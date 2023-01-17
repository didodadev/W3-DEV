<cfquery name="GET_BADWORDS" datasource="#DSN#">
	SELECT
		WORD,
		'***' AS STAR
	FROM
		SETUP_FORUM_FILTER
</cfquery>
<cfset badword_list = valuelist(get_badwords.word)>
<cfset star_list = valuelist(get_badwords.star)>

