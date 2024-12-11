indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.overviewtable = document.getElementById("overviewtable")
    global.gridjsFrame = document.getElementById("gridjs-frame")
    global.forwardingLink = document.getElementById("forwarding-link")
    global.backButton = document.getElementById("back-button")
    global.patientNameIndication = document.getElementById("patient-name-indication")
    global.loadcontrols = document.getElementById("loadcontrols")
    global.refreshButton = document.getElementById("refresh-button")
    global.chooseDateLimit = document.getElementById("choose-date-limit")
    return
    
module.exports = indexdomconnect