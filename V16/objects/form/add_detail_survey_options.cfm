<cfsetting showdebugoutput="no">
<cfparam name="attributes.stream_name" default="#createUUID()#"/>
<cfparam name="attributes.add_new_option" default="0">
<cfquery name="get_survey_options" datasource="#dsn#"><!--- bolume eklenen siklar --->
	SELECT 
		QUESTION_TYPE,
		QUESTION_DESIGN,
		SCORE_RATE1,
		SCORE_RATE2,
		OPTION_HEAD,
		OPTION_DETAIL,
		OPTION_NOTE,
		OPTION_POINT,
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_EMP,
		UPDATE_DATE,
		(SELECT SURVEY_CHAPTER_DETAIL2 FROM SURVEY_CHAPTER SC WHERE SC.SURVEY_CHAPTER_ID = SURVEY_OPTION.SURVEY_CHAPTER_ID) CHAPTER_DETAIL2,
		(SELECT IS_CHAPTER_DETAIL2 FROM SURVEY_CHAPTER SC WHERE SC.SURVEY_CHAPTER_ID = SURVEY_OPTION.SURVEY_CHAPTER_ID) IS_CHAPTER_DETAIL2
	FROM 
		SURVEY_OPTION
	WHERE 
		SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_chapter_id#"> AND 
		SURVEY_QUESTION_ID IS NULL
</cfquery>
 <cfquery name="get_chapter_option_detail" datasource="#dsn#"><!--- bölümün soru ekle/guncelle sayfalarinda  --->
	SELECT SURVEY_CHAPTER_ID FROM SURVEY_OPTION WHERE SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_chapter_id#"> AND SURVEY_QUESTION_ID IS NOT NULL
</cfquery>
<cfquery name="get_chapter_detail2" datasource="#dsn#">
	SELECT SURVEY_CHAPTER_DETAIL2,IS_CHAPTER_DETAIL2,IS_SHOW_GD,SURVEY_CHAPTER_HEAD FROM SURVEY_CHAPTER WHERE SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_chapter_id#">
</cfquery>
<cfset get_result = createObject("component","V16.objects.cfc.get_survey_result").getSurveyResult(dsn:dsn,survey_main_id:attributes.survey_id)>
<cf_box title="#getLang('','Şıklar',60274)#:#get_chapter_detail2.survey_chapter_head#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<div id="survey_question"></div><!--- AjaxFormSubmit icin kullaniliyor --->
	<cfform name="add_survey_options" onsubmit="return false;" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_detail_survey_options">
		<input type="hidden" name="add_new_option" id="add_new_option" value=""><!--- Sayfa gonderildiginde deger ataniyor,queryde kullaniliyor silmeyin --->
		<input type="hidden" name="survey_id" id="survey_id" value="<cfoutput>#attributes.survey_id#</cfoutput>">
		<input type="hidden" name="survey_chapter_id" id="survey_chapter_id" value="<cfoutput>#attributes.survey_chapter_id#</cfoutput>">
		<input type="hidden" name="option_record_num" id="option_record_num" value="<cfoutput>#get_survey_options.recordCount#</cfoutput>">
		<cf_box_elements>
			<table>
				<!--- <tr class="color-header" id="table_options_1"<cfif get_survey_options.question_type neq 4>style="display:"<cfelse>style="display:none"</cfif>> 
					<td class="form-title" height="20" colspan="2">&nbsp;<cf_get_lang_main no='2000.Şıklar ve Seçenekler'></td>
				</tr> --->
				<div class="ui-form-list">
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='29792.Tasarım'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<select name="question_design" id="question_design" style="width:200px;" <cfif get_survey_options.question_type eq 3 or get_chapter_option_detail.recordcount>disabled="disabled"</cfif>>
								<option value="1"<cfif get_survey_options.question_design eq 1>selected</cfif>><cf_get_lang dictionary_id='29793.Dikey'></option>
								<option value="2"<cfif get_survey_options.question_design eq 2>selected</cfif>><cf_get_lang dictionary_id='29794.Yatay'></option>
							</select>
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='57630.Tip'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<select name="question_type" id="question_type" style="width:200px;" onchange="change_display()" <cfif get_chapter_option_detail.recordcount>disabled</cfif>>
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<option value="1"<cfif get_survey_options.question_type eq 1>selected</cfif>><cf_get_lang dictionary_id='29795.Tekli'></option>
								<option value="2"<cfif get_survey_options.question_type eq 2>selected</cfif>><cf_get_lang dictionary_id='58032.Çoklu'></option>
								<option value="3"<cfif get_survey_options.question_type eq 3>selected</cfif>><cf_get_lang dictionary_id='60191.Metin'></option>
								<!--- <option value="4"<cfif get_survey_options.question_type eq 4>selected</cfif>><cf_get_lang_main no='1975.Skor'></option> --->
								<option value="5"<cfif get_survey_options.question_type eq 5>selected</cfif>><cf_get_lang dictionary_id='60192.Paragraf Metin'></option>
							</select>
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='57629.Açıklama'><input type="checkbox" name="IS_CHAPTER_DETAIL2" id="IS_CHAPTER_DETAIL2" value="0" <cfif get_chapter_detail2.IS_CHAPTER_DETAIL2 eq 1>checked</cfif>></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<textarea name="chapter_detail2" id="chapter_detail2" style="width:200px;height:40px;" maxlength="4000" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);"><cfoutput>#get_chapter_detail2.survey_chapter_detail2#</cfoutput></textarea>
						</div>
					</div>
				</div>
				<table>
					<tr id="gd_check" <cfif get_survey_options.question_type neq 1>style="display:none"</cfif>>
						<td>&nbsp;</td>
						<td><input type="checkbox" name="is_show_gd" id="is_show_gd" value="1"<cfif get_chapter_detail2.is_show_gd eq 1>checked</cfif>><cf_get_lang dictionary_id='60193.GD seçeneği'></td>
					</tr>
					<!--- <tr>
						<td id="option_score_rate" <cfif get_survey_options.question_type eq 4>style="display:"<cfelse>style="display:none"</cfif>>Min. Max.&nbsp;</td>
						<td id="option_score_rate_" <cfif get_survey_options.question_type eq 4>style="display:"<cfelse>style="display:none"</cfif>>
							<input type="text" name="option_score_rate1" maxlength="4" id="option_score_rate1" onkeyup="option_point_off();" onblur="option_point_off();" value="<cfoutput>#get_survey_options.score_rate1#</cfoutput>" style="width:30px">
							<input type="text" name="option_score_rate2"  maxlength="4" id="option_score_rate2" onkeyup="option_point_off();" onblur="option_point_off();" value="<cfoutput>#get_survey_options.score_rate2#</cfoutput>" style="width:30px">
						</td>
					</tr> --->
				</table>
				<cfif not get_chapter_option_detail.recordcount>
					<!---  <tr id="table_options_2" <cfif get_survey_options.question_type neq 4>style="display:"<cfelse>style="display:none"</cfif>>  --->
					<tr id="table_options_2 style="display:""> 			 
						<td class="txtbold">
							<cf_grid_list>
								<thead>
									<tr name="frm_row_options" id="frm_row_options" class="color-list">
										<th width="10"><input type="button" class="eklebuton" onClick="add_option_row();"></th>
										<th style="width:15px"><cf_get_lang dictionary_id='57487.No'></th>
										<th><cf_get_lang dictionary_id='29798.Seçenekler'></th>
										<th width="200"><cf_get_lang dictionary_id='57771.Detay'></th>
										<!--- <th width="25"><cf_get_lang_main no='55.Not'></th> --->
										<th width="25"><cf_get_lang dictionary_id='58984.Puan'></th>
									</tr>
								</thead>
								<tbody id="table_add_options">
									<cfoutput query="get_survey_options">
										<tr name="frm_row_options#currentrow#" id="frm_row_options#currentrow#" class="color-row">
											<td><input type="hidden" name="add_row_kontrol#currentrow#" id="add_row_kontrol#currentrow#" value="1">
												<a style="cursor:pointer" onclick="sil(#currentrow#);"><img  src="images/delete_list.gif"  border="0" title="<cf_get_lang dictionary_id='57463.Sil'>"></a>
											</td>
											<td align="left"><input type="text" name="option_row#currentrow#" id="option_row#currentrow#" value="#currentrow#" style="width:25px;" maxlength="3" class="box" readonly=""></td>
											<td><input type="hidden" name="frm_row_options#currentrow#" id="frm_row_options#currentrow#" value="1">
												<input type="text" name="option_head#currentrow#" id="option_head#currentrow#" value="#option_head#" style="width:200px;" maxlength="250"></td>
											<td><input type="text" name="option_detail#currentrow#" id="option_detail#currentrow#" value="#option_detail#" style="width:275px;" maxlength="4000"></td>
											<!--- <td><input type="checkbox" name="option_add_note#currentrow#" id="option_add_note#currentrow#" <cfif get_survey_options.question_type neq 1>disabled="disabled"</cfif>value="" <cfif get_survey_options.option_note is 1>checked</cfif> style="width:25px;"></td> --->
											<td><input type="text" name="option_point#currentrow#" id="option_point#currentrow#" <cfif get_survey_options.question_type eq 3 or get_survey_options.question_type eq 5>disabled="disabled"</cfif> value="#option_point#" maxlength="3" onkeyup="isNumber(this);" class="moneybox" style="width:25px;"></td>
										</tr> 
									</cfoutput>
								</tbody>
							</cf_grid_list>
						</td>
					</tr>
				</cfif>
			</table>
		</cf_box_elements>
		<cf_box_footer>
			<cfif get_survey_options.recordcount>
				<cf_record_info query_name="get_survey_options">
			<cfelseif get_survey_options.recordcount>
				<cf_record_info query_name="get_survey_options">
			</cfif>
			<cfif not get_result.recordcount>
				<cf_workcube_buttons is_upd='0' is_cancel='1' add_function='kontrol()'>
            <cfelse>
                <span class="bold" style="color:red;"><cf_get_lang dictionary_id='63771.Form kullanıldığı için güncellenemez'>!</span>
			</cfif>
		</cf_box_footer>
	</cfform>  
</cf_box>
<script type="text/javascript">
function change_display()
{
	if(document.getElementById('question_type').value == 1)
	{
		document.getElementById('question_design').disabled = false;
		if(document.getElementById('option_score_rate') != undefined)
			document.getElementById('option_score_rate').style.display = 'none';
		if(document.getElementById('option_score_rate_') != undefined)
			document.getElementById('option_score_rate_').style.display = 'none';
		if(document.getElementById('table_options_1') != undefined)
			table_options_1.style.display = '';
		if(document.getElementById('table_options_2') != undefined)
			table_options_2.style.display = '';
		for(i=1;i<=document.add_survey_options.option_record_num.value;i++)
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
		document.getElementById('question_design').disabled = false;
		document.getElementById('question_design').disabled = false;
		if(document.getElementById('option_score_rate') != undefined)
			document.getElementById('option_score_rate').style.display = 'none';
		if(document.getElementById('option_score_rate_') != undefined)
			document.getElementById('option_score_rate_').style.display = 'none';
		if(document.getElementById('table_options_1') != undefined)
			table_options_1.style.display = '';
		if(document.getElementById('table_options_2') != undefined)
			table_options_2.style.display = '';
		for(i=1;i<=document.add_survey_options.option_record_num.value;i++)
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
		document.getElementById('question_design').disabled = true; 
		if(document.getElementById('option_score_rate') != undefined)
			document.getElementById('option_score_rate').style.display = 'none';
		if(document.getElementById('option_score_rate_') != undefined)
			document.getElementById('option_score_rate_').style.display = 'none';
		if(document.getElementById('table_options_1') != undefined)
			table_options_1.style.display = '';
		if(document.getElementById('table_options_2') != undefined)
			table_options_2.style.display = '';
		for(i=1;i<=document.add_survey_options.option_record_num.value;i++)
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
		document.getElementById('question_design').disabled = false; 
		document.getElementById('question_design').disabled = false;
		if(document.getElementById('option_score_rate') != undefined)
			document.getElementById('option_score_rate').style.display = '';
		if(document.getElementById('option_score_rate_') != undefined)
			document.getElementById('option_score_rate_').style.display = '';
		if(document.getElementById('table_options_1') != undefined)
			table_options_1.style.display = 'none';
		if(document.getElementById('table_options_2') != undefined)
			table_options_2.style.display = 'none';
		gd_check.style.display = 'none';
	}*/
}

row_count_options=document.add_survey_options.option_record_num.value;
function kontrol()
{
	<cfif not get_chapter_option_detail.recordcount>
	if(document.getElementById('question_type').value == '')
	{
		alert("<cf_get_lang dictionary_id='29789.Soru Tipi Seçiniz'>!");
		return false;
	}
	
	/*if(document.getElementById('question_type').value != 4)
	{*/
		if(document.add_survey_options.option_record_num.value == 0)
		{
			alert("<cf_get_lang dictionary_id='29790.Seçenek Ekleyiniz'> !");
			return false;
		}
		for (var counter_=1; counter_ <=  document.add_survey_options.option_record_num.value; counter_++)
		{
			if(eval("document.add_survey_options.option_head"+counter_).value == '' && eval("document.add_survey_options.add_row_kontrol"+counter_).value == 1)
			{
				alert("<cf_get_lang dictionary_id='29802.Seçenek için Başlık Giriniz'>! " + eval("document.add_survey_options.option_row"+counter_).value);
				return false;
			}
		}
		if(document.getElementById('question_type').value == 1 || document.getElementById('question_type').value == 2)
		{
			for (var option_point_counter=1; option_point_counter <=  document.add_survey_options.option_record_num.value; option_point_counter++)
			{
				if(eval("document.add_survey_options.option_point"+option_point_counter).value == '' && eval("document.add_survey_options.add_row_kontrol"+option_point_counter).value == 1)
				{
					alert("<cf_get_lang dictionary_id='29803.Seçenek İçin Puan Giriniz'>" + eval("document.add_survey_options.option_row"+option_point_counter).value);
					return false;
				}
			}
		} 
	//}
	</cfif>

	AjaxFormSubmit('add_survey_options','survey_question',0,'body_div_related_chapter');
	<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	$("#div_related_chapter .catalyst-refresh").click();
	return false;

}
/*function option_point_off()
{
	if(parseInt(document.getElementById('option_score_rate1').value) > parseInt(document.getElementById('option_score_rate2').value))
	{
		alert("<cf_get_lang_main no='1994.Min Değeri Max Değerinden Büyük Olamaz'> !");
		document.getElementById('option_score_rate1').value = ' ';
		return false;
	}
}	*/
function sil(sy)
{
	var my_element=eval("add_row_kontrol"+sy);
	my_element.value='0';
	console.log(my_element);
	var my_element=eval("frm_row_options"+sy);
	try
	{
	my_element=document.getElementById('frm_row_options'+sy);
	my_element.style.display="none";
	} catch(err){};
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
	document.add_survey_options.option_record_num.value=row_count_options;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="hidden" name="add_row_kontrol'+row_count_options+'" value="1"><a style="cursor:pointer" onclick="sil(' + row_count_options + ');"><img src="images/delete_list.gif" border="0"></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="option_row'+row_count_options+'" value="'+row_count_options+'" style="width:25px;" class="box" readonly>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="option_head'+row_count_options+'" value="" style="width:200px;">';
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
	if(document.getElementById('question_type').value == 3)
		newCell.innerHTML = '<input type="text" name="option_point'+row_count_options+'"  id="option_point'+row_count_options+'" disabled value="" maxlength="3" onkeyup="isNumber(this);" class="moneybox" style="width:25px;">';
	else
		newCell.innerHTML = '<input type="text" name="option_point'+row_count_options+'"  id="option_point'+row_count_options+'" value="" maxlength="3" onkeyup="isNumber(this);" class="moneybox" style="width:25px;">';

}
</script>