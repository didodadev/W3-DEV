<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset attributes.startrow = 1 >
    <cfset attributes.maxrows = "#session.ep.maxrows#" >
    <cfset my_id = #session.ep.userid#>

    <cfif session.ep.dateformat_style is 'dd/mm/yyyy'>
        <cfset dateformat_style_ = 'dd/MM/yyyy'>
    <cfelse>
        <cfset dateformat_style_ = 'MM/dd/yyyy'>
    </cfif>

    <cffunction name = "returnData" access = "private">
        <cfargument name="queryData" type="string" required="yes">
        <cfset structQueryData = deserializeJson(queryData)>
        <cfset data = ArrayNew(1)> 
        <cfloop index = "i" from = "1" to = "#ArrayLen(structQueryData.DATA)#">
            <cfset row = StructNew()>
            <cfset data[i] = row>
            <cfloop index = "j" from = "1" to = "#ArrayLen(structQueryData.COLUMNS)#">
                <cftry>
                    <cfset data[i]["#structQueryData.COLUMNS[j]#"] = structQueryData.DATA[i][j]>
                    <cfcatch>
                        <cfset data[i]["#structQueryData.COLUMNS[j]#"] = ''>
                    </cfcatch>
                </cftry>
            </cfloop>
        </cfloop>
        <cfreturn data>
    </cffunction>

    <cffunction name="GET_WRK_EP_APPS" returntype="any" access="public">
        <cfquery name="GET_WRK_EP_APPS" datasource="#DSN#">
            SELECT E.EMPLOYEE_NAME, E.EMPLOYEE_SURNAME, E.EMPLOYEE_ID, E.PHOTO, ED.SEX, MAX(WM.SEND_DATE) AS SENDDATE,
                ( 
                    SELECT TOP 1 WMS.MESSAGE 
                    FROM WRK_MESSAGE AS WMS
                    WHERE 
                        ( E.EMPLOYEE_ID = WMS.SENDER_ID OR E.EMPLOYEE_ID = WMS.RECEIVER_ID )
                        AND ( WMS.SENDER_ID = #my_id# OR WMS.RECEIVER_ID = #my_id# )
                        AND WMS.ENC_KEY IS NULL
                    ORDER BY WRK_MESSAGE_ID DESC
                ) AS LASTMESSAGE
            FROM EMPLOYEES AS E
            INNER JOIN EMPLOYEES_DETAIL AS ED ON E.EMPLOYEE_ID = ED.EMPLOYEE_ID 
            INNER JOIN WRK_MESSAGE AS WM ON ( E.EMPLOYEE_ID = WM.SENDER_ID OR E.EMPLOYEE_ID = WM.RECEIVER_ID )
            WHERE 
                E.EMPLOYEE_ID != #my_id#
                AND WM.ENC_KEY IS NULL
                AND ( WM.SENDER_ID = #my_id# OR WM.RECEIVER_ID = #my_id# )
                <cfif IsDefined("arguments.notuser") and len(arguments.notuser)>
                AND E.EMPLOYEE_ID != <cfqueryparam value = "#arguments.notuser#" CFSQLType = "cf_sql_integer">
                </cfif>
            GROUP BY E.EMPLOYEE_NAME, E.EMPLOYEE_SURNAME, E.EMPLOYEE_ID, E.PHOTO, ED.SEX
            ORDER BY SENDDATE DESC
        </cfquery>
        <cfreturn GET_WRK_EP_APPS>
    </cffunction>

    <cffunction name="get_wrk_messages" returntype="any" access="public">
        <cfargument name="employee_id" type="any" default="" />
        <cfargument name="group_id" type="any" default="" />
        <cfargument name="enc_key" type="any" default="" />

        <cfquery name="get_wrk_messages" datasource="#DSN#">
            SELECT
                *
            FROM
                WRK_MESSAGE
                LEFT JOIN WRK_MESSAGE_FILES ON WRK_MESSAGE.WRK_MESSAGE_ID = WRK_MESSAGE_FILES.MESSAGE_ID
            WHERE 1 = 1
            <cfif len( arguments.employee_id )>
                AND
                (
                    RECEIVER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#my_id#">
                    AND SENDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                )
                OR
                (
                    RECEIVER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                    AND SENDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#my_id#">
                )
            <cfelseif len( arguments.group_id )>
                AND WG_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.group_id#">
            <cfelseif len( arguments.enc_key )>
                AND ENC_KEY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.enc_key#">
            </cfif>
            ORDER BY SEND_DATE ASC
        </cfquery>     
        <cfreturn get_wrk_messages>   
    </cffunction>

    <cffunction name="get_last_messages" returntype="any" access="remote" returnFormat="JSON">
        <cfargument name="employee_id" type="any" required="false" default="">
        <cfargument name="group_id" type="any" required="false" default="">
        <cfargument name="enc_key" type="any" required="false" default="">

        <cfquery name="get_last_messages" datasource="#DSN#">
            SELECT TOP 1 * FROM WRK_MESSAGE
            WHERE 1 = 1
            <cfif IsDefined("arguments.employee_id") and len(arguments.employee_id)>
                AND RECEIVER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
            <cfelseif IsDefined("arguments.group_id") and len( arguments.group_id )>
                AND WG_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.group_id#">
            <cfelseif IsDefined("arguments.enc_key") and len( arguments.enc_key )>
                AND ENC_KEY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.enc_key#">
            </cfif>
            AND SENDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#my_id#">
            ORDER BY WRK_MESSAGE_ID DESC
        </cfquery>
        <cfreturn replace(serializeJSON( returnData( replace(serializeJSON( get_last_messages ), "//", "") ) ), "//", "") /> 
    </cffunction>

    <cffunction name="getMessageById" returntype="any" access="remote" returnFormat="JSON">
        <cfargument name="message_id" type="any" required="true">
        <cfquery name="getMessageById" datasource="#DSN#">
            SELECT * FROM WRK_MESSAGE
            LEFT JOIN WRK_MESSAGE_FILES ON WRK_MESSAGE.WRK_MESSAGE_ID = WRK_MESSAGE_FILES.MESSAGE_ID
            WHERE WRK_MESSAGE_ID IN(<cfqueryparam value = "#arguments.message_id#" CFSQLType = "cf_sql_integer" list = "yes">)
        </cfquery>
        <cfreturn replace(serializeJSON( returnData( replace(serializeJSON( getMessageById ), "//", "") ) ), "//", "") />
    </cffunction>

    <cffunction name="get_warning_messages" returntype="any" access="public">
        <cfargument name="action_id" type="numeric" default="0">
        <cfargument name="period_id" type="numeric" default="0">
        <cfargument name="fuseaction" type="string" default="">
        <cfquery name="GET_WARNING_MESSAGES" datasource="#DSN#">
            SELECT
                WMSG.*,
                SENEMP.EMPLOYEE_NAME AS SENDER_NAME,
                SENEMP.EMPLOYEE_SURNAME AS SENDER_SURNAME,
                SENEMP.PHOTO AS SENDER_PHOTO,
                RECEMP.EMPLOYEE_NAME AS RECEIVER_NAME,
                RECEMP.EMPLOYEE_SURNAME AS RECEIVER_SURNAME,
                RECEMP.PHOTO AS RECEIVER_PHOTO
            FROM
                WRK_MESSAGE AS WMSG
                JOIN EMPLOYEES AS SENEMP ON WMSG.SENDER_ID = SENEMP.EMPLOYEE_ID
                JOIN EMPLOYEES AS RECEMP ON WMSG.RECEIVER_ID = RECEMP.EMPLOYEE_ID
            WHERE
                1 = 1
                <cfif arguments.action_id neq 0 and arguments.period_id eq 0>
                    AND WMSG.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
                <cfelseif arguments.period_id neq 0>
                    AND WMSG.WARNING_PARENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">
                </cfif>
                <cfif len(arguments.fuseaction)>
                    AND WMSG.FUSEACTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.fuseaction#">
                </cfif>
            ORDER BY WMSG.SEND_DATE ASC
        </cfquery>     
        <cfreturn GET_WARNING_MESSAGES>   
    </cffunction>

    <cffunction name="isalerted" returntype="any" access="remote">
        <cfargument name="employee_id" type="any" default="" />
        <cfargument name="group_id" type="any" default="" />
        <cfargument name="enc_key" type="any" default="" />
        
        <cfquery name="ISALERTED" datasource="#DSN#">  <!--- OKUNDU --->
            <cfif len( arguments.group_id )>
                UPDATE WRK_MESSAGE_GROUP_EMP_MSG SET IS_ALERTED = 1 
                WHERE EMPLOYEE_ID = #my_id# 
                AND WG_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.group_id#">
            <cfelseif len( arguments.employee_id ) or len( arguments.enc_key )>
                UPDATE WRK_MESSAGE SET IS_ALERTED = 1 
                WHERE RECEIVER_ID = #my_id#
                <cfif len( arguments.employee_id )>
                    AND SENDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                <cfelseif len( arguments.enc_key )>
                    AND ENC_KEY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.enc_key#">
                </cfif>
            </cfif>
        </cfquery>
    </cffunction>

    <cffunction name="isDeleted" returntype="any" access="remote" returnFormat="JSON">
        <cfargument name="message_id" type="boolean" required="true">
        <cfset response = {} />
        <cftry>
            <cfquery name="isDeleted" datasource="#DSN#">  <!--- SİLİNDİ --->
                UPDATE WRK_MESSAGE SET DELETED_DATE = #now()#, IS_DELETED = 1 WHERE WRK_MESSAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.message_id#">
            </cfquery>
            <cfset response = { status: true } />
            <cfcatch type = "any">
                <cfset response = { status: false } />
            </cfcatch>
        </cftry>
        
        <cfreturn LCase(Replace(serializeJSON(response), '//', ''))>
    </cffunction>

    <cffunction name="getFilter" access="remote" returntype="any" returnFormat="json">
        <cfargument name="search" default="">
        <cfquery name="getFilter" datasource="#DSN#">
            SELECT E.EMPLOYEE_NAME, E.EMPLOYEE_SURNAME, E.EMPLOYEE_ID, E.PHOTO, ED.SEX, MAX(WM.SEND_DATE) AS SENDDATE,
                ( SELECT TOP 1 WMS.MESSAGE FROM WRK_MESSAGE AS WMS
                        WHERE ( E.EMPLOYEE_ID = WMS.SENDER_ID OR E.EMPLOYEE_ID = WMS.RECEIVER_ID ) AND
                            ( WMS.SENDER_ID = #my_id# OR WMS.RECEIVER_ID = #my_id# )
                    ORDER BY WRK_MESSAGE_ID DESC
                    ) AS LASTMESSAGE
            FROM EMPLOYEES AS E 
                INNER JOIN EMPLOYEES_DETAIL AS ED ON E.EMPLOYEE_ID = ED.EMPLOYEE_ID 
                INNER JOIN WRK_MESSAGE AS WM ON ( E.EMPLOYEE_ID = WM.SENDER_ID OR E.EMPLOYEE_ID = WM.RECEIVER_ID ) 
                WHERE E.EMPLOYEE_ID != #my_id# AND ( WM.SENDER_ID = #my_id# OR WM.RECEIVER_ID = #my_id# ) 
                      <cfif isdefined("arguments.search") and len(arguments.search)> AND E.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.search#%"></cfif>
                GROUP BY E.EMPLOYEE_NAME, E.EMPLOYEE_SURNAME, E.EMPLOYEE_ID, E.PHOTO, ED.SEX
                ORDER BY SENDDATE DESC
        </cfquery>

        <cfif getFilter.recordcount>
            <cfset result.status = true>
            <cfset result.data = returnData(serializeJSON(getFilter))>
        <cfelse>
            <cfset result.status = false>
        </cfif>

        <cfreturn Replace(serializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="ONLINE_USER_INTRANET" access="remote" returntype="any" returnFormat="json">
        <cfset get_module_pu = createObject("Component","WMO.functions") />
        <cfset result = StructNew()>

        <cfquery name = "get_employe_position" datasource = "#dsn#">
            SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #my_id#
        </cfquery>

        <cfquery name="GET_ONLINE_USER" datasource="#dsn#">
            SELECT 
                W.NAME + ' ' + W.SURNAME AS KULLANICI,
                ROW_NUMBER() OVER (ORDER BY W.NAME) AS NAME,
                W.SURNAME,
                W.USERID,
                W.POSITION_NAME,
                E.PHOTO,
                E2.SEX,
                W.ACTION_PAGE,
                W.USER_IP,
                W.ACTION_DATE ,
                W.SESSIONID,
                W.USER_TYPE ,
                W.BROWSER_INFO                          
            FROM
                WRK_SESSION AS W
                LEFT JOIN EMPLOYEES AS E ON E.EMPLOYEE_ID = W.USERID
                LEFT JOIN EMPLOYEE_POSITIONS AS EMPS ON W.USERID = EMPS.EMPLOYEE_ID
                LEFT JOIN EMPLOYEES_DETAIL AS E2 ON E2.EMPLOYEE_ID = W.USERID
			WHERE
                USER_TYPE = 0
                AND EMPS.POSITION_ID IN(
                    SELECT POSITION_ID 
                    FROM EMPLOYEE_POSITION_PERIODS
                    WHERE PERIOD_ID IN (
                        SELECT POSEP.PERIOD_ID
                        FROM 
                            SETUP_PERIOD POSSP, 
                            EMPLOYEE_POSITION_PERIODS POSEP,
                            OUR_COMPANY POSO
                        WHERE 
                            POSEP.PERIOD_ID = POSSP.PERIOD_ID AND 
                            POSEP.POSITION_ID = #get_employe_position.POSITION_ID# AND
                            POSSP.OUR_COMPANY_ID = POSO.COMP_ID	
                    )
                )
                <cfif isdefined("arguments.search") and len(arguments.search)>
                    AND W.NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.search#%">
                </cfif>
            ORDER BY
            	W.USER_TYPE ASC,
                W.NAME + ' ' + W.SURNAME ASC
        </cfquery>

        <cfquery name="getOnlineUserIntranet" dbtype="query">
            SELECT DISTINCT USERID,KULLANICI,POSITION_NAME,PHOTO,SEX,USER_TYPE,SURNAME FROM GET_ONLINE_USER ORDER BY NAME ASC
        </cfquery>

        <cfset query2 = returnData(serializeJSON(getOnlineUserIntranet))>
        <cfset counter = 1>

        <cfloop array="#query2#" index="dataColumns" >
            <cfset item = 1>
            <cfquery name="getUserDetail" dbtype="query">
                SELECT USERID,ACTION_PAGE,USER_IP,USER_TYPE,ACTION_DATE,SESSIONID,BROWSER_INFO FROM GET_ONLINE_USER WHERE USERID = #dataColumns["USERID"]#
            </cfquery>
            <cfset result.status = true>
            <cfset result.data[counter] = dataColumns>
            <cfset result.data[counter]["FUSEACTION"] = returnData(serializeJSON(getUserDetail))>
            <cfloop array="#result.data[counter]["FUSEACTION"]#" index="jj">
                <cfset result.data[counter]["FUSEACTION"][item]["SESSION_DATE"] = dateformat(jj["ACTION_DATE"],dateformat_style_) & ' ' & timeformat(jj["ACTION_DATE"],'HH:MM')>
                <cfif get_module_pu.get_module_power_user(7) <!--- and not listfindnocase(caller.denied_pages,'home.act_ban') ---->>
                    <cfset result.data[counter]["FUSEACTION"][item]["TRUSH"] = true></cfif>
                <cfset item++>
            </cfloop>
            <cfset counter++>
            <cfset result.totalCount = counter>
        </cfloop>
        <!---
        <cfdump var="#result.data#"><cfabort>--->

		<cfreturn Replace(serializeJSON(result),'//','')>
    </cffunction>
      
    <cffunction name="GET_EMPLOYEES" access="remote" returntype="any" returnFormat="json">
        <cfargument name="startrow" default="1">
        <cfargument name="maxrows" default="#session.ep.maxrows#">
        <cfargument name="searchEmp" default="">
        <cfset result = StructNew()>

        <cfquery name = "get_employe_position" datasource = "#dsn#">
            SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #my_id#
        </cfquery>

        <cfquery name="GET_EMPLOYEES" datasource="#dsn#">
        
        WITH CTE1 AS(    
            SELECT
                E.EMPLOYEE_ID,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME,
                E.PHOTO,
                EP.POSITION_NAME
            FROM EMPLOYEES AS E
            LEFT JOIN EMPLOYEES_DETAIL AS E2 ON E.EMPLOYEE_ID = E2.EMPLOYEE_ID
            LEFT JOIN EMPLOYEE_POSITIONS AS EP ON E2.EMPLOYEE_ID = EP.EMPLOYEE_ID 
            WHERE
                EMPLOYEE_STATUS = 1
                AND EP.POSITION_NAME IS NOT NULL 
                AND EP.POSITION_NAME <> ''
                AND EP.POSITION_ID IN(
                    SELECT POSITION_ID 
                    FROM EMPLOYEE_POSITION_PERIODS
                    WHERE PERIOD_ID IN (
                        SELECT POSEP.PERIOD_ID
                        FROM 
                            SETUP_PERIOD POSSP, 
                            EMPLOYEE_POSITION_PERIODS POSEP,
                            OUR_COMPANY POSO
                        WHERE 
                            POSEP.PERIOD_ID = POSSP.PERIOD_ID AND 
                            POSEP.POSITION_ID = #get_employe_position.POSITION_ID# AND
                            POSSP.OUR_COMPANY_ID = POSO.COMP_ID	
                    )
                )
                <cfif len(arguments.searchEmp)>
                    AND E.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchEmp#%">
                </cfif>
        ),
        CTE2 AS (
                SELECT
                    CTE1.*,
                    ROW_NUMBER() OVER (	 
                      ORDER BY EMPLOYEE_NAME ASC						    							    
                    ) AS RowNum,
                    (SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                FROM
                    CTE1
        )
        SELECT
            CTE2.*
        FROM
            CTE2
        WHERE
        RowNum BETWEEN #arguments.startrow# and #arguments.startrow#+(#arguments.maxrows#-1)
        </cfquery>

        <cfif GET_EMPLOYEES.recordcount>
            <cfset result.status = true>
            <cfset result.data = returnData(serializeJSON(GET_EMPLOYEES))>
        <cfelse>
            <cfset result.status = false>
        </cfif>
        
        <cfreturn Replace(serializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="DEL_MESSAGES" access="remote" returntype="any">
        <cfif len(arguments.sender_id) and len(arguments.receiver_id)>
            <cfquery name="DEL_MESSAGES" datasource="#dsn#">
                DELETE FROM WRK_MESSAGE 
                WHERE 
                    (SENDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sender_id#"> AND 
                    RECEIVER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.receiver_id#">) 
                    OR
                    (SENDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.receiver_id#"> AND 
                    RECEIVER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sender_id#">) 
            </cfquery>
            <cfset result = true>
        <cfelse>
            <cfset result = false>
        </cfif>
        <cfreturn result> 
    </cffunction>

    <cffunction name="GET_PROCESS_MESSAGE" returntype="any" access="remote" returnFormat="json">
        <cfargument name="startrowprocess" default="1">
        <cfargument name="maxrowsprocess" default="#session.ep.maxrows#">
        <cfargument name="searchProcess" default="">
        <cfargument name="incomingProcess" default="">
        <cfargument name="outgoingProcess" default="">
        <cfargument name="allProcess" default="">
        <cfset result = StructNew()>
        <cfquery name="GET_PROCESS_MESAGE" datasource="#dsn#">
        
        WITH CTE1 AS(    
            SELECT
                WM.ACTION_PAGE,
                WM.ACTION_ID, 
                WM.ACTION_COLUMN,
                WM.RECEIVER_ID,
                WM.WRK_MESSAGE_ID,
                WM.SENDER_ID,
                WM.MESSAGE,
                WM.FUSEACTION,
                WM.WARNING_HEAD, 
                E.EMPLOYEE_NAME, 
                E.EMPLOYEE_SURNAME, 
                E.EMPLOYEE_ID, 
                E.PHOTO, 
                ED.SEX
            FROM EMPLOYEES AS E
            INNER JOIN workcube_devcatalyst.EMPLOYEES_DETAIL AS ED ON E.EMPLOYEE_ID = ED.EMPLOYEE_ID 
            RIGHT JOIN workcube_devcatalyst.WRK_MESSAGE AS WM ON 
                (<cfif len(arguments.outgoingProcess) and arguments.outgoingProcess eq 1>E.EMPLOYEE_ID = WM.RECEIVER_ID<cfelse>E.EMPLOYEE_ID = WM.SENDER_ID</cfif>) 
            WHERE
                1=1 AND
                <cfif len(arguments.allProcess) and arguments.allProcess eq 1> <!--- tüm süreç mesajları --->
                    WM.RECEIVER_ID = #my_id# AND 
                    WM.SENDER_ID != #my_id# AND
                <cfelseif len(arguments.outgoingProcess) and arguments.outgoingProcess eq 1> <!--- benden gidenler --->
                    WM.SENDER_ID = #my_id# AND 
                    WM.RECEIVER_ID != #my_id# AND
                <cfelseif len(arguments.incomingProcess) and arguments.incomingProcess eq 1> <!--- bana gelenler --->
                    WM.RECEIVER_ID = #my_id# AND 
                    WM.SENDER_ID != #my_id# AND
                </cfif>
                WM.ACTION_PAGE IS NOT NULL AND
                WM.ACTION_ID IS NOT NULL
                <cfif len(arguments.searchProcess)>
                    AND WM.MESSAGE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchProcess#%">
                </cfif>
        ),
        CTE2 AS (
                SELECT
                    CTE1.*,
                    ROW_NUMBER() OVER (	 
                      ORDER BY WRK_MESSAGE_ID DESC						    							    
                    ) AS RowNum,
                    (SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                FROM
                    CTE1
        )
        SELECT
            CTE2.*
        FROM
            CTE2
        WHERE
            RowNum BETWEEN #arguments.startrowprocess# and #arguments.startrowprocess#+(#arguments.maxrowsprocess#-1)
        </cfquery>

        <cfif GET_PROCESS_MESAGE.recordcount>
            <cfset result.status = true>
            <cfset result.data = returnData(serializeJSON(GET_PROCESS_MESAGE))>
        <cfelse>
            <cfset result.status = false>
        </cfif>
        
        <cfreturn Replace(serializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="MESSAGE_COUNTER" returntype="any" access="remote">
        <cfif isDefined('session.ep.userid')>
            <cfset my_id = session.ep.userid>
            <cfset receiver_type = 0>
        <cfelseif isDefined('session.pp.userid')>
            <cfset my_id = session.pp.userid>
            <cfset receiver_type = 1>
        <cfelseif isDefined('session.ww.userid')>
            <cfset my_id = session.ww.userid>
            <cfset receiver_type = 2>
        </cfif>

        <cfquery name="MESSAGE_COUNTER" datasource="#dsn#">
            
            IF (NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'WRK_MESSAGE_GROUP_EMP_MSG' ) )
            BEGIN

                CREATE TABLE [WRK_MESSAGE_GROUP_EMP_MSG](
                    [WGEM_ID] [int] IDENTITY(1,1) NOT NULL,
                    [WG_ID] [int] NOT NULL,
                    [WRK_MESSAGE_ID] [int] NOT NULL,
                    [EMPLOYEE_ID] [int] NOT NULL,
                    [IS_ALERTED] [bit] NULL CONSTRAINT [DF_WRK_MESSAGE_GROUP_EMP_MSG_IS_ALERTED]  DEFAULT ((0)),
                    [IS_DELETED] [bit] NULL CONSTRAINT [DF_WRK_MESSAGE_GROUP_EMP_MSG_IS_DELETED]  DEFAULT ((0)),
                CONSTRAINT [PK_WRK_MESSAGE_GROUP_EMP_MSG] PRIMARY KEY CLUSTERED 
                (
                    [WGEM_ID] ASC
                )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
                ) ON [PRIMARY]
            
            END;
            
            SELECT
                COUNT(WM.WRK_MESSAGE_ID) AS COUNT
            FROM
                WRK_MESSAGE AS WM
                LEFT JOIN WRK_MESSAGE_GROUP_EMP_MSG AS WGEM ON WM.WRK_MESSAGE_ID = WGEM.WRK_MESSAGE_ID
            WHERE
                (WM.RECEIVER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#my_id#"> OR WGEM.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#my_id#">)
                AND WM.RECEIVER_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#receiver_type#">
                AND ( (WM.RECEIVER_ID IS NOT NULL AND (WM.IS_ALERTED IS NULL OR WM.IS_ALERTED = 0)) OR (WGEM.EMPLOYEE_ID IS NOT NULL AND WGEM.IS_ALERTED = 0) )
        </cfquery>
        <cfreturn MESSAGE_COUNTER>

    </cffunction>

</cfcomponent>