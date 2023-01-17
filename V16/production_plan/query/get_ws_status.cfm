<cfquery name="get_status1" datasource="#DSN#">
	select
			*
	FROM
		WORKSTATIONS_STATUS
	<cfif isdefined('attributes.STATUS_ID')>
		WHERE
			WS_STATUS_ID=#attributes.STATUS_ID#
	</cfif>	
	<cfif isdefined('attributes.keyword')>
		WHERE 
			WS_STATUS_NAME like '%#attributes.keyword#%'
	</cfif>
	
</cfquery>
