<cfsetting showdebugoutput="no">
<cfparam name="attributes.process_type" default="">
<cfparam name="attributes.startdate" default="#dateformat(now(),'dd/mm/yyyy')#">
<cfparam name="attributes.finishdate" default="#dateformat(now(),'dd/mm/yyyy')#">
<cf_date tarih='attributes.finishdate'>
<cf_date tarih='attributes.startdate'>
<cfquery name="get_process_cat" datasource="#dsn3#">
	SELECT PROCESS_CAT,PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN(53,531) ORDER BY PROCESS_CAT
</cfquery>
<cfif isdefined('attributes.is_form_submitted') and attributes.is_form_submitted eq 1>
	<cfquery name="get_all_invoice_amount" datasource="#dsn3#">
		SELECT
			'#session.ep.money#' OTHER_MONEY,
			IR.PRODUCT_ID,
			ISNULL(SUM((IR.COST_PRICE+IR.EXTRA_COST)*AMOUNT),0) COST_PRICE,
			S.PRODUCT_NAME
		FROM
			#dsn2_alias#.INVOICE I,
			#dsn2_alias#.INVOICE_ROW IR,
			#dsn3_alias#.STOCKS S
		WHERE
			I.IS_IPTAL = 0 AND
			I.PURCHASE_SALES = 1 AND
			I.INVOICE_CAT IN(53,531) AND
			I.INVOICE_ID = IR.INVOICE_ID AND
			IR.STOCK_ID = S.STOCK_ID AND
			I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
			I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
			<cfif len(attributes.process_type)>
				AND PROCESS_CAT IN(#attributes.process_type#)
			</cfif>
		GROUP BY
			IR.PRODUCT_ID,
			S.PRODUCT_NAME
	</cfquery>
	<cfif get_all_invoice_amount.recordcount>
		<cfset muhasebe_uyari = ''>
		<cflock name="#CreateUUID()#" timeout="60">
			<cftransaction>				
				<!--- Satılan malın maliyeti ile ilgili, olup (53), gonderilen tarihte daha onceki kayitlar yeniden olusacagi icin temizleniyor --->
				<cfquery name="Get_Account_Control" datasource="#dsn3#">
					SELECT
						CARD_ID
					FROM
						#dsn2_alias#.ACCOUNT_CARD
					WHERE
						ACTION_ID = 0 AND
						ACTION_TYPE = 53 AND
						ACTION_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
				</cfquery>
				<cfif Get_Account_Control.RecordCount>
					<cfquery name="Del_Account_Card_Rows" datasource="#dsn3#">
						DELETE FROM #dsn2_alias#.ACCOUNT_CARD_ROWS WHERE CARD_ID IN (#ValueList(Get_Account_Control.Card_Id)#)
					</cfquery>
					<cfquery name="Del_Account_Cards" datasource="#dsn3#">
						DELETE FROM #dsn2_alias#.ACCOUNT_CARD WHERE CARD_ID IN (#ValueList(Get_Account_Control.Card_Id)#)
					</cfquery>
				</cfif>
				<!--- Satılan malın maliyeti muhasebe kaydı oluşturulacak. Ürünlerin alış hesabına alacak, satılan malın maliyet hesabına borç yazacak --->
				<cfscript>
					Date_Detail = "#DateFormat(attributes.startdate,'dd/mm/yyyy')# - #DateFormat(attributes.finishdate,'dd/mm/yyyy')#";
					str_borclu_hesaplar = '' ;
					str_alacakli_hesaplar = '' ;
					str_borc_tutar = '' ;
					str_alacak_tutar = '' ;
					str_alacak_dovizli = '' ;
					str_borc_dovizli = '' ;
					str_other_currency_borc = '' ;
					str_other_currency_alacak = '';
					temp_cost_price_system_exit = 0;
					temp_cost_price_exit = 0;
					//üretilen ürün
					for(i=1;i lte get_all_invoice_amount.recordcount; i=i+1) 
					{	
						account_codes =  cfquery(datasource:'#dsn3#',sqlstring:'SELECT ACCOUNT_CODE_PUR,SALE_PRODUCT_COST,PRODUCTION_COST FROM PRODUCT_PERIOD WHERE PRODUCT_ID = #get_all_invoice_amount.PRODUCT_ID[i]# AND PERIOD_ID = #session.ep.period_id#');
						str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, account_codes.SALE_PRODUCT_COST, ",");	
						str_borc_tutar = ListAppend(str_borc_tutar, wrk_round(get_all_invoice_amount.COST_PRICE[i]),",");
						str_borc_dovizli = ListAppend(str_borc_dovizli, wrk_round(get_all_invoice_amount.COST_PRICE[i]),",");
						str_other_currency_borc = ListAppend(str_other_currency_borc,get_all_invoice_amount.OTHER_MONEY[i],",");//get_all_invoice_amount.OTHER_MONEY[i]
																		
						str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, account_codes.ACCOUNT_CODE_PUR, ",");	
						str_alacak_tutar = ListAppend(str_alacak_tutar, wrk_round(get_all_invoice_amount.COST_PRICE[i]),",");
						str_alacak_dovizli = ListAppend(str_alacak_dovizli, wrk_round(get_all_invoice_amount.COST_PRICE[i]),",");
						str_other_currency_alacak = ListAppend(str_other_currency_alacak,get_all_invoice_amount.OTHER_MONEY[i],",");
						
						if(not len(account_codes.SALE_PRODUCT_COST))
							muhasebe_uyari = "#muhasebe_uyari#;#get_all_invoice_amount.PRODUCT_NAME[i]# Ürünü İçin Satılan Malın Maliyeti Hesabı Eksik.";
						if(not len(account_codes.ACCOUNT_CODE_PUR))
							muhasebe_uyari = "#muhasebe_uyari#;#get_all_invoice_amount.PRODUCT_NAME[i]# Ürünü İçin Alış Hesabı Eksik.";
					}
					//1-9 kurus icin yuvarlama islemi yapılıyor
					temp_total_alacak = evaluate(ListChangeDelims(str_alacak_tutar,'+',','));
					temp_total_borc = evaluate(ListChangeDelims(str_borc_tutar,'+',','));
					temp_fark = round((temp_total_alacak-temp_total_borc)*100);
					if( temp_fark gte -9 and temp_fark lt 0 )
					{
						fark_account = cfquery(datasource:"#dsn3#",sqlstring:"SELECT FARK_GELIR FROM SETUP_INVOICE");
						str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, fark_account.FARK_GELIR, ",");
						str_alacak_tutar = ListAppend(str_alacak_tutar, abs(temp_fark/100), ",");
						str_alacak_dovizli = ListAppend(str_alacak_dovizli, abs(temp_fark/100),",");
						str_other_currency_alacak = ListAppend(str_other_currency_alacak,session.ep.money,",");
					}
					else if( temp_fark lte 9 and temp_fark gt 0 )
					{
						fark_account = cfquery(datasource:"#dsn3#",sqlstring:"SELECT FARK_GIDER FROM SETUP_INVOICE");
						str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, fark_account.FARK_GIDER, ",");
						str_borc_tutar = ListAppend(str_borc_tutar, abs(temp_fark/100), ",");
						str_borc_dovizli = ListAppend(str_borc_dovizli, abs(temp_fark/100),",");
						str_other_currency_borc = ListAppend(str_other_currency_borc,session.ep.money,",");
					}	
					if(len(muhasebe_uyari))
					{
						for(kk=1;kk<=listlen(muhasebe_uyari,';');kk=kk+1)
						{
							writeoutput("#listgetat(muhasebe_uyari,kk,';')#<br />");
							abort("Yukarıdaki Ürünler İçin Düzenleme Yapmalısınız !");
						}
					}
					muhasebeci
					(
						action_id : 0,
						workcube_process_type : 53,
						workcube_process_cat : 0,
						muhasebe_db : dsn3,
						muhasebe_db_alias = dsn2_alias,
						account_card_type : 13,
						islem_tarihi : attributes.finishdate,
						borc_hesaplar : str_borclu_hesaplar,
						borc_tutarlar : str_borc_tutar,
						other_amount_borc : str_borc_dovizli,
						other_currency_borc : str_other_currency_borc,
						alacak_hesaplar : str_alacakli_hesaplar,
						alacak_tutarlar : str_alacak_tutar,
						other_amount_alacak : str_alacak_dovizli,
						other_currency_alacak :str_other_currency_alacak,
						fis_detay : '#Date_Detail# SATILAN MALIN MALİYETİ',
						fis_satir_detay : '#Date_Detail# SATILAN MALIN MALİYETİ',
						is_account_group : 1
					);
				</cfscript>
			</cftransaction>
		</cflock>
		<cfquery name="get_cards" datasource="#dsn2#">
			SELECT BILL_NO,ACTION_DATE FROM ACCOUNT_CARD WHERE ACTION_ID = 0 AND ACTION_TYPE = 53 AND RECORD_EMP = #session.ep.userid# AND ACTION_DATE = #attributes.finishdate#
		</cfquery>
		<cfset warning_txt = ''>
		<cfoutput query="get_cards">
			<cfif len(warning_txt)>
				<cfset warning_txt = '#warning_txt#,#get_cards.bill_no#'>
			<cfelse>
				<cfset warning_txt = '#get_cards.bill_no#'>
			</cfif>
		</cfoutput>
		<cfoutput>
			<script>
				alert("Seçilen Tarih Aralığındaki Faturaların Muhasebe Fişleri Oluşturuldu !\n Fiş Numaraları : \n #warning_txt#");
			</script>	
		</cfoutput>
	<cfelse>
		<script>
			alert("Seçilen Tarih Aralığındaki Fatura Bulunamadı !");
		</script>	
	</cfif>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.product_cost_account_card';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'account/display/product_cost_account_card.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'account/display/product_cost_account_card.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.product_cost_account_card';
</cfscript>

