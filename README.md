# ArgumentModes.jl

The package provides type `Mode` which could be seen as an extension of `Val`.
`Mode` is intended to be used as a type for a function method argument. A 
specialization of `Mode` type contains a list of accepted symbols (flags). The 
dispatch would choose the method only if the argument value (a `Mode` instance) 
containes only symbols from the list of accepted symbols as declared in the type
of the argument.

Presumed uses of `Mode`:
1) Replacement of using ordinary `Symbol` as a function argument as a flag 
   parameter. Here `Mode` allows to explicitly declare a function argument as a 
   set of symbols (flags) with a distinct list of accepted symbols for each of 
   a function's methods. The dispatch process then chooses a method with 
   respect to those lists. That way it also indirectly performs the typo 
   control. For example, `open(f, Mode(:read))`, `open(f, Mode(:write))`, 
   `open(f, Mode(:write, :sync))` might correspond (depending on the design)
   to 3 different methods.

2) The way to explicitly show in which meaning a value to a function argument 
   is provided. This might be useful when it is not possible to distinct the 
   meaning of an argument only by the type. 

   For example, suppose a function **f** processes array-typed objects with 
   arbitrary dimensions number. We might want to declare methods for both 
   processing a single object and an iteratable collection of objects. It 
   would be difficult to distinct the methods using only the type of the 
   argument since `f([x,y])` could both mean to process a single object `[x,y]` 
   or to process two objects `x` and `y`. However, using `Mode` in the 
   declaration of method for a collection, the user would be allowed to 
   explicitly indicate what is passed in the call: `f([x,y])` for a single 
   object and `f(Mode(:collection)=> [x, y])` for a collection of objects.
   
# Example

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
[3] f(x::Union{Int64, Mode[:c => Int64, :a, :b]) in Main at REPL[38]:1
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
# Detailed description of mechanics

Here is a more detailed description of the mechanics of the type. A specialized 
`Mode` type **M=Mode{[s₁⇒t₁, s₂⇒t₂, ...]}** is determined by a collection of 
symbols **s₁**, **s₂**, ...  of type `Symbol` and corresponding types **t₁**, 
**t₂**, ... (of type `DataType` or `Union` of `DataType`s). An instance 
**m::Mode** of `Mode` additionally contains values **vᵢ** for each **sᵢ** of 
type **tᵢ**. Let **param(x)** denote the collection **{sᵢ=>tᵢ}ᵢ** of **x** 
(here **x** is an instance or a specialized type of `Mode`). Then **m** is of 
type **M** only if **param(m) ⊆ param(M)**. This allows the dispatch to choose 
an appropriate method of a function based on **param(m)**.

# Constructor of the type specialization

    Mode[ s₁ [=> t₁] [, s₂ [=> t₂]]... ]

Construct a specialization **M=Mode{[s₁⇒t₁, s₂⇒t₂, ...]}** to be used as a 
type for a argument in a function method declaration. The argument with type 
**M** would accept only instances **m::Mode** with **param(m) ⊆ param(M)**. 
Some or all **tᵢ** may absent in the type declaration which defaults to 
`Nothing`. An example: `Mode[:a, :b => Int, :c => Tuple{Int, String}]`.

Symbol `==` could also be added as the first argument in a constructor call to 
indicate that the concrete type is wanted (not an `UnionAll` as above). This
option is added only for auxiliary purposes and generally should not be useful.

Note that such nonconventional syntax with brackets `[`,`]` is used to make the 
code for a type declaration look similar to the presentation of the type name 
in a function signature.

# Constructors of an instance

    Mode( s₁[=> v₁] [, s₂ [=> v₂]]... )

Construct an instance **m::Mode{[s₁⇒typeof(v₁), s₂⇒typeof(v₂), ...]}** with
values **v₁, v₂, ...**. Some or all of **vᵢ** might be omited which defaults to 
`nothing`. An example: `Mode(:a => 25, :b, :c => "Hello world!")`.

    Mode(s)

Construct an instance **m::Mode{[s⇒Nothing]}** with `nothing` value. The 
type and value could be set by a subsequent call **m**`=>`**v**. Several 
instances could be joined with `~` operator. For example, 
`Mode(:a)=> 25 ~ Mode(:b) ~ Mode(:c)=> "Hello world!"` is equivalent to 
`Mode(:a => 25, :b, :c => "Hello world!")`.

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
  symbols, and, possibly, do an action.
  
### checkmode

    checkmode(m, s::Symbol)
    checkmode(m, [&, |, ==, or !], s₁::Symbol[, s₂:Symbol]...)
    checkmode(f, m, [&, |, ==, or !], s₁::Symbol[, s₂:Symbol]...)

Tests if `m` is a `Mode` and contains the prescribed symbols.

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

# Performance

Series of tests showed that the current implementation of `Mode` fully compiles
out when it used for function arguments and method dispatch, so it seems that
there is no runtime overhead for using it (at least for the use cases 
considered in the tests). 

Tests on compile-time overhead showed that (for Julia 1.6) it is like 0.2-0.5s 
for the first call of `Mode[...]` and `Mode(...)`, and something like
5-20ms for further uses (when a call signature is sufficiently changes). 
Unfortunatelly, I have not found so far the way to further reduce the latency.
