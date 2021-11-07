module Impl
export Mode, checkmode


"""
    struct Mode
\n `Mode` could be seen as an extension of `Val` and is intended to be used as 
a type for a function argument. Its semantics is a set of symbols (flags) whose 
value is taken into account during method dispatch. A specialization of `Mode`  
allows to declare a list of symbols which a function method would accept for 
the argument. The symbols could be accompanied with additional parameters with 
prescribed types.

Here is a more detailed description of the mechanics of the type. A specialized 
`Mode` type **M=Mode{[s₁⇒t₁, s₂⇒t₂, ...]}** is determined by a collection of 
symbols **s₁**, **s₂**, ...  of type `Symbol` and corresponding types **t₁**, 
**t₂**, ... (of type `DataType` or `Union` of `DataType`s). An instance 
**m::Mode** of `Mode` additionally contains values **vᵢ** for each **sᵢ** of 
type **tᵢ**. Let **param(x)** denote the collection **{sᵢ=>tᵢ}ᵢ** of **x** 
(here **x** is an instance or a specialized type of `Mode`). Then **m** is of 
type **M** only if **param(m) ⊆ param(M)**. This allows the dispatch to choose 
an appropriate method of a function based on **param(m)**.

See also: [`checkmode`](@ref)

# Constructor of the type specialization
    Mode[ s₁ [=> t₁] [, s₂ [=> t₂]]... ]
\n Construct a specialization **M=Mode{[s₁⇒t₁, s₂⇒t₂, ...]}** to be used as a 
type for a argument in a function method declaration. The argument with type 
**M** would accept only instances **m::Mode** with **param(m) ⊆ param(M)**. 
Some or all **tᵢ** may absent in the type declaration which defaults to 
`Nothing`. An example: `Mode[:a, :b => Int, :c => Tuple{Int, String}]`.

Symbol `==` could also be added as the first argument in a constructor call to indicate that the concrete type is wanted (not an `UnionAll` as above). This
option is added only for auxiliary purposes and generally should not be useful.

Note that such nonconventional syntax with brackets `[`,`]` is used to make the 
code for a type declaration look similar to the presentation of the type name 
in a function signature.

# Constructors of an instance
    Mode( s₁[=> v₁] [, s₂ [=> v₂]]... )
\n Construct an instance **m::Mode{[s₁⇒typeof(v₁), s₂⇒typeof(v₂), ...]}** with
values **v₁, v₂, ...**. Some or all of **vᵢ** might be omited which defaults to 
`nothing`. An example: `Mode(:a => 25, :b, :c => "Hello world!")`.

    Mode(s)
\n Construct an instance **m::Mode{[s⇒Nothing]}** with `nothing` value. The 
type and value could be set by a subsequent call **m**`=>`**v**. Several 
instances could be joined with `~` operator. For example, `Mode(:a)=> 25 ~ Mode
(:b) ~ Mode(:c)=> "Hello world!"` is equivalent to `Mode(:a => 25, :b, :c => 
"Hello world!")`.

# Operations on an instance
Let **m, m₁, m₂::Mode**. Then
- `m => v` given `m::Mode{[s => Nothing]}`: return a new instance with symbol 
  **s** having value and type of `v`. 
- `m₁ ~ m₂`: join `m₁` and `m₂`. Throws an ArgumentError if `m₁` and `m₂` 
  contain the same symbols.
- `keys(m), values(m), pairs(m)`: return symbols / values / pairs of symbols 
  and values.
- `m[s₁ [, s₂]... ]` for `sᵢ::Symbol`: return the value of `s₁` / tuple of 
  values of `s₁, s₂, ...`.
- `m[]`: if `m` contains only one value, return it; throw an ArgumentError 
  otherwise
- `checkmode(m, ...)`: check if `m` is a `Mode` and contains the prescribed  
  symbols, and, possibly, do an action. See [`ArgumentModes.checkmode`](@ref) 
  for detailed description.

# Examples

### 1. Usage in function declarations and calls
```julia-repl
julia> f(x) = println("Anything: \$x")
       f(x::Mode[:iterator => Any]) = println("Values from iterator: \$(x[]...)")
       f(x::Mode[:fromargs], y...) = println("Fromargs: \$(y...)")
       function f(x::Union{Int, Mode[:a, :b, :c => Int]})
           checkmode(x, :a) do _;  println(":a")  end
           checkmode(x, :c) do c;  println(":c = \$c")  end
           checkmode(x, :b) && println(":b")
           if x isa Int;  println("x = \$x") end
       end
f (generic function with 4 methods)

julia> methods(f)
# 4 methods for generic function "f":
[1] f(x::Mode[:iterator => Any]) in Main at REPL[34]:1
[2] f(x::Mode[:fromargs], y...) in Main at REPL[36]:1
[3] f(x::Union{Int64, Mode[:c => Int64, :a, :b]}) in Main at REPL[38]:1
[4] f(x) in Main at REPL[33]:1

julia> f(25.0)
Anything: 25.0

julia> f(Mode(:iterator)=> 1:5)
Values from iterator: 12345

julia> f(Mode(:fromargs), 1, 2, 3, 4, 5)
Fromargs: 12345

julia> f(1)
x = 1

julia> f(Mode(:a, :c => 125))
:a
:c = 125

julia> f(Mode(:fromargs, :iterator => 1:5), 2)
ERROR: MethodError: no method matching f(::Mode[==, :iterator => UnitRange, :fromargs], ::Int64)
Closest candidates are:
  f(::Mode[:fromargs], ::Any...) at REPL[36]:1
  f(::Any) at REPL[33]:1
Stacktrace:
 [1] top-level scope
   @ REPL[59]:1

```

### 2. Construction of types and instances, operations on an instance
```julia-repl
julia> M = Mode[:a => Real, :b => Union{Number, String}, :c]
Mode[:a => Real, :b => Union{Number, String}, :c]

julia> m1 = Mode(:a => 2.5, :c)
Mode[==, :a => Float64, :c]((a = 2.5, c = nothing))

julia> m1 isa M
true

julia> m2 = Mode(:a)=> 2.5 ~ Mode(:c)
Mode[==, :a => Float64, :c]((a = 2.5, c = nothing))

julia> m1 === m2
true

julia> Mode(:a => 2.5, :c, :d) isa M
false

julia> Mode(:a => "2", :c) isa M
false

julia> Mode(:a => 2.5, :c) ~ Mode(:b)=> "Hello world!"
Mode[==, :a => Float64, :c, :b => String]((a = 2.5, b = "Hello world!", c = nothing))

julia> Mode(:a => 2.5, :c) ~ Mode(:b)=> "Hello world!" ~ Mode(:a)=> 2
ERROR: ArgumentError: Duplicated keys :a

julia> checkmode(m, :a)
true

julia> checkmode(m, &, :a, :b, :g)
false

julia> checkmode(m, |, :a, :b, :g)
true

julia> m[:a, :c]
(2.5, nothing)

julia> m2 = Mode(:a => 2.5)
Mode[:a => Float64]((a = 2.5,))

julia> m2[]
2.5
```

# Notes

- `show` is redefined for the `DataType` of `Mode` for more compact and 
  pleasent presentation of **s⇒t** pairs declared in the type. The actual 
  signature of the type is `struct ArgnmentModes.Mode{NameType, 
  ValuesNamedTuple}` where `NameType` containes all pairs **s⇒t** and 
  `ValuesNamedTuple` contains `NamedTuple` for storing the actual values 
  associated with the symbols.
"""
struct Mode{NameType, ValuesNamedTuple}
  values::ValuesNamedTuple
end

@inline Mode() = Mode{Union{}, typeof((;))}((;))

# using @generated to reduce compilation/inference time
@generated function _Mode_instance_g(symbs, kwargs)
  #@nospecialize
  n = length(kwargs.parameters)
  types = Vector{DataType}(undef, n)
  for (i,e) in enumerate(kwargs.parameters)
    if e == Symbol;  types[i] = Nothing;   
    else   types[i] = e.parameters[2]   end
  end
  symbs = Symbol[symbs.parameters[1]...]
  
  if n == 1;   si = [1]
  else
    si = sortperm(symbs)
    symbs = symbs[si]
    types = types[si]
  end

  for i in 2:length(symbs)
    if symbs[i-1] == symbs[i]
      dubls = unique(symbs[j]  for j in i:length(symbs)  
        if symbs[j-1] == symbs[j])
      msg = "Duplicated keys $(join(QuoteNode.(dubls), ", "))"
      return quote
        $(Expr(:meta, :inline))
        throw(ArgumentError($msg))
      end
    end
  end

  tpls = [:(  Tuple{$(QuoteNode(symbs[i])),$(types[i])}  )  for i in 1:n]
  vals = [types[i] == Nothing ? :(nothing) : :(kwargs[$(si[i])][2])  
    for i in 1:n]
  ntvals = [Expr(:kw, s, v)  for (s,v) in zip(symbs, vals)]
  qsymbs = [QuoteNode(s)  for s in symbs]

  if n == 1
    return quote
      $(Expr(:meta, :inline))
      Mode{
          $(tpls...),
          NamedTuple{($(qsymbs...),), Tuple{$(types...)}}
        }((; $(ntvals...)))
    end
  else
    return quote
      $(Expr(:meta, :inline))
      Mode{
          Union{$(tpls...)}, 
          NamedTuple{($(qsymbs...),), Tuple{$(types...)}}
        }((; $(ntvals...)))
    end
  end
end
@generated function _extract_symbols_from_args_g(kwargs)
  #@nospecialize
  vals = Expr[
    x == Symbol ? :(kwargs[$i]) : :(kwargs[$i][1])
    for (i,x) in enumerate(kwargs.parameters)
  ]
  quote
    $(Expr(:meta, :inline))
    Val{($(vals...),)}()
  end
end

@inline function Mode(kwargs::Union{<:Pair{Symbol}, Symbol}...) 
  _Mode_instance_g(_extract_symbols_from_args_g(kwargs), kwargs)
end

@inline Base.:(=>)(::Mode{Tuple{Name, Nothing}}, val) where 
  Name = Mode(Name => val)

@generated function _Combined_namedtuples_to_pairs_g(nt1, nt2)
  #@nospecialize
  n1 = length(nt1.names);   n2 = length(nt2.names)
  prs = Vector{Expr}(undef, n1+n2)
  for i in 1:n1;   prs[i] = :($(QuoteNode(nt1.names[i])) => nt1[$i])   end
  for i in 1:n2;   prs[n1+i] = :($(QuoteNode(nt2.names[i])) => nt2[$i])   end
  quote
    $(Expr(:meta, :inline))
    ($(prs...),)
  end
end

@inline function Base.:(~)(mode1::Mode, mode2::Mode)
  Mode(_Combined_namedtuples_to_pairs_g(mode1.values, mode2.values)...)
end

@generated function _getindex_g(symbs, args, concrete)
  #@nospecialize
  n = length(args.parameters)
  symbs = Symbol[symbs.parameters[1]...]
  si = sortperm(symbs)
  symbs = symbs[si]
  tpls = Vector{Expr}(undef, n)
  if concrete == Val{true}
    types = Vector{Union{Expr, Symbol}}(undef, n)   
  end
  for i in 1:n
    oi = si[i]
    if args.parameters[oi] == Symbol
      tpls[i] = :(Tuple{$(QuoteNode(symbs[i])), Nothing})
      if concrete == Val{true};   types[i] = :(Nothing)   end
    else   
      tpls[i] = :(Tuple{$(QuoteNode(symbs[i])), args[$oi][2]})
      if concrete == Val{true};   types[i] = :(args[$oi][2])   end
    end
  end

  
  
  if concrete == Val{true}
    symbs = QuoteNode[QuoteNode(x)  for x in symbs]
    t1 = n == 1 ? tpls[1] : :(Union{$(tpls...)})
    return quote
      $(Expr(:meta, :inline))
      Mode{$t1, NamedTuple{($(symbs...),), Tuple{$(types...)}}}
    end
  else
    t1 = n == 1 ? tpls[1] : :(<:Union{$(tpls...)})
    return quote
      $(Expr(:meta, :inline))
      Mode{$t1}
    end
  end
end
@inline Base.getindex(::Type{Mode}, args::Union{Pair{Symbol, <:Union{DataType, 
    Union}}, Symbol}...) = 
  _getindex_g(_extract_symbols_from_args_g(args), args, Val(false))
@inline Base.getindex(::Type{Mode}, ::typeof(==), args::Union{Pair{Symbol, 
    <:Union{DataType, Union}}, Symbol}...) = 
  _getindex_g(_extract_symbols_from_args_g(args), args, Val(true))
@inline Base.getindex(::Type{Mode}) = typeof(Mode())
@inline Base.getindex(::Type{Mode}, ::typeof(==)) = typeof(Mode())


@inline Base.keys(m::Mode) = keys(m.values)
@inline Base.values(m::Mode) = values(m.values)
@inline Base.pairs(m::Mode) = pairs(m.values)
@inline Base.getindex(m::Mode, k::Symbol, kk::Symbol...) = 
  getindex.((m.values,), (k, kk...))
@inline Base.getindex(m::Mode, k::Symbol) = m.values[k]
@inline function Base.getindex(m::Mode)
  if length(m.values) == 1 
    m.values[1]
  else
    throw(ArgumentError("Expected exactly one value, but got keys $(keys(m))"))
  end
end

function text_for_type_desc(io, tpls, concrete)
  Base.show_type_name(io, Base.typename(Mode))
  print(io, "[")
  if concrete;   print(io, "==, ")   end

  function f(x)
    print(io, ":", x[1])
    if x[2] != Nothing
      print(io, " => ")
      if x[2] isa Union
        print(io, "Union{")
        types = Base.uniontypes(x[2])
        Base.show_type_name(io, Base.typename(types[1]))
        for t in Iterators.drop(types, 1)
          print(io, ", ")
          Base.show_type_name(io, Base.typename(t))
        end
        print(io, "}")
      else
        Base.show_type_name(io, Base.typename(x[2]))
      end
    end    
  end
  
  pairs = sort(
      [y[1] => y[2]  for y in (x.parameters  for x in tpls)  if length(y) == 2];
      by= x->x[1]
    )

  if length(pairs) > 0
    f(pairs[1])
    for e in Iterators.drop(pairs, 1)
      print(io, ", ")
      f(e)
    end
  end

  print(io, "]")
end

function extract_list_of_elements(m::Type{<:Mode})
  body = m;   while body isa UnionAll;   body = body.body   end
  args = body.parameters[1];   if args isa TypeVar;   args = args.ub   end
  Base.uniontypes(args)
end


function Base.show(io::IO, m::Type{<:Mode})
  if m == typeof(Mode())
    Base.show_type_name(io, Base.typename(Mode))
    print(io, "[]")
  elseif m == Mode
    Base.show_type_name(io, Base.typename(Mode))
  else
    elems = extract_list_of_elements(m)
    text_for_type_desc(io, elems, !(m isa UnionAll))
  end
  nothing
end

"""
    checkmode(m, s::Symbol)
    checkmode(m, [&, |, ==, or !], s₁::Symbol[, s₂:Symbol]...)
    checkmode(f, m, [&, |, ==, or !], s₁::Symbol[, s₂:Symbol]...)
\n Tests if `m` is a `Mode` and contains the prescribed symbols.

- In the 1st form the function tests for the presence of `s` in `m`. 
- In the 2nd form the function tests either (for `&` or if any operation symbol 
  is omited) that all symbols `s₁`, `s₂`, ... are in `m`, or (for `|`) that at 
  least one of them in `m`, or (for `==`) that `m` contains exactly the 
  prescribed collection of the symbols, or (for `!`) that `m` does not contain 
  any of the prescribed symbols. 
- In the 3rd form the function tests whether all of the symbols `s₁`, `s₂`, ... 
  are in `m` (also if `&` is provided). If they are --- return `f(m[s₁], m[s₂], 
  ...)`; if not --- return `nothing`. If `==` is also added in the function 
  call, the test will be positive only when `m` contains all and only the 
  prescribed symbols. If `!` is added in the function call, the test will be 
  positive only when `m` contains no any of the prescribed symbols; if that is 
  true, `f` is called with no arguments. Similarly for `|` -- if test is true,
  `f` is called with no arguments.

See also: [`ArgumentModes.Mode`](@ref)

# Examples
```julia-repl
julia> m = Mode(:a => 1, :b => 2.5, :c)
Mode[==, :b => Float64, :a => Int64, :c]((a = 1, b = 2.5, c = nothing))

julia> checkmode(m, :a)
true

julia> checkmode(m, :d)
false

julia> checkmode(m, |, :a, :d)
true

julia> checkmode(m, &, :a, :d)
false

julia> checkmode(m, ==, :a, :b)
false

julia> checkmode(m, ==, :a, :b, :c)
true

julia> checkmode(m, :a) do a;  @show a   end
a = 1
1

julia> checkmode(m, :a, :b) do a, b;  @show a, b   end
(a, b) = (1, 2.5)
(1, 2.5)

julia> checkmode(m, :a, :e) do x, y;  @show x, y   end

julia> checkmode(12, :a)
false
```
"""
function checkmode end
@inline checkmode(m, s::Symbol) = m isa Mode && s in keys(m.values)
@inline checkmode(m, ::typeof(&), s::Symbol...) = m isa Mode && 
  foldl(&, s .∈ (keys(m.values),))
@inline checkmode(m, s::Symbol, s1::Symbol...) = checkmode(m, &, s, s1...)
@inline checkmode(m, ::typeof(|), s::Symbol...) = m isa Mode && 
  foldl(|, s .∈ (keys(m.values),))
@inline checkmode(m, ::typeof(==), s::Symbol...) = m isa Mode && 
  foldl(&, s .∈ (keys(m.values),)) && foldl(&, keys(m.values) .∈ (s,))
@inline checkmode(m, ::typeof(!), s::Symbol...) = m isa Mode && 
  !foldl(|, s .∈ (keys(m.values),))
@inline function checkmode(f, m, s::Symbol)
  if checkmode(m, s)
    return f(m.values[s])
  else
    return nothing
  end
end
@inline function checkmode(f, m, ::typeof(&), s::Symbol, ss::Symbol...)
  if checkmode(m, &, s, ss...)
    return f(m.values[s], getindex.((m.values,), ss)...)
  else
    return nothing
  end
end
@inline checkmode(f, m, s::Symbol, ss::Symbol...) = 
  checkmode(f, m, &, s, ss...)
@inline function checkmode(f, m, ::typeof(==), s::Symbol, ss::Symbol...)
  if checkmode(m, ==, s, ss...)
    return f(m.values[s], getindex.((m.values,), ss)...)
  else
    return nothing
  end
end
@inline function checkmode(f, m, ::typeof(!), s::Symbol, ss::Symbol...)
  if checkmode(m, !, s, ss...)
    return f()
  else
    return nothing
  end
end
@inline function checkmode(f, m, ::typeof(|), s::Symbol, ss::Symbol...)
  if checkmode(m, |, s, ss...)
    return f()
  else
    return nothing
  end
end

end # module