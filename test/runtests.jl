# Copyright (c) 2022: Pierre Blaud and contributors
########################################################
# This Source Code Form is subject to the terms of the #
# Mozilla Public License, v. 2.0. If a copy of the MPL #
# was not distributed with this file,  				   #
# You can obtain one at https://mozilla.org/MPL/2.0/.  #
########################################################

# Test subfunctions from AutomationPod cli package
print("Testing project cli...")
took_seconds = @elapsed include("./project_cli_test.jl");
println("done (took ", took_seconds, " seconds)")

print("Testing data cli...")
took_seconds = @elapsed include("./data_cli_test.jl");
println("done (took ", took_seconds, " seconds)")

print("Testing model cli...")
took_seconds = @elapsed include("./model_cli_test.jl");
println("done (took ", took_seconds, " seconds)")

print("Testing dash cli...")
took_seconds = @elapsed include("./dash_cli_test.jl");
println("done (took ", took_seconds, " seconds)")

print("Testing controller cli...")
took_seconds = @elapsed include("./controller_cli_test.jl");
println("done (took ", took_seconds, " seconds)")
