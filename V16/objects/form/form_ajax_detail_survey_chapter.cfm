<cfsetting showdebugoutput="no">
<cfset cfc=createObject("component","V16.training_management.cfc.training_survey")> 
<cfset get_survey_chapter=cfc.GetSurveyChapter(survey_id:attributes.survey_id)>
<cfparam name="attributes.add_new_chapter" default="0">
<div id="survey_chapter"></div><!--- AjaxFormSubmit icin kullaniliyor --->
<cfform name="add_survey_chapter" id="add_survey_chapter" method="post" action="#request.self#?fuseaction=objects.emptypopup_ajax_detail_survey_chapter&survey_chapter_id=#get_survey_chapter.survey_chapter_id#">
    <div class="col col-8">
		<cf_grid_list>
			<cfoutput>
				<input type="hidden" name="survey_id" id="survey_id" value="#attributes.survey_id#">
				<input type="hidden" name="record_num" id="record_num" value="#get_survey_chapter.recordcount#">
				<input type="hidden" name="add_new_chapter" id="add_new_chapter" value="<cfif get_survey_chapter.recordCount>1</cfif>"><!--- Sayfa gonderildiginde deger ataniyor,queryde kullaniliyor silmeyin --->
				<input type="hidden" name="add_new_question" id="add_new_question" value=""><!--- Sayfa gonderildiginde deger ataniyor,queryde kullaniliyor silmeyin --->
			</cfoutput>
			<thead>
				<tr>
					<th width="10"><input type="button" class="eklebuton" onClick="add_row();"></th>
					<th width="10"></th>
					<th width="10"></th>
					<th><cf_get_lang dictionary_id="57789.Özel Kod"></th>
					<th><cf_get_lang dictionary_id="57995.Bölüm"></th>
					<th><cf_get_lang dictionary_id="57771.Detay"></th>
					<th><cf_get_lang dictionary_id="29784.Agirlik"> (%)</th>
				</tr>
			</thead>
			<tbody id="table_add_chapter">
				<cfif get_survey_chapter.recordCount>
					<cfset attributes.record_num_list = "">
					<cf_box_elements>
						<cfoutput query="get_survey_chapter">
						<tr name="frm_row#currentrow#" id="frm_row#currentrow#">
							<td width="15px">
								<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
								<a title="<cf_get_lang dictionary_id='57463.Sil'>" style="cursor:pointer" onClick="sil(#currentrow#);"><i class="fa fa-minus"></i></a>
							</td>
							<td width="15px">
								<a href="javascript://" class="tableyazi" title="<cf_get_lang dictionary_id='60274.Şıklar'>" onClick="openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_add_detail_survey_options&survey_id=#attributes.survey_id#&survey_chapter_id=#survey_chapter_id#','','ui-draggable-box-medium');"><i class="fa fa-list-ul"></i></a>
							</td>
							<td width="15px">
								<a style="cursor:pointer" onClick="open_questions_list('#currentrow#','#survey_chapter_id#','#survey_id#');" title="<cf_get_lang dictionary_id='58087.Sorular'>"><i class="fa fa-question-circle"></i></a>
							</td>
							<td>
								<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
									<div class="form-input">
										<input type="text" name="survey_chapter_code#currentrow#" id="survey_chapter_code#currentrow#" value="#survey_chapter_code#" maxlength="50">
									</div>
								</div>
							</td>
							<td>
								<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
									<div class="form-input">
										<input type="hidden" name="survey_chapter_id#currentrow#" id="survey_chapter_id#currentrow#" value="#survey_chapter_id#">
										<input type="text" name="survey_chapter_head#currentrow#" id="survey_chapter_head#currentrow#" value="#survey_chapter_head#" maxlength="50">
									</div>
								</div>
							</td>
							<td>
								<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
									<div class="form-input">
										<input type="text" name="survey_chapter_detail#currentrow#" id="survey_chapter_detail#currentrow#" value="#survey_chapter_detail#" style="width:300px;" maxlength="4000">
									</div>
								</div>
							</td>
							<td>
								<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
									<div class="form-input">
										<cfinput type="text" name="survey_chapter_weight#currentrow#" id="survey_chapter_weight#currentrow#" value="#tlformat(survey_chapter_weight,0)#" validate="float" style="width:50px" message="Agirlik için 1 ile 100 arasinda bir sayi giriniz !" required="yes" range="1,100" onkeyup="return(FormatCurrency(this,event));">
									</div>
								</div>
							</td>
						</tr>
						<tr id="related_question_list_#currentrow#" style="display:none;" class="nohover">
							<td>
								<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
									<div class="form-input">
										<div id="add_question_#currentrow#"></div><!--- Soru Ekleme ve Listeleme ajaxlari icin kullaniliyor --->
									</div>
								</div>
							</td>
						</tr>
						</cfoutput>
					</cf_box_elements>
				</cfif>
			</tbody>
			<!--- <tfoot>
				<tr>
					<td colspan="7"></td>
				</tr>
			</tfoot> --->
		</cf_grid_list>
		<cf_workcube_buttons is_upd='0' add_function='rel_kontrol()' is_cancel='0' type_format="1">
	</div>
 </cfform>
<script type="text/javascript">
row_count=<cfoutput>#get_survey_chapter.recordcount#</cfoutput>;
function rel_kontrol()
{	
	for (var counter_=1; counter_ <= row_count; counter_++)
	{
		fld = eval("document.all.survey_chapter_weight"+counter_);
		fld.value=filterNum(fld.value);
		if(eval("document.all.survey_chapter_head"+counter_).value == '' && eval("document.all.row_kontrol"+counter_).value == 1)
		{
			alert("<cf_get_lang dictionary_id='58059.Başlık Girmelisiniz'>!");
			return false;
			
		}
	 	 else if(eval("add_survey_chapter.survey_chapter_weight"+counter_).value == '')
		{
			alert("<cf_get_lang dictionary_id='46688.Agirlik için 1 ile 100 arasinda bir sayi giriniz'>!");
			return false;
		} 	
	}
	
	document.getElementById("add_new_chapter").value = 1;
		
	AjaxFormSubmit('add_survey_chapter','survey_chapter',1,'','','','',1);
	return false;
}
function add_row()
{	
	document.getElementById("add_new_chapter").value = 1;
	row_count++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table_add_chapter").insertRow(document.getElementById("table_add_chapter").rows.length);
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);	
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);
	document.add_survey_chapter.record_num.value=row_count;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("nowrap","nowrap");
	newCell.setAttribute("max-width","10");
	newCell.innerHTML = '<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12"><div class="form-input"><input type="hidden" name="row_kontrol'+row_count+'" id="row_kontrol'+row_count+'" value="1"><a style="cursor:pointer" onclick="sil(' + row_count + ');"><i class="fa fa-minus"></i></a></div></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12"><a style="cursor:pointer" onclick="add_question_();" title="<cf_get_lang dictionary_id='60274.Şıklar'>"><i class="fa fa-list-ul"></i></a></div></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12"><a style="cursor:pointer" onclick="add_question_();" title="<cf_get_lang dictionary_id='58087.Sorular'>"><i class="fa fa-question-circle"></i></a></div></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12"><div class="form-input"><input type="text" name="survey_chapter_code'+row_count+'" id="survey_chapter_code'+row_count+'" value="" maxlength="50"></div></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12"><div class="form-input"><input type="hidden" name="survey_chapter_id'+row_count+'" id="survey_chapter_id'+row_count+'" value=""><input type="text" name="survey_chapter_head'+row_count+'" id="survey_chapter_head'+row_count+'" value="" maxlength="250"></div></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12"><div class="form-input"><input type="text" name="survey_chapter_detail'+row_count+'" id="survey_chapter_detail'+row_count+'" value="" maxlength="4000"></div></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12"><div class="form-input"><input type="text" name="survey_chapter_weight'+row_count+'" id="survey_chapter_weight'+row_count+'" value="1" validate="float" message="Agirlik için 1 ile 100 arasinda bir sayi giriniz !" required="yes" range="1,100" onkeyup="return(FormatCurrency(this,event));"></div></div>';
}
function sil(sy)
{	
	var my_element=eval("document.all.row_kontrol"+sy);
	my_element.value=0;
	var my_element=eval("frm_row"+sy);
	my_element.style.display="none";
	try
	{
	my_element=document.getElementById('related_question_list_'+sy);
	my_element.style.display="none";
	} catch(err){};
}		
function open_questions_list(crn,chid,sur_id,type)
{	
	div_id = 'add_question_'+crn;
	var page = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_detailed_survey_questions&crn='+crn+'&survey_id='+sur_id+'&survey_chapter_id=</cfoutput>'+chid;
	openBoxDraggable(page,div_id,1);
}
function add_question_()
{	
	alert("<cf_get_lang dictionary_id='29770.Önce Bölümü Kaydediniz'> !");
}
</script>