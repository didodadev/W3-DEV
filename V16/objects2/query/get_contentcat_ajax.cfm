<cfsetting showdebugoutput="no">
<cfquery name="GET_CONTENT_SPOT" datasource="#DSN#" maxrows="1">
	SELECT 
		CONT_HEAD,
		CONT_BODY, 
		CONTENT_ID,
		CONT_SUMMARY,
		CONTENTCAT
	FROM  
		CONTENT C,
		CONTENT_CHAPTER CH,
		CONTENT_CAT CT
	WHERE 
		SPOT = 1 AND
		STAGE_ID = -2 AND 
		C.CHAPTER_ID = CH.CHAPTER_ID AND
		CH.CONTENTCAT_ID = CT.CONTENTCAT_ID AND
		CT.CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cat_id#"> AND
		CT.IS_RULE <> 1 AND
		<cfif isdefined("session.pp.company_category")>
            C.COMPANY_CAT  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.company_category#,%"> AND
            CT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">) AND
            CT.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.language#">
        <cfelseif isdefined("session.ww.consumer_category")>
            C.CONSUMER_CAT  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ww.consumer_category#,%"> AND
            CT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">) AND
            CT.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.language#">
        <cfelseif isdefined("session.cp")>
            CAREER_VIEW = 1  AND
            CT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#">) AND
            CT.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.cp.language#">	
        <cfelse>
            INTERNET_VIEW = 1  AND
            CT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">)
        </cfif>
	ORDER BY 
		C.CONTENT_ID DESC
</cfquery>

<cfquery name="GET_CONTENT_CAT" datasource="#DSN#" maxrows="5">
	SELECT 
		CONT_HEAD,
		CONTENT_ID,
		CONTENTCAT
	FROM  
		CONTENT C,
		CONTENT_CHAPTER CH,
		CONTENT_CAT CT
	WHERE 
		STAGE_ID = -2 AND 
		C.CHAPTER_ID = CH.CHAPTER_ID AND
		CH.CONTENTCAT_ID = CT.CONTENTCAT_ID AND
		CT.CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cat_id#"> AND
		CT.IS_RULE <> 1 AND
		<cfif isdefined("session.pp.company_category")>
            C.COMPANY_CAT  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.company_category#,%"> AND
            CT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">) AND
            CT.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.language#">
        <cfelseif isdefined("session.ww.consumer_category")>
            C.CONSUMER_CAT  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ww.consumer_category#,%"> AND
            CT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">) AND
            CT.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.language#">
        <cfelseif isdefined("session.cp")>
            CAREER_VIEW = 1  AND
            CT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#">) AND
            CT.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.cp.language#">	
        <cfelse>
            INTERNET_VIEW = 1  AND
            CT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">)
        </cfif>
	ORDER BY 
		C.CONTENT_ID DESC
</cfquery>

<cfoutput>
	<cfset mystr = '<table border="0" width="100%">'>
		<cfif get_content_spot.recordcount>
			<cfset mystr = mystr & '<tr>'>
				<cfset mystr = mystr & '<td>'>
					<cfset mystr = mystr & '<table>'>
						<cfset mystr = mystr & '<tr>'>
							<cfset mystr = mystr & '<td class="txtbold">'>
								<cfset mystr = mystr & '#get_content_spot.CONT_HEAD#' >
							<cfset mystr = mystr & '</td>'>
						<cfset mystr = mystr & '</tr>'>
						<cfset mystr = mystr & '<tr>'>
							<cfset mystr = mystr & '<td>'>
								<cfset mystr = mystr & '#get_content_spot.CONT_BODY#' >
							<cfset mystr = mystr & '</td>'>
						<cfset mystr = mystr & '</tr>'>
					<cfset mystr = mystr & '</table>'>
				<cfset mystr = mystr & '</td>'>
				<cfset mystr = mystr & '<td valign="top" width="350">'>
					<cfset mystr = mystr & '<table>'>
						<cfloop query="get_content_cat">
							<cfset mystr = mystr & '<tr>'>
								<cfset mystr = mystr & '<td width="15">'>
									<cfset mystr = mystr & '#currentrow# -' >
								<cfset mystr = mystr & '</td>'>
								<cfset mystr = mystr & '<td>'>
									<cfset mystr = mystr & '<a href="#request.self#?fuseaction=objects2.detail_content&cid=#content_id#" class="tableyazi">#get_content_cat.CONT_HEAD#</a>' >
								<cfset mystr = mystr & '</td>'>
							<cfset mystr = mystr & '</tr>'>
						</cfloop>
					<cfset mystr = mystr & '</table>'>
				<cfset mystr = mystr & '</td>'>
			<cfset mystr = mystr & '</tr>'>
		<cfelse>
			<cfset mystr = mystr & '<tr>'>
				<cfset mystr = mystr & '<td>'>
					<cfset mystr = mystr & 'Kayit Yok!' >
				<cfset mystr = mystr & '</td>'>
			<cfset mystr = mystr & '</tr>'>
		</cfif>
	<cfset mystr = mystr & '</table>'>
</cfoutput>
<cfoutput>#mystr#</cfoutput>

