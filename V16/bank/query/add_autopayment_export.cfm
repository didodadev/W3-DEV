<!--- Pronet için otomatik ödeme işlemi belgesi oluşturan sayfasıdır,HSBC,Finansbank,Isbankası,Garanti,Oyakbank,YKB,Akbank,Ziraat,VakıfBank,Sekerbank formatları vardır.
Başka firmalar için istenirse firma bilgileri değiştitirilerek add_options a taşınabilir
Dore firmasi icin add_optionsda calismaktadir. Bk 20101015
Aysenur 20060810 BK20101015
DBS dosya desenleri eklendi 20121204SM
Sayfa performansından kaynaklanan problemler yuzunden query XML e bagli olarak buradada donduruluyor 
satirlari formdan gelenler ve queryden çekilenler olmak üzere iki bloktan olusuyor yukarıda yapılan değisiklikler asagıdada yapilmalidir
08122012FA
--->
<cfsetting showdebugoutput="no">
<cfif attributes.is_process_check eq 0>
	<!--- sistem ödeme planı satirlarini getirir. --->
    <cfif attributes.open_form eq 1 and attributes.source eq 1>
        <cf_date tarih='attributes.start_date'>
        <cf_date tarih='attributes.finish_date'>
        <cfquery name="get_period" datasource="#dsn#">
            SELECT 
                PERIOD_ID,
                PERIOD_YEAR,
                OUR_COMPANY_ID 
            FROM 
                SETUP_PERIOD 
            WHERE 
                OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                <cfif isDefined("attributes.prov_period") and len(attributes.prov_period) and attributes.is_show_related_inv_period eq 1>
                    AND PERIOD_ID = #listlast(attributes.prov_period,';')#
                </cfif>
             ORDER BY 
                PERIOD_YEAR DESC
        </cfquery>
        <cfquery name="GET_PAYMENT_PLAN" datasource="#DSN3#">
            SELECT
                *
            FROM
            (
                <cfloop query="get_period">
                    <cfset new_dsn2 = '#dsn#_#get_period.period_year#_#get_period.our_company_id#'>
                    <cfset period_id = get_period.period_id>
                    SELECT
                        SPR.*,
                        SPR.SUBSCRIPTION_PAYMENT_ROW_ID AS PAYMENT_ROW,
                        SC.SUBSCRIPTION_NO AS SUBS_NO,
                        I.NETTOTAL,
                        I.INVOICE_NUMBER,
                        I.INVOICE_DATE AS INV_DATE,
                        I.DUE_DATE AS DUE_DATE,
                        C.FULLNAME MEMBER_NAME
                    FROM
                        SUBSCRIPTION_PAYMENT_PLAN_ROW SPR,
                        SUBSCRIPTION_CONTRACT SC,
                        #new_dsn2#.INVOICE I,
                        #dsn_alias#.COMPANY C
                    WHERE
                        SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID AND
                        I.INVOICE_ID = SPR.INVOICE_ID AND
                        I.COMPANY_ID = C.COMPANY_ID AND
                        SPR.PAYMENT_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date# AND
                        <cfif len(attributes.pay_method) and not (isdefined("attributes.card_pay_method") and len(attributes.card_pay_method))><!---ödeme yöntemi--->
                            SPR.PAYMETHOD_ID IN (#attributes.pay_method#) AND
                        <cfelseif len(attributes.card_pay_method) and not len(attributes.pay_method)>
                            SPR.CARD_PAYMETHOD_ID IN (#attributes.card_pay_method#) AND
                        <cfelse>
                            (
                                SPR.PAYMETHOD_ID IN (#attributes.pay_method#) OR SPR.CARD_PAYMETHOD_ID IN (#attributes.card_pay_method#)
                            ) AND
                        </cfif>
                        SPR.PERIOD_ID = #period_id# AND
                        SPR.IS_BILLED = 1 AND<!--- faturalandı --->
                        SPR.IS_PAID = 0 AND<!--- ödenmedi --->
                        SPR.IS_COLLECTED_PROVISION = 0 AND<!---toplu provizyon oluşturulmadı olanlar gelecek otomatik ödemede --->
                        SPR.IS_ACTIVE = 1 AND<!--- aktif satırlar --->
                        I.NETTOTAL > 0 AND
                        I.INVOICE_CAT <> 57 AND <!--- verilen proforma faturası (id:57) odeme plani satirlarina dahil edilmez --->
                        I.IS_IPTAL = 0
                        
                    UNION ALL
                    
                    SELECT
                        SPR.*,
                        SPR.SUBSCRIPTION_PAYMENT_ROW_ID AS PAYMENT_ROW,
                        SC.SUBSCRIPTION_NO AS SUBS_NO,
                        I.NETTOTAL,
                        I.INVOICE_NUMBER,
                        I.INVOICE_DATE AS INV_DATE,
                        I.DUE_DATE AS DUE_DATE,
                        C.CONSUMER_NAME + ' ' + C.CONSUMER_SURNAME MEMBER_NAME
                    FROM
                        SUBSCRIPTION_PAYMENT_PLAN_ROW SPR,
                        SUBSCRIPTION_CONTRACT SC,
                        #new_dsn2#.INVOICE I,
                        #dsn_alias#.CONSUMER C
                    WHERE
                        SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID AND
                        I.INVOICE_ID = SPR.INVOICE_ID AND
                        I.CONSUMER_ID = C.CONSUMER_ID AND
                        SPR.PAYMENT_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date# AND
                    <cfif len(attributes.pay_method) and not (isdefined("attributes.card_pay_method") and len(attributes.card_pay_method))><!---ödeme yöntemi--->
                        SPR.PAYMETHOD_ID IN (#attributes.pay_method#) AND
                    <cfelseif len(attributes.card_pay_method) and not len(attributes.pay_method)>
                        SPR.CARD_PAYMETHOD_ID IN (#attributes.card_pay_method#) AND
                    <cfelse>
                        (
                            SPR.PAYMETHOD_ID IN (#attributes.pay_method#) OR
                            SPR.CARD_PAYMETHOD_ID IN (#attributes.card_pay_method#)
                        ) AND
                    </cfif>
                        SPR.PERIOD_ID = #period_id# AND
                        SPR.IS_BILLED = 1 AND<!--- faturalandı --->
                        SPR.IS_PAID = 0 AND<!--- ödenmedi --->
                        SPR.IS_COLLECTED_PROVISION = 0 AND<!--- toplu provizyon oluşturulmadı olanlar gelecek otomatik ödemede--->
                        SPR.IS_ACTIVE = 1 AND<!--- aktif satırlar --->
                        I.NETTOTAL > 0 AND
                        I.INVOICE_CAT <> 57 AND <!--- verilen proforma faturası (id:57) odeme plani satirlarina dahil edilmez --->
                        I.IS_IPTAL = 0
                <cfif get_period.currentrow neq get_period.recordcount>UNION ALL</cfif>
                </cfloop>
            )T1	
            ORDER BY
                INVOICE_ID,
				PERIOD_ID
        </cfquery>
    <!--- fatura ödeme planı satirlarini getirir --->
    <cfelseif attributes.open_form eq 1 and attributes.source eq 2>
        <cf_date tarih='attributes.start_date'>
        <cf_date tarih='attributes.finish_date'>
        <cfquery name="get_payment_plan" datasource="#dsn3#">
            SELECT
                INVOICE_PAYMENT_PLAN_ID,
                INVOICE_ID,
                INVOICE_NUMBER,
                INVOICE_DATE,
                DUE_DATE,
                ACTION_DETAIL,
                (SELECT PAYMETHOD FROM #dsn_alias#.SETUP_PAYMETHOD WHERE PAYMETHOD_ID = PAYMENT_METHOD_ROW) PAYMETHOD,
                OTHER_ACTION_VALUE,
                OTHER_MONEY,
                IS_BANK,
                IS_ACTIVE,
                IS_PAID,
                COMPANY.FULLNAME MEMBER_NAME,
                COMPANY.MEMBER_CODE
            FROM 
                INVOICE_PAYMENT_PLAN
                LEFT JOIN #dsn_alias#.COMPANY ON COMPANY.COMPANY_ID = INVOICE_PAYMENT_PLAN.COMPANY_ID
            WHERE
                IS_PAID = 0 AND
                INVOICE_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
                <cfif len(attributes.pay_method)>
                    AND PAYMENT_METHOD_ROW IN (#attributes.pay_method#)
                </cfif>
                <cfif len(attributes.money_type)>
                    AND OTHER_MONEY = '#attributes.money_type#'
                </cfif>
                <cfif isdefined("attributes.status") and len(attributes.status)>
                    AND IS_ACTIVE = #attributes.status#
                </cfif>
                <cfif len(attributes.document_status) and attributes.document_status neq -1>
                    AND IS_BANK = #attributes.document_status#
                </cfif>
        </cfquery>
        <cfquery name="get_bank_" datasource="#dsn#">
            SELECT BANK_ID,BANK_NAME,BANK_CODE FROM SETUP_BANK_TYPES WHERE BANK_ID = #attributes.bank#
        </cfquery>
    </cfif>
    <cfscript>
        CRLF=chr(13)&chr(10);
        file_content = ArrayNew(1);
        index_array = 1;
        toplam = 0;
        kayit_sayisi = 0;
        
        if(isdefined("attributes.source") and attributes.source eq 2)//fatura ödeme planı seçilmişse dbs formatında dosya oluşacak
        {
            if(len(get_bank_.bank_code) <= 4)
                banka_kodu = repeatString("0",4-len(get_bank_.bank_code)) & "#get_bank_.bank_code#";
            else 
                banka_kodu = "#right(get_bank_.bank_code,4)#";
            header = "H" & dateformat(now(),'yyyymmddhhmmss') & "#banka_kodu#" & "#left(replacelist(get_bank_.bank_name," ",""),10)#";
            file_content[index_array] = "#header#";
            index_array = index_array+1;
			
			for(i=1;i lte GET_PAYMENT_PLAN.recordcount;i=i+1)
            {
				"deger_#i#" = 1;
                try
                {
					satir = "";
					if(get_payment_plan.is_bank[i] eq 1 and get_payment_plan.is_active[i] eq 1) 
						pay_type = "G"; 
					else if(get_payment_plan.is_bank[i] eq 0 and get_payment_plan.is_active[i] eq 1) 
						pay_type = "Y" ;
					else 
						pay_type = "I";
						
					if (get_payment_plan.other_money[i] == 'TL')
						get_payment_plan.other_money[i] = 'TRY';
						
					tutar = wrk_round(get_payment_plan.other_action_value[i]);
					satir = satir & "D" & repeatString(" ",131);
					satir = yerles(satir,replacelist(get_payment_plan.member_code[i],"ş,Ş,ğ,Ğ,ı,İ","s,S,g,G,i,I"),2,20," ");	//müşteri no
					satir = yerles(satir,replacelist(get_payment_plan.member_name[i],"ş,Ş,ğ,Ğ,ı,İ","s,S,g,G,i,I"),22,40," ");	//müşteri unvan/adi
					satir = yerles(satir,get_payment_plan.invoice_number[i],62,16," ");											//fatura no
					satir = yerles(satir,dateformat(get_payment_plan.invoice_date[i],'yyyymmdd'),78,8," ");						//fatura tarihi
					satir = yerles(satir,dateformat(get_payment_plan.due_date[i],'yyyymmdd'),86,8," ");							//vade tarihi
					satir = yerles_saga(satir,NumberFormat(tutar,"00.00"),94,15,"0");											//fatura tutarı
					satir = yerles(satir,get_payment_plan.other_money[i],109,3," ");											//döviz
					satir = yerles(satir,pay_type,112,1," ");																	//satır tipi
					satir = yerles_saga(satir,get_payment_plan.invoice_payment_plan_id[i],113,20,"0");							//satır id
					file_content[index_array] = "#satir#";
					index_array = index_array+1;
					writeoutput('<br/>#index_array-2#. Satır Yazıldı (Satır ID : #get_payment_plan.invoice_payment_plan_id[i]#)');	
                }
                catch(any e)
                {
                    writeoutput('<br/>#i#. Satır Yazılamadı (Satır ID : #get_payment_plan.invoice_payment_plan_id[i]#)');
					"deger_#i#" = 0;	
                }
            }
            index_array = index_array+1;
        }
        else if (attributes.bank_name eq 10)// HSBC Belge Formatı
        {
            header = "H" & dateformat(now(),'yyyymmdd') & "000123";
            file_content[index_array] = "#header#";
            index_array = index_array+1;
            for(i=1;i lte GET_PAYMENT_PLAN.recordcount;i=i+1)
            {
                try
                {
                    if(get_payment_plan.invoice_id[i] eq get_payment_plan.invoice_id[i-1] and get_payment_plan.period_id[i] eq get_payment_plan.period_id[i-1])
						{}
                    else{
                        satir = "";
                        tutar = get_payment_plan.nettotal[i];
                        satir = satir & "D" & repeatString(" ",116);
                        satir = yerles(satir,replacelist(get_payment_plan.subs_no[i],"ş,Ş,ğ,Ğ,ı,İ","s,S,g,G,i,I"),2,10," ");//Sistem no
                        satir = yerles_saga(satir,get_payment_plan.invoice_id[i],12,12," ");//Fatura id
                        satir = yerles_saga(satir,get_payment_plan.payment_row[i],24,12," ");//ödeme planı satır id
                        satir = yerles_saga(satir,NumberFormat(tutar,"00.00"),36,15,"0");//Fatura tutarı
                        satir = yerles(satir,dateformat(get_payment_plan.inv_date[i],'yyyymmdd'),51,8," ");//Fatura tarihi
						
						if(isdefined('attributes.due_date') and len(attributes.due_date))
							satir = yerles(satir,dateformat(attributes.due_date,'yyyymmdd'),59,8," ");//Son Ödeme tarihi
						else
						{
							if(get_payment_plan.due_date[i] lt CreateODBCDateTime(attributes.finish_date))
								satir = yerles(satir,dateformat(now(),'yyyymmdd'),59,8," ");//Son Ödeme tarihi
							else
								satir = yerles(satir,dateformat(get_payment_plan.due_date[i],'yyyymmdd'),59,8," ");	
						}
						
                        satir = yerles(satir,left(replacelist(get_payment_plan.member_name[i],"ş,Ş,ğ,Ğ,ı,İ","s,S,g,G,i,I"),50),67,50," ");//Firma unvan
                        toplam = toplam + wrk_round(tutar);//trailerda toplam tutar bilgisi için
                        kayit_sayisi = kayit_sayisi + 1;//trailerda seçili satırların toplamı için
                        file_content[index_array] = "#satir#";
                        index_array = index_array+1;
                        writeoutput('<br/>#kayit_sayisi#. Satır Yazıldı (Fatura ID : #get_payment_plan.invoice_id[i]#)');	
                    }
                }
                catch(any e)
                {
                    writeoutput('<br/>#i#. Satır Yazılamadı (Fatura ID : #get_payment_plan.invoice_id[i]#)');	
                }
            }
            trailer = "F" & repeatString("0",10-len(kayit_sayisi)) & kayit_sayisi & repeatString("0",18-len(NumberFormat(toplam,"00.00"))) & NumberFormat(toplam,"00.00");
            file_content[index_array] = "#trailer#";
            index_array = index_array+1;
        }
        else if (attributes.bank_name eq 11)// Finansbank Belge Formatı
        {
            header = "H" & dateformat(now(),'ddmmyyyy') & Year(now()) & repeatString("0",2-len(Month(now()))) & Month(now());
            file_content[index_array] = "#header#";
            index_array = index_array+1;
            for(i=1;i lte GET_PAYMENT_PLAN.recordcount;i=i+1)
            {
                try
                {
                    if(get_payment_plan.invoice_id[i] eq get_payment_plan.invoice_id[i-1] and get_payment_plan.period_id[i] eq get_payment_plan.period_id[i-1])
						{}
                    else{
                        satir = "";
                        tutar = get_payment_plan.nettotal[i];
                        satir = satir & "D" & repeatString(" ",142);
                        satir = yerles(satir,replacelist(get_payment_plan.subs_no[i],"ş,Ş,ğ,Ğ,ı,İ,Ö,ö,Ü,ü,Ç,ç","s,S,g,G,i,I,O,o,U,u,C,c"),2,12," ");//Sistem no
                        satir = yerles(satir,left(replacelist(get_payment_plan.member_name[i],"ş,Ş,ğ,Ğ,ı,İ,Ö,ö,Ü,ü,Ç,ç","s,S,g,G,i,I,O,o,U,u,C,c"),60),14,60," ");//Firma unvan
                        satir = yerles_saga(satir,get_payment_plan.invoice_id[i],74,12,"0");//Fatura id
                        satir = yerles(satir,dateformat(get_payment_plan.inv_date[i],'ddmmyyyy'),86,8," ");//Fatura tarihi
                        
						if(isdefined('attributes.due_date') and len(attributes.due_date))
							satir = yerles(satir,dateformat(attributes.due_date,'yyyymmdd'),94,8," ");//Son Ödeme tarihi
						else
						{
							if(get_payment_plan.due_date[i] lt CreateODBCDateTime(attributes.finish_date))
								satir = yerles(satir,dateformat(now(),'ddmmyyyy'),94,8," ");//Son Ödeme tarihi
							else
								satir = yerles(satir,dateformat(get_payment_plan.due_date[i],'ddmmyyyy'),94,8," ");	
						}
    
                        satir = yerles_saga(satir,NumberFormat(tutar,"00.00"),102,15,"0");//Fatura tutarı
                        satir = yerles(satir,"H",117,1," ");//otomatik ödeme kurumu
                        satir = yerles(satir," ",118,10," ");//banka kodu
                        satir = yerles_saga(satir,get_payment_plan.payment_row[i],128,15,"0");//ödeme planı satır id
                        toplam = toplam + wrk_round(tutar);//trailerda toplam tutar bilgisi için
                        kayit_sayisi = kayit_sayisi + 1;//trailerda seçili satırların toplamı için
                        file_content[index_array] = "#satir#";
                        index_array = index_array+1;
                        writeoutput('<br/>#kayit_sayisi#. Satır Yazıldı (Fatura ID : #get_payment_plan.invoice_id[i]#)');	
                    }
                }
                catch(any e)
                {
                    writeoutput('<br/>#i#. Satır Yazılamadı (Fatura ID : #get_payment_plan.invoice_id[i]#)');	
                }
            }
            trailer = "F" & repeatString("0",8-len(kayit_sayisi)) & kayit_sayisi & repeatString("0",15-len(NumberFormat(toplam,"00.00"))) & NumberFormat(toplam,"00.00");
            file_content[index_array] = "#trailer#";
            index_array = index_array+1;
        }
        else if (attributes.bank_name eq 12)// İşBankası Belge Formatı
        {
            GET_FILE_AMOUNT = cfquery(datasource:"#dsn2#",sqlstring:"
                SELECT
                    TARGET_SYSTEM
                FROM
                    FILE_EXPORTS
                WHERE
                    YEAR(RECORD_DATE) = #year(now())# AND
                    MONTH(RECORD_DATE) = #month(now())# AND
                    DAY(RECORD_DATE) = #day(now())# AND
                    TARGET_SYSTEM = 12");
            
            if (GET_FILE_AMOUNT.recordcount)
                dosya_sayisi = GET_FILE_AMOUNT.recordcount;
            else
                dosya_sayisi = 0;
    
            if(session.ep.company_id eq 1)
				header = "10KB" & repeatString("0",6-len(dosya_sayisi+1)) & dosya_sayisi+1 & dateformat(now(),'yyyymmdd') & "321"  & "PRONET_GUV" & "064" & "ISBANK" & RepeatString(" ",4) & "SIL" & RepeatString(" ",188);
			else
				header = "10KB" & repeatString("0",6) & dateformat(now(),'yyyymmdd') & RepeatString(" ",3) & "WATERNET" & RepeatString(" ",2) & "064" & "ISBANK" & RepeatString(" ",4) & "SIL01562" & RepeatString(" ",188);
				
            file_content[index_array] = "#header#";
            index_array = index_array+1;
            for(i=1;i lte GET_PAYMENT_PLAN.recordcount;i=i+1)
            {
               try
                {
                    if(get_payment_plan.invoice_id[i] eq get_payment_plan.invoice_id[i-1] and get_payment_plan.period_id[i] eq get_payment_plan.period_id[i-1])
						{}
                    else{
                        satir = "";
                        tutar = get_payment_plan.nettotal[i];
                        subs_no_last = replacelist(get_payment_plan.subs_no[i],"ş,Ş,ğ,Ğ,ı,İ","s,S,g,G,i,I");
                        satir = satir & "44" & repeatString(" ",234);
                        satir = yerles(satir,ListLast(subs_no_last,"-"),3,15," ");//Sistem no
                        satir = yerles(satir,get_payment_plan.invoice_id[i],18,16," ");//Fatura id
                        
						if(isdefined('attributes.due_date') and len(attributes.due_date))
							satir = yerles(satir,dateformat(attributes.due_date,'yyyymmdd'),34,8," ");//Son Ödeme tarihi
						else
						{
							if(get_payment_plan.due_date[i] lt CreateODBCDateTime(attributes.finish_date))
								satir = yerles(satir,dateformat(now(),'yyyymmdd'),34,8," ");//Son Ödeme tarihi
							else
								satir = yerles(satir,dateformat(get_payment_plan.due_date[i],'yyyymmdd'),34,8," ");	
						}
                        satir = yerles_saga(satir,NumberFormat(tutar,"00.00"),42,15,"0");//Fatura tutarı
                        satir = yerles_saga(satir,NumberFormat(tutar,"00.00"),57,15,"0");//Gecikmeli Fatura tutarı
                        satir = yerles(satir,"0",72,7,"0");//Ek Müşteri Bilgisi
                        satir = yerles(satir," ",79,5," ");//Rezerve
                        satir = yerles(satir,"TRY",84,3," ");//döviz kuru
                        satir = yerles(satir,dateformat(get_payment_plan.inv_date[i],'yyyymmdd'),87,8," ");//Fatura tarihi
                        satir = yerles(satir,left(replacelist(get_payment_plan.member_name[i],"ş,Ş,ğ,Ğ,ı,İ","s,S,g,G,i,I"),65),95,65," ");//Firma unvan
                        satir = yerles(satir,get_payment_plan.payment_row[i],160,76," ");//ödeme planı satır id
                        toplam = toplam + wrk_round(tutar);//trailerda toplam tutar bilgisi için
                        kayit_sayisi = kayit_sayisi + 1;//trailerda seçili satırların toplamı için
                        file_content[index_array] = "#satir#";
                        index_array = index_array+1;
                        writeoutput('<br/>#kayit_sayisi#. Satır Yazıldı (Fatura ID : #get_payment_plan.invoice_id[i]#)');	
                    }
                }
                catch(any e)
                {
                    writeoutput('<br/>#i#. Satır Yazılamadı (Fatura ID : #get_payment_plan.invoice_id[i]#)');	
                }
            }
            trailer = "45" & repeatString("0",15-len(kayit_sayisi)) & kayit_sayisi & repeatString("0",15-len(NumberFormat(toplam,"00.00"))) & NumberFormat(toplam,"00.00") & repeatString("0",15-len(NumberFormat(toplam,"00.00"))) & NumberFormat(toplam,"00.00") & repeatString(" ",188) & CRLF & "90" & repeatString("0",15-len(kayit_sayisi+3)) & kayit_sayisi+3 & repeatString(" ",218);
            file_content[index_array] = "#trailer#";
            index_array = index_array+1;
        }
        else if (ListFind('13,16,17,19,23,25',attributes.bank_name))// Garanti-YKB-Akbank-Ziraat Belge Formatı, Sekerbank
        {
            GET_FILE_AMOUNT = cfquery(datasource:"#dsn2#",sqlstring:"
                SELECT
                    TARGET_SYSTEM
                FROM
                    FILE_EXPORTS
                WHERE
                    YEAR(RECORD_DATE) = #year(now())# AND
                    MONTH(RECORD_DATE) = #month(now())# AND
                    DAY(RECORD_DATE) = #day(now())# AND
                    TARGET_SYSTEM = #attributes.bank_name#");
            
            if (get_file_amount.recordcount)
                dosya_sayisi = get_file_amount.recordcount;
            else
                dosya_sayisi = 0;
    
            if(ListFind('13,25',attributes.bank_name))//garanti-sekerbank
                header = "H02554" & dateformat(now(),'yyyymmdd') & repeatString("0",6-len(dosya_sayisi+1)) & dosya_sayisi+1;
            else//ykb formatıda aynı şekilde sadece header daki no farklı,oyüzden ayrı bir blok yapmadım
                header = "H00001" & dateformat(now(),'yyyymmdd') & repeatString("0",6-len(dosya_sayisi+1)) & dosya_sayisi+1;
            
            file_content[index_array] = "#header#";
            index_array = index_array+1;
            for(i=1;i lte GET_PAYMENT_PLAN.recordcount;i=i+1)
            {
                try
                {
                    if(get_payment_plan.invoice_id[i] eq get_payment_plan.invoice_id[i-1] and get_payment_plan.period_id[i] eq get_payment_plan.period_id[i-1])
						{}
                    else{
                        satir = "";
                        tutar = get_payment_plan.nettotal[i];
                        subs_no_last = replacelist(get_payment_plan.subs_no[i],"ş,Ş,ğ,Ğ,ı,İ","s,S,g,G,i,I");
                        satir = satir & "D" & repeatString(" ",179);
                        satir = yerles(satir,ListLast(subs_no_last,"-"),2,20," ");//Sistem no
                        satir = yerles(satir,left(replacelist(get_payment_plan.member_name[i],"ş,Ş,ğ,Ğ,ı,İ","s,S,g,G,i,I"),35),22,35," ");//Firma unvan
                        satir = yerles(satir,get_payment_plan.invoice_id[i],57,13," ");//Fatura id
                        satir = yerles(satir,dateformat(get_payment_plan.inv_date[i],'yyyymmdd'),70,8,"0");//Fatura tarihi
                        
						if(isdefined('attributes.due_date') and len(attributes.due_date))
							satir = yerles(satir,dateformat(attributes.due_date,'yyyymmdd'),78,8,"0");//Son Ödeme tarihi
						else
						{
							if(get_payment_plan.due_date[i] lt CreateODBCDateTime(attributes.finish_date))
								satir = yerles(satir,dateformat(now(),'yyyymmdd'),78,8,"0");//Son Ödeme tarihi
							else
								satir = yerles(satir,dateformat(get_payment_plan.due_date[i],'yyyymmdd'),78,8,"0");	
						}
                        satir = yerles_saga(satir,NumberFormat(tutar,"00.00"),86,15,"0");//Fatura tutarı
                        satir = yerles(satir,"YTL",101,3," ");//döviz kuru
                        satir = yerles_saga(satir,"0",104,15,"0");//Fat. Tah.Tut
                        satir = yerles(satir,get_payment_plan.payment_row[i],119,60," ");//ödeme planı satır id-Parametreler alanı
                        satir = yerles(satir,"01",179,2,"0");//İşlem Kodu
                        toplam = toplam + wrk_round(tutar);//trailerda toplam tutar bilgisi için
                        kayit_sayisi = kayit_sayisi + 1;//trailerda seçili satırların toplamı için
                        file_content[index_array] = "#satir#";
                        index_array = index_array+1;
                        writeoutput('<br/>#kayit_sayisi#. Satır Yazıldı (Fatura ID : #get_payment_plan.invoice_id[i]#)');	
                   }
                }
                catch(any e)
                {
                    writeoutput('<br/>#i#. Satır Yazılamadı (Fatura ID : #get_payment_plan.invoice_id[i]#)');	
                }
            }
            trailer = "T" & repeatString("0",7-len(kayit_sayisi)) & kayit_sayisi;
            file_content[index_array] = "#trailer#";
            index_array = index_array+1;
        }
        else if (attributes.bank_name eq 14)// oyak Belge Formatı
        {
            GET_FILE_AMOUNT = cfquery(datasource:"#dsn2#",sqlstring:"
                SELECT
                    TARGET_SYSTEM
                FROM
                    FILE_EXPORTS
                WHERE
                    YEAR(RECORD_DATE) = #year(now())# AND
                    MONTH(RECORD_DATE) = #month(now())# AND
                    DAY(RECORD_DATE) = #day(now())# AND
                    TARGET_SYSTEM = 14");
            
            if (get_file_amount.recordcount)
                dosya_sayisi = get_file_amount.recordcount;
            else
                dosya_sayisi = 0;
    
            header = "H00493" & dateformat(now(),'yyyymmdd') & repeatString("0",6-len(dosya_sayisi+1)) & dosya_sayisi+1;
            file_content[index_array] = "#header#";
            index_array = index_array+1;
            for(i=1;i lte GET_PAYMENT_PLAN.recordcount;i=i+1)
            {
                try
                {
                    if(get_payment_plan.invoice_id[i] eq get_payment_plan.invoice_id[i-1] and get_payment_plan.period_id[i] eq get_payment_plan.period_id[i-1])
						{}
                    else{
                        satir = "";
                        tutar = get_payment_plan.nettotal[i];
                        subs_no_last = replacelist(get_payment_plan.subs_no[i],"ş,Ş,ğ,Ğ,ı,İ,Ç,ç,Ö,ö,Ü,ü","s,S,g,G,i,I,C,c,O,o,U,u");
                        satir = satir & "D" & repeatString(" ",179);
                        satir = yerles(satir,ListLast(subs_no_last,"-"),2,20," ");//Sistem no
                        satir = yerles(satir,left(replacelist(get_payment_plan.member_name[i],"ş,Ş,ğ,Ğ,ı,İ,Ç,ç,Ö,ö,Ü,ü","s,S,g,G,i,I,C,c,O,o,U,u"),35),22,35," ");//Firma unvan
                        satir = yerles(satir,get_payment_plan.invoice_id[i],57,13," ");//Fatura id
                        satir = yerles(satir,dateformat(get_payment_plan.inv_date[i],'yyyymmdd'),70,8,"0");//Fatura tarihi
                        
						if(isdefined('attributes.due_date') and len(attributes.due_date))
							satir = yerles(satir,dateformat(attributes.due_date,'yyyymmdd'),78,8,"0");//Son Ödeme tarihi
						else
						{
							if(get_payment_plan.due_date[i] lt CreateODBCDateTime(attributes.finish_date))
								satir = yerles(satir,dateformat(now(),'yyyymmdd'),78,8,"0");//Son Ödeme tarihi
							else
								satir = yerles(satir,dateformat(get_payment_plan.due_date[i],'yyyymmdd'),78,8,"0");	
						}
                        satir = yerles_saga(satir,NumberFormat(tutar,"00.00"),86,15,"0");//Fatura tutarı
                        satir = yerles(satir,"YTL",101,3," ");//döviz kuru
                        satir = yerles_saga(satir,"0",104,15,"0");//Fat. Tah.Tut
                        satir = yerles(satir,get_payment_plan.payment_row[i],119,60," ");//ödeme planı satır id-Parametreler alanı
                        satir = yerles(satir,"01",179,2,"0");//İşlem Kodu
                        toplam = toplam + wrk_round(tutar);//trailerda toplam tutar bilgisi için
                        kayit_sayisi = kayit_sayisi + 1;//trailerda seçili satırların toplamı için
                        file_content[index_array] = "#satir#";
                        index_array = index_array+1;
                        writeoutput('<br/>#kayit_sayisi#. Satır Yazıldı (Fatura ID : #get_payment_plan.invoice_id[i]#)');	
                    }
                }
                catch(any e)
                {
                    writeoutput('<br/>#i#. Satır Yazılamadı (Fatura ID : #get_payment_plan.invoice_id[i]#)');	
                }
            }
            trailer = "T" & repeatString("0",7-len(kayit_sayisi)) & kayit_sayisi;
            file_content[index_array] = "#trailer#";
            index_array = index_array+1;
        }
        else if (attributes.bank_name eq 15)// TEB Belge Formatı
        {
            GET_FILE_AMOUNT = cfquery(datasource:"#dsn2#",sqlstring:"
                SELECT
                    TARGET_SYSTEM
                FROM
                    FILE_EXPORTS
                WHERE
                    YEAR(RECORD_DATE) = #year(now())# AND
                    MONTH(RECORD_DATE) = #month(now())# AND
                    DAY(RECORD_DATE) = #day(now())# AND
                    TARGET_SYSTEM = 15");
            
            if (get_file_amount.recordcount)
                dosya_sayisi = get_file_amount.recordcount;
            else
                dosya_sayisi = 0;
    
            header = "H00890" & dateformat(now(),'yyyymmdd') & repeatString("0",6-len(dosya_sayisi+1)) & dosya_sayisi+1;
            file_content[index_array] = "#header#";
            index_array = index_array+1;
            for(i=1;i lte GET_PAYMENT_PLAN.recordcount;i=i+1)
            {
                try
                {
                    if(get_payment_plan.invoice_id[i] eq get_payment_plan.invoice_id[i-1] and get_payment_plan.period_id[i] eq get_payment_plan.period_id[i-1])
						{}
                    else{
                        satir = "";
                        tutar = get_payment_plan.nettotal[i];
                        subs_no_last = replacelist(get_payment_plan.subs_no[i],"ş,Ş,ğ,Ğ,ı,İ,Ç,ç,Ö,ö,Ü,ü","s,S,g,G,i,I,C,c,O,o,U,u");
                        satir = satir & "D" & repeatString(" ",179);
                        satir = yerles(satir,ListLast(subs_no_last,"-"),2,20," ");//Sistem no
                        satir = yerles(satir,left(replacelist(get_payment_plan.member_name[i],"ş,Ş,ğ,Ğ,ı,İ,Ç,ç,Ö,ö,Ü,ü","s,S,g,G,i,I,C,c,O,o,U,u"),35),22,35," ");//Firma unvan
                        satir = yerles(satir,get_payment_plan.invoice_id[i],57,13," ");//Fatura id
                        satir = yerles(satir,dateformat(get_payment_plan.inv_date[i],'yyyymmdd'),70,8,"0");//Fatura tarihi
                        
						if(isdefined('attributes.due_date') and len(attributes.due_date))
							satir = yerles(satir,dateformat(attributes.due_date,'yyyymmdd'),78,8,"0");//Son Ödeme tarihi
						else
						{
							if(get_payment_plan.due_date[i] lt CreateODBCDateTime(attributes.finish_date))
								satir = yerles(satir,dateformat(now(),'yyyymmdd'),78,8,"0");//Son Ödeme tarihi
							else
								satir = yerles(satir,dateformat(get_payment_plan.due_date[i],'yyyymmdd'),78,8,"0");	
						}
                        satir = yerles_saga(satir,NumberFormat(tutar,"00.00"),86,15,"0");//Fatura tutarı
                        satir = yerles(satir,"YTL",101,3," ");//döviz kuru
                        satir = yerles_saga(satir,"0",104,15,"0");//Fat. Tah.Tut
                        satir = yerles(satir,get_payment_plan.payment_row[i],119,60," ");//ödeme planı satır id-Parametreler alanı
                        satir = yerles(satir,"01",179,2,"0");//İşlem Kodu
                        toplam = toplam + wrk_round(tutar);//trailerda toplam tutar bilgisi için
                        kayit_sayisi = kayit_sayisi + 1;//trailerda seçili satırların toplamı için
                        file_content[index_array] = "#satir#";
                        index_array = index_array+1;
                        writeoutput('<br/>#kayit_sayisi#. Satır Yazıldı (Fatura ID : #get_payment_plan.invoice_id[i]#)');	
                    }
                }
                catch(any e)
                {
                    writeoutput('<br/>#i#. Satır Yazılamadı (Fatura ID : #get_payment_plan.invoice_id[i]#)');	
                }
            }
            trailer = "T" & repeatString("0",7-len(kayit_sayisi)) & kayit_sayisi;
            file_content[index_array] = "#trailer#";
            index_array = index_array+1;
        }
        else if (listfind('20,24',attributes.bank_name))//Denizbank ve odeabank Belge Formatı
        {
			if(attributes.bank_name eq 20)
           	 header = "HFT" & "134" & dateformat(now(),'yyyymmdd');	
			else
           	 header = "HFT" & "146" & dateformat(now(),'yyyymmdd');	
            file_content[index_array] = "#header#";
            index_array = index_array+1;
            for(i=1;i lte GET_PAYMENT_PLAN.recordcount;i=i+1)
            {
                try
                {
                    if(get_payment_plan.invoice_id[i] eq get_payment_plan.invoice_id[i-1] and get_payment_plan.period_id[i] eq get_payment_plan.period_id[i-1])
						{}
                    else{
                        satir = "";
                        tutar = get_payment_plan.nettotal[i];
                        subs_no_last = replacelist(get_payment_plan.subs_no[i],"ş,Ş,ğ,Ğ,ı,İ,Ç,ç,Ö,ö,Ü,ü","s,S,g,G,i,I,C,c,O,o,U,u");
                        satir = satir & "F" & repeatString(" ",143);
                        satir = yerles(satir,subs_no_last,2,15," ");//Abone No
                        satir = yerles(satir,get_payment_plan.invoice_id[i],17,15," ");//Fatura id
                        satir = yerles(satir,dateformat(get_payment_plan.inv_date[i],'yyyymmdd'),32,8,"0");//Fatura tarihi
                        
						if(isdefined('attributes.due_date') and len(attributes.due_date))
							satir = yerles(satir,dateformat(attributes.due_date,'yyyymmdd'),40,8,"0");//Son Ödeme tarihi
						else
						{
							if(get_payment_plan.due_date[i] lt CreateODBCDateTime(attributes.finish_date))
								satir = yerles(satir,dateformat(now(),'yyyymmdd'),40,8,"0");//Son Ödeme tarihi
							else
								satir = yerles(satir,dateformat(get_payment_plan.due_date[i],'yyyymmdd'),40,8,"0");	
						}
						
                        satir = yerles_saga(satir,tutar,48,21,"0");//Fatura tutarı
                        satir = yerles(satir,"TRY",69,3," ");//döviz kuru
                        satir = yerles(satir,"Y",72,1," ");//Durum Kodu
                        satir = yerles(satir,repeatString(" ",40),73,40," ");//Açıklama
                        //satir = yerles_saga(satir,"0",104,15,"0");//Fat. Tah.Tut
                        satir = yerles(satir,get_payment_plan.payment_row[i],113,30," ");//ödeme planı satır id-Parametreler alanı
                        toplam = toplam + wrk_round(tutar);//trailerda toplam tutar bilgisi için
                        kayit_sayisi = kayit_sayisi + 1;//trailerda seçili satırların toplamı için
                        file_content[index_array] = "#satir#";
                        index_array = index_array+1;
                        writeoutput('<br/>#kayit_sayisi#. Satır Yazıldı (Fatura ID :#get_payment_plan.invoice_id[i]#)');	
                    }
                }
                catch(any e)
                {
                    writeoutput('<br/>#i#. Satır Yazılamadı (Fatura NO : #get_payment_plan.invoice_id[i]#)');
                }
            }
            trailer = "T" & repeatString("0",5-len(kayit_sayisi)) & kayit_sayisi;
            file_content[index_array] = "#trailer#";
        }
        else if (attributes.bank_name eq 22)//Vakıf Bank Belge Formatı
        {
            GET_MAX_FILE_ID = cfquery(datasource:"#dsn2#",sqlstring:"
                SELECT
                    MAX(E_ID) MAX_E_ID
                FROM
                    FILE_EXPORTS
                ");
                    
            header = "10" & "KB" & repeatString("0",6-len(GET_MAX_FILE_ID.MAX_E_ID+1)) & "#GET_MAX_FILE_ID.MAX_E_ID+1#" & dateformat(now(),'yyyymmdd')& "XXX" & "YYYYYYYYYY" & "ZZZ" & "WWWWWWWWWW"& "NOR" & repeatString(".",188);	
            file_content[index_array] = "#header#";
            index_array = index_array+1;
            for(i=1;i lte GET_PAYMENT_PLAN.recordcount;i=i+1)
            {		
                try
                {
                    if(get_payment_plan.invoice_id[i] eq get_payment_plan.invoice_id[i-1] and get_payment_plan.period_id[i] eq get_payment_plan.period_id[i-1])
						{}
                    else{
                        satir = "";
                        tutar = get_payment_plan.nettotal[i];
                        subs_no_last = replacelist(get_payment_plan.subs_no[i],"ş,Ş,ğ,Ğ,ı,İ,Ç,ç,Ö,ö,Ü,ü","s,S,g,G,i,I,C,c,O,o,U,u");
                        satir = satir & "44" & repeatString(" ",234);
                        satir = yerles(satir,subs_no_last,3,15," ");//Abone No
                        satir = yerles(satir,get_payment_plan.invoice_number[i],18,16," ");//Fatura No
                        
						if(isdefined('attributes.due_date') and len(attributes.due_date))
							satir = yerles(satir,dateformat(attributes.due_date,'yyyymmdd'),34,8,"0");//Son Ödeme tarihi
						else
						{
							satir = yerles(satir,dateformat(get_payment_plan.inv_date[i],'yyyymmdd'),34,8,"0");//Son Ödeme tarihi
						}
						
                        satir = yerles_saga(satir,NumberFormat(tutar,"00.00"),42,15,"0");//Fatura tutarı
                        satir = yerles(satir," ",57,27," ");
                        satir = yerles(satir,"TRY",84,3," ");//döviz kuru
                        satir = yerles(satir,dateformat(get_payment_plan.inv_date[i],'yyyymmdd'),87,8,"0");//Fatura tarihi
                        satir = yerles(satir,left(get_payment_plan.member_name[i],65),95,65," ");//Firma unvan
                        
                        satir = yerles(satir,get_payment_plan.payment_row[i],160,46," ");//ödeme planı satır id-Parametreler alanı
                        satir = yerles(satir,get_payment_plan.invoice_id[i],206,30," ");//invoice_id
                        
                        toplam = toplam + wrk_round(tutar);//trailerda toplam tutar bilgisi için
                        kayit_sayisi = kayit_sayisi + 1;//trailerda seçili satırların toplamı için
                        file_content[index_array] = "#satir#";
                        index_array = index_array+1;
                        writeoutput('<br/>#kayit_sayisi#. Satır Yazıldı (Fatura ID :#get_payment_plan.invoice_id[i]#)');	
                    }
                }
                catch(any e)
                {
                    writeoutput('<br/>#i#. Satır Yazılamadı (Fatura NO : #get_payment_plan.invoice_id[i]#)');
                }
            }
            trailer_ = "45" & repeatString("0",15-len(kayit_sayisi)) & kayit_sayisi & repeatString("0",15-len(toplam)) & toplam & repeatString(" ",15) & repeatString(".",188);
            file_content[index_array] = "#trailer_#";
            index_array = index_array + 1;
            trailer = "90" & repeatString("0",15-len(kayit_sayisi)) & (kayit_sayisi+3) & repeatString(".",218);
            file_content[index_array] = "#trailer#";
        }
    </cfscript>
<cfelse>
	<cfscript>
		CRLF=chr(13)&chr(10);
		file_content = ArrayNew(1);
		index_array = 1;
		toplam = 0;
		kayit_sayisi = 0;
		
		if(isdefined("attributes.source") and attributes.source eq 2 and attributes.is_file_from_manuelpaper neq 1)//fatura ödeme planı seçilmişse dbs formatında dosya oluşacak
		{
			if(len(attributes.bank_code_) <= 4)
				banka_kodu = repeatString("0",4-len(attributes.bank_code_)) & "#attributes.bank_code_#";
			else 
				banka_kodu = "#right(attributes.bank_code_,4)#";
			header = "H" & dateformat(now(),'yyyymmddhhmmss') & "#banka_kodu#" & "#left(replacelist(attributes.bank_name_," ",""),10)#";
			file_content[index_array] = "#header#";
			index_array = index_array+1;
			for(i=1;i lte attributes.all_records;i=i+1)
			{
				"deger_#i#" = 1;
				try
				{
					if(isdefined("attributes.payment_row#i#"))
					{
						satir = "";
						if (evaluate("attributes.other_money#i#") == 'TL')
							"attributes.other_money#i#" = 'TRY';
						tutar = evaluate("attributes.nettotal#i#");
						satir = satir & "D" & repeatString(" ",132);
						satir = yerles(satir,replacelist(evaluate("attributes.member_code#i#"),"ş,Ş,ğ,Ğ,ı,İ","s,S,g,G,i,I"),2,20," ");//müşteri no
						satir = yerles(satir,replacelist(left(evaluate("attributes.member_name#i#"),40),"ş,Ş,ğ,Ğ,ı,İ","s,S,g,G,i,I"),22,40," ");//müşteri unvan/adi
						satir = yerles(satir,evaluate("attributes.invoice_number#i#"),62,16," ");//fatura no
						satir = yerles(satir,dateformat(evaluate("attributes.invoice_date#i#"),'yyyymmdd'),78,8," ");//vade tarihi
						satir = yerles(satir,dateformat(evaluate("attributes.due_date#i#"),'yyyymmdd'),86,8," ");//vade tarihi
						satir = yerles_saga(satir,NumberFormat(tutar,"00.00"),94,15,"0");//Fatura tutarı
						satir = yerles(satir,evaluate("attributes.other_money#i#"),109,3," ");//döviz
						satir = yerles(satir,evaluate("attributes.pay_type#i#"),112,1," ");//satır tipi
						satir = yerles_saga(satir,evaluate("attributes.invoice_payment_plan_id#i#"),113,20,"0");//satır id
						file_content[index_array] = "#satir#";
						index_array = index_array+1;
						writeoutput('<br/>#i#. Satır Yazıldı (Satır ID : #evaluate("attributes.invoice_payment_plan_id#i#")#)');	
					}
				}
				catch(any e)
				{
					writeoutput('<br/>#i#. Satır Yazılamadı (Satır ID : #evaluate("attributes.invoice_payment_plan_id#i#")#)');
					"deger_#i#" = 0;
				}
			}
			index_array = index_array+1;
		}
		else if (attributes.bank_name eq 10)// HSBC Belge Formatı
		{
			header = "H" & dateformat(now(),'yyyymmdd') & "000123";
			file_content[index_array] = "#header#";
			index_array = index_array+1;
			for(i=1;i lte attributes.all_records;i=i+1)
			{
				try
				{
					if(isdefined("attributes.payment_row#i#"))
					{
						satir = "";
						tutar = evaluate("attributes.nettotal#i#");
						satir = satir & "D" & repeatString(" ",116);
						satir = yerles(satir,replacelist(evaluate("attributes.subs_no#i#"),"ş,Ş,ğ,Ğ,ı,İ","s,S,g,G,i,I"),2,10," ");//Sistem no
						satir = yerles_saga(satir,evaluate("attributes.invoice_id#i#"),12,12," ");//Fatura id
						satir = yerles_saga(satir,evaluate("attributes.payment_row#i#"),24,12," ");//ödeme planı satır id
						satir = yerles_saga(satir,NumberFormat(tutar,"00.00"),36,15,"0");//Fatura tutarı
						satir = yerles(satir,dateformat(evaluate("attributes.invoice_date#i#"),'yyyymmdd'),51,8," ");//Fatura tarihi
						
						if(isdefined('attributes.due_date') and len(attributes.due_date))
							satir = yerles(satir,dateformat(attributes.due_date,'yyyymmdd'),59,8," ");//Son Ödeme tarihi
						else
						{
							if(evaluate("attributes.due_date#i#") lt CreateODBCDateTime(attributes.finish_date))
								satir = yerles(satir,dateformat(now(),'yyyymmdd'),59,8," ");//Son Ödeme tarihi
							else
								satir = yerles(satir,dateformat(evaluate("attributes.due_date#i#"),'yyyymmdd'),59,8," ");
						}
						
						satir = yerles(satir,left(replacelist(evaluate("attributes.member_name#i#"),"ş,Ş,ğ,Ğ,ı,İ","s,S,g,G,i,I"),50),67,50," ");//Firma unvan
						toplam = toplam + wrk_round(tutar);//trailerda toplam tutar bilgisi için
						kayit_sayisi = kayit_sayisi + 1;//trailerda seçili satırların toplamı için
						file_content[index_array] = "#satir#";
						index_array = index_array+1;
						writeoutput('<br/>#i#. Satır Yazıldı (Fatura ID : #evaluate("attributes.invoice_id#i#")#)');	
					}
				}
				catch(any e)
				{
					writeoutput('<br/>#i#. Satır Yazılamadı (Fatura ID : #evaluate("attributes.invoice_id#i#")#)');	
				}
			}
			trailer = "F" & repeatString("0",10-len(kayit_sayisi)) & kayit_sayisi & repeatString("0",18-len(NumberFormat(toplam,"00.00"))) & NumberFormat(toplam,"00.00");
			file_content[index_array] = "#trailer#";
			index_array = index_array+1;
		}
		else if (attributes.bank_name eq 11)// Finansbank Belge Formatı
		{
			header = "H" & dateformat(now(),'ddmmyyyy') & Year(now()) & repeatString("0",2-len(Month(now()))) & Month(now());
			file_content[index_array] = "#header#";
			index_array = index_array+1;
			for(i=1;i lte attributes.all_records;i=i+1)
			{
				try
				{
					if(isdefined("attributes.payment_row#i#"))
					{
						satir = "";
						tutar = evaluate("attributes.nettotal#i#");
						satir = satir & "D" & repeatString(" ",142);
						satir = yerles(satir,replacelist(evaluate("attributes.subs_no#i#"),"ş,Ş,ğ,Ğ,ı,İ,Ö,ö,Ü,ü,Ç,ç","s,S,g,G,i,I,O,o,U,u,C,c"),2,12," ");//Sistem no
						satir = yerles(satir,left(replacelist(evaluate("attributes.member_name#i#"),"ş,Ş,ğ,Ğ,ı,İ,Ö,ö,Ü,ü,Ç,ç","s,S,g,G,i,I,O,o,U,u,C,c"),60),14,60," ");//Firma unvan
						satir = yerles_saga(satir,evaluate("attributes.invoice_id#i#"),74,12,"0");//Fatura id
						satir = yerles(satir,dateformat(evaluate("attributes.invoice_date#i#"),'ddmmyyyy'),86,8," ");//Fatura tarihi
						
						if(isdefined('attributes.due_date') and len(attributes.due_date))
							satir = yerles(satir,dateformat(attributes.due_date,'yyyymmdd'),94,8," ");//Son Ödeme tarihi
						else
						{
							if(evaluate("attributes.due_date#i#") lt CreateODBCDateTime(attributes.finish_date))
								satir = yerles(satir,dateformat(now(),'ddmmyyyy'),94,8," ");//Son Ödeme tarihi
							else
								satir = yerles(satir,dateformat(evaluate("attributes.due_date#i#"),'ddmmyyyy'),94,8," ");	
						}
						
						satir = yerles_saga(satir,NumberFormat(tutar,"00.00"),102,15,"0");//Fatura tutarı
						satir = yerles(satir,"H",117,1," ");//otomatik ödeme kurumu
						satir = yerles(satir," ",118,10," ");//banka kodu
						satir = yerles_saga(satir,evaluate("attributes.payment_row#i#"),128,15,"0");//ödeme planı satır id
						toplam = toplam + wrk_round(tutar);//trailerda toplam tutar bilgisi için
						kayit_sayisi = kayit_sayisi + 1;//trailerda seçili satırların toplamı için
						file_content[index_array] = "#satir#";
						index_array = index_array+1;
						writeoutput('<br/>#i#. Satır Yazıldı (Fatura ID : #evaluate("attributes.invoice_id#i#")#)');	
					}
				}
				catch(any e)
				{
					writeoutput('<br/>#i#. Satır Yazılamadı (Fatura ID : #evaluate("attributes.invoice_id#i#")#)');	
				}
			}
			trailer = "F" & repeatString("0",8-len(kayit_sayisi)) & kayit_sayisi & repeatString("0",15-len(NumberFormat(toplam,"00.00"))) & NumberFormat(toplam,"00.00");
			file_content[index_array] = "#trailer#";
			index_array = index_array+1;
		}
		else if (attributes.bank_name eq 12)// İşBankası Belge Formatı
		{
			GET_FILE_AMOUNT = cfquery(datasource:"#dsn2#",sqlstring:"
				SELECT
					TARGET_SYSTEM
				FROM
					FILE_EXPORTS
				WHERE
					YEAR(RECORD_DATE) = #year(now())# AND
					MONTH(RECORD_DATE) = #month(now())# AND
					DAY(RECORD_DATE) = #day(now())# AND
					TARGET_SYSTEM = 12");
			
			if (GET_FILE_AMOUNT.recordcount)
				dosya_sayisi = GET_FILE_AMOUNT.recordcount;
			else
				dosya_sayisi = 0;
	
			if(session.ep.company_id eq 1)
				header = "10KB" & repeatString("0",6-len(dosya_sayisi+1)) & dosya_sayisi+1 & dateformat(now(),'yyyymmdd') & "321"  & "PRONET_GUV" & "064" & "ISBANK" & RepeatString(" ",4) & "SIL" & RepeatString(" ",188);
			else
				header = "10KB" & repeatString("0",6) & dateformat(now(),'yyyymmdd') & RepeatString(" ",3) & "WATERNET" & RepeatString(" ",2) & "064" & "ISBANK" & RepeatString(" ",4) & "SIL01562" & RepeatString(" ",188);
			
			file_content[index_array] = "#header#";
			index_array = index_array+1;
			for(i=1;i lte attributes.all_records;i=i+1)
			{
				try
				{
					if(isdefined("attributes.payment_row#i#"))
					{
						satir = "";
						tutar = evaluate("attributes.nettotal#i#");
						subs_no_last = replacelist(evaluate("attributes.subs_no#i#"),"ş,Ş,ğ,Ğ,ı,İ","s,S,g,G,i,I");
						satir = satir & "44" & repeatString(" ",234);
						satir = yerles(satir,ListLast(subs_no_last,"-"),3,15," ");//Sistem no
						satir = yerles(satir,evaluate("attributes.invoice_id#i#"),18,16," ");//Fatura id
						
						if(isdefined('attributes.due_date') and len(attributes.due_date))
							satir = yerles(satir,dateformat(attributes.due_date,'yyyymmdd'),34,8," ");//Son Ödeme tarihi
						else
						{
							if(evaluate("attributes.due_date#i#") lt CreateODBCDateTime(attributes.finish_date))
								satir = yerles(satir,dateformat(now(),'yyyymmdd'),34,8," ");//Son Ödeme tarihi
							else
								satir = yerles(satir,dateformat(evaluate("attributes.due_date#i#"),'yyyymmdd'),34,8," ");	
						}
						
						satir = yerles_saga(satir,NumberFormat(tutar,"00.00"),42,15,"0");//Fatura tutarı
						satir = yerles_saga(satir,NumberFormat(tutar,"00.00"),57,15,"0");//Gecikmeli Fatura tutarı
						satir = yerles(satir,"0",72,7,"0");//Ek Müşteri Bilgisi
						satir = yerles(satir," ",79,5," ");//Rezerve
						satir = yerles(satir,"TRY",84,3," ");//döviz kuru
						satir = yerles(satir,dateformat(evaluate("attributes.invoice_date#i#"),'yyyymmdd'),87,8," ");//Fatura tarihi
						satir = yerles(satir,left(replacelist(evaluate("attributes.member_name#i#"),"ş,Ş,ğ,Ğ,ı,İ","s,S,g,G,i,I"),65),95,65," ");//Firma unvan
						satir = yerles(satir,evaluate("attributes.payment_row#i#"),160,76," ");//ödeme planı satır id
						toplam = toplam + wrk_round(tutar);//trailerda toplam tutar bilgisi için
						kayit_sayisi = kayit_sayisi + 1;//trailerda seçili satırların toplamı için
						file_content[index_array] = "#satir#";
						index_array = index_array+1;
						writeoutput('<br/>#i#. Satır Yazıldı (Fatura ID : #evaluate("attributes.invoice_id#i#")#)');	
					}
				}
				catch(any e)
				{
					writeoutput('<br/>#i#. Satır Yazılamadı (Fatura ID : #evaluate("attributes.invoice_id#i#")#)');	
				}
			}
			trailer = "45" & repeatString("0",15-len(kayit_sayisi)) & kayit_sayisi & repeatString("0",15-len(NumberFormat(toplam,"00.00"))) & NumberFormat(toplam,"00.00") & repeatString("0",15-len(NumberFormat(toplam,"00.00"))) & NumberFormat(toplam,"00.00") & repeatString(" ",188) & CRLF & "90" & repeatString("0",15-len(kayit_sayisi+3)) & kayit_sayisi+3 & repeatString(" ",218);
			file_content[index_array] = "#trailer#";
			index_array = index_array+1;
		}
		else if (ListFind('13,16,17,19,23,25',attributes.bank_name))// Garanti-YKB-Akbank-Ziraat Belge Formatı,Sekerbank
		{
			GET_FILE_AMOUNT = cfquery(datasource:"#dsn2#",sqlstring:"
				SELECT
					TARGET_SYSTEM
				FROM
					FILE_EXPORTS
				WHERE
					YEAR(RECORD_DATE) = #year(now())# AND
					MONTH(RECORD_DATE) = #month(now())# AND
					DAY(RECORD_DATE) = #day(now())# AND
					TARGET_SYSTEM = #attributes.bank_name#");
			
			if (get_file_amount.recordcount)
				dosya_sayisi = get_file_amount.recordcount;
			else
				dosya_sayisi = 0;
	
			if(ListFind('13,25',attributes.bank_name))//garanti-sekerbank
				header = "H02554" & dateformat(now(),'yyyymmdd') & repeatString("0",6-len(dosya_sayisi+1)) & dosya_sayisi+1;
			else//ykb formatıda aynı şekilde sadece header daki no farklı,oyüzden ayrı bir blok yapmadım
				header = "H00001" & dateformat(now(),'yyyymmdd') & repeatString("0",6-len(dosya_sayisi+1)) & dosya_sayisi+1;
			
			file_content[index_array] = "#header#";
			index_array = index_array+1;
			for(i=1;i lte attributes.all_records;i=i+1)
			{
				try
				{
					if(isdefined("attributes.payment_row#i#"))
					{
						satir = "";
						tutar = evaluate("attributes.nettotal#i#");
						subs_no_last = replacelist(evaluate("attributes.subs_no#i#"),"ş,Ş,ğ,Ğ,ı,İ","s,S,g,G,i,I");
						satir = satir & "D" & repeatString(" ",179);
						satir = yerles(satir,ListLast(subs_no_last,"-"),2,20," ");//Sistem no
						satir = yerles(satir,left(replacelist(evaluate("attributes.member_name#i#"),"ş,Ş,ğ,Ğ,ı,İ","s,S,g,G,i,I"),35),22,35," ");//Firma unvan
						satir = yerles(satir,evaluate("attributes.invoice_id#i#"),57,13," ");//Fatura id
						satir = yerles(satir,dateformat(evaluate("attributes.invoice_date#i#"),'yyyymmdd'),70,8,"0");//Fatura tarihi
						
						if(isdefined('attributes.due_date') and len(attributes.due_date))
							satir = yerles(satir,dateformat(attributes.due_date,'yyyymmdd'),78,8,"0");//Son Ödeme tarihi
						else
						{
							if(evaluate("attributes.due_date#i#") lt CreateODBCDateTime(attributes.finish_date))
								satir = yerles(satir,dateformat(now(),'yyyymmdd'),78,8,"0");//Son Ödeme tarihi
							else
								satir = yerles(satir,dateformat(evaluate("attributes.due_date#i#"),'yyyymmdd'),78,8,"0");	
						}
						satir = yerles_saga(satir,NumberFormat(tutar,"00.00"),86,15,"0");//Fatura tutarı
						satir = yerles(satir,"YTL",101,3," ");//döviz kuru
						satir = yerles_saga(satir,"0",104,15,"0");//Fat. Tah.Tut
						satir = yerles(satir,evaluate("attributes.payment_row#i#"),119,60," ");//ödeme planı satır id-Parametreler alanı
						satir = yerles(satir,"01",179,2,"0");//İşlem Kodu
						toplam = toplam + wrk_round(tutar);//trailerda toplam tutar bilgisi için
						kayit_sayisi = kayit_sayisi + 1;//trailerda seçili satırların toplamı için
						file_content[index_array] = "#satir#";
						index_array = index_array+1;
						writeoutput('<br/>#i#. Satır Yazıldı (Fatura ID : #evaluate("attributes.invoice_id#i#")#)');	
					}
				}
				catch(any e)
				{
					writeoutput('<br/>#i#. Satır Yazılamadı (Fatura ID : #evaluate("attributes.invoice_id#i#")#)');	
				}
			}
			trailer = "T" & repeatString("0",7-len(kayit_sayisi)) & kayit_sayisi;
			file_content[index_array] = "#trailer#";
			index_array = index_array+1;
		}
		else if (attributes.bank_name eq 14)// Oyakbank Belge Formatı
		{
			GET_FILE_AMOUNT = cfquery(datasource:"#dsn2#",sqlstring:"
				SELECT
					TARGET_SYSTEM
				FROM
					FILE_EXPORTS
				WHERE
					YEAR(RECORD_DATE) = #year(now())# AND
					MONTH(RECORD_DATE) = #month(now())# AND
					DAY(RECORD_DATE) = #day(now())# AND
					TARGET_SYSTEM = 14");
			
			if (get_file_amount.recordcount)
				dosya_sayisi = get_file_amount.recordcount;
			else
				dosya_sayisi = 0;
	
			header = "H00493" & dateformat(now(),'yyyymmdd') & repeatString("0",6-len(dosya_sayisi+1)) & dosya_sayisi+1;
			file_content[index_array] = "#header#";
			index_array = index_array+1;
			for(i=1;i lte attributes.all_records;i=i+1)
			{
				try
				{
					if(isdefined("attributes.payment_row#i#"))
					{
						satir = "";
						tutar = evaluate("attributes.nettotal#i#");
						subs_no_last = replacelist(evaluate("attributes.subs_no#i#"),"ş,Ş,ğ,Ğ,ı,İ,Ç,ç,Ö,ö,Ü,ü","s,S,g,G,i,I,C,c,O,o,U,u");
						satir = satir & "D" & repeatString(" ",179);
						satir = yerles(satir,ListLast(subs_no_last,"-"),2,20," ");//Sistem no
						satir = yerles(satir,left(replacelist(evaluate("attributes.member_name#i#"),"ş,Ş,ğ,Ğ,ı,İ,Ç,ç,Ö,ö,Ü,ü","s,S,g,G,i,I,C,c,O,o,U,u"),35),22,35," ");//Firma unvan
						satir = yerles(satir,evaluate("attributes.invoice_id#i#"),57,13," ");//Fatura id
						satir = yerles(satir,dateformat(evaluate("attributes.invoice_date#i#"),'yyyymmdd'),70,8,"0");//Fatura tarihi
						
						if(isdefined('attributes.due_date') and len(attributes.due_date))
							satir = yerles(satir,dateformat(attributes.due_date,'yyyymmdd'),78,8,"0");//Son Ödeme tarihi
						else
						{
							if(evaluate("attributes.due_date#i#") lt CreateODBCDateTime(attributes.finish_date))
								satir = yerles(satir,dateformat(now(),'yyyymmdd'),78,8,"0");//Son Ödeme tarihi
							else
								satir = yerles(satir,dateformat(evaluate("attributes.due_date#i#"),'yyyymmdd'),78,8,"0");	
						}
						
						satir = yerles_saga(satir,NumberFormat(tutar,"00.00"),86,15,"0");//Fatura tutarı
						satir = yerles(satir,"YTL",101,3," ");//döviz kuru
						satir = yerles_saga(satir,"0",104,15,"0");//Fat. Tah.Tut
						satir = yerles(satir,evaluate("attributes.payment_row#i#"),119,60," ");//ödeme planı satır id-Parametreler alanı
						satir = yerles(satir,"01",179,2,"0");//İşlem Kodu
						toplam = toplam + wrk_round(tutar);//trailerda toplam tutar bilgisi için
						kayit_sayisi = kayit_sayisi + 1;//trailerda seçili satırların toplamı için
						file_content[index_array] = "#satir#";
						index_array = index_array+1;
						writeoutput('<br/>#i#. Satır Yazıldı (Fatura ID : #evaluate("attributes.invoice_id#i#")#)');	
					}
				}
				catch(any e)
				{
					writeoutput('<br/>#i#. Satır Yazılamadı (Fatura ID : #evaluate("attributes.invoice_id#i#")#)');	
				}
			}
			trailer = "T" & repeatString("0",7-len(kayit_sayisi)) & kayit_sayisi;
			file_content[index_array] = "#trailer#";
			index_array = index_array+1;
		}
		else if (attributes.bank_name eq 15)// TEB Belge Formatı
		{
			GET_FILE_AMOUNT = cfquery(datasource:"#dsn2#",sqlstring:"
				SELECT
					TARGET_SYSTEM
				FROM
					FILE_EXPORTS
				WHERE
					YEAR(RECORD_DATE) = #year(now())# AND
					MONTH(RECORD_DATE) = #month(now())# AND
					DAY(RECORD_DATE) = #day(now())# AND
					TARGET_SYSTEM = 15");
			
			if (get_file_amount.recordcount)
				dosya_sayisi = get_file_amount.recordcount;
			else
				dosya_sayisi = 0;
	
			header = "H00890" & dateformat(now(),'yyyymmdd') & repeatString("0",6-len(dosya_sayisi+1)) & dosya_sayisi+1;
			file_content[index_array] = "#header#";
			index_array = index_array+1;
			for(i=1;i lte attributes.all_records;i=i+1)
			{
				try
				{
					if(isdefined("attributes.payment_row#i#"))
					{
						satir = "";
						tutar = evaluate("attributes.nettotal#i#");
						subs_no_last = replacelist(evaluate("attributes.subs_no#i#"),"ş,Ş,ğ,Ğ,ı,İ,Ç,ç,Ö,ö,Ü,ü","s,S,g,G,i,I,C,c,O,o,U,u");
						satir = satir & "D" & repeatString(" ",179);
						satir = yerles(satir,ListLast(subs_no_last,"-"),2,20," ");//Sistem no
						satir = yerles(satir,left(replacelist(evaluate("attributes.member_name#i#"),"ş,Ş,ğ,Ğ,ı,İ,Ç,ç,Ö,ö,Ü,ü","s,S,g,G,i,I,C,c,O,o,U,u"),35),22,35," ");//Firma unvan
						satir = yerles(satir,evaluate("attributes.invoice_id#i#"),57,13," ");//Fatura id
						satir = yerles(satir,dateformat(evaluate("attributes.invoice_date#i#"),'yyyymmdd'),70,8,"0");//Fatura tarihi
						
						if(isdefined('attributes.due_date') and len(attributes.due_date))
							satir = yerles(satir,dateformat(attributes.due_date,'yyyymmdd'),78,8,"0");//Son Ödeme tarihi
						else
						{
							if(evaluate("attributes.due_date#i#") lt CreateODBCDateTime(attributes.finish_date))
								satir = yerles(satir,dateformat(now(),'yyyymmdd'),78,8,"0");//Son Ödeme tarihi
							else
								satir = yerles(satir,dateformat(evaluate("attributes.due_date#i#"),'yyyymmdd'),78,8,"0");	
						}
						satir = yerles_saga(satir,NumberFormat(tutar,"00.00"),86,15,"0");//Fatura tutarı
						satir = yerles(satir,"YTL",101,3," ");//döviz kuru
						satir = yerles_saga(satir,"0",104,15,"0");//Fat. Tah.Tut
						satir = yerles(satir,evaluate("attributes.payment_row#i#"),119,60," ");//ödeme planı satır id-Parametreler alanı
						satir = yerles(satir,"01",179,2,"0");//İşlem Kodu
						toplam = toplam + wrk_round(tutar);//trailerda toplam tutar bilgisi için
						kayit_sayisi = kayit_sayisi + 1;//trailerda seçili satırların toplamı için
						file_content[index_array] = "#satir#";
						index_array = index_array+1;
						writeoutput('<br/>#i#. Satır Yazıldı (Fatura ID : #evaluate("attributes.invoice_id#i#")#)');	
					}
				}
				catch(any e)
				{
					writeoutput('<br/>#i#. Satır Yazılamadı (Fatura ID : #evaluate("attributes.invoice_id#i#")#)');	
				}
			}
			trailer = "T" & repeatString("0",7-len(kayit_sayisi)) & kayit_sayisi;
			file_content[index_array] = "#trailer#";
			index_array = index_array+1;
		}
		else if (listfind('20,24',attributes.bank_name))//Denizbank ve odeabank Belge Formatı
		{
			header = "HFT" & "134" & dateformat(now(),'yyyymmdd');	
			file_content[index_array] = "#header#";
			index_array = index_array+1;
			for(i=1;i lte attributes.all_records;i=i+1)
			{
				try
				{
					if(isdefined("attributes.payment_row#i#"))
					{
						satir = "";
						tutar = evaluate("attributes.nettotal#i#");
						subs_no_last = replacelist(evaluate("attributes.subs_no#i#"),"ş,Ş,ğ,Ğ,ı,İ,Ç,ç,Ö,ö,Ü,ü","s,S,g,G,i,I,C,c,O,o,U,u");
						satir = satir & "F" & repeatString(" ",143);
						satir = yerles(satir,subs_no_last,2,15," ");//Abone No
						satir = yerles(satir,evaluate("attributes.invoice_id#i#"),17,15," ");//Fatura id
						satir = yerles(satir,dateformat(evaluate("attributes.invoice_date#i#"),'yyyymmdd'),32,8,"0");//Fatura tarihi
						
						if(isdefined('attributes.due_date') and len(attributes.due_date))
							satir = yerles(satir,dateformat(attributes.due_date,'yyyymmdd'),40,8,"0");//Son Ödeme tarihi
						else
						{
							if(evaluate("attributes.due_date#i#") lt CreateODBCDateTime(attributes.finish_date))
								satir = yerles(satir,dateformat(now(),'yyyymmdd'),40,8,"0");//Son Ödeme tarihi
							else
								satir = yerles(satir,dateformat(evaluate("attributes.due_date#i#"),'yyyymmdd'),40,8,"0");	
						}
						satir = yerles_saga(satir,tutar,48,21,"0");//Fatura tutarı
						satir = yerles(satir,"TRY",69,3," ");//döviz kuru
						satir = yerles(satir,"Y",72,1," ");//Durum Kodu
						satir = yerles(satir,repeatString(" ",40),73,40," ");//Açıklama
						//satir = yerles_saga(satir,"0",104,15,"0");//Fat. Tah.Tut
						satir = yerles(satir,evaluate("attributes.payment_row#i#"),113,30," ");//ödeme planı satır id-Parametreler alanı
						toplam = toplam + wrk_round(tutar);//trailerda toplam tutar bilgisi için
						kayit_sayisi = kayit_sayisi + 1;//trailerda seçili satırların toplamı için
						file_content[index_array] = "#satir#";
						index_array = index_array+1;
						writeoutput('<br/>#i#. Satır Yazıldı (Fatura ID :#evaluate("attributes.invoice_id#i#")#)');	
					}
				}
				catch(any e)
				{
					writeoutput('<br/>#i#. Satır Yazılamadı (Fatura NO : #evaluate("attributes.invoice_id#i#")#)');
				}
			}
			trailer = "T" & repeatString("0",5-len(kayit_sayisi)) & kayit_sayisi;
			file_content[index_array] = "#trailer#";
		}
		else if (attributes.bank_name eq 22)//Vakıf Bank Belge Formatı
		{
			GET_MAX_FILE_ID = cfquery(datasource:"#dsn2#",sqlstring:"
				SELECT
					MAX(E_ID) MAX_E_ID
				FROM
					FILE_EXPORTS
				");
			header = "10" & "KB" & repeatString("0",6-len(GET_MAX_FILE_ID.MAX_E_ID+1)) & "#GET_MAX_FILE_ID.MAX_E_ID+1#" & dateformat(now(),'yyyymmdd')& "XXX" & "YYYYYYYYYY" & "ZZZ" & "WWWWWWWWWW"& "NOR" & repeatString(".",188);	
			file_content[index_array] = "#header#";
			index_array = index_array+1;
			for(i=1;i lte attributes.all_records;i=i+1)
			{		
				try
				{
					if(isdefined("attributes.payment_row#i#"))
					{
						satir = "";
						tutar = evaluate("attributes.nettotal#i#");
						subs_no_last = replacelist(evaluate("attributes.subs_no#i#"),"ş,Ş,ğ,Ğ,ı,İ,Ç,ç,Ö,ö,Ü,ü","s,S,g,G,i,I,C,c,O,o,U,u");
						satir = satir & "44" & repeatString(" ",234);
						satir = yerles(satir,subs_no_last,3,15," ");//Abone No
						satir = yerles(satir,evaluate("attributes.invoice_number#i#"),18,16," ");//Fatura No
						
						if(isdefined('attributes.due_date') and len(attributes.due_date))
							satir = yerles(satir,dateformat(attributes.due_date,'yyyymmdd'),34,8,"0");//Son Ödeme tarihi
						else
							satir = yerles(satir,dateformat(evaluate("attributes.invoice_date#i#"),'yyyymmdd'),34,8,"0");//Son Ödeme tarihi
							
						satir = yerles_saga(satir,NumberFormat(tutar,"00.00"),42,15,"0");//Fatura tutarı
						satir = yerles(satir," ",57,27," ");
						satir = yerles(satir,"TRY",84,3," ");//döviz kuru
						satir = yerles(satir,dateformat(evaluate("attributes.invoice_date#i#"),'yyyymmdd'),87,8,"0");//Fatura tarihi
						satir = yerles(satir,left(evaluate("attributes.member_name#i#"),65),95,65," ");//Firma unvan
						
						satir = yerles(satir,evaluate("attributes.payment_row#i#"),160,46," ");//ödeme planı satır id-Parametreler alanı
						satir = yerles(satir,evaluate("attributes.invoice_id#i#"),206,30," ");//invoice_id
						
						toplam = toplam + wrk_round(tutar);//trailerda toplam tutar bilgisi için
						kayit_sayisi = kayit_sayisi + 1;//trailerda seçili satırların toplamı için
						file_content[index_array] = "#satir#";
						index_array = index_array+1;
						writeoutput('<br/>#i#. Satır Yazıldı (Fatura ID :#evaluate("attributes.invoice_id#i#")#)');	
					}
				}
				catch(any e)
				{
					writeoutput('<br/>#i#. Satır Yazılamadı (Fatura NO : #evaluate("attributes.invoice_id#i#")#)');
				}
			}
			trailer_ = "45" & repeatString("0",15-len(kayit_sayisi)) & kayit_sayisi & repeatString("0",15-len(toplam)) & toplam & repeatString(" ",15) & repeatString(".",188);
			file_content[index_array] = "#trailer_#";
			index_array = index_array + 1;
			trailer = "90" & repeatString("0",15-len(kayit_sayisi)) & (kayit_sayisi+3) & repeatString(".",218);
			file_content[index_array] = "#trailer#";
		}
	</cfscript>
</cfif>

<cftry>
	<cfquery name="check" datasource="#dsn#">
		SELECT NICK_NAME FROM OUR_COMPANY WHERE COMP_ID = #session.ep.company_id#
	</cfquery>
	<cfif isdefined("attributes.bank_name") and attributes.bank_name eq 20>
		<cfset file_name = "FT_134_#dateformat(now(),'ddmmyyyy')##timeformat(now(),'HHMM')#_#check.nick_name#.txt">
	<cfelseif isdefined("attributes.source") and attributes.source eq 2>
		<cfif attributes.is_file_from_manuelpaper>
            <cfquery name="get_bank_" datasource="#dsn#">
                SELECT BANK_ID,BANK_NAME,BANK_CODE FROM SETUP_BANK_TYPES WHERE BANK_ID = #attributes.bank#
            </cfquery>   
            <cfset file_name = "#listfirst(session.ep.company_nick,' ')#FTB#get_bank_.bank_code##dateformat(now(),'yyyymmddhhmmss')#.txt">
        <cfelse>
        	<cfset file_name = "#listfirst(session.ep.company_nick,' ')#FTB#attributes.bank_code_##dateformat(now(),'yyyymmddhhmmss')#.txt">
        </cfif>
	<cfelse>
		<cfset file_name = "#CreateUUID()#.txt">
	</cfif>
	<cflock name="#CreateUUID()#" timeout="60">
		<cftransaction>
			<cfquery name="ADD_FILE_EXPORTS" datasource="#dsn2#" result="e_id">
				INSERT INTO
					FILE_EXPORTS
					(
						PROCESS_TYPE,
						FILE_NAME,
						FILE_CONTENT,
						TARGET_SYSTEM,
						IS_DBS,
						RECORD_DATE,
						RECORD_IP,
						RECORD_EMP
					)
					VALUES
					(
						-11,
						'#file_name#',
						<cfif isdefined("attributes.key_type")>'#Encrypt(ArraytoList(file_content,CRLF),attributes.key_type,"CFMX_COMPAT","Hex")#'<cfelse>'#ArraytoList(file_content,CRLF)#'</cfif>,
						<cfif attributes.source eq 2>#attributes.bank#<cfelse>#attributes.bank_name#</cfif>,
						<cfif isdefined("attributes.source") and attributes.source eq 2>1<cfelse>0</cfif>,
						#now()#,
						'#cgi.remote_addr#',
						#session.ep.userid#
					)
			</cfquery>
			<cfif isdefined("attributes.source") and attributes.source eq 2>
            	<cfif attributes.is_file_from_manuelpaper>
                	<cfset attributes.all_records = GET_PAYMENT_PLAN.recordcount>
                </cfif>
                <cfloop from="1" to="#attributes.all_records#" index="i">
                	<cfif attributes.is_file_from_manuelpaper>
                    	<cfset 'attributes.payment_row#i#' = GET_PAYMENT_PLAN.invoice_payment_plan_id[i]>
                        <cfset 'attributes.invoice_payment_plan_id#i#' = GET_PAYMENT_PLAN.invoice_payment_plan_id[i]>
                        <cfif GET_PAYMENT_PLAN.is_bank[i] eq 1 and GET_PAYMENT_PLAN.is_active[i] eq 1>
                        	<cfset 'attributes.pay_type#i#' = "G">
                        <cfelseif GET_PAYMENT_PLAN.is_bank[i] eq 0 and GET_PAYMENT_PLAN.is_active[i] eq 1>
                        	<cfset 'attributes.pay_type#i#' = "Y">
                        <cfelse>
                        	<cfset 'attributes.pay_type#i#' = "I">
                        </cfif>
                    </cfif>
                    <cfif isdefined("attributes.payment_row#i#")>
                        <cfif "deger_#i#" neq 0>
                            <cfquery name="upd_row" datasource="#dsn2#">
                                UPDATE #dsn3_alias#.INVOICE_PAYMENT_PLAN SET IS_BANK = 1, FILE_ID = #e_id.IDENTITYCOL# WHERE INVOICE_PAYMENT_PLAN_ID = #evaluate("attributes.invoice_payment_plan_id#i#")#
                            </cfquery>
                            <cfif (isdefined("attributes.pay_type#i#") and evaluate("attributes.pay_type#i#") eq 'I') or (isdefined("get_payment_plan") and get_payment_plan.is_active[i] eq 0)>
                                <cfquery name="upd_row_iptal" datasource="#dsn2#">
                                    UPDATE #dsn3_alias#.INVOICE_PAYMENT_PLAN SET IS_BANK_IPTAL = 1 WHERE INVOICE_PAYMENT_PLAN_ID = #evaluate("attributes.invoice_payment_plan_id#i#")#
                                </cfquery>
                            </cfif>
                        </cfif>
                    </cfif>
                </cfloop>
			</cfif>
		</cftransaction>
	</cflock>
    <script type="text/javascript">
    	alert("Belge Oluşturma İşlemi Tamamlandı!");
		wrk_opener_reload();
		window.close();
    </script>
	<cfcatch> <!---otomatik ödeme işlemlerinde belge kaydedilirken sorun olmuşsa,geri alınıcak bişey yoktur yeniden oluştulabilir,provizyon gibi değildir--->
		<script type="text/javascript">
            alert("Belge Oluşturma İşlemi Tamamlanamadı!");
            wrk_opener_reload();
            window.close();
        </script>
	</cfcatch>
</cftry>
