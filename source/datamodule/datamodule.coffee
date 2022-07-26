############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("datamodule")
#endregion

############################################################
import dayjs from "dayjs"

############################################################
import { requestSharesURL } from "./configmodule.js"
import { sampleData } from "./sampledata.js"

import { dataLoadPageSize } from "./configmodule.js"

MedCaseToEntry = {}


############################################################
#region merge Properties Functions
mergeCaseDate = (obj, share) ->
    current = obj.CaseDate
    niu = dayjs(share.CaseDate)
    if !current? then return niu

    # use the newer date
    diff = current.diff(niu)
    if diff < 0 then return niu
    else return current

mergePatientFullname = (obj, share) ->
    current = obj.PatientFullname
    niu = share.PatientFullname
    if !current? then return niu
    
    # just checking if everything is in order
    if current != niu then log "PatientFullname not matching at @MedCasePk "+share.MedCasePk+". "+current+" vs "+niu
    
    return current

mergePatientSsn = (obj, share) ->
    current = obj.PatientSsn
    niu = share.PatientSsn
    if !current? then return niu

    # just checking if everything is in order
    if current != niu then log "PatientSsn not matching at @MedCasePk "+share.MedCasePk+". "+current+" vs "+niu

    return current

mergePatientDob = (obj, share) ->
    current = obj.PatientDob
    niu = dayjs(share.PatientDob)
    if !current? then return niu

    # just checking if everything is in order
    if current.diff(niu) != 0 then log "PatientDob not matching at @MedCasePk "+share.MedCasePk+". "+current+" vs "+niu

    return current

mergeCaseDescription = (obj, share) ->
    current = obj.CaseDescription
    niu = share.CaseDescription
    if !current? then return niu

    merged = current + " |\n\n" + niu
    return merged

mergeCreatedBy = (obj, share) ->
    current = obj.CreatedBy
    niu = share.CreatedBy
    if !current? then return niu

    merged = current + " |\n\n" + niu
    return merged

mergeDateCreated = (obj, share) ->
    current = obj.DateCreated
    niu = dayjs(share.DateCreated)
    if !current? then return niu

    #use the newer date
    diff = current.diff(niu)
    if diff < 0 then return niu
    else return current

mergeFormat = (obj, share) ->
    result = obj.format
    result = {} unless result?

    if share.FormatTypeMt == 4 then result.hasImage = true
    else if share.FormatTypeMt != 2 and share.FormatTypeMt < 10 and share.FormatTypeMt > 0 then result.hasBefund = true

    if share.documentFormatPk then result.documentFormatPk = share.documentFormatPk 

    return result

#endregion


############################################################
groupByMedCase = (data) ->
    before = performance.now()
    for d in data
        entry = {}
        entry[d.SharePk] = d
        oldEntry = MedCaseToEntry[d.MedCasePk] 
        MedCaseToEntry[d.MedCasePk] = Object.assign(entry, oldEntry)
    
    results = []
    for key,entry of MedCaseToEntry
        obj = {}
        for sharePk,share of entry
            obj.CaseDate = mergeCaseDate(obj, share)
            obj.PatientFullname = mergePatientFullname(obj, share)
            obj.PatientSsn = mergePatientSsn(obj, share)
            obj.PatientDob = mergePatientDob(obj, share)
            obj.CaseDescription = mergeCaseDescription(obj, share)
            obj.CreatedBy = mergeCreatedBy(obj, share)
            obj.DateCreated = mergeDateCreated(obj, share)
            obj.format = mergeFormat(obj, share)
        results.push(obj)

    after = performance.now()
    diff = after - before
    log "mapping took: "+diff+"ms"
    
    return results

############################################################
defaultSharesCompare = (el1, el2) ->
    date1 = dayjs(el1.DateCreated)
    date2 = dayjs(el2.DateCreated)
    return -date1.diff(date2)

############################################################
postRequest = (url, data) ->
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
export retrieveData = (dayCount) ->
    log "retrieveData"
    # return new Promise (resolve) ->
    #     returnShares = -> resolve(sampleResponse.shares) 
    #     setTimeout(returnShares, 5000)

    # {
    #     "SharePk": 100012348,
    #     "OrgPersonPkTo": 9,
    #     "OrgPersonPkFrom": 7,
    #     "OrgPersonPkPatient": 100002428,
    #     "PatientFullname": "Kira Nussbeck",
    #     "DocumentFormatPk": 0,
    #     "FormatTypeMt": 0,
    #     "CaseDate": "2022-02-17T07:09:00",
    #     "DateCreated": "2022-07-18T23:02:05",
    #     "CreatedBy": "Karl",
    #     "DateModified": "2022-07-18T23:02:05",
    #     "ModifiedBy": "Lenny",
    #     "Status1": 0,
    #     "Status2": 0,
    #     "SessionKeyAenc": "",
    #     "Sequence": 0,
    #     "SignatureFrom": "",
    #     "Remark": "",
    #     "DownloadStart": "2022-07-18T23:02:05",
    #     "DownloadEnd": "2022-07-18T23:02:05",
    #     "DocumentPk": 0,
    #     "MedCasePk": 100004884,
    #     "PriorityMt": 1,
    #     "Percentage": 0,
    #     "PatientSsn": "1296050503",
    #     "PatientDob": "2022-07-18T00:00:00",
    #     "CaseDescription": "CT"
    # }


    try
        minDate = dayjs().subtract(dayCount, "day")
        pageSize = dataLoadPageSize
        page = 1
        
        receivedCount = 0
        allData = []

        loop
            requestData = {minDate, page, pageSize}
            log "requesting -> "
            olog requestData

            rawData = await postRequest(requestSharesURL, requestData)
            allData.push(rawData.shares)
            receivedCount += rawData.current_shares_count
            if receivedCount == rawData.total_shares_count then break
            if receivedCount <  pageSize then break
            page++
        
        allData = groupByMedCase(allData.flat())

        return allData.sort(defaultSharesCompare)
    catch err 
        log err
        allData = groupByMedCase(sampleData)
        return allData.sort(defaultSharesCompare)




