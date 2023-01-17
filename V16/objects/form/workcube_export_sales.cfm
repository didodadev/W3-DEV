<cfsavecontent variable="message"><cf_get_lang dictionary_id='34315.Workcube Satış Export Belgesi Oluştur'></cfsavecontent>
<cf_popup_box title="#message#">
    <cfform name="workcube_export_sales" method="post" action="#request.self#?fuseaction=objects.emptypopup_workcube_export_sales">
    <input type="hidden" name="main_table" id="main_table" value="INVOICE">
    <input type="hidden" name="main_table_related_columns" id="main_table_related_columns" value="INVOICE_ID">
    <input type="hidden" name="sub_table_list" id="sub_table_list" value="INVOICE_ROW,INVOICE_MONEY">
    <input type="hidden" name="sub_table_related_columns_list" id="sub_table_related_columns_list" value="INVOICE_ID,ACTION_ID">
    <input type="hidden" name="query_order" id="query_order" value="INVOICE_ID">
    <div class="row">
        <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
		<div class="form-group" id="item-target_pos">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58594.Format'></label>
            <div class="col col-8 col-xs-12">
                <select name="target_pos" id="target_pos" style="width:200px;">
                    <option value="-4"><cf_get_lang dictionary_id='58783.Workcube'></option>
                </select>
            </div>
        </div>
        <div class="form-group" id="item-file_format">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
            <div class="col col-8 col-xs-12">
                <select name="file_format" id="file_format" style="width:200px;">
                    <option value="ISO-8859-9"><cf_get_lang dictionary_id='32979.ISO-8859-9 (Türkçe)'></option>
                    <option value="UTF-8">UTF-8</option>
                </select>
            </div>
        </div>
        <div class="form-group" id="item-department_id">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'>*</label>
            <div class="col col-8 col-xs-12">
            <div class="input-group">
                <input type="hidden" name="department_id" id="department_id" value="">
                <input type="text" name="department" id="department" value="" readonly style="width:200px;">
                <span class="input-group-addon btnPointer icon-ellipsis"  href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=workcube_export_sales&field_name=department&field_id=department_id</cfoutput>','list');"></span>
            </div>
        </div>
    </div>    
        <div class="form-group" id="item-processdate">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
                <div class="col col-8 col-xs-12">
                <div class="input-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
                    <cfinput type="text" name="processdate" value="" required="Yes" message="#message#" validate="#validate_style#" maxlength="10" style="width:65px;">
                    <span class="input-group-addon"><cf_wrk_date_image date_field="processdate"></span>
                </div>
            </div>
        </div>
    </div>
</div>        
     <cf_popup_box_footer><cf_workcube_buttons is_upd='0' add_function='form_chk()'></cf_popup_box_footer>
    </cfform>
</cf_popup_box>
<script type="text/javascript">
function type_change()
{
	if(document.formexport.target_pos.value=='-4')

	{
		type_workcube.style.display='';
	}
	else
	{
		type_workcube.style.display='none';
		document.formexport.is_insert.checked=false;
		document.formexport.is_update.checked=false;
		document.formexport.is_update.checked=false;
		document.formexport.destination_company_id.value='';
		document.formexport.destination_company_name.value='';
	}
}
function form_chk()
{
	/*if(document.formexport.target_pos.value!='-4')
	{
		if(document.formexport.department_id.value =="") 
		{
			alert("<cf_get_lang no='480.Stokları Hangi Şube İçin Alacağınızı Seçmediniz'> !");
			return false;
		}
	}*/
	/*else{
		if (formexport.destination_company_name.value =="" || formexport.destination_company_id.value =="") 
			{alert("Stokları Hangi Üye İçin Alacağınızı Seçmediniz!");return false;}
	}*/
	if(document.getElementById('department').value=='')
	{
			alert("<cf_get_lang dictionary_id='32870.Stokları Hangi Şube İçin Alacağınızı Seçmediniz'> !");
			return false;
	}
	return true;
}
</script>
