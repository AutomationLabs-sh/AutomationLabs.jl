# Copyright (c) 2022: Pierre Blaud and contributors
########################################################
# This Source Code Form is subject to the terms of the #
# Mozilla Public License, v. 2.0. If a copy of the MPL #
# was not distributed with this file,  				   #
# You can obtain one at https://mozilla.org/MPL/2.0/.  #
########################################################
module ProjectTest

using Test
using AutomationLabs

@testset "Project command test" begin

    # Create a project with name
    project(:create, name = "jean_claude")

    #List project
    project(:ls)

    #remove project
    project(:rm, name = "jean_claude")

    #List project
    project(:ls)

end

end
