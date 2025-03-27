# This file was generated by the Julia OpenAPI Code Generator
# Do not modify this file directly. Modify the OpenAPI specification instead.


function attach_metadata_to_event_read(handler)
    function attach_metadata_to_event_read_handler(req::HTTP.Request)
        openapi_params = Dict{String,Any}()
        path_params = HTTP.getparams(req)
        openapi_params["instance_id"] = OpenAPI.Servers.to_param(String, path_params, "instance_id", required=true, )
        openapi_params["episode_name"] = OpenAPI.Servers.to_param(String, path_params, "episode_name", required=true, )
        openapi_params["event_id"] = OpenAPI.Servers.to_param(Int64, path_params, "event_id", required=true, )
        openapi_params["AttachMetadataToEventRequest"] = OpenAPI.Servers.to_param_type(AttachMetadataToEventRequest, String(req.body))
        req.context[:openapi_params] = openapi_params

        return handler(req)
    end
end

function attach_metadata_to_event_validate(handler)
    function attach_metadata_to_event_validate_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        
        return handler(req)
    end
end

function attach_metadata_to_event_invoke(impl; post_invoke=nothing)
    function attach_metadata_to_event_invoke_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        ret = impl.attach_metadata_to_event(req::HTTP.Request, openapi_params["instance_id"], openapi_params["episode_name"], openapi_params["event_id"], openapi_params["AttachMetadataToEventRequest"];)
        resp = OpenAPI.Servers.server_response(ret)
        return (post_invoke === nothing) ? resp : post_invoke(req, resp)
    end
end

function create_episode_read(handler)
    function create_episode_read_handler(req::HTTP.Request)
        openapi_params = Dict{String,Any}()
        path_params = HTTP.getparams(req)
        openapi_params["instance_id"] = OpenAPI.Servers.to_param(String, path_params, "instance_id", required=true, )
        openapi_params["CreateEpisodeRequest"] = OpenAPI.Servers.to_param_type(CreateEpisodeRequest, String(req.body))
        req.context[:openapi_params] = openapi_params

        return handler(req)
    end
end

function create_episode_validate(handler)
    function create_episode_validate_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        
        return handler(req)
    end
end

function create_episode_invoke(impl; post_invoke=nothing)
    function create_episode_invoke_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        ret = impl.create_episode(req::HTTP.Request, openapi_params["instance_id"], openapi_params["CreateEpisodeRequest"];)
        resp = OpenAPI.Servers.server_response(ret)
        return (post_invoke === nothing) ? resp : post_invoke(req, resp)
    end
end

function create_model_instance_read(handler)
    function create_model_instance_read_handler(req::HTTP.Request)
        openapi_params = Dict{String,Any}()
        openapi_params["CreateModelInstanceRequest"] = OpenAPI.Servers.to_param_type(CreateModelInstanceRequest, String(req.body))
        req.context[:openapi_params] = openapi_params

        return handler(req)
    end
end

function create_model_instance_validate(handler)
    function create_model_instance_validate_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        
        return handler(req)
    end
end

function create_model_instance_invoke(impl; post_invoke=nothing)
    function create_model_instance_invoke_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        ret = impl.create_model_instance(req::HTTP.Request, openapi_params["CreateModelInstanceRequest"];)
        resp = OpenAPI.Servers.server_response(ret)
        return (post_invoke === nothing) ? resp : post_invoke(req, resp)
    end
end

function delete_episode_read(handler)
    function delete_episode_read_handler(req::HTTP.Request)
        openapi_params = Dict{String,Any}()
        path_params = HTTP.getparams(req)
        openapi_params["instance_id"] = OpenAPI.Servers.to_param(String, path_params, "instance_id", required=true, )
        openapi_params["episode_name"] = OpenAPI.Servers.to_param(String, path_params, "episode_name", required=true, )
        req.context[:openapi_params] = openapi_params

        return handler(req)
    end
end

function delete_episode_validate(handler)
    function delete_episode_validate_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        
        return handler(req)
    end
end

function delete_episode_invoke(impl; post_invoke=nothing)
    function delete_episode_invoke_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        ret = impl.delete_episode(req::HTTP.Request, openapi_params["instance_id"], openapi_params["episode_name"];)
        resp = OpenAPI.Servers.server_response(ret)
        return (post_invoke === nothing) ? resp : post_invoke(req, resp)
    end
end

function delete_model_instance_read(handler)
    function delete_model_instance_read_handler(req::HTTP.Request)
        openapi_params = Dict{String,Any}()
        path_params = HTTP.getparams(req)
        openapi_params["instance_id"] = OpenAPI.Servers.to_param(String, path_params, "instance_id", required=true, )
        req.context[:openapi_params] = openapi_params

        return handler(req)
    end
end

function delete_model_instance_validate(handler)
    function delete_model_instance_validate_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        
        return handler(req)
    end
end

function delete_model_instance_invoke(impl; post_invoke=nothing)
    function delete_model_instance_invoke_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        ret = impl.delete_model_instance(req::HTTP.Request, openapi_params["instance_id"];)
        resp = OpenAPI.Servers.server_response(ret)
        return (post_invoke === nothing) ? resp : post_invoke(req, resp)
    end
end

function get_available_model_read(handler)
    function get_available_model_read_handler(req::HTTP.Request)
        openapi_params = Dict{String,Any}()
        path_params = HTTP.getparams(req)
        openapi_params["model_name"] = OpenAPI.Servers.to_param(String, path_params, "model_name", required=true, )
        req.context[:openapi_params] = openapi_params

        return handler(req)
    end
end

function get_available_model_validate(handler)
    function get_available_model_validate_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        
        return handler(req)
    end
end

function get_available_model_invoke(impl; post_invoke=nothing)
    function get_available_model_invoke_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        ret = impl.get_available_model(req::HTTP.Request, openapi_params["model_name"];)
        resp = OpenAPI.Servers.server_response(ret)
        return (post_invoke === nothing) ? resp : post_invoke(req, resp)
    end
end

function get_available_models_read(handler)
    function get_available_models_read_handler(req::HTTP.Request)
        openapi_params = Dict{String,Any}()
        req.context[:openapi_params] = openapi_params

        return handler(req)
    end
end

function get_available_models_validate(handler)
    function get_available_models_validate_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        
        return handler(req)
    end
end

function get_available_models_invoke(impl; post_invoke=nothing)
    function get_available_models_invoke_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        ret = impl.get_available_models(req::HTTP.Request;)
        resp = OpenAPI.Servers.server_response(ret)
        return (post_invoke === nothing) ? resp : post_invoke(req, resp)
    end
end

function get_episode_info_read(handler)
    function get_episode_info_read_handler(req::HTTP.Request)
        openapi_params = Dict{String,Any}()
        path_params = HTTP.getparams(req)
        openapi_params["instance_id"] = OpenAPI.Servers.to_param(String, path_params, "instance_id", required=true, )
        openapi_params["episode_name"] = OpenAPI.Servers.to_param(String, path_params, "episode_name", required=true, )
        req.context[:openapi_params] = openapi_params

        return handler(req)
    end
end

function get_episode_info_validate(handler)
    function get_episode_info_validate_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        
        return handler(req)
    end
end

function get_episode_info_invoke(impl; post_invoke=nothing)
    function get_episode_info_invoke_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        ret = impl.get_episode_info(req::HTTP.Request, openapi_params["instance_id"], openapi_params["episode_name"];)
        resp = OpenAPI.Servers.server_response(ret)
        return (post_invoke === nothing) ? resp : post_invoke(req, resp)
    end
end

function get_episodes_read(handler)
    function get_episodes_read_handler(req::HTTP.Request)
        openapi_params = Dict{String,Any}()
        path_params = HTTP.getparams(req)
        openapi_params["instance_id"] = OpenAPI.Servers.to_param(String, path_params, "instance_id", required=true, )
        req.context[:openapi_params] = openapi_params

        return handler(req)
    end
end

function get_episodes_validate(handler)
    function get_episodes_validate_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        
        return handler(req)
    end
end

function get_episodes_invoke(impl; post_invoke=nothing)
    function get_episodes_invoke_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        ret = impl.get_episodes(req::HTTP.Request, openapi_params["instance_id"];)
        resp = OpenAPI.Servers.server_response(ret)
        return (post_invoke === nothing) ? resp : post_invoke(req, resp)
    end
end

function get_model_instance_read(handler)
    function get_model_instance_read_handler(req::HTTP.Request)
        openapi_params = Dict{String,Any}()
        path_params = HTTP.getparams(req)
        openapi_params["instance_id"] = OpenAPI.Servers.to_param(String, path_params, "instance_id", required=true, )
        req.context[:openapi_params] = openapi_params

        return handler(req)
    end
end

function get_model_instance_validate(handler)
    function get_model_instance_validate_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        
        return handler(req)
    end
end

function get_model_instance_invoke(impl; post_invoke=nothing)
    function get_model_instance_invoke_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        ret = impl.get_model_instance(req::HTTP.Request, openapi_params["instance_id"];)
        resp = OpenAPI.Servers.server_response(ret)
        return (post_invoke === nothing) ? resp : post_invoke(req, resp)
    end
end

function get_model_instance_state_read(handler)
    function get_model_instance_state_read_handler(req::HTTP.Request)
        openapi_params = Dict{String,Any}()
        path_params = HTTP.getparams(req)
        openapi_params["instance_id"] = OpenAPI.Servers.to_param(String, path_params, "instance_id", required=true, )
        req.context[:openapi_params] = openapi_params

        return handler(req)
    end
end

function get_model_instance_state_validate(handler)
    function get_model_instance_state_validate_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        
        return handler(req)
    end
end

function get_model_instance_state_invoke(impl; post_invoke=nothing)
    function get_model_instance_state_invoke_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        ret = impl.get_model_instance_state(req::HTTP.Request, openapi_params["instance_id"];)
        resp = OpenAPI.Servers.server_response(ret)
        return (post_invoke === nothing) ? resp : post_invoke(req, resp)
    end
end

function get_model_instances_read(handler)
    function get_model_instances_read_handler(req::HTTP.Request)
        openapi_params = Dict{String,Any}()
        req.context[:openapi_params] = openapi_params

        return handler(req)
    end
end

function get_model_instances_validate(handler)
    function get_model_instances_validate_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        
        return handler(req)
    end
end

function get_model_instances_invoke(impl; post_invoke=nothing)
    function get_model_instances_invoke_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        ret = impl.get_model_instances(req::HTTP.Request;)
        resp = OpenAPI.Servers.server_response(ret)
        return (post_invoke === nothing) ? resp : post_invoke(req, resp)
    end
end

function run_inference_read(handler)
    function run_inference_read_handler(req::HTTP.Request)
        openapi_params = Dict{String,Any}()
        path_params = HTTP.getparams(req)
        openapi_params["instance_id"] = OpenAPI.Servers.to_param(String, path_params, "instance_id", required=true, )
        openapi_params["InferRequest"] = OpenAPI.Servers.to_param_type(InferRequest, String(req.body))
        req.context[:openapi_params] = openapi_params

        return handler(req)
    end
end

function run_inference_validate(handler)
    function run_inference_validate_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        
        return handler(req)
    end
end

function run_inference_invoke(impl; post_invoke=nothing)
    function run_inference_invoke_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        ret = impl.run_inference(req::HTTP.Request, openapi_params["instance_id"], openapi_params["InferRequest"];)
        resp = OpenAPI.Servers.server_response(ret)
        return (post_invoke === nothing) ? resp : post_invoke(req, resp)
    end
end

function run_learning_read(handler)
    function run_learning_read_handler(req::HTTP.Request)
        openapi_params = Dict{String,Any}()
        path_params = HTTP.getparams(req)
        openapi_params["instance_id"] = OpenAPI.Servers.to_param(String, path_params, "instance_id", required=true, )
        openapi_params["LearnRequest"] = OpenAPI.Servers.to_param_type(LearnRequest, String(req.body))
        req.context[:openapi_params] = openapi_params

        return handler(req)
    end
end

function run_learning_validate(handler)
    function run_learning_validate_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        
        return handler(req)
    end
end

function run_learning_invoke(impl; post_invoke=nothing)
    function run_learning_invoke_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        ret = impl.run_learning(req::HTTP.Request, openapi_params["instance_id"], openapi_params["LearnRequest"];)
        resp = OpenAPI.Servers.server_response(ret)
        return (post_invoke === nothing) ? resp : post_invoke(req, resp)
    end
end

function wipe_episode_read(handler)
    function wipe_episode_read_handler(req::HTTP.Request)
        openapi_params = Dict{String,Any}()
        path_params = HTTP.getparams(req)
        openapi_params["instance_id"] = OpenAPI.Servers.to_param(String, path_params, "instance_id", required=true, )
        openapi_params["episode_name"] = OpenAPI.Servers.to_param(String, path_params, "episode_name", required=true, )
        req.context[:openapi_params] = openapi_params

        return handler(req)
    end
end

function wipe_episode_validate(handler)
    function wipe_episode_validate_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        
        return handler(req)
    end
end

function wipe_episode_invoke(impl; post_invoke=nothing)
    function wipe_episode_invoke_handler(req::HTTP.Request)
        openapi_params = req.context[:openapi_params]
        ret = impl.wipe_episode(req::HTTP.Request, openapi_params["instance_id"], openapi_params["episode_name"];)
        resp = OpenAPI.Servers.server_response(ret)
        return (post_invoke === nothing) ? resp : post_invoke(req, resp)
    end
end


function registerModelsApi(router::HTTP.Router, impl; path_prefix::String="", optional_middlewares...)
    HTTP.register!(router, "POST", path_prefix * "/models/i/{instance_id}/episodes/{episode_name}/events/{event_id}/attach-metadata", OpenAPI.Servers.middleware(impl, attach_metadata_to_event_read, attach_metadata_to_event_validate, attach_metadata_to_event_invoke; optional_middlewares...))
    HTTP.register!(router, "POST", path_prefix * "/models/i/{instance_id}/create-episode", OpenAPI.Servers.middleware(impl, create_episode_read, create_episode_validate, create_episode_invoke; optional_middlewares...))
    HTTP.register!(router, "POST", path_prefix * "/models/create-instance", OpenAPI.Servers.middleware(impl, create_model_instance_read, create_model_instance_validate, create_model_instance_invoke; optional_middlewares...))
    HTTP.register!(router, "DELETE", path_prefix * "/models/i/{instance_id}/episodes/{episode_name}", OpenAPI.Servers.middleware(impl, delete_episode_read, delete_episode_validate, delete_episode_invoke; optional_middlewares...))
    HTTP.register!(router, "DELETE", path_prefix * "/models/i/{instance_id}", OpenAPI.Servers.middleware(impl, delete_model_instance_read, delete_model_instance_validate, delete_model_instance_invoke; optional_middlewares...))
    HTTP.register!(router, "GET", path_prefix * "/models/available/{model_name}", OpenAPI.Servers.middleware(impl, get_available_model_read, get_available_model_validate, get_available_model_invoke; optional_middlewares...))
    HTTP.register!(router, "GET", path_prefix * "/models/available", OpenAPI.Servers.middleware(impl, get_available_models_read, get_available_models_validate, get_available_models_invoke; optional_middlewares...))
    HTTP.register!(router, "GET", path_prefix * "/models/i/{instance_id}/episodes/{episode_name}", OpenAPI.Servers.middleware(impl, get_episode_info_read, get_episode_info_validate, get_episode_info_invoke; optional_middlewares...))
    HTTP.register!(router, "GET", path_prefix * "/models/i/{instance_id}/episodes", OpenAPI.Servers.middleware(impl, get_episodes_read, get_episodes_validate, get_episodes_invoke; optional_middlewares...))
    HTTP.register!(router, "GET", path_prefix * "/models/i/{instance_id}", OpenAPI.Servers.middleware(impl, get_model_instance_read, get_model_instance_validate, get_model_instance_invoke; optional_middlewares...))
    HTTP.register!(router, "GET", path_prefix * "/models/i/{instance_id}/state", OpenAPI.Servers.middleware(impl, get_model_instance_state_read, get_model_instance_state_validate, get_model_instance_state_invoke; optional_middlewares...))
    HTTP.register!(router, "GET", path_prefix * "/models/instances", OpenAPI.Servers.middleware(impl, get_model_instances_read, get_model_instances_validate, get_model_instances_invoke; optional_middlewares...))
    HTTP.register!(router, "POST", path_prefix * "/models/i/{instance_id}/infer", OpenAPI.Servers.middleware(impl, run_inference_read, run_inference_validate, run_inference_invoke; optional_middlewares...))
    HTTP.register!(router, "POST", path_prefix * "/models/i/{instance_id}/learn", OpenAPI.Servers.middleware(impl, run_learning_read, run_learning_validate, run_learning_invoke; optional_middlewares...))
    HTTP.register!(router, "POST", path_prefix * "/models/i/{instance_id}/episodes/{episode_name}/wipe", OpenAPI.Servers.middleware(impl, wipe_episode_read, wipe_episode_validate, wipe_episode_invoke; optional_middlewares...))
    return router
end
