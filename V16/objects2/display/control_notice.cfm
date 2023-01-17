<cfquery name="GET_NOTICE" datasource="#DSN#" maxrows="1">
	SELECT
		C.CONTENT_ID
	FROM
		CONTENT C,
		CONTENT_CHAPTER CH,
		CONTENT_CAT CCAT
	WHERE 
		<cfif isdefined("session.ww.language")>
			CCAT.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.language#"> AND
		<cfelseif isdefined("session.pp.language")>
			CCAT.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.language#"> AND
		<cfelseif isdefined("session.cp")>
			CCAT.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.cp.language#"> AND
		</cfif>
		C.IS_VIEWED = 1 AND
		C.VIEW_DATE_START <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('h',session_base.time_zone,now())#"> AND
		C.VIEW_DATE_FINISH >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('h',session_base.time_zone,now())#"> AND
		C.STAGE_ID = -2 AND	 
		C.CONTENT_STATUS = 1 AND
		C.CHAPTER_ID = CH.CHAPTER_ID AND
		CCAT.CONTENTCAT_ID = CH.CONTENTCAT_ID AND
		CCAT.IS_RULE <> 1 AND 
	<cfif isdefined("session.pp.company_category")>
        ','+C.COMPANY_CAT+','  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.company_category#,%"> AND
        CCAT.COMPANY_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">)
    <cfelseif isdefined("session.ww.consumer_category")>
        ','+C.CONSUMER_CAT+','  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ww.consumer_category#,%"> AND
        CCAT.COMPANY_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">)
    <cfelseif isdefined("session.cp")>
        CAREER_VIEW = 1 AND
        CCAT.COMPANY_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#">)
    <cfelse>
        INTERNET_VIEW = 1  AND
        CCAT.COMPANY_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">)
    </cfif>	
   	ORDER BY
		C.CONTENT_ID DESC
</cfquery>
<cfif get_notice.recordcount>
	<script type="text/javascript">
		<cfoutput>
			windowopen('#request.self#?fuseaction=objects2.popup_content_notice&content_id=#get_notice.content_id#','list');
		</cfoutput>
	</script>
</cfif>
