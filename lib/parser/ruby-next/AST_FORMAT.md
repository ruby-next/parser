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
