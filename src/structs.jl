abstract type AbstractActivity end 

mutable struct Activity <: AbstractActivity
    start_time::Float64
    end_time::Float64
    idx::Int64
    Module::String
    condition::String
    model_name::String
    run_id::Int
end

function Activity(;start_time=0.0, 
                    end_time=0.0, 
                    idx=0, 
                    Module="", 
                    condition="",
                    model_name ="", 
                    run_id=0) 

     return Activity(start_time, 
                    end_time, 
                    idx, 
                    Module, 
                    condition, 
                    model_name,
                    run_id)
end

Broadcast.broadcastable(x::Activity) = Ref(x)
