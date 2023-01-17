<cfquery name="GET_STOCKBOND1" datasource="#DSN3#">
	SELECT
		S.*,
		SPR.*
	FROM
		STOCKBONDS AS S 
        LEFT JOIN STOCKBONDS_YIELD_PLAN_ROWS SPR ON SPR.STOCKBOND_ID = S.STOCKBOND_ID 
	WHERE
		S.STOCKBOND_ID = #attributes.stockbond_id#
</cfquery>
<cfquery name="GET_YIELD_PLAN_ROWS" datasource="#dsn3#">
	SELECT
		SPR.STOCKBOND_ID
	FROM
        STOCKBONDS_YIELD_PLAN_ROWS AS SPR
	WHERE
		SPR.STOCKBOND_ID = #attributes.stockbond_id#
</cfquery>
<cfif GET_YIELD_PLAN_ROWS.recordCount gt 0>
	<cfset plan_rows_recordCount = GET_YIELD_PLAN_ROWS.recordCount>
<cfelse>
	<cfset plan_rows_recordCount = 0>
</cfif>
<cfquery name="GET_STOCKBOND_TYPES" datasource="#DSN#">
	SELECT
		STOCKBOND_TYPE
	FROM 
		SETUP_STOCKBOND_TYPE
	WHERE
		STOCKBOND_TYPE_ID = #get_stockbond1.stockbond_type#
</cfquery>
<cfif len(get_stockbond1.row_exp_center_id)>
	<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
		SELECT 
			EXPENSE 
		FROM 
			EXPENSE_CENTER 
		WHERE 
			EXPENSE_ID=#get_stockbond1.row_exp_center_id#
	</cfquery>
</cfif>
<cfif len(get_stockbond1.row_exp_item_id)>
	<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
		SELECT 
			EXPENSE_ITEM_ID,
			EXPENSE_ITEM_NAME 
		FROM 
			EXPENSE_ITEMS 
		WHERE
			IS_EXPENSE = 1 AND EXPENSE_ITEM_ID = #get_stockbond1.row_exp_item_id#
	</cfquery>
</cfif>
<cfquery name="GET_STOCK_TOTAL" datasource="#dsn3#">
	SELECT 
		SUM(STOCKBOND_IN) AS STOCK_IN,
		SUM(STOCKBOND_OUT) AS STOCK_OUT
	FROM
		STOCKBONDS_INOUT
	WHERE 
		STOCKBOND_ID = #attributes.stockbond_id#
</cfquery>
<cfquery name="GET_STOCK" datasource="#dsn3#">
	SELECT 
		QUANTITY
	FROM
		STOCKBONDS_INOUT
	WHERE 
		STOCKBOND_ID = #attributes.stockbond_id#
</cfquery>
<cfquery name="GET_STOCKBONDS_VALUE_CHANGES" datasource="#dsn3#">
	SELECT 
		SVC.HISTORY_ID,
		SVC.ACTUAL_VALUE,
		SVC.OTHER_ACTUAL_VALUE,
		SVC.DATE,
		SVC.IS_DAD_ACCOUNT,
		SVC.IS_DAD_ACTION_ID,
		EMP.EMPLOYEE_NAME,
		EMP.EMPLOYEE_SURNAME
	 FROM STOCKBONDS_VALUE_CHANGES AS SVC JOIN #dsn_alias#.EMPLOYEES AS EMP ON SVC.RECORD_EMP = EMP.EMPLOYEE_ID
	 WHERE STOCKBOND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stockbond_id#">
	 ORDER BY DATE ASC
</cfquery>
<cfif GET_STOCKBONDS_VALUE_CHANGES.recordCount gt 0>
	<cfset value_change_recordCount = GET_STOCKBONDS_VALUE_CHANGES.recordCount>
<cfelse>
	<cfset value_change_recordCount = 0>
</cfif>
<cfif len(get_stock_total.stock_out)>
	<cfset stok=get_stock_total.stock_in-get_stock_total.stock_out>
<cfelse>
	<cfset stok=get_stock_total.stock_in>
</cfif>
<cf_catalystHeader>

<cfoutput>
<cf_box>
	<div class="row" type="row">
		<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
			<div class="form-group" id="item-stockbond_types">
				<label class="col col-6 txtbold"><cf_get_lang dictionary_id='51415.Menkul Kıymet Tipi'></label>
				<label class="col col-6">: #get_stockbond_types.stockbond_type#</label>
			</div>
			<div class="form-group" id="item-stockbond_code">
				<label class="col col-6 txtbold"><cf_get_lang dictionary_id='58585.Kod'></label>
				<label class="col col-6">: #get_stockbond1.stockbond_code#</label>
			</div>
			<div class="form-group" id="item-stok">
				<label class="col col-6 txtbold"><cf_get_lang dictionary_id='51408.Stok Miktarı'></label>
				<label class="col col-6">: #stok#</label>
			</div>
		</div>
		<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
			<div class="form-group" id="item-nominal_value">
				<label class="col col-6 txtbold"><cf_get_lang dictionary_id='51409.Nominal Değer'></label>
				<label class="col col-6">: #TLFormat(get_stockbond1.nominal_value,session.ep.our_company_info.rate_round_num)#</label>
			</div>
			<div class="form-group" id="item-other_nominal_value">
				<label class="col col-6 txtbold"><cf_get_lang dictionary_id='51410.Nominal Değer Döviz'></label>
				<label class="col col-6">: #TLFormat(get_stockbond1.other_nominal_value,session.ep.our_company_info.rate_round_num)#</label>
			</div>
			<div class="form-group" id="item-dateformat">
				<label class="col col-6 txtbold"><cf_get_lang dictionary_id='57640.Vade'></label>
				<label class="col col-6">: #dateformat(get_stockbond1.due_date,dateformat_style)#</label>
			</div>
		</div>
		<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
			<div class="form-group" id="item-purchase_value">
				<label class="col col-6 txtbold"><cf_get_lang dictionary_id='51411.Alış Değer'></label>
				<label class="col col-6">: #TLFormat(get_stockbond1.purchase_value,session.ep.our_company_info.rate_round_num)#</label>
			</div>
			<div class="form-group" id="item-company_info">
				<label class="col col-6 txtbold"><cf_get_lang dictionary_id='51412.Alış Değer Döviz'></label>
				<label class="col col-6">: #TLFormat(get_stockbond1.other_purchase_value,session.ep.our_company_info.rate_round_num)#</label>
			</div>
			<div class="form-group" id="item-stockbond.row_exp_center_id">
				<label class="col col-6 txtbold"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></label>
				<label class="col col-6">: <cfif len(get_stockbond1.row_exp_center_id)>#get_expense_center.expense#</cfif></label>
			</div>
		</div>
		<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
			<div class="form-group" id="item-purchase_value">
				<label class="col col-6 txtbold"><cf_get_lang dictionary_id='51413.Güncel Değer'></label>
				<label class="col col-6">: #TLFormat(get_stockbond1.ACTUAL_VALUE,session.ep.our_company_info.rate_round_num)#</label>
			</div>
			<div class="form-group" id="item-islem">
				<label class="col col-6 txtbold"><cf_get_lang dictionary_id='51414.Güncel Değer Döviz'></label>
				<label class="col col-6">: #TLFormat(get_stockbond1.OTHER_ACTUAL_VALUE,session.ep.our_company_info.rate_round_num)#</label>
			</div>
			<div class="form-group" id="item-expense_item">
				<label class="col col-6 txtbold"><cf_get_lang dictionary_id='58551.Gider Kalemi'></label>
				<label class="col col-6">: <cfif len(get_stockbond1.row_exp_item_id)>#get_expense_item.expense_item_name#</cfif></label>
			</div>
		</div>
	</div>
	<cf_box_footer>
		<cf_record_info query_name="get_stockbond1">
	</cf_box_footer>
</cf_box>
</cfoutput>
<cfquery name="GET_STOCKBOND" datasource="#dsn3#">
	SELECT 
		* 
	FROM 
		STOCKBONDS_SALEPURCHASE
	WHERE ACTION_ID IN
		(
			SELECT 
				SALES_PURCHASE_ID
			FROM
				STOCKBONDS_SALEPURCHASE_ROW
			WHERE STOCKBOND_ID = #attributes.stockbond_id#
		)
</cfquery>

<cf_box title="#getLang('','Menkul Kıymet Hareketleri','51416')#" closable="0">
	<cf_grid_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='57742.Tarih'></th>
				<th><cf_get_lang dictionary_id='57630.Tip'></th>
				<th><cf_get_lang dictionary_id='58586.İşlem Yapan'></th>	
				<th><cf_get_lang dictionary_id='57635.Miktar'></th>
				<th style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>	
				<th style="text-align:right;"><cf_get_lang dictionary_id='58056.Dövizli Tutar'></th>	
				<th><a href="javascript:void(0)"><i class="fa fa-pencil"></i></th>  
			</tr>
		</thead>
		<tbody>
			<cfif get_stockbond.recordcount>
					<cfset employee_id_list=''>
					<cfset company_id_list=''>
					<cfoutput query="get_stockbond">
						<cfif len(employee_id) and not listfind(employee_id_list,employee_id)>
							<cfset employee_id_list=listappend(employee_id_list,employee_id)>
						</cfif>
						<cfif len(company_id) and not listfind(company_id_list,company_id)>
							<cfset company_id_list=listappend(company_id_list,company_id)>
						</cfif>
					</cfoutput>
					<cfif listlen(employee_id_list)>
					<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
					<cfquery name="GET_EMPLOYEE_DETAIL" datasource="#DSN#">
						SELECT
							EMPLOYEE_NAME,
							EMPLOYEE_SURNAME,
							EMPLOYEE_ID
						FROM
							EMPLOYEES
						WHERE
							EMPLOYEE_ID IN (#employee_id_list#)
						ORDER BY
							EMPLOYEE_ID
					</cfquery>
					</cfif>
					<cfif listlen(company_id_list)>
					<cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
					<cfquery name="GET_COMPANY_DETAIL" datasource="#DSN#">
						SELECT
							FULLNAME,
							COMPANY_ID
						FROM
							COMPANY
						WHERE
							COMPANY_ID IN (#company_id_list#)
						ORDER BY
							COMPANY_ID
					</cfquery>
					</cfif>
					
			<cfoutput query="get_stockbond">
				<tr>
					<td>#dateformat(action_date,dateformat_style)#</td>
					<td>#get_process_name(process_type)#</td>
					<td><cfif listlen(employee_id_list)>#get_employee_detail.employee_name[listfind(employee_id_list,employee_id,',')]#&nbsp;
						#get_employee_detail.employee_surname[listfind(employee_id_list,employee_id,',')]#</cfif>
					</td>
					<td>#GET_STOCK.QUANTITY[currentrow]#</td>
					<td style="text-align:right;">#TLFormat(net_total,session.ep.our_company_info.rate_round_num)#</td>
					<td style="text-align:right;">#TLFormat(other_money_value,session.ep.our_company_info.rate_round_num)#</td>
					<td>
					<cfif process_type eq 293>
						<a href="#request.self#?fuseaction=credit.add_stockbond_purchase&event=upd&action_id=#ACTION_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id="57464.Güncelle">"></i></a>
					<cfelse>
						<a href="#request.self#?fuseaction=credit.add_stockbond_sale&event=upd&action_id=#ACTION_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id="57464.Güncelle">"></i></a>
					</cfif>
					</td>
				</tr>
			</cfoutput>
			<cfelse>
			<tr>
				<td colspan="12"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
			</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
</cf_box>
<div class="col col-6 col-md-6 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Değer Tarihçesi Grafiği','64452')#" closable="0">
	<cfif value_change_recordCount gt 0>
		<table class="ui-table-list">
			<script src="JS/Chart.min.js"></script>
			<canvas id="stockbondChart"></canvas>
			<script>
				var ctx = document.getElementById('stockbondChart');
					var myChartsss = new Chart(ctx, {
						type: 'line',
						data: {
							labels: [<cfloop from="1" to="#GET_STOCKBONDS_VALUE_CHANGES.recordcount#" index="jj">
								<cfoutput>"#dateformat(GET_STOCKBONDS_VALUE_CHANGES.DATE[jj],dateformat_style)# #timeformat(GET_STOCKBONDS_VALUE_CHANGES.DATE[jj],timeformat_style)#"</cfoutput>,</cfloop>],
							datasets: [{
								label: "<cf_get_lang dictionary_id='51413.Güncel Değer'>",
								backgroundColor : ['rgba(255, 99, 132, 0.2)'],
								borderColor: ['rgba(255, 99, 132, 1)',],
								data: [<cfloop from="1" to="#GET_STOCKBONDS_VALUE_CHANGES.recordcount#" index="jj">
								<cfoutput>#GET_STOCKBONDS_VALUE_CHANGES.OTHER_ACTUAL_VALUE[jj]#</cfoutput>,</cfloop>],
							}]
						},
						options: {
							scales: {
								yAxes: [{
									ticks: {
										beginAtZero: true
									}
								}]
							}
						}
				});
		</script>
		</table>
	<cfelse>
		<table class="ui-table-list">
			<cf_get_lang dictionary_id='64454.Menkul Kıymete Ait Değer Tarihçesi Bulunamadı'>!
		</table>
	</cfif>
	</cf_box>
</div>
<div class="col col-6 col-md-6 col-sm-12 col-xs-12">
	<cfset height = "">
	<cfif value_change_recordCount gt 0>
		<cfset height = "340px">
	</cfif>

	<cf_box 
		title="#getLang('','Değer Tarihçesi','64453')#" 
		closable="0" 
		add_href="javascript:connectAjax2('#attributes.stockbond_id#')" 
		scroll="1"
		uniquebox_height="#height#">
		
		<cf_grid_list>
			<thead>
				<tr>
					<th>#</th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='51413.Güncel Değer'></th>	
					<th style="text-align:right;"><cf_get_lang dictionary_id='51414.Güncel Değer Döviz'>></th>
					<th><cf_get_lang dictionary_id='33566.Değerleme Tarihi'></th>
					<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
					<th>
						<a href="javascript:void(0)"><i class="fa fa-pencil"></i></a>
					</th>
					<th><a href="javascript:void(0)"><i class="fa fa-table"></i></th>
				</tr>
			</thead>
			<tbody>
				<cfif value_change_recordCount gt 0>
					<cfoutput query="GET_STOCKBONDS_VALUE_CHANGES">
						<tr>
							<td>#currentrow#</td>
							<td style="text-align:right;">#TLFormat(ACTUAL_VALUE)#</td>
							<td style="text-align:right;">#TLFormat(OTHER_ACTUAL_VALUE)#</td>
							<td>#dateformat(DATE,dateformat_style)# #timeformat(DATE,timeformat_style)#</td>
							<td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
							<td>
								<cfif not len(IS_DAD_ACCOUNT) or IS_DAD_ACCOUNT eq 0>
									<a href="javascript:void(0)" onclick="connectAjax(#currentrow#,#history_id#);" id="stockbond_plus_detail#currentrow#"><i class="fa fa-pencil"></i></a>
								</cfif>
							</td>
							<td>
								<cfif IS_DAD_ACCOUNT eq 1>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#IS_DAD_ACTION_ID#&process_cat=2932','page','upd_term_deposit')" title="<cf_get_lang dictionary_id='58452.Mahsup Fişi'>"><i class="icon-fa fa-table"></i></a>
								</cfif>
							</td>
						</tr>
					</cfoutput>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif value_change_recordCount eq 0>
			<div class="ui-info-bottom">
				<p><cf_get_lang dictionary_id='64454.Menkul Kıymete Ait Değer Tarihçesi Bulunamadı'>!</p>
			</div>
		</cfif>
	</cf_box>
</div>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box title="<cfoutput>#getLang('','Getiri Tablosu','51378')#</cfoutput>" closable="0">
	<cf_grid_list>
		<thead>
			<tr>
				<th width="25"><cf_get_lang dictionary_id='58577.Sıra'></th>
				<th><cf_get_lang dictionary_id='47952.Periyot'></th>
				<th><cf_get_lang dictionary_id='57692.İşlem'></th>
				<th><cf_get_lang dictionary_id='48897.Hesaba Geçiş Tarihi'></th>
				<th style="text-align:right;"><cf_get_lang dictionary_id='51374.Getiri Tutarı'></th>    
				<th class="text-center"><cf_get_lang dictionary_id='57756.Durum'></th>
				<th class="text-center"><cf_get_lang dictionary_id='57692.İşlem'></th>
			</tr>
		</thead>
		<tbody>
			<cfif plan_rows_recordCount gt 0>
				<cfoutput query="GET_STOCKBOND1">
					<tr>
						<td>#currentrow#</td>
						<td>
							<cfif YIELD_PAYMENT_PERIOD eq 0><cf_get_lang dictionary_id='57490.Gün'>  
							<cfelseif YIELD_PAYMENT_PERIOD eq 1><cf_get_lang dictionary_id='58724.Ay'>
							<cfelseif YIELD_PAYMENT_PERIOD eq 2>3 <cf_get_lang dictionary_id='58724.Ay'>
							<cfelseif YIELD_PAYMENT_PERIOD eq 3>6 <cf_get_lang dictionary_id='58724.Ay'>
							<cfelseif YIELD_PAYMENT_PERIOD eq 4><cf_get_lang dictionary_id='58455.Yıl'>
							<cfelseif YIELD_PAYMENT_PERIOD eq 5> #SPECIAL_DAY# <cf_get_lang dictionary_id='57490.Gün'>
							<cfelseif YIELD_PAYMENT_PERIOD eq 6><cf_get_lang dictionary_id='33558.Vade Sonu'>
							</cfif> 
						</td> <!--- periyot --->
						<td>#OPERATION_NAME#</td> <!--- işlem --->
						<td>#dateformat(BANK_ACTION_DATE,dateformat_style)#</td> <!--- hesaba geçiş tarihi --->
						<td style="text-align:right;">#TLFormat(AMOUNT)#</td> <!--- periyot bazında getiri --->
						<td class="text-center">
							<cfif IS_PAYMENT eq 1>
									<i class="fa fa-bookmark" title="<cf_get_lang dictionary_id='49834.Tahsil Edilmiştir'>" style="vertical-align:middle;color:green;cursor:pointer;"></i>
							<cfelse>
									<i class="fa fa-bookmark" title="<cf_get_lang dictionary_id='59173.Tahsil Edilmedi'>" style="vertical-align:middle;color:red;cursor:pointer;"></i>
							</cfif>   
						</td>
						<td class="text-center">
							<cfif IS_PAYMENT eq 1>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=credit.list_stockbonds&event=updPaymentRevenue&yield_plan_row_id=#YIELD_PLAN_ROWS_ID#&acc_tahakkuk_code=#get_expense_item.expense_item_id#&stockbond_id=#attributes.stockbond_id#','medium');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
							<cfelse>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=credit.list_stockbonds&event=addPaymentRevenue&yield_plan_row_id=#YIELD_PLAN_ROWS_ID#&acc_tahakkuk_code=#get_expense_item.expense_item_id#&stockbond_id=#attributes.stockbond_id#','medium');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='48731.Hesaba Geçiş'>"></i></a>
							</cfif>  
						</td>
					</tr>
				</cfoutput>
			</cfif> 
		</tbody>
	</cf_grid_list>
	<cfif plan_rows_recordCount eq 0>
		<div class="ui-info-bottom">
			<p><cf_get_lang dictionary_id='64455.Menkul Kıymete Ait Getiri Kaydı Bulunamadı'>!</p>
		</div>
	</cfif>
</cf_box>
</div>

<script>
	function connectAjax(crtrow,history_id)
	{
		cfmodal('<cfoutput>#request.self#?fuseaction=credit.ajax_stockbond_value_currently</cfoutput>&history_id='+history_id, 'warning_modal');
	}
	function connectAjax2(stockbond_id)
	{
		cfmodal('<cfoutput>#request.self#?fuseaction=credit.ajax_stockbond_value_currently</cfoutput>&stockbond_id='+stockbond_id, 'warning_modal');
	}
</script>