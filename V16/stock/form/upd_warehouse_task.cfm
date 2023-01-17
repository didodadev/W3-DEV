<cfset multi_doc_companies = "44">
<cfif isdefined("attributes.is_end")>
	<cfinclude template="../query/end_warehouse_task.cfm">
<cfelseif isdefined("attributes.is_dlt")>
	<cfinclude template="../query/del_warehouse_task.cfm">
<cfelseif isdefined("attributes.is_active")>
	<cfinclude template="../query/active_warehouse_task.cfm">
<cfelseif isdefined("attributes.is_ups")>
	<cfinclude template="../query/ups_warehouse_task.cfm">
<cfelseif isdefined("attributes.is_ups_void")>
	<cfinclude template="../query/void_ups_warehouse_task.cfm">
<cfelseif isdefined("attributes.is_create_result")>
	<cfinclude template="../query/create_result_warehouse_task.cfm">	
<cfelseif isdefined("attributes.is_submit")>
	<cfinclude template="../query/upd_warehouse_task.cfm">
<cfelse>
	<cfscript>
		if(isdefined("session.ep.userid"))
			get_warehouse_tasks_action = createObject("component", "v16.stock.cfc.get_warehouse_tasks");
		else
			get_warehouse_tasks_action = createObject("component", "cfc.get_warehouse_tasks");
        get_warehouse_tasks_action.dsn3 = dsn3;
        get_warehouse_tasks_action.dsn_alias = dsn_alias;
        get_warehouse_task = get_warehouse_tasks_action.get_warehouse_task_fnc(
			 task_id : '#attributes.task_id#'
		);
	</cfscript>
	
	<cfif isdefined("session.pp.userid") and get_warehouse_task.company_id neq session.pp.company_id>
		<cf_get_lang dictionary_id="59953.Sayfayı Görmek İçin Yetkiniz Yok">
		<cfexit method="exittemplate">
	</cfif>
	
	<cfif get_warehouse_task.warehouse_in_out eq 0 and not listfind(multi_doc_companies,get_warehouse_task.company_id)>
		<cfset one_document_no = 1>
	<cfelse>
		<cfset one_document_no = 0>
	</cfif>
	
	<cfquery name="get_rates" datasource="#dsn3#">
		SELECT 
			WRR.WAREHOUSE_TASK_TYPE_ID,
			WRR.RATE_CODE,
			#dsn#.Get_Dynamic_Language(WTT.WAREHOUSE_TASK_TYPE_ID,'#session.ep.language#','WAREHOUSE_TASK_TYPES','WAREHOUSE_TASK_TYPE',NULL,NULL,WTT.WAREHOUSE_TASK_TYPE) AS WAREHOUSE_TASK_TYPE,
			WTT.WAREHOUSE_TASK_TYPE_ORDER,
			WRR.RATE_INFO,
			ISNULL((SELECT ROW_AMOUNT FROM WAREHOUSE_TASKS_ROWS WTR WHERE WTR.WAREHOUSE_TASK_TYPE_ID = WRR.WAREHOUSE_TASK_TYPE_ID AND WTR.RATE_CODE = WRR.RATE_CODE AND WTR.TASK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.task_id#">),0) AS ROW_AMOUNT
		FROM
			WAREHOUSE_RATES WR,
			WAREHOUSE_RATES_ROWS WRR,
			#dsn_alias#.WAREHOUSE_TASK_TYPES WTT
		WHERE 
			WRR.WAREHOUSE_TASK_TYPE_ID = WTT.WAREHOUSE_TASK_TYPE_ID AND
			WR.RATE_ID = WRR.RATE_ID AND
			WR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_warehouse_task.company_id#"> AND
			WR.ACTION_DATE < #NOW()#
			<cfif get_warehouse_task.warehouse_in_out eq 1>
				AND WTT.IS_SHIPMENT = 1
			</cfif>
			<cfif get_warehouse_task.warehouse_in_out eq 0>
				AND WTT.IS_RECEIVING = 1
			</cfif>
			<cfif get_warehouse_task.warehouse_in_out eq 2 or get_warehouse_task.warehouse_in_out eq 3>
				AND WTT.WAREHOUSE_TASK_TYPE_ID IS NULL
			</cfif>
		ORDER BY
			WTT.WAREHOUSE_TASK_TYPE_ORDER ASC
	</cfquery>
	
	<cfquery name="get_actions" datasource="#dsn3#">
		SELECT * FROM WAREHOUSE_TASKS_ACTIONS WHERE TASK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.task_id#">
	</cfquery>
	
	<cfquery name="get_products" datasource="#dsn3#">
		SELECT 
			*,
			ISNULL((SELECT TOP 1 MULTIPLIER FROM PRODUCT_UNIT WHERE ADD_UNIT = 'Pallet' AND MULTIPLIER IS NOT NULL AND MULTIPLIER <> '' AND PRODUCT_ID = WAREHOUSE_TASKS_PRODUCTS.PRODUCT_ID),1) AS PALLET_MIKTAR 
		FROM 
			WAREHOUSE_TASKS_PRODUCTS WHERE TASK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.task_id#">
	</cfquery>
	<cfquery name="get_companies" datasource="#dsn#">
		SELECT 
			C.ASSET_FILE_NAME2,
			C.NICKNAME,
			C.COMPANY_ID 
		FROM 
			COMPANY C,
			#dsn3_alias#.WAREHOUSE_RATES WR
		WHERE 
			WR.COMPANY_ID IS NOT NULL AND
			C.COMPANY_ID = WR.COMPANY_ID AND
			C.COMPANY_STATUS = 1
	</cfquery>

	<cfquery name="get_company_products" datasource="#dsn3#">
		SELECT 
			S.*,
			PC.PRODUCT_CAT,
			ISNULL((SELECT MULTIPLIER FROM PRODUCT_UNIT WHERE ADD_UNIT = 'Pallet' AND MULTIPLIER IS NOT NULL AND MULTIPLIER <> '' AND PRODUCT_ID = S.PRODUCT_ID),1) AS PALLET_MIKTAR
		FROM 
			STOCKS S,
			#dsn1_alias#.PRODUCT P,
			PRODUCT_CAT PC
		WHERE
			S.PRODUCT_ID = P.PRODUCT_ID AND
			S.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_warehouse_task.company_id#"> AND
			S.PRODUCT_CATID = PC.PRODUCT_CATID
		ORDER BY
			PC.PRODUCT_CAT,
			S.PRODUCT_NAME
	</cfquery>

	<cfif isdefined("session.ep.userid")>
		<cfif get_warehouse_task.is_active neq -2 and len(get_warehouse_task.record_par)>
			<cfset cr = "CR - ">
		<cfelse>
			<cfset cr="">
		</cfif>
		<cfif get_warehouse_task.is_active eq 0>
			<cfset pageHead = "#getlang('','Depo İşlemleri',45369)#: "&cr&"#getlang('','main',48943)#">
		<cfelseif get_warehouse_task.is_active eq -1>
			<cfset pageHead = "#getlang('','Depo İşlemleri',45369)#: "&cr&"#getlang('','main',57704)#">
		<cfelseif get_warehouse_task.is_active eq -2>
			<cfset pageHead = "#getlang('','Depo İşlemleri',45369)#: "&cr&"#getlang('','main',63848)#">
		<cfelseif get_warehouse_task.is_active eq 1>
			<cfset pageHead = "#getlang('','Depo İşlemleri',45369)#: "&cr&"#getlang('','main',58699)#">
		</cfif>
		<cf_catalystHeader>
	<cfelse>
		<cfoutput><div style="text-align:right;"><a href="javascript://" onclick="windowopen('index.cfm?fuseaction=objects.popup_print_files&action_id=#attributes.task_id#&print_type=1002','page');"><img src="/images/print.gif"></a></div></cfoutput>
	</cfif>
	<cf_box>
	<cfform name="add_packet_ship" id="add_packet_ship" method="post" action="#request.self#?fuseaction=stock.list_warehouse_tasks&event=upd">
		<input type="hidden" name="is_submit" id="is_submit" value="1">
		<cfinput type="hidden" name="task_id" id="task_id" value="#attributes.task_id#">
	<cf_box_elements>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
							<cfif isdefined("session.ep.userid")>
							<div class="form-group" id="item-process_cat" style="display:none;">
								<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"> *</label>
								<div class="col col-9 col-xs-12"><cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'></div>
							</div>
							</cfif>
							<div class="form-group" id="item-task_in_out" style="display:none;">
								<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'> *</label>
								<div class="col col-9 col-xs-12">
									<select name="task_in_out">
										<option value="0" <cfif get_warehouse_task.warehouse_in_out eq 0>selected</cfif>><cf_get_lang dictionary_id="63877.Receiving"></option>
										<option value="1" <cfif get_warehouse_task.warehouse_in_out eq 1>selected</cfif>><cf_get_lang dictionary_id="63876.Shipment"></option>
										<option value="2" <cfif get_warehouse_task.warehouse_in_out eq 2>selected</cfif>><cf_get_lang dictionary_id="63874.Sayım Sonucu"></option>
										<option value="3" <cfif get_warehouse_task.warehouse_in_out eq 3>selected</cfif>><cf_get_lang dictionary_id="63875.Sayım"></option>
									</select>
								</div>
							</div>							
							<div class="form-group" id="item-company">
								<label class="col col-12 col-xs-12">
									<b>
									<cfif get_warehouse_task.warehouse_in_out eq 0>
										<cf_get_lang dictionary_id="63877.Receiving">
									<cfelseif  get_warehouse_task.warehouse_in_out eq 3>
										<cf_get_lang dictionary_id="63875.Sayım">
									<cfelseif  get_warehouse_task.warehouse_in_out eq 2>
									<cf_get_lang dictionary_id="63874.Sayım Sonucu">
									<cfelse>
										<cf_get_lang dictionary_id="63876.Shipment">
									</cfif>
								</b>
								</label>
							</div>

								<div class="form-group" id="item-companies">
									<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57519.Cari Hesap"></label>
									<div class="col col-9 col-xs-12">
											<select id="company_id" name="company_id" style="width:150px;">
												<cfoutput><option value="#get_warehouse_task.company_id#">#get_warehouse_task.NICKNAME#</option></cfoutput>
											</select>
									</div>
								</div>
								<div class="form-group" id="item_project_head">
									<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57416.Proje"></label>
									<div class="col col-9 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="project_id" id="project_id" value="<cfif len(get_warehouse_task.project_id)><cfoutput>#get_warehouse_task.project_id#</cfoutput></cfif>">
											<input type="text" name="project_head" id="project_head" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','125');" value="<cfoutput>#get_warehouse_task.project_head#</cfoutput>" autocomplete="off">
											<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=add_packet_ship.project_head&project_id=add_packet_ship.project_id</cfoutput>');"></span>
										</div>
									</div>
								</div>
							<cfif isdefined("session.ep.userid")>
							<div class="form-group" id="item-location_id">
								<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="58763.Depo"> *</label>
								<div class="col col-9 col-xs-12">
										<cf_wrkdepartmentlocation
											returnInputValue="location_id,department_name,department_id,branch_id"
											returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
											fieldName="department_name"
											fieldid="location_id"
											department_fldId="department_id"
											branch_fldId="branch_id"
											department_id="#get_warehouse_task.DEPARTMENT_ID#"
											location_id="#get_warehouse_task.LOCATION_ID#"
											DEPARTMENT_name="#get_warehouse_task.DEPARTMENT_HEAD#"
											user_level_control="#session.ep.our_company_info.is_location_follow#"
											width="150">
								</div>
							</div>
							</cfif>
							<div class="form-group" id="item-action_date">
								<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57742.Tarih"></label>
								<div class="col col-9 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id="57742.Tarih"> !</cfsavecontent>
										<cfinput type="text" name="action_date" id="action_date" validate="#validate_style#" required="Yes" message="#message#" style="width:65px;" value="#dateformat(get_warehouse_task.action_date,dateformat_style)#">
										<cfoutput>
											<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="action_date"></span>
										</cfoutput>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-employee_id">
								<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57576.Çalışan"></label>
								<div class="col col-9 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_warehouse_task.employee_id#</cfoutput>">
										<input type="text" name="employee_name" id="employee_name" value="<cfoutput>#get_emp_info(get_warehouse_task.employee_id,0,0)#</cfoutput>" readonly style="width:150px;">
										<cfif isdefined("session.ep.userid")>
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id2=add_packet_ship.employee_id&field_name=add_packet_ship.employee_name&select_list=1','list');"></span>
										</cfif>
									</div>
								</div>
							</div>
							<cfif get_warehouse_task.warehouse_in_out eq 3>
							<div class="form-group" id="item-container">
								<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="63871.Sayım Tipi"></label>
								<div class="col col-9 col-xs-12">
										<select name="count_type" style="width:150px;">
											<option value="0" <cfif get_warehouse_task.count_type eq 0>selected</cfif>><cf_get_lang dictionary_id="63880.All Items"></option>
											<option value="1" <cfif get_warehouse_task.count_type eq 1>selected</cfif>><cf_get_lang dictionary_id="63881.Selected Items"></option>
											<option value="2" <cfif get_warehouse_task.count_type eq 2>selected</cfif>><cf_get_lang dictionary_id="63882.Add Items to Inventory"></option>
											<option value="3" <cfif get_warehouse_task.count_type eq 3>selected</cfif>><cf_get_lang dictionary_id="63883.Label Only"></option>
										</select>
								</div>
							</div>
							</cfif>
							<div class="form-group" id="item-container" style="<cfif get_warehouse_task.warehouse_in_out eq 1>display:none;</cfif>">
								<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='63850.Konteyner'></label>
								<div class="col col-9 col-xs-12">
										<cfinput type="text" name="container" id="container" value="#get_warehouse_task.container#" style="width:150px;"/>
								</div>
							</div>
							<div class="form-group" id="item-bl_number" style="<cfif get_warehouse_task.warehouse_in_out eq 0>display:none;</cfif>">
								<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='63851.B/L No'></label>
								<div class="col col-9 col-xs-12">
										<cfinput type="text" name="bl_number" id="bl_number" value="#get_warehouse_task.bl_number#" style="width:150px;"/>
								</div>
							</div>
							<div class="form-group" id="item-detail">
								<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57422.Notlar"></label>
								<div class="col col-9 col-xs-12">
										<cftextarea type="text" name="detail" id="detail" value="#get_warehouse_task.DETAIL#" style="width:150px;" rows="3"/>
								</div>
							</div>
							<cfif get_warehouse_task.warehouse_in_out eq 1>
								<div class="form-group" id="item-employee_id">
									<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57716.Taşıyıcı"></label>
									<div class="col col-9 col-xs-12">
											<cfinput type="text" name="CARRIER_NAME" id="CARRIER_NAME" value="#get_warehouse_task.CARRIER_NAME#" style="width:150px;"/>
									</div>
								</div>
								<div class="form-group" id="item-employee_id">
									<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="63861.Özel Talimatlar"></label>
									<div class="col col-9 col-xs-12">
											<cfinput type="text" name="SPECIAL_INS" id="SPECIAL_INS" value="#get_warehouse_task.SPECIAL_INS#" style="width:150px;"/>
									</div>
								</div>
								<div class="form-group" id="item-employee_id">
									<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="63862.Navlun Ücreti Şartları"></label>
											<label class="col col-3"><cf_get_lang dictionary_id="63863.Ön Ödemeli"> <input type="radio" value="1" name="FREIGHT" <cfif get_warehouse_task.FREIGHT eq 1>checked</cfif>></label>
											<label class="col col-3"><cf_get_lang dictionary_id="63864.Ödemeli"> <input type="radio" value="2" name="FREIGHT" <cfif get_warehouse_task.FREIGHT eq 2>checked</cfif>></label>
											<label class="col col-3"><cf_get_lang dictionary_id="63865.3. Şahıs"> <input type="radio" value="3" name="FREIGHT" <cfif get_warehouse_task.FREIGHT eq 3>checked</cfif>></label>
								</div>
							</cfif>
							<cfif one_document_no eq 1>
								<input type="hidden" name="document_count" value="1">
								<div class="form-group" id="item-document-no">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="40830.Satınalma Siparişi"><cf_get_lang dictionary_id="44867.Numarası"></label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">											
											<cfinput type="text" name="document_no_1" value="#get_products.action_no#" style="width:150px;">
											<span class="input-group-addon"></span>
										</div>
									</div>
								</div>
							</cfif>
						</div>
						<cfif get_warehouse_task.warehouse_in_out eq 1>
						<cfoutput>
						<div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="2" sort="true">
							<div class="form-group" id="item-company">
								<label class="col col-12 col-xs-12">
									<b><cf_get_lang dictionary_id="60308.Gönderici"></b>
								</label>
							</div>
							<div id="cargo_sender_information">							
								<div class="form-group" id="item-document-no">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57574.Şirket"></label>
									<div class="col col-8 col-xs-12">										
											<input type="text" name="CARGO_MYCOMPANY" value="#get_warehouse_task.CARGO_MYCOMPANY#" style="width:150px;">
									</div>
								</div>
								<div class="form-group" id="item-document-no">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="44592.İsim"></label>
									<div class="col col-8 col-xs-12">							
											<input type="text" name="CARGO_MYNAME" value="#get_warehouse_task.CARGO_MYNAME#" style="width:150px;">
									</div>
								</div>
								<div class="form-group" id="item-document-no">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58723.Adres"></label>
									<div class="col col-8 col-xs-12">					
											<input type="text" name="CARGO_MYADDRESS" value="#get_warehouse_task.CARGO_MYADDRESS#" style="width:150px;">
									</div>
								</div>
								<div class="form-group" id="item-document-no">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57499.Telefon"></label>
									<div class="col col-8 col-xs-12">					
											<input type="text" name="CARGO_MYPHONE" value="#get_warehouse_task.CARGO_MYPHONE#" style="width:150px;">
									</div>
								</div>
								<div class="form-group" id="item-document-no">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57472.Posta Kodu"></label>
									<div class="col col-8 col-xs-12">							
											<input type="text" name="CARGO_MYPOSTCODE" value="#get_warehouse_task.CARGO_MYPOSTCODE#" style="width:150px;">
									</div>
								</div>
								<div class="form-group" id="item-document-no">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="52661.Şehir"></label>
									<div class="col col-8 col-xs-12">							
											<input type="text" name="CARGO_MYCOUNTY" value="#get_warehouse_task.CARGO_MYCOUNTY#" style="width:150px;">
									</div>
								</div>
								<div class="form-group" id="item-document-no">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="44806.Devlet"></label>
									<div class="col col-8 col-xs-12">							
											<input type="text" name="CARGO_MYCITY" value="#get_warehouse_task.CARGO_MYCITY#" style="width:150px;">
									</div>
								</div>
							</div>
						</div>	
							<div class="col col-3">
							<div class="form-group" id="item-company">
								<label class="col col-12 col-xs-12">
									<b><cf_get_lang dictionary_id="58733.Alıcı"></b>
								</label>
							</div>
							<div class="form-group" id="item-document-no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="63891.Sold To"></label>
								<div class="col col-8 col-xs-12">		
										<input type="text" name="CARGO_SHIP_RELATED_NUMBER" value="#get_warehouse_task.CARGO_SHIP_RELATED_NUMBER#" style="width:150px;">
								</div>
							</div>
							<div class="form-group" id="item-document-no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="63892.Sold To Zipcode"></label>
								<div class="col col-8 col-xs-12">										
										<input type="text" name="CARGO_SHIP_RELATED_POSTCODE" value="#get_warehouse_task.CARGO_SHIP_RELATED_POSTCODE#" style="width:150px;">
								</div>
							</div>
							<div class="form-group" id="item-ship">
								<label class="col col-12 col-xs-12">
									<b><cf_get_lang dictionary_id="35958.Teslimat Bilgileri"></b>
								</label>
							</div>
							<div class="form-group" id="item-document-no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="63893.Ship To"></label>
								<div class="col col-8 col-xs-12">						
										<input type="text" name="CARGO_SHIP_COMPANY" value="#get_warehouse_task.CARGO_SHIP_COMPANY#" style="width:150px;">
							
								</div>
							</div>
							<div class="form-group" id="item-document-no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="63894.Ship To Attention"></label>
								<div class="col col-8 col-xs-12">					
										<input type="text" name="CARGO_SHIP_NAME" value="#get_warehouse_task.CARGO_SHIP_NAME#" style="width:150px;">
								</div>
							</div>
							<div class="form-group" id="item-document-no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="63895.Ship To Address"></label>
								<div class="col col-8 col-xs-12">					
										<input type="text" name="CARGO_SHIP_ADDRESS" value="#get_warehouse_task.CARGO_SHIP_ADDRESS#" style="width:150px;">
								</div>
							</div>
							<div class="form-group" id="item-document-no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="63896.Ship To Phone"></label>
								<div class="col col-8 col-xs-12">				
										<input type="text" name="CARGO_SHIP_PHONE" value="#get_warehouse_task.CARGO_SHIP_PHONE#" style="width:150px;">
								</div>
							</div>
							<div class="form-group" id="item-document-no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="63897.Ship To PostCode"></label>
								<div class="col col-8 col-xs-12">					
										<input type="text" name="CARGO_SHIP_POSTCODE" value="#get_warehouse_task.CARGO_SHIP_POSTCODE#" style="width:150px;">
								</div>
							</div>
							<div class="form-group" id="item-document-no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="63898.Ship To City"></label>
								<div class="col col-8 col-xs-12">				
										<input type="text" name="CARGO_SHIP_COUNTY" value="#get_warehouse_task.CARGO_SHIP_COUNTY#" style="width:150px;">
								</div>
							</div>
							<div class="form-group" id="item-document-no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="63899.Ship To State"></label>
								<div class="col col-8 col-xs-12">
										<input type="text" name="CARGO_SHIP_CITY" value="#get_warehouse_task.CARGO_SHIP_CITY#" style="width:150px;">
								</div>
							</div>
							<cfif get_warehouse_task.is_active eq -1 and len(get_warehouse_task.CARGO_SHIP_POSTCODE) and len(get_warehouse_task.CARGO_SHIP_COMPANY)>
								<div class="form-group" id="item-document-no">
									<label class="col col-4 col-xs-12"></label>
									<div class="col col-8 col-xs-12">
											<cfif not len(get_warehouse_task.cargo_code)>			
												<input type="button" class="ui-wrk-btn ui-wrk-btn-success" onclick="send_to_cargo('ups');" value="<cf_get_lang dictionary_id='64010.Send to Ups'>">
											<cfelse>
												<cfloop list="#get_warehouse_task.cargo_code#" index="c_code">
													<input type="button" onclick="send_to_cargo_info('ups');" value="#c_code#">
												</cfloop>
											</cfif>
									</div>
								</div>
							</cfif>
						</div>
						</cfoutput>
						</cfif>
						<div class="col col-2 col-md-2 col-sm-2 col-xs-12" type="column" index="2" sort="true">
							<cfif isdefined("get_rates") and get_rates.recordcount>
								<label>
									<b><cf_get_lang dictionary_id="39892.Services"></b>
								</label>
									<input type="hidden" name="rate_code_list" value="<cfoutput>#valuelist(get_rates.rate_code)#</cfoutput>">
									<cfoutput query="get_rates">
										<div class="form-group" id="item-services">
											
													<label class="col col-4">#WAREHOUSE_TASK_TYPE#</label>
													<input type="hidden" name="rate_type_id_#rate_code#" value="#WAREHOUSE_TASK_TYPE_ID#">
													<div class="col col-8 col-xs-12">
													<select name="rate_row_#rate_code#">
														<cfloop from="0" to="100" index="i">
															<option value="#i#" <cfif ROW_AMOUNT eq i>selected</cfif>>#i#</option>
														</cfloop>
													</select>
												</div>
											</div>
									</cfoutput>
										<div class="form-group" id="item-services">
											<label class="col col-4"><cf_get_lang dictionary_id="58156.Diğer"></label>
												<div class="col col-5"><cfinput type="text" name="other_detail" id="other_detail" value="#get_warehouse_task.EXTRA_DETAIL#">									
												</div><div class="col col-3">
												<select name="other_amount">
													<cfloop from="0" to="100" index="i">
														<cfoutput><option value="#i#" <cfif get_warehouse_task.EXTRA_AMOUNT eq i>selected</cfif>>#i#</option></cfoutput>
													</cfloop>
												</select>
											</div>
										</div>
							</cfif>
						</div>
					</cf_box_elements>
					<cf_seperator title="#getlang('','ITEMS','63900')#" id="items" is_closed="0">
						<div id="items">
						<cfif get_products.recordcount gt 50>
							<cfset p_count = get_products.recordcount + 5>
						<cfelseif get_warehouse_task.warehouse_in_out eq 1>
							<cfset p_count = get_products.recordcount + 5>
						<cfelse>
							<cfset p_count = get_products.recordcount + 5>
						</cfif>
						<cfif one_document_no eq 0><cfinput type="hidden" name="document_count" value="#p_count#"></cfif>
						<cfinput type="hidden" name="product_count" value="#p_count#">
						<cf_grid_list>
						<thead>
							<tr>
								<cfif one_document_no eq 0><th width="200"><cf_get_lang dictionary_id="40830.Satınalma Siparişi"><cf_get_lang dictionary_id="44867.Numarası"></th></cfif>
								<th width="150"><cf_get_lang dictionary_id="57657.Ürün"></th>
								<th width="50"><cf_get_lang dictionary_id="57635.Miktar"></th>
									<th width="50">
										<cfif session.ep.language eq 'tr'>
										<cf_get_lang dictionary_id="37244.Palet">/<cf_get_lang dictionary_id="48312.Koli"><br>
										<cf_get_lang dictionary_id="63866.Başına"><cf_get_lang dictionary_id="57635.Miktar"> 
										<cfelse>
											<cf_get_lang dictionary_id="57635.Miktar"> 
												<cf_get_lang dictionary_id="63866.Başına"> 
											<br><cf_get_lang dictionary_id="37244.Palet">/<cf_get_lang dictionary_id="48312.Koli">
										</cfif>
									</th>
								<th width="50"><cf_get_lang dictionary_id="57492.Toplam"> <br><cf_get_lang dictionary_id="37244.Palet">/<cf_get_lang dictionary_id="48312.Koli"></th>
								<th width="60"></th>
								<th width="80"><cf_get_lang dictionary_id="48383.Ebat"></th>
								<th width="80"><cf_get_lang dictionary_id="63867.Koli Tipi"></th>
								<th width="50"><cf_get_lang dictionary_id="58585.Kod"></th>
								<th width="50"><cf_get_lang dictionary_id="29784.Ağırlık"></th>
								<th width="75"><cf_get_lang dictionary_id="63868.Boyut"></th>
								<th width="50"><cf_get_lang dictionary_id="63869.Batch No"></th>

							</tr>
						</thead>
						<cfloop from="1" to="#p_count#" index="aa">
						<cfoutput>
							<cfif get_products.recordcount gte aa and get_products.amount[aa] neq 0>
								<cfset product_amount_ = get_products.amount[aa]>
								<cfif len(get_products.pallet_amount[aa])>
									<cfset pallet_amount_ = get_products.pallet_amount[aa]>
								<cfelse>
									<cfset pallet_amount_ = get_products.PALLET_MIKTAR[aa]>
								</cfif>
								<cfif pallet_amount_ gt 0>
									<cfset total_pallet_amount_ = ceiling(product_amount_ / pallet_amount_)>
								<cfelse>
									<cfset total_pallet_amount_ = 0>
								</cfif>
							<cfelse>
								<cfset product_amount_ = 0>
								<cfset pallet_amount_ = 0>
								<cfset total_pallet_amount_ = 0>
							</cfif>
							<tr>
								<cfif one_document_no eq 0>
									<td>
									<cfif get_products.recordcount gte aa>
										<input type="text" name="document_no_#aa#" value="#get_products.action_no[aa]#" style="width:200px;">
									<cfelse>
										<input type="text" name="document_no_#aa#" value="" style="width:200px;">
									</cfif>
									</td>
								</cfif>
								<td>
									<cfset r_stock_id = iif(get_products.recordcount gte aa,de("#get_products.stock_id[aa]#"),de(""))>
									<div class="form-group">
										<div class="input-group">
											<input type="hidden" name="product_id_#aa#"  id="product_id_#aa#" value="<cfif r_stock_id eq get_company_products.stock_id>#get_company_products.product_id#-#get_company_products.stock_id#-#get_company_products.pallet_miktar#</cfif>">
											<input type="text" readonly name="urun_#aa#"  id="urun_#aa#" value="<cfif r_stock_id eq get_company_products.stock_id>#get_company_products.product_name#</cfif>">
											<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac(#aa#);"></span>
										</div>
									</div>
								</td>
								<td><cfinput type="text" name="product_amount_#aa#" value="#tlformat(product_amount_,0)#" style="width:50px;" onkeyup="return(FormatCurrency(this,event,0,'float'));" onblur="hesapla_pallet('#aa#');"></td>
								<td><cfinput type="text" name="pallet_amount_#aa#" value="#tlformat(pallet_amount_,0)#" style="width:50px;" onkeyup="return(FormatCurrency(this,event,0,'float'));" onblur="hesapla_pallet('#aa#');"></td>
								<td><cfinput type="text" name="total_pallet_#aa#" value="#tlformat(total_pallet_amount_,0)#" readonly="yes" style="width:50px;"></td>
								<td>
									<div class="form-group">
									<select name="total_unit_type_#aa#" id="unit_type_#aa#">
										<option value="Pallet" <cfif get_products.total_unit_type[aa] is 'Pallet'>selected</cfif>><cf_get_lang dictionary_id="37244.Palet"></option>
										<option value="Box" <cfif get_products.total_unit_type[aa] is 'Box'>selected</cfif>><cf_get_lang dictionary_id="48312.Koli"></option>
										<option value="Piece" <cfif get_products.total_unit_type[aa] is 'Piece'>selected</cfif>><cf_get_lang dictionary_id="45.Parça"></option>
										<option value="Roll" <cfif get_products.total_unit_type[aa] is 'Roll'>selected</cfif>><cf_get_lang dictionary_id="63870.Rulo"></option>
									</select>
								</div>
								</td>
								<td>
									<div class="form-group">
									<select name="size_style_#aa#" id="size_style_#aa#">
										<option value="1" <cfif get_products.size_style[aa] is '1'>selected</cfif>><cf_get_lang dictionary_id="56109.Standart"></option>
										<option value="2" <cfif get_products.size_style[aa] is '2'>selected</cfif>><cf_get_lang dictionary_id="63856.Büyük Boy"></option>
									</select>
								</div>
								</td>
								<td>
									<div class="form-group">
									<select name="box_style_#aa#" id="box_style_#aa#">
										<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
										<option value="1" <cfif get_products.box_style[aa] is '1'>selected</cfif>><cf_get_lang dictionary_id="63884.OverBox"> </option>
										<option value="2" <cfif get_products.box_style[aa] is '2'>selected</cfif>><cf_get_lang dictionary_id="63885.ImageBox"> </option>
									</select>
								</div>
								</td>
								<td><cfinput type="text" name="pallet_code_#aa#" value="#get_products.pallet_code[aa]#" style="width:50px;">
								<cfinput type="hidden" name="box_code_#aa#" value="#get_products.box_code[aa]#" style="width:50px;">
								</td>
								<td><cfinput type="text" name="weight_#aa#" value="#get_products.weight[aa]#" style="width:50px;"></td>
								<td><cfinput type="text" name="dimension_#aa#" value="#get_products.dimension[aa]#" style="width:75px;"></td>
								<td><cfinput type="text" name="product_info_#aa#" value="#get_products.product_info[aa]#" style="width:100px;"></td>
		
							</tr>
						</cfoutput>
						</cfloop>
						</cf_grid_list>
					</div>
					
				<cf_box_footer> 
						<cfif isdefined("session.ep.userid")>
							<cf_record_info query_name="get_warehouse_task" is_partner="1">
							<cfif get_warehouse_task.warehouse_in_out neq 2>
								<cfif get_warehouse_task.is_active eq 0>
									<cf_workcube_buttons 
										is_upd='0' 
										add_function='control()' 
										delete_page_url='#request.self#?fuseaction=stock.list_warehouse_tasks&event=upd&task_id=#attributes.task_id#&is_active=1' 
										delete_info='#getlang('','Aktif Et','63858')#' 
										delete_alert='#getlang('','Aktif Et','63858')# ?'
										is_insert='0'
										>
								<cfelseif get_warehouse_task.is_active eq -1 or get_warehouse_task.is_active eq -2>
									<cf_workcube_buttons 
										is_upd='0'
										add_function='control()'
										delete_info="#getlang('','İptal Et','51468')#"
										delete_page_url='#request.self#?fuseaction=stock.list_warehouse_tasks&event=upd&task_id=#attributes.task_id#&is_dlt=1'>
									<cf_workcube_buttons 
										is_upd='0'
										is_insert='0'
										delete_info='#getlang('','Süreci Onayla','63857')#'
										delete_alert='#getlang('','Süreci Onayla','63857')# ?'
										delete_page_url='#request.self#?fuseaction=stock.list_warehouse_tasks&event=upd&task_id=#attributes.task_id#&is_end=1'>
								<cfelseif get_warehouse_task.is_active eq 1>
									<cfif get_warehouse_task.warehouse_in_out eq 3 and get_warehouse_task.count_type neq 3>
										<cfif len(get_warehouse_task.related_task_id)>
											<cf_workcube_buttons
											extrainfo="#getlang('','Sonuçlandırıldı','63889')#"
											extraButton="1"
											extraButtonText="#getlang('','Tekrar Sonuçlandır','63888')# "
											extraAlert="#getlang('','Tekrar','63888')# ?"
											extraFunction="create_result()"
											is_upd='0'
											add_function='control()'
											is_insert='0'
											delete_info="#getlang('','İptal Et','51468')#"
											delete_alert="#getlang('','İptal Et','51468')# ?"
											delete_page_url='#request.self#?fuseaction=stock.list_warehouse_tasks&event=upd&task_id=#attributes.task_id#&is_dlt=1'>
										<cfelse>
											<cf_workcube_buttons
											extraButton="1"
											extraButtonText="#getlang('','Sonuçlandır','63887')#"
											extraAlert="#getlang('','Sonuçlandır','63887')# ?"
											extraFunction="create_result()"
											is_upd='0'
											add_function='control()'
											is_insert='0'
											delete_page_url='#request.self#?fuseaction=stock.list_warehouse_tasks&event=upd&task_id=#attributes.task_id#&is_dlt=1'>
										</cfif>
									<cfelse>
										<cf_workcube_buttons
										is_upd='0'
										add_function='control()'
										is_insert='0'
										delete_info="#getlang('','İptal Et','51468')#"
										delete_alert="#getlang('','İptal Et','51468')# ?"
										delete_page_url='#request.self#?fuseaction=stock.list_warehouse_tasks&event=upd&task_id=#attributes.task_id#&is_dlt=1'>
									</cfif>				
								</cfif>
							</cfif>
						</cfif>
					</cf_box_footer> 
	</cfform>
</cf_box>
	<script type="text/javascript">
		$('.disabledButtons').hide();
		
		function control()
		{
			return true;
		}
		
		function end_control()
		{
			window.location.href = '<cfoutput>#request.self#?fuseaction=stock.list_warehouse_tasks&event=upd&task_id=#attributes.task_id#&is_end=1</cfoutput>';
			return false;
		}
		function set_pallet(row)
		{
			deger_ = list_getat(document.getElementById('product_id_' + row).value,3,'-');
			document.getElementById('pallet_amount_' + row).value = deger_;
			
			/* if(deger_ != '')
			{
				product_id_ = list_getat(document.getElementById('product_id_' + row).value,1,'-');
				p_info_	= wrk_safe_query('get_p_dimensions','dsn3',1,product_id_);
				
				if(p_info_.WEIGHT != '')
					document.getElementById('weight_' + row).value = wrk_round(p_info_.WEIGHT);
				else
					document.getElementById('weight_' + row).value = '';
					
				if(p_info_.DIMENTION != '')
				{
					document.getElementById('dimension_' + row).value = p_info_.DIMENTION;
				}
				else
				{
					document.getElementById('dimension_' + row).value = '';
				}
			}
			else
			{
				document.getElementById('weight_' + row).value = '';
				document.getElementById('dimension_' + row).value = '';
			} */
			document.getElementById('weight_' + row).value = '';
				document.getElementById('dimension_' + row).value = '';
		}

		function hesapla_pallet(row)
		{	
			if(document.getElementById('product_id_' + row).value != '')
			{
				g_p_deger_ = list_getat(document.getElementById('product_id_' + row).value,3,'-');
				
				deger_ = filterNum(document.getElementById('product_amount_' + row).value);
				p_deger_ = filterNum(document.getElementById('pallet_amount_' + row).value);
				
				if(deger_ == '')
				{
					document.getElementById('pallet_amount_' + row).value = '';
					document.getElementById('total_pallet_' + row).value = '';
				}
				else if(deger_ != '' && p_deger_ == '')
				{
					document.getElementById('pallet_amount_' + row).value = commaSplit(g_p_deger_,0);
					document.getElementById('total_pallet_' + row).value = commaSplit(Math.ceil(deger_ / g_p_deger_),0);
				}
				else
				{
					document.getElementById('total_pallet_' + row).value = commaSplit(Math.ceil(deger_ / p_deger_),0);
					if(parseFloat(deger_) > 0 && parseFloat(deger_) < parseFloat(p_deger_))
					{
						document.getElementById('pallet_amount_' + row).value = commaSplit(deger_,0);
						document.getElementById('total_pallet_' + row).value = 1;
					}
				}
			}
			else
			{
				document.getElementById('pallet_amount_' + row).value = '';
				document.getElementById('total_pallet_' + row).value = '';
				document.getElementById('product_amount_' + row).value = '';
				
				document.getElementById('product_id_' + row).focus();
			}
		}
		
		function send_to_cargo(type)
		{
			if(confirm('<cf_get_lang dictionary_id="64034.Are you sure send to cargo">?'))
			{
				window.location.href='<cfoutput>#request.self#?fuseaction=stock.list_warehouse_tasks&event=upd&task_id=#attributes.task_id#&is_ups=1</cfoutput>';
			}
			else
			{
				return false;
			}
		}
		
		function send_to_cargo_info(type)
		{
			window.location.href='<cfoutput>#request.self#?fuseaction=stock.list_warehouse_tasks&event=upd&task_id=#attributes.task_id#&is_ups=1</cfoutput>';
		}
		
		function pencere_ac(no)
			{
				if(add_packet_ship.company_id.value != '')
				openBoxDraggable("<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&3pl=1&rows="+no+"&company_id="+add_packet_ship.company_id.value+"&product_id=add_packet_ship.product_id_"+no+"&field_name=add_packet_ship.urun_"+no);
				else
				alert("<cf_get_lang dictionary_id='33557.Cari Hesap Seçmelisiniz'>!");
			}

		function create_result()
		{
			window.location.href='<cfoutput>#request.self#?fuseaction=stock.list_warehouse_tasks&event=upd&task_id=#attributes.task_id#&is_create_result=1</cfoutput>';
		}
		
	</script>
</cfif>