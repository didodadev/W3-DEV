<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Meltem Aşkın		
Analys Date : 01/04/2016			Dev Date	: 17/05/2016		
Description :
	Bu component ilanlar objesine ait CRUD ve list fonksiyonlarını gerceklestirir.
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset employee_domain = application.systemParam.systemParam().employee_domain>
    
    <!--- list --->
    <cffunction name="list" access="public" returntype="query">
        <cfargument name="keyword" type="string" default="" required="no" hint="Aranacak Kelime">
        <cfargument name="status" type="numeric" default="0" required="no" hint="Aktif/Pasif/Tümü">
        <cfargument name="process_stage" type="string" default="" required="no" hint="İlan Süreç Aşaması">
        <cfargument name="startdate" type="string" default="" required="no" hint="İlan Başlangıç Tarihi">
        <cfargument name="finishdate" type="string" default="" required="no" hint="İlan Bitiş Tarihi">
        <cfargument name="comp_id" type="numeric" default="0" required="no" hint="Şirket Id">
        <cfargument name="company_id" type="numeric" default="0" required="no" hint="Kurumsal Üye Id">
        <cfargument name="branch_id" type="numeric" default="0" required="no" hint="Şube Id">
        <cfargument name="department" type="numeric" default="0" required="no" hint="Departman Id">
        <cfargument name="notice_cat_id" type="numeric" default="0" required="no" hint="İlan Grubu">
        
		<cfquery name="GET_NOTICES" datasource="#dsn#">
          SELECT
                NOTICES.NOTICE_CAT_ID,
                NOTICES.NOTICE_ID,
                NOTICES.NOTICE_NO,
                NOTICES.NOTICE_HEAD,
                NOTICES.RECORD_DATE,
                NOTICES.POSITION_ID,
                NOTICES.POSITION_NAME,
                NOTICES.POSITION_CAT_ID,
                NOTICES.POSITION_CAT_NAME,
                NOTICES.RECORD_EMP,
                NOTICES.STARTDATE,
                NOTICES.FINISHDATE,
                NOTICES.COMPANY_ID,
                NOTICES.COMPANY,
                NOTICES.OUR_COMPANY_ID,
                NOTICES.STATUS,
                NOTICES.DEPARTMENT_ID,
                NOTICES.BRANCH_ID,
                NOTICES.STAGE,
                SNG.NOTICE AS NOTICE_CAT,
                SPC.POSITION_CAT,
                EP.POSITION_NAME +'-'+ EP.EMPLOYEE_NAME +' '+ EP.EMPLOYEE_SURNAME AS EMP_NAME,
                C.FULLNAME,
                OC.NICK_NAME,
                EMP.EMPLOYEE_NAME +' '+ EMP.EMPLOYEE_SURNAME AS RECORD_EMP_NAME,
                (SELECT COUNT(NOTICE_ID) FROM EMPLOYEES_APP_POS WHERE NOTICE_ID = NOTICES.NOTICE_ID) AS BASVURU_SAYISI
            FROM
                NOTICES
                LEFT JOIN SETUP_NOTICE_GROUP SNG ON SNG.NOTICE_CAT_ID = NOTICES.NOTICE_CAT_ID
                LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = NOTICES.POSITION_CAT_ID
                LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = NOTICES.POSITION_ID 
                LEFT JOIN COMPANY C ON C.COMPANY_ID = NOTICES.COMPANY_ID
                LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID = NOTICES.OUR_COMPANY_ID
                LEFT JOIN EMPLOYEES EMP ON EMP.EMPLOYEE_ID = NOTICES.RECORD_EMP
            WHERE
                NOTICES.NOTICE_ID IS NOT NULL
            <cfif arguments.status eq 1>
                AND NOTICES.STATUS = 0
            <cfelseif arguments.status eq 2>
                AND NOTICES.STATUS = 1
            </cfif> 
            <cfif len(arguments.process_stage)>
                AND NOTICES.STAGE = #arguments.process_stage#
            </cfif>
            <cfif len(arguments.keyword)>   
                AND  
                    ( 
                    NOTICES.NOTICE_HEAD LIKE '%#arguments.keyword#%'
                    OR
                    NOTICES.NOTICE_NO LIKE '%#arguments.keyword#%'
                    )
            </cfif>		
            <cfif len(arguments.STARTDATE)>
                <cfif len(arguments.STARTDATE) AND len(arguments.FINISHDATE)>
                AND
                (
                    (
                    NOTICES.STARTDATE >= #arguments.STARTDATE# AND
                    NOTICES.STARTDATE <= #arguments.FINISHDATE#
                    )
                OR
                    (
                    NOTICES.STARTDATE <= #arguments.STARTDATE# AND
                    NOTICES.FINISHDATE >= #arguments.STARTDATE#
                    )
                )
                <cfelseif len(arguments.STARTDATE)>
                AND
                (
                NOTICES.STARTDATE >= #arguments.STARTDATE#
                OR
                    (
                    NOTICES.STARTDATE < #arguments.STARTDATE# AND
                    NOTICES.FINISHDATE >= #arguments.STARTDATE#
                    )
                )
                <cfelseif len(arguments.FINISHDATE)>
                AND
                (
                NOTICES.FINISHDATE <= #arguments.FINISHDATE#
                OR
                    (
                    NOTICES.STARTDATE <= #arguments.FINISHDATE# AND
                    NOTICES.FINISHDATE > #arguments.FINISHDATE#
                    )
                )
                </cfif>
            </cfif>
            <cfif arguments.comp_id neq 0>
                AND NOTICES.OUR_COMPANY_ID = #arguments.comp_id#
            </cfif>
            <cfif arguments.company_id neq 0>
                AND NOTICES.COMPANY_ID = #arguments.COMPANY_ID#
            </cfif>
            <cfif arguments.branch_id neq 0>
                AND NOTICES.BRANCH_ID=#arguments.branch_id#  	
            </cfif>
            <cfif arguments.department neq 0>
                AND NOTICES.DEPARTMENT_ID = #arguments.department#  	
            </cfif>
            <cfif arguments.notice_cat_id neq 0>
                AND NOTICES.NOTICE_CAT_ID = #arguments.notice_cat_id#
            </cfif>
            ORDER BY
                NOTICES.RECORD_DATE DESC
        </cfquery>
        
		<cfreturn GET_NOTICES>
	</cffunction>
	
	<!--- get --->
    <cffunction name="get" access="public" returntype="query">
		<cfargument name="notice_id" type="numeric" default="0" required="yes" hint="İlan Id'si">
		<cfquery name="get" datasource="#dsn#">
            SELECT
                N.*,
                E.EMPLOYEE_ID,
                E.EMPLOYEE_USERNAME,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME,
                PRF.PERSONEL_REQUIREMENT_HEAD PIF_NAME,
                OC.NICK_NAME,
                B.BRANCH_NAME,
                D.DEPARTMENT_HEAD,
                C.FULLNAME,
                EP.EMPLOYEE_NAME +' '+ EP.EMPLOYEE_SURNAME AS EMP_VALIDATOR,
                CP.COMPANY_PARTNER_NAME +' '+ CP.COMPANY_PARTNER_SURNAME AS PAR_VALIDATOR,
                EP2.EMPLOYEE_NAME +' '+ EP2.EMPLOYEE_SURNAME AS EMP_INTERVIEW,
                CP2.COMPANY_PARTNER_NAME +' '+ CP2.COMPANY_PARTNER_SURNAME AS PAR_INTERVIEW
            FROM
                NOTICES N 
                LEFT JOIN EMPLOYEES E ON N.VALID_EMP = E.EMPLOYEE_ID 
                LEFT JOIN PERSONEL_REQUIREMENT_FORM PRF ON N.PIF_ID = PRF.PERSONEL_REQUIREMENT_ID
                LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID = N.OUR_COMPANY_ID
                LEFT JOIN BRANCH B ON B.BRANCH_ID = N.BRANCH_ID
                LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = N.DEPARTMENT_ID
                LEFT JOIN COMPANY C ON C.COMPANY_ID = N.COMPANY_ID
               	LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = N.VALIDATOR_POSITION_CODE
                LEFT JOIN COMPANY_PARTNER CP ON CP.PARTNER_ID = N.VALIDATOR_PAR
                LEFT JOIN EMPLOYEE_POSITIONS EP2 ON EP2.POSITION_CODE = N.INTERVIEW_POSITION_CODE
                LEFT JOIN COMPANY_PARTNER CP2 ON CP2.PARTNER_ID = N.INTERVIEW_PAR
            WHERE
                N.NOTICE_ID = #arguments.NOTICE_ID#
        </cfquery>
		<cfreturn get>
	</cffunction>
    <!--- add --->
    <cffunction name="add" access="public" returntype="string">			
        <cfargument name="process_stage" type="numeric" default="0" required="yes" hint="Süreç Aşaması">
        <cfargument name="paper_number" type="string" default="" required="yes" hint="İlan No">
        <cfargument name="paper_no" type="numeric" default="0" required="yes" hint="İlan Numarasının Rakam Kısmı">
        <cfargument name="notice_head" type="string" default="" required="yes" hint="İlan Başlığı">
        <cfargument name="validator_position" type="string" default="" required="yes" hint="Onaylayacak Kişi">
        <cfargument name="validator_position_code" type="numeric" default="0" required="yes" hint="Onaylayacak Kişinin Pozisyon Kodu">
      	<cfargument name="validator_par" type="numeric" default="0" required="no" hint="Onaylayacak Kişi Kurumsal Üye ise Id'si">
        <cfargument name="startdate" type="date" required="yes" hint="İlan Başlangıç Tarihi">
        <cfargument name="finishdate" type="date" required="yes" hint="İlan Bitiş Tarihi">
		<cfargument name="notice_cat_id" type="numeric" default="0" required="no" hint="İlan Grubu">
		<cfargument name="status" type="boolean" default="0" required="no" hint="Aktif">
        <cfargument name="detail" type="string" default="" required="no" hint="Açıklama">
		<cfargument name="app_position" type="string" default="" required="no" hint="Pozisyon İsmi">
        <cfargument name="position_id" type="numeric" default="0" required="no" hint="Pozisyon Id'si">
        <cfargument name="position_cat" type="string" default="" required="no" hint="Pozisyon Tipi">
        <cfargument name="position_cat_id" type="numeric" default="0" required="no" hint="Pozisyon Tipi Id'si">
        <cfargument name="interview_position_code" type="string" default="" required="no" hint="Bağlantı Kurulacak Kişi Pozisyon Kodu">
        <cfargument name="interview_par" type="numeric" default="0" required="no" hint="Bağlantı Kurulacak Kişi Kurumsal Üye ise Id'si">
        <cfargument name="valid" type="string" default="" required="no" hint="Onaylandı mı?">
        <cfargument name="publish" type="string" default="" required="no" hint="Yayın">
        <cfargument name="company_id" type="numeric" default="0" required="no" hint="Kurumsal Üye Id">
        <cfargument name="company" type="string" default="" required="no" hint="Kurumsal Üye">
        <cfargument name="our_company_id" type="numeric" default="0" required="no" hint="Şirket Id">
        <cfargument name="department_id" type="numeric" default="0" required="no" hint="Departman Id">
        <cfargument name="branch_id" type="numeric" default="0" required="no" hint="Şube Id">
        <cfargument name="city" type="string" default="" required="no" hint="Çalışılacak İller">
        <cfargument name="staff_count" type="numeric" default="0" required="no" hint="Kadro sayısı">
        <cfargument name="work_detail" type="string" default="" required="no" hint="Aciklama">
        <cfargument name="pif_id" type="numeric" default="0" required="no" hint="Personel Istek Formu">
        <cfargument name="view_logo" type="boolean" default="0" required="no" hint="Logo Görünsün/Görünmesin (Şirket)">
        <cfargument name="view_company_name" type="boolean" default="0" required="no" hint="Logo Görünsün/Görünmesin">
        <cfargument name="view_visual_notice" type="boolean" default="0" required="no" hint="Görsel İlan Görünsün/Görünmesin">
        <cfargument name="visual_notice" type="string" default="" required="no" hint="Görsel İlan Seç">
        
        <cfquery name="add_notice" datasource="#dsn#" result="MAX_ID">
            INSERT INTO
                NOTICES
                (
                    NOTICE_CAT_ID,
                    NOTICE_HEAD, 
                    NOTICE_NO,
                    STATUS,
                    STAGE,
                    DETAIL,
                    <cfif len(arguments.app_position)>POSITION_NAME,</cfif>
                    <cfif len(arguments.POSITION_ID)>POSITION_ID,</cfif>
                    <cfif len(arguments.position_cat)>POSITION_CAT_NAME,</cfif>
                    <cfif len(arguments.POSITION_CAT_ID)>POSITION_CAT_ID,</cfif>
                    <cfif len(arguments.INTERVIEW_POSITION_CODE)>
                        INTERVIEW_POSITION_CODE, 
                    <cfelseif len(arguments.INTERVIEW_PAR)>
                        INTERVIEW_PAR,
                    </cfif>
                    <cfif len(arguments.validator_position)>
                        <cfif len(arguments.validator_position_code)>
                            VALIDATOR_POSITION_CODE,
                        <cfelseif len(arguments.validator_par)>
                            VALIDATOR_PAR,
                        </cfif>
                    <cfelse>
                        VALID, 
                        VALID_DATE, 
                        VALID_EMP, 
                    </cfif>
                    STARTDATE, 
                    FINISHDATE, 	
                    PUBLISH, 
                    COMPANY_ID,
                    COMPANY,
                    OUR_COMPANY_ID,
                    DEPARTMENT_ID,
                    BRANCH_ID,
                    NOTICE_CITY,
                    COUNT_STAFF,
                    WORK_DETAIL,
                    PIF_ID,
                    IS_VIEW_LOGO,
                    IS_VIEW_COMPANY_NAME,
                    VIEW_VISUAL_NOTICE,
                    <cfif len(arguments.visual_notice)>
                        VISUAL_NOTICE,
                        SERVER_VISUAL_NOTICE_ID,
                    </cfif>
                    RECORD_DATE,
                    RECORD_IP,
                    RECORD_EMP
                )
            VALUES
                (
					<cfif len(arguments.notice_cat_id)>#arguments.notice_cat_id#,<cfelse>NULL,</cfif>
                    '#arguments.notice_head#', 
                    '#arguments.paper_number#',
                    #arguments.status#,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
                    '#arguments.detail#',<!--- '#attributes.detail#', --->
                    <cfif len(arguments.app_position)>'#arguments.app_position#',</cfif>
                    <cfif len(arguments.position_id)>#arguments.position_id#,</cfif>
                    <cfif len(arguments.position_cat)>'#arguments.position_cat#',</cfif>
                    <cfif len(arguments.position_cat_id)>#arguments.position_cat_id#,</cfif> 
                    <cfif len(arguments.interview_position_code)>
                        #arguments.interview_position_code#,
                    <cfelseif len(arguments.interview_par)>
                        #arguments.interview_par#,
                    </cfif>
                    <cfif len(arguments.validator_position)>
                        <cfif len(arguments.validator_position_code)>
                            #arguments.validator_position_code#,
                        <cfelseif len(arguments.validator_par)>
                            #arguments.validator_par#,
                        </cfif>
                    <cfelse>
                        1, 
                        #now()#, 
                        #session.ep.userid#, 
                    </cfif>
                    #arguments.startdate#, 
                    #arguments.finishdate#, 	
                    <cfif len(arguments.publish)>'#arguments.publish#',<cfelse>NULL,</cfif>
                    <cfif len(arguments.company) and len(arguments.company_id)>#arguments.company_id#,<cfelse>NULL,</cfif>
                    <cfif len(arguments.company) and len(arguments.company_id)>'#arguments.company#',<cfelse>NULL,</cfif>
                    <cfif len(arguments.our_company_id)>#arguments.our_company_id#,<cfelse>NULL,</cfif>
                    <cfif  len(arguments.department_id)>#arguments.department_id#,<cfelse>NULL,</cfif>
                    <cfif len(arguments.branch_id)>#arguments.branch_id#,<cfelse>NULL,</cfif>		
                    <cfif len(arguments.city)>',#arguments.city#,'<cfelse>NULL</cfif>,
                    <cfif len(arguments.staff_count)>#arguments.staff_count#<cfelse>NULL</cfif>,
                    <cfif len(arguments.work_detail)>'#arguments.work_detail#'<cfelse>NULL</cfif>,
                    <cfif len(arguments.pif_id) and len(arguments.pif_name)>#arguments.pif_id#<cfelse>NULL</cfif>,
                    #arguments.view_logo#,
                    #arguments.view_company_name#,
                    #arguments.view_visual_notice#,
                    <cfif len(arguments.visual_notice)>
                        '#arguments.visual_notice#',
                        1,
                    </cfif>
                    #now()#,
                    '#cgi.REMOTE_ADDR#',
                    #session.ep.userid#
                )
        </cfquery>
        
        <!--- EMP_NOTICE_NUMBER Değerini 1 Artır. --->
        <cfquery name="UPD_EMP_NOTICE_NUMBER" datasource="#DSN#">
            UPDATE GENERAL_PAPERS_MAIN SET EMP_NOTICE_NUMBER = #arguments.paper_no# WHERE EMP_NOTICE_NUMBER IS NOT NULL
        </cfquery>
        <cfsavecontent variable="message">
            <cf_get_lang dictionary_id="52158.Onaylayacak çalışanın email adresi girilmemiş veya uygun formatta değil">.
            <cf_get_lang dictionary_id="52184.İlan kaydedildi fakat email gönderilemedi.">
         </cfsavecontent> 
        <!--- Onaylayacak Pozisyon/Çalışan Email Bilgisi  --->
        <cfquery name="get_emp_email" datasource="#dsn#">
            SELECT
                E.EMPLOYEE_EMAIL
            FROM
                EMPLOYEES E,
                EMPLOYEE_POSITIONS EP
            WHERE
                EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.validator_position_code#"> AND
                E.EMPLOYEE_ID = EP.EMPLOYEE_ID
        </cfquery>
        <cfif not len(get_emp_email.EMPLOYEE_EMAIL)>
            <script>
             alertObject({message:"<cf_get_lang dictionary_id='52158.Onaylayacak çalışanın email adresi girilmemiş veya uygun formatta değil'>.<cf_get_lang dictionary_id='54590.İlan kaydedildi fakat email gönderilemedi'>!<cfoutput>#get_emp_email.EMPLOYEE_EMAIL#</cfoutput>"});
            </script>
        </cfif>
                
        <!--- Onaylayacak Kişiye E-Mail Gönder --->
		<cfif Len(get_emp_email.EMPLOYEE_EMAIL) and Find("@", get_emp_email.EMPLOYEE_EMAIL) and Find(".", get_emp_email.EMPLOYEE_EMAIL)>
            <cfmail to="#get_emp_email.EMPLOYEE_EMAIL#" from="#session.ep.company#<#session.ep.company_email#>" subject="İlan Onay" type="HTML">
                Onayınızı bekleyen bir ilan bulunmaktadır.
                <br />
                <a href="#employee_domain##request.self#?fuseaction=hr.list_notice&event=det&notice_id=#MAX_ID.IDENTITYCOL#">İlgili Forma Buradan Ulaşabilirsiniz...</a><br />
                Gönderen : #session.ep.name# #session.ep.surname#
            </cfmail>
        </cfif>
        
		<cfreturn MAX_ID.IDENTITYCOL>
	</cffunction>
    <!--- upd --->
    <cffunction name="upd" access="public" returntype="string">
        <cfargument name="process_stage" type="numeric" default="0" required="yes" hint="Süreç">
        <cfargument name="paper_number" type="string" default="" required="yes" hint="İlan No">
        <cfargument name="notice_head" type="string" default="" required="yes" hint="İlan Başlığı">
        <cfargument name="validator_position_code" type="numeric" default="0" required="yes" hint="Onaylayacak Kişinin Pozisyon Kodu">
       	<cfargument name="validator_par" type="numeric" default="0" required="no" hint="Onaylayacak Kişi Kurumsal Üye ise Id'si">
        <cfargument name="startdate" type="date" required="yes" hint="İlan Başlangıç Tarihi">
        <cfargument name="finishdate" type="date" required="yes" hint="İlan Bitiş Tarihi">
		<cfargument name="notice_cat_id" type="numeric" default="0" required="no" hint="İlan Grubu">
		<cfargument name="status" type="boolean" default="0" required="no" hint="Aktif">
        <cfargument name="detail" type="string" default="" required="no" hint="Açıklama">
		<cfargument name="app_position" type="string" default="" required="no" hint="Pozisyon İsmi">
        <cfargument name="position_id" type="numeric" default="0" required="no" hint="Pozisyon Id'si">
        <cfargument name="position_cat" type="string" default="" required="no" hint="Pozisyon Tipi">
        <cfargument name="position_cat_id" type="numeric" default="0" required="no" hint="Pozisyon Tipi Id'si">
        <cfargument name="interview_position_code" type="string" default="" required="no" hint="Bağlantı Kurulacak Kişi Pozisyon Kodu">
        <cfargument name="interview_par" type="numeric" default="0" required="no" hint="Bağlantı Kurulacak Kişi Kurumsal Üye is Id'si">
        <cfargument name="valid" type="string" default="" required="no" hint="Onaylandı mı?">
        <cfargument name="publish" type="string" default="" required="no" hint="Yayın">
        <cfargument name="company_id" type="numeric" default="0" required="no" hint="Kurumsal Üye Id">
        <cfargument name="company" type="string" default="" required="no" hint="Kurumsal Üye">
        <cfargument name="our_company_id" type="numeric" default="0" required="no" hint="Şirket Id">
        <cfargument name="department_id" type="numeric" default="0" required="no" hint="Departman Id">
        <cfargument name="branch_id" type="numeric" default="0" required="no" hint="Şube Id">
        <cfargument name="city" type="string" default="" required="no" hint="Çalışılacak İller">
        <cfargument name="staff_count" type="numeric" default="0" required="no" hint="Kadro sayısı">
        <cfargument name="work_detail" type="string" default="" required="no" hint="Aciklama">
        <cfargument name="pif_id" type="numeric" default="0" required="no" hint="Personel Istek Formu">
        <cfargument name="view_logo" type="boolean" default="0" required="no" hint="Logo Görünsün/Görünmesin (Şirket)">
        <cfargument name="view_company_name" type="boolean" default="0" required="no" hint="Logo Görünsün/Görünmesin">
        <cfargument name="view_visual_notice" type="boolean" default="0" required="no" hint="Görsel İlan Görünsün/Görünmesin">
        <cfargument name="visual_notice" type="string" default="" required="no" hint="Görsel İlan Seç">
        
        <cfquery name="upd_notice" datasource="#dsn#">
            UPDATE
                NOTICES
            SET
                NOTICE_CAT_ID = <cfif len(arguments.notice_cat_id)>#arguments.notice_cat_id#,<cfelse>NULL,</cfif>
                NOTICE_HEAD = '#arguments.notice_head#', 
                NOTICE_NO = '#arguments.paper_number#',
                STATUS = #arguments.status#,
                STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
                DETAIL = '#arguments.detail#',
                POSITION_NAME = <cfif len(arguments.app_position)>'#arguments.app_position#',<cfelse>NULL,</cfif>
                POSITION_ID = <cfif len(arguments.position_id)>#arguments.position_id#,<cfelse>NULL,</cfif>
                POSITION_CAT_ID = <cfif len(arguments.position_cat_id)>#arguments.position_cat_id#,<cfelse>NULL,</cfif>
                POSITION_CAT_NAME = <cfif len(arguments.position_cat)>'#arguments.position_cat#',<cfelse>NULL,</cfif>
                INTERVIEW_POSITION_CODE = <cfif len(arguments.interview_position_code)>#arguments.interview_position_code#, <cfelse>NULL, </cfif>
                INTERVIEW_PAR = <cfif len(arguments.interview_par)>#arguments.interview_par#,<cfelse>NULL,</cfif>
                VALIDATOR_POSITION_CODE = <cfif validator_position_code neq 0>#arguments.validator_position_code#, <cfelse>NULL,</cfif>
                <cfif arguments.validator_par neq 0>
                    VALIDATOR_PAR = #arguments.validator_par#, 
                <cfelse>
                    VALIDATOR_PAR = NULL, 
                </cfif>
                <cfif len(arguments.valid)>
					<cfif arguments.valid eq 1>
                        VALID = 1, 
                        VALID_DATE = #now()#, 
                        VALID_EMP = #session.ep.userid#, 
                    <cfelseif arguments.valid eq 0>
                        VALID = 0, 
                        VALID_DATE = #now()#, 
                        VALID_EMP = #session.ep.userid#, 
                    </cfif>
                </cfif>
                STARTDATE = <cfif len(arguments.startdate)>#arguments.startdate#,<cfelse>NULL,</cfif>
                FINISHDATE = <cfif len(arguments.finishdate)>#arguments.finishdate#,<cfelse>NULL,</cfif>
                PUBLISH = <cfif len(arguments.publish)>'#arguments.publish#',<cfelse>NULL,</cfif> 
                <cfif len(arguments.company_id) and len(arguments.company)>COMPANY_ID=#arguments.company_id#,<cfelse>COMPANY_ID=NULL,</cfif>
                <cfif len(arguments.company) and len(arguments.company_id)>COMPANY='#arguments.company#',<cfelse>COMPANY=NULL,</cfif>
                <cfif len(arguments.our_company_id)>
                    OUR_COMPANY_ID = #arguments.our_company_id#,
                <cfelse>
                    OUR_COMPANY_ID  =NULL,
                </cfif>
                <cfif len(arguments.department_id)>
                    DEPARTMENT_ID = #arguments.department_id#,
                <cfelse>
                    DEPARTMENT_ID = NULL,
                </cfif>
                <cfif len(arguments.branch_id)>
                    BRANCH_ID = #arguments.branch_id#,
                <cfelse>
                    BRANCH_ID = NULL,
                </cfif>
                    UPDATE_DATE = #now()#,
                    UPDATE_IP = '#cgi.REMOTE_ADDR#',
                    UPDATE_EMP = #session.ep.userid#,
                    NOTICE_CITY = <cfif len(arguments.city)>',#arguments.city#,'<cfelse>NULL</cfif>,
                    COUNT_STAFF = <cfif len(arguments.staff_count)>#arguments.staff_count#<cfelse>NULL</cfif>,
                    WORK_DETAIL = <cfif len(arguments.work_detail)>'#arguments.work_detail#'<cfelse>NULL</cfif>,
                    PIF_ID = <cfif len(arguments.pif_id)>#arguments.pif_id#<cfelse>NULL</cfif>,
                    IS_VIEW_LOGO = #arguments.view_logo#,
                    IS_VIEW_COMPANY_NAME = #arguments.view_company_name#,
                    VIEW_VISUAL_NOTICE = #arguments.view_visual_notice#,
	                <cfif len(arguments.visual_notice)>VISUAL_NOTICE = '#arguments.visual_notice#',</cfif>
                    SERVER_VISUAL_NOTICE_ID = 1
            WHERE
                NOTICE_ID = #arguments.notice_id#
        </cfquery>
        
		<cfreturn arguments.notice_id>
	</cffunction>
    <!--- del --->
    <cffunction name="del" access="public" returntype="boolean">
		<cfargument name="notice_id" type="numeric" default="0" required="yes" hint="İlan Id'si">
        
        <cfquery name="upd_notice" datasource="#dsn#">
            DELETE FROM NOTICES WHERE NOTICE_ID = #arguments.notice_id#
        </cfquery>
               
		<cfreturn true>
	</cffunction>
    
    <!--- control --->
    <cffunction name="controlNotice" access="public" returntype="query">
		<cfargument name="notice_no" type="string" default="" required="yes" hint="İlan no">
        <cfargument name="notice_id" type="numeric" default="0" required="no" hint="İlan Id'si">
        
        <cfquery name="control" datasource="#dsn#">
            SELECT 
            	NOTICE_ID 
            FROM 
            	NOTICES 
            WHERE 
            	NOTICE_NO = '#arguments.notice_no#' 
                <cfif arguments.notice_id neq 0>
	                AND NOTICE_ID <> #arguments.notice_id#
                </cfif>
        </cfquery>
               
		<cfreturn control>
	</cffunction>
    
    <!--- get İmage --->
    <cffunction name="getImage" access="public" returntype="query">
		<cfargument name="notice_id" type="numeric" default="0" required="yes" hint="İlan Id'si">
        
        <cfquery name="get" datasource="#dsn#">
            SELECT VISUAL_NOTICE,SERVER_VISUAL_NOTICE_ID FROM NOTICES WHERE NOTICE_ID =  #arguments.notice_id#
        </cfquery>
               
		<cfreturn get>
	</cffunction>
</cfcomponent>