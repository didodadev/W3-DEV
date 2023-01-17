<cfparam  name="attributes.yuvarlama" default="0">
<cfquery name="get_per" datasource="#DSN#" >
	SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = #attributes.period_id#
</cfquery>
<cfset attributes.comp_name=get_par_info(attributes.company_id,1,0,0)>
<cfset new_period_is_integrated = get_per.IS_INTEGRATED >
<cfscript>
	new_dsn3 = '#dsn#_#get_per.OUR_COMPANY_ID#';			
	if (database_type IS 'MSSQL') {new_dsn2 = '#dsn#_#get_per.PERIOD_YEAR#_#get_per.OUR_COMPANY_ID#';new_dsn2_alias='#new_dsn2#';new_dsn3_alias = '#dsn3#';}
	else if (database_type IS 'DB2') {new_dsn2 = '#dsn#_#get_per.OUR_COMPANY_ID#_#right(get_per.PERIOD_YEAR,2)#';new_dsn2_alias='#new_dsn2#_dbo';new_dsn3_alias = '#dsn3#_dbo';}
</cfscript>
<cfquery name="get_invoice" datasource="#DSN2#">
	SELECT * FROM INVOICE WHERE INVOICE_ID = #ATTRIBUTES.INVOICE_ID#
</cfquery>
<cfquery name="get_invoice_row" datasource="#DSN2#">
	SELECT * FROM INVOICE_ROW WHERE INVOICE_ID = #ATTRIBUTES.INVOICE_ID#
</cfquery>
<cfset prod_list=ValueList(get_invoice_row.PRODUCT_ID)>

<cfquery name="get_b_dis"  dbtype="query">
	SELECT SUM(DISCOUNTTOTAL) AS DISC_ FROM get_invoice_row
</cfquery>
<cfif len(get_b_dis.DISC_)>
	<cfset attributes.BASKET_DISCOUNT_TOTAL = get_b_dis.DISC_>
<cfelse>
	<cfset attributes.BASKET_DISCOUNT_TOTAL = 0>
</cfif>
<cfquery name="get_invoice_moneys" datasource="#DSN2#">
	SELECT * FROM INVOICE_MONEY WHERE ACTION_ID = #ATTRIBUTES.INVOICE_ID#
</cfquery>
<cfset 	currency_multiplier = ''>
<cfoutput query="get_invoice_moneys">
	<cfif money_type is session.ep.money2>
		<cfset currency_multiplier = get_invoice_moneys.rate2/get_invoice_moneys.rate1>
	</cfif>
</cfoutput>
<cfquery name="get_m" datasource="#DSN#">
	SELECT
		*
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
		MONEY = '#GET_INVOICE.OTHER_MONEY#'
</cfquery>
<cfset attributes.basket_rate1 = get_m.RATE1 >
<cfset attributes.basket_rate2 = get_m.RATE2 >
<cfquery name="get_prod_in" datasource="#DSN3#">
	SELECT
		PRODUCT_ID,
		IS_INVENTORY
	FROM
		PRODUCT
	WHERE
		PRODUCT_ID IN (#prod_list#)
</cfquery>
<cfquery name="get_prod_inv_det" dbtype="query" maxrows="1">
	SELECT * FROM get_prod_in WHERE IS_INVENTORY=1
</cfquery>
<cfset inventory_product_exists = get_prod_inv_det.RECORDCOUNT >
<cfquery name="get_process_type" datasource="#new_dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT,
		IS_ACCOUNT_GROUP
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	if(len(get_process_type.IS_CARI))is_cari = get_process_type.IS_CARI; else is_cari = 0;
	if(len(get_process_type.IS_ACCOUNT)) is_account = get_process_type.IS_ACCOUNT ;else	is_account = 0;	
	invoice_cat = get_process_type.PROCESS_TYPE ;
	process_cat = form.PROCESS_CAT ;
</cfscript>

<cfif not len(attributes.location_id) >
	<cfset attributes.location_id = "NULL" >
</cfif>
<cfset attributes.invoice_date = dateformat(get_invoice.invoice_date,dateformat_style) >
<cf_date tarih='attributes.invoice_date'>

<cfset temp_tax_list = "">
<cfset inventory_product_exists = 0 >
<cfloop query="get_invoice_row" >
	<cfif not listfind(temp_tax_list, tax[currentrow], ",")>
		<cfset temp_tax_list = ListAppend(temp_tax_list, tax[currentrow], ",")>
	</cfif>
</cfloop>
<cfset attributes.basket_tax_count = ListLen(temp_tax_list) >
<cfquery name="get_taxes" datasource="#new_dsn2#">
	SELECT * FROM SETUP_TAX WHERE TAX IN (#temp_tax_list#)
</cfquery>
<cfset tax_list = valuelist(get_taxes.tax) >

<cfif is_account>

	<cfquery datasource="#new_DSN2#" name="bill_control">
		SELECT * FROM BILLS
	</cfquery>
	<cfif not bill_control.recordcount>
		<script type="text/javascript">
			alert("Muhasebe Fiş Numaralarınız Tanımlı değil.Lütfen Tanımlayınız !");
			window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
			//history.back();
		</script>
		<cfabort>
	</cfif>
	<cfquery name="GET_NO_" datasource="#new_dsn3#">
		SELECT * FROM SETUP_INVOICE_PURCHASE
	</cfquery>
	<cfif NOT LEN(GET_NO_.A_DISC) >
		<cfset HATA=2>
	</cfif>
	<cfif not get_no_.recordcount>
		<cfset HATA=1>
	</cfif>

	<cfif isDefined("HATA")>
		<script type="text/javascript">
			alert("<cf_get_lang no='146.Lutfen Alis Tanimlari Ayarlarini Yapiniz'>");
			window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
			//history.back();
		</script>
		<cfabort>
	</cfif>

	<cfset MY_ACC_RESULT = GET_COMPANY_PERIOD(company_id:attributes.company_id,period_id:attributes.period_id)>
	<cfif len(MY_ACC_RESULT)>
		<cfset ACC=MY_ACC_RESULT>
	<cfelse>
		<cfset ACC="">
	</cfif>
	<cfif not len(ACC)>
		<script type="text/javascript">
			alert("<cf_get_lang no='100.Seçilen Sirketin Muhasebe Kodu Belirtilmemis'>");
			window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
			//history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfinclude template="get_inv_cats.cfm">
<!--- get basket irs --->
<cfset ship_list = get_invoice.SHIP_NUMBER>
<cfquery name="get_ship" datasource="#new_dsn2#">
	SELECT
		SHIP_ID
	FROM
		SHIP
	WHERE
		<cfif len(ship_list)>
			(		
				<cfloop list="#ship_list#" index="ind_c">
					SHIP_NUMBER = '#ship_list#' OR
				</cfloop>
				1=1
			)
			AND	SHIP_ID IS NOT NULL
		<cfelse>
			SHIP_ID IS NULL
		</cfif>	
</cfquery>

<cfset included_irs = 0>
<cfset attributes.ship_ids = ValueList(get_ship.SHIP_ID)>
<cfset attributes.ship_numbers = ship_list>
<cfset attributes.ship_methods = "">
<cfif get_ship.recordcount><cfset included_irs = 1></cfif>

<cfif included_irs>
	<cfquery name="get_irs" datasource="#new_dsn2#">
		SELECT SHIP_NUMBER,SHIP_METHOD,DEPARTMENT_IN,LOCATION_IN,DELIVER_STORE_ID,LOCATION FROM SHIP WHERE SHIP_ID IN (#attributes.ship_ids#)
	</cfquery>
	<cfset attributes.ship_methods = ValueList(get_irs.SHIP_METHOD, ",")>
	<cfif not (isDefined("attributes.department_id") and len(attributes.department_id))>
		<cfset attributes.department_id = get_irs.DEPARTMENT_IN>
	</cfif>
	<cfif not (isDefined("attributes.location_id") and len(attributes.location_id))>
		<cfset attributes.location_id = get_irs.LOCATION_IN>
	</cfif>
</cfif>
<!--- get basket irs --->

<cfif not (isDefined("attributes.department_id") and len(attributes.department_id))>
	<cfset attributes.department_id = "NULL">
</cfif>
<cfif not (isDefined("attributes.location_id") and len(attributes.location_id))>
	<cfset attributes.location_id = "NULL">
</cfif>
<cfif not (isDefined("attributes.ship_method") and len(attributes.ship_method))>
	<cfset attributes.ship_method = "NULL">
</cfif>
<cfif not (isDefined("attributes.paymethod_id") and len(attributes.paymethod_id))>
	<cfset attributes.paymethod_id = "NULL">
</cfif>
<cfif len(attributes.yuvarlama)>
	<cfquery name="get_yuvarlama_hesap" datasource="#new_dsn3#">
		SELECT * FROM SETUP_INVOICE_PURCHASE 
	</cfquery>
</cfif>
<cfif attributes.yuvarlama lt 0 >
	<cfset hesap_yuvarlama = get_yuvarlama_hesap.YUVARLAMA_GELIR >
<cfelse>
	<cfset hesap_yuvarlama = get_yuvarlama_hesap.YUVARLAMA_GIDER >	
</cfif>
