############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("uistatemodule")
#endregion

############################################################
import * as table from "./overviewtablemodule.js"
import * as modeButtons from "./modecontrolsmodule.js"
import * as loadControls from "./loadcontrolsmodule.js"
import * as patientApprovalModule from "./patientapprovalmodule.js"
import * as selectionAction from "./selectionactionmodule.js"

############################################################
export setDefaultState = ->
    # modeButtons.setMyDocumentButtonActive()
    table.setDefaultState()
    selectionAction.hideUI()    
    patientApprovalModule.hideUI()
    loadControls.showUI()
    return

############################################################
export setPatientApproval0 = ->
    # modeButtons.setPatientApprovalButtonActive()
    table.setPatientApproval0() 
    patientApprovalModule.showUI()
    loadControls.hideUI()
    selectionAction.hideUI()
    return

export setPatientApproval1 = ->
    # modeButtons.setPatientApprovalButtonActive()
    table.setPatientApproval1()
    patientApprovalModule.hideUI()
    selectionAction.showUI()
    loadControls.showUI()
    return

############################################################
export setShareToDoctor0 = ->
    # modeButtons.setShareToDoctorButtonActive()
    table.setShareToDoctor0()
    patientApprovalModule.hideUI()
    loadControls.showUI()    
    selectionAction.showUI()
    return

export setShareToDoctor1 = ->
    # modeButtons.setShareToDoctorButtonActive()
    table.setShareToDoctor1()
    patientApprovalModule.hideUI()
    loadControls.hideUI()
    selectionAction.showUI()
