<!--- CallCenter Sms Gonderimi Otomatik - Checkbox ile Secildiginde --->
<cfset attributes.member_type = "">
<cfset attributes.member_id = "">
<cfif session.ep.our_company_info.sms>
	<cfif len(get_service1.service_partner_id)>
		<cfset attributes.member_type='partner'>
		<cfset attributes.member_id=get_service1.service_partner_id>
	<cfelseif len(get_service1.service_company_id)>
		<cfset attributes.member_type='company'>
		<cfset attributes.member_id=get_service1.service_company_id>
	<cfelseif len(get_service1.service_consumer_id)>
		<cfset attributes.member_type='consumer'>
		<cfset attributes.member_id=get_service1.service_consumer_id>
	<cfelseif len(get_service1.service_employee_id)>
		<cfset attributes.member_type='employee'>
		<cfset attributes.member_id=get_service1.service_employee_id>
	</cfif>
	<cfif attributes.member_type eq 'company'>
		<cfquery name="GET_MEMBER" datasource="#DSN#">
			SELECT CP.MOBIL_CODE+CP.MOBILTEL AS MOBILPHONE FROM COMPANY_PARTNER CP,	COMPANY C WHERE CP.PARTNER_ID = C.MANAGER_PARTNER_ID AND C.COMPANY_ID = #attributes.member_id#
		</cfquery>
	<cfelseif attributes.member_type eq 'partner'>
		<cfquery name="GET_MEMBER" datasource="#DSN#">
			SELECT CP.MOBIL_CODE+CP.MOBILTEL AS MOBILPHONE FROM COMPANY_PARTNER CP, COMPANY C WHERE C.COMPANY_ID = CP.COMPANY_ID AND CP.PARTNER_ID = #attributes.member_id#
		</cfquery>
	<cfelseif attributes.member_type eq 'consumer'>
		<cfquery name="GET_MEMBER" datasource="#DSN#">
			SELECT MOBIL_CODE+MOBILTEL AS MOBILPHONE FROM CONSUMER WHERE CONSUMER_ID = #attributes.member_id# 
		</cfquery>
	<cfelseif attributes.member_type eq 'employee'>
		<cfquery name="GET_MEMBER" datasource="#DSN#">
			SELECT MOBILCODE+MOBILTEL AS MOBILPHONE FROM EMPLOYEES WHERE EMPLOYEE_ID = #attributes.member_id#
		</cfquery>
	</cfif>
	<cfquery name="GET_MSG_TEMP" datasource="#DSN#">
		SELECT TOP 1
			SMS_TEMPLATE_ID,
			SMS_TEMPLATE_NAME,
			SMS_TEMPLATE_BODY
		FROM 
			SMS_TEMPLATE
		WHERE
			IS_ACTIVE = 1 AND
			SMS_FUSEACTION LIKE '%call.upd_service%'
	</cfquery>
	<cfif len(get_member.mobilphone) eq 10>
		<cfset attributes.mobil_phone = get_member.mobilphone>
	<cfelse>
		<cfset attributes.mobil_phone = "">
	</cfif>
	<cfset attributes.sms_template_id = get_msg_temp.sms_template_id>
	<cfset attributes.paper_type = 6>
	<cfset attributes.paper_id = attributes.service_id>
	<cfset callcenter_include = 1><!--- include a gonderiliyor --->
	<cfset attributes.sms_body=wrk_sms_body_replace(sms_body:GET_MSG_TEMP.SMS_TEMPLATE_BODY,member_type:attributes.member_type,member_id:attributes.member_id,paper_type:attributes.paper_type,paper_id:attributes.paper_id)>
	<cfinclude template="../../objects/query/add_send_sms.cfm">
</cfif>
