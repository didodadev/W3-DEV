<!--- Lutfen Sayfaya Filtre vb Eklerken Dikkatli Olalim!!!!!!!! Varolan Yapiyi Bozmayalim FBS 20120501 --->
<cfif listfirst(fuseaction,'.') is 'correspondence'>
	<cfif listlast(fuseaction,'.') is 'list_purchasedemand'>
		<cf_xml_page_edit fuseact ="correspondence.list_purchasedemand">
	<cfelse>
		<cf_xml_page_edit fuseact ="correspondence.list_internaldemand">
	</cfif>
<cfelse>
	<cfif listlast(fuseaction,'.') is 'list_purchasedemand'>
		<cf_xml_page_edit fuseact ="purchase.list_purchasedemand">
	<cfelse>
		<cf_xml_page_edit fuseact ="purchase.list_internaldemand">
	</cfif>
</cfif>
<cf_get_lang_set module_name="correspondence">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.location_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.location_in_id" default="">
<cfparam name="attributes.department_in_id" default="">
<cfparam name="attributes.txt_departman" default="">
<cfparam name="attributes.department_in_txt" default="">
<cfparam name="attributes.internaldemand_stage" default="">
<cfparam name="attributes.internaldemand_status" default="">
<cfparam name="attributes.internaldemand_action" default="0">
<cfparam name="attributes.priority" default="">
<cfparam name="attributes.add_explain" default="">
<cfparam name="attributes.group_project" default="">
<cfparam name="attributes.deliverdate" default= "">
<cfif not isdefined("attributes.list_type")>
 <cfparam name="attributes.list_type" default="0">
</cfif>
<cfif listgetat(attributes.fuseaction,2,'.') contains 'list_purchasedemand'><cfset is_demand = 1><cfelse><cfset is_demand = 0></cfif>
	<cfif isdefined("x_order_by") and x_order_by eq 1>
		<cfparam name="attributes.order_by_date_" default="1">
	<cfelseif isdefined("x_order_by") and x_order_by eq 2>
		<cfparam name="attributes.order_by_date_" default="2">
	<cfelseif isdefined("x_order_by") and x_order_by eq 3>
		<cfparam name="attributes.order_by_date_" default="3">
	<cfelseif isdefined("x_order_by") and x_order_by eq 4>
		<cfparam name="attributes.order_by_date_" default="4">
	<cfelseif isdefined("x_order_by") and x_order_by eq 5>
		<cfparam name="attributes.order_by_date_" default="5">
	<cfelseif isdefined("x_order_by") and x_order_by eq 6>
		<cfparam name="attributes.order_by_date_" default="6">
	<cfelseif isdefined("x_order_by") and x_order_by eq 7>
		<cfparam name="attributes.order_by_date_" default="7">
	<cfelseif isdefined("x_order_by") and x_order_by eq 8>
		<cfparam name="attributes.order_by_date_" default="8">
	<cfelse>
		<cfparam name="attributes.order_by_date_" default="">
	</cfif> 
	<cfif x_list_is_from_employee_id eq 1>
		<cfif not  isdefined('attributes.is_submit') or (isDefined("attributes.from_employee_id") and len(attributes.from_employee_id))>
			<cfparam name="attributes.from_employee_id" default='#session.ep.userid#'><!--- Pozisyon Kod Yerine Userid Tutuluyor --->
			<cfparam name="attributes.from_employee_name" default='#session.ep.name# #session.ep.surname#'>
		<cfelse>
			<cfparam name="attributes.from_employee_id" default=''>
			<cfparam name="attributes.from_employee_name" default=''>
		</cfif>
	<cfelse>
		<cfparam name="attributes.from_employee_id" default=''>
		<cfparam name="attributes.from_employee_name" default=''>
	</cfif>
<cfif isdefined("xml_to_position_code") and xml_to_position_code eq 1>
	<cfparam name="attributes.to_position_code" default="#session.ep.position_code#">
	<cfparam name="attributes.to_position_name" default= "#session.ep.name# #session.ep.surname#">
<cfelse>
	<cfparam name="attributes.to_position_code" default="">
	<cfparam name="attributes.to_position_name" default= "">
</cfif>
<cfscript>
	get_dep = createObject("component","V16.myhome.cfc.get_travel_demands");
	get_dep.dsn = dsn;
	get_department = get_dep.get_department(position_code : session.ep.position_code);
</cfscript>
<cfif x_list_is_from_department eq 1>
    <cfif not isdefined('attributes.is_submit') or (isDefined("attributes.emp_department_id") and len(attributes.emp_department_id) and isDefined("attributes.emp_department") and len(attributes.emp_department))>
        <cfparam name="attributes.emp_department_id" default="#get_department.department_id#">
        <cfparam name="attributes.emp_department" default= "#get_department.department_head#">
    <cfelse>
        <cfparam name="attributes.emp_department_id" default="">
        <cfparam name="attributes.emp_department" default= "">
    </cfif>
<cfelse>
	<cfparam name="attributes.emp_department_id" default="">
	<cfparam name="attributes.emp_department" default= "">
</cfif>
<cfparam name="attributes.from_partner_id" default="">
<cfparam name="attributes.from_consumer_id" default="">
<cfparam name="attributes.from_company_id" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.prod_cat" default="">
<cfparam name="attributes.position_code" default="">
<cfparam name="attributes.position_name" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.work_id" default="">
<cfparam name="attributes.work_head" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.is_active" default="1">
<cfparam name="attributes.dpl_id" default="">
<cfparam name="attributes.dpl_no" default="">
<cfset url_str = "">
<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
<cfelse>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.startdate=''>
	<cfelse> 
		<cfset attributes.startdate = wrk_get_today()>
	</cfif>
</cfif>
<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
<cfelse>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.finishdate=''>
	<cfelse>
		<cfset attributes.finishdate = wrk_get_today()>
	</cfif>
</cfif>
<cfif isdefined("attributes.deliverdate") and isdate(attributes.deliverdate)>
	<cf_date tarih="attributes.deliverdate">
</cfif>
<cfif x_show_authorized_stage eq 1>
	<cf_workcube_process_info>
</cfif>
<cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
	SELECT
        PTR.PROCESS_ROW_ID,
        #dsn#.Get_Dynamic_Language(PTR.PROCESS_ROW_ID,'#session.ep.language#','PROCESS_TYPE_ROWS','STAGE',NULL,NULL,PTR.STAGE) AS STAGE
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
        <cfif is_demand eq 1>
        	PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_purchasedemand%">
		<cfelse>
        	<cfif attributes.list_type eq 2>
				PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="project.popup_add_project%">
			<cfelse>
				PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_internaldemand%">
            </cfif>
		</cfif>
		<cfif x_show_authorized_stage eq 1 and isDefined("Process_RowId_List") and ListLen(process_rowid_list)>
            AND PTR.PROCESS_ROW_ID IN (#process_rowid_list#)
        </cfif>
</cfquery>
<cfquery name="GET_ADD_EXP" datasource="#DSN3#">
    SELECT 
        BASKET_INFO_TYPE_ID,
        #dsn#.Get_Dynamic_Language(BASKET_INFO_TYPE_ID,'#session.ep.language#','SETUP_BASKET_INFO_TYPES','BASKET_INFO_TYPE',NULL,NULL,BASKET_INFO_TYPE) AS BASKET_INFO_TYPE
    FROM 
        SETUP_BASKET_INFO_TYPES
</cfquery>

<cfif x_is_show_unit eq 1 and attributes.list_type eq 1>
    <cfquery name="GET_PRODUCT_UNITS" datasource="#DSN3#">
        SELECT 
            IS_MAIN,
            ADD_UNIT,
            PRODUCT_ID,
            MULTIPLIER 
        FROM 
            PRODUCT_UNIT 
        WHERE 
            PRODUCT_UNIT_STATUS = 1
    </cfquery>
</cfif>          
 <cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>                           
<cfif isdefined('attributes.is_submit')>
	<cfif attributes.list_type eq 2>
		<cfinclude template="../../purchase/query/get_project_material_list.cfm">
	<cfelse>
		<cfinclude template="../query/get_list_internaldemand.cfm">
	</cfif>
<cfelse>
	<cfset get_list_internaldemand.recordcount=0>
    <cfset get_list_internaldemand.query_count=0>
</cfif>
<cfparam name="attributes.totalrecords" default='#get_list_internaldemand.query_count#'>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="list_request_form" id="list_request_form" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
            <input type="hidden" name="is_submit" id="is_submit" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfinput type="text" name="keyword" id="keyword" placeholder="#getLang('main','Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
                </div>
                <div class="form-group">
                    <select name="list_type" id="list_type" onchange="show_work_list();">
                        <option value="0" <cfif attributes.list_type eq 0> selected="selected" </cfif>><cf_get_lang dictionary_id='57660.Belge Bazında'></option>
                        <option value="1" <cfif attributes.list_type eq 1> selected="selected" </cfif>><cf_get_lang dictionary_id='29539.Satır Bazında'></option>
                        <cfif is_demand neq 1><option value="2" <cfif attributes.list_type eq 2> selected="selected" </cfif>><cf_get_lang dictionary_id='58443.Planlama Bazında'></option></cfif>
                    </select>
                </div>
                <div class="form-group">
                    <select name="order_by_date_" id="order_by_date_">
                        <option value="1" <cfif isdefined("attributes.order_by_date_") and attributes.order_by_date_ eq 1>selected</cfif>><cf_get_lang dictionary_id='57926.Azalan Tarih'></option>                     
                        <option value="2" <cfif isdefined("attributes.order_by_date_") and attributes.order_by_date_ eq 2>selected</cfif>><cf_get_lang dictionary_id='57925.Artan Tarih'></option>
                        <option value="3" <cfif isdefined("attributes.order_by_date_") and attributes.order_by_date_ eq 3>selected</cfif>><cf_get_lang dictionary_id='58742.Ürüne Göre Azalan'></option>
                        <option value="4" <cfif isdefined("attributes.order_by_date_") and attributes.order_by_date_ eq 4>selected</cfif>><cf_get_lang dictionary_id='58771.Ürüne Göre Artan'></option>
                        <option value="5" <cfif isdefined("attributes.order_by_date_") and attributes.order_by_date_ eq 5>selected</cfif>><cf_get_lang dictionary_id='57880.Belge No'> <cf_get_lang dictionary_id='29827.Azalan'></option>
                        <option value="6" <cfif isdefined("attributes.order_by_date_") and attributes.order_by_date_ eq 6>selected</cfif>><cf_get_lang dictionary_id='57880.Belge No'> <cf_get_lang dictionary_id='29826.Artan'></option>
                        <option value="7" <cfif isdefined("attributes.order_by_date_") and attributes.order_by_date_ eq 7>selected</cfif>><cf_get_lang dictionary_id='57627.Kayıt Tarihi'> <cf_get_lang dictionary_id='29827.Azalan'></option>
                        <option value="8" <cfif isdefined("attributes.order_by_date_") and attributes.order_by_date_ eq 8>selected</cfif>><cf_get_lang dictionary_id='57627.Kayıt Tarihi'> <cf_get_lang dictionary_id='29826.Artan'></option>
                        <cfif isdefined("x_order_list") and x_order_list eq 1>
                            <option value="11" <cfif isdefined("attributes.order_by_date_") and attributes.order_by_date_ eq 11>selected</cfif>><cf_get_lang dictionary_id='57554.Giris'><cf_get_lang dictionary_id='57416.Proje'> <cf_get_lang dictionary_id='29827.Azalan'></option>
                            <option value="12" <cfif isdefined("attributes.order_by_date_") and attributes.order_by_date_ eq 12>selected</cfif>><cf_get_lang dictionary_id='57554.Giris'><cf_get_lang dictionary_id='57416.Proje'> <cf_get_lang dictionary_id='29826.Artan'></option>
                            <option value="13" <cfif isdefined("attributes.order_by_date_") and attributes.order_by_date_ eq 13>selected</cfif>><cf_get_lang dictionary_id='29523.Çıkış Proje'> <cf_get_lang dictionary_id='29827.Azalan'></option>
                            <option value="14" <cfif isdefined("attributes.order_by_date_") and attributes.order_by_date_ eq 14>selected</cfif>><cf_get_lang dictionary_id='29523.Çıkış Proje'> <cf_get_lang dictionary_id='29826.Artan'></option>
                            <option value="9" <cfif isdefined("attributes.order_by_date_") and attributes.order_by_date_ eq 9> selected </cfif>><cf_get_lang dictionary_id='57567.Ürün Kategorileri'> <cf_get_lang dictionary_id='29827.Azalan'></option>
                            <option value="10" <cfif isdefined("attributes.order_by_date_") and attributes.order_by_date_ eq 10>selected</cfif>><cf_get_lang dictionary_id='57567.Ürün Kategorileri'> <cf_get_lang dictionary_id='29826.Artan'></option>
                        </cfif>
                    </select>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='57742.Tarih'>!</cfsavecontent>
                        <cfinput type="text" name="startdate" id="startdate" maxlength="10" placeholder="#getLang('main',641)#" value="#dateformat(attributes.startdate,dateformat_style)#" validate="#validate_style#" message="#message#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfinput type="text" name="finishdate" id="finishdate" maxlength="10" placeholder="#getLang('main','Bitiş Tarihi',57700)#" value="#dateformat(attributes.finishdate,dateformat_style)#" validate="#validate_style#" message="#message#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                    </div>
                </div>
                <cfif isdefined("x_deliverdate") and x_deliverdate eq 1 and is_demand eq 0>
                    <div class="form-group <cfif attributes.list_type neq 0> hide</cfif>">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='57742.Tarih'>!</cfsavecontent>
                            <cfinput type="text" name="deliverdate" id="deliverdate" maxlength="10" placeholder="#getLang('main','Teslim Tarihi',57645)#" value="#dateformat(attributes.deliverdate,dateformat_style)#" validate="#validate_style#" message="#message#">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="deliverdate"></span>
                        </div>
                    </div>
                </cfif>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button search_function="date_check(list_request_form.startdate,list_request_form.finishdate,'#getLang('','Tarih Değerini Kontrol Ediniz',57782)#')" button_type ="4">
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-internaldemand_action">
                        <label class="col col-12"><cf_get_lang dictionary_id='51100.Talep'> <cf_get_lang dictionary_id='51089.Tipi'></label>
                        <div class="col col-12">
                            <select name="internaldemand_action" id="internaldemand_action">
                                <option value="0" <cfif attributes.internaldemand_action eq 0>selected</cfif>><cf_get_lang dictionary_id='51100.Talep'> <cf_get_lang dictionary_id='51089.Tipi'></option>
                                <option value="1" <cfif attributes.internaldemand_action eq 1>selected</cfif>><cf_get_lang dictionary_id='51060.Siparişe Dönüşenler'></option>
                                <option value="2" <cfif attributes.internaldemand_action eq 2>selected</cfif>><cf_get_lang dictionary_id='51074.Teklife Dönüşenler'></option>
                                <option value="4" <cfif attributes.internaldemand_action eq 4>selected</cfif>><cf_get_lang dictionary_id='51061.Sarf Fişine Dönüşenler'></option>
                                <option value="3" <cfif attributes.internaldemand_action eq 3>selected</cfif>><cf_get_lang dictionary_id='51085.İşlenmeyenler'></option>
                            </select> 
                        </div>
                    </div>
                    <div class="form-group" id="item-internaldemand_stage">
                        <label class="col col-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                        <div class="col col-12">
                            <select name="internaldemand_stage" id="internaldemand_stage">
                                <option value=""><cf_get_lang dictionary_id='58859.Süreç'></option>
                                <cfoutput query="get_process_type">
                                    <option value="#process_row_id#"<cfif attributes.internaldemand_stage eq process_row_id>selected</cfif>>#stage#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <cfif session.ep.our_company_info.workcube_sector is 'tersane'>
                        <div class="form-group" id="item-dpl_no">
                            <label class="col col-12"><cf_get_lang dictionary_id='32595.DPL'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="dpl_id" id="dpl_id" value="<cfif len(attributes.dpl_id) and len(attributes.dpl_no)><cfoutput>#attributes.dpl_id#</cfoutput></cfif>"> 
                                    <input type="text" name="dpl_no" id="dpl_no" value="<cfif len(attributes.dpl_id) and len(attributes.dpl_no)><cfoutput>#attributes.dpl_no#</cfoutput></cfif>">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_drawing_parts&field_id=list_request_form.dpl_id&field_name=list_request_form.dpl_no'</cfoutput>);"></span>
                                </div>
                            </div>
                        </div>
                    </cfif>
                    <cfif x_show_project_in eq 1>
                        <div class="form-group" id="item-project_head">
                            <label class="col col-12"><cf_get_lang dictionary_id='57554.Giris'><cf_get_lang dictionary_id='57416.Proje'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
                                    <input type="text" name="project_head" id="project_head" value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=list_request_form.project_id&project_head=list_request_form.project_head');" title="<cf_get_lang dictionary_id='57416.Proje'>"></span>
                                </div>
                            </div>
                        </div>
                    </cfif>
                    <cfif x_show_project_out eq 1>
                        <div class="form-group" id="item-project_head_out">
                            <label class="col col-12"><cf_get_lang dictionary_id='29523.Çıkış Proje'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="project_id_out" id="project_id_out" value="<cfif isdefined('attributes.project_id_out') and len(attributes.project_id_out)><cfoutput>#attributes.project_id_out#</cfoutput></cfif>">
                                    <input type="text" name="project_head_out" id="project_head_out"  value="<cfif isdefined('attributes.project_head_out') and  len(attributes.project_head_out)><cfoutput>#attributes.project_head_out#</cfoutput></cfif>" onfocus="AutoComplete_Create('project_head_out','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id_out','','3','200');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=list_request_form.project_id_out&project_head=list_request_form.project_head_out');" title="<cf_get_lang dictionary_id='57416.Proje'>"></span>
                                </div>
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="item-form_ul_department">
                        <label class="col col-12"><cf_get_lang dictionary_id='57572.Department'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="emp_department_id" id="emp_department_id" value="<cfif isdefined('attributes.emp_department_id') and len(attributes.emp_department_id) and len(attributes.emp_department) ><cfoutput>#attributes.emp_department_id#</cfoutput></cfif>">
                                <input type="text" name="emp_department" id="emp_department" value="<cfif isdefined('attributes.emp_department') and len(attributes.emp_department)><cfoutput>#attributes.emp_department#</cfoutput></cfif>"  onfocus="AutoComplete_Create('emp_department','DEPARTMENT_HEAD','DEPARTMENT_HEAD','get_department1','','DEPARTMENT_ID','emp_department_id','list_request_form','3','200');" autocomplete="off">
                                <span  class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=list_request_form.emp_department_id&field_dep_branch_name=list_request_form.emp_department&is_store_module=1&is_function=1');"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-work_head">
                        <label class="col col-12"><cf_get_lang dictionary_id='58445.İş'></label>
                        <div class="col col-12"> 
                            <div class="input-group">
                                <input type="hidden" name="work_id" id="work_id" value="<cfif isdefined("attributes.work_id")><cfoutput>#attributes.work_id#</cfoutput></cfif>">
                                <input type="text" name="work_head" id="work_head" value="<cfif isdefined("attributes.work_id") and isdefined("attributes.work_head")><cfoutput>#attributes.work_head#</cfoutput></cfif>" onfocus="AutoComplete_Create('work_head','WORK_HEAD','WORK_HEAD','get_work','','WORK_ID','work_id','','3','110')">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&field_id=list_request_form.work_id&field_name=list_request_form.work_head')" title="<cf_get_lang dictionary_id='58445.İş'>"></span>
                            </div>
                        </div>
                    </div>
                    <cfif x_show_project_in eq 1>
                        <div class="form-group <cfif attributes.list_type eq 2>hide</cfif>" id="item-location_in_id">
                            <label class="col col-12"><cf_get_lang dictionary_id='51192.Giriş Depo'></label>
                            <div class="col col-12">
                                <cf_wrkdepartmentlocation 
                                    returninputvalue="location_in_id,department_in_txt,department_in_id"
                                    returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
                                    fieldname="department_in_txt"
                                    fieldid="location_in_id"
                                    department_fldid="department_in_id"
                                    department_id="#attributes.department_in_id#"
                                    location_name="#attributes.department_in_txt#"
                                    location_id="#attributes.location_in_id#"
                                    user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                    line_info = 2
                                    width="100">
                            </div>
                        </div>
                    </cfif>
                    <cfif x_show_project_out eq 1>
                        <div class="form-group <cfif (attributes.list_type eq 2) or (is_demand eq 1)></cfif>" id="item-location_id">
                            <label class="col col-12"><cf_get_lang dictionary_id='29428.Çıkış Depo'></label>
                            <div class="col col-12">
                                <cf_wrkdepartmentlocation 
                                    returninputvalue="location_id,txt_departman,department_id"
                                    returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
                                    fieldname="txt_departman"
                                    fieldid="location_id"
                                    department_fldid="department_id"
                                    department_id="#attributes.department_id#"
                                    location_name="#attributes.txt_departman#"
                                    location_id="#attributes.location_id#"
                                    user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                    line_info = 1
                                    width="100">
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group <cfif attributes.list_type eq 0>hide</cfif>" id="item-company">
                        <label class="col col-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
                        <div class="col col-12"> 
                            <div class="input-group">
                                <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isDefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                                <input type="text" name="company" id="company" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id)and isDefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','company_id','','3','250');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=list_request_form.company&field_comp_id=list_request_form.company_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2&keyword='+encodeURIComponent(document.list_request_form.company.value));" title="<cf_get_lang dictionary_id='29533.Tedarikçi'>"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group <cfif attributes.list_type eq 2>hide</cfif>" id="item-from_employee_name">
                        <label class="col col-12"><cf_get_lang dictionary_id='30829.Talep Eden'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="from_employee_id" id="from_employee_id" value="<cfif len(attributes.from_employee_id) and len(attributes.from_employee_name)><cfoutput>#attributes.from_employee_id#</cfoutput></cfif>"><!--- çalışanlar için --->
                                <input type="hidden" name="from_company_id" id="from_company_id" value="<cfif isdefined("attributes.from_company_id") and len(attributes.from_employee_name) and len(attributes.from_company_id)><cfoutput>#attributes.from_company_id#</cfoutput></cfif>"><!--- kurumsal üyeler için --->
                                <input type="hidden" name="from_partner_id" id="from_partner_id" value="<cfif isdefined("attributes.from_partner_id") and len(attributes.from_employee_name) and len(attributes.from_partner_id)><cfoutput>#attributes.from_partner_id#</cfoutput></cfif>"><!--- kurumsal üyeler için --->
                                <input type="hidden" name="from_consumer_id" id="from_consumer_id" value="<cfif isdefined("attributes.from_consumer_id") and len(attributes.from_employee_name) and len(attributes.from_consumer_id)><cfoutput>#attributes.from_consumer_id#</cfoutput></cfif>"><!--- bireysel üyeler için --->              
                                <input type="text" name="from_employee_name" id="from_employee_name" value="<cfoutput><cfif len(attributes.from_employee_id) and len(attributes.from_employee_name)>#get_emp_info(attributes.from_employee_id,0,0)#<cfelseif len(attributes.from_partner_id) and len(attributes.from_employee_name)>#get_par_info(attributes.from_partner_id,0,0,0)#<cfelseif len(attributes.from_consumer_id) and len(attributes.from_employee_name)>#get_cons_info(attributes.from_consumer_id,0,0)#</cfif></cfoutput>" onfocus="AutoComplete_Create('from_employee_name','MEMBER_PARTNER_NAME3','MEMBER_PARTNER_NAME3','get_member_autocomplete','','CONSUMER_ID,COMPANY_ID,EMPLOYEE_ID,PARTNER_ID','from_consumer_id,from_company_id,from_employee_id,from_partner_id','','3','250');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=list_request_form.from_employee_id&field_name=list_request_form.from_employee_name&field_partner=list_request_form.from_partner_id&field_consumer=list_request_form.from_consumer_id&field_comp_id=list_request_form.from_company_id&is_form_submitted=1&select_list=1,7,8');" title="<cf_get_lang dictionary_id='30829.Talep Eden'>"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group <cfif attributes.list_type neq 1>hide</cfif>" id="item-position_name">
                        <label class="col col-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="position_code" id="position_code" value="<cfif len(attributes.position_code) and len(attributes.position_name)><cfoutput>#attributes.position_code#</cfoutput></cfif>">
                                <input type="text" name="position_name" id="position_name" value="<cfif len(attributes.position_code) and len(attributes.position_name)><cfoutput>#attributes.position_name#</cfoutput></cfif>" maxlength="255" onfocus="AutoComplete_Create('position_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','position_code','','3','135');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=list_request_form.position_code&field_name=list_request_form.position_name&select_list=1&is_form_submitted=1');" title="<cf_get_lang dictionary_id='57544.Sorumlu'>"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group <cfif attributes.list_type eq 2>hide</cfif>" id="item-to_position_name">
                        <label class="col col-12"><cf_get_lang dictionary_id='57924.Kime'></label>
                        <div class="col col-12"> 
                            <div class="input-group">
                                <input type="hidden" name="to_position_code" id="to_position_code" value="<cfif len(attributes.to_position_code)><cfoutput>#attributes.to_position_code#</cfoutput></cfif>">
                                <input type="text" name="to_position_name" id="to_position_name" value="<cfif len(attributes.to_position_code) and len(attributes.to_position_name)><cfoutput>#attributes.to_position_name#</cfoutput></cfif>"  onfocus="AutoComplete_Create('to_position_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','to_position_code','','3','120');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=list_request_form.to_position_code&field_name=list_request_form.to_position_name&select_list=1');" title="<cf_get_lang dictionary_id='57924.Kime'>"></span>
                            </div>
                        </div>
                    </div>
                    <cfif isdefined("x_basket_row_add_definition") and x_basket_row_add_definition eq 1>
                        <div class="form-group <cfif attributes.list_type neq 1>hide</cfif>" id="item-add_explain">
                            <label class="col col-12"><cf_get_lang dictionary_id='37076.Ek Tanım'></label>
                            <div class="col col-12"> 
                                <select name="add_explain" id="add_explain">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_add_exp">
                                        <option value="#basket_info_type_id#" <cfif attributes.add_explain eq basket_info_type_id>selected</cfif>>#basket_info_type#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                    </cfif>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    <div class="form-group" id="item-priority">
                        <label class="col col-12"><cf_get_lang dictionary_id='57485.Öncelik'></label>
                        <div class="col col-12">
                            <select name="priority" id="priority">
                                <option value=""><cf_get_lang dictionary_id='57485.Öncelik'></option>
                                <cfinclude template="../query/get_priority.cfm">
                                <cfoutput query="get_priority">
                                    <option value="#get_priority.priority_id#"<cfif attributes.priority eq get_priority.priority_id>selected</cfif>>#priority# 
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-is_active">
                        <label class="col col-12"><cf_get_lang dictionary_id='57493.Aktif'>/<cf_get_lang dictionary_id='
                            57494.Pasif'></label>
                        <div class="col col-12">
                            <select name="is_active" id="is_active">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="1"<cfif attributes.is_active eq 1> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                                <option value="0"<cfif attributes.is_active eq 0> selected</cfif>><cf_get_lang dictionary_id='
                                    57494.Pasif'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group <cfif attributes.list_type neq 1>hide</cfif>" id="item-prod_cat">
                        <label class="col col-12"><cf_get_lang dictionary_id='57567.Ürün Kategorileri'></label>
                        <div class="col col-12"> 
                            <cfinclude template="../query/get_product_cat.cfm">
                            <select name="prod_cat" id="prod_cat">
                                <option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_product_cat">
                                    <cfif listlen(HIERARCHY,".") lte 3>
                                        <option value="#HIERARCHY#"<cfif (attributes.prod_cat eq HIERARCHY) and len(attributes.prod_cat) eq len(HIERARCHY)> selected</cfif>>
                                            <cfloop from="1" to="#listlen(HIERARCHY,'.')#" index="i">&nbsp;</cfloop>#HIERARCHY#-#product_cat#
                                        </option>
                                    </cfif>
                                </cfoutput>
                            </select>
                        </div>
                    </div>                  
                    <div class="form-group <cfif attributes.list_type eq 0>hide</cfif>" id="item-product_name">
                        <label class="col col-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                        <div class="col col-12"> 
                            <div class="input-group">
                                <input type="hidden" name="product_id" id="product_id" <cfif len(attributes.product_id) and len(attributes.product_name)>value="<cfoutput>#attributes.product_id#</cfoutput>"</cfif>>
                                <input type="text" name="product_name" id="product_name" value="<cfif len(attributes.product_id) and len(attributes.product_name)><cfoutput>#attributes.product_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','','2','200');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=list_request_form.product_id&field_name=list_request_form.product_name&keyword='+encodeURIComponent (document.list_request_form.product_name.value));" title="<cf_get_lang dictionary_id='57657.Ürün'>"></span>
                            </div>
                        </div>
                    </div>
                </div>                         
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cf_box title="#iif(is_demand neq 1,DE(getLang('correspondence',142)),DE(getLang('correspondence',258)))#" uidrop="1" hide_table_column="1">
        <cf_grid_list sort="0">
            <thead>
                <tr>
                    <cfif attributes.list_type eq 1>
                        <cfset colspan_ = 11>
                        <th width="30"><cf_get_lang dictionary_id="58577.Sıra"></th>
                        <!-- sil --><th>&nbsp;</th><!-- sil -->
                        <th><cf_get_lang dictionary_id='57880.Belge No'></th>
                        <cfif session.ep.our_company_info.workcube_sector is 'tersane'>
                            <cfset colspan_ = colspan_ + 1>
                            <th><cf_get_lang dictionary_id='32604.DPL No'></th>
                        </cfif>
                        <cfif x_is_work eq 1>
                            <cfset colspan_ = colspan_ + 1>
                            <th><cf_get_lang dictionary_id='58445.İş'></th>
                        </cfif>
                        <cfif isDefined("x_show_project_in") and x_show_project_in eq 1>
                            <cfset colspan_ = colspan_ + 1>
                            <th><cf_get_lang dictionary_id='57554.Giris'><cf_get_lang dictionary_id='57416.Proje'></th>
                        </cfif>
                        <cfif is_demand neq 1 and x_show_project_out eq 1>
                            <cfset colspan_ = colspan_ + 1>
                            <th><cf_get_lang dictionary_id='29523.Cikis Proje'></th>
                        </cfif>                   
                        <th><cf_get_lang dictionary_id='58820.Başlık'></th>
                            <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                        <cfif x_is_statu eq 1>
                            <cfset colspan_ = colspan_ + 1>
                            <th><cf_get_lang dictionary_id='57756.Durum'></th>
                        </cfif>
                        <cfif x_basket_row_add_definition eq 1>
                            <cfset colspan_ = colspan_ + 1>
                            <th><cf_get_lang dictionary_id='38499.Ek Açıklama'></th>
                        </cfif>
                        <cfif x_to_position eq 1>
                            <cfset colspan_ = colspan_ + 1>
                            <th><cf_get_lang dictionary_id='57924.Kime'></th>
                        </cfif>
                        <th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                        <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                        <cfif x_is_show_spec eq 1>
                            <cfset colspan_ = colspan_ + 1>
                            <th><cf_get_lang dictionary_id='57647.Spec'></th>
                        </cfif>
                        <th><cf_get_lang dictionary_id='29533.Tedarikçi'></th>
                        <th><cf_get_lang dictionary_id='57645.Teslim Tarihi'></th>
                        <cfif x_show_project_in eq 1>
                            <cfset colspan_ = colspan_ + 1>
                            <th><cf_get_lang dictionary_id='33658.Giriş Depo'></th>
                        </cfif>
                        <cfif is_demand neq 1 and x_show_project_out eq 1>
                            <cfset colspan_ = colspan_ + 1>
                            <th><cf_get_lang dictionary_id='29428.Cikis Depo'></th>
                        </cfif>
                        <cfif x_is_show_unit eq 1>
                            <cfset colspan_ = colspan_ + 1>
                            <th><cf_get_lang dictionary_id='32073.Birimler'></th>
                        </cfif>
                        <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                        <th><cf_get_lang dictionary_id='58444.Kalan'></th>
                        <!-- sil -->
                            <th width="20"><input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','internal_row_info');"></th>
                        <!-- sil -->
                    <cfelseif attributes.list_type eq 2>
                        <cfset colspan_ = 10>
                        <th width="20"><cf_get_lang dictionary_id="58577.Sıra"></th>
                        <!-- sil --><th width="20"></th><!-- sil -->
                        <cfif x_show_project_in eq 1>
                            <cfset colspan_ = colspan_ + 1>
                            <th><cf_get_lang dictionary_id='57554.Giris'><cf_get_lang dictionary_id='57416.Proje'></th>
                        </cfif>
                        <th><cf_get_lang dictionary_id='58445.İş'></th>
                        <th><cf_get_lang dictionary_id='57468.belge'></th>
                        <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                        <cfif x_is_statu eq 1>
                            <cfset colspan_ = colspan_ + 1>
                            <th><cf_get_lang dictionary_id='57756.Durum'></th>
                        </cfif>
                        <th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                        <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                        <th><cf_get_lang dictionary_id='29533.Tedarikçi'></th>
                        <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                        <th><cf_get_lang dictionary_id='58444.Kalan'></th>
                        <!-- sil -->
                        <th  width="20">
                            <input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','internal_row_info');">
                        </th>
                        <!-- sil -->
                    <cfelse>
                        <cfset colspan_ = 10>
                        <th width="20"><cf_get_lang dictionary_id="58577.Sıra"></th>
                        <th><cf_get_lang dictionary_id='57880.Belge No'></th>
                        <cfif session.ep.our_company_info.workcube_sector is 'tersane'>
                            <cfset colspan_ = colspan_ + 1>
                            <th><cf_get_lang dictionary_id='32604.DPL No'></th>
                        </cfif>
                        <cfif x_is_work eq 1>
                            <cfset colspan_ = colspan_ + 1>
                            <th><cf_get_lang dictionary_id='58445.İş'></th>
                        </cfif>
                        <cfif x_show_project_in eq 1>
                            <cfset colspan_ = colspan_ + 1>
                            <th><cf_get_lang dictionary_id='57554.Giris'><cf_get_lang dictionary_id='57416.Proje'></th>
                        </cfif>
                        <cfif is_demand neq 1 and  x_show_project_out eq 1>
                            <cfset colspan_ = colspan_ + 1>
                            <th><cf_get_lang dictionary_id='29523.Cikis Proje'></th>
                        </cfif>                       
                        <th><cf_get_lang dictionary_id='58820.Başlık'></th>
                        <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                        <th><cf_get_lang dictionary_id='57485.Öncelik'></th>
                        <th><cf_get_lang dictionary_id='30829.Talep Eden'></th>
                        <th><cf_get_lang dictionary_id='57924.Kime'></th>
                            <th><cf_get_lang dictionary_id='57572.Departman'></th>
                        <cfif x_show_project_in eq 1>
                            <cfset colspan_ = colspan_ + 1>
                            <th><cf_get_lang dictionary_id='33658.Giriş Depo'></th>
                        </cfif>
                        <cfif is_demand neq 1 and x_show_project_out eq 1>
                            <cfset colspan_ = colspan_ + 1>
                            <th><cf_get_lang dictionary_id='29428.Cikis Depo'></th>
                        </cfif>    
                        <th><cf_get_lang dictionary_id='58859.Süreç'></th>
                        <th><cf_get_lang dictionary_id='57482.Aşama'></th>
                        <cfif x_is_statu eq 1>
                            <cfset colspan_ = colspan_ + 1>		
                            <th><cf_get_lang dictionary_id='57756.Durum'></th>
                        </cfif>
                    </cfif>
                    <!-- sil -->
                    <cfif attributes.list_type neq 2>
                        <cfset colspan_ = colspan_ + 1>
                        <th width="20">
                            <a href="javascript://"><i class="fa fa-cubes" alt=""title="<cf_get_lang dictionary_id='29676.İç Talep Karşılaştırma Raporu'>"></i></a>
                        </th>
                        <th width="20">
                            <cfif is_demand eq 1>
                                <cfoutput><a href="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.list_purchasedemand&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></cfoutput>
                            <cfelse>
                                <cfoutput><a href="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.list_internaldemand&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'> alt="<cf_get_lang dictionary_id='57582.Ekle'>""></i></a></cfoutput>
                            </cfif>
                        </th>
                    </cfif>
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfform name="list_internaldemand_2" action="">
                    <cfif get_list_internaldemand.recordcount>
                        <cfscript>
                            internald_position_code_list = "";
                            internald_employee_id_list="";
                            department_list = "";
                            location_list = "";
                            company_id_list = "";
                            internaldemand_id_list="";
                            work_id_list="";
                            project_id_list ="";
                            stage_list = "";
                            basket_extra_info_id_list = "";
                            main_department_list_id="";
                            main_department_list="";
                        </cfscript>
                        <cfoutput query="get_list_internaldemand">
                            <cfif not listfind(internaldemand_id_list,action_id)>
                                <cfset internaldemand_id_list=listappend(internaldemand_id_list,action_id)>
                            </cfif>
                            <cfif attributes.list_type eq 0>
                                <cfif len(row_dept) and not listfind(department_list,row_dept)>
                                    <cfset department_list=listappend(department_list,row_dept)>
                                </cfif>
                                <cfif len("#row_dept#-#row_loc#") and not listfind(location_list,"#row_dept#-#row_loc#")>
                                    <cfset location_list=listappend(location_list,"#row_dept#-#row_loc#")>
                                </cfif>
                                <cfif len(from_position_code) and not listfind(internald_employee_id_list,from_position_code)>
                                    <cfset internald_employee_id_list = listappend(internald_employee_id_list,from_position_code)>
                                </cfif>
                                <cfif len(to_position_code) and not listfind(internald_position_code_list,to_position_code)>
                                    <cfset internald_position_code_list=listappend(internald_position_code_list,to_position_code)>
                                </cfif>
                                <cfif len(internaldemand_stage) and not listfind(stage_list,internaldemand_stage)>
                                    <cfset stage_list=listappend(stage_list,internaldemand_stage)>
                                </cfif>
                                <cfif len(project_id) and not listfind(project_id_list,project_id)>
                                    <cfset project_id_list=listappend(project_id_list,project_id)>
                                </cfif>
                                <cfif len(department_id) and not listfind(main_department_list_id,department_id)>
                                    <cfset main_department_list_id=listappend(main_department_list_id,department_id)>
                                </cfif>
                            <cfelseif attributes.list_type eq 1>
                                <cfif len(row_dept) and not listfind(department_list,row_dept)>
                                    <cfset department_list=listappend(department_list,row_dept)>
                                </cfif>
                                <cfif len("#row_dept#-#row_loc#") and not listfind(location_list,"#row_dept#-#row_loc#")>
                                    <cfset location_list=listappend(location_list,"#row_dept#-#row_loc#")>
                                </cfif>
                                <cfif len(company_id) and not listfind(company_id_list,company_id)>
                                    <cfset company_id_list=listappend(company_id_list,company_id)>
                                </cfif>
                                <cfif len(project_id) and not listfind(project_id_list,project_id)>
                                    <cfset project_id_list=listappend(project_id_list,project_id)>
                                </cfif>
                                <cfif len(basket_extra_info_id) and not listfind(basket_extra_info_id_list,basket_extra_info_id)>
                                    <cfset basket_extra_info_id_list=listappend(basket_extra_info_id_list,basket_extra_info_id)>
                                </cfif>
                            <cfelseif attributes.list_type eq 2>
                                <cfif len(company_id) and not listfind(company_id_list,company_id)>
                                    <cfset company_id_list=listappend(company_id_list,company_id)>
                                </cfif>
                                <cfif len(work_id) and not listfind(work_id_list,work_id)>
                                    <cfset work_id_list=listappend(work_id_list,work_id)>
                                </cfif>
                                <cfif len(project_id) and not listfind(project_id_list,project_id)>
                                    <cfset project_id_list=listappend(project_id_list,project_id)>
                                </cfif>
                            </cfif>
                        </cfoutput>
                        <cfif len(work_id_list)>
                            <cfset work_id_list=listsort(work_id_list,"numeric","ASC",",")>
                                <cfquery name="GET_WORK_INFO" datasource="#DSN#">
                                    SELECT WORK_ID, WORK_HEAD FROM PRO_WORKS WHERE WORK_ID IN (#work_id_list#) ORDER BY WORK_ID
                                </cfquery>
                            <cfset work_id_list = listsort(listdeleteduplicates(valuelist(get_work_info.work_id,',')),'numeric','ASC',',')>
                        </cfif>
                        <cfif len(project_id_list)>
                            <cfset project_id_list=listsort(project_id_list,"numeric","ASC",",")>
                            <cfquery name="GET_PROJECT_INFO" datasource="#DSN#">
                                SELECT PROJECT_ID, PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id_list#) ORDER BY PROJECT_ID
                            </cfquery>
                            <cfset project_id_list = listsort(listdeleteduplicates(valuelist(get_project_info.project_id,',')),'numeric','ASC',',')>
                        </cfif>
                        <cfif len(internald_position_code_list)>
                            <cfset internald_position_code_list=listsort(internald_position_code_list,"numeric","ASC",",")>
                            <cfquery name="GET_FROM_DETAIL" datasource="#DSN#">
                                SELECT (EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME) AS EMPLOYEE_NAME,POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE IN (#internald_position_code_list#) ORDER BY POSITION_CODE
                            </cfquery>
                            <cfset internald_position_code_list = listsort(listdeleteduplicates(valuelist(get_from_detail.position_code,',')),'numeric','ASC',',')>
                        </cfif>
                        <cfif len(internald_employee_id_list)>
                            <cfset internald_employee_id_list=listsort(internald_employee_id_list,"numeric","ASC",",")>
                            <cfquery name="GET_EMP_DETAIL" datasource="#DSN#">
                                SELECT (EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME) AS EMPLOYEE_NAME, EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#internald_employee_id_list#) ORDER BY EMPLOYEE_ID
                            </cfquery>
                            <cfset internald_employee_id_list = listsort(listdeleteduplicates(valuelist(get_emp_detail.employee_id,',')),'numeric','ASC',',')>
                        </cfif>
                        <cfif len(company_id_list)>
                            <cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
                            <cfquery name="GET_COMPANY_DETAIL" datasource="#DSN#">
                                SELECT FULLNAME,COMPANY_ID FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
                            </cfquery>
                            <cfset company_id_list = listsort(listdeleteduplicates(valuelist(get_company_detail.company_id,',')),'numeric','ASC',',')>
                        </cfif>
                        <cfif len(department_list)>
                            <cfset department_list=listsort(department_list,"numeric","ASC",",")>
                            <cfquery name="get_dep_detail" datasource="#DSN#">
                                SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID IN (#department_list#) ORDER BY DEPARTMENT_ID
                            </cfquery>
                            <cfset department_list = listsort(listdeleteduplicates(valuelist(get_dep_detail.department_id,',')),'numeric','ASC',',')>
                        </cfif>
                        <cfif len(main_department_list_id)>
                            <cfset main_department_list_id=listsort(main_department_list_id,"numeric","ASC",",")>
                            <cfquery name="get_dep_detail" datasource="#DSN#">
                                SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID IN (#main_department_list_id#) ORDER BY DEPARTMENT_ID
                            </cfquery>
                            <cfset main_department_list = valuelist(get_dep_detail.department_head,',')>
                        </cfif>
                        <cfif ListLen(location_list,',')>
                            <cfset location_list=listsort(location_list,'text','asc',',')>
                                <cfquery name="GET_LOCATION" datasource="#DSN#">
                                    SELECT
                                        SL.COMMENT,
                                        CAST(D.DEPARTMENT_ID AS NVARCHAR(10)) + CAST('-' AS NVARCHAR(1)) + CAST(SL.LOCATION_ID AS NVARCHAR(10)) DEPARTMENT_LOCATIONS_
                                    FROM
                                        DEPARTMENT D,
                                        STOCKS_LOCATION SL
                                    WHERE
                                        D.DEPARTMENT_ID = SL.DEPARTMENT_ID AND
                                        D.IS_STORE <> 2 AND
                                        CAST(D.DEPARTMENT_ID AS NVARCHAR(10)) + CAST('-' AS NVARCHAR(1)) + CAST(SL.LOCATION_ID AS NVARCHAR(10)) IN (#ListQualify(location_list,"'",",")#)
                                    ORDER BY
                                        CAST(D.DEPARTMENT_ID AS NVARCHAR(10)) + CAST('-' AS NVARCHAR(1)) + CAST(SL.LOCATION_ID AS NVARCHAR(10))
                                </cfquery>
                            <cfset location_list = ListSort(ListDeleteDuplicates(ValueList(get_location.department_locations_,',')),"text","asc",",")>
                        </cfif>
                        <cfif len(stage_list)>
                            <cfset stage_list=listsort(stage_list,"numeric","ASC",",")>
                                <cfquery name="GET_PRO_NAME" datasource="#DSN#">
                                    SELECT PROCESS_ROW_ID, STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#stage_list#) ORDER BY PROCESS_ROW_ID
                                </cfquery>
                            <cfset stage_list = listsort(listdeleteduplicates(valuelist(get_pro_name.process_row_id,',')),'numeric','ASC',',')>
                        </cfif>
                        <cfif len(basket_extra_info_id_list)>
                            <cfset basket_extra_info_id_list=listsort(basket_extra_info_id_list,"numeric","ASC",",")>
                            <cfquery name="GET_BASKET_INFO" datasource="#DSN3#">
                                SELECT BASKET_INFO_TYPE,BASKET_INFO_TYPE_ID FROM SETUP_BASKET_INFO_TYPES WHERE BASKET_INFO_TYPE_ID IN (#basket_extra_info_id_list#) ORDER BY BASKET_INFO_TYPE_ID
                            </cfquery>
                            <cfset basket_extra_info_id_list = listsort(listdeleteduplicates(valuelist(get_basket_info.basket_info_type_id,',')),'numeric','ASC',',')>
                        </cfif>
                        <cfif attributes.list_type eq 1>
                            <cfquery name="GET_USED_ORDER_STOCK" datasource="#DSN3#">
                                SELECT
                                    SUM(TOTAL_AMOUNT) TOTAL_AMOUNT,
                                    STOCK_ID,
                                    PRODUCT_ID,
                                    SPECT_MAIN_ID,
                                    INTERNALDEMAND_ID,
                                    INTERNALDEMAND_ROW_ID
                                FROM
                                (
                                    <!--- talep eger ambar fisine cekilmisse --->
                                    <cfif isDefined('x_kalan_hesap') and listFind('1,4',x_kalan_hesap)>
                                    SELECT 
                                        PO.AMOUNT AS TOTAL_AMOUNT,
                                        PO.STOCK_ID,I_ROW.PRODUCT_ID,
                                        ISNULL((SELECT SP.SPECT_MAIN_ID FROM SPECTS SP WHERE SP.SPECT_VAR_ID = I_ROW.SPECT_VAR_ID),0) AS SPECT_MAIN_ID,
                                        I_ROW.I_ID INTERNALDEMAND_ID,
                                        I_ROW.I_ROW_ID INTERNALDEMAND_ROW_ID
                                    FROM 
                                        INTERNALDEMAND_ROW I_ROW,
                                        #dsn2_alias#.STOCK_FIS_ROW PO
                                    WHERE 
                                        I_ID IN (#internaldemand_id_list#) AND
                                        PO.WRK_ROW_RELATION_ID = I_ROW.WRK_ROW_ID
                                    </cfif>                        
                                    <!--- talep eger üretime --->
                                    <cfif isDefined('x_kalan_hesap') and listFind('1,7',x_kalan_hesap)>
                                    <cfif isDefined('x_kalan_hesap') and listFind('1,4',x_kalan_hesap)>
                                    UNION ALL
                                    </cfif>
                                    SELECT 
                                        PO.QUANTITY AS TOTAL_AMOUNT,
                                        PO.STOCK_ID,I_ROW.PRODUCT_ID,
                                        PO.SPEC_MAIN_ID AS SPECT_MAIN_ID,
                                        I_ROW.I_ID INTERNALDEMAND_ID,
                                        I_ROW.I_ROW_ID INTERNALDEMAND_ROW_ID
                                    FROM 
                                        INTERNALDEMAND_ROW I_ROW,
                                        PRODUCTION_ORDERS PO
                                    WHERE 
                                        I_ID IN (#internaldemand_id_list#) AND
                                        PO.WRK_ROW_RELATION_ID = I_ROW.WRK_ROW_ID
                                    </cfif>                    
                                    <!--- talep eger irsaliyeye cekilmisse --->
                                    <cfif isDefined('x_kalan_hesap') and listFind('1,3',x_kalan_hesap)>
                                    <cfif isDefined('x_kalan_hesap') and listFind('1,7',x_kalan_hesap)>
                                    UNION ALL
                                    </cfif>
                                    SELECT 
                                        AMOUNT AS TOTAL_AMOUNT,
                                        STOCK_ID,PRODUCT_ID,
                                        ISNULL((SELECT SP.SPECT_MAIN_ID FROM SPECTS SP WHERE SP.SPECT_VAR_ID = INTERNALDEMAND_RELATION_ROW.SPECT_VAR_ID),0) AS SPECT_MAIN_ID,
                                        INTERNALDEMAND_ID,
                                        INTERNALDEMAND_ROW_ID
                                    FROM 
                                        INTERNALDEMAND_RELATION_ROW 
                                    WHERE 
                                        INTERNALDEMAND_ID IN (#internaldemand_id_list#) AND
                                        (TO_SHIP_ID IS NOT NULL) AND
                                        INTERNALDEMAND_ROW_ID IS NOT NULL
                                    </cfif>                      
                                    <!--- talep eger siparise cekilmisse --->
                                    <cfif isDefined('x_kalan_hesap') and listFind('1,6',x_kalan_hesap)>
                                    <cfif isDefined('x_kalan_hesap') and listFind('1,3',x_kalan_hesap)>
                                    UNION ALL
                                    </cfif>
                                    SELECT 
                                        AMOUNT AS TOTAL_AMOUNT,
                                        STOCK_ID,PRODUCT_ID,
                                        ISNULL((SELECT SP.SPECT_MAIN_ID FROM SPECTS SP WHERE SP.SPECT_VAR_ID = INTERNALDEMAND_RELATION_ROW.SPECT_VAR_ID),0) AS SPECT_MAIN_ID,
                                        INTERNALDEMAND_ID,
                                        INTERNALDEMAND_ROW_ID
                                    FROM 
                                        INTERNALDEMAND_RELATION_ROW 
                                    WHERE 
                                        INTERNALDEMAND_ID IN (#internaldemand_id_list#) AND
                                        (TO_ORDER_ID IS NOT NULL) AND
                                        INTERNALDEMAND_ROW_ID IS NOT NULL
                                        </cfif>
                                    <!--- talep eger iliskili teklife çekilip sipariş eklenmemişse --->
                                    <cfif isDefined('x_kalan_hesap') and listFind('1,5',x_kalan_hesap)>
                                    <cfif isDefined('x_kalan_hesap') and listFind('1,6',x_kalan_hesap)>
                                    UNION ALL
                                    </cfif>
                                    SELECT
                                        OFR.QUANTITY AS TOTAL_AMOUNT,
                                        OFR.STOCK_ID,OFR.PRODUCT_ID,
                                        ISNULL((SELECT SP.SPECT_MAIN_ID FROM SPECTS SP WHERE SP.SPECT_VAR_ID = IRR.SPECT_VAR_ID),0) AS SPECT_MAIN_ID,
                                        IRR.INTERNALDEMAND_ID,
                                        IRR.INTERNALDEMAND_ROW_ID
                                    FROM
                                        INTERNALDEMAND_ROW IR,
                                        INTERNALDEMAND_RELATION_ROW IRR,
                                        OFFER_ROW OFR
                                    WHERE
                                        IRR.TO_OFFER_ID IS NOT NULL AND
                                        IRR.TO_OFFER_ID = OFR.OFFER_ID AND
                                        IRR.STOCK_ID = OFR.STOCK_ID AND
                                        IR.STOCK_ID = OFR.STOCK_ID AND
                                        IRR.INTERNALDEMAND_ROW_ID = IR.I_ROW_ID AND
                                        IR.WRK_ROW_ID = OFR.WRK_ROW_RELATION_ID AND
                                        IRR.INTERNALDEMAND_ID IN (#internaldemand_id_list#) AND
                                        OFR.WRK_ROW_ID NOT IN(SELECT ORR.WRK_ROW_RELATION_ID FROM ORDER_ROW ORR WHERE ORR.WRK_ROW_RELATION_ID IS NOT NULL)                                
                                    UNION ALL
                                    <!--- talep eger iliskili tekliften siparise cekilmisse --->
                                    SELECT
                                        OFR.QUANTITY AS TOTAL_AMOUNT,
                                        ORR.STOCK_ID,ORR.PRODUCT_ID,
                                        ISNULL((SELECT SP.SPECT_MAIN_ID FROM SPECTS SP WHERE SP.SPECT_VAR_ID = IRR.SPECT_VAR_ID),0) AS SPECT_MAIN_ID,
                                        IRR.INTERNALDEMAND_ID,
                                        IRR.INTERNALDEMAND_ROW_ID
                                    FROM
                                        INTERNALDEMAND_RELATION_ROW IRR,
                                        OFFER_ROW OFR,
                                        ORDER_ROW ORR
                                    WHERE
                                        IRR.TO_OFFER_ID IS NOT NULL AND
                                        IRR.TO_OFFER_ID = OFR.OFFER_ID AND
                                        IRR.INTERNALDEMAND_ID IN (#internaldemand_id_list#) AND
                                        IRR.STOCK_ID = ORR.STOCK_ID AND
                                        OFR.WRK_ROW_ID = ORR.WRK_ROW_RELATION_ID
                                        </cfif>                            
                                    <!--- talep eger iliskili satınalma talebi cekilmisse --->
                                    <cfif isDefined('x_kalan_hesap') and listFind('1,2',x_kalan_hesap)>
                                    <cfif isDefined('x_kalan_hesap') and listFind('1,5',x_kalan_hesap)>
                                    UNION ALL
                                    </cfif>
                                    SELECT
                                        OFR.QUANTITY AS TOTAL_AMOUNT,
                                        OFR.STOCK_ID,OFR.PRODUCT_ID,
                                        ISNULL((SELECT SP.SPECT_MAIN_ID FROM SPECTS SP WHERE SP.SPECT_VAR_ID = IRR.SPECT_VAR_ID),0) AS SPECT_MAIN_ID,
                                        IRR.INTERNALDEMAND_ID,
                                        IRR.INTERNALDEMAND_ROW_ID
                                    FROM
                                        INTERNALDEMAND_ROW IR,
                                        INTERNALDEMAND_RELATION_ROW IRR,
                                        INTERNALDEMAND_ROW OFR
                                    WHERE
                                        IRR.TO_INTERNALDEMAND_ID IS NOT NULL AND
                                        IRR.TO_INTERNALDEMAND_ID = OFR.I_ID AND
                                        IRR.STOCK_ID = OFR.STOCK_ID AND
                                        IR.STOCK_ID = OFR.STOCK_ID AND
                                        IRR.INTERNALDEMAND_ROW_ID = IR.I_ROW_ID AND
                                        IR.WRK_ROW_ID = OFR.WRK_ROW_RELATION_ID AND
                                        IRR.INTERNALDEMAND_ID IN (#internaldemand_id_list#) AND
                                        OFR.WRK_ROW_ID NOT IN(SELECT ORR.WRK_ROW_RELATION_ID FROM ORDER_ROW ORR WHERE ORR.WRK_ROW_RELATION_ID IS NOT NULL)
                                        </cfif>
                                )T1
                                GROUP BY
                                    INTERNALDEMAND_ID,INTERNALDEMAND_ROW_ID,PRODUCT_ID,STOCK_ID,SPECT_MAIN_ID
                            </cfquery>
                            <cfscript>
                                for(kk=1; kk lte get_used_order_stock.recordcount; kk=kk+1) /*satıra satır ilişkisi tutulan siparişe cekilen iç talep miktarları*/
                                    'used_order_amount_#get_used_order_stock.internaldemand_id[kk]#_#get_used_order_stock.internaldemand_row_id[kk]#_#get_used_order_stock.stock_id[kk]#' = get_used_order_stock.total_amount[kk];
                            </cfscript>
                        <cfelseif attributes.list_type eq 2>
                            <cfquery name="GET_USED_ORDER_STOCK" datasource="#DSN3#">
                                SELECT
                                    SUM(TOTAL_AMOUNT) TOTAL_AMOUNT,
                                    STOCK_ID,
                                    PRODUCT_ID,
                                    SPECT_MAIN_ID,
                                    INTERNALDEMAND_ID,
                                    INTERNALDEMAND_ROW_ID
                                FROM
                                (
                                    SELECT 
                                        IR.QUANTITY AS TOTAL_AMOUNT,
                                        IR.STOCK_ID,
                                        IR.PRODUCT_ID,
                                        ISNULL((SELECT SP.SPECT_MAIN_ID FROM SPECTS SP WHERE SP.SPECT_VAR_ID = IR.SPECT_VAR_ID),0) AS SPECT_MAIN_ID,
                                        PMR.PRO_MATERIAL_ID INTERNALDEMAND_ID,
                                        PMR.PRO_MATERIAL_ROW_ID INTERNALDEMAND_ROW_ID
                                    FROM 
                                        #dsn_alias#.PRO_MATERIAL_ROW  PMR,
                                        INTERNALDEMAND_ROW IR
                                    WHERE
                                        PMR.WRK_ROW_ID = IR.WRK_ROW_RELATION_ID AND
                                        PMR.PRO_MATERIAL_ID = IR.PRO_MATERIAL_ID AND
                                        PMR.PRO_MATERIAL_ID IN (#internaldemand_id_list#)
                                ) T1
                                GROUP BY
                                    INTERNALDEMAND_ID,INTERNALDEMAND_ROW_ID,PRODUCT_ID,STOCK_ID,SPECT_MAIN_ID
                            </cfquery>
                            <cfscript>
                                for(kk=1; kk lte get_used_order_stock.recordcount; kk=kk+1) /*satıra satır ilişkisi tutulan siparişe cekilen iç talep miktarları*/
                                    'used_order_amount_#get_used_order_stock.internaldemand_id[kk]#_#get_used_order_stock.internaldemand_row_id[kk]#_#get_used_order_stock.stock_id[kk]#' = get_used_order_stock.total_amount[kk];
                            </cfscript>
                        </cfif>
                        <!--- Union kullanma sebebi tekliften siparişe dönüşen iç talepleride aşamasının da siparişe dönüştür olarak görülebilmesi için.--->
                        <cfquery name="getInternalRel" datasource="#dsn3#">
                            SELECT 
                                INTERNALDEMAND_ID,
                                TO_OFFER_ID,
                                TO_ORDER_ID,
                                TO_SHIP_ID,
                                TO_STOCK_FIS_ID,
                                NULL TO_INTERNALDEMAND_ID
                            FROM 
                                INTERNALDEMAND_RELATION 
                            WHERE 
                                INTERNALDEMAND_ID IN (#internaldemand_id_list#) 
                        UNION
                            SELECT 
                                INTERNALDEMAND_ID,
                                NULL TO_OFFER_ID,
                                RR.TO_ACTION_ID TO_ORDER_ID,
                                NULL TO_SHIP_ID,
                                NULL TO_STOCK_FIS_ID,
                                TO_INTERNALDEMAND_ID
                            FROM 
                                INTERNALDEMAND_RELATION_ROW 
                                LEFT JOIN RELATION_ROW RR ON RR.FROM_TABLE = 'OFFER' AND RR.TO_TABLE = 'ORDERS' AND RR.FROM_ACTION_ID = TO_OFFER_ID
                            WHERE 
                                INTERNALDEMAND_ID IN (#internaldemand_id_list#) 
                        UNION
                            SELECT DISTINCT
                                INTERNALDEMAND_ID,
                                NULL TO_OFFER_ID,
                                RR2.TO_ACTION_ID TO_ORDER_ID,
                                NULL TO_SHIP_ID,
                                NULL TO_STOCK_FIS_ID,
                                TO_INTERNALDEMAND_ID
                            FROM 
                                INTERNALDEMAND_RELATION_ROW 
                                JOIN RELATION_ROW RR ON RR.FROM_TABLE = 'OFFER' AND RR.TO_TABLE = 'OFFER' AND RR.FROM_ACTION_ID = TO_OFFER_ID
                                JOIN RELATION_ROW RR2 ON RR2.FROM_TABLE = 'OFFER' AND RR2.TO_TABLE = 'ORDERS' AND RR2.FROM_ACTION_ID = RR.TO_ACTION_ID
                            WHERE 	INTERNALDEMAND_ID IN (#internaldemand_id_list#) 
                            ORDER BY 
                                INTERNALDEMAND_ID
                        </cfquery>
                        <cfset to_offer_id_list = ''>
                        <cfset to_order_id_list = ''>
                        <cfset to_ship_id_list = ''>
                        <cfset to_stock_fis_id_list = ''>
                        <cfset to_internaldemand_id_list = ''>
                        <cfoutput query="getInternalRel">
                            <cfif len(TO_OFFER_ID)>
                                <cfset to_offer_id_list = '#to_offer_id_list#;#INTERNALDEMAND_ID#'>
                            </cfif>
                            <cfif len(TO_ORDER_ID)>
                                <cfset to_order_id_list = '#to_order_id_list#;#INTERNALDEMAND_ID#'>
                            </cfif>
                            <cfif len(TO_SHIP_ID)>
                                <cfset to_ship_id_list = '#to_ship_id_list#;#INTERNALDEMAND_ID#'>
                            </cfif>
                            <cfif len(TO_STOCK_FIS_ID)>
                                <cfset to_stock_fis_id_list = '#to_stock_fis_id_list#;#INTERNALDEMAND_ID#'>
                            </cfif>
                            <cfif len(TO_INTERNALDEMAND_ID)>
                                <cfset to_internaldemand_id_list = '#to_internaldemand_id_list#;#INTERNALDEMAND_ID#'>
                            </cfif>
                        </cfoutput>
                        <cfoutput query="get_list_internaldemand">
                            <cfif listfind('1,2',attributes.list_type)>
                                <cfset 'add_stock_amount_#ACTION_ID#_#ACTION_ROW_ID#_#STOCK_ID#_#SPECT_MAIN_ID#' = get_list_internaldemand.quantity>
                                <cfif isdefined('used_order_amount_#ACTION_ID#_#ACTION_ROW_ID#_#STOCK_ID#') and len(evaluate('used_order_amount_#ACTION_ID#_#ACTION_ROW_ID#_#STOCK_ID#'))>
                                    <cfset 'add_stock_amount_#ACTION_ID#_#ACTION_ROW_ID#_#STOCK_ID#_#SPECT_MAIN_ID#' = evaluate('add_stock_amount_#ACTION_ID#_#ACTION_ROW_ID#_#STOCK_ID#_#SPECT_MAIN_ID#')-evaluate('used_order_amount_#ACTION_ID#_#ACTION_ROW_ID#_#STOCK_ID#')>
                                </cfif>
                                <cfif evaluate('add_stock_amount_#ACTION_ID#_#ACTION_ROW_ID#_#STOCK_ID#_#SPECT_MAIN_ID#') gt 0>
                                    <cfif isdefined('used_stock_amount_#ACTION_ID#_#STOCK_ID#_#SPECT_MAIN_ID#') and len(evaluate('used_stock_amount_#ACTION_ID#_#STOCK_ID#_#SPECT_MAIN_ID#')) and evaluate('used_stock_amount_#ACTION_ID#_#STOCK_ID#_#SPECT_MAIN_ID#') gte evaluate('add_stock_amount_#ACTION_ID#_#ACTION_ROW_ID#_#STOCK_ID#_#SPECT_MAIN_ID#')>
                                        <cfset 'used_stock_amount_#ACTION_ID#_#STOCK_ID#_#SPECT_MAIN_ID#'=evaluate('used_stock_amount_#ACTION_ID#_#STOCK_ID#_#SPECT_MAIN_ID#')-evaluate('add_stock_amount_#ACTION_ID#_#ACTION_ROW_ID#_#STOCK_ID#_#SPECT_MAIN_ID#')>
                                        <cfset 'add_stock_amount_#ACTION_ID#_#ACTION_ROW_ID#_#STOCK_ID#_#SPECT_MAIN_ID#' = 0>
                                    <cfelseif isdefined('used_stock_amount_#ACTION_ID#_#STOCK_ID#_#SPECT_MAIN_ID#') and len(evaluate('used_stock_amount_#ACTION_ID#_#STOCK_ID#_#SPECT_MAIN_ID#')) and evaluate('used_stock_amount_#ACTION_ID#_#STOCK_ID#_#SPECT_MAIN_ID#') lt evaluate('add_stock_amount_#ACTION_ID#_#ACTION_ROW_ID#_#STOCK_ID#_#SPECT_MAIN_ID#')>
                                        <cfset 'add_stock_amount_#ACTION_ID#_#ACTION_ROW_ID#_#STOCK_ID#_#SPECT_MAIN_ID#' = evaluate('add_stock_amount_#ACTION_ID#_#ACTION_ROW_ID#_#STOCK_ID#_#SPECT_MAIN_ID#')-evaluate('used_stock_amount_#ACTION_ID#_#STOCK_ID#_#SPECT_MAIN_ID#')>	
                                        <cfset 'used_stock_amount_#ACTION_ID#_#STOCK_ID#_#SPECT_MAIN_ID#'=0>
                                    </cfif>
                                </cfif>
                                <tr>
                                    <td width="9">#Rownum#</td>
                                    <!-- sil -->
                                    <td align="center" id="order_row#currentrow#" class="color-row" onclick="open_div_purchase_info('#currentrow#','#stock_id#',#product_id#);gizle_goster(siparis_goster#currentrow#);gizle_goster(siparis_gizle#currentrow#);">
                                        <img id="siparis_goster#currentrow#" src="/images/listele.gif" alt="Göster" title="Göster">
                                        <img id="siparis_gizle#currentrow#" src="/images/listele_down.gif" alt="Göster" title="Gizle" style="display:none">
                                    </td>
                                    <!-- sil -->
                                    <cfif attributes.list_type eq 2>
                                        <cfif x_show_project_in eq 1>
                                            <td>
                                                <cfif len(project_id)>
                                                    <cfif len(get_list_internaldemand.product_id_exceptions)>
                                                        <font color="ff0000">#get_project_info.project_head[listfind(project_id_list,project_id)]#</font>
                                                    <cfelse>
                                                        #get_project_info.project_head[listfind(project_id_list,project_id)]#
                                                    </cfif>
                                                </cfif>
                                            </td>
                                        </cfif>
                                        <input type="hidden" name="work_id#action_id#_#action_row_id#" id="work_id#action_id#_#action_row_id#" value="#work_id#" />
                                        <td>
                                            <cfif len(work_id)>
                                                <cfif len(get_list_internaldemand.product_id_exceptions)>
                                                    <font color="ff0000">#get_work_info.work_head[listfind(work_id_list,work_id)]#</font>
                                                <cfelse>
                                                    #get_work_info.work_head[listfind(work_id_list,work_id)]#
                                                </cfif>
                                            </cfif>
                                        </td>
                                        <td width="75"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=project.popup_upd_project_material&upd_id=#action_id#','longpage','popup_upd_project_material');" class="tableyazi">#pro_material_no#</a></td>
                                    <cfelse>
                                        <td width="75">
                                            <a href="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.<cfif is_demand eq 1>list_purchasedemand<cfelse>list_internaldemand</cfif>&event=upd&id=#action_id#" class="tableyazi">
                                                <cfif len(get_list_internaldemand.product_id_exceptions)>
                                                    <font color="ff0000">#internal_number#</font>
                                                <cfelse>
                                                    #internal_number#
                                                </cfif>
                                            </a>
                                        </td>
                                        <cfif session.ep.our_company_info.workcube_sector is 'tersane'>
                                            <td><cfif len(get_list_internaldemand.product_id_exceptions)>
                                                    <font color="ff0000">#dpl_no#</font>
                                                <cfelse>
                                                    #dpl_no#
                                                </cfif>
                                            </td>
                                        </cfif>
                                        <cfif x_is_work eq 1>
                                            <td>
                                                <cfif len(work_id)>
                                                    <a href="#request.self#?fuseaction=project.works&event=det&id=#work_id#" class="tableyazi">
                                                        <cfif len(get_list_internaldemand.product_id_exceptions)>
                                                            <font color="ff0000">#work_no#-#work_head#</font>
                                                        <cfelse>
                                                            #work_no#-#work_head#
                                                        </cfif>
                                                    </a>
                                                </cfif>
                                            </td>
                                        </cfif>
                                        <cfif x_show_project_in eq 1>
                                            <td width="120">
                                                <cfif len(project_id)>
                                                    <cfif len(get_list_internaldemand.product_id_exceptions)>
                                                        <font color="ff0000">#get_project_info.project_head[listfind(project_id_list,project_id)]#</font>
                                                    <cfelse>
                                                        #get_project_info.project_head[listfind(project_id_list,project_id)]#
                                                    </cfif>
                                                </cfif>
                                            </td>
                                        </cfif>
                                    </cfif>
                                    <cfif is_demand neq 1 and attributes.list_type neq 2 and x_show_project_out eq 1>
                                        <td><cfif len(get_list_internaldemand.product_id_exceptions)>
                                                <font color="ff0000">#project_head_out#</font>
                                            <cfelse>
                                                #project_head_out#
                                            </cfif>
                                        </td>
                                    </cfif>                                  
                                    <cfif attributes.list_type eq 1>
                                        <td width="150">
                                            <a href="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.<cfif is_demand eq 1>list_purchasedemand<cfelse>list_internaldemand</cfif>&event=upd&id=#get_list_internaldemand.action_id#" class="tableyazi">
                                                <cfif len(get_list_internaldemand.product_id_exceptions)>
                                                    <font color="ff0000">#subject#</font>
                                                <cfelse>
                                                    #subject#
                                                </cfif>
                                            </a>
                                        </td>
                                    </cfif>
                                    <td width="85">
                                        <cfif len(get_list_internaldemand.product_id_exceptions)>
                                            <font color="ff0000">#dateformat(dateadd('h',session.ep.time_zone,get_list_internaldemand.record_date),dateformat_style)#</font>
                                        <cfelse>
                                            #dateformat(dateadd('h',session.ep.time_zone,get_list_internaldemand.record_date),dateformat_style)#
                                        </cfif>
                                    </td>
                                    <cfif x_is_statu eq 1>
                                        <td><cfif is_active eq 1>
                                                <cfif len(get_list_internaldemand.product_id_exceptions)>
                                                    <font color="ff0000"><cf_get_lang dictionary_id='57493.Aktif'></font>
                                                <cfelse>
                                                    <cf_get_lang dictionary_id='57493.Aktif'>
                                                </cfif>
                                            <cfelse>
                                                <cfif len(get_list_internaldemand.product_id_exceptions)>
                                                    <font color="ff0000"><cf_get_lang dictionary_id='57494.Pasif'></font>
                                                <cfelse>
                                                    <cf_get_lang dictionary_id='57494.Pasif'>
                                                </cfif>
                                            </cfif>
                                        </td>
                                    </cfif>
                                    <cfif x_basket_row_add_definition eq 1 and attributes.list_type eq 1>
                                        <td><cfif len(basket_extra_info_id)>
                                                <cfif len(get_list_internaldemand.product_id_exceptions)>
                                                    <font color="ff0000">#get_basket_info.BASKET_INFO_TYPE[listfind(basket_extra_info_id_list,basket_extra_info_id)]#</font>
                                                <cfelse>
                                                    #get_basket_info.BASKET_INFO_TYPE[listfind(basket_extra_info_id_list,basket_extra_info_id)]#
                                                </cfif>
                                            </cfif>
                                        </td>
                                    </cfif>
                                    <cfif attributes.list_type eq 1 and x_to_position eq 1>
                                        <td><cfif len(get_list_internaldemand.product_id_exceptions)>
                                                <font color="ff0000">#name#</font>
                                            <cfelse>
                                                #name#
                                            </cfif>
                                        </td>
                                    </cfif>
                                    <td width="65">
                                        <cfif len(get_list_internaldemand.product_id_exceptions)>
                                            <font color="ff0000">#get_list_internaldemand.stock_code#</font>
                                        <cfelse>
                                            #get_list_internaldemand.stock_code#
                                        </cfif>
                                    </td> 
                                    <td  style="min-width:230px;">
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_list_internaldemand.product_id#','large');" class="tableyazi">
                                            <cfif len(get_list_internaldemand.product_id_exceptions)>
                                                <font color="ff0000">#get_list_internaldemand.product_name#</font>
                                            <cfelse>
                                                #get_list_internaldemand.product_name#
                                            </cfif>
                                        </a>
                                    </td>
                                    <cfif x_is_show_spec eq 1 and attributes.list_type eq 1>
                                        <td width="100">
                                            <cfif len(get_list_internaldemand.product_id_exceptions)>
                                                <font color="ff0000">#spect_var_name#</font>
                                            <cfelse>
                                                #spect_var_name#
                                            </cfif>
                                        </td>
                                    </cfif>
                                    <td width="150"><cfif len(get_list_internaldemand.company_id)>
                                            <cfif len(get_list_internaldemand.product_id_exceptions)>
                                                <font color="ff0000">#get_company_detail.FULLNAME[listfind(company_id_list,get_list_internaldemand.company_id)]#</font>
                                            <cfelse>
                                                #get_company_detail.FULLNAME[listfind(company_id_list,get_list_internaldemand.company_id)]#
                                            </cfif>
                                        </cfif>
                                    </td>
                                    <cfif attributes.list_type eq 1>
                                        <td  width="85" align="center" nowrap>
                                        <cfif x_list_deliverdate_row eq 1 and not fusebox.fuseaction contains 'autoexcel'>
                                            <div id="update_row_deliver_date_#action_row_id#" style="display:none;"></div> 
                                            <input type="text" name="row_deliver_date_#action_row_id#" id="row_deliver_date_#action_row_id#"  style="width:63px;" readonly class="box_" value="#dateformat(get_list_internaldemand.deliver_date,dateformat_style)#" onchange="change_deliverdate(this.value,#action_row_id#);">
                                            <cf_wrk_date_image date_field="row_deliver_date_#action_row_id#">
                                        <cfelse>	
                                            #dateformat(get_list_internaldemand.deliver_date,dateformat_style)#
                                        </cfif>
                                        </td>
                                        <cfif x_show_project_in eq 1>
                                            <td width="180">
                                                <cfif len(row_dept)>
                                                    <cfif len(get_list_internaldemand.product_id_exceptions)>
                                                        <font color="ff0000">#get_dep_detail.department_head[listfind(department_list,row_dept,',')]#</font>
                                                    <cfelse>
                                                        #get_dep_detail.department_head[listfind(department_list,row_dept,',')]#
                                                    </cfif>
                                                </cfif>
                                                <cfif len(row_loc)>
                                                    <cfif len(get_list_internaldemand.product_id_exceptions)>
                                                        <font color="ff0000"> - #get_location.comment[ListFind(location_list,"#row_dept#-#row_loc#",',')]#</font>
                                                    <cfelse>
                                                        - #get_location.comment[ListFind(location_list,"#row_dept#-#row_loc#",',')]#
                                                    </cfif>
                                                </cfif>
                                            </td>
                                        </cfif>
                                        <cfif is_demand neq 1 and x_show_project_out eq 1>
                                            <td >
                                                <cfif len(get_list_internaldemand.product_id_exceptions)>
                                                    <font color="ff0000">#SL_COMMENT#</font>
                                                <cfelse>
                                                    #SL_COMMENT#
                                                </cfif>
                                            </td>
                                        </cfif>
                                    </cfif>
                                    <cfif x_is_show_unit eq 1 and attributes.list_type eq 1>
                                        <td>
                                            <cfquery name="GET_PRODUCT_UNIT" dbtype="query">
                                                SELECT 
                                                    *
                                                FROM 
                                                    GET_PRODUCT_UNITS 
                                                WHERE 
                                                    PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_list_internaldemand.product_id#"> 
                                            </cfquery>
                                            <cfloop query="get_product_unit">
                                                <cfif is_main is 1>
                                                    <font color="##ff0000">#get_product_unit.add_unit# - #get_product_unit.multiplier# <br/></font>
                                                <cfelse>
                                                    #get_product_unit.add_unit# - #get_product_unit.multiplier# <br/>
                                                </cfif>
                                            </cfloop>
                                        </td>
                                    </cfif>
                                    <td width="75">
                                        <cfif len(get_list_internaldemand.product_id_exceptions)>
                                            <font color="ff0000">#get_list_internaldemand.quantity# #get_list_internaldemand.unit#</font>
                                        <cfelse>
                                            #get_list_internaldemand.quantity# #get_list_internaldemand.unit#
                                        </cfif>
                                    </td>
                                    <td width="75" style="mso-number-format:'0\.0000'"><cfif not fusebox.fuseaction contains 'autoexcel'><input type="text" name="add_stock_amount_#ACTION_ID#_#ACTION_ROW_ID#" id="add_stock_amount_#ACTION_ID#_#ACTION_ROW_ID#" <cfif evaluate('add_stock_amount_#ACTION_ID#_#ACTION_ROW_ID#_#STOCK_ID#_#SPECT_MAIN_ID#') eq 0>readonly="yes"<cfelse> onBlur="if(this.value.length==0 || filterNum(this.value)==0) this.value = '1'; compare(this.value,#evaluate('add_stock_amount_#ACTION_ID#_#ACTION_ROW_ID#_#STOCK_ID#_#SPECT_MAIN_ID#')#,'add_stock_amount_#ACTION_ID#_#ACTION_ROW_ID#');" onkeyup="return(FormatCurrency(this,event,4));"</cfif> class="moneybox" value="#TLFormat(evaluate('add_stock_amount_#ACTION_ID#_#ACTION_ROW_ID#_#STOCK_ID#_#SPECT_MAIN_ID#'),4)#" style="width:50px;"><cfelse>#TLFormat(evaluate('add_stock_amount_#ACTION_ID#_#ACTION_ROW_ID#_#STOCK_ID#_#SPECT_MAIN_ID#'),4)#</cfif></td>
                                    <!-- sil -->
                                    <td><input type="checkbox" name="internal_row_info" id="internal_row_info" value="#ACTION_ID#;#ACTION_ROW_ID#" <cfif (evaluate('add_stock_amount_#ACTION_ID#_#ACTION_ROW_ID#_#STOCK_ID#_#SPECT_MAIN_ID#') lte 0)>disabled</cfif>></td>
                                    <cfif attributes.list_type eq 1>
                                        <td width="20"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_internaldemand_relation&internaldemand_id=#ACTION_ID#&stock_id=#STOCK_ID#','list');"><i class="fa fa-cubes" style="color:red!important;" alt=""></a></td>
                                    </cfif>
                                    <!-- sil -->
                                    <td width="20"><a href="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.<cfif is_demand eq 1>list_purchasedemand<cfelse>list_internaldemand</cfif>&event=upd&id=#get_list_internaldemand.ACTION_ID#"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></a></td>
                                </tr>
                            <cfelse>
                                <tr>
                                    <td>#RowNum#</td>
                                    <td width="75">
                                        <a href="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.<cfif is_demand eq 1>list_purchasedemand<cfelse>list_internaldemand</cfif>&event=upd&id=#get_list_internaldemand.ACTION_ID#" class="tableyazi">#internal_number#</a>
                                    </td>
                                    <cfif session.ep.our_company_info.workcube_sector is 'tersane'>
                                        <td>#dpl_no#</td>
                                    </cfif>
                                    <cfif x_is_work eq 1>
                                        <td><cfif len(work_id)>
                                                <a href="#request.self#?fuseaction=project.works&event=det&id=#work_id#" class="tableyazi">#work_no#-#work_head#</a>
                                            </cfif>
                                        </td>
                                    </cfif>
                                    <cfif x_show_project_in eq 1><td><cfif len(project_id)>#get_project_info.project_head[listfind(project_id_list,project_id)]#</cfif></td></cfif>
                                    <cfif is_demand neq 1 and x_show_project_out eq 1><td>#project_head_out#</td></cfif>
                                    <td width="150">#subject#</td>
                                    <td width="100">#dateformat(dateadd('h',session.ep.time_zone,get_list_internaldemand.record_date),dateformat_style)#</td>
                                    <td width="75">#priority_name#</td>
                                    <td width="125">
                                        <cfif len(from_position_code)>
                                            #get_emp_detail.employee_name[listfind(internald_employee_id_list,get_list_internaldemand.from_position_code,',')]#&nbsp;
                                        <cfelseif len(from_partner_id)>
                                            #get_par_info(get_list_internaldemand.from_partner_id,0,0,0)#&nbsp;
                                        <cfelseif len(from_consumer_id)>
                                            #get_cons_info(get_list_internaldemand.from_consumer_id,0,0)#&nbsp;   
                                        </cfif> 
                                    </td>
                                    <td width="125">
                                        <cfif len(to_position_code)>
                                            #get_from_detail.employee_name[listfind(internald_position_code_list,get_list_internaldemand.to_position_code,',')]#&nbsp;
                                        </cfif>
                                    </td>
                                    <td><cfif len(department_id)>#listgetat(main_department_list,listFind(main_department_list_id,department_id))#</cfif></td>
                                    <cfif x_show_project_in eq 1>
                                    <td>
                                        <cfif len(row_dept)>#get_dep_detail.department_head[listfind(department_list,row_dept,',')]#</cfif>
                                        <cfif len(row_loc)> - #get_location.comment[ListFind(location_list,"#row_dept#-#row_loc#",',')]#</cfif>
                                    </td>
                                    </cfif>
                                    <cfif is_demand neq 1 and  x_show_project_out eq 1><td>#sl_comment#</td></cfif>
                                    <td><cfif len(internaldemand_stage)>#get_pro_name.stage[listfind(stage_list,internaldemand_stage,',')]#</cfif></td>
                                    <td>
                                        <cfif len(to_offer_id_list) and listfind(to_offer_id_list,get_list_internaldemand.ACTION_ID,';') gt 0>
                                            <cf_get_lang dictionary_id='51121.Satınalma Teklifine Dönüştürüldü'><br />
                                        </cfif>
                                        <cfif len(to_order_id_list) and listfind(to_order_id_list,get_list_internaldemand.ACTION_ID,';') gt 0>
                                            <cf_get_lang dictionary_id='31238.Satınalma Siparişine Dönüştürüldü'><br />
                                        </cfif>
                                        <cfif len(to_ship_id_list) and listfind(to_ship_id_list,get_list_internaldemand.ACTION_ID,';') gt 0>
                                            <cf_get_lang dictionary_id='31239.Sevk İrsaliyesine Dönüştürüldü'><br />
                                        </cfif>
                                        <cfif len(to_stock_fis_id_list) and listfind(to_stock_fis_id_list,get_list_internaldemand.ACTION_ID,';') gt 0>
                                            <cf_get_lang dictionary_id='31242.Sarf Fişi Oluşturuldu'><br />
                                        </cfif>
                                        <cfif len(to_internaldemand_id_list) and listfind(to_internaldemand_id_list,get_list_internaldemand.ACTION_ID,';') gt 0>
                                            <cf_get_lang dictionary_id='31192.Satın Alma Talebine Dönüştürüldü'>
                                        </cfif>
                                    </td>
                                    <cfif x_is_statu eq 1><td><cfif is_active eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td></cfif>
                                    <!-- sil -->
                                    <td width="20">
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_internaldemand_relation&internaldemand_id=#ACTION_ID#','list');"><i class="fa fa-cubes" style="color:red!important;" alt=""title="<cf_get_lang dictionary_id='29676.İç Talep Karşılaştırma Raporu'>"></i></a>
                                    </td>
                                    <td width="20"><a href="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.<cfif is_demand eq 1>list_purchasedemand<cfelse>list_internaldemand</cfif>&event=upd&id=#get_list_internaldemand.ACTION_ID#"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></a></td>
                                    <!-- sil -->
                                </tr>
                            </cfif>
                            <cfif listfind('1,2',attributes.list_type)>
                                <!-- sil -->
                                <tr style="display:none;" id="purchase_info_row#currentrow#" class="color-row">
                                    <td colspan="#colspan_#" align="center">
                                        <div id="stock_purchase_info#currentrow#" style="display:none; width:100%;"></div>
                                    </td>
                                </tr>
                                <!-- sil -->
                            </cfif>
                        </cfoutput>
                        <cfif attributes.list_type eq 1>
                            <tfooter>
                                <tr class="total">
                                    <td class="text-right" colspan="<cfoutput>#colspan_+1#</cfoutput>">
                                        <cfif is_demand eq 0 and (not isDefined('xml_purchase_demand_button') or (isDefined('xml_purchase_demand_button') and xml_purchase_demand_button eq 1))>
                                            <input type="submit" class="ui-wrk-btn ui-wrk-btn-extra"  value="<cf_get_lang dictionary_id='51092.Satınalma Talebi Oluştur'>" name="satinalma_talebi" id="satinalma_talebi" onclick="control_action(6);"/>
                                        </cfif>
                                        <input type="submit" class="ui-wrk-btn ui-wrk-btn-extra"  value="<cf_get_lang dictionary_id='36897.Sevk İrsaliyesine Dönüştür'>" name="sevk_irsaliyesi" id="sevk_irsaliyesi" onclick="control_action(1);">
                                        <cfif not isDefined('xml_sarf_fis_button') or (isDefined('xml_sarf_fis_button') and xml_sarf_fis_button eq 1)>
                                            <input type="submit" class="ui-wrk-btn ui-wrk-btn-extra"  value="<cf_get_lang dictionary_id='36881.Stok Fişi Oluştur'>" name="ambar_fisi" id="ambar_fisi" onclick="control_action(2);">
                                        </cfif>
                                        <cfif (not isDefined('xml_sarf_fis_button') or (isDefined('xml_purch_order_button') and xml_purch_order_button eq 1))>
                                            <input type="submit" class="ui-wrk-btn ui-wrk-btn-extra"  value="<cf_get_lang dictionary_id='51276.Satınalma Teklifi Oluştur'>" name="satinalma_teklifi" id="satinalma_teklifi" onclick="control_action(5);">
                                        </cfif>
                                        <cfif not isDefined('xml_sarf_fis_button') or (isDefined('xml_purch_offer_button') and xml_purch_offer_button eq 1)>
                                            <input type="submit" class="ui-wrk-btn ui-wrk-btn-extra" value="<cf_get_lang dictionary_id='41174.Satınalma Siparişi Oluştur'>" name="satinalma_siparisi" id="satinalma_siparisi" onclick="control_action(3);">
                                        </cfif>
                                        <input type="submit" class="ui-wrk-btn ui-wrk-btn-extra"  value="<cf_get_lang dictionary_id='51072.Üretim Talebi Oluştur'>" name="uretim_talebi" id="uretim_talebi" onclick="control_action(7);">
                                    </td>
                                </tr>
                            </tfooter>
                        <cfelseif attributes.list_type eq 2>
                            <cfset colspan_ = 10>
                            <cfif x_show_project_in eq 1><cfset colspan_ = colspan_ + 1></cfif>
                            <cfif x_is_statu eq 1><cfset colspan_ = colspan_ + 1></cfif>
                            <tbody>
                                <tr>
                                    <td height="25" colspan="<cfoutput>#colspan_+1#</cfoutput>" class="text-right">
                                        <input type="button" value="<cf_get_lang dictionary_id='51120.İç Talep Oluştur'>" name="add_internaldemand_" id="add_internaldemand_" onclick="control_action(4);">
                                    </td>
                                </tr>
                            </tbody>
                        </cfif>	
                    <cfelse>
                        <tr>
                            <td colspan="<cfoutput>#colspan_+2#</cfoutput>"><cfif isdefined('attributes.is_submit') and get_list_internaldemand.recordcount eq 0><cf_get_lang dictionary_id='57484.Kayıt Yok'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
                        </tr>
                    </cfif>
                </cfform>
            </tbody>
        </cf_grid_list>
        <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
            <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        </cfif>
        <cfif isdefined("attributes.order_by_date_") and len(attributes.order_by_date_)>
            <cfset url_str = "#url_str#&order_by_date_=#attributes.order_by_date_#">
        </cfif>
        <cfif isdefined("attributes.priority") and len(attributes.priority)>
            <cfset url_str = "#url_str#&priority=#attributes.priority#">
        </cfif>
        <cfif isdefined("attributes.list_type") and len(attributes.list_type)>
            <cfset url_str = "#url_str#&list_type=#attributes.list_type#">
        </cfif>
        <cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)>
            <cfset url_str = "#url_str#&company_id=#attributes.company_id#&company=#attributes.company#">
        </cfif>
        <cfif isdefined("attributes.position_code") and len(attributes.position_code) and isdefined("attributes.position_name") and len(attributes.position_name)>
            <cfset url_str = "#url_str#&position_code=#attributes.position_code#&position_name=#attributes.position_name#">
        </cfif>
        <cfif isdefined("attributes.to_position_code") and len(attributes.to_position_code) and isdefined("attributes.to_position_name") and len(attributes.to_position_name)>
            <cfset url_str = "#url_str#&to_position_code=#attributes.to_position_code#&to_position_name=#attributes.to_position_name#">
        </cfif>
        <cfif isdefined("attributes.from_employee_id") and len(attributes.from_employee_name)>
            <cfset url_str = "#url_str#&from_employee_id=#attributes.from_employee_id#&from_employee_name=#attributes.from_employee_name#">
        </cfif>
        <cfif isdefined("attributes.from_partner_id")and len(attributes.from_partner_id)>
            <cfset url_str = "#url_str#&from_partner_id=#attributes.from_partner_id#">
        </cfif>
        <cfif isdefined("attributes.from_company_id")and len(attributes.from_company_id)>
            <cfset url_str = "#url_str#&from_company_id=#attributes.from_company_id#">
        </cfif>
        <cfif isdefined("attributes.from_consumer_id")and len(attributes.from_consumer_id)>
            <cfset url_str = "#url_str#&from_consumer_id=#attributes.from_consumer_id#">
        </cfif>
        <cfif len(attributes.prod_cat)>
            <cfset url_str = "#url_str#&prod_cat=#attributes.prod_cat#">
        </cfif>
        <cfif len(attributes.location_id) and len(attributes.department_id) and len(attributes.txt_departman)>
            <cfset url_str = "#url_str#&location_id=#attributes.location_id#&department_id=#attributes.department_id#&txt_departman=#attributes.txt_departman#">
        </cfif>
        <cfif len(attributes.location_in_id) and len(attributes.department_in_id) and len(attributes.department_in_txt)>
            <cfset url_str = "&#url_str#&location_in_id=#attributes.location_in_id#&department_in_id=#attributes.department_in_id#&department_in_txt=#attributes.department_in_txt#">
        </cfif>
        <cfif len(attributes.internaldemand_stage)>
            <cfset url_str = "#url_str#&internaldemand_stage=#attributes.internaldemand_stage#">
        </cfif>
        <cfif len(attributes.internaldemand_status)>
            <cfset url_str = "#url_str#&internaldemand_status=#attributes.internaldemand_status#">
        </cfif>
        <cfif len(attributes.internaldemand_action)>
            <cfset url_str = "#url_str#&internaldemand_action=#attributes.internaldemand_action#">
        </cfif>
        <cfif len(attributes.project_id) and len(attributes.project_head)>
            <cfset url_str = "#url_str#&project_id=#attributes.project_id#&project_head=#attributes.project_head#">
        </cfif>
        <cfif len(attributes.work_id) and len(attributes.work_head)>
            <cfset url_str = "#url_str#&work_id=#attributes.work_id#&work_head=#attributes.work_head#">
        </cfif>
        <cfif len(attributes.product_id) and len(attributes.product_name)>
            <cfset url_str = "#url_str#&product_id=#attributes.product_id#&product_name=#attributes.product_name#">
        </cfif>
        <cfif isdate(attributes.startdate)>
            <cfset url_str = "#url_str#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
        </cfif>
        <cfif isdate(attributes.finishdate)>
            <cfset url_str = "#url_str#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#">
        </cfif>
        <cfif isdefined("attributes.is_active")>
            <cfset url_str = "#url_str#&is_active=#attributes.is_active#">
        </cfif>
        <cfif len(attributes.dpl_id) and len(attributes.dpl_no)>
            <cfset url_str = "#url_str#&dpl_id=#attributes.dpl_id#&dpl_no=#attributes.dpl_no#">
        </cfif>
        <cfif isdefined("attributes.project_id_out") and len(attributes.project_id_out) and len(attributes.project_head_out)>
            <cfset url_str = "#url_str#&project_id_out=#attributes.project_id_out#&project_head_out=#attributes.project_head_out#">
        </cfif>
        <cfif isdefined("x_basket_row_add_definition") and x_basket_row_add_definition eq 1 and len(attributes.add_explain)>
            <cfset url_str="#url_str#&add_explain=#attributes.add_explain#">
        </cfif>
        <cfif isdefined("attributes.group_project") and len(attributes.group_project)>
            <cfset url_str="#url_str#&group_project=#attributes.group_project#">
        </cfif>
        <cfif isdefined("attributes.is_submit") and len(attributes.is_submit)>
            <cfset url_str="#url_str#&is_submit=#attributes.is_submit#">
        </cfif>
        <cfif isdefined("attributes.emp_department_id") and len(attributes.emp_department_id)>
            <cfset url_str="#url_str#&emp_department_id=#attributes.emp_department_id#">
        </cfif>
        <cfif isdefined("attributes.emp_department") and len(attributes.emp_department)>
            <cfset url_str="#url_str#&emp_department=#attributes.emp_department#">
        </cfif>
        <cf_paging page="#attributes.page#" 
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#attributes.fuseaction#&#url_str#">
    </cf_box>
</div>
<script type="text/javascript">
    $(document).ready(function(){
        $("table.big_list_head, a.btn").hide();
    });
    document.getElementById('keyword').focus();
	function compare(value,value2,id)
	{
		if(filterNum(value,4)=='' || filterNum(value,4)==0)
			value=1;
			
		if(filterNum(value,4)> value2)
		{
			alert("<cf_get_lang dictionary_id='32727.Kalan Miktar'> <cf_get_lang dictionary_id='54827.Bu Değerden Fazla Olmamalıdır'>:" +value2+"");
			document.getElementById(id).value = commaSplit(value2,4);
			return false;
		}
		return true;
	}
	function change_deliverdate(xx,yy)
	{
		if(xx != '')
		{
			updrowdeliverdate_div = 'update_row_deliver_date_'+yy;
			var send_address = '<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.emptypopup_upd_demand_row_deliver_date&row_order_id=' + yy + '&row_deliver_date=' + xx;
			AjaxPageLoad(send_address,updrowdeliverdate_div ,1);
		}
		else
		{
			alert("<cf_get_lang dictionary_id='45761.Tarih Alanı Boş Olmamalıdır'>");
			return false;
		}
	}
	function kontrol()
	{
		<cfif isdefined("x_is_select_department") and x_is_select_department eq 1>//xmlden zorunlu olsun seçilmişse ve satır bazında listeleme yapılıyorsa
			if(document.list_request_form.list_type.value == 1)
			{
				<cfif x_show_project_out eq 1>
				if(document.list_request_form.txt_departman.value == "" || document.list_request_form.department_id.value == "")
				{
					alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='29428.Çıkış Depo'>");
					return false;
				}
				</cfif>
				<cfif x_show_project_in eq 1>
				if(document.list_request_form.department_in_txt.value == "" || document.list_request_form.department_in_id.value == "")
				{
					alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='51192.Giriş Depo'>");
					return false;
				}
				</cfif>
			}
		</cfif>
		return true;
	}
	function control_action(type)
	/*___Type__ 1:Sevk İrsaliyesi 2:Ambar Fişi 3:Satınalma Siparisi 4: İç Talep 5 : Satinalma Teklifi*/
	{
		
        var checked_item_ = document.getElementsByName('internal_row_info');
		if(checked_item_.length != undefined)
		{
			
			for(var xx=0; xx < checked_item_.length; xx++)
			{
				if(checked_item_[xx].checked)
					var is_selected_row = 1;
			}
		}
		else if(checked_item_.checked)
			var is_selected_row = 1;
		
		if(is_selected_row == undefined)
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='57657.Ürün'>");
			return false;
		}
		
		<cfoutput>
		if(type==1)
		{
			list_internaldemand_2.action="#request.self#?fuseaction=stock.add_ship_dispatch<cfif isdefined("attributes.txt_departman") and len(attributes.txt_departman)>&department_id=#attributes.department_id#&location_id=#attributes.location_id#</cfif><cfif len(attributes.department_in_txt)>&department_in_id=#attributes.department_in_id#&location_in_id=#attributes.location_in_id#</cfif>";
            document.getElementById("sevk_irsaliyesi").disabled = true;
		}
		if(type==2)
		{
			list_internaldemand_2.action="#request.self#?fuseaction=stock.form_add_fis";
            document.getElementById("ambar_fisi").disabled = true;
		}
		if(type==3)
		{
            list_internaldemand_2.action="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.form_add_internaldemand_order";
            document.getElementById("satinalma_siparisi").disabled = true;
		}
		if(type==4)
		{
			if(checked_item_.length != undefined)
			{
				
				for(var xx=0; xx < checked_item_.length; xx++)
				{
					if(checked_item_[xx].checked)
					{
						var action_id_ = list_getat(document.all.internal_row_info[xx].value,2,';');
						var action_row_id_ = list_getat(document.all.internal_row_info[xx].value,1,';');
					}
				}
			}
			list_internaldemand_2.action="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.list_internaldemand&event=add&pro_material_id_list=1<cfif isdefined("ACTION_ID")>&upd_id=#ACTION_ID#</cfif><cfif len(attributes.project_id) and len(attributes.project_head)>&project_id=<cfoutput>#attributes.project_id#</cfoutput></cfif>";
            document.getElementById("add_internaldemand_").disabled = true;
		}
		if(type==5)
		{
            list_internaldemand_2.action="#request.self#?fuseaction=purchase.list_offer&event=add";
            document.getElementById("satinalma_teklifi").disabled = true;
		}
		if(type==6)
		{
			list_internaldemand_2.action="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.list_purchasedemand&event=add&is_from_internaldemand=1<cfif isdefined("ACTION_ID")>&upd_id=#ACTION_ID#</cfif>";
            document.getElementById("satinalma_talebi").disabled = true;
		}
		if(type==7)
		{
			if(checked_item_.length != undefined)
			{
				
				for(var xx=0; xx < checked_item_.length; xx++)
				{
					if(checked_item_[xx].checked)
					{
						var action_row_id_ = list_getat(document.all.internal_row_info[xx].value,2,';');
						var get_spect_info_ = wrk_safe_query('corr_get_intrnldmnd','dsn3',0,action_row_id_);
						var listParam = get_spect_info_.STOCK_ID;
						QueryTextSpec = 'prdp_get_main_spec_id_3';
						var get_main_spec_id = wrk_safe_query(QueryTextSpec,'dsn3',0,listParam);
						if(get_main_spec_id.recordcount == 0)
						{
                            var y = xx + 1;
                            alert(y +". <cf_get_lang dictionary_id='37377.Satırdaki'><cf_get_lang dictionary_id='34603.Ürüne Ait Bir Spec Kaydedilmemiş!'>");        
							return false;
						}
					}
				}
			}
            list_internaldemand_2.action='#request.self#?fuseaction=prod.order&event=add&is_demand=1&is_collacted=1&frm_prod_report=1';
            document.getElementById("uretim_talebi").disabled = true;
		}
		</cfoutput>
		list_internaldemand_2.submit();
	}
	 
	function open_div_purchase_info(no,stock_id,product_id) //satır bazında listelemede stok durumlarını getirmek icin
	{
		gizle_goster(eval("document.getElementById('purchase_info_row"+no+"')"));
		gizle_goster(eval("document.getElementById('stock_purchase_info"+no+"')"));
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_ajax_product_stock_info&sales=1&production_statistic=1&pid='+product_id+'&sid='+stock_id,'stock_purchase_info'+no+'',1);
	}
	function show_work_list()
	{
		if(document.list_request_form.list_type.options[document.list_request_form.list_type.selectedIndex].value==2)//planlama bazında
		{
			document.getElementById('show_product_1').style.display="";//ürünleri göster
			document.getElementById('show_product_2').style.display="";
			document.getElementById('show_company_1').style.display="";
			document.getElementById('show_company_2').style.display="";
			//document.getElementById('company_td_2').style.display="";
			document.getElementById('show_position_1').style.display='none';
			document.getElementById('show_position_2').style.display='none';
			document.getElementById('show_prod_cat_1').style.display='none';
			<cfif x_show_project_in eq 1>
				document.getElementById('show_to_department_1').style.display='none';
				document.getElementById('show_to_department_2').style.display='none';
			</cfif>
			<cfif x_show_project_out eq 1>
				document.getElementById('show_from_department_1').style.display='none';
				document.getElementById('show_from_department_2').style.display='none';
			</cfif>
			<cfif x_basket_row_add_definition eq 1 >
				document.getElementById('add_inf').style.display='none';
			</cfif>
			document.getElementById('show_to_position_code_1').style.display='none';
			document.getElementById('show_to_position_code_2').style.display='none';
			document.getElementById('show_from_position_code_1').style.display='none';
			document.getElementById('show_from_position_code_2').style.display='none';
			<cfif isdefined("x_deliverdate") and x_deliverdate eq 1 and is_demand eq 0>
				document.getElementById('show_deliverdate_1').style.display='none';
				document.getElementById('show_deliverdate_2').style.display='none';
			</cfif>
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=purchase.list_demand_stage&is_demand=#is_demand#&list_type=2<cfif x_show_authorized_stage eq 1><cfif isdefined("Process_RowId_List")>&Process_RowId_List=#Process_RowId_List#</cfif></cfif></cfoutput>' ,'stage1');
		}
		else if(document.list_request_form.list_type.options[document.list_request_form.list_type.selectedIndex].value==1)//satır bazında.
		{
			document.getElementById('show_product_1').style.display='';
			document.getElementById('show_product_2').style.display='';
			document.getElementById('show_company_1').style.display='';
			//document.getElementById('company_td_2').style.display="";
			document.getElementById('show_company_2').style.display='';
			document.getElementById('show_position_1').style.display='';
			document.getElementById('show_position_2').style.display='';
			document.getElementById('show_prod_cat_1').style.display='';
			<cfif x_show_project_in eq 1>
				document.getElementById('show_to_department_1').style.display='';
				document.getElementById('show_to_department_2').style.display='';
			</cfif>
			<cfif is_demand neq 1>
				<cfif x_show_project_out eq 1>
					document.getElementById('show_from_department_1').style.display='';
					document.getElementById('show_from_department_2').style.display='';
				</cfif>
			</cfif>
			<cfif x_basket_row_add_definition eq 1>
				document.getElementById('add_inf').style.display='';
			</cfif>
			document.getElementById('show_to_position_code_1').style.display='';
			document.getElementById('show_to_position_code_2').style.display='';
			document.getElementById('show_from_position_code_1').style.display='';
			document.getElementById('show_from_position_code_2').style.display='';
			<cfif isdefined("x_deliverdate") and x_deliverdate eq 1 and is_demand eq 0>
				document.getElementById('show_deliverdate_1').style.display='';
				document.getElementById('show_deliverdate_2').style.display='';
			</cfif>
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=purchase.list_demand_stage&is_demand=#is_demand#&list_type=1<cfif x_show_authorized_stage eq 1><cfif isdefined("Process_RowId_List")>&Process_RowId_List=#Process_RowId_List#</cfif></cfif></cfoutput>' ,'stage1');
	
		}
		else
		{
			document.getElementById('show_product_1').style.display='none';
			document.getElementById('show_product_2').style.display='none';
			document.getElementById('show_company_1').style.display='none';
			document.getElementById('show_company_2').style.display='none';
			//document.getElementById('company_td_2').style.display="none";
			document.getElementById('show_position_1').style.display='none';
			document.getElementById('show_position_2').style.display='none';
			document.getElementById('show_prod_cat_1').style.display='none';
			<cfif x_show_project_in eq 1>
				document.getElementById('show_to_department_1').style.display='';
				document.getElementById('show_to_department_2').style.display='';
			</cfif>
			<cfif is_demand neq 1>
				<cfif x_show_project_out eq 1>
					document.getElementById('show_from_department_1').style.display='';
					document.getElementById('show_from_department_2').style.display='';
				</cfif>
			</cfif>
			<cfif x_basket_row_add_definition eq 1 >
				document.getElementById('add_inf').style.display='none';
			</cfif>
			document.getElementById('show_to_position_code_1').style.display='';
			document.getElementById('show_to_position_code_2').style.display='';
			document.getElementById('show_from_position_code_1').style.display='';
			document.getElementById('show_from_position_code_2').style.display='';
			<cfif isdefined("x_deliverdate") and x_deliverdate eq 1 and is_demand eq 0>
				document.getElementById('show_deliverdate_1').style.display='none';
				document.getElementById('show_deliverdate_2').style.display='none';
			</cfif>
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=purchase.list_demand_stage&is_demand=#is_demand#&list_type=0<cfif x_show_authorized_stage eq 1><cfif isdefined("Process_RowId_List")>&Process_RowId_List=#Process_RowId_List#</cfif></cfif></cfoutput>' ,'stage1');
		}
	}
</script>
<cf_get_lang_set module_name="#listfirst(attributes.fuseaction,'.')#">