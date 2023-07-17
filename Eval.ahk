;=======================================================================
; Library - Eval
;=======================================================================
Eval(Expr, Format := FALSE)
{
    static obj := ""    ; par cuestiones de rendimiento
    if ( !obj )
        obj := ComObjCreate("HTMLfile")

    Expr := StrReplace( RegExReplace(Expr, "\s") , ",", ".")
  , Expr := RegExReplace(StrReplace(Expr, "**", "^"), "(\w+(\.*\d+)?)\^(\w+(\.*\d+)?)", "pow($1,$3)")    ; 2**3 -> 2^3 -> pow(2,3)
  , Expr := RegExReplace(Expr, "=+", "==")    ; = -> ==  |  === -> ==  |  ==== -> ==  |  ..
  , Expr := RegExReplace(Expr, "\b(E|LN2|LN10|LOG2E|LOG10E|PI|SQRT1_2|SQRT2)\b", "Math.$1")
  , Expr := RegExReplace(Expr, "\b(abs|acos|asin|atan|atan2|ceil|cos|exp|floor|log|max|min|pow|random|round|sin|sqrt|tan)\b\(", "Math.$1(")

  , obj.write("<body><script>document.body.innerText=eval('" . Expr . "');</script>")
  , Expr := obj.body.innerText

    return InStr(Expr, "d") ? "" : InStr(Expr, "false") ? FALSE    ; d = body | undefined
                                 : InStr(Expr, "true")  ? TRUE
                                 : ( Format && InStr(Expr, "e") ? Format("{:f}",Expr) : Expr )
}
