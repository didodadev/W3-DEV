<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfinclude template="../query/account_closed_definition_end.cfm">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cfform name="account_closed_table_def" action="#request.self#?fuseaction=account.emptypopup_add_account_closed_definition" method="post">
    <cf_box title="#getLang('account',253)#">
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
            <cf_grid_list>
                <input type="hidden" name="row_count_debt_exit" id="row_count_debt_exit" />
                <input type="hidden" name="is_form_submitted" value="1" />
                <thead>
					<tr>
						<th><a style="cursor:pointer" onclick="add_row_debt();" title="Satır Ekle"><i class="fa fa-plus"></i></a></th>
						<th><cfoutput>#getLang('','',60718)#</cfoutput></th>
						<th><cfoutput>#getLang('account',323)#</cfoutput></th>
                    </tr>
                </thead>
                <tbody id="Table_Debt">
					<cfif GET_ACCOUNT_CLOSED_DEBT.recordcount>
						<cfoutput query="GET_ACCOUNT_CLOSED_DEBT">
                            <tr id="frm_row_exit#currentrow#">
                                <td><a style="cursor:pointer" onclick="sil_exit(#currentrow#);" title="Sil"><i class="fa fa-minus"></i></a></td>
                                <td>
									<div class="form-group">
										<div class="col col-12">
											<div class="input-group">
												<input type="hidden" name="row_kontrol_exit#currentrow#" id="row_kontrol_exit#currentrow#" value="1">
												<input type="hidden" name="type_debt#currentrow#" id="type_debt#currentrow#" value="1">
												<input type="hidden" name="account_closed_id_debt#currentrow#" id="account_closed_id_debt#currentrow#" value="#GET_ACCOUNT_CLOSED_DEBT.ACCOUNT_CLOSED_ID#">
												<input type="text" name="DEBT_ACCOUNT_ID#currentrow#" id="DEBT_ACCOUNT_ID#currentrow#" value="#GET_ACCOUNT_CLOSED_DEBT.DEBT_ACCOUNT_CODE#" required="yes"  autocomplete="on" onFocus="AutoComplete_Create('DEBT_ACCOUNT_ID#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','1','','','','3','225');">
												<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_account_plan_all&field_id=account_closed_table_def.DEBT_ACCOUNT_ID#currentrow#','list');"></span>
											</div>
										</div>	
									</div>	
								</td>
                                <td>
									<div class="form-group">
										<div class="col col-12">
											<div class="input-group">
												<input type="text" name="DEBT_CLOSED_ACCOUNT_ID#currentrow#" id="DEBT_CLOSED_ACCOUNT_ID#currentrow#"  value="#GET_ACCOUNT_CLOSED_DEBT.CLOSED_ACCOUNT_CODE#" required="yes" autocomplete="on" onFocus="AutoComplete_Create('DEBT_CLOSED_ACCOUNT_ID#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225');">
												<span class="input-group-addon btnPointer icon-ellipsis"  href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_account_plan&field_id=account_closed_table_def.DEBT_CLOSED_ACCOUNT_ID#currentrow#','list');"></span>
											</div>
										</div>	
									</div>	
								</td>
                            </tr>
                        </cfoutput>
                    </cfif>
                </tbody>
            </cf_grid_list>
        </div>
        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
            <cf_grid_list>
                <input type="hidden" name="row_count_claim_exit" id="row_count_claim_exit" />
                <thead>
                    <tr>
                        <th><a style="cursor:pointer" onclick="add_row_claim();" title="Satır Ekle"><i class="fa fa-plus"></i></a></th>
                        <th><cfoutput>#getLang('','',59069)#</cfoutput></th>
                        <th><cfoutput>#getLang('account',323)#</cfoutput></th>
                    </tr>
                </thead>
                <tbody id="Table_Claim">
                    <cfif GET_ACCOUNT_CLOSED_CLAIM.recordcount>
                        <cfoutput query="GET_ACCOUNT_CLOSED_CLAIM">
                            <tr id="frm_row_exit_claim#currentrow#">
                                <td><a style="cursor:pointer" onclick="sil_exit_claim(#currentrow#);" title="Sil"><i class="fa fa-minus"></i></a></td>
                                <td>
									<div class="form-group">
										<div class="col col-12">
											<div class="input-group">
												<input type="hidden" name="row_kontrol_exit_claim#currentrow#" id="row_kontrol_exit_claim#currentrow#" value="1">
												<input type="hidden" name="type_claim#currentrow#" id="type_claim#currentrow#" value="1">
												<input type="hidden" name="account_closed_id_claim#currentrow#" id="account_closed_id_claim#currentrow#" value="#GET_ACCOUNT_CLOSED_CLAIM.ACCOUNT_CLOSED_ID#">
												<input type="text" name="CLAIM_ACCOUNT_ID#currentrow#" id="CLAIM_ACCOUNT_ID#currentrow#" value="#GET_ACCOUNT_CLOSED_CLAIM.CLAIM_ACCOUNT_CODE#" required="yes"  autocomplete="on" onFocus="AutoComplete_Create('CLAIM_ACCOUNT_ID#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','1','','','','3','225');">
												<span class="input-group-addon btnPointer icon-ellipsis"  href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_account_plan_all&field_id=account_closed_table_def.CLAIM_ACCOUNT_ID#currentrow#','list');"></span>
											</div>
										</div>	
									</div>	
								</td>
                                <td>
									<div class="form-group">
										<div class="col col-12">
											<div class="input-group">
												<input type="text" name="CLAIM_CLOSED_ACCOUNT_ID#currentrow#" id="CLAIM_CLOSED_ACCOUNT_ID#currentrow#"  required="yes" value="#GET_ACCOUNT_CLOSED_CLAIM.CLOSED_ACCOUNT_CODE#" autocomplete="on" onFocus="AutoComplete_Create('CLAIM_CLOSED_ACCOUNT_ID#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225');">
												<span class="input-group-addon btnPointer icon-ellipsis"  href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_account_plan&field_id=account_closed_table_def.CLAIM_CLOSED_ACCOUNT_ID#currentrow#','list');"></span>
											</div>
										</div>	
									</div>	
								</td>
                            </tr>
                        </cfoutput>
                    </cfif>
               </tbody>
            </cf_grid_list>
        </div>
	</div>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box_footer>
            <cf_workcube_buttons  is_upd="1" is_delete="0" add_function="kontrol()"	>
        </cf_box_footer>
		</div>
	</cf_box>
</cfform>
</div>
<script type="text/javascript">
	row_count_debt_exit = <cfoutput>#GET_ACCOUNT_CLOSED_DEBT.recordcount#</cfoutput>;
	row_count_claim_exit = <cfoutput>#GET_ACCOUNT_CLOSED_CLAIM.recordcount#</cfoutput>;
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
		newCell.innerHTML += '<input type="hidden" name="row_kontrol_exit' + row_count_debt_exit +'" id="row_kontrol_exit' + row_count_debt_exit +'" value="1"><a style="cursor:pointer" onclick="sil_exit('+ row_count_debt_exit + ');" ><i class="fa fa-minus"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML +='<div class="form-group"><div class="col col-12"><div class="input-group"><input type="hidden" name="'+type_row+'" id="'+type_row+'" value="0"><input type="text" name="'+temp_account_id+'" id="'+temp_account_id+'" autocomplete="on" onFocus="AutoComplete_Create(\''+temp_account_id+'\',\'ACCOUNT_CODE,ACCOUNT_NAME\',\'ACCOUNT_CODE,ACCOUNT_NAME\',\'get_account_code\',\'1\',\'\',\'\',\'\',\',\',\'3\',\'225\');"><span class="input-group-addon btnPointer icon-ellipsis"  href="javascript://" onclick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=account_closed_table_def.'+temp_account_id+'\',\'list\');"></span></div></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML +='<div class="form-group"><div class="col col-12"><div class="input-group"><input type="text" name="'+to_account_id+'" id="'+to_account_id+'" autocomplete="on" onFocus="AutoComplete_Create(\''+to_account_id+'\',\'ACCOUNT_CODE,ACCOUNT_NAME\',\'ACCOUNT_CODE,ACCOUNT_NAME\',\'get_account_code\',\'0\',\'\',\'\',\'\',\',\',\'3\',\'225\');"><span class="input-group-addon btnPointer icon-ellipsis"  href="javascript://" onclick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=account_closed_table_def.'+to_account_id+'\',\'list\');"></span></div></div></div>';
		document.getElementById("row_count_debt_exit").value = row_count_debt_exit;
	}
   	function kontrol()
	{
		for (i=1; i<=document.getElementById("row_count_debt_exit").value; i++)
		{
			if(document.getElementById("row_kontrol_exit"+i).value == 1 && (document.getElementById("DEBT_ACCOUNT_ID"+i).value =='' || document.getElementById("DEBT_CLOSED_ACCOUNT_ID"+i).value ==''))
			{
				alert("<cf_get_lang dictionary_id='56735.Borçlu Hesap Grubu Alanında'>" +i+ "<cf_get_lang dictionary_id='56774.satırdaki bilgileri doldurunuz'>!");
				return false;
			}
			
		}
		for (i=1; i<=document.getElementById("row_count_claim_exit").value; i++)
		{
			if(document.getElementById("row_kontrol_exit_claim"+i).value == 1 && (document.getElementById("CLAIM_ACCOUNT_ID"+i).value =='' || document.getElementById("CLAIM_CLOSED_ACCOUNT_ID"+i).value ==''))
			{
				alert("<cf_get_lang dictionary_id='59066.Alacaklı Hesap Grubu Alanında'>" +i+ "<cf_get_lang dictionary_id='56774.satırdaki bilgileri doldurunuz'>!");
				return false;
			}
		}
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
		newCell.innerHTML += '<input type="hidden" name="row_kontrol_exit_claim' + row_count_claim_exit +'" id="row_kontrol_exit_claim' + row_count_claim_exit +'" value="1" ><a style="cursor:pointer" onclick="sil_exit_claim('+ row_count_claim_exit + ');"><i class="fa fa-minus"></i></a>';;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML +='<div class="form-group"><div class="col col-12"><div class="input-group"><input type="hidden" name="'+type_row_+'" id="'+type_row_+'" value="0"><input type="text" name="'+claim_account_id+'" id="'+claim_account_id+'"  autocomplete="on" onFocus="AutoComplete_Create(\''+claim_account_id+'\',\'ACCOUNT_CODE,ACCOUNT_NAME\',\'ACCOUNT_CODE,ACCOUNT_NAME\',\'get_account_code\',\'1\',\'\',\'\',\'\',\',\',\'3\',\'225\');"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=account_closed_table_def.'+claim_account_id+'\',\'list\');"></span></div></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML +='<div class="form-group"><div class="col col-12"><div class="input-group"><input type="text" name="'+claim_closed_account_id+'" id="'+claim_closed_account_id+'"  autocomplete="on" onFocus="AutoComplete_Create(\''+claim_closed_account_id+'\',\'ACCOUNT_CODE,ACCOUNT_NAME\',\'ACCOUNT_CODE,ACCOUNT_NAME\',\'get_account_code\',\'0\',\'\',\'\',\'\',\',\',\'3\',\'225\');"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=account_closed_table_def.'+claim_closed_account_id+'\',\'list\');"></span></div></div></div>';			
		document.getElementById("row_count_claim_exit").value = row_count_claim_exit;
	}
	document.getElementById("row_count_debt_exit").value = row_count_debt_exit;
	document.getElementById("row_count_claim_exit").value = row_count_claim_exit;
	
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



