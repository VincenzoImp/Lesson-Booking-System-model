block Monitor_RF

    parameter Real T = 1.0;
    
    Input_Integer capienza;
    Input_Integer posti_prenotati;
    Input_Integer old_posti_prenotati;
    Input_Integer nuove_prenotazioni;

    Integer safety_signal;
    Integer liveness_signal;

    algorithm
        when initial() then
            safety_signal := 0;
            liveness_signal := 0;
        end when;
        when sample(0, T) then
            if posti_prenotati < 0 or posti_prenotati > capienza then
                safety_signal := 1;
            else
                safety_signal := pre(safety_signal);
            end if;
            if capienza > 0 and nuove_prenotazioni > 0 and posti_prenotati-old_posti_prenotati <> nuove_prenotazioni then
                liveness_signal := 1;
            else
                liveness_signal := pre(liveness_signal);
            end if;
        end when;
        
end Monitor_RF;
