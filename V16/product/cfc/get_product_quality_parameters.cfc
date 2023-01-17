<cfcomponent>
	<cffunction name="addQualityParameters" access="public" returntype="any">
		<cfargument name="product_cat_id" required="no" default="">
		<cfargument name="product_id" required="no" default="">
		<cfargument name="line_number" type="numeric" required="yes" default="">
		<cfargument name="inspection_level_id" type="numeric" required="no" default="">
		<cfargument name="min_quantity" type="numeric" required="yes" default="0">
		<cfargument name="max_quantity" type="numeric" required="yes" default="0">
		<cfargument name="sample_quantity" type="numeric" required="yes" default="0">
		<cfargument name="acceptance_quantity" type="numeric" required="yes" default="0">
		<cfargument name="rejection_quantity" type="numeric" required="yes" default="0">

		<cfquery name="add_Quality_Parameters" datasource="#dsn3#">
			INSERT INTO
				PRODUCT_QUALITY_PARAMETERS
			(
				PRODUCT_CAT_ID,
				PRODUCT_ID,
				LINE_NUMBER,
				INSPECTION_LEVEL_ID,
				MIN_QUANTITY,
				MAX_QUANTITY,
				SAMPLE_QUANTITY,
				ACCEPTANCE_QUANTITY,
				REJECTION_QUANTITY,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)
			VALUES
			(
				<cfif Len(arguments.product_cat_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_cat_id#"><cfelse>NULL</cfif>,
				<cfif Len(arguments.product_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.line_number#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.inspection_level_id#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.min_quantity#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.max_quantity#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.sample_quantity#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.acceptance_quantity#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.rejection_quantity#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="delQualityParameters" access="public" returntype="any">
		<cfargument name="qparameters_id" required="no" default="">
		<cfargument name="product_cat_id" required="no" default="">
		<cfargument name="product_id" required="no" default="">
		
		<cfquery name="del_Quality_Parameters" datasource="#dsn3#">
			DELETE FROM 
				PRODUCT_QUALITY_PARAMETERS
			WHERE
				<cfif isDefined("arguments.qparameters_id") and Len(arguments.qparameters_id)>
					QPARAMETERS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.qparameters_id#">
				<cfelseif isDefined("arguments.product_cat_id") and Len(arguments.product_cat_id)>
					PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_cat_id#">
				<cfelseif isDefined("arguments.product_id") and Len(arguments.product_id)>
					PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
				<cfelse>
					INSPECTION_LEVEL_ID IS NULL
				</cfif>
		</cfquery>
		<cfreturn true>
	</cffunction>

	<cffunction name="getQualityParameters" returntype="query">
		<cfargument name="qparameters_id" required="no" default="">
		<cfargument name="product_cat_id" required="no" default="">
		<cfargument name="product_id" required="no" default="">
		
		<cfquery name="get_Quality_Parameters" datasource="#dsn3#">
			SELECT 
				PRODUCT_CAT_ID,
				PRODUCT_ID,
				LINE_NUMBER,
				INSPECTION_LEVEL_ID,
				MIN_QUANTITY,
				MAX_QUANTITY,
				SAMPLE_QUANTITY,
				ACCEPTANCE_QUANTITY,
				REJECTION_QUANTITY,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			FROM 
				PRODUCT_QUALITY_PARAMETERS
			WHERE
				INSPECTION_LEVEL_ID IS NOT NULL
				<cfif isDefined("arguments.qparameters_id") and Len(arguments.qparameters_id)>
					AND QPARAMETERS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.qparameters_id#">
				</cfif>
				<cfif isDefined("arguments.product_cat_id") and Len(arguments.product_cat_id)>
					AND PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_cat_id#">
				</cfif>
				<cfif isDefined("arguments.product_id") and Len(arguments.product_id)>
					AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
				</cfif>
			ORDER BY
				PRODUCT_ID,
				PRODUCT_CAT_ID,
				LINE_NUMBER,
				INSPECTION_LEVEL_ID
		</cfquery>
		<cfreturn get_Quality_Parameters>
	</cffunction>
</cfcomponent>
