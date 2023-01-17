<cfparam name="opp_id" default="1">
<cfset attributes.id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.id,accountKey:'wrk')>
<cfset getComponent = createObject('component','V16.callcenter.cfc.call_center')>
<cfset get_project_detail = createObject('component','V16.project.cfc.get_project_detail')>
<cfset get_service_detail = getComponent.GET_SERVICE_DETAIL(service_id: attributes.id)>
<cfset get_related_subscription = len(get_service_detail.subscription_id) ? getComponent.GET_RELATED_SUBSCRIPTION(subscription_id: get_service_detail.subscription_id) : "">
<cfset get_service_appcat = getComponent.GET_SERVICE_APPCAT()>
<cfset get_subscriptions = getComponent.GET_SUBSCRIPTION()>
<cfset get_priority = getComponent.get_priority()>
<cfset get_process_types = getComponent.get_process_types(faction:'call.list_service')>
<cfset company_cmp = createObject("component","V16.member.cfc.member_company")> 
<cfset GET_PARTNER = company_cmp.GET_PARTS_EMPS(cpid: session.pp.COMPANY_ID,partner_status:1)>

<form name="upd_service" id="upd_service">
    <cfoutput query="get_service_detail">
        <div class="row">
            <div class="col-lg-12 col-xl-7">
                <input type="hidden" name="id" id="id" value="#attributes.id#">
                <h4 class="mb-4">#get_service_detail.service_no# / #get_service_detail.service_head#</h4>                
                <p style="word-wrap:break-word">#get_service_detail.service_detail#</p>       
                <div>
                    <div class="col-lg-6">
                        <div class="abone-id">
                            <p class="font-weight-bold mb-0"><cf_get_lang dictionary_id='61766.?'></p>
                            <cfif isdefined("get_related_subscription.recordcount") and get_related_subscription.recordcount>
                                <p class="mb-0">#get_related_subscription.subscription_no# - #get_related_subscription.subscription_head#</p>
                                <div class="span-class">
                                    <span class="badge badge-info mb-4 btn-color-3">LYKP</span>
                                    <span class="badge badge-secondary mb-4 btn-color-4">WORKDESK SILVER</span>
                                </div>
                            </cfif>                        
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <p class="font-weight-bold mb-0"><cf_get_lang dictionary_id='57416.Project'></p>
                        <cfif len(get_service_detail.project_id)><p>#get_project_name(get_service_detail.project_id)#</p></cfif>
                    </div>
                </div>
                <div>
                    <div class="col-lg-6 ">
                        <div class="cagri-sahibi">
                            <p class="font-weight-bold mb-0"><cf_get_lang dictionary_id='61767.?'></p>
                            <p class="mb-0">#get_service_detail.applicator_name#</p>
                            <a href="mailto:#get_service_detail.APPLICATOR_EMAIL#" class="none-decoration"><i class="far fa-envelope mr-2"></i></a>
                            <div class="span-class">
                                <span class="badge mb-4 span-color-1">#get_service_detail.fuseaction#</span>
                            </div>
                        </div>
                    </div>
                    <cfif len(get_service_detail.NOTIFY_EMPLOYEE_ID)>
                        <cfset employee_photo = get_project_detail.EMPLOYEE_PHOTO(employee_id:get_service_detail.NOTIFY_EMPLOYEE_ID)>
                        <cfif len(employee_photo.photo)>
                            <cfset emp_photo ="../../documents/hr/#employee_photo.PHOTO#">
                        <cfelseif employee_photo.sex eq 1>
                            <cfset emp_photo ="images/male.jpg">
                        <cfelse>
                            <cfset emp_photo ="images/female.jpg">
                        </cfif>
                        <div class="col-lg-6">
                            <div class="row">
                                <div class="col-lg-4 col-xl-3">
                                    <img src='#emp_photo#' class="rounded-circle float-left mr-4" height="50px" width="50px" />
                                </div>
                                <div class="col-lg-9 col-xl-9">
                                    <p class="font-weight-bold mb-0"><cf_get_lang dictionary_id='39468.Notifier'></p>
                                    <p class="mb-0">#get_emp_info(get_service_detail.notify_employee_id,0,0)#</p>
                                    <a href="community?id=#get_service_detail.NOTIFY_EMPLOYEE_ID#" class="none-decoration"><i class="far fa-user mr-2"></i></a>
                                    <a href="mailto:#employee_photo.employee_email#" class="none-decoration" title="#employee_photo.employee_email#"><i class="far fa-envelope mr-2"></i></a>
                                    <a href="javascript://" class="none-decoration"><i class="far fa-comment-dots mr-2"></i></a>
                                    <a href="projectCalendar?id=#get_service_detail.NOTIFY_EMPLOYEE_ID#" class="none-decoration"><i class="far fa-calendar-alt mr-2"></i></a>                                         
                                </div>
                            </div>
                        </div>
                    <cfelseif len(get_service_detail.NOTIFY_PARTNER_ID)>
                        <cfset employee_photo = get_project_detail.PARTNER_PHOTO(partner_id:get_service_detail.NOTIFY_PARTNER_ID)>
                        <cfif len(employee_photo.photo)>
                            <cfset emp_photo ="../../documents/member/#employee_photo.PHOTO#">
                        <cfelseif employee_photo.sex eq 1>
                            <cfset emp_photo ="images/male.jpg">
                        <cfelse>
                            <cfset emp_photo ="images/female.jpg">
                        </cfif>
                        <div class="col-lg-6">
                            <div class="row">
                                <div class="col-lg-4 col-xl-3">
                                    <img src='#emp_photo#' class="rounded-circle float-left mr-4" height="50px" width="50px" />
                                </div>
                                <div class="col-lg-9 col-xl-9">
                                    <p class="font-weight-bold mb-0"><cf_get_lang dictionary_id='39468.Notifier'></p>
                                    <p class="mb-0">#get_par_info(get_service_detail.notify_partner_id,0,-1,0)#</p>
                                    <a href="mailto:#employee_photo.COMPANY_PARTNER_EMAIL#" class="none-decoration"><i class="far fa-envelope mr-2"></i></a>                               
                                </div>
                            </div>
                        </div>
                    <cfelseif len(get_service_detail.NOTIFY_CONSUMER_ID)>
                        <cfset employee_photo = get_project_detail.CONSUMER_PHOTO(consumer_id:get_service_detail.NOTIFY_CONSUMER_ID)>
                        <cfif len(employee_photo.picture)>
                            <cfset emp_photo ="../../documents/member/consumer/#employee_photo.picture#">
                        <cfelseif employee_photo.sex eq 1>
                            <cfset emp_photo ="images/male.jpg">
                        <cfelse>
                            <cfset emp_photo ="images/female.jpg">
                        </cfif>
                        <div class="col-lg-6">
                            <div class="row">
                                <div class="col-lg-4 col-xl-3">
                                    <img src='#emp_photo#' class="rounded-circle float-left mr-4" height="50px" width="50px" />
                                </div>
                                <div class="col-lg-9 col-xl-9">
                                    <p class="font-weight-bold mb-0"><cf_get_lang dictionary_id='39468.Notifier'></p>
                                    <p class="mb-0">#get_cons_info(get_service_detail.notify_consumer_id,0,0)#</p>
                                    <a href="mailto:#employee_photo.COMPANY_PARTNER_EMAIL#" class="none-decoration"><i class="far fa-envelope mr-2"></i></a>                               
                                </div>
                            </div>
                        </div>
                    </cfif>
                </div>
            </div>
            <div class="col-lg-12 col-xl-5 mt-5">
                <div class="form-row mb-3">
                    <div class="col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='57493.Active'></div>
                    <div class="col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">
                        <label class="checkbox-container font-weight-bold">
                            <input type="checkbox" name="status" id="status" value="1" <cfif get_service_detail.service_active eq 1>checked</cfif>>
                            <span class="checkmark"></span>
                        </label>    
                    </div>
                </div>
                <div class="form-row mb-3">
                    <div class="col-12 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='57486.Category'></div>
                    <div class="col-12 col-sm-6 col-md-6 col-lg-6 col-xl-8">
                        <select class="form-control form-control-sm" name="appcat_id" id="appcat_id">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfloop query="get_service_appcat">
                                <option value="#get_service_appcat.servicecat_id#" <cfif get_service_detail.servicecat_id EQ servicecat_id>selected</cfif>>#get_service_appcat.servicecat#</option>
                            </cfloop>
                        </select>	
                    </div>
                </div>
                <div class="form-row mb-3">
                    <div class="col-12 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='57485.Öncelik'>*</div>
                    <div class="col-12 col-sm-6 col-md-6 col-lg-6 col-xl-8">
                        <select class="form-control form-control-sm" id="priority_id" name="priority_id" required>
                            <option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
                            <cfloop query="get_priority">
                                <option value="#priority_id#" <cfif get_service_detail.priority_id EQ priority_id>selected</cfif>>#priority#</option>
                            </cfloop>
                        </select>
                    </div>
                </div>
                <div class="form-row mb-3">
                    <div class="col-12 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='57482.Stage'></div>
                    <div class="col-12 col-sm-6 col-md-6 col-lg-6 col-xl-8">
                        <select class="form-control form-control-sm" id="process_stage" name="process_stage">
                            <option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
                            <cfloop query="get_process_types">
                                <option value="#process_row_id#" <cfif get_service_detail.service_status_id eq process_row_id>selected</cfif>>#stage#</option>
                            </cfloop>
                        </select>
                    </div>
                </div>
                <div class="form-row mb-3">
                    <div class="col-12 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='55116.Application'></div>
                    <div class="col-8 col-sm-4 col-md-4 col-lg-4 col-xl-6 ">
                        <input type="date" class="form-control form-control-sm" name="apply_date" id="apply_date" value="#dateformat(get_service_detail.apply_date,"yyyy-MM-dd")#">
                    </div>
                    <div class="col-4 col-sm-2 col-md-2 col-lg-2 col-xl-2">
                        <input type="text" class="form-control form-control-sm" name="apply_hour" value='<cfif len(get_service_detail.apply_date)>#datepart("H",date_add("H",session_base.time_zone,get_service_detail.apply_date))#:#datepart("N",get_service_detail.apply_date)#</cfif>' placeholder="00:00" >
                    </div>                   
                </div>
                <div class="form-row mb-3">
                    <div class="col-12 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='56261.Acceptance'></div>
                    <div class="col-8 col-sm-4 col-md-4 col-lg-4 col-xl-6">
                        <input type="date" class="form-control form-control-sm" name="start_date1" id="start_date1" value="#dateformat(get_service_detail.start_date,"yyyy-MM-dd")#">
                    </div>
                    <div class="col-4 col-sm-2 col-md-2 col-lg-2 col-xl-2">
                        <input type="text" class="form-control form-control-sm" name="start_hour" value="<cfif len(get_service_detail.start_date)>#datepart("H",date_add("H",session_base.time_zone,get_service_detail.start_date))#:#datepart("N",get_service_detail.start_date)#</cfif>" placeholder="00:00" >
                    </div>                   
                </div>
                <div class="form-row mb-3">
                    <div class="col-12 col-sm-4 col-md-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='57502.Finish'></div>
                    <div class="col-8 col-sm-4 col-md-4 col-lg-4 col-xl-6">
                        <input type="date" class="form-control form-control-sm" name="finish_date1" id="finish_date1" value="#dateformat(get_service_detail.finish_date,"yyyy-MM-dd")#">
                    </div>
                    <div class="col-4 col-sm-2 col-md-2 col-lg-2 col-xl-2 ">
                        <input type="text" class="form-control form-control-sm" name="finish_hour" placeholder="00:00" value="<cfif len(get_service_detail.finish_date)>#datepart("H",date_add("H",session_base.time_zone,get_service_detail.finish_date))#:#datepart("N",get_service_detail.finish_date)#</cfif>">
                    </div>                   
                </div>
                <div class="form-row mb-3">
                    <div class="col-12 col-md-4 col-sm-4 col-lg-4 col-xl-4 font-weight-bold"><cf_get_lang dictionary_id='57544.Responsible'></div>
                    <div class="col-12 col-md-6 col-sm-6 col-lg-6 col-xl-8">    
                        <cfset resp_id = "">
                        <cfif len(get_service_detail.resp_emp_id)>
                            <cfset resp_id = get_service_detail.resp_emp_id>
                        <cfelseif len(get_service_detail.resp_par_id)>
                            <cfset resp_id =get_service_detail.resp_par_id>
                        </cfif>                     
                        <select class="form-control" id="resp_id" name="resp_id">
                            <option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
                            <cfloop query="GET_PARTNER">
                                <option value="#ID_CE#_#TYPE#" <cfif resp_id eq ID_CE>selected</cfif>>#name_surname#</option>
                            </cfloop>
                        </select>
                    </div>
                </div>
                </div>    
            <div class="col-12 col-md-12">
                <cf_workcube_buttons is_upd="1" is_delete="0" data_action="/V16/callcenter/cfc/call_center:upd_service" next_page="#site_language_path#/callDet?id=">           
            </div> 
        </div>  
    </cfoutput>
</form>

