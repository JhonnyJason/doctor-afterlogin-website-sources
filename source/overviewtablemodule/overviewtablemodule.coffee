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
import * as S from "./statemodule.js"
import * as utl from "./tableutils.js"
import * as data from "./datamodule.js"

############################################################
tableObj = null
currentTableHeight = 0

############################################################
currentState = null

############################################################
export initialize = ->
    log "initialize"         
    setDefaultState()
    setInterval(updateTableHeight, 2000)
    return

############################################################
export renderTable = (dataPromise) ->
    # log "renderTable"
    headerObject = utl.getHeaderObject(currentState)
    languageObject = utl.getLanguageObject(currentState)
    searchObject = utl.getSearchObject(currentState)
    paginationObject = utl.getPaginationObject(currentState)

    currentTableHeight = utl.getTableHeight(currentState)

    gridJSOptions = {
        columns: headerObject
        data: -> dataPromise,
        # server: serverObject,
        search: searchObject,
        pagination: paginationObject,
        sort: {
            multiColumn: false
        },
        language: languageObject,
        fixedHeader: true,
        resizable: false,
        # footer: 
        # height: "calc(100vh - "+nonTableOffset+"px)",
        height: currentTableHeight+"px"
        width: "100%"
        # className: {
        #     td: 'table-cell',
        #     table: 'c-table'
        # }
    }

    tableObj = new Grid(gridJSOptions)
    gridjsFrame.innerHTML = ""
    tableObj.render(gridjsFrame)
    return

updateTable = (dataPromise) ->
    # log "updateTable"
    searchInput = document.getElementsByClassName("gridjs-search-input")[0]
    if searchInput? then searchValue = searchInput.value
    log searchValue
    
    search =
        enabled: true
        keyword: searchValue

    data = -> dataPromise

    tableObj.updateConfig({data, search})
    tableObj.forceRender()
    
    # if searchValue then searchInput.value = searchValue
    return


############################################################
updateTableHeight = (height) ->
    # olog {height}
    if !height? then height = utl.getTableHeight()
    if currentTableHeight == height then return
    currentTableHeight = height 
    height = height+"px"

    #preserve input value if we have
    searchInput = document.getElementsByClassName("gridjs-search-input")[0]
    if searchInput? 
        searchValue = searchInput.value
        log searchValue
        search =
            enabled: true
            keyword: searchValue
    else search = false
    
    tableObj.updateConfig({height, search})
    tableObj.forceRender()
    return

############################################################
export refresh = ->
    ##TODO check if we should differentiate between states here
    updateTable(data.getOwnData())
    return

############################################################
#region setTable to differentState
export setShareToDoctor0 = ->
    log "setShareToDoctor0"
    ## TODO implement
    
    return

export setShareToDoctor1 = ->
    log "setShareToDoctor1"
    ## TODO implement

    return

############################################################
export setPatientApproval0 = ->
    log "setPatientApproval0"
    currentState = "patientApproval0"
    ## TODO get the right headers for patientApproval1 already here
    
    data = []
    language = utl.getLanguageObject(currentState)
    search = false

    overviewtable.classList.add("patientApproval0")

    tableObj.updateConfig({search, data, language})
    tableObj.forceRender()    
    return

export setPatientAPproval1 = (options) ->
    log "setPatientAPproval1"
    currentState = "patientApproval1"
    overviewtable.classList.remove("patientApproval0")
    ## TODO get the right headers for checkboxes

    data = options
    language = deDE
    search = getSearchObject()

    tableObj.updateConfig({search, data, language})
    tableObj.forceRender()    

    return

############################################################
export setDefaultState = ->
    log "setDefaultState"
    currentState = "ownData"
    overviewtable.classList.remove("patientApproval0")

    renderTable(data.getOwnData())
    return

#endregion