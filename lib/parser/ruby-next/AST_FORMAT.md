Ruby Next AST format additions
=======================

### Method reference operator

Format:

~~~
(meth-ref (self) :foo)
"self.:foo"
     ^^ dot
       ^^^ selector
 ^^^^^^^^^ expression
~~~

### Hash

#### Implicit pair

Format:

~~~
(hash (ipair (send nil :x)))
"{x}"
 ^ begin^ end
  ~~~~~~ expression (send)
  ~~~~~~ expression (spair)
 ~~~~~~~~ expression (hash)
~~~

~~~
(hash (ipair (lvar :foo)))
"{foo}"
 ^ begin^ end
  ~~~~~~ expression (send)
  ~~~~~~ expression (spair)
 ~~~~~~~~ expression (hash)
~~~

### Kwargs

#### Implicit kwarg

Format:

~~~
(hash (ipair (send nil :x)))
"foo x:"
     ~~ expression
~~~

~~~
(hash (ipair (lvar :foo)))
"foo(foo:)"
     ~~~~ expression
~~~

If `emit_kwargs` compatibility flag is enabled:

~~~
(kwargs (ipair (send nil :x)))
"foo x:"
     ~~ expression
~~~
