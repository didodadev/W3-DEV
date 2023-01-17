<cfcomponent extends="cfc.queryJSONConverter">

    <cfheader name="Access-Control-Allow-Origin" value="*" />
    <cfheader name="Access-Control-Allow-Methods" value="GET,POST" />
    <cfheader name="Access-Control-Allow-Headers" value="Content-Type" /> 

    <cfif isdefined("session.pp")>
        <cfset session_base = evaluate('session.pp')>
        <cfset session_base.period_is_integrated = 0>
    <cfelseif isdefined("session.ww")>
        <cfset session_base = evaluate('session.ww')>
    <cfelse>
        <cfset session_base = evaluate('session.qq')>
    </cfif> 

    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1_alias = "#dsn#_product">
    <cfset dsn_alias = '#dsn#'>
    <cfset dsn3 = dsn3_alias = '#dsn#_#this.GET_SITE().COMPANY#' />
    <cfset result = StructNew()>

    <cffunction name="GET_SESSION" access="remote" returntype="query">
        <cfquery name="GET_SESSION" datasource="#dsn#">
            SELECT * FROM WRK_SESSION WHERE CFTOKEN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cftoken#"> AND CFID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfid#">
        </cfquery>
        <cfreturn GET_SESSION>
    </cffunction>
    <cffunction name="GET_BASE_SESSION" access="remote" returntype="struct">
        <cfset uid = int(rand()*9999999)>
        <cfquery name="GET_BASE_SESSION" datasource="#dsn#">
           SELECT
                SP.PERIOD_ID,
                SP.PERIOD_YEAR,
                SP.OUR_COMPANY_ID,
                SP.OTHER_MONEY,
                SP.STANDART_PROCESS_MONEY,
                OC.COMPANY_NAME,
                OC.EMAIL,
                OC.NICK_NAME,
                OCI.SPECT_TYPE,
                OCI.IS_USE_IFRS,
                OCI.RATE_ROUND_NUM,
                SM.MONEY,
                SP.OTHER_MONEY MONEY2,
                SP.OTHER_MONEY,
                'tr' language,
                2 TIME_ZONE,
			    25 MAXROWS,
                'q-#uid#' USERKEY,
                'q' USERTYPE,
                '#uid#' USERID,
                '' NAME,
                '' SURNAME,
                '' USERNAME,
                '' EMAIL
            FROM
                OUR_COMPANY OC
                LEFT JOIN OUR_COMPANY_INFO OCI ON OC.COMP_ID = OCI.COMP_ID
                LEFT JOIN SETUP_PERIOD SP ON OC.COMP_ID = SP.OUR_COMPANY_ID
                LEFT JOIN SETUP_MONEY SM ON SP.PERIOD_ID = SM.PERIOD_ID
            WHERE
                SP.PERIOD_YEAR = #year(now())# AND
                SM.RATE1 = SM.RATE2 AND
                OC.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#">
        </cfquery>
        <cfreturn QueryGetRow(GET_BASE_SESSION,1)>
    </cffunction>

    <cffunction name="GET_SITE" access="remote" returntype="query">
        <cfquery name="GET_SITE" datasource="#dsn#">
            SELECT * FROM PROTEIN_SITES WHERE DOMAIN LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#cgi.SERVER_NAME#%">
        </cfquery>
        <cfreturn GET_SITE>
    </cffunction>

    <cffunction name="GET_PAGE" access="remote" returntype="query">
        
        <cfquery name="GET_PAGE" datasource="#dsn#">
         WITH T1 AS(
            SELECT
                UFU.USER_URL_ID,
                UFU.USER_FRIENDLY_URL,
                UFU.ACTION_TYPE,
                UFU.ACTION_ID,
                UFU.PROTEIN_PAGE,
                UFU.PROTEIN_SITE,
                UFU.PROTEIN_EVENT,
                PRP.*,
                (SELECT TOP 1 PAGE_ID FROM PROTEIN_PAGES WHERE PAGE_DATA LIKE '%"RELATED_PAGE":"'+CONVERT(varchar,PRP.PAGE_ID)+'"%' AND PAGE_DATA LIKE '%"EVENT":"det"%') AS DET_PAGE,
                (SELECT TOP 1 PAGE_ID FROM PROTEIN_PAGES WHERE PAGE_DATA LIKE '%"RELATED_PAGE":"'+CONVERT(varchar,PRP.PAGE_ID)+'"%' AND PAGE_DATA LIKE '%"EVENT":"list"%') AS LIST_PAGE,
                (SELECT TOP 1 PAGE_ID FROM PROTEIN_PAGES WHERE PAGE_DATA LIKE '%"RELATED_PAGE":"'+CONVERT(varchar,PRP.PAGE_ID)+'"%' AND PAGE_DATA LIKE '%"EVENT":"upd"%') AS UPD_PAGE,
                (SELECT TOP 1 PAGE_ID FROM PROTEIN_PAGES WHERE PAGE_DATA LIKE '%"RELATED_PAGE":"'+CONVERT(varchar,PRP.PAGE_ID)+'"%' AND PAGE_DATA LIKE '%"EVENT":"add"%') AS ADD_PAGE,
                (SELECT TOP 1 PAGE_ID FROM PROTEIN_PAGES WHERE PAGE_DATA LIKE '%"RELATED_PAGE":"'+CONVERT(varchar,PRP.PAGE_ID)+'"%' AND PAGE_DATA LIKE '%"EVENT":"dashboard"%') AS DASHBOARD_PAGE
            FROM
                USER_FRIENDLY_URLS UFU
                LEFT JOIN PROTEIN_PAGES PRP ON PRP.PAGE_ID = UFU.PROTEIN_PAGE 
            WHERE 
                UFU.PROTEIN_SITE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SITE#"> 
                AND UFU.USER_FRIENDLY_URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FRIENDLY_URL#">)

            SELECT
                T1.*,
                (SELECT TOP 1 USER_FRIENDLY_URL FROM USER_FRIENDLY_URLS WHERE ACTION_TYPE = 'PROTEIN_PAGE' AND ACTION_ID = T1.DET_PAGE) AS DET_PAGE_URL,
                (SELECT TOP 1 USER_FRIENDLY_URL FROM USER_FRIENDLY_URLS WHERE ACTION_TYPE = 'PROTEIN_PAGE' AND ACTION_ID = T1.LIST_PAGE) AS LIST_PAGE_URL,
                (SELECT TOP 1 USER_FRIENDLY_URL FROM USER_FRIENDLY_URLS WHERE ACTION_TYPE = 'PROTEIN_PAGE' AND ACTION_ID = T1.UPD_PAGE) AS UPD_PAGE_URL,
                (SELECT TOP 1 USER_FRIENDLY_URL FROM USER_FRIENDLY_URLS WHERE ACTION_TYPE = 'PROTEIN_PAGE' AND ACTION_ID = T1.ADD_PAGE) AS ADD_PAGE_URL,
                (SELECT TOP 1 USER_FRIENDLY_URL FROM USER_FRIENDLY_URLS WHERE ACTION_TYPE = 'PROTEIN_PAGE' AND ACTION_ID = T1.DASHBOARD_PAGE) AS DASHBOARD_PAGE_URL
            FROM
                T1  
        </cfquery>
        <cfreturn GET_PAGE>
    </cffunction>

    <cffunction name="GET_TEMPLATE" access="remote" returntype="query">
        <cfquery name="GET_TEMPLATE" datasource="#dsn#">
            SELECT
                TEMPLATE_ID,
                TITLE,
                TYPE,
                DESIGN_DATA
            FROM 
                PROTEIN_TEMPLATES 
            WHERE 
                SITE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SITE#">
                AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TYPE#">
                AND TEMPLATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TEMPLATE#">
        </cfquery>
        <cfreturn GET_TEMPLATE>
    </cffunction>

    <cffunction name="GET_WIDGET" access="remote" returntype="string" returnFormat="json">
        <cftry>
        	<cfquery name="GET_WIDGET" datasource="#dsn#" result="query_result">
                SELECT
                    PW.WIDGET_ID,
                    PW.WIDGET_NAME,
                    ISNULL(SLT.ITEM_#UCase(session_base.language)#,PW.TITLE) AS TITLE,
                    PW.WIDGET_DATA,
                    CW.WIDGET_FILE_PATH,
                    PW.WIDGET_EXTEND,
                    PW.WIDGET_BOX_DATA,
                    PW.WIDGET_SEO_DATA
                FROM 
                    PROTEIN_WIDGETS PW
	                LEFT JOIN WRK_WIDGET CW ON PW.WIDGET_NAME = CW.WIDGETID
                    LEFT JOIN SETUP_LANGUAGE_TR SLT ON CW.WIDGET_TITLE_DICTIONARY_ID = SLT.DICTIONARY_ID
                WHERE 
                    PW.SITE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SITE#">
                    AND PW.WIDGET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.WIDGET#">
                    AND PW.STATUS = 1
            </cfquery>
            <cfset result.status = true>
            <cfset result.identitycol = #arguments.WIDGET#>
            <cfset result.data = this.returnData(replace(serializeJSON(GET_WIDGET),"//",""))>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')> 
    </cffunction>

    <cffunction name="GET_DESIGN_BLOCK" access="remote" returntype="string">
        <cfargument name="WIDGET" default="">
        <cfquery name="get_desing_blocks_query" datasource="#dsn#">        	
            SELECT
                DESIGN_BLOCK_ID ID,BLOCK_CONTENT_TITLE,BLOCK_CONTENT
            FROM
                PROTEIN_DESIGN_BLOCKS
            WHERE
                PROTEIN_WIDGET_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.WIDGET#">                        
        </cfquery>
        <cfreturn "#get_desing_blocks_query.BLOCK_CONTENT#">
    </cffunction>

    <cffunction name="GET_MENU" access="remote" returntype="query">
        <cfquery name="GET_MENU" datasource="#dsn#">
            SELECT TOP 1
                MENU_ID,
                MENU_NAME,
                MENU_DATA
            FROM
                PROTEIN_MENUS
            WHERE
                MENU_STATUS = 1
                AND MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.MENU#">
            ORDER BY UPDATE_DATE DESC, RECORD_DATE DESC
        </cfquery>
        <cfreturn GET_MENU>
    </cffunction>

    <cffunction name="GET_ACTION_TITLE" access="remote" returntype="string">
        <cfargument name="ACTION" default="">
        <cfargument name="ACTION_ID" default="">
        <cfswitch expression ="#ACTION#">
            <cfcase value="PROTEIN_PAGE">
                <cfquery name="GET_ACTION_TITLE_QUERY" datasource="#dsn#">
                    SELECT TOP 1 TITLE FROM PROTEIN_PAGES WHERE PAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ACTION_ID#">
                </cfquery> 
            </cfcase>
            <cfcase value="SUBSCRIPTION_ID">
                <cfquery name="GET_ACTION_TITLE_QUERY" datasource="#dsn3#">
                    SELECT TOP 1 SUBSCRIPTION_NO + ' : ' + SUBSCRIPTION_HEAD TITLE FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#contentEncryptingandDecodingAES(isEncode:0,content:ACTION_ID,accountKey:'wrk')#">
                </cfquery>                
            </cfcase>
            <cfcase value="wid">
                <cfquery name="GET_ACTION_TITLE_QUERY" datasource="#dsn#">
                    SELECT TOP 1 CONVERT(NVARCHAR, WORK_ID) + ' : ' + WORK_HEAD TITLE FROM PRO_WORKS WHERE WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#contentEncryptingandDecodingAES(isEncode:0,content:ACTION_ID,accountKey:'wrk')#">
                </cfquery>                
            </cfcase>
            <cfcase value="id">
                <cfquery name="GET_ACTION_TITLE_QUERY" datasource="#dsn#">
                    SELECT TOP 1 PROJECT_NUMBER TITLE FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#contentEncryptingandDecodingAES(isEncode:0,content:ACTION_ID,accountKey:'wrk')#">
                </cfquery>                
            </cfcase>
        </cfswitch> 
        <cfreturn "#GET_ACTION_TITLE_QUERY.TITLE#">
    </cffunction>

    <cffunction name="GET_DEFAULT_MENU" access="remote" returntype="query">
        <cfquery name="GET_DEFAULT_MENU" datasource="#dsn#">
            SELECT TOP 1
                MENU_ID,
                MENU_NAME,
                MENU_DATA
            FROM
                PROTEIN_MENUS
            WHERE
                MENU_STATUS = 1
                AND IS_DEFAULT = 1
                AND SITE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SITE#">
                AND MENU_LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#">
            ORDER BY UPDATE_DATE DESC, RECORD_DATE DESC
        </cfquery>
        <cfreturn GET_DEFAULT_MENU>
    </cffunction>

    <cffunction name="GET_MEGA_MENU" access="remote" returntype="query">
        <cfquery name="GET_MEGA_MENU" datasource="#dsn#">
            SELECT TOP 1
                TITLE,
                MEGAMENU_DATA
            FROM
                PROTEIN_MEGA_MENUS
            WHERE
                STATUS = 1
                AND MEGAMENU_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.megamenu#">
        </cfquery>
        <cfreturn GET_MEGA_MENU>
    </cffunction>

    <cffunction name="GET_COMPANY" access="remote" returntype="query">
        <cfquery name="GET_COMPANY" datasource="#dsn#">
            SELECT 
                COMP_ID,
                COMPANY_NAME,
                NICK_NAME,
                TAX_NO,
                TAX_OFFICE,
                TEL_CODE,
                TEL,
                FAX,
                FAX2,
                EMAIL,
                ADDRESS,
                ADMIN_MAIL,
                ASSET_FILE_NAME1,
                ASSET_FILE_NAME2,
                ASSET_FILE_NAME3 logo
            FROM
                OUR_COMPANY
            WHERE
                COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#">
        </cfquery>
        <cfreturn GET_COMPANY>
    </cffunction>

    <cffunction name="GET_PAGE_DENIED" access="remote" returntype="query">
        <cfquery name="GET_PAGE_DENIED" datasource="#dsn#">
            SELECT TOP 1
                CPD.IS_VIEW,
                CPD.IS_INSERT,
                CPD.IS_DELETE
            FROM
                COMPANY_PARTNER_DENIED CPD
            WHERE
                 DENIED_PAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.page#">
                AND PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner#">
        </cfquery>
        <cfreturn GET_PAGE_DENIED>
    </cffunction>   
    <cffunction name="contentEncryptingandDecodingAES" access="public" returntype="string" hint="Generates the Base64 encoded encryption" output="false">
        <cfargument name="isEncode" type="numeric" required="false" default="1"  />
        <cfargument name="content" type="string" required="true" />
        <cfargument name="accountKey" type="string" required="true" />
        <cfargument name="apiKey1" type="string" required="false" default="" />
        <cfargument name="apiKey2" type="string" required="false" default="" />
        <cfargument name="apiKey3" type="string" required="false" default="" />
        <cfsavecontent variable="message">
            <cf_get_lang dictionary_id="52126">\n
            <cf_get_lang dictionary_id="52153">
        </cfsavecontent>
        
        
        
        <cfscript>
        
            try{
                var salted = arguments.accountKey & arguments.apiKey1 & arguments.apiKey2 & arguments.apiKey3;
                var hashed = binaryDecode(hash(salted, "sha"), "hex");
                var trunc = arrayNew(1);
                var i = 1;
                for (i = 1; i <= 16; i ++) {
                    trunc[i] = hashed[i];
                }
                var generateKey = binaryEncode(javaCast("byte[]", trunc), "Base64");
                
                if(arguments.isEncode eq 1)
                    return encrypt(arguments.content, generateKey, "AES/CBC/PKCS5Padding", "hex");
                else if(arguments.isEncode eq 0)
                    return decrypt(arguments.content, generateKey, "AES/CBC/PKCS5Padding", "hex");
            }
            catch(any e)
            {
               
                abort(message);	                 
            }
        </cfscript>
    </cffunction> 
    
</cfcomponent>