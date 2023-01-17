<cfset get_basket = createObject("component", "cfc.basketAction")>
<cfset partner_id = consumer_id = cookie_name = "" />

<cfif isdefined("session.ww.userid")>
	<cfset consumer_id = session_base.userid>
<cfelseif isdefined("session.pp.userid")>
	<cfset partner_id = session_base.userid>
<cfelse>
    <cfset cookie_name = evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#") />
</cfif>

<cfset basket = get_basket.get_product_to_basket( consumer_id, partner_id, cookie_name ) >

<cfif basket.recordcount gt 0>

    <div class="table-responsive">
        <table class="table table-bordered">
            <thead>
                <tr class="header-color">
                <th class="border-top-0 border-left-0" scope="col"><cf_get_lang dictionary_id='57629.Açıklama'></th>
                <th class="border-top-0" scope="col"><cf_get_lang dictionary_id='57635.Quantity'></th>
                <th class="border-top-0" scope="col"><cf_get_lang dictionary_id='57636.Unit'></th>
                <th class="border-top-0 text-center" scope="col" colspan="2"><cf_get_lang dictionary_id='61696.?'></th>
                <th class="border-top-0" scope="col"><cf_get_lang dictionary_id='57639.KDV'></th>
                <th class="border-top-0" scope="col"><cf_get_lang dictionary_id='37427.KDV li Fiyat'></th>
                <th class="border-top-0 text-center" scope="col" colspan="2"><cf_get_lang dictionary_id='57212.Total Excluding VAT'></th>
                <th class="border-top-0 text-center" scope="col" colspan="2"><cf_get_lang dictionary_id='51316.Total Including VAT'></th>
                <th class="border-top-0 border-right-0" scope="col"></th>              
                </tr>
            </thead>
            <tbody>
                <cfoutput query="basket">
                    <cfset prod_rev_name ="#replacelist(product_name," ,{,},/,+","-,-,-,-,-")#">
                    <tr>
                        <td class="border-left-0" scope="row"><a href="/ProductDetail/#product_id#/#stock_id#/#prod_rev_name#">#product_name#</a></td>
                        <td class="text-center">#QUANTITY#</td>
                        <td>#MAIN_UNIT#</td>
                        <td class="text-right">#TLFORMAT(PRICE)#</td>
                        <td>#MONEY#</td>
                        <td>#TAX#</td>
                        <td class="text-right">#TLFORMAT(PRICE_KDV)#</td>
                        <td class="text-right">#TLFORMAT(PRICE_TL)#</td>
                        <td>#session_base.MONEY#</td>
                        <td class="text-right">#TLFORMAT(PRICE_KDV_TL)#</td>
                        <td>#session_base.MONEY#</td>
                        <td class="border-right-0"><button type="button" class="btn btn-circle-md" onclick="del_product('#product_id#', '#stock_id#','#partner_id#', '#consumer_id#')"><i class="fa fa-minus"></i></button></td>
                    </tr>
                </cfoutput>
            </tbody>
        </table>
    </div>

    <cfquery name="get_total" dbtype="query">
        SELECT SUM(PRICE_KDV_TL) AS T_TL_PRICE,
            SUM(PRICE * QUANTITY) AS T_USD_PRICE,
            SUM(QUANTITY) AS T_ADET, 
            SUM(PRICE_TL) AS PRICE_TL
        FROM basket
        WHERE (IS_CARGO IS NULL OR IS_CARGO = 0)
        GROUP BY MONEY
    </cfquery>

    <!--- <cfdump var = "#get_total#" abort> --->

    <cfquery name="get_cargo" dbtype="query">
        SELECT SUM(PRICE_CARGO) AS T_TL_PRICE,SUM(QUANTITY) AS T_ADET FROM basket WHERE IS_CARGO = 1
    </cfquery>
  
    <div class="row">
        <div class="col-xl-8">
        <!--- <label class="font-weight-bold text-color-4">KUR BİLGİSİ</label>
        <div class="custom-control custom-radio">
            <input type="radio" id="customRadio1" class="custom-control-input">
            <label class="custom-control-label text-w3">TL</label>
            <label class="text-right">1,0000</label>
        </div>
        <div class="custom-control custom-radio">
            <input type="radio" id="customRadio1" class="custom-control-input">
            <label class="custom-control-label text-w3">USD</label>
            <label class="text-right">7,8712</label>
        </div>
        <div class="custom-control custom-radio">
            <input type="radio" id="customRadio1" class="custom-control-input">
            <label class="custom-control-label text-w3">Euro</label>
            <label class="text-right">9,3452</label>
        </div>
    
        <div class="row mt-4">
            <div class="col-md-12">
            <p class="mb-1 text-color-4"><small>Bu cari hesapla TL çalışılmaktadır.</small></p>              
            </div>
        </div> --->
        </div>
        <cfif get_total.recordcount>
            <div class="col-xl-4 mt-2">
                <div class="table-responsive">
                    <table class="table table-bordered">
                        <tbody>
                            <tr>
                                <td>Ara Toplam:</td>
                                <td class="text-right"><cfoutput>#TLFORMAT(get_total.PRICE_TL)# #session_base.MONEY#</cfoutput></td>
                            </tr>
                            <tr>
                                <td>Toplam KDV:</td>
                                <td class="text-right"><cfoutput>#TLFORMAT(get_total.T_TL_PRICE  - get_total.PRICE_TL)# #session_base.MONEY#</cfoutput></td>
                            </tr>
                            <cfif get_cargo.recordcount>
                            <tr>
                                <td>Kargo:</td>
                                <td class="text-right"><cfoutput>#TLFORMAT(get_cargo.T_ADET * get_cargo.T_TL_PRICE)# #session_base.MONEY#</cfoutput></td>
                            </tr>
                            </cfif>
                            <tr>
                                <td>Genel Toplam:</td>
                                <td class="text-right"><cfoutput>#TLFORMAT(get_total.T_TL_PRICE)# #session_base.MONEY#</cfoutput></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </cfif>
    </div>
<cfelse>
    <h1 class="mt-5 text-center"><i class="fa fa-shopping-basket mr-2" style="font-size:100px;"></i></h1>
    <h3 class="mt-3 text-center" style="padding:40px;">Sepetiniz boş kaldı! Hemen alışverişe başlamak için <a href="/Product">tıklayın</a></h3>
</cfif>
<script>
    function sepet_kontrol(){
        if( !$("input[name=check]").prop( "checked" )){
            alert("Lütfen Sözleşmeyi Okuyup Onaylayın")
        }else{
            var basket_subscription_id = document.getElementById('basket_subscription_id').value;
            var is_subscription = document.getElementById('is_subscription').value;
            if( is_subscription == 1 && basket_subscription_id == '' ){
                alert("<cf_get_lang dictionary_id='41400.Lütfen Abone Seçiniz'>!");
                return false;
            }
            add_order('<cfoutput>#partner_id#</cfoutput>', '<cfoutput>#consumer_id#</cfoutput>', basket_subscription_id);
        }
    }

    function offer_kontrol() {
        if( !$("input[name=check]").prop( "checked" )){
            alert("Lütfen Sözleşmeyi Okuyup Onaylayın");
        }else{
            add_offer('<cfoutput>#partner_id#</cfoutput>', '<cfoutput>#consumer_id#</cfoutput>');
        } 
    }
</script>