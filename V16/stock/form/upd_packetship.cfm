<cf_xml_page_edit fuseact="stock.popup_add_packetship">
<!--- Not: SHIP_RESULT tablosundaki IS_TYPE alani siparis datayindaki Sevkiyat popup'dan atılan kayıtlarda (sadece bu kayitlarda) 2 set edilir.
	O yuzden ekleme ve silme işlemi su an yapilamamakta BK 20070405
 --->
 <cfset xml_all_depo = iif(isdefined("xml_location_auth"),xml_location_auth,DE('-1'))>
<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
<cfinclude template="../query/get_moneys.cfm">
<cfinclude template="../query/get_package_type.cfm">
<cfinclude template="../query/get_country.cfm">
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT MONEY,RATE2,RATE1 FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = 1 ORDER BY MONEY_ID
</cfquery>
<cfquery name="GET_SHIP_RESULT" datasource="#DSN2#">
	SELECT
		SR.SHIP_RESULT_ID,
        SR.SHIP_METHOD_TYPE,
        SR.SERVICE_COMPANY_ID,
		SR.SERVICE_CONSUMER_ID,
        SR.SERVICE_MEMBER_ID,
		SR.SERVICE_CONSUMER_MEMBER_ID,
        SR.ASSETP_ID,
        SR.DELIVER_EMP,
        SR.ASSETP,
        SR.DELIVER_EMP_NAME,
        SR.PLATE,
		SR.PLATE2,
        SR.NOTE,
        SR.SHIP_FIS_NO,
        SR.DELIVER_PAPER_NO,
        SR.REFERENCE_NO,
        SR.OUT_DATE,
        SR.DELIVERY_DATE,
        SR.DELIVER_POS,
        SR.DEPARTMENT_ID,
        SR.SHIP_STAGE,
        SR.COST_VALUE,
        SR.COST_VALUE2,
        SR.CALCULATE_TYPE,
        SR.COMPANY_ID,
        SR.PARTNER_ID,
        SR.CONSUMER_ID,
        SR.IS_TYPE,
        SR.SENDING_ADDRESS,
        SR.SENDING_POSTCODE,
        SR.SENDING_SEMT,
        SR.SENDING_COUNTY_ID,
        SR.SENDING_CITY_ID,
        SR.SENDING_COUNTRY_ID,
        SR.LOCATION_ID,
        SR.RECORD_EMP,
        SR.RECORD_IP,
        SR.RECORD_DATE,
        SR.UPDATE_EMP,
        SR.UPDATE_IP,
        SR.UPDATE_DATE,
        SR.INSURANCE_COMP_ID,
        SR.INSURANCE_COMP_PART,
        SR.DUTY_COMP_ID,
        SR.DUTY_COMP_PARTNER,
        SR.WAREHOUSE_ENTRY_DATE,
        SR.OTHER_MONEY_VALUE,
        SR.OTHER_MONEY,
		SM.SHIP_METHOD,
		SR.DELIVER_EMP_TC
	FROM
		SHIP_RESULT SR,
		#dsn_alias#.SHIP_METHOD SM
	WHERE
		SR.SHIP_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_result_id#"> AND
		SR.SHIP_METHOD_TYPE = SM.SHIP_METHOD_ID AND
		SR.MAIN_SHIP_FIS_NO IS NULL 
</cfquery>
<cfif not get_ship_result.recordcount>
	<br/><font class="txtbold"><cf_get_lang dictionary_id='58943.Böyle Kayıt Bulunmamaktadır'>!</font>
	<cfexit method="exittemplate">
</cfif>
<cfif is_show_warehouse_date eq 1>
	<cfif get_ship_result.recordcount and not len(get_ship_result.warehouse_entry_date)>
		<cfset get_ship_result.warehouse_entry_date = get_ship_result.RECORD_DATE>
	</cfif>
</cfif>
<cfif is_show_cost eq 1>
    <cfquery name="GET_SHIP_METHOD_PRICE" datasource="#DSN#">
        SELECT * FROM SHIP_METHOD_PRICE WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_result.service_company_id#">
    </cfquery>
	<!--- Eger ilgili hesap yontemine ait kayit yoksa --->
    <cfif not get_ship_method_price.recordcount>
        <script type="text/javascript">
            alert('<cfoutput>#get_par_info(get_ship_result.service_company_id,1,0,0)#</cfoutput>'+ " <cf_get_lang dictionary_id ='45655.Şirketine Ait Bir Taşıyıcı Kaydı Yok,Lütfen Kayıtlarınızı Kontrol Ediniz'>" );
            window.location.href="<cfoutput>#request.self#?</cfoutput>fuseaction=stock.list_packetship"
        </script>
    </cfif>
    <!--- Tasiyici Bilgisi Degistirilirse,yeni tasiyici icin sevk fiyatı verilip verilmedigini kontrol etmek icssin  --->
    <cfquery name="GET_SHIP_METHOD_PRICE_" datasource="#DSN#">
        SELECT * FROM SHIP_METHOD_PRICE
    </cfquery>

	<!--- Tasiyici Firma Sadece 1 kez secilsin. --->
    <cfset transport_selected=ValueList(get_ship_method_price_.company_id,',')>
    <cfif len(get_ship_result.ship_method_type)>
        <cfquery name="GET_ROWS" datasource="#DSN2#">
            SELECT
                PACKAGE_PIECE,
                PACKAGE_DIMENTION,
                PACKAGE_WEIGHT
            FROM
                SHIP_RESULT_PACKAGE
            WHERE
                SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_result_id#">
        </cfquery>
        <cfset toplam_kg = 0>
        <cfset toplam_desi = 0>
    </cfif>
</cfif>
<cfif get_ship_result.is_type eq 2>
    <cfset head =  " * ( " & "#getLang('stock', 372)#" & " )">
<cfelse>
	<cfset head =  "">
</cfif>
<cfset pageHead = pageHead & head>

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="upd_packet_ship" id="upd_packet_ship" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_packetship">
			<input type="hidden" name="ship_result_id" id="ship_result_id" value="<cfoutput>#attributes.ship_result_id#</cfoutput>">
			<input type="hidden" name="is_type" id="is_type" value="<cfoutput>#get_ship_result.is_type#</cfoutput>">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_cat">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"> *</label>
						<div class="col col-8 col-xs-12"><cf_workcube_process is_upd='0' select_value = '#get_ship_result.ship_stage#' process_cat_width='150' is_detail='1'></div>
					</div>
					<div class="form-group" id="item-company">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif len(get_ship_result.partner_id)>
									<input type="hidden" name="consumer_id" id="consumer_id" value="">
									<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_ship_result.company_id#</cfoutput>">
									<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_ship_result.partner_id#</cfoutput>">	
									<input type="text" name="company" id="company" value="<cfoutput>#get_par_info(get_ship_result.partner_id,0,1,0)#</cfoutput>" readonly="readonly">	  
								<cfelseif len(get_ship_result.consumer_id)>
									<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#get_ship_result.consumer_id#</cfoutput>">
									<input type="hidden" name="company_id" id="company_id" value="">
									<input type="hidden" name="partner_id" id="partner_id" value="">	
									<input type="text" name="company" id="company" value="" readonly="readonly">
								<cfelse>
									<input type="hidden" name="consumer_id" id="consumer_id" value="">
									<input type="hidden" name="company_id" id="company_id" value="">
									<input type="hidden" name="partner_id" id="partner_id" value="">	
									<input type="text" name="company" id="company" value="" readonly="readonly">
								</cfif>
								<cfset str_linke_ait="&field_comp_id=upd_packet_ship.company_id&field_partner=upd_packet_ship.partner_id&field_consumer=upd_packet_ship.consumer_id&field_comp_name=upd_packet_ship.company&field_name=upd_packet_ship.member_name&ship_method_id=upd_packet_ship.ship_method_id&ship_method_name=upd_packet_ship.ship_method_name&field_trans_comp_id=upd_packet_ship.transport_comp_id&field_trans_comp_name=upd_packet_ship.transport_comp_name&field_trans_deliver_id=upd_packet_ship.transport_deliver_id&field_trans_deliver_name=upd_packet_ship.transport_deliver_name&field_long_address=upd_packet_ship.sending_address">
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#</cfoutput><cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=7,8');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-member_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'> *</label>
						<div class="col col-8 col-xs-12">
							<cfif len(get_ship_result.partner_id)>
								<input type="text" name="member_name" id="member_name" value="<cfoutput>#get_par_info(get_ship_result.partner_id,0,-1,0)#</cfoutput>" readonly>
							<cfelseif len(get_ship_result.consumer_id)>
								<input type="text" name="member_name" id="member_name" value="<cfoutput>#get_cons_info(get_ship_result.consumer_id,0,0)#</cfoutput>" readonly>
							<cfelse>
								<input type="text" name="member_name" id="member_name" value="" readonly>
							</cfif>
						</div>
					</div>
					<div class="form-group" id="item-ship_method_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="ship_method_id" id="ship_method_id" value="<cfoutput>#get_ship_result.ship_method_type#</cfoutput>">
								<input type="text" name="ship_method_name" id="ship_method_name" value="<cfoutput>#get_ship_result.ship_method#</cfoutput>" readonly>
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=upd_packet_ship.ship_method_name&field_id=upd_packet_ship.ship_method_id&is_form_submitted=1','','ui-draggable-box-small');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-transport_comp_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57716.Taşıyıcı'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="transport_comp_id_" id="transport_comp_id_" value="<cfoutput>#get_ship_result.service_company_id#</cfoutput>">
								<input type="hidden" name="transport_comp_id" id="transport_comp_id" value="<cfoutput>#get_ship_result.service_company_id#</cfoutput>">
								<input type="hidden" name="transport_cons_id" id="transport_cons_id" value="<cfoutput>#get_ship_result.service_consumer_id#</cfoutput>">
								<input type="text" name="transport_comp_name" id="transport_comp_name" value="<cfoutput># ( len(get_ship_result.service_company_id) ) ? get_par_info(get_ship_result.service_company_id,1,0,0) : get_cons_info(get_ship_result.service_consumer_id,0,0) #</cfoutput>" readonly>
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=upd_packet_ship.transport_comp_id&field_consumer=upd_packet_ship.transport_cons_id&field_id=upd_packet_ship.transport_cons_deliver_id&field_comp_name=upd_packet_ship.transport_comp_name&field_partner=upd_packet_ship.transport_deliver_id&field_name=upd_packet_ship.transport_deliver_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-transport_deliver_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45460.Taşıyıcı Yetkilisi'></label>
						<div class="col col-8 col-xs-12">
							<input type="hidden" name="transport_deliver_id" id="transport_deliver_id" value="<cfoutput>#get_ship_result.service_member_id#</cfoutput>">
							<input type="hidden" name="transport_cons_deliver_id" id="transport_cons_deliver_id" value="<cfoutput>#get_ship_result.service_consumer_member_id#</cfoutput>">
							<input type="text" name="transport_deliver_name" id="transport_deliver_name" value="<cfoutput># ( len(get_ship_result.service_member_id) ) ? get_par_info(get_ship_result.service_member_id,0,-1,0) : get_cons_info(get_ship_result.service_consumer_member_id,0,0)#</cfoutput>" readonly>
						</div>
					</div>
					<div class="form-group" id="item-assetp_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58480.Araç'></label>
						<div class="col col-8 col-xs-12">
							<cfif is_manuel_asset eq 0>
								<div class="input-group">
									<input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#get_ship_result.assetp_id#</cfoutput>">
									<cfif len(get_ship_result.assetp_id)>
										<cfquery name="GET_ASSETP" datasource="#DSN#">
											SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_result.assetp_id#">
										</cfquery>
										<input type="text" name="assetp_name" id="assetp_name" value="<cfoutput>#get_assetp.assetp#</cfoutput>">
									<cfelse>
										<input type="text" name="assetp_name" id="assetp_name" value="">
									</cfif>
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=upd_packet_ship.assetp_id&field_name=upd_packet_ship.assetp_name&field_emp_id=upd_packet_ship.vehicle_emp_id&field_emp_name=upd_packet_ship.vehicle_emp_name');"></span>
								</div>
							<cfelse>
								<input type="text" name="assetp_name" id="assetp_name" value="<cfoutput>#get_ship_result.assetp#</cfoutput>" maxlength="50">
							</cfif>
						</div>
					</div>	
					<div class="form-group" id="item-vehicle_emp_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45466.Araç Yetkilisi'></label>
						<div class="col col-8 col-xs-12">
							<cfif is_manuel_asset eq 0>
								<div class="input-group">
									<input type="hidden" name="vehicle_emp_id" id="vehicle_emp_id" value="<cfoutput>#get_ship_result.deliver_emp#</cfoutput>">
									<input type="text" name="vehicle_emp_name" id="vehicle_emp_name" value="<cfoutput>#get_emp_info(get_ship_result.deliver_emp,0,0)#</cfoutput>">
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=upd_packet_ship.vehicle_emp_name&field_emp_id=upd_packet_ship.vehicle_emp_id&select_list=1');"></span>
								</div>
							<cfelse>
								<input type="text" name="vehicle_emp_name" id="vehicle_emp_name" value="<cfoutput>#get_ship_result.deliver_emp_name#</cfoutput>">							
							</cfif>
						</div>
					</div>
					<cfif is_manuel_asset neq 0>
						<div class="form-group" id="item-vehicle_emp_tc">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45466.Araç Yetkilisi'> TC</label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="vehicle_emp_tc" id="vehicle_emp_tc" maxlength="11" value="<cfoutput>#get_ship_result.DELIVER_EMP_TC#</cfoutput>">
							</div>
						</div>
					<div class="form-group" id="item-plate">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29453.Plaka'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="plate" id="plate" maxlength="50" value="<cfoutput>#get_ship_result.plate#</cfoutput>">
						</div>
					</div>
					</cfif>
					<div class="form-group" id="item-vehicle2">
						<label class="col col-4 col-xs-12">2. <cf_get_lang dictionary_id='29453.Plaka'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="plate2" id="plate2" maxlength="150" value="<cfoutput>#get_ship_result.plate2#</cfoutput>">
						</div>	
					</div>
					<cfif is_show_insurance_comp eq 1>
						<div class="form-group" id="item-insurance_comp_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45234.Sigorta Firması'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="insurance_comp_id" id="insurance_comp_id" value="<cfoutput>#get_ship_result.INSURANCE_COMP_ID#</cfoutput>">
									<input type="text" name="insurance_comp_name"  id="insurance_comp_name" value="<cfoutput>#get_par_info(get_ship_result.INSURANCE_COMP_ID,1,0,0)#</cfoutput>" readonly>
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=upd_packet_ship.insurance_comp_id&field_comp_name=upd_packet_ship.insurance_comp_name&field_partner=upd_packet_ship.insurance_comp_partner_id&field_name=upd_packet_ship.insurance_comp_partner_name&select_list=2');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-insurance_comp_partner_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45240.Sigorta Yetkilisi'></label>
							<div class="col col-8 col-xs-12">
								<input type="hidden" name="insurance_comp_partner_id" id="insurance_comp_partner_id" value="<cfoutput>#get_ship_result.INSURANCE_COMP_PART#</cfoutput>">
								<input type="text" name="insurance_comp_partner_name" id="insurance_comp_partner_name" value="<cfoutput>#get_par_info(get_ship_result.INSURANCE_COMP_PART,0,-1,0)#</cfoutput>" readonly>
							</div>
						</div>
					</cfif>
					<cfif is_show_duty_comp eq 1>
						<div class="form-group" id="item-duty_comp_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45238.Gümrük Firması'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="duty_comp_id" id="duty_comp_id" value="<cfoutput>#get_ship_result.DUTY_COMP_ID#</cfoutput>">
									<input type="text" name="duty_comp_name" id="duty_comp_name" value="<cfoutput>#get_par_info(get_ship_result.DUTY_COMP_ID,1,0,0)#</cfoutput>" readonly>
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=upd_packet_ship.duty_comp_id&field_comp_name=upd_packet_ship.duty_comp_name&field_partner=upd_packet_ship.duty_comp_partner_id&field_name=upd_packet_ship.duty_comp_partner_name&select_list=2');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-duty_comp_partner_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45251.Gümrük Yetkilisi'></label>
							<div class="col col-8 col-xs-12">
								<input type="hidden" name="duty_comp_partner_id" id="duty_comp_partner_id" value="<cfoutput>#get_ship_result.DUTY_COMP_PARTNER#</cfoutput>">
								<input type="text" name="duty_comp_partner_name" id="duty_comp_partner_name" value="<cfoutput>#get_par_info(get_ship_result.DUTY_COMP_PARTNER,0,-1,0)#</cfoutput>" readonly>
							</div>
						</div>
					</cfif>
					<div class="form-group" id="item-ship_price">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="45184.Nakliye Bedeli"></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="text" name="ship_price" id="ship_price" value="<cfoutput>#tlFormat(get_ship_result.other_money_value)#</cfoutput>" class="moneybox" onkeyup="return(FormatCurrency(this,event,2));"/>
								<span class="input-group-addon width">
									<select name="ship_price_name" id="ship_price_name">
										<cfoutput query="get_moneys">
											<option value="#money#"<cfif money eq get_ship_result.other_money>selected</cfif>>#money#</option>
										</cfoutput>
									</select>
								</span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-transport_no1">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45458.Sevkiyat No'> *</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="transport_no1" id="transport_no1" value="<cfoutput>#get_ship_result.ship_fis_no#</cfoutput>" readonly="readonly">
						</div>
					</div>
					<div class="form-group" id="item-transport_paper_no">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57716.Taşıyıcı'> <cf_get_lang dictionary_id='57880.Belge No'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="transport_paper_no" id="transport_paper_no" value="#get_ship_result.deliver_paper_no#" maxlength="25">
						</div>
					</div>
					<div class="form-group" id="item-reference_no">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58794.Referans No'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="reference_no" id="reference_no" value="<cfoutput>#get_ship_result.reference_no#</cfoutput>" maxlength="25">
						</div>
					</div>
					<cfif is_show_warehouse_date eq 1>
						<div class="form-group" id="item-warehouse_entry_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45227.Depo Giris'></label>
							<div class="col col-4 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="warehouse_entry_date" id="warehouse_entry_date" validate="#validate_style#" value="#dateformat(get_ship_result.WAREHOUSE_ENTRY_DATE,dateformat_style)#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="warehouse_entry_date"></span>
								</div>
							</div>
							<div class="col col-2 col-xs-12">
								<cf_wrkTimeFormat name="warehouse_entry_h" id="warehouse_entry_h" value="#numberformat("#hour(get_ship_result.WAREHOUSE_ENTRY_DATE)#",00)#">
							</div>
							<div class="col col-2 col-xs-12">
								<select name="warehouse_entry_m" id="warehouse_entry_m">
									<cfoutput>
										<cfloop from="0" to="59" index="i">
											<option value="#numberformat(i,00)#" <cfif i eq minute(get_ship_result.WAREHOUSE_ENTRY_DATE)>selected</cfif>>#numberformat(i,00)#</option>
										</cfloop>
									</cfoutput>
								</select>
							</div>
						</div>
					</cfif>
					<div class="form-group" id="item-action_date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45463.Depo Çıkış'></label>
						<div class="col col-4 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='45464.Depo Çıkış Tarih Girmelisiniz'> !</cfsavecontent>
								<cfinput type="text" name="action_date" id="action_date" value="#dateformat(get_ship_result.out_date,dateformat_style)#" validate="#validate_style#" required="yes" message="#message#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="action_date"></span>
							</div>
						</div>
						<div class="col col-2 col-xs-12">
							<cf_wrkTimeFormat name="start_h" id="start_h" value="#numberformat("#hour(get_ship_result.out_date)#",00)#">	
						</div>
						<div class="col col-2 col-xs-12">
							<select name="start_m" id="start_m">
								<cfoutput>
									<cfloop from="0" to="59" index="i">
										<option value="#numberformat(i,00)#" <cfif i eq minute(get_ship_result.out_date)>selected</cfif>>#numberformat(i,00)#</option>
									</cfloop>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-deliver_date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57645.Teslim Tarih'></label>
						<div class="col col-4 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='45467.Teslim Tarihi Girmelisiniz'> !</cfsavecontent>
								<cfinput type="text" name="deliver_date" id="deliver_date" value="#dateformat(get_ship_result.delivery_date,dateformat_style)#" validate="#validate_style#" message="#getLang('','Lütfen Teslim Tarihi Formatını Doğru Giriniz',45647)#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="deliver_date"></span>
							</div>
						</div>
						<div class="col col-2 col-xs-12">
							<cfif len(get_ship_result.delivery_date)>
								<cfset delivery_hour = hour(get_ship_result.delivery_date)>
								<cfset delivery_minute = minute(get_ship_result.delivery_date)>
								<cf_wrkTimeFormat  name="deliver_h" id="deliver_h" value="#numberformat("#delivery_hour#",00)#">	
							<cfelse>
								<cfset delivery_hour = ''>
								<cfset delivery_minute = ''>
								<cf_wrkTimeFormat  name="deliver_h" id="deliver_h" value="0">	
							</cfif>
						</div>
						<div class="col col-2 col-xs-12">
							<select name="deliver_m" id="deliver_m">
								<cfoutput>
									<cfloop from="0" to="59" index="i">
										<option value="#numberformat(i,00)#" <cfif i eq delivery_minute> selected</cfif>>#numberformat(i,00)#</option>	
									</cfloop>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-deliver_id2">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45470.Teslim Eden'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="deliver_id2" id="deliver_id2" value="<cfoutput>#get_ship_result.deliver_pos#</cfoutput>">
								<input type="text" name="deliver_name2" id="deliver_name2" value="<cfoutput>#get_emp_info(get_ship_result.deliver_pos,0,0)#</cfoutput>" readonly>
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id2=upd_packet_ship.deliver_id2&field_name=upd_packet_ship.deliver_name2&select_list=1');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-location_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29428.Çıkış Depo'><cfif is_department_required eq 1> *</cfif></label>
						<div class="col col-8 col-xs-12">
							<cfif len(get_ship_result.department_id)>
								<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
									SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_result.department_id#">
								</cfquery>
								<cf_wrkdepartmentlocation
									returninputvalue="location_id,department_name,department_id,branch_id"
									returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
									fieldname="department_name"
									fieldid="location_id"
									department_fldid="department_id"
									branch_fldid="branch_id"
									xml_all_depo = "#xml_all_depo#"
									user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
									department_id="#get_ship_result.department_id#"
									location_name="#get_department.department_head#"
									width="170">
							<cfelse>
								<cf_wrkdepartmentlocation
									returninputvalue="location_id,department_name,department_id,branch_id"
									returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
									fieldname="department_name"
									fieldid="location_id"
									department_fldid="department_id"
									branch_id="branch_id"
									xml_all_depo = "#xml_all_depo#"
									user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
									width="170">
							</cfif>
						</div>
					</div>
					<cfif is_show_cost eq 1>
						<div class="form-group" id="item-calculate_type">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45546.Hes Yöntemi'></label>
							<div class="col col-8 col-xs-12">
								<input type="hidden" name="max_limit" id="max_limit" value="<cfoutput>#get_ship_method_price.max_limit#</cfoutput>">
								<label><input type="radio" name="calculate_type" id="calculate_type_1" disabled="disabled" value="1" <cfif get_ship_method_price.calculate_type eq 1>checked</cfif> onclick="change_packet(1);" ><cf_get_lang dictionary_id='45547.Kümülatif'></label>
								<label><input type="radio" name="calculate_type" id="calculate_type_2" disabled="disabled" value="2" <cfif get_ship_method_price.calculate_type eq 2>checked</cfif> onclick="change_packet(2);"><cf_get_lang dictionary_id='45548.Paket'></label>
							</div>
						</div>
						<div class="form-group" id="item-total_cost_value">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45493.Maliyet Tutarı'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="text" name="total_cost_value" id="total_cost_value" value="<cfoutput>#TlFormat(get_ship_result.cost_value)#</cfoutput>" onkeyup="return(FormatCurrency(this,event));" class="moneybox" readonly>
									<span class="input-group-addon"><cfoutput>#session.ep.money#</cfoutput></span>
									<input type="text" name="total_cost2_value" id="total_cost2_value" value="<cfoutput>#TlFormat(get_ship_result.cost_value2)#</cfoutput>" onkeyup="return(FormatCurrency(this,event));" class="moneybox" readonly>
									<span class="input-group-addon"><cfoutput>#session.ep.money2#</cfoutput></span>
								</div>
							</div>
						</div>
					</cfif>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-sending_address">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='45646.Sevkiyat Adresi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<textarea name="sending_address" id="sending_address"><cfoutput>#get_ship_result.sending_address#</cfoutput></textarea>
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="add_adress(3);"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-sending_postcode">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="sending_postcode" id="sending_postcode" value="<cfoutput>#get_ship_result.sending_postcode#</cfoutput>" maxlength="5">
						</div>
					</div>
					<div class="form-group" id="item-sending_semt">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58132.Semt'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="sending_semt" id="sending_semt" value="<cfoutput>#get_ship_result.sending_semt#</cfoutput>" maxlength="30">
						</div>
					</div>
					<div class="form-group" id="item-sending_county">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="sending_county_id" id="sending_county_id" value="<cfoutput>#get_ship_result.sending_county_id#</cfoutput>">
								<cfif len(get_ship_result.sending_county_id)>
									<cfquery name="GET_COUNTY" datasource="#DSN#">
										SELECT * FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_result.sending_county_id#">
									</cfquery>					
									<input type="text" name="sending_county" id="sending_county" value="<cfoutput>#get_county.county_name#</cfoutput>" readonly>
								<cfelse>
									<input type="text" name="sending_county" id="sending_county" value="" readonly>					
								</cfif>
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac_();"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-sending_city">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57971.Şehir'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="sending_city_id" id="sending_city_id" value="<cfoutput>#get_ship_result.sending_city_id#</cfoutput>">
								<cfif len(get_ship_result.sending_city_id)>
									<cfquery name="GET_CITY" datasource="#DSN#">
										SELECT CITY_NAME,CITY_ID FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_result.sending_city_id#">
									</cfquery>								
								</cfif>							
								<input type="text" name="sending_city" id="sending_city" value="<cfif len(get_ship_result.sending_city_id)><cfoutput>#get_city.city_name#</cfoutput></cfif>" readonly>
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac_city();"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-sending_country">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
						<div class="col col-8 col-xs-12">
							<select name="sending_country_id" id="sending_country_id" onchange="remove_adress('1');">
								<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
								<cfoutput query="get_country">
									<option value="#country_id#" <cfif get_country.country_id eq get_ship_result.sending_country_id>selected</cfif>>#country_name#</option>
								</cfoutput>
							</select>						
						</div>
					</div>
					<div class="form-group" id="item-note">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="note" id="note" style="width:150px;height:45px;"><cfoutput>#get_ship_result.note#</cfoutput></textarea>											
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cfquery name="GET_ROW" datasource="#DSN2#">
				SELECT * FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_result_id#">
			</cfquery>
			<div>
			<cf_seperator id="paket_" title="#getLang('stock','Sevkiyatı Yapılan İrsaliyeler','45360')#">
			<div id="paket_">
				<cf_grid_list>
					<thead>
						<tr>
							<th width="20">
								<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_row.recordcount#</cfoutput>">
								<input type="hidden" name="ship_id_list" id="ship_id_list" value="">
								<cfif get_ship_result.is_type neq 2>
									<a onclick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
								</cfif>
							</th>
							<th width="300"><cfif get_ship_result.is_type neq 2><cf_get_lang dictionary_id='58138.İrsaliye No'><cfelse><cf_get_lang dictionary_id='58211.Sipariş No'></cfif></th>
							<th width="125"><cf_get_lang dictionary_id='57742.Tarih'></th>
							<th width="200"><cf_get_lang dictionary_id='58733.Alıcı'></th>
							<th width="300"><cf_get_lang dictionary_id='58723.Adres'></th>
							<th width="300"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></th>
						</tr>
					</thead>
					<tbody id="table1">
						<cfoutput query="get_row">
							<tr id="frm_row#currentrow#">
							<cfif get_ship_result.is_type neq 2>
								<cfquery name="GET_SHIP" datasource="#DSN2#">
									SELECT SHIP_NUMBER FROM SHIP WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ship_id#">
								</cfquery>
							<cfelse>		
								<cfquery name="GET_SHIP" datasource="#DSN3#">
									SELECT ORDER_NUMBER SHIP_NUMBER FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ship_id#">
								</cfquery>
							</cfif>
								<td>
									<cfif get_ship_result.is_type neq 2><a onclick="sil('#currentrow#');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></cfif>
									<input type="hidden" name="ship_result_row_id#currentrow#" id="ship_result_row_id#currentrow#" value="#ship_result_row_id#">
									<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
								</td>
								<td>
									<div class="input-group">
									<input type="hidden" name="ship_id#currentrow#" id="ship_id#currentrow#" value="#ship_id#">
									<input type="text" name="ship_number#currentrow#" id="ship_number#currentrow#" value="#get_ship.ship_number#" readonly>
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('#currentrow#');"></span>
									</div>
								</td>
								<td><input type="text" name="ship_date#currentrow#" id="ship_date#currentrow#" value="#dateformat(ship_date,dateformat_style)#" readonly></td>
								<td><input type="text" name="ship_deliver#currentrow#" id="ship_deliver#currentrow#" value="#deliver_comp#" readonly></td>
								<td>
									<div class="form-group">
										<div class="input-group">
											<input type="text" name="ship_adress#currentrow#" id="ship_adress#currentrow#" value="#deliver_adress#" readonly>
											<span class="input-group-addon" href="javascript://" onclick="windowopen('#request.self#?fuseaction=stock.popup_ship_package_detail&process_id=#ship_id#','project')">
												<i class="fa fa-address-card-o" title="<cf_get_lang dictionary_id ='45656.Paket Kontrol'>"></i>
											</span>
										</div>
									</div>
									<!--- <ul class="ui-icon-list">
										<li><input type="text" name="ship_adress#currentrow#" id="ship_adress#currentrow#" value="#deliver_adress#" readonly></li>
										<cfif get_ship_result.is_type neq 2>
											<li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=stock.popup_ship_package_detail&process_id=#ship_id#','project')"><i class="fa fa-address-card-o" title="<cf_get_lang dictionary_id ='45656.Paket Kontrol'>"></i></a></li>
										</cfif>
									</ul> --->
								</td>
								<td><input type="text" name="ship_type#currentrow#" id="ship_type#currentrow#" value="#deliver_type#" readonly></td>
							</tr>
						</cfoutput>
					</tbody>
				</cf_grid_list>
			</div>
			<cfif is_show_cost eq 1>
				<cfquery name="GET_PACKAGE" datasource="#DSN2#">
					SELECT
						SRP.*,
						'' PACK_NAME
					FROM
						SHIP_RESULT_PACKAGE SRP
					WHERE 
						SRP.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_result_id#"> AND
						PACK_EMP_ID IS NULL
						
					UNION ALL
						
					SELECT
						SRP.*,
						<cfif (database_type is 'MSSQL')>
						EMPLOYEES.EMPLOYEE_NAME +' '+ EMPLOYEES.EMPLOYEE_SURNAME PACK_NAME
						<cfelseif (database_type is 'DB2')>
						EMPLOYEES.EMPLOYEE_NAME ||' '|| EMPLOYEES.EMPLOYEE_SURNAME PACK_NAME
						</cfif>
					FROM
						SHIP_RESULT_PACKAGE SRP,
						#dsn_alias#.EMPLOYEES EMPLOYEES
					WHERE 
						SRP.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_result_id#"> AND
						SRP.PACK_EMP_ID = EMPLOYEES.EMPLOYEE_ID
				</cfquery>
				<div class="col col-9 col-md-12 col-xs-12">
					<cf_seperator id="paket_2" title="#getLang('stock','Sevkiyatı Yapılan Paketlemeler','45367')#">
					<div id="paket_2">
						<cf_box_elements>
							<div class="form-group">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12 bold"><cf_get_lang dictionary_id='35781.Paketleyen'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="pack_emp_id0" id="pack_emp_id0" value="">
										<input type="text" name="pack_emp_name0" id="pack_emp_name0" value="" readonly onfocus="hepsi();">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac2_main();"></span>						
									</div>
								</div>
							</div>
						</cf_box_elements>
						<cf_grid_list>
							<thead>
								<tr>
									<th width="20"><a onclick="add_row_other();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
									<th width="35"><cf_get_lang dictionary_id='57487.No'><input name="record_num_other" id="record_num_other" type="hidden" value="<cfoutput>#get_package.recordcount#</cfoutput>"></th>
									<th width="35"><cf_get_lang dictionary_id='58082.Adet'> *</th>
									<th width="200"><cf_get_lang dictionary_id='45477.Paket Tipi'> *</th>
									<th><cf_get_lang dictionary_id='45478.Ebat'></th>
									<th><cf_get_lang dictionary_id='29784.Ağırlık'> (<cf_get_lang dictionary_id="45766.kg">)</th>
									<th><cf_get_lang dictionary_id='57633.Barkod'></th>
									<th width="200"><cf_get_lang dictionary_id='45545.Paketleyen'></th>
								</tr>	
							</thead>
							<tbody id="table2">
								<cfoutput query="get_package">
									<cfquery name="GET_TYPE" datasource="#DSN#">
										SELECT PACKAGE_TYPE, DIMENTION FROM SETUP_PACKAGE_TYPE WHERE PACKAGE_TYPE_ID = <cfif len(package_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#package_type#"><cfelse>0</cfif> 
									</cfquery>
									<tr id="frm_row_other#currentrow#">
										<td>
											<a onclick="sil_other('#currentrow#');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
										</td>
										<td>
											<div class="form-group">
												<input type="text" name="ship_result_package_id#currentrow#" id="ship_result_package_id#currentrow#" value="#ship_result_package_id#" style="width:20px;">
												<input type="hidden" name="row_kontrol_other#currentrow#" id="row_kontrol_other#currentrow#" value="1">
											</div>
										</td>
										<td width="35"><input type="text" name="quantity#currentrow#" id="quantity#currentrow#" value="#tlformat(package_piece,0)#" onblur="degistir('#currentrow#');" onkeyup="return(FormatCurrency(this,event,0));" class="moneybox"></td>
										<td>
											<div class="form-group">
												<select name="package_type#currentrow#" id="package_type#currentrow#" onchange="degistir('#currentrow#');">
													<cfset value_package_type = package_type>
													<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
													<cfloop query="get_package_type">
														<option value="#package_type_id#,#dimention#,#calculate_type_id#" <cfif value_package_type eq package_type_id>selected</cfif>>#package_type#</option>
													</cfloop>
												</select>
											</div>
										</td>
										<td><div class="form-group"><input type="text" name="ship_ebat#currentrow#" id="ship_ebat#currentrow#" value="#PACKAGE_DIMENTION#"></div></td>
										<td><div class="form-group"><input type="text" name="ship_agirlik#currentrow#" id="ship_agirlik#currentrow#" value="#tlformat(package_weight)#" onblur="degistir('#currentrow#');" onkeyup="return(FormatCurrency(this,event));" class="moneybox"></div></td>
										<td><div class="form-group"><input type="hidden" name="total_price#currentrow#" id="total_price#currentrow#" value="#tlformat(total_price)#" onkeyup="return(FormatCurrency(this,event));" class="moneybox" readonly><input type="hidden" name="other_money#currentrow#" id="other_money#currentrow#" value="#other_money#" class="moneybox" readonly><input type="text" name="ship_barcod#currentrow#" id="ship_barcod#currentrow#" value="#barcode#"></div></td>
										<td nowrap="nowrap">
											<div class="form-group">
												<div class="input-group">
													<input type="hidden" name="pack_emp_id#currentrow#" id="pack_emp_id#currentrow#" value="#get_package.pack_emp_id#">
													<input type="text" name="pack_emp_name#currentrow#" id="pack_emp_name#currentrow#" value="#get_package.pack_name#">
													<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac2(#currentrow#);"></span>
												</div>
											</div>
										</td>
									</tr>
								</cfoutput>
							</tbody>	
						</cf_grid_list>
					</div>
				</div>
			</cfif>
			<div class="col col-12">
				<cf_box_footer>
					<cf_record_info query_name="get_ship_result">
					<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=stock.emptypopup_del_packetship&multi_packet_ship=0&ship_result_id=#attributes.ship_result_id#&head=#get_ship_result.ship_fis_no#&is_type=#get_ship_result.is_type#' add_function='control()'>	<!--- is_delete='0' --->
				</cf_box_footer> 
			</div>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
<cfif is_show_cost eq 1>
	calculate_type_deger=<cfoutput>#get_ship_method_price.calculate_type#</cfoutput>;
	row_count2=<cfoutput>#get_package.recordcount#</cfoutput>;
</cfif>

row_count=<cfoutput>#get_row.recordcount#</cfoutput>;
money_list = "<cfoutput>#valuelist(moneys.money,',')#</cfoutput>";
rate1_list = "<cfoutput>#valuelist(moneys.rate1,',')#</cfoutput>";
rate2_list = "<cfoutput>#valuelist(moneys.rate2,',')#</cfoutput>";
function add_adress(adress_type)
{
	if(!(upd_packet_ship.partner_id.value=="") || !(upd_packet_ship.consumer_id.value==""))
	{	
		if(upd_packet_ship.partner_id.value!="")
		{
			str_adrlink = '&field_adres=upd_packet_ship.sending_address&field_city=upd_packet_ship.sending_city_id&field_city_name=upd_packet_ship.sending_city&field_county=upd_packet_ship.sending_county_id&field_county_name=upd_packet_ship.sending_county&field_postcode=upd_packet_ship.sending_postcode&field_semt=upd_packet_ship.sending_semt'; 
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(upd_packet_ship.company.value)+''+ str_adrlink);
			return true;
		}
		else
		{
			str_adrlink = '&field_adres=upd_packet_ship.sending_address&field_city=upd_packet_ship.sending_city_id&field_city_name=upd_packet_ship.sending_city&field_county=upd_packet_ship.sending_county_id&field_county_name=upd_packet_ship.sending_county&field_country=upd_packet_ship.sending_country_id&field_country_name=upd_packet_ship.sending_country&field_postcode=upd_packet_ship.sending_postcode&field_semt=upd_packet_ship.sending_semt'; 
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(upd_packet_ship.member_name.value)+''+ str_adrlink);
			return true;
		}
	}
	else
	{
		alert("<cf_get_lang dictionary_id ='45308.Cari Hesap Seçiniz'> !");
		return false;
	}		
}

function pencere_ac(no)
{	
	if(document.getElementById('member_name').value !='')
	{
		document.getElementById('ship_id_list').value  ='';
		for(r=1;r<=upd_packet_ship.record_num.value;r++)
		{
			deger_row_kontrol = document.getElementById("row_kontrol"+r);
			deger_ship_id = document.getElementById("ship_id"+r);
			if(deger_row_kontrol.value == 1)
			{
				if(document.getElementById('ship_id_list').value == '')
				{
					if(deger_ship_id.value != '')
						document.getElementById('ship_id_list').value = deger_ship_id.value;
				}
				else
				{
					if(deger_ship_id.value != '')
						document.getElementById('ship_id_list').value += ','+deger_ship_id.value;
				}	
			}
		}		
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,".")#.popup_list_ship_details</cfoutput>&ship_id_list=' + document.getElementById("ship_id_list").value + '&ship_id=upd_packet_ship.ship_id'+no+'&ship_number=upd_packet_ship.ship_number'+no+'&ship_date=upd_packet_ship.ship_date'+no+'&ship_deliver=upd_packet_ship.ship_deliver'+no+'&ship_type=upd_packet_ship.ship_type'+no+'&ship_adress=upd_packet_ship.ship_adress'+no+'&is_gonder=1&deliver_company_id='+document.getElementById("company_id").value);//&deliver_company_id='+upd_packet_ship.service_company_id.value
	}
	else
	{
		alert("<cf_get_lang dictionary_id='45308.Cari Hesap Seçiniz'>!");
	}
}

function pencere_ac2(no)
{
	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_packet_ship.pack_emp_id'+ no +'&field_name=upd_packet_ship.pack_emp_name'+ no+'&select_list=1');
}

function pencere_ac2_main()
{
	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_packet_ship.pack_emp_id0&field_name=upd_packet_ship.pack_emp_name0&select_list=1&call_function=hepsi()');
}

function sil(sy)
{
	var my_element=document.getElementById("row_kontrol"+sy);
	my_element.value=0;
	var my_element=eval("frm_row"+sy);
	my_element.style.display="none";
}
function sil_other(sy)
{
	var my_element2=document.getElementById("row_kontrol_other"+sy);
	my_element2.value=0;
	var my_element2=eval("frm_row_other"+sy);
	my_element2.style.display="none";
	if(document.getElementById('calculate_type_2').checked)/*Paket ise*/
		return kur_hesapla();
	else
		degistir(sy);
}

function add_row()
{	
		
	row_count++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);		
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);		
	document.getElementById('record_num').value=row_count;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="hidden" value="" name="ship_result_row_id' + row_count +'" id="ship_result_row_id' + row_count +'"><input  type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><a onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="Sil"></i></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="hidden" name="ship_id' + row_count +'" id="ship_id' + row_count +'"><div class="form-group"><div class="input-group"><input type="text" name="ship_number' + row_count +'" id="ship_number' + row_count +'" value="" readonly><span class="input-group-addon icon-ellipsis" onClick="pencere_ac('+ row_count +');"></span></div></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="ship_date' + row_count +'" id="ship_date' + row_count +'" value="" readonly></div></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<div class="form-group"><input type="text" name="ship_deliver' + row_count +'" id="ship_deliver' + row_count +'" value="" readonly></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<div class="form-group"><input type="text" name="ship_adress' + row_count +'" id="ship_adress' + row_count +'" value="" readonly></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<div class="form-group"><input type="text" name="ship_type' + row_count +'" id="ship_type' + row_count +'" value="" readonly></div>';
}

function add_row_other()
{
	row_count2++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);
	newRow.setAttribute("name","frm_row_other" + row_count2);
	newRow.setAttribute("id","frm_row_other" + row_count2);		
	newRow.setAttribute("NAME","frm_row_other" + row_count2);
	newRow.setAttribute("ID","frm_row_other" + row_count2);		
	document.getElementById('record_num_other').value=row_count2;
	/* - Sil */
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="hidden" name="ship_result_package_id' + row_count2 +'" id="ship_result_package_id' + row_count2 +'" value=""><input type="hidden" value="1" name="row_kontrol_other' + row_count2 +'" id="row_kontrol_other' + row_count2 +'"><a onclick="sil_other(' + row_count2 + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';


	/* NO */
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="record_num_other' + row_count2 +'" id="record_num_other' + row_count2 +'" value="' + row_count2 +'" style="width:35px">';

	
	/* ADET */
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<div class="form-group"><input type="text" name="quantity' + row_count2 +'" id="quantity' + row_count2 +'" onblur="degistir( ' + row_count2 + ');" onKeyup="return(FormatCurrency(this,event,0));" value="<cfoutput>#tlformat(1,0)#</cfoutput>" class="moneybox" style="width:35px"></div>';

	/* PAKET TİPİ */
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<div class="form-group"><select name="package_type' + row_count2 +'" id="package_type' + row_count2 +'" onchange="degistir( ' + row_count2 + ');"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfoutput query="get_package_type"><option value="#package_type_id#,#dimention#,#calculate_type_id#">#package_type#</option></cfoutput></select></div>'; //add_general_prom();

	/* ebat */
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<div class="form-group"><input type="text" name="ship_ebat' + row_count2 +'" id="ship_ebat' + row_count2 +'" value=""></div>';

	/* ağırlık */
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<div class="form-group"><input type="text" name="ship_agirlik' + row_count2 +'" id="ship_agirlik' + row_count2 +'" value="" onBlur="degistir(' + row_count2 + ');" onKeyup="return(FormatCurrency(this,event));" class="moneybox"></div>';

	/* barkod */
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="hidden" name="total_price' + row_count2 +'" id="total_price' + row_count2 +'" value="" onKeyup="return(FormatCurrency(this,event));" class="moneybox" readonly><input type="hidden" name="other_money' + row_count2 +'" id="other_money' + row_count2 +'" value="" class="moneybox" readonly><input type="text" name="ship_barcod' + row_count2 +'" id="ship_barcod' + row_count2 +'" value="">';
	
	/* paketleyen */
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<div class="input-group"><input type="hidden" name="pack_emp_id' + row_count2 +'" id="pack_emp_id' + row_count2 +'" value=""><input type="text" name="pack_emp_name' + row_count2 +'" id="pack_emp_name' + row_count2 +'" value=""><span class="input-group-addon btnPointer icon-ellipsis no-bg" onClick="pencere_ac2('+ row_count2 +');"></span></div>';
	
}
<cfif is_show_cost eq 1>
	function degistir(id)
	{
		if(document.getElementById("row_kontrol_other"+id).value == 1)
		{
			if(trim(document.getElementById("quantity"+id).value).length == 0)
				document.getElementById("quantity"+id).value = 1;
		}
		if(document.getElementById('calculate_type_2').checked)/*Paket ise*/
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
				desi_1 = list_getat(temp_desi,1,'*');
				desi_2 = list_getat(temp_desi,2,'*');
				desi_3 = list_getat(temp_desi,3,'*');
				desi_hesap = (parseInt(desi_1)*parseInt(desi_2)*parseInt(desi_3)/3000);
				if(desi_hesap<<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>)
				{	
					var listParam = document.getElementById('transport_comp_id').value + "*" + document.getElementById('ship_method_id').value + "*" + desi_hesap;
					var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
				}
				else 
				{
					var listParam = document.getElementById('transport_comp_id').value + "*" + document.getElementById('ship_method_id').value + "*" + "<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>";
					var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
				}
			}
			else if(temp_package_type_id==2) 
			{	
				temp_ship_agirlik_ = parseFloat(filterNum(temp_ship_agirlik.value))*parseFloat(temp_quantity.value);
				//burdaki ifadenin ust limiti asmasi durumunda rakam uste yuvarlanir Or: 31,5 degeri 32 olur
				if(temp_ship_agirlik_><cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>)
					temp_ship_agirlik_ = Math.ceil(temp_ship_agirlik_);
				if(temp_ship_agirlik.value !="" && temp_ship_agirlik.value !=0)
				{
					if(temp_ship_agirlik_<<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>)
					{
						var listParam = document.getElementById('transport_comp_id').value + "*" + document.getElementById('ship_method_id').value + "*" + temp_ship_agirlik_;
						var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
					}
					else
					{
						var listPAram = document.getElementById('transport_comp_id').value + "*" + document.getElementById('ship_method_id').value + "*" + "<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>";
						var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
					}
				}	
			}	
			else if(temp_package_type_id==3)  //Zarf ise
			{
				var listParam = document.getElementById('transport_comp_id').value + "*" + document.getElementById('ship_method_id').value;
				var GET_PRICE = wrk_safe_query("stk_GET_PRICE_2",'dsn',0,listParam);
			}
			if(GET_PRICE != undefined)
			{
				if(GET_PRICE.recordcount==0)
				{
					alert("<cf_get_lang dictionary_id ='45648.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma Paket Tipini Kontrol Ediniz (Fiyat Listesi)'>!"+GET_PRICE.recordcount);
					temp_ship_ebat.value = "";
					temp_total_price.value = "";
					temp_other_money.value = "";
				}
				else
				{
					if(temp_package_type_id==1)//Desi ise
					{
						temp_ship_agirlik.value = "";
						if(desi_hesap<<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>)
						{
							temp_total_price.value = commaSplit(GET_PRICE.PRICE*temp_quantity.value);/*Toplam atanıyor.*/
						}
						else 
						{
							var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30','dsn',0,document.getElementById('transport_comp_id').value);
							desi_remain = parseFloat((parseInt(desi_1)*parseInt(desi_2)*parseInt(desi_3))/(3000)-<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>);
							temp_total_price.value = commaSplit(parseFloat(GET_PRICE.PRICE*temp_quantity.value)+parseFloat(GET_PRICE_30.PRICE*desi_remain*temp_quantity.value));
						}
					}
					if(temp_package_type_id==2)//Kg ise
					{
						temp_ship_ebat.value = "";
						if(temp_ship_agirlik_<<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>)
						{
							temp_total_price.value = commaSplit(GET_PRICE.PRICE);
						}
						else
						{
							var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30','dsn',0,document.getElementById('transport_comp_id').value);
							kg_remain = parseFloat(temp_ship_agirlik_-<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>);
							temp_total_price.value = commaSplit(parseFloat(GET_PRICE.PRICE)+parseFloat(GET_PRICE_30.PRICE*kg_remain));
						}
					}				
					
					else if(temp_package_type_id==3)//Zarf ise
					{
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
			
			for(r=1;r<=upd_packet_ship.record_num_other.value;r++)
			{
				if(document.getElementById("row_kontrol_other"+r).value == 1)
				{
					var temp_package_type = document.getElementById("package_type"+r);
					var temp_ship_ebat = document.getElementById("ship_ebat"+r);
					var temp_quantity = document.getElementById("quantity"+r);
					temp_desi = list_getat(temp_package_type.value,2,',');
					temp_package_type_id = list_getat(temp_package_type.value,3,',');
					if(temp_package_type_id==1) //Desi
					{
						
						count_desi += 1;
						temp_ship_ebat.value = temp_desi;
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
						temp_ship_agirlik = document.getElementById("ship_agirlik"+r);
						temp_ship_agirlik_ = filterNum(temp_ship_agirlik.value);
						if(temp_ship_agirlik.value !="" && temp_ship_agirlik.value !=0)
							kg_sum +=parseFloat(temp_ship_agirlik_)*parseFloat(temp_quantity.value);
					}	
					else if(temp_package_type_id==3)//Zarf ise
					{
						count_envelope += 1;
						var listParam = document.getElementById('transport_comp_id').value + "*" + document.getElementById('ship_method_id').value;
						var GET_PRICE3 = wrk_safe_query("stk_GET_PRICE_2",'dsn',0,listParam);
						if(GET_PRICE3 != undefined)
						{
							if(GET_PRICE3.recordcount==0)
								alert("<cf_get_lang dictionary_id ='45649.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma Paket Tipini(Zarf) Kontrol Ediniz (Fiyat Listesi)'>!");
							else
								envelope_price_sum += GET_PRICE3.PRICE * parseFloat(temp_quantity.value);
						}					
					}
				}
			}
	
			if(count_desi != 0)
			{
				if(desi_sum<<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>)
				{
					var listParam = +document.getElementById('transport_comp_id').value + "*" + document.getElementById('ship_method_id').value + "*" + desi_sum;
					var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
				}
				else
				{
					var listParam = document.getElementById('transport_comp_id').value + "*" + document.getElementById('ship_method_id').value + "*" + "<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>";
					var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
				}
				
				if(GET_PRICE1 != undefined)
				{
					if(GET_PRICE1.recordcount==0)
						alert("<cf_get_lang dictionary_id ='45650.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma Paket Tipini(Desi) Kontrol Ediniz (Fiyat Listesi)'>!");
					else
					{
						if(desi_sum<<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>)
						{
							desi_price_sum = GET_PRICE1.PRICE;
						}
						else
						{					
							var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30','dsn',0,document.getElementById('transport_comp_id').value);
							desi_remain2 = parseFloat(desi_sum-<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>);
							desi_price_sum = parseFloat(GET_PRICE1.PRICE)+parseFloat(GET_PRICE_30.PRICE*desi_remain2);
						}
					}
				}
			}
			if(count_kg != 0)
			{
				if(kg_sum<<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>)
				{
					var listParam = document.getElementById('transport_comp_id').value + "*" + document.getElementById('ship_method_id').value + "*" + kg_sum;
					var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
				}
				else
				{
					var listPAram = document.getElementById('transport_comp_id').value + "*" + document.getElementById('ship_method_id').value + "*" + "<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>";
					var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
				}
				
				if(GET_PRICE1 != undefined)
				{
					if(GET_PRICE1.recordcount==0)
						alert("<cf_get_lang dictionary_id ='45651.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma Paket Tipini(Kg) Kontrol Ediniz (Fiyat Listesi)'>!");
					else
					{
						if(kg_sum<<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>)
						{
							kg_price_sum = GET_PRICE1.PRICE;
						}
						else
						{					
							var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30','dsn',0,document.getElementById('transport_comp_id').value);
							kg_remain2 = parseFloat(kg_sum-<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>);
							kg_remain2 = Math.ceil(kg_remain2);
							kg_price_sum = parseFloat(GET_PRICE1.PRICE)+parseFloat(GET_PRICE_30.PRICE*kg_remain2);
						}
					}
				}
			}
			document.getElementById('total_cost_value').value = commaSplit(parseFloat(desi_price_sum)+parseFloat(kg_price_sum)+parseFloat(envelope_price_sum));
		}
		return kur_hesapla();
	}
</cfif>
function fiyat_hesapla(satir)
{
	if(trim(document.getElementById("quantity"+satir).value).length == 0)
		document.getElementById("quantity"+satir).value = 1;
	
	if(document.getElementById("price"+satir).value.length != 0)
		document.getElementById("total_price"+satir).value = commaSplit(filterNum(document.getElementById("quantity"+satir).value) * filterNum(document.getElementById("price"+satir).value));
		
	return kur_hesapla();
}

function control()
{
	document.upd_packet_ship.ship_price.value = filterNum(document.upd_packet_ship.ship_price.value);
	deger_zarf_kontrol = 0;	
	<cfif is_department_required eq 1>
		if((document.getElementById("department_id").value=="") || (document.getElementById("department_name").value==""))
		{
			alert("Çıkış Depo Seçiniz !");
			return false;
		}
	</cfif>
	<cfif is_show_cost eq 1>
		if(document.getElementById('transport_comp_id').value != document.getElementById('transport_comp_id_').value)//Taşıyıcı firma değiştirildiyse	
		{	
			if(!(list_find(<cfoutput>'#transport_selected#'</cfoutput>,document.getElementById('transport_comp_id').value,',')))//Taşıyıcı firmanın dışında seçilen firma daha önceden seçilmiş mi?
			{
				alert("<cf_get_lang dictionary_id='45550.Bu Taşıyıcı Firmaya Ait Fiyat Listesi Yok'>!!");
				return false;
			}
		}
	</cfif>
	if((upd_packet_ship.company_id.value=="") && (upd_packet_ship.consumer_id.value==""))
	{
		alert("<cf_get_lang dictionary_id='45308.Cari Hesap Seçiniz'>");
		return false;
	}

	if(upd_packet_ship.ship_method_id.value == "" || upd_packet_ship.ship_method_name.value == "")	
	{
		alert("<cf_get_lang dictionary_id='45482.Lütfen Sevk Yöntemi Seçiniz'> !");
		return false;
	}
	
	//Irsaliye kontrolleri	
	for(r=1;r<=upd_packet_ship.record_num.value;r++)
	{
		deger_row_kontrol = document.getElementById("row_kontrol"+r);
		deger_ship_id = document.getElementById("ship_id"+r);
		if(deger_row_kontrol.value == 1)
		{
			if(deger_ship_id.value == "")
			{
				alert("<cf_get_lang dictionary_id='45483.Lütfen İrsaliye Seçiniz'> !");
				return false;
			}
		}
	}
	
	//Zarf ise sevkiyat adresi zorunlu
	if(deger_zarf_kontrol == 1)
	{
		if(document.getElementById('sending_address').value == "")
		{
			alert("<cf_get_lang dictionary_id ='45652.Zarf Gönderilerinde Sevkiyat Adresi Seçilmelidir'>!")
			return false;
		}
	}	
	
	if(document.getElementById('sending_address').value.length > 300)
	{
		alert("<cf_get_lang dictionary_id ='45653.Sevkiyat Adresi 300 Karakterden Fazla Olamaz'>!");
		return false;
	}
	<cfif is_show_cost eq 1>
		// Paket kontrolleri
		for(r=1; r<=document.getElementById("record_num_other").value; r++)
		{
			if(document.getElementById("row_kontrol_other"+r).value == 1)
			{
				if( document.getElementById("package_type"+r).value == "")
				{
					alert("<cf_get_lang dictionary_id='45484.Lütfen Paket Tipi Seçiniz'> !");
					return false;
				}
				if(list_getat( document.getElementById("package_type"+r).value,3) == 3)
					deger_zarf_kontrol = 1;			
			}
		}
		
		if (document.getElementById("record_num_other").value == 0)
		{
			alert("<cf_get_lang dictionary_id='61196.Paketleme Tipi Seçiniz'>!");
			return false;	
		}
		else 
			unformat_fields();
	</cfif>	
	
/*	if (document.getElementById("record_num").value == 0)
	{
		alert("İrsaliye Seçiniz!");
		return false;	
	}*/
	/*
	for(i=1;i<=document.getElementById('record_num').value;++i)
	{
		document.getElementById('upd_packet_ship').appendChild(document.getElementById('row_kontrol' + i));
		document.getElementById('upd_packet_ship').appendChild(document.getElementById('ship_id' + i));
		document.getElementById('upd_packet_ship').appendChild(document.getElementById('ship_number' + i));
		document.getElementById('upd_packet_ship').appendChild(document.getElementById('ship_date' + i));
		document.getElementById('upd_packet_ship').appendChild(document.getElementById('ship_deliver' + i));
		document.getElementById('upd_packet_ship').appendChild(document.getElementById('ship_type' + i));
		document.getElementById('upd_packet_ship').appendChild(document.getElementById('ship_adress' + i));
	}
	for(i=1;i<=document.getElementById('record_num_other').value;++i)
	{
		document.getElementById('upd_packet_ship').appendChild(document.getElementById('package_type' + i));
		document.getElementById('upd_packet_ship').appendChild(document.getElementById('ship_ebat' + i));
		document.getElementById('upd_packet_ship').appendChild(document.getElementById('total_price' + i));
		document.getElementById('upd_packet_ship').appendChild(document.getElementById('quantity' + i));
		document.getElementById('upd_packet_ship').appendChild(document.getElementById('other_money' + i));
		document.getElementById('upd_packet_ship').appendChild(document.getElementById('ship_agirlik' + i));
		document.getElementById('upd_packet_ship').appendChild(document.getElementById('row_kontrol_other' + i));
		document.getElementById('upd_packet_ship').appendChild(document.getElementById('ship_barcod' + i));
		document.getElementById('upd_packet_ship').appendChild(document.getElementById('pack_emp_id' + i));
		document.getElementById('upd_packet_ship').appendChild(document.getElementById('pack_emp_name' + i));
	}
	*/
	return true;
}

function kur_hesapla()
{
	total_cost_value = 0;
	if(document.getElementById('calculate_type_2').checked)/*Paket ise*/
	{		
		for(r=1; r<=document.getElementById('record_num_other').value; r++)
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
		
		document.getElementById('total_cost_value').value = commaSplit(total_cost_value);
		document.getElementById('total_cost2_value').value = commaSplit(total_cost2_value);
	}
	else
	{
		temp2_sira = list_find(money_list,<cfoutput>'#session.ep.money2#'</cfoutput>); 
		temp2_rate1 = list_getat(rate1_list,temp2_sira);
		temp2_rate2 = list_getat(rate2_list,temp2_sira);
		total_cost2_value = filterNum(document.getElementById('total_cost_value').value) * (parseFloat(temp2_rate1) / parseFloat(temp2_rate2));
		document.getElementById('total_cost2_value').value = commaSplit(total_cost2_value);
	}
	return true;
}
function change_packet(calculate_type_value)
{
	if(row_count2!=0)
	{
		if(calculate_type_deger!=calculate_type_value)
		{
			if(calculate_type_value == 2)/*Satır ise*/
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
				document.getElementById('total_cost_value').value = commaSplit(0);
				document.getElementById('total_cost2_value').value = commaSplit(0);				
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
function unformat_fields()
{
	for(r=1; r<=document.getElementById('record_num_other').value; r++)
	{
		if(document.getElementById("row_kontrol_other"+r).value == 1)
		{
			document.getElementById("quantity"+r).value = filterNum(document.getElementById("quantity"+r).value);
			document.getElementById("ship_agirlik"+r).value = filterNum(document.getElementById("ship_agirlik"+r).value);
			document.getElementById("total_price"+r).value = filterNum(document.getElementById("total_price"+r).value);
			
		}
	}
	document.getElementById('total_cost_value').value = filterNum(document.getElementById('total_cost_value').value);
	document.getElementById('total_cost2_value').value = filterNum(document.getElementById('total_cost2_value').value);
}

function hepsi()
{
	deger = document.getElementById('pack_emp_name0').value;
	deger2 = document.getElementById('pack_emp_id0').value;

	for(var i=1;i<=document.getElementById('record_num_other').value;i++)
	{
		nesne_ = document.getElementById("pack_emp_name"+i);
		nesne_.value = deger;
		nesne2_ = document.getElementById("pack_emp_id"+i);
		nesne2_.value = deger2;
	}
}

function pencere_ac_(no)
{
	if (document.getElementById('sending_country_id').value == "")
	{
		alert("<cf_get_lang dictionary_id ='45654.İlk Olarak Ülke Seçiniz'> !");
	}	
	else if(document.getElementById('sending_city_id').value == "")
	{
		alert("<cf_get_lang dictionary_id ='45491.İl Seçiniz'>!");
	}
	else
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=upd_packet_ship.sending_county_id&field_name=upd_packet_ship.sending_county&city_id=' + document.getElementById('sending_city_id').value,'','ui-draggable-box-small');
		document.getElementById('sending_county_id').value = '';
		document.getElementById('sending_county').value = '';
	}
}
function pencere_ac_city()
{
	if (document.getElementById('sending_country_id').value == "")
	{
		alert("<cf_get_lang dictionary_id ='45654.İlk Olarak Ülke Seçiniz'> !");
	}	
	else
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=upd_packet_ship.sending_city_id&field_name=upd_packet_ship.sending_city&country_id=' + document.getElementById('sending_country_id').value,'','ui-draggable-box-small');
	}
	return remove_adress('2');
}

function remove_adress(parametre)
{
	if(parametre==1)
	{
		document.getElementById('sending_city_id').value = '';
		document.getElementById('sending_city').value = '';
		document.getElementById('sending_county_id').value = '';
		document.getElementById('sending_county').value = '';
	}
	else
	{
		document.getElementById('sending_county_id').value = '';
		document.getElementById('sending_county').value = '';
	}	
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
