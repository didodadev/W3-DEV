<cfquery name="GET_RIVAL" datasource="#DSN#">
	SELECT R_ID,RIVAL_NAME,STATUS,RIVAL_DETAIL,IS_GROUP FROM SETUP_RIVALS WHERE R_ID = #attributes.r_id#
</cfquery>
<cfquery name="GET_BRANCH_ZONE" datasource="#DSN#">
	SELECT 
		SRB.R_ID, 
		SRB.BRANCH_ID,
		B.BRANCH_NAME
	FROM 
		SETUP_RIVALS_BRANCH SRB,
		BRANCH B
	WHERE 
		SRB.BRANCH_ID = B.BRANCH_ID AND
		SRB.R_ID = #attributes.r_id#  
</cfquery>
<cfset row = get_branch_zone.recordCount>
<cfsavecontent variable="txt">
    <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=store.popup_form_add_rival"><img src="/images/plus1.gif" title="<cf_get_lang_main no ='170.Ekle'>"></a>
</cfsavecontent>
<cf_popup_box title="#getLang('store',1367)#" right_images="#txt#">
    <cfform name="upd_rival" action="#request.self#?fuseaction=store.emptypopup_upd_rival" method="post">
    <input type="hidden" name="counter" id="counter" value="">
    <input type="hidden" name="rival_id" id="rival_id" value="<cfoutput>#attributes.r_id#</cfoutput>">
    <table>
        <tr>
            <td width="80"><cf_get_lang_main no='70.Aşama'></td>
            <td><input type="Checkbox" name="status" id="status" value="1" <cfif get_rival.status eq 1>checked</cfif>>
                <cf_get_lang_main no='81.Aktif'> 
            </td>
        </tr>
        <tr>
            <td><cf_get_lang no='182.Rakip Adı'>* </td>
            <td>
            <cfsavecontent variable="message"><cf_get_lang no='160.Rakip Adı girmelisiniz'></cfsavecontent>
            <cfinput type="Text" name="rival_name" style="width:225px;" value="#get_rival.rival_name#" maxlength="100" required="Yes" message="#message#">
            </td>
        </tr>
        <tr>
            <td valign="top"><cf_get_lang_main no='217.Ayrıntı'></td>
            <td>
            <cfsavecontent variable="message"><cf_get_lang_main no='1687.Fazla karakter sayısı'></cfsavecontent>
            <textarea name="rival_detail" id="rival_detail" cols="60" rows="2" style="width:225px;height:100px;" maxlength="300" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#get_rival.rival_detail#</cfoutput></TEXTAREA>
            </td>
        </tr>
    </table>
    <cf_form_list>
        <thead>
          <tr>
            <th width="15"><input type="button" class="eklebuton" title="Ekle" onClick="add_row();"></th>
            <th><cf_get_lang no='108.Rekabet İçerisinde Olduğu Şubeler'><input name="record_num" id="record_num" type="hidden" value="<cfoutput>#row#</cfoutput>"> </th>
          </tr>
        </thead>
        <tbody name="table1" id="table1">
          <cfoutput query="get_branch_zone">
            <tr id="frm_row#currentrow#">
              <td width="15"><input  type="hidden"  value="1"  name="row_kontrol#currentrow#" id="row_kontrol#currentrow#"><a style="cursor:pointer" onclick="sil(#currentrow#);"><img  src="images/delete_list.gif" border="0" align="absmiddle" title="Sil"></a></td>
              <td nowrap><input type="text" name="branch_name#currentrow#" id="branch_name#currentrow#" value="#branch_name#" style="width=250px;" readonly="yes">
                <input type="hidden" name="branch_id#currentrow#" id="branch_id#currentrow#" value="#branch_id#"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_branches&field_branch_name=upd_rival.branch_name#currentrow#&field_branch_id=upd_rival.branch_id#currentrow#','medium');"><img src="/images/plus_list.gif" align="absmiddle" title="<cf_get_lang_main no='170.Ekle'>" border="0"></a></td>
            </tr>
          </cfoutput>
       </tbody>
    </cf_form_list>
    <cf_popup_box_footer><cf_workcube_buttons is_upd='1' is_delete='0'> </cf_popup_box_footer>
    </cfform>
</cf_popup_box>
<script type="text/javascript">
	
	row_count=<cfoutput>#row#</cfoutput>;
	function sil(sy)
	{
		var my_element=eval("upd_rival.row_kontrol"+sy);
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
		document.upd_rival.record_num.value = row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0" align="absmiddle" alt="Sil"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden"  value="1"  name="row_kontrol' +row_count+'"><input name="branch_name' + row_count +'" style="width:250" readonly="yes"><input type="hidden" name="branch_id' +row_count+'">&nbsp;<a href="javascript://" <a href="javascript://" onClick="pencere_ac(' + row_count + ');"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='170.Ekle'>" border="0"></a> ';
	}
	
	function pencere_ac2(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_sales_zone&field_name=upd_rival.sales_zone'+no+'&field_id=upd_rival.sales_zone_id'+no,'medium');
	}
	
	function pencere_ac(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_name=upd_rival.branch_name'+no+'&field_branch_id=upd_rival.branch_id'+no,'medium');
	}

</script>
