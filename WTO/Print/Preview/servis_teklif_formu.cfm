<!--- servis teklif formu --->
<cfquery name="our_company" datasource="#dsn#">
	SELECT 
		ASSET_FILE_NAME3,
		ASSET_FILE_NAME3_SERVER_ID,
		COMPANY_NAME,
		TEL_CODE,
		TEL,TEL2,
		TEL3,
		TEL4,
		FAX,
		TAX_OFFICE,
		TAX_NO,
		ADDRESS,
		WEB,
		EMAIL
	FROM 
	    OUR_COMPANY 
	WHERE 
	   COMP_ID = <cfif isDefined("SESSION.EP.COMPANY_ID")>#SESSION.EP.COMPANY_ID#<cfelseif isDefined("SESSION.PP.COMPANY")>#SESSION.PP.COMPANY#</cfif>
</cfquery>
<cfquery name="get_service" datasource="#dsn3#">
	SELECT * FROM SERVICE WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>
<cfif len(get_service.service_company_id)>
	<cfquery name="get_adres" datasource="#dsn#">
		SELECT
			 COMPANY_ADDRESS AS ADRES,
			 SEMT AS SEMT,
			 COMPANY_TELCODE AS TELCODE,
			 COMPANY_TEL1 AS TEL,
			 TAXOFFICE AS TAX,
			 TAXNO AS TAXNO,
			 COUNTY AS COUNTY,
			 CITY AS CITY,
			 COUNTRY AS COUNTRY
		FROM  
			 COMPANY
		WHERE 
			 COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service.service_company_id#">
	</cfquery>
<cfelseif len(get_service.service_consumer_id)>
	<cfquery name="get_adres" datasource="#dsn#">
		SELECT
			 WORKADDRESS AS ADRES,
			 WORKSEMT AS SEMT,
			 CONSUMER_WORKTELCODE AS TELCODE,
			 CONSUMER_WORKTEL AS TEL,
			 TAX_OFFICE AS TAX,
			 TAX_NO AS TAXNO,
			 WORK_COUNTY_ID AS COUNTY,
			 WORK_CITY_ID AS CITY,
			 WORK_COUNTRY_ID AS COUNTRY
		FROM  
			 CONSUMER
		WHERE 
			 CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service.service_consumer_id#">
	</cfquery>
</cfif>
<cfif len(get_adres.county)>
	<cfquery name="get_county" datasource="#dsn#">
		SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_adres.county#">
	</cfquery>
</cfif>
<cfif len(get_adres.city)>
	<cfquery name="get_city" datasource="#dsn#">
		SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_adres.city#">
	</cfquery> 
</cfif>
<cfif len(get_service.subscription_id)>
	<cfquery name="get_subscription" datasource="#dsn3#">
		SELECT * FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID IS NOT NULL AND SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service.subscription_id#">
	</cfquery>
</cfif>
<cfquery name="get_service_plus" datasource="#dsn3#">
	SELECT * FROM SERVICE_PLUS WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>
<cfquery name="get_service_operation" datasource="#dsn3#">
	SELECT TOTAL_PRICE SYSTEM_TOTAL_PRICE,AMOUNT,CURRENCY FROM SERVICE_OPERATION WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>
<cfset service_operation_total = 0>
<cfset service_operation_money = ''>
<cfset adam_gun = 0>
<cfif get_service_operation.recordcount>
	<cfoutput query="get_service_operation">
		<cfset service_operation_total = service_operation_total + SYSTEM_TOTAL_PRICE>
		<cfset adam_gun = adam_gun + amount>
		<cfset service_operation_money = currency>
	</cfoutput>
</cfif>
<cf_woc_header>
<cfoutput   query="get_service">
	<cf_woc_elements>
		<cf_wuxi id="item_service_no" data="#service_no#"  label="57487" type="cell">
		<cf_wuxi id="item_apply_date" data="#dateformat(APPLY_date,dateformat_style)#"  label="57742" type="cell">
		<cf_wuxi id="service_consumer_id" data="#iif(len(service_consumer_id),'get_cons_info(service_consumer_id,0,0)', DE(''))# #iif(len(service_company_id),'get_par_info(service_company_id,1,1,0)', DE(''))#"  label="57457" type="cell">
		<cf_wuxi id="applicator_name" data="#get_service.applicator_name#"  label="57578" type="cell">
		<cf_wuxi id="county" data="#iif(len(get_adres.county),'get_county.county_name',DE('-'))#  #iif(len(get_adres.city),'get_city.city_name',DE('-'))#"  label="58723" type="cell">
		<cf_wuxi id="city" data="#iif(len(get_adres.county),'get_county.county_name',DE('-'))#  #iif(len(get_adres.city),'get_city.city_name',DE('-'))#"  label="58723" type="cell">
		<cf_wuxi id="adres_tel" data="#get_adres.telcode# - #get_adres.tel#"  label="57499" type="cell">
		<cf_wuxi id="tax_office" data="#get_adres.tax#"  label="58762" type="cell">
		<cf_wuxi id="tax_no" data="#get_adres.taxno#"  label="57752" type="cell">
		<cfset new_detail = replace(service_detail,'#chr(13)#','<br/>','all')>
		<cf_wuxi id="details" data="#service_head# #new_detail#"  label="57480" type="cell">
	</cf_woc_elements>   
</cfoutput>
</br></br>
<cf_woc_elements>
	<cfsavecontent variable="aa"><cf_get_lang dictionary_id='33324.Yukarıdaki düzenlemeyi yapabilmek için firmamız'></cfsavecontent>
	<cfsavecontent variable="ab"><cf_get_lang dictionary_id='33325.Adam/Gün karşılığında'></cfsavecontent>
	<cfsavecontent variable="ac"><cf_get_lang dictionary_id='33328.KDV talep etmektedir'>. <br/><cf_get_lang dictionary_id='33327.Bu tutarı onaylıyorsanız, lütfen bildiriniz'>.</cfsavecontent>
	<cf_wuxi id="nnn_type" data="#aa# #adam_gun# #ab# #TLFormat(service_operation_total)# #service_operation_money# #ac#" type="cell">
</cf_woc_elements>  
<cf_woc_elements>
	<cf_wuxi id="xx" data=""  label="57457+57500" type="cell">
	<cf_wuxi id="yy" data="&nbsp;"  label="57457+57578" type="cell">
	<cf_wuxi id="zz" data="&nbsp;"  label="57742" type="cell">
</cf_woc_elements> 
<cf_woc_footer>