
<cfobject name="myhome_employee_mandate_component" component="V16.myhome.cfc.myhome_employee_mandate">
<cfset myhome_employee_mandate_component.init()>
<cfparam name="attributes.is_mandate" default="1">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfset objRequest = GetPageContext().GetRequest() />
<cfset strUrl = objRequest.GetRequestUrl().Append( "?" & objRequest.GetQueryString() ).ToString()/>
<cfform method="POST" action="#strUrl#">
     <input type="hidden" name="submited" value="1">
    <cf_box_elements>
          <div class="col col-6 col-md-6 col-sm-8 col-xs-12" type="column" index="1" sort="true" data-formulacontainer="mandate">
               <cfif 1 eq 1 >
                    <div class="form-group" id="item-process_stage">
                         <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'>*</label>
                         <div class="col col-8 col-xs-12">
                              <cf_workcube_process select_value="#iif(isDefined("mandate_query"), "mandate_query.process_stage", DE(""))#" is_upd="0" is_detail="#(attributes.event eq "add")?0:1#">
                         </div>
                    </div>
               <cfelse>
                    <cfoutput><input type="hidden" name="process_stage" id="mandate_process_stage" value="#iif(isDefined("mandate_query"), "mandate_query.process_stage", DE(''))#"></cfoutput>
               </cfif>
               <cfif 1 eq 1 >
                    <div class="form-group" id="item-employee_name">
                         <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59855.Vekalet Veren'>*</label>
                         <div class="col col-8 col-xs-12">
                              <cfif isDefined("attributes.is_mandate") and attributes.is_mandate eq 0>
                                   <div class="input-group">
                              <cfoutput><input type="hidden" name="employee_id" id="mandate_employee_id" value="#iif(isDefined("mandate_query"), "mandate_query.employee_id", DE(''))#"></cfoutput>

                                        <cfoutput><input type="text" name="employee_name" id="mandate_employee_name" value="#iif(isDefined("attributes.is_mandate") and attributes.is_mandate eq 1, "get_emp_info(session.ep.userid,0,0)", DE(''))#"></cfoutput>
                                       <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_emps&field_id=mandate_employee_id&field_name=mandate_employee_name&select_list=1', 'list')"></span>
                                   </div>  
                              <cfelse>
                                   <cfoutput><input type="hidden" name="employee_id" id="mandate_employee_id_" value="#iif(isDefined("mandate_query"), "mandate_query.employee_id", DE(session.ep.userid))#"></cfoutput>
                                   <cfoutput><input type="text" name="employee_name" id="mandate_employee_name_" value="#iif(isDefined("attributes.is_mandate") and attributes.is_mandate eq 1, "get_emp_info(session.ep.userid,0,0)", DE(''))#" readonly></cfoutput>
                              </cfif>
                         </div>
                    </div>
               <cfelse>
                         <cfoutput><input type="hidden" name="employee_name" id="mandate_employee_name" value="#iif(isDefined("mandate_query"), "mandate_query.employee_name", DE(''))#"></cfoutput>
               </cfif>
               <cfif 1 eq 1 >
                    <div class="form-group" id="item-mandate_name">
                         <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60285.Vekalet Alan'>*</label>
                         <div class="col col-8 col-xs-12">
                              <cfif isDefined("attributes.is_mandate") and attributes.is_mandate eq 1>
                              <div class="input-group">   
                                   <cfoutput><input type="hidden" name="mandate_id" id="mandate_mandate_id" value="#iif(isDefined("mandate_query"), "mandate_query.mandate_id", DE(''))#"></cfoutput>
                                   <cfoutput><input type="text" name="mandate_name" id="mandate_mandate_name" value="#iif(isDefined("attributes.is_mandate") and attributes.is_mandate eq 0, "get_emp_info(session.ep.userid,0,0)", DE(''))#"></cfoutput>
                                   <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_emps&field_id=mandate_mandate_id&field_name=mandate_mandate_name&select_list=1', 'list')"></span>
                              </div>
                              <cfelse>
                              <cfoutput><input type="hidden" name="mandate_id" id="mandate_mandate_id_" value="#iif(isDefined("mandate_query"), "mandate_query.mandate_id", DE(session.ep.userid))#"></cfoutput>
                                   <cfoutput><input type="text" name="mandate_name" id="mandate_mandate_name_" value="#iif(isDefined("attributes.is_mandate") and attributes.is_mandate eq 0, "get_emp_info(session.ep.userid,0,0)", DE(''))#" readonly></cfoutput>
                              </cfif>
                         </div>
                    </div>
               <cfelse>
                    <cfoutput><input type="hidden" name="mandate_name" id="mandate_mandate_name" value="#iif(isDefined("mandate_query"), "mandate_query.mandate_name", DE(''))#"></cfoutput>
               </cfif>
               <cfif 1 eq 1 >
                    <div class="form-group" id="item-startdate">
                         <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>*</label>
                         <div class="col col-4 col-xs-12">
                              <cfif isDefined("attributes.is_mandate") and attributes.is_mandate eq 1>
                                   <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="startdate" id="startdate" maxlength="10" validate="#validate_style#" required="yes" message="#message#" value="">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                                   </div>
                              <cfelse>
                                   <div class="input-group">
                                        <cfinput type="text" name="startdate" id="startdate_" maxlength="10" validate="#validate_style#"  value="">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="startdate_"></span>
                                   </div>
                              </cfif>
                         </div>
                         <div class="col col-4 col-xs-12">
                              <div class="input-group">
                                   <cfif isDefined("attributes.is_mandate") and attributes.is_mandate eq 1>
                                        <cf_wrkTimeFormat name="start_hour" id="start_hour" value="#timeformat(attributes.startdate,"HH")#">
                                        </select>
                                        <span class="input-group-addon no-bg"></span>
                                        <select name="start_min" id="start_min">
                                             <option value="0"><cf_get_lang dictionary_id='58827.Dk'></option>
                                             <cfloop from="0" to="45" index="i" step="15">
                                                  <cfoutput>
                                                       <cfoutput><option value="#Numberformat(i,00)#">#Numberformat(i,00)#</option></cfoutput>
                                                  </cfoutput>
                                             </cfloop>
                                        </select>
                                   <cfelse>
                                        <cf_wrkTimeFormat name="start_hour_" id="start_hour_" value="#timeformat(attributes.startdate,"HH")#">
                                        </select>
                                        <span class="input-group-addon no-bg"></span>
                                        <select name="start_min" id="start_min_">
                                             <option value="0"><cf_get_lang dictionary_id='58827.Dk'></option>
                                             <cfloop from="0" to="45" index="i" step="15">
                                                  <cfoutput>
                                                       <cfoutput><option value="#Numberformat(i,00)#">#Numberformat(i,00)#</option></cfoutput>
                                                  </cfoutput>
                                             </cfloop>
                                        </select>
                                   </cfif>
                              </div>
                         </div>
                    </div>
               <cfelse>
                    <cfoutput><input type="hidden" name="startdate" id="startdate" value="#iif(isDefined("mandate_query"), "mandate_query.startdate", DE(''))#"></cfoutput>
               </cfif>
               <cfif 1 eq 1 >
                    <div class="form-group" id="item-finishdate">
                         <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'>*</label>
                         <div class="col col-4 col-xs-12">
                              <cfif isDefined("attributes.is_mandate") and attributes.is_mandate eq 1>
                                   <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="finishdate" id="finishdate" maxlength="10" validate="#validate_style#" required="yes" message="#message#" value="">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                                   </div>
                              <cfelse>
                                   <div class="input-group">
                                        <cfinput type="text" name="finishdate" id="finishdate_" maxlength="10" validate="#validate_style#" value="">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate_"></span>
                                   </div>
                              </cfif>
                         </div>
                         <div class="col col-4 col-xs-12">
                              <div class="input-group">
                                   <cfif isDefined("attributes.is_mandate") and attributes.is_mandate eq 1>
                                        <cf_wrkTimeFormat name="end_hour" id="end_hour" value="#timeformat(attributes.finishdate,"HH")#">
                                        </select>
                                        <span class="input-group-addon no-bg"></span>
                                        <select name="end_min" id="end_min">
                                             <option value="0"><cf_get_lang dictionary_id='58827.Dk'></option>
                                             <cfloop from="0" to="45" index="i" step="15">
                                                  <cfoutput>
                                                       <cfoutput><option value="#Numberformat(i,00)#">#Numberformat(i,00)#</option></cfoutput>
                                                  </cfoutput>
                                             </cfloop>
                                        </select>
                                   <cfelse>
                                        <cf_wrkTimeFormat name="end_hour_" id="end_hour_" value="#timeformat(attributes.finishdate,"HH")#">
                                        </select>
                                        <span class="input-group-addon no-bg"></span>
                                        <select name="end_min" id="end_min_">
                                             <option value="0"><cf_get_lang dictionary_id='58827.Dk'></option>
                                             <cfloop from="0" to="45" index="i" step="15">
                                                  <cfoutput>
                                                       <cfoutput><option value="#Numberformat(i,00)#">#Numberformat(i,00)#</option></cfoutput>
                                                  </cfoutput>
                                             </cfloop>
                                        </select>
                                   </cfif>
                              </div>
                         </div>
                    </div>
               <cfelse>
                    <cfoutput><input type="hidden" name="finishdate" id="finishdate" value="#iif(isDefined("mandate_query"), "mandate_query.finishdate", DE(''))#"></cfoutput>
               </cfif>    
               <cfif 1 eq 1 >
                    <div class="form-group" id="item-detail">
                         <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                         <div class="col col-8 col-xs-12">
                              <cfif isDefined("attributes.is_mandate") and attributes.is_mandate eq 1>
                                   <cfoutput><textarea name="detail" id="mandate_detail"   >#iif(isDefined("mandate_query"), "mandate_query.detail", DE(''))#</textarea></cfoutput>                   
                              <cfelse>
                                   <cfoutput><textarea name="detail" id="mandate_detail_"   >#iif(isDefined("mandate_query"), "mandate_query.detail", DE(''))#</textarea></cfoutput>
                              </cfif>
                         </div>
                    </div>
               <cfelse>
                    <cfoutput><input type="hidden" name="detail" id="mandate_detail" value="#iif(isDefined("mandate_query"), "mandate_query.detail", DE(''))#"></cfoutput>
               </cfif>   
          </div>
     </cf_box_elements>
     <cf_box_footer>
          <cf_workcube_buttons is_upd="0" is_delete="0" add_function="control()">
     </cf_box_footer>
</cfform>