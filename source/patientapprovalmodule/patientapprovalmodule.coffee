############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("patientapprovalmodule")
#endregion

############################################################
import * as utl from "./utilmodule.js"
import * as dataModule from "./datamodule.js"

############################################################
svnPartLength = 0
svnBirthdayPartLength = 0

############################################################
svnMode = true

############################################################
waitingResolve = null

############################################################
export initialize = ->
    log "initialize"
    searchPatientButton.addEventListener("click", searchPatientButtonClicked)
    approvalSvnPartInput.addEventListener("keydown", svnPartKeyDowned)
    approvalSvnPartInput.addEventListener("keyup", svnPartKeyUpped)
    approvalBirthdayPartInput.addEventListener("keyup", birthdayPartKeyUpped)
    approvalSvnSwitch.addEventListener("change", approvalSvnSwitchChanged)

    svnMode = approvalSvnSwitch.checked
    return

############################################################
errorFeedback = (message) -> alert(message)

############################################################
svnPartKeyDowned = (evnt) ->
    # log "svnPartKeyUpped"
    value = approvalSvnPartInput.value
    svnPartLength = value.length
    # olog {newLength}

    if evnt.keyCode == 46 then return
    
    if evnt.keyCode == 8 then return

    if svnPartLength > 4 
        approvalSvnPartInput.value = value.slice(0,4)
        focusBirthdayPartFirst()
    return

svnPartKeyUpped = (evnt) ->
    # log "svnPartKeyUpped"
    value = approvalSvnPartInput.value
    svnPartLength = value.length
    # olog {newLength}

    if evnt.keyCode == 46 then return
    
    if evnt.keyCode == 8 then return

    if svnPartLength == 4 then focusBirthdayPartFirst()
    if svnPartLength > 4 
        approvalSvnPartInput.value = value.slice(0,4)
        focusBirthdayPartFirst()
    return

birthdayPartKeyUpped = (evnt) ->
    # log "birthdayPartKeyUpped"
    value = approvalBirthdayPartInput.value
    newLength = value.length
    # olog {newLength}

    if evnt.keyCode != 8
        svnBirthdayPartLength = newLength
        return

    if svnBirthdayPartLength == 0 then focusSVNPartLast()
    else svnBirthdayPartLength = newLength
    return

approvalSvnSwitchChanged = ->
    svnMode = approvalSvnSwitch.checked
    if svnMode then patientApproval.classList.add("pin-mode")
    else patientApproval.classList.remove("pin-mode")
    return

############################################################
searchPatientButtonClicked = (evnt) ->
    log "searchPatientButtonClicked"
    evnt.preventDefault()
    searchPatientButton.disabled = true
    try

        if svnMode then requestBody = await extractSVNFormBody()
        else requestBody = await extractNoSVNFormBody()
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
extractSVNFormBody = ->
    isMedic = false
    rememberMe = false
    svnPart = ""+approvalSvnPartInput.value
    birthdayPart = ""+approvalBirthdayPartInput.value
    olog {birthdayPart}
    birthdayTokens = birthdayPart.split("-")
    year = birthdayTokens.shift()
    birthdayTokens.push(year)
    birthdayPart = birthdayTokens.join("")
    olog {birthdayPart}

    username = svnPart+birthdayPart
    password = ""+approvalPinInput.value

    if !password then hashedPw = ""
    else hashedPw = await utl.hashUsernamePw(username, password)
    
    return {username, hashedPw, isMedic, rememberMe}

extractNoSVNFormBody = ->

    isMedic = false
    rememberMe = false
    
    birthdayPart = ""+approvalBirthdayPartInput.value
    olog {birthdayPart}
    
    username = birthdayPart
    password = "AT-"+approvalAuthcodeInput.value
    
    if password == "AT-" then hashedPw = ""
    else hashedPw = await utl.hashUsernamePw(username, password)
    
    return {username, hashedPw, isMedic, rememberMe}

############################################################
export approvalOptionsReceived = ->
    return new Promise (resolve) -> waitingResolve = resolve 

############################################################
focusSVNPartLast = ->
    approvalSvnPartInput.setSelectionRange(4, 4)
    approvalSvnPartInput.focus()
    return

focusBirthdayPartFirst = ->
    # approvalBirthdayPartInput.setSelectionRange(0, 0)
    approvalBirthdayPartInput.focus()
    return

############################################################
export showUI = ->
    patientapproval.classList.add("shown")
    return

export hideUI = ->
    svnMode = true
    approvalSvnSwitch.checked = true
    approvalSvnPartInput.value = ""
    approvalBirthdayPartInput.value = ""
    approvalPinInput.value = ""
    patientapproval.classList.remove("shown")
    return