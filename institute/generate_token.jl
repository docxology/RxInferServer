"""
    generate_token.jl

A script that generates a real token for connecting to the RxInfer Server.
"""

# Add the local package path
using Pkg
# Add the client package from local path
clientpkg_path = joinpath(dirname(@__DIR__), "openapi", "client")
Pkg.develop(path=clientpkg_path)

using RxInferClientOpenAPI
using Dates
# Import specific classes we need
using RxInferClientOpenAPI.OpenAPI.Clients: Client, set_header
import RxInferClientOpenAPI: AuthenticationApi, ModelsApi, ServerApi, token_generate, token_roles, 
                            get_available_models, basepath, ping_server, get_server_info

# The fallback token to use when server connection fails
const FALLBACK_TOKEN = "99d55dd4-8e42-408f-a7b3-824a10f04088"

# Define possible server endpoints to try
const SERVER_ENDPOINTS = [
    basepath(ServerApi),                   # Default from OpenAPI spec
    "https://api.rxinfer.ai/v1",           # Possible production endpoint
    "https://rxinfer.ai/api/v1",           # Another possible production endpoint
    get(ENV, "RXINFER_SERVER_URL", "")     # From environment variable if set
]

"""
    ping_server_endpoint(endpoint::String)::Bool

Pings a specific server endpoint to check if it's running.
Returns true if the server is running, false otherwise.

Parameters:
- endpoint: The server URL to connect to
"""
function ping_server_endpoint(endpoint::String)::Bool
    if isempty(endpoint)
        return false
    end

    println("Pinging server at: $endpoint")
    
    # Create client with custom endpoint
    client = Client(endpoint)
    api = ServerApi(client)
    
    try
        response, http_info = ping_server(api)
        if http_info.status == 200 && response.status == "ok"
            println("✓ Server is running! (Status: $(http_info.status))")
            return true
        else
            println("✗ Server returned unexpected status: $(response.status) (HTTP: $(http_info.status))")
            return false
        end
    catch e
        println("✗ Error pinging server: $(typeof(e))")
        return false
    end
end

"""
    find_active_server()::Union{String,Nothing}

Attempts to connect to multiple server endpoints and returns the first one that responds.
Returns nothing if no servers are available.
"""
function find_active_server()::Union{String,Nothing}
    println("\n=== FINDING ACTIVE RXINFER SERVER ===")
    
    for endpoint in SERVER_ENDPOINTS
        if !isempty(endpoint) && ping_server_endpoint(endpoint)
            println("✓ Found active server at: $endpoint")
            return endpoint
        end
    end
    
    println("✗ No active RxInfer servers found")
    return nothing
end

"""
    get_server_details(client::Client)::Dict{String,Any}

Gets detailed information about the server.
Returns a dictionary with server information or an empty dict if request fails.

Parameters:
- client: A configured API client with authentication
"""
function get_server_details(client::Client)::Dict{String,Any}
    println("Fetching server information...")
    
    api = ServerApi(client)
    
    try
        response, http_info = get_server_info(api)
        println("✓ Server information retrieved successfully! (Status: $(http_info.status))")
        
        # Create a dictionary with server information
        server_info = Dict{String,Any}(
            "rxinfer_version" => response.rxinfer_version,
            "server_version" => response.server_version,
            "server_edition" => response.server_edition,
            "julia_version" => response.julia_version,
            "api_version" => response.api_version,
            "server_url" => client.root,
            "timestamp" => Dates.now()
        )
        
        # Log the server details
        println("\n=== SERVER DETAILS ===")
        println("RxInfer Version: $(server_info["rxinfer_version"])")
        println("Server Version: $(server_info["server_version"])")
        println("Server Edition: $(server_info["server_edition"])")
        println("Julia Version: $(server_info["julia_version"])")
        println("API Version: $(server_info["api_version"])")
        println("Server URL: $(server_info["server_url"])")
        println("Timestamp: $(server_info["timestamp"])")
        
        return server_info
    catch e
        println("✗ Error getting server information: $(typeof(e))")
        return Dict{String,Any}()
    end
end

"""
    generate_real_token(server_url::String)::String

Generates a real token by connecting to the RxInfer Server.
Returns the token string or the fallback token if connection fails.

Parameters:
- server_url: The URL of the server to connect to
"""
function generate_real_token(server_url::String)::String
    println("\n=== GENERATING TOKEN ===")
    println("Connecting to RxInfer Server at: $server_url")
    
    # Create client with the specific server URL
    client = Client(server_url)
    api = AuthenticationApi(client)
    
    try
        response, http_info = token_generate(api)
        token = response.token
        println("✓ Successfully generated token! (Status: $(http_info.status))")
        return token
    catch e
        println("✗ Error generating token: $(typeof(e))")
        println("\nUsing fallback token instead.")
        return FALLBACK_TOKEN
    end
end

"""
    create_authenticated_client(token::String, server_url::String)::Client

Creates and returns an authenticated client for API calls.

Parameters:
- token: The authentication token
- server_url: The URL of the server to connect to
"""
function create_authenticated_client(token::String, server_url::String)::Client
    client = Client(server_url)
    set_header(client, "Authorization", "Bearer $token")
    return client
end

"""
    main()::Tuple{String,Client,Dict{String,Any},String}

Generates a token and displays it for use with RxInfer Server.
Returns a tuple containing:
- token: The generated or fallback token
- client: A configured Client for API calls
- server_details: Server information dictionary
- server_url: The URL of the server that was contacted
"""
function main()::Tuple{String,Client,Dict{String,Any},String}
    println("=== RxInfer Server Token Generator ===")
    
    # Try to find an active server
    server_url = find_active_server()
    
    if isnothing(server_url)
        println("\n=== NO ACTIVE SERVERS FOUND ===")
        println("Using fallback token for potential offline operations.")
        token = FALLBACK_TOKEN
        server_url = SERVER_ENDPOINTS[1] # Use default for client config
    else
        # Generate a token
        token = generate_real_token(server_url)
    end
    
    # Display token information
    if token == FALLBACK_TOKEN
        println("\n=== USING FALLBACK TOKEN ===")
        println("Your token: $token")
        println("\nTo use this token in API calls, include the following header:")
        println("Authorization: Bearer $token")
        println("\nYou can also use the development token for testing:")
        println("Token: $(get(ENV, "RXINFER_SERVER_DEV_TOKEN", "dev-token"))")
    else
        println("\n=== TOKEN GENERATED SUCCESSFULLY ===")
        println("Your token: $token")
        println("\nTo use this token in API calls, include the following header:")
        println("Authorization: Bearer $token")
    end
    
    # Create an authenticated client
    client = create_authenticated_client(token, server_url)
    
    # Get and log server details (might fail with fallback token)
    server_details = get_server_details(client)
    
    # Create a log file in the current directory
    log_filename = "rxinfer_server_connection_$(Dates.format(Dates.now(), "yyyymmdd_HHMMSS")).log"
    open(log_filename, "w") do log_file
        println(log_file, "=== RXINFER SERVER CONNECTION LOG ===")
        println(log_file, "Timestamp: $(Dates.now())")
        println(log_file, "Server URL: $server_url")
        println(log_file, "Token: $token")
        
        if !isempty(server_details)
            println(log_file, "\n=== SERVER DETAILS ===")
            for (key, value) in server_details
                println(log_file, "$key: $value")
            end
        else
            println(log_file, "\nFailed to retrieve server details.")
        end
        
        # Log connection attempts
        println(log_file, "\n=== CONNECTION ATTEMPTS ===")
        for endpoint in SERVER_ENDPOINTS
            if !isempty(endpoint)
                println(log_file, "- $endpoint: $(endpoint == server_url ? "CONNECTED" : "FAILED")")
            end
        end
    end
    
    println("\nConnection log saved to: $log_filename")
    println("\n=== USAGE INSTRUCTIONS ===")
    println("To use this connection in your code:")
    println("""
    # First, import the necessary modules
    using RxInferClientOpenAPI
    using RxInferClientOpenAPI.OpenAPI.Clients: Client, set_header
    
    # Create a client with the server URL
    client = Client("$server_url")
    
    # Add the authorization header with token
    set_header(client, "Authorization", "Bearer $token")
    
    # Create API objects for different endpoints
    server_api = RxInferClientOpenAPI.ServerApi(client)
    models_api = RxInferClientOpenAPI.ModelsApi(client)
    
    # Now you can make API calls, e.g.
    # response, _ = RxInferClientOpenAPI.get_server_info(server_api)
    # models, _ = RxInferClientOpenAPI.get_available_models(models_api)
    """)
    
    return (token, client, server_details, server_url)
end

# Exportable function to get token and client for other scripts
"""
    get_token_and_client()::Tuple{String,Client,String}

Generates a token and creates an authenticated client.
This function can be imported and used by other scripts to get a ready-to-use client.

Returns a tuple containing:
- token: The authentication token
- client: A configured Client for API calls
- server_url: The URL of the server that was used
"""
function get_token_and_client()::Tuple{String,Client,String}
    # Try to find an active server
    server_url = find_active_server()
    
    if isnothing(server_url)
        token = FALLBACK_TOKEN
        server_url = SERVER_ENDPOINTS[1] # Use default for client config
    else
        # Generate a token
        token = generate_real_token(server_url)
    end
    
    # Create and return an authenticated client
    client = create_authenticated_client(token, server_url)
    return (token, client, server_url)
end

# Run the generator when script is executed directly
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end 