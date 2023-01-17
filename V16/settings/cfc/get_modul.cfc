<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="GET_PARAMETERS" access="public" >
        <cfargument name="type" default="">
        <cfquery name="get_parameters" datasource="#dsn#">
                SELECT
                    <cfif session.ep.language eq 'tr'> 
                        S2.ITEM_TR AS FAMILY, 
                        S3.ITEM_TR AS MODULE, 
                        S4.ITEM_TR AS OBJECT, 
                    <cfelseif session.ep.language eq 'eng'>
                        S2.ITEM_ENG AS FAMILY, 
                        S3.ITEM_ENG AS MODULE, 
                        S4.ITEM_ENG AS OBJECT, 
                    </cfif>
                    S1.ITEM_#session.ep.language# AS SOLUTION, 
                    W.FULL_FUSEACTION,
                    W.*, 
                    M.* 
                FROM 
                    WRK_OBJECTS AS W 
                    LEFT JOIN SETUP_LANGUAGE_TR AS S4 ON S4.DICTIONARY_ID = W.DICTIONARY_ID 
                    LEFT JOIN WRK_MODULE AS M ON W.MODULE_NO = M.MODULE_NO 
                    LEFT JOIN SETUP_LANGUAGE_TR AS S3 ON S3.DICTIONARY_ID = M.MODULE_DICTIONARY_ID 
                    LEFT JOIN WRK_FAMILY AS WF ON WF.WRK_FAMILY_ID = M.FAMILY_ID
                    LEFT JOIN SETUP_LANGUAGE_TR AS S2 ON S2.DICTIONARY_ID = WF.FAMILY_DICTIONARY_ID
                    LEFT JOIN WRK_SOLUTION AS WS ON WS.WRK_SOLUTION_ID = WF.WRK_SOLUTION_ID
                    LEFT JOIN SETUP_LANGUAGE_TR AS S1 ON S1.DICTIONARY_ID = WS.SOLUTION_DICTIONARY_ID
                WHERE 
                    W.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type#"> AND 
                    W.IS_ACTIVE = 1 AND
                    W.DICTIONARY_ID IS NOT NULL
                ORDER BY 
                WS.WRK_SOLUTION_ID,
                W.RANK_NUMBER,
                S2.ITEM_TR,
                S3.ITEM_TR,
                S4.ITEM_TR
        </cfquery>
        <cfreturn get_parameters> 
    </cffunction>
</cfcomponent>