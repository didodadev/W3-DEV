<cfsetting showdebugoutput="no">
<cfset cfc=createObject("component","V16.training_management.cfc.training_survey")> 
<cfset get_survey_question=cfc.GetSurveyQuestion(survey_question_id:attributes.survey_question_id)> 
<cfset get_survey_chapter=cfc.GetSurveyChapterQuestion(survey_chapter_id:attributes.survey_chapter_id)> 
<cfset get_survey_options=cfc.GetSurveyOptionsQuestion(survey_question_id:attributes.survey_question_id)> 
<cfset get_survey_options_=cfc.GetSurveyOptions(survey_chapter_id:attributes.survey_chapter_id)> 
<cfparam name="attributes.stream_name" default="#createUUID()#"/>
<cfparam name="attributes.is_stream" default="0"/>
<cfif not isdefined("attributes.currentrow")>
	<cfset currentrow = 0>
<cfelse>
	<cfset currentrow = attributes.currentrow>
</cfif>
<cfset get_result = createObject("component","V16.objects.cfc.get_survey_result").getSurveyResult(dsn:dsn,survey_main_id:attributes.survey_id)>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='58810.Soru'></cfsavecontent>
<cf_box title="#message#" add_href="openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_add_detail_survey_questions&survey_id=#attributes.survey_id#&survey_chapter_id=#survey_chapter_id#&currentrow=#currentrow#')" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="upd_survey_questions" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_detail_survey_questions" method="post" enctype="multipart/form-data">
		<cfoutput>
			<cfif get_survey_options_.recordcount><!--- optionslar defaultta geliyorsa, degerler default atanir --->
				<input type="hidden" name="option_record_num" id="option_record_num" value="<cfoutput>#get_survey_options_.recordcount#</cfoutput>">
				<cfloop query="get_survey_options_">
					<input type="hidden" name="row_kontrol_options#currentrow#" id="row_kontrol_options#currentrow#" value="1">
					<input type="hidden" name="option_head#currentrow#" id="option_head#currentrow#" value="#option_head#">
					<input type="hidden" name="option_detail#currentrow#" id="option_detail#currentrow#" value="#option_detail#">
					<input type="hidden" name="option_point#currentrow#" id="option_point#currentrow#" value="#option_point#">
					<input type="hidden" name="option_image#currentrow#" id="option_image#currentrow#" value="">
					<!--- <input type="hidden" name="option_score_rate1_#currentrow#" id="option_score_rate1_#currentrow#" value="#score_rate1#">
					<input type="hidden" name="option_score_rate2_#currentrow#" id="option_score_rate2_#currentrow#" value="#score_rate2#"> --->
				</cfloop>
			<cfelse>
				<input type="hidden" name="option_record_num" id="option_record_num" value="#get_survey_options.recordCount#">
			</cfif>
			<cfif isdefined("attributes.currentrow")>
				 <input type="hidden" name="currentrow" id="currentrow" value="<cfoutput>#attributes.currentrow#</cfoutput>">
			</cfif>
			<input type="hidden" name="record_num" id="record_num" value="">
			<input type="hidden" name="survey_question_id" id="survey_question_id" value="#attributes.survey_question_id#">
			<input type="hidden" name="survey_chapter_id" id="survey_chapter_id" value="#attributes.survey_chapter_id#">
			<input type="hidden" name="survey_id" id="survey_id" value="#attributes.survey_id#">
			<cf_box_elements>
				<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id='58810.Soru'></label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<textarea name="head" id="head" style="width:200px;height:40px;" maxlength="4000" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);">#get_survey_question.question_head#</textarea>
					</div>
				</div>
				<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id='57771.Detay'></label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<textarea name="detail" id="detail" style="width:200px;height:40px;" maxlength="4000" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);">#get_survey_question.question_detail#</textarea>
					</div>
				</div>
				<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id='29801.Zorunlu'></label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<input type="checkbox" name="is_question" id="is_question" <cfif get_survey_question.is_required eq 1> checked value="1"<cfelse> value="0"</cfif>>
					</div>
				</div>
				<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id='29762.Imaj'></label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<cfif not len(get_survey_question.question_image_path)>
							<input type="file" name="option_image0" id="option_image0" value="#get_survey_question.question_image_path#" <cfif len(get_survey_question.question_image_path)>style="width:150px;"<cfelse>style="width:200px;"</cfif>>
						<cfelse>
							<input type="file" name="question_file" id="question_file" value="" style="width:200px;display:none;">
							<input type="text" name="file" id="file" value="" style="width:193px;">
							<a href="javascript://" id="value11" onclick="temizle();"><img src="/images/delete_list.gif" border="0" alt="<cf_get_lang dictionary_id='57934.Temizle'>" align="absmiddle"></a>
							<label id="get_server_file" style="display:'';width:5mm;"><cf_get_server_file output_file="helpdesk/#get_survey_question.question_image_path#" output_server="1" output_type="2" image_link="1"></label>
						</cfif> 
							<input type="hidden" name="question_image" id="question_image" value="#get_survey_question.question_image_path#" style="width:194px;">
					</div>
				</div>
				<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id='57630.Tip'></label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<select name="question_type" id="question_type" style="width:200px;" onchange="change_display()" <cfif get_survey_options_.recordcount>disabled="disabled"</cfif>>
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<option value="1" <cfif get_survey_question.question_type eq 1>selected<cfelseif not len(get_survey_question.question_type) and get_survey_options_.recordcount and get_survey_options_.question_type eq 1>selected</cfif>><cf_get_lang dictionary_id='29795.Tekli'></option>
							<option value="2" <cfif get_survey_question.question_type eq 2>selected<cfelseif not len(get_survey_question.question_type) and get_survey_options_.recordcount and get_survey_options_.question_type eq 2>selected</cfif>><cf_get_lang dictionary_id='58032.Çoklu'></option>
							<option value="3" <cfif get_survey_question.question_type eq 3>selected<cfelseif not len(get_survey_question.question_type) and get_survey_options_.recordcount and get_survey_options_.question_type eq 3>selected</cfif>><cf_get_lang dictionary_id='60191.Metin'></option>
							<!--- <option value="4" <cfif get_survey_question.question_type eq 4>selected<cfelseif not len(get_survey_question.question_type) and get_survey_options_.recordcount and get_survey_options_.question_type eq 4>selected</cfif>><cf_get_lang_main no='1975.Skor'></option> --->
							<option value="5" <cfif get_survey_question.question_type eq 5>selected<cfelseif not len(get_survey_question.question_type) and get_survey_options_.recordcount and get_survey_options_.question_type eq 5>selected</cfif>><cf_get_lang dictionary_id='60192.Paragraf Metin'></option>
						</select>
					</div>
				</div>
				<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id='29792.Tasarim'></label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<select name="question_design" id="question_design" style="width:200px;" <cfif get_survey_question.question_type eq 3 or get_survey_question.question_type eq 5 or get_survey_options_.recordcount>disabled="disabled"</cfif>>
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<option value="1" <cfif get_survey_question.question_design eq 1>selected<cfelseif not len(get_survey_question.question_design) and get_survey_options_.recordcount and get_survey_options_.question_design eq 1>selected</cfif>><cf_get_lang dictionary_id='29793.Dikey'></option>
						<option value="2" <cfif get_survey_question.question_design eq 2>selected<cfelseif not len(get_survey_question.question_design) and get_survey_options_.recordcount and get_survey_options_.question_design eq 2>selected</cfif>><cf_get_lang dictionary_id='29794.Yatay'></option>
					</select>
					</div>
				</div>
				<cfif not get_survey_options_.recordcount><!--- şıklar seçenekler ekranında belirlenmemiş ise GD burada gelsin--->
					<div id="gd_check" class="form-group col col-6 col-md-6 col-sm-6 col-xs-12" <cfif get_survey_question.question_type eq 1>style="display:"<cfelse>style="display:none"</cfif>>
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='60193.GD seçeneği'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<input type="checkbox" name="is_show_gd" id="is_show_gd" value="1" <cfif get_survey_question.is_show_gd eq 1>checked</cfif>>
						</div>
					</div>
				</cfif>
			</cf_box_elements>
		</cfoutput>
			<div class="col col-12">
				<cf_grid_list class="form_list" id="table_upd_options"style="display:""">
					<cfoutput>
						<thead>
							<tr>
								<th width="10"><input type="button" class="eklebuton" onClick="upd_option_row();"></th>
								<th style="width:10px"><cf_get_lang dictionary_id='57487.No'></th>
								<th width="180"><cf_get_lang dictionary_id='29798.Seçenekler'></th>
								<th width="180"><cf_get_lang dictionary_id='57771.Detay'></th>
								<!--- <th width="80">İmaj</th> --->
								<!--- <th width="25"><cf_get_lang_main no='55.Not'></th> --->
								<th width="25"><cf_get_lang dictionary_id='58984.Puan'></th>
							</tr>
						</thead>
						<tbody>
							<cfloop query="get_survey_options">
								<tr name="frm_row_options#currentrow#" id="frm_row_options#currentrow#" class="color-row" value="1">
									<td style="width:10px"><input type="hidden" name="row_kontrol_options#currentrow#" id="row_kontrol_options#currentrow#" value="1">
										<a style="cursor:pointer" onclick="sil_options(#currentrow#);"><img  src="images/delete_list.gif"  border="0" alt="<cf_get_lang dictionary_id='57463.Sil'>"></a>
									</td>
									<td align="left"><input type="text" name="option_row#currentrow#" id="option_row#currentrow#" value="#currentrow#" style="width:25px;" maxlength="3" class="box" readonly=""></td>
									<td>
										<input type="text" name="option_head#currentrow#" id="option_head#currentrow#" value="#option_head#" style="width:280px;" maxlength="250"></td>
									<td><input type="text" name="option_detail#currentrow#" id="option_detail#currentrow#" value="#option_detail#" style="width:300px;" maxlength="4000"></td>
									<td><input type="text" name="option_point#currentrow#" id="option_point#currentrow#" value="#option_point#" <cfif get_survey_question.question_type eq 3 or get_survey_question.question_type eq 5>disabled="disabled"</cfif> maxlength="3" onkeyup="isNumber(this);" class="moneybox" style="width:25px;"></td>
								</tr>
							</cfloop>
						</tbody>
					</cfoutput>
				</cf_grid_list>
			</div>
		<div class="col col-12">
			<cf_box_footer>
				<cf_record_info query_name="get_survey_question">
				<cfif not get_result.recordcount>
					<cf_workcube_buttons is_upd='1' add_function='kontrol()' is_cancel='1' delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_survey_question&survey_id=#attributes.survey_id#&survey_question_id=#attributes.survey_question_id#'>
                <cfelse>
                    <span class="bold" style="color:red;"><cf_get_lang dictionary_id='63771.Form kullanıldığı için güncellenemez'>!</span>
				</cfif>
			</cf_box_footer>
		</div>
	</cfform>
</cf_box>
<script type="text/javascript">
function change_display()
{
	if(document.getElementById('question_type').value == 1)
	{
		document.getElementById('opt_question_design').disabled = false; 
		document.getElementById('question_design').disabled = false;
		if(document.getElementById('option_score_rate') != undefined)
			document.getElementById('option_score_rate').style.display = 'none';
		if(document.getElementById('table_options_2') != undefined)
			table_options_2.style.display = '';
		if(document.getElementById('table_upd_options') != undefined)
			table_upd_options.style.display = '';
		for(i=1;i<=document.getElementById('option_record_num').value;i++)
		{
			/*if(document.getElementById('option_add_note'+i) != undefined)
			{
				document.getElementById('option_add_note'+i).checked = false;
				document.getElementById('option_add_note'+i).disabled = false;
			}*/
			if(document.getElementById('option_point'+i) != undefined)
			{
				//document.getElementById('option_point'+i).value = '';
				document.getElementById('option_point'+i).disabled = false;
			}
		}
		gd_check.style.display = '';
	}
	else if(document.getElementById('question_type').value == 2)
	{
		document.getElementById('opt_question_design').disabled = false;
		document.getElementById('question_design').disabled = false;
		if(document.getElementById('option_score_rate') != undefined)
			document.getElementById('option_score_rate').style.display = 'none';
		if(document.getElementById('table_options_2') != undefined)
			table_options_2.style.display = '';
		if(document.getElementById('table_upd_options') != undefined)
			table_upd_options.style.display = '';
		for(i=1;i<=document.getElementById('option_record_num').value;i++)
		{
			/*if(document.getElementById('option_add_note'+i) != undefined)
			{
				document.getElementById('option_add_note'+i).checked = false;
				document.getElementById('option_add_note'+i).disabled = true;
			}*/
			if(document.getElementById('option_point'+i) != undefined)
			{
				//document.getElementById('option_point'+i).value = '';
				document.getElementById('option_point'+i).disabled = false;
			}
		}
		gd_check.style.display = 'none';
	}
	else if(document.getElementById('question_type').value == 3 || document.getElementById('question_type').value == 5)
	{
		document.getElementById('opt_question_design').disabled = true; 
		if(document.getElementById('option_score_rate') != undefined)
			document.getElementById('option_score_rate').style.display = 'none';
		if(document.getElementById('table_options_2') != undefined)
			table_options_2.style.display = '';
		if(document.getElementById('table_upd_options') != undefined)
			table_upd_options.style.display = '';
		for(i=1;i<=document.getElementById('option_record_num').value;i++)
		{
			/*if(document.getElementById('option_add_note'+i) != undefined)
			{
				document.getElementById('option_add_note'+i).checked = false;
				document.getElementById('option_add_note'+i).disabled = true;
			}*/
			if(document.getElementById('option_point'+i) != undefined)
			{
				document.getElementById('option_point'+i).value = '';
				document.getElementById('option_point'+i).disabled = true;
			}
		}
		gd_check.style.display = 'none';
	}
	/*else if(document.getElementById('question_type').value == 4)
	{	
		document.getElementById('opt_question_design').disabled = false; 
		document.getElementById('question_design').disabled = false;
		if(document.getElementById('option_score_rate') != undefined)
			document.getElementById('option_score_rate').style.display = '';
		if(document.getElementById('table_options_2') != undefined)
			table_options_2.style.display = 'none';
		if(document.getElementById('table_upd_options') != undefined)
			table_upd_options.style.display = 'none';
		gd_check.style.display = 'none';
	}*/
}
row_count_options=document.getElementById('option_record_num').value;
function kontrol()
{
	/*if((document.getElementById('option_score_rate1') != undefined && document.getElementById('option_score_rate2') != undefined)  && (document.getElementById('option_score_rate1').value == '' || document.getElementById('option_score_rate2').value == '') )
	{
		alert("<cf_get_lang_main no='2002.Min Max Degerlerini Giriniz'> !");
		return false;
	}*/
	if(document.getElementById('head').value == '')
	{
		alert("<cf_get_lang dictionary_id='58059.Soru Basligi Girmelisiniz'>!");
		return false;
	}
	if(document.getElementById('question_type').value == '')
	{
		alert("<cf_get_lang dictionary_id='29789.Soru Tipi Seçiniz'>!");
		return false;
	}
	/*if(document.getElementById('question_type').value != 4)
	{*/
		if(document.upd_survey_questions.option_record_num.value == 0)
		{
			alert("<cf_get_lang dictionary_id='29790.Seçenek Ekleyiniz'> !");
			return false;
		}
		for (var counter_=1; counter_ <=  document.upd_survey_questions.option_record_num.value; counter_++)
		{
			if(eval("document.upd_survey_questions.option_head"+counter_).value == '' && eval("document.upd_survey_questions.row_kontrol_options"+counter_).value == 1)
			{
				alert(eval("document.upd_survey_questions.option_row"+counter_).value + '.' + "<cf_get_lang dictionary_id='29802.Seçenek İçin Başlık Giriniz'>!");
				return false;
			}
		}
		if(document.getElementById('question_type').value == 1 || document.getElementById('question_type').value == 2)
		{
			for (var option_point_counter=1; option_point_counter <=  document.upd_survey_questions.option_record_num.value; option_point_counter++)
			{
				if(eval("document.upd_survey_questions.option_point"+option_point_counter).value == ''  && eval("document.upd_survey_questions.row_kontrol_options"+option_point_counter).value == 1)
				{
					alert(eval("document.upd_survey_questions.option_row"+option_point_counter).value + '.' +"<cf_get_lang dictionary_id='29803.Seçenek İçin Puan Giriniz'> !");
					return false;
				}
			}
		} 
	//}

	document.getElementById('head').value = document.getElementById('head').value.replace(/\n/g, " ");
	<cfif isdefined("attributes.draggable")>
		loadPopupBox('upd_survey_questions' , '<cfoutput>#attributes.modal_id#</cfoutput>');
		return false;
	</cfif>
}
function option_point_off()
{
	if(document.getElementById('option_score_rate2').value != '' && document.getElementById('option_score_rate1').value > document.getElementById('option_score_rate2').value)
	{
		alert("<cf_get_lang dictionary_id='29791.Min Değeri Max Değerinden Büyük Olamaz'> !");
		document.getElementById('option_score_rate1').value = '';
		return false;
	}
}
function temizle()
{
	document.upd_survey_questions.question_image.value='';
	upd_survey_questions.question_image.style.display='';
	upd_survey_questions.file.style.display='none';
	value11.style.display='none';
	upd_survey_questions.question_file.style.display='';
	get_server_file.style.display='none';
}
function temizle_opt(crow)
{
	var my_element=eval("upd_survey_questions.opt_image"+crow);
	my_element.value='';
	eval("upd_survey_questions.option_file"+crow).style.display='none';
	eval("value12"+crow).style.display='none';
	eval("upd_survey_questions.opt_file"+crow).style.display='';
	eval("opt_get_server_file"+crow).style.display='none';
}
function attachStream(streamName)
{
	document.getElementById("asset_file").disabled = "true";
	document.getElementById("stream_name").value = streamName;
}
function detach(streamName)
{
	document.getElementById("asset_file").disabled = "false";
	document.getElementById("asset_file").value = "";
	document.getElementById("stream_name").value = "";
}
function sil_options(sy)
{
	var my_element=document.getElementById('row_kontrol_options'+sy);
		my_element.value=0;
		var my_element=eval("frm_row_options"+sy);
		my_element.style.display="none";
}
function upd_option_row()
{
	row_count_options++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table_upd_options").insertRow(document.getElementById("table_upd_options").rows.length);
	newRow.setAttribute("name","frm_row_options" + row_count_options);
	newRow.setAttribute("id","frm_row_options" + row_count_options);	
	newRow.setAttribute("NAME","frm_row_options" + row_count_options);
	newRow.setAttribute("ID","frm_row_options" + row_count_options);				
	document.upd_survey_questions.option_record_num.value=row_count_options;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="hidden" name="row_kontrol_options'+row_count_options+'" id="row_kontrol_options'+row_count_options+'" value="1"><a style="cursor:pointer" onclick="sil_options(' + row_count_options + ');"><img src="images/delete_list.gif" alt="<cf_get_lang dictionary_id="57463.Sil">" border="0"></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="option_row'+row_count_options+'" value="'+row_count_options+'" style="width:25px;" class="box" align="left" readonly>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="option_head'+row_count_options+'" value="" style="width:280px;">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="option_detail'+row_count_options+'" value="" style="width:300px;" maxlength="4000">';
	/*newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="file" name="option_image'+row_count_options+'" value="" style="width:155px;">';*/
	/*newCell = newRow.insertCell(newRow.cells.length);
	if(document.getElementById('question_type').value == 1 || document.getElementById('question_type').value == '')
		newCell.innerHTML = '<input type="checkbox" name="option_add_note'+row_count_options+'" id="option_add_note'+row_count_options+'"  value="" style="width:25px;">';
	else
		newCell.innerHTML = '<input type="checkbox" name="option_add_note'+row_count_options+'" id="option_add_note'+row_count_options+'" disabled value="" style="width:25px;">';*/
	newCell = newRow.insertCell(newRow.cells.length);
	if(document.getElementById('question_type').value == 3)
		newCell.innerHTML = '<input type="text" name="option_point'+row_count_options+'"  id="option_point'+row_count_options+'" disabled value="" maxlength="3" onkeyup="isNumber(this);" class="moneybox" style="width:25px;">';
	else
		newCell.innerHTML = '<input type="text" name="option_point'+row_count_options+'"  id="option_point'+row_count_options+'" value="" maxlength="3" onkeyup="isNumber(this);" class="moneybox" style="width:25px;">';
}
</script>