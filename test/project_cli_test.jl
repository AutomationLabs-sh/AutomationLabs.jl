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
    pjt = project(:ls)
    project(:ls, show_all = true)

    @test findall( x -> occursin("jean_claude", x), pjt[:, 1]) != Int64[]

    #remove project
    project(:rm, name = "jean_claude")

    #List project
    pjt_2 =  project(:ls)
    project(:ls, show_all = true)

    @test pjt != pjt_2

    @test findall( x -> occursin("jean_claude", x), pjt_2[:, 1]) == Int64[]

end

@testset "Project error message test" begin

    # Wrong args
    project(:gt)

    # Create a project with random name
    rslt = project(:create)
    @test rslt == true

    # List project
    pjt = project(:ls)
    project(:ls, show_all = true)
    @test size(pjt) == (1, 7)

    # Remove project
    rslt = project(:rm, name = "gt")
    @test rslt == false

    rslt = project(:rm, name = pjt[1])
    @test rslt == true

    # List project
    pjt = project(:ls)
    project(:ls, show_all = true)
    @test size(pjt) == (0, 7)

end

end
