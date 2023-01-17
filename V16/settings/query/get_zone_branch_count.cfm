<cfquery name="GET_ZONE_BRANCH_COUNT" datasource="#dsn#" maxrows="1">
	SELECT ZONE_ID FROM BRANCH WHERE ZONE_ID=#attributes.ID#
</cfquery>		

