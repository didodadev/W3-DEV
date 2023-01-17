<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn />
    <cffunction  name="ADD_IAM"  access="public" returntype="any">
        <cfargument name="comp_id" type="any" required="false" default="" hint="Iam User Company Id">
        <cfargument name="company_id" type="any" required="false" default="" hint="System Company Id">
        <cfargument name="subscription_id" type="any" required="false" default="" hint="Iam User Subscription Id">
        <cfargument name="subscription_no" type="any" required="false" default="" hint="Iam User Subscription No">
        <cfargument name="iam_active" type="any" required="false" default="" hint="Iam User Is Active">
        <cfargument name="username" type="any" required="false" default="" hint="Iam User Username">
        <cfargument name="member_name" type="any" required="false" default="" hint="Iam User Member Name">
        <cfargument name="member_sname" type="any" required="false" default="" hint="Iam User Member Surname">
        <cfargument name="password" type="any" required="false" default="" hint="Iam User Password">
        <cfargument name="pr_mail" type="any" required="false" default="" hint="Iam User First Email">
        <cfargument name="sec_mail" type="any" required="false" default="" hint="Iam User Second Email">
        <cfargument name="mobile_code" type="any" required="false" default="" hint="Iam User Mobil Phone Code">
        <cfargument name="mobile_no" type="any" required="false" default="" hint="Iam User Mobil Phone">
        <cfargument name="user_comp_name" type="any" required="false" default="" hint="Iam User Company Name">
        <cfargument name="domain" type="any" required="false" default="" hint="Iam User Site Domain">

        <cfset responseStruct = structNew()>
        <cftry>
            <cfif isDefined("arguments.comp_id") and len(arguments.comp_id)>
                <cfquery name="get_partner" datasource="#dsn#">
                    SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE COMPANY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.comp_id#">
                </cfquery>
            </cfif>

            <cfif IsDefined("arguments.company_id") and len(arguments.company_id)>
                <cfquery name="get_subscription" datasource="#dsn#_#arguments.company_id#">
                    SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.subscription_no#">
                </cfquery>
                <cfif get_subscription.recordcount><cfset arguments.subscription_id = get_subscription.SUBSCRIPTION_ID /></cfif>
            </cfif>

            <cfquery name="ADD_IAM" datasource="#dsn#"  result="my_result">
                INSERT INTO SUBSCRIPTION_IAM
                (
                SUBSCRIPTION_ID
                ,SUBSCRIPTION_NO
                ,IAM_ACTIVE
                ,IAM_USER_NAME
                ,IAM_NAME
                ,IAM_SURNAME
                ,IAM_PASSWORD
                ,IAM_EMAIL_FIRST
                ,IAM_EMAİL_SECOND
                ,IAM_MOBILE_CODE
                ,IAM_MOBILE_NUMBER
                ,IAM_USER_COMPANY_NAME
                ,COMPANY_PARTNER_ID
                ,REFERRAL_DOMAIN
                ,RECORD_DATE
                ,RECORD_IP
                ,RECORD_EMP
                )
                VALUES
                (
                <cfif isdefined("arguments.subscription_id") and len(arguments.subscription_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.subscription_id#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.subscription_no") and len(arguments.subscription_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.subscription_no#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.iam_active") and len(arguments.iam_active)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.iam_active#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.username") and len(arguments.username)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.member_name") and len(arguments.member_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_name#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.member_sname") and len(arguments.member_sname)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_sname#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.password") and len(arguments.password)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.pr_mail") and len(arguments.pr_mail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pr_mail#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.sec_mail") and len(arguments.sec_mail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sec_mail#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.mobile_code") and len(arguments.mobile_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobile_code#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.mobile_no") and len(arguments.mobile_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobile_no#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.user_comp_name") and len(arguments.user_comp_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.user_comp_name#"><cfelse>NULL</cfif>,
                <cfif isdefined("get_partner.PARTNER_ID") and len(get_partner.PARTNER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_partner.PARTNER_ID#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.domain") and len(arguments.domain)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domain#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                <cfif IsDefined("session.ep.userid")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"><cfelse>NULL</cfif>
                )
            </cfquery>
            <cfquery name="GET_MAX" datasource="#dsn#" maxrows="1">
                SELECT * FROM SUBSCRIPTION_IAM   
                ORDER BY 
                    IAM_ID DESC
            </cfquery>
             <cfset responseStruct.message = "İşlem Başarılı">
             <cfset responseStruct.status = true>
             <cfset responseStruct.error = {}>
             <cfset responseStruct.identity = GET_MAX.IAM_ID>
             <cfcatch>
                 <cftransaction action="rollback">
                 <cfset responseStruct.message = "İşlem Hatalı">
                 <cfset responseStruct.status = false>
                 <cfset responseStruct.error = cfcatch>
             </cfcatch>
         </cftry>
     <cfreturn responseStruct>
    </cffunction>
    <cffunction  name="UPD_IAM"  access="public" returntype="any">
        <cfargument name="comp_id" type="any" required="false" default="" hint="Iam User Company Id">
        <cfargument name="company_id" type="any" required="false" default="" hint="System Company Id">
        <cfargument name="subscription_id" type="any" required="false" default="" hint="Iam User Subscription Id">
        <cfargument name="subscription_no" type="any" required="false" default="" hint="Iam User Subscription No">
        <cfargument name="iam_active" type="any" required="false" default="" hint="Iam User Is Active">
        <cfargument name="username" type="any" required="false" default="" hint="Iam User Username">
        <cfargument name="member_name" type="any" required="false" default="" hint="Iam User Member Name">
        <cfargument name="member_sname" type="any" required="false" default="" hint="Iam User Member Surname">
        <cfargument name="password" type="any" required="false" default="" hint="Iam User Password">
        <cfargument name="pr_mail" type="any" required="false" default="" hint="Iam User First Email">
        <cfargument name="sec_mail" type="any" required="false" default="" hint="Iam User Second Email">
        <cfargument name="mobile_code" type="any" required="false" default="" hint="Iam User Mobil Phone Code">
        <cfargument name="mobile_no" type="any" required="false" default="" hint="Iam User Mobil Phone">
        <cfargument name="user_comp_name" type="any" required="false" default="" hint="Iam User Company Name">
        <cfargument name="domain" type="any" required="false" default="" hint="Iam User Site Domain">
        <cfargument name="is_employee_record" type="any" required="false" default="0" hint="Iam User Site Domain">
        <cfargument name="comp_id_" type="any" required="false" default="" hint="Iam User Company Id">
        <cfargument name="company_id_" type="any" required="false" default="" hint="System Company Id">
        <cfargument name="subscription_id_" type="any" required="false" default="" hint="Iam User Subscription Id">
        <cfargument name="subscription_no_" type="any" required="false" default="" hint="Iam User Subscription No">
        <cfargument name="user_comp_name_" type="any" required="false" default="" hint="Iam User Company Name">

        <cfargument name="domain_" type="any" required="false" default="" hint="Iam User Site Domain">
        <cfif arguments.is_employee_record eq 1>
            <cfset arguments.comp_id = arguments.comp_id_>
            <cfset arguments.company_id = arguments.company_id_>
            <cfset arguments.subscription_id = arguments.subscription_id_>
            <cfset arguments.subscription_no = arguments.subscription_no_>
            <cfset arguments.user_comp_name = arguments.user_comp_name_>
            <cfset arguments.domain = arguments.domain_>
        </cfif>


        <cfset responseStruct = structNew()>
        <cftry>
            <cfquery name="get_partner" datasource="#dsn#">
                SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE COMPANY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.comp_id#">
            </cfquery>

            <cfif IsDefined("arguments.company_id") and len(arguments.company_id) and arguments.is_employee_record neq 1>
                <cfquery name="get_subscription" datasource="#dsn#_#arguments.company_id#">
                    SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.subscription_no#">
                </cfquery>
                <cfif get_subscription.recordcount><cfset arguments.subscription_id = get_subscription.SUBSCRIPTION_ID /></cfif>
            </cfif>

            <!--- Çalışan eklemeden geliyorsa --->
            <cfif IsDefined("arguments.company_id_") and len(arguments.company_id_) and arguments.is_employee_record eq 1>
                <cfquery name="get_subscription" datasource="#dsn#_22">
                    SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.subscription_no_#">
                </cfquery>
                <cfif get_subscription.recordcount>
                    <cfset arguments.subscription_id = get_subscription.SUBSCRIPTION_ID />
                <cfelse>
                    <cfquery name="get_subscription_" datasource="#dsn#_5">
                        SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.subscription_no_#">
                    </cfquery>
                    <cfif get_subscription_.recordcount>
                        <cfset arguments.subscription_id = get_subscription_.SUBSCRIPTION_ID />
                    <cfelse>
                        <cfset arguments.subscription_id = ""/>
                    </cfif>
                </cfif>
            </cfif>

            <cfquery name="UPD_IAM" datasource="#dsn#" result="result">
                UPDATE 
                    SUBSCRIPTION_IAM
                SET 
                    SUBSCRIPTION_ID=<cfif isdefined("arguments.subscription_id") and len(arguments.subscription_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.subscription_id#"><cfelse>NULL</cfif>
                    ,SUBSCRIPTION_NO=<cfif isdefined("arguments.subscription_no") and len(arguments.subscription_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.subscription_no#"><cfelse>NULL</cfif>
                    ,IAM_ACTIVE=<cfif isdefined("arguments.iam_active") and len(arguments.iam_active)>1<cfelse>0</cfif>
                    ,IAM_USER_NAME=<cfif isdefined("arguments.username") and len(arguments.username)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#"><cfelse>NULL</cfif>
                    ,IAM_NAME=<cfif isdefined("arguments.member_name") and len(arguments.member_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_name#"><cfelse>NULL</cfif>
                    ,IAM_SURNAME=<cfif isdefined("arguments.member_sname") and len(arguments.member_sname)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_sname#"><cfelse>NULL</cfif>
                    ,IAM_PASSWORD=<cfif isdefined("arguments.password") and len(arguments.password)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#"><cfelse>NULL</cfif>
                    ,IAM_EMAIL_FIRST=<cfif isdefined("arguments.pr_mail") and len(arguments.pr_mail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pr_mail#"><cfelse>NULL</cfif>
                    ,IAM_EMAİL_SECOND=<cfif isdefined("arguments.sec_mail") and len(arguments.sec_mail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sec_mail#"><cfelse>NULL</cfif>
                    ,IAM_MOBILE_CODE=<cfif isdefined("arguments.mobile_code") and len(arguments.mobile_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobile_code#"><cfelse>NULL</cfif>
                    ,IAM_MOBILE_NUMBER=<cfif isdefined("arguments.mobile_no") and len(arguments.mobile_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobile_no#"><cfelse>NULL</cfif>
                    ,IAM_USER_COMPANY_NAME=<cfif isdefined("arguments.user_comp_name") and len(arguments.user_comp_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.user_comp_name#"><cfelse>NULL</cfif>
                    ,COMPANY_PARTNER_ID=<cfif isdefined("get_partner.PARTNER_ID") and len(get_partner.PARTNER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_partner.PARTNER_ID#"><cfelse>NULL</cfif>
                    ,REFERRAL_DOMAIN=<cfif isdefined("arguments.domain") and len(arguments.domain)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domain#"><cfelse>NULL</cfif>
                    ,UPDATE_DATE=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    ,UPDATE_EMP=<cfif IsDefined("session.ep.userid")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"><cfelse>NULL</cfif>
                    ,UPDATE_IP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                WHERE 
                    IAM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.iam_id#">
            </cfquery>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = arguments.iam_id>
            <cfcatch>
                <cftransaction action="rollback">
                <cfset responseStruct.message = "İşlem Hatalı">
                <cfset responseStruct.status = false>
                <cfset responseStruct.error = cfcatch>
            </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>

    <cffunction  name="select"  access = "public">
        <cfargument name="iam_id" type="numeric" required="true" default="" hint="Iam user Id">
        <cfquery name="get_iam"  datasource="#DSN#">
            SELECT 
            S.IAM_ID
            ,S.SUBSCRIPTION_ID
            ,S.SUBSCRIPTION_NO
            ,S.IAM_ACTIVE
            ,S.IAM_USER_NAME
            ,S.IAM_NAME
            ,S.IAM_SURNAME
            ,S.IAM_PASSWORD
            ,S.IAM_EMAIL_FIRST
            ,S.IAM_EMAİL_SECOND
            ,S.IAM_MOBILE_CODE
            ,S.IAM_MOBILE_NUMBER
            ,S.IAM_USER_COMPANY_NAME
            ,S.COMPANY_PARTNER_ID
            ,S.REFERRAL_DOMAIN
            ,S.RECORD_DATE
            ,S.RECORD_IP
            ,S.RECORD_EMP
            ,S.UPDATE_DATE
            ,S.UPDATE_IP
            ,S.UPDATE_EMP
            ,C.FULLNAME
            ,C.COMPANY_ID
            FROM 
            SUBSCRIPTION_IAM S
            LEFT JOIN COMPANY_PARTNER CP ON CP.PARTNER_ID=S.COMPANY_PARTNER_ID
            LEFT JOIN COMPANY C ON C.COMPANY_ID=CP.COMPANY_ID
        WHERE 
            IAM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.iam_id#">
        </cfquery>
        <cfreturn get_iam>
    </cffunction>
    <cffunction  name="get" access="public">
        <cfargument  name="iam_id" default="">
         <cfreturn select(iam_id=arguments.iam_id)> 
    </cffunction> 
    <cffunction name="list_iam" access="public" returntype="query">
        <cfargument name="subscription_no" type="any" required="false" default="" hint="Iam User Subscription No">
        <cfargument name="user_comp_name" type="any" required="false" default="" hint="Iam User Company Name">
        <cfargument name="domain" type="any" required="false" default="" hint="Iam User Site Domain">
        <cfargument name="username" type="any" required="false" default="" hint="Iam User Username">
        <cfargument name="password" type="any" required="false" default="" hint="Iam User Password">
        <cfargument name="name_sname" type="any" required="false" default="" hint="Iam User Name">
        <cfargument name="mobile" type="any" required="false" default="" hint="Iam User Mobile Phone">
        <cfargument name="mail" type="any" required="false" default="" hint="Iam User Mail">
        <cfargument name="status" type="any" required="false" default="" hint="Iam User Status">
        <cfargument name="subscription_id" type="any" required="false" default="" hint="Iam User Subscription ID">
        <cfargument name="startdate" type="any" required="false" default="" hint="Iam User startdate">
        <cfargument name="finishdate" type="any" required="false" default="" hint="Iam User Sfinishdate">
        <cfquery name="list_iam" datasource="#dsn#">
            SELECT
                *
            FROM
                SUBSCRIPTION_IAM
            WHERE 
                1=1
                <cfif isDefined("arguments.status") and len(arguments.status)>
                   AND IAM_ACTIVE= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.status#">
                </cfif>     
                <cfif isDefined("arguments.subscription_no") and len(arguments.subscription_no) and isDefined("arguments.SUBSCRIPTION_ID") and len(arguments.SUBSCRIPTION_ID)>
                   AND SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SUBSCRIPTION_ID#">
                </cfif>
                <cfif isDefined("arguments.user_comp_name") and len(arguments.user_comp_name)>
                    AND IAM_USER_COMPANY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.user_comp_name#%">
                </cfif>
                <cfif isDefined("arguments.domain") and len(arguments.domain)>
                    AND REFERRAL_DOMAIN LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.domain#%">
                </cfif>
                <cfif isDefined("arguments.username") and len(arguments.username)>
                    AND IAM_USER_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.username#%">
                </cfif>
                <cfif isDefined("arguments.password") and len(arguments.password)>
                    AND IAM_PASSWORD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.password#%">
                </cfif>
                <cfif isDefined("arguments.name_sname") and len(arguments.name_sname)>
                    AND IAM_NAME + ' ' + IAM_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#name_sname#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
                </cfif>
                <cfif isDefined("arguments.mobile") and len(arguments.mobile)>
                    AND IAM_MOBILE_CODE + IAM_MOBILE_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#mobile#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
                </cfif>
                <cfif isDefined("arguments.mail") and len(arguments.mail)>
                    AND IAM_EMAIL_FIRST LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#mail#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
                    OR IAM_EMAİL_SECOND LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#mail#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
                </cfif>
                <cfif len(arguments.STARTDATE) AND len(arguments.FINISHDATE)>
                    <!--- IKI TARIH DE VAR --->
                    AND
                    (
                        RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.STARTDATE#"> AND
                        RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,arguments.FINISHDATE)#">
                    )
                <cfelseif len(arguments.STARTDATE)>
                    <!--- SADECE BAŞLANGIÇ --->
                    AND
                    (
                        RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.STARTDATE#">
                    )
                <cfelseif len(arguments.FINISHDATE)>
                    <!--- SADECE BITIŞ --->
                    AND RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,arguments.FINISHDATE)#">
                </cfif>
            ORDER BY
                RECORD_DATE	DESC
        </cfquery>
        <cfreturn list_iam>
    </cffunction>
    <cffunction  name="ADD_IAM_REMOTE"  access="public" returntype="any">
        <cfargument name="comp_id_" type="any" required="false" default="" hint="Iam User Company Id">
        <cfargument name="company_id_" type="any" required="false" default="" hint="System Company Id">
        <cfargument name="subscription_id_" type="any" required="false" default="" hint="Iam User Subscription Id">
        <cfargument name="subscription_no_" type="any" required="false" default="" hint="Iam User Subscription No">
        <cfargument name="user_comp_name_" type="any" required="false" default="" hint="Iam User Company Name">
        <cfargument name="domain_" type="any" required="false" default="" hint="Iam User Site Domain">

        <cfargument name="iam_active" type="any" required="false" default="" hint="Iam User Is Active">
        <cfargument name="username" type="any" required="false" default="" hint="Iam User Username">
        <cfargument name="member_name" type="any" required="false" default="" hint="Iam User Member Name">
        <cfargument name="member_sname" type="any" required="false" default="" hint="Iam User Member Surname">
        <cfargument name="password" type="any" required="false" default="" hint="Iam User Password">
        <cfargument name="pr_mail" type="any" required="false" default="" hint="Iam User First Email">
        <cfargument name="sec_mail" type="any" required="false" default="" hint="Iam User Second Email">
        <cfargument name="mobile_code" type="any" required="false" default="" hint="Iam User Mobil Phone Code">
        <cfargument name="mobile_no" type="any" required="false" default="" hint="Iam User Mobil Phone">

        <cfset responseStruct = structNew()>
        <cftry>
            <cfquery name="get_partner" datasource="#dsn#">
                SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE COMPANY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.comp_id_#">
            </cfquery>

            <cfif IsDefined("arguments.company_id_") and len(arguments.company_id_)>
                <cfquery name="get_subscription" datasource="#dsn#_22">
                    SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.subscription_no_#">
                </cfquery>
                <cfif get_subscription.recordcount>
                    <cfset arguments.subscription_id = get_subscription.SUBSCRIPTION_ID />
                <cfelse>
                    <cfquery name="get_subscription_" datasource="#dsn#_5">
                        SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.subscription_no_#">
                    </cfquery>
                    <cfif get_subscription_.recordcount>
                        <cfset arguments.subscription_id = get_subscription_.SUBSCRIPTION_ID />
                    <cfelse>
                        <cfset arguments.subscription_id = ""/>
                    </cfif>
                </cfif>
            </cfif>
            
            <cfquery name="ADD_IAM" datasource="#dsn#"  result="my_result">
                INSERT INTO SUBSCRIPTION_IAM
                (
                SUBSCRIPTION_ID
                ,SUBSCRIPTION_NO
                ,IAM_ACTIVE
                ,IAM_USER_NAME
                ,IAM_NAME
                ,IAM_SURNAME
                ,IAM_PASSWORD
                ,IAM_EMAIL_FIRST
                ,IAM_EMAİL_SECOND
                ,IAM_MOBILE_CODE
                ,IAM_MOBILE_NUMBER
                ,IAM_USER_COMPANY_NAME
                ,COMPANY_PARTNER_ID
                ,REFERRAL_DOMAIN
                ,RECORD_DATE
                ,RECORD_IP
                ,RECORD_EMP
                )
                VALUES
                (
                <cfif isdefined("arguments.subscription_id") and len(arguments.subscription_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.subscription_id#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.subscription_no_") and len(arguments.subscription_no_)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.subscription_no_#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.iam_active") and len(arguments.iam_active)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.iam_active#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.username") and len(arguments.username)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.member_name") and len(arguments.member_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_name#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.member_sname") and len(arguments.member_sname)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_sname#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.password") and len(arguments.password)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.pr_mail") and len(arguments.pr_mail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pr_mail#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.sec_mail") and len(arguments.sec_mail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sec_mail#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.mobile_code") and len(arguments.mobile_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobile_code#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.mobile_no") and len(arguments.mobile_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobile_no#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.user_comp_name_") and len(arguments.user_comp_name_)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.user_comp_name_#"><cfelse>NULL</cfif>,
                <cfif isdefined("get_partner.PARTNER_ID") and len(get_partner.PARTNER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_partner.PARTNER_ID#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.domain_") and len(arguments.domain_)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domain_#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                <cfif IsDefined("session.ep.userid")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"><cfelse>NULL</cfif>
                )
            </cfquery>
            <cfquery name="GET_MAX" datasource="#dsn#" maxrows="1">
                SELECT * FROM SUBSCRIPTION_IAM   
                ORDER BY 
                    IAM_ID DESC
            </cfquery>
             <cfset responseStruct.message = "İşlem Başarılı">
             <cfset responseStruct.status = true>
             <cfset responseStruct.error = {}>
             <cfset responseStruct.identity = GET_MAX.IAM_ID>
             <cfcatch>
                 <cftransaction action="rollback">
                 <cfset responseStruct.message = "İşlem Hatalı">
                 <cfset responseStruct.status = false>
                 <cfset responseStruct.error = cfcatch>
             </cfcatch>
         </cftry>
     <cfreturn responseStruct>
    </cffunction>
    <cffunction  name="GET_IAM_REMOTE"  access="public" returntype="any">
        <cfargument name="username" type="any" required="false" default="" hint="Iam User Username">
        <cfargument name="member_name" type="any" required="false" default="" hint="Iam User Member Name">
        <cfargument name="member_sname" type="any" required="false" default="" hint="Iam User Member Surname">

        <cfquery name="GET_IAM_REMOTE"  datasource="#DSN#">
            SELECT 
                IAM_ID
            FROM 
                SUBSCRIPTION_IAM 
            WHERE
                IAM_USER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">
                AND IAM_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_name#">
                AND IAM_SURNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_sname#">
        </cfquery>
        <cfreturn GET_IAM_REMOTE>
    </cffunction>
    <cffunction  name="get_subscription"  access="public" returntype="query">
        <cfargument name="subscription_no" type="any" required="false" default="" hint="Iam User Subscription No">
        <cfquery name="get_subscription" datasource="#dsn#_5">
            SELECT SUBSCRIPTION_ID FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.subscription_no#">
        </cfquery>
        <cfreturn get_subscription>
    </cffunction>
</cfcomponent>


