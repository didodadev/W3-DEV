<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
	<cfquery name="GET_HELP" datasource="#DSN#">
		SELECT 
			SUBJECT,
			PROCESS_STAGE,
			CUS_HELP_ID
		FROM
			CUSTOMER_HELP
		WHERE
			CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cus_help_id#">
	</cfquery>
	<cfquery name="DEL_HELP" datasource="#DSN#">
		DELETE 
			CUSTOMER_HELP
		WHERE 
			CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cus_help_id#">
	</cfquery>
	<cfquery name="GET_ASSET" datasource="#DSN#">
		SELECT ASSET_FILE_NAME,ASSETCAT_ID FROM ASSET WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cus_help_id#"> AND MODULE_NAME = 'call'
	</cfquery>
	<cfif get_asset.recordcount and Len(get_asset.assetcat_id)>
		<cfquery name="GET_ASSETCAT_PATH" datasource="#DSN#">
			SELECT ASSETCAT_PATH FROM ASSET_CAT WHERE ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_asset.assetcat_id#">
		</cfquery>
        <cfif company_asset_relation eq 1>
			<cfset assetcat_path = get_assetcat_path.assetcat_path>
        <cfelse>
        	<cfif get_asset.assetcat_id gte 0>
        		<cfset assetcat_path = "asset/#get_assetcat_path.assetcat_path#">
            <cfelse>
        		<cfset assetcat_path = get_assetcat_path.assetcat_path>            
            </cfif>
        </cfif>
		<cfquery name="DEL_ASSET" datasource="#DSN#">
			DELETE ASSET WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cus_help_id#"> AND MODULE_NAME = 'call'
		</cfquery>
	</cfif>
	<cfif isdefined('get_asset.asset_file_name') and len(get_asset.asset_file_name)>
		<cffile action="delete" file="#upload_folder##assetcat_path##dir_seperator##get_asset.asset_file_name#">
	</cfif>
	<cf_add_log log_type="-1" action_id="#attributes.cus_help_id#" action_name="Etkileşim: #get_help.subject#" process_stage="#get_help.process_stage#" paper_no="#get_help.cus_help_id#">
	</cftransaction>
</cflock>
<script type="text/javascript">
	<!---window.location.href="<cfoutput>#request.self#?fuseaction=call.helpdesk&form_submitted=1</cfoutput>";--->
	window.location.href="<cfoutput>#request.self#?fuseaction=call.helpdesk&event=list&form_submitted=1</cfoutput>";
</script>
