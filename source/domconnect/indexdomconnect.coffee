indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.nameInput = document.getElementById("name-input")
    global.passwordHashInput = document.getElementById("password-hash-input")
    global.loginButton = document.getElementById("login-button")
    global.chooseDateLimit = document.getElementById("choose-date-limit")
    global.gridjsFrame = document.getElementById("gridjs-frame")
    global.patientApproval = document.getElementById("patient-approval")
    global.approvalSvnPartInput = document.getElementById("approval-svn-part-input")
    global.approvalBirthdayPartInput = document.getElementById("approval-birthday-part-input")
    global.searchPatientButton = document.getElementById("search-patient-button")
    return
    
module.exports = indexdomconnect