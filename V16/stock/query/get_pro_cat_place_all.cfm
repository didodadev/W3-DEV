<cfquery name="get_pro_cat_place" datasource="#DSN3#">
	SELECT
		P.*,
		PC.PRODUCT_CATID, 
		PC.HIERARCHY, 
		PC.PRODUCT_CAT, 
		D.DEPARTMENT_HEAD
	FROM
		PRODUCT_CAT_PLACE P,
		PRODUCT_CAT PC,
		#dsn_alias#.DEPARTMENT D
	WHERE
		1=1
		AND P.PRODUCT_CATID=PC.PRODUCT_CATID
		AND D.DEPARTMENT_ID=P.DEPARTMENT_ID
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND  (P.DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
			OR PC.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
			OR PC.PRODUCT_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
			OR D.DEPARTMENT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
			)
		</cfif>
		<cfif isDefined("attributes.store") and len(attributes.store)>
			AND P.DEPARTMENT_ID =#attributes.store#
		</cfif>
		<cfif session.ep.isBranchAuthorization>
			AND P.DEPARTMENT_ID IN ( SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT D,#dsn_alias#.BRANCH B WHERE B.BRANCH_ID=D.BRANCH_ID AND B.BRANCH_ID=#ListGetAt(session.ep.user_location,2,"-")#)
		</cfif>
</cfquery>	
