<cfset cfc= createObject("component","workdata.get_print_files_cats")>
<cfset get_print_cats=cfc.GetPrintCats()>
<cfif isdefined("fusebox.use_period") and fusebox.use_period eq true>
<cfquery name="GET_PRINT_QUALITIES" datasource="#DSN3#">
	SELECT 
        FORM_ID,
        START_DATE,
        QUALITY_NO
    FROM 
    	SETUP_PRINT_FILES_QUALITY
    WHERE
   		FORM_ID = #attributes.form_id#
</cfquery>
</cfif>
<cfquery name="GET_TEMPLATE" datasource="#dsn3#">
	SELECT 
	    FORM_ID, 
        PROCESS_TYPE, 
        MODULE_ID, 
        ACTIVE, 
		#dsn#.Get_Dynamic_Language(FORM_ID,'#session.ep.language#','SETUP_PRINT_FILES','NAME',NULL,NULL,NAME) AS NAME,
        TEMPLATE_FILE, 
        DETAIL, 
        IS_DEFAULT, 
        TEMPLATE_FILE_SERVER_ID, 
        IS_STANDART, 
        IS_PARTNER, 
        RECORD_DATE, 
        RECORD_IP, 
        RECORD_EMP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_PRINT_FILES 
    WHERE 
	    FORM_ID = #attributes.form_id#
</cfquery>

<cfinclude template="../query/get_print_files.cfm">
<cfinclude template="../query/get_print_files_positions.cfm">
<cfinclude template="../query/get_print_files_position_cats.cfm">
<cfform name="add_invoice_template" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_print_files">
	<cf_box title="#getLang('','Sistem İçi Yazıcı Belgeleri',42837)#" add_href="#request.self#?fuseaction=settings.form_add_print_files" closable="0" collapsed="0">
	<cf_box_elements>
			<cfoutput>
				<input type="hidden" name="document_id" id="document_id" value="#get_print_files.form_id#">
				<input type="hidden" name="position_cats" id="position_cats" value="#ValueList(get_print_files_position_cats.pos_cat_id)#">
				<input type="hidden" name="positions2" id="positions2" value="#ValueList(get_print_files_positions.pos_code)#">
			</cfoutput>
			<div class="col col-4 col-xs-12">
				<div class="scrollbar" style="max-height:357px;overflow:auto;">
					<div id="cc">
						<cfinclude template="../display/list_print_files.cfm">
					</div>
				</div>
			</div>
			<div class="col col-4 col-xs-12">
				<input type="hidden" name="is_standart" id="is_standart" value="<cfif len(get_template.is_standart)><cfoutput>#get_template.is_standart#</cfoutput><cfelse>0</cfif>">
				<input type="hidden" name="form_id" id="form_id" value="<cfoutput>#attributes.form_id#</cfoutput>">
				<input type="hidden" name="old_template_file" id="old_template_file" value="<cfoutput>#get_template.template_file#</cfoutput>">
				<input type="hidden" name="old_template_file_server_id" id="old_template_file_server_id" value="<cfoutput>#get_template.template_file_server_id#</cfoutput>">
				<div class="form-group">
					<label class="col col-2 col-xs-2"><cf_get_lang dictionary_id='57756.Durum'></label>
					<label class="col col-2 col-xs-2"><input name="active" id="active" type="checkbox" value="1" <cfif get_template.active eq 1>checked</cfif>><cf_get_lang dictionary_id='57493.Aktif'></label>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58820.Başlık'>*</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
						<cfinput type="text" name="template_head" maxlength="100" value="#get_template.name#" required="yes" message="#getLang('','Başlık Girmelisiniz',58059)#">
						<span class="input-group-addon">
							<cf_language_info
							table_name="SETUP_PRINT_FILES"
							column_name="NAME" 
							column_id_value="#attributes.form_id#" 
							maxlength="500" 
							datasource="#dsn3#" 
							column_id="FORM_ID" 
							control_type="0">
							</span></div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'>*</label>
					<div class="col col-8 col-xs-12">
						<select name="process_type" id="process_type">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_print_cats">
							<option value="#print_type#-#print_module_id#" <cfif len(get_template.process_type) and (get_template.process_type eq print_type)>selected</cfif>>#print_namenew#&nbsp;(#print_type#)</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-2"><cf_get_lang dictionary_id='57691.Dosya'></label>
					<cfif get_template.is_standart eq 1>
						<div class="col col-8 col-xs-8">
							<div class="input-group">
							<input type="file" name="template_file" id="template_file" style="display:none;">
							<input type="text" name="file_name" id="file_name" readonly="" value="<cfoutput>#get_template.template_file#</cfoutput>">
							<span id="value1" class="input-group-addon btnPointer icon-add" style="display:none;" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_standart_print_files&field_name=add_invoice_template.file_name&field_id=add_invoice_template.template_file&standart=add_invoice_template.is_standart&field_detail=add_invoice_template.detail&field_process_type=add_invoice_template.process_type');"></span><span class="input-group-addon btnPointer icon-minus" href="javascript://" id="value2" onclick="temizle();"></span>
						</div>
						</div>
					<cfelse>
						<div class="col col-8 col-xs-8">
							<input type="file" name="template_file" id="template_file">
							<input type="text" name="file_name" id="file_name" style="display:none;" readonly="" value="">
						</div>
						<label class="col col-1 col-xs-1"><a id="value1" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_standart_print_files&field_name=add_invoice_template.file_name&field_id=add_invoice_template.template_file&standart=add_invoice_template.is_standart&field_detail=add_invoice_template.detail&field_process_type=add_invoice_template.process_type');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a><a href="javascript://" id="value2" style="display:none;" onclick="temizle();"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></label>
					</cfif>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
					<div class="col col-8 col-xs-12">
						<textarea name="detail" id="detail" alue=""><cfoutput>#get_template.detail#</cfoutput></textarea>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-12 col-xs-12"><input type="checkbox" name="is_default" id="is_default" value="1"<cfif get_template.is_default eq 1> checked</cfif>><cf_get_lang dictionary_id ='43115.Standart Seçenek Olarak Gelsin'> (<cf_get_lang dictionary_id='43116.Default'>)</label>
				</div>	
				<div class="form-group">
					<label class="col col-12 col-xs-12"><input type="checkbox" name="is_partner" id="is_partner" value="1"<cfif get_template.is_partner eq 1> checked</cfif>><cf_get_lang dictionary_id ='43008.İnternetde Gürünsün'></label>
				</div>	
				<div class="form-group">
					<label class="col col-2 col-xs-2"><cf_get_lang dictionary_id='57691.Dosya'></label>
					<cfif get_template.is_standart eq 1>
						<label class="col col-9 col-xs-9"><cfoutput>#get_template.template_file#</cfoutput></label>
					<cfelse>
						<label class="col col-9 col-xs-9">documents\settings\<cfoutput>#get_template.template_file#</cfoutput></label>
					</cfif>
				</div>
			</div>
			<div class="col col-4 col-xs-12">
				<cfsavecontent variable="txt1"><cf_get_lang dictionary_id='42683.Yetkili Pozisyonlar'></cfsavecontent>
				<cf_workcube_to_cc 
					is_update="1" 
					to_dsp_name="#txt1#" 
					form_name="add_invoice_template" 
					str_list_param="1" 
					data_type="2" 
					action_dsn="#DSN#"
					action_id_name="FORM_ID"
					action_id="#attributes.form_id#"
					str_action_names="POS_CODE AS TO_POS_CODE"
					str_alias_names = ""
					action_table="SETUP_PRINT_FILES_POSITION"
					our_comp_id="#session.ep.company_id#">
				<cf_ajax_list class="workDevList"  id="td_yetkili2">
					<thead>	
						<tr>	
						<th width="20">
						<a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_position_cats&field_id=add_invoice_template.position_cats&field_td=td_yetkili2&is_noclose=1</cfoutput>');"><i class="icon-pluss" align="absmiddle" border="0"></i></a>
						</th>
						<th>
						<cf_get_lang dictionary_id='42736.Yetkili Pozisyon Tipleri'>
						</th>
					</tr>
					</thead>
					<cfif get_print_files_position_cats.recordcount>
						<cfoutput query="get_print_files_position_cats">
							<tr><td>
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=settings.emptypopup_del_print_position_cat&document_id=#get_print_files.form_id#&pos_cat_id=#POS_CAT_ID#','small');"><i class="fa fa-minus"></i></a> 
							</td><td>
							#position_cat#
						</td></tr>
						</cfoutput>
					</cfif>
				</cf_ajax_list>
				<cfif isdefined("fusebox.use_period") and fusebox.use_period eq true>
					<cf_ajax_list id="kalite_table">
						<thead>
							<tr>
								<th width="20">
									<a title="<cf_get_lang dictionary_id ='57582.Ekle'>" onClick="add_row();"><i class="icon-pluss" align="absmiddle" border="0"></i></a>
									<input name="record_num" id="record_num" type="hidden" value="<cfoutput>#get_print_qualities.recordcount#</cfoutput>">
								</th>
								<th><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
								<th><cf_get_lang dictionary_id='32063.Kalite'> <cf_get_lang dictionary_id='57487.No'></th>
							</tr>
						</thead>
						<tbody id="table1">
							<cfoutput query="get_print_qualities">
								<tr id="frm_row#currentrow#">
									<td><a style="cursor:pointer" onClick="sil('#currentrow#');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
									<td>
										<div class="form-group">
											<div class="col col-12 col-xs-12">
												<div class="input-group">
													<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1" >
													<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id="58053.Başlangıç Tarihi"></cfsavecontent>
													<cfinput value="#dateformat(start_date,dateformat_style)#" type="text" name="startdate#currentrow#" message="#message#" validate="#validate_style#">
													<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
												</div>
											</div>
										</div>
									</td>
									<td>
										<div class="form-group">
											<div class="col col-12 col-xs-12">
												<cfinput type="text" name="quality_no#currentrow#" value="#quality_no#" />
											</div>
										</div>
									</td>
								</tr>
							</cfoutput>
						</tbody>
					</cf_ajax_list>
				</cfif>
			</div>
		</cf_box_elements>
		<cf_box_footer>	
			<div class="col col-6 col-xs-6">
				<cf_record_info query_name="get_template">
			</div>
			<div class="col col-6 col-xs-6">
				<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_print_files&form_id=#get_template.form_id#&old_template_file=#get_template.template_file#&old_template_file_server_id=#get_template.template_file_server_id#' add_function='kontrol()'>
			</div>
		</cf_box_footer>
	</cf_box>
</cfform>
<script type="text/javascript">
<cfif isdefined("fusebox.use_period") and fusebox.use_period eq true>
row_count=<cfoutput>#get_print_qualities.recordcount#</cfoutput>;
function add_row()
{
	row_count++;
	var newRow;
	var newCell;
		
	newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);
	document.getElementById('record_num').value = row_count;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0" align="absmiddle"></a><input type="hidden"  value="1" id="row_kontrol' + row_count +'" name="row_kontrol' + row_count +'">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("id","startdate" + row_count + "_td");
	newCell.innerHTML = '<div class="form-group"><div class="col col-12 col-xs-12"><div class="input-group"><input type="text" name="startdate' + row_count +'" id="startdate' + row_count +'"><span class="input-group-addon" id="edate_'+row_count+'"></span></div></div></div>';
	wrk_date_image('startdate' + row_count);
	$('#edate_'+row_count).append($('#startdate'+row_count+'_image'));
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><div class="col col-12 col-xs-12"><input type="text" name="quality_no' + row_count +'" id="quality_no' + row_count +'"></div></div>';
}
</cfif>
function sil(sy)
{
	document.getElementById('row_kontrol'+sy).value = 0;
	document.getElementById('frm_row'+sy).style.display = 'none';	
}

function temizle()
{
	add_invoice_template.template_file.style.display='';
	add_invoice_template.file_name.style.display='none';
	value1.style.display='';
	value2.style.display='none';
	add_invoice_template.file_name.value='';
	add_invoice_template.process_type.value='';
	add_invoice_template.detail.value='';
	add_invoice_template.is_standart.value=0;
}

function kontrol()
{
	if(document.add_invoice_template.process_type.value == '')
	{
		alert("<cf_get_lang dictionary_id='58770.İşlem Tipi Seçmelisiniz'> !");
		return false;
	}
	x =(200-add_invoice_template.detail.value.length);
	if(x<0)
	{ 
		alert ("<cf_get_lang dictionary_id='57771.Detay'> "+ ((-1) * x) +" <cf_get_lang dictionary_id='29538.Karakter Uzun'>");
		return false;
	}
	return true;
}
</script>
