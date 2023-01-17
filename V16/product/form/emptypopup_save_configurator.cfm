<cfsetting showdebugoutput="no">
<!--- imaj eklemeyi unutmayalım --->		
<!--- <cfquery name="ADD_SETUP_PRODUCT_CONFIGURATOR" datasource="#DSN3#">
	INSERT INTO 
		SETUP_PRODUCT_CONFIGURATOR
		(
			IS_ACTIVE,
			PRODUCT_CAT_ID,
			CONFIGURATOR_NAME,
			CONFIGURATOR_DETAIL,
			RECORD_EMP, 
			RECORD_IP, 
			RECORD_DATE
		)
	VALUES
		(
			<cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
			#attributes.product_catid#,
			'#attributes.configuration_name#',
			'#attributes.configuration_detail#',
			 #session.ep.userid#,
			'#REMOTE_ADDR#',
			#now()#
		)
</cfquery> --->
<input type="hidden" name="PRODUCT_CONFIGURATOR_ID" id="PRODUCT_CONFIGURATOR_ID" value="<cfoutput>#attributes.PRODUCT_CONFIGURATOR_ID#</cfoutput>">
<input name="record_num" id="record_num" type="hidden">
<table id="table2" width="98%" cellpadding="2" cellspacing="1" class="color-border" align="center">
	<tr class="color-header">
    	<td width="1%"><a onClick="add_row();"><img src="/images/plus_list.gif"  style="cursor:pointer;" border="0"></a></td>
        <td class="form-title" width="10"><cf_get_lang dictionary_id='58577.Sıra'></td>
        <td class="form-title"><cf_get_lang dictionary_id='40788.Bölüm Adı'></td>
        <td class="form-title"><cf_get_lang dictionary_id='52750.Detail'></td>
        <td width="80%"></td>
    </tr>
</table>
<script type="text/javascript">
row_count=0;
row_count2=0;
function add_row()
{
	row_count++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);	
	newRow.setAttribute("ID","frm_row" + row_count);		
	newRow.setAttribute("ID","frm_row" + row_count);
	newRow.className = 'color-row';
	document.getElementById('record_num').value=row_count;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="chapter_line" value="' + row_count + '" style="width:30px;">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.Width = "120";
	newCell.innerHTML = '<input type="text" name="chapter_name' + row_count +'" style="width:120px;" maxlength="7">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.Width = "120";
	newCell.innerHTML = '<input type="text" name="detail'+ row_count +'" style="width:120px;">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.Width = "150";
	newCell.innerHTML = '<input type="button" name="SaveChapter' + row_count +'" onClick="SaveChapter('+row_count+');" value="Kaydet">';
	//newCell.innerHTML = '<input type="button" name="eklebuton' + row_count +'" onClick="add_row_('+row_count+');" value="Component">';
	var newRow;
	var newCell;
	newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);
	newRow.setAttribute("name","second_frm_row" + row_count);
	newRow.setAttribute("id","second_frm_row" + row_count);		
	newRow.setAttribute("NAME","second_frm_row" + row_count);
	newRow.setAttribute("ID","second_frm_row" + row_count);
	newRow.className = 'color-list';
	newRow.style.display='none';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.colSpan = 5;
	newCell.innerHTML = '<table id="table2_' + row_count + '"><tr class="txtboldblue"><td>Anahtar</td><td width="30"><cf_get_lang dictionary_id='58577.Sıra'></td><td width="100"><cf_get_lang dictionary_id='57632.Özellik'></td><td width="90"><cf_get_lang dictionary_id='59088.Tip'></td><td width="45"><cf_get_lang dictionary_id='36493.Değer'> 1</td><td width="45"><cf_get_lang dictionary_id='36493.Değer'> 2</td><td width="50"><cf_get_lang dictionary_id='29443.Tolerans'></td><td width="100"><cf_get_lang dictionary_id='57629.Açıklama'></td><td width="70"><cf_get_lang dictionary_id='57810.Ek Bilgi'></td><td width="95"><cf_get_lang dictionary_id='57486.Kategori'></td><td width="100"><cf_get_lang dictionary_id='57657.Ürün'></td><td><cf_get_lang dictionary_id='57635.Miktar'></td><td align="center"></td><td align="center"></td></tr><tr id="frm_row"></tr></table>';
}
//Bölümleri Kaydeder ve form kontrollerini yapar!
function SaveChapter(chapter_row_id){
	if(!form_warning('chapter_name'+chapter_row_id+'','Bölüm Adı Giriniz!'))return false;
	if(!form_warning('detail'+chapter_row_id+'','Bölüm Detayı Giriniz!'))return false;
	
}
function add_row_(row_)
{
	row_count2++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table2_"+row_).insertRow(document.getElementById("table2_"+row_).rows.length);
	newRow.setAttribute("name","frm_row" + row_count2);
	newRow.setAttribute("id","frm_row" + row_count2);		
	newRow.setAttribute("NAME","frm_row" + row_count2);
	newRow.setAttribute("ID","frm_row" + row_count2);		
	document.getElementById('record_num').value=row_count2;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="radio" name="is_key_component" value="' + row_count2 + '">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="order_no' + row_count2 +'" style="width:30px;" maxlength="7" class="moneybox">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="hidden" name="property_id' + row_count2 +'"><input type="text" readonly="yes" name="property' + row_count2 +'" style="width:85px;"> <a href="javascript://" onClick="pencere_pos(' + row_count2 + ');"><img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="Özellik Seç"></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<select name="comp_type' + row_count2 + '" style="width:90px;"><option value="1">Radio Button</option><option value="2">CheckBox</option><option value="3">SelectBox</option><option value="4">Boş</option></select>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<select name="is_value_1' + row_count2 + '" style="width:40px;"><option value="1"><cf_get_lang dictionary_id='58564.Var'></option><option value="2">Yok</option></select>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<select name="is_value_2' + row_count2 + '" style="width:40px;"><option value="1"><cf_get_lang dictionary_id='58564.Var'></option><option value="2">Yok</option></select>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<select name="is_tolerance' + row_count2 + '" style="width:50px;"><option value="1"><cf_get_lang dictionary_id='58564.Var'></option><option value="2">Yok</option></select>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="property_detail' + row_count2 + '" style="width:100px;" maxlength="200">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<select name="comp_information' + row_count2 + '" style="width:70px;"><option value="1"><cf_get_lang dictionary_id='58564.Var'>-Input</option><option value="2"><cf_get_lang dictionary_id='58564.Var'>-TextArea</option></select>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol' + row_count2 +'"><input type="hidden" name="product_cat_id' + row_count2 +'"><input type="text" readonly="yes" name="product_cat' + row_count2 +'" style="width:80px;"> <a href="javascript://" onClick="pencere_kategori(' + row_count2 + ');"><img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="<cf_get_lang dictionary_id='58947.Kategori Seç'>"></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="hidden" name="product_id' + row_count2 +'"><input type="text" readonly="yes" name="product_name' + row_count2 +'" style="width:85px;"> <a href="javascript://" onClick="popup_products(' + row_count2 + ',1);"><img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="Ürün Seç"></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<select name="max_amount' + row_count2 + '"><option value="1">1</option><option value="2">2</option><option value="3">3</option><option value="4">4</option><option value="5">5</option></select>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="button" name="variant_button' + row_count2 + '" style="width:30px;" value="V'+row_count2+'" onclick="variant_production_plan(' + row_count2 + ')">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count2 + ');"><img  src="images/delete_list.gif" border="0"></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.colSpan = 5;
	newCell.innerHTML = '<div id="div_variant' + row_count2 + '" style="position:absolute;border:1;z-index:auto;background-color:DAEAF8;width:270px;height:80px;display:none"><br/>&nbsp;&nbsp;Varyasyon 1 <input type="hidden" name="sub_product_id' + row_count2 +'"><input type="text" readonly="yes" name="sub_product_name' + row_count2 +'" style="width:120px;"> <a href="javascript://" onClick="popup_products(' + row_count2 + ',2);"><img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="Ürün Seç"></a>&nbsp;Miktar&nbsp;<input type="text" name="variant_amount' + row_count2 +'" style="width:30px;" maxlength="7"><br/>&nbsp;&nbsp;Varyasyon 2 <input type="hidden" name="sub_2_product_id' + row_count2 +'"><input type="text" readonly="yes" name="sub_2_product_name' + row_count2 +'" style="width:120px;"> <a href="javascript://" onClick="popup_products(' + row_count2 + ');"><img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="<cf_get_lang dictionary_id='50885.Ürün Seç'>"></a>&nbsp;Miktar&nbsp;<input type="text" name="_variant_amount' + row_count2 +'" style="width:30px;" maxlength="7"><input type="button" name="variant_close'+row_count2+'" value="'+row_count2+'.Varyasyonu Kapat" onClick="variant_production('+row_count2+');"></div>';
}
</script>
