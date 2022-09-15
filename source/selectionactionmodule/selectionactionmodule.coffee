############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("selectionactionmodule")
#endregion

############################################################
import { applySelection } from "./overviewtablemodule.js"

############################################################
export initialize = ->
    log "initialize"
    selectionactionButton.addEventListener("click", selectionactionButtonClicked)
    return

############################################################
selectionactionButtonClicked = -> 
    applySelection()
    return

############################################################
export showUI = ->
    selectionaction.classList.add("shown")
    return

export hideUI = ->
    selectionaction.classList.remove("shown")
    return



