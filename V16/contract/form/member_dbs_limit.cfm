<!--- Sirket DBS Tanimlari --->
<cfinclude template="../../cash/query/get_money.cfm">
<cfquery name="get_bank_names" datasource="#dsn#">
	SELECT BANK_ID,BANK_NAME FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
</cfquery>
<cfquery name="get_branch_names" datasource="#dsn3#">
	SELECT BANK_BRANCH_ID,BANK_BRANCH_NAME FROM BANK_BRANCH ORDER BY BANK_BRANCH_NAME
</cfquery>
<cfif isdefined("attributes.our_company_id") and len(attributes.our_company_id)>
	<cfset our_comp_id = attributes.our_company_id>
<cfelse>	
	<cfset our_comp_id = session.ep.company_id>
</cfif>
<cfquery name="get_dbs_limit" datasource="#dsn#">
	SELECT 
		PRIORITY,
		BANK_ID,
		BRANCH_ID,
		LIMIT,
		AVAILABLE_LIMIT,
		CREDIT_USED_AMOUNT,
		CURRENCY_ID,
		IS_ACTIVE,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP	
	FROM 
		COMPANY_CREDIT_DBS 
	WHERE 
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		AND OUR_COMPANY_ID = #our_comp_id#
</cfquery>
<cfform name="form_dbs" method="post" action="#request.self#?fuseaction=contract.emptypopoup_add_dbs_limit">
    <cf_grid_list>
		<input type="hidden" name="record_num_dbs" id="record_num_dbs" value="<cfoutput>#get_dbs_limit.recordcount#</cfoutput>">
		<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
		<input type="hidden" name="our_cmp_id_" id="our_cmp_id_" value="<cfoutput>#our_comp_id#</cfoutput>">
		<thead>
			<tr>
				<th width="20"></th>
				<th width="20"><a onClick="add_row_dbs();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
				<th><cf_get_lang dictionary_id='57485.Öncelik'></th>
				<th width="300"><cf_get_lang dictionary_id='57521.Banka'>*</th>
				<th width="300"><cf_get_lang dictionary_id='57453.Şube'>*</th>
				<th><cf_get_lang dictionary_id="53213.Limit">*</th>
				<th><cf_get_lang dictionary_id='57878.Kullanılabilir Limit'></th>
				<th><cf_get_lang dictionary_id="54747.Krediden Kullanılan Tutar"></th>
				<th><cf_get_lang dictionary_id='57677.Döviz'>*</th>
				<th width="20"><cf_get_lang dictionary_id='57493.Aktif'></th>
			</tr>
		</thead>
		<tbody name="table_dbs" id="table_dbs">
			<cfoutput query="get_dbs_limit">
				<tr id="frm_row_dbs#currentrow#">
					<input type="hidden" id="row_kontrol_dbs#currentrow#" name="row_kontrol_dbs#currentrow#" value="1">
					<td>#currentrow#<input type="hidden" name="row_#currentrow#" id="row_#currentrow#" value="#currentrow#"></td>
					<td><a onclick="sil_dbs(#currentrow#);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
					<td><div class="form-group"><input type="text" name="priority#currentrow#" id="priority#currentrow#" value="<cfif len(priority)>#priority#</cfif>" onKeyUp="isNumber(this)"></div></td>
					<td>
						<div class="form-group">
							<select name="bank_id#currentrow#" id="bank_id#currentrow#" onChange="set_bank_branch(this.value,#currentrow#);">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfloop query="get_bank_names">
									<option value="#get_bank_names.bank_id#" <cfif get_bank_names.bank_id eq get_dbs_limit.bank_id>selected</cfif>>#get_bank_names.bank_name#
								</cfloop>
							</select>
						</div>
					</td>
					<td>
						<div class="form-group">
							<cfif len(get_dbs_limit.branch_id)>
								<cfquery name="get_branch_" datasource="#dsn3#">
									SELECT 
										BANK_ID, 
										BANK_BRANCH_ID, 
										BANK_BRANCH_NAME, 
										BRANCH_CODE 
									FROM 
										BANK_BRANCH 
									WHERE 	
										BANK_ID IN (SELECT BANK_ID FROM BANK_BRANCH WHERE BANK_BRANCH_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#get_dbs_limit.branch_id#">) 
									ORDER BY 
										BANK_BRANCH_NAME
								</cfquery>
								<select name="bank_branch_id#currentrow#" id="bank_branch_id#currentrow#">
									<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
									<cfloop query="get_branch_">
										<option value="#bank_branch_id#" <cfif get_branch_.bank_branch_id eq get_dbs_limit.branch_id>selected</cfif>>#get_branch_.bank_branch_name#</option>
									</cfloop>
								</select>
							<cfelse>
								<select name="bank_branch_id#currentrow#" id="bank_branch_id#currentrow#">
									<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
								</select>
							</cfif>
						</div>
					</td>
					<td>
						<div class="form-group">
							<input type="text" name="limit#currentrow#" id="limit#currentrow#" value="<cfif len(limit)>#tlFormat(limit,2)#</cfif>" class="moneybox" onkeyup="return(FormatCurrency(this,event));">
						</div>
					</td>
					<td>
						<div class="form-group">
							<input type="text" name="available_limit#currentrow#" id="available_limit#currentrow#" value="<cfif len(available_limit)>#tlFormat(available_limit,2)#</cfif>" class="moneybox" onkeyup="return(FormatCurrency(this,event));">
						</div>
					</td>
					<td>
						<div class="form-group">
							<input type="text" name="credit_used_amount#currentrow#" id="credit_used_amount#currentrow#" value="<cfif len(credit_used_amount)>#tlFormat(credit_used_amount,2)#</cfif>" class="moneybox" onkeyup="return(FormatCurrency(this,event));">
						</div>
					</td>
					<td>
						<div class="form-group">
							<select name="money_id#currentrow#" id="money_id#currentrow#" style="width:60px;">
								<cfloop query="get_money">
									<option value="#get_money.money#" <cfif get_money.money eq get_dbs_limit.currency_id>selected</cfif>>#get_money.money#
								</cfloop>
							</select>
						</div>
					</td>
					<td>
						<input type="checkbox" name="is_active#currentrow#" id="is_active#currentrow#" value="1" <cfif is_active eq 1>checked</cfif>>
					</td>
				</tr>
			</cfoutput>	
		</tbody>
	</cf_grid_list>
	<cf_box_footer>
		<div class="col col-6">
			<cf_record_info query_name="get_dbs_limit">
		</div>
		<div class="col col-6">
			<cf_workcube_buttons type_format='1' is_upd='1' is_delete="0" add_function="control()">
		</div>
	</cf_box_footer>
    
</cfform>
<script type="text/javascript">
$(document).ready(function(){
	row_count_=<cfoutput>#get_dbs_limit.recordcount#</cfoutput>;
});	
	function sil_dbs(sy)
	{
		var my_element = document.getElementById("row_kontrol_dbs"+sy);
		my_element.value=0;
		var my_element=document.getElementById("frm_row_dbs"+sy);
		my_element.style.display="none";
	}	
	function add_row_dbs()
	{
		row_count_++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table_dbs").insertRow(document.getElementById("table_dbs").rows.length);	
		newRow.setAttribute("name","frm_row_dbs" + row_count_);
		newRow.setAttribute("id","frm_row_dbs" + row_count_);		
		document.getElementById("record_num_dbs").value=row_count_;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="row_' + row_count_ +'" id="row_' + row_count_ +'" value="'+row_count_+'" readonly="readonly" style="text-align:left; width:20px;"  class="box">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<a onclick="sil_dbs(' + row_count_ + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';				
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="row_kontrol_dbs' + row_count_ +'" id="row_kontrol_dbs' + row_count_ +'" value="1"><input type="text" name="priority' + row_count_ +'" id="priority' + row_count_ +'" value="" onKeyUp="isNumber(this)"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><select name="bank_id' + row_count_ + '" id="bank_id' + row_count_ + '" onChange="set_bank_branch(this.value,row_count_);"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option><cfoutput query="get_bank_names"><option value="#bank_id#">#bank_name#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><select name="bank_branch_id' + row_count_ + '" id="bank_branch_id' + row_count_ + '"></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><input type="text" name="limit' + row_count_ +'" id="limit' + row_count_ +'" class="moneybox" onkeyup="return(FormatCurrency(this,event));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><input type="text" name="available_limit' + row_count_ +'" id="available_limit' + row_count_ +'" class="moneybox" onkeyup="return(FormatCurrency(this,event));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><input type="text" name="credit_used_amount' + row_count_ +'" id="credit_used_amount' + row_count_ +'" class="moneybox" onkeyup="return(FormatCurrency(this,event));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		a = '<div class="form-group"><select name="money_id' + row_count_  +'" id="money_id' + row_count_ + '">';
		<cfoutput query="get_money">
			a += '<option value="#money#">#money#</option>';
		</cfoutput>
		newCell.innerHTML =a+ '</select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="checkbox" name="is_active' + row_count_ +'" id="is_active' + row_count_ +'" value="1" checked>';
	}
	function set_bank_branch(xyz,no)
	{
		var bank_branch_names = wrk_safe_query('bnk_branch_names',"dsn3",0,xyz);
		
		var option_count = document.getElementById('bank_branch_id'+no).options.length; 
		for(x=option_count;x>=0;x--)
			document.getElementById('bank_branch_id'+no).options[x] = null;
		
		if(bank_branch_names.recordcount != 0)
		{	
			document.getElementById('bank_branch_id'+no).options[0] = new Option("<cf_get_lang dictionary_id='57734.Seçiniz'>",'');
			for(var xx=0;xx<bank_branch_names.recordcount;xx++)
				document.getElementById('bank_branch_id'+no).options[xx+1]=new Option(bank_branch_names.BANK_BRANCH_NAME[xx],bank_branch_names.BANK_BRANCH_ID[xx]);
		}
		else
			document.getElementById('bank_branch_id'+no).options[0] = new Option("<cf_get_lang dictionary_id='57734.Seçiniz'>",'');
	}
	function control()
	{
		for(var n=1; n<=document.getElementById('record_num_dbs').value;n++)
		{
			if(document.getElementById('row_kontrol_dbs'+n).value == 1)
			{
				if (document.getElementById('bank_id'+n).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='57521.Banka'>\n<cf_get_lang dictionary_id='58230.Satır No'>: "+ document.getElementById("row_"+n).value);
					return false;
				}
				if (document.getElementById('bank_branch_id'+n).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='57453.Sube'>\n<cf_get_lang dictionary_id='58230.Satır No'>: "+ document.getElementById("row_"+n).value);
					return false;
				}
				if (document.getElementById('limit'+n).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>: Limit \n<cf_get_lang dictionary_id='58230.Satır No'>: "+ document.getElementById("row_"+n).value);
					return false;
				}
			}
		}	
		 unformat_fields();
		return true;	
	}
</script>

