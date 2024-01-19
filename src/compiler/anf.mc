include "mexpr/anf.mc"

include "ast.mc"

lang OCamlOpaqueANF = ANF + OpaqueOCamlAst
  sem normalize (k : Expr -> Expr) =
  | TmOpaqueOCaml t -> k (TmOpaqueOCaml t)
end

lang OCamlListANFAll = ANF + OCamlListAst + FunTypeAst + UnknownTypeAst + LamAst + AppAst
  -- NOTE(Linnea, 2024-01-16): We cannot lift out (::), as it is a constructur
  -- that must be fully applied. This version lifts out the two arguments to
  -- (::), but keeps the application fully applied.
  sem normalize (k : Expr -> Expr) =
  | TmApp ({lhs = TmApp {lhs = TmConst {val = COCons ()}}, rhs = rhs } & t) ->
    normalizeNames k (TmApp t)

  sem normalizeNames (k : Expr -> Expr) =
  | TmApp ({lhs = TmConst {val = COCons ()}} & t) ->
    normalizeName (lam r. k (TmApp {t with rhs = r})) t.rhs
  | TmApp t ->
    normalizeNames
      (lam l. normalizeName (lam r. k (TmApp {t with lhs = l, rhs = r})) t.rhs)
      t.lhs
  | t -> normalizeName k t
end

lang OCamlExtrasANF = OCamlOpaqueANF
end

lang OCamlExtrasANFAll = OCamlOpaqueANF + OCamlListANFAll
end
