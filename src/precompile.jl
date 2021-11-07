# 2021-11-07T14:01:01
if Base.VERSION >= v"1.4.2" && ccall(:jl_generating_output, Cint, ()) == 1
  var"#precompile#int"(f, args...) = f(args...)
  var"#precompile"(f, args...) =
    Base.precompile(Tuple{typeof(var"#precompile#int"), f, args...})

  # Core
  # total time: 0.0



  # Base.MainInclude
  # total time: 0.0



  # Base.Sort
  # total time: 0.014884936

  var"#precompile"(typeof(sortperm),Vector{Symbol})   # time: 0.007626647
  let fbody = try __lookup_kwbody__(which(sortperm, (Vector{Symbol},))) catch missing end
        if !ismissing(fbody)
            var"#precompile"(fbody, Base.Sort.QuickSortAlg,Function,Function,Nothing,Base.Order.ForwardOrdering,typeof(sortperm),Vector{Symbol})
        end
    end   # time: 0.007258289


  # Base.Iterators
  # total time: 0.013343715999999999

  var"#precompile"(typeof(iterate),Base.Iterators.Zip{Tuple{Vector{Symbol}, Vector{Expr}}})   # time: 0.005042564
  var"#precompile"(typeof(iterate),Base.Iterators.Drop{Vector{Pair{Symbol, DataType}}})   # time: 0.003272639
  var"#precompile"(typeof(iterate),Base.Iterators.Zip{Tuple{Vector{Symbol}, Vector{Expr}}},Tuple{Int64, Int64})   # time: 0.00317269
  var"#precompile"(typeof(zip),Vector{Symbol},Vararg{Any, N} where N)   # time: 0.001855823


  # Base.Broadcast
  # total time: 0.032511912

  var"#precompile"(typeof(copy),Base.Broadcast.Broadcasted{Base.Broadcast.Style{Tuple}, Nothing, typeof(in), Tuple{NTuple{4, Symbol}, Tuple{Tuple{Symbol, Symbol, Symbol}}}})   # time: 0.025055496
  var"#precompile"(typeof(copy),Base.Broadcast.Broadcasted{Base.Broadcast.Style{Tuple}, Nothing, typeof(getindex), Tuple{Tuple{NamedTuple{(:a, :b, :c), Tuple{Nothing, Int64, Float64}}}, Tuple{Symbol, Symbol}}})   # time: 0.006404012
  var"#precompile"(Type{Base.Broadcast.Broadcasted{Base.Broadcast.Style{Tuple}, Axes, F, Args} where {Axes, F, Args<:Tuple}},typeof(in),Tuple{NTuple{4, Symbol}, Tuple{Tuple{Symbol, Symbol, Symbol}}})   # time: 0.001052404


  # Base
  # total time: 0.373312223

  var"#precompile"(Type{Base.IteratorSize},Base.Iterators.Zip{Tuple{Vector{Symbol}, Vector{Expr}}})   # time: 0.028020676
  var"#precompile"(Type{Base.IteratorSize},Base.Iterators.Zip{Tuple{Vector{Symbol}, Vector{Symbol}}})   # time: 0.025203701
  var"#precompile"(Type{Base.IteratorSize},Base.Iterators.Zip{Tuple{Vector{Symbol}, Vector{Any}}})   # time: 0.01814107
  var"#precompile"(typeof(getindex),Vector{Symbol},Vector{Int64})   # time: 0.01510981
  var"#precompile"(typeof(==),Vector{Pair{Symbol, Union{Nothing, Int64}}},Vector{Pair{Symbol, Union{Nothing, Int64}}})   # time: 0.012717317
  var"#precompile"(typeof(Base.copymutable),Vector{Pair{Symbol, DataType}})   # time: 0.012320287
  var"#precompile"(Type{Pair},Symbol,Float64)   # time: 0.010663889
  var"#precompile"(typeof(Base.vect),Pair{Symbol, Nothing},Vararg{Any, N} where N)   # time: 0.009562518
  var"#precompile"(typeof(Base.setindex_widen_up_to),Vector{Expr},Symbol,Int64)   # time: 0.008246483
  var"#precompile"(typeof(foldl),Function,Tuple{Bool, Bool, Bool})   # time: 0.007966861
  var"#precompile"(typeof(foldl),Function,NTuple{4, Bool})   # time: 0.006025352
  let fbody = try __lookup_kwbody__(which(mapfoldl, (Function,Function,NTuple{4, Bool},))) catch missing end
        if !ismissing(fbody)
            var"#precompile"(fbody, Base._InitialValue,typeof(mapfoldl),Function,Function,NTuple{4, Bool})
        end
    end   # time: 0.005161738
  var"#precompile"(typeof(getindex),Vector{DataType},Vector{Int64})   # time: 0.004795045
  var"#precompile"(typeof(Base.setindex_widen_up_to),Vector{Symbol},Expr,Int64)   # time: 0.004716734
  let fbody = try __lookup_kwbody__(which(mapfoldl, (Function,Function,Tuple{Bool, Bool, Bool},))) catch missing end
        if !ismissing(fbody)
            var"#precompile"(fbody, Base._InitialValue,typeof(mapfoldl),Function,Function,Tuple{Bool, Bool, Bool})
        end
    end   # time: 0.004602275
  var"#precompile"(typeof(collect),Base.Generator{Vector{Symbol}, Type{QuoteNode}})   # time: 0.004223247
  var"#precompile"(typeof(copyto!),Vector{Pair{Symbol, Union{Nothing, Int64}}},Tuple{Pair{Symbol, Nothing}, Pair{Symbol, Int64}})   # time: 0.003908387
  var"#precompile"(typeof(Base.setindex_widen_up_to),Vector{Expr},Expr,Int64)   # time: 0.003778313
  var"#precompile"(typeof(repr),Type)   # time: 0.003444675
  var"#precompile"(typeof(string),String,Tuple{Symbol, Symbol})   # time: 0.003264028
  var"#precompile"(typeof(Base.mapfoldl_impl),typeof(identity),typeof(&),Base._InitialValue,NTuple{4, Bool})   # time: 0.002810136
  var"#precompile"(typeof(Base.promote_typeof),Pair{Symbol, Nothing},Pair{Symbol, Int64})   # time: 0.002365867
  var"#precompile"(typeof(Base.push_widen),Vector{Pair{Symbol, DataType}},Any)   # time: 0.002126327
  var"#precompile"(typeof(==),Tuple{Symbol, Symbol},Tuple{Symbol, Symbol})   # time: 0.00204966
  var"#precompile"(Type{Base.IteratorSize},Base.Iterators.Enumerate{Core.SimpleVector})   # time: 0.001976853
  var"#precompile"(typeof(Base._array_for),Type{Expr},Base.Iterators.Zip{Tuple{Vector{Symbol}, Vector{Any}}},Base.HasShape{1})   # time: 0.001738193
  var"#precompile"(typeof(push!),Vector{Pair{Symbol, DataType}},Pair{Symbol, DataType})   # time: 0.001541832
  var"#precompile"(typeof(Base.setindex_widen_up_to),Vector{Symbol},Symbol,Int64)   # time: 0.001493033
  var"#precompile"(Type{Pair},Symbol,Type)   # time: 0.001342879
  var"#precompile"(typeof(==),Tuple{Int64, Float64},Tuple{Int64, Float64})   # time: 0.001154466
  var"#precompile"(typeof(Base._array_for),Type{Expr},Base.Iterators.Zip{Tuple{Vector{Symbol}, Vector{Symbol}}},Base.HasShape{1})   # time: 0.001013987


  # ArgumentModes.Impl
  # total time: 0.740025636

  var"#precompile"(typeof(~),Mode[==, :a => Int64],Mode[==, :a])   # time: 0.20711419
  var"#precompile"(typeof(which(ArgumentModes.Impl._Mode_instance_g,(Any,Any,)).generator.gen),Any,Any,Any)   # time: 0.15569615
  var"#precompile"(typeof(show),IOBuffer,Type{Mode[==, :a => Float64, :b => String, :c, :d => Int64]})   # time: 0.03318364
  var"#precompile"(typeof(checkmode),Mode[==, :a, :b => Int64, :c => Float64],typeof(==),Symbol,Symbol)   # time: 0.027065475
  var"#precompile"(typeof(checkmode),Mode[==, :a, :b => Int64, :c => Float64],typeof(|),Symbol,Symbol)   # time: 0.023050297
  var"#precompile"(typeof(checkmode),Mode[==, :a, :b => Int64, :c => Float64],Symbol,Symbol,Symbol)   # time: 0.021079471
  var"#precompile"(typeof(checkmode),Mode[==, :a, :b => Int64, :c => Float64],typeof(!),Symbol,Symbol,Symbol)   # time: 0.020862447
  var"#precompile"(typeof(~),Mode[==, :a],Mode[==, :b])   # time: 0.017923424
  var"#precompile"(typeof(checkmode),Function,Mode[==, :a, :b => Int64, :c => Float64],typeof(==),Symbol,Symbol,Vararg{Symbol, N} where N)   # time: 0.016142227
  var"#precompile"(typeof(which(ArgumentModes.Impl._extract_symbols_from_args_g,(Any,)).generator.gen),Any,Any)   # time: 0.013818592
  var"#precompile"(typeof(checkmode),Mode[==, :a, :b => Int64, :c => Float64],typeof(==),Symbol,Symbol,Symbol,Vararg{Symbol, N} where N)   # time: 0.013255158
  var"#precompile"(typeof(checkmode),Mode[==, :a, :b => Int64, :c => Float64],typeof(|),Symbol,Symbol,Symbol)   # time: 0.011424678
  var"#precompile"(Type{Pair},Mode[==, :m2],String)   # time: 0.009898064
  var"#precompile"(typeof(which(ArgumentModes.Impl._getindex_g,(Any,Any,Any,)).generator.gen),Any,Any,Any,Any)   # time: 0.009702764
  var"#precompile"(typeof(getindex),Mode[==, :a, :b => Int64],Symbol,Symbol)   # time: 0.009164862
  var"#precompile"(typeof(~),Mode[==, :m1 => Int64],Mode[==, :m2 => Int64])   # time: 0.00815442
  var"#precompile"(typeof(~),Mode[==, :m1],Mode[==, :m2 => String])   # time: 0.007593852
  var"#precompile"(typeof(checkmode),Mode[==, :a, :b => Int64, :c => Float64],typeof(!),Symbol,Symbol)   # time: 0.006211011
  var"#precompile"(Type{Pair},Mode[==, :m2],Int64)   # time: 0.005805799
  isdefined(ArgumentModes.Impl, Symbol("#f#19")) && var"#precompile"(getfield(ArgumentModes.Impl, Symbol("#f#19")),Pair{Symbol, DataType})   # time: 0.003805427
  var"#precompile"(typeof(ArgumentModes.Impl._Mode_instance_g),Val{(:a, :b, :c, :d)},Tuple{Pair{Symbol, Float64}, Pair{Symbol, String}, Symbol, Pair{Symbol, Int64}})   # time: 0.002551479
  var"#precompile"(typeof(getindex),Type{Mode},Symbol,Pair{Symbol, DataType},Pair{Symbol, Union})   # time: 0.001971067
  var"#precompile"(typeof(ArgumentModes.Impl._extract_symbols_from_args_g),Tuple{Pair{Symbol, Float64}, Pair{Symbol, String}, Symbol, Pair{Symbol, Int64}})   # time: 0.001938178
  var"#precompile"(typeof(show),IOBuffer,Type{Mode})   # time: 0.001661923
  var"#precompile"(typeof(show),IOBuffer,Type{Mode[:a => Int64, :b => Float64, :c, :d => String]})   # time: 0.001531112
  var"#precompile"(Type{Mode},Pair{Symbol, Nothing})   # time: 0.001299248
  var"#precompile"(typeof(pairs),Mode[==, :a, :b => Int64])   # time: 0.001058294

end
