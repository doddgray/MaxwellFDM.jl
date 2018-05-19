@testset "gridgen" begin
rt = R_TARGET_DEFAULT  # 1.9
rmax = R_MAX_DEFAULT  # 2.0

@testset "gen_lprim1d for fixed intervals to fail" begin
    domain = OpenInterval((-3.155830993045275,1.1707739814306768),0.13507892645230862)
    intvprim = [ClosedInterval((-0.186399,0.502855),0.0689254), ClosedInterval((-0.330103,1.17077),0.150088)]
    intvdual = ClosedInterval[]

    lprim0 = MaxwellFDM.Float[]
    ldual0 = MaxwellFDM.Float[]

    sublprim = MaxwellFDM.gen_sublprim1d(domain, PRIM, intvprim, intvdual, lprim0, ldual0)
    # info("sublprim = $sublprim")
    @test_throws ErrorException MaxwellFDM.gen_lprim1d(domain, PRIM, intvprim, intvdual, lprim0, ldual0, rt, rmax)
end  # @testset "gen_lprim1d for fixed intervals to fail"

@testset "gen_lprim1d for fixed intervals" begin
    domain = OpenInterval((-100,100),10)
    intvprim = [ClosedInterval((-100,-20)), ClosedInterval((20,100)), ClosedInterval((-30,30),1)]
    intvdual = ClosedInterval[]

    lprim0 = MaxwellFDM.Float[-75, 75]
    ldual0 = MaxwellFDM.Float[-10,0,10]

    sublprim = MaxwellFDM.gen_sublprim1d(domain, PRIM, intvprim, intvdual, lprim0, ldual0)
    # info("sublprim = $sublprim")
    @test typeof(sublprim) == Vector{Vector{MaxwellFDM.Float}}
    @test isodd(length(sublprim))
    subgrid = sublprim[1:2:end]
    ∆lt = sublprim[2:2:end]
    @test length.(∆lt) == ones(Int, length(∆lt))
    # info("domain = $domain")
    # info("intvprim = $intvprim")
    # info("lprim0 = $lprim0")
    # info("ldual0 = $ldual0")
    # info("rt = $rt")
    # info("rmax = $rmax")
    lprim = MaxwellFDM.gen_lprim1d(domain, PRIM, intvprim, intvdual, lprim0, ldual0, rt, rmax)
    # info("lprim = $lprim")
    @test all(lprim[[1,end]] .== bounds(domain))
    @test MaxwellFDM.issmooth(diff(lprim), rmax)
end  # @testset "gen_lprim1d for fixed intervals"

@testset "gen_lprim1d for fixed intervals, dual domain" begin
    domain = OpenInterval((-100,100),10)
    intvprim = [ClosedInterval((-100,-20)), ClosedInterval((20,100)), ClosedInterval((-30,30),1)]
    intvdual = ClosedInterval[]

    lprim0 = MaxwellFDM.Float[-75, 75]
    ldual0 = MaxwellFDM.Float[-10,0,10]

    sublprim = MaxwellFDM.gen_sublprim1d(domain, DUAL, intvprim, intvdual, lprim0, ldual0)
    # info("sublprim = $sublprim")
    @test typeof(sublprim) == Vector{Vector{MaxwellFDM.Float}}
    @test isodd(length(sublprim))
    subgrid = sublprim[1:2:end]
    ∆lt = sublprim[2:2:end]
    @test length.(∆lt) == ones(Int, length(∆lt))
    # info("domain = $domain")
    # info("intvprim = $intvprim")
    # info("lprim0 = $lprim0")
    # info("ldual0 = $ldual0")
    # info("rt = $rt")
    # info("rmax = $rmax")
    lprim = MaxwellFDM.gen_lprim1d(domain, DUAL, intvprim, intvdual, lprim0, ldual0, rt, rmax)
    # info("lprim = $lprim")
    @test mean(lprim[1:2]) == bounds(domain)[1]
    @test mean(lprim[end-1:end]) == bounds(domain)[2]
    @test MaxwellFDM.issmooth(diff(lprim), rmax)
end  # @testset "gen_lprim1d for fixed intervals, dual domain"

@testset "gen_lprim1d for randomly generated intervals" begin  # case generated by @testset "gen_lprim1d for random intervals"
    domain = OpenInterval((-2.4275370034248813,1.5578784568403026),0.0038696573133163836)
    intvprim = [ClosedInterval((-2.42754,-0.105743),0.00429962),
                ClosedInterval((-0.433823,1.49839),0.00357817),
                ClosedInterval((0.751153,1.55788),0.00149394),
                ClosedInterval((-0.409778,-0.21345),0.00036357)]
    intvdual = ClosedInterval[]

    lprim0 = [-0.314801,-0.314801,-0.770512,-0.685944,-0.664589]
    ldual0 = [-0.395004,-0.225236,0.081886,-0.477425]

    sublprim = MaxwellFDM.gen_sublprim1d(domain, PRIM, intvprim, intvdual, lprim0, ldual0)
    # info("sublprim = $sublprim")
    @test typeof(sublprim) == Vector{Vector{MaxwellFDM.Float}}
    @test isodd(length(sublprim))
    subgrid = sublprim[1:2:end]
    ∆lt = sublprim[2:2:end]
    @test length.(∆lt) == ones(Int, length(∆lt))
    lprim = MaxwellFDM.gen_lprim1d(domain, PRIM, intvprim, intvdual, lprim0, ldual0, rt, rmax)
    # info("lprim = $lprim")
    @test all(lprim[[1,end]] .== bounds(domain))
    @test MaxwellFDM.issmooth(diff(lprim), rmax)
end  # @testset "gen_lprim1d for randomly generated intervals"

@testset "gen_lprim1d for randomly generated intervals, dual domain" begin  # case generated by @testset "gen_lprim1d for random intervals, dual domain"
    domain = OpenInterval((-2.4275370034248813,1.5578784568403026),0.0038696573133163836)
    intvprim = [ClosedInterval((-2.42754,-0.105743),0.00429962),
                ClosedInterval((-0.433823,1.49839),0.00357817),
                ClosedInterval((0.751153,1.55788),0.00149394),
                ClosedInterval((-0.409778,-0.21345),0.00036357)]
    intvdual = ClosedInterval[]

    lprim0 = [-0.314801,-0.314801,-0.770512,-0.685944,-0.664589]
    ldual0 = [-0.395004,-0.225236,0.081886,-0.477425]

    sublprim = MaxwellFDM.gen_sublprim1d(domain, DUAL, intvprim, intvdual, lprim0, ldual0)
    # info("sublprim = $sublprim")
    @test typeof(sublprim) == Vector{Vector{MaxwellFDM.Float}}
    @test isodd(length(sublprim))
    subgrid = sublprim[1:2:end]
    ∆lt = sublprim[2:2:end]
    @test length.(∆lt) == ones(Int, length(∆lt))
    lprim = MaxwellFDM.gen_lprim1d(domain, DUAL, intvprim, intvdual, lprim0, ldual0, rt, rmax)
    # info("lprim = $lprim")

    # Entries of diff(wprim) can exceed max∆l(domain)[w], but not much.  See gridgen.jl:fill_constant
    @test all(diff(lprim) .< max∆l(domain)*rmax)
    @test mean(lprim[1:2]) == bounds(domain)[1]
    @test mean(lprim[end-1:end]) == bounds(domain)[2]
    @test MaxwellFDM.issmooth(diff(lprim), rmax)
end  # @testset "gen_lprim1d for randomly generated intervals, dual domain"

@testset "comp_lprim1d" begin
    sublprim = [[0., 0.5], [1.], [10., 11., 12], [1.5], [20.5, 21.], [2.], [30., 31.]];
    lprim = MaxwellFDM.comp_lprim1d(sublprim, rt, rmax)
    @test MaxwellFDM.issmooth(diff(lprim), rmax)
    lprim_result = [0.0,0.5,1.20711,2.20711,3.32038,4.43365,5.54692,6.66019,7.77346,8.88673,10.0,11.0,12.0,13.6982,15.3964,17.0947,18.7929,19.7929,20.5,21.0,21.7071,22.7071,23.7071,24.909,26.3536,27.7981,29.0,30.0,31.0]
    @test isapprox(lprim, lprim_result, rtol = 1e-6)
end  # @testset "comp_lprim1d"

# Test with shapes
@testset "gen_lprim" begin
    ∆L = 5
    ∆l = 1

    ge = PRIM
    vac = Material("vacuum")
    evac = EncodedMaterial(ge, vac)
    domain = Object(Box([0,0,0], [200,200,200]), evac, 10)

    h = 50
    r = 20
    sprim = [Object(Cylinder([0,0,0],r,[0,0,1],h), evac, [∆l,∆l,∆L]), Object(Sphere([0,0,h/2], r), evac, ∆l), Object(Sphere([0,0,-h/2], r), evac, ∆l)]
    # sprim = [Object(Sphere([0,0,0],r), evac, [∆l,∆l,∆L]), Object(Sphere([0,0,h/2], r), evac, ∆l), Object(Sphere([0,0,-h/2], r), evac, ∆l)]

    (xprim, yprim, zprim) = gen_lprim(domain, (PRIM,PRIM,PRIM), sprim)
    # info("xprim = $xprim")
    # info("yprim = $yprim")
    # info("zprim = $zprim")
    @test xprim == yprim

    # Entries of diff(wprim) can exceed max∆l(domain)[w], but not much.  See gridgen.jl:fill_constant
    @test all(diff(xprim) .< max∆l(domain)[nX]*rmax)
    @test all(diff(yprim) .< max∆l(domain)[nY]*rmax)
    @test all(diff(zprim) .< max∆l(domain)[nZ]*rmax)

    @test MaxwellFDM.issmooth(diff(xprim), rmax)
    @test MaxwellFDM.issmooth(diff(yprim), rmax)
    @test MaxwellFDM.issmooth(diff(zprim), rmax)
end

end  # @testset "gridgen"
