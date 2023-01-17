<cfsetting showdebugoutput="no">
<cfset cfc=createObject("component","V16.training_management.cfc.training_survey")> 
<cfset get_questions=cfc.GetQuestions(survey_chapter_id:attributes.survey_chapter_id)> 
<input type="hidden" name="delete_ids" id="delete_ids" value="0">
<div class="col col-12">
	<cf_box id="questions" title="#getLang('','Sorular',58087)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_box_elements>
			<cf_grid_list>
				<thead>
					<tr>
						<th width="15"><a href="javascript://" class="tableyazi" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_add_detail_survey_questions&survey_id=#attributes.survey_id#&survey_chapter_id=#survey_chapter_id#<cfif isdefined("attributes.crn")>&currentrow=#attributes.crn#</cfif></cfoutput>','new_question_box','ui-draggable-box-large');" title="<cf_get_lang dictionary_id='58810.Soru'> <cf_get_lang dictionary_id='57582.Ekle'>"><i class="fa fa-plus"></i></a></th>
						<th width="15"><cf_get_lang dictionary_id="57487.No"></th>
						<th><cf_get_lang dictionary_id="58810.Soru"></th>
						<th><cf_get_lang dictionary_id="57771.Detay"></th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="get_questions">
						<tr name="frm_list_row_question#survey_question_id#" id="frm_list_row_question#survey_question_id#">
							<td  nowrap="nowrap">
								<input type="hidden" name="row_kontrol_list_question#survey_question_id#" id="row_kontrol_list_question#survey_question_id#" value="1">
								<input type="hidden" name="survey_question_id#survey_question_id#" id="survey_question_id#survey_question_id#" value="#survey_question_id#">
								<input type="hidden" name="list_survey_id" id="list_survey_id" value="#survey_main_id#">
									<!--- <a style="cursor:pointer" title="<cf_get_lang dictionary_id='57463.Sil'>" onclick="del_question(#survey_question_id#);"><i class="fa fa-minus"></i></a> --->
									<a href="javascript://" title="<cf_get_lang dictionary_id='57464.Güncelle'>" class="tableyazi" onclick="openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_upd_detail_survey_questions&survey_question_id=#survey_question_id#&survey_chapter_id=#attributes.survey_chapter_id#&survey_id=#attributes.survey_id#<cfif isdefined("attributes.crn")>&currentrow=#attributes.crn#</cfif>','','ui-draggable-box-large');"><i class="fa fa-pencil"></i></a>
							</td>
							<td><input type="text" name="line_replace_#currentrow#" id="line_replace_#currentrow#" value="#currentrow#" style="width:25px;" maxlength="3" class="box" onKeyUp="isNumber(this);" onblur="loadPage(this.value,#line_number#,#survey_question_id#,#attributes.survey_chapter_id#,0);" align="absmiddle"></td>
							<td>
								<a href="javascript://" class="tableyazi" onclick="openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_upd_detail_survey_questions&survey_question_id=#survey_question_id#&survey_chapter_id=#attributes.survey_chapter_id#&survey_id=#attributes.survey_id#<cfif isdefined("attributes.crn")>&currentrow=#attributes.crn#</cfif>','','ui-draggable-box-large');">#get_questions.question_head#</a>
							</td>
							<td>#question_detail#&nbsp;</td>
						</tr>
					</cfoutput>
				</tbody>
			</cf_grid_list>
		</cf_box_elements>
	</cf_box>
</div>
<script type="text/javascript">
	function del_question(sy)
	{	
		document.getElementById("delete_ids").value = document.getElementById("delete_ids").value + "," + sy;
		var my_element=eval("document.all.row_kontrol_list_question"+sy);
		my_element.value=0;
		var my_element=eval("frm_list_row_question"+sy);
		my_element.style.display="none";
	}
	function loadPage(ln,xx,yy,zz,tt)
	{
		if(ln == '')
		{alert("<cf_get_lang dictionary_id='60096.Satır numarasına sayı girmelisiniz'>");}
		else
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.emptypopup_ajax_detail_survey_chapter&type=1&survey_chapter_id='+zz+'&survey_question_id='+yy+'&line_number='+xx+'&line_replace='+ln+'&survey_id= '+ document.getElementById('list_survey_id').value,'survey_chapter',1,'');
	} 
</script>