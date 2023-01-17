<cf_xml_page_edit fuseact="ehesap.popup_form_upd_payroll_accounts">
<cfparam name="attributes.modal_id" default="">
<cfif isdefined("attributes.payroll_id")>
	<cfquery name="get_definition" datasource="#dsn#">
		SELECT 
    	    PAYROLL_ID, 
            DEFINITION, 
            RECORD_EMP, 
            UPDATE_EMP, 
            RECORD_IP, 
            UPDATE_IP, 
            RECORD_DATE, 
            UPDATE_DATE,
			PAYROLL_STATUS
        FROM 
	        SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF 
        WHERE 
        	PAYROLL_ID = #attributes.payroll_id#
	</cfquery>
	<cfquery name="get_rows" datasource="#dsn#">
		SELECT 
        	ROW_ID, 
            PAYROLL_ID, 
            PUANTAJ_ACCOUNT_COL, 
            ACCOUNT_CODE, 
            BUDGET_ITEM, 
            PUANTAJ_BORC_ALACAK, 
            RECORD_EMP, 
            RECORD_IP, 
            RECORD_DATE, 
            PUANTAJ_ACCOUNT_DEFINITION, 
            PUANTAJ_ACCOUNT, 
            COMMENT_PAY_ID, 
            IS_PROJECT, 
            IS_NET,
            IS_EXPENSE
        FROM 
    	    SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF_ROWS 
        WHERE 
	        PAYROLL_ID = #attributes.payroll_id# 
        ORDER BY 
        	PUANTAJ_BORC_ALACAK,
			PUANTAJ_ACCOUNT_DEFINITION			
	</cfquery>
</cfif>
<cfparam name="attributes.modal_id" default="">
<cfsavecontent variable="title"><cf_get_lang dictionary_id='53139.Muhasebe Hesap Grupları'> - <cfif isdefined("attributes.is_copy")><cf_get_lang dictionary_id='57476.Kopyala'><cfelse><cf_get_lang dictionary_id='57464.Güncelle'></cfif></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#title#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="accounts" action="#request.self#?fuseaction=ehesap.emptypopup_upd_payroll_accounts">
				<cfif isdefined("attributes.payroll_id") and not isdefined("attributes.is_copy")>
					<input name="record_num" id="record_num" type="hidden" value="<cfif get_rows.recordcount><cfoutput>#get_rows.recordcount#</cfoutput><cfelse>0</cfif>">
					<input name="payroll_id" id="payroll_id" type="hidden" value="<cfoutput>#attributes.payroll_id#</cfoutput>">
					<cfset detail_ = get_definition.definition>
				<cfelseif isdefined("attributes.payroll_id") and isdefined("attributes.is_copy")>
					<input name="record_num" id="record_num" type="hidden" value="<cfif get_rows.recordcount><cfoutput>#get_rows.recordcount#</cfoutput><cfelse>0</cfif>">
					<cfset detail_ = get_definition.definition>
				<cfelse>
					<input name="record_num" id="record_num" type="hidden" value="0">
					<cfset detail_ = ''>
				</cfif>
				<cf_box_elements>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
						<div class="form-group" id="item-account_type">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="54021.Hesap Türü"></label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message1"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id="58233.Tanım"></cfsavecontent>
								<cfinput type="text" name="definition" required="yes" message="#message1#" maxlength="250" value="#detail_#" style="width:500px;">
							</div>
						</div>
						<div class="form-group" id="item-account_type_status">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='344.Durum'></label>
							<div class="col col-8 col-xs-12">
								<label><input type="checkbox" name="account_type_status" id="account_type_status" value="1"<cfif isdefined("attributes.payroll_id") and get_definition.payroll_status eq 1>checked</cfif>><cf_get_lang_main no ='81.Aktif'></label>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_grid_list>
					<thead>
						<tr>
							<th><a href="javascript://" onclick="add_row();"><i class="fa fa-plus" title=""></i></a></th>
							<th>&nbsp;<cf_get_lang dictionary_id='54292.Bordro Karşılığı'> *</th>
							<th><cf_get_lang dictionary_id='58083.Net'></th>
							<th>&nbsp;<cf_get_lang dictionary_id='57867.Borç/alacak'> *</th>
							<th>&nbsp;<cf_get_lang dictionary_id='58811.muhasebe kodu'> *</th>
							<th>&nbsp;<cf_get_lang dictionary_id='58234.bütçe Kalemi'></th>
							<th>&nbsp;<cf_get_lang dictionary_id='57629.açıklama'> *</th>
							<cfif is_project_acc eq 1><th>&nbsp;<cf_get_lang dictionary_id="54030.Proje Dağılımı"></th></cfif>
						</tr>
					</thead>
					<tbody id="link_table">
						<cfif isdefined("get_rows") and get_rows.recordcount>
							<cfoutput query="get_rows">
								<input type="hidden" name="row_kontrol_#currentrow#" id="row_kontrol_#currentrow#" value="1"/>
								<tr id="my_row_#currentrow#">
									<td><a  onclick="sil(#currentrow#);"><i class="fa fa-minus" border="0"></i></a></td>
									<td>
										<div class="form-group">
											<div class="input-group">
												<input type="hidden" readonly name="is_net#currentrow#" id="is_net#currentrow#" value="#is_net#">
												<input type="hidden" readonly name="is_expense#currentrow#" id="is_expense#currentrow#" value="#is_expense#">
												<input type="hidden" readonly name="comment_pay_id#currentrow#" id="comment_pay_id#currentrow#" value="#comment_pay_id#">
												<input type="hidden" readonly name="puantaj_account#currentrow#" id="puantaj_account#currentrow#" value="#PUANTAJ_ACCOUNT#">
												<input type="text" readonly name="puantaj_account_name_list#currentrow#" id="puantaj_account_name_list#currentrow#" value="#puantaj_account_col#" style="width:140px;"/>
												<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="get_puantaj_account(#currentrow#);"></span> 
											</div>
										</div>
									</td>
									<td><input type="text" class="boxtext" value="<cfif is_net eq 1><cf_get_lang dictionary_id='58083.Net'></cfif>" name="is_net_detail#currentrow#" id="is_net_detail#currentrow#" readonly="readonly"></td>
									<td>
										<select name="borc_alacak#currentrow#" id="borc_alacak#currentrow#" style="width:80px;">
										<option value="0" <cfif PUANTAJ_BORC_ALACAK eq 0>selected</cfif>><cf_get_lang dictionary_id='57587.Borç'></option>
										<option value="1" <cfif PUANTAJ_BORC_ALACAK eq 1>selected</cfif>><cf_get_lang dictionary_id='57588.Alacak'></option>
										</select>
									</td>
									<td>
										<cfif len(ACCOUNT_CODE)>
											<cfset attributes.account_code = ACCOUNT_CODE>
											<cfinclude template="../query/get_account.cfm">
											<cfset account_name = get_account.account_name>
											<cfset account_code = get_account.account_code>
										<cfelse>
											<cfset account_name = "">
											<cfset account_code = "">
										</cfif>
										<cf_wrk_account_codes form_name='accounts' account_code="ACCOUNT_CODE#currentrow#" account_name='ACCOUNT_NAME#currentrow#' search_from_name='1' is_sub_acc='0' is_multi_no = '1'>
											<div class="form-group">
												<div class="input-group">
													<input type="hidden" name="ACCOUNT_CODE#currentrow#" id="ACCOUNT_CODE#currentrow#" value="#ACCOUNT_CODE#">
													<cfinput type="Text" name="ACCOUNT_NAME#currentrow#" value="#ACCOUNT_CODE# - #ACCOUNT_NAME#" style="width:140px;">
													<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="get_account(#currentrow#);"></span> 
												</div>
											</div>
									</td>
									<td>
										<div class="form-group">
											<div class="input-group">
												<input type="hidden" name="BUDGET_ITEM#currentrow#" id="BUDGET_ITEM#currentrow#" value="#BUDGET_ITEM#">
												<cfif len(BUDGET_ITEM)>
													<cfquery name="get_expense_item_name" datasource="#DSN2#">
														SELECT EXPENSE_ITEM_NAME,ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #BUDGET_ITEM#
													</cfquery><cfinput type="text" name="BUDGET_NAME#currentrow#" value="#get_expense_item_name.ACCOUNT_CODE# - #get_expense_item_name.EXPENSE_ITEM_NAME#" style="width:140px;">
												<cfelse>
													<cfinput type="Text" name="BUDGET_NAME#currentrow#" value="" style="width:140px;">
												</cfif>
												<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="get_budget_item(#currentrow#);"></span>
											</div>
										</div>
									</td>
									<td><input type="text" name="puantaj_account_definition#currentrow#" id="puantaj_account_definition#currentrow#" value="#puantaj_account_definition#" style="width:150px;" /></td>
									<cfif is_project_acc eq 1>
										<td style="text-align:center;"><input type="checkbox" name="is_project#currentrow#" id="is_project#currentrow#" <cfif is_project eq 1>checked</cfif>></td>
									</cfif>
								</tr>
							</cfoutput>
						</cfif>
					</tbody>
				</cf_grid_list>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
					<cf_box_footer>
						<cfif isdefined("get_definition")>
							<cfif not isdefined("attributes.is_copy")>
								<div class="col col-6 col-xs-12">
									<cf_record_info query_name="get_definition">
								</div>
							</cfif>
							<div class="col col-6 col-xs-12">
								<cf_workcube_buttons is_upd="#iif(isdefined("attributes.is_copy"),0,1)#" is_delete = "0" add_function='kontrol()'>
							</div>
						<cfelse>
							<div class="col col-12">
								<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
							</div>
						</cfif>
					</cf_box_footer>
				</div>				
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	<cfif isdefined("get_rows") and get_rows.recordcount>
		row_count=<cfoutput>#get_rows.recordcount#</cfoutput>;
	<cfelse>
		row_count=0;
	</cfif>
	function get_puantaj_account(count)
	{	
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_list_puantaj_account_name&field_kesinti_id=accounts.comment_pay_id'+ count +'&field_net=accounts.is_net'+ count +'&field_detail=accounts.puantaj_account_definition'+ count +'&field_name=accounts.puantaj_account_name_list'+ count +'&field_id=accounts.puantaj_account'+count +'&field_expense=accounts.is_expense'+count +'&field_net_detail=accounts.is_net_detail'+count+'','list');
	}
	function get_account(count)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=accounts.ACCOUNT_NAME'+ count +'&field_id=accounts.ACCOUNT_CODE' + count);
	}
	function get_budget_item(count)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=accounts.BUDGET_ITEM' + count + '&field_acc_name=accounts.BUDGET_NAME' + count);
	}
	function sil(sy)
	{
		var my_element=eval("accounts.row_kontrol_"+sy);
		my_element.value=0;
		var my_element=eval("my_row_"+sy);
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
		document.accounts.record_num.value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a  onclick="sil(' + row_count + ');" ><i class="fa fa-minus" border="0"></i></a>';	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_kontrol_'+ row_count +'" value="1" />';
		newCell.innerHTML += '<div class="form-group"><div class="input-group"><input type="hidden" name="puantaj_account'+ row_count +'" value="" /><input type="hidden" name="comment_pay_id'+ row_count +'" value="" /><input type="hidden" name="is_net'+ row_count +'" value="" /><input type="hidden" name="is_expense'+ row_count +'" value="" /><input type="text" readonly name="puantaj_account_name_list'+ row_count +'" value="" /><span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="get_puantaj_account('+ row_count +');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" class="boxtext" value="" name="is_net_detail'+ row_count +'" id="is_net_detail#currentrow#" readonly="readonly" style="width:40px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="borc_alacak'+ row_count +'" style="width:80px;"><option value="0"><cf_get_lang dictionary_id='57587.Borç'></option><option value="1"><cf_get_lang dictionary_id='57588.Alacak'></option></select>';
		newCell= newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="Hidden" name="ACCOUNT_CODE'+ row_count +'" value=""><input type="Text" name="ACCOUNT_NAME'+row_count+'" value="" style="width:140px;" readonly ><span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="get_account(' + row_count + ');"></span>';
		newCell= newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="BUDGET_ITEM'+ row_count +'" value=""><input type="text" name="BUDGET_NAME' + row_count + '" value="" readonly style="width:140px;"><span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="get_budget_item(' + row_count +');"></span>';
		newCell=newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="puantaj_account_definition' + row_count +'" value="" style="width:150px;" />';
		<cfif is_project_acc eq 1>
			newCell=newRow.insertCell(newRow.cells.length);
			newCell.style.textAlign = 'center';
			newCell.innerHTML = '<input type="checkbox" name="is_project' + row_count +'">';
		</cfif>
	}
	function kontrol()
	{
		document.accounts.record_num.value=row_count;
		if(row_count == 0)
		{
			alert("Bir Kayıt Giriniz!");
			return false;
		}
		for(var j=1;j<=row_count;j++)
		{
			if(eval('document.accounts.row_kontrol_'+j+'.value')==1)
			{
				var liste = eval('document.accounts.puantaj_account_name_list'+j+'.value');
				if(liste == '')
				{
					alert("<cf_get_lang dictionary_id='54623.Lütfen Listeden Bir Veri Seçiniz'>!");
					return false;
				}
				var borc_alacak = eval('document.accounts.borc_alacak'+j+'.value');
				if(borc_alacak == '')
				{
					alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='57867.Borç/alacak'>");
					return false;
				}
				var muhasebe_kodu = eval('document.accounts.ACCOUNT_CODE'+j+'.value');
				if(muhasebe_kodu == '')
				{
					alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='58811.Muhasebe Kodu'>");
					return false;
				}
				var definition = eval('document.accounts.puantaj_account_definition'+j+'.value');
				if(definition == '')
				{
					alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='57629.açıklama'>");
					return false;
				}
			}
		}
		return true;
	}	
</script>
