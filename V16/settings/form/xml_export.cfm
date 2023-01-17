<!---TolgaS 20071205 XML export belirtilen alanlara göre xml oluşturur--->
<cf_box title="#getLang('settings',1422)#">
    <cfform name="export_form"  action="#request.self#?fuseaction=settings.emptypopup_xml_export">
    <input type="hidden" value="0" name="record_num" id="record_num">
        <cf_grid_list>
            <thead>
                <tr>                   
                   <th width="20"><a href="javascrript://" onclick="add_Row();"  title="<cf_get_lang_main no ='170.Ekle'>"><i class="fa fa-plus"></i></a></th>
                    <th></th>
                    <th><cf_get_lang_main no ='1060.Dönem'></th>
                    <th><cf_get_lang no ='1587.Tablo'></th>
                    <th><cf_get_lang no ='1766.İlişkili Kolon'></th>
                    <th><cf_get_lang no ='1767.Koşul'></th>
                    <th><cf_get_lang_main no='1512.Sıralama'></th>
                </tr>
            </thead>
            <tbody id="tables">
                <tr>
                    <input type="hidden" value="1" name="row_kontrol1" id="row_kontrol1">
                    <td><a style="cursor:pointer" onclick="sil('1');" ><i class="fa fa-minus"></i></a></td>
                    <td><cf_get_lang no ='1769.Ana Tablo'></td>
                    <td>
                        <select name="table_dsn" id="table_dsn" onchange="get_table(this.value,'main_table');">
                            <option value=""><cf_get_lang no ='1936.Dönem Seçiniz'></option>
                            <option value="dsn"><cf_get_lang no='1423.Ana Veritabanı'></option>
                            <option value="dsn3"><cf_get_lang no='1424.Firma Veritabanı'> </option>
                            <option value="dsn2"><cf_get_lang no='1425.Muhasebe Veritabanı'></option>
                            <option value="dsn1"><cf_get_lang no='1579.Ürün Veritabanı'></option>
                        </select>
                    </td>
                    <td>
                        <select name="main_table" id="main_table"  onchange="get_columns(document.export_form.table_dsn.value,this.value,'main_table_related_columns');">
                            <option value=""><cf_get_lang no ='1935.Tablo Seçiniz '></option>
                        </select>
                    </td>
                    <td><select name="main_table_related_columns" id="main_table_related_columns" ><option value=""><cf_get_lang no ='1934.Sutun Seçiniz'></option></select></td>
                    <td><input type="text" name="where_text" id="where_text"></td>
                    <td><input type="text" name="order_text" id="order_text"></td>
                    
                </tr>
            </tbody>
        </cf_grid_list>
        <cf_box_footer><cf_workcube_buttons is_upd='0' add_function='control()'></cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
function control()
        {
            if($('#where_text').val() == '' || $('#order_text').val() == '') 
                {
                    alert("<cf_get_lang dictionary_id ='64846.Koşul ve Sıralamayı giriniz'>");
                    return false;
                }
        }
function get_table(dsn_text,obj_name)
{	
	if(dsn_text != "")
	{
		nesne=eval('document.export_form.'+obj_name);
		table_query = wrk_safe_query("set_tbl_q_2",dsn_text);
        //console.log(table_query);
        let unique = table_query.NAME.filter((item, i, ar) => ar.indexOf(item) === i);
		nesne.options.length=0;
		nesne.options[0] = new Option("<cf_get_lang no ='1935.Tablo Seçiniz '> !",'');
		for(var jj=0;jj<unique.length;jj++)
			nesne.options[jj+1]=new Option(unique[jj],unique[jj]);
	}
}
function get_columns(dsn_text,table_name,obj_name)
{
	nesne=eval('document.export_form.'+obj_name);
	table_query = wrk_safe_query("set_tbl_q",dsn_text,0,table_name);
    let unique_ = table_query.NAME.filter((item, i, ar) => ar.indexOf(item) === i);
	nesne.options.length=0;
	nesne.options[0] = new Option("<cf_get_lang no ='1934.Sutun Seçiniz'>",'');
	for(var jj=0;jj<unique_.length;jj++)
		nesne.options[jj+1]=new Option(unique_[jj],unique_[jj]);
}

var row_count=0;
function sil(sy)
	{  
		/*var my_element=eval("user_group.row_kontrol"+sy); */
		var my_element=document.getElementById('row_kontrol'+sy);
		my_element.value=0;

		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
function add_Row()
{
	row_count++;
	var newRow;
	var newCell;
	
	newRow = document.getElementById("tables").insertRow(document.getElementById("tables").rows.length);
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);		
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);		
	document.export_form.record_num.value=row_count;
    newCell = newRow.insertCell();
	newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><i class="fa fa-minus"></i></a>';
	newCell = newRow.insertCell();
	newCell.innerHTML = '<cf_get_lang no ="1937.Alt Tablo">&nbsp;';
	newCell = newRow.insertCell(newRow.cells.length);
	hdf_nesne="main_table_"&row_count;
	newCell.innerHTML = '<input  type="hidden"  value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><select name="sub_table_dsn_'+row_count+'" onChange="get_sub_table(this.value,'+row_count+');"><option value=""><cf_get_lang no ="1936.Dönem Seçiniz"></option><option value="dsn"><cf_get_lang no="1423.Ana Veritabanı"></option><option value="dsn3"><cf_get_lang no="1424.Firma Veritabanı"></option><option value="dsn2"><cf_get_lang no="1425.Muhasebe Veritabanı"></option><option value="dsn1"><cf_get_lang no="1579.Ürün Veritabanı"></option></select>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<select name="sub_table_'+row_count+'" onChange="get_sub_table_columns(this.value,'+row_count+');" ><option value=""><cf_get_lang no ="1935.Tablo Seçiniz"></option></select>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<select name="sub_table_related_columns_'+row_count+'" ><option value=""><cf_get_lang no ="1934.Sutun Seçiniz"></option></select>';
}
function get_sub_table(dsn_txt,cnt,col_name)
{
	get_table(dsn_txt,'sub_table_'+cnt);
}
function get_sub_table_columns(table_name,cnt,col_name)
{
	dsn_txt = eval('document.all.sub_table_dsn_'+cnt).value;
	get_columns(dsn_txt,table_name,'sub_table_related_columns_'+cnt);
}

</script>
