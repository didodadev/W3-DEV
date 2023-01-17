<cfcomponent extends="cfc.queryJSONConverter">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset upload_folder = application.systemParam.systemParam().upload_folder>
    <cfset dir_seperator = application.systemParam.systemParam().dir_seperator>

    <cfsavecontent variable="warning">
        <cf_get_lang dictionary_id='62565.Kayıt İşlemi Gerçekleşti, Yönlendiriliyorsunuz'>
    </cfsavecontent>

    <cffunction name="get_emps_pars_cons" access="remote" returntype="query" output="no">
        <cfargument  name="company_id" default="">

        <cfquery name="GET_EMPS_PARS_CONS" datasource="#DSN#">
            <cfif isdefined('arguments.company_id') and len(arguments.company_id)>
                    SELECT
                        3 AS TYPE,
                        CP.PARTNER_ID AS UYE_ID,
                        CP.COMPANY_ID AS COMP_ID,
                        CP.COMPANY_PARTNER_NAME AS UYE_NAME,
                        CP.COMPANY_PARTNER_SURNAME AS UYE_SURNAME,
                        C.NICKNAME AS NICKNAME
                    FROM
                        COMPANY_PARTNER CP,
                        COMPANY C
                    WHERE
                        CP.COMPANY_ID = C.COMPANY_ID AND
                        CP.COMPANY_PARTNER_STATUS = 1 AND		
                        CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
                <cfif arguments.company_id neq session.pp.company_id>
                    UNION
                        SELECT
                            4 AS TYPE,
                            CP.PARTNER_ID AS UYE_ID,
                            CP.COMPANY_ID AS COMP_ID,
                            CP.COMPANY_PARTNER_NAME AS UYE_NAME,
                            CP.COMPANY_PARTNER_SURNAME AS UYE_SURNAME,
                            C.NICKNAME AS NICKNAME
                        FROM
                            COMPANY_PARTNER CP,
                            COMPANY C
                        WHERE
                            CP.COMPANY_ID = C.COMPANY_ID AND	
                            CP.COMPANY_PARTNER_STATUS = 1 AND	
                            CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                </cfif>
            <cfelse>
                    SELECT
                        1 AS TYPE,
                        EP.EMPLOYEE_ID AS UYE_ID,
                        0 AS COMP_ID,
                        EP.EMPLOYEE_NAME AS UYE_NAME,
                        EP.EMPLOYEE_SURNAME AS UYE_SURNAME,
                        '' AS NICKNAME
                    FROM
                        EMPLOYEE_POSITIONS EP,
                        WORKGROUP_EMP_PAR WE
                    WHERE
                        EP.POSITION_STATUS = 1 AND
                        EP.POSITION_CODE = WE.POSITION_CODE AND
                        WE.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
                UNION
                    SELECT
                        2 AS TYPE,
                        CP.PARTNER_ID AS UYE_ID,
                        CP.COMPANY_ID AS COMP_ID,
                        CP.COMPANY_PARTNER_NAME AS UYE_NAME,
                        CP.COMPANY_PARTNER_SURNAME AS UYE_SURNAME,
                        C.NICKNAME AS NICKNAME
                    FROM
                        COMPANY_PARTNER CP,
                        WORKGROUP_EMP_PAR WE,
                        COMPANY C
                    WHERE
                        C.COMPANY_ID = CP.COMPANY_ID AND
                        CP.PARTNER_ID = WE.PARTNER_ID AND
                        CP.COMPANY_PARTNER_STATUS = 1 AND
                        WE.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
                UNION
                    SELECT
                        3 AS TYPE,
                        CP.PARTNER_ID AS UYE_ID,
                        CP.COMPANY_ID AS COMP_ID,
                        CP.COMPANY_PARTNER_NAME AS UYE_NAME,
                        CP.COMPANY_PARTNER_SURNAME AS UYE_SURNAME,
                        C.NICKNAME AS NICKNAME
                    FROM
                        COMPANY_PARTNER CP,
                        COMPANY C
                    WHERE
                        CP.COMPANY_ID = C.COMPANY_ID AND
                        CP.COMPANY_PARTNER_STATUS = 1 AND		
                        CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
                UNION
                    SELECT
                        4 AS TYPE,
                        CP.PARTNER_ID AS UYE_ID,
                        CP.COMPANY_ID AS COMP_ID,
                        CP.COMPANY_PARTNER_NAME AS UYE_NAME,
                        CP.COMPANY_PARTNER_SURNAME AS UYE_SURNAME,
                        C.NICKNAME AS NICKNAME
                    FROM
                        COMPANY_PARTNER CP,
                        COMPANY C
                    WHERE
                        CP.COMPANY_ID = C.COMPANY_ID AND
                        CP.COMPANY_PARTNER_STATUS = 1 AND		
                        C.HIERARCHY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
                UNION
                    SELECT
                        5 AS TYPE,
                        C.CONSUMER_ID AS UYE_ID,
                        0 AS COMP_ID,
                        C.CONSUMER_NAME AS UYE_NAME,
                        C.CONSUMER_SURNAME AS UYE_SURNAME,
                        '' AS NICKNAME
                    FROM
                        CONSUMER C
                    WHERE	
                        C.HIERARCHY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
            </cfif>
        </cfquery>
        
        <cfreturn get_emps_pars_cons>
    </cffunction>

    <cffunction name="GET_NOTICES" access="remote" returntype="query" output="no">
        <cfargument name="our_company_id" deafult="#session.pp.company_id#"> 
        <cfquery name="GET_NOTICES" datasource="#DSN#">
            SELECT
              NOTICE_ID,
              NOTICE_NO,
              NOTICE_HEAD,
              POSITION_ID,
              POSITION_NAME,
              DEPARTMENT_ID,
              BRANCH_ID,
              OUR_COMPANY_ID,
              IS_VIEW_COMPANY_NAME,
              COMPANY_ID,
              STARTDATE,
              NOTICE_CITY
          FROM
              NOTICES
          WHERE
                STATUS=1 AND
                STARTDATE < =<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
                FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND 
                OUR_COMPANY_ID IS NOT NULL AND
                <cfif isDefined('arguments.our_company_id') and len(arguments.our_company_id)>
                    OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#"> AND
                </cfif>
                <cfif isDefined('arguments.city') and len(arguments.city)>
                    NOTICE_CITY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#arguments.city#,%"> AND			
                </cfif>
                <cfif isDefined('arguments.position_id') and len(arguments.position_id)>
                    POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_id#"> AND			
                </cfif>
                <cfif isdefined("arguments.keyword") and len(arguments.keyword)>
                    (	
                        DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
                        WORK_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
                        NOTICE_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                    )AND
                </cfif> 
                STATUS_NOTICE = -2 
          ORDER BY
              RECORD_DATE DESC
        </cfquery>   
        <cfreturn GET_NOTICES>
    </cffunction>

    <cffunction name="GET_BRANCHS" access="remote" returntype="query" output="no">
        <cfargument  name="our_company_id">
        <cfargument  name="branch_id">
        <cfargument  name="department_id">
        
        <cfquery name="GET_BRANCHS" datasource="#DSN#">
            SELECT 
                BRANCH.BRANCH_NAME,
                DEPARTMENT.DEPARTMENT_HEAD,
                OUR_COMPANY.NICK_NAME,
                OUR_COMPANY.COMPANY_NAME
            FROM 
                DEPARTMENT,
                BRANCH,
                OUR_COMPANY
            WHERE 
                OUR_COMPANY.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#"> AND
                BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#"> AND
                DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
        </cfquery>
        <cfreturn GET_BRANCHS>
    </cffunction>

    <cffunction name="add_notice" access="public" returntype="string" returnformat="json">
        <cftry>
            <cfif len(arguments.startdate)>
                <CF_DATE tarih="arguments.startdate">
            </cfif>
            <cfif len(arguments.finishdate)>
                <CF_DATE tarih="arguments.finishdate">
            </cfif>
            
            <cfif len(arguments.notice_no)>
                <cfquery name="control" datasource="#dsn#">
                    SELECT NOTICE_ID FROM NOTICES WHERE NOTICE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.notice_no#">
                </cfquery>
                <cfif control.RECORDCOUNT> 
                    <cfset result.status = false>
                    <cfset result.danger_message = "<cf_get_lang dictionary_id='35808.There is an entry with the same advert number.'> !">
                    <cfset result.error = "<cf_get_lang dictionary_id='35808.There is an entry with the same advert number.'> !" >
                    <cfreturn Replace(SerializeJSON(result),'//','')>
                </cfif>
            </cfif>
            
            <cfif isDefined("arguments.visual_notice") and len(arguments.visual_notice)>
                <cfset upload_folder = "#upload_folder##dir_seperator#hr#dir_seperator#">
                <cffile action="UPLOAD"
                        filefield="visual_notice"
                        destination="#upload_folder#"
                        mode="777"
                        nameconflict="MAKEUNIQUE"
                        accept = "image/*">
                    <cfset file_name = createUUID()>
                    <cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
                    <!---Script dosyalarını engelle  02092010 FA-ND --->
                    <cfset assetTypeName = listlast(cffile.serverfile,'.')>
                    <cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
                    <cfif listfind(blackList,assetTypeName,',')>
                        <cffile action="delete" file="#upload_folder##file_name#.#cffile.serverfileext#">
                        <cfset error_ = "\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!">
                    </cfif>
                    <cfset arguments.visual_notice = '#file_name#.#cffile.serverfileext#'>
            </cfif>
            
            <cfset arguments.detail=replace(arguments.detail,"'"," ","all")>
            <cfquery name="add_notice" datasource="#dsn#"  result="MAX_ID">
                INSERT INTO
                    NOTICES
                    (
                    NOTICE_HEAD,
                    NOTICE_NO,
                    STATUS,
                    STATUS_NOTICE,
                    DETAIL,
                    POSITION_NAME,
                    INTERVIEW_PAR,
                    <cfif len(validator_par)>
                        VALIDATOR_PAR,
                    <cfelse>
                        VALID, 
                        VALID_DATE, 
                        VALID_PAR,
                    </cfif>
                        STARTDATE, 
                        FINISHDATE, 	
                        PUBLISH, 
                        COMPANY_ID,
                        COMPANY,
                        OUR_COMPANY_ID,
                        NOTICE_CITY,
                        COUNT_STAFF,
                        WORK_DETAIL,
                        IS_VIEW_LOGO,
                        IS_VIEW_COMPANY_NAME,
                        VIEW_VISUAL_NOTICE,
                        <cfif isDefined("arguments.visual_notice") and len(arguments.visual_notice)>
                            VISUAL_NOTICE,
                            SERVER_VISUAL_NOTICE_ID,
                        </cfif>
                        RECORD_DATE,
                        RECORD_IP,
                        RECORD_PAR
                    )
                VALUES
                    (
                    '#arguments.notice_head#', 
                    '#arguments.notice_no#',
                    <cfif isdefined('arguments.status')>1<cfelse>0</cfif>,
                    <cfif len(arguments.status_notice)>#arguments.status_notice#,<cfelse>NULL,</cfif>
                    '#arguments.detail#',
                    <cfif len(arguments.app_position)>'#arguments.app_position#',<cfelse>NULL,</cfif>
                    <cfif len(arguments.interview_par)>
                        #listgetat(arguments.interview_par,1,',')#,
                    <cfelse>
                        NULL,
                    </cfif>
                    <cfif len(arguments.validator_par)>
                        #listgetat(arguments.validator_par,1,',')#, 
                    <cfelse>
                        1, 
                        #now()#, 
                        #session.pp.userid#, 
                    </cfif>
                    <cfif len(arguments.startdate)>#arguments.startdate#, <cfelse>NULL,</cfif>
                    <cfif len(arguments.finishdate)>#arguments.finishdate#,<cfelse>NULL,</cfif>
                    1,
                    #session.pp.company_id#,
                    '#session.pp.company#',
                    #session.pp.our_company_id#,
                    <cfif isdefined('arguments.city') and len(arguments.city)>',#arguments.city#,'<cfelse>NULL</cfif>,
                    <cfif len(arguments.staff_count)>#arguments.staff_count#<cfelse>NULL</cfif>,
                    <cfif len(arguments.work_detail)>'#arguments.work_detail#'<cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.view_logo")>1<cfelse>0</cfif>,
                    <cfif isdefined("arguments.view_company_name")>1<cfelse>0</cfif>,
                    <cfif isdefined("arguments.view_visual_notice")>1<cfelse>0</cfif>,
                    <cfif isDefined("arguments.visual_notice") and len(arguments.visual_notice)>
                        '#arguments.visual_notice#',
                        #fusebox.server_machine#,
                    </cfif>
                    #now()#,
                    '#cgi.REMOTE_ADDR#',
                    #session.pp.userid#
                    )
            </cfquery>
            <cfset result.status = true>
            <cfset result.success_message = warning>
            <cfset result.identity = MAX_ID.IDENTITYCOL>
        <cfcatch type="any">
            <cfset result.status = false>
            <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
            <cfset result.error = cfcatch >
        </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="GET_NOTICE" access="remote" returntype="query" output="no">
        <cfargument  name="notice_id" default="">
        <cfargument  name="company_id" default="">
        <cfargument  name="status_notice" default="">
        <cfargument  name="keyword" default="">

        <cfquery name="GET_NOTICE" datasource="#DSN#">
            SELECT
                *
            FROM
                NOTICES
            WHERE
                1=1
                <cfif len(arguments.notice_id)>
                    AND NOTICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.notice_id#">
                </cfif>
                <cfif len(arguments.company_id)>
                    AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                </cfif>
                <cfif len(arguments.status_notice)>
                    AND STATUS_NOTICE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.status_notice#"> 
                </cfif>
                <cfif len(arguments.keyword)>
                    AND 
                    (	
                        DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
                        WORK_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
                        NOTICE_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                    )
                </cfif>
            ORDER BY
                NOTICE_HEAD
        </cfquery>
        <cfreturn GET_NOTICE>
    </cffunction>
   
    <cffunction name="upd_notice" access="public" returntype="string" returnformat="json">
        <cftry>

            <cfif len(arguments.startdate)>
                <cf_date tarih="arguments.startdate">
            </cfif>
            <cfif len(arguments.finishdate)>
                <cf_date tarih="arguments.finishdate">
            </cfif>
            
            <cfif len(arguments.notice_no)>
                <cfquery name="CONTROL" datasource="#DSN#">
                    SELECT 
                        NOTICE_ID 
                    FROM 
                        NOTICES 
                    WHERE 
                        NOTICE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.notice_no#"> AND 
                        NOTICE_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.notice_id#">
                </cfquery>
                <cfif control.recordcount>
                    <cfset result.status = false>
                    <cfset result.danger_message = "<cf_get_lang dictionary_id='35808.There is an entry with the same advert number.'> !">
                    <cfset result.error = "<cf_get_lang dictionary_id='35808.There is an entry with the same advert number.'> !" >
                    <cfreturn Replace(SerializeJSON(result),'//','')>
                </cfif>
            </cfif>
            
            <cfquery name="GET_IMAGE" datasource="#DSN#">
                SELECT 
                    VISUAL_NOTICE,
                    SERVER_VISUAL_NOTICE_ID
                FROM 
                    NOTICES
                WHERE
                    NOTICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.notice_id#">
            </cfquery>
            
            <cfset upload_folder = "#upload_folder#hr#dir_seperator#">
            <cfif isDefined("del_visual_notice")>
                <cfif len(get_image.visual_notice)>
                    <cf_del_server_file output_file="hr/#get_image.visual_notice#" output_server="#get_image.server_visual_notice_id#">
                </cfif>
                <cfset arguments.visual_notice = "">
            <cfelse>
                <cfif isDefined("arguments.visual_notice") and len(arguments.visual_notice)>
                    <cfif len(get_image.visual_notice)>
                        <cf_del_server_file output_file="hr/#get_image.visual_notice#" output_server="#get_image.server_visual_notice_id#">
                    </cfif>
                    <cfset file_name = createUUID()>
                    <cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
                    <!---Script dosyalarını engelle  02092010 FA-ND --->
                    <cfset assetTypeName = listlast(cffile.serverfile,'.')>
                    <cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
                    <cfif listfind(blackList,assetTypeName,',')>
                        <cffile action="delete" file="#upload_folder##file_name#.#cffile.serverfileext#">
                        <cfset result.status = false>
                        <cfset result.danger_message = "\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!">
                        <cfset result.error = "\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!" >
                        <cfreturn Replace(SerializeJSON(result),'//','')>
                    </cfif>
                    <cfset arguments.visual_notice = '#file_name#.#cffile.serverfileext#'>
                <cfelse>
                    <cfset arguments.visual_notice = get_image.visual_notice>
                </cfif>
            </cfif>
            
            <cfset arguments.detail=replace(arguments.detail,"'"," ","all")>
            <cfquery name="UPD_NOTICE" datasource="#DSN#">
                UPDATE
                    NOTICES
                SET
                    NOTICE_HEAD = '#arguments.notice_head#', 
                    NOTICE_NO = '#arguments.notice_no#',
                    STATUS = <cfif isdefined('arguments.status')>1<cfelse>0</cfif>,
                    STATUS_NOTICE = <cfif len(arguments.status_notice)>#arguments.status_notice#,<cfelse>NULL,</cfif>
                    DETAIL = '#arguments.detail#',
                    POSITION_NAME = <cfif len(arguments.app_position)>'#arguments.app_position#',<cfelse>NULL,</cfif>
                    INTERVIEW_PAR = <cfif len(arguments.interview_par)>#listgetat(arguments.interview_par,1,',')#,<cfelse>NULL,</cfif>
                    VALIDATOR_PAR = <cfif isdefined("arguments.validator_par") and len(validator_par)>#listgetat(arguments.validator_par,1,',')#,<cfelse> NULL,</cfif>
                    <cfif isdefined("valid")>
                        <cfif valid eq 1>
                            VALID = 1, 
                            VALID_DATE = #now()#, 
                            VALID_PAR = #session.pp.userid#,
                        <cfelseif valid eq 0>
                            VALID = 0, 
                            VALID_DATE = #now()#, 
                            VALID_PAR = #session.pp.userid#,
                        </cfif>
                    </cfif>
                    STARTDATE = <cfif len(arguments.startdate)>#arguments.startdate#, <cfelse>NULL,</cfif>
                    FINISHDATE = <cfif len(arguments.finishdate)>#arguments.finishdate#,<cfelse>NULL,</cfif>
                    PUBLISH = 1,
                    COMPANY_ID = #session.pp.company_id#,
                    COMPANY = '#session.pp.company#',
                    OUR_COMPANY_ID = #session.pp.our_company_id#,
                    NOTICE_CITY = <cfif isdefined('arguments.city') and len(arguments.city)>',#arguments.city#,'<cfelse>NULL</cfif>,
                    COUNT_STAFF = <cfif len(arguments.staff_count)>#arguments.staff_count#<cfelse>NULL</cfif>,
                    WORK_DETAIL = <cfif len(arguments.work_detail)>'#arguments.work_detail#'<cfelse>NULL</cfif>,
                    IS_VIEW_LOGO = <cfif isdefined("arguments.view_logo")>1<cfelse>0</cfif>,
                    IS_VIEW_COMPANY_NAME = <cfif isdefined("arguments.view_company_name")>1<cfelse>0</cfif>,
                    VIEW_VISUAL_NOTICE = <cfif isdefined("arguments.view_visual_notice")>1<cfelse>0</cfif>,
                    <cfif isDefined("arguments.visual_notice") and len(arguments.visual_notice)>
                        VISUAL_NOTICE = '#arguments.visual_notice#',
                    </cfif>
                    UPDATE_DATE = #now()#,
                    UPDATE_IP = '#cgi.REMOTE_ADDR#',
                    UPDATE_PAR = #session.pp.userid#
                WHERE
                    NOTICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.notice_id#">
            </cfquery>
            <cfset result.status = true>
            <cfset result.success_message = warning>
            <cfset result.identity = arguments.notice_id>
        <cfcatch type="any">
            <cfset result.status = false>
            <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
            <cfset result.error = cfcatch >
        </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>   

    <cffunction name="GET_APPS" access="remote">
        <cfargument  name="keyword" default="">
        <cfargument  name="date_status" default="">
        <cfargument  name="status" default="">
        <cfargument  name="start_date" default="">
        <cfargument  name="finish_date" default="">
        <cfquery name="GET_APPS" datasource="#dsn#">
            SELECT
                EMPLOYEES_APP.EMPAPP_ID,
                EMPLOYEES_APP_POS.APP_POS_ID,
                EMPLOYEES_APP_POS.POSITION_ID,
                EMPLOYEES_APP_POS.POSITION_CAT_ID,
                EMPLOYEES_APP_POS.APP_DATE,
                EMPLOYEES_APP.NAME,
                EMPLOYEES_APP.SURNAME,
                EMPLOYEES_APP_POS.NOTICE_ID,
                EMPLOYEES_APP_POS.APP_POS_STATUS,
                EMPLOYEES_APP.RECORD_DATE
            FROM
                EMPLOYEES_APP,
                EMPLOYEES_APP_POS
            WHERE
                EMPLOYEES_APP.EMPAPP_ID IS NOT NULL
                AND EMPLOYEES_APP.EMPAPP_ID=EMPLOYEES_APP_POS.EMPAPP_ID
                AND EMPLOYEES_APP_POS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
                AND EMPLOYEES_APP_POS.APP_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">  
                AND EMPLOYEES_APP_POS.APP_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
                    <cfif isdefined("arguments.keyword") AND len(arguments.keyword)>
                     AND
                       (
                            EMPLOYEES_APP.NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
                            EMPLOYEES_APP.SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                        )
                    </cfif>
                    <cfif len(arguments.status) eq 1>
                        AND EMPLOYEES_APP_POS.APP_POS_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.status#">
                     </cfif>
                 <cfif arguments.date_status eq 1>ORDER BY EMPLOYEES_APP_POS.APP_DATE DESC
                    <cfelseif arguments.date_status eq 2>ORDER BY EMPLOYEES_APP_POS.APP_DATE ASC
                    <cfelseif arguments.date_status eq 3>ORDER BY EMPLOYEES_APP.RECORD_DATE DESC
                    <cfelseif arguments.date_status eq 4>ORDER BY EMPLOYEES_APP.RECORD_DATE ASC
                    <cfelseif arguments.date_status eq 5>ORDER BY NAME DESC
                    <cfelseif arguments.date_status eq 6>ORDER BY NAME ASC
                </cfif>
        </cfquery>
        <cfreturn GET_APPS>
    </cffunction>

    <cffunction name="GET_APP" access="remote">
        <cfargument  name="app_pos_id" default="">
        <cfargument  name="company_id" default="">
        <cfargument  name="not_app_pos" default="0">
        <cfargument  name="empapp_id" default="">
        <cfquery name="get_app" datasource="#dsn#">
            SELECT 
                * 
            FROM 
                EMPLOYEES_APP_POS 
            WHERE 
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                <cfif not_app_pos eq 0>
                    AND APP_POS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.app_pos_id#"> 
                <cfelse>
                    AND APP_POS_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.app_pos_id#">
                </cfif>
                <cfif len(arguments.empapp_id)>
                    AND EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empapp_id#">
                </cfif>
        </cfquery>
        <cfreturn get_app>
    </cffunction>

    <cffunction name="add_empapp_mail" access="public" returntype="string" returnformat="json">
        <cftry>
            <cfif isdefined("arguments.mail") and len(arguments.mail)>
                <cfset arguments.empapp_id = arguments.mail>
            </cfif>
                <cfif find('??isim??',arguments.content)>
                    <cfset isim_var=1>
                <cfelse>
                    <cfset isim_var=0>
                </cfif>
            <cfif isdefined("arguments.cont") and (arguments.cont eq 1)>
                <cfset counter = 1>
                <cfloop list="#arguments.empapp_id#" index="i" delimiters=",">
                    <cfif counter lte listlen(arguments.EMPLOYEE_EMAIL)>
                        <cfset emp_mail= listgetat(arguments.EMPLOYEE_EMAIL,counter,',')>
                    <cfelse>
                        <cfset emp_mail = "">
                    </cfif>
                    <cfif isim_var>
                        <!--- isim değişkeni geldi ise mail içindeki ?isim? degerini url den yollanan isim yapıyor--->
                        <cfquery name="get_name" datasource="#dsn#">
                            SELECT
                                NAME,
                                SURNAME
                            FROM
                                EMPLOYEES_APP
                            WHERE
                                EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emp_mail#">
                        </cfquery>
                        <cfset arguments.content2=replace(arguments.content,'??isim??','#get_name.name# #get_name.surname#','all')>
                    <cfelse>
                        <cfset arguments.content2=arguments.content>
                    </cfif>
                    <cfquery name="ADD_EMPAPP_MAIL" datasource="#DSN#">
                    INSERT  INTO
                        EMPLOYEES_APP_MAILS
                        (
                        EMPAPP_ID,
                        <cfif isdefined('arguments.app_pos_id') and len(arguments.app_pos_id)>APP_POS_ID,</cfif>
                        <cfif isdefined('arguments.list_id') and len(arguments.list_id)>LIST_ID,</cfif>
                        MAIL_HEAD,
                        <cfif len(emp_mail)>
                        EMPAPP_MAIL,
                        </cfif>
                        MAIL_CONTENT,
                        RECORD_DATE,
                        RECORD_IP,
                        RECORD_PAR
                        )
                        VALUES
                        (
                        #i#,
                        <cfif isdefined('arguments.app_pos_id') and len(arguments.app_pos_id)>#ListGetAt(arguments.app_pos_id,counter,',')#,</cfif>
                        <cfif isdefined('arguments.list_id') and len(arguments.list_id)>#arguments.list_id#,</cfif>
                        '#header#',
                    <cfif len(emp_mail)>
                        '#emp_mail#',
                    </cfif> 
                        '#arguments.content2#',
                        #now()#,
                        '#cgi.REMOTE_ADDR#',
                        #session.pp.userid#
                        )
                    </cfquery>
                    <cfset counter =counter + 1>
                </cfloop>
            <cfelse>
                <cfif isim_var>
                    <!--- isim değişkeni geldi ise mail içindeki ?isim? degerini url den yollanan isim yapıyor --->
                    <cfquery name="get_name" datasource="#dsn#">
                        SELECT
                            NAME,
                            SURNAME
                        FROM
                            EMPLOYEES_APP
                        WHERE
                            EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#EMPLOYEE_EMAIL#">
                    </cfquery>
                    <cfset arguments.content2=replace(arguments.content,'??isim??','#get_name.name# #get_name.surname#','all')>
                <cfelse>
                    <cfset arguments.content2=arguments.content>
                </cfif>
                <cfquery name="ADD_EMPAPP_MAIL" datasource="#DSN#">
                    INSERT INTO
                        EMPLOYEES_APP_MAILS
                    (
                        EMPAPP_ID,
                        <cfif isdefined('arguments.app_pos_id') and len(arguments.app_pos_id)>APP_POS_ID,</cfif>
                        <cfif isdefined('arguments.list_id') and len(arguments.list_id)>LIST_ID,</cfif>
                        MAIL_HEAD,
                        EMPAPP_MAIL,
                        MAIL_CONTENT,
                        RECORD_DATE,
                        RECORD_IP,
                        RECORD_PAR
                    )
                    VALUES
                    (
                        #arguments.empapp_id#,
                        <cfif isdefined('arguments.app_pos_id') and len(arguments.app_pos_id)>#arguments.app_pos_id#,</cfif>
                        <cfif isdefined('arguments.list_id') and len(arguments.list_id)>#arguments.list_id#,</cfif>
                        '#header#',
                        '#EMPLOYEE_EMAIL#',
                        '#arguments.content2#',
                        #now()#,
                        '#cgi.REMOTE_ADDR#',
                        #session.pp.userid#
                    )
                </cfquery>
            </cfif>
            
            <cfif isDefined("arguments.email") and (arguments.email eq "true")>
                <cfquery name="get_our_company" datasource="#dsn#"> <!--- Ayarlar sirket akis parametrelerinden girilen Insan kaynaklari mail adresi bilgisi mail from olarak alinmaktadir. --->
                    SELECT EMAIL FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.pp.our_company_id#
                </cfquery>
                <cfset sender = "İnsan Kaynakları <#get_our_company.EMAIL#>" >
                <cfloop list="#arguments.EMPLOYEE_EMAIL#" index="i" delimiters=",">
                    <cfif isim_var>
                        <!--- isim değişkeni geldi ise mail içindeki ?isim? degerini url den yollanan isim yapıyor--->
                        <cfquery name="get_name" datasource="#dsn#">
                            SELECT
                                NAME,
                                SURNAME
                            FROM
                                EMPLOYEES_APP
                            WHERE
                                EMAIL=<cfqueryparam cfsqltype="cf_sql_varchar" value="#i#">
                        </cfquery>
                        <cfset arguments.content2=replace(arguments.content,'??isim??','#get_name.name# #get_name.surname#','all')>
                    <cfelse>
                        <cfset arguments.content2=arguments.content>
                    </cfif>
                <cfmail  
                    to = "#i#"
                    from = "#sender#"
                    subject = "#arguments.header#" type="HTML">
                        <style type="text/css">
                            .color-header{background-color: ##a7caed;}
                            .color-border	{background-color:##6699cc;}
                            .color-row{	background-color: ##f1f0ff;}
                            .label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
                        </style>
                        #arguments.content2#
                </cfmail>
                </cfloop>
                <cfsavecontent variable="css">
                    <style type="text/css">
                        .color-header{background-color: ##a7caed;}
                        .color-border	{background-color:##6699cc;}
                        .color-row{	background-color: ##f1f0ff;}
                        .label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
                    </style>
                </cfsavecontent>
                <style type="text/css">
                    .color-header{background-color: ##a7caed;}
                    .color-border	{background-color:##6699cc;}
                    .color-row{	background-color: ##f1f0ff;}
                    .headbold {  font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
                </style>	  	   
                <table height="100%" width="100%" cellspacing="0" cellpadding="0">
                    <tr class="color-border">
                        <td valign="top"> 
                            <table height="100%" width="100%" cellspacing="1" cellpadding="2">
                                <tr class="color-list">
                                    <td height="35" class="headbold">&nbsp;&nbsp;Workcube E-Mail</td>
                                </tr>
                                <tr class="color-row">
                                    <td align="center" class="headbold">Mail Başarıyla Gönderildi</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </cfif>
            <cfset result.status = true>
            <cfset result.success_message = warning>
            <cfset result.identity = ''>
        <cfcatch type="any">
            <style type="text/css">
                .color-header{background-color: ##a7caed;}
                .color-border	{background-color:##6699cc;}
                .color-row{	background-color: ##f1f0ff;}
                .headbold {  font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
            </style>	
            <table height="100%" width="100%" cellspacing="0" cellpadding="0">
                <tr class="color-border">
                    <td valign="top"> 
                        <table height="100%" width="100%" cellspacing="1" cellpadding="2">
                            <tr class="color-list">
                                <td height="35" class="headbold">&nbsp;&nbsp;Workcube E-Mail</td>
                            </tr>
                            <tr class="color-row">
                                <td align="center" class="headbold">Kaydedildi Fakat Mail Göndermede Bir Hata Oldu Lütfen Verileri Kontrol Edip Sonra Tekrar Deneyiniz</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <cfset result.status = false>
            <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
            <cfset result.error = cfcatch >
        </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="upd_empapp_mail" access="public" returntype="string" returnformat="json">
        <cftry>
            <cfquery name="UPD_EMPAPP_MAIL" datasource="#DSN#">
                UPDATE
                    EMPLOYEES_APP_MAILS
                SET
                    EMPAPP_ID = #arguments.empapp_id#,
                    MAIL_HEAD = '#header#',
                    EMPAPP_MAIL = '#EMPLOYEE_EMAIL#',
                    MAIL_CONTENT = <cfif len(content)>'#content#'<cfelse>NULL</cfif>,
                    UPDATE_DATE = #now()#,	
                    UPDATE_IP = '#cgi.REMOTE_ADDR#',
                    UPDATE_PAR = #session.pp.userid#
                WHERE
                    EMP_APP_MAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EMP_APP_MAIL_ID#">
            </cfquery>
            
            <cfset result.status = true>
            <cfset result.success_message = warning>
            <cfset result.identity = '#arguments.EMP_APP_MAIL_ID#'>
        <cfcatch type="any">   
            <cfset result.status = false>
            <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
            <cfset result.error = cfcatch >
        </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="del_empapp_mail" access="public" returntype="string" returnformat="json">
        <cftry>
            <cfquery name="del_empapp_mail" datasource="#dsn#">
                DELETE FROM EMPLOYEES_APP_MAILS WHERE EMP_APP_MAIL_ID = #arguments.EMP_APP_MAIL_ID#
              </cfquery>
              
            <cfset result.status = true>
            <cfset result.success_message = warning>
            <cfset result.identity = '#arguments.EMP_APP_MAIL_ID#'>
        <cfcatch type="any">   
            <cfset result.status = false>
            <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
            <cfset result.error = cfcatch >
        </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="get_in_out_branches" access="remote" returntype="query" output="no">
        <cfargument  name="in_out_days" default="#session.cp.period_id#">
        <cfargument  name="branch_id" default="">
        <cfquery name="get_in_out_branches" datasource="#dsn#">
            SELECT DISTINCT
                B.BRANCH_NAME,
                B.BRANCH_ID,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME,
                E.EMPLOYEE_ID,
                EIO.START_DATE,
                D.DEPARTMENT_HEAD
            FROM
                EMPLOYEES_IN_OUT EIO
                LEFT JOIN BRANCH B ON EIO.BRANCH_ID = B.BRANCH_ID
                LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
                LEFT JOIN DEPARTMENT D ON EIO.DEPARTMENT_ID = D.DEPARTMENT_ID
            WHERE
                EIO.START_DATE BETWEEN #DATEADD("d",-arguments.in_out_days,now())# AND #NOW()#
                <cfif isdefined("arguments.branch_id") and len(arguments.branch_id)>
                   AND EIO.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#"> 
                </cfif>
            ORDER BY
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME
        </cfquery>
        <cfreturn get_in_out_branches>
    </cffunction>

    <cffunction name="add_change_pass" access="public" returntype="string" returnformat="json">
        <cftry>
            <cfif isdefined("arguments.username")>
                <cf_cryptedpassword password="#arguments.old_password#" output="sifre">
                <cfquery name="get_user" datasource="#dsn#">
                    SELECT
                        EMPAPP_ID,
                        NAME
                    FROM
                        EMPLOYEES_APP
                    WHERE
                        EMAIL=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">
                </cfquery>
               
                <cfif get_user.recordcount>
                    <cfif isdefined("arguments.new_username") and len(arguments.new_username)>
                        <cfquery name="GET_MAIL" datasource="#dsn#">
                            SELECT EMAIL FROM EMPLOYEES_APP WHERE EMAIL=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.new_username#"> AND EMPAPP_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#get_user.empapp_id#">
                        </cfquery>
                        <cfif get_mail.recordcount>
                            <script type="text/javascript">
                                {
                                    alert("<cf_get_lang no ='1486.Mail Adresine Sahip Kullanıcı Sisteme Kayıtlı'>!");
                                    history.go(-1);
                                }
                            </script>
                            <cfabort>
                        </cfif>
                    </cfif>
                    
                    <cfif arguments.new_password eq arguments.new_password2>
                        
                        <cf_cryptedpassword password="#arguments.new_password#" output="yeni_sifre">
                        <cfquery name="upd_pass" datasource="#dsn#">
                            UPDATE 
                                EMPLOYEES_APP 
                            SET
                                NAME = '#get_user.name#'
                                <cfif isdefined("arguments.new_password") and len(arguments.new_password)>,EMPAPP_PASSWORD='#yeni_sifre#'</cfif>
                                <cfif isdefined("arguments.new_username") and len(arguments.new_username)>
                                ,EMAIL = '#arguments.new_username#'
                                </cfif>
                            WHERE
                                EMPAPP_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_user.empapp_id#">
                        </cfquery>
                    <cfelse>
                        <cfsavecontent variable="result.error"><cf_get_lang no ='1484.Yeni Şifre ve Yeni Şifre Tekrar Alanlarını Kontrol Ediniz'>.</cfsavecontent>
                    </cfif>
                <cfelse>
                    <cfsavecontent variable="result.error"><cf_get_lang no ='1485.Girdiğiniz E-posta Adresi Veya Şifreniz Hatalı, Tekrar Kontrol Ediniz'>.</cfsavecontent>
                </cfif>
            <cfelse>
            </cfif>
            
            <cfset result.status = true>
            <cfset result.success_message = warning>
            <cfset result.identity = ''>
        <cfcatch type="any">
            <cfset result.status = false>
            <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
            <cfset result.error = cfcatch >
        </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>
</cfcomponent>