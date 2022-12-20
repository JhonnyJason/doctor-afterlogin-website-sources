############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("userprocessmodule")
#endregion

############################################################
import * as patientApprovalModule from "./patientapprovalmodule.js"
import * as table from "./overviewtablemodule.js"
import * as uiState from "./uistatemodule.js"
import * as proc from "./stepprocess.js"

############################################################
hooks = {
    onFinish: -> uiState.setDefaultState()
}
############################################################
export initialize = ->
    log "initialize"
    proc.addProcess("patientApproval", patientApprovalProcess, hooks)
    proc.addProcess("shareToDoctor", shareToDoctorProcess, hooks)
    return

############################################################
patientApprovalProcess = ->
    log "patientApprovalProcess"

    uiState.setPatientApproval0()
    # user shall log in as patient
    yield patientApprovalModule.approvalOptionsPromise()
    log "Patient Options have been received!"

    uiState.setPatientApproval1()
    # user shall slect the documents to take over
    yield table.userSelectionPromise()
    log "patientApproval succeeded!"
    return

shareToDoctorProcess = ->
    log "shareToDoctorProcess"

    uiState.setShareToDoctor0()
    # user shall select documents to share
    yield table.userSelectionPromise()
    log "selection of "

    uiState.setShareToDoctor1()
    # user shall select the doctor so share to
    yield table.userSelectionPromise()
    log "shareToDoctor succeeded!"
    return

############################################################
export startPatientApproval = -> proc.startProcess("patientApproval")
export startShareToDoctor = -> proc.startProcess("shareToDoctor")
