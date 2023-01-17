<cfsavecontent variable="message"><cf_get_lang dictionary_id='34039.Stok Dosyası Al'></cfsavecontent>
<cf_popup_box title="#message#">
    <cfform name="formexport" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=objects.emptypopup_upload_stock_import">
     <table>
        <tr>
            <td><cf_get_lang dictionary_id='58594.Format'></td>
            <td><select name="target_pos" id="target_pos" style="width:200px;">
                	<option value="-4"><cf_get_lang dictionary_id='58783.Workcube'></option>
                </select>
            </td>
        </tr>
        <tr>
            <td width="100"><cf_get_lang dictionary_id='32901.Belge Formatı'></td>
            <td><select name="file_format" id="file_format" style="width:200px;">
					<!--- <option value="ISO-8859-9"><cf_get_lang no='589.ISO-8859-9 (Türkçe)'></option> --->
                    <option value="UTF-8">UTF-8</option>
                </select>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='57468.Belge'></td>
            <td><input type="file" name="uploaded_file" style="width:200px;"></td>
        </tr>
        <cfquery name="PRICE_CATS" datasource="#DSN3#">
            SELECT
                PRICE_CATID,
                PRICE_CAT
            FROM
                PRICE_CAT
            WHERE
                PRICE_CAT_STATUS = 1
            ORDER BY
                PRICE_CAT
        </cfquery>
        <tr>
            <td><cf_get_lang dictionary_id='58964.Fiyat Listesi'></td>
            <td>
              <select name="price_catid" id="price_catid" style="width:200px;">
                  <option value="-2"><cf_get_lang dictionary_id='58721.Standart Satış'></option>
                  <cfoutput query="price_cats">
                    <option value="#price_catid#">#price_cat#</option>
                  </cfoutput>
              </select>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='57453.Şube'> *</td>
            <td><input type="hidden" name="department_id" id="department_id" value="">
                <input type="text" name="department" id="department" value="" readonly style="width:200px;">
                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=formexport&field_name=department&field_id=department_id</cfoutput>','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
            </td>
        </tr>
        <tr>
            <td id="aa"><cf_get_lang dictionary_id='57742.Tarih'> *</td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
                <cfinput type="text" name="processdate" value="" required="Yes" message="#message#" validate="#validate_style#" maxlength="10" style="width:65px;">
                <cf_wrk_date_image date_field="processdate">
            </td>
        </tr>
    </table>
  	<cf_popup_box_footer><cf_workcube_buttons is_upd='0' add_function='form_chk()'></cf_popup_box_footer>
    </cfform>
</cf_popup_box>
<script type="text/javascript">

function form_chk()
{	
	if (formexport.department_id.value.length == 0)
	{
		alert("<cf_get_lang dictionary_id ='30126.Şube Seçiniz'> !");
		return false;
	}
	return true;		
}
</script>
