<!--- dosya eskiye döndüğü için yedeklerden geri alındı sorun olursa bildiriniz SM20120612 --->
<!--- Zorunlu Alanlar
attributes.mail_content_from
attributes.mail_content_to
--->
<cfparam name="attributes.mail_content_from" default="">
<cfparam name="attributes.mail_content_to" default="">
<cfparam name="attributes.mail_content_cc" default="">
<cfparam name="attributes.mail_content_bcc" default="">
<cfparam name="attributes.mail_content_subject" default="Konusuz!">
<cfparam name="attributes.mail_content_additor" default="Yetkili;">
<cfparam name="attributes.ReplyTo" default="">
<cfparam name="attributes.mail_content_link" default="">
<cfparam name="attributes.mail_content_link_info" default="">
<cfparam name="attributes.mail_content_info" default="bilgilendirme">
<cfparam name="attributes.mail_content_info2" default="">
<cfparam name="attributes.mail_content_param_file_list" default="">
<cfparam name="attributes.mail_record_emp" default="">
<cfparam name="attributes.mail_record_date" default="">
<cfparam name="attributes.mail_update_emp" default="">
<cfparam name="attributes.mail_update_date" default="">
<cfparam name="attributes.mail_company" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.participant" default="">
<cfparam name="attributes.mail_logo" default="">
<cfparam name="attributes.sub_info" default='Bu mail <a href="http://www.workcube.com/">Workcube ERP</a> altyapısı kullanılarak gönderilmiştir.'>
<cfparam name="attributes.process_stage_info" default="">
<cfparam name="attributes.add_content_info" default="">
<cfparam name="attributes.remainder" default="">
<cfif not isdefined("dsn")>
	<cfset dsn = caller.dsn>
	<cfset dsn_alias = caller.dsn_alias>
</cfif>
<cfif isdefined("attributes.data_source")>
	<cfset use_dsn_ = attributes.data_source>
<cfelse>
	<cfset use_dsn_ = dsn>
</cfif>
<cfif len(attributes.process_stage_info)>
	<cfquery name="GET_PROCESS_NAME" datasource="#use_dsn_#">
		SELECT STAGE FROM #dsn_alias#.PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = #attributes.process_stage_info#
	</cfquery>
</cfif>
<cfquery name="GET_COMP_ADDR" datasource="#use_dsn_#">
	SELECT 
		COMPANY_NAME,
		ADDRESS,
		TEL_CODE,
		TEL,
		FAX,
		WEB,
		ASSET_FILE_NAME2 
	FROM 
		#dsn_alias#.OUR_COMPANY 
	WHERE
	<cfif isdefined('session.ep')> 
        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
    <cfelseif isdefined('session.pp')>
        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
    <cfelseif isdefined('session.ww')>
        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">
    <cfelseif isdefined('session.mobile')>
        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.mobile.company_id#">
    <cfelseif isDefined("my_our_company_id_")>
        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#my_our_company_id_#">
    </cfif>
</cfquery>
<cfif len(get_comp_addr.ASSET_FILE_NAME2)>
	<cfset attributes.mail_logo = "documents/settings/"&get_comp_addr.asset_file_name2>
<cfelse>
	<cfset attributes.mail_logo = "documents/templates/info_mail/logobig.gif">
</cfif> 
<cfif len(attributes.mail_record_emp) and isNumeric(attributes.mail_record_emp)>
	<cfquery name="get_record_emp" datasource="#use_dsn_#">
		SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.mail_record_emp#">
	</cfquery>
</cfif>
<cfif len(attributes.mail_update_emp) and isNumeric(attributes.mail_update_emp)>
	<cfquery name="get_update_emp" datasource="#use_dsn_#">
		SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.mail_update_emp#">
	</cfquery>
</cfif>
<cfif Len(attributes.mail_content_to) and len(attributes.mail_content_from)>
	<cftry>
		<cfmail to="#attributes.mail_content_to#" from="#attributes.mail_content_from#" cc="#attributes.mail_content_cc#" bcc="#attributes.mail_content_bcc#" subject="#attributes.mail_content_subject#" type="HTML">
			<cfif not isdefined("user_domain")>
				<cfset user_domain = caller.user_domain>
			</cfif>
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
											<cf_get_lang dictionary_id="58780.Sayın"> #attributes.mail_content_additor#,
											<br>
											<cf_get_lang dictionary_id="52121.Workcube'de adınıza yapılmış bir kayıt bulunmaktadır"> : #attributes.mail_content_info# 
											<cfif len(attributes.remainder)>
											<br><strong>#attributes.remainder#</strong>
											</cfif>
											</td>
										</tr><br/><br>
										<tr>
											<td class="bold"><cf_get_lang dictionary_id="57480.Konu"> : </td>
											<td class="unbold"><cfif len(attributes.mail_content_link)><a href="#attributes.mail_content_link#">#attributes.mail_content_subject#</a><cfelse>#attributes.mail_content_subject#</cfif></td>
										</tr>
										<cfif len(attributes.process_stage_info)>
											<tr>
												<td class="bold"><cf_get_lang dictionary_id="57482.Aşama"> : </td>
												<td class="unbold">#get_process_name.stage#</td>
											</tr>
										</cfif>
										<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
											<cfquery name="get_comp_name" datasource="#use_dsn_#">
												SELECT FULLNAME FROM #dsn_alias#.COMPANY WHERE COMPANY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
											</cfquery>
											<tr>
												<td class="bold"><cf_get_lang dictionary_id="57519.Cari Hesap"> : </td>
												<td class="unbold"><a href="#user_domain#/#request.self#?fuseaction=objects.popup_com_det&company_id=#attributes.company_id#">#get_comp_name.fullname#</a></td>
											</tr>
										</cfif>
										<tr>
											<td class="bold"><cf_get_lang dictionary_id="57569.Görevli">/<cf_get_lang dictionary_id="57658.Üye"> : </td>
											<td class="unbold"><cfif isdefined('attributes.mail_staff') and len(attributes.mail_staff)>#attributes.mail_staff#<cfelse>#attributes.mail_content_additor#</cfif></td>
										</tr>
										<cfif Len(attributes.project_id) and len(attributes.project_head)>
											<tr>
												<td class="bold"><cf_get_lang dictionary_id="57416.Proje"> <cf_get_lang dictionary_id="57897.Adı"> : </td>
												<td class="unbold"><a href="#user_domain#/#request.self#?fuseaction=project.projects&event=det&id=#attributes.project_id#">#attributes.project_head#</a></td>
											</tr>
										</cfif>
										<cfif len(attributes.start_date) or len(attributes.finish_date)>
											<tr>
												<td class="bold"><cf_get_lang dictionary_id="57742.Tarih"> : </td>
												<td class="unbold"> #attributes.start_date# - #attributes.finish_date#</td>
											</tr>
										</cfif>
										<cfif Len(attributes.mail_content_info2)>
											<tr>
												<td valign="top" class="bold"><cf_get_lang dictionary_id="57629.Açıklama"> : </td>
												<td class="unbold">#REReplaceNoCase(attributes.mail_content_info2, "<[\/]?[^>]*>", "", "ALL")#<br>
											</tr>
											<cfif IsDefined("wsr_password") and len(wsr_password)>
												<tr>
													<td valign="top" class="bold"><cf_get_lang dictionary_id="61098.Bildirimi görüntülemek için kullanılacak şifreniz"> : </td>
													<td class="unbold">#wsr_password#</td>
												</tr>
											</cfif>
										</cfif>
                                        <cfif isDefined('attributes.event_place') and attributes.event_place eq 4> <!--- Event online ise: --->
                                            <tr>
                                                <td><cf_get_lang dictionary_id='30015.Online'> : </td>
                                                <td><a href="#attributes.place_online#" target="_blank">#attributes.place_online#</a></td>
                                            </tr>
                                        </cfif></td>
										<cfif len(attributes.participant)>
											<tr>
												<td class="bold" style="vertical-align:top"><cf_get_lang dictionary_id="57590.Katılımcılar"> : </td>
												<td>
													<table>
														<cfloop list="#attributes.participant#" delimiters="," index="i">
															<tr>
																<td class="unbold">#i#</td>
															</tr>
														</cfloop>
													</table>
												</td>
											</tr>
										</cfif>
										<cfif len(attributes.mail_record_emp) or len(attributes.mail_update_emp)>
											<tr>
												<td colspan="2">
													<table>
													<cfif len(attributes.mail_record_emp)>
														<tr valign="middle">
															<td style="width:20px;">&nbsp;</td>
															<td class="grey"><cf_get_lang dictionary_id="57483.Kayıt">: <cfif isNumeric(attributes.mail_record_emp)>#get_record_emp.employee_name# #get_record_emp.employee_surname# <cfelse>#attributes.mail_record_emp# </cfif> #attributes.mail_record_date#</td>
														</tr>
													</cfif>
													<cfif len(attributes.mail_update_emp)>
														<tr valign="middle">
															<td style="width:20px;">&nbsp;</td>
															<td class="grey"><cf_get_lang dictionary_id="57703.Güncelleme">:<cfif isNumeric(attributes.mail_update_emp)>#get_update_emp.employee_name# #get_update_emp.employee_surname# <cfelse> #attributes.mail_update_emp#</cfif> #attributes.mail_update_date#</td>
														</tr>
													</cfif>
													</table>
												</td>
											</tr>
										</cfif>
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
					<cfif isDefined("attributes.add_content_info") and Len(attributes.add_content_info)>
						<tr>
							<td colspan="2" align="center">#attributes.add_content_info#</td>
						</tr>
					</cfif>
					<tr>
						<td colspan="2" align="center" style="margin-bottom:0px; font-size:9px;"; class="unbold">#attributes.sub_info#</td>
					</tr>
				</table>
				<cfif len(attributes.ReplyTo)>
					<cfmailparam name = "Reply-To" value ="#attributes.ReplyTo#">
				</cfif>  
				<cfif listlen(attributes.mail_content_param_file_list,';')>
					<cfloop list="#attributes.mail_content_param_file_list#" index="ccc" delimiters=";">
						<cfmailparam file = "#ccc#">
					</cfloop>
				</cfif>
				</body>
				</html>
			</cfoutput>
		</cfmail>
		<cfcatch>
		</cfcatch>
	</cftry>
</cfif>