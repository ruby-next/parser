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

### "Endless" method

Format:

~~~
(def_e :foo (args) (int 42))
"def foo = 42"
 ~~~ keyword
     ~~~ name
         ^ assignment
 ~~~~~~~~~~~~ expression
~~~


### "Endless" singleton method

Format:

~~~
(defs_e (self) :foo (args) (int 42))
"def self.foo = 42"
 ~~~ keyword
          ~~~ name
              ^ assignment
 ~~~~~~~~~~~~~~~~~ expression
~~~
