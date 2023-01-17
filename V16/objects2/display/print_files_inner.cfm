<cfsetting showdebugoutput="no">
<style>
	@media print
	{
		html,body {background: white;}
		table{font-size: 10px;font-family:Geneva, Verdana, tahoma, arial,  Helvetica, sans-serif;}
		tr{font-size: 10px;font-family:Geneva, Verdana, tahoma, arial,  Helvetica, sans-serif;}
		td{font-size: 10px;font-family:Geneva, Verdana, tahoma, arial,  Helvetica, sans-serif;}
	}
	
	@media screen
	{
		html,body{height: 100%;width:100%;}
		table{font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif;color: #333333;}
		tr{font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif;color : #333333;}
		td{font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif;color : #333333;}
	}
</style>

<cfif isdefined("attributes.form_type")>
	<cfquery name="GET_FORM" datasource="#dsn3#">
		SELECT TEMPLATE_FILE,FORM_ID,PROCESS_TYPE,IS_STANDART FROM SETUP_PRINT_FILES WHERE FORM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.form_type#">
	</cfquery>
	<cfif isdefined("attributes.iid") and len(attributes.iid) and get_form.process_type eq 10>
		<cfquery name="GET_PRINT_COUNT" datasource="#dsn2#">
			SELECT PRINT_COUNT FROM INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
		</cfquery>
		<cfif len(get_print_count.print_count)>
			<cfset print_count = get_print_count.print_count + 1>
		<cfelse>
			<cfset print_count = 1>
		</cfif>	
		<cfquery name="UPD_PRINT_COUNT" datasource="#dsn2#">
			UPDATE INVOICE SET PRINT_COUNT = <cfqueryparam cfsqltype="cf_sql_integer" value="#print_count#"> WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
		</cfquery>								
	</cfif>								
	<!--- Siparis print sayisi (stock emirler satis siparisi sayfasi print sayisini yazdirmak icin eklendi) Senay 20060704--->
	<cfif isdefined("attributes.action_id") and len(attributes.action_id) and get_form.process_type eq 73>
		<cfquery name="GET_PRINT_COUNT" datasource="#dsn3#">
			SELECT PRINT_COUNT FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
		</cfquery>
		<cfif len(get_print_count.print_count)>
			<cfset print_count = get_print_count.print_count + 1>
		<cfelse>
			<cfset print_count = 1>
		</cfif>	
		<cfquery name="UPD_PRINT_COUNT" datasource="#dsn3#">
			UPDATE ORDERS SET PRINT_COUNT = <cfqueryparam cfsqltype="cf_sql_integer" value="#print_count#"> WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
		</cfquery>								
	</cfif>								
	<cfif isdefined("attributes.action_id") and len(attributes.action_id) and get_form.process_type eq 281>
		<cfquery name="GET_PRINT_COUNT" datasource="#dsn3#">
			SELECT PRINT_COUNT FROM PRODUCTION_ORDERS WHERE P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
		</cfquery>
		<cfif len(get_print_count.print_count)>
			<cfset print_count = get_print_count.print_count + 1>
		<cfelse>
			<cfset print_count = 1>
		</cfif>	
		<cfquery name="UPD_PRINT_COUNT" datasource="#dsn3#">
			UPDATE PRODUCTION_ORDERS SET PRINT_COUNT = <cfqueryparam cfsqltype="cf_sql_integer" value="#print_count#"> WHERE P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
		</cfquery>								
	</cfif>		
	<cfif get_form.is_standart eq 1>
		<cfinclude template="../../#get_form.template_file#">
	<cfelse>	
		<cfinclude template="#file_web_path#settings/#get_form.template_file#">
	</cfif>
<cfelse>
	<cf_get_lang no='363.Otomatik Baskı Şablonu Oluşturulmamış'>!
</cfif>
