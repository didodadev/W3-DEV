<cfif session.ep.isBranchAuthorization><cfset attributes.store_id = listgetat(session.ep.user_location, 2, '-')></cfif>
<cf_get_lang_set module_name="finance"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="GET_BRANCH_NAME" datasource="#DSN#">
	SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = #attributes.store_id#
</cfquery>
<cfquery name="GET_DAILY_SALES_REPORT" datasource="#DSN3#">
	SELECT EQUIPMENT AS EQUIPMENT, POS_ID AS POS_ID FROM POS_EQUIPMENT WHERE BRANCH_ID = #attributes.store_id# AND IS_STATUS = 1 ORDER BY POS_ID
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<form name="add_daily_sales_report" id="add_daily_sales_report" action="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.emptypopup_add_daily_reports" method="post">
			<cfparam name="attributes.report_date" default="#now()#">
			<input type="hidden" name="bug_state" id="bug_state" value="0">
			<input type="hidden" value="<cfoutput>#get_daily_sales_report.recordcount#</cfoutput>" name="equirment_count" id="equirment_count">
			<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.store_id#</cfoutput>">
			<cf_box_search plus="0">
				<div class="form-group" id="tarih">
					<div class="input-group medium">
						<input type="text" name="report_date" id="report_date" readonly="yes" value="<cfoutput>#Dateformat(now(),dateformat_style)#</cfoutput>" maxlength="10">
						<span class="input-group-addon"><cf_wrk_date_image date_field="report_date" call_function="change_date"></span>
					</div>
				</div>
			</cf_box_search>
			<cf_seperator id="kasalar_" title="#getLang('','Kasalar',58657)#">
			<cf_grid_list id="kasalar_">
				<thead>
					<tr>
						<th><cf_get_lang dictionary_id='54574.Kasa No'></th>
						<th><cf_get_lang dictionary_id='54577.Kasiyer'></th>
						<th><cf_get_lang dictionary_id='54585.Nakit Satış'></th>
						<th><cf_get_lang dictionary_id='54586.Kredili Satış'></th>
						<th><cf_get_lang dictionary_id='37285.Toplam Satış'></th>
						<th><cf_get_lang dictionary_id='58438.Z Raporu'></th>
						<th><cf_get_lang dictionary_id='54597.Z No'></th>
						<th><cf_get_lang dictionary_id='58717.Açık'></th>
					</tr>
				</thead>
					<cfif get_daily_sales_report.recordcount><!--- finans tanımlardaki yazar kasalardan geliyor. --->
						<tbody>
							<cfoutput query="get_daily_sales_report">
								<input type="hidden" name="pos_id#currentrow#" id="pos_id#currentrow#" value="#get_daily_sales_report.pos_id#">
								<input type="hidden" name="pos_no#currentrow#" id="pos_no#currentrow#" value="#get_daily_sales_report.equipment#">
								<tr>
									<td>#equipment#</td>
									<td><div class="input-group">
										<input type="hidden" name="employee_id#currentrow#" id="employee_id#currentrow#" value="">
										<input type="text" name="employee#currentrow#" id="employee#currentrow#" value="">
										<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_daily_sales_report.employee_id#currentrow#&field_name=add_daily_sales_report.employee#currentrow#&select_list=1');"></span></div>
									</td>
									<td  style="text-align:right;"><input type="text" name="total_cash#currentrow#" id="total_cash#currentrow#" value="0" class="moneybox" onBlur="toplam_center();" onKeyup="return(FormatCurrency(this,event));"></td>
									<td  style="text-align:right;"><input type="text" name="total_credit#currentrow#" id="total_credit#currentrow#" onBlur="toplam_center();" onKeyup="return(FormatCurrency(this,event));" value="0" style="width:100px;" class="moneybox"></td>
									<td  style="text-align:right;"><input type="text" name="total#currentrow#" id="total#currentrow#" value="0" class="moneybox" readonly="yes"></td>
									<td  style="text-align:right;"><input type="text" name="given_money#currentrow#" id="given_money#currentrow#" value="0" class="moneybox" onBlur="toplam_center();" onKeyup="return(FormatCurrency(this,event));"></td>
									<td  style="text-align:right;"><input type="text" name="z_no#currentrow#" id="z_no#currentrow#" value="" maxlength="100"></td>
									<td  style="text-align:right;"><input type="text" name="open_cash#currentrow#" id="open_cash#currentrow#" readonly="yes" value="0" class="moneybox"></td>
								</tr>
							</cfoutput>
						</tbody>
						<tfoot>
							<tr>
								<td colspan="2" class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
								<td style="text-align:right;"><input type="text" name="a_total_cash" id="a_total_cash" readonly="yes" value="0" class="moneybox"></td>
								<td style="text-align:right;"><input type="text" name="a_total_credit" id="a_total_credit" readonly="yes" value="0" class="moneybox"></td>
								<td style="text-align:right;"><input type="text" name="a_total" id="a_total" readonly="yes" value="0" class="moneybox"></td>
								<td style="text-align:right;"><input type="text" name="a_given_money" id="a_given_money" readonly="yes" value="0" class="moneybox"></td>
								<td style="text-align:right;"></td>
								<td style="text-align:right;"><input type="text" name="a_open_cash" id="a_open_cash" readonly="yes" value="0" class="moneybox"></td>
							</tr>
						</tfoot>
					<cfelse>
						<tbody>
							<tr>
								<td colspan="9" class="tableyazi"><cf_get_lang dictionary_id='54852.Kasalarınızı Tanımlayınız'>!</td>
							</tr>
						</tbody>
					</cfif>
				</tbody>
			</cf_grid_list>
			<cfquery name="GET_CREDIT_PAYMENT" datasource="#DSN3#">
				SELECT PAYMENT_TYPE_ID,CARD_NO,GIVEN_POINT_RATE FROM CREDITCARD_PAYMENT_TYPE WHERE IS_ACTIVE = 1 ORDER BY CARD_NO
			</cfquery>
			<cf_seperator id="bankalar_" title="#getLang('','Bankalar',57987)#">
			<cf_grid_list id="bankalar_">
				<thead>
					<tr>
						<th><cf_get_lang dictionary_id='34257.Kredi Kartı Ödeme Yöntemi'></th>
						<th><cf_get_lang dictionary_id='40025.İşlem Sayısı'></th>
						<th><cf_get_lang dictionary_id='54854.Kredili Satış Tutarı'></th>
						<th><cf_get_lang dictionary_id='54857.Verilen Puan'></th>
						<th><cf_get_lang dictionary_id='54856.Satış Puan'></th>
						<th><cf_get_lang dictionary_id='57492.Toplam'></th>
					</tr>
				</thead>
				<cfif get_credit_payment.recordcount>
					<tbody>
						<cfoutput query="get_credit_payment">
							<input type="hidden" name="bank_branch_id#currentrow#" id="bank_branch_id#currentrow#" value="#payment_type_id#">
							<input type="hidden" name="given_point_rate#currentrow#" id="given_point_rate#currentrow#" value="0"><!--- #TLFormat(get_credit_payment.given_point_rate)#   burası şimdilik 0 atıcak,eski sayfalar olduug için zaanı gelince tekrar düzeltilecel--->
							<tr>
								<td>#card_no#</td>
								<td style="text-align:right;"><input type="text" name="number_of_operation#currentrow#" id="number_of_operation#currentrow#" value="0" onBlur="hesapla_banka();" onKeyup="return(FormatCurrency(this,event));" class="moneybox"></td>
								<td style="text-align:right;"><input type="text" name="sales_credit#currentrow#" id="sales_credit#currentrow#" value="0" onBlur="hesapla_banka();" onKeyup="return(FormatCurrency(this,event));"class="moneybox"></td>
								<td style="text-align:right;"><input type="text" name="puanli_pesin#currentrow#" id="puanli_pesin#currentrow#" value="0" readonly="yes" class="moneybox"></td>
								<td style="text-align:right;"><input type="text" name="puanli#currentrow#" id="puanli#currentrow#" value="0" readonly="yes" onBlur="hesapla_banka();" onKeyup="return(FormatCurrency(this,event));" class="moneybox"></td><!--- readonly yapıldı,gerekirse düzenlenecek --->
								<td style="text-align:right;"><input type="text" name="sales_open_cash#currentrow#" id="sales_open_cash#currentrow#" value="0"  class="moneybox" readonly="yes"></td>
							</tr>
						</cfoutput>
					</tbody>
					<tfoot>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
							<td style="text-align:right;"><input type="text" value="0" name="bank_total_number_of_operation" id="bank_total_number_of_operation" class="moneybox" readonly="yes"></td>
							<td style="text-align:right;"><input type="text" value="0" name="bank_total_credit" id="bank_total_credit" readonly="yes" class="moneybox"></td>
							<td style="text-align:right;"><input type="text" value="0" name="bank_total_puanli_pesin" id="bank_total_puanli_pesin" class="moneybox" readonly="yes"></td>
							<td style="text-align:right;"><input type="text" value="0" name="bank_total_puanli" id="bank_total_puanli" class="moneybox" readonly="yes"></td>
							<td style="text-align:right;"><input type="text" value="0" name="bank_total_toplam" id="bank_total_toplam" class="moneybox" readonly="yes"></td>
						</tr>
					</tfoot>
				<cfelse>
					<tbody>
						<tr>
							<td colspan="5" class="tableyazi"><cf_get_lang no='563.Kredi Kartı Ödeme Yöntemlerinizi Tanımlayınız'> !</td>
						</tr>
					</tbody>
				</cfif>
				</tbody>
			</cf_grid_list>
			<cfquery name="GET_MONEY" datasource="#DSN#">
				SELECT MONEY, RATE1, RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS= 1
			</cfquery>
			<cfquery name="GET_STORE_EXPENSE_TYPE" datasource="#dsn2#">
				SELECT EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1  AND IS_ACTIVE = 1 ORDER BY EXPENSE_ITEM_NAME 
			</cfquery>
			<cfquery name="GET_SETUP_TAX" datasource="#DSN2#">
				SELECT TAX FROM SETUP_TAX
			</cfquery>
			<cf_seperator title="#getLang('main',1246)#" id="odemeler_">
				<cf_grid_list id="odemeler_">
					<thead>
						<tr>
							<th width="20"><input name="record_num" id="record_num" type="hidden" value="0"><a href="javascript://" onClick="add_row();"><i class="fa fa-plus"></i></a></th>
							<th><cf_get_lang dictionary_id='58234.Bütçe Kalemi'>*</th>
							<th><cf_get_lang dictionary_id='36199.Açıklama'> *</th>
							<th><cf_get_lang dictionary_id='57673.Tutar'></th>
							<th><cf_get_lang dictionary_id='57639.KDV'></th>
							<th><cf_get_lang dictionary_id='33214.KDV Tutar'></th>
							<th><cf_get_lang dictionary_id='57492.Toplam'></th>
							<th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
						</tr>
					</thead>
					<tbody name="table1" id="table1"></tbody>
				</cf_grid_list>
			<cf_seperator title="#getLang('main',677)#" id="gelirler_">
				<cf_grid_list id="gelirler_">
					<thead>
						<cfquery name="GET_INCOME" datasource="#dsn2#">
							SELECT EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE INCOME_EXPENSE = 1 AND IS_ACTIVE = 1 ORDER BY EXPENSE_ITEM_NAME 
						</cfquery>
						<tr>
							<th width="20"><input name="income_record_num" id="income_record_num" type="hidden" value="0"><a href="javascript://" onClick="income_add_row();"><i class="fa fa-plus"></i></a></th>
							<th><cf_get_lang dictionary_id='58234.Bütçe Kalemi'>*</th>
							<th><cf_get_lang dictionary_id='36199.Açıklama'>*</th>
							<th><cf_get_lang dictionary_id='57673.Tutar'></th>
							<th><cf_get_lang dictionary_id='57639.KDV'></th>
							<th><cf_get_lang dictionary_id='33214.KDV Tutar'></th>
							<th><cf_get_lang dictionary_id='57492.Toplam'></th>
							<th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
						</tr>
					</thead>
					<tbody name="table2" id="table2"></tbody>
				</cf_grid_list>
			<cfquery name="GET_TOTAL_KALAN" datasource="#DSN2#" maxrows="1"><!--- enson kaydı bulur --->
				SELECT DEVREDEN,STORE_REPORT_DATE FROM STORE_REPORT WHERE STORE_REPORT_DATE >= #DATEADD("d",attributes.report_date, -1)# AND STORE_REPORT_DATE < #attributes.report_date# AND BRANCH_ID = #attributes.store_id#
			</cfquery>
			<br />
			<cf_seperator title="#session.ep.money#" id="money">
			<cf_box_elements id="money">
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-kalan_eski">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='54604.Dünden Kalan'></label>
						<div class="col col-8 col-xs-12">
							<cfif len(get_total_kalan.devreden)>
								<input type="text" name="kalan_eski" id="kalan_eski" value="<cfoutput>#tlformat(get_total_kalan.devreden)#</cfoutput>" class="moneybox" onBlur="toplam_center();" onkeyup="return(FormatCurrency(this,event));">
							<cfelse>
								<input type="text" name="kalan_eski" id="kalan_eski" value="0" class="moneybox" onBlur="toplam_center();" onkeyup="return(FormatCurrency(this,event));">
							</cfif>
							<input type="hidden" name="a_1" id="a_1" value="<cfoutput>#tlformat(get_total_kalan.devreden)#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-summary_genel_nakit">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='54585.Nakit Satış'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="summary_genel_nakit" id="summary_genel_nakit" readonly="yes" value="0" class="moneybox">
						</div>
					</div>
					<div class="form-group" id="item-summary_genel_kredili">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='54586.Kredili Satış'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="summary_genel_kredili" id="summary_genel_kredili" value="0" readonly="yes" class="moneybox">
						</div>
					</div>
					<div class="form-group" id="item-summary_genel_toplam">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37285.Toplam Satış'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="summary_genel_toplam" id="summary_genel_toplam" value="0" readonly="yes" class="moneybox">
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-summary_genel_gelir">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58658.Ödemeler'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="summary_genel_gider" id="summary_genel_gider" value="0" readonly="yes" class="moneybox">
						</div>
					</div>
					<div class="form-group" id="item-summary_genel_gelir">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58089.Gelirler'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="summary_genel_gelir" id="summary_genel_gelir" value="0" readonly="yes" class="moneybox">
						</div>
					</div>
					<div class="form-group" id="item-summary_genel_acik">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='54609.Kasa Açıkları'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="summary_genel_acik" id="summary_genel_acik" value="0" readonly="yes" class="moneybox">
						</div>
					</div>
					<div class="form-group" id="item-bankaya_yatan">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='54607.Bankaya Yatan'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="bankaya_yatan" id="bankaya_yatan" value="0" onBlur="expense_topla();" onKeyup="return(FormatCurrency(this,event));" class="moneybox">
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-summary_genel_kalan">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58034.Devreden'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="summary_genel_kalan" id="summary_genel_kalan" value="0" readonly="yes" class="moneybox">
						</div>
					</div>
					<div class="form-group" id="item-report_emp">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='54606.Düzenleyen'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="report_emp_id" id="report_emp_id" value="">
								<input type="text" name="report_emp" id="report_emp" value="" readonly="">
								<span class="input-group-addon icon-ellipsis"  onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_daily_sales_report.report_emp_id&field_name=add_daily_sales_report.report_emp&select_list=1,9</cfoutput>');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-ek_info">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57810.Ek Bilgi'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="ek_info" id="ek_info" style="width:120px;height:65px;"></textarea>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons type_format="1" is_upd='0' add_function='gonder_temizle()'>
			</cf_box_footer>
		</form>
	</cf_box>
</div>
<script type="text/javascript">
row_count=0;
function sil(sy)
{
	var my_element=eval("add_daily_sales_report.row_kontrol"+sy);
	my_element.value=0;
	var my_element=eval("frm_row"+sy);
	my_element.style.display="none";
}

function kontrol_et()
{
	if(row_count ==0) return false;
	else return true;
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
	document.add_daily_sales_report.record_num.value=row_count;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"><i class="fa fa-minus"></i></a>';		
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" ><select name="payment_type' + row_count +'" style="width:150px;"><option value=""><cf_get_lang_main no='322.Seçiniz'></option><cfoutput query="get_store_expense_type"><option value="#expense_item_id#">#expense_item_name#</option></cfoutput></select></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="detail' + row_count +'" style="width:150px;"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="expense_total' + row_count +'" style="width:100px;" value="0" onBlur="expense_topla();" onkeyup="return(FormatCurrency(this,event));" class="moneybox"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><select name="payment_tax' + row_count  +'" onChange="expense_topla();" ><cfoutput query="get_setup_tax"><option value="#tax#">#tax#</option></cfoutput></select></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="payment_net_total_tax' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:80px;" onBlur="expense_topla();"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="payment_net_total' + row_count +'" value="0" class="moneybox" style="width:100px;" readonly="yes"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><select name="money_type' + row_count +'" onChange="expense_topla();" style="width:80px;"><cfoutput query="get_money"><option value="#money#,#rate1#,#rate2#" <cfif money eq session.ep.money>selected</cfif>>#money#</option></cfoutput></select></div>';
}
income_row_count=0;
function income_sil(syi)
{
	var income_my_element=eval("add_daily_sales_report.income_row_kontrol"+syi);
	income_my_element.value=0;
	var income_my_element=eval("income_frm_row"+syi);
	income_my_element.style.display="none";
}
function income_kontrol_et()
{
	if(income_row_count ==0) return false;
	else return true;
}
function income_add_row()
{
	income_row_count++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);	
	newRow.setAttribute("name","income_frm_row" + income_row_count);
	newRow.setAttribute("id","income_frm_row" + income_row_count);		
	newRow.setAttribute("NAME","income_frm_row" + income_row_count);
	newRow.setAttribute("ID","income_frm_row" + income_row_count);		
	document.add_daily_sales_report.income_record_num.value=income_row_count;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a style="cursor:pointer" onclick="income_sil(' + income_row_count + ');"  ><i class="fa fa-minus"></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input  type="hidden"  value="1"  name="income_row_kontrol' + income_row_count +'" ><select name="income_payment_type' + income_row_count +'" style="width:150px;"><option value=""><cf_get_lang_main no='322.Seçiniz'></option><cfoutput query="get_income"><option value="#expense_item_id#">#expense_item_name#</option></cfoutput></select></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="income_detail' + income_row_count +'" style="width:150px;"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="income_expense_total' + income_row_count +'" style="width:100px;" value="0" onBlur="income_expense_topla();" onkeyup="return(FormatCurrency(this,event));" class="moneybox"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><select name="income_payment_tax' + income_row_count  +'" onChange="income_expense_topla();"><cfoutput query="get_setup_tax"><option value="#tax#">#tax#</option></cfoutput></select></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="income_payment_net_total_tax' + income_row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:80px;" onBlur="income_expense_topla();"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="income_payment_net_total' + income_row_count +'" value="0" class="moneybox" style="width:100px;" readonly="yes"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><select name="income_money_type' + income_row_count +'" onChange="income_expense_topla();" style="width:80px;"><cfoutput query="get_money"><option value="#money#,#rate1#,#rate2#" <cfif money eq session.ep.money>selected</cfif>>#money#</option></cfoutput></select></div>';
}
/*Kasa İle İlgili Tum Hesaplamalar Burada Yapılıyor*/
function toplam_center()
{
	toplam_expense=0;
	toplam_fark_expense=0;
	genel_toplam_1=0;
	genel_toplam_2=0;
	genel_toplam_3=0;
	genel_toplam_4=0;
	genel_toplam_5=0;
	for (var k=1; k <= <cfoutput>#get_daily_sales_report.recordcount#</cfoutput>; k++)
	{
		alan_1 = eval('add_daily_sales_report.total_cash'+k);
		alan_2 = eval('add_daily_sales_report.total_credit'+k);
		alan_3 = eval('add_daily_sales_report.given_money'+k);
		alan_4 = eval('add_daily_sales_report.total'+k);
		alan_5 = eval('add_daily_sales_report.open_cash'+k);
		alan_1.value=filterNum(alan_1.value);
		alan_2.value=filterNum(alan_2.value);
		alan_3.value=filterNum(alan_3.value);
		if(alan_1.value == "") { alan_1.value = 0; }
		if(alan_2.value == "") { alan_2.value = 0; }
		if(alan_3.value == "") { alan_3.value = 0; }
		toplam_expense = parseFloat(alan_1.value) + parseFloat(alan_2.value);
		genel_toplam_3 = genel_toplam_3 + toplam_expense;
		alan_4.value = toplam_expense;		
		add_daily_sales_report.a_total.value = commaSplit(genel_toplam_3);
		toplam_fark_expense = parseFloat(alan_3.value) - (parseFloat(alan_1.value) + parseFloat(alan_2.value));		
		alan_4.value = commaSplit(alan_4.value);
		genel_toplam_5 = genel_toplam_5 + wrk_round(toplam_fark_expense);
		alan_5.value = commaSplit(toplam_fark_expense);
		add_daily_sales_report.a_open_cash.value = commaSplit(genel_toplam_5);
		add_daily_sales_report.summary_genel_acik.value = commaSplit(genel_toplam_5);
		genel_toplam_1 = genel_toplam_1 + parseFloat(alan_1.value);
		add_daily_sales_report.a_total_cash.value = commaSplit(genel_toplam_1);
		add_daily_sales_report.summary_genel_nakit.value = commaSplit(genel_toplam_1);
		genel_toplam_2 = genel_toplam_2 + parseFloat(alan_2.value); 
		add_daily_sales_report.a_total_credit.value = commaSplit(genel_toplam_2);
		add_daily_sales_report.summary_genel_kredili.value = commaSplit(genel_toplam_2);
		genel_toplam_4 = genel_toplam_4 + parseFloat(alan_3.value);
		add_daily_sales_report.a_given_money.value = commaSplit(genel_toplam_4);
		add_daily_sales_report.summary_genel_toplam.value = commaSplit(genel_toplam_3);
		alan_1.value=commaSplit(alan_1.value);
		alan_2.value=commaSplit(alan_2.value);
		alan_3.value=commaSplit(alan_3.value);
	} 
	return expense_topla()
}
/*Banka İle İlgili Hesaplamalar Burada Yapılıyor*/
function hesapla_banka()
{
	banka_toplam_1 = 0;
	banka_toplam_2 = 0;
	banka_toplam_3 = 0;
	banka_toplam_4 = 0;
	banka_toplam_5 = 0;
	banka_toplam_6 = 0;
	for (var d=1; d <= <cfoutput>#get_credit_payment.recordcount#</cfoutput>; d++)
	{
		alan_banka_1 = eval('add_daily_sales_report.sales_credit'+d);
		alan_banka_2 = eval('add_daily_sales_report.puanli_pesin'+d);
		alan_banka_3 = eval('add_daily_sales_report.puanli'+d);
		alan_banka_4 = eval('add_daily_sales_report.number_of_operation'+d);
		alan_banka_5 = eval('add_daily_sales_report.sales_open_cash'+d);
		alan_banka_6 = eval('add_daily_sales_report.given_point_rate'+d);

		alan_banka_1.value=filterNum(alan_banka_1.value);
		alan_banka_2.value=filterNum(alan_banka_2.value);
		alan_banka_3.value=filterNum(alan_banka_3.value);
		alan_banka_4.value=filterNum(alan_banka_4.value,0);
		alan_banka_6.value=filterNum(alan_banka_6.value);
		
		if(alan_banka_1.value=="") { alan_banka_1.value = 0; }
		if(alan_banka_2.value=="") { alan_banka_2.value = 0; }
		if(alan_banka_3.value=="") { alan_banka_3.value = 0; }
		if(alan_banka_4.value=="") { alan_banka_4.value = 0; }
		if(alan_banka_6.value=="") { alan_banka_6.value = 0; }
		
		banka_toplam_1 = banka_toplam_1 + parseFloat(alan_banka_1.value);
		add_daily_sales_report.bank_total_credit.value = commaSplit(banka_toplam_1);
		banka_toplam_4 = banka_toplam_4 + parseFloat(alan_banka_4.value);
		add_daily_sales_report.bank_total_number_of_operation.value = commaSplit(banka_toplam_4,0);
		banka_toplam_3 = banka_toplam_3 + parseFloat(alan_banka_3.value);
		add_daily_sales_report.bank_total_puanli.value = commaSplit(banka_toplam_3);
		banka_toplam_2 = ((parseFloat(alan_banka_1.value) * parseFloat(alan_banka_6.value)) / 1000);
		banka_toplam_2 = wrk_round(banka_toplam_2);
		alan_banka_2.value = banka_toplam_2;
		banka_toplam_6 = banka_toplam_6 + banka_toplam_2;
		add_daily_sales_report.bank_total_puanli_pesin.value = commaSplit(banka_toplam_6);
		alan_banka_5.value = parseFloat(alan_banka_1.value) + parseFloat(alan_banka_3.value) - parseFloat(banka_toplam_2);
		banka_toplam_5 = banka_toplam_5 + parseFloat(alan_banka_5.value);
		add_daily_sales_report.bank_total_toplam.value = commaSplit(banka_toplam_5);
		alan_banka_1.value=commaSplit(alan_banka_1.value);
		alan_banka_2.value=commaSplit(alan_banka_2.value);
		alan_banka_3.value=commaSplit(alan_banka_3.value);
		alan_banka_4.value=commaSplit(alan_banka_4.value,0);
		alan_banka_5.value=commaSplit(alan_banka_5.value);
		alan_banka_6.value=commaSplit(alan_banka_6.value);
	}
}
/* Ödeme Hesapları Burada Yapılıyor*/
function expense_topla()
{		
	if(add_daily_sales_report.bankaya_yatan.value=="")
		add_daily_sales_report.bankaya_yatan.value = 0;
	if(add_daily_sales_report.kalan_eski.value=="")
		add_daily_sales_report.kalan_eski.value = 0;
	toplam_expense_dongu_1 = 0;
	for (var p=1;p<=row_count;p++)
		{
		deger_toplayacagim_1_1 = 0;
		deger_para_degisim = eval("document.add_daily_sales_report.money_type"+p);
		deger_para_miktarı = eval("document.add_daily_sales_report.expense_total"+p);
		alan_expense_1 = eval("document.add_daily_sales_report.payment_net_total_tax"+p);
		alan_expense_2 = eval("document.add_daily_sales_report.payment_net_total"+p);
		alan_expense_3 = eval("document.add_daily_sales_report.payment_tax"+p);
		deger_para_miktarı.value=filterNum(deger_para_miktarı.value);
		alan_expense_1.value=filterNum(alan_expense_1.value);
		alan_expense_2.value=filterNum(alan_expense_2.value);
		alan_expense_3.value=filterNum(alan_expense_3.value);
		if(deger_para_miktarı.value == "") { deger_para_miktarı.value = 0; }
		if(alan_expense_1.value == "") { alan_expense_1.value = 0; }
		if(alan_expense_2.value == "") { alan_expense_2.value = 0; }
		deger_para_degisim_1 = deger_para_degisim.value.split(',');
		deger_para_degisim_rate_ilk = deger_para_degisim_1[1];
		deger_para_degisim_rate_son = deger_para_degisim_1[2]; 
		alan_expense_1.value = (parseFloat(deger_para_miktarı.value)*alan_expense_3.value)/100;
		alan_expense_2.value = parseFloat(deger_para_miktarı.value) + parseFloat(alan_expense_1.value);
		deger_toplayacagim_1_1 = (parseFloat(eval(alan_expense_2.value)) * (parseFloat(deger_para_degisim_rate_son) / parseFloat(deger_para_degisim_rate_ilk)));
		toplam_expense_dongu_1 = toplam_expense_dongu_1 + deger_toplayacagim_1_1;		
		deger_para_miktarı.value = commaSplit(deger_para_miktarı.value);
		alan_expense_1.value = commaSplit(alan_expense_1.value);
		alan_expense_2.value = commaSplit(alan_expense_2.value);
		}
	add_daily_sales_report.summary_genel_gider.value = toplam_expense_dongu_1;
	/*toplam_expense_dongu_1= filterNum(toplam_expense_dongu_1);*/
	add_daily_sales_report.kalan_eski.value = filterNum(add_daily_sales_report.kalan_eski.value);
	add_daily_sales_report.a_given_money.value = filterNum(add_daily_sales_report.a_given_money.value);
	add_daily_sales_report.bankaya_yatan.value = filterNum(add_daily_sales_report.bankaya_yatan.value);
	add_daily_sales_report.summary_genel_nakit.value = filterNum(add_daily_sales_report.summary_genel_nakit.value);
	add_daily_sales_report.a_open_cash.value = filterNum(add_daily_sales_report.a_open_cash.value);
	add_daily_sales_report.summary_genel_gelir.value = filterNum(add_daily_sales_report.summary_genel_gelir.value);
	add_daily_sales_report.a_total.value = filterNum(add_daily_sales_report.a_total.value);
	add_daily_sales_report.a_total_credit.value = filterNum(add_daily_sales_report.a_total_credit.value);
	//kasa nakit satış + dünden kalan + gelirler - kasa kredilisatış - ödemeler - bankaya yatan 
	add_daily_sales_report.summary_genel_kalan.value = parseFloat(add_daily_sales_report.a_total.value) + parseFloat(add_daily_sales_report.kalan_eski.value) + parseFloat(add_daily_sales_report.summary_genel_gelir.value) - parseFloat(add_daily_sales_report.a_total_credit.value) - parseFloat(add_daily_sales_report.summary_genel_gider.value) - parseFloat(add_daily_sales_report.bankaya_yatan.value)
	add_daily_sales_report.a_total_credit.value = commaSplit(add_daily_sales_report.a_total_credit.value);
	add_daily_sales_report.a_total.value = commaSplit(add_daily_sales_report.a_total.value);
	add_daily_sales_report.summary_genel_gider.value = commaSplit(toplam_expense_dongu_1);
	toplam_expense_dongu_1= commaSplit(toplam_expense_dongu_1);
	add_daily_sales_report.kalan_eski.value = commaSplit(add_daily_sales_report.kalan_eski.value);
	add_daily_sales_report.a_given_money.value = commaSplit(add_daily_sales_report.a_given_money.value);
	add_daily_sales_report.bankaya_yatan.value = commaSplit(add_daily_sales_report.bankaya_yatan.value);
	add_daily_sales_report.summary_genel_nakit.value = commaSplit(add_daily_sales_report.summary_genel_nakit.value);
	add_daily_sales_report.a_open_cash.value = commaSplit(add_daily_sales_report.a_open_cash.value);
	add_daily_sales_report.summary_genel_gelir.value = commaSplit(add_daily_sales_report.summary_genel_gelir.value);
	add_daily_sales_report.summary_genel_kalan.value = commaSplit(add_daily_sales_report.summary_genel_kalan.value);
}
/* Gelir Hesapları Burada Yapılıyor */
function income_expense_topla()
{
	income_toplam_expense_dongu_1 = 0;
	for (var p=1;p<=income_row_count;p++)
		{
		income_deger_toplayacagim_1_1 = 0;
		income_deger_para_degisim = eval("document.add_daily_sales_report.income_money_type"+p);
		income_deger_para_miktarı = eval("document.add_daily_sales_report.income_expense_total"+p);
		income_alan_expense_1 = eval("document.add_daily_sales_report.income_payment_net_total_tax"+p);
		income_alan_expense_2 = eval("document.add_daily_sales_report.income_payment_net_total"+p);
		income_alan_expense_3 = eval("document.add_daily_sales_report.income_payment_tax"+p);
		income_deger_para_miktarı.value=filterNum(income_deger_para_miktarı.value);
		income_alan_expense_1.value=filterNum(income_alan_expense_1.value);
		income_alan_expense_2.value=filterNum(income_alan_expense_2.value);
		income_alan_expense_3.value=filterNum(income_alan_expense_3.value);
		if(income_deger_para_miktarı.value=="") { income_deger_para_miktarı.value = 0; }
		if(income_alan_expense_1.value=="") { income_alan_expense_1.value = 0; }
		if(income_alan_expense_2.value=="") { income_alan_expense_2.value = 0; }
		income_deger_para_degisim_1 = income_deger_para_degisim.value.split(',');
		income_deger_para_degisim_rate_ilk = income_deger_para_degisim_1[1];
		income_deger_para_degisim_rate_son = income_deger_para_degisim_1[2];
		income_alan_expense_1.value =(parseFloat(income_deger_para_miktarı.value)*income_alan_expense_3.value)/100;
		income_alan_expense_2.value = parseFloat(income_deger_para_miktarı.value) + parseFloat(income_alan_expense_1.value);
		income_deger_toplayacagim_1_1 = (parseFloat(eval(income_alan_expense_2.value)) * (parseFloat(income_deger_para_degisim_rate_son) / parseFloat(income_deger_para_degisim_rate_ilk)));
		income_toplam_expense_dongu_1 = income_toplam_expense_dongu_1 + income_deger_toplayacagim_1_1;			
		income_deger_para_miktarı.value = commaSplit(income_deger_para_miktarı.value);
		income_alan_expense_1.value = commaSplit(income_alan_expense_1.value);
		income_alan_expense_2.value = commaSplit(income_alan_expense_2.value);
		}
	add_daily_sales_report.summary_genel_gelir.value = commaSplit(income_toplam_expense_dongu_1);
	return expense_topla()
}

/* Formumuzu Submit Ederken Zorunlu Alanları Kontrol Edelim */
function gonder_temizle()
{
	if (document.getElementById("equirment_count").value == 0)
		{
			alert("<cf_get_lang no ='551.Kasa Tanımlayınız'>");
			return false;
		}
	if (document.getElementById('report_date').value == "")
	{
		alert("<cf_get_lang no ='474.Lütfen Rapor Tarihi Giriniz'> !");
		return false;
	}
	add_daily_sales_report.bug_state.value = 1;
	for (var r=1;r<=row_count;r++)
	{
		deger_row_kontrol = eval("document.add_daily_sales_report.row_kontrol"+r);
		deger_payment_type = eval("document.add_daily_sales_report.payment_type"+r);
		deger_detail = eval("document.add_daily_sales_report.detail"+r);
		if(deger_row_kontrol.value == 1)
		{
			x = deger_payment_type.selectedIndex;
			if (deger_payment_type[x].value == "")
			{ 
				alert ("<cf_get_lang no ='475.Lütfen Ödemeler Gider Kalemi Seçiniz'> !");
				return false;
			}	
			
			if (deger_detail.value == "")
			{
				alert("<cf_get_lang no ='476.Ödemeler Açıklama Girmelisiniz'> !");
				return false;
			}
		}
	}
	add_daily_sales_report.bug_state.value = 2;
	for (var r=1;r<=income_row_count;r++)
	{
		deger_income_row_kontrol = eval("document.add_daily_sales_report.income_row_kontrol"+r);
		deger_income_payment_type = eval("document.add_daily_sales_report.income_payment_type"+r);
		deger_income_detail = eval("document.add_daily_sales_report.income_detail"+r);
		if(deger_income_row_kontrol.value == 1)
		{
			x = deger_income_payment_type.selectedIndex;
			if (deger_income_payment_type[x].value == "")
			{ 
				alert ("<cf_get_lang no ='477.Lütfen Gelirler Gider Kalemi Seçiniz'> !");
				return false;
			}
			if (deger_income_detail.value == "")
			{
				alert("<cf_get_lang no ='478.Gelirler Açıklama Girmelisiniz'> !");
				return false;
			}
		}
	}
	add_daily_sales_report.bug_state.value = 3;
	add_daily_sales_report.summary_genel_kalan.value = filterNum(add_daily_sales_report.summary_genel_kalan.value);
	add_daily_sales_report.bankaya_yatan.value = filterNum(add_daily_sales_report.bankaya_yatan.value); 
	add_daily_sales_report.kalan_eski.value = filterNum(add_daily_sales_report.kalan_eski.value); 
	add_daily_sales_report.bug_state.value = 4;
	for (var g=1; g <= <cfoutput>#get_daily_sales_report.recordcount#</cfoutput>; g++)
	{
		alan_1 = eval('add_daily_sales_report.total_cash'+g);
		alan_2 = eval('add_daily_sales_report.total_credit'+g);
		alan_3 = eval('add_daily_sales_report.given_money'+g);
		alan_4 = eval('add_daily_sales_report.total'+g);
		alan_5 = eval('add_daily_sales_report.open_cash'+g);
		alan_1.value = filterNum(alan_1.value);
		alan_2.value = filterNum(alan_2.value);
		alan_3.value = filterNum(alan_3.value);
		alan_4.value = filterNum(alan_4.value);
		alan_5.value = filterNum(alan_5.value);
	}
	add_daily_sales_report.bug_state.value = 5;
	for (var h=1; h <= <cfoutput>#get_credit_payment.recordcount#</cfoutput>; h++)
	{
		alan_banka_1 = eval('add_daily_sales_report.sales_credit'+h);
		alan_banka_2 = eval('add_daily_sales_report.puanli_pesin'+h);
		alan_banka_3 = eval('add_daily_sales_report.puanli'+h);
		alan_banka_4 = eval('add_daily_sales_report.number_of_operation'+h);
		alan_banka_1.value = filterNum(alan_banka_1.value);
		alan_banka_2.value = filterNum(alan_banka_2.value);
		alan_banka_3.value = filterNum(alan_banka_3.value);
		alan_banka_4.value = filterNum(alan_banka_4.value,0);
	}
	add_daily_sales_report.bug_state.value = 6;
	for (var r=1;r<=row_count;r++)
	{
		deger_para_miktarı = eval("document.add_daily_sales_report.expense_total"+r);
		alan_expense_1 = eval("document.add_daily_sales_report.payment_net_total_tax"+r);
		alan_expense_2 = eval("document.add_daily_sales_report.payment_net_total"+r);
		deger_para_miktarı.value = filterNum(deger_para_miktarı.value);
		alan_expense_1.value = filterNum(alan_expense_1.value);
		alan_expense_2.value = filterNum(alan_expense_2.value);
	}
	add_daily_sales_report.bug_state.value = 7;
	for (var r=1;r<=income_row_count;r++)
	{
		income_deger_para_miktarı = eval("document.add_daily_sales_report.income_expense_total"+r);
		income_alan_expense_1 = eval("document.add_daily_sales_report.income_payment_net_total_tax"+r);
		income_alan_expense_2 = eval("document.add_daily_sales_report.income_payment_net_total"+r);
		income_deger_para_miktarı.value = filterNum(income_deger_para_miktarı.value);
		income_alan_expense_1.value = filterNum(income_alan_expense_1.value);
		income_alan_expense_2.value = filterNum(income_alan_expense_2.value);
	}
	add_daily_sales_report.bug_state.value = 8;
	return true;
}

function change_date()
{
	var report_date_ = js_date( date_add('d',-1,eval('add_daily_sales_report.report_date.value').toString()) );
	var listParam = report_date_ + "*" + js_date(eval('add_daily_sales_report.report_date.value').toString()) + "*" + "<cfoutput>#attributes.store_id#</cfoutput>";
	var DEVREDEN_INFO = wrk_safe_query("fin_DEVREDEN_INFO",'dsn2',0,listParam);
	if (DEVREDEN_INFO.DEVREDEN != undefined)
		document.add_daily_sales_report.kalan_eski.value = commaSplit(DEVREDEN_INFO.DEVREDEN);
	toplam_center();
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
