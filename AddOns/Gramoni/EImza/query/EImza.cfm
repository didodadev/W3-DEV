<cfscript>
    
         include "../cfc/EImza.cfc";
         <!--- --->
         signflow = GetSignFlow(
             dokumanbase64 :"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
             tur : "Banka deneme",
             talimatnumarasi: "19122019.TRY..2",
             tarih: "19.12.2019",
             toplamtutar: "15000.00",
             parabirimi:"TRY",
             nereyegonderilecek: "GLORY BANK",
             talimatdetaylari: "19122019.TRY..2.pdf",
             onaycilar : [
                 {
                     adi: "Cagla",
                     soyadi: "Kara",
                     telefon: "05436249739",
                     eposta: "cagla.kara@gramoni.com",
                     onaysirano: "1",
                     serino: "05436249739",
                     operator:"",
                     ismobile: false,
                     imzabilgimetni:"Cagla"
                 },
                 {
                     adi: "Mahmut",
                     soyadi: "Cifci",
                     telefon: "05514159082",
                     eposta: "mahmut.cifci@gramoni.com",
                     onaysirano: "2",
                     serino: "",
                     operator:"TURKCELL" ,
                     ismobile: false,
                     imzabilgimetni:"Mahmut"
                 }
             ]
         );
         responseData = deserializeJSON(signflow.fileContent);
     
         verification_date=GetVerificationDate(talimatnumarasi: "19122019.TRY..2");
         responseData = deserializeJSON(verification_date.fileContent);
     
         history=GetHistory(talimatnumarasi: "19122019.TRY..2",dokumanDatasiOlsunMu:false,sadeceAktifOlanKayit:true);
         responseData = deserializeJSON(history.fileContent);
     
 </cfscript>