<cfset dsn = application.systemParam.systemParam().dsn />
<cffunction name="getAllProperty" returntype="query">
	<cfargument name="keyword" type="string" default="">
    <cfargument name="our_company" type="string" default="">
    <cfargument name="is_active" type="string" default="">
    <cfargument name="is_web" type="string" default="">
	<cfquery name="GET_PROPERTY_CAT" datasource="#this.DSN1#">
		WITH CTE1 AS
			(SELECT 
				PP.PROPERTY_ID,
				#dsn#.#dsn#.Get_Dynamic_Language(PP.PROPERTY_ID,'#ucase(session.ep.language)#','PRODUCT_PROPERTY','PROPERTY',NULL,NULL,PROPERTY) AS PROPERTY,
				PP.PROPERTY_CODE, 
					(SELECT 
						COUNT(PRPT_ID) 
					FROM 
						PRODUCT_PROPERTY_DETAIL PPD 
					WHERE 
						PPD.PRPT_ID=PP.PROPERTY_ID) COUNT_PROPERTY_ID 
			 FROM 
			 	PRODUCT_PROPERTY PP 
			 WHERE 
			 	1=1
	<cfif IsDefined( "arguments.keyword") and len(arguments.keyword)>
   		AND (PROPERTY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR 
   		PROPERTY_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR 
   		PROPERTY_ID IN(SELECT PRPT_ID FROM PRODUCT_PROPERTY_DETAIL WHERE PROPERTY_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI) )
	</cfif>
	<cfif isdefined( "arguments.our_company") and len(arguments.our_company)>
   		AND PROPERTY_ID IN (SELECT PROPERTY_ID FROM PRODUCT_PROPERTY_OUR_COMPANY WHERE OUR_COMPANY_ID = #arguments.our_company#)
 	</cfif>
	<cfif isdefined( "arguments.is_active") and len(arguments.is_active) and arguments.is_active neq 2>
		AND PP.IS_ACTIVE=#arguments.is_active#
	</cfif>
	<cfif isDefined('arguments.is_web') and len(arguments.is_web) and arguments.is_web neq 2>
		AND PP.IS_INTERNET = #arguments.is_web#
	</cfif>),
		CTE2 AS 
			( SELECT 
				CTE1.*, ROW_NUMBER() OVER (ORDER BY CTE1.PROPERTY ASC) AS RowNum, 
			(SELECT
		 		COUNT(*) 
		 	FROM 
		 		CTE1) AS QUERY_COUNT FROM CTE1 ) 
			SELECT 
				CTE2.* 
			FROM 
				CTE2 
			WHERE 	
				RowNum BETWEEN ( ((#this.page# - 1) * #this.maxrows# )+ 1) AND #this.page#*#this.maxrows#
	</cfquery>
	<cfreturn GET_PROPERTY_CAT>
</cffunction>
