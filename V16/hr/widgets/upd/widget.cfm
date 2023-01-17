<cfobject name="hr_employee_mandate_component" component="V16.hr.cfc.hr_employee_mandate">
<cfset hr_employee_mandate_component.init()>
<cfset mandate_query = hr_employee_mandate_component.mandate_get(argumentCollection=attributes)>
<cfset objRequest = GetPageContext().GetRequest() />
<cfset strUrl = objRequest.GetRequestUrl().Append( "?" & objRequest.GetQueryString() ).ToString()/>
<cfform method="POST" action="#strUrl#">
<input type="hidden" name="submited" value="1">
<cf_box_elements>
     <div class="col col-6 col-xs-12" type="column" index="1" sort="true" data-formulacontainer="mandate">
          <cfoutput><input type="hidden" name="id" id="mandate_id" value="#iif(isDefined("mandate_query"), "mandate_query.id", DE(''))#"></cfoutput>
          <cfif 1 eq 1 >
          <div class="form-group" id="item-process_stage">
               <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36841'>*</label>
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
                         <cfoutput><input type="hidden" name="employee_id" id="mandate_employee_id" value="#iif(isDefined("mandate_query"), "mandate_query.employee_id", DE(''))#"></cfoutput>
                                   <div class="input-group">
                                        <cfoutput><input type="text" name="employee_name" id="mandate_employee_name" value="#iif(isDefined("mandate_query"), "mandate_query.employee_name", DE(session.ep.name & " " & session.ep.surname))#"></cfoutput>
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_emps&field_id=mandate_employee_id&field_name=mandate_employee_name&select_list=1', 'list')"></span>
                                   </div>
                         </div>
                    </div>
               <cfelse>
                    <cfoutput><input type="hidden" name="employee_name" id="mandate_employee_name" value="#iif(isDefined("mandate_query"), "mandate_query.employee_name", DE(session.ep.name & " " & session.ep.surname))#"></cfoutput>
               </cfif>             
               <cfif 1 eq 1 >
                    <div class="form-group" id="item-mandate_name">
                         <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60285.Vekalet Alan'>*</label>
                         <div class="col col-8 col-xs-12">
                              <cfoutput><input type="hidden" name="mandate_id" id="mandate_mandate_id" value="#iif(isDefined("mandate_query"), "mandate_query.mandate_id", DE(''))#"></cfoutput>
                            
                                   <div class="input-group">
                                        <cfoutput><input type="text" name="mandate_name" id="mandate_mandate_name" value="#iif(isDefined("mandate_query"), "mandate_query.mandate_name", DE(''))#"    ></cfoutput>
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_emps&field_id=mandate_mandate_id&field_name=mandate_mandate_name&select_list=1', 'list')"></span>
                                   </div>
                         </div>
                    </div>
               <cfelse>
                    <cfoutput><input type="hidden" name="mandate_name" id="mandate_mandate_name" value="#iif(isDefined("mandate_query"), "mandate_query.mandate_name", DE(''))#"></cfoutput>
               </cfif>
          <cfif 1 eq 1 >
          <div class="form-group" id="item-startdate">
               <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç T'>*</label>
               <div class="col col-4 col-xs-12">
                    <div class="input-group">
                         <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
                         <cfinput type="text" name="startdate" id="startdate" maxlength="10" validate="#validate_style#" required="yes" message="#message#" value="#DateFormat(mandate_query.startdate,dateformat_style)#">
                         <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                     </div>
               </div>
               <div class="col col-4 col-xs-12">
                    <div class="input-group">
                         <cf_wrkTimeFormat name="start_hour" value="#timeformat(mandate_query.startdate,"HH")#">
                         <span class="input-group-addon no-bg"></span>
                         <select name="start_min" id="start_min">
                              <option value="0"><cf_get_lang dictionary_id='58827.Dk'></option>
                              <cfloop from="0" to="45" index="i" step="15">
                                   <cfoutput><option value="#Numberformat(i,00)#" <cfif timeformat(mandate_query.startdate,"MM") eq i>selected</cfif>>#Numberformat(i,00)#</option>
                                   </cfoutput>
                              </cfloop>
                         </select>
                    </div>
               </div>
          </div>
               <cfelse>
               <cfoutput><input type="hidden" name="startdate" id="startdate" value="#iif(isDefined("mandate_query"), "mandate_query.startdate", DE(''))#"></cfoutput>
               </cfif>
          <cfif 1 eq 1 >
               <div class="form-group" id="item-finishdate">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş T'>*</label>
                    <div class="col col-4 col-xs-12">
                         <div class="input-group">
                              <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
                              <cfinput type="text" name="finishdate" id="finishdate" maxlength="10" validate="#validate_style#" required="yes" message="#message#" value="#DateFormat(mandate_query.finishdate,dateformat_style)#">
                              <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                         </div>
                    </div>
                    <div class="col col-4 col-xs-12">
                         <div class="input-group">
                              <cf_wrkTimeFormat name="end_hour" value="#timeformat(mandate_query.finishdate,"HH")#">
                              <span class="input-group-addon no-bg"></span>
                              <select name="end_min" id="end_min">
                                   <option value="0"><cf_get_lang dictionary_id='58827.Dk'></option>
                                   <cfloop from="0" to="45" index="i" step="15">
                                        <cfoutput>
                                             <option value="#Numberformat(i,00)#" <cfif timeformat(mandate_query.finishdate,"MM") eq i>selected</cfif>>#Numberformat(i,00)#</option>
                                        </cfoutput>
                                   </cfloop>
                              </select>
                         </div>
                    </div>
               </div>               
          <cfelse>
               <cfoutput><input type="hidden" name="finishdate" id="finishdate" value="#iif(isDefined("mandate_query"), "mandate_query.finishdate", DE(''))#"></cfoutput>
          </cfif>
          <cfif 1 eq 1 >
          <div class="form-group" id="item-detail">
               <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36199'></label>
               <div class="col col-8 col-xs-12">
                    <cfoutput><input type="text" name="detail" id="mandate_detail" value="#iif(isDefined("mandate_query"), "mandate_query.detail", DE(''))#"    ></cfoutput>
                    
               </div>
          </div>
               <cfelse>
               <cfoutput><input type="hidden" name="detail" id="mandate_detail" value="#iif(isDefined("mandate_query"), "mandate_query.detail", DE(''))#"></cfoutput>
               </cfif>
     </div>
</cf_box_elements>
<cf_box_footer>    
     <cf_record_info query_name="mandate_query">
     <cf_workcube_buttons is_upd="1" is_delete="0"  add_function="kontrol()">
</cf_box_footer>
</cfform>
