<cfset cmpExpense = createObject("component","V16.myhome.cfc.health_expense") />
<cfset get_expense = cmpExpense.GET_EXPENSE(health_id : attributes.health_id) />
<cfset get_money = cmpExpense.GET_MONEY() />

<cfparam name="attributes.modal_id" default="" />

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfform action="#request.self#?fuseaction=hr.emptypopup_health_invoice_control" name="add_health_invoice_control" method="post" enctype="multipart/form-data">
        <cf_box id="health_invoice_control" title="#getLang('','Fatura Kontrolü',62738)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <input type="hidden" value="<cfoutput>#attributes.health_id#</cfoutput>" name="health_id" id="health_id">
                    <div class="form-group" id="item-invoice_no">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58133.Fatura No'>*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="hidden" value="<cfoutput>#get_expense.EXPENSE_ITEM_PLANS_ID#</cfoutput>" name="expense_id" id="expense_id">
                            <cfinput type="text" name="invoice_no" id="invoice_no" value="#get_expense.INVOICE_NO#" readonly>
                        </div>
                    </div>
                    <div class="form-group" id="item-company">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cfoutput>
                                <div class="input-group">
                                    <input type="hidden" name="company_id" id="company_id" value="#get_expense.company_id#">
                                    <input type="text" name="company" id="company" readonly onfocus="AutoComplete_Create('company','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'1\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','COMPANY_ID','company_id','','3','250','return_company()');" value="<cfif get_expense.member_type eq 'partner'>#get_par_info(get_expense.company_id,1,1,0)#</cfif>" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&field_comp_name=add_health_invoice_control.company&field_comp_id=add_health_invoice_control.company_id&call_function=change_due_date()<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2');"></span>
                                </div>
                            </cfoutput>
                        </div>
                    </div>
                    <div class="form-group" id="item-pur_sales_info">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57332.Fark Tipi'>*</label>
						<div class="col col-8 col-xs-12">
							<select name="pur_sales_info" id="pur_sales_info">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<option value="1"><cf_get_lang dictionary_id='58488.Alınan'></option>
								<option value="0"><cf_get_lang dictionary_id='58490.Verilen'></option>
							</select>
						</div>
					</div>
                    <div class="form-group" id="item-diff_type">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58583.Fark'><cf_get_lang dictionary_id='58651.Türü'>*</label>
						<div class="col col-8 col-xs-12">
							<select name="diff_type" id="diff_type">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<option value="1"><cf_get_lang dictionary_id ='57327.Koşul Farkı'></option>
								<option value="2"><cf_get_lang dictionary_id ='57333.Aksiyon Farkı'></option>
								<option value="3"><cf_get_lang dictionary_id ='57334.Sipariş Farkı'></option>
								<option value="4"><cf_get_lang dictionary_id ='57239.Fiyat Farkı'></option>
								<option value="5"><cf_get_lang dictionary_id ='57884.Kur Farkı'></option>
								<option value="6"><cf_get_lang dictionary_id ='57335.Fiyat Koruma'></option>
								<option value="7"><cf_get_lang dictionary_id ='57336.Manuel Fark'></option>
								<option value="8"><cf_get_lang dictionary_id ='58501.Vade Farkı'></option>
								<option value="9"><cf_get_lang dictionary_id ='57398.Prim Hakedişi'></option>
								<option value="10"><cf_get_lang dictionary_id ='57399.Mal Fazlası Hakedişi'></option>
								<option value="11"><cf_get_lang dictionary_id ='57400.Manuel Maliyet'></option>
							</select>
						</div>
					</div>
                    <div class="form-group" id = "item-product_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="product_id" id="product_id" value="">
                                <input type="hidden" name="stock_id" id="stock_id" value="">
                                <cfinput type="text" name="product_name" id="product_name" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID,STOCK_ID','product_id,stock_id','','3','200');" value="" required="yes" message="#getLang('main',313)#">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=add_health_invoice_control.product_id&field_name=add_health_invoice_control.product_name&field_id=add_health_invoice_control.stock_id');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-quantity">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57635.Miktar'>*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="quantity" id="quantity" class="moneybox" value="" onkeyup="return(FormatCurrency(this,event));" onchange="fieldCommaSplit(this);">
                        </div>
                    </div>
                    <div class="form-group" id="item-kdv">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57639.KDV'>% *</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="kdv" id="kdv" class="moneybox" value="" onkeyup="return(FormatCurrency(this,event));">
                        </div>
                    </div>
                    <div class="form-group" id="item-amount">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'>*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="amount" id="amount" class="moneybox" value="" onkeyup="return(FormatCurrency(this,event));" onBlur="doviz_hesapla();">
                        </div>
                    </div>
                    <div class="form-group" id="item-currency_amount">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30635.Döviz Tutar'>*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="currency_amount" id="currency_amount" class="moneybox" value="" onkeyup="return(FormatCurrency(this,event));" onBlur="tl_hesapla();">
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="invoice_details" id="invoice_details"></textarea>
                        </div>
                    </div>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-kur-ekle">
                        <div class="col col-12 scrollContent scroll-x2">
                            <label class="bold"><cf_get_lang dictionary_id ='30636.İşlem Para Birimi'></label>
                            <cfif session.ep.rate_valid eq 1>
                                <cfset readonly_info = "yes">
                            <cfelse>
                                <cfset readonly_info = "no">
                            </cfif>
                            <input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money.recordcount#</cfoutput>">
                            <cfset selected_money = get_expense.MONEY>
                            <table>
                                <cfoutput query="get_money">
                                    <tr>
                                        <input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
                                        <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
                                        <td><input type="radio" name="rd_money" id="rd_money" value="#money#,#currentrow#,#rate1#,#rate2#" onClick="doviz_hesapla();" <cfif selected_money eq money>checked</cfif>></td>
                                        <td>#money# #TLFormat(rate1,0)# /</td>
                                        <td><input type="text" <cfif readonly_info>readonly</cfif> class="box" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onblur="doviz_hesapla();"></td>
                                    </tr>
                                </cfoutput>
                            </table>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-12">
                    <cf_workcube_buttons is_upd='0' add_function='#iif(isdefined("attributes.draggable"),DE("kontrol() && loadPopupBox('add_health_invoice_control' , #attributes.modal_id#)"),DE(""))#'>
                </div>
            </cf_box_footer>
        </cf_box>
    </cfform>
</div>
<script type="text/javascript">
    function kontrol() {
        if( $( '#invoice_no' ).val() == '' ) {
            alert("<cf_get_lang dictionary_id='57471.Missing Data'>: <cf_get_lang dictionary_id='58133.Fatura No'>");
            $( '#invoice_no' ).focus();
            return false;
        }
        if( $( '#company' ).val() == '' || $( '#company_id' ).val() == '' ) {
            alert("<cf_get_lang dictionary_id='57471.Missing Data'>: <cf_get_lang dictionary_id='57519.Cari Hesap'>");
            $( '#company' ).focus();
            return false;
        }
        if( $( '#pur_sales_info' ).val() == '' ) {
            alert("<cf_get_lang dictionary_id='57471.Missing Data'>: <cf_get_lang dictionary_id='57332.Fark Tipi'>");
            $( '#pur_sales_info' ).focus();
            return false;
        }
        if( $( '#diff_type' ).val() == '' ) {
            alert("<cf_get_lang dictionary_id='57471.Missing Data'>: <cf_get_lang dictionary_id='58583.Fark'><cf_get_lang dictionary_id='58651.Türü'>");
            $( '#diff_type' ).focus();
            return false;
        }
        if( $( '#quantity' ).val() == '' ) {
            alert("<cf_get_lang dictionary_id='57471.Missing Data'>: <cf_get_lang dictionary_id='57635.Miktar'>");
            $( '#quantity' ).focus();
            return false;
        }
        if( $( '#kdv' ).val() == '' ) {
            alert("<cf_get_lang dictionary_id='57471.Missing Data'>: <cf_get_lang dictionary_id='57639.KDV'>");
            $( '#kdv' ).focus();
            return false;
        }
        if( $( '#amount' ).val() == '' ) {
            alert("<cf_get_lang dictionary_id='57471.Missing Data'>: <cf_get_lang dictionary_id='57673.Tutar'>");
            $( '#amount' ).focus();
            return false;
        }
        if( $( '#currency_amount' ).val() == '' ) {
            alert("<cf_get_lang dictionary_id='57471.Missing Data'>: <cf_get_lang dictionary_id='30635.Döviz Tutar'>");
            $( '#currency_amount' ).focus();
            return false;
        }
        formatFilterInputs();
        return true;
    }

    function formatFilterInputs() {
        $('#quantity').val( filterNum( $('#quantity').val() ) );
        $('#amount').val( filterNum( $('#amount').val() ) );
        $('#currency_amount').val( filterNum( $('#currency_amount').val() ) );
    }

    function fieldCommaSplit( obj ) {
        obj.value = commaSplit( parseFloat( filterNum( obj.value ) ) );
    }

    function doviz_hesapla() {
        toplam = eval("document.add_health_invoice_control.amount");
        toplam.value = filterNum(toplam.value);
        toplam = parseFloat(toplam.value);
        for(s = 1; s <= add_health_invoice_control.kur_say.value; s++) {
            if(document.add_health_invoice_control.rd_money[s-1].checked == true) {
                deger_diger_para = document.add_health_invoice_control.rd_money[s-1];
                form_value_rate2 = eval("document.add_health_invoice_control.txt_rate2_"+s);
            }
        }
        deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
        form_value_rate2.value = filterNum(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
        if(toplam > 0) {            
            document.add_health_invoice_control.currency_amount.value = commaSplit(toplam * parseFloat(deger_money_id_3)/(parseFloat(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')));
            document.add_health_invoice_control.amount.value=commaSplit(toplam);
        }
        else {
            document.add_health_invoice_control.currency_amount.value = commaSplit(0);
            document.add_health_invoice_control.amount.value = commaSplit(0);
        }
        form_value_rate2.value = commaSplit(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'); 
        return true;
    }
    
    function tl_hesapla() {
        toplam2 = eval("document.add_health_invoice_control.currency_amount");
        toplam2.value = filterNum(toplam2.value);
        toplam2 = parseFloat(toplam2.value);
        for(s = 1; s <= add_health_invoice_control.kur_say.value; s++) {
            if(document.add_health_invoice_control.rd_money[s-1].checked == true) {
                deger_diger_para = document.add_health_invoice_control.rd_money[s-1];
                form_value_rate2 = eval("document.add_health_invoice_control.txt_rate2_"+s);
            }
        }
        deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
        form_value_rate2.value = filterNum(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
        if(toplam2 > 0) {
            document.add_health_invoice_control.amount.value = commaSplit(toplam2 * parseFloat(form_value_rate2.value,4)/(parseFloat(deger_money_id_3)));
            document.add_health_invoice_control.currency_amount.value = commaSplit(toplam2);
        }
        else {
            document.add_health_invoice_control.amount.value = commaSplit(0);
            document.add_health_invoice_control.currency_amount.value = commaSplit(0);
        }
        form_value_rate2.value = commaSplit(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
        return true;
    }
</script>