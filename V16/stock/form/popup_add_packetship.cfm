<cf_xml_page_edit fuseact="stock.popup_add_packetship">
<cfinclude template="../query/get_moneys.cfm">
<cfinclude template="../query/get_package_type.cfm">
<cfquery name="GET_ORDER" datasource="#DSN3#">
	SELECT 
		ORDERS.ORDER_NUMBER,
		ORDERS.ORDER_DATE,
		ORDERS.SHIP_METHOD,
		ORDERS.SHIP_ADDRESS,
		ORDERS.COMPANY_ID,
		ORDERS.PARTNER_ID,
		ORDERS.CONSUMER_ID,
		COMPANY_CREDIT.SHIP_METHOD_ID SHIP_METHOD_ID,
		COMPANY_CREDIT.TRANSPORT_COMP_ID TRANSPORT_COMP_ID,
		COMPANY_CREDIT.TRANSPORT_DELIVER_ID TRANSPORT_DELIVER_ID
	FROM
		ORDERS
	        LEFT JOIN #dsn_alias#.COMPANY_CREDIT COMPANY_CREDIT ON ORDERS.COMPANY_ID = COMPANY_CREDIT.COMPANY_ID AND COMPANY_CREDIT.OUR_COMPANY_ID = #session.ep.company_id#
	WHERE
		ORDERS.ORDER_ID = #attributes.order_id#
</cfquery>
<cfif len(get_order.ship_method) or len(get_order.ship_method_id)>
	<cfquery name="GET_SHIP_METHOD" datasource="#DSN#">
		SELECT SHIP_METHOD,SHIP_METHOD_ID FROM SHIP_METHOD WHERE SHIP_METHOD_ID =<cfif len(get_order.ship_method)>#get_order.ship_method#<cfelse>#get_order.SHIP_METHOD_ID#</cfif> 
	</cfquery>
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getlang('','Sevkiyat Planla	',65452)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="add_packet_ship" id="add_packet_ship" method="post" action="#request.self#?fuseaction=stock.emptypopup_add_packetship_order&order_id=#url.order_id#">
			<cf_papers paper_type="ship_fis" form_name="add_packet_ship" form_field="transport_no1">
			<input type="hidden" name="is_type" id="is_type" value="<cfoutput>#url.is_type#</cfoutput>">
			<input type="hidden" name="order_comp" id="order_comp" value="<cfoutput>#get_par_info(get_order.company_id,1,0,0)#</cfoutput>">
			<input type="hidden" name="order_cons" id="order_cons" value="<cfoutput>#get_cons_info(get_order.consumer_id,1,0,0)#</cfoutput>">
			<input type="hidden" name="order_number" id="order_number" value="<cfoutput>#get_order.order_number#</cfoutput>">
			<cfinput type="hidden" name="draggable" id="draggable" value="#iif(isdefined("attributes.draggable"),1,0)#">
			<cfif len(get_order.ship_address)>
				<input type="hidden" name="order_adress" id="order_adress" value="<cfoutput>#get_order.ship_address#</cfoutput>">
			<cfelse>
				<input type="hidden" name="order_adress" id="order_adress" value="">
			</cfif>
			<cfif len(get_order.ship_method)>
				<input type="hidden" name="order_type" id="order_type" value="<cfoutput>#get_ship_method.ship_method#</cfoutput>">
			<cfelse>
				<input type="hidden" name="order_type" id="order_type" value="">
			</cfif>
			<input type="hidden" name="order_date" id="order_date" value="<cfoutput>#dateformat(get_order.order_date,dateformat_style)#</cfoutput>">
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="12" sort="true">
                    <div class="form-group" id="item-order_process">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58859.Süreç'>*</label>
                        <div class="col col-8 col-sm-12">
                            <cf_workcube_process is_upd='0' process_cat_width='170' is_detail='0'>
                        </div>
                    </div>
					<div class="form-group" id="item-consumer_id">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57519.Cari Hesap'>*</label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
								<cfif len(attributes.order_id)>
									<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#get_order.consumer_id#</cfoutput>">
									<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_order.company_id#</cfoutput>">
									<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_order.partner_id#</cfoutput>">
									<input type="text" name="company" id="company" value="<cfoutput>#get_par_info(get_order.company_id,1,0,0)#</cfoutput>" readonly >
								<cfelse>
									<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
									<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
									<input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined("attributes.partner_id")><cfoutput>#attributes.partner_id#</cfoutput></cfif>">
									<input type="text" name="company" id="company" value="<cfif isdefined("attributes.company")><cfoutput>#attributes.company#</cfoutput></cfif>" readonly >
								</cfif>
								<cfset str_linke_ait="&field_comp_id=add_packet_ship.company_id&field_partner=add_packet_ship.partner_id&field_consumer=add_packet_ship.consumer_id&field_comp_name=add_packet_ship.company&field_name=add_packet_ship.member_name&ship_method_id=add_packet_ship.ship_method_id&ship_method_name=add_packet_ship.ship_method_name&field_trans_comp_id=add_packet_ship.transport_comp_id&field_trans_comp_name=add_packet_ship.transport_comp_name&field_trans_deliver_id=add_packet_ship.transport_deliver_id&field_trans_deliver_name=add_packet_ship.transport_deliver_name">
								<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#</cfoutput>&select_list=7,8');"></span>
							</div>
                        </div>
                    </div>
					<div class="form-group" id="item-member_name">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57578.Yetkili'>*</label>
                        <div class="col col-8 col-sm-12">
							<cfif len(attributes.order_id)>
								<input type="text" name="member_name" id="member_name" value="<cfoutput>#get_par_info(get_order.partner_id,0,-1,0)#</cfoutput>" readonly >
							<cfelse>
								<input type="text" name="member_name" id="member_name" value="<cfif isdefined("attributes.member_name")><cfoutput>#attributes.member_name#</cfoutput></cfif>" readonly >
							</cfif>
                        </div>
                    </div>
					<div class="form-group" id="item-ship_method_name">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'>*</label>
                        <div class="col col-8 col-sm-12">
                           <div class="input-group">
								<input type="hidden" name="ship_method_id" id="ship_method_id" value="<cfif isdefined("attributes.ship_method_id")><cfoutput>#attributes.ship_method_id#</cfoutput><cfelseif isdefined('get_ship_method')><cfoutput>#get_ship_method.ship_method_id#</cfoutput></cfif>">
								<input type="text" name="ship_method_name" id="ship_method_name" value="<cfif isdefined("attributes.ship_method_name")><cfoutput>#attributes.ship_method_name#</cfoutput><cfelseif isdefined('get_ship_method')><cfoutput>#get_ship_method.ship_method#</cfoutput></cfif>" readonly >
								<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=add_packet_ship.ship_method_name&field_id=add_packet_ship.ship_method_id');"></span>
						   </div>
                        </div>
                    </div>
					<div class="form-group" id="item-transport_comp_id">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57716.Taşıyıcı'>*</label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
								<input type="hidden" name="transport_comp_id" id="transport_comp_id" value="<cfif len(get_order.transport_comp_id)><cfoutput>#get_order.transport_comp_id#</cfoutput></cfif>">
								<input type="text" name="transport_comp_name" id="transport_comp_name" value="<cfif len(get_order.transport_comp_id)><cfoutput>#get_par_info(get_order.transport_comp_id,1,0,0)#</cfoutput></cfif>" readonly >
								<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=add_packet_ship.transport_comp_id&field_comp_name=add_packet_ship.transport_comp_name&field_partner=add_packet_ship.transport_deliver_id&field_name=add_packet_ship.transport_deliver_name&select_list=2');"></span>
							</div>
                        </div>
                    </div>
					<div class="form-group" id="item-transport_deliver_name">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='35783.Taşıyıcı Yetkilisi'></label>
                        <div class="col col-8 col-sm-12">
                            <input type="hidden" name="transport_deliver_id" id="transport_deliver_id" value="<cfif len(get_order.transport_comp_id)><cfoutput>#get_order.transport_deliver_id#</cfoutput></cfif>">
							<input type="text" name="transport_deliver_name" id="transport_deliver_name" readonly  value="<cfif len(get_order.transport_comp_id)><cfoutput>#get_par_info(get_order.transport_deliver_id,0,-1,0)#</cfoutput></cfif>">
                        </div>
                    </div>
					<div class="form-group" id="item-assetp_name">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58480.Araç'></label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
								<cfif is_manuel_asset eq 0>
									<cfif isdefined("attributes.assetp_id")>
										<cfquery name="GET_ASSETP" datasource="#DSN#">
											SELECT ASSETP, POSITION_CODE FROM ASSET_P WHERE ASSETP_ID = #attributes.assetp_id#
										</cfquery>
										<input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#attributes.assetp_id#</cfoutput>">
									<cfelse>
										<input type="hidden" name="assetp_id" id="assetp_id">
										<input type="text" name="assetp_name" id="assetp_name" value="" >
									</cfif>
									<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=add_packet_ship.assetp_id&field_name=add_packet_ship.assetp_name&field_emp_id=add_packet_ship.vehicle_emp_id&field_emp_name=add_packet_ship.vehicle_emp_name');"></span>
								<cfelse>
									<input type="text" name="assetp_name" id="assetp_name" value="" maxlength="50" >
								</cfif>	
							</div>
                        </div>
                    </div>
					<div class="form-group" id="item-vehicle_emp_name">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='34802.Araç Yetkilisi'></label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
								<cfif is_manuel_asset eq 0>
									<cfif isdefined("attributes.assetp_id")>
										<input type="hidden" name="vehicle_emp_id" id="vehicle_emp_id" value="<cfif len(get_assetp.position_code)><cfoutput>#get_assetp.position_code#</cfoutput></cfif>">
										<input type="text" name="vehicle_emp_name" id="vehicle_emp_name" value="<cfif len(get_assetp.position_code)><cfoutput>#get_emp_info(get_assetp.position_code,1,0)#</cfoutput></cfif>" >
									<cfelse>
										<input type="hidden" name="vehicle_emp_id" id="vehicle_emp_id" value="">
										<input type="text" name="vehicle_emp_name" id="vehicle_emp_name" >
									</cfif>
									<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=add_packet_ship.vehicle_emp_name&field_emp_id=add_packet_ship.vehicle_emp_id&select_list=1');"></span>
								<cfelse>
									<input type="text" name="vehicle_emp_name" id="vehicle_emp_name" maxlength="150" >
								</cfif>	
							</div>
                        </div>
                    </div>
					<div class="form-group" id="item-plate">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='29453.Plaka'></label>
                        <div class="col col-8 col-sm-12">
                            <input name="plate" id="plate" type="text" maxlength="50" >
                        </div>
                    </div>
					<div class="form-group" id="item-plate">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                        <div class="col col-8 col-sm-12">
                            <textarea name="note" id="note" style="width:170px;height:45px;"></textarea>
                        </div>
                    </div>
					<cfif is_show_insurance_comp eq 1>
						<div class="form-group" id="item-insurance_comp_name">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='39459.Sigorta Firması'></label>
							<div class="col col-8 col-sm-12">
								<div class="input-group">
									<input type="hidden" name="insurance_comp_id" id="insurance_comp_id" value="">
									<input type="text" name="insurance_comp_name"  id="insurance_comp_name" value="" readonly >
									<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=add_packet_ship.insurance_comp_id&field_comp_name=add_packet_ship.insurance_comp_name&field_partner=add_packet_ship.insurance_comp_partner_id&field_name=add_packet_ship.insurance_comp_partner_name&select_list=2');"></span>
								</div>
							</div>
						</div>
					</cfif>
					<cfif is_show_insurance_comp eq 1>
						<div class="form-group" id="item-insurance_comp_partner_name">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='45240.Sigorta Yetkilisi'></label>
							<div class="col col-8 col-sm-12">
								<input type="hidden" name="insurance_comp_partner_id" id="insurance_comp_partner_id" value="">
								<input type="text" name="insurance_comp_partner_name" id="insurance_comp_partner_name" readonly  value="">
							</div>
						</div>
					</cfif>
				</div>
				<div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="13" sort="true">
					<div class="form-group" id="item-transport_no1">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='34775.Sevkiyat No'>*</label>
                        <div class="col col-8 col-sm-12">
                            <input name="transport_no1" id="transport_no1" type="text" value="<cfoutput>#paper_code & '-' & paper_number#</cfoutput>" readonly >
                        </div>
                    </div>
					<div class="form-group" id="item-transport_paper_no">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='34792.Taşıyıcı Belge No'></label>
                        <div class="col col-8 col-sm-12">
                            <cfinput name="transport_paper_no" id="transport_paper_no" type="text" maxlength="25" >
                        </div>
                    </div>
					<div class="form-group" id="item-reference_no">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58794.Referans No'></label>
                        <div class="col col-8 col-sm-12">
                            <input type="text" name="reference_no" id="reference_no" value="" maxlength="25" >
                        </div>
                    </div>
					<cfif is_show_warehouse_date eq 1>
						<div class="form-group" id="item-warehouse_entry_date">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='45227.Depo Giriş Tarihi'></label>
							<div class="col col-4 col-sm-12">
								<div class="input-group">
									<cfinput type="text" name="warehouse_entry_date" id="warehouse_entry_date" validate="#validate_style#"  value="#dateformat(now(),dateformat_style)#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="warehouse_entry_date"></span>
								</div>
							</div>
							<div class="col col-2 col-sm-12">
								<cf_wrkTimeFormat name="warehouse_entry_h" value="0">
							</div>
							<div class="col col-2 col-sm-12">
								<select name="warehouse_entry_m" id="warehouse_entry_m">
									<cfoutput>
										<cfloop from="0" to="59" index="i">
											<option value="#numberformat(i,00)#">#numberformat(i,00)#</option>
										</cfloop>
									</cfoutput>
								</select>
							</div>
						</div>
					</cfif>
					<div class="form-group" id="item-action_date">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='45463.Depo Çıkış Tarihi'></label>
                        <div class="col col-4 col-sm-12">
                            <div class="input-group">
								<cfinput type="text" name="action_date" id="action_date" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" required="Yes" message="#getLang('','	Depo Çıkış Tarihi Girmelisiniz',45464)#" >
								<span class="input-group-addon"><cf_wrk_date_image date_field="action_date"></span>
							</div>
                        </div>
						<div class="col col-2 col-sm-12">
							<cf_wrkTimeFormat name="start_h" value="0">
						</div>
						<div class="col col-2 col-sm-12">
							<select name="start_m" id="start_m">
								<cfoutput>
									<cfloop from="0" to="59" index="i">
										<option value="#numberformat(i,00)#">#numberformat(i,00)#</option>
									</cfloop>
								</cfoutput>
							</select>
						</div>
                    </div>
					<div class="form-group" id="item-deliver_date">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57645.Teslim Tarihi'></label>
                        <div class="col col-4 col-sm-12">
							<div class="input-group">
								<cfinput type="text" name="deliver_date" id="deliver_date" value="" validate="#validate_style#"  message="#getLang('','Lütfen Teslim Tarihi Formatını Doğru Giriniz',45647)#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="deliver_date"></span>
							</div>
                        </div>
						<div class="col col-2 col-sm-12">
							<cf_wrkTimeFormat name="deliver_h" value="0">
						</div>
						<div class="col col-2 col-sm-12">
							<select name="deliver_m" id="deliver_m">
								<cfoutput>
									<cfloop from="0" to="59" index="i">
										<option value="#numberformat(i,00)#">#numberformat(i,00)#</option>
									</cfloop>
								</cfoutput>
							</select>
						</div>
                    </div>
					<div class="form-group" id="item-deliver_name2">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='33211.Teslim Eden'></label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
								<input type="hidden" name="deliver_id2" id="deliver_id2" value="<cfoutput>#session.ep.userid#</cfoutput>">
								<input type="text" name="deliver_name2" id="deliver_name2" value="<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>" readonly >
								<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id2=add_packet_ship.deliver_id2&field_name=add_packet_ship.deliver_name2&select_list=1');"></span>
							</div>
                        </div>
                    </div>
					<div class="form-group" id="item-department_name">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='29428.Çıkış Depo'> <cfif is_department_required eq 1>*</cfif></label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
								<input type="hidden" name="branch_id" id="branch_id" value="<cfif isdefined("attributes.branch_id")><cfoutput>#attributes.branch_id#</cfoutput></cfif>">
								<input type="hidden" name="department_id" id="department_id" value="<cfif isdefined("attributes.department_id")><cfoutput>#attributes.department_id#</cfoutput></cfif>">
								<input type="hidden" name="location_id" id="location_id" value="<cfif isdefined("attributes.location_id")><cfoutput>#attributes.location_id#</cfoutput></cfif>">
								<cfif isdefined("attributes.department_name")>
									<cfinput type="text" name="department_name" id="department_name" value="#attributes.department_name#" readonly="yes" message="#getLang('','Yaptığınız İşleme Bağlı Olarak Depo Girmelisiniz',45473)#!" >
								<cfelse>
									<cfinput type="text" name="department_name" id="department_name" value="" readonly="yes" message="#getLang('','Yaptığınız İşleme Bağlı Olarak Depo Girmelisiniz',45473)#!" >
								</cfif>
								<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_stores_locations&form_name=add_packet_ship&field_name=department_name&field_id=department_id&field_location_id=location_id&branch_id=branch_id')" ></span>
							</div>
                        </div>
                    </div>
					<cfif is_show_duty_comp eq 1>
						<div class="form-group" id="item-duty_comp_name">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='39462.Gümrük Firması'></label>
							<div class="col col-8 col-sm-12">
								<div class="input-group">
									<input type="hidden" name="duty_comp_id" id="duty_comp_id" value="">
									<input type="text" name="duty_comp_name" id="duty_comp_name" value="" readonly >
									<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=add_packet_ship.duty_comp_id&field_comp_name=add_packet_ship.duty_comp_name&field_partner=add_packet_ship.duty_comp_partner_id&field_name=add_packet_ship.duty_comp_partner_name&select_list=2');"></span>
								</div>
							</div>
						</div>
					</cfif>
					<cfif is_show_duty_comp eq 1>
						<div class="form-group" id="item-duty_comp_partner_name">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='45251.Gümrük Yetkilisi'></label>
							<div class="col col-8 col-sm-12">
								<input type="hidden" name="duty_comp_partner_id" id="duty_comp_partner_id" value="">
								<input type="text" name="duty_comp_partner_name" id="duty_comp_partner_name" readonly  value="">
							</div>
						</div>
					</cfif>
					<cfif is_show_cost eq 1>
						<div class="form-group" id="item-total_cost_value">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='35782.Maliyet Tutarı'></label>
							<div class="col col-3 col-sm-12">
								<input type="text" name="total_cost_value" id="total_cost_value" value="<cfoutput>#TlFormat(0)#</cfoutput>" onKeyup="return(FormatCurrency(this,event));" class="moneybox" readonly >
							</div>
							<div class="col col-1 col-sm-12">
								<label><cfoutput>#session.ep.money#</cfoutput></label>
							</div>
							<div class="col col-3 col-sm-12">
								<input type="text" name="total_cost2_value" id="total_cost2_value" value="<cfoutput>#TlFormat(0)#</cfoutput>" onKeyup="return(FormatCurrency(this,event));" class="moneybox" readonly >
							</div>
							<div class="col col-1 col-sm-12">
								<label><cfoutput>#session.ep.money2#</cfoutput></label>
							</div>
						</div>
					</cfif>
					<cfif is_show_cost eq 1>
						<div class="form-group" id="item-options_kontrol">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='43490.Hes. Yöntemi'></label>
							<input type="hidden" name="max_limit" id="max_limit" value="">
							<input type="hidden" name="options_kontrol" id="options_kontrol" value=""><!--- Bu alan disabled olan asagidaki radio butonlarin secilip secilmadegini kontrol etmek icin kullaniliyor --->
							<div class="col col-4 col-sm-12">
								<input type="radio" name="calculate_type" id="calculate_type_1" value="1" onclick="change_packet(1);" disabled="disabled"><cf_get_lang no='370.Kümülatif'>&nbsp;
							</div>
							<div class="col col-4 col-sm-12">
								<input type="radio" name="calculate_type" id="calculate_type_2" value="2" onclick="change_packet(2);" disabled="disabled"><cf_get_lang no='371.Paket'><!--- onblur="change_packet(2);" --->	
							</div>
						</div>
					</cfif>
				</div>
				<cfif is_show_cost eq 1>
					<cf_grid_list>
						<thead>
							<tr>
								<th width="20"><input name="record_num_other" id="record_num_other" type="hidden" value="0"><input type="button" class="eklebuton" title="<cf_get_lang dictionary_id='44630.Ekle'>" onClick="add_row_other();"></th>
								<th><cf_get_lang dictionary_id='58082.Adet'> *</th>
								<th><cf_get_lang dictionary_id='34799.Paket Tipi'> *</th>
								<th><cf_get_lang dictionary_id='34800.Ebat'></th>
								<th><cf_get_lang dictionary_id='29784.Ağırlık'> (kg)</th>
								<th><cf_get_lang dictionary_id='57633.Barkod'></th>
								<th><cf_get_lang dictionary_id='35781.Paketleyen'></th>
							</tr>
						</thead>
						<tbody id="table2"></tbody>
					</cf_grid_list>
				</cfif>
			</cf_box_elements>
			<cf_box_footer>
				<cfif is_show_cost eq 1>
					<cf_workcube_buttons is_upd='0' add_function='transport_control(),control()'>
				<cfelse>
					<cf_workcube_buttons is_upd='0' add_function='control()'>    
				</cfif>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>	
	


<script type="text/javascript">
	calculate_type_deger = 1;
	row_count = 0;
	row_count2 = 0;
	
	money_list = "<cfoutput>#valuelist(moneys.money,',')#</cfoutput>";
	rate1_list = "<cfoutput>#valuelist(moneys.rate1,',')#</cfoutput>";
	rate2_list = "<cfoutput>#valuelist(moneys.rate2,',')#</cfoutput>";
	
	function pencere_ac2(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_packet_ship.pack_emp_id'+ no +'&field_name=add_packet_ship.pack_emp_name'+ no+'&select_list=1');
	}
	
	function sil_other(sy)
	{
		var my_element=document.getElementById("row_kontrol_other"+sy);
		my_element.value=0;
		var my_element=eval("frm_row_other"+sy);
		my_element.style.display="none";
		if(document.getElementById("calculate_type_2").checked) /* paket ise */ 
			return kur_hesapla();
		else
			degistir(sy);
	}
	function transport_control()
	{
		if(document.getElementById("transport_comp_id").value != "" )
		{
			var GET_MAX_LIMIT = wrk_safe_query('stk_get_max_limit','dsn',0,document.getElementById("transport_comp_id").value);//Seçilen taşıyıcıya ait yapılmış bir tanımlama değeri varsa.
			document.getElementById("max_limit").value=GET_MAX_LIMIT.MAX_LIMIT;
			if(GET_MAX_LIMIT.CALCULATE_TYPE==1)
			{
				document.getElementById("calculate_type_1").checked=true;
				document.getElementById("options_kontrol").value=1;/*Form'u kontrol etmek için,*/
			}
			else if	(GET_MAX_LIMIT.CALCULATE_TYPE==2)
			{
				document.getElementById("calculate_type_2").checked=true;
				document.getElementById("options_kontrol").value=1;/*Form'u kontrol etmek için,*/
			}
			if(GET_MAX_LIMIT.MAX_LIMIT == undefined)
			{
				alert("<cf_get_lang dictionary_id='63450.Lütfen Hesaplama için Sevk Yöntemi Taşıyıcı Firma Paket Tipini(Kg) Kontrol Ediniz (Fiyat Listesi)'>!"+GET_MAX_LIMIT.recordcount);
				document.getElementById("calculate_type_1").checked=false;
				document.getElementById("calculate_type_2").checked=false;
				document.getElementById("options_kontrol").value=0;
				document.getElementById("max_limit").value=0;
				document.getElementById("transport_comp_id").value= "";
				document.getElementById("transport_comp_name").value= "";
				document.getElementById("transport_deliver_id").value= "";
				document.getElementById("transport_deliver_name").value= "";
				return false;	
			}
		}
	}
	function add_row_other()
	{
		if(document.getElementById("ship_method_id").value == "")
		{
			alert("<cf_get_lang dictionary_id='35327.Lütfen Sevk Yöntemi Seçiniz'>!");
			return false;
		}
		
		if(document.getElementById("transport_comp_id").value == "")
		{
			alert("<cf_get_lang dictionary_id='45495.Taşıyıcı Seçiniz'> !");
			return false;
		}
		transport_control();/*Satır eklerkende taşıyıcıyı kontrol etsin.*/
		row_count2++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);
		newRow.setAttribute("name","frm_row_other" + row_count2);
		newRow.setAttribute("id","frm_row_other" + row_count2);		
		newRow.setAttribute("NAME","frm_row_other" + row_count2);
		newRow.setAttribute("ID","frm_row_other" + row_count2);		
		document.getElementById("record_num_other").value=row_count2;
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_kontrol_other' + row_count2 +'" id="row_kontrol_other' + row_count2 +'" value="1"><a style="cursor:pointer" onclick="sil_other(' + row_count2 + ');"><i class="fa fa-minus"></i></a>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="quantity' + row_count2 +'" id="quantity' + row_count2 +'" onblur="degistir( ' + row_count2 + ');" onKeyup="return(FormatCurrency(this,event,0));" value="<cfoutput>#tlformat(1,0)#</cfoutput>" class="moneybox" ></div>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="package_type' + row_count2 +'" id="package_type' + row_count2 +'" onchange="degistir( ' + row_count2 + ');"><option value="">Seçiniz</option><cfoutput query="get_package_type"><option value="#package_type_id#,#dimention#,#calculate_type_id#">#package_type#</option></cfoutput></select></div>'; //add_general_prom();
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="ship_ebat' + row_count2 +'" id="ship_ebat' + row_count2 +'" value="" readonly "></div>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="ship_agirlik' + row_count2 +'" id="ship_agirlik' + row_count2 +'" value="" onBlur="degistir(' + row_count2 + ');" onKeyup="return(FormatCurrency(this,event));" class="moneybox" ></div>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="total_price' + row_count2 +'" id="total_price' + row_count2 +'" value="" onKeyup="return(FormatCurrency(this,event));" class="moneybox" readonly ><input type="hidden" name="other_money' + row_count2 +'" id="other_money' + row_count2 +'" value="" class="moneybox" readonly ><input type="text" name="ship_barcod' + row_count2 +'" id="ship_barcod' + row_count2 +'" value="" ></div>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="input-group"><input type="hidden" name="pack_emp_id' + row_count2 +'" id="pack_emp_id' + row_count2 +'" value=""><input type="text" name="pack_emp_name' + row_count2 +'" id="pack_emp_name' + row_count2 +'" value="" ><span class="input-group-addon icon-ellipsis" onClick="pencere_ac2('+ row_count2 +');"></span></div>';
	}
	
	function degistir(id)
	{
		row_kontrol_other = document.getElementById("row_kontrol_other"+id);
		if(row_kontrol_other.value == 1)
		{
			if(trim(document.getElementById("quantity"+id).value).length == 0)
				document.getElementById("quantity"+id).value = 1;
		}
		if(document.getElementById("calculate_type_2").checked)
		{
			var temp_package_type = document.getElementById("package_type"+id);
			var temp_ship_ebat = document.getElementById("ship_ebat"+id);
			var temp_total_price = document.getElementById("total_price"+id);
			var temp_quantity = document.getElementById("quantity"+id);
			var temp_other_money = document.getElementById("other_money"+id);
			var temp_ship_agirlik = document.getElementById("ship_agirlik"+id);
			
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
				if(desi_hesap<document.getElementById("max_limit").value)
				{
					var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id_modal").value + "*" + desi_hesap;
					var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
				}
				else
				{
					var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id_modal").value + "*" + document.getElementById("max_limit").value;
					var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
				}
			}
			else if(temp_package_type_id==2) 
			{	
				temp_ship_agirlik_ = parseFloat(temp_ship_agirlik.value)*parseFloat(temp_quantity.value);
				if(temp_ship_agirlik.value !="" && temp_ship_agirlik.value !=0)
				{
					if(temp_ship_agirlik_<document.getElementById("max_limit").value)
					{
						var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id_modal").value + "*" + temp_ship_agirlik_;
						var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
					}
					else
					{
						var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id_modal").value + "*" + document.getElementById("max_limit").value;
						var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
					}
				}	
			}	
			else if(temp_package_type_id==3)  //Zarf ise
			{
				var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id_modal").value;
				var GET_PRICE = wrk_safe_query("stk_GET_PRICE_2",'dsn',0,listParam);
			}
			if(GET_PRICE != undefined)
			{
				if(GET_PRICE.recordcount==0)
				{
					alert("1<cf_get_lang dictionary_id='63450.Lütfen Hesaplama için Sevk Yöntemi Taşıyıcı Firma Paket Tipini(Kg) Kontrol Ediniz (Fiyat Listesi)'>!");
					temp_ship_ebat.value = "";
					temp_total_price.value = "";
					temp_other_money.value = "";
					return false;
				}
				else
				{
					if(temp_package_type_id==1)//Desi ise
					{
						temp_ship_agirlik.value = "";
						if(desi_hesap<document.getElementById("max_limit").value)
						{
							temp_total_price.value = commaSplit(GET_PRICE.PRICE*temp_quantity.value);/*Toplam atanıyor.*/
						}
						else
						{
							var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30','dsn',0,document.getElementById("transport_comp_id").value);
							desi_remain = parseFloat((parseInt(desi_1)*parseInt(desi_2)*parseInt(desi_3))/(3000)-<cfoutput>document.getElementById("max_limit").value</cfoutput>);
							temp_total_price.value = commaSplit(parseFloat(GET_PRICE.PRICE*temp_quantity.value)+parseFloat(GET_PRICE_30.PRICE*desi_remain*temp_quantity.value));
						}
					}
					if(temp_package_type_id==2)//Kg ise
					{
						temp_ship_ebat.value = "";
						if(temp_ship_agirlik_<document.getElementById("max_limit").value)
						{
							temp_total_price.value = commaSplit(GET_PRICE.PRICE);
						}
						else
						{
							var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30','dsn',0,document.getElementById("transport_comp_id").value);
							kg_remain = parseFloat(temp_ship_agirlik_-document.getElementById("max_limit").value);
							temp_total_price.value = commaSplit(parseFloat(GET_PRICE.PRICE)+parseFloat(GET_PRICE_30.PRICE*kg_remain));
						}
					}				
					
					else if(temp_package_type_id==3)//Zarf ise
					{
						temp_ship_agirlik = '';
						temp_ship_ebat.value = '';
						temp_total_price.value = commaSplit(parseFloat(GET_PRICE.PRICE) * parseFloat(temp_quantity.value));
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
			
			for(r=1;r<=document.getElementById("record_num_other").value;r++)
			{
				row_kontrol_other = document.getElementById("row_kontrol_other"+r);
				if(row_kontrol_other.value == 1)
				{
					var temp_package_type = document.getElementById("package_type"+r);
					var temp_ship_ebat = document.getElementById("ship_ebat"+r);
					var temp_quantity = document.getElementById("quantity"+r);
					var temp_ship_agirlik = document.getElementById("ship_agirlik"+r);
	
					temp_desi = list_getat(temp_package_type.value,2,',');
					temp_package_type_id = list_getat(temp_package_type.value,3,',');
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
						if(trim(document.getElementById("ship_agirlik"+r).value).length == 0)
							document.getElementById("ship_agirlik"+r).value = 1;
						temp_ship_agirlik_ = filterNum(temp_ship_agirlik.value);
						if(temp_ship_agirlik.value !="" && temp_ship_agirlik.value !=0)
							kg_sum +=parseFloat(temp_ship_agirlik_)*parseFloat(temp_quantity.value);
					}	
					else if(temp_package_type_id==3)//Zarf ise
					{
						count_envelope += 1;
						temp_ship_agirlik.value = '';
						temp_ship_ebat.value = '';
						var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id_modal").value;
						var GET_PRICE3 = wrk_safe_query("stk_GET_PRICE_2",'dsn',0,listParam);
						if(GET_PRICE3 != undefined)
						{
							if(GET_PRICE3.recordcount==0)
								{
								alert("<cf_get_lang dictionary_id='63450.Lütfen Hesaplama için Sevk Yöntemi Taşıyıcı Firma Paket Tipini(Kg) Kontrol Ediniz (Fiyat Listesi)'>!");
								return false;
								}
							else
								envelope_price_sum += GET_PRICE3.PRICE * parseFloat(temp_quantity.value);
						}					
					}
				}
			}
	
			if(count_desi != 0)
			{
				if(desi_sum<document.getElementById("max_limit").value)
				{
					var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id_modal").value + "*" + desi_sum
					var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
				}
				else
				{
					var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id_modal").value + "*" + document.getElementById("max_limit").value;
					
					var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
				}
				
				if(GET_PRICE1 != undefined)
				{
					if(GET_PRICE1.recordcount==0)
					 {
						alert("<cf_get_lang dictionary_id='63450.Lütfen Hesaplama için Sevk Yöntemi Taşıyıcı Firma Paket Tipini(Kg) Kontrol Ediniz (Fiyat Listesi)'>!");
						return false;
					 }
					else
					 {
						if(desi_sum<document.getElementById("max_limit").value)
						{
							desi_price_sum = GET_PRICE1.PRICE;
						}
						else
						{					
							var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30','dsn',0,document.getElementById("transport_comp_id").value);
							desi_remain2 = parseFloat(desi_sum-document.getElementById("max_limit").value);
							desi_price_sum = parseFloat(GET_PRICE1.PRICE)+parseFloat(GET_PRICE_30.PRICE*desi_remain2);
						}
					 }
				}
			}
			if(count_kg != 0)
			{
				if(kg_sum<document.getElementById("max_limit").value)
				{
					var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id_modal").value + "*" +  kg_sum;
					var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
				}
				else
				{
					var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id_modal").value + "*" + document.getElementById("max_limit").value;
					var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
				}
				if(GET_PRICE1 != undefined)
				{
					if(GET_PRICE1.recordcount==0)
					 {
						alert("<cf_get_lang dictionary_id='63450.Lütfen Hesaplama için Sevk Yöntemi Taşıyıcı Firma Paket Tipini(Kg) Kontrol Ediniz (Fiyat Listesi)'>!");
						return false;
					 }
					else
					{
						if(kg_sum<document.getElementById("max_limit").value)
						{
							kg_price_sum = GET_PRICE1.PRICE;
						}
						else
						{					
							var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30','dsn',0,document.getElementById("transport_comp_id").value);
							kg_remain2 = parseFloat(kg_sum-document.getElementById("max_limit").value);
							kg_price_sum = parseFloat(GET_PRICE1.PRICE)+parseFloat(GET_PRICE_30.PRICE*kg_remain2);
						}
					}
				}
			}
			document.getElementById("total_cost_value").value = commaSplit(parseFloat(desi_price_sum)+parseFloat(kg_price_sum)+parseFloat(envelope_price_sum));
		}
		return kur_hesapla();
	}
	
	function control()
	{
		
		if (document.getElementById("company_id").value == "" && document.getElementById("consumer_id").value == "")
		{
			alert("<cf_get_lang dictionary_id='50081.Lütfen Cari Hesap Seçiniz'>!");
			return false;
		}	
		
		if(document.getElementById("ship_method_id_modal").value == "")	
		{
			alert("<cf_get_lang dictionary_id='35327.Lütfen Sevk Yöntemi Seçiniz'> !");
			return false;
		}
		
		if(document.getElementById("transport_comp_id").value == "")	
		{
			alert("<cf_get_lang dictionary_id='45495.Taşıyıcı Seçiniz'> !");
			return false;
		}
		
		<cfif is_department_required eq 1>
			if((document.getElementById("department_id").value=="") || (document.getElementById("department_name").value==""))
			{
				alert("<cf_get_lang dictionary_id='51278.Lütfen Çıkış Depo Seçiniz'> !");
				return false;
			}
		</cfif>
		<cfif is_show_cost eq 1>
			if(document.getElementById("options_kontrol").value==0 || document.getElementById("options_kontrol").value == "")
			{	
				alert("5<cf_get_lang dictionary_id='63450.Lütfen Hesaplama için Sevk Yöntemi Taşıyıcı Firma Paket Tipini(Kg) Kontrol Ediniz (Fiyat Listesi)'>!");
				return false;
			}
	
			// Paket kontrolleri
			for(r=1;r<=document.getElementById("record_num_other").value;r++)
			{
				deger_row_kontrol_other = document.getElementById("row_kontrol_other"+r);
				deger_package_type = document.getElementById("package_type"+r);
				if(deger_row_kontrol_other.value == 1)
				{
					if(deger_package_type.value == "")
					{
						alert("<cf_get_lang dictionary_id='63451.Lütfen Paket Tipi Seçiniz'> !");
						return false;
					}
				}
			}
			unformat_fields();
		</cfif>

		if(process_cat_control())
			return paper_control(document.getElementById("transport_no1"),'SHIP_FIS');
		else
			return false;
	}
	function kur_hesapla()
	{
		total_cost_value = 0;
		if(document.getElementById("calculate_type_2").checked)
		{		
			for(r=1;r<=document.getElementById("record_num_other").value;r++)
			{
				if(document.getElementById("row_kontrol_other"+r).value == 1)
				{
					var temp_other_money = document.getElementById("other_money"+r);
					var temp_total_price = document.getElementById("total_price"+r);
					
					if(temp_total_price.value != '')
					{
						temp_sira = list_find(money_list,temp_other_money.value);				
						temp_rate1 = list_getat(rate1_list,temp_sira);
						temp_rate2 = list_getat(rate2_list,temp_sira);
						temp_deger = parseFloat(parseFloat(filterNum(temp_total_price.value)) / (parseFloat(temp_rate1) / parseFloat(temp_rate2)));
						total_cost_value = parseFloat(total_cost_value) + parseFloat(temp_deger);
					}
				}
			}
			temp2_sira = list_find(money_list,<cfoutput>'#session.ep.money2#'</cfoutput>); 
			temp2_rate1 = list_getat(rate1_list,temp2_sira);
			temp2_rate2 = list_getat(rate2_list,temp2_sira);
			total_cost2_value = total_cost_value * (parseFloat(temp2_rate1) / parseFloat(temp2_rate2));
			
			document.getElementById("total_cost_value").value = commaSplit(total_cost_value);
			document.getElementById("total_cost2_value").value = commaSplit(total_cost2_value);
		}
		else
		{
			temp2_sira = list_find(money_list,<cfoutput>'#session.ep.money2#'</cfoutput>); 
			temp2_rate1 = list_getat(rate1_list,temp2_sira);
			temp2_rate2 = list_getat(rate2_list,temp2_sira);
			total_cost2_value = filterNum(document.getElementById("total_cost_value").value) * (parseFloat(temp2_rate1) / parseFloat(temp2_rate2));
			document.getElementById("total_cost2_value").value = commaSplit(total_cost2_value);
		}
		return true;
	}
	
	function unformat_fields()
	{
		for(r=1;r<=document.getElementById("record_num_other").value;r++)
		{
			if(document.getElementById("row_kontrol_other"+r).value == 1)
			{
				document.getElementById("quantity"+r).value = filterNum(document.getElementById("quantity"+r).value);
				document.getElementById("ship_agirlik"+r).value = filterNum(document.getElementById("ship_agirlik"+r).value);
				document.getElementById("total_price"+r).value = filterNum(document.getElementById("total_price"+r).value);
			}
		}
		document.getElementById("total_cost_value").value = filterNum(document.getElementById("total_cost_value").value);
		document.getElementById("total_cost2_value").value = filterNum(document.getElementById("total_cost2_value").value);
	}
	
	function change_packet(calculate_type_value)
	{
		if(row_count2!=0)
		{
			if(calculate_type_deger!=calculate_type_value)
			{
				if(calculate_type_value == 2)
				{
					for(r=1;r<=document.getElementById("record_num_other").value;r++)
					{
						if(document.getElementById("row_kontrol_other"+r).value == 1)
						{
							document.getElementById("package_type"+r).value = '';
							document.getElementById("ship_ebat"+r).value = '';
							document.getElementById("ship_agirlik"+r).value = '';
							document.getElementById("total_price"+r).value = '';
							document.getElementById("other_money"+r).value = '';
						}					
					}
					document.getElementById("total_cost_value").value = commaSplit(0);
					document.getElementById("total_cost2_value").value = commaSplit(0);				
				}
				else
				{
					degistir(1);
				}
			}
		}
		calculate_type_deger = calculate_type_value;
		return true;
	}	
</script>
