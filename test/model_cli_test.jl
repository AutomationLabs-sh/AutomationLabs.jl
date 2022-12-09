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

@testset "Training the first model" begin

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

    data(:ls, project_name = "qtp_test")

    model(
        :tune;
        project_name = "qtp_test",
        model_name = "test_1",
        io = "io_qtp",
        computation_verbosity = 5,
        computation_solver = "lls",
        model_architecture = "linear",
    )

    model(
        :tune;
        project_name = "qtp_test",
        model_name = "test_fnn_threads2",
        io = "io_qtp",
        computation_verbosity = 5,
        computation_solver = "radam",
        computation_maximum_time = Dates.Minute(5),
        model_architecture = "fnn",
        computation_processor = "cpu_threads",
    )

    model(:stats, project_name = "qtp_test", model_name = "test_fnn_threads2")

    model(:ls, project_name = "qtp_test")

    model(:rm, project_name = "qtp_test", model_name = "test_1")

    model(:rm, project_name = "qtp_test", model_name = "test_fnn_threads2")

    data(:rmio, project_name = "qtp_test", data_name = "io_qtp")

    data(:rmraw, project_name = "qtp_test", data_name = "data_inputs_m3h")

    data(:rmraw, project_name = "qtp_test", data_name = "data_outputs")

    project(:rm, name = "qtp_test")

end

end
