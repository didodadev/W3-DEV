<cfquery name="DEL_USER_GROUP" datasource="#DSN#">
	DELETE FROM USER_GROUP WHERE USER_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.user_group_id#">
</cfquery>

<cfquery name="GET_LANGS" datasource="#dsn#">
	SELECT
    	LANGUAGE_SHORT
	FROM
    	SETUP_LANGUAGE
</cfquery>

<cfset attributes.actionId = attributes.user_group_id>
<cfoutput query="GET_LANGS">
    <cftry>
    	<cffile action="delete" file="#upload_folder#personal_settings#dir_seperator#userGroup_#LANGUAGE_SHORT#_#attributes.actionId#.json">
    <cfcatch></cfcatch>
    </cftry>
</cfoutput>
<cfset attributes.spa = 1>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=#nextEvent#</cfoutput>';
</script>
