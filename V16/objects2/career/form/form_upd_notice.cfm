<cfset get_components = createObject("component", "V16.objects2.career.cfc.data_career_partner")>
<cfset get_notice = get_components.GET_NOTICE(notice_id : attributes.notice_id)>

<cfif not get_notice.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='35509.Olmayan bir ilana erişmeye çalışıyorsunuz'>");
		history.go(-1);
	</script>
</cfif>

<cfform name="upd_notice" method="post" enctype="multipart/form-data">
<table align="center" cellpadding="2" cellspacing="1" border="0" class="color-border" style="width:100%;">
	<input type="hidden" name="notice_id" id="notice_id" value="<cfoutput>#attributes.notice_id#</cfoutput>">
	<cfif not len(get_notice.valid)>
		<input type="hidden" name="valid" id="valid" value="">
	</cfif>
  	<tr> 
		<td class="color-row"> 
	  		<table>
	 	 		<tr>
					<td style="width:15%;"><cf_get_lang dictionary_id='35098.Job Posting No.'>*</td>
					<td>
                    	<cfsavecontent variable="message"><cf_get_lang dictionary_id='35099.İlan No Girmelisiniz'> !</cfsavecontent>
						<cfinput type="text" name="notice_no" id="notice_no" style="width:100px;" required="yes" value="#get_notice.notice_no#" message="#message#">
						&nbsp;&nbsp;<cf_get_lang dictionary_id='57493.Aktif'><input type="checkbox" name="status" id="status" value="1" <cfif get_notice.status eq 1>checked</cfif>>
					</td>
				  	<td style="width:15%;"><cf_get_lang_main no='70.Aşama'></td>
				  	<td>
                    	<select name="status_notice" id="status_notice" style="width:165px;">
							<option value="-1"<cfif get_notice.status_notice eq -1>selected</cfif>><cf_get_lang dictionary_id='35100.Hazırlık'></option>
							<option value="-2"<cfif get_notice.status_notice eq -2>selected</cfif>><cf_get_lang dictionary_id='29479.Yayın'></option>
					  	</select>
				  	</td>
				</tr>
				<tr> 
			  		<td><cf_get_lang_main no='68.İlan Başlığı'>*</td>
			  		<td colspan="3">
				  		<cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık Girmelisiniz'>!</cfsavecontent>
				  		<cfinput type="text" name="notice_head" id="notice_head" style="width:528px;" maxlength="100" required="yes" message="#message#" value="#get_notice.notice_head#">
			  		</td>
				</tr>
				<tr>
					<td><cf_get_lang no='781.Kadro Sayısı'></td>
					<cfsavecontent variable="alert"><cf_get_lang dictionary_id='35507.Kadro Sayısını Giriniz'></cfsavecontent>
					<td><cfinput type="text" name="staff_count" id="staff_count" validate="integer" value="#get_notice.count_staff#" style="width:150px;" maxlength="2" message="#alert#"></td>
					<td><cf_get_lang_main no='1085.Poziyon'></td>
					<td><cfinput type="text" name="app_position" id="app_position" style="width:165px;" value="#get_notice.position_name#"></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='31268.Bağlantı Kurulacak Kişi'></td>
				  	<td>
						<cfset get_emps_pars_cons = get_components.get_emps_pars_cons()>
			 			<select name="interview_par" id="interview_par" style="width:150px;">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="get_emps_pars_cons">
								<cfif type eq 3>
									<option value="#uye_id#,#comp_id#,#type#"<cfif get_notice.interview_par eq uye_id>selected</cfif>>#nickname# - #uye_name# #uye_surname#</option>
								</cfif>
							</cfoutput>
						</select>
		  			</td>
		  			<cfif not len(get_notice.valid) and (get_notice.validator_par neq session.pp.userid)>
		  				<td><cf_get_lang dictionary_id='30920.Onaylayacak'></td>
						<td>
							<select name="validator_par" id="validator_par" style="width:165px;">
								<option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
								<cfoutput query="get_emps_pars_cons">
									<cfif type eq 3>
										<option value="#uye_id#,#comp_id#,#type#"<cfif get_notice.validator_par eq uye_id>selected</cfif>>#nickname# - #uye_name# #uye_surname#</option>
									</cfif>
								</cfoutput>
							</select>
		  				</td>
					<cfelseif get_notice.validator_par eq session.pp.userid>
						<td></td>
						<td><input type="Image" src="/images/valid.gif" alt="<cf_get_lang_main no ='1063.Onayla'>" onclick="if (confirm('<cf_get_lang no='899.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir. Onaylamak istediðinizden emin misiniz'> ?')) {upd_notice.valid.value='1'} else {return false}" border="0">
							<input type="Image" src="/images/refusal.gif" alt="<cf_get_lang_main no='1049.Reddet'>" onclick="if (confirm('<cf_get_lang no='899.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir. Reddetmek istediðinizden emin misiniz'> ?')) {upd_notice.valid.value='0'} else {return false}" border="0">
						</td>
					</cfif>
		  			<cfif get_notice.valid eq 1>
						<td colspan="2">
							<cf_get_lang dictionary_id='58699.Onaylandı'> !
							<cfif len(get_notice.valid_par)>
								<cfoutput>#get_par_info(get_notice.valid_par,0,0,0)# - #dateformat(get_notice.valid_date,'dd/mm/yyyy')# (#timeformat(get_notice.valid_date,'HH:MM')#)</cfoutput>
							</cfif>
				 		</td>
					<cfelseif get_notice.valid eq 0>
		  				<td>
							<cf_get_lang dictionary_id='57617.Reddedildi'> !
							<cfif len(get_notice.valid_par)>
								<cfoutput>#get_par_info(get_notice.valid_par,0,0,0)# - #dateformat(get_notice.valid_date,'dd/mm/yyyy')# (#timeformat(get_notice.valid_date,'HH:MM')#)</cfoutput>
							</cfif>
						</td>
					</cfif>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='50575.Yayın Başlangıç'>></td>
				  	<td>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='62536.Başlangıç Girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="startdate" id="startdate" style="width:130px;" value="#dateformat(get_notice.startdate,'dd/mm/yyyy')#"  validate="eurodate" maxlength="10" message="#message#">
						<cf_wrk_date_image date_field="startdate">
				  	</td>
				  	<td rowspan="4" style="vertical-align:top;"><cf_get_lang dictionary_id='35106.Çalışılacak İller'></td>
					<td rowspan="4" style="vertical-align:top;">
						<cfquery name="GET_CITY" datasource="#DSN#">
							SELECT CITY_ID, CITY_NAME, COUNTRY_ID FROM SETUP_CITY ORDER BY CITY_NAME
						</cfquery>
						<select name="city" id="city" style="width:165px;height:75px" multiple>
							<option value="" <cfif not len(get_notice.notice_city)>selected</cfif>><cf_get_lang dictionary_id='57734.Please Select'></option>			
							<option value="0" <cfif listfind(get_notice.notice_city,0,',')>selected</cfif>><cf_get_lang dictionary_id='31704.All of Turkey'></option>			
							<cfoutput query="get_city">
								<option value="#city_id#" <cfif listfind(get_notice.notice_city,get_city.city_id,',')>selected</cfif>>#city_name#</option>
							</cfoutput>
						</select>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang no='787.Yayın Bitiş'></td>
					<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='30753.Bitiş Girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="finishdate" id="finishdate" style="width:130px;" value="#dateformat(get_notice.finishdate,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#">
						<cf_wrk_date_image date_field="finishdate">
					</td>
				</tr>
				<tr> 
					<td><cf_get_lang dictionary_id='58637.Logo'></td>
					<td><input type="checkbox" name="view_logo" id="view_logo" value="1" <cfif get_notice.is_view_logo eq 1>checked</cfif>>&nbsp;(<cf_get_lang no='789.Görünsün'>) - 
						<cf_get_lang_main no='162.Şirket'>&nbsp;
						<input type="checkbox" name="view_company_name" id="view_company_name" value="1" <cfif get_notice.is_view_company_name eq 1>checked</cfif>> (<cf_get_lang no='789.Görünsün'>)
					</td>
				</tr>
		  		<tr>
					<td><cf_get_lang dictionary_id='35111.Görsel İlan'></td>
					<td><input type="file" name="visual_notice" id="visual_notice" style="width:150px;">&nbsp;
						<input type="checkbox" name="view_visual_notice" id="view_visual_notice" value="1" <cfif get_notice.view_visual_notice eq 1>checked</cfif>>(<cf_get_lang no='789.Görünsün'>)&nbsp;
						<cfif len(get_notice.visual_notice)>
							<cf_get_server_file output_file="hr/#get_notice.visual_notice#" output_server="#get_notice.server_visual_notice_id#" output_type="2" image_link="1" alt="#getLang('objects2',751)#" title="#getLang('objects2',751)#">
						</cfif>
					</td>
				</tr>
				<tr> 
			  		<td style="vertical-align:top;"><cf_get_lang dictionary_id='31641.İşin Tanımı'></td>
			  		<td colspan="3">
				  		<textarea name="work_detail" id="work_detail" style="width:528px;height:80px;"><cfoutput>#get_notice.work_detail#</cfoutput></textarea>
			  		</td>
				</tr>
	  		</table>
	  		<table>
				<tr> 
					<td style="vertical-align:top;width:17%;"><cf_get_lang dictionary_id='57629.Açıklama'></td>
					<td colspan="3">
						<cfset detail_body = htmleditformat(get_notice.detail)> 
                        <cfmodule template="/fckeditor/fckeditor.cfm"
                            toolbarset="Basic"
                            basepath="/fckeditor/"
                            instancename="detail"
                            valign="top"
                            value="#detail_body#"
                            width="490"
                            height="300">
					</td>
				</tr>
				<tr>
					<td></td>
					<td style="text-align:right;" colspan="3">
						<!--- <cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='1' delete_page_url ='#request.self#?fuseaction=objects2.emptypopup_del_notice&notice_id=#attributes.notice_id#'>&nbsp;&nbsp;&nbsp;&nbsp; --->
						<cf_workcube_buttons is_upd='1'	 is_delete='1' data_action="/V16/objects2/career/cfc/data_career_partner:upd_notice" next_page="/#attributes.param_1#?notice_id=" add_function='kontrol()'>                    
					</td>
				</tr>
	  		</table>
	  	</td>
	</tr>
</table>
</cfform>

<script type="text/javascript">
	function kontrol()
	{
		if ((document.getElementById('work_detail').value.length)>1000)
		{
			alert("<cf_get_lang dictionary_id='56207.İş Tanımı 1000 Karakterden Fazla Olamaz'>!");
			return false;
		}
			
		if ((document.getElementById('startdate').value != "") && (document.getElementById('finishdate').value != ""))
		return date_check(document.getElementById('startdate'),document.getElementById('finishdate'),"<cf_get_lang_main no='1450.Başlama Tarihi Bitiş Tarihinden küçük olmalıdır'> !"); 
	}
</script>
