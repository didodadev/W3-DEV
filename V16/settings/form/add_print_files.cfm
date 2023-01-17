<cfset cfc= createObject("component","workdata.get_print_files_cats")>
<cfset get_print_cats=cfc.GetPrintCats()> 
<cfparam name="process_type" default="">
<!--- <cffile action="read" variable="xmldosyam" file="#Replace(index_folder,'\v16','')#design#dir_seperator#template#dir_seperator#standart_print_files.xml" charset = "UTF-8">
<cfscript>
	dosyam = XmlParse(xmldosyam);
	xml_dizi = dosyam.STANDART_PRINT_FILE.XmlChildren;
	d_boyut = ArrayLen(xml_dizi);
</cfscript> --->
<cfform name="add_invoice_template" action="#request.self#?fuseaction=settings.emptypopup_add_print_files"  method="post" enctype="multipart/form-data">
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('settings',854,'Sistem İçi Yazıcı Dosyası')#" closable="0" collapsed="0">
		<cf_box_elements>
			<input type="hidden" name="positions" id="positions" value="">
			<input type="hidden" name="position_cats" id="position_cats" value="">
			<input type="hidden" name="positions2" id="positions2" value="">
			<div class="col col-4 col-xs-12">
				<div class="scrollbar" style="max-height:357px;overflow:auto;">
					<div id="cc">
						<cfinclude template="../display/list_print_files.cfm">
					</div>
				</div>
			</div>
			<div class="col col-4 col-xs-12">
				<input name="is_standart" id="is_standart" type="hidden" value="0">
				<div class="form-group">
						<label class="col col-2 col-xs-2"><cf_get_lang dictionary_id='57756.Durum'></label>
						<label class="col col-3 col-xs-3"><input name="active" id="active" type="checkbox" value="1"><cf_get_lang dictionary_id='57493.Aktif'></label>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58820.Başlık'>*</label>
					<div class="col col-8 col-xs-12">
						<cfinput type="text" name="template_head" value="" maxlength="100" required="yes" message="#getLang('','Başlık Girmelisiniz',58059)#">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'>*</label>
					<div class="col col-8 col-xs-12">
						<select name="process_type" id="process_type">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_print_cats">
								<option value="#print_type#-#print_module_id#" <cfif print_type eq process_type>selected</cfif>>#print_namenew#&nbsp;(#print_type#)</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-2"><cf_get_lang dictionary_id='57691.Dosya'></label>
					<div class="col col-8 col-xs-8">
						<div class="input-group">
						<input type="file" name="template_file" id="template_file">
						<input type="text" name="file_name" id="file_name" style="display:none;">
						<span class="input-group-addon btnPointer icon-add" id="value1" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_standart_print_files&field_name=add_invoice_template.file_name&field_id=add_invoice_template.template_file&standart=add_invoice_template.is_standart&field_detail=add_invoice_template.detail&field_process_type=add_invoice_template.process_type');"></span>	
						<span class="input-group-addon btnPointer icon-minus" href="javascript://" id="value2" onclick="temizle();" style="display:none;"></span>
					</div>
				</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
					<div class="col col-8 col-xs-12">
						<textarea name="detail" id="detail" value=""></textarea>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-12 col-xs-12"><input type="checkbox" name="is_default" id="is_default" value="1"><cf_get_lang dictionary_id='43115.Standart Seçenek Olarak Gelsin'>(<cf_get_lang dictionary_id='43116.Default'>)</label>
				</div>
				<div class="form-group">
					<label class="col col-12 col-xs-12"><input type="checkbox" name="is_partner" id="is_partner" value="1"><cf_get_lang dictionary_id ='43008.İnternette Gürünsün'></label>
				</div>
			</div>
			<div class="col col-4 col-xs-12">
				<cfsavecontent variable="txt1"><cf_get_lang dictionary_id='42683.Yetkili Pozisyonlar'></cfsavecontent>
				<cf_workcube_to_cc 
					is_update="0" 
					to_dsp_name="#txt1#" 
					form_name="add_invoice_template" 
					str_list_param="1" 
					data_type="2"> 
				<cf_ajax_list class="workDevList"  id="td_yetkili2">
					<thead>
						<tr>
						<th width="20">
						<a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_position_cats&field_id=add_invoice_template.position_cats&field_td=td_yetkili2&is_noclose=1</cfoutput>');"><i class="icon-pluss" align="absmiddle" border="0"></i></a>
						</th><th>
						<cf_get_lang dictionary_id='42736.Yetkili Pozisyon Tipleri'>
						</th>
						</tr>
						</thead>
				</cf_ajax_list>
				<!---<tr>
					<td id="td_yetkili1" colspan="2" valign="top"></td>
					<td id="td_yetkili2"  colspan="2" valign="top"></td>
				</tr>--->
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
		</cf_box_footer>
	</cf_box>
	</div>
</cfform>
<script type="text/javascript">
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
	x = (200 - add_invoice_template.detail.value.length);
	if ( x < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id='57771.Detay'> "+ ((-1) * x) +"<cf_get_lang dictionary_id='29538.Karakter Uzun'>");
		return false;
	}
	return true;
}
	function open_list_templates(url,id) {
		document.getElementById(id).style.display ='';	
		document.getElementById(id).style.width ='600px';	
		$("#"+id).css('right',"40%");
		$("#"+id).css('top',"10%");
		$("#"+id).css('position','absolute');	
		AjaxPageLoad(url,id,1);
		return false;
	}
</script>
