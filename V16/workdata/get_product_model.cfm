<cffunction name="get_product_model" access="public" returnType="query" output="no">
	<cfargument name="model_name" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="-1">
	<cfquery name="get_product_model" datasource="#dsn1#">
		SELECT 
			MODEL_ID,
			MODEL_NAME
		FROM 
			PRODUCT_BRANDS_MODEL
		WHERE			
			MODEL_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.model_name#%">
		ORDER BY 
			MODEL_NAME
	</cfquery>
	<cfreturn get_product_model>
</cffunction>

