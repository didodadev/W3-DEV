<cfinclude template="../query/get_money.cfm">
<cfinclude template="../query/get_fuel_type.cfm">
<cfquery name="get_document_type" datasource="#dsn#">
	SELECT
		SDT.DOCUMENT_TYPE_ID,
		SDT.DOCUMENT_TYPE_NAME
	FROM
		SETUP_DOCUMENT_TYPE SDT,
		SETUP_DOCUMENT_TYPE_ROW SDTR
	WHERE
		SDTR.DOCUMENT_TYPE_ID =  SDT.DOCUMENT_TYPE_ID AND
		SDTR.FUSEACTION LIKE '%#fuseaction#%'
	ORDER BY
		DOCUMENT_TYPE_NAME		
</cfquery>
<cfquery name="get_max_fuel" datasource="#dsn#">
	SELECT MAX(FUEL_ID) AS MAX_FUEL_ID FROM ASSET_P_FUEL
</cfquery>
<cfif len(get_max_fuel.max_fuel_id)>
	<cfset max_fuel_id = get_max_fuel.max_fuel_id+1>
<cfelse>
	<cfset max_fuel_id = 1>
</cfif>

<!--- POPUP YAKIT-KM Ekle --->
	<cf_box title="#getLang('','Yakıt-Km',48556)#">
	<cfform name="add_fuel_km" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_add_fuel_km" onsubmit="return(unformat_fields());">
		<cf_box_elements>
		
		<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="car_info">
						<label class="col"><span style="font-weight:bold;"><cf_get_lang dictionary_id='48559.Araç Bilgisi'></span></label>
					</div>
					
					<div class="form-group" id="branch_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41443.Plaka'>*</label>
						<div class="col col-8 col-xs-12 ">
							<div class="input-group">
								<input type="hidden" name="assetp_id" id="assetp_id" value="">
								<input name="assetp_name" id="assetp_name" type="text" readonly style="width:140px;">
								<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=add_fuel_km.assetp_id&field_name=add_fuel_km.assetp_name&field_emp_id=add_fuel_km.employee_id&field_emp_name=add_fuel_km.employee_name&field_dep_name=add_fuel_km.department&field_dep_id=add_fuel_km.department_id&field_pre_date=add_fuel_km.start_date&field_pre_km=add_fuel_km.pre_km&is_from_km_kontrol=1&fuel_type_id=add_fuel_km.fuel_type_id&is_active=1','list','popup_list_ship_vehicles');"></span>
							
							</div>
						</div>
					</div>
					<div class=" form-group" id="response">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'>*</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="employee_id" id="employee_id" value="">
								<input type="text" name="employee_name" id="employee_name" readonly value="" style="width:140px;">
								<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_fuel_km.employee_id&field_name=add_fuel_km.employee_name&field_pre_km=add_fuel_km.pre_km&field_pre_date=add_fuel_km.start_date&select_list=1&branch_related','list','popup_list_positions')"></span>
							</div>
						</div>
					</div>

					<div class="form-group" id="branch_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="department_id" id="department_id" value="">
								<input type="text" name="department" id="department" readonly style="width:140px;">
								<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_fuel_km.employee_id&field_name=add_fuel_km.employee_name&field_pre_km=add_fuel_km.pre_km&field_pre_date=add_fuel_km.start_date&select_list=1&branch_related','list','popup_list_positions')"></span>
							</div>
						</div>
					</div>
			</div>
		<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="Km_record">
						<label class="col fw-bold"><span style="font-weight:bold;"><cf_get_lang dictionary_id='47971.KM Kayıt'></span></label>
					</div>

			
					<div class=" form-group" id="km_exdate">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48227.Önceki KM Tarihi'></label>
						<div class="col col-8 col-xs-12 ">
							<div class="input-group">
								<input name="start_date" id="start_date" type="text" readonly style="width:140px;">
								<span class="input-group-addon" <i class="fa fa-calendar"><cf_wrk_date_image date_field="start_date"></i></span>

							</div>
						</div>
					</div>
							
					<div class=" form-group" id="exkm">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48228.Önceki KM'></label>
						<div class="col col-8 col-xs-12">
								<input name="pre_km" id="pre_km" type="text" value="" readonly style="width:140px;">
								<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_assetp.position_code&field_name=add_assetp.position</cfoutput>','list','popup_list_positions')"></a>
						</div>
					</div>
					<div class=" form-group" id="km_date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48230.Son KM Tarihi'>*</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input name="finish_date" id="finish_date" type="text" style="width:140px;" maxlength="10">
								<span class="input-group-addon" <i class="fa fa-calendar"><cf_wrk_date_image date_field="finish_date"></i></span>
								
							</div>
						</div>
					</div>
					<div class=" form-group" id="lastkm">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48090.Son KM '>*</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="last_km" id="last_km" style="width:140px;" onKeyup="return(FormatCurrency(this,event,0));">
						</div>
					</div>

					<div class=" form-group" id="descp">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
						<div class="col col-8 col-xs-12">
								<input type="text" name="detail" id="detail" style="width:140px" maxlength="200">
						</div>
					</div>
					<div class=" form-group" id="branch_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48229.Mesai Dışı'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
							<input name="is_offtime" id="is_offtime" type="checkbox" value="1">
							</div>
						</div>
					</div>
				</div>
		<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="fuel_record">
						<label class="col "><span style="font-weight:bold;"><cf_get_lang dictionary_id='48069.Yakıt Kayıt'></span></label>
					</div>
					<div class="form-group " id="doc">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'></label>
						
						<div class="col col-4 col-xs-8" style="padding-right:0.5rem;">
							<cfinput type="text" name="fuel_num" value="#max_fuel_id#" >
						</div>
						<div class="col col-4 col-xs-8">
							<cfinput type="text" name="document_num" >
						</div>
							
					</div>
					<div class="form-group" id="doc_type">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58533.Belge Tipi'>*</label>
						<div class="col col-8 col-xs-12">
							<select name="document_type_id" id="document_type_id" style="width:140px">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_document_type"> 
									<option value="#document_type_id#">#document_type_name#</option>
								</cfoutput>
							</select>
				
						</div>
					</div>

					<div class="form-group" id="fuel_comp">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30117.Yakıt Şirketi'>*</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input name="fuel_comp_id" id="fuel_comp_id" type="hidden" value="">
								<cfinput type="text" name="fuel_comp_name" readonly required="yes" message="Yakıt Şirketi Seçmelisiniz !" style="width:140px;"> 
								<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=add_fuel_km.fuel_comp_id&field_comp_name=add_fuel_km.fuel_comp_name&is_buyer_seller=1&select_list=2','list','popup_list_pars')"></span>
							
							</div>
						</div>
					</div>
					<div class="form-group" id="fuel_type">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30113.Yakıt Tipi'>*</label>
						<div class="col col-8 col-xs-12">
							<select name="fuel_type_id" id="fuel_type_id" style="width:140px">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_fuel_type"> 
									<option value="#fuel_id#">#fuel_name#</option>
								</cfoutput>
							</select>
				
						</div>
					</div>
					<div class="form-group" id="fuel_quantity">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48259.Yakıt Miktarı'> (Lt)*</label>
						<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message25"><cf_get_lang dictionary_id='63587.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='48259.Yakıt Miktarı'> !</cfsavecontent>
								<cfinput type="text" name="fuel_amount" style="width:140px;" required="yes" message="#message25#" onKeyup="return(FormatCurrency(this,event));">
						</div>
					</div>

					<div class="form-group" id="total_pay">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48114.KDV li Toplam Tutar'></label>
							<div class="col col-5" style="padding-right:0.5rem;" >
								<cfinput name="total_amount" type="text" class="moneybox" style="width:95px;" onKeyup="return(FormatCurrency(this,event));">
							</div>
							<div class="col col-3">
								<select name="total_currency" id="total_currency" style="width:43px;">
									<cfoutput query="get_money"> 
										<option value="#money#"<cfif money eq session.ep.money>selected</cfif>>#money#</option>
									</cfoutput>
								</select>
							</div>
						
					</div>
		</div>
		</cf_box_elements>

		<cf_box_footer>
		<cf_workcube_buttons type_format='1' is_upd='0' is_cancel='0' is_reset='1' add_function='kontrol()'>
		</cf_box_footer>

	</cfform>			
</cf_box>

<script type="text/javascript">	
	function unformat_fields()
	{
	  document.add_fuel_km.pre_km.value = filterNum(document.add_fuel_km.pre_km.value);
	  document.add_fuel_km.last_km.value = filterNum(document.add_fuel_km.last_km.value);
	  document.add_fuel_km.fuel_amount.value = filterNum(document.add_fuel_km.fuel_amount.value);
	  document.add_fuel_km.total_amount.value = filterNum(document.add_fuel_km.total_amount.value);
	}
		
	function kontrol()
	{
		if(document.add_fuel_km.assetp_name.value == "") 
		{
			alert("<cf_get_lang dictionary_id='63587.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='41443.Plaka'>!");
			return false;
		}
	
		if((document.add_fuel_km.employee_id.value.length == "") || (document.add_fuel_km.employee_id.value == 0))
		{
			alert("<cf_get_lang dictionary_id='48493.Lütfen Aracın Sorumlu Bilgisini Kontrol Ediniz'>!");
			return false;
		}
		
		if(document.add_fuel_km.department.value == "") 
		{
			alert("<cf_get_lang dictionary_id='63587.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='29532.Şube Adı'>!");
			return false;
		}
		
		if(document.add_fuel_km.finish_date.value == "") 
		{
			alert("<cf_get_lang dictionary_id='63587.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='48230.Son KM Tarihi'>!");
			return false;
		}
		
		if(!date_check(document.add_fuel_km.start_date,document.add_fuel_km.finish_date,"<cf_get_lang dictionary_id='57806.Tarih Aralığını Kontrol Ediniz'>!"))
		{	
			return false;
		}
		a = parseFloat(filterNum(document.add_fuel_km.pre_km.value));
		b = parseFloat(filterNum(document.add_fuel_km.last_km.value));
		if(a >= b)
		{
			alert("<cf_get_lang dictionary_id='48495.Km Aralığını Kontrol Ediniz'>!");
			return false;
		}
		if (!CheckEurodate(document.add_fuel_km.finish_date.value,"<cf_get_lang dictionary_id='57700.Bitiş Tarihi'>"))
		{
			return false;
		}
		if (document.add_fuel_km.fuel_type_id.value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='63587.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30113.Yakıt Tipi'> !");
			return false;
		}
		if (document.add_fuel_km.document_type_id.value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='63587.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58533.Belge Tipi'> !");
			return false;
		}
		return true;
	}
</script>

