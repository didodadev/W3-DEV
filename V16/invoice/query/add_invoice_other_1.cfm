<cfinclude template="check_product_exists.cfm">
<cfinclude template="check_taxes.cfm">	
<cfinclude template="check_bill_start.cfm">
<cfinclude template="get_bill_process_cat.cfm">
<cf_date tarih ='attributes.invoice_date'>
<cfif isdefined("attributes.process_date") and len(attributes.process_date)>
	<cf_date tarih ='attributes.process_date'>
</cfif>
<cfif isdefined("attributes.basket_due_value") and len(attributes.basket_due_value)>
	<cfset invoice_due_date = date_add("d",attributes.basket_due_value,attributes.invoice_date)>
<cfelse>
	<cfset invoice_due_date = "">
</cfif>
<cfset form.invoice_number = Trim(form.invoice_number)>
<cfswitch expression="#invoice_cat#">
	<cfcase value="691"><!--- Gider Pusula (Hizmet) --->
		<cfset str_line_detail = "Gider Pusula (Hizmet)">
	</cfcase>
	<cfcase value="690"><!--- Gider Pusula (Mal) --->
		<cfset str_line_detail = "Gider Pusula (Mal)">
	</cfcase>
	<cfcase value="64"><!--- Müstahsil Makbuzu ---><!--- Mal --->
		<cfset str_line_detail = "Müstahsil Makbuzu">
	</cfcase>
	<cfcase value="68"><!--- Serbest Meslek Makbuzu ---><!--- Hizmet --->
		<cfset str_line_detail = "Serbest Meslek Makbuzu">
	</cfcase>
</cfswitch>
<cfset cari_hesap_secili = 0>
<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
	<cfset cari_hesap_secili = 1>
</cfif>
<cfif isdefined("attributes.partner_id") and len(attributes.partner_id)>
	<cfset cari_hesap_secili = 1>
</cfif>
<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
	<cfset cari_hesap_secili = 1>
</cfif>

<cfset ACC="">
<cfif is_account eq 1>
	<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
		<cfset ACC = GET_COMPANY_PERIOD(attributes.company_id)>
	<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
		<cfset ACC = GET_CONSUMER_PERIOD(attributes.consumer_id)>
	<cfelseif len(other_account_code)>
		<cfset ACC=other_account_code>
	</cfif>
	<cfif not len(ACC)>
		<script type="text/javascript">
			alert("<cf_get_lang no='402.Seçilen Üyenin Muhasebe Kodu Belirtilmemis'>!");
			window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
			//history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfscript>
	/*if( not (isDefined("attributes.department_id") and len(attributes.department_id)) )
		attributes.department_id = "NULL";
	if( not (isDefined("attributes.location_id") and len(attributes.location_id)) )
		attributes.location_id = "NULL";
	if( not (isDefined("attributes.ship_method") and len(attributes.ship_method)) )
		attributes.ship_method = "NULL";
	if( not (isDefined("attributes.paymethod_id") and len(attributes.paymethod_id)) )
		attributes.paymethod_id = "NULL";*/
	// invoice_other_account_process.cfm 'de location_type a gore urun muhasebe kodu alınıyor...
	if(len(attributes.location_id) and len(attributes.department_id))
	{
		GET_LOCATION_TYPE = cfquery(datasource:"#dsn#",sqlstring:"SELECT LOCATION_TYPE FROM STOCKS_LOCATION WHERE DEPARTMENT_ID=#attributes.department_id# AND LOCATION_ID=#attributes.location_id#");
		location_type=GET_LOCATION_TYPE.LOCATION_TYPE;
	}
	else
		location_type='';
	
	/*attributes.currency_multiplier = '';//basketin secili olan kurun degeri cari ve muh islemlerinde kullaniliyor
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				attributes.currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
	*/	
				
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

<cfif not len(deliver_get_id)>
	<script type="text/javascript">
		alert(" <cf_get_lang no='33.Teslim Alacak Personeli Seçmelisiniz'>!");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
		//history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_PURCHASE" datasource="#dsn2#">
	SELECT
		SHIP_NUMBER
	FROM
		SHIP
	WHERE
		PURCHASE_SALES = 0 AND 
		SHIP_NUMBER = '#FORM.INVOICE_NUMBER#'
</cfquery>
<cfif get_purchase.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='35.Girdiğiniz İrsaliye Numarası Kullanılıyor'>!");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
		//history.back();
	</script>
	<cfabort>
</cfif>
