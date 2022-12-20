############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("patientapprovalmodule")
#endregion

############################################################
import * as utl from "./utilmodule.js"
import * as dataModule from "./datamodule.js"

############################################################
svnMode = true

############################################################
waitingResolve = null

############################################################
export initialize = ->
    log "initialize"
    searchPatientButton.addEventListener("click", searchPatientButtonClicked)

    codeInput.addEventListener("keydown", codeInputKeyDowned)
    codeInput.addEventListener("keyup", codeInputKeyUpped)
    return

############################################################
errorFeedback = (message) -> alert(message)

############################################################
codeInputKeyDowned = (evt) ->
    # log "svnPartKeyUpped"
    value = codeInput.value
    codeLength = value.length
    
    # 46 is delete
    if evt.keyCode == 46 then return    
    # 8 is backspace
    if evt.keyCode == 8 then return
    # 27 is escape
    if evt.keyCode == 27 then return
    
    # We we donot allow the input to grow furtherly
    if codeLength == 13
        evt.preventDefault()
        return false
    
    if codeLength > 13 then codeInput.value = ""

    # okay = utl.isAlphanumericString(evt.key)
    okay = utl.isBase32String(evt.key)

    if !okay
        evt.preventDefault()
        return false
    return

codeInputKeyUpped = (evt) ->
    # log "svnPartKeyUpped"
    value = codeInput.value
    codeLength = value.length

    codeTokens = []
    rawCode = value.replaceAll(" ", "")
    rLen = rawCode.length
    
    log "rawCode #{rawCode}"
    if rLen > 0
        codeTokens.push(rawCode.slice(0,3))
    if rLen > 3
        codeTokens.push(rawCode.slice(3,6))
    if rLen > 6
        codeTokens.push(rawCode.slice(6))
    newValue = codeTokens.join("  ")
    
    del = evt.keyCode == 46 || evt.keyCode == 8

    if rLen == 3 || rLen == 6 then newValue += "  " unless del

    codeInput.value = newValue
    return

############################################################
searchPatientButtonClicked = (evnt) ->
    log "searchPatientButtonClicked"
    evnt.preventDefault()
    searchPatientButton.disabled = true
    try
        requestBody = await extractCodeFormBody()
        olog {requestBody}
        if !requestBody.hashedPw and !requestBody.username then return
        await dataModule.loadPatientData(requestBody)
        resolveApprovalOptionsReceived()
    catch err
        errorFeedback("Zugriff auf Patientendaten ist fehlgeschlagen!")
        log err
    finally searchPatientButton.disabled = false
    return

############################################################
resolveApprovalOptionsReceived = ->
    if waitingResolve then waitingResolve(true)
    waitingResolve = null
    return

############################################################
extractCodeFormBody = ->
    username = ""+birthdayInput.value
    if !username then return {}

    code = codeInput.value.replaceAll(" ", "").toLowerCase()
    if !utl.isBase32String(code) then return {}

    isMedic = false
    rememberMe = false

    hashedPw = utl.argon2HashPw(code, username)

    return {username, hashedPw, isMedic, rememberMe}

############################################################
export approvalOptionsPromise = ->
    abort = null
    p = new Promise (resolve, reject) ->
        abort = reject
        waitingResolve = resolve
    p.abort = abort
    return p
    
############################################################
export showUI = ->
    patientapproval.classList.add("shown")
    return

export hideUI = ->
    birthdayInput.value = ""
    codeInput.value = ""
    patientapproval.classList.remove("shown")
    return