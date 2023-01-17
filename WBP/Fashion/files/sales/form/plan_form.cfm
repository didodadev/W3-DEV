    <input type="hidden" name="referel_page" value="<cfoutput>#referel_page#</cfoutput>">
    <div class="row">
        <div class="col col-12 uniqueRow">
            <div class="row formContent">
                <div class="row" type="row">
                    <!--- col 1 --->
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="10" sort="true">
                        <div class="form-group" id="item-stretching_test_id">
                            <label class="col col-4 col-xs-12"><cfoutput>#title#</cfoutput></label>
                            <div class="col col-8 col-xs-12">
                                <div class="">
                                    <input type="text" name="plan_no" id="plan_no" value="<cfoutput>#attributes.plan_id#</cfoutput>" disabled="disabled">
                                    <input type="hidden" name="plan_id" id="plan_id" value="<cfoutput>#attributes.plan_id#</cfoutput>">
                                    <input type="hidden" name="plan_type" id="plan_type" value="<cfoutput>#query_product_plan.plan_type#</cfoutput>">
                                    <input type="hidden" name="work_id" id="work_id" value="<cfoutput>#query_product_plan.work_id#</cfoutput>">
                                    <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#query_product_plan.company_id#</cfoutput>">
                                    <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#query_product_plan.partner_id#</cfoutput>">
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-numune-no">
                            <label class="col col-4 col-xs-12">Numune No</label>
                            <div class="col col-8 col-xs-12">
                                <div class="">
                                    <input type="hidden" name="req_id" id="req_id" value="<cfoutput>#query_product_plan.req_id#</cfoutput>">
                                    <input type="text" name="req_no" id="req_no" style="width:140px;" readonly="" value="<cfoutput>#query_product_plan.req_no#</cfoutput>">
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-emp_name" >
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='157.Görevli'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
								<cfinput type="hidden" name="old_project_emp_id" id="old_project_emp_id"  value="#attributes.project_emp_id#">
                                    <cfinput type="hidden" name="project_emp_id" id="project_emp_id"  value="#attributes.project_emp_id#">
                                     <cfinput type="text" name="emp_name" style="width:100px;" id="emp_name" value="#attributes.emp_name#"  onFocus="AutoComplete_Create('emp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0,0','PARTNER_ID,EMPLOYEE_ID','outsrc_partner_id,project_emp_id','plan','3','250');">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="javascript:gonder2('plan.emp_name');"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--- col 2 --->
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="11" sort="true">
                        <div class="form-group" id="item-date">
                            <label class="col col-4 col-xs-12">Tarih</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='1357.Basvuru Tarihi Girmelisiniz'></cfsavecontent>
                                    <input type="text" name="plan_date" id="plan_date" value="<cfoutput>#dateformat(query_product_plan.plan_date,dateformat_style)#</cfoutput>" validate="#validate_style#" maxlength="10">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="plan_date"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-project_id">
                            <label class="col col-4 col-xs-12">Proje No</label>
                            <div class="col col-8 col-xs-12">
                                <div class="">
                                    <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#query_product_plan.project_id#</cfoutput>">
                                    <input name="project_head" type="text" id="project_head" value=" <cfoutput>#query_product_plan.project_head#</cfoutput>" readonly="">
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--- col 3 --->
                   <!--- col 2 --->
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="12" sort="true">
                        <div class="form-group" id="item-start-date">
                            <label class="col col-4 col-xs-4">İş Başlangıç Zaman</label>
                            <div class="col col-8 col-xs-8">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='1357.Basvuru Tarihi Girmelisiniz'></cfsavecontent>
                                    <input type="text" name="date_start" id="date_start" value="<cfoutput>#dateformat(query_product_plan.start_date,dateformat_style)#</cfoutput>" validate="#validate_style#" maxlength="10">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="date_start"></span>
									 <cfif len(query_product_plan.start_date)>
                                            <cfset sdate=date_add("H",session.ep.time_zone,query_product_plan.start_date)>
                                            <cfset shour=datepart("H",sdate)>
                                            <cfset sminute=datepart("N",sdate)>
                                        <cfelse>
                                            <cfset sdate="">
                                            <cfset shour="">
                                            <cfset sminute="">                                           
                                        </cfif>
									 <cfoutput>
                                    <span class="input-group-addon">
                                          <cf_wrkTimeFormat name="date_start_hour" value="#shour#">
                                        </span>
                                        <span class="input-group-addon">
                                            <select name="date_start_minute" id="date_start_minute" style="width:38px;">
                                                <cfloop from="0" to="59" index="sta_min">
                                                    <option value="#NumberFormat(sta_min,00)#" <cfif sta_min eq sminute>selected</cfif>>#NumberFormat(sta_min,00)#</option>
                                                </cfloop>
                                            </select>
                                        </span>
                                    </cfoutput>
								</div>
                            </div>
                        </div>
                        <div class="form-group" id="item-finish-date">
                            <label class="col col-4 col-xs-4">İş Bitiş Zaman</label>
                            <div class="col col-8 col-xs-8">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='1357.Basvuru Tarihi Girmelisiniz'></cfsavecontent>
                                    <input type="text" name="date_finish" id="date_finish" value="<cfoutput>#dateformat(query_product_plan.finish_date,dateformat_style)#</cfoutput>" validate="#validate_style#" maxlength="10">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="date_finish"></span>
									 <cfif len(query_product_plan.finish_date)>
                                            <cfset fdate=date_add("h",session.ep.TIME_ZONE,query_product_plan.finish_date)>
                                            <cfset fhour=datepart("h",fdate)>
                                            <cfset fminute=datepart("N",fdate)>                                          
                                        <cfelse>
                                            <cfset fdate="">
                                            <cfset fhour="">
                                            <cfset fminute="">                                          
                                        </cfif>
									 <cfoutput>
                                        <span class="input-group-addon">
                                           <cf_wrkTimeFormat name="date_finish_hour" value="#fhour#">
                                        </span>
                                        <span class="input-group-addon">
                                            <select name="date_finish_minute" id="date_finish_minute" style="width:38px;">
                                                <cfloop from="0" to="59" index="fin_min">
                                                    <option value="#NumberFormat(fin_min,00)#" <cfif fminute eq fin_min> selected</cfif>>#NumberFormat(fin_min,00)#</option>
                                                </cfloop>
                                            </select>                                            
                                        </span>
                                   </cfoutput>
							   </div>
								 
                            </div>
                        </div>
                    </div>
					
                    <!--- col 4 --->
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="13" sort="true">
                        <div class="form-group" id="item-stage_id">
                            <label class="col col-4 col-xs-12">Aktif *</label>
                            <div class="col col-8 col-xs-12">
                                           <input type="checkbox" name="status_plan" id="status_plan" value="1" <cfif query_product_plan.active>checked</cfif>>
                            </div>
                        </div>
                        <div class="form-group" id="item-stage_id">
<!---<select name="opportunity_type_id" id="opportunity_type_id" onchange="if (['6','14'].indexOf(this.value)>=0) { $('#btnorderadd').hide() } else { $('#btnorderadd').show() }">--->

                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='1447.Süreç'> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class=""	>
                                           <cf_workcube_process is_upd='0' select_value='#query_product_plan.stage_id#' process_cat_width='140' is_detail='1'>
                                </div>
                            </div>
                        </div>
                        
                    </div>
                </div>
            </div>
        </div>
    </div>

  