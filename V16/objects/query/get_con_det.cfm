<cfif isdefined("attributes.cons_id")>
	<cfset con_id = attributes.cons_id>
</cfif>
<cfquery name="DETAIL_CON" datasource="#DSN#">
	SELECT 
		CONSUMER_ID,
		CONSUMER_NAME,
		CONSUMER_SURNAME,
		CONSUMER_EMAIL,
		CONSUMER_USERNAME,
		MEMBER_CODE,
		IMCAT_ID,
		IM,
		MOBIL_CODE,
		MOBILTEL,
		CONSUMER_WORKTELCODE,
		CONSUMER_WORKTEL,
		CONSUMER_TEL_EXT,
		WORKADDRESS,
		WORKPOSTCODE,
		WORKSEMT,
		WORK_COUNTY_ID,
		WORK_CITY_ID,
		WORK_COUNTRY_ID,
		HOMEADDRESS,
		HOMEPOSTCODE,
		HOMESEMT,
		HOME_COUNTY_ID,
		HOME_CITY_ID,
		HOME_COUNTRY_ID,
		CONSUMER_FAXCODE,
		CONSUMER_FAX,
		TITLE,
		COMPANY,
		HOMEPAGE,
		PICTURE,
		PICTURE_SERVER_ID,
		CONSUMER_CAT_ID,
		REF_POS_CODE,
		(
        SELECT 
			POSITION_CODE 
		FROM 
			WORKGROUP_EMP_PAR 
		WHERE 
			CONSUMER_ID IS NOT NULL AND
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#con_id#"> AND
			<cfif isdefined('session.ep.userid')>
				OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
			<cfelseif isdefined('session.pp.userid')>
				OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
			<cfelseif isdefined('session.ww.userid')>
				OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
			</cfif>
			IS_MASTER = 1
        ) POSITION_CODE        
	FROM
		CONSUMER
	WHERE
		CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#con_id#">
</cfquery>
<cfquery name="GET_CONSUMER_CAT" datasource="#dsn#">
	SELECT 
		CONSCAT
	FROM 
		CONSUMER_CAT
	WHERE
		CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#detail_con.consumer_cat_id#"> 
</cfquery>

