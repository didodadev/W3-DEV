<cf_get_lang_set module_name="account">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfinclude template="../account/query/account_closed_definition_end.cfm">
<script type="text/javascript">
	$(document).ready(function(){
		row_count_debt_exit = <cfoutput>#GET_ACCOUNT_CLOSED_DEBT.recordcount#</cfoutput>;
		row_count_claim_exit = <cfoutput>#GET_ACCOUNT_CLOSED_CLAIM.recordcount#</cfoutput>;	
		document.getElementById("row_count_debt_exit").value = row_count_debt_exit;
		document.getElementById("row_count_claim_exit").value = row_count_claim_exit;	
	});
	function add_row_debt()
	{
		row_count_debt_exit++;
		var newRow;
		var newCell;
		var temp_account_id ="DEBT_ACCOUNT_ID"+row_count_debt_exit;
		var to_account_id ="DEBT_CLOSED_ACCOUNT_ID"+row_count_debt_exit;
		var type_row="type_debt"+row_count_debt_exit;
		newRow = document.getElementById("Table_Debt").insertRow(document.getElementById("Table_Debt").rows.length);
		newRow.setAttribute("name","frm_row_exit" + row_count_debt_exit);
		newRow.setAttribute("id","frm_row_exit" + row_count_debt_exit);
		newRow.className = 'color-row';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML += '<input type="hidden" name="row_kontrol_exit' + row_count_debt_exit +'" id="row_kontrol_exit' + row_count_debt_exit +'" value="1"><a style="cursor:pointer"><img src="images/delete_list.gif" border="0" align="absmiddle" alt="Sil" onclick="sil_exit('+ row_count_debt_exit + ');"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML +='<input type="hidden" name="'+type_row+'" id="'+type_row+'" value="0"><input type="text" name="'+temp_account_id+'" id="'+temp_account_id+'" style="width:96%;" autocomplete="on" onFocus="AutoComplete_Create(\''+temp_account_id+'\',\'ACCOUNT_CODE,ACCOUNT_NAME\',\'ACCOUNT_CODE,ACCOUNT_NAME\',\'get_account_code\',\'1\',\'\',\'\',\'\',\',\',\'3\',\'225\');"><a href="javascript://" onclick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=account_closed_table_def.'+temp_account_id+'\',\'list\');"><img src="/images/plus_thin.gif" align="top" border="0" style="margin-left:3px;"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML +='<input type="text" name="'+to_account_id+'" id="'+to_account_id+'" style="width:96%;" autocomplete="on" onFocus="AutoComplete_Create(\''+to_account_id+'\',\'ACCOUNT_CODE,ACCOUNT_NAME\',\'ACCOUNT_CODE,ACCOUNT_NAME\',\'get_account_code\',\'0\',\'\',\'\',\'\',\',\',\'3\',\'225\');"><a href="javascript://" onclick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=account_closed_table_def.'+to_account_id+'\',\'list\');"><img src="/images/plus_thin.gif" align="top" border="0" style="margin-left:3px;"></a>';			
		document.getElementById("row_count_debt_exit").value = row_count_debt_exit;
	}
   	function kontrol()
	{
		for (i=1; i<=document.getElementById("row_count_debt_exit").value; i++)
		{
			if(document.getElementById("row_kontrol_exit"+i).value == 1 && (document.getElementById("DEBT_ACCOUNT_ID"+i).value =='' || document.getElementById("DEBT_CLOSED_ACCOUNT_ID"+i).value ==''))
			{
				alert("Borçlu Hesap Grubu Alanında "+" "+i +".satırdaki bilgileri doldurunuz!");
				return false;
			}
			
		}
		for (i=1; i<=document.getElementById("row_count_claim_exit").value; i++)
		{
			if(document.getElementById("row_kontrol_exit_claim"+i).value == 1 && (document.getElementById("CLAIM_ACCOUNT_ID"+i).value =='' || document.getElementById("CLAIM_CLOSED_ACCOUNT_ID"+i).value ==''))
			{
				alert("Alacaklı Hesap Grubu Alanında "+" "+ i +".satırdaki bilgileri doldurunuz!");
				return false;
			}
		}
		return true;
	}
	
	function add_row_claim()
	{
		row_count_claim_exit++;
		var newRow;
		var newCell;
		var claim_account_id ="CLAIM_ACCOUNT_ID"+row_count_claim_exit;
		var claim_closed_account_id ="CLAIM_CLOSED_ACCOUNT_ID"+row_count_claim_exit;
		var type_row_="type_claim"+row_count_claim_exit;
		newRow = document.getElementById("Table_Claim").insertRow(document.getElementById("Table_Claim").rows.length);
		newRow.setAttribute("name","frm_row_exit_claim" + row_count_claim_exit);
		newRow.setAttribute("id","frm_row_exit_claim" + row_count_claim_exit);
		newRow.className = 'color-row';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML += '<input type="hidden" name="row_kontrol_exit_claim' + row_count_claim_exit +'" id="row_kontrol_exit_claim' + row_count_claim_exit +'" value="1"><a style="cursor:pointer"><img src="images/delete_list.gif" border="0" align="absmiddle" alt="Sil" onclick="sil_exit_claim('+ row_count_claim_exit + ');"></a>';;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML +='<input type="hidden" name="'+type_row_+'" id="'+type_row_+'" value="0"><input type="text" name="'+claim_account_id+'" id="'+claim_account_id+'" style="width:96%;" autocomplete="on" onFocus="AutoComplete_Create(\''+claim_account_id+'\',\'ACCOUNT_CODE,ACCOUNT_NAME\',\'ACCOUNT_CODE,ACCOUNT_NAME\',\'get_account_code\',\'1\',\'\',\'\',\'\',\',\',\'3\',\'225\');"><a href="javascript://" onclick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=account_closed_table_def.'+claim_account_id+'\',\'list\');"><img src="/images/plus_thin.gif" align="top" border="0" style="margin-left:3px;"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML +='<input type="text" name="'+claim_closed_account_id+'" id="'+claim_closed_account_id+'" style="width:96%;" autocomplete="on" onFocus="AutoComplete_Create(\''+claim_closed_account_id+'\',\'ACCOUNT_CODE,ACCOUNT_NAME\',\'ACCOUNT_CODE,ACCOUNT_NAME\',\'get_account_code\',\'0\',\'\',\'\',\'\',\',\',\'3\',\'225\');"><a href="javascript://" onclick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=account_closed_table_def.'+claim_closed_account_id+'\',\'list\');"><img src="/images/plus_thin.gif" align="top" border="0" style="margin-left:3px;"></a>';			
		document.getElementById("row_count_claim_exit").value = row_count_claim_exit;
	}
	
	function sil_exit(sy)
	{
		var my_element=eval("account_closed_table_def.row_kontrol_exit"+sy);
		my_element.value=0;
		var my_element=eval("frm_row_exit"+sy);
		my_element.style.display="none";
		
	}
	function sil_exit_claim(sy)
	{
		var my_element=eval("account_closed_table_def.row_kontrol_exit_claim"+sy);
		my_element.value=0;
		var my_element=eval("frm_row_exit_claim"+sy);
		my_element.style.display="none";
	}
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'addUpd';
	
	if(not isDefined("attributes.event"))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['addUpd'] = structNew();
	WOStruct['#attributes.fuseaction#']['addUpd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['addUpd']['fuseaction'] = 'account.account_closed_definition';
	WOStruct['#attributes.fuseaction#']['addUpd']['filePath'] = 'account/form/account_closed_definition.cfm';
	WOStruct['#attributes.fuseaction#']['addUpd']['queryPath'] = 'account/query/add_account_closed_definition.cfm';
	WOStruct['#attributes.fuseaction#']['addUpd']['nextEvent'] = 'account.account_closed_definition';
	WOStruct['#attributes.fuseaction#']['addUpd']['Identity'] = '';
	
</cfscript>
