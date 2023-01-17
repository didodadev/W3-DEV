<cfset xfa.upd = "campaign.popup_upd_campaign">
<cfset xfa.del = "campaign.popup_del_campaign">
<cfinclude template="../query/get_camp_email_conts.cfm">
<cfinclude template="../query/get_camp_sms_conts.cfm">
<cfinclude template="../query/get_camp_tmarkets.cfm">
<cfinclude template="../query/get_campaign_cats.cfm">
<cfinclude template="../query/get_campaign_stages.cfm">
<cfinclude template="../query/get_campaign.cfm">
<cfquery name="GET_CAMP_TYPES" datasource="#DSN3#">
	SELECT CAMP_TYPE_ID, CAMP_TYPE FROM CAMPAIGN_TYPES
</cfquery>
<cfquery name="GET_COMPANY_CAT" datasource="#dsn#">
	SELECT COMPANYCAT_ID, COMPANYCAT FROM COMPANY_CAT
</cfquery>
<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT CONSCAT_ID, CONSCAT FROM CONSUMER_CAT ORDER BY CONSCAT
</cfquery>
<cfset attributes.project_id = campaign.project_id>
<cfif len(attributes.project_id)>
	<cfinclude template="../query/get_project_head.cfm">
</cfif>
<cfform name="upd_camp" method="post" action="#request.self#?fuseaction=#xfa.upd#">
<input type="hidden" name="camp_id_" id="camp_id_" value="<cfoutput>#camp_id#</cfoutput>">
<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
	<tr>
		<td class="headbold" height="35"><cf_get_lang dictionary_id='57446.Kampanya'>: <cfoutput>#campaign.camp_head#</cfoutput></td>
		<td colspan="2" style="text-align:right;">
			<cfoutput>
			<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=campaign.popup_camp_maillist&camp_id=#attributes.camp_id#','list');"><img src="/images/mail.gif" title="<cf_get_lang dictionary_id ='32440.Mail Listesi'>" border="0"></a>
			<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=campaign.list_campaign&event=upd&action_name=camp_id&action_id=#attributes.camp_id#','list');"><img src="/images/uyar.gif" title="<cf_get_lang dictionary_id='57757.Uyarılar'>" border="0"></a>
			<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=campaign.popup_dsp_promotions_actions&camp_id=#camp_id#</cfoutput>','medium')"><img src="/images/promo.gif" title="<cf_get_lang dictionary_id ='42657.Promosyon'>&<cf_get_lang dictionary_id='33119.Aksiyon'>"  border="0"></a>
			<cfif len(attributes.project_id) and get_project_head.recordcount>
				<a href="#request.self#?fuseaction=project.projects&event=det&id=#attributes.project_id#"><img src="/images/cizelge.gif" title="<cf_get_lang dictionary_id='49527.Proje Detayı'>" border="0"></a>
			<cfelse>
				<a href="#request.self#?fuseaction=project.projects&event=add&camp_id=<cfoutput>#campaign.camp_id#</cfoutput>"><img src="/images/cizelge.gif" title="<cf_get_lang dictionary_id='49375.Proje Ekle'>" border="0"></a>
			</cfif>
			<!--- Üst Menüler --->
			<cfif not listfindnocase(denied_pages,'campaign.popup_form_add_email_cont')><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=campaign.popup_form_add_email_cont&camp_id=#camp_id#','page')"><img src="/images/content_plus.gif" title="<cf_get_lang dictionary_id='58142.İçerik Ekle'>" border="0"></a></cfif> 
			<cfif (not listfindnocase(denied_pages,'campaign.popup_form_add_sms_cont')) and (session.ep.our_company_info.sms eq 1)><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=campaign.popup_form_add_sms_cont&camp_id=#camp_id#','small');"><img src="/images/mobil.gif" border="0" title="<cf_get_lang dictionary_id='49381.SMS İçeriği Ekle'>"></a></cfif>
			<cfif not listfindnocase(denied_pages,'campaign.popup_list_target_markets')><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=campaign.popup_list_target_markets&camp_id=#camp_id#','list')"><img src="/images/target.gif" title="<cf_get_lang dictionary_id='49325.Hedef Kitle Ekle'>" border="0"></a></cfif>
			<cfif not listfindnocase(denied_pages,'campaign.list_campaign_target')><a href="#request.self#?fuseaction=campaign.list_campaign_target&camp_id=#camp_id#"><img src="/images/outsource.gif" title="<cf_get_lang dictionary_id='49382.Liste Yöneticisi'>" border="0"></a></cfif>
			<cfif not listfindnocase(denied_pages,'campaign.popup_form_add_member')><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=campaign.popup_form_add_member&campaign_id=#attributes.camp_id#</cfoutput>','medium');;"><img src="/images/partner_plus.gif" border="0" title="<cf_get_lang dictionary_id='60066.Kampanya Görevlisi Ekle'>"></a></cfif>
			<cfif not listfindnocase(denied_pages,'campaign.popup_list_campaign_paymethods')><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=campaign.popup_list_campaign_paymethods&campaign_id=#attributes.camp_id#</cfoutput>','medium');;"><img src="/images/money_plus.gif" border="0" title="<cf_get_lang dictionary_id='58516.Ödeme Yöntemleri'>"></a></cfif>
			<a href="#request.self#?fuseaction=campaign.list_campaign&event=add"><img src="/images/plus1.gif" align="absmiddle" title="<cf_get_lang dictionary_id ='44630.Ekle'>" border="0"></a>
			</cfoutput>
			<cf_np tablename="campaigns" primary_key="camp_id" pointer="camp_id=#camp_id#" dsn_var="DSN3"> 
		</td>
	</tr>
</table>
<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
	<tr>
		<td valign="top">
		<table class="color-border" cellspacing="1" cellpadding="2" width="98%" border="0">
			<tr class="color-row">
				<td valign="top" width="160">
					<div id="cont" style="position:absolute;width:99%;height:310px;z-index:1;overflow:auto;">
						<table>
							<tr>
								<td class="txtboldblue"><cf_get_lang dictionary_id='54982.Partner Portal'></td>
							</tr>
							<cfoutput query="get_company_cat">
								<tr>
									<td nowrap="nowrap">
										<input type="Checkbox"  name="comp_cat" id="comp_cat" value="#COMPANYCAT_ID#" <cfif listfind(CAMPAIGN.COMPANY_CAT,COMPANYCAT_ID)> checked </cfif>>#companycat#
									</td>
								</tr>
							</cfoutput>
							<tr>
								<td nowrap="nowrap">
									<input type="checkbox" name="is_extranet" id="is_extranet" value="1" <cfif CAMPAIGN.IS_EXTRANET eq 1>checked</cfif>><cf_get_lang dictionary_id='58019.Extranet'>
								</td>
							</tr>
							<tr>
								<td class="txtboldblue"><cf_get_lang dictionary_id='54981.Public Portal'></td>
							</tr>
							<tr>
								<td valign="top">
									<cfoutput query="GET_CONSUMER_CAT">
										<input type="Checkbox" name="cons_cat" id="cons_cat" value="#CONSCAT_ID#"<cfif listfind(CAMPAIGN.CONSUMER_CAT,CONSCAT_ID)> checked </cfif>>#CONSCAT#<br/>
									</cfoutput>
								</td>	
							</tr>
							<tr>
								<td>
									<input type="checkbox" name="is_internet" id="is_internet" value="1" <cfif CAMPAIGN.IS_INTERNET eq 1>checked</cfif>><cf_get_lang dictionary_id='58079.İnternet'>
								</td>
							</tr>		
						</table>
					</div>
				</td>
				<td valign="top">
				<table>
					<tr>
						<td width="90"><cf_get_lang dictionary_id='57493.Aktif'></td>
						<td width="190"><input type="checkbox" name="camp_status" id="camp_status" value="1" <cfif campaign.camp_status eq 1>checked</cfif>></td>
						<td width="70"><cf_get_lang dictionary_id='42406.Kampanya No'></td>
						<td><input type="text" name="camp_no" id="camp_no" style="width:170px;" value="<cfoutput>#campaign.camp_no#</cfoutput>"></td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id='57486.Kategori'> *</td>
						<td>
							<select name="camp_type" id="camp_type" style="width:170px;" onChange="redirect(this.options.selectedIndex);">
								<option value=""><cf_get_lang dictionary_id='59088.Tip'></option>
								<cfoutput query="get_camp_types">
									<option value="#camp_type_id#" <cfif camp_type_id eq campaign.camp_type>selected</cfif>>#camp_type#</option>
								</cfoutput>
							</select>
						</td>
						<td><cf_get_lang dictionary_id ='34194.Alt Kategori'> *</td>
						<td>	
							<select name="camp_cat_id" id="camp_cat_id" style="width:170px;">
								<cfoutput query="get_campaign_cats">
									<option value="#camp_cat_id#" <cfif campaign.camp_cat_id eq camp_cat_id>selected</cfif>>#camp_cat_name# 
								</cfoutput>
							</select>
						</td>
					</tr>
					<tr height="22">
						<td><cf_get_lang dictionary_id='58859.Süreç'></td>
						<td><cf_workcube_process is_upd='0' select_value='#campaign.PROCESS_STAGE#' process_cat_width='170' is_detail='1'></td>
						<td><cf_get_lang dictionary_id='49344.İlgili Proje'></td>
						<td>
							<input type="Hidden" name="project_id" id="project_id" value="<cfoutput>#campaign.project_id#</cfoutput>">
							<input type="text" name="project_head" id="project_head" style="width:170px;" value="<cfif len(attributes.project_id) AND GET_PROJECT_HEAD.RecordCount><cfoutput>#GET_PROJECT_HEAD.PROJECT_HEAD#</cfoutput></cfif>">
							<a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_id=upd_camp.project_id&project_head=upd_camp.project_head</cfoutput>');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a> 
						</td>
					</tr>
					<tr height="22">
						<td> <cf_get_lang dictionary_id='57655.Başlama Tarihi'>*</td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58745.Başlama Tarihi Girmelisiniz !'></cfsavecontent>
							<cfif isdate(campaign.camp_startdate)>
								<cfinput type="text" name="camp_startdate" style="width:65px;" required="Yes" validate="#validate_style#" message="#message#" value="#dateformat(date_add('h',session.ep.time_zone,campaign.camp_startdate),dateformat_style)#">
							<cfelse>
								<cfinput type="text" name="camp_startdate" style="width:65px;" required="Yes" validate="#validate_style#" message="#message#" value=""><strong></strong>
							</cfif>
							<cf_wrk_date_image date_field="camp_startdate">
							<select name="camp_start_hour" id="camp_start_hour" style="width:40px;">
								<cfloop from="1" to="23" index="i">
									<cfoutput>
										<option value="#i#" <cfif len(campaign.camp_startdate) and (timeformat(campaign.camp_startdate,'HH')+session.ep.time_zone is i)>selected</cfif>>#i#</option>
									</cfoutput>
								</cfloop>
								<option value="0" <cfif len(campaign.camp_startdate) and timeformat(campaign.camp_startdate,'HH')+session.ep.time_zone is 0> selected</cfif>>24</option>
							</select>
							<select name="camp_start_min" id="camp_start_min">
								<cfloop from="0" to="55" index="a" step="5">
									<cfoutput><option value="#Numberformat(a,00)#" <cfif len(campaign.camp_startdate) and (#timeformat(campaign.camp_startdate,'mm')# is a)>selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
								</cfloop>			  
							</select>
						</td>
						<td><cf_get_lang dictionary_id='57700.Bitiş Tarihi'>*</td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
							<cfif isdate(campaign.camp_finishdate)>
								<cfinput type="text" name="camp_finishdate" style="width:65px;" required="Yes" validate="#validate_style#" message="#message#" value="#dateformat(date_add('h',session.ep.time_zone,campaign.camp_finishdate),dateformat_style)#">
							<cfelse>
								<cfinput type="text" name="camp_finishdate" style="width:65px;" required="Yes" validate="#validate_style#" message="#message#" value="">
							</cfif>
							<cf_wrk_date_image date_field="camp_finishdate">
							<select name="camp_finish_hour" id="camp_finish_hour" style="width:40px;">
								<cfloop from="1" to="23" index="i">
									<cfoutput>
										<option value="#i#" <cfif len(campaign.camp_finishdate) and (timeformat(campaign.camp_finishdate,'HH')+session.ep.time_zone is i)> selected</cfif>>#i#</option>
									</cfoutput>
								</cfloop>
								<option value="0" <cfif len(campaign.camp_finishdate) and (timeformat(campaign.camp_finishdate,'HH')+session.ep.time_zone is 0)>selected</cfif>>24</option>
							</select>
							<select name="camp_finish_min" id="camp_finish_min">
								<cfloop from="0" to="55" index="a" step="5">
									<cfoutput><option value="#Numberformat(a,00)#" <cfif len(campaign.camp_finishdate) and (#timeformat(campaign.camp_finishdate,'mm')# is a)>selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
								</cfloop>
							</select>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id='57480.Başlık'>*</td>
						<td colspan="4">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='31595.Lütfen başlık girmelisin'></cfsavecontent>
							<cfinput type="text" name="camp_head" style="width:440;" value="#campaign.camp_head#" required="Yes" message="#message#">
						</td>
					<tr>
					<tr>
						<td valign="top"><cf_get_lang dictionary_id='55474.Amaç'></td>
						<td colspan="4"><textarea name="camp_objective" id="camp_objective" style="width:440;height:130px;"><cfoutput>#campaign.camp_objective#</cfoutput></textarea></td>
					</tr>
					<tr height="22">
						<td><cf_get_lang dictionary_id='49336.Lider'></td>
						<td>
							<cfif len(campaign.leader_position_code)>
								<cfset attributes.position_code = campaign.leader_position_code>
								<cfinclude template="../query/get_position.cfm">
								<input type="Hidden" name="leader_position_code" id="leader_position_code" value="<cfoutput>#campaign.leader_position_code#</cfoutput>">
								<input type="text" name="leader_position" id="leader_position" style="width:170px;"  readonly value="<cfoutput>#get_position.employee_name# #get_position.employee_surname#</cfoutput>">
							<cfelse>
								<input type="Hidden" name="leader_position_code" id="leader_position_code" value="">
								<input type="text" name="leader_position" id="leader_position" style="width:170px;" readonly value="">
							</cfif>
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1,2,3&field_code=upd_camp.leader_position_code&field_name=upd_camp.leader_position</cfoutput>','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
						</td>
						<td colspan="2"  style="text-align:right;">
						<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=#xfa.del#&camp_id=#attributes.camp_id#&cat=#campaign.camp_type#&head=#campaign.camp_head#'add_function='kontrol()'>
						&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<tr>
					<tr>
						<td colspan="4">
							<cfif campaign.recordcount>
								<cfset emp_list = ''>
								<cfoutput query="campaign">
									<cfif len(record_emp) and not listfind(emp_list,record_emp)>
										<cfset emp_list=listappend(emp_list,record_emp)>
									</cfif>
									<cfif len(update_emp) and not listfind(emp_list,update_emp)>
										<cfset emp_list=listappend(emp_list,update_emp)>
									</cfif>
								</cfoutput>
								<cfif len(emp_list)>
									<cfquery name="employee" datasource="#dsn#">
										SELECT EMPLOYEE_ID, EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#emp_list#) ORDER BY EMPLOYEE_ID
									</cfquery>
									<cfset emp_list = listsort(listdeleteduplicates(valuelist(employee.employee_id,',')),'numeric','ASC',',')>
								</cfif>
								<cf_get_lang dictionary_id='71.Kayit'>:
								<cfif len(campaign.record_date)>
									<cfoutput query="campaign">
									 	#employee.employee_name[listfind(emp_list,record_emp,',')]# #employee.employee_surname[listfind(emp_list,record_emp,',')]# -
										#dateformat(date_add('h',session.ep.time_zone,campaign.record_date),dateformat_style)# -
										#timeformat(date_add('h',session.ep.time_zone,campaign.record_date),timeformat_style)#
									</cfoutput>
								</cfif>
								<cfif len(campaign.update_date)>
									<cf_get_lang dictionary_id='291.Güncelleme'>:
									<cfoutput query="campaign"> 
										#employee.employee_name[listfind(emp_list,update_emp,',')]# #employee.employee_surname[listfind(emp_list,update_emp,',')]# -
										#dateformat(date_add('h',session.ep.time_zone,campaign.update_date),dateformat_style)# -
										#timeformat(date_add('h',session.ep.time_zone,campaign.update_date),timeformat_style)#
									</cfoutput>
								</cfif>	
							</cfif>
						</td>
					</tr>
				</table>
				</td>
			</tr>  
		</table>
		<br/>
		<!--- CONTENTS --->
		<table cellpadding="0" cellspacing="1" border="0" width="98%" class="color-border">
			<tr class="color-list" height="25">
				<td class="txtboldblue" colspan="2">&nbsp;<cf_get_lang dictionary_id ='33830.Kampanya İçerikleri'></td>
			</tr>
			<cfoutput query="camp_sms_conts">
				<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					<td width="98%">
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=campaign.popup_form_upd_sms_cont&sms_cont_id=#sms_cont_id#','small');" class="tableyazi">#sms_body#</a> -
						<cf_get_lang dictionary_id='49523.Sms'>
					</td>
					<td width="15" align="center">
						<cfif is_sent eq 1>
							<img src="/images/start_grey.gif" border="0" title="<cf_get_lang dictionary_id='49525.Gönderildi'>">
						<cfelse>
							<cfif not campaign.camp_stage_id eq -1>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=campaign.popup_list_target_masses&sms_cont_id=#sms_cont_id#&camp_id=#camp_id#&goal=sms','small');"><img src="/images/start.gif" border="0" title="<cf_get_lang dictionary_id='58743.Gönder'>"></a>
							</cfif>
						</cfif>
					</td>
				</tr>
			</cfoutput>
			<cfif ListLEn(CAMP_TMARKETS.TMARKET_ID)>
					<cfset target_list = ValueList(CAMP_TMARKETS.TMARKET_ID) & ',-1'>
			<cfelse>
					<cfset target_list = '-1'>
			</cfif>
			<cfif camp_email_conts.recordcount>
			<cfoutput query="camp_email_conts">
				<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					<td width="98%">
						&nbsp;<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=campaign.popup_form_upd_email_cont&email_cont_id=#email_cont_id#&camp_id=#camp_id#','page');" class="tableyazi">#email_subject#</a>
					</td>
					<td width="15" align="center">
						<cfset is_mail_sent = 1>
						<cfloop from="1" to="#ListLen(target_list)#" index="ind">
							<cfif not ListContains(SENDED_TARGET_MASS, ListGetAt(target_list, ind))>
								<cfset is_mail_sent = 0>
							<cfbreak>
							</cfif>
						</cfloop>
						<cfif is_mail_sent>
							<img src="/images/start_grey.gif" border="0" title="<cf_get_lang dictionary_id='49525.Gönderildi'>">
						<cfelse>
							<cfif not campaign.camp_stage_id eq -1>
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=campaign.popup_list_target_masses&email_cont_id=#email_cont_id#&camp_id=#camp_id#&goal=email','small');"><img src="/images/start.gif" border="0" title="<cf_get_lang dictionary_id='58743.Gönder'>"></a>
							</cfif>
						</cfif>
					</td>
				</tr>
			</cfoutput>
			<cfelse>
			<tr class="color-row" height="20">
				<td colspan="2">&nbsp;<cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
			</tr>
			</cfif>
		</table>
		<td valign="top" width="220">
		<!--- Sağ Menü --->
		<!--- <br/> --->
        
		<!--- <table cellspacing="1" cellpadding="2" width="98%" border="0" class="color-border">
			<tr class="color-header" height="22" >
				<td class="form-title" width="100%"><cf_get_lang no='43.Hedef Kitle'></td>
				<td nowrap width="40">
					<a href="<cfoutput>#request.self#?fuseaction=campaign.form_add_target_market&camp_id=#camp_id#</cfoutput>"><img src="/images/plus_square.gif" border="0" align="absmiddle" alt="<cf_get_lang no='49.Yeni Hedef Kitle Oluştur'>"></a>
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=campaign.popup_list_target_markets&camp_id=#camp_id#</cfoutput>','list')"><img src="/images/report_square.gif" border="0" alt="<cf_get_lang no='5.Hedef Kitle Ekle'>" align="absmiddle"></a>
				</td>
			</tr>
			<cfoutput query="camp_tmarkets">
				<cfset attributes.tmarket_id = tmarket_id>
				<cfinclude template="../query/get_target_markets.cfm">
				<cfset 'cons_#attributes.tmarket_id#' =0>
				<cfset 'par_#attributes.tmarket_id#' =0>
				<cfif tmarket.target_market_type eq 0 or tmarket.target_market_type eq 2>
					<cfinclude template="../query/get_tmarket_consumers.cfm">
					<cfset 'cons_#attributes.tmarket_id#' = get_tmarket_users.recordcount>
				</cfif>
				<cfif tmarket.target_market_type eq 0 or tmarket.target_market_type eq 1>
					<cfinclude template="../query/get_tmarket_partner_ids.cfm">
					<cfset 'par_#attributes.tmarket_id#' = get_tmarket_partners.recordcount>
				</cfif>
				<cfset total_no = evaluate("cons_#attributes.tmarket_id#") + evaluate("par_#attributes.tmarket_id#")>				
				<tr class="color-row">
					<td>
						<a href="#request.self#?fuseaction=campaign.list_target_list&tmarket_id=#tmarket_id#&camp_id=#camp_id#" class="tableyazi">#tmarket_name# - #total_no# (#evaluate("par_#attributes.TMARKET_ID#")# / #evaluate("cons_#attributes.TMARKET_ID#")#)</a><br/>
					</td>
					<td>
						<a href="#request.self#?fuseaction=campaign.form_upd_target_market&tmarket_id=#tmarket_id#&camp_id=#camp_id#" class="tableyazi"><img src="/images/update_list.gif" border="0" alt="Güncelle"></a>
						<a href="javascript://" onClick="javascript:if (confirm('Kayıtlı Hedef Kitleyi Siliyorsunuz. Emin misiniz?')) windowopen('#request.self#?fuseaction=campaign.popup_del_camp_tmarket&tmarket_id=#tmarket_id#&camp_id=#camp_id#','small'); else return false;"><img src="/images/delete_list.gif" border="0" alt="Sil"></a>
					</td>
				</tr>
			</cfoutput>
		</table> --->
			    <!---Hedef Kitle--->
                <
                	cf_show_ajax 
                    title="Hedef Kitle" 
                    class_type="1" 
                    page_style="off" 
                    tr_id="list_target_markets" 
                    add_buton_url="#request.self#?fuseaction=campaign.form_add_target_market&camp_id=#camp_id#"
                    add_buton_url2="#request.self#?fuseaction=campaign.popup_list_target_markets&camp_id=#camp_id#"
                    page_url="#request.self#?fuseaction=campaign.emptypopup_list_target_markets_ajax&camp_id=#camp_id#" 
                >
                <!---Ekip ---->
                <
                	cf_show_ajax 
                    title="Ekip" 
                    class_type="1" 
                    page_style="off" 
                    tr_id="list_correspondence1_menu" 
                    add_buton_url="#request.self#?fuseaction=campaign.popup_form_add_member&campaign_id=#attributes.camp_id#"
                    page_url="#request.self#?fuseaction=campaign.emptypopup_form_add_campaign_team_ajax&camp_id=#attributes.camp_id#" 
                >
                <!---Anketler--->
				<cf_show_ajax 
                    title="Anketler" 
                    class_type="1" 
                    page_style="off" 
                    tr_id="list_campaigns_survey" 
                    add_buton_url="#request.self#?fuseaction=campaign.popup_list_target_surveys&camp_id=#camp_id#&from_promotion=1"
                    page_url="#request.self#?fuseaction=campaign.emptypopup_list_campaigns_surveys_ajax&camp_id=#attributes.camp_id#" 
                > 
                
                <cf_get_workcube_content action_type ='CAMPAIGN_ID' company_id='#session.ep.company_id#' action_type_id ='#attributes.camp_id#' style='0' design='0'>
				<br/>
                
				<!--- <cfinclude template="list_campaigns_surveys.cfm"> ---> 
            	<cf_get_related_events action_section='CAMPAIGN_ID' action_id='#attributes.camp_id#' company_id='#session.ep.company_id#'>
	            <br/>
				<!--- Notlar --->
				<cf_get_workcube_note company_id="#session.ep.company_id#" action_section='CAMPAIGN_ID' action_id='#attributes.camp_id#'>
				<br/>
				<!--- Varlıklar --->
				<cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="-15" module_id='15' action_section='CAMPAIGN_ID' action_id='#attributes.camp_id#'>
		</td>	
	</tr>
</table>
</cfform>
<script type="text/javascript">
	var groups=document.upd_camp.camp_type.options.length;
	var group=new Array(groups);
	for (i=0; i<groups; i++)
		group[i]=new Array();
		group[0][0]=new Option("Kategori","");
		<cfset branch = ArrayNew(1)>
		<cfoutput query="get_camp_types">
			<cfset branch[currentrow]=#camp_type_id#>
		</cfoutput>
		<cfloop from="1" to="#ArrayLen(branch)#" index="indexer">
		<cfquery name="dep_names" datasource="#dsn3#">
			SELECT CAMP_CAT_NAME,CAMP_CAT_ID FROM CAMPAIGN_CATS WHERE CAMP_TYPE = #branch[indexer]# ORDER BY CAMP_CAT_ID
		</cfquery>
		<cfif dep_names.recordcount>
		<cfset deg = 0>
		<cfoutput>group[#indexer#][#deg#]=new Option("Kategori","");</cfoutput>
			<cfoutput query="dep_names">
				<cfset deg = currentrow>
					<cfif dep_names.recordcount>
						group[#indexer#][#deg#]=new Option("#camp_cat_name#","#camp_cat_id#");
					</cfif>
			</cfoutput>
		<cfelse>
		<cfset deg = 0>
		<cfoutput>
		group[#indexer#][#deg#]=new Option("<cf_get_lang dictionary_id='58947.Kategori Seçiniz'>","");
		</cfoutput>
	</cfif>
	</cfloop>
	
	var temp = document.upd_camp.camp_cat_id;
	function redirect(x)
	{
		for (m=temp.options.length-1;m>0;m--)
		temp.options[m]=null;
		for (i=0;i<group[x].length;i++)
			{
				temp.options[i]=new Option(group[x][i].text,group[x][i].value)
			}
	}

	function kontrol()
	{
		x = document.upd_camp.camp_type.selectedIndex;
		if (document.upd_camp.camp_type[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='49554.Lütfen Kampanya Tipi Giriniz '>!");
			return false;
		}
		
		x = document.upd_camp.camp_cat_id.selectedIndex;
		if (document.upd_camp.camp_cat_id[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='49555.Lütfen Kampanya Kategorisi Giriniz '> !");
			return false;
		}
		return unformat_fields();
	}
	
	function unformat_fields()
	{
		return date_check(upd_camp.camp_startdate,upd_camp.camp_finishdate,"<cf_get_lang dictionary_id='49487.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır !'>");
	}
</script>
