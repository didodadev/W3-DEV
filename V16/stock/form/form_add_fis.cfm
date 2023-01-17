<cfsetting showdebugoutput="yes"> 
<cf_get_lang_set module_name="stock">
<cf_xml_page_edit fuseact="stock.form_add_fis">
<cf_papers paper_type="stock_fis">
<cfinclude template="../query/get_shipment_method.cfm">
<cfparam name="attributes.fis_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.member_type" default="employee">
<cfparam name="attributes.company_id" default="#session.ep.company_id#">
<cfif isdefined("paper_full") and isdefined("paper_number")>
	<cfset system_paper_no = paper_full>
	<cfset system_paper_no_add = paper_number>
<cfelse>
	<cfset system_paper_no = "">
	<cfset system_paper_no_add = "">
</cfif>
<cfscript>
xml_all_depo_entry = iif(isdefined("xml_location_auth_entry"),xml_location_auth_entry,DE('-1'));
xml_all_depo_outer = iif(isdefined("xml_location_auth_outer"),xml_location_auth_outer,DE('-1'));
</cfscript>
<cfif isdefined("attributes.upd_id") and len(attributes.upd_id)><!--- Fiş Kopyalama --->
	<cfinclude template="../query/get_fis_det.cfm">
	<cfscript>session_basket_kur_ekle(action_id=attributes.upd_id,table_type_id:6,process_type:1);</cfscript>
	<cfset attributes.fis_date = dateformat(get_fis_det.fis_date,dateformat_style)>
	<cfset attributes.deliver_get_id = get_fis_det.employee_id>
	<cfset attributes.deliver_get = get_emp_info(get_fis_det.employee_id,0,0)>
	<cfset attributes.detail = get_fis_det.fis_detail>
	<cfset attributes.location_out = get_fis_det.location_out>
	<cfset attributes.department_out = get_fis_det.department_out>
	<cfset attributes.txt_departman_out = get_location_info(get_fis_det.department_out,get_fis_det.location_out)>
	<cfif len(get_fis_det.prod_order_number)>
		<cfquery name="GET_PRODUCTION_ORDER" datasource="#DSN3#">
			SELECT P_ORDER_NO FROM PRODUCTION_ORDERS WHERE P_ORDER_ID = #get_fis_det.prod_order_number#
		</cfquery>				  
		<cfset attributes.prod_order_number = get_fis_det.prod_order_number>
		<cfset attributes.prod_order = get_production_order.p_order_no>
	<cfelse>
		<cfset attributes.prod_order_number = "">
		<cfset attributes.prod_order = "">
	</cfif>
	<cfset attributes.ref_no = get_fis_det.ref_no>
	<cfset attributes.location_in = get_fis_det.location_in>
	<cfset attributes.department_in = get_fis_det.department_in>
	<cfset attributes.txt_department_in = get_location_info(get_fis_det.department_in,get_fis_det.location_in)>
	<cfset attributes.pj_id = get_fis_det.project_id><!--- attributes.pj_id başka yerden de gönderiliyor --->
    <cfset attributes.project_id=get_fis_det.project_id_in>
	<cfset attributes.is_production = get_fis_det.is_production>
    <cfset attributes.work_id = get_fis_det.WORK_ID>
    <cfset attributes.subscription_id = get_fis_det.subscription_id>
    <cfif len(attributes.subscription_id)>
    	<cfquery name="get_sub_no" datasource="#dsn3#">
            SELECT SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = #attributes.subscription_id#
        </cfquery> 
        <cfif get_sub_no.recordcount><cfset attributes.subscription_no = get_sub_no.subscription_no></cfif>
    </cfif>
<cfelseif isdefined("attributes.internal_demand_id")>
    <cfquery name="get_internal_demand" datasource="#dsn3#">
        SELECT 
            DEPARTMENT_IN,
            DEPARTMENT_OUT,
            SERVICE_ID,
            PROJECT_ID,
            PROJECT_ID_OUT,
            WORK_ID,
            REF_NO,
            NOTES,
            TARGET_DATE,
            LOCATION_IN,
            LOCATION_OUT,
            NOTES,
			INTERNAL_NUMBER,
			FROM_POSITION_CODE,
			FROM_PARTNER_ID,
			FROM_CONSUMER_ID
        FROM 
            INTERNALDEMAND
        WHERE
            INTERNAL_ID=#attributes.internal_demand_id#
    </cfquery>
    <cfquery name="get_int_row" datasource="#dsn3#">
        SELECT I_ROW_ID FROM INTERNALDEMAND_ROW WHERE I_ID=#attributes.internal_demand_id#
    </cfquery>
   	 <cfif get_int_row.recordcount>
    	<cfset internald_row_id_list=listdeleteduplicates(valuelist(get_int_row.i_row_id,','))>
    </cfif>
   	<cfscript>session_basket_kur_ekle(action_id=attributes.internal_demand_id,table_type_id:7,process_type:1);</cfscript>
	<cfset attributes.fis_date = dateformat(get_internal_demand.target_date,dateformat_style)>
	<cfset attributes.deliver_get_id = ''>
	<cfset attributes.deliver_get = ''>
    <cfif isdefined('get_internal_demand.from_position_code') and len(get_internal_demand.from_position_code)>
        <cfset attributes.deliver_get_id = get_internal_demand.from_position_code>
		<cfset attributes.deliver_get = get_emp_info(get_internal_demand.from_position_code,0,0)>
        <cfset attributes.member_type = 'employee'>
	<cfelseif isDefined('get_internal_demand.from_partner_id') and len(get_internal_demand.from_partner_id)>
        <cfset attributes.deliver_get_id = get_internal_demand.from_partner_id>
        <cfset attributes.deliver_get = get_par_info(get_internal_demand.from_partner_id,0,0,0)>
        <cfset attributes.member_type = 'partner'>
	<cfelseif isDefined('get_internal_demand.from_consumer_id') and len(get_internal_demand.from_consumer_id)>
        <cfset attributes.deliver_get_id = get_internal_demand.from_consumer_id>
        <cfset attributes.deliver_get = get_cons_info(get_internal_demand.from_consumer_id,0,0)>
        <cfset attributes.member_type = 'consumer'>
    </cfif>
	<cfset attributes.detail = get_internal_demand.notes>
    <cfset attributes.location_in = get_internal_demand.location_in>
	<cfset attributes.location_out = get_internal_demand.location_out>
	<cfset attributes.department_out = get_internal_demand.department_out>
    <cfset attributes.txt_departman_out = get_location_info(get_internal_demand.department_out,get_internal_demand.location_out)>
	<cfset attributes.prod_order_number = "">
	<cfset attributes.prod_order = "">
	<cfset attributes.ref_no = get_internal_demand.internal_number>
	<cfset attributes.location_in = get_internal_demand.location_in>
	<cfset attributes.department_in = get_internal_demand.department_in>
	<cfset attributes.txt_department_in = get_location_info(get_internal_demand.department_in,get_internal_demand.location_in)>
	<cfset attributes.pj_id = get_internal_demand.project_id_out>
	<cfset attributes.is_production = ''>
    <cfset attributes.work_id=get_internal_demand.work_id>
    <cfset attributes.service_id=get_internal_demand.service_id>
	<cfset attributes.project_id=get_internal_demand.project_id>
<cfelseif isDefined("attributes.st_id")>
	<cfquery name="get_st" datasource="#dsn3#">
		SELECT
			0 AS DEPARTMENT_IN,
			#listFirst(session.ep.user_location, "-")# AS DEPARTMENT_OUT,
			NULL AS SERVICE_ID,
			PROJECT_ID,
			STRETCHING_TEST_ID AS REF_NO,
			NOTES,
			FABRIC_ARRIVAL_DATE AS TARGET_DATE,
			0 AS LOCATION_ID,
			listGetAt(session.ep.user_location, 2, "-") AS LOCATION_OUT,
			'' AS INTERNAL_NUMBER
		FROM TEXTILE_STRETCHING_TEST_HEAD
		WHERE STRETCHING_TEST_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.st_id#'>
	</cfquery>
	<cfquery name="get_st_row_int" datasource="#dsn3#">
		SELECT STRETCHING_TEST_ROWID FROM TEXTILE_STRETCHING_TEST_ROWS WHERE STRETCHING_TEST_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.st_id#'>
	</cfquery>
	<cfif get_st_row_int.recordCount>
		<cfset internald_row_id_list = listDeleteDuplicates(valueList( get_st_row_int.STRETCHING_TEST_ROWID, ',' ))>
	</cfif>
	<cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
	<cfset attributes.fis_date = dateformat(get_st_row_int.TARGET_DATE,dateformat_style)>
<cfelse>
	<cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
	<cfset attributes.deliver_get_id = session.ep.userid>
	<cfset attributes.deliver_get = get_emp_info(session.ep.userid,0,0)>
	<cfset attributes.detail = "">
	<cfif not isdefined("attributes.location_out")>
		<cfset attributes.location_out = "">
    </cfif>
    <cfif not isdefined("attributes.department_out")>
		<cfset attributes.department_out = "">
    </cfif>
    <cfif not isdefined("attributes.txt_departman_out")>
		<cfset attributes.txt_departman_out = "">
    </cfif>
	<cfif not isdefined("attributes.location_in")>
		<cfset attributes.location_in = "">
    </cfif>
    <cfif not isdefined("attributes.department_in")>
		<cfset attributes.department_in = "">
    </cfif>
    <cfif not isdefined("attributes.txt_department_in")>
		<cfset attributes.txt_department_in = "">
    </cfif>
	<cfset attributes.prod_order_number = "">
	<cfset attributes.prod_order = "">
	<cfparam name="attributes.ref_no" default="">
	<cfset attributes.is_production = "">
</cfif>
<cfif isdefined('attributes.internal_row_info')>
	<cfscript>
		internald_row_amount_list ="";
		internald_row_id_list ="";
		internaldemand_id_list ="";
		for(ind_i=1; ind_i lte listlen(attributes.internal_row_info); ind_i=ind_i+1)
		{
			temp_row_info_ = listgetat(attributes.internal_row_info,ind_i);
			if(isdefined('add_stock_amount_#replace(temp_row_info_,";","_")#') and len(evaluate('add_stock_amount_#replace(temp_row_info_,";","_")#')) )
			{
				internald_row_amount_list = listappend(internald_row_amount_list,filterNum(evaluate('add_stock_amount_#replace(temp_row_info_,";","_")#'),4));
				internald_row_id_list = listappend(internald_row_id_list,listlast(temp_row_info_,';'));
				if(not listfind(internaldemand_id_list,listfirst(temp_row_info_,';')))
					internaldemand_id_list = listappend(internaldemand_id_list,listfirst(temp_row_info_,';'));
			}
		}
	</cfscript>
	<cfif isdefined('internaldemand_id_list') and len(internaldemand_id_list)>
		<cfquery name="GET_INTERNALDEMAND_NUMBER" datasource="#DSN3#">
			SELECT 
				DISTINCT 
				INTERNAL_NUMBER
			FROM 
				INTERNALDEMAND
			WHERE 
				INTERNAL_ID IN (#internaldemand_id_list#)
		</cfquery>
		<cfset internal_number_list = valuelist(GET_INTERNALDEMAND_NUMBER.INTERNAL_NUMBER,',')>

        <cfquery name="get_internaldemand_info" datasource="#dsn3#">
			SELECT PROJECT_ID,PROJECT_ID_OUT,WORK_ID,LOCATION_OUT,DEPARTMENT_OUT,LOCATION_IN,DEPARTMENT_IN FROM INTERNALDEMAND WHERE INTERNAL_ID IN (#internaldemand_id_list#)
        </cfquery>
    
        <cfscript>
            if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.project_id,',')),',') eq 1)
                attributes.project_id = ListDeleteDuplicates(ValueList(get_internaldemand_info.project_id,','));
            else
                attributes.project_id = "";

			if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.project_id_out,',')),',') eq 1)
                attributes.pj_id = ListDeleteDuplicates(ValueList(get_internaldemand_info.project_id_out,','));
            else
                attributes.pj_id = "";	

            if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.work_id,',')),',') eq 1)
                attributes.work_id = ListDeleteDuplicates(ValueList(get_internaldemand_info.work_id,','));
            else
                attributes.work_id = "";
				
			if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.location_out,',')),',') eq 1)
                attributes.location_out = ListDeleteDuplicates(ValueList(get_internaldemand_info.location_out,','));


            else
                attributes.location_out = "";
				
			if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.department_out,',')),',') eq 1)
                attributes.department_out = ListDeleteDuplicates(ValueList(get_internaldemand_info.department_out,','));
            else
                attributes.department_out = "";
				
			if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.location_in,',')),',') eq 1)
                attributes.location_in = ListDeleteDuplicates(ValueList(get_internaldemand_info.location_in,','));
            else
                attributes.location_in = "";
				
			if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.department_in,',')),',') eq 1)
                attributes.department_in = ListDeleteDuplicates(ValueList(get_internaldemand_info.department_in,','));
            else
                attributes.department_in = "";	
        </cfscript>
        
		 <cfif len(attributes.location_out) and len(attributes.department_out)>
            <cfset attributes.txt_departman_out = get_location_info(attributes.department_out,attributes.location_out)>
        </cfif>
		 <cfif len(attributes.location_in) and len(attributes.department_in)>
			<cfset attributes.txt_department_in = get_location_info(attributes.department_in,attributes.location_in)>
         </cfif>
	</cfif>
</cfif>
<cfif isdefined('attributes.is_from_prod_report')><!--- isbak için yapılan özel rapordan gelen değerler için kullanılıyor. silmeyiniz. hgul 20121011 --->
	<cfif isDefined("form.prod_order_number")><cfset attributes.prod_order_number = form.prod_order_number></cfif>
	<cfif isDefined("form.prod_order")><cfset attributes.prod_order = form.prod_order></cfif>
	<cfif (isDefined("form.department_out") and Len(form.department_out)) or (isDefined("attributes.department_out") and Len(attributes.department_out))><cfset attributes.department_out = form.department_out></cfif>
	<cfif (isDefined("form.location_out") and Len(form.location_out)) or (isDefined("attributes.location_out") and Len(attributes.location_out))><cfset attributes.location_out = form.location_out></cfif>
	<cfif isDefined("form.department_in") and Len(form.department_in)><cfset attributes.department_in = form.department_in></cfif>
	<cfif isDefined("form.location_in") and Len(form.location_in)><cfset attributes.location_in = form.location_in></cfif>
	<cfif isDefined("attributes.location_out") and Len(attributes.location_out)><cfset attributes.txt_departman_out = get_location_info(attributes.department_out,attributes.location_out)></cfif>
	<cfif isDefined("attributes.location_in") and Len(attributes.location_in)><cfset attributes.txt_department_in = get_location_info(attributes.department_in,attributes.location_in)></cfif>
</cfif>
<cfif isdefined('x_departman_out') and x_departman_out eq 1><!--- iş detayından sarf fişi ekleneceğinde projenin departmanı varsa, çıkış depoyu projeden getiriyor. --->
	<cfif isdefined("attributes.pj_id") and len(attributes.pj_id)>  
		<cfquery name="get_project_department" datasource="#dsn#">
			SELECT DEPARTMENT_ID,LOCATION_ID FROM PRO_PROJECTS WHERE PROJECT_ID = #attributes.pj_id#
		</cfquery>
		<cfif get_project_department.recordCount>
			<cfset attributes.department_out = get_project_department.department_id>
			<cfset attributes.location_out = get_project_department.location_id>
			<cfset attributes.txt_departman_out = get_location_info(attributes.department_out,attributes.location_out)>
		</cfif>     
	</cfif>
</cfif>
<cf_catalystHeader>
<div id="basket_main_div">
	<cf_box>
		<cfform name="form_basket" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_ship_fis_process">
			<cf_basket_form id="add_fis_process">
				<cfoutput>
					<input type="hidden" name="form_action_address" id="form_action_address" value="#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_ship_fis_process">
					<input type="hidden" name="search_process_date" id="search_process_date" value="fis_date">
					<input type="hidden" name="x_cost_acc" id="x_cost_acc" value="#x_cost_acc#">
					<input type="hidden" name="xml_multiple_counting_fis" id="xml_multiple_counting_fis" value="#xml_multiple_counting_fis#">
					<input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
					<cfif isdefined("attributes.internal_demand_id") and isdefined("internald_row_id_list") and  len(internald_row_id_list)>
						<input type="hidden" name="internald_row_id_list" id="internald_row_id_list" value="#internald_row_id_list#"> 
						<input type="hidden" name="internal_demand_id" id="internal_demand_id" value="#internal_demand_id#">
						<cfset internaldemand_id_list = internal_demand_id>
					</cfif>	
					<input type="hidden" name="internaldemand_id_list" id="internaldemand_id_list" value="<cfif isdefined('internaldemand_id_list') and len(internaldemand_id_list)>#internaldemand_id_list#</cfif>">
					<cf_box_elements>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-form_ul_process_cat">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'> *</label>
								<div class="col col-8 col-xs-12">
									<cfif isdefined("attributes.upd_id") and len(attributes.upd_id)>
									<cf_workcube_process_cat process_cat="#get_fis_det.process_cat#">
								<cfelseif (isdefined('attributes.type') and type eq 'convert') and not isdefined("process_cat_id") and not isdefined("attributes.service") and not isdefined("attributes.material_id")><!--- Üretim Malzeme İhtiyaçları veya İç Talepler Listesinden Dönüşüm Yapılıyorsa --->
									<cfquery name="get_process_type" datasource="#dsn3#" maxrows="1"><!--- Ambar fişi oluşturmak istendiği için seçili işlem tipinden ambar fişini seçili hale getiriyoruz. --->
										SELECT 
											PROCESS_TYPE,
											IS_CARI,
											IS_ACCOUNT,
											IS_STOCK_ACTION,
											PROCESS_CAT_ID
										FROM 
											SETUP_PROCESS_CAT 
										WHERE 
											PROCESS_TYPE = 113
									</cfquery>
									<cf_workcube_process_cat process_cat="#get_process_type.PROCESS_CAT_ID#">
								<cfelseif (isdefined('attributes.type') and type eq 'convert')  and isdefined("attributes.process_cat_id") and not isdefined("attributes.service")>
									<cf_workcube_process_cat process_cat="#attributes.process_cat_id#">
								<cfelseif (isdefined('attributes.type') and attributes.type eq 'convert')  and isdefined("attributes.process_type") and isdefined("attributes.material_id")>
										<cfquery name="get_process_cat" datasource="#dsn3#" maxrows="1">
										SELECT 
											PROCESS_CAT_ID
										FROM 
											SETUP_PROCESS_CAT 
										WHERE 
											PROCESS_TYPE = #attributes.process_type#
									</cfquery>
									<cf_workcube_process_cat process_cat="#get_process_cat.PROCESS_CAT_ID#">
								<cfelseif isdefined('attributes.process_cat') and len(attributes.process_cat)>
									<cf_workcube_process_cat process_cat="#attributes.process_cat#">
								<cfelse>
									<cf_workcube_process_cat>
								</cfif>
								</div>
							</div>
							<div class="form-group" id="item-form_ul_fis_no_">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57946.Fis No'> *</label>
								<div class="col col-8 col-xs-12">
									<input type="text" name="fis_no_" id="fis_no_" value="#system_paper_no#" onBlur="paper_control(this,'STOCK_FIS',false,0,'','','');">
								</div>
							</div>
							<div class="form-group" id="item-form_ul_ref_no_">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58784.Referans No'></label>
								<div class="col col-8 col-xs-12">
									<input type="text" name="ref_no" id="ref_no" maxlength="50" value="<cfif isdefined('attributes.internal_row_info') and isdefined('internaldemand_id_list') and len(internaldemand_id_list)>#internal_number_list#<cfelse>#attributes.ref_no#</cfif>" style="width:150px;">
								</div>
							</div>
							<div class="form-group" id="item-form_ul_work_head">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58445.İş'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="work_id" id="work_id" value="<cfif isdefined("attributes.work_id") and len(attributes.work_id)>#attributes.work_id#</cfif>">
										<input type="text" name="work_head" id="work_head" value="<cfif isdefined("attributes.work_id") and len(attributes.work_id)>#get_work_name(attributes.work_id)#</cfif>">
										<span class="input-group-addon icon-ellipsis" onClick="o_window();"></span>
									</div>
								</div>
							</div>
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
							<div class="form-group" id="item-form_ul_fis_date">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
								<div class="col col-4 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='45290.fis tarihi girmelisiniz'>!</cfsavecontent>
										<cfinput type="text" name="fis_date" maxlength="10" validate="#validate_style#" value="#attributes.fis_date#" required="yes" message="#message#" onblur="change_money_info('form_basket','fis_date');">
										<span class="input-group-addon"><cf_wrk_date_image date_field="fis_date" call_function="change_money_info"></span>
									</div>
								</div>
								<cfoutput>
									<cfif isdefined('get_fis_det.deliver_date') and len(get_fis_det.deliver_date)>
										<cfset value_fis_date_h = hour(get_fis_det.deliver_date)>
										<cfset value_fis_date_m = minute(get_fis_det.deliver_date)>
									<cfelse>
										<cfset value_fis_date_h = hour(dateadd('h',session.ep.time_zone,now()))>
										<cfset value_fis_date_m = minute(now())>
									</cfif>
									<div class="col col-2 col-xs-12">
										<cf_wrkTimeFormat name="fis_date_h" value="#value_fis_date_h#">
									</div>
									<div class="col col-2 col-xs-12">
										<select name="fis_date_m" id="fis_date_m">
											<cfloop from="0" to="59" index="i">
												<option value="#i#" <cfif value_fis_date_m eq i>selected</cfif>><cfif i lt 10>0</cfif>#i# </option>
											</cfloop>
										</select>														
									</div>
								</cfoutput>     
							</div>
							<cfif session.ep.our_company_info.project_followup eq 1>
								<div class="form-group" id="item-form_ul_project_head_in">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29757.Giris Proje'></label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="project_id_in" id="project_id_in" value="<cfif isdefined('attributes.project_id')>#attributes.project_id#</cfif>"> 
											<input type="text" name="project_head_in" id="project_head_in" onfocus="AutoComplete_Create('project_head_in','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id_in','','3','125');" value="<cfif isdefined('attributes.project_id') and  len(attributes.project_id)>#GET_PROJECT_NAME(attributes.project_id)#</cfif>" style="width:150px;">
											<span class="input-group-addon icon-ellipsis" onClick="if(kontrol_giris(1))openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id_in&project_head=form_basket.project_head_in');else return true;"></span>
											<span class="input-group-addon bold" onClick="if(document.getElementById('project_id_in').value!='')windowopen('#request.self#?fuseaction=project.popup_list_project_actions&from_paper=SHIP&id='+document.getElementById('project_id_in').value+'','wwide');else alert('#getLang('','Proje Seçiniz',58797)#');">?</span>
										</div>
									</div>
								</div>
							</cfif>
							<div class="form-group" id="item-form_ul_txt_department_in">
								<label class="col col-4 col-xs-12"><div id="IN_LBL"><cf_get_lang dictionary_id='51192.Giriş Depo'>*</div></label>
								<div class="col col-8 col-xs-12">
									<cfif isdefined('attributes.department_in') and len(attributes.department_in)>
									<cf_wrkdepartmentlocation 
										returnInputValue="location_in,txt_department_in,department_in,branch_in_id"
										returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
										fieldName="txt_department_in"
										fieldid="location_in"
										department_fldId="department_in"
										department_id="#attributes.department_in#"
										xml_all_depo = "#xml_all_depo_entry#"
										location_id="#attributes.location_in#"
										location_name="#attributes.txt_department_in#"
										user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
										line_info = 1
										is_store_kontrol = "0"
										width="150">
								<cfelse>
									<cf_wrkdepartmentlocation
										returnInputValue="location_in,txt_department_in,department_in,branch_in_id"
										returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
										fieldName="txt_department_in"
										fieldid="location_in"
										department_fldId="department_in"
										xml_all_depo = "#xml_all_depo_entry#"
										branch_fldId="branch_in_id"
										user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
										line_info = 2
										width="150"
										call_function="kontrol_giris(0)">
								</cfif>
								</div>
							</div>
							<div class="form-group" id="item-form_ul_is_productions">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='45596.Üretime Giden'></label>
								<div class="col col-8 col-xs-12">
									<input type="checkbox" name="is_productions" id="is_productions" value="1" <cfif attributes.is_production eq 1>checked</cfif>>
								</div>
							</div>
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
							<div class="form-group" id="item-form_ul_prod_order">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45276.Üretim Emir No'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="prod_order_number" id="prod_order_number" value="#attributes.prod_order_number#">
										<input type="text" name="prod_order" id="prod_order" value="#attributes.prod_order#">
										<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_prod_order&field_id=form_basket.prod_order_number&field_name=form_basket.prod_order&keyword='+encodeURIComponent(document.form_basket.prod_order.value));"></span>
									</div>
								</div>
							</div>
							<cfif session.ep.our_company_info.project_followup eq 1>
								<div class="form-group" id="item-form_ul_project_head">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29523.Cikis Proje'></label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.pj_id')>#attributes.pj_id#</cfif>"> 
											<input type="text" name="project_head" id="project_head"  onfocus="if(kontrol_cikis())AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','125'); else return true;" value="<cfif isdefined('attributes.pj_id') and len(attributes.pj_id)>#GET_PROJECT_NAME(attributes.pj_id)#</cfif>" onchange="if(document.getElementById('project_head').value==''){document.getElementById('project_id').value='';}">
											<span class="input-group-addon icon-ellipsis"  onClick="if(kontrol_cikis())openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head'); else return true;"></span>
											<cfif isdefined('attributes.pj_id') and len(attributes.pj_id)>
												<span class="input-group-addon bold" onClick="if(document.getElementById('project_id').value!='')windowopen('#request.self#?fuseaction=project.popup_list_project_actions&from_paper=STOCK_FIS&id='+document.getElementById('project_id').value+'','horizantal');else alert('<cf_get_lang dictionary_id="29523.Çıkış Proje Seçiniz">');">?</span>
											</cfif>
												<span class="input-group-addon bold" onClick="if(document.getElementById('project_id').value!='')windowopen('#request.self#?fuseaction=project.popup_list_project_actions&from_paper=SHIP&id='+document.getElementById('project_id').value+'','wwide');else alert('Proje Seçiniz');">?</span>
										</div>
									</div>
								</div>
							</cfif>
							<div class="form-group" id="item-form_ul_txt_departman_out">
									<label class="col col-4 col-xs-12"><div id="OUT_LBL"><cf_get_lang dictionary_id='29428.Cıkıs Depo'>*</div></label>
									<div class="col col-8 col-xs-12">
											<div id="OUT_TXT">
										<cfif isdefined('attributes.department_out') and len(attributes.department_out)>
											<cf_wrkdepartmentlocation 
												returnInputValue="location_out,txt_departman_out,department_out,branch_id"
												returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
												fieldName="txt_departman_out"
												fieldid="location_out"
												department_fldId="department_out"
												department_id="#attributes.department_out#"
												location_id="#attributes.location_out#"
												xml_all_depo = "#xml_all_depo_outer#"
												location_name="#attributes.txt_departman_out#"
												user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
												line_info = 1
												is_store_kontrol = "0"
												width="150">
										<cfelse>
											<cf_wrkdepartmentlocation
												returnInputValue="location_out,txt_departman_out,department_out,branch_id"
												returnInputQuery="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
												fieldName="txt_departman_out"
												fieldid="location_out"
												department_fldId="department_out"
												xml_all_depo = "#xml_all_depo_outer#"
												user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
												line_info="1"
												is_store_kontrol = "0"
												width="150">
										</cfif>
											</div>
									</div>
							</div>
							<div class="form-group" id="item-form_ul_txt_subscription">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29502.Abone No'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="subscription_id" id="subscription_id" value="<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id)><cfoutput>#attributes.subscription_id#</cfoutput></cfif>" />
										<input type="text" name="subscription_no" id="subscription_no" value="<cfif isdefined("attributes.subscription_no") and len(attributes.subscription_no)><cfoutput>#attributes.subscription_no#</cfoutput></cfif>"/>
										<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_subscription&field_id=form_basket.subscription_id&field_no=form_basket.subscription_no');"></span>
									</div>
								</div>
							</div>
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
							<div class="form-group" id="item-form_ul_member_name">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57775.Teslim Alan'> *</label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="company_id" id="company_id" value="<cfif x_employee_name eq 0>#session.ep.company_id#</cfif>">
										<input type="hidden" name="partner_id" id="partner_id" value="<cfif x_employee_name eq 0><cfif isdefined("from_partner_id") and len(from_partner_id)>#from_partner_id#</cfif></cfif>">
										<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif x_employee_name eq 0><cfif  isdefined("from_consumer_id") and len(from_consumer_id)>#from_consumer_id#</cfif></cfif>">
										<input type="hidden" name="employee_id" id="employee_id" value="<cfif x_employee_name eq 0>#attributes.deliver_get_id#</cfif>">
										<input type="hidden" name="member_type" id="member_type" value="<cfif x_employee_name eq 0>#attributes.member_type#</cfif>">
										<cfif x_employee_name eq 1><cfset attributes.deliver_get=""></cfif>
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='45288.Teslim Alan Girmelisiniz'> !</cfsavecontent>
										<input type="text" name="member_name" id="member_name" value="#attributes.deliver_get#" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',0,0,0','CONSUMER_ID,COMPANY_ID,EMPLOYEE_ID,PARTNER_ID,MEMBER_TYPE','consumer_id,company_id,employee_id,partner_id,member_type','','3','250');" required="yes" message="#message#">
										<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_partner=form_basket.partner_id&field_consumer=form_basket.consumer_id&field_comp_id=form_basket.company_id&field_emp_id=form_basket.employee_id&field_name=form_basket.member_name&field_type=form_basket.member_type&select_list=1,7,8');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-form_ul_service_name">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57656.Servis"></label>
								<div class="col col-8 col-xs-12">
									<cfif isdefined("attributes.service_id") and len(attributes.service_id)>
										<cfquery name="GET_SERVICE_NO" datasource="#DSN3#">
											SELECT SERVICE_NO FROM SERVICE WHERE SERVICE_ID = #attributes.service_id#
										</cfquery>
									</cfif>
									<input type="hidden" name="service_id" id="service_id" value="<cfif isdefined("attributes.service_id") and len(attributes.service_id)>#attributes.service_id#</cfif>"/>
									<input type="text" name="service_name" id="service_name" value="<cfif isdefined("attributes.service_id") and len(attributes.service_id)>#get_service_no.service_no#</cfif>" style="width:150px;" readonly/>
								</div>
							</div>
							<div class="form-group" id="item-form_ul_detail">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Acıklama'></label>
								<div class="col col-8 col-xs-12">
									<textarea name="detail" id="detail" style="width:150px;height:45px;">#attributes.detail#</textarea>
								</div>
							</div>
							<div class="form-group" id="item-additional_info">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57810.Ek Bilgi"></label>
								<div class="col col-8 col-xs-12">
									<cf_wrk_add_info info_type_id="-22" upd_page = "0" colspan="8">
								</div>
							</div>
						</div>
					</cf_box_elements>
					<cf_box_footer>
						<cf_workcube_buttons is_upd='0' add_function='kontrol_kayit()'>
					</cf_box_footer>
				</cfoutput>
			</cf_basket_form>
			<cfif isdefined('attributes.internal_row_info')><!--- ic talepler listesinden olusturulacaksa --->
				<cfset attributes.basket_related_action = 1> 
			</cfif>
			<cfif session.ep.isBranchAuthorization><!--- subeden cagırılıyorsa sube basket sablonunu kullansın--->
				<cfset attributes.basket_id = 19>
				<cfquery name="GET_IS_SELECTED" datasource="#DSN3#">
					SELECT IS_SELECTED FROM SETUP_BASKET_ROWS WHERE BASKET_ID = 19 AND B_TYPE=1 AND TITLE = 'is_project_selected'
				</cfquery>
			<cfelse>
				<cfset attributes.basket_id = 12>
				<cfquery name="GET_IS_SELECTED" datasource="#DSN3#">
					SELECT IS_SELECTED FROM SETUP_BASKET_ROWS WHERE BASKET_ID = 12 AND B_TYPE=1 AND TITLE = 'is_project_selected'
				</cfquery>
			</cfif>
			<cfif not isdefined('attributes.type') and not (isdefined("attributes.upd_id") and len(attributes.upd_id))><!--- Malzeme İhtiyaçları Sayfasından Gelmiyor ise burayı yoksa direkt 12 nolu basket açsın +  kopyalama da değilse --->
				<cfif not isdefined("attributes.file_format")>
					<cfset attributes.form_add = 1>
				<cfelse>
					<cfset attributes.basket_sub_id = 12>
				</cfif>	
			</cfif>
			<cfinclude template="../../objects/display/basket.cfm">
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	function kontrol_kayit()
	{
		if(!paper_control(form_basket.fis_no_,'STOCK_FIS',true,0,'','','')) return false;
		if(!chk_process_cat('form_basket')) return false;
		if(!check_display_files('form_basket')) return false;
		if(!chk_period(form_basket.fis_date,"İşlem")) return false;
		deger = window.document.form_basket.process_cat.options[window.document.form_basket.process_cat.selectedIndex].value;
		if(deger != "")
		{
			var fis_no = eval("form_basket.ct_process_type_" + deger );		
			if(list_find('110,115,119',fis_no.value))
			{
			
				if(form_basket.department_in.value == ""  )
				{
					alert("<cf_get_lang dictionary_id ='45601.Giriş Deposunu Seçmelisiniz'>!");
					return false;
				}
	
				<cfif get_is_selected.is_selected eq 1 and session.ep.our_company_info.project_followup eq 1>
					if(document.getElementById('project_id_in').value == "" || document.getElementById('project_head_in').value == "")
					{
						alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='29757.Giris Proje'>");
						return false;
					}
				</cfif>
			
				if( list_find('119',fis_no.value) )
				{
					if (form_basket.prod_order_number.value == '' || form_basket.prod_order.value == '')
					{	
						alert("<cf_get_lang dictionary_id ='45604.Üretimden Gelen Ürünler için Emir No Bilgisini Belirtin'>!");
						return false;
					}	
				}
			}
			if(list_find('111,112',fis_no.value))
			{
				if(form_basket.department_out.value == ""  )
				{
					alert("<cf_get_lang dictionary_id ='45602.Çıkış Deposunu Seçmelisiniz'>!");					
					return false;
				}
				<cfif get_is_selected.is_selected eq 1 and session.ep.our_company_info.project_followup eq 1>
					if(document.getElementById('project_id').value == "" || document.getElementById('project_head').value == "")
					{
						alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='29523.Cikis Proje'>");
						return false;
					}
				</cfif>
			
			}
			if(list_find('113,114,1131',fis_no.value))
			{
				if(form_basket.department_in.value == "" || form_basket.txt_department_in.value == "" || form_basket.department_out.value == "" )
				{
					alert("<cf_get_lang dictionary_id ='45603.Giriş ve Çıkış Depolarını Seçmelisiniz'>!");
					return false;
				}
				<cfif get_is_selected.is_selected eq 1 and session.ep.our_company_info.project_followup eq 1>
					if(document.getElementById('project_id').value == "" || document.getElementById('project_head').value == "")
					{
						alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='29523.Cikis Proje'>");
						return false;
					}
					if(document.getElementById('project_id_in').value == "" || document.getElementById('project_head_in').value == "")
					{
						alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='29757.Giris Proje'>");
						return false;
					}
				</cfif>
			}
			if(check_stock_action('form_basket') && list_find('110,111,112,113', fis_no.value))
			{
				var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
				if(basket_zero_stock_status.IS_SELECTED != 1)
				{
					if(!zero_stock_control(form_basket.department_out.value,form_basket.location_out.value,0,fis_no.value)) return false;
				}
				
			}
			if(list_find('110,115,119', fis_no.value))
			{
				<cfif session.ep.our_company_info.is_lot_no eq 1>//şirket akış parametrelerinde lot no zorunlu olsun seçili ise
					if( window.basketManager !== undefined ){
						row_count = basketManagerObject.basketItems().length;
						if(check_lotno('form_basket') != undefined && check_lotno('form_basket')){//işlem kategorisinde lot no zorunlu olsun seçili ise
							if(row_count != undefined){
								for(i=0;i<row_count;i++){
									if( basketManagerObject.basketItems()[i].stock_id().length != 0){
										get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0, basketManagerObject.basketItems()[i].stock_id());
										if(get_prod_detail.IS_LOT_NO == 1){//üründe lot no takibi yapılıyor seçili ise
											if(basketManagerObject.basketItems()[i].lot_no() == 0){
												alert((i+1)+'. <cf_get_lang dictionary_id ='59292.satırdaki'> '+ basketManagerObject.basketItems()[i].product_name() + ' <cf_get_lang dictionary_id ='59288.ürünü için lot no takibi yapılmaktadı'>!');
												return false;
											}
										}
									}
								}
							}
						}
					}else{
						row_count = window.basket.items.length;
						if(check_lotno('form_basket') != undefined && check_lotno('form_basket')){//işlem kategorisinde lot no zorunlu olsun seçili ise
							if(row_count != undefined){
								for(i=0;i<row_count;i++){
									if(window.basket.items[i].STOCK_ID.length != 0){
										get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,window.basket.items[i].STOCK_ID);
										if(get_prod_detail.IS_LOT_NO == 1){//üründe lot no takibi yapılıyor seçili ise
											if(window.basket.items[i].LOT_NO.length == 0){
												alert((i+1)+'. <cf_get_lang dictionary_id ='59292.satırdaki'> '+ window.basket.items[i].PRODUCT_NAME + ' <cf_get_lang dictionary_id ='59288.ürünü için lot no takibi yapılmaktadı'>!');
												return false;
												}
											}
										}
									}
								}
							}
						else{
							if(window.basket.items[0].STOCK_ID.length != 0){
								get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,window.basket.items[0].STOCK_ID);
								if(get_prod_detail.IS_LOT_NO == 1){//üründe lot no takibi yapılıyor seçili ise
									if(window.basket.items[0].LOT_NO == ''){
										alert((1)+'. <cf_get_lang dictionary_id ='59292.satırdaki'> '+ window.basket.items[0].PRODUCT_NAME + ' <cf_get_lang dictionary_id ='59288.ürünü için lot no takibi yapılmaktadı'>!');
										return false;
										}
									}
								}
							}
						}			
				</cfif>	
			}
		
			
			<!---Satır bazında seri girilmesi zorunluluğu kontrolü --->
		<cfif isdefined("xml_serialno_control") and (xml_serialno_control eq 1)>
			prod_name_list = '';

			if( window.basketManager !== undefined ){ 
				for(var str=0; str < basketManagerObject.basketItems().length; str++){
					if( basketManagerObject.basketItems()[str].product_id() != ''){
						wrk_row_id_ = basketManagerObject.basketItems()[str].wrk_row_id();
						amount_ = basketManagerObject.basketItems()[str].amount();
						product_serial_control = wrk_safe_query("chk_product_serial1",'dsn3',0, basketManagerObject.basketItems()[str].product_id());
						str1_ = "SELECT SERIAL_NO FROM SERVICE_GUARANTY_NEW WHERE WRK_ROW_ID = '"+ wrk_row_id_ +"'";
						var get_serial_control = wrk_query(str1_,'dsn3');
						if(product_serial_control.IS_SERIAL_NO=='1'&&get_serial_control.recordcount!=amount_){
							prod_name_list = prod_name_list + eval(str +1) + '.Satır : ' + basketManagerObject.basketItems()[str].product_name() + '\n';
						}
					}
				}
			}else{
				for(var str=0; str < window.basket.items.length; str++){
					if(window.basket.items[str].PRODUCT_ID != ''){
						wrk_row_id_ = window.basket.items[str].WRK_ROW_ID;
						amount_ = window.basket.items[str].AMOUNT;
						product_serial_control = wrk_safe_query("chk_product_serial1",'dsn3',0, window.basket.items[str].PRODUCT_ID);
						str1_ = "SELECT SERIAL_NO FROM SERVICE_GUARANTY_NEW WHERE WRK_ROW_ID = '"+ wrk_row_id_ +"'";
						var get_serial_control = wrk_query(str1_,'dsn3');
						if(product_serial_control.IS_SERIAL_NO=='1'&&get_serial_control.recordcount!=amount_){
							prod_name_list = prod_name_list + eval(str +1) + '.Satır : ' + window.basket.items[str].PRODUCT_NAME + '\n';
						}
					}
				}
			}
			if(prod_name_list!=''){
				alert(prod_name_list +" <cf_get_lang dictionary_id='62812.Adlı Ürünler İçin Seri Numarası Girmelisiniz'>!");
				return false;
			}
		</cfif>
		<!---Satır bazında seri girilmesi zorunluluğu kontrolü --->
			saveForm();
			return false;
		}
		else
		{
			alert("<cf_get_lang dictionary_id='58770.İşlem Tipi seçiniz'>!");
			return false;
		}
		
	}
	function kontrol_giris(type)
	{
		deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
		if(deger != "")
		{
			var fis_no = eval("form_basket.ct_process_type_" + deger);
			if(list_find('111,112', fis_no.value))
			{
				if(type == 0)
				alert("<cf_get_lang dictionary_id ='45411.Sarf ve Fire Fişleri için Giriş Deposu Seçemezsiniz'>!");
				else
				alert("<cf_get_lang dictionary_id ='45249.Sarf ve Fire Fişleri için Giriş Proje Seçemezsiniz'>!");
				return false;
			}
			return true;
		}
		else
			alert("<cf_get_lang dictionary_id='58770.İşlem Tipi seçiniz'>!");
	}
	function o_window()
	{
		
		deger=parseInt(window.document.getElementById('process_cat').value);
		var fis_no = eval("form_basket.ct_process_type_" + deger );
	
		if(list_find('111,112', fis_no.value) && document.getElementById('project_id').value!='')
		{
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&field_id=form_basket.work_id&field_name=form_basket.work_head&sarf_project_id='+document.getElementById('project_id').value);
		}
		else
		{
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&field_id=form_basket.work_id&field_name=form_basket.work_head');
		}
	}
	function kontrol_cikis()
	{
		deger=form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
		if(deger != "")
		{
			var fis_no = eval("form_basket.ct_process_type_" + deger );		
			if(list_find('110,115,119', fis_no.value))
			{
				alert("<cf_get_lang dictionary_id ='45599.Üretimden Gelen Ürünler ve Sayım Fişleri için Çıkış Deposu Seçemezsiniz'>!");
				document.getElementById("project_head").blur();
				return false;
			}
			return true;
		}
		else
			alert("<cf_get_lang dictionary_id='58770.İşlem Tipi seçiniz'>!")
	}
	function goster_checkbox(yer)
	{
		if(form_basket.process_cat.options[yer].value == 115)
		{
			goster(is_fire_upd);
			goster(sayim_icin);						
		}
		else
		{
			gizle(is_fire_upd);
			gizle(sayim_icin);						
		}
	}
	function goster_checkbox()
	{
		deger = window.document.form_basket.process_cat.options[window.document.form_basket.process_cat.selectedIndex].value;
		if(deger != ""){
			var fis_no = eval("form_basket.ct_process_type_" + deger );		
			if(fis_no.value == 115)
			{
				gizle_goster(is_fire_upd);
				gizle_goster(sayim_icin);
			}
		}
	}
	function return_company()
	{	
		if(document.getElementById('member_type').value=='employee')
		{	
			var emp_id=document.getElementById('employee_id').value;
			var GET_COMPANY=wrk_safe_query('sls_get_cmpny','dsn',0,emp_id);
			document.getElementById('company_id').value=GET_COMPANY.COMP_ID;
		}
		else
			return false;
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
