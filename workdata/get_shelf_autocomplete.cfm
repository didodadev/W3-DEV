<cffunction name="get_shelf_autocomplete" access="public" returntype="query" output="no">
	<cfargument name="name" required="yes">
	<cfargument name="maxrows" required="yes">
	<cfargument name="extra_params" required="no" default="">
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn3="#dsn#_#session.ep.company_id#">
	<cfset dsn_alias="#dsn#">
	<cfquery name="get_shelf_1" datasource="#dsn3#">
		SELECT
			DISTINCT
			(SELECT SSS.SHELF_NAME FROM #DSN_ALIAS#.SHELF SSS WHERE SSS.SHELF_ID = PP.SHELF_TYPE) AS SHELF_NAME,
			PP.SHELF_TYPE AS SHELF_ID,
			D.DEPARTMENT_HEAD,
			SL.COMMENT,
			PP.PRODUCT_PLACE_ID,
			PP.PRODUCT_ID,
			PP.STORE_ID,
			PP.LOCATION_ID,
			PP.SHELF_TYPE,
			PP.SHELF_CODE,
			PP.QUANTITY,
			PP.DETAIL,
			PP.START_DATE,
			PP.FINISH_DATE,
			PP.RECORD_DATE
		FROM
			PRODUCT_PLACE PP,
			<cfif isdefined('attributes.shelf_product_id') and len(attributes.shelf_product_id)>
			PRODUCT_PLACE_ROWS PPR,
			</cfif>
			#dsn_alias#.DEPARTMENT D,
			#dsn_alias#.STOCKS_LOCATION SL
		WHERE 
			 PP.PLACE_STATUS=1
			 AND PP.STORE_ID = D.DEPARTMENT_ID
			 AND D.DEPARTMENT_ID = SL.DEPARTMENT_ID 
			 AND PP.LOCATION_ID = SL.LOCATION_ID
			 <cfif isdefined('attributes.shelf_product_id') and len(attributes.shelf_product_id)>
				AND PP.PRODUCT_PLACE_ID = PPR.PRODUCT_PLACE_ID
			 </cfif>
             <cfif isdefined('attributes.extra_params') and listLen(attributes.extra_params) gt 1>
				AND PP.STORE_ID = '#listGetat(attributes.extra_params,2)#'
             </cfif>
			 AND D.IS_STORE=1
			 <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
				AND 
				(
					PP.SHELF_CODE LIKE '%#attributes.keyword#%' OR
					PP.SHELF_TYPE IN (SELECT SHELF_ID FROM #dsn_alias#.SHELF WHERE SHELF_NAME LIKE '%#attributes.keyword#%')
				)
			 </cfif>
			<cfif isdefined("attributes.location_id") and len(attributes.location_id)>
				AND PP.LOCATION_ID = #attributes.location_id#
			</cfif>
			<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
				AND PP.STORE_ID = #attributes.department_id#
			</cfif>
			<cfif isdefined('attributes.shelf_product_id') and len(attributes.shelf_product_id)><!--- rn iin tanimlanmis raflari getirebilmek iin eklendi --->
				AND PPR.PRODUCT_ID = #attributes.shelf_product_id#
			</cfif>
		ORDER BY PP.SHELF_CODE
	</cfquery>
	<cfquery name="get_shelf_autocomplete" dbtype="query">
		SELECT 
			SHELF_CODE + ' ' + SHELF_NAME AS NAME,
			SHELF_NAME,
			SHELF_ID
		FROM 
			get_shelf_1
		WHERE
			SHELF_CODE + ' - ' + SHELF_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#%">
			<cfif isdefined("attributes.store_id") and len(attributes.store_id)>
				AND PP.LOCATION_ID = #attributes.store_id#
			</cfif>
	</cfquery>
	<cfreturn get_shelf_autocomplete>
</cffunction>
