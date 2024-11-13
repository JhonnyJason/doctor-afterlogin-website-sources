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
minDate = null
minDateFormatted  = null
patientAuth = null

############################################################
ownDataPromise = null
patientDataPromise = null

############################################################
dataToShare = null

############################################################
#region dataRetrieval
retrieveData = (minDate) ->
    log "retrieveData"
    try
        pageSize = dataLoadPageSize
        page = 1
        
        receivedCount = 0
        allData = []

        loop
            requestData = {minDate, page, pageSize}
            log "requesting -> "
            olog requestData

            rawData = await utl.postRequest(requestSharesURL, requestData)
            allData.push(rawData.shareSummary)
            # receivedCount = allData.length  
            receivedCount += rawData.currentSharesCount
            if receivedCount == rawData.totalSharesCount then break
            if receivedCount <  pageSize then break
            page++
        
        return utl.groupAndSort(allData)

    catch err
        log err
        return utl.groupAndSort(ownSampleData)

#endregion

############################################################
export setMinDateDaysBack = (daysCount) ->
    log "setMinDateDaysBack"
    dateObj = dayjs().subtract(daysCount, "day")
    minDate = dateObj.toJSON()
    minDateFormatted = dateObj.format("DD.MM.YYYY")

    ownDataPromise = null
    return

export setMinDateMonthsBack = (monthsCount) ->
    log "setMinDateMonthsBack"
    dateObj = dayjs().subtract(monthsCount, "month")
    minDate = dateObj.toJSON()
    minDateFormatted = dateObj.format("DD.MM.YYYY")

    ownDataPromise = null
    return


export setMinDateYearsBack = (yearsCount) ->
    log "setMinDateYearsBack"
    dateObj = dayjs().subtract(yearsCount, "year")
    minDate = dateObj.toJSON()
    minDateFormatted = dateObj.format("DD.MM.YYYY")

    ownDataPromise = null
    return

############################################################
export getOwnData = ->
    if !ownDataPromise? then ownDataPromise = retrieveData(minDate)
    return ownDataPromise

############################################################
export addToOwnData = (newData) ->
    log "addToOwnData"
    if ownDataPromise? then ownDataPromise = utl.mergeDataSets((await ownDataPromise), newData)
    # olog { ownDataPromise }
    return

export getMinDate = -> minDateFormatted

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