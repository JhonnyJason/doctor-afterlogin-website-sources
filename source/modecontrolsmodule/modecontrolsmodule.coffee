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
    # myDocumentsButton.addEventListener("click", myDocumentsButtonClicked)
    # patientApprovalButton.addEventListener("click", patientApprovalButtonClicked)
    # shareToDoctorButton.addEventListener("click", shareToDoctorButtonClicked)
    return

############################################################
myDocumentsButtonClicked = ->
    log "myDocumentsButtonClicked"
    userProcess.stopAnyProcess()
    return

patientApprovalButtonClicked = ->
    log "patientApprovalButtonClicked"
    userProcess.startPatientApproval()
    return
    
shareToDoctorButtonClicked = ->
    log "shareToDoctorButtonClicked"
    userProcess.startShareToDoctor()
    return

############################################################
export setMyDocumentButtonActive = ->
    myDocumentsButton.classList.add("isActive")
    patientApprovalButton.classList.remove("isActive")
    shareToDoctorButton.classList.remove("isActive")
    return

export setPatientApprovalButtonActive = ->
    myDocumentsButton.classList.remove("isActive")
    patientApprovalButton.classList.add("isActive")
    shareToDoctorButton.classList.remove("isActive")
    return

export setShareToDoctorButtonActive = ->
    myDocumentsButton.classList.remove("isActive")
    patientApprovalButton.classList.remove("isActive")
    shareToDoctorButton.classList.add("isActive")
    return
