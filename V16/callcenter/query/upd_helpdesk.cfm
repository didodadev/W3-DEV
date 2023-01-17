<cfif not isDefined("attributes.email") and isDefined("attributes.clicked") and attributes.clicked contains 'true'>
	<cfset attributes.email = "true">
<cfelseif not isDefined("attributes.email")>
	<cfset attributes.email = "false">
</cfif>
<cf_xml_page_edit fuseact="call.popup_add_helpdesk">
<cfif len(attributes.interaction_date)>
	<cf_date tarih="attributes.interaction_date">
</cfif>
<cfquery name="SAVE_MEMBER" datasource="#DSN#">
	SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
</cfquery>
<cfif isdefined('attributes.template_id') and len(attributes.template_id)>
	<cfquery name="GET_TEMPLATE" datasource="#DSN#">
		SELECT IS_LOGO FROM TEMPLATE_FORMS WHERE TEMPLATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.template_id#">
	</cfquery>
</cfif>
<cfquery name="GET_EMPLOYEE_EMAIL" datasource="#DSN#"><!--- Mail gönderen kişinin mail adresini getiriyor. --->
	SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME, EMPLOYEE_EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
</cfquery>
<!--- Consumer_id degerinin else ifadesinde kontrol edilmesi partner ve sistem disindaki kayit atilan yerler icin eklendi BK 20070328--->
<cfquery name="GET_MAIL_RECORD_INFO" datasource="#DSN#">
	SELECT MAIL_RECORD_DATE, MAIL_RECORD_EMP,RECORD_DATE,IS_REPLY_MAIL,RECEIVED_DURATION FROM CUSTOMER_HELP WHERE CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cus_help_id#">
</cfquery>
<cfif attributes.email eq 'true'>
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
        <cfif attributes.member_type is 'partner'>
            PARTNER_ID = #attributes.partner_id#,
            COMPANY_ID = #attributes.company_id#,
            CONSUMER_ID = NULL,
        <cfelse>
            PARTNER_ID = NULL,
            COMPANY_ID = NULL,
            CONSUMER_ID = <cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
        </cfif>
        PRODUCT_ID = <cfif isdefined('attributes.product_id') and len(attributes.product_id)>#attributes.product_id#,<cfelse>NULL,</cfif>
        SUBSCRIPTION_ID = <cfif isdefined(attributes.subscription_id) and len(attributes.subscription_id)>#attributes.subscription_id#,<cfelse>NULL,</cfif>
        APP_CAT = #attributes.app_cat#,
        INTERACTION_CAT = <cfif len(attributes.interaction_cat)>#attributes.interaction_cat#<cfelse>NULL</cfif>,
        INTERACTION_DATE = #attributes.interaction_date#,
        APPLICANT_MAIL = '#attributes.applicant_mail#',
        APPLICANT_NAME = #sql_unicode()#'#attributes.applicant_name#',
        PROCESS_STAGE = #attributes.process_stage#,
        SOLUTION_DETAIL = #sql_unicode()#'#attributes.content#',
        DETAIL = #sql_unicode()#'#attributes.detail#',
        SUBJECT = #sql_unicode()#'#attributes.subject#',
        <cfif attributes.email eq 'true'>
            IS_REPLY_MAIL = 1,
            IS_REPLY = 0,
        <cfelseif len(attributes.content)>
            IS_REPLY =1,
        </cfif>
        CUSTOMER_TELCODE = <cfif isdefined("attributes.tel_code")>'#attributes.tel_code#',<cfelse>NULL,</cfif>
        CUSTOMER_TELNO = <cfif isdefined("attributes.tel_no")>'#attributes.tel_no#',<cfelse>NULL,</cfif>
        SPECIAL_DEFINITION_ID = <cfif isdefined("attributes.special_definition") and Len(attributes.special_definition)>#attributes.special_definition#<cfelse>NULL</cfif>,
        <cfif attributes.email eq 'true' and not len(get_mail_record_info.MAIL_RECORD_DATE)>MAIL_RECORD_DATE = #now()#,</cfif><!--- mail_record_date null ise  değer atanir--->
        <cfif attributes.email eq 'true' and not len(get_mail_record_info.MAIL_RECORD_EMP)>MAIL_RECORD_EMP = #session.ep.userid#,</cfif><!--- mail_record_emp null ise  değer atanir--->
        <cfif isdefined("attributes.camp_id")  and isdefined("attributes.camp_name")>	
            <cfif len(attributes.camp_id) and len(attributes.camp_name)>
                CAMP_ID = #attributes.camp_id#,
            <cfelse>	
                CAMP_ID = NULL,
            </cfif>
        </cfif>
        RECEIVED_DURATION=<cfif isdefined("duration")>#duration#<cfelse>NULL</cfif>,
        UPDATE_DATE = #now()#,
        UPDATE_IP = '#cgi.remote_addr#',
        UPDATE_EMP = #session.ep.userid#
        <cfif isDefined('attributes.process_cat')>
            ,PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#">
        </cfif>
    WHERE
        CUS_HELP_ID = #attributes.cus_help_id#
</cfquery>
<cfif isdefined('attributes.is_help_desk') and len(attributes.is_help_desk)>
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
            '#attributes.modul_name#',
            '#attributes.faction#',
            '#attributes.help_head#',
            '#attributes.content#',
            <cfif isdefined('attributes.is_internet')>1<cfelse>0</cfif>,
            <cfif isdefined('attributes.is_faq')>1<cfelse>0</cfif>,
            #now()#,
            'e',
            '#cgi.remote_addr#',
            #session.ep.userid#,
            '#session.ep.language#'
        )
    </cfquery>
</cfif>
<!--- Bu sayfa TTInsaat icin add_optionsa tasinmistir. Yapilan degisiklikler oraya da aktarilmali.BK 20080402 --->
<cfquery name="GET_HELP" datasource="#DSN#">
    SELECT PARTNER_ID,CONSUMER_ID,APPLICANT_NAME,DETAIL FROM CUSTOMER_HELP WHERE CUSTOMER_HELP.CUS_HELP_ID = #attributes.cus_help_id#
</cfquery>
<cfif len(get_help.partner_id)>
    <cfset member_name = get_par_info(get_help.partner_id,0,-1,0)>
<cfelseif len(get_help.consumer_id)>
    <cfset member_name = get_cons_info(get_help.consumer_id,0,0)>
<cfelse>
    <cfset member_name = get_help.applicant_name>
</cfif>
<cfif attributes.email eq 'true' and isdefined("attributes.applicant_mail") and len(attributes.applicant_mail)>
    <cfset from_mail='#session.ep.company#<#session.ep.company_email#>'>
    <cfif isdefined("attributes.is_reply_email") and (attributes.is_reply_email eq 1)>
        <cfset replyto_mail = "#get_employee_email.employee_name# #get_employee_email.employee_surname#<#get_employee_email.employee_email#>;#from_mail#">
    <cfelse>
        <cfset replyto_mail = "#from_mail#">
    </cfif> 
    <cfif x_interaction eq 1>
        <cfsavecontent variable="message"><cfoutput>#attributes.cus_help_id# - #get_help.detail#</cfoutput></cfsavecontent>
    <cfelse>
       <cfsavecontent variable="message"><cfoutput>#get_help.detail#</cfoutput></cfsavecontent>
    </cfif>
    <cfmail from="#from_mail#" to="#attributes.applicant_mail#" replyto="#replyto_mail#" subject="#message#" type="html" charset="utf-8">
        <html>
            <head>
                <title></title>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
            </head>
            <body> 
            <table width="650"  border="0">
                <cfif isdefined('attributes.template_id') and len(attributes.template_id)>
                    <cfif get_template.recordcount and len(get_template.is_logo) and get_template.is_logo eq 1>
                        <tr style="height:60px;">
                            <td><cfinclude template="../../objects/display/view_company_logo.cfm"></td>
                        </tr>
                    </cfif>
                </cfif> 
                
                <tr style="height:35px;">
                    <td><b><cf_get_lang_main no ='1242.Cevap'> : </b><cfoutput>#attributes.content#</cfoutput><br/><br/></td>
                </tr>

                <tr style="height:35px;">
                    <td><b><cf_get_lang_main no='1368.Sayın'> : </b><cfoutput>#applicant_name#</cfoutput><br/><br/></td>
                </tr>

                <tr>
                    <td><b><cf_get_lang_main no='68.Konu'> : </b><cfoutput>#attributes.subject#</cfoutput><br/><br/></td>
                </tr>
                
                <tr>
                    <td colspan="2"><b><cf_get_lang_main no='330.Tarih'> : </b><cfoutput>#dateformat(now(),'dd/mm/yy')#</cfoutput><b> <cf_get_lang_main no='79.Saat'> : </b><cfoutput>#TimeFormat(date_add('h',session.ep.time_zone,now()), timeformat_style)#</cfoutput><br/></td>
                </tr>
                
                <cfif isdefined('attributes.template_id') and len(attributes.template_id)>
                    <cfif get_template.recordcount and len(get_template.is_logo) and get_template.is_logo eq 1>
                        <tr>
                            <td>
                                <cfinclude template="../../objects/display/view_company_info.cfm"><br/>
                            </td>
                        </tr>
                    </cfif>
                </cfif>
            </table> 
            </body>
        </html>
    </cfmail>
</cfif>
<!---Ek Bilgiler--->
	<cfset attributes.info_id =  attributes.cus_help_id>
    <cfset attributes.is_upd = 1>
    <cfset attributes.info_type_id = -25>
    <cfinclude template="../../objects/query/add_info_plus2.cfm">
    <!---Ek Bilgiler--->
<cf_workcube_process 
    is_upd='1' 
    old_process_line='#attributes.old_process_line#'
    process_stage='#attributes.process_stage#' 
    record_member='#session.ep.userid#'
    record_date='#now()#' 
    action_table='CUSTOMER_HELP'
    action_column='CUS_HELP_ID'
    action_id='#attributes.cus_help_id#' 
    action_page='#request.self#?fuseaction=call.helpdesk&event=upd&cus_help_id=#attributes.cus_help_id#' 
    warning_description="#getLang('call',80)# : #attributes.company_name# - #attributes.applicant_name# #attributes.detail# <br> #attributes.subject#">


<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=call.helpdesk&event=upd&cus_help_id=#attributes.cus_help_id#</cfoutput>";
</script>
