Ruby Next AST format additions
=======================

### Pattern matching non-local variables

Format:

~~~
(in_pattern
  (match_as
    (int 1),
    (match_var (ivar :@a))))

"in 1 => @a then true"
~~~

~~~
(in_pattern
  (match_as
    (int 1),
    (match_var (gvar :$a))))

"in 1 => $a then true"
~~~
