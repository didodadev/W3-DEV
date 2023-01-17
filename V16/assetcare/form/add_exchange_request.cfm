<cfinclude template="../query/get_brands.cfm">
<table width="98%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td valign="top">
      <table width="100%" cellpadding="0" cellspacing="0" border="0" align="center" height="100%">
        <tr>
          <td>
            <table width="100%" cellpadding="2" cellspacing="1" border="0" height="100%">
              <tr valign="middle">
                <td class="txtbold" colspan="5"><cf_get_lang no='161.Satış Talebi'></td>
              </tr>
              <tr id="list_correspondence1_menu2">
                <td class="color-row" valign="top">
                  <table name="table1" id="table1" width="100%">
                    <tr class="txtboldblue">
                      <td width="94px"><cf_get_lang_main no='1656.Plaka'></td>
                      <td width="120px"><cf_get_lang_main no='1435.Marka'></td>
                      <td width="130px"><cf_get_lang_main no='2244.Marka Tipi'></td>
                      <td width="50px"><cf_get_lang_main no='1043.Yıl'></td>
                      <td width="50px"><cf_get_lang_main no='670.Adet'></td>
                      <td><input name="record_num" id="record_num" type="hidden" value="0"><input type="button" class="eklebuton" title="" onClick="add_row();"></td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<script type="text/javascript">

	row_count=0;
	function sil(sy)
	{
		var my_element=eval("add_sales_request.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
	
	function kontrol_et()
	{
		if(row_count ==0)
			return false;
		else
			return true;
	}

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
						
			document.getElementById('record_num').value=row_count;

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="hidden" value="1"  name="row_kontrol' + row_count +'" ><input type="hidden" name="assetp_id'+ row_count +'"><input type="text" name="assetp_name' + row_count +'" style="width:75px;" value="" readonly=yes;"><a href="javascript://" onClick="get_vehicle(' + row_count + ');"> <img border="0" src="/images/plus_list.gif" alt="" align="absmiddle"></a>'

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="text" value=""  name="brand_name' + row_count +'" readonly style="width:120px">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="text" value=""  name="brand_type' + row_count +'" readonly style="width:130px">';
	
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="text" value=""  name="make_year' + row_count +'" readonly style="width:50px">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="text"  name="quantity' + row_count +'" value="1" readonly style="width:50px">';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"><img src="images/delete_list.gif" border="0" alt="Sil" align="absmiddle"></a>';							
	}		

	function get_vehicle(no)
	{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=add_sales_request.assetp_id' + no + '&field_name=add_sales_request.assetp_name' + no + '&brand_name=add_sales_request.brand_name' + no + '&model=add_sales_request.brand_type' + no + '&make_year=add_sales_request.make_year' + no ,'list');
	}
</script>

