<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="countSetupLanguage" access="public" returntype="query">
        <cfargument name="count_setup_language" default="">
        <cfquery name="COUNT_SETUP_LANGUAGE_TR" datasource="#DSN#">
			SELECT ITEM_TR, COUNT(*) AS TOTAL_COUNT
			FROM #dsn#.SETUP_LANGUAGE_TR
			GROUP BY ITEM_TR
			HAVING COUNT(*) > 1
			ORDER BY TOTAL_COUNT DESC
		</cfquery>
        <cfreturn COUNT_SETUP_LANGUAGE_TR>
    </cffunction>

    <cffunction name="getSetupLanguage" access="public" returntype="query">
        <cfargument name="setup_language" default="">
        <cfquery name="GET_SETUP_LANGUAGE_TR" datasource="#DSN#">
			SELECT 
                DICTIONARY_ID,
                ITEM_TR,
                ITEM_ENG,
                ITEM_DE,
                ITEM_ARB,
                ITEM_FR,
                ITEM_RUS,
                ITEM_IT,
                RECORD_DATE,
                UPDATE_DATE
            FROM 
                #dsn#.SETUP_LANGUAGE_TR
			ORDER BY 
                UPDATE_DATE DESC
		</cfquery>
        <cfreturn GET_SETUP_LANGUAGE_TR>
    </cffunction>

    <cffunction name="countTR" access="public" returntype="query">
        <cfargument name="TR" default="">
        <cfquery name="count_TR" datasource="#DSN#">
            SELECT SUM(MISSING_TR) AS SUM_TR FROM
            (SELECT
                ITEM_TR,
                COUNT(*) AS MISSING_TR
            FROM 
                #dsn#.SETUP_LANGUAGE_TR
            WHERE (ITEM_TR = '?' OR ITEM_TR LIKE '%?%?%' OR ITEM_TR IS NULL OR ITEM_TR = '')
			GROUP BY 
                ITEM_TR) AS SUM_TR
		</cfquery>
        <cfreturn count_TR>
    </cffunction>

    <cffunction name="countENG" access="public" returntype="query">
        <cfargument name="ENG" default="">
        <cfquery name="count_ENG" datasource="#DSN#">
            SELECT SUM(MISSING_ENG) AS SUM_ENG FROM
            (SELECT
                ITEM_ENG,
                COUNT(*) AS MISSING_ENG
            FROM 
                #dsn#.SETUP_LANGUAGE_TR
            WHERE (ITEM_ENG = '?' OR ITEM_ENG LIKE '%?%?%' OR ITEM_ENG IS NULL OR ITEM_ENG = '')
			GROUP BY 
                ITEM_ENG) AS SUM_ENG
		</cfquery>
        <cfreturn count_ENG>
    </cffunction>

    <cffunction name="countDE" access="public" returntype="query">
        <cfargument name="DE" default="">
        <cfquery name="count_DE" datasource="#DSN#">
            SELECT SUM(MISSING_DE) AS SUM_DE FROM
            (SELECT
                ITEM_DE,
                COUNT(*) AS MISSING_DE
            FROM 
                #dsn#.SETUP_LANGUAGE_TR
            WHERE (ITEM_DE = '?' OR ITEM_DE LIKE '%?%?%' OR ITEM_DE IS NULL OR ITEM_DE = '')
			GROUP BY 
                ITEM_DE) AS SUM_DE
		</cfquery>
        <cfreturn count_DE>
    </cffunction>

    <cffunction name="countARB" access="public" returntype="query">
        <cfargument name="ARB" default="">
        <cfquery name="count_ARB" datasource="#DSN#">
            SELECT SUM(MISSING_ARB) AS SUM_ARB FROM
            (SELECT
                ITEM_ARB,
                COUNT(*) AS MISSING_ARB
            FROM 
                #dsn#.SETUP_LANGUAGE_TR
            WHERE (ITEM_ARB = '?' OR ITEM_ARB LIKE '%?%?%' OR ITEM_ARB IS NULL OR ITEM_ARB = '')
			GROUP BY 
                ITEM_ARB) AS SUM_ARB
		</cfquery>
        <cfreturn count_ARB>
    </cffunction>

    <cffunction name="countFR" access="public" returntype="query">
        <cfargument name="FR" default="">
        <cfquery name="count_FR" datasource="#DSN#">
            SELECT SUM(MISSING_FR) AS SUM_FR FROM
            (SELECT
                ITEM_FR,
                COUNT(*) AS MISSING_FR
            FROM 
                #dsn#.SETUP_LANGUAGE_TR
            WHERE (ITEM_FR = '?' OR ITEM_FR LIKE '%?%?%' OR ITEM_FR IS NULL OR ITEM_FR = '')
			GROUP BY 
                ITEM_FR) AS SUM_FR
		</cfquery>
        <cfreturn count_FR>
    </cffunction>

    <cffunction name="countRUS" access="public" returntype="query">
        <cfargument name="RUS" default="">
        <cfquery name="count_RUS" datasource="#DSN#">
            SELECT SUM(MISSING_RUS) AS SUM_RUS FROM
            (SELECT
                ITEM_RUS,
                COUNT(*) AS MISSING_RUS
            FROM 
                #dsn#.SETUP_LANGUAGE_TR
            WHERE (ITEM_RUS = '?' OR ITEM_RUS LIKE '%?%?%' OR ITEM_RUS IS NULL OR ITEM_RUS = '')
			GROUP BY 
                ITEM_RUS) AS SUM_RUS
		</cfquery>
        <cfreturn count_RUS>
    </cffunction>

    <cffunction name="countIT" access="public" returntype="query">
        <cfargument name="IT" default="">
        <cfquery name="count_IT" datasource="#DSN#">
            SELECT SUM(MISSING_IT) AS SUM_IT FROM
            (SELECT
                ITEM_IT,
                COUNT(*) AS MISSING_IT
            FROM 
                #dsn#.SETUP_LANGUAGE_TR
            WHERE (ITEM_IT = '?' OR ITEM_IT LIKE '%?%?%' OR ITEM_IT IS NULL OR ITEM_IT = '')
			GROUP BY 
                ITEM_IT) AS SUM_IT
		</cfquery>
        <cfreturn count_IT>
    </cffunction>
</cfcomponent>