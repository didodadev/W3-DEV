<cfquery name="GET_TRANSFER_DEFINITION" datasource="#DSN#">
	SELECT
		BTD.BRANCH_ID,
		BTD.DEFINITION_ID,
		BTD.TABLE_NAME,
		BTD.BRANCH_NAME BRANCH_NAME2,
		B.BRANCH_NAME
	FROM
		BRANCH_TRANSFER_DEFINITION BTD,
		BRANCH B
	WHERE
		BTD.BRANCH_ID = B.BRANCH_ID
	ORDER BY 
		BTD.DEFINITION_ID
</cfquery>
		<table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td height="35" class="headbold"><cf_get_lang no='794.Şube Aktarım Tanımları'></td>
			</tr>
		</table>
		<table cellspacing="1" cellpadding="2" border="0" width="98%" class="color-border" align="center">
			<cfform name="form_branch_transfer_definition" method="post" action="#request.self#?fuseaction=crm.emptypopup_branch_transfer_definition">
			<tr>
				<td valign="top" class="color-row">
				<table name="table1" id="table1">
					<tr height="30">
						<td width="170" class="txtbold"><cf_get_lang no='443.Workcube Şube *'></td>
						<td width="120" align="left" class="txtbold"><cf_get_lang_main no='1735.Şube Adı'> *</td>
						<td width="120" align="left" class="txtbold"><cf_get_lang no='444.Tablo Adı'> *</td>
						<td><input name="record_num" id="record_num" type="hidden" value="0"><a href="javascript://" onClick="add_row();"><img src="/images/plus_list.gif" alt="Ekle" border="0" title="Ekle"></a></td>
					</tr>
				<cfif get_transfer_definition.recordCount>
				<cfoutput query="get_transfer_definition">
				<tr id="frm_row#currentrow#">
				  <td nowrap>
				  	<input type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#">
					<input type="hidden" name="definition_id#currentrow#" id="definition_id#currentrow#" value="#definition_id#">
				  	<input type="hidden" name="branch_id#currentrow#" id="branch_id#currentrow#" value="#branch_id#" readonly style="width:150px;">
				  	<input type="text" name="branch#currentrow#" id="branch#currentrow#" value="#branch_name#" readonly style="width:150px;">
					<a href="javascript://" onClick="pencere_ac1('#currentrow#');" style="cursor:pointer;"><img src="/images/plus_thin.gif" alt="Şube Seç" align="absmiddle" border="0" title="Sube Seç"></a>
				  </td>
				  <td nowrap><input type="text" name="branch_name#currentrow#" id="branch_name#currentrow#" value="#branch_name2#" maxlength="50" style="width:120px;"></td><!--- value="#get_care_report_row.detail#" --->
				  <td nowrap><input type="text" name="table_name#currentrow#" id="table_name#currentrow#" value="#table_name#" maxlength="50" style="width:120px;"></td><!--- value="#tlformat(get_care_report_row.quantity)#" --->
				  <td nowrap><a style="cursor:pointer" onClick="sil(#currentrow#);"><img  src="images/delete_list.gif" alt="Sil" border="0" align="absmiddle"></a></td>
				</cfoutput>
				</cfif>
				</table>
				<table>
					<tr>						
						<td align="left"><cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'></td>
					</tr>
				</table>
				</td>
			</tr>
			</cfform>
		</table>
<script type="text/javascript">
row_count = <cfoutput>#get_transfer_definition.recordcount#</cfoutput>;
document.form_branch_transfer_definition.record_num.value=row_count;
function add_row()
{
	row_count++;
	var newRow;
	var newCell;

	newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);
				
	document.form_branch_transfer_definition.record_num.value=row_count;
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="hidden" name="definition_id' + row_count +'" value=""><input type="hidden" value="1" name="row_kontrol' + row_count +'"><input type="hidden" name="branch_id'+ row_count +'" value=""><input type="text" name="branch'+ row_count +'" value="" readonly style="width:150px;">&nbsp;<a href="javascript://" onClick="pencere_ac1('+ row_count +');" style="cursor:pointer;"><img src="/images/plus_thin.gif" align="absmiddle" border="0" alt="Sube Seç"></a>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="branch_name'+ row_count +'" maxlength="50" style="width:120px;">';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="table_name'+ row_count +'" maxlength="50" style="width:120px;">';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a style="cursor:pointer" onClick="sil(' + row_count + ');"><img src="/images/delete_list.gif" align="absmiddle" border="0" alt="<cf_get_lang_main no ='51.sil'>"></a>';							
}

function pencere_ac1(no)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_related_branches&branch_id=form_branch_transfer_definition.branch_id'+ no +'&branch_name=form_branch_transfer_definition.branch'+ no,'list');
}

function sil(sy)
{
	var my_element=eval("form_branch_transfer_definition.row_kontrol"+sy);
	my_element.value=0;
	var my_element=eval("frm_row"+sy);
	my_element.style.display="none";
}

function kontrol()
{
	if(document.form_branch_transfer_definition.record_num.value > 0)
	{
		for(r=1;r<=document.form_branch_transfer_definition.record_num.value;r++)
		{
			if(eval("document.form_branch_transfer_definition.branch_id"+r).value == "")
			{
				alert("<cf_get_lang dictionary_id='54871.Workcube Şube Seçmelisiniz'>!");
				return false;
			}
			
			if(eval("document.form_branch_transfer_definition.branch_name"+r).value == "")
			{
				alert("<cf_get_lang dictionary_id='48754.Şube Adı Girmelisiniz'>!");
				return false;
			}
			
			if(eval("document.form_branch_transfer_definition.table_name"+r).value == "")
			{
				alert("<cf_get_lang dictionary_id='54896.Tablo Adı Girmelisiniz'>!");
				return false;
			}
		}
	}
	return true;
}
</script>

