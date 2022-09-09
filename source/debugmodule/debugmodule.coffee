
import { addModulesToDebug } from "thingy-debug"

############################################################
export modulesToDebug = {
    # configmodule: true
    # datamodule: true#
    # loadcontrolsmodule: true
    modecontrolsmodule: true
    # overviewtablemodule: true
    # patientapprovalmodule: true
    userprocessmodule: true
}

addModulesToDebug(modulesToDebug)