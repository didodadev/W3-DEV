<cffunction name="GET_LAST_PROCESSES" output="yes" returntype="any">
    <cfif isdefined("session.ep.userid")>
		<cfset attributes.user_id = session.ep.userid>
	<cfelseif isdefined("session.pp.userid")>
		<cfset attributes.user_id = session.pp.userid>
	<cfelseif isdefined("session.ww.userid")>
		<cfset attributes.user_id = session.ww.userid>
    <cfelse>
		<cfset attributes.user_id = 0>
	</cfif>
    <cfquery name="logs" datasource="#DSN#" maxrows="10">
        SELECT TOP 10 * FROM (
            SELECT * FROM (SELECT TOP 10 LG.LOG_DATE, OBJ.HEAD, LG.ACTION_NAME
                FROM [WRK_LOG] LG
                    INNER JOIN [WRK_OBJECTS] OBJ
                        ON LG.FUSEACTION = OBJ.FULL_FUSEACTION
                WHERE LG.EMPLOYEE_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#attributes.user_id#">
                ORDER BY LG.LOG_DATE DESC) T1
            UNION ALL
            SELECT * FROM (SELECT TOP 10 VST.VISIT_DATE AS LOG_DATE, WO.HEAD, LNG.ITEM_TR AS ACTION_NAME
                FROM [WRK_VISIT] VST
                    INNER JOIN [WRK_OBJECTS] WO
                        ON VST.VISIT_PAGE = WO.FULL_FUSEACTION
                    LEFT OUTER JOIN [SETUP_LANGUAGE_TR] LNG
                        ON WO.DICTIONARY_ID = LNG.DICTIONARY_ID
                WHERE VST.USER_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#attributes.user_id#">
                ORDER BY VST.WRK_VISIT_ID DESC) T2) TR
        ORDER BY LOG_DATE DESC
    </cfquery>
    <cfreturn logs>
</cffunction>