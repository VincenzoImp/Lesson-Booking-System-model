block Studenti

    parameter Real T = 1.0; //1 minuto
    parameter Integer localSeed = 617292;
    parameter Integer globalSeed = 30020;
    parameter Real distribuzione_prenotazioni[4] = {0.10, 0.75, 0.10, 0.05}; //rispettivamente -1, 0, +1, +2 prenotazioni al minuto di media
    Real r1024;
    Integer state1024[Modelica.Math.Random.Generators.Xorshift1024star.nState];

    Output_Integer nuove_prenotazioni;

    algorithm
        when initial() then
            r1024 := 0.0;
            state1024 := Modelica.Math.Random.Generators.Xorshift1024star.initialState(localSeed, globalSeed);
            nuove_prenotazioni := 0;
        end when;
        when sample(0, T) then
            (r1024, state1024) := Modelica.Math.Random.Generators.Xorshift1024star.random(pre(state1024));
            nuove_prenotazioni := pick_array(r1024, distribuzione_prenotazioni) - 2;
        end when;

end Studenti;
