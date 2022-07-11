indexdomconnect = {name: "indexdomconnect"}

############################################################
indexdomconnect.initialize = () ->
    global.nameInput = document.getElementById("name-input")
    global.passwordHashInput = document.getElementById("password-hash-input")
    global.loginButton = document.getElementById("login-button")
    return
    
module.exports = indexdomconnect