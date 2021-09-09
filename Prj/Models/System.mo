block System
    //l'unitá di tempo piú piccola é 1.0 che equivale a un minuto
    Aula a;
    Studenti s;
    Prenotazioni p;
    GOMP G;
    Prodigit prod;
    Monitor_RF m_rf;
    Monitor_RNF m_rnf;

    equation
        //Input Prenotazioni
        connect(s.nuove_prenotazioni, p.nuove_prenotazioni);
        connect(a.capienza, p.capienza);

        //Input GOMP
        connect(a.stato, G.stato_ricevuto);
        connect(a.capienza, G.capienza_ricevuto);
        connect(p.posti_prenotati, G.posti_prenotati_ricevuto);

        //Input Monitor_RF
        connect(a.capienza, m_rf.capienza);
        connect(p.posti_prenotati, m_rf.posti_prenotati);
        connect(p.old_posti_prenotati, m_rf.old_posti_prenotati);
        connect(s.nuove_prenotazioni, m_rf.nuove_prenotazioni);

        //Input Prodigit
        connect(G.stato_ricevuto, prod.stato);
        connect(G.capienza_ricevuto, prod.capienza);
        connect(G.posti_prenotati_ricevuto, prod.posti_prenotati);

        //Input Monitor_RNF
        connect(a.stato, m_rnf.stato_esatto);
        connect(a.capienza, m_rnf.capienza_esatta);
        connect(p.posti_prenotati, m_rnf.posti_prenotati_esatti);
        connect(prod.stato_aula_letto, m_rnf.stato_percepito);
        connect(prod.capienza_aula_letta, m_rnf.capienza_percepita);
        connect(prod.posti_prenotati_letti, m_rnf.posti_prenotati_percepiti);

end System;
