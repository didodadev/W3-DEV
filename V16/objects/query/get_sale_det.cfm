<cfif isdefined("attributes.period_id") and len(attributes.period_id) >
	<cfquery name="get_period" datasource="#DSN#">
		SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = #attributes.period_id#
	</cfquery>
	<cfif database_type eq "MSSQL">
		<cfset db_adres = "#dsn#_#get_period.period_year#_#get_period.our_company_id#">
	<cfelseif database_type eq "DB2">
		<cfset db_adres = "#dsn#_#get_period.our_company_id#_#MID(get_period.period_year,3,2)#">
	</cfif>	
<cfelse>
	<cfset db_adres = "#dsn2#">
</cfif>
<cfscript>
	if (listfindnocase(partner_url,'#cgi.http_host#',';'))
	{
		attributes.company_id = session.pp.company_id;
	}
	else if (listfindnocase(server_url,'#cgi.http_host#',';') )
	{	
		if(isdefined('session.ww.company_id'))
			attributes.company_id = session.ww.company_id;
		else if(isdefined('session.ww.userid'))
			attributes.consumer_id = session.ww.userid;
	}
</cfscript>
<cfquery name="GET_SALE_DET" datasource="#db_adres#">
	SELECT
		*,
        SPC.INVOICE_TYPE_CODE
	FROM
		INVOICE,
        #dsn3_alias#.SETUP_PROCESS_CAT SPC
	WHERE
	  <cfif not isDefined("attributes.ID")>
		INVOICE_ID = #attributes.IID#
	  <cfelse>
		INVOICE_ID = #attributes.ID#
	  </cfif>
		AND INVOICE.PROCESS_CAT = SPC.PROCESS_CAT_ID 
	<cfif isdefined("attributes.company_id")>
		AND	COMPANY_ID = #attributes.company_id#
	<cfelseif isdefined("attributes.consumer_id")>
		AND CONSUMER_ID = #attributes.consumer_id#
	</cfif>
</cfquery>
<cfif not get_sale_det.recordcount>
	<script type="text/javascript">
		alert("Fatura No Bulunamadı! Kayıtları Kontrol Ediniz!");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfquery name="get_efatura_det" datasource="#dsn2#">
	SELECT 
		RECEIVING_DETAIL_ID
	FROM
		EINVOICE_RECEIVING_DETAIL
	WHERE
		INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_SALE_DET.INVOICE_ID#">
	ORDER BY
		RECEIVING_DETAIL_ID DESC
</cfquery>
<cfquery name="get_earchive_det" datasource="#db_adres#">
	SELECT 
		EARCHIVE_ID
	FROM
		EARCHIVE_RELATION
	WHERE
		ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_SALE_DET.INVOICE_ID#">
        AND ACTION_TYPE = 'INVOICE'
        AND ISNULL(STATUS,1) <> 0
</cfquery>
<cfif len(get_sale_det.company_id) and get_sale_det.company_id neq 0>
	<cfset comp="1"><!--- _sil bu satir ne ise yarar?? (gösteri sayfasında üyenin şirketmi bireysel üye mi olduğunu belirtir.)--->
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
			COUNTRY,
            USE_EFATURA,
            EFATURA_DATE
		FROM
			COMPANY
		WHERE 
			COMPANY.COMPANY_ID = #get_sale_det.company_id#
	</cfquery>
	<cfquery name="GET_SALE_DET_CONS" datasource="#DSN#">
		SELECT
			PARTNER_ID,
			COMPANY_PARTNER_NAME,
			COMPANY_PARTNER_SURNAME
		FROM
			COMPANY_PARTNER
		WHERE
			PARTNER_ID = #iif(len(get_sale_det.partner_id),get_sale_det.partner_id,0)#
	</cfquery>
<cfelseif len(get_sale_det.consumer_id) and get_sale_det.consumer_id neq 0>
	<cfquery name="GET_CONS_NAME" datasource="#DSN#">
		SELECT 
			*
		FROM 
			CONSUMER
		WHERE 
			CONSUMER_ID = #get_sale_det.consumer_id#
	</cfquery>
<cfelseif len(get_sale_det.employee_id) and get_sale_det.employee_id neq 0>
	<cfquery name="GET_EMP_NAME" datasource="#DSN#">
		SELECT 
			*
		FROM 
			EMPLOYEES
		WHERE 
			EMPLOYEE_ID = #get_sale_det.employee_id#
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
			EMPLOYEE_ID = #get_sale_det.deliver_emp#
	</cfquery>
</cfif>
<cfif GET_SALE_DET.recordcount>
	<cfquery name="GET_MONEY" datasource="#db_adres#">
		SELECT
			RATE1,
			RATE2,
			MONEY_TYPE,
			IS_SELECTED
		FROM
			INVOICE_MONEY
		WHERE
			<cfif not isDefined("attributes.ID")>
				ACTION_ID=#attributes.IID# AND
			<cfelse>
				ACTION_ID=#attributes.ID# AND
			</cfif>
				IS_SELECTED = 1
	</cfquery>
</cfif>

<cfif GET_SALE_DET.recordcount>
<cfquery name="GET_MONEY_INFO" datasource="#db_adres#">
	SELECT 
		RATE1,
		RATE2,
		MONEY_TYPE,
		IS_SELECTED
	FROM
		INVOICE_MONEY
	WHERE
		<cfif not isDefined("attributes.ID")>
			ACTION_ID=#attributes.IID# AND
		<cfelse>
			ACTION_ID=#attributes.ID# AND
		</cfif>
		MONEY_TYPE = '#GET_SALE_DET.OTHER_MONEY#' 
</cfquery>
<cfquery name="GET_MONEY_INFO_SEC" datasource="#db_adres#">
	SELECT 
		RATE1,
		RATE2,
		MONEY_TYPE,
		IS_SELECTED
	FROM
		INVOICE_MONEY
	WHERE
		<cfif not isDefined("attributes.ID")>
			ACTION_ID=#attributes.IID#
		<cfelse>
			ACTION_ID=#attributes.ID#
		</cfif>
</cfquery>
</cfif>
