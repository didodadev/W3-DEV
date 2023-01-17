<cfquery name="GET_BADWORDS" datasource="#DSN#">
	SELECT
		WORD
	FROM
		SETUP_FORUM_FILTER
</cfquery>
<cfset badword_list = valuelist(get_badwords.word)>


