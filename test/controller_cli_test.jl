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
using JLD

@testset "Controller test" begin

    project(:create, name = "qtp_test")

    project(:ls)

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
    )

    data(:ls, project_name = "qtp_test")

    model(
        :tune;
        project_name = "qtp_test",
        model_name = "test_1",
        io = "io_qtp",
        computation_verbosity = 0,
        computation_solver = "lls",
        computation_maximum_time = Dates.Minute(5),
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

    model(:ls, project_name = "qtp_test")

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

    c = controller(
        :tune;
        project_name = "qtp_test",
        model_name = "test_1",
        controller_name = "controller_1",
        mpc_controller_type = "model_predictive_control",
        mpc_programming_type = "linear",
        mpc_lower_state_constraints = mpc_lower_state_constraints,
        mpc_higher_state_constraints = mpc_higher_state_constraints,
        mpc_lower_input_constraints = mpc_lower_input_constraints,
        mpc_higher_input_constraints = mpc_higher_input_constraints,
        mpc_horizon = 6,
        mpc_sample_time = 5,
        mpc_state_reference = mpc_state_reference,
        mpc_input_reference = mpc_input_reference,
    )

    controller(:ls, project_name = "qtp_test")

    initialization = [0.6, 0.6, 0.6, 0.6]

    c = controller(:calculate; initialization = initialization, predictive_controller = c)

    c.computation_results.x
    c.computation_results.u
    c.computation_results.e_x
    c.computation_results.e_u

    c2 = controller(
        :tune;
        project_name = "qtp_test",
        model_name = "test_2",
        controller_name = "controller_2",
        mpc_controller_type = "model_predictive_control",
        mpc_programming_type = "non_linear",
        mpc_lower_state_constraints = mpc_lower_state_constraints,
        mpc_higher_state_constraints = mpc_higher_state_constraints,
        mpc_lower_input_constraints = mpc_lower_input_constraints,
        mpc_higher_input_constraints = mpc_higher_input_constraints,
        mpc_horizon = 25,
        mpc_sample_time = 5,
        mpc_state_reference = mpc_state_reference,
        mpc_input_reference = mpc_input_reference,
        mpc_solver = "ipopt",
    )

    initialization = [0.6, 0.6, 0.6, 0.6]

    c2 = controller(:calculate; initialization = initialization, predictive_controller = c2)

    c2.computation_results.x
    c2.computation_results.u
    c2.computation_results.e_x
    c2.computation_results.e_u


end


@testset "Controller load test" begin

    controller(:ls, project_name = "qtp_test")

    c = controller(:load, project_name = "qtp_test", controller_name = "controller_1")

    initialization = [0.6, 0.6, 0.6, 0.6]

    c = controller(:calculate; initialization = initialization, predictive_controller = c)

    c.computation_results.x
    c.computation_results.u
    c.computation_results.e_x
    c.computation_results.e_u

    controller(:ls, project_name = "qtp_test")

    controller(:rm, project_name = "qtp_test", controller_name = "controller_1")

    model(:rm, project_name = "qtp_test", model_name = "test_1")

    data(:rmraw, project_name = "qtp_test", data_name = "data_inputs_m3h")

    data(:rmraw, project_name = "qtp_test", data_name = "data_outputs")

    data(:rmio, project_name = "qtp_test", data_name = "io_qtp")

    project(:rm, name = "qtp_test")

end


@testset "Create a MPC controller from a system from user defined discrete linear model" begin

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

    model(:ls, project_name = "qtp_test")

    system(:tune,
        project_name = "qtp_test", 
        system_name = "system_1", 
        model_name = "user_linear",
        input_constraint = u_cons, 
        state_constraint = x_cons,      
    )

    system(:ls, project_name = "qtp_test" )

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
        model_name = "test_2",
        controller_name = "controller_2",
        mpc_controller_type = "model_predictive_control",
        mpc_programming_type = "linear",
        mpc_horizon = 25,
        mpc_sample_time = 5,
        mpc_state_reference = mpc_state_reference,
        mpc_input_reference = mpc_input_reference,
    )






    system(:rm, project_name = "qtp_test", system_name = "system_1",)

    model(:rm, project_name = "qtp_test", model_name = "user_linear")

    project(:rm, name = "qtp_test")

end





end
