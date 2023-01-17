<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
		<cffunction name="get_chapter" returntype="query" access="remote">
			<cfargument  name="content_cat" default="">
            <cfquery name="get_chapter" datasource="#DSN#">
                SELECT
                    CCH.CHAPTER,
                    COUNT(CASE WHEN (C.CONTENT_STATUS = 0 )THEN C.CONTENT_STATUS  END) AS PASSIVE_TOTAL,
                    COUNT(CASE WHEN (C.CONTENT_STATUS = 1) THEN C.CONTENT_STATUS  END) AS ACTIVE_TOTAL
                FROM
					CONTENT C
                LEFT JOIN CONTENT_CHAPTER CCH ON CCH.CHAPTER_ID = C.CHAPTER_ID
                WHERE 
                    C.CHAPTER_ID IS NOT NULL
                <cfif len(arguments.content_cat)>
                    AND CCH.CONTENTCAT_ID IN (<cfqueryparam value="#arguments.content_cat#" cfsqltype="cf_sql_integer" list="yes">) 
                </cfif>
                GROUP BY CCH.CHAPTER
            </cfquery>
        <cfreturn get_chapter>
	</cffunction>

    <cffunction name="get_stage" returntype="query" access="remote">
        <cfargument  name="content_cat" default="">
        <cfquery name="get_stage" datasource="#DSN#">
            SELECT
                PTR.STAGE,
                COUNT(CASE WHEN (C.CONTENT_STATUS = 0 )THEN C.CONTENT_STATUS  END) AS PASSIVE_TOTAL,
                COUNT(CASE WHEN (C.CONTENT_STATUS = 1) THEN C.CONTENT_STATUS  END) AS ACTIVE_TOTAL
            FROM
                CONTENT C
            JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = C.PROCESS_STAGE
            LEFT JOIN CONTENT_CHAPTER CCH ON CCH.CHAPTER_ID = C.CHAPTER_ID
            WHERE 
               1=1
            <cfif len(arguments.content_cat)>
                AND CCH.CONTENTCAT_ID IN (<cfqueryparam value="#arguments.content_cat#" cfsqltype="cf_sql_integer" list="yes">) 
            </cfif>
            GROUP BY PTR.STAGE
        </cfquery>
        <cfreturn get_stage>
    </cffunction>

    <cffunction name="get_language" returntype="query" access="remote">
        <cfargument  name="content_cat" default="">
        <cfquery name="get_language" datasource="#DSN#">
            SELECT
                SP.LANGUAGE_SET,
                COUNT(CASE WHEN (C.CONTENT_STATUS = 0 )THEN C.CONTENT_STATUS  END) AS PASSIVE_TOTAL,
                COUNT(CASE WHEN (C.CONTENT_STATUS = 1) THEN C.CONTENT_STATUS  END) AS ACTIVE_TOTAL
            FROM
                CONTENT C
            LEFT JOIN SETUP_LANGUAGE SP ON C.LANGUAGE_ID = SP.LANGUAGE_SHORT
            LEFT JOIN CONTENT_CHAPTER CCH ON CCH.CHAPTER_ID = C.CHAPTER_ID
            WHERE 
               1=1
            <cfif len(arguments.content_cat)>
                AND CCH.CONTENTCAT_ID IN (<cfqueryparam value="#arguments.content_cat#" cfsqltype="cf_sql_integer" list="yes">) 
            </cfif>
            GROUP BY SP.LANGUAGE_SET
        </cfquery>
        <cfreturn get_language>
    </cffunction>

    <cffunction name="get_related_wiki" returntype="query" access="remote">
        <cfargument  name="wo_type" default="">
        <cfargument  name="module_no" default="">
        <cfargument  name="lang" default="">
        <cfargument  name="rel_wiki" default="">
        <cfargument  name="keyword" default="">
        <cfargument name="solution" default="">
        <cfargument name="family" default="">

        <cfquery name="get_related_wiki" datasource="#DSN#">
           
                SELECT
                    TABLE1.FULL_FUSEACTION,
                    TABLE1.HEAD,
                    TABLE1.MODULE MODUL
                    
                FROM
                (
                    SELECT
                        W.FULL_FUSEACTION
                        ,W.HEAD
                        ,M.MODULE

                    FROM
                        WRK_OBJECTS AS W

                    LEFT JOIN WRK_MODULE AS M ON W.MODULE_NO = M.MODULE_NO
                    LEFT JOIN WRK_FAMILY AS WF2 ON WF2.WRK_FAMILY_ID = M.FAMILY_ID
                    LEFT JOIN WRK_SOLUTION AS WS ON WS.WRK_SOLUTION_ID = WF2.WRK_SOLUTION_ID

                    WHERE
                        W.STATUS = <cfqueryparam cfsqltype="cf_sql_varchar" value="Deployment">
                        <cfif len(arguments.wo_type)>
                            AND W.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wo_type#">
                        </cfif>
                        <cfif len(arguments.keyword)>
                            AND W.FULL_FUSEACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                        </cfif>
                        <cfif len(arguments.module_no)>
                            AND W.MODULE_NO = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.module_no#">
                        </cfif>
                        <cfif len(arguments.solution)>
                            AND WS.WRK_SOLUTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.solution#">
                        </cfif>
                        <cfif len(arguments.family)>
                            AND WF2.WRK_FAMILY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.family#">
                        </cfif>
                
                ) TABLE1
                
                <cfif len(arguments.rel_wiki)>
                    <cfif arguments.rel_wiki eq 0>
                        LEFT JOIN
                    <cfelseif arguments.rel_wiki eq 1>
                        JOIN
                    </cfif>
                    META_DESCRIPTIONS MD
                        ON(
                            (REPLACE(MD.META_DESC_HEAD, ' ', '') LIKE '%,'+TABLE1.FULL_FUSEACTION+',%')
                            OR (REPLACE(MD.META_DESC_HEAD, ' ', '') LIKE '%,'+TABLE1.FULL_FUSEACTION)
                            OR (REPLACE(MD.META_DESC_HEAD, ' ', '') LIKE TABLE1.FULL_FUSEACTION+',%')
                            OR (REPLACE(MD.META_DESC_HEAD, ' ', '') = TABLE1.FULL_FUSEACTION)
                        )
                </cfif>
                
                WHERE
                    1=1
                    <cfif arguments.rel_wiki eq 1 and len(arguments.lang)>
                        AND MD.LANGUAGE_SHORT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lang#">
                    </cfif>
                    <cfif arguments.rel_wiki eq 1>
                        AND MD.ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="CONTENT_ID">
                    <cfelseif arguments.rel_wiki eq 0>
                        AND(
                            (MD.META_DESC_HEAD IS NULL) OR (TABLE1.FULL_FUSEACTION IS NULL)
                        ) 
                    </cfif>
                GROUP BY 
                    TABLE1.FULL_FUSEACTION,
                    TABLE1.HEAD,
                    TABLE1.MODULE
                ORDER BY (CASE WHEN TABLE1.MODULE IS NULL THEN 1 ELSE 0 END), TABLE1.MODULE
           
        </cfquery>
        <cfreturn get_related_wiki>
    </cffunction>
</cfcomponent>