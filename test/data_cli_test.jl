# Copyright (c) 2022: Pierre Blaud and contributors
########################################################
# This Source Code Form is subject to the terms of the #
# Mozilla Public License, v. 2.0. If a copy of the MPL #
# was not distributed with this file,  				   #
# You can obtain one at https://mozilla.org/MPL/2.0/.  #
########################################################
module DataTest

using Test
using AutomationLabs

@testset "Data add, io, ls rm, command line interface test" begin

    project(:create, name = "qtp_test")

    path = pwd() * "/data_QTP/"
    data(:add; project_name = "qtp_test", path = path, name = "data_inputs_m3h")

    data(:add; project_name = "qtp_test", path = path, name = "data_outputs")

    data(
        :io;
        inputs_data_name = "data_inputs_m3h",
        outputs_data_name = "data_outputs",
        project_name = "qtp_test",
        data_name = "io_qtp",
    )

    data(:lsraw, project_name = "qtp_test")

    data(:lsio, project_name = "qtp_test")

    data(:ls, project_name = "qtp_test")

    data(:rmraw, project_name = "qtp_test", data_name = "data_inputs_m3h")

    data(:rmraw, project_name = "qtp_test", data_name = "data_outputs")

    data(:rmio, project_name = "qtp_test", data_name = "io_qtp")

    project(:rm, name = "qtp_test")
end

end
