<cfoutput>
    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
        <div class="form-group" id="item-subject">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58820.Başlık'></label>
            <div class="col col-8 col-xs-12"> 
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58820.Başlık'>!</cfsavecontent>
                <cfinput type="text" name="subject" id="subject" maxlength="200" value="#get_internaldemand.subject#" required="yes" message="#message#" style="width:360px;">
            </div>
        </div>
        <cfif isdefined("xml_show_process_cat") and len(xml_show_process_cat) and xml_show_process_cat eq 1 and is_demand eq 1> 
            <div class="form-group" id="item_process_cat">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'></label>
                <div class="col col-8 col-xs-12">
                    <cf_workcube_process_cat process_cat='#get_internaldemand.PROCESS_CAT#' slct_width="135">
                </div>
            </div>
        </cfif> 
        <div class="form-group" id="item-from_position_name">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30829.Talep Eden'></label>
            <div class="col col-8 col-xs-12"> 
                <div class="input-group">
                    <input type="hidden" name="from_company_id" id="from_company_id" value="#get_internaldemand.from_company_id#"><!--- c kurumsal üyeler için --->
                    <input type="hidden" name="from_partner_id" id="from_partner_id" value="#get_internaldemand.from_partner_id#"><!--- c kurumsal üyeler için --->
                    <input type="hidden" name="from_consumer_id" id="from_consumer_id" value="#get_internaldemand.from_consumer_id#"><!--- bireysel üyeler için --->
                    <input type="hidden" name="from_position_code" id="from_position_code" value="#get_internaldemand.from_position_code#"><!--- employee_id tutuyor --->  
                    <input type="text" name="from_name" id="from_name" value="<cfif len(get_internaldemand.from_position_code)>#get_emp_info(get_internaldemand.from_position_code,0,0)#<cfelseif len(get_internaldemand.from_partner_id)>#get_par_info(get_internaldemand.from_partner_id,0,0,0)#<cfelseif len(get_internaldemand.from_consumer_id)>#get_cons_info(get_internaldemand.from_consumer_id,0,0)#</cfif>" onFocus="AutoComplete_Create('from_name','MEMBER_PARTNER_NAME3','MEMBER_PARTNER_NAME3','get_member_autocomplete','','CONSUMER_ID,COMPANY_ID,EMPLOYEE_ID,PARTNER_ID','from_consumer_id,from_company_id,from_position_code,from_partner_id','','3','250');" autocomplete="off" required="yes" message="#message#" style="width:150px;">
                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_consumer=form_basket.from_consumer_id&field_emp_id=form_basket.from_position_code&field_name=form_basket.from_name&field_partner=form_basket.from_partner_id&field_comp_id=form_basket.from_company_id&is_form_submitted=1&field_dep_id=form_basket.emp_department_id&field_dep_name=form_basket.emp_department&select_list=1,7,8','list');" title="<cf_get_lang dictionary_id='30829.Talep Eden'>"></span>
                </div>
            </div>
        </div>
        <div class="form-group" id="item-position_code">
            <label class="col col-4 col-xs-12"><cfif (isDefined("xml_show_to_position_code") and xml_show_to_position_code eq 1) or not isDefined("xml_show_to_position_code")><cf_get_lang dictionary_id='57924.Kime'>*</cfif></label>
            <div class="col col-8 col-xs-12"> 
                <div class="input-group">
                    <input type="hidden" name="to_position_code" id="to_position_code" value="#get_internaldemand.to_position_code#">
                    <cfif (isDefined("xml_show_to_position_code") and xml_show_to_position_code eq 1) or not isDefined("xml_show_to_position_code")>
                        <cfinput type="text" name="position_code" id="position_code" style="width:130px;" required="yes" onFocus="AutoComplete_Create('position_code','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','to_position_code','','3','150');" autocomplete="off" value="#get_emp_info(get_internaldemand.to_position_code,1,0)#">
                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_code=form_basket.to_position_code&field_name=form_basket.position_code&select_list=1','list');" title="<cf_get_lang dictionary_id='57924.Kime'>"></span>
                    <cfelse>
                        <cfinput type="hidden" name="position_code" id="position_code" value="#get_emp_info(get_internaldemand.to_position_code,1,0)#">
                    </cfif>                                                                            
                </div>
            </div>
        </div>
        <div class="form-group" id="item-ship_method_name">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
            <div class="col col-8 col-xs-12"> 
                <div class="input-group">
                    <input type="hidden" name="ship_method" id="ship_method" value="#get_internaldemand.ship_method#">
                    <cfif len(get_internaldemand.ship_method)>
                        <cfset attributes.ship_method = get_internaldemand.ship_method>
                        <cfinclude template="../query/get_ship_method.cfm">
                    </cfif>
                    <input type="text" name="ship_method_name" id="ship_method_name" value="<cfif len(get_internaldemand.ship_method)>#get_ship_method.ship_method#</cfif>" readonly style="width:130px;">
                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method','list');" title="<cf_get_lang dictionary_id='29500.Sevk Yöntemi'>"></span>
                </div>
            </div>
        </div>
        <div class="form-group" id="item-form_ul_department">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Department'></label>
            <div class="col col-8 col-xs-12">
                <cfif listfirst(attributes.fuseaction,'.') is 'purchase'>	
                    <div class="input-group">
                        <input type="hidden" name="emp_department_id" id="emp_department_id" value="#get_department.department_id#">
                        <input type="text" name="emp_department" id="emp_department" value="#get_department.department_head#" onfocus="AutoComplete_Create('emp_department','DEPARTMENT_HEAD','DEPARTMENT_HEAD','get_department1','','DEPARTMENT_ID','emp_department_id','form_basket','3','200');" autocomplete="off">
                        <span  class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=form_basket.emp_department_id&field_dep_branch_name=form_basket.emp_department&is_store_module=1&is_function=1');"></span>
                    </div>
                <cfelse>
                    <input type="hidden" name="emp_department_id" id="emp_department_id" value="#get_department.department_id#">
                    <input type="text" name="emp_department" id="emp_department" value="#get_department.department_head#" readonly>
                </cfif>
            </div>
        </div>
    </div>
    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
        <div class="form-group" id="item-is_active">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
            <div class="col col-8 col-xs-12"> 
                <input type="checkbox" name="is_active" id="is_active" value="1" <cfif get_internaldemand.is_active eq 1>checked</cfif>>
            </div>
        </div>
        <div class="form-group" id="item-work_head">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51183.İş görev'></label>
            <div class="col col-8 col-xs-12"> 
                <div class="input-group">
                    <input type="hidden" name="work_id" id="work_id" value="#get_internaldemand.work_id#">
                    <input type="text" name="work_head" id="work_head" style="width:130px;" value="<cfif len(get_internaldemand.work_id)>#get_work_name(get_internaldemand.work_id)#</cfif>">
                    <cfif isdefined("x_project_from_work") and  x_project_from_work eq 1>
                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_add_work&field_id=form_basket.work_id&field_name=form_basket.work_head&project_id='+document.getElementById('project_id_out').value+'&project_head='+encodeURIComponent(document.getElementById('project_head_out').value)+'&field_pro_id=form_basket.project_id_out&field_pro_name=form_basket.project_head_out','list');" title="<cf_get_lang dictionary_id='51183.İş'>"></span>
                    <cfelse>                
                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_add_work&field_id=form_basket.work_id&field_name=form_basket.work_head','list');" title="<cf_get_lang dictionary_id='51183.İş'>"></span>
                    </cfif>
                </div>
            </div>
        </div>
        <div class="form-group" id="item-priority">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57485.Öncelik'></label>
            <div class="col col-8 col-xs-12"> 
                <select name="priority" id="priority" style="width:125px;">
                    <cfinclude template="../query/get_priority.cfm">
                    <cfloop query="get_priority">
                        <option value="#get_priority.priority_id#"<cfif get_internaldemand.priority eq get_priority.priority_id>selected</cfif>>#priority#</option> 
                    </cfloop>
                </select>
            </div>
        </div>
        <div class="form-group" id="item-process">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
            <div class="col col-8 col-xs-12"> 
                <cf_workcube_process is_upd='0' select_value='#get_internaldemand.internaldemand_stage#' process_cat_width='125' is_detail='1'>
            </div>
        </div>
        <div class="form-group" id="item-ref_no">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58784.Referans'></label>
            <div class="col col-8 col-xs-12"> 
                <input type="text" name="ref_no" id="ref_no" style="width:125px;" maxlength="200" value="#get_internaldemand.ref_no#">
            </div>
        </div>
        <div class="form-group" id="item-target_date">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57645.Teslim Tarihi'></label>
            <div class="col col-8 col-xs-12"> 
                <div class="input-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57645.Teslim Tarihi'></cfsavecontent>
                    <cfset target_date_ = "">
                    <cfif len(get_internaldemand.target_date)><cfset target_date_ = DateFormat(get_internaldemand.target_date,dateformat_style)></cfif>
                    <!---<cfif is_target_date eq 1> 
                        <cfinput type="text" name="target_date"  required="Yes" style="width:105px;"  value="#target_date_#" validate="#validate_style#" message="#message#" maxlength="10" >						
                    <cfelse>--->
                        <cfinput type="text" name="target_date" style="width:105px;"  value="#target_date_#" validate="#validate_style#" message="#message#" maxlength="10" >
                    <!---</cfif>--->
                    <span class="input-group-addon"><cf_wrk_date_image date_field="target_date"></span>
                </div>
            </div>
        </div>
    </div>
    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
        <div class="form-group" id="item-service_no">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57656.Servis'></label>
            <div class="col col-8 col-xs-12"> 
                <div class="input-group">
                    <cfif len(get_internaldemand.service_id)>
                        <cfquery name="get_service" datasource="#dsn3#">
                            SELECT SERVICE_NO,SERVICE_HEAD FROM SERVICE WHERE SERVICE_ID = #get_internaldemand.service_id#
                        </cfquery>
                    </cfif>
                    <input type="hidden" name="service_id" id="service_id"  value="<cfif len(get_internaldemand.service_id)>#get_internaldemand.service_id#</cfif>">
                    <input type="text" name="service_no" id="service_no" value="<cfif len(get_internaldemand.service_id)>#get_service.service_no# #get_service.service_head#</cfif>" style="width:130px;"  maxlength="50">                                    
                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_service&field_id=form_basket.service_id&field_no=form_basket.service_no','list');" title="<cf_get_lang dictionary_id='51183.İş'>"></span>
                </div>
            </div>
        </div>
        <div class="form-group" id="item-notes">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
            <div class="col col-8 col-xs-12"> 
                <textarea name="notes" id="notes" style="width:135px;height:50px;">#get_internaldemand.notes#</textarea>
            </div>
        </div>
        <div class="form-group" id="item-cf_wrk_add_info">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57810.Ek Bilgi'></label>
            <div class="col col-8 col-xs-12"> 
                <cfif is_demand eq 1>
                    <cf_wrk_add_info info_type_id="-28" info_id="#attributes.id#" upd_page = "1" colspan="9"> 
                <cfelse>
                    <cf_wrk_add_info info_type_id="-29" info_id="#attributes.id#" upd_page = "1" colspan="9">
                </cfif>
            </div>
        </div>   
        <cfif session.ep.our_company_info.workcube_sector is 'tersane'>
            <div class="form-group" id="item-dpl_no">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47681.DPL'></label>
                <div class="col col-8 col-xs-12"> 
                    <div class="input-group">
                        <cfif len(get_internaldemand.dpl_id)>
                            <cfquery name="get_dpl" datasource="#dsn3#">
                                SELECT DPL_NO FROM DRAWING_PART WHERE DPL_ID = #get_internaldemand.dpl_id#
                            </cfquery>
                        </cfif>
                        <input type="hidden" name="dpl_id" id="dpl_id" value="#get_internaldemand.dpl_id#"> 
                        <input type="text" name="dpl_no" id="dpl_no" value="<cfif len(get_internaldemand.dpl_id)>#get_dpl.dpl_no#</cfif>" style="width:130px;">                                        
                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_drawing_parts&field_id=form_basket.dpl_id&field_name=form_basket.dpl_no','medium');"></span>
                    </div>
                </div>
            </div>
        </cfif>
    </div>
    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
            <cfif is_demand eq 0>
                <div class="form-group" id="item-location_in_id">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33658.Giriş Depo'></label>
                    <div class="col col-8 col-xs-12"> 
                        <cfset search_dep_id=get_internaldemand.department_in>
                        <cfif len(get_internaldemand.department_in) and isnumeric(get_internaldemand.department_in)>
                            <cfinclude template="../query/get_dep_names_for_inter.cfm">
                            <cfset txt_department_name=get_name_of_dep.DEPARTMENT_HEAD>
                            <cfif len(search_dep_id) and len(trim(get_internaldemand.LOCATION_IN))>
                                <cfset search_location_id = get_internaldemand.LOCATION_IN>
                                <cfinclude template="../query/get_location_for_inter.cfm">
                                <cfset txt_department_name = txt_department_name & "-" & get_location.COMMENT>
                                <cfset txt_department_id = "#get_location.DEPARTMENT_LOCATION#" >
                            <cfelse>
                                <cfset txt_department_id="#search_dep_id#">
                            </cfif>
                        <cfelse>
                            <cfset txt_department_name = "">
                            <cfset txt_department_id = "">
                        </cfif>
                        <cf_wrkdepartmentlocation 
                            returnInputValue="location_in_id,department_in_txt,department_in_id,branch_id"
                            returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                            fieldName="department_in_txt"
                            fieldid="location_in_id"
                            department_fldId="department_in_id"
                            department_id="#get_internaldemand.DEPARTMENT_IN#"
                            location_id="#get_internaldemand.LOCATION_IN#"
                            user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                            line_info = 2
                            xml_all_depo = "#xml_all_depo_entry#"
                            width="135">
                    </div>
                </div>
        <cfelse>
                <div class="form-group" id="item-location_in_id">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33658.Giriş Depo'></label>
                    <div class="col col-8 col-xs-12"> 
                        <cfset search_dep_id=get_internaldemand.DEPARTMENT_IN>
                        <cfif len(get_internaldemand.DEPARTMENT_IN) and isnumeric(get_internaldemand.DEPARTMENT_IN)>
                            <cfinclude template="../query/get_dep_names_for_inter.cfm">
                            <cfset txt_department_name=get_name_of_dep.DEPARTMENT_HEAD>
                            <cfif len(search_dep_id) and len(trim(get_internaldemand.LOCATION_IN))>
                                <cfset search_location_id = get_internaldemand.LOCATION_IN>
                                <cfinclude template="../query/get_location_for_inter.cfm">
                                <cfset txt_department_name = txt_department_name & "-" & get_location.COMMENT>
                                <cfset txt_department_id = "#get_location.DEPARTMENT_LOCATION#" >
                            <cfelse>
                                <cfset txt_department_id="#search_dep_id#">
                            </cfif>
                        <cfelse>
                            <cfset txt_department_name = "">
                            <cfset txt_department_id = "">
                        </cfif>
                        <cf_wrkdepartmentlocation 
                            returnInputValue="location_in_id,department_in_txt,department_in_id,branch_id"
                            returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                            fieldName="department_in_txt"
                            fieldid="location_in_id"
                            department_fldId="department_in_id"
                            department_id="#get_internaldemand.DEPARTMENT_IN#"
                            location_id="#get_internaldemand.LOCATION_IN#"
                            user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                            line_info = 2
                            xml_all_depo = "#xml_all_depo_entry#"
                            width="135">
                    </div>
                </div>
        </cfif>
        <cfif is_demand eq 0>
                <div class="form-group" id="item-project_head">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57554.Giriş'><cf_get_lang dictionary_id='57416.Proje'></label>
                    <div class="col col-8 col-xs-12"> 
                        <div class="input-group">
                            <input type="hidden" name="project_id" id="project_id" value="#get_internaldemand.project_id#">
                            <input type="text" name="project_head" id="project_head" style="width:135px;" value="<cfif len(get_internaldemand.project_id)>#get_project_name(get_internaldemand.project_id)#</cfif>"  onFocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket','3','130')"autocomplete="off">
                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');" title="<cf_get_lang dictionary_id='57416.Proje'>"></span>
                            <span class="input-group-addon btnPointer" onClick="if(document.getElementById('project_id').value!='')windowopen('#request.self#?fuseaction=project.popup_list_project_actions&from_paper=INTERNALDEMAND&id='+document.getElementById('project_id').value+'','horizantal');else alert('Proje Seçiniz');" title="<cf_get_lang dictionary_id='57416.Proje'>">?</span>
                        </div>
                    </div>
                </div>
        <cfelse>
                <div class="form-group" id="item-project_head">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57554.Giriş'><cf_get_lang dictionary_id='57416.Proje'></label>
                    <div class="col col-8 col-xs-12"> 
                        <div class="input-group">
                            <input type="hidden" name="project_id" id="project_id" value="#get_internaldemand.project_id#">
                            <input type="text" name="project_head" id="project_head" style="width:135px;" value="<cfif len(get_internaldemand.project_id)>#get_project_name(get_internaldemand.project_id)#</cfif>"  onFocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket','3','130')"autocomplete="off">                                        
                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');" title="<cf_get_lang dictionary_id='57416.Proje'>"></span>
                            <span class="input-group-addon btnPointer" onClick="if(document.getElementById('project_id').value!='')windowopen('#request.self#?fuseaction=project.popup_list_project_actions&from_paper=INTERNALDEMAND&id='+document.getElementById('project_id').value+'','horizantal');else alert('Proje Seçiniz');" title="<cf_get_lang dictionary_id='57416.Proje'>">?</span>
                        </div>
                    </div>
                </div>
        </cfif>
            <div class="form-group" id="item-project_head_out">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57431.Çıkış'><cf_get_lang dictionary_id='57416.Proje'></label>
                <div class="col col-8 col-xs-12"> 
                    <div class="input-group">
                        <input type="hidden" name="project_id_out" id="project_id_out" value="#get_internaldemand.project_id_out#">
                        <input type="text" name="project_head_out" id="project_head_out" style="width:135px;" value="<cfif len(get_internaldemand.project_id_out)>#get_project_name(get_internaldemand.project_id_out)#</cfif>"  onFocus="AutoComplete_Create('project_head_out','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id_out','form_basket','3','130')"autocomplete="off"> 
                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id_out&project_head=form_basket.project_head_out');" title="<cf_get_lang dictionary_id='57416.Proje'>"></span>
                        <span class="input-group-addon btnPointer" onClick="if(document.getElementById('project_id_out').value!='')windowopen('#request.self#?fuseaction=project.popup_list_project_actions&from_paper=INTERNALDEMAND&id='+document.getElementById('project_id_out').value+'','horizantal');else alert('Proje Seçiniz');" title="<cf_get_lang dictionary_id='57416.Proje'>">?</span>
                    </div>
                </div>
            </div>                        
            <div class="form-group" id="item-search_dep_id">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29428.Çıkış Depo'></label>
                <div class="col col-8 col-xs-12"> 
                    <cfset search_dep_id=get_internaldemand.department_out>
                    <cfif len(search_dep_id)>
                        <cfinclude template="../query/get_dep_names_for_inter.cfm">
                        <cfset txt_department_name=get_name_of_dep.department_head>
                    <cfelse>
                        <cfset txt_department_name = ''>
                    </cfif>
                    <cfif len(search_dep_id) and len(trim(get_internaldemand.location_out))>
                        <cfset search_location_id = get_internaldemand.location_out>
                        <cfinclude template="../query/get_location_for_inter.cfm">
                        <cfset txt_department_name = txt_department_name & "-" & get_location.comment>
                        <cfset txt_department_id = "#get_location.department_location#">
                    <cfelse>
                        <cfset txt_department_id="#search_dep_id#">
                    </cfif>
                    <cf_wrkdepartmentlocation 
                        returnInputValue="location_id,txt_departman_,department_id,branch_id"
                        returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                        fieldName="txt_departman_"
                        department_id="#get_internaldemand.department_out#"
                        location_id="#get_internaldemand.location_out#"
                        user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                        line_info = 1
                        xml_all_depo = "#xml_all_depo_outer#"
                        width="135">
                </div>
            </div>
    </div>	            	
</cfoutput>