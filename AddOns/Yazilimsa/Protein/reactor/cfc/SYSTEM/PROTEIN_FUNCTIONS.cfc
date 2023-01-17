<cfcomponent extends="cfc.queryJSONConverter">
    <cfif isdefined("session.pp")>
        <cfset session_base = evaluate('session.pp')>
        <cfset session_base.period_is_integrated = 0>
    <cfelseif isdefined("session.ep")>
        <cfset session_base = evaluate('session.ep')>
    <cfelseif isdefined("session.cp")>
        <cfset session_base = evaluate('session.cp')>
    <cfelseif isdefined("session.ww")>
        <cfset session_base = evaluate('session.ww')>
    <cfelse>
        <cfset session_base = evaluate('session.qq')>
    </cfif>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = "#dsn#_product">
    <cfset result = StructNew()>
    <cfparam  name="URL.param_1" default="">
    <cfset MAIN = createObject('component','cfc.SYSTEM.MAIN')>
    <cfset GET_SITE = MAIN.GET_SITE()>
    <cfset ZONE_DATA = #deserializeJSON(GET_SITE.ZONE_DATA)#>
    <cfset PAGE_FRIENDLY_URL = (len(URL.param_1)?URL.param_1:"#ZONE_DATA.LANGUAGE[1]['#session_base.language#'].HOMEPAGE#")><!--- Dile göre set edilen başlangıç sayfası --->
    <cfset GET_PAGE = MAIN.GET_PAGE(FRIENDLY_URL:PAGE_FRIENDLY_URL,SITE:GET_SITE.SITE_ID)>  
    
    <cffunction name="qrystringToStruct" returntype="any">    
        <cfargument name="str" required="true" default="">
        <cfargument name="site_language_path" required="true" default="">
        <cfset myStruct = {}>
        <cfscript>
            _url="#site_language_path#/";
            for(i=1; i LTE listLen(arguments.str,'&');i=i+1) {
            item = listToArray(listGetAt(arguments.str,i,'&'), "=");
            item_key = item[1];
            item_val = item[2];
            if(item_key != "param_lang" 
            && item_key != "param_1" 
            && item_key != "param_2" 
            && item_key != "param_3" 
            && item_key != "param_4"){
                _url=_url&"#item_key#=#item_val##(i neq listLen(arguments.str,'&'))?'&':''#";
            }else{
                _url= _url & "#item_val#";
            }
                    structInsert(myStruct, "#item_key#", item_val);
            }
        </cfscript>
        <cfreturn _url>
    </cffunction>  

    <cffunction name="SEND_MAIL" access="public" returntype="struct">
        <cfargument  name="from">
        <cfargument  name="to">
        <cfargument  name="content">
        <cfargument  name="subject">
        <cfset MAIL_SETTINGS_DATA = deserializeJSON(this.returnData(replace(serializeJSON(GET_SITE()),"//",""))[1].MAIL_SETTINGS_DATA)>

        <cfmail 
            to="#to#" 
            from="#MAIL_SETTINGS_DATA.USER#"
            subject="#subject#" 
            server="#MAIL_SETTINGS_DATA.SERVER#" 
            port="465" 
            usetls ="false"
            usessl ="true"
            username="#MAIL_SETTINGS_DATA.USER#" 
            password="#MAIL_SETTINGS_DATA.PASSWORD#"
            type ="text/html">
            <cfoutput>
                #content#
            </cfoutput>
        </cfmail>
        <cfset result = {}>
        <cfset result.data = MAIL_SETTINGS_DATA>
        <cfreturn result>
    </cffunction>   

    <cffunction name="GET_PAGE_TITLE" access="remote" eturntype="string" returnFormat="json">  
        <cfset PRIMARY_DATA = #deserializeJSON(GET_SITE.PRIMARY_DATA)#>

        <cfset PAGE_TITLE_DEFAULT = "#GET_PAGE.TITLE# | #PRIMARY_DATA.TITLE#">
        <cfset PAGE_TITLE = "">

        <cfswitch expression="#GET_PAGE.ACTION_TYPE#">
            <cfcase value="cntid">
                <cfquery name="get_title_query" datasource="#dsn#">
                    SELECT 
                        COALESCE(SLICN.ITEM,C.CONT_HEAD) AS TITLE
                    FROM 
                        CONTENT C
                        LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLICN
                            ON SLICN.UNIQUE_COLUMN_ID = C.CONTENT_ID 
                            AND SLICN.COLUMN_NAME ='CONT_HEAD'
                            AND SLICN.TABLE_NAME = 'CONTENT'
                            AND SLICN.LANGUAGE = '#session_base.language#'
                    WHERE 
                        CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PAGE.ACTION_ID#">
                </cfquery>
                <cfset PAGE_TITLE = get_title_query.TITLE>
            </cfcase>
            <cfcase value="PRODUCT_ID">
                <cfquery name="get_title_query" datasource="#dsn1#">
                    SELECT 
                        COALESCE(SLIPN.ITEM,P.PRODUCT_NAME) AS TITLE
                    FROM 
                        PRODUCT P
                        LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLIPN 
                            ON SLIPN.UNIQUE_COLUMN_ID = P.PRODUCT_ID 
                            AND SLIPN.COLUMN_NAME ='PRODUCT_NAME'
                            AND SLIPN.TABLE_NAME = 'PRODUCT'
                            AND SLIPN.LANGUAGE = '#session_base.language#'
                    WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PAGE.ACTION_ID#">
                </cfquery>
                <cfset PAGE_TITLE = get_title_query.TITLE>
            </cfcase>
            <cfdefaultcase>
                <cfset PAGE_DATA = #deserializeJSON(GET_PAGE.PAGE_DATA)#>
                <cfswitch expression="#PAGE_DATA.RELATED_WO#">
                    <cfcase value="content.list_content">
                    <cfif isDefined("url.param_2") and len(url.param_2)>
                    
                        <cfquery name="get_title_query" datasource="#dsn#">
                            SELECT 
                                COALESCE(SLICN.ITEM,C.CONT_HEAD) AS TITLE
                            FROM 
                                CONTENT C
                                LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLICN
                                    ON SLICN.UNIQUE_COLUMN_ID = C.CONTENT_ID 
                                    AND SLICN.COLUMN_NAME ='CONT_HEAD'
                                    AND SLICN.TABLE_NAME = 'CONTENT'
                                    AND SLICN.LANGUAGE = '#session_base.language#'
                            WHERE 
                                CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.param_2#">
                        </cfquery>
                        <cfset PAGE_TITLE = get_title_query.TITLE>
                    <cfelse>
                        <cfset PAGE_TITLE = "#PAGE_TITLE_DEFAULT# #GET_PAGE.ACTION_TYPE#">
                    </cfif>
                    </cfcase>                   
                    <cfdefaultcase>
                        <cfset PAGE_TITLE = "#PAGE_TITLE_DEFAULT# #GET_PAGE.ACTION_TYPE#">
                    </cfdefaultcase>
                </cfswitch>
            </cfdefaultcase>
        </cfswitch>

        <cfset PAGE_TITLE = len(PAGE_TITLE)?PAGE_TITLE:PAGE_TITLE_DEFAULT>

        <cfreturn PAGE_TITLE>
    </cffunction>
</cfcomponent>