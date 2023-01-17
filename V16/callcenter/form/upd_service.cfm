<!---select ifadeleri düzenlendi.e.a 24.07.2012--->
<cf_xml_page_edit fuseact="call.add_service">
<cfset attributes.g_service_id = attributes.service_id>
<cfinclude template="../query/get_service_detail.cfm">
<cfif not get_service_detail.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='49305.Bu Şikayet No İle Kayıt Bulunamadı'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfinclude template="../query/get_priority.cfm">
<cfinclude template="../query/get_com_method.cfm">
<cfquery name="GET_SERVICE_APPCAT" datasource="#DSN#"><!--- Kategori --->
	SELECT
			CASE
			WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
			ELSE SERVICECAT
		END AS SERVICECAT,
		SERVICECAT_ID
	FROM
		G_SERVICE_APPCAT
		LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = G_SERVICE_APPCAT.SERVICECAT_ID
		AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SERVICECAT">
		AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="G_SERVICE_APPCAT">
		AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
	WHERE
		IS_STATUS = 1 AND
		(
			OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.company_id#"> OR
			OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.company_id#"> OR
			OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.company_id#,%"> OR
			OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.company_id#,%">
		)    
	ORDER BY 
		SERVICECAT
</cfquery>

<cfquery name="GET_SERVICE_APPCAT_SUB" datasource="#DSN#"><!--- Alt Kategori --->
	SELECT
		SERVICE_SUB_CAT_ID,
		SERVICE_SUB_CAT,
		SERVICECAT_ID
	FROM
		G_SERVICE_APPCAT_SUB
	WHERE
		IS_STATUS = 1 AND
		(
			OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.company_id#"> OR
			OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.company_id#"> OR
			OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.company_id#,%"> OR
			OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.company_id#,%">
		)    	  
	ORDER BY
		SERVICE_SUB_CAT
</cfquery>

<cfquery name="GET_SERVICE_APPCAT_SUB_STATUS" datasource="#DSN#"><!--- Alt Tree Kategori --->
	SELECT
		SERVICE_SUB_CAT_ID,
		SERVICE_SUB_STATUS_ID,
		SERVICE_SUB_STATUS
	FROM
		G_SERVICE_APPCAT_SUB_STATUS
	WHERE
		IS_STATUS = 1 AND
		(
			OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.company_id#"> OR
			OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.company_id#"> OR
			OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.company_id#,%"> OR
			OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.company_id#,%">
		)
	UNION ALL
	SELECT
		SERVICE_SUB_CAT_ID,
		SERVICE_SUB_STATUS_ID,
		SERVICE_SUB_STATUS
	FROM
		G_SERVICE_APPCAT_SUB_STATUS
	WHERE
		IS_STATUS = 0 AND
		(
			OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.company_id#"> OR
			OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.company_id#"> OR
			OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.company_id#,%"> OR
			OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.company_id#,%">
		) AND
		SERVICE_SUB_STATUS_ID IN (SELECT SERVICE_SUB_STATUS_ID FROM G_SERVICE_APP_ROWS WITH(NOLOCK) WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">)   
	ORDER BY 
		SERVICE_SUB_STATUS
</cfquery>
<cfquery name="GET_SERVICE_APP_ROWS" datasource="#DSN#"><!--- Basvuru Satirlari- Kategori Bilgileri --->
	SELECT 
		SERVICE_SUB_CAT_ID,
		SERVICECAT_ID,
		SERVICE_SUB_STATUS_ID,
		SERVICE_ID
	FROM 
		G_SERVICE_APP_ROWS 
	WHERE 
		SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
</cfquery>
<cfset app_rows = valuelist(get_service_app_rows.service_sub_status_id,',')>
<cfscript>
	attributes.company_id = get_service_detail.service_company_id;
	attributes.partner_id = get_service_detail.service_partner_id;
	attributes.consumer_id = get_service_detail.service_consumer_id;
	attributes.employee_id = get_service_detail.service_employee_id;
	attributes.brnch_id = get_service_detail.service_branch_id;
</cfscript>
<cfset pageHead = #getLang('main',774)# & " : " & #GET_SERVICE_DETAIL.SERVICE_NO#>
<cf_catalystHeader>
<!--- Sayfa ana kısım  --->

<div style="display:none;z-index:999;" id="simlar_apply"></div>
<div style="display:none;z-index:999;" id="history"></div>
<cfset keyword=get_service_detail.service_head>
<cfif isdefined("get_service_detail.fuseaction") and len(get_service_detail.fuseaction)>
	<cfquery name="get_woid" datasource="#dsn#">
		SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_service_detail.fuseaction#">
	</cfquery>
	<cfset keyword=get_service_detail.fuseaction>
</cfif>
<cfform name="add_service" method="post" action="#request.self#?fuseaction=call.emptypopup_act_upd_service&id=#attributes.service_id#&#xml_str#">
<cfoutput>
	<input type="hidden" name="old_app_rows" id="old_app_rows" value="#app_rows#">
	<input type="hidden" name="service_no" id="service_no" value="#get_service_detail.service_no#">
	<input type="hidden" name="service_id" id="service_id" value="#attributes.service_id#">
	<input type="hidden" name="listParam" id="listParam" value="#ValueList(get_service_appcat_sub.service_sub_cat_id,',')#">
	<input type="hidden" name="temp_service_sub_cat_id" id="temp_service_sub_cat_id" value="#get_service_app_rows.service_sub_cat_id#">
	<input type="hidden" name="x_is_sub_tree_single_select" id="x_is_sub_tree_single_select" value="#x_is_sub_tree_single_select#">
</cfoutput>
	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
		<cf_box title="#getLang('call',112)# #getLang('main',359)#" closable="0" id="form">
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-checkbox">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<cf_get_lang dictionary_id='57493.Aktif'>
								<input type="checkbox" name="status" id="status" value="1" <cfif get_service_detail.service_active eq 1>checked</cfif>>
							</label>
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<cf_get_lang dictionary_id ='57475.Mail Gönder'>
								<input type="checkbox" name="send_mail" id="send_mail" value="1" <cfif get_service_detail.send_mail eq 1>checked</cfif>>
							</label>
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<cf_get_lang dictionary_id='58590.SMS Gönder'>
								<input type="checkbox" name="send_sms" id="send_sms" value="1" <cfif get_service_detail.send_sms eq 1>checked</cfif>>
							</label>
						</div>
						<cfoutput>
							<div class="form-group" id="item-member_name">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29514.Başvuru Yapan'> *</label>
								<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
									<cfif len(get_service_detail.service_employee_id)>
										<cfquery name="GET_EMP_POS" datasource="#DSN#">
											SELECT POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.service_employee_id#">
										</cfquery>
									</cfif>
									<input type="hidden" name="partner_id" id="partner_id" value="<cfif len(get_service_detail.service_partner_id)>#get_service_detail.service_partner_id#</cfif>">
									<input type="hidden" name="company_id" id="company_id" value="<cfif len(get_service_detail.service_company_id)>#get_service_detail.service_company_id#</cfif>">
									<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif len(get_service_detail.service_consumer_id)>#get_service_detail.service_consumer_id#</cfif>">
									<input type="hidden" name="employee_id" id="employee_id" value="<cfif len(get_service_detail.service_employee_id)>#get_service_detail.service_employee_id#</cfif>">
										<input type="text" name="member_company" id="member_company" value="<cfif len(get_service_detail.service_company_id)>#get_par_info(get_service_detail.service_company_id,1,1,0)#<cfelseif len(get_service_detail.service_employee_id)>#get_emp_pos.position_name#</cfif>" onfocus="AutoComplete_Create('member_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\',0,0,0','PARTNER_ID,COMPANY_ID,CONSUMER_ID,MEMBER_PARTNER_NAME2','partner_id,company_id,consumer_id,member_name','','3','250','return_member_code();info_comp(0,0)');" autocomplete="off">
									</div>
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
										<div class="input-group">
											<input type="text" name="member_name" id="member_name" value="#get_service_detail.applicator_name#" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2\',0,0,0<cfif is_notify_popup eq 1>,2,1,0,0,0,1</cfif>','PARTNER_ID,COMPANY_ID,CONSUMER_ID,MEMBER_NAME2<cfif is_notify_popup eq 1>,MEMBER_TYPE,WORKGROUP_EMP_ID,WORKGROUP_EMP_NAME</cfif>','partner_id,company_id,consumer_id,member_company<cfif is_notify_popup eq 1>,notify_app_type,notify_app_id,notify_app_name</cfif>','','3','250','return_member_code();info_comp(0,0)');"  autocomplete="off">
											<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='29514.Başvuru Yapan'>" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&is_period_kontrol=0&field_consumer=add_service.consumer_id&field_emp_id=add_service.employee_id&field_partner=add_service.partner_id&field_comp_id=add_service.company_id&field_comp_name=add_service.member_company<cfif is_notify_popup eq 1>&field_notify_app_type=add_service.notify_app_type&field_notify_app_id=add_service.notify_app_id&field_notify_app_name=add_service.notify_app_name</cfif>&field_pos_name=add_service.member_company&field_name=add_service.member_name&field_cons_code=add_service.member_company&select_list=7,8,9&function_name=info_comp&keyword='+encodeURIComponent(document.getElementById('member_company').value),'list');"></span>
										</div>
									</div>
							</div>
							<div class="form-group" id="item-notify_app_name">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='38725.Başvuruyu Bildiren'></label>
								<input type="hidden" name="notify_app_type" id="notify_app_type" value="<cfif len(get_service_detail.notify_employee_id)>employee<cfelseif len(get_service_detail.notify_partner_id)>partner<cfelseif len(get_service_detail.notify_consumer_id)>consumer</cfif>">
								<input type="hidden" name="notify_app_id" id="notify_app_id" value="<cfif len(get_service_detail.notify_partner_id)>#get_service_detail.notify_partner_id#<cfelseif len(get_service_detail.notify_consumer_id)>#get_service_detail.notify_consumer_id#</cfif>">
								<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
									<input type="text" name="notify_company_name" id="notify_company_name" value="<cfif len(get_service_detail.notify_partner_id)>#get_par_info(get_service_detail.notify_partner_id,0,1,0)#</cfif>">
								</div>
								<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
									<div class="input-group">
										<input type="text" name="notify_app_name" id="notify_app_name" value="<cfif len(get_service_detail.notify_partner_id)>#get_par_info(get_service_detail.notify_partner_id,0,-1,0)#<cfelseif len(get_service_detail.notify_consumer_id)>#get_cons_info(get_service_detail.notify_consumer_id,0,0)#<cfelseif len(get_service_detail.notify_employee_id)>#get_emp_info(get_service_detail.notify_employee_id,0,0)#</cfif>">
										<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='38725.Başvuruyu Bildiren'>" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&is_period_kontrol=0&field_id=add_service.notify_app_id&field_comp_name=add_service.notify_company_name&field_name=add_service.notify_app_name&field_type=add_service.notify_app_type&field_emp_id=add_service.notify_app_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,2,3','list');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-service_branch_id">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfinclude template="../query/get_branch.cfm">
									<select name="service_branch_id" id="service_branch_id">
										<option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
										<cfloop query="get_branch">
											<option value="#branch_id#" <cfif get_service_detail.service_branch_id eq branch_id> selected</cfif>>#branch_name#</option>
										</cfloop>
									</select>
								</div>
							</div>
							<div class="form-group" id="item-priority_id">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57485.Öncelik'> *</label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<select name="priority_id" id="priority_id">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfloop query="get_priority">
											<option value="#priority_id#" <cfif get_service_detail.priority_id eq priority_id>selected</cfif>>#priority#</option>
										</cfloop>
									</select>
								</div>
							</div>
							<div class="form-group" id="item-process">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"> *</label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cf_workcube_process is_upd='0' select_value='#get_service_detail.service_status_id#' process_cat_width='140' is_detail='1'>
								</div>
							</div>
							<div class="form-group" id="item-appcat_id">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'> *</label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<input type="hidden" name="old_appcat_id" id="old_appcat_id" value="#get_service_detail.servicecat_id#" >
									<select name="appcat_id" id="appcat_id" onchange="kategori_getir();">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfloop query="get_service_appcat">
											<option value="#get_service_appcat.servicecat_id#" <cfif get_service_detail.servicecat_id EQ servicecat_id>selected</cfif>>#get_service_appcat.servicecat#</option>
										</cfloop>
									</select>		
								</div>
							</div>
							<cfif x_is_sub_tree_single_select eq 1>
								<cfquery name="GET_SUB_QUERY" dbtype="query">
									SELECT SERVICE_SUB_CAT_ID,SERVICE_SUB_CAT,SERVICECAT_ID FROM GET_SERVICE_APPCAT_SUB 
									<cfif x_is_related_upper_cat><cfif isdefined("get_service_app_rows.servicecat_id") and len(get_service_app_rows.servicecat_id)>WHERE SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_app_rows.servicecat_id#"></cfif></cfif>
								</cfquery>
								<cfquery name="GET_SUB_TREE_QUERY" dbtype="query">
									SELECT SERVICE_SUB_CAT_ID,SERVICE_SUB_STATUS_ID,SERVICE_SUB_STATUS FROM GET_SERVICE_APPCAT_SUB_STATUS 
									<cfif x_is_related_upper_cat>WHERE SERVICE_SUB_CAT_ID <cfif len(get_service_app_rows.service_sub_cat_id)>= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_app_rows.service_sub_cat_id#"><cfelse>IS NULL</cfif></cfif>
								</cfquery>
						
								<div class="form-group" id="item-servicecat_sub_id">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31061.Alt Kategori'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<select name="servicecat_sub_id" id="servicecat_sub_id" onchange="rel_tree_cat(#get_service_app_rows.service_sub_cat_id#)&sub_kategori_getir();">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfloop query="get_sub_query">
												<option value="#service_sub_cat_id#" <cfif get_service_app_rows.service_sub_cat_id eq service_sub_cat_id>selected</cfif>>#service_sub_cat#</option>
											</cfloop>
										</select>
									</div>
								</div>
								<div class="form-group" id="item-servicecat_sub_tree_id">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='38732.Alt Tree Kategori'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<select name="servicecat_sub_tree_id" id="servicecat_sub_tree_id" onchange="rel_tree_cat(#get_service_app_rows.service_sub_cat_id#);">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfloop query="get_sub_tree_query">
												<option value="#service_sub_status_id#" <cfif get_service_app_rows.service_sub_status_id eq service_sub_status_id>selected</cfif>>#service_sub_status#</option>
											</cfloop>
										</select>
									</div>
								</div>
							</cfif>
							<div class="form-group" id="item-ComMethod_Id">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58143.İletişim'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cf_wrkComMethod width="140" ComMethod_Id="#get_service_detail.Commethod_Id#">
								</div>
							</div>
							<div class="form-group" id="item-ref_no">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58794.Referans No'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<input type="text" name="ref_no" id="ref_no" maxlength="50" value="<cfif isdefined('get_service_detail.ref_no') and len(get_service_detail.ref_no)>#get_service_detail.ref_no#</cfif>">
								</div>
							</div>
						</cfoutput>
					</div>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<cfoutput>
							<div class="form-group" id="item-apply_date">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='49292.Başvuru Tarihi'> *</label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12" id="form_ul_apply_date" extra_select="apply_hour,apply_minute">
									<cfif len(get_service_detail.apply_date)>
										<cfset adate=date_add("H",session.ep.time_zone,get_service_detail.apply_date)>
										<cfset ahour=datepart("H",adate)>
										<cfset aminute=datepart("N",adate)>
										<cfset apply_date_ = dateformat(date_add("H",session.ep.time_zone,get_service_detail.apply_date),dateformat_style)>
									<cfelse>
										<cfset adate="">
										<cfset ahour="">
										<cfset aminute="">
										<cfset apply_date_ = "">
									</cfif>
									<!--- 5 dk aralik verildigi icin BK 20120323 --->
									<cfif aminute gt 55>
										<cfset aminute = 55>
									<cfelseif (aminute mod 5) neq 0>
										<cfset aminute = aminute+(5-(aminute mod 5))>
									</cfif>
									<cfsavecontent variable="message_apply"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='49292.Başvuru Tarihi'>!</cfsavecontent>
									<cfif get_module_user(47)>
										<div class="col col-6 col-md-6 col-sm-6 col-xs-12" id="form_ul_apply_date" extra_select="apply_hour,apply_minute">
											<div class="input-group">
												<cfinput type="text" name="apply_date" id="apply_date" value="#apply_date_#" validate="#validate_style#" message="#message_apply#">
												<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="apply_date"></span>
											</div>
										</div>
										<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
											<cf_wrkTimeFormat name="apply_hour" id="apply_hour" value="#NumberFormat("#ahour#",00)#">
										</div>
										<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
											<select name="apply_minute" id="apply_minute">
												<cfloop from="0" to="55" step="5" index="app_min">
													<option value="#NumberFormat(app_min,00)#" <cfif aminute eq app_min>selected</cfif>>#NumberFormat(app_min,00)#</option>
												</cfloop>
											</select>
										</div>
									<cfelse>
										<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
											<cfinput type="text" name="apply_date" id="apply_date" value="#apply_date_#" validate="#validate_style#" readonly >
										</div>
										<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
											<select name="apply_hour" id="apply_hour" disabled>
												<cfloop from="0" to="23" index="app_hour">
													<option value="#NumberFormat(app_hour,00)#" <cfif app_hour eq ahour>selected</cfif>>#NumberFormat(app_hour,00)#</option>
												</cfloop>
											</select>
										</div>
										<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
											<select name="apply_minute" id="apply_minute" disabled>
												<cfloop from="0" to="55" step="5" index="app_min">
													<option value="#NumberFormat(app_min,00)#" <cfif aminute eq app_min>selected</cfif>>#NumberFormat(app_min,00)#</option>
												</cfloop>
											</select>
										</div>
										<input type="hidden" name="apply_hour" id="apply_hour" value="<cfoutput>#ahour#</cfoutput>" />
										<input type="hidden" name="apply_minute" id="apply_minute" value="<cfoutput>#aminute#</cfoutput>" />
									</cfif>
								</div>
							</div>
							<div class="form-group" id="item-start_date">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='49293.Kabul Tarihi'> *</label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12" id="form_ul_start_date1" extra_select="start_hour,start_minute">
									<div class="col col-6 col-md-6 col-sm-6 col-xs-12" >
										<div class="input-group">
											<cfif isdefined("get_service_detail.start_date") and len(get_service_detail.start_date)>
												<cfset sdate=date_add("H",session.ep.time_zone,get_service_detail.start_date)>
												<cfset shour=datepart("H",sdate)>
												<cfset sminute=datepart("N",sdate)>
												<cfset start_date_ = dateformat(date_add("H",session.ep.time_zone,get_service_detail.start_date),dateformat_style)>
											<cfelse>
												<cfset sdate="">
												<cfset shour="">
												<cfset sminute="">
												<cfset start_date_ = "">
											</cfif>
											<cfsavecontent variable="message_startdate"><cf_get_lang dictionary_id ='49206.Kabul Tarihi Girmelisiniz'></cfsavecontent>
											<cfinput type="text" name="start_date1" id="start_date1" value="#start_date_#" validate="#validate_style#" message="#message_startdate#">
											<cfif get_module_user(47)>
												<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date1"></span>
											</cfif>
										</div>
									</div>
									<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
										<cf_wrkTimeFormat name="start_hour" id="start_hour" value="#NumberFormat("#shour#",00)#">
									</div>
									<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
										<select name="start_minute" id="start_minute">
											<cfloop from="0" to="55" step="5" index="sta_min">
												<option value="#NumberFormat(sta_min,00)#" <cfif sta_min eq sminute>selected</cfif>>#NumberFormat(sta_min,00)#</option>
											</cfloop>
										</select>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-finish_date">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12" id="form_ul_finish_date1" extra_select="finish_hour,finish_minute">
									<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
										<div class="input-group">
											<cfif len(get_service_detail.finish_date)>
												<cfset fdate=date_add("h",session.ep.time_zone,get_service_detail.finish_date)>
												<cfset fhour=datepart("h",fdate)>
												<cfset fminute=datepart("N",fdate)>
												<cfset finish_date_ = dateformat(fdate,dateformat_style)>
											<cfelse>
												<cfset fdate="">
												<cfset fhour="">
												<cfset fminute="">
												<cfset finish_date_ = "">
											</cfif>
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
											<cfinput type="text" name="finish_date1" id="finish_date1" validate="#validate_style#" value="#finish_date_#" message="#message#">
											<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date1"></span> 
										</div>
									</div>
									<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
										<cf_wrkTimeFormat  name="finish_hour" id="finish_hour" value="#NumberFormat("#fhour#",00)#">
									</div>
									<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
										<select name="finish_minute" id="finish_minute">
											<cfloop from="0" to="55" step="5" index="fin_min">
												<option value="#NumberFormat(fin_min,00)#" <cfif fminute eq fin_min> selected</cfif>>#NumberFormat(fin_min,00)#</option>
											</cfloop>
										</select>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-responsible_person">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfif len(get_service_detail.resp_emp_id)>
											<cfset resp_emp_name = get_emp_info(get_service_detail.resp_emp_id,0,0)>
										<cfelseif len(get_service_detail.resp_par_id)>
											<cfset resp_emp_name = get_par_info(get_service_detail.resp_par_id,0,0,0)>
										<cfelseif len(get_service_detail.resp_cons_id)>
											<cfset resp_emp_name = get_cons_info(get_service_detail.resp_cons_id,0,0)>
										<cfelse>
											<cfset resp_emp_name = "">
										</cfif>
										<input type="hidden" name="resp_comp_id" id="resp_comp_id" value="<cfif len(get_service_detail.resp_comp_id)>#get_service_detail.resp_comp_id#<cfelse></cfif>">
										<input type="hidden" name="resp_par_id" id="resp_par_id" value="<cfif len(get_service_detail.resp_par_id)>#get_service_detail.resp_par_id#<cfelse></cfif>">
										<input type="hidden" name="resp_cons_id" id="resp_cons_id" value="<cfif len(get_service_detail.resp_cons_id)>#get_service_detail.resp_cons_id#<cfelse></cfif>">
										<input type="hidden" name="resp_emp_id" id="resp_emp_id" value="<cfif len(get_service_detail.resp_emp_id)>#get_service_detail.resp_emp_id#<cfelse></cfif>">
										<cfinput type="text" name="resp_emp_name" id="resp_emp_name" value="#resp_emp_name#" onFocus="AutoComplete_Create('resp_emp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',0,0','COMPANY_ID,PARTNER_ID,CONSUMER_ID,EMPLOYEE_ID','resp_comp_id,resp_par_id,resp_cons_id,resp_emp_id','','3','160');">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_name=add_service.resp_emp_name&field_emp_id=add_service.resp_emp_id&field_consumer=add_service.resp_cons_id&field_partner=add_service.resp_par_id&field_comp_id=add_service.resp_comp_id&select_list=1,7,8','list');" title="<cf_get_lang dictionary_id='57544.Sorumlu'>"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-project_head">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="project_id" id="project_id" value="#get_service_detail.project_id#">
										<input name="project_head" type="text" id="project_head" value="<cfif len(get_service_detail.project_id)>#get_project_name(get_service_detail.project_id)#</cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','165');" autocomplete="off">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=add_service.project_id&project_head=add_service.project_head');" title="<cf_get_lang dictionary_id='57416.Proje'>"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-url">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42371.link'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<input name="url" type="text" id="url" value="<cfif isdefined('get_service_detail.fuseaction') and len(get_service_detail.fuseaction)>#get_service_detail.fuseaction#</cfif>">
										<span class="input-group-addon btnPointer icon-link" onclick="<cfif isdefined('get_service_detail.FULL_URL') and len(get_service_detail.FULL_URL)>loc('#listlast(get_service_detail.FULL_URL,'_')#')<cfelseif isdefined('get_service_detail.fuseaction') and len(get_service_detail.fuseaction)>loc('#request.self#?fuseaction=#get_service_detail.fuseaction#')</cfif>"></span>
										<span class="input-group-addon btnPointer catalyst-info" onclick="<cfif isdefined('get_service_detail.FULL_URL') and len(get_service_detail.FULL_URL)>loc('#listfirst(get_service_detail.FULL_URL,'_')#')<cfelseif isdefined('get_service_detail.fuseaction') and len(get_service_detail.fuseaction)>loc('#request.self#?fuseaction=dev.wo&event=upd&fuseact=#get_service_detail.fuseaction#&woid=#get_woid.WRK_OBJECTS_ID#&Calls')</cfif>"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-camp_name">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57446.Kampanya'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfif len(get_service_detail.campaign_id)>
											<cfquery name="GET_CAMP_INFO" datasource="#DSN3#">
												SELECT CAMP_ID,CAMP_HEAD FROM CAMPAIGNS WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.campaign_id#">
											</cfquery>
										<cfelse>
											<cfset get_camp_info.camp_head = ''>
										</cfif>
										<input type="hidden" name="camp_id" id="camp_id" value="#get_service_detail.campaign_id#">
										<input type="text" name="camp_name" id="camp_name" value="#get_camp_info.camp_head#">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_campaigns&field_id=add_service.camp_id&field_name=add_service.camp_name','list');" title="<cf_get_lang dictionary_id='57446.Kampanya'>"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-subscription_no">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29502.Sistem No'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfif len(get_service_detail.subscription_id)>					
											<cfoutput>	
													<cfset attributes.subscription_id = get_service_detail.subscription_id>					 	
													<cfquery name="GET_SUBSCRIPTION" datasource="#DSN3#">
														SELECT SUBSCRIPTION_NO,SUBSCRIPTION_HEAD FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID IS NOT NULL AND SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
													</cfquery>
													<input type="hidden" name="subscription_id" id="subscription_id" value="#get_service_detail.subscription_id#" />
													<!---<input type="text" name="subscription_head" id="subscription_head" value="<cfif len(get_service_detail.subscription_id)>#get_subscription.subscription_no# - #get_subscription.subscription_head#</cfif>" />--->
													<input type="text" name="subscription_head" id="subscription_head" onfocus="AutoComplete_Create('subscription_head','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,MEMBER_NAME','get_subscription','1','SUBSCRIPTION_ID,COMPANY_ID,FULLNAME,MEMBER_ID,MEMBER_TYPE,MEMBER_NAME','subscription_id,company_id,company_name,member_id,member_type,member_name','','3','164');" autocomplete="off" value="<cfif len(get_service_detail.subscription_id)>#get_subscription.subscription_no# - #get_subscription.subscription_head#</cfif>" /> 
													<cfset str_subscription_link="field_project_id=add_service.project_id&field_project_name=add_service.project_head&field_consumer=add_service.consumer_id&field_partner=add_service.partner_id&field_id=add_service.subscription_id&field_head=add_service.subscription_head&field_member_name=add_service.member_name&field_company_id=add_service.company_id&field_company_name=add_service.member_company">
													<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_subscription&#str_subscription_link#','list','popup_list_subscription');" title="<cf_get_lang dictionary_id='29502.Sistem NO'>"></span>
													<a href="javascript://" class="input-group-addon btnPointer icon-question" onclick="call_sub_id()" title="<cf_get_lang dictionary_id='30003.Aboneler'>"></a>
											</cfoutput>
										<cfelse>
											<input type="hidden" name="subscription_id" id="subscription_id" value="<cfif isdefined("attributes.subscription_id")>#attributes.subscription_id#</cfif>">
											<input type="text" name="subscription_head" id="subscription_head" value="<cfif isdefined("attributes.subscription_head")>#attributes.subscription_head#</cfif>"  onfocus="AutoComplete_Create('subscription_head','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','get_subscription','2','SUBSCRIPTION_ID','subscription_id','','3','200');" autocomplete="off">
											<cfset str_subscription_link="field_project_id=add_service.project_id&field_project_name=add_service.project_head&field_consumer=add_service.consumer_id&field_partner=add_service.partner_id&field_id=add_service.subscription_id&field_head=add_service.subscription_head&field_member_name=add_service.member_name&field_company_id=add_service.company_id&field_company_name=add_service.member_company">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_subscription&#str_subscription_link#','list','popup_list_subscription');" title="<cf_get_lang dictionary_id='29502.Sistem No'>"></span>
											<a href="javascript://" class="input-group-addon btnPointer icon-question" onclick="call_sub_id()" title="<cf_get_lang dictionary_id='30003.Aboneler'>"></a>
										</cfif>
									</div>
								</div>
							</div>
						</cfoutput>
					</div>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<cfif x_is_sub_tree_single_select eq 0><!--- bu neden Kaldırılmış--->
							<cfoutput query="get_service_appcat" group="servicecat_id">
								<cfquery name="GET_SERVICE_APPCAT_SUB_ORD" dbtype="query">
									SELECT SERVICE_SUB_CAT_ID,SERVICE_SUB_CAT,SERVICECAT_ID FROM GET_SERVICE_APPCAT_SUB WHERE SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_appcat.servicecat_id#">
								</cfquery>
								<div class="row" id="anakategori_#servicecat_id#" style="#iif(get_service_detail.servicecat_id eq serviceCAT_ID , DE('display:block;') , DE('display:none;'))#">
									<div class="form-group"><label class="col col-12 bold">#servicecat#</label></div>
								<cfoutput>
									<cfloop query="get_service_appcat_sub_ord">
										<cfquery name="GET_SERVICE_APPCAT_SUB_STATUS_ORD" dbtype="query">
											SELECT SERVICE_SUB_STATUS_ID,SERVICE_SUB_CAT_ID,SERVICE_SUB_STATUS FROM GET_SERVICE_APPCAT_SUB_STATUS WHERE SERVICE_SUB_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_appcat_sub_ord.service_sub_cat_id#">
										</cfquery>
										<div class="form-group" id="form_ul_service_sub_cat_id_#service_sub_cat_id#">
											<label class="col col-4 col-md-4 col-sm-4 col-xs-12">#service_sub_cat#</label>
											<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
												<div class="input-group">
													<select name="service_sub_cat_id_#service_sub_cat_id#" id="service_sub_cat_id_#service_sub_cat_id#"onchange="rel_tree_cat(#service_sub_cat_id#);">
														<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
														<cfloop query="get_service_appcat_sub_status_ord">
															<option value="#get_service_appcat_sub_ord.service_sub_cat#,#service_sub_status_id#" <cfif listfindnocase(app_rows,service_sub_status_id,',')>selected</cfif>>#service_sub_status#</option>
														</cfloop>
													</select>
													<cfif x_is_mail_send_tree_list eq 1>
														<span class="input-group-addon btnPointer catalyst-list bold"  onclick="send_tree_mail(#service_sub_cat_id#);" title="<cf_get_lang dictionary_id='49300.Gönderi Listesi'>"></span>
													<cfelse>
														<span class="input-group-addon btnPointer catalyst-list bold"  onclick="windowopen('#request.self#?fuseaction=call.popup_sub_cat_people&service_sub_cat_id=#service_sub_cat_id#&branch_id='+document.getElementById('service_branch_id').value,'medium');" title="<cf_get_lang dictionary_id='49300.Gönderi Listesi'>"></span>
													</cfif>
												</div>
											</div>
										</div>
									</cfloop>
									</div>
								</cfoutput>
							</cfoutput>
						</cfif>
					</div>
				</cf_box_elements>
				<cf_box_elements vertical="1">
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="4" sort="true">
					<cfoutput>
						<div class="form-group" id="item-service_head">
							<label class="col col-12"><cf_get_lang dictionary_id='57480.Konu'> *</label>
							<div class="col col-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57480.Konu'>!</cfsavecontent>
								<cfinput type="text" name="service_head" id="service_head" value="#get_service_detail.service_head#" required="yes" maxlength="50" message="#message#">
							</div>
						</div>
						<div class="form-group" id="item-service_head">
							<label class="col col-12"><cf_get_lang dictionary_id='57629.Açıklama'> *</label>
							<div class="col col-12">
								<cfmodule
								template="/fckeditor/fckeditor.cfm"
								toolbarset="Basic"
								basepath="/fckeditor/"
								instancename="service_detail"
								valign="top"
								value="#get_service_detail.service_detail#"
								width="600"
								height="300">
							</div>
						</div>
						<cfset subject = replace(get_service_detail.service_HEAD,'"','','all')>
					</cfoutput>
					</div>
				</cf_box_elements>
				<div class="ui-form-list-btn">
					<div class="col col-6 col-xs-12">
						<cf_record_info 
							query_name="get_service_detail"
							record_emp="RECORD_MEMBER" 
							record_date="record_date"
							is_partner='1'
							update_emp="UPDATE_MEMBER"
							update_date="update_date">
					</div>
					<div class="col col-6 col-xs-12">
						<cf_workcube_buttons is_upd='1' is_delete='1' add_function='chk_form()' delete_page_url="#request.self#?fuseaction=call.emptypopup_del_service&service_id=#attributes.service_id#">
					</div>
				</div>  
		</cf_box> 
		<cfif len(get_service_detail.service_company_id)>
			<cfset attributes.company_id = get_service_detail.service_company_id>
			<cfelse>
			<cfset attributes.consumer_id = get_service_detail.service_consumer_id>
		</cfif>
		<!--- Takipler --->
		<cfinclude template="dsp_service_plus.cfm">
		<!---İlişkili İçerikler--->
		<cf_get_workcube_content action_type ='SERVICE_ID' action_type_id ='#attributes.service_id#' design='1' company_id='#session.ep.company_id#' keyword='#keyword#'>
		<cfsavecontent variable="message"><cf_get_lang dictionary_id='58020.İşler'></cfsavecontent>
		<cfsavecontent variable="service_str">
			<cfoutput><cfif isDefined("attributes.g_service_id")>&g_service_id=#attributes.g_service_id#<cfelseif isDefined("attributes.service_id")>&service_id=#attributes.service_id#<cfelseif isDefined("attributes.opp_id")>&opp_id=#attributes.opp_id#</cfif></cfoutput>
		</cfsavecontent>
			
			<!--- burada xml degerinin kontrolünü yapıp ona göre add gönderilecek--->
			<!--- Isler --->
			<cf_box id="main_news_menu"
				title="#message#"
				add_href="javascript:openBoxDraggable('#request.self#?fuseaction=project.works&event=add&work_fuse=objects.emptypopup_ajax_project_works&id=#get_service_detail.project_id##iif(isdefined("attributes.work_detail_id") and attributes.work_detail_id eq 0,DE("&work_detail_id=0"),DE(""))##iif(isDefined("attributes.project_id") and Len(attributes.project_id),DE("&id=##attributes.project_id##"),DE(""))##iif(isDefined("attributes.forum_reply_id"),DE("&forum_reply_id=##attributes.forum_reply_id##"),DE(""))##service_str#','','ui-draggable-box-large');"
				box_page="#request.self#?fuseaction=objects.emptypopup_ajax_project_works&g_service_id=#attributes.service_id#&project_id=#get_service_detail.project_id#"
				closable="0">
			</cf_box>     
		<!--- 	<cfinclude template="../display/list_company_services.cfm">	 --->
	</div>
	<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
		<!--- Uye Bilgileri --->
		<cfinclude template="upd_service_sag.cfm">
		<!--- <cfinclude template="../display/list_service_history_ic.cfm"> --->
			
	</div>
</cfform>
<script type="text/javascript">
	$(window).load(function(){if($('#display_detail'))$('#form').after( $('#display_detail') );});
	var x_is_related_tree_cat = '<cfoutput>#x_is_related_tree_cat#</cfoutput>';
	var x_is_mail_send_tree_list = '<cfoutput>#x_is_mail_send_tree_list#</cfoutput>';
	var x_is_sub_tree_single_select = '<cfoutput>#x_is_sub_tree_single_select#</cfoutput>';

	var tree_category_list = "";
	if(document.getElementById('old_app_rows').value != "")
		tree_category_list = document.getElementById('old_app_rows').value;
	function call_sub_id(){
		subscription_id = document.getElementById("subscription_id").value;
		if(subscription_id != ''){
			window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=sales.list_subscription_contract&event=upd&subscription_id='+subscription_id,'_blank');
		}else{
			alert("<cf_get_lang dictionary_id = '41400.Abone seçiniz'>!");
		}
	}
	function info_comp(member_id,type)
	{
		document.getElementById('resp_emp_id').value='';
		document.getElementById('resp_emp_name').value='';
		if(member_id==0)
		{
			if(document.getElementById('partner_id').value!='')
			{
				member_id=document.getElementById('company_id').value;
				type=1;
			}
			else if(document.getElementById('consumer_id').value!='')
			{
				member_id=document.getElementById('consumer_id').value;
				type=2;
			}
		}
		if(type == 1)
		{
			get_info_sales=wrk_query("select SZ_NAME,RESPONSIBLE_POSITION_CODE from SALES_ZONES,COMPANY where SALES_ZONES.SZ_ID=COMPANY.SALES_COUNTY AND COMPANY.COMPANY_ID=" + member_id,"dsn");
		}
		else if(type == 2)
		{
			get_info_sales=wrk_query("select SZ_NAME,RESPONSIBLE_POSITION_CODE from SALES_ZONES,CONSUMER where SALES_ZONES.SZ_ID=CONSUMER.SALES_COUNTY AND CONSUMER.CONSUMER_ID=" + member_id,"dsn");
		}
		if(get_info_sales.recordcount)
		{
			// SATIŞ BÖLGESİNİN YÖNETİCİSİ SORUMLU KISMINA ATANIYOR
			get_info_manager=wrk_query("SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE="+get_info_sales.RESPONSIBLE_POSITION_CODE,"dsn");
			document.getElementById('resp_emp_id').value=get_info_manager.EMPLOYEE_ID;
			document.getElementById('resp_emp_name').value=get_info_manager.EMPLOYEE_NAME +' '+get_info_manager.EMPLOYEE_SURNAME;
		}
	}
	
	//gorevli alt tree kategoriye bagli olsun secilirse tree_idlerini gondermek icin FS
	function rel_tree_cat(ssci)
	{
		<cfif isdefined('x_is_multiple_select') and x_is_multiple_select eq 0 and isdefined("x_is_sub_tree_single_select") and x_is_sub_tree_single_select eq 0>
			if(document.getElementById('temp_service_sub_cat_id').value != '')
			{
				var temp_sel = document.getElementById('temp_service_sub_cat_id').value;
				document.getElementById('service_sub_cat_id_'+temp_sel).value ="";
			}
			if(ssci != undefined)
			document.getElementById('temp_service_sub_cat_id').value = parseInt(ssci);
			else
			document.getElementById('temp_service_sub_cat_id').value = '';	
		</cfif>
		tree_category_list = "";
		<cfif x_is_sub_tree_single_select neq 1>
			<cfoutput query="get_service_appcat" group="servicecat_id">
				<cfquery name="GET_SERVICE_APPCAT_SUB_ORD" dbtype="query">
					SELECT SERVICE_SUB_CAT_ID,SERVICE_SUB_CAT,SERVICECAT_ID FROM GET_SERVICE_APPCAT_SUB WHERE SERVICECAT_ID = #get_service_appcat.servicecat_id#
				</cfquery>
				<cfoutput>
				<cfloop query="get_service_appcat_sub_ord">
					
					if(document.getElementById('service_sub_cat_id_#service_sub_cat_id#').value != "")
					{
						tree_category_list = tree_category_list  + (document.getElementById('service_sub_cat_id_#service_sub_cat_id#').value)+ ",";
					}
				</cfloop>
				</cfoutput>
			</cfoutput>
		<cfelse>
			if(document.getElementById('servicecat_sub_tree_id').value != "")
				tree_category_list = tree_category_list  + document.getElementById('servicecat_sub_tree_id').value + ",";
		</cfif>
	}
	
	//gorevli linkinlerini ve zorunluluklarini kontrol ediyor yukardaki fonksiyonla baglantili FS
	function tree_gonder(link_no,work_id)
	{
		if(x_is_related_tree_cat == 1 && tree_category_list == "")
		{
			alert("<cf_get_lang dictionary_id='49197.Kategori / Alt Tree Kategori Seçmelisiniz'>!");
			return false;
		}
		else if(x_is_related_tree_cat == 1 && link_no == 1 && tree_category_list != "")
		{
			windowopen('<cfoutput>#request.self#?fuseaction=project.works&event=add<cfif isDefined("attributes.related_project_info")>&id=#project_detail.project_id#</cfif>&work_fuse=#attributes.fuseaction#<cfif isDefined("attributes.g_service_id")>&g_service_id=#attributes.service_id#<cfelseif isDefined("attributes.service_id")>&service_id=#attributes.service_id#<cfelseif isDefined("attributes.opp_id")>&opp_id=#attributes.opp_id#</cfif></cfoutput>&process_date='+document.getElementById('start_date1').value+'&tree_category_id='+tree_category_list,'list');
		}
		// proje listesinde kayit donerse girecek bu kosula yoksa current_work bulunamiyor haliyle FS
		else if(x_is_related_tree_cat == 1 && link_no == 2 && tree_category_list != "")
		{
			windowopen('<cfoutput>#request.self#?fuseaction=project.works&event=det&id='+work_id+'&process_date='+document.getElementById('start_date1').value+'</cfoutput>&tree_category_id='+tree_category_list,'project');
		}
		else if(x_is_related_tree_cat == 1 && link_no == 3 && tree_category_list != "")
		{
			windowopen('<cfoutput>#request.self#?fuseaction=project.works&event=add<cfif isDefined("attributes.related_project_info")>&id=#project_detail.project_id#</cfif><cfif isdefined("current_work.work_id")>&work_id=#current_work.work_id#</cfif>&work_fuse=#attributes.fuseaction#<cfif isDefined("attributes.g_service_id")>&g_service_id=#attributes.service_id#<cfelseif isDefined("attributes.service_id")>&service_id=#attributes.service_id#<cfelseif isDefined("attributes.opp_id")>&opp_id=#attributes.opp_id#</cfif></cfoutput>&process_date='+document.getElementById('start_date1').value+'&tree_category_id='+tree_category_list,'list');
		}
	}
	
	<cfif x_is_mail_send_tree_list eq 1 and x_is_sub_tree_single_select eq 0>
	//gonderi listesi alt tree kategoriden gelsin secilirse FS
		function send_tree_mail(xx)
		{
			service_sub_status_id_ = list_getat(eval("document.getElementById('service_sub_cat_id_"+xx+"')").value,2,',');
			if(service_sub_status_id_ == "")
			{
				alert("<cf_get_lang dictionary_id='49198.Önce Alt Tree Kategori Seçmelisiniz'>!");
				return false;
			}
			else
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=call.popup_sub_status_people&service_sub_status_id='+service_sub_status_id_+'&branch_id='+document.getElementById('service_branch_id').value,'medium');
		}
	</cfif>
	
	//kategori secimine gore alt kategorileri getirir
	function kategori_getir()
	{
		category_value = document.getElementById('appcat_id').value;
		<cfif x_is_sub_tree_single_select neq 1>
			if(category_value != '')
			{
				<cfoutput query="get_service_appcat">
					gizle(anakategori_#servicecat_id#);
				</cfoutput>
				goster(eval('anakategori_' + category_value));
			}
			else
			{
				<cfoutput query="get_service_appcat">
					gizle(anakategori_#servicecat_id#);
				</cfoutput>		
			}
		<cfelse>
			if(category_value != '')
			{
				<cfif x_is_related_upper_cat>
					var get_sub_category = wrk_safe_query('clcr_get_sub_category','dsn',0,category_value);	
				<cfelse>
					var get_sub_category = wrk_safe_query('clcr_get_sub_category','dsn',0,'');	
				</cfif>			
				var option_count = document.getElementById('servicecat_sub_id').options.length; 
				for(x=option_count;x>=0;x--)
					document.getElementById('servicecat_sub_id').options[x] = null;
				
				document.getElementById('servicecat_sub_id').options[0] = new Option('<cf_get_lang dictionary_id='57734.Seçiniz'>','');
				for(sc=0;sc<get_sub_category.recordcount;sc++)
					document.getElementById('servicecat_sub_id').options[sc+1]=new Option(get_sub_category.SERVICE_SUB_CAT[sc],get_sub_category.SERVICE_SUB_CAT_ID[sc]);
				return sub_kategori_getir();
			}
			else
			{
				var option_count = document.getElementById('servicecat_sub_id').options.length; 
				for(x=option_count;x>=0;x--)
					document.getElementById('servicecat_sub_id').options[x] = null;
				document.getElementById('servicecat_sub_id').options[0] = new Option('<cf_get_lang dictionary_id='57734.Seçiniz'>','');
				
				// kategori secilmediginde alt tree kategoriyi de bosaltmasi lazim
				return sub_kategori_getir()
			}
		</cfif>
	}
	//alt kategori secimine gore alt tree kategorileri getirir
	<cfif x_is_sub_tree_single_select eq 1>
	function sub_kategori_getir()
	{
		if(document.getElementById('servicecat_sub_id').value!= '')
		{
			<cfif x_is_related_upper_cat>
				var get_sub_tree_category = wrk_safe_query('clcr_get_sub_tree_category','dsn',0,document.getElementById('servicecat_sub_id').value);
			<cfelse>
				var get_sub_tree_category = wrk_safe_query('clcr_get_sub_tree_category','dsn',0,'');
			</cfif>
			var option_count_sub = document.getElementById('servicecat_sub_tree_id').options.length; 
			for(y=option_count_sub;y>=0;y--)
				document.getElementById('servicecat_sub_tree_id').options[y] = null;
					
			document.getElementById('servicecat_sub_tree_id').options[0] = new Option('<cf_get_lang dictionary_id='57734.Seçiniz'>','');
			for(stc=0;stc<get_sub_tree_category.recordcount;stc++)
				document.getElementById('servicecat_sub_tree_id').options[stc+1]=new Option(get_sub_tree_category.SERVICE_SUB_STATUS[stc],get_sub_tree_category.SERVICE_SUB_STATUS_ID[stc]);
		}
		else
		{
			var option_count_sub = document.getElementById('servicecat_sub_tree_id').options.length; 
			for(y=option_count_sub;y>=0;y--)
				document.getElementById('servicecat_sub_tree_id').options[y] = null;
			document.getElementById('servicecat_sub_tree_id').options[0] = new Option('<cf_get_lang dictionary_id='57734.Seçiniz'>','');
		}
	}
	</cfif>
	
	function loc(url){
		window.open(url, '_blank');
	}
	function chk_form()
	{
		if(document.getElementById('member_name').value=="")
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='29514.Başvuru Yapan'>");
			return false;
		}
		if(document.getElementById('priority_id').value=="")
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='49298.Öncelik Kategorisi'>");
			return false;
		}
		if(document.getElementById('appcat_id').value=="")
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57486.Kategori'>");
			return false;
		}
		if(document.getElementById('start_date1').value=="")
		{
			alert("<cf_get_lang dictionary_id ='49206.Kabul Tarihi Girmelisiniz'>");
			return false;
		}
		if(document.getElementById('apply_date').value=="")
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='31362.Başvuru Tarihi'>!");
			return false;
		}

		var service_detail = CKEDITOR.instances.service_detail.getData();
		var service_detail_= service_detail.replace(/<[^>]+>/g, '');
		if (service_detail_.length <= 10 )
		{ 
			alert ("<cf_get_lang dictionary_id='57425.uyarı'>:<cf_get_lang dictionary_id='57629.açıklama'><cf_get_lang dictionary_id='49304.En Az 10 Karakter'>!");
			return false;
		}

		if (document.getElementById('start_date1') != undefined && document.getElementById('apply_date') != undefined && document.getElementById('start_date1').value !='' && document.getElementById('apply_date').value !='')
		{
			if (!time_check(document.getElementById('apply_date'), document.getElementById('apply_hour'), document.getElementById('apply_minute'), document.getElementById('start_date1'), document.getElementById('start_hour'), document.getElementById('start_minute'),"<cf_get_lang dictionary_id='49301.Başvuru Tarihi Kabul Tarihinden Önce Olmalıdır'>!"))
			return false;
		}
		if (document.getElementById('start_date1') != undefined && document.getElementById('finish_date1') != undefined && document.getElementById('start_date1').value !='' && document.getElementById('finish_date1').value !='')
		{
			if (!time_check(document.getElementById('start_date1'), document.getElementById('start_hour'), document.getElementById('start_minute'), document.getElementById('finish_date1'), document.getElementById('finish_hour'), document.getElementById('finish_minute'), "<cf_get_lang dictionary_id='49242.Başvuru Başlangıç Tarihi Bitiş Tarihinden Önce Olmalıdır'>!"))
			return false;
		} 
		if (document.getElementById('apply_date') != undefined && document.getElementById('finish_date1') != undefined && document.getElementById('apply_date').value !='' && document.getElementById('finish_date1').value !='')
		{
			if (!time_check(document.getElementById('apply_date'), document.getElementById('apply_hour'), document.getElementById('apply_minute'), document.getElementById('finish_date1'), document.getElementById('finish_hour'), document.getElementById('finish_minute'), "<cf_get_lang dictionary_id ='49219.Başvuru Tarihi Bitiş Tarihinden Önce Olmalıdır'>!"))
			return false;
		} 
		//document.getElementById('apply_hour').disabled = false;
		//document.getElementById('apply_minute').disabled = false;		
		return process_cat_control();
	}

	function return_member_code()
	{
		var consumer_id=document.getElementById('consumer_id').value;
		if(consumer_id!='')
		{
			get_consumer=wrk_safe_query('clcr_get_consumer','dsn',0,consumer_id);
			document.getElementById('member_company').value=get_consumer.MEMBER_CODE;
		}
		else
			return false;
	}
	function open_apply(url,id) {
		document.getElementById(id).style.display ='';	
		document.getElementById(id).style.width ='500px';	
		$("#"+id).css('margin-left',$("#tabMenu").position().left);
		$("#"+id).css('margin-top',$("#tabMenu").position().top);
		$("#"+id).css('position','absolute');	
		
		AjaxPageLoad(url,id,1);
		return false;
	}
</script>
