<cf_xml_page_edit fuseact="ehesap.popup_add_collacted_dekont">
<cfparam name="attributes.is_virtual_puantaj" default="0">
<cfif attributes.is_virtual_puantaj eq 0>
	<cfset main_puantaj_table = "EMPLOYEES_PUANTAJ">
	<cfset row_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS">
<cfelse>
	<cfset main_puantaj_table = "EMPLOYEES_PUANTAJ_VIRTUAL">
	<cfset row_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_VIRTUAL">
</cfif>
<cfquery name="get_dekont" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_PUANTAJ_CARI_ACTIONS WHERE PUANTAJ_ID = #attributes.puantaj_id# AND IS_VIRTUAL = #attributes.is_virtual_puantaj# ORDER BY DEKONT_ID DESC
</cfquery>
<cfquery name="get_dekont_rows" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_PUANTAJ_CARI_ACTIONS_ROW WHERE DEKONT_ID = #get_dekont.dekont_id#
</cfquery>
<cfquery name="GET_DEKONT_MONEY" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_PUANTAJ_CARI_ACTIONS_MONEY WHERE MONEY_TYPE = '#get_dekont.other_money#' AND ACTION_ID = #get_dekont.dekont_id#
</cfquery>
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_PUANTAJ_CARI_ACTIONS_MONEY WHERE ACTION_ID = #get_dekont.dekont_id#
</cfquery>
<cfif not GET_MONEY.recordcount>
	<cfquery name="GET_MONEY" datasource="#dsn#">
		SELECT MONEY AS MONEY_TYPE,0 AS IS_SELECTED ,* FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1
	</cfquery>
</cfif>
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT EXPENSE_ID,EXPENSE,EXPENSE_CODE FROM EXPENSE_CENTER ORDER BY EXPENSE
</cfquery>
<cfquery name="get_puantaj_total" datasource="#dsn#">
	SELECT
		SUM(EMPLOYEES_PUANTAJ_ROWS.NET_UCRET) TOTAL_AMOUNT
	FROM
		#row_puantaj_table# AS EMPLOYEES_PUANTAJ_ROWS,
		#main_puantaj_table# AS EMPLOYEES_PUANTAJ
	WHERE		
		EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID AND
		EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = #get_dekont.puantaj_id# 
</cfquery>

<cfquery name="get_p_detail" datasource="#dsn#">
	SELECT
		B.COMPANY_ID,
		EP.SAL_YEAR,
		EP.SAL_MON,
        B.BRANCH_ID
	FROM
		#main_puantaj_table# EP,
		BRANCH B
	WHERE
		EP.SSK_BRANCH_ID = B.BRANCH_ID AND
		EP.PUANTAJ_ID = #attributes.puantaj_id#
</cfquery>
<cfquery name="get_period_id" datasource="#dsn#">
	SELECT
		PERIOD_ID,
		PERIOD_YEAR
	FROM
		SETUP_PERIOD
	WHERE
		OUR_COMPANY_ID = #get_p_detail.company_id#
		AND (PERIOD_YEAR = #get_p_detail.sal_year# OR YEAR(FINISH_DATE) = #get_p_detail.sal_year#)
		AND (FINISH_DATE IS NULL OR (FINISH_DATE IS NOT NULL AND FINISH_DATE >= #createdate(get_p_detail.sal_year,get_p_detail.sal_mon,1)#))
</cfquery>
<cfset new_dsn2 = '#dsn#_#get_period_id.period_year#_#get_p_detail.COMPANY_ID#'>
<cfset new_dsn3 = '#dsn#_#get_p_detail.COMPANY_ID#'>
<!---<cfif len(get_dekont.bank_period_id) and get_dekont.bank_period_id eq get_period_id.period_id>
--->	
<cfif get_dekont.recordcount>
	<cfset multi_action_id = get_dekont.BANK_ACTION_MULTI_ID>
	<cfset bank_period_id = get_dekont.bank_period_id>
</cfif>
<!---</cfif>--->
<cfif len(get_dekont.cash_period_id)><!--- and get_dekont.cash_period_id eq get_period_id.period_id--->
	<cfset multi_action_cash_id = get_dekont.CASH_ACTION_MULTI_ID>
	<cfset cash_period_id = get_dekont.cash_period_id>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent  variable="head"><cf_get_lang dictionary_id ='29946.Ücret Dekontu'></cfsavecontent>
	<cfsavecontent  variable="icons">
		<cfoutput>
			<cfif get_module_user(19) and not listfindnocase(denied_pages,'bank.popup_add_collacted_gidenh')>
				<cfif isdefined("multi_action_id") and isdefined('bank_period_id') and len(multi_action_id) and len(bank_period_id)>
					<cfquery name="get_period_" datasource="#dsn#">
						SELECT
							PERIOD_YEAR,
							OUR_COMPANY_ID,
							PERIOD_ID
						FROM
							SETUP_PERIOD
						WHERE
							PERIOD_ID = #bank_period_id#
					</cfquery>
					<cfset new_dsn2_ = '#dsn#_#get_period_.period_year#_#get_period_.OUR_COMPANY_ID#'>
					<cfset new_dsn3_ = '#dsn#_#get_period_.OUR_COMPANY_ID#'>
					<li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=bank.form_add_gidenh&event=updMulti&multi_id=#multi_action_id#&is_virtual_puantaj=#attributes.is_virtual_puantaj#&new_period_id=#get_period_.period_id#&puantaj_id=#attributes.puantaj_id#&new_dsn2=#new_dsn2_#&new_dsn3=#new_dsn3_#','wide');"><i class="fa fa-bank" title="<cf_get_lang dictionary_id='64906.Giden Havale Güncelle'>"></i></a></li>
				<cfelse>
					<li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=bank.form_add_gidenh&event=addMulti&is_virtual_puantaj=#attributes.is_virtual_puantaj#&puantaj_id=#attributes.puantaj_id#&new_period_id=#get_period_id.period_id#&new_dsn2=#new_dsn2#&new_dsn3=#new_dsn3#','wide');"><i class="fa fa-bank" title="<cf_get_lang dictionary_id='48759.Giden Havale Ekle'>"></i></a></li>
				</cfif>
			</cfif>
			<cfif get_module_user(18) and not listfindnocase(denied_pages,'cash.popup_add_collacted_payment')>
				<cfif isdefined("multi_action_cash_id")>
					<cfquery name="get_period_" datasource="#dsn#">
						SELECT
							PERIOD_YEAR,
							OUR_COMPANY_ID,
							PERIOD_ID
						FROM
							SETUP_PERIOD
						WHERE
							PERIOD_ID = #cash_period_id#
					</cfquery>
					<cfset new_dsn2_ = '#dsn#_#get_period_.period_year#_#get_period_.OUR_COMPANY_ID#'>
					<cfset new_dsn3_ = '#dsn#_#get_period_.OUR_COMPANY_ID#'>
					<li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=cash.form_add_cash_payment&event=updMulti&multi_id=#multi_action_cash_id#&is_virtual_puantaj=#attributes.is_virtual_puantaj#&new_period_id=#get_period_.period_id#&puantaj_id=#attributes.puantaj_id#&new_dsn2=#new_dsn2_#&new_dsn3=#new_dsn3_#','wide');"><i class="fa fa-money" title="<cf_get_lang dictionary_id='64907.Ödeme Güncelle'>"></i></a></li>
				<cfelse>
					<li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=cash.form_add_cash_payment&event=addMulti&is_virtual_puantaj=#attributes.is_virtual_puantaj#&puantaj_id=#attributes.puantaj_id#&new_period_id=#get_period_id.period_id#&new_dsn2=#new_dsn2#&new_dsn3=#new_dsn3#','wide');"><i class="fa fa-money" title="<cf_get_lang dictionary_id='47175.Ödeme Ekle'>"></i></a></li>
				</cfif>
			</cfif>
		</cfoutput>
	</cfsavecontent>
	<cf_box title="#head#" right_images="#icons#">
		<cfform name="upd_dekont" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_upd_collacted_dekont">
			<cf_basket_form id="collacted_dekont">
				<cf_box_elements>
					<input type="hidden" name="is_virtual" id="is_virtual" value="<cfoutput>#attributes.is_virtual_puantaj#</cfoutput>">
					<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
					<input type="hidden" name="puantaj_id" id="puantaj_id" value="<cfoutput>#get_dekont.puantaj_id#</cfoutput>">
					<input type="hidden" name="dekont_id" id="dekont_id" value="<cfoutput>#get_dekont.dekont_id#</cfoutput>">
					<cfif len(get_dekont.puantaj_id)>
						<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#get_p_detail.branch_id#</cfoutput>">
					<cfelse>
						<input type="hidden" name="branch_id" id="branch_id" value="<cfif isdefined("attributes.branch_id")><cfoutput>#attributes.branch_id#</cfoutput></cfif>">
					</cfif>
					<input type="hidden" name="sal_year" id="sal_year" value="<cfoutput>#attributes.sal_year#</cfoutput>">
					<input type="hidden" name="xml_code_control" id="xml_code_control" value="<cfoutput>#xml_code_control#</cfoutput>">
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
						<div class="form-group">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'> *</label>
							<div class="col col-8 col-xs-12"><cf_workcube_process_cat process_cat='#get_dekont.process_cat#' slct_width="140"></div>
						</div>
						<div class="form-group">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57880.Belge No'> *</label>
							<div class="col col-8 col-xs-12"><input type="text" name="paper_no" id="paper_no" style="width:130px;" value="<cfoutput>#get_dekont.paper_no#</cfoutput>"></div>
						</div>
						<div class="form-group">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-8 col-xs-12"><textarea name="action_detail" id="action_detail" style="width:130px;height:45px;"><cfoutput>#get_dekont.action_detail#</cfoutput></textarea></div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
						<div class="form-group">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57879.İşlem Tarihi'> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57906.İşlem Tarihi Girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="action_date" value="#dateformat(get_dekont.action_date,dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#" style="width:120px;">
									<span class="input-group-addon"><cf_wrk_date_image date_field="action_date"></span>
								</div>
							</div>
						</div>
						<div class="form-group">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58586.İşlem Yapan'> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="action_employee_id" id="action_employee_id" value="<cfoutput>#get_dekont.employee_id#</cfoutput>">
									<input type="text" name="action_employee_name" id="action_employee_name" style="width:140px;" value="<cfoutput>#get_emp_info(get_dekont.employee_id,0,0)#</cfoutput>">
									<span class="input-group-addon" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_dekont.action_employee_id&field_name=upd_dekont.action_employee_name&select_list=1','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></span>
								</div>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_record_info query_name="get_dekont">
					<cfsavecontent variable="del_message"><cf_get_lang dictionary_id = '61034.İlişkili toplu giden havale varsa silinecektir.'><cf_get_lang dictionary_id = '57533.Silmek istediğinizden emin misiz?'></cfsavecontent>
					<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_collacted_dekont&puantaj_id=#get_dekont.puantaj_id#&dekont_id=#get_dekont.dekont_id#&process_type=#get_dekont.process_type#' add_function='kontrol()' delete_alert='#del_message#'></td>
				</cf_box_footer>
			</cf_basket_form>
			<cf_basket id="collacted_dekont_bask">
				<cf_grid_list sort="0" id="table1">
					<thead>
						<tr>
							<th width="20">
								<input name="record_num" id="record_num" type="hidden" value="<cfoutput>#get_dekont_rows.recordcount#</cfoutput>">
								<a href="javascript://" title="Ekle" onClick="add_row();"><i class="fa fa-plus"></i>
							</th>
							<th style="min-width:200px" nowrap><cf_get_lang dictionary_id ='53363.Çalışan Hesap'></th>
							<cfif x_show_exp_center neq 0>
								<th style="min-width:142px"><cf_get_lang dictionary_id='58460.Masraf Merkezi'> <cfif x_show_exp_center eq 2>*</cfif></th>
							</cfif>
							<cfif x_show_exp_item neq 0>
								<th style="min-width:140px"><cf_get_lang dictionary_id='58551.Gider Kalemi'> <cfif x_show_exp_center eq 2>*</cfif></th>
							</cfif>
							<th style="min-width:100px"><cf_get_lang dictionary_id='57673.Tutar'></th>
							<th style="min-width:100px"><cf_get_lang dictionary_id ='53364.Döviz Tutar'></th>
						</tr>
					</thead>
					<cfset toplam_tutar = 0>
					<cfset item_id_list=''>
					<cfoutput query="get_dekont_rows">
					<cfif len(EXPENSE_ITEM_ID) and not listfind(item_id_list,EXPENSE_ITEM_ID)>
					<cfset item_id_list=listappend(item_id_list,EXPENSE_ITEM_ID)>
					</cfif>
					</cfoutput>
					<cfif len(item_id_list)>
					<cfset item_id_list=listsort(item_id_list,"numeric","ASC",",")>
					<cfquery name="get_exp_detail" datasource="#dsn2#">
						SELECT EXPENSE_ITEM_NAME,ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (#item_id_list#) ORDER BY EXPENSE_ITEM_ID
					</cfquery>
					</cfif>
					<cfoutput query="get_dekont_rows">
						<tr id="frm_row#currentrow#" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';">
							<td><input  type="hidden"  value="1"  name="row_kontrol#currentrow#" id="row_kontrol#currentrow#"><a href="javascript://" onClick="sil('#currentrow#');"  ><i class="fa fa-minus"></i></a></td>
							<td nowrap>
								<cfset emp_id = get_dekont_rows.employee_id>
								<cfif len(get_dekont_rows.acc_type_id)>
									<cfset emp_id = "#emp_id#_#get_dekont_rows.acc_type_id#">
								</cfif>
								<div class="form-group">
									<div class="input-group">
										<input type="hidden" name="is_tax_refund#currentrow#" id="is_tax_refund#currentrow#" value="#is_tax_refund#"><!---agi oldugunu belirten parametre--->
										<input type="hidden" name="in_out_id#currentrow#" id="in_out_id#currentrow#" value="#in_out_id#"><input type="hidden" name="employee_id#currentrow#" id="employee_id#currentrow#" value="#emp_id#">
										<input type="text" name="employee_name#currentrow#" id="employee_name#currentrow#" value="#get_emp_info(employee_id,0,0,0,get_dekont_rows.acc_type_id)#" class="boxtext" style="width:185px;" readonly><span class="input-group-addon" onClick="pencere_ac_employee('#currentrow#');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></span>
									</div>
								</div>										
							</td>
							<cfif x_show_exp_center neq 0>
								<td>
									<div class="form-group">
										<select name="expense_center#currentrow#" id="expense_center#currentrow#" style="width:150px;" class="boxtext">
											<option value=""><cf_get_lang dictionary_id ='53365.Masraf/Gelir Merkezi'></option>
											<cfset deger_expense = expense_center_id>
											<cfloop query="get_expense_center">
												<option value="#expense_id#" <cfif deger_expense eq get_expense_center.expense_id>selected</cfif>>#expense#</option>
											</cfloop>
										</select>
									</div>
								</td>
							</cfif>
							<cfif x_show_exp_item neq 0>
								<td nowrap="nowrap">
									<div class="form-group">
										<div class="input-group">
											<input type="hidden" name="expense_item_id#currentrow#" id="expense_item_id#currentrow#" value="#expense_item_id#">
											<input type="text" name="expense_item_name#currentrow#" id="expense_item_name#currentrow#"  value="<cfif len(expense_item_id)>#get_exp_detail.EXPENSE_ITEM_NAME[listfind(item_id_list,EXPENSE_ITEM_ID,',')]#</cfif>" style="width:130px;" class="boxtext">
											<span class="input-group-addon" onclick="pencere_ac_exp('#currentrow#');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></span>
										</div>
									</div>
								</td>
							</cfif>
							<td><div class="form-group"><input type="text" name="action_value#currentrow#" id="action_value#currentrow#"  onkeyup="return(FormatCurrency(this,event));" style="width:100px;" class="box" value="#tlformat(action_value)#" onBlur="hesapla(#currentrow#);"></div></td>
							<td><div class="form-group"><input type="text" name="other_action_value#currentrow#" id="other_action_value#currentrow#"  readonly style="width:105px;" class="box" value="#tlformat(other_action_value)#"></div></td>
						</tr>
					</cfoutput>
				</cf_grid_list>
				<cf_basket_footer height="100">
					<div class="ui-row">
						<div id="sepetim_total" class="padding-0">
							<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
								<div class="totalBox">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"> <cf_get_lang dictionary_id='57677.Dövizler'> </span>
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="totalBoxBody">
										<table>
											<cfoutput>
											<input id="kur_say" type="hidden" name="kur_say" id="kur_say" value="#get_money.recordcount#">
											<cfloop query="get_money">
												<tr>
													<td>
														<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money_type#">
														<input type="radio" name="rd_money_" id="rd_money_" value="#money_type#" onClick="toplam_hesapla();" <cfif get_dekont.other_money eq money_type>checked</cfif>>
													</td>
													<td>#money_type#</td>
													<td><input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">#TLFormat(rate1,0)#/</td>
													<td><input type="text" class="box" id="txt_rate2_#currentrow#" name="txt_rate2_#currentrow#" <cfif money_type eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" style="width:100%;" onKeyUp="return(FormatCurrency(this,event,'#session.ep.our_company_info.rate_round_num#'));" onBlur="toplam_hesapla();"></td>
												</tr>
											</cfloop>
											</cfoutput>
										</table>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<div class="totalBox">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"> <cf_get_lang dictionary_id='57492.Total'> </span>
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="totalBoxBody">       
										<table>
											<tr>
												<td><cf_get_lang dictionary_id ='53366.Puantaj Toplam'></td>
												<td style="text-align:right;">
													<input type="text" name="total_amount_puantaj" id="total_amount_puantaj" class="box" readonly="" value="<cfoutput>#tlformat(get_puantaj_total.total_amount)#</cfoutput>">
													<input type="text" name="tl_value_puantaj" id="tl_value_puantaj" class="box" readonly="" value="<cfoutput>#session.ep.money#</cfoutput>" style="width:40px;">
												</td>
											</tr>
											<tr>
												<td><cf_get_lang dictionary_id ='53367.Dekont Toplam'></td>
												<td style="text-align:right;">
													<input type="text" name="total_amount" id="total_amount" class="box" readonly="" value="<cfoutput>#tlformat(get_dekont.action_value)#</cfoutput>">
													<input type="text" name="tl_value" id="tl_value" class="box" readonly="" value="<cfoutput>#session.ep.money#</cfoutput>" style="width:40px;">
												</td>
											</tr>
										</table>
									</div>
								</div>
							</div>
							<div class="col col-5 col-md-5 col-sm-5 col-xs-12">
								<div class="totalBox">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"><cf_get_lang dictionary_id='58124.Foreign Currency Total'> </span>
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="totalBoxBody">       
										<table>
											<tr>
												<td><cf_get_lang dictionary_id ='53368.Pauntaj Döviz Toplam'></td>
												<td style="text-align:right;">
													<input type="text" name="other_puantaj_amount" id="other_puantaj_amount" class="box" readonly="" value="<cfoutput><cfif len(get_puantaj_total.total_amount)>#tlformat(get_puantaj_total.total_amount/GET_DEKONT_MONEY.rate2)#<cfelse>0</cfif></cfoutput>">&nbsp;
													<input type="text" name="tl_value1_puantaj" id="tl_value1_puantaj" class="box" readonly="" value="<cfoutput>#get_dekont.other_money#</cfoutput>" style="width:40px;">
												</td>
											</tr>
											<tr>
												<td><cf_get_lang dictionary_id ='53369.Dekont Döviz Toplam'></td>
												<td style="text-align:right;">
													<input type="text" name="other_total_amount" id="other_total_amount" class="box" readonly="" value="<cfoutput>#tlformat(get_dekont.other_action_value)#</cfoutput>">&nbsp;
													<input type="text" name="tl_value1" id="tl_value1" class="box" readonly="" value="<cfoutput>#get_dekont.other_money#</cfoutput>" style="width:40px;">
												</td>
											</tr>
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>
				</cf_basket_footer>
			</cf_basket>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	row_count=<cfoutput>#get_dekont_rows.recordcount#</cfoutput>;
	record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
	function kontrol()
	{
		say=1;
		if(!chk_process_cat('upd_dekont')) return false;
		if(!check_display_files('upd_dekont')) return false;
		if(document.upd_dekont.paper_no.value=="")
		{
			alert("<cf_get_lang dictionary_id='58556.Belge No Giriniz'>!");
			return false;
		}
		if(document.upd_dekont.action_employee_name.value=="" || document.upd_dekont.action_employee_id.value=="")
		{
			alert("<cf_get_lang dictionary_id ='53371.İşlem Yapan Seçiniz'>!");
			return false;
		}
		for(r=1;r<=upd_dekont.record_num.value;r++)
		{
			if(eval("document.upd_dekont.row_kontrol"+r).value == 1)
			{
				record_exist=1;
				if (eval("document.upd_dekont.employee_name"+r).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id ='53372.Lütfen Satırda Çalışan Hesap Seçiniz'>! <cf_get_lang dictionary_id ='58508.Satır'>:"+ say);
					return false;
				}
				<cfif x_show_exp_center eq 2>
					if (eval("document.upd_dekont.expense_center"+r).value == "")
					{ 
						alert ("<cf_get_lang dictionary_id ='53373.Lütfen Masraf Merkezi Seçiniz'>! <cf_get_lang dictionary_id ='58508.Satır'>:"+ say);
						return false;
					}
				</cfif>
				<cfif x_show_exp_item eq 2>
					if (eval("document.upd_dekont.expense_item_name"+r).value == "")
					{ 
						alert ("<cf_get_lang dictionary_id ='53374.Lütfen Gider Kalemi Seçiniz'>! <cf_get_lang dictionary_id ='58508.Satır'>:"+ say);
						return false;
					}
				</cfif>
				if ((eval("document.upd_dekont.action_value"+r).value == "")||(eval("document.upd_dekont.action_value"+r).value ==0))
				{ 
					alert ("<cf_get_lang dictionary_id='29535.Lutfen Tutar Giriniz'> <cf_get_lang dictionary_id ='58508.Satır'>:"+ say);
					return false;
				}
				say++;
			}
		}
		if (record_exist == 0) 
			{
				alert("<cf_get_lang dictionary_id ='53376.Lütfen Satır Giriniz'>!");
				return false;
			}
		return true;
	}
	function sil(sy)
	{
		var my_element=eval("upd_dekont.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		toplam_hesapla();
	}
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;	
		document.upd_dekont.record_num.value=row_count;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		newRow.className = 'color-row';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" ><a href="javascript://" onclick="sil(' + row_count + ');"  ><i class="fa fa-minus"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="employee_id'+ row_count +'" value=""><input type="text" style="width:185px;" name="employee_name'+ row_count +'" value="" class="boxtext"><span class="input-group-addon" onClick="pencere_ac_employee('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></span></div></div>';
		<cfif x_show_exp_center neq 0>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><select name="expense_center' + row_count  +'" style="width:150px;" class="boxtext"><option value=""><cf_get_lang dictionary_id ="53365.Masraf/Gelir Merkezi"></option><cfoutput query="get_expense_center"><option value="#expense_id#">#expense#</option></cfoutput></select></div>';
		</cfif>
		<cfif x_show_exp_item neq 0>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" name="expense_item_id' + row_count +'" ><input type="text" readonly="yes" style="width:133px;" name="expense_item_name' + row_count +'" class="boxtext"><span class="input-group-addon"><img src="/images/plus_thin.gif" onclick="pencere_ac_exp('+ row_count +');" align="absmiddle" border="0"></span></div></div>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="action_value' + row_count +'" value=""  style="width:100%;" class="box" onBlur="hesapla('+row_count+');" onkeyup="return(FormatCurrency(this,event));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="other_action_value' + row_count +'" style="width:100%;" class="box" readonly></div>';
	}
	function hesapla(satir)
	{
		if(eval("document.upd_dekont.row_kontrol"+satir).value==1)
		{
			deger_total =  filterNum(eval("document.upd_dekont.action_value"+satir).value);//tutar
			for(i=1;i<=upd_dekont.kur_say.value;i++)
			{
				if(document.upd_dekont.rd_money_[i-1].checked == true)
				{
					form_txt_rate2 = filterNum(eval("document.upd_dekont.txt_rate2_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					eval('upd_dekont.other_action_value'+satir).value = commaSplit(deger_total/form_txt_rate2);
				}
			}
		}
		toplam_hesapla();
	}
	function toplam_hesapla()
	{
		for (var t=1; t<=upd_dekont.kur_say.value; t++)
		{		
			if(document.upd_dekont.rd_money_[t-1].checked == true)
			{
				for(k=1;k<=upd_dekont.record_num.value;k++)
				{		
					deger_diger_para = document.upd_dekont.rd_money_[t-1].value;
					rate2_value = filterNum(eval("document.upd_dekont.txt_rate2_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					eval('upd_dekont.other_action_value'+k).value = commaSplit(filterNum(eval('upd_dekont.action_value'+k).value)/rate2_value);
				}
			}
		}
		var total_amount = 0;
		var other_total_amount = 0;
		for(j=1;j<=upd_dekont.record_num.value;j++)
		{		
			if(eval("document.upd_dekont.row_kontrol"+j).value==1)
			{
				total_amount += parseFloat(filterNum(eval('upd_dekont.action_value'+j).value));
			}
		}
		other_total_amount = total_amount/rate2_value;
		upd_dekont.other_puantaj_amount.value = commaSplit(filterNum(upd_dekont.total_amount_puantaj.value)/rate2_value);
		upd_dekont.tl_value1_puantaj.value = deger_diger_para;
		upd_dekont.tl_value1.value = deger_diger_para;
		upd_dekont.total_amount.value = commaSplit(total_amount);
		upd_dekont.other_total_amount.value = commaSplit(other_total_amount);
	}
	toplam_hesapla();
	function pencere_ac_exp(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=upd_dekont.expense_item_id' + no +'&field_name=upd_dekont.expense_item_name' + no +'','list');
	}
	function pencere_ac_employee(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&is_cari_action=1&field_emp_id=upd_dekont.employee_id' + no +'&field_name=upd_dekont.employee_name' + no +'&select_list=1','list');
	}
</script>
