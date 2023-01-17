<cfset subscribers = createObject("component","V16.objects2.sale.cfc.subscribers")>
<cfset get_subscription_contract = subscribers.get_subscription_contract(company_id : session_base.company_id)>
<cfif isDefined("session.pp") and attributes.is_risc_order eq 1> <!--- Risk limitine bağlı sipariş verilebilsin --->
    <cfset get_risc_info = subscribers.get_company_risk(company_id : session_base.company_id)>
    <cfset risc_info = deserializeJSON(get_risc_info)>
</cfif>
<cfset partner_id = consumer_id = "" />
<cfif isdefined("session.ww.userid")>
	<cfset consumer_id = session_base.userid>
<cfelseif isdefined("session.pp.userid")>
	<cfset partner_id = session_base.userid>
</cfif>
<input type="hidden" name="is_subscription" id="is_subscription" value="<cfoutput>#attributes.is_subscription#</cfoutput>">
<cfif attributes.is_subscription eq 1> <!--- Abone Bazlı Sipariş Oluşturulabilir --->
    <cfif get_subscription_contract.recordcount>
        <div class="row mb-2">
            <div class="col-md-12">
                <h6 class="mb-2 font-weight-bold text-color-5">Bu işlemi gerçekleştirebileceğiniz abone sayısı: <cfoutput>#get_subscription_contract.recordcount#</cfoutput></h6>
                <p class="font-weight-bold text-color-4">Workcube ID seçerek alım yapabilirsiniz.</p>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <div class="form-group mb-3">
                    <label class="font-weight-bold text-uppercase"><cf_get_lang dictionary_id='61813.?'></label>
                    <select name="basket_subscription_id" id="basket_subscription_id" class="form-control input-color-1">
                        <option value="">Abone Bilgisi</option>
                        <cfoutput query = "get_subscription_contract">
                            <option value="#SUBSCRIPTION_ID#" #(isdefined('session_base.subscription_id') and len(session_base.production_subscription_id) and session_base.production_subscription_id eq SUBSCRIPTION_ID) ? 'selected' : ''#>#SUBSCRIPTION_NO#</option>
                        </cfoutput>
                    </select>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <p class="mb-0"><cf_get_lang dictionary_id='61814.?'>:</p>
                <p class="font-weight-bold"><cfoutput>#session_base.company?:''#</cfoutput></p>
            </div>
        </div>
    <cfelse>
        <cfform action="/subscriberInfo?return_url=#attributes.param_1#">
            <input type="hidden" name="basket_subscription_id" id="basket_subscription_id" value="">
            <div class="row mb-2">
                <div class="col-md-12">                
                    <h6 class="mb-4 text-color-5 font-weight-bold"><cf_get_lang dictionary_id='61926.Bu işlemi gerçekleştirmek için yeni Abone kaydı açmalısınız'>.</h6>
                </div>
            </div>
            <!--- <div class="row">
                <div class="col-md-12">
                    <div class="form-group mb-3">                        
                        <select class="form-control input-color-1">
                            <option>Fırsatı Seçiniz</option>
                            <option>2</option>
                            <option>3</option>
                            <option>4</option>
                            <option>5</option>
                        </select>
                    </div>
                </div>
            </div> --->
            <div class="row mb-3">
                <div class="col-md-12">
                    <button type="submit" class="btn font-weight-bold btn-block input-color-5"> <cf_get_lang dictionary_id='62771.Yeni Abone Aç'></button>                      
                </div>
            </div>
        </cfform>
    </cfif>
<cfelse>
    <input type="hidden" name="basket_subscription_id" id="basket_subscription_id" value="">
</cfif>

<div class="row mb-3">
    <div class="col-md-12">
        <label class="checkbox-container font-weight-bold"><cf_get_lang dictionary_id='61698.Sözleşmeyi Kabul Ediyorum'>
            <input type="checkbox" name="check">
            <span class="checkmark"></span>
        </label>    
        <cfif isDefined("attributes.x_content_id") and len(attributes.x_content_id)>
            <cfquery name="get_content" datasource="#dsn#">
                SELECT CONT_HEAD FROM CONTENT WHERE CONTENT_ID = #attributes.x_content_id# AND LANGUAGE_ID = '#session_base.language#'
            </cfquery>
            <cfif get_content.recordcount>
                <a href="javascript://" onclick="openBoxDraggable('widgetloader?widget_load=viewContent&x_content_id=<cfoutput>#attributes.x_content_id#</cfoutput>&isbox=1&style=maxi&title=<cfoutput>#get_content.CONT_HEAD#</cfoutput>')" class="none-decoration">
                    <p class="ml-4 small"><cf_get_lang dictionary_id='61815.Sözleşmeyi okumak için tıklayınız'>!</p>
                </a>
            </cfif>
        </cfif>
    </div>
</div> 

<cfset session_company_category = session_base.company_category>
<cfset xml_company_cat_member_id = attributes.company_cat_member_id>

<cfset session_company_category = listSort(session_company_category, 'numeric')>
<cfset xml_company_cat_member_id = listSort(xml_company_cat_member_id, 'numeric')>

<div class="row">
    <div class="col-md-12">
        <cfif len(xml_company_cat_member_id)>
            <cfif ((compareNoCase(session_company_category,xml_company_cat_member_id) eq 0) or (compareNoCase(session_company_category,xml_company_cat_member_id) eq 1) or (compareNoCase(session_company_category,xml_company_cat_member_id) eq -1))>
                <cfif attributes.is_risc_order eq 1>
                    <cfif sepet_toplam lte risc_info.member_use_limit>
                        <button type="submit" class="btn font-weight-bold btn-block text-uppercase btn-color-1" onclick="javascript:sepet_kontrol();"> 
                            <cf_get_lang dictionary_id='32011.Place Order'>
                        </button>
                    <cfelse>
                        <h6 class="mb-4 text-color-5 font-weight-bold">Bu siparişi verebilmek için kullanılabilir limitiniz uygun değildir.</h6>
                    </cfif>
                <cfelse>
                    <button type="submit" class="btn font-weight-bold btn-block text-uppercase btn-color-1" onclick="javascript:sepet_kontrol();"> 
                        <cf_get_lang dictionary_id='32011.Place Order'>
                    </button>
                </cfif>
            <cfelse>
                Bu işlemi yapabilmek için uygun bir kurumsal üye kategorisine dahil değilsiniz!
            </cfif>
        <cfelse>
            <button type="submit" class="btn font-weight-bold btn-block text-uppercase btn-color-1" onclick="javascript:sepet_kontrol();"> 
                <cf_get_lang dictionary_id='32011.Place Order'>
            </button>
        </cfif>
    </div>
    <cfif attributes.is_offer eq 1>
        <cfif len(xml_company_cat_member_id) and ((compareNoCase(session_company_category,xml_company_cat_member_id) eq 0) or (compareNoCase(session_company_category,xml_company_cat_member_id) eq 1) or (compareNoCase(session_company_category,xml_company_cat_member_id) eq -1))>
            <div class="col-md-12 mt-2">
                <button type="submit" class="btn font-weight-bold btn-block text-uppercase btn-color-4" onclick="javascript:offer_kontrol();"> <cf_get_lang dictionary_id='38169.Teklif Al'></button>
            </div>
        </cfif>
    </cfif>
</div>

<script>
    function sepet_kontrol(){
        if( !$("input[name=check]").prop( "checked" )){
            alertMessage({
                title: 'Sözleşmeyi Onaylamadınız!',
                message: 'Lütfen Sözleşmeyi Okuyup Onaylayın!'
            });
        }else{
            var basket_subscription_id = document.getElementById('basket_subscription_id').value;
            var is_subscription = document.getElementById('is_subscription').value;
            if( is_subscription == 1 && basket_subscription_id == '' ){
                alertMessage({
                    title: "Abone Seçmediniz!",
                    message: "<cf_get_lang dictionary_id='41400.Lütfen Abone Seçiniz'>!"
                });
                return false;
            }
            document.location.href = '<cfoutput>#attributes.order_url#</cfoutput>/' + basket_subscription_id;
            //add_order('<cfoutput>#partner_id#</cfoutput>', '<cfoutput>#consumer_id#</cfoutput>', basket_subscription_id);
        }
    }

    function offer_kontrol() {
        if( !$("input[name=check]").prop( "checked" )){
            alertMessage({
                title: "Sözleşmeyi Onaylamadınız!",
                message: "Lütfen Sözleşmeyi Okuyup Onaylayın!"
            });
        }else{
            add_offer('<cfoutput>#partner_id#</cfoutput>', '<cfoutput>#consumer_id#</cfoutput>');
        } 
    }
</script>