<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_allocate.cfm">
<cfinclude template="../query/get_reasons.cfm">
<cfquery name="get_record" datasource="#dsn#">
	SELECT
		RECORD_DATE, 
        RECORD_IP, 
        RECORD_EMP,
		UPDATE_EMP,
		UPDATE_DATE,
		UPDATE_IP 
	FROM
		ASSET_P_KM_CONTROL
	WHERE 
		KM_CONTROL_ID = #get_allocate.KM_CONTROL_ID#
</cfquery>
<cfquery name="get_user_info" datasource="#dsn#">
	SELECT 
    	ID, 
        STATUS, 
        EMPLOYEE_ID, 
        RECORD_DATE, 
        RECORD_IP, 
        RECORD_EMP, 
        ASSETP_ID, 
        KM_CONTROL_ID 
    FROM 
    	ASSET_P_KM_CONTROL_USERS 
    WHERE 
    	KM_CONTROL_ID = #get_allocate.KM_CONTROL_ID#
</cfquery>
<cf_catalystHeader>

<cfset attributes.is_detail = 0>
<!--- Bu tahsis girişinen sonra başka km kaydı  var mı? --->
<cfquery name="GET_KM_FINISH" datasource="#DSN#">
	SELECT 
		MAX(KM_CONTROL_ID) AS MAX_ID
	FROM 
		ASSET_P_KM_CONTROL
	WHERE 
		ASSETP_ID = #get_allocate.assetp_id#
	GROUP BY 
		ASSETP_ID
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="upd_allocate" id="upd_allocate" method="post"  action="#request.self#?fuseaction=assetcare.emptypopup_upd_allocate&km_control_id=#attributes.km_control_id#">
			<input type="hidden" name="is_detail" id="is_detail" value="0">
			<cf_box_elements>
				<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-assetp_name">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29453.Plaka'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfinput type="hidden" name="assetp_id" id="assetp_id" value="#get_allocate.assetp_id#">
							<cfinput type="text" name="assetp_name" readonly value="#get_allocate.assetp#" maxlength="50">
						</div>
					</div>
					<div class="form-group" id="item-department_name">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='48350.Tahsis Edilen Şube'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfinput type="hidden" name="department_id" id="department_id" value="#get_allocate.department_id#">
								<cfinput type="text" name="department" id="department" readonly value="#get_allocate.branch_name# - #get_allocate.department_head#">
								<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_name=upd_allocate.field_dep_branch_name&field_id=upd_allocate.department_id')"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-employee_name">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='48351.Tahsis Edilen'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfinput type="hidden" name="employee_id" id="employee_id" value="#get_allocate.employee_id#">
								<cfinput type="text" name="employee_name" value="#get_allocate.employee_name# #get_allocate.employee_surname#" readonly>
								<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=upd_allocate.employee_id&field_name=upd_allocate.employee_name&select_list=1&branch_related</cfoutput>')"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-allocate_reason">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='48353.Tahsis Tipi'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name="allocate_reason_id" id="allocate_reason_id">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_reasons">
									<option value="#reason_id#" <cfif get_allocate_reasons.allocate_reason_id eq reason_id>selected</cfif>>#allocate_reason#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-allocate_name">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47989.Tahsis Adı'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfinput type="text" name="allocate_name" id="allocate_name" value="#get_allocate.allocate_name#" maxlength="100">
						</div>
					</div>
					<div class="form-group" id="item-detail">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<textarea name="detail" id="detail"><cfoutput>#get_allocate.allocate_detail#</cfoutput></textarea>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-start_km">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='48102.Başlangıç KM'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfinput type="text" name="start_km" id="start_km"  value="#tlFormat(get_allocate.km_start,0)#" readonly="yes">
						</div>
					</div>
					<div class="form-group" id="item-finish_km">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='237.Bitiş KM'> *</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfinput type="text" name="finish_km" id="finish_km"  value="#tlFormat(get_allocate.km_finish,0)#" readonly="yes">
						</div>
					</div>
					<div class="form-group" id="item-start_date">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="col col-6 col-md-12 col-sm-12 col-xs-12">			
								<div class="input-group">
									<cfinput type="text" name="start_date" id="start_date" maxlength="10" value="#dateFormat(date_add("h",session.ep.time_zone,get_allocate.start_date),dateformat_style)#" readonly>
									<span class="input-group-addon"><cf_wrk_date_image readonly="yes" date_field="start_date"></span>
								</div>
							</div>
							<cfset saat = TimeFormat(get_allocate.start_date,"HH")>
                       		<cfset dak = TimeFormat(get_allocate.start_date,"MM")>
							<div class="col col-3 col-md-6 col-sm-6 col-xs-12">			
								<select name="start_hour" id="start_hour" disabled>
									<cfoutput>
										<cfloop from="0" to="23" index="i">
											<option value="#i#" <cfif saat eq i>selected</cfif>>#NumberFormat(i,'00')#</option>
										</cfloop>
									</cfoutput>
								</select>
							</div>
							<div class="col col-3 col-md-6 col-sm-6 col-xs-12">			
								<select name="start_min" id="start_min" disabled>
									<cfoutput>
										<cfloop index="j" from="0" to="55" step="5">
											<option value="#j#" <cfif dak eq j>selected</cfif>>#NumberFormat(j,'00')#</option>
										</cfloop>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-finish_date">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
						<cfif len(get_allocate.finish_date)>
							<cfset saat2 = TimeFormat(get_allocate.finish_date,"HH")>
							<cfset dak2 = TimeFormat(get_allocate.finish_date,"MM")>
							<cfset x = dateFormat(get_allocate.finish_date,dateformat_style)>
						<cfelse>
							<cfset saat2 = 00>
							<cfset dak2 = 00>
							<cfset x = "">
						</cfif>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="col col-6 col-md-12 col-sm-12 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="finish_date" id="finish_date" maxlength="10" value="#x#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
								</div>
							</div>
							<div class="col col-3 col-md-6 col-sm-6 col-xs-12">
								<select name="finish_hour" id="finish_hour">
									<cfoutput>
										<cfloop from="0" to="23" index="k">
											<option value="#k#" <cfif saat2 eq k>selected</cfif>>#NumberFormat(k,'00')#</option>
										</cfloop>
									</cfoutput>
								</select>
							</div>
							<div class="col col-3 col-md-6 col-sm-6 col-xs-12">
								<select name="finish_min" id="finish_min">
									<cfoutput>
										<cfloop from="0" to="55" index="l" step="5">
											<option value="#l#" <cfif dak2 eq l>selected</cfif>>#NumberFormat(l,'00')#</option>
										</cfloop>
									</cfoutput>
								</select>
							</div>              
						</div>
					</div>
					<div class="form-group" id="item-destination">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47988.Gidilecek Yer'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfinput type="text" value="#get_allocate.destination#" name="destination" id="destination" maxlength="100">
						</div>
					</div>
					<div class="form-group" id="item-project_head">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfif len(get_allocate.project_id)>
									<cfquery name="GET_PRO_NAME" datasource="#DSN#">
										SELECT PROJECT_HEAD,TARGET_START,TARGET_FINISH FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_allocate.project_id#">
									</cfquery>
								</cfif>
								<input type="hidden" name="project_id" id="project_id" value="<cfif len(get_allocate.project_id)><cfoutput>#get_allocate.project_id#</cfoutput></cfif>">
								<input name="project_head" type="text" id="project_head" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','list_works','3','250');" value="<cfif len(get_allocate.project_id)><cfoutput>#GET_PRO_NAME.project_head#</cfoutput></cfif>" autocomplete="off">
								<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=list_works.project_head&project_id=list_works.project_id</cfoutput>');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item_process">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cf_workcube_process is_upd='0' is_detail="1" select_value="#get_allocate.process_row_id#" process_cat_width='170'>
						</div>
					</div>
					<div class="form-group" id="item-is_offtime">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='48229.Mesai Dışı'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="checkbox" name="is_offtime" id="is_offtime" value="1" <cfif get_allocate.is_offtime eq 1>checked</cfif>>
						</div>
					</div>
					
				</div>
				<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-upd-cc">
						<cfsavecontent variable="txt_2"><cf_get_lang dictionary_id='57590.Katılımcılar'></cfsavecontent>
						<cfinput type="hidden" name="to_old_ids" id="to_old_ids" value="#valuelist(get_user_info.employee_id)#">
						<cf_workcube_to_cc 
						is_update="1" 
						to_dsp_name="#txt_2#"
						form_name="upd_allocate" 
						str_list_param="1"
						data_type="2"
						str_action_names="EMPLOYEE_ID AS TO_EMP"
						str_alias_names = "TO_EMP"
						action_table="ASSET_P_KM_CONTROL_USERS"
						action_id_name="KM_CONTROL_ID"
						action_dsn="#DSN#"
						action_id="#attributes.KM_CONTROL_ID#">
					</div>
				</div>
				<!--- <cfif get_user_info.recordcount>
					<cfquery name="get_users" datasource="#dsn#">
						SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#valuelist(get_user_info.EMPLOYEE_ID)#)
					</cfquery>	
					<cfoutput query="get_users">
						<tr style="display:none;">
							<td>&nbsp;</td>
							<td><a id="del_func" href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.emptypopup_del_allocate_users&emp_id=#employee_id#&km_control_id=#get_user_info.km_control_id#','small');"><img src="/images/delete_list.gif" border="0" align="absmiddle"></a> #employee_name# #employee_surname#</td>
						</tr>
					</cfoutput>
				</cfif> --->
			</cf_box_elements>
			<cf_box_footer>
				<cf_record_info query_name="get_record">
					<cfif get_km_finish.max_id gt attributes.km_control_id>
						<cf_workcube_buttons is_upd='1' is_cancel='0'add_function='kontrol()' is_delete='0' delete_page_url='#request.self#?fuseaction=assetcare.emptypopup_del_vehicle_allocate&km_control_id=#attributes.km_control_id#'>
					<cfelse>
						<cf_workcube_buttons is_upd='1' is_cancel='0'add_function='kontrol()' is_delete='1' delete_page_url='#request.self#?fuseaction=assetcare.emptypopup_del_vehicle_allocate&km_control_id=#attributes.km_control_id#'>
					</cfif>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	function unformat_fields()
	{
		  document.upd_allocate.start_km.value = filterNum(document.upd_allocate.start_km.value);
		  document.upd_allocate.finish_km.value = filterNum(document.upd_allocate.finish_km.value);
		  document.upd_allocate.start_hour.disabled = false;
		  document.upd_allocate.start_min.disabled = false;
	}
	function kontrol()
	{
			
			x = (50 - upd_allocate.detail.value.length);
			if ( x < 0 )
			{ 
				alert ("<cf_get_lang_main no='217.Açıklama'> "+ ((-1) * x) +" <cf_get_lang_main no='1741.Karakter Uzun'>");
				return false;
			}
			if(!CheckEurodate(document.upd_allocate.finish_date.value,"Bitiş Tarihi"))
			{
				return false;
			}
			if(!date_check(document.upd_allocate.start_date,document.allocate.finish_date, "Tarih Aralığını Kontrol Ediniz!"))
			{
				return false;
			}
		return true;
	}
	function uyari()
	{
		alert("Araçla İlgili Başka KM Kayıtları Olduğu İçin KM' yi Değiştiremezsiniz!");
	}
	
</script>

