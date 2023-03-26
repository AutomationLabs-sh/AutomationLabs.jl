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

    # Raw data evaluation
    path = pwd() * "/data_QTP/"
    data(:add; project_name = "qtp_test", path = path, name = "data_inputs_m3h")

    data(:add; project_name = "qtp_test", path = path, name = "data_outputs")

    data_raw_db = data(:lsraw, project_name = "qtp_test")

    @test data_raw_db != nothing
    @test data_raw_db[:,3] == [ "data_inputs_m3h",
                                "data_outputs"
    ]

    data(:lsraw, project_name = "qtp_test", show_all = true)

    # Io data evaluation
    data(
        :io;
        inputs_data_name = "data_inputs_m3h",
        outputs_data_name = "data_outputs",
        project_name = "qtp_test",
        data_name = "io_qtp",
    )


    data_io_db = data(:lsio, project_name = "qtp_test")

    @test data_io_db != nothing
    @test data_io_db[:, 3] == ["io_qtp"] 

    data(:lsio, project_name = "qtp_test", show_all = true)


    data_ls_db = data(:ls, project_name = "qtp_test")
    @test data_ls_db != nothing
    @test data_ls_db[:, 3] ==  ["data_inputs_m3h",
                                "data_outputs",
                                "io_qtp"
    ]

    data(:ls, project_name = "qtp_test", show_all = true)


    # Remove the data
    data(:rmraw, project_name = "qtp_test", data_name = "data_inputs_m3h")

    data(:rmraw, project_name = "qtp_test", data_name = "data_outputs")

    data_raw_db = data(:lsraw, project_name = "qtp_test")

    @test size(data_raw_db) == (0, 6)

    data(:rmio, project_name = "qtp_test", data_name = "io_qtp")

    data_io_db = data(:lsio, project_name = "qtp_test")

    @test size(data_io_db) == (0, 6)

    project(:rm, name = "qtp_test")

end

end
