############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("overviewtablemodule")
#endregion

############################################################
import { Grid, html} from "gridjs"
import dayjs from "dayjs"
# import { de } from "dayjs/locales"

############################################################
import { retrieveData } from "./datamodule.js"

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

entryBaseURL = "https://www.bilder-befunde.at/webview/index.php?value_dfpk="

## datamodel 
# | Bilder Button | Befunde Button | Untersuchungsdatum | Patienten Name (Fullname) | SSN (4 digits) | Geb.Datum | Untersuchungsbezeichnung | Radiologie | Zeitstempel (Datum + Uhrzeit) |

############################################################
export initialize = ->
    log "initialize"
    chooseDateLimit.addEventListener("change", dateLimitChanged)
    renderTable(retrieveData(30))
    # renderTable([])
    return

############################################################
export renderTable = (dataPromise) ->
    # log "renderTable"
    headerObject = getHeaderObject()
    searchObject = getSearchObject()
    paginationObject = getPaginationObject()
    # serverObject =  getServerObject()

    gridJSOptions = {
        columns: headerObject
        data: -> dataPromise,
        # server: serverObject,
        search: searchObject,
        pagination: paginationObject,
        sort: {
            multiColumn: false
        },
        language: deDE,
        fixedHeader: true,
        resizable: true,
        height: "calc(100vh - 120px)"
        width: "100%"
        className: {
            td: 'table-cell',
            table: 'c-table'
        }
    }

    tableObj = new Grid(gridJSOptions)
    gridjsFrame.innerHTML = ""
    tableObj.render(gridjsFrame)
    return

updateTable = (dataPromise) ->
    # log "updateTable"
    tableObj.updateConfig({data: -> dataPromise})
    tableObj.forceRender()
    return

dateLimitChanged = ->
    # log "dateLimitChanged"
    # log chooseDateLimit.value
    switch chooseDateLimit.value
        when "1" then retrieveAndRenderData(30)
        when "2" then retrieveAndRenderData(90)
        when "3" then retrieveAndRenderData(180)
        else log "unknown value: "+chooseDateLimit.value
    return

retrieveAndRenderData = (dayCount) -> updateTable(retrieveData(dayCount))

############################################################
#region sort functions
dateCompare = (el1, el2) ->
    # date1 = dayjs(el1)
    # date2 = dayjs(el2)
    # return -date1.diff(date2)
    
    # here we already expect a dayjs object
    diff = el1.diff(el2)
    if diff > 0 then return 1
    if diff < 0 then return -1
    return 0

numberCompare = (el1, el2) ->
    number1 = parseInt(el1, 10)
    number2 = parseInt(el2, 10)

    if number1 > number2 then return 1
    if number2 > number1 then return -1
    return 0
    # log number1 - number2
    # return number1 - number2

#endregion

############################################################
#region get optionObjects for GridJS
getHeaderObject = ->
    
    bilderHeadObj = {
        name: ""
        id: "format"
        formatter: bilderFormatter
        sort: false
    }
    befundeHeadObj = {
        name: ""
        id: "format"
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
        id: "DateCreated"
        formatter: sendingDateFormatter
        sort: { compare: dateCompare }
    }

    return [bilderHeadObj, befundeHeadObj, screeningDateHeadObj, nameHeadObj, svnHeadObj, birthdayHeadObj, descriptionHeadObj, radiologistHeadObj, sendingDateHeadObj]

getSearchObject = ->
    return true

# getServerObject = ->
#     return {
#         url: requestSharesURL,
#         data: (options) -> return new Promise (resolve, reject) ->
#             try
#                 response = await postData(options.url, options.parameter)
#                 data = response.shares
#                 total = response.total_user_count
#                 resolve({data, total})
#             catch err then reject(err)
#     }

getPaginationObject = ->
    # TODO retriev currently chosen limit
    return { limit: 50 }

#endregion

############################################################
#region cell formatter functions
bilderFormatter  = (content, row) ->
    formatObj = {
            content: '<svg><use href="#svg-images-icon" /></svg>'
            className: 'bild-button click-button',
            onClick: ->
                olog row 
                log("Bilder Button clicked! @#{row.id}")
          }

    # return h('button', formatObj, '<svg><use href="#svg-images-icon" /></svg>')
    # return h('button', formatObj, 'B')
    # return h(HTMLElement, formatObj)
    # olog content

    # if content.hasImage? and content.documentFormatPk? then innerHTML = '<a href="'+entryBaseURL+content.documentFormatPk+'" class="bild-button" target="_blank" ><svg row-id="'+row.id+'" ><use href="#svg-images-icon" /></svg></a>'
    if content.hasImage? then innerHTML = '<a href="'+entryBaseURL+content.documentFormatPk+'" class="bild-button" target="_blank" ><svg row-id="'+row.id+'" ><use href="#svg-images-icon" /></svg></a>'
    else innerHTML = '<div disabled class="bild-button" ><svg row-id="'+row.id+'" ><use href="#svg-images-icon" /></svg></div>'
    return html(innerHTML)

befundeFormatter = (content , row) ->
    formatObj = {
            className: 'befund-button click-button',
            onClick: ->
                olog row
                log("Befunde Button clicked! @#{row.id}")
          }
    # return h('button', formatObj, '<svg><use href="#svg-documents-icon" /></svg>')
    # return h('button', formatObj, 'BF')
    # olog content

    # if content.hasBefund? and content.documentFormatPk? then innerHTML = '<a href="'+entryBaseURL+content.documentFormatPk+'" class="befund-button" ><svg row-id="'+row.id+'" ><use href="#svg-documents-icon" /></svg></a>'
    if content.hasBefund? then innerHTML = '<a href="'+entryBaseURL+content.documentFormatPk+'" class="befund-button" ><svg row-id="'+row.id+'" ><use href="#svg-documents-icon" /></svg></a>'
    else innerHTML = '<div disabled class="befund-button" ><svg row-id="'+row.id+'" ><use href="#svg-documents-icon" /></svg></div>'
    return html(innerHTML)

screeningDateFormatter = (content, row) ->
    # date = dayjs(content)
    # return date.format("DD.MM.YYYY")

    #here we expect to already get a dayjs object
    return content.format("DD.MM.YYYY")

nameFormatter = (content, row) ->
    return content

svnFormatter = (content, row) ->
    return content

birthdayFormatter = (content, row) ->
    # date = dayjs(content)
    # return date.format("DD.MM.YYYY")

    #here we expect to already get a dayjs object
    return content.format("DD.MM.YYYY")

descriptionFormatter = (content, row) ->
    return content

radiologistFormatter = (content, row) ->
    return content

sendingDateFormatter = (content, row) ->
    # date = dayjs(content)
    # return date.format("YYYY-MM-DD hh:mm")

    #here we expect to already get a dayjs object
    return content.format("DD.MM.YYYY hh:mm")


#endregion
