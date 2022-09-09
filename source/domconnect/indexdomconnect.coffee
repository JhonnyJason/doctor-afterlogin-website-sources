indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.nameInput = document.getElementById("name-input")
    global.passwordHashInput = document.getElementById("password-hash-input")
    global.loginButton = document.getElementById("login-button")
    global.gridjsFrame = document.getElementById("gridjs-frame")
    global.patientapproval = document.getElementById("patientapproval")
    global.patientApproval = document.getElementById("patient-approval")
    global.approvalSvnPartInput = document.getElementById("approval-svn-part-input")
    global.approvalBirthdayPartInput = document.getElementById("approval-birthday-part-input")
    global.searchPatientButton = document.getElementById("search-patient-button")
    global.refreshButton = document.getElementById("refresh-button")
    global.chooseDateLimit = document.getElementById("choose-date-limit")
    global.modecontrols = document.getElementById("modecontrols")
    global.patientApprovalButton = document.getElementById("patient-approval-button")
    global.shareToDoctorButton = document.getElementById("share-to-doctor-button")
    return
    
module.exports = indexdomconnect