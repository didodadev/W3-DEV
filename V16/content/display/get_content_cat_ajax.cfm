<cfsetting showdebugoutput="no">
<cfquery name="GET_CHAPTER_HIER" datasource="#DSN#">
	SELECT DISTINCT
		CC.CONTENTCAT,
		CC.CONTENTCAT_ID,
		CH.CHAPTER_ID,
		CH.CHAPTER
	FROM
		CONTENT_CAT CC,
		CONTENT_CHAPTER CH
	WHERE
		CC.CONTENTCAT_ID = CH.CONTENTCAT_ID AND
		CC.LANGUAGE_ID = <cfif isdefined('attributes.type') and len(attributes.type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.type#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#"></cfif> AND
		CC.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY CCC WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">)
	ORDER BY
		CC.CONTENTCAT,
		CH.CHAPTER
</cfquery>
<select name="cat" id="cat" style="width:200px;"><option value=""><cf_get_lang no='32.İçerik Kategorisi'></option>
	<cfoutput query="get_chapter_hier" group="contentcat_id">
		<option value="cat-#contentcat_id#" <cfif isdefined("attributes.cat") and attributes.cat is "cat-#contentcat_id#">selected</cfif>>#contentcat#</option>
    	<cfoutput>
			<option value="ch-#chapter_id#" <cfif isdefined("attributes.cat") and attributes.cat is "ch-#chapter_id#">selected</cfif>>&nbsp;&nbsp;#chapter#</option>
    	</cfoutput>
	</cfoutput>
</select>

