# 2021-11-06T21:38:00
if Base.VERSION >= v"1.4.2" && ccall(:jl_generating_output, Cint, ()) == 1

  # ArgumentModes.Impl

  Base.precompile(Tuple{typeof(~),Mode[==, :a => Int64],Mode[==, :a]})   # time: 0.21385093
  Base.precompile(Tuple{typeof(which(ArgumentModes.Impl._Mode_instance_g,(Any,Any,)).generator.gen),Any,Any,Any})   # time: 0.14990702
  Base.precompile(Tuple{Type{Pair},Mode[==, :a],Int64})   # time: 0.07459128
  Base.precompile(Tuple{typeof(checkmode),Mode[==, :a, :b => Int64, :c => Float64],typeof(==),Symbol,Symbol})   # time: 0.034551956
  Base.precompile(Tuple{typeof(checkmode),Mode[==, :a, :b => Int64, :c => Float64],Symbol,Symbol,Symbol})   # time: 0.020513222
  Base.precompile(Tuple{typeof(checkmode),Function,Mode[==, :a, :b => Int64, :c => Float64],typeof(==),Symbol,Symbol,Vararg{Symbol, N} where N})   # time: 0.014792388
  Base.precompile(Tuple{typeof(which(ArgumentModes.Impl._getindex_g,(Any,Any,Any,)).generator.gen),Any,Any,Any,Any})   # time: 0.013510224
  Base.precompile(Tuple{typeof(ArgumentModes.Impl._Mode_instance_g),Val{(:b,)},Tuple{Pair{Symbol, Int64}}})   # time: 0.01279773
  Base.precompile(Tuple{typeof(which(ArgumentModes.Impl._extract_symbols_from_args_g,(Any,)).generator.gen),Any,Any})   # time: 0.012365534
  Base.precompile(Tuple{typeof(getindex),Mode[==, :a, :b => Int64],Symbol,Symbol})   # time: 0.00898272
  Base.precompile(Tuple{typeof(show),IOBuffer,Type{Mode[==, :a => Float64, :b => String, :c, :d => Int64]}})   # time: 0.0088238
  Base.precompile(Tuple{Type{Pair},Mode[==, :m2],String})   # time: 0.006326404
  Base.precompile(Tuple{typeof(ArgumentModes.Impl._Mode_instance_g),Val{(:a, :b, :c, :d)},Tuple{Pair{Symbol, Float64}, Pair{Symbol, String}, Symbol, Pair{Symbol, Int64}}})   # time: 0.002360393
  Base.precompile(Tuple{typeof(getindex),Type{Mode},Symbol,Pair{Symbol, DataType},Pair{Symbol, Union}})   # time: 0.00193502
  Base.precompile(Tuple{typeof(show),IOBuffer,Type{Mode}})   # time: 0.001645881
  Base.precompile(Tuple{typeof(show),IOBuffer,Type{Mode[:a => Int64, :b => Float64, :c, :d => String]}})   # time: 0.001585353
  Base.precompile(Tuple{typeof(getindex),Type{Mode},Symbol,Symbol})   # time: 0.001176902
  Base.precompile(Tuple{typeof(ArgumentModes.Impl._extract_symbols_from_args_g),Tuple{Pair{Symbol, Float64}, Pair{Symbol, String}, Symbol, Pair{Symbol, Int64}}})   # time: 0.001118686

end
