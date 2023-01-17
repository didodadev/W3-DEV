<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
	<cf_xml_page_edit fuseact="stock.detail_multi_packetship">
	<cfinclude template="../query/get_moneys.cfm">
	<cfinclude template="../query/get_package_type.cfm">
	<cfif isdefined("attributes.is_logistic") and len(attributes.is_logistic)>
		<cfquery name="ADD_LOGISTIC" datasource="#DSN2#">
			SELECT
				1 MEMBER_TYPE,
				C.COMPANY_ID MEMBER_ID,
				S.LOCATION,
				S.COMPANY_ID,
				S.PARTNER_ID,
				S.CONSUMER_ID,
				S.SHIP_ID,
				S.SHIP_NUMBER,
				(SELECT ORDER_NUMBER FROM #dsn3_alias#.ORDERS WHERE ORDER_ID = OS.ORDER_ID) ORDER_NUMBER,
				S.SHIP_DATE,
				S.SHIP_METHOD,
				S.ADDRESS,
				S.ORDER_ID,
				S.DELIVER_STORE_ID,
				S.IS_DISPATCH,
				(SELECT DEPARTMENT_HEAD FROM  #dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = S.DELIVER_STORE_ID) AS DEPARTMENT_HEAD,
				C.FULLNAME MEMBER_NAME,
				C.NICKNAME MEMBER_NAME2
			FROM 
				SHIP S,
				#dsn_alias#.COMPANY C,
				#dsn3_alias#.ORDERS_SHIP OS
			WHERE
				OS.ORDER_ID IN (<cfqueryparam value="#attributes.is_logistic#" cfsqltype="cf_sql_integer" list="true">) AND
				OS.SHIP_ID = S.SHIP_ID AND
				OS.PERIOD_ID = <cfqueryparam value="#session.ep.period_id#" cfsqltype="cf_sql_integer"> AND
				S.COMPANY_ID = C.COMPANY_ID
	
			UNION ALL
			
			SELECT
				2 MEMBER_TYPE,
				C.CONSUMER_ID MEMBER_ID,
				S.LOCATION,
				S.COMPANY_ID,
				S.PARTNER_ID,
				S.CONSUMER_ID,
				S.SHIP_ID,
				S.SHIP_NUMBER,
				(SELECT ORDER_NUMBER FROM #dsn3_alias#.ORDERS WHERE ORDER_ID = OS.ORDER_ID) ORDER_NUMBER,
				S.SHIP_DATE,
				S.SHIP_METHOD,
				S.ADDRESS,
				S.ORDER_ID,
				S.DELIVER_STORE_ID,
				S.IS_DISPATCH,
				(SELECT DEPARTMENT_HEAD FROM #dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = S.DELIVER_STORE_ID) AS DEPARTMENT_HEAD,
				C.CONSUMER_NAME + ' '+ C.CONSUMER_SURNAME MEMBER_NAME,
				C.CONSUMER_NAME + ' '+ C.CONSUMER_SURNAME MEMBER_NAME2
			FROM
				SHIP S,
				#dsn_alias#.CONSUMER C,
				#dsn3_alias#.ORDERS_SHIP OS
			WHERE
				OS.ORDER_ID IN (<cfqueryparam value="#attributes.is_logistic#" cfsqltype="cf_sql_integer" list="true">) AND
				OS.SHIP_ID = S.SHIP_ID AND
				OS.PERIOD_ID = <cfqueryparam value="#session.ep.period_id#" cfsqltype="cf_sql_integer"> AND
				S.CONSUMER_ID = C.CONSUMER_ID
			ORDER BY
				MEMBER_TYPE,
				MEMBER_ID
		</cfquery>
	
		<cfquery name="GET_CONTROL_" dbtype="query">
			SELECT SHIP_NUMBER FROM ADD_LOGISTIC WHERE IS_DISPATCH = 1
		</cfquery>
		
		<!--- Tasiyici bilgileri icin --->
		<cfquery name="GET_COMPANY_SEVK" datasource="#DSN#">
			SELECT 
				TRANSPORT_COMP_ID,
				TRANSPORT_DELIVER_ID,
				SHIP_METHOD_ID
			FROM 
				COMPANY_CREDIT 
			WHERE 
			<cfif add_logistic.member_type[1] eq 1>
				COMPANY_ID = <cfqueryparam value="#add_logistic.member_id[1]#" cfsqltype="cf_sql_integer"> AND
			<cfelse>
				CONSUMER_ID = <cfqueryparam value="#add_logistic.member_id[1]#" cfsqltype="cf_sql_integer"> AND
			</cfif>
				OUR_COMPANY_ID = <cfqueryparam value="#session.ep.company_id#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfif get_company_sevk.recordcount>
			<cfset attributes.transport_comp_id = get_company_sevk.transport_comp_id>
			<cfset attributes.transport_deliver_id = get_company_sevk.transport_deliver_id>
			<cfif len(get_company_sevk.ship_method_id)>
				<cfquery name="GET_SHIP_METHOD_" datasource="#DSN#">
					SELECT SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID = #get_company_sevk.ship_method_id#
				</cfquery>
				<cfif get_ship_method_.recordcount>
					<cfset attributes.ship_method_id = get_company_sevk.ship_method_id>
					<cfset attributes.ship_method_name = get_ship_method_.ship_method>
				</cfif>
			</cfif>
		</cfif>
	
		<cfset all_logistic = QueryNew("MEMBER_TYPE,MEMBER_ID,LINE","Integer,Integer,Integer")>
		<cfset TEMP_LINE = 0>
		<cfscript>
			for(i_index=1;i_index lte add_logistic.recordcount;i_index=i_index+1)
			{
				TEMP_LINE = TEMP_LINE + 1;
				QueryAddRow(all_logistic,1);
				QuerySetCell(all_logistic,"MEMBER_TYPE",add_logistic.MEMBER_TYPE[i_index],TEMP_LINE);
				QuerySetCell(all_logistic,"MEMBER_ID",add_logistic.MEMBER_ID[i_index],TEMP_LINE);
				QuerySetCell(all_logistic,"LINE",i_index,TEMP_LINE);	
			}
		</cfscript>
	</cfif>
	<cf_catalystHeader>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box title="#getLang('','Toplu Sevkiyatlar','47233')#">
			<cfform name="add_packet_ship" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_multi_packetship" onsubmit="return (unformat_fields());"><!--- #request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_packetship --->
				<cf_papers paper_type="ship_fis" form_name="add_packet_ship" form_field="transport_no1">
				<cfoutput>
					<cf_box_elements>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-process_cat">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'>*</label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58859.Süreç'></cfsavecontent>
									<cf_workcube_process is_upd='0' process_cat_width='170' is_detail='0'>
								</div>
							</div>
							<div class="form-group" id="item-ship_method_name">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'>*</label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="header_"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></cfsavecontent>
										<input type="hidden" name="ship_method_id" id="ship_method_id" value="<cfif isdefined("attributes.ship_method_id")>#attributes.ship_method_id#</cfif>">
										<input type="text" name="ship_method_name" id="ship_method_name" value="<cfif isdefined("attributes.ship_method_name")>#attributes.ship_method_name#</cfif>" readonly style="width:170px;">
										<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_ship_methods&field_name=add_packet_ship.ship_method_name&field_id=add_packet_ship.ship_method_id&is_form_submitted=1','','ui-draggable-box-small');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-transport_comp_name">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57716.Taşıyıcı'>*</label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57716.Taşıyıcı'></cfsavecontent>
										<input type="hidden" name="transport_comp_id" id="transport_comp_id" value="<cfif isdefined('attributes.transport_comp_id') and len(attributes.transport_comp_id)>#attributes.transport_comp_id#</cfif>"> 
										<input type="text" name="transport_comp_name" id="transport_comp_name" readonly value="<cfif isdefined('attributes.transport_comp_id') and len(attributes.transport_comp_id)>#get_par_info(attributes.transport_comp_id,1,0,0)#</cfif>">
										<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=add_packet_ship.transport_comp_id&field_comp_name=add_packet_ship.transport_comp_name&field_partner=add_packet_ship.transport_deliver_id&field_name=add_packet_ship.transport_deliver_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&call_function=kontrol_prerecord()&select_list=2');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-transport_deliver_name">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='45460.Taşıyıcı Yetkilisi'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfsavecontent variable="header_"><cf_get_lang dictionary_id='45460.Taşıyıcı Yetkilisi'></cfsavecontent>
									<input type="hidden" name="transport_deliver_id" id="transport_deliver_id" value="<cfif isdefined('attributes.transport_deliver_id') and len(attributes.transport_deliver_id)>#attributes.transport_deliver_id#</cfif>">
									<input type="text" name="transport_deliver_name" id="transport_deliver_name" readonly value="<cfif isdefined('attributes.transport_deliver_id') and len(attributes.transport_deliver_id)>#get_par_info(attributes.transport_deliver_id,0,-1,0)#</cfif>">
								</div>
							</div>
							<div class="form-group" id="item-assetp_name">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58480.Araç'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58480.Araç'></cfsavecontent>
										<cfif isdefined("attributes.assetp_id")>
											<cfquery name="GET_ASSETP" datasource="#DSN#">
												SELECT ASSETP, POSITION_CODE FROM ASSET_P WHERE ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#">
											</cfquery>
											<input type="hidden" name="assetp_id" id="assetp_id" value="#attributes.assetp_id#">
										<cfelse>
											<input type="hidden" name="assetp_id" id="assetp_id">
											<input name="assetp_name" type="text" id="assetp_name" onFocus="AutoComplete_Create('assetp_name','ASSETP','ASSETP,FULL_NAME','get_assept','','ASSETP_ID,FULL_NAME,EMPLOYEE_ID','assetp_id,vehicle_emp_name,vehicle_emp_id','','3','170');" value="" autocomplete="off" >
										</cfif>
										<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_ship_vehicles&field_id=add_packet_ship.assetp_id&field_name=add_packet_ship.assetp_name&field_emp_id=add_packet_ship.vehicle_emp_id&field_emp_name=add_packet_ship.vehicle_emp_name');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-vehicle_emp_name">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='45466.Araç Yetkilisi'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="header_"><cf_get_lang dictionary_id='45466.Araç Yetkilisi'></cfsavecontent>
										<cfif isdefined("attributes.assetp_id")>
											<input type="hidden" name="vehicle_emp_id" id="vehicle_emp_id" value="<cfif len(get_assetp.position_code)>#get_assetp.position_code#</cfif>">
											<input  name="vehicle_emp_name" type="text" id="vehicle_emp_name" onFocus="AutoComplete_Create('vehicle_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','vehicle_emp_id','','3','170');" value="<cfif len(get_assetp.position_code)>#get_emp_info(get_assetp.position_code,1,0)#</cfif>" autocomplete="off">
										<cfelse>
											<input type="hidden" name="vehicle_emp_id" id="vehicle_emp_id" value="">
											<input  name="vehicle_emp_name" type="text" id="vehicle_emp_name" onFocus="AutoComplete_Create('vehicle_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','vehicle_emp_id','','3','170');" autocomplete="off">
										</cfif>
										<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_name=add_packet_ship.vehicle_emp_name&field_emp_id=add_packet_ship.vehicle_emp_id&select_list=1');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-plate">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29453.Plaka'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfsavecontent variable="header_"><cf_get_lang dictionary_id='29453.Plaka'></cfsavecontent>
									<input  name="plate" id="plate" type="text" maxlength="50">
								</div>
							</div>
							<div class="form-group" id="item-note">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57629.Açıklama'></cfsavecontent>
									<textarea name="note" id="note" style="width:170px;height:40px;"></textarea>
								</div>
							</div>
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
							<div class="form-group" id="item-transport_no1">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='45458.Sevkiyat No'>*</label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfsavecontent variable="header_"><cf_get_lang dictionary_id='45458.Sevkiyat No'></cfsavecontent>
									<input type="text" name="transport_no1" id="transport_no1" value="#paper_code & '-' & paper_number#" readonly>
								</div>
							</div>
							<div class="form-group" id="item-reference_no">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58794.Referans No'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58794.Referans No'></cfsavecontent>
									<input type="text" name="reference_no" id="reference_no" value="" maxlength="25">
								</div>
							</div>
							<div class="form-group" id="item-transport_paper_no">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57716.Taşıyıcı'><cf_get_lang dictionary_id='57880.Belge No'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57716.Taşıyıcı'><cf_get_lang dictionary_id='57880.Belge No'></cfsavecontent>
									<cfinput name="transport_paper_no" type="text" maxlength="25">
								</div>
							</div>
							<div class="form-group" id="item-deliver_date">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57645.Teslim Tarihi'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
										<div class="input-group">
											<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57645.Teslim Tarihi'></cfsavecontent>
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='45467.Teslim Tarihi Girmelisiniz'></cfsavecontent>
											<cfsavecontent variable="message1"><cf_get_lang dictionary_id='45647.Lütfen Teslim Tarihi Formatını Doğru Giriniz'></cfsavecontent>
											<cfinput value="" validate="#validate_style#" type="text" name="deliver_date" message="#message1#">
											<span class="input-group-addon"><cf_wrk_date_image date_field="deliver_date"></span>
										</div>
									</div>
									<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
										<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
											<cf_wrkTimeFormat name="deliver_h" id="deliver_h" value="0">
										</div>
										<div class="col col-6 col-md-6 col-sm-6 col-xs-6">  
											<select name="deliver_m" id="deliver_m">
												<cfloop from="0" to="59" index="i">
													<option value="#numberformat(i,00)#">#numberformat(i,00)#</option>
												</cfloop>
											</select>
										</div>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-action_date">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='45463.Depo Çıkış Tarihi'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
										<div class="input-group">
											<cfsavecontent variable="header_"><cf_get_lang dictionary_id='45463.Depo Çıkış Tarihi'></cfsavecontent>
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='45464.Depo Çıkış Tarihi Girmelisiniz'> !</cfsavecontent>
											<cfinput validate="#validate_style#" required="Yes" message="#message#" type="text" name="action_date" style="width:65px;" value="#dateformat(now(),dateformat_style)#">
											<span class="input-group-addon"><cf_wrk_date_image date_field="action_date"></span>
										</div>
									</div>
									<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
										<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
											<cf_wrkTimeFormat name="start_h" id="start_h" value="0">	
										</div>
										<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
											<select name="start_m" id="start_m">
												<cfloop from="0" to="59" index="i">
													<option value="#numberformat(i,00)#">#numberformat(i,00)#</option>
												</cfloop>
											</select>
										</div>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-deliver_name2">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='45466.Araç Yetkilisi'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="header_"><cf_get_lang dictionary_id='45470.Teslim Eden'></cfsavecontent>
										<input type="hidden" name="deliver_id2" id="deliver_id2" value="#session.ep.userid#">
										<input name="deliver_name2" type="text" id="deliver_name2" onFocus="AutoComplete_Create('deliver_name2','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','deliver_id2','','3','170');" value="#get_emp_info(session.ep.userid,0,0)#" autocomplete="off">
										<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id2=add_packet_ship.deliver_id2&field_name=add_packet_ship.deliver_name2&select_list=1');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-location_id">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29428.Çıkış Depo'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfsavecontent variable="header_"><cf_get_lang dictionary_id='29428.Çıkış Depo'></cfsavecontent>
									<cfif isdefined('attributes.location_id')>
										<cf_wrkdepartmentlocation
											returnInputValue="location_id,department_name,department_id,branch_id"
											returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
											fieldName="department_name"
											fieldid="location_id"
											department_fldId="department_id"
											branch_fldId="branch_id"
											branch_id="#attributes.branch_id#"
											department_id="#attributes.department_id#"
											location_id="#attributes.location_id#"
											location_name="#attributes.department_name#"
											user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
											width="170">
									<cfelse>
										<cf_wrkdepartmentlocation
											returnInputValue="location_id,department_name,department_id,branch_id"
											returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
											fieldName="department_name"
											fieldid="location_id"
											department_fldId="department_id"
											branch_fldId="branch_id"
											user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
											width="170">
									</cfif>
								</div>
							</div>
							<div class="form-group" id="item-calculate_type">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='45546.Hes. Yöntemi'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfsavecontent variable="header_"><cf_get_lang dictionary_id='45546.Hes. Yöntemi'></cfsavecontent>
									<input type="hidden" value="30" name="max_limit" id="max_limit">
									<input type="hidden" value="1" name="options_kontrol" id="options_kontrol"><!--- Bu alan disabled olan asagidaki radio butonlarin secilip secilmadegini kontrol etmek icin kullaniliyor --->
									<label><input type="radio" name="calculate_type" id="calculate_type" value="1" onclick="change_packet(1);" disabled><cf_get_lang dictionary_id='45547.Kümülatif'></label>
									<label><input type="radio" name="calculate_type" id="calculate_type" value="2" onclick="change_packet(2);" disabled><cf_get_lang dictionary_id='45548.Paket'><!--- onblur="change_packet(2);" ---></label>
								</div>
							</div>
							<div class="form-group" id="item-total_cost2_value">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57492.Toplam'><cf_get_lang dictionary_id='45493.Maliyet Tutarı'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57492.Toplam'><cf_get_lang dictionary_id='45493.Maliyet Tutarı'></cfsavecontent>
										<input type="text" name="total_cost_value" id="total_cost_value" value="#TlFormat(0)#" class="moneybox" readonly style="width:74px;"><span class="input-group-addon no-bg">#session.ep.money#</span>
										<input type="text" name="total_cost2_value" id="total_cost2_value" value="#TlFormat(0)#" class="moneybox" readonly style="width:74px;"><span class="input-group-addon no-bg">#session.ep.money2#</span>
									</div>
								</div>
							</div>
						</div>
						<div class="col col-9 col-xs-12 ListContent">
							<cf_seperator id="sevkiyat" title="#getLang('','Sevkiyatlar','34791')#">
							<cf_grid_list id="sevkiyat">
								<tbody id="table1"></tbody>
								<thead>
									<tr>
										<th width="10"  style="text-align:center;">
											<input type="hidden" name="record_num" id="record_num" value="0">
											<input type="hidden" name="ship_id_list" id="ship_id_list" value="">
											<span onClick="add_row();" class="fa fa-plus" title="<cf_get_lang dictionary_id='58061.Cari'><cf_get_lang dictionary_id='57582.Ekle'>"></span>						
										</th>
										<th width="20"><i class="fa fa-copy" title="<cf_get_lang dictionary_id='45323.İlişkili İrsaliye Ekle'>"></i></th>
										<th width="20"><i class="fa fa-archive" title="<cf_get_lang dictionary_id='63707.Paket Ekle'>"></i></th>
										<th width="160"><cf_get_lang dictionary_id='57519.Cari Hesap'>*</th>
										<th width="125"><cf_get_lang dictionary_id='58138.İrsaliye No'>*</th>
										<th width="65"><cf_get_lang dictionary_id='57742.Tarih'></th>
										<th width="150"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></th>
										<th width="200"><cf_get_lang dictionary_id='58723.Adres'></th>
										<th width="200"><cf_get_lang dictionary_id='45493.Maliyet Tutarı'>(#session.ep.money#)</th>
										<th width="200"><cf_get_lang dictionary_id='45493.Maliyet Tutarı'>(#session.ep.money2#)</th>
									</tr>
								</thead>
							</cf_grid_list>
						</div>
						<div class="col col-9 col-xs-12 ListContent">
							<cf_seperator id="paket" title="#getLang('','Paketler','60')#">
							<cf_grid_list id="paket">
								<tbody id="table2"></tbody>
								<thead>
									<tr>
										<th><input name="record_num_other" id="record_num_other" type="hidden" value="0"></th>
										<th width="160"><cf_get_lang dictionary_id='57519.Cari Hesap'>*</th>
										<th width="100"><cf_get_lang dictionary_id='58082.Adet'>*</th>
										<th width="125"><cf_get_lang dictionary_id='45477.Paket Tipi'>*</th>
										<th width="150"><cf_get_lang dictionary_id='45478.Ebat'></th>
										<th width="150"><cf_get_lang dictionary_id='29784.Ağırlık'> (kg)</th>
										<th width="150"><cf_get_lang dictionary_id='57633.Barkod'></th>
										<th width="150"><cf_get_lang dictionary_id='45545.Paketleyen'></th>
									</tr>
								</thead>
							</cf_grid_list>
						</div>
					</cf_box_elements>
					<cf_box_footer>
						<cf_workcube_buttons type_format='1' is_upd='0' add_function='control()'>
					</cf_box_footer>
				</cfoutput>
			</cfform>
		</cf_box>
	</div>
	<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
	<script type="text/javascript">
	calculate_type_deger = 1;
	row_count = 0;
	row_count2 = 0;
	
	kontrol_row_count = 0;
	
	money_list = "<cfoutput>#valuelist(moneys.money,',')#</cfoutput>";
	rate1_list = "<cfoutput>#valuelist(moneys.rate1,',')#</cfoutput>";
	rate2_list = "<cfoutput>#valuelist(moneys.rate2,',')#</cfoutput>";
	
	function pencere_ac(no)
	{
		deger_company_id = eval("document.add_packet_ship.company_id"+no).value;
		deger_consumer_id = eval("document.add_packet_ship.consumer_id"+no).value;
		
		document.add_packet_ship.ship_id_list.value ='';
		if(deger_company_id != "")
		{
			for(r=1;r<=add_packet_ship.record_num.value;r++)
			{	
				deger_row_kontrol = eval("document.add_packet_ship.row_kontrol"+r).value;
				deger_ship_id = eval("document.add_packet_ship.ship_id"+r).value;
				deger_company_id2 = eval("document.add_packet_ship.company_id"+r).value;
				if(deger_row_kontrol == 1 && (deger_company_id2 == deger_company_id))
				{
					if(document.add_packet_ship.ship_id_list.value == '')
					{
						if(deger_ship_id != '')
							document.add_packet_ship.ship_id_list.value = deger_ship_id;
					}
					else
					{
						if(deger_ship_id != '')
							document.add_packet_ship.ship_id_list.value += ','+deger_ship_id;
					}	
				}
			}
			<!---windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_ship_details</cfoutput>&ship_id_list=' + add_packet_ship.ship_id_list.value + '&ship_id=add_packet_ship.ship_id'+no+'&ship_number=add_packet_ship.ship_number'+no+'&ship_date=add_packet_ship.ship_date'+no+'&ship_deliver=add_packet_ship.ship_deliver'+no+'&ship_type=add_packet_ship.ship_type'+no+'&ship_adress=add_packet_ship.ship_adress'+no+'&is_gonder=1&deliver_company_id='+deger_company_id,'project');--->
			openBoxDraggable('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_ship_details</cfoutput>&ship_id_list=' + document.getElementById('ship_id_list').value + '&ship_id=ship_id'+no+'&ship_number=ship_number'+no+'&ship_date=ship_date'+no+'&ship_deliver=ship_deliver'+no+'&ship_type=ship_type'+no+'&ship_adress=ship_adress'+no+'&is_gonder=1&is_multi=1&deliver_company_id='+deger_company_id);
		}
		else if(deger_consumer_id != "")
		{		
			for(r=1;r<=add_packet_ship.record_num.value;r++)
			{	
				deger_row_kontrol = eval("document.add_packet_ship.row_kontrol"+r).value;
				deger_ship_id = eval("document.add_packet_ship.ship_id"+r).value;
				deger_consumer_id2 = eval("document.add_packet_ship.consumer_id"+r).value;
				if(deger_row_kontrol == 1 && (deger_consumer_id2 == deger_consumer_id))
				{
					if(document.add_packet_ship.ship_id_list.value == '')
					{
						if(deger_ship_id != '')
							document.add_packet_ship.ship_id_list.value = deger_ship_id;
					}
					else
					{
						if(deger_ship_id != '')
							document.add_packet_ship.ship_id_list.value += ','+deger_ship_id;
					}	
				}
			}
			<!---windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_ship_details</cfoutput>&ship_id_list=' + add_packet_ship.ship_id_list.value + '&ship_id=add_packet_ship.ship_id'+no+'&ship_number=add_packet_ship.ship_number'+no+'&ship_date=add_packet_ship.ship_date'+no+'&ship_deliver=add_packet_ship.ship_deliver'+no+'&ship_type=add_packet_ship.ship_type'+no+'&ship_adress=add_packet_ship.ship_adress'+no+'&is_gonder=1&deliver_company_id='+deger_consumer_id,'list');//&deliver_company_id='+add_packet_ship.service_company_id.value--->
			openBoxDraggable('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_ship_details</cfoutput>&ship_id_list=' + document.getElementById('ship_id_list').value + '&ship_id=add_packet_ship.ship_id'+no+'&ship_number=ship_number'+no+'&ship_date=ship_date'+no+'&ship_deliver=ship_deliver'+no+'&ship_type=ship_type'+no+'&ship_adress=ship_adress'+no+'&is_gonder=1&is_multi=1&deliver_consumer_id='+deger_consumer_id);//&deliver_company_id='+add_packet_ship.service_company_id.value	
		}
		else
		{
			alert(no + ".<cf_get_lang dictionary_id='45657.Satır İçin'><cf_get_lang dictionary_id='45308.Cari Hesap Seçmelisiniz'>");
			return false;
		}	
	}
	
	function pencere_ac_order(no)//order list
	{
	<!---	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_details&field_emp_id=add_packet_ship.pack_emp_id'+ no +'&field_name=add_packet_ship.pack_emp_name'+ no+'&select_list=1','list','popup_list_positions');--->
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=object.popup_list_orders_for_ship','list','popup_list_positions');
	}
	
	function pencere_ac2(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_packet_ship.pack_emp_id'+ no +'&field_name=add_packet_ship.pack_emp_name'+ no+'&select_list=1');
	}
	
	function pencere_ac_cari(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_comp_id=add_packet_ship.company_id'+ no +'&field_partner=add_packet_ship.partner_id'+ no +'&field_consumer=add_packet_ship.consumer_id'+ no +'&field_comp_name=add_packet_ship.member_name'+ no +'&field_name=add_packet_ship.member_name'+ no +'&call_function=cari_kontrol('+no+')&select_list=7,8');
	}
	
	function cari_kontrol(no)
	{
		deger_company_id = eval("document.add_packet_ship.company_id"+no).value;
		deger_consumer_id = eval("document.add_packet_ship.consumer_id"+no).value;
		if(deger_company_id !='')
			deger_cari = deger_company_id;
		else
			deger_cari = deger_consumer_id;
		for(ck=1;ck<=add_packet_ship.record_num.value;ck++)
		{
			deger_row_kontrol = eval("document.add_packet_ship.row_kontrol"+ck).value;
			if (deger_company_id != '')
				deger_cari_row = eval("document.add_packet_ship.company_id"+ck).value;
			else
				deger_cari_row = eval("document.add_packet_ship.consumer_id"+ck).value;
			//Satir silinmemis,ilgili satırla dongudeki satir farkli mi ve deger aynimi
			if(deger_row_kontrol == 1 && (ck != no) && (deger_cari == deger_cari_row)) 
				eval("document.add_packet_ship.cari_kontrol"+no).value = ck;
		}
	}
	
	function sil(sy)
	{
		for(r=1;r<=add_packet_ship.record_num_other.value;r++)
		{
			deger_row_kontrol_other = eval("document.add_packet_ship.row_kontrol_other"+r).value;
			deger_row_count_other = eval("document.add_packet_ship.row_count_other"+r).value;
			if(deger_row_kontrol_other == 1 && (deger_row_count_other == sy))//satir silinmemis ve irsaliye ile iliskili ise
			{
				alert("<cf_get_lang dictionary_id='45658.İlgili İrsaliye ile İlişkili Paketler Mevcut. Kontrol Ediniz'>!");
				return false;
			}
		}
	
		kontrol_row_count--;
		var my_element=eval("add_packet_ship.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	
		for(rr=1;rr<=add_packet_ship.record_num.value;rr++)
		{
			deger_row_kontrol = eval("document.add_packet_ship.row_kontrol"+rr).value;
			deger_related_row_kontrol = eval("document.add_packet_ship.related_row_kontrol"+rr).value;
			if(deger_row_kontrol == 1 && (deger_related_row_kontrol == sy))
			{
				kontrol_row_count--;
				var my_element=eval("add_packet_ship.row_kontrol"+rr);
				my_element.value=0;
				var my_element=eval("frm_row"+rr);
				my_element.style.display="none";	
			}
		}
	}
	
	function sil_other(sy)
	{
		//irsaliye ve paket satir iliskisi icin silinen satırda 
		 temp_row_count_other = eval("document.add_packet_ship.row_count_other"+sy).value;
		temp_cari_ship_id_list = eval("document.add_packet_ship.cari_" +temp_row_count_other+ "_ship_id_list").value;
		
		var temp_ship_id_list = '';
		for(r=1;r<=list_len(temp_cari_ship_id_list);r++)
		{
			if(list_getat(temp_cari_ship_id_list,r) != sy)
			{
				if(temp_ship_id_list == '')
					temp_ship_id_list = list_getat(temp_cari_ship_id_list,r);
				else
					temp_ship_id_list += ','+list_getat(temp_cari_ship_id_list,r);
			}
		}
		
		eval("document.add_packet_ship.cari_" +temp_row_count_other+ "_ship_id_list").value = temp_ship_id_list;
	
		var my_element=eval("add_packet_ship.row_kontrol_other"+sy);
		my_element.value=0;
		var my_element=eval("frm_row_other"+sy);
		my_element.style.display="none";
		degistir(sy);
	}
	
	function add_row()
	{
		if(document.add_packet_ship.ship_method_id.value != "" && document.add_packet_ship.transport_comp_id.value != "")
		{
			if(document.add_packet_ship.options_kontrol.value == 0 || document.add_packet_ship.options_kontrol.value == "")
			{	
				alert("<cf_get_lang dictionary_id='45659.Lütfen Tasıyıcı Firmayı Kontrol Ediniz. Bu Cari İçin Fiyat Listesi Tanımlı Değil'>!");
				return false;
			}
			
			row_count++;
			kontrol_row_count++;
				
			var newRow;
			var newCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);		
			document.add_packet_ship.record_num.value=row_count;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" value="1"><input type="hidden" name="row_count_' + row_count +'_list" id="row_count_' + row_count +'_list" value=""><input type="hidden" name="related_row_kontrol' + row_count +'" id="related_row_kontrol' + row_count +'" value=""><a style="cursor:pointer" onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="Sil"></i></a>';
			/* copy */
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<a style="cursor:pointer" onclick="add_row2(' + row_count + ');"><i class="fa fa-copy" title="<cf_get_lang dictionary_id='45323.İlişkili İrsaliye Ekle'>"></i></a>';
			/* paket */
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<a style="cursor:pointer" onclick="add_row_other(' + row_count + ');" title="<cf_get_lang dictionary_id='63707.Paket Ekle'>"><i class="fa fa-archive"></i></a>';		
			/* cari hesap */
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="cari_kontrol' + row_count +'" id="cari_kontrol' + row_count +'" value=""><input type="hidden" name="cari_' + row_count +'_ship_id_list" id="cari_' + row_count +'_ship_id_list" value=""><input type="hidden" name="consumer_id' + row_count +'" id="consumer_id' + row_count +'" value=""><input type="hidden" name="company_id' + row_count +'" id="company_id' + row_count +'" value=""><input type="hidden" name="partner_id' + row_count +'" id="partner_id' + row_count +'" value=""><input type="text" name="member_name' + row_count +'" id="member_name' + row_count +'" value="" readonly style="width:150px;"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_cari('+ row_count +');"></span></div></div>';
			/* irsaliye no */
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="ship_id' + row_count +'" id="ship_id' + row_count +'"><input type="text" name="ship_number' + row_count +'" id="ship_number' + row_count +'" value="" readonly  style="width:110px;"> <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac('+ row_count +');"></span></div></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="ship_deliver' + row_count +'" id="ship_deliver' + row_count +'" value=""><input type="text" name="ship_date' + row_count +'" id="ship_date' + row_count +'" value="" readonly style="width:65px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="ship_type' + row_count +'" id="ship_type' + row_count +'" value="" readonly style="width:150px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="ship_adress' + row_count +'" id="ship_adress' + row_count +'" value="" readonly style="width:200px;">';
			/* maliyet1 */
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="total_cost_value' + row_count +'" id="total_cost_value' + row_count +'" value="<cfoutput>#TlFormat(0)#</cfoutput>" class="moneybox" readonly style="width:74px;">&nbsp;<cfoutput>#session.ep.money#</cfoutput></div>';
			/* maliyet2 */
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="total_cost2_value' + row_count +'" id="total_cost2_value' + row_count +'" value="<cfoutput>#TlFormat(0)#</cfoutput>" class="moneybox" readonly style="width:74px;">&nbsp;<cfoutput>#session.ep.money2#</cfoutput></div>';
		}
		else
		{
			alert("<cf_get_lang dictionary_id='45660.Lütfen Tasıyıcı veya Sevk Yöntemi Seçiniz'> !");
			return false;	
		}
	}
	
	function add_row2(no)
	{
		deger_company_id = eval("document.add_packet_ship.company_id"+no).value;
		deger_partner_id = eval("document.add_packet_ship.partner_id"+no).value;
		deger_consumer_id = eval("document.add_packet_ship.consumer_id"+no).value;
		deger_member_name = eval("document.add_packet_ship.member_name"+no).value;
		deger_ship_id = eval("document.add_packet_ship.ship_id"+no).value;
		
		deger_cari_ship_id_list = eval("document.add_packet_ship.cari_" +no+ "_ship_id_list");
		
		deger_row_count_list = eval("document.add_packet_ship.row_count_" +no+ "_list");
		
		if(deger_company_id == "" && deger_consumer_id == "")
		{
			alert(no + ".<cf_get_lang dictionary_id='45657.Satır İçin'> <cf_get_lang dictionary_id='45308.Cari Hesap Seçmelisiniz'>");
			return false;
		}
		
		if(deger_ship_id == "")
		{
			alert(no + ".<cf_get_lang dictionary_id='45657.Satır İçin'><cf_get_lang dictionary_id='45483.İrsaliye Seçiniz'>!");
			return false;
		}
		
		row_count++;
		kontrol_row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		document.add_packet_ship.record_num.value=row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" value="1"><input type="hidden" name="row_count_' + row_count +'_list" id="row_count_' + row_count +'_list" value=""><input type="hidden" name="related_row_kontrol' + row_count +'" id="related_row_kontrol' + row_count +'" value="'+no+'">';
		/* copy */
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a style="cursor:pointer" onclick="add_row2(' + row_count + ');"><i class="fa fa-copy" title="<cf_get_lang dictionary_id='45323.İlişkili İrsaliye Ekle'>"></i></a>';
		/* paket */
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a style="cursor:pointer" onclick="add_row_other(' + row_count + ');" title="<cf_get_lang dictionary_id='63707.Paket Ekle'>"><i class="fa fa-archive"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="cari_kontrol' + row_count +'" id="cari_kontrol' + row_count +'" value=""><input type="hidden" name="cari_' + row_count +'_ship_id_list" id="cari_' + row_count +'_ship_id_list" value=""><input type="hidden" name="consumer_id' + row_count +'" id="consumer_id' + row_count +'" value="'+deger_consumer_id+'"><input type="hidden" name="company_id' + row_count +'" id="company_id' + row_count +'" value="'+deger_company_id+'"><input type="hidden" name="partner_id' + row_count +'" id="partner_id' + row_count +'" value="'+deger_partner_id+'"><input type="text" name="member_name' + row_count +'" id="member_name' + row_count +'" value="'+deger_member_name+'" readonly style="width:150px;"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick=""></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="ship_id' + row_count +'" id="ship_id' + row_count +'"><input type="text" name="ship_number' + row_count +'" id="ship_number' + row_count +'" value="" readonly  style="width:110px;"> <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac('+ row_count +');"></span></div></div>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="ship_deliver' + row_count +'" id="ship_deliver' + row_count +'" value=""><input type="text" name="ship_date' + row_count +'" id="ship_date' + row_count +'" value="" readonly style="width:65px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="ship_type' + row_count +'" value="" id="ship_type' + row_count +'" value="" readonly style="width:150px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="ship_adress' + row_count +'" id="ship_adress' + row_count +'" value="" readonly style="width:200px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="total_cost_value' + row_count +'" id="total_cost_value' + row_count +'" value="<cfoutput>#TlFormat(0)#</cfoutput>" style="width:74px;"><input type="hidden" name="total_cost2_value' + row_count +'" id="total_cost2_value' + row_count +'" value="<cfoutput>#TlFormat(0)#</cfoutput>" style="width:74px;">';
		
		if(deger_row_count_list.value == '')
			deger_row_count_list.value = row_count;
		else
			deger_row_count_list.value += ','+row_count;
	}
	
	function add_row_other(no)
	{	
		deger_company_id = eval("document.add_packet_ship.company_id"+no).value;
		deger_partner_id = eval("document.add_packet_ship.partner_id"+no).value;
		deger_consumer_id = eval("document.add_packet_ship.consumer_id"+no).value;
		deger_member_name = eval("document.add_packet_ship.member_name"+no).value;
		deger_ship_id = eval("document.add_packet_ship.ship_id"+no).value;
		
		deger_cari_ship_id_list = eval("document.add_packet_ship.cari_" +no+ "_ship_id_list");
		
		if(deger_company_id == "" && deger_consumer_id == "")
		{
			alert(no + ".<cf_get_lang dictionary_id='45657.Satır İçin'><cf_get_lang dictionary_id='45308.Cari Hesap Seçmelisiniz'>");
			return false;
		}
		
		if(deger_ship_id == "")
		{
			alert(no + ".<cf_get_lang dictionary_id='45657.Satır İçin'><cf_get_lang dictionary_id='45483.İrsaliye Seçiniz'>!");
			return false;
		}
	
		//transport_control();/*Satır eklerkende taşıyıcıyı kontrol etsin.*/
		row_count2++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);
		newRow.setAttribute("name","frm_row_other" + row_count2);
		newRow.setAttribute("id","frm_row_other" + row_count2);		
		newRow.setAttribute("NAME","frm_row_other" + row_count2);
		newRow.setAttribute("ID","frm_row_other" + row_count2);		
		document.add_packet_ship.record_num_other.value=row_count2;
	
		newCell = newRow.insertCell(newRow.cells.length)
		newCell.innerHTML = '<input type="hidden" name="row_count_other' + row_count2 +'" id="row_count_other' + row_count2 +'" value="'+no+'"><input type="hidden" name="row_kontrol_other' + row_count2 +'" id="row_kontrol_other' + row_count2 +'" value="1"><a style="cursor:pointer" onclick="sil_other(' + row_count2 + ');"><img src="images/delete_list.gif" border="0"></a>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="consumer_id_other' + row_count2 +'" id="consumer_id_other' + row_count2 +'" value="'+deger_consumer_id+'"><input type="hidden" name="company_id_other' + row_count2 +'" id="company_id_other' + row_count2 +'" value="'+deger_company_id+'"><input type="hidden" name="partner_id_other' + row_count2 +'" id="partner_id_other' + row_count2 +'" value="'+deger_partner_id+'"><input type="text" name="member_name_other' + row_count2 +'" id="member_name_other' + row_count2 +'" value="'+deger_member_name+'" readonly style="width:170px;">';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="quantity' + row_count2 +'" id="quantity' + row_count2 +'" onblur="degistir( ' + row_count2 + ');" onKeyup="return(FormatCurrency(this,event,0));" value="<cfoutput>#tlformat(1,0)#</cfoutput>" class="moneybox" style="width:40px;">';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="package_type' + row_count2 +'" id="package_type' + row_count2 +'" onchange="degistir( ' + row_count2 + ');" style="width:130px;"><option value="">Seçiniz</option><cfoutput query="get_package_type"><option value="#package_type_id#,#dimention#,#calculate_type_id#">#package_type#</option></cfoutput></select>'; //add_general_prom();
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="ship_ebat' + row_count2 +'" id="ship_ebat" value="" readonly style="width:90px;">';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="ship_agirlik' + row_count2 +'" id="ship_agirlik' + row_count2 +'" value="" onBlur="degistir(' + row_count2 + ');" onKeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:75px;">';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="total_price' + row_count2 +'" id="total_price' + row_count2 +'" value="" onKeyup="return(FormatCurrency(this,event));" class="moneybox" readonly style="width:75px;"><input type="hidden" name="other_money' + row_count2 +'" id="other_money' + row_count2 +'" value="" class="moneybox" readonly style="width:50px;"><input type="text" name="ship_barcod' + row_count2 +'" id="ship_barcod' + row_count2 +'" value="" style="width:120px;">';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="pack_emp_id' + row_count2 +'" id="pack_emp_id' + row_count2 +'" value=""><input type="text" name="pack_emp_name' + row_count2 +'" id="pack_emp_name' + row_count2 +'" value="" style="width:150px;"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac2('+ row_count2 +');"></span></div></div>';
	
		if(deger_cari_ship_id_list.value == '')
			deger_cari_ship_id_list.value = row_count2;
		else
			deger_cari_ship_id_list.value += ','+row_count2;
	}
	
	function degistir(id)
	{
		if(document.add_packet_ship.ship_method_id.value != "" && document.add_packet_ship.transport_comp_id.value != "")
		{
			//Coklu satir mantigi icin eklendi ship_id_list degerine ulasmak icin
			temp_row_count_other = eval("document.add_packet_ship.row_count_other"+id).value;
			var ship_id_list = eval("document.add_packet_ship.cari_"+temp_row_count_other+"_ship_id_list").value;
			
			price_sum = 0;
			if(document.add_packet_ship.calculate_type[1].checked)
			{
				for(ii=1;ii<=list_len(ship_id_list);ii++)
				{
					//hangi satırdaki paketler hesaplamaya dahil edilecek
					var ii_ = list_getat(ship_id_list,ii);
					if(eval("document.add_packet_ship.row_kontrol_other"+ii_).value == 1)
					{
						var temp_package_type = eval("document.add_packet_ship.package_type"+ii_);
						var temp_ship_ebat = eval("document.add_packet_ship.ship_ebat"+ii_);
						var temp_total_price = eval("document.add_packet_ship.total_price"+ii_);
						var temp_quantity = eval("document.add_packet_ship.quantity"+ii_);
						var temp_other_money = eval("document.add_packet_ship.other_money"+ii_);
						var temp_ship_agirlik = eval("document.add_packet_ship.ship_agirlik"+ii_);
						
						if(trim(eval("add_packet_ship.quantity"+ii_).value).length == 0)
							eval("add_packet_ship.quantity"+ii_).value = 1;
						
						temp_desi = list_getat(temp_package_type.value,2,',');
						temp_package_type_id = list_getat(temp_package_type.value,3,',');
						if(temp_package_type_id==1) //Desi
						{
							temp_ship_ebat.value = temp_desi;
							temp_ship_agirlik.value = '';
							desi_1 = list_getat(temp_desi,1,'*');
							desi_2 = list_getat(temp_desi,2,'*');
							desi_3 = list_getat(temp_desi,3,'*');
							desi_hesap = (parseInt(desi_1)*parseInt(desi_2)*parseInt(desi_3)/3000);
							if(desi_hesap<document.add_packet_ship.max_limit.value)
							{
	
								var listParam = document.add_packet_ship.transport_comp_id.value + "*" + document.add_packet_ship.ship_method_id.value + "*" + desi_hesap;
								var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
							}
							else
							{
								var listParam = document.add_packet_ship.transport_comp_id.value + "*" + document.add_packet_ship.ship_method_id.value + "*" + document.add_packet_ship.max_limit.value;
								var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
							}
						}
						else if(temp_package_type_id==2) 
						{	
							temp_ship_ebat.value = '';
							if(trim(temp_ship_agirlik.value).length == 0)
								temp_ship_agirlik.value = 1;
							temp_ship_agirlik_ = parseFloat(filterNum(temp_ship_agirlik.value))*parseFloat(temp_quantity.value);
							if(temp_ship_agirlik_>document.add_packet_ship.max_limit.value)
								temp_ship_agirlik_ = Math.ceil(temp_ship_agirlik_);
							if(temp_ship_agirlik.value !="" && temp_ship_agirlik.value !=0)
							{
								if(temp_ship_agirlik_<document.add_packet_ship.max_limit.value)
								{
									var listParam = document.add_packet_ship.transport_comp_id.value + "*" + document.add_packet_ship.ship_method_id.value + "*" + temp_ship_agirlik_;
									var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
								}
								else
								{
									var listParam = document.add_packet_ship.transport_comp_id.value + "*" + document.add_packet_ship.ship_method_id.value + "*" + document.add_packet_ship.max_limit.value;
									var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
								}
							}	
						}	
						else if(temp_package_type_id==3)  //Zarf ise
						{
							var listParam = document.add_packet_ship.transport_comp_id.value + "*" + document.add_packet_ship.ship_method_id.value;
							var GET_PRICE = wrk_safe_query("stk_GET_PRICE_2",'dsn',0,listParam);
						}
						
						if(GET_PRICE != undefined)
						{
							if(GET_PRICE.recordcount==0)
							{
								alert("<cf_get_lang dictionary_id='45648.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma  Paket Tipini Kontrol Ediniz (Fiyat Listesi)'>!");
								temp_ship_ebat.value = "";
								temp_total_price.value = "";
								temp_other_money.value = "";
							}
							else
							{
								if(temp_package_type_id==1)//Desi ise
								{
									temp_ship_agirlik.value = "";
									if(desi_hesap<document.add_packet_ship.max_limit.value)
									{
										temp_total_price.value = commaSplit(GET_PRICE.PRICE*temp_quantity.value);/*Toplam atanıyor.*/
										price_sum += parseFloat((GET_PRICE.PRICE*temp_quantity.value));
									}
									else
									{
										var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30','dsn',0,document.add_packet_ship.transport_comp_id.value);
										desi_remain = parseFloat((parseInt(desi_1)*parseInt(desi_2)*parseInt(desi_3))/(3000)-<cfoutput>document.add_packet_ship.max_limit.value</cfoutput>);
										temp_total_price.value = commaSplit(parseFloat(GET_PRICE.PRICE*temp_quantity.value)+parseFloat(GET_PRICE_30.PRICE*desi_remain*temp_quantity.value));
										price_sum += parseFloat(GET_PRICE.PRICE*temp_quantity.value)+parseFloat(GET_PRICE_30.PRICE*desi_remain*temp_quantity.value);
										
									}
								}
								if(temp_package_type_id==2)//Kg ise
								{
									temp_ship_ebat.value = "";
									if(trim(temp_ship_agirlik.value).length == 0)
										temp_ship_agirlik.value = 1;							
									if(temp_ship_agirlik_<document.add_packet_ship.max_limit.value)
									{
										price_sum += parseFloat(GET_PRICE.PRICE);
									}
									else
									{
										var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30','dsn',0,document.add_packet_ship.transport_comp_id.value);
										kg_remain = parseFloat(temp_ship_agirlik_-document.add_packet_ship.max_limit.value);
										temp_total_price.value = commaSplit(parseFloat(GET_PRICE.PRICE)+parseFloat(GET_PRICE_30.PRICE*kg_remain));
										price_sum += parseFloat(GET_PRICE.PRICE)+parseFloat(GET_PRICE_30.PRICE*kg_remain);
									}
								}				
								
								else if(temp_package_type_id==3)//Zarf ise
								{
									temp_ship_agirlik = '';
									temp_ship_ebat.value = '';
									temp_total_price.value = commaSplit(parseFloat(GET_PRICE.PRICE) * parseFloat(temp_quantity.value));
									price_sum += parseFloat(GET_PRICE.PRICE) * parseFloat(temp_quantity.value);
								}
								temp_other_money.value = GET_PRICE.OTHER_MONEY;
							}
						}
						else
						{
							temp_total_price.value = "";
							temp_other_money.value = "";	
						}
					}
				}
				eval("add_packet_ship.total_cost_value"+temp_row_count_other).value = commaSplit(price_sum);
				var temp2_sira = list_find(money_list,<cfoutput>'#session.ep.money2#'</cfoutput>); 
				var temp2_rate1 = list_getat(rate1_list,temp2_sira);
				var temp2_rate2 = list_getat(rate2_list,temp2_sira);
				var total_cost2_value = price_sum * (parseFloat(temp2_rate1) / parseFloat(temp2_rate2));
				eval("add_packet_ship.total_cost2_value"+temp_row_count_other).value = commaSplit(total_cost2_value);
			}
			else
			{
				count_desi = 0;
				count_kg = 0;
				count_envelope = 0;
				desi_sum = 0;
				kg_sum = 0;
				desi_price_sum = 0;
				kg_price_sum = 0;
				envelope_price_sum = 0;
				
				for(ii=1;ii<=list_len(ship_id_list);ii++)
				{
					//hangi satırdaki paketler hesaplamaya dahil edilecek
					var ii_ = list_getat(ship_id_list,ii);
					if(eval("document.add_packet_ship.row_kontrol_other"+ii_).value == 1)
					{
						var temp_quantity = document.getElementById('quantity'+ii_);
						var temp_package_type = document.getElementById('package_type'+ii_);
						var temp_ship_ebat = document.getElementById('ship_ebat'+ii_);
						var temp_ship_agirlik = document.getElementById('ship_agirlik'+ii_);
						
						if(trim(eval("add_packet_ship.quantity"+ii_).value).length == 0)
							eval("add_packet_ship.quantity"+ii_).value = 1;
		
						var temp_desi = list_getat(temp_package_type.value,2,',');
						var temp_package_type_id = list_getat(temp_package_type.value,3,',');
		
						if(temp_package_type_id==1) //Desi
						{
							count_desi += 1;
							temp_ship_ebat.value = temp_desi;
							temp_ship_agirlik.value = '';
							desi_1 = list_getat(temp_desi,1,'*');
							desi_2 = list_getat(temp_desi,2,'*');
							desi_3 = list_getat(temp_desi,3,'*');
							desi_hesap = (parseInt(desi_1)*parseInt(desi_2)*parseInt(desi_3)/3000*parseFloat(temp_quantity.value));
							desi_sum +=desi_hesap;
						}
						else if(temp_package_type_id==2)//Kg
						{
							count_kg += 1;
							temp_ship_ebat.value = "";
							if(trim(eval("add_packet_ship.ship_agirlik"+ii_).value).length == 0)
								eval("add_packet_ship.ship_agirlik"+ii_).value = 1;
							temp_ship_agirlik_ = filterNum(temp_ship_agirlik.value);
							if(temp_ship_agirlik.value != "" && temp_ship_agirlik.value !=0)
								kg_sum +=parseFloat(temp_ship_agirlik_)*parseFloat(temp_quantity.value);
						}	
						else if(temp_package_type_id==3)//Zarf ise
						{
							count_envelope += 1;
							temp_ship_agirlik.value = '';
							temp_ship_ebat.value = '';
							var listParam = document.add_packet_ship.transport_comp_id.value + "*" + document.add_packet_ship.ship_method_id.value;
							var GET_PRICE3 = wrk_safe_query("stk_GET_PRICE_2",'dsn',0,listParam);
							if(GET_PRICE3 != undefined)
							{
								if(GET_PRICE3.recordcount==0)
									alert("<cf_get_lang dictionary_id='45650.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma  Paket Tipini(Desi) Kontrol Ediniz (Fiyat Listesi)'>!");
								else
									envelope_price_sum += GET_PRICE3.PRICE * parseFloat(temp_quantity.value);
							}					
						}
					}
				}
				
				if(count_desi != 0)
				{
					
					if(desi_sum<document.add_packet_ship.max_limit.value)
					{
						var listParam = document.add_packet_ship.transport_comp_id.value + "*" + document.add_packet_ship.ship_method_id.value + "*" + desi_sum;
						var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
					}
					else
					{
						var listParam = document.add_packet_ship.transport_comp_id.value + "*" + document.add_packet_ship.ship_method_id.value + "*" + document.add_packet_ship.max_limit.value;
						var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
					}
					
					if(GET_PRICE1 != undefined)
					{
						if(GET_PRICE1.recordcount==0)
							alert("<cf_get_lang dictionary_id='45650.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma  Paket Tipini(Desi) Kontrol Ediniz (Fiyat Listesi)'>!");
						else
						{
							if(desi_sum<document.add_packet_ship.max_limit.value)
							{
								desi_price_sum = GET_PRICE1.PRICE;
							}
							else
							{					
								var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30','dsn',0,document.add_packet_ship.transport_comp_id.value);
								desi_remain2 = parseFloat(desi_sum-document.add_packet_ship.max_limit.value);
								desi_price_sum = parseFloat(GET_PRICE1.PRICE)+parseFloat(GET_PRICE_30.PRICE*desi_remain2);
							}
						}
					}
				}
				
				if(count_kg != 0)
				{
		
					if(kg_sum<document.add_packet_ship.max_limit.value)
					{
						var listParam = document.add_packet_ship.transport_comp_id.value + "*" + document.add_packet_ship.ship_method_id.value + "*" + kg_sum;
						var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
					}
					else
					{
						var listParam = document.add_packet_ship.transport_comp_id.value + "*" + document.add_packet_ship.ship_method_id.value + "*" + document.add_packet_ship.max_limit.value;
						var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
					}
					
					if(GET_PRICE1 != undefined)
					{
						if(GET_PRICE1.recordcount==0)
							alert("<cf_get_lang dictionary_id='45651.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma  Paket Tipini(Kg) Kontrol Ediniz (Fiyat Listesi)'>!");
						else
						{
							if(kg_sum<document.add_packet_ship.max_limit.value)
								kg_price_sum = GET_PRICE1.PRICE;
							else
							{	
								var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30_2','dsn',0,document.add_packet_ship.transport_comp_id.value);
								kg_remain2 = parseFloat(kg_sum-document.add_packet_ship.max_limit.value);
								kg_remain2 = Math.ceil(kg_remain2);
								kg_price_sum = parseFloat(GET_PRICE1.PRICE)+parseFloat(GET_PRICE_30.PRICE*kg_remain2);
							}
						}
					}
				}
		
				eval("add_packet_ship.total_cost_value"+temp_row_count_other).value = commaSplit(parseFloat(desi_price_sum)+parseFloat(kg_price_sum)+parseFloat(envelope_price_sum));
				//document.add_packet_ship.total_cost_value.value = commaSplit(parseFloat(desi_price_sum)+parseFloat(kg_price_sum)+parseFloat(envelope_price_sum));*/
			}
			return kur_hesapla();
		}
	}
	
	function control()
	{
		if(document.add_packet_ship.options_kontrol.value==0 || document.add_packet_ship.options_kontrol.value == "")
		{	
			alert("<cf_get_lang dictionary_id='45651.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma  Paket Tipini(Kg) Kontrol Ediniz (Fiyat Listesi)'>!");
			return false;
		}
		
		if(add_packet_ship.ship_method_id.value == "")	
		{
			alert("<cf_get_lang dictionary_id='45482.Lütfen Sevk Yöntemi Seçiniz'>!");
			return false;
		}
		
		if(add_packet_ship.transport_comp_id.value == "")	
		{
			alert("<cf_get_lang dictionary_id='45495.Taşıyıcı Seçiniz'>!");
			return false;
		}
		
		if(kontrol_row_count == 0)
		{
			alert("<cf_get_lang dictionary_id='45661.En Az Bir Satır İrsaliye Kaydı Giriniz'>!");
			return false;
		}	
		
		//Cari ve irsaliye kontrolleri
		temp_satir=0;	
		for(cr=1;cr<=add_packet_ship.record_num.value;cr++)
		{
			deger_row_kontrol = eval("document.add_packet_ship.row_kontrol"+cr).value;
			deger_company_id = eval("document.add_packet_ship.company_id"+cr).value;
			deger_consumer_id = eval("document.add_packet_ship.consumer_id"+cr).value;
			deger_ship_id = eval("document.add_packet_ship.ship_id"+cr).value;
			deger_cari_kontrol = eval("document.add_packet_ship.cari_kontrol"+cr).value;
			if(deger_row_kontrol == 1)
			{
				temp_satir++;
				if(deger_company_id=="" && deger_consumer_id=="")
				{
					alert(temp_satir + ".<cf_get_lang dictionary_id='45657.Satır İçin'><cf_get_lang dictionary_id='45308.Cari Hesap Seçmelisiniz'>");
					return false;
				}
				if(deger_ship_id == "")
				{
					alert(temp_satir + "<cf_get_lang dictionary_id='45657.Satır İçin'><cf_get_lang dictionary_id='45483.İrsaliye Seçiniz'>!");
					return false;
				}
				if(deger_cari_kontrol != "")
				{
					alert(temp_satir + ".<cf_get_lang dictionary_id='45662.Satır İçin Cari Değerini Kontrol Ediniz'>!");
					return false;
				}			
			}
		}
	
		// Paket kontrolleri
		for(r=1;r<=add_packet_ship.record_num_other.value;r++)
		{
			deger_row_kontrol_other = eval("document.add_packet_ship.row_kontrol_other"+r);
			deger_package_type = eval("document.add_packet_ship.package_type"+r);
			if(deger_row_kontrol_other.value == 1)
			{
				if(deger_package_type.value == "")
				{
					alert("<cf_get_lang dictionary_id='45484.Lütfen Paket Tipi Giriniz'>!");
					return false;
				}
			}
		}
		
		if(process_cat_control())
			return paper_control(add_packet_ship.transport_no1,'SHIP_FIS');
		else
			return false;	
	}
	
	function kur_hesapla()
	{
		total_cost_value = 0;
		if(document.add_packet_ship.calculate_type[1].checked)
		{		
			for(r=1;r<=add_packet_ship.record_num_other.value;r++)
			{	
				if(eval("document.add_packet_ship.row_kontrol_other"+r).value == 1)
				{
					var temp_other_money = eval("document.add_packet_ship.other_money"+r);
					var temp_total_price = eval("document.add_packet_ship.total_price"+r);
					
					if(temp_total_price.value != '')
					{
						temp_sira = list_find(money_list,temp_other_money.value);	
						temp_rate1 = list_getat(rate1_list,temp_sira);
						temp_rate2 = list_getat(rate2_list,temp_sira);
						temp_deger = parseFloat(parseFloat(filterNum(temp_total_price.value)) / ((parseFloat(temp_rate1) / parseFloat(temp_rate2))));
						total_cost_value = parseFloat(total_cost_value) + parseFloat(temp_deger);
					}
				}
			}
			temp2_sira = list_find(money_list,<cfoutput>'#session.ep.money2#'</cfoutput>); 
			temp2_rate1 = list_getat(rate1_list,temp2_sira);
			temp2_rate2 = list_getat(rate2_list,temp2_sira);
			total_cost2_value = total_cost_value * (parseFloat(temp2_rate1) / parseFloat(temp2_rate2));
			document.add_packet_ship.total_cost_value.value = commaSplit(total_cost_value);
			document.add_packet_ship.total_cost2_value.value = commaSplit(total_cost2_value);
		}
		else
		{
			for(rk=1;rk<=add_packet_ship.record_num.value;rk++)
			{
				
				temp2_sira = list_find(money_list,<cfoutput>'#session.ep.money2#'</cfoutput>); 
				temp2_rate1 = list_getat(rate1_list,temp2_sira);
				temp2_rate2 = list_getat(rate2_list,temp2_sira);
				temp_total_cost_value = eval("add_packet_ship.total_cost_value"+rk).value;
				total_cost2_value = parseFloat(filterNum(temp_total_cost_value)) * ((parseFloat(temp2_rate1) / parseFloat(temp2_rate2)));
				eval("add_packet_ship.total_cost2_value"+rk).value = commaSplit(total_cost2_value);
				//document.add_packet_ship.total_cost2_value.value = commaSplit(total_cost2_value);
			}
		}
		
		sum_total_cost_value = 0;
		sum_total_cost2_value = 0;
		
		for(r=1;r<=add_packet_ship.record_num.value;r++)
		{
			if(eval("document.add_packet_ship.row_kontrol"+r).value == 1)
			{
				var temp =eval("add_packet_ship.total_cost_value"+r);
				var temp2 =eval("add_packet_ship.total_cost2_value"+r);
				temp_total_cost_value = filterNum(temp.value);
				temp_total_cost2_value = filterNum(temp2.value);
		
				sum_total_cost_value = sum_total_cost_value+temp_total_cost_value;
				sum_total_cost2_value = sum_total_cost2_value+temp_total_cost2_value;			
			}		
		}
		
		add_packet_ship.total_cost_value.value = commaSplit(sum_total_cost_value);
		add_packet_ship.total_cost2_value.value = commaSplit(sum_total_cost2_value);
	
		return true;
	}
	
	function unformat_fields()
	{
		for(r=1;r<=add_packet_ship.record_num_other.value;r++)
		{
			if(eval("document.add_packet_ship.row_kontrol_other"+r).value == 1)
			{
				eval("document.add_packet_ship.quantity"+r).value = filterNum(eval("document.add_packet_ship.quantity"+r).value);
				eval("document.add_packet_ship.ship_agirlik"+r).value = filterNum(eval("document.add_packet_ship.ship_agirlik"+r).value);
				eval("document.add_packet_ship.total_price"+r).value = filterNum(eval("document.add_packet_ship.total_price"+r).value);
			}
		}
		for(kr=1;kr<=add_packet_ship.record_num.value;kr++)
		{
			if(eval("document.add_packet_ship.row_kontrol"+kr).value == 1)
			{
				eval("document.add_packet_ship.total_cost_value"+kr).value = filterNum(eval("document.add_packet_ship.total_cost_value"+kr).value);
				eval("document.add_packet_ship.total_cost2_value"+kr).value = filterNum(eval("document.add_packet_ship.total_cost2_value"+kr).value);
	
			}
		}	
	}
	
	function kontrol_prerecord()
	{
		if(document.add_packet_ship.transport_comp_id.value != "")
		{
	
			var GET_MAX_LIMIT = wrk_safe_query('stk_get_max_limit','dsn',0,document.add_packet_ship.transport_comp_id.value);//Seçilen taşıyıcıya ait yapılmış bir tanımlama değeri varsa.
			if(GET_MAX_LIMIT.recordcount > 0)
			{
				document.add_packet_ship.max_limit.value=GET_MAX_LIMIT.MAX_LIMIT;
				if(GET_MAX_LIMIT.CALCULATE_TYPE==1)
				{
					document.add_packet_ship.calculate_type[0].checked = true;
					document.add_packet_ship.options_kontrol.value=1;/*Form'u kontrol etmek için,*/
				}
				else if	(GET_MAX_LIMIT.CALCULATE_TYPE==2)
				{
					document.add_packet_ship.calculate_type[1].checked=true;
					document.add_packet_ship.options_kontrol.value=1;/*Form'u kontrol etmek için,*/
				}
				for(xx=1;xx<=add_packet_ship.record_num_other.value;xx++)
				{
					deger_row_kontrol_other = eval("document.add_packet_ship.row_kontrol_other"+xx);
					if(deger_row_kontrol_other.value == 1)
						degistir(xx);
				}			
			}
			else		
			{
				alert("<cf_get_lang dictionary_id='45663.Lütfen Hesaplama için Tasıyıcı Firmayı Kontrol Ediniz (Fiyat Listesi)'>!");
				
				document.add_packet_ship.calculate_type[0].checked=false;
				document.add_packet_ship.calculate_type[1].checked=false;
				document.add_packet_ship.options_kontrol.value=0;
				document.add_packet_ship.max_limit.value=0;
				return false;	
			}
		}
	}
		// Emirler Ekranından Toplu Sevkiyat ile geliyorsa
		<cfif isdefined("attributes.is_logistic") and len(attributes.is_logistic)>
			<cfoutput query="add_logistic">
			<cfif not (member_id[currentrow] neq member_id[currentrow-1])>
				<cfquery name="GET_LINE" dbtype="query" maxrows="1">
					SELECT LINE FROM ALL_LOGISTIC WHERE MEMBER_TYPE = #add_logistic.member_type# AND MEMBER_ID = #add_logistic.member_id# ORDER BY LINE
				</cfquery>
			
				deger_row_count_list = eval("document.add_packet_ship.row_count_" +#get_line.line#+ "_list");
			</cfif>
				row_count++;
				kontrol_row_count++;
					
				var newRow;
				var newCell;
				newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
				newRow.setAttribute("name","frm_row" + row_count);
				newRow.setAttribute("id","frm_row" + row_count);		
				newRow.setAttribute("NAME","frm_row" + row_count);
				newRow.setAttribute("ID","frm_row" + row_count);		
				document.add_packet_ship.record_num.value=row_count;
			
				newCell = newRow.insertCell(newRow.cells.length);
			<cfif (member_id[currentrow] neq member_id[currentrow-1])>
				newCell.innerHTML = '<input  type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" value="1"><input type="hidden" name="row_count_' + row_count +'_list" id="row_count_' + row_count +'_list" value=""><input type="hidden" name="related_row_kontrol' + row_count +'" id="related_row_kontrol' + row_count +'" value="">&nbsp;<a style="cursor:pointer" onclick="add_row2(' + row_count + ');"><img title="İlişkili İrsaliye Ekle" src="images/button_gri.gif" border="0"></a>&nbsp;<a style="cursor:pointer" onclick="add_row_other(' + row_count + ');"><img title="Paket Ekle" src="images/plus_list.gif" border="0"></a>&nbsp;<a style="cursor:pointer" onclick="sil(' + row_count + ');"><img title="Sil" src="images/delete_list.gif" border="0"></a>';
			<cfelse>
				newCell.innerHTML = '<input  type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" value="1"><input type="hidden" name="row_count_' + row_count +'_list" id="row_count_' + row_count +'_list" value=""><input type="hidden" name="related_row_kontrol' + row_count +'" id="related_row_kontrol' + row_count +'" value="#get_line.line#">';<!--- <a style="cursor:pointer" onclick="add_row2(' + row_count + ');"><img title="İlişkili İrsaliye Ekle" src="images/button_gri.gif" border="0"></a>&nbsp;<a style="cursor:pointer" onclick="add_row_other(' + row_count + ');"><img title="Paket Ekle" src="images/plus_list.gif" border="0"></a>&nbsp;<a style="cursor:pointer" onclick="sil(' + row_count + ');"><img title="Sil" src="images/delete_list.gif" border="0"></a> --->
				if(deger_row_count_list.value == '')
					deger_row_count_list.value = #currentrow#;
				else
					deger_row_count_list.value += ','+#currentrow#;			
			</cfif>
			<cfif len(add_logistic.company_id)>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="hidden" name="cari_kontrol' + row_count +'" id="cari_kontrol' + row_count +'" value=""><input type="hidden" name="cari_' + row_count +'_ship_id_list" id="cari_' + row_count +'_ship_id_list" value=""><input type="hidden" name="consumer_id' + row_count +'" id="consumer_id' + row_count +'" value=""><input type="hidden" name="company_id' + row_count +'" id="company_id' + row_count +'" value="#add_logistic.company_id#"><input type="hidden" name="partner_id' + row_count +'" id="partner_id' + row_count +'" value="#add_logistic.partner_id#"><input type="text" name="member_name' + row_count +'" id="member_name' + row_count +'" value="#add_logistic.member_name#" readonly style="width:150px;"> <a href="javascript://"><img src="/images/plus_thin.gif" onClick="pencere_ac_cari('+ row_count +');" align="absmiddle" border="0"></a>';
			<cfelse>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="hidden" name="cari_kontrol' + row_count +'" id="cari_kontrol' + row_count +'" value=""><input type="hidden" name="cari_' + row_count +'_ship_id_list" id="cari_' + row_count +'_ship_id_list" value=""><input type="hidden" name="consumer_id' + row_count +'" id="consumer_id' + row_count +'" value="#add_logistic.consumer_id#"><input type="hidden" name="company_id' + row_count +'" id="company_id' + row_count +'" value=""><input type="hidden" name="partner_id' + row_count +'" id="partner_id' + row_count +'" value=""><input type="text" name="member_name' + row_count +'" id="member_name' + row_count +'" value="#add_logistic.member_name#" readonly style="width:150px;"> <a href="javascript://"><img src="/images/plus_thin.gif" onClick="pencere_ac_cari('+ row_count +');" align="absmiddle" border="0"></a>';
			</cfif>	
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="hidden" name="ship_id' + row_count +'" id="ship_id' + row_count +'" value="#add_logistic.ship_id#"><input type="text" name="ship_number' + row_count +'" id="ship_number' + row_count +'"  value="#add_logistic.ship_number#" readonly style="width:110px;"> <a href="javascript://"><img src="/images/plus_thin.gif" onClick="pencere_ac('+ row_count +');" align="absmiddle" border="0"></a>';
				
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="hidden" name="ship_deliver' + row_count +'" id="ship_deliver' + row_count +'" value="#add_logistic.member_name2#"><input type="text" name="ship_date' + row_count +'" id="ship_date' + row_count +'" value="#dateformat(add_logistic.ship_date,dateformat_style)#" readonly style="width:65px;">';
				
			<cfif len(add_logistic.ship_method)>
				<cfquery name="GET_SHIP_METHOD" datasource="#DSN#"> 
					SELECT SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID = #add_logistic.ship_method#
				</cfquery>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="ship_type' + row_count +'" id="ship_type' + row_count +'" value="#get_ship_method.ship_method#" readonly style="width:150px;">';
			<cfelse>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="ship_type' + row_count +'" id="ship_type' + row_count +'" value="" readonly style="width:150px;">';
			</cfif>
				
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="ship_adress' + row_count +'" id="ship_adress' + row_count +'" value="#replace(address,"#Chr(13)##chr(10)#"," ","all")#" readonly style="width:200px;">';
				
			<cfif (member_id[currentrow] neq member_id[currentrow-1])>
				/* maliyet1 */
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="total_cost_value' + row_count +'" id="total_cost_value' + row_count +'" value="#TlFormat(0)#" class="moneybox" readonly style="width:74px;">&nbsp;#session.ep.money#</div>;
				/* maliyet2 */
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="total_cost2_value' + row_count +'" id="total_cost2_value' + row_count +'" value="#TlFormat(0)#" class="moneybox" readonly style="width:74px;">&nbsp;#session.ep.money2#'</div>;
			<cfelse>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="hidden" name="total_cost_value' + row_count +'" id="total_cost_value' + row_count +'" value="#TlFormat(0)#" class="moneybox" readonly style="width:74px;"><input type="hidden" name="total_cost2_value' + row_count +'" id="total_cost2_value' + row_count +'" value="#TlFormat(0)#" class="moneybox" readonly style="width:74px;">';
			</cfif>
			</cfoutput>
			<cfif get_control_.recordcount>
				alert('<cf_get_lang dictionary_id='45767.Daha Önce Sevk Edilmiş Kayıtlar'> : <cfoutput>#valuelist(get_control_.ship_number)#</cfoutput>');
			</cfif>
		</cfif>
	</script>
	