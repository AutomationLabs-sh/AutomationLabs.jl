# Copyright (c) 2022: Pierre Blaud and contributors
########################################################
# This Source Code Form is subject to the terms of the #
# Mozilla Public License, v. 2.0. If a copy of the MPL #
# was not distributed with this file,  				   #
# You can obtain one at https://mozilla.org/MPL/2.0/.  #
########################################################
module DashTest

using Test
using AutomationLabs

@testset "Dash test" begin

    project(:create, name = "qtp_test")

    project(:ls)

    data(:add; project_name = "qtp_test", path = "./data_QTP/", name = "data_inputs_m3h")

    data(:add; project_name = "qtp_test", path = "./data_QTP/", name = "data_outputs")

    lower_in = [0.2 0.2 0.2 0.2 -Inf -Inf]
    upper_in = [1.2 1.2 1.2 1.2 Inf Inf]

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


    dash(
        :rawdata,
        project_name = "qtp_test",
        data_name = "data_inputs_m3h",
        recipe = "box",
        dash_name = "dash_box_qtp",
    )

    dash(
        :rawdata,
        project_name = "qtp_test",
        data_name = "data_inputs_m3h",
        recipe = "temporal",
        dash_name = "dash_temporal_qtp",
    )

    dash(
        :iodata,
        project_name = "qtp_test",
        data_name = "io_qtp",
        recipe = "box",
        dash_name = "iodash_box_qtp",
    )

    dash(
        :iodata,
        project_name = "qtp_test",
        data_name = "io_qtp",
        recipe = "temporal",
        dash_name = "iodash_temporal_qtp",
    )

    dash(:ls, project_name = "qtp_test")

    dash(:rm, project_name = "qtp_test", dash_name = "iodash_temporal_qtp")
    dash(:rm, project_name = "qtp_test", dash_name = "iodash_box_qtp")

    dash(:rm, project_name = "qtp_test", dash_name = "dash_box_qtp")
    dash(:rm, project_name = "qtp_test", dash_name = "dash_temporal_qtp")

    data(:rmio, project_name = "qtp_test", data_name = "io_qtp")

    data(:rmraw, project_name = "qtp_test", data_name = "data_inputs_m3h")

    data(:rmraw, project_name = "qtp_test", data_name = "data_outputs")

    project(:rm, name = "qtp_test")
end

end
