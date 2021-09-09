block Aula

    parameter Real T = 1.0*60*4; //ogni quattro ore l'aula puó cambiare stato
    parameter Integer localSeed = 614657;
    parameter Integer globalSeed = 30020;
    parameter Real MC_stato[3,3] = {{0.60, 0.30, 0.10},//agibile
                                    {0.33, 0.34, 0.33},//parzialmente agibile
                                    {0.10, 0.30, 0.60}};//inagibile
    parameter Integer info_capienza[3] = {100, 50, 0}; //agibile, parzialmente agibile, inagibile
    parameter Integer stato_iniziale = 1; //1 agibile, 2 parzialmente inagibile, 3 inagibile

    Real r1024;
    Integer state1024[Modelica.Math.Random.Generators.Xorshift1024star.nState];

    Output_Integer stato;
    Output_Integer capienza;

    algorithm
        when initial() then
            r1024 := 0.0;
            state1024 := Modelica.Math.Random.Generators.Xorshift1024star.initialState(localSeed, globalSeed);
            stato := stato_iniziale;
            capienza := info_capienza[stato];
        end when;
        when sample(0, T) then
            (r1024, state1024) := Modelica.Math.Random.Generators.Xorshift1024star.random(pre(state1024));
            stato := pick_matrix(r1024, pre(stato), MC_stato);
            capienza := info_capienza[stato];
        end when;

end Aula;
