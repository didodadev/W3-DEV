<!---
    Author: Workcube - Botan Kayğan <botankaygan@workcube.com>
    Date: 01.05.2021
    Description:
      Ücret Ödenek (ehesap.list_salary) sürecine action file olarak eklenmelidir.
      Herhangi bir çalışanın ücret kartında değişiklik yapıldığında bordro yöneticilerine bilgilendirme maili gönderir.
--->
<cfset manager_employees_ids = "8,65" /> <!--- Bordro yöneticilerinin employee_id leri virgül ile girilmelidir. "1,2,3,4,5" gibi --->
<cfif isdefined("session.ep") and isdefined("attributes.action_id") and len(attributes.action_id)>
    <cfquery name="get_in_out_employee" datasource="#caller.dsn#">
        SELECT
            EIO.EMPLOYEE_ID,
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME
        FROM
            EMPLOYEES_IN_OUT EIO
            LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
        WHERE
            EIO.IN_OUT_ID = #attributes.action_id#
    </cfquery>
    <cfquery name="get_manager_employees_mail" datasource="#caller.dsn#">
        SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#manager_employees_ids#" list="true">)
    </cfquery>
    <cfoutput query="get_manager_employees_mail">
        <cfif len(EMPLOYEE_EMAIL)>
            <cfif Len(session.ep.company_email)>
                <cfset attributes.mail_content_from ='#session.ep.company#<#session.ep.company_email#>'>
                <cfset attributes.start_date=DateFormat(dateadd('h',session.ep.time_zone,now()), 'DD/MM/YYYY') & " " & TimeFormat(dateadd('h',session.ep.time_zone,now()), 'HH:MM')>
            </cfif>
            <cfset attributes.mail_content_to = '#EMPLOYEE_EMAIL#'>
            <cfset attributes.mail_content_subject = 'Ücret Ödenek Kartı - Bilgilendirme'>
            
            <cfset attributes.mail_content_additor = '#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#'>
            <cfset attributes.mail_content_info2='#get_in_out_employee.EMPLOYEE_NAME# #get_in_out_employee.EMPLOYEE_SURNAME# adlı kişinin ücret kartında değişiklik yapılmıştır.'>

            <cfsavecontent variable="attributes.mail_content_info">Bilgilendirme</cfsavecontent>
            <cfif cgi.server_port eq 443>
                <cfset user_domain = "https://#cgi.server_name#">
            <cfelse>
                <cfset user_domain = "http://#cgi.server_name#">
            </cfif>
            <cfset attributes.mail_content_link = '#user_domain#/#attributes.action_page#&wrkflow=1'>
            <cfset attributes.process_stage_info = attributes.process_stage>
            <cfinclude template="/design/template/info_mail/mail_content.cfm">
        </cfif>
    </cfoutput>
</cfif>