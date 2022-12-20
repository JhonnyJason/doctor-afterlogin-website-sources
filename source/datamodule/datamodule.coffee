############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("datamodule")
#endregion

############################################################
import dayjs from "dayjs"

############################################################
import * as utl from "./datautils.js"
import * as S from "./statemodule.js"

############################################################
import { requestSharesURL } from "./configmodule.js"
import { ownSampleData, patientSampleData, doctorsSampleData } from "./sampledata.js"

import { dataLoadPageSize } from "./configmodule.js"

############################################################
daysLimit = null
patientAuth = null

############################################################
ownDataPromise = null
patientDataPromise = null

############################################################
dataToShare = null

############################################################
export initialize = ->
    log "initialize"
    daysLimit = S.load("daysLimit")
    if !daysLimit
        daysLimit = 30
        S.save("daysLimit", 30)
    return

############################################################
#region dataRetrieval
retrieveOwnData = (dayCount) ->
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

            rawData = await utl.postRequest(requestSharesURL, requestData)
            allData.push(rawData.shares)
            receivedCount += rawData.current_shares_count
            if receivedCount == rawData.total_shares_count then break
            if receivedCount <  pageSize then break
            page++
        
        return utl.groupAndSort(allData)

    catch err
        log err
        return utl.groupAndSort(ownSampleData)

############################################################
retrievePatientData = (daysCount) ->
    log "retrievePatientData"
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
        ## TODO figure out how the request is being formed
        # minDate = dayjs().subtract(dayCount, "day")
        # pageSize = dataLoadPageSize
        # page = 1
        
        # receivedCount = 0
        # allData = []

        # loop
        #     requestData = {minDate, page, pageSize}
        #     log "requesting -> "
        #     olog requestData

        #     rawData = await utl.postRequest(requestSharesURL, requestData)
        #     allData.push(rawData.shares)
        #     receivedCount += rawData.current_shares_count
        #     if receivedCount == rawData.total_shares_count then break
        #     if receivedCount <  pageSize then break
        #     page++
        
        # return utl.groupAndSort(allData)

        throw new Error("Not implemented yet!")
    catch err
        log err
        return utl.groupAndSort(patientSampleData)

############################################################
retrieveDoctors = ->
    log "retrieveDoctors"
    ##TODO figure out the format of the response
    try
        ## TODO figure out how the request is being formed
        # minDate = dayjs().subtract(dayCount, "day")
        # pageSize = dataLoadPageSize
        # page = 1
        
        # receivedCount = 0
        # allData = []

        # loop
        #     requestData = {minDate, page, pageSize}
        #     log "requesting -> "
        #     olog requestData

        #     rawData = await utl.postRequest(requestSharesURL, requestData)
        #     allData.push(rawData.shares)
        #     receivedCount += rawData.current_shares_count
        #     if receivedCount == rawData.total_shares_count then break
        #     if receivedCount <  pageSize then break
        #     page++
        
        # return utl.groupAndSort(allData)

        throw new Error("Not implemented yet!")
    catch err
        log err
        return utl.prepareDoctorsList(doctorsSampleData)

############################################################
shareToDoctor = (data, doctor) ->
    log "shareToDoctor"
    log "not implementedYet!"
    return

#endregion

############################################################
export changeDaysLimit = (daysCount) ->
    daysLimit = daysCount
    S.save("daysLimit", daysLimit)

    ownDataPromise = null
    patientDataPromise = null
    doctorsList = null
    return

############################################################
export getOwnData = ->
    if !ownDataPromise? then ownDataPromise = retrieveOwnData(daysLimit)
    return ownDataPromise

############################################################
export loadPatientData = (patientAuthBody) ->
    log "loadPatientData"
    patientAuth = patientAuthBody
    patientDataPromise = retrievePatientData(daysLimit)
    await patientDataPromise
    ## here we should wait for the request to be successful
    # this is because we only want to proceed if the autData is valid
    # we would only know this from this request succeeding
    return

export clearPatientData = ->
    log "clearPatientData"
    patientAuth = null
    patientDataPromise = null
    return

export getPatientData = ->
    log "getPatientData"
    if !patientDataPromise? then patientDataPromise = retrievePatientData(daysLimit)
    return patientDataPromise

############################################################
export getDoctorList = ->
    log "getDoctorList"
    return retrieveDoctors()

############################################################
export addToOwnData = (newData) ->
    log "addToOwnData"
    if ownDataPromise? then ownDataPromise = utl.mergeDataSets((await ownDataPromise), newData)
    # olog { ownDataPromise }
    return


############################################################
export setShareData = (data) ->
    dataToShare = data
    return

export clearShareData = ->
    dataToShare = null
    return

export shareToDoctors = (doctors) ->
    log "shareToDoctors"
    for doctor in doctors
        shareToDoctor(dataToShare, doctor)
    return