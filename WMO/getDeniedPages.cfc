<cfcomponent>
	<cfsetting requesttimeout="2000">
    <cffunction name="pageAuthority" access="remote" returntype="struct">
        <cfargument name="datasource" default="#dsn#" required="yes">
        <cfargument name="employee_id" required="yes">
        <cfargument name="fuseaction" required="yes">
        <cfargument name="position_code" required="yes">
        <cfargument name="wrkflow" default="0">
        <cfargument name="pathinfo" default="">
        <cfargument name="event" default="">
        <cfargument name="referer" default="">
        <cfargument name="wsr_code" default="">
        <cfargument name="action_id" default="">

        <!--- fix event --->
        <!---vekalet varsa vekalet verenlerin pozisyonları soru ana sorguya içinde kullanılmadı performans için--->
        <cfset get_mandate = createObject("component", "WMO.process_authority").init().get_mandate() />
        <cfset mandate_positioncode = get_mandate.recordcount ? ValueList(get_mandate.POSITION_CODE) : "" />

        <!--- IS_CHECKER_UPDATE_AUTHORITY : Süreçte güncelleme yetkisi verilmiş mi? 1 güncelleme yapabilir, 0 güncelleme yapamaz. ---->
        <cfset application.deniedPages = structNew() />
        <cftry>
            <cfquery name="GET_PAGE_AUTHORITY" datasource="#arguments.datasource#">
                SELECT
                    U.OBJECT_NAME,
                    U.LIST_OBJECT,
                    U.ADD_OBJECT,
                    U.UPDATE_OBJECT,
                    U.DELETE_OBJECT,
                    1 AS IS_CHECKER_UPDATE_AUTHORITY,
                    '' AS WARNING_PASSWORD,
                    '' AS WARNING_ID
                FROM
                    USER_GROUP_OBJECT AS U
                    LEFT JOIN EMPLOYEE_POSITIONS AS E ON ISNULL(E.USER_GROUP_ID,0) = U.USER_GROUP_ID
                WHERE
                    E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                    AND U.LIST_OBJECT = 1
                UNION ALL
                    SELECT
                        EPD.DENIED_PAGE AS OBJECT_NAME,
                        EPD.IS_VIEW AS LIST_OBJECT,
                        0 AS ADD_OBJECT,
                        0 AS UPDATE_OBJECT,
                        0 AS DELETE_OBJECT,
                        1 AS IS_CHECKER_UPDATE_AUTHORITY,
                        '' AS WARNING_PASSWORD,
                        '' AS WARNING_ID
                    FROM
                        EMPLOYEE_POSITIONS_DENIED AS EPD,
                        EMPLOYEE_POSITIONS AS EP
                    WHERE
                        EPD.DENIED_TYPE <> 1 AND
                        EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#"> AND
                        EPD.DENIED_PAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fuseaction#"> AND
                        (
                            EPD.POSITION_CODE = EP.POSITION_CODE OR
                            EPD.POSITION_CAT_ID = EP.POSITION_CAT_ID OR
                            EPD.USER_GROUP_ID = ISNULL(EP.USER_GROUP_ID,0)
                        )
                        AND EPD.IS_VIEW = 1
                UNION ALL
                    SELECT
                        WO.FULL_FUSEACTION AS OBJECT_NAME,
                        1 AS LIST_OBJECT,
                        1 AS ADD_OBJECT,
                        1 AS UPDATE_OBJECT,
                        1 AS DELETE_OBJECT,
                        '' AS IS_CHECKER_UPDATE_AUTHORITY,
                        '' AS WARNING_PASSWORD,
                        '' AS WARNING_ID
                    FROM
                        WRK_OBJECTS AS WO
                    WHERE
                        WO.FULL_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.fuseaction#">
                        AND(
                            <cfif listLen(session.ep.report_user_level)>
                                (WO.TYPE = 8 AND WO.MODULE_NO NOT IN(#session.ep.report_user_level#)) 
                            <cfelse>
                                WO.TYPE = 8
                            </cfif>
                            OR 
                            <cfif listLen(session.ep.power_user_level_id)>
                                (WO.TYPE IN(1,3,5) AND WO.MODULE_NO NOT IN(#session.ep.power_user_level_id#))
                            <cfelse>
                                WO.TYPE IN(1,3,5)
                            </cfif>
                        )
                UNION ALL
                    SELECT
                        <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.fuseaction#'> AS OBJECT_NAME,
                        0 AS LIST_OBJECT,
                        0 AS ADD_OBJECT,
                        0 AS UPDATE_OBJECT,
                        0 AS DELETE_OBJECT,
                        ISNULL(PGW.IS_CHECKER_UPDATE_AUTHORITY,1) AS IS_CHECKER_UPDATE_AUTHORITY,
                        PGW.WARNING_PASSWORD,
                        PGW.W_ID AS WARNING_ID
                    FROM 
                        PAGE_WARNINGS PGW
                    WHERE 
                        <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.wrkflow#'> = 1 AND
                        <cfif len(arguments.wsr_code)>
                            PGW.ACCESS_CODE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.wsr_code#'> AND
                        </cfif>
                        (
                            SELECT TOP 1 1 FROM WRK_OBJECTS 
                            WHERE 
                                FULL_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.fuseaction#'> AND 
                                TYPE <> 10 AND TYPE <> 11
                        ) IS NOT NULL AND
                        <cfif len( arguments.action_id )>
                            PGW.URL_LINK LIKE '%#left(reReplace(replaceNoCase(reReplace(replaceNoCase(arguments.pathinfo, '&wrkflow=1', ''), '&event=[upd|det|add]+', '%'), '&action_id=', '%'),'&wsr_code=[0-9A-Fa-f]{8}[-][0-9A-Fa-f]{4}[-][0-9A-Fa-f]{4}[-][0-9A-Fa-f]{16}',''),250)#%' AND
                        <cfelse>
                            PGW.URL_LINK LIKE '%#left(reReplace(reReplace(replaceNoCase(arguments.pathinfo, '&wrkflow=1', ''), '&event=[upd|det|add]+', '%'),'&wsr_code=[0-9A-Fa-f]{8}[-][0-9A-Fa-f]{4}[-][0-9A-Fa-f]{4}[-][0-9A-Fa-f]{16}',''),250)#%' AND
                        </cfif>
                        PGW.OUR_COMPANY_ID = #session.ep.company_id# AND 
                        ( 
                            PGW.POSITION_CODE = #session.ep.position_code# 
                            <cfif len(mandate_positioncode)>
                                OR PGW.POSITION_CODE IN (#mandate_positioncode#) 
                            </cfif>
                        )
                UNION ALL
                    SELECT
                        <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.fuseaction#'> AS OBJECT_NAME,
                        0 AS LIST_OBJECT,
                        0 AS ADD_OBJECT,
                        0 AS UPDATE_OBJECT,
                        0 AS DELETE_OBJECT,
                        ISNULL(PGWCH.IS_CHECKER_UPDATE_AUTHORITY,1) AS IS_CHECKER_UPDATE_AUTHORITY,
                        PGWCH.WARNING_PASSWORD,
                        PGWCH.W_ID AS WARNING_ID
                    FROM
                        PAGE_WARNINGS PGWCH
                    WHERE
                        <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.wrkflow#'> = 1 AND
                        <cfif len(arguments.wsr_code)>
                            PGWCH.ACCESS_CODE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.wsr_code#'> AND
                        </cfif>
                        <cfif len( arguments.action_id )>
                            PGWCH.URL_LINK LIKE '%#reReplace(replaceNoCase(reReplace(replaceNoCase(reReplace(arguments.referer, 'http[s]*://[\w\.:]+/index.cfm?', ''), '&wrkflow=1', ''), '&event=[upd|det|add]+', '%'), '&action_id=', '%'),'&wsr_code=[0-9A-Fa-f]{8}[-][0-9A-Fa-f]{4}[-][0-9A-Fa-f]{4}[-][0-9A-Fa-f]{16}','')#%' AND
                        <cfelse>
                            PGWCH.URL_LINK LIKE '%#reReplace(reReplace(replaceNoCase(reReplace(arguments.referer, 'http[s]*://[\w\.:]+/index.cfm?', ''), '&wrkflow=1', ''), '&event=[upd|det|add]+', '%'),'&wsr_code=[0-9A-Fa-f]{8}[-][0-9A-Fa-f]{4}[-][0-9A-Fa-f]{4}[-][0-9A-Fa-f]{16}','')#%' AND
                        </cfif>
                        PGWCH.OUR_COMPANY_ID = #session.ep.company_id# AND
                        ( 
                            PGWCH.POSITION_CODE = #session.ep.position_code# 
                            <cfif len(mandate_positioncode)>
                                OR PGWCH.POSITION_CODE IN (#mandate_positioncode#) 
                            </cfif>
                        ) AND
                        (   
                            SELECT TOP 1 1 
                            FROM WRK_OBJECTS
                            INNER JOIN WRK_OBJECTS_RELATION ON WRK_OBJECTS.FULL_FUSEACTION = WRK_OBJECTS_RELATION.PARENT_FUSEACTION
                            INNER JOIN WRK_OBJECTS WRK2 ON WRK_OBJECTS_RELATION.FULL_FUSEACTION = WRK2.FULL_FUSEACTION
                            WHERE
                                WRK_OBJECTS.FULL_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#parseurl(arguments.referer).fuseaction?:''#'> AND
                                (WRK2.TYPE = 10 OR WRK2.TYPE = 11) AND
                                WRK2.FULL_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.fuseaction#'>
                                <cfif len(parseurl(arguments.referer).event?:'')>
                                    AND WRK_OBJECTS_RELATION.FULL_FUSEACTION_EVENT = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#parseurl(arguments.referer).event?:''#'>
                                <cfelse>
                                    AND WRK_OBJECTS_RELATION.FULL_FUSEACTION_EVENT IS NULL
                                </cfif>
                        ) = 1
            </cfquery>
            <cfscript>
                for(i=1;i<=GET_PAGE_AUTHORITY.recordcount;i++)
                {
                    application.deniedPages['#GET_PAGE_AUTHORITY.OBJECT_NAME[i]#'] = structNew();
                    application.deniedPages['#GET_PAGE_AUTHORITY.OBJECT_NAME[i]#']['IS_VIEW'] = GET_PAGE_AUTHORITY.LIST_OBJECT[i];
                    application.deniedPages['#GET_PAGE_AUTHORITY.OBJECT_NAME[i]#']['IS_INSERT'] = GET_PAGE_AUTHORITY.ADD_OBJECT[i];
                    application.deniedPages['#GET_PAGE_AUTHORITY.OBJECT_NAME[i]#']['IS_UPD'] = GET_PAGE_AUTHORITY.UPDATE_OBJECT[i];
                    application.deniedPages['#GET_PAGE_AUTHORITY.OBJECT_NAME[i]#']['IS_DELETE'] = GET_PAGE_AUTHORITY.DELETE_OBJECT[i];
                    application.deniedPages['#GET_PAGE_AUTHORITY.OBJECT_NAME[i]#']['IS_CHECKER_UPDATE_AUTHORITY'] = GET_PAGE_AUTHORITY.IS_CHECKER_UPDATE_AUTHORITY[i];
                    application.deniedPages['#GET_PAGE_AUTHORITY.OBJECT_NAME[i]#']['WARNING_PASSWORD'] = GET_PAGE_AUTHORITY.WARNING_PASSWORD[i];
                    application.deniedPages['#GET_PAGE_AUTHORITY.OBJECT_NAME[i]#']['WARNING_ID'] = GET_PAGE_AUTHORITY.WARNING_ID[i];
                    if(GET_PAGE_AUTHORITY.LIST_OBJECT[i] eq 1)
                        application.denied_pages = listappend(application.denied_pages,GET_PAGE_AUTHORITY.OBJECT_NAME[i]);
                }
            </cfscript>
            <cfcatch type="any"></cfcatch>
        </cftry>
		<cfreturn application.deniedPages>
		
    </cffunction>
    
    <cffunction name="recordAuthority" access="remote" returntype="boolean">
        <cfargument name="datasource" default="#dsn#" required="yes">
        <cfargument name="employee_id" required="yes">
        <cfargument name="url_string" required="yes">
        <cfargument name="company_id" required="yes">
        <cfargument name="period_id" required="yes">
        
    <cftry>

		<cfquery name="GET_RECORD_AUTHORITY" datasource="#arguments.datasource#">
            SELECT 
                DENIED_TYPE,
                DPL.DENIED_PAGE,
                DPL.OUR_COMPANY_ID,
                DPL.PERIOD_ID,
                EP.EMPLOYEE_NAME,
                EP.EMPLOYEE_SURNAME,
                EP.POSITION_NAME,
                EP.POSITION_CODE
            FROM 
                DENIED_PAGES_LOCK DPL
                LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = DPL.POSITION_CODE
                LEFT JOIN EMPLOYEES AS E ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID
            WHERE 
                DPL.DENIED_PAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.url_string#">
        </cfquery>
        <cfif GET_RECORD_AUTHORITY.recordcount>
			<cfset lock_list = valuelist(GET_RECORD_AUTHORITY.position_code)>
			<cfset lock_denied_type = GET_RECORD_AUTHORITY.denied_type>
		<cfelse>
			<cfset lock_list = "">
		</cfif>
		<cfset kontrol = 0>
        	<cfif kontrol eq 0 and GET_RECORD_AUTHORITY.recordcount>
                <cfif ((lock_denied_type eq 1 and not listfindnocase(lock_list,session.ep.position_code)) or (lock_denied_type eq 0 and listfindnocase(lock_list,session.ep.position_code)))>
                    <cfif len(GET_RECORD_AUTHORITY.PERIOD_ID)>
                        <cfif listFindNoCase(GET_RECORD_AUTHORITY.PERIOD_ID,arguments.period_id,',')>
                                <cfset kontrol = 1>
                        </cfif>
                    <cfelseif len(GET_RECORD_AUTHORITY.OUR_COMPANY_ID)>
                        <cfloop index="aaa" from="1" to="#listlen(GET_RECORD_AUTHORITY.DENIED_PAGE,'&')#">
                            <cfif not listFindNoCase(arguments.url_string,listgetat(GET_RECORD_AUTHORITY.DENIED_PAGE,aaa,'&'),'&')>
                                <cfif not listFirst(arguments.url_string,'&') is listFirst(GET_RECORD_AUTHORITY.DENIED_PAGE,'&')>
                                    <cfset kontrol = 0>
                                    <cfbreak>
                                <cfelseif not listFindNoCase(arguments.url_string,listgetat(GET_RECORD_AUTHORITY.DENIED_PAGE,aaa,'&'),'&')>
                                    <cfset kontrol = 1>
                                    <cfbreak>
                                </cfif>
                            </cfif>
                        </cfloop>
                    <cfelse>
                            <cfset kontrol = 1>     
                    </cfif>	
                </cfif>
            </cfif>
		<cfreturn kontrol>
        <cfcatch>
            <cfdump var="#cfcatch#">
            <cfreturn 0>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="parseurl">
        <cfargument name="uri">
        <cftry>
        <cfscript>
            qstring = listLast(uri, "?");
            qsarr = listToArray(qstring, "&");
            qsobj = arrayReduce( qsarr, function(acc, val) {
                acc = acc?:structNew();
                acc[ listFirst( val, "=" ) ] = listLast( val, "=" );
                return acc;
            });
        </cfscript>
        <cfreturn qsobj>
        <cfcatch>
            <cfreturn { wrkflow: 0, fuseaction: "", event: "" }>
        </cfcatch>
        </cftry>
    </cffunction>

    
</cfcomponent>
