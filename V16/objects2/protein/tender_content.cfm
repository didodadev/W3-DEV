<cfoutput query="get_offer" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">  
    <cfset get_finally_coming_offers_details = getComponent.GET_OFFER(offer_id : get_offer.offer_id, is_offer_id : 1)>
    <div class="col-lg-12 boxRow" style="margin:1% 0 !important">
        <div class="row">
            <div class="col-lg-12">
                <!--- <div class="span-class float-left mb-2">
                    <span class="badge span-color-1">##MODUL</span>
                    <span class="badge span-color-1">##WORKFUSE</span>
                </div> --->
                <div class="button-class float-right">
                <div class="form-row">
                    <!--- kendi oluşturduğum teklif ise anlaşma sağla butonu gözükür --->
                    <!--- eğer bu teklif ile anlaşma sağlanmışsa anlaşma sağlama butonları gözükmez.--->
                    <cfif not len(get_offer.accepted_offer_id) and not listfind( valuelist(get_finally_coming_offers_details.OFFER_ID), get_offer.accepted_offer_id ) > 
                        <cfif ( company_id neq session.pp.company_id ) or ( partner_id neq session.pp.userid )>
                            <a href="##" onclick="openBoxDraggable('widgetloader?widget_load=offerToTender&isbox=1&for_offer_id=#offer_id#&work_id=#work_id#&title=#getLang('','',32016)#&style=maxi')" class="btn ml-3 btn-color-5"><i class="fas fa-money-bill-wave"></i> <cf_get_lang dictionary_id='32016.Submit Offer'></a>                            
                        </cfif>
                    </cfif>
                    <a href="#site_language_path#/tenderDetail?offer_id=#offer_id#" class="btn btn-color-7 ml-3"><i class="fas fa-cube"></i> <cf_get_lang dictionary_id='64273.İş Detayı'></a>
                    <a href="#site_language_path#/taskdetail?wid=#contentEncryptingandDecodingAES(isEncode:1,content:work_id,accountKey:"wrk")#" class="btn btn-color-6 ml-3"><i class="fas fa-cube"></i> <cf_get_lang dictionary_id='49733.İş Detayı'></a>
                    </div>      
                </div>
            </div>
        </div>        
        <div class="row mt-lg-4">
            <div class="col-lg-5">
                <div class="mycontent-left mr-5">
                    <cfif len(work_id)>
                        <p class="font-weight-bold"><cf_get_lang dictionary_id='38594.İş ID'>:#work_id#</p>
                    </cfif>
                    <!--- <a href="#site_language_path#/tenderDetail?offer_id=#offer_id#" class="none-decoration" style="font-size:1.25rem;font-weight:bold">#offer_head#</h5> --->
                    <p>#left(offer_detail,200)#
                        <a href="#site_language_path#/tenderDetail?offer_id=#offer_id#" class="none-decoration"><small>><cf_get_lang dictionary_id='62026.Devamını Oku'></small></a>
                    </p>
                    <div class="row">
                        <div class="col-lg-1 m-auto">
                            <cfif len(PHOTO)>
                                <svg height="50" width="50" class="rounded-circle">
                                    <image href="/documents/member/#PHOTO#" height="50px" width="50px" />
                                </svg>
                            <cfelse>
                                <img src="/images/no-image.png" height="50px" width="50px">
                            </cfif>
                        </div>
                        <div class="col-lg-10 m-auto">
                            <p class="font-weight-bold mb-0"><cf_get_lang dictionary_id='56406.İşveren'> <label class="text-color-3">#CUSTOMER_VALUE#</label></p>
                            <p class="mb-0">#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME# / #NICKNAME#</p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-3">
                <div class="mycontent-left">
                    <div class="row">
                        <div class="col-md-6">
                            <label class="font-weight-bold"><cf_get_lang dictionary_id='31639.Yayın Tarihi'></label>
                        </div>
                        <div class="col-md-6">
                            <label for="date">#dateformat(OFFER_DATE,"dd/mm/yyy")#</label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <label class="font-weight-bold"><cf_get_lang dictionary_id='57645.Teslim Tarihi'></label>
                        </div>
                        <div class="col-md-6">
                            <label for="date">#dateformat(deliverdate,"dd/mm/yyyy")#</label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <label class="font-weight-bold"><cf_get_lang dictionary_id='38215.Öngörülen Süre'></label>
                        </div>
                        <div class="col-md-6">  
                        <cfif len(estimated_time)>
                            <cfset est_time_h = estimated_time / 60>                       
                            <cfset est_time_m = estimated_time % 60>
                        <cfelse>
                            <cfset est_time_h = 0>
                            <cfset est_time_m = 0>
                        </cfif>
                            <label for="date">#floor(est_time_h)# saat #est_time_m# dk</label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <label class="font-weight-bold"><cf_get_lang dictionary_id='38308.Öngörülen Bütçe'></label>
                        </div>
                        <div class="col-md-6">
                            <label for="date">#TLFormat(other_money_value)# #other_money#</label>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-2">
                <div class="mycontent-left">
                    <div class="row mx-auto mb-4">
                        <div class="col-2 col-sm-2 col-md-2 col-lg-3">
                            <label class="font-weight-bold"><cf_get_lang dictionary_id='57486.Kategori'></label>
                            <span class="badge pl-3 pr-3 py-2 btn-color-4">#work_cat#</span>
                        </div>
                    </div>
                    <div class="row mx-auto">
                        <div class="col-sm-12 col-md-12 col-lg-12">
                            <label class="col-lg-12 font-weight-bold pl-0"><cf_get_lang dictionary_id='57482.Aşama'></label>
                            <label class="col-lg-12 pl-0">
                                <cfif len(offer_stage)><cf_workcube_process type="color-status" process_stage="#offer_stage#" fuseaction="purchase.list_offer" fusepath="purchase.list_offer"></cfif>
                            </label>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-2">
                <div class="row">
                    <div class="col-md-12 d-flex">               
                        <cfset get_coming_offer = getComponent.get_coming_offer(offer_id : get_offer.offer_id)>
                        <svg height="100" width="150">                            
                            <circle  cx="65%" cy="50%" r="40%" fill="##f8f7f1" />
                            <text x="66%" y="50%" text-anchor="middle" stroke="black" dy=".3em"><cfif len(get_coming_offer.recordcount)>#get_coming_offer.recordcount# <cf_get_lang dictionary_id='57545.Teklif'> <cfelse> 0 <cf_get_lang dictionary_id='57545.teklif'></cfif> </text>
                        </svg>                             
                    </div>
                </div>            
                <div class="col-lg-12">
                    <div class="row">
                        <div class="col-6 col-sm-3 col-md-2 col-lg-10 col-xl-6">
                            <i class="fas fa-arrow-circle-up icon-color-3"></i> <label class="small"> <cf_get_lang dictionary_id='46859.En Yüksek'></label>
                        </div>
                        <div class="col-6 col-sm-3 col-md-2 col-lg-10 col-xl-6">
                            <label class="font-weight-bold small">#len(get_coming_offer.OM_MAX) ? TLFormat(get_coming_offer.OM_MAX) : TLFormat(0)# #get_coming_offer.OTHER_MONEY#</label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-6 col-sm-3 col-md-2 col-lg-10 col-xl-6">
                            <i class="fas fa-arrow-circle-down icon-color-2"></i> <label class="small"> <cf_get_lang dictionary_id='46860.En Düşük'></label>
                        </div>
                        <div class="col-6 col-sm-3 col-md-2 col-lg-10 col-xl-6">
                            <label class="font-weight-bold small">#len(get_coming_offer.OM_MIN) ? TLFormat(get_coming_offer.OM_MIN) : TLFormat(0)# #get_coming_offer.OTHER_MONEY#</label>
                        </div>
                    </div>                        
                </div>
            </div>
        </div>
    </div>
</cfoutput>

<cfif isDefined("attributes.totalrecords") and attributes.totalrecords gt attributes.maxrows>
    <table class="table table-light">
        <tr> 
            <td>
                <cf_paging page="#attributes.page#" 
                    maxrows="#attributes.maxrows#"
                    totalrecords="#attributes.totalrecords#"
                    startrow="#attributes.startrow#"
                    adres="#url_str#"> 
            </td>
        </tr>
    </table>
</cfif>