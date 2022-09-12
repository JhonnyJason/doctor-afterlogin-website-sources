############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("loadcontrolsmodule")
#endregion

############################################################
import * as table from "./overviewtablemodule.js"
import * as data from "./datamodule.js"
import * as S from "./statemodule.js"

############################################################
export initialize = ->
    log "initialize"
    daysLimit = S.load("daysLimit")
    if daysLimit then switch daysLimit
        when 30 then chooseDateLimit.value = 1
        when 90 then chooseDateLimit.value = 2
        when 180 then chooseDateLimit.value = 3
        else log "Error: daysLimit was not of the expected 30,90 or 180!"

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
        when "1" then data.changeDaysLimit(30)
        when "2" then data.changeDaysLimit(90)
        when "3" then data.changeDaysLimit(180)
        else log "unknown value: "+chooseDateLimit.value
    table.refresh()
    return

############################################################
export hideUI = -> loadcontrols.classList.add("hidden")

export showUI = -> loadcontrols.classList.remove("hidden")

