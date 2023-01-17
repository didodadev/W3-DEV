<!---
File: kanban_board.cfm
Author: Esma R. Uysal <esmauysal@workcube.com>
--->
<cf_xml_page_edit fuseact="project.works">
<cfparam name="attributes.priority_cat" default="">
<cfparam name="attributes.activity_id" default="">
<cfparam name="attributes.currency" default="">
<cfparam name="attributes.pro_employee" default="">
<cfparam name="attributes.pro_employee_id" default="">
<cfparam name="attributes.workgroup_id" default="">
<cfparam name="attributes.search_date1" default="">
<cfparam name="attributes.search_date2" default="">
<cfparam name="attributes.work_cat" default="">
<cfparam name="attributes.is_milestone" default="0">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.sort_type" default="0">
<cfparam name="attributes.time_interval" default="">
<cfparam name="attributes.startrow" default="1">
<cfparam name="attributes.day_type" default="0">
<cfparam name="attributes.roles_id" default="">
<cfif isdefined("attributes.id") and len(attributes.id)>
  <cfset attributes.project_id = attributes.id>
  <cfset attributes.project_head = get_project_name(attributes.project_id)>
  <cfset attributes.is_submitted = 1>
</cfif>
<cfif  isDefined("attributes.service_id")>
  <cfparam name="attributes.work_status" default="0">
<cfelse>
  <cfparam name="attributes.work_status" default="1">
</cfif>
<cfif isdefined("attributes.search_date1") and isdate(attributes.search_date1)>
    <cf_date tarih = "attributes.search_date1">
</cfif>
<cfif isdefined("attributes.search_date2") and isdate(attributes.search_date2)>
    <cf_date tarih = "attributes.search_date2">
</cfif>
<!--- css, js ve include --->
<script src="/css/assets/template/ui-kanban/sortable.js"></script>
<link rel="stylesheet" type="text/css" href="/css/assets/template/ui-kanban/_bootstrap_v4.css">
<link rel="stylesheet" type="text/css" href="/css/assets/template/ui-kanban/kanban.css?version=3">
<cfinclude template="../../project/query/get_priority.cfm">
<!--- componentler --->
<cfset getComponentWork = createObject('component','V16.project.cfc.get_work')><!--- İşler Component --->
<cfset getComponentKanban = createObject('component','V16.report.cfc.kanban_board')><!--- İşler Component --->
<cfset get_workgroups = getComponentWork.GET_WORKGROUPS()><!--- İş Grupları --->
<cfset get_activity = getComponentWork.GET_ACTIVITY()><!--- Aktivite Tipi --->
<cfset get_process_types  = getComponentKanban.GET_PROCESS_TYPES()>
<!--- Milestona Göre --->
<cfif attributes.sort_type eq 1>
  <cfset get_project_milestone  = getComponentKanban.GET_PROJECT_MILESTONE(
    project_id      :(len(attributes.project_id)) ? "#attributes.project_id#" : "",
    project_head    : (len(attributes.project_head)) ? "#attributes.project_head#" : ""
  )>
<!--- Kişilere Göre --->
<cfelseif attributes.sort_type eq 2>
  <cfset get_employee_task  = getComponentKanban.GET_EMPLOYEE_TASK(
    project_id      :(len(attributes.project_id)) ? "#attributes.project_id#" : "",
    project_head    : (len(attributes.project_head)) ? "#attributes.project_head#" : "",
    roles_id        : (len(attributes.roles_id)) ? "#attributes.roles_id#" : ""
  )>
</cfif>
<cfset get_roles  = getComponentKanban.GET_ROLES()>

<!--- Search --->
<div class="col col-12">
  <cf_box scroll="0">
      <cfform name="works" method="post" action="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.kanban_board">
        <cf_box_search>
          <input type="hidden" name="is_submitted" id="is_submitted" value="1" />
          <div class="form-group" id="form_ul_pro_employee_id">
            <div class="input-group">
                <input type="hidden" name="pro_employee_id"  id="pro_employee_id" value="<cfif isdefined('attributes.pro_employee_id') and len(attributes.pro_employee)><cfoutput>#attributes.pro_employee_id#</cfoutput></cfif>">
                <input type="text" name="pro_employee" id="pro_employee"  placeholder="<cf_get_lang dictionary_id='57569.Görevli'>"  value="<cfif isdefined('attributes.pro_employee') and len(attributes.pro_employee)><cfoutput>#attributes.pro_employee#</cfoutput></cfif>" onfocus="AutoComplete_Create('pro_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','pro_employee_id','','3','135');" autocomplete="off">	
                <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=works.pro_employee_id&field_name=works.pro_employee&select_list=1');"></span>
            </div>
          </div>
          <div class="form-group" id="item-project_id" >
            <div class="col col-12">
                <div class="input-group">
                <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>" >
                <input name="project_head" type="text" placeholder="<cf_get_lang dictionary_id='57416.Proje'>" id="project_head" value="<cfif Len(attributes.project_id) and len(attributes.project_head)><cfoutput>#get_project_name(attributes.project_id)#</cfoutput></cfif>"  onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','list_works','3','250');" autocomplete="off" onchange="open_milestone()">
                <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=list_works.project_head&project_id=list_works.project_id&call_function=open_milestone()</cfoutput>');"></span>
                </div>
            </div>
          </div>
          <div class="form-group">       
            <select name="is_milestone" id="is_milestone">
              <option value="0" <cfif attributes.is_milestone eq 0>selected="selected"</cfif>><cf_get_lang dictionary_id='30781.Üst İşler Dahil'></option>
              <option value="1" <cfif attributes.is_milestone eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id='30784.Üst İşler hariç'></option>
            </select>
          </div>
          <div id="sort_type_div" class="form-group" style="display:none">       
            <select name="sort_type" id="sort_type" onchange="open_roles()">
              <option value="0" <cfif attributes.sort_type eq 0>selected="selected"</cfif>><cf_get_lang dictionary_id='39492.Aşamaya Göre'></option>
              <option value="1" <cfif attributes.sort_type eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id='60624.Milestone a Göre'></option>
              <option value="2" <cfif attributes.sort_type eq 2>selected="selected"</cfif>><cf_get_lang dictionary_id='61053.Kişilere Göre'></option>
            </select>
          </div> 
          <div id="sort_employee" class="form-group" style="display:none">       
            <select name="roles_id" id="roles_id">
              <option value=""><cf_get_lang dictionary_id ='38216.Rol Seçiniz'></option>
                <cfif get_roles.recordcount>
                  <cfoutput query="get_roles">
                    <option value="#PROJECT_ROLES_ID#" <cfif attributes.roles_id eq PROJECT_ROLES_ID>selected</cfif>>#PROJECT_ROLES#</option>
                  </cfoutput>
                </cfif>
              </select>
            </select>
          </div>
          <div class="form-group" id="item-search_date">        
            <div class="input-group">
              <cfsavecontent variable="txt1"><cf_get_lang dictionary_id="57782.Tarih Değerini Kontrol Ediniz">!</cfsavecontent>
              <cfinput type="text" name="search_date1" value="#dateformat(attributes.search_date1, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#txt1#">
              <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="search_date1"></span>
            </div>
          </div>
          <div class="form-group" id="item-search_date"> 
            <div class="input-group">
              <cfinput type="text" name="search_date2" value="#dateformat(attributes.search_date2, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#txt1#">
              <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="search_date2"></span>
            </div>
          </div>
          <div class="form-group">       
            <select name="work_status" id="work_status">
              <option value="1" <cfif attributes.work_status eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
              <option value="-1" <cfif attributes.work_status eq -1>selected="selected"</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
              <option value="0" <cfif attributes.work_status eq 0>selected="selected"</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
            </select>
          </div>
          <div class="form-group">
            <cf_wrk_search_button is_excel="0" button_type="4">
          </div>
        </cf_box_search>
        <cf_box_search_detail>
          <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
            <div class="form-group">
              <select name="workgroup_id" id="workgroup_id">				  
                <option value=""><cf_get_lang dictionary_id='58140.İş Grubu'></option>
                <cfoutput query="get_workgroups">
                  <option value="#workgroup_id#" <cfif isdefined("attributes.workgroup_id") and workgroup_id eq attributes.workgroup_id>selected</cfif>>#workgroup_name#</option>
                </cfoutput>
              </select>
            </div>
            <div class="form-group">
              <cfsavecontent variable="secmessage"><cf_get_lang dictionary_id='57482.Asama'></cfsavecontent>
              <cf_multiselect_check 
                  query_name="get_process_types"  
                  name="currency"
                  option_text="#secmessage#" 
                  option_value="process_row_id"
                  option_name="stage"
                  value="#iif(isdefined("attributes.currency"),"attributes.currency",DE(""))#"
                >
            </div>
          </div>
          <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
            <div class="form-group">
              <select name="priority_cat" id="priority_cat">
                <option value=""><cf_get_lang dictionary_id='57485.Öncelik'></option>
                <cfoutput query="get_cats">
                  <option value="#priority_id#" <cfif attributes.priority_cat eq priority_id>selected</cfif>>#priority#</option>
                </cfoutput>
              </select>
            </div>
            <div class="form-group">
              <select name="day_type" id="day_type">
                <option value="0" <cfif attributes.day_type eq 0>selected</cfif>><cf_get_lang dictionary_id='40199.Bitiş Tarihine Göre'></option>
                <option value="1" <cfif attributes.day_type eq 1>selected</cfif>><cf_get_lang dictionary_id='705.Termin Tarihine Göre'></option>
              </select>
            </div>
          </div>
          <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="13" sort="true">
            <div class="form-group">
              <select name="activity_id" id="activity_id">
                <option value=""><cf_get_lang dictionary_id='38378.Aktivite Tipi'></option>
                <cfoutput query="get_activity">
                  <option value="#activity_id#" <cfif attributes.activity_id eq activity_id>selected</cfif> >#activity_name#</option>
                </cfoutput>
              </select>
            </div>
          </div>
          <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
            <div class="form-group">               
              <select name="time_interval" id="time_interval">
                <option value="-2" <cfif isdefined("attributes.time_interval") and len(attributes.time_interval) and attributes.time_interval eq '-2'>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                <option value="-1" <cfif isdefined("attributes.time_interval") and len(attributes.time_interval) and attributes.time_interval eq '-1'>selected</cfif>><cf_get_lang dictionary_id='57942.Bugün'></option>
                <option value="0" <cfif isdefined("attributes.time_interval") and len(attributes.time_interval) and attributes.time_interval eq '0'>selected</cfif>><cf_get_lang dictionary_id='58734.Bu Hafta'></option>
                <option value="1" <cfif isdefined("attributes.time_interval") and len(attributes.time_interval)and attributes.time_interval eq '1'>selected</cfif>><cf_get_lang dictionary_id='58724.Bu Ay'></option>
              </select>
            </div>
          </div>
        </cf_box_search_detail>
      </cfform>
  </cf_box>
  <!--- detail --->
  <cf_box title="#getLang('','Kanban',38272)#" collapsable="1">
    <cfif isdefined("attributes.is_submitted")>
      <div id="kanban_board" class="bootstrap">
        <cfif attributes.time_interval eq 1>
            <cfset firstdayofmonth = CREATEODBCDATETIME(CREATEDATE(year(now()),month(now()),1))>
            <cfset lastdayofmonth = CREATEODBCDATETIME(date_add("d",29,CREATEDATE(year(now()),month(now()),1)))>
        <cfelseif attributes.time_interval eq 0>
            <cfset firstDay= DateAdd("d", "-#DayOfWeek(Now()) -2#", Now())>
            <cfset seventhday = date_add('d',6,firstday)>
        </cfif>
        <cfif attributes.sort_type eq 0>
          <cfif isdefined("attributes.currency") and len(attributes.currency)>
            <cfquery name="get_process_types_column" dbtype="query">
              SELECT * FROM get_process_types WHERE PROCESS_ROW_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.currency#" list="yes">)
            </cfquery>
          <cfelse>
              <cfset get_process_types_column = get_process_types>
          </cfif>
          <cfoutput query="get_process_types_column"> 
            <div  class="kanban_grid cl-xl-2 cl-md-3 cl-sm-6 cl-12" id="#get_process_types_column.process_row_id#">
              <!--- Sürece Bağlı İşler --->
              <cfset get_PRO_WORKS =  getComponentKanban.get_PRO_WORKS(
                process_row_id  : get_process_types_column.process_row_id,
                work_cat        : (len(attributes.work_cat)) ? "#attributes.work_cat#" : "",
                currency        : (len(attributes.currency)) ? "#attributes.currency#" : "",
                priority_cat    : (len(attributes.priority_cat)) ? "#attributes.priority_cat#" : "",
                activity_id     : (len(attributes.activity_id)) ? "#attributes.activity_id#" : "",
                workgroup_id    :  (len(attributes.workgroup_id)) ? "#attributes.workgroup_id#" : "",
                work_status     : (len(attributes.work_status)) ? "#attributes.work_status#" : "",
                time_interval   : (len(attributes.time_interval)) ? "#attributes.time_interval#" : "",
                search_date1    : (len(attributes.search_date1)) ? "#attributes.search_date1#" : "",
                search_date2    : (len(attributes.search_date2)) ? "#attributes.search_date2#" : "",
                pro_employee    : (len(attributes.pro_employee)) ? "#attributes.pro_employee#" : "",
                pro_employee_id : (len(attributes.pro_employee_id)) ? "#attributes.pro_employee_id#" : "",
                is_milestone    : (len(attributes.is_milestone)) ? "#attributes.is_milestone#" : "",
                project_id      :(len(attributes.project_id)) ? "#attributes.project_id#" : "",
                project_head    : (len(attributes.project_head)) ? "#attributes.project_head#" : "",
                xml_is_all_authorization : xml_is_all_authorization,
                day_type : attributes.day_type
              )>
              <div class="kanban_title" id="#get_process_types_column.STAGE#">
                <div class="kanban_hide_btn">
                  <a href="javascript://">
                    <i class="fa fa-chevron-down"></i>
                  </a>
                </div>
                <div class="kanban_add_btn">
                  <a href="javascript://" onclick="cfmodal('#request.self#?fuseaction=objects.popup_add_rapid_work&process_id=#get_process_types_column.process_row_id#&type=0<cfif len(attributes.project_id)>&project_id=#attributes.project_id#</cfif>','warning_modal');">
                    <i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i>
                  </a>
                </div>
                <div class="kanban_total">
                  #get_PRO_WORKS.recordcount#
                </div>
              </div>
              <div class="kanban_title_2" id="">
                  <h2>#get_process_types_column.STAGE#</h2>
              </div>
              <div class="kanban_box">
                <cfloop query="get_PRO_WORKS">            
                  <cfset diyez =chr(35)>                    
                  <cfset renk=#diyez# &'#color#'>
                  <cfif not len(color)>
                    <cfset renk=#diyez# &'ffc2b3'>
                  </cfif>
                  <div class="kanban_detail"  id="#get_PRO_WORKS.WORK_ID#">
                    <div class="kanban_detail_title">
                      <a href="javascript://" style="background-color:#renk#;color:##fff">#get_PRO_WORKS.WORK_CAT#</a>
                      <div style="background:url('#get_PRO_WORKS.PHOTO#');background-size:cover;border-radius:25px;"  class="kanban_staff">
                        <a href="javascript://"></a>
                        <div class="custom_tooltip">
                          <p>#get_PRO_WORKS.EMPLOYEE_NAME# #get_PRO_WORKS.EMPLOYEE_SURNAME#</p>
                          <p>
                            <cfset work_detail = getComponentWork.DET_WORK(id : get_PRO_WORKS.work_id)>
                            <cfif len(work_detail.ESTIMATED_TIME)>
                              <cfset estimate_time_ = work_detail.ESTIMATED_TIME>
                              <cfset total=estimate_time_/60>
                              <cfset hour=listfirst(total,'.')>
                              <cfset minute_=estimate_time_-hour*60>
                              <i class="fa fa-clock-o" style="color:red" title="<cf_get_lang dictionary_id='38215.Öngörülen Zaman'>"></i> #hour# <cf_get_lang dictionary_id='57491.Saat'> #minute_# <cf_get_lang dictionary_id='58827.Dk'>
                            <cfelse>
                              <i class="fa fa-clock-o" style="color:red" title="<cf_get_lang dictionary_id='38215.Öngörülen Zaman'>"></i> 0 <cf_get_lang dictionary_id='57491.Saat'> 0 <cf_get_lang dictionary_id='58827.Dk'>
                            </cfif>
                          </p>
                          <p>
                            <cfif len(work_detail.harcanan_dakika)>
                              <cfset harcanan_ = work_detail.HARCANAN_DAKIKA>
                              <cfset liste=harcanan_/60>
                              <cfset saat=listfirst(liste,'.')>
                              <cfset dak=harcanan_-saat*60>
                              <i class="fa fa-clock-o" style="color:green" title="<cf_get_lang dictionary_id='34989.Harcanan Zaman'>"></i> #saat# <cf_get_lang dictionary_id='57491.Saat'> #dak# <cf_get_lang dictionary_id='58827.Dk'>
                            <cfelse>
                              <i class="fa fa-clock-o" style="color:green" title="<cf_get_lang dictionary_id='34989.Harcanan Zaman'>"></i> 0 <cf_get_lang dictionary_id='57491.Saat'> 0 <cf_get_lang dictionary_id='58827.Dk'>                 	
                            </cfif>
                          </p>
                        </div>
                      </div>
                    </div>
                    <div class="kanban_detail_body">
                      <div class="kanban_name">
                        <p>#get_PRO_WORKS.ACTIVITY_NAME#</p>
                        <p><cfif get_PRO_WORKS.IS_MILESTONE eq 1><b style="color:red">M </b></cfif><a href="#request.self#?fuseaction=project.works&event=det&id=#get_PRO_WORKS.WORK_ID#" style="color:black">#get_PRO_WORKS.WORK_HEAD#</a></p>
                        <p>  
                          <cfif len(get_PRO_WORKS.TERMINATE_DATE)> <i class="fa fa-clock-o" style="color:blue" title="<cf_get_lang dictionary_id='60609.Termin tarihi'>"></i> #dateformat(get_PRO_WORKS.TERMINATE_DATE,dateformat_style)# #TimeFormat(get_PRO_WORKS.TERMINATE_DATE,timeformat_style)#</cfif> 
                        </p>
                      </div>
                      <div class="progress">
                        <span style="width:#get_PRO_WORKS.TO_COMPLETE#%">#get_PRO_WORKS.TO_COMPLETE#%</span>
                        <div class="progress-bar" role="progressbar" aria-valuemin="0" aria-valuemax="100"></div>
                        <div style="display:none;" class="load">#get_PRO_WORKS.TO_COMPLETE#</div>
                      </div>
                    </div>
                  </div> 
                </cfloop>
              </div>
            </div>
          </cfoutput>
        <cfelseif attributes.sort_type eq 1>
          <cfoutput query="get_project_milestone"> 
            <div  class="kanban_grid cl-xl-2 cl-md-3 cl-sm-6 cl-12" id="#get_project_milestone.work_id#">
              <!--- Milestone'a bağlı işler --->
              <cfset get_PRO_WORKS =  getComponentKanban.get_PRO_WORKS(
                work_id         : get_project_milestone.work_id,
                work_cat        : (len(attributes.work_cat)) ? "#attributes.work_cat#" : "",
                currency        : (len(attributes.currency)) ? "#attributes.currency#" : "",
                priority_cat    : (len(attributes.priority_cat)) ? "#attributes.priority_cat#" : "",
                activity_id     : (len(attributes.activity_id)) ? "#attributes.activity_id#" : "",
                workgroup_id    :  (len(attributes.workgroup_id)) ? "#attributes.workgroup_id#" : "",
                work_status     : (len(attributes.work_status)) ? "#attributes.work_status#" : "",
                time_interval   : (len(attributes.time_interval)) ? "#attributes.time_interval#" : "",
                search_date1    : (len(attributes.search_date1)) ? "#attributes.search_date1#" : "",
                search_date2    : (len(attributes.search_date2)) ? "#attributes.search_date2#" : "",
                pro_employee    : (len(attributes.pro_employee)) ? "#attributes.pro_employee#" : "",
                pro_employee_id : (len(attributes.pro_employee_id)) ? "#attributes.pro_employee_id#" : "",
                is_milestone    : (len(attributes.is_milestone)) ? "#attributes.is_milestone#" : "",
                project_id      :(len(attributes.project_id)) ? "#attributes.project_id#" : "",
                project_head    : (len(attributes.project_head)) ? "#attributes.project_head#" : "",
                xml_is_all_authorization : xml_is_all_authorization,
                day_type : attributes.day_type
              )>
              <div class="kanban_title" id="#get_project_milestone.work_head#">
                <div class="kanban_hide_btn">
                  <a href="javascript://">
                    <i class="fa fa-chevron-down"></i>
                  </a>
                </div>
                <div class="kanban_add_btn">
                  <a href="javascript://" onclick="cfmodal('#request.self#?fuseaction=objects.popup_add_rapid_work&milestone_id=#get_project_milestone.work_id#&type=1&project_id=#attributes.project_id#','warning_modal');">
                    <i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i>
                  </a>
                </div>
                <div class="kanban_total">
                  #get_PRO_WORKS.recordcount#
                </div>
              </div>
              <div class="kanban_title_2" id="">
                <h2>#get_project_milestone.work_head#</h2>
              </div>
              <div class="kanban_box">
                <cfloop query="get_PRO_WORKS">            
                  <cfset diyez =chr(35)>                    
                  <cfset renk=#diyez# &'#color#'>
                  <cfif not len(color)>
                    <cfset renk=#diyez# &'ffc2b3'>
                  </cfif>
                  <div class="kanban_detail"  id="#get_PRO_WORKS.WORK_ID#">
                    <div class="kanban_detail_title">
                      <a href="javascript://" style="background-color:#renk#;color:##fff">#get_PRO_WORKS.WORK_CAT#</a>
                      <div style="background:url('#get_PRO_WORKS.PHOTO#');background-size:cover;border-radius:25px;"  class="kanban_staff">
                        <a href="javascript://"></a>
                        <div class="custom_tooltip">
                          <p>#get_PRO_WORKS.EMPLOYEE_NAME# #get_PRO_WORKS.EMPLOYEE_SURNAME#</p>
                          <p>
                            <cfset work_detail = getComponentWork.DET_WORK(id : get_PRO_WORKS.work_id)>
                            <cfif len(work_detail.ESTIMATED_TIME)>
                              <cfset estimate_time_ = work_detail.ESTIMATED_TIME>
                              <cfset total=estimate_time_/60>
                              <cfset hour=listfirst(total,'.')>
                              <cfset minute_=estimate_time_-hour*60>
                              <i class="fa fa-clock-o" style="color:red" title="<cf_get_lang dictionary_id='38215.Öngörülen Zaman'>"></i> #hour# <cf_get_lang dictionary_id='57491.Saat'> #minute_# <cf_get_lang dictionary_id='58827.Dk'>
                            <cfelse>
                              <i class="fa fa-clock-o" style="color:red" title="<cf_get_lang dictionary_id='38215.Öngörülen Zaman'>"></i> 0 <cf_get_lang dictionary_id='57491.Saat'> 0 <cf_get_lang dictionary_id='58827.Dk'>
                            </cfif>
                          </p>
                          <p>
                            <cfif len(work_detail.harcanan_dakika)>
                                  <cfset harcanan_ = work_detail.HARCANAN_DAKIKA>
                                  <cfset liste=harcanan_/60>
                                  <cfset saat=listfirst(liste,'.')>
                                  <cfset dak=harcanan_-saat*60>
                                  <i class="fa fa-clock-o" style="color:green" title="<cf_get_lang dictionary_id='34989.Harcanan Zaman'>"></i> #saat# <cf_get_lang dictionary_id='57491.Saat'> #dak# <cf_get_lang dictionary_id='58827.Dk'>
                            <cfelse>
                              <i class="fa fa-clock-o" style="color:green" title="<cf_get_lang dictionary_id='34989.Harcanan Zaman'>"></i> 0 <cf_get_lang dictionary_id='57491.Saat'> 0 <cf_get_lang dictionary_id='58827.Dk'>                 	
                            </cfif>
                          </p>
                        </div>
                      </div>
                    </div>
                    <div class="kanban_detail_body">
                      <div class="kanban_name">
                        <p>#get_PRO_WORKS.ACTIVITY_NAME#</p>
                        <p><cfif get_PRO_WORKS.IS_MILESTONE eq 1><b style="color:red">M </b></cfif><a href="#request.self#?fuseaction=project.works&event=det&id=#get_PRO_WORKS.WORK_ID#" style="color:black">#get_PRO_WORKS.WORK_HEAD#</a></p>
                        <p>  
                          <cfif len(get_PRO_WORKS.TERMINATE_DATE)> <i class="fa fa-clock-o" style="color:blue" title="<cf_get_lang dictionary_id='60609.Termin tarihi'>"></i> #dateformat(get_PRO_WORKS.TERMINATE_DATE,dateformat_style)# #TimeFormat(get_PRO_WORKS.TERMINATE_DATE,timeformat_style)#</cfif>
                          
                        </p>
                        
                      </div>
                      <div class="progress">
                        <span style="width:#get_PRO_WORKS.TO_COMPLETE#%">#get_PRO_WORKS.TO_COMPLETE#%</span>
                        <div class="progress-bar" role="progressbar" aria-valuemin="0" aria-valuemax="100"></div>
                        <div style="display:none;" class="load">#get_PRO_WORKS.TO_COMPLETE#</div>
                      </div>
                    </div>
                  </div> 
                  
                </cfloop>
              </div>
            </div>
          </cfoutput>
          <!--- Üst işten bağımsızlar --->
            <cfset get_pro_works_free =  getComponentKanban.get_PRO_WORKS(
              work_cat        : (len(attributes.work_cat)) ? "#attributes.work_cat#" : "",
              currency        : (len(attributes.currency)) ? "#attributes.currency#" : "",
              priority_cat    : (len(attributes.priority_cat)) ? "#attributes.priority_cat#" : "",
              activity_id     : (len(attributes.activity_id)) ? "#attributes.activity_id#" : "",
              workgroup_id    :  (len(attributes.workgroup_id)) ? "#attributes.workgroup_id#" : "",
              work_status     : (len(attributes.work_status)) ? "#attributes.work_status#" : "",
              time_interval   : (len(attributes.time_interval)) ? "#attributes.time_interval#" : "",
              search_date1    : (len(attributes.search_date1)) ? "#attributes.search_date1#" : "",
              search_date2    : (len(attributes.search_date2)) ? "#attributes.search_date2#" : "",
              pro_employee    : (len(attributes.pro_employee)) ? "#attributes.pro_employee#" : "",
              pro_employee_id : (len(attributes.pro_employee_id)) ? "#attributes.pro_employee_id#" : "",
              project_id      :(len(attributes.project_id)) ? "#attributes.project_id#" : "",
              project_head    : (len(attributes.project_head)) ? "#attributes.project_head#" : "",
              is_free         : 1,
              xml_is_all_authorization : xml_is_all_authorization,
              day_type : attributes.day_type
            )>
          <div  class="kanban_grid cl-xl-2 cl-md-3 cl-sm-6 cl-12" id="">
            <div class="kanban_title" id="">
              <div class="kanban_hide_btn">
                <a href="javascript://">
                  <i class="fa fa-chevron-down"></i>
                </a>
              </div>
              <div class="kanban_add_btn">
                <a href="javascript://" onclick="cfmodal('<cfoutput>#request.self#?fuseaction=objects.popup_add_rapid_work&milestone_id=&type=1&project_id=#attributes.project_id#</cfoutput>','warning_modal');">
                  <i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i>
                </a>
              </div>
              <div class="kanban_total">
                <cfoutput>#get_pro_works_free.recordcount#</cfoutput>
              </div>
            </div>
            <div class="kanban_title_2" id="">
              <h2><cf_get_lang dictionary_id="60690.Bağımsız işler"></h2>
            </div> 
            <div class="kanban_box">
              <cfoutput query="get_pro_works_free">
                <cfset diyez =chr(35)>                    
                  <cfset renk=#diyez# &'#color#'>
                  <cfif not len(color)>
                    <cfset renk=#diyez# &'ffc2b3'>
                  </cfif>
                  <div class="kanban_detail"  id="#WORK_ID#">
                    <div class="kanban_detail_title">
                      <a href="javascript://" style="background-color:#renk#;color:##fff">#WORK_CAT#</a>
                      <div style="background:url('#PHOTO#');background-size:cover;border-radius:25px;"  class="kanban_staff">
                        <a href="javascript://"></a>
                        <div class="custom_tooltip">
                          <p>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</p>
                          <p>
                            <cfset work_detail = getComponentWork.DET_WORK(id : work_id)>
                            <cfif len(work_detail.ESTIMATED_TIME)>
                              <cfset estimate_time_ = work_detail.ESTIMATED_TIME>
                              <cfset total=estimate_time_/60>
                              <cfset hour=listfirst(total,'.')>
                              <cfset minute_=estimate_time_-hour*60>
                              <i class="fa fa-clock-o" style="color:red" title="<cf_get_lang dictionary_id='38215.Öngörülen Zaman'>"></i> #hour# <cf_get_lang dictionary_id='57491.Saat'> #minute_# <cf_get_lang dictionary_id='58827.Dk'>
                            <cfelse>
                              <i class="fa fa-clock-o" style="color:red" title="<cf_get_lang dictionary_id='38215.Öngörülen Zaman'>"></i> 0 <cf_get_lang dictionary_id='57491.Saat'> 0 <cf_get_lang dictionary_id='58827.Dk'>
                            </cfif>
                          </p>
                          <p>
                            <cfif len(work_detail.harcanan_dakika)>
                                  <cfset harcanan_ = work_detail.HARCANAN_DAKIKA>
                                  <cfset liste=harcanan_/60>
                                  <cfset saat=listfirst(liste,'.')>
                                  <cfset dak=harcanan_-saat*60>
                                  <i class="fa fa-clock-o" style="color:green" title="<cf_get_lang dictionary_id='34989.Harcanan Zaman'>"></i> #saat# <cf_get_lang dictionary_id='57491.Saat'> #dak# <cf_get_lang dictionary_id='58827.Dk'>
                            <cfelse>
                              <i class="fa fa-clock-o" style="color:green" title="<cf_get_lang dictionary_id='34989.Harcanan Zaman'>"></i> 0 <cf_get_lang dictionary_id='57491.Saat'> 0 <cf_get_lang dictionary_id='58827.Dk'>                 	
                            </cfif>
                          </p>
                        </div>
                      </div>
                    </div>
                    <div class="kanban_detail_body">
                      <div class="kanban_name">
                        <p>#ACTIVITY_NAME#</p>
                        <p><cfif IS_MILESTONE eq 1><b style="color:red">M </b></cfif><a href="#request.self#?fuseaction=project.works&event=det&id=#WORK_ID#" style="color:black">#WORK_HEAD#</a></p>
                        <p>  
                          <cfif len(TERMINATE_DATE)> <i class="fa fa-clock-o" style="color:blue" title="<cf_get_lang dictionary_id='60609.Termin tarihi'>"></i> #dateformat(TERMINATE_DATE,dateformat_style)# #TimeFormat(TERMINATE_DATE,timeformat_style)#</cfif>
                        </p>
                        
                      </div>
                      <div class="progress">
                        <span style="width:#TO_COMPLETE#%">#TO_COMPLETE#%</span>
                        <div class="progress-bar" role="progressbar" aria-valuemin="0" aria-valuemax="100"></div>
                        <div style="display:none;" class="load">#TO_COMPLETE#</div>
                      </div>
                    </div>
                  </div> 
              </cfoutput>
            </div>
          </div>
        <cfelseif attributes.sort_type eq 2>
          <cfoutput query="get_employee_task"> 
            <cfif len(get_employee_task.employee_id)>
              <cfset employee_name = get_emp_info(get_employee_task.EMPLOYEE_ID,0,0)>
              <cfset task_employee = get_employee_task.EMPLOYEE_ID>
              <cfset task_employee_type = 1><!--- employee --->
              <cfset task_employee_id = get_employee_task.EMPLOYEE_ID>
              <cfset task_employee_cmp = "">
            <cfelseif len(get_employee_task.consumer_id)>
              <cfset employee_name = get_cons_info(get_employee_task.CONSUMER_ID,1,0)>
              <cfset task_employee = get_employee_task.CONSUMER_ID>
              <cfset task_employee_id = get_employee_task.CONSUMER_ID>
              <cfset task_employee_type = 2><!--- consumer --->
              <cfset task_employee_cmp = "">
            <cfelse>
              <cfset getComponent = createObject('component','V16.project.cfc.get_project_detail')>
              <cfset GET_COMPANY_PARTNER = getComponent.GET_COMPANY_PARTNER(PARTNER_ID :get_employee_task.PARTNER_ID)>       
              <cfset employee_name = '#GET_COMPANY_PARTNER.COMPANY_PARTNER_NAME# #GET_COMPANY_PARTNER.COMPANY_PARTNER_SURNAME#-#GET_COMPANY_PARTNER.NICKNAME#'>  
              <cfset task_employee = get_employee_task.PARTNER_ID>
              <cfset task_employee_id = get_employee_task.PARTNER_ID>
              <cfset task_employee_type = 3><!--- partner --->
              <cfset task_employee_cmp = GET_COMPANY_PARTNER.COMPANY_ID>
            </cfif>
            <div  class="kanban_grid cl-xl-2 cl-md-3 cl-sm-6 cl-12" id="#task_employee_id#-#task_employee_type#-#task_employee_cmp#">
              <cfset get_PRO_WORKS =  getComponentKanban.get_PRO_WORKS(
                work_cat        : (len(attributes.work_cat)) ? "#attributes.work_cat#" : "",
                currency        : (len(attributes.currency)) ? "#attributes.currency#" : "",
                priority_cat    : (len(attributes.priority_cat)) ? "#attributes.priority_cat#" : "",
                activity_id     : (len(attributes.activity_id)) ? "#attributes.activity_id#" : "",
                workgroup_id    :  (len(attributes.workgroup_id)) ? "#attributes.workgroup_id#" : "",
                work_status     : (len(attributes.work_status)) ? "#attributes.work_status#" : "",
                time_interval   : (len(attributes.time_interval)) ? "#attributes.time_interval#" : "",
                search_date1    : (len(attributes.search_date1)) ? "#attributes.search_date1#" : "",
                search_date2    : (len(attributes.search_date2)) ? "#attributes.search_date2#" : "",
                pro_employee    : (len(attributes.pro_employee)) ? "#attributes.pro_employee#" : "",
                pro_employee_id : (len(attributes.pro_employee_id)) ? "#attributes.pro_employee_id#" : "",
                is_milestone    : (len(attributes.is_milestone)) ? "#attributes.is_milestone#" : "",
                project_id      :(len(attributes.project_id)) ? "#attributes.project_id#" : "",
                project_head    : (len(attributes.project_head)) ? "#attributes.project_head#" : "",
                xml_is_all_authorization : xml_is_all_authorization,
                employee_id     : (len(get_employee_task.employee_id)) ? "#get_employee_task.employee_id#" : "",
                partner_id      : (len(get_employee_task.partner_id)) ? "#get_employee_task.partner_id#" : "",
                consumer_id     : (len(get_employee_task.consumer_id)) ? "#get_employee_task.consumer_id#" : "",
                day_type : attributes.day_type
              )>
              <div class="kanban_title" id="#get_PRO_WORKS.EMPLOYEE_NAME#">
                <div class="kanban_hide_btn">
                  <a href="javascript://">
                    <i class="fa fa-chevron-down"></i>
                  </a>
                </div>
                <div class="kanban_add_btn">
                  <a href="javascript://" onclick="cfmodal('#request.self#?fuseaction=objects.popup_add_rapid_work&process_id=#get_process_types.process_row_id#&type=0<cfif len(attributes.project_id)>&project_id=#attributes.project_id#</cfif>','warning_modal');">
                    <i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i>
                  </a>
                </div>
                <div class="kanban_total">
                  #get_PRO_WORKS.recordcount#
                </div>
              </div>
              <div class="kanban_title_2" id="">
                  <h2>#employee_name#</h2>
              </div>
              <div class="kanban_box">
                <cfloop query="get_PRO_WORKS">            
                  <cfset diyez =chr(35)>                    
                  <cfset renk=#diyez# &'#color#'>
                  <cfif not len(color)>
                    <cfset renk=#diyez# &'ffc2b3'>
                  </cfif>
                  <div class="kanban_detail"  id="#get_PRO_WORKS.WORK_ID#">
                    <div class="kanban_detail_title">
                      <a href="javascript://" style="background-color:#renk#;color:##fff">#get_PRO_WORKS.WORK_CAT#</a>
                      <div style="background:url('#get_PRO_WORKS.PHOTO#');background-size:cover;border-radius:25px;"  class="kanban_staff">
                        <a href="javascript://"></a>
                        <div class="custom_tooltip">
                          <p>#get_PRO_WORKS.EMPLOYEE_NAME# #get_PRO_WORKS.EMPLOYEE_SURNAME#</p>
                          <p>
                            <cfset work_detail = getComponentWork.DET_WORK(id : get_PRO_WORKS.work_id)>
                            <cfif len(work_detail.ESTIMATED_TIME)>
                              <cfset estimate_time_ = work_detail.ESTIMATED_TIME>
                              <cfset total=estimate_time_/60>
                              <cfset hour=listfirst(total,'.')>
                              <cfset minute_=estimate_time_-hour*60>
                              <i class="fa fa-clock-o" style="color:red" title="<cf_get_lang dictionary_id='38215.Öngörülen Zaman'>"></i> #hour# <cf_get_lang dictionary_id='57491.Saat'> #minute_# <cf_get_lang dictionary_id='58827.Dk'>
                            <cfelse>
                              <i class="fa fa-clock-o" style="color:red" title="<cf_get_lang dictionary_id='38215.Öngörülen Zaman'>"></i> 0 <cf_get_lang dictionary_id='57491.Saat'> 0 <cf_get_lang dictionary_id='58827.Dk'>
                            </cfif>
                          </p>
                          <p>
                            <cfif len(work_detail.harcanan_dakika)>
                                  <cfset harcanan_ = work_detail.HARCANAN_DAKIKA>
                                  <cfset liste=harcanan_/60>
                                  <cfset saat=listfirst(liste,'.')>
                                  <cfset dak=harcanan_-saat*60>
                                  <i class="fa fa-clock-o" style="color:green" title="<cf_get_lang dictionary_id='34989.Harcanan Zaman'>"></i> #saat# <cf_get_lang dictionary_id='57491.Saat'> #dak# <cf_get_lang dictionary_id='58827.Dk'>
                            <cfelse>
                              <i class="fa fa-clock-o" style="color:green" title="<cf_get_lang dictionary_id='34989.Harcanan Zaman'>"></i> 0 <cf_get_lang dictionary_id='57491.Saat'> 0 <cf_get_lang dictionary_id='58827.Dk'>                 	
                            </cfif>
                          </p>
                        </div>
                      </div>
                    </div>
                    <div class="kanban_detail_body">
                      <div class="kanban_name">
                        <p>#get_PRO_WORKS.ACTIVITY_NAME#</p>
                        <p><cfif get_PRO_WORKS.IS_MILESTONE eq 1><b style="color:red">M </b></cfif><a href="#request.self#?fuseaction=project.works&event=det&id=#get_PRO_WORKS.WORK_ID#" style="color:black">#get_PRO_WORKS.WORK_HEAD#</a></p>
                        <p>  
                          <cfif len(get_PRO_WORKS.TERMINATE_DATE)> <i class="fa fa-clock-o" style="color:blue" title="<cf_get_lang dictionary_id='60609.Termin tarihi'>"></i> #dateformat(get_PRO_WORKS.TERMINATE_DATE,dateformat_style)# #TimeFormat(get_PRO_WORKS.TERMINATE_DATE,timeformat_style)#</cfif>
                        </p>
                      </div>
                      <div class="progress">
                        <span style="width:#get_PRO_WORKS.TO_COMPLETE#%">#get_PRO_WORKS.TO_COMPLETE#%</span>
                        <div class="progress-bar" role="progressbar" aria-valuemin="0" aria-valuemax="100"></div>
                        <div style="display:none;" class="load">#get_PRO_WORKS.TO_COMPLETE#</div>
                      </div>
                    </div>
                  </div> 
                </cfloop>
              </div>
            </div>
          </cfoutput>
        </cfif>
      </div>
    </cfif>
  </cf_box>
</div>
<script>
  open_milestone();
  open_roles();
  
  function open_milestone(){
    if(document.getElementById("project_head").value != ""){
      document.getElementById("sort_type_div").style.display = "";	
    }else{
      document.getElementById("sort_type_div").style.display = "none";	
      document.getElementById("sort_type").value = 0;
    }
  }


  function open_roles(){
    if(document.getElementById("sort_type").value == 2){
      document.getElementById("sort_employee").style.display = "";	
    }else{
      document.getElementById("sort_employee").style.display = "none";	
    }
  }
  
  $(function(){
    
    $('.kanban_hide_btn').click(function(){
      if($(this).find("i").hasClass("fa fa-chevron-down")){
        $(this).find('i').removeClass("fa fa-chevron-down").addClass("fa fa-chevron-up");
      }
      else{
        $(this).find('i').removeClass("fa fa-chevron-up").addClass("fa fa-chevron-down");
      }
      $(this).parents(".kanban_grid").find('.muuri').toggle();
    });
    $('.kanban_staff').hover(function(){
      $(this).parent().parent().css("z-index","2");
      $(this).parent().find('.custom_tooltip').stop().fadeIn('fast');
    }, function(){
      $(this).parent().find('.custom_tooltip').stop().fadeOut('fast', function(){
        
      });
    });
  })
  $( window ).load(function() {
    $.each($('.load'), function(){
      var value = $(this).text();
      $(this).parent().find('.progress-bar').animate({
          "width" : value+"%"
      }, function(){
        $('.progress span').fadeIn();
      });
    })
  });
  var itemContainers = [].slice.call(document.querySelectorAll('.kanban_box'));
  var columnGrids = [];
  var boardGrid;
  itemContainers.forEach(function (container) {
    // Instantiate column grid.
    var grid = new Muuri(container, {
      items: '.kanban_detail',
      layoutDuration: 500,
      layoutEasing: 'ease',
      dragEnabled: true,
      dragSort: function () {
        return columnGrids;
      },
      dragSortInterval: 0,
      
      dragReleaseDuration:500,
      dragReleaseEasing: 'ease'
      
      
    })
    .on('dragStart', function (item) {
      
      item.getElement().style.width = item.getWidth() + 'px';
      item.getElement().style.height = item.getHeight() + 'px';
    })
    .on('dragReleaseEnd', function (item) {
      item.getElement().style.width = '';
      item.getElement().style.height = '';
      <cfif attributes.sort_type eq 2>
        grid_id = $(item.getElement()).parents(".kanban_grid").attr('id');
        grid_id = grid_id.split('-');
        parent_id = grid_id[0];
        employee_type = grid_id[1];
        partner_cmp_id = grid_id[2];
      <cfelse>
        parent_id = $(item.getElement()).parents(".kanban_grid").attr('id');
        employee_type = "";
        partner_cmp_id = "";
      </cfif>

      to_work_id = item.getElement().id;
      
      type = "<cfoutput>#attributes.sort_type#</cfoutput>";
      $.ajax({ 
          type:'POST',  
          url:'V16/report/cfc/kanban_board.cfc?method=query_Fonksiyon',  
          data: { 
          pro_work_ID : to_work_id, 
          type  : type,
          new_currency_ID: parent_id,
          milestone_work_id : parent_id,
          employee_type : employee_type,
          partner_cmp_id  : partner_cmp_id,
          new_emp_id  : parent_id
        }
      });
      columnGrids.forEach(function (grid) {
        grid.refreshItems();
      });
    })
    columnGrids.push(grid);
  });
</script>