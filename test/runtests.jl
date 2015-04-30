using HyperRectangles
using HyperRectangles.Relations
using HyperRectangles.Operations
using Base.Test

# test constructors and containment
let
    a= HyperRectangle{Float64,4}([Inf,Inf,Inf,Inf],[-Inf,-Inf,-Inf,-Inf])

    update!(a, [1,2,3,4])

    @test a == HyperRectangle{Float64,4}([1.0,2.0,3.0,4.0],[1.0,2.0,3.0,4.0])
    @test a != HyperRectangle{Float64,4}([3.0,2.0,3.0,4.0],[1.0,2.0,3.0,4.0])

    update!(a, [5,6,7,8])

    b = HyperRectangle{Float64,4}([1.0,2.0,3.0,4.0],[5.0,6.0,7.0,8.0])
    @test a == b
    @test isequal(a,b)

    @test max(a) == [5.0,6.0,7.0,8.0]
    @test min(a) == [1.0,2.0,3.0,4.0]

    @test_throws ErrorException HyperRectangle([1.0,2.0,3.0],[1.0,2.0,3.0,4.0])

    @test in(a,b) && in(b,a) && contains(a,b) && contains(b,a)

    c = HyperRectangle([1.1,2.1,3.1,4.1],[4.0,5.0,6.0,7.0])

    @test !in(a,c) && in(c,a) && contains(a,c) && !contains(c,a)
end

# Testing split function
let
    d = HyperRectangle{Float64,4}([1.0,2.0,3.0,4.0],[2.0,3.0,4.0,5.0])
    d1, d2 = split(d, 3, 3.5)

    @test d1.max[3] == 3.5 && d1.min[3] == 3.0
    @test d2.max[3] == 4.0 && d2.min[3] == 3.5
end

#test points function
let
    a = HyperRectangle([0,0],[1,1])
    pt_expa = Vector[[0,0],[0,1],[1,0],[1,1]]
    @test points(a) == pt_expa
    b = HyperRectangle([0,0,0],[1,1,1])
    pt_expb = Vector[[0,0,0],[0,0,1],[0,1,0],[0,1,1],[1,0,0],[1,0,1],[1,1,0],[1,1,1]]
    @test points(b) == pt_expb
end

# test empty constructor on 0.4
if VERSION >= v"0.4.0-"
    let
        a = HyperRectangle{Float64, 4}()
        @test a == HyperRectangle{Float64,4}([Inf,Inf,Inf,Inf],[-Inf,-Inf,-Inf,-Inf])
    end
end

# Test distance functions
let
    a = HyperRectangle([0.0,0.0], [1.0, 1.0])
    b = HyperRectangle([2.0,3.0], [3.0, 4.0])
    p = [2.5, 1.5]

    # Rect - Rect
    @test min_dist_dim(a, b, 1) == 1.0
    @test min_dist_dim(a, b, 2) == 2.0
    @test max_dist_dim(a, b, 1) == 3.0
    @test max_dist_dim(a, b, 2) == 4.0

    @test min_euclideansq(a, b) == 5.0
    @test max_euclideansq(a, b) == 25.0
    @test minmax_euclideansq(a, b) == (5.0, 25.0)

    @test min_euclidean(a, b) == sqrt(5.0)
    @test max_euclidean(a, b) == sqrt(25.0)
    @test minmax_euclidean(a, b) == (sqrt(5.0), sqrt(25.0))

    # Rect - Point
    @test min_dist_dim(a, p, 1) == 1.5
    @test max_dist_dim(a, p, 1) == 2.5
    @test minmax_dist_dim(a, p, 1) == (1.5, 2.5)

    @test min_dist_dim(a, p, 2) == 0.5
    @test max_dist_dim(a, p, 2) == 1.5
    @test minmax_dist_dim(a, p, 2) ==(0.5, 1.5)

    @test min_euclideansq(a, p) == 2.5
    @test max_euclideansq(a, p) == 8.5
    @test minmax_euclideansq(a, p) == (2.5, 8.5)

    @test min_euclidean(a, p) == sqrt(2.5)
    @test max_euclidean(a, p) == sqrt(8.5)
    @test minmax_euclidean(a, p) == (sqrt(2.5), sqrt(8.5))

    p2 = [0.75, 0.75]
    @test min_dist_dim(a, p2, 1) == 0.0
    @test min_dist_dim(a, p2, 2) == 0.0

    b2  = HyperRectangle([0.25, 0.25], [0.75,0.75])
    @test min_dist_dim(a, b2, 1) == 0
    @test min_dist_dim(a, b2, 2) == 0
end