<cfset getComponent = createObject('component','V16.project.cfc.get_work')>
<cfset attributes.wid=contentEncryptingandDecodingAES(isEncode:0,content:attributes.wid,accountKey:'wrk')>
<cfset work_detail = getComponent.DET_WORK(id : attributes.wid)>
<cfset work_detail_first = getComponent.GET_WORK_FIRST_DETAIL(id : attributes.wid)>
<cfset work_history = getComponent.GET_WORK_HISTORY(wid:attributes.wid)>
<cfset get_work_cat = getComponent.GET_WORK_CAT(work_cat_id:work_detail.work_cat_id)>
<cfset get_work_currency = getComponent.GET_PROCESS(work_currency_id:work_detail.work_currency_id)>
<cfset getOffer = createObject("component", "V16.objects2.protein.data.tender_data" )>
<cfset Offer = getOffer.GET_OFFER(work_id : attributes.wid)>
<cfif isDefined ('session.ep.time_zone')>
    <cfset simdi = dateadd ('h',session.ep.time_zone,now())>
<cfelseif isDefined ('session.pp.time_zone')>
    <cfset simdi = dateadd ('h',session.pp.time_zone,now())>
<cfelse>
    <cfset simdi = now()>
</cfif>
<cfset fark3 = datediff('n',len(work_detail.target_start) ? work_detail.target_start : now(),len(work_detail.terminate_date) ? work_detail.terminate_date : work_detail.target_finish)>
<cfset toplam = fark3>
<cfset fark6 = datediff('n',(len(work_detail.target_start) ? work_detail.target_start : now()),simdi)>
<cfset fark = fark6>
<cfif toplam neq 0>
    <cfset work_cent = Round (evaluate( (fark / toplam) * 100))>
<cfelse>
    <cfset work_cent = Round (evaluate( (fark) * 100))>
</cfif>
<cfif work_cent gt 100>
    <cfset work_cent = 100>
<cfelseif work_cent lte 0>
    <cfset work_cent = 100>
</cfif>
<cfif session.pp.userid eq work_detail.record_par>
    <div class="row">
        <div class="col-md-12">
            <cfsavecontent variable="title"><cf_get_lang dictionary_id='38252.Update Task'></cfsavecontent>
            <a href="javascript://" onclick="openBoxDraggable('<cfoutput>widgetloader?widget_load=updWork&isbox=1&work_id=#attributes.wid#&title=#title#</cfoutput>&style=maxi')" class="none-decoration">
                <i class="fas fa-pencil-alt float-right"></i>
            </a>
        </div>
    </div>
</cfif>
<cfoutput query="work_detail">
    <div class="row">
        <div class="col-md-6">
            <div class="row mb-4">
                <div class="col-md-12">
                    <div class="font-weight-bold">#URLDecode(work_head)#</div>
                    #work_detail_first.work_detail#
                </div>
            </div>
            <div class="row">
                <div class="col-md-12 flow-list">
                    <ul>
                        <li class="li-img">                            
                            <cfif len(company_partner_id) or len(update_par)>
                                <cfset GET_EMP_LIST_ = getComponent.PARTNER_PHOTO(partner_id : iif(len(company_partner_id),company_partner_id,update_par))>
                            <cfelseif len(update_author)>                                
                                <cfset GET_EMP_LIST_ = getComponent.GET_EMP_LIST(int_emp_list : update_author)>
                            </cfif>
                            <cfif len(GET_EMP_LIST_.photo)>
                                <a title="#GET_EMP_LIST_.NAME# #GET_EMP_LIST_.SURNAME#"><svg height="50" width="50" class="rounded-circle"><image height="50px" width="50px" href='../documents/hr/#GET_EMP_LIST_.PHOTO#' /></svg></a>
                            <cfelse>                            
                                <a title="#GET_EMP_LIST_.NAME# #GET_EMP_LIST_.SURNAME#" class="rounded-circle color-#Left(GET_EMP_LIST_.NAME, 1)#" style="font-size:larger;display:flex;justify-content: center;align-items: center;width:50px;height:50px;">
                                    #Left(GET_EMP_LIST_.NAME, 1)##Left(GET_EMP_LIST_.SURNAME, 1)#
                                </a>
                            </cfif>
                        </li>
                        <li class="li-icon">
                            <i class="fa fa-angle-right"></i>
                        </li>
                        <li class="li-img">                            
                            <cfif len(project_emp_id)>
                                <cfset GET_EMP_LIST_ = getComponent.GET_EMP_LIST(int_emp_list : project_emp_id)>
                            <cfelseif len(outsrc_partner_id)>
                                <cfset GET_EMP_LIST_ = getComponent.PARTNER_PHOTO(partner_id : outsrc_partner_id)>
                            </cfif>
                            <cfif len(GET_EMP_LIST_.photo)>
                            <a title="#GET_EMP_LIST_.NAME# #GET_EMP_LIST_.SURNAME#"><svg height="50" width="50" class="rounded-circle"><image height="50px" width="50px" href='../documents/hr/#GET_EMP_LIST_.PHOTO#' /></svg></a>
                            <cfelse>                            
                                <a title="#GET_EMP_LIST_.NAME# #GET_EMP_LIST_.SURNAME#" class="rounded-circle color-#Left(GET_EMP_LIST_.NAME, 1)#" style="font-size:larger;display:flex;justify-content: center;align-items: center;width:50px;height:50px;">
                                    #Left(GET_EMP_LIST_.NAME, 1)##Left(GET_EMP_LIST_.SURNAME, 1)#
                                </a>
                            </cfif>                               
                        </li>
                        <!--- <li class="li-txt">
                            <p>Marcus Antonius</p>
                        </li> --->                                               
                    </ul>
                    <div class="span_class">
                        <span class="badge span-color-1"></span>
                        <span class="badge span-color-1"></span>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-6 ">
            <div class="row mb-2 justify-content-center">
                <div class="col-lg-4">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='57486.Kategori'></label>
                </div>
                <div class="col-lg-4">
                    <label>#get_work_cat.work_cat#</label>
                </div>
            </div>

            <div class="row  mb-2 justify-content-center">
                <div class="col-lg-4">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='57482.Aşama'></label>
                </div>
                <div class="col-lg-4">
                    <label>#get_work_currency.stage#</label>
                </div>
            </div>

            <div class="row  mb-2 justify-content-center">
                <div class="col-lg-4">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='58467.Başlama'></label>
                </div>
                <div class="col-lg-4 pr-0">
                    <label>
                        <cfif len(target_start)>
                            <cfset sdate=dateAdd("h",session_base.time_zone,TARGET_START)>
                            #dateformat(sdate,dateformat_style)# #timeformat(sdate,timeformat_style)#
                        </cfif>
                </label>
                </div>
            </div>

            <div class="row mb-2 justify-content-center">
                <div class="col-lg-4">
                    <label class="font-weight-bold"> <cf_get_lang dictionary_id='60609.Termin Tarihi'></label>
                </div>
                <div class="col-lg-4 pr-0">
                    <label>
                         <cfif len(terminate_date)>
                            <cfset fdate_plan=dateAdd("h",session_base.time_zone,terminate_date)>
                        <cfelse>
                            <cfset fdate_plan=''>
                        </cfif>
                        <cfif isdefined('fdate_plan') and len(fdate_plan)>
                            #dateformat(fdate_plan,dateformat_style)# #timeformat(fdate_plan,timeformat_style)#
                        </cfif>
                    </label>
                </div>
            </div>

            <div class="row mb-2 justify-content-end">
                <div class="col-lg-4">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='31031.Kalan Zaman'></label>
                </div>
                <div class="col-lg-4 my-1">
                    <div class="progress">
                        <div class="progress-bar  bg-color-1"  style="width:<cfoutput>#work_cent#</cfoutput>%"  role="progressbar"
                            aria-valuenow="#work_cent#" aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                </div>
                <div class="col-lg-2 pr-0">
                    <label><cfset days=abs(datediff("d",terminate_date,target_start))>#days+1# <cf_get_lang dictionary_id='57490.gün'></label>
                </div>
            </div>

            <div class="row mb-2 justify-content-end">
                <div class="col-lg-4">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='38307.Tamamlanma'></label>
                </div>
                <div class="col-lg-4 my-1">
                    <div class="progress">
                        <div class="progress-bar bg-color-4" style="width:<cfoutput>#(work_history.to_complete)#</cfoutput>%" role="progressbar"
                            aria-valuenow="#work_history.to_complete#" aria-valuemin="0" aria-valuemax="100">
                        </div>                                    
                    </div>
                </div>
                <div class="col-lg-2">
                    <label> <cfif len(work_history.to_complete) and work_history.to_complete neq 0>#(work_history.to_complete)#%<cfelse>%0 </cfif></label>
                </div>
            </div>

            <div class="row mb-2 justify-content-center">
                <div class="col-lg-4 pr-0">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='32245.Zaman Harcaması'></label>
                </div>
                <div class="col-lg-4 pr-0">
                    <label>
                        <cfif len(work_detail.harcanan_dakika)>
                            <cfset harcanan_ = work_detail.HARCANAN_DAKIKA>
                            <cfset liste=harcanan_/60>
                            <cfset saat=listfirst(liste,'.')>
                            <cfset dak=harcanan_-saat*60>
                            <label>#saat# saat #dak# dk</label>
                        <cfelse>
                            <label> 0 saat 0 dk </label>                 	
                        </cfif>
                </label>
                </div>
            </div>
            <div class="row mb-2 justify-content-center">
                <div class="col-lg-4 pr-0">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
                </div>
                <div class="col-lg-4 pr-0">
                    <label><cfif len(RECORD_AUTHOR)>#get_emp_info(RECORD_AUTHOR,0,0)#<cfelseif len(record_par)>#get_par_info(record_par,0,-1,0)#</cfif></label>
                </div>
            </div>
        </div>
    </div>   
</cfoutput>

<script>
    /* 
        İhaleye çıkarılacak olan işler için top menüye şimdilik buradan müdahale edip linklendiriyorum.
        Protein tarafındaki menü geliştirimleri bittiğinde dinamik halde çalışacak burası kaldırılacak.

    */

     $('ol.breadcrumb li a').each(function(){
        var cr_href = $(this).attr("href");
        
        <cfif Offer.recordcount gt 0>
            if( cr_href.includes("tenderDetail") ){
                $(this).attr({ "href" : "#", "onclick" : "openBoxDraggable('widgetloader?widget_load=workToTender&isbox=1&offer_id=<cfoutput>#offer.OFFER_ID#</cfoutput>&work_id=<cfoutput>#attributes.wid#</cfoutput>&title=<cfoutput>#getLang('','',61855)#</cfoutput>:<cfoutput>#offer.OFFER_ID#</cfoutput>&style=maxi')" })
            }
            if( cr_href.includes("#ihale")){
                $(this).remove();
            }
        <cfelse>
            <cfif work_detail.COMPANY_ID eq session.pp.company_id and IsDefined("attributes.stock_id") and len(attributes.stock_id)>
                if( cr_href.includes("#ihale") ){
                    $(this).attr({ "onclick" : "openBoxDraggable('widgetloader?widget_load=workToTender&isbox=1&stock_id=<cfoutput>#attributes.stock_id#</cfoutput>&work_id=<cfoutput>#attributes.wid#</cfoutput>&title=<cfoutput>#getLang('','',32010)#</cfoutput>&x_content_id=<cfoutput>#attributes.x_content_id#</cfoutput>&style=maxi')" })
                }
            </cfif>
            if( cr_href.includes("tenderDetail")){
                $(this).remove();
            }
        </cfif>
    });


</script>