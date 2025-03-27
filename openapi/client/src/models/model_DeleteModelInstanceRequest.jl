# This file was generated by the Julia OpenAPI Code Generator
# Do not modify this file directly. Modify the OpenAPI specification instead.


@doc raw"""DeleteModelInstanceRequest

    DeleteModelInstanceRequest(;
        instance_id=nothing,
    )

    - instance_id::String : ID of the model instance to delete
"""
Base.@kwdef mutable struct DeleteModelInstanceRequest <: OpenAPI.APIModel
    instance_id::Union{Nothing, String} = nothing

    function DeleteModelInstanceRequest(instance_id, )
        OpenAPI.validate_property(DeleteModelInstanceRequest, Symbol("instance_id"), instance_id)
        return new(instance_id, )
    end
end # type DeleteModelInstanceRequest

const _property_types_DeleteModelInstanceRequest = Dict{Symbol,String}(Symbol("instance_id")=>"String", )
OpenAPI.property_type(::Type{ DeleteModelInstanceRequest }, name::Symbol) = Union{Nothing,eval(Base.Meta.parse(_property_types_DeleteModelInstanceRequest[name]))}

function check_required(o::DeleteModelInstanceRequest)
    o.instance_id === nothing && (return false)
    true
end

function OpenAPI.validate_property(::Type{ DeleteModelInstanceRequest }, name::Symbol, val)

    if name === Symbol("instance_id")
        OpenAPI.validate_param(name, "DeleteModelInstanceRequest", :format, val, "uuid")
    end
end
