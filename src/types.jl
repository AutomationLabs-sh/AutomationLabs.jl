# Copyright (c) 2022: Pierre Blaud and contributors
########################################################
# This Source Code Form is subject to the terms of the #
# Mozilla Public License, v. 2.0. If a copy of the MPL #
# was not distributed with this file,  				   #
# You can obtain one at https://mozilla.org/MPL/2.0/.  #
########################################################

"""
AbstractModel
An abstract type that should be subtyped for model extensions (linear or non linear)
"""
abstract type AbstractModel end

"""
    ContinuousLinearModel
Model linear implementation with AutomationLabs.

** Fields **
* `A`: state matrix.
* `B`: input matrix.
"""
struct ContinuousLinearModel <: AbstractModel
    A::Union{Matrix,Vector}
    B::Union{Matrix,Vector}
    nbr_state::Int
    nbr_input::Int
end

"""
    DiscreteLinearModel
Model linear implementation with AutomationLabs.

** Fields **
* `A`: state matrix.
* `B`: input matrix.
"""
struct DiscreteLinearModel <: AbstractModel
    A::Union{Matrix,Vector}
    B::Union{Matrix,Vector}
    nbr_state::Int
    nbr_input::Int
end

"""
    ContinuousNonLinearModel
Model non linear implementation with AutoamtionLabs.

** Fields **
* `f`: the non linear model.
* `nbr_state`: the state number.
* `nbr_input`: the input number
"""
struct ContinuousNonLinearModel <: AbstractModel
    f::Function
    nbr_state::Int
    nbr_input::Int
end

"""
    DiscreteNonLinearModel
Model non linear implementation with AutoamtionLabs.

** Fields **
* `f`: the non linear model.
* `nbr_state`: the state number.
* `nbr_input`: the input number
"""
struct DiscreteNonLinearModel <: AbstractModel
    f::Function
    nbr_state::Int
    nbr_input::Int
end
