<cfquery name="get_images" datasource="#DSN#" maxrows="1">
	SELECT
		*
	FROM
		CONTENT_BANNERS
	WHERE
		CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#"> AND
		START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
	ORDER BY
		START_DATE DESC
</cfquery>

<cfif not get_images.recordcount>   
	<cfquery name="get_chapter_contantcat" datasource="#DSN#">
		SELECT 
			CC.CONTENTCAT_ID,
			CH.CHAPTER_ID
		FROM
			CONTENT_CHAPTER CH,
			CONTENT_CAT CC,
			CONTENT C
		WHERE
			C.CHAPTER_ID = CH.CHAPTER_ID AND
			CH.CONTENTCAT_ID = CC.CONTENTCAT_ID AND
			CONTENT_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">
	</cfquery>
	   
	<cfquery name="get_images" datasource="#DSN#" maxrows="1">
		SELECT
			*
		FROM
			CONTENT_BANNERS
		WHERE
			CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_chapter_contantcat.chapter_id#"> AND
			START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
		ORDER BY
			START_DATE DESC
	</cfquery>
	<cfif not get_images.RECORDCOUNT>
		<cfquery name="get_images" datasource="#DSN#" maxrows="1">
			SELECT
				*
			FROM
				CONTENT_BANNERS
			WHERE
				CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_chapter_contantcat.contentcat_id#"> AND
				START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			ORDER BY
				START_DATE DESC
		</cfquery>
	</cfif>   
</cfif>
