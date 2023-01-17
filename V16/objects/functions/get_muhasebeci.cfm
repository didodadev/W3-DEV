<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="yes">
<cffunction name="muhasebeci" returntype="numeric" output="false">
	<!---
	by : Admin
	notes : Muhasebe fişi keser...(Tahsil-Tediye-Mahsup)
			!!! TRANSACTION icinde kullanılmalıdır !!!Fonksiyon sorunsuz çalistiginda muhasebe fişi ID sini (true) döndürür.
	usage :
	muhasebeci (
		action_id:attributes.id,
		workcube_process_type:90,
		workcube_old_process_type:90, güncellemelerde mecburi alan ; güncellemede işlemin eski proses tipi
		workcube_process_cat:,
		account_card_type:13, tahsil-tediye veya mahsup card_type_no buna göre alinir ve arttirilir.
		islem_tarihi:'#attributes.PAYROLL_REVENUE_DATE#',
		borc_hesaplar:'100,',
		borc_tutarlar:'123000,',
		other_amount_borc : '120,100' , borc tutarların doviz karsılıklarını tutar
		alacak_hesaplar:'#GET_COMPANY_PERIOD(COMPANY_ID)#,',
		alacak_tutarlar:'#toplam#,',
		other_amount_alacak : '100,120', alacak tutarların doviz karsılıklarını tutar
		other_currency_borc : '#diger_doviz#', other_amount_borc tutarlarının doviz birimini gosterir
		other_currency_alacak : '#diger_doviz2#', other_amount_alacak tutarlarının doviz birimini gosterir
		fis_detay:'#detail#',
		fis_satir_detay: fis satır acıklamalarını gosteriyor, arguman a string veya 2 boyutlu bir array gonderilebilir. 
					string olarak gonderilisi: '12/12/2005 VADELİ ÇEK GİRİŞ İŞLEMİ',
					array tipinde veri gonderildiginde; array[1][xxx] borc satırı açıklamalarını, array[2][xxx]  alacak satırı acıklamalarını tutar.
		belge_no : form.belge_no,
		is_account_group : is_account_group , islem kategorisinden gelir
		action_currency_2 : 'USD', ikinci para birimini tutar
		currency_multiplier : '#kur_bilgisi#', sistem ikinci para birimi icin kur bilgisini tutar
		is_other_currency : 0 , eger 1 ise muh fisinin dovizli olarak gosterilecegini (islem dovizlerini), 0 ise gosterilmeyecegini (kaydedilseler bile) set eder
		wrk_id : '' ilgili islem icin kullanilan unique deger varsa o da verilebilir
		muhasebe_db : muhasebeci fonksiyonunu transaction içinde kullanılabilmesini saglar. transaction için dsn2'den farklı kullanılan datasource bu argumana gonderilmelidir.
		muhasebe_db_alias : muhasebe_db_alias argumanına deger gonderilmemelidir, muhasebe_db argumanı DSN2'den farklıysa muhasebe_db_alias set ediliyor...
		company_id : 4 ,  Muhasebe hareketi yazılan işlemin kurumsal uye id si tutulur
		consumer_id : 15,  Muhasebe hareketi yazılan işlemin bireysel uye id si tutulur
		employee_id :  Muhasebe hareketi yazılan işlemin calisan id si tutulur
		alacak_miktarlar :'1,20,5' , satıs faturalarından yapılan muhasebe hareketleri için fatura satırlarındaki urun miktarlarını gosterir
		borc_miktarlar : '1,20,5',  alış faturalarından yapılan muhasebe hareketleri için fatura satırlarındaki urun miktarlarını gosterir
		alacak_birim_tutar : '15,25,45', satıs faturalarından yapılan muhasebe hareketleri için fatura satırlarındaki urun fiyatını gosterir
		borc_birim_tutar : '15,25,45' alış faturalarından yapılan muhasebe hareketleri için fatura satırlarındaki urun fiyatını gosterir
		is_abort : işlem kesilsinmi yoksa devam etsinmi
		);		
	revisions :20040227, 20051020, OZDEN20051101, OZDEN20051221 ,OZDEN20051230, 20060101, 20060125, OZDEN20060406, OZDEN20060421, OZDEN20060628, OZDEN20060907, OZDEN20060926, OZDEN20070411, OZDEN20070624
	UFRS_CODE eklendi OZDEN20071212
	is_abort  eklendi TolgaS 20080221
	yuvarlama bölümü eklendi OZDEN20080304
	--->
	<cfargument name="action_id" required="yes" type="numeric">
	<cfargument name="action_currency" required="yes" default="#session.ep.money#">
	<cfargument name="action_currency_2" type="string" default="#session.ep.money2#">
	<cfargument name="currency_multiplier" type="string" default="">
	<cfargument name="workcube_process_type" required="yes" type="numeric">
	<cfargument name="workcube_old_process_type" type="numeric">
	<cfargument name="account_card_type" required="yes" type="numeric">
	<cfargument name="account_card_catid" required="yes" type="numeric" default="0"> <!--- muhasebe fiş türünün process_cat_id si--->
	<cfargument name="islem_tarihi" required="yes" type="date">
	<cfargument name="borc_hesaplar" required="yes" type="string">
	<cfargument name="borc_tutarlar" required="yes" type="string">
	<cfargument name="alacak_hesaplar" required="yes" type="string">
	<cfargument name="alacak_tutarlar" required="yes" type="string">
	<cfargument name="other_amount_borc" type="string" default="">	
	<cfargument name="other_amount_alacak" type="string" default="">	
	<cfargument name="other_currency_borc" type="string" default="">
	<cfargument name="other_currency_alacak" type="string" default="">
	<cfargument name="belge_no" type="string" default="">
	<cfargument name="fis_detay" type="string">
	<cfargument name="fis_satir_detay" default="">
	<cfargument name="wrk_id" type="string" default="">
	<cfargument name="muhasebe_db" type="string" default="#dsn2#">
	<cfargument name="muhasebe_db_alias" type="string" default="">
	<cfargument name="company_id" default="">
	<cfargument name="consumer_id" default="">
	<cfargument name="employee_id" default="">
	<cfargument name="alacak_miktarlar" default="">
	<cfargument name="borc_miktarlar" default="">
	<cfargument name="alacak_birim_tutar" default="">
	<cfargument name="borc_birim_tutar" default="">
	<cfargument name="is_account_group" type="numeric" default="0">
	<cfargument name="is_other_currency" type="numeric" default="0"><!--- 0: muhasebe fisi dovizli goruntulenMEsin, 1: goruntulensin --->
	<cfargument name="base_period_year_start" default="">
	<cfargument name="base_period_year_finish" default="">
	<cfargument name="action_table" type="string"> <!--- payrollda cek bazlı muhasebe islemi yapılabilmesi icin eklendi --->
	<cfargument name="from_branch_id">
	<cfargument name="to_branch_id">
	<cfargument name="acc_department_id">
	<cfargument name="acc_project_id">
	<cfargument name="acc_project_list_alacak" type="string" default="">
	<cfargument name="acc_project_list_borc" type="string" default="">
	<cfargument name="acc_branch_list_alacak" type="string" default="">
	<cfargument name="acc_branch_list_borc" type="string" default="">
	<cfargument name="is_abort" type="numeric" default="1">
	<cfargument name="dept_round_account" default=""> <!---muhasebe fisi borc-alacak toplamları arasındaki BORC FARKI icin kullanılacak yuvarlama hesabı --->
	<cfargument name="claim_round_account" default=""> <!---muhasebe fisi borc-alacak toplamları arasındaki ALACAK FARKI icin kullanılacak yuvarlama hesabı --->
	<cfargument name="max_round_amount" default="0"> <!---borc-alacak toplamları arasında yuvarlama yapılabilecek max. fark --->
	<cfargument name="round_row_detail" default=""><!--- yuvarlama satırı acıklama bilgisi, gönderilmezse yuvarlama satırına fis_detay bilgisi yazılır --->
	<cfargument name="workcube_process_cat" default=""> <!--- islem kategorisi process_cat_id --->
    <cfargument name="action_row_id" default="">
    <cfargument name="due_date" default="">
    <cfargument name="is_cancel">
    <cfargument name="document_type" default="">
    <cfargument name="payment_method" default="">
    <cfif isDefined('session.ep.userid')>
    	<cfif not len(arguments.base_period_year_start)>
        	<cfset arguments.base_period_year_start = year(session.ep.period_start_date)>
        </cfif>
    	<cfif not len(arguments.base_period_year_finish)>
        	<cfset arguments.base_period_year_finish = year(session.ep.period_finish_date)>
        </cfif>   
	</cfif>
    <cfscript>
		if(arguments.muhasebe_db_alias == '' and arguments.muhasebe_db is not '#dsn2#')
		{
			if(arguments.muhasebe_db is '#dsn#' or arguments.muhasebe_db is '#dsn1#' or arguments.muhasebe_db is '#dsn3#')		
				arguments.muhasebe_db_alias = '#dsn2_alias#.';
			else 
				arguments.muhasebe_db_alias = '#muhasebe_db#.';
		}
		else
		{
			arguments.muhasebe_db_alias = '#arguments.muhasebe_db_alias#.';
		}
	</cfscript>
    
	<!--- e-defter islem kontrolu FA --->
    <cfif isDefined('session.ep.our_company_info.is_edefter') and session.ep.our_company_info.is_edefter eq 1>
    	<cfif isDefined('arguments.workcube_old_process_type') and len(arguments.workcube_old_process_type)>
            <cfquery name="GET_CARD_ID" datasource="#arguments.muhasebe_db#">
                 SELECT
                    ACTION_DATE
                 FROM
                    #arguments.muhasebe_db_alias#ACCOUNT_CARD
                 WHERE
                    ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
                    AND ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.workcube_old_process_type#">
                    <cfif isDefined('arguments.action_table') and len(arguments.action_table)> 
                        AND ACTION_TABLE = '#arguments.action_table#'
                    </cfif>
                    <cfif len(arguments.action_row_id)> 
                        AND ACTION_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_row_id#">
                    </cfif>
            </cfquery>
            <cfif GET_CARD_ID.RECORDCOUNT>
            	<cfset netbook_date = GET_CARD_ID.ACTION_DATE>
            <cfelse>
            	<cfset netbook_date = ''>
            </cfif>
        <cfelse>
        	<cfset netbook_date = ''>
        </cfif>
        <cfstoredproc procedure="GET_NETBOOK" datasource="#arguments.muhasebe_db#">
            <cfprocparam cfsqltype="cf_sql_timestamp" value="#netbook_date#" null="#not(len(netbook_date))#">
            <cfprocparam cfsqltype="cf_sql_timestamp" value="#arguments.islem_tarihi#">
            <cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.muhasebe_db_alias#">
            <cfprocresult name="getNetbook">
        </cfstoredproc>
        <cfscript>
            if(getNetbook.recordcount)
                abort('<font color="red">Muhasebeci : İşlemi yapamazsınız. İşlem tarihine ait e-defter bulunmaktadır.</font>');
        </cfscript>
    </cfif>
	<!--- e-defter islem kontrolu FA --->
    
	<cfif len(arguments.account_card_type) and arguments.account_card_catid eq 0 or not len(arguments.account_card_catid)>
		<cfquery name="CONTROL_ACC_CARD_PROCESS_" datasource="#arguments.muhasebe_db#"> <!---fiş türüne ait default olarak tanımlanmış işlem kategorisi bulunuyor --->
			SELECT
				PROCESS_CAT_ID,PROCESS_CAT,
				PROCESS_TYPE,DISPLAY_FILE_NAME,
				DISPLAY_FILE_FROM_TEMPLATE
			FROM
				<cfif isdefined('dsn3_alias')>#dsn3_alias#<cfelse>#caller.dsn3_alias#</cfif>.SETUP_PROCESS_CAT <!--- işlem kategorilerinin action fileların tanımlı olmama durumu için eklendi --->
			WHERE
				PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.account_card_type#">
				AND IS_DEFAULT=1		
		</cfquery>
		<cfif control_acc_card_process_.recordcount eq 0>
			<cfscript>
				if(arguments.account_card_type eq 13)
					alert_card_type_name='Mahsup';
				else if(arguments.account_card_type eq 12)
					alert_card_type_name='Tediye';
				else if(arguments.account_card_type eq 11)
					alert_card_type_name='Tahsil';
				abort('Muhasebeci: Standart #alert_card_type_name# Fişi İşlem Kategorisi Tanımlı Değil!<br/>İşlem Kategorileri Bölümünde Fiş Tanımlarınızı Yapınız!');
			</cfscript>
		<cfelse>
			<cfset arguments.account_card_catid=control_acc_card_process_.process_cat_id>
		</cfif>
	</cfif>
	<cfif isdefined("session.pp")>
		<cfset session_base = evaluate('session.pp')>
	<cfelseif isdefined("session.ep")>
		<cfset session_base = evaluate('session.ep')>
	<cfelseif isdefined('session.ww')>
		<cfset session_base = evaluate('session.ww')>
	</cfif>
	<cfscript>
		if(((isDefined('arguments.base_period_year_start') and year(arguments.islem_tarihi) lt arguments.base_period_year_start) or (isDefined('arguments.base_period_year_finish') and len(arguments.base_period_year_finish) and year(arguments.islem_tarihi) gt arguments.base_period_year_finish)) and workcube_process_type neq 130 and workcube_process_type neq 161)
			abort('Muhasebeci : İşlem Tarihi Döneme Uygun Değil.');
		if(len(arguments.other_amount_borc) and listlen(arguments.other_amount_borc,',') neq listlen(arguments.borc_tutarlar,',') )
			abort('Muhasebeci : Dövizli Borç Listesi Eksik.');
		if(len(arguments.other_amount_alacak) and listlen(arguments.other_amount_alacak,',') neq listlen(arguments.alacak_tutarlar,',') )
			abort('Muhasebeci : Dövizli Alacak Listesi Eksik.');			
		if(len(arguments.action_currency_2) and (not len(arguments.currency_multiplier))) {
			get_currency_rate = cfquery(datasource:"#arguments.muhasebe_db#", sqlstring:"SELECT (RATE2/RATE1) RATE FROM #arguments.muhasebe_db_alias#SETUP_MONEY WHERE MONEY ='#arguments.action_currency_2#'");
			if(get_currency_rate.recordcount) arguments.currency_multiplier = get_currency_rate.RATE;
		}
		muh_query = QueryNew("BA,ACCOUNT_CODE,AMOUNT,OTHER_AMOUNT,OTHER_CURRENCY,DETAIL,QUANTITY,PRICE,ACC_PROJECT_ID,ACC_BRANCH_ID","Bit,VarChar,Double,Double,Varchar,Varchar,Double,Double,Double,Double");
		muh_query_row = 0;
		borc_hesaplar_total = 0;
		alacak_hesaplar_total = 0;
		other_borc_hesaplar_total = 0;
		other_alacak_hesaplar_total = 0;
		for(i_index=1;i_index lte listlen(arguments.borc_hesaplar,',');i_index=i_index+1){
			if((wrk_round(listgetat(arguments.borc_tutarlar,i_index,','),4) gt 0 and len(listgetat(arguments.borc_hesaplar,i_index,',')) gt 0) or (listlen(arguments.other_amount_borc) and wrk_round(listgetat(arguments.other_amount_borc,i_index,','),4) gt 0 and len(listgetat(arguments.borc_hesaplar,i_index,',')) gt 0))
				{
				muh_query_row = muh_query_row + 1;
				QueryAddRow(muh_query,1);
				QuerySetCell(muh_query,"BA",0,muh_query_row);
				QuerySetCell(muh_query,"ACCOUNT_CODE",listgetat(arguments.borc_hesaplar,i_index,','),muh_query_row);
				{
					QuerySetCell(muh_query,"AMOUNT",listgetat(arguments.borc_tutarlar,i_index,','),muh_query_row);
					if(len(arguments.other_amount_borc)){
						QuerySetCell(muh_query,"OTHER_AMOUNT",listgetat(arguments.other_amount_borc,i_index,','),muh_query_row);
						QuerySetCell(muh_query,"OTHER_CURRENCY",listgetat(arguments.other_currency_borc,i_index,','),muh_query_row);
						}
				}
				if(IsArray(arguments.fis_satir_detay) and Arraylen(arguments.fis_satir_detay[1]) gte i_index)
				{
					if(len(arguments.belge_no))
						arguments.fis_satir_detay[1][i_index] = replace(arguments.fis_satir_detay[1][i_index],arguments.belge_no,'','all');
					if(len(arguments.belge_no) and not findnocase(arguments.belge_no,arguments.fis_satir_detay[1][i_index]))
					{
						arguments.fis_satir_detay[1][i_index] =  arguments.belge_no&"-"&arguments.fis_satir_detay[1][i_index] ;
						arguments.fis_satir_detay[1][i_index] = replace(arguments.fis_satir_detay[1][i_index],'- -','-');
					}
					QuerySetCell(muh_query,"DETAIL",arguments.fis_satir_detay[1][i_index],muh_query_row);
				}
				else if (not IsArray(arguments.fis_satir_detay))
				{
					if(len(arguments.belge_no))
						arguments.fis_satir_detay = replace(arguments.fis_satir_detay,"#arguments.belge_no# - ",'','all');
					if(len(arguments.belge_no) and not findnocase(arguments.belge_no,arguments.fis_satir_detay))
					{
						arguments.fis_satir_detay =  arguments.belge_no&"-"&arguments.fis_satir_detay;
						arguments.fis_satir_detay = replace(arguments.fis_satir_detay,'- -','-');
					}
					QuerySetCell(muh_query,"DETAIL",arguments.fis_satir_detay,muh_query_row);
				}
				if(IsArray(arguments.borc_miktarlar) and Arraylen(arguments.borc_miktarlar) gte i_index)
					QuerySetCell(muh_query,"QUANTITY",arguments.borc_miktarlar[i_index],muh_query_row);
				else if (not IsArray(arguments.borc_miktarlar))
					QuerySetCell(muh_query,"QUANTITY",arguments.borc_miktarlar,muh_query_row);
				if(IsArray(arguments.borc_birim_tutar) and Arraylen(arguments.borc_birim_tutar) gte i_index)
					QuerySetCell(muh_query,"PRICE",arguments.borc_birim_tutar[i_index],muh_query_row);
				else if (not IsArray(arguments.borc_birim_tutar))
					QuerySetCell(muh_query,"PRICE",arguments.borc_birim_tutar,muh_query_row);
				if(listlen(arguments.acc_project_list_borc))
					QuerySetCell(muh_query,"ACC_PROJECT_ID",listgetat(arguments.acc_project_list_borc,i_index,','),muh_query_row);
				else if (not listlen(arguments.acc_project_list_borc))
					QuerySetCell(muh_query,"ACC_PROJECT_ID",0,muh_query_row);
				if(len(arguments.acc_branch_list_borc))
					QuerySetCell(muh_query,"ACC_BRANCH_ID",listgetat(arguments.acc_branch_list_borc,i_index,','),muh_query_row);
				else
					QuerySetCell(muh_query,"ACC_BRANCH_ID",listLast(session.ep.user_location,'-'),muh_query_row);
				}
		}
		for(i_index=1;i_index lte listlen(arguments.alacak_hesaplar,',');i_index=i_index+1){
			if((wrk_round(listgetat(arguments.alacak_tutarlar,i_index,','),4) gt 0 and len(listgetat(arguments.alacak_hesaplar,i_index,',')) gt 0) or (listlen(arguments.other_amount_alacak) and wrk_round(listgetat(arguments.other_amount_alacak,i_index,','),4) gt 0 and len(listgetat(arguments.alacak_hesaplar,i_index,',')) gt 0))
				{
				muh_query_row = muh_query_row + 1;
				QueryAddRow(muh_query,1);
				QuerySetCell(muh_query,"BA",1,muh_query_row);
				QuerySetCell(muh_query,"ACCOUNT_CODE",listgetat(arguments.alacak_hesaplar,i_index,','),muh_query_row);
				{
					QuerySetCell(muh_query,"AMOUNT",listgetat(arguments.alacak_tutarlar,i_index,','),muh_query_row);
					if(len(arguments.other_amount_alacak)){
						QuerySetCell(muh_query,"OTHER_AMOUNT",listgetat(arguments.other_amount_alacak,i_index,','),muh_query_row);
						QuerySetCell(muh_query,"OTHER_CURRENCY",listgetat(arguments.other_currency_alacak,i_index,','),muh_query_row);
						}	
				}
				if(IsArray(arguments.fis_satir_detay) and Arraylen(arguments.fis_satir_detay[2]) gte i_index)
				{
					if(len(arguments.belge_no) and not findnocase(arguments.belge_no,arguments.fis_satir_detay[2][i_index]))
					{
						arguments.fis_satir_detay[2][i_index] =  arguments.belge_no&"-"&arguments.fis_satir_detay[2][i_index] ;
						arguments.fis_satir_detay[2][i_index] = replace(arguments.fis_satir_detay[2][i_index],'- -','-');
					}
					QuerySetCell(muh_query,"DETAIL",arguments.fis_satir_detay[2][i_index],muh_query_row);
				}
				else if (not IsArray(arguments.fis_satir_detay))
				{
					if(len(arguments.belge_no) and not findnocase(arguments.belge_no,arguments.fis_satir_detay))
					{
						arguments.fis_satir_detay =  arguments.belge_no&"-"&arguments.fis_satir_detay ;
						arguments.fis_satir_detay = replace(arguments.fis_satir_detay,'- -','-');
					}
					QuerySetCell(muh_query,"DETAIL",arguments.fis_satir_detay,muh_query_row);
				}
				if(IsArray(arguments.alacak_miktarlar) and Arraylen(arguments.alacak_miktarlar) gte i_index)
					QuerySetCell(muh_query,"QUANTITY",arguments.alacak_miktarlar[i_index],muh_query_row);
				else if (not IsArray(arguments.borc_miktarlar))
					QuerySetCell(muh_query,"QUANTITY",arguments.borc_miktarlar,muh_query_row);
				if(IsArray(arguments.alacak_birim_tutar) and Arraylen(arguments.alacak_birim_tutar) gte i_index)
					QuerySetCell(muh_query,"PRICE",arguments.alacak_birim_tutar[i_index],muh_query_row);
				else if (not IsArray(arguments.alacak_birim_tutar))
					QuerySetCell(muh_query,"PRICE",arguments.alacak_birim_tutar,muh_query_row);
				if(listlen(arguments.acc_project_list_alacak))
					QuerySetCell(muh_query,"ACC_PROJECT_ID",listgetat(arguments.acc_project_list_alacak,i_index,','),muh_query_row);
				else if (not listlen(arguments.acc_project_list_alacak))
					QuerySetCell(muh_query,"ACC_PROJECT_ID",0,muh_query_row);
				if(len(arguments.acc_branch_list_alacak))
					QuerySetCell(muh_query,"ACC_BRANCH_ID",listgetat(arguments.acc_branch_list_alacak,i_index,','),muh_query_row);
				else
					QuerySetCell(muh_query,"ACC_BRANCH_ID",listLast(session.ep.user_location,'-'),muh_query_row);
				}
		}
		/*20040112 alttaki iki satirda fatura para biriminin kuruş durumuna göre round işlemi yapılmalı yoksa kuruş kaçar*/
		//alacak_hesaplar_total = wrk_round(alacak_hesaplar_total,2);
		//borc_hesaplar_total = wrk_round(borc_hesaplar_total,2);
		if( arguments.is_account_group )
		{
			if(not len(session.ep.our_company_info.is_project_group) or session.ep.our_company_info.is_project_group eq 1)//şirket akış parametrelerinde proje bazında grupla seçili ise
				muh_query = cfquery(dbtype:'query',datasource:"",sqlstring:"SELECT SUM(OTHER_AMOUNT) OTHER_AMOUNT,SUM(AMOUNT) AMOUNT,ACC_PROJECT_ID, BA, ACCOUNT_CODE, OTHER_CURRENCY,DETAIL,SUM(QUANTITY) QUANTITY, SUM(PRICE) PRICE FROM muh_query GROUP BY ACC_PROJECT_ID,BA, ACCOUNT_CODE, OTHER_CURRENCY,DETAIL ORDER BY BA");
			else
				muh_query = cfquery(dbtype:'query',datasource:"",sqlstring:"SELECT SUM(OTHER_AMOUNT) OTHER_AMOUNT,SUM(AMOUNT) AMOUNT,0 ACC_PROJECT_ID, BA, ACCOUNT_CODE, OTHER_CURRENCY,DETAIL,SUM(QUANTITY) QUANTITY, SUM(PRICE) PRICE FROM muh_query GROUP BY BA, ACCOUNT_CODE, OTHER_CURRENCY,DETAIL ORDER BY BA");
		}
		is_ifrs = 0;
		if(isDefined("session.ep") and len(session.ep.our_company_info.is_ifrs eq 1))
			is_ifrs = 1;
		else if(isDefined("session.pp.userid") and len(session.pp.our_company_info.is_ifrs eq 1))
			is_ifrs = 1;
		else if(isDefined("session.ww.userid") and len(session.ww.our_company_info.is_ifrs eq 1))
			is_ifrs = 1;
			
		if(len(arguments.belge_no) and not findnocase(arguments.belge_no,arguments.fis_detay))
			arguments.fis_detay =  arguments.belge_no&" #getLang('main',2655)# "&arguments.fis_detay ;
		for(cnt_i=1;cnt_i lte muh_query.recordcount;cnt_i=cnt_i+1) //borc alacak toplamı bulunup, fiste fark var mı bakılır
		{
			if(muh_query.BA[cnt_i] eq 1)
			{
				alacak_hesaplar_total = alacak_hesaplar_total + wrk_round(muh_query.AMOUNT[cnt_i]);
				if(len(muh_query.OTHER_AMOUNT[cnt_i]))
					other_alacak_hesaplar_total = other_alacak_hesaplar_total + wrk_round(muh_query.OTHER_AMOUNT[cnt_i]);
			}
			else if (muh_query.BA[cnt_i] eq 0)
			{
				borc_hesaplar_total = borc_hesaplar_total + wrk_round(muh_query.AMOUNT[cnt_i]);
				if(len(muh_query.OTHER_AMOUNT[cnt_i]))
					other_borc_hesaplar_total = other_borc_hesaplar_total + wrk_round(muh_query.OTHER_AMOUNT[cnt_i]);
			}
		}
		
		if(wrk_round(alacak_hesaplar_total) is not wrk_round(borc_hesaplar_total) or wrk_round((alacak_hesaplar_total-borc_hesaplar_total),2) neq 0) // borc-alacak tutmayan fisler icin yuvarlama yapılıyor
		{
			temp_fark = round((alacak_hesaplar_total-borc_hesaplar_total)*100);
			
			if(temp_fark gte (arguments.max_round_amount*-100) and temp_fark lt 0 and len(arguments.claim_round_account))
			{// fark alacaklilara eklenmeli, borc bakiye gelmis,muhasebeci querysine fark satırı ekleniyor
				muh_query_row = muh_query.recordcount + 1;
				QueryAddRow(muh_query,1);
				QuerySetCell(muh_query,"BA",1,muh_query_row);
				QuerySetCell(muh_query,"ACCOUNT_CODE",claim_round_account,muh_query_row);
				QuerySetCell(muh_query,"AMOUNT",abs(temp_fark/100),muh_query_row);
				QuerySetCell(muh_query,"OTHER_AMOUNT",abs(temp_fark/100),muh_query_row);
				QuerySetCell(muh_query,"OTHER_CURRENCY",session_base.money,muh_query_row);
				QuerySetCell(muh_query,"DETAIL",arguments.fis_detay,muh_query_row);
				QuerySetCell(muh_query,"ACC_PROJECT_ID",0,muh_query_row);
			}
			else if(temp_fark lte (arguments.max_round_amount*100) and temp_fark gt 0 and len(arguments.dept_round_account))
			{//fark borclulara eklenmeli, alacak bakiye gelmis,muhasebeci querysine fark satırı ekleniyor 
				muh_query_row = muh_query.recordcount + 1;
				QueryAddRow(muh_query,1);
				QuerySetCell(muh_query,"BA",0,muh_query_row);
				QuerySetCell(muh_query,"ACCOUNT_CODE",dept_round_account,muh_query_row);
				QuerySetCell(muh_query,"AMOUNT",abs(temp_fark/100),muh_query_row);
				QuerySetCell(muh_query,"OTHER_AMOUNT",abs(temp_fark/100),muh_query_row);
				QuerySetCell(muh_query,"OTHER_CURRENCY",session_base.money,muh_query_row);
				QuerySetCell(muh_query,"DETAIL",arguments.fis_detay,muh_query_row);
				QuerySetCell(muh_query,"ACC_PROJECT_ID",0,muh_query_row);
			}
			//yuvarlama satırı da eklenlendikten sonra fark olup olmadıgı yeniden kontrol ediliyor
			alacak_hesaplar_total =0;
			borc_hesaplar_total = 0;
			other_alacak_hesaplar_total =0;
			other_borc_hesaplar_total = 0;
			for(cnt_k=1;cnt_k lte muh_query.recordcount;cnt_k=cnt_k+1)
			{
				if(muh_query.BA[cnt_k] eq 1)
				{
					alacak_hesaplar_total = alacak_hesaplar_total + wrk_round(muh_query.AMOUNT[cnt_k]);
					if(len(muh_query.OTHER_AMOUNT[cnt_k]))
						other_alacak_hesaplar_total = other_alacak_hesaplar_total + wrk_round(muh_query.OTHER_AMOUNT[cnt_k]);
				}
				else if (muh_query.BA[cnt_k] eq 0)
				{
					borc_hesaplar_total = borc_hesaplar_total + wrk_round(muh_query.AMOUNT[cnt_k]);
					if(len(muh_query.OTHER_AMOUNT[cnt_k]))
					other_borc_hesaplar_total = other_borc_hesaplar_total + wrk_round(muh_query.OTHER_AMOUNT[cnt_k]);
				}
			}
		}
	</cfscript>
	<cfif (alacak_hesaplar_total eq 0) and (borc_hesaplar_total eq 0) and (other_borc_hesaplar_total eq 0) and (other_alacak_hesaplar_total eq 0)><!---Muhasebe Fisi Toplam Tutari Yoksa Hareket Yazmaz--->
		<cfif isDefined('arguments.workcube_old_process_type') and len(arguments.workcube_old_process_type)>
			<cfscript>muhasebe_sil(action_id:arguments.action_id, process_type:arguments.workcube_old_process_type, muhasebe_db:arguments.muhasebe_db);</cfscript>
        </cfif>
		<cfreturn 0>
	</cfif>
	<cfif wrk_round((alacak_hesaplar_total-borc_hesaplar_total),2) neq 0 or (arguments.workcube_process_type eq 111 and (listlen(arguments.alacak_tutarlar) neq listlen(arguments.alacak_hesaplar) or listlen(arguments.borc_tutarlar) neq listlen(arguments.borc_hesaplar)))>
	<!--- yuvarlama hesabı henuz alerta dahil edilmedi --->
		<cfif workcube_mode>
			<cfif arguments.is_abort>
				<script type="text/javascript">
				var alert_str='Muhasebe Fişi Borç-Alacak Bakiyesi Eşit Değil!';
				<cfoutput>
					alert_str = alert_str + '\nborc_hesaplar:\n';
					<cfloop from="1" to="#listlen(arguments.borc_hesaplar,',')#" index="i">
						alert_str = alert_str + '<cfoutput>#listgetat(arguments.borc_hesaplar,i,',')#=#TLFormat(listgetat(arguments.borc_tutarlar,i,','))#  <cfif (i mod 4) eq 0>\n<cfelse> ; </cfif></cfoutput>';
					</cfloop>
					alert_str = alert_str + 'borc_hesaplar_total = #TLFormat(borc_hesaplar_total)#\n';
					alert_str = alert_str + '\nalacak_hesaplar:\n';
					<cfloop from="1" to="#listlen(arguments.alacak_hesaplar,',')#" index="i">
						alert_str = alert_str + '<cfoutput>#listgetat(arguments.alacak_hesaplar,i,',')#=#TLFormat(listgetat(arguments.alacak_tutarlar,i,','))#  <cfif (i mod 4) eq 0>\n<cfelse> ; </cfif></cfoutput>';
					</cfloop>
					alert_str = alert_str + 'alacak_hesaplar_total = #TLFormat(alacak_hesaplar_total)#\n\n';
					alert_str = alert_str + 'Fark = #TLFormat(borc_hesaplar_total-alacak_hesaplar_total)# <cfif borc_hesaplar_total gt alacak_hesaplar_total>(B)<cfelse>(A)</cfif>';
				</cfoutput>
					alert(alert_str);
					window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
				</script>
				<cfabort>
			<cfelse>
				<cfif arguments.workcube_process_type eq 111 and (listlen(arguments.alacak_tutarlar) neq listlen(arguments.alacak_hesaplar) or listlen(arguments.borc_tutarlar) neq listlen(arguments.borc_hesaplar))>
					<b>! Borç-Alacak Hesaplarında Eksik Tanımlamalar Mevcut!</b><br/>
				<cfelse>
					<b>! Muhasebe Fişi Borç-Alacak Bakiyesi Eşit Değil!</b><br/>
					<b>Fark = <cfoutput>#TLFormat(borc_hesaplar_total-alacak_hesaplar_total)#</cfoutput> <cfif borc_hesaplar_total gt alacak_hesaplar_total>(B)<cfelse>(A)</cfif></b><br/>
				</cfif>
				<cfabort>
			</cfif>
		<cfelse>
			<cfif arguments.workcube_process_type eq 111 and (listlen(arguments.alacak_tutarlar) neq listlen(arguments.alacak_hesaplar) or listlen(arguments.borc_tutarlar) neq listlen(arguments.borc_hesaplar))>
				<b>! Borç-Alacak Hesaplarında Eksik Tanımlamalar Mevcut!</b><br/>
			<cfelse>
				<!--- baskette kur sorunlarına sebep oldugundan acıklama yukardaki gibi degistirildi, bu bölüm sadece development modda calısıyor --->
				<b>!Muhasebe Fişi Borç-Alacak Bakiyesi Eşit Değil!</b><br/>
				<cfoutput>
					borc_hesaplar:<br/>
					<cfloop from="1" to="#listlen(arguments.borc_hesaplar,',')#" index="i">
						#listgetat(arguments.borc_hesaplar,i,',')#=#TLFormat(listgetat(arguments.borc_tutarlar,i,','))#<br/>
					</cfloop>
					borc_hesaplar_total = #TLFormat(borc_hesaplar_total)#<br/>
					alacak_hesaplar:<br/>
					<cfloop from="1" to="#listlen(arguments.alacak_hesaplar,',')#" index="i">
						#listgetat(arguments.alacak_hesaplar,i,',')#=#TLFormat(listgetat(arguments.alacak_tutarlar,i,','))#<br/>
					</cfloop>
					alacak_hesaplar_total = #TLFormat(alacak_hesaplar_total)#<br/><br/>
					<b>Fark = #TLFormat(borc_hesaplar_total-alacak_hesaplar_total)# <cfif borc_hesaplar_total gt alacak_hesaplar_total>(B)<cfelse>(A)</cfif></b>
				</cfoutput>
			</cfif>
			<cfabort>
		</cfif>
	</cfif>
	<cfif isDefined('arguments.workcube_old_process_type') and len(arguments.workcube_old_process_type)>
		<cfquery name="GET_CARD_ID" datasource="#arguments.muhasebe_db#">
			 SELECT
				*
			 FROM
				#arguments.muhasebe_db_alias#ACCOUNT_CARD
			 WHERE
				ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
				AND ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.workcube_old_process_type#">
                AND ISNULL(IS_CANCEL,0)=0
				<cfif isDefined('arguments.action_table') and len(arguments.action_table)> 
					AND ACTION_TABLE = '#arguments.action_table#'
				</cfif>
                <cfif len(arguments.action_row_id)> 
					AND ACTION_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_row_id#">
				</cfif>
		</cfquery>
		<cfif GET_CARD_ID.RECORDCOUNT>
			<cfquery name="ADD_ACCOUNT_CARD_HISTORY" datasource="#arguments.muhasebe_db#">
				INSERT INTO
					#arguments.muhasebe_db_alias#ACCOUNT_CARD_HISTORY
					(
						CARD_ID,
						WRK_ID,
						ACTION_ID,
						IS_ACCOUNT,
						BILL_NO,
						CARD_DETAIL,
						CARD_TYPE,
						CARD_CAT_ID,
						CARD_TYPE_NO,
						ACTION_TYPE,
						ACTION_CAT_ID,
						ACTION_DATE,
						ACTION_TABLE,
						PAPER_NO,
						ACC_COMPANY_ID,
						ACC_CONSUMER_ID,
						ACC_EMPLOYEE_ID,
						IS_OTHER_CURRENCY,
						RECORD_EMP_OLD,
						RECORD_PAR_OLD,
						RECORD_CONS_OLD,
						RECORD_IP_OLD,
						RECORD_DATE_OLD,
						<cfif isDefined("session.ep.userid")>
							RECORD_EMP,
						<cfelseif isDefined("session.pp.userid")>
							RECORD_PAR,
						<cfelseif isDefined("session.ww.userid")>
							RECORD_CONS,
						</cfif>
						RECORD_IP,
						RECORD_DATE,
                        ACTION_ROW_ID,
                        DUE_DATE,
                        CARD_DOCUMENT_TYPE,
                        CARD_PAYMENT_METHOD
					)
				VALUES
					(
						#GET_CARD_ID.CARD_ID#,
						<cfif len(GET_CARD_ID.WRK_ID)>'#GET_CARD_ID.WRK_ID#'<cfelse>NULL</cfif>,
						<cfif len(GET_CARD_ID.ACTION_ID)>#GET_CARD_ID.ACTION_ID#<cfelse>NULL</cfif>,
						<cfif len(GET_CARD_ID.IS_ACCOUNT)>#GET_CARD_ID.IS_ACCOUNT#<cfelse>NULL</cfif>,
						<cfif len(GET_CARD_ID.BILL_NO)>#GET_CARD_ID.BILL_NO#<cfelse>NULL</cfif>,
						<cfif len(GET_CARD_ID.CARD_DETAIL)>#sql_unicode()#'#GET_CARD_ID.CARD_DETAIL#'<cfelse>NULL</cfif>,
						<cfif len(GET_CARD_ID.CARD_TYPE)>#GET_CARD_ID.CARD_TYPE#<cfelse>NULL</cfif>,
						<cfif len(GET_CARD_ID.CARD_CAT_ID)>#GET_CARD_ID.CARD_CAT_ID#<cfelse>NULL</cfif>,
						<cfif len(GET_CARD_ID.CARD_TYPE_NO)>#GET_CARD_ID.CARD_TYPE_NO#<cfelse>NULL</cfif>,
						<cfif len(GET_CARD_ID.ACTION_TYPE)>#GET_CARD_ID.ACTION_TYPE#<cfelse>NULL</cfif>,
						<cfif len(GET_CARD_ID.ACTION_CAT_ID)>#GET_CARD_ID.ACTION_CAT_ID#<cfelse>NULL</cfif>,
						<cfif len(GET_CARD_ID.ACTION_DATE)>#CreateODBCDateTime(GET_CARD_ID.ACTION_DATE)#<cfelse>NULL</cfif>,
						<cfif len(GET_CARD_ID.ACTION_TABLE)>'#GET_CARD_ID.ACTION_TABLE#'<cfelse>NULL</cfif>,
						<cfif len(GET_CARD_ID.PAPER_NO)>'#GET_CARD_ID.PAPER_NO#'<cfelse>NULL</cfif>,
						<cfif len(GET_CARD_ID.ACC_COMPANY_ID)>#GET_CARD_ID.ACC_COMPANY_ID#<cfelse>NULL</cfif>,
						<cfif len(GET_CARD_ID.ACC_CONSUMER_ID)>#GET_CARD_ID.ACC_CONSUMER_ID#<cfelse>NULL</cfif>,
						<cfif len(GET_CARD_ID.ACC_EMPLOYEE_ID)>#GET_CARD_ID.ACC_EMPLOYEE_ID#<cfelse>NULL</cfif>,
						<cfif len(GET_CARD_ID.IS_OTHER_CURRENCY)>#GET_CARD_ID.IS_OTHER_CURRENCY#<cfelse>NULL</cfif>,
						<cfif len(GET_CARD_ID.RECORD_EMP)>#GET_CARD_ID.RECORD_EMP#<cfelse>NULL</cfif>,
						<cfif len(GET_CARD_ID.RECORD_PAR)>#GET_CARD_ID.RECORD_PAR#<cfelse>NULL</cfif>,
						<cfif len(GET_CARD_ID.RECORD_CONS)>#GET_CARD_ID.RECORD_CONS#<cfelse>NULL</cfif>,
						<cfif len(GET_CARD_ID.RECORD_IP)>'#GET_CARD_ID.RECORD_IP#'<cfelse>NULL</cfif>,
						<cfif len(GET_CARD_ID.RECORD_DATE)>#CreateODBCDateTime(GET_CARD_ID.RECORD_DATE)#<cfelse>NULL</cfif>,
						<cfif isDefined("session.ep.userid")>
							#SESSION.EP.USERID#,
						<cfelseif isDefined("session.pp.userid")>
							#SESSION.PP.USERID#,
						<cfelseif isDefined("session.ww.userid")>
							#SESSION.WW.USERID#,
						</cfif>
						'#CGI.REMOTE_ADDR#',
						#NOW()#,
                        <cfif len(GET_CARD_ID.ACTION_ROW_ID)>#GET_CARD_ID.ACTION_ROW_ID#<cfelse>NULL</cfif>,
						<cfif len(GET_CARD_ID.DUE_DATE)>#CreateODBCDateTime(GET_CARD_ID.DUE_DATE)#<cfelse>NULL</cfif>,
                        <cfif len(GET_CARD_ID.CARD_DOCUMENT_TYPE)>#GET_CARD_ID.CARD_DOCUMENT_TYPE#<cfelse>NULL</cfif>,
                       	<cfif len(GET_CARD_ID.CARD_PAYMENT_METHOD)>#GET_CARD_ID.CARD_PAYMENT_METHOD#<cfelse>NULL</cfif>
					)
			</cfquery>
			<cfquery name="GET_MAX_ACC_HISTORY" datasource="#arguments.muhasebe_db#">
				SELECT MAX(CARD_HISTORY_ID) AS MAX_HISTORY_ID FROM #arguments.muhasebe_db_alias#ACCOUNT_CARD_HISTORY
			</cfquery>
			<cfquery name="GET_ACC_ROW_INFO" datasource="#arguments.muhasebe_db#">
				SELECT * FROM #arguments.muhasebe_db_alias#ACCOUNT_CARD_ROWS WHERE CARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CARD_ID.CARD_ID#">
			</cfquery>
			<cfloop query="GET_ACC_ROW_INFO">
				<cfquery name="ADD_ACC_ROW_HISTORY" datasource="#arguments.muhasebe_db#">
					INSERT INTO
						#arguments.muhasebe_db_alias#ACCOUNT_CARD_ROWS_HISTORY
						(
							CARD_HISTORY_ID,
							CARD_ID,
							CARD_ROW_ID,
							ACCOUNT_ID,
							IFRS_CODE,
							ACCOUNT_CODE2,
							DETAIL,
							BA,
							AMOUNT,
							AMOUNT_CURRENCY,
							AMOUNT_2,
							AMOUNT_CURRENCY_2,
							OTHER_CURRENCY,
							OTHER_AMOUNT,
							QUANTITY,
							PRICE,
							ACC_DEPARTMENT_ID,
							ACC_BRANCH_ID,
							ACC_PROJECT_ID,
							BILL_CONTROL_NO
						)
					VALUES
						(
							#GET_MAX_ACC_HISTORY.MAX_HISTORY_ID#,
							#GET_ACC_ROW_INFO.CARD_ID#,
							#GET_ACC_ROW_INFO.CARD_ROW_ID#,
							'#GET_ACC_ROW_INFO.ACCOUNT_ID#',
							<cfif len(GET_ACC_ROW_INFO.IFRS_CODE)>'#GET_ACC_ROW_INFO.IFRS_CODE#',<cfelse>NULL,</cfif>
							<cfif len(GET_ACC_ROW_INFO.ACCOUNT_CODE2)>'#GET_ACC_ROW_INFO.ACCOUNT_CODE2#',<cfelse>NULL,</cfif>
							<cfif len(GET_ACC_ROW_INFO.DETAIL)>#sql_unicode()#'#GET_ACC_ROW_INFO.DETAIL#',<cfelse>NULL,</cfif>
							#GET_ACC_ROW_INFO.BA#,
							#GET_ACC_ROW_INFO.AMOUNT#,
							'#GET_ACC_ROW_INFO.AMOUNT_CURRENCY#',
							<cfif len(GET_ACC_ROW_INFO.AMOUNT_2)>#GET_ACC_ROW_INFO.AMOUNT_2#<cfelse>NULL</cfif>,
							<cfif len(GET_ACC_ROW_INFO.AMOUNT_CURRENCY_2)>'#GET_ACC_ROW_INFO.AMOUNT_CURRENCY_2#'<cfelse>NULL</cfif>,
							<cfif len(GET_ACC_ROW_INFO.OTHER_CURRENCY)>'#GET_ACC_ROW_INFO.OTHER_CURRENCY#'<cfelse>NULL</cfif>,
							<cfif len(GET_ACC_ROW_INFO.OTHER_AMOUNT)>#GET_ACC_ROW_INFO.OTHER_AMOUNT#<cfelse>NULL</cfif>,
							<cfif len(GET_ACC_ROW_INFO.QUANTITY)>#GET_ACC_ROW_INFO.QUANTITY#<cfelse>NULL</cfif>,
							<cfif len(GET_ACC_ROW_INFO.PRICE)>#GET_ACC_ROW_INFO.PRICE#<cfelse>NULL</cfif>,
							<cfif len(GET_ACC_ROW_INFO.ACC_DEPARTMENT_ID)>#GET_ACC_ROW_INFO.ACC_DEPARTMENT_ID#<cfelse>NULL</cfif>,
							<cfif len(GET_ACC_ROW_INFO.ACC_BRANCH_ID)>#GET_ACC_ROW_INFO.ACC_BRANCH_ID#<cfelse>NULL</cfif>,
							<cfif len(GET_ACC_ROW_INFO.ACC_PROJECT_ID)>#GET_ACC_ROW_INFO.ACC_PROJECT_ID#<cfelse>NULL</cfif>,
							<cfif len(GET_ACC_ROW_INFO.BILL_CONTROL_NO)>#GET_ACC_ROW_INFO.BILL_CONTROL_NO#<cfelse>NULL</cfif>
						)
				</cfquery>
			</cfloop>
			<cfset bill_no=GET_CARD_ID.BILL_NO>
			<cfset card_type_no=GET_CARD_ID.CARD_TYPE_NO>
			<cfquery name="DEL_ACCOUNT_CARD" datasource="#arguments.muhasebe_db#">
				DELETE FROM #arguments.muhasebe_db_alias#ACCOUNT_CARD WHERE CARD_ID IN (#valuelist(GET_CARD_ID.CARD_ID)#)
			</cfquery>
			<cfquery name="DEL_ACCOUNT_CARD_ROWS" datasource="#arguments.muhasebe_db#">
				DELETE FROM #arguments.muhasebe_db_alias#ACCOUNT_CARD_ROWS WHERE CARD_ID IN (#valuelist(GET_CARD_ID.CARD_ID)#)
			</cfquery>
		<cfelse>
			<cfquery name="get_bill_no" datasource="#arguments.muhasebe_db#">SELECT BILL_NO,MAHSUP_BILL_NO,TAHSIL_BILL_NO,TEDIYE_BILL_NO FROM #arguments.muhasebe_db_alias#BILLS</cfquery>
			<cfset bill_no=get_bill_no.BILL_NO>
			<cfif arguments.account_card_type is '11'>
				<cfset card_type_no = get_bill_no.TAHSIL_BILL_NO>
				<cfquery name="upd_bill_no" datasource="#arguments.muhasebe_db#">UPDATE #arguments.muhasebe_db_alias#BILLS SET BILL_NO=#bill_no+1#,TAHSIL_BILL_NO=#card_type_no+1#</cfquery>
			<cfelseif arguments.account_card_type is '12'>
				<cfset card_type_no = get_bill_no.TEDIYE_BILL_NO>
				<cfquery name="upd_bill_no" datasource="#arguments.muhasebe_db#">UPDATE #arguments.muhasebe_db_alias#BILLS SET BILL_NO=#bill_no+1#,TEDIYE_BILL_NO=#card_type_no+1#</cfquery>
			<cfelse>
				<cfset card_type_no = get_bill_no.MAHSUP_BILL_NO>
				<cfquery name="upd_bill_no" datasource="#arguments.muhasebe_db#">UPDATE #arguments.muhasebe_db_alias#BILLS SET BILL_NO=#bill_no+1#,MAHSUP_BILL_NO=#card_type_no+1#</cfquery>
			</cfif>
		</cfif>
	<cfelse>
		<cfquery name="get_bill_no" datasource="#arguments.muhasebe_db#">SELECT BILL_NO,MAHSUP_BILL_NO,TAHSIL_BILL_NO,TEDIYE_BILL_NO FROM #arguments.muhasebe_db_alias#BILLS</cfquery>
		<cfset bill_no=get_bill_no.BILL_NO>
		<cfif arguments.account_card_type is '11'>
			<cfset card_type_no = get_bill_no.TAHSIL_BILL_NO>
			<cfquery name="upd_bill_no" datasource="#arguments.muhasebe_db#">UPDATE #arguments.muhasebe_db_alias#BILLS SET BILL_NO=#bill_no+1#,TAHSIL_BILL_NO=#card_type_no+1#</cfquery>
		<cfelseif arguments.account_card_type is '12'>
			<cfset card_type_no = get_bill_no.TEDIYE_BILL_NO>
			<cfquery name="upd_bill_no" datasource="#arguments.muhasebe_db#">UPDATE #arguments.muhasebe_db_alias#BILLS SET BILL_NO=#bill_no+1#,TEDIYE_BILL_NO=#card_type_no+1#</cfquery>
		<cfelse>
			<cfset card_type_no = get_bill_no.MAHSUP_BILL_NO>
			<cfquery name="upd_bill_no" datasource="#arguments.muhasebe_db#">UPDATE #arguments.muhasebe_db_alias#BILLS SET BILL_NO=#bill_no+1#,MAHSUP_BILL_NO=#card_type_no+1#</cfquery>
		</cfif>
	</cfif>
    
    <!--- parametre olarak gönderilmişse --->
    <cfif not (len(arguments.document_type) OR len(arguments.payment_method))>
		<!--- edefter kapsaminda islem kategorisine bagli belge tipi ve odeme sekilleri cekiliyor. Masraf gelir fislerinde buradan degil belgeden gelene gore calismasi gerekiyor FA --->
        <cfif len(arguments.workcube_process_cat) and arguments.workcube_process_cat neq 0>
            <cfquery name="getProcessCatInfo" datasource="#arguments.muhasebe_db#">
                SELECT
                    DOCUMENT_TYPE,
                    PAYMENT_TYPE
                FROM
                    <cfif isdefined('dsn3_alias')>#dsn3_alias#<cfelse>#caller.dsn3_alias#</cfif>.SETUP_PROCESS_CAT
                WHERE
                    PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.workcube_process_cat#">	
            </cfquery>
        <cfelseif len(arguments.workcube_process_type)>
            <cfquery name="getProcessCatInfo" datasource="#arguments.muhasebe_db#">
                SELECT TOP 1
                    DOCUMENT_TYPE,
                    PAYMENT_TYPE
                FROM
                    <cfif isdefined('dsn3_alias')>#dsn3_alias#<cfelse>#caller.dsn3_alias#</cfif>.SETUP_PROCESS_CAT
                WHERE
                    PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.workcube_process_type#">
            </cfquery>
        </cfif>
    </cfif>
    
	<cfquery name="ADD_ACCOUNT_CARD" datasource="#arguments.muhasebe_db#">
		INSERT INTO
			#arguments.muhasebe_db_alias#ACCOUNT_CARD
			(
			<cfif len(arguments.wrk_id)>
				WRK_ID,
			</cfif>
				ACTION_ID,
				IS_ACCOUNT,
				BILL_NO,
				CARD_DETAIL,
				CARD_TYPE,
				CARD_CAT_ID,
				CARD_TYPE_NO,
				ACTION_TYPE,
				ACTION_CAT_ID,
				ACTION_DATE,
			<cfif isdefined('arguments.action_table') and len(arguments.action_table)>
				ACTION_TABLE,
			</cfif>
			<cfif len(arguments.belge_no)>
				PAPER_NO,
			</cfif>
			<cfif len(arguments.company_id)>
				ACC_COMPANY_ID,
			<cfelseif len(arguments.consumer_id)>
				ACC_CONSUMER_ID,
			<cfelseif len(arguments.employee_id)>
				ACC_EMPLOYEE_ID,
			</cfif>
				IS_OTHER_CURRENCY,
			<cfif isDefined("session.ep.userid")>
				RECORD_EMP,
			<cfelseif isDefined("session.pp.userid")>
				RECORD_PAR,
			<cfelseif isDefined("session.ww.userid")>
				RECORD_CONS,
			</cfif>
				RECORD_IP,
				RECORD_DATE,
                IS_CANCEL,
                ACTION_ROW_ID,
                DUE_DATE,
                CARD_DOCUMENT_TYPE,
                CARD_PAYMENT_METHOD
			)
		VALUES
			(
			<cfif len(arguments.wrk_id)>
				'#arguments.wrk_id#',
			</cfif>
				#arguments.action_id#,
				1,
				#bill_no#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#LEFT(arguments.fis_detay,150)#">,
				#arguments.account_card_type#,
				#account_card_catid#,
				#card_type_no#,
				#arguments.workcube_process_type#,
			<cfif len(arguments.workcube_process_cat)>#arguments.workcube_process_cat#<cfelse>NULL</cfif>,
				#arguments.islem_tarihi#,
			<cfif isdefined('arguments.action_table') and len(arguments.action_table)>
				'#arguments.action_table#',
			</cfif>
			<cfif len(arguments.belge_no)>
				'#arguments.belge_no#',
			</cfif>
			<cfif len(arguments.company_id)>
				#arguments.company_id#,
			<cfelseif len(arguments.consumer_id)>
				#arguments.consumer_id#,
			<cfelseif len(arguments.employee_id)>
				#arguments.employee_id#,
			</cfif>
			1,
			<cfif isDefined("session.ep.userid")>
				#SESSION.EP.USERID#,
			<cfelseif isDefined("session.pp.userid")>
				#SESSION.PP.USERID#,
			<cfelseif isDefined("session.ww.userid")>
				#SESSION.WW.USERID#,
			</cfif>
			'#CGI.REMOTE_ADDR#',
			#now()#,
            <cfif isdefined('arguments.is_cancel') and len(arguments.is_cancel)>#arguments.is_cancel#,<cfelse>0,</cfif>
            <cfif len(arguments.action_row_id)>#arguments.action_row_id#<cfelse>NULL</cfif>,
            <cfif len(arguments.due_date)>#arguments.due_date#<cfelse>NULL</cfif>,
            <!--- belge tipi --->
			<cfif len(arguments.document_type) OR len(arguments.payment_method)>
            	<cfif len(arguments.document_type)>
                	#arguments.document_type#
                <cfelse>
                	NULL
                </cfif>
			<cfelseif isdefined('getProcessCatInfo.DOCUMENT_TYPE') and len(getProcessCatInfo.DOCUMENT_TYPE)>
            	#getProcessCatInfo.DOCUMENT_TYPE#
            <cfelse>
            	NULL
            </cfif>,
            <!--- odeme sekli --->
            <cfif len(arguments.document_type) OR len(arguments.payment_method)>
            	<cfif len(arguments.payment_method)>
                	#arguments.payment_method#
                <cfelse>
                	NULL
                </cfif>
			<cfelseif isdefined('getProcessCatInfo.PAYMENT_TYPE') and len(getProcessCatInfo.PAYMENT_TYPE)>
            	#getProcessCatInfo.PAYMENT_TYPE#
            <cfelse>
            	NULL
            </cfif>
			)
	</cfquery>
	<cfquery name="GET_MAX_ACCOUNT_CARD_ID" datasource="#arguments.muhasebe_db#">
		SELECT
			MAX(CARD_ID) AS MAX_ID 
		FROM
			#arguments.muhasebe_db_alias#ACCOUNT_CARD
		WHERE
			1=1
			<cfif len(arguments.wrk_id)>
				AND WRK_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.wrk_id#">
			</cfif>
			<cfif len(arguments.action_id)>
				AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
			</cfif>
			<cfif len(arguments.workcube_process_type)>
				AND ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.workcube_process_type#">
			</cfif>
	</cfquery>
	<cfif is_ifrs eq 1> <!--- sirket parametrelerinde ifrs_code kullan secilmisse hesapların urfs ve özel kodları alınıyor --->
		<cfset acc_list_for_ifrs = listsort(listdeleteduplicates(valuelist(muh_query.ACCOUNT_CODE)),'text','asc')>
        <cfif listlen(acc_list_for_ifrs)>
            <cfquery name="GET_IFRS_CODE" datasource="#arguments.muhasebe_db#">
                SELECT ACCOUNT_CODE,IFRS_CODE,ACCOUNT_CODE2 FROM #arguments.muhasebe_db_alias#ACCOUNT_PLAN WHERE ACCOUNT_CODE IN (#listqualify(acc_list_for_ifrs,"'")#) ORDER BY ACCOUNT_CODE
            </cfquery>
         </cfif>
	</cfif>
	<cfloop query="muh_query">
		<cfif ListFind("48,49,45,46",arguments.workcube_process_type)><!--- kur farkı faturalarında döviz bakiyeleri sıfırlamak için.. Ayşenur20080111 --->
			<cfif isDefined('muh_query.OTHER_AMOUNT') and len(muh_query.OTHER_AMOUNT) and muh_query.OTHER_AMOUNT neq "session_base.money">
				<cfset muh_query.OTHER_AMOUNT = 0>
				<cfset action_value2 = 0>
			</cfif>
		<cfelseif len(arguments.currency_multiplier)>
			<cfset action_value2 = (wrk_round(muh_query.AMOUNT)/arguments.currency_multiplier)>
		</cfif>
		<cfif wrk_round(muh_query.AMOUNT,2) neq 0 or wrk_round(muh_query.OTHER_AMOUNT,2) neq 0>
			<cfquery name="ADD_FIS_ROW" datasource="#arguments.muhasebe_db#">
				INSERT INTO
					#arguments.muhasebe_db_alias#ACCOUNT_CARD_ROWS
					(
						CARD_ID,
						ACCOUNT_ID,
					<cfif is_ifrs eq 1>
						IFRS_CODE,
						ACCOUNT_CODE2,
					</cfif>
						DETAIL,
						BA,
						AMOUNT,
						AMOUNT_CURRENCY,
						AMOUNT_2,
						AMOUNT_CURRENCY_2,
						OTHER_CURRENCY,
						OTHER_AMOUNT,
						QUANTITY,
						ACC_DEPARTMENT_ID,
						PRICE,
						ACC_BRANCH_ID,
						ACC_PROJECT_ID
					)
				VALUES
					(
						#GET_MAX_ACCOUNT_CARD_ID.MAX_ID#,
						'#muh_query.ACCOUNT_CODE#',
					<cfif is_ifrs eq 1>
						<cfif len(GET_IFRS_CODE.IFRS_CODE[listfind(acc_list_for_ifrs,muh_query.ACCOUNT_CODE)])>'#GET_IFRS_CODE.IFRS_CODE[listfind(acc_list_for_ifrs,muh_query.ACCOUNT_CODE)]#',<cfelse>NULL,</cfif>
						<cfif len(GET_IFRS_CODE.ACCOUNT_CODE2[listfind(acc_list_for_ifrs,muh_query.ACCOUNT_CODE)])>'#GET_IFRS_CODE.ACCOUNT_CODE2[listfind(acc_list_for_ifrs,muh_query.ACCOUNT_CODE)]#',<cfelse>NULL,</cfif>
					</cfif>
						#sql_unicode()#'#left(muh_query.DETAIL,500)#',
						#muh_query.BA#,
						#wrk_round(muh_query.AMOUNT,2)#,
						'#arguments.action_currency#'
					<cfif len(arguments.currency_multiplier)>
						,#wrk_round(action_value2,2)#
						,'#arguments.action_currency_2#'
					<cfelse>
						,NULL
						,NULL
					</cfif>
					<cfif len(muh_query.OTHER_CURRENCY) and len(muh_query.OTHER_AMOUNT)>
						,'#muh_query.OTHER_CURRENCY#'
						,#wrk_round(muh_query.OTHER_AMOUNT,2)#
					<cfelse>
						,'#arguments.action_currency#'
						,#wrk_round(muh_query.AMOUNT,2)#
					</cfif>
					<cfif len(muh_query.QUANTITY)>,#muh_query.QUANTITY#<cfelse>,NULL</cfif>
					<cfif isdefined('arguments.acc_department_id') and len(arguments.acc_department_id)>
						,#arguments.acc_department_id#
					<cfelse>
						,NULL
					</cfif>
					<cfif len(muh_query.PRICE)>,#muh_query.PRICE#<cfelse>,NULL</cfif>
					<cfif isdefined("muh_query.ACC_BRANCH_ID") and len(muh_query.ACC_BRANCH_ID) and muh_query.ACC_BRANCH_ID gt 0>
						,#muh_query.ACC_BRANCH_ID#
					<cfelse>
						<cfif isdefined('arguments.from_branch_id') and len(arguments.from_branch_id) and not (isdefined('arguments.to_branch_id') and len(arguments.to_branch_id))>
						<!--- sadece from_branch_id gönderildiyse --->
							,#arguments.from_branch_id#
						<cfelseif isdefined('arguments.to_branch_id') and len(arguments.to_branch_id) and not (isdefined('arguments.from_branch_id') and len(arguments.from_branch_id))>
						<!--- sadece to_branch_id gönderildiyse --->
							,#arguments.to_branch_id#
						<cfelse>
							<cfif muh_query.BA eq 1>
								<cfif isdefined('arguments.from_branch_id') and len(arguments.from_branch_id)>
									,#arguments.from_branch_id#
								<cfelse>
									,NULL
								</cfif>
							<cfelse>
								<cfif isdefined('arguments.to_branch_id') and len(arguments.to_branch_id)>
									,#arguments.to_branch_id#
								<cfelse>
									,NULL
								</cfif>
							</cfif>
						</cfif>
					</cfif>
					<cfif isdefined("muh_query.ACC_PROJECT_ID") and len(muh_query.ACC_PROJECT_ID) and muh_query.ACC_PROJECT_ID gt 0>
						,#muh_query.ACC_PROJECT_ID#
					<cfelse>
						<cfif isdefined('arguments.acc_project_id') and len(arguments.acc_project_id) and arguments.acc_project_id neq 0>
							,#arguments.acc_project_id#
						<cfelse>
							,NULL
						</cfif>
					</cfif>
					)
			</cfquery>
		</cfif>
	</cfloop>	
	<cfquery name="ADD_LOG" datasource="#arguments.muhasebe_db#">
		INSERT INTO
			#dsn_alias#.WRK_LOG
		(
			PROCESS_TYPE,
			EMPLOYEE_ID,
			LOG_TYPE,
			LOG_DATE,
            <cfif len(arguments.belge_no)>
            PAPER_NO, 
            </cfif>
			FUSEACTION,
			ACTION_ID,
			ACTION_NAME,
			PERIOD_ID
		)
		VALUES
		(	
			#arguments.account_card_type#,
			#session_base.userid#,
			<cfif isDefined('arguments.workcube_old_process_type') and len(arguments.workcube_old_process_type)>0<cfelse>1</cfif>,
			#now()#,
            <cfif len(arguments.belge_no)>
                    '#arguments.belge_no#', 
            </cfif>
			<cfif isdefined("fusebox.circuit") and isdefined("fusebox.fuseaction")>
				'#fusebox.circuit#.#fusebox.fuseaction#',
			<cfelseif isdefined("caller.fusebox.circuit") and isdefined("caller.fusebox.fuseaction")>
				'#caller.fusebox.circuit#.#caller.fusebox.fuseaction#',
			<cfelseif isdefined("caller.caller.fusebox.circuit") and isdefined("caller.caller.fusebox.fuseaction")>
				'#caller.caller.fusebox.circuit#.#caller.caller.fusebox.fuseaction#',
			</cfif>
			#GET_MAX_ACCOUNT_CARD_ID.MAX_ID#,
			'#left(bill_no,250)#',
			#session_base.period_id#
		)
	</cfquery>
	<cfreturn GET_MAX_ACCOUNT_CARD_ID.MAX_ID>
</cffunction>
<cffunction name="muhasebe_sil" output="false">
	<!---
	by :  20040227
	notes : Muhasebe fişi siler...(Tahsil-Tediye-Mahsup)
			!!! TRANSACTION icinde kullanılmalıdır !!! Fonksiyon sorunsuz çalistiginda true döndürür.
	usage :
		muhasebe_sil (action_id:attributes.id,process_type:90);
	revisions :
	muhasebe sil fonksiyonuna history silme bölümü eklenmedi, boylece silinen kayıtların detaylı loglarını tutuyoruz
	--->
	<cfargument name="action_id" required="yes" type="numeric">
	<cfargument name="process_type" required="yes" type="numeric">
	<cfargument name="muhasebe_db" type="string" default="#dsn2#">	
	<cfargument name="muhasebe_db_alias" type="string" default="">
    <cfargument name="belge_no" type="string" default="">
	<cfargument name="action_table" type="string">
	<cfif arguments.muhasebe_db is not '#dsn2#'>
		<cfset arguments.muhasebe_db_alias = '#dsn2_alias#'&'.'>
	<cfelse>
		<cfset arguments.muhasebe_db_alias =''>
	</cfif>
	<cfquery name="GET_CARD_ID" datasource="#arguments.muhasebe_db#">
        SELECT
            CARD_ID,
            ACTION_ID,
            BILL_NO,
            ACTION_DATE,
            PAPER_NO,
            CARD_TYPE
        FROM
        	#arguments.muhasebe_db_alias#ACCOUNT_CARD
        WHERE
            ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
            AND ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_type#">
            AND ISNULL(IS_CANCEL,0)=0
            <cfif isDefined('arguments.action_table') and len(arguments.action_table)> 
                AND ACTION_TABLE = '#arguments.action_table#'
            </cfif>
	</cfquery>
	<cfif GET_CARD_ID.RECORDCOUNT>
    	<!--- e-defter islem kontrolu FA --->
		<cfif session.ep.our_company_info.is_edefter eq 1>
            <cfstoredproc procedure="GET_NETBOOK" datasource="#arguments.muhasebe_db#">
                <cfprocparam cfsqltype="cf_sql_timestamp" value="#GET_CARD_ID.ACTION_DATE#">
                <cfprocparam cfsqltype="cf_sql_timestamp" value="#GET_CARD_ID.ACTION_DATE#">
                <cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.muhasebe_db_alias#">
                <cfprocresult name="getNetbook">
            </cfstoredproc>
            <cfscript>
                if(getNetbook.recordcount)
                    abort('Muhasebeci : İşlemi yapamazsınız. İşlem tarihine ait e-defter bulunmaktadır.');
            </cfscript>
        </cfif>
        <!--- e-defter islem kontrolu FA --->
        
		<!--- FBS 20120606 Belgelerde Birden Fazla Fis Olustugunda, Belge Silindiginde Fislerin Tamaminin Silinmesi Icin CARD_ID IN ile Cekiliyor  --->
		<cfquery name="DEL_ACCOUNT_CARD" datasource="#arguments.muhasebe_db#">
			DELETE FROM #arguments.muhasebe_db_alias#ACCOUNT_CARD WHERE CARD_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#ValueList(GET_CARD_ID.CARD_ID)#" list="yes">)
		</cfquery>
		<cfquery name="DEL_ACCOUNT_CARD_ROWS" datasource="#arguments.muhasebe_db#">
			DELETE FROM #arguments.muhasebe_db_alias#ACCOUNT_CARD_ROWS WHERE CARD_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#ValueList(GET_CARD_ID.CARD_ID)#" list="yes">)
		</cfquery>
		<cfquery name="ADD_LOG" datasource="#arguments.muhasebe_db#">
			INSERT INTO
				#dsn_alias#.WRK_LOG
			(
				PROCESS_TYPE,
				EMPLOYEE_ID,
				LOG_TYPE,
				LOG_DATE,
				<cfif len(GET_CARD_ID.PAPER_NO)>
                 PAPER_NO, 
                </cfif>
				FUSEACTION,
				ACTION_ID,
				ACTION_NAME,
				PERIOD_ID
                
			)
			VALUES
			(	
				#GET_CARD_ID.CARD_TYPE#,
				#session.ep.userid#,
				-1,
				#now()#,
                <cfif len(GET_CARD_ID.PAPER_NO)>
                    '#GET_CARD_ID.PAPER_NO#', 
                </cfif>
				<cfif isdefined("fusebox.circuit")>
					'#fusebox.circuit#  #fusebox.fuseaction#',
				<cfelse>
					'#caller.fusebox.circuit#  #caller.fusebox.fuseaction#',
				</cfif>
				#GET_CARD_ID.CARD_ID#,
				'#left(GET_CARD_ID.BILL_NO,250)#',
				#session.ep.period_id#
			)
		</cfquery>
	</cfif>
	<cfreturn true>
</cffunction>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
