<cfquery name="GET_CHAPTER_MENU" datasource="#DSN#">
	SELECT 
		CHAPTER_ID,
        CHAPTER 
	FROM 
		CONTENT_CHAPTER
	WHERE 
		CONTENTCAT_ID IN 
		(
            SELECT
                CONTENTCAT_ID
            FROM
                CONTENT_CAT
            WHERE
                CONTENTCAT_ID <> 0 AND
                LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
		)
	ORDER BY 
		HIERARCHY
</cfquery>

