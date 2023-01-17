<cfcomponent>
	<cffunction name="addProductQualityTypes" access="public" returntype="any">
		
		<cfargument name="product_cat_id" required="no" default="">
		<cfargument name="product_id" required="no" default="">
		<cfargument name="quality_type_id" default="">
		<cfargument name="operation_type_id" required="no" default="">
		<cfargument name="order_no" required="no" default="">
		<cfquery name="add_Product_Quality_Types" datasource="#dsn3#">
			INSERT INTO
				PRODUCT_QUALITY
			(
				PRODUCT_CAT_ID,
				PRODUCT_ID,
				QUALITY_TYPE_ID,
				OPERATION_TYPE_ID,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP,
				ORDER_NO,
				PROCESS_CAT	
			
			)
			VALUES     
			(
				<cfif Len(arguments.product_cat_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_cat_id#"><cfelse>NULL</cfif>,
				<cfif Len(arguments.product_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"><cfelse>NULL</cfif>,
				<cfif Len(arguments.quality_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.quality_type_id#"><cfelse>NULL</cfif>,
				<cfif Len(arguments.operation_type_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.operation_type_id#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				<cfif Len(arguments.order_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.order_no#"><cfelse>NULL</cfif>,
				<cfif Len(arguments.process_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_cat#"><cfelse>NULL</cfif>
				
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="delProductQualityTypes" access="public" returntype="any">
		<cfargument name="product_cat_id" required="no" default="">
		<cfargument name="product_id" required="no" default="">
		
		<cfquery name="del_Product_Quality_Types" datasource="#dsn3#">
			DELETE FROM 
				PRODUCT_QUALITY
			WHERE
				<cfif isDefined("arguments.product_cat_id") and Len(arguments.product_cat_id)>
					PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_cat_id#">
				<cfelseif isDefined("arguments.product_id") and Len(arguments.product_id)>
					PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
				<cfelse>
					QUALITY_RULE IS NULL
				</cfif>
		</cfquery>
		<cfreturn true>
	</cffunction>

	<cffunction name="getProductQualityTypes" returntype="query">
		<cfargument name="product_cat_id" required="no" default="">
		<cfargument name="product_id" required="no" default="">
		
		<cfquery name="get_Product_Quality_Types" datasource="#dsn3#">
			SELECT 
				PRODUCT_CAT_ID,
				PRODUCT_ID,
				QUALITY_TYPE_ID,
				OPERATION_TYPE_ID,
				ORDER_NO,
				DEFAULT_VALUE,
				TOLERANCE,
				TOLERANCE_2,
				QUALITY_RULE,
				PROCESS_CAT,
				QUALITY_SAMPLE_NUMBER,
				QUALITY_SAMPLE_METHOD,
				QUALITY_SAMPLE_TYPE,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			FROM 
				PRODUCT_QUALITY
			WHERE
				1=1
				<cfif isDefined("arguments.product_cat_id") and Len(arguments.product_cat_id)>
					AND PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_cat_id#">
				</cfif>
				<cfif isDefined("arguments.product_id") and Len(arguments.product_id)>
					AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
				</cfif>
			ORDER BY
				PRODUCT_ID,
				PRODUCT_CAT_ID,
				ISNULL(ORDER_NO,0),
				QUALITY_TYPE_ID
		</cfquery>
		<cfreturn get_Product_Quality_Types>
	</cffunction>
</cfcomponent>
