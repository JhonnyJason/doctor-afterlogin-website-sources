############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("loadcontrolsmodule")
#endregion

############################################################
import * as table from "./overviewtablemodule.js"
import * as data from "./datamodule.js"
import * as S from "./statemodule.js"

############################################################
mindateDisplay = document.getElementById("mindate-display")
patientNameIndication = document.getElementById("patient-name-indication")

############################################################
export initialize = ->
    log "initialize"
    optionValue = S.load("entryLimitOptionValue")
    if optionValue? then switch optionValue
        when "1"
            chooseDateLimit.value = optionValue
            # data.setMinDateDaysBack(30)
            setEntryLimit(250)
        when "2" 
            chooseDateLimit.value = optionValue
            # data.setMinDateMonthsBack(3)
            setEntryLimit(500)
        when "3" 
            chooseDateLimit.value = optionValue
            # data.setMinDateMonthsBack(6)
            setEntryLimit(1000)
        when "4" 
            chooseDateLimit.value = optionValue
            # data.setMinDateYearsBack(1)
            setEntryLimit(2500)
        when "5" 
            chooseDateLimit.value = optionValue
            # data.setMinDateYearsBack(2)
            setEntryLimit(5000)
        when "6" 
            chooseDateLimit.value = optionValue
            # data.setMinDateYearsBack(2)
            setEntryLimit(10000)
        else throw new Error("Error: optionValue was an unexpected value: #{optionValue}")
    else
        chooseDateLimit.value = "1"
        # data.setMinDateDaysBack(30)
        setEntryLimit(250)

    # mindateDisplay.textContent = data.getMinDate()

    refreshButton.addEventListener("click", refreshButtonClicked)
    chooseDateLimit.addEventListener("change", dateLimitChanged)
    backButton.addEventListener("click", backButtonClicked)
    return


############################################################
backButtonClicked = ->
    log "backButtonClicked"
    table.backFromPatientTable()
    return

############################################################
refreshButtonClicked = ->
    # "refreshButtonClicked"
    dateLimitChanged()
    return

dateLimitChanged = ->
    # log "dateLimitChanged"
    # log chooseDateLimit.value
    S.save("entryLimitOptionValue", chooseDateLimit.value)
    switch chooseDateLimit.value
        when "1" then setEntryLimit(250)
        when "2" then setEntryLimit(500)
        when "3" then setEntryLimit(1000)
        when "4" then setEntryLimit(2500)
        when "5" then setEntryLimit(5000)
        when "6" then setEntryLimit(10000)
        else log "unknown value: "+chooseDateLimit.value
    # mindateDisplay.textContent = data.getMinDate()
    table.refresh()
    return

############################################################
setEntryLimit = (entryLimit) ->
    data.setEntryLimit(entryLimit)
    log entryLimit
    # entryLimitDisplay.textContent = " #{entryLimit} Einträge"
    return

############################################################
export setPatientString = (patientString) ->
    patientNameIndication.textContent = patientString
    return
