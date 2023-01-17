<cffunction name="get_micro_zone_autocomplete" access="public" returntype="query" output="no">
	<cfargument name="microname" required="yes">
	<cfargument name="maxrows" required="yes">
	<cfquery name="get_micro_zone_autocomplete" datasource="#dsn#">
		SELECT 
			IMS_CODE ,
			IMS_CODE_NAME,
			IMS_CODE_ID,
			IMS_CODE + ' ' + IMS_CODE_NAME as NAME
		FROM 
			SETUP_IMS_CODE 	
		WHERE 
			IMS_CODE + ' ' + IMS_CODE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.microname#%">
	</cfquery>
	<cfreturn get_micro_zone_autocomplete>
</cffunction>



			
