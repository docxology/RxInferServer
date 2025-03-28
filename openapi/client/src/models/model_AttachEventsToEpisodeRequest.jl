# This file was generated by the Julia OpenAPI Code Generator
# Do not modify this file directly. Modify the OpenAPI specification instead.


@doc raw"""AttachEventsToEpisodeRequest

    AttachEventsToEpisodeRequest(;
        events=nothing,
    )

    - events::Vector{AttachEventsToEpisodeRequestEventsInner} : List of events to attach to the episode
"""
Base.@kwdef mutable struct AttachEventsToEpisodeRequest <: OpenAPI.APIModel
    events::Union{Nothing, Vector} = nothing # spec type: Union{ Nothing, Vector{AttachEventsToEpisodeRequestEventsInner} }

    function AttachEventsToEpisodeRequest(events, )
        OpenAPI.validate_property(AttachEventsToEpisodeRequest, Symbol("events"), events)
        return new(events, )
    end
end # type AttachEventsToEpisodeRequest

const _property_types_AttachEventsToEpisodeRequest = Dict{Symbol,String}(Symbol("events")=>"Vector{AttachEventsToEpisodeRequestEventsInner}", )
OpenAPI.property_type(::Type{ AttachEventsToEpisodeRequest }, name::Symbol) = Union{Nothing,eval(Base.Meta.parse(_property_types_AttachEventsToEpisodeRequest[name]))}

function check_required(o::AttachEventsToEpisodeRequest)
    o.events === nothing && (return false)
    true
end

function OpenAPI.validate_property(::Type{ AttachEventsToEpisodeRequest }, name::Symbol, val)

end
