<cfparam name="attributes.TO_CONS_IDS" default="">
<cfparam name="attributes.TO_COMP_IDS" default="">
<cfparam name="attributes.TO_POS_CODES" default="">
<cfif (isDefined('attributes.TO_CONS_IDS') and len(attributes.TO_CONS_IDS)) or (isDefined('attributes.TO_COMP_IDS') and len(attributes.TO_COMP_IDS)) or (isDefined('attributes.TO_POS_CODES') and len(attributes.TO_POS_CODES))>
<cfset POSITION_CODE = "#attributes.TO_CONS_IDS#,#attributes.TO_COMP_IDS#,#attributes.TO_POS_CODES#">
<cfelse>
<cfset POSITION_CODE = "#session.ep.position_code#">
</cfif>	
<cfloop from="1" to="#listlen(POSITION_CODE)#" index="i">
	<!--- <cfif isDefined("attributes.email_startdate0") and len(evaluate("attributes.email_startdate0"))>
		<cf_date tarih="attributes.email_startdate0">
		<cfset EMAIL_WARNING_DATE = date_add('h',evaluate("attributes.EMAIL_START_CLOCK0")-session.ep.time_zone,evaluate("attributes.email_startdate0"))>
		<cfset EMAIL_WARNING_DATE = date_add('n',evaluate("attributes.EMAIL_START_MIN0"),EMAIL_WARNING_DATE)>
	<cfelse>
		<cfset EMAIL_WARNING_DATE = "NULL">
	</cfif> --->
	<cfif isDefined("attributes.response_date0") and len(evaluate("attributes.response_date0"))>
		<cf_date tarih="attributes.response_date0">
		<cfset RESPONSE_DATE = date_add('h',evaluate("attributes.response_clock0")-session.ep.time_zone,evaluate("attributes.response_date0"))>
		<cfset RESPONSE_DATE = date_add('n',evaluate("attributes.response_min0"),RESPONSE_DATE)>
	<cfelse>
		<cfset RESPONSE_DATE = "NULL">
	</cfif>
	<cfquery name="add_warning" datasource="#dsn#" result="GET_WARNINGS">
		INSERT INTO
			PAGE_WARNINGS
			(
				URL_LINK,
				ACCESS_CODE,
				WARNING_HEAD,
				SETUP_WARNING_ID,
				WARNING_DESCRIPTION,
				SMS_WARNING_DATE,
				EMAIL_WARNING_DATE,
				LAST_RESPONSE_DATE,
				RECORD_DATE,
				IS_ACTIVE,
				IS_PARENT,
				IS_CONTENT,
				CONTENT_ID,
				RESPONSE_ID,
				RECORD_IP,
				RECORD_EMP,
				POSITION_CODE,
				OUR_COMPANY_ID,
				PERIOD_ID,
				IS_AGENDA,
				IS_CHECKER_UPDATE_AUTHORITY,
				COMMENT_REQUEST,
				WARNING_PASSWORD
				<cfif attributes.notice_type eq 2>
				,IS_CONFIRM
				,IS_REFUSE
				</cfif>
				,IS_MANUEL_NOTIFICATION
				,SENDER_POSITION_CODE
			)
			VALUES
			(
				<cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#attributes.url_link#">,
				<cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#attributes.access_code#" null = "#not len(attributes.access_code)? 'yes' : 'no'#">,
				'#attributes.notice_type eq 1 ? getLang("","","61054") : getLang("","","30389")#',
				-1,
				<cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#attributes.warning_description#">,
				#RESPONSE_DATE#,
				#RESPONSE_DATE#,
				#RESPONSE_DATE#,
				#NOW()#,
				1,
				1,
				<cfif url_link contains 'dsp_rule'>1<cfelse>0</cfif>,
				<cfif url_link contains 'dsp_rule'>#listlast(url_link,'=')#<cfelse>NULL</cfif>,
				0,
				'#CGI.REMOTE_ADDR#',
				#SESSION.EP.USERID#,
				#ListGetAt(POSITION_CODE,i)#,
				#session.ep.company_id#,
				#session.ep.period_id#,
				<cfif isdefined('attributes.is_agenda') and attributes.is_agenda eq 1>1<cfelse>0</cfif>,
				<cfqueryparam cfsqltype = "cf_sql_bit" value = "#attributes.is_checker_update_authority#">,
				<cfif attributes.notice_type eq 1>1<cfelse>0</cfif>,
				<cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#attributes.warning_password#" null = "#not len(attributes.warning_password)? 'yes' : 'no'#">
				<cfif attributes.notice_type eq 2>
				,1
				,1
				</cfif>
				,1
				,#session.ep.position_code#
			)
	</cfquery>
	<cfquery name="UPD_WARNINGS" datasource="#dsn#">
		UPDATE PAGE_WARNINGS SET PARENT_ID = #GET_WARNINGS.IDENTITYCOL# WHERE W_ID = #GET_WARNINGS.IDENTITYCOL#			
	</cfquery>
	<cfquery name="get_employee_info" datasource="#dsn#">
		SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_EMAIL FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #ListGetAt(POSITION_CODE,i)#
	</cfquery>
	<cfif get_employee_info.recordcount and len(get_employee_info.EMPLOYEE_EMAIL)>
		
		<cfquery name="GET_COMP_ADDR" datasource="#dsn#">
			SELECT 
				COMPANY_NAME,
				ADDRESS,
				TEL_CODE,
				TEL,
				FAX,
				WEB,
				ASSET_FILE_NAME2 
			FROM 
				OUR_COMPANY 
			WHERE
			<cfif isdefined('session.ep')> 
				COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
			<cfelseif isdefined('session.pp')>
				COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
			<cfelseif isdefined('session.ww')>
				COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">
			</cfif>
		</cfquery>
		<cfif len(get_comp_addr.ASSET_FILE_NAME2)>
			<cfset attributes.mail_logo = "documents/settings/"&get_comp_addr.asset_file_name2>
		<cfelse>
			<cfset attributes.mail_logo = "documents/templates/info_mail/logobig.gif">
		</cfif> 
		
		<cfmail
			to="#get_employee_info.EMPLOYEE_EMAIL#"
			from="#session.ep.company#<#session.ep.company_email#>"
			subject="Work Share" 
			type="HTML">
			<style>
				.bold
				{
				font-size:12px;
				font-family:Verdana, Arial, Helvetica, sans-serif;
				font-weight:bold;
				}
				.grey
				{
				font-family:Verdana, Arial, Helvetica, sans-serif;
				font-size:10px;
				color:999999;
				}
				.unbold
				{
				font-size:12px; 
				font-family:Verdana, Arial, Helvetica, sans-serif;
				}
				.header
				{
				font-family:Verdana, Arial, Helvetica, sans-serif;
				font-size:15px;
				}
				</style>
				<cfoutput>
					<html>
						<body>
							<table cellpadding="0" cellspacing="0" align="center" width="800">
								<tr>
									<td align="center"><img border="0" src="#user_domain#/#attributes.mail_logo#"/></td>
								</tr>
								<tr>
									<td>&nbsp;</td>
								</tr>
								<tr bgcolor="FFFFFF">
									<td>
										<table>
											<tr bgcolor="FFFFFF">
												<td>
												<table>
													<tr>
														<td colspan="2" class="header">	
														<br/>
														<cf_get_lang dictionary_id="58780.Sayın"> #get_employee_info.EMPLOYEE_NAME# #get_employee_info.EMPLOYEE_SURNAME#,
														<br>
														<cf_get_lang dictionary_id="52121.Workcube'de adınıza yapılmış bir kayıt bulunmaktadır">
														</td>
													</tr><br/><br>
													<tr>
														<td class="bold"><cf_get_lang dictionary_id="57480.Konu"> : </td>
														<td class="unbold"><a href="#fusebox.server_machine_list#/#attributes.url_link#&wrkflow=1#(IsDefined("attributes.access_code") and len(attributes.access_code)) ? '&wsr_code=' & attributes.access_code : ''#">Work Share '#attributes.notice_type eq 1 ? getLang(dictionary_id:61602) : getLang(dictionary_id:61601)#'</a></td>
													</tr>
													<tr>
														<td valign="top" class="bold"><cf_get_lang dictionary_id="57629.Açıklama"> : </td>
														<td class="unbold">#attributes.warning_description#</td>
													</tr>
													<cfif IsDefined("warning_password") and len(warning_password)>
														<tr>
															<td valign="top" class="bold"><cf_get_lang dictionary_id="61098.Bildirimi görüntülemek için kullanılacak şifreniz"> : </td>
															<td class="unbold">#warning_password#</td>
														</tr>
													</cfif>
													<tr>
														<td colspan="1">
															<table>
																<tr valign="middle">
																	<td style="width:20px;">&nbsp;</td>
																	<td class="grey"><cf_get_lang dictionary_id="57483.Kayıt">: #session.ep.name# #session.ep.surname# #dateformat(now(),dateformat_style)#</td>
																</tr>
															</table>
														</td>
													</tr>
													<cfif get_comp_addr.recordcount>
														<tr>
															<td colspan="2" class="unbold" style="font-size:12px;">
															#get_comp_addr.company_name#<br>
															#get_comp_addr.address#<br>
															<cf_get_lang dictionary_id="57499.Tel">: #get_comp_addr.tel_code# #get_comp_addr.tel# <cf_get_lang dictionary_id="57488.Fax">: #get_comp_addr.tel_code# #get_comp_addr.fax#<br>
															<a href="//#get_comp_addr.web#">#get_comp_addr.web#</a>
															</td>
														</tr>
													</cfif>
												</table>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</body>
					</html>
				</cfoutput>
		</cfmail>
	</cfif>
</cfloop>

<script type="text/javascript">
	window.location.href = "<cfoutput>#attributes.url_link#</cfoutput>";
</script>