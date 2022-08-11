"""
    module ArgumentModes
\n The module provides type `Mode` which could be seen as an extension of `Val`.
`Mode` is indended to be used as a type for a function method argument. A 
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

Series of tests showed that the current implementation of `Mode` fully compiles
out when it used for function arguments and method dispatch, so it seems that
there is no runtime overhead for using it (at least for the use cases 
considered in the tests). 

# Types
- `Mode`: similar to a set of symbols (possibly, with parameters) with ability 
  for dispatch process to choose the function method based on a value of a `Mode` instance.

# Type constructors
- `Mode[ s₁ [=> t₁] [, s₂ [=> t₂]]... ]`: declare a type specialization which
  would accept the symbols `s₁`, `s₂`, …. Intended to be used in a function 
  method declaration as a type of an argument.

# Instance constructors
- `Mode( s₁[=> v₁] [, v₂ [=> v₂]]... )`: create an instance with symbols `s₁`, 
  `s₂`, … and corresponding values `v₁`, `v₂`, … in it. Intended to be used
  in a function call as an argument value.

# Operations on a `Mode` instance
- `m => v` given `m::Mode[s => Nothing]`: return a new instance with single 
  symbol in it.
- `m₁ ~ m₂`: join `m₁` and `m₂`.
- `keys(m), values(m), pairs(m)`: return symbols / values / pairs of symbols 
  and values.
- `m[s₁ [, s₂]... ]`: return the value of `s₁` / the tuple of 
  values of `s₁, s₂, ...`.
- `m[]`: if `m` contains only one value, return it; throw an ArgumentError 
  otherwise.
- `checkmode(m, ...)`: check if `m` is a `Mode` and contains the prescribed  
  symbols, and, possibly, do an action.
"""
module ArgumentModes
  if isdefined(Base, :Experimental) && 
      isdefined(Base.Experimental, Symbol("@optlevel"))
    @eval Base.Experimental.@optlevel 1 # 0 disables inlining in user-code
  end

  include("Impl.jl")
  using .Impl
  # Mode.body.body.name.module = ArgumentModes
  export checkmode
  export Mode

  # doesn't seem to help
  # include("precompile.jl")
end # module