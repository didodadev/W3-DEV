<cfquery name="GET_USER_GROUPS" datasource="#dsn#">
	SELECT * FROM USER_GROUP WHERE USER_GROUP_ID = #USER_GROUP_ID#
</cfquery>
