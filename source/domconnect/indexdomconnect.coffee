indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.nameInput = document.getElementById("name-input")
    global.passwordHashInput = document.getElementById("password-hash-input")
    global.loginButton = document.getElementById("login-button")
    global.patientApproval = document.getElementById("patient-approval")
    global.chooseDateLimit = document.getElementById("choose-date-limit")
    global.gridjsFrame = document.getElementById("gridjs-frame")
    return
    
module.exports = indexdomconnect