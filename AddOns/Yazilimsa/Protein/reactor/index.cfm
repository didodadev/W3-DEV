<cfparam  name="URL.param_1" default="">
<cfparam  name="URL.param_lang" default="">

<cfset SESSION_SERVICE = createObject('component','CFC.SYSTEM.SESSIONS')>
<cfset GET_SESSION = SESSION_SERVICE.GET_SESSION()>

<cfif isdefined("session.pp")>
    <cfset session_base = evaluate('session.pp')>
    <cfset session_base.period_is_integrated = 0>
<cfelseif isdefined("session.cp")>
    <cfset session_base = evaluate('session.cp')>
<cfelseif isdefined("session.ww")>
    <cfset session_base = evaluate('session.ww')>
<cfelse>
    <cfset session_base = evaluate('session.qq')>
</cfif>

<cfset MAIN = createObject('component','CFC.SYSTEM.MAIN')>
<cfset GET_SITE = MAIN.GET_SITE()>

<!----* LANGUAGE SETTINGS BEGIN ---->
<cfset ZONE_DATA = #deserializeJSON(GET_SITE.ZONE_DATA)#>


<cfset lang_list = {}>
<cfset download_folder = replace(application.systemParam.systemParam().download_folder,'\','/','all')>
<cfset site_language = (LEN(URL.param_lang))?URL.param_lang:(len(session_base.language))?session_base.language:'tr'><!--- TODO: varsayılan seçilecek  --->

<cfloop collection="#ZONE_DATA.LANGUAGE[1]#" item="item">
    <cfset lang = ZONE_DATA.LANGUAGE[1][#item#]>  
    <cfif structKeyExists(lang, "STATUS") AND lang.STATUS EQ 1>
        <cfset lang_list [#replace(lang.PATH, "/", "")#] = ["#lang.LANGUAGE_SET#","#item#"]>
    </cfif>
    
    <cfif structKeyExists(lang, "LANGUAGE_SHORT") AND lang.LANGUAGE_SHORT EQ site_language>
        <cfset site_language_path = "#lang.PATH#">
    <cfelseif structKeyExists(lang, "PATH") AND lang.PATH EQ "/#site_language#">
        <cfset site_language_path = "#lang.PATH#">
    </cfif>
</cfloop>


<cfif structKeyExists(lang_list, URL.param_lang)>
    <cfset site_language = lang_list[#URL.param_lang#][2]>
<cfelse>
        <cfset site_language = 
        (
            structKeyExists(session_base, "language")
            AND LEN(session_base.language)
        )?
            session_base.language:"tr"><!--- TODO: varsayılan seçilecek  --->
            
        <cfloop collection="#ZONE_DATA.LANGUAGE[1]#" item="item">
            <cfset lang = ZONE_DATA.LANGUAGE[1][#item#]>
            <cfif structKeyExists(lang, "LANGUAGE_SHORT") AND lang.LANGUAGE_SHORT EQ site_language>
                <cfset site_language_path = "#lang.PATH#">
            </cfif>
        </cfloop>

        <cffunction name="qrystringToStruct" returntype="any">    
            <cfargument name="str" required="true" default="">
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
        <cfset list_default_links = "datagate,widgetloader,woc,wocPreview">  
        <cfif listFind(list_default_links, URL.param_lang)>            
            <cfset URL.param_1 = URL.param_lang >
        <cfelse>
            <cflocation url="#qrystringToStruct(cgi.QUERY_STRING)#" addToken="false">
            <script>console.log("<cfoutput>#qrystringToStruct(cgi.QUERY_STRING)#</cfoutput>");</script>
        </cfif> 
        
</cfif>
<cfset session_base.language  = site_language>	
<!---* LANGUAGE SETTINGS END--->	

<cfset PRIMARY_DATA = #deserializeJSON(GET_SITE.PRIMARY_DATA)#>

<cfset MANIFEST = createObject("component","manifest").get()>
<cfif len(MANIFEST)>
    <cftry>
        <cffile action="write" file="#download_folder#/manifest.json" addnewline="no" output="#MANIFEST#" charset="utf-8" mode="777">
    <cfcatch></cfcatch>
    </cftry>
</cfif>
<cfset SCHEMA_ORG = {}>

<cfif GET_SITE.MAINTENANCE_MODE EQ 1 AND StructKeyExists(session, "MAINTENANCE_PASSWORD") EQ 'NO'>
    <cfinclude  template="maintenance.cfm">
    <cfabort>
<cfelseif GET_SITE.MAINTENANCE_MODE EQ 1 AND session.MAINTENANCE_PASSWORD NEQ PRIMARY_DATA.MAINTENANCE_PASSWORD>
    <cfinclude  template="maintenance.cfm">
    <cfabort>
</cfif>

<cfif isdefined("session.pp")>
    <cfset session.pp.language = site_language>
    <cfset session_base = evaluate('session.pp')>
    <cfset session_base.period_is_integrated = 0>
<cfelseif isdefined("session.cp")>
    <cfset session.cp.language = site_language>
    <cfset session_base = evaluate('session.cp')>
<cfelseif isdefined("session.ww")>
    <cfset session.ww.language = site_language>
    <cfset session_base = evaluate('session.ww')>
<cfelse>
    <cfset session.qq.language = site_language>
    <cfset session_base = evaluate('session.qq')>
</cfif>
<cfset session_base.OUR_COMPANY_ID = GET_SITE.COMPANY>
<cfset dsn = application.systemParam.systemParam().dsn>
<cfset dsn1_alias = "#dsn#_product">
<cfset dsn_alias = '#dsn#'>
<cfset dsn2 = dsn2_alias = '#dsn#_#session_base.period_year#_#session_base.OUR_COMPANY_ID#' />
<cfset dsn3 = dsn3_alias = '#dsn#_#session_base.OUR_COMPANY_ID#' />

<cfset server_url = "#cgi.http_host#">
<cfset partner_url = ""><!--- deprecated --->
<cfset employee_url = ""><!---  deprecated --->
<cfset session.dark_mode = 0>
<cfset REQUEST.self = "/#site_language#/#cgi.http_host#/">
<cfset thisPage = "/#url.param_1#">
<cfset IS_ONLY_SHOW_PAGE = 0>
<cfset WORKCUBE_MODE  = 0>
<cfset use_https  = 0>
<cfset dateformat_style = "dd/mm/yyyy">
<cfset timeformat_style = "HH:mm">

<cfscript>
    attributes=StructNew();
	StructAppend(attributes,form,true);
	StructAppend(attributes,url,true);
</cfscript>


<!--- ön tanımlı linkler --->
<cfswitch  expression="#url.param_1#">    
    <cfcase value="datagate">
        <cfinclude  template="PMO/datagate.cfm">
        <cfabort>
    </cfcase>
    <cfcase value="widgetloader">
        <cfinclude  template="PMO/widgetloader.cfm">
        <cfabort>
    </cfcase>
    <cfcase value="woc">
        <cfinclude  template="PMO/woc.cfm">
        <cfabort>
    </cfcase>
    <cfcase value="wocPreview">
        <cfinclude  template="PMO/woc_preview.cfm">
        <cfabort>
    </cfcase>
    <cfcase value="padmin">
        <cfinclude  template="protein_admin_login.cfm">
        <cfabort>
    </cfcase>
    <cfcase value="index">
        <cfif isdefined("url.fuseaction")>
            <cfinclude  template="caller_action.cfm">
            <cfabort>
        </cfif>
    </cfcase>
    <cfdefaultcase>
    </cfdefaultcase>
</cfswitch>


<cfset THEME_DATA = #deserializeJSON(GET_SITE.THEME_DATA)#>
<cfset ACCESS_DATA = #deserializeJSON(GET_SITE.ACCESS_DATA)#>

<cfset  PAGE_FRIENDLY_URL = (len(URL.param_1)?URL.param_1:"#ZONE_DATA.LANGUAGE[1]['#session_base.language#'].HOMEPAGE#")><!--- Dile göre set edilen başlangıç sayfası --->

<cfset GET_PAGE = MAIN.GET_PAGE(FRIENDLY_URL:PAGE_FRIENDLY_URL,SITE:GET_SITE.SITE_ID)>

<cfif LEN(GET_PAGE.ACTION_TYPE) NEQ 0 AND LEN(GET_PAGE.ACTION_ID) NEQ 0>
    <cfset attributes[#GET_PAGE.ACTION_TYPE#] = #GET_PAGE.ACTION_ID#><!--- USER_FRIENDLY_URLS ACTION_ID SET --->
</cfif>

<cfset GET_COMPANY = MAIN.GET_COMPANY(our_company_id : GET_SITE.COMPANY)>
<cfset PAGE_DATA = deserializeJSON(LEN(GET_PAGE.PAGE_DATA)?GET_PAGE.PAGE_DATA:{})>
<!--- <cfif cgi.remote_addr eq "127.0.0.1">
<cfdump  var="#GET_PAGE#">
<cfdump  var="#PAGE_DATA.RELATED_WO#">
</cfif> --->
<cfset REQUEST.self = "/#site_language#/#GET_PAGE.FRIENDLY_URL#/">
<cfset GET_BODY_TEMPLATE = MAIN.GET_TEMPLATE(SITE:GET_SITE.SITE_ID,TYPE:1,TEMPLATE:GET_PAGE.TEMPLATE_BODY)>
<cfset GET_INSIDE_TEMPLATE = MAIN.GET_TEMPLATE(SITE:GET_SITE.SITE_ID,TYPE:2,TEMPLATE:GET_PAGE.TEMPLATE_INSIDE)>
<cfset GET_DEFAULT_MENU = MAIN.GET_DEFAULT_MENU(SITE:GET_SITE.SITE_ID)>
<cfif len(GET_DEFAULT_MENU.MENU_DATA)>
    <cfset GET_DEFAULT_MENU_JSON = #deserializeJSON(GET_DEFAULT_MENU.MENU_DATA)#>
<cfelse>
    <cfset GET_DEFAULT_MENU_JSON = #deserializeJSON("[]")#>
</cfif>
<cfif GET_BODY_TEMPLATE.Recordcount eq 0 AND GET_INSIDE_TEMPLATE.Recordcount eq 0>
    <!--- TODO hata gösterimi için custom tag oluşturulacak, mail, abort, message parametreleri alacak. --->
    Template Seçiniz <cfabort>
<cfelse>
    <cfset BODY_DESIGN = #deserializeJSON(GET_BODY_TEMPLATE.DESIGN_DATA)#>
    <cfset INSIDE_DESIGN = #deserializeJSON(GET_INSIDE_TEMPLATE.DESIGN_DATA)#>
</cfif>
<cfif GET_SESSION.RecordCount eq 0 AND PAGE_DATA.ACCESS_DATA[1].CARIER.STATUS EQ 1 AND PAGE_DATA.ACCESS_DATA[1].PUBLIC.STATUS NEQ 1>
    <cfinclude  template="login.cfm">
<cfelseif GET_SESSION.RecordCount eq 0 AND PAGE_DATA.ACCESS_DATA[1].COMPANY.STATUS EQ 1 AND PAGE_DATA.ACCESS_DATA[1].PUBLIC.STATUS NEQ 1>
    <cfinclude  template="login.cfm">
<cfelse>
    <cfinclude  template="PMO/language_cfm_to_js.cfm">
    <cfif ACCESS_DATA.CONSUMER.STATUS>	
        <cfif not isdefined('session.ww')>
            <cfset session.ww = session_base>
            <cfif isdefined("url.fuseaction")>
                <cfinclude  template="caller_action.cfm">
                <cfabort>
            </cfif>
        <cfelse>
            <cfset session_base = session.ww>
        </cfif>    	
        <!--- ww --->
        <cfset GET_PAGE_DENIED = MAIN.GET_PAGE_DENIED(page:GET_PAGE.PAGE_ID,partner:0)><!--- sayfa kısıtı --->
        <cfinclude template="themes/#THEME_DATA.REACTOR#/index.cfm">
    <cfelseif ACCESS_DATA.COMPANY.STATUS>
        <cfscript>StructDelete(session,"ww",true);</cfscript>
        <!--- PP --->		
        <cfif GET_SESSION.RecordCount>
            <cfset session_base = session.pp>   
            <cfset GET_PAGE_DENIED = MAIN.GET_PAGE_DENIED(page:GET_PAGE.PAGE_ID,partner:session.pp.userid)><!--- sayfa kısıtı --->          
            <cfinclude template="themes/#THEME_DATA.REACTOR#/index.cfm">
        <cfelse>
            <cfinclude  template="login.cfm">
        </cfif>
    <cfelseif ACCESS_DATA.CARIER.STATUS>
        <!--- CP --->
        <cfset GET_PAGE_DENIED = MAIN.GET_PAGE_DENIED(page:GET_PAGE.PAGE_ID,partner:0)><!--- sayfa kısıtı --->
        <cfscript>StructDelete(session,"ww",true);</cfscript>       		
        <cfif GET_SESSION.RecordCount>
            <cfset session_base = session.cp>   
            <cfset GET_PAGE_DENIED = MAIN.GET_PAGE_DENIED(page:GET_PAGE.PAGE_ID,partner:session.cp.userid)><!--- sayfa kısıtı --->          
            <cfinclude template="themes/#THEME_DATA.REACTOR#/index.cfm">
        <cfelse>
            <cfinclude  template="login.cfm">
        </cfif>        
    <cfelseif ACCESS_DATA.PUBLIC.STATUS>
        <cfset GET_PAGE_DENIED = MAIN.GET_PAGE_DENIED(page:GET_PAGE.PAGE_ID,partner:0)><!--- sayfa kısıtı --->
        <cfinclude template="themes/#THEME_DATA.REACTOR#/index.cfm">
    <cfelse>
        P R O T E I N 
    </cfif>
</cfif>
<cfinclude  template="PMO/protein_admin_tool_bar.cfm">