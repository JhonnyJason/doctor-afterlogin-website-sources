
import { addModulesToDebug } from "thingy-debug"

############################################################
export modulesToDebug = {
    configmodule: true
    # datamodule: true
    # overviewtablemodule: true
    patientapprovalmodule: true
}

addModulesToDebug(modulesToDebug)