<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name = "getObjects">
    	<cfquery name="getWrkObjects" datasource="#dsn#">
        	SELECT
            	WS.WRK_SOLUTION_ID,
                WS.IS_MENU,
                WS.SOLUTION_TYPE,
                WS.SOLUTION_DICTIONARY_ID,
                WS.SOLUTION,
                WS.ICON,
                WS.WIKI,
                WS.VIDEO
            FROM
            	WRK_SOLUTION WS
			ORDER BY
            	ISNULL(WS.RANK_NUMBER,100)
        </cfquery>
        <cfreturn getWrkObjects>
    </cffunction>

    <cffunction name = "getSolutionImp">
    	<cfquery name="getWrkObjects" datasource="#dsn#">
        	SELECT
            	WS.WRK_SOLUTION_ID,
                WS.IS_MENU,
                WS.SOLUTION_TYPE,
                WS.SOLUTION_DICTIONARY_ID,
                WS.SOLUTION,
                WS.ICON,
                WF.FAMILY,
                WF.WRK_FAMILY_ID
            FROM
            	WRK_SOLUTION WS
                LEFT JOIN WRK_FAMILY WF ON WS.WRK_SOLUTION_ID = WF.WRK_SOLUTION_ID
			ORDER BY
            	ISNULL(WS.RANK_NUMBER,100)
        </cfquery>
        <cfreturn getWrkObjects>
    </cffunction>

    <cffunction name = "getSolutionID">
    	<cfquery name="getSolutionID" datasource="#dsn#">
        	SELECT
            	WS.WRK_SOLUTION_ID,
                WS.SOLUTION_DICTIONARY_ID,
                WS.SOLUTION,
                WF.FAMILY,
                WF.WRK_FAMILY_ID
            FROM
            	WRK_SOLUTION WS
                LEFT JOIN WRK_FAMILY WF ON WS.WRK_SOLUTION_ID = WF.WRK_SOLUTION_ID
            WHERE
                WF.WRK_FAMILY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.family_id#">
			ORDER BY
            	ISNULL(WS.RANK_NUMBER,100)
        </cfquery>
        <cfreturn getSolutionID>
    </cffunction>
    
    <cffunction name = "getFamilyWiki">
    	<cfquery name="getFamilyWiki" datasource="#dsn#">
        	SELECT
                WF.WRK_FAMILY_ID,
                WF.WIKI,
                WF.VIDEO
            FROM
            	WRK_SOLUTION WS
                LEFT JOIN WRK_FAMILY WF ON WS.WRK_SOLUTION_ID = WF.WRK_SOLUTION_ID
            WHERE
                WF.WRK_FAMILY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.family_id#">
			ORDER BY
            	ISNULL(WS.RANK_NUMBER,100)
        </cfquery>
        <cfreturn getFamilyWiki>
    </cffunction>
</cfcomponent>