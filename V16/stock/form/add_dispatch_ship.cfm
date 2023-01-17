<cf_get_lang_set module_name="stock"> 
<cf_xml_page_edit fuseact="stock.upd_ship_dispatch">
<cfscript>
	if(isDefined("attributes.dispatch_ship_id") and Len(attributes.dispatch_ship_id))
		session_basket_kur_ekle(action_id=attributes.dispatch_ship_id,table_type_id:10,process_type:1);
	else if(isdefined('attributes.is_ship_copy') and isdefined('attributes.ship_id') and len(attributes.ship_id))
		session_basket_kur_ekle(action_id=attributes.ship_id,table_type_id:2,process_type:1);
	else
		session_basket_kur_ekle(process_type:0);
	xml_all_depo_entry = iif(isdefined("xml_location_auth_entry"),xml_location_auth_entry,DE('-1'));
	xml_all_depo_outer = iif(isdefined("xml_location_auth_outer"),xml_location_auth_outer,DE('-1'));
</cfscript>
<cfif isdefined("attributes.department_id") and isdefined("attributes.location_id") and len(attributes.department_id) and len(attributes.location_id)>
	<cfset txt_department_name =get_location_info(attributes.department_id,attributes.location_id)>
</cfif>
<cfif isdefined("attributes.department_in_id") and isdefined("attributes.location_in_id") and len(attributes.department_in_id) and len(attributes.location_in_id)>
	<cfset attributes.department_in_txt =get_location_info(attributes.department_in_id,attributes.location_in_id)>
<cfelse>
	<cfset attributes.department_in_txt = ''>
</cfif>
<cfif (isdefined('attributes.is_ship_copy') or isdefined('attributes.from_sale_ship')) and isdefined('attributes.ship_id') and len(attributes.ship_id)><!--- from_sale_ship: konsinye satış irsaliyesinden depo sevk irsaliyesi olusturulurken gonderiliyor --->
	<cfquery name="GET_UPD_PURCHASE" datasource="#DSN2#">
		SELECT * FROM SHIP WHERE SHIP_ID = #attributes.ship_id#
	</cfquery>
	<cfscript>
		attributes.ref_no = get_upd_purchase.ref_no;
		attributes.pj_id = get_upd_purchase.project_id;
		attributes.ship_method_id = get_upd_purchase.ship_method;
		if(len(attributes.ship_method_id))
		{
			include('../query/get_ship_method.cfm');
			attributes.ship_method_txt_ =GET_SHIP_METHOD.SHIP_METHOD;
		}
		attributes.department_id = get_upd_purchase.deliver_store_id;
		attributes.location_id = get_upd_purchase.location;
		txt_department_name =get_location_info(get_upd_purchase.deliver_store_id,get_upd_purchase.location);
		attributes.department_in_id = get_upd_purchase.department_in;
		attributes.location_in_id = get_upd_purchase.location_in;
		attributes.department_in_txt=get_location_info(get_upd_purchase.department_in,get_upd_purchase.location_in);
		attributes.deliver_date = get_upd_purchase.deliver_date;
		attributes.ship_detail	=get_upd_purchase.ship_detail;
	</cfscript>
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
			INTERNAL_NUMBER
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
    <cfif isdefined('from_position_code') and len(from_position_code)>
        <cfset attributes.deliver_get_id = from_position_code>
		<cfset attributes.deliver_get = get_emp_info(from_position_code,0,0)>
        <cfset attributes.member_type = 'employee'>
	<cfelseif isDefined('from_partner_id') and len(from_partner_id)>
        <cfset attributes.deliver_get = get_par_info(from_partner_id,0,0,0)>
        <cfset attributes.member_type = 'partner'>
	<cfelseif isDefined('from_consumer_id') and len(from_consumer_id)>
        <cfset attributes.deliver_get = get_cons_info(from_consumer_id,0,0)>
        <cfset attributes.member_type = 'consumer'>
    </cfif>
	<cfset attributes.detail = get_internal_demand.notes>
    <cfset attributes.location_in = get_internal_demand.location_in>
	<cfset attributes.location_out = get_internal_demand.location_out>
	<cfset attributes.department_out = get_internal_demand.department_out>
    <cfset attributes.txt_departman_out = get_location_info(get_internal_demand.department_out,get_internal_demand.location_out)>
	<cfset attributes.ref_no = get_internal_demand.internal_number>
	<cfset attributes.location_id = get_internal_demand.location_out>
	<cfset attributes.department_id = get_internal_demand.department_out>
	<cfset attributes.location_in_id = get_internal_demand.location_in>
	<cfset attributes.department_in_id = get_internal_demand.department_in>
	<cfset attributes.department_in_txt = get_location_info(get_internal_demand.department_in,get_internal_demand.location_in)>
    <cfset attributes.work_id=get_internal_demand.work_id>
	<cfset attributes.service_id=get_internal_demand.service_id>
	<cfset attributes.project_id=get_internal_demand.project_id_out>
	<cfset attributes.project_id_in=get_internal_demand.project_id>
	<cfset attributes.project_head_in=IIf(len(attributes.project_id_in),"get_project_name(get_internal_demand.project_id)",DE(""))>
	
<cfelseif isdefined('attributes.internal_row_info')>
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
			attributes.location_id = ListDeleteDuplicates(ValueList(get_internaldemand_info.location_out,','));


		else
			attributes.location_id = "";
			
		if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.department_out,',')),',') eq 1)
			attributes.department_id = ListDeleteDuplicates(ValueList(get_internaldemand_info.department_out,','));
		else
			attributes.department_id = "";
			
		if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.location_in,',')),',') eq 1)
			attributes.location_in_id = ListDeleteDuplicates(ValueList(get_internaldemand_info.location_in,','));
		else
			attributes.location_in_id = "";
			
		if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.department_in,',')),',') eq 1)
			attributes.department_in_id = ListDeleteDuplicates(ValueList(get_internaldemand_info.department_in,','));
		else
			attributes.department_in_id = "";	
	</cfscript>
	 <cfif len(attributes.location_in_id) and len(attributes.department_in_id)>
        <cfset attributes.department_in_txt = get_location_info(attributes.department_in_id,attributes.location_in_id)>
    </cfif>
     <cfif len(attributes.location_id) and len(attributes.department_id)>
        <cfset attributes.txt_departman_ = get_location_info(attributes.department_id,attributes.location_id)>
     </cfif>
	 <cfquery name="GET_INTERNALDEMAND_NUMBER" datasource="#DSN3#">
		SELECT DISTINCT INTERNAL_NUMBER FROM INTERNALDEMAND WHERE INTERNAL_ID IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#internaldemand_id_list#" list="yes">)
	</cfquery>
	<cfset internal_number_list = valuelist(GET_INTERNALDEMAND_NUMBER.INTERNAL_NUMBER,',')>
	<cfparam name="attributes.ref_no" default="#internal_number_list#">
<cfelseif isdefined("attributes.dispatch_ship_id") and len(attributes.dispatch_ship_id)>
	<cfquery name="GET_UPD_PURCHASE" datasource="#DSN2#">
		SELECT * FROM SHIP_INTERNAL WHERE DISPATCH_SHIP_ID = #attributes.dispatch_ship_id#
	</cfquery>
	<cfscript>
		attributes.ref_no = "";
		attributes.pj_id = "";
		attributes.ship_method_id = get_upd_purchase.ship_method;
		if(len(attributes.ship_method_id))
		{
			include('get_ship_method.cfm','\V16\stock\query');
			attributes.ship_method_txt_ =GET_SHIP_METHOD.SHIP_METHOD;
		}
		attributes.department_id = get_upd_purchase.department_out;
		attributes.location_id = get_upd_purchase.location_out;
		txt_department_name =get_location_info(get_upd_purchase.department_out,get_upd_purchase.location_out);
		attributes.department_in_id = get_upd_purchase.department_in;
		attributes.location_in_id = get_upd_purchase.location_in;
		attributes.department_in_txt=get_location_info(get_upd_purchase.department_in,get_upd_purchase.location_in);
		attributes.deliver_date = get_upd_purchase.deliver_date;
		attributes.ship_detail	=get_upd_purchase.detail;
	</cfscript>
<cfelseif isdefined("attributes.receiving_detail_id")>
	<cfquery name="GET_ESHIP_DET" datasource="#DSN2#">
		SELECT ISSUE_DATE,ESHIPMENT_ID FROM ESHIPMENT_RECEIVING_DETAIL WHERE RECEIVING_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.receiving_detail_id#"> 
	</cfquery>
	<cfif GET_ESHIP_DET.recordcount>
		<cfset ship_date = GET_ESHIP_DET.issue_date>
		<script type="text/javascript">
			try{
				window.onload = function () { change_money_info('form_basket','ship_date');}
			}
			catch(e){}
		</script>
	</cfif>
</cfif>
<cfif isdefined('attributes.is_from_report')><!--- isbak için yapılan üretim sevk özel raporundan gelen değerler için kullanılıyor. silmeyiniz. hgul 20130108 --->
	<cfif isDefined("form.department_out")><cfset attributes.department_id = form.department_out></cfif>
	<cfif isDefined("form.department_out")><cfset attributes.location_id = form.location_out></cfif>
	<cfif isDefined("form.department_out")><cfset attributes.department_in_id = form.department_in></cfif>
	<cfif isDefined("form.department_out")><cfset attributes.location_in_id = form.location_in></cfif>
	<cfif isDefined("form.department_out")><cfset attributes.txt_department_name = get_location_info(attributes.department_id,attributes.location_id)></cfif>
	<cfif isDefined("form.department_out")><cfset attributes.department_in_txt = get_location_info(attributes.department_in_id,attributes.location_in_id)></cfif>
	<cfif isDefined("form.department_out")><cfset attributes.ref_no = form.convert_p_order_no></cfif> 
</cfif>
<cfparam name="attributes.ship_date" default="#dateformat(now(),dateformat_style)#">
<cf_catalystHeader>
<cf_papers paper_type="ship">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<div id="basket_main_div">
			<cfform name="form_basket" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_sale">
				<cfoutput>
				<cf_basket_form id="dispatch_ship">
					<input type="hidden" name="form_action_address" id="form_action_address" value="#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_sale">
					<input type="hidden" name="search_process_date" id="search_process_date" value="ship_date">
					<input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
					<input type="hidden" name="paper_number" id="paper_number" value="<cfif isdefined("paper_number")>#paper_number#</cfif>">
					<input type="hidden" name="paper_printer_id" id="paper_printer_id" value="<cfif isDefined('paper_printer_code')>#paper_printer_code#</cfif>">
					<cfif isdefined("attributes.internal_demand_id") and isdefined("internald_row_id_list") and  len(internald_row_id_list)>
						<input type="hidden" name="internald_row_id_list" id="internald_row_id_list" value="#internald_row_id_list#"> 
						<input type="hidden" name="internal_demand_id" id="internal_demand_id" value="#internal_demand_id#">
						<cfset internaldemand_id_list = internal_demand_id>
					</cfif>	
					<cfif isdefined("attributes.receiving_detail_id")>
						<input type="hidden" name="receiving_detail_id" id="receiving_detail_id" value="<cfoutput>#attributes.receiving_detail_id#</cfoutput>">
					</cfif>
					<input type="hidden" name="internaldemand_id_list" id="internaldemand_id_list" value="<cfif isdefined('internaldemand_id_list') and len(internaldemand_id_list)>#internaldemand_id_list#</cfif>">
					<input type="hidden" name="dispatch_ship_id" id="dispatch_ship_id" value="<cfif isdefined("attributes.dispatch_ship_id") and len(attributes.dispatch_ship_id)>#attributes.dispatch_ship_id#</cfif>">
					<cf_box_elements>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="form_ul_process_cat">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='388.işlem tipi'></label>
								<div class="col col-8 col-xs-12">
									<cfif isdefined("attributes.is_from_report") and isdefined("attributes.my_process_cat")>
										<cf_workcube_process_cat process_cat="#attributes.my_process_cat#">
									<cfelse>
										<cfif IsDefined("attributes.process_cat") and len(attributes.process_cat)>
											<cf_workcube_process_cat process_cat="#attributes.process_cat#">
										<cfelse>
											<cf_workcube_process_cat>                                
										</cfif>
									</cfif>
								</div>
							</div>
							<div class="form-group" id="form_ul_ship_number">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='726.Irsaliye No'>*</label>
								<div class="col col-8 col-xs-12">
									<cfsavecontent variable="message"><cf_get_lang no='118.irsaliye no girmelisiniz'>!</cfsavecontent>
									<cfif isdefined("paper_full")>
										<cfinput type="text" name="ship_number" value="#paper_full#" required="Yes" message="#message#" maxlength="50" style="width:150px;" onBlur="paper_control(this,'SHIP',true);">
									<cfelse>
										<cfinput type="text" name="ship_number" value="" required="Yes" message="#message#" maxlength="50" style="width:150px;" onBlur="paper_control(this,'SHIP',true);">					
									</cfif>  
								</div>
							</div>
							<cfif isDefined('url.dispatch_ship_id') and len(url.dispatch_ship_id)>
								<div class="form-group" id="form_ul_ship_internal_number">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49564.İlişkili'><cf_get_lang dictionary_id='45959.Sevk Talebi'></label>
									<div class="col col-8 col-xs-12">
										<cfquery name="get_ship_internal_number" datasource="#dsn2#">
											SELECT PAPER_NO FROM SHIP_INTERNAL WHERE DISPATCH_SHIP_ID = #url.dispatch_ship_id#
										</cfquery>
											<input type="text" name="ship_internal_number" id="ship_internal_number" value="#get_ship_internal_number.paper_no#" readonly>
									</div>
								</div>
							</cfif>
							<div class="form-group" id="form_ul_ship_method_name">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='1703.Sevk Yontemi'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="ship_method" id="ship_method" value="<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id)>#attributes.ship_method_id#</cfif>">
										<input type="text" name="ship_method_name" id="ship_method_name" readonly  value="<cfif isdefined('attributes.ship_method_id') and isdefined('attributes.ship_method_txt_') and len(attributes.ship_method_txt_)>#attributes.ship_method_txt_#</cfif>" style="width:150px;">
										<span class="input-group-addon icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method','list');"></span>
									</div>
								</div>
							</div>
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
							<div class="form-group" id="form_ul_ship_date">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='330.Tarih'> *</label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'>!</cfsavecontent>
										<cfinput type="text" required="Yes" maxlength="10" message="#message#" validate="#validate_style#" name="ship_date" style="width:80px;" value="#attributes.ship_date#" readonly onblur="change_deliver_date()&change_money_info('form_basket','ship_date');">
										<span class="input-group-addon"><cf_wrk_date_image date_field="ship_date" call_function="change_money_info&change_deliver_date"></span>
									</div>    
								</div>
							</div>
							<div class="form-group" id="form_ul_deliver_date_frm">
								<label class="col col-4 col-xs-12"><cf_get_lang no='127.Fiili Sevk Tarih'></label>
								<div class="col col-8 col-xs-12">
									<div class="col col-6 col-xs-12">
										<div class="input-group">
											<cfif isdefined('attributes.deliver_date') and len(attributes.deliver_date)>
												<cfsavecontent variable="message"><cf_get_lang no ='446.Lütfen Fiili Sevk Tarihini Giriniz'></cfsavecontent>
												<cfinput type="text" maxlength="10" name="deliver_date_frm" value="#dateformat(attributes.deliver_date,dateformat_style)#" validate="#validate_style#" style="width:80px;" message="#message#">
												<cfset value_deliver_date_h=hour(attributes.deliver_date)>
												<cfset value_deliver_date_m=minute(attributes.deliver_date)>
											<cfelse>
												<cfsavecontent variable="message"><cf_get_lang no ='446.Lütfen Fiili Sevk Tarihini Giriniz'></cfsavecontent>
												<cfinput type="text" maxlength="10" name="deliver_date_frm" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" style="width:80px;" message="#message#">
												<cfset value_deliver_date_h=hour(now())>
												<cfset value_deliver_date_m=minute(now())>
											</cfif>
											<span class="input-group-addon"><cf_wrk_date_image date_field="deliver_date_frm"></span>&nbsp;
										</div>
									</div>
									<cfoutput>
										<div class="col col-3 col-md-3 col-sm-3 col-xs-12">												
											<cf_wrkTimeFormat name="deliver_date_h" value="#value_deliver_date_h#">
										</div>
										<div class="col col-3 col-md-3 col-sm-3 col-xs-12">	
											<select name="deliver_date_m" id="deliver_date_m">
												<cfloop from="0" to="59" index="i">
													<option value="#i#" <cfif value_deliver_date_m eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
												</cfloop>
											</select>
										</div>	
									</cfoutput>		    
								</div>
							</div>
							<div class="form-group" id="form_ul_ref_no">
									<label class="col col-4 col-xs-12"><cf_get_lang_main no='1372.Ref No'></label>
									<div class="col col-8 col-xs-12">
										<input type="text" name="ref_no" id="ref_no" maxlength="50" value="<cfif isdefined('attributes.ref_no') and len(attributes.ref_no)>#attributes.ref_no#</cfif>" style="width:100px;">
									</div>
							</div>
							<div class="form-group" id="form_ul_work_head">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='1033.İş'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="work_id" id="work_id" value="<cfif isdefined("attributes.work_id") and len(attributes.work_id)>#attributes.work_id#</cfif>">
										<input type="text" name="work_head" id="work_head" style="width:150px;" value="<cfif isdefined("attributes.work_id") and len(attributes.work_id)>#get_work_name(attributes.work_id)#</cfif>">
										<span class="input-group-addon icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_add_work&field_id=form_basket.work_id&field_name=form_basket.work_head','list');"></span>
									</div>
								</div>
							</div>
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
							<div class="form-group" id="form_ul_txt_departman_">
									<label class="col col-4 col-xs-12"><cf_get_lang_main no='1631.Çıkış Depo'> *</label>
									<div class="col col-8 col-xs-12">
										<cfif not (isdefined('txt_department_name') and len(txt_department_name))>
											<cfset search_dep_id = listgetat(session.ep.user_location,1,'-')>
											<cfinclude template="../query/get_dep_names_for_inv.cfm">
											<cfinclude template="../query/get_default_location.cfm">
											<cfif get_loc.recordcount and get_name_of_dep.recordcount>
												<cfset txt_department_name = get_name_of_dep.department_head&'-'&get_loc.comment>
												<cfset attributes.department_id = search_dep_id>
												<cfset attributes.location_id = get_loc.location_id>
											<cfelse>
												<cfset txt_department_name = ''>
											</cfif>
										</cfif>
										<cfif isdefined('attributes.location_id')>
											<cf_wrkdepartmentlocation 
												returnInputValue="location_id,txt_departman_,department_id,branch_id"
												returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
												fieldName="txt_departman_"
												fieldid="location_id"
												department_fldId="department_id"
												department_id="#attributes.department_id#"
												location_id="#attributes.location_id#"
												location_name="#txt_department_name#"
												xml_all_depo = "#xml_all_depo_outer#"
												user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
												line_info = 1
												width="150">
										<cfelse>
											<cf_wrkdepartmentlocation 
												returnInputValue="location_id,txt_departman_,department_id,branch_id"
												returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
												fieldName="txt_departman_"
												fieldid="location_id"
												department_fldId="department_id"
												xml_all_depo = "#xml_all_depo_outer#"
												user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
												line_info = 1
												width="150">
										</cfif>
									</div>
							</div>
							<div class="form-group" id="form_ul_location_in_id">
									<label class="col col-4 col-xs-12"><cf_get_lang no='96.Giriş Depo'> *</label>
									<div class="col col-8 col-xs-12">
										<cfif isdefined('attributes.location_in_id')>
											<cf_wrkdepartmentlocation 
												returnInputValue="location_in_id,department_in_txt,department_in_id,branch_id"
												returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
												fieldName="department_in_txt"
												fieldid="location_in_id"
												department_fldId="department_in_id"
												department_id="#attributes.department_in_id#"
												location_id="#attributes.location_in_id#"
												location_name="#attributes.department_in_txt#"
												xml_all_depo = "#xml_all_depo_entry#"
												user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#" 
												is_store_kontrol = "0"
												line_info = 2
												width="150">
										<cfelse>
											<cf_wrkdepartmentlocation 
												returnInputValue="location_in_id,department_in_txt,department_in_id,branch_id"
												returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
												fieldName="department_in_txt"
												fieldid="location_in_id"
												department_fldId="department_in_id"
												xml_all_depo = "#xml_all_depo_entry#"
												user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
												is_store_kontrol = "0"
												line_info = 2
												width="150">
										</cfif>
									</div>
							</div>
							<div class="form-group" id="form_ul_project_head">
									<label class="col col-4 col-xs-12"><cf_get_lang_main no='19.Cikis'> <cf_get_lang_main no='4.Proje'></label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
												<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.pj_id')>#attributes.pj_id#<cfelseif isdefined('attributes.project_id') and len(attributes.project_id)>#attributes.project_id#</cfif>"> 
												<input type="text" name="project_head" id="project_head" value="<cfif isdefined('attributes.pj_id') and  len(attributes.pj_id)>#GET_PROJECT_NAME(attributes.pj_id)#<cfelseif isdefined('attributes.project_id') and len(attributes.project_id)>#get_project_name(attributes.project_id)#</cfif>" style="width:150px;" onFocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket','3','135')"autocomplete="off">
												<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');"></span>
												<span class="input-group-addon bold" onClick="if(document.getElementById('project_id').value!='')windowopen('#request.self#?fuseaction=project.popup_list_project_actions&from_paper=SHIP&id='+document.getElementById('project_id').value+'','horizantal');else alert('<cf_get_lang_main no="1385.Proje Seçiniz">');">?</span>
										</div>
									</div>
							</div>
							<div class="form-group" id="form_ul_project_head_in">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='142.Giriş'> <cf_get_lang_main no='4.Proje'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
											<input type="hidden" name="project_id_in" id="project_id_in" value="<cfif isdefined("attributes.project_id_in") and len(attributes.project_id_in)>#attributes.project_id_in#</cfif>"> 
											<input type="text" name="project_head_in" id="project_head_in" value="<cfif isdefined("attributes.project_id_in") and len(attributes.project_id_in) and isdefined("attributes.project_head_in") and len(attributes.project_head_in)>#attributes.project_head_in#</cfif>" style="width:150px;" onFocus="AutoComplete_Create('project_head_in','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id_in','form_basket','3','135')"autocomplete="off">
											<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id_in&project_head=form_basket.project_head_in');"></span>
											<span class="input-group-addon bold" onClick="if(document.getElementById('project_id_in').value!='')windowopen('#request.self#?fuseaction=project.popup_list_project_actions&from_paper=SHIP&id='+document.getElementById('project_id_in').value+'','horizantal');else alert('Proje Seçiniz');">?</span>
									</div>
								</div>
							</div>
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
							<div class="form-group" id="form_ul_ship_detail">
									<label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
									<div class="col col-8 col-xs-12">
										<textarea name="ship_detail" id="ship_detail" style="width:140px;height:65px;"><cfif isdefined('attributes.ship_detail') and len(attributes.ship_detail)>#attributes.ship_detail#</cfif></textarea>
								</div>
							</div>
						</div>
					</cf_box_elements>
						<cf_box_footer>	<!---/// footer alanı record info ve submit butonu--->
							<div class="col col-12 text-right">
								<cf_workcube_buttons is_upd='0' add_function="control_depo()">
							</div>
						</cf_box_footer>
			</cf_basket_form>
			<cfif isdefined("attributes.dispatch_ship_id") and len(attributes.dispatch_ship_id)>
					<cfset attributes.basket_id = 31>
					<cfset attributes.basket_sub_id = 44>
				</cfif>
				<cfif isdefined('attributes.internal_row_info') or isdefined('from_sale_ship')><!--- iç talepler listesinden olusturulacaksa --->
					<cfset attributes.basket_related_action = 1> 
				</cfif>
				<cfif session.ep.isBranchAuthorization><!--- subeden cagırılıyorsa sube basket sablonunu kullansın--->
					<cfset attributes.basket_id = 32> 
				<cfelse>
					<cfset attributes.basket_id = 31>
				</cfif>
				<cfif isdefined('attributes.service_ids') and len(attributes.service_ids)> <!--- servis modulunden cagırılıyorsa --->
					<cfset attributes.basket_id = 48>
				</cfif>
				<cfif not isdefined('attributes.type') and not isdefined('attributes.is_from_report') and not (isdefined('attributes.is_ship_copy') and isdefined('attributes.ship_id') and len(attributes.ship_id)) and not isdefined("attributes.dispatch_ship_id") and not (isdefined('attributes.service_ids') and len(attributes.service_ids)) and not isdefined("attributes.receiving_detail_id")>
					<cfif not isdefined("attributes.file_format")>
						<cfset attributes.form_add = 1>
					<cfelse>
						<cfset attributes.basket_sub_id = 41>
					</cfif>		
				</cfif>
				<cfinclude template="../../objects/display/basket.cfm">
			</cfoutput>
			</cfform>
			
		</div>
	</cf_box>
</div>
<script type="text/javascript">
	function control_depo()
	{
	
		if(!paper_control(form_basket.ship_number,'SHIP','true')) return false;
		if(!chk_period(form_basket.ship_date,"İşlem")) return false;
		if(!chk_process_cat('form_basket')) return false;
		if (!check_display_files('form_basket')) return false;
		if(form_basket.txt_departman_.value=="" || form_basket.department_id.value == "")
		{
			alert("<cf_get_lang no ='425.Çıkış Deposu Seçiniz'>!");
			return false;
		}
		if(form_basket.department_in_txt.value=="" || form_basket.department_in_id.value == "")
		{
			alert("<cf_get_lang no ='424.Giriş Deposu Seçiniz'>!");
			return false;
		}
		<cfif isdefined("xml_select_same_dept") and xml_select_same_dept eq 0>
			if(form_basket.department_in_id.value == form_basket.department_id.value && form_basket.location_id.value == form_basket.location_in_id.value)
			{
				alert("<cf_get_lang no ='445.Giriş ve Çıkış Depoda Aynı Lokasyon Seçilemez'>!");
				return false;
			}
		</cfif>
		
		if(datediff(document.getElementById('deliver_date_frm').value,document.getElementById('ship_date').value)>0)
		{
			alert("Fiili Sevk Tarihi, Belge Tarihinden Önce Olamaz!");
			return false;
		}
		
		if(check_stock_action('form_basket'))
		{
			var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
			if(basket_zero_stock_status.IS_SELECTED != 1)
			{
				var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
				var temp_process_type = eval("document.form_basket.ct_process_type_" + temp_process_cat);
				if(!zero_stock_control(form_basket.department_id.value,form_basket.location_id.value,0,temp_process_type.value)) return false;
			}
		}
	
		/* if(form_basket.ship_number.value == "")
		{
			alert("<cf_get_lang no='374.Lütfen Belge No Giriniz'>!");
			return false;
		}
	
		else
		{
			var BELGE_NO_CONTROL = wrk_safe_query('stk_belge_no_control','dsn2',0,form_basket.ship_number.value);
			if(BELGE_NO_CONTROL.recordcount)
			{
				alert("<cf_get_lang_main no='710.Girdiğiniz Belge No Kullanılıyor'>!");
				return false;
			}	
		} */
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
										alert((i+1)+'. satırdaki '+ basketManagerObject.basketItems()[i].product_name() + ' ürünü için lot no takibi yapılmaktadır!');
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
											alert((i+1)+'. satırdaki '+ window.basket.items[i].PRODUCT_NAME + ' ürünü için lot no takibi yapılmaktadır!');
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
									alert((1)+'. satırdaki '+ window.basket.items[0].PRODUCT_NAME + ' ürünü için lot no takibi yapılmaktadır!');
									return false;
								}
							}
						}
					}
				}		
		</cfif>
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
				alert(prod_name_list +" Adlı Ürünler İçin Seri Numarası Girmelisiniz!");
				return false;
			}
		
		</cfif>
		<!---Satır bazında seri girilmesi zorunluluğu kontrolü --->
		
		<cfif isdefined("xml_upd_row_project") and xml_upd_row_project eq 1>
			project_field_name = 'project_head_in';
			project_field_id = 'project_id_in';
			apply_deliver_date('',project_field_name,project_field_id);
		</cfif>
		saveForm();
		return false;
	}
	function irs_tip_sec()
	{
		max_sel = form_basket.process_cat.options.length;
		for(my_i=0;my_i<=max_sel;my_i++)
		{
			if(form_basket.process_cat.options[my_i]!=undefined)
			{
				deger = form_basket.process_cat.options[my_i].value;
				if(deger!="")
				{
					var fis_no = eval("form_basket.ct_process_type_" + deger );
					if(fis_no.value == 81)
					{
						form_basket.process_cat.options[my_i].selected = true;
						my_i = max_sel + 1;
					}
				}
			}
		}
	}
	//irs_tip_sec(); ne işe yaradığını anlayamadım selected özelliğini kullanmamaı engellediği için kapatıyorum PY 
	function change_deliver_date()
	{//eklemede,irsaliye tarihi değiştiğinde fiili sevk tarihi de değişir
		document.form_basket.deliver_date_frm.value = document.form_basket.ship_date.value;
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
<cfsetting showdebugoutput="yes"> 