# Copyright (c) 2022: Pierre Blaud and contributors
########################################################
# This Source Code Form is subject to the terms of the #
# Mozilla Public License, v. 2.0. If a copy of the MPL #
# was not distributed with this file,  				   #
# You can obtain one at https://mozilla.org/MPL/2.0/.  #
########################################################

module SystemTest

using Test
using Dates
using AutomationLabs

@testset "Tuning a system from a identified model" begin

    project(:create, name = "qtp_test")

    project(:ls, show_all = true)

    data(:add; project_name = "qtp_test", path = "./data_QTP/", name = "data_inputs_m3h")

    data(:add; project_name = "qtp_test", path = "./data_QTP/", name = "data_outputs")

    lower_in = [0.2 0.2 0.2 0.2 0.2 0.2]
    upper_in = [1.2 1.2 1.2 1.2 1.2 1.2]

    lower_out = [0.2 0.2 0.2 0.2]
    upper_out = [1.2 1.2 1.2 1.2]

    data(
        :io;
        inputs_data_name = "data_inputs_m3h",
        outputs_data_name = "data_outputs",
        project_name = "qtp_test",
        data_name = "io_qtp",
        data_lower_input = lower_in,
        data_upper_input = upper_in,
        data_lower_output = lower_out,
        data_upper_output = upper_out,
        data_type = Float32,
    )

    data(:ls, project_name = "qtp_test", show_all = true)

    model(
        :tune;
        project_name = "qtp_test",
        model_name = "test_1",
        io = "io_qtp",
        computation_verbosity = 0,
        computation_solver = "lls",
        model_architecture = "linear",
    )

    model(
        :tune;
        project_name = "qtp_test",
        model_name = "test_2",
        io = "io_qtp",
        computation_verbosity = 0,
        computation_solver = "radam",
        computation_maximum_time = Dates.Minute(5),
        model_architecture = "fnn",
        computation_processor = "cpu_threads",
    )

    model(:ls, project_name = "qtp_test", show_all = true)

    # Constraints 
    x_cons = [ 0.2 1.2; 
                0.2 1.2;
                0.2 1.2;
                0.2 1.2;               
                ]

    u_cons = [0 3;
              0 3]

    ### Non linear systems 

    # tune a system without constraints 
    system(:tune,
           project_name = "qtp_test", 
           system_name = "system_1", 
           model_name = "test_2"   
    )

    system(:ls, project_name = "qtp_test", show_all = true )
    sys_1 = system(:ls, project_name = "qtp_test" )
    @test size(sys_1) == (1, 6)
    @test sys_1[:, 3] == ["system_1"]
    
    # Tune a system with input constraints 
    system(:tune,
           project_name = "qtp_test", 
           system_name = "system_ucons", 
           model_name = "test_2",
           input_constraint = u_cons, 
    )

    system(:ls, project_name = "qtp_test", show_all = true )
    sys_2 = system(:ls, project_name = "qtp_test" )
    @test size(sys_2) == (2, 6)
    @test sys_2[:, 3] == ["system_1"; "system_ucons"]

    # tune a system with state and input constraints
    system(:tune,
           project_name = "qtp_test", 
           system_name = "system_xcons_ucons", 
           model_name = "test_2",
           input_constraint = u_cons, 
           state_constraint = x_cons,      
    )

    system(:ls, project_name = "qtp_test", show_all = true )
    sys_3 = system(:ls, project_name = "qtp_test" )
    @test size(sys_3) == (3, 6)
    @test sys_3[:, 3] == ["system_1"; "system_ucons"; "system_xcons_ucons"]

    # Stats the systems 
    sys_stats_1 = system(:stats,
        project_name = "qtp_test", 
        system_name = "system_1",
    )
    system(:stats,
        project_name = "qtp_test", 
        system_name = "system_1",
        show_all = true
    )
    @test size(sys_stats_1) == (3,)

    sys_stats_ucons = system(:stats,
        project_name = "qtp_test", 
        system_name = "system_ucons",
    )
    system(:stats,
        project_name = "qtp_test", 
        system_name = "system_ucons",
        show_all = true
    )   
    @test size(sys_stats_ucons) == (3,)

    sys_stats_xuconbs = system(:stats,
           project_name = "qtp_test", 
           system_name = "system_xcons_ucons",

    )
    system(:stats,
           project_name = "qtp_test", 
           system_name = "system_xcons_ucons",
           show_all = true
    )
    @test size(sys_stats_xuconbs) == (3,)

    ### Linear system from identification

    # tune a system without constraints 
    system(:tune,
           project_name = "qtp_test", 
           system_name = "system_linear_1", 
           model_name = "test_1"   
    )

    system(:ls, project_name = "qtp_test", show_all = true )
    sys_4 = system(:ls, project_name = "qtp_test" )
    @test size(sys_4) == (4, 6)
    @test sys_4[:, 3] == ["system_1"; "system_ucons"; "system_xcons_ucons"; "system_linear_1"]

    # Tune a system with input constraints 
    system(:tune,
           project_name = "qtp_test", 
           system_name = "system_linear_ucons", 
           model_name = "test_1",
           input_constraint = u_cons, 
    )

    system(:ls, project_name = "qtp_test", show_all = true )
    sys_5 = system(:ls, project_name = "qtp_test" )
    @test size(sys_5) == (5, 6)
    @test sys_5[:, 3] == ["system_1"; 
                        "system_ucons";     
                        "system_xcons_ucons"; 
                        "system_linear_1";
                        "system_linear_ucons"]


    # tune a system with state and input constraints
    system(:tune,
           project_name = "qtp_test", 
           system_name = "system_linear_xcons_ucons", 
           model_name = "test_2",
           input_constraint = u_cons, 
           state_constraint = x_cons,      
    )

    system(:ls, project_name = "qtp_test", show_all = true )
    sys_6 = system(:ls, project_name = "qtp_test" )
    @test size(sys_6) == (6, 6)
    @test sys_6[:, 3] == ["system_1"; 
                        "system_ucons";     
                        "system_xcons_ucons"; 
                        "system_linear_1";
                        "system_linear_ucons";
                        "system_linear_xcons_ucons"]


    pjt_result = project(:ls)
    @test pjt_result[1, 5] == 6

    # Delete the systems 
    system(:rm, project_name = "qtp_test", system_name = "system_1")
    system(:rm, project_name = "qtp_test", system_name = "system_ucons")
    system(:rm, project_name = "qtp_test", system_name = "system_xcons_ucons")
    system(:rm, project_name = "qtp_test", system_name = "system_linear_1")
    system(:rm, project_name = "qtp_test", system_name = "system_linear_ucons")
    system(:rm, project_name = "qtp_test", system_name = "system_linear_xcons_ucons")

    # Delete the models
    model(:rm, project_name = "qtp_test", model_name = "test_1")
    model(:rm, project_name = "qtp_test", model_name = "test_2")

    # Delete the data 
    data(:rmraw, project_name = "qtp_test", data_name = "data_inputs_m3h")
    data(:rmraw, project_name = "qtp_test", data_name = "data_outputs")
    data(:rmio, project_name = "qtp_test", data_name = "io_qtp")

    # Delete the project 
    pjt_result = project(:ls)
    @test pjt_result[1, 2] == 0
    @test pjt_result[1, 4] == 0
    @test pjt_result[1, 5] == 0

    # Delete the project 
    project(:rm, name = "qtp_test")

end

@testset "Create a system from user defined discrete linear model" begin

    A = [
        1 1
        0 0.9
    ]
    B = [1; 0.5]
    nbr_state = 2
    nbr_input = 1

    x_cons =  [0.2 1.2;
               0.2 1.2;       
    ]

    u_cons = [0  4;
              0   4]

    project(:create, name = "qtp_test")

    project(:ls)

    model(
        :create;
        project_name = "qtp_test",
        model_name = "user_linear",
        variation = "discrete",
        A = A,
        B = B, 
        nbr_state = nbr_state,
        nbr_input = nbr_input,
    )

    list_model = model(:ls, project_name = "qtp_test")
    @test size(list_model) == (1, 6)
    @test list_model[:, 3] == ["user_linear"]

    model(:ls, project_name = "qtp_test", show_all = true)

    system(:tune,
        project_name = "qtp_test", 
        system_name = "system_1", 
        model_name = "user_linear",
        input_constraint = u_cons, 
        state_constraint = x_cons,      
    )

    system(:ls, project_name = "qtp_test", show_all = true )

    sys_6 = system(:ls, project_name = "qtp_test" )
    @test size(sys_6) == (1, 6)
    @test sys_6[:, 3] == ["system_1"]

    # Stats the system 
    sys_stats = system(:stats,
        project_name = "qtp_test", 
        system_name = "system_1",
    )
    @test size(sys_stats) == (3,)

    system(:stats,
        project_name = "qtp_test", 
        system_name = "system_1",
        show_all = true,
    )

    # Delete the system and the model
    system(:rm, project_name = "qtp_test", system_name = "system_1",)
    model(:rm, project_name = "qtp_test", model_name = "user_linear")

    # Delete the project 
    pjt_result = project(:ls)
    @test pjt_result[1, 2] == 0
    @test pjt_result[1, 4] == 0
    @test pjt_result[1, 5] == 0

    # Delete the project 
    project(:rm, name = "qtp_test")

end

@testset "System error message test" begin

    project(:create, name = "qtp_test")

    project(:ls)

    # Wrong arguments
    system(:gt)

    # Wrong ls 
    system(:ls, project_name = "qtp_test", show_all = true)
    rslt = system(:ls, project_name = "gt")
    @test size(rslt) == (0, 6)

    # Wrong rm 
    rslt = system(:rm, project_name = "qtp_test")
    @test rslt == nothing
    rslt = system(:rm, system_name = "gt")
    @test rslt == nothing

    # Wrong stats 
    rslt = system(:stats, project_name = "qtp_test")
    @test rslt == nothing
    rslt = system(:stats, system_name = "gt")
    @test rslt == nothing

    # Wrong tune 
    rlst = system(:tune, project_name = "qtp_test")
    @test rslt == nothing
    rlst = system(:tune, model_name = "gt")
    @test rslt == nothing

end



end