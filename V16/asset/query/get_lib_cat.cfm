<cfquery name="DEP" datasource="#DSN#">
	SELECT 
		DEPARTMENT.DEPARTMENT_ID, 
		DEPARTMENT.DEPARTMENT_HEAD, 
		DEPARTMENT.ADMIN1_POSITION_CODE,
		DEPARTMENT.ADMIN2_POSITION_CODE,
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID
	FROM 
		DEPARTMENT,
		BRANCH
	WHERE 
		BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
	ORDER BY
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD
</cfquery>
<cfquery name="GET_LIB_CAT" datasource="#DSN#">
	SELECT LIBRARY_CAT FROM LIBRARY_CAT ORDER BY LIBRARY_CAT
</cfquery>
<cfquery name="GET_LIB_ASSET" datasource="#DSN#">
	SELECT
		LA.LIB_ASSET_ID,
		LA.LIB_ASSET_CAT,
		LA.LIB_ASSET_NAME,
		LA.LIB_ASSET_PUB,
		LA.DEPARTMENT_ID,
		LA.WRITER,
		LA.IMAGE_PATH	
	FROM
		LIBRARY_ASSET LA
		LEFT JOIN LIBRARY_ASSET_RESERVE LAR ON LAR.LIBRARY_ASSET_ID = LA.LIB_ASSET_ID
	WHERE 1=1
	<cfif len(attributes.keyword)>	 
		AND	LA.LIB_ASSET_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
	</cfif>
	<cfif len(attributes.DEPARTMENT_ID)>
		AND LA.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.DEPARTMENT_ID#">
	</cfif>
	<cfif len(attributes.lib_cat_id)>
		AND	LA.LIB_ASSET_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.lib_cat_id#">
	</cfif>
	<cfif len(attributes.rez_status)>
		<cfif attributes.rez_status eq 1 or attributes.rez_status eq 2>
			AND	LAR.STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.rez_status#">
		<cfelseif attributes.rez_status eq 0>
			AND	LAR.STATUS in (0,3)
		</cfif>
	</cfif>
	<cfif len(attributes.writer)>
		AND	LA.WRITER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.writer#%">
	</cfif>
	<cfif len(attributes.publisher)>
		AND	LA.LIB_ASSET_PUB LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.publisher#%">
	</cfif>
	<cfif len(attributes.barcode_no)>
		AND	LA.BARCODE_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.barcode_no#%">
	</cfif>
	GROUP BY 
		LA.LIB_ASSET_ID,
		LA.LIB_ASSET_CAT,
		LA.LIB_ASSET_NAME,
		LA.LIB_ASSET_PUB,
		LA.DEPARTMENT_ID,
		LA.WRITER,
		LA.IMAGE_PATH	
	ORDER BY 
		LA.LIB_ASSET_NAME
</cfquery>

