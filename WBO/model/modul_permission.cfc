<!--- FBS 20121006 cfcye cevrildi, acil lazim oldugundan sadece selecti cevirip kullandim, add ve upd duzenlenmeli daha sonra --->
<cfcomponent>
	<cffunction name="modul_permission" access="public" returntype="query">
		<cfargument name="modul_no" type="numeric" required="yes" default="1">
        <cfargument name="datasource" type="string" required="yes" default="1">
        <cfargument name="lang" type="string" required="yes" default="tr">
		<cfquery name="GET_MODUL_PERMISSION" datasource="#arguments.datasource#">
        SELECT
        	*
        FROM
        (
            SELECT
                Replace(L3.ITEM_#UCASE(arguments.lang)#,'''','') AS SOLUTION,
                Replace(L2.ITEM_#UCASE(arguments.lang)#,'''','') AS FAMILY,
                Replace(L1.ITEM_#UCASE(arguments.lang)#,'''','') AS MODULE,
                Replace(L4.ITEM_#UCASE(arguments.lang)#,'''','') AS OBJECT,
                W.FULL_FUSEACTION AS FUSEACTION,
                W.WRK_OBJECTS_ID,
                WM.MODULE_TYPE AS TYPE
            FROM
                WRK_OBJECTS AS W
                LEFT JOIN WRK_MODULE AS WM ON WM.MODULE_NO = W.MODULE_NO
                LEFT JOIN SETUP_LANGUAGE_TR AS L1 ON L1.DICTIONARY_ID = WM.MODULE_DICTIONARY_ID
                LEFT JOIN WRK_FAMILY AS WF ON WF.WRK_FAMILY_ID = WM.FAMILY_ID
                LEFT JOIN SETUP_LANGUAGE_TR AS L2 ON L2.DICTIONARY_ID = WF.FAMILY_DICTIONARY_ID
                LEFT JOIN WRK_SOLUTION AS WS ON WS.WRK_SOLUTION_ID = WF.WRK_SOLUTION_ID
                LEFT JOIN SETUP_LANGUAGE_TR AS L3 ON L3.DICTIONARY_ID = WS.SOLUTION_DICTIONARY_ID
                LEFT JOIN SETUP_LANGUAGE_TR AS L4 ON L4.DICTIONARY_ID = W.DICTIONARY_ID
            WHERE
                W.IS_MENU = 1
                AND W.MODULE_NO = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.modul_no#">
            GROUP BY
                Replace(L3.ITEM_#UCASE(arguments.lang)#,'''',''),
                Replace(L2.ITEM_#UCASE(arguments.lang)#,'''',''),
                Replace(L1.ITEM_#UCASE(arguments.lang)#,'''',''),
                Replace(L4.ITEM_#UCASE(arguments.lang)#,'''',''),
                W.WRK_OBJECTS_ID,
                W.FULL_FUSEACTION,
                WM.MODULE_TYPE
		)AS L1
        	ORDER BY
            L1.SOLUTION,
            L1.FAMILY,
            L1.MODULE,
            L1.OBJECT,
            L1.FUSEACTION
		</cfquery>
		<cfreturn GET_MODUL_PERMISSION>
	</cffunction> 
</cfcomponent>
