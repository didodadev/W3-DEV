<cf_xml_page_edit fuseact='hr.popup_add_employee_healty'>
<cfinclude template="../query/get_emp_healty.cfm">
<cfif len(get_healty.relative_id)>
	<cfquery name="get_rel_name" datasource="#dsn#">
		SELECT NAME +' '+ SURNAME NAME FROM EMPLOYEES_RELATIVES WHERE RELATIVE_ID = #get_healty.relative_id# <!---AND EMPLOYEE_ID = #attributes.EMPLOYEE_ID#--->
	</cfquery>
</cfif>
    <cf_box title="#getLang('','İşyeri Sağlık Muayeneleri',47131)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="upd_healty" method="post" action="#request.self#?fuseaction=hr.emptypopup_upd_employee_healty">
        <input type="hidden" name="draggable" id="draggable">
    	<input type="hidden" name="healty_id" id="healty_id" value="<cfoutput>#get_healty.healty_id#</cfoutput>">
     <cf_box_elements>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-employee_healty_no">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'>*</label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="employee_healty_no" style="width:150px;" value="#get_healty.HEALTY_NO#" required="yes" message="Belge No Girmelisiniz!">
                                </div>
                            </div>
                            <div class="form-group" id="item-process_stage">
                                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                                <div class="col col-8 col-sm-12">
                                    <cf_workcube_process is_upd='0'  select_value ='#get_healty.HEALTY_STAGE#' process_cat_width='150' is_detail='0' tabindex="10">
                                </div>
                            </div>
                                <div class="form-group" id="item-emp_name_">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_healty.employee_id#</cfoutput>" >
                                            <input type="text" name="emp_name_" id="emp_name_" value="<cfoutput>#get_healty.employee_name# #get_healty.employee_surname#</cfoutput>" style="width:150px;" readonly>
                                            <!---  <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_positions&field_emp_id=upd_healty.EMPLOYEE_ID&field_name=upd_healty.emp_name_</cfoutput>','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>  --->
                                            <span class="input-group-addon icon-pluss" onClick="javascript:if(document.upd_healty.employee_id.value !=''){openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.employee_relative_ssk&event=add&field_rel_name=upd_healty.relative_name&field_rel_id=upd_healty.relative_id&employee_id='+document.upd_healty.employee_id.value);}else {alert('Çalışan seçiniz');return false};chanege_();" title="<cf_get_lang no='24.Çalışan Yakını'>"></span>
                                        </div>
                                    </div>
                                </div>
                            <div class="form-group" id="is_relative_name" <cfif not len(get_healty.relative_id)>style="display:none"</cfif>>
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55109.Çalışan Yakını'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="hidden" name="relative_id" id="relative_id" value="<cfoutput>#get_healty.relative_id#</cfoutput>" >
                    				<input type="text" name="relative_name" id="relative_name" value="<cfif len(get_healty.relative_id) and len(get_rel_name.name)><cfoutput>#get_rel_name.name#</cfoutput></cfif>" style="width:150px;" readonly>
                                </div>
                            </div>
                            <div class="form-group" id="item-INSPECTION_DATE">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfsavecontent variable="alert"><cf_get_lang dictionary_id ='54164.İşlem tarihi yanlış'></cfsavecontent>
                    					<cfinput validate="#validate_style#" required="Yes" message="#alert#" type="text" value="#dateformat(get_healty.INSPECTION_DATE,dateformat_style)#" name="INSPECTION_DATE" style="width:150px;">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="INSPECTION_DATE"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-doctor">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64003.Hekim'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="doctor_emp_id" id="doctor_emp_id" value="<cfif len(get_healty.doctor_emp_id)><cfoutput>#get_healty.doctor_emp_id#</cfoutput></cfif>">
                                        <input type="hidden" name="doctor_comp_id" id="doctor_comp_id" value="<cfif len(get_healty.doctor_comp_id)><cfoutput>#get_healty.doctor_comp_id#</cfoutput></cfif>">
                                        <input type="text" name="doctor_name" id="doctor_name" value="<cfif len(get_healty.doctor_emp_id)><cfoutput>#get_emp_info(get_healty.doctor_emp_id,0,0)#</cfoutput><cfelseif len(get_healty.doctor_comp_id)><cfoutput>#get_par_info(get_healty.doctor_comp_id,1,1,0)#</cfoutput></cfif>" style="width:150px;" readonly>
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_all_positions&field_emp_id=upd_healty.doctor_emp_id&field_name=upd_healty.doctor_name&field_comp_id=upd_healty.doctor_comp_id&field_comp_name=upd_healty.doctor_name&select_list=5,6,9</cfoutput>');"></span>                                   
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-inspection_type">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56885.Muayene Tipi'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfset get_inspection_list = createObject("component","V16.settings.cfc.setupInspectionTypes").getInspectionTypes()>
                                    <select name="inspection_type" id="inspection_type" style="width:150px;;">
                                        <cfoutput query="get_inspection_list">
                                            <option value="#inspection_type_id#" <cfif inspection_type_id eq get_healty.process_type>selected</cfif>>#inspection_type#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-health_complaint">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55184.Şikayet'></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea type="text" name="health_complaint" id="health_complaint" style="width:400px;height:80px;"><cfif len(get_healty.health_complaint)><cfoutput>#get_healty.health_complaint#</cfoutput></cfif></textarea>
                                </div>
                            </div>
                            <div class="form-group" id="item-inspection_result">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56624.Bulgular/Lab İncelemeleri'></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea type="text" name="inspection_result" id="inspection_result" style="width:400px;height:80px;"><cfif len(get_healty.INSPECTION_RESULT)><cfoutput>#get_healty.INSPECTION_RESULT#</cfoutput></cfif></textarea>
                                </div>
                            </div>
                            <div class="form-group" id="item-complaint2">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32413.Tanı'></label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
										<cfset get_complaint_list = createObject("component","V16.settings.cfc.setupComplaints").getComplaints(complaint_id_list:get_healty.COMPLAINT2)>
                                        <select name="complaint2" id="complaint2" style="width:400px;height:60px;" multiple>
                                            <cfoutput query="get_complaint_list">
                                                <option value="#COMPLAINT_ID#">#COMPLAINT#</option>
                                            </cfoutput>
                                        </select> 
                                        <span class="input-group-addon icon-pluss" onClick="openBoxDraggable('<cfoutput>#request.self#?</cfoutput>fuseaction=objects.popup_list_complaints&field_name=upd_healty.complaint2&from_inspection=1');"></span>
                                        <span class="input-group-addon icon-minus" onClick="complaint_remove();" title="<cf_get_lang dictionary_id ='57463.Sil'>"></span>
                                	</div>
                                </div>
                            </div>
                         <cfif xml_complaint eq 1> 
                            <div class="form-group" id="item-complaint">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea type="text" name="complaint" id="complaint" style="width:400px;height:80px;"><cfif len(get_healty.COMPLAINT)><cfoutput>#get_healty.COMPLAINT#</cfoutput></cfif></textarea>
                                </div>
                            </div>
                           </cfif> 
                        </div>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-decisionmecidine2">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55191.Verilen İlaçlar'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfset get_medicine_list = createObject("component","V16.settings.cfc.setupDecisionmedicine").getDecisionmedicine(decision_medicine_id_list:get_healty.DECISION_MEDICINE2)>
                                        <select name="decisionmecidine2" id="decisionmecidine2" style="width:400px;height:60px;" multiple>
                                            <cfoutput query="get_medicine_list">
                                                <option value="#DECISION_MEDICINE_ID#">#DECISION_MEDICINE#</option>
                                            </cfoutput>
                                        </select> 
                                        <span class="input-group-addon icon-pluss" onClick="openBoxDraggable('<cfoutput>#request.self#?</cfoutput>fuseaction=objects.popup_list_decision_medicines&field_name=upd_healty.decisionmecidine2');"></span>
                                        <span class="input-group-addon icon-minus" onClick="medicine_remove();" title="<cf_get_lang dictionary_id ='57463.Sil'>"></span>
                                    </div>
                                </div>
                            </div>
                           <cfif xml_decisionmecidine eq 1>  
                            <div class="form-group" id="item-decisionmecidine">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea type="text" name="decisionmecidine" id="decisionmecidine" style="width:400px;height:60px;"><cfif len(get_healty.DECISION_MEDICINE)><cfoutput>#get_healty.DECISION_MEDICINE#</cfoutput></cfif></textarea>
                                </div>
                            </div>	
                           </cfif> 
                            <div class="form-group" id="item-conclusion">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57684.Sonuç'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="conclusion" id="conclusion" style="width:150px;">
                                        <option value="1" <cfif get_healty.conclusion eq 1>selected</cfif>><cf_get_lang dictionary_id='58761.Sevk'></option>
                                        <option value="2" <cfif get_healty.conclusion eq 2>selected</cfif>><cf_get_lang dictionary_id='55224.İstiharat'></option>
                                        <option value="3" <cfif get_healty.conclusion eq 3>selected</cfif>><cf_get_lang dictionary_id='55229.İşbaşı'></option>
                                        <option value="4" <cfif get_healty.conclusion eq 4>selected</cfif>><cf_get_lang dictionary_id='58156.Diğer'></option>	
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-delivery_place">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55200.Sevk Yeri'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="delivery_place" id="delivery_place" value="<cfoutput>#get_healty.delivery_place#</cfoutput>" style="width:150px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-rest_day">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55290.İstirahat'> <cf_get_lang dictionary_id='56655.Gün Sayısı'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="rest_day" id="rest_day" value="<cfoutput>#get_healty.rest_day#</cfoutput>" onkeyup="isNumber(this);" style="width:150px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-rest_hour">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55324.İstirahat Saati'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="rest_hour" id="rest_hour" value="<cfoutput>#get_healty.rest_hour#</cfoutput>" onkeyup="isNumber(this);" style="width:150px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-rest_start_date">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55290.İstirahat'> <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="col col-6 col-xs-12">
                                    <div class="input-group">
                                        <cfif len(get_healty.rest_start_date)><cfset start_=date_add('h',session.ep.time_zone,get_healty.rest_start_date)><cfelse><cfset start_ = ""></cfif>
										<cfinput validate="#validate_style#" type="text" name="rest_start_date" style="width:150px;" value="#dateformat(start_,dateformat_style)#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="rest_start_date"></span>
                                        </div></div><div class="col col-3 col-xs-12">
                                     
                                            <cf_wrkTimeFormat name="start_clock" value="#timeformat(start_,'HH')#">
                                       
                                    </div><div class="col col-3 col-xs-12">
                                       
                                            <select name="start_minute" id="start_minute">
                                                <cfloop from="0" to="55" index="a" step="5">
                                                    <cfoutput><option value="#Numberformat(a,00)#" <cfif timeformat(start_,'MM') eq a> selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
                                                </cfloop>
                                            </select>
                                       
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-NEXT_INSPECTION_DATE">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55223.Bir Sonraki Muayene Tarihi'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfinput validate="#validate_style#" type="text" name="NEXT_INSPECTION_DATE" style="width:150px;"  value="#dateformat(get_healty.NEXT_INSPECTION_DATE,dateformat_style)#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="NEXT_INSPECTION_DATE"></span>
                                    </div>
                                </div>
                            </div>
                        <cfif xml_detail eq 1> 
                            <div class="form-group" id="item-detail">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56626.Düşünceler'></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea type="text" name="detail" id="detail" style="width:400px;height:60px;"><cfif len(get_healty.healty_detail)><cfoutput>#get_healty.healty_detail#</cfoutput></cfif></textarea>
                                </div>
                            </div>
                        </cfif> 
                        </div>
                    </cf_box_elements>
                    <cf_box_footer>
                            <cf_record_info query_name="get_healty">
                            <cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=hr.emptypopup_del_emp_healty&healty_id=#attributes.healty_id#'>
                    </cf_box_footer>
	        </cfform>
        </cf_box>
<script type="text/javascript">
function chanege_()
{
	is_relative_name.style.display = '';
}
function kontrol()
{
	select_all('decisionmecidine2');
	select_all('complaint2');
     <cfif xml_complaint eq 1>  
	x = (200 - document.upd_healty.complaint.value.length);
	if ( x < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id ='53112.Tanı'>"+ ((-1) * x) +"<cf_get_lang dictionary_id='29538.Karakter Uzun'>!");
		return false;
	}
     </cfif> 
	x = (200 - document.upd_healty.inspection_result.value.length);
	if ( x < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id ='53111.Bulgular/Lab. İncelemeleri'>  "+ ((-1) * x) +"<cf_get_lang dictionary_id='29538.Karakter Uzun'> !");
		return false;
	}
      <cfif xml_decisionmecidine eq 1> 
	x = (500 - document.upd_healty.decisionmecidine.value.length);
	if ( x < 0 )
	{ 
		alert (" <cf_get_lang dictionary_id ='53320.Karar ve Verilen İlaçlar'>  "+ ((-1) * x) +"<cf_get_lang dictionary_id='29538.Karakter Uzun'>!");
		return false;
	}
    </cfif>
    <cfif xml_detail eq 1> 
	x = (500 - document.upd_healty.detail.value.length);
	if ( x < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id ='56626.Düşünceler'>"+ ((-1) * x) +"<cf_get_lang dictionary_id='29538.Karakter Uzun'>!");
		return false;
	}
     </cfif>
	return true;
}
function select_all(selected_field)
{
	var m = eval("document.upd_healty." + selected_field + ".length");
	for(i=0;i<m;i++)
	{
		eval("document.upd_healty."+selected_field+"["+i+"].selected=true");
	}
}
function medicine_remove()
{
	for (i=document.getElementById('decisionmecidine2').options.length-1;i>-1;i--)
	{
		if (document.getElementById('decisionmecidine2').options[i].selected==true)
		{
			document.getElementById('decisionmecidine2').options.remove(i);
		}	
	}
}
function complaint_remove()
{
	for (i=document.getElementById('complaint2').options.length-1;i>-1;i--)
	{
		if (document.getElementById('complaint2').options[i].selected==true)
		{
			document.getElementById('complaint2').options.remove(i);
		}	
	}
}
</script>
