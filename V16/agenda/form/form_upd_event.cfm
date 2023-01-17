<!---E.A 17.07.2012 select ifadeleri ile ilgili çalışma yapıldı.--->
<cfsetting showdebugoutput="YES">
<cf_get_lang_set module_name="agenda">
<cf_xml_page_edit fuseact="agenda.form_add_event">
<cfparam name="url.fromagenda" default="0">
<cfif not isnumeric(attributes.event_id)>
	<cfset hata = 10>
	<cfinclude template="../../dsp_hata.cfm">
	<cfexit method="exittemplate">
</cfif>
<cfif not isdefined("control_all_")>
	<cfset control_all_ = 1>
</cfif>
<cfinclude template="../query/get_event.cfm">
<cfquery name="GET_EVENT_COMPANY" datasource="#DSN#">
	SELECT COMPANY_ID FROM EVENT_COMPANY WHERE EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#">
</cfquery>
<cfquery name="GET_COMPANIES" datasource="#DSN#">
    SELECT COMP_ID,NICK_NAME FROM OUR_COMPANY ORDER BY COMPANY_NAME
</cfquery>
<cfset comp_list = valuelist(get_event_company.company_id)>
<cfif (not get_event.recordcount)>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'>!</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
	<cfinclude template="../query/get_event_cats.cfm">
	<!--- BK partner tarafında da kayıt atildigi icin eklendi bu blok  --->
	<cfif len(get_event.record_emp)>
		<cfquery name="GET_RECORD_POSITIONS_CODE" datasource="#DSN#">
			SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_event.record_emp#">  AND IS_MASTER = 1
		</cfquery>
	</cfif>
	<cfset xfa.upd = "agenda.emptypopup_upd_event">
	<cfif not isdefined("attributes.action_id")>
		<cfset xfa.del = "agenda.emptypopup_del_event&event_id=#url.event_id#&link_id=#get_event.link_id#">
	<cfelse>
		<cfset xfa.del = "agenda.emptypopup_del_event&event_id=#url.event_id#&link_id=#get_event.link_id#&is_popup=1">
	</cfif>
	<cfif len(get_event.startdate)>
		<cfset startdate = date_add('h', session.ep.time_zone, get_event.startdate)>
	<cfelse>
		<cfset startdate = "">
	</cfif>
	<cfif len(get_event.finishdate)>	
		<cfset finishdate = date_add('h', session.ep.time_zone, get_event.finishdate)>
	<cfelse>
		<cfset finishdate = "">
	</cfif>
	<cfif not isdefined("session.agenda.event#url.event_id#.joins")>
		<cfset "session.agenda.event#url.event_id#.joins" = "">
		<cfif len(get_event.event_to_pos)>
			<cfloop list="#get_event.event_to_pos#" index="i">
				<cfset "session.agenda.event#url.event_id#.joins"=listappend(evaluate("session.agenda.event#url.event_id#.joins"),"#i#")>
			</cfloop>
		</cfif>

		<cfif len(get_event.event_to_par)>
			<cfloop list="#get_event.event_to_par#" index="i">
				<cfset "session.agenda.event#url.event_id#.joins"=listappend(evaluate("session.agenda.event#url.event_id#.joins"),"#i#")>
			</cfloop>
		</cfif>
	
		<cfif len(get_event.event_to_con)>
			<cfloop list="#get_event.event_to_con#" index="i">
				<cfset "session.agenda.event#url.event_id#.joins"=listappend(evaluate("session.agenda.event#url.event_id#.joins"),"#i#")>
			</cfloop>
		</cfif>
		
		<cfif len(get_event.event_to_grp)>
			<cfloop list="#get_event.event_to_grp#" index="i">
				<cfset "session.agenda.event#url.event_id#.joins"=listappend(evaluate("session.agenda.event#url.event_id#.joins"),"#i#")>
			</cfloop>
		</cfif>
		
		<cfif len(get_event.event_to_wrkgroup)>
			<cfloop list="#get_event.event_to_wrkgroup#" index="i">
				<cfset "session.agenda.event#url.event_id#.joins"=listappend(evaluate("session.agenda.event#url.event_id#.joins"),"#i#")>
			</cfloop>
		</cfif>
	</cfif>
	<cfif not isdefined("session.agenda.event#url.event_id#.specs")>
		<cfset "session.agenda.event#url.event_id#.specs"= "">
		<cfif len(get_event.event_cc_par)>
			<cfloop list="#get_event.event_cc_par#" index="i">
				<cfset "session.agenda.event#url.event_id#.specs"=listappend(evaluate("session.agenda.event#url.event_id#.specs"),"#i#")>
			</cfloop>
		</cfif>
		
		<cfif len(get_event.event_cc_con)>
			<cfloop list="#get_event.event_cc_con#" index="i">
				<cfset "session.agenda.event#url.event_id#.specs"=listappend(evaluate("session.agenda.event#url.event_id#.specs"),"#i#")>
			</cfloop>
		</cfif>
		
		<cfif len(get_event.event_cc_grp)>
			<cfloop list="#get_event.event_cc_grp#" index="i">
				<cfset "session.agenda.event#url.event_id#.specs"=listappend(evaluate("session.agenda.event#url.event_id#.specs"),"#i#")>
			</cfloop>
		</cfif>
		
		<cfif len(get_event.event_cc_pos)>
			<cfloop list="#get_event.event_cc_pos#" index="i">
				<cfset "session.agenda.event#url.event_id#.specs"=listappend(evaluate("session.agenda.event#url.event_id#.specs"),"#i#")>
			</cfloop>
		</cfif>
	
		<cfif len(get_event.event_cc_wrkgroup)>
			<cfloop list="#get_event.event_cc_wrkgroup#" index="i">
				<cfset "session.agenda.event#url.event_id#.specs"=listappend(evaluate("session.agenda.event#url.event_id#.specs"),"#i#")>
			</cfloop>
		</cfif>
	</cfif>
	<script language="JavaScript">
		function gizle(id1)
		{
			if(id1.style.display=='')
				id1.style.display='none';
			else
				id1.style.display='';
		}
	</script>
	<cfquery name="CONTROL" datasource="#DSN#">
		SELECT EVENT_ID FROM EVENT_RESULT WHERE EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.event_id#">
	</cfquery>
	<!--- site tanimlari icin gerekli --->
   	<cfif isdefined('x_is_net_display') and (x_is_net_display eq 1)>
		<cfquery name="GET_SITE_MENU" datasource="#DSN#">
			SELECT MENU_ID,SITE_DOMAIN,OUR_COMPANY_ID FROM MAIN_MENU_SETTINGS WHERE IS_ACTIVE = 1 AND SITE_DOMAIN IS NOT NULL
		</cfquery>
	</cfif>
	<cfquery name="GET_EVENT_SITE_DOMAIN" datasource="#DSN#">
		SELECT MENU_ID FROM EVENT_SITE_DOMAIN WHERE EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#">
	</cfquery>
	<cfsavecontent variable="right">
		<cfoutput>
		<cfif not isdefined("attributes.action_id")>
			<!---<a href="#request.self#?fuseaction=agenda.view_daily&event=add" ><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>" title="<cf_get_lang_main no='170.Ekle'>"></a>
			<a href="#request.self#?fuseaction=agenda.view_daily&event=add&event_id=#attributes.event_id#" ><img src="/images/plus.gif" border="0" title="<cf_get_lang_main no='64.Kopyala'>" alt="<cf_get_lang_main no='64.Kopyala'>"></a>
			<a href="#request.self#?fuseaction=service.add_service&event_id=#attributes.event_id#" target="_blank"><img src="/images/care_plus.gif" alt="<cf_get_lang no='14.Başvuru Ekle'>" title="<cf_get_lang no='14.Başvuru Ekle'>" border="0"></a>
			<cfif (isdefined("flashComServerApplicationsPath")) and (len(flashComServerApplicationsPath))>
				<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_video_conferans&room_id=#url.event_id#','video_conference','popup_video_conferans');"><img src="/images/instmes.gif" border="0" alt="<cf_get_lang_main no='14.Video Konferans'>" title="<cf_get_lang_main no='14.Video Konferans'>"></a>
			</cfif>---->
		<cfelse>
			<input type="hidden" name="is_popup" id="is_popup" value="1">
		</cfif>
		<!----<cfif not control.recordcount>
			<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=agenda.popup_event_result&event_id=#url.event_id#','wide');"><img src="/images/content_plus.gif" alt="<cf_get_lang_main no='179.Olay Tutanagi'>" title="<cf_get_lang_main no='179.Olay Tutanagi'>" border="0"></a>
		<cfelse>
			<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=agenda.popup_event_result&event_id=#url.event_id#','wide');"><img src="/images/content_plus2.gif" alt="<cf_get_lang_main no='179.Olay Tutanagi'>" title="<cf_get_lang_main no='179.Olay Tutanagi'>" border="0"></a>
		</cfif>----->
		</cfoutput>
	</cfsavecontent>
<cfset pageHead = "#getLang('main',3)# #getLang('main',1713)# : #get_event.event_head#">
<cf_catalystheader>
        <div class="col col-9 col-xs-12">
            <cf_box title="#getLang('main',3)# #getLang('main',359)#">
                <cfform name="upd_event" method="post" action="#request.self#?fuseaction=#xfa.upd#">
                    <input type="hidden" name="xml_remember" id="xml_remember" value="<cfoutput>#xml_remember#</cfoutput>">
                    <input type="hidden" name="send_mail_agenda" id="send_mail_agenda" value="">
                    <input type="hidden" name="event_id" id="event_id" value="<cfoutput>#attributes.event_id#</cfoutput>">
                    <input type="hidden" name="link_id" id="link_id" value="<cfif len(get_event.link_id) and get_event_count.EVENT_COUNT gt 1><cfoutput>#get_event.link_id#</cfoutput></cfif>">
                    <input type="hidden" name="link_update" id="link_update" value="0">
                    <cf_box_elements>
                            <div class="col col-5 col-md-5 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                                <div class="form-group col col-12" id="item-form_ul_process_stage">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no ='1447.Süreç'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfif isdefined("get_event.event_stage")>
                                            <cf_workcube_process is_upd='0' select_value='#get_event.event_stage#' process_cat_width='300' is_detail='1'>
                                        </cfif>
                                    </div>
                                </div>
                                <div class="form-group col col-12" id="item-form_ul_eventcat_ID">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='74.Olay Kategorisi'>*</label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="eventcat_id" id="eventcat_id">
                                            <option value="0" selected><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfoutput query="get_event_cats">
                                            <option value="#eventcat_ID#" <cfif get_event_cats.eventcat_id eq get_event.eventcat_id>selected</cfif>>#eventcat#</option>
                                        </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group col col-12" id="item-form_ul_time_zone">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='85.Zaman Dilimi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cf_wrkTimeZone width="300">
                                    </div>
                                </div>
                                <div class="form-group col col-12" id="item-form_ul_EVENT_HEAD">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='68.Başlık'>*</label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="message"><cf_get_lang_main no='59.Eksik Veri'>:<cf_get_lang_main no='68.Konu'></cfsavecontent>
                                        <cfinput type="text" name="event_head" id="event_head" required="Yes" message="#message#" value="#get_event.event_head#" maxlength="100">
                                    </div>
                                </div> 
                                <div class="form-group col col-12" id="item-form_ul_event_detail">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='217.açıklama'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div id="add_event_td" type="text_top"></div>
                                        <textarea name="event_detail" id="event_detail" style="height:150px!important;"><cfoutput>#get_event.event_detail#</cfoutput></textarea>
                                    </div>
                                </div>
                                <cfif isdefined("get_event.project_id") and  len(get_event.project_id)>
                                    <cfquery name="GET_PROJECT_NAME" datasource="#DSN#">
                                        SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_event.project_id#">
                                    </cfquery>
                                </cfif>
                                <div class="form-group col col-12" id="item-form_ul_project_head">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='4.Proje'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#get_event.project_id#</cfoutput>">
                                            <input type="text" name="project_head" id="project_head" value="<cfif len(get_event.project_id)><cfoutput>#GET_PROJECT_NAME.PROJECT_HEAD#</cfoutput></cfif>">
                                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=upd_event.project_id&project_head=upd_event.project_head');"></span>
                                        </div>
                                    </div>
                                </div> 
                                <div class="form-group col col-12" id="item-form_ul_work_head">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='1033.İş'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfif len(get_event.work_id)>
                                                <cfquery name="GET_WORK" datasource="#DSN#">
                                                    SELECT 
                                                        WORK_ID,
                                                        WORK_HEAD 
                                                    FROM 
                                                        PRO_WORKS 
                                                    WHERE 
                                                        WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_event.work_id#">
                                                </cfquery>
                                            </cfif>
                                            <input type="hidden" name="work_id" id="work_id" value="<cfif isdefined("get_event.work_id") and len(get_event.work_id)><cfoutput>#get_event.work_id#</cfoutput></cfif>">
                                            <input type="text" name="work_head" id="work_head" value="<cfif isdefined("get_event.work_id") and isdefined("get_work.work_head") and len(get_work.work_head)><cfoutput>#get_work.work_head#</cfoutput></cfif>" onfocus="AutoComplete_Create('work_head','WORK_HEAD','WORK_HEAD','get_work','','WORK_ID','work_id','','3','110')">
                                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac_work();"></span>
                                        </div>
                                    </div>
                                </div>
                                <cfif xml_camp_id eq 1 or xml_camp_id eq 2>
                                    <div class="form-group col col-12" id="item-form_ul_camp_name">
                                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='34.Kampanya'></label>
                                        <div class="col col-8 col-xs-12">
                                            <div class="input-group">
                                                <cfif len(get_event.camp_id)>
                                                    <cfquery name="GET_CAMP_INFO" datasource="#DSN3#">
                                                        SELECT CAMP_ID,CAMP_HEAD FROM CAMPAIGNS WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_event.camp_id#">
                                                    </cfquery>
                                                <cfelse>
                                                    <cfset get_camp_info.camp_head = ''>
                                                </cfif>
                                                <input type="hidden" name="camp_id" id="camp_id" value="<cfoutput>#get_event.camp_id#</cfoutput>">
                                                <input type="text" name="camp_name" id="camp_name" value="<cfoutput>#get_camp_info.camp_head#</cfoutput>">
                                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_campaigns&field_id=upd_event.camp_id&field_name=upd_event.camp_name','list');"></span>
                                            </div>
                                        </div>
                                    </div>
                                </cfif>
                                <div class="form-group col col-12" id="item-form_ul_validator">
                                    <input type="Hidden" name="valid" id="valid" value="">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='88.Onay'></label>
                                    <div class="col col-8 col-xs-12">
                                    <cfif get_event.valid is "">   
                                        <div class="input-group">
                                            <cfif len(get_event.validator_position_code)>
                                                <cfset attributes.position_code = get_event.validator_position_code>
                                                <cfinclude template="../query/get_position.cfm">
                                                <input type="Hidden" name="validator_type" id="validator_type" value="e">
                                                <input type="Hidden" name="validator_id" id="validator_id" value="<cfoutput>#get_event.validator_position_code#</cfoutput>">
                                                <input type="text" name="validator" id="validator"  value="<cfoutput>#get_position.employee_name# #get_position.employee_surname#</cfoutput>">
                                            <cfelseif len(get_event.validator_par)>
                                                <cfset attributes.partner_id = get_event.validator_par>
                                                <cfinclude template="../query/get_partner_name.cfm">
                                                <input type="Hidden" name="validator_type" id="validator_type" value="p">
                                                <input type="Hidden" name="validator_id" id="validator_id" value="<cfoutput>#get_event.validator_par#</cfoutput>">
                                                <input type="text" name="validator" id="validator"  value="<cfoutput>#get_partner_name.company_partner_name# #get_partner_name.company_partner_surname#</cfoutput>">
                                            <cfelse>
                                                <input type="Hidden" name="validator_type" id="validator_type" value="">
                                                <input type="Hidden" name="validator_id" id="validator_id" value="">
                                                <input type="text" name="validator" id="validator" value="">
                                            </cfif>
                                            
                                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=upd_event.validator_id&field_id=upd_event.validator_id&field_name=upd_event.validator&field_type=upd_event.validator_type','list');"></span> 
                                            <cfif len(get_event.validator_position_code) and (get_event.validator_position_code eq session.ep.position_code)>
                                                <cfsavecontent variable="asc_message"><cf_get_lang_main no ='784.Onaylamak istediğinizden emin misiniz'></cfsavecontent>
                                                <cfsavecontent variable="rej_message"><cf_get_lang no ='95.Reddetmek istediğinizden emin misiniz'></cfsavecontent>
                                                <span class="input-group-addon btnPointer" alt="<cf_get_lang_main no ='1063.Onayla'>" title="<cf_get_lang_main no ='1063.Onayla'>" onclick="if (confirm('<cfoutput>#asc_message#</cfoutput>')) {upd_event.valid.value='1';$('.fa-thumbs-o-down').parent('span').css('display','none');} else {return false}"><i class="fa fa-thumbs-o-up" style="color:#008000!important;"></i></span>
                                                <span class="input-group-addon btnPointer" alt="<cf_get_lang_main no ='1049.Reddet'>" title="<cf_get_lang_main no ='1049.Reddet'>" onclick="if (confirm('<cfoutput>#rej_message#</cfoutput>')) {upd_event.valid.value='0';$('.fa-thumbs-o-up').parent('span').css('display','none');} else {return false}"><i class="fa fa-thumbs-o-down" style="color:#FF0000!important;"></i></span>
                                            </cfif>
                                        </div>
                                    <cfelseif get_event.valid eq 0>
                                        <!--- <label class="col col-12 col-xs-12"><cf_get_lang_main no='88.Onay'></label> --->
                                            <cfif len(get_event.valid_emp)>
                                                <cfoutput>#get_emp_info(get_event.valid_emp,0,0)# (#dateformat(get_event.valid_date,dateformat_style)#)</cfoutput>
                                                <cf_get_lang_main no='205.Redddedildi'>!
                                            <cfelseif len(get_event.valid_par_id)>
                                                <cfoutput>#get_par_info(get_event.valid_par_id,0,-1,0)# (#dateformat(get_event.valid_par_date,dateformat_style)#)</cfoutput>
                                                <cf_get_lang_main no='205.Redddedildi'>!
                                            </cfif>
                                    <cfelseif get_event.valid eq 1>
                                        <cfif len(get_event.valid_emp)>
                                            <cfoutput>#get_emp_info(get_event.valid_emp,0,0)# #dateformat(date_add('h',session.ep.time_zone,get_event.valid_date),dateformat_style)# -  #timeformat(date_add('h',session.ep.time_zone,get_event.valid_date),timeformat_style)#</cfoutput>
                                            <cf_get_lang_main no='1287.Onaylandı'> !
                                        <cfelseif len(get_event.valid_par_id)>
                                            <cfoutput>#get_par_info(get_event.valid_par_id,0,0)# (#dateformat(date_add('h',session.ep.time_zone,get_event.valid_par_date),dateformat_style)# -  #timeformat(date_add('h',session.ep.time_zone,get_event.valid_par_date),timeformat_style)#</cfoutput>
                                            <cf_get_lang_main no='1287.Onaylandı'> !
                                        </cfif>
                                    </cfif>
                                </div>
                                </div>
                            </div>
                            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                                <cfif xml_multiple_comp eq 1>            
                                    <div class="form-group col col-12" id="item-form_ul_agenda_company">
                                        <label class="col col-4 col-xs-12">Şirket Bilgisi</label>
                                        <div class="col col-8 col-xs-12">
                                            <select name="agenda_company" multiple="multiple">
                                                <cfoutput query="get_companies">
                                                    <option value="#comp_id#" <cfif session.ep.company_id eq comp_id>selected</cfif>>#NICK_NAME#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    </div>
                                </cfif>
                                <div class="form-group col col-12" id="item-form_ul_event_place">
                                    <label class="col col-4 col-xs-12"><cf_get_lang no ='83.Olay Yeri'></label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="event_place" id="event_place">
                                            <option value="" selected><cf_get_lang_main no ='322.Seçiniz'></option>
                                            <option value="1" <cfif get_event.event_place_id eq 1> selected </cfif> ><cf_get_lang no ='6.Ofis İçi'></option>
                                            <option value="2" <cfif get_event.event_place_id eq 2> selected </cfif>><cf_get_lang no ='10.Ofis Dışı'></option>
                                            <option value="3" <cfif get_event.event_place_id eq 3> selected </cfif>><cf_get_lang no='12.Müşteri Ofisi'></option>
                                            <option value="4" <cfif get_event.event_place_id eq 4> selected </cfif>><cf_get_lang dictionary_id='30015.Online'></option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group col col-12" id="item-form_ul_event_place_online">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30015.Online'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <input type="text" id="place_online" name="place_online" value="<cfoutput>#get_event.ONLINE_MEET_LINK#</cfoutput>">
                                            <a class="input-group-addon" <cfif len(get_event.ONLINE_MEET_LINK)> href="<cfif not get_event.ONLINE_MEET_LINK contains 'https://'> https://</cfif><cfoutput>#get_event.ONLINE_MEET_LINK#</cfoutput>"</cfif> rel="external" target="_blank"><i class="fa fa-coffee"></i></a>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group col col-12" id="item-form_ul_startdate">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='243.Başlama Tarihi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang_main no='326.Başlangıç Tarihini Giriniz!'></cfsavecontent>
                                        <cfinput type="text" name="startdate" id="startdate" maxlength="10" required="Yes" validate="#validate_style#" message="#message#" value="#dateformat(startdate,dateformat_style)#">
                                        <span class="input-group-addon"> <cf_wrk_date_image date_field="startdate"> </span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group col col-12" id="item-event_start_clock">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='79.Saat'>/<cf_get_lang_main no='1415.dk'></label>
                                    <div class="col col-4 col-xs-12">
                                        <cf_wrkTimeFormat name="event_start_clock" value="#timeformat(startdate,"HH")#">
                                    </div>
                                    <div class="col col-4 col-xs-12">
                                    <select name="event_start_minute" id="event_start_minute">
                                        <cfloop from="0" to="55" index="a" step="5">
                                            <cfoutput><option value="#Numberformat(a,00)#" <cfif timeformat(startdate,"MM") eq a >selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
                                        </cfloop>
                                    </select>
                                    </div>
                                </div>
                                <div class="form-group col col-12" id="item-form_ul_finishdate">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='288.Bitiş Tarihi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang_main no='327.Bitiş Tarihini Giriniz!'></cfsavecontent>
                                        <cfinput type="text" name="finishdate" id="finishdate" maxlength="10" required="Yes" validate="#validate_style#" message="#message#"  value="#dateformat(finishdate,dateformat_style)#">
                                        <span class="input-group-addon"> <cf_wrk_date_image date_field="finishdate"> </span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group col col-12" id="item-event_finish_clock">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='79.Saat'>/<cf_get_lang_main no='1415.dk'></label>
                                    <div class="col col-4 col-xs-12">
                                        <cf_wrkTimeFormat name="event_finish_clock" value="#timeformat(finishdate,"HH")#">
                                    </div>
                                    <div class="col col-4 col-xs-12">
                                    <select name="event_finish_minute" id="event_finish_minute">
                                        <cfloop from="0" to="55" index="a" step="5">
                                            <cfoutput><option value="#Numberformat(a,00)#" <cfif timeformat(finishdate,"MM") eq a >selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
                                        </cfloop>
                                    </select>
                                    </div>
                                </div>
                                <div class="form-group col col-12" id="item-form_ul_warning_start">
                                    <label class="col col-4 col-xs-12"><cf_get_lang no='17.Uyarı Başlat'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfif len(get_event.warning_start)>
                                                <cfset warning_start = dateformat(date_add('h',session.ep.time_zone,get_event.warning_start),dateformat_style)>
                                            <cfelse>
                                                <cfset warning_start = "">
                                            </cfif>
                                            <input type="text" name="warning_start" id="warning_start" validate="#validate_style#" value="<cfoutput>#warning_start#</cfoutput>">
                                            <span class="input-group-addon"> <cf_wrk_date_image date_field="warning_start"></span>
                                        </div>
                                    </div>
                                </div> 
                                <div class="form-group col col-12" id="item-form_ul_email_alert_day">
                                    <label class="col col-4 col-xs-12"><cf_get_lang no='18.E-Mail Uyarı'></label>
                                        <cfif len(get_event.warning_email)>
                                            <cfset date_difference = datediff("d",get_event.warning_email, get_event.startdate)>
                                        <cfelse>
                                            <cfset date_difference = 0>
                                        </cfif>
                                        <div class="col col-4 col-xs-12">
                                            <select name="email_alert_day" id="email_alert_day">
                                                <option value="0" <cfif date_difference eq 0>selected</cfif>><cf_get_lang no='22.Kaç'><cf_get_lang_main no='78.Gün'></option>
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
                                        <cfif len(get_event.warning_email)>
                                            <cfset date_difference = datediff("h",get_event.warning_email, get_event.startdate) mod 24>
                                            <cfset date_diff2 = datediff("n",get_event.warning_email,get_event.startdate) mod 60>
                                        <cfelse>
                                            <cfset date_difference = 0>
                                            <cfset date_diff2 = 0>
                                        </cfif>
                                        <div class="col col-4 col-xs-12">
                                            <select name="email_alert_hour" id="email_alert_hour">
                                                <option value="0" <cfif date_difference eq 0>selected</cfif>><cf_get_lang no='22.Kaç'><cf_get_lang no='25.Saat Önce'></option>
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
                                <div class="form-group col col-12" id="item-form_ul_sms_alert_day">
                                    <label class="col col-4 col-xs-12"><cf_get_lang no='19.SMS Uyarı'></label>
                                        <cfif len(get_event.warning_sms)>
                                            <cfset date_difference = datediff("d",get_event.warning_sms, get_event.startdate)>
                                        <cfelse>
                                            <cfset date_difference = 0>
                                        </cfif>
                                        <div class="col col-4 col-xs-12">
                                            <select name="sms_alert_day" id="sms_alert_day">
                                                <option value="0" <cfif date_difference eq 0>selected</cfif>><cf_get_lang no='22.Kaç'><cf_get_lang_main no='78.Gün'></option>
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
                                        <cfif len(get_event.warning_sms)>
                                            <cfset date_difference = datediff("h",get_event.warning_sms, get_event.startdate) mod 24>
                                            <cfset date_diff2 = datediff("n",get_event.warning_sms,get_event.startdate) mod 60>
                                        <cfelse>
                                            <cfset date_difference = 0>
                                            <cfset date_diff2 = 0>
                                        </cfif>
                                        <div class="col col-4 col-xs-12">
                                            <select name="sms_alert_hour" id="sms_alert_hour">
                                                <option value="0" <cfif date_difference eq 0>selected</cfif>><cf_get_lang no='22.Kaç'><cf_get_lang no='25.Saat Önce'></option>
                                                <option value="0.25" <cfif date_diff2 eq 15>selected</cfif>>15 <cf_get_lang_main no='1415.dk'></option>
                                                <option value="0.5"  <cfif date_diff2 eq 30>selected</cfif>>30 <cf_get_lang_main no='1415.dk'></option>
                                                <option value="1" <cfif date_difference eq 1> selected</cfif>>1</option>
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
                                                <option value="18" <cfif date_difference eq 18> selected</cfif>>18</option>
                                            </select>
                                        </div>
                                </div>  
                                <div class="form-group col col-12" id="item-form_ul_warning">
                                    <label class="col col-4 col-xs-12"><cf_get_lang no='20.Olay Tekrarı'></label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="warning" id="warning" onchange="show_warn(this.selectedIndex);" style="width:65px;" <cfif len(get_event.link_id) and get_event_count.EVENT_COUNT gt 1>disabled</cfif>>
                                            <option value="0" <cfif not len(get_event.link_id)>selected</cfif>><cf_get_lang_main no='1134.Yok'></option>
                                            <option value="1" <cfif len(get_event.link_id) and get_event_count.EVENT_COUNT gt 1>selected</cfif>><cf_get_lang no='62.Periodik'></option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group col col-12" id="item-warning_type">
                                    <label class="col col-4 col-xs-12"><cf_get_lang no='52.Tekrar'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="col col-4 col-xs-12">
                                            <input type="radio" name="warning_type" id="warning_type" value="1" <cfif fark eq 1>checked</cfif> <cfif len(get_event.link_id) and get_event_count.EVENT_COUNT gt 1>disabled</cfif>><cf_get_lang dictionary_id='47948.Günde Bir'>
                                        </div>
                                        <div class="col col-4 col-xs-12">
                                            <input type="radio" name="warning_type" id="warning_type" value="7" <cfif fark eq 7>checked</cfif> <cfif len(get_event.link_id) and get_event_count.EVENT_COUNT gt 1>disabled</cfif>><cf_get_lang no='50.Haftada Bir'>
                                        </div>
                                        <div class="col col-4 col-xs-12">  
                                            <input type="radio" name="warning_type" id="warning_type" value="30" <cfif fark eq 30>checked</cfif> <cfif len(get_event.link_id) and get_event_count.EVENT_COUNT gt 1>disabled</cfif>><cf_get_lang no='53.Ayda Bir'>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group col col-12" id="item-warning_count">
                                    <label class="col col-4 col-xs-12"><cf_get_lang no='49.Tekrar Sayısı'></label>
                                    <div class="col col-4 col-xs-12">
                                        <cfset message5="<cf_get_lang no='36.Tekrar Sayısı Tam Sayı Olmalıdır !'>">
                                        <cfif len(get_event.link_id)>
                                            <cfif isdefined("get_event_count.event_count") and  get_event_count.event_count gt 1>
                                                <input type="text" name="warning_count" id="warning_count" value="<cfoutput>#get_event_count.event_count#</cfoutput>" readonly passthrough="onkeyup=""return(formatcurrency(this,event,0));""" class="moneybox" maxlength="2">
                                            <cfelse>
                                                <input type="text" name="warning_count" id="warning_count" value="" passthrough="onkeyup=""return(formatcurrency(this,event,0));""" validate="integer" message="#message5#" class="moneybox" maxlength="2">
                                            </cfif>                             
                                        <cfelse>
                                            <input type="text" name="warning_count" id="warning_count" value="" passthrough="onkeyup=""return(formatcurrency(this,event,0));""" class="moneybox" maxlength="2">
                                        </cfif>
                                    </div>
                                    <div class="col col-4 col-xs-12"><label class="col col-2 col-xs-12" style="padding:0;"><cf_get_lang no='54.Kez'></label></div>     
                                </div>
                                <cfif len(get_event.link_id) and get_event_count.event_count gt 1>
                                    <div class="col col-12 margin-bottom-5" id="item-buttons">
                                        <div class="ui-form-list-btn margin-0 flex-start" style="border:0!important">
                                                <a href="javascript://" class="ui-wrk-btn ui-wrk-btn-red" title=<cfoutput>"#getLang('agenda',91)#"</cfoutput> onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=agenda.emptypopup_del_event&EVENT_ID=<cfoutput>#attributes.event_id#</cfoutput>&link_id=<cfoutput>#get_event.link_id#</cfoutput>&del_repeat=1','small')"><cfoutput>#getLang('agenda',91)#</cfoutput> </a>
                                                <cfsavecontent  variable="mess"><cf_get_lang dictionary_id='55875.Tekrar'><cf_get_lang dictionary_id='57464.Güncelle'></cfsavecontent>
                                                <cf_workcube_buttons
                                                    is_upd='0'
                                                    insert_info='#mess#'
                                                    is_cancel='0'
                                                    add_function="kontrol(2)"
                                                    insert_alert=''
                                                    >
                                        </div>
                                    </div>
                                </cfif> 
                                <div class="form-group col col-12" id="form_ul_total_time_hour">
                                    <label class="col col-4 col-xs-12"><cf_get_lang no='31.Harcanan Zaman'></label>
                                    <div class="col col-4 col-xs-12">
                                        <div class="col col-12 col-xs-12">
                                            <cfsavecontent variable="message">0-59 <cf_get_lang no='2.Arası Giriniz'>!</cfsavecontent>
                                            <input type="text" placeholder="<cfoutput>#getLang('main',79)#</cfoutput>"  name="total_time_hour" id="total_time_hour" value=""  onKeyUp="isNumber(this);">
                                        </div>
                                    </div>	
                                    <div class="col col-4 col-xs-12">
                                        <div class="col col-12 col-xs-12">
                                            <input type="text" placeholder="<cfoutput>#getLang('main',1415)#</cfoutput>" name="total_time_minute" id="total_time_minute" value="" range="0,59" onKeyUp="isNumber(this);" message="#message#">
                                        </div>
                                    </div>
                                </div>
                            </div> 
                            <div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                                <div class="form-group" id="item-form_ul_VIEW_TO_ALL">
                                    <cfsavecontent variable="header_"><cf_get_lang no='21.Bu olayı herkes görsün'></cfsavecontent>
                                    <div class="col col-12 col-xs-12">
                                        <input type="Checkbox" name="view_to_all" id="view_to_all" value="1" <cfif isdefined("get_event.view_to_all") and  get_event.view_to_all eq 1 and not len(get_event.is_wiew_branch) and not len(get_event.is_wiew_department) >checked</cfif> onclick="wiew_control(1);"><label><cf_get_lang no='21.Bu olayı herkes görsün'></label> 
                                    </div>
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
                                <div class="form-group" id="item-form_ul_is_wiew_branch">
                                    <cfsavecontent variable="header_"><cf_get_lang_main no='502.Şubemdeki Herkes Görsün'></cfsavecontent>
                                    <div class="col col-12 col-xs-12">
                                        <input type="checkbox" name="is_wiew_branch" id="is_wiew_branch" <cfif isdefined("get_event.is_wiew_branch") and  len(get_event.is_wiew_branch)and not len(get_event.is_wiew_department)>checked</cfif>  value="<cfoutput>#find_department_branch.branch_id#</cfoutput>" onclick="wiew_control(2);">
                                        <label><cf_get_lang_main no='502.Şubemdeki Herkes Görsün'></label>
                                    </div>
                                </div>
                                <div class="form-group" id="item-form_ul_is_wiew_department"> 
                                    <cfsavecontent variable="header_"><cf_get_lang_main no='503.Departmanımdaki Herkes Görsün'></cfsavecontent>
                                    <div class="col col-12 col-xs-12">
                                        <input type="hidden" name="is_wiew_branch_" id="is_wiew_branch_" value="<cfoutput>#find_department_branch.branch_id#</cfoutput>">
                                        <input type="checkbox" name="is_wiew_department" id="is_wiew_department" <cfif isdefined("get_event.is_wiew_department") and  len(get_event.is_wiew_department)>checked</cfif> value="<cfoutput>#find_department_branch.department_id#</cfoutput>" onclick="wiew_control(3);">
                                        <label><cf_get_lang_main no='503.Departmanımdaki Herkes Görsün'></label>
                                    </div>
                                </div>
                                <div class="form-group" id="item-form_ul_is_view_comp">
                                    <cfsavecontent variable="header_"><cfoutput>#getLang('objects',1091)#</cfoutput></cfsavecontent>
                                    <div class="col col-12 col-xs-12">
                                        <input type="checkbox" name="is_view_comp" id="is_view_comp" <cfif isdefined("get_event.is_view_company") and  len(get_event.is_view_company)>checked</cfif> value="1" onclick="wiew_control(4);" >
                                        <label><cfoutput>#getLang('objects',1091)#</cfoutput></label>
                                    </div>
                                </div>
                                <div class="form-group" id="item-form_ul_is_internet">
                                    <cfsavecontent variable="header_"><cf_get_lang no ='97.İnternette Gözüksün'></cfsavecontent>
                                    <div class="col col-12 col-xs-12">
                                        <input type="Checkbox" name="is_internet" id="is_internet" value="1" <cfif isdefined("get_event.is_internet") and  get_event.is_internet eq 1>checked</cfif> onclick="gizle_goster(is_site_agenda);"><cf_get_lang no ='97.İnternette Gözüksün'>
                                    </div>
                                </div>
                                <cfif get_event.RECORD_EMP eq session.ep.userid>
                                    <div class="form-group" id="item-is_google_cal">
                                        <cfsavecontent variable="header_"><cfoutput><cf_get_lang dictionary_id='64162.Google Takvimde Görünsün'></cfoutput></cfsavecontent>
                                        <div class="col col-12 col-xs-12">
                                            <input type="checkbox" name="is_google_cal" id="is_google_cal" <cfif isdefined("get_event.is_google_cal") and get_event.is_google_cal eq 1>checked</cfif> value="1"><cfoutput><cf_get_lang dictionary_id='64162.Google Takvimde Görünsün'></cfoutput>
                                        </div>
                                    </div>
                                </cfif>
                                <cfinput name="googleEventId" id="googleEventId" type="hidden" readonly value="#iif(isdefined("get_event.CREATED_GOOGLE_EVENT_ID"), DE(get_event.CREATED_GOOGLE_EVENT_ID), DE(""))#">
                            </div> 
                            <div class="col col-12 col-md-12 col-xs-12" type="column" index="4" sort="true">
                                <div class="col col-4 col-md-4 col-xs-12">
                                    <cfsavecontent variable="txt_1" ><cf_get_lang_main no='178.Katılımcılar'></cfsavecontent>
                                    <cf_workcube_to_cc 
                                        is_update="1" 
                                        to_dsp_name="#txt_1#" 
                                        form_name="upd_event" 
                                        str_list_param="8,7,1" 
                                        action_dsn="#DSN#"
                                        str_action_names="EVENT_TO_POS AS TO_EMP,EVENT_TO_PAR AS TO_PAR,EVENT_TO_CON TO_CON,EVENT_TO_GRP AS TO_GRP,EVENT_TO_WRKGROUP AS TO_WRKGROUP ,EVENT_CC_POS AS CC_EMP,EVENT_CC_PAR AS CC_PAR,EVENT_CC_CON AS CC_CON,EVENT_CC_GRP AS CC_GRP,EVENT_CC_WRKGROUP AS CC_WRKGROUP"
                                        action_table="EVENT"
                                        action_id_name="EVENT_ID"
                                        action_id="#attributes.EVENT_ID#"
                                        data_type="1"
                                        str_alias_names="">
                                </div>
                                <div class="col col-4 col-md-4 col-xs-12">
                                    <cfsavecontent variable="txt_2"><cf_get_lang no='16.Bilgi Verilecekler'></cfsavecontent>   
                                    <cfoutput></cfoutput>
                                    <cfif isdefined("attributes.partner_id")>
                                        <cf_workcube_to_cc 
                                            is_update="1" 
                                            cc_dsp_name="#txt_2#" 
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
                                            cc_dsp_name="#txt_2#" 
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
                                            cc_dsp_name="#txt_2#" 
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
                                            cc_dsp_name="#txt_2#" 
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
                                                    <input type="hidden" name="row_count" id="row_count" value="<cfoutput>#listlen(get_event.event_to_branch)#</cfoutput>">
                                                    <input type="hidden" name="last_record" id="last_record" value="<cfoutput>#listlen(get_event.event_to_branch)#</cfoutput>">
                                                </th>
                                            </tr>
                                        </thead>
                                     
                                        <tbody id="branches">
                                            <cfloop from="1" to="#listlen(get_event.event_to_branch)#" index="i">
                                                <tr id="branch_row<cfoutput>#i#</cfoutput>">
                                                    <cfquery name="GET_BRANCH" datasource="#DSN#">
                                                        SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(get_event.event_to_branch,i,',')#">
                                                    </cfquery>	
                                                    <td><a href="javascript://" onclick="del_row(<cfoutput>#i#</cfoutput>);"><i class="fa fa-minus"></i></a>&nbsp;<input type="hidden" name="row_count" id="row_count" value="<cfoutput>#i#</cfoutput>"><input type="hidden" name="branch_id<cfoutput>#i#</cfoutput>" id="branch_id<cfoutput>#i#</cfoutput>" value="<cfoutput>#listgetat(get_event.event_to_branch,i,',')#</cfoutput>">
                                                    <td><cfoutput>#get_branch.branch_name#</cfoutput></td>
                                                </tr>
                                            </cfloop>			
                                                <tr id="branch_row<cfoutput>#listlen(get_event.event_to_branch)#</cfoutput>"> 
                                        </tbody> 
                                    </table>
                                </div>
                                <div class="col col-12 col-md-12 col-xs-12" style="margin-top:1%; margin-left:4px;"><input type="button" value="<cf_get_lang no ='88.Katılımcı Durumu'>" onclick="control_joining();" style="background:#69b56c;"></div>
                                <div class="col col-12 col-md-12 col-xs-12" id="control_joining_id"></div>
                                <div class="form-group col col-12 col-md-4 col-xs-0">
                                    <div class="form-group col col-12 co-md-12 col-xs-12">
                                        <table>
                                            <tr>
                                                <td  valign="top" align="left" id="gizli1" style="display:none">
                                                    <!--- katılımcılar --->
                                                    <cfset attributes.partner_ids="">
                                                    <cfset attributes.employee_ids="">
                                                    <cfset attributes.consumer_ids="">
                                                    <cfset attributes.group_ids="">
                                                    <cfset attributes.wrk_group_ids="">
                                                    <cfloop list="#evaluate('session.agenda.event#url.event_id#.joins')#" index="i" delimiters=",">
                                                        <cfif i contains "par">
                                                            <cfset attributes.PARTNER_IDS = listappend(attributes.PARTNER_IDS,listgetat(I,2,"-"))>
                                                        </cfif>
                                                        <cfif i contains "emp">
                                                            <cfset attributes.EMPLOYEE_IDS = listappend(attributes.EMPLOYEE_IDS,listgetat(I,2,"-"))>
                                                        </cfif>
                                                        <cfif i contains "con">
                                                            <cfset attributes.consumer_ids = listappend(attributes.consumer_ids,listgetat(I,2,"-"))>
                                                        </cfif>
                                                        <cfif i contains "grp">
                                                            <cfset attributes.group_ids = listappend(attributes.group_ids,listgetat(I,2,"-"))>
                                                        </cfif>
                                                        <cfif i contains "wrk">
                                                            <cfset attributes.wrk_group_ids = listappend(attributes.wrk_group_ids,listgetat(I,2,"-"))>
                                                        </cfif>
                                                    </cfloop>
                                                    
                                                    <cfif len(attributes.partner_ids)>
                                                        <cfinclude template="../query/get_partners.cfm">
                                                        <cfloop query="get_partners">
                                                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=agenda.emptypopup_del_joins&id=par-#get_partners.partner_id#&event_id=#url.event_id#','small');"><img src="/images/delete_list.gif" border="0" alt="" align="absmiddle"></a> #get_partners.company_partner_name# #get_partners.company_partner_surname#<br />
                                                        </cfloop>
                                                    </cfif>
                                                    <cfif len(attributes.employee_ids)>
                                                        <cfinclude template="../query/get_employees.cfm">
                                                        <cfloop query="get_employees">
                                                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=agenda.emptypopup_del_joins&id=emp-#get_employees.employee_id#&event_id=#url.event_id#','small');"><img src="/images/delete_list.gif" border="0" alt="" align="absmiddle"></a> #get_employees.employee_name# #get_employees.employee_surname#<br />
                                                        </cfloop>
                                                    </cfif>
                                                    <cfif len(attributes.consumer_ids)>
                                                        <cfinclude template="../query/get_consumers.cfm">
                                                        <cfloop query="get_consumers">
                                                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=agenda.emptypopup_del_joins&id=con-#get_consumers.consumer_id#&event_id=#url.event_id#','small');"><img src="/images/delete_list.gif" border="0" alt="" align="absmiddle"></a> #get_consumers.consumer_name# #get_consumers.consumer_surname#<br />
                                                        </cfloop>
                                                    </cfif>
                                                    <cfif len(attributes.group_ids)>
                                                        <cfinclude template="../query/get_groups.cfm">
                                                        <cfloop query="get_groups">
                                                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=agenda.emptypopup_del_joins&id=grp-#get_groups.group_id#&event_id=#url.event_id#','small');"><img src="/images/delete_list.gif" border="0" alt="" align="absmiddle"></a> #get_groups.group_name#<br />
                                                        </cfloop>
                                                    </cfif>
                                                    <cfif len(attributes.wrk_group_ids)>
                                                        <cfinclude template="../query/get_wrkgroups.cfm">
                                                        <cfloop query="get_wrkgroups">
                                                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=agenda.emptypopup_del_joins&id=wrk-#get_wrkgroups.workgroup_id#&event_id=#url.event_id#','small');"><img src="/images/delete_list.gif" border="0" alt="" align="absmiddle"></a> #get_wrkgroups.workgroup_name#<br />
                                                        </cfloop>
                                                    </cfif>
                                                </td>
                                            </tr>
                                        </table>
                                        <table>
                                            <tr>
                                                <td  valign="top" align="left" id="gizli2" style="display:none">
                                                    <!--- izleyiciler --->
                                                    <cfset attributes.partner_ids="">
                                                    <cfset attributes.employee_ids="">
                                                    <cfset attributes.consumer_ids="">
                                                    <cfset attributes.group_ids="">
                                                    <cfset attributes.wrk_group_ids="">
                                                    <cfloop list="#Evaluate("session.agenda.event#url.event_id#.specs")#" index="i">
                                                        <cfif i contains "par">
                                                            <cfset attributes.partner_ids = ListAppend(attributes.partner_ids,ListGetAt(I,2,"-"))>
                                                        </cfif>
                                                        <cfif i contains "emp">
                                                            <cfset attributes.EMPLOYEE_IDS = ListAppend(attributes.employee_ids,ListGetAt(I,2,"-"))>
                                                        </cfif>
                                                        <cfif i contains "con">
                                                            <cfset attributes.consumer_ids = ListAppend(attributes.consumer_ids,ListGetAt(I,2,"-"))>
                                                        </cfif>
                                                        <cfif i contains "grp">
                                                            <cfset attributes.group_ids = ListAppend(attributes.group_ids,ListGetAt(I,2,"-"))>
                                                        </cfif>
                                                        <cfif i contains "wrk">
                                                            <cfset attributes.wrk_group_ids = ListAppend(attributes.wrk_group_ids,ListGetAt(I,2,"-"))>
                                                        </cfif>
                                                    </cfloop>
                                                    <cfif len(attributes.partner_ids)>
                                                        <cfinclude template="../query/get_partners.cfm">
                                                        <cfloop query="get_partners">
                                                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=agenda.emptypopup_del_specs&id=par-#get_partners.partner_id#&event_id=#url.event_id#','small');"><img src="/images/delete_list.gif" border="0" alt="" align="absmiddle"></a> #get_partners.company_partner_name# #get_partners.company_partner_surname#<br />
                                                        </cfloop>
                                                    </cfif>
                                                    <cfif len(attributes.employee_ids)>
                                                        <cfinclude template="../query/get_employees.cfm">
                                                        <cfloop query="get_employees">
                                                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=agenda.emptypopup_del_specs&id=emp-#get_employees.employee_id#&event_id=#url.event_id#','small');"><img src="/images/delete_list.gif" border="0" alt="" align="absmiddle"></a> #get_employees.employee_name# #get_employees.employee_surname#<br />
                                                        </cfloop>
                                                    </cfif>
                                                    <cfif len(attributes.consumer_ids)>
                                                        <cfinclude template="../query/get_consumers.cfm">
                                                        <cfloop query="get_consumers">
                                                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=agenda.emptypopup_del_specs&id=con-#get_consumers.consumer_id#&event_id=#url.event_id#','small');"><img src="/images/delete_list.gif" border="0" alt="" align="absmiddle"></a> #get_consumers.consumer_name# #get_consumers.consumer_surname#<br />
                                                        </cfloop>
                                                    </cfif>
                                                    <cfif len(attributes.group_ids)>
                                                        <cfinclude template="../query/get_groups.cfm">
                                                        <cfloop query="get_groups">
                                                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=agenda.emptypopup_del_specs&id=grp-#get_groups.group_id#&event_id=#url.event_id#','small');"><img src="/images/delete_list.gif" border="0" alt="" align="absmiddle"></a> #get_groups.group_name#<br />
                                                        </cfloop>
                                                    </cfif>
                                                    <cfif len(attributes.wrk_group_ids)>
                                                        <cfinclude template="../query/get_wrkgroups.cfm">
                                                        <cfloop query="get_wrkgroups">
                                                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=agenda.emptypopup_del_specs&id=wrk-#get_wrkgroups.workgroup_id#&event_id=#url.event_id#','small');"><img src="/images/delete_list.gif" border="0" alt="" align="absmiddle"></a> #get_wrkgroups.workgroup_name#<br />
                                                        </cfloop>
                                                    </cfif>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                                <cfif isdefined('x_is_net_display') and (x_is_net_display eq 1)><!--- INTERNETTE GÖRÜNSÜN XML değişkeni--->                 
                                    <cfset my_event_site_list = valuelist(get_event_site_domain.menu_id)>
                                    <table id="is_site_display" width="100%" <cfif get_event.is_internet eq 0>style="display:none;"</cfif> valign="top">
                                        <tr> 
                                            <td>
                                                <cf_seperator header="#getLang('agenda',98)#" id="actives_site" is_closed="1">
                                                <table id="actives_site" style="display:none;">
                                                    <cfloop query="get_site_menu">
                                                        <tr>
                                                            <td><input name="menu_<cfoutput>#get_site_menu.menu_id#</cfoutput>" id="menu_<cfoutput>#get_site_menu.menu_id#</cfoutput>" type="checkbox" value="<cfoutput>#get_site_menu.menu_id#</cfoutput>"<cfif len(my_event_site_list) and ListFindNoCase(my_event_site_list,get_site_menu.menu_id,',')>checked</cfif>><cfoutput>#get_site_menu.site_domain#</cfoutput></td>
                                                        </tr>
                                                    </cfloop>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </cfif>
                            </div>
                    </cf_box_elements>
                    <div class="ui-form-list-btn">	
                        <div class="col col-6 col-xs-12">
                            <cf_record_info query_name="get_event">
                        </div>    
                        <div class="col col-6 col-xs-12">
                            <cfif xml_email_send_active eq 1>
                                <cfsavecontent variable="message"><cf_get_lang no ='89.Güncelle ve Mail Gönder'></cfsavecontent>
                                <cf_workcube_buttons type_format="1" 
                                    is_upd='0'
                                    insert_info='#message#'
                                    is_cancel='0'
                                    add_function="kontrol(1)">
                            </cfif>
                            <cf_workcube_buttons type_format="1"
                                is_upd='1'
                                is_cancel='0'
                                delete_page_url='#request.self#?fuseaction=#xfa.del#&fromagenda=#url.fromagenda#'
                                add_function="kontrol(0)">
                            <div id="delGoogleEventButton" class="pull-right"><input data-gate-action="del" class="ui-wrk-btn ui-wrk-btn-red" name="wrk_delete_button1" id="wrk_delete_button1" type="button" value="<cf_get_lang dictionary_id='64705.Googledan Sil'>" onclick="javascript:return (confirm('<cf_get_lang dictionary_id="64728.Onaylarsanız, etkinlik hem Workcube Ajandadan, hem de Google Takvimden silinecek!">') && googleDeleteEvent())"/></div>
                        </div>
                    </div>
                    <div>
                        <cfinput type="hidden" name="googleEventId" id="googleEventId" value="">
                    </div>
                </cfform>
            </cf_box>
        </div>
        <div class="col col-3 col-xs-12">
            <!--- Belgeler --->
            <cf_get_workcube_asset asset_cat_id="-20" module_id='6' action_section='EVENT_ID' action_id='#attributes.event_id#'>
            <!--- Fiziki Varlık Rezervasyonu --->
            <cf_box 
                id="related_cont" 
                unload_body="1" 
                title="#getLang('agenda',1)#"
                box_page="#request.self#?fuseaction=agenda.form_event_ajax&event_id=#attributes.event_id#&get_event.link_id"
                closable="0"
                width="100%">
            </cf_box>
        </div>
	<cfif isDefined("attributes.reserv")>
		<script language="JavaScript">
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_assets&event_id=<cfoutput>#attributes.event_id#</cfoutput>','list');
		</script>
	</cfif>
	<script language="JavaScript">
        var type = '';
        var googleCalEventsListed = 0; // listelenen olaylar yinelenmesin diye eklendi
        var CLIENT_ID = '';
        var CLIENT_SECRET = '';
        var API_KEY = '';
        var DISCOVERY_DOCS = [];
        var SCOPES = "";
        var gEventId = "<cfoutput>#get_event.CREATED_GOOGLE_EVENT_ID#</cfoutput>";
        var googleSignInMessage = "<cf_get_lang dictionary_id='64111.Google Hesabınızla Giriş Yapmalısınız!'>";
        document.getElementById("delGoogleEventButton").style.display = "none";
        function googleDeleteEvent(){
            function signInGoogleForDel(gEventId){
                type = "del"; // add, upd ve list seçenkelerinden uygun olan, burada tanımlanmalıdır.
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
                    handleClientLoad(gEventId);
                    deleteGoogleEvent(gEventId);
                }else{
                    alert("<cf_get_lang dictionary_id='61524.API Key'>, <cf_get_lang dictionary_id='64109.CLIENT_ID'>, <cf_get_lang dictionary_id='64110.CLIENT_SECRET'> bilgilerinin girilmesi gerekiyor.");
                    return false;
                }
            }
            signInGoogleForDel(gEventId);
        }
		function kontrol(type)
		{
			if(type==0)
			{
				document.getElementById('send_mail_agenda').value='0'; //Güncelle
				document.getElementById('link_update').value = '0';
			}
			else if(type==1)
			{
				document.getElementById('send_mail_agenda').value='1'; //Güncelle ve mail gönder
				document.getElementById('link_update').value = '0';
			}
			else if(type==2)
			{
				document.getElementById('send_mail_agenda').value='0'; //Tekrar Eden kayitlari guncelle
				document.getElementById('link_update').value = '1';
			}
			
			if (document.getElementById('eventcat_id').value == 0)
			{ 
				alert("<cf_get_lang_main no='59.Eksik Veri'>:<cf_get_lang no='26.Olay Kategorisi'>");
				return false;
			}
			if (document.upd_event.warning.selectedIndex !=undefined && document.upd_event.warning.selectedIndex == 1)
				if (document.getElementById('warning_count').value == "")
				{
					alert("<cf_get_lang no='49.Tekrar sayısı!'>");
					return false;
				}
			if (document.upd_event.warning_count.value.length != 0)
				if (document.getElementById('warning_count').value < 2)
				{
					alert("<cf_get_lang no='35.Tekrar sayısı 1 den büyük olmalı!'>");
					return false;
				}
			if (document.upd_event.warning.selectedIndex == 1)
			{
				if (document.getElementById('warning_count').value != "")
					if (document.getElementById('warning_count').value < 2)
					{
						alert("<cf_get_lang no='35.Tekrar sayısı 1 den büyük olmalı!'>");
						return false;
					}
				if (document.upd_event.warning_type[0].disabled!=true && document.upd_event.warning_type[0].disabled!=true && ((document.upd_event.warning_type[0].checked=="false") || (document.upd_event.warning_type[1].checked=="false")))
				{
					alert("<cf_get_lang no='34.Tekrar Periyodu!'>");
					return false;
				}
			}
			if ((document.getElementById('startdate').value != "") && (upd_event.finishdate.value != "") )
				if(!time_check(upd_event.startdate, upd_event.event_start_clock, upd_event.event_start_minute, upd_event.finishdate,  upd_event.event_finish_clock, upd_event.event_finish_minute, "<cf_get_lang no='40.Olay Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır !'>")) return false;
			
			if ( (upd_event.warning_start.value != "") && (upd_event.startdate.value != ""))
				if(!date_check(upd_event.warning_start,upd_event.startdate,"<cf_get_lang no='39.Uyarı Tarihi Olay Başlama Tarihinden Önce Olmalıdır !'>")) return false;
			
			if(document.getElementById('to_emp_ids') == undefined && (document.getElementById('total_time_hour').value != '' || document.getElementById('total_time_minute').value != ''))
			{
				alert("Katılımcı olmadığı için zaman harcaması kaydı giremezsiniz!");
				return false;
			}
			<cfif xml_camp_id eq 2>
				if( document.getElementById('camp_id').value == '' || document.getElementById('camp_name').value == '')
				{
					alert("<cf_get_lang no ='101.Lütfen Kampanya Seçiniz'>!");
					return false;
				}
			</cfif>
			return process_cat_control();
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
			
		<cfif len(get_event.link_id)>
			<cfoutput>
				warning_type = #fark#;
				warning_count = #get_event_count.event_count#;
			</cfoutput>
		</cfif>
			
		<cfif get_event.link_id is "" or get_event_count.event_count eq 1>
			show_warn(0);
		<cfelse>
			show_warn(1);
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
				document.upd_event.is_wiew_branch.checked=false;
				document.upd_event.is_wiew_department.checked=false;
				document.getElementById('is_view_comp').checked =false;
			}
			if(type==2)
			{
				document.upd_event.view_to_all.checked=false;
				document.upd_event.is_wiew_department.checked=false;
				document.getElementById('is_view_comp').checked =false;
			}
			if(type==3)
			{
				document.upd_event.view_to_all.checked=false;
				document.upd_event.is_wiew_branch.checked=false;
				document.getElementById('is_view_comp').checked =false;
			}
			if(type==4)
			{
				document.upd_event.view_to_all.checked=false;
				document.upd_event.is_wiew_branch.checked=false;
				document.upd_event.is_wiew_department.checked=false;
				<cfif xml_multiple_comp eq 1>
					if(document.getElementById('is_view_comp').checked ==false)
						document.getElementById('form_ul_agenda_company').style.display = 'none';
					else
						document.getElementById('form_ul_agenda_company').style.display = '';
				</cfif>
			}
		}
		function control_joining()
		{
			if(document.getElementById('to_emp_ids') == undefined)
			{
				alert("<cf_get_lang no ='84.Katılımcı Ekleyiniz'>!");
				return false;
			}
			if(document.getElementById('startdate').value == '' || document.getElementById('finishdate').value == '')
			{
				alert("<cf_get_lang no ='85.Lütfen Tarih Aralığı Giriniz'>!");
				return false;
			}
			list_to_emp_ids= '';
			if(document.getElementById('to_emp_ids').value != undefined && document.upd_event.to_emp_ids.length == undefined)
				list_to_emp_ids=document.getElementById('to_emp_ids').value;
			else
				{
					for(i=0;i<document.upd_event.to_emp_ids.length;i++)
					list_to_emp_ids+=','+document.upd_event.to_emp_ids[i].value;
				}
			var send_adress='<cfoutput>#request.self#</cfoutput>?fuseaction=agenda.emptypopup_control_joining&startdate='+document.upd_event.startdate.value+'&finishdate='+document.upd_event.finishdate.value+'&event_start_clock='+document.upd_event.event_start_clock.value+'&event_finish_clock='+document.upd_event.event_finish_clock.value+'&event_start_minute='+document.upd_event.event_start_minute.value+'&event_finish_minute='+document.upd_event.event_finish_minute.value+'&event_id='+document.upd_event.event_id.value+'&list_to_emp_ids='+list_to_emp_ids;
			AjaxPageLoad(send_adress,'control_joining_id',1,'Katılımcılar Kontrol Ediliyor.');
		}
		
		 function del_row(id)
		 {  
			eval("document.getElementById('branch_id"+id+"')").value = "";
			eval("document.getElementById('branch_row"+id+"')").style.display="none";
			document.getElementById('row_count').value = document.getElementById('row_count').value - 1; 
		 }
		
		function pencere_ac_work()
		{
			p_id_ = document.getElementById("project_id").value;
			p_name_ = document.getElementById("project_head").value;
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&field_id=upd_event.work_id&field_name=upd_event.work_head&project_id=' + p_id_ + '&project_head=' + p_name_ +'','list');
		}
	</script>
</cfif>
<script language="javascript">
	//BURASI "OLAY TAKVİMİ" İLE İLGİLİ
	try{ // Eğer ilk satır hata verirse ki olay takviminden gelirse hata vermez. o zaman çalışmaz
		var scheduler = window.opener.scheduler;
		var d1 = document.getElementById('startdate').value.split('/');
		var d2 = document.getElementById('finishdate').value.split('/');
		
		var tmpobj = scheduler.getEvent(scheduler.pre_obj.id);
		
		tmpobj.text = document.getElementById('event_head').value;
			
		start_clock = document.getElementById('event_start_clock').value;
		start_minute = document.getElementById('event_start_minute').value;
		tmpobj.start_date = d1[0]+'-'+d1[1]+'-'+d1[2]+' '+start_clock+':'+start_minute;
		
		finish_clock = document.getElementById('event_finish_clock').value;
		finish_minute = document.getElementById('event_finish_minute').value;
		tmpobj.end_date = d2[0]+'-'+d2[1]+'-'+d2[2]+' '+finish_clock+':'+finish_minute;	
		
		scheduler.addEvent(tmpobj);
	}catch(err){}
    function signInGoogle(){
        type = "upd"; // add, upd ve list seçenkelerinden uygun olan, burada tanımlanmalıdır.
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
            handleClientLoad();
        }else{
            alert("<cf_get_lang dictionary_id='61524.API Key'>, <cf_get_lang dictionary_id='64109.CLIENT_ID'>, <cf_get_lang dictionary_id='64110.CLIENT_SECRET'> bilgilerinin girilmesi gerekiyor.");
            return false;
        }
    }
    document.addEventListener("DOMContentLoaded", function(){
        // Sayfa yüklendiğinde, eventin Google'a kayıtlı olup olmadığını kontrol ediyor.
        // Google API Key, CLIENT_ID, CLIENT_SECRET bilgileri girildiyse ve eventi kaydeden kullanıcı sayfaya girdiyse
        // Google giriş işlemlerini yapıyor.
        if(<cfoutput>#len(get_api_key.GOOGLE_API_KEY)#</cfoutput> && <cfoutput>#len(get_api_key.GOOGLE_CLIENT_ID)#</cfoutput> && <cfoutput>#len(get_api_key.GOOGLE_CLIENT_SECRET)#</cfoutput>){
            <cfif get_event.is_google_cal eq 1 and get_event.RECORD_EMP eq session.ep.userid>
                signInGoogle();
            </cfif>
        }
    });
    function deleteGoogleEvent(evntId) {
        return gapi.client.calendar.events.delete({
            "calendarId": "primary",
            eventId: evntId
        }).then(function (response) {
            /* console.log("Response", response); */
            console.log("Event Silindi!");
            sonuc = "1";
            if (sonuc == 1)
            {
                window.location = "<cfoutput>#request.self#?fuseaction=#xfa.del#&fromagenda=#url.fromagenda#&googleEvent=1&event_id=<cfoutput>#attributes.event_id#</cfoutput>&is_google_cal=#get_event.is_google_cal#</cfoutput>&googleEventId=<cfif get_event.is_google_cal eq 1><cfoutput>#get_event.CREATED_GOOGLE_EVENT_ID#</cfoutput></cfif>";
                return false;
            }
        },
            function (err) { console.error("Execute error", err); });
    }
</script>
<script async defer src="https://apis.google.com/js/api.js"></script>
<script src="JS/google_ws/google_calendar_init.js"></script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">