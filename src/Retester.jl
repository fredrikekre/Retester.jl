module Retester

using Distributed, Revise

export includer

function includer(x::AbstractString)
    w = init_workers()
    @show w
    load_stuff(w[1])
end

const workerpool = Ref{Union{WorkerPool,Nothing}}(nothing)
function init_workers()
    # start workers
    if workerpool[] === nothing
        workerpool[] = WorkerPool(addprocs(1))
    end
    wks = workers(workerpool[])
    for w in wks
        remotecall(() -> eval(:(using Retester)), w)
    end
    # load needed packages
    @everywhere workers(workerpool) begin
        using Retester
        const Revize = Retester.Revise
    end
    return workerpool[]
end

function load_stuff(worker_id::Int)
    Distributed.remotecall_eval(Main, [worker_id], :(using Retester, Retester.Revise))
end

mutable struct Worker
    ready::Bool
    worker_id::Int
    # ...
end

function restart(worker::Worker)
    rmprocs(worker.worker_id)
    worker.worker_id = addprocs(1)
end

end # module
