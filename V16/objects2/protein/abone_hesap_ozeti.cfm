<cfset subscription_contract = createObject('component','V16.sales.cfc.subscription_contract') />
<cfset get_subscription_counter = subscription_contract.get_subscription_counter( subscription_id: attributes.subscription_id ) />

<cfif get_subscription_counter.recordcount>
    <div class="row">
        <div class="col-md-12">
            <label class="font-weight-bold float-left"><cf_get_lang dictionary_id='61794.?'></label>
            <label class="font-weight-bold float-right"><cf_get_lang dictionary_id='57589.Balance'></label>
        </div>
    </div>
    <cfoutput query="get_subscription_counter">
        <div class="row">
            <div class="col-md-12">
                <label class="float-left w-50">#PRODUCT_NAME#</label>
                <label class="font-weight-bold float-right project-color-g">#TLFormat(TOTAL_COUNT)# #MAIN_UNIT#</label>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <a href="javascript://" onclick="openBoxDraggable('widgetloader?widget_load=uploadContour&product_id=#PRODUCT_ID#&isbox=1&style=maxi')"> <i class="fas fa-shopping-cart float-left text-color-1"> <cf_get_lang dictionary_id='34589.Purchase'></i></a>
            </div>
        </div>
    </cfoutput>
<cfelse>
    <label><cf_get_lang dictionary_id='37678.Kontürlü ürününüz bulunamadı'>!</label>
</cfif>
<hr>
<cfset get_extre = subscription_contract.get_extre( subscription_id: attributes.subscription_id ) />
<div class="mb-3">
    <label><cf_get_lang dictionary_id='61636.Abone Cari Hesap Özeti'></label>
</div>
<cfif get_extre.recordcount>
    <!--- <div class="row mb-2">
        <div class="col-md-12">
            <div class="progress">
                <div class="progress-bar bg-color-1" role="progressbar" style="width: 75%;" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100"></div>
            </div>
        </div>
    </div>
    <div class="row mb-2">
        <div class="col-md-12">
            <div class="progress">
                <div class="progress-bar bg-color-2" role="progressbar" style="width: 50%;" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100"></div>
            </div>
        </div>
    </div> --->

    <div class="row mt-3">
        <div class="col-md-12">
            <div class="row">
                <div class="col-12">
                    <label class="font-weight-bold float-left project-color-g text-w1"><cf_get_lang dictionary_id='57587.Debit'></label>
                    <cfoutput query="get_extre">
                        <label class="font-weight-bold float-right text-right text-w2">#TLFormat(TOTAL_BORC_OTHER)# #OTHER_MONEY#</label>
                    </cfoutput>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <label class="font-weight-bold float-left text-color-1 text-w1"><cf_get_lang dictionary_id='57588.Credit'></label>
                    <cfoutput query="get_extre">
                        <label class="font-weight-bold float-right text-right text-w2">#TLFormat(TOTAL_ALACAK_OTHER)# #OTHER_MONEY#</label>
                    </cfoutput>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <label class="font-weight-bold float-left text-color-2 text-w1"><cf_get_lang dictionary_id='57589.Balance'></label>
                    <cfoutput query="get_extre">
                        <label class="font-weight-bold float-right text-right text-w2">#TLFormat(ABS(TOTAL_BORC_OTHER - TOTAL_ALACAK_OTHER))# #OTHER_MONEY#</label>
                    </cfoutput>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-12">
                    <label class="font-weight-bold text-color-3"><cf_get_lang dictionary_id='61795.?'></label>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <label class="font-weight-bold float-left text-color-3 text-w1">42 <cf_get_lang dictionary_id='57490.Gün'></label>                        
                    <label class="font-weight-bold float-right text-right text-w2">70,00 $</label>                    
                    <label class="font-weight-bold float-right text-right text-w2">870,00 <cf_get_lang dictionary_id='37345.TL'></label>                       
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12 d-flex justify-content-center">
            <form action="odeme">
            <button type="submit" class="btn btn-color-2"><i class="far fa-credit-card"></i> <cf_get_lang dictionary_id='61796.?'></button>
        </form>
        </div>
    </div>
<cfelse>
    <div class="col-md-12">
        <label class="font-weight-bold"><cf_get_lang dictionary_id='35923.Borç ya da alacak kaydınız bulunamadı'>!</label>
    </div>
</cfif>    