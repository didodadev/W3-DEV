<!---BU SAYFA HEM BASKET, HEM POPUP SAYFA OLARAK KULLANILDIĞI İÇİN BASKETE GÖRE DÜZENLENMİŞTİR.--->
<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_money.cfm">
<cfquery name="get_ship" datasource="#dsn#">
	SELECT SHIP_METHOD,SHIP_METHOD_ID FROM SHIP_METHOD ORDER BY SHIP_METHOD_ID
</cfquery>
<cfquery name="get_ship_num" datasource="#dsn#">
	SELECT MAX(SHIP_ID) AS MAX_SHIP_ID FROM ASSET_P_TRANSPORT 
</cfquery>
<cfif isdefined("attributes.assetp_id") and len(attributes.assetp_id)>
	<cfquery name="get_asset" datasource="#dsn#">
		SELECT ASSETP_ID,ASSETP FROM ASSET_P WHERE ASSETP_ID=#attributes.assetp_id#
	</cfquery>
    <cfset pageHead = "#getLang('assetcare',157)# : #getLang('main',1656)# : #get_asset.assetp# ">
<cfelse>
	<cfset pageHead = "#getLang('assetcare',157)#">
</cfif>
<cfif len(get_ship_num.max_ship_id)>
	<cfset max_ship_id = get_ship_num.max_ship_id>
	<cfset max_ship_id = max_ship_id + 1>
<cfelse>
	<cfset max_ship_id = 1>
</cfif>
<cfinclude template="../query/get_document_type.cfm">

<cf_catalystHeader>
	<cf_box>
	<div class="col col-12 uniqueRow">
		<cfform method="post" name="add_transport" action="#request.self#?fuseaction=assetcare.emptypopup_add_vehicle_transport" onsubmit="return unformat_fields();">
			<cf_box_elements>
			<input type="hidden" name="is_detail" id="is_detail" value="0">
			<div class="row">
				<div class="row">
					<div class="row" type="row">
						<div class="col col-4 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-shipping_num">
								<label class="col col-4 col-xs-12"><cf_get_lang no='319.Sevk No'></label>
								<div class="col col-8 col-xs-12">
									<input type="text" name="shipping_num" id="shipping_num" value="<cfoutput>#max_ship_id#</cfoutput>" maxlength="50" readonly >
								</div>
							</div>
							<div class="form-group" id="item-shipping_date">
								<label class="col col-4 col-xs-12"><cf_get_lang no='411.Sevk Tarihi'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="text" name="shipping_date" id="shipping_date" maxlength="10"  > 
										<span class="input-group-addon"><cf_wrk_date_image date_field="shipping_date"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-sender_depot">
								<label class="col col-4 col-xs-12"><cf_get_lang no='410.Gönderen Şube'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="sender_depot_id" id="sender_depot_id" value="">
										<input type="text" name="sender_depot" id="sender_depot" value="" readonly  > 
										<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_name=add_transport.sender_depot&field_id=add_transport.sender_depot_id','list','popup_list_departments')"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-sender_employee">
								<label class="col col-4 col-xs-12"><cf_get_lang no='409.Gönderen Kişi'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input name="sender_employee_id" id="sender_employee_id" type="hidden" value="">
										<input type="text" name="sender_employee" id="sender_employee" maxlength="10"  readonly> 
										<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_transport.sender_employee_id&field_name=add_transport.sender_employee&branch_related&select_list=1','list','popup_list_positions')"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-receiver_depot">
								<label class="col col-4 col-xs-12"><cf_get_lang no='408.Alıcı Şube'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="receiver_depot_id" id="receiver_depot_id">
										<input type="text" name="receiver_depot" id="receiver_depot" value="" readonly> 
										<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_name=add_transport.receiver_depot&field_id=add_transport.receiver_depot_id&is_all_departments=1','list','popup_list_departments')"></span>
									</div>
								</div>
							</div>
						</div>
						<div class="col col-4 col-xs-12" type="column" index="2" sort="true">
							<div class="form-group" id="item-document_num">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='468.Belge No'></label>
								<div class="col col-8 col-xs-12">
									<input name="document_num" id="document_num" type="text" maxlength="40" >
								</div>
							</div>

							<div class="form-group" id="item-shipping_type">
								<label class="col col-4 col-xs-12"><cf_get_lang no='258.Taşıma Tipi'></label>
								<div class="col col-8 col-xs-12">
									<select name="shipping_type" id="shipping_type" >
										<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
										<cfoutput query="get_ship">
											<option value="#ship_method_id#">#ship_method#</option>
										</cfoutput>
									</select>
								</div>
							</div>


							<div class="form-group" id="item-transporter">
								<label class="col col-4 col-xs-12"><cf_get_lang no='407.Taşıyan Firma'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="transporter_id" id="transporter_id" value="">
										<input type="text" name="transporter" id="transporter" value="" readonly > 
										<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=add_transport.transporter_id&field_comp_name=add_transport.transporter&is_buyer_seller=1&select_list=2','list','popup_list_pars')"></span>
									</div>
								</div>
							</div>
							
							<div class="form-group" id="item-plate">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='1656.Plaka'></label>
								<div class="col col-8 col-xs-12">
									<input name="plate" id="plate" type="text"  value="<cfif isdefined("get_asset.assetp") and len(get_asset.assetp)><cfoutput>#get_asset.assetp#</cfoutput></cfif>">
								</div>
							</div>
							
							<div class="form-group" id="item-stuff_type">
								<label class="col col-4 col-xs-12"><cf_get_lang no='406.Gönderi'></label>
								<div class="col col-2 col-xs-12">
									<input name="quantity" id="quantity" type="text" onKeyup="return(FormatCurrency(this,event,0));" placeholder="<cfoutput><cf_get_lang_main no='670.Adet'></cfoutput>">
								</div>
								<div class="col col-2 col-xs-12">
									<input name="desi" id="desi" type="text" onKeyup="return(FormatCurrency(this,event,0));"  placeholder="<cfoutput><cf_get_lang no='442.Desi'></cfoutput>">
								</div>
								<div class="col col-2 col-xs-12">
									<select name="stuff_type" id="stuff_type" >
										<option value="1"><cf_get_lang no='441.Koli'></option>
										<option value="2"><cf_get_lang_main no='279.Dosya'></option>
										<option value="3"><cf_get_lang_main no='1068.Arac'></option>
									</select>
								</div>
							</div>

						</div>
						<div class="col col-4 col-xs-12" type="column" index="3" sort="true">
							<div class="form-group" id="item-shipping_status">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='70.Asama'></label>
								<div class="col col-8 col-xs-12">
									<select name="shipping_status" id="shipping_status" >
										<option value="0"><cf_get_lang no='435.Gönderildi'></option>
										<option value="0"><cf_get_lang no='659.Alındı'></option>
									</select>
								</div>
							</div>
							<div class="form-group" id="item-document_type">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='1121.Belge Tipi'></label>
								<div class="col col-8 col-xs-12">
									<select name="document_type" id="document_type" >
										<cfoutput query="get_document_type"> 
											<option value="#document_type_id#">#document_type_name#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group" id="item-total_amount">
								<label class="col col-4 col-xs-12"><cf_get_lang no='243.KDV li Toplam Tutar'></label>
								<div class="col col-8 col-xs-12">
									
										<div class="col col-8">
											<input type="text" name="total_amount" id="total_amount" onKeyup="return(FormatCurrency(this,event));"> 
										</div>
										<div class="col col-4">
											<select name="total_currency" id="total_currency">
												<cfoutput query="get_money"> 
													<option value="#money#"<cfif money eq session.ep.money>selected</cfif>>#money#</option>
												</cfoutput>
											</select>
										</div>
								
								</div>
							</div>

							<div class="form-group" id="item-detail">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
								<div class="col col-8 col-xs-12">
									<textarea name="detail" id="detail" style="width:155px;height:35px"></textarea>
								</div>
							</div>

						</div>
					</div>
				</div>
			</div>
		</cf_box_elements>
			<cf_box_footer>
            	<cf_workcube_buttons is_upd='0' is_cancel='0' is_reset='0' add_function="kontrol()">

				</cf_box_footer>
				
		</cfform>
	</div>
</cf_box>
<cfinclude template="../display/list_vehicle_transport.cfm"> 
<script type="text/javascript">
	function unformat_fields()
	{
		var fld = document.add_transport.quantity;
		var fld3 = document.add_transport.total_amount;
		fld.value = filterNum(fld.value);
		fld3.value = filterNum(fld3.value);
	}
	function kontrol()
	{
		if(document.add_transport.shipping_date.value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='411.Geçerli sevk tarihi'>!");
			return false;
		}
		
		if(!CheckEurodate(document.add_transport.shipping_date.value,"<cf_get_lang no='411.Sevk Tarihi'>"))
			return false;
		
		if(document.add_transport.sender_depot.value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='410.Gönderen Şube'>!");
			return false;
		}
		
		if(document.add_transport.sender_employee.value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='409.Gönderen Kişi'>!");
			return false;
		}
		
		if(document.add_transport.receiver_depot.value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='408.Alıcı Şube'>!");
			return false;
		}
		
		x = document.add_transport.shipping_type.selectedIndex;
		if(document.add_transport.shipping_type[x].value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='258.Taşıma Tipi'>!");
			return false;
		}
		
		if(document.add_transport.transporter.value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1195.Firma'>!");
			return false;
		}
		return true;
	}
</script>
