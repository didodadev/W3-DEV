<cfset get_contract= createObject("component","V16.contract.cfc.contract") />
<cfset get_contact_detail=get_contract.get_contact_detail(contract_id:attributes.contract_id)/>   
<cfset contract_cmp= createObject("component","V16.contract.cfc.contract") />
<cfset GET_PAYMENT = contract_cmp.GET_PAYMENT(contract_id: get_contact_detail.contract_id)>
<cfset GET_PAYMENT_ROWS = contract_cmp.GET_PAYMENT_ROWS(contract_id : get_contact_detail.contract_id)>   
<cfset GET_CAMPAIGN = contract_cmp.GET_CAMPAIGN(subscription_id: get_contact_detail.contract_id)>
<cfset contract_cmp_2 = createObject("component","V16.sales.cfc.subscription_contract")>
<cfset GET_BASKET_AMOUNT = contract_cmp_2.GET_BASKET_AMOUNT()>
<cfset GET_MONEY_MAIN = contract_cmp_2.GET_MONEY_MAIN()>
<cfparam name="attributes.count" default="0">
<cfparam name="attributes.start_date" default="#dateformat(now(),dateformat_style)#">
<cfif GET_BASKET_AMOUNT.recordcount>
    <cfoutput query="GET_BASKET_AMOUNT">
        <cfset PRICE_ROUND_NUMBER = GET_BASKET_AMOUNT.PRICE_ROUND_NUMBER>
    </cfoutput>
<cfelse>
    <cfset PRICE_ROUND_NUMBER = session.ep.our_company_info.sales_price_round_num>
</cfif>
    <cf_box 
    title="#getLang('','Plan Ekle',64130)#"
    edit_href_title='#getLang('main', 1420)#' scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="payment_plan" method="post" action="#request.self#?fuseaction=sales.subscription_payment_plan">
    <input name="contract_id" id="contract_id" type="hidden" value="<cfoutput>#get_contact_detail.contract_id#</cfoutput>">
    <input name="record_num" id="record_num" type="hidden" value="<cfoutput>#GET_PAYMENT_ROWS.recordcount#</cfoutput>">
    <input name="record" id="record" type="hidden" value="0">
    <input name="count_camp" id="count_camp" type="hidden" value="0">
    <cf_box_elements>
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
            <div class="form-group">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç "></label>
                <div class="col col-8 col-xs-12">
                    <cfif GET_PAYMENT.recordcount>
                        <cf_workcube_process is_upd='0' select_value='#GET_PAYMENT.PROCESS_STAGE#' is_detail='1'>
                    <cfelse>
                        <cf_workcube_process is_upd='0' is_detail='0'>
                    </cfif>
                </div>
            </div>
                <div class="form-group">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57446.Kampanya'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="camp_id" id="camp_id">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfoutput query="get_campaign">
                                <option value="#camp_id#">#camp_head#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
            <div class="form-group">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'>*</label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <cfoutput>
                            <cfif len(GET_PAYMENT.STOCK_ID)>
                                <cfquery name="get_tax" datasource="#dsn3#">
                                    SELECT TAX,OTV FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PAYMENT.STOCK_ID#">
                                </cfquery>
                                <cfset tax_info = get_tax.tax>
                                <cfset otv_info = get_tax.otv>
                            <cfelseif isdefined("attributes.stock_id") and len(attributes.stock_id)>
                                <cfquery name="get_tax" datasource="#dsn3#">
                                    SELECT TAX,OTV FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
                                </cfquery>
                                <cfset tax_info = get_tax.tax>
                                <cfset otv_info = get_tax.otv>
                            <cfelse>
                                <cfset tax_info = ''>
                                <cfset otv_info = ''>
                            </cfif>
                                <input type="hidden" name="product_id" id="product_id" value="<cfif len(GET_PAYMENT.PRODUCT_ID)>#GET_PAYMENT.PRODUCT_ID#<cfelseif isdefined("attributes.product_id")>#attributes.product_id#</cfif>">
                                <input type="hidden" name="stock_id" id="stock_id" value="<cfif len(GET_PAYMENT.STOCK_ID)>#GET_PAYMENT.STOCK_ID#<cfelseif isdefined("attributes.stock_id")>#attributes.stock_id#</cfif>">
                                <input type="hidden" name="unit_id" id="unit_id" value="<cfif len(GET_PAYMENT.UNIT_ID)>#GET_PAYMENT.UNIT_ID#<cfelseif isdefined("attributes.unit_id")>#attributes.unit_id#</cfif>">
                                <input type="hidden" name="tax" id="tax" value="#tax_info#">
                                <input type="hidden" name="otv" id="otv" value="#otv_info#">
                                <input type="text" name="product_name" id="product_name" value="<cfif len(GET_PAYMENT.PRODUCT_ID)>#get_product_name(GET_PAYMENT.PRODUCT_ID)#<cfelseif isdefined("attributes.product_name")>#attributes.product_name#</cfif>" passthrough="readonly=yes">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_price_unit</cfoutput>&field_stock_id=payment_plan.stock_id&field_id=payment_plan.product_id&field_name=payment_plan.product_name&field_otv=payment_plan.otv&field_tax=payment_plan.tax&field_amount=payment_plan.quantity&field_unit_id=payment_plan.unit_id&field_unit=payment_plan.unit&field_price=payment_plan.amount&field_total_price=payment_plan.net_amount&field_money=payment_plan.money_type');"></span>
                        </cfoutput>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57635.Miktar'></label>
                <div class="col col-8 col-xs-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id ='41303.Miktar Giriniz'></cfsavecontent>
                        <cfoutput>
                    <cfif len(GET_PAYMENT.QUANTITY)>
                        <input type="text" name="quantity" id="quantity" class="box" onBlur="is_zero(1)" value="#GET_PAYMENT.QUANTITY#" validate="float" required="yes" message="#message#">
                    <cfelse>
                        <input type="text" name="quantity" id="quantity" class="box" onBlur="is_zero(1)" value="<cfif isdefined("attributes.quantity")>#attributes.quantity#</cfif>" validate="float" required="yes" message="#message#">
                    </cfif>	
                        </cfoutput>
                </div>
            </div>
        </div>
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
            <div class="form-group">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57636.Birim'></label>
                <div class="col col-8 col-xs-12">
                    <cfoutput>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='41304.Birim Giriniz'></cfsavecontent>
                        <input type="text" name="unit" id="unit" value="<cfif len(GET_PAYMENT.UNIT)>#GET_PAYMENT.UNIT#<cfelseif isdefined("attributes.unit")>#attributes.unit#</cfif>" required="yes" message="#message#" maxlength="10" readonly="yes">
                    </cfoutput>
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'>*</label>
                <div class="col col-8 col-xs-12">
                    <cfoutput>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='29535.Lutfen Tutar Giriniz'></cfsavecontent>
                            <input type="text" name="amount" id="amount" class="moneybox" onblur="hesapla_main(0);AmountRnd('amount',<cfoutput>#price_round_number#</cfoutput>);" value="<cfif len(GET_PAYMENT.AMOUNT)>#TLFormat(GET_PAYMENT.AMOUNT,price_round_number)#<cfelseif isdefined("attributes.amount")>#TLFormat(attributes.amount,price_round_number)#</cfif>" required="yes" message="#message#">    
                    </cfoutput>
                </div>
            </div>
                <div class="form-group">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48991.Net Tutar'></label>
                    <div class="col col-8 col-xs-12">
                        <input type="text" name="net_amount"  id="net_amount" class="moneybox" onblur="hesapla_main(1);AmountRnd('net_amount',<cfoutput>#price_round_number#</cfoutput>);" value="<cfoutput><cfif len(GET_PAYMENT.AMOUNT)>#TLFormat(GET_PAYMENT.AMOUNT,price_round_number)#<cfelseif isdefined("attributes.net_amount")>#TLFormat(attributes.net_amount,price_round_number)#</cfif></cfoutput>" required="yes" message="#message#">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57641.İskonto'>%</label>
                    <div class="col col-8 col-xs-12">
                        <input type="text" name="discount"  id="discount" class="moneybox" onblur="hesapla_main(2);" value="<cfoutput><cfif isdefined("attributes.discount")>#TLFormat(attributes.discount)#</cfif></cfoutput>" onkeyup="return(FormatCurrency(this,event));"> 
                    </div>                   
                </div>
        </div>            
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
            <div class="form-group">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57489.Para Br'></label>
                <div class="col col-8 col-xs-12">
                    <select name="money_type" id="money_type">
                        <cfoutput query="GET_MONEY_MAIN">
                            <option value="#MONEY#" <cfif GET_MONEY_MAIN.MONEY eq GET_PAYMENT.MONEY_TYPE>selected</cfif>>#MONEY#</option>
                        </cfoutput>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41109.Periyod'></label>
                <div class="col col-8 col-xs-12">
                    <select name="period" id="period">
                        <option value="1" <cfif GET_PAYMENT.PERIOT eq 1>selected</cfif>><cf_get_lang dictionary_id='58932.Aylık'></option>
                        <option value="2" <cfif GET_PAYMENT.PERIOT eq 2>selected</cfif>>2 <cf_get_lang dictionary_id='58932.Aylık'></option>
                        <option value="3" <cfif GET_PAYMENT.PERIOT eq 3>selected</cfif>>3 <cf_get_lang dictionary_id='58932.Aylık'></option>
                        <option value="6" <cfif GET_PAYMENT.PERIOT eq 6>selected</cfif>>6 <cf_get_lang dictionary_id='58932.Aylık'></option>
                        <option value="12" <cfif GET_PAYMENT.PERIOT eq 12>selected</cfif>><cf_get_lang dictionary_id='29400.Yıllık'></option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'>*</label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <cfif len(GET_PAYMENT.PAYMETHOD_ID)>
                            <cfquery name="GET_PAYMETHOD" datasource="#dsn#">
                                SELECT PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PAYMENT.PAYMETHOD_ID#">
                            </cfquery>
                        <cfelseif len(GET_PAYMENT.CARD_PAYMETHOD_ID)>
                            <cfquery name="GET_CARD_PAYMETHOD" datasource="#dsn3#">
                                SELECT CARD_NO FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PAYMENT.CARD_PAYMETHOD_ID#">
                            </cfquery>
                        </cfif>
                        <cfoutput>
                            <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="<cfif len(GET_PAYMENT.CARD_PAYMETHOD_ID)>#GET_PAYMENT.CARD_PAYMETHOD_ID#<cfelseif isdefined("attributes.card_paymethod_id")>#attributes.card_paymethod_id#</cfif>">
                            <input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfif len(GET_PAYMENT.PAYMETHOD_ID)>#GET_PAYMENT.PAYMETHOD_ID#<cfelseif isdefined("attributes.paymethod_id")>#attributes.paymethod_id#</cfif>">
                            <input type="text" name="paymethod" id="paymethod" value="<cfif len(GET_PAYMENT.PAYMETHOD_ID)>#GET_PAYMETHOD.PAYMETHOD#<cfelseif len(GET_PAYMENT.CARD_PAYMETHOD_ID)>#GET_CARD_PAYMETHOD.CARD_NO#<cfelseif isdefined("attributes.paymethod")>#attributes.paymethod#</cfif>" readonly>
                            <cfset card_link="&field_card_payment_id=payment_plan.card_paymethod_id&field_card_payment_name=payment_plan.paymethod">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=payment_plan.paymethod_id&field_name=payment_plan.paymethod#card_link#</cfoutput>');"></span>
                        </cfoutput>
                    </div>
                </div>
            </div>
        </div>
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
            <div class="form-group">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='40963.Tekrar'>*</label>
                <div class="col col-8 col-xs-12">
                    <input type="text" name="count" id="count" validate="integer" class="moneybox" value="<cfoutput>#attributes.count#</cfoutput>" maxlength="3">    
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57655.Başlama'>*</label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
                        <input type="text" name="start_date" id="start_date" value="<cfoutput><cfif len(GET_PAYMENT.START_DATE)>#dateformat(GET_PAYMENT.START_DATE,dateformat_style)#<cfelseif isdefined("attributes.start_date")>#attributes.start_date#</cfif></cfoutput>" required="yes" message="#message#" validate="#validate_style#" readonly>
                        <span class="input-group-addon"> <cf_wrk_date_image date_field="start_date"></span>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col col-9 col-xs-12"><cf_get_lang dictionary_id='41110.Toplu Fatr Dah'>*</label>
                <div class="col col-3 col-xs-12">
                    <input type="checkbox" name="top_fat_dah" id="top_fat_dah" checked onclick="select_bill_type(1);">
                </div>
            </div>
            <div class="form-group">
                <label class="col col-9 col-xs-12"><cf_get_lang dictionary_id ='41302.Grup Fatura Dah'></label>
                <div class="col col-3 col-xs-12">
                    <input type="checkbox" name="grup_fat_dah" id="grup_fat_dah" onclick="select_bill_type(2);">
                </div>
            </div>
                <div class="form-group">
                    <label class="col col-9 col-xs-12"><cf_get_lang dictionary_id='41425.Kampanya Operasyon Kuralları Çalışsın'></label>
                    <div class="col col-3 col-xs-12">
                        <input type="checkbox" name="is_camp_rules" id="is_camp_rules" onclick="" value="1">
                    </div>
                </div>
        </div>
    </cf_box_elements>
    <cf_box_footer>
        <cf_record_info query_name='GET_PAYMENT'>
        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57934.Temizle'></cfsavecontent>
       <!---  <input type="button" name="temizle" id="temizle" value="<cfoutput>#message#</cfoutput>" onclick="camp_control();" style="float:right;margin-left: 12px;"> --->
        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='41306.Ödeme Oluştur'></cfsavecontent>
        <input type="button" name="odeme_olustur" id="odeme_olustur" value="<cfoutput>#message#</cfoutput>" onclick="kontrol();" style="float:right;">
    </cf_box_footer>
</cfform>
</cf_box>
<script>
    function kontrol()
    {	
      
        //Eger kampanya kuralları çalışsın seçilmişse kontrolleri yapmasına gerek yok
        if(!(document.payment_plan.camp_id != undefined && document.payment_plan.is_camp_rules.checked == true))
        {
            if(document.payment_plan.product_id.value == '')
            {
                alert("<cf_get_lang dictionary_id='57725.Ürün Seçiniz'>!");
                return false;
            }
            if(document.payment_plan.count.value == '')
            {
                alert("<cf_get_lang dictionary_id='40968.Tekrar Sayısı Girmelisiniz'>!");
                return false;
            }
            if(document.payment_plan.start_date.value == '')
            {
                alert("<cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'>!");
                return false;
            }
            if(document.payment_plan.amount.value == '')
            {
                alert("<cf_get_lang dictionary_id='29535.Tutar Girmelisiniz'>!");
                return false;
            }
            if(document.payment_plan.paymethod.value == '')
            {
                alert("<cf_get_lang dictionary_id ='58027.Ödeme Yöntemi Seçmelisiniz'>!");
                return false;
            }
        }
        
        <cfif xml_save_total_zero eq 0>//FBS
            if(parseFloat(filterNum(document.getElementById("amount").value)) == 0)
            {
                alert("Tutar 0'dan Farklı Olmalıdır!");
                return false;
            }
        </cfif>
            
        <cfif x_control_camp_rules eq 1>
            if(document.payment_plan.camp_id.value != '')
            {
                if(document.payment_plan.is_camp_rules != undefined && document.payment_plan.is_camp_rules.checked == false)
                {
                    alert("Kampanya Operasyon Kuralları Çalışsın Seçeneğini Seçiniz!");
                    return false;
                }
            }
        </cfif>
        if(document.payment_plan.is_camp_rules != undefined && document.payment_plan.is_camp_rules.checked == true)
        {
            if(document.payment_plan.camp_id.value == '')
            {
                alert("Kampanya Seçiniz!");
                return false;
            }
        }
        //Eğer kampanyadan gelmiyorsa standart yukarıdaki bilgileri kullanarak satır eklenir,kampanya seçilmişse kampanya operasyon satırlarına göre eklenir
        if(document.payment_plan.camp_id == undefined || !(document.payment_plan.camp_id.value != '' && document.payment_plan.is_camp_rules.checked == true))
            add_row(document.payment_plan.count.value,document.payment_plan.period[document.payment_plan.period.selectedIndex].value);
        else
        {
            get_camp_info=wrk_query('SELECT DISTINCT ISNULL(CO.DISCOUNT_AMOUNT,0) DISCOUNT_AMOUNT,ISNULL(CO.K_DISCOUNT_AMOUNT,0) K_DISCOUNT_AMOUNT,CO.CAMP_OPE_ID,C.CAMP_ID,C.CAMP_HEAD,CO.PRICE,CO.UNIT,CO.UNIT_ID,S.STOCK_ID,S.TAX,S.OTV,S.PRODUCT_NAME,ISNULL(REPEAT_NUMBER,0) REPEAT_NUMBER,ISNULL(FREE_REPEAT_NUMBER,0) FREE_REPEAT_NUMBER,ISNULL(DISCOUNT,0) DISCOUNT,ISNULL(K_DISCOUNT,0) K_DISCOUNT,CO.AMOUNT,CO.PRODUCT_ID,CO.PAYMETHOD_ID,CO.CARD_PAYMETHOD_ID,CO.CURRENCY,CO.PERIOD,CO.RATE FROM CAMPAIGN_OPERATION CO,STOCKS S,CAMPAIGNS C WHERE C.CAMP_ID = CO.CAMP_ID AND CO.PRODUCT_ID = S.PRODUCT_ID AND CO.CAMP_ID='+document.all.camp_id.value,'dsn3');
    
            if(get_camp_info.recordcount > 0)
            {
                total_repeat_number = 0;
                for(kk=0;kk<get_camp_info.recordcount;kk++)
                {
                    row_period = get_camp_info.PERIOD[kk];
                    row_product_id = get_camp_info.PRODUCT_ID[kk];
                    row_stock_id = get_camp_info.STOCK_ID[kk];
                    row_product_name = get_camp_info.PRODUCT_NAME[kk];
                    row_unit = get_camp_info.UNIT[kk];
                    row_unit_id = get_camp_info.UNIT_ID[kk];
                    row_tax = get_camp_info.TAX[kk];
                    row_otv = get_camp_info.OTV[kk];
                    row_paymethod = get_camp_info.PAYMETHOD_ID[kk];
                    row_card_paymethod = get_camp_info.CARD_PAYMETHOD_ID[kk];
                    row_currency = get_camp_info.CURRENCY[kk];
                    row_amount = get_camp_info.AMOUNT[kk];
                    row_price = get_camp_info.PRICE[kk];
                    row_discount = get_camp_info.DISCOUNT[kk];
                    row_k_discount = get_camp_info.K_DISCOUNT[kk];
                    row_discount_amount = get_camp_info.DISCOUNT_AMOUNT[kk];
                    row_k_discount_amount = get_camp_info.K_DISCOUNT_AMOUNT[kk];
                    row_repeat_number = get_camp_info.REPEAT_NUMBER[kk];
                    row_free_repeat_number = get_camp_info.FREE_REPEAT_NUMBER[kk];
                    row_camp_id = get_camp_info.CAMP_ID[kk];
                    row_camp_name = get_camp_info.CAMP_HEAD[kk];
                    row_rate = get_camp_info.RATE[kk];
                    period_info = row_period;
                    
                    if(row_paymethod != '')
                    {
                        get_pay_name = wrk_query('SELECT PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID='+row_paymethod,'dsn');
                        row_paymethod_name = get_pay_name.PAYMETHOD;					
                    }
                    else if(row_card_paymethod != '')
                    {
                        get_pay_name = wrk_query('SELECT CARD_NO FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID='+row_card_paymethod,'dsn3');
                        row_paymethod_name = get_pay_name.CARD_NO;
                    }
                    else
                    {
                        row_paymethod = document.payment_plan.paymethod_id.value;
                        row_card_paymethod = document.payment_plan.card_paymethod_id.value;
                        row_paymethod_name = document.payment_plan.paymethod.value;
                    }
                    if(period_info == '')period_info = document.payment_plan.period.value;
                    <cfif x_control_camp_product eq 1>
                        if(document.payment_plan.product_id.value != '' && row_product_id == document.payment_plan.product_id.value)
                        {
                            total_repeat_number = parseFloat(total_repeat_number)+parseFloat(row_repeat_number);
                            add_row(row_repeat_number,period_info,row_product_id,row_stock_id,row_product_name,row_unit_id,row_unit,row_paymethod,row_card_paymethod,row_paymethod_name,row_amount,row_price,row_currency,row_camp_id,row_camp_name,row_discount,row_k_discount,row_repeat_number,row_free_repeat_number,kk,row_tax,row_otv,row_discount_amount,row_k_discount_amount,row_rate);
                        }
                        else if(document.payment_plan.product_id.value == '')
                        {
                            total_repeat_number = parseFloat(total_repeat_number)+parseFloat(row_repeat_number);
                            add_row(row_repeat_number,period_info,row_product_id,row_stock_id,row_product_name,row_unit_id,row_unit,row_paymethod,row_card_paymethod,row_paymethod_name,row_amount,row_price,row_currency,row_camp_id,row_camp_name,row_discount,row_k_discount,row_repeat_number,row_free_repeat_number,kk,row_tax,row_otv,row_discount_amount,row_k_discount_amount,row_rate);
                        }
                    <cfelse>	
                        total_repeat_number = parseFloat(total_repeat_number)+parseFloat(row_repeat_number);
                        add_row(row_repeat_number,period_info,row_product_id,row_stock_id,row_product_name,row_unit_id,row_unit,row_paymethod,row_card_paymethod,row_paymethod_name,row_amount,row_price,row_currency,row_camp_id,row_camp_name,row_discount,row_k_discount,row_repeat_number,row_free_repeat_number,kk,row_tax,row_otv,row_discount_amount,row_k_discount_amount,row_rate);
                    </cfif>
                }
                document.payment_plan.count_camp.value = total_repeat_number;
                document.payment_plan.count.value = 0;
            }
        }
        $("#show_pay_plan #kayit_yok").hide();
            document.payment_plan_det.record_num.value=document.payment_plan.record_num.value;
            document.payment_plan_det.record.value=document.payment_plan.record.value;
            document.payment_plan_det.count_camp.value=document.payment_plan.count_camp.value;
            document.payment_plan_det.unit.value=document.payment_plan.unit.value;
            document.payment_plan_det.amount.value=document.payment_plan.amount.value;
            document.payment_plan_det.quantity.value=document.payment_plan.quantity.value;
            document.payment_plan_det.product_id.value=document.payment_plan.product_id.value;
            document.payment_plan_det.stock_id.value=document.payment_plan.stock_id.value;
            document.payment_plan_det.unit_id.value=document.payment_plan.unit_id.value;
            document.payment_plan_det.money_type.value=document.payment_plan.money_type.value;
            document.payment_plan_det.period.value=document.payment_plan.period.value;
            document.payment_plan_det.paymethod_id.value=document.payment_plan.paymethod_id.value;
            document.payment_plan_det.card_paymethod_id.value=document.payment_plan.card_paymethod_id.value;
            document.payment_plan_det.process_stage.value=document.payment_plan.process_stage.value;
        closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');
        return true;
    }
</script>