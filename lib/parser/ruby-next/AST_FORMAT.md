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
"def foo() = 42"
 ~~~ keyword
     ~~~ name
           ^ assignment
 ~~~~~~~~~~~~~~ expression
~~~


### "Endless" singleton method

Format:

~~~
(defs_e (self) :foo (args) (int 42))
"def self.foo() = 42"
 ~~~ keyword
          ~~~ name
                ^ assignment
 ~~~~~~~~~~~~~~~~~~~ expression
~~~


### Right-hand assignment

Format:

~~~
(rasgn (int 1) (lvasgn :a))
"1 => a"
 ~~~~~~ expression
   ~~ operator
~~~

#### Multiple right-hand assignment

Format:

~~~
(mrasgn (send (int 13) :divmod (int 5)) (mlhs (lvasgn :a) (lvasgn :b)))
"13.divmod(5) => a,b"
 ~~~~~~~~~~~~~~~~~~~ expression
              ^^ operator},
~~~
