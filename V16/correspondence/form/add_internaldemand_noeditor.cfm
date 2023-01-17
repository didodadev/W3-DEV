<!--- <cfif isdefined("attributes.target_date") and isdate(attributes.target_date)>
	<cf_date tarih="attributes.target_date">
</cfif> --->
<cfif not isdefined("is_demand")>
	<cfset is_demand=0>
</cfif>
<cfif isdefined("internal_number_list") and len(internal_number_list)>
    <cfparam name="attributes.ref_no" default="#internal_number_list#">
<cfelse>
    <cfparam name="attributes.ref_no" default="">
</cfif>
<cfif isdefined("attributes.id") and len(attributes.id)>
	<cfscript>
        get_demand_list_action = CreateObject("component","V16.correspondence.cfc.get_demand");
        get_dep = createObject("component","V16.myhome.cfc.get_travel_demands");
        get_demand_list_action.dsn = dsn3;
        get_internaldemand = get_demand_list_action.get_demand_list_fnc(
        is_demand:'#iif(isdefined("is_demand"),"is_demand",DE(""))#',
        id:'#iif(isdefined("attributes.id"),"attributes.id",DE(""))#'
        );
	</cfscript>
<cfelse>
	<cfset get_internaldemand.recordcount=0>
</cfif>
<cfscript>
    get_dep = createObject("component","V16.myhome.cfc.get_travel_demands");
    get_dep.dsn = dsn;
</cfscript>
<cfif get_internaldemand.recordcount>
	<cfset attributes.subject=get_internaldemand.subject>
	<cfset attributes.from_position_code=get_internaldemand.from_position_code>
    <cfif len(get_internaldemand.from_position_code)>
    	<cfset attributes.from_position_name=get_emp_info(get_internaldemand.from_position_code,0,0)>
    <cfelse>
    	<cfset attributes.from_position_name="">
	</cfif>
    
    <cfif len(attributes.from_position_code)>
        <cfset get_department = get_dep.get_department(position_code : attributes.from_position_code)>
        <cfset attributes.emp_department_head = get_department.department_head>
        <cfset attributes.emp_department_id= get_department.department_id>
    <cfelse>
        <cfset attributes.emp_department_head = ''>
        <cfset attributes.emp_department_id= ''>
    </cfif>
    
    <cfset attributes.priority=get_internaldemand.priority>
    <cfset attributes.service_id=get_internaldemand.service_id>
    <cfif len(get_internaldemand.service_id)>
        <cfquery name="get_service" datasource="#dsn3#">
            SELECT SERVICE_NO,SERVICE_HEAD FROM SERVICE WHERE SERVICE_ID = #get_internaldemand.service_id#
        </cfquery>
        <cfset attributes.service_no=get_service.service_no&' '&get_service.service_head>
    <cfelse>
   		<cfset attributes.service_no="">
    </cfif>
   	<cfset attributes.department_out=get_internaldemand.department_out>
    <cfset attributes.location_out=get_internaldemand.location_out>
	<cfset attributes.department_in=get_internaldemand.department_in>
    <cfset attributes.location_in=get_internaldemand.location_in>
	<cfset attributes.to_position_code=get_internaldemand.to_position_code>
    <cfif len(get_internaldemand.to_position_code)>
    	<cfset attributes.position_code=get_emp_info(get_internaldemand.to_position_code,1,0)>
    <cfelse>
    	<cfset attributes.position_code="">
    </cfif>
   	<cfset attributes.notes=get_internaldemand.notes>
    <cfset attributes.project_id=get_internaldemand.project_id>
    <cfif len(get_internaldemand.project_id)>
		<cfset attributes.project_head=get_project_name(get_internaldemand.project_id)>
    <cfelse>
    	<cfset attributes.project_head="">   
	</cfif>
    <cfset attributes.ship_method = get_internaldemand.ship_method>
	<cfif len(get_internaldemand.ship_method)>
       <cfinclude template="../query/get_ship_method.cfm">
       <cfset attributes.ship_method_name=get_ship_method.ship_method>
	<cfelse>
    	<cfset attributes.ship_method_name="">      
    </cfif>
    <cfset attributes.project_id_out=get_internaldemand.project_id_out>
    <cfif len(get_internaldemand.project_id_out)>
		<cfset attributes.project_head_out=get_project_name(get_internaldemand.project_id_out)>
    <cfelse>
    	<cfset attributes.project_head_out="">
	</cfif>
    <cfset attributes.work_id=get_internaldemand.work_id>
    <cfif len(get_internaldemand.work_id)>
		<cfset attributes.work_head=get_work_name(get_internaldemand.work_id)>
    <cfelse>
    	<cfset attributes.work_head="">
	</cfif>
    <cfset attributes.target_date=get_internaldemand.target_date>
    <cfset attributes.dpl_id=get_internaldemand.dpl_id>
    <cfif len(get_internaldemand.dpl_id)>
		<cfquery name="get_dpl" datasource="#dsn3#">
           SELECT DPL_NO FROM DRAWING_PART WHERE DPL_ID = #get_internaldemand.dpl_id#
        </cfquery>
     	<cfset attributes.dpl_no=get_dpl.dpl_no>
    <cfelse>
    	<cfset attributes.dpl_no="">
	</cfif>
    <cfset attributes.is_active=get_internaldemand.is_active>
    <cfset attributes.ref_no=get_internaldemand.ref_no>
<cfelse>
	<cfif is_demand eq 1>
    	<cfset attributes.subject=getLang('main',2271)>
	<cfelse>
    	<cfset attributes.subject=getLang('main',1386)>
    </cfif>
	<cfif isdefined("attributes.service_id") and len(attributes.service_id)>
        <cfquery name="get_service" datasource="#dsn3#">
            SELECT SERVICE_NO,SERVICE_HEAD,PROJECT_ID FROM SERVICE WHERE SERVICE_ID = #attributes.service_id#
        </cfquery>
        <cfset attributes.service_no=get_service.service_no>
        <cfset attributes.service_name=get_service.service_no&' '&get_service.service_head>
        <cfset attributes.ref_no=attributes.service_no>
    <cfelse>
   		<cfset attributes.service_no="">
        <cfset attributes.service_name="">
    </cfif>
	<cfif len(attributes.ref_no)>
		<cfset attributes.ref_no = attributes.ref_no>
	<cfelse>
		<cfset attributes.ref_no = "">
	</cfif>
   <cfif isdefined('x_to_position_code') and len(x_to_position_code)>
        <cfset attributes.to_position_code=x_to_position_code>
        <cfset attributes.position_code=get_emp_info(x_to_position_code,1,0)>
    <cfelse>
        <cfset attributes.to_position_code="">  
        <cfset attributes.position_code="">                     
    </cfif>
    <cfif isdefined("attributes.work_id") and len(attributes.work_id)>
		<cfset attributes.work_id=attributes.work_id>
		<cfset attributes.work_head=get_work_name(attributes.work_id)>
    </cfif>
    <cfif isdefined("pro_material_work_list")  and len(pro_material_work_list)>
    	<cfscript>
            if(ListLen(ListDeleteDuplicates(pro_material_work_list),',') eq 1){
                attributes.work_id = ListDeleteDuplicates(pro_material_work_list);
                attributes.work_head=get_work_name(attributes.work_id);
            }
            else {
                attributes.work_id = "";
                attributes.work_head="";
            }
        </cfscript>
    </cfif>
    <cfif isdefined("attributes.service_id") and len(attributes.service_id)>
        <cfif len(get_service.PROJECT_ID)>
            <cfset attributes.project_id_out=get_service.PROJECT_ID>
            <cfset attributes.project_head_out=get_project_name(get_service.PROJECT_ID)>
        </cfif>
    </cfif>
	<cfif not isdefined("attributes.target_date")><cfset attributes.target_date=""></cfif>
    <cfif isdefined("attributes.from_position_code") and len(attributes.from_position_code)>
        <cfset attributes.from_position_name=get_emp_info(attributes.from_position_code,0,0)>
    <cfelseif x_is_from_employee_id eq 1>
    	<cfset attributes.from_position_code=session.ep.userid>
        <cfset attributes.from_position_name=get_emp_info(session.ep.userid,0,0)>
    <cfelse>
    	<cfset attributes.from_position_code="">
        <cfset attributes.from_position_name="">
	</cfif>
    <cfif len(attributes.from_position_code)>
        <cfset get_department = get_dep.get_department(position_code : session.ep.position_code)>
        <cfset attributes.emp_department_head = get_department.department_head>
        <cfset attributes.emp_department_id= get_department.department_id>
    <cfelse>
        <cfset attributes.emp_department_head = ''>
        <cfset attributes.emp_department_id= ''>
    </cfif>
    <cfset attributes.search_dep_id="">
    <cfset attributes.search_location_id="">
    <cfif isdefined("attributes.project_id") and len(attributes.project_id)>
    	<cfset attributes.project_id=attributes.project_id>
        <cfset attributes.project_head=get_project_name(attributes.project_id)>
    <cfelse>
    	<cfset attributes.project_id="">
        <cfset attributes.project_head="">
    </cfif>
    <cfif isdefined("attributes.project_id_out") and len(attributes.project_id_out)>
        <cfset attributes.project_id_out=attributes.project_id_out>
        <cfset attributes.project_head_out=get_project_name(attributes.project_id_out)>
    <cfelse>
        <cfset attributes.project_id_out=""> 
        <cfset attributes.project_head_out=""> 
    </cfif>
    <cfset attributes.is_active=1>
</cfif>
<cfif isdefined("attributes.offer_id") and len(attributes.offer_id)>
	<cfquery name="get_offer_no" datasource="#dsn3#">
		SELECT OFFER_NUMBER FROM OFFER WHERE OFFER_ID = #attributes.offer_id#
	</cfquery>
	<cfset attributes.ref_no = get_offer_no.OFFER_NUMBER>
</cfif>
<div class="col col-12 col-xs-12">
    <cf_box>
        <div id="basket_main_div">
            <cfform name="form_basket" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_internaldemand" method="post">
                <cfoutput>
                    <cf_basket_form id="internaldemand">
                        <cf_box_elements>
                            <input type="hidden" name="form_action_address" id="form_action_address" value="#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_internaldemand">
                            <input type="hidden"  name="is_demand" id="is_demand" value="<cfoutput>#is_demand#</cfoutput>">
                            <input type="hidden" name="search_process_date" id="search_process_date" value="target_date">
                            <input type="hidden" name="offer_id" id="offer_id"  value="<cfif isdefined("attributes.offer_id")>#attributes.offer_id#</cfif>">
                            <input type="hidden" name="pro_material_id_list" id="pro_material_id_list" value="<cfif isdefined('pro_material_id_list') and len(pro_material_id_list)>#pro_material_id_list#</cfif>">
                            <input type="hidden" name="internaldemand_id_list" id="internaldemand_id_list" value="<cfif isdefined('attributes.internal_row_info') and isdefined('internaldemand_id_list') and len(internaldemand_id_list)>#internaldemand_id_list#</cfif>">
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">                      
                                <div class="form-group" id="item-subject">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58820.Başlık'></label>
                                    <div class="col col-8 col-xs-12"> 
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58820.Başlık'>!</cfsavecontent>
                                        <cfsavecontent variable="talep">#attributes.subject#</cfsavecontent>
                                        <cfinput type="text" name="subject" maxlength="200" style="width:370px;" value="#talep#" required="yes" message="#message#">
                                    </div>
                                </div>
                                <cfif isdefined("xml_show_process_cat") and len(xml_show_process_cat) and xml_show_process_cat eq 1 and is_demand eq 1> 
                                    <div class="form-group" id="item_process_cat">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'></label>
                                        <div class="col col-8 col-xs-12">
                                            <cf_workcube_process_cat slct_width="150"  >
                                        </div>
                                    </div>
                                </cfif>    
                                <div class="form-group" id="item-from_position_name">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30829.Talep Eden'></label>
                                    <div class="col col-8 col-xs-12"> 
                                        <div class="input-group">
                                            <input type="hidden" name="from_company_id" id="from_company_id" value="<cfif isdefined("attributes.from_company_id") and len(attributes.from_company_id)>#attributes.from_company_id#</cfif>"><!--- kurumsal üyeler için --->
                                            <input type="hidden" name="from_partner_id" id="from_partner_id" value="<cfif isdefined("attributes.from_partner_id") and len(attributes.from_partner_id)>#attributes.from_partner_id#</cfif>"><!--- kurumsal üyeler için --->
                                            <input type="hidden" name="from_consumer_id" id="from_consumer_id" value="<cfif isdefined("attributes.from_consumer_id") and len(attributes.from_consumer_id)>#attributes.from_consumer_id#</cfif>"><!--- bireysel üyeler için --->              
                                            <input type="hidden" name="from_position_code" id="from_position_code" value="<cfif isdefined("attributes.from_position_code") and len(attributes.from_position_code)>#attributes.from_position_code#</cfif>"><!--- employee_id tutuyor --->              
                                            <input type="text" name="from_position_name" id="from_position_name" value="<cfif isdefined("attributes.from_position_code") and len(attributes.from_position_code)>#get_emp_info(attributes.from_position_code,0,0)#<cfelseif isdefined("attributes.from_partner_id") and len(attributes.from_partner_id)>#get_par_info(attributes.from_partner_id,0,0,0)#<cfelseif isdefined("attributes.from_consumer_id") and  len(attributes.from_consumer_id)>#get_cons_info(attributes.from_consumer_id,0,0)#</cfif>" onfocus="AutoComplete_Create('from_position_name','MEMBER_PARTNER_NAME3','MEMBER_PARTNER_NAME3','get_member_autocomplete','','CONSUMER_ID,COMPANY_ID,EMPLOYEE_ID,PARTNER_ID','from_consumer_id,from_company_id,from_position_code,from_partner_id','','3','250');" autocomplete="off" required="yes" message="#message#" style="width:130px;">                         
                                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=form_basket.from_position_code&field_name=form_basket.from_position_name&field_partner=form_basket.from_partner_id&field_consumer=form_basket.from_consumer_id&field_comp_id=form_basket.from_company_id&is_form_submitted=1&field_dep_id=form_basket.emp_department_id&field_dep_name=form_basket.emp_department&select_list=1,7,8');" title="<cf_get_lang dictionary_id='30829.Talep Eden'>"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-position_code">
                                    <label class="col col-4 col-xs-12"><cfif (isDefined("xml_show_to_position_code") and xml_show_to_position_code eq 1) or not isDefined("xml_show_to_position_code")><cf_get_lang dictionary_id='57924.Kime'></cfif></label>
                                    <div class="col col-8 col-xs-12"> 
                                        <div class="input-group">
                                            <input type="hidden" name="to_position_code" id="to_position_code" value="<cfif isdefined("attributes.to_position_code") and len(attributes.to_position_code)>#attributes.to_position_code#</cfif>">
                                            <cfif (isDefined("xml_show_to_position_code") and xml_show_to_position_code eq 1) or not isDefined("xml_show_to_position_code")>
                                                <input type="text" name="position_code" id="position_code" style="width:130px;" onfocus="AutoComplete_Create('position_code','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','to_position_code','','3','150');" autocomplete="off" value="<cfif isdefined("attributes.to_position_code") and len(attributes.to_position_code)>#attributes.position_code#</cfif>">
                                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_code=form_basket.to_position_code&field_name=form_basket.position_code&select_list=1');" title="<cf_get_lang dictionary_id='57924.Kime'>"></span>
                                            <cfelse>
                                                <input type="hidden" name="position_code" id="position_code" value="<cfif isdefined("attributes.to_position_code") and len(attributes.to_position_code)>#attributes.position_code#</cfif>">
                                            </cfif>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-ship_method_name">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
                                    <div class="col col-8 col-xs-12"> 
                                        <div class="input-group">
                                            <input type="hidden" name="ship_method" id="ship_method" value="<cfif isdefined("attributes.id") and len("attributes.ship_method")>#attributes.ship_method#</cfif>">
                                            <input type="text" name="ship_method_name" id="ship_method_name" readonly value="<cfif isdefined("attributes.id") and len("attributes.ship_method_name")>#attributes.ship_method_name#</cfif>" style="width:130px;">
                                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method');" title="<cf_get_lang dictionary_id='29500.Sevk Yöntemi'>"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-form_ul_department">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Department'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfif listfirst(attributes.fuseaction,'.') is 'purchase'>	
                                            <div class="input-group">
                                                <input type="hidden" name="emp_department_id" id="emp_department_id" value="<cfif isdefined('attributes.emp_department_id')><cfoutput>#attributes.emp_department_id#</cfoutput></cfif>">
                                                <input type="text" name="emp_department" id="emp_department" value="<cfif isdefined('attributes.emp_department_head')><cfoutput>#attributes.emp_department_head#</cfoutput></cfif>" onfocus="AutoComplete_Create('emp_department','DEPARTMENT_HEAD','DEPARTMENT_HEAD','get_department1','','DEPARTMENT_ID','emp_department_id','form_basket','3','200');" autocomplete="off">
                                                <span  class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=form_basket.emp_department_id&field_dep_branch_name=form_basket.emp_department&is_store_module=1');"></span>
                                            </div>
                                        <cfelse>
                                            <input type="hidden" name="emp_department_id" id="emp_department_id" value="<cfif isdefined('attributes.emp_department_id')><cfoutput>#attributes.emp_department_id#</cfoutput></cfif>">
                                            <input type="text" name="emp_department" id="emp_department" value="<cfif isdefined('attributes.emp_department_head')><cfoutput>#attributes.emp_department_head#</cfoutput></cfif>" readonly>
                                        </cfif>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true"> 
                                <div class="form-group" id="item-is_active">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                                    <div class="col col-8 col-xs-12"> 
                                        <input type="checkbox" name="is_active" id="is_active" value="1" <cfif attributes.is_active eq 1>checked</cfif>>
                                    </div>
                                </div>      
                                <div class="form-group" id="item-work_head">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51183.İş görev'></label>
                                    <div class="col col-8 col-xs-12"> 
                                        <div class="input-group">
                                            <input type="hidden" name="work_id" id="work_id" value="<cfif isdefined("attributes.id") and len("attributes.work_id")>#attributes.work_id#</cfif>">
                                            <input type="text" name="work_head" id="work_head" style="width:130px;" value="<cfif isdefined("attributes.id") and len("attributes.work_head")>#attributes.work_head#</cfif>">
                                            <cfif isdefined('x_project_from_work') and x_project_from_work eq 1>
                                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_add_work&field_id=form_basket.work_id&field_name=form_basket.work_head&project_id='+document.getElementById('project_id_out').value+'&project_head='+encodeURIComponent(document.getElementById('project_head_out').value)+'&field_pro_id=form_basket.project_id_out&field_pro_name=form_basket.project_head_out');" title="<cf_get_lang dictionary_id='51183.İş'>"></span>
                                            <cfelse>                
                                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_add_work&field_id=form_basket.work_id&field_name=form_basket.work_head');" title="<cf_get_lang dictionary_id='51183.İş'>"></span>
                                            </cfif>
                                        </div>
                                    </div>
                                </div>               
                                <div class="form-group" id="item-priority">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57485.Öncelik'></label>
                                    <div class="col col-8 col-xs-12"> 
                                        <select name="priority" id="priority" style="width:125px;">
                                            <cfloop query="get_priority">
                                                <option value="#get_priority.priority_id#"<cfif isdefined("attributes.priority") and attributes.priority eq get_priority.priority_id>selected</cfif>>#priority#</option>
                                            </cfloop>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-process">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                                    <div class="col col-8 col-xs-12"> 
                                        <cf_workcube_process is_upd='0' process_cat_width='125' is_detail='0'>
                                    </div>
                                </div>
                                <div class="form-group" id="item-ref_no">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58784.Referans'></label>
                                    <div class="col col-8 col-xs-12"> 
                                        <input type="text" name="ref_no" id="ref_no" maxlength="200" value="#attributes.ref_no#" style="width:125px;">
                                    </div>
                                </div>
                                <div class="form-group" id="item-target_date">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57645.Teslim Tarihi'></label>
                                    <div class="col col-8 col-xs-12"> 
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57645.Teslim Tarihi'></cfsavecontent>
                                            <!--- <cfif is_target_date eq 1> 
                                                    <cfinput type="text" name="target_date"  required="Yes" style="width:105px;"  value="#dateformat(attributes.target_date,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10" >						
                                                <cfelse>--->
                                                    <cfinput type="text" name="target_date" style="width:105px;"  value="#attributes.target_date#" validate="#validate_style#" message="#message#" maxlength="10" >
                                                <!---</cfif>--->
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="target_date"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>                     
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">                           
                                <div class="form-group" id="item-location_in_id">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33658.Giriş Depo'></label>
                                    <div class="col col-8 col-xs-12"> 
                                        <cfset search_dep_id=''>
                                        <cfset search_location_id=''>
                                        <cfif isdefined("attributes.department_in") and len(attributes.department_in)>
                                            <cfset search_dep_id = attributes.department_in>
                                            <cfset search_location_id = attributes.location_in>
                                        <cfelseif isdefined("attributes.deliver_dept_id") and len(attributes.deliver_dept_id)>
                                            <cfset search_dep_id = attributes.deliver_dept_id>
                                            <cfset search_location_id = attributes.deliver_loc_id>
                                        <cfelseif isdefined("attributes.department_in_id") and len(attributes.department_in_id)>
                                            <cfset search_dep_id = attributes.department_in_id>
                                            <cfinclude template="../query/get_dep_names_for_inter.cfm">
                                            <cfset txt_department_name=get_name_of_dep.department_head>
                                            <cfif len(search_dep_id) and isdefined("attributes.location_in_id") and len(attributes.location_in_id)>
                                                <cfset search_location_id = attributes.location_in_id>
                                                <cfinclude template="../query/get_location_for_inter.cfm">
                                                <cfset txt_department_name = txt_department_name & "-" & get_location.COMMENT>
                                                <cfset txt_department_id = "#get_location.department_location#" >
                                            <cfelse>
                                                <cfset txt_department_id="#search_dep_id#">
                                            </cfif>
                                        <cfelse>
                                            <cfset txt_department_name = "">
                                            <cfset txt_department_id = "">
                                        </cfif>
                                        <cf_wrkdepartmentlocation 
                                            returninputvalue="location_in_id,department_in_txt,department_in_id,branch_id"
                                            returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                            fieldname="department_in_txt"
                                            fieldid="location_in_id"
                                            department_fldid="department_in_id"
                                            user_level_control="#session.ep.our_company_info.is_location_follow#"
                                            department_id="#search_dep_id#"
                                            location_id="#search_location_id#"
                                            width="135"
                                            xml_all_depo = "#xml_all_depo_entry#"
                                            line_info = 2
                                            is_branch="1">
                                    </div>
                                </div>
                                <div class="form-group" id="item-project_head">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57554.Giriş'><cf_get_lang dictionary_id='57416.Proje'></label>
                                    <div class="col col-8 col-xs-12"> 
                                        <div class="input-group">
                                            <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.project_id")>#attributes.project_id#</cfif>">
                                            <input type="text" name="project_head" id="project_head" value="<cfif isdefined("attributes.project_head")>#attributes.project_head#</cfif>"  onfocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket','3','130')"autocomplete="off">
                                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');" title="<cf_get_lang dictionary_id='57416.Proje'>"></span>
                                            <span class="input-group-addon btnPointer" onclick="if(document.getElementById('project_id').value!='')windowopen('#request.self#?fuseaction=project.popup_list_project_actions&from_paper=INTERNALDEMAND&id='+document.getElementById('project_id').value+'','horizantal');else alert('<cf_get_lang dictionary_id='58797.Proje Seçiniz'>');" title="<cf_get_lang dictionary_id='57416.Proje'>">?</span>
                                        </div>
                                    </div>
                                </div>                       
                                <div class="form-group" id="item-project_head_out">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57431.Çıkış'><cf_get_lang dictionary_id='57416.Proje'></label>
                                    <div class="col col-8 col-xs-12"> 
                                        <div class="input-group">
                                            <input type="hidden" name="project_id_out" id="project_id_out" value="#attributes.project_id_out#">
                                            <input type="text" name="project_head_out" id="project_head_out" value="#attributes.project_head_out#"  onfocus="AutoComplete_Create('project_head_out','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id_out','form_basket','3','130')"autocomplete="off">
                                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id_out&project_head=form_basket.project_head_out');" title="<cf_get_lang dictionary_id='57416.Proje'>"></span>
                                            <span class="input-group-addon btnPointer" onclick="if(document.getElementById('project_id_out').value!='')windowopen('#request.self#?fuseaction=project.popup_list_project_actions&from_paper=INTERNALDEMAND&id='+document.getElementById('project_id_out').value+'','horizantal');else alert('Çıkış <cf_get_lang dictionary_id='58797.Proje Seçiniz'>');" title="<cf_get_lang dictionary_id='57416.Proje'>">?</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-search_dep_id">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29428.Çıkış Depo'></label>
                                    <div class="col col-8 col-xs-12"> 
                                        <cfif isdefined("attributes.department_out") and len(attributes.department_out)>
                                            <cfset search_dep_id=attributes.department_out>
                                            <cfset search_location_id=attributes.location_out>
                                        <cfelse>
                                            <cfset search_dep_id = listgetat(session.ep.user_location, 1, '-')>
                                            <cfset search_location_id="">   
                                        </cfif>
                                        <cfinclude template="../query/get_dep_names_for_inv.cfm">
                                        <cfset txt_department_name = get_name_of_dep.department_head>
                                        <cfif get_name_of_dep.recordcount>
                                            <cf_wrkdepartmentlocation 
                                                returninputvalue="location_id,txt_departman_,department_id,branch_id"
                                                returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                                fieldname="txt_departman_"
                                                department_id="#search_dep_id#"
                                                location_id="#search_location_id#"
                                                user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                                line_info = 1
                                                xml_all_depo = "#xml_all_depo_outer#"
                                                width="135">
                                        <cfelse>
                                            <cf_wrkdepartmentlocation 
                                                returninputvalue="location_id,txt_departman_,department_id,branch_id"
                                                returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                                fieldname="txt_departman_"
                                                user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                                line_info = 1
                                                xml_all_depo = "#xml_all_depo_outer#"
                                                width="135">
                                        </cfif>                                       
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                                <div class="form-group" id="item-service_no">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57656.Servis'></label>
                                    <div class="col col-8 col-xs-12"> 
                                        <div class="input-group">
                                            <input type="hidden" name="service_id" id="service_id"  value="<cfif isdefined("attributes.service_id") and len(attributes.service_id)>#attributes.service_id#</cfif>">
                                            <input type="text" name="service_no" id="service_no" value="<cfif isdefined("attributes.service_no") and len(attributes.service_no)>#attributes.service_no#</cfif>" style="width:135px;"  maxlength="50">
                                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_service&field_id=form_basket.service_id&field_no=form_basket.service_no');" title="<cf_get_lang dictionary_id='51183.İş'>"></span>
                                        </div>
                                    </div>
                                </div>                      
                                <cfif session.ep.our_company_info.workcube_sector is 'tersane'>
                                    <div class="form-group" id="item-dpl_no">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47681.DPL'></label>
                                        <div class="col col-8 col-xs-12"> 
                                            <div class="input-group">
                                                <input type="hidden" name="dpl_id" id="dpl_id" value="<cfif isdefined("attributes.dpl_id")>#attributes.dpl_id#</cfif>"> 
                                                <input type="text" name="dpl_no" id="dpl_no" value="<cfif isdefined("attributes.dpl_no")>#attributes.dpl_no#</cfif>" style="width:135px;">
                                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_drawing_parts&field_id=form_basket.dpl_id&field_name=form_basket.dpl_no','medium');"></span>
                                            </div>
                                        </div>
                                    </div>
                                </cfif>
                                <div class="form-group" id="item-notes">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                    <div class="col col-8 col-xs-12">
                                        <textarea name="notes" id="notes" rows="3"><cfif isdefined("attributes.id")>#attributes.notes#</cfif></textarea>
                                    </div>
                                </div>
                                <div class="form-group" id="item-cf_wrk_add_info">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57810.Ek Bilgi'></label>                                        
                                    <div class="col col-8 col-xs-12"> 
                                        <cfif is_demand eq 1>
                                        <cf_wrk_add_info info_type_id="-28" upd_page= "0"> 
                                        <cfelse>
                                            <cf_wrk_add_info info_type_id="-29" upd_page= "0"> 
                                        </cfif>
                                    </div>
                                </div>
                            </div>                     
                        </cf_box_elements>
                        <cf_box_footer>
                            <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                        </cf_box_footer>
                    </cf_basket_form>
                </cfoutput>
                <cfif isdefined('attributes.internal_row_info')><!--- proje malzeme planı satırlarından iç talep eklenecekse --->
                    <cfset attributes.basket_related_action = 1> 
                </cfif>
                <cfif session.ep.isBranchAuthorization>
                    <cfset attributes.basket_id = 39>
                <cfelseif listgetat(attributes.fuseaction,1,'.') is 'correspondence'>
                    <cfset attributes.basket_id = 8>
                <cfelse>
                    <cfset attributes.basket_id = 7>
                </cfif>
                <cfif not isdefined('attributes.type')><!--- Üretim Malzeme İhtiyaçları listesinden dönüşüm yapılmıyorsa --->
                    <cfif isdefined("attributes.file_format")>
                        <cfset attributes.basket_sub_id = 4>
                    <cfelse>
                        <cfset attributes.form_add = 1>
                    </cfif>
                </cfif>
                <cfset attributes.target_date = dateformat(attributes.target_date,dateformat_style)>
                <cfinclude template="../../objects/display/basket.cfm">
            </cfform>
        </div>
    </cf_box>
</div>
