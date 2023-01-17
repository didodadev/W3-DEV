<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT 
    	MONEY_ID, 
        MONEY, 
        RATE1, 
        RATE2, 
        MONEY_STATUS, 
        PERIOD_ID, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP
    FROM 
    	SETUP_MONEY
    WHERE 
	    PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_TAX" datasource="#dsn2#">
	SELECT 
        TAX, 
        DETAIL,
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
	    SETUP_TAX 
    ORDER BY 
    	TAX
</cfquery>
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT 
    	EXPENSE_ID,
   		EXPENSE,
    	EXPENSE_CODE 
    FROM 
	    EXPENSE_CENTER 
    ORDER BY 
    	EXPENSE
</cfquery>
<cf_papers paper_type="stock_fis">
<cfif isdefined("paper_full") and isdefined("paper_number")>
	<cfset system_paper_no = paper_full>
	<cfset system_paper_no_add = paper_number>
<cfelse>
	<cfset system_paper_no = "">
	<cfset system_paper_no_add = "">
</cfif>

<cf_catalystHeader>
<cf_box>
	<cfform name="add_invent" method="post" action="#request.self#?fuseaction=invent.emptypopup_add_invent_stock_fis_return" onsubmit="return(unformat_fields());">
		<cf_basket_form id="invent_stock_fis_return">
			<cf_box_elements>
				<div class="row" type="row">
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-process_cat">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'> *</label>
							<div class="col col-8 col-xs-12">
								<cf_workcube_process_cat slct_width="120">
							</div>
						</div>
						<div class="form-group" id="item-fis_number">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57946.Fiş No'> *</label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message1"><cf_get_lang dictionary_id='57946.Fiş No'></cfsavecontent>
								<cfinput type="text" name="fis_number" value="#system_paper_no#" readonly="yes" maxlength="50" required="yes" message="#message1#">
							</div>
						</div>
						<div class="form-group" id="item-ref_no">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58794.Ref No'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="ref_no" id="ref_no" value="" style="width:120px;">
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-start_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message3"><cf_get_lang dictionary_id='57742.Tarih'></cfsavecontent>
									<cfinput type="text" name="start_date" validate="#validate_style#" required="yes" message="#message3#" value="#dateformat(now(),dateformat_style)#" maxlength="10" style="width:120px;" onblur="change_money_info('add_invent_stock_fis','start_date');">
									<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date" call_function="change_money_info"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-giris_depo">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56969.Giriş Depo'> *</label>
							<div class="col col-8 col-xs-12">
								<cf_wrkdepartmentlocation
									returnInputValue="location_id,department_name,department_id,branch_id"
									returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
									fieldName="department_name"
									fieldid="location_id"
									department_fldId="department_id"
									branch_fldId="branch_id"
									user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
									line_info = 1
									width="120">
							</div>
						</div>
						<div class="form-group" id="item-cikis_depo">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29428.Çıkış Depo'></label>
							<div class="col col-8 col-xs-12">
								<cf_wrkdepartmentlocation
									returnInputValue="location_id_2,department_name_2,department_id_2,branch_id_2"
									returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
									fieldName="department_name_2"
									fieldid="location_id_2"
									department_fldId="department_id_2"
									branch_fldId="branch_id_2"
									user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
									line_info = 2
									width="120">
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="item-deliver_get">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57775.Teslim Alan'> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="deliver_get_id" id="deliver_get_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57775.Teslim Alan'> <cf_get_lang dictionary_id='57613.Girmelsiniz'></cfsavecontent>
									<cfinput type="text" name="deliver_get" required="yes" message="#message#" style="width:120px;" readonly="yes" value="#session.ep.name# #session.ep.surname#">
									<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57775.Teslim Alan'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=add_invent.deliver_get&field_emp_id2=add_invent.deliver_get_id</cfoutput>');"></span>
								</div>
							</div>
						</div>
						<cfif session.ep.our_company_info.project_followup eq 1>
							<div class="form-group" id="item-project">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cf_wrk_projects form_name='add_invent_stock_fis' project_id='project_id' project_name='project_head'>
										<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.pj_id')><cfoutput>#attributes.pj_id#</cfoutput></cfif>">
										<input type="text" name="project_head" id="project_head" value="<cfif isdefined('attributes.pj_id') and  len(attributes.pj_id)><cfoutput>#GET_PROJECT_NAME(attributes.pj_id)#</cfoutput></cfif>" onkeyup="get_project_1();" style="width:120px;">
										<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57416.Proje'>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_invent_stock_fis.project_id&project_head=add_invent_stock_fis.project_head');"></span>
									</div>
								</div>
							</div>
						</cfif>
						<cfif session.ep.our_company_info.subscription_contract eq 1>
							<div class="form-group" id="item-subscription_no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59774.Sistem No'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="subscription_id" id="subscription_id" value="<cfif isdefined("attributes.subscription_id")><cfoutput>#attributes.subscription_id#</cfoutput></cfif>">
										<input type="text" name="subscription_no" id="subscription_no" value="<cfif isdefined("attributes.subscription_no")><cfoutput>#attributes.subscription_no#</cfoutput></cfif>" style="width:120px;" onFocus="AutoComplete_Create('subscription_no','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO','get_subscription','2','SUBSCRIPTION_ID','subscription_id','','2','100');" autocomplete="off">
										<cfset str_subscription_link="field_partner=&field_id=add_invent.subscription_id&field_no=add_invent.subscription_no">
										<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='59774.Sistem No'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_subscription&#str_subscription_link#'</cfoutput>);"></span>
									</div>
								</div>
							</div>
						</cfif>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
						<div class="form-group" id="item-detail">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-8 col-xs-12">
								<textarea name="detail" id="detail"></textarea>
							</div>
						</div>
					</div>
				</div>
				<div class="row formContentFooter">
					<div class="col col-12">
						<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
					</div>
				</div>
			</cf_box_elements>
		</cf_basket_form>
		<cf_basket id="invent_stock_fis_return_bask">
			<cf_grid_list id="table1">
				<thead>
					<tr>
						<th><input name="record_num" id="record_num" type="hidden" value="0"><a onClick="f_add_invent();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='58878.Demirbaş No'>&nbsp;</th>
						<th nowrap="nowrap" width="180"><cf_get_lang dictionary_id='57629.Açıklama'>&nbsp;</th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='57635.Miktar'>&nbsp;</th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='57638.Birim Fiyat'>&nbsp;</th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='57639.KDV'> % &nbsp;</th>
						<th width="60"  nowrap class="form-title" style="text-align:right;">&nbsp;<cf_get_lang dictionary_id='57639.KDV'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='58083.Net'><cf_get_lang dictionary_id='58084.Fiyat'>&nbsp;</th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='58083.Net'><cf_get_lang dictionary_id='56994.Döviz Fiyat'>&nbsp;</th>
						<th nowrap="nowrap" width="60"><cf_get_lang dictionary_id='57677.Döviz'>&nbsp;</th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='58456.Oran'>&nbsp;</th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='29420.Amortisman Yöntemi'>&nbsp;</th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'>&nbsp;</th>
						<th nowrap="nowrap" width="125"><cf_get_lang dictionary_id='56909.Son Değer'>&nbsp;</th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='56966.Gelir/Gider'><cf_get_lang dictionary_id='56964.Farkı'>&nbsp;</th>
						<th nowrap="nowrap" width="125"><cf_get_lang dictionary_id='58460.Masraf Merkezi'>&nbsp;</th>
						<th nowrap="nowrap" width="125"><cf_get_lang dictionary_id='58234.Bütçe Kalemi'>&nbsp;</th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='56966.Gelir/Gider'><cf_get_lang dictionary_id='58811.Muhasebe Kodu'>&nbsp;</th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='56963.Amortisman'><cf_get_lang dictionary_id='56962.Karşılık'><cf_get_lang dictionary_id='58811.Muhasebe Kodu'>&nbsp;</th>
						<th nowrap width="125"><cf_get_lang dictionary_id='57452.Stok'>&nbsp;</th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='56990.Stok Birimi'>&nbsp;</th>
					</tr>
				</thead>
				<tbody></tbody>
			</cf_grid_list>
			<div class="ui-row">
				<div id="sepetim_total" class="padding-0">
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
						<div class="totalBox">
							<div class="totalBoxHead font-grey-mint">
								<span class="headText"><cf_get_lang dictionary_id='57677.Dövizler'> </span>
								<div class="collapse">
									<span class="icon-minus"></span>
								</div>
							</div>
							<div class="totalBoxBody">
								<table>
									<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money.recordcount#</cfoutput>">
									<cfquery name="get_standart_process_money" datasource="#dsn#"><!--- muhasebe doneminden standart islem dövizini alıyor --->
										SELECT 
											PERIOD_ID, 
											PERIOD, 
											OTHER_MONEY, 
											STANDART_PROCESS_MONEY, 
											RECORD_DATE, 
											RECORD_IP, 
											RECORD_EMP, 
											UPDATE_DATE, 
											UPDATE_IP, 
											UPDATE_EMP, 
											PROCESS_DATE 
										FROM 
											SETUP_PERIOD 
										WHERE 
											PERIOD_ID = #session.ep.period_id#
									</cfquery>
									<cfoutput>
										<cfif IsQuery(get_standart_process_money) and len(get_standart_process_money.STANDART_PROCESS_MONEY)>
											<cfset selected_money=get_standart_process_money.STANDART_PROCESS_MONEY>
										<cfelseif len(session.ep.money2)>
											<cfset selected_money=session.ep.money2>
										<cfelse>
											<cfset selected_money=session.ep.money>
										</cfif>
										<cfloop query="get_money">
											<tr>
												<td>
													<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
													<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
													<input type="radio" name="rd_money" id="rd_money" value="#money#,#currentrow#,#rate1#,#rate2#" onClick="toplam_hesapla();" <cfif selected_money eq money>checked</cfif>>#money#
												</td>
												<cfif session.ep.rate_valid eq 1>
													<cfset readonly_info = "yes">
												<cfelse>
													<cfset readonly_info = "no">
												</cfif>
												<td>
													#TLFormat(rate1,0)#/<input type="text" <cfif readonly_info>readonly</cfif> class="box" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" <cfif money eq session.ep.money>readonly="yes"</cfif> style="width:50px;" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="toplam_hesapla();">
												</td>
											</tr>
										</cfloop>
									</cfoutput>
								</table>
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
						<div class="totalBox">
							<div class="totalBoxHead font-grey-mint">
								<span class="headText"> <cf_get_lang dictionary_id='57492.Toplam'> </span>
								<div class="collapse">
									<span class="icon-minus"></span>
								</div>
							</div>
							<div class="totalBoxBody">
								<table>
									<tr>
										<td height="20" class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
										<td style="text-align:right;">
											<input type="text" name="total_amount" id="total_amount" class="box" readonly="" value="0">&nbsp;&nbsp;<cfoutput>#session.ep.money#</cfoutput>
										</td>
									</tr>
									<tr>
										<td class="txtbold"><cf_get_lang dictionary_id ='57643.KDV Toplam'></td>
										<td style="text-align:right;"><input type="text" name="kdv_total_amount" id="kdv_total_amount" class="box" value="0"  readonly>&nbsp;&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
									</tr>
									<tr>
										<td class="txtbold" ><cf_get_lang dictionary_id ='57678.Fatura Altı İndirim'></td>
										<td style="text-align:right;"><input type="text" name="net_total_discount" id="net_total_discount" class="box" value="0" onBlur="toplam_hesapla();" onkeyup="return(FormatCurrency(this,event));">&nbsp;&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
									</tr>
									<tr>
										<td class="txtbold" ><cf_get_lang dictionary_id='56975.KDV li Toplam'></td>
										<td style="text-align:right;"><input type="text" name="net_total_amount" id="net_total_amount" class="box" readonly="" value="0">&nbsp;&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
									</tr>
								</table>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
						<div class="totalBox">
							<div class="totalBoxHead font-grey-mint">
								<span class="headText"> <cf_get_lang dictionary_id="58124.Döviz Toplam"> </span>
								<div class="collapse">
									<span class="icon-minus"></span>
								</div>
							</div>
							<div class="totalBoxBody" id="totalAmountList">  
								<table>
									<tr>
										<td class="txtbold"><cf_get_lang dictionary_id='58124.Döviz Toplam'></td>
										<td id="rate_value1" style="text-align:right;">
											<input type="text" name="other_total_amount" id="other_total_amount" class="box" readonly="" value="0">&nbsp;
											<input type="text" name="tl_value1" id="tl_value1" class="box" readonly="" value="<cfoutput>#selected_money#</cfoutput>" style="width:40px;">
										</td>
									</tr>
									<tr>
										<td class="txtbold"><cf_get_lang dictionary_id='56961.Döviz KDV Toplam'></td>
										<td style="text-align:right;"><input type="text" name="other_kdv_total_amount" id="other_kdv_total_amount" class="box" readonly value="0">&nbsp;
										<input type="text" name="tl_value2" id="tl_value2" class="box" readonly="" value="<cfoutput>#selected_money#</cfoutput>" style="width:40px;"></td>
									</tr>
									<tr>
										<td class="txtbold"><cf_get_lang dictionary_id ='57678.Fatura Altı İndirim'><cf_get_lang dictionary_id ='57677.Döviz'></td>
										<td style="text-align:right;"><input type="text" name="other_net_total_discount" id="other_net_total_discount" class="box" readonly value="0">&nbsp;
										<input type="text" name="tl_value4" id="tl_value4" class="box" readonly="" value="<cfoutput>#selected_money#</cfoutput>" style="width:40px;"></td>
									</tr>
									<tr>
										<td class="txtbold"><cf_get_lang dictionary_id='56993.Döviz KDV li Toplam'></td>
										<td id="rate_value3" style="text-align:right;"><input type="text" name="other_net_total_amount" id="other_net_total_amount" class="box" readonly="" value="0">&nbsp;
										<input type="text" name="tl_value3" id="tl_value3" class="box" readonly="" value="<cfoutput>#selected_money#</cfoutput>" style="width:40px;"></td>
									</tr>
								</table>
							</div>
						</div>
					</div>
					<div class="col col-2 col-md-4 col-sm-6 col-xs-12">
						<table>
								<tr>
									<td colspan="2" width="190">
										<input type="checkbox" name="tevkifat_box" id="tevkifat_box" onClick="gizle_goster(tevkifat_oran);gizle_goster(tevkifat_plus);gizle_goster(tevk_1);gizle_goster(tevk_2);gizle_goster(beyan_1);gizle_goster(beyan_2);toplam_hesapla();">
										<b><cf_get_lang dictionary_id='58022.Tevkfat'></b>
										<input type="text" name="tevkifat_oran" id="tevkifat_oran" value="" readonly style="display:none;width:35px;" onBlur="toplam_hesapla();">
										<a style="display:none;cursor:pointer" id="tevkifat_plus" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_tevkifat_rates&field_tevkifat_rate=add_invent.tevkifat_oran&field_tevkifat_rate_id=add_invent.tevkifat_oran_id&call_function=toplam_hesapla()</cfoutput>','small')"> <img src="images/plus_thin.gif" border="0" align="absmiddle"></a>
									</td>
								</tr>
								<tr>
									<td id="tevk_1" style="display:none"><b><cf_get_lang dictionary_id ='58022.Tevkifat'>:</b></td>
									<td id="tevk_2" style="display:none" nowrap="nowrap"><div id="tevkifat_text"></div></td>
								</tr>
								<tr>
									<td id="beyan_1" style="display:none"><b><cf_get_lang dictionary_id ='58024.Beyan Edilen'>:</b></td>
									<td id="beyan_2" style="display:none" nowrap="nowrap"><div id="beyan_text"></div></td>
								</tr>
							</table>
					</div>
				</div>
			</div>
		</cf_basket>
	</cfform>
</cf_box>
<script type="text/javascript">
	record_exist=0;
	function kontrol()
	{
		if (!chk_process_cat('add_invent')) return false;
		if(!check_display_files('add_invent')) return false;
		if(add_invent.department_id.value=="")
		{
			alert("<cf_get_lang dictionary_id='56984.Departman Seçiniz'>!");
			return false;
		}
		//change_paper_duedate('invoice_date');
		for(r=1;r<=add_invent.record_num.value;r++)
		{
			if(eval("document.add_invent.row_kontrol"+r).value == 1)
			{
				record_exist=1;
				if (eval("document.add_invent.invent_no"+r).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='56981.Lütfen Demirbaş No Giriniz'>!");
					return false;
				}
				if (eval("document.add_invent.invent_name"+r).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='56986.Lütfen Açıklama Giriniz'> !");
					return false;
				}
				if ((eval("document.add_invent.row_total"+r).value == ""))
				{ 
					alert ("<cf_get_lang dictionary_id='29535.Lütfen Tutar Giriniz '>!");
					return false;
				}
				if ((eval("document.add_invent.amortization_rate"+r).value == "")||(eval("document.add_invent.amortization_rate"+r).value ==0))
				{ 
					alert ("<cf_get_lang dictionary_id='56988.Lütfen Amortisman Oranı Giriniz'> !");
					return false;
				}
				if (eval("document.add_invent.account_code"+r).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='56989.Lütfen Muhasebe Kodu Seçiniz'>");
					return false;
				}
				if (eval("document.add_invent.last_diff_value"+r).value != 0 && filterNum(eval("document.add_invent.last_diff_value"+r).value) > 0 && eval("document.add_invent.budget_account_code"+r).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='56958.Lütfen Gelir/Gider Farkı İçin Muhasebe Kodu Seçiniz'>!");
					return false;
				}
				if (eval("document.add_invent.last_diff_value"+r).value != 0 && filterNum(eval("document.add_invent.last_diff_value"+r).value) > 0 && eval("document.add_invent.amort_account_code"+r).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='56957.Lütfen Amortisman Karşılık Muhasebe Kodu Seçiniz'>!");
					return false;
				}
				if (eval("document.add_invent.stock_id"+r).value == '' || eval("document.add_invent.product_name"+r).value == '')
				{
					alert ("<cf_get_lang dictionary_id='57725.Ürün Seçiniz'> !");
					return false;
				}
			}
		}
		if (record_exist == 0) 
		{
			alert("<cf_get_lang dictionary_id='56983.Lütfen Demirbaş Giriniz'>!");
			return false;
		}
	}
	function unformat_fields()
	{
		for(r=1;r<=add_invent.record_num.value;r++)
		{
			deger_total = eval("document.add_invent.row_total"+r);
			deger_kdv_total= eval("document.add_invent.kdv_total"+r);
			deger_net_total = eval("document.add_invent.net_total"+r);
			deger_other_net_total = eval("document.add_invent.row_other_total"+r);
			deger_amortization_rate = eval("document.add_invent.amortization_rate"+r);
			last_diff_value = eval("document.add_invent.last_diff_value"+r);
			last_inventory_value = eval("document.add_invent.last_inventory_value"+r);
			total_first_value = eval("document.add_invent.total_first_value"+r);
			unit_first_value = eval("document.add_invent.unit_first_value"+r);
			
			deger_total.value = filterNum(deger_total.value);
			deger_kdv_total.value = filterNum(deger_kdv_total.value);
			deger_net_total.value = filterNum(deger_net_total.value);
			deger_other_net_total.value = filterNum(deger_other_net_total.value);
			deger_amortization_rate.value = filterNum(deger_amortization_rate.value);
			last_diff_value.value = filterNum(last_diff_value.value);
			last_inventory_value.value = filterNum(last_inventory_value.value);
			total_first_value.value = filterNum(total_first_value.value);
			unit_first_value.value = filterNum(unit_first_value.value);
		}
	
		document.add_invent.total_amount.value = filterNum(document.add_invent.total_amount.value);
		document.add_invent.kdv_total_amount.value = filterNum(document.add_invent.kdv_total_amount.value);
		document.add_invent.net_total_amount.value = filterNum(document.add_invent.net_total_amount.value);
		document.add_invent.other_total_amount.value = filterNum(document.add_invent.other_total_amount.value);
		document.add_invent.other_kdv_total_amount.value = filterNum(document.add_invent.other_kdv_total_amount.value);
		document.add_invent.other_net_total_amount.value = filterNum(document.add_invent.other_net_total_amount.value);
		
		for(s=1;s<=add_invent.kur_say.value;s++)
		{
			eval('add_invent.txt_rate2_' + s).value = filterNum(eval('add_invent.txt_rate2_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			eval('add_invent.txt_rate1_' + s).value = filterNum(eval('add_invent.txt_rate1_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
	}
	row_count=0;
	satir_say=0;
	function sil(sy)
	{
		var my_element=eval("add_invent.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		toplam_hesapla();
		satir_say--;
	}
	function hesapla(satir,hesap_type)
	{
		var toplam_dongu_0 = 0;//satir toplam
		if(eval("document.add_invent.row_kontrol"+satir).value==1)
		{
			deger_total = eval("document.add_invent.row_total"+satir);//tutar
			deger_miktar = eval("document.add_invent.quantity"+satir);//miktar
			deger_kdv_total= eval("document.add_invent.kdv_total"+satir);//kdv tutarı
			deger_net_total = eval("document.add_invent.net_total"+satir);//kdvli tutar
			deger_tax_rate = eval("document.add_invent.tax_rate"+satir);//kdv oranı
			deger_last_value = eval("document.add_invent.last_inventory_value"+satir);//Son değer
			deger_other_net_total = eval("document.add_invent.row_other_total"+satir);//dovizli tutar kdv dahil
			deger_diff_value = eval("document.add_invent.last_diff_value"+satir);//Fark
			deger_first_value = eval("document.add_invent.total_first_value"+satir);//İlk değer
			deger_last_unit_value = eval("document.add_invent.unit_last_value"+satir);//Son değer birim
			deger_first_unit_value = eval("document.add_invent.unit_first_value"+satir);//İlk değer birim
			if(deger_total.value == "") deger_total.value = 0;
			if(deger_kdv_total.value == "") deger_kdv_total.value = 0;
			if(deger_net_total.value == "") deger_net_total.value = 0;
			deger_money_id = eval("document.add_invent.money_id"+satir);
			deger_money_id_ilk = list_getat(deger_money_id.value,2,',');
			deger_money_id_son = list_getat(deger_money_id.value,3,',');
			deger_miktar.value = filterNum(deger_miktar.value,0);
			deger_total.value = filterNum(deger_total.value);
			deger_kdv_total.value = filterNum(deger_kdv_total.value);
			deger_net_total.value = filterNum(deger_net_total.value);
			deger_other_net_total.value = filterNum(deger_other_net_total.value);
			deger_diff_value.value = filterNum(deger_diff_value.value);
			deger_last_unit_value.value = filterNum(deger_last_unit_value.value);
			deger_first_unit_value.value = filterNum(deger_first_unit_value.value);
			deger_first_value.value = filterNum(deger_first_value.value);
			if(hesap_type ==undefined)
			{
				deger_kdv_total.value = (parseFloat(deger_total.value) * deger_miktar.value * deger_tax_rate.value)/100;
			}else if(hesap_type == 2)
			{
				deger_total.value = ((parseFloat(deger_net_total.value)*100)/ (parseFloat(deger_tax_rate.value)+100))/deger_miktar.value;
				deger_kdv_total.value = (parseFloat(deger_total.value * deger_miktar.value * deger_tax_rate.value))/100;
			}
			toplam_dongu_0 = (parseFloat(deger_total.value)*deger_miktar.value) + parseFloat(deger_kdv_total.value);
			deger_other_net_total.value = ((parseFloat(deger_total.value) + parseFloat(deger_kdv_total.value)) * parseFloat(deger_money_id_ilk) / (parseFloat(deger_money_id_son)));
			deger_net_total.value = commaSplit(toplam_dongu_0);
			deger_kdv_total.value = commaSplit(deger_kdv_total.value);
			deger_other_net_total.value = commaSplit(deger_other_net_total.value);
			deger_last_value.value = filterNum(deger_last_value.value);
			deger_last_value.value =  parseFloat(deger_last_unit_value.value * deger_miktar.value);
			deger_first_value.value =  parseFloat(deger_first_unit_value.value * deger_miktar.value);
			deger_diff_value.value = parseFloat((deger_total.value * deger_miktar.value)  - deger_last_value.value);
			deger_diff_value.value = commaSplit(deger_diff_value.value);
			deger_last_value.value = commaSplit(deger_last_value.value);
			deger_last_unit_value.value = commaSplit(deger_last_unit_value.value);
			deger_first_value.value = commaSplit(deger_first_value.value);
			deger_first_unit_value.value = commaSplit(deger_first_unit_value.value);
			deger_total.value = commaSplit(deger_total.value);
		}
		toplam_hesapla();
	}
	function toplam_hesapla()
	{
		var toplam_dongu_1 = 0;//tutar genel toplam
		var toplam_dongu_2 = 0;// kdv genel toplam
		var toplam_dongu_3 = 0;// kdvli genel toplam
		var toplam_dongu_4 = 0;// kdvli genel toplam
		var beyan_tutar = 0;
		var tevkifat_info = "";
		var beyan_tutar_info = "";
		var new_taxArray = new Array(0);
		var taxBeyanArray = new Array(0);
		var taxTevkifatArray = new Array(0);
		for(r=1;r<=add_invent.record_num.value;r++)
		{
			if(eval("document.add_invent.row_kontrol"+r).value==1)
			{
				toplam_dongu_4 = toplam_dongu_4 + (parseFloat(filterNum(eval("document.add_invent.row_total"+r).value) * filterNum(eval("document.add_invent.quantity"+r).value)));
			}
		}			
		genel_indirim_yuzdesi = commaSplit(parseFloat(document.add_invent.net_total_discount.value) / parseFloat(toplam_dongu_4),8);
		genel_indirim_yuzdesi = filterNum(genel_indirim_yuzdesi,8);
		genel_indirim_yuzdesi = wrk_round(genel_indirim_yuzdesi,2);
		deger_discount_value = document.add_invent.net_total_discount.value;
		deger_discount_value = filterNum(deger_discount_value,4);
	
		for(r=1;r<=add_invent.record_num.value;r++)
		{
			if(eval("document.add_invent.row_kontrol"+r).value==1)
			{
				deger_total = eval("document.add_invent.row_total"+r);//tutar
				deger_miktar = eval("document.add_invent.quantity"+r);//miktar
				deger_kdv_total= eval("document.add_invent.kdv_total"+r);//kdv tutarı
				deger_net_total = eval("document.add_invent.net_total"+r);//kdvli tutar
				deger_tax_rate = eval("document.add_invent.tax_rate"+r);//kdv oranı
				deger_other_net_total = eval("document.add_invent.row_other_total"+r);//dovizli tutar kdv dahil
				deger_money_id = eval("document.add_invent.money_id"+r);
				deger_money_id_ilk = list_getat(deger_money_id.value,1,',');
				for(s=1;s<=add_invent.kur_say.value;s++)
					{
						if(list_getat(document.add_invent.rd_money[s-1].value,1,',') == deger_money_id_ilk)
						{
							satir_rate2= eval("document.add_invent.txt_rate2_"+s).value;
						}
					}
				satir_rate2= filterNum(satir_rate2,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');			
				deger_total.value = filterNum(deger_total.value);
				deger_kdv_total.value = filterNum(deger_kdv_total.value);
				deger_net_total.value = filterNum(deger_net_total.value);
				deger_other_net_total.value = filterNum(deger_other_net_total.value);
				toplam_dongu_1 = toplam_dongu_1 + parseFloat(deger_total.value * deger_miktar.value);
				deger_other_net_total.value = ((parseFloat(deger_total.value * deger_miktar.value) + parseFloat(deger_kdv_total.value)) / (parseFloat(satir_rate2)));
				toplam_dongu_2 = toplam_dongu_2 + parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value*genel_indirim_yuzdesi);
				deger_indirim_kdv = parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value*genel_indirim_yuzdesi);
				toplam_dongu_3 = toplam_dongu_3 + ((parseFloat(deger_total.value)- (parseFloat(deger_total.value)*genel_indirim_yuzdesi)) * filterNum(eval("document.add_invent.quantity"+r).value));
				toplam_dongu_3 = toplam_dongu_3 + parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value*genel_indirim_yuzdesi);
				
				if(document.add_invent.tevkifat_oran != undefined && document.add_invent.tevkifat_oran.value != "" && add_invent.tevkifat_box.checked == true)
				{//tevkifat hesaplamaları
					beyan_tutar = beyan_tutar + wrk_round(deger_indirim_kdv*filterNum(document.add_invent.tevkifat_oran.value)/100);
					if(new_taxArray.length != 0)
						for (var m=0; m < new_taxArray.length; m++)
						{	
							var tax_flag = false;
							if(new_taxArray[m] == deger_tax_rate.value){
								tax_flag = true;
								taxBeyanArray[m] += wrk_round(deger_indirim_kdv - (deger_indirim_kdv*(filterNum(document.add_invent.tevkifat_oran.value)/100)));
								taxTevkifatArray[m] += wrk_round(deger_indirim_kdv*(filterNum(document.add_invent.tevkifat_oran.value)/100));
								break;
							}
						}
					if(!tax_flag){
						new_taxArray[new_taxArray.length] = deger_tax_rate.value;
						taxBeyanArray[taxBeyanArray.length] = wrk_round(deger_indirim_kdv - (deger_indirim_kdv*(filterNum(document.add_invent.tevkifat_oran.value)/100)));
						taxTevkifatArray[taxTevkifatArray.length] = wrk_round(deger_indirim_kdv*(filterNum(document.add_invent.tevkifat_oran.value)/100));
					}
				}
				deger_net_total.value = commaSplit(deger_net_total.value);
				deger_total.value = commaSplit(deger_total.value);
				deger_kdv_total.value = commaSplit(deger_kdv_total.value);
				deger_other_net_total.value = commaSplit(deger_other_net_total.value);
			}
		}	
		if(document.add_invent.tevkifat_oran != undefined && document.add_invent.tevkifat_oran.value != "" && add_invent.tevkifat_box.checked == true)
		{//tevkifat hesaplamaları
			toplam_dongu_3 = toplam_dongu_3 - toplam_dongu_2 + beyan_tutar;
			toplam_dongu_2 = beyan_tutar;
			tevkifat_text.style.fontWeight = 'bold';
			tevkifat_text.innerHTML = '';
			beyan_text.style.fontWeight = 'bold';
			beyan_text.innerHTML = '';
			for (var tt=0; tt < new_taxArray.length; tt++)
			{
				tevkifat_text.innerHTML += '% ' + new_taxArray[tt] + ' : ' + commaSplit(taxBeyanArray[tt],4) + ' ';
				beyan_text.innerHTML += '% ' + new_taxArray[tt] + ' : ' + commaSplit(taxTevkifatArray[tt],4) + ' ';
			}
		 }	
		
		document.add_invent.total_amount.value = commaSplit(toplam_dongu_1);
		document.add_invent.kdv_total_amount.value = commaSplit(toplam_dongu_2); 
		document.add_invent.net_total_amount.value = commaSplit(toplam_dongu_3);
		for(s=1;s<=add_invent.kur_say.value;s++)
		{
			form_txt_rate2_ = eval("document.add_invent.txt_rate2_"+s);
			if(form_txt_rate2_.value == "")
				form_txt_rate2_.value = 1;
		}
		if(add_invent.kur_say.value == 1)
			for(s=1;s<=add_invent.kur_say.value;s++)
			{
				if(document.add_invent.rd_money.checked == true)
				{
					deger_diger_para = document.add_invent.rd_money;
					form_txt_rate2_ = eval("document.add_invent.txt_rate2_"+s);
				}
			}
		else 
			for(s=1;s<=add_invent.kur_say.value;s++)
			{
				if(document.add_invent.rd_money[s-1].checked == true)
				{
					deger_diger_para = document.add_invent.rd_money[s-1];
					form_txt_rate2_ = eval("document.add_invent.txt_rate2_"+s);
				}
			}
		deger_money_id_1 = list_getat(deger_diger_para.value,1,',');
		deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
		form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.add_invent.other_total_amount.value = commaSplit(toplam_dongu_1 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)));
		document.add_invent.other_kdv_total_amount.value = commaSplit(toplam_dongu_2 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value))); 
		document.add_invent.other_net_total_amount.value = commaSplit(toplam_dongu_3 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)));
		document.add_invent.other_net_total_discount.value = commaSplit(deger_discount_value* parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)));
		document.add_invent.net_total_discount.value = commaSplit(deger_discount_value);
		document.add_invent.tl_value1.value = deger_money_id_1;
		document.add_invent.tl_value2.value = deger_money_id_1;
		document.add_invent.tl_value3.value = deger_money_id_1;
		document.add_invent.tl_value4.value = deger_money_id_1;
		form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	}
	function gonder(invent_id,invent_name,invent_no,quantity,acc_id,amort_rate,amortizaton_method,unit_last_value,last_inventory_value,unit_first_value,total_first_value,last_diff_value,expense_center_id,expense_center_name,budget_item_id,budget_item_name,debt_account_id,claim_account_id,product_id,product_name,stock_unit_id,stock_id,stock_unit,entry_date)
	{
		row_count++;
		satir_say++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		newRow.className = 'color-row';
		document.add_invent.record_num.value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		x = '<input  type="hidden" value="WRK'+row_count+ js_create_unique_id() + row_count+'" name="wrk_row_id' + row_count +'"><input  type="hidden" value="" name="wrk_row_relation_id' + row_count +'">';
		newCell.innerHTML = x + '<input  type="hidden" value="1" name="row_kontrol' + row_count +'" ><a href="javascript://" onclick="sil(' + row_count + ');"><i class="fa fa-minus"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="entry_date' + row_count +'" value="'+ entry_date +'" readonly><input type="hidden" name="invent_id' + row_count +'" value="'+ invent_id +'" readonly><input type="text" name="invent_no' + row_count +'" style="width:100%;" class="boxtext" value="'+ invent_no +'" maxlength="50">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" readonly name="invent_name' + row_count +'" style="width:100px;" class="boxtext" value="'+ invent_name +'" maxlength="100"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<div class="form-group"><input type="text" name="quantity' + row_count +'" style="width:100%;" class="moneybox" value="'+ quantity +'" onBlur="hesapla(' + row_count +');" onkeyup="return(FormatCurrency(this,event));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<div class="form-group"><input type="text" name="row_total' + row_count +'" value="' + unit_last_value + '" onkeyup="return(FormatCurrency(this,event));" onBlur="hesapla(' + row_count +');" style="width:100%;" class="moneybox"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<div class="form-group"><select name="tax_rate'+ row_count +'" style="width:100%;" onChange="hesapla('+ row_count +');" class="box"><cfoutput query="get_tax"><option value="#tax#">#tax#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<div class="form-group"><input type="text" name="kdv_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" style="width:60px;" onBlur="hesapla(' + row_count +',1);" class="moneybox"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<div class="form-group"><input type="text" name="net_total' + row_count +'" value="0" class="moneybox" readonly></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<div class="form-group"><input type="text" name="row_other_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="moneybox" readonly></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<div class="form-group"><select name="money_id' + row_count  +'" style="width:100%;" class="boxtext" onChange="hesapla('+ row_count +');"><cfoutput query="get_money"><option value="#money#,#rate1#,#rate2#" <cfif money eq session.ep.money>selected</cfif>>#money#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<div class="form-group"><input type="text" name="amortization_rate' + row_count +'" value="'+ amort_rate +'" style="width:100%;" class="moneybox" onkeyup="return(FormatCurrency(this,event));" readonly="yes"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		if(amortizaton_method == 0)
			newCell.innerHTML = '<div class="form-group"><input type="text" readonly name="amortization_method'+ row_count +'" style="width:165px;" class="boxtext" value="<cf_get_lang dictionary_id="29421.Azalan Bakiye Üzerinden">"></div>';
		else if(amortizaton_method == 1)
			newCell.innerHTML = '<div class="form-group"><input type="text" readonly name="amortization_method'+ row_count +'" style="width:165px;" class="boxtext" value="<cf_get_lang dictionary_id="29422.Sabit Miktar Üzeriden">"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" name="account_id' + row_count +'" id="account_id' + row_count +'" value="'+ acc_id +'"><input type="text" name="account_code' + row_count +'" id="account_code' + row_count +'" value="'+ acc_id +'" class="boxtext" onFocus="autocomp_account('+row_count+');"><span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac_acc('+ row_count +');" ></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="unit_last_value' + row_count +'" value="'+ unit_last_value +'"><input type="hidden" name="unit_first_value' + row_count +'" value="'+ unit_first_value +'"><input type="hidden" name="total_first_value' + row_count +'" value="'+ total_first_value +'"><input type="text" name="last_inventory_value' + row_count +'" value="'+ last_inventory_value +'" style="width:100%;" class="moneybox" onkeyup="return(FormatCurrency(this,event));" readonly="yes"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<div class="form-group"><input type="text" name="last_diff_value' + row_count +'" value="'+last_diff_value+'" style="width:100%;" class="moneybox" onkeyup="return(FormatCurrency(this,event));" readonly="yes"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML ='<div class="form-group"><div class="input-group"><input type="hidden" name="expense_center_id' + row_count +'" value="'+expense_center_id+'" id="expense_center_id' + row_count +'"><input type="text" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'" onFocus="exp_center('+row_count+');" value="'+expense_center_name+'" style="width:150px;" class="boxtext"><span class="input-group-addon btnPointer icon-ellipsis" onClick="pencere_ac_exp_center('+ row_count +');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="budget_item_id' + row_count +'" id="budget_item_id' + row_count +'" value='+budget_item_id+'><input type="text" style="width:115px;" name="budget_item_name' + row_count +'" id="budget_item_name' + row_count +'" class="boxtext" value="'+budget_item_name+'" onFocus="exp_item('+row_count+');"><span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac_exp('+ row_count +');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" name="budget_account_id' + row_count +'" id="budget_account_id' + row_count +'" value="'+debt_account_id+'"><input type="text" name="budget_account_code' + row_count +'" id="budget_account_code' + row_count +'"  value="'+debt_account_id+'" class="boxtext" style="width:155px;" onFocus="autocomp_budget_account('+row_count+');"><span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac_acc_1('+ row_count +');" ></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" name="amort_account_id' + row_count +'" id="amort_account_id' + row_count +'" value="'+claim_account_id+'"><input type="text" name="amort_account_code' + row_count +'" id="amort_account_code' + row_count +'" value="'+claim_account_id+'" class="boxtext" style="width:205px;" onFocus="autocomp_amort_account('+row_count+');"><span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac_acc_2('+ row_count +');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" name="product_id' + row_count +'" value="'+product_id+'"><input type="hidden" name="stock_id' + row_count +'" value="'+stock_id+'"><input type="text" name="product_name' + row_count +'"  value="'+product_name+'" class="boxtext" style="width:110px;"><span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=add_invent.product_id" + row_count + "&field_id=add_invent.stock_id" + row_count + "&field_unit_name=add_invent.stock_unit" + row_count + "&field_main_unit=add_invent.stock_unit_id" + row_count + "&field_name=add_invent.product_name" + row_count + "');"+'"></span></div></div>'
		newCell.innerHTML += '';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="stock_unit_id' + row_count +'" value="'+stock_unit_id+'" ><input type="text" name="stock_unit' + row_count +'" style="width:100%;" value="'+stock_unit+'" class="boxtext"></div>';
		hesapla(row_count);
	}
	/* masraf merkezi popup */
	function pencere_ac_exp_center(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=add_invent.expense_center_id' + no +'&field_name=add_invent.expense_center_name' + no);
	}
	/* masraf merkezi autocomplete */
	function exp_center(no)
	{
		AutoComplete_Create("expense_center_name" + no,"EXPENSE,EXPENSE_CODE","EXPENSE,EXPENSE_CODE","get_expense_center","","EXPENSE_ID","expense_center_id"+no,"",3);
	}
	/* gider kalemi autocomplete */
	function exp_item(no)
	{
		AutoComplete_Create("budget_item_name" + no,"EXPENSE_ITEM_NAME","EXPENSE_ITEM_NAME","get_expense_item","","EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE","budget_item_id"+no+",budget_account_code"+no+",budget_account_id"+no,"",3);
	}
	function autocomp_account(no)
	{
		AutoComplete_Create("account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_CODE","account_id"+no,"",3);
	}
	function autocomp_budget_account(no)
	{
		AutoComplete_Create("budget_account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_CODE","budget_account_id"+no,"",3);
	}
	function autocomp_amort_account(no)
	{
		AutoComplete_Create("amort_account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_CODE","amort_account_id"+no,"",3);
	}
	function pencere_ac_acc(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_invent.account_id' + no +'&field_name=add_invent.account_code' + no +'','list');
	}
	function pencere_ac_acc_1(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_invent.budget_account_id' + no +'&field_name=add_invent.budget_account_code' + no +'','list');
	}
	function pencere_ac_acc_2(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_invent.amort_account_id' + no +'&field_name=add_invent.amort_account_code' + no +'','list');
	}
	function pencere_ac_exp(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=add_invent.budget_item_id' + no +'&field_name=add_invent.budget_item_name' + no +'&field_account_no=add_invent.budget_account_code' + no +'&field_account_no2=add_invent.budget_account_id' + no +'','list');
	}
	function ayarla_gizle_goster()
	{
		if(add_invent.cash.checked)
			kasa_sec.style.display='';
		else
			kasa_sec.style.display='none';
	}
	function f_add_invent()
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_inventory&field_id=add_invent.invent_id','wide');
	}
</script>
