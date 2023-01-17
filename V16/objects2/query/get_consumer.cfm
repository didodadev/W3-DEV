<cfquery name="GET_CONS_REF_CODE" datasource="#DSN#">
	SELECT CONSUMER_REFERENCE_CODE,CONSUMER_CAT_ID FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
</cfquery>
<cfquery name="GET_CAMP_ID" datasource="#DSN3#">
	SELECT 
		CAMP_ID,
		CAMP_HEAD
	FROM 
		CAMPAIGNS 
	WHERE 
		CAMP_STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
		CAMP_FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
</cfquery>
<cfif get_camp_id.recordcount>
	<cfquery name="GET_LEVEL" datasource="#DSN3#">
		SELECT ISNULL(MAX(PREMIUM_LEVEL),0) AS PRE_LEVEL FROM SETUP_CONSCAT_PREMIUM WHERE CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_cons_ref_code.consumer_cat_id#"> AND CAMPAIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_camp_id.camp_id#">
	</cfquery>
	<cfset ref_count = get_level.pre_level + listlen(get_cons_ref_code.consumer_reference_code,'.')>
<cfelse>
	<cfset ref_count = 0>
</cfif>
<cfquery name="GET_CONSUMER" datasource="#DSN#">
	SELECT 
		CONSUMER_ID,
		REF_POS_CODE,
		MEMBER_CODE,
		CONSUMER_NAME,
		CONSUMER_SURNAME,
		CONSUMER_CAT_ID,
		CONSUMER_USERNAME,
		TIMEOUT_LIMIT,
		CONSUMER_EMAIL,
		MOBIL_CODE,
		MOBILTEL,
		MOBIL_CODE_2,
		MOBILTEL_2,
		CONSUMER_HOMETELCODE,
		CONSUMER_HOMETEL,
		CONSUMER_WORKTELCODE,
		CONSUMER_WORKTEL,
		HOMEPAGE,
		BIRTHPLACE,
		EDUCATION_ID,
		SEX,
		CHILD,
		MARRIED,
		BIRTHDATE,
		PICTURE,
		TC_IDENTY_NO,
		NATIONALITY,
		PICTURE_SERVER_ID,
		COMPANY ,
		SECTOR_CAT_ID,
		TITLE,
		VOCATION_TYPE_ID,
		MISSION,
		COMPANY_SIZE_CAT_ID,
		DEPARTMENT,
        HOME_DISTRICT,
		HOME_DISTRICT_ID,
		HOME_COUNTRY_ID,
		HOME_CITY_ID,
		HOME_MAIN_STREET,
		HOME_COUNTY_ID,
		HOME_STREET,
		HOMESEMT,
		HOME_DOOR_NO,
		HOMEPOSTCODE,
		HOMEADDRESS,
        WORK_DISTRICT,
		WORK_DISTRICT_ID,
		WORK_CITY_ID,
		WORK_MAIN_STREET,
		WORK_COUNTY_ID,
		WORK_STREET,
		WORKSEMT,
		WORK_DOOR_NO,
		WORKPOSTCODE,
		WORKADDRESS,
        TAX_DISTRICT,
		TAX_DISTRICT_ID,
		TAX_OFFICE,
		TAX_NO,
		TAX_ADRESS,
		TAX_COUNTRY_ID,
		TAX_CITY_ID,
		TAX_MAIN_STREET,
		TAX_COUNTY_ID,
		TAX_STREET,
		TAX_SEMT,
		TAX_DOOR_NO,
	    TAX_POSTCODE,      
		WORK_COUNTRY_ID 
	FROM 
		CONSUMER
	WHERE 
		<cfif isdefined("attributes.cid") and len(attributes.cid)>
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">
		<cfelse>
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
		</cfif>
		AND CONSUMER_STATUS = 1
		AND 
		(
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> OR
			(
				REF_POS_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> OR 
				(
					CONSUMER_REFERENCE_CODE IS NOT NULL
					AND '.'+CONSUMER_REFERENCE_CODE+'.' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#session.ww.userid#.%">
					AND (LEN(REPLACE(CONSUMER_REFERENCE_CODE,'.','..'))-LEN(CONSUMER_REFERENCE_CODE)+1) < = <cfqueryparam cfsqltype="cf_sql_integer" value="#ref_count#">
				)
			)
		)
</cfquery>
