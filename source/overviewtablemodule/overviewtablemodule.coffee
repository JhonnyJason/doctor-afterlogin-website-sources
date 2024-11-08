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
    # setInterval(emboldenNewRows, tableRenderCycleMS)
    window.addEventListener("resize", updateTableHeight)
    window.searchForName = searchForName
    return

############################################################
renderTable = (dataPromise) ->
    log "renderTable"
    
    columns = utl.getColumnsObject(currentState)
    data = -> dataPromise
    language = utl.getLanguageObject(currentState)
    search = true

    pagination = { limit: 50 }
    # sort = { multiColumn: false }
    sort = false
    fixedHeader = true
    resizable = false
    # resizable = true
    height = "#{utl.getTableHeight(currentState)}px"
    width = "100%"
    
    autoWidth = false
    afterRender = emboldenNewRows
    
    gridJSOptions = { columns, data, language, search, pagination, sort, fixedHeader, resizable, height, width, autoWidth, afterRender }
    
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
    setTimeout(emboldenNewRows, tableRenderCycleMS)
    return

# updateTableData = (dataPromise) ->
#     # log "updateTableData"

#     columns = utl.getColumnsObject(currentState)
#     data = -> dataPromise
#     language = utl.getLanguageObject(currentState)

#     searchInput = document.getElementsByClassName("gridjs-search-input")[0]
#     if searchInput? then searchValue = searchInput.value
#     log searchValue
#     search =
#         enabled: true
#         keyword: searchValue

#     focusRange = getSearchFocusRange()

#     height = "#{utl.getTableHeight(currentState)}px"
#     width = "100%"

#     await updateTable({columns, data, language, search, height, width})
#     if focusRange? then setFocusRange(focusRange)
#     return

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

    setTimeout(emboldenNewRows, tableRenderCycleMS)
    
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

emboldenNewRows = ->
    log "emboldenNewRows"
    if document.getElementsByClassName("gridjs-loading-bar").length > 0
        setTimeout(emboldenNewRows, tableRenderCycleMS)
        return

    isNewIndicators = document.getElementsByClassName("isNew")
    log "isNewIndicators: #{isNewIndicators.length}"

    for el in isNewIndicators
        rowEl = getRowForIsNewIndicator(el)
        rowEl.classList.add("newRow")
    return

getRowForIsNewIndicator = (indicator) ->
    node = indicator
    loop
        node = node.parentNode
        if !node? or node.tagName == "TR" then return node
    return

############################################################
searchForName = (name) ->
    log "searchForName #{name}"
    search = {keyword: name}
    updateTable({search})
    return
    
############################################################
export refresh = ->
    log "refresh"
    log currentState
    setDefaultState()
    return 

############################################################
#region set to state Functions
export setDefaultState = ->
    log "setDefaultState"
    currentState = "ownData"
    overviewtable.classList.remove("no-search")

    dataPromise = dataModule.getOwnData()

    # this is when we want to destroy the table completely
    renderTable(dataPromise)

    # in the usual case we only want to update the table when it already exists
    # if tableObj then updateTableData(dataPromise)
    # else renderTable(dataPromise)
    return

#endregion