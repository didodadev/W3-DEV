component
    {
    public any function GetSignFlow(
        required string dokumanbase64,
        required string tur,
        required string talimatnumarasi,
        required date tarih,
        required numeric toplamtutar,
        required string parabirimi,
        required string nereyegonderilecek,
        required string talimatdetaylari,
        required array onaycilar
        
        ){       
            jsonReq='[
                        {
                            "dokumanbase64":"#arguments.dokumanbase64#",
                            "tur":"#arguments.tur#",
                            "talimatnumarasi":"#arguments.talimatnumarasi#",
                            "tarih":"#dateFormat(arguments.tarih,"dd.mm.YYYY")#",
                            "toplamtutar":"#arguments.toplamtutar#",
                            "parabirimi":"#arguments.parabirimi#",
                            "nereyegonderilecek": "#arguments.nereyegonderilecek#",
                            "talimatdetaylari": "#arguments.talimatdetaylari#",
                            "onaycilar": [';
                
            for(i=1;i<=arrayLen(onaycilar);i++)
            {
                jsonReq=jsonReq.concat(
                    '
                        {
                            "adi": "#arguments.onaycilar[i].adi#",
                            "soyadi": "#arguments.onaycilar[i].soyadi#",
                            "telefon": "#arguments.onaycilar[i].telefon#",
                            "eposta": "#arguments.onaycilar[i].eposta#",
                            "onaysirano": "#arguments.onaycilar[i].onaysirano#",');
                            if(arguments.onaycilar[i].serino=="")
                            {
                                jsonReq=jsonReq.concat('"serino": null,');
                            }
                            else 
                            {
                                jsonReq=jsonReq.concat('"serino": "#arguments.onaycilar[i].serino#",');
                            }
                            if(arguments.onaycilar[i].operator=="")
                            {
                                jsonReq=jsonReq.concat('"operator": null,');
                            }
                            else 
                            {
                                jsonReq=jsonReq.concat('"operator":"#arguments.onaycilar[i].operator#",');
                            }
                            jsonReq=jsonReq.concat(
                           '"ismobile": #arguments.onaycilar[i].ismobile#,
                            "imzabilgimetni":"#arguments.onaycilar[i].imzabilgimetni#"
                        },');
            
            }
            jsonReq=jsonReq.Substring(0, jsonReq.Length() - 1);
            jsonReq=jsonReq.concat(']}]');

        cfhttp (url="",method="POST",username="",password="",timeout="20",result="return_signflow")
        {
            cfhttpparam(name="Content-Type",value="application/json",type="header");
            cfhttpparam(value="#jsonReq#",type="body");
        }

        return return_signflow;
    }

    public any function GetVerificationDate(
        required string talimatnumarasi
        ){
        
        jsonReq='[
                    {
                    "talimatNumarasi": "#arguments.talimatnumarasi#"
                    }
                 ]';


        cfhttp (url="",method="POST",username="",password="",timeout="20",result="verification_date")
        {
            cfhttpparam(name="Content-Type",value="application/json",type="header");
            cfhttpparam(value="#jsonReq#",type="body");
        }

        return verification_date;
    }

    public any function GetHistory(
        required string talimatnumarasi,
        required string dokumanDatasiOlsunMu,
        required string sadeceAktifOlanKayit
        ){
        
            jsonReq='[
                        {
                        "talimatNumarasi": "#arguments.talimatnumarasi#",
                        "dokumanDatasiOlsunMu": #arguments.dokumanDatasiOlsunMu#,
                        "sadeceAktifOlanKayit": #arguments.sadeceAktifOlanKayit#
                        }
                    ]';


        cfhttp (url="",method="POST",username="",password="",timeout="20",result="history")
        {
            cfhttpparam(name="Content-Type",value="application/json",type="header");
            cfhttpparam(value="#jsonReq#",type="body");
        }

        return history;
    }

}