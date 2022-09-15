############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("tableutils")
#endregion

############################################################
import { Grid, html} from "gridjs"
import { RowSelection } from "gridjs/plugins/selection"

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
        showing: 'Anzeigen'
        of: 'von'
        to: 'zu'
        results: 'Ergebnisse'
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
        showing: 'Anzeigen'
        of: 'von'
        to: 'zu'
        results: 'Ergebnisse'
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
doctorNameFormatter = (content, row) ->
    return content

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
    if content.hasImage? 
        if messageTarget? then innerHTML = '<a onclick="onLinkClick(this);" href="'+entryBaseURL+content.documentFormatPk+'" class="bild-button" target="_blank" ><svg row-id="'+row.id+'" ><use href="#svg-images-icon" /></svg></a>'
        else innerHTML = '<a href="'+entryBaseURL+content.documentFormatPk+'" class="bild-button" target="_blank" ><svg row-id="'+row.id+'" ><use href="#svg-images-icon" /></svg></a>'
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

    if content.hasBefund?
        if messageTarget? innerHTML = '<a onClick="onLinkClick(this);" href="'+entryBaseURL+content.documentFormatPk+'" class="befund-button" ><svg row-id="'+row.id+'" ><use href="#svg-documents-icon" /></svg></a>'
        else innerHTML = '<a href="'+entryBaseURL+content.documentFormatPk+'" class="befund-button" ><svg row-id="'+row.id+'" ><use href="#svg-documents-icon" /></svg></a>'
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

#endregion

############################################################
#region columnHeadObjects
checkboxHeadObj = {
    name: "",
    id: "select",
    data: () -> false,
    sort: false,
    plugin: {
        component: RowSelection,
        props: {
            id: (row) -> row.cell(1).data
        }
    }
}

indexHeadObj = {
    name: "",
    id: "index",
    sort: false,
    hidden: true
}

############################################################
doctorHeadObj = {
    name: "Name",
    id: "doctorName",
    formatter: doctorNameFormatter

}

############################################################
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

############################################################
#region regularDataFields
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
#endregion

#endregion


############################################################
#region exportedFunctions
export getTableHeight = (state) ->
    # log "getTableHeight"
    ## TODO check if we need to differentiate between states here

    gridJSHead = document.getElementsByClassName("gridjs-head")[0]
    gridJSFooter = document.getElementsByClassName("gridjs-footer")[0]

    fullHeight = window.innerHeight
    fullWidth = window.innerWidth
    
    outerPadding = 5
    modecontrolsHeight = modecontrols.offsetHeight

    if gridJSHead? and gridJSFooter?
        footerHeight = gridJSFooter.offsetHeight
        searchHeight = gridJSHead.offsetHeight + 10
    else
        searchHeight = 58
        if fullWidth < 750 then footerHeight = 82
        else footerHeight = 55

    nonTableOffset = modecontrolsHeight + footerHeight + searchHeight + outerPadding
    approvalHeight = patientApproval.offsetHeight

    if fullWidth < 1000 then nonTableOffset += approvalHeight

    tableHeight = fullHeight - nonTableOffset
    # olog {tableHeight, fullHeight, nonTableOffset, approvalHeight}

    # return tableHeight
    return tableHeight

############################################################
export getColumnsObject = (state) ->

    ############################################################
    #region columnHeadObjects
    checkboxHeadObj = {
        name: "",
        id: "select",
        data: () -> false,
        sort: false,
        plugin: {
            component: RowSelection,
            props: {
                id: (row) -> row.cell(1).data
            }
        }
    }

    indexHeadObj = {
        name: "",
        id: "index",
        sort: false,
        hidden: true
    }

    ############################################################
    doctorHeadObj = {
        name: "Name",
        id: "doctorName",
        formatter: doctorNameFormatter

    }

    ############################################################
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

    ############################################################
    #region regularDataFields
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
    #endregion

    #endregion

    if state == "shareToDoctor0" then return [checkboxHeadObj, indexHeadObj, screeningDateHeadObj, nameHeadObj, svnHeadObj, birthdayHeadObj, descriptionHeadObj, radiologistHeadObj, sendingDateHeadObj]

    if state == "shareToDoctor1" then return [checkboxHeadObj, indexHeadObj, doctorHeadObj]

    if state == "patientApproval1" then return [checkboxHeadObj, indexHeadObj, screeningDateHeadObj, nameHeadObj, svnHeadObj, birthdayHeadObj, descriptionHeadObj, radiologistHeadObj, sendingDateHeadObj]

    return [bilderHeadObj, befundeHeadObj, screeningDateHeadObj, nameHeadObj, svnHeadObj, birthdayHeadObj, descriptionHeadObj, radiologistHeadObj, sendingDateHeadObj]

export getLanguageObject = (state) ->
    if state == "patientApproval0" then return deDEPatientApproval
    else return deDE

############################################################
export changeLinksToMessageSent = (target) ->
    # console.log("I have a target opener!")
    messageTarget = target
    window.onLinkClick = onLinkClick
    return

#endregion
