############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("datautils")
#endregion

############################################################
import dayjs from "dayjs"

############################################################
import { requestSharesURL } from "./configmodule.js"
import { sampleData } from "./sampledata.js"
## TODO introduce more sampleData e.g. patientSampleData

import { dataLoadPageSize } from "./configmodule.js"

############################################################
StudyToEntry = {}

############################################################
#region merge Properties Functions
mergeIsNew = (obj, share) ->
    return true if obj.isNew
    return true if share.isNew or share.isNew == "true"
    return false

mergeStudyDate = (obj, share) ->
    current = obj.studyDate
    niu = dayjs(share.studyDate)
    if !current? then return niu

    # use the newer date
    diff = current.diff(niu)
    if diff < 0 then return niu
    else return current

mergePatientFullname = (obj, share) ->
    current = obj.patientFullName
    niu = share.patientFullName
    if !current? then return niu
    
    # just checking if everything is in order
    if current != niu then log "patientFullName not matching at @studyId "+share.studyId+". "+current+" vs "+niu
    
    return current

mergePatientSsn = (obj, share) ->
    current = obj.patientSsn
    niu = share.patientSsn
    if !current? then return niu

    # just checking if everything is in order
    if current != niu then log "patientSsn not matching at @studyId "+share.studyId+". "+current+" vs "+niu

    return current

mergePatientDob = (obj, share) ->
    current = obj.patientDob
    niu = dayjs(share.patientDob)
    if !current? then return niu

    # just checking if everything is in order
    if current.diff(niu) != 0 then log "patientDob not matching at @studyId "+share.studyId+". "+current+" vs "+niu

    return current

mergeStudyDescription = (obj, share) ->
    current = obj.studyDescription
    niu = share.studyDescription
    if !current? then return niu

    merged = current + " |\n\n" + niu
    return merged

mergeCreatedBy = (obj, share) ->
    current = obj.fromFullName
    niu = share.fromFullName
    if !current? then return niu
    else return current
    # merged = current + " |\n\n" + niu
    # return merged

mergeDateCreated = (obj, share) ->
    current = obj.createdAt
    niu = dayjs(share.createdAt)
    if !current? then return niu

    #use the newer date
    diff = current.diff(niu)
    if diff < 0 then return niu
    else return current

mergeDocuments = (obj, share) ->
    result = obj.documents
    result = {} unless result?
    return result unless share.documentUrl?

    if share.formatType == 4
        result.images = [] unless result.images?
        image = {
            url: share.documentUrl, 
            description: share.documentDescription
        }
        result.images.push(image)
    else 
        result.befunde = [] unless result.befunde?
        befund = {
            url: share.documentUrl, 
            description: share.documentDescription
        }
        result.befunde.push(befund)

    ## This is a more detailed check if the document is a Befund...
    # else if share.formatType != 2 and share.formatType < 10 and share.formatType > 0 

    return result

#endregion

############################################################
defaultSharesCompare = (el1, el2) ->
    date1 = dayjs(el1.createdAt)
    date2 = dayjs(el2.createdAt)
    return -date1.diff(date2)

############################################################
groudByStudyId = (data) ->
    ## TODO improve caching of Cases
    ## Because maybe the next cases added would fit to a previous case

    StudyToEntry = {}

    before = performance.now()
    for d in data
        entry = {}
        entry[d.shareId] = d
        oldEntry = StudyToEntry[d.studyId]
        StudyToEntry[d.studyId] = Object.assign(entry, oldEntry)
    
    results = []
    for key,entry of StudyToEntry
        obj = {}
        for shareId,share of entry
            obj.isNew = mergeIsNew(obj, share)
            obj.studyDate = mergeStudyDate(obj, share)
            obj.patientFullName = mergePatientFullname(obj, share)
            obj.patientSsn = mergePatientSsn(obj, share)
            obj.patientDob = mergePatientDob(obj, share)
            # obj.studyDescription = mergeStudyDescription(obj, share)
            obj.fromFullName = mergeCreatedBy(obj, share)
            obj.createdAt = mergeDateCreated(obj, share)
            obj.documents = mergeDocuments(obj,share)
            obj.select = false
            obj.studyId = key
            obj.index = results.length
        results.push(obj)

    after = performance.now()
    diff = after - before
    log "mapping took: "+diff+"ms"
    
    return results

############################################################
export groupAndSort = (rawData) ->
    allData = groudByStudyId(rawData.flat())
    return allData.sort(defaultSharesCompare)

export prepareDoctorsList = (rawData) ->
    results = []
    for d in rawData
        obj = {}
        obj.index = results.length
        obj.doctorName = d
        results.push(obj)
    return results
    
############################################################
export postRequest = (url, data) ->
    options =
        method: 'POST'
        mode: 'cors'
        credentials: 'include'

        body: JSON.stringify(data)
        headers:
            'Content-Type': 'application/json'

    try
        response = await fetch(url, options)
        if !response.ok then throw new Error("Response not ok - status: "+response.status+"!")
        return response.json()
    catch err then throw new Error("Network Error: "+err.message)


############################################################
export mergeDataSets = (oldData, newData) ->
    log "mergeDataSets"
    results = []
    for d in newData
        results.push(d)
        d.index = results.length
    for d in oldData
        results.push(d)
        d.index = results.length

    ## TODO implement more sophisticatedly
    # we neglect here the situation when we have the same studyId 
    return results

