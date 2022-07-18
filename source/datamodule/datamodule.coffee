############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("datamodule")
#endregion

############################################################
import { requestSharesURL } from "./configmodule.js"
import { sampleResponse } from "./sampledata.js"

import dayjs from "dayjs"


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
    #     "shareId": 0,
    #     "modality": "string",
    #     "fullName": "string",
    #     "ssn": "string",
    #     "dob": "string",
    #     "minDate": "string",
    #     "maxDate": "string",
    #     "page": 0,
    #     "pageSize": 0
    # }
    try
        minDate = dayjs().subtract(dayCount, "day")
        requestData = {minDate}
        rawData = await postRequest(requestSharesURL, requestData)
        return rawData.shares.sort(defaultSharesCompare)
    catch err 
        log err
        return []




