<!-- Description : Kapanış Fişi Açıklamaları Düzenlendi
Developer: Pınar Yıldız
Company : Workcube
Destination: Main-->
<querytag>
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Üye Kodu,B/A,Sistem Para Birimi Karşılık Tutarı (float), Sistem İkinci Döviz Birimi,Sistem İkinci Döviz Tutarı(float), İşlem Döviz Tutarı (float), İşlem Döviz Birimi, Ödeme Tarihi(dd/mm/yyyy),Proje ID si,Şube ID si,Belge Tarihi,Cari Hesap Tipi(Sadece Çalışanlar İçin)" şeklinde olmalıdır', ITEM_TR='Üye Kodu,B/A,Sistem Para Birimi Karşılık Tutarı (float), Sistem İkinci Döviz Birimi,Sistem İkinci Döviz Tutarı(float), İşlem Döviz Tutarı (float), İşlem Döviz Birimi, Ödeme Tarihi(dd/mm/yyyy),Proje ID si,Şube ID si,Belge Tarihi,Cari Hesap Tipi(Sadece Çalışanlar İçin)" şeklinde olmalıdır' WHERE DICTIONARY_ID = 44884    
    UPDATE SETUP_LANGUAGE_TR SET 
        ITEM='45654,B,1000,USD,500,1000,TL,28/02/2019,8,1,20/02/2019,-3--------------------TL islem dövizi bakiye için', 
        ITEM_TR='45654,B,1000,USD,500,1000,TL,28/02/2019,8,1,20/02/2019,-3--------------------TL islem dövizi bakiye için', 
        ITEM_ENG='45654,B,1000,USD,500,1000,TL,28/02/2019,8,1,20/02/2019,-3--------------------TL for transaction foreign currency balance',
        ITEM_DE='45654,B,1000,USD,500,1000,TL,28/02/2019,8,1,20/02/2019,-3--------------------TL für Transaktions-Fremdwährungssaldo' 
    WHERE DICTIONARY_ID = 44888
    UPDATE 
    	SETUP_LANGUAGE_TR SET 
        	ITEM='B12255,B,1400.32,USD,500,1000,USD,28/02/2019,8,1,20/02/2019,-3-----------------USD islem dövizi bakiye için', 
        	ITEM_TR='B12255,B,1400.32,USD,500,1000,USD,28/02/2019,8,1,20/02/2019,-3-----------------USD islem dövizi bakiye için', 
            ITEM_ENG='B12255,B,1400.32,USD,500,1000,USD,28/02/2019,8,1,20/02/2019,-3-----------------USD for transaction foreign currency balance', 
            ITEM_DE='B12255,B,1400.32,USD,500,1000,USD,28/02/2019,8,1,20/02/2019,-3-----------------USD für den Fremdwährungssaldo der Transaktion'
    WHERE DICTIONARY_ID = 44889
    UPDATE 
    	SETUP_LANGUAGE_TR SET 
        	ITEM='B12255,B,1400.32,USD,500,1000,USD,28/02/2019,8,1,20/02/2019,-3------------------Euro islem dövizi bakiye için', 
        	ITEM_TR='B12255,B,1400.32,USD,500,1000,USD,28/02/2019,8,1,20/02/2019,-3-----------------Euro islem dövizi bakiye için', 
            ITEM_ENG='B12255,B,1400.32,USD,500,1000,USD,28/02/2019,8,1,20/02/2019,-3-----------------Euro for transaction foreign currency balance', 
            ITEM_DE='B12255,B,1400.32,USD,500,1000,USD,28/02/2019,8,1,20/02/2019,-3-----------------Euro für den Fremdwährungssaldo der Transaktion'
    WHERE DICTIONARY_ID = 44890
</querytag>