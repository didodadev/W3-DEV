<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="DEL_ORGANIZATION" datasource="#DSN#">
			DELETE FROM 
				ORGANIZATION
			WHERE
				ORGANIZATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.org_id#">
		</cfquery>
		
		<cfquery name="DEL_SITE_DOMAIN" datasource="#DSN#">
			DELETE FROM ORGANIZATION_SITE_DOMAIN WHERE ORGANIZATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.org_id#">
		</cfquery>
	</cftransaction>
</cflock>
<cfif isdefined("attributes.called_campaign_id")>
	<cflocation url="#request.self#?fuseaction=campaign.list_campaign&event=upd&camp_id=#attributes.called_campaign_id#" addtoken="no">
<cfelseif isdefined("attributes.caller_project_id")>
	<cflocation url="#request.self#?fuseaction=project.projects&event=det&id=#attributes.caller_project_id#" addtoken="no">
<cfelse>
	<cflocation url="#request.self#?fuseaction=campaign.list_campaign" addtoken="no">
</cfif>


