<cf_xml_page_edit fuseact="ehesap.popup_list_period">
<cf_get_lang_set module_name="ehesap">
<cfquery name="get_company_periods" datasource="#DSN#">
	SELECT PERIOD_ID,PERIOD,PERIOD_YEAR FROM SETUP_PERIOD ORDER BY PERIOD_YEAR
</cfquery>
<cfif not isdefined("attributes.period_id") >
	<cfset attributes.period_id = SESSION.EP.PERIOD_ID>
</cfif>
<cfquery name="GET_IN_OUT_PERIODS" datasource="#DSN#">
	SELECT
		ACCOUNT_BILL_TYPE,
		ACCOUNT_CODE,
		EXPENSE_CODE,
		EXPENSE_CENTER_ID,
		EXPENSE_CODE_NAME,
		EXPENSE_ITEM_ID,
		EXPENSE_ITEM_NAME,
		RECORD_DATE,
		RECORD_EMP,
		UPDATE_DATE,
		UPDATE_EMP
	FROM
		EMPLOYEES_IN_OUT_PERIOD
	WHERE
		IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
</cfquery>
<cfquery name="get_active_period" dbtype="query">
	SELECT * FROM get_company_periods WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
</cfquery>
<cfquery name="get_acc_types" datasource="#dsn#">
	SELECT ACC_TYPE_ID,ACC_TYPE_NAME FROM SETUP_ACC_TYPE ORDER BY ACC_TYPE_ID DESC
</cfquery>
<cfset getActivity = createobject("component","workdata.get_activity_types").getActivity()>
<cfquery name="get_emp_id" datasource="#dsn#">
    SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
</cfquery>
<cfif get_in_out_periods.recordcount>
	<cfquery name="get_rows" datasource="#dsn#">
		SELECT 
        	ACC_TYPE_ID,
            ACCOUNT_CODE
        FROM 
        	EMPLOYEES_ACCOUNTS 
        WHERE 
        	EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_id.employee_id#"> AND
        	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#"> AND
            IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
       ORDER BY 
       		ACC_TYPE_ID DESC
	</cfquery>
	<cfquery name="get_rows_2" datasource="#iif(fusebox.use_period,"dsn2","dsn")#">
		SELECT 
        	PR.EXPENSE_CENTER_ID,
            PR.RATE,
            EC.EXPENSE,
			ACTIVITY_TYPE_ID
         FROM 
         	#dsn_alias#.EMPLOYEES_IN_OUT_PERIOD_ROW PR INNER JOIN EXPENSE_CENTER EC
            ON EC.EXPENSE_ID = PR.EXPENSE_CENTER_ID
         WHERE 
         	PR.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND 
            PR.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
	</cfquery>
<cfelse>
	<cfset get_rows.recordcount = 0>
	<cfset get_rows_2.recordcount = 0>
</cfif>
<cfif not isdefined("x_add_multi_expense_center")><cfset x_add_multi_expense_center = 0></cfif>

<cfset payroll_accounts= createObject("component","V16.hr.ehesap.cfc.payroll_accounts_code") />
<cfset get_code_cat=payroll_accounts.GET_CODE_CAT(payroll_id : iif(isdefined("GET_IN_OUT_PERIODS.ACCOUNT_BILL_TYPE"),"GET_IN_OUT_PERIODS.ACCOUNT_BILL_TYPE",DE('')))/>

<cf_box title="#getLang('','Çalışan Muhasebe Tanımları',46014)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_period" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_add_periods_to_in_out">
		<cfif isdefined("attributes.from_upd_salary") and attributes.from_upd_salary eq 1>
			<input type="hidden" name="from_upd_salary" id="from_upd_salary" value="1">
		</cfif>
    	<input name="in_out_id" id="in_out_id" type="hidden" value="<cfoutput>#attributes.in_out_id#</cfoutput>">
		<cf_seperator title="#getLang('','Muhasebe Kodları',54115)#" id="seperator_1">
		<cf_box_elements id="seperator_1">
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-period_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='54116.Dönem Yıl'></label>
					<div class="col col-8 col-xs-12">
						<select name="period_id" id="period_id" onChange="javascript:window.location.href='<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.popup_list_period&in_out_id=#attributes.in_out_id#&period_id=</cfoutput>' + document.getElementById('period_id').value;">
							<cfoutput query="get_company_periods">
								<option value="#PERIOD_ID#" <cfif get_company_periods.PERIOD_ID eq attributes.period_id>selected</cfif>>#PERIOD#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-period_code_cat">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='54117.Muhasebe Kod Grubu'></label>
					<div class="col col-8 col-xs-12">
						<select name="period_code_cat" id="period_code_cat">
							<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
							<cfoutput query="get_code_cat">
								<option value="#payroll_id#" <cfif payroll_id eq GET_IN_OUT_PERIODS.ACCOUNT_BILL_TYPE>selected</cfif>>#definition#</option>
							</cfoutput>
						</select>
					</div>
				</div>  
				<cfif fusebox.use_period>
					<cfif x_add_multi_acc eq 0>
						<div class="form-group" id="item-account_code">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cf_wrk_account_codes form_name='add_period' account_code="account_code" account_name='account_name' search_from_name='1' is_sub_acc='0' is_multi_no = '1'>
									<input type="Hidden" name="account_code" id="account_code" value="<cfoutput>#GET_IN_OUT_PERIODS.account_code#</cfoutput>">
									<cfif len(GET_IN_OUT_PERIODS.account_code)>
										<cfset attributes.account_code = GET_IN_OUT_PERIODS.account_code>
										<cfinclude template="../query/get_account.cfm">
										<cfset account_name = get_account.account_name>
										<cfset account_code = get_account.account_code>
									<cfelse>
										<cfset account_name = "">
										<cfset account_code = "">
									</cfif>
									<cfinput type="text" name="account_name" value="#account_code# - #account_name#" onkeyup="get_wrk_acc_code_1();">
									<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=add_period.account_name&field_id=add_period.account_code</cfoutput>')"></span>
								</div>
							</div>
						</div>  
					</cfif>
				</cfif>  
				<cfif x_add_multi_expense_center eq 0>
					<div class="form-group" id="item-expense_center_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif len(GET_IN_OUT_PERIODS.EXPENSE_CODE)>
									<input type="hidden" name="expense_center_id" id="expense_center_id" value="<cfoutput>#GET_IN_OUT_PERIODS.expense_center_id#</cfoutput>">
									<input type="hidden" name="EXPENSE_CODE" id="EXPENSE_CODE" value="<cfoutput>#GET_IN_OUT_PERIODS.expense_code#</cfoutput>">
									<cfinput type="Text" name="EXPENSE_CODE_NAME" value="#GET_IN_OUT_PERIODS.expense_code_name#">
								<cfelse>
									<input type="hidden" name="expense_center_id" id="expense_center_id" value="">
									<input type="hidden" name="EXPENSE_CODE" id="EXPENSE_CODE" value="">
									<cfinput type="Text" name="EXPENSE_CODE_NAME" value="">
								</cfif>
								<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=add_period.expense_center_id&field_code=add_period.EXPENSE_CODE&field_acc_code_name=add_period.EXPENSE_CODE_NAME</cfoutput>');"></span> 
							</div>
						</div>
					</div>             	
				</cfif>
				<div class="form-group" id="item-expense_item_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58551.Gider Kalemi'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfif len(GET_IN_OUT_PERIODS.EXPENSE_ITEM_ID)>
								<input type="hidden" name="expense_item_id" id="expense_item_id" value="<cfoutput>#GET_IN_OUT_PERIODS.EXPENSE_ITEM_ID#</cfoutput>">
								<cfinput type="text" name="expense_item_name" value="#GET_IN_OUT_PERIODS.EXPENSE_ITEM_NAME#">
							<cfelse>
								<input type="hidden" name="expense_item_id" id="expense_item_id" value="">
								<cfinput type="text" name="expense_item_name" value="">
							</cfif>
							<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_period.expense_item_id&field_acc_name=add_period.expense_item_name');"></span> 
						</div>
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cfif fusebox.use_period>
			<cfif x_add_multi_acc eq 1>
				<cf_grid_list>
					<thead>
						<tr>
							<th colspan="4"><cf_get_lang dictionary_id="55197.Muhasebe Hesapları"></th>
						</tr>
						<tr>
							<th width="20"><a onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
							<th><cf_get_lang dictionary_id="53329.Hesap Tipi"> *</th>
							<th><cf_get_lang dictionary_id='58811.muhasebe kodu'> *</th>
						</tr>
					</thead>
					<input name="record_num" id="record_num" type="hidden" value="<cfif get_rows.recordcount><cfoutput>#get_rows.recordcount#</cfoutput><cfelse>0</cfif>">
					<tbody id="link_table">
							<cfif isdefined("get_rows") and get_rows.recordcount>
							<cfoutput query="get_rows">
								<tr id="my_row_#currentrow#">
									<td>
										<input type="hidden" name="row_kontrol_#currentrow#" id="row_kontrol_#currentrow#" value="1"><cfif session.ep.ehesap or get_module_power_user(48)><a onclick="sil(#currentrow#);"><i class="fa fa-minus" title="Sil"></i></a></cfif>
									</td>
									<td>
										<div class="form-group">
											<select name="acc_type_id_#currentrow#" id="acc_type_id_#currentrow#">
												<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
												<cfloop query="get_acc_types">
													<option value="#get_acc_types.acc_type_id#" <cfif get_acc_types.acc_type_id eq get_rows.acc_type_id>selected</cfif>>#acc_type_name#</option>
												</cfloop>
											</select>
										</div>
									</td>
									<td nowrap>
										<cfif len(ACCOUNT_CODE)>
											<cfset attributes.account_code = ACCOUNT_CODE>
											<cfinclude template="../query/get_account.cfm">
											<cfset account_name = get_account.account_name>
											<cfset account_code = get_account.account_code>
										<cfelse>
											<cfset account_name = "">
											<cfset account_code = "">
										</cfif>
										<div class="form-group">
											<div class="input-group">
												<cfinput type="hidden"  name="account_code_#currentrow#" id="account_code_#currentrow#" value="#account_code#">
												<cfinput type="Text"  name="account_name_#currentrow#" id="account_name_#currentrow#" value="#account_code#-#account_name#" onFocus="AutoComplete_Create('account_code_#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225');" >
												<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="get_account('#currentrow#');" ></span>
											</div>
										</div>
									</td>
								</tr>
							</cfoutput>
						</cfif>
					</tbody>
				</cf_grid_list>
			</cfif>
		</cfif>
		<br>
		<cfif x_add_multi_expense_center eq 1>
			<cf_grid_list>
				<thead>
					<tr>
						<th colspan="4"><cf_get_lang dictionary_id="54256.Masraf Merkezleri"></th>
					</tr>
					<tr>
						<th width="20"><a onClick="add_row_2();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
						<th><cf_get_lang dictionary_id='58460.Masraf Merkezi'> *</th>
						<th><cf_get_lang dictionary_id='58456.Oran'> *</th>
						<th><cf_get_lang dictionary_id ="49184.Aktivite tipi"></th>
					</tr>
				</thead>
				<input name="record_num_2" id="record_num_2" type="hidden" value="<cfif get_rows_2.recordcount><cfoutput>#get_rows_2.recordcount#</cfoutput><cfelse>0</cfif>">
				<tbody id="link_table2">
						<cfif isdefined("get_rows_2") and get_rows_2.recordcount>
						<cfoutput query="get_rows_2">
							<tr id="my_row_2_#currentrow#">
								<td><input type="hidden" name="row_kontrol_2_#currentrow#" id="row_kontrol_2_#currentrow#" value="1"><a onclick="sil2(#currentrow#);"><i class="fa fa-minus" title="Sil"></i></a></td>
								<td nowrap>
									<div class="form-group">
										<div class="input-group">
											<input type="hidden" name="expense_center_id#currentrow#" id="expense_center_id#currentrow#" value="#expense_center_id#">
											<input type="text" name="expense_center_name#currentrow#" id="expense_center_name#currentrow#" value="<cfif len(expense_center_id)>#expense#</cfif>" class="boxtext" onFocus="AutoComplete_Create('expense_center_name#currentrow#','EXPENSE','EXPENSE','get_expense_center','1','EXPENSE_ID','expense_center_id#currentrow#','add_period',1);" autocomplete="off">
											<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_exp('#currentrow#');"></span>
										</div>
									</div>
								</td>
								<td nowrap>
									<input type="text" name="rate#currentrow#" id="rate#currentrow#" value="#tlformat(rate)#" onkeyup="return(FormatCurrency(this,event,2));" class="moneybox">
								</td>
								<td>
									<div class="form-group">
										<select name="expense_activity_id#currentrow#" id="expense_activity_id#currentrow#">
											<option value=""><cf_get_lang dictionary_id ="57734.Aktivite tipi"></option>
											<cfloop  query="getActivity">
												<option value="#activity_id#" <cfif getActivity.activity_id eq get_rows_2.activity_type_id>selected</cfif>>#activity_name#</option>
											</cfloop> 
										</select>
									</div>
								</td>
							</tr>
						</cfoutput>
					</cfif>
				</tbody>
			</cf_grid_list>
		</cfif>
		<input type="hidden" id="sil_id" value="" />
		<cf_box_footer>
			<div class="col col-12">
				<cfif GET_IN_OUT_PERIODS.recordcount><cf_record_info query_name="GET_IN_OUT_PERIODS"></cfif>
				<cfif attributes.period_id eq session.ep.period_id>
					<cf_workcube_buttons is_upd='0' add_function="kontrol()">
				<cfelse>
					<cf_get_lang dictionary_id="35399.İlgili Döneme Geçmeden Güncelleme Yapamazsınız">!
				</cfif>
			</div>
		<cf_box_footer>
	</cfform>
</cf_box>
<script language="javascript">
	function pencere_ac_exp(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&field_id=add_period.expense_center_id' + no +'&field_name=add_period.expense_center_name' + no);
	}
	row_count = <cfoutput>#get_rows.recordcount#</cfoutput>;
	row_count2 = <cfoutput>#get_rows_2.recordcount#</cfoutput>;
	function get_account(count)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=add_period.account_name_'+ count +'&field_id=add_period.account_code_' + count);
	}
	function sil(sy)
	{
		$('#sil_id').val(sy);
		doConfirm(confirm('<cf_get_lang dictionary_id="35397.Muhasebe Hesap Tanımını Kalıcı Olarak Silmek İstediğinizden Emin Misiniz?"><cf_get_lang dictionary_id="35396.Yapacağınız İşlem Sistemsel Sorunlara Neden Olabilir.">'));
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
		newCell.innerHTML = '<input type="hidden" name="row_kontrol_'+ row_count +'" value="1" /><cfif session.ep.ehesap or get_module_power_user(48)><a onclick="sil(' + row_count + ');" ><i class="fa fa-minus" title="Sil"></i></a></cfif>';	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML= '<div class="form-group"><select name="acc_type_id_'+ row_count +'"><option value="">Seçiniz</option><cfoutput query="get_acc_types"><option value="#get_acc_types.acc_type_id#">#get_acc_types.acc_type_name#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="account_code_'+ row_count +'" id="account_code_'+ row_count +'" value="">';
		newCell.innerHTML+= '<div class="form-group"><div class="input-group"><input type="text" name="account_name_'+row_count+'" id="account_name_'+ row_count +'" value="" onFocus="autocomp_account('+row_count+');"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="get_account(' + row_count + ');"></span></div></div>';
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
		newCell.innerHTML = '<input type="hidden" name="row_kontrol_2_'+ row_count2 +'" value="1" /><a onclick="sil2(' + row_count2 + ');" ><i class="fa fa-minus" title="Sil"></i></a>';	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML ='<div class="form-group"><div class="input-group"><input type="hidden" name="expense_center_id' + row_count2 +'" id="expense_center_id' + row_count2 +'" value=""><input type="text" id="expense_center_name' + row_count2 +'" name="expense_center_name' + row_count2 +'" onFocus="AutoComplete_Create(\'expense_center_name' + row_count2 +'\',\'EXPENSE,EXPENSE_CODE\',\'EXPENSE,EXPENSE_CODE\',\'get_expense_center\',\'0\',\'EXPENSE_ID\',\'expense_center_id' + row_count2 +'\',\'add_period\',1);" value="" class="boxtext"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_exp('+ row_count2 +');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="rate' + row_count2 +'" id="rate' + row_count2 +'" value="" onkeyup="return(FormatCurrency(this,event,2));" class="box">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="expense_activity_id' + row_count2 +'" id="expense_activity_id' + row_count2 +'"><option value=""><cf_get_lang dictionary_id ="57734.Aktivite tipi"></option><cfoutput query="getActivity"><option value="#activity_id#">#activity_name#</option></cfoutput></select></div>';
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
			}
		}
		<cfif isdefined("attributes.draggable")>
			loadPopupBox('add_period' , <cfoutput>#attributes.modal_id#</cfoutput>);
		</cfif>
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
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
