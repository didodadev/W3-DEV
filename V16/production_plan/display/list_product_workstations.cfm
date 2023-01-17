<cfparam  name="attributes.unit2" default="">
<cfparam  name="attributes.station_id" default="1">
<cfquery name="GET_WORKSTATION_DETAIL" datasource="#DSN3#">
	SELECT ISNULL(REFLECTION_TYPE,1) REFLECTION_TYPE,UNIT2 FROM WORKSTATIONS WHERE STATION_ID = #attributes.station_id#
</cfquery>
<cfparam  name="attributes.reflection_type" default="#get_workstation_detail.reflection_type#">
<cfquery name="GET_UNIT" datasource="#DSN#">
	SELECT UNIT FROM SETUP_UNIT
</cfquery>
<cfquery name="GET_COMPANY_PERIODS" datasource="#DSN#">
	SELECT PERIOD_ID,PERIOD FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id#  ORDER BY PERIOD_ID DESC
</cfquery>
<cfquery name="GET_" datasource="#DSN3#">
	select STATION_ID from WORKSTATION_PERIOD
</cfquery>
<cfquery name="GET2_" datasource="#DSN3#">
	select STATION_ID from WORKSTATION_PERIOD WHERE CONCAT(',',STATION_ID,',') LIKE CONCAT('%,',#attributes.station_id#,',%') 
</cfquery>
<cfset s_list = valuelist(GET_.STATION_ID)>
<cfset s_list2 = valuelist(GET2_.STATION_ID)>

<cfif not len(s_list2)>
	<cfset s_list2 = attributes.station_id>
</cfif>
<cfquery name="GET_STATION" datasource="#DSN3#">
	SELECT DISTINCT STATION_NAME,STATION_ID FROM WORKSTATIONS WHERE STATION_ID IN ( #PreserveSingleQuotes(s_list2)#)
	<cfif len(s_list)>
	UNION
	SELECT DISTINCT STATION_NAME,STATION_ID FROM WORKSTATIONS WHERE STATION_ID NOT IN ( #PreserveSingleQuotes(s_list)#)
	</cfif>
</cfquery>
<cfif not isdefined("attributes.period_id")><cfset attributes.period_id = session.ep.period_id></cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent  variable="title"><cf_get_lang dictionary_id='36314.Work Center Expense Definitions'></cfsavecontent>
	<cf_box title="#title#">
		<cfform name="list_workstation" method="post" action="#request.self#?fuseaction=prod.emptypopup_add_product_workstations">
			<cf_box_elements>
				<div class="col col-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-period_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58472.Dönem"></label>
						<div class="col col-8 col-xs-12">
							<select name="period_id" id="period_id">
								<cfoutput query="get_company_periods">
									<option value="#period_id#"<cfif get_company_periods.period_id eq attributes.period_id>selected</cfif>>#period#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-prod_ref_type">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="36649.Dağıtım Anahtarı"></label>
						<div class="col col-8 col-xs-12">
							<select name="reflection_type" id="reflection_type" onchange="kontrol_unit();">
								<option value="1" <cfif attributes.reflection_type eq 1>selected</cfif>><cf_get_lang dictionary_id="29513.Süre"></option>
								<option value="2" <cfif attributes.reflection_type eq 2>selected</cfif>><cf_get_lang dictionary_id="36626.Ana Birim"></option>
								<option value="3" <cfif attributes.reflection_type eq 3>selected</cfif>><cf_get_lang dictionary_id="36635.Ek Birim"></option>
								<option value="4" <cfif attributes.reflection_type eq 4>selected</cfif>><cf_get_lang dictionary_id="36648.Standart Alış Fiyatı"></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="unit_1" <cfif get_workstation_detail.reflection_type neq 3>style="display:none;"</cfif>>
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="36635.Ek Birim"></label>
						<div class="col col-8 col-xs-12">
							<select name="prod_unit2" id="prod_unit2">
								<cfoutput query="get_unit">
									<option value="#UNIT#" <cfif attributes.unit2 eq get_unit.unit>selected</cfif>>#unit#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-station_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="36326.İş İstasyonları"></label>
						<div class="col col-8 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57734.Seçiniz'></cfsavecontent>
						<cfinput type="hidden" name="station_id_" id="station_id_" value="#attributes.station_id#">
								<cf_multiselect_check 
								query_name="GET_STATION"  
								name="station_id"
								width="140" 
								option_value="station_id"
								option_name="station_name"
								option_text="#message#"
								value="#iif(isdefined('s_list2'),'s_list2',DE(''))#">
						</div>
					</div>
				</div>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
					<div class="col col-6 col-md-6 col-sm-12 col-xs-12">					
						<!--- masraf merkezi ekle --->
						<cf_grid_list>
							<thead>
								<tr> 
									<th style="width:20px;">
										<a onClick="add_cost();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='36332.Masraf Merkezi Ekle'>"></i></a>
									</th>
									<cfquery name="EXPENCE_CENT" datasource="#DSN3#">
										SELECT 
											EC.EXPENSE,
											WP.EXPENSE_ID,
											WP.EXPENSE_SHIFT,
											WP.COST_TYPE
										FROM 
											WORKSTATION_PERIOD WP,
											#dsn2_alias#.EXPENSE_CENTER AS EC 
										WHERE 
											WP.ACCOUNT_ID IS NULL AND 
											EC.EXPENSE_ID = WP.EXPENSE_ID AND 
											CONCAT(',',WP.STATION_ID,',')  LIKE CONCAT('%,',#attributes.STATION_ID#,',%')
											AND WP.PERIOD_ID = #attributes.period_id#  
									</cfquery>
									
									<th><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
									<th><cf_get_lang dictionary_id ='36412.Yansıma'> %</th>
									<th><cf_get_lang dictionary_id ='58258.Maliyet'></th>
								</tr>
							</thead>
							<tbody id="add_station">
								<input type="hidden" name="record_num1" id="record_num1" value="<cfoutput>#expence_cent.recordcount#</cfoutput>">
								<cfif expence_cent.recordcount>
									<cfoutput query="expence_cent">
										<tr id="pro_station#currentrow#">
											<td><input  type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#"><a onclick="sil(#currentrow#);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id ='57463.sil'>"></i></a></td>
											<td>
												<div class="form-group">
													<div class="input-group">
														<input type="hidden" name="expense_id#currentrow#" id="expense_id#currentrow#" value="#EXPENSE_ID#">
														<input type="text" name="expense#currentrow#" id="expense#currentrow#" value="#EXPENSE#">
														<span class="input-group-addon icon-ellipsis btnPointer" onClick="pencere_ac_exp(#currentrow#);"></span>
													</div>
												</div>											
											</td>
											<td>
												<div class="form-group">
													<input type="text" name="expense_shift#currentrow#" id="expense_shift#currentrow#" value="#tlformat(EXPENSE_SHIFT,4)#" onKeyup="return(FormatCurrency(this,event,6));"  class="moneybox" >
												</div>
											</td>
											<td>
												<div class="form-group">
													<select name="expense_cost_type#currentrow#" id="expense_cost_type#currentrow#">
														<option value="1" <cfif expence_cent.cost_type eq 1>selected</cfif>><cf_get_lang dictionary_id="29954.Genel"></option>
														<option value="2" <cfif expence_cent.cost_type eq 2>selected</cfif>><cf_get_lang dictionary_id="57784.İşçilik"></option>
													</select>
												</div>
											</td>
										</tr>
									</cfoutput>
								</cfif>
							</tbody>
						</cf_grid_list>
					</div>		
					<div class="col col-6 col-md-6 col-sm-12 col-xs-12">	
						<!--- muhasebe hesabı ekle --->
						<cf_grid_list>
							<thead>
								<tr> 
									<th style="width:20px;">
										<a onClick="add_acont();"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id ='36348.Muhasebe Hesabı Ekle'>"></i></a>
									</th>
									<cfquery name="ACCOUNT_ACC" datasource="#DSN3#">
										SELECT 
											AC.ACCOUNT_NAME,
											AC.ACCOUNT_CODE,
											WP.ACCOUNT_SHIFT,
											WP.ACCOUNT_ID,
											WP.COST_TYPE							
										FROM 
											WORKSTATION_PERIOD WP,
											#dsn2_alias#.ACCOUNT_PLAN AS AC 
										WHERE
											WP.EXPENSE_ID IS NULL AND 
											AC.ACCOUNT_CODE = WP.ACCOUNT_ID AND
											CONCAT(',',WP.STATION_ID,',')  LIKE CONCAT('%,',#attributes.STATION_ID#,',%')
											AND WP.PERIOD_ID = #attributes.period_id#  
									</cfquery>
									<th><cf_get_lang dictionary_id ='36350.Muhasebe Hesabı'></th>
									<th><cf_get_lang dictionary_id ='36412.Yansıma'> %</th>
									<th width="100"><cf_get_lang dictionary_id ='58258.Maliyet'></th>
								</tr>
							</thead>
							<tbody id="add_accounts">
								<input type="hidden" name="record_num2" id="record_num2" value="<cfoutput>#account_acc.recordcount#</cfoutput>">
								<cfif account_acc.recordcount>
									<cfoutput query="account_acc">
										<tr id="pro_station_2#currentrow#">
											<td><input  type="hidden" value="1" name="row_kontrol2_#currentrow#" id="row_kontrol2_#currentrow#"><a onclick="sil_2(#currentrow#);"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id ='57463.sil'>"></i></a></td>
											<td>
												<div class="form-group">
													<div class="input-group">
														<input type="hidden" name="account_id#currentrow#" id="account_id#currentrow#" value="#ACCOUNT_ID#">
														<input type="text" name="account_code#currentrow#" id="account_code#currentrow#" value="#ACCOUNT_CODE#-#ACCOUNT_NAME#" onFocus="autocomp_account(#currentrow#);">
														<span class="input-group-addon icon-ellipsis btnPointer" onClick="pencere_ac_acc(#currentrow#);"></span>
													</div>
												</div>
											</td>
											<td>
												<div class="form-group">
													<input type="text" name="account_shift#currentrow#" id="account_shift#currentrow#" value="#tlformat(account_shift,4)#" onKeyup="return(FormatCurrency(this,event,6));"  class="moneybox">
												</div>
											</td>
											<td>
												<div class="form-group">
													<select name="account_cost_type#currentrow#" id="account_cost_type#currentrow#">
														<option value="1" <cfif account_acc.cost_type eq 1>selected</cfif>><cf_get_lang dictionary_id="29954.Genel"></option>
														<option value="2" <cfif account_acc.cost_type eq 2>selected</cfif>><cf_get_lang dictionary_id="57784.İşçilik"></option>
													</select>
												</div>
											</td>
										</tr>
									</cfoutput>
								</cfif>
							</tbody>
						</cf_grid_list>	
					</div>						
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' add_function ='control()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	var row_count = document.getElementById('record_num1').value;
	var row_count2 = document.getElementById('record_num2').value;
	function sil(sy){
		var my_element=eval("list_workstation.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("pro_station"+sy);
		my_element.style.display="none";
	}
	function add_cost(){
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("add_station").insertRow(document.getElementById("add_station").rows.length);
		newRow.setAttribute("name","pro_station" + row_count);
		newRow.setAttribute("id","pro_station" + row_count);
		document.list_workstation.record_num1.value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><a onclick="sil(' + row_count + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id ='57463.sil'>"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="expense_id' + row_count +'" id="expense_id' + row_count +'" value=""><input type="text" name="expense' + row_count +'">'+' '+'<span class="input-group-addon icon-ellipsis btnPointer" onClick="pencere_ac_exp('+ row_count +');"></span></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="expense_shift' + row_count +'" id="expense_shift' + row_count +'" onKeyup="return(FormatCurrency(this,event,6));" class="moneybox"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="expense_cost_type' + row_count +'"><option value="1"><cf_get_lang dictionary_id="29954.Genel"></option><option value="2"><cf_get_lang dictionary_id="57784.İşçilik"></option></select></div>';
	}

	function open_station_popup(no){
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_list_workstation&c=1&field_name=add_production_order.station_name'+no+'&field_id=add_production_order.station_id'+no,'list');
	}
	function pencere_ac_exp(no){
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=list_workstation.expense_id' + no +'&field_name=list_workstation.expense' + no,'list');
	}
 	function sil_2(sy){
		var my_element=eval("list_workstation.row_kontrol2_"+sy);
		my_element.value=0;
		var my_element=eval("pro_station_2"+sy);
		my_element.style.display="none";
	}
	function sil_3(sy){
		var my_element=eval("list_workstation.row_kontrol3_"+sy);
		my_element.value=0;
		var my_element=eval("pro_station_3"+sy);
		my_element.style.display="none";
	}

	function add_acont(expense_id,expense){
		row_count2++;
		var newRow;
		var newCell;
		newRow = document.getElementById("add_accounts").insertRow(document.getElementById("add_accounts").rows.length);
		newRow.setAttribute("name","pro_station_2" + row_count2);
		newRow.setAttribute("id","pro_station_2" + row_count2);
		document.list_workstation.record_num2.value=row_count2;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_kontrol2_'+row_count2+'" id="row_kontrol2_'+row_count2+'" value="1"><a onclick="sil_2(' + row_count2 + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id ='57463.sil'>"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input  type="hidden" name="account_id' + row_count2 +'" id="account_id' + row_count2 +'"><input type="text" name="account_code' + row_count2 +'" id="account_code' + row_count2 +'" onFocus="autocomp_account('+row_count2+');">'+' '+'<span class="input-group-addon icon-ellipsis btnPointer" onClick="pencere_ac_acc('+ row_count2 +');"></span></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="account_shift' + row_count2 +'" id="account_shift' + row_count2 +'" onKeyup="return(FormatCurrency(this,event,6));" class="moneybox"></div>';		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="account_cost_type' + row_count2 +'"><option value="1"><cf_get_lang dictionary_id="29954.Genel"></option><option value="2"><cf_get_lang dictionary_id="57784.İşçilik"></option></select></div>';
	}
	function pencere_ac_acc(no){
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=list_workstation.account_id' + no +'&field_name=list_workstation.account_code' + no +'','list');
	}
	function autocomp_account(no)
	{
		AutoComplete_Create("account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","1","ACCOUNT_CODE","account_id"+no,"",3);
	}
	function control(){
		if(row_count == 0 && row_count2 == 0){
			alert("<cfoutput><cf_get_lang dictionary_id='44006.Kaydetmek İçin En Az Bir Seçim Yapmalısınız'></cfoutput>");
			return false;
		}
		for(i=1;i<=row_count;i++)
			if (eval("list_workstation.row_kontrol"+i).value == 1){
				if(!form_warning('expense'+i+'','<cfoutput><cf_get_lang dictionary_id="51382.Masraf Merkezi Seçiniz!"></cfoutput>'))return false;
				if(!form_warning('expense_shift'+i+'','<cf_get_lang dictionary_id="64548.Masraf Yansıma Oranı Giriniz">!'))return false;
			}
		for(j=1;j<=row_count2;j++)
			if (eval("list_workstation.row_kontrol2_"+j).value == 1){
				if(!form_warning('account_code'+j+'','<cfoutput><cf_get_lang dictionary_id="43202.Muhasebe Hesabı Seçiniz!"></cfoutput>!'))return false;
				if(!form_warning('account_shift'+j+'','<cfoutput><cf_get_lang dictionary_id="60538.Yansıma Oranı Giriniz!"></cfoutput>!'))return false;
			}
		convert_fields();	
		return true;
	}
	function convert_fields()
	{
		for(i=1;i<=row_count;i++)
			if (eval("list_workstation.row_kontrol"+i).value == 1)
				allFilterNum('expense_shift'+i+'');
		for(x=1;x<=row_count2;x++)
			if (eval("list_workstation.row_kontrol2_"+x).value == 1)
				allFilterNum('account_shift'+x+'');
	}
	function kontrol_unit()
	{
		if(document.all.prod_ref_type.value == 3)
		{
			unit_1.style.display='';
			unit_2.style.display='';
		}
		else
		{
			unit_1.style.display='none';
			unit_2.style.display='none';
		}
	}
</script> 
