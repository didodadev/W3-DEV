<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
	<cfquery name="GET_ADDRESS" datasource="#DSN#">
		SELECT
			CB.COMPBRANCH_ID AS ADDRESS_ID,
			CB.COMPBRANCH_ID AS COMPBRANCH_ID,
			CB.COMPBRANCH__NAME AS ADRESS_NAME,
			CB.COMPBRANCH__NICKNAME AS COMPBRANCH_NICKNAME,
			CB.COMPBRANCH_ADDRESS ADDRESS,
			CB.COMPBRANCH_POSTCODE POSTCODE,
			CB.COUNTY_ID COUNTY,
			CB.CITY_ID CITY,
			CB.COUNTRY_ID COUNTRY,
			CB.SEMT SEMT,
			'' DISTRICT,		
			'' MAIN_STREET,
			'' STREET,
			'' ADDRESS_DETAIL
		FROM	
			COMPANY_BRANCH CB,
			COMPANY C
		WHERE 
			CB.COMPANY_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
			CB.COMPANY_ID = C.COMPANY_ID AND
			CB.COMPBRANCH_STATUS = 1 AND
			CB.COMPBRANCH_ADDRESS IS NOT NULL
	UNION ALL
		SELECT
			'-1' AS ADDRESS_ID,
			'' AS COMPBRANCH_ID,
			NICKNAME AS ADRESS_NAME,
			NICKNAME AS COMPBRANCH_NICKNAME,
			COMPANY_ADDRESS ADDRESS,
			COMPANY_POSTCODE POSTCODE,
			COUNTY COUNTY,
			CITY CITY,
			COUNTRY COUNTRY,
			SEMT SEMT,
			'' DISTRICT,		
			'' MAIN_STREET,
			'' STREET,
			'' ADDRESS_DETAIL
		FROM 
			COMPANY
		WHERE
			COMPANY_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
			COMPANY_STATUS = 1 
	</cfquery>
<cfelse>
	<cfquery name="GET_ADDRESS" datasource="#DSN#">
		SELECT 
			*
		FROM
		(
			SELECT
				'-2' AS ADDRESS_ID,
				'Ev' AS ADRESS_NAME,
				HOMEADDRESS ADDRESS,
				HOMEPOSTCODE POSTCODE,
				HOME_COUNTY_ID COUNTY,
				HOME_CITY_ID CITY,
				HOME_COUNTRY_ID COUNTRY,
				HOMESEMT SEMT,
				HOME_DISTRICT_ID DISTRICT,
				HOME_MAIN_STREET  MAIN_STREET,
				HOME_STREET  STREET,
				HOME_DOOR_NO ADDRESS_DETAIL	,	
				3 AS ADR_TYPE
			FROM 
				CONSUMER
			WHERE
				CONSUMER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
				CONSUMER_STATUS = 1 AND
				HOMEADDRESS IS NOT NULL
		UNION ALL
			SELECT
				'-1' AS ADDRESS_ID,
				'İş' AS ADRESS_NAME,
				WORKADDRESS ADDRESS,
				WORKPOSTCODE POSTCODE,
				WORK_COUNTY_ID COUNTY,
				WORK_CITY_ID CITY,
				WORK_COUNTRY_ID COUNTRY,
				WORKSEMT SEMT,
				WORK_DISTRICT_ID DISTRICT,
				WORK_MAIN_STREET  MAIN_STREET,
				WORK_STREET  STREET,
				WORK_DOOR_NO ADDRESS_DETAIL,
				2 AS ADR_TYPE
			FROM 
				CONSUMER
			WHERE
				CONSUMER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
				CONSUMER_STATUS = 1 AND
				WORKADDRESS IS NOT NULL
		UNION ALL
			SELECT
				CB.CONTACT_ID AS ADDRESS_ID,
				CB.CONTACT_NAME AS ADRESS_NAME,
				CB.CONTACT_ADDRESS ADDRESS,
				CB.CONTACT_POSTCODE POSTCODE,
				CB.CONTACT_COUNTY_ID COUNTY,
				CB.CONTACT_CITY_ID CITY,
				CB.CONTACT_COUNTRY_ID COUNTRY,
				CB.CONTACT_SEMT SEMT,
				CB.CONTACT_DISTRICT_ID DISTRICT,			
				CONTACT_MAIN_STREET  MAIN_STREET,
				CONTACT_STREET  STREET,
				CONTACT_DOOR_NO ADDRESS_DETAIL,												
				1 AS ADR_TYPE
			FROM	
				CONSUMER_BRANCH CB,
				CONSUMER C
			WHERE 
				CB.CONSUMER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
				CB.CONSUMER_ID = C.CONSUMER_ID AND
				CB.STATUS = 1 AND
				CB.CONTACT_ADDRESS IS NOT NULL
		)T1 
		ORDER BY
			ADR_TYPE DESC,ADRESS_NAME
	</cfquery>
</cfif>
<cfquery name="GET_CITY_ALL" datasource="#DSN#">
	SELECT CITY_ID, CITY_NAME FROM SETUP_CITY ORDER BY PRIORITY,CITY_NAME
</cfquery>
<cfquery name="GET_COUNTRY_ALL" datasource="#DSN#">
	SELECT COUNTRY_ID, COUNTRY_NAME FROM SETUP_COUNTRY ORDER BY COUNTRY_ID
</cfquery>
<cfset city_id_list="">
<cfset county_id_list="">
<cfset country_id_list="">
<cfif get_address.recordcount>
	<cfset city_id_list=listsort(valuelist(get_address.city,','),'numeric','ASC',',')>
	<cfset county_id_list=listsort(valuelist(get_address.county,','),'numeric','ASC',',')>
	<cfset country_id_list=listsort(valuelist(get_address.country,','),'numeric','ASC',',')>
	<cfif listlen(city_id_list)>
		<cfquery name="GET_CITY" dbtype="query">
			SELECT * FROM GET_CITY_ALL WHERE CITY_ID IN (#city_id_list#) ORDER BY CITY_ID
		</cfquery>
		<cfset city_list_id=valuelist(get_city.city_id,',')>
		<cfset city_name_list=valuelist(get_city.city_name,',')>
	<cfelse>
		<cfset city_name_list= ''>
	</cfif>
	<cfif listlen(county_id_list)>
		<cfquery name="GET_COUNTY" datasource="#dsn#">
			SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN (#county_id_list#) ORDER BY COUNTY_ID
		</cfquery>
		<cfset county_list_id=valuelist(get_county.county_id,',')>
		<cfset county_name_list=valuelist(get_county.county_name,',')>
	<cfelse>
		<cfset county_name_list= ''>
	</cfif>
	<cfif listlen(country_id_list)>
		<cfquery name="GET_COUNTRY" dbtype="query">
			SELECT COUNTRY_ID,COUNTRY_NAME FROM GET_COUNTRY_ALL WHERE COUNTRY_ID IN (#country_id_list#) ORDER BY COUNTRY_ID
		</cfquery>
		<cfset country_list_id=valuelist(get_country.country_id,',')>
		<cfset country_name_list=valuelist(get_country.country_name,',')>
	<cfelse>
		<cfset country_name_list= ''>
	</cfif>
</cfif>
<cfquery name="GET_CONSUMER_STAGE" datasource="#DSN#" maxrows="1">
	SELECT TOP 1
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		<cfif isDefined('session.ep.userid')>
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		<cfelseif isdefined("session.pp")>
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
		<cfelseif isdefined("session.ww")>
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
		</cfif>
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.form_add_consumer%">
	ORDER BY 
		PTR.LINE_NUMBER
</cfquery>
<!--- fatura adresleri icin --->
<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
	<cfquery name="GET_TAX_ADDRESS" datasource="#DSN#">
	SELECT
		TAX_ADRESS ADDRESS,
		TAX_POSTCODE POSTCODE,
		TAX_SEMT SEMT,
		TAX_COUNTY_ID COUNTY,
		TAX_CITY_ID CITY,
		TAX_COUNTRY_ID COUNTRY
	FROM 
		CONSUMER
	WHERE
		CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
		CONSUMER_STATUS = 1
	</cfquery>
<cfelseif isdefined("attributes.company_id") and len(attributes.company_id)>
	<cfquery name="GET_TAX_ADDRESS" datasource="#DSN#">
		SELECT
			COMPBRANCH_ADDRESS ADDRESS,
			COMPBRANCH_POSTCODE POSTCODE,
			COUNTY_ID COUNTY,
			CITY_ID CITY,
			COUNTRY_ID COUNTRY,
			SEMT SEMT
		FROM
			COMPANY_BRANCH 
		WHERE 
			COMPANY_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
			IS_INVOICE_ADDRESS = 1
	</cfquery>
	<cfif not get_tax_address.recordcount>
		<cfquery name="GET_TAX_ADDRESS" datasource="#DSN#">
			SELECT
				COMPANY_ADDRESS ADDRESS,
				COMPANY_POSTCODE POSTCODE,
				COUNTY COUNTY,
				CITY CITY,
				COUNTRY COUNTRY,
				SEMT SEMT
			FROM 
				COMPANY
			WHERE
				COMPANY_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
				COMPANY_STATUS = 1 
		</cfquery>
	</cfif>
</cfif> 	
