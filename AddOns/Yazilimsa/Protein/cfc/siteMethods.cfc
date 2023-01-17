<!---
    File :          AddOns\Yazilimsa\Protein\cfc\siteMethods.cfc
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          16.05.2020
    Description :   Protein temel methodlar
--->
<cfcomponent extends="cfc.queryJSONConverter">

    <cfheader name="Access-Control-Allow-Origin" value="*" />
    <cfheader name="Access-Control-Allow-Methods" value="GET,POST" />
    <cfheader name="Access-Control-Allow-Headers" value="Content-Type" /> 

    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset result = StructNew()>

    <cffunction name="get_general_definitions" access="remote" returntype="string" returnFormat="json">
        <cftry>
            <cfquery name="get_general_definitions" datasource="#dsn#">        	
                SELECT
                    SITE_ID AS ID,DOMAIN,STATUS,MAINTENANCE_MODE,PRIMARY_DATA
                FROM
                    PROTEIN_SITES
                WHERE
                    SITE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">  
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.id#>
            <cfset result.data = this.returnData(replace(serializeJSON(get_general_definitions),"//",""))>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="get_lang_and_money" access="remote" returntype="string" returnFormat="json">
        <cftry>
            <cfquery name="get_lang_and_money" datasource="#dsn#">        	
                SELECT
                    SITE_ID AS ID,COMPANY,ZONE_DATA
                FROM
                    PROTEIN_SITES
                WHERE
                    SITE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">  
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.id#>
            <cfset result.data = this.returnData(replace(serializeJSON(get_lang_and_money),"//",""))>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="get_access" access="remote" returntype="string" returnFormat="json">
        <cftry>
            <cfquery name="get_access" datasource="#dsn#">        	
                SELECT
                    SITE_ID AS ID,ACCESS_DATA
                FROM
                    PROTEIN_SITES
                WHERE
                    SITE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">  
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.id#>
            <cfset result.data = this.returnData(replace(serializeJSON(get_access),"//",""))>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="get_theme" access="remote" returntype="string" returnFormat="json">
        <cftry>
            <cfquery name="get_theme" datasource="#dsn#">        	
                SELECT
                    SITE_ID AS ID,THEME_DATA
                FROM
                    PROTEIN_SITES
                WHERE
                    SITE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">  
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.id#>
            <cfset result.data = this.returnData(replace(serializeJSON(get_theme),"//",""))>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="get_security" access="remote" returntype="string" returnFormat="json">
        <cftry>
            <cfquery name="get_security" datasource="#dsn#">        	
                SELECT
                    SITE_ID AS ID, SECURITY_DATA
                FROM
                    PROTEIN_SITES
                WHERE
                    SITE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">  
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.id#>
            <cfset result.data = this.returnData(replace(serializeJSON(get_security),"//",""))>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="get_privacy" access="remote" returntype="string" returnFormat="json">
        <cftry>
            <cfquery name="get_privacy" datasource="#dsn#">        	
                SELECT
                    SITE_ID AS ID, PRIVACY_DATA
                FROM
                    PROTEIN_SITES
                WHERE
                    SITE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">  
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.id#>
            <cfset result.data = this.returnData(replace(serializeJSON(get_privacy),"//",""))>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="get_mail_settings" access="remote" returntype="string" returnFormat="json">
        <cftry>
            <cfquery name="get_mail_settings" datasource="#dsn#">        	
                SELECT
                    SITE_ID AS ID, MAIL_SETTINGS_DATA
                FROM
                    PROTEIN_SITES
                WHERE
                    SITE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">  
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.id#>
            <cfset result.data = this.returnData(replace(serializeJSON(get_mail_settings),"//",""))>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="get_template" access="remote" returntype="string" returnFormat="json">
        <cftry>
            <cfquery name="get_template" datasource="#dsn#">        	
                SELECT
                    TEMPLATE_ID AS ID,SITE,STATUS,TYPE,TITLE,DESIGN_DATA
                FROM
                    PROTEIN_TEMPLATES
                WHERE
                    TEMPLATE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">  
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.id#>
            <cfset result.data = this.returnData(replace(serializeJSON(get_template),"//",""))>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="get_page" access="remote" returntype="string" returnFormat="json">
        <cftry>
            <cfquery name="get_page" datasource="#dsn#">        	
                SELECT
                    PAGE_ID AS ID,FRIENDLY_URL,TITLE,SITE,PAGE_DATA,TEMPLATE_BODY,TEMPLATE_INSIDE,STATUS
                FROM
                    PROTEIN_PAGES
                WHERE
                    PAGE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">  
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.id#>
            <cfset result.data = this.returnData(replace(serializeJSON(get_page),"//",""))>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="get_relatedInfo" access="remote" returntype="string" returnFormat="json">
        <cftry>
            <cfquery name="get_relatedInfo" datasource="#dsn#">        	
                SELECT
                    PAGE_ID AS ID,FRIENDLY_URL,TITLE,SITE,PAGE_DATA,TEMPLATE_BODY,TEMPLATE_INSIDE,STATUS
                FROM
                    PROTEIN_PAGES
                WHERE
                    PAGE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">  
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.id#>
            <cfset result.data = this.returnData(replace(serializeJSON(get_relatedInfo),"//",""))>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="get_related_page_event" access="remote" returntype="string" returnFormat="json">
        <cftry>
            <cfquery name="get_related_page_event" datasource="#dsn#">
                   SELECT PAGE_ID, 'add' EVENT, CASE PAGE_ID When #arguments.related_page# Then 0 ELSE 1 END AS CHILD_PAGE FROM PROTEIN_PAGES WHERE PAGE_DATA LIKE '%"RELATED_PAGE":"#arguments.related_page#"%' AND PAGE_DATA LIKE '%"EVENT":"add"%'
                   UNION ALL
                   SELECT PAGE_ID, 'upd' EVENT, CASE PAGE_ID When #arguments.related_page# Then 0 ELSE 1 END AS CHILD_PAGE FROM PROTEIN_PAGES WHERE PAGE_DATA LIKE '%"RELATED_PAGE":"#arguments.related_page#"%' AND PAGE_DATA LIKE '%"EVENT":"upd"%'
                   UNION ALL
                   SELECT PAGE_ID, 'list' EVENT, CASE PAGE_ID When #arguments.related_page# Then 0 ELSE 1 END AS CHILD_PAGE FROM PROTEIN_PAGES WHERE PAGE_DATA LIKE '%"RELATED_PAGE":"#arguments.related_page#"%' AND PAGE_DATA LIKE '%"EVENT":"list"%'
                   UNION ALL
                   SELECT PAGE_ID, 'det' EVENT, CASE PAGE_ID When #arguments.related_page# Then 0 ELSE 1 END AS CHILD_PAGE FROM PROTEIN_PAGES WHERE PAGE_DATA LIKE '%"RELATED_PAGE":"#arguments.related_page#"%' AND PAGE_DATA LIKE '%"EVENT":"det"%'
                   UNION ALL
                   SELECT PAGE_ID, 'dashboard' EVENT, CASE PAGE_ID When #arguments.related_page# Then 0 ELSE 1 END AS CHILD_PAGE FROM PROTEIN_PAGES WHERE PAGE_DATA LIKE '%"RELATED_PAGE":"#arguments.related_page#"%' AND PAGE_DATA LIKE '%"EVENT":"dashboard"%'
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.related_page#>
            <cfset result.data = this.returnData(replace(serializeJSON(get_related_page_event),"//",""))>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>   

    <cffunction name="get_megamenu" access="remote" returntype="string" returnFormat="json">
        <cftry>
            <cfquery name="get_megamenu" datasource="#dsn#">        	
                SELECT
                    MEGAMENU_ID AS ID,TITLE,SITE,MENU_ID MENU,MEGAMENU_ID,STATUS,MEGAMENU_DATA
                FROM
                    PROTEIN_MEGA_MENUS
                WHERE
                    MEGAMENU_ID =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#">  
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #get_megamenu.MEGAMENU_ID#>
            <cfset result.data = this.returnData(replace(serializeJSON(get_megamenu),"//",""))>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="get_widget" access="remote" returntype="string" returnFormat="json">
        <cftry>
            <cfquery name="get_widget" datasource="#dsn#">        	
                SELECT
                    PW.WIDGET_ID AS ID,
                    PW.SITE,
                    PW.TITLE,
                    PW.STATUS,
                    PW.WIDGET_NAME,
                    PW.WIDGET_DATA,
                    PW.WIDGET_EXTEND,
                    PW.WIDGET_BOX_DATA,
                    PW.WIDGET_SEO_DATA,
                    CW.WIDGET_FILE_PATH,
                    CW.WIDGET_TITLE,
                    CW.WIDGET_DESCRIPTION,
                    CW.WIDGET_AUTHOR,
                    CW.WIDGET_VERSION
                FROM
                    PROTEIN_WIDGETS PW
	                LEFT JOIN WRK_WIDGET CW ON PW.WIDGET_NAME = CW.WIDGETID
                WHERE
                    WIDGET_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">  
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.id#>
            <cfset result.data = this.returnData(replace(serializeJSON(get_widget),"//",""))>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="get_widget_info" access="remote" returntype="string" returnFormat="json" >
        <cfset arguments = deserializeJSON(getHttpRequestData().content)> 
        <cftry>
            <cfquery name="get_widget_info" datasource="#dsn#">
                SELECT
                    CW.WIDGETID,
                    CW.WIDGET_TITLE,
                    CW.WIDGET_DESCRIPTION,
                    CW.WIDGET_AUTHOR,
                    CW.WIDGET_VERSION
                FROM
                   WRK_WIDGET CW 
                WHERE
                    CW.WIDGETID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
                <cfif arguments.id eq -2>
                    union all 
                    SELECT
                        -2 WIDGETID,
                        'Designg Block' WIDGET_TITLE,
                        'Html Nesneleri Oluştrumanızı Sağlar' WIDGET_DESCRIPTION,
                        'Yazılımsa | Protein Team' WIDGET_AUTHOR,
                        '1.0' WIDGET_VERSION
                </cfif>
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.id#>
            <cfset result.data = this.returnData(replace(serializeJSON(get_widget_info),"//",""))>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="get_menu" access="remote" returntype="string" returnFormat="json">
        <cftry>
            <cfquery name="get_menu" datasource="#dsn#">        	
                SELECT
                    MENU_ID AS ID,
                    SITE,
                    MENU_NAME,
                    MENU_STATUS,
                    IS_DEFAULT,
                    MENU_DATA,
                    MENU_LANGUAGE
                FROM
                    PROTEIN_MENUS
                WHERE
                    MENU_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">  
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.id#>
            <cfset result.data = this.returnData(replace(serializeJSON(get_menu),"//",""))>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>
    
    <cffunction name="get_xml_settings" access="remote" returntype="string" returnFormat="json">
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>    
        <cftry>                   
            <cffile action="read" file="#application.systemParam.INDEX_FOLDER#objects2/xml/#arguments.XML#" variable="xmlString"> 
            <cfscript>
                function xmlToStruct(xml x) {
                    var s = {};

                    if(xmlGetNodeType(x) == "DOCUMENT_NODE") {
                        s[structKeyList(x)] = xmlToStruct(x[structKeyList(x)]);    
                    }

                    if(structKeyExists(x, "xmlAttributes") && !structIsEmpty(x.xmlAttributes)) { 
                        s.attributes = {};
                        for(var item in x.xmlAttributes) {
                            s.attributes[item] = x.xmlAttributes[item];        
                        }
                    }
                    
                    if(structKeyExists(x, "xmlText") && len(trim(x.xmlText))) {
                    s.value = x.xmlText;
                    }

                    if(structKeyExists(x, "xmlChildren") && arrayLen(x.xmlChildren)) {
                        for(var i=1; i<=arrayLen(x.xmlChildren); i++) {
                            if(structKeyExists(s, x.xmlchildren[i].xmlname)) { 
                                if(!isArray(s[x.xmlChildren[i].xmlname])) {
                                    var temp = s[x.xmlchildren[i].xmlname];
                                    s[x.xmlchildren[i].xmlname] = [temp];
                                }
                                arrayAppend(s[x.xmlchildren[i].xmlname], xmlToStruct(x.xmlChildren[i]));                
                            } else {
                                //before we parse it, see if simple
                                if(structKeyExists(x.xmlChildren[i], "xmlChildren") && arrayLen(x.xmlChildren[i].xmlChildren)) {
                                    s[x.xmlChildren[i].xmlName] = xmlToStruct(x.xmlChildren[i]);
                                } else if(structKeyExists(x.xmlChildren[i],"xmlAttributes") && !structIsEmpty(x.xmlChildren[i].xmlAttributes)) {
                                    s[x.xmlChildren[i].xmlName] = xmlToStruct(x.xmlChildren[i]);
                                } else {
                                    s[x.xmlChildren[i].xmlName] = x.xmlChildren[i].xmlText;
                                }
                            }
                        }
                    }
                    
                    return s;
                }

            </cfscript>   
            <cfset xmlData = xmlParse(xmlString)>   
            <cfset jsonData = xmlToStruct(xmlData)>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.XML#>
            <cfset result.data = replace(serializeJSON(jsonData.OBJECT_PROPERTIES),"//","")>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="get_wo" access="remote" returntype="string" returnFormat="json">
        <cftry>
            <cfquery name="get_wo" datasource="#dsn#">
                SELECT
                    WRK_OBJECTS_ID,
                    FRIENDLY_URL,
                    HEAD,
                    EVENT_TYPE,
                    ISNULL(EVENT_DEFAULT,'list') EVENT_DEFAULT,
                    IS_PUBLIC,
                    IS_CONSUMER,
                    IS_COMPANY,
                    IS_EMPLOYEE,
                    IS_EMPLOYEE_APP,
                    IS_LIVESTOCK,
                    IS_MACHINES,
                    EVENT_LIST,
                    EVENT_ADD,
                    EVENT_UPD,
                    EVENT_DETAIL,
                    EVENT_DASHBOARD
                FROM
                   WRK_OBJECTS
                WHERE
                    FULL_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.wo#">
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.wo#>
            <cfset result.data = this.returnData(replace(serializeJSON(get_wo),"//",""))>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="get_widget_desing_blocks" access="remote" returntype="string" returnFormat="json">
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>
        <cftry>
            <cfquery name="get_widget_desing_blocks_query" datasource="#dsn#">        	
                SELECT
                    DESIGN_BLOCK_ID ID,BLOCK_CONTENT_TITLE,BLOCK_CONTENT,AUTHOR,THUMBNAIL,PROTEIN_WIDGET_ID
                FROM
                    PROTEIN_DESIGN_BLOCKS
                WHERE
                   PROTEIN_WIDGET_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#(len(arguments.widget_id))?arguments.widget_id:-1#">
            </cfquery>
            <cfif get_widget_desing_blocks_query.recordcount><!---- Widget IDne kayıtlı design var ise designi widgettan getirir yoksa taslaklar gelir--->
                <cfquery name="get_desing_blocks_query" datasource="#dsn#">        	
                    SELECT
                        DESIGN_BLOCK_ID ID,BLOCK_CONTENT_TITLE,AUTHOR,THUMBNAIL,PROTEIN_WIDGET_ID AS WIDGET_ID
                    FROM
                        PROTEIN_DESIGN_BLOCKS
                    WHERE
                        PROTEIN_WIDGET_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.widget_id#">                        
                </cfquery>
                <cfset result.type = 'update'>
            <cfelse>
                <cfquery name="get_desing_blocks_query" datasource="#dsn#">        	
                    SELECT
                        DESIGN_BLOCK_ID ID,BLOCK_CONTENT_TITLE,AUTHOR,THUMBNAIL,PROTEIN_WIDGET_ID AS WIDGET_ID
                    FROM
                        PROTEIN_DESIGN_BLOCKS
                    WHERE
                    PROTEIN_WIDGET_ID IS NULL
                </cfquery>
                <cfset result.type = 'draft'>
            </cfif>
            <cfset result.status = true>
            <cfset result.identitycol = (isDefined("arguments.id") and len(arguments.id))?arguments.id:0>
            <cfset result.data = this.returnData(replace(serializeJSON(get_desing_blocks_query),"//",""))>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="get_desing_blocks" access="remote" returntype="string" returnFormat="json">
        <cftry>
            <cfquery name="get_widget_desing_blocks_query" datasource="#dsn#">        	
                SELECT
                    DESIGN_BLOCK_ID ID,BLOCK_CONTENT_TITLE,BLOCK_CONTENT,AUTHOR,THUMBNAIL,PROTEIN_WIDGET_ID
                FROM
                    PROTEIN_DESIGN_BLOCKS
                WHERE
                   PROTEIN_WIDGET_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#(len(arguments.widget_id))?arguments.widget_id:-1#">
            </cfquery>
            <cfif get_widget_desing_blocks_query.recordcount><!---- Widget ID var ise designi widgettan getirir yoksa taslak gelir--->
                <cfquery name="get_desing_blocks" datasource="#dsn#">        	
                    SELECT
                        DESIGN_BLOCK_ID ID,BLOCK_CONTENT_TITLE,BLOCK_CONTENT,AUTHOR,THUMBNAIL,PROTEIN_WIDGET_ID AS WIDGET_ID
                    FROM
                        PROTEIN_DESIGN_BLOCKS
                    WHERE
                        1=1
                        <cfif isDefined("arguments.widget_id") and len(arguments.widget_id)>
                            AND PROTEIN_WIDGET_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.widget_id#">
                        </cfif>
                </cfquery>
            <cfelse>
                <cfquery name="get_desing_blocks" datasource="#dsn#">        	
                    SELECT
                        DESIGN_BLOCK_ID ID,BLOCK_CONTENT_TITLE,BLOCK_CONTENT,AUTHOR,THUMBNAIL,PROTEIN_WIDGET_ID AS WIDGET_ID
                    FROM
                        PROTEIN_DESIGN_BLOCKS
                    WHERE
                        1=1
                        <cfif isDefined("arguments.id") and len(arguments.id)>
                            AND DESIGN_BLOCK_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
                        </cfif>
                </cfquery>
            </cfif>
            <cfset result.status = true>
            <cfset result.identitycol = (isDefined("arguments.id") and len(arguments.id))?arguments.id:0>
            <cfset result.data = this.returnData(replace(serializeJSON(get_desing_blocks),"//",""))>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="general_definitions_add" access="remote" returntype="string" returnFormat="json"> 
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>
        <cftry>
        	<cfquery name="insert_site_step_one" datasource="#dsn#" result="query_result">	
                INSERT INTO
                    PROTEIN_SITES  (DOMAIN,STATUS,MAINTENANCE_MODE,PRIMARY_DATA,RECORD_DATE,RECORD_EMP,RECORD_IP)
                VALUES
                	(
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DOMAIN#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.STATUS#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.MAINTENANCE_MODE#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(SerializeJSON(arguments.PRIMARY_DATA[1]),'//','')#">,
                        <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,	
                        <cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar">
                    )
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #query_result.identitycol#>
            <cfif len(result.identitycol)>
                <cfset SITE_PATH ="#application.systemParam.DOWNLOAD_FOLDER#AddOns\yazilimsa\Protein\reactor">
                <cfset cmd = "C:\Windows\system32\cmd.exe">
                <cfset iis_app = "/c C:\Windows\System32\inetsrv\appcmd.exe">
                <cfset param = "add site /name:""#arguments.DOMAIN#"" /bindings:http://#arguments.DOMAIN#:80 /physicalpath:""#SITE_PATH#"" ">
                <cfexecute name="#cmd#" arguments="#iis_app# #param#" variable="console_result" timeout="60"></cfexecute>
            </cfif>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
	</cffunction>

    <cffunction name="general_definitions_upd" access="remote" returntype="string" returnFormat="json"> 
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>       
        <cftry>
        	<cfquery name="general_definitions_upd" datasource="#dsn#" result="query_result">	
                UPDATE
                    PROTEIN_SITES
                SET
                    DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DOMAIN#">,
                    STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.STATUS#">,
                    MAINTENANCE_MODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.MAINTENANCE_MODE#">,
                    PRIMARY_DATA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(SerializeJSON(arguments.PRIMARY_DATA[1]),'//','')#">,
                    UPDATE_DATE = <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,	
                    UPDATE_EMP = <cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">,
                    UPDATE_IP = <cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar">
                WHERE
                    SITE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">    
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.id#>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
	</cffunction>

    <cffunction name="lang_and_money_upd" access="remote" returntype="string" returnFormat="json"> 
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>       
        <cftry>
        	<cfquery name="update_site_step_two" datasource="#dsn#" result="query_result">	
                UPDATE
                    PROTEIN_SITES
                SET
                    COMPANY = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.COMPANY#">,
                    ZONE_DATA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(SerializeJSON(arguments.ZONE_DATA[1]),'//','')#">,
                    UPDATE_DATE = <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,	
                    UPDATE_EMP = <cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">,
                    UPDATE_IP = <cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar">
                WHERE
                    SITE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">    
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.id#>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
	</cffunction>

    <cffunction name="access_upd" access="remote" returntype="string" returnFormat="json"> 
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>       
        <cftry>
        	<cfquery name="update_site_step_three" datasource="#dsn#" result="query_result">	
                UPDATE
                    PROTEIN_SITES
                SET
                    ACCESS_DATA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(SerializeJSON(arguments.ACCESS_DATA[1]),'//','')#">,
                    UPDATE_DATE = <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,	
                    UPDATE_EMP = <cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">,
                    UPDATE_IP = <cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar">
                WHERE
                    SITE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">    
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.id#>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
	</cffunction>

    <cffunction name="theme_upd" access="remote" returntype="string" returnFormat="json"> 
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>       
        <cftry>
        	<cfquery name="update_site_step_four" datasource="#dsn#" result="query_result">	
                UPDATE
                    PROTEIN_SITES
                SET
                    THEME_DATA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(SerializeJSON(arguments.THEME_DATA[1]),'//','')#">,
                    UPDATE_DATE = <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,	
                    UPDATE_EMP = <cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">,
                    UPDATE_IP = <cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar">
                WHERE
                    SITE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">    
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.id#>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
	</cffunction>

    <cffunction name="security_upd" access="remote" returntype="string" returnFormat="json"> 
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>       
        <cftry>
        	<cfquery name="update_site_step_five" datasource="#dsn#" result="query_result">	
                UPDATE
                    PROTEIN_SITES
                SET
                SECURITY_DATA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(SerializeJSON(arguments.SECURITY_DATA[1]),'//','')#">,
                    UPDATE_DATE = <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,	
                    UPDATE_EMP = <cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">,
                    UPDATE_IP = <cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar">
                WHERE
                    SITE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">    
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.id#>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
	</cffunction>

    <cffunction name="privacy_upd" access="remote" returntype="string" returnFormat="json"> 
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>       
        <cftry>
        	<cfquery name="update_site_step_five" datasource="#dsn#" result="query_result">	
                UPDATE
                    PROTEIN_SITES
                SET
                    PRIVACY_DATA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(SerializeJSON(arguments.PRIVACY_DATA[1]),'//','')#">,
                    UPDATE_DATE = <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,	
                    UPDATE_EMP = <cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">,
                    UPDATE_IP = <cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar">
                WHERE
                    SITE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">    
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.id#>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
	</cffunction>

    <cffunction name="mail_settins_upd" access="remote" returntype="string" returnFormat="json"> 
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>       
        <cftry>
        	<cfquery name="update_site_step_six" datasource="#dsn#" result="query_result">	
                UPDATE
                    PROTEIN_SITES
                SET
                    MAIL_SETTINGS_DATA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(SerializeJSON(arguments.MAIL_SETTINGS_DATA[1]),'//','')#">,
                    UPDATE_DATE = <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,	
                    UPDATE_EMP = <cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">,
                    UPDATE_IP = <cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar">
                WHERE
                    SITE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">    
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.id#>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
	</cffunction>

    <cffunction name="add_template" access="remote" returntype="string" returnFormat="json"> 
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>
        <cftry>
        	<cfquery name="insert_template" datasource="#dsn#" result="query_result">	
                INSERT INTO
                    PROTEIN_TEMPLATES  (SITE,STATUS,TYPE,TITLE,DESIGN_DATA,RECORD_DATE,RECORD_EMP,RECORD_IP)
                VALUES
                	(
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SITE#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.STATUS#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TYPE#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.TITLE#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(SerializeJSON(arguments.DESIGN_DATA[1]),'//','')#">,
                        <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,	
                        <cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar">
                    )
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #query_result.identitycol#>          
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>       
	</cffunction>

    <cffunction name="upd_template" access="remote" returntype="string" returnFormat="json"> 
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>       
        <cftry>
        	<cfquery name="upd_template" datasource="#dsn#" result="query_result">	
                UPDATE
                    PROTEIN_TEMPLATES
                SET
                    SITE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SITE#">,
                    STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.STATUS#">,
                    TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TYPE#">,
                    TITLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.TITLE#">,
                    DESIGN_DATA =<cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(SerializeJSON(arguments.DESIGN_DATA[1]),'//','')#">,
                    UPDATE_DATE = <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,	
                    UPDATE_EMP = <cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">,
                    UPDATE_IP = <cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar">
                WHERE
                    TEMPLATE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">    
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.id#>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
	</cffunction>

    <cffunction name="add_page" access="remote" returntype="string" returnFormat="json"> 
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>
        <cftry>
            <cfset friendly_url_control = deserializeJSON(FN_FRIENDLY_CONTROL(FRIENDLY_URL:arguments.FRIENDLY_URL,SITE:arguments.SITE,PAGE:0))>
            <cfif friendly_url_control.code eq 100>
                <cfset result.status = true>
                <cfset result.action = 'friendly_url_control'>
                <cfset result.error = "Frienly Url Kullanımda" >
            <cfelse> 
                <cfquery name="insert_page" datasource="#dsn#" result="query_result">	
                    INSERT INTO
                        PROTEIN_PAGES  (TITLE,FRIENDLY_URL,SITE,TEMPLATE_BODY,TEMPLATE_INSIDE,STATUS,PAGE_DATA,RECORD_DATE,RECORD_EMP,RECORD_IP)
                    VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.TITLE#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FRIENDLY_URL#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SITE#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TEMPLATE_BODY#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TEMPLATE_INSIDE#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.STATUS#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(SerializeJSON(arguments.PAGE_DATA[1]),'//','')#">,
                            <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,	
                            <cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">,
                            <cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar">
                        )
                </cfquery>
                <cfset friendly_url_control = deserializeJSON(FN_FRIENDLY_CONTROL(FRIENDLY_URL:arguments.FRIENDLY_URL,SITE:arguments.SITE,PAGE:query_result.identitycol,EVENT:arguments.PAGE_DATA[1].EVENT))>
                <cfset result.status = true>
                <cfset result.action = 'add_page'>
                <cfset result.identitycol = #query_result.identitycol#>
            </cfif>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>       
	</cffunction>

    <cffunction name="upd_page" access="remote" returntype="string" returnFormat="json"> 
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>
        <cftry>
            <cfset friendly_url_control = deserializeJSON(FN_FRIENDLY_CONTROL(FRIENDLY_URL:arguments.FRIENDLY_URL,SITE:arguments.SITE,PAGE:arguments.id,EVENT:arguments.PAGE_DATA[1].EVENT))>
            <cfif friendly_url_control.code eq 100>
                <cfset result.status = true>
                <cfset result.action = 'friendly_url_control'>
                <cfset result.error = "Frienly Url Kullanımda" >
            <cfelse>            
                <cfquery name="upd_page" datasource="#dsn#" result="query_result">	
                    UPDATE
                        PROTEIN_PAGES
                    SET
                        TITLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.TITLE#">,
                        FRIENDLY_URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FRIENDLY_URL#">,
                        SITE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SITE#">,
                        TEMPLATE_BODY =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TEMPLATE_BODY#">,
                        TEMPLATE_INSIDE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TEMPLATE_INSIDE#">,
                        STATUS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.STATUS#">,
                        PAGE_DATA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(SerializeJSON(arguments.PAGE_DATA[1]),'//','')#">,
                        UPDATE_DATE = <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,	
                        UPDATE_EMP = <cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">,
                        UPDATE_IP = <cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar">
                    WHERE
                        PAGE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">    
                </cfquery>
                <cfset result.status = true>
                <cfset result.action = 'upd_page'>
                <cfset result.related_action = friendly_url_control>
                <cfset result.identitycol = #arguments.id#>
                
            </cfif>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="add_design_blocks" access="remote" returntype="string" returnFormat="json"> 
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>
        <cftry>
        	<cfquery name="insert_design_blocks" datasource="#dsn#" result="query_result">	
                INSERT INTO
                    PROTEIN_DESIGN_BLOCKS  (BLOCK_CONTENT_TITLE,BLOCK_CONTENT,AUTHOR,RECORD_DATE,RECORD_EMP,RECORD_IP)
                VALUES
                	(
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.BLOCK_CONTENT_TITLE#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(SerializeJSON(arguments.BLOCK_CONTENT),'//','')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.AUTHOR#">,
                        <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,	
                        <cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar">
                    )
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #query_result.identitycol#>          
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>       
	</cffunction>

    <cffunction name="upd_design_blocks" access="remote" returntype="string" returnFormat="json"> 
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>
        <cftry>
            <cfif len(arguments.widget_id)><!---- Widget ID var ise designi kopyasını ekler / günceller ---->
                <cfquery name="get_widget_desing_blocks" datasource="#dsn#">        	
                    SELECT
                        DESIGN_BLOCK_ID ID,BLOCK_CONTENT_TITLE,BLOCK_CONTENT,AUTHOR,THUMBNAIL,PROTEIN_WIDGET_ID
                    FROM
                        PROTEIN_DESIGN_BLOCKS
                    WHERE
                       PROTEIN_WIDGET_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#(len(arguments.widget_id))?arguments.widget_id:-1#">
                </cfquery>
                <cfif get_widget_desing_blocks.recordcount>
                    <cfquery name="upd_design_blocks" datasource="#dsn#" result="query_result">	
                        UPDATE
                            PROTEIN_DESIGN_BLOCKS
                        SET
                            BLOCK_CONTENT_TITLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.BLOCK_CONTENT_TITLE#">,
                            BLOCK_CONTENT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(SerializeJSON(arguments.BLOCK_CONTENT),'//','')#">,
                            AUTHOR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.AUTHOR#">,  
                            THUMBNAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.THUMBNAIL#">,                       
                            UPDATE_DATE = <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,	
                            UPDATE_EMP = <cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">,
                            UPDATE_IP = <cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar">
                        WHERE
                            PROTEIN_WIDGET_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.widget_id#">  
                    </cfquery>
                    <cfset result.identitycol = 0>
                <cfelse>
                    <cfquery name="insert_design_blocks" datasource="#dsn#" result="query_result">	
                        INSERT INTO
                            PROTEIN_DESIGN_BLOCKS  (BLOCK_CONTENT_TITLE,BLOCK_CONTENT,AUTHOR,PROTEIN_WIDGET_ID,THUMBNAIL,RECORD_DATE,RECORD_EMP,RECORD_IP)
                        VALUES
                            (
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.BLOCK_CONTENT_TITLE#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(SerializeJSON(arguments.BLOCK_CONTENT),'//','')#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.AUTHOR#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.widget_id#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.THUMBNAIL#">,
                                <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,	
                                <cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">,
                                <cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar">
                            )
                    </cfquery>    
                    <cfset result.identitycol = query_result.identitycol>
                </cfif>
                
            <cfelse>
                <cfquery name="upd_design_blocks" datasource="#dsn#" result="query_result">	
                    UPDATE
                        PROTEIN_DESIGN_BLOCKS
                    SET
                        BLOCK_CONTENT_TITLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.BLOCK_CONTENT_TITLE#">,
                        BLOCK_CONTENT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(SerializeJSON(arguments.BLOCK_CONTENT),'//','')#">,
                        AUTHOR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.AUTHOR#">,  
                        THUMBNAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.THUMBNAIL#">,                       
                        UPDATE_DATE = <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,	
                        UPDATE_EMP = <cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">,
                        UPDATE_IP = <cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar">
                    WHERE
                        DESIGN_BLOCK_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">    
                </cfquery>
                <cfset result.identitycol = arguments.id>
            </cfif> 
            <cfset result.status = true>
            
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
	</cffunction>

    <cffunction name="del_design_blocks" access="remote" returntype="string" returnFormat="json">
        <cftry>
            <cfif len(arguments.widget_id)>
                <cfquery name="del_design_blocks" datasource="#dsn#"> 
                    DELETE FROM PROTEIN_DESIGN_BLOCKS WHERE PROTEIN_WIDGET_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#(len(arguments.widget_id))?arguments.widget_id:-1#">
                </cfquery>
            <cfelse>
                <cfquery name="del_design_blocks" datasource="#dsn#"> 
                    DELETE FROM PROTEIN_DESIGN_BLOCKS WHERE DESIGN_BLOCK_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
                </cfquery>
            </cfif>
            <cfset result.status = true>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="update_design_block_thumbnail_file" access="remote" returntype="string" returnFormat="json">         
        <cfset thumbnail_file_folder = #replace(application.systemParam.INDEX_FOLDER,"v16","documents\")#>
        <cfset thumbnail_file_folder = #replace(thumbnail_file_folder,"V16","documents\")#>
        <cftry>  
            <!--- Klasor Konrolu BEGIN --->       
                <cfdirectory action="list" directory="#thumbnail_file_folder#" recurse="false" name="folders">
                <cfquery dbtype="query" name="find_folder">
                    SELECT Name FROM folders WHERE TYPE='Dir' AND NAME = 'design_blocks_thumbnail'
                </cfquery>                
                <cfif find_folder.RecordCount neq 1>
                    <cfdirectory action="create" directory="#thumbnail_file_folder#/design_blocks_thumbnail" name="create_folder">
                </cfif>
            <!--- Klasor Konrolu END --->  
            <cffile action="upload" filefield="form.FILE" destination="#thumbnail_file_folder#/design_blocks_thumbnail" nameconflict="Overwrite" result = "upload_result">   
            <cffile action="rename" source="#upload_result.SERVERDIRECTORY#\#upload_result.SERVERFILE#" destination="#upload_result.SERVERDIRECTORY#\#arguments.id#_#arguments.type#.#upload_result.CLIENTFILEEXT#" attributes="normal">	
            
            <cfset result.status = true>
            <cfset result.file = "#arguments.id#_#arguments.type#.#upload_result.CLIENTFILEEXT#">
            <cfset result.identitycol = #arguments.id#>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="delete_design_block_thumbnail_file" access="remote" returntype="string" returnFormat="json">       
        <cfset thumbnail_file_folder = #replace(application.systemParam.INDEX_FOLDER,"v16","documents\design_blocks_thumbnail")#>
        <cfset thumbnail_file_folder = #replace(thumbnail_file_folder,"V16","documents\design_blocks_thumbnail")#>
        <cftry>  
            <cffile action = "delete" file = "#thumbnail_file_folder#\#arguments.delete_file#">      
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.id#>
            <cfcatch type="any">
                <cfset result.status = true>
                <cfset result.error = cfcatch.message >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    
    <cffunction name="upd_megamenu" access="remote" returntype="string" returnFormat="json"> 
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>
        <cftry>
            <cfquery name="get_megamenu" datasource="#dsn#">	
                SELECT
                    ID
                FROM
                    PROTEIN_MEGA_MENUS
                WHERE
                    MEGAMENU_ID =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#">                    
            </cfquery>
            <cfif get_megamenu.recordcount>
                <cfquery name="upd_megamenu" datasource="#dsn#" result="query_result">	
                    UPDATE
                        PROTEIN_MEGA_MENUS
                    SET
                        TITLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.TITLE#">,
                        SITE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SITE#">,
                        STATUS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.STATUS#">,
                        MEGAMENU_DATA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(SerializeJSON(arguments.MEGAMENU_DATA[1]),'//','')#">,
                        UPDATE_DATE = <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,	
                        UPDATE_EMP = <cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">,
                        UPDATE_IP = <cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar">
                    WHERE
                        MEGAMENU_ID =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MEGAMENU_ID#">
                        AND MENU_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.MENU#">                    
                </cfquery>
            <cfelse>
                <cfquery name="insert_megamenu" datasource="#dsn#" result="query_int">	
                    INSERT INTO
                        PROTEIN_MEGA_MENUS  (TITLE,SITE,MENU_ID,MEGAMENU_ID,STATUS,MEGAMENU_DATA,RECORD_DATE,RECORD_EMP,RECORD_IP)
                    VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.TITLE#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SITE#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.MENU#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.STATUS#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(SerializeJSON(arguments.MEGAMENU_DATA[1]),'//','')#">,
                            <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,	
                            <cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">,
                            <cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar">
                        )
                </cfquery>
            </cfif>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.id#>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
	</cffunction>

    <cffunction name="add_widget" access="remote" returntype="string" returnFormat="json"> 
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>
        <cftry>
        	<cfquery name="insert_widget" datasource="#dsn#" result="query_result">	
                INSERT INTO
                    PROTEIN_WIDGETS  (SITE,TITLE,WIDGET_NAME,STATUS,WIDGET_DATA,RECORD_DATE,RECORD_EMP,RECORD_IP)
                VALUES
                	(
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SITE#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.TITLE#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.WIDGET_NAME#">,                        
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.STATUS#">,
                        <cfif isDefined("arguments.WIDGET_DATA") and len(arguments.WIDGET_DATA)>
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(SerializeJSON(arguments.WIDGET_DATA),'//','')#">,
                        <cfelse>
                            null,
                        </cfif>
                        <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,	
                        <cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar">
                    )
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #query_result.identitycol#>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>       
	</cffunction>

    <cffunction name="upd_widget" access="remote" returntype="string" returnFormat="json"> 
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>
        <cftry>
        	<cfquery name="upd_widget" datasource="#dsn#" result="query_result">	
                UPDATE
                    PROTEIN_WIDGETS
                SET
                    SITE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SITE#">,
                    TITLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.TITLE#">,
                    WIDGET_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.WIDGET_NAME#">,                        
                    STATUS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.STATUS#">,
                    <cfif arguments.WIDGET_NAME neq "-2">                   
                        WIDGET_DATA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(SerializeJSON(arguments.WIDGET_DATA),'//','')#">,
                    </cfif>
                    WIDGET_EXTEND = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(SerializeJSON(arguments.WIDGET_EXTEND),'//','')#">,
                    WIDGET_BOX_DATA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(SerializeJSON(arguments.WIDGET_BOX_DATA),'//','')#">,
                    WIDGET_SEO_DATA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(SerializeJSON(arguments.WIDGET_SEO_DATA),'//','')#">,
                    UPDATE_DATE = <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,	
                    UPDATE_EMP = <cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">,
                    UPDATE_IP = <cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar">
                WHERE
                    WIDGET_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">    
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.id#>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
	</cffunction>

    <cffunction name="upd_widget_design_block" access="remote" returntype="string" returnFormat="json"> 
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>
        <cftry>
        	<cfquery name="upd_widget_design_block" datasource="#dsn#" result="query_result">	
                UPDATE
                    PROTEIN_WIDGETS
                SET                    
                    WIDGET_DATA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(SerializeJSON(arguments.WIDGET_DATA),'//','')#">,                   
                    UPDATE_DATE = <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,	
                    UPDATE_EMP = <cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">,
                    UPDATE_IP = <cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar">
                WHERE
                WIDGET_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">    
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.id#>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
	</cffunction>

    <cffunction name="del_widget" access="remote" returntype="string" returnFormat="json"> 
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>
        <cftry>
        	<cfquery name="del_widget" datasource="#dsn#" result="query_result">	
                DELETE
                FROM
                    PROTEIN_WIDGETS                
                WHERE
                    WIDGET_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.WIDGET_ID#">  
                    AND SITE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SITE#">
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.WIDGET_ID#>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
	</cffunction>

    <cffunction name="add_menu" access="remote" returntype="string" returnFormat="json"> 
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>
        <cftry>
        	<cfquery name="insert_menu" datasource="#dsn#" result="query_result">	
                INSERT INTO
                    PROTEIN_MENUS  (SITE,MENU_NAME,MENU_STATUS,IS_DEFAULT,MENU_DATA,MENU_LANGUAGE,RECORD_DATE,RECORD_EMP,RECORD_IP)
                VALUES
                	(
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SITE#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MENU_NAME#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.MENU_STATUS#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.IS_DEFAULT#">,
                        <cfif isDefined("arguments.MENU_DATA") and len(arguments.MENU_DATA)>
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MENU_DATA#">,
                        <cfelse>
                            null,
                        </cfif>
                        <cfif isDefined("arguments.MENU_LANGUAGE") and len(arguments.MENU_LANGUAGE)>
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MENU_LANGUAGE#">,
                        <cfelse>
                            null,
                        </cfif>
                        <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,	
                        <cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar">
                    )
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #query_result.identitycol#>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>       
	</cffunction>

    <cffunction name="upd_menu" access="remote" returntype="string" returnFormat="json"> 
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>
        <cftry>
        	<cfquery name="upd_menu" datasource="#dsn#" result="query_result">	
                UPDATE
                    PROTEIN_MENUS
                SET
                    SITE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SITE#">,
                    MENU_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MENU_NAME#">,
                    MENU_STATUS  = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.MENU_STATUS#">,
                    IS_DEFAULT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.IS_DEFAULT#">,
                    MENU_DATA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MENU_DATA#">,
                    MENU_LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MENU_LANGUAGE#">,
                    UPDATE_DATE = <cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,	
                    UPDATE_EMP = <cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">,
                    UPDATE_IP = <cfqueryparam value="#cgi.remote_addr#" cfsqltype="cf_sql_varchar">
                WHERE
                    MENU_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">    
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.id#>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="update_extend_file" access="remote" returntype="string" returnFormat="json">       
        <cfset protein_folder = #replace(application.systemParam.INDEX_FOLDER,"v16","AddOns\Yazilimsa\Protein")#>
        <cfset extend_file_folder = "#protein_folder#extend_files">
        <cfset extend_file_widget_folder = "#extend_file_folder#\widget">
        <cftry>  
            <!--- Klasor Konrolu BEGIN --->       
                <cfdirectory action="list" directory="#protein_folder#" recurse="false" name="folders">
                <cfquery dbtype="query" name="find_folder">
                    SELECT Name FROM folders WHERE TYPE='Dir' AND NAME = 'extend_files'
                </cfquery>                
                <cfif find_folder.RecordCount neq 1>
                    <cfdirectory action="create" directory="#protein_folder#/extend_files" name="create_folder">
                </cfif>                
                <cfdirectory action="list" directory="#extend_file_folder#" recurse="false" name="folders">
                <cfquery dbtype="query" name="find_folder">
                    SELECT Name FROM folders WHERE TYPE='Dir' AND NAME = 'widget'
                </cfquery>
                <cfif find_folder.RecordCount neq 1>
                    <cfdirectory action="create" directory="#extend_file_folder#/widget" name="create_folder">
                </cfif>
            <!--- Klasor Konrolu END --->  
            <cffile action="upload" filefield="form.EXTEND_FILE" destination="#extend_file_widget_folder#" nameconflict="Overwrite" result = "upload_result">                 
            <cffile action="rename" source="#upload_result.SERVERDIRECTORY#\#upload_result.SERVERFILE#" destination="#upload_result.SERVERDIRECTORY#\#arguments.widget#_#arguments.type#.cfm" attributes="normal">	
            <cfset result.status = true>
            <cfset result.file = "#arguments.widget#_#arguments.type#.cfm">
            <cfset result.identitycol = #arguments.widget#>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="delete_extend_file" access="remote" returntype="string" returnFormat="json">       
        <cfset protein_folder = #replace(application.systemParam.INDEX_FOLDER,"v16","AddOns\Yazilimsa\Protein")#>
        <cfset extend_file_folder = "#protein_folder#extend_files">
        <cfset extend_file_widget_folder = "#extend_file_folder#\widget">
        <cftry>  
            <cffile action = "delete" file = "#extend_file_widget_folder#\#arguments.widget#_#arguments.type#.cfm">      
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.widget#>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="update_site_manifest_file" access="remote" returntype="string" returnFormat="json">       
        <cfset protein_folder = #replace(application.systemParam.INDEX_FOLDER,"v16","AddOns\Yazilimsa\Protein\reactor\src\")#>
        <cfset protein_folder = #replace(protein_folder,"V16","AddOns\Yazilimsa\Protein\reactor\src")#>
        <cfset extend_file_folder = "#protein_folder#includes">
        <cfset extend_file_manifest_folder = "#extend_file_folder#\manifest">
        <cftry>  
            <!--- Klasor Konrolu BEGIN --->       
                <cfdirectory action="list" directory="#protein_folder#" recurse="false" name="folders">
                <cfquery dbtype="query" name="find_folder">
                    SELECT Name FROM folders WHERE TYPE='Dir' AND NAME = 'extend_files'
                </cfquery>                
                <cfif find_folder.RecordCount neq 1>
                    <cfdirectory action="create" directory="#protein_folder#/extend_files" name="create_folder">
                </cfif>                
                <cfdirectory action="list" directory="#extend_file_folder#" recurse="false" name="folders">
                <cfquery dbtype="query" name="find_folder">
                    SELECT Name FROM folders WHERE TYPE='Dir' AND NAME = 'manifest'
                </cfquery>
                <cfif find_folder.RecordCount neq 1>
                    <cfdirectory action="create" directory="#extend_file_folder#/manifest" name="create_folder">
                </cfif>
            <!--- Klasor Konrolu END --->  
            <cffile action="upload" filefield="form.FILE" destination="#extend_file_manifest_folder#" nameconflict="Overwrite" result = "upload_result">   
            <cffile action="rename" source="#upload_result.SERVERDIRECTORY#\#upload_result.SERVERFILE#" destination="#upload_result.SERVERDIRECTORY#\#arguments.site#_#arguments.type#.#upload_result.CLIENTFILEEXT#" attributes="normal">	
            
            <cfif arguments.type eq "favicon">
                <cfset image192 = imageNew("#upload_result.SERVERDIRECTORY#\#arguments.site#_#arguments.type#.#upload_result.CLIENTFILEEXT#")> 
                <cfset imageResize(image192,"192","192")> 
                <cfimage source="#image192#" action="write" destination="#upload_result.SERVERDIRECTORY#\#arguments.site#_#arguments.type#_192x192.#upload_result.CLIENTFILEEXT#" overwrite="yes"> 
                
                <cfset image144 = imageNew("#upload_result.SERVERDIRECTORY#\#arguments.site#_#arguments.type#.#upload_result.CLIENTFILEEXT#")> 
                <cfset imageResize(image144,"144","144")> 
                <cfimage source="#image144#" action="write" destination="#upload_result.SERVERDIRECTORY#\#arguments.site#_#arguments.type#_144x144.#upload_result.CLIENTFILEEXT#" overwrite="yes"> 
                
                <cfset image96 = imageNew("#upload_result.SERVERDIRECTORY#\#arguments.site#_#arguments.type#.#upload_result.CLIENTFILEEXT#")> 
                <cfset imageResize(image96,"96","96")> 
                <cfimage source="#image96#" action="write" destination="#upload_result.SERVERDIRECTORY#\#arguments.site#_#arguments.type#_96x96.#upload_result.CLIENTFILEEXT#" overwrite="yes"> 

                <cfset image72 = imageNew("#upload_result.SERVERDIRECTORY#\#arguments.site#_#arguments.type#.#upload_result.CLIENTFILEEXT#")> 
                <cfset imageResize(image72,"72","72")> 
                <cfimage source="#image72#" action="write" destination="#upload_result.SERVERDIRECTORY#\#arguments.site#_#arguments.type#_72x72.#upload_result.CLIENTFILEEXT#" overwrite="yes"> 

                <cfset image48 = imageNew("#upload_result.SERVERDIRECTORY#\#arguments.site#_#arguments.type#.#upload_result.CLIENTFILEEXT#")> 
                <cfset imageResize(image48,"48","48")> 
                <cfimage source="#image48#" action="write" destination="#upload_result.SERVERDIRECTORY#\#arguments.site#_#arguments.type#_48x48.#upload_result.CLIENTFILEEXT#" overwrite="yes"> 

                <cfset image36 = imageNew("#upload_result.SERVERDIRECTORY#\#arguments.site#_#arguments.type#.#upload_result.CLIENTFILEEXT#")> 
                <cfset imageResize(image36,"36","36")> 
                <cfimage source="#image36#" action="write" destination="#upload_result.SERVERDIRECTORY#\#arguments.site#_#arguments.type#_36x36.#upload_result.CLIENTFILEEXT#" overwrite="yes"> 
            </cfif>

            <cfset result.status = true>
            <cfset result.file = "#arguments.site#_#arguments.type#.#upload_result.CLIENTFILEEXT#">
            <cfset result.identitycol = #arguments.site#>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="delete_site_manifest_file" access="remote" returntype="string" returnFormat="json">       
        <cfset protein_folder = #replace(application.systemParam.INDEX_FOLDER,"v16","AddOns\Yazilimsa\Protein")#>
        <cfset extend_file_folder = "#protein_folder#extend_files">
        <cfset extend_file_manifest_folder = "#extend_file_folder#\manifest">
        <cftry>  
            <cffile action = "delete" file = "#extend_file_manifest_folder#\#arguments.delete_file#">      
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.site#>
            <cfcatch type="any">
                <cfset result.status = true>
                <cfset result.error = cfcatch.message >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="del_site" access="remote" returntype="string" returnFormat="json">
        <cftry>
            <cfquery name="del_site" datasource="#dsn#"> 
                DELETE FROM PROTEIN_SITES WHERE SITE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.site#">
                DELETE FROM PROTEIN_TEMPLATES WHERE SITE =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.site#">
                DELETE FROM PROTEIN_PAGES WHERE SITE =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.site#">
                DELETE FROM PROTEIN_WIDGETS WHERE SITE =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.site#">
                DELETE FROM PROTEIN_MENUS WHERE SITE =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.site#">
            </cfquery>
            <cfset result.status = true>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="del_template" access="remote" returntype="string" returnFormat="json">
        <cftry>
            <cfquery name="del_template" datasource="#dsn#"> 
                DELETE FROM PROTEIN_TEMPLATES WHERE TEMPLATE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.template#">
            </cfquery>
            <cfset result.status = true>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="del_page" access="remote" returntype="string" returnFormat="json">
        <cftry>
            <cfquery name="del_page" datasource="#dsn#"> 
                DELETE FROM PROTEIN_PAGES WHERE PAGE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.page#">
            </cfquery>
            <cfset result.status = true>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="del_menu" access="remote" returntype="string" returnFormat="json">
        <cftry>
            <cfquery name="del_menu" datasource="#dsn#"> 
                DELETE FROM PROTEIN_MENUS WHERE MENU_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.menu#">
            </cfquery>
            <cfset result.status = true>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction> 
    
    <cffunction name="add_denied" access="remote" returntype="string" returnFormat="json"> 
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>
        <cftry>
        	<cfquery name="insert_deniede" datasource="#dsn#" result="query_result">	
                INSERT INTO
                    COMPANY_PARTNER_DENIED  (
                        DENIED_PAGE_ID,
                        PARTNER_ID,
                        PARTNER_POSITION_ID,
                        COMPANY_CAT_ID,
                        MENU_ID,
                        DENIED_PAGE,
                        IS_VIEW,
                        IS_INSERT,
                        IS_DELETE,
                        CONSUMER_CAT_ID,
                        CONSUMER_ID                     
                        )
                VALUES                
                	(
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.page#">,
                        <cfif isDefined("arguments.denied_par_id") and len(arguments.denied_par_id)>
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.denied_par_id#">,
                        <cfelse>
                            null,
                        </cfif>
                        <cfif isDefined("arguments.PARTNER_POSITION_ID") and len(arguments.PARTNER_POSITION_ID)>
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PARTNER_POSITION_ID#">,
                        <cfelse>
                            null,
                        </cfif>
                        <cfif isDefined("arguments.COMPANY_CAT_ID") and len(arguments.COMPANY_CAT_ID)>
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.COMPANY_CAT_ID#">,
                        <cfelse>
                            null,
                        </cfif>
                        <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.url#">,
                        <cfif isDefined("arguments.is_view") and len(arguments.is_view)>
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_view#">,
                        <cfelse>
                            0,
                        </cfif>
                        <cfif isDefined("arguments.is_insert") and len(arguments.is_insert)>
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_insert#">,
                        <cfelse>
                            0,
                        </cfif>
                        <cfif isDefined("arguments.is_delete") and len(arguments.is_delete)>
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_delete#">,
                        <cfelse>
                            0,
                        </cfif>
                        <cfif isDefined("arguments.CONSUMER_CAT_ID") and len(arguments.CONSUMER_CAT_ID)>
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CONSUMER_CAT_ID#">,
                        <cfelse>
                            null,
                        </cfif>
                        <cfif isDefined("arguments.CONSUMER_ID") and len(arguments.CONSUMER_ID)>
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CONSUMER_ID#">
                        <cfelse>
                            null
                        </cfif>
                    )
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.page#>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message  >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>       
    </cffunction>

    <cffunction name="upd_denied" access="remote" returntype="string" returnFormat="json"> 
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>
        <cftry>
        	<cfquery name="upd_denied" datasource="#dsn#" result="query_result">	
                UPDATE
                    COMPANY_PARTNER_DENIED
                SET                    
                    <cfif isDefined("arguments.denied") and arguments.denied eq "view">
                    IS_VIEW = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.status#">
                    </cfif>
                    <cfif isDefined("arguments.denied") and arguments.denied eq "insert">
                    IS_INSERT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.status#">
                    </cfif>
                    <cfif isDefined("arguments.denied") and arguments.denied eq "delete">
                    IS_DELETE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.status#">
                    </cfif>
                WHERE
                    DENIED_PAGE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.page#">
                    AND PARTNER_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner#">   
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.page#>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="del_denied" access="remote" returntype="string" returnFormat="json">
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>
        <cftry>
            <cfquery name="del_denied" datasource="#dsn#"> 
                DELETE 
                    FROM COMPANY_PARTNER_DENIED 
                WHERE 
                    DENIED_PAGE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.page#">
                    AND PARTNER_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner#"> 
            </cfquery>
            <cfset result.status = true>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction> 
   
    <cffunction name="GET_SITE_RECORD_INFO" access="remote" returntype="query">
        <cfquery name="GET_SITE_RECORD_INFO" datasource="#dsn#">
            SELECT RECORD_DATE,RECORD_EMP,UPDATE_DATE,UPDATE_EMP FROM PROTEIN_SITES WHERE SITE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SITE#">
        </cfquery>
        <cfreturn GET_SITE_RECORD_INFO>
    </cffunction>

    <cffunction name="GET_TEMPLATE_RECORD_INFO" access="remote" returntype="query">
        <cfquery name="GET_TEMPLATE_RECORD_INFO" datasource="#dsn#">
            SELECT RECORD_DATE,RECORD_EMP,UPDATE_DATE,UPDATE_EMP FROM PROTEIN_TEMPLATES WHERE TEMPLATE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.template#">
        </cfquery>
        <cfreturn GET_TEMPLATE_RECORD_INFO>
    </cffunction>

    <cffunction name="GET_PAGE_RECORD_INFO" access="remote" returntype="query">
        <cfquery name="GET_PAGE_RECORD_INFO" datasource="#dsn#">
            SELECT RECORD_DATE,RECORD_EMP,UPDATE_DATE,UPDATE_EMP FROM PROTEIN_PAGES WHERE PAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.page#">
        </cfquery>
        <cfreturn GET_PAGE_RECORD_INFO>
    </cffunction>

    <cffunction name="GET_MENU_RECORD_INFO" access="remote" returntype="query">
        <cfquery name="GET_MENU_RECORD_INFO" datasource="#dsn#">
            SELECT RECORD_DATE,RECORD_EMP,UPDATE_DATE,UPDATE_EMP FROM PROTEIN_MENUS WHERE MENU_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.menu#">
        </cfquery>
        <cfreturn GET_MENU_RECORD_INFO>
    </cffunction>

    <cffunction name="GET_MEGAMENU_RECORD_INFO" access="remote" returntype="query">
        <cfquery name="GET_MEGAMENU_RECORD_INFO" datasource="#dsn#">
            SELECT RECORD_DATE,RECORD_EMP,UPDATE_DATE,UPDATE_EMP FROM PROTEIN_MEGA_MENUS WHERE MEGAMENU_ID =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.megamenu#">
        </cfquery>
        <cfreturn GET_MEGAMENU_RECORD_INFO>
    </cffunction>

    <cffunction name="GET_DESIGN_BLOCK_RECORD_INFO" access="remote" returntype="query">
        <cfquery name="GET_DESIGN_BLOCK_RECORD_INFO" datasource="#dsn#">
            SELECT RECORD_DATE,RECORD_EMP,UPDATE_DATE,UPDATE_EMP FROM PROTEIN_DESIGN_BLOCKS WHERE DESIGN_BLOCK_ID =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.design_block_id#">
        </cfquery>
        <cfreturn GET_DESIGN_BLOCK_RECORD_INFO>
    </cffunction>

    

    <cffunction name="FN_FRIENDLY_CONTROL" access="package"  returntype="string" returnFormat="json">
        <cfargument name="FRIENDLY_URL" type="string">
        <cfargument name="SITE" type="numeric" default="0">
        <cfargument name="PAGE" type="numeric" default="0">
        <cfargument name="EVENT" type="string" default="">
        <cftry>
            <cfquery name="GET_FRIENDLY_URL" datasource="#dsn#">
                SELECT 
                    USER_URL_ID,
                    USER_FRIENDLY_URL,
                    PROTEIN_SITE,
                    PROTEIN_PAGE,
                    PROTEIN_EVENT,
                    ACTION_TYPE
                FROM 
                    USER_FRIENDLY_URLS
                WHERE
                    USER_FRIENDLY_URL =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#FRIENDLY_URL#">
                    <cfif site neq 0>
                        AND PROTEIN_SITE = <cfqueryparam cfsqltype="cf_sql_integer" value="#SITE#">
                    </cfif>
            </cfquery>
            <cfquery name="GET_FRIENDLY_URL_UPD_CONTROL" datasource="#dsn#">
                SELECT 
                    USER_URL_ID
                FROM 
                    USER_FRIENDLY_URLS
                WHERE
                    ACTION_TYPE =  <cfqueryparam cfsqltype="cf_sql_varchar" value="PROTEIN_PAGE">
                    AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PAGE#">
            </cfquery>
            <cfif GET_FRIENDLY_URL.recordcount eq 0>
                <cfset result_fn.code = 200>
                <cfset result_fn.response_message = "available">
                <cfif PAGE NEQ 0>                    
                    <cfif GET_FRIENDLY_URL_UPD_CONTROL.recordcount eq 0>
                        <cfquery name="ADD_FRIENDLY_URL" datasource="#dsn#">
                            ALTER TABLE USER_FRIENDLY_URLS
                            ALTER COLUMN PROTEIN_EVENT nvarchar(50) NULL                            
                            INSERT INTO
                                USER_FRIENDLY_URLS  (
                                    USER_FRIENDLY_URL,
                                    PROTEIN_SITE,
                                    PROTEIN_PAGE,
                                    ACTION_TYPE,
                                    ACTION_ID
                                    <cfif len(EVENT)>
                                    ,PROTEIN_EVENT
                                    </cfif>                    
                                    )
                            VALUES                
                                (
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#FRIENDLY_URL#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#SITE#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#PAGE#">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="PROTEIN_PAGE">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#PAGE#">
                                    <cfif len(EVENT)>
                                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#EVENT#">
                                    </cfif>
                                )
                        </cfquery>
                    <cfelseif GET_FRIENDLY_URL_UPD_CONTROL.recordcount eq 1>
                        <cfquery name="ADD_FRIENDLY_URL" datasource="#dsn#" result="query_result">	
                            UPDATE
                                USER_FRIENDLY_URLS
                            SET                    
                                USER_FRIENDLY_URL  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FRIENDLY_URL#">
                                <cfif len(EVENT)>
                                    ,PROTEIN_EVENT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#EVENT#">
                                </cfif>
                            WHERE
                                USER_URL_ID =  #GET_FRIENDLY_URL_UPD_CONTROL.USER_URL_ID#                              
                        </cfquery>
                    </cfif>
                </cfif>                
            <cfelseif GET_FRIENDLY_URL.PROTEIN_SITE eq SITE AND GET_FRIENDLY_URL.PROTEIN_PAGE eq PAGE>
                <cfquery name="ADD_FRIENDLY_URL" datasource="#dsn#" result="query_result">	
                    UPDATE
                        USER_FRIENDLY_URLS
                    SET                    
                        USER_FRIENDLY_URL  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FRIENDLY_URL#">
                        <cfif len(EVENT)>
                            ,PROTEIN_EVENT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#EVENT#">
                        </cfif>
                    WHERE
                        USER_URL_ID =  #GET_FRIENDLY_URL_UPD_CONTROL.USER_URL_ID#                              
                </cfquery>
                <cfset result_fn.code = 201>
                <cfset result_fn.response_message = "available update">
            <cfelse>
                <cfset result_fn.code = 100>
                <cfset result_fn.response_message = "not available">  
            </cfif>
            <cfset result_fn.found = GET_FRIENDLY_URL.recordcount> 
            <cfset result_fn.SITE = SITE>
            <cfset result_fn.PAGE = PAGE>
            <cfset result_fn.EVENT = EVENT>
            <cfset result_fn.FRIENDLY_URL = FRIENDLY_URL>                      
            <cfset result_fn.status = true>

            <cfcatch type="any">
                <cfset result_fn.code = 100>
                <cfset result_fn.status = false>
                <cfset result_fn.error = cfcatch >
                <cfdump  var="#cfcatch#">
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result_fn),'//','')>
    </cffunction>

    <cffunction name="GET_SITES" access="remote" returntype="query">
        <cfquery name="GET_SITES" datasource="#dsn#">
            SELECT SITE_ID,DOMAIN FROM PROTEIN_SITES WHERE STATUS = 1
        </cfquery>
        <cfreturn GET_SITES>
    </cffunction>
     
</cfcomponent>