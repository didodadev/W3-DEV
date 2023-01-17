<!--- 20050302 buradaki dosya siralari performans ve oncelik dusunulerek duzenlendi bilgi disinda degistirmeyin --->
<cfinclude template="check_product_exists.cfm">
<cfscript>
	attributes.acc_type_id = '';
	if(isdefined("attributes.employee_id") and listlen(attributes.employee_id,'_') eq 2)
	{
		attributes.acc_type_id = listlast(attributes.employee_id,'_');
		attributes.employee_id = listfirst(attributes.employee_id,'_');
	}
</cfscript>
<cf_date tarih='attributes.invoice_date'>
<cfif isdefined("attributes.process_date") and len(attributes.process_date)>
	<cf_date tarih='attributes.process_date'>
</cfif>
<cfif isdefined("attributes.note")>
	<cfset note = attributes.note>
</cfif>
<cfif isdefined('attributes.realization_date') and isdate(attributes.realization_date)>
	<cf_date tarih='attributes.realization_date'>
</cfif>
<cfset form.basket_rate2 = form.basket_rate2 / form.basket_rate1>
<cfset attributes.basket_rate2 = attributes.basket_rate2 / attributes.basket_rate1>
<cf_date tarih = "attributes.basket_due_value_date_">
<cfset invoice_due_date = attributes.basket_due_value_date_>
<!--- gelen fatura tarihine gore vade tarihi bulunur YO20062802--->
<cfset form.invoice_number = Trim(form.invoice_number)>
<cfquery name="GET_UNIQUE" datasource="#dsn2#">
	SELECT 
		INVOICE_ID
	FROM 
		INVOICE
	WHERE 
		INVOICE_NUMBER = '#form.invoice_number#' AND
		INVOICE_ID <> #form.invoice_id# AND
		PURCHASE_SALES = 0
	  <cfif len(attributes.company_id)>
		AND COMPANY_ID = #attributes.company_id# 
	  <cfelseif len(attributes.consumer_id)>
	  	AND CONSUMER_ID = #attributes.consumer_id#
	  <cfelse>
	  	AND EMPLOYEE_ID = #attributes.employee_id#
	  </cfif>
</cfquery>
<cfif get_unique.recordcount>
	<script type="text/javascript">
		alert("Girdiğiniz Fatura Numarası Seçilen Cari Adına Kullanılmış !");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
		//history.back();
	</script>
	<cfabort>
</cfif>
<cfscript>
	include('check_taxes.cfm');
	include('get_basket_irs.cfm');

	/*if( not (isDefined("attributes.department_id") and len(attributes.department_id)) )
		attributes.department_id = "NULL";
	if( not (isDefined("attributes.location_id") and len(attributes.location_id)) )
		attributes.location_id = "NULL";
	if( not (isDefined("attributes.ship_method") and len(attributes.ship_method)) )
		attributes.ship_method = "NULL";
	if( not (isDefined("attributes.paymethod_id") and len(attributes.paymethod_id)) )
		attributes.paymethod_id = "NULL";*/
	// invoice_account_process.cfm 'de location_type a gore urun muhasebe kodu alınıyor...
	if( len(attributes.location_id) and len(attributes.department_id)) 
	{	
		LOCATION=cfquery(datasource:"#dsn2#",sqlstring:"SELECT LOCATION_TYPE,IS_SCRAP FROM #dsn_alias#.STOCKS_LOCATION WHERE DEPARTMENT_ID=#attributes.department_id# AND LOCATION_ID=#attributes.location_id#");
		location_type = LOCATION.LOCATION_TYPE;
		is_scrap = LOCATION.IS_SCRAP;
	}
	else
	{location_type ='';is_scrap =0;}
	
	include('get_bill_process_cat.cfm');
	include('check_disc_accs.cfm');
	attributes.currency_multiplier = '';//basketin secili olan kurun degeri cari ve muh islemlerinde kullaniliyor
	paper_currency_multiplier ='';
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
		{
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				attributes.currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			if(evaluate("attributes.hidden_rd_money_#mon#") is form.basket_money)
				paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		}
</cfscript>
<cfswitch expression="#invoice_cat#">
	<!--- 20060217 buan benzer ifade be kodlar yukaridaki check_disc_accs.cfm icinde cagrilan get_inv_cats.cfm dosyasinda da var sadelesmelii temizlenmeli--->
	<cfcase value="51"><cfset str_line_detail = "#attributes.comp_name# ALINAN VADE FARKI FATURASI"></cfcase>
	<cfcase value="54"><cfset str_line_detail = "#attributes.comp_name# PERAKENDE SATIŞ İADE FATURASI"></cfcase>	
	<cfcase value="55"><cfset str_line_detail = "#attributes.comp_name# TOPTAN SATIŞ İADE FATURASI"></cfcase>
	<cfcase value="59"><cfset str_line_detail = "#attributes.comp_name# MAL ALIM FATURASI"></cfcase>
	<cfcase value="60"><cfset str_line_detail = "#attributes.comp_name# ALINAN HİZMET FATURASI "></cfcase>
	<cfcase value="61"><cfset str_line_detail = "#attributes.comp_name# ALINAN PROFORMA FATURASI"></cfcase>
	<cfcase value="63"><cfset str_line_detail = "#attributes.comp_name# ALINAN FİYAT FARKI FATURASI"></cfcase>
	<cfcase value="591"><cfset str_line_detail = "#attributes.comp_name# ITHALAT FATURASI"></cfcase>	
	<cfcase value="592"><cfset str_line_detail = "#attributes.comp_name# HAL FATURASI"></cfcase>		
	<cfdefaultcase><cfset str_line_detail = " "></cfdefaultcase>
</cfswitch>
<cfquery name="GET_SHIP_ID" datasource="#dsn2#"><!--- faturanın kendi irsaliyesi varsa alır --->
	SELECT 
		INV_S.SHIP_ID,
		INV_S.INVOICE_NUMBER,
		INV_S.SHIP_NUMBER,
		INV_S.IS_WITH_SHIP,
		S.SHIP_TYPE
	FROM 
		INVOICE_SHIPS INV_S,
		SHIP S 
	WHERE 
		INV_S.SHIP_ID = S.SHIP_ID AND
		INV_S.IS_WITH_SHIP = 1 AND
		INV_S.INVOICE_ID = #form.invoice_id# AND
		INV_S.SHIP_PERIOD_ID = #session.ep.period_id#
</cfquery>
<cfset old_ship_id = GET_SHIP_ID.SHIP_ID>
<cfset old_ship_type = GET_SHIP_ID.SHIP_TYPE>
<cfquery name="GET_INV_INFO" datasource="#dsn2#"><!--- upd_invoice_purchase_3 de cari kapamalar için kullanılıyor silmeyiniz --->
	SELECT NETTOTAL,DUE_DATE FROM INVOICE WHERE INVOICE_ID = #form.invoice_id#
</cfquery>
