<cfset getComponent = createObject('component','V16.callcenter.cfc.call_center')>
<cfset get_service_detail = getComponent.GET_SERVICE_DETAIL(service_id: attributes.id)>
<cfset get_related_subscription = len(get_service_detail.subscription_id) ? getComponent.GET_RELATED_SUBSCRIPTION(subscription_id: get_service_detail.subscription_id) : "">
<h5 class="text-color-2"><cf_get_lang dictionary_id='58599.Dikkat'>!</h5>
<cfif len(get_service_detail.subscription_id)>
    <cfset subscription_contract = createObject("component","V16.sales.cfc.subscription_contract")>
    <cfset get_subscription = subscription_contract.GET_SUBSCRIPTION(subscription_id : get_service_detail.subscription_id)>
    <p class="mb-0">
        <cfif len(get_subscription.finish_date)>
            <cf_get_lang dictionary_id='61797.?'> <cf_get_lang dictionary_id='57502.Finish'>: <cfoutput>#dateFormat(get_subscription.finish_date,'dd/mm/yyyy')#</cfoutput>
        </cfif>
        <cfif (len(get_subscription.finish_date) and dateformat(get_subscription.finish_date,'yyyy-mm-dd') lt dateformat(now(),'yyyy-mm-dd')) or not len(get_subscription.finish_date) >
            <cf_get_lang dictionary_id='64090.Bu Abone için LYKP desteği yok!'>
        </cfif>
    </p>
    <hr>
    <div class="row mt-4">
        <div class="col-md-3">
            <img src="/src/assets/icons/catalyst-icon-svg/profesyonel-danismanlik.svg" height="40px" width="40px" >
        </div>                        
        <div class="col-md-9">
            <a href="communitySupport?id=<cfoutput>#get_service_detail.subscription_id#</cfoutput>"><p><cf_get_lang dictionary_id='64039.Danışman Desteği Al'></p></a>
        </div>
    </div>
    <hr>                
    <div class="row mt-4">
        <div class="col-md-3">
            <img src="/src/assets/icons/catalyst-icon-svg/codefactory-logo.svg" height="40px" width="40px" >
        </div>                        
        <div class="col-md-9">
            <a href="codeFactorySupport?id=<cfoutput>#get_service_detail.subscription_id#</cfoutput>"><p><cf_get_lang dictionary_id='64040.Kod Hizmeti Al'></p></a>
        </div>
    </div>
    <hr>
    <div class="row mt-4">
        <div class="col-md-3">
            <img src="/src/assets/icons/catalyst-icon-svg/google-meet.svg" height="40px" width="40px" >
        </div>                        
        <div class="col-md-9">
            <a href="onlineMeetSupport?id=<cfoutput>#get_service_detail.subscription_id#</cfoutput>"><p><cf_get_lang dictionary_id='64041.Online Meet Hizmeti Al'></p></a>
        </div>
    </div>
    <hr> 
</cfif>
  