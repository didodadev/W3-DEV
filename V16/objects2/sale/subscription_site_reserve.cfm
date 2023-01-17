<cfif isDefined("attributes.pc") and len(attributes.pc) and isdefined("attributes.reference_code") and len(attributes.reference_code)>
    <cfset upload_folder = application.systemParam.systemParam().upload_folder />
    <cfif fileExists("#upload_folder#session_storage/#attributes.pc#.json")>
        <cffile action = "read" file = "#upload_folder#session_storage/#attributes.pc#.json" variable = "session_storage" charset = "utf-8">
        <cfset session.storage = session_storage />
        <cfcookie name="wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#" value="#attributes.pc#" expires="1">

        <cfset storage = deserializeJSON(session.storage) />

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
                        <h6 class="mt-3"><cf_get_lang dictionary_id='65318.Workcube dijital platformunu kullanmaya başlamak için birkaç dakikanız kaldı'>!</h6>
                        <h6><cf_get_lang dictionary_id='65319.Birazdan yönlendirileceksiniz'>.</h6>
                        <ul class="mt-3" id="process_response"></ul>
                    </div>
                </div>
                <!--- session storage dosyasını siler --->
                <cftry>
                    <cffile action="Delete" file="#upload_folder#session_storage/#attributes.pc#.json">
                <cfcatch type="any">
                </cfcatch>
                </cftry>
                <cfif storage.product[1].PRODUCT_ID neq 8817>
                    <!--- Site rezerve işlemleri tamamlanır --->
                    <script>
                        $("#process_response").append($("<li>").addClass('text-success').text("Abone tanımlarınız yapılıyor... Lütfen bekleyiniz."));
                        var data = new FormData();
                        data.append('cfc', '/V16/objects2/sale/cfc/create_company_upd_subscription');
                        data.append('method', 'site_reserve');
                        data.append('form_data', JSON.stringify({
                            widget_id: <cfoutput>#widget.id#</cfoutput>
                        }));
                        AjaxControlPostDataJson('/datagate',data,function(response) {
                            if( response.STATUS ){
                                $("#process_response").append($("<li>").addClass('text-success').text("Abone tanımlarınız başarıyla tamamlandı!"));
                                $("#process_response").append($("<li>").addClass('text-success').text("Yönlendiriliyorsunuz..."));
                                setTimeout(function() { document.location.href = '/yonlendirme'; }, 2000);
                            }else{
                                $("#process_response").append($("<li>").addClass('text-danger').text("Abone tanım işlemleriniz sırasında bir hata oluştu."));
                                $("#process_response").append($("<li>").addClass('text-success').text("Ödemeniz iptal ediliyor... Lütfen bekleyiniz."));
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
                        });
                    </script>
                <cfelse>
                    <script>document.location.href = '/tr';</script>
                </cfif>
            <cfelse>
                <div class="row mx-auto" style="height:400px;">
                    <div class="col-md-6 text-danger">
                        <h4>Ödemeniz Gerçekleştirilemedi!</h4>
                        <h6 class="mt-3"><cfoutput>#result.response_data#</cfoutput></h6>
                        <h6 class="text-muted"><a href="/siparis-odeme">Yeniden Denemek için Tıklayın</a></h4>
                    </div>
                </div>
            </cfif>
        <cfelse>
            <div class="row mx-auto" style="height:400px;">
                <div class="col-md-6 text-danger">
                    <h4>Ödemeniz Gerçekleştirilemedi!</h4>
                    <h6 class="mt-3"><cfoutput>#RCompletePayment.message?:RCompletePayment.data.error_message#</cfoutput></h6>
                    <h6 class="text-muted"><a href="/siparis-odeme">Yeniden Denemek için Tıklayın</a></h4>
                </div>
            </div>
        </cfif>

    </cfif>
<cfelseif isDefined("attributes.response_code") and attributes.response_code eq 0>
    <div class="row mx-auto" style="height:400px;">
        <div class="col-md-6 text-danger">
            <h4>Ödemeniz Gerçekleştirilemedi!</h4>
            <h6 class="mt-3"><cfoutput>#attributes.response_data#</cfoutput></h6>
            <h6 class="text-muted"><a href="/siparis-odeme">Yeniden Denemek için Tıklayın</a></h4>
        </div>
    </div>
<cfelse>
    <div class="row mx-auto" style="height:400px;">
        <div class="col-md-6 text-danger">
            Ödeme işlemi başlatılmamış!
        </div>
    </div>
</cfif>