<cf_get_lang_set module_name="cheque">
<cfquery name="get_money" datasource="#dsn2#">
	SELECT * FROM SETUP_MONEY
</cfquery>
<cfinclude template="../query/get_voucher_cashes.cfm">
<cf_popup_box title="#getLang('cheque',250)#"><!--- <cf_get_lang no ='250.Yeni Ödeme Planı'> --->
	<cfform name="payment_with_voucher" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_add_payment_with_voucher">
		<cfif isdefined("attributes.voucher_list")>
			<input type="hidden" name="voucher_list" id="voucher_list" value="<cfoutput>#attributes.voucher_list#</cfoutput>">
		</cfif>
		<input type="hidden" name="payroll_revenue_date" id="payroll_revenue_date" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
		<input type="hidden" name="company_id" id="company_id" value="<cfif isDefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
		<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isDefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>"> 
		<cfset belge_no = get_cheque_no(belge_tipi:'voucher_payroll')>
		<input type="hidden" name="payroll_no" id="payroll_no" value="<cfoutput>#belge_no#</cfoutput>">
		<cfset belge_no = get_cheque_no(belge_tipi:'voucher_payroll',belge_no:belge_no+1)>
		<div class="row"> 
			<div class="col col-12 uniqueRow"> 		
				<div class="row formContent">
					<div class="row">
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1">
							<div class="form-group">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no ='280.İşlem'> *</label>
								<div class="col col-9 col-xs-12"> 
									<cf_workcube_process_cat slct_width="140">
								</div>
							</div>
							<div class="form-group">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='108.Kasa'></label>
								<div class="col col-9 col-xs-12"> 
									<select name="cash_id" id="cash_id" style="width:140px;">
										<cfoutput query="get_cashes">
											<option value="#cash_id#;#branch_id#">#cash_name#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='1737.Toplam Tutar'> *</label>
								<div class="col col-9 col-xs-12"> 
									<input type="text" name="net_total" id="net_total" style="width:140px;" value="<cfif isdefined('attributes.net_total')><cfoutput>#tlformat(attributes.net_total)#</cfoutput></cfif>" readonly class="moneybox">
									<input type="hidden" name="gross_total" id="gross_total" style="width:140px;" value="0" readonly class="moneybox">
								</div>
							</div>
							<div class="form-group">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='449.Ortalama Vade'> *</label>
								<div class="col col-9 col-xs-12"> 
									<cfif isdefined('attributes.due_day')>
										<cfif not len(attributes.due_day)>
											<cfset attributes.due_day = 0>
										</cfif>
										<cfset avg_due_date = dateadd('d',attributes.due_day,now())>
										<input type="text" name="avg_due_date" id="avg_due_date" style="width:140px;" value="<cfoutput>#dateformat(avg_due_date,dateformat_style)#</cfoutput>" readonly>
									</cfif>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-3 col-xs-12"><cf_get_lang no ='252.Vade Başlangıç Tarihi'> *</label>
								<div class="col col-9 col-xs-12"> 
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang no ='253.Vade Başlangıç Girmelisiniz'> !</cfsavecontent>
										<cfinput value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#" type="text" name="revenue_start_date" style="width:140px;" onBlur="change_due_date();">
										<span class="input-group-addon"><cf_wrk_date_image date_field="revenue_start_date" call_function="change_due_date"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no ='1104.Ödeme Yontemi'> *</label>
								<div class="col col-9 col-xs-12"> 
									<div class="input-group">
										<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
										<input type="hidden" name="commission_rate" id="commission_rate" value="">
										<input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="">
										<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
										<input type="hidden" name="basket_due_value" id="basket_due_value" value="">
										<input type="text" name="paymethod" id="paymethod" value="" readonly style="width:140px;">
										<cfset card_link="&field_card_payment_id=payment_with_voucher.card_paymethod_id&field_card_payment_name=payment_with_voucher.paymethod&field_commission_rate=payment_with_voucher.commission_rate&field_paymethod_vehicle=payment_with_voucher.paymethod_vehicle&field_due_month=payment_with_voucher.due_month">
										<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=payment_with_voucher.paymethod_id&field_name=payment_with_voucher.paymethod&field_dueday=payment_with_voucher.basket_due_value&field_duedate_rate=payment_with_voucher.due_value&function_name=add_voucher_row#card_link#</cfoutput>','medium');" title="<cf_get_lang_main no ='1104.Ödeme Yontemi'>"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-3 col-xs-12"><cf_get_lang no ='254.Taksit Sayısı'> *</label>
								<div class="col col-9 col-xs-12"> 
									<input type="text" name="due_month" id="due_month" value="0" style="width:140px" onKeyUp="isNumber(this);" class="moneybox" onBlur="if(this.value.length == 0 || filterNum(this.value)==0) this.value = 0;add_voucher_row();">
								</div>
							</div>
							<div class="form-group">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='1089.Vade Farkı'></label>
								<div class="col col-9 col-xs-12"> 
									<input type="text" name="due_value" id="due_value" value="0" style="width:140px" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="add_voucher_row();">
								</div>
							</div>
						</div>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="2">
							<div class="form-group">
								<label class="col col-12 bold"><cf_get_lang no ='256.Taksitler'></label>
							</div>
							<div class="form-group">
								<div class="col col-12"> 
									<table name="table1" id="table1" cellspacing="1" cellpadding="2" border="0" class="color-row">
										<input type="hidden" name="record_num" id="record_num" value="0">
										<tr class="color-header">
											<td width="10" class="color-row" align="center"><a style="cursor:pointer" onClick="add_row();" title="Ekle"><img  src="images/plus_list.gif" alt="<cf_get_lang no ='256.Taksitler'>" border="0"></a></td>
											<td class="form-title" width="90"><cf_get_lang_main no ='261.Tutar'></td>
											<td class="form-title" width="90"><cf_get_lang_main no='469.Vade Tarihi'></td>
										</tr>
									</table>
								</div>
							</div>
							<div class="from-group">
								<div class="col col-12">
									<table>
										<tr>
                                        	<td class="txtbold"><cf_get_lang no ='257.Senet Toplam'></td>
											<td width="135"><input type="text" name="total_voucher_value" id="total_voucher_value" value="0" style="width:90px;" class="moneybox" readonly></td>
										</tr>
									</table>
								</div>
							</div>
						</div>
					</div>	
					<div class="row formContentFooter">	
						<div class="col col-12"><cf_workcube_buttons is_upd='0' add_function='kontrol()'></div> 
					</div>
				</div>
			</div>
		</div>
	</cfform>
<!---</cf_popup_box>--->
<script type="text/javascript">
	function kontrol()
	{
		if (!chk_process_cat('payment_with_voucher')) return false;
		if(!check_display_files('payment_with_voucher')) return false;
		record_exist = 0;
		for(r=1;r<=payment_with_voucher.record_num.value;r++)
		{
			if(eval("document.payment_with_voucher.row_kontrol"+r).value == 1)
			{
				record_exist=1;
				if ((eval("document.payment_with_voucher.voucher_value"+r).value == "") || (eval("document.payment_with_voucher.voucher_value"+r).value ==0))
				{ 
					alert ("<cf_get_lang no ='258.Senet Tutarı Girmelisiniz '>!");
					return false;
				}
				if (eval("document.payment_with_voucher.due_date"+r).value == "")
				{ 
					alert ("<cf_get_lang no ='259.Vade Tarihi Girmelisiniz'> !");
					return false;
				}
			}
		}
		if (record_exist == 0) 
		{
			alert("<cf_get_lang no ='260.Ödeme Planı İçin Enaz Bir Senet Girilmelidir'> !");
			return false;
		}
		toplam_tutar = parseFloat(filterNum(payment_with_voucher.gross_total.value));
		toplam_senet_tutar = parseFloat(filterNum(payment_with_voucher.total_voucher_value.value));
		if (toplam_senet_tutar != toplam_tutar) 
		{
			alert("<cf_get_lang no ='261.İşlem Tutarı İle Senetlerin Toplam Tutarı Eşit Olmalı'> !");
			return false;
		}
	}
	row_count=0;
	function sil(sy)
	{
		var my_element=eval("payment_with_voucher.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		toplam_voucher_hesapla();
	}
	function add_row(total,due_date)
	{
		if(payment_with_voucher.paymethod_id.value == '')
		{
			alert("<cf_get_lang no ='262.Önce Ödeme Yöntemi Seçmelisiniz'> !");
			return false;
		}
		else
		{
			if(total == undefined)
			{
				row_count++;
				var newRow;
				var newCell;
				newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);	
				newRow.setAttribute("name","frm_row" + row_count);
				newRow.setAttribute("id","frm_row" + row_count);		
				newRow.setAttribute("NAME","frm_row" + row_count);
				newRow.setAttribute("ID","frm_row" + row_count);		
				newRow.className = 'color-row';
				document.getElementById('record_num').value=row_count;
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol' + row_count +'"><a href="javascript://" onclick="sil(' + row_count + ',1);"><img  src="images/delete_list.gif" alt="Sil" border="0"></a>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="hidden" name="voucher_system_value' + row_count +'" value="0"><input type="text" name="voucher_value' + row_count +'" value="0" style="width:100%;"  onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="toplam_voucher_hesapla();">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("id","due_date" + row_count + "_td");
				newCell.innerHTML = '<input type="text" name="due_date' + row_count +'" class="text" maxlength="10" style="width:70px;" value="" onBlur="change_due_date('+row_count+');">';
				wrk_date_image('due_date' + row_count,'change_due_date('+row_count+')');
			}
			else
			{
				row_count++;
				var newRow;
				var newCell;
				newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);	
				newRow.setAttribute("name","frm_row" + row_count);
				newRow.setAttribute("id","frm_row" + row_count);		
				newRow.setAttribute("NAME","frm_row" + row_count);
				newRow.setAttribute("ID","frm_row" + row_count);		
				newRow.className = 'color-row';
				document.getElementById('record_num').value=row_count;
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol' + row_count +'"><a href="javascript://" onclick="sil(' + row_count + ',1);"><img  src="images/delete_list.gif" alt="Sil" border="0"></a>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="hidden" name="voucher_system_value' + row_count +'" value="'+total+'"><input type="text" name="voucher_value' + row_count +'" value="'+total+'" style="width:100%;" onkeyup="return(FormatCurrency(this,event));" class="moneybox" onBlur="toplam_voucher_hesapla();">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("id","due_date" + row_count + "_td");
				newCell.innerHTML = '<input type="text" name="due_date' + row_count +'" class="text" maxlength="10" style="width:70px;" value="'+due_date+'" onBlur="change_due_date('+row_count+');">';
				wrk_date_image('due_date' + row_count,'change_due_date('+row_count+')');
			}
		}
	}
	function add_voucher_row()
	{	
		if(payment_with_voucher.paymethod_id.value == '')
		{
			alert("<cf_get_lang no ='262.Önce Ödeme Yöntemi Seçmelisiniz'> !");
			return false;
		}
		else
		{
			deger_vade_tarih = document.payment_with_voucher.revenue_start_date.value;
			deger_toplam = document.payment_with_voucher.net_total;
			deger_due_month = document.payment_with_voucher.due_month;
			deger_gross_total = document.payment_with_voucher.gross_total;
			deger_due_value = payment_with_voucher.due_value;
			deger_toplam.value = filterNum(deger_toplam.value);
			deger_due_month.value = filterNum(deger_due_month.value);	
			deger_due_value.value = filterNum(deger_due_value.value);	
			deger_gross_total.value = filterNum(deger_gross_total.value);
			deger_vade_tarih = payment_with_voucher.revenue_start_date.value;
			deger_vade_old = payment_with_voucher.avg_due_date.value;
			deger_new_due = ('d',deger_due_month.value*30/2,deger_vade_tarih);
			deger_vade_farki = datediff(deger_vade_old,deger_new_due,0);
			deger_faiz_total = deger_toplam.value * (deger_vade_farki/30) *(deger_due_value.value / 100);
			new_value = parseFloat(deger_toplam.value) + parseFloat(deger_faiz_total);
			deger_gross_total.value = commaSplit(new_value);
			if (document.getElementById('record_num').value > 0)
			{
				for(k=1;k<=payment_with_voucher.record_num.value;k++)
				{
					if(eval("document.payment_with_voucher.row_kontrol"+k).value==1)
					{
						sil(k);
					}
				}
			}
			my_row_value =  new_value / deger_due_month.value;
			my_row_value = commaSplit(my_row_value,4);
			for(i=1;i<=payment_with_voucher.due_month.value;i++)
			{
				add_row(my_row_value,deger_vade_tarih);
				deger_vade_tarih = ('m',+1,deger_vade_tarih);
			}	
			deger_toplam.value = commaSplit(deger_toplam.value);
			deger_due_value.value = commaSplit(deger_due_value.value);
			toplam_voucher_hesapla();
		}
	}
	function toplam_voucher_hesapla()
	{
		total_value = 0;
		for(j=1;j<=payment_with_voucher.record_num.value;j++)
		{
			if(eval("document.payment_with_voucher.row_kontrol"+j).value == 1)
				total_value = total_value + parseFloat(filterNum(eval('payment_with_voucher.voucher_value'+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
		}
		payment_with_voucher.total_voucher_value.value = commaSplit(total_value);
	}
	function change_due_date(no)
	{
		if(no != undefined)
		{
			deger_vade_tarih = eval('payment_with_voucher.due_date'+no).value;
			for(j=no+1;j<=row_count;j++)
			{
				deger_vade_tarih = ('m',+1,deger_vade_tarih);
				eval('payment_with_voucher.due_date' + j).value = deger_vade_tarih;
			}
		}
		else
		{
			deger_vade_tarih = payment_with_voucher.revenue_start_date.value;
			for(j=1;j<=row_count;j++)
			{
				deger_vade_tarih = ('m',+1,deger_vade_tarih);
				eval('payment_with_voucher.due_date' + j).value = deger_vade_tarih;
			}
			add_voucher_row();
		}
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
