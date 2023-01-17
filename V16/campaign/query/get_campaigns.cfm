<cfquery name="CAMPAIGNS" datasource="#DSN3#">
	SELECT
		CAMPAIGNS.CAMP_ID,
		CAMPAIGNS.CAMP_CAT_ID,
		CAMPAIGNS.CAMP_NO,
		CAMPAIGNS.CAMP_STATUS,
		CAMPAIGNS.CAMP_HEAD,
		CAMPAIGNS.CAMP_STAGE_ID,
		CAMPAIGNS.PROCESS_STAGE,
		CAMPAIGNS.CAMP_STARTDATE,
		CAMPAIGNS.CAMP_FINISHDATE,
		CAMPAIGNS.LEADER_EMPLOYEE_ID
	FROM
		CAMPAIGNS
	<cfif isDefined("attributes.camp_type") and (attributes.camp_type neq 0)>
		,CAMPAIGN_CATS
	</cfif>
WHERE
    CAMPAIGNS.OUR_COMPANY_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.COMPANY_ID#"> 
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND
		(
			CAMPAIGNS.CAMP_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
			CAMPAIGNS.CAMP_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
			CAMPAIGNS.CAMP_OBJECTIVE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
		)
	</cfif>
	<cfif isdefined("attributes.camp_type") and  len(attributes.camp_type) and listlen(attributes.camp_type,'_') eq 2>
		AND	CAMPAIGNS.CAMP_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.camp_type,2,'_')#">
	<cfelseif isdefined("attributes.camp_type") and  len(attributes.camp_type)>
		AND	CAMPAIGNS.CAMP_CAT_ID IN (SELECT CAMP_CAT_ID FROM CAMPAIGN_CATS WHERE CAMP_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_type#">)
	</cfif>
	<cfif isDefined("attributes.camp_type") and (attributes.camp_type neq 0)>
		AND	CAMPAIGNS.CAMP_CAT_ID = CAMPAIGN_CATS.CAMP_CAT_ID
	</cfif>
	<cfif isDefined("attributes.is_active") and len(attributes.is_active)>
		AND	CAMPAIGNS.CAMP_STATUS = #attributes.is_active#
	</cfif>	
	<cfif isdefined("attributes.member_name") and len(attributes.member_name)><!--- Lider --->
		<cfif isdefined('attributes.emp_id') and len(attributes.emp_id) and attributes.member_type eq 'employee'>
			AND CAMPAIGNS.LEADER_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#"> 
		</cfif>
		<cfif isdefined('attributes.par_id') and len(attributes.par_id) and attributes.member_type eq 'partner'>
			AND CAMPAIGNS.LEADER_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.par_id#">
		</cfif>
		<cfif isdefined('attributes.cons_id') and len(attributes.cons_id) and attributes.member_type eq 'consumer'>
			AND CAMPAIGNS.LEADER_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cons_id#">
		</cfif>
	</cfif>
	<cfif len(attributes.start_dates)>AND CAMP_STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.start_dates)#"> </cfif>
	<cfif len(attributes.finish_dates)>AND CAMP_STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.finish_dates)#"> </cfif>
	ORDER BY 	
		CAMPAIGNS.CAMP_STARTDATE DESC
</cfquery>
