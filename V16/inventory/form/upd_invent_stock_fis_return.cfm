<cfquery name="GET_FIS_DET" datasource="#dsn2#">
	SELECT * FROM STOCK_FIS WHERE FIS_ID = #attributes.fis_id#
</cfquery>
<cfif not GET_FIS_DET.recordcount>
	<br/><font class="txtbold"><cf_get_lang dictionary_id='58943.Böyle Bir Fatura Bulunmamaktadır'>!</font>
	<cfexit method="exittemplate">
</cfif>
<cfquery name="GET_STOCK_FIS_MONEY" datasource="#dsn2#">
	SELECT MONEY_TYPE AS MONEY,* FROM STOCK_FIS_MONEY WHERE ACTION_ID = #attributes.fis_id#
</cfquery>
<cfquery name="GET_STOCK_MONEY" datasource="#dsn2#">
	SELECT RATE2,RATE1,MONEY_TYPE FROM STOCK_FIS_MONEY WHERE ACTION_ID = #attributes.fis_id# AND IS_SELECTED=1
</cfquery>
<cfif not GET_STOCK_FIS_MONEY.recordcount>
	<cfquery name="GET_INVOICE_MONEY" datasource="#DSN#">
		SELECT MONEY,RATE2,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS=1
	</cfquery>
</cfif>
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_TAX" datasource="#dsn2#">
	SELECT * FROM SETUP_TAX ORDER BY TAX
</cfquery>
<cfquery name="GET_ACCOUNTS" datasource="#dsn3#">
	SELECT ACCOUNT_ID,ACCOUNT_CURRENCY_ID,ACCOUNT_NAME FROM ACCOUNTS ORDER BY ACCOUNT_NAME
</cfquery>
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT EXPENSE_ID,EXPENSE,EXPENSE_CODE FROM EXPENSE_CENTER ORDER BY EXPENSE
</cfquery>
<cfquery name="GET_INVENTORY_CATS" datasource="#dsn3#">
	SELECT * FROM SETUP_INVENTORY_CAT ORDER BY INVENTORY_CAT_ID
</cfquery>
<cfquery name="GET_AMORTIZATION_COUNT" datasource="#DSN3#">
	SELECT 
		COUNT(IA.AMORTIZATION_ID) AS AMORTIZATION_COUNT
	FROM 
		INVENTORY I,
		INVENTORY_ROW IR,
		INVENTORY_AMORTIZATON IA
	WHERE 
		I.INVENTORY_ID = IR.INVENTORY_ID
		AND IA.INVENTORY_ID = IR.INVENTORY_ID
		AND IR.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.fis_id#">
		AND IR.PROCESS_TYPE = 1182
		AND PERIOD_ID = #session.ep.period_id#
	UNION
	SELECT 
		COUNT(IA.AMORTIZATION_ID) AS AMORTIZATION_COUNT
	FROM 
		INVENTORY I,
		INVENTORY_ROW IR,
		INVENTORY_AMORTIZATON_IFRS IA
	WHERE 
		I.INVENTORY_ID = IR.INVENTORY_ID
		AND IA.INVENTORY_ID = IR.INVENTORY_ID
		AND IR.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.fis_id#">
		AND IR.PROCESS_TYPE = 1182
		AND PERIOD_ID = #session.ep.period_id#
</cfquery>
<cfset inventory_cat_list=valuelist(GET_INVENTORY_CATS.INVENTORY_CAT_ID)>

<cf_catalystHeader>
<cf_box>
	<cfform name="upd_invent" method="post" action="#request.self#?fuseaction=invent.emptypopup_upd_invent_stock_fis_return">
		<cf_basket_form id="invent_stock_fis_return">
			<cf_box_elements>
				<div class="row" type="row">
					<input type="hidden" name="fis_id" id="fis_id" value="<cfoutput>#attributes.fis_id#</cfoutput>">
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-process_cat">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'> *</label>
							<div class="col col-8 col-xs-12">
								<cf_workcube_process_cat process_cat='#GET_FIS_DET.process_cat#' slct_width='120'>
							</div>
						</div>
						<div class="form-group" id="item-fis_number">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57946.Fiş No'> *</label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message1"><cf_get_lang dictionary_id='57946.Fiş No'></cfsavecontent>
								<cfinput type="text" name="fis_no" value="#get_fis_det.fis_number#" readonly="yes" maxlength="50" style="width:120px;" required="yes" message="#message1#"></td>
							</div>
						</div>
						<div class="form-group" id="item-ref_no">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58794.Ref No'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="ref_no" id="ref_no" value="<cfoutput>#get_fis_det.ref_no#</cfoutput>" style="width:120px;">
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-start_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message3"><cf_get_lang dictionary_id='57742.Tarih'></cfsavecontent>
									<cfinput type="text" name="start_date" validate="#validate_style#" readonly="yes" required="yes" message="#message3#" value="#dateformat(get_fis_det.fis_date,dateformat_style)#" maxlength="10" style="width:120px;" onblur="change_money_info('upd_invent','start_date');">
									<span class="input-group-addon btnPointer"><cfif GET_AMORTIZATION_COUNT.AMORTIZATION_COUNT lte 0><cf_wrk_date_image date_field="start_date" call_function="change_money_info"></cfif></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-giris_depo">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56969.Giriş Depo'> *</label>
							<div class="col col-8 col-xs-12">
								<cfset location_info_ = get_location_info(get_fis_det.department_in,get_fis_det.location_in,1,1)>
								<cf_wrkdepartmentlocation
									returnInputValue="location_id,department_name,department_id,branch_id"
									returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
									fieldName="department_name"
									fieldid="location_id"
									department_fldId="department_id"
									branch_fldId="branch_id"
									branch_id="#listlast(location_info_,',')#"
									department_id="#get_fis_det.department_in#"
									location_id="#get_fis_det.location_in#"
									location_name="#listfirst(location_info_,',')#"
									user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
									line_info = 1
									width="120">
							</div>
						</div>
						<div class="form-group" id="item-cikis_depo">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29428.Çıkış Depo'></label>
							<div class="col col-8 col-xs-12">
								<cfset location_out_info_ = get_location_info(get_fis_det.department_out,get_fis_det.location_out,1,1)>
								<cf_wrkdepartmentlocation
									returnInputValue="location_id_2,department_name_2,department_id_2,branch_id_2"
									returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
									fieldName="department_name_2"
									fieldid="location_id_2"
									department_fldId="department_id_2"
									branch_fldId="branch_id_2"
									branch_id="#listlast(location_out_info_,',')#"
									department_id="#get_fis_det.department_out#"
									location_id="#get_fis_det.location_out#"
									location_name="#listfirst(location_out_info_,',')#"
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
									<input type="hidden" name="deliver_get_id" id="deliver_get_id" value="<cfoutput>#get_fis_det.employee_id#</cfoutput>">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57775.Teslim Alan'> <cf_get_lang dictionary_id='57613.Girmelsiniz'></cfsavecontent>
									<cfinput type="text" name="deliver_get" required="yes" message="#message#" style="width:120px;" readonly="yes" value="#get_emp_info(get_fis_det.employee_id,0,0)#">
									<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57775.Teslim Alan'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=upd_invent.deliver_get&field_emp_id2=upd_invent.deliver_get_id</cfoutput>');"></span>
								</div>
							</div>
						</div>
						<cfif session.ep.our_company_info.project_followup eq 1>
							<div class="form-group" id="item-project">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cf_wrk_projects form_name='upd_invent' project_id='project_id' project_name='project_head'>
										<cfif len(get_fis_det.project_id)>
											<cfquery name="GET_PROJECT" datasource="#dsn#">
												SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_fis_det.project_id#
											</cfquery>
											<input type="hidden" name="project_id" id="project_id" value="<cfoutput>#get_fis_det.project_id#</cfoutput>"> 
											<input type="text" name="project_head" id="project_head" onkeyup="get_project_1();" style="width:120px;" value="<cfoutput>#get_project.project_head#</cfoutput>">
										<cfelse>
											<input type="hidden" name="project_id" id="project_id" value=""> 
											<input type="text" name="project_head" id="project_head" onkeyup="get_project_1();" style="width:120px;" value="">
										</cfif>
										<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57416.Proje'>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=upd_invent.project_id&project_head=upd_invent.project_head');"></span>
									</div>
								</div>
							</div>
						</cfif>
						<cfif session.ep.our_company_info.subscription_contract eq 1>
							<div class="form-group" id="item-subscription_no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59774.Sistem No'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfif len(get_fis_det.subscription_id)>
											<cfquery name="GET_SUBS_INFO" datasource="#dsn3#">
												SELECT * FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = #get_fis_det.subscription_id#
											</cfquery>
										</cfif>
										<input type="hidden" name="subscription_id" id="subscription_id" value="<cfif len(get_fis_det.subscription_id)><cfoutput>#get_fis_det.subscription_id#</cfoutput></cfif>">
										<input type="text" name="subscription_no" id="subscription_no" value="<cfif len(get_fis_det.subscription_id)><cfoutput>#GET_SUBS_INFO.SUBSCRIPTION_NO#</cfoutput></cfif>" style="width:120px;" onFocus="AutoComplete_Create('subscription_no','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO','get_subscription','2','SUBSCRIPTION_ID','subscription_id','','2','100');" autocomplete="off">
										<cfset str_subscription_link="field_partner=&field_id=upd_invent.subscription_id&field_no=upd_invent.subscription_no">
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
								<textarea name="detail" id="detail"><cfoutput>#get_fis_det.FIS_DETAIL#</cfoutput></textarea>
							</div>
						</div>
					</div>
				</div>
				<div class="row formContentFooter">
					<div class="col col-6 col-xs-12">
						<cf_record_info query_name='get_fis_det'>
					</div>
					<div class="col col-6 col-xs-12">
						<cfif not len(get_fis_det.RELATED_SHIP_ID)>
							<cf_workcube_buttons 
								is_upd='1' 
								add_function='kontrol()' 
								is_delete='1' 
								delete_page_url='#request.self#?fuseaction=invent.emptypopup_del_invent_stock_fis&fis_id=#attributes.fis_id#&head=#get_fis_det.fis_number#&old_process_type=#get_fis_det.fis_type#'>
						<cfelse>
							<cfquery name="get_related_ship" datasource="#dsn2#">
								SELECT SHIP_NUMBER FROM SHIP WHERE SHIP_ID = #get_fis_det.RELATED_SHIP_ID#
							</cfquery>
							<font color="red"><cfoutput>#get_related_ship.ship_number#</cfoutput> No'lu İrsaliyeden Oluşmuştur.</font>
						</cfif>
					</div>
				</div>
			</cf_box_elements>
		</cf_basket_form>
		<cf_basket id="invent_stock_fis_return_bask">
			<cfquery name="GET_ROWS" datasource="#dsn2#">
				SELECT
					STOCK_FIS_ROW.*,
					INVENTORY.*,
					S.PRODUCT_ID,
					S.PRODUCT_NAME,
					STOCK_FIS_ROW.AMOUNT STOCK_QUANTITY,
					INVENTORY.AMOUNT INVENT_AMOUNT
				FROM
					STOCK_FIS_ROW,
					#dsn3_alias#.STOCKS S,
					#dsn3_alias#.INVENTORY INVENTORY
				WHERE
					STOCK_FIS_ROW.STOCK_ID = S.STOCK_ID AND
					STOCK_FIS_ROW.FIS_ID = #attributes.fis_id# AND
					INVENTORY.INVENTORY_ID = STOCK_FIS_ROW.INVENTORY_ID
			</cfquery>
			<cfset item_id_list=''>
			<cfset exp_center_id_list=''>
			<cfoutput query="GET_ROWS">
				<cfif len(SALE_EXPENSE_ITEM_ID) and not listfind(item_id_list,SALE_EXPENSE_ITEM_ID)>
					<cfset item_id_list=listappend(item_id_list,SALE_EXPENSE_ITEM_ID)>
				</cfif>
				<cfif len(SALE_EXPENSE_CENTER_ID) and not listfind(exp_center_id_list,SALE_EXPENSE_CENTER_ID)>
					<cfset exp_center_id_list=listappend(exp_center_id_list,SALE_EXPENSE_CENTER_ID)>
				</cfif>
			</cfoutput>
			<cfif len(item_id_list)>
				<cfset item_id_list=listsort(item_id_list,"numeric","ASC",",")>
				<cfquery name="get_exp_detail" datasource="#dsn2#">
					SELECT EXPENSE_ITEM_NAME,ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (#item_id_list#) ORDER BY EXPENSE_ITEM_ID
				</cfquery>
			</cfif>
			<cfif len(exp_center_id_list)>
				<cfquery name="get_expense_center" datasource="#dsn2#">
					SELECT * FROM EXPENSE_CENTER WHERE EXPENSE_ID IN (#exp_center_id_list#) ORDER BY EXPENSE_ID
				</cfquery>
				<cfset exp_center_id_list = listsort(listdeleteduplicates(valuelist(get_expense_center.EXPENSE_ID,',')),'numeric','ASC',',')>
			</cfif>
			<cf_grid_list id="table1">
				<thead>
					<tr>
						<th>
							<input name="record_num" id="record_num" type="hidden" value="<cfoutput>#get_rows.recordcount#</cfoutput>"> 
							<a onClick="f_upd_invent();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
						</th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='58878.Demirbaş No'></th>
						<th nowrap="nowrap" width="180"><cf_get_lang dictionary_id='57629.Açıklama'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='57635.Miktar'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='57638.Birim Fiyat'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='57639.KDV'> %</th>
						<th width="60"  nowrap style="text-align:right;"><cf_get_lang dictionary_id='57639.KDV'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='58083.Net'><cf_get_lang dictionary_id='58084.Fiyat'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='58083.Net'><cf_get_lang dictionary_id='56994.Döviz Fiyat'></th>
						<th nowrap="nowrap" width="60"><cf_get_lang dictionary_id='57677.Döviz'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='58456.Oran'>&nbsp;</th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='29420.Amortisman Yöntemi'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
						<th nowrap="nowrap" width="125"><cf_get_lang dictionary_id='56909.Son Değer'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='56966.Gelir/Gider'><cf_get_lang dictionary_id='56964.Farkı'></th>
						<th nowrap="nowrap" width="125"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
						<th nowrap="nowrap" width="125"><cf_get_lang dictionary_id='58234.Bütçe Kalemi'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='56966.Gelir/Gider'><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='56963.Amortisman'><cf_get_lang dictionary_id='56962.Karşılık'><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
						<th nowrap width="125"><cf_get_lang dictionary_id='57452.Stok'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='56990.Stok Birimi'></th>
					</tr>
				</thead>
				<tbody>
					<cfset net_toplam = 0>
					<cfset gross_toplam = 0>
					<cfset tax_toplam = 0>
					<cfset doviz_topla=0>
					<cfset doviz_kdv_topla=0>
					<cfoutput query="get_rows">
						<cfset gross_toplam = gross_toplam + TOTAL>
						<cfset net_toplam = net_toplam + NET_TOTAL>
						<tr id="frm_row#currentrow#">
							<td><input  type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#"><a href="javascript://" onClick="sil('#currentrow#');"><i class="fa fa-minus"></i></a></td>
							<td>
								<div class="form-group">
									<input type="hidden" name="wrk_row_id#currentrow#" id="wrk_row_id#currentrow#" value="#wrk_row_id#">
									<input type="hidden" name="wrk_row_relation_id#currentrow#" id="wrk_row_relation_id#currentrow#" value="">
									<input type="hidden" class="boxtext" name="entry_date#currentrow#" id="entry_date#currentrow#" value="#entry_date#">
									<input type="hidden" class="boxtext" name="invent_id#currentrow#" id="invent_id#currentrow#" style="width:100%;" value="#INVENTORY_ID#">
									<input type="text" class="boxtext" name="invent_no#currentrow#" id="invent_no#currentrow#" style="width:100%;" value="#INVENTORY_NUMBER#" title="#INVENTORY_NAME#" maxlength="50" readonly>
								</div>
							</td>
							<cfset inventory_name_ = Replace(Replace(INVENTORY_NAME,'"','','ALL'),"'","","ALL")>
							<td><div class="form-group"><input type="text" class="boxtext" name="invent_name#currentrow#" id="invent_name#currentrow#" style="width:100px;" value="#inventory_name_#" title="#inventory_name_#" maxlength="100" readonly></div></td>
							<td><div class="form-group"><input type="text" name="quantity#currentrow#" id="quantity#currentrow#" style="width:100%;" class="moneybox" value="#STOCK_QUANTITY#" onBlur="hesapla('#currentrow#');" onkeyup="return(FormatCurrency(this,event));" title="#INVENTORY_NAME#"></div></td>
							<td>
								<div class="form-group">
									<input type="text" name="row_total#currentrow#" id="row_total#currentrow#" value="#TLFormat(PRICE)#" onkeyup="return(FormatCurrency(this,event));" onBlur="hesapla('#currentrow#');" style="width:100%;" class="moneybox" title="#INVENTORY_NAME#">
								</div>
							</td>
							<td>
								<div class="form-group">
									<select name="tax_rate#currentrow#" id="tax_rate#currentrow#" style="width:100%;" onChange="hesapla('#currentrow#');" class="box">
										<cfset deger_tax = TAX>
										<cfloop query="get_tax">
											<option value="#tax#" <cfif deger_tax eq TAX>selected</cfif>>#tax#</option>
										</cfloop>
									</select>
								</div>
							</td>
							<td><div class="form-group"><input type="text" name="kdv_total#currentrow#" id="kdv_total#currentrow#" value="#TLFormat(TOTAL_TAX)#" onkeyup="return(FormatCurrency(this,event));" style="width:60px;" onBlur="hesapla('#currentrow#',1);" class="moneybox" title="#INVENTORY_NAME#"></div></td>
							<td><div class="form-group"><input type="text" name="net_total#currentrow#" id="net_total#currentrow#" value="#TLFormat(NET_TOTAL)#" class="moneybox" readonly></div></td>
							<td><div class="form-group"><input type="text" name="row_other_total#currentrow#" id="row_other_total#currentrow#" value="#TLFormat(PRICE_OTHER * AMOUNT)#" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="moneybox" readonly="yes" title="#INVENTORY_NAME#"></div></td>
							<td>
								<div class="form-group">
									<select name="money_id#currentrow#" id="money_id#currentrow#" style="width:100%;" class="boxtext" onchange="hesapla('#currentrow#',1);">
										<cfset deger_money = OTHER_MONEY>
										<cfloop query="get_money">
										<option value="#money#,#rate1#,#rate2#" <cfif deger_money eq money>selected</cfif>>#money#</option>
										</cfloop>
									</select>
								</div>
							</td>
							<td><div class="form-group"><input type="text" class="moneybox" readonly="yes" name="amortization_rate#currentrow#" id="amortization_rate#currentrow#" style="width:100%;" value="#TLFormat(AMORTIZATON_ESTIMATE)#" onkeyup="return(FormatCurrency(this,event));" title="#INVENTORY_NAME#"></div></td>
							<cfif AMORTIZATON_METHOD eq 0>
								<cfsavecontent variable="method"><cf_get_lang dictionary_id='29421.Azalan Bakiye Üzerinden'></cfsavecontent>
							<cfelseif AMORTIZATON_METHOD eq 1>
								<cfsavecontent variable="method"><cf_get_lang dictionary_id='29422.Sabit Miktar Üzeriden'></cfsavecontent>
							</cfif>
							<td>
								<div class="form-group">
									<input type="text" name="amortization_method#currentrow#" id="amortization_method#currentrow#" style="width:165px;" class="boxtext" value="#method#" title="#INVENTORY_NAME#" readonly>
								</div>
							</td>
							<td nowrap="nowrap">
								<div class="form-group">
									<div class="input-group">
										<input type="hidden" name="account_id#currentrow#" id="account_id#currentrow#" value="#ACCOUNT_ID#">
										<input type="text" name="account_code#currentrow#" id="account_code#currentrow#" class="boxtext" value="#ACCOUNT_ID#" title="#INVENTORY_NAME#" readonly="readonly">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac_acc('#currentrow#');"></span>
									</div>
								</div>
							</td>
							<td>
								<div class="form-group">
									<input type="hidden" name="unit_first_value#currentrow#" id="unit_first_value#currentrow#" value="#Tlformat(invent_amount)#">
									<input type="hidden" name="total_first_value#currentrow#" id="total_first_value#currentrow#" value="#Tlformat(invent_amount*stock_quantity)#">
									<input type="hidden" name="unit_last_value#currentrow#" id="unit_last_value#currentrow#" value="#Tlformat(last_inventory_value)#">
									<input type="text" name="last_inventory_value#currentrow#" id="last_inventory_value#currentrow#" value="#Tlformat(last_inventory_value*stock_quantity)#" style="width:100%;" class="moneybox"readonly="yes">
								</div>
							</td>
							<td>
								<div class="form-group">
									<input type="text" name="last_diff_value#currentrow#" id="last_diff_value#currentrow#" value="#Tlformat(NET_TOTAL - last_inventory_value*stock_quantity)#" style="width:100%;" class="moneybox" readonly="yes">
								</div>
							</td>
							<td nowrap="nowrap">
								<div class="form-group">
									<div class="input-group">
										<input type="hidden" name="expense_center_id#currentrow#" id="expense_center_id#currentrow#" value="#SALE_EXPENSE_CENTER_ID#" >
										<input type="text" name="expense_center_name#currentrow#" id="expense_center_name#currentrow#" onFocus="exp_center(#currentrow#);" value="<cfif len(SALE_EXPENSE_CENTER_ID) and len(exp_center_id_list)>#get_expense_center.expense[listfind(exp_center_id_list,SALE_EXPENSE_CENTER_ID,',')]#</cfif>" style="width:150px;" class="boxtext"><span class="input-group-addon btnPointer icon-ellipsis" onClick="pencere_ac_exp_center(#currentrow#);"></span>
									</div>
								</div>
							</td>
							<td nowrap="nowrap">
								<div class="form-group">
									<div class="input-group">
										<input type="hidden" name="budget_item_id#currentrow#" id="budget_item_id#currentrow#" value="#SALE_EXPENSE_ITEM_ID#">
										<input type="text" name="budget_item_name#currentrow#" id="budget_item_name#currentrow#" onFocus="exp_item(#currentrow#);" value="<cfif len(SALE_EXPENSE_ITEM_ID) and len(item_id_list)>#get_exp_detail.EXPENSE_ITEM_NAME[listfind(item_id_list,SALE_EXPENSE_ITEM_ID,',')]#</cfif>" style="width:115px;" class="boxtext" title="#INVENTORY_NAME#">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac_exp('#currentrow#');"></span>
									</div>
								</div>
							</td>
							<td nowrap="nowrap">
								<div class="form-group">
									<div class="input-group">
										<input type="hidden" name="budget_account_id#currentrow#" id="budget_account_id#currentrow#" value="<cfif len(SALE_DIFF_ACCOUNT_ID)>#SALE_DIFF_ACCOUNT_ID#</cfif>">
										<input type="text" name="budget_account_code#currentrow#" id="budget_account_code#currentrow#" class="boxtext" value="<cfif len(SALE_DIFF_ACCOUNT_ID)>#SALE_DIFF_ACCOUNT_ID#</cfif>" title="#INVENTORY_NAME#" style="width:155px;" onFocus="AutoComplete_Create('budget_account_code#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','ACCOUNT_CODE','budget_account_id#currentrow#','','3','225');">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac_acc_1('#currentrow#');"></span>
									</div>
								</div>
							</td>
							<td nowrap="nowrap">
								<div class="form-group">
									<div class="input-group">
										<input type="hidden" name="amort_account_id#currentrow#" id="amort_account_id#currentrow#" value="<cfif len(AMORT_DIFF_ACCOUNT_ID)>#AMORT_DIFF_ACCOUNT_ID#</cfif>">
										<input type="text" name="amort_account_code#currentrow#" id="amort_account_code#currentrow#" class="boxtext" value="<cfif len(AMORT_DIFF_ACCOUNT_ID)>#AMORT_DIFF_ACCOUNT_ID#</cfif>" title="#INVENTORY_NAME#" style="width:205px;" onFocus="AutoComplete_Create('amort_account_code#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','ACCOUNT_CODE','amort_account_id#currentrow#','','3','225');">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac_acc_2('#currentrow#');"></span>
									</div>
								</div>
							</td>
							<td nowrap="nowrap">
								<div class="form-group">
									<div class="input-group">
										<input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#PRODUCT_ID#">
										<input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#STOCK_ID#">
										<input type="text" name="product_name#currentrow#"  id="product_name#currentrow#" class="boxtext" value="#product_name#" title="#product_name#" style="width:110px;">
										<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_names&product_id=upd_invent.product_id#currentrow#&field_id=upd_invent.stock_id#currentrow#&field_unit_name=upd_invent.stock_unit#currentrow#&field_main_unit=upd_invent.stock_unit_id#currentrow#&field_name=upd_invent.product_name#currentrow#');"></span>	
									</div>
								</div>
							</td>
							<td nowrap="nowrap">
								<div class="form-group">
									<input type="hidden" name="stock_unit_id#currentrow#" id="stock_unit_id#currentrow#" value="#UNIT_ID#">
									<input type="text" name="stock_unit#currentrow#" id="stock_unit#currentrow#" width="100%" class="boxtext" value="#UNIT#" title="#INVENTORY_NAME#">
								</div>
							</td>
						</tr>
					</cfoutput>
				</tbody>
			</cf_grid_list>
			<cfset doviz_topla = gross_toplam / GET_STOCK_MONEY.rate2>
			<cfset doviz_kdv_topla = net_toplam / get_stock_money.rate2>
			<div class="ui-row">
				<div id="sepetim_total" class="padding-0">
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<div class="totalBox">
							<div class="totalBoxHead font-grey-mint">
								<span class="headText"><cf_get_lang dictionary_id='57677.Dövizler'> </span>
								<div class="collapse">
									<span class="icon-minus"></span>
								</div>
							</div>
							<div class="totalBoxBody">
								<table>
									<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#GET_STOCK_FIS_MONEY.recordcount#</cfoutput>">
									<cfoutput>
										<cfloop query="GET_STOCK_FIS_MONEY">
										<tr>
											<td>
												<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
												<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
												<input type="radio" name="rd_money" id="rd_money" value="#money#,#currentrow#,#rate1#,#rate2#" onClick="toplam_hesapla();"  <cfif GET_STOCK_FIS_MONEY.IS_SELECTED>checked</cfif>>#money#
											</td>
											<cfif session.ep.rate_valid eq 1>
												<cfset readonly_info = "yes">
											<cfelse>
												<cfset readonly_info = "no">
											</cfif>
											<td>#TLFormat(rate1,0)#/<input type="text" <cfif readonly_info>readonly</cfif> class="box" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#"  <cfif money eq session.ep.money>readonly="yes"</cfif> style="width:50px;" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="toplam_hesapla();"></td>
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
								<span class="headText"> <cf_get_lang dictionary_id='57492.Toplam'> </span>
								<div class="collapse">
									<span class="icon-minus"></span>
								</div>
							</div>
							<div class="totalBoxBody">
								<table>
										<tr>
											<td class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
											<td style="text-align:right;"><input type="text" name="total_amount" id="total_amount" class="box" readonly="readonly" value="<cfoutput>#TLFormat(gross_toplam)#</cfoutput>">&nbsp;&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
										</tr>
										<tr>
											<td class="txtbold"><cf_get_lang dictionary_id='56975.KDV li Toplam'></td>
											<td style="text-align:right;"><input type="text" name="net_total_amount" id="net_total_amount" class="box" readonly="readonly" value="<cfoutput>#TLFormat(net_toplam)#</cfoutput>">&nbsp;&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
										</tr>
								</table>
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
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
										<td id="rate_value1" style="text-align:right;"><input type="text" name="other_total_amount" id="other_total_amount" class="box" readonly="readonly" value="<cfoutput>#TLFormat(doviz_topla)#</cfoutput>">&nbsp;
											<input type="text" name="tl_value1" id="tl_value1" class="box" readonly="" value="<cfoutput>#GET_STOCK_MONEY.MONEY_TYPE#</cfoutput>" style="width:40px;">
										</td>
									</tr>
									<input type="hidden" name="kdv_total_amount" id="kdv_total_amount" class="box" readonly="" value="<cfoutput>#TLFormat(tax_toplam)#</cfoutput>">
									<input type="hidden" name="other_kdv_total_amount" id="other_kdv_total_amount" class="box" readonly="" value="">&nbsp;<input type="hidden" name="tl_value2" id="tl_value2" class="box" readonly="readonly" value="" style="width:40px;">
									<tr>
										<td class="txtbold"><cf_get_lang dictionary_id='56993.Döviz KDV li Toplam'></td>
										<td id="rate_value3" style="text-align:right;"><input type="text" name="other_net_total_amount" id="other_net_total_amount" class="box" readonly="readonly" value="<cfoutput>#TLFormat(doviz_kdv_topla)#</cfoutput>">&nbsp;
										<input type="text" name="tl_value3" id="tl_value3" class="box" readonly="" value="<cfoutput>#GET_STOCK_MONEY.MONEY_TYPE#</cfoutput>" style="width:40px;"></td>
									</tr>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
		</cf_basket>
	</cfform>
</cf_box>

<script type="text/javascript">
	function kontrol()
	{
		if (!chk_process_cat('upd_invent')) return false;
		if(!check_display_files('upd_invent')) return false;
		if(upd_invent.department_id.value=="" || upd_invent.department_name.value=="")
		{
			alert("<cf_get_lang dictionary_id='56984.Departman Seçiniz'>!");
			return false;
		}
		record_exist=0;
		for(r=1;r<=upd_invent.record_num.value;r++)
		{
			if(eval("document.upd_invent.row_kontrol"+r).value == 1)
			{
				record_exist=1;
				if (eval("document.upd_invent.invent_no"+r).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='56981.Lütfen Demirbaş No Giriniz'>!");
					return false;
				}
				if (eval("document.upd_invent.invent_name"+r).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='56986.Lütfen Açıklama Giriniz'>  !");
					return false;
				}
				if ((eval("document.upd_invent.row_total"+r).value == ""))
				{ 
					alert ("<cf_get_lang dictionary_id='29535.Lütfen Tutar Giriniz '>!");
					return false;
				}
				if ((eval("document.upd_invent.amortization_rate"+r).value == "")||(eval("document.upd_invent.amortization_rate"+r).value ==0))
				{ 
					alert ("<cf_get_lang dictionary_id='56988.Lütfen Amortisman Oranı Giriniz'> !");
					return false;
				}
				if (eval("document.upd_invent.account_code"+r).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='56989.Lütfen Muhasebe Kodu Seçiniz'>");
					return false;
				}
				if (eval("document.upd_invent.last_diff_value"+r).value != 0 && filterNum(eval("document.upd_invent.last_diff_value"+r).value) > 0 && eval("document.upd_invent.budget_account_code"+r).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='56958.Lütfen Gelir/Gider Farkı İçin Muhasebe Kodu Seçiniz'>!");
					return false;
				}
				if (eval("document.upd_invent.last_diff_value"+r).value != 0 && filterNum(eval("document.upd_invent.last_diff_value"+r).value) > 0 && eval("document.upd_invent.amort_account_code"+r).value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='56957.Lütfen Amortisman Karşılık Muhasebe Kodu Seçiniz'>!");
					return false;
				}
				if (eval("document.upd_invent.stock_id"+r).value == '' || eval("document.upd_invent.product_name"+r).value == '')
				{
					alert ("<cf_get_lang dictionary_id='57725.Ürün Seçiniz'> !");
					return false;
				}
				var listParam = eval("document.upd_invent.invent_id"+r).value;
				var get_invent_amortization = wrk_safe_query("get_inventory_amort_number","dsn3",0,listParam);
				if(get_invent_amortization.recordcount)
				{
					if(datediff(date_format(get_invent_amortization.RECORD_DATE,dateformat_style),document.upd_invent.start_date.value,0) <= 0)
					{
						alert("<cf_get_lang dictionary_id='59788.Değerlemesi Yapılan Demirbaş Bulunmaktadır'>! <cf_get_lang dictionary_id='58508.Satır'>: "+r);
						return false;
					}
				}
			}
		}
		if (record_exist == 0) 
		{
			alert("<cf_get_lang dictionary_id='56983.Lütfen Demirbaş Giriniz'>!");
			return false;
		}
		return unformat_fields();
	}
	function unformat_fields()
	{
		for(r=1;r<=upd_invent.record_num.value;r++)
		{
			deger_total = eval("document.upd_invent.row_total"+r);
			deger_kdv_total= eval("document.upd_invent.kdv_total"+r);
			deger_net_total = eval("document.upd_invent.net_total"+r);
			deger_other_net_total = eval("document.upd_invent.row_other_total"+r);
			deger_amortization_rate = eval("document.upd_invent.amortization_rate"+r);
			last_diff_value = eval("document.upd_invent.last_diff_value"+r);
			last_inventory_value = eval("document.upd_invent.last_inventory_value"+r);
			total_first_value = eval("document.upd_invent.total_first_value"+r);
			unit_first_value = eval("document.upd_invent.unit_first_value"+r);
			
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
		
		document.upd_invent.total_amount.value = filterNum(document.upd_invent.total_amount.value);
		document.upd_invent.kdv_total_amount.value = filterNum(document.upd_invent.kdv_total_amount.value);
		document.upd_invent.net_total_amount.value = filterNum(document.upd_invent.net_total_amount.value);
		document.upd_invent.other_total_amount.value = filterNum(document.upd_invent.other_total_amount.value);
		document.upd_invent.other_kdv_total_amount.value = filterNum(document.upd_invent.other_kdv_total_amount.value);
		document.upd_invent.other_net_total_amount.value = filterNum(document.upd_invent.other_net_total_amount.value);
		
		
		for(s=1;s<=upd_invent.kur_say.value;s++)
		{
			eval('upd_invent.txt_rate2_' + s).value = filterNum(eval('upd_invent.txt_rate2_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			eval('upd_invent.txt_rate1_' + s).value = filterNum(eval('upd_invent.txt_rate1_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
		
	}
	row_count=<cfoutput>#get_rows.recordcount#</cfoutput>;
	satir_say=<cfoutput>#get_rows.recordcount#</cfoutput>;
	function sil(sy)
	{
		var my_element=eval("upd_invent.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		toplam_hesapla();
		satir_say--;
	}
	function hesapla(satir,hesap_type)
	{
		var toplam_dongu_0 = 0;//satir toplam
		if(eval("document.upd_invent.row_kontrol"+satir).value==1)
		{
			deger_total = eval("document.upd_invent.row_total"+satir);//tutar
			deger_miktar = eval("document.upd_invent.quantity"+satir);//miktar
			deger_kdv_total= eval("document.upd_invent.kdv_total"+satir);//kdv tutarı
			deger_net_total = eval("document.upd_invent.net_total"+satir);//kdvli tutar
			deger_tax_rate = eval("document.upd_invent.tax_rate"+satir);//kdv oranı
			deger_last_value = eval("document.upd_invent.last_inventory_value"+satir);//Son değer
			deger_other_net_total = eval("document.upd_invent.row_other_total"+satir);//dovizli tutar kdv dahil
			deger_diff_value = eval("document.upd_invent.last_diff_value"+satir);//Fark
			deger_first_value = eval("document.upd_invent.total_first_value"+satir);//İlk değer
			deger_last_unit_value = eval("document.upd_invent.unit_last_value"+satir);//Son değer birim
			deger_first_unit_value = eval("document.upd_invent.unit_first_value"+satir);//İlk değer birim
			if(deger_total.value == "") deger_total.value = 0;
			if(deger_kdv_total.value == "") deger_kdv_total.value = 0;
			if(deger_net_total.value == "") deger_net_total.value = 0;
			deger_money_id = eval("document.upd_invent.money_id"+satir);
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
		for(r=1;r<=upd_invent.record_num.value;r++)
		{
			if(eval("document.upd_invent.row_kontrol"+r).value==1)
			{
				deger_total = eval("document.upd_invent.row_total"+r);//tutar
				deger_miktar = eval("document.upd_invent.quantity"+r);//miktar
				deger_kdv_total= eval("document.upd_invent.kdv_total"+r);//kdv tutarı
				deger_net_total = eval("document.upd_invent.net_total"+r);//kdvli tutar
				deger_tax_rate = eval("document.upd_invent.tax_rate"+r);//kdv oranı
				deger_other_net_total = eval("document.upd_invent.row_other_total"+r);//dovizli tutar kdv dahil
				deger_money_id = eval("document.upd_invent.money_id"+r);
				deger_money_id_ilk = list_getat(deger_money_id.value,1,',');
				for(s=1;s<=upd_invent.kur_say.value;s++)
					{
						if(list_getat(document.upd_invent.rd_money[s-1].value,1,',') == deger_money_id_ilk)
						{
							satir_rate2= eval("document.upd_invent.txt_rate2_"+s).value;
						}
					}
				satir_rate2= filterNum(satir_rate2,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');			
				deger_total.value = filterNum(deger_total.value);
				deger_kdv_total.value = filterNum(deger_kdv_total.value);
				deger_net_total.value = filterNum(deger_net_total.value);
				deger_other_net_total.value = filterNum(deger_other_net_total.value);
				toplam_dongu_1 = toplam_dongu_1 + parseFloat(deger_total.value * deger_miktar.value);
				toplam_dongu_2 = toplam_dongu_2 + parseFloat(deger_kdv_total.value);
				toplam_dongu_3 = toplam_dongu_3 + (parseFloat(deger_total.value * deger_miktar.value) + parseFloat(deger_kdv_total.value));
				deger_other_net_total.value = ((parseFloat(deger_total.value * deger_miktar.value) + parseFloat(deger_kdv_total.value)) / (parseFloat(satir_rate2)));
				deger_net_total.value = commaSplit(deger_net_total.value);
				deger_total.value = commaSplit(deger_total.value);
				deger_kdv_total.value = commaSplit(deger_kdv_total.value);
				deger_other_net_total.value = commaSplit(deger_other_net_total.value);
			}
		}
			
		document.upd_invent.total_amount.value = commaSplit(toplam_dongu_1);
		document.upd_invent.kdv_total_amount.value = commaSplit(toplam_dongu_2);
		document.upd_invent.net_total_amount.value = commaSplit(toplam_dongu_3);
		for(s=1;s<=upd_invent.kur_say.value;s++)
		{
			form_txt_rate2_ = eval("document.upd_invent.txt_rate2_"+s);
			if(form_txt_rate2_.value == "")
				form_txt_rate2_.value = 1;
		}
		if(upd_invent.kur_say.value == 1)
			for(s=1;s<=upd_invent.kur_say.value;s++)
			{
				if(document.upd_invent.rd_money.checked == true)
				{
					deger_diger_para = document.upd_invent.rd_money;
					form_txt_rate2_ = eval("document.upd_invent.txt_rate2_"+s);
				}
			}
		else 
			for(s=1;s<=upd_invent.kur_say.value;s++)
			{
				if(document.upd_invent.rd_money[s-1].checked == true)
				{
					deger_diger_para = document.upd_invent.rd_money[s-1];
					form_txt_rate2_ = eval("document.upd_invent.txt_rate2_"+s);
				}
			}
		deger_money_id_1 = list_getat(deger_diger_para.value,1,',');
		//deger_money_id_2 = list_getat(deger_diger_para.value,2,',');
		deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
		form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.upd_invent.other_total_amount.value = commaSplit(toplam_dongu_1 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)));
		document.upd_invent.other_kdv_total_amount.value = commaSplit(toplam_dongu_2 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)));
		document.upd_invent.other_net_total_amount.value = commaSplit(toplam_dongu_3 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)));
	
		document.upd_invent.tl_value1.value = deger_money_id_1;
		document.upd_invent.tl_value2.value = deger_money_id_1;
		document.upd_invent.tl_value3.value = deger_money_id_1;
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
		document.upd_invent.record_num.value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		x = '<input  type="hidden" value="WRK'+row_count+ js_create_unique_id() + row_count+'" name="wrk_row_id' + row_count +'"><input  type="hidden" value="" name="wrk_row_relation_id' + row_count +'">';
		newCell.innerHTML = x + '<input  type="hidden" value="1" name="row_kontrol' + row_count +'" ><a href="javascript://" onclick="sil(' + row_count + ');"><i class="fa fa-minus"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="entry_date' + row_count +'" value="'+ entry_date +'" readonly><input type="hidden" name="invent_id' + row_count +'" value="'+ invent_id +'" readonly><input type="text" name="invent_no' + row_count +'" style="width:100%;" class="boxtext" value="'+ invent_no +'"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="invent_name' + row_count +'" style="width:100%;"  readonly class="boxtext" value="'+ invent_name +'" maxlength="100"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("upd_invent.invent_name"+satir_say).value;
		newCell.innerHTML = '<div class="form-group"><input type="text" name="quantity' + row_count +'" style="width:100%;" class="moneybox" value="'+ quantity +'" onBlur="hesapla(' + row_count +');" onkeyup="return(FormatCurrency(this,event));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("upd_invent.invent_name"+satir_say).value;
		newCell.innerHTML = '<div class="form-group"><input type="text" name="row_total' + row_count +'" value="' + unit_last_value + '" onkeyup="return(FormatCurrency(this,event));" onBlur="hesapla(' + row_count +');" style="width:100%;" class="moneybox"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("upd_invent.invent_name"+satir_say).value;
		newCell.innerHTML = '<div class="form-group"><select name="tax_rate'+ row_count +'" style="width:100%;" onChange="hesapla('+ row_count +');" class="box"><cfoutput query="get_tax"><option value="#tax#">#tax#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("upd_invent.invent_name"+satir_say).value;
		newCell.innerHTML = '<div class="form-group"><input type="text" name="kdv_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" onBlur="hesapla(' + row_count +',1);" class="moneybox"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("upd_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<div class="form-group"><input type="text" name="net_total' + row_count +'" value="0" class="moneybox" readonly></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("upd_invent.invent_name"+satir_say).value;
		newCell.innerHTML = '<div class="form-group"><input type="text" name="row_other_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="moneybox" readonly></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("upd_invent.invent_name"+satir_say).value;
		newCell.innerHTML = '<div class="form-group"><select name="money_id' + row_count  +'" style="width:100%;" class="boxtext" onChange="hesapla('+ row_count +');"><cfoutput query="get_money"><option value="#money#,#rate1#,#rate2#" <cfif money eq session.ep.money>selected</cfif>>#money#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("upd_invent.invent_name"+satir_say).value;
		newCell.innerHTML = '<div class="form-group"><input type="text" readonly="yes" name="amortization_rate' + row_count +'" value="'+ amort_rate +'" style="width:100%;" class="moneybox" onkeyup="return(FormatCurrency(this,event));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("upd_invent.invent_name"+satir_say).value;
		if(amortizaton_method == 0)
			newCell.innerHTML = '<div class="form-group"><input type="text" readonly name="amortization_method'+ row_count +'" style="width:165px;" class="moneybox" value="<cf_get_lang dictionary_id='29421.Azalan Bakiye Üzerinden'>"></div>';
		else if(amortizaton_method == 1)
			newCell.innerHTML = '<div class="form-group"><input type="text" readonlyname="amortization_method'+ row_count +'" style="width:165px;" class="moneybox" value="<cf_get_lang dictionary_id='29422.Sabit Miktar Üzeriden'>"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("upd_invent.invent_name"+satir_say).value;
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" readonly name="account_id' + row_count +'"  value="'+ acc_id +'"><input type="text" readonly style="width:115px;"  name="account_code' + row_count +'"  value="'+ acc_id +'" class="boxtext" ><span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac_acc('+ row_count +');" ></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("upd_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="unit_first_value' + row_count +'" value="'+ unit_first_value +'"><input type="hidden" name="total_first_value' + row_count +'" value="'+ total_first_value +'"><input type="hidden" name="unit_last_value' + row_count +'" value="'+ unit_last_value +'"><input type="text" name="last_inventory_value' + row_count +'" value="'+ last_inventory_value +'" style="width:100%;" class="moneybox" onkeyup="return(FormatCurrency(this,event));" readonly="yes"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("upd_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<div class="form-group"><input type="text" name="last_diff_value' + row_count +'" value="'+last_diff_value+'" style="width:100%;" class="moneybox" onkeyup="return(FormatCurrency(this,event));" readonly="yes"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.title=eval("upd_invent.invent_name"+satir_say).value;	
		newCell.innerHTML ='<div class="form-group"><div class="input-group"><input type="hidden" name="expense_center_id' + row_count +'" value="'+expense_center_id+'" id="expense_center_id' + row_count +'"><input type="text" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'" onFocus="exp_center('+row_count+');" value="'+expense_center_name+'" style="width:150px;" class="boxtext"><span class="input-group-addon btnPointer icon-ellipsis" onClick="pencere_ac_exp_center('+ row_count +');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.title=eval("upd_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" name="budget_item_id' + row_count +'" id="budget_item_id' + row_count +'" value='+budget_item_id+'><input type="text" style="width:118px;" name="budget_item_name' + row_count +'" id="budget_item_name' + row_count +'" class="boxtext" value="'+budget_item_name+'" onFocus="exp_item('+row_count+');"><span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac_exp('+ row_count +');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.title=eval("upd_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" name="budget_account_id' + row_count +'" id="budget_account_id' + row_count +'" value="'+debt_account_id+'"><input type="text" name="budget_account_code' + row_count +'" id="budget_account_code' + row_count +'" value="'+debt_account_id+'" class="boxtext" style="width:158px;" onFocus="autocomp_budget_account('+row_count+');"><span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac_acc_1('+ row_count +');" ></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.title=eval("upd_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" name="amort_account_id' + row_count +'" id="amort_account_id' + row_count +'" value="'+claim_account_id+'"><input type="text" name="amort_account_code' + row_count +'" id="amort_account_code' + row_count +'" value="'+claim_account_id+'" class="boxtext" style="width:205px;" onFocus="autocomp_amort_account('+row_count+');"> <span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac_acc_2('+ row_count +');" ></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.title=eval("upd_invent.invent_name"+satir_say).value;
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" name="product_id' + row_count +'" value="'+product_id+'"><input  type="hidden" value="'+stock_id+'" name="stock_id' + row_count +'" ><input type="text" name="product_name' + row_count +'" class="boxtext" style="width:110px;" value="'+product_name+'">'
							+' '+'<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=upd_invent.product_id" + row_count + "&field_id=upd_invent.stock_id" + row_count + "&field_unit_name=upd_invent.stock_unit" + row_count + "&field_main_unit=upd_invent.stock_unit_id" + row_count + "&field_name=upd_invent.product_name" + row_count + "');"+'"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("upd_invent.invent_name"+satir_say).value;
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="stock_unit_id' + row_count +'" value="'+stock_unit_id+'"><input type="text" name="stock_unit' + row_count +'" value="'+stock_unit+'" style="width:100%;" class="boxtext"></div>';
		hesapla(row_count);
	}
	/* masraf merkezi popup */
	function pencere_ac_exp_center(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=upd_invent.expense_center_id' + no +'&field_name=upd_invent.expense_center_name' + no);
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
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=upd_invent.account_id' + no +'&field_name=upd_invent.account_code' + no +'','list');
	}
	function pencere_ac_acc_1(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=upd_invent.budget_account_id' + no +'&field_name=upd_invent.budget_account_code' + no +'','list');
	}
	function pencere_ac_acc_2(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=upd_invent.amort_account_id' + no +'&field_name=upd_invent.amort_account_code' + no +'','list');
	}
	function pencere_ac_exp(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=upd_invent.budget_item_id' + no +'&field_name=upd_invent.budget_item_name' + no +'&field_account_no=upd_invent.budget_account_code' + no +'&field_account_no2=upd_invent.budget_account_id' + no);
	}
	function ayarla_gizle_goster()
	{
		if(upd_invent.cash.checked)
			kasa_sec.style.display='';
		else
			kasa_sec.style.display='none';
	}
	function f_upd_invent()
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_inventory&field_id=upd_invent.invent_id','wide');
	}
</script>
