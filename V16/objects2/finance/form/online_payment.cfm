<cfif not structKeyExists(session, 'storage')><cfset session.storage = replace( serializeJSON( {} ), '//', '' ) /></cfif>
<cfset storage = deserializeJSON( session.storage ) />
<cfif not structKeyExists(storage, 'url_param') and isDefined("url.param_2") and url.param_2 neq 'src'>
    <cfset structAppend(storage, {url_param: url.param_2}) />
</cfif>
<cfif not structKeyExists(storage, 'company_id')>
    <cfset structAppend(storage, {company_id: session_base.company_id}) />
</cfif>
<cfif not structKeyExists(storage, 'is_amount')>
    <cfset structAppend(storage, {is_amount: attributes.is_amount}) />
</cfif>
<cfset session.storage = replace( serializeJSON(storage), '//', '' ) />
<div class="row mx-auto">
    <div class="col-md-12">
        <ul class="nav nav-tabs" id="myTab" role="tablist">
			<li class="nav-item active" data-id="1">
				<a class="nav-link active" id="home-tab" data-toggle="tab" href="#creditCart" role="tab" aria-controls="home" aria-selected="true">Kredi kartı ile ödeme</a>
			</li>
			<li class="nav-item" data-id="2">
				<a class="nav-link" id="profile-tab" data-toggle="tab" href="#havaleEft" role="tab" aria-controls="profile" aria-selected="false">Havale - Eft ile ödeme</a>
			</li>
        </ul>
        <div class="tab-content mt-3" id="myTabContent">
            <div class="tab-pane fade active show" id="creditCart" role="tabpanel" aria-labelledby="home-tab">
				<form id="creditCart-post" method="post" action="" autocomplete="off">
					<input type="hidden" value="1" name="payType">
					<fieldset class="col-md-12" style="padding:0">
                        <div class="form-group">
                            <label for="cardNumber" class="font-weight-bold">Kart Numarası</label>
                            <input type="text" name="cardNumber" id="cardNumber" class="form-control" data-payment="card_number" x-autocompletetype="cc-number" onblur="getInstallment()" data-message="Lütfen kart numaranızı giriniz!" required>
                        </div>
                        <div class="form-group">
                            <label for="cardHolderName" class="font-weight-bold">Kart Üzerindeki Ad Soyad</label>
                            <input type="text" name="cardHolderName" id="cardHolderName" class="form-control" autocomplete="nope" data-message="Lütfen kartınızın üzerindeki ad soyad bilgilerinizi giriniz!" required>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="font-weight-bold">Son Kullanma Tarihi</label>
                                    <input type="text" name="cardExpDate" id="cardExpDate" class="form-control" data-payment="card_expired_date" x-autocompletetype="cc-exp" data-message="Lütfen kartınızın üzerindeki son kullanma tarihini giriniz!" required maxlength="7">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="cardCvc" class="font-weight-bold">CVC</label>
                                    <input type="text" name="cardCvc" id="cardCvc" class="form-control" data-payment="card_cvc" x-autocompletetype="cc-csc" data-message="Lütfen kartınızın arka yüzündeki CVC kodunu giriniz!" required autocomplete="off">
                                </div>
                            </div>
                        </div>
                        <cfif attributes.is_amount eq 1>
                            <div class="row">
                                <div class="col-md-5">
                                    <div class="form-group">
                                        <label class="font-weight-bold">Tutar</label>
                                        <input type="text" name="AmountTotal" id="AmountTotal" class="form-control text-right" onblur="getInstallment()" onkeyup="return FormatCurrency(this,event,2);" data-message="Lütfen ödemek istediğiniz tutarı girin!">
                                    </div>
                                </div>
                            </div>
                        </cfif> 
                        <div class="row" style="display:none;">
                            <table id="installmentList" class="table">
                                <thead>
                                    <tr>
                                        <th></th>
                                        <th>Taksit Sayısı</th>
                                        <th>Taksit Tutarı</th>
                                        <th>Toplam Tutar</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
					</fieldset>
                    <div class="row">
                        <div class="col-md-12">
                            <input type="submit" class="btn btn-primary" value="Ödemeyi Tamamla">
                        </div>
                    </div>
				</form>
			</div>
            <div class="tab-pane fade" id="havaleEft" role="tabpanel" aria-labelledby="profile-tab">
                <form id="havaleEft-post" method="post" action="" autocomplete="off">
                    <input type="hidden" value="2" name="payType">
                    <fieldset class="col-md-12" style="padding:0">
                        <div class="form-group">
                            <label for="ibanNumber" class="font-weight-bold">Havale Gönderilen Hesabın Iban Kodu</label>
                            <input name="ibanNumber" type="text" placeholder = "TR11111122223333444455" class="form-control" id="ibanNumber" required>
                        </div>
                        <div class="form-group">
                            <label for="receiptDocument" class="font-weight-bold">Dekont Belgesini Yükleyin</label>
                            <input name="receiptDocument" type="file" class="form-control" id="receiptDocument" required>
                        </div>
                        <div class="form-group">
                            <label for="remittanceDate" class="font-weight-bold">Havale Tarihi</label>
                            <input name="remittanceDate" type="date" class="form-control" id="remittanceDate" required>
                        </div>
                    </fieldset>
                    <div class="row">
                        <div class="col-md-12">
                            <input type="submit" class="btn btn-primary" value="Ödemeyi Bildir">
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    function getInstallment() {
        $('table#installmentList').parent('div.row').hide();
        $('table#installmentList tbody').html('');
        var cardNumber = $("input[ name = cardNumber ]").val();
        if( cardNumber != '' && cardNumber.length == 19 ){
            var data = new FormData();
            data.append('cfc', '/V16/objects2/finance/cfc/online_payment');
            data.append('method', 'get_payment_installment');
            data.append('form_data', JSON.stringify({
                widget_id: <cfoutput>#widget.id#</cfoutput>,
                creditCardNo: cardNumber.replaceAll(' ', '')
                <cfif attributes.is_amount eq 1>
                ,amountTotal: $("input[ name = AmountTotal ]").val()
                </cfif>
            }));
            AjaxControlPostDataJson('/datagate',data,function(response) {
                if( response.STATUS ){
                    if( response.DATA.SUCCESS ){
                        var paymentBankList = response.DATA.CONTENT.PAYMENT_BANK_LIST;
                        if( paymentBankList != null ){
                            $('table#installmentList').parent('div.row').show();
                            paymentBankList.forEach((el) => {
                                var template="<tr><td class='text-center'><input name='installmentNo' value='"+ el.INSTALLMENT +"' type='radio' " + (el.CARD_TRX_TYPE == 'TEKCEKIM' ? 'checked' : '') + "></td><td>" + (el.CARD_TRX_TYPE == 'TEKCEKIM' ? 'Tek Çekim' : + el.INSTALLMENT + ' Taksit') + "</td><td>" + el.INSTALLMENT + ' X ' + el.INSTALLMENT_AMOUNT + "₺</td><td>"+ (el.CARD_TRX_TYPE == 'TEKCEKIM' ? '' : el.AUTHORIZATION_AMOUNT + '₺') +"</td></tr>";
                                $('table#installmentList tbody').append(template);
                            });
                        }else{
                            alertMessage({
                                title: 'Hatalı kart girişi yaptınız!',
                                message: 'Lütfen geçerli bir kart numarası giriniz!'
                            });
                            $("input[ name = cardNumber ]").val('');
                        }
                    }
                }
            });
        }

    }

    $("form#creditCart-post, form#havaleEft-post").submit(function(){
        let mistake = false;

        $(this).find('input[required], select[required]').each(function(){
            if($.trim($(this).val()) == ''){		
                alertMessage({
                    title: 'Mesaj',
                    message: $(this).data("message")
                });
                mistake = true;
            }
        });

        if(!mistake){
            var data = new FormData(), 
                param = {}, 
                parameters = $(this).serializeArray();
            
            parameters.forEach((el) => { param[el.name] = el.value });
            param.widget_id = <cfoutput>#widget.id#</cfoutput>;

            data.append('cfc', '/V16/objects2/finance/cfc/online_payment');
            
            if(param['payType'] == 1) data.append('method', 'payment');
            else{
                data.append('receiptDocument', $('input[name = receiptDocument]')[0].files[0]);
                data.append('method', 'payment_eft');
            }

            data.append('form_data', JSON.stringify(param));
            AjaxControlPostData('/datagate',data,function(response) {
                if( response.STATUS ){
                    if(param['payType'] == 1){
                        if( response.DATA.SUCCESS ){
                            if(response.DATA.CONTENT.RESPONSE_CODE == 2){
                                setTimeout(function() { 
                                    $("body").remove();
                                    $("html").html(response.DATA.CONTENT.BANK_REQUEST_MESSAGE);
                                    document.getElementById('form').submit();
                                }, 500);
                            }else{
                                alertMessage({
                                    title: 'Ödeme işlemi başlatılamadı!',
                                    message: response.DATA.CONTENT.RESPONSE_DATA,
                                    confirmFunction: function(result){
                                        if (result.value) { location.reload(); }
                                    }
                                });    
                            }
                        }else{
                            alertMessage({
                                title: 'Ödeme işlemi başlatılamadı!',
                                message: response.MESSAGE,
                                confirmFunction: function(result){
                                    if (result.value) { location.reload(); }
                                }
                            });
                        }
                    }else{
                        document.location.href = '<cfoutput>#attributes.success_url#?payType=2</cfoutput>';
                    }
                }else{
                    alertMessage({
                        title: 'Ödeme işlemi başlatılamadı!',
                        message: response.MESSAGE,
                        confirmFunction: function(result){
                            if (result.value) { location.reload(); }
                        }
                    });
                }
            });
        }

        return false;
    });

</script>