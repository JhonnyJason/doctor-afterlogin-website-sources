############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("overviewtablemodule")
#endregion

############################################################
import { Grid, h } from "gridjs"

############################################################
import { dataURL } from "./configmodule.js"


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
export initialize = ->
    log "initialize"

    try
        data = await getData(0, 1000)
        olog data
    catch error
        log "error occured!"
        log error

    bilderObj = {
        name: ""
        id: "bilder-button"
        formatter: bilderFormatter
        sort: false
    }
    befundeObj = {
        name: ""
        id: "befunde-button"
        formatter: befundeFormatter
        sort: false
    }

    gridJSOptions = {
        columns: [bilderObj, befundeObj, "Unt.-Datum", "Name + Vorname", "SVN", "Geb.Datum", "Beschreibung", "Radiologie", "Zustellung"]
        fixedHeader: true,
        search: true,
        sort: true,
        pagination: {
            limit: 50
        }
        data: [
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]            
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]            
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]            
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]            
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]            
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]            
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]            
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]            
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]            
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]            
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]            
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]            
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]            
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]            
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]            
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]            
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]            
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]            
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]            
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]
            ["-", "-", "7/7/2022", "Walter Müller", "4444", "23.1.1950", "Sehr interesssante Untersuchung, vielleicht ist die Länge der Beschreibung auch sehr lang.", "Dr. Rad", "7/7/2022-16:32"]        
        ],
        language: deDE
    }

    tableObj = new Grid(gridJSOptions)
    tableObj.render(overviewtable)
    
    #Implement or Remove :-)
    return

############################################################
bilderFormatter  = (cell, row) ->
    formatObj = {
            className: 'bild-buttom click-button',
            onClick: ->
                olog row 
                log("Bilder Button clicked! @#{row.id}")
          }
    return h('button', formatObj, 'Bilder')

befundeFormatter = (cell, row) ->
    formatObj = {
            className: 'befund-buttom click-button',
            onClick: ->
                olog row
                log("Befunde Button clicked! @#{row.id}")
          }
    return h('button', formatObj, 'Befunde')


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