# This file was generated by the Julia OpenAPI Code Generator
# Do not modify this file directly. Modify the OpenAPI specification instead.


@doc raw"""AttachEventsToEpisodeRequest_events_inner

    AttachEventsToEpisodeRequestEventsInner(;
        timestamp=nothing,
        data=nothing,
        metadata=nothing,
    )

    - timestamp::ZonedDateTime : Timestamp of the event
    - data::Dict{String, Any} : Arbitrary data to attach to the event, model-specific
    - metadata::Dict{String, Any} : Arbitrary metadata to attach to the event, model-specific
"""
Base.@kwdef mutable struct AttachEventsToEpisodeRequestEventsInner <: OpenAPI.APIModel
    timestamp::Union{Nothing, ZonedDateTime} = nothing
    data::Union{Nothing, Dict{String, Any}} = nothing
    metadata::Union{Nothing, Dict{String, Any}} = nothing

    function AttachEventsToEpisodeRequestEventsInner(timestamp, data, metadata, )
        OpenAPI.validate_property(AttachEventsToEpisodeRequestEventsInner, Symbol("timestamp"), timestamp)
        OpenAPI.validate_property(AttachEventsToEpisodeRequestEventsInner, Symbol("data"), data)
        OpenAPI.validate_property(AttachEventsToEpisodeRequestEventsInner, Symbol("metadata"), metadata)
        return new(timestamp, data, metadata, )
    end
end # type AttachEventsToEpisodeRequestEventsInner

const _property_types_AttachEventsToEpisodeRequestEventsInner = Dict{Symbol,String}(Symbol("timestamp")=>"ZonedDateTime", Symbol("data")=>"Dict{String, Any}", Symbol("metadata")=>"Dict{String, Any}", )
OpenAPI.property_type(::Type{ AttachEventsToEpisodeRequestEventsInner }, name::Symbol) = Union{Nothing,eval(Base.Meta.parse(_property_types_AttachEventsToEpisodeRequestEventsInner[name]))}

function check_required(o::AttachEventsToEpisodeRequestEventsInner)
    true
end

function OpenAPI.validate_property(::Type{ AttachEventsToEpisodeRequestEventsInner }, name::Symbol, val)

    if name === Symbol("timestamp")
        OpenAPI.validate_param(name, "AttachEventsToEpisodeRequestEventsInner", :format, val, "date-time")
    end


end
