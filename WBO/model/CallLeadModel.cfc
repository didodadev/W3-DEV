<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Semih Bozal		
Analys Date : 01/04/2016			Dev Date	: 17/05/2016		
Description :
	Bu component etkileşimler objesine ait CRUD ve list fonksiyonlarını gerceklestirir.
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = '#dsn#_product'>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>
    <cfinclude template="../fbx_workcube_funcs.cfm">
    
    <!--- list --->
    <cffunction name="list" access="remote" returntype="string" returnformat="plain">
        <cfargument name="keyword" type="string" default="" required="no" hint="Keyword; konu,açıklama ve etkileşim numarasına göre arama yapar">
        <cfargument name="comp_cat" type="numeric" default="0" required="no" hint="Kurumsal üye kategorisi">
        <cfargument name="app_cat" type="numeric" default="0" required="no" hint="İletişim yöntemi">
        <cfargument name="company_id" type="numeric" default="0" required="no" hint="Kurumsal üye ID">
        <cfargument name="consumer_id" type="numeric" default="0" required="no" hint="Bireysel üye ID">
        <cfargument name="record_emp" type="numeric" default="0" required="no" hint="Etkileşimi kaydeden çalışan ID">
        <cfargument name="subscription_id" type="numeric" default="0" required="no" hint="Abone ID">
        <cfargument name="applicant_name" type="string" default="" required="no" hint="Başvuru yapan kişi">
        <cfargument name="site_domain" type="string" default="" required="no" hint="Etkileşimin kaydedildiği web site bilgisi">
        <cfargument name="interaction_cat" type="numeric" default="0" required="no" hint="Etkileşim kategorisi">
        <cfargument name="is_reply" type="any" default="" required="no" hint="1: Cevaplı , 0 : Cevapsız  ">
        <cfargument name="process_stage" type="numeric" default="0" required="no" hint="Etkileşim aşaması">
        <cfargument name="start_date" type="string" default="" required="no" hint="Gönderilen tarihten sonraki etkileşimleri getirir">
        <cfargument name="finish_date" type="string" default="" required="no" hint="Gönderilen tarihten önceki etkileşimleri getirir">
        <cfargument name="special_definition" type="numeric" default="0" required="no" hint="Etkileşim özel tanımı">
        <cfargument name="call_center_stage_list" type="string" default="" required="no" hint="Yetkili olduğum etkileşim aşamaları">
        <cfargument name="subscriber_stage" type="numeric" default="0" required="no" hint="Etkileşimde seçilen abone aşaması">
        <cfargument name="project_id" type="numeric" default="0" required="no" hint="Etkileşim proje ID">
        <cfargument name="sortField" type="string" default="CUS_HELP_ID" required="no" hint="Sıralama Kolonu">
        <cfargument name="sortType" type="string" default="DESC" required="no" hint="Sıralama Türü">
        <cfargument name="maxrows" type="numeric" default="0" required="no" hint="Sayfalama : Sayfa başına satır sayısı">
        <cfargument name="pagenum" type="numeric" default="0" required="no" hint="Sayfalama : Sayfa no">
        <cfif session.ep.our_company_info.sales_zone_followup eq 1>
            <cfinclude template="../member/query/get_ims_control.cfm">
        </cfif>
        <cfif len(arguments.start_date)>
            <cf_date tarih = "arguments.start_date">
        </cfif>
        <cfif len(arguments.finish_date)>
            <cf_date tarih = "arguments.finish_date">
        </cfif>
		<cfquery name="GET_HELP" datasource="#DSN#">
        	WITH CTE1 AS (
                SELECT               
                    C.CUS_HELP_ID,
                    C.COMPANY_ID,
                    C.PARTNER_ID,
                    C.CONSUMER_ID,
                    C.PROCESS_STAGE,
                    C.SUBJECT,
                    C.SUBSCRIPTION_ID,
                    C.APPLICANT_NAME,
                    C.APP_CAT,
                    C.IS_REPLY,
                    C.IS_REPLY_MAIL,
                    C.OUR_COMPANY_ID,
                    C.SITE_DOMAIN,
                    C.INTERACTION_CAT,
                    C.RECORD_EMP,
                    C.RECORD_DATE,
                    C.UPDATE_EMP,
                    C.DETAIL,
                    RECEIVED_DURATION DURATION,
                    C.INTERACTION_DATE,
                    EMPLOYEES.EMPLOYEE_NAME+' '+EMPLOYEES.EMPLOYEE_SURNAME EMP_NAME ,
                    CASE WHEN C.PARTNER_ID IS NOT NULL THEN COMP.NICKNAME + ' - ' + CP.COMPANY_PARTNER_NAME +' '+ CP.COMPANY_PARTNER_SURNAME ELSE CONS.CONSUMER_NAME +' '+ CONS.CONSUMER_SURNAME END AS FULLNAME,
                    PTR.STAGE,
                    SC.COMMETHOD,
                    <cfif session.ep.our_company_info.subscription_contract eq 1>
                        S_CONTRACT.SUBSCRIPTION_NO,
                    </cfif>
                    SIC.INTERACTIONCAT,
                    ROW_NUMBER() OVER (
                    	<cfif len(sortField) and len(sortType)>
	                    	ORDER BY #arguments.sortField# #arguments.sortType#
                        <cfelse>
                        	ORDER BY (SELECT 0)
                        </cfif>
                    ) AS ROWNUM
                    <cf_extendedFields type="1" controllerFileName="callLeadController" selectClause="1" mainTableAlias="C">
               FROM
                    CUSTOMER_HELP C
                    LEFT JOIN COMPANY_PARTNER CP ON CP.PARTNER_ID = C.PARTNER_ID
                    LEFT JOIN COMPANY COMP ON COMP.COMPANY_ID = CP.COMPANY_ID AND COMP.COMPANY_ID = C.COMPANY_ID
                    LEFT JOIN CONSUMER CONS ON CONS.CONSUMER_ID = C.CONSUMER_ID
                    LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = C.PROCESS_STAGE
                    LEFT JOIN SETUP_COMMETHOD SC ON SC.COMMETHOD_ID = C.APP_CAT
                    LEFT JOIN SETUP_INTERACTION_CAT SIC ON SIC.INTERACTIONCAT_ID = C.INTERACTION_CAT
                    <cfif session.ep.our_company_info.subscription_contract eq 1>
                        LEFT JOIN #dsn3#.SUBSCRIPTION_CONTRACT S_CONTRACT ON S_CONTRACT.SUBSCRIPTION_ID = C.SUBSCRIPTION_ID
                    </cfif>
                    LEFT JOIN EMPLOYEES ON C.UPDATE_EMP = EMPLOYEES.EMPLOYEE_ID
                    <cfif arguments.comp_cat neq 0>
                        ,COMPANY
                    </cfif>
                WHERE
                    1 = 1 AND
                    <cfif arguments.comp_cat neq 0>
                        COMPANY.COMPANY_ID = C.COMPANY_ID AND
                    </cfif>
                    (
                        C.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> OR
                        C.OUR_COMPANY_ID IS NULL
                    )
                    <cfif len(arguments.keyword)>
                        AND 
                        (
                            C.SUBJECT LIKE #sql_unicode()#'%#arguments.keyword#%'
                            OR C.DETAIL LIKE '%#arguments.keyword#%'
                            <cfif IsNumeric(arguments.keyword) and arguments.keyword lte 1000000000000>
                                OR C.CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.keyword#">
                            </cfif>
                        )
                    </cfif>
                    <cfif arguments.app_cat neq 0>
                        AND C.APP_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.app_cat#">
                    </cfif>
                    <cfif arguments.company_id neq 0>
                        AND C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer"  value="#arguments.company_id#">
                    <cfelseif arguments.consumer_id neq 0>
                        AND C.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
                    </cfif>
                    <cfif arguments.record_emp neq 0>
                        AND C.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.record_emp#">
                    </cfif>
                    <cfif arguments.subscription_id neq 0>
                        AND C.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.subscription_id#">
                    </cfif>
                    <cfif len(arguments.applicant_name)>
                        AND C.APPLICANT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.applicant_name#%">
                    </cfif>
                    <cfif len(arguments.site_domain)>
                        AND C.SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.site_domain#"> 
                    </cfif>
                    <cfif arguments.interaction_cat neq 0>
                        AND C.INTERACTION_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.interaction_cat#"> 
                    </cfif>
                    <cfif arguments.comp_cat neq 0>
                        AND COMPANY.COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.comp_cat#"> 
                    </cfif>
                    <cfif arguments.is_reply eq 2>
                        AND	C.IS_REPLY_MAIL  IN (0,1)		  
                    </cfif>
                    <cfif arguments.is_reply eq 0>
                        AND	C.IS_REPLY_MAIL  = 0		  
                    </cfif>
                    <cfif arguments.is_reply eq 1>
                        AND	C.IS_REPLY_MAIL  = 1		  
                    </cfif>
                    <cfif arguments.process_stage neq 0>
                        AND C.PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"> 
                    </cfif>
                    <cfif len(arguments.start_date)>
                        AND C.INTERACTION_DATE >= #arguments.start_date#
                    </cfif>
                    <cfif len(arguments.finish_date)>
                        AND C.INTERACTION_DATE <= #arguments.finish_date#
                    </cfif>
                    <cfif arguments.special_definition neq 0>
                        AND C.SPECIAL_DEFINITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.special_definition#">
                    </cfif>
                    <cfif session.ep.our_company_info.sales_zone_followup eq 1>
                        AND
                            (
                            (C.CONSUMER_ID IS NULL AND C.COMPANY_ID IS NULL ) 
                            OR ( C.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#) )
                            OR ( C.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#) )
                            )
                    </cfif>
                    <cfif len(arguments.call_center_stage_list)>
                        AND C.PROCESS_STAGE IN (#arguments.call_center_stage_list#)
                    </cfif>
                    <cfif arguments.subscriber_stage>
                        AND C.SUBSCRIPTION_ID IN (SELECT SC.SUBSCRIPTION_ID FROM #dsn3#.SUBSCRIPTION_CONTRACT SC, PROCESS_TYPE_ROWS PTR WHERE PTR.PROCESS_ROW_ID = SC.SUBSCRIPTION_STAGE AND PTR.PROCESS_ROW_ID = #arguments.subscriber_stage#)
                    </cfif>
                    <cfif arguments.project_id neq 0>
                        AND C.SUBSCRIPTION_ID IN (SELECT SC.SUBSCRIPTION_ID FROM #dsn3#.SUBSCRIPTION_CONTRACT SC WHERE SC.PROJECT_ID = #arguments.project_id#)
                    </cfif>
                    <cf_extendedFields type="1" controllerFileName="callLeadController" whereClause="1" mainTableAlias="C">
            )
            SELECT
            	*,
                (SELECT COUNT(*) FROM CTE1) AS TOTALROWS
            FROM
            	CTE1
            WHERE
            	1 = 1
			<cfif maxrows gt 0>
                AND ROWNUM BETWEEN #pagenum * maxrows + 1# AND #(pagenum + 1) * maxrows#
            </cfif>
            ORDER BY
            	ROWNUM
        </cfquery>
		<cfreturn SerializeJQXFormat(GET_HELP)>
	</cffunction>
    
	<!--- get --->
    <cffunction name="get" access="public" returntype="query">
		<cfargument name="cus_help_id" type="numeric" default="0" required="yes" hint="Etkileşim ID">
        
		<cfquery name="GET_HELP" datasource="#DSN#">
            SELECT
                CH.DETAIL,
                CH.CUS_HELP_ID,
                CH.COMPANY_ID,
                CH.PARTNER_ID,
                CH.CONSUMER_ID,
                CH.SUBJECT,
                CH.APP_CAT,
                CH.PROCESS_STAGE,
                CH.SOLUTION_DETAIL,
                CH.APPLICANT_NAME,
                CH.APPLICANT_MAIL,
                CH.MAIL_RECORD_DATE,
                CH.MAIL_RECORD_EMP,
                CH.RECORD_EMP,
                CH.RECORD_PAR,
                CH.RECORD_CONS,
                CH.RECORD_APP,
                CH.GUEST,
                CH.RECORD_DATE,
                CH.UPDATE_DATE,
                CH.UPDATE_EMP,
                CH.IS_REPLY,
                CH.IS_REPLY_MAIL,
                CH.SUBSCRIPTION_ID,
                CH.INTERACTION_CAT,
                CH.INTERACTION_DATE,
                CH.CUSTOMER_TELCODE,
                CH.CUSTOMER_TELNO,
                CH.CAMP_ID,
                CH.PRODUCT_ID,
                CH.SPECIAL_DEFINITION_ID,
                P.PRODUCT_NAME,
                C.CAMP_HEAD,
                SC.SUBSCRIPTION_NO,
                CP.COMPANY_PARTNER_NAME +' '+ CP.COMPANY_PARTNER_SURNAME AS PARTNER_NAME,
                COMP.NICKNAME,
                CONS.CONSUMER_NAME +' '+ CONS.CONSUMER_SURNAME AS CONS_NAME
            FROM
                CUSTOMER_HELP CH
                LEFT JOIN COMPANY_PARTNER CP ON CP.PARTNER_ID = CH.PARTNER_ID
                LEFT JOIN COMPANY COMP ON COMP.COMPANY_ID = CP.COMPANY_ID AND COMP.COMPANY_ID = CH.COMPANY_ID
                LEFT JOIN CONSUMER CONS ON CONS.CONSUMER_ID = CH.CONSUMER_ID
                LEFT JOIN #dsn1#.PRODUCT AS P ON P.PRODUCT_ID = CH.PRODUCT_ID
                LEFT JOIN #dsn3#.CAMPAIGNS C ON C.CAMP_ID = CH.CAMP_ID
                LEFT JOIN #dsn3#.SUBSCRIPTION_CONTRACT SC ON SC.SUBSCRIPTION_ID = CH.SUBSCRIPTION_ID
            WHERE
                CH.CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cus_help_id#">
        </cfquery>

		<cfreturn GET_HELP>
	</cffunction>
    
    <!--- add --->
    <cffunction name="add" access="public" returntype="string">
		<cfargument name="camp_id" type="numeric" default="0" required="yes" hint="Kampanya Id">
        <cfargument name="isEmail" type="boolean" default="0" required="yes" hint="Email gönder">
        <cfargument name="partner_id" type="numeric" default="0"  required="no" hint="Kurumsal üye çalışan Id">
		<cfargument name="company_id" type="numeric" default="0" required="no" hint="Kurumsal Üye Id">
        <cfargument name="consumer_id" type="numeric" default="0" required="no" hint="Bireysel üye Id">
        <cfargument name="workcube_id" type="string" default="NULL" required="no" hint="Workcube Id">
		<cfargument name="product_id" type="numeric" default="0" required="no" hint="Ürün Id">
        <cfargument name="company" type="string" required="no" hint="Üye adı">
        <cfargument name="app_cat" type="numeric" default="0" required="yes" hint="İletişim yöntemi Id">
        <cfargument name="interaction_cat" type="numeric" default="0" required="no" hint="Etkileşim kategori Id">
        <cfargument name="action_date" type="string" default="" required="yes" hint="Etkileşim tarihi">
        <cfargument name="subject" type="string" default="" required="yes" hint="Konu">
        <cfargument name="process_stage" type="numeric" default="0" required="yes" hint="Etkileşim aşama Id">
        <cfargument name="detail" type="string" default="" required="no" hint="Açıklama">
        <cfargument name="applicant_name" type="string" default="" required="yes" hint="Başvuru yapan kişi">
        <cfargument name="applicant_mail" type="string" default="" required="yes" hint="Başvuru yapan kişinin Email bilgisi">
        <cfargument name="subscription_id" type="numeric" default="0" required="no" hint="Abone Id">
        <cfargument name="tel_code" type="string" default="" required="no" hint="Başvuru yapan kişinin telefon kodu">
        <cfargument name="tel_no" type="string" default="" required="no" hint="Başvuru yapan kişinin telefon numarası">
        <cfargument name="special_definition" type="numeric" default="0" required="no" hint="Etkileşim özel tanım Id">
        
        <cfquery name="ADD_HELP" datasource="#DSN#" result="MAX_ID">
            INSERT INTO
                CUSTOMER_HELP
            (
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
                SUBSCRIPTION_ID,  
                CUSTOMER_TELCODE,
                CUSTOMER_TELNO,
                SPECIAL_DEFINITION_ID,
                <cfif arguments.isEmail eq 1>
                    MAIL_RECORD_DATE,
                    MAIL_RECORD_EMP,
                </cfif>
                CAMP_ID,
                RECEIVED_DURATION,
                RECORD_EMP,
                RECORD_DATE,
                RECORD_IP
            )
            VALUES
            (
                <cfif arguments.partner_id neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#"><cfelse>NULL</cfif>,
                <cfif arguments.company_id neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"><cfelse>NULL</cfif>,
                <cfif arguments.consumer_id neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.workcube_id#" null="yes">,
                <cfif arguments.product_id neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"><cfelse>NULL</cfif>,
                <cfif len(arguments.company)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.app_cat#">,
                <cfif arguments.interaction_cat neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.interaction_cat#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.action_date#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.subject#">, 
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.applicant_name#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.applicant_mail#">,
                #arguments.isEmail#,
                0,
                <cfif arguments.subscription_id neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.subscription_id#"><cfelse>NULL</cfif>,
                <cfif len(arguments.tel_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tel_code#">,<cfelse>NULL,</cfif>
                <cfif len(arguments.tel_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tel_no#">,<cfelse>NULL,</cfif>
                <cfif arguments.special_definition neq 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.special_definition#"><cfelse>NULL</cfif>,
                <cfif arguments.isEmail eq 1>
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                </cfif>
                <cfif arguments.camp_id neq 0>#arguments.camp_id#<cfelse> NULL</cfif>,
                #arguments.isEmail#,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
             )
        </cfquery>
        
		<cfreturn MAX_ID.IDENTITYCOL>
	</cffunction>
    
    <!--- upd --->
    <cffunction name="upd" access="public" returntype="string">
		<cfargument name="help_id" type="numeric" default="0" required="yes" hint="Etkileşim Id">
        <cfargument name="camp_id" type="numeric" default="0" required="yes" hint="Kampanya Id">
        <cfargument name="isEmail" type="boolean" default="0" required="yes" hint="Email gönder">
        <cfargument name="partner_id" type="numeric" default="0"  required="no" hint="Kurumsal üye çalışan Id">
		<cfargument name="company_id" type="numeric" default="0" required="no" hint="Kurumsal Üye Id">
        <cfargument name="consumer_id" type="numeric" default="0" required="no" hint="Bireysel üye Id">
		<cfargument name="product_id" type="numeric" default="0" required="no" hint="Ürün Id">
        <cfargument name="app_cat" type="numeric" default="0" required="yes" hint="İletişim yöntemi Id">
        <cfargument name="interaction_cat" type="numeric" default="0" required="no" hint="Etkileşim kategori Id">
        <cfargument name="action_date" type="string" default="" required="yes" hint="Etkileşim tarihi">
        <cfargument name="subject" type="string" default="" required="yes" hint="Konu">
        <cfargument name="process_stage" type="numeric" default="0" required="yes" hint="Etkileşim aşama Id">
        <cfargument name="detail" type="string" default="" required="no" hint="Açıklama">
        <cfargument name="content" type="string" default="" required="no" hint="Etkileşime verilen cevap">
        <cfargument name="applicant_name" type="string" default="" required="yes" hint="Başvuru yapan kişi">
        <cfargument name="applicant_mail" type="string" default="" required="yes" hint="Başvuru yapan kişinin Email bilgisi">
        <cfargument name="subscription_id" type="numeric" default="0" required="no" hint="Abone Id">
        <cfargument name="tel_code" type="string" default="" required="no" hint="Başvuru yapan kişinin telefon kodu">
        <cfargument name="tel_no" type="string" default="" required="no" hint="Başvuru yapan kişinin telefon numarası">
        <cfargument name="special_definition" type="numeric" default="0" required="no" hint="Etkileşim özel tanım Id">
        
		<cfif arguments.isEmail eq 1>
            <cfquery name="GET_MAIL_RECORD_INFO" datasource="#DSN#">
                SELECT MAIL_RECORD_DATE, MAIL_RECORD_EMP,RECORD_DATE,IS_REPLY_MAIL,RECEIVED_DURATION FROM CUSTOMER_HELP WHERE CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.help_id#">
            </cfquery>
        
            <cfif get_mail_record_info.is_reply_mail  eq 0>
                <cfset duration=datediff('n',get_mail_record_info.record_date,now())>
            <cfelseif len(get_mail_record_info.received_duration)>
                <cfset duration=get_mail_record_info.received_duration>
            <cfelse>
                <cfset duration=0>
            </cfif>
        </cfif>
        
        <cfquery name="UPD_CUSTOMER_HELP" datasource="#DSN#">
            UPDATE
                CUSTOMER_HELP
            SET
                PARTNER_ID = <cfif arguments.partner_id neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#"><cfelse>NULL</cfif>,
                COMPANY_ID = <cfif arguments.company_id neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"><cfelse>NULL</cfif>,
                CONSUMER_ID = <cfif arguments.consumer_id neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#"><cfelse>NULL</cfif>,
                PRODUCT_ID = <cfif arguments.product_id neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"><cfelse>NULL</cfif>,
                SUBSCRIPTION_ID = <cfif arguments.subscription_id neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.subscription_id#"><cfelse>NULL</cfif>,
                APP_CAT = #arguments.app_cat#,
                INTERACTION_CAT = <cfif arguments.interaction_cat neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.interaction_cat#"><cfelse>NULL</cfif>,
                INTERACTION_DATE = #arguments.action_date#,
                APPLICANT_MAIL = '#arguments.applicant_mail#',
                APPLICANT_NAME = '#arguments.applicant_name#',
                PROCESS_STAGE = #arguments.process_stage#,
                SOLUTION_DETAIL = '#arguments.content#',
                DETAIL = '#arguments.detail#',
                SUBJECT = '#arguments.subject#',
                <cfif arguments.isEmail eq 1>
                    IS_REPLY_MAIL = 1,
                    IS_REPLY = 0,
                <cfelseif len(arguments.content)>
                    IS_REPLY =1,
                </cfif>
                CUSTOMER_TELCODE = <cfif len(arguments.tel_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tel_code#">,<cfelse>NULL,</cfif>
                CUSTOMER_TELNO = <cfif len(arguments.tel_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tel_no#">,<cfelse>NULL,</cfif>
                SPECIAL_DEFINITION_ID = <cfif arguments.special_definition neq 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.special_definition#"><cfelse>NULL</cfif>,
                <cfif arguments.isEmail eq 1 and not len(get_mail_record_info.MAIL_RECORD_DATE)>MAIL_RECORD_DATE = #now()#,</cfif>
                <cfif arguments.isEmail eq 1 and not len(get_mail_record_info.MAIL_RECORD_EMP)>MAIL_RECORD_EMP = #session.ep.userid#,</cfif>
                CAMP_ID = <cfif arguments.camp_id neq 0>#arguments.camp_id#<cfelse> NULL</cfif>,
                RECEIVED_DURATION= <cfif isdefined("duration")>#duration#<cfelse>NULL</cfif>,
                UPDATE_DATE = #now()#,
                UPDATE_IP = '#cgi.remote_addr#',
                UPDATE_EMP = #session.ep.userid#
            WHERE
                CUS_HELP_ID = #arguments.help_id#
        </cfquery>
        
		<cfreturn arguments.help_id>
	</cffunction>
    
    <!--- del --->
    <cffunction name="del" access="public" returntype="boolean">
		<cfargument name="help_id" type="numeric" default="0" required="yes" hint="Etkileşim Id">
        
        <cfquery name="DEL_HELP" datasource="#DSN#">
            DELETE CUSTOMER_HELP WHERE CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.help_id#">
        </cfquery>
        
        <cfquery name="GET_ASSET" datasource="#DSN#">
            SELECT ASSET_FILE_NAME,ASSETCAT_ID FROM ASSET WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.help_id#"> AND MODULE_NAME = 'call'
        </cfquery>
        
        <cfif get_asset.recordcount and Len(get_asset.assetcat_id)>
            <cfquery name="GET_ASSETCAT_PATH" datasource="#DSN#">
                SELECT ASSETCAT_PATH FROM ASSET_CAT WHERE ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_asset.assetcat_id#">
            </cfquery>
            <cfif company_asset_relation eq 1>
                <cfset assetcat_path = get_assetcat_path.assetcat_path>
            <cfelse>
                <cfif get_asset.assetcat_id gte 0>
                    <cfset assetcat_path = "asset/#get_assetcat_path.assetcat_path#">
                <cfelse>
                    <cfset assetcat_path = get_assetcat_path.assetcat_path>            
                </cfif>
            </cfif>
            <cfquery name="DEL_ASSET" datasource="#DSN#">
                DELETE ASSET WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.help_id#"> AND MODULE_NAME = 'call'
            </cfquery>
        </cfif>
        
		<cfreturn arguments.help_id>
	</cffunction>
    
    <!--- email --->
    <cffunction name="emailSend" access="public" returntype="boolean">
		<cfargument name="from_mail" type="string" default="" required="yes">
        <cfargument name="to_mail" type="string" default="" required="yes">
        <cfargument name="fail_to" type="string" default="" required="yes">
        <cfargument name="reply_to" type="string" default="" required="yes">
        <cfargument name="subject" type="string" default="" required="yes">
        <cfargument name="mailSubject" type="string" default="" required="yes">
        <cfargument name="isLogo" type="boolean" default="0" required="no">
        <cfargument name="applicant_name" type="string" default="" required="no">

		<cfmail from="#arguments.from_mail#" to="#arguments.to_mail#" failto="#arguments.fail_to#" replyto="#arguments.reply_to#" subject="#arguments.mailSubject#" type="html" charset="utf-8">
            <html>
                <head>
                <title></title>
                </head>
                <body> 
                <table border="0" align="center" style="width:500px;">
                    <cfif arguments.isLogo eq 1>
                        <tr style="height:60px;">
                            <td colspan="2"><cfinclude template="../objects/display/view_company_logo.cfm"></td>
                        </tr> 
                    </cfif>
                    <tr style="height:35px;">
                        <td colspan="2"><b><cf_get_lang no='26.Yardım Talebiniz'></b></td>
                    </tr>
                    <tr style="height:35px;">
                        <td style="vertical-align:top"><b><cf_get_lang_main no='1368.Sayın'> : </b><cfif len(arguments.applicant_name)></td>
                        <td style="width:93%"><cfoutput>#arguments.applicant_name#</cfoutput></cfif><br/><br/></td>
                    </tr>
                    <tr>
                        <td style="vertical-align:top"><b><cf_get_lang_main no='68.Konu'> : </b></td>
                        <td><cfoutput>#arguments.subject#</cfoutput><br/><br/></td>
                    </tr>
                    <tr>
                        <td colspan="2"><b><cf_get_lang_main no='330.Tarih'> : </b><cfoutput>#dateformat(now(),'dd/mm/yy')#</cfoutput><b> <cf_get_lang_main no='79.Saat'> : </b><cfoutput>#TimeFormat(date_add('h',session.ep.time_zone,now()), "HH:MM")#</cfoutput><br/></td>
                    </tr>			
                    <cfif arguments.isLogo eq 1>
                        <tr>
                            <td align="center" colspan="2">
                                <cfinclude template="../objects/display/view_company_info.cfm"><br/>
                                <a href="http://www.workcube.com"><img src="http://www.workcube.com/images/powered.gif" alt="" border="0"></a>
                            </td>
                        </tr> 
                    </cfif>
                </table>
                </body>
            </html>
        </cfmail>
        
		<cfreturn true>
	</cffunction>
    
	<!--- helpDesk --->
    <cffunction name="addHelpDesk" access="public" returntype="boolean">
		<cfargument name="modul_name" type="string" default="" required="yes">
        <cfargument name="faction" type="string" default="" required="yes">
        <cfargument name="help_head" type="string" default="" required="yes">
        <cfargument name="content" type="string" default="" required="yes">
        <cfargument name="is_internet" type="boolean" default="0" required="yes">
        <cfargument name="is_faq" type="boolean" default="0" required="yes">

		<cfquery name="ADD_HELP_DESK" datasource="#DSN#">
            INSERT INTO 
                HELP_DESK
            (
                HELP_CIRCUIT,
                HELP_FUSEACTION,
                HELP_HEAD,
                HELP_TOPIC,
                IS_INTERNET,
                IS_FAQ,
                RECORD_DATE,
                RECORD_MEMBER,
                RECORD_IP,
                RECORD_ID,
                HELP_LANGUAGE
            )
            VALUES
            (
                '#arguments.modul_name#',
                '#arguments.faction#',
                '#arguments.help_head#',
                '#arguments.content#',
                #arguments.is_internet#,
                #arguments.is_faq#,
                #now()#,
                'e',
                '#cgi.remote_addr#',
                #session.ep.userid#,
                '#session.ep.language#'
            )
        </cfquery>
        
		<cfreturn true>
	</cffunction>
</cfcomponent>