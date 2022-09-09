############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("modecontrolsmodule")
#endregion

############################################################
import *  as userProcess from "./userprocessmodule.js"

############################################################
export initialize = ->
    log "initialize"
    patientApprovalButton.addEventListener("click", patientApprovalButtonClicked)
    shareToDoctorButton.addEventListener("click", shareToDoctorButtonClicked)
    return

############################################################
patientApprovalButtonClicked = ->
    log "patientApprovalButtonClicked"
    userProcess.startPatientApproval()
    return
    
shareToDoctorButtonClicked = ->
    log "shareToDoctorButtonClicked"
    userProcess.startShareToDoctor()
    return
