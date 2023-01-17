<cfif isDefined("session.storage")>
    <cfset storage = deserializeJSON(session.storage) />
    <cfoutput>
        <div class="row mx-auto" style="height:300px;">
            <div class="col-md-12 text-danger">
                <h4>Merhaba #storage.name#,</h4>
                <h6 class="mt-3">Kurulumlarınız başarıyla tamamlandı!</h6>
                <h6>Sistem Yöneticisi olarak kullanıcın açıldı.</h6>
                <h6>Abonelik ve erişim bilgilerin e-mailine gönderildi.</h6>
                <h6 class="mt-3 text-body">İşletmenizin Domaini</h6>
                <h6 class="text-muted"><a href="https://#storage.subscription_domain#/index.cfm?fuseaction=home.login" target="_blank">https://#storage.subscription_domain#</a></h6>
                <h6 class="mt-3 text-body">Gelen mailinizi açın ve erişim linkine tıklayın.</h6>
                <h6>Dikkat: Mail işlemi bir kaç dakika sürebilir. Lütfen mailinizi kontrol ediniz.</h6>
                <h6 class="text-muted"><a href="javascript://" onclick="mailSender();">Tekrar Gönder</a></h6>
            </div>
        </div>
    </cfoutput>

    <script>
        function mailSender(){
            var data = new FormData();
            data.append('cfc', '/V16/objects2/sale/cfc/create_company_upd_subscription');
            data.append('method', 'mailSender');
            data.append('form_data', JSON.stringify({
                widget_id: <cfoutput>#widget.id#</cfoutput>
            }));
            AjaxControlPostDataJson('/datagate',data,function(response) {
                if(response.status){
                    alertMessage({
                        title: "Mail yeniden gönderildi!",
                        message: "Lütfen mail adresinizi kontrol edin: <cfoutput>#storage.company_partner_email#</cfoutput>",
                        confirmFunction: function(result){
                            if (result.value) { location.reload(); }
                        }
                    });
                }else{
                    alertMessage({
                        title: "Mail gönderilemedi!",
                        message: response.message,
                        confirmFunction: function(result){
                            if (result.value) { location.reload(); }
                        }
                    });
                }
            });
        }
    </script>
<cfelse>
    <div class="row mx-auto" style="height:400px;">
        <div class="col-md-6 text-danger">
            Lütfen önce satınalma süreçlerini tamamlayınız!
        </div>
    </div>
</cfif>