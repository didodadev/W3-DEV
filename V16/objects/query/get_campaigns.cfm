<cfif isdefined("attributes.compid")>
	<cfset dsn3 = "#dsn#_#attributes.compid#">
</cfif>
<cfquery name="CAMPAIGNS" datasource="#DSN3#">
	SELECT
		CAMPAIGNS.CAMP_ID,
		CAMPAIGNS.CAMP_CAT_ID,
		CAMPAIGNS.CAMP_NO,
		CAMPAIGNS.CAMP_STATUS,
		CAMPAIGNS.CAMP_HEAD,
		CAMPAIGNS.PROJECT_ID,
		CAMPAIGNS.CAMP_STAGE_ID,
		CAMPAIGNS.CAMP_STARTDATE,
		CAMPAIGNS.CAMP_FINISHDATE,
		CAMPAIGNS.CAMP_OBJECTIVE,
		CAMPAIGNS.LEADER_EMPLOYEE_ID
	FROM
		CAMPAIGNS
	WHERE
		CAMPAIGNS.OUR_COMPANY_ID = <cfif isdefined("attributes.compid")>#attributes.compid#<cfelse>#session.ep.company_id#</cfif>
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND 
		(
			CAMPAIGNS.CAMP_NO LIKE '%#attributes.keyword#%'
			OR
			CAMPAIGNS.CAMP_HEAD LIKE '%#attributes.keyword#%'
			OR
			CAMPAIGNS.CAMP_OBJECTIVE LIKE '%#attributes.keyword#%'
		)
	</cfif>
	<cfif isDefined("attributes.tarih_kontrol") and (attributes.tarih_kontrol eq 1)>
		AND CAMPAIGNS.CAMP_FINISHDATE >= #now()#
	</cfif>
	<cfif isdefined("attributes.camp_type") and  len(attributes.camp_type) and listlen(attributes.camp_type,'_') eq 2>
		AND	CAMPAIGNS.CAMP_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.camp_type,2,'_')#">
	<cfelseif isdefined("attributes.camp_type") and  len(attributes.camp_type)>
		AND	CAMPAIGNS.CAMP_CAT_ID IN (SELECT CAMP_CAT_ID FROM CAMPAIGN_CATS WHERE CAMP_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_type#">)
	</cfif>
	<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id)>
		AND CAMP_ID IN(SELECT CR.CAMP_ID FROM CAMPAIGN_RELATION CR WHERE CR.SUBSCRIPTION_ID = #attributes.subscription_id#)
	</cfif>
    <cfif isDefined("attributes.is_active") and attributes.is_active neq 2>
		AND CAMP_STATUS = #attributes.is_active#
	</cfif>
	ORDER BY  
		CAMPAIGNS.CAMP_STARTDATE DESC
</cfquery>
