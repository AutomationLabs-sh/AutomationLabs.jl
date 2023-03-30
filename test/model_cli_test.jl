# Copyright (c) 2022: Pierre Blaud and contributors
########################################################
# This Source Code Form is subject to the terms of the #
# Mozilla Public License, v. 2.0. If a copy of the MPL #
# was not distributed with this file,  				   #
# You can obtain one at https://mozilla.org/MPL/2.0/.  #
########################################################
module ModelTest

using Test
using Dates
using AutomationLabs

@testset "Training the first model linear and Fnn" begin

    project(:create, name = "qtp_test")

    project(:ls)

    data(:add; project_name = "qtp_test", path = "./data_QTP/", name = "data_inputs_m3h")

    data(:add; project_name = "qtp_test", path = "./data_QTP/", name = "data_outputs")

    lower_in = [0.2 0.2 0.2 0.2 0.2 0.2] #-Inf -Inf]
    upper_in = [1.2 1.2 1.2 1.2 1.2 1.2] # Inf Inf]

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

    data_ls_db = data(:ls, project_name = "qtp_test")

    @test data_ls_db != nothing

    # Tune the linear model
    model(
        :tune;
        project_name = "qtp_test",
        model_name = "test_1",
        io = "io_qtp",
        computation_verbosity = 0,
        computation_solver = "lls",
        model_architecture = "linear",
    )

    # Tune the non linear model
    model(
        :tune;
        project_name = "qtp_test",
        model_name = "test_fnn_threads2",
        io = "io_qtp",
        computation_verbosity = 0,
        computation_solver = "radam",
        computation_maximum_time = Dates.Minute(5),
        model_architecture = "fnn",
        computation_processor = "cpu_threads",
    )

    # List the models 
    model_result = model(:ls, project_name = "qtp_test")

    @test model_result[:, 3] == [  "test_1",
                                    "test_fnn_threads2"
    ]

    model(:ls, project_name = "qtp_test", show_all = true)

    # Models stats
    stats_results = model(:stats, project_name = "qtp_test", model_name = "test_fnn_threads2")

    @test stats_results != nothing
    @test stats_results[3] == "Fnn"

    model(:stats, project_name = "qtp_test", model_name = "test_fnn_threads2", show_all = true)

    # Remove the models

    model(:rm, project_name = "qtp_test", model_name = "test_1")
    model(:rm, project_name = "qtp_test", model_name = "test_fnn_threads2")
    
    model_result = model(:ls, project_name = "qtp_test")
    @test size(model_result) == (0, 6)


    data(:rmio, project_name = "qtp_test", data_name = "io_qtp")
    data(:rmraw, project_name = "qtp_test", data_name = "data_inputs_m3h")
    data(:rmraw, project_name = "qtp_test", data_name = "data_outputs")

    data_raw_db = data(:lsraw, project_name = "qtp_test")
    @test size(data_raw_db) == (0, 6)

    data_io_db = data(:lsio, project_name = "qtp_test")
    @test size(data_io_db) == (0, 6)

    project(:rm, name = "qtp_test")

end

@testset "Create a user defined linear model discrete" begin

    A = [
        1 1
        0 0.9
    ]
    B = [1; 0.5]
    nbr_state = 2
    nbr_input = 1

    project(:create, name = "qtp_test")

    project(:ls, show_all = true)

    model(
        :create;
        project_name = "qtp_test",
        model_name = "user_linear_1",
        variation = "discrete",
        A = A,
        B = B, 
        nbr_state = nbr_state,
        nbr_input = nbr_input,
    )

    model(:ls, project_name = "qtp_test", show_all = true)

    model_ls_result = model(:ls, project_name = "qtp_test")
    @test size(model_ls_result) == (1, 6) 
    @test model_ls_result[:, 3] == ["user_linear_1"]

    # Remove the model
    model(:rm, project_name = "qtp_test", model_name = "user_linear_1")
    model_ls_result = model(:ls, project_name = "qtp_test")
    @test size(model_ls_result) == (0, 6) 

    # Remove the project
    project(:rm, name = "qtp_test")
    pjt_result = project(:ls)
    @test size(pjt_result) == (0, 6) 

end

@testset "Create a user defined non linear model discrete" begin
   
    g = x -> x^2

    nbr_state = 2
    nbr_input = 1

    project(:create, name = "qtp_test")

    project(:ls)

    model(
        :create;
        project_name = "qtp_test",
        model_name = "user_non_linear_1",
        variation = "discrete",
        f = g,
        nbr_state = nbr_state,
        nbr_input = nbr_input,
    )

    model(:ls, project_name = "qtp_test", show_all = true)

    model_ls_result = model(:ls, project_name = "qtp_test")
    @test size(model_ls_result) == (1, 6) 
    @test model_ls_result[:, 3] == ["user_non_linear_1"]

    model(:rm, project_name = "qtp_test", model_name = "user_non_linear_1")

    # Remove the project
    project(:rm, name = "qtp_test")
    pjt_result = project(:ls)
    @test size(pjt_result) == (0, 6) 

end


end
