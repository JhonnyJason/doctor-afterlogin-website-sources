import Modules from "./allmodules"
import domconnect from "./indexdomconnect"
domconnect.initialize()

global.allModules = Modules

############################################################
#region login for demoData
loginButtonClicked = ->
    username = nameInput.value
    hashedPwd = passwordHashInput.value
    try
        loginResult = await demoLogin(username, hashedPwd)
        olog { loginResult }
        whoamiResult = await checkWhoAmI()
        olog { whoamiResult }
        dataPromise = Modules.datamodule.retrieveData(180)
        renderTable(dataPromise)
    catch err
        log "error occured!"
        log err
    
    return

demoLogin = (username, hashedPw) ->
    url = "https://extern.bilder-befunde.at/caasdemo/api/v1/auth/login"
    data = {
        username,
        hashedPw,
        isMedic: true,
        rememberMe: true
    }

    return postData(url, data)

checkWhoAmI = ->
    url = "https://extern.bilder-befunde.at/caasdemo/api/v1/auth/whoami"
    options =
        method: 'GET'
        mode: 'cors'
        credentials: 'include'
    
    try
        response = await fetch(url, options)
        if !response.ok then throw new Error("Response not ok - status: "+response.status+"!")
        return response.json()
    catch err then throw new Error("Network Error: "+err.message)

#endregion

############################################################
appStartup = ->
    #for demologin and whole connection testing
    loginButton.addEventListener("click", loginButtonClicked)
    return

############################################################
run = ->
    promises = (m.initialize() for n,m of Modules when m.initialize?) 
    await Promise.all(promises)
    appStartup()

############################################################
run()