############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("uistatemodule")
#endregion

############################################################
import * as table from "./overviewtablemodule.js"
import * as loadControls from "./loadcontrolsmodule.js"
import * as patientApprovalModule from "./patientapprovalmodule.js"
import * as selectionAction from "./selectionactionmodule.js"

############################################################
export setDefaultState = ->
    table.setDefaultState()
    selectionAction.hideUI()    
    patientApprovalModule.hideUI()
    loadControls.showUI()
    return

############################################################
export setPatientApproval0 = ->
    table.setPatientApproval0() 
    patientApprovalModule.showUI()
    loadControls.hideUI()
    selectionAction.hideUI()
    return

export setPatientApproval1 = ->
    table.setPatientApproval1()
    patientApprovalModule.hideUI()
    selectionAction.showUI()
    loadControls.showUI()
    return

############################################################
export setShareToDoctor0 = ->
    table.setShareToDoctor0()
    patientApprovalModule.hideUI()
    loadControls.showUI()    
    selectionAction.showUI()
    return

export setShareToDoctor1 = ->
    table.setShareToDoctor1()
    patientApprovalModule.hideUI()
    loadControls.hideUI()
    selectionAction.showUI()
