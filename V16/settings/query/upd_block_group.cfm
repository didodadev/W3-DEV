<cfset attributes.level_id = "">
<cfloop from="1" to="6" index="loop_level">
	<cfif IsDefined("attributes.level_id_#loop_level#")>
		<cfset attributes.level_id = ListAppend(attributes.level_id,1)>
	<cfelse>
		<cfset attributes.level_id = ListAppend(attributes.level_id,0)>
	</cfif>
</cfloop>
<cftransaction>
	<cfquery name="UPD_BLOCK_GROUP" datasource="#dsn#">
		UPDATE
			 BLOCK_GROUP
		SET
			BLOCK_GROUP_NAME = '#attributes.block_group_name#',
			BLOCK_GROUP_PERMISSIONS = '#attributes.level_id#',
			UPDATE_DATE = #NOW()#,
			UPDATE_EMP = #SESSION.EP.USERID#,
			UPDATE_IP = '#CGI.REMOTE_ADDR#'
		WHERE
			BLOCK_GROUP_ID = #attributes.group_id#
	</cfquery>
</cftransaction>
<script>
	location.href=document.referrer;
</script>
