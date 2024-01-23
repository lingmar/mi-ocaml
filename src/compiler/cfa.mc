include "mexpr/cfa.mc"

include "ast.mc"

lang OCamlStringCFA = ConstCFA + OCamlStringAst
  sem generateConstraintsConst graph info ident =
  | COString _ -> graph
end

lang OCamlOpaqueCFA = CFA + OpaqueOCamlAst
  sem generateConstraints graph =
  | TmLet { ident = ident, body = TmOpaqueOCaml _, info = info } -> graph

end

lang OCamlListCFA = ConstCFA + OCamlListAst + NestedMeasuringPoints
  sem generateConstraintsConst graph info ident =
  | CONil _ -> graph
  | COCons _ -> graph

  sem generateConstraints graph =
  | TmLet {body = TmApp {lhs = TmApp {lhs = TmConst {val = COCons ()}}}, ident = ident, info = info} ->
    graph

  sem generateHoleConstraints (graph: CFAGraphInit) =
  | TmLet {body = TmApp {lhs = TmApp {lhs = TmConst {val = COCons ()}}}, ident = ident, info = info} ->
    graph

  sem callGraphEdges im data avLams cur acc =
  | TmApp {lhs = TmApp {lhs = TmConst {val = COCons ()}}} ->
    acc

  sem augmentDependenciesH id im env enc ms mset data eholes g acc =
  | TmLet {body = TmApp {lhs = TmApp {lhs = TmConst {val = COCons ()}}}} -> acc
end

lang OCamlExtrasCFA = OCamlStringCFA + OCamlOpaqueCFA + OCamlListCFA
end
