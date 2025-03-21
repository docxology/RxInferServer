using RxInfer, LinearAlgebra

function initial_state(arguments)
    return Dict(
        "dt" => arguments["dt"],
        "horizon" => arguments["horizon"],
        "gravity" => arguments["gravity"],
        "mass" => arguments["mass"],
        "inertia" => arguments["inertia"],
        "radius" => arguments["radius"],
        "force_limit" => arguments["force_limit"]
    )
end

Base.@kwdef struct Drone
    gravity::Float64
    mass::Float64
    inertia::Float64
    radius::Float64
    force_limit::Float64
end

get_gravity(drone::Drone) = drone.gravity
get_mass(drone::Drone) = drone.mass
get_inertia(drone::Drone) = drone.inertia
get_radius(drone::Drone) = drone.radius
get_force_limit(drone::Drone) = drone.force_limit

get_properties(drone::Drone) =
    (get_gravity(drone), get_mass(drone), get_inertia(drone), get_radius(drone), get_force_limit(drone))

struct State
    x::Float64
    y::Float64
    vx::Float64
    vy::Float64
    𝜃::Float64
    𝜔::Float64
end

get_state(state::State) = (state.x, state.y, state.vx, state.vy, state.𝜃, state.𝜔)

function state_transition(state, actions, drone::Drone, dt)

    # extract drone properties
    g, m, I, r, limit = get_properties(drone)

    # extract feasible actions
    Fl, Fr = clamp.(actions, 0, limit)

    # extract state properties
    x, y, vx, vy, θ, ω = state

    # compute forces and torques
    Fg = m * g
    Fy = (Fl + Fr) * cos(θ) - Fg
    Fx = (Fl + Fr) * sin(θ)
    𝜏  = (Fl - Fr) * r

    # compute movements
    ax = Fx / m
    ay = Fy / m
    vx_new = vx + ax * dt
    #     vy_new = vx + ay * dt # old version
    vy_new = vy + ay * dt   # new version
    x_new  = x + vx * dt + ax * dt^2 / 2
    y_new  = y + vy * dt + ay * dt^2 / 2

    # compute rotations
    α = 𝜏 / I
    ω_new = ω + α * dt
    θ_new = θ + ω * dt + α * dt^2 / 2

    return [x_new, y_new, vx_new, vy_new, θ_new, ω_new]
end

@model function drone_model(drone, initial_state, goal, horizon, dt)
    g = get_gravity(drone)
    m = get_mass(drone)

    # initial state prior
    s[1] ~ MvNormal(mean = initial_state, covariance = 1e-5 * I)

    for i in 1:horizon

        # prior on actions (mean compensates for gravity)
        u[i] ~ MvNormal(μ = [m * g / 2, m * g / 2], Σ = diageye(2))

        # state transition
        s[i + 1] ~ MvNormal(μ = state_transition(s[i], u[i], drone, dt), Σ = 1e-10 * I)
    end

    s[end] ~ MvNormal(mean = goal, covariance = 1e-5 * diageye(6))
end

@meta function drone_meta()
    # approximate the state transition function using the Unscented transform
    state_transition() -> Unscented()
end

function move_to_target(drone::Drone, current_state, target, horizon, dt)
    results = infer(
        model = drone_model(drone = drone, horizon = horizon, dt = dt),
        data = (initial_state = current_state, goal = [target[1], target[2], 0, 0, 0, 0]),
        meta = drone_meta(),
        returnvars = (s = KeepLast(), u = KeepLast()),
        options = (limit_stack_depth = 200, )
    )
    return Dict(
        "actions" => mean.(results.posteriors[:u]), 
        "states" => mean.(results.posteriors[:s])
    )
end

function run_inference(state, data)
    current_state = Float64.(data["current_state"])
    target = data["target"]
    horizon = state["horizon"]
    dt = state["dt"]
    drone = Drone(gravity = state["gravity"], mass = state["mass"], inertia = state["inertia"], radius = state["radius"], force_limit = state["force_limit"])
    results = move_to_target(drone, current_state, target, horizon, dt)
    return results, state
end

function run_learning(state, parameters, events)
    error("Not available for this model")
end
