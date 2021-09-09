block Prenotazioni

    parameter Real T = 1.0;
    parameter Integer reset_posti_prenotati = 1*60*24; //ogni colpo di clock equivale ad un minuto, quindi dopo 1*60*24 termina un giorno, quindi si tiene la lezione, le prenotazioni scadono e quindi ci sono tutti i posti liberi in un primo momento

    Input_Integer capienza;
    Input_Integer nuove_prenotazioni;
    Output_Integer posti_prenotati;
    Output_Integer old_posti_prenotati;

    algorithm
        when initial() then
            posti_prenotati := 0;
        end when;
        when sample(0, T) then
            old_posti_prenotati := pre(posti_prenotati);
            if pre(posti_prenotati)+nuove_prenotazioni > capienza then
                posti_prenotati := capienza;
            elseif pre(posti_prenotati)+nuove_prenotazioni < 0 then
                posti_prenotati := 0;
            else
                posti_prenotati := pre(posti_prenotati)+nuove_prenotazioni;
            end if;
        end when;
        when sample(0, reset_posti_prenotati) then
            posti_prenotati := 0;
        end when;
end Prenotazioni;
