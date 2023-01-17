<cfquery name="GET_PRICE_CATS" datasource="#DSN3#">
	SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT ORDER BY PRICE_CAT
</cfquery>
<cfquery name="GET_BLACKLIST_INFO" datasource="#DSN#">
	SELECT 
        BLACKLIST_INFO_ID,
        #dsn#.Get_Dynamic_Language(BLACKLIST_INFO_ID,'#session.ep.language#','SETUP_BLACKLIST_INFO','BLACKLIST_INFO_NAME',NULL,NULL,BLACKLIST_INFO_NAME) AS BLACKLIST_INFO_NAME
    FROM 
        SETUP_BLACKLIST_INFO 
    ORDER BY 
        BLACKLIST_INFO_NAME
</cfquery>
<cfquery name="GET_OUR_COMPANY_INFO" datasource="#DSN#">
	SELECT ISNULL(IS_SELECT_RISK_MONEY,0) IS_SELECT_RISK_MONEY FROM OUR_COMPANY_INFO WHERE COMP_ID=#session.ep.COMPANY_ID#
</cfquery>
<cfinclude template="../../member/query/get_money.cfm">
<cfinclude template="../../member/query/get_paymethod.cfm">
<cfif get_credit_limit.recordcount>
	<cfquery name="GET_CREDIT_MONEY" datasource="#DSN#">
        WITH CTE1 AS (
            SELECT 
                MONEY_TYPE,
                RATE1,
                RATE2 
            FROM 
                COMPANY_CREDIT_MONEY 
            WHERE 
                ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_credit_limit.company_credit_id#">        
        )
        SELECT 
        	CTE1.* 
        FROM 
        	CTE1        

        UNION ALL

        SELECT
        	MONEY,
            RATE1,
            RATE2 
        FROM 
        	SETUP_MONEY 
        WHERE 
        	PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND 
            MONEY NOT IN (
	        	SELECT
    	        	MONEY_TYPE
        	    FROM 
                	CTE1       
			)	
		ORDER BY MONEY_TYPE
	</cfquery>
<cfelse>
	<cfquery name="GET_RISK_MONEY" datasource="#DSN#">
    	SELECT ISNULL(IS_SELECT_RISK_MONEY,0) IS_SELECT_RISK_MONEY FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.ep.company_id#    
    </cfquery>
</cfif>
<cfif session.ep.rate_valid eq 1>
	<cfset readonly_info = "yes">
<cfelse>
	<cfset readonly_info = "no">
</cfif>
<cfif get_credit_limit.recordcount>
	<cfset url_str1="#request.self#?fuseaction=contract.emptypopup_updcompany_credit_total">
<cfelse>
	<cfset url_str1="#request.self#?fuseaction=contract.emptypopup_addcompany_credit_total">
</cfif>
	<div class="col col-12 col-xs-12"> 
        <cf_box> 
            <cfform name="add_credit" id="add_credit" method="post" action="#url_str1#">
                <cf_box_elements>
                    <cfif get_credit_limit.recordcount>
                        <input type="hidden" name="company_credit_id" id="company_credit_id" value="<cfoutput>#get_credit_limit.company_credit_id#</cfoutput>">
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-process">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_workcube_process is_upd='0' select_value='#get_credit_limit.process_stage#' process_cat_width='130' is_detail='1'>
                                </div>
                            </div>
                            <div class="form-group" id="item-company_name">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#get_credit_limit.consumer_id#</cfoutput>">
                                    <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_credit_limit.company_id#</cfoutput>">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57785.Üye Seçmelisiniz'>!</cfsavecontent>
                                    <cfif len(get_credit_limit.company_id)>
                                        <cfinput type="text" name="company_name" value="#get_par_info(get_credit_limit.company_id,1,0,0)#" readonly required="yes" message="#message#">	
                                    <cfelse>
                                        <cfinput type="text" name="company_name" value="#get_cons_info(get_credit_limit.consumer_id,0,0)#" readonly required="yes" message="#message#">	
                                    </cfif>
                                    <cfif not len(get_credit_limit.company_id) and not len(get_credit_limit.consumer_id)>
                                        <a href="javascript://" onclick="javascript:windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_id=add_credit.company_id&field_consumer=add_credit.consumer_id&field_member_name=add_credit.company_name</cfoutput>','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                                    </cfif>
                                </div>
                            </div>
                            <div class="form-group" id="item-our_company_id">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('contract',245)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="our_company_id" id="our_company_id">
                                        <cfoutput query="get_our_companies">
                                            <option value="#comp_id#" <cfif get_credit_limit.our_company_id eq comp_id>selected</cfif>>#company_name#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <cfif len(get_credit_limit.paymethod_id)>
                                <cfquery name="GET_PAY_METHOD" datasource="#DSN#">
                                    SELECT PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_credit_limit.paymethod_id#">
                                </cfquery>
                                <cfset paymethod_name_ = get_pay_method.paymethod>
                            <cfelseif len(get_credit_limit.card_paymethod_id)>
                                <cfquery name="GET_PAY_METHOD" datasource="#DSN3#">
                                    SELECT CARD_NO FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_credit_limit.card_paymethod_id#">
                                </cfquery>
                                <cfset paymethod_name_ = get_pay_method.card_no>
                            <cfelse>
                                <cfset paymethod_name_= ''>
                            </cfif>
                            <div class="form-group" id="item-paymethod_name">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('contract',247)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfif len(get_credit_limit.paymethod_id)><cfoutput>#get_credit_limit.paymethod_id#</cfoutput></cfif>">
                                        <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="<cfif len(get_credit_limit.card_paymethod_id)><cfoutput>#get_credit_limit.card_paymethod_id#</cfoutput></cfif>">
                                        <input type="text" name="paymethod_name" id="paymethod_name" value="<cfoutput>#paymethod_name_#</cfoutput>">
                                        <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=add_credit.paymethod_id&field_name=add_credit.paymethod_name&field_card_payment_id=add_credit.card_paymethod_id&field_card_payment_name=add_credit.paymethod_name</cfoutput>');" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
                                    </div>
                                </div>
                            </div>
                            <cfif len(get_credit_limit.revmethod_id)>
                                <cfquery name="GET_PAY_METHOD" datasource="#DSN#">
                                    SELECT PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_credit_limit.revmethod_id#">
                                </cfquery>
                                <cfset revmethod_name_ = get_pay_method.paymethod>
                            <cfelseif len(get_credit_limit.card_revmethod_id)>
                                <cfquery name="GET_PAY_METHOD" datasource="#DSN3#">
                                    SELECT CARD_NO FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_credit_limit.card_revmethod_id#">
                                </cfquery>
                                <cfset revmethod_name_ = get_pay_method.card_no>
                            <cfelse>
                                <cfset revmethod_name_= ''>
                            </cfif>
                            <div class="form-group" id="item-revmethod_name">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('contract',248)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="revmethod_id" id="revmethod_id" value="<cfif len(get_credit_limit.revmethod_id)><cfoutput>#get_credit_limit.revmethod_id#</cfoutput></cfif>">
                                        <input type="hidden" name="card_revmethod_id" id="card_revmethod_id" value="<cfif len(get_credit_limit.card_revmethod_id)><cfoutput>#get_credit_limit.card_revmethod_id#</cfoutput></cfif>">
                                        <input type="text" name="revmethod_name" id="revmethod_name" value="<cfoutput>#revmethod_name_#</cfoutput>">
                                        <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=add_credit.revmethod_id&field_name=add_credit.revmethod_name&field_card_payment_id=add_credit.card_revmethod_id&field_card_payment_name=add_credit.revmethod_name</cfoutput>');" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-ship_method_name">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfif len(get_credit_limit.ship_method_id)>
                                            <cfquery name="GET_METHOD" datasource="#DSN#">
                                                SELECT SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_credit_limit.ship_method_id#">
                                            </cfquery>
                                            <input type="hidden" name="ship_method_id" id="ship_method_id" value="<cfoutput>#get_credit_limit.ship_method_id#</cfoutput>">
                                            <input type="text" name="ship_method_name" id="ship_method_name" value="<cfoutput>#get_method.ship_method#</cfoutput>">
                                        <cfelse>
                                            <input type="hidden" name="ship_method_id" id="ship_method_id" value="">
                                            <input type="text" name="ship_method_name" id="ship_method_name" value="">
                                        </cfif>
                                        <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method_id','','ui-draggable-box-small');" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-transport_comp_name">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57716.Taşıyıcı'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="transport_comp_id" id="transport_comp_id" value="<cfoutput>#get_credit_limit.transport_comp_id#</cfoutput>">
                                        <input type="text" name="transport_comp_name" id="transport_comp_name" value="<cfoutput>#get_par_info(get_credit_limit.transport_comp_id,1,0,0)#</cfoutput>">
                                        <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=add_credit.transport_comp_id&field_comp_name=add_credit.transport_comp_name&field_partner=add_credit.transport_deliver_id&field_name=add_credit.transport_deliver_name&select_list=2');" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-transport_deliver_name">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('contract',276)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="hidden" name="transport_deliver_id" id="transport_deliver_id" value="<cfoutput>#get_credit_limit.transport_deliver_id#</cfoutput>">
                                    <input type="text" name="transport_deliver_name" id="transport_deliver_name" readonly value="<cfoutput>#get_par_info(GET_CREDIT_LIMIT.transport_deliver_id,0,-1,0)#</cfoutput>">
                                </div>
                            </div>
                            <div class="form-group" id="item-instalment">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('contract',252)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="checkbox" name="instalment" id="instalment" <cfif get_credit_limit.is_instalment_info eq 1>checked</cfif>>
                                </div>
                            </div>
                            <div class="form-group" id="item-is_blacklist">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58646.Kara Liste'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="checkbox" name="is_blacklist" id="is_blacklist" value="1" onclick="check_info();" <cfif get_credit_limit.is_blacklist eq 1>checked</cfif>></td>
                                </div>
                            </div>	
                            <div class="form-group <cfif get_credit_limit.is_blacklist neq 1>hide</cfif>" id="item-blacklist_date">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58648.Kara Listeye Alınma Tarihi'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfif len(get_credit_limit.blacklist_date)>
                                            <cfinput validate="#validate_style#" type="text" name="blacklist_date" value="#dateformat(get_credit_limit.blacklist_date,dateformat_style)#">
                                        <cfelse>
                                            <cfinput validate="#validate_style#" type="text" name="blacklist_date" value="">
                                        </cfif>
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="blacklist_date"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group <cfif get_credit_limit.is_blacklist neq 1>hide</cfif>" id="item-blacklist_info">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58647.Kara Listeye Alınma Nedeni'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="blacklist_info" id="blacklist_info">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="get_blacklist_info">
                                            <option value="#blacklist_info_id#" <cfif len(get_credit_limit.blacklist_info) and get_credit_limit.blacklist_info eq blacklist_info_id>selected</cfif>>#blacklist_info_name#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                            <div class="form-group" id="item-open_account_risk_limit">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57875.Açık Hesap Limiti'></label>
                                <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.eksik veri'>:<cf_get_lang dictionary_id='57875.Açık Hesap Limiti'>!</cfsavecontent>
                                <cfif get_module_user(16)>
                                    <cfinput type="text" name="open_account_risk_limit" class="moneybox" value="#tlformat(get_credit_limit.open_account_risk_limit)#" onkeyup="return(formatcurrency(this,event));" onblur="doviz_hesapla();" message="#message#">
                                <cfelse>
                                    <cfinput type="text" name="open_account_risk_limit" class="moneybox" value="#tlformat(get_credit_limit.open_account_risk_limit)#" onkeyup="return(formatcurrency(this,event));" onblur="doviz_hesapla();" message="#message#" readonly="yes">
                                </cfif>
                                </div>
                            </div>
                            <div class="form-group" id="item-open_account_risk_limit_other_cash">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('contract',271)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='50972.Açık hesap limiti döviz karşılığı girmelisiniz'>!</cfsavecontent>
                                    <cfif get_module_user(16)>
                                        <cfinput type="text" name="open_account_risk_limit_other_cash" value="#tlformat(get_credit_limit.open_account_risk_limit_other)#" onkeyup="return(formatcurrency(this,event));" onBlur="ytl_hesapla();" class="moneybox">
                                    <cfelse>
                                        <cfinput type="text" name="open_account_risk_limit_other_cash" value="#tlformat(get_credit_limit.open_account_risk_limit_other)#" onkeyup="return(formatcurrency(this,event));" onblur="ytl_hesapla();" class="moneybox" readonly="yes" message="#message#">
                                    </cfif>
                                </div>
                            </div>
                            <div class="form-group" id="item-forward_sale_limit">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('contract',66)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.eksik veri'>:<cf_get_lang dictionary_id='54657.Vadeli Ödeme Aracı Limiti!'></cfsavecontent>
                                    <cfif get_module_user(16)>
                                        <cfinput type="text" name="forward_sale_limit" value="#tlformat(get_credit_limit.forward_sale_limit)#" onkeyup="return(formatcurrency(this,event));" onblur="doviz_hesapla();" message="#message#" class="moneybox">
                                    <cfelse>
                                        <cfinput type="text" name="forward_sale_limit" value="#tlformat(get_credit_limit.forward_sale_limit)#" onkeyup="return(formatcurrency(this,event));" onblur="doviz_hesapla();" message="#message#" class="moneybox" readonly="yes">
                                    </cfif>
                                </div>							
                            </div>
                            <div class="form-group" id="item-forward_sale_limit_other_cash">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('contract',274)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='50975.Vadeli Ödeme Aracı Limit Döviz Tutarı girmelisiniz'>!</cfsavecontent>
                                    <cfif get_module_user(16)>
                                        <cfinput type="text" name="forward_sale_limit_other_cash" value="#tlformat(get_credit_limit.forward_sale_limit_other)#" onkeyup="return(formatcurrency(this,event));" onblur="ytl_hesapla();" class="moneybox">
                                    <cfelse>
                                        <cfinput type="text" name="forward_sale_limit_other_cash" value="#tlformat(get_credit_limit.forward_sale_limit_other)#" onkeyup="return(formatcurrency(this,event));" onblur="ytl_hesapla();" class="moneybox" readonly="yes" message="#message#">
                                    </cfif>
                                </div>
                            </div>
                            <div class="form-group" id="item-first_payment_interest">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('contract',250)#</cfoutput> %</label>
                                <div class="col col-8 col-xs-12">
                                    <cfif get_module_user(16)>
                                        <input type="text" onkeyup="return(FormatCurrency(this,event));" name="first_payment_interest" id="first_payment_interest" value="<cfoutput>#TLFormat(get_credit_limit.first_payment_interest)#</cfoutput>">
                                    <cfelse>
                                        <input type="text" onkeyup="return(FormatCurrency(this,event));" name="first_payment_interest" id="first_payment_interest" value="<cfoutput>#TLFormat(get_credit_limit.first_payment_interest)#</cfoutput>">
                                    </cfif>
                                </div>
                            </div>
                            <div class="form-group" id="item-last_payment_interest">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58501.Vade Farkı'>%</label>
                                <div class="col col-8 col-xs-12">
                                    <cfif get_module_user(16)>
                                        <input type="text" onkeyup="return(FormatCurrency(this,event));" name="last_payment_interest" id="last_payment_interest" value="<cfoutput>#TLFormat(get_credit_limit.last_payment_interest)#</cfoutput>">
                                    <cfelse>
                                        <input type="text" onkeyup="return(FormatCurrency(this,event));" name="last_payment_interest" id="last_payment_interest" value="<cfoutput>#TLFormat(get_credit_limit.last_payment_interest)#</cfoutput>"  readonly>
                                    </cfif>
                                </div>
                            </div>
                            <div class="form-group" id="item-payment_blokaj">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('contract',251)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='50951.Ödeme Blokajı'> !</cfsavecontent>
                                    <cfinput type="text" name="payment_blokaj" value="#tlformat(get_credit_limit.payment_blokaj)#" onkeyup="return(formatcurrency(this,event));" message="#message#" class="moneybox">
                                </div>
                            </div>
                            <div class="form-group" id="item-blokaj_type">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('contract',97)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="blokaj_type" id="blokaj_type">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <option value="1" <cfif get_credit_limit.PAYMENT_BLOKAJ_TYPE eq 1>selected</cfif>>%</option>
                                        <option value="2" <cfif get_credit_limit.PAYMENT_BLOKAJ_TYPE eq 2>selected</cfif>><cf_get_lang dictionary_id='57673.Tutar'></option>
                                        <option value="3" <cfif get_credit_limit.PAYMENT_BLOKAJ_TYPE eq 3>selected</cfif>><cf_get_lang dictionary_id='58906.Stok Maliyeti'></option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-price_cat">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58944.Öncelikli'> <cf_get_lang dictionary_id='57448.satış'> <cf_get_lang dictionary_id='58964.Fiyat Listesi'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="price_cat" id="price_cat">
                                        <option value=""><cf_get_lang dictionary_id='58964.Fiyat Listesi'></option>
                                        <cfoutput query="get_price_cats">
                                            <option value="#get_price_cats.price_catid#" <cfif get_price_cats.price_catid eq get_credit_limit.price_cat>selected</cfif>>#get_price_cats.price_cat#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-price_cat_purchase">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58944.Öncelikli'> <cf_get_lang dictionary_id='58176.Alış'> <cf_get_lang dictionary_id='58964.Fiyat Listesi'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="price_cat_purchase" id="price_cat_purchase">
                                        <option value=""><cf_get_lang dictionary_id='58964.Fiyat Listesi'></option>
                                        <cfoutput query="get_price_cats">
                                            <option value="#get_price_cats.price_catid#" <cfif get_price_cats.price_catid eq get_credit_limit.price_cat_purchase>selected</cfif>>#get_price_cats.price_cat#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-rate_type">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('contract',336)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_get_lang_set module_name="finance">
                                        <select name="rate_type" id="rate_type">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <option value="1" <cfif get_credit_limit.PAYMENT_RATE_TYPE eq 1>selected</cfif>><cf_get_lang dictionary_id='30028.Alış Kuru'></option>
                                            <option value="2" <cfif get_credit_limit.PAYMENT_RATE_TYPE eq 2>selected</cfif>><cf_get_lang dictionary_id='30014.Satış Kuru'></option>
                                            <option value="3" <cfif get_credit_limit.PAYMENT_RATE_TYPE eq 3>selected</cfif>><cf_get_lang dictionary_id='58945.Efektif'> <cf_get_lang dictionary_id='30028.Alış Kuru'></option>
                                            <option value="4" <cfif get_credit_limit.PAYMENT_RATE_TYPE eq 4>selected</cfif>><cf_get_lang dictionary_id='58945.Efektif'> <cf_get_lang dictionary_id='30014.Satış Kuru'></option>
                                        </select>
                                    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="false">
                            <div class="row">
                                <label class="col col-12 bold"><cfoutput>#getLang('contract',273)#</cfoutput></label>
                            </div>
                            <cfif get_credit_money.recordcount>
                                <input type="hidden" name="deger_get_money" id="deger_get_money" value="<cfoutput>#get_credit_money.recordcount#</cfoutput>">
                            <cfelse>
                                <input type="hidden" name="deger_get_money" id="deger_get_money" value="<cfoutput>#get_money.recordcount#</cfoutput>">
                            </cfif>
                            <cfset selected_money=get_credit_limit.money>
                            <cfoutput>
                                <cfif get_credit_money.recordcount>
                                    <cfloop query="get_credit_money">
                                        <cfif x_rate_day eq 1>
                                            <cfquery name="get_money_rate" datasource="#dsn#" maxrows="1">
                                                SELECT
                                                    *
                                                FROM 
                                                    MONEY_HISTORY
                                                WHERE 
                                                    VALIDATE_DATE <= #now()#
                                                    AND PERIOD_ID = #session.ep.period_id#
                                                    AND MONEY = '#money_type#'
                                                ORDER BY 
                                                    VALIDATE_DATE DESC,
                                                    RECORD_DATE DESC
                                            </cfquery>
                                            <cfif get_money_rate.recordcount>
                                                <cfset rate1_ = get_money_rate.rate1>
                                                <cfif get_our_company_info.is_select_risk_money eq 1>
                                                    <cfif get_credit_limit.payment_rate_type eq 1>
                                                        <cfset rate2_ = get_money_rate.RATE3>
                                                    <cfelseif get_credit_limit.payment_rate_type eq 3>
                                                        <cfset rate2_ = get_money_rate.EFFECTIVE_PUR>
                                                    <cfelseif get_credit_limit.payment_rate_type eq 4>
                                                        <cfset rate2_ = get_money_rate.EFFECTIVE_SALE>
                                                    <cfelse>
                                                        <cfset rate2_ = get_money_rate.rate2>
                                                    </cfif>
                                                <cfelse>
                                                    <cfset rate2_ = get_money_rate.rate2>
                                                </cfif>
                                            <cfelse>
                                                <cfset rate1_ = 1>
                                                <cfset rate2_ = 1>
                                            </cfif>
                                        <cfelse>
                                            <cfset rate1_ = get_credit_money.rate1>
                                            <cfset rate2_ = get_credit_money.rate2>
                                        </cfif>
                                        <div class="form-group">
                                            <div class="col col-2 col-md-2 col-sm-2 col-xs-6">
                                                <input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money_type#">
                                                <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1_#">
                                                <input type="radio" name="other_money" id="other_money" value="#money_type#,#currentrow#,#rate1_#,#rate2_#" onclick="doviz_hesapla();" <cfif selected_money eq money_type>checked</cfif>>
                                                <label>#money_type#</label>
                                            </div>
                                            <div class="col col-2 col-md-4 col-sm-4 col-xs-12"><label>#TLFormat(rate1,0)# /</label></div>
                                            <div class="col col-6">
                                                <input type="text" <cfif readonly_info>readonly</cfif> class="box" name="value_rate2#currentrow#" id="value_rate2#currentrow#" value="#TLFormat(rate2_,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onblur="doviz_hesapla();">
                                            </div>
                                            
                                        </div>
                                    </cfloop>
                                <cfelse>
                                    <cfloop query="get_money">
                                        <div class="form-group">
                                            <div class="col col-2 col-md-2 col-sm-2 col-xs-6">
                                                <input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
                                                <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
                                                <input type="radio" name="other_money" id="other_money" value="#money#,#currentrow#,#rate1#,#rate2#" onclick="doviz_hesapla();" <cfif selected_money eq money>checked</cfif>>
                                                <label>#money#</label>
                                                <div class="col col-2 col-md-4 col-sm-4 col-xs-12"><label>#TLFormat(rate1,0)# /</label></div>
                                                <div class="col col-6">
                                                    <input type="text" <cfif readonly_info> readonly</cfif> class="box" name="value_rate2#currentrow#" id="value_rate2#currentrow#" value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onblur="doviz_hesapla();">
                                                </div>
                                            </div>
                                        </div>
                                    </cfloop>
                                </cfif>
                            </cfoutput>
                        </div>
                    <cfelse>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-process">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_workcube_process is_upd='0' process_cat_width='130' is_detail='0'>
                                </div>
                            </div>
                            <div class="form-group" id="item-company_name">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.eksik veri'>:<cf_get_lang dictionary_id='57658.Üye'>!</cfsavecontent>
                                        <cfif isdefined("attributes.cpid") and len(attributes.cpid)>
                                            <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.cpid#</cfoutput>">
                                            <input type="hidden" name="consumer_id" id="consumer_id" value="">
                                            <cfinput type="text" name="company_name" value="#get_par_info(attributes.cpid,1,0,0)#" readonly required="yes" message="#message#">
                                        <cfelseif isdefined("attributes.company_id") and len(attributes.company_id)>
                                            <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
                                            <input type="hidden" name="consumer_id" id="consumer_id" value="">
                                            <cfinput type="text" name="company_name" value="#get_par_info(attributes.company_id,1,0,0)#" readonly required="yes" message="#message#">	
                                        <cfelseif isdefined("attributes.consumer_id")>
                                            <input type="hidden" name="company_id" id="company_id" value="">
                                            <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
                                            <cfinput type="text" name="company_name" value="#get_cons_info(attributes.consumer_id,0,0)#" readonly required="yes" message="#message#">	
                                        <cfelse>
                                            <input type="hidden" name="company_id" id="company_id" value="">
                                            <input type="hidden" name="consumer_id" id="consumer_id" value="">
                                            <cfinput type="text" name="company_name" value="" readonly required="yes" message="#message#">	
                                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="javascript:windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_id=add_credit.company_id&field_consumer=add_credit.consumer_id&field_member_name=add_credit.company_name</cfoutput>','list');"></span>
                                        </cfif>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-our_company_id">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('contract',245)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="our_company_id" id="our_company_id">
                                        <cfoutput query="get_our_companies">
                                            <option value="#comp_id#">#company_name#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-paymethod_name">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('contract',247)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="paymethod_id" id="paymethod_id" value="">
                                        <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
                                        <input type="text" name="paymethod_name" id="paymethod_name" value="">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=add_credit.paymethod_id&field_name=add_credit.paymethod_name&field_card_payment_id=add_credit.card_paymethod_id&field_card_payment_name=add_credit.paymethod_name</cfoutput>','list');" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-revmethod_name">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('contract',248)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="revmethod_id" id="revmethod_id" value="">
                                        <input type="hidden" name="card_revmethod_id" id="card_revmethod_id" value="">
                                        <input type="text" name="revmethod_name" id="revmethod_name" value="">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=add_credit.revmethod_id&field_name=add_credit.revmethod_name&field_card_payment_id=add_credit.card_revmethod_id&field_card_payment_name=add_credit.revmethod_name</cfoutput>','list');" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-ship_method_name">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="ship_method_id" id="ship_method_id" value="">
                                        <input type="text" name="ship_method_name" id="ship_method_name" value="">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method_id','list');" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-transport_comp_name">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57716.Taşıyıcı'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="transport_comp_id" id="transport_comp_id">
                                        <input type="text" name="transport_comp_name" id="transport_comp_name" readonly>
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=add_credit.transport_comp_id&field_comp_name=add_credit.transport_comp_name&field_partner=add_credit.transport_deliver_id&field_name=add_credit.transport_deliver_name&select_list=2','list');" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-transport_deliver_name">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('contract',276)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="hidden" name="transport_deliver_id" id="transport_deliver_id" value="">
                                    <input type="text" name="transport_deliver_name" id="transport_deliver_name" readonly>
                                </div>
                            </div>
                            <div class="form-group" id="item-price_cat">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58944.Öncelikli'> <cf_get_lang dictionary_id='57448.satış'> <cf_get_lang dictionary_id='58964.Fiyat Listesi'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="price_cat" id="price_cat">
                                        <option value=""><cf_get_lang dictionary_id='58964.Fiyat Listesi'></option>
                                        <cfoutput query="get_price_cats">
                                            <option value="#get_price_cats.price_catid#">#get_price_cats.price_cat#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-price_cat_purchase">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58944.Öncelikli'> <cf_get_lang dictionary_id='58176.Alış'> <cf_get_lang dictionary_id='58964.Fiyat Listesi'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="price_cat_purchase" id="price_cat_purchase">
                                        <option value=""><cf_get_lang dictionary_id='58964.Fiyat Listesi'></option>
                                        <cfoutput query="get_price_cats">
                                            <option value="#get_price_cats.price_catid#">#get_price_cats.price_cat#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-instalment">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('contract',252)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="checkbox" name="instalment" id="instalment">
                                </div>
                            </div>
                            <div class="form-group" id="item-is_blacklist">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58646.Kara Liste'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="checkbox" name="is_blacklist" id="is_blacklist" value="1" onclick="check_info();">
                                </div>
                            </div>
                            <div class="form-group hide" id="item-blacklist_date">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58648.Kara Listeye Alınma Tarihi'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfinput validate="#validate_style#" type="text" name="blacklist_date" value="">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="blacklist_date"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group hide" id="item-blacklist_info">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58647.Kara Listeye Alınma Nedeni'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="blacklist_info" id="blacklist_info">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="get_blacklist_info">
                                            <option value="#blacklist_info_id#">#blacklist_info_name#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                            <div class="form-group" id="item-open_account_risk_limit">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57875.Açık Hesap Limiti'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.eksik veri'>:<cf_get_lang dictionary_id='57875.Açık Hesap Limiti'>!</cfsavecontent>
                                    <cfinput type="text" name="open_account_risk_limit" class="moneybox" value="0" onkeyup="return(formatcurrency(this,event));" onblur="doviz_hesapla();" message="#message#">
                                </div>
                            </div>
                            <div class="form-group" id="item-open_account_risk_limit_other_cash">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('contract',271)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cfoutput>#getLang('contract',272)#</cfoutput>!</cfsavecontent>
                                    <cfinput type="text" name="open_account_risk_limit_other_cash" value="0" onkeyup="return(formatcurrency(this,event));" onblur="ytl_hesapla();"  message="#message#" class="moneybox">
                                </div>
                            </div>
                            <div class="form-group" id="item-forward_sale_limit">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('contract',66)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.eksik veri'>:<cfoutput>#getLang('contract',66)#</cfoutput></cfsavecontent>
                                    <cfinput type="text" name="forward_sale_limit" value="0" onkeyup="return(formatcurrency(this,event));" onblur="doviz_hesapla();" message="#message#" class="moneybox">
                                </div>							
                            </div>
                            <div class="form-group" id="item-forward_sale_limit_other_cash">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('contract',274)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cfoutput>#getLang('contract',275)#</cfoutput>!</cfsavecontent>
                                    <cfinput type="text" name="forward_sale_limit_other_cash" value="0" onkeyup="return(formatcurrency(this,event));" onblur="ytl_hesapla();"  message="#message#" class="moneybox">
                                </div>
                            </div>
                            <div class="form-group" id="item-first_payment_interest">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('contract',250)#</cfoutput> %</label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="first_payment_interest" id="first_payment_interest" value="" onkeyup="return(FormatCurrency(this,event));">
                                </div>
                            </div>
                            <div class="form-group" id="item-last_payment_interest">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58501.Vade Farkı'> %</label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" onkeyup="return(FormatCurrency(this,event));" name="last_payment_interest" id="last_payment_interest" value="" >
                                </div>
                            </div>
                            <div class="form-group" id="item-payment_blokaj">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('contract',251)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cfoutput>#getLang('contract',251)#</cfoutput>!</cfsavecontent>
                                    <cfinput type="text" name="payment_blokaj" value="" onkeyup="return(formatcurrency(this,event));" message="#message#" class="moneybox">
                                </div>
                            </div>
                            <div class="form-group" id="item-blokaj_type">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('contract',2)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="blokaj_type" id="blokaj_type">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <option value="1">%</option>
                                        <option value="2"><cf_get_lang dictionary_id='57673.Tutar'></option>
                                        <option value="3"><cf_get_lang dictionary_id='58906.Stok Maliyeti'></option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-rate_type">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('contract',336)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="rate_type" id="rate_type">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <option value="1"><cf_get_lang dictionary_id='58176.Alış'></option>
                                        <option value="2"><cf_get_lang dictionary_id='57448.Satış'></option>
                                        <option value="3"><cf_get_lang dictionary_id='58945.Efektif'> <cf_get_lang dictionary_id='58176.Alış'></option>
                                        <option value="4"><cf_get_lang dictionary_id='58945.Efektif'> <cf_get_lang dictionary_id='57448.Satış'></option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="false">
                            <div class="row">
                                <label class="col col-12 bold"><cfoutput>#getLang('contract',273)#</cfoutput></label>
                            </div>
                                    <input type="hidden" name="deger_get_money" id="deger_get_money" value="<cfoutput>#get_money.recordcount#</cfoutput>">
                                    <cfif get_risk_money.is_select_risk_money>                            
                                        <cfif len(session.ep.other_money)>
                                            <cfset selected_money=session.ep.other_money>
                                        <cfelseif len(session.ep.money2)>
                                            <cfset selected_money=session.ep.money2>
                                        <cfelse>
                                            <cfset selected_money=session.ep.money>
                                        </cfif>
                                    <cfelse>
                                        <cfset selected_money = session.ep.money>
                                    </cfif>
                                    <cfloop query="get_money">
                                        <cfoutput>
                                            <div class="form-group">
                                                <div class="col col-2 col-md-2 col-sm-2 col-xs-6">
                                                        <input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
                                                        <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
                                                        <input type="radio" name="other_money" id="other_money" value="#money#,#currentrow#,#rate1#,#rate2#" onclick="doviz_hesapla();" <cfif selected_money eq money>checked</cfif>>
                                                        <label>#money#</label>
                                                    </div>
                                                    <div class="col col-2 col-md-4 col-sm-4 col-xs-12"><label>#TLFormat(rate1,0)# /</label></div>
                                                    <div class="col col-6">
                                                        <input type="text" <cfif readonly_info>readonly</cfif> class="box" name="value_rate2#currentrow#" id="value_rate2#currentrow#" value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onblur="doviz_hesapla();">
                                                    </div>
                                                </div>
                                        </cfoutput>
                                    </cfloop>
                        </div>
                    </cfif>
                </cf_box_elements>
                <cf_box_footer>	
                    <div class="col col-6">
                        <cf_record_info query_name="get_credit_limit">
                    </div>
                    <div class="col col-6">
                        <cfif get_credit_limit.recordcount>
                            <cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
                        <cfelse>
                            <cf_workcube_buttons is_add='1' add_function='kontrol()'>
                        </cfif>
                    </div>
                </cf_box_footer>
            </cfform>
        </cf_box>
        <cfif isdefined("attributes.company_id") and len(attributes.company_id)>
            <!--- müşteri fiyat listeleri--->
                    <cf_box
                        closable="0"
                        id="special_id"
                        unload_body="1" 
                        title="#getLang('contract',5)#" 
                        style="width:100%"
                        box_page="#request.self#?fuseaction=contract.list_member_special_price_cat&company_id=#attributes.company_id#">
                    </cf_box>
            <!--- müşteri dbs limitleri --->
                    <cf_box 
                        title="#getLang('','DBS Limitleri',47087)#" 
                        id="dbs_lmt" 
                        unload_body="1" 
                        style="width:100%"
                        box_page="#request.self#?fuseaction=contract.member_dbs_limit&company_id=#attributes.company_id#"
                        closable="0">
                    </cf_box>
            <!--- Özel Fiyat Ve İskonto --->
                    <cf_box
                        closable="0" 
                        id="price_id_"
                        unload_body="1" 
                        title="#getLang('contract','Özel Fiyatlar ve İskonto',50958)#" 
                        style="width:100%"
                        box_page="#request.self#?fuseaction=contract.list_member_special_prices&company_id=#attributes.company_id#">
                    </cf_box>
            <!--- Kota ve Primler --->
                    <cf_box
                        closable="0" 
                        id="quatos_id"
                        unload_body="1" 
                        title="#getLang('contract','Kotalar ve Primler',62784)#" 
                        style="width:100%"
                        box_page="#request.self#?fuseaction=contract.quotas_premium_ajax&company_id=#attributes.company_id#&get_credit_limit.company_id">
                    </cf_box>
            <!--- Genel İskontolar --->
                    <cf_box
                        closable="0" 
                        id="comp_discount_id"
                        unload_body="1" 
                        title="#getLang('contract','Genel İskontolar',50931)#"
                        style="width:100%"
                        box_page="#request.self#?fuseaction=contract.list_company_related_discount&company_id=#attributes.company_id#">
                    </cf_box>
            <!--- Grup Risk Limitleri --->
                    <cf_box 
                    title="#getLang('','Grup Risk Limitleri',50966)#" 
                        id="risk_status" 
                        unload_body="1" 
                        style="width:100%"
                        box_page="#request.self#?fuseaction=contract.member_risk_status&company_id=#attributes.company_id#"
                        closable="0">
                    </cf_box>
                    <!--- Sozlesmeler--->
                    <cf_box 
                        title="#getLang('','Sözleşmeler',51037)#" 
                        id="related_cont" 
                        unload_body="1" 
                        style="width:100%"
                        box_page="#request.self#?fuseaction=contract.related_contracts&company_id=#attributes.company_id#"
                        closable="0">
                    </cf_box>
                <cfelse>
                    <!--- müşteri fiyat listeleri--->
                    <cf_box
                        closable="0"
                        id="special_id"
                        unload_body="1" 
                        title="#getLang('contract',5)#" 
                        style="width:100%"
                        box_page="#request.self#?fuseaction=contract.list_member_special_price_cat&consumer_id=#attributes.consumer_id#">
                    </cf_box>
                    <cf_box 
                        title="#getLang('','Grup Risk Limitleri',50966)#" 
                        id="risk_status" 
                        unload_body="1" 
                        style="width:100%"
                        box_page="#request.self#?fuseaction=contract.member_risk_status&consumer_id=#attributes.CONSUMER_ID#"
                        closable="0">
                    </cf_box>
                    <!--- Sozlesmeler--->
                    <cf_box 
                        title="#getLang('','Sözleşmeler',55816)#" 
                        id="related_cont" 
                        unload_body="1" 
                        style="width:100%"
                        box_page="#request.self#?fuseaction=contract.related_contracts&CONSUMER_ID=#attributes.CONSUMER_ID#"
                        closable="0">
                    </cf_box>
        </cfif>
    </div>
<script type="text/javascript">
	function kontrol()
	{
		if (document.add_credit.company_name.value == "")
		{
			alert("<cf_get_lang dictionary_id='57471.eksik veri'>:<cf_get_lang dictionary_id='57519.Cari Hesap'> !");
			return false;
		}
		unformat_fields();
		return process_cat_control();
	}
	function doviz_hesapla()
	{
		toplam =eval("document.add_credit.open_account_risk_limit");
		toplam1=eval("document.add_credit.forward_sale_limit");
		toplam.value=filterNum(toplam.value);
		toplam1.value=filterNum(toplam1.value);
		toplam=parseFloat(toplam.value);
		toplam1=parseFloat(toplam1.value);
		for(s=1;s<=add_credit.deger_get_money.value;s++)
		{
			if(document.add_credit.other_money[s-1].checked == true)
			{
				deger_diger_para = document.add_credit.other_money[s-1];
				form_value_rate2=eval("document.add_credit.value_rate2"+s);
			}
		}
		deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
		form_value_rate2.value = filterNum(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		if(toplam>0)
		{
			document.add_credit.open_account_risk_limit_other_cash.value = commaSplit(toplam * parseFloat(deger_money_id_3)/(parseFloat(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')));
			document.add_credit.open_account_risk_limit.value=commaSplit(toplam);
		}
		else
		{
			document.add_credit.open_account_risk_limit_other_cash.value =0;
			document.add_credit.open_account_risk_limit.value=0;
		}
		if(toplam1>0)
		{
			document.add_credit.forward_sale_limit_other_cash.value = commaSplit(toplam1 * parseFloat(deger_money_id_3)/(parseFloat(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')));
			document.add_credit.forward_sale_limit.value=commaSplit(toplam1);
		}
		else
		{
			document.add_credit.forward_sale_limit_other_cash.value = 0;
			document.add_credit.forward_sale_limit.value=0;
		}
		form_value_rate2.value = commaSplit(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		return true;
	}
	function ytl_hesapla()
	{
		toplam2 =eval("document.add_credit.open_account_risk_limit_other_cash");
		toplam3=eval("document.add_credit.forward_sale_limit_other_cash");
		toplam2.value=filterNum(toplam2.value);
		toplam3.value=filterNum(toplam3.value);
		toplam2=parseFloat(toplam2.value);
		toplam3=parseFloat(toplam3.value);
		for(s=1;s<=add_credit.deger_get_money.value;s++)
		{
			if(document.add_credit.other_money[s-1].checked == true)
			{
				deger_diger_para = document.add_credit.other_money[s-1];
				form_value_rate2=eval("document.add_credit.value_rate2"+s);
			}
		}
		deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
		form_value_rate2.value = filterNum(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		if(toplam2>0)
		{
			document.add_credit.open_account_risk_limit.value = commaSplit(toplam2 * parseFloat(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/(parseFloat(deger_money_id_3)));
			document.add_credit.open_account_risk_limit_other_cash.value=commaSplit(toplam2);
		}
		else
		{
			document.add_credit.open_account_risk_limit.value =0;
			document.add_credit.open_account_risk_limit_other_cash.value=0;
		}
		if(toplam3>0)
		{
			document.add_credit.forward_sale_limit.value = commaSplit(toplam3 *parseFloat(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>') /(parseFloat(deger_money_id_3)));
			document.add_credit.forward_sale_limit_other_cash.value=commaSplit(toplam3);
		}
		else
		{
			document.add_credit.forward_sale_limit.value = 0;
			document.add_credit.forward_sale_limit_other_cash.value=0;
		}
		form_value_rate2.value = commaSplit(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		return true;
	}
	function check_info()
	{   //bu javascriptin düzenlenmesi lazım
		if(document.add_credit.is_blacklist.checked == true)
		{
			$("#item-blacklist_info").removeClass('hide');
			$("#item-blacklist_date").removeClass('hide');	
		}
		else
		{
			$("#item-blacklist_info").addClass('hide');
			$("#item-blacklist_date").addClass('hide');
		}
	}
	ytl_hesapla();
</script>
