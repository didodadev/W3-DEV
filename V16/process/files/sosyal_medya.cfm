<cfif isDefined("attributes.process_stage") and isDefined("attributes.action_id")>
	<cfquery name="UPD_S" datasource="#CALLER.DSN#">
		UPDATE SOCIAL_MEDIA_REPORT SET IS_PUBLISH = 1 WHERE SID=#attributes.action_id#
	</cfquery>
</cfif>

