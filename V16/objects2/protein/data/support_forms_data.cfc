<cfcomponent extends="cfc.queryJSONConverter">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset result = StructNew()>
    <cfif isdefined("session.pp")>
        <cfset session_base = evaluate('session.pp')>
        <cfset company_id = session.pp.our_company_id>
        <cfset period_year = session.pp.period_year>
        <cfset language = session.pp.language>
    <cfelseif isdefined("session.ep")>
        <cfset session_base = evaluate('session.ep')>
        <cfset company_id = session.ep.our_company_id>
        <cfset period_year = session.ep.period_year>
        <cfset language = session.ep.language>
    <cfelseif isdefined("session.cp")>
        <cfset session_base = evaluate('session.cp')>
    <cfelseif isdefined("session.ww")>
        <cfset session_base = evaluate('session.ww')>
        <cfset company_id = session.ww.our_company_id>
        <cfset period_year = session.ww.period_year>
        <cfset language = session.ww.language>
    <cfelse>
        <cfset session_base = evaluate('session.qq')>
        <cfset company_id = session.qq.our_company_id>
        <cfset period_year = session.qq.period_year>
        <cfset language = session.qq.language>
    </cfif> 

    <!--- Not Bırakın, Sizi Arayalım --->
    <cffunction name="CONTACT_REQUEST" access="remote" returntype="string" returnformat="json">
        <cftry>            
            <cfsavecontent variable="topicContent">
                <cfoutput>
                    <strong>#arguments.contact_name# #arguments.contact_surname#</strong> bilgi talebinde bulundu</br>
                    <cfif len(arguments.contact_note)>
                        <strong>Firma</strong> : #arguments.contact_firm#</br>
                    </cfif>
                    <strong>Ad</strong> : #arguments.contact_name#</br>
                    <strong>Soyad</strong> : #arguments.contact_surname#</br>
                    <strong>Telefon</strong> : #arguments.contact_phone#</br>
                    <strong>E Mail</strong> : #arguments.contact_mail#</br>
                    <cfif len(arguments.contact_note)>
                        <strong>Not</strong> : #arguments.contact_note#
                    </cfif>
                    </br></br> <em>workcube.com'dan gönderildi.</em>
                    </br><a href="#CGI.HTTP_REFERER#">#CGI.HTTP_REFERER#</a>
                </cfoutput>
            </cfsavecontent>            
            <cfquery name="GET_TRAINING_REQUEST" datasource="#dsn#" result="query_result">	
                INSERT INTO
                    CUSTOMER_HELP (
                        PARTNER_ID,
                        COMPANY_ID,					
                        CONSUMER_ID,
                        WORKCUBE_ID,
                        PRODUCT_ID,
                        COMPANY,
                        APP_CAT,
                        INTERACTION_CAT,
                        INTERACTION_DATE,
                        SUBJECT,
                        PROCESS_STAGE,
                        DETAIL,
                        APPLICANT_NAME,
                        APPLICANT_MAIL,
                        IS_REPLY_MAIL,
                        IS_REPLY,	
                        RECORD_EMP,
                        RECORD_DATE,
                        RECORD_IP)
                VALUES
                    (
                        38261,
                        18538,
                        NULL,
                        NULL,
                        NULL,
                        NULL,
                        5,
                        9,
                        GETDATE(),
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#topicContent#">,
                        29,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="Ürün Bilgi ve Satış Talebi - #arguments.contact_name# #arguments.contact_surname#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contact_name# #arguments.contact_surname#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contact_mail#">,
                        0,
                        0,
                        1,
                        GETDATE(),
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                    )
            </cfquery>
               
            <cfset result.status = true>
            <cfset result.success_message = "Kaydı Yapıldı, Yönlendiriliyor">            
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
                <cfset result.error = cfcatch >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>
    
    <!--- Destek Çağrısı --->
    <cffunction name="CALL_SUPPORT" access="remote" returntype="any" returnFormat="json">
        <cftry>                  
            <cfquery name="GET_MAIN_PAPER" datasource="#DSN#">
                SELECT * FROM GENERAL_PAPERS_MAIN WHERE EMPLOYEE_NUMBER IS NOT NULL
            </cfquery>
            <cfset paper_code = evaluate('get_main_paper.g_service_app_no')>
            <cfset paper_number = evaluate('get_main_paper.g_service_app_number') +1>
    
            <cfset system_paper_no_add = paper_number>
            <cfquery name="UPD_GEN_PAP" datasource="#DSN#">
                UPDATE
                    GENERAL_PAPERS_MAIN
                SET
                    G_SERVICE_APP_NUMBER = #system_paper_no_add#
                WHERE
                    G_SERVICE_APP_NUMBER IS NOT NULL
            </cfquery>
    
            <cfset system_paper_no=paper_code & '-' & paper_number>
            <cfset x_is_sub_tree_single_select = 0> 
        
            <!--- textarea a basılıyor --->          
            <cfsavecontent variable="topicContent">                                    
            <cfif len(arguments.contact_note)>Firma : <cfoutput>#arguments.contact_firm#</cfoutput></cfif>
            AD : <cfoutput>#arguments.contact_name#</cfoutput>
            SOYAD : <cfoutput>#arguments.contact_surname#</cfoutput>
            TELEFON : <cfoutput>#arguments.contact_phone#</cfoutput>
            MAİL : <cfoutput>#arguments.contact_mail#</cfoutput>
            <cfif len(arguments.contact_note)>NOT : <cfoutput>#arguments.contact_note#</cfoutput></cfif>
            workcube.com'dan gönderildi.
            <cfoutput>#CGI.HTTP_REFERER#</cfoutput>                
            </cfsavecontent>
            <!--- textarea a basılıyor --->   

            <cfquery name="GET_SERVICE_REQUEST" datasource="#DSN#" result="query_result">	
                INSERT INTO
                    G_SERVICE
                    (
                        SERVICE_ACTIVE,
                        ISREAD,
                        SERVICECAT_ID,
                        SERVICE_STATUS_ID,
                        PRIORITY_ID,
                        COMMETHOD_ID,
                        SERVICE_HEAD,
                        SERVICE_DETAIL,
                        APPLY_DATE,
                        START_DATE,
                        SERVICE_EMPLOYEE_ID,
                        SERVICE_CONSUMER_ID,
                        SERVICE_COMPANY_ID,
                        SERVICE_PARTNER_ID,
                        NOTIFY_PARTNER_ID,
                        NOTIFY_CONSUMER_ID,
                        NOTIFY_EMPLOYEE_ID,
                        SERVICE_BRANCH_ID,
                        APPLICATOR_NAME,
                        APPLICATOR_EMAIL,
                        SERVICE_NO,
                        SUBSCRIPTION_ID,
                        PROJECT_ID,
                        REF_NO,
                        CUS_HELP_ID,
                        RECORD_DATE	
                    )
                    VALUES
                    (
                        1,
                        0,
                        1,
                        813,
                        1,
                        11,
                        'Destek Çağrısı - #arguments.contact_name# #arguments.contact_surname#',
                        '#topicContent#',
                        GETDATE(),
                        GETDATE(),
                        NULL,
                        NULL,
                        18538,                        
                        38261,
                        NULL,
                        NULL,
                        NULL,
                        NULL,
                        '#arguments.contact_name# #arguments.contact_surname#',
                        '#arguments.contact_mail#',
                        '#system_paper_no#',
                        NULL,
                        NULL,
                        NULL,
                        NULL,
                        GETDATE()
                    )            
            </cfquery>
               
            <cfset result.status = true>
            <cfset result.success_message = "Kaydı Yapıldı, Yönlendiriliyor">            
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
                <cfset result.error = cfcatch >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>       
    </cffunction>
</cfcomponent>