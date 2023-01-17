<cf_xml_page_edit fuseact="assetcare.form_add_asset_care">
<cfinclude template="../query/get_document_type.cfm">
<cfinclude template="../query/get_unit.cfm">
<cfif isdefined("attributes.care_report_id") and len(care_report_id)>
<cfquery name="GET_ASSET_GUARANTY" datasource="#dsn#">
    SELECT
		IS_GUARANTY
	FROM 
		ASSET_CARE_REPORT
	WHERE
    	CARE_REPORT_ID = #attributes.care_report_id#
    </cfquery>
</cfif>
<cfquery name="GET_ASSET_CARE" datasource="#DSN#">
	SELECT
		ASSET_CARE_REPORT.*,
		ASSET_P.ASSETP,
		ASSET_P.ASSETP_ID,
		ASSET_P_CAT.MOTORIZED_VEHICLE
	FROM
		ASSET_CARE_REPORT,
		ASSET_P,
		ASSET_P_CAT
	WHERE
		ASSET_CARE_REPORT.CARE_REPORT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.care_report_id#"> AND
		ASSET_CARE_REPORT.ASSET_ID = ASSET_P.ASSETP_ID AND
		ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID
</cfquery>

<cfquery name="GET_CARE_REPORT_ROW" datasource="#DSN#">
	SELECT
		ASSET_CARE_REPORT_ROW.*,
		SETUP_CARE_CAT.HIERARCHY,
		SETUP_CARE_CAT.CARE_CAT
	FROM
		ASSET_CARE_REPORT_ROW,
		SETUP_CARE_CAT
	WHERE
		CARE_REPORT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.care_report_id#"> AND
		SETUP_CARE_CAT.CARE_CAT_ID = ASSET_CARE_REPORT_ROW.CARE_CAT_ID
	ORDER BY
		ASSET_CARE_REPORT_ROW.CARE_REPORT_ROW_ID
</cfquery>
<cfset row = get_care_report_row.recordcount>
<cfif len(get_asset_care.motorized_vehicle)>
	<cfset motorized_vehicle_value = 1>
<cfelse>
	<cfset motorized_vehicle_value = 0>
</cfif>
<cfquery name="get_care_cat" datasource="#dsn#">
	SELECT ACC.ASSET_CARE_ID, ACC.ASSET_CARE FROM ASSET_CARE_CAT ACC, ASSET_P A WHERE A.ASSETP_ID = #get_asset_care.assetp_id# AND A.ASSETP_CATID = ACC.ASSETP_CAT
</cfquery>

<cf_catalystHeader>
<cfform name="upd_asset_care" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_upd_asset_care" onsubmit="return (unformat_fields());">
	<div class="col col-9">
		<cf_box>
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-is_yasal_islem">
						<label class="col col-4 col-xs-12"><cf_get_lang no='283.Bakım İşlem Tipi'></label>
						<div class="col col-4 col-xs-12">	
							<input type="hidden" name="is_detail" id="is_detail" value="1">
							<input type="hidden" name="care_report_id" id="care_report_id" value="<cfoutput>#attributes.care_report_id#</cfoutput>">
							<input type="hidden" name="motorized_vehicle" id="motorized_vehicle" value="<cfoutput>#get_asset_care.motorized_vehicle#</cfoutput>">
							<input type="hidden" name="failure_id" id="failure_id" value="<cfoutput>#get_asset_care.failure_id#</cfoutput>">
							<input type="hidden" name="calender_date" id="calender_date" value="<cfoutput>#dateFormat(get_asset_care.CALENDER_DATE,dateformat_style)#</cfoutput>">										
							<label><input name="is_yasal_islem" id="is_yasal_islem" type="radio" value="0" <cfif get_asset_care.is_yasal_islem eq 0> checked</cfif> onclick="son_deger_degis(0);"><cf_get_lang no='336.Normal Bakım'></label>
						</div>
						<div class="col col-4 col-xs-12">
							<label><input name="is_yasal_islem" id="is_yasal_islem" type="radio" value="1" <cfif get_asset_care.is_yasal_islem eq 1> checked</cfif> onclick="son_deger_degis(1);"><cf_get_lang no='239.Yasal Bakım'></label>
						</div>
					</div>
					<div class="form-group" id="item_care_km">
						<label class="col col-4 col-xs-12"><cf_get_lang no='241.Bakım KM'>*</label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="care_km" id="care_km" value="#tlformat(get_asset_care.care_km,0)#" class="moneybox" onKeyUp="return(FormatCurrency(this,event),0);" maxlength="50">
						</div>
					</div>
					<div class="form-group" id="item-care_number">
						<label class="col col-4 col-xs-12"><cf_get_lang no='122.Bakım No'></label>
						<div class="col col-8 col-xs-12">
							<input type="text"  name="care_number" id="care_number" value="<cfoutput>#get_asset_care.care_report_number#</cfoutput>"  maxlength="50">
						</div>
					</div>
					<div class="form-group" id="item-asset_id">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='1655.Varlık'></label>
						<div class="col col-8 col-xs-12">
							<input type="hidden" name="asset_id" id="asset_id" value="<cfoutput>#get_asset_care.asset_id#</cfoutput>">
							<cfinput type="text" name="asset_name" value="#get_asset_care.assetp#">
							<!---<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=asset_care.asset_id&field_name=asset_care.asset_name&event_id=0&field_motorized_vehicle=asset_care.motorized_vehicle&motorized_vehicle='+document.asset_care.motorized_vehicle.value+'&call_function=change_display','list','popup_list_assetps');"></span>--->
						</div>
					</div>						
					<div class="form-group" id="item-service_company_id">
						<label class="col col-4 col-xs-12"><cf_get_lang no='240.Bakımı Yapan Firma'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="service_company_id" id="service_company_id" value="<cfoutput>#get_asset_care.company_id#</cfoutput>">
								<input type="text" name="service_company" id="service_company" value="<cfif len(get_asset_care.company_id)><cfoutput>#get_par_info(get_asset_care.company_id,1,0,0)#</cfoutput></cfif>">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=upd_asset_care.service_company&field_comp_id=upd_asset_care.service_company_id&field_name=upd_asset_care.authorized&field_partner=upd_asset_care.authorized_id&is_buyer_seller=1&select_list=7');"></span>
							</div>							
						</div>
					</div>
					<div class="form-group" id="item-station_id">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no ='1422.İstasyon'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="station_id" id="station_id" <cfif isDefined("get_asset_care.STATION_ID") and len(get_asset_care.STATION_ID)>VALUE="<cfoutput>#get_asset_care.STATION_ID#</cfoutput>"</cfif>>
								<cfif len(get_asset_care.STATION_ID)>
									<cfset new_dsn3 = "#dsn#_#get_asset_care.OUR_COMPANY_ID#">
									<cfquery name="GET_STATION" datasource="#new_dsn3#">
										SELECT  STATION_ID,STATION_NAME FROM WORKSTATIONS WHERE STATION_ID = #get_asset_care.STATION_ID#
									</cfquery>
									<input type="hidden" name="station_company_id" id="station_company_id" value="<cfoutput>#get_asset_care.our_company_id#</cfoutput>">
									<input type="text" name="station_name" id="station_name" value="<cfoutput>#GET_STATION.STATION_NAME#</cfoutput>">
								<cfelse>
									<input type="hidden" name="station_company_id" id="station_company_id" value="<cfoutput>#get_asset_care.our_company_id#</cfoutput>">
									<input type="text" name="station_name" id="station_name" value="">
								</cfif>
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=prod.popup_list_workstation&field_comp_id=upd_care.station_company_id&field_name=upd_care.station_name&field_id=upd_care.station_id</cfoutput>')"></span>										
							</div>								
						</div>
					</div>
					<div class="form-group" id="item-employee_id">
						<label class="col col-4 col-xs-12"><cf_get_lang no='39.Bakımı Yapan Çalışan'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="employee_id"  id="employee_id" value="<cfoutput>#get_asset_care.c_employee1_id#</cfoutput>">
								<input type="text" name="employee" id="employee" value="<cfif len(get_asset_care.c_employee1_id)><cfoutput>#get_emp_info(get_asset_care.c_employee1_id,0,0)#</cfoutput></cfif>">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_asset_care.employee_id&field_name=upd_asset_care.employee&select_list=1');"></span>
							</div>
						</div>
					</div>						
					<div class="form-group" id="item-document_type_id">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='1121.Belge Tipi'></label>
						<div class="col col-8 col-xs-12">
							<select name="document_type_id" id="document_type_id">
								<option value="">&nbsp;</option>
								<cfoutput query="get_document_type">
									<option value="#document_type_id#" <cfif get_asset_care.document_type_id eq document_type_id>selected</cfif>>#document_type_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>						
					<div class="form-group" id="item-care_start_date">
						<label class="col col-4 col-xs-12"><cf_get_lang no='758.Bakım Baslangic Tarihi'>*</label>
						<div class="col col-4 col-xs-12">
							<div class="input-group">	
								<cfsavecontent variable="message"><cf_get_lang_main no='370.Tarih Değerinizi Kontrol Ediniz'> !</cfsavecontent>
								<cfinput type="text" name="care_start_date" value="#dateformat(get_asset_care.care_date,dateformat_style)#" message="#message#" required="yes" validate="#validate_style#" maxlength="10">
									<span class="input-group-addon"><cf_wrk_date_image date_field="care_start_date"></span>
								<cfset start_hour = hour(get_asset_care.care_date)>
							</div>
						</div>	
						<div class="col col-2 col-xs-6">						
								<cf_wrkTimeFormat name="start_clock" value="#start_hour#">
						</div>							
						<div class="col col-2 col-xs-6">
							<cfoutput>
								<cfset start_minute = minute(get_asset_care.care_date)>
								<select name="start_minute" id="start_minute">
									<option value=""><cf_get_lang_main no='1415.Dk'></option>
									<cfloop from="0" to="55" step="5" index="k">
										<option value="#k#" <cfif start_minute eq k> selected</cfif>>#numberformat(k,00)#</option>
									</cfloop>
								</select>
							</cfoutput>								
						</div>						
					</div>						
					<div class="form-group" id="item-care_finish_date">
						<label class="col col-4 col-xs-12"><cf_get_lang no='759.Bakım Bitis Tarihi'></label>
						<div class="col col-4 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message1"><cf_get_lang_main no='370.Tarih Değerinizi Kontrol Ediniz'> !</cfsavecontent>
								<cfinput type="text" name="care_finish_date" value="#dateformat(get_asset_care.care_finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message1#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="care_finish_date"></span>
								<cfif len(get_asset_care.care_finish_date)>
									<cfset finish_hour = hour(get_asset_care.care_finish_date)>
									<cfset finish_minute = minute(get_asset_care.care_finish_date)>
								<cfelse>
									<cfset finish_hour = ''>
									<cfset finish_minute = ''>
								</cfif>
							</div>
						</div>
						<div class="col col-2 col-xs-6">
								<cf_wrkTimeFormat name="finish_clock" value="#finish_hour#">
						</div>
						<div class="col col-2 col-xs-6">
							<cfoutput>
								<select name="finish_minute" id="finish_minute">
									<option value=""><cf_get_lang_main no='1415.Dk'></option>
									<cfloop from="0" to="55" step="5" index="k">
										<option value="#numberformat(k,00)#" <cfif finish_minute eq k> selected</cfif>>#numberformat(k,00)#</option>
									</cfloop>
								</select>
							</cfoutput>								
						</div>							
					</div>						
					<div class="form-group" id="item-care_detail">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="care_detail" id="care_detail"><cfif len(get_asset_care.detail)><cfoutput>#get_asset_care.detail#</cfoutput></cfif></textarea>
						</div>
					</div>				
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">							
					<div class="form-group" id="item-detail">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no="1447.Süreç"></label>
						<div class="col col-8 col-xs-12">
							<cf_workcube_process is_upd='0' process_cat_width='170' select_value='#get_asset_care.process_stage#' is_detail='1'>							
						</div>
					</div>
					<div class="form-group" id="item-care_type_id">
						<label class="col col-4 col-xs-12"><cf_get_lang no='42.Bakım Tipi'> *</label>
						<div class="col col-8 col-xs-12">
							<select name="care_type_id" id="care_type_id">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfoutput query="get_care_cat">
									<option value="#asset_care_id#" <cfif get_care_cat.asset_care_id eq get_asset_care.care_type>selected</cfif>>#asset_care#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-authorized_id">
						<label class="col col-4 col-xs-12"><cf_get_lang no='38.Bakımı Yapan Yetkili'></label>
						<div class="col col-8 col-xs-12">
							<input type="hidden" name="authorized_id" id="authorized_id" value="<cfoutput>#get_asset_care.company_partner_id#</cfoutput>">
							<input type="text" name="authorized" id="authorized" value="<cfif len(get_asset_care.company_partner_id)><cfoutput>#get_par_info(get_asset_care.company_partner_id,0,-1,0)#</cfoutput></cfif>" readonly>
						</div>
					</div>
					<div class="form-group" id="item-project_id">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='4.Proje'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfoutput>
									<input type="hidden" name="project_id" id="project_id" value="#get_asset_care.project_id#">
									<input type="text" name="project_head" id="project_head" value="<cfif len(get_asset_care.project_id)>#GET_PROJECT_NAME(get_asset_care.project_id)#</cfif>"  onFocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','upd_asset_care','3','200')" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=upd_asset_care.project_id&project_head=upd_asset_care.project_head');"></span>
								</cfoutput>
							</div>								
						</div>
					</div>						
					<div class="form-group" id="item-employee_id2">
						<label class="col col-4 col-xs-12"><cf_get_lang no='39.Bakım Yapan Çalışan'>2</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="employee_id2" id="employee_id2" value="<cfoutput>#get_asset_care.c_employee2_id#</cfoutput>">
								<input type="text" name="employee2" id="employee2" value="<cfif len(get_asset_care.c_employee2_id)><cfoutput>#get_emp_info(get_asset_care.c_employee2_id,0,0)#</cfoutput></cfif>" readonly>
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_asset_care.employee_id2&field_name=upd_asset_care.employee2&select_list=1');"></span>
							</div>
						</div>					
					</div>						
					<div class="form-group" id="item_bill_id">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='468.Belge No'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="bill_id" id="bill_id" value="<cfoutput>#get_asset_care.bill_id#</cfoutput>" maxlength="20">																									
						</div>
					</div>
					<div class="form-group" id="item_policy_num" style="display:none;">
						<label class="col col-4 col-xs-12"><cf_get_lang no='242.Poliçe No'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="policy_num" id="policy_num" value="#get_asset_care.policy_num#">
						</div>
					</div>
					<div class="form-group" id="item-expense">
						<label class="col col-4 col-xs-12"><cf_get_lang no='243.KDV li Toplam Tutar'></label>
						<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='846.maliyet'></cfsavecontent>
						<div class="col col-5 col-xs-8">
							<cfif isdefined("get_asset_care.expense_amount") and len(get_asset_care.expense_amount)>
								<cfinput type="text" name="expense" value="#tlformat(get_asset_care.expense_amount)#" class="moneybox" message="#message#" onKeyUp="return(FormatCurrency(this,event));">
							<cfelse>
								<cfinput type="text" name="expense" value="" class="moneybox" message="#message#" onKeyUp="return(FormatCurrency(this,event));">
							</cfif>
						</div>
						<div class="col col-3 col-xs-4">
							<cfinclude template="../query/get_money.cfm">
							<select name="money_currency" id="money_currency">
								<cfoutput query="get_money">
									<option value="#money#" <cfif get_asset_care.amount_currency eq money>selected</cfif>>#money#</option>
								</cfoutput>
							</select>
						</div>	
					</div>
					<div class="form-group" id="item-expense_net">
						<label class="col col-4 col-xs-12"><cf_get_lang no='234.KDV siz Toplam Tutar'></label>
						<div class="col col-5 col-xs-8">
							<cfif isdefined("get_asset_care.expense_amount_net") and len(get_asset_care.expense_amount_net)>
								<cfinput type="text" name="expense_net" value="#TLFormat(get_asset_care.expense_amount_net)#" class="moneybox" message="#message#" onKeyUp="return(FormatCurrency(this,event));">
								<cfelse>
								<cfinput type="text" name="expense_net" value="" class="moneybox" message="#message#" onKeyUp="return(FormatCurrency(this,event));">
							</cfif>
						</div>
						<div class="col col-3 col-xs-4">								
							<cfinclude template="../query/get_money.cfm">
							<select name="money_currency_net" id="money_currency_net">
								<cfoutput query="get_money">
									<option value="#money#" <cfif get_asset_care.amount_currency eq money>selected</cfif>>#money#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-is_guaranty">
						<label class="col col-4 col-xs-12"><cf_get_lang no='399.Sigorta Odemesi'></label>
						<div class="col col-8 col-xs-12">
							<div class="col col-12 col-xs-12">
								<div class="col col-6 col-xs-12">
									<label><input name="is_guaranty" id="is_guaranty" type="radio" value="0" <cfif (GET_ASSET_GUARANTY.is_guaranty eq 0)>checked</cfif>><cf_get_lang_main no='1134.Yok'></label>
								</div>
								<div class="col col-6 col-xs-12">
									<label><input name="is_guaranty" id="is_guaranty" type="radio" value="1" <cfif (GET_ASSET_GUARANTY.is_guaranty eq 1)>checked</cfif>><cf_get_lang_main no='1152.Var'></label>
								</div>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-care_detail2">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'>2</label>
						<div class="col col-8 col-xs-12">							
							<textarea name="care_detail2" id="care_detail2"><cfif len(get_asset_care.detail2)><cfoutput>#get_asset_care.detail2#</cfoutput></cfif></textarea>						
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<div class="col col-6">
					<cf_record_info query_name='get_asset_care'>
				</div>
				<div class="col col-6">
					<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=assetcare.emptypopup_del_asset_care&care_report_id=#care_report_id#' add_function='kontrol()'>
				</div>	
			</cf_box_footer>		
		</cf_box>				
	</div>
	<div class="col col-3">	
		<cf_get_workcube_asset asset_cat_id="-23" module_id='40' action_section='CARE_REPORT_ID' action_id='#attributes.care_report_id#'>		
		<cfif len(get_asset_care.station_id)>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id="639.İlişkili Fiziki Varlıklar"></cfsavecontent>
			<cf_box id="rel_phy_asset"
				title="#message#"
				box_page="#request.self#?fuseaction=assetcare.emptypopup_ajax_dsp_physical_assets&station_id=#get_asset_care.station_id#"
				closable="0"
				style="width:99%;">
			</cf_box>
		</cfif>				
	</div>	
	<div class=" col col-9">
		<cfif len(get_asset_care.assetp_id)>
			<cfset attributes.asset_id = get_asset_care.assetp_id>
			<cfset attributes.asset = get_asset_care.assetp>
			<cfsavecontent variable="message"><cf_get_lang no='782.Bileşenler'></cfsavecontent>
			<cf_box id="list_member_rel"
				box_page="#request.self#?fuseaction=assetcare.emptypopup_relation_phsical_asset&asset_id=#attributes.asset_id#&assetp=#attributes.asset#&hide_img=1"
				style="width:99%"
				closable="0"
				title="#message#">
			</cf_box>
		</cfif>		
		<cfif xml_show_care_rows eq 1>
			<cfsavecontent variable="message"><cf_get_lang no='530.Bakım Kalemleri'></cfsavecontent>
			<cf_box id="rel_phy_asset_" title="#message#" box_page="#request.self#?fuseaction=assetcare.emptypopup_upd_care_row&care_report_id=#attributes.care_report_id#" closable="0"style="width:99%;"></cf_box>
		</cfif>
	</div>
</cfform>
<script type="text/javascript">
	<cfif not get_asset_care.motorized_vehicle>
		gizle(item_care_km);
	</cfif>
	
	<cfif get_asset_care.is_yasal_islem eq 1>
		gizle(item_bill_id);		
	<cfelse>
		gizle(item_policy_num);
	</cfif>

	function son_deger_degis(deger)
	{
		if(deger == 0)
		{
			goster(item_bill_id);
			gizle(item_policy_num);
		}
		else
		{
			goster(item_policy_num);
			gizle(item_bill_id);
		}
		degistir_care_type();
	}	

	row_count=<cfoutput>#row#</cfoutput>;
	function degistir_care_type()
	{
		if(document.upd_asset_care.is_yasal_islem[1] != undefined && document.upd_asset_care.is_yasal_islem[1].checked == true)
			var yasal_mi = 1;
		else if(document.upd_asset_care.is_yasal_islem != undefined && document.upd_asset_care.is_yasal_islem.value == 1)
			var yasal_mi = 1;
		else
			var yasal_mi = 0;

		for(j=document.getElementById("care_type_id").length; j>=0; j--)
			document.getElementById("care_type_id").options[j] = null;

		var get_care_type_id = wrk_query("SELECT ACC.ASSET_CARE_ID, ACC.ASSET_CARE FROM ASSET_CARE_CAT ACC, ASSET_P A WHERE A.ASSETP_ID = " + document.getElementById("asset_id").value + " AND ACC.IS_YASAL = " + yasal_mi + " AND A.ASSETP_CATID = ACC.ASSETP_CAT","dsn");
		if(get_care_type_id.recordcount != 0)
		{
			document.getElementById("care_type_id").options[0]=new Option('<cfoutput>#getLang("main",322)#</cfoutput>','');
			for(var jj=0;jj < get_care_type_id.recordcount; jj++)
				document.getElementById("care_type_id").options[jj+1]=new Option(get_care_type_id.ASSET_CARE[jj],get_care_type_id.ASSET_CARE_ID[jj]);
		}
		else
			document.getElementById("care_type_id").options[0]=new Option('<cfoutput>#getLang("main",322)#</cfoutput>','');
			
	}

	function unformat_fields()
	{
		if(upd_asset_care.record_num != undefined)
		{
			for(r=1;r<=upd_asset_care.record_num.value;r++)
				eval("document.upd_asset_care.quantity"+r).value = filterNum(eval("document.upd_asset_care.quantity"+r).value);
		}
		
	}

	function kontrol()
	{
		if(document.upd_asset_care.motorized_vehicle.value == 1)
		{
			if(document.upd_asset_care.care_km.value == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='241.Bakım Km'> !");
				return false;
			}
		}

		if(document.upd_asset_care.is_yasal_islem[1] != undefined && document.upd_asset_care.is_yasal_islem[1].checked == true)
		{
			if(document.upd_asset_care.policy_num.value == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='242.Poliçe No'> !");
				return false;
			}
		}

		if(document.upd_asset_care.care_type_id.value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='42.Bakım Tipi'> !");
			return false;
		}

		//belge tipi zorunlulugu xml den gelir BK
		
			xxx = document.upd_asset_care.document_type_id.selectedIndex;
			if(document.upd_asset_care.document_type_id[xxx].value == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1121.Belge Tipi'> !");
				return false;
			}
		

		//tarih degerlerinin kontrolu

		if ((document.upd_asset_care.care_start_date.value != "") && (document.upd_asset_care.care_finish_date.value != ""))
		{
			if(!time_check(document.upd_asset_care.care_start_date,document.upd_asset_care.start_clock,document.upd_asset_care.start_minute,document.upd_asset_care.care_finish_date,document.upd_asset_care.finish_clock,document.upd_asset_care.finish_minute,"Bakım Başlangıç Tarihi ve Saati, Bitiş Tarihi ve Saatinden önce olmalıdır!"))
			return false;
		}

		if(upd_asset_care.record_num != undefined && document.upd_asset_care.record_num.value > 0)
		{
			for(r=1;r<=upd_asset_care.record_num.value;r++)
			{
				deger_unit = eval("document.upd_asset_care.unit"+r);
				if(eval("document.upd_asset_care.row_kontrol"+r).value == 1)
				{
					if(eval("document.upd_asset_care.care_cat_id"+r).value == "")
					{
						alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='530.Bakım Kalemi'>!");
						return false;
					}
					if(eval("document.upd_asset_care.quantity"+r).value == "")
					{
						alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='223.Miktar'>!");
						return false;
					}
					x = deger_unit.selectedIndex;
					if (deger_unit[x].value == "")
					{
						alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='224.birim'> !");
						return false;
					}
				}
			}
		}
		if(process_cat_control())
		{				
			if(document.getElementById('care_km') != undefined ) document.getElementById('care_km').value = filterNum(document.getElementById('care_km').value); 
		}
		else
			return false;
	}
</script>