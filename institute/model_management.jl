"""
    model_management.jl

This script demonstrates interacting with the RxInferServer's model management API.
It tests and logs operations for discovering models, creating instances, checking states, and deletion.
"""

# Add the package path if needed
using Pkg

# Try to find the client package in different locations
client_pkg_locations = [
    joinpath(@__DIR__, "openapi", "client"),               # Local to institute directory
    joinpath(dirname(@__DIR__), "openapi", "client"),      # Root project directory
]

# First try to use the package if already installed
try
    Pkg.status("RxInferClientOpenAPI")
    println("Using already installed RxInferClientOpenAPI package")
catch
    # Otherwise try to develop from local paths
    client_found = false
    
    for path in client_pkg_locations
        if isdir(path)
            println("Developing RxInferClientOpenAPI from: $path")
            try
                Pkg.develop(path=path)
                client_found = true
                break
            catch e
                println("Failed to develop from $path: $e")
            end
        end
    end
    
    if !client_found
        @warn """
        Could not find or develop RxInferClientOpenAPI package.
        Make sure it's installed or specify the correct path.
        Will attempt to continue anyway.
        """
    end
end

# Try to load the packages
try
    using RxInferClientOpenAPI
    using Dates, UUIDs
    # Import specific classes we need
    using RxInferClientOpenAPI.OpenAPI.Clients: Client, set_header
    import RxInferClientOpenAPI: 
        AuthenticationApi, 
        ModelsApi, 
        basepath,
        token_generate,
        get_available_models,
        get_available_model,
        create_model_instance,
        CreateModelInstanceRequest,
        get_model_instances,
        get_model_instance,
        get_model_instance_state,
        delete_model_instance
catch e
    error("Failed to load RxInferClientOpenAPI: $e")
end

# Define fallback tokens
const FALLBACK_TOKEN = "99d55dd4-8e42-408f-a7b3-824a10f04088"
# Try to get dev token from environment
const DEV_TOKEN = get(ENV, "RXINFER_SERVER_DEV_TOKEN", "dev-token")

# Try to include the generate_token module for more robust connection
let generate_token_imported = false
    try
        include(joinpath(@__DIR__, "generate_token.jl"))
        generate_token_imported = true
        println("Successfully imported generate_token.jl for robust server connection")
    catch e
        println("Note: generate_token.jl not available, using simplified connection: $e")
    end
    global GENERATE_TOKEN_AVAILABLE = generate_token_imported
end

"""
    generate_token()::String

Generates a token for authenticating with the RxInferServer.
Returns the token string or a fallback token if generation fails.
"""
function generate_token()::String
    println("Connecting to RxInfer Server to generate token...")
    
    try
        client = Client(basepath(AuthenticationApi))
        println("Base URL: $(client.root)")
        
        api = AuthenticationApi(client)
        
        response, _ = token_generate(api)
        token = response.token
        println("✓ Successfully generated token!")
        return token
    catch e
        println("✗ Error generating token: $e")
        
        # Try using development token
        if DEV_TOKEN != "dev-token"
            println("Using development token from environment")
            return DEV_TOKEN
        end
        
        println("Using fallback token instead")
        return FALLBACK_TOKEN
    end
end

"""
    log_section(title::String)

Print a formatted section header for logging purposes.
"""
function log_section(title::String)
    println("\n========== $title ==========")
end

"""
    run_model_management_tests(token::String, client::Client=nothing, server_url::String=nothing)

Run a comprehensive test of the RxInferServer model management API operations.

Parameters:
- `token`: The authentication token to use for API calls
- `client`: Optional pre-configured client, will create one if not provided
- `server_url`: Optional server URL to connect to
"""
function run_model_management_tests(token::String, client::Client=nothing, server_url::String=nothing)
    # Create client with authentication if not provided
    if isnothing(client)
        if isnothing(server_url)
            server_url = basepath(ModelsApi)
        end
        
        client = Client(server_url; headers = Dict(
            "Authorization" => "Bearer $token"
        ))
        println("Created new client for server: $server_url")
    else
        println("Using provided client for server: $(client.root)")
    end
    
    api = ModelsApi(client)
    
    # Create log file for detailed model operations
    log_filename = "rxinfer_models_$(Dates.format(Dates.now(), "yyyymmdd_HHMMSS")).log"
    log_file = open(log_filename, "w")
    
    println(log_file, "=== RXINFER MODEL MANAGEMENT LOG ===")
    println(log_file, "Timestamp: $(Dates.now())")
    println(log_file, "Server: $(client.root)")
    println(log_file, "Token: $token")
    
    # Track created instances for cleanup
    created_instance_ids = String[]
    
    try
        log_section("DISCOVERING AVAILABLE MODELS")
        println("Fetching available models...")
        println(log_file, "\n=== AVAILABLE MODELS ===")
        
        available_models, http_response = get_available_models(api)
        
        println(log_file, "HTTP Status: $(http_response.status)")
        
        if isempty(available_models)
            println("No models available.")
            println(log_file, "No models available.")
            close(log_file)
            println("\nModel management log saved to: $log_filename")
            return
        end
        
        println("Found $(length(available_models)) available models:")
        println(log_file, "Found $(length(available_models)) models:")
        
        for (i, model) in enumerate(available_models)
            model_info = "$(i). $(model.details.name): $(model.details.description)"
            println(model_info)
            println(log_file, model_info)
        end
        
        # Select first model to work with
        selected_model = available_models[1]
        model_name = selected_model.details.name
        println("\nSelected model for testing: $model_name")
        println(log_file, "\nSelected model for testing: $model_name")
        
        log_section("INSPECTING MODEL DETAILS")
        println("Fetching details for model: $model_name")
        println(log_file, "\n=== MODEL DETAILS: $model_name ===")
        
        model_details, http_response = get_available_model(api, model_name)
        println(log_file, "HTTP Status: $(http_response.status)")
        
        println("Model details:")
        println(log_file, "Model details:")
        
        detail_fields = [
            "Name" => model_details.details.name,
            "Description" => model_details.details.description,
            "Author" => model_details.details.author,
            "Roles" => join(model_details.details.roles, ", ")
        ]
        
        for (key, value) in detail_fields
            println("- $key: $value")
            println(log_file, "- $key: $value")
        end
        
        # Try to create a model instance
        log_section("CREATING MODEL INSTANCE")
        instance_description = "Test instance created at $(now())"
        println("Creating instance of model '$model_name' with description: $instance_description")
        println(log_file, "\n=== CREATING MODEL INSTANCE ===")
        println(log_file, "Model: $model_name")
        println(log_file, "Description: $instance_description")
        
        request = CreateModelInstanceRequest(
            model_name = model_name,
            description = instance_description
        )
        
        create_response, http_response = create_model_instance(api, request)
        println(log_file, "HTTP Status: $(http_response.status)")
        
        if !hasproperty(create_response, :instance_id)
            error_msg = "Failed to create instance: $(create_response.error)"
            println(error_msg)
            println(log_file, error_msg)
            close(log_file)
            println("\nModel management log saved to: $log_filename")
            return
        end
        
        instance_id = create_response.instance_id
        push!(created_instance_ids, instance_id)
        success_msg = "✓ Instance created successfully with ID: $instance_id"
        println(success_msg)
        println(log_file, success_msg)
        
        # Test creating instance with non-existent model (should fail)
        println("\nTesting error handling - Creating instance with non-existent model:")
        println(log_file, "\n=== ERROR HANDLING TEST ===")
        println(log_file, "Attempting to create instance with non-existent model")
        
        error_request = CreateModelInstanceRequest(model_name = "non_existent_model")
        error_response, http_response = create_model_instance(api, error_request)
        
        error_msg = "Expected error response: $(error_response.error)"
        println(error_msg)
        println(log_file, error_msg)
        println(log_file, "HTTP Status: $(http_response.status)")
        
        # List instances
        log_section("LISTING MODEL INSTANCES")
        println("Fetching all created model instances...")
        println(log_file, "\n=== MODEL INSTANCES ===")
        
        instances, http_response = get_model_instances(api)
        println(log_file, "HTTP Status: $(http_response.status)")
        
        println("Found $(length(instances)) instances:")
        println(log_file, "Found $(length(instances)) instances:")
        
        for instance in instances
            instance_info = "- $(instance.instance_id): $(instance.model_name) ($(instance.description))"
            println(instance_info)
            println(log_file, instance_info)
        end
        
        # Get specific instance details
        log_section("GETTING INSTANCE DETAILS")
        println("Fetching details for instance ID: $instance_id")
        println(log_file, "\n=== INSTANCE DETAILS ===")
        println(log_file, "Instance ID: $instance_id")
        
        instance_details, http_response = get_model_instance(api, instance_id)
        println(log_file, "HTTP Status: $(http_response.status)")
        
        println("Instance details:")
        println(log_file, "Instance details:")
        
        instance_fields = [
            "ID" => instance_details.instance_id,
            "Model" => instance_details.model_name,
            "Created" => instance_details.created_at,
            "Current episode" => instance_details.current_episode,
            "Arguments" => instance_details.arguments
        ]
        
        for (key, value) in instance_fields
            println("- $key: $value")
            println(log_file, "- $key: $value")
        end
        
        # Check model state
        log_section("CHECKING MODEL INSTANCE STATE")
        println("Fetching state for instance ID: $instance_id")
        println(log_file, "\n=== MODEL INSTANCE STATE ===")
        println(log_file, "Instance ID: $instance_id")
        
        state_response, http_response = get_model_instance_state(api, instance_id)
        println(log_file, "HTTP Status: $(http_response.status)")
        
        println("Model state:")
        println(log_file, "Model state:")
        
        for (key, value) in state_response.state
            println("- $key: $value")
            println(log_file, "- $key: $value")
        end
        
        # Clean up - delete instances
        log_section("DELETING MODEL INSTANCE")
        println(log_file, "\n=== DELETING MODEL INSTANCES ===")
        
        for id in created_instance_ids
            println("Deleting instance: $id")
            println(log_file, "Deleting instance: $id")
            
            delete_response, http_response = delete_model_instance(api, id)
            println(log_file, "HTTP Status: $(http_response.status)")
            
            response_msg = "Response: $(delete_response.message)"
            println(response_msg)
            println(log_file, response_msg)
            
            # Verify deletion
            verify_response, verify_http = get_model_instance(api, id)
            
            if verify_http.status == 404
                verify_msg = "✓ Instance successfully deleted - not found on server"
                println(verify_msg)
                println(log_file, verify_msg)
            else
                verify_msg = "✗ Instance might still exist - unexpected response: $(verify_http.status)"
                println(verify_msg)
                println(log_file, verify_msg)
            end
        end
        
    catch e
        error_msg = "Error during testing: $e"
        println(error_msg)
        println(log_file, "\n=== ERROR ===")
        println(log_file, error_msg)
    finally
        close(log_file)
        println("\nModel management log saved to: $log_filename")
    end
end

"""
    main()

Main function to run the model management tests.
"""
function main()
    println("=== RxInfer Server Model Management Test ===")
    
    # Try to use the robust connection method if available
    if @isdefined(GENERATE_TOKEN_AVAILABLE) && GENERATE_TOKEN_AVAILABLE
        println("Using robust connection method from generate_token.jl")
        token, client, server_url = get_token_and_client()
        println("\nRunning tests with token from generate_token.jl")
        run_model_management_tests(token, client, server_url)
    else
        # Generate or use fallback token with the simple method
        token = generate_token()
        println("\nRunning tests with token: $token")
        run_model_management_tests(token)
    end
    
    println("\n=== Test Complete ===")
end

# Run the model management tests when script is executed directly
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
