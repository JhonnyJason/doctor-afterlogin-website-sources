indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.nameInput = document.getElementById("name-input")
    global.passwordHashInput = document.getElementById("password-hash-input")
    global.loginButton = document.getElementById("login-button")
    global.overviewtable = document.getElementById("overviewtable")
    global.gridjsFrame = document.getElementById("gridjs-frame")
    global.mindateDisplay = document.getElementById("mindate-display")
    global.loadcontrols = document.getElementById("loadcontrols")
    global.refreshButton = document.getElementById("refresh-button")
    global.chooseDateLimit = document.getElementById("choose-date-limit")
    return
    
module.exports = indexdomconnect