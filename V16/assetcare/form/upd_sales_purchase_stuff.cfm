<cfinclude template="../query/get_money.cfm">
<cfquery name="GET_SOLD_STUFF" datasource="#DSN#">
	SELECT
		ASSET_P_SOLD.ASSET_P_SOLD_ID,
		ASSET_P.ASSETP,
		ASSET_P.ASSETP_STATUS,
		ASSET_P_SOLD.ASSETP_ID,
		ASSET_P_SOLD.COMPANY_ID_BUYER,
		ASSET_P_SOLD.NAME_BUYER,
		ASSET_P_SOLD.TEL_AREA_CODE,
		ASSET_P_SOLD.TEL_NUM_BUYER,
		ASSET_P_SOLD.GSM_CODE,
		ASSET_P_SOLD.GSM_NUM_BUYER,
		ASSET_P_SOLD.ADRESS_BUYER,
		ASSET_P_SOLD.TAX_NUM,
		ASSET_P_SOLD.MIN_PRICE,
		ASSET_P_SOLD.MAX_PRICE,
		ASSET_P_SOLD.MAX_MONEY,
		ASSET_P_SOLD.MIN_MONEY,
		ASSET_P_SOLD.DESCRIPTION,
		ASSET_P_SOLD.DRIVING_LICENCE,
		ASSET_P_SOLD.RECORD_DATE,
		ASSET_P_SOLD.TRANSFER_DATE,
		ASSET_P_SOLD.IS_PAID,
		ASSET_P_SOLD.IS_TRANSFERED,
		ASSET_P_SOLD.REQUEST_ID,
		ASSET_P_SOLD.REQUEST_ROW_ID,
		ASSET_P_SOLD.SALE_CURRENCY,
		ASSET_P_SOLD.SALE_CURRENCY_MONEY		
	FROM 
		ASSET_P_SOLD,
		ASSET_P
	WHERE
		ASSET_P_SOLD.ASSETP_ID = ASSET_P.ASSETP_ID 
		AND ASSET_P_SOLD.ASSET_P_SOLD_ID = #attributes.sold_id#
</cfquery>
<cf_box title="#getLang(951,'Araç Satış Güncelle',48170)#">
<cfform name="upd_stuff" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_upd_sales_purchase_stuff" onsubmit="return(unformat_fields());">                      

	<input type="hidden" name="sold_id" id="sold_id" value="<cfoutput>#attributes.sold_id#</cfoutput>">
	<cf_box_elements>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12" id="upload_status">

				<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
					<div class="form-group">
						<label class="col col-4 col-xs-12">
							<cf_get_lang dictionary_id='51100.Talep'>/<cf_get_lang dictionary_id='55657.Sıra No'>
							</label>
						<div class="col col-8 col-xs-12">
			
							<div class="col col-6">
								<input type="text" name="request_id" id="request_id" value="<cfoutput>#get_sold_stuff.request_id#</cfoutput>" readonly>

							</div>
							<div class="col col-6">
								<input type="text" name="request_row_id" id="request_row_id" value="<cfoutput>#get_sold_stuff.request_row_id#</cfoutput>" readonly >

							</div>     
						</div>
					</div>

					<div class="form-group" id="branch_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58480.Araç'> *</label>
						<div class="col col-8 col-xs-12 ">
							
								<input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#get_sold_stuff.assetp_id#</cfoutput>"> 
								<input type="text" name="asset_name" id="asset_name" value="<cfoutput>#get_sold_stuff.assetp#</cfoutput>" readonly style="width:198px;"> 
							
						</div>
					</div>

					<div class="form-group" id="branch_id">
						<label class="col col-4 col-xs-12">
							<cf_get_lang dictionary_id='48168.Min Fiyat'> *
						</label>
						<div class="col col-8 col-xs-12">
			
							<div class="col col-8">
							<input type="text" name="min_price" id="min_price" value="<cfoutput>#tlformat(get_sold_stuff.min_price)#</cfoutput>" class="moneybox" readonly style="width:125px;"> 
							</div>
							<div class="col col-4">
								<select name="min_currency" id="min_currency" readonly style="width:70px;">
									<cfoutput query="get_money"> 
										<option value="#money#" <cfif get_sold_stuff.min_money eq money>selected</cfif>>#money#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>

					<div class="form-group" >
						<label class="col col-4 col-xs-12">
							<cf_get_lang dictionary_id='48169.Max Fiyat'>*
						</label>
						<div class="col col-8 col-xs-12">
		
							<div class="col col-8">
								<input type="text" name="max_price" id="max_price" value="<cfoutput>#tlformat(get_sold_stuff.max_price)#</cfoutput>" class="moneybox" readonly style="width:125px;"> 
								</div>
							<div class="col col-4">
								<select name="max_currency" id="max_currency" readonly style="width:70px;">
									<cfoutput query="get_money"> 
										<option value="#money#" <cfif get_sold_stuff.max_money eq money>selected</cfif>>#money#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>

					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='1321.Alıcı'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message2"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1321.Alıcı'> <cf_get_lang_main no='485.adı'>!</cfsavecontent> 
								<input type="hidden" name="position_code" id="position_code" value="<cfoutput>#get_sold_stuff.company_id_buyer#</cfoutput>"> 
								<cfinput type="text" name="position_name" value="#get_sold_stuff.name_buyer#" onChange="remove();" maxlength="150" style="width:200px;">  
								<span class="input-group-addon icon-ellipsis"onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=upd_stuff.position_code&field_comp_name=upd_stuff.position_name&select_list=2</cfoutput>','list')"></span><cfsavecontent variable="message6"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='672.Fiyat'>!</cfsavecontent>
							</div>
						</div>
					</div>
					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang no='305.Telefon No'></label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message4"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='306.Alan kodu'>!</cfsavecontent>
								<cfsavecontent variable="message5"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='305.telefon no'>!</cfsavecontent> 
						
								<div class="col col-4">
									<cfinput type="text" name="tel_num1" style="width:45px;" maxlength="3" required="no" message="#message4#" validate="integer" value="#get_sold_stuff.tel_area_code#">
								</div>
								<div class="col col-8">
									<cfinput type="text" name="tel_num2" style="width:152px;" maxlength="7" required="no" message="#message5#" validate="integer"  value="#get_sold_stuff.tel_num_buyer#">
								</div>
							</div>
					</div>
					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang no='308.GSM No'></label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message10"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='306.Alan kodu'>!</cfsavecontent>
								<cfsavecontent variable="message11"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='305.telefon no'>!</cfsavecontent> 
						
								<div class="col col-4">
									<cfinput type="text" name="gsm_num1" maxlength="3" required="no" message="#message10#" validate="integer" value="#get_sold_stuff.gsm_code#" style="width:45px;"> 
								</div>
								<div class="col col-8">
									<cfinput type="text" name="gsm_num2" maxlength="7" required="no" message="#message11#" validate="integer" value="#get_sold_stuff.gsm_num_buyer#" style="width:152px;">
								</div>
							</div>
					</div>
					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='1311.Adres'></label>
							<div class="col col-8 col-xs-12">
								<textarea name="adress_buyer" id="adress_buyer" style="width:200px;height:30px"><cfoutput>#get_sold_stuff.adress_buyer#</cfoutput></textarea>
							</div>
					</div>


					</div>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='340.Vergi No'></label>
							<div class="col col-8 col-xs-12"> 
								<cfsavecontent variable="message15"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='340.Vergi No'>!</cfsavecontent>
									<cfinput type="text" name="tax_num" value="#get_sold_stuff.tax_num#" maxlength="50" message="#message15#" style="width:200px;">
						
							</div>
						</div>     
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang no='311.Ehliyet No'></label>
							<div class="col col-8 col-xs-12"> 
								<cfinput type="text" name="driving_licence" value="#get_sold_stuff.driving_licence#" maxlength="10" style="width:200px;">
							</div>
						</div>   
						<div class="form-group" >
							<label class="col col-4 col-xs-12">
								<cf_get_lang no='312.Satış Fiyatı'> *
							</label>
							<div class="col col-8 col-xs-12">
			
								<div class="col col-6">
									<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='312.Satış Fiyatı'>!</cfsavecontent>
									<cfinput type="text" name="sale_currency" value="#tlformat(get_sold_stuff.sale_currency)#" required="yes" message="#message#" class="moneybox" onKeyup="return(FormatCurrency(this,event));" style="width:127px;"> 
										
								</div>
								<div class="col col-6">
									<select name="sale_currency_money" id="sale_currency_money" style="width:70px;">
										<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
										<cfoutput query="get_money"> 
											<option value="#money#" <cfif get_sold_stuff.sale_currency_money eq money>selected</cfif>>#money#</option>
										</cfoutput>
									</select>
								</div>
							</div>
						</div>  
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
							<div class="col col-8 col-xs-12">
								<textarea name="detail" id="detail" style="width:200px;height:30px"><cfoutput>#get_sold_stuff.description#</cfoutput></textarea>

							</div>
						</div> 
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang no='313.Devir Tarihi'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='313.Devir Tarihi'>!</cfsavecontent>
										<cfif get_sold_stuff.is_transfered>
											<cfinput type="text" name="transfer_date" value="#dateformat(get_sold_stuff.transfer_date,dateformat_style)#" readonly maxlength="10" validate="#validate_style#" message="#message#" style="width:200px">
										<cfelse>					 
											<cfinput type="text" name="transfer_date" value="#dateformat(get_sold_stuff.transfer_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" style="width:200px">
											<span class="input-group-addon"><cf_wrk_date_image date_field="transfer_date"></span>
										</cfif>
								</div>
							</div>
						</div>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='344.Durumu'> *</label>
							<div class="col col-8 col-xs-12">
									<cf_wrk_combo
										name="assetp_status"
										query_name="GET_ASSET_STATE"
										option_name="asset_state"
										option_value="asset_state_id"
										value="#get_sold_stuff.assetp_status#"
										width=200>
							</div>
						</div>
						<div class="form-group" >
							<div class="col col-12 col-xs-12">
								<div class="input-group">
									<cf_get_lang no='315.Devri Yapıldı'>&nbsp;<input type="checkbox" name="is_transfered" id="is_transfered" value="checkbox" <cfif get_sold_stuff.is_transfered>checked disabled</cfif>> 
										<cf_get_lang no='316.Ödemesi Alındı'>&nbsp;<input type="checkbox" name="is_paid" id="is_paid" value="checkbox" <cfif get_sold_stuff.is_paid eq 1>checked</cfif>>
									
							</div>
						</div>
				</div>
		</div>

	</cf_box_elements>

		<cf_box_footer>
			<cf_workcube_buttons type_format="1" is_upd='1' add_function='kontrol()' is_delete='0'>

		</cf_box_footer>


</cfform>
</cf_box>
<script type="text/javascript">
	function unformat_fields()
	{
		upd_stuff.sale_currency.value = filterNum(upd_stuff.sale_currency.value);
	}
	function kontrol()
	{
		x = document.upd_stuff.sale_currency_money.selectedIndex;
		if(document.upd_stuff.sale_currency_money[x].value == "")
		{ 
			alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='77.Para Birimi'>!");
			return false;
		}
		if(document.upd_stuff.is_transfered.checked)
		{
			if(document.upd_stuff.transfer_date.value == "")
			{
				alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='313.Devir Tarihi'>!");
				return false;
			}
		}
		a = filterNum(document.upd_stuff.min_price.value);
		b = filterNum(document.upd_stuff.max_price.value);
		c = filterNum(document.upd_stuff.sale_currency.value);
		if ((a>c) || (b<c))
		{
			alert ("<cf_get_lang no='312.Satış Fiyatı'><cf_get_lang no='676. Kontrol Ediniz'>!");
			return false;
		}
		x = document.upd_stuff.assetp_status.selectedIndex;
		if(document.upd_stuff.assetp_status[x].value == "")
		{ 
			alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='363.Araç Durumu'>!");
			return false;
		}
		y= (50 - document.upd_stuff.detail.value.length);
		if(y < 0)
		{ 
			alert ((y * (-1)) + "<cf_get_lang_main no='1741.Karakter Uzun'>!");
			return false;
		}	
		
		return true;
	}
	function remove() 
	{
		document.upd_stuff.position_code.value = "" ;
	}
</script>
