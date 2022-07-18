import Modules from "./allmodules"
import domconnect from "./indexdomconnect"
domconnect.initialize()

global.allModules = Modules

gridjsOffset = 0

############################################################
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


############################################################
appStartup = ->
    #for demologin and whole connection testing
    loginButton.addEventListener("click", loginButtonClicked)

    # The real stuff
    gridjsOffset = getTopOffset(gridjsFrame)

    centerTableButton.addEventListener("click", centerTableButtonClicked)
    document.body.addEventListener("scroll", scrolled)
    return

############################################################
#region centering table funcations
centerTableButtonClicked = ->
    scrollOptions = 
        top: gridjsOffset
        behavior: "smooth"

    document.body.scrollTo(scrollOptions)

    return

scrolled = ->
    distance =  Math.abs(document.body.scrollTop - gridjsOffset)
    if distance > 2 then showCenterTableButton()
    else hideCenterTableButton()
    return

hideCenterTableButton = ->
    centerTableButton.style.opacity = "0"
    centerTableButton.style.pointerEvents = "none"
    return

showCenterTableButton = ->
    centerTableButton.style.opacity = "1"
    centerTableButton.style.pointerEvents = "all"
    return

getTopOffset = (elem)->
    top = 0
    while elem
        top += parseInt(elem.offsetTop)
        elem = elem.offsetParent
    return top

#endregion

############################################################
run = ->
    promises = (m.initialize() for n,m of Modules when m.initialize?) 
    await Promise.all(promises)
    appStartup()

############################################################
run()