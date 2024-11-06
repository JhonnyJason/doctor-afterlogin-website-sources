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
import * as dataModule from "./datamodule.js"
import {tableRenderCycleMS} from "./configmodule.js"

############################################################
tableObj = null
currentTableHeight = 0

############################################################
# rendering = false
# updateLater = null
# firstRenderComplete = false

############################################################
currentState = null

############################################################
userSelectionResolve = null

############################################################
export initialize = ->
    log "initialize"
    # setDefaultState()
    # setInterval(updateTableHeight, tableRenderCycleMS)
    window.addEventListener("resize", updateTableHeight)
    return

############################################################
renderTable = (dataPromise) ->
    log "renderTable"
    
    columns = utl.getColumnsObject(currentState)
    data = -> dataPromise
    language = utl.getLanguageObject(currentState)
    search = true

    pagination = { limit: 50 }
    sort = { multiColumn: false }
    fixedHeader = true
    # resizable = false
    resizable = true
    height = "#{utl.getTableHeight(currentState)}px"
    width = "100%"

    gridJSOptions = { columns, data, language, search, pagination, sort, fixedHeader, resizable, height, width }

    if tableObj?
        tableObj = null
        gridjsFrame.innerHTML = ""  
        tableObj = new Grid(gridJSOptions)
        await tableObj.render(gridjsFrame).forceRender()
        # render alone does not work here - it seems the Old State still remains in the GridJS singleton thus a render here does not refresh the table at all
    else
        tableObj = new Grid(gridJSOptions)
        gridjsFrame.innerHTML = ""    
        await tableObj.render(gridjsFrame)
    
    # firstRenderComplete = true
    # setInterval(updateTableHeight, tableRenderCycleMS)
    return

updateTableData = (dataPromise) ->
    # log "updateTableData"

    columns = utl.getColumnsObject(currentState)
    data = -> dataPromise
    language = utl.getLanguageObject(currentState)

    searchInput = document.getElementsByClassName("gridjs-search-input")[0]
    if searchInput? then searchValue = searchInput.value
    log searchValue
    search =
        enabled: true
        keyword: searchValue

    focusRange = getSearchFocusRange()

    await updateTable({columns, data, language, search})
    if focusRange? then setFocusRange(focusRange)
    return

############################################################
updateTableHeight = (height) ->
    # return unless firstRenderComplete

    log "updateTableHeight"
    olog { height }

    ##updating table height in other states causes selection data issues :-(
    return unless currentState == "ownData"

    if typeof height != "number" then height = utl.getTableHeight()
    if currentTableHeight == height then return
    currentTableHeight = height 
    height = height+"px"

    # probably the columns and language objects are not useful here
    # columns = utl.getColumnsObject(currentState)
    # language = utl.getLanguageObject(currentState)

    #preserve input value if we have
    searchInput = document.getElementsByClassName("gridjs-search-input")[0]
    if searchInput? 
        searchValue = searchInput.value
        log searchValue    
        focusRange = getSearchFocusRange()
        search =
            enabled: true
            keyword: searchValue
    else search = false
    
    await updateTable({height, search})
    if focusRange? then setFocusRange(focusRange)
    return

############################################################
updateTable = (config) ->
    log "updateTable"
    olog {rendering, updateLater}
    if rendering  
        updateLater = () -> updateTable(config)
        return

    rendering = true
    try await tableObj.updateConfig(config).forceRender()
    catch err then log err
    rendering = false
    
    if updateLater?
        log "updateLater existed!"
        updateNow = updateLater
        updateLater = null
        updateNow()
    log "update done!"
    return

############################################################
getSearchFocusRange = ->
    searchInput = document.getElementsByClassName("gridjs-search-input")[0]
    return null unless searchInput? and searchInput == document.activeElement
    start = searchInput.selectionStart
    end = searchInput.selectionEnd
    return {start, end}

setFocusRange = (range) ->
    { start, end } = range
    searchInput = document.getElementsByClassName("gridjs-search-input")[0]
    return unless searchInput?
    searchInput.setSelectionRange(start, end)
    searchInput.focus()
    return

############################################################
userSelectionDone = ->
    if userSelectionResolve then userSelectionResolve(true)
    userSelectionResolve = null
    return

############################################################
export userSelectionPromise = ->
    abort = null
    p = new Promise (resolve, reject) ->
        abort = reject
        userSelectionResolve = resolve
    p.abort = abort
    return p

export applySelection = ->
    checkboxPlugin = tableObj.config.plugin.get('select')
    selectedIndices = checkboxPlugin.props.store.state.rowIds

    olog { selectedIndices }

    selectionData = await tableObj.config.data()

    selectedData = []
    for index in selectedIndices
        selectedData.push(selectionData[index])

    # olog { selectedData }

    if currentState == "patientApproval1" then await dataModule.addToOwnData(selectedData)
    else if currentState == "shareToDoctor0" then await dataModule.setShareData(selectedData)
    else if currentState == "shareToDoctor1" then await dataModule.shareToDoctors(selectedData)
    else log "I was not in any selection application state: "+currentState

    ## The reset does not help - BUG! the state of the plugin is set once and would not be changable again TODO FIX
    # checkboxPlugin.props.store.state.rowIds = [] # reset selection
    userSelectionDone()
    return

############################################################
export refresh = ->
    log "refresh"
    log currentState
    switch currentState
        when "shareToDoctor0" then setShareToDoctor0()
        when "shareToDoctor1" then setShareToDoctor1()
        when "patientApproval0" then setPatientApproval0()
        when "patientApproval1" then setPatientApproval1()
        when "ownData" then setDefaultState()
    return 

############################################################
#region set to state Functions
export setShareToDoctor0 = ->
    log "setShareToDoctor0"
    currentState = "shareToDoctor0"

    columns = utl.getColumnsObject(currentState)
    data = -> dataModule.getOwnData()
    language = utl.getLanguageObject(currentState)

    ## preserve search
    searchInput = document.getElementsByClassName("gridjs-search-input")[0]
    if searchInput? 
        searchValue = searchInput.value
        # log searchValue
        search =
            enabled: true
            keyword: searchValue
    else 
        search = true
    overviewtable.classList.remove("no-search")

    updateTable({columns, data, language, search})
    return

export setShareToDoctor1 = ->
    log "setShareToDoctor1"
    currentState = "shareToDoctor1"

    columns = utl.getColumnsObject(currentState)
    data = -> dataModule.getDoctorList()
    language = utl.getLanguageObject(currentState)
    search = true
    overviewtable.classList.remove("no-search")

    updateTable({columns, data, language, search})
    return

############################################################
export setPatientApproval0 = ->
    log "setPatientApproval0"
    currentState = "patientApproval0"

    data = []
    language = utl.getLanguageObject(currentState)
    search = false
    overviewtable.classList.add("no-search")

    updateTable({search, data, language})
    return

export setPatientApproval1 = ->
    log "setPatientAPproval1"
    currentState = "patientApproval1"

    columns = utl.getColumnsObject(currentState)
    data = -> dataModule.getPatientData()
    language = utl.getLanguageObject(currentState)
    search = true
    overviewtable.classList.remove("no-search")

    updateTable({columns, search, data, language})
    return

############################################################
export setDefaultState = ->
    log "setDefaultState"
    currentState = "ownData"
    overviewtable.classList.remove("no-search")

    dataPromise = dataModule.getOwnData()

    # this is when we want to destroy the table completely
    # renderTable(dataPromise)

    # in the usual case we only want to update the table when it already exists
    if tableObj then updateTableData(dataPromise)
    else renderTable(dataPromise)
    return

#endregion