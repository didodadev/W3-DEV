<!--- mozilla clicked icindeki &li degeri almadigindan tanimli degilse tanimladik fbs 20130212 --->
<cfif isDefined("attributes.clicked") and attributes.clicked contains 'true'>
	<cfset attributes.email = "true">
<cfelse>
	<cfset attributes.email = "false">
</cfif>
<cf_xml_page_edit fuseact="call.popup_add_helpdesk">
<!---<cfif not len(attributes.subject)>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='217.Açıklama'> !");
		history.back();
	</script>
</cfif>--->
<cfif isdefined('attributes.template_id') and len(attributes.template_id)>
	<cfquery name="GET_TEMPLATE" datasource="#DSN#">
		SELECT IS_LOGO FROM TEMPLATE_FORMS WHERE TEMPLATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.template_id#">
	</cfquery>
</cfif>
<cfif len(attributes.interaction_date)><cf_date tarih="attributes.interaction_date"></cfif>
<!--- Bu sayfa TTInsaat icin add_optionsa tasinmistir. Yapilan degisiklikler oraya da aktarilmali.BK 20080402 --->
<cfquery name="GET_EMPLOYEE_EMAIL" datasource="#DSN#"><!--- Mail gönderen kişinin mail adresini getiriyor. --->
	SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME, EMPLOYEE_EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
</cfquery>
<!--- Modified: OZCAN 20120713 Şikayet cevaplama süresini bulma İş_id=47372--->
<cfif isdefined('attributes.email') and attributes.email eq 'true'>
	<cfset duration=0>
</cfif>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
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
				<cfif isdefined('attributes.email') and attributes.email eq 'true'>
					MAIL_RECORD_DATE,
					MAIL_RECORD_EMP,
				</cfif>
				<cfif isdefined("attributes.camp_id") and isdefined("attributes.camp_name")>CAMP_ID,</cfif>
				RECEIVED_DURATION,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP,
				PROCESS_CAT,
				EVENT_PLAN_ROW_ID
			)
			VALUES
			(
			  	<cfif attributes.member_type is 'partner'>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">,
					NULL,
			  	<cfelse>
					NULL,
					NULL,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">,		
			  	</cfif>
			  	<cfif len(attributes.workcube_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.workcube_id#"><cfelse>NULL</cfif>,
			  	<cfif isdefined('attributes.product_id') and len(attributes.product_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"><cfelse>NULL</cfif>,
			  	<cfif len(attributes.company)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.company#"><cfelse>NULL</cfif>,
			 	<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.app_cat#">,
              	<cfif len(attributes.interaction_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.interaction_cat#"><cfelse>NULL</cfif>,
              	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.interaction_date#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.subject#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.applicant_name#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.applicant_mail#">,
				<cfif isdefined('attributes.email') and attributes.email eq 'true'>1<cfelse>0</cfif>,
				0,
				<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.tel_code")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tel_code#">,<cfelse>NULL,</cfif>
                <cfif isdefined("attributes.tel_no")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tel_no#">,<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.special_definition") and Len(attributes.special_definition)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.special_definition#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.email') and attributes.email eq 'true'>
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				</cfif>
				<cfif isdefined("attributes.camp_id") and isdefined("attributes.camp_name")>
					<cfif len(attributes.camp_id) and len(attributes.camp_name)>
						#attributes.camp_id#,
					<cfelse>
						NULL,
					</cfif>
				</cfif>
				<cfif isdefined("duration")>#duration#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				<cfif isDefined('attributes.process_cat') and len(attributes.process_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#"><cfelse>NULL</cfif>,
				<cfif isDefined('attributes.event_plan_row_id') and len(attributes.event_plan_row_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_plan_row_id#"><cfelse>NULL</cfif>
			 )
		</cfquery>
	</cftransaction>
</cflock>

<!---Ek Bilgiler--->
<cfset attributes.info_id = max_id.IDENTITYCOL>
<cfset attributes.is_upd = 0>
<cfset attributes.info_type_id = -25>
<cfinclude template="../../objects/query/add_info_plus2.cfm">
<!---Ek Bilgiler--->

<cfif isdefined('attributes.email') and attributes.email eq 'true' and isdefined("attributes.applicant_mail") and len(attributes.applicant_mail)>
	<cfset from_mail='#session.ep.company#<#session.ep.company_email#>'>
	<cfif isdefined("attributes.is_reply_email") and (attributes.is_reply_email eq 1)>
		<cfset replyto_mail = "#get_employee_email.employee_name# #get_employee_email.employee_surname#<#get_employee_email.employee_email#>;#from_mail#">
	<cfelse>
		<cfset replyto_mail = "#from_mail#">
	</cfif>
    <cfif x_interaction eq 1>
    	<cfsavecontent variable="message"><cfoutput>#MAX_ID.IDENTITYCOL# - #attributes.detail#</cfoutput></cfsavecontent>
    <cfelse>
       <cfsavecontent variable="message"><cfoutput>#attributes.detail#</cfoutput></cfsavecontent>
    </cfif>
	<cfmail from="#from_mail#" to="#attributes.applicant_mail#" failto="#get_employee_email.employee_email#" replyto="#replyto_mail#" subject="#message#" type="html" charset="utf-8">
		<html>
			<head>
			<title></title>
			</head>
			<body> 
			<table border="0" align="center" style="width:500px;">
				<cfif isdefined('attributes.template_id') and len(attributes.template_id)>
					<cfif get_template.recordcount and len(get_template.is_logo) and get_template.is_logo eq 1>
						<tr style="height:60px;">
							<td colspan="2"><cfinclude template="../../objects/display/view_company_logo.cfm"></td>
						</tr> 
					</cfif>
				</cfif>
				<tr style="height:35px;">
					<td colspan="2"><b><cf_get_lang no='26.Yardım Talebiniz'></b></td>
				</tr>
				<tr style="height:35px;">
					<td style="vertical-align:top"><b><cf_get_lang_main no='1368.Sayın'> : </b><cfif isdefined("attributes.applicant_name")></td>
					<td style="width:93%"><cfoutput>#attributes.applicant_name#</cfoutput></cfif><br/><br/></td>
				</tr>
				<tr>
					<td style="vertical-align:top"><b><cf_get_lang_main no='68.Konu'> : </b></td>
					<td><cfoutput>#attributes.subject#</cfoutput><br/><br/></td>
				</tr>
				<tr>
					<td colspan="2"><b><cf_get_lang_main no='330.Tarih'> : </b><cfoutput>#dateformat(now(),'dd/mm/yy')#</cfoutput><b> <cf_get_lang_main no='79.Saat'> : </b><cfoutput>#TimeFormat(date_add('h',session.ep.time_zone,now()), timeformat_style)#</cfoutput><br/></td>
				</tr>			
				<cfif isdefined('attributes.template_id') and len(attributes.template_id)>
					<cfif get_template.recordcount and len(get_template.is_logo) and get_template.is_logo eq 1>
                        <tr>
                            <td align="center" colspan="2">
                                <cfinclude template="../../objects/display/view_company_info.cfm"><br/>
                                <a href="http://www.workcube.com"><img src="http://www.workcube.com/images/powered.gif" alt="" border="0"></a>
                            </td>
                        </tr> 
                    </cfif>
                </cfif>
			</table>
			</body>
		</html>
	</cfmail>  
</cfif>
<cfif len(attributes.partner_id)>
	<cfset comp_name = '#get_par_info(attributes.partner_id,0,1,0)#'>
<cfelse>
	<cfset comp_name = ''>
</cfif>
<cf_workcube_process 
	is_upd='1' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#'
	action_table='CUSTOMER_HELP'
	action_column='CUS_HELP_ID'
	action_id='#MAX_ID.IDENTITYCOL#'
	action_page='#request.self#?fuseaction=call.helpdesk&event=upd&cus_help_id=#MAX_ID.IDENTITYCOL#' 
	warning_description="#getLang('call',80)# : #comp_name# - #attributes.applicant_name# #attributes.detail# <br> #attributes.subject#">
<cfset attributes.actionId = MAX_ID.IDENTITYCOL>
<cfif not isdefined("attributes.is_rapor")>
	<script type="text/javascript">
		window.location.href='<cfoutput>#request.self#?fuseaction=call.helpdesk&event=upd&cus_help_id=#MAX_ID.IDENTITYCOL#</cfoutput>';
	</script>
<cfelse>
	<script type="text/javascript">
		window.opener.location.reload();
		window.close();
	</script>
</cfif>