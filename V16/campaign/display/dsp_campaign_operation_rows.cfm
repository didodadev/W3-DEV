<cfsetting showdebugoutput="no">
<cfquery name="get_camp_operation_rows" datasource="#dsn3#">
	SELECT C.*,P.TAX,ISNULL(P.OTV,0) OTV FROM CAMPAIGN_OPERATION C,PRODUCT P WHERE C.CAMP_ID = #attributes.camp_id# AND C.PRODUCT_ID = P.PRODUCT_ID
</cfquery>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 ORDER BY MONEY DESC
</cfquery>
<cfform name="add_camp_operation" action="#request.self#?fuseaction=campaign.emptypopup_upd_campaign_operation_rows" method="post" onsubmit="return unformat_fields();"> 
	<input type="hidden" name="camp_id" id="camp_id" value="<cfoutput>#attributes.camp_id#</cfoutput>">
	<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_camp_operation_rows.recordcount#</cfoutput>">
	<cf_grid_list id="table1">
		<thead>
			<tr>
				<cfset colspan_ = 2>
				<cfset colspan_2 = 7>
				<cfset colspan_3 = 2>
				<cfset colspan_4 = 2>
				<cfif attributes.is_operation_show_kdv eq 1>
					<cfset colspan_2 = colspan_2 + 1>
				</cfif>
				<cfif attributes.is_operation_show_otv eq 1>
					<cfset colspan_2 = colspan_2 + 1>
				</cfif>
				<cfif attributes.is_operation_show_isk_amount eq 1>
					<cfset colspan_4 = colspan_4 + 2>
				</cfif>
				<cfif attributes.is_operation_show_kdv_amount eq 1>
					<cfset colspan_ = colspan_ + 2>
				</cfif>
				<th colspan="<cfoutput>#colspan_2#</cfoutput>"></th>
				<th colspan="<cfoutput>#colspan_4#</cfoutput>" align="center"><cf_get_lang dictionary_id='57641.İskonto'></th>
				<th colspan="<cfoutput>#colspan_#</cfoutput>" align="center"><cf_get_lang dictionary_id='57673.Tutar'></th>
				<cfif colspan_3 gt 0>
					<th colspan="<cfoutput>#colspan_3#</cfoutput>"></th>
				</cfif>
				<th colspan="3" align="center"><cf_get_lang dictionary_id='49701.Tekrar'></th>
			</tr>
			<tr>
				<th width="20"><a onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>			
				<th><cf_get_lang dictionary_id='57657.Ürün'></th>
				<th><cf_get_lang dictionary_id="58516.Ödeme Yöntemi"> <cfif attributes.is_paymethod_kontrol eq 1>*</cfif></th>
				<th><cf_get_lang dictionary_id='57635.Miktar'></th>
				<th><cf_get_lang dictionary_id='57636.Birim'></th>
				<cfif attributes.is_operation_show_kdv eq 1>
					<th><cf_get_lang dictionary_id='57639.KDV'></th>
				</cfif>
				<cfif attributes.is_operation_show_otv eq 1>
					<th><cf_get_lang dictionary_id='58021.ÖTV'></th>
				</cfif>
				<th><cf_get_lang dictionary_id='58084.Fiyat'></th>
				<th><cf_get_lang dictionary_id='57673.Tutar'></th>
				<th title="<cf_get_lang dictionary_id='57641.İskonto'>">%</th>
				<th title="<cf_get_lang dictionary_id='57446.Kampanya'> <cf_get_lang dictionary_id='57641.İskonto'>">K.İsk.%</th>
				<cfif attributes.is_operation_show_isk_amount eq 1>
					<th title="<cf_get_lang dictionary_id='57673.Tutar'> <cf_get_lang dictionary_id='57641.İskonto'>"><cf_get_lang dictionary_id="57673.Tutar"></th>
					<th title="<cf_get_lang dictionary_id='54706.Kampanya Tutar İskontosu'>"><cf_get_lang dictionary_id="54706.Kampanya Tutar İskontosu"></th> 
				</cfif>
				<th><cf_get_lang dictionary_id="58083.Net"></th>
				<th><cf_get_lang dictionary_id='57446.Kampanya'></th>
				<cfif attributes.is_operation_show_kdv_amount eq 1>
					<th><cf_get_lang dictionary_id="58716.KDV'li"></th>
					<th><cf_get_lang dictionary_id="58716.KDV'li"> <cf_get_lang dictionary_id='57446.Kampanya'></th>
				</cfif>
				<th><cf_get_lang dictionary_id='57489.Para Br'></th>
				<th><cf_get_lang dictionary_id='57648.Kur'></th>
				<th><cf_get_lang dictionary_id= '49702.Periyot'></th>
				<th><cf_get_lang dictionary_id='57446.Kampanya'></th>
				<th><cf_get_lang dictionary_id='57492.Toplam'></th>
			</tr>
		</thead>			
		<cfif get_camp_operation_rows.recordcount>
			<cfset pay_method_id_list=''>
			<cfset card_pay_method_id_list=''>
			<cfoutput query="get_camp_operation_rows">
				<cfif len(paymethod_id) and not listfind(pay_method_id_list,paymethod_id)>
					<cfset pay_method_id_list=listappend(pay_method_id_list,paymethod_id)>
				</cfif>
				<cfif len(card_paymethod_id) and not listfind(card_pay_method_id_list,card_paymethod_id)>
					<cfset card_pay_method_id_list=listappend(card_pay_method_id_list,card_paymethod_id)>
				</cfif>
			</cfoutput>
			<cfif len(pay_method_id_list)>
				<cfset pay_method_id_list=listsort(pay_method_id_list,"numeric","ASC",",")>
				<cfquery name="get_paymethod_detail" datasource="#dsn#">
					SELECT PAYMETHOD,PAYMETHOD_ID FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID IN (#pay_method_id_list#) ORDER BY PAYMETHOD_ID
				</cfquery>
				<cfset pay_method_id_list = valuelist(get_paymethod_detail.PAYMETHOD_ID)>
			</cfif>
			<cfif len(card_pay_method_id_list)>
				<cfset card_pay_method_id_list=listsort(card_pay_method_id_list,"numeric","ASC",",")>
				<cfquery name="get_card_paymethod_detail" datasource="#dsn3#">
					SELECT CARD_NO,PAYMENT_TYPE_ID FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID IN (#card_pay_method_id_list#) ORDER BY PAYMENT_TYPE_ID
				</cfquery>
				<cfset card_pay_method_id_list = valuelist(get_card_paymethod_detail.PAYMENT_TYPE_ID)>
			</cfif>
			<cfoutput query="get_camp_operation_rows"> 
				<tr id="frm_row#currentrow#">
					<td>
						<cfif attributes.is_operation_show_kdv eq 0>
							<input type="hidden" name="kdv_rate#currentrow#" id="kdv_rate#currentrow#" value="#get_camp_operation_rows.tax#" readonly style="width:40px;">
						</cfif>
						<cfif attributes.is_operation_show_otv eq 0>
							<input type="hidden" name="otv_rate#currentrow#" id="otv_rate#currentrow#" value="#get_camp_operation_rows.otv#" readonly style="width:40px;">
						</cfif>
						<input type="hidden" name="wrk_row_id#currentrow#" id="wrk_row_id#currentrow#" value="#wrk_row_id#">
						<input type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#">
						<a style="cursor:pointer" onClick="sil(#currentrow#);"><i class="fa fa-minus" alt="Sil"></i></a> 
					</td>			
					<td>
						<div class="input-group">
							<input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#product_id#">
							<input type="text" name="product#currentrow#" id="product#currentrow#" value="#product_name#">
							<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_product('#currentrow#');"></span>
						</div>
					</td>
					<td nowrap>
						<div class="input-group">
							<input type="hidden" name="card_paymethod_id#currentrow#" value="#card_paymethod_id#">
							<input type="hidden" name="paymethod_id#currentrow#" value="#paymethod_id#"><input type="text" name="paymethod#currentrow#" value="<cfif len(paymethod_id)>#get_paymethod_detail.paymethod[listfind(pay_method_id_list,paymethod_id,',')]#<cfelseif len(card_paymethod_id)>#get_card_paymethod_detail.card_no[listfind(card_pay_method_id_list,card_paymethod_id,',')]#</cfif>" maxlength="50">
							<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_paymethods&field_id=add_camp_operation.paymethod_id#currentrow#&field_name=add_camp_operation.paymethod#currentrow#&field_card_payment_id=add_camp_operation.card_paymethod_id#currentrow#&field_card_payment_name=add_camp_operation.paymethod#currentrow#');"></span>
						</div>

					</td>
					<td><cfset my_amount_ = replace(amount,'.',',')>
						<input type="text" name="amount#currentrow#"  id="amount#currentrow#" value="#my_amount_#" onBlur="fiyat_hesapla('#currentrow#');isNumber(this);" class="moneybox" style="width:40px;" onKeyup="isNumber(this);">  
					</td>
					<td>
						<input type="hidden" name="unit_id#currentrow#" id="unit_id#currentrow#" value="<cfif isdefined('unit_id')>#unit_id#</cfif>">
						<input type="text" name="unit_name#currentrow#" id="unit_name#currentrow#" value="#unit#" readonly style="width:40px;">  
					</td>
					<cfif attributes.is_operation_show_kdv eq 1>
						<td>
							<input type="text" name="kdv_rate#currentrow#" id="kdv_rate#currentrow#" value="#get_camp_operation_rows.tax#" readonly style="width:40px;">
						</td>
					</cfif>
					<cfif attributes.is_operation_show_otv eq 1>
						<td>
							<input type="text" name="otv_rate#currentrow#" id="otv_rate#currentrow#" value="#get_camp_operation_rows.otv#" readonly style="width:40px;">
						</td>
					</cfif>
					<td><input type="text" name="price#currentrow#" id="price#currentrow#" value="#tlformat(price)#" onKeyUp="return(FormatCurrency(this,event));" class="moneybox" onBlur="fiyat_hesapla('#currentrow#');" style="width:50px;"></td>
					<td><input type="text" name="total_price#currentrow#" id="total_price#currentrow#" value="#tlformat(total_price)#" class="moneybox" onKeyUp="return(FormatCurrency(this,event));" readonly style="width:50px;"></td>
					<td><input type="text" name="discount#currentrow#" id="discount#currentrow#" value="#discount#" class="moneybox" onBlur="fiyat_hesapla('#currentrow#');" onKeyUp="return(FormatCurrency(this,event));" style="width:40px;" maxlength="3"></td>
					<td><input type="text" name="k_discount#currentrow#" id="k_discount#currentrow#" value="#k_discount#" class="moneybox" onBlur="fiyat_hesapla('#currentrow#');" onKeyUp="return(FormatCurrency(this,event));" style="width:50px;" maxlength="3"></td> 
					<cfif attributes.is_operation_show_isk_amount eq 1>
						<td><input type="text" name="discount_amount#currentrow#" id="discount_amount#currentrow#" value="<cfif len(discount_amount)>#tlformat(discount_amount)#<cfelse>0</cfif>" class="moneybox" onBlur="fiyat_hesapla('#currentrow#');" onKeyUp="return(FormatCurrency(this,event));" style="width:40px;"></td>
						<td><input type="text" name="k_discount_amount#currentrow#" id="k_discount_amount#currentrow#" value="<cfif len(k_discount_amount)>#tlformat(k_discount_amount)#<cfelse>0</cfif>" class="moneybox" onBlur="fiyat_hesapla('#currentrow#');" onKeyUp="return(FormatCurrency(this,event));" style="width:50px;"></td> 
					</cfif>
					<td><cfif not len(discount)>
							<cfset nettotal = total_price>
						<cfelse>
							<cfset nettotal = total_price - (total_price * discount / 100)>
						</cfif>
						<cfif len(discount_amount)><cfset nettotal = nettotal -discount_amount> </cfif>
						<input type="text" name="nettotal_price#currentrow#" id="nettotal_price#currentrow#" value="#tlformat(nettotal)#" class="moneybox" onKeyUp="return(FormatCurrency(this,event));" readonly style="width:60px;">
					</td>
					<td><cfif not len(k_discount)>
							<cfset k_nettotal = total_price>
						<cfelse>
							<cfset k_nettotal = total_price - (total_price * k_discount / 100)>
						</cfif> 
						<cfif len(k_discount_amount)><cfset k_nettotal = k_nettotal -k_discount_amount> </cfif>
						<input type="text" name="k_nettotal_price#currentrow#" id="k_nettotal_price#currentrow#" value="#tlformat(k_nettotal)#" class="moneybox" onKeyUp="return(FormatCurrency(this,event));" readonly style="width:100px;">
					</td>
					<cfif attributes.is_operation_show_kdv_amount eq 1>
						<td>
							<cfset nettotal_kdv = nettotal*tax/100>
							<cfset nettotal_otv = nettotal*otv/100>
							<input type="text" name="kdv_nettotal_price#currentrow#" id="kdv_nettotal_price#currentrow#" value="#tlformat(nettotal+nettotal_kdv+nettotal_otv)#" class="moneybox" onKeyUp="return(FormatCurrency(this,event));" readonly style="width:60px;">
						</td>
						<td>
							<cfset k_nettotal_kdv = k_nettotal*tax/100>
							<cfset k_nettotal_otv = k_nettotal*otv/100>
							<input type="text" name="kdv_k_nettotal_price#currentrow#" id="kdv_k_nettotal_price#currentrow#" value="#tlformat(k_nettotal+k_nettotal_kdv+k_nettotal_otv)#" class="moneybox" onKeyUp="return(FormatCurrency(this,event));" readonly style="width:100px;">
						</td>
					</cfif>
					<td><select name="money#currentrow#" id="money#currentrow#" style="width:75px;">
						<cfloop query="get_money">
							<option value="#get_money.money#" <cfif get_money.money is get_camp_operation_rows.currency>selected</cfif>>#get_money.money#</option>
						</cfloop>
						</select> 
					</td>
					<td>
						<input type="text" name="row_rate#currentrow#" id="row_rate#currentrow#" value="#tlformat(rate,4)#" class="moneybox" onKeyUp="return(FormatCurrency(this,event,4));" style="width:50px;">
					</td>
					<td><select name="period#currentrow#" id="period#currentrow#" style="width:75px;">
							<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
							<option value="1" <cfif get_camp_operation_rows.period eq 1>selected</cfif>><cf_get_lang dictionary_id='58932.Aylık'></option>
							<option value="2" <cfif get_camp_operation_rows.period eq 2>selected</cfif>>2 <cf_get_lang dictionary_id='58932.Aylık'></option>
							<option value="3" <cfif get_camp_operation_rows.period eq 3>selected</cfif>>3 <cf_get_lang dictionary_id='58932.Aylık'></option>
							<option value="6" <cfif get_camp_operation_rows.period eq 6>selected</cfif>>6 <cf_get_lang dictionary_id='58932.Aylık'></option>
							<option value="12" <cfif get_camp_operation_rows.period eq 12>selected</cfif>><cf_get_lang dictionary_id='29400.Yıllık'></option>
						</select>
					</td>
					<td><input type="text" name="free_repeat_number#currentrow#" id="free_repeat_number#currentrow#" value="#free_repeat_number#" style="width:65px;" class="moneybox" onKeyup="isNumber(this);" onblur="isNumber(this);"></td>
					<td><input type="text" name="repeat_number#currentrow#" id="repeat_number#currentrow#" value="#repeat_number#" style="width:50px;" class="moneybox" onKeyup="isNumber(this);" onblur="isNumber(this);"></td>
				</tr>
			</cfoutput>
		</cfif>
	</cf_grid_list>    
	<cf_box_footer>
		<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
	</cf_box_footer>
</cfform>	
<script type="text/javascript">
	row_count=<cfoutput>#get_camp_operation_rows.recordcount#</cfoutput>;
	function kontrol()
	{
		control_row = 0;
		paymethod_id_list = '';
		card_paymethod_id_list = '';
		for(r=1;r<=row_count;r++)
		{
			if(document.getElementById("row_kontrol"+r).value == 1)
			{
				control_row = control_row+1;
				if(document.getElementById("product_id"+r).value == '' || document.getElementById("product"+r).value == '')
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57657.Ürün'>! <cf_get_lang dictionary_id='58508.Satır'>:"+control_row);
					return false;
				}
				<cfif attributes.is_paymethod_kontrol eq 1><!--- Ödeme yöntemleri zorunlu ise --->
					if((document.getElementById("card_paymethod_id"+r).value == '' && document.getElementById("paymethod_id"+r).value == '') || document.getElementById("paymethod"+r).value == '')
					{
						alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58516.Ödeme Yöntemi'>! <cf_get_lang dictionary_id='58508.Satır'>:"+control_row);
						return false;
					}
				</cfif>
				if(document.getElementById("card_paymethod_id"+r).value != '' && document.getElementById("paymethod"+r).value != '')
				{
					if(! list_find(card_paymethod_id_list,document.getElementById("card_paymethod_id"+r).value))
						card_paymethod_id_list+=document.getElementById("card_paymethod_id"+r).value+',';
				}
				else if(document.getElementById("paymethod_id"+r).value != '' && document.getElementById("paymethod"+r).value != '')
				{
					if(! list_find(paymethod_id_list,document.getElementById("paymethod_id"+r).value))
						paymethod_id_list+=document.getElementById("paymethod_id"+r).value+',';
				}
				if(document.getElementById("discount"+r).value >100)
				{
					alert("<cf_get_lang dictionary_id='49704.Lütfen Uygun İskonto Değeri Giriniz'> ! <cf_get_lang dictionary_id='58508.Satır'> :"+control_row);
					return false;
				}
				if(parseInt(document.getElementById("free_repeat_number"+r).value) > parseInt(document.getElementById("repeat_number"+r).value))
				{
					alert("<cf_get_lang dictionary_id='49705.Kampanya Tekrarı Toplam Tekrar Sayısından Fazla Olamaz'>! <cf_get_lang dictionary_id='58508.Satır'>:"+control_row);
					return false;
				}
			}
		}
		<cfif attributes.is_paymethod_value_kontrol eq 1><!--- Ödeme yöntemleri farklı seçilemez ise --->
			if(card_paymethod_id_list != '')
			{
				card_paymethod_id_list = card_paymethod_id_list.substr(0,(card_paymethod_id_list.length-1));
			}
			if(paymethod_id_list != '')
			{
				paymethod_id_list = paymethod_id_list.substr(0,(paymethod_id_list.length-1));
			}
			total_len = parseFloat(list_len(paymethod_id_list)) + parseFloat(list_len(card_paymethod_id_list));
			if(total_len > 1)
			{
				alert("<cf_get_lang dictionary_id='49706.Satırlarda Farklı Ödeme Yöntemleri Seçemezsiniz'> !");
				return false;
			}
		</cfif>
	}	
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;
	
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
	
		document.getElementById("record_num").value=row_count;
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="wrk_row_id'+row_count+'" id="wrk_row_id'+row_count+'" value="'+js_create_unique_id()+'"><input type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><a style="cursor:pointer" onclick="sil(' + row_count + ');"><i class="fa fa-minus" alt="Sil"></i></a>';				
		<cfif attributes.is_operation_show_kdv eq 0>
			newCell.innerHTML += '<input type="hidden" name="kdv_rate' + row_count +'" id="kdv_rate' + row_count +'" value="" readonly style="width:40px;">';
		</cfif>
		<cfif attributes.is_operation_show_otv eq 0>
			newCell.innerHTML += '<input type="hidden" name="otv_rate' + row_count +'" id="otv_rate' + row_count +'" value="" readonly style="width:40px;">';
		</cfif>
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'"><input type="hidden" name="product_id' + row_count +'" id="product_id' + row_count +'"><div class="input-group"><input type="text" name="product' + row_count +'" id="product' + row_count +'"><span class="input-group-addon icon-ellipsis" onclick="javascript:pencere_ac_product(' + row_count + ');"></span></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="card_paymethod_id' + row_count +'" id="card_paymethod_id' + row_count +'" value=""><input type="hidden" name="paymethod_id' + row_count +'" id="paymethod_id' + row_count +'" value=""><div class="input-group"><input type="text" name="paymethod' + row_count +'" id="paymethod' + row_count +'" maxlength="50" value=""><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('+"'<cfoutput>#request.self#?fuseaction=objects.popup_paymethods</cfoutput>&field_id=add_camp_operation.paymethod_id" + row_count + "&field_name=add_camp_operation.paymethod" + row_count + "&field_card_payment_id=add_camp_operation.card_paymethod_id" + row_count + "&field_card_payment_name=add_camp_operation.paymethod" + row_count + "');"+'"></span></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="amount' + row_count +'" id="amount' + row_count +'" value="" class="moneybox" onBlur="fiyat_hesapla(' + row_count + ');" style="width:40px;" onKeyup="isNumber(this);" onblur="isNumber(this);">';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="unit_id' + row_count +'" id="unit_id' + row_count +'"><input type="text" name="unit_name' + row_count +'" id="unit_name' + row_count +'" value="" readonly style="width:40px;">';
		
		<cfif attributes.is_operation_show_kdv eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="kdv_rate' + row_count +'" id="kdv_rate' + row_count +'"value="" readonly style="width:40px;">';
		</cfif>
		
		<cfif attributes.is_operation_show_otv eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="otv_rate' + row_count +'" id="otv_rate' + row_count +'" value="" readonly style="width:40px;">';
		</cfif>		
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="price' + row_count +'" id="price' + row_count +'" value="" onBlur="fiyat_hesapla(' + row_count + ');" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:50px;">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="total_price' + row_count +'" id="total_price' + row_count +'" value="" onkeyup="return(FormatCurrency(this,event));" class="moneybox" readonly style="width:50px;">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="discount' + row_count +'" id="discount' + row_count +'" value="" onBlur="fiyat_hesapla(' + row_count + ');" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:40px;" maxlength="3">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="k_discount' + row_count +'" id="k_discount' + row_count +'" value="" onBlur="fiyat_hesapla(' + row_count + ');" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:50px;" maxlength="3">';
		
		<cfif attributes.is_operation_show_isk_amount eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="discount_amount' + row_count +'" id="discount_amount' + row_count +'" value="" onBlur="fiyat_hesapla(' + row_count + ');" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:40px;">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="k_discount_amount' + row_count +'" id="k_discount_amount' + row_count +'" value="" onBlur="fiyat_hesapla(' + row_count + ');" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:50px;">';
		</cfif>
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="nettotal_price' + row_count +'" id="nettotal_price' + row_count +'" value="" onkeyup="return(FormatCurrency(this,event));" class="moneybox" readonly style="width:60px;">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="k_nettotal_price' + row_count +'" id="k_nettotal_price' + row_count +'" value="" onkeyup="return(FormatCurrency(this,event));" class="moneybox" readonly style="width:100px;">';
		
		<cfif attributes.is_operation_show_kdv_amount eq 1>		
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="kdv_nettotal_price' + row_count +'" id="kdv_nettotal_price' + row_count +'" value="" onkeyup="return(FormatCurrency(this,event));" class="moneybox"  readonly style="width:60px;">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="kdv_k_nettotal_price' + row_count +'" id="kdv_k_nettotal_price' + row_count +'" value="" onkeyup="return(FormatCurrency(this,event));" class="moneybox" readonly style="width:100px;">';
		</cfif>
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="money' + row_count +'" id="money' + row_count +'" style="width:75px;"><cfoutput query="get_money"><option value="#get_money.money#">#get_money.money#</option></cfoutput></select>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="row_rate' + row_count +'" id="row_rate' + row_count +'" value="" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox" style="width:50px;">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="period' + row_count +'" id="period' + row_count +'" style="width:75px;"><option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option><option value="1"><cf_get_lang dictionary_id="58932.Aylık"></option><option value="2">2 <cf_get_lang dictionary_id="58932.Aylık"></option><option value="3">3 <cf_get_lang dictionary_id="58932.Aylık"></option><option value="6">6 <cf_get_lang dictionary_id="58932.Aylık"></option><option value="12"><cf_get_lang dictionary_id="29400.Yıllık"></option></select>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="free_repeat_number' + row_count +'" id="free_repeat_number' + row_count +'" value="" class="moneybox" style="width:65px;" onKeyup="isNumber(this);" onblur="isNumber(this);">';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="repeat_number' + row_count +'" id="repeat_number' + row_count +'" value="" class="moneybox" style="width:50px;" onKeyup="isNumber(this);" onblur="isNumber(this);">';
	}
	
	function sil(sy)
	{
		var my_element=document.getElementById("row_kontrol"+sy);		
		my_element.value=0;
		var my_element=document.getElementById("frm_row"+sy);
		my_element.style.display="none";
	}
	function pencere_ac_product(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_price_unit&field_otv=add_camp_operation.otv_rate'+ no +'&field_tax=add_camp_operation.kdv_rate'+ no +'&field_id=add_camp_operation.product_id'+ no +'&field_name=add_camp_operation.product'+ no +'&field_amount=add_camp_operation.amount'+ no +'&field_unit_id=add_camp_operation.unit_id'+ no+'&field_unit=add_camp_operation.unit_name'+ no+'&field_price=add_camp_operation.price'+ no+'&field_total_price=add_camp_operation.total_price'+ no+'&field_money=add_camp_operation.money'+ no);
	}	
	function fiyat_hesapla(satir)
	{
		if(document.getElementById("price"+satir).value.length != 0 && document.getElementById("amount"+satir).value.length != 0)
		{
			document.getElementById("total_price" + satir).value =  filterNum(document.getElementById("price"+satir).value) * filterNum(document.getElementById("amount"+satir).value);
			document.getElementById("total_price" + satir).value = commaSplit(document.getElementById("total_price" + satir).value);
			//tutar
			<cfif attributes.is_operation_show_isk_amount eq 1>
				document.getElementById("nettotal_price" + satir).value =  filterNum(document.getElementById("total_price"+satir).value)- (filterNum(document.getElementById("discount_amount"+satir).value)) - (filterNum(document.getElementById("total_price"+satir).value) * filterNum(document.getElementById("discount"+satir).value) / 100);
			<cfelse>
				document.getElementById("nettotal_price" + satir).value =  filterNum(document.getElementById("total_price"+satir).value) - (filterNum(document.getElementById("total_price"+satir).value) * filterNum(document.getElementById("discount"+satir).value) / 100);
			</cfif>
			document.getElementById("nettotal_price" + satir).value = commaSplit(document.getElementById("nettotal_price" + satir).value);
			new_price_kdv = (filterNum(document.getElementById("nettotal_price"+satir).value) * filterNum(document.getElementById("kdv_rate"+satir).value) / 100);
			new_price_otv = (filterNum(document.getElementById("nettotal_price"+satir).value) * filterNum(document.getElementById("otv_rate"+satir).value) / 100);
			<cfif attributes.is_operation_show_kdv_amount eq 1>
				document.getElementById("kdv_nettotal_price" + satir).value = commaSplit(filterNum(document.getElementById("nettotal_price"+satir).value)+new_price_kdv+new_price_otv);
			</cfif>
			//kampanya tutarlar
			<cfif attributes.is_operation_show_isk_amount eq 1>
				document.getElementById("k_nettotal_price" + satir).value =  filterNum(document.getElementById("total_price"+satir).value)- (filterNum(document.getElementById("k_discount_amount"+satir).value)) - (filterNum(document.getElementById("total_price"+satir).value) * filterNum(document.getElementById("k_discount"+satir).value) / 100);
			<cfelse>
				document.getElementById("k_nettotal_price" + satir).value =  filterNum(document.getElementById("total_price"+satir).value) - (filterNum(document.getElementById("total_price"+satir).value) * filterNum(document.getElementById("k_discount"+satir).value) / 100);
			</cfif>
			document.getElementById("k_nettotal_price" + satir).value = commaSplit(document.getElementById("k_nettotal_price" + satir).value);
			new_price_kdv = (filterNum(document.getElementById("k_nettotal_price"+satir).value) * filterNum(document.getElementById("kdv_rate"+satir).value) / 100);
			new_price_otv = (filterNum(document.getElementById("k_nettotal_price"+satir).value) * filterNum(document.getElementById("otv_rate"+satir).value) / 100);
			<cfif attributes.is_operation_show_kdv_amount eq 1>
				document.getElementById("kdv_k_nettotal_price" + satir).value = commaSplit(filterNum(document.getElementById("k_nettotal_price"+satir).value)+new_price_kdv+new_price_otv);
			</cfif>
		}
		return true;
	}
	function unformat_fields()
	{
		for(r=1;r<=row_count;r++)
		{
			if(document.getElementById("row_kontrol"+r).value == 1)
			{
				fiyat_hesapla(r);
				<cfif attributes.is_operation_show_isk_amount eq 1>	
					document.getElementById("discount_amount"+r).value = filterNum(document.getElementById("discount_amount"+r).value);
					document.getElementById("k_discount_amount"+r).value = filterNum(document.getElementById("k_discount_amount"+r).value);
				</cfif>
				document.getElementById("amount"+r).value = filterNum(document.getElementById("amount"+r).value);
				document.getElementById("price"+r).value = filterNum(document.getElementById("price"+r).value);
				document.getElementById("total_price"+r).value = filterNum(document.getElementById("total_price"+r).value);
				document.getElementById("row_rate"+r).value = filterNum(document.getElementById("row_rate"+r).value,4);
			}
		}
	}
</script>   
