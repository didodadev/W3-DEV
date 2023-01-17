<cfparam name="attributes.product_id" default="">

<style>
    .table thead th, .table tbody td{
        border: none !important;
        padding: 0.25rem 0.25rem 0.25rem 0 !important;
        font-weight: 500 !important;
    }
    .form-control:disabled, .form-control[readonly] {
        background-color: #fff !important;
    }
</style>

<cfset quantity = 0 />
<cfset TotalProductPrice = 0.0 />
<cfset TotalPrice = 0.0 />
<cfset TotalPrice_2 = 0.0 />
<cfset TotalDiscountPrice = 0.0 />
<cfset currency_type = "" />
<cfif isDefined("session.storage")>
    <cfset structDelete(session, "storage") />
</cfif>

<cfif isDefined("attributes.param_2") and len(attributes.param_2)><!---  Basket kayıt modunda görüntüleniyorsa --->
    <cfset attributes.product_id = attributes.param_2 />
    <cfquery name="get_stock_by_product_id" datasource="#dsn3#">
        SELECT STOCK_ID FROM STOCKS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
    </cfquery>
    
    <cfif get_stock_by_product_id.recordcount>
        <cfset prodData = createObject("component","V16/objects2/product/cfc/data") />
        <cfset get_stock = prodData.GET_HOMEPAGE_PRODUCTS(stock_id: get_stock_by_product_id.stock_id,session_base:session_base) />

        <cfquery name="get_related_stock_by_product_id" datasource="#dsn3#">
            SELECT S.STOCK_ID FROM RELATED_PRODUCT AS RP, STOCKS AS S WHERE RP.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND S.PRODUCT_ID = RP.RELATED_PRODUCT_ID
        </cfquery>

        <cfif get_related_stock_by_product_id.recordcount>
            <cfset get_stock_related = prodData.GET_HOMEPAGE_PRODUCTS(stock_id: get_related_stock_by_product_id.stock_id,session_base:session_base) />
        <cfelse>
            <cfset get_stock_related = { recordcount: 0 } />
        </cfif>
    <cfelse>
        <cfset get_stock = { recordcount: 0 } />
        <cfset get_stock_related = { recordcount: 0 } />
    </cfif>
<cfelse>
    <cfabort>
</cfif>

<cfif get_stock.recordcount>
    <h3 class="mt-5" style="color: #E38283;"><cfoutput>#get_stock.PRODUCT_NAME#</cfoutput></h3>
    <h5 class="mt-3"><cfoutput>#get_stock.PRODUCT_DETAIL#</cfoutput></h5>
    <h6 class="mt-3"><cfoutput>#get_stock.PRODUCT_DETAIL2#</cfoutput></h6>            

    <cfform name="add_to_basket" id="add_to_basket" action="" method="post">
        <cfinput type="hidden" name="widget_id" id="widget_id" value="#widget.id#" />
        <div class="row mx-auto">
            <cfif get_stock_related.recordcount>
                <div class="col-lg-8 col-md-10 col-sm-12">
                    <h6 class="mb-3"><cf_get_lang dictionary_id='65302.Dijitalleşmek için bir adımınız kaldı. Kullanıcı sayınızı belirtin. Kullanıma geçtiğiniz zaman aynı fiyattan kullanıcı sayısını artırabilirsiniz.'></h6>
                    <div class="col-lg-8 col-md-10 col-sm-12 p-0">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>On-Prem Sunucu ( 1 Sistem Yöneticisi Kullanıcıyla birlikte gelir. )</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query = "get_stock">
                                    <cfinput type="hidden" name="product_id" id="product_id" value="#PRODUCT_ID#" />
                                    <cfinput type="hidden" name="quantity" id="quantity" value="1">
                                    <tr> 
                                        <cfset TotalPrice_2 += PRICE />
                                        <td>
                                            <div class="form-group col-md-4 pl-0">
                                                <input type="text" name="product_main_unit_price" id="product_main_unit_price" class="form-control text-center font-weight-bold" value="#TLFormat(PRICE)# #MONEY#" required readonly>
                                            </div>
                                        </td>
                                    </tr>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                    <h5 style="color: #E38283;">Ek Ürünler</h5>
                    <div class="col-lg-12 col-md-12 col-sm-12 p-0">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Açıklama</th>
                                    <th class="text-right">Miktar</th>
                                    <th>Birim</th>
                                    <th class="text-right">Birim Fiyat</th>
                                    <th class="text-right">Toplam</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query = "get_stock_related">
                                    <cfinput type="hidden" name="product_id" id="product_id" value="#PRODUCT_ID#" />
                                    <cfset quantity = 1 />
                                    <tr>
                                        <td>
                                            <div class="form-group">
                                                <input type="text" name="product_name" id="product_name" class="form-control" value="#PRODUCT_NAME#" readonly>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="form-group">
                                                <input type="text" name="quantity" id="quantity_user" class="form-control text-right" value="1" onkeyup="setTotalPrice('#PRICE#')" required>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="form-group">
                                                <input type="text" name="product_unit" id="product_unit" class="form-control" value="#ADD_UNIT#" readonly>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="form-group">
                                                <input type="text" name="product_unit_price" id="product_unit_price" class="form-control text-right" value="#TLFormat(PRICE)# #MONEY#" readonly>
                                            </div>
                                        </td>
                                        <cfset TotalProductPrice += PRICE />
                                        <cfset TotalPrice += PRICE />
                                        <cfset TotalDiscountPrice = TotalProductPrice * 2 />
                                        <cfset currency_type = MONEY />
                                        <td>
                                            <div class="form-group">
                                                <input type="text" name="product_total_price" id="product_total_price" class="form-control text-right" value="#TLFormat(PRICE)# #MONEY#" readonly>
                                            </div>
                                        </td>
                                    </tr>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                    <div class="row">
                        <div class="col-md-12 col-sm-12">
                            <div class="form-group col-md-4 pl-0">
                                <label for="total_price" class="font-weight-bold"><cf_get_lang dictionary_id='29534.Toplam Tutar'></label>
                                <input type="text" name="total_price" id="total_price" value="<cfoutput>#TLFormat( TotalPrice + TotalPrice_2 )# #currency_type#</cfoutput>" class="form-control text-center font-weight-bold" readonly>
                            </div>
                        </div>
                    </div>
                </div>
            <cfelse>
                <div class="col-lg-8 col-md-10 col-sm-12">
                    <h5 class="mt-3" style="color: #E38283;">Kullanıcı Sayınızı Belirleyin!</h5>
                    <h6 class="mb-3"><cf_get_lang dictionary_id='65302.Dijitalleşmek için bir adımınız kaldı. Kullanıcı sayınızı belirtin. Kullanıma geçtiğiniz zaman aynı fiyattan kullanıcı sayısını artırabilirsiniz.'></h6>
                    <!--- <h6 class="mt-3 mb-4">Kullanıma geçtiğiniz zaman aynı fiyattan kullanıcı sayısını artırabilirsiniz.</h6> --->
                    <div class="col-lg-8 col-md-10 col-sm-12 p-0">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Kullanıcı Sayısı</th>
                                    <th>Kulanıcı Başına / Ay</th>
                                    <th>Toplam / Ay</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query = "get_stock">
                                    <cfinput type="hidden" name="product_id" id="product_id" value="#PRODUCT_ID#" />
                                    <cfset quantity = 1 />
                                    <tr>
                                        <td>
                                            <div class="form-group">
                                                <input type="text" name="quantity" id="quantity_user" class="form-control" value="1" onkeyup="setTotalPrice('#PRICE#')" required>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="form-group">
                                                <input type="text" name="product_unit_price" id="product_unit_price" class="form-control text-right" value="#TLFormat(PRICE)# #MONEY#" readonly>
                                            </div>
                                        </td>
                                        <cfset TotalProductPrice += PRICE />
                                        <cfset TotalPrice += PRICE />
                                        <cfset TotalDiscountPrice = TotalProductPrice * 2 />
                                        <cfset currency_type = MONEY />
                                        <td>
                                            <div class="form-group">
                                                <input type="text" name="product_total_price" id="product_total_price" class="form-control text-right" value="#TLFormat(PRICE)# #MONEY#" readonly>
                                            </div>
                                        </td>
                                    </tr>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                    <h6><cf_get_lang dictionary_id='65303.1 yıllık peşin ödediğinizde 2 ay ücretsiz kullanım hakkı kazanacaksınız'>!</h6>
                    <h6 class="mb-3 text-danger"><cf_get_lang dictionary_id='65307.Kazanacağınız indirim'>: <span id="discount_price"><cfoutput>#TLFormat( TotalPrice * 2 )#</cfoutput></span> <cfoutput>#currency_type#</cfoutput></h6>
                    <div class="row">
                        <div class="col-md-12 col-sm-12">
                            <label class="checkbox-container">
                                <input type="checkbox" name="one_year_cash_payment" id="one_year_cash_payment" onchange="setTotalPriceByCheckbox();">
                                <span class="checkmark"></span>
                                <cf_get_lang dictionary_id='65304.1 yılık avantajlı alım yapmak için tıklayınız'>.
                            </label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12 col-sm-12">
                            <div class="form-group col-md-4 pl-0">
                                <label for="total_price" class="font-weight-bold"><cf_get_lang dictionary_id='29534.Toplam Tutar'></label>
                                <input type="text" name="total_price" id="total_price" value="<cfoutput>#TLFormat( TotalPrice )# #currency_type#</cfoutput>" class="form-control text-center font-weight-bold" readonly>
                            </div>
                        </div>
                    </div>
                </div>
            </cfif>
            <div class="col-lg-8 col-md-10 col-sm-12">
                <div class="row">
                    <div class="col-md-12 col-sm-12">
                        <label class="checkbox-container font-weight-bold">
                            <input type="checkbox" name="accept_license" id="accept_license" required>
                            <span class="checkmark"></span>
                            <cf_get_lang dictionary_id='65305.Kullanım sözleşmesi ve koşullarını okudum. Kabul ettim.'>
                        </label>
                    </div>
                    <cfif isDefined("attributes.x_content_id") and len(attributes.x_content_id)>
                        <cfquery name="get_content" datasource="#dsn#">
                            SELECT CONT_HEAD FROM CONTENT WHERE CONTENT_ID = #attributes.x_content_id# AND LANGUAGE_ID = '#session_base.language#'
                        </cfquery>
                        <cfif get_content.recordcount>
                            <div class="col-md-12 col-sm-12 pl-5">
                                <a href="javascript://" onclick="openBoxDraggable('widgetloader?widget_load=viewContent&x_content_id=<cfoutput>#attributes.x_content_id#</cfoutput>&isbox=1&style=maxi&title=<cfoutput>#get_content.CONT_HEAD#</cfoutput>')" class="none-decoration text-body">
                                    >> <cf_get_lang dictionary_id='65306.Tıklayarak sözleşmeyi okuyabilirsiniz'>!
                                </a>
                            </div>
                        </cfif>
                    </cfif>
                </div>
            </div>
            <div class="col-lg-8 col-md-10 col-sm-12 mt-3">
                <div class="form-group" style="float: left;">
                    <cf_workcube_buttons is_insert="1" insert_info="İlerle" win_alert="0" data_action="/V16/objects2/sale/cfc/default_product_basket_operations:basket_operations" next_page="/musteri" class="btn-success">
                </div>
            </div>
        </div>
    </cfform>

    <script>
        var quantity = <cfoutput>#quantity#</cfoutput>,
            product_price = <cfoutput>#TotalPrice#</cfoutput>,
            total_product_price = <cfoutput>#TotalProductPrice#</cfoutput>,
            discount_price = <cfoutput>#TotalDiscountPrice#</cfoutput>,
            total_price = <cfoutput>#TotalPrice#</cfoutput>;
            total_price_2 = <cfoutput>#TotalPrice_2#</cfoutput>;
            currency_type = '<cfoutput>#currency_type#</cfoutput>';

        function setTotalPrice(price) {
            quantity = parseInt( $("#quantity_user").val() );
            product_price = parseFloat( price );
            
            if( quantity != '' && quantity != 0 ){
                
                total_product_price = quantity * product_price;
                $("#product_total_price").val( commaSplit( total_product_price ) + ' ' + currency_type );
                discount_price = total_product_price * 2;
                total_price = total_product_price;
                if($("input[name = one_year_cash_payment]").length > 0){
                    if( $("input[name = one_year_cash_payment]").is(":checked") ) total_price = (total_product_price * 12)  - discount_price;
                    else total_price = total_product_price;    
                }
                
            }else{

                total_product_price = product_price;
                $("#quantity_user").val( 1 );
                $("#product_total_price").val( commaSplit( product_price ) + ' ' + currency_type );
                discount_price = total_product_price * 2;
                total_price = total_product_price;

            }
            $("#discount_price").text( commaSplit( discount_price ) );
            $("#total_price").val( commaSplit( total_price + total_price_2 ) + ' ' + currency_type );
        }

        function setTotalPriceByCheckbox() {
            total_price = total_product_price;
            if($("input[name = one_year_cash_payment]").length > 0){
                if( $("input[name = one_year_cash_payment]").is(":checked") ) total_price = (total_product_price * 12)  - discount_price;
                else total_price = total_product_price;
            }
            $("#total_price").val( commaSplit( total_price + total_price_2 ) + ' ' + currency_type );
        }
    </script>
<cfelse>
    Bu ürün sistemlerimizde mevcut değildir!
</cfif>