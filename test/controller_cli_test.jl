# Copyright (c) 2022: Pierre Blaud and contributors
########################################################
# This Source Code Form is subject to the terms of the #
# Mozilla Public License, v. 2.0. If a copy of the MPL #
# was not distributed with this file,  				   #
# You can obtain one at https://mozilla.org/MPL/2.0/.  #
########################################################
module ControllerTest

using Test
using AutomationLabs
using Dates

@testset "Controller tuning test" begin

    project(:create, name = "qtp_test")

    data(:add; project_name = "qtp_test", path = "./data_QTP/", name = "data_inputs_m3h")

    data(:add; project_name = "qtp_test", path = "./data_QTP/", name = "data_outputs")

    lower_in = [0.2 0.2 0.2 0.2 0.1 0.1] #-Inf -Inf]
    upper_in = [1.2 1.2 1.2 1.2 Inf Inf] # Inf Inf]

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

    data_raw_db = data(:lsraw, project_name = "qtp_test")
    @test size(data_raw_db) == (2, 6)

    data_io_db = data(:lsio, project_name = "qtp_test")
    @test size(data_io_db) == (1, 6)

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

    model_result = model(:ls, project_name = "qtp_test")
    @test size(model_result) == (2, 6)

    # Controller definition 
    hmin = 0.2
    h1max = 1.36
    h2max = 1.36
    h3max = 1.30
    h4max = 1.30
    qmin = 0
    qamax = 4
    qbmax = 3.26

    # Constraint definition:
    mpc_lower_state_constraints = [hmin, hmin, hmin, hmin]
    mpc_higher_state_constraints = [h1max, h2max, h3max, h4max]
    mpc_lower_input_constraints = [qmin, qmin]
    mpc_higher_input_constraints = [qamax, qbmax]

    mpc_state_reference = [0.65, 0.65, 0.65, 0.65]
    mpc_input_reference = [1.2, 1.2]


    # Create the system

    # Tune a system with input constraints 
    u_cons = [  0 1.2;
                0 1.2]

    system(:tune,
            project_name = "qtp_test", 
            system_name = "system_linear_ucons", 
            model_name = "test_1",
            input_constraint = u_cons, 
    )

    system(:tune,
           project_name = "qtp_test", 
           system_name = "system_non_linear_ucons", 
           model_name = "test_2",
           input_constraint = u_cons, 
    )

    ### Tune the linear controller ### 

    controller(
        :tune;
        project_name = "qtp_test",
        system_name = "system_linear_ucons",
        controller_name = "controller_linear",
        mpc_controller_type = "model_predictive_control",
        mpc_horizon = 6,
        mpc_sample_time = 5,
        mpc_state_reference = mpc_state_reference,
        mpc_input_reference = mpc_input_reference,
    )

    ### Tune the non linear controller ###

    controller(
        :tune;
        project_name = "qtp_test",
        system_name = "system_non_linear_ucons",
        controller_name = "controller_non_linear",
        mpc_controller_type = "model_predictive_control",
        mpc_horizon = 6,
        mpc_sample_time = 5,
        mpc_state_reference = mpc_state_reference,
        mpc_input_reference = mpc_input_reference,
    )

    controller(:ls, project_name = "qtp_test", show_all = true)
    list_controller = controller(:ls, project_name = "qtp_test")
    @test size(list_controller) == (2, 6)
    @test list_controller[:, 3] == ["controller_linear", "controller_non_linear"]

    # Remove the controllers
    controller(:rm, project_name = "qtp_test", controller_name = "controller_linear")
    controller(:rm, project_name = "qtp_test", controller_name = "controller_non_linear")

    controller_result = controller(:ls, project_name = "qtp_test")
    @test size(controller_result) == (0, 6)

    # Remove the systems 
    system(:rm, project_name = "qtp_test", system_name = "system_linear_ucons")
    system(:rm, project_name = "qtp_test", system_name = "system_non_linear_ucons")

    system_result = system(:ls, project_name = "qtp_test")
    @test size(system_result) == (0, 6)

    # Remove the models 
    model(:rm, project_name = "qtp_test", model_name = "test_1")
    model(:rm, project_name = "qtp_test", model_name = "test_2")
    
    model_result = model(:ls, project_name = "qtp_test")
    @test size(model_result) == (0, 6)

    #Remove the data 
    data(:rmio, project_name = "qtp_test", data_name = "io_qtp")
    data(:rmraw, project_name = "qtp_test", data_name = "data_inputs_m3h")
    data(:rmraw, project_name = "qtp_test", data_name = "data_outputs")

    data_raw_db = data(:lsraw, project_name = "qtp_test")
    @test size(data_raw_db) == (0, 6)

    data_io_db = data(:lsio, project_name = "qtp_test")
    @test size(data_io_db) == (0, 6)

    # Remove the project
    project(:rm, name = "qtp_test")
    pjt_result = project(:ls)
    @test size(pjt_result) == (0, 7) 

end

@testset "Controller linear computation test" begin

    project(:create, name = "qtp_test")

    data(:add; project_name = "qtp_test", path = "./data_QTP/", name = "data_inputs_m3h")

    data(:add; project_name = "qtp_test", path = "./data_QTP/", name = "data_outputs")

    lower_in = [0.2 0.2 0.2 0.2 0.1 0.1] #-Inf -Inf]
    upper_in = [1.2 1.2 1.2 1.2 Inf Inf] # Inf Inf]

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

    model(
        :tune;
        project_name = "qtp_test",
        model_name = "test_1",
        io = "io_qtp",
        computation_verbosity = 0,
        computation_solver = "lls",
        model_architecture = "linear",
    )

    # Controller definition 
    hmin = 0.2
    h1max = 1.36
    h2max = 1.36
    h3max = 1.30
    h4max = 1.30
    qmin = 0
    qamax = 4
    qbmax = 3.26
 
    # Constraint definition:
    mpc_lower_state_constraints = [hmin, hmin, hmin, hmin]
    mpc_higher_state_constraints = [h1max, h2max, h3max, h4max]
    mpc_lower_input_constraints = [qmin, qmin]
    mpc_higher_input_constraints = [qamax, qbmax]
 
    mpc_state_reference = [0.65, 0.65, 0.65, 0.65]
    mpc_input_reference = [1.2, 1.2]
 
    # Create the system
 
    # Tune a system with input constraints 
    u_cons = [  0 3;
                 0 3]
 
    system(:tune,
            project_name = "qtp_test", 
            system_name = "system_linear_ucons", 
            model_name = "test_1",
            input_constraint = u_cons, 
    )

    controller(
        :tune;
        project_name = "qtp_test",
        system_name = "system_linear_ucons",
        controller_name = "controller_linear",
        mpc_controller_type = "model_predictive_control",
        mpc_horizon = 6,
        mpc_sample_time = 5,
        mpc_state_reference = mpc_state_reference,
        mpc_input_reference = mpc_input_reference,
    )

    initialization = [0.6, 0.6, 0.6, 0.6]

    controller(
        :calculate; 
        initialization = initialization, 
        controller_name = "controller_linear"
    )

    rslt = controller(
        :retrieve; 
        controller_name = "controller_linear"
    )

    @test rslt.x != nothing
    @test rslt.u != nothing
    @test rslt.e_x != nothing
    @test rslt.e_u != nothing

    # Remove the controllers
    controller(:rm, project_name = "qtp_test", controller_name = "controller_linear")

    controller_result = controller(:ls, project_name = "qtp_test")
    @test size(controller_result) == (0, 6)

    # Remove the systems 
    system(:rm, project_name = "qtp_test", system_name = "system_linear_ucons")

    system_result = system(:ls, project_name = "qtp_test")
    @test size(system_result) == (0, 6)

    # Remove the models 
    model(:rm, project_name = "qtp_test", model_name = "test_1")
    
    model_result = model(:ls, project_name = "qtp_test")
    @test size(model_result) == (0, 6)

    #Remove the data 
    data(:rmio, project_name = "qtp_test", data_name = "io_qtp")
    data(:rmraw, project_name = "qtp_test", data_name = "data_inputs_m3h")
    data(:rmraw, project_name = "qtp_test", data_name = "data_outputs")

    data_raw_db = data(:lsraw, project_name = "qtp_test")
    @test size(data_raw_db) == (0, 6)

    data_io_db = data(:lsio, project_name = "qtp_test")
    @test size(data_io_db) == (0, 6)

    # Remove the project
    project(:rm, name = "qtp_test")
    pjt_result = project(:ls)
    @test size(pjt_result) == (0, 7) 

end

@testset "Controller non linear computation test" begin

    project(:create, name = "qtp_test")

    data(:add; project_name = "qtp_test", path = "./data_QTP/", name = "data_inputs_m3h")

    data(:add; project_name = "qtp_test", path = "./data_QTP/", name = "data_outputs")

    lower_in = [0.2 0.2 0.2 0.2 0.1 0.1] #-Inf -Inf]
    upper_in = [1.2 1.2 1.2 1.2 Inf Inf] # Inf Inf]

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

    model(
        :tune;
        project_name = "qtp_test",
        model_name = "test_1",
        io = "io_qtp",
        computation_verbosity = 0,
        computation_solver = "radam",
        model_architecture = "densenet",
    )

    # Controller definition 
    hmin = 0.2
    h1max = 1.36
    h2max = 1.36
    h3max = 1.30
    h4max = 1.30
    qmin = 0
    qamax = 4
    qbmax = 3.26
 
    # Constraint definition:
    mpc_lower_state_constraints = [hmin, hmin, hmin, hmin]
    mpc_higher_state_constraints = [h1max, h2max, h3max, h4max]
    mpc_lower_input_constraints = [qmin, qmin]
    mpc_higher_input_constraints = [qamax, qbmax]
 
    mpc_state_reference = [0.65, 0.65, 0.65, 0.65]
    mpc_input_reference = [1.2, 1.2]
 
    # Create the system
 
    # Tune a system with input constraints 
    u_cons = [  0 1.2;
                 0 1.2]
 
    system(:tune,
            project_name = "qtp_test", 
            system_name = "system_non_linear_ucons", 
            model_name = "test_1",
            input_constraint = u_cons, 
    )

    controller(
        :tune;
        project_name = "qtp_test",
        system_name = "system_non_linear_ucons",
        controller_name = "controller_non_linear",
        mpc_controller_type = "model_predictive_control",
        mpc_horizon = 6,
        mpc_sample_time = 5,
        mpc_state_reference = mpc_state_reference,
        mpc_input_reference = mpc_input_reference,
    )

    initialization = [0.6, 0.6, 0.6, 0.6]

    controller(
        :calculate; 
        initialization = initialization, 
        controller_name = "controller_non_linear"
    )

    rslt = controller(
        :retrieve; 
        controller_name = "controller_non_linear"
    )

    @test rslt.x != nothing
    @test rslt.u != nothing
    @test rslt.e_x != nothing
    @test rslt.e_u != nothing

    # Remove the controllers
    controller(:rm, project_name = "qtp_test", controller_name = "controller_non_linear")

    controller_result = controller(:ls, project_name = "qtp_test")
    @test size(controller_result) == (0, 6)

    # Remove the systems 
    system(:rm, project_name = "qtp_test", system_name = "system_non_linear_ucons")

    system_result = system(:ls, project_name = "qtp_test")
    @test size(system_result) == (0, 6)

    # Remove the models 
    model(:rm, project_name = "qtp_test", model_name = "test_1")
    
    model_result = model(:ls, project_name = "qtp_test")
    @test size(model_result) == (0, 6)

    #Remove the data 
    data(:rmio, project_name = "qtp_test", data_name = "io_qtp")
    data(:rmraw, project_name = "qtp_test", data_name = "data_inputs_m3h")
    data(:rmraw, project_name = "qtp_test", data_name = "data_outputs")

    data_raw_db = data(:lsraw, project_name = "qtp_test")
    @test size(data_raw_db) == (0, 6)

    data_io_db = data(:lsio, project_name = "qtp_test")
    @test size(data_io_db) == (0, 6)

    # Remove the project
    project(:rm, name = "qtp_test")
    pjt_result = project(:ls)
    @test size(pjt_result) == (0, 7) 

end

@testset "Cobntroller from user defined discrete linear model" begin

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

    system(:tune,
        project_name = "qtp_test", 
        system_name = "system_user_linear", 
        model_name = "user_linear",
        input_constraint = u_cons, 
        state_constraint = x_cons,      
    )

    # Controller definition 
    hmin = 0.2
    h1max = 1.36
    h2max = 1.36
    h3max = 1.30
    h4max = 1.30
    qmin = 0
    qamax = 4
    qbmax = 3.26
    
    #Constraint definition:
    mpc_lower_state_constraints = [hmin, hmin, hmin, hmin]
    mpc_higher_state_constraints = [h1max, h2max, h3max, h4max]
    mpc_lower_input_constraints = [qmin, qmin]
    mpc_higher_input_constraints = [qamax, qbmax]
    
    mpc_state_reference = [0.65, 0.65, 0.65, 0.65]
    mpc_input_reference = [1.2, 1.2]

    controller(
        :tune;
        project_name = "qtp_test",
        system_name = "system_user_linear",
        controller_name = "controller_user_linear",
        mpc_controller_type = "model_predictive_control",
        mpc_horizon = 6,
        mpc_sample_time = 5,
        mpc_state_reference = mpc_state_reference,
        mpc_input_reference = mpc_input_reference,
    )

    initialization = [0.6, 0.6, 0.6, 0.6]

    controller(
        :calculate; 
        initialization = initialization, 
        controller_name = "controller_user_linear"
    )

    rslt = controller(
        :retrieve; 
        controller_name = "controller_user_linear"
    )

    @test rslt.x != nothing
    @test rslt.u != nothing
    @test rslt.e_x != nothing
    @test rslt.e_u != nothing

    # Remove the controllers
    controller(:rm, project_name = "qtp_test", controller_name = "controller_user_linear")

    controller_result = controller(:ls, project_name = "qtp_test")
    @test size(controller_result) == (0, 6)

    # Remove the systems 
    system(:rm, project_name = "qtp_test", system_name = "system_user_linear")

    system_result = system(:ls, project_name = "qtp_test")
    @test size(system_result) == (0, 6)

    # Remove the models 
    model(:rm, project_name = "qtp_test", model_name = "user_linear")
    
    model_result = model(:ls, project_name = "qtp_test")
    @test size(model_result) == (0, 6)

    #Remove the data 
    data(:rmio, project_name = "qtp_test", data_name = "io_qtp")
    data(:rmraw, project_name = "qtp_test", data_name = "data_inputs_m3h")
    data(:rmraw, project_name = "qtp_test", data_name = "data_outputs")

    data_raw_db = data(:lsraw, project_name = "qtp_test")
    @test size(data_raw_db) == (0, 6)

    data_io_db = data(:lsio, project_name = "qtp_test")
    @test size(data_io_db) == (0, 6)

    # Remove the project
    project(:rm, name = "qtp_test")
    pjt_result = project(:ls)
    @test size(pjt_result) == (0, 7) 

end

@testset "Controller error message test" begin

    rslt = controller(:ki)
    @test rslt == nothing

    rslt = controller(:ls, project_ = "1")
    @test rslt == nothing

    rslt = controller(:rm, project = "1")
    @test rslt == nothing

    rslt = controller(:rm, project_name = "1")
    @test rslt == nothing

    rslt = controller(:tune, project = "1")
    @test rslt == nothing

    rslt = controller(:tune, project_name = "1")
    @test rslt == nothing

    rslt = controller(:tune, project_name = "1", system_name = "1")
    @test rslt == nothing

    rslt = controller(:tune, project_name = "1", system_name = "1", mpc_horizon = 1)
    @test rslt == nothing

    rslt = controller(:tune, project_name = "1", system_name = "1", mpc_horizon = 1, mpc_sample_time = 5)
    @test rslt == nothing

    rslt = controller(:tune, project_name = "1", system_name = "1", mpc_horizon = 1, mpc_sample_time = 5, mpc_state_reference = 1)
    @test rslt == nothing

    rslt = controller(:calculate)
    @test rslt == nothing

    rslt = controller(:calculate, initialization = 1)
    @test rslt == nothing

    #rslt = controller(:calculate, initialization = 1, controller_name = "1")
    #@test rslt == nothing

    rslt = controller(:retrieve)
    @test rslt == nothing

end


end
