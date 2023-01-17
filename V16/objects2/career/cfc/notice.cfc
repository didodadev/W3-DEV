<cfcomponent extends="cfc.queryJSONConverter">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset upload_folder = application.systemParam.systemParam().upload_folder>
    <cfset dir_seperator = application.systemParam.systemParam().dir_seperator>
    <cfset user_domain = application.systemParam.systemParam().user_domain>
    <cfset FILE_WEB_PATH = application.systemParam.systemParam().FILE_WEB_PATH>

    <cfsavecontent variable="warning">
        <cf_get_lang dictionary_id='62565.Kayıt İşlemi Gerçekleşti, Yönlendiriliyorsunuz'>
    </cfsavecontent>

    <!--- Başvuru Paylaş--->
    <cffunction name="add_message_send" access="public" returntype="string" returnformat="json">
        <cftry>   
            <cfif isdefined('arguments.share_not') and arguments.share_not eq 1>
                <cfif len(arguments.company_id)>
                    <cfquery name="GET_COMP_NAME" datasource="#DSN#">
                        SELECT COMPANY_NAME FROM OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                    </cfquery>
                </cfif>
                <cfmail  
                    to = "#arguments.receive_email#"
                    from = "#arguments.sender_email#"
                    subject = "Iconomy Group İş Fırsatı - Pozisyon Adı" type="HTML">
                    <table width="698" height="523" border="0" style="background:url(http://cp.kariyerportal/documents/templates/newcareer/images/mail_sablon.jpg);font-size:12px;">
                        <tr height="30">
                            <td></td>
                        </tr>
                        <tr>
                            <td rowspan="6" width="30"></td>
                            <td>Merhaba!<br/>
                                Arkadaşınız #arguments.sender_name# <a href="http://#cgi.HTTP_HOST#" target="_blank">Iconomy Kariyer Portal</a>'dan size bu iş fırsatını gönderdi :
                            </td>
                        </tr>
                        <tr>
                            <td class="headbold">
                                şirket &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:
                                <cfif len(arguments.company_id)>
                                    #get_comp_name.company_name#
                                </cfif><br/>
                                konu &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:
                                #arguments.detail#<br/>
                                pozisyon :
                                #arguments.position#
                            </td>
                        </tr>
                        <tr>
                            <td>Arkadaşınızın Mesajı :<br/>
                                #arguments.receive_notes#		
                            </td>
                        </tr>
                        <tr>
                            <td>İlana ulaşmak için aşağıdaki linke tıklayın!<br/>
                                <a href="#request.self#?fuseaction=objects2.dsp_notice&notice_id=#arguments.notice_id#" target="_blank">http://#cgi.HTTP_HOST#/#request.self#?fuseaction=objects2.dsp_notice&amp;notice_id=#arguments.notice_id#</a>
                            </td>
                        </tr>
                        <tr height="40%">
                            <td></td>
                        </tr>
                    </table>
                </cfmail>
            <cfelse>
                <cfquery name="ADD_EMPAPP_MAIL" datasource="#DSN#">
                    INSERT INTO
                        EMPLOYEES_APP_MAILS
                        (
                            EMPAPP_ID,
                            MAIL_CONTENT,
                            EMPAPP_MAIL,
                            RECORD_DATE,
                            RECORD_IP,
                            RECORD_APP
                        )
                        VALUES
                        (
                            #session.cp.userid#,
                            <cfif isDefined('arguments.temp_detail')>'#arguments.temp_detail#'<cfelse>'#arguments.message_detail#'</cfif>,
                            <cfif isDefined('arguments.temp_email')>'#arguments.temp_email#'<cfelse>'#arguments.email#'</cfif>,
                            #now()#,
                            '#cgi.REMOTE_ADDR#',
                            #session.cp.userid#
                        )
                </cfquery>
            </cfif>

            <cfset result.status = true>
            <cfset result.success_message = warning>
            <cfset result.identity = "">
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
        <cfargument  name="notice_type" default="1">

        <cfquery name="GET_NOTICE" datasource="#dsn#">
            SELECT
                NOTICE_HEAD, 
                NOTICE_NO,
                STATUS,
                STATUS_NOTICE,
                DETAIL, 
                POSITION_ID,
                POSITION_NAME,
                POSITION_CAT_ID,
                POSITION_CAT_NAME,
                INTERVIEW_POSITION_CODE, 
                VALIDATOR_POSITION_CODE,
                VALID, 
                VALID_DATE, 
                VALID_EMP,
                STARTDATE, 
                FINISHDATE, 	
                PUBLISH, 
                COMPANY_ID,
                COMPANY,
                OUR_COMPANY_ID,
                DEPARTMENT_ID,
                BRANCH_ID,
                RECORD_DATE,
                RECORD_IP,
                RECORD_EMP,
                NOTICE_CITY,
                COUNT_STAFF,
                WORK_DETAIL,
                PIF_ID,
                IS_VIEW_LOGO,
                IS_VIEW_COMPANY_NAME,
                VIEW_VISUAL_NOTICE,
                SERVER_VISUAL_NOTICE_ID,
                VISUAL_NOTICE
            FROM
                NOTICES
            WHERE
                NOTICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.notice_id#"> 
                <cfif arguments.notice_type eq 1>
                    AND
                    STARTDATE < = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
                    FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
                    STATUS=1 
                </cfif>
        </cfquery>
    
        <cfreturn GET_NOTICE>
    </cffunction>

    <cffunction name="GET_APP_POS" access="remote" returntype="query" output="no">
        <cfargument  name="notice_id" default="">
        <cfargument  name="empapp_id" default="">

        <cfquery name="GET_APP_POS" datasource="#DSN#">
            SELECT
                APP_POS_ID
            FROM
                EMPLOYEES_APP_POS
            WHERE
                NOTICE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.notice_id#">
                AND EMPAPP_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empapp_id#">
        </cfquery>
        <cfreturn GET_APP_POS>
    </cffunction>

    <cffunction name="GET_APP_POS_WITH" access="remote" returntype="query" output="no">
        <cfargument  name="notice_id" default="">
        <cfargument  name="empapp_id" default="">

        <cfquery name="GET_APP_POS_WITH" datasource="#DSN#">
            SELECT
                NOTICES.NOTICE_ID,
                NOTICES.NOTICE_HEAD,
                NOTICES.NOTICE_NO,
                NOTICES.STATUS,
                EMPLOYEES_APP_POS.APP_POS_STATUS,
                EMPLOYEES_APP_POS.APP_POS_ID
            FROM
                EMPLOYEES_APP,
                EMPLOYEES_APP_POS,
                NOTICES
            WHERE
                EMPLOYEES_APP_POS.NOTICE_ID = NOTICES.NOTICE_ID AND
                EMPLOYEES_APP.EMPAPP_ID = EMPLOYEES_APP_POS.EMPAPP_ID AND
                EMPLOYEES_APP.EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empapp_id#">
        </cfquery>
        <cfreturn GET_APP_POS_WITH>
    </cffunction>

    <cffunction name="add_app_pos" access="public" returntype="string" returnformat="json">
        <cftry>
            <cfif len(arguments.startdate_if_accepted)>
                <cf_date tarih="arguments.startdate_if_accepted">
            <cfelse>
                <cfset arguments.startdate_if_accepted = "NULL">
            </cfif>
            <cfquery name="get_notice" datasource="#dsn#">
                SELECT
                    NOTICE_HEAD,
                    POSITION_ID,
                    POSITION_NAME,
                    POSITION_CAT_ID,
                    POSITION_CAT_NAME,
                    COMPANY_ID,
                    COMPANY,
                    OUR_COMPANY_ID,
                    DEPARTMENT_ID,
                    BRANCH_ID
                FROM
                    NOTICES
                WHERE
                    NOTICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.notice_id#">
            </cfquery>

            <cfquery name="add_app_pos" datasource="#dsn#">
                INSERT INTO
                    EMPLOYEES_APP_POS
                    (
                        EMPAPP_ID,
                        NOTICE_ID,
                        POSITION_ID,
                        POSITION_CAT_ID,
                        APP_DATE,
                        COMPANY_ID,
                        OUR_COMPANY_ID,
                        DEPARTMENT_ID,
                        BRANCH_ID,
                        SALARY_WANTED,
                        SALARY_WANTED_MONEY,
                        STARTDATE_IF_ACCEPTED,
                        APP_POS_STATUS,
                        DETAIL,
                        COMMETHOD_ID,
                        RECORD_DATE
                    )
                    VALUES(
                        #session.cp.userid#,
                        #arguments.notice_id#,
                        <cfif len(get_notice.POSITION_ID)>#get_notice.POSITION_ID#,<cfelse>NULL,</cfif>
                        <cfif len(get_notice.POSITION_CAT_ID)>#get_notice.POSITION_CAT_ID#,<cfelse>NULL,</cfif>
                        #NOW()#,
                        <cfif len(get_notice.COMPANY_ID)>#get_notice.COMPANY_ID#,<cfelse>NULL,</cfif>
                        <cfif len(get_notice.OUR_COMPANY_ID)>#get_notice.OUR_COMPANY_ID#,<cfelse>NULL,</cfif>
                        <cfif len(get_notice.DEPARTMENT_ID)>#get_notice.DEPARTMENT_ID#,<cfelse>NULL,</cfif>
                        <cfif len(get_notice.BRANCH_ID)>#get_notice.BRANCH_ID#,<cfelse>NULL,</cfif>
                        <cfif len(arguments.salary_wanted)>#arguments.salary_wanted#<cfelse>NULL</cfif>,
                        '#arguments.salary_wanted_money#',
                        #arguments.startdate_if_accepted#,
                        '1',
                        '#arguments.detail_app#',
                        6,
                        #NOW()#
                    )
            </cfquery>

            <cfquery name="GET_MAIL" datasource="#dsn#">
                SELECT EMAIL FROM EMPLOYEES_APP WHERE EMPAPP_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
            </cfquery>
            <cfquery name="get_info" datasource="#dsn#">
                SELECT EMAIL FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#">
            </cfquery>
            <cfmail to="#GET_MAIL.EMAIL#" from="#get_info.email#" subject="Başvurunuz Alınmıştır" type="html" charset="utf-8">

                <head>
                    <title>Workcube | Şifre Hatırlatma</title>
                    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
                    <link href="http://www.workcube.com.tr/haberler/e-bulten/css/ebulten.css" rel="stylesheet" type="text/css">
                </head>
                <html>
                    <body> 
                        <table>
                            <tr>
                                <td>
                                    <cfquery name="CHECK" datasource="#DSN#">
                                    SELECT ASSET_FILE_NAME1,EMAIL FROM OUR_COMPANY WHERE <cfif isDefined("session.cp.our_company_id")>COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#"></cfif>
                                    </cfquery>
                                    <cfif len(CHECK.asset_file_name1)><cfoutput><img src="#user_domain##file_web_path#settings/#CHECK.asset_file_name1#" border="0" title="<cf_get_lang_main no='1225.Logo'>" alt="<cf_get_lang_main no='1225.Logo'>"/></cfoutput></cfif>
                                </td>
                            </tr>
                            <tr>
                                <td>İnsan Kaynakları İş Başvurunuz hakkında</td>
                            </tr>
                            <tr>
                                <td>İlan: <cfoutput>#get_notice.notice_head#</cfoutput></td>
                            </tr>
                            <tr>
                                <td><span>Sayın;</span><span> <cfoutput>#session.cp.name# #session.cp.surname#</cfoutput></span></td>
                            </tr>
                            <tr>
                                <td>
                                    ilanına yaptığınız başvurunuz tarafımıza ulaşmıştır.
                                    Yaptığınız başvuruları ve cevaplarını / sonuçlarını üye sayfanızdaki ‘Başvurularım’ bölümünden takip edebilirsiniz.
                                    <br/>Şirketimize gösterdiğiniz ilgi için teşekkür ederiz.</p>
                                </td>
                            </tr>
                            <tr>
                                <td><cfif len(check.email)>#check.email#</cfif></td>
                            </tr>
                        </table>		
                    </body>
                </html>
            </cfmail>

            <cfset result.status = true>
            <cfset result.success_message = warning>
            <cfset result.identity = "">
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
                <cfset result.error = cfcatch >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>  
    </cffunction>
</cfcomponent>