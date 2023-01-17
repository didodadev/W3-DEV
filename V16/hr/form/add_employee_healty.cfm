<cf_xml_page_edit fuseact='hr.popup_add_employee_healty'>
<cf_papers paper_type="EMPLOYEE_HEALTY">
<cfset system_paper_no=paper_code & '-' & paper_number>
<cfset system_paper_no_add=paper_number>
<cfif len(paper_number)>
	<cfset asset_no = system_paper_no>
<cfelse>
	<cfset asset_no = ''>
</cfif>
<cf_box title="#getLang('','İşyeri Sağlık Muayeneleri',47131)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfform name="add_healty" method="post" action="#request.self#?fuseaction=hr.emptypopup_add_employee_healty">
    <input type="hidden" name="draggable" id="draggable">
  <cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-employee_healty_no">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57880.Belge No'>*</label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="employee_healty_no" style="width:150px;" value="#asset_no#" required="yes" message="Belge No Girmelisiniz!">
                            </div>
                        </div>
                        <div class="form-group" id="item-process_stage" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
							<div class="col col-8 col-xs-12"><cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'></div>
						</div>
                        <div class="form-group" id="item-emp_name_">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57570.Ad Soyad'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.employee_id")><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
                                    <input type="text" name="emp_name_" id="emp_name_" value="<cfif isdefined("attributes.employee_id")><cfoutput>#get_emp_info(attributes.employee_id,0,0)#</cfoutput></cfif>" style="width:150px;" readonly>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_positions&field_emp_id=add_healty.employee_id&field_emp_name=add_healty.emp_name_</cfoutput>');"></span>
                                	<span class="input-group-addon icon-pluss" onClick="javascript:if(document.add_healty.employee_id.value !=''){openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.employee_relative_ssk&event=add&field_rel_name=add_healty.relative_name&field_rel_id=add_healty.relative_id&employee_id='+document.add_healty.employee_id.value);}else {alert('<cfoutput>#getLang('','Çalışan seçiniz',56649)#</cfoutput> !');return false};chanege_();" title="<cf_get_lang no='24.Çalışan Yakını'>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" style="display:none" id="is_relative_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55109.Çalışan Yakını'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="hidden" name="relative_id" id="relative_id" value="">
                                <input type="text" name="relative_name" id="relative_name" value="" style="width:150px;" readonly>
                            </div>
                        </div>
                        <div class="form-group" id="item-INSPECTION_DATE">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='53322.Muayene Tarihi girmelisiniz'></cfsavecontent>
                                    <cfinput validate="#validate_style#" required="Yes" message="#message#" type="text" name="INSPECTION_DATE" id="INSPECTION_DATE" style="width:150px;" value="#dateformat(now(), dateformat_style)#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="INSPECTION_DATE"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-doctor">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64003.Hekim'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="doctor_emp_id" id="doctor_emp_id">
                                    <input type="hidden" name="doctor_comp_id" id="doctor_comp_id">
                                    <input type="text" name="doctor_name" id="doctor_name" style="width:150px;" readonly>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_all_positions&field_emp_id=add_healty.doctor_emp_id&field_name=add_healty.doctor_name&field_comp_id=add_healty.doctor_comp_id&field_comp_name=add_healty.doctor_name&select_list=5,6,9</cfoutput>','list');"></span>                                   
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-inspection_type">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56885.Muayene Tipi'></label>
                            <div class="col col-8 col-xs-12">
                                <cfset get_inspection_list = createObject("component","V16.settings.cfc.setupInspectionTypes").getInspectionTypes()>
                                <select name="inspection_type" id="inspection_type" style="width:150px;">
                                    <cfoutput query="get_inspection_list">
                                        <option value="#inspection_type_id#">#inspection_type#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-health_complaint">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55184.Şikayet'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea type="text" name="health_complaint" id="health_complaint" style="width:400px;height:80px;"></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-inspection_result">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56624.Bulgular/Lab İncelemeleri'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea type="text" name="inspection_result" id="inspection_result" style="width:400px;height:80px;"></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-complaint2">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32413.Tanı'></label>
                            <div class="col col-8 col-xs-12">
                            	<div class="input-group">
                                    <select name="complaint2" id="complaint2" style="width:400px;height:60px;" multiple></select>
                                    <span class="input-group-addon icon-pluss" onClick="openBoxDraggable('<cfoutput>#request.self#?</cfoutput>fuseaction=objects.popup_list_complaints&field_name=add_healty.complaint2&from_inspection=1');"></span>
                                    <span class="input-group-addon icon-minus" onClick="complaint2_remove();" title="<cf_get_lang_main no ='51.Sil'>"></span>
                                </div>
                            </div>
                        </div>
                        <cfif xml_complaint eq 1>
                        <div class="form-group" id="item-complaint">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea type="text" name="complaint" id="complaint" style="width:400px;height:80px;"></textarea>
                            </div>
                        </div>
                      </cfif> 
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-decisionmecidine2">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55191.Verilen İlaçlar'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <select name="decisionmecidine2" id="decisionmecidine2" style="width:400px;height:60px;" multiple></select>
                                    <span class="input-group-addon icon-pluss" onClick="openBoxDraggable('<cfoutput>#request.self#?</cfoutput>fuseaction=objects.popup_list_decision_medicines&field_name=add_healty.decisionmecidine2');"></span>
                                    <span class="input-group-addon icon-minus" onClick="medicine_remove();" title="<cf_get_lang_main no ='51.Sil'>"></span>
                                </div>
                            </div>
                        </div>
                   <cfif xml_decisionmecidine eq 1> 
                        <div class="form-group" id="item-decisionmecidine">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea type="text" name="decisionmecidine" id="decisionmecidine" style="width:400px;height:60px;"></textarea>
                            </div>
                        </div>	
                      </cfif> 
                        <div class="form-group" id="item-conclusion">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57684.Sonuç'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="conclusion" id="conclusion" style="width:150px;">
                                    <option value="1"><cf_get_lang dictionary_id='58761.Sevk'></option>
                                    <option value="2"><cf_get_lang dictionary_id='55224.İstiharat'></option>
                                    <option value="3"><cf_get_lang dictionary_id='55229.İşbaşı'></option>
                                    <option value="4"><cf_get_lang dictionary_id='58156.Diğer'></option>	
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-delivery_place">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55200.Sevk Yeri'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="delivery_place" id="delivery_place" value="" style="width:150px;">
                            </div>
                        </div>
                        <div class="form-group" id="item-rest_day">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55290.İstirahat'> <cf_get_lang dictionary_id='56655.Gün Sayısı'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="rest_day" id="rest_day" onkeyup="isNumber(this);" value="" style="width:150px;">
                            </div>
                        </div>
                        <div class="form-group" id="item-rest_hour">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55324.İstirahat Saati'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="rest_hour" id="rest_hour" onkeyup="isNumber(this);"  value="" style="width:150px;">
                            </div>
                        </div>
                        <div class="form-group" id="item-rest_start_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55290.İstirahat'> <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="col col-6 col-xs-12">
                                    <div class="input-group">
                                    <cfinput validate="#validate_style#" type="text" name="rest_start_date" id="rest_start_date" style="width:150px;" value="#dateformat(now(), dateformat_style)#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="rest_start_date"></span>
                                    </div></div><div class="col col-3 col-xs-12">
                                        <cf_wrkTimeFormat name="start_clock" value="0">
                                        </div><div class="col col-3 col-xs-12">
                                        <select name="start_minute" id="start_minute">
                                            <cfloop from="0" to="55" index="a" step="5">
                                                <cfoutput><option value="#Numberformat(a,00)#">#Numberformat(a,00)#</option></cfoutput>
                                            </cfloop>
                                        </select>
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-NEXT_INSPECTION_DATE">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55223.Bir Sonraki Muayene Tarihi'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput validate="#validate_style#" type="text" name="NEXT_INSPECTION_DATE" id="NEXT_INSPECTION_DATE" style="width:150px;" value="#dateformat(dateadd('d',7,now()), dateformat_style)#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="NEXT_INSPECTION_DATE"></span>
                                </div>
                            </div>
                        </div>
                      <cfif xml_detail eq 1> 
                        <div class="form-group" id="item-detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56626.Düşünceler'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea type="text" name="detail" id="detail" style="width:400px;height:60px;"></textarea>
                            </div>
                        </div>
                    </cfif> 
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                        <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
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
	if(document.getElementById('emp_name_').value == '' && document.getElementById('employee_id').value == '')
	{
		alert("<cf_get_lang dictionary_id='56649.Çalışan Seçiniz'> !");
		return false;
	}
	select_all('decisionmecidine2');
	select_all('complaint2');
	<cfif xml_complaint eq 1>
	x = (200 - document.getElementById('complaint').value.length);
	if ( x < 0 )
	{ 
		alert (" <cf_get_lang dictionary_id ='53112.Tanı'> "+ ((-1) * x) +"<cf_get_lang dictionary_id='29538.Karakter Uzun'>!");
		return false;
	}
	</cfif> 
	x = (200 - document.getElementById('inspection_result').value.length);
	if ( x < 0 )
	{ 
		alert (" <cf_get_lang dictionary_id ='53111.Bulgular/Lab. İncelemeleri'> "+ ((-1) * x) +"<cf_get_lang dictionary_id='29538.Karakter Uzun'>!");
		return false;
	}
 	<cfif xml_decisionmecidine eq 1>
	x = (500 - document.getElementById('decisionmecidine').value.length);
	if ( x < 0 )
	{ 
		alert (" <cf_get_lang dictionary_id ='53320.Karar ve Verilen İlaçlar'> "+ ((-1) * x) +"<cf_get_lang dictionary_id='29538.Karakter Uzun'>!");
		return false;
	}
 	</cfif>
 	<cfif xml_detail eq 1>
	x = (500 - document.getElementById('detail').value.length);
	if ( x < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id ='53321.Düşünceler'>  "+ ((-1) * x) +"<cf_get_lang dictionary_id='29538.Karakter Uzun'>!");
		return false;
	}
	 </cfif>
	return true;

}
function select_all(selected_field)
{
	var m = eval("document.add_healty." + selected_field + ".length");
	for(i=0;i<m;i++)
	{
		eval("document.add_healty."+selected_field+"["+i+"].selected=true");
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
function complaint2_remove()
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

