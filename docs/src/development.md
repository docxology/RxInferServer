# Development

This section describes the development process for the RxInferServer.jl project and how to setup the development environment.

## OpenAPI Specification and Code Generation

This repository includes an OpenAPI specification for the RxInferServer.jl API and tools to generate Julia server code from it.

### Prerequisites

- Docker and Docker Compose installed on your system
- Visual Studio Code (or your preferred code editor) for editing the OpenAPI specification

### Development environment with Docker

To start the development environment with Docker, from the root directory of the repository, run:

```bash
docker-compose up -d
```

Or alternatively, use VSCode extension "Docker" to start the server. The VSCode extension also allows to check the logs and attach to the running container. Read more about docker here: [Docker](https://docs.docker.com/get-started/).

The `docker-compose.yaml` currently has the following services:

- RxInferServer: the server implementation running in the background on `localhost:8000` with hot-reloading enabled by default, use `LocalPreferences.toml` file to configure the server
- Swagger UI: a web interface for visualizing and testing the OpenAPI specification, the UI is available at `http://localhost:8080` and allows to test the API endpoints, the endpoints can also be tested in VSCode by opening `spec.yaml` directly and clicking on the "Try it" button
- OpenTelemetry Collector: a service that collects, processes, and exports telemetry data (metrics, traces, and logs) from the RxInferServer. It listens for OTLP data on ports 4317 (gRPC) and 4318 (HTTP), exposes a Prometheus metrics endpoint on port 8889, and provides its own internal metrics on port 8888. The configuration is stored in `telemetry/otel-collector.yaml`.
- Prometheus: a monitoring and alerting tool that scrapes and stores metrics from the OpenTelemetry Collector. The Prometheus UI is available at `http://localhost:9090` and allows querying and visualizing collected metrics.
- Loki: a log aggregation system designed to store and query logs from all your applications and infrastructure. Loki data can be accessed via Grafana.
- Tempo: a high-volume, minimal-dependency distributed tracing backend. It can ingest, store, and query traces and is tightly integrated with Grafana.
- Grafana: a multi-platform open source analytics and interactive visualization web application. It provides charts, graphs, and alerts when connected to supported data sources. Access it at `http://localhost:3000`.

### Editing the OpenAPI Specification

Edit the `openapi/spec.yaml` file directly in VSCode or your preferred code editor. The OpenAPI specification uses the YAML format and follows the [OpenAPI 3](https://swagger.io/specification/) standard.

Some useful VS Code extensions for working with OpenAPI specifications include:
- "OpenAPI (Swagger) Editor" by 42Crunch
- "YAML" by Red Hat
- "Docker" by Microsoft

### Accessing Swagger UI

Open your browser and navigate to: http://localhost:8080

The Swagger UI will automatically load the `openapi/spec.yaml` file, allowing you to visualize and test your API without leaving your browser. Alternatively, you can test the API endpoints in VSCode by opening `spec.yaml` directly and clicking on the "Try it" button.

#### Testing Authenticated Endpoints

The API uses standard Bearer token authentication with the `Authorization` header. Here's how to test authenticated endpoints:

1. **Get a token**:
   - Navigate to the `/token` endpoint
   - Click "Try it out" followed by "Execute"
   - Copy the token from the response
   - **For development**: You can use the predefined dev token (`dev-token`) configured in the environment variable `RXINFER_SERVER_DEV_TOKEN`

2. **Set up authentication**:
   - Click the "Authorize" button (padlock icon) at the top of Swagger UI
   - Enter your token in the value field (without "Bearer" prefix)
   - For local development, you can enter `dev-token`
   - Click "Authorize" and "Close"
   - The client will send requests with `Authorization: Bearer your-token-here`

3. **Test protected endpoints**:
   - All subsequent requests will include the authorization header
   - The token remains active until you log out or close the browser
   - By default, all endpoints except `/token` require authentication

See [Configuration](configuration.md) for more details on setting up authentication for development and production.

### OpenTelemetry Integration

The development environment includes a complete observability stack:

1. **OpenTelemetry Collector**: Collects telemetry data (metrics, traces, logs) from the RxInfer server
2. **Prometheus**: Stores and queries metrics
3. **Loki**: Stores and queries logs
4. **Tempo**: Stores and queries distributed traces
5. **Grafana**: Visualizes all telemetry data in a unified interface

#### Available Endpoints

- **OpenTelemetry Collector**:
  - gRPC: `localhost:4317`
  - HTTP: `localhost:4318`
  - Prometheus Metrics (collector): `http://localhost:8888/metrics`
  - Prometheus Exporter (application): `http://localhost:8889/metrics`

- **Prometheus**: `http://localhost:9090`
- **Loki**: `http://localhost:3100`
- **Tempo**: `http://localhost:3200`
- **Grafana**: `http://localhost:3000` (admin/admin)

#### Viewing Telemetry Data

For a unified view of all telemetry data, access Grafana at `http://localhost:3000`:
- Default login is `admin/admin`
- All data sources (Prometheus, Loki, Tempo) are pre-configured
- Create dashboards to view metrics, logs, and traces in one place
- Explore traces, logs, and metrics with correlation between them

You can also access each component directly:
- Prometheus UI at `http://localhost:9090` for metrics queries
- Tempo UI at `http://localhost:3200` for trace viewing
- Raw metrics at `http://localhost:8889/metrics`

#### Configuration

- **OpenTelemetry Collector**: `telemetry/otel-collector.yaml`
- **Prometheus**: `prometheus.yml`
- **Loki**: `loki-config.yaml`
- **Tempo**: `tempo-config.yaml`
- **Grafana Datasources**: `datasource.yml`

After changing any configuration, restart the respective service:
```bash
# For OpenTelemetry Collector
docker-compose restart otel-collector

# For Prometheus
docker-compose restart prometheus

# For Loki
docker-compose restart loki

# For Tempo
docker-compose restart tempo

# For Grafana
docker-compose restart grafana
```

### Generating Server Code

To generate Julia server code from the OpenAPI specification, run:

```bash
./generate-server.sh
```

This script will:
1. Check if Docker is running
2. Stop all running Docker Compose services to prevent code conflicts
3. Run the OpenAPI Generator Docker image directly
4. Generate Julia server code in the `openapi/server` directory

The script uses the official `openapitools/openapi-generator-cli` Docker image and mounts the necessary directories to generate the code without needing a persistent container.

!!! note
    The script stops all Docker Compose services before generating code to prevent conflicts. You will need to manually restart the services after generation with `docker-compose up -d`.

!!! note
    After the re-generation of the server code, the initial startup time will be longer due to initial compilation of the generated code.

### Working with the Generated Code

The generated code will be placed in the `openapi/server` directory as a separate Julia module and should never be modified directly. The `RxInferServer.jl` package will automatically load the generated code when the package is loaded. 

The generated code does not contain the actual implementation of the endpoints. The actual implementation is located in the `src/tags` directory for each tag specified in the OpenAPI specification. You can also manually open the `openapi/server/src/RxInferServerOpenAPI.jl` file to view which endpoints must be implemented. An example generated output might look like this:

```julia 
@doc raw"""
Encapsulates generated server code for RxInferServerOpenAPI

The following server methods must be implemented:

- **get_server_info**
    - *invocation:* GET /info
    - *signature:* get_server_info(req::HTTP.Request;) -> ServerInfo
"""
module RxInferServerOpenAPI

# ... a lot of auto generated code ...

end
```

This tells you that you need to implement the `get_server_info` function that must return a `ServerInfo` object as defined in the `openapi/spec.yaml` file.

For a quick check of which server methods need to be implemented, you can use the provided Makefile target:

```bash
make openapi-endpoints
```

This command will load RxInferServer and display the documentation of the RxInferServerOpenAPI module, which contains the list of methods that must be implemented.

### Customizing the OpenAPI Specification

Edit the `openapi/spec.yaml` file directly in your code editor to customize your API specification. 

!!! warning "Important"
    After making ANY changes to the OpenAPI specification, you MUST regenerate the server code by running the generation script again:

See [Generating Server Code](#generating-server-code) for more details.

Failing to regenerate the code after changes to the OpenAPI specification will result in inconsistencies between your API specification and the actual server implementation. The code is not being re-generated automatically for two primary reasons:
- It might be somewhat slow for a lot of endpoints
- It most likely will cause `Revise` errors with redefined structures 

### Additional Resources

- [OpenAPI Specification](https://swagger.io/specification/)
- [OpenAPI Generator](https://openapi-generator.tech/)
- [Julia Server Template](https://openapi-generator.tech/docs/generators/julia-server)