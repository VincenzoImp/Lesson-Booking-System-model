block Prodigit

    parameter Real T = 1.0*60;

    Input_Integer stato;
    Input_Integer capienza;
    Input_Integer posti_prenotati;
    Output_Integer stato_aula_letto;
    Output_Integer capienza_aula_letta;
    Output_Integer posti_prenotati_letti;

    algorithm
        when initial() then
            stato_aula_letto := 0;
            capienza_aula_letta := 0;
            posti_prenotati_letti := 0;
        end when;
        when sample(0, T) then
            stato_aula_letto := stato;
            capienza_aula_letta := capienza;
            posti_prenotati_letti := posti_prenotati;
        end when;

end Prodigit;
