<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.comp_name" default="">
<cfparam name="attributes.partner_name" default="">
<cfquery name="GET_STOCKBOND_TYPES" datasource="#dsn#">
	SELECT
		*
	FROM
		SETUP_STOCKBOND_TYPE
</cfquery>
<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
	SELECT
		EXPENSE_ITEM_ID,
		EXPENSE_ITEM_NAME
	FROM
		EXPENSE_ITEMS
	WHERE
		IS_EXPENSE = 1 
	ORDER BY
		EXPENSE_ITEM_NAME
</cfquery>
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT
		EXPENSE_ID,
		EXPENSE_CODE,
		EXPENSE
	FROM
		EXPENSE_CENTER
	ORDER BY
		EXPENSE
</cfquery>
<cfquery name="GET_BOND_ACTION" datasource="#dsn3#">
	SELECT
		*
	FROM
		STOCKBONDS_SALEPURCHASE
	WHERE
		<cfif isdefined('url.id')>
			ACTION_ID = #url.id#
		<cfelse>
			BANK_ACTION_ID = #url.action_id#
		</cfif>
</cfquery>
<cfquery name="GET_ACTION_MONEY" datasource="#dsn3#">
	SELECT
		MONEY_TYPE AS MONEY,
		*
	FROM
		STOCKBONDS_SALEPURCHASE_MONEY
	WHERE
		<cfif isdefined('url.id')>
			ACTION_ID=#url.id#
		<cfelse>
			ACTION_ID = #get_bond_action.action_id#
		</cfif>
</cfquery>
<cfif not get_action_money.recordcount>
	<cfquery name="GET_ACTION_MONEY" datasource="#dsn2#">
		SELECT
			MONEY,
			0 AS IS_SELECTED,
			*
		FROM
			SETUP_MONEY
	</cfquery>
</cfif>
<cfquery name="GET_STOCKBOND_ROWS" datasource="#dsn3#">
	SELECT
		* 
	FROM
		STOCKBONDS,
		STOCKBONDS_SALEPURCHASE_ROW
	WHERE
		<cfif isdefined('url.id')>
			STOCKBONDS_SALEPURCHASE_ROW.SALES_PURCHASE_ID = #url.id# AND
		<cfelse>
			STOCKBONDS_SALEPURCHASE_ROW.SALES_PURCHASE_ID  = #get_bond_action.action_id# AND
		</cfif>
		STOCKBONDS.STOCKBOND_ID = STOCKBONDS_SALEPURCHASE_ROW.STOCKBOND_ID
</cfquery>

<cfif get_bond_action.process_type eq 293>
	<cfsavecontent variable="baslik"><cf_get_lang dictionary_id='34401.Menkul Kıymet Alışı'></cfsavecontent>
<cfelseif get_bond_action.process_type eq 294>
	<cfsavecontent variable="baslik"><cf_get_lang dictionary_id='34402.Menkul Kıymet Satışı'></cfsavecontent>
</cfif>
<cfif isdefined("attributes.id")>
	<cfquery name="GET_CARD" datasource="#dsn2#">
		SELECT
			ACS.CARD_ID,
			ACS.ACTION_TYPE
		FROM
			ACCOUNT_CARD ACS
		WHERE
			ACS.ACTION_TYPE = #GET_BOND_ACTION.process_type#
			AND ACS.ACTION_ID =  #attributes.id#
	</cfquery>
<cfelse>
	<cfset GET_CARD.recordCount = 0> 
</cfif>
<cfsavecontent variable="right">
    <cfif GET_CARD.recordcount and isdefined("session.ep.user_level") and listgetat(session.ep.user_level,22)>
        <li><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=#get_card.action_type#</cfoutput>','page');"><i class="icon-fa fa-table"title="<cf_get_lang dictionary_id='59032.Muhasebe Hareketleri'>"></i></a></li>
    </cfif>
</cfsavecontent>
<cf_box title='#baslik#' right_images="#right#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_box_elements>
	<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column"  index="1" sort="true">
		<div class="form-group" id="item-process_cat">
			<label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'></label>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
				<cfquery name="get_setup_process_cat" datasource="#DSN3#">
					SELECT	 
						PROCESS_CAT 
					FROM 
						SETUP_PROCESS_CAT 
					WHERE 
						PROCESS_CAT_ID = #get_bond_action.process_cat#
				</cfquery>
				<cfoutput>#get_setup_process_cat.process_cat#</cfoutput>
			</div>
		</div>
		<div class="form-group" id="item-paper_no">
			<label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'></label>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12"><cfoutput>#get_bond_action.paper_no#</cfoutput></div>
		</div>
		<div class="form-group" id="item-fullname">
			<label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
				<cfif len(get_bond_action.company_id)>
					<cfquery name="GET_COMP" datasource="#dsn#">
						SELECT 
							FULLNAME 
						FROM
							COMPANY
						WHERE
							COMPANY_ID=#get_bond_action.company_id#
					</cfquery>	
				</cfif>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
				<cfif len(get_bond_action.company_id)><cfoutput>#get_comp.fullname#</cfoutput></cfif>
			</div>
		</div>
		<div class="form-group" id="item-action_date">
			<label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
				<cfoutput>#dateformat(get_bond_action.action_date,dateformat_style)#</cfoutput>
			</div>
		</div>
		<div class="form-group" id="item-ref_no">
			<label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='58794.Referans No'></label>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12"><cfoutput>#get_bond_action.ref_no#</cfoutput></div>
				
		</div>
	</div>
	<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column"  index="2" sort="true">
		<div class="form-group" id="item-account_currency_id">
				<label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='29449.Banka Hesabı'></label>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
				<cfinclude template="../query/get_accounts.cfm">
				<cfoutput query="get_accounts">
					<cfif get_bond_action.bank_acc_id eq account_id>#account_name#-#account_currency_id#</cfif>
				</cfoutput>
			</div>
		</div>
	
		<div class="form-group" id="item-partner_id">
			<label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'></label>
				<cfif len(get_bond_action.partner_id)>
					<cfquery name="GET_PARTNER" datasource="#dsn#">
						SELECT 
							PARTNER_ID,
							COMPANY_PARTNER_NAME,
							COMPANY_PARTNER_SURNAME
						FROM 
							COMPANY_PARTNER
						WHERE 
							PARTNER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_bond_action.partner_id#">
					</cfquery>
				</cfif>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
				<cfif len(get_bond_action.partner_id)><cfoutput>#get_partner.company_partner_name# #get_partner.company_partner_surname#</cfoutput></cfif>
			</div>
		</div>
		<div class="form-group" id="item-employee_name">
			<label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='58586.İşlem Yapan'></label>
				<cfif len(get_bond_action.employee_id)>
					<cfquery name="GET_EMP" datasource="#dsn#">
						SELECT 
							EMPLOYEE_NAME,
							EMPLOYEE_SURNAME 
						FROM 
							EMPLOYEES 
						WHERE 
							EMPLOYEE_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_bond_action.employee_id#">
					</cfquery>
				</cfif>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
				<cfif len(get_bond_action.employee_id)><cfoutput>#get_emp.employee_name# #get_emp.employee_surname#</cfoutput></cfif>
			</div>
		</div>
		<div class="form-group" id="item-broker_company">
			<label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="51417.Aracı Kurum"></label>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12"><cfoutput>#get_bond_action.broker_company#</cfoutput></div>
		</div>
		<div class="form-group" id="item-detail">
			<label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12"><cfoutput>#get_bond_action.detail#</cfoutput></div>
		</div>
	</div>
	<cf_grid_list>
		<thead>
			<tr>
				<th width="45"><cf_get_lang dictionary_id="57630.Tip"></th>
				<th width="45" class="text-right"><cf_get_lang dictionary_id="58585.Kod"></th>
				<th width="120"><cf_get_lang dictionary_id="57629.Açıklama"></th>
				<th width="70" class="text-right"><cf_get_lang dictionary_id="51409.Nominal Değer"></th>
				<th width="35" class="text-right"><cf_get_lang dictionary_id="51410.Nominal Değer Döviz"></th>
				<th clasS="form-title" width="70">
					<cfif get_bond_action.process_type eq 293><cf_get_lang dictionary_id="51411.Alış Değer"></cfif>
					<cfif get_bond_action.process_type eq 294><cf_get_lang dictionary_id="51440.Satış Değer"></cfif>
				</th> 
				<th width="70" class="text-right">
					<cfif get_bond_action.process_type eq 293><cf_get_lang dictionary_id="51412.Alış Değer Döviz"></cfif>
					<cfif get_bond_action.process_type eq 294><cf_get_lang dictionary_id="51441.Satış Değer Döviz"></cfif>
				</th>
				<th width="35" class="text-right"><cf_get_lang dictionary_id="57635.Miktar"></th>
				<th clasS="form-title" width="70">
					<cfif get_bond_action.process_type eq 293><cf_get_lang dictionary_id="51419.Toplam Alış"></cfif>
					<cfif get_bond_action.process_type eq 294><cf_get_lang dictionary_id="51436.Toplam Satış"></cfif>
				</th> 
				<th width="80" class="text-right">
					<cfif get_bond_action.process_type eq 293><cf_get_lang dictionary_id="51420.Toplam Alış Döviz"></cfif>
					<cfif get_bond_action.process_type eq 294><cf_get_lang dictionary_id="51442.Toplam Satış Döviz"></cfif>
				</th>
				<th width="90" class="text-right"><cf_get_lang dictionary_id="51813.Masraf Gelir Merkezi"></th> 
				<cfif get_bond_action.process_type eq 293>
					<th width="80" class="text-right"><cf_get_lang dictionary_id="58234.Bütçe Kalemi"></th>
					<th width="80" class="text-right"><cf_get_lang dictionary_id="57881.Vade Tarihi"></th>
				</cfif>
			</tr>
		</thead>
		<tbody>
			<cfset exp_item_id_list=''>
			<cfset exp_center_id_list=''>
			<cfset stockbond_type_list=''>
			<cfoutput query="get_stockbond_rows">
				<cfif len(row_exp_center_id) and not listfind(exp_center_id_list,row_exp_center_id)>
					<cfset exp_center_id_list=listappend(exp_center_id_list,row_exp_center_id)>
				</cfif>
				<cfif len(row_exp_item_id) and not listfind(exp_item_id_list,row_exp_item_id)>
					<cfset exp_item_id_list=listappend(exp_item_id_list,row_exp_item_id)>
				</cfif>
				<cfif len(stockbond_type) and not listfind(stockbond_type_list,stockbond_type)>
					<cfset stockbond_type_list=listappend(stockbond_type_list,stockbond_type)>
				</cfif>
			</cfoutput>
			<cfif len(exp_center_id_list)>
				<cfset exp_center_id_list=listsort(exp_center_id_list,"numeric","ASC",",")>
				<cfquery name="get_exp_center" datasource="#dsn2#">
					SELECT 
						EXPENSE_ID,
						EXPENSE_CODE,
						EXPENSE 
					FROM 
						EXPENSE_CENTER 
					WHERE 
						EXPENSE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#exp_center_id_list#">) 
					ORDER BY 
						EXPENSE
				</cfquery>
			</cfif>
			<cfif len(exp_item_id_list)>
				<cfset exp_item_id_list=listsort(exp_item_id_list,"numeric","ASC",",")>
				<cfquery name="get_exp_detail" datasource="#dsn2#">
					SELECT 
						EXPENSE_ITEM_NAME,
						EXPENSE_ITEM_ID 
					FROM 
						EXPENSE_ITEMS 
					WHERE 
						EXPENSE_ITEM_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#exp_item_id_list#">) 
					ORDER BY 
						EXPENSE_ITEM_ID
				</cfquery>
			</cfif>
			<cfif len(stockbond_type_list)>
				<cfset stockbond_type_list=listsort(stockbond_type_list,"numeric","ASC",",")>
				<cfquery name="get_bond_types" datasource="#dsn#">
					SELECT 
						* 
					FROM 
						SETUP_STOCKBOND_TYPE 
					WHERE 
						STOCKBOND_TYPE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#stockbond_type_list#">) 
					ORDER BY 
						STOCKBOND_TYPE_ID
				</cfquery>
			</cfif>
			<cfoutput query="get_stockbond_rows">
				<tr>
					<td>
						<cfif len(stockbond_type_list)>
							<cfset deger_bond_type = get_bond_types.stockbond_type_id[listfind(stockbond_type_list,stockbond_type,',')]>
						<cfelse>
							<cfset deger_bond_type=''>
						</cfif>
						<cfloop query="get_stockbond_types">
							<cfif deger_bond_type eq get_stockbond_types.stockbond_type_id>#stockbond_type#</cfif>
						</cfloop>
					</td>
					<td class="text-right">#stockbond_code#</td>
					<td>#detail#</td>
					<td class="text-right">#TLFormat(nominal_value,session.ep.our_company_info.rate_round_num)#</td>
					<td class="text-right">#TLFormat(other_nominal_value,session.ep.our_company_info.rate_round_num)#</td>
					<td class="text-right">#TLFormat(purchase_value)#</td>
					<td class="text-right">#TLFormat(other_purchase_value,session.ep.our_company_info.rate_round_num)#</td>
					<td class="text-right">#quantity#</td>
					<td class="text-right">#TLFormat(total_purchase,session.ep.our_company_info.rate_round_num)#</td>
					<td class="text-right">#TLFormat(other_total_purchase,session.ep.our_company_info.rate_round_num)#</td>
					<td>
						<cfif len(exp_center_id_list)>
							#get_exp_center.expense[listfind(exp_center_id_list,row_exp_center_id,',')]#
						</cfif>
					</td>
					<cfif get_bond_action.process_type eq 293>
						<td class="text-right">
							<cfif len(exp_item_id_list)>
								<cfset deger_exp_item = get_exp_detail.expense_item_id[listfind(exp_item_id_list,row_exp_item_id,',')]>
							<cfelse>
								<cfset deger_exp_item =''>
							</cfif>
							<cfloop query="get_expense_item">
								<cfif deger_exp_item eq get_expense_item.expense_item_id>#expense_item_name#</cfif>
							</cfloop>
						</td>
						<td class="text-right">#dateformat(due_date,dateformat_style)#</td>
					</cfif>
				</div>
			</cfoutput>
		</tbody>
	</cf_grid_list>
	
		<cfoutput query="get_bond_action">
			<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column"  index="3" sort="true">
				<div class="form-group" id="item-net_total">
					<label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="51813.Alış Toplam"><cfoutput>#session.ep.money#</cfoutput></label>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12 text-right"><cfoutput>#TLFormat(net_total,session.ep.our_company_info.rate_round_num)#</cfoutput></div>
				</div>
				<div class="form-group" id="item-exp_center_id">
					
					<label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="58460.Masraf Merkezi"></label>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12 text-right">
						<cfif len(exp_center_id)>
							<cfquery name="get_main_center" datasource="#dsn2#">
								SELECT  
									EXPENSE,
									EXPENSE_ID 
								FROM 
									EXPENSE_CENTER 
								WHERE 
									EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#exp_center_id#">
							</cfquery>
						</cfif>
						<cfoutput><cfif len(exp_center_id)>#get_main_center.expense#</cfif></cfoutput>
					</div>
				</div>
				<div class="form-group" id="item-other_money_value">
					<label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="51813.Alış Toplam"><cfoutput>#get_bond_action.other_money#</cfoutput></label>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12 text-right">
						<cfoutput>#TLFormat(other_money_value,session.ep.our_company_info.rate_round_num)#</cfoutput>&nbsp;
					</div>
				</div>
				<div class="form-group" id="item-expense_item_name">
					<label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="58551.Gider Kalemi"></label>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12 text-right">
						<cfif len(exp_item_id)>
							<cfquery name="get_main_item" datasource="#dsn2#">
								SELECT 
									EXPENSE_ITEM_NAME,
									EXPENSE_ITEM_ID 
								FROM 
									EXPENSE_ITEMS 
								WHERE 
									IS_EXPENSE = 1 AND 
									EXPENSE_ITEM_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#exp_item_id#">
							
							</cfquery>
						</cfif>			   
						<cfoutput><cfif len(exp_item_id)>#get_main_item.expense_item_name#</cfif></cfoutput>
					</div>
				</div>					  
				<div class="form-group" id="item-com_rate">
					<label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="35334.Komisyon Oranı %"></label>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12 text-right"><cfoutput>#TLFormat(com_rate,session.ep.our_company_info.rate_round_num)#</cfoutput></div>
				</div>
			</div>
			<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column"  index="4" sort="true">
				<div class="form-group" id="item-account_code">
					<label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="58811.Muhasebe Kodu"></label>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12 text-right"><cfoutput>#account_code#</cfoutput></div>
				</div>
			
				<div class="form-group" id="item-rate_round_num">
					<label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="51425.Komisyon Toplam"><cfoutput>#session.ep.money#</cfoutput></label>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12 text-right"><cfoutput>#TLFormat(com_total,session.ep.our_company_info.rate_round_num)#</cfoutput></div>
				</div>
				<div class="form-group" id="item-expense">
					<label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="51426.Komisyon Masraf Merkezi"></label>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12 text-right">
						<cfif len(com_exp_center_id)>
							<cfquery name="get_com_main_center" datasource="#dsn2#">
								SELECT 
									EXPENSE,
									EXPENSE_ID 
								FROM 
									EXPENSE_CENTER 
								WHERE 
									EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#com_exp_center_id#">
							</cfquery>
						</cfif>
						<cfoutput><cfif len(com_exp_center_id)>#get_com_main_center.expense#</cfif></cfoutput>
					</div>
				</div>
				<div class="form-group" id="item-other_com_total">
					<label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="51425.Komisyon Toplam"> <cfoutput>#get_bond_action.other_money#</cfoutput></label>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12 text-right">#TLFormat(other_com_total,session.ep.our_company_info.rate_round_num)#</div>
				</div>
				<div class="form-group" id="item-expense_item_name">
					<label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="51427.Komisyon Gider Kalemi"></label>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12 text-right">
						<cfif len(com_exp_item_id)>
							<cfquery name="get_com_main_item" datasource="#dsn2#">
								SELECT 
									EXPENSE_ITEM_NAME,
									EXPENSE_ITEM_ID 
								FROM 
									EXPENSE_ITEMS 
								WHERE 
									IS_EXPENSE = 1 AND 
									EXPENSE_ITEM_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#com_exp_item_id#">
							</cfquery>
						</cfif>	
						<cfoutput><cfif len(com_exp_item_id)>#get_com_main_item.expense_item_name#</cfif></cfoutput>
					</div>
				</div>
				<div class="form-group" id="item-com_account_code">
					<label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="51428.Komisyon Muhasebe Kodu"></label>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12"><cfoutput>#com_account_code#</cfoutput></div>
				</div>
			</div>
		</cfoutput>
</cf_box_elements>
	<cf_box_footer>
		<cf_record_info query_name="get_bond_action">
	</cf_box_footer>
</cf_box>

