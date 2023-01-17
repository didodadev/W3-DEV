<cfquery name="get_expense_cat_list" datasource="#dsn2#">
	SELECT 
		#dsn#.Get_Dynamic_Language(EXPENSE_CAT_ID,'#session.ep.language#','EXPENSE_CATEGORY','EXPENSE_CAT_NAME',NULL,NULL,EXPENSE_CAT_NAME) AS EXPENSE_CAT_NAME,
		*
	FROM
		EXPENSE_CATEGORY
	WHERE
		1=1
		<cfif isdefined("attributes.cat_id")>
			AND EXPENSE_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cat_id#">
		</cfif>
		<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
			AND EXPENSE_CAT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
		</cfif>
		<cfif isdefined('attributes.kategory_secim') and len(attributes.kategory_secim) and kategory_secim is 'ik'>
			AND EXPENCE_IS_HR = 1
		</cfif>
		<cfif isdefined('attributes.kategory_secim') and len(attributes.kategory_secim) and kategory_secim is 'eg'>
			AND EXPENCE_IS_TRAINING = 1
		</cfif>
	ORDER BY
		EXPENSE_CAT_CODE
</cfquery>

