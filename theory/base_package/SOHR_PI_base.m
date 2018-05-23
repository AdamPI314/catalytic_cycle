PIGetExponentialBase[l_] := Table[E^((-Symbol[StringJoin["k", ToString[i]]])*
       t), {i, 1, l}]
 
i = 1
 
PIGetPathIntegral[N_] := Module[{output, tlist, klist}, 
     tlist = Table[Symbol[StringJoin["t", IntegerString[i]]], {i, 1, N}]; 
      klist = Table[Symbol[StringJoin["k", IntegerString[i]]], 
        {i, 1, N + 1}]; output = Product[With[{}, 
         Evaluate[klist[[i]]/E^(klist[[i]]*tlist[[i]])]], {i, 1, N}]; 
      output *= E^((-klist[[-1]])*(t - Sum[tlist[[i]], {i, 1, N}])); 
      For[i = N, i > 1, i--, output = Integrate[output, 
         {tlist[[i]], 0, t - Sum[tlist[[j]], {j, 1, i - 1}]}]]; 
      If[N == 0, output = E^((-klist[[1]])*t), 
       output = Integrate[output, {t1, 0, t}]]; output = Expand[output]; 
      output = output /. {Exp[x_] :> Exp[Together[FullSimplify[x]]]}; 
      Return[output]; ]
 
PIGetHMatrix[pathProb_] := Module[{l, ExponentialVector, CoeffMatrix}, 
     l = Length[pathProb]; ExponentialVector = PIGetExponentialBase[l]; 
      CoeffMatrix = Table[Table[Simplify[Coefficient[pathProb[[i]], 
           ExponentialVector[[j]], 1]], {j, 1, l}], {i, 1, l}]; 
      Return[CoeffMatrix]; ]
 
PIGetPathwayProbabilityVector[l_] := Module[{output}, 
     output = Table[PIGetPathIntegral[i], {i, 0, l}]; Return[output]; ]
 
PIToSubScriptExpression[P_, i_] := Module[{output}, 
     output = P /. {Symbol[StringJoin["k", ToString[i]]] -> 
          Subscript["k", ToString[i]]}; Return[output]; ]
 
Attributes[Subscript] = {NHoldRest}
