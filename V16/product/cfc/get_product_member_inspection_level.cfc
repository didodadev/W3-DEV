<cfcomponent>
	<cffunction name="addProductMemberInspectionLevel" access="public" returntype="any">
		<cfargument name="product_cat_id" required="no" default="">
		<cfargument name="product_id" required="no" default="">
		<cfargument name="inspection_level_id" type="numeric" required="no" default="">
		<cfargument name="company_id" type="numeric" required="no" default="">

		<cfquery name="add_Product_Member_Inspection_Level" datasource="#dsn3#">
			INSERT INTO
				PRODUCT_MEMBER_INSPECTION_LEVEL
			(
				PRODUCT_ID,
				PRODUCT_CAT_ID,
				INSPECTION_LEVEL_ID,
				COMPANY_ID,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)
			VALUES
			(
				<cfif Len(arguments.product_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"><cfelse>NULL</cfif>,
				<cfif Len(arguments.product_cat_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_cat_id#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.inspection_level_id#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="delProductMemberInspectionLevel" access="public" returntype="any">
		<cfargument name="pmil_id" required="no" default="">
		<cfargument name="product_cat_id" required="no" default="">
		<cfargument name="product_id" required="no" default="">
		
		<cfquery name="del_Product_Member_Inspection_Level" datasource="#dsn3#">
			DELETE FROM 
				PRODUCT_MEMBER_INSPECTION_LEVEL
			WHERE
				<cfif isDefined("arguments.pmil_id") and Len(arguments.pmil_id)>
					PMIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pmil_id#">
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

	<cffunction name="getProductMemberInspectionLevel" returntype="query">
		<cfargument name="pmil_id" required="no" default="">
		<cfargument name="product_cat_id" required="no" default="">
		<cfargument name="product_id" required="no" default="">
		
		<cfquery name="get_Product_Member_Inspection_Level" datasource="#dsn3#">
			SELECT 
				PMIL_ID,
				PRODUCT_ID,
				PRODUCT_CAT_ID,
				INSPECTION_LEVEL_ID,
				COMPANY_ID,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			FROM 
				PRODUCT_MEMBER_INSPECTION_LEVEL
			WHERE
				INSPECTION_LEVEL_ID IS NOT NULL
				<cfif isDefined("arguments.pmil_id") and Len(arguments.pmil_id)>
					AND PMIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pmil_id#">
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
				INSPECTION_LEVEL_ID
		</cfquery>
		<cfreturn get_Product_Member_Inspection_Level>
	</cffunction>
</cfcomponent>
