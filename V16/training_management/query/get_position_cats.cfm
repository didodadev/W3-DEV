<cfquery name="GET_POSITION_CATS" datasource="#DSN#">
	SELECT POSITION_CAT, POSITION_CAT_ID FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT
</cfquery>