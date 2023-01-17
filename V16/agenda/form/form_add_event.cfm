<!---E.A 17.07.2012 select ifadelerinde düzenleme yapıldı.--->
<cfsetting showdebugoutput="no">
<cf_xml_page_edit  fuseact='agenda.form_add_event'>
<!---Destek Patent için kontrolü kapatıyorum py --->
<!---<cfif isdefined("session.agenda_userid")>
	<cflocation url="#request.self#?fuseaction=agenda.view_daily" addtoken="No">
</cfif>--->
<cfparam name="attributes.action_id" default="">
<cfparam name="attributes.action_section" default="">
<cfparam name="attributes.place_online" default="">
<cfif isdefined("attributes.action_id") and len(attributes.action_id)>
    <cfset action_id_ = "#attributes.action_id#">
</cfif>

<cfif isdefined("attributes.action_section") and len(attributes.action_section)>
    <cfset action_section_ = "#attributes.action_section#">
</cfif>

<cfinclude template="../query/get_event_cats.cfm">
<cfif isdefined("attributes.event_id")>
	<cfinclude template="../query/get_event.cfm">
    <cfquery name="GET_EVENT_SITE_DOMAIN" datasource="#DSN#">
		SELECT MENU_ID FROM EVENT_SITE_DOMAIN WHERE EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#">
	</cfquery>
</cfif>
<cfquery name="GET_SITE_MENU" datasource="#DSN#">
	SELECT MENU_ID,SITE_DOMAIN,OUR_COMPANY_ID FROM MAIN_MENU_SETTINGS WHERE SITE_DOMAIN IS NOT NULL
</cfquery>
<cfquery name="GET_COMPANIES" datasource="#DSN#">
    SELECT COMP_ID,NICK_NAME FROM OUR_COMPANY ORDER BY COMPANY_NAME
</cfquery>
<cfif isdefined("get_event.startdate") and len(get_event.startdate)>
	<cfparam name="attributes.hour" default="#timeformat(date_add("h", session.ep.time_zone, get_event.startdate),'HH')#">
<cfelse>
    <cfparam name="attributes.hour" default="#timeformat(date_add("h",session.ep.time_zone,now()),'HH')#">
</cfif>
<cfif isdefined("get_event.finishdate") and len(get_event.finishdate)>
	<cfparam name="attributes.hour1" default="#timeformat(date_add("h", session.ep.time_zone+1, get_event.finishdate),'HH')#">
<cfelse>
	<cfparam name="attributes.hour1" default="#(timeformat(date_add("h",session.ep.time_zone+1,now()),'HH'))#">
</cfif>
<cfif isDefined("attributes.temp_date")><cf_date tarih="attributes.temp_date"></cfif>
<cfsavecontent variable="title_">
	<cf_get_lang_main no='3.Ajanda'><cf_get_lang_main no='1084.Olay Ekle'>
</cfsavecontent>
<cfset pageHead = "#title_#">
<cf_catalystHeader>
<cfform name="add_event" method="post" action="#request.self#?fuseaction=agenda.emptypopup_add_event">
    <cfif isdefined("attributes.action_section") and len(attributes.action_section)>
        <input type="hidden" name="action_section" id="action_section" value="<cfoutput>#attributes.action_section#</cfoutput>">
        <cfif action_section_ is 'WORK_ID'>
            <cfset action_id__ = "#attributes.action_id#">
        </cfif>
    </cfif>
    <cfif isdefined("attributes.action_id") and len(attributes.action_id)>
        <input type="hidden" name="action_id" id="action_id" value="<cfoutput>#attributes.action_id#</cfoutput>">    
    </cfif>
	<input type="hidden" name="send_mail_agenda" id="send_mail_agenda" value="0">
    <input type="hidden" name="xml_remember" id="xml_remember" value="<cfoutput>#xml_remember#</cfoutput>" />
	<cfif attributes.fuseaction contains 'popup' or (isdefined('attributes.is_popup') and len(attributes.is_popup))>
		<input type="hidden" name="is_popup" id="is_popup" value="1">
	</cfif><!--- Popuptan geliyorsa sayfanin kapanmasi icin eklendi --->
   <cf_box>
        <cf_box_elements>
            <div class="col col-5 col-md-5 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-process_stage">
                    <label class="col col-3 col-xs-12"><cf_get_lang_main no ='1447.Süreç'></label>
                    <div class="col col-9 col-xs-12">
                        <cfif isdefined("get_event.event_stage")>
                            <cf_workcube_process is_upd='0' select_value='#get_event.event_stage#' is_detail='1'>
                        <cfelse>
                            <cf_workcube_process is_upd='0' process_cat_width='300' is_detail='0'>
                        </cfif>
                    </div>
                </div>
                <div class="form-group" id="item-eventcat_id">
                    <label class="col col-3 col-xs-12"><cf_get_lang_main no='74.Olay Kategorisi'>*</label>
                    <div class="col col-9 col-xs-12">
                        <select name="eventcat_id" id="eventcat_id" style="width:300px;">
                            <option value="0" selected><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfoutput query="get_event_cats">
                            <option value="#eventcat_id#" <cfif (IS_STANDART eq 1) or(isdefined("get_event.eventcat_id") and get_event_cats.eventcat_id eq get_event.eventcat_id)>selected</cfif>>#eventcat#</option>
                        </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-time_zone">
                    <label class="col col-3 col-xs-12"><cf_get_lang_main no='85.Zaman Dilimi'></label>
                    <div class="col col-9 col-xs-12">
                        <cf_wrkTimeZone width="300">
                    </div>
                </div>
                <div class="form-group" id="item-event_head">
                    <label class="col col-3 col-xs-12"><cf_get_lang_main no='68.Başlık'>*</label>
                    <div class="col col-9 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang_main no='59.Eksik Veri'>:<cf_get_lang_main no='68.Konu'></cfsavecontent>
                    <cfif isdefined("get_event.event_head") and len(get_event.event_head)>
                        <cfinput type="text" name="event_head" id="event_head" style="width:350px;;" required="Yes" message="#message#" value="#get_event.event_head#" maxlength="100">
                    <cfelse>
                        <cfinput type="text" name="event_head" id="event_head" style="width:350px;" required="Yes" message="#message#" maxlength="100">
                    </cfif>
                    </div>
                </div> 
                <div class="form-group" id="item-event_detail">
                    <label class="col col-3 col-xs-12"><cf_get_lang_main no='217.açıklama'></label>
                    <div class="col col-9 col-xs-12">
                        <div id="add_event_td" type="text_top"></div>
                    <textarea name="event_detail" id="event_detail" style="width:350px;height:148px!important;"><cfif isdefined("get_event.event_detail") and len(get_event.event_detail)><cfoutput>#get_event.event_detail#</cfoutput></cfif></textarea>
                    </div>
                </div>
                <cfif isdefined("action_section_") and action_section_ is 'PROJECT_ID'>
                        <cfquery name="GET_PROJECT_NAME" datasource="#dsn#">
                            SELECT
                                PROJECT_HEAD
                            FROM 
                                PRO_PROJECTS
                            WHERE
                                PROJECT_ID = #action_id_#
                        </cfquery>
                <cfelseif isdefined("get_event.project_id") and  len(get_event.project_id)>
                    <cfquery name="GET_PROJECT_NAME" datasource="#DSN#">
                         SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_event.project_id#">
                    </cfquery>
                    <cfelseif isdefined("attributes.project_id") and  len(attributes.project_id)>
                    <cfquery name="GET_PROJECT_NAME" datasource="#DSN#">
                        SELECT PROJECT_HEAD FROM PRO_PROJECTS 
                        WHERE 
                        PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                    </cfquery>
                     <cfelseif isdefined("attributes.action_project_id") and  len(attributes.action_project_id)>
                        <cfquery name="GET_PROJECT_NAME" datasource="#DSN#">
                            SELECT PROJECT_HEAD FROM PRO_PROJECTS 
                            WHERE 
                            PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_project_id#">
                        </cfquery>
                </cfif>
                <div class="form-group" id="item-project_head">
                    <label class="col col-3 col-xs-12"><cf_get_lang_main no='4.Proje'></label>
                    <div class="col col-9 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("get_event.project_id") and len(get_event.project_id)><cfoutput>#get_event.project_id#</cfoutput><cfelseif isdefined('action_id_') and len(action_id_)><cfoutput>#action_id_#</cfoutput><cfelseif isdefined("attributes.project_id") and len(attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput><cfelseif isdefined("attributes.action_project_id") and len(attributes.action_project_id)><cfoutput>#attributes.action_project_id#</cfoutput></cfif>">
                            <input type="text" name="project_head" id="project_head" value="<cfif isdefined("get_event.project_id") and len(get_event.project_id) and isdefined('GET_PROJECT_NAME.PROJECT_HEAD') and len(GET_PROJECT_NAME.PROJECT_HEAD)><cfoutput>#GET_PROJECT_NAME.PROJECT_HEAD#</cfoutput><cfelseif isdefined('action_section') and len(action_section) and isdefined('GET_PROJECT_NAME.PROJECT_HEAD') and len(GET_PROJECT_NAME.PROJECT_HEAD)><cfoutput>#GET_PROJECT_NAME.PROJECT_HEAD#</cfoutput><cfelseif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined('GET_PROJECT_NAME.PROJECT_HEAD') and len(GET_PROJECT_NAME.PROJECT_HEAD)><cfoutput>#GET_PROJECT_NAME.PROJECT_HEAD#</cfoutput><cfelseif isdefined("attributes.action_project_id") and len(attributes.action_project_id) and isdefined('GET_PROJECT_NAME.PROJECT_HEAD') and len(GET_PROJECT_NAME.PROJECT_HEAD)><cfoutput>#GET_PROJECT_NAME.PROJECT_HEAD#</cfoutput></cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','250');" autocomplete="off" style="width:150px;">
                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_event.project_id&project_head=add_event.project_head');"></span>
                        </div>
                    </div>
                </div> 
                <cfif xml_camp_id eq 1 or xml_camp_id eq 2>
                    <div class="form-group" id="item-camp_name">
                        <label class="col col-3 col-xs-12"><cf_get_lang_main no='34.Kampanya'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfif xml_camp_id eq 2>*</cfif>
                                <cfif isdefined("get_event.camp_id") and len(get_event.camp_id)>
                                    <cfquery name="GET_CAMP_INFO" datasource="#DSN3#">
                                        SELECT CAMP_ID,CAMP_HEAD FROM CAMPAIGNS WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_event.camp_id#">
                                    </cfquery>
                                <cfelse>
                                    <cfset get_camp_info.camp_head = ''>
                                </cfif>
                                <cfoutput>
                                    <input type="hidden" name="camp_id" id="camp_id" value="<cfif isdefined("get_event.camp_id") and len(get_event.camp_id)>#get_event.camp_id#</cfif>">
                                    <input type="text" name="camp_name" id="camp_name" value="<cfif isdefined("get_event.camp_id") and len(get_event.camp_id)>#get_camp_info.camp_head#</cfif>" style="width:150px;">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_campaigns&field_id=add_event.camp_id&field_name=add_event.camp_name','list');"></span>
                                </cfoutput>    
                            </div>
                        </div>
                    </div>
                </cfif>
                <div class="form-group" id="item-work_head" style="height:30px;">
                    <label class="col col-3 col-xs-12"><cf_get_lang_main no='1033.İş'></label>
                    <div class="col col-9 col-xs-12">
                        <div class="input-group">
                            <cfif (isdefined("attributes.work_id") and len(attributes.work_id)) or (isdefined("get_event.work_id") and len(get_event.work_id)) or(isdefined("action_id__") and len(action_id__))>
                                <cfquery name="GET_WORK" datasource="#DSN#">
                                    SELECT 
                                    WORK_ID,
                                    WORK_HEAD,
                                    PROJECT_ID
                                    FROM 
                                        PRO_WORKS 
                                    WHERE 
                                        <cfif isdefined("get_event.work_id") and len(get_event.work_id)>
                                            WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_event.work_id#">
                                        <cfelseif isdefined("attributes.work_id") and len(attributes.work_id)>
                                            WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_id#">
                                        <cfelseif isdefined("action_id__") and len(action_id__)>
                                            WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#action_id__#">
                                        </cfif>
                                </cfquery>
                                <cfset attributes.project_id = get_work.project_id>
                                <cfset attributes.work_head = get_work.work_head>
                            <cfelse>
                                <cfset attributes.work_head = ''>
                            </cfif>
                            <input type="hidden" name="work_id" id="work_id" value="<cfif (isdefined("get_event.work_id") and len(get_event.work_id))><cfoutput>#get_event.work_id#</cfoutput><cfelseif isdefined("attributes.work_id") and len(attributes.work_id)><cfoutput>#attributes.work_id#</cfoutput><cfelseif isdefined("action_id__") and len(action_id__)><cfoutput>#action_id__#</cfoutput></cfif>">
                            <input type="text" name="work_head" id="work_head" style="width:150px;" value="<cfoutput>#attributes.work_head#</cfoutput>" onfocus="AutoComplete_Create('work_head','WORK_HEAD','WORK_HEAD','get_work','','WORK_ID','work_id','','3','150')">
                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac_work();"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-validator">
                    <label class="col col-3 col-xs-12"><cf_get_lang no='55.Onaylayacak'></label>
                    <div class="col col-9 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="validator_emp_id" id="validator_emp_id" value="">
                            <input type="hidden" name="validator_id" id="validator_id" value="">
                            <input type="hidden" name="validator_type" id="validator_type" value="">
                            <input type="text" name="validator" id="validator" style="width:150px;" value="">
                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_event.validator_id&field_id=add_event.validator_id&field_name=add_event.validator&field_emp_id=add_event.validator_emp_id&field_type=add_event.validator_type','list');"></span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group" id="item-event_place">
                    <label class="col col-4 col-xs-12"><cf_get_lang no ='83.Olay Yeri'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="event_place" id="event_place" style="width:65px;" onchange="checkOnline();">
                            <option value="" selected><cf_get_lang_main no='322.Seçiniz'></option>
                            <option value="1" <cfif isdefined("get_event.event_place_id") and get_event.event_place_id eq 1>selected</cfif>><cf_get_lang no='6.Ofis İçi'></option>
                            <option value="2" <cfif isdefined("get_event.event_place_id") and get_event.event_place_id eq 2>selected</cfif>><cf_get_lang no='10.Ofis Dışı'></option>
                            <option value="3" <cfif isdefined("get_event.event_place_id") and get_event.event_place_id eq 3>selected</cfif>><cf_get_lang no='12.Müşteri Ofisi'></option>
                            <option value="4" <cfif isdefined("get_event.event_place_id") and get_event.event_place_id eq 4>selected</cfif>><cf_get_lang dictionary_id='30015.Online'></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-form_ul_event_place_online">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30015.Online'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="text" id="place_online" name="place_online" value="<cfif isdefined('attributes.place_online') and len(attributes.place_online)><cfoutput>#attributes.place_online#</cfoutput></cfif>">
                            <a class="input-group-addon"<cfif isdefined('attributes.place_online') and len(attributes.place_online)> href="https://<cfoutput>#attributes.place_online#</cfoutput>"</cfif> rel="external" target="_blank"><i class="fa fa-coffee"></i></a>
                        </div>
                    </div>
                </div>
                <cfif xml_multiple_comp eq 1>            
                    <div class="form-group" id="item-agenda_company">
                        <label class="col col-4 col-xs-12"><cfoutput>#getLang('Objects2',533)#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <select name="agenda_company" multiple="multiple" style="width:150px">
                                <cfoutput query="get_companies">
                                    <option value="#comp_id#" <cfif session.ep.company_id eq comp_id>selected</cfif>>#NICK_NAME#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </cfif>
                <div class="form-group" id="item-startdate">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='243.Başlama Tarihi'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang_main no='326.Başlangıç Tarihini Giriniz!'></cfsavecontent>
                            <cfif isDefined("attributes.temp_date")>
                                <cfinput type="text" name="startdate" id="startdate" maxlength="10" required="Yes" validate="#validate_style#" message="#message#" style="width:65px;" value="#dateformat(attributes.temp_date,dateformat_style)#">
                            <cfelseif isdefined("get_event.startdate") and len(get_event.startdate)>
                                <cfinput type="text" name="startdate" id="startdate" maxlength="10" required="Yes" validate="#validate_style#" message="#message#" style="width:65px;" value="#dateformat(date_add('h', session.ep.time_zone, get_event.startdate),dateformat_style)#">
                            <cfelse>
                                <cfinput type="text" name="startdate" id="startdate" maxlength="10" required="Yes" validate="#validate_style#" message="#message#" style="width:65px;" value="#dateformat(now(),dateformat_style)#">
                            </cfif>
                            <span class="input-group-addon"> <cf_wrk_date_image date_field="startdate"> </span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-event_start_clock">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='79.Saat'>/<cf_get_lang_main no='1415.dk'></label>
                    <div class="col col-4 col-xs-6">
                        <cf_wrkTimeFormat name="event_start_clock" value="#attributes.hour#">
                    </div>
                    <div class="col col-4 col-xs-6">
                        <select name="event_start_minute" id="event_start_minute">
                            <cfloop from="0" to="55" index="a" step="5">
                                <cfoutput><option value="#Numberformat(a,00)#">#Numberformat(a,00)#</option></cfoutput>
                            </cfloop>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-finishdate">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='288.Bitiş Tarihi'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang_main no='327.Bitiş Tarihini Giriniz!'></cfsavecontent>
                    <cfif isDefined("attributes.temp_date")>
                        <cfinput type="text" name="finishdate" id="finishdate" maxlength="10" required="Yes" validate="#validate_style#" message="#message#" style="width:65px;" value="#dateformat(attributes.temp_date,dateformat_style)#">
                    <cfelseif isdefined("get_event.finishdate") and len(get_event.finishdate)>
                        <cfinput type="text" name="finishdate" id="finishdate" maxlength="10" required="Yes" validate="#validate_style#" message="#message#" style="width:65px;" value="#dateformat(date_add('h', session.ep.time_zone, get_event.finishdate),dateformat_style)#">
                    <cfelse>
                        <cfinput type="text" name="finishdate" id="finishdate" maxlength="10" required="Yes" validate="#validate_style#" message="#message#" style="width:65px;" value="#dateformat(now(),dateformat_style)#">
                    </cfif>
                        <span class="input-group-addon"> <cf_wrk_date_image date_field="finishdate"> </span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-event_finish_clock">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='79.Saat'>/<cf_get_lang_main no='1415.dk'></label>
                    <div class="col col-4 col-xs-6">
                        <cf_wrkTimeFormat name="event_finish_clock" value="#attributes.hour1#">
                    </div>
                    <div class="col col-4 col-xs-6">
                        <select name="event_finish_minute" id="event_finish_minute">
                            <cfloop from="0" to="55" index="a" step="5">
                                <cfoutput><option value="#Numberformat(a,00)#">#Numberformat(a,00)#</option></cfoutput>
                            </cfloop>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-warning_start">
                    <label class="col col-4 col-xs-12"><cf_get_lang no='17.Ajanda Uyarısı'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfif isdefined("get_event.warning_start") and  len(get_event.warning_start)>
                                <cfset warning_start = dateformat(date_add('h',session.ep.time_zone,get_event.warning_start),dateformat_style)>
                                <cfinput type="text" name="warning_start" id="warning_start" value="#warning_start#" style="width:65px;" required="No" validate="#validate_style#">
                            <cfelse>
                                <cfinput type="text" name="warning_start" id="warning_start" value="" required="No" validate="#validate_style#" style="width:65px;">
                            </cfif>
                            <span class="input-group-addon"> <cf_wrk_date_image date_field="warning_start"> </span>    
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-email_alert_day">
                    <label class="col col-4 col-xs-12"><cf_get_lang no='18.E-Mail Uyarı'></label>
                    <div class="col col-8 col-xs-12">
                        <cfif isdefined("get_event.warning_email") and isdefined("get_event.startdate") and  len(get_event.warning_email) and len(get_event.startdate)>
                            <cfset date_difference = datediff("d",get_event.warning_email, get_event.startdate)>
                            <cfelse>
                            <cfset date_difference = 0>
                        </cfif>
                        <div class="col col-6 col-xs-6">
                            <select name="email_alert_day" id="email_alert_day" style="width:65px;">
                                <option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
                                <option value="1" <cfif date_difference eq 1>selected</cfif>>1</option>
                                <option value="2" <cfif date_difference eq 2>selected</cfif>>2</option>
                                <option value="3" <cfif date_difference eq 3>selected</cfif>>3</option>
                                <option value="4" <cfif date_difference eq 4>selected</cfif>>4</option>
                                <option value="5" <cfif date_difference eq 5>selected</cfif>>5</option>
                                <option value="6" <cfif date_difference eq 6>selected</cfif>>6</option>
                                <option value="7" <cfif date_difference eq 7>selected</cfif>>7</option>
                                <option value="10" <cfif date_difference eq 10>selected</cfif>>10</option>
                                <option value="15" <cfif date_difference eq 15>selected</cfif>>15</option>
                                <option value="30" <cfif date_difference eq 30>selected</cfif>>30</option>
                                <option value="60" <cfif date_difference eq 60>selected</cfif>>60</option>
                                <option value="90" <cfif date_difference eq 90>selected</cfif>>90</option>
                            </select>
                        </div>
                        <cfif isdefined("get_event.warning_email") and isdefined("get_event.startdate") and  len(get_event.warning_email) and len(get_event.startdate)>
                            <cfset date_difference = datediff("h",get_event.warning_email, get_event.startdate) mod 24>
                            <cfset date_diff2 = datediff("n",get_event.warning_email,get_event.startdate) mod 60>
                            <cfelse>
                            <cfset date_difference = 0>
                            <cfset date_diff2 = 0>
                        </cfif>
                        <div class="col col-6 col-xs-6">
                            <select name="email_alert_hour" id="email_alert_hour" style="width:65px;">
                                <option value="0" <cfif date_difference eq 0>selected</cfif>><cf_get_lang_main no='322.Seçiniz'></option>
                                <option value="0.25" <cfif date_diff2 eq 15>selected</cfif>>15 <cf_get_lang_main no='1415.dk'></option>
                                <option value="0.5" <cfif date_diff2 eq 30>selected</cfif>>30 <cf_get_lang_main no='1415.dk'></option>
                                <option value="1" <cfif date_difference eq 1>selected</cfif>>1</option>
                                <option value="2" <cfif date_difference eq 2>selected</cfif>>2</option>
                                <option value="3" <cfif date_difference eq 3>selected</cfif>>3</option>
                                <option value="4" <cfif date_difference eq 4>selected</cfif>>4</option>
                                <option value="5" <cfif date_difference eq 5>selected</cfif>>5</option>
                                <option value="6" <cfif date_difference eq 6>selected</cfif>>6</option>
                                <option value="7" <cfif date_difference eq 7>selected</cfif>>7</option>
                                <option value="8" <cfif date_difference eq 8>selected</cfif>>8</option>
                                <option value="9" <cfif date_difference eq 9>selected</cfif>>9</option>
                                <option value="10" <cfif date_difference eq 10>selected</cfif>>10</option>
                                <option value="12" <cfif date_difference eq 12>selected</cfif>>12</option>
                                <option value="16" <cfif date_difference eq 16>selected</cfif>>16</option>
                                <option value="18" <cfif date_difference eq 18>selected</cfif>>18</option>
                            </select>	
                        </div>
                    </div>
                </div> 
                <div class="form-group" id="item-sms_alert_day">
                    <label class="col col-4 col-xs-12"><cf_get_lang no='19.SMS Uyarı'></label>
                    <div class="col col-8 col-xs-12">
                        <cfif isdefined("get_event.warning_sms") and  len(get_event.warning_sms) and isdefined("get_event.startdate") and len(get_event.startdate)>
                            <cfset date_difference = datediff("d",get_event.warning_sms, get_event.startdate)>
                        <cfelse>
                            <cfset date_difference = 0>
                        </cfif>
                        <div class="col col-6 col-xs-6">
                            <select name="sms_alert_day" id="sms_alert_day" style="width:65px;">
                                <option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
                                <option value="1" <cfif date_difference eq 1>selected</cfif>>1</option>
                                <option value="2" <cfif date_difference eq 2>selected</cfif>>2</option>
                                <option value="3" <cfif date_difference eq 3>selected</cfif>>3</option>
                                <option value="4" <cfif date_difference eq 4>selected</cfif>>4</option>
                                <option value="5" <cfif date_difference eq 5>selected</cfif>>5</option>
                                <option value="6" <cfif date_difference eq 6>selected</cfif>>6</option>
                                <option value="7" <cfif date_difference eq 7>selected</cfif>>7</option>
                                <option value="10" <cfif date_difference eq 10>selected</cfif>>10</option>
                                <option value="15" <cfif date_difference eq 15>selected</cfif>>15</option>
                                <option value="30" <cfif date_difference eq 30>selected</cfif>>30</option>
                                <option value="60" <cfif date_difference eq 60>selected</cfif>>60</option>
                                <option value="90" <cfif date_difference eq 90>selected</cfif>>90</option>
                            </select>
                        </div>	
                        <cfif isdefined("get_event.warning_sms") and len(get_event.warning_sms)>
                            <cfset date_difference = datediff("h",get_event.warning_sms, get_event.startdate) mod 24>
                            <cfset date_diff2 = datediff("n",get_event.warning_sms,get_event.startdate) mod 60>
                            <cfelse>
                            <cfset date_difference = 0>
                            <cfset date_diff2 = 0>
                        </cfif>
                        <div class="col col-6 col-xs-6">
                            <select name="sms_alert_hour" id="sms_alert_hour" style="width:65px;"> 
                                <option value="0" <cfif date_difference eq 0>selected</cfif>><cf_get_lang_main no='322.Seçiniz'></option>
                                <option value="0.25" <cfif date_diff2 eq 15>selected</cfif>>15 <cf_get_lang_main no='1415.dk'></option>
                                <option value="0.5" <cfif date_diff2 eq 30>selected</cfif>>30 <cf_get_lang_main no='1415.dk'></option>
                                <option value="1" <cfif date_difference eq 1>selected</cfif>>1</option>
                                <option value="2" <cfif date_difference eq 2>selected</cfif>>2</option>
                                <option value="3" <cfif date_difference eq 3>selected</cfif>>3</option>
                                <option value="4" <cfif date_difference eq 4>selected</cfif>>4</option>
                                <option value="5" <cfif date_difference eq 5>selected</cfif>>5</option>
                                <option value="6" <cfif date_difference eq 6>selected</cfif>>6</option>
                                <option value="7" <cfif date_difference eq 7>selected</cfif>>7</option>
                                <option value="8" <cfif date_difference eq 8>selected</cfif>>8</option>
                                <option value="9" <cfif date_difference eq 9>selected</cfif>>9</option>
                                <option value="10" <cfif date_difference eq 10>selected</cfif>>10</option>
                                <option value="12" <cfif date_difference eq 12>selected</cfif>>12</option>
                                <option value="16" <cfif date_difference eq 16>selected</cfif>>16</option>
                                <option value="18" <cfif date_difference eq 18>selected</cfif>>18</option>
                            </select>	
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-warning" style="height:30px;">
                    <label class="col col-4 col-xs-12"><cf_get_lang no='20.Olay Tekrarı'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="warning" id="warning" onchange="show_warn(this.selectedIndex);" style="width:65px;">
                            <option value="0" selected><cf_get_lang_main no='1134.Yok'></option>
                            <option value="1" <cfif isdefined("get_event.link_id") and  len(get_event.link_id) and get_event_count.EVENT_COUNT gt 1>selected</cfif>><cf_get_lang no='62.Periodik'></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-warning_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='52.Tekrar'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="col col-4 col-xs-12">
                                <input type="radio" name="warning_type" id="warning_type" <cfif isdefined("fark") and fark eq 1>checked</cfif> value="1"><cf_get_lang dictionary_id='47948.Günde Bir'>
                            </div>
                            <div class="col col-4 col-xs-12">
                                <input type="radio" name="warning_type" id="warning_type" <cfif isdefined("fark") and fark eq 7>checked</cfif> value="7"><cf_get_lang no='50.Haftada Bir'>
                            </div>
                            <div class="col col-4 col-xs-12">  
                                <input type="radio" name="warning_type" id="warning_type" <cfif isdefined("fark") and fark eq 30>checked</cfif> value="30"><cf_get_lang no='53.Ayda Bir'>
                            </div>
                        </div>
                </div>
                <div class="form-group" id="item-warning_count" style="height:30px;">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='49.Tekrar Sayısı'></label>
                        <div class="col col-4 col-xs-12">
                            <cfset message5="<cf_get_lang no='36.Tekrar Sayısı Tam Sayı Olmalıdır !'>">
                        <cfif isdefined("get_event_count.event_count") and  get_event_count.event_count gt 1>
                            <cfinput type="text" name="warning_count" id="warning_count" value="#get_event_count.event_count#" readonly passthrough="onkeyup=""return(formatcurrency(this,event,0));""" class="moneybox" maxlength="2" style="width:50px;">
                        <cfelse>
                            <cfinput type="text" name="warning_count" id="warning_count" value="" passthrough="onkeyup=""return(formatcurrency(this,event,0));""" validate="integer" message="#message5#" class="moneybox" maxlength="2" style="width:50px;">
                        </cfif>
                        </div>
                        <div class="col col-4 col-xs-12">
                        <label class="col col-2 col-xs-12"><cf_get_lang no='54.Kez'></label>
                    </div>
                </div>
            </div> 
            <div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                <div class="form-group" id="item-view_to_all">
                    <cfsavecontent variable="header_"><cf_get_lang no='21.Bu olayı herkes görsün'></cfsavecontent>
                    <label><input type="Checkbox" name="view_to_all" id="view_to_all" value="1" <cfif isdefined("get_event.view_to_all") and  get_event.view_to_all eq 1 and not len(get_event.is_wiew_branch) and not len(get_event.is_wiew_department) >checked</cfif> onclick="wiew_control(1);"><cf_get_lang no='21.Bu olayı herkes görsün'></label> 
                </div>
                <cfquery name="FIND_DEPARTMENT_BRANCH" datasource="#DSN#">
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
                            EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
                            DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
                            EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> 
                </cfquery>
                <div class="form-group" id="item-is_wiew_branch">
                    <cfsavecontent variable="header_"><cf_get_lang_main no='502.Şubemdeki Herkes Görsün'></cfsavecontent>
                    <label><input type="checkbox" name="is_wiew_branch" id="is_wiew_branch" <cfif isdefined("get_event.is_wiew_branch") and  len(get_event.is_wiew_branch)and not len(get_event.is_wiew_department)>checked</cfif>  value="<cfoutput>#find_department_branch.branch_id#</cfoutput>" onclick="wiew_control(2);"><cf_get_lang_main no='502.Şubemdeki Herkes Görsün'></label>
                </div>
                <div class="form-group" id="item-is_wiew_department">
                    <cfsavecontent variable="header_"><cf_get_lang_main no='503.Departmanımdaki Herkes Görsün'></cfsavecontent>
                    <input type="hidden" name="is_wiew_branch_" id="is_wiew_branch_" value="<cfoutput>#find_department_branch.branch_id#</cfoutput>">
                    <label><input type="checkbox" name="is_wiew_department" id="is_wiew_department" <cfif isdefined("get_event.is_wiew_department") and  len(get_event.is_wiew_department)>checked</cfif> value="<cfoutput>#find_department_branch.department_id#</cfoutput>" onclick="wiew_control(3);"><cf_get_lang_main no='503.Departmanımdaki Herkes Görsün'></label>
                </div>
                <div class="form-group" id="item-is_view_comp">
                    <cfsavecontent variable="header_"><cfoutput>#getLang('Objects',1091)#</cfoutput></cfsavecontent>
                    <label><input type="checkbox" name="is_view_comp" id="is_view_comp" <cfif isdefined("get_event.is_view_company") and  len(get_event.is_view_company)>checked</cfif> value="1" onclick="wiew_control(4);" ><cfoutput>#getLang('Objects',1091)#</cfoutput></label>
                </div>
                <cfif isdefined('x_is_net_display') and (x_is_net_display eq 1)>
                    <div class="form-group" id="item-is_internet">
                        <cfsavecontent variable="header_"><cf_get_lang no ='97.İnternette Gözüksün'></cfsavecontent>
                        <label><input type="Checkbox" name="is_internet" id="is_internet" value="1" <cfif isdefined("get_event.is_internet") and  get_event.is_internet eq 1>checked</cfif> onclick="gizle_goster(is_site_agenda);"><cf_get_lang no ='97.İnternette Gözüksün'></label>
                    </div>
                </cfif>
                <div class="form-group" id="item-is_google_cal">
                    <cfsavecontent variable="header_"><cfoutput><cf_get_lang dictionary_id='64162.Google Takvimde Görünsün'></cfoutput></cfsavecontent>
                    <label><input type="checkbox" name="is_google_cal" id="is_google_cal" value="1"><cfoutput><cf_get_lang dictionary_id='64162.Google Takvimde Görünsün'></cfoutput></label>
                </div>
                <cfinput name="googleEventId" id="googleEventId" value="" type="hidden">
                <cfinput name="meetLink" id="meetLink" value="" type="hidden">
            </div>
            <div class="col col-12 col-md-12 col-xs-12" type="column" index="4" sort="true">
                <input type="hidden" name="tos" id="tos" value="">
                <input type="hidden" name="ccs" id="ccs" value="">
                <div class="col col-4 co-md-4 col-xs-12">
                    <cfsavecontent variable="txt_2"><cf_get_lang_main no='178.Katılımcılar'></cfsavecontent>
                    <cfoutput></cfoutput>
                    <cfif isdefined("attributes.partner_id")>
                        <cf_workcube_to_cc 
                            is_update="1" 
                            to_dsp_name="#txt_2#"
                            form_name="add_event" 
                            str_list_param="1,7,8" 
                            action_dsn="#DSN#"
                            str_action_names="PARTNER_ID AS TO_PAR"
                            action_table="COMPANY_PARTNER"
                            action_id_name="PARTNER_ID"
                            action_id="#attributes.partner_id#"
                            data_type="1"
                            str_alias_names="">
                        <cfelseif isdefined('attributes.consumer_id')>
                        <cf_workcube_to_cc 
                            is_update="1" 
                            to_dsp_name="#txt_2#"
                            form_name="add_event" 
                            str_list_param="1,7,8" 
                            action_dsn="#DSN#"
                            str_action_names="CONSUMER_ID AS TO_CON"
                            action_table="CONSUMER"
                            action_id_name="CONSUMER_ID"
                            action_id="#attributes.consumer_id#"
                            data_type="1"
                            str_alias_names="">
                        <cfelseif isdefined("attributes.EVENT_ID") and len(attributes.EVENT_ID)>
                        <cf_workcube_to_cc 
                            is_update="1" 
                            to_dsp_name="#txt_2#"
                            form_name="upd_event" 
                            str_list_param="1,7,8" 
                            action_dsn="#DSN#"
                            str_action_names="EVENT_TO_POS AS TO_EMP,EVENT_TO_PAR AS TO_PAR,EVENT_TO_CON TO_CON,EVENT_TO_GRP AS TO_GRP,EVENT_TO_WRKGROUP AS TO_WRKGROUP ,EVENT_CC_POS AS CC_EMP,EVENT_CC_PAR AS CC_PAR,EVENT_CC_CON AS CC_CON,EVENT_CC_GRP AS CC_GRP,EVENT_CC_WRKGROUP AS CC_WRKGROUP"
                            action_table="EVENT"
                            action_id_name="EVENT_ID"
                            action_id="#attributes.EVENT_ID#"
                            data_type="1"
                            str_alias_names="">
                        <cfelse>
                        <cf_workcube_to_cc 
                        is_update="0" 
                        to_dsp_name="#txt_2#"
                        form_name="add_event" 
                        str_list_param="1,7,8" 
                        data_type="1"> 
                    </cfif>
                </div>
                <div class="col col-4 co-md-4 col-xs-12">
                    <cfsavecontent variable="txt_1"><cf_get_lang no='16.Bilgi Verilecekler'></cfsavecontent>
                    <cfoutput></cfoutput>
                    <cfif isdefined("attributes.partner_id")>
                        <cf_workcube_to_cc 
                            is_update="1" 
                            cc_dsp_name="#txt_1#" 
                            form_name="add_event" 
                            str_list_param="1,7,8" 
                            action_dsn="#DSN#"
                            str_action_names="PARTNER_ID AS TO_PAR"
                            action_table="COMPANY_PARTNER"
                            action_id_name="PARTNER_ID"
                            action_id="#attributes.partner_id#"
                            data_type="1"
                            str_alias_names="">
                        <cfelseif isdefined('attributes.consumer_id')>
                        <cf_workcube_to_cc 
                            is_update="1" 
                            cc_dsp_name="#txt_1#" 
                            form_name="add_event" 
                            str_list_param="1,7,8" 
                            action_dsn="#DSN#"
                            str_action_names="CONSUMER_ID AS TO_CON"
                            action_table="CONSUMER"
                            action_id_name="CONSUMER_ID"
                            action_id="#attributes.consumer_id#"
                            data_type="1"
                            str_alias_names="">
                        <cfelseif isdefined("attributes.EVENT_ID") and len(attributes.EVENT_ID)>
                        <cf_workcube_to_cc 
                            is_update="1" 
                            cc_dsp_name="#txt_1#" 
                            form_name="upd_event" 
                            str_list_param="1,7,8" 
                            action_dsn="#DSN#"
                            str_action_names="EVENT_TO_POS AS TO_EMP,EVENT_TO_PAR AS TO_PAR,EVENT_TO_CON TO_CON,EVENT_TO_GRP AS TO_GRP,EVENT_TO_WRKGROUP AS TO_WRKGROUP ,EVENT_CC_POS AS CC_EMP,EVENT_CC_PAR AS CC_PAR,EVENT_CC_CON AS CC_CON,EVENT_CC_GRP AS CC_GRP,EVENT_CC_WRKGROUP AS CC_WRKGROUP"
                            action_table="EVENT"
                            action_id_name="EVENT_ID"
                            action_id="#attributes.EVENT_ID#"
                            data_type="1"
                            str_alias_names="">
                        <cfelse>
                        <cf_workcube_to_cc 
                            is_update="0"
                            cc_dsp_name="#txt_1#" 
                            form_name="add_event" 
                            str_list_param="1,7,8" 
                            data_type="1"> 
                    </cfif>
                </div>
                <div class="col col-4 col-md-4 col-xs-12">
                    <cfset int_row=0>
                    <table class="ajax_list">  
                        <thead>  
                            <tr>
                                <th width="20">
                                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_name=branches&field_row_name=branch_row&field_row_count=row_count&last_record=last_record&coklu_secim=1&ajanda=1','list');">
                                        <i class="fa fa-plus"></i>
                                    </a>
                                </th>
                                <th>
                                    <cf_get_lang_main no="1637.Şubeler">
                                    <input type="hidden" name="row_count" id="row_count" value="<cfoutput><cfif isdefined("get_event.event_to_branch") and len(get_event.event_to_branch)>#listlen(get_event.event_to_branch)#<cfelse>#int_row#</cfif></cfoutput>">
                                    <input type="hidden" name="last_record" id="last_record" value="<cfoutput><cfif isdefined("get_event.event_to_branch") and len(get_event.event_to_branch)>#listlen(get_event.event_to_branch)#<cfelse>#int_row#</cfif></cfoutput>">
                                </th>
                            </tr>
                        </thead> 
                        <tbody  id="branches">
                            <cfif isdefined("get_event.event_to_branch") and len(get_event.event_to_branch)>
                                <cfloop from="1" to="#listlen(get_event.event_to_branch)#" index="i">
                                        <tr id="branch_row<cfoutput>#i#</cfoutput>">
                                            <cfquery name="GET_BRANCH" datasource="#DSN#">
                                                SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(get_event.event_to_branch,i,',')#">
                                            </cfquery>	
                                           <td> <a href="javascript://" onclick="del_row(<cfoutput>#i#</cfoutput>);"><i class="fa fa-minus"></i></a><input type="hidden" name="row_count" id="row_count" value="<cfoutput>#i#</cfoutput>"><input type="hidden" name="branch_id<cfoutput>#i#</cfoutput>" id="branch_id<cfoutput>#i#</cfoutput>" value="<cfoutput>#listgetat(get_event.event_to_branch,i,',')#</cfoutput>">
                                           <td><cfoutput>#get_branch.branch_name#</cfoutput></td>
                                        </tr>
                                </cfloop>
                            </cfif>    				
                                <tr id="branch_row<cfoutput><cfif isdefined("get_event.event_to_branch") and len(get_event.event_to_branch)>#listlen(get_event.event_to_branch)#</cfif>#int_row#</cfoutput>"></tr> 
                        </tbody> 
                    </table>
                </div>  
                <div class="col col-12 col-md-12 col-xs-12" style="margin-top:1%; margin-left:4px; height:30px;"><input type="button" value="<cf_get_lang no ='88.Katılımcı Durumu'>" onclick="control();" style="background:#69b56c;"></div>
                <div class="col col-12 col-md-12 col-xs-12" id="control_joining_id"></div>
            </div>
            <div class="col col-12 col-xs-12">
                <cfif get_site_menu.recordcount>
                    <cfif isdefined('get_event_site_domain.menu_id')>
                        <cfset my_event_site_list = valuelist(get_event_site_domain.menu_id)>
                    <cfelse>
                        <cfset my_event_site_list= "">
                    </cfif>
                    <table id="is_site_agenda" style="display:none; width:100%; vertical-align:top;">
                        <tr>
                            <td>
                                <cf_seperator header="#getLang('agenda',98)#" id="actives_site" is_closed="1">
                                <table id="actives_site" style="display:none;">
                                    <cfoutput query="get_site_menu">
                                        <tr>
                                            <td><input type="checkbox" name="menu_#menu_id#" id="menu_#menu_id#" value="#menu_id#" <cfif isdefined('my_event_site_list') and  len(my_event_site_list) and ListFindNoCase(my_event_site_list,get_site_menu.menu_id,',')> checked </cfif>>#site_domain#&nbsp;</td>
                                        </tr>
                                    </cfoutput>
                                </table>
                            </td>
                        </tr>
                    </table>
                </cfif>
                <input type="hidden" name="reserve" id="reserve" value="">
            </div> 
        </cf_box_elements>
        <div class="ui-form-list-btn">	
            <cfif xml_email_send_active eq 1>
                <cfsavecontent variable="message"><cf_get_lang no='92.Kaydet ve Mail Gönder'></cfsavecontent>
                <cf_workcube_buttons type_format="1" is_upd='0' insert_info='#message#' add_function='check(1)' is_cancel='0'>
            </cfif>
            <cf_workcube_buttons type_format="1" is_upd='0' is_cancel='1' add_function='check(0)'>
        </div>
    </cf_box>
</cfform>
<script async defer src="https://apis.google.com/js/api.js"></script>
<script type="text/javascript">
	<cfif isdefined("get_event.link_id") and  len(get_event.link_id) and get_event_count.EVENT_COUNT gt 1>
		show_warn(1);
	</cfif> 
	//XML acik ve kopyalanan olayda internetde goster secili ise
	<cfif isdefined('x_is_net_display') and (x_is_net_display eq 1) and (isdefined("get_event.is_internet") and  get_event.is_internet eq 1)>
		goster(is_site_agenda);
	</cfif>

    function checkOnline(){
        if($('#is_google_cal').is(':checked')) {
            var event_place = document.getElementById('event_place').value;
            if(event_place == 4){
                $('#place_online').prop( "disabled", true );
                $('#place_online').attr("placeholder", "<cf_get_lang dictionary_id='33937.Meet Linki Otomatik Oluşturulacak'>");
                $('#place_online').val("");
                $('#form_ul_event_place_online a').prop( "disabled", true );
            }else{
                $('#place_online').prop( "disabled", false );
                $('#place_online').attr("placeholder", "");
                $('#form_ul_event_place_online a').prop( "disabled", false );
            }
        }
    }

    $('#is_google_cal').change(function() { // otomatik meet linki oluşturmak için eklendi

        if($(this).is(':checked')) {
            var event_place = document.getElementById('event_place').value;
            if(event_place == 4){
                $('#place_online').prop( "disabled", true );
                $('#place_online').attr("placeholder", "<cf_get_lang dictionary_id='33937.Meet Linki Otomatik Oluşturulacak'>");
                $('#place_online').val("");
                $('#form_ul_event_place_online a').prop( "disabled", true );
            }
        }else{
            $('#place_online').prop( "disabled", false );
            $('#place_online').attr("placeholder", "");
            $('#form_ul_event_place_online a').prop( "disabled", false );
        }
    });
    
	function check(type)
	{
        function formatDate(date) {
            var d = new Date(date),
                month = '' + (d.getMonth() + 1),
                day = '' + d.getDate(),
                year = d.getFullYear();

            if (month.length < 2) 
                month = '0' + month;
            if (day.length < 2) 
                day = '0' + day;

            return [day, month, year];
        }
        
		if(type==0)
		{
			document.getElementById('send_mail_agenda').value='0'; //Kaydet
		}
		else if(type==1)
		{
			document.getElementById('send_mail_agenda').value='1'; //Kaydet ve mail gönder
		}
		if (document.getElementById('eventcat_id').value == 0)
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'>:<cf_get_lang no='26.Olay Kategorisi'>");
			return false;
		}
		if(document.add_event.warning.selectedIndex == 1)
		{
			if(document.getElementById('warning_count').value == "")
			{
				alert("<cf_get_lang no='49.Tekrar sayısı !'>");
				return false;
			}
			
			if(document.getElementById('warning_count').value != "")
				if(document.getElementById('warning_count').value < 2)
				{
					alert("<cf_get_lang no='35.Tekrar sayısı 1 den büyük olmalı !'>");
					return false;
				}
			if(document.add_event.warning.selectedIndex == 1)
			{
				if(document.getElementById('warning_count').value != "")
					if(document.getElementById('warning_count').value < 2)
					{
						alert("<cf_get_lang no='35.Tekrar sayısı 1 den büyük olmalı !'>");
						return false;
					}
					if(((document.add_event.warning_type[0].checked=="false") || (document.add_event.warning_type[1].checked=="false")))
					{
						alert("<cf_get_lang no='34.Tekrar Periyodu !'>");
						return false;
					}
			}
		}		
		if((document.getElementById('startdate').value != "") && (document.getElementById('finishdate').value != ""))
		{
			if (!time_check(add_event.startdate, add_event.event_start_clock, add_event.event_start_minute, add_event.finishdate,  add_event.event_finish_clock, add_event.event_finish_minute, "<cf_get_lang no ='40.Olay Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır '>"))
				return false;
			
		}
		if((document.getElementById('warning_start').value != "") && (document.getElementById('startdate').value != ""))
		{
			if (!date_check(add_event.warning_start,add_event.startdate,"<cf_get_lang no='39.Uyarı Tarihi Olay Başlama Tarihinden Önce Olmalıdır'>!"))
				return false;
		}
		<cfif xml_camp_id eq 2>
			if( document.getElementById('camp_id').value == '' || document.getElementById('camp_name').value == '')
			{
				alert("<cf_get_lang no ='101.Lütfen Kampanya Seçiniz'>!");
				return false;
			}
		</cfif>
		
        if ($('#is_google_cal').prop('checked')){
            $( "form#add_event" ).submit(function( event ) {
		        
                if ($('#is_google_cal').prop('checked')){
                    var dateString = $('#startdate').val();
                    var dateParts = dateString.split("/");
                    var startDateNew = new Date(+dateParts[2], dateParts[1] - 1, +dateParts[0]);
                    var startDateDay = formatDate(startDateNew)[0];
                    var startDateMonth = formatDate(startDateNew)[1];
                    var startDateYear = formatDate(startDateNew)[2];
                    var startClockNew = document.add_event.event_start_clock.value;
                    var startMinuteNew = document.add_event.event_start_minute.value;

                    var finishDateString = $('#finishdate').val();
                    var finishDateParts = finishDateString.split("/");
                    var finishDateNew = new Date(+finishDateParts[2], finishDateParts[1] - 1, +finishDateParts[0]);
                    var finishDateDay = formatDate(finishDateNew)[0];
                    var finishDateMonth = formatDate(finishDateNew)[1];
                    var finishDateYear = formatDate(finishDateNew)[2];
                    var finishClockNew = document.add_event.event_finish_clock.value;
                    var finishMinuteNew = document.add_event.event_finish_minute.value;

                    var eventStartTime = startDateYear + "-" + ("0" + startDateMonth).slice(-2) + "-" + ("0" + startDateDay).slice(-2) + "T" + startClockNew + ":" + startMinuteNew + ":00.000";
                    var eventFinishTime = finishDateYear + "-" + ("0" + finishDateMonth).slice(-2) + "-" + ("0" + finishDateDay).slice(-2) + "T" + finishClockNew + ":" + finishMinuteNew + ":00.000";
                    var timeZone = "<cfoutput>#server.system.properties.user.timezone#</cfoutput>";
                    signInGoogle(eventStartTime, eventFinishTime, timeZone);
                }
                event.preventDefault(); // don't submit this
                return false;
            });
        }else{
		    return process_cat_control();
        }
	}	

	function show_warn(i)
	{
		/* uyarı var*/
		if(i == 0)
		{
			/*tek uyarı açık*/
			document.getElementById('item-warning_type').style.display = 'none';
			document.getElementById('item-warning_count').style.display = 'none';
		}
		if(i == 1)
		{
			/*çoklu uyarı açık*/
			document.getElementById('item-warning_type').style.display = '';
			document.getElementById('item-warning_count').style.display = '';
		}
			
	}
	<cfif not isdefined("attributes.event_id")>
		show_warn(0);
	</cfif>
	function sil_secilen(int_sec)
	{
		if(int_sec==1)
		{
			document.all.spec_names.value='';
			document.all.specs.value='';					
		}
		else
		{
			document.all.join_names.value='';
			document.all.joins.value='';
		}
	}
	function wiew_control(type)
	{
		if(type==1)
		{
			document.add_event.is_wiew_branch.checked=false;
			document.add_event.is_wiew_department.checked=false;
			document.getElementById('is_view_comp').checked =false;
		}
		if(type==2)
		{
			document.add_event.view_to_all.checked=false;
			document.add_event.is_wiew_department.checked=false;
			document.getElementById('is_view_comp').checked =false;
		}
		if(type==3)
		{
			document.add_event.view_to_all.checked=false;
			document.add_event.is_wiew_branch.checked=false;
			document.getElementById('is_view_comp').checked =false;
		}
		if(type==4)
		{
			document.add_event.view_to_all.checked=false;
			document.add_event.is_wiew_branch.checked=false;
			document.add_event.is_wiew_department.checked=false;
			<cfif xml_multiple_comp eq 1>
				if(document.getElementById('is_view_comp').checked ==false)
					document.getElementById('form_ul_agenda_company').style.display = 'none';
				else
					document.getElementById('form_ul_agenda_company').style.display = '';
			</cfif>
		}

	}
	function control()
	{
		if(document.getElementById('to_emp_ids') == undefined)
		{
			alert("<cf_get_lang no ='84.Katılımcı Ekleyiniz'>!");
			return false;
		}
		if( document.add_event.startdate.value == '' || document.add_event.finishdate.value == '')
		{
			alert("<cf_get_lang no ='85.Lütfen Tarih Aralığı Giriniz'>!");
			return false;
		}
		list_to_emp_ids= '';
		if(document.getElementById('to_emp_ids').value != undefined && document.all.to_emp_ids.length == undefined)
			list_to_emp_ids=document.all.to_emp_ids.value;
		else
		{
			for(i=0;i<document.all.to_emp_ids.length;i++)
				list_to_emp_ids+=','+document.all.to_emp_ids[i].value;
		}
		var send_adress='<cfoutput>#request.self#?fuseaction=agenda.emptypopup_control_joining&startdate='+document.add_event.startdate.value+'&finishdate='+document.add_event.finishdate.value+'&event_start_clock='+document.add_event.event_start_clock.value+'&event_finish_clock='+document.add_event.event_finish_clock.value+'&event_start_minute='+document.add_event.event_start_minute.value+'&event_finish_minute='+document.add_event.event_finish_minute.value+'</cfoutput>&list_to_emp_ids='+list_to_emp_ids;
		AjaxPageLoad(send_adress,'control_joining_id',1,'Katılımcılar Kontrol Ediliyor.');
		
	 }
	 
	 function del_row(id)
	 { 
		eval("document.all.branch_id"+id).value = "";
		eval("document.all.branch_row"+id).style.display="none";
		document.getElementById('row_count').value = document.getElementById('row_count').value - 1; 
	 }
 
 	function pencere_ac_work()
	{
		p_id_ = document.getElementById("project_id").value;
		p_name_ = document.getElementById("project_head").value;
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&field_id=add_event.work_id&field_name=add_event.work_head&project_id=' + p_id_ + '&project_head=' + p_name_ +'','list');
	}
    var googleCalEventsListed = 0; // listelenen olaylar yinelenmesin diye eklendi
    var CLIENT_ID = '';
    var CLIENT_SECRET = '';
    var API_KEY = '';
    var DISCOVERY_DOCS = [];
    var SCOPES = "";
    var type = "add"; // add, upd ve list seçenkelerinden uygun olan, burada tanımlanmalıdır.
    var googleSignInMessage = "<cf_get_lang dictionary_id='64111.Google Hesabınızla Giriş Yapmalısınız!'>";
    function signInGoogle(eventStartTime='', eventFinishTime='', timeZone=''){
        <cfset googleapi = createObject("component","WEX.google.cfc.google_api")>
        <cfset get_api_key = googleapi.get_api_key()>
        if(<cfoutput>#len(get_api_key.GOOGLE_API_KEY)#</cfoutput> && <cfoutput>#len(get_api_key.GOOGLE_CLIENT_ID)#</cfoutput> && <cfoutput>#len(get_api_key.GOOGLE_CLIENT_SECRET)#</cfoutput>){
            CLIENT_ID = '<cfoutput>#get_api_key.GOOGLE_CLIENT_ID#</cfoutput>';
            CLIENT_SECRET = '<cfoutput>#get_api_key.GOOGLE_CLIENT_SECRET#</cfoutput>';
            API_KEY = '<cfoutput>#get_api_key.GOOGLE_API_KEY#</cfoutput>';

            // Array of API discovery doc URLs for APIs used by the quickstart
            DISCOVERY_DOCS = ["https://www.googleapis.com/discovery/v1/apis/calendar/v3/rest"];
            // Authorization scopes required by the API; multiple scopes can be
            // included, separated by spaces.
            SCOPES = "https://www.googleapis.com/auth/calendar.readonly https://www.googleapis.com/auth/calendar";
            handleClientLoad(eventStartTime, eventFinishTime, timeZone);
        }else{
            alert("<cf_get_lang dictionary_id='61524.API Key'>, <cf_get_lang dictionary_id='64109.CLIENT_ID'>, <cf_get_lang dictionary_id='64110.CLIENT_SECRET'> bilgilerinin girilmesi gerekiyor.");
            return false;
        }
    }
</script>
<script src="JS/google_ws/google_calendar_init.js"></script>