<!---
    File :          AddOns\Yazilimsa\Protein\view\po\publishing_settings.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          20.04.2021
    Description :   frienly url wo page ilişkisi yayın ayarları widgetı methodları
    Notes :         frienly url alan module objelerinin protein pageleri ile ilişkisini organize eder
                    AddOns\Yazilimsa\Protein\view\po\publishing_settings.cfm ile çağırılır
--->
<cfcomponent extends="cfc.queryJSONConverter">

    <cfheader name="Access-Control-Allow-Origin" value="*" />
    <cfheader name="Access-Control-Allow-Methods" value="GET,POST" />
    <cfheader name="Access-Control-Allow-Headers" value="Content-Type" /> 

    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset result = StructNew()>

    <cffunction name="fn_friendly_control" access="package"  returntype="string" returnFormat="json">
        <cfargument name="FRIENDLY_URL" type="string">
        <cfargument name="SITE" type="numeric" default="">
        <cfargument name="PAGE" type="numeric" default="">
        <cfargument name="ACTION_TYPE" type="string" default="">
        <cfargument name="ACTION_ID" type="numeric" default="">
        <cfargument name="USER_URL_ID" type="numeric" default="0">
        <cfargument name="EVENT" type="string" default="">
        <cftry>
            <cfset result_fn.status = true>
            <cfset CLEAR_FRIENDLY_URL = trim(arguments.FRIENDLY_URL)>
            <cfif len(CLEAR_FRIENDLY_URL) eq 0>  
                <cfset result_fn.status = false>
                <cfset result_fn.code = 205>
                <cfset result_fn.response_message = 'friendly url cannot be empty'>         
            </cfif>
            <cfif result_fn.status> 
                <cfset CLEAR_FRIENDLY_URL = replacelist(lcase(CLEAR_FRIENDLY_URL),"/,*, ,',ğ,ü,ş,ö,ç,ı,İ,:,;,_,.,!,?","-,x,-,-,g,u,s,o,c,i,I,-,-,-,-,-,-")>
                <cfset CLEAR_FRIENDLY_URL = replace("#CLEAR_FRIENDLY_URL#-","--","","all")>
                <cfset CLEAR_FRIENDLY_URL = replace(CLEAR_FRIENDLY_URL,",","-","all")>
                <cfset CLEAR_FRIENDLY_URL = replace(CLEAR_FRIENDLY_URL,"--","-","all")>
                <cfset CLEAR_FRIENDLY_URL = replace(CLEAR_FRIENDLY_URL,"--","-","all")>
                <cfset CLEAR_FRIENDLY_URL = replace(CLEAR_FRIENDLY_URL,"--","","all")>  
                <cfset CLEAR_FRIENDLY_URL = replace("#CLEAR_FRIENDLY_URL#-","--","","all")>   
                
                <cfquery name="CONTROL_ACTION" datasource="#dsn#">
                    SELECT
                        USER_FRIENDLY_URL,
                        PROTEIN_SITE,
                        PROTEIN_PAGE,
                        PROTEIN_EVENT
                    FROM 
                        USER_FRIENDLY_URLS
                    WHERE
                        ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_TYPE#">
                        AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ACTION_ID#">                        
                </cfquery> 
                <cfquery name="CONTROL_FRIENDLY_URL" datasource="#dsn#">
                    SELECT
                        USER_URL_ID,
                        USER_FRIENDLY_URL,
                        PROTEIN_SITE,
                        PROTEIN_PAGE,
                        PROTEIN_EVENT,
                        ACTION_TYPE,
                        ACTION_ID
                    FROM 
                        USER_FRIENDLY_URLS
                    WHERE
                        USER_FRIENDLY_URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CLEAR_FRIENDLY_URL#">
                        AND ACTION_TYPE != 'PROTEIN_PAGE'  
                </cfquery>            
                <!--- ?  Bu action için kayıt varmı --->    
                <cfif CONTROL_ACTION.recordcount><!--- ! EVET--->   
                    <!--- ?  Bu URL Uygunmu --->                   
                    <cfif CONTROL_FRIENDLY_URL.recordcount><!--- ! HAYIR incele---> 
                        <cfset sites_using_url =  ValueList(CONTROL_FRIENDLY_URL.PROTEIN_SITE)>                        
                        <cfif sites_using_url.listFind(site)><!--- ~ URL Bu bu sitede kullanılıyor--->
                            <cfquery name="action_using_url" dbtype="query">
                                SELECT * FROM CONTROL_FRIENDLY_URL WHERE 
                                ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_TYPE#">
                                AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ACTION_ID#">  
                                AND USER_URL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#USER_URL_ID#">  
                            </cfquery>
                            <cfif action_using_url.recordcount><!--- ~ URL Bu kayıt için kullanılıyor, uygun güncelle--->
                                <cfset result_fn.code = 201>                                
                                <cfset result_fn.response_message = "URL Bu kayıt için kullanılıyor">
                            <cfelse><!--- ~ URL farklı kayıt için kullanılıyor, uygun değil--->
                                <cfset result_fn.code = 101>
                                <cfset result_fn.response_message = "not available">
                                <cfset result_fn.status = false>
                            </cfif>                          
                        <cfelse><!--- ~ URL farklı sitede kullanılıyor, uygun---> 
                            <cfset result_fn.code = 202>
                            <cfset result_fn.response_message = "URL farklı sitede kullanılıyor">
                        </cfif> 
                    <cfelse><!--- ! EVET kullan---> 
                        <cfset result_fn.code = 200>
                        <cfset result_fn.response_message = "available">
                    </cfif>    
                <cfelse><!--- ! HAYIR --->
                    <!--- ?  Bu URL Uygunmu --->   
                    <cfif CONTROL_FRIENDLY_URL.recordcount><!--- ! HAYIR incele---> 
                        <cfset sites_using_url =  ValueList(CONTROL_FRIENDLY_URL.PROTEIN_SITE)>                        
                        <cfif sites_using_url.listFind(site)><!--- ~ URL Bu bu sitede kullanılıyor--->                            
                            <cfset result_fn.code = 101>
                            <cfset result_fn.response_message = "not available">
                            <cfset result_fn.status = false>                                                  
                        <cfelse><!--- ~ URL farklı sitede kullanılıyor, uygun---> 
                            <cfset result_fn.code = 200>
                            <cfset result_fn.response_message = "URL farklı sitede kullanılıyor">
                        </cfif> 
                    <cfelse><!--- ! EVET kullan---> 
                        <cfset result_fn.code = 200>
                        <cfset result_fn.response_message = "available">
                    </cfif>
                </cfif>

                <cfset result_fn.SITE = SITE>
                <cfset result_fn.PAGE = PAGE>
                <cfset result_fn.EVENT = EVENT>
                <cfset result_fn.FRIENDLY_URL = CLEAR_FRIENDLY_URL>                      
            </cfif>
            <cfcatch type="any">
                <cfset result_fn.status = false>
                <cfset result_fn.response_message = cfcatch>
                <cfset result_fn.code = 204>
                <cfset result_fn.error = cfcatch >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result_fn),'//','')>
    </cffunction>

    <cffunction name="generate_friendly" access="remote"  returntype="string" returnFormat="json">
        <!--- NASIL ÇALIŞIR
            1 - ACTION_TYPE a göre switche girer ACTION_ID ile uygun url cümleciği alınır.
            2 - Oluşan url cümleciği fn_friendly_control fonksiyonuna gider ugunn hale gelene kadar loop ta döner.
            3 - Fonksiyondan dönen uygun friendly url publish_page fonsiyonuna gider.
        --->
        <cfset arguments_content = deserializeJSON(getHttpRequestData().content)> 
        <cfscript>
            StructAppend(arguments,arguments_content,false);
        </cfscript>
        <cftry>
            <cfset result.status = true>
            <!--- Action Type Göre Friendly Önerisi Getirir --->
            <cfswitch expression="#arguments.ACTION_TYPE#">
                <cfcase value="cntid">
                    <cfquery name="GET_SFU" datasource="#dsn#">
                        SELECT LEFT(CONT_HEAD, 250) SUGGEST_FRIENDLY_URL FROM CONTENT WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
                    </cfquery>
                </cfcase>
                <cfdefaultcase>
                    <cfset result.status = false>
                    <cfset result.response_message = "205">
                    <cfset result.code = 205>
                    <cfset result.error = 'Tanımsız ACTION_TYPE'> 
                </cfdefaultcase>
            </cfswitch>   
            <cfif result.status> 
                <cfset SUGGEST_FRIENDLY_URL = GET_SFU.SUGGEST_FRIENDLY_URL>
                <cfloop index="i" from="1" to="10">
                    <!--- Validation --->
                    <cfset friendly_url_control = 
                    deserializeJSON(
                        fn_friendly_control(
                            FRIENDLY_URL:SUGGEST_FRIENDLY_URL,
                            SITE:((structKeyExists(arguments, "SITE"))?arguments.SITE:arguments.SITE_ID),
                            PAGE:arguments.PAGE_ID,
                            ACTION_TYPE:arguments.ACTION_TYPE,                   
                            ACTION_ID:arguments.ACTION_ID,
                            EVENT:arguments.EVENT)
                        )>
                    <cfif i eq 1>
                        <cfset result.data.friendly_control_code = friendly_url_control.code>
                        <cfset result.data.friendly_control_message = friendly_url_control.response_message> 
                    </cfif>
                    <cfif friendly_url_control.status>                       
                        <cfbreak>
                    <cfelse>
                        <cfset result.data.friendly_control_code = friendly_url_control.code>
                        <cfset result.data.friendly_control_message = friendly_url_control.response_message>
                        <cfset result.data.friendly_control_message = friendly_url_control>
                        <cfset SUGGEST_FRIENDLY_URL = "#SUGGEST_FRIENDLY_URL#-#encrypt(round(rand()*1000),'FR1END','CFMX_COMPAT','Hex')#">
                    </cfif>
                </cfloop><!--- Uygun FRIENDLY_URL Uretir --->
                <cfset result.data.FRIENDLY_URL = friendly_url_control.FRIENDLY_URL>                
                <cfif friendly_url_control.status eq false>  
                    <cfset result.status = false>
                    <cfset result.error = friendly_url_control.response_message>         
                </cfif>
            </cfif> 
            <cfif result.status>
                <cfset arguments.FRIENDLY_URL = friendly_url_control.FRIENDLY_URL>  
                           
                <cfif friendly_url_control.status>
                    <cfset result.status = true>
                    <cfset result.data.FRIENDLY_URL =  friendly_url_control.FRIENDLY_URL>
                    <cfset result.SUGGEST_FRIENDLY_URL = GET_SFU.SUGGEST_FRIENDLY_URL>
                    
                <cfelse>
                    <cfset result.status = false>
                    <cfset result.error = 'generate_friendly >> publish_page' >
                    <cfset result.data.publish_page = fn_publish_page>
                    <cfset result.response_message = "205">
                    <cfset result.code = 205>
                </cfif>                
                <cfset result.action = "generate_friendly"> 
            </cfif>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.response_message = "204">
                <cfset result.code = 204>
                <cfset result.expression = LEN(((structKeyExists(arguments, "SITE"))?arguments.SITE:arguments.SITE_ID))>
                <cfif LEN(((structKeyExists(arguments, "SITE"))?arguments.SITE:arguments.SITE_ID)) eq 0>
                    <cfset result.status = false>
                    <cfset result.error = 'Yayınlanacak Sayfa Seçimi Yapımız.' >
                <cfelse>
                    <cfset result.error = cfcatch >
                </cfif>                
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>   

    <cffunction name="get_publish_page_available" access="remote" returntype="string" returnFormat="json">
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>
        <cftry>
            <cfquery name="get_publish_page_available_query" datasource="#dsn#">
                --Action'ın yayınlanabileceği page ler
                SELECT DISTINCT
                    PG.PAGE_ID,
                    PG.SITE,
                    PG.TITLE,
                    ST.DOMAIN
                FROM 
                    PROTEIN_PAGES PG
                    LEFT JOIN USER_FRIENDLY_URLS UFU ON PG.PAGE_ID = UFU.PROTEIN_PAGE 
                    LEFT JOIN PROTEIN_SITES ST ON PG.SITE = ST.SITE_ID
                WHERE
                    PG.PAGE_DATA LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%"RELATED_WO":"#arguments.faction#"%'>
                    AND PG.PAGE_DATA LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%"EVENT":"#arguments.event#"%'>
                    AND PG.STATUS = 1
                    AND ST.STATUS = 1
                ORDER BY PG.SITE        
            </cfquery>
            <cfset result.status = true>
            <cfset result.action = "get_publish_page_available">
            <cfset result.data = this.returnData(replace(serializeJSON(get_publish_page_available_query),"//",""))>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="get_publish_page" access="remote" returntype="string" returnFormat="json">
        <cfset arguments = deserializeJSON(getHttpRequestData().content)>
        <cftry>
            <cfquery name="get_publish_page" datasource="#dsn#">
                SELECT
                    UFU.USER_URL_ID,
                    PG.PAGE_ID,
                    PG.SITE,
                    PG.TITLE,
                    ST.DOMAIN,
                    ST.COMPANY,
                    UFU.USER_FRIENDLY_URL FRIENDLY_URL,
                    UFU.OPTIONS_DATA,
                    UFU.ACTION_TYPE,
                    UFU.ACTION_ID,
                    ISNULL(UFU.STATUS,-1) STATUS,
                    '#arguments.event#' EVENT
                FROM 
                    PROTEIN_PAGES PG
                    LEFT JOIN USER_FRIENDLY_URLS UFU ON PG.PAGE_ID = UFU.PROTEIN_PAGE 
                    LEFT JOIN PROTEIN_SITES ST ON PG.SITE = ST.SITE_ID
                WHERE
                    PG.PAGE_DATA LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%"RELATED_WO":"#arguments.faction#"%'>
                    AND PG.PAGE_DATA LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%"EVENT":"#arguments.event#"%'>
                    AND PG.STATUS = 1
                    AND ST.STATUS = 1
                    AND UFU.ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_type#">
                    AND UFU.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
            </cfquery>
            <cfset result.status = true>
            <cfset result.action = "get_publish_page">
            <cfset result.data = this.returnData(replace(serializeJSON(get_publish_page),"//",""))>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="publish_page" access="remote" returntype="string" returnFormat="json">
        <cfset arguments_content = deserializeJSON(getHttpRequestData().content)> 
        <cfscript>
            StructAppend(arguments,arguments_content,false);
        </cfscript>
        <cfset result.status = true> 
        <cftry>          
                <!--- Validation --->
                <cfset friendly_url_control = 
                deserializeJSON(
                    fn_friendly_control(
                        FRIENDLY_URL:arguments.FRIENDLY_URL,
                        SITE:arguments.SITE,
                        PAGE:arguments.PAGE_ID,
                        ACTION_TYPE:arguments.ACTION_TYPE,                   
                        ACTION_ID:arguments.ACTION_ID,
                        EVENT:arguments.EVENT)
                    )>
                <cfif friendly_url_control.status eq false>  
                    <cfset result.status = false>
                    <cfset result.response_message = friendly_url_control.response_message>
                    <cfset result.code = friendly_url_control.code>
                    <cfset result.data = friendly_url_control>
                    <cfset result.action = "publish_page >> fn_friendly_control">
                    <cfset result.arguments = arguments>    
                    <cfif not len(arguments.FRIENDLY_URL) and arguments.status eq -1>
                        <cfquery name="delete_page" datasource="#dsn#">
                            DELETE FROM 
                                USER_FRIENDLY_URLS 
                            WHERE   
                                PROTEIN_SITE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SITE#">
                                AND PROTEIN_PAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PAGE_ID#">
                                AND PROTEIN_EVENT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EVENT#">
                                AND ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACTION_TYPE#">
                                AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ACTION_ID#">
                        </cfquery>
                    </cfif>     
                </cfif>
                <cfif result.status> 
                    <cfquery name="publish_page" datasource="#dsn#">
                        <cfif friendly_url_control.code eq 201>
                            UPDATE
                                USER_FRIENDLY_URLS
                            SET
                                USER_FRIENDLY_URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#friendly_url_control.FRIENDLY_URL#">,
                                STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.STATUS#">,
                                OPTIONS_DATA =<cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(SerializeJSON(arguments.OPTIONS_DATA),'//','')#">
                            WHERE
                                PROTEIN_SITE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SITE#">
                                AND PROTEIN_PAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PAGE_ID#">
                                AND PROTEIN_EVENT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EVENT#">
                                AND ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACTION_TYPE#">
                                AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ACTION_ID#">
                        
                        <cfelse>
                            INSERT INTO
                                USER_FRIENDLY_URLS (USER_FRIENDLY_URL,ACTION_TYPE,ACTION_ID,PROTEIN_SITE,PROTEIN_PAGE,PROTEIN_EVENT,OPTIONS_DATA,STATUS)
                            VALUES(
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#friendly_url_control.FRIENDLY_URL#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACTION_TYPE#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ACTION_ID#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SITE#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PAGE_ID#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EVENT#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(SerializeJSON(arguments.OPTIONS_DATA),'//','')#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.STATUS#">                  
                            )
                        </cfif>
                    </cfquery>
                    <cfset result.status = true>
                    <cfset result.data.fuc_code = friendly_url_control.code>
                    <cfset result.data.fuc_message = friendly_url_control.response_message> 
                    <cfset result.type = "insert">
                    <cfset result.action = "publish_page">
                </cfif>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.action = "publish_page">
                <cfset result.aaa = "#Replace(SerializeJSON(arguments.OPTIONS_DATA),'//','')#">  
                <cfset result.error = cfcatch >                
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="add_publish_page" access="remote" returntype="string" returnFormat="json">
        <cfset arguments_content = deserializeJSON(getHttpRequestData().content)> 
        <cfscript>
            StructAppend(arguments,arguments_content,false);
        </cfscript>
        <cfset result.status = true> 
        <cftry>          
                <!--- Validation --->
                <cfset friendly_url_control = 
                deserializeJSON(
                    fn_friendly_control(
                        FRIENDLY_URL:arguments.FRIENDLY_URL,
                        SITE:arguments.SITE_ID,
                        PAGE:arguments.PAGE_ID,
                        ACTION_TYPE:arguments.ACTION_TYPE,                   
                        ACTION_ID:arguments.ACTION_ID,
                        EVENT:arguments.EVENT,
                        LANGUAGE:arguments.OPTIONS_DATA.LANGUAGE)
                    )>
                <cfif result.status> 
                   
                        <cfif friendly_url_control.code eq 200 OR friendly_url_control.code eq 202 >
                            <cfquery name="add_publish_page_query" datasource="#dsn#">
                                 INSERT INTO
                                    USER_FRIENDLY_URLS (USER_FRIENDLY_URL,ACTION_TYPE,ACTION_ID,PROTEIN_SITE,PROTEIN_PAGE,PROTEIN_EVENT,OPTIONS_DATA,STATUS)
                                VALUES(
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#friendly_url_control.FRIENDLY_URL#">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACTION_TYPE#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ACTION_ID#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SITE_ID#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PAGE_ID#">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EVENT#">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(SerializeJSON(arguments.OPTIONS_DATA),'//','')#">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.STATUS#">                  
                                )                
                            </cfquery>
                            <cfset result.status = true>
                        <cfelse>
                            <cfset result.status = false>
                        </cfif>
                    <cfset result.data.fuc_code = friendly_url_control.code>
                    <cfset result.data.fuc_message = friendly_url_control.response_message>
                    <cfset result.error = friendly_url_control.response_message>    
                    <cfset result.type = "insert">
                    <cfset result.action = "add_publish_page">
                </cfif>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.action = "add_publish_page"> 
                <cfset result.error = cfcatch >                
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="upd_publish_page" access="remote" returntype="string" returnFormat="json">
        <cfset arguments_content = deserializeJSON(getHttpRequestData().content)> 
        <cfscript>
            StructAppend(arguments,arguments_content,false);
        </cfscript>
        <cfset result.status = true> 
        <cftry>         
            <cfif arguments.status eq -2>                   
                <cfquery name="delete_page" datasource="#dsn#">
                    DELETE FROM 
                        USER_FRIENDLY_URLS 
                    WHERE   
                        USER_URL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.USER_URL_ID#">
                </cfquery>
                <cfset result.response_message = "URL Silindi">
                <cfset result.type = "update">
                <cfset result.action = "upd_publish_page">
            <cfelse>                
                <!--- Validation --->
                <cfset friendly_url_control = 
                deserializeJSON(
                    fn_friendly_control(
                        FRIENDLY_URL:arguments.FRIENDLY_URL,
                        SITE:arguments.SITE,
                        PAGE:arguments.PAGE_ID,
                        ACTION_TYPE:arguments.ACTION_TYPE,                   
                        ACTION_ID:arguments.ACTION_ID,
                        LANGUAGE:arguments.OPTIONS_DATA.LANGUAGE,
                        USER_URL_ID: arguments.USER_URL_ID)
                    )>
                <cfif result.status> 
                
                        <cfif friendly_url_control.code eq 201 or friendly_url_control.code eq 200 or friendly_url_control.code eq 202>
                            <cfquery name="upd_publish_page_query" datasource="#dsn#">
                                UPDATE
                                    USER_FRIENDLY_URLS
                                SET
                                    USER_FRIENDLY_URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#friendly_url_control.FRIENDLY_URL#">,
                                    STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.STATUS#">,
                                    OPTIONS_DATA =<cfqueryparam cfsqltype="cf_sql_varchar" value="#Replace(SerializeJSON(arguments.OPTIONS_DATA),'//','')#">
                                WHERE
                                    USER_URL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.USER_URL_ID#">
                            </cfquery>
                            <cfset result.status = true>
                        <cfelse>
                            <cfset result.status = false>
                        </cfif>
                    <cfset result.data.fuc_code = friendly_url_control.code>
                    <cfset result.data.fuc_message = friendly_url_control.response_message>
                    <cfset result.data.FRIENDLY_URL = friendly_url_control.FRIENDLY_URL>
                    <cfset result.error = friendly_url_control.response_message>    
                    <cfset result.response_message = "Güncelleme Yapıldı">
                    <cfset result.type = "update">
                    <cfset result.action = "upd_publish_page">
                </cfif>
            </cfif>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.action = "upd_publish_page"> 
                <cfset result.error = cfcatch >                
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>
</cfcomponent>