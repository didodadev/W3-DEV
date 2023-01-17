<cfquery name="GET_CATEGORY_CONTENTS" datasource="#DSN#">
	SELECT DISTINCT	TOP 5	
        C.OUTHOR_EMP_ID,
        C.OUTHOR_CONS_ID,
        C.OUTHOR_PAR_ID		
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
        C.OUTHOR_EMP_ID	 DESC
</cfquery>

<h2>Öne Çıkan Yazarlar</h2>
<cfoutput query="get_category_contents">
    <div>
        <cfif len(OUTHOR_EMP_ID)>
            #get_emp_info(OUTHOR_EMP_ID,0,0)#    
        <cfelseif len(OUTHOR_PAR_ID)>
            #get_cons_info(OUTHOR_PAR_ID,1,0)#
        <cfelseif len(OUTHOR_CONS_ID)>
            #get_cons_info(OUTHOR_CONS_ID,1,0)#
        </cfif>
    </div>
</cfoutput>

