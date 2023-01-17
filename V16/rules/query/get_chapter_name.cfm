<cfquery name="GET_CHAPTER_NAME" datasource="#DSN#">
	SELECT
		CH.CHAPTER,
		CH.CHAPTER_ID,
		CC.CONTENTCAT
	FROM
		CONTENT_CHAPTER CH,
		CONTENT_CAT CC
	WHERE
		CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.chapter_id#"> AND
		CH.CONTENTCAT_ID = CC.CONTENTCAT_ID
</cfquery>