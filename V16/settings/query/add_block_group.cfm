<cfset attributes.level_id = "">
<cfloop from="1" to="6" index="loop_level">
	<cfif IsDefined("attributes.level_id_#loop_level#")>
		<cfset attributes.level_id = ListAppend(attributes.level_id,1)>
	<cfelse>
		<cfset attributes.level_id = ListAppend(attributes.level_id,0)>
	</cfif>
</cfloop>
<cftransaction>
	<cfquery name="ADD_BLOCK_GROUP" datasource="#dsn#">
		INSERT INTO BLOCK_GROUP
			(
			BLOCK_GROUP_NAME,
			BLOCK_GROUP_PERMISSIONS,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
			)
		VALUES
			(
			'#attributes.block_group_name#',
			'#attributes.level_id#',
			 #NOW()#,
			 #SESSION.EP.USERID#,
			'#CGI.REMOTE_ADDR#'
			)
	</cfquery>
</cftransaction>
<cflocation url="#request.self#?fuseaction=settings.form_add_block_group" addtoken="no">
