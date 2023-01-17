<!--- 
	gonderilen departman ve lokasyon bilgilerine uygun aktif rafları listeler. baskette de calısıyor
	kullanim        : get_shelf_info( shelf_code, maxrow,deparment_id, location_id) 
	OZDEN20070926
 --->
<cffunction name="get_shelf_info" access="public" returnType="query" output="no">
	<cfargument name="shelf_code_" required="yes" type="string" default="">
	<cfargument name="maxrows" required="yes" type="string" default="">
	<cfargument name="shelf_dept_id" default="">
	<cfargument name="shelf_loc_id" default="">
	<cfif len(arguments.maxrows)>
		<cfquery name="get_shelf_info_" datasource="#dsn3#" maxrows="#arguments.maxrows#">
			SELECT
				PRODUCT_PLACE_ID,
				SHELF_CODE
			FROM 
				PRODUCT_PLACE
			WHERE
				PLACE_STATUS=1
				<cfif len(arguments.shelf_dept_id)>
				AND STORE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.shelf_dept_id#">
				</cfif>
				<cfif len(arguments.shelf_loc_id)>
				AND LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.shelf_loc_id#">
				</cfif> 
				<cfif len(arguments.shelf_code_)>
				AND SHELF_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.shelf_code_#%">
				</cfif>
			ORDER BY
				SHELF_CODE
		</cfquery>
	<cfelse>
		<cfquery name="get_shelf_info_" datasource="#dsn3#">
			SELECT
				PRODUCT_PLACE_ID,
				SHELF_CODE
			FROM 
				PRODUCT_PLACE
			WHERE
				PLACE_STATUS=1
				<cfif len(arguments.shelf_dept_id)>
				AND STORE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.shelf_dept_id#">
				</cfif>
				<cfif len(arguments.shelf_loc_id)>
				AND LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.shelf_loc_id#">
				</cfif> 
				<cfif len(arguments.shelf_code_)>
				AND SHELF_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.shelf_code_#%">
				</cfif>
			ORDER BY
				SHELF_CODE
		</cfquery>
	</cfif>
	<cfreturn get_shelf_info_>
</cffunction>
