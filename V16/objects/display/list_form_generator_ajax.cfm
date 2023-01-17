	<cfset cfc= createObject("component","V16.objects.cfc.get_list_detail_survey")>
	<cfsetting showdebugoutput="no">
	<cfif isdefined("x_form_count_per_offer") and len(x_form_count_per_offer)>
		<cfset survey_count = x_form_count_per_offer>
	<cfelse>
		<cfset survey_count = "">
	</cfif>
	<cfset get_main_result=cfc.GetMainResult(action_type:attributes.action_type,action_type_id:attributes.action_type_id)> 
	<cfif attributes.design eq 3>
	<!--- custom tag de design='3' olarak gönderildiginde sadece o tipe ait doldurulmus olan tum kayıtlar ve iliskilendirilmis formlar listelenir. SG20120919
			örnek olarak e-profil detay,seçim listesi,cv detay değerlendirme formlarına bakınız.
	--->
		<cf_ajax_list>
			<tbody>
			<cfif get_main_result.recordcount>
				<cfoutput query="get_main_result" maxrows="#attributes.row_count#">
				<cfset is_view = 0>
				<cfif is_one_result eq 1 and survey_main_result_id eq -1><!--- 1 kez form doldurulsun seçili ise kisinin doldurmus oldugu form varmi kontrol edilir--->
					<cfset get_control_result=cfc.GetControlResult(survey_main_id:survey_main_id)> 
					<cfif get_control_result.recordcount><!--- kayıt var ise form ekleme tekrar gelmesin--->
						<cfset is_view = 0>
					<cfelse>
						<cfset is_view = 1><!---yok ise form ekleyebilsin ---->
					</cfif>	
				<cfelse>
					<cfset is_view = 1><!--- 1 kez doldurulsun seçili değilse istedigi kadar ekleme yapabilir--->		
				</cfif>
				<cfif is_view eq 1>
					<cfset survey_details=cfc.GetSurveyDetails(survey_result_id:get_main_result.survey_main_result_id)>
					<tr>
						<cfif survey_main_result_id gt 0>
							<td>#survey_details.SCORE_RESULT#/#survey_details.TOTAL_SCORE#</td>
							<td>#survey_main_head#</td>
							<td>#get_par_info(survey_details.partner_id,0,-1,0)#</td>
							<td>#get_emp_info(survey_details.emp_id,0,0)#</td>
							<td><cfif len(survey_details.RECORD_DATE)>#dateformat(date_add('h',session.ep.time_zone,survey_details.RECORD_DATE),dateformat_style)#</cfif></td>
							<td width="15">
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_detailed_survey_main_result&survey_id=#encodeForURL(survey_main_id)#&result_id=#encodeForURL(survey_main_result_id)#&is_popup=1','wide');" class=""><i class="catalyst-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
							</td>
							<td width="15"></td>
						<cfelse>
							<td></td>
							<td>#survey_main_head#</td>
							<td></td>
							<td></td>
							<td></td>
							<td width="15">
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_add_detailed_survey_main_result&survey_id=#encodeForURL(survey_main_id)#&action_type=#encodeForURL(get_main_result.type)#&action_type_id=#encodeForURL(attributes.action_type_id)#&is_popup=1','wide');" class=""><i class="icon-SUBO" title="<cf_get_lang dictionary_id='57762.Formu Doldur'>"></i></a>
							</td>
							<td width="15"></td>
						</cfif>
					</tr>
				</cfif>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
				</tr>		
			</cfif>	
			</tbody>
		</cf_ajax_list>
	<cfelse>
	<!--- ilişkili formlar doldurulmak üzere listelenir ve kişinin kendi doldurmuş olduğu formlar listelenir--->
	 <cfset get_survey=cfc.GetSurvey(related_type:attributes.related_type, action_type_id:attributes.action_type_id)>
	 <cfquery name="evaluation_forms" dbtype="query">
		 SELECT * FROM get_survey WHERE survey_main_result_id < 0
	 </cfquery>
	 <cfquery name="filled_forms" dbtype="query">
		SELECT * FROM get_survey WHERE survey_main_result_id > 0
	</cfquery>
		 <cf_ajax_list>
			<tbody>
				<cfif get_survey.recordcount>
					<cfoutput query="evaluation_forms" maxrows="#attributes.row_count#">
						<cfset survey_details=cfc.GetSurveyDetails(survey_result_id:survey_main_result_id)>
						<cfset get_control_survey=cfc.GetControlSurvey(survey_main_id:survey_main_id)> 
						<cfset is_view = 0>
						<cfif is_one_result eq 1 and survey_main_result_id eq -1><!--- 1 kez form doldurulsun seçili ise kisinin doldurmus oldugu form varmi kontrol edilir--->
							<cfif get_control_survey.recordcount><!--- kayıt var ise form ekleme tekrar gelmesin--->
								<cfset is_view = 0>
							<cfelse>
								<cfset is_view = 1><!---yok ise form ekleyebilsin ---->
							</cfif>	
						<cfelse>
							<cfset is_view = 1><!--- 1 kez doldurulsun seçili değilse istedigi kadar ekleme yapabilir--->		
						</cfif>
						<cfif get_control_survey.recordcount and RELATED_ALL eq 1><!--- tümü ile ilişkilendirildi ise ve 1 kere formu doldurduysam tekrar ekleme gelmesin--->
							<cfset is_view = 0>
						</cfif>
						<cfif is_view eq 1>
							<tr>
								<td width="95%">#survey_main_head#</td>
								<td>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_add_detailed_survey_main_result&survey_id=#encodeForURL(survey_main_id)#&action_type=#encodeForURL(attributes.related_type)#&action_type_id=#encodeForURL(attributes.action_type_id)#&is_popup=1','wide');" class=""><i class="icon-SUBO" title="<cf_get_lang dictionary_id='57762.Formu Doldur'>"></i></a>
								</td>
								<cfif attributes.design eq 1><!---sadece yonetim tarafindan silinebilecek --->
									<td>
										<cfsavecontent variable="delete_message"><cf_get_lang dictionary_id ='57533.Silmek istediginize emin misiniz'></cfsavecontent>
										<a href="javascript://" onClick="if(confirm('#delete_message#')) windowopen('#request.self#?fuseaction=objects.emptypopup_del_survey_relation&action_type=#encodeForURL(attributes.related_type)#&action_type_id=#encodeForURL(attributes.action_type_id)#&survey_id=#encodeForURL(survey_main_id)#&isContentDelete=1&action_id=##','small');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.sil'>"></i></a>
									</td>
								</cfif>
							</tr>
						</cfif>
					</cfoutput>
					<cfif filled_forms.recordcount>
						<cfsavecontent  variable="header_"><cf_get_lang dictionary_id='55759.Değerlendirmeler'></cfsavecontent>
						<cf_ajax_list  id="degerlendirmeler">
							<cf_seperator id="degerlendirmeler" header="#header_#" is_closed="0">
					<thead>
						<tr>
							<th><cf_get_lang dictionary_id='58984.Puan'></th>
							<th><cf_get_lang dictionary_id='57196.Form Adı'></th>
							<th><cf_get_lang dictionary_id='59596.Bilgi Veren'></th>
							<th><cf_get_lang dictionary_id='59597.Formu Dolduran'></th>
							<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
							<th></th>
							<th></th>
						</tr>
					</thead>
					<cfoutput query="filled_forms" maxrows="#attributes.row_count#">
						<cfset survey_details=cfc.GetSurveyDetails(survey_result_id:survey_main_result_id)>
						<cfset get_control_survey=cfc.GetControlSurvey(survey_main_id:survey_main_id)>
						<tbody>
							<tr>
								<td>#survey_details.SCORE_RESULT#/#survey_details.TOTAL_SCORE#</td>
								<td>#survey_main_head#</td>
								<td><cfif len(survey_details.partner_id)>#get_par_info(survey_details.partner_id,0,-1,0)#<cfelseif len(survey_details.consumer_id)>#get_cons_info(survey_details.consumer_id,0,-1,0)#</cfif></td>
								<td>#get_emp_info(survey_details.emp_id,0,0)#</td>
								<td><cfif len(survey_details.RECORD_DATE)>#dateformat(date_add('h',session.ep.time_zone,survey_details.RECORD_DATE),dateformat_style)#</cfif></td>
								<td width="15">
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_detailed_survey_main_result&survey_id=#encodeForURL(survey_main_id)#&result_id=#encodeForURL(survey_main_result_id)#&is_popup=1','wide');" class=""><i class="catalyst-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
								</td>
								<cfif attributes.design eq 1><!---sadece yonetim tarafindan silinebilecek --->
									<td width="15">
										<cfsavecontent variable="delete_message"><cf_get_lang dictionary_id ='57533.Silmek istediginize emin misiniz'></cfsavecontent>
										<a href="javascript://" onClick="if(confirm('#delete_message#')) windowopen('#request.self#?fuseaction=objects.emptypopup_del_survey_relation&isContentDelete=0&survey_main_result_id=#encodeForURL(survey_main_result_id)#&action_id=##','small');"><img  src="images/delete_list.gif" border="0" title="<cf_get_lang dictionary_id='57463.sil'>"></a>
									</td>
								</cfif>
							</tr>
						</tbody>
					</cfoutput>
				</cf_ajax_list>
				</cfif>
				<cfelse>
				<tbody>
					<tr>
						<td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
					</tr>
				</tbody>		
				</cfif>	
			</tbody>
		</cf_ajax_list>
	</cfif>
	