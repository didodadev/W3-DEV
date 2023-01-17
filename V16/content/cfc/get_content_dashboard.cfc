<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
		<cffunction name="GET_CONTENT_DASHBOARD" returntype="query">
			<cfquery name="GET_CONTENT_DASHBOARD" datasource="#DSN#">
				SELECT
					<cfif isDefined("arguments.content_cat")>
						CC.CONTENTCAT,
					<cfelseif isDefined("arguments.chapter")>
						CCH.CHAPTER,
					<cfelseif isDefined("arguments.writer")>
						C.OUTHOR_EMP_ID,
						C.OUTHOR_COMPANY_PAR_ID,
						C.OUTHOR_PAR_ID,
						C.OUTHOR_CONS_ID,
					<cfelseif isDefined("arguments.type")>
						CP.NAME,
					<cfelseif isDefined("arguments.language")>
						SP.LANGUAGE_SET,
					</cfif>
					COUNT(CASE WHEN (C.CONTENT_STATUS = 0 )THEN C.CONTENT_STATUS  END) AS PASSIVE_TOTAL,
					COUNT(CASE WHEN (C.CONTENT_STATUS = 1) THEN C.CONTENT_STATUS  END) AS ACTIVE_TOTAL
				FROM
					CONTENT C,
					<cfif isDefined("arguments.content_cat") or (isDefined("arguments.writer"))>
						CONTENT_CAT CC,
						CONTENT_CHAPTER CCH
					<cfelseif isDefined("arguments.chapter")>
						CONTENT_CHAPTER CCH
					<cfelseif isDefined("arguments.type")>
						CONTENT_PROPERTY CP
					<cfelseif isDefined("arguments.language")>
						SETUP_LANGUAGE SP
					</cfif>
				WHERE
					<cfif isDefined("arguments.language")>
						C.LANGUAGE_ID = SP.LANGUAGE_SHORT 
					<cfelseif isDefined("arguments.chapter")>
						CCH.CHAPTER_ID = C.CHAPTER_ID
					<cfelseif isDefined("arguments.type")>
						C.CONTENT_PROPERTY_ID=CP.CONTENT_PROPERTY_ID 
					<cfelseif isDefined("arguments.content_cat") or( isDefined("arguments.writer"))>
						CC.CONTENTCAT_ID = CCH.CONTENTCAT_ID AND
						CCH.CHAPTER_ID = C.CHAPTER_ID AND					
						CC.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">) 
					</cfif>
				GROUP BY 
					<cfif isDefined("arguments.content_cat")>
						CC.CONTENTCAT
					<cfelseif isDefined("arguments.chapter")>
						CCH.CHAPTER	
					<cfelseif isDefined("arguments.writer")>
						C.OUTHOR_EMP_ID,
						C.OUTHOR_COMPANY_PAR_ID,
						C.OUTHOR_PAR_ID,
						C.OUTHOR_CONS_ID
					<cfelseif isDefined("arguments.type")>
						CP.NAME	
					<cfelseif isDefined("arguments.language")>
						SP.LANGUAGE_SET
					</cfif>
			</cfquery>
        <cfreturn GET_CONTENT_DASHBOARD>
	</cffunction>
</cfcomponent>