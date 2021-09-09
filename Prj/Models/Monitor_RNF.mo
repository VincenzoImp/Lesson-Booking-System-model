block Monitor_RNF

    parameter Real T = 1.0;

    Input_Integer stato_esatto;
    Input_Integer capienza_esatta;
    Input_Integer posti_prenotati_esatti;
    Input_Integer stato_percepito;
    Input_Integer capienza_percepita;
    Input_Integer posti_prenotati_percepiti;

    Integer stato_differente;
    Integer capienza_differente;
    Integer posti_prenotati_differenti;
    Integer delta_error_prenotazioni;
    Integer max_delta_error_prenotazioni;

    algorithm
        when initial() then
            stato_differente := 0;
            capienza_differente := 0;
            posti_prenotati_differenti := 0;
            delta_error_prenotazioni := 0;
            max_delta_error_prenotazioni := 0;
        end when;
        when sample(0, T) then
            if(stato_esatto <> stato_percepito) then
                stato_differente := 1;
            end if;
            if(capienza_esatta <> capienza_percepita) then
                capienza_differente := 1;
            end if;
            if(posti_prenotati_esatti <> posti_prenotati_percepiti) then
                posti_prenotati_differenti := 0;
            end if;
            delta_error_prenotazioni := unsigned_integer(posti_prenotati_esatti-posti_prenotati_percepiti);
            max_delta_error_prenotazioni := max(pre(max_delta_error_prenotazioni), delta_error_prenotazioni);
        end when;

end Monitor_RNF;
