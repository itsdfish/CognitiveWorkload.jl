"""
    compute_workload(data::Vector{<:AbstractActivity}, res, weights, n_mod, start_time, end_time)

Returns workload and module activity. 

# Arguments

- `data::Vector{<:AbstractActivity}`: a vector of module activity 
- `res`: time resolution or time step 
- `weights`: a vector of weights for modules 
- `start_time`: start time of the simulation 
- `end_time`: end time of the simulation  

"""
function compute_workload(data::Vector{<:AbstractActivity}, res, weights, start_time, end_time)
    n_mod = length(weights)
    t = start_time:res:end_time
    n_steps = length(t) - 1
    workload = fill(0.0, n_steps)
    mod_activity = Array{Array{Float64,2},1}()
    # pure activity
    a_val = fill(0.0, 1, n_mod)
    for step in 1:n_steps
        a_val .= 0.0
        for dd in data
            m = dd.idx
            a_val[m] += max(min(dd.end_time, t[step+1]) - max(dd.start_time, t[step]), 0.0)
        end
        activity = a_val * weights
        push!(mod_activity, a_val / res)
        workload[step] = activity[1] / res
    end
    module_activity::Array{Float64,2} = vcat(mod_activity...)
    return workload,module_activity
end

function compute_workload(data::Vector{<:AbstractActivity}, res, weights)
    end_time = find_duration(data)
    start_time = find_start_time(data)
    return compute_workload(data, res, weights, start_time, end_time)
end

function find_duration(data::Vector{<:AbstractActivity})
    return round(maximum(x -> x.end_time, data))
end

function find_start_time(data::Vector{<:AbstractActivity})
    return round(minimum(x -> x.start_time, data))
end

function compute_mean_workload(data::Vector{<:AbstractActivity}, weights, start_time, end_time)
    total = sum(map(x -> (x.end_time - x.start_time) * weights[x.idx], data))
    return total / (end_time - start_time)
end