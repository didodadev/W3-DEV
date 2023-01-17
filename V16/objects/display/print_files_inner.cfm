<!-- sil -->
<div class="printThis" id="objects">
<cfsetting showdebugoutput="no">
<cfset upload_folder = application.systemParam.systemParam().upload_folder>
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
		SELECT TEMPLATE_FILE,FORM_ID,PROCESS_TYPE,IS_STANDART FROM SETUP_PRINT_FILES WHERE FORM_ID = #attributes.form_type# ORDER BY IS_XML,NAME
	</cfquery>
	<cfif isdefined("attributes.iid") and len(attributes.iid) and GET_FORM.PROCESS_TYPE eq 10>
		<cfquery name="GET_PRINT_COUNT" datasource="#dsn2#">
			SELECT PRINT_COUNT FROM INVOICE WHERE INVOICE_ID = #attributes.iid#
		</cfquery>
		<cfif len(GET_PRINT_COUNT.PRINT_COUNT)>
			<cfset PRINT_COUNT = GET_PRINT_COUNT.PRINT_COUNT + 1>
		<cfelse>
			<cfset PRINT_COUNT = 1>
		</cfif>	
		<cfquery name="UPD_PRINT_COUNT" datasource="#dsn2#">
			UPDATE INVOICE SET PRINT_COUNT = #PRINT_COUNT#,PRINT_DATE = #now()# WHERE INVOICE_ID = #attributes.iid#
		</cfquery>
	</cfif>	
	<cfif isdefined("attributes.action_id") and len(attributes.action_id) and GET_FORM.PROCESS_TYPE eq 30>
		<cfquery name="GET_PRINT_COUNT" datasource="#dsn2#">
			SELECT PRINT_COUNT FROM SHIP WHERE SHIP_ID = #attributes.action_id#
		</cfquery>
		<cfif len(GET_PRINT_COUNT.PRINT_COUNT)>
			<cfset PRINT_COUNT = GET_PRINT_COUNT.PRINT_COUNT + 1>
		<cfelse>
			<cfset PRINT_COUNT = 1>
		</cfif>	
		<cfquery name="UPD_PRINT_COUNT" datasource="#dsn2#">
			UPDATE SHIP SET PRINT_COUNT = #PRINT_COUNT#,PRINT_DATE = #now()# WHERE SHIP_ID = #attributes.action_id#
		</cfquery>
	</cfif>	
	<!--- Siparis print sayisi (stock emirler satis siparisi sayfasi print sayisini yazdirmak icin eklendi) Senay 20060704--->
	<cfif isdefined("attributes.action_id") and len(attributes.action_id) and GET_FORM.PROCESS_TYPE eq 73>
    
		<!--- siparis sayfalarindan alinan ciktilarin emirlerde etki yapmamasi icin eklendi FBS 20080916 --->
		<cfif isdefined("attributes.action_type") and attributes.action_type is "commands">
			<cfquery name="GET_PRINT_COUNT" datasource="#dsn3#">
				SELECT PRINT_COUNT FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
			</cfquery>
			<cfif len(GET_PRINT_COUNT.PRINT_COUNT)>
				<cfset PRINT_COUNT = GET_PRINT_COUNT.PRINT_COUNT + 1>
			<cfelse>
				<cfset PRINT_COUNT = 1>
			</cfif>	
			<cfquery name="UPD_PRINT_COUNT" datasource="#dsn3#">
				UPDATE ORDERS SET PRINT_COUNT = #PRINT_COUNT# WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
			</cfquery>
		</cfif>
	</cfif>
	<cfif isdefined("attributes.action_id") and len(attributes.action_id) and GET_FORM.PROCESS_TYPE eq 281>
		<cfquery name="GET_PRINT_COUNT" datasource="#dsn3#">
			SELECT PRINT_COUNT FROM PRODUCTION_ORDERS WHERE P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
		</cfquery>
		<cfif len(GET_PRINT_COUNT.PRINT_COUNT)>
			<cfset PRINT_COUNT = GET_PRINT_COUNT.PRINT_COUNT + 1>
		<cfelse>
			<cfset PRINT_COUNT = 1>
		</cfif>	
		<cfquery name="UPD_PRINT_COUNT" datasource="#dsn3#">
			UPDATE PRODUCTION_ORDERS SET PRINT_COUNT = #PRINT_COUNT# WHERE P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
		</cfquery>								
	</cfif>
	<cfif get_form.is_standart eq 1 and fileExists("#download_folder##get_form.template_file#")>
		<cfinclude template="/#get_form.template_file#">
	<cfelse>
		<cfif ListLast(get_form.template_file,'.') is 'xml'>
        	<cfinclude template="print_files_xml.cfm">
		<cfelseif fileExists("#upload_folder#settings/#get_form.template_file#")>
			<cfinclude template="#file_web_path#settings/#get_form.template_file#">
		<cfelse>
			<div style="text-align:center;padding:70px 0;"><h4><cf_get_lang dictionary_id='60110.Önizleme Yapılamıyor'>!</h4><h5><cf_get_lang dictionary_id='54834.Şablon Bulunamadı'>!</h5></div>
		</cfif>
	</cfif>
<cfelse>
	<div style="text-align:center;padding:70px 0;"><h4><cf_get_lang dictionary_id='32718.Otomatik Baskı Şablonu Oluşturulmamış'>!</h4></div>
</cfif>
</div>
<!-- sil -->
