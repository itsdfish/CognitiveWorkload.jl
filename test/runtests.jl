using SafeTestsets 

@safetestset "workload" begin 
    @safetestset "mean_workload" begin 
        using Test
        using CognitiveWorkload

        modules = [:procedural,:declarative,:imaginal,:motor,:visual,:audio,:speech,:temporal]
        weights = [2.0, 4.0, 4.0, 1.0, 1.0, 1.0, 1.0, 1.0]
        res = .5 #seconds
        start_time = 0.0
        end_time = 20
        times = res:res:end_time 
        activity = Activity[]

        a = Activity(;start_time=0.0, end_time=1.0, idx=1, Module="procedural")
        push!(activity, a)

        a = Activity(;start_time=0.5, end_time=1.0, idx=2, Module="declarative")
        push!(activity, a)

        w1 = compute_mean_workload(activity, weights, 0, 1)
        @test w1 == 4


        activity = Activity[]

        a = Activity(;start_time=0.0, end_time=1.0, idx=1, Module="procedural")
        push!(activity, a)

        a = Activity(;start_time=0.5, end_time=1.0, idx=2, Module="declarative")
        push!(activity, a)

        w1 = compute_mean_workload(activity, weights, 0, 2)
        @test w1 == 2
    end

    @safetestset "test2" begin 
        using Test
        using CognitiveWorkload

        modules = [:procedural,:declarative,:imaginal,:motor,:visual,:audio,:speech,:temporal]
        weights = [2.0, 4.0, 4.0, 1.0, 1.0, 1.0, 1.0, 1.0]
        res = .5 #seconds
        start_time = 0.0
        end_time = 20
        times = res:res:end_time 
        activity = Activity[]

        a = Activity(;start_time=0.0, end_time=1.0, idx=1, Module="procedural")
        push!(activity, a)

        w1,a1 = compute_workload(activity, res, weights, 0, 1)
        @test w1 == [2,2]
        @test a1[1,:] == [1.0,  0.0,  0.0,  0.0,  0.0,  0.0, 0.0,  0.0]
        @test a1[2,:] == [1.0,  0.0,  0.0,  0.0,  0.0,  0.0, 0.0,  0.0]

        activity = Activity[]

        a = Activity(;start_time=0.25, end_time=1.25, idx=1, Module="procedural")
        push!(activity, a)

        w2,a2 = compute_workload(activity, res, weights, 0, 1.5)
        @test w2 == [1,2,1]
        @test a2[1,:] == [0.5,  0.0,  0.0,  0.0,  0.0,  0.0, 0.0,  0.0]
        @test a2[2,:] == [1.0,  0.0,  0.0,  0.0,  0.0,  0.0, 0.0,  0.0]
        @test a2[3,:] == [0.5,  0.0,  0.0,  0.0,  0.0,  0.0, 0.0,  0.0]

        activity = Activity[]

        a = Activity(;start_time=0.25, end_time=1.25, idx=1, Module="procedural")
        push!(activity, a)

        a = Activity(;start_time=0.4, end_time=1.1, idx=4, Module="motor")
        push!(activity, a)

        w3,a3 = compute_workload(activity, res, weights, 0, 1.5)
        @test w3 ≈ [1.2,3,1.2]
        @test a3[1,:] ≈ [0.5,  0.0,  0.0,  0.2,  0.0,  0.0, 0.0,  0.0]
        @test a3[2,:] ≈ [1.0,  0.0,  0.0,  1.0,  0.0,  0.0, 0.0,  0.0]
        @test a3[3,:] ≈ [0.5,  0.0,  0.0,  0.2,  0.0,  0.0, 0.0,  0.0]
    end
end