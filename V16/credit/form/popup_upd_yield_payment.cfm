
<cfquery name="GET_STOCKBOND" datasource="#DSN3#">
	SELECT
		*
	FROM
        STOCKBONDS AS ST
        LEFT JOIN STOCKBONDS_YIELD_PLAN_ROWS SPR ON SPR.STOCKBOND_ID = ST.STOCKBOND_ID 
 	WHERE
        ST.STOCKBOND_ID = #attributes.stockbond_id#
</cfquery>
<cfquery name="GET_STOCKBOND_TYPES" datasource="#DSN#">
	SELECT
		STOCKBOND_TYPE
	FROM 
		SETUP_STOCKBOND_TYPE
	WHERE
		STOCKBOND_TYPE_ID = #get_stockbond.stockbond_type#
</cfquery>
<cfif len(get_stockbond.row_exp_center_id)>
	<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
		SELECT 
			EXPENSE 
		FROM 
			EXPENSE_CENTER 
		WHERE 
			EXPENSE_ID=#get_stockbond.row_exp_center_id#
	</cfquery>
</cfif>
<cfif len(get_stockbond.row_exp_item_id)>
	<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
		SELECT 
			EXPENSE_ITEM_NAME 
		FROM 
			EXPENSE_ITEMS 
		WHERE
			IS_EXPENSE = 1 AND EXPENSE_ITEM_ID = #get_stockbond.row_exp_item_id#
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
<cfquery name="GET_INTEREST_VALUATION" datasource="#dsn3#">
    SELECT SYV.*, BP.BUDGET_PLAN_ID FROM
        STOCKBONDS_YIELD_VALUATION AS SYV
        LEFT JOIN #dsn_alias#.BUDGET_PLAN_ROW BPR ON SYV.BUDGET_PLAN_ROW_ID = BPR.BUDGET_PLAN_ROW_ID
        LEFT JOIN #dsn_alias#.BUDGET_PLAN BP ON BP.BUDGET_PLAN_ID = BPR.BUDGET_PLAN_ID
        WHERE STOCKBONDS_ROWS_ID = #GET_STOCKBOND.YIELD_PLAN_ROWS_ID#
</cfquery>
<cfif len(get_stock_total.stock_out)>
	<cfset stok=get_stock_total.stock_in-get_stock_total.stock_out>
<cfelse>
	<cfset stok=get_stock_total.stock_in>
</cfif>
<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
    SELECT * FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #GET_STOCKBOND.ROW_EXP_ITEM_ID#
</cfquery>
<cfsavecontent variable="lang"><cf_get_lang dictionary_id='40996.Menkul Kıymet Alış Getiri Hesap Detayı'></cfsavecontent>
<cfset pagehead="#lang#">
<cf_catalystHeader>

<div class="row">
    <div class="col col-12 uniqueRow">
        <div class="row formContent">
            <div class="row" type="row">
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-stockbond_types">
                        <label class="col col-6 txtbold"><cf_get_lang no ='83.Menkul Kıymet Tipi'></label>
                        <label class="col col-6">: <cfoutput>#get_stockbond_types.stockbond_type#</cfoutput></label>
                    </div>
                    <div class="form-group" id="item-stockbond_code">
                        <label class="col col-6 txtbold"><cf_get_lang_main no ='1173.Kod'></label>
                        <label class="col col-6">: <cfoutput>#GET_STOCKBOND.stockbond_code#</cfoutput></label>
                    </div>
                    <div class="form-group" id="item-stok">
                        <label class="col col-6 txtbold"><cf_get_lang no ='76.Stok Miktarı'></label>
                        <label class="col col-6">: <cfoutput>#stok#</cfoutput></label>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-nominal_value">
                        <label class="col col-6 txtbold"><cf_get_lang no ='77.Nominal Değer'></label>
                        <label class="col col-6">: <cfoutput>#TLFormat(GET_STOCKBOND.nominal_value,session.ep.our_company_info.rate_round_num)#</cfoutput></label>
                    </div>
                    <div class="form-group" id="item-other_nominal_value">
                        <label class="col col-6 txtbold"><cf_get_lang no ='78.Nominal Değer Döviz'></label>
                        <label class="col col-6">: <cfoutput>#TLFormat(GET_STOCKBOND.other_nominal_value,session.ep.our_company_info.rate_round_num)#</cfoutput></label>
                    </div>
                    <div class="form-group" id="item-dateformat">
                        <label class="col col-6 txtbold"><cf_get_lang_main no ='228.Vade'></label>
                        <label class="col col-6">: <cfoutput>#dateformat(GET_STOCKBOND.due_date,dateformat_style)#</cfoutput></label>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-purchase_value">
                        <label class="col col-6 txtbold"><cf_get_lang no ='79.Alış Değeri'></label>
                        <label class="col col-6">: <cfoutput>#TLFormat(GET_STOCKBOND.purchase_value,session.ep.our_company_info.rate_round_num)#</cfoutput></label>
                    </div>
                    <div class="form-group" id="item-company_info">
                        <label class="col col-6 txtbold"><cf_get_lang no ='80.Alış Değer Döviz'></label>
                        <label class="col col-6">: <cfoutput>#TLFormat(GET_STOCKBOND.other_purchase_value,session.ep.our_company_info.rate_round_num)#</cfoutput></label>
                    </div>
                    <div class="form-group" id="item-stockbond.row_exp_center_id">
                        <label class="col col-6 txtbold"><cf_get_lang_main no='1048.Masraf Merkezi'></label>
                        <label class="col col-6">: <cfif len(get_stockbond.row_exp_center_id)><cfoutput>#get_expense_center.expense#</cfoutput></cfif></label>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    <div class="form-group" id="item-purchase_value">
                        <label class="col col-6 txtbold"><cf_get_lang no ='81.Güncel Değer'></label>
                        <label class="col col-6">: <cfoutput>#TLFormat(GET_STOCKBOND.ACTUAL_VALUE,session.ep.our_company_info.rate_round_num)#</cfoutput></label>
                    </div>
                    <div class="form-group" id="item-islem">
                        <label class="col col-6 txtbold"><cf_get_lang no ='82.Güncel Değer Döviz'></label>
                        <label class="col col-6">: <cfoutput>#TLFormat(GET_STOCKBOND.OTHER_ACTUAL_VALUE,session.ep.our_company_info.rate_round_num)#</cfoutput></label>
                    </div>
                    <div class="form-group" id="item-expense_item">
                        <label class="col col-6 txtbold"><cf_get_lang_main no='1139.Gider Kalemi'></label>
                        <label class="col col-6">: <cfif len(get_stockbond.row_exp_item_id)><cfoutput>#get_expense_item.expense_item_name#</cfoutput></cfif></label>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="5" sort="true">
                    <div class="form-group" id="item-yield_rate">
                        <label class="col col-6 txtbold"><cf_get_lang dictionary_id='51373.Getiri Oranı'></label>
                        <label class="col col-6">: <cfoutput>#TLFormat(GET_STOCKBOND.YIELD_RATE)#</cfoutput></label>
                    </div>
                    <div class="form-group" id="item-islem">
                        <label class="col col-6 txtbold"><cf_get_lang dictionary_id ='51374.Getiri Tutarı'></label>
                        <label class="col col-6">: <cfoutput>#TLFormat(GET_STOCKBOND.YIELD_AMOUNT_TOTAL,session.ep.our_company_info.rate_round_num)#</cfoutput></label>
                    </div>
                    <div class="form-group" id="item-islem">
                        <label class="col col-6 txtbold"><cf_get_lang dictionary_id ='51376.Getiri Ödeme Periyodu'></label>
                        <label class="col col-6">
                            <cfif GET_STOCKBOND.YIELD_PAYMENT_PERIOD eq 0><cf_get_lang dictionary_id='57490.Gün'>  
                            <cfelseif GET_STOCKBOND.YIELD_PAYMENT_PERIOD eq 1><cf_get_lang dictionary_id='58724.Ay'>
                            <cfelseif GET_STOCKBOND.YIELD_PAYMENT_PERIOD eq 2>3 <cf_get_lang dictionary_id='58724.Ay'>
                            <cfelseif GET_STOCKBOND.YIELD_PAYMENT_PERIOD eq 3>6 <cf_get_lang dictionary_id='58724.Ay'>
                            <cfelseif GET_STOCKBOND.YIELD_PAYMENT_PERIOD eq 4><cf_get_lang dictionary_id='58455.Yıl'>
                            <cfelseif GET_STOCKBOND.YIELD_PAYMENT_PERIOD eq 5> <cfoutput>#SPECIAL_DAY#</cfoutput> <cf_get_lang dictionary_id='57490.Gün'>
                            </cfif> 
                        </label>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="6" sort="true">
                    <div class="form-group" id="item-yield_rate">
                        <label class="col col-6 txtbold"><cf_get_lang dictionary_id='57640.Vade'> <cf_get_lang dictionary_id='57490.Vade'></label>
                        <label class="col col-6">: <cfoutput>#GET_STOCKBOND.DUE_VALUE#</cfoutput></label>
                    </div>
                    <div class="form-group" id="item-expense_item">
                        <label class="col col-6 txtbold"><cf_get_lang dictionary_id='33556.Getiri Ödeme Sayısı'></label>
                        <label class="col col-6">: <cfoutput>#GET_STOCKBOND.NUMBER_YIELD_COLLECTION#</cfoutput></label>
                    </div>
                </div>
            </div>
            <cf_seperator id="getiri_tablosu" header="<cfoutput>#getLang('credit',46)#</cfoutput>">
                <div class="row" id="getiri_tablosu">
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                        <cf_grid_list>
                            <thead>
                                <tr>
                                    <th width="25"><cf_get_lang dictionary_id='58577.Sıra'></th>
                                    <th><cf_get_lang dictionary_id='47952.Periyot'></th>
                                    <th><cf_get_lang dictionary_id='57692.İşlem'></th>
                                    <th><cf_get_lang dictionary_id='48897.Hesaba Geçiş Tarihi'></th>
                                    <th><cf_get_lang dictionary_id='51374.Getiri Tutarı'></th>    
                                    <th class="text-center"><cf_get_lang dictionary_id='57756.Durum'></th>
                                    <th class="text-center"><i class="fa fa-pencil"></i></th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="GET_STOCKBOND">
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
                                        <td>#TLFormat(AMOUNT)#</td> <!--- periyot bazında getiri --->
                                        <td class="text-center">
                                            <cfif IS_PAYMENT eq 1>
                                                <i class="fa fa-bookmark" title="<cf_get_lang dictionary_id='49834.Tahsil Edilmiştir'>" style="vertical-align:middle;color:green;cursor:pointer;"></i>
                                            <cfelse>
                                                <i class="fa fa-bookmark" title="Tahsil Edilmedi" style="vertical-align:middle;color:red;cursor:pointer;"></i>
                                            </cfif>   
                                        </td>
                                        <td class="text-center">
                                            <cfif IS_PAYMENT eq 1>
                                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=credit.list_stockbonds&event=updPaymentRevenue&yield_plan_row_id=#YIELD_PLAN_ROWS_ID#&stockbond_id=#attributes.stockbond_id#&acc_tahakkuk_code=#GET_EXPENSE_ITEM.EXPENSE_ITEM_ID#','medium');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                                            <cfelse>
                                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=credit.list_stockbonds&event=addPaymentRevenue&yield_plan_row_id=#YIELD_PLAN_ROWS_ID#&stockbond_id=#attributes.stockbond_id#&acc_tahakkuk_code=#GET_EXPENSE_ITEM.EXPENSE_ITEM_ID#','medium');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='48731.Hesaba Geçiş'>"></i></a>
                                            </cfif> 
                                        </td>
                                    </tr>
                                </cfoutput>     
                            </tbody>
                        </cf_grid_list>
                    </div>
                </div>

                <cf_seperator id="reeskont_tablosu" header="#getLang('','Reeskont Tablosu','60886')#">
                    <div class="row" id="reeskont_tablosu">
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <cf_grid_list>
                                <thead>
                                    <tr>
                                        <th width="25"><cf_get_lang dictionary_id='58577.Sıra'></th>
                                        <th><cf_get_lang dictionary_id='59798.Reeskont Tarihi'></th>
                                        <th><cf_get_lang dictionary_id='38879.Gün Sayısı'></th>
                                        <th><cf_get_lang dictionary_id='50221.Reeskont Tutarı'></th>
                                        <cfif len(GET_INTEREST_VALUATION.budget_plan_id)>    
                                            <th class="text-center"><cf_get_lang dictionary_id='57692.İşlem'></th>
                                        </cfif>
                                    </tr>
                                </thead>
                                <tbody>
                                    <cfoutput query="GET_INTEREST_VALUATION">
                                        <tr>
                                            <td>#currentrow#</td>
                                            <td>#dateformat(STOCKBONDS_VALUATION_DATE,dateformat_style)#</td> <!--- hesaba geçiş tarihi --->
                                            <td>#DATE_DIFF#</td>
                                            <td>#TLFormat(STOCKBONDS_VALUATION_AMOUNT)#</td> <!--- periyot bazında getiri --->
                                            <cfif len(budget_plan_id)>
                                            <td class="text-center">
                                                <a href="#request.self#?fuseaction=budget.list_plan_rows&event=upd&budget_plan_id=#budget_plan_id#" target="_blank"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                                            </td>
                                            </cfif>
                                        </tr>
                                    </cfoutput>     
                                </tbody>
                            </cf_grid_list>
                        </div>
                    </div>
        </div>
    </div>
</div>
