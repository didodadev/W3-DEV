<cfscript>
    ids = "";
	module = 1;
	for(ind = 1 ; ind lte ListLen(session.ep.user_level,",") ; ind = ind + 1){		
		if (ListGetAt(session.ep.user_level, ind))	ids = ids & "," & module;
		module = module + 1;
	}
	ids = Right(ids,(Len(ids) - 1));
</cfscript>

<!--- Yetkili olduğum tüm şirketlerin dijital varlıklarını çekebilmek için --->
<cfquery name="GET_POSITION_COMPANIES" datasource="#DSN#">
	SELECT 
	DISTINCT
		SP.OUR_COMPANY_ID,
		O.NICK_NAME
	FROM
		EMPLOYEE_POSITIONS EP,
		SETUP_PERIOD SP,
		EMPLOYEE_POSITION_PERIODS EPP,
		OUR_COMPANY O
	WHERE 
		SP.OUR_COMPANY_ID = O.COMP_ID AND
		SP.PERIOD_ID = EPP.PERIOD_ID AND
		EP.POSITION_ID = EPP.POSITION_ID AND
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
</cfquery>
<!--- Yetkili olduğum tüm şirketlerin dijital varlıklarını çekebilmek için --->

<cfquery name="GET_ASSETS" datasource="#DSN#">
		SELECT
        	ASSET.ASSET_NO,
		    ASSET.MODULE_NAME,
		    ASSET.ACTION_SECTION,
		    ASSET.ACTION_ID,
			ASSET.ASSET_ID,
			ASSET.ASSET_NAME,
			ASSET.ASSET_FILE_NAME,
			ASSET.ASSET_FILE_REAL_NAME,
			ASSET.ASSET_FILE_SERVER_ID,
			ASSET.ASSET_FILE_SIZE,
			ASSET.RECORD_EMP,
			ASSET.RECORD_PAR,
			ASSET.RECORD_PUB,
			ASSET.RECORD_DATE,
			ASSET.UPDATE_DATE,
			ASSET.UPDATE_EMP,
			ASSET.UPDATE_PAR,
			ASSET_CAT.ASSETCAT,
			ASSET_CAT.ASSETCAT_PATH,
			ASSET_DETAIL AS DESCRIPTION,
			ASSET.ASSETCAT_ID,
			ASSET.PROPERTY_ID,
			ASSET.EMBEDCODE_URL
		FROM 
			ASSET,
			ASSET_CAT
		WHERE
			<cfif isdefined("attributes.our_company_id") and len(attributes.our_company_id)>COMPANY_ID = #attributes.our_company_id# AND</cfif>
			ASSET.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID AND
			MODULE_ID IN (#ids#) AND
			COMPANY_ID IN (#valuelist(get_position_companies.our_company_id,',')#)
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND
			(
				ASSET.ASSET_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                ASSET.ASSET_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                 <!--- OR
				ASSET.ASSET_FILE_NAME LIKE '%#attributes.keyword#%' --->
			)
			</cfif>
			<cfif isDefined("attributes.format") and len(attributes.format)>
				AND ASSET.ASSET_FILE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.format#%">
			</cfif>
			<cfif isDefined("attributes.assetcat_id") and len(attributes.assetcat_id)>
				AND ASSET.ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetcat_id#">
			</cfif>
			<cfif isDefined("attributes.property_id") and len(attributes.property_id)>
				AND ASSET.PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.property_id#">
			</cfif>
		ORDER BY
			ASSET.RECORD_DATE DESC						
</cfquery>
