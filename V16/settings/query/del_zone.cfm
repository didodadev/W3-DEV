<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
	<cfquery name="DELZONE" datasource="#dsn#">
		DELETE 
		FROM 
			ZONE 
		WHERE 
			ZONE_ID=#ZONE_ID#
	</cfquery>
	<cf_add_log  log_type="-1" action_id="#attributes.zone_id#" action_name="#attributes.head# ">
	</cftransaction>
</cflock>
<cfif isdefined("attributes.hr")>
	<cflocation url="#request.self#?fuseaction=hr.list_zones&hr=1" addtoken="no">
<cfelse>
	<cflocation url="#request.self#?fuseaction=settings.list_zones" addtoken="no">
</cfif>

