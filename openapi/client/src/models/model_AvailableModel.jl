# This file was generated by the Julia OpenAPI Code Generator
# Do not modify this file directly. Modify the OpenAPI specification instead.


@doc raw"""AvailableModel

    AvailableModel(;
        details=nothing,
        config=nothing,
    )

    - details::AvailableModelDetails
    - config::Dict{String, Any} : The entire model configuration as in the &#x60;config.yaml&#x60; file.  May include arbitrary fields, which are not part of the public interface. Note that this information also includes the properties from the &#x60;details&#x60; object. 
"""
Base.@kwdef mutable struct AvailableModel <: OpenAPI.APIModel
    details = nothing # spec type: Union{ Nothing, AvailableModelDetails }
    config::Union{Nothing, Dict{String, Any}} = nothing

    function AvailableModel(details, config, )
        OpenAPI.validate_property(AvailableModel, Symbol("details"), details)
        OpenAPI.validate_property(AvailableModel, Symbol("config"), config)
        return new(details, config, )
    end
end # type AvailableModel

const _property_types_AvailableModel = Dict{Symbol,String}(Symbol("details")=>"AvailableModelDetails", Symbol("config")=>"Dict{String, Any}", )
OpenAPI.property_type(::Type{ AvailableModel }, name::Symbol) = Union{Nothing,eval(Base.Meta.parse(_property_types_AvailableModel[name]))}

function check_required(o::AvailableModel)
    o.details === nothing && (return false)
    o.config === nothing && (return false)
    true
end

function OpenAPI.validate_property(::Type{ AvailableModel }, name::Symbol, val)


end
