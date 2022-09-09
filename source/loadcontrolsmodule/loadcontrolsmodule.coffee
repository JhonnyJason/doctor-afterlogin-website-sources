############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("loadcontrolsmodule")
#endregion

############################################################
import *  as table from "./overviewtablemodule.js"

############################################################
export initialize = ->
    log "initialize"
    refreshButton.addEventListener("click", refreshButtonClicked)
    chooseDateLimit.addEventListener("change", dateLimitChanged)
    return

############################################################
refreshButtonClicked = ->
    # "refreshButtonClicked"
    dateLimitChanged()
    return

dateLimitChanged = ->
    # log "dateLimitChanged"
    # log chooseDateLimit.value
    switch chooseDateLimit.value
        when "1" then table.retrieveAndRenderOwnData(30)
        when "2" then table.retrieveAndRenderOwnData(90)
        when "3" then table.retrieveAndRenderOwnData(180)
        else log "unknown value: "+chooseDateLimit.value
    return

