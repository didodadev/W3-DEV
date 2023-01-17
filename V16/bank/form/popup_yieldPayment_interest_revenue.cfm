<cfquery name="GET_ACTION_DETAIL" datasource="#dsn2#">
	SELECT
        BANK_ACTIONS.*,
        IYP.*,
        IYPR.*
	FROM
		BANK_ACTIONS
        LEFT JOIN INTEREST_YIELD_PLAN AS IYP ON BANK_ACTIONS.ACTION_ID = IYP.BANK_ACTION_ID
        RIGHT JOIN INTEREST_YIELD_PLAN_ROWS AS IYPR ON IYPR.YIELD_ID = IYP.YIELD_ID 
	WHERE
		ACTION_ID = #ATTRIBUTES.ID# AND ACTION_TYPE_ID IN (2311)
</cfquery>
<cfquery name="GET_ACTION_DETAIL_NOT_PAYMENT" datasource="#dsn2#">
    SELECT
        IYPR.YIELD_ROWS_ID
    FROM
        BANK_ACTIONS
        LEFT JOIN INTEREST_YIELD_PLAN AS IYP ON BANK_ACTIONS.ACTION_ID = IYP.BANK_ACTION_ID
        RIGHT JOIN INTEREST_YIELD_PLAN_ROWS AS IYPR ON IYPR.YIELD_ID = IYP.YIELD_ID 
	WHERE
        BANK_ACTIONS.ACTION_ID = #ATTRIBUTES.ID# AND BANK_ACTIONS.ACTION_TYPE_ID IN (2311)
        AND IYPR.IS_PAYMENT = 0 OR IYPR.IS_PAYMENT IS NULL 
</cfquery>
<cfquery name="GET_ACTION_DETAIL_PAYMENT_PRINCIPAL" datasource="#dsn2#">
    SELECT
        IYPR.YIELD_ROWS_ID
    FROM
        BANK_ACTIONS
        LEFT JOIN INTEREST_YIELD_PLAN AS IYP ON BANK_ACTIONS.ACTION_ID = IYP.BANK_ACTION_ID
        RIGHT JOIN INTEREST_YIELD_PLAN_ROWS AS IYPR ON IYPR.YIELD_ID = IYP.YIELD_ID 
	WHERE
        BANK_ACTIONS.ACTION_ID = #ATTRIBUTES.ID# AND BANK_ACTIONS.ACTION_TYPE_ID IN (2311)
        AND IYPR.PAYMENT_PRINCIPAL = 1
</cfquery>
<cfquery name="GET_INTEREST_VALUATION" datasource="#dsn2#">
    SELECT * FROM
        INTEREST_YIELD_VALUATION AS IYV
        LEFT JOIN #dsn_alias#.BUDGET_PLAN_ROW BPR ON IYV.BUDGET_PLAN_ROW_ID = BPR.BUDGET_PLAN_ROW_ID
        LEFT JOIN #dsn_alias#.BUDGET_PLAN BP ON BP.BUDGET_PLAN_ID = BPR.BUDGET_PLAN_ID
        WHERE YIELD_ROWS_ID = #GET_ACTION_DETAIL.YIELD_ROWS_ID#
</cfquery>
<cfif GET_ACTION_DETAIL_PAYMENT_PRINCIPAL.recordCount> <!--- herhangi bir satırda ana para cekildi ise --->
    <cfset PAYMENT_PRINCIPAL_CHECKED = 1>
<cfelse>
    <cfset PAYMENT_PRINCIPAL_CHECKED = 0>
</cfif>
<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
    SELECT * FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #GET_ACTION_DETAIL.EXPENSE_ITEM_TAHAKKUK_ID#
</cfquery>
<cfquery name="get_account_name" datasource="#dsn3#">
    SELECT ACCOUNT_NAME,ACCOUNT_ID FROM ACCOUNTS AS A LEFT JOIN #dsn2#.BANK_ACTIONS AS BA ON BA.ACTION_TO_ACCOUNT_ID = A.ACCOUNT_ID WHERE BA.ACTION_ID = #ATTRIBUTES.ID+1#
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='33560'></cfsavecontent>
<cfset pagehead="#message#">
<cf_catalystHeader>
    <cf_box>
        <cf_box_elements>
            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-paper_no">
                    <label class="col col-4 col-xs-12"><b><cf_get_lang dictionary_id='57880.Belge No'> :</b></label>
                    <label class="col col-8 col-xs-12"><cfoutput>#GET_ACTION_DETAIL.PAPER_NO#</cfoutput> </label> 
                </div>
                <div class="form-group" id="item-process_date">
                    <label class="col col-4 col-xs-12"><b><cf_get_lang dictionary_id='57879.İşlem Tarihi'> :</b></label>
                    <label class="col col-8 col-xs-12"> <cfoutput># dateformat(GET_ACTION_DETAIL.ACTION_DATE,dateformat_style) #</cfoutput> </label> 
                </div>
                <div class="form-group" id="item-process_cat">
                    <label class="col col-4 col-xs-12"><b><cf_get_lang dictionary_id='57800.İşlem Tipi'> :</b></label>
                    <label class="col col-8 col-xs-12"> <cfoutput># GET_ACTION_DETAIL.ACTION_TYPE #</cfoutput> </label> 
                </div>
                <div class="form-group" id="item_expense_center">
                    <label class="col col-4 col-xs-12"><b><cf_get_lang dictionary_id='58172.Gelir Merkezi'> :</b></label>
                    <label class="col col-8 col-xs-12"> </label> 
                </div>
                <div class="form-group" id="item-expense_item">
                    <label class="col col-4 col-xs-12"><b><cf_get_lang dictionary_id='58234.Bütçe Kalemi'> :</b></label>
                    <label class="col col-8 col-xs-12"> <cfoutput>#GET_EXPENSE_ITEM.EXPENSE_ITEM_NAME#</cfoutput></label> 
                </div>
            </div>      
            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group" id="item-account_name">
                    <label class="col col-4 col-xs-12"><b><cf_get_lang dictionary_id='29449.Banka Hesabı'> :</b></label>
                    <label class="col col-8 col-xs-12"><cfoutput># get_account_name.ACCOUNT_NAME #</cfoutput> </label> 
                </div>
                <div class="form-group" id="item-amount">
                    <label class="col col-4 col-xs-12"><b><cf_get_lang dictionary_id='59179.Ana Para'> :</b></label>
                    <label class="col col-8 col-xs-12"><cfoutput># TLFormat(GET_ACTION_DETAIL.ACTION_VALUE - GET_ACTION_DETAIL.MASRAF) # # GET_ACTION_DETAIL.ACTION_CURRENCY_ID #</cfoutput></label> 
                </div>
                <div class="form-group" id="item-other_cash">
                    <label class="col col-4 col-xs-12"><b><cf_get_lang dictionary_id='58056.Dövizli Tutar'> :</b></label>
                    <label class="col col-8 col-xs-12"><cfoutput># TLFormat(GET_ACTION_DETAIL.OTHER_CASH_ACT_VALUE) # # GET_ACTION_DETAIL.OTHER_MONEY #</cfoutput></label> 
                </div>
                <div class="form-group" id="item-due_value">
                    <label class="col col-4 col-xs-12"><b><cf_get_lang dictionary_id='57640.Vade'> :</b></label>
                    <label class="col col-8 col-xs-12"><cfoutput># GET_ACTION_DETAIL.DUE_VALUE #</cfoutput> <cf_get_lang dictionary_id='57490.Gün'></label> 
                </div>
                <div class="form-group" id="item-due_value_date">
                    <label class="col col-4 col-xs-12"><b><cf_get_lang dictionary_id='57881.Vade Tarihi'> :</b></label>
                    <label class="col col-8 col-xs-12"><cfoutput># dateformat(GET_ACTION_DETAIL.DUE_VALUE_DATE,dateformat_style) #</cfoutput></label> 
                </div>
            </div>      
            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                <div class="form-group" id="item-yield_rate">
                    <label class="col col-4 col-xs-12"><b><cf_get_lang dictionary_id='51373.Getiri Oranı'> :</b></label>
                    <label class="col col-8 col-xs-12">% <cfoutput># GET_ACTION_DETAIL.YIELD_RATE #</cfoutput>  </label> 
                </div>
                <div class="form-group" id="item-yield_amount">
                    <label class="col col-4 col-xs-12"><b><cf_get_lang dictionary_id='51374.Getiri Tutarı'> :</b></label>
                    <label class="col col-8 col-xs-12"><cfoutput># TLFormat(GET_ACTION_DETAIL.YIELD_AMOUNT) #</cfoutput></label> 
                </div>
                <div class="form-group" id="item-yield_payment_period">
                    <label class="col col-4 col-xs-12"><b><cf_get_lang dictionary_id='51376.Getiri Ödeme Periyodu'> :</b></label>
                    <label class="col col-8 col-xs-12"> <cfif GET_ACTION_DETAIL.YIELD_PAYMENT_PERIOD eq 0><cf_get_lang dictionary_id='57490.Day'>  
                                                        <cfelseif GET_ACTION_DETAIL.YIELD_PAYMENT_PERIOD eq 1><cf_get_lang dictionary_id='58724.Ay'>
                                                        <cfelseif GET_ACTION_DETAIL.YIELD_PAYMENT_PERIOD eq 2>3 <cf_get_lang dictionary_id='58724.Ay'>
                                                        <cfelseif GET_ACTION_DETAIL.YIELD_PAYMENT_PERIOD eq 3>6 <cf_get_lang dictionary_id='58724.Ay'>
                                                        <cfelseif GET_ACTION_DETAIL.YIELD_PAYMENT_PERIOD eq 4><cf_get_lang dictionary_id='58455.Yıl'>
                                                        <cfelseif GET_ACTION_DETAIL.YIELD_PAYMENT_PERIOD eq 5> <cfoutput>#GET_ACTION_DETAIL.SPECIAL_DAY#</cfoutput> <cf_get_lang dictionary_id='57490.Day'>
                                                        <cfelseif GET_ACTION_DETAIL.YIELD_PAYMENT_PERIOD eq 6> <cfoutput>#GET_ACTION_DETAIL.DUE_VALUE#</cfoutput> <cf_get_lang dictionary_id='57490.Day'>
                                                        </cfif>  
                    </label> 
                </div>
                <div class="form-group" id="item-number_yield">
                    <label class="col col-4 col-xs-12"><b><cf_get_lang dictionary_id='33556.Getiri Ödeme Sayısı'> :</b></label>
                    <label class="col col-8 col-xs-12"><cfoutput># GET_ACTION_DETAIL.NUMBER_YIELD_COLLECTION #</cfoutput></label> 
                </div>
                <div class="form-group">
                    <label class="col col-6 col-xs-12">
                            
                        <button class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left" href="javascript://" onclick="location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=bank.interest_revenue&event=addPaymentRevenue&id=<cfoutput>#GET_ACTION_DETAIL_NOT_PAYMENT.YIELD_ROWS_ID#&bank_action_id=#get_account_name.ACCOUNT_ID#&yield_id=#GET_ACTION_DETAIL.YIELD_ID#&acc_tahakkuk_code=#GET_EXPENSE_ITEM.EXPENSE_ITEM_ID#</cfoutput>&is_principal=1';return false;" <cfif PAYMENT_PRINCIPAL_CHECKED eq 1>disabled</cfif>><i class="fa fa-money"></i><cf_get_lang dictionary_id='60887.Anaparayı Çek'></button>
                       
                        </label> 

                </div>
            </div> 
        </cf_box_elements>
        <cf_box_elements>
            <cfsavecontent variable="header"><cf_get_lang dictionary_id="51378.Getiri Tablosu"></cfsavecontent>
            <cf_seperator id="getiri_tablosu" header="#header#">
            <div class="col col-12" id="getiri_tablosu">
                <cf_grid_list>
                    <thead>
                        <tr>
                            <th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
                            <th><cf_get_lang dictionary_id='47952.Periyot'></th>
                            <th><cf_get_lang dictionary_id='57692.İşlem'></th>
                            <th><cf_get_lang dictionary_id='48897.Hesaba Geçiş Tarihi'></th>
                            <th><cf_get_lang dictionary_id='51374.Getiri Tutarı'></th>    
                            <th><cf_get_lang dictionary_id='57692.İşlem'></th>
                            <th width="20" class="text-center"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="GET_ACTION_DETAIL">
                            <tr>
                                <td width="20">#currentrow#</td>
                                <td>
                                    <cfif YIELD_PAYMENT_PERIOD eq 0><cf_get_lang dictionary_id='57490.Day'>  
                                    <cfelseif YIELD_PAYMENT_PERIOD eq 1><cf_get_lang dictionary_id='58724.Ay'>
                                    <cfelseif YIELD_PAYMENT_PERIOD eq 2>3 <cf_get_lang dictionary_id='58724.Ay'>
                                    <cfelseif YIELD_PAYMENT_PERIOD eq 3>6 <cf_get_lang dictionary_id='58724.Ay'>
                                    <cfelseif YIELD_PAYMENT_PERIOD eq 4><cf_get_lang dictionary_id='58455.Yıl'>
                                    <cfelseif YIELD_PAYMENT_PERIOD eq 5> #SPECIAL_DAY# <cf_get_lang dictionary_id='57490.Day'>
                                    <cfelseif YIELD_PAYMENT_PERIOD eq 6> #DUE_VALUE# <cf_get_lang dictionary_id='57490.Day'>
                                    </cfif> 
                                </td> <!--- periyot --->
                                <td>#OPERATION_NAME#</td> <!--- işlem --->
                                <td>#dateformat(BANK_ACTION_DATE,dateformat_style)#</td> <!--- hesaba geçiş tarihi --->
                                <td class="moneybox">#TLFormat(AMOUNT)#</td> <!--- periyot bazında getiri --->
                                <td>
                                    <cfif PAYMENT_PRINCIPAL eq 1>                                    
                                        <b><cf_get_lang dictionary_id='60888.Anapara İle Birlikte'><cf_get_lang dictionary_id='49834.Tahsil Edilmiştir'></b>
                                    <cfelseif IS_PAYMENT eq 1>
                                        <b><cf_get_lang dictionary_id='49834.Tahsil Edilmiştir'></b>
                                    <cfelseif IS_PAYMENT eq 0>
                                        <cfif PAYMENT_PRINCIPAL_CHECKED eq 1> 
                                            <b><cf_get_lang dictionary_id='60889.Anapara Çekildiği İçin Kalan Getiriler Kullanılamaz'></b>
                                        </cfif>
                                    </cfif>
                                </td>
                                <td width="20">
                                    <cfif PAYMENT_PRINCIPAL eq 1>
                                        <a href="#request.self#?fuseaction=bank.interest_revenue&event=updPaymentRevenue&id=#YIELD_ROWS_ID#&acc_tahakkuk_code=#GET_EXPENSE_ITEM.EXPENSE_ITEM_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                                    <cfelseif IS_PAYMENT eq 1>
                                        <a href="#request.self#?fuseaction=bank.interest_revenue&event=updPaymentRevenue&id=#YIELD_ROWS_ID#&acc_tahakkuk_code=#GET_EXPENSE_ITEM.EXPENSE_ITEM_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                                    <cfelseif IS_PAYMENT eq 0>
                                        <cfif PAYMENT_PRINCIPAL_CHECKED neq 1>
                                            <a href="#request.self#?fuseaction=bank.interest_revenue&event=addPaymentRevenue&id=#YIELD_ROWS_ID#&bank_action_id=#get_account_name.ACCOUNT_ID#&yield_id=#GET_ACTION_DETAIL.YIELD_ID#&acc_tahakkuk_code=#GET_EXPENSE_ITEM.EXPENSE_ITEM_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>   
                                        </cfif>
                                    </cfif>
                                </td>
                            </tr>
                        </cfoutput>     
                    </tbody>
                </cf_grid_list>
            </div>   
        </cf_box_elements>
        <cf_box_elements>
            <cfsavecontent variable="header_"><cf_get_lang dictionary_id="60886.Reeskont Tablosu"></cfsavecontent>
            <cf_seperator id="reeskont_tablosu" header="#header_#">
            <div class="col col-12" id="reeskont_tablosu">
                <cf_grid_list>
                    <thead>
                        <tr>
                            <th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
                            <th><cf_get_lang dictionary_id='59798.Reeskont Tarihi'></th>
                            <th><cf_get_lang dictionary_id='38879.Gün Sayısı'></th>
                            <th><cf_get_lang dictionary_id='59799.Reeskont Tutarı'></th>
                            <cfif len(GET_INTEREST_VALUATION.budget_plan_id)>    
                                <th><cf_get_lang dictionary_id='57692.İşlem'></th>
                            </cfif>
                            <th width="20"><i class="fa fa-table" title="<cf_get_lang dictionary_id='58452.Mahsup Fişi'>"></i></th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="GET_INTEREST_VALUATION">
                            <tr>
                                <td width="20">#currentrow#</td>
                                <td>#dateformat(YIELD_VALUATION_DATE,dateformat_style)#</td> <!--- hesaba geçiş tarihi --->
                                <td>#DATE_DIFF#</td>
                                <td>#TLFormat(YIELD_VALUATION_AMOUNT)#</td> <!--- periyot bazında getiri --->
                                <cfif len(budget_plan_id)>
                                    <td>
                                        <a href="#request.self#?fuseaction=budget.list_plan_rows&event=upd&budget_plan_id=#budget_plan_id#" target="_blank"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                                    </td>
                                </cfif>
                                <td width="20">
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#yield_valuation_id#&action_table=INTEREST_YIELD_VALUATION&process_cat=2314','page','upd_term_deposit')"><cf_get_lang dictionary_id='58452.Mahsup Fişi'></a>
                                </td>
                            </tr>
                        </cfoutput>     
                    </tbody>
                </cf_grid_list>
            </div>
        </cf_box_elements>
       
    </cf_box>
        
