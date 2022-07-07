############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("overviewtablemodule")
#endregion

import { createTable } from '@tanstack/table-core'

import { Grid } from "gridjs"

tableObj = null


## datamodel 
# | (+) button | Untersuchungsdatum | Patienten Name (Fullname) | SSN (4 digits) | Geb.Datum | Untersuchungsbezeichnung | Radiologie | Zeitstempel (Datum + Uhrzeit) |

############################################################
export initialize = ->
    log "initialize"
    options =
        debugTable: true

    gridJSOptions = {
        columns: ["Name", "Email", "Phone Number"]
        search: true
        data: [
            ["John", "john@example.com", "(353) 01 222 3333"],
            ["Mark", "mark@gmail.com", "(01) 22 888 4444"],
            ["Eoin", "eoin@gmail.com", "0097 22 654 00033"],
            ["Sarah", "sarahcdd@gmail.com", "+322 876 1233"],
            ["Afshin", "afshin@mail.com", "(353) 22 87 8356"]
        ]
    }

    tableObj = new Grid(gridJSOptions)
    tableObj.render(overviewtable)
    
    #Implement or Remove :-)
    return