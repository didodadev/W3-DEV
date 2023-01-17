<cfif isDefined("attributes.offer_id") and len(attributes.offer_id)>
    <cfset attributes.id = attributes.offer_id>
<cfelse>
    <cfset attributes.id = attributes.param_2>
</cfif>
<cfset getComponent = createObject('component','V16.objects2.protein.data.tender_data')>
<cfset get_offer_det = getComponent.GET_OFFER(offer_id : attributes.id)>
<cfset get_coming_offer = getComponent.get_coming_offer(offer_id :  attributes.id)>  
<cfset get_coming_offer_for_main = getComponent.get_coming_offer_for_main(offer_id : attributes.id)>
<cfset get_finally_coming_offers = getComponent.get_finally_coming_offers()>
<cfset get_finally_coming_offers_details = getComponent.get_finally_coming_offers_details( get_offer.accepted_offer_id )>
<cfif len(get_offer_det.sales_emp_id)>
    <cfset GET_POSITION_DETAIL = getComponent.GET_POSITION_DETAIL(sales_emp_id_tender : get_offer_det.sales_emp_id)>
</cfif>
<cfset GET_PROCESS = getComponent.GET_PROCESS(work_currency_id : get_offer_det.WORK_CURRENCY_ID)>

<div class="col-lg-12">
    <div class="col-lg-12">
        <div class="col-md-12">
            <!--- <div class="span-class float-left mb-2">
                <span class="badge span-color-1">#MODUL</span>
                <span class="badge span-color-1">#WORKFUSE</span>
            </div> --->
            <div class="button-class float-right">
                <div class="form-row">   
                    <!--- kendi oluşturduğu teklif ise, teklif ver butonu gelmesin --->     
                    <cfif not len(get_offer.accepted_offer_id) and not listfind( valuelist(get_finally_coming_offers_details.OFFER_ID), get_offer.accepted_offer_id ) > 
                        <cfif ( get_offer_det.company_id neq session.pp.company_id ) and ( get_offer_det.partner_id neq session.pp.userid )>
                            <a href="#" onclick="openBoxDraggable('widgetloader?widget_load=offerToTender&isbox=1&for_offer_id=<cfoutput>#attributes.id#</cfoutput>&work_id=<cfoutput>#get_offer_det.work_id#</cfoutput>&title=<cfoutput>#getLang('','',32016)#</cfoutput>&x_content_id=<cfoutput>#attributes.x_content_id#</cfoutput>&style=maxi')" class="btn ml-3 btn-color-5"><i class="fas fa-money-bill-wave"></i> <cf_get_lang dictionary_id='32016.Submit Offer'></a>                     
                        </cfif>
                    </cfif>
                    <cfif len(get_offer_det.work_id)> 
                        <a href="<cfoutput>#site_language_path#/taskdetail?wid=#contentEncryptingandDecodingAES(isEncode:1,content:get_offer_det.work_id,accountKey:"wrk")#</cfoutput>" class="btn btn-color-6 ml-3"><i class="fas fa-cube"></i> <cf_get_lang dictionary_id='49733.İş Detayı'></a>
                    </cfif>               
                </div>      
            </div>
        </div>
    </div>

    <div class="row col-lg-12">
        <div class="col-md-6 tender_det_item" style="border-right: 2px dashed #b7b7b7;">                   
            <div class="tender_det_badge d-flex">
                <div class="tender_det_badge_item">
                    <label><cf_get_lang dictionary_id='57486.Category'></label>
                    <span class="badge btn-color-4"><cfoutput>#get_offer_det.work_cat#</cfoutput></span>
                </div>
                <div class="tender_det_badge_item ml-4">
                    <label><cf_get_lang dictionary_id='57482.Stage'></label>
                    <span class="badge span-color-2"><cfoutput>#GET_PROCESS.STAGE#</cfoutput></span>
                </div>
            </div>
            
            <div class="mt-3 mb-5">
                <div class="col-md-12">
                    <!--- <h5><cfoutput>#get_offer_det.offer_head#</cfoutput></h5> --->
                    <p><cfoutput>#get_offer_det.offer_detail#</cfoutput></p>
                    <a href="<cfoutput>#site_language_path#/taskdetail?wid=#contentEncryptingandDecodingAES(isEncode:1,content:get_offer_det.work_id,accountKey:"wrk")#</cfoutput>" class="font-weight-bold none-decoration-2"><i class="fa fa-chevron-right" style="font-size:12px"></i> <cf_get_lang dictionary_id='61747.?'></a>
                </div>
            </div>
            <div class="table-responsive-sm">
                <table class="table table-borderless">
                    <thead class="text-center">
                        <tr>
                            <th scope="col"><cf_get_lang dictionary_id='57645.Delivery Date'></th>
                            <th scope="col"><cf_get_lang dictionary_id='38215.Estimated Time'></th>
                            <th scope="col"><cf_get_lang dictionary_id='38308.Estimated Budget'></th>
                        </tr>
                    </thead>
                    <tbody class="border-top text-center">
                        <tr>
                            <td scope="row"><cfoutput>#dateformat(get_offer_det.deliverdate,"dd.mm.yyyy")#</cfoutput></td>
                            <cfif len(get_offer_det.estimated_time)>
                                <cfset est_time_h = get_offer_det.estimated_time / 60>                       
                                <cfset est_time_m = get_offer_det.estimated_time % 60>
                            <cfelse>
                                <cfset est_time_h = 0>
                                <cfset est_time_m = 0>
                            </cfif>
                            <td><cfoutput>#floor(est_time_h)# saat #est_time_m# dk</cfoutput></td>
                            <td><cfoutput>#TlFormat(get_offer_det.other_money_value)# #get_offer_det.other_money#</cfoutput></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            
            <div class="table-responsive-sm mb-3">
                <table class="table table-borderless">
                    <thead class="text-center">
                        <tr>
                            <th scope="col"><cf_get_lang dictionary_id='31639.Publishing Date'></th>
                            <th scope="col"><cf_get_lang dictionary_id='38503.Last Offer Date'></th>
                            <th scope="col"></th>                                        
                        </tr>
                    </thead>
                    <tbody class="border-top text-center">
                        <tr>
                            <td scope="row"><cfoutput>#dateformat(get_offer_det.startdate,"dd.mm.yyyy")# #TimeFormat(get_offer_det.startdate,'HH:MM')#</cfoutput></td>
                            <td><cfif len(get_offer_det.offer_finishdate)><cfoutput>#dateformat(get_offer_det.offer_finishdate,"dd.mm.yyyy")# #TimeFormat(get_offer_det.offer_finishdate,'HH:MM')#</cfoutput></cfif></td>
                            <td></td>                                        
                        </tr>
                    </tbody>
                </table>
            </div>                        
            
            <div class="tender_list_item_img_info">
                <div class="tender_list_item_img">
                    <cfif isdefined("get_offer_det.photo") and len(get_offer_det.photo)>
                        <img src="/documents/member/<cfoutput>#get_offer_det.photo#</cfoutput>" height="50px" width="50px">
                    <cfelse>
                        <img src="/images/no-image.png" height="50px" width="50px">
                    </cfif> 
                </div>
                <div class="tender_list_item_info">
                    <p><b><cf_get_lang dictionary_id='56406.Employer'></b></p>
                    <p><cfoutput>#get_offer_det.NICKNAME# / #get_offer_det.COMPANY_PARTNER_NAME# #get_offer_det.COMPANY_PARTNER_SURNAME#</cfoutput></p>                
                    <cfif len(GET_OFFER_DET.ACCEPTED_OFFER_ID)>
                        <p><b>İhaleyi Alan Yüklenici</b></p>
                        <cfset get_offer_accepted_detail = getComponent.GET_OFFER(offer_id : GET_OFFER_DET.ACCEPTED_OFFER_ID, is_offer_id : 1)>
                        <cfoutput>
                        <p>#get_par_info(listdeleteduplicates(get_offer_accepted_detail.offer_to_partner),0,0,0)#</p>
                        </cfoutput>
                    </cfif>
                </div>
            </div>
        
    
        </div>
        <div class="col-md-6 tender_det_item pl-5 pt-4">       
            <div class="row mb-2">
                <div class="col-md-12">
                    <h5 class="float-left"><cf_get_lang dictionary_id='33411.Issued Offers'></h5>
                    <h5 class="float-right"><cfif len(get_coming_offer.recordcount)><cfoutput>#get_coming_offer.recordcount# Teklif</cfoutput> <cfelse> 0 Teklif</cfif> </h5>
                </div>
            </div>                   
            <cfoutput query="get_finally_coming_offers">
                <cfset get_finally_coming_offers_details = getComponent.GET_OFFER(offer_id : offer_id, is_offer_id : 1)>
                <div class="border-bottom mb-3">
                    <div class="row">
                        <div class="col-md-12">
                            <h6 class="font-weight-bold">#get_par_info(listdeleteduplicates(get_finally_coming_offers_details.offer_to_partner),0,1,0,1)# / #get_finally_coming_offers_details.OFFER_NUMBER#</h6>
                            <p class="mb-1">#get_finally_coming_offers_details.OFFER_DETAIL#</p>
                        </div>
                    </div>
                    <div class="row mb-4">
                        <div class="col-md-5">
                            <i class="fas fa-calendar-check-o icon-color-2"></i>
                            <span><cf_get_lang dictionary_id='57231.Delivery'>: #dateformat(get_finally_coming_offers_details.deliverdate,"dd.mm.yyyy")#</span>
                        </div>
                        <div class="col-md-5">
                            <i class="fa-ticket icon-color-2"></i>
                            <span><cf_get_lang dictionary_id='58084.Price'>: #TLFormat(get_finally_coming_offers_details.OTHER_MONEY_VALUE)# #get_finally_coming_offers_details.OTHER_MONEY#</span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">                                   
                            <button type="button" class="btn mr-1 mb-2 custom-btn" onclick="openBoxDraggable('widgetloader?widget_load=AskQuestionForTender&isbox=1&title=#getLang('','',46085)#&offer_id=#attributes.id#','','ui-draggable-box-large')"><i class="fas fa-question icon-color-1"></i> <cf_get_lang dictionary_id='46085.Ask Question'></button>

                            <!--- kendi oluşturduğum teklif ise anlaşma sağla butonu gözükür --->
                            <!--- eğer bu teklif ile anlaşma sağlanmışsa anlaşma sağlama butonları gözükmez.--->
                            <cfif not len(GET_OFFER_DET.accepted_offer_id) and not listfind( valuelist(get_finally_coming_offers_details.OFFER_ID), GET_OFFER_DET.accepted_offer_id ) >
                                <cfif get_offer_det.company_id eq session.pp.company_id and get_offer_det.partner_id eq session.pp.userid>
                                    <button type="button" class="btn mb-2 custom-btn" onclick="openBoxDraggable('widgetloader?widget_load=acceptDeal&isbox=1&style=maxi&accepted_offer_id=#offer_id#&offer_id=#get_offer_det.offer_id#')"><i class="far fa-handshake icon-color-1"></i> <cf_get_lang dictionary_id='61751.?'></button>                                     
                                </cfif>
                            </cfif>
                            <!--- hangi teklif ile anlaşma sağlandıysa o belli olur --->
                            <cfif GET_OFFER_DET.accepted_offer_id eq get_finally_coming_offers_details.OFFER_ID>
                                <button type="button" class="btn mb-2 custom-btn color-b"><i class="far fa-check-circle-o icon-color-1"></i> <cf_get_lang dictionary_id='64272.Bu Teklif ile Anlaşma Sağlanmıştır'></button>
                            </cfif>
                        </div>
                    </div>
                </div>
            </cfoutput>  
        </div>
    </div>
</div>