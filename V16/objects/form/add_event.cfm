<!--- Bu sayfa kontrol edilip kullanılmıyorsa kaldırılacak, agenda sayfasindaki ile arasinda fark yok gibi, farkliliklar oraya uyarlanacak FBS 20101007 --->
<cfif isDefined("attributes.date")><cf_date tarih="attributes.date"></cfif>
<cfquery name="GET_EVENT_CATS" datasource="#DSN#">
	SELECT * FROM EVENT_CAT ORDER BY EVENTCAT
</cfquery>
<cfset url_string="">
<cfif isdefined("attributes.action_id") and len(attributes.action_id)>
	<cfset url_string="#url_string#&action_id=#attributes.action_id#">
</cfif>
<cfif isdefined("attributes.action_section") and len(attributes.action_section)>
	<cfset url_string="#url_string#&action_section=#attributes.action_section#">
</cfif>
<!--- 20051219 eğer sayfaya empapp_id yollanırsa olay eklerken onuda kaydediyor ve başlığa özgeçmişin adını yazıyor--->
<cfif isdefined("attributes.empapp_id") and len(attributes.empapp_id)>
	<cfset url_string="#url_string#&empapp_id=#attributes.empapp_id#">
	<cfquery name="GET_EMPAPP" datasource="#DSN#">
		SELECT NAME, SURNAME FROM EMPLOYEES_APP WHERE EMPAPP_ID = #attributes.empapp_id#
	</cfquery>
</cfif>
<cfparam name="attributes.modal_id" default="">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='58496.Olay Ekle'></cfsavecontent>
<cf_box title="#message#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfform name="add_event" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_event#url_string#">
<input type="hidden" name="send_mail_agenda" id="send_mail_agenda" value="0">
<cf_box_elements >
    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
        <div class="form-group" >
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58859.Süreç'></label>
            <div class="col col-8 col-xs-12">
                <!--- <cf_workcube_process is_upd='0' process_cat_width='230' is_detail='0'> --->
                    <cf_workcube_process is_upd='0' select_name="process_stage" process_cat_width='230' is_detail='0'>  
            </div>
        </div>
        <div class="form-group" >
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58880.Time Zone'> *</label>
            <div class="col col-8 col-xs-12">
                <cfif isdefined("session.ep.time_zone")>
                    <cfset my_time_zone = session.ep.time_zone>
                    <cfelse>
                    <cfset my_time_zone = session.pp.time_zone>
                    </cfif>
                    <cf_wrkTimeZone>
            </div>
        </div>
        <div class="form-group" >
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'> *</label>
            <div class="col col-8 col-xs-12">
                <select name="eventcat_ID" id="eventcat_ID" >
                    <option value="0" selected><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <cfoutput query="get_event_cats">
                    <option value="#eventcat_ID#">#eventcat#</option>
                    </cfoutput>
                </select>
            </div>
        </div>

        <div class="form-group" >
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57501.Başlama'> *</label>
            <div class="col col-8 col-xs-12">
                <div class="col col-5 col-xs-12">
					<div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
                        <cfif isDefined("attributes.date")>
                            <cfinput maxlength="10" required="Yes" validate="#validate_style#" message="#message#" type="text" name="startdate" value="#dateformat(attributes.date,dateformat_style)#">
                        <cfelse>
                            <cfinput maxlength="10" required="Yes" validate="#validate_style#" message="#message#" type="text" name="startdate"  value="#dateformat(NOW(),dateformat_style)#">
                        </cfif>
                        <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                    </div>
                </div>
                <div class="col col-7 col-xs-12">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57491.Saat'>/<cf_get_lang dictionary_id='58827.Dk'>:</label>
                    <div class="col col-4 col-xs-12">
                    <cf_wrkTimeFormat name="event_start_clock" value="#0#">
                    </div>
                    <div class="col col-4 col-xs-12">
                        <select name="event_start_minute" id="event_start_minute">
                            <option value="00" selected>00</option>
                            <option value="05">05</option>
                            <option value="10">10</option>
                            <option value="15">15</option>
                            <option value="20">20</option>
                            <option value="25">25</option>
                            <option value="30">30</option>
                            <option value="35">35</option>
                            <option value="40">40</option>
                            <option value="45">45</option>
                            <option value="50">50</option>
                            <option value="55">55</option>
                        </select>
                    </div> 
                </div>

            </div>
        </div>

        <div class="form-group" >
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57502.Bitiş'> *</label>
            <div class="col col-8 col-xs-12">
                <div class="col col-5 col-xs-12">
					<div class="input-group">
                        <cfsavecontent variable="message2"><cf_get_lang dictionary_id='57739.Bitis Tarihi Girmelisiniz'></cfsavecontent>
                            <cfif isDefined("attributes.date")>			    
                                <cfinput maxlength="10" type="text" name="finishdate" required="Yes" message="#message2#" validate="#validate_style#" value="#dateformat(attributes.date,dateformat_style)#" style="width:65px;">
                            <cfelse>
                                <cfinput maxlength="10" type="text" name="finishdate" required="Yes" message="#message2#" validate="#validate_style#" style="width:65px;" value="#dateformat(NOW(),dateformat_style)#">
                            </cfif>
                            <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                    </div>
                </div>
                <div class="col col-7 col-xs-12">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57491.Saat'>/<cf_get_lang dictionary_id='58827.Dk'>:</label>
                    <div class="col col-4 col-xs-12">
                        <cf_wrkTimeFormat name="event_finish_clock" value="0">
                    </div>
                    <div class="col col-4 col-xs-12">
                        <select name="event_finish_minute" id="event_finish_minute">
                            <option value="00" selected>00</option>
                            <option value="05">05</option>
                            <option value="10">10</option>
                            <option value="15">15</option>
                            <option value="20">20</option>
                            <option value="25">25</option>
                            <option value="30" <cfif isDefined("attributes.hour")>selected</cfif>>30</option>
                            <option value="35">35</option>
                            <option value="40">40</option>
                            <option value="45">45</option>
                            <option value="50">50</option>
                            <option value="55">55</option>
                        </select>
                    </div> 
                </div>
            </div>
        </div>
                <div class="form-group" >
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57480.Başlık'> *</label>
                    <div class="col col-8 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık girmelisiniz'></cfsavecontent>
                        <cfif isdefined("attributes.empapp_id") and len(attributes.empapp_id) and get_empapp.recordcount>
                            <cfinput type="text" name="EVENT_HEAD" style="width:100%" required="Yes" message="#message#" value="(#get_empapp.name# #get_empapp.surname# iş görüşmesi)">
                        <cfelse>
                            <cfinput type="text" name="EVENT_HEAD" style="width:100%" required="Yes" message="#message#">
                        </cfif>
                    </div>
                </div>

                <div class="form-group" >
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.açıklama'></label>
                    <div class="col col-8 col-xs-12">
                        <textarea name="event_detail" id="event_detail" style="width:140px;height:45px;"></textarea>
                    </div>
                </div>

                <div class="form-group" >
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57500.Onay'></label>
                    <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <input type="hidden" name="validator_id" id="validator_id" value="">
                        <input type="hidden" name="validator_type" id="validator_type" value="">
                        <input type="text" name="validator" id="validator" value=""  onFocus="AutoComplete_Create('validator','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2,3\'','PARTNER_CODE,MEMBER_TYPE','validator_id,validator_type','','3','250');" autocomplete="off">
                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_event.validator_id&field_id=add_event.validator_id&field_name=add_event.validator&field_type=add_event.validator_type');"></span>
                    </div>
                    </div>
                </div>
                
                <div class="form-group" >
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfif isdefined("attributes.action_section") and attributes.action_section is 'PROJECT_ID'>
                                <cfquery name="GET_PROJECT_NAME" datasource="#dsn#">
                                    SELECT
                                        PROJECT_HEAD
                                    FROM 
                                        PRO_PROJECTS
                                    WHERE
                                        PROJECT_ID = #attributes.action_id#
                                </cfquery>
                                <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.action_id#</cfoutput>">
                                <input type="text" name="project_head" id="project_head" style="width:230px;" value="<cfoutput>#GET_PROJECT_NAME.PROJECT_HEAD#</cfoutput>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                            <cfelseif isdefined("attributes.project_id") and len(attributes.project_id)>
                                <cfquery name="GET_PROJECT_NAME" datasource="#dsn#">
                                    SELECT
                                        PROJECT_HEAD
                                    FROM 
                                        PRO_PROJECTS
                                    WHERE
                                        PROJECT_ID = #attributes.project_id#
                                </cfquery>
                                <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
                                <input type="text" name="project_head" id="project_head"  value="<cfoutput>#GET_PROJECT_NAME.PROJECT_HEAD#</cfoutput>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                            <cfelse>
                                <input type="hidden" name="project_id" id="project_id" value="">
                                <input type="text" name="project_head" id="project_head"  value="<cf_get_lang_main no='1385.Proje Seçiniz'>"  onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                            </cfif>
                            <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_event.project_id&project_head=add_event.project_head');"></span>
                        </div>
                    </div>
                </div>
                <input type="hidden" name="tos" id="tos" value="">
                <input type="hidden" name="ccs" id="ccs" value="">
                
                <input type="hidden" name="reserve" id="reserve" value="">
                
    </div>


    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">

        <div class="form-group" >
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33149.Uyarı Başlat'></label>
            <div class="col col-8 col-xs-12">
                <div class="input-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='41367.Uyarı Başlangıç Tarihi'>!</cfsavecontent>
                    <cfinput type="text" name="warning_start"  value="" validate="#validate_style#" message="#message#">
                    <span class="input-group-addon"><cf_wrk_date_image date_field="warning_start"></span>
                </div>
            </div>
        </div>

        <div class="form-group" >
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33666.Olay Yeri'></label>
            <div class="col col-8 col-xs-12">
                <select name="event_place" id="event_place" >
                    <option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <option value="1"><cf_get_lang dictionary_id='34320.Ofis İçi'></option>
                    <option value="2"><cf_get_lang dictionary_id='33668.Ofis Dışı'></option>
                    <option value="3"><cf_get_lang dictionary_id='34321.Müşteri Ofisi'></option>
                </select>
            </div>
        </div>

        <div class="form-group" >
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32990.EMail Uyarı'></label>
            <div class="col col-8 col-xs-12">
                <div class="col col-3 ">
                    <select name="email_alert_day" id="email_alert_day" >
                        <option value="0" selected><cf_get_lang dictionary_id='33150.Kaç'></option>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                        <option value="10">10</option>
                        <option value="15">15</option>
                        <option value="30">30</option>
                        <option value="60">60</option>
                        <option value="90">90</option>
                    </select>
                </div>
                <div class="col col-3 "><label class="text-center"><cf_get_lang dictionary_id='57490.Gün'></label></div>
                <div class="col col-3 ">
                        <select name="email_alert_hour" id="email_alert_hour">
                            <option value="0" selected><cf_get_lang dictionary_id='33150.Kaç'></option>
                            <option value="0.25">15 <cf_get_lang dictionary_id='58827.dk'></option>
                            <option value="0.5">30 <cf_get_lang dictionary_id='58827.dk'></option>
                            <option value="1">1</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                            <option value="4">4</option>
                            <option value="5">5</option>
                            <option value="6">6</option>
                            <option value="7">7</option>
                            <option value="8">8</option>
                            <option value="9">9</option>
                            <option value="10">10</option>
                            <option value="12">12</option>
                            <option value="16">16</option>
                            <option value="18">18</option>
                        </select>
                </div>
                <div class="col col-3 "><label class="text-center"><cf_get_lang dictionary_id='33151.Saat Önce'></label></div>
            </div>
        </div>

        <div class="form-group" >
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32989.SMS Uyarı'></label>
            <div class="col col-8 col-xs-12">
                <div class="col col-3 ">
                    <select name="sms_alert_day" id="sms_alert_day" >
                        <option value="0" selected><cf_get_lang dictionary_id='33150.Kaç'></option>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                        <option value="10">10</option>
                        <option value="15">15</option>
                        <option value="30">30</option>
                        <option value="60">60</option>
                        <option value="90">90</option>
                    </select>
                </div>
                <div class="col col-3 "><label class="text-center"><cf_get_lang dictionary_id='57490.Gün'></label></div>
                <div class="col col-3 ">
                    <select name="sms_alert_hour" id="sms_alert_hour">
                        <option value="0" selected><cf_get_lang dictionary_id='33150.Kaç'></option>
                        <option value="0.25">15 <cf_get_lang dictionary_id='58827.dk'></option>
                        <option value="0.5">30 <cf_get_lang dictionary_id='58827.dk'></option>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                        <option value="8">8</option>
                        <option value="9">9</option>
                        <option value="10">10</option>
                        <option value="12">12</option>
                        <option value="16">16</option>
                        <option value="18">18</option>
                    </select>
                </div>
                <div class="col col-3 "><label class="text-center"><cf_get_lang dictionary_id='33151.Saat Önce'></label></div>
            </div>
        </div>
      
        <div class="form-group" >
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33163.Olay Tekrar'></label>
            <div class="col col-8 col-xs-12">
                <select name="warning" id="warning" onChange="show_warn(this.selectedIndex);" >
                    <option value="0" selected><cf_get_lang dictionary_id='58546.Yok'></option>
                    <option value="1"><cf_get_lang dictionary_id='33153.Periodik'></option>
                </select>
            </div>
        </div>

        <div class="form-group" id="warn_multiple">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33154.Tekrar'></label>
            <div class="col col-4">
                <input type="radio" name="warning_type" id="warning_type" value="7"><cf_get_lang dictionary_id='33155.Haftada Bir'>
            </div>
            <div class="col col-4">
                <input type="radio" name="warning_type" id="warning_type" value="30"><cf_get_lang dictionary_id='33156.Ayda Bir'>
            </div>
        </div>

        <div class="form-group" id="warn_multiple2">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33157.Tekrar Sayısı'></label>
            <div class="col col-8 col-xs-12">
                <div class="input-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='33158.Tekrar Sayısı girmelisiniz'></cfsavecontent>
                    <cfinput type="text" name="warning_count" onkeyup="return(FormatCurrency(this,event,0));" value="" validate="integer" message="#message#" class="moneybox" maxlength="2" style="width:50px;"> 
                    <span class="input-group-addon"><cf_get_lang dictionary_id='33159.kez'></label>
                </div>
            </div>
        </div>

        <div class="form-group" >
            <label class="col col-4 col-xs-12"></label>
            <div class="col col-8 col-xs-12">
                <input type="Checkbox" name="VIEW_TO_ALL" id="VIEW_TO_ALL" value="1" onClick="wiew_control(1);"><cf_get_lang dictionary_id='33164.Bu Olayı Herkes Görsün'>
            </div>
        </div>

        <cfquery name="find_department_branch" datasource="#DSN#">
            SELECT
                EMPLOYEE_POSITIONS.EMPLOYEE_ID,
                EMPLOYEE_POSITIONS.POSITION_ID,
                EMPLOYEE_POSITIONS.POSITION_CODE,
                BRANCH.BRANCH_ID,
                BRANCH.BRANCH_NAME,
                DEPARTMENT.DEPARTMENT_ID,
                DEPARTMENT.DEPARTMENT_HEAD
            FROM
                EMPLOYEE_POSITIONS,
                DEPARTMENT,
                BRANCH
            WHERE
                EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID
                AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
                AND EMPLOYEE_POSITIONS.POSITION_CODE = #session.ep.POSITION_CODE#
        </cfquery>
        <div class="form-group" >
            <label class="col col-4 col-xs-12"></label>
            <div class="col col-8 col-xs-12">
                <input type="checkbox" name="is_wiew_branch" id="is_wiew_branch" value="<cfoutput>#find_department_branch.BRANCH_ID#</cfoutput>" onClick="wiew_control(2);">
                <cf_get_lang dictionary_id='57914.Şubemdeki Herkes Görsün'>
                <input type="hidden" name="is_wiew_branch_" id="is_wiew_branch_" value="<cfoutput>#find_department_branch.BRANCH_ID#</cfoutput>">
            </div>
        </div>

        <div class="form-group" >
            <label class="col col-4 col-xs-12"></label>
            <div class="col col-8 col-xs-12">
                <input type="checkbox" name="is_wiew_department" id="is_wiew_department" value="<cfoutput>#find_department_branch.DEPARTMENT_ID#</cfoutput>" onClick="wiew_control(3);">
                <cf_get_lang dictionary_id='57915.Departmanımdaki Herkes Görsün'>
            </div>
        </div>
    </div>
</cf_box_elements>
<cf_box_elements>

    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" >
        <div class="form-group" >
            <cfsavecontent variable="txt_2"><cf_get_lang dictionary_id='57590.Katılımcılar'></cfsavecontent>
                <cf_workcube_to_cc 
                    is_update="0" 
                    to_dsp_name="#txt_2#" 
                     orm_name="add_event" 
                    str_list_param="1,7,8" 
                    data_type="1">
            
        </div>
    </div>
    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" >
        <div class="form-group" >
            <cfsavecontent variable="txt_1" ><cf_get_lang dictionary_id='58773.Bilgi Verilecekler'></cfsavecontent>
           
                <cf_workcube_to_cc 
                    is_update="0" 
                    cc_dsp_name="#txt_1#" 
                    form_name="add_event" 
                    str_list_param="1,7,8" 
                    data_type="1">
        </div>
    </div>
    
</cf_box_elements>

<cf_box_footer>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='33689.Kaydet ve Mail Gönder'></cfsavecontent>
    <cf_workcube_buttons is_upd='0' insert_info='#message#' add_function='check(1)' is_cancel='0' search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_event' , #attributes.modal_id#)"),DE(""))#">
    <cf_workcube_buttons is_upd='0' add_function='check(0)' search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_event' , #attributes.modal_id#)"),DE(""))#">
</cf_box_footer>


</cfform>
</cf_box>

<script type="text/javascript">
function check(type)
{
	if(type==0)
	{
		document.getElementById('send_mail_agenda').value='0'//Kaydet
	}
	else if(type==1)
	{
		document.getElementById('send_mail_agenda').value='1'; //Kaydet ve mail gönder
	}
	if (document.add_event.eventcat_ID.value == 0)
	{ 
		alert("<cf_get_lang dictionary_id ='33714.Olay Kategorisi Seçiniz'>!");
		return false;
	}

	if(document.add_event.warning.selectedIndex == 1)
		if(document.add_event.warning_count.value == "")
		{
			alert("<cf_get_lang dictionary_id ='33157.Tekrar Sayısı '>!");
			return false;
		}
		if(document.add_event.warning_count.value != "")
			if(document.add_event.warning_count.value < 2)
			{
				alert("<cf_get_lang dictionary_id ='33717.Tekrar Sayısı 1 den Büyük Olmalı '>!")
				return false;
			}
			if(document.add_event.warning.selectedIndex == 1)
			{
				if(document.add_event.warning_count.value != "")
					if(document.add_event.warning_count.value < 2)
					{
						alert("<cf_get_lang dictionary_id ='33717.Tekrar Sayısı 1 den Büyük Olmalı '>!")
						return false;
					}

		if (!((document.add_event.warning_type[0].value) || (document.add_event.warning_type[1].value) ))
		{
			alert("<cf_get_lang dictionary_id ='33718.Tekrar Periyodu'>!");
			return false;
		}
	}
	/*if ( (add_event.startdate.value != "") && (add_event.finishdate.value != "") )
		return time_check(add_event.startdate, add_event.event_start_clock, add_event.event_start_minute, add_event.finishdate,  add_event.event_finish_clock, add_event.event_finish_minute, "<cf_get_lang no ='1325.Olay Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır '>!");

	if ( (add_event.warning_start.value != "") && (add_event.startdate.value != "") )
		return date_check(add_event.warning_start,add_event.startdate,"<cf_get_lang no ='1326.Uyarı Tarihi Olay Başlama Tarihinden Önce Olmalıdır'>!");
	return true;*/
	if ( (add_event.startdate.value != "") && (add_event.finishdate.value != "") )
	{
		if (!time_check(add_event.startdate, add_event.event_start_clock, add_event.event_start_minute, add_event.finishdate,  add_event.event_finish_clock, add_event.event_finish_minute, "<cf_get_lang dictionary_id ='33715.Olay Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır '>!"))
			return false;
	}

	if ( (add_event.warning_start.value != "") && (add_event.startdate.value != "") )
	{
		if (!date_check(add_event.warning_start,add_event.startdate,"<cf_get_lang dictionary_id ='33716.Uyarı Tarihi Olay Başlama Tarihinden Önce Olmalıdır'>!"))
			return false;
	}

}

function show_warn(i)
{
/*uyari var*/
	if(i == 0)
		{
		/*tek uyari acik*/
		warn_multiple.style.display = 'none';
		warn_multiple2.style.display = 'none';
		}
	if(i == 1)
		{
		/*coklu uyari acik*/
		warn_multiple.style.display = '';
		warn_multiple2.style.display = '';
		}
}
	show_warn(0);

add_event_popup(window.opener.event_name,window.opener.event_emp_id,window.opener.event_pos_id,window.opener.event_pos_code,window.opener.event_cons_ids,window.opener.event_comp_ids,window.opener.event_par_ids,window.opener.event_grp_ids,window.opener.event_wgrp_ids,window.opener.event_add_type)

function add_event_popup(str_ekle,int_id,int_id2,int_id3,int_id4,int_id5,int_id6,int_id7,int_id8,add_type)
{
if (add_type>0 && add_type<4)
	{
	var newRow;
	var newCell;
	rowCount = document.all.tbl_to_names_row_count.value;
	newRow = document.getElementById("tbl_to_names").insertRow(document.getElementById("tbl_to_names").rows.length);
	newRow.setAttribute("name","workcube_to_row" + rowCount);
	newRow.setAttribute("id","workcube_to_row" + rowCount);		
	newRow.setAttribute("style","display:''");	
	newCell = newRow.insertCell(newRow.cells.length);
	str_html = '';
	/*calisanlar*/
	if(add_type==1){
		str_html = str_html + '<input type="hidden" name="to_emp_ids" value="' + int_id + '">	<input type="hidden" name="to_pos_ids" value="' + int_id2 + '">';	
		str_html = str_html + '<input type="hidden" name="to_pos_codes" value="' + int_id3 + '">';	
		str_html = str_html + '<input type="hidden" name="to_cons_ids" value="">'
		str_html = str_html +'<input type="hidden" name="to_grp_ids" value=""><input type="hidden" name="to_wgrp_ids" value="">';
	}
	/*kurumsal*/
	if(add_type==2){
		str_html = str_html + '<input type="hidden" name="to_emp_ids" value="">	<input type="hidden" name="to_pos_ids" value="">';	
		str_html = str_html + '<input type="hidden" name="to_pos_codes" value="">';	
		str_html = str_html + '<input type="hidden" name="to_comp_ids" value="' + int_id5 + '"><input type="hidden" name="to_par_ids" value="' + int_id6 + '">';	
		str_html = str_html + '<input type="hidden" name="to_cons_ids" value="">'	
		str_html = str_html +'<input type="hidden" name="to_grp_ids" value=""><input type="hidden" name="to_wgrp_ids" value="">';
	}
	/*bireysel*/
	if(add_type==3){
		str_html = str_html + '<input type="hidden" name="to_emp_ids" value="">	<input type="hidden" name="to_pos_ids" value="">';	
		str_html = str_html + '<input type="hidden" name="to_pos_codes" value="">';	
		str_html = str_html + '<input type="hidden" name="to_cons_ids" value="' + int_id4 + '">'
		str_html = str_html +'<input type="hidden" name="to_grp_ids" value=""><input type="hidden" name="to_wgrp_ids" value="">';
	}
	
	if(add_type==1){
		str_del = '<a href="javascript://" onClick="workcube_to_delRow(' + rowCount +');"><img src="/images/delete_list.gif"  align="absmiddle" border="0"></a>&nbsp;';	
	}
	if(add_type==2){
		str_del='<a href="javascript://" onClick="workcube_to_delRow(' + rowCount +');"><img src="/images/delete_list.gif"  align="absmiddle" border="0"></a>&nbsp;';
	}
	if(add_type==3){
		str_del='<a href="javascript://" onClick="workcube_to_delRow(' + rowCount +');"><img src="/images/delete_list.gif"  align="absmiddle" border="0"></a>&nbsp;';	
	}
	
	newCell.innerHTML = str_del + str_html + str_ekle;
	}
	return 1;
}
function wiew_control(type)
{
	if(type==1)
	{
		document.add_event.is_wiew_branch.checked=false;
		document.add_event.is_wiew_department.checked=false;
	}
	if(type==2)
	{
		document.add_event.VIEW_TO_ALL.checked=false;
		document.add_event.is_wiew_department.checked=false;
	}
	if(type==3)
	{
		document.add_event.VIEW_TO_ALL.checked=false;
		document.add_event.is_wiew_branch.checked=false;
	}
}
</script>