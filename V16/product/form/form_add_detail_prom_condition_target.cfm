<cfquery name="get_cons_cat" datasource="#dsn#">
	SELECT
		*
	FROM
		CONSUMER_CAT
	ORDER BY
		HIERARCHY
</cfquery>
<cfquery name="get_process_cats" datasource="#dsn#">
	SELECT
  		PTR.STAGE,
		PTR.PROCESS_ROW_ID
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
        PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.add_consumer%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfquery name="get_paymethod" datasource="#dsn#">
	SELECT 
		SP.* 
	FROM 
		SETUP_PAYMETHOD SP,
		SETUP_PAYMETHOD_OUR_COMPANY SPOC
	WHERE 
		SP.PAYMETHOD_STATUS = 1
		AND SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
		AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY 
		SP.PAYMETHOD
</cfquery>
<cfquery name="get_kk_paymethod" datasource="#dsn3#">
	SELECT PAYMENT_TYPE_ID,CARD_NO FROM CREDITCARD_PAYMENT_TYPE WHERE IS_ACTIVE = 1 ORDER BY CARD_NO
</cfquery>
<table>
	<tr class="color-row">
		<td colspan="12" id="info" class="color-row">
			<table cellspacing="1" cellpadding="2" border="0">
				<tr>
					<td width="80"><cf_get_lang dictionary_id='58690.Tarih Aralığı'></td>
					<td>
						<cfinput type="text" name="order_start_date" style="width:65px;" validate="#validate_style#">
						<cf_wrk_date_image date_field="order_start_date">
					</td>
					<td width="110">
						<cfinput type="text" name="order_finish_date" style="width:65px;" validate="#validate_style#">
						<cf_wrk_date_image date_field="order_finish_date">
					</td>									
				</tr>
			</table>
		</td>
	</tr>
	<tr class="color-row">
		<td colspan="12" class="color-row">
			<table cellspacing="1" cellpadding="2" border="0" width="100%">
				<tr height="20"> 
					<td colspan="7" class="txtbold"><a href="javascript:gizle_goster(product_tab);">&raquo;</a><cf_get_lang dictionary_id='57657.Ürün'></td> 
				</tr>
				<tr id="product_tab" style="display:none;">
					<td>
						<table cellspacing="1" cellpadding="2" border="0" width="98%" class="color-border">
							<tr class="color-row">
								<td>
									<table>
										<td width="60"></td>
										<td valign="top" width="220">
											<table id="table1_1" name="table1_1">
												<tr>
													<input type="hidden" name="record_num1" id="record_num1" value="0">
													<td style="width:10px;"><a style="cursor:pointer" onclick="add_row1();"><img src="images/plus_list.gif" border="0"></a></td>
													<td style="width:173px;" nowrap><cf_get_lang dictionary_id='58221.Ürün Adı'></td>
												</tr>
											</table>
										</td>
										<td valign="top">
											<table width="70">
												<tr>
													<td><input type="checkbox" name="is_product_and" id="is_product_and" value="1" onClick="check_product(1);" checked> <cf_get_lang dictionary_id='57989.Ve'></td>
												</tr>
												<tr>
													<td><input type="checkbox" name="is_product_or" id="is_product_or" value="1" onClick="check_product(2);"> <cf_get_lang dictionary_id='57998.Veya'></td>
												</tr>
											</table>
										</td>
										<td width="40"></td>
										<td valign="top" width="220">
											<table id="table1_2" name="table1_2">
												<tr>
													<input type="hidden" name="record_num2" id="record_num2" value="0">
													<td style="width:10px;"><a style="cursor:pointer" onclick="add_row2();"><img src="images/plus_list.gif" border="0"></a></td>
													<td style="width:170px;" nowrap><cf_get_lang dictionary_id='29401.Ürün Kategorisi'></td>
												</tr>
											</table>
										</td>
										<td valign="top">
											<table width="100">
												<tr>
													<td><input type="checkbox" name="is_productcat_and" id="is_productcat_and" value="1" onClick="check_productcat(1);" checked> <cf_get_lang dictionary_id='57989.Ve'></td>
												</tr>
												<tr>
													<td><input type="checkbox" name="is_productcat_or" id="is_productcat_or" value="1" onClick="check_productcat(2);"> <cf_get_lang dictionary_id='57998.Veya'></td>
												</tr>
											</table>
										</td>									
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr class="color-row">
		<td colspan="12">
			<table cellspacing="1" cellpadding="2" border="0" width="100%">
				<tr height="20"> 
					<td colspan="7" class="txtbold"><a href="javascript:gizle_goster(promotion);">&raquo;</a><cf_get_lang dictionary_id='57369.Promosyon'></td> 
				</tr>
				<tr id="promotion" style="display:none;">
					<td>
						<table cellspacing="1" cellpadding="2" border="0" width="98%" class="color-border">
							<tr class="color-row">
								<td>
									<table width="100%">					
										<td width="60"></td>
										<td valign="top" width="220">
											<table id="table1_3" name="table1_3">
												<tr>
													<input type="hidden" name="record_num3" id="record_num3" value="0">
													<td style="width:10px;"><a style="cursor:pointer" onclick="add_row3();"><img src="images/plus_list.gif" border="0"></a></td>
													<td style="width:170px;" nowrap><cf_get_lang dictionary_id='57369.Promosyon'></td>
												</tr>
											</table>
										</td>
										<td valign="top">
											<table width="160">
												<tr>
													<td><input type="checkbox" name="is_prom_and" id="is_prom_and" value="1" onClick="check_prom(1);" checked> <cf_get_lang dictionary_id='57989.Ve'></td>
												</tr>
												<tr>
													<td><input type="checkbox" name="is_prom_or" id="is_prom_or" value="1" onClick="check_prom(2);"> <cf_get_lang dictionary_id='57998.Veya'></td>
												</tr>
												<tr>
													<td>
														<input type="text" name="prom_count" id="prom_count" value="" style="width:20px;" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));">
														<cf_get_lang dictionary_id='49621.Promosyon Sayısı'>
													</td>
												</tr>
											</table>
										</td>
										<td width="70"></td>
									</table>
								</td>
							</tr>
						</table>
					</td>						
				</tr>
			</table>
		</td>
	</tr>
	<tr class="color-row">
		<td colspan="12">
			<table cellspacing="1" cellpadding="2" border="0" width="100%">
				<tr height="20"> 
					<td colspan="7" class="txtbold"><a href="javascript:gizle_goster(order);">&raquo;</a><cf_get_lang dictionary_id='57611.Sipariş'></td> 
				</tr>
				<tr id="order" style="display:none;">
					<td>
					<table cellspacing="1" cellpadding="2" border="0" width="98%" class="color-border">
						<tr class="color-row">
							<td>
								<table width="100%">
									<tr>
										<td><cf_get_lang dictionary_id='29398.Son'></td>
										<td colspan="2">
											<input type="text" class="moneybox" name="order_date" id="order_date" style="width:78px;" value="" onKeyUp="return(FormatCurrency(this,event,0));">
											<select name="order_date_opt" id="order_date_opt" style="width:100px;">
												<option value="1"><cf_get_lang dictionary_id='57490.Gün'></option>
												<option value="2"><cf_get_lang dictionary_id='58734.Hafta'></option>
												<option value="3"><cf_get_lang dictionary_id='58724.Ay'></option>
												<option value="4"><cf_get_lang dictionary_id='58455.Yıl'></option>
											</select>
										</td>
										<td>
											<input type="checkbox" name="is_order" id="is_order" value="1" onClick="check_order(1);"><cf_get_lang dictionary_id='49624.Sipariş Verenler'>
											<input type="checkbox" name="is_not_order" id="is_not_order" value="1" onClick="check_order(2);"><cf_get_lang dictionary_id='49625.Sipariş Vermeyenler'>
										</td>							
									</tr>
									<tr>
										<td width="80"><cf_get_lang dictionary_id='49626.Sipariş Tutarı'></td>
										<td width="260">
											<input type="text" class="moneybox" name="order_amount" id="order_amount" style="width:78px;" value="" onKeyUp="return(FormatCurrency(this,event));">
											<select name="sel_order_amount" id="sel_order_amount" style="width:100px;">
												<option value="1"><cf_get_lang dictionary_id='49627.En Az'></option>
												<option value="2"><cf_get_lang dictionary_id='49628.En Çok'></option>
												<option value="3"><cf_get_lang dictionary_id='57492.Toplam'></option>
												<option value="4"><cf_get_lang dictionary_id='54560.Ortalama'></option>
											</select>
										</td>
										<td width="77"><cf_get_lang dictionary_id='49630.Ürün Adedi'></td>
										<td>
											<input type="text" class="moneybox" name="product_amount" id="product_amount" style="width:78px;" value="" onKeyUp="return(FormatCurrency(this,event,0));">
											<select name="sel_product_amount" id="sel_product_amount" style="width:100px;">
												<option value="1"><cf_get_lang dictionary_id='49627.En Az'></option>
												<option value="2"><cf_get_lang dictionary_id='49628.En Çok'></option>
												<option value="3"><cf_get_lang dictionary_id='57492.Toplam'></option>
												<option value="4"><cf_get_lang dictionary_id='54560.Ortalama'></option>
											</select>
										</td>
									</tr>
									<tr>
										<td><cf_get_lang dictionary_id='49631.Sipariş Adedi'></td>
										<td>
											<input type="text" class="moneybox" name="order_count" id="order_count" style="width:78px;" value="" onKeyUp="return(FormatCurrency(this,event,0));">
											<select name="sel_order_count" id="sel_order_count" style="width:100px;">
												<option value="1"><cf_get_lang dictionary_id='49627.En Az'></option>
												<option value="2"><cf_get_lang dictionary_id='49628.En Çok'></option>
												<option value="3"><cf_get_lang dictionary_id='57492.Toplam'></option>
											</select>
										</td>
									</tr>
									<tr>
										<td rowspan="2" valign="top"><cf_get_lang dictionary_id='58090.İletişim Yöntemi'></td>
										<td rowspan="2" valign="top">
											<select name="order_commethod" id="order_commethod" style="width:180px;height:90px;" multiple>
												<cfoutput query="get_commethod_cats">
													<option value="#commethod_id#">#commethod#</option>
												</cfoutput>
											</select>	
										</td>
										<td rowspan="2" valign="top"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></td>
										<td rowspan="2" valign="top">
											<select name="order_paymethod" id="order_paymethod" style="width:180px; height:90px;" multiple="multiple">
												<optgroup label="Ödeme Yöntemleri">
													<cfoutput query="get_paymethod">
													  <option value="1-#paymethod_id#">&nbsp;&nbsp;#paymethod#</option>
													</cfoutput>
												</optgroup>
												<optgroup label="Kredi Kartı Ödeme Yöntemleri">
													<cfoutput query="get_kk_paymethod">
													  <option value="2-#payment_type_id#">&nbsp;&nbsp;#card_no#</option>
													</cfoutput>
												</optgroup>
											</select>	
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr class="color-row">
		<td colspan="12">
			<table cellspacing="1" cellpadding="2" border="0" width="100%">
				<tr height="20"> 
					<td colspan="7" class="txtbold"><a href="javascript:gizle_goster(member);">&raquo;</a><cf_get_lang dictionary_id='57658.Üye'></td> 
				</tr>
				<tr id="member" style="display:none;">
					<td>
					<table cellspacing="1" cellpadding="2" border="0" width="98%" class="color-border">
						<tr class="color-row">
							<td>
								<table>
									<tr>
										<td rowspan="3" valign="top" width="80"><cf_get_lang dictionary_id='49634.Üye Aşama'></td>
										<td rowspan="3" valign="top" width="200">
											<select name="member_stage" id="member_stage" style="width:180px;height:70px;" multiple>
												<cfoutput query="get_process_cats">
													<option value="#process_row_id#">#stage#</option>
												</cfoutput>
											</select>	
										</td>
										<td align="right" valign="top" style="text-align:right;"><cf_get_lang dictionary_id='58727.Doğum Tarihi'></td>
										<td valign="top">
											<cfinput type="text" name="birth_date" style="width:65px;" validate="#validate_style#">
											<cf_wrk_date_image date_field="birth_date">
										</td>
									</tr>
									<tr>
										<td align="right" style="text-align:right;"><cf_get_lang dictionary_id='49636.Promosyon Önerisi'></td>
										<td>
											<input type="checkbox" name="is_prom_select" id="is_prom_select" value="1" onClick="check_prom_sel(1);">&nbsp;<cf_get_lang dictionary_id='49637.Seçenler'>
										</td>
									</tr>
									<tr>
										<td></td>
										<td>
											<input type="checkbox" name="is_notprom_select" id="is_notprom_select" value="1" onClick="check_prom_sel(2);">&nbsp;<cf_get_lang dictionary_id='49638.Seçmeyenler'>
										</td>
									</tr>
									<tr>
										<td width="60"></td>
										<td colspan="4">
										<table>
											<tr>
												<td><input type="checkbox" name="is_cep_tel" id="is_cep_tel" value="1">&nbsp;<cf_get_lang dictionary_id='49639.Cep Telefonu olanlar'></td>
												<td width="135"><input type="checkbox" name="is_email" id="is_email" value="1">&nbsp;<cf_get_lang dictionary_id='49640.Email Adresi Olanlar'></td>
												<td><input type="checkbox" name="is_tax" id="is_tax" value="1">&nbsp;<cf_get_lang dictionary_id='49641.Vergi Mükellefi Olanlar'></td>
											</tr>
											<tr>
												<td><input type="checkbox" name="is_debt" id="is_debt" value="1">&nbsp;<cf_get_lang dictionary_id='49642.Vadesi Geçmiş Borcu Olanlar'></td>
												<td><input type="checkbox" name="is_bloke" id="is_bloke" value="1">&nbsp;<cf_get_lang dictionary_id='49643.Bloke Olanlar'></td>
												<td><input type="checkbox" name="is_open_order" id="is_open_order" value="1">&nbsp;<cf_get_lang dictionary_id='49644.Açık Sipariş Satırı Olanlar'></td>
											</tr>
											<tr>
												<td><input type="checkbox" name="is_black_list" id="is_black_list" value="1">&nbsp;<cf_get_lang dictionary_id='49645.Kara Listede Olanlar'></td>
												<td colspan="2"><cf_get_lang dictionary_id='49646.Şifresini'> <input type="text" name="password_day" id="password_day" value="" style="width:40px;" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));"><cf_get_lang dictionary_id='49647.Gündür Değiştirmeyenler'></td>
											</tr>
										</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr class="color-row">
		<td colspan="12">
			<table cellspacing="1" cellpadding="2" border="0" width="100%">
				<tr height="20"> 
					<td colspan="7" class="txtbold"><a href="javascript:gizle_goster(other);">&raquo;</a><cf_get_lang dictionary_id='58156.Diğer'></td> 
				</tr>
				<tr id="other" style="display:none;">
					<td>
						<table cellspacing="1" cellpadding="2" border="0" width="98%" class="color-border">
						<tr class="color-row">
							<td>
								<table width="100%">
								<tr>
									<td width="60"></td>
									<td valign="top" width="230">
										<table id="table1_4" name="table1_4">
											<tr>
												<input type="hidden" name="record_num4" id="record_num4" value="0">
												<td style="width:10px;"><a style="cursor:pointer" onclick="add_row4();"><img src="images/plus_list.gif" border="0"></a></td>
												<td style="width:170px;" nowrap><cf_get_lang dictionary_id='57419.Eğitim'></td>
											</tr>
										</table>
									</td>
									<td valign="top">
										<table width="160">
											<tr>
												<td><input type="checkbox" name="is_train_and" id="is_train_and" value="1" onClick="check_train(1);" checked> <cf_get_lang dictionary_id='57989.Ve'></td>
											</tr>
											<tr>
												<td><input type="checkbox" name="is_train_or" id="is_train_or" value="1" onClick="check_train(2);"> <cf_get_lang dictionary_id='57998.Veya'></td>
											</tr>
										</table>
									</td>
									<td width="70"></td>									
								</tr>
								</table>
							</td>
						</tr>
					</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<script type="text/javascript">
	var row_count_t_1= 0;
	var row_count_t_2= 0;
	var row_count_t_3= 0;
	var row_count_t_4= 0;
	function sil1(sy)
	{
		var my_element=eval("add_prom.row_kontrol1"+sy);
		my_element.value=0;
		var my_element=eval("frm_row1"+sy);
		my_element.style.display="none";
	}
	function add_row1()
	{
		row_count_t_1++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1_1").insertRow(document.getElementById("table1_1").rows.length);
		newRow.setAttribute("name","frm_row1" + row_count_t_1);
		newRow.setAttribute("id","frm_row1" + row_count_t_1);
		document.getElementById('record_num1').value=row_count_t_1;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_kontrol1'+row_count_t_1+'" value="1"><a style="cursor:pointer" onclick="sil1(' + row_count_t_1 + ');"><img  src="images/delete_list.gif" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden" name="product_target_id' + row_count_t_1 +'" ><input type="text" name="product_target_name' + row_count_t_1 +'" class="text" style="width:180px;" readonly>'
						+' '+'<a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=add_prom.product_target_id" + row_count_t_1 + "&field_name=add_prom.product_target_name" + row_count_t_1 + "','list');"+'"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
	}
	function sil2(sy)
	{
		var my_element=eval("add_prom.row_kontrol2"+sy);
		my_element.value=0;
		var my_element=eval("frm_row2"+sy);
		my_element.style.display="none";
	}
	function add_row2()
	{
		row_count_t_2++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1_2").insertRow(document.getElementById("table1_2").rows.length);
		newRow.setAttribute("name","frm_row2" + row_count_t_2);
		newRow.setAttribute("id","frm_row2" + row_count_t_2);
		document.getElementById('record_num2').value=row_count_t_2;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_kontrol2'+row_count_t_2+'" value="1"><a style="cursor:pointer" onclick="sil2(' + row_count_t_2 + ');"><img  src="images/delete_list.gif" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden" name="productcat_id' + row_count_t_2 +'" ><input type="text" name="productcat_name' + row_count_t_2 +'" class="text" style="width:178px;" readonly>'
						+' '+'<a href="javascript://" onClick="openBoxDraggable('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=add_prom.productcat_id" + row_count_t_2 + "&field_name=add_prom.productcat_name" + row_count_t_2 + "</cfoutput>');"+'"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
	}
	function sil3(sy)
	{
		var my_element=eval("add_prom.row_count_t_3"+sy);
		my_element.value=0;
		var my_element=eval("frm_row3"+sy);
		my_element.style.display="none";
	}
	function add_row3()
	{
		row_count_t_3++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1_3").insertRow(document.getElementById("table1_3").rows.length);
		newRow.setAttribute("name","frm_row3" + row_count_t_3);
		newRow.setAttribute("id","frm_row3" + row_count_t_3);
		document.getElementById('record_num3').value=row_count_t_3;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_count_t_3'+row_count_t_3+'" value="1"><a style="cursor:pointer" onclick="sil3(' + row_count_t_3 + ');"><img  src="images/delete_list.gif" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden" name="promotion_id' + row_count_t_3 +'" ><input type="text" name="promotion_name' + row_count_t_3 +'" class="text" style="width:180px;" readonly>'
						+' '+'<a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_list_promotions&prom_id=add_prom.promotion_id" + row_count_t_3 + "&prom_head=add_prom.promotion_name" + row_count_t_3 + "</cfoutput>','small');"+'"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
	}
	function sil4(sy)
	{
		var my_element=eval("add_prom.row_count_t_4"+sy);
		my_element.value=0;
		var my_element=eval("frm_row4"+sy);
		my_element.style.display="none";
	}
	function add_row4()
	{
		row_count_t_4++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1_4").insertRow(document.getElementById("table1_4").rows.length);
		newRow.setAttribute("name","frm_row4" + row_count_t_4);
		newRow.setAttribute("id","frm_row4" + row_count_t_4);
		document.getElementById('record_num4').value=row_count_t_4;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_count_t_4'+row_count_t_4+'" value="1"><a style="cursor:pointer" onclick="sil4(' + row_count_t_4 + ');"><img  src="images/delete_list.gif" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden" name="training_id' + row_count_t_4 +'" ><input type="text" name="training_name' + row_count_t_4 +'" class="text" style="width:180px;" readonly>'
						+' '+'<a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_list_trainings&field_id=add_prom.training_id" + row_count_t_4 + "&field_name=add_prom.training_name" + row_count_t_4 + "</cfoutput>','list');"+'"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
	}
	add_row1();
	add_row2();
	add_row3();
	add_row4();
</script>
