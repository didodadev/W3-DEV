<!---
File: list_designer.cfm
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Controller: VisualDesignerController.cfm
Description: İş akış tasarımcısı fonsiyonların çağırıldığı cfc'dir.
--->
<cfcomponent displayname="Board"  hint="ColdFusion Component for Kullanicilar">
<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="GET_XML"  hint="" access="remote">
        <cfargument name="id" >
        <cfquery name="GET_XML" datasource="#dsn#" result="result_xml">
        SELECT * FROM VISUAL_DESIGNER  WHERE PROCESS_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
        </cfquery>
        <cfreturn GET_XML>
    </cffunction>
    <cffunction name="GET_LIST"  hint="" access="remote">
        <cfargument name="startrow" default="">
        <cfargument name="maxrows" default="">
        <cfargument name="keyword" default="">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="">
         <cfargument name="action_section" default="">
        <cfargument name="relative_id" default="">
        <cfquery name="GET_LIST" datasource="#dsn#">
            WITH CTE1 AS (
                SELECT 
                    * 
                FROM 
                VISUAL_DESIGNER
                WHERE
                1 = 1  
                <cfif isdefined('arguments.keyword') and len(arguments.keyword)>
                    AND FILE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                </cfif>
                <cfif isdefined('arguments.action_section') and len(arguments.action_section)>
                    AND ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_section#">
                </cfif>
                 <cfif isdefined('arguments.relative_id') and len(arguments.relative_id)>
                    AND RELATIVE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.relative_id#">
                </cfif>
                ),
                CTE2 AS (
                     SELECT
                         CTE1.*,
                         ROW_NUMBER() OVER ( ORDER BY PROCESS_ID DESC) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                         FROM
                             CTE1
                     )
                     SELECT
                         CTE2.*
                     FROM
                         CTE2
                     WHERE
                         RowNum BETWEEN #startrow# and #startrow#+(#maxrows#-1)
        </cfquery>
        <cfreturn GET_LIST>
    </cffunction>
    <cffunction name="ADD_WRK_SESSION_TO_DB"  hint="" access="remote">
        <cfargument name="xml" default="">
        <cfargument name="filename" default="">
        <cfargument name="type" default="">
        <cfargument name="action_section" default="">
        <cfargument name="relative_id" default="">
        <cfquery name="ADD_WRK_SESSION_TO_DB" datasource="#DSN#">
            INSERT INTO 
                VISUAL_DESIGNER
                (
                    TYPE,
                    XML,
                    FILE_NAME,
                    ACTION_SECTION,
                    RELATIVE_ID,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDecode(arguments.type)#">,                   
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDecode(arguments.xml)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDecode(arguments.filename)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDecode(arguments.action_section)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDecode(arguments.relative_id)#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#SESSION.EP.USERID#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
                )
        </cfquery>
        <cfreturn 1>
    </cffunction>
    <cffunction name="UPD_WRK_SESSION_TO_DB"  hint="" access="remote">
        <cfargument name="xml" default="">
        <cfargument name="filename" default="">
        <cfargument name="c_id" default="">
        <cfquery name="UPD_WRK_SESSION_TO_DB" datasource="#DSN#">
            UPDATE 
                VISUAL_DESIGNER
            SET
                XML = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDecode(arguments.xml)#">,
                FILE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDecode(arguments.filename)#">,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
            WHERE 
                PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.c_id#">
        </cfquery>
        <cfreturn 1>
    </cffunction>
    <cffunction name="GET_LAST_ID"  hint="" access="remote">    
        <cfquery name="GET_LAST_ID" datasource="#DSN#">
            SELECT MAX(PROCESS_ID) MAX_ID FROM VISUAL_DESIGNER 
        </cfquery>
        <cfreturn GET_LAST_ID>
    </cffunction>
    <cffunction name="ADD_MAIN_DESIGNER"  hint="" access="remote">
        <cfargument name="xml" default="">
        <cfargument name="filename" default="">
        <cfargument name="type" default="">
        <cfargument name="main_process_id" default="">
        <cfset xml_decode = URLDecode(arguments.xml)>
        <cfscript>
            MyDoc = XmlNew(); 
            MyDoc = XMLParse(xml_decode);//editörden gelen xml formatını parse ediyor.
        </cfscript>
       
        <cfloop array = "#MyDoc.mxGraphModel.root.XmlChildren#" index = "key"><!--- Array'e atılan elemanları db'ye kayıt ediyor----->
            <cfif isdefined("key.XmlAttributes.style")>
                <cfif ListGetAt(key.XmlAttributes.style,1,';') eq 'process'><!-----eğer process objesi seçiliyse ----->
                    <cftransaction>
                        <cftry>
                            <cfquery name="save_process_type" datasource="#dsn#">
                                INSERT INTO PROCESS_TYPE
                                    (
                                    PROCESS_NAME,
                                    IS_ACTIVE,
                                    RECORD_DATE,
                                    RECORD_EMP,
                                    RECORD_IP
                                    )
                                VALUES
                                    (
                                    '#key.XmlAttributes.value#',
                                    1,
                                    #now()#,
                                    #SESSION.EP.USERID#,
                                    '#cgi.REMOTE_ADDR#'
                                    )
                            </cfquery>
                            <cfquery name="get_last_process_type" datasource="#dsn#">
                                SELECT MAX(PROCESS_ID) AS processID FROM PROCESS_TYPE
                            </cfquery>
                            <cfset process_id = get_last_process_type.processID>
                            <cfset key.XmlAttributes.pid = process_id>
                            <cfquery name="save_object" datasource="#dsn#">	
                                INSERT INTO PROCESS_MAIN_ROWS
                                    (
                                    PROCESS_MAIN_ID,
                                    PROCESS_ID,
                                    DESIGN_TITLE,
                                    DESIGN_OBJECT_TYPE,
                                    RECORD_DATE,
                                    RECORD_EMP,
                                    RECORD_IP
                                    )
                                VALUES
                                    (
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.main_process_id#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#process_id#">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#key.XmlAttributes.value#">, 
                                    0,
                                    #now()#,
                                    #SESSION.EP.USERID#,
                                    '#cgi.REMOTE_ADDR#'
                                    )
                            </cfquery>
                            <cfcatch type="any">
                                <cfreturn "#cfcatch.Message#\n\nDetail: #cfcatch.Detail#\n\nRaw Trace: #cfcatch.tagcontext[1].raw_trace#">
                            </cfcatch>
                        </cftry>
                    </cftransaction>
                </cfif>                    
            </cfif>
        </cfloop> 
       <cfloop array = "#MyDoc.mxGraphModel.root.XmlChildren#" index = "out">
            <cfif isdefined("out.XmlAttributes.style")><!---- 0 ve 1. id lileri almaması ---->
                <cfloop array = "#MyDoc.mxGraphModel.root.XmlChildren#" index = "in"><!----- process'in içerisine atılan objeler------>    
                    <cfif isdefined("in.XmlAttributes.style")>    
                        <cfif isdefined('in.XmlAttributes.parent') and in.XmlAttributes.parent eq out.XmlAttributes.id>
                            <cftransaction>
                                <cftry> 
                                    <cfquery name="update_process_in" datasource="#dsn#">
                                        UPDATE
                                            PROCESS_MAIN_ROWS
                                        SET 
                                            DISPLAY_HEADER = <cfif ListGetAt(in.XmlAttributes.style,1,';') eq 'display' and  len(in.XmlAttributes.value)>'#in.XmlAttributes.value#'<cfelse>'Display File'</cfif>,
                                            ACTION_HEADER = <cfif ListGetAt(in.XmlAttributes.style,1,';') eq 'action' and  len(in.XmlAttributes.value)>'#in.XmlAttributes.value#'<cfelse>'Action File'</cfif>
                                        WHERE 
                                            PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#out.XmlAttributes.pid#">
                                    </cfquery>
                                <cfcatch type="any">
                                    <cfdump var="#cfcatch#">
                                    <cfreturn "#cfcatch.Message#\n\nDetail: #cfcatch.Detail#\n\nRaw Trace: #cfcatch.tagcontext[1].raw_trace#">
                                </cfcatch>
                                </cftry>
                            </cftransaction>
                        </cfif>
                    </cfif>
                </cfloop>
            </cfif>
        </cfloop>
        <cfdump var="#MyDoc.mxGraphModel.root.XmlChildren#">
        <cfreturn 1>
    </cffunction>
    <cffunction name="DEL_DESIGNER" access="remote"  returntype="any"><!--- LLimit satır silme ---->
        <cfargument name="id" default="">
        <cfargument name="process_id" default="">  
        <cfquery name="DEL_HEALTH_ASSURANCE_TYPE_SUPPORT" datasource="#dsn#">
            DELETE FROM 
                VISUAL_DESIGNER 
            WHERE 
                <cfif len(arguments.id)>
                    RELATIVE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
                <cfelseif len(arguments.process_id)>
                    PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_id#">
                </cfif>
        </cfquery>
    </cffunction>
</cfcomponent>
