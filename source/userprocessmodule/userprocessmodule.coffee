############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("userprocessmodule")
#endregion

############################################################
import * as table from "./overviewtablemodule.js"
import * as loadControls from "./loadcontrolsmodule.js"
import * as patientApprovalModule from "./patientapprovalmodule.js"
import * as selectionAction from "./selectionactionmodule.js"

############################################################
currentProcess = null

############################################################
patientApprovalProcess = (control)->
    log "patientApprovalProcess"
    table.setPatientApproval0()
    loadControls.hideUI()
    patientApprovalModule.showUI()

    await patientApprovalModule.approvalOptionsReceived()
    if control.isAborted
        patientApprovalModule.hideUI()
        loadControls.showUI()    
        return
    log "Patient Options have been received!"

    table.setPatientApproval1()
    patientApprovalModule.hideUI()
    loadControls.showUI()

    selectionAction.showUI()
    await table.userSelectionMade()
    if control.isAborted
        selectionAction.hideUI()    
        return
    log "Patient options have been selected!"

    selectionAction.hideUI()    
    table.setDefaultState()
    log "patientApproval succeeded!"
    return

shareToDoctorProcess = (control) ->
    log "shareToDoctorProcess"

    table.setShareToDoctor0()
    patientApprovalModule.hideUI()
    loadControls.showUI()    

    selectionAction.showUI()
    await table.userSelectionMade()
    if control.isAborted
        selectionAction.hideUI()    
        return
    log "Selection of what to share has been made!"

    table.setShareToDoctor1()
    loadControls.hideUI()
    await table.userSelectionMade()
    if control.isAborted
        loadControls.showUI() 
        selectionAction.hideUI()    
        return
    log "Selection has been shared to doctor!"
    
    loadControls.showUI()
    selectionAction.hideUI()    
    table.setDefaultState()
    log "shareToDoctor succeeded!"
    return


############################################################
waitMS = (ms) -> new Promise (resolve, reject) -> setTimeout(resolve, ms)

############################################################
createAbortableProcess = (process) ->
    control = {isAborted:false}
    abort = null

    abortionPromise = new Promise (resolve, reject) -> abort = reject
    successPromise = process(control)

    success = startSuccessAbortionRace(successPromise, abortionPromise, control)
    
    return {success, abort}

############################################################
startSuccessAbortionRace = (success, abortion, control) ->
    try await Promise.race([success, abortion])
    catch err 
        control.isAborted = true
        throw err
    return true


############################################################
export startPatientApproval = ->
    log "startPatientApproval"
    if currentProcess? then currentProcess.abort("User started new process.") 
    currentProcess = createAbortableProcess(patientApprovalProcess)

    try 
        await currentProcess.success
        log "userProcess patientApproval succeeded!"
    catch err 
        log "userProcess patientApproval choked: "+err
        # in the case of abortion - when user started a new process - the currentProcess has already been replaced. And will be set to null when the new process terminates.
        if err == "User started new process." then return
        
    currentProcess = null
    return

export startShareToDoctor = ->
    log "startShareToDoctor"
    if currentProcess? then currentProcess.abort("User started new process.")
    currentProcess = createAbortableProcess(shareToDoctorProcess)
    
    try 
        await currentProcess.success
        log "userProcess shareToDoctor succeeded!"
    catch err
        log "userProcess shareToDoctor failed"+err
        # in the case of abortion - when user started a new process - the currentProcess has already been replaced. And will be set to null when the new process terminates.
        if err == "User started new process." then return

    currentProcess = null
    return

############################################################
export abortCurrentProcess = ->
    return unless currentProcess?
    currentProcess.abort("Called for Abortion.")
    return