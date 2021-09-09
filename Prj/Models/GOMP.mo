block GOMP

    parameter Real T = 1.0;
    parameter Integer localSeed = 352657;
    parameter Integer globalSeed = 30020;
    parameter Real MC_funzionamento[2,2] = {{0.98, 0.02},  //funzionante
                                            {0.04, 0.96}}; //down
    parameter Integer stato_iniziale_G = 1; //funzionante

    Real r1024;
    Integer state1024[Modelica.Math.Random.Generators.Xorshift1024star.nState];
    Integer stato_G;

    Input_Integer stato_ricevuto;
    Input_Integer capienza_ricevuto;
    Input_Integer posti_prenotati_ricevuto;
    Output_Integer stato_inviato;
    Output_Integer capienza_inviato;
    Output_Integer posti_prenotati_inviato;

    algorithm
        when initial() then
            r1024 := 0.0;
            state1024 := Modelica.Math.Random.Generators.Xorshift1024star.initialState(localSeed, globalSeed);
            stato_G := stato_iniziale_G;
            stato_inviato := 0;
            capienza_inviato := 0;
            posti_prenotati_inviato := 0;
        end when;
        when sample(0, T) then
            (r1024, state1024) := Modelica.Math.Random.Generators.Xorshift1024star.random(pre(state1024));
            stato_G := pick_matrix(r1024, pre(stato_G), MC_funzionamento);
            if stato_G == 1 then
                stato_inviato := stato_ricevuto;
                capienza_inviato := capienza_ricevuto;
                posti_prenotati_inviato := posti_prenotati_ricevuto;
            else //stato_G == 2
                stato_inviato := pre(stato_inviato);
                capienza_inviato := pre(capienza_inviato);
                posti_prenotati_inviato := pre(posti_prenotati_inviato);
            end if;
        end when;

end GOMP;
