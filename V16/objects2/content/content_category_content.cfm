<cfquery name="GET_CATEGORY_CONTENTS" datasource="#DSN#">
	SELECT TOP 5
		CCAT.CONTENTCAT_ID,
		CCAT.CONTENTCAT,
		C.CONTENT_ID,
		CH.CHAPTER_ID,
		CH.CHAPTER,
		C.CONT_HEAD,
        C.CONT_SUMMARY,
        C.CONT_BODY,
        C.HIT_PARTNER,
        C.HIT_EMPLOYEE		
    FROM
		CONTENT C,
		CONTENT_CAT CCAT,
		CONTENT_CHAPTER CH
    WHERE
		C.CHAPTER_ID = CH.CHAPTER_ID AND
		CH.CONTENTCAT_ID = CCAT.CONTENTCAT_ID AND
		CCAT.CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CONTENTCAT_ID#"> AND
        C.STAGE_ID = -2 AND
		C.CONTENT_STATUS = 1
    ORDER BY
        C.HIT_PARTNER DESC, C.HIT_EMPLOYEE
</cfquery>

<h2>Öne Çıkan İçerikler</h2>
<cfoutput query="GET_CATEGORY_CONTENTS">
    <h3>#CONT_HEAD#</h3>
    <div>
        #cont_summary#
    </div>
    <div>
        #CONT_BODY#
    </div>
</cfoutput>