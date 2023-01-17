<cfset attributes.subscription_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.subscription_id,accountKey:'wrk')>
<cfset subscription_contract = createObject("component","V16.sales.cfc.subscription_contract")>
<cfset get_subscription = subscription_contract.GET_SUBSCRIPTION(subscription_id : attributes.subscription_id)>
<cfset get_partner = subscription_contract.GET_PARTNER(partner_list:get_subscription.partner_id)>
<cfif len(get_subscription.consumer_id)>
    <cfset get_consumer = subscription_contract.GET_CONSUMER(consumer_list:get_subscription.consumer_id)>
</cfif>
<cfoutput query="GET_SUBSCRIPTION">
    <div class="row mb-2">
        <div class="col-md-4">
            <h6 class="mb-1 font-weight-bold text-uppercase"><cf_get_lang dictionary_id='57574.Company'></h6>
            <p>#get_partner.nickname#</p>
        </div>
        <div class="col-md-4">
            <h6 class="mb-1 font-weight-bold text-uppercase"><cf_get_lang dictionary_id='57578.Contact Person'></h6>
            <p>
                <cfif len(consumer_id)>
                    <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium');">#get_consumer.consumer_name#&nbsp;#get_consumer.consumer_surname#</a>
                <cfelseif len(company_id)>
                    <cfif len(partner_id)>
                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#partner_id#','medium');" class="tableyazi">#get_partner.company_partner_name#&nbsp;#get_partner.company_partner_surname#</a>
                    </cfif>
                </cfif>
            </p>
        </div>
        <div class="col-md-4">
            <h6 class="mb-1 font-weight-bold text-uppercase"><cf_get_lang dictionary_id='57486.Category'></h6>
            <p>#subscription_type#</p>
        </div>
    </div>
    <div class="row mb-2">
        <div class="col-md-4">
            <h6 class="mb-1 font-weight-bold text-uppercase"><cf_get_lang dictionary_id='57655.Starting Date'></h6>
            <p>#dateFormat(start_date,'dd/mm/yyyy')#</p>
        </div>
        <div class="col-md-4">
            <h6 class="mb-1 font-weight-bold text-uppercase"><cf_get_lang dictionary_id='61797.?'> - <cf_get_lang dictionary_id='57502.Finish'></h6>
            <p>#dateFormat(finish_date,'dd/mm/yyyy')#</p>
        </div>
        <div class="col-md-4">
            <h6 class="mb-1 font-weight-bold text-uppercase"><cf_get_lang dictionary_id='57482.Stage'></h6>
            <p><span class="badge pl-3 pr-3 py-2 span-color-3">#STAGE#</span></p>
            <!--- <a href="/calls?subscription_id=#attributes.subscription_id#" class="btn btn-color-1"><cf_get_lang dictionary_id='47612.Calls'></a>
            <a href="/Product?production_subscription_id=#attributes.subscription_id#" class="btn btn-color-1">Uygulamamı Genişlet</a> --->
        </div>
    </div>
    <div class="row mb-2">
        <div class="col-md-12">
            <h6 class="mb-1 text-uppercase font-weight-bold"><cf_get_lang dictionary_id='61798.?'></h6>
            <p>
                <cfif len(get_subscription.sales_partner_id)>
                   #get_par_info(get_subscription.sales_partner_id, 0, 0, 0)#
                <cfelseif len(get_subscription.sales_consumer_id)>
                    #get_cons_info(get_subscription.sales_consumer_id, 1, 0)#
                <cfelse>
                        ---
                </cfif>
            </p>
        </div>
    </div>
    <div class="row mb-2">
        <!--- <div class="col-md-8">
            <h6 class="mb-1 text-uppercase font-weight-bold"><cf_get_lang dictionary_id='33110.Modules'></h6>
            <p>Cari,Kasa,Çek-Senet Cari,Kasa,Çek-Senet Cari,Kasa,Çek-SenetCari,Kasa,Çek-Senet Cari,Kasa,Çek-Senet Cari,Kasa,Çek-SenetCari,Kasa,Çek-Senet</p>
        </div> --->
        <div class="col-md-4">
            <h6 class="mb-1 text-uppercase font-weight-bold"><cf_get_lang dictionary_id='57892.Domain'></h6>
            <cfif listLen(PROPERTY16)><cfloop index = "i" item = "domain" list = "#PROPERTY16#" delimiters = ","><p class="mb-1">#domain#</p></cfloop></cfif>
        </div>
    </div>
</cfoutput>