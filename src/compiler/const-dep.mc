include "tuning/const-dep.mc"

include "ast.mc"

lang OCamlStringDep = ConstDep + OCamlStringAst
  sem constDep =
  | COString _ -> []
end

lang OCamlListDep = ConstDep + OCamlListAst
  sem constDep =
  | CONil _ -> []
  | COCons _ -> [_constDepData, _constDepData]
end

lang OCamlExtrasConstDep = OCamlStringDep + OCamlListDep
end
