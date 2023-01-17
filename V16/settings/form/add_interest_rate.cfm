<cfquery name="get_rates" datasource="#dsn3#">
	SELECT 
        MONTH_VALUE, 
        DUE_DAY,
        CREDITCARD_RATE, 
        CREDITCARD_RATE_DISCOUNT, 
        VOUCHER_RATE, 
        VOUCHER_RATE_DISCOUNT, 
        CHEQUE_RATE, 
        CHEQUE_RATE_DISCOUNT, 
        BANKPAYMENT_RATE, 
        BANKPAYMENT_RATE_DISCOUNT, 
        UPDATE_EMP, 
        UPDATE_IP, 
        UPDATE_DATE 
    FROM 
	    SETUP_INTEREST_RATE
</cfquery>
<div class="col col-12 col-xs-12">
	<cf_box title="#getLAng('','Vade Farkı Oranları',43567)#">
		<cfform name="add_rate" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_interest_rate" onsubmit="return(unformat_fields());">
			<cf_grid_list name="table1" id="table1" sort="0">
				<thead>
					<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_rates.recordcount#</cfoutput>">
					<tr>
						<th width="15" rowspan="2"><a style="cursor:pointer" onclick="add_row();" title="<cf_get_lang dictionary_id='57582.Ekle'>"><i class="fa fa-plus" border="0"></i></a></th>
						<th width="120" rowspan="2"><cf_get_lang dictionary_id='58724.Ay'></th>
						<th rowspan="2"><cf_get_lang dictionary_id='43667.Ort.Vade'></th>
						<th colspan="2"><cf_get_lang dictionary_id='58199.Kredi Kartı'></th>
						<th colspan="2"><cf_get_lang dictionary_id='58008.Senet'></th>
						<th colspan="2"><cf_get_lang dictionary_id='58007.Çek'></th>
						<th colspan="2"><cf_get_lang dictionary_id='57146.Havale'></th>
					</tr>
					<tr>
						<th><i class="fa fa-plus" border="0"></i></th>
						<th><i class="fa fa-minus" border="0"></i></th>
						<th><i class="fa fa-plus" border="0"></i></th>
						<th><i class="fa fa-minus" border="0"></i></th>
						<th><i class="fa fa-plus" border="0"></i></th>
						<th><i class="fa fa-minus" border="0"></i></th>
						<th><i class="fa fa-plus" border="0"></i></th>
						<th><i class="fa fa-minus" border="0"></i></th>
					</tr>
				</thead>
				
				<cfif get_rates.recordcount>
					<tbody>
						<cfoutput query="get_rates">
							<tr name="frm_row#currentrow#" id="frm_row#currentrow#" class="color-row">
								<td>
									<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
									<a style="cursor:pointer" onclick="sil(#currentrow#);"><i class="fa fa-minus" border="0" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
								</td>
								<td><div class="form-group"><input type="text" name="month#currentrow#" id="month#currentrow#" onBlur="hesapla_vade('#currentrow#')" value="#month_value#" class="text"></div></td>
								<td><div class="form-group"><input type="text" name="due_day#currentrow#" id="due_day#currentrow#"  value="#due_day#" class="moneybox" style="width:90px;"></div></td>
								<td><div class="form-group"><input type="text" name="creditcard_rate#currentrow#" id="creditcard_rate#currentrow#" value="#Tlformat(creditcard_rate)#" class="moneybox" style="width:50px;"></div></td>
								<td><div class="form-group"><input type="text" name="creditcard_rate_discount#currentrow#" id="creditcard_rate_discount#currentrow#" value="#Tlformat(creditcard_rate_discount)#" class="moneybox" style="width:50px;"></div></td>
								<td><div class="form-group"><input type="text" name="voucher_rate#currentrow#" id="voucher_rate#currentrow#" value="#Tlformat(voucher_rate)#" class="moneybox" style="width:50px;"></div></td>
								<td><div class="form-group"><input type="text" name="voucher_rate_discount#currentrow#" id="voucher_rate_discount#currentrow#" value="#Tlformat(voucher_rate_discount)#" class="moneybox" style="width:50px;"></div></td>
								<td><div class="form-group"><input type="text" name="cheque_rate#currentrow#" id="cheque_rate#currentrow#" value="#Tlformat(cheque_rate)#" class="moneybox" style="width:50px;"></div></td>
								<td><div class="form-group"><input type="text" name="cheque_rate_discount#currentrow#" id="cheque_rate_discount#currentrow#" value="#Tlformat(cheque_rate_discount)#" class="moneybox" style="width:50px;"></div></td>
								<td><div class="form-group"><input type="text" name="bankpayment_rate#currentrow#" id="bankpayment_rate#currentrow#" value="#Tlformat(bankpayment_rate)#" class="moneybox" style="width:50px;"></div></td>
								<td><div class="form-group"><input type="text" name="bankpayment_rate_discount#currentrow#" id="bankpayment_rate_discount#currentrow#" value="#Tlformat(bankpayment_rate_discount)#" class="moneybox" style="width:50px;"></div></td>
							</tr> 	
						</cfoutput>
					</tbody>
				</cfif>
			</cf_grid_list>
			
			<cf_box_footer>
				<cf_record_info query_name="get_rates">
				<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function kontrol()
{
	for(r=1;r<=add_rate.record_num.value;r++)
	{
		month = eval("document.add_rate.month"+r).value; 
		for(s=r+1;s<=add_rate.record_num.value;s++)
		{
			if(eval("document.add_rate.month"+s).value == month && eval("document.add_rate.row_kontrol"+s).value == 1)
			{
				alert("<cf_get_lang dictionary_id='43841.Satırlardaki Ay Değerleri Farklı Olmalıdır'> !");
				return false;
			}
		}
	}
}
function unformat_fields()
{
	for(r=1;r<=add_rate.record_num.value;r++)
	{
		eval("document.add_rate.creditcard_rate"+r).value = filterNum(eval("document.add_rate.creditcard_rate"+r).value);
		eval("document.add_rate.creditcard_rate_discount"+r).value = filterNum(eval("document.add_rate.creditcard_rate_discount"+r).value);
		eval("document.add_rate.voucher_rate"+r).value = filterNum(eval("document.add_rate.voucher_rate"+r).value);
		eval("document.add_rate.voucher_rate_discount"+r).value = filterNum(eval("document.add_rate.voucher_rate_discount"+r).value);
		eval("document.add_rate.cheque_rate"+r).value = filterNum(eval("document.add_rate.cheque_rate"+r).value);
		eval("document.add_rate.cheque_rate_discount"+r).value = filterNum(eval("document.add_rate.cheque_rate_discount"+r).value);
		eval("document.add_rate.bankpayment_rate"+r).value = filterNum(eval("document.add_rate.bankpayment_rate"+r).value);
		eval("document.add_rate.bankpayment_rate_discount"+r).value = filterNum(eval("document.add_rate.bankpayment_rate_discount"+r).value);
	}
}
row_count=<cfoutput>#get_rates.recordcount#</cfoutput>;
function sil(sy)
{
	var my_element=eval("add_rate.row_kontrol"+sy);
	my_element.value=0;
	var my_element=eval("frm_row"+sy);
	my_element.style.display="none";
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
	document.add_rate.record_num.value=row_count;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="hidden" name="row_kontrol'+row_count+'" value="1"><a style="cursor:pointer" onclick="sil(' + row_count + ');"  ><i class="fa fa-minus" border="0" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="month' + row_count +'" style="width:100%;" class="text" onkeyup="return(FormatCurrency(this,event,0));"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="due_day' + row_count +'" style="width:100%;" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event,0));"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="creditcard_rate' + row_count +'" style="width:100%;" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event));"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="creditcard_rate_discount' + row_count +'" style="width:100%;" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event));"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="voucher_rate' + row_count +'" style="width:100%;" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event));"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="voucher_rate_discount' + row_count +'" style="width:100%;" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event));"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="cheque_rate' + row_count +'" style="width:100%;" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event));"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="cheque_rate_discount' + row_count +'" style="width:100%;" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event));"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="bankpayment_rate' + row_count +'" style="width:100%;" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event));"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="bankpayment_rate_discount' + row_count +'" style="width:100%;" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event));"></div>';
}
function hesapla_vade(id)
{
	if (eval("document.add_rate.month"+id).value != "")
		eval("document.add_rate.due_day" + id).value = (30+(eval("document.add_rate.month"+id).value*30))/2;
}

</script>
