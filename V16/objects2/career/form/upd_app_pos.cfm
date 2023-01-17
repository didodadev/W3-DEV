
<!--- İlan Başvuru Detayı Partner --->
<!--- TODO: arayüzü düzenlenecek. --->

<cfset get_components_partner = createObject("component", "V16.objects2.career.cfc.data_career_partner")>
<cfset get_components = createObject("component", "V16.objects2.career.cfc.data_career")>
<cfset get_app = get_components_partner.get_app(
	app_pos_id: attributes.app_pos_id,
	company_id: session.pp.company_id
)>

<cfif isdefined('attributes.empapp_id')>
  <cfset get_empapp = get_components.GET_APP(empapp_id : attributes.empapp_id)>
</cfif>

<cfif get_app.recordcount or get_empapp.recordcount>
	<cfset get_moneys = get_components.get_moneys(period_id: session.pp.period_id)>
	<cfset get_commethods = get_components.GET_COMMETHODS()>
<cfif get_app.recordcount>
	  	<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
		  <tr>
			<td class="headbold" height="25"><cf_get_lang dictionary_id='34747.Application'> :
			  <cfif IsDefined('get_empapp') and get_empapp.recordcount>
				<cfoutput>#get_empapp.name# #get_empapp.surname#</cfoutput>
			  </cfif>
			 </td>
			<!--- <td style="text-align:right;">
				<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_print_files&iid=#app_pos_id#&print_type=171</cfoutput>','page','workcube_print');"><img src="/images/print.gif" alt="<cf_get_lang_main no='62.Yazdır'>" border="0"></a>
			</td> --->
		  </tr>
		  <tr>
			<td valign="top">
				<table width="98%" cellpadding="2" cellspacing="1" border="0" class="color-border">
				  <tr>
					<td class="color-row">
					  <table>
						  <input type="hidden" value="<cfoutput>#attributes.app_pos_id#</cfoutput>" name="app_pos_id" id="app_pos_id">
						  <input type="hidden" value="<cfoutput>#get_app.empapp_id#</cfoutput>" name="empapp_id" id="empapp_id">
						  <tr>
							<td height="20" class="txtbold"><cf_get_lang dictionary_id='35072.Job Posting'> :</td>
							<td class="txtbold" colspan="3">
								<cfset get_notice = get_components_partner.get_notice(notice_id: get_app.notice_id)>
								<cfoutput>#get_notice.NOTICE_NO#-#get_notice.NOTICE_HEAD#</cfoutput>
							</td>
						  </tr>
						  <tr>
							<td width="100" class="txtbold" height="20"><cf_get_lang dictionary_id='35221.Application No.'> :</td>
							<td><cfoutput>#get_app.app_pos_id#</cfoutput>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<cfif get_app.app_pos_status eq 1><cf_get_lang_main no='81.Aktif'><cfelse>Pasif</cfif>
							</td>
							<td width="100" class="txtbold"><cf_get_lang dictionary_id='34789.Application Date'> :</td>
							<td><cfoutput>#dateformat(get_app.app_date,'dd/mm/yyyy')#</cfoutput></td>
						  </tr>
						  <tr>
							<td class="txtbold" height="20"><cf_get_lang dictionary_id='58497.Position'> :</td>
							<td><!--- <cfoutput>#get_position.position_name#</cfoutput> ---></td>
							<td class="txtbold"><cf_get_lang dictionary_id='35074.Requested Salary'> :</td>
							<td><cfif len(get_app.salary_wanted)><cfoutput>#TLFormat(get_app.salary_wanted)# #get_app.salary_wanted_money#</cfoutput></cfif></td>
						  </tr>
						  <tr>
							<td class="txtbold" height="20"><cf_get_lang dictionary_id='35222.Approval Status'> :</td>
							<td width="150"><cfoutput>#get_par_info(get_app.validator_par,0,0,0)#</cfoutput></td>
							<td class="txtbold"><cf_get_lang dictionary_id='35227.Employment Start Date'> :</td>
							<td><cfoutput>#dateformat(get_app.STARTDATE_IF_ACCEPTED,'dd/mm/yyyy')#</cfoutput></td>
						  </tr>
						  <tr>
							<td class="txtbold" height="20"><cf_get_lang dictionary_id='58649.Cover Letter'> :</td>
							<td colspan="3"><cfif len(get_app.detail)><cfoutput>#get_app.detail#</cfoutput></cfif></td>
						  </tr>
					  </table>
					</td>
				  </tr>
				</table>
			  	<br/>
				<cfinclude template="../display/dsp_cv_partner.cfm">
			</td>
			<td width="220" valign="top" id="sag">
		    <!--- Yazışma --->
			  	<table cellspacing="1" cellpadding="2" width="98%" border="0" class="color-border">
					<tr class="color-header" height="22">
						<td class="form-title"><cf_get_lang_main no='47.Yazışmalar'></td>
						<td width="15">
							<a href="javascript://" title="<cf_get_lang dictionary_id='32254.Add Correspondence'>" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_app_add_mail&empapp_id=#attributes.empapp_id#&app_pos_id=#attributes.app_pos_id#</cfoutput>','large');">
								<img src="/images/plus_square.gif" border="0" alt="<cf_get_lang dictionary_id='32254.Add Correspondence'>" />
							</a>
						</td>
					</tr>
					<cfset GET_EMPAPP_MAIL = get_components.GET_EMPAPP_MAIL(
						empapp_id: attributes.EMPAPP_ID,
						app_pos_id: attributes.app_pos_id
					)>
					<cfif isDefined("GET_EMPAPP_MAIL") and GET_EMPAPP_MAIL.recordcount>
						<cfoutput query="GET_EMPAPP_MAIL">
							<tr class="color-row">
								<td>#GET_EMPAPP_MAIL.MAIL_HEAD#</td>
								<td>
									<a href="javascript://" title="<cf_get_lang dictionary_id='59844.Correspondence Update'>"  onClick="windowopen('#request.self#?fuseaction=objects2.popup_upd_app_mail&empapp_id=#attributes.empapp_id#&EMP_APP_MAIL_ID=#EMP_APP_MAIL_ID#','large');">
										<img src="/images/update_list.gif" alt="<cf_get_lang dictionary_id='59844.Correspondence Update'>" border="0" />
									</a>
								</td>
							</tr>
						</cfoutput>
					</cfif>
					<cfif isDefined("GET_EMPAPP_MAIL") and (GET_EMPAPP_MAIL.recordcount eq 0)>
						<tr>
						<td colspan="2" class="color-row"><cf_get_lang dictionary_id='57484.No record'>!</td>
						</tr>
					</cfif>
				</table>
				<!--- Yazısma Bitis --->
				<br/>
		<!--- belgeler --->
		<cf_get_workcube_asset asset_cat_id="-8" module_id='3' is_add='0' action_section='EMPLOYEES_APP_ID' action_id='#empapp_id#'>
		<!--- belgeler --->
		<br/>
		<!--- Notlar --->
		<cf_get_workcube_note action_section='EMPLOYEES_APP_ID' company_id="#session.pp.our_company_id#" action_id='#empapp_id#' style='1'>
		<!--- Notlar --->
	  <br/>
	  <!--- Başvurular --->
	  	<cfset get_app_pos = get_components_partner.get_app(
			app_pos_id: attributes.app_pos_id,
			company_id: session.pp.company_id,
			not_app_pos: 1,
			empapp_id: get_app.empapp_id
		)>
	  	<table width="100%" align="center" cellpadding="2" cellspacing="1" border="0" class="color-border">
			<tr class="color-header" height="22">
				<td class="form-title"><cf_get_lang dictionary_id='35223.All Applications'></td>
			</tr>
			<cfif get_app_pos.recordcount>
				<cfoutput query="get_app_pos">
					<tr class="color-row">
						<td><cf_get_lang dictionary_id='35221.Application No.'>: <a href="#request.self#?fuseaction=objects2.upd_app_pos&empapp_id=#get_app.empapp_id#&app_pos_id=#app_pos_id#" class="tableyazi">#get_app_pos.app_pos_id#</a> -
						<cfif get_app_pos.app_pos_status eq 1><cf_get_lang dictionary_id='57493.Active'><cfelse><cf_get_lang dictionary_id='57494.Passive'></cfif>
						<br/>
						<cf_get_lang dictionary_id='57742.Date'> #DateFormat(get_app_pos.app_date,'dd/mm/yyyy')# </td>
						<td><a href="#request.self#?fuseaction=objects2.upd_app_pos&empapp_id=#get_app.empapp_id#&app_pos_id=#app_pos_id#" title="<cf_get_lang dictionary_id='31960.Update Application'>"><img src="../../images/update_list.gif" border="0" alt="<cf_get_lang dictionary_id='31960.Update Application'>" /></a></td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr class="color-row">
				<td colspan="7"><cf_get_lang dictionary_id='57484.No record'>!</td>
				</tr>
		  </cfif>
		</table>
	  </td>
	</tr>
  </table>
<cfelse>
&nbsp;&nbsp;<cf_get_lang dictionary_id='57484.No record'>
</cfif>
<cfelse>
	<strong><cf_get_lang dictionary_id='35224.Record may have been deleted Details can not be displayed'>..</strong>
</cfif>

