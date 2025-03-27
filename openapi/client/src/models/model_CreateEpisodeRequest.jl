# This file was generated by the Julia OpenAPI Code Generator
# Do not modify this file directly. Modify the OpenAPI specification instead.


@doc raw"""CreateEpisodeRequest

    CreateEpisodeRequest(;
        name=nothing,
    )

    - name::String : Name of the episode to create
"""
Base.@kwdef mutable struct CreateEpisodeRequest <: OpenAPI.APIModel
    name::Union{Nothing, String} = nothing

    function CreateEpisodeRequest(name, )
        OpenAPI.validate_property(CreateEpisodeRequest, Symbol("name"), name)
        return new(name, )
    end
end # type CreateEpisodeRequest

const _property_types_CreateEpisodeRequest = Dict{Symbol,String}(Symbol("name")=>"String", )
OpenAPI.property_type(::Type{ CreateEpisodeRequest }, name::Symbol) = Union{Nothing,eval(Base.Meta.parse(_property_types_CreateEpisodeRequest[name]))}

function check_required(o::CreateEpisodeRequest)
    o.name === nothing && (return false)
    true
end

function OpenAPI.validate_property(::Type{ CreateEpisodeRequest }, name::Symbol, val)

end
