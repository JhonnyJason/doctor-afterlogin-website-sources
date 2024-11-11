############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("tableutils")
#endregion

############################################################
import { Grid, html} from "gridjs"
# import { RowSelection } from "gridjs/plugins/selection"
# import { RowSelection } from "gridjs-selection"

import dayjs from "dayjs"
# import { de } from "dayjs/locales"

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
        previous: 'Vorherige'
        next: 'Nächste'
        navigate: (page, pages) -> "Seite #{page} von #{pages}"
        page: (page) -> "Seite #{page}"
        showing: ' '
        of: 'von'
        to: '-'
        results: 'Daten'
    }
    loading: 'Wird geladen...'
    noRecordsFound: 'Keine übereinstimmenden Aufzeichnungen gefunden'
    error: 'Beim Abrufen der Daten ist ein Fehler aufgetreten'
}

deDEPatientApproval = {
    search: {
        placeholder: 'Suche...'
    }
    sort: {
        sortAsc: 'Spalte aufsteigend sortieren'
        sortDesc: 'Spalte absteigend sortieren'
    }
    pagination: {
        previous: 'Vorherige'
        next: 'Nächste'
        navigate: (page, pages) -> "Seite #{page} von #{pages}"
        page: (page) -> "Seite #{page}"
        showing: ' '
        of: 'von'
        to: '-'
        results: 'Daten'
    }
    loading: 'Wird geladen...'
    noRecordsFound: 'Geben Sie die Authentifizierungsdaten für den Patienten ein.'
    error: 'Beim Abrufen der Daten ist ein Fehler aufgetreten'
}
#endregion

############################################################
entryBaseURL = "https://www.bilder-befunde.at/webview/index.php?value_dfpk="
messageTarget = null

## datamodel default entry
# | Bilder Button | Befunde Button | Untersuchungsdatum | Patienten Name (Fullname) | SSN (4 digits) | Geb.Datum | Untersuchungsbezeichnung | Radiologie | Zeitstempel (Datum + Uhrzeit) |

## datamodel checkbox entry
# | checkbox | hidden index | Untersuchungsdatum | Patienten Name (Fullname) | SSN (4 digits) | Geb.Datum | Untersuchungsbezeichnung | Radiologie | Zeitstempel (Datum + Uhrzeit) |

## datamodel doctor selection entry
# | checkbox | doctorName | 

############################################################
#region internalFunctions

############################################################
onLinkClick = (el) ->
    evnt = window.event
    # console.log("I got called!")
    # console.log(evnt)
    evnt.preventDefault()
    ## TODO send right message
    href = el.getAttribute("href")
    ## TODO send right message
    # window.open("mainwindow.html", messageTarget.name)
    if messageTarget.closed then messageTarget = window.open("mainwindow.html", messageTarget.name)
    else window.open("", messageTarget.name)
    messageTarget.postMessage(href)
    # messageTarget.focus()
    # window.blur()
    return

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
#region cell formatter functions
isNewFormatter = (content, row) ->
    dotClass = "isNewDot"
    
    if content then dotClass = "isNewDot isNew" 

    innerHTML = "<div class='#{dotClass}'></div>"
    return  html(innerHTML)

doctorNameFormatter = (content, row) ->
    if row._cells[0].data then return html("<b>#{content}</b>")
    else return content

bilderFormatter  = (content, row) ->
    return "" unless content?
    innerHTML = "<ul class='bilder'>"
    for image in content
        if image.isNew
            innerHTML += "<li><b><a href='#{image.url}'> #{image.description}</a></b></li>"
        else
            innerHTML += "<li><a href='#{image.url}'> #{image.description}</a></li>"
        
    innerHTML += "</ul>"
    
    return html(innerHTML)

    # if row._cells[0].data then return html("<b>#{innerHTML}</b>")
    # else return html(innerHTML) 

befundeFormatter = (content , row) ->
    return "" unless content?

    innerHTML = "<ul class='befunde'>"
    for befund in content
        if befund.isNew
            innerHTML += "<li><b><a href='#{befund.url}'> #{befund.description}</a></b></li>"
        else
            innerHTML += "<li><a href='#{befund.url}'> #{befund.description}</a></li>"

    innerHTML += "</ul>"

    return html(innerHTML)
    # if row._cells[0].data then return html("<b>#{innerHTML}</b>")
    # else return html(innerHTML) 

    # formatObj = {
    #         className: 'befund-button click-button',
    #         onClick: ->
    #             olog row
    #             log("Befunde Button clicked! @#{row.id}")
    #       }
    # # return h('button', formatObj, '<svg><use href="#svg-documents-icon" /></svg>')
    # # return h('button', formatObj, 'BF')
    # # olog content

    # # if content.hasBefund? and content.documentFormatPk? then innerHTML = '<a href="'+entryBaseURL+content.documentFormatPk+'" class="befund-button" ><svg row-id="'+row.id+'" ><use href="#svg-documents-icon" /></svg></a>'

    # if content.hasBefund?
    #     if messageTarget? innerHTML = '<a onClick="onLinkClick(this);" href="'+content.befundURL+'" class="befund-button" ><svg row-id="'+row.id+'" ><use href="#svg-documents-icon" /></svg></a>'
    #     else innerHTML = '<a href="'+content.befundURL+'" class="befund-button" ><svg row-id="'+row.id+'" ><use href="#svg-documents-icon" /></svg></a>'
    # else innerHTML = '<div disabled class="befund-button" ><svg row-id="'+row.id+'" ><use href="#svg-documents-icon" /></svg></div>'
    # return html(innerHTML)

screeningDateFormatter = (content, row) ->
    return content.format("DD.MM.YYYY")
    # date = dayjs(content)
    # return date.format("DD.MM.YYYY")

    #here we expect to already get a dayjs object
    # dateString = content.format("DD.MM.YYYY")
    # if row._cells[0].data then return html("<b>#{dateString}</b>")
    # else return dateString 

nameFormatter = (content, row) ->
    linkHTML = """
        <a onclick='gridSearchByString("#{content}")'>#{content}</a>
    """
    if row._cells[0].data then return html("<b>#{linkHTML}</b>")
    else return html(linkHTML)

svnFormatter = (content, row) ->
    return content
    # linkHTML = """
    #     <a onclick='gridSearchByString("#{content}")'>#{content}</a>
    # """
    # if row._cells[0].data then return html("<b>#{linkHTML}</b>")
    # else return html(linkHTML)

birthdayFormatter = (content, row) ->
    # date = dayjs(content)
    # return date.format("DD.MM.YYYY")

    #here we expect to already get a dayjs object
    if typeof content == "object" 
        dateString = content.format("DD.MM.YYYY")
        return dateString
        # if row._cells[0].data then return html("<b>#{dateString}</b>")
        # else return dateString
    else return content
        # linkHTML = """
        #     <a onclick='gridSearchByString("#{content}")'>#{content}</a>
        # """
        # if row._cells[0].data then return html("<b>#{linkHTML}</b>")
        # else return html(linkHTML)
            


descriptionFormatter = (content, row) ->
    if row._cells[0].data then return html("<b>#{content}</b>")
    else return content

radiologistFormatter = (content, row) ->
    return content
    # if row._cells[0].data then return html("<b>#{content}</b>")
    # else return content

sendingDateFormatter = (content, row) ->
    # date = dayjs(content)
    # return date.format("YYYY-MM-DD hh:mm")

    #here we expect to already get a dayjs object
    dateString = content.format("DD.MM.YYYY HH:mm")
    if row._cells[0].data then return html("<b>#{dateString}</b>")
    else return dateString 

#endregion

#endregion

############################################################
#region exportedFunctions
export getTableHeight = (state) ->
    log "getTableHeight"
    ## TODO check if we need to differentiate between states here

    tableWrapper = document.getElementsByClassName("gridjs-wrapper")[0]
    gridJSFooter = document.getElementsByClassName("gridjs-footer")[0]
    
    fullHeight = window.innerHeight
    fullWidth = window.innerWidth
    
    outerPadding = 5

    # nonTableOffset = modecontrols.offsetHeight
    ## we removed the modecontrols
    nonTableOffset = 0
    if !tableWrapper? # table does not exist yet
        nonTableOffset += 114 # so take the height which should be enough
    else 
        nonTableOffset += tableWrapper.offsetTop
        nonTableOffset += gridJSFooter.offsetHeight
        nonTableOffset += outerPadding
        log nonTableOffset
    if fullWidth <= 600
        nonTableOffset += loadcontrols.offsetHeight

    tableHeight = fullHeight - nonTableOffset
    # olog {tableHeight, fullHeight, nonTableOffset, approvalHeight}

    olog {tableHeight}
    return tableHeight

############################################################
export getColumnsObject = (state) ->

    ############################################################
    #region columnHeadObjects
    isNewHeadObj = {
        name: ""
        id: "isNew"
        formatter: isNewFormatter
        sort: false
    }

    bilderHeadObj = {
        name: "Bilder"
        id: "images"
        formatter: bilderFormatter
        sort: false
    }

    befundeHeadObj = {
        name: "Befunde"
        id: "befunde"
        formatter: befundeFormatter
        sort: false
    }

    ############################################################
    #region regularDataFields
    screeningDateHeadObj = {
        name: "Unt.-Datum"
        id: "studyDate"
        formatter: screeningDateFormatter
        sort: false
        # sort: { compare: dateCompare }
    }

    nameHeadObj = {
        name: "Name"
        id: "patientFullName"
        formatter: nameFormatter
        sort: false
    }

    svnHeadObj = {
        name: "SVNR"
        id: "patientSsn"
        formatter: svnFormatter
        sort: false
        # sort: {compare: numberCompare}
    }

    birthdayHeadObj = {
        name: "Geb.-Datum"
        id: "patientDob"
        formatter: birthdayFormatter
        sort: false
        # sort:{ compare: dateCompare }
    }

    descriptionHeadObj = {
        name:"Beschreibung"
        id: "studyDescription"
        formatter: descriptionFormatter
        sort: false
    }

    radiologistHeadObj = {
        name: "Radiologie"
        id: "fromFullName"
        formatter: radiologistFormatter
        sort: false
    }

    sendingDateHeadObj = {
        name: "Zustellungsdatum"
        id: "createdAt"
        formatter: sendingDateFormatter
        # sort: { compare: dateCompare }
        sort: false
    }
    #endregion

    #endregion

    return [isNewHeadObj, nameHeadObj, svnHeadObj, birthdayHeadObj, befundeHeadObj, bilderHeadObj, screeningDateHeadObj, radiologistHeadObj, sendingDateHeadObj]

export getLanguageObject = (state) -> return deDE

############################################################
export changeLinksToMessageSent = (target) ->
    # console.log("I have a target opener!")
    messageTarget = target
    window.onLinkClick = onLinkClick
    return

#endregion
