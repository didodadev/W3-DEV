<cfquery name="BRANCHES" datasource="#DSN#">
	SELECT 
		BRANCH_ID, 
		BRANCH_NAME 
	FROM 
		BRANCH 
	ORDER BY
		BRANCH_NAME 	
</cfquery>
<cf_popup_box title="#getLang('store',111)#">
	<cfform name="add_rival" action="#request.self#?fuseaction=store.emptypopup_add_rival" method="post">
     <input type="hidden" name="counter" id="counter" value="">
     <table>          
        <tr>
            <td><cf_get_lang_main no='70.Aşama'></td>
            <td><input type="Checkbox" name="status" id="status" value="1">
            <cf_get_lang_main no='81.Aktif'> </td>
        </tr>
        <tr>
            <td width="90"><cf_get_lang no='182.Rakip Adı'>* </td>
            <td> 
            <cfsavecontent variable="message"><cf_get_lang no='160.Rakip Adı girmelisiniz'> !</cfsavecontent>
            <cfinput type="Text" name="rival_name" style="width:225px;" value="" maxlength="100" required="Yes" message="#message#"> 
            </td>
        </tr>
        <tr>
            <td valign="top"><cf_get_lang_main no='217.açıklama'></td>
            <td>
            <cfsavecontent variable="message"><cf_get_lang_main no='1687.Fazla karakter sayısı'></cfsavecontent>				
             <TEXTAREA name="rival_detail" cols="60" rows="2" style="width:225px;height:100px;" maxlength="300" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></TEXTAREA> 
            </td>
        </tr>
     </table>
     <cf_form_list>
     	<thead>
          <tr>
            <th width="15"><input type="button" class="eklebuton" title="Ekle" onClick="add_row();"></a></th>
            <th>Rekabet İçerisinde Olduğu Şubeler<input name="record_num"  id="record_num" type="hidden" value="0"></th>
          </tr>
        </thead>
        <tbody name="table1" id="table1"></tbody>
    </cf_form_list>
    <cf_popup_box_footer>
         <cf_workcube_buttons is_upd='0'>
    </cf_popup_box_footer>
  </cfform>
</cf_popup_box>
<script type="text/javascript">
	row_count=0;
	function sil(sy)
	{
		var my_element=eval("add_rival.row_kontrol"+sy);
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
			document.add_rival.record_num.value = row_count;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0" align="absmiddle" alt="Sil"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden"  value="1"  name="row_kontrol' + row_count +'"><input type="hidden" name="branch_id' +row_count+'"><input name="branch_name' + row_count +'" style="width:250" readonly="yes"><a href="javascript://" <a href="javascript://" onClick="pencere_ac(' + row_count + ');">&nbsp;<img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='170.Ekle'>" border="0"></a>';
	}
	
	function pencere_ac2(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_sales_zone&field_name=add_rival.sales_zone'+no+'&field_id=add_rival.sales_zone_id'+no,'medium');
		}
		
	function pencere_ac(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_name=add_rival.branch_name'+no+'&field_branch_id=add_rival.branch_id'+no,'medium');
		}
</script>

