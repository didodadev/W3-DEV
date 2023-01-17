<cfquery name="GET_BRANCH_DEP_COUNT" datasource="#dsn#" maxrows="1">
	SELECT BRANCH_ID FROM DEPARTMENT WHERE BRANCH_ID=#attributes.ID#
</cfquery>		

