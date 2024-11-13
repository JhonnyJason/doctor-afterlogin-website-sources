############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("uistatemodule")
#endregion

############################################################
import * as table from "./overviewtablemodule.js"
import * as loadControls from "./loadcontrolsmodule.js"

############################################################
export setDefaultState = ->
    table.setDefaultState()
    loadControls.showUI()
    return