<cflock name="#CREATEUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="DEL_TEAM" datasource="#dsn#">
			DELETE FROM SALES_ZONES_TEAM_ROLES WHERE TEAM_ID = #attributes.team_id#
		</cfquery>
		<cfquery name="DEL_TEAM_IMS" datasource="#dsn#">
			DELETE FROM SALES_ZONES_TEAM_IMS_CODE WHERE TEAM_ID = #attributes.team_id#
		</cfquery>
		<cfquery name="DEL_SALES_ZONES_TEAM_DETAIL" datasource="#dsn#">
			DELETE FROM SALES_ZONES_TEAM WHERE TEAM_ID = #attributes.team_id#
		</cfquery>
        <cfquery name="DEL_TEAM_ZONES_COUNTY" datasource="#dsn#">
			DELETE FROM SALES_ZONES_TEAM_COUNTY WHERE TEAM_ID = #attributes.team_id#
		</cfquery>
         <cfquery name="DEL_TEAM_ZONES_DISTRICT" datasource="#dsn#">
			DELETE FROM SALES_ZONES_TEAM_DISTRICT WHERE TEAM_ID = #attributes.team_id#
		</cfquery>
	</cftransaction>
</cflock>
<cfset actionId = attributes.team_id>
<script type="text/javascript">
	window.location='<cfoutput>#request.self#?fuseaction=salesplan.list_sales_team</cfoutput>';
</script>
