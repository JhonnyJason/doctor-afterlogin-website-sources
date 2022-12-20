############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("userprocessmodule")
#endregion

############################################################
currentProcess = null

############################################################
processMap = {}

############################################################
startStepProcess = (stepGenerator) ->
    abort = null
    success = null
    p = new Promise (resolve, reject) ->
        abort = reject
        success = resolve
    currentProcess = {p}

    resolveAfterAllSteps(stepGenerator, success, abort)
    return

############################################################
resolveAfterAllSteps = (stepGenerator, resolve, abort) ->
    for step from stepGenerator()
        currentProcess.currentStep = step
        try await step
        catch err then return abort(err)
    
    return resolve()

############################################################
export addProcess = (name, process, hooks) ->
    processMap[name] = {process, hooks}
    return

############################################################
export startProcess = (name) ->
    log "startProcess #{name}"
    if currentProcess? and currentProcess.currentStep?
        currentProcess.currentStep.abort("User started new process.")

    if !processMap[name]? then throw new Error("process #{name} was not found in the processMap!")
    
    { onSuccess, onReplace, onError, onFinish } = processMap[name].hooks
    startStepProcess(processMap[name].process)

    try 
        result = await currentProcess.p
        if onSuccess? then onSuccess(result)
    catch err
        log "userProcess #{name} choked: "+err
        # in the case of abortion - when user started a new process - the currentProcess has already been replaced
        if err == "User started new process." 
            if onReplace? then onReplace()
            return ## prevent finishing and setting userProcess to null
        else if onError? then onError(err)
    
    currentProcess = null
    if onFinish? then onFinish()
    return

export stopAnyProcess = (name) ->
    return unless currentProcess? and currentProcess.currentStep?
    currentProcess.currentStep.abort("User stopped any Process!")
    return
    
# ############################################################
# export abortCurrentProcess = ->
#     return unless currentProcess?
#     currentProcess.currentStep.abort("Called for Abortion.")
#     return

# ############################################################
# export throwInCurrentProcess = (err) ->
#     return unless currentProcess?
#     currentProcess.currentStep.abort(err)
#     return

