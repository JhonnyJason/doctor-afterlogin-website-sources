indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.nameInput = document.getElementById("name-input")
    global.passwordHashInput = document.getElementById("password-hash-input")
    global.loginButton = document.getElementById("login-button")
    global.overviewtable = document.getElementById("overviewtable")
    global.gridjsFrame = document.getElementById("gridjs-frame")
    global.selectionaction = document.getElementById("selectionaction")
    global.selectionactionButton = document.getElementById("selectionaction-button")
    global.patientapproval = document.getElementById("patientapproval")
    global.birthdayInput = document.getElementById("birthday-input")
    global.codeInput = document.getElementById("code-input")
    global.searchPatientButton = document.getElementById("search-patient-button")
    global.loadcontrols = document.getElementById("loadcontrols")
    global.refreshButton = document.getElementById("refresh-button")
    global.chooseDateLimit = document.getElementById("choose-date-limit")
    return
    
module.exports = indexdomconnect