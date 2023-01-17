<cfif isdefined("attributes.period_id") and len(attributes.period_id)>
	<cfquery name="GET_PERIOD" datasource="#DSN#">
		SELECT PERIOD_YEAR, OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
	</cfquery>
	<cfif get_period.recordcount>
		<cfset db_adres = "#dsn#_#get_period.period_year#_#get_period.our_company_id#">
	<cfelse>
		<cfset db_adres = "#dsn2#">
	</cfif>
<cfelse>
	<cfset db_adres = "#dsn2#">
</cfif>

<cfquery name="GET_SALE_DET" datasource="#db_adres#">
	SELECT
		COMPANY_ID,
        PARTNER_ID,
        CONSUMER_ID,
        DELIVER_EMP,
        OTHER_MONEY,
        DEPARTMENT_ID,
        SHIP_METHOD,
        PAY_METHOD,
        PURCHASE_SALES,
        CARD_PAYMETHOD_ID,
        INVOICE_NUMBER,
        INVOICE_CAT,
        INVOICE_ID,
        INVOICE_DATE,
        NOTE,
        GROSSTOTAL,
        SA_DISCOUNT,
        ROUND_MONEY,
        NETTOTAL,
        TAXTOTAL    
	FROM
		INVOICE
	WHERE
	<cfif not isDefined("attributes.id")>
        INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.iid#">
    <cfelse>
        INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
    </cfif>
</cfquery>
<cfif not get_sale_det.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1496.Fatura No Bulunamadı! Kayıtları Kontrol Ediniz'>!");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfif len(get_sale_det.company_id) and get_sale_det.company_id neq 0>
	<cfset comp="1">
	<cfquery name="GET_SALE_DET_COMP" datasource="#DSN#">
		SELECT 
			COMPANY_ID,
			TAXOFFICE,
			TAXNO,
			COMPANY_ADDRESS,
			FULLNAME,
			SEMT,
			COMPANY_POSTCODE,
			COUNTY,
			CITY,
			COUNTRY
		FROM
			COMPANY
		WHERE 
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sale_det.company_id#">
	</cfquery>
	<cfquery name="GET_SALE_DET_CONS" datasource="#DSN#">
		SELECT
			PARTNER_ID,
			COMPANY_PARTNER_NAME,
			COMPANY_PARTNER_SURNAME
		FROM
			COMPANY_PARTNER
		WHERE
			PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#iif(len(get_sale_det.partner_id),get_sale_det.partner_id,0)#">
	</cfquery>
<cfelseif len(get_sale_det.consumer_id) and get_sale_det.consumer_id neq 0>
	<cfquery name="GET_CONS_NAME" datasource="#DSN#">
		SELECT 
			CONSUMER_NAME,
			CONSUMER_SURNAME,
			TAX_ADRESS,
			TAX_NO,
			TAX_SEMT,
			TAX_POSTCODE,
			TAX_COUNTY_ID,
			TAX_CITY_ID,
			TAX_COUNTRY_ID
		FROM 
			CONSUMER
		WHERE 
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sale_det.consumer_id#">
	</cfquery>		
</cfif>
<cfif len(get_sale_det.deliver_emp) and get_sale_det.purchase_sales eq 0>
	<cfquery name="GET_SALE_DET_DELIVER_EMP" datasource="#DSN#">
		SELECT
			POSITION_ID,
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME
		FROM
			EMPLOYEE_POSITIONS
		WHERE
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sale_det.deliver_emp#">
	</cfquery>
</cfif>
<cfif get_sale_det.recordcount>
    <cfquery name="GET_MONEY_INFO" datasource="#db_adres#">
        SELECT 
            RATE1,
            RATE2,
            MONEY_TYPE,
            IS_SELECTED
        FROM
            INVOICE_MONEY
        WHERE
		<cfif not isDefined("attributes.id")>
            ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
        <cfelse>
            ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
        </cfif>
            AND MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_sale_det.other_money#"> 
    </cfquery>
</cfif>
