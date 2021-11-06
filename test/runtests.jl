using ArgumentModes
using Test

@test Mode(:a, :b => 1, :c => "sdf") isa 
  Mode[:a, :b => Int, :c => Union{Float64, AbstractString}]
@test !(Mode(:a, :b => 1, :c => 2) isa 
  Mode[:a, :b => Int, :c => Union{Float64, AbstractString}])

@test repr(Mode(:a => 1., :b => "1", :c , :d => 2)) == 
  "Mode[==, :a => Float64, :b => String, :c, :d => Int64]"*
  "((a = 1.0, b = \"1\", c = nothing, d = 2))"
@test repr(Mode[:a => Int, :b => Float64, :c , :d => String]) == 
  "Mode[:a => Int64, :b => Float64, :c, :d => String]"  
@test repr(Mode) == "Mode"

@test Mode[:a, :b => Int, :c => Float64] == 
  Mode[:c => Float64, :a, :b => Int] == Mode[:c => Float64, :b => Int, :a]

@test typeof(Mode(:a, :b => 1, :c => "sdf")) == 
  Mode[==, :b => Int, :c => String, :a] ==
  typeof(Mode(:b => 1, :a, :c => "sdf")) == 
  Mode[==, :a, :c => String,:b => Int]


f(x::Mode[:mode1]) = 1
f(x::Mode[:mode2]) = 2
f(x::Mode[:mode1, :mode2]) = 3
f(x::Mode[:mode1, :mode2, :mode3]) = 4

@test f(Mode(:mode1)) == 1
@test f(Mode(:mode2)) == 2
@test f(Mode(:mode1, :mode2)) == 3
@test f(Mode(:mode3)) == 4
@test f(Mode(:mode1, :mode3)) == 4

@test Mode(:a) == Mode(:a => nothing)
@test (Mode(:a) ~ Mode(:b)) == Mode(:a, :b)
@test (Mode(:a)=>3 ~ Mode(:b)) == Mode(:a=>3, :b)
@test_throws ArgumentError Mode(:a)=>3 ~ Mode(:a)

@test keys(Mode(:a, :b=> 3)) == (:a, :b)
@test values(Mode(:a, :b=> 3)) == (nothing, 3)
@test collect(pairs(Mode(:a, :b=> 3))) == [:a=> nothing, :b=> 3]

@test !(Mode(:a => 5) isa Mode[:a => Float64])
@test Mode(:a => 5) isa Mode[:a => Real]

@test Mode(:a, :b=> 3)[:a, :b] == (nothing, 3)
@test Mode(:a, :b=> 3)[:b] == 3
@test_throws ArgumentError Mode(:a, :b=> 3)[] 
@test Mode(:b=> 3)[] == 3

m = Mode(:a, :b=> 2, :c=> 3.)
x = 4
@test !checkmode(x, :a)
@test checkmode(m, :a, :b)
@test !checkmode(m, :a, :b, :d)
@test checkmode(m, &, :a, :b)
@test !checkmode(m, &, :a, :b, :d)
@test checkmode(m, |, :a, :b, :d)
@test checkmode(m, |, :a, :b)
@test !checkmode(m, |, :d, :e)
@test !checkmode(m, ==, :a, :b)
@test !checkmode(m, ==, :a, :b, :c, :d)
@test checkmode(m, ==, :a, :b, :c)
@test !checkmode(m, !, :a, :b, :c)
@test !checkmode(m, !, :a, :d, :e)
@test checkmode(m, !, :d, :e)

@test checkmode(m, :b, :c) do  x,y; x,y   end == (2,3.)
@test checkmode(m, :b, :d) do  x,y; x,y   end === nothing
@test checkmode(m, &, :b, :c) do  x,y; x,y   end == (2,3.)
@test checkmode(m, &, :b, :d) do  x,y; x,y   end === nothing
@test checkmode(m, :b) do  x;  x   end == 2
@test checkmode(m, !, :d, :e) do;  1   end == 1
@test checkmode(m, !, :c, :e) do;  1   end === nothing
@test checkmode(m, |, :c, :e) do;  1   end == 1
@test checkmode(m, |, :d, :e) do;  1   end === nothing
@test checkmode(m, ==, :a, :b, :c) do x,y,z;  x,y,z   end == (nothing, 2, 3.)
@test checkmode(m, ==, :a, :b, :c, :d) do x,y,z;  1   end === nothing
@test checkmode(m, ==, :a, :b, :d) do x,y,z;  1   end === nothing
@test checkmode(m, ==, :a, :b) do x,y,z;  1   end === nothing


f2(x::Mode[:m1, :m2 => Int]) = 1
f2(x::Mode[:m1, :m2 => String]) = 2

@test_throws MethodError f2(Mode(:m1) ~ Mode(:m2))
@test f2(Mode(:m1) ~ Mode(:m2)=> 1) == 1
@test f2(Mode(:m1) ~ Mode(:m2)=> "1") == 2
@test_throws MethodError f2(Mode(:m1)=> 1 ~ Mode(:m2)=> 1)
@test_throws MethodError f2(Mode(:m1) ~ Mode(:m3))