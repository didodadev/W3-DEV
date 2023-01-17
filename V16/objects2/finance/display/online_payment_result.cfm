<cfif isDefined("attributes.payType") and attributes.payType eq 1 and isDefined("attributes.pc") and len(attributes.pc) and isdefined("attributes.reference_code") and len(attributes.reference_code)>
    <cfset storage = deserializeJSON(session.storage) />
    <cfset partner_id = consumer_id = cookie_name = "" />

    <cfif isdefined("session.ww.userid")>
        <cfset consumer_id = session_base.userid>
    <cfelseif isdefined("session.pp.userid")>
        <cfset partner_id = session_base.userid>
    <cfelse>
        <cfset cookie_name = "#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#" />
    </cfif>

    <!--- Ödeme işlemi tamamlanır --->
    <cfset online_payment = createObject("component", "/V16/objects2/finance/cfc/online_payment") />
    <cfset completePayment = online_payment.completePayment(
        widget_id: storage.widget_id,
        referenceCode: attributes.reference_code
    ) />

    <cfset RCompletePayment = deserializeJson( completePayment ) />
    <cfif RCompletePayment.status and RCompletePayment.data.success>
        <cfset result = deserializeJSON( RCompletePayment.data.content.result ) />
        <cfif result.response_code eq 2><!--- Ödeme işlemi tamamlandıysa --->
            <div class="row mx-auto" style="height:200px;">
                <div class="col-md-6 text-danger">
                    <h4><cf_get_lang dictionary_id='65317.Tebrikler'>!</h4>
                    <h6 class="mt-3">Ödemeniz başarıyla gerçekleşti!</h6>
                    <ul class="mt-3" id="process_response"></ul>
                </div>
            </div>

            <!--- Sipariş işlemleri tamamlanır --->
            <script>

                function paymentRefund() {
                    var data = new FormData(), 
                        param = {
                            widget_id: <cfoutput>#storage.widget_id#</cfoutput>,
                            referenceCode: "<cfoutput>#result.REFERENCE_CODE#</cfoutput>",
                            amount: "<cfoutput>#result.AUTHORIZATION_AMOUNT#</cfoutput>",
                            type: "cancel"
                        };
                    data.append('cfc', '/V16/objects2/finance/cfc/online_payment');
                    data.append('method', 'cancelRefundPayment');
                    data.append('form_data', JSON.stringify(param));
                    AjaxControlPostData('/datagate',data,function(response) {
                        if( response.STATUS ){
                            if( response.DATA.SUCCESS ){
                                if( response.DATA.CONTENT.RESPONSE_CODE == 2 ){
                                    $("#process_response").append($("<li>").addClass('text-success').text("Ödemeniz iptal edildi! Lütfen daha sonra tekrar deneyiniz!"));
                                }else{
                                    $("#process_response").append($("<li>").addClass('text-danger').text("Ödemeniz iptal edilemedi! Lütfen müşteri temsilcimizle iletişime geçiniz!"));
                                }
                            }
                        }else{
                            $("#process_response").addClass('text-danger').append($("<li>").text(response.MESSAGE));
                        }
                    });
                }
                 // Sipariş dışı ödeme ise
                <cfif storage.is_amount eq 1>
                    $("#process_response").append($("<li>").addClass('text-success').text("Talebiniz Oluşturuluyor... Lütfen bekleyiniz."));

                    var data = new FormData();
                    data.append('cfc', '/V16/objects2/sale/cfc/basketAction');
                    data.append('method', 'add_payment_company');
                    data.append('form_data', JSON.stringify({
                        partner_id : "<cfoutput>#len(partner_id) ? partner_id : ''#</cfoutput>",
                        consumer_id : "<cfoutput>#len(consumer_id) ? consumer_id : ''#</cfoutput>",
                        cookie_name: "<cfoutput>#len(cookie_name) ? cookie_name : ''#</cfoutput>",
                        pos_id : "<cfoutput>#attributes.pos_id#</cfoutput>",
                        net_total: <cfoutput>#result.AUTHORIZATION_AMOUNT#</cfoutput>
                    }));

                    AjaxControlPostDataJson('/datagate',data,function(response) { 
                        if( response.STATUS ){
                            $("#process_response").append($("<li>").addClass('text-success').text("Ödemeniz başarıyla gerçekleşti!"));
                            $("#process_response").append($("<li>").addClass('text-success').text("Yönlendiriliyorsunuz..."));
                            setTimeout(function() { document.location.href = '/welcome'; }, 2000);
                        }else{
                            $("#process_response").append($("<li>").addClass('text-danger').text("Ödemeniz oluşturulurken bir hata oluştu."));
                            $("#process_response").append($("<li>").addClass('text-success').text("Ödemeniz iptal ediliyor... Lütfen bekleyiniz."));
                            paymentRefund();
                        }
                    });
                <cfelse>

                    $("#process_response").append($("<li>").addClass('text-success').text("Siparişiniz oluşturuluyor... Lütfen bekleyiniz."));
                    
                    var data = new FormData();
                    data.append('cfc', '/V16/objects2/sale/cfc/basketAction');
                    data.append('method', 'show_product_on_basket');
                    data.append('form_data', JSON.stringify({
                        partner_id : "<cfoutput>#len(partner_id) ? partner_id : ''#</cfoutput>",
                        consumer_id : "<cfoutput>#len(consumer_id) ? consumer_id : ''#</cfoutput>",
                        cookie_name: "<cfoutput>#len(cookie_name) ? cookie_name : ''#</cfoutput>"
                    }));

                    AjaxControlPostDataJson('/datagate',data,function(response) { 
                        if( response.SEPET_ADET > 0){

                            var data2 = new FormData();
                            data2.append('cfc', '/V16/objects2/sale/cfc/basketAction');
                            data2.append('method', 'add_order_func');
                            data2.append('form_data', JSON.stringify({
                                partner_id : "<cfoutput>#len(partner_id) ? partner_id : ''#</cfoutput>",
                                consumer_id : "<cfoutput>#len(consumer_id) ? consumer_id : ''#</cfoutput>",
                                subscription_id: "<cfoutput>#len(storage.url_param) ? storage.url_param : ''#</cfoutput>",
                                pos_id : "<cfoutput>#attributes.pos_id#</cfoutput>"
                            }));

                            AjaxControlPostDataJson('/datagate',data2,function(response) { 
                                if( response.STATUS ){
                                    $("#process_response").append($("<li>").addClass('text-success').text("Siparişiniz başarıyla oluşturuldu!"));
                                    $("#process_response").append($("<li>").addClass('text-success').text("Yönlendiriliyorsunuz..."));
                                    setTimeout(function() { document.location.href = '/welcome'; }, 2000);
                                }else{
                                    $("#process_response").append($("<li>").addClass('text-danger').text("Siparişiniz oluşturulurken bir hata oluştu."));
                                    $("#process_response").append($("<li>").addClass('text-success').text("Ödemeniz iptal ediliyor... Lütfen bekleyiniz."));
                                    paymentRefund();
                                }
                            });

                        }else{
                            $("#process_response").append($("<li>").addClass('text-danger').text("Sepetinizde ürün bulunamadı!"));
                            $("#process_response").append($("<li>").addClass('text-success').text("Ödemeniz iptal ediliyor... Lütfen bekleyiniz."));
                            paymentRefund();
                        }
                    });
                </cfif>
            </script>
        <cfelse>
            <div class="row mx-auto" style="height:400px;">
                <div class="col-md-6 text-danger">
                    <h4>Ödemeniz Gerçekleştirilemedi!</h4>
                    <h6 class="mt-3"><cfoutput>#result.response_data#</cfoutput></h6>
                    <h6 class="text-muted"><a href="/payment">Yeniden Denemek için Tıklayın</a></h4>
                </div>
            </div>
        </cfif>
    <cfelse>
        <div class="row mx-auto" style="height:400px;">
            <div class="col-md-6 text-danger">
                <h4>Ödemeniz Gerçekleştirilemedi!</h4>
                <h6 class="mt-3"><cfoutput>#RCompletePayment.message?:RCompletePayment.data.error_message#</cfoutput></h6>
                <h6 class="text-muted"><a href="/payment">Yeniden Denemek için Tıklayın</a></h4>
            </div>
        </div>
    </cfif>
<cfelseif isDefined("attributes.payType") and attributes.payType eq 2>

    <cfset storage = deserializeJSON(session.storage) />
    <cfset partner_id = consumer_id = cookie_name = "" />

    <cfif isdefined("session.ww.userid")>
        <cfset consumer_id = session_base.userid>
    <cfelseif isdefined("session.pp.userid")>
        <cfset partner_id = session_base.userid>
    <cfelse>
        <cfset cookie_name = "#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#" />
    </cfif>

    <div class="row mx-auto" style="height:200px;">
        <div class="col-md-6 text-danger">
            <h4><cf_get_lang dictionary_id='65317.Tebrikler'>!</h4>
            <h6 class="mt-3">Havale - EFT dekontunuz tarafımıza ulaştı!</h6>
            <ul class="mt-3" id="process_response"></ul>
        </div>
    </div>

    <!--- Sipariş işlemleri tamamlanır --->
    <script>

        <cfif storage.is_amount eq 1>
            $("#process_response").append($("<li>").addClass('text-success').text("Talebiniz oluşturuluyor... Lütfen bekleyiniz."));
            $("#process_response").append($("<li>").addClass('text-success').text("Yönlendiriliyorsunuz..."));
            setTimeout(function() { document.location.href = '/welcome'; }, 2000);
        <cfelse>
            $("#process_response").append($("<li>").addClass('text-success').text("Sipariş talebiniz oluşturuluyor... Lütfen bekleyiniz."));
            $("#process_response").append($("<li>").addClass('text-success').text("Sipariş talebiniz başarıyla alındı. İşlem onaylandığında Siparişlerim ekranından görüntüleyebilirsiniz!"));
            $("#process_response").append($("<li>").addClass('text-success').text("Yönlendiriliyorsunuz..."));
            setTimeout(function() { document.location.href = '/welcome'; }, 2000);
        </cfif>
                
        /* var data = new FormData();
        data.append('cfc', '/V16/objects2/sale/cfc/basketAction');
        data.append('method', 'show_product_on_basket');
        data.append('form_data', JSON.stringify({
            partner_id : "<cfoutput>#len(partner_id) ? partner_id : ''#</cfoutput>",
            consumer_id : "<cfoutput>#len(consumer_id) ? consumer_id : ''#</cfoutput>",
            cookie_name: "<cfoutput>#len(cookie_name) ? cookie_name : ''#</cfoutput>"
        }));

        AjaxControlPostDataJson('/datagate',data,function(response) { 
            if( response.SEPET_ADET > 0){

                var data2 = new FormData();
                data2.append('cfc', '/V16/objects2/sale/cfc/basketAction');
                data2.append('method', 'add_pre_order_func');
                data2.append('form_data', JSON.stringify({
                    partner_id : "<cfoutput>#len(partner_id) ? partner_id : ''#</cfoutput>",
                    consumer_id : "<cfoutput>#len(consumer_id) ? consumer_id : ''#</cfoutput>",
                    subscription_id: "<cfoutput>#len(storage.url_param) ? storage.url_param : ''#</cfoutput>"
                }));

                AjaxControlPostDataJson('/datagate',data2,function(response) { 
                    if( response.STATUS ){
                        $("#process_response").append($("<li>").addClass('text-success').text("Sipariş talebiniz başarıyla alındı. İşlem onaylandığında Siparişlerim ekranından görüntüleyebilirsiniz!"));
                        $("#process_response").append($("<li>").addClass('text-success').text("Yönlendiriliyorsunuz..."));
                        setTimeout(function() { document.location.href = '/welcome'; }, 2000);
                    }else{
                        $("#process_response").append($("<li>").addClass('text-danger').text("Siparişiniz oluşturulurken bir hata oluştu."));
                        $("#process_response").append($("<li>").addClass('text-success').text("Lütfen daha sonra tekrar deneyiniz!"));
                    }
                });

            }else{
                $("#process_response").append($("<li>").addClass('text-danger').text("Sepetinizde ürün bulunamadı!"));
                $("#process_response").append($("<li>").addClass('text-success').text("Lütfen daha sonra tekrar deneyiniz!"));
            } 
        });*/
    </script>

<cfelseif isDefined("attributes.response_code") and attributes.response_code eq 0>
    <div class="row mx-auto" style="height:400px;">
        <div class="col-md-6 text-danger">
            <h4>Ödemeniz Gerçekleştirilemedi!</h4>
            <h6 class="mt-3"><cfoutput>#attributes.response_data#</cfoutput></h6>
            <h6 class="text-muted"><a href="/payment">Yeniden Denemek için Tıklayın</a></h4>
        </div>
    </div>
<cfelse>
    <div class="row mx-auto" style="height:400px;">
        <div class="col-md-6 text-danger">
            Ödeme işlemi başlatılmamış!
        </div>
    </div>
</cfif>