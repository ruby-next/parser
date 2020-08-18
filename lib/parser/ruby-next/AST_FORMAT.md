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
