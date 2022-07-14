############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("overviewtablemodule")
#endregion

############################################################
import { Grid, h } from "gridjs"
import dayjs from "dayjs"
# import { de } from "dayjs/locales"

############################################################
import { requestSharesURL } from "./configmodule.js"
import { sharesResponse } from "./sampledata.js"

############################################################
#region germanLanguage
deDE = {
    search: {
        placeholder: 'Suche...'
    }
    sort: {
        sortAsc: 'Spalte aufsteigend sortieren'
        sortDesc: 'Spalte absteigend sortieren'
    }
    pagination: {
        previous: 'Bisherige'
        next: 'Nächste'
        navigate: (page, pages) -> "Seite #{page} von #{pages}"
        page: (page) -> "Seite #{page}"
        showing: 'Anzeigen'
        of: 'von'
        to: 'zu'
        results: 'Ergebnisse'
    }
    loading: 'Wird geladen...'
    noRecordsFound: 'Keine übereinstimmenden Aufzeichnungen gefunden'
    error: 'Beim Abrufen der Daten ist ein Fehler aufgetreten'
}  
#endregion

############################################################
tableObj = null


## datamodel 
# | Bilder Button | Befunde Button | Untersuchungsdatum | Patienten Name (Fullname) | SSN (4 digits) | Geb.Datum | Untersuchungsbezeichnung | Radiologie | Zeitstempel (Datum + Uhrzeit) |

############################################################
loginButtonClicked = ->
    username = nameInput.value
    hashedPwd = passwordHashInput.value
    try
        loginResult = await demoLogin(username, hashedPwd)
        olog { loginResult }
        whoamiResult = await checkWhoAmI()
        olog { whoamiResult }
        data = await getData(0, 1000)
        olog { data }

    catch err
        log "error occured!"
        log err
    
    return


demoLogin = (username, hashedPw) ->
    url = "https://extern.bilder-befunde.at/caasdemo/api/v1/auth/login"
    data = {
        username,
        hashedPw,
        isMedic: true,
        rememberMe: true
    }

    return postData(url, data)

checkWhoAmI = ->
    url = "https://extern.bilder-befunde.at/caasdemo/api/v1/auth/whoami"
    options =
        method: 'GET'
        mode: 'cors'
        credentials: 'include'
    
    try
        response = await fetch(url, options)
        if !response.ok then throw new Error("Response not ok - status: "+response.status+"!")
        return response.json()
    catch err then throw new Error("Network Error: "+err.message)


############################################################
export initialize = ->
    log "initialize"
    #for demologin and whole connection testing
    loginButton.addEventListener("click", loginButtonClicked)

    renderTable()
    
    #Implement or Remove :-)
    return

############################################################
renderTable = ->
    headerObject = getHeaderObject()
    searchObject = getSearchObject()
    paginationObject = getPaginationObject()
    serverObject =  getServerObject()

    dataArray = sharesResponse.shares.sort(defaultSharesCompare)

    gridJSOptions = {
        columns: headerObject
        data: dataArray,
        # server: serverObject,
        search: searchObject,
        pagination: paginationObject,
        sort: true,
        language: deDE,
        fixedHeader: true,
        height: "70vh"
    }
    tableObj = new Grid(gridJSOptions)
    # gridjsFrame.
    tableObj.render(gridjsFrame)
    return

############################################################
#region sort functions
dateCompare = (el1, el2) ->
    date1 = dayjs(el1)
    date2 = dayjs(el2)
    return -date1.diff(date2)

numberCompare = (el1, el2) ->
    # todo
    return

defaultSharesCompare = (el1, el2) ->
    date1 = dayjs(el1.DateModified)
    date2 = dayjs(el2.DateModified)
    return -date1.diff(date2)
#endregion

############################################################
#region get optionObjects for GridJS
getHeaderObject = ->
     
    bilderHeadObj = {
        name: ""
        id: "bilder-button"
        formatter: bilderFormatter
        sort: false
    }
    befundeHeadObj = {
        name: ""
        id: "befunde-button"
        formatter: befundeFormatter
        sort: false
    }
    screeningDateHeadObj = {
        name: "Unt.-Datum"
        id: "CaseDate"
        formatter: screeningDateFormatter
        sort: { compare: dateCompare }
    }
    nameHeadObj = {
        name: "Name"
        id: "PatientFullname"
        formatter: nameFormatter
    }
    svnHeadObj = {
        name: "SVN"
        id: "PatientSsn"
        formatter: svnFormatter
        sort: {compare: numberCompare}
    }
    birthdayHeadObj = {
        name: "Geb.-Datum"
        id: "PatientDob"
        formatter: birthdayFormatter
        sort:{ compare: dateCompare }
    }
    descriptionHeadObj = {
        name:"Beschreibung"
        id: "CaseDescription"
        formatter: descriptionFormatter
    }
    radiologistHeadObj = {
        name: "Radiologie"
        id: "CreatedBy"
        formatter: radiologistFormatter
    }
    sendingDateHeadObj = {
        name: "Zustellungsdatum"
        id: "DateModified"
        formatter: sendingDateFormatter
        sort: { compare: dateCompare }
    }

    return [bilderHeadObj, befundeHeadObj, screeningDateHeadObj, nameHeadObj, svnHeadObj, birthdayHeadObj, descriptionHeadObj, radiologistHeadObj, sendingDateHeadObj]

getSearchObject = ->
    return true

getServerObject = ->
    return {
        url: requestSharesURL,
        data: (options) -> return new Promise (resolve, reject) ->
            try
                response = await postData(options.url, options.parameter)
                data = response.shares
                total = response.total_user_count
                resolve({data, total})
            catch err then reject(err)
    }

getPaginationObject = ->
    # TODO retriev currently chosen limit
    return { limit: 50 }

#endregion

############################################################
#region cell formatter functions
bilderFormatter  = (content, row) ->
    formatObj = {
            className: 'bild-buttom click-button',
            onClick: ->
                olog row 
                log("Bilder Button clicked! @#{row.id}")
          }
    return h('button', formatObj, 'Bilder')

befundeFormatter = (content , row) ->
    formatObj = {
            className: 'befund-buttom click-button',
            onClick: ->
                olog row
                log("Befunde Button clicked! @#{row.id}")
          }
    return h('button', formatObj, 'Befunde')

screeningDateFormatter = (content, row) ->
    date = dayjs(content)
    return date.format("DD.MM.YYYY")

nameFormatter = (content, row) ->
    return content

svnFormatter = (content, row) ->
    return content

birthdayFormatter = (content, row) ->
    date = dayjs(content)
    return date.format("DD.MM.YYYY")

descriptionFormatter = (content, row) ->
    return content

radiologistFormatter = (content, row) ->
    return content

sendingDateFormatter = (content, row) ->
    date = dayjs(content)
    return date.format("YYYY-MM-DD hh:mm")

#endregion

############################################################
postData = (url, data) ->
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



getData = (page, pageSize) ->
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

    requestData = {page, pageSize}
    return postData(dataURL, requestData)