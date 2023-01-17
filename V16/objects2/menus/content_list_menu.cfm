<cfquery name="GET_CONTENTS" datasource="#DSN#">
	SELECT 
		CONT_HEAD,
        UFU.USER_FRIENDLY_URL
	FROM 
		CONTENT C
        OUTER APPLY(
			SELECT TOP 1 UFU.USER_FRIENDLY_URL 
			FROM #dsn#.USER_FRIENDLY_URLS UFU 
			WHERE UFU.ACTION_TYPE = 'cntid' 
			AND UFU.ACTION_ID = C.CONTENT_ID 		
			AND UFU.PROTEIN_SITE = #GET_PAGE.PROTEIN_SITE#) UFU
	WHERE 
		C.CONTENT_STATUS = 1 AND
		C.INTERNET_VIEW = 1 
        <cfif isDefined("attributes.xml_cont_chap_id") and len(attributes.xml_cont_chap_id)>
            AND C.CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.xml_cont_chap_id#">
        </cfif>
</cfquery>

<div>	
	<h1>
		<cfif isDefined("attributes.content_list_menu_header") and len(attributes.content_list_menu_header)>
			<cf_get_lang dictionary_id='#attributes.content_list_menu_header#'>
		</cfif>
	</h1>
	<ul>
		<cfoutput query="GET_CONTENTS">				
			<li>
				<a href="#USER_FRIENDLY_URL#">#CONT_HEAD#</a> 
			</li>
		</cfoutput>
	</ul>
</div>