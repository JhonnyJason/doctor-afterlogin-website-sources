############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("patientapprovalmodule")
#endregion


############################################################
svnPartLength = 0
svnBirthdayPartLength = 0

############################################################
export initialize = ->
    log "initialize"
    searchPatientButton.addEventListener("click", searchPatientButtonClicked)
    approvalSvnPartInput.addEventListener("keydown", svnPartKeyDowned)
    approvalSvnPartInput.addEventListener("keyup", svnPartKeyUpped)
    approvalBirthdayPartInput.addEventListener("keyup", birthdayPartKeyUpped)
    approvalSvnPartInput.addEventListener("focus", svnPartFocused)
    approvalSvnPartInput.addEventListener("blur", svnPartBlurred)
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

svnPartFocused = ->
    log "svnPartFocused"
    patientApproval.classList.add("pin-mode")
    return

svnPartBlurred = ->
    log "svnPartBlurred"
    if approvalSvnPartInput.value.length == 0 then patientApproval.classList.remove("pin-mode")
    return

############################################################
searchPatientButtonClicked = (evnt) ->
    log "searchPatientButtonClicked"
    evnt.preventDefault()
    searchPatientButton.disabled = true
    try
        ##TODO
    catch err then return errorFeedback("svnPatient", "Other: " + err.message)
    finally searchPatientButton.disabled = false
    return



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
    searchInput = document.getElementsByClassName("gridjs-search-input")[0]
    searchInput.style.display = "none"
    return

export hideUI = ->
    patientapproval.classList.remove("shown")
    return
