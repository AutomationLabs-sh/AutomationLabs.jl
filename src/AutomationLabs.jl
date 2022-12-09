# Copyright (c) 2022: Pierre Blaud and contributors
########################################################
# This Source Code Form is subject to the terms of the #
# Mozilla Public License, v. 2.0. If a copy of the MPL #
# was not distributed with this file,  				   #
# You can obtain one at https://mozilla.org/MPL/2.0/.  #
########################################################

module AutomationLabs

print(" \n\nWelcome to ")
print("Automation")
printstyled("Labs", bold = true, color = :black)

# Import packages
import AutomationLabsDepot
import AutomationLabsIdentification
import AutomationLabsModelPredictiveControl
import JLD # need in module: https://github.com/JuliaIO/JLD.jl/issues/252
import PrettyTables
import Dates
import Random

# Export functions
export data
export project
export model
export config
export dash
export controller

# Load files
include("data_cli.jl")
include("model_cli.jl")
include("project_cli.jl")
include("dash_cli.jl")
include("controller_cli.jl")

end
