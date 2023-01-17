<cfsetting showdebugoutput="no">
<cfset cfc=createObject("component","V16.training_management.cfc.training_survey")> 
<cfparam name="attributes.stream_name" default="#createUUID()#"/>
<cfparam name="attributes.add_new_option" default="0">
<cfset get_survey_options=cfc.GetSurveyOptions(survey_chapter_id:attributes.survey_chapter_id)> 
<div class="col col-12">
	<cf_box id="add_question" title="#getLang('','Soru Ekle',46312)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	    <cfform name="add_survey_questions" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_detail_survey_questions" method="post" enctype="multipart/form-data" onsubmit="return false;">
	        <cfif get_survey_options.recordcount><!--- optionslar defaultta geliyorsa, degerler default atanir --->
	            <cfoutput query="get_survey_options">
	                <input type="hidden" name="add_row_kontrol#currentrow#" id="add_row_kontrol#currentrow#" value="1">
	                <input type="hidden" name="option_head#currentrow#" id="option_head#currentrow#" value="#option_head#">
	                <input type="hidden" name="option_detail#currentrow#" id="option_detail#currentrow#" value="#option_detail#">
	                <input type="hidden" name="option_point#currentrow#" id="option_point#currentrow#" value="#option_point#">
	                <input type="hidden" name="option_image#currentrow#" id="option_image#currentrow#" value="">
	                <input type="hidden" name="option_score_rate1_#currentrow#" id="option_score_rate1_#currentrow#" value="#score_rate1#">
	                <input type="hidden" name="option_score_rate2_#currentrow#" id="option_score_rate2_#currentrow#" value="#score_rate2#">
	                <input type="hidden" name="question_type#currentrow#" id="question_type#currentrow#" value="#question_type#">
	                <input type="hidden" name="question_design#currentrow#" id="question_design#currentrow#" value="#question_design#">
	            </cfoutput>
				<input type="hidden" name="option_record_num" id="option_record_num" value="">
			<cfelse>
				<input type="hidden" name="option_record_num" id="option_record_num" value="0">
			</cfif>
			<cfif isdefined("attributes.currentrow")>
				 <input type="hidden" name="currentrow" id="currentrow" value="<cfoutput>#attributes.currentrow#</cfoutput>">
			</cfif>
	        <input type="hidden" name="add_new_option" id="add_new_option" value=""><!--- Sayfa gonderildiginde deger ataniyor,queryde kullaniliyor silmeyin --->
	        <input type="hidden" name="survey_id" id="survey_id" value="<cfoutput>#attributes.survey_id#</cfoutput>">
	        <input type="hidden" name="survey_chapter_id" id="survey_chapter_id" value="<cfoutput>#attributes.survey_chapter_id#</cfoutput>">
			<div class="ui-form-list col col-12">
				<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id='58810.Soru'></label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<textarea name="question_head" id="question_head" style="width:200px;height:40px;" maxlength="4000" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);"></textarea>
					</div>
				</div>
				<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id='57771.Detay'></label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<textarea name="question_detail" id="question_detail" style="width:200px;height:40px;" maxlength="4000" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);"></textarea>
					</div>
				</div>
				<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id='29801.Zorunlu'></label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<input type="checkbox" name="is_question" id="is_question" value="">
					</div>
				</div>
				<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id='29762.Imaj'></label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<input type="file" name="option_image0" id="option_image0" value=""><input type="hidden" name="question_image" id="question_image" value="">
					</div>
				</div>
				<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id='57630.Tip'></label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<select name="question_type" id="question_type" style="width:200px;" onchange="change_display()" <cfif get_survey_options.recordcount>disabled</cfif>>
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<option value="1"<cfif get_survey_options.recordcount and get_survey_options.question_type eq 1>selected</cfif>><cf_get_lang dictionary_id='29795.Tekli'></option>
							<option value="2"<cfif get_survey_options.recordcount and get_survey_options.question_type eq 2>selected</cfif>><cf_get_lang dictionary_id='58032.Çoklu'></option>
							<option value="3"<cfif get_survey_options.recordcount and get_survey_options.question_type eq 3>selected</cfif>><cf_get_lang dictionary_id='60191.Metin'></option>
							<!---<option value="4"<cfif get_survey_options.recordcount and get_survey_options.question_type eq 4>selected</cfif>><cf_get_lang_main no='1975.Skor'></option>--->
							<option value="5"<cfif get_survey_options.recordcount and get_survey_options.question_type eq 5>selected</cfif>><cf_get_lang dictionary_id='60192.Paragraf Metin'></option>
						</select>
					</div>
				</div>
				<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id='29792.Tasarim'></label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<select name="question_design" id="question_design" style="width:200px;" <cfif get_survey_options.question_type eq 3 or get_survey_options.question_type eq 5 or get_survey_options.recordcount>disabled="disabled"</cfif>>
							<option value="1"<cfif get_survey_options.recordcount and get_survey_options.question_design eq 1>selected</cfif>><cf_get_lang dictionary_id='29793.Dikey'></option>
							<option value="2"<cfif get_survey_options.recordcount and get_survey_options.question_design eq 2>selected</cfif>><cf_get_lang dictionary_id='29794.Yatay'></option>
						</select>
					</div>
				</div>
			</div>
	        <table>
	        <tr id="option_score_rate" <cfif get_survey_options.recordcount and get_survey_options.question_type eq 4>style="display:"<cfelse>style="display:none"</cfif>>
	            <td><cf_get_lang dictionary_id='58908.Min'>. <cf_get_lang dictionary_id ='58909.Max'>.</td>
	            <td><input type="text" name="option_score_rate1" id="option_score_rate1" onkeyup="isNumber(this);option_point_off();" value="<cfif len(get_survey_options.score_rate1)><cfoutput>#get_survey_options.score_rate1#</cfoutput></cfif>" style="width:30px" <cfif get_survey_options.recordcount>disabled</cfif>>
	                <input type="text" name="option_score_rate2" id="option_score_rate2" onkeyup="isNumber(this);option_point_off();" value="<cfif len(get_survey_options.score_rate2)><cfoutput>#get_survey_options.score_rate2#</cfoutput></cfif>" style="width:30px" <cfif get_survey_options.recordcount>disabled</cfif>>
	            </td>
	        </tr>
			<tr id="gd_check" <cfif get_survey_options.recordcount>style="display:none"</cfif>>
				<td>&nbsp;</td>
				<td><input type="checkbox" name="is_show_gd" id="is_show_gd" value="1"><cf_get_lang dictionary_id='60193.GD seçeneği'></td>
			</tr>
		    </table>
	        <cf_grid_list id="table_options">
	            <cfif not get_survey_options.recordcount>
	                <thead>
	                	<tr> 
	                        <th colspan="6"><cf_get_lang dictionary_id='29797.Siklar ve Seçenekler'></th>
	                    </tr>
	                    <tr name="frm_row_options" id="frm_row_options">
	                        <th width="10"><input type="button" class="eklebuton" onClick="add_option_row();"></th>
	                        <th width="10"><cf_get_lang dictionary_id='57487.No'></th>
	                        <th width="200"><cf_get_lang dictionary_id='29798.Seçenekler'></th>
	                        <th width="200"><cf_get_lang dictionary_id='57771.Detay'></th>
	                        <!--- <th class="txtbold" width="150">Imaj</th> --->
	                        <!--- <th width="25" id="th_note"><cf_get_lang_main no='55.Not'></th> --->
	                        <th width="25" id="th_puan"><cf_get_lang dictionary_id='58984.Puan'></th>
	                    </tr>
	                </thead>
	                <tbody id="table_add_options"></tbody>
	            </cfif>
	        </cf_grid_list>
			<cf_workcube_buttons is_upd='0' is_cancel='1' add_function='kontrol()'>
		</cfform>
	<div id="survey_question"></div><!--- AjaxFormSubmit icin kullaniliyor --->
	</cf_box>
</div>
<script type="text/javascript">
function change_display()
{
	if(document.getElementById('question_type').value == 1)
	{
		document.getElementById('question_design').disabled = false; 
		document.getElementById('question_design').disabled = false;
		if(document.getElementById('option_score_rate') != undefined)
			document.getElementById('option_score_rate').style.display = 'none';
		if(document.getElementById('table_options') != undefined)
			table_options.style.display = '';
		if(document.getElementById('table_options_2') != undefined)
			table_options_2.style.display = '';
		if(document.getElementById('option_record_num') != undefined)
		{
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
		}
		gd_check.style.display = '';
	}
	else if(document.getElementById('question_type').value == 2)
	{
		document.getElementById('question_design').disabled = false;
		document.getElementById('question_design').disabled = false;
		if(document.getElementById('option_score_rate') != undefined)
			document.getElementById('option_score_rate').style.display = 'none';
		if(document.getElementById('table_options') != undefined)
			table_options.style.display = '';
		if(document.getElementById('table_options_2') != undefined)
			table_options_2.style.display = '';
		if(document.getElementById('option_record_num') != undefined)
		{
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
		}
		gd_check.style.display = 'none';
	}
	else if(document.getElementById('question_type').value == 3 || document.getElementById('question_type').value == 5)
	{
		document.getElementById('question_design').disabled = true; 
		if(document.getElementById('option_score_rate') != undefined)
			document.getElementById('option_score_rate').style.display = 'none';
		if(document.getElementById('table_options') != undefined)
			table_options.style.display = '';
		if(document.getElementById('table_options_2') != undefined)
			table_options_2.style.display = '';
		if(document.getElementById('option_record_num') != undefined)
		{
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
		}
		gd_check.style.display = 'none';
	}
	else if(document.getElementById('question_type').value == 4)
	{	
		document.getElementById('question_design').disabled = false; 
		document.getElementById('question_design').disabled = false;
		if(document.getElementById('option_score_rate') != undefined)
			document.getElementById('option_score_rate').style.display = '';
		if(document.getElementById('table_options') != undefined)
			table_options.style.display = 'none';
		if(document.getElementById('table_options_2') != undefined)
			table_options_2.style.display = 'none';
		gd_check.style.display = 'none';
	}
}
row_count_options=0;
function kontrol()
{
	
	if((document.getElementById('option_score_rate1') != undefined && document.getElementById('option_score_rate1') != undefined)  && (document.getElementById('option_score_rate1').value == '' || document.getElementById('option_score_rate1').value == '') && document.getElementById('question_type').value == 4)
	{
		alert("<cf_get_lang dictionary_id='29799.Min Max Degerlerini Giriniz'> !");
		return false;
	}
	if(document.getElementById('question_head').value == '')
	{
		alert("<cf_get_lang dictionary_id='58059.Soru Basligi Girmelisiniz'>!");
		return false;
	}
	if(document.getElementById('question_type').value == '')
	{
		alert("<cf_get_lang dictionary_id='29789.Soru Tipi Seçiniz'>!");
		return false;
	}
	if(document.getElementById('question_type').value != 4)
	{
		if(document.add_survey_questions.option_record_num.value == 0 && document.add_survey_questions.option_record_num.value != '')
		{
			alert("<cf_get_lang dictionary_id='29790.Seçenek Ekleyiniz'> !");
			return false;
		}
		for (var counter_=1; counter_ <=  document.add_survey_questions.option_record_num.value; counter_++)
		{
			if(eval("document.add_survey_questions.option_head"+counter_).value == '' && eval("document.add_survey_questions.add_row_kontrol"+counter_).value == 1)
			{
				alert(eval("document.add_survey_questions.option_row"+counter_).value + '.' + "<cf_get_lang dictionary_id='29802.Seçenek İçin Başlık Giriniz'>!");
				return false;
			}
		}
		if(document.getElementById('question_type').value != 3 && document.getElementById('question_type').value != 5)
		{
			for (var option_point_counter=1; option_point_counter <=  document.getElementById('option_record_num').value; option_point_counter++)
			{
				if(eval("document.add_survey_questions.option_point"+option_point_counter).value == '' && eval("document.add_survey_questions.add_row_kontrol"+option_point_counter).value == 1)
				{
					alert(eval("document.add_survey_questions.option_row"+option_point_counter).value + '.' +"<cf_get_lang dictionary_id='29803.Seçenek İçin Puan Giriniz'> !");
					return false;
				}
			}
		}
		
	}
	
	document.getElementById('question_head').value = document.getElementById('question_head').value.replace(/\n/g, " ");
	var survey_chapter_id = <cfoutput>#attributes.survey_chapter_id#</cfoutput>;
	var survey_id = $("#survey_id").val();
	var currentrow = $("#currentrow").val();
	AjaxFormSubmit('add_survey_questions','survey_question','0');
	<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	closeBoxDraggable('add_question_'+currentrow);
	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_list_detailed_survey_questions&survey_chapter_id='+survey_chapter_id+'&survey_id='+survey_id);
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
function sil(sy)
{
    row_count_options--;
	document.add_survey_questions.option_record_num.value=row_count_options;
	var my_element=eval("add_survey_questions.add_row_kontrol"+sy);
	my_element.value=0;
	var my_element=eval("frm_row_options"+sy);
	my_element.style.display="none";
}
function add_option_row()
{	
	document.getElementById("add_new_option").value = 1;
	row_count_options++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table_add_options").insertRow(document.getElementById("table_add_options").rows.length);
	newRow.setAttribute("name","frm_row_options" + row_count_options);
	newRow.setAttribute("id","frm_row_options" + row_count_options);	
	newRow.setAttribute("NAME","frm_row_options" + row_count_options);
	newRow.setAttribute("ID","frm_row_options" + row_count_options);				
	document.add_survey_questions.option_record_num.value=row_count_options;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="hidden" name="add_row_kontrol'+row_count_options+'" value="1"><a style="cursor:pointer" onclick="sil(' + row_count_options + ');"><img src="images/delete_list.gif" border="0"></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="option_row'+row_count_options+'" value="'+row_count_options+'" style="width:25px;" class="box" readonly>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="option_head'+row_count_options+'" value="" style="width:275px;">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="option_detail'+row_count_options+'" value="" style="width:275px;" maxlength="4000">';
	/*newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="file" name="option_image'+row_count_options+'" value="" style="width:150px;">';*/
	/*newCell = newRow.insertCell(newRow.cells.length);
	if(document.getElementById('question_type').value == 1 || document.getElementById('question_type').value == '')
		newCell.innerHTML = '<input type="checkbox" name="option_add_note'+row_count_options+'" id="option_add_note'+row_count_options+'"  value="" style="width:25px;">';
	else
		newCell.innerHTML = '<input type="checkbox" name="option_add_note'+row_count_options+'" id="option_add_note'+row_count_options+'" disabled value="" style="width:25px;">';*/
	newCell = newRow.insertCell(newRow.cells.length);
	if(document.getElementById('question_type').value == 3 || document.getElementById('question_type').value == 5)
		newCell.innerHTML = '<input type="text" name="option_point'+row_count_options+'"  id="option_point'+row_count_options+'" disabled value="" maxlength="3" onkeyup="isNumber(this);" class="moneybox" style="width:25px;">';
	else
		newCell.innerHTML = '<input type="text" name="option_point'+row_count_options+'"  id="option_point'+row_count_options+'" value="" maxlength="3" onkeyup="isNumber(this);" class="moneybox" style="width:25px;">';

}
</script>