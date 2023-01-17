<cffunction name="get_asset_autocomplete" access="public" returnType="query" output="no">
	<cfargument name="asset_name" required="yes" type="string">
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
			EMPLOYEE_ID = #session.ep.userid#
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
			ASSET_CAT.ASSETCAT,
			ASSET_CAT.ASSETCAT_PATH,
			ASSET_DETAIL AS DESCRIPTION,
			ASSET.ASSETCAT_ID,
			ASSET.PROPERTY_ID
		FROM 
			ASSET,
			ASSET_CAT
		WHERE
			ASSET.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID AND
			MODULE_ID IN (#ids#) AND
			COMPANY_ID IN (#valuelist(get_position_companies.our_company_id,',')#)
			<cfif isdefined("arguments.asset_name") and len(arguments.asset_name)>
				AND
				(
					ASSET.ASSET_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.asset_name#%"> OR
					ASSET.ASSET_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.asset_name#%">
				)
			</cfif>
		ORDER BY
			ASSET.RECORD_DATE DESC						
	</cfquery>
	<cfreturn GET_ASSETS>
</cffunction>
