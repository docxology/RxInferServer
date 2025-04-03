"""
    generate_token.jl

A script that generates a real token for connecting to the RxInfer Server.
"""

# Add the local package path
using Pkg
# Add the client package from local path
clientpkg_path = joinpath(@__DIR__, "openapi", "client")
Pkg.develop(path=clientpkg_path)

using RxInferClientOpenAPI
# Import specific classes we need
using RxInferClientOpenAPI.OpenAPI.Clients: Client, set_header
import RxInferClientOpenAPI: AuthenticationApi, ModelsApi, token_generate, token_roles, get_available_models, basepath

# The fallback token to use when server connection fails
const FALLBACK_TOKEN = "99d55dd4-8e42-408f-a7b3-824a10f04088"

"""
    generate_real_token(base_url=nothing)::String

Generates a real token by connecting to the RxInfer Server.
Returns the token string or the fallback token if connection fails.

Parameters:
- base_url: Optional custom server URL. If nothing, uses the default from basepath.
"""
function generate_real_token(base_url=nothing)::String
    println("Connecting to RxInfer Server to generate token...")
    
    url = isnothing(base_url) ? basepath(AuthenticationApi) : base_url
    println("Base URL: $url")
    
    client = Client(url)
    api = AuthenticationApi(client)
    
    try
        response, _ = token_generate(api)
        token = response.token
        println("✓ Successfully generated token!")
        return token
    catch e
        println("✗ Error generating token: $e")
        println("\nUsing fallback token instead.")
        return FALLBACK_TOKEN
    end
end

"""
    main(base_url=nothing)

Generates a token and displays it for use with RxInfer Server.

Parameters:
- base_url: Optional custom server URL. If nothing, uses the default.
"""
function main(base_url=nothing)
    println("=== RxInfer Server Token Generator ===")
    
    # Try to generate a token
    token = generate_real_token(base_url)
    
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
    
    return token
end

# Run the generator when script is executed directly
if abspath(PROGRAM_FILE) == @__FILE__
    # You can try different server URLs if the default doesn't work
    # Examples:
    # - http://localhost:8000/api/v1
    # - http://localhost:8080/v1
    main()
end 