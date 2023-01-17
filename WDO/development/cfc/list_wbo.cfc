<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getWbo" returntype="query">
    	<cfargument name="dsn" required="yes">
        <cfquery name="GET_MODULES" datasource="#arguments.DSN#">
            SELECT
            	ISNULL(Replace(S3.ITEM_#UCASE(session.ep.language)#,'''',''),WS.SOLUTION) AS SOLUTION,
                ISNULL(Replace(S2.ITEM_#UCASE(session.ep.language)#,'''',''),WF.FAMILY) AS FAMILY,
                ISNULL(Replace(S1.ITEM_#UCASE(session.ep.language)#,'''',''),WM.MODULE) AS MODULE,
                WM.MODULE_NO AS MODUL_NO,
                WM.MODULE_TYPE
            FROM
                WRK_MODULE AS WM
                LEFT JOIN SETUP_LANGUAGE_TR AS S1 ON WM.MODULE_DICTIONARY_ID = S1.DICTIONARY_ID
                LEFT JOIN WRK_FAMILY AS WF ON WM.FAMILY_ID = WF.WRK_FAMILY_ID
                LEFT JOIN SETUP_LANGUAGE_TR AS S2 ON WF.FAMILY_DICTIONARY_ID = S2.DICTIONARY_ID
                LEFT JOIN WRK_SOLUTION AS WS ON WF.WRK_SOLUTION_ID = WS.WRK_SOLUTION_ID
                LEFT JOIN SETUP_LANGUAGE_TR AS S3 ON WS.SOLUTION_DICTIONARY_ID = S3.DICTIONARY_ID
            ORDER BY
                Replace(S3.ITEM_#UCASE(session.ep.language)#,'''',''),
                Replace(S2.ITEM_#UCASE(session.ep.language)#,'''',''),
                Replace(S1.ITEM_#UCASE(session.ep.language)#,'''','')
        </cfquery>
        <cfreturn GET_MODULES>
    </cffunction>
    <cffunction name="getUserName" returntype="query">
    	<cfargument name="dsn" required="yes">
    	<cfargument name="userid" required="yes">
        <cfquery name="GET_USER_NAME" datasource="#DSN#">
            SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">
        </cfquery>
        <cfreturn GET_USER_NAME>
    </cffunction>
    <cffunction name="getWboList" returntype="query">
		<cfscript>
            WBO_TYPES = QueryNew("TYPE_ID, TYPE_NAME");
            QueryAddRow(WBO_TYPES,12);
            QuerySetCell(WBO_TYPES,"TYPE_ID",50,1);
            QuerySetCell(WBO_TYPES,"TYPE_NAME","Ajax List",1);
            QuerySetCell(WBO_TYPES,"TYPE_ID",30,2);
            QuerySetCell(WBO_TYPES,"TYPE_NAME","Detail",2);		
            QuerySetCell(WBO_TYPES,"TYPE_ID",90,3);
            QuerySetCell(WBO_TYPES,"TYPE_NAME","Display",3);
            QuerySetCell(WBO_TYPES,"TYPE_ID",10,4);
            QuerySetCell(WBO_TYPES,"TYPE_NAME","Form Add",4);
            QuerySetCell(WBO_TYPES,"TYPE_ID",11,5);
            QuerySetCell(WBO_TYPES,"TYPE_NAME","Form Update",5);
            QuerySetCell(WBO_TYPES,"TYPE_ID",80,6);
            QuerySetCell(WBO_TYPES,"TYPE_NAME","Function",6);	
            QuerySetCell(WBO_TYPES,"TYPE_ID",40,7);
            QuerySetCell(WBO_TYPES,"TYPE_NAME","List",7);
            QuerySetCell(WBO_TYPES,"TYPE_ID",70,8);
            QuerySetCell(WBO_TYPES,"TYPE_NAME","Menu",8);
            QuerySetCell(WBO_TYPES,"TYPE_ID",60,9);
            QuerySetCell(WBO_TYPES,"TYPE_NAME","Report",9);
            QuerySetCell(WBO_TYPES,"TYPE_ID",20,10);
            QuerySetCell(WBO_TYPES,"TYPE_NAME","Query Add",10);
            QuerySetCell(WBO_TYPES,"TYPE_ID",21,11);
            QuerySetCell(WBO_TYPES,"TYPE_NAME","Query Update",11);
            QuerySetCell(WBO_TYPES,"TYPE_ID",22,12);
            QuerySetCell(WBO_TYPES,"TYPE_NAME","Query Delete",12);
        </cfscript>
        <cfreturn WBO_TYPES>
    </cffunction>
    <cffunction name="getProcessTypes" returntype="query">
        <cfset upload_folder = replaceNoCase(replaceNoCase(GetDirectoryFromPath(GetCurrentTemplatePath()),"\WDO\development\cfc\",""), "/WDO/development/cfc/","")>
        <cffile action="read" variable="xmldosyam" file="#upload_folder#/V16/admin_tools/xml/setup_process_cat.xml" charset = "UTF-8">
        <cfset dosyam = XmlParse(xmldosyam)>
        <cfset xml_dizi = dosyam.workcube_process_types.XmlChildren>
        <cfset d_boyut = ArrayLen(xml_dizi)>
        <!--- Create query from setup_process_xml list --->
        <cfset process_type_list = queryNew("PROCESS_CAT_ID,PROCESS_CAT")>
        <cfloop index="i" from="1" to="#d_boyut#">
			<cfset queryAddRow(process_type_list)>
            <cfset aaa = dosyam.workcube_process_types.process[i].process_type.XmlText>
            <cfset aaa = listappend(aaa,dosyam.workcube_process_types.process[i].process_cat.XmlText,';')>
            <cfset querySetCell(process_type_list,"PROCESS_CAT_ID", aaa)>
            <cfset querySetCell(process_type_list,"PROCESS_CAT", dosyam.workcube_process_types.process[i].process_cat.XmlText)>
        </cfloop>
        <cfreturn process_type_list>
    </cffunction>
    <cffunction name="getWrkFuesactions" returntype="query">
    	<cfargument name="dsn" required="yes">
        <cfargument name="woid" required="yes">
        <cfquery name="GET_WRK_FUSEACTIONS" datasource="#arguments.DSN#">
             SELECT
             	W.WRK_OBJECTS_ID,
                W.STATUS,
                W.MODUL,
                W.STAGE,
                W.MODUL_SHORT_NAME,
                W.HEAD,
                W.TYPE,
                W.IS_ACTIVE,
                W.FILE_NAME,
                W.IS_ADD,
                W.IS_UPDATE,
                W.IS_DELETE,
            	W.OBJECTS_COUNT,
             	W.FRIENDLY_URL,
                W.EXTERNAL_FUSEACTION,
                W.LICENCE,
                W.MODULE_NO,
                W.AUTHOR,
                W.WATOMIC_SOLUTION_ID,
                W.WATOMIC_FAMILY_ID,
                W.ICON,
                IS_PUBLIC,
                IS_EMPLOYEE,
                IS_CONSUMER,
                IS_COMPANY,
                IS_EMPLOYEE_APP,
                IS_LIVESTOCK,
                IS_MACHINES,
                <cfif isdefined("arguments.woid") and len(arguments.woid)>
                    W.DICTIONARY_ID,
                    W.FILE_PATH,
                    W.FUSEACTION,
                    W.FULL_FUSEACTION,
                    W.TYPE,
                    W.WINDOW,
                    W.SECURITY,
                    W.DETAIL,
                    W.RECORD_IP,
                    W.RECORD_EMP,
                    W.RECORD_DATE,
                    W.UPDATE_IP,
                    W.UPDATE_EMP,
                    W.UPDATE_DATE,
                    W.IS_WBO_DENIED,
                    W.IS_WBO_LOCK,
                    W.IS_WBO_LOG,
                    W.IS_SPECIAL,
                    W.IS_MENU,
                    W.POPUP_TYPE,
                    W.CONTROLLER_FILE_PATH,
                    W.ADDOPTIONS_CONTROLLER_FILE_PATH,
                    W.VERSION,
                    W.MAIN_VERSION,
                    WS.WRK_SOLUTION_ID AS SOLUTION_ID,
                    WF2.WRK_FAMILY_ID AS FAMILY_ID,
                    W.USE_PROCESS_CAT,
                    W.USE_WORKFLOW,
                    W.USE_SYSTEM_NO,
                    W.EVENT_ADD,
                    W.EVENT_UPD,
                    W.EVENT_LIST,
                    W.EVENT_DETAIL,
                    W.EVENT_DASHBOARD,
                    W.EVENT_OUTPUT,
                    W.IS_LEGACY,
                    W.DISPLAY_BEFORE_PATH,
                    W.DISPLAY_AFTER_PATH,
                    W.ACTION_BEFORE_PATH,
                    W.ACTION_AFTER_PATH,
                    XML_PATH,
                    W.DATA_CFC
                <cfelse>
                	W.FULL_FUSEACTION,
                    W.BASE,
                    W.FOLDER,
                    WS.SOLUTION_DICTIONARY_ID,
                    WF2.FAMILY_DICTIONARY_ID,
                    M.MODULE_DICTIONARY_ID,
                    WWF.WRK_WATOMIC_FAMILY_DICTONARY_ID,
                    WWS.WRK_WATOMIC_SOLUTION_DICTIONARY_ID
                </cfif>
            FROM
                WRK_OBJECTS AS W
                LEFT JOIN WRK_MODULE AS M ON W.MODULE_NO = M.MODULE_NO
                LEFT JOIN WRK_FAMILY AS WF2 ON WF2.WRK_FAMILY_ID = M.FAMILY_ID
                LEFT JOIN WRK_SOLUTION AS WS ON WS.WRK_SOLUTION_ID = WF2.WRK_SOLUTION_ID
                LEFT JOIN WRK_WATOMIC_SOLUTION AS WWS ON WWS.WRK_WATOMIC_SOLUTION_ID = W.WATOMIC_SOLUTION_ID
                LEFT JOIN WRK_WATOMIC_FAMILY AS WWF ON WWF.WRK_WATOMIC_FAMILY_ID=  W.WATOMIC_FAMILY_ID
            WHERE 
            	<cfif isdefined("arguments.woid") and len(arguments.woid)>
                	W.WRK_OBJECTS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.woid#">
                <cfelse>
                    W.WRK_OBJECTS_ID IS NOT NULL
                    <cfif isdefined("arguments.solution") and len(arguments.solution)>
                        AND WS.WRK_SOLUTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.solution#">
                    </cfif>
                    <cfif isdefined("arguments.family") and len(arguments.family)>
                        AND WF2.WRK_FAMILY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.family#">
                    </cfif>
                    <cfif isdefined("arguments.module") and len(arguments.module)>
                        AND M.MODULE_NO = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.module#">
                    </cfif>
                    <cfif isdefined("arguments.is_menu") and len(arguments.is_menu)>
                        AND W.IS_MENU = 1
                    </cfif>
                     <cfif isdefined("arguments.is_legacy") and len(arguments.is_legacy)>
                        AND W.IS_LEGACY = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_legacy#">
                    </cfif>
                    <cfif isdefined("arguments.typeObject") and len(arguments.typeObject)>
                        AND W.TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.typeObject#">
                    </cfif>
                    <cfif isdefined("arguments.author") and len(arguments.author)>
                        AND W.AUTHOR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.author#%">
                    </cfif>
                    <cfif isdefined("arguments.main_version") and len(arguments.main_version)>
                        AND W.MAIN_VERSION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.main_version#">
                    </cfif>
                    <cfif isdefined("arguments.keyword") and len(arguments.keyword)>
                        AND 
                        (
                            W.FUSEACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
                            W.HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
                            W.FRIENDLY_URL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
                            W.FULL_FUSEACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
                            W.EXTERNAL_FUSEACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                        )
                    </cfif>
                    <cfif isdefined("arguments.licence") and len(arguments.licence)>
                        AND W.LICENCE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.licence#">
                    </cfif>
                    <cfif isdefined("arguments.status") and len(arguments.status)>
                        AND W.STATUS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status#">
                    </cfif>
                    <cfif isdefined("arguments.publish_on") and len(arguments.publish_on)>
                        <cfif listfind(arguments.publish_on,'is_public',',')>AND IS_PUBLIC = 1</cfif>
                        <cfif listfind(arguments.publish_on,'is_employee',',')>AND IS_EMPLOYEE = 1</cfif>
                        <cfif listfind(arguments.publish_on,'is_consumer',',')>AND IS_CONSUMER = 1</cfif>
                        <cfif listfind(arguments.publish_on,'is_company',',')>AND IS_COMPANY = 1</cfif>
                        <cfif listfind(arguments.publish_on,'is_livestock',',')>AND IS_LIVESTOCK = 1</cfif>
                        <cfif listfind(arguments.publish_on,'is_machines',',')>AND IS_MACHINES = 1</cfif>
                        <cfif listfind(arguments.publish_on,'is_employee_app',',')>AND IS_EMPLOYEE_APP = 1</cfif>
                    </cfif>
                    <cfif isdefined("arguments.events") and len(arguments.events)>
                        <cfif listfind(arguments.events,'is_add',',')>AND EVENT_ADD = 1</cfif>
                        <cfif listfind(arguments.events,'is_update',',')>AND EVENT_UPD = 1</cfif>
                        <cfif listfind(arguments.events,'is_list',',')>AND EVENT_LIST = 1</cfif>
                        <cfif listfind(arguments.events,'is_detail',',')>AND EVENT_DETAIL = 1</cfif>
                        <cfif listfind(arguments.events,'is_dashboard',',')>AND EVENT_DASHBOARD = 1</cfif>
                        <cfif listfind(arguments.events,'is_output',',')>AND EVENT_OUTPUT = 1</cfif>
                    </cfif>
                    <cfif isdefined("arguments.wat_solution") and len(arguments.wat_solution)>
                        AND W.WATOMIC_SOLUTION_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wat_solution#">
                    </cfif>
                    <cfif isdefined("arguments.wat_family") and len(arguments.wat_family)>
                        AND W.WATOMIC_FAMILY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.wat_family#">
                    </cfif>
                    AND (W.FUSEACTION IS NOT NULL OR W.EXTERNAL_FUSEACTION IS NOT NULL)
                </cfif>
            ORDER BY W.RECORD_DATE DESC
        </cfquery>
        <cfreturn GET_WRK_FUSEACTIONS>
    </cffunction>
    <cffunction name="getWrkObjectsId" returntype="any">
    	<cfargument name="dsn" required="yes">
    	<cfargument name="fuseact" required="yes">
        <cfargument name="fuseactExternal" required="yes">
        <cfquery name="GET_WRK_OBJECTS_ID" datasource="#arguments.DSN#">
             SELECT
                WRK_OBJECTS_ID
            FROM
                WRK_OBJECTS
            WHERE 
            	<cfif len(arguments.fuseact)>
	                FULL_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fuseact#">
                <cfelse>
                	EXTERNAL_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fuseactExternal#">
                </cfif>
        </cfquery>
        <cfreturn GET_WRK_OBJECTS_ID.WRK_OBJECTS_ID>
    </cffunction>
    <cffunction name="getSolution" returntype="query">
        <cfquery name="GET_SOLUTION" datasource="#dsn#">
            SELECT
            	WRK_SOLUTION_ID,
                ISNULL(SL.ITEM_#session.ep.language#,WS.SOLUTION) AS NAME,
                SOLUTION_DICTIONARY_ID
            FROM
                WRK_SOLUTION WS
                LEFT JOIN SETUP_LANGUAGE_TR SL ON WS.SOLUTION_DICTIONARY_ID = SL.DICTIONARY_ID
			ORDER BY
            	ISNULL(SL.ITEM_#session.ep.language#,WS.SOLUTION)
        </cfquery>
        <cfreturn GET_SOLUTION>
    </cffunction>
    <cffunction name="getWatomicSolution" returntype="query">
        <cfquery name="GET_WATOMIC_SOLUTION" datasource="#dsn#">
            SELECT
                WRK_WATOMIC_SOLUTION_ID,
                ISNULL(SL.ITEM_#session.ep.language#,WWS.WRK_WATOMIC_SOLUTION_NAME) AS NAME,
                WRK_WATOMIC_SOLUTION_DICTIONARY_ID
            FROM
                WRK_WATOMIC_SOLUTION WWS
                LEFT JOIN SETUP_LANGUAGE_TR SL ON WWS.WRK_WATOMIC_SOLUTION_DICTIONARY_ID = SL.DICTIONARY_ID
			ORDER BY
            	ISNULL(SL.ITEM_#session.ep.language#,WWS.WRK_WATOMIC_SOLUTION_NAME)
        </cfquery>
        <cfreturn GET_WATOMIC_SOLUTION>
    </cffunction>
    <cffunction name="getWatomicFamily" returntype="query">
        <cfquery name="getWatomicFamily" datasource="#dsn#">
            SELECT
                WRK_WATOMIC_FAMILY_ID,
                ISNULL(SL.ITEM_#session.ep.language#,WWF.WATOMIC_FAMILY_NAME) AS NAME,
                WRK_WATOMIC_FAMILY_DICTONARY_ID
            FROM
                WRK_WATOMIC_FAMILY WWF
                LEFT JOIN SETUP_LANGUAGE_TR SL ON WWF.WRK_WATOMIC_FAMILY_DICTONARY_ID = SL.DICTIONARY_ID
            ORDER BY
                ISNULL(SL.ITEM_#session.ep.language#,WWF.WATOMIC_FAMILY_NAME)
        </cfquery>
        <cfreturn getWatomicFamily>
    </cffunction>
    <cffunction name="getFamily" returntype="query">
        <cfquery name="getFamily" datasource="#dsn#">
            SELECT
                ISNULL(SL.ITEM_#session.ep.language#,WF.FAMILY) AS NAME,
                FAMILY_DICTIONARY_ID
            FROM
                WRK_FAMILY WF
                LEFT JOIN SETUP_LANGUAGE_TR SL ON WF.FAMILY_DICTIONARY_ID = SL.DICTIONARY_ID
            ORDER BY
                ISNULL(SL.ITEM_#session.ep.language#,WF.FAMILY)
        </cfquery>
        <cfreturn getFamily>
    </cffunction>
    <cffunction name="getModule" returntype="query">
        <cfquery name="getModule" datasource="#dsn#">
            SELECT
                ISNULL(SL.ITEM_#session.ep.language#,M.MODULE) AS NAME,
                MODULE_DICTIONARY_ID
            FROM
                WRK_MODULE M
                LEFT JOIN SETUP_LANGUAGE_TR SL ON M.MODULE_DICTIONARY_ID = SL.DICTIONARY_ID
            ORDER BY
                ISNULL(SL.ITEM_#session.ep.language#,M.MODULE)
        </cfquery>
        <cfreturn getModule>
    </cffunction>
    
    <cffunction name="getWboTypeList" returntype="string">
    	<cfargument name="type" required="yes">
    	<cfargument name="IS_ADD" required="yes">
        <cfargument name="IS_UPDATE" required="yes">
        <cfargument name="IS_DELETE" required="yes">
		<cfset wbo_type_list = "">
        <!--- DB den gelen tip alanları gosterimi icin eklendi --->
        <cfif arguments.type eq 1><!--- Form --->
            <cfif arguments.IS_ADD EQ 1><!--- Ekleme --->
                <cfset wbo_type_list = listappend(wbo_type_list,10)>
            </cfif>
            <cfif arguments.IS_UPDATE EQ 1><!--- Guncelleme --->
                <cfset wbo_type_list = listappend(wbo_type_list,11)>
            </cfif>
        <cfelseif arguments.TYPE eq 2><!--- Query --->
            <cfif arguments.IS_ADD EQ 1><!--- Ekleme --->
                <cfset wbo_type_list = listappend(wbo_type_list,20)>
            </cfif>
            <cfif arguments.IS_UPDATE EQ 1><!--- Guncelleme --->
                <cfset wbo_type_list = listappend(wbo_type_list,21)>
            </cfif>
            <cfif arguments.IS_DELETE EQ 1><!--- Silme --->
                <cfset wbo_type_list = listappend(wbo_type_list,22)>
            </cfif>
        <cfelseif arguments.TYPE eq 3><!--- Detail --->
            <cfset wbo_type_list = listappend(wbo_type_list,30)>
        <cfelseif arguments.TYPE eq 4><!--- List --->
            <cfset wbo_type_list = listappend(wbo_type_list,40)>
        <cfelseif arguments.TYPE eq 5><!--- Ajax List --->
            <cfset wbo_type_list = listappend(wbo_type_list,50)>	
        <cfelseif arguments.TYPE eq 6><!--- Report --->
            <cfset wbo_type_list = listappend(wbo_type_list,60)>
        <cfelseif arguments.TYPE eq 7><!--- Menu --->
            <cfset wbo_type_list = listappend(wbo_type_list,70)>
        <cfelseif arguments.TYPE eq 8><!--- Function --->
            <cfset wbo_type_list = listappend(wbo_type_list,80)>
        <cfelseif arguments.TYPE eq 9><!--- Display --->
            <cfset wbo_type_list = listappend(wbo_type_list,90)>
        </cfif>
        <cfreturn wbo_type_list/>
    </cffunction>
    <cffunction name="getRelatedProcessCat" returntype="query">
    	<cfargument name="dsn" required="yes">
    	<cfargument name="woid" required="yes">
        <cfquery name="related_process_cat" datasource="#arguments.DSN#">
             SELECT
                PROCESS_CAT
            FROM
                WRK_OBJ_PROCESS_CAT
            WHERE 
                WRK_OBJECTS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.woid#">
        </cfquery>
        <cfreturn RELATED_PROCESS_CAT>
    </cffunction>
    
    <cffunction name="getBestpractice" returntype="query">
        <cfquery name="query_bp" datasource="#dsn#">
            SELECT * FROM WRK_BESTPRACTICE
        </cfquery>
        <cfreturn query_bp>
    </cffunction>

    <cffunction name="getObjectsBestpractice" returntype="query">
        <cfargument name="woid">
        <cfquery name="query_this_bp" datasource="#dsn#">
            SELECT * FROM WRK_OBJECTS_BESTPRACTICE WHERE OBJECT_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.woid#'> 
        </cfquery>
        <cfreturn query_this_bp>
    </cffunction>
</cfcomponent>
