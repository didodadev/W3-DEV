<!--- şube ve departmana bağlı muhasebe tanımları yapılır--->
<cf_xml_page_edit fuseact="hr.popup_list_period">
<cf_get_lang_set module_name="ehesap">
<cfif not isdefined("attributes.period_id")>
	<cfset attributes.period_id = SESSION.EP.PERIOD_ID>
</cfif>
<cfif isdefined('attributes.department_id') and len(attributes.department_id)>
	<cfset attributes.department_id = attributes.department_id>
<cfelse>
	<cfset attributes.department_id = "">
</cfif>
<cfscript>
	cmp = createObject("component","V16.hr.cfc.create_account_period");
	cmp.dsn = dsn;
	cmp.dsn2_alias = dsn2_alias;
	get_company_periods = cmp.get_comp_period();
	get_active_period = cmp.get_comp_period(period_id:attributes.period_id);
	get_acc_types = cmp.get_acc_type();

	get_rows = cmp.get_account_definition(
		period_id:attributes.period_id,	
		branch_id:attributes.branch_id,
		department_id:attributes.department_id
	);
	
	if(get_rows.recordcount)
	{ 
		get_account_code_row = cmp.get_account_definiton_code_row(
		account_definition_id = get_rows.id
		);
	} else {get_account_code_row.recordcount = 0;}

	get_rows2 = cmp.get_account_expense(
		period_id:attributes.period_id,
		branch_id:attributes.branch_id,
		department_id:attributes.department_id
	);
	
	get_rows3 = cmp.get_account_code_definition(
		period_id:attributes.period_id,
		branch_id:attributes.branch_id,
		department_id:attributes.department_id
	);
	cmp2 = createObject("component","V16.hr.cfc.get_branches");
	cmp2.dsn = dsn;
	get_name_branch = cmp2.get_branch(branch_id:attributes.branch_id);
	
	if(len(attributes.department_id))
	{
		cmp3 = createObject("component","V16.hr.cfc.get_departments");
		cmp3.dsn = dsn;
		get_dept_name = cmp3.get_department(department_id:attributes.department_id);
		get_dept_name.department_head = get_dept_name.department_head;
	}
	else
	{
		get_dept_name.department_head = '';
	}
</cfscript>	
<cfif not isdefined("x_add_multi_expense_center")><cfset x_add_multi_expense_center = 0></cfif>
<cfinclude template="../ehesap/query/get_code_cat.cfm">
<cf_box title="#getLang('','Muhasebe Kodları',54115)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_period" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_add_periods_account_definition">
		<cf_box_elements>
			<cfoutput>
				<input type="hidden" name="branch_id" value="#attributes.branch_id#"> 
				<input type="hidden" name="department_id" value="#attributes.department_id#"> 
				<input type="hidden" name="is_multi_period_code_cat" value="#x_add_multi_period_code_cat#"/>
			</cfoutput>
			<div class="row"> 
				<div class="col col-12 uniqueRow">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-12 col-md-12 col-sm-6 col-xs-12" type="column" index="1" sort="true">
								<div class="row">
									<label class="col col-12 bold"></label>
								</div>
								<div class="form-group" id="item-period_id">
									<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='54116.Dönem Yıl'></label>
									<div class="col col-9 col-xs-12"> 
										<select name="period_id" id="period_id" style="width:145px;" onChange="javascript:window.location.href='<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.list_branches&event=addPeriod&branch_id=#attributes.branch_id#&department_id=#attributes.department_id#&period_id=</cfoutput>' + document.getElementById('period_id').value;">
											<cfoutput query="get_company_periods">
												<option value="#PERIOD_ID#" <cfif get_company_periods.PERIOD_ID eq attributes.period_id>selected</cfif>>#PERIOD#</option>
											</cfoutput>
										</select>
									</div>
								</div>						
								<div class="form-group" id="item-period_code_cat">
									<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='54117.Muhasebe Kod Grubu'></label>
									<div class="col col-9 col-xs-12">
										<cfif x_add_multi_period_code_cat eq 1>
											<cfif get_account_code_row.recordcount>
												<cfset account_code_list = valuelist(get_account_code_row.account_bill_type)>
											<cfelse>
												<cfset account_code_list ="">
											</cfif>
											<cf_multiselect_check 
												query_name="get_code_cat"  
												name="period_code_cat"
												width="145" 
												option_text="#getLang('main',322)#" 
												option_value="payroll_id"
												option_name="definition"
												value="iif(#listlen(account_code_list)#,#account_code_list#,DE(''))">
										<cfelse>
											<select name="period_code_cat" id="period_code_cat" style="width:145px;">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfoutput query="get_code_cat">
													<option value="#payroll_id#" <cfif payroll_id eq get_rows.ACCOUNT_BILL_TYPE>selected</cfif>>#definition#</option>
												</cfoutput>
											</select>
										</cfif>
									</div>
								</div>
								<cfif x_add_multi_acc eq 0>
									<div class="form-group" id="item-account_name">
										<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></label>
										<div class="col col-9 col-xs-12"> 
											<div class="input-group">
												<cf_wrk_account_codes form_name='add_period' account_code="account_code" account_name='account_name' search_from_name='1' is_sub_acc='0' is_multi_no = '1'>
												<input type="Hidden" name="account_code" id="account_code" value="<cfoutput>#get_rows.account_code#</cfoutput>">
												<cfif len(get_rows.account_code)>
													<cfset attributes.account_code = get_rows.account_code>
													<cfinclude template="../ehesap/query/get_account.cfm">
													<cfset account_name = get_account.account_name>
													<cfset account_code = get_account.account_code>
												<cfelse>
													<cfset account_name = "">
													<cfset account_code = "">
												</cfif>
												<cfinput type="text" name="account_name" value="#account_code# - #account_name#" style="width:145px;" onkeyup="get_wrk_acc_code_1();">
												<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=add_period.account_name&field_id=add_period.account_code</cfoutput>','list')"></span>
											</div>									
										</div>
									</div>
								</cfif>
								<cfif x_add_multi_expense_center eq 0>
									<div class="form-group" id="item-EXPENSE_CODE_NAME">
										<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></label>
										<div class="col col-9 col-xs-12"> 
											<div class="input-group">
												<cfif len(get_rows.EXPENSE_CODE)>
													<input type="hidden" name="expense_center_id" id="expense_center_id" value="<cfoutput>#get_rows.expense_center_id#</cfoutput>">
													<input type="hidden" name="EXPENSE_CODE" id="EXPENSE_CODE" value="<cfoutput>#get_rows.expense_code#</cfoutput>">
													<cfinput type="Text" name="EXPENSE_CODE_NAME" value="#get_rows.expense_code_name#" style="width:145px;">
												<cfelse>
													<input type="hidden" name="expense_center_id" id="expense_center_id" value="">
													<input type="hidden" name="EXPENSE_CODE" id="EXPENSE_CODE" value="">
													<cfinput type="Text" name="EXPENSE_CODE_NAME" value="" style="width:145px;">
												</cfif> 
												<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=add_period.expense_center_id&field_code=add_period.EXPENSE_CODE&field_acc_code_name=add_period.EXPENSE_CODE_NAME</cfoutput>','list');"></span>
											</div>
										</div>
									</div>
								</cfif>
								<div class="form-group" id="item-expense_item_name">
									<label class="col col-3 col-xs-12"><cf_get_lang_main no='1139.Gider Kalemi'></label>
									<div class="col col-9 col-xs-12"> 
										<div class="input-group">
											<cfif len(get_rows.EXPENSE_ITEM_ID)>
												<input type="hidden" name="expense_item_id" id="expense_item_id" value="<cfoutput>#get_rows.EXPENSE_ITEM_ID#</cfoutput>">
												<cfinput type="text" name="expense_item_name" value="#get_rows.EXPENSE_ITEM_NAME#" style="width:145px;">
											<cfelse>
												<input type="hidden" name="expense_item_id" id="expense_item_id" value="">
												<cfinput type="text" name="expense_item_name" value="" style="width:145px;">
											</cfif>
											<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_period.expense_item_id&field_acc_name=add_period.expense_item_name','list');"></span>
										</div>
									</div>
								</div>						
							</div>
						</div>
						<cfif x_add_multi_acc eq 1>
							<div class="row">						
								<div class="col col-12">
									<div class="ListContent">
										<table class="workDevList">
											<thead>
												<tr>
													<th colspan="3"><cf_get_lang dictionary_id="38814.Muhasebe Hesapları"></th>
												</tr>
												<tr>
													<th><input type="button" class="eklebuton" title="" onClick="add_row();"></th>
													<th style="width:150px;">&nbsp;<cf_get_lang dictionary_id="53329.Hesap Tipi"> *</th>
													<th style="width:170px;">&nbsp;<cf_get_lang dictionary_id='58811.muhasebe kodu'> *</th>
												</tr>
											</thead>
											<input name="record_num" id="record_num" type="hidden" value="<cfif get_rows3.recordcount><cfoutput>#get_rows3.recordcount#</cfoutput><cfelse>0</cfif>">
											<tbody id="link_table">
													<cfif isdefined("get_rows3") and get_rows3.recordcount>
													<cfoutput query="get_rows3">
														<tr id="my_row_#currentrow#">
															<td><input type="hidden" name="row_kontrol_#currentrow#" id="row_kontrol_#currentrow#" value="1"><cfif session.ep.ehesap or get_module_power_user(48)><a style="cursor:pointer" onclick="sil(#currentrow#);"><img  src="images/delete_list.gif" border="0"></a></cfif></td>
															<td>
																<select name="acc_type_id_#currentrow#" id="acc_type_id_#currentrow#" style="width:150px;">
																	<option value="">Seçiniz</option>
																	<cfloop query="get_acc_types">
																		<option value="#get_acc_types.acc_type_id#" <cfif get_acc_types.acc_type_id eq get_rows3.acc_type_id>selected</cfif>>#acc_type_name#</option>
																	</cfloop>
																</select>
															</td>
															<td nowrap>
																<cfif len(ACCOUNT_CODE)>
																	<cfset attributes.account_code = ACCOUNT_CODE>
																	<cfinclude template="../ehesap/query/get_account.cfm">
																	<cfset account_name = get_account.account_name>
																	<cfset account_code = get_account.account_code>
																<cfelse>
																	<cfset account_name = "">
																	<cfset account_code = "">
																</cfif>
																<cfinput type="hidden"  name="account_code_#currentrow#" id="account_code_#currentrow#" value="#account_code#">
																<cfinput type="Text"  name="account_name_#currentrow#" id="account_name_#currentrow#" value="#account_code#-#account_name#" style="width:150px;" onFocus="AutoComplete_Create('account_code_#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225');" >
																<a href="javascript://" onClick="get_account('#currentrow#');" ><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='1399.Muhasebe Kodu'>" border="0" align="top"></a>
															</td>
														</tr>
													</cfoutput>
												</cfif>
											</tbody>
										</table>
									</div>
								</div>
							</div>
						</cfif>
						<cfif x_add_multi_expense_center eq 1>
							<div class="row">
								<div class="col col-12">
									<div class="ListContent">
										<table class="workDevList">
											<thead>
												<tr>
													<th colspan="3"><cf_get_lang dictionary_id="44050.Masraf Merkezleri"></th>
												</tr>
												<tr>
													<th><input type="button" class="eklebuton" title="" onClick="add_row_2();"></th>
													<th style="width:150px;">&nbsp;<cf_get_lang dictionary_id='58460.Masraf Merkezi'> *</th>
													<th style="width:170px;">&nbsp;<cf_get_lang dictionary_id='58456.Oran'> *</th>
												</tr>
											</thead>
											<input name="record_num_2" id="record_num_2" type="hidden" value="<cfif get_rows2.recordcount><cfoutput>#get_rows2.recordcount#</cfoutput><cfelse>0</cfif>">
											<tbody id="link_table2">
													<cfif isdefined("get_rows2") and get_rows2.recordcount>
													<cfoutput query="get_rows2">
														<tr id="my_row_2_#currentrow#">
															<td><input type="hidden" name="row_kontrol_2_#currentrow#" id="row_kontrol_2_#currentrow#" value="1"><a style="cursor:pointer" onclick="sil2(#currentrow#);"><img  src="images/delete_list.gif" border="0"></a></td>
															<td nowrap>
																<input type="hidden" name="expense_center_id#currentrow#" id="expense_center_id#currentrow#" value="#expense_center_id#">
																<input type="text" name="expense_center_name#currentrow#" id="expense_center_name#currentrow#" value="<cfif len(expense_center_id)>#expense#</cfif>" class="boxtext" style="width:150px;" onFocus="AutoComplete_Create('expense_center_name#currentrow#','EXPENSE','EXPENSE','get_expense_center','1','EXPENSE_ID','expense_center_id#currentrow#','add_period',1);" autocomplete="off">
																<a href="javascript://" onClick="pencere_ac_exp('#currentrow#');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
															</td>
															<td nowrap>
																<input type="text" name="rate#currentrow#" id="rate#currentrow#" value="#tlformat(rate)#" onkeyup="return(FormatCurrency(this,event,2));" style="width:150px;" class="box">
															</td>
														</tr>
													</cfoutput>
												</cfif>
											</tbody>
										</table>
									</div>
								</div>
							</div>
						</cfif>
						<cfif get_rows.recordcount>
							<cf_box_footer>
								<div class="col col-8"><cf_record_info query_name="get_rows"></div>
								<div class="col col-4">
									<cfif attributes.period_id eq session.ep.period_id>
										<cf_workcube_buttons is_upd='0' add_function="kontrol()">
									<cfelse>
										<cf_get_lang dictionary_id="35399.İlgili Döneme Geçmeden Güncelleme Yapamazsınız">!
									</cfif>
								</div>
							<cfelse>
								<div class="col col-12">
									<cf_box_footer>	
									<cfif attributes.period_id eq session.ep.period_id>
										<cf_workcube_buttons is_upd='0' add_function="kontrol()">
									<cfelse>
										<cf_get_lang dictionary_id="35399.İlgili Döneme Geçmeden Güncelleme Yapamazsınız">!
									</cfif>
									
								</div>
							</cf_box_footer>
						</cfif>
					</div>
				</div>
			</div>
			<div id="confirm">
				<table>
					<tr>
						<td colspan="3"><b><cf_get_lang dictionary_id="35397.Muhasebe Hesap Tanımını Kalıcı Olarak Silmek İstediğinizden Emin Misiniz?"><br/><font style="color:red;"><cf_get_lang dictionary_id="35396.Yapacağınız İşlem Sistemsel Sorunlara Neden Olabilir."></font></b></td>
					</tr>
					<tr>
						<td><input type="hidden" id="sil_id" value="" /></td>
						<td style="width:10px;"><input type="button" id="ok" value="Tamam" onclick="doConfirm(true);setDisp('confirm', 'none');" /></td>
						<td style="width:10px;"><input type="button" id="cancel" value="İptal" onclick="doConfirm(false);setDisp('confirm', 'none');" /></td>
					</tr>
				</table>
				<div></div>
			</div>
		</cf_box_elements>
	</cfform>
</cf_box>
<script language="javascript">
	function pencere_ac_exp(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&field_id=add_period.expense_center_id' + no +'&field_name=add_period.expense_center_name' + no,'list');
	}
	row_count = <cfoutput>#get_rows3.recordcount#</cfoutput>;
	row_count2 = <cfoutput>#get_rows2.recordcount#</cfoutput>;
	function get_account(count)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=add_period.account_name_'+ count +'&field_id=add_period.account_code_' + count ,'list');
	}
	function sil(sy)
	{	
		setDisp('confirm', 'block');
		$('#sil_id').val(sy);
	}
	function sil2(sy)
	{
		var my_element=eval("document.add_period.row_kontrol_2_"+sy);
		my_element.value=0;
		var my_element=eval("my_row_2_"+sy);
		my_element.style.display="none";
	}
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);	
		newRow.setAttribute("name","my_row_" + row_count);
		newRow.setAttribute("id","my_row_" + row_count);		
		newRow.setAttribute("NAME","my_row_" + row_count);
		newRow.setAttribute("ID","my_row_" + row_count);		
		document.add_period.record_num.value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" name="row_kontrol_'+ row_count +'" value="1" /><cfif session.ep.ehesap or get_module_power_user(48)><a style="cursor:pointer" onclick="sil(' + row_count + ');" ><img src="images/delete_list.gif" border="0"></a></cfif>';	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML= '<select name="acc_type_id_'+ row_count +'" style="width:150px;"><option value="">Seçiniz</option><cfoutput query="get_acc_types"><option value="#get_acc_types.acc_type_id#">#get_acc_types.acc_type_name#</option></cfoutput></select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="account_code_'+ row_count +'" id="account_code_'+ row_count +'" value="">';
		newCell.innerHTML+= '<input type="text" name="account_name_'+row_count+'" id="account_name_'+ row_count +'" value="" style="width:150px;" onFocus="autocomp_account('+row_count+');">';
		newCell.innerHTML+= ' <a href="javascript://" onClick="get_account(' + row_count + ');"><img src="/images/plus_thin.gif" border="0" align="top"></a>';
	}
	function add_row_2()
	{
		row_count2++;
		var newRow;
		var newCell;
		newRow = document.getElementById("link_table2").insertRow(document.getElementById("link_table2").rows.length);	
		newRow.setAttribute("name","my_row_2_" + row_count2);
		newRow.setAttribute("id","my_row_2_" + row_count2);		
		newRow.setAttribute("NAME","my_row_2_" + row_count2);
		newRow.setAttribute("ID","my_row_2_" + row_count2);		
		document.add_period.record_num_2.value=row_count2;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" name="row_kontrol_2_'+ row_count2 +'" value="1" /><a style="cursor:pointer" onclick="sil2(' + row_count2 + ');" ><img src="images/delete_list.gif" border="0"></a>';	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML ='<input type="hidden" name="expense_center_id' + row_count2 +'" id="expense_center_id' + row_count2 +'" value=""><input type="text" id="expense_center_name' + row_count2 +'" name="expense_center_name' + row_count2 +'" onFocus="AutoComplete_Create(\'expense_center_name' + row_count2 +'\',\'EXPENSE,EXPENSE_CODE\',\'EXPENSE,EXPENSE_CODE\',\'get_expense_center\',\'0\',\'EXPENSE_ID\',\'expense_center_id' + row_count2 +'\',\'add_period\',1);" value="" style="width:150px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_exp('+ row_count2 +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="rate' + row_count2 +'" id="rate' + row_count2 +'" value="" onkeyup="return(FormatCurrency(this,event,2));" style="width:150px;" class="box">';
	}
	function autocomp_account(no)
	{
		AutoComplete_Create("account_name_"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_NAME,ACCOUNT_CODE","account_name_"+no+",account_code_"+no+"","",3);
	}
	function kontrol()
	{
		acc_type_id_list='';
		for(var j=1;j<=row_count;j++)
		{
			if(eval('document.add_period.row_kontrol_'+j+'.value')==1)
			{

				var definition = eval('document.add_period.acc_type_id_'+j+'.value');
				if(definition == '')
				{
					alert("<cf_get_lang dictionary_id='54642.Lütfen Hesap Tipi Seçiniz'>!");
					return false;
				}
				var muhasebe_kodu = eval('document.add_period.account_code_'+j+'.value');
				if(muhasebe_kodu == '')
				{
					alert("<cf_get_lang dictionary_id='35394.Lütfen Muhasebe Kodunu Seçiniz'>!");
					return false;
				}
				if(list_find(acc_type_id_list,eval('document.add_period.acc_type_id_'+j+'.value'),','))
				{
					alert("<cf_get_lang dictionary_id='35386.Satırlarda Aynı Hesap Türleri Seçili Olamaz'>!");
					return false;
				}
				else
				{
					if(list_len(acc_type_id_list,',') == 0)
						acc_type_id_list+=eval('document.add_period.acc_type_id_'+j+'.value');
					else
						acc_type_id_list+=","+eval('document.add_period.acc_type_id_'+j+'.value');
				}
			}
		}
		expense_center_id_list = '';
		for(var j=1;j<=row_count2;j++)
		{
			if(eval('document.add_period.row_kontrol_2_'+j+'.value')==1)
			{
				if(eval('document.add_period.expense_center_id'+j+'.value') == '' || eval('document.add_period.expense_center_name'+j+'.value') == '')
				{
					alert('<cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id="58460.Masraf Merkezi">');
					return false;
				}
				if(eval('document.add_period.rate'+j+'.value') == '')
				{
					alert('<cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id="58456.Oran">');
					return false;
				}
				if(list_find(expense_center_id_list,eval('document.add_period.expense_center_id'+j+'.value'),','))
				{
					alert("<cf_get_lang dictionary_id='35385.Satırlarda Aynı Masraf Merkezi Seçili Olamaz'>!");
					return false;
				}
				else
				{
					if(list_len(expense_center_id_list,',') == 0)
						expense_center_id_list+=eval('document.add_period.expense_center_id'+j+'.value');
					else
						expense_center_id_list+=","+eval('document.add_period.expense_center_id'+j+'.value');
				}
				
			}
		}
		return true;
	}
	function doConfirm(v)
	{
		var b = document.getElementById('btn');
		var sy = document.getElementById('sil_id').value;
		if(v){
			var my_element=eval("document.add_period.row_kontrol_"+sy);
			my_element.value=0;
			var my_element=eval("my_row_"+sy);
			my_element.style.display="none";
		}
		return v;
	}
			
	function setDisp(id, disp)
	{
		document.getElementById(id).style.display = disp;
	}
</script>
<style type="text/css">
	#confirm {
		position: absolute;
		top: 100px;
		left: 70px;
		border: outset #000 1px;
		padding: 1em 3em;
		display: none;
		background: #ffffff;
		width: 350px;
	}
</style>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">