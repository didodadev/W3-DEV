
<cfinclude template="../query/get_money.cfm">
<cfinclude template="../../assetcare/form/vehicle_detail_top.cfm">
<cfquery name="GET_ASSETP" datasource="#DSN#">
	SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = #attributes.assetp_id#
</cfquery>
<cfquery name="GET_RENT_CONTRACT" datasource="#dsn#">
	SELECT 
		COMPANY.COMPANY_ID,
		ASSET_CARE_CONTRACT.*,
		COMPANY.FULLNAME 
	FROM 
		ASSET_CARE_CONTRACT,
		COMPANY
	WHERE 
		ASSET_CARE_CONTRACT.IS_RENT=1 AND <!--- kira sarti --->
		ASSET_CARE_CONTRACT.ASSET_ID = #attributes.assetp_id#
		AND ASSET_CARE_CONTRACT.SUPPORT_COMPANY_ID = COMPANY.COMPANY_ID
</cfquery>
<cfset pageHead="#getLang('assetcare',188)# : #getLang('main',1656)# : #get_assetp.assetp# ">
<cf_catalystHeader>
<div class="row">
	<div class="col col-12 uniqueRow">
		<cfsetting showdebugoutput="no">
		<cfform name="rent_contract" action="#request.self#?fuseaction=assetcare.emptypopup_upd_vehicle_rent_contract" method="post" enctype="multipart/form-data" onsubmit="return(unformat_fields());">
			<input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#attributes.assetp_id#</cfoutput>">
			<div class="row formContent">
				<div class="row" type="row">
					<div class="col col-4 col-xs-12" type="column" index="1" sort="true">

						<div class="form-group" id="item-contract_head">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='68.Başlık'></label>
								<div class="col col-6 col-xs-12">
									<cfif len(get_rent_contract.contract_head)>
										<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1408.Başlık'></cfsavecontent>
										<cfinput type="text" name="contract_head" value="#get_rent_contract.contract_head#" maxlength="100" required="yes" message="#message#">
									<cfelse>
										<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1408.Başlık'></cfsavecontent>
										<cfinput type="text" name="contract_head" value="" maxlength="100" required="yes" message="#message#">
									</cfif>	
								</div>
						</div>

						<div class="form-group" id="item-asset_name">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='1068.Araç'></label>
								<div class="col col-6 col-xs-12">
									<cfinput type="text" name="asset_name" value="#get_assetp.assetp#" readonly>
								</div>
						</div>

						<div class="form-group" id="item-company_id">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='162.Şirket'></label>
								<div class="col col-6 col-xs-12">
									<div class="input-group">
										<cfif len(get_rent_contract.support_company_id)>
												<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_rent_contract.support_company_id#</cfoutput>">
												<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='162.şirket!'></cfsavecontent>
												<cfinput type="text" name="support_company_id" value="#get_rent_contract.fullname#" readonly required="yes" message="#message#" >
												<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_id=rent_contract.authorized_id&field_comp_name=rent_contract.support_company_id&field_name=rent_contract.support_authorized_id&field_comp_id=rent_contract.company_id&select_list=2,3,5,6','list');"></span>
										<cfelse>
											<input type="hidden" name="company_id" id="company_id" value="">
											<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='162.şirket!'></cfsavecontent>
											<cfinput type="text" name="support_company_id" value="" required="yes" message="#message#"  readonly>
											<span  class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_id=rent_contract.authorized_id&field_comp_name=rent_contract.support_company_id&field_name=rent_contract.support_authorized_id&field_comp_id=rent_contract.company_id&select_list=2,3,5,6','list');"></span>			
										</cfif>
									</div>
								</div>
						</div>

						<div class="form-group" id="item-authorized_id">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='166.Yetkili'></label>
								<div class="col col-6 col-xs-12">
									<cfif len(get_rent_contract.support_authorized_id)>
										<input type="hidden" name="authorized_id" id="authorized_id" value="<cfoutput>#get_rent_contract.support_authorized_id#</cfoutput>">
										<input type="text" name="support_authorized_id" id="support_authorized_id" value="<cfoutput>#get_par_info(get_rent_contract.support_authorized_id,0,-1,0)#</cfoutput>" readonly >
									<cfelse>
										<input type="hidden" name="authorized_id" id="authorized_id" value="">
										<input type="text" name="support_authorized_id" id="support_authorized_id" value="" readonly >			
									</cfif>
								</div>
						</div>

						<div class="form-group" id="item-support_position_id">
								<label class="col col-4 col-xs-12"><cf_get_lang no='244.Sorumlu Çalışan'></label>
								<div class="col col-6 col-xs-12">
									<div class="input-group">
										<cfif len(get_rent_contract.support_employee_id)>
											<input type="hidden" name="support_position_id" id="support_position_id" value="<cfoutput>#get_rent_contract.support_employee_id#</cfoutput>">
											<input type="text" name="support_position_name" id="support_position_name" value="<cfoutput>#get_emp_info(get_rent_contract.support_employee_id,1,0)#</cfoutput>"  readonly>
											<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=rent_contract.support_position_id&field_name=rent_contract.support_position_name&select_list=1','list');"></span>
										<cfelse>
											<input type="hidden" name="support_position_id" id="support_position_id" value="">
											<input type="text" name="support_position_name" id="support_position_name" value="" readonly>
											<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=rent_contract.support_position_id&field_name=rent_contract.support_position_name&select_list=1','list');"></span>				
										</cfif>
									</div>
								</div>
						</div>

						<div class="form-group" id="item-support_start_date">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='243.Başlangıç Tarihi'></label>
								<div class="col col-6 col-xs-12">
									<div class="input-group">
										<cfif len(get_rent_contract.support_start_date)>
											<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='641.Başlangıç Tarihi !'></cfsavecontent>
											<cfinput type="text" name="support_start_date" validate="#validate_style#" maxlength="10" message="#message#" value="#dateformat(get_rent_contract.support_start_date,dateformat_style)#" >
											<span class="input-group-addon"><cf_wrk_date_image date_field="support_start_date"></span>
										<cfelse>
											<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='641.Başlangıç Tarihi !'></cfsavecontent>
											<cfinput type="text" name="support_start_date" validate="#validate_style#" maxlength="10" message="#message#" value="">
											<span class="input-group-addon"><cf_wrk_date_image date_field="support_start_date"></span>	
										</cfif>
									</div>
								</div>
						</div>

						<div class="form-group" id="item-support_finish_date">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='288.Bitiş Tarihi'></label>
								<div class="col col-6 col-xs-12">
									<div class="input-group">
										<cfif len(get_rent_contract.support_finish_date)>
											<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='288.Bitiş Tarihi !'></cfsavecontent>
											<cfinput type="text" name="support_finish_date" validate="#validate_style#" maxlength="10" message="#message#" value="#dateformat(get_rent_contract.support_finish_date,dateformat_style)#">
											<span class="input-group-addon"><cf_wrk_date_image date_field="support_finish_date"></span>				
										<cfelse>
											<cfsavecontent variable="message"><cf_get_lang_main no='327.Bitiş Tarihi Girmelisiniz'> !</cfsavecontent>
											<cfinput type="text" name="support_finish_date" value="" validate="#validate_style#" maxlength="10" message="#message#">
											<span class="input-group-addon"><cf_wrk_date_image date_field="support_finish_date"></span>						
										</cfif>
									</div>
								</div>
						</div>

						<div class="form-group" id="item-project_id">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='4.Proje'></label>
								<div class="col col-6 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('get_rent_contract.project_id') and len(get_rent_contract.project_id)><cfoutput>#get_rent_contract.project_id#</cfoutput></cfif>">
										<input type="text" name="project_head" id="project_head" value="<cfif isdefined('get_rent_contract.project_id') and len(get_rent_contract.project_id)><cfoutput>#get_project_name(get_rent_contract.project_id)#</cfoutput></cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','time_cost','3','250');" autocomplete="off">
										<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=rent_contract.project_head&project_id=rent_contract.project_id</cfoutput>');"></span>
									</div>
								</div>
						</div>

						<div class="form-group" id="item-add-document">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='54.Belge Ekle'></label>
							<div class="col col-6 col-xs-12">
								<cfif len(get_rent_contract.use_certificate)>
									<cf_get_server_file output_file="assetcare/#get_rent_contract.use_certificate#" output_server="#get_rent_contract.use_certificate_server_id#" output_type="2" small_image="images/asset.gif" image_link="1"><cfelse>
								</cfif>
							</div>
						</div>

						<div class="form-group" id="item-support_cat">
							<label class="col col-4 col-xs-12"><cf_get_lang no='779.Destek'>:<cf_get_lang_main no='74.Kategori'></label>
							<div class="col col-6 col-xs-12">
								<cf_wrk_combo
										name="support_cat"
										query_name="GET_ASSET_TAKE_SUPPORT_CAT"
										option_name="TAKE_SUP_CAT"
										option_value="TAKE_SUP_CATID"
										value="#get_rent_contract.support_cat_id#"
										width="150">
							</div>
						</div>

						<div class="form-group" id="item-detail">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
							<div class="col col-6 col-xs-12">
								<cfif len(get_rent_contract.detail)>
									<textarea  name="detail" id="detail"><cfoutput>#get_rent_contract.detail#</cfoutput></textarea>
								<cfelse>
									<textarea  name="detail" id="detail"></textarea>
								</cfif>
							</div>
						</div>

						<div class="form-group" id="item-header2">
							<label class="col col-4 col-xs-12 bold"><cf_get_lang no='332.Kira Bilgileri'></label>
						</div>

						<div class="form-group" id="item-rent_amount">
							<label class="col col-4 col-xs-12"><cf_get_lang no='333.Kira Tutarı'>(<cf_get_lang no='785.KDV Hariç'>)</label>
							<div class="col col-6 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="rent_amount" value="#tlformat(get_rent_contract.rent_amount)#" onKeyup="return(FormatCurrency(this,event));" class="moneybox"> 
									<span class="input-group-addon"><select name="rent_amount_currency" id="rent_amount_currency">
										<cfoutput query="get_money"> 
										<option value="#money#" <cfif money eq get_rent_contract.rent_amount_currency>selected</cfif>>#money#</option>
										</cfoutput>
									</select></span>
								</div>
							</div>
						</div>

						<div class="form-group" id="item-rent_payment_period">
							<label class="col col-4 col-xs-12"><cf_get_lang no='334.Ödeme Periyodu'></label>
							<div class="col col-6 col-xs-12">
								<select name="rent_payment_period" id="rent_payment_period">
									<option value=""></option>
									<option value="1" <cfif get_rent_contract.rent_payment_period eq 1>selected</cfif>><cf_get_lang_main no='1046.Haftalık'></option>
									<option value="2" <cfif get_rent_contract.rent_payment_period eq 2>selected</cfif>><cf_get_lang_main no='1520.Aylık'></option>
									<option value="3" <cfif get_rent_contract.rent_payment_period eq 3>selected</cfif>>3 <cf_get_lang_main no='1520.Aylık'></option>
									<option value="4" <cfif get_rent_contract.rent_payment_period eq 4>selected</cfif>><cf_get_lang_main no='1603.Yıllık'></option>
								</select>
							</div>
						</div>

						<div class="form-group" id="item-rent_payment_period">
							<label class="col col-4 col-xs-12 bold"><cf_get_lang no='339.Masraf Bilgileri'></label>
						</div>

						<div class="form-group" id="item-is_fuel_added">
							<label class="col col-4 col-xs-12"><cf_get_lang no='345.Yakıt Masrafı'></label>
							<div class="col col-2 col-xs-12">
								<input name="is_fuel_added" id="is_fuel_added" type="radio" value="0" <cfif get_rent_contract.fuel_expense eq 0>checked</cfif> onClick="show_hide(fuel);"><cf_get_lang no='342.Hariç'>
							</div>
							<div class="col col-3 col-xs-12">
								<input name="is_fuel_added" id="is_fuel_added" type="radio" value="2" <cfif get_rent_contract.fuel_expense eq 2>checked</cfif> onClick="show_hide(fuel);"><cf_get_lang no='536.Limitsiz'>
							</div>
							<div class="col col-2 col-xs-12">
								<input name="is_fuel_added" id="is_fuel_added" type="radio" value="1" <cfif get_rent_contract.fuel_expense eq 1>checked</cfif> onClick="show_hide(fuel);"><cf_get_lang no='343.Dahil'>
							</div>
						</div>

						<div class="form-group" id="fuel" style="display:none;">
							<label class="col col-4 col-xs-12"><cf_get_lang no='341.Üst Limit'></label>
							<div class="col col-6 col-xs-12">
								<div class="input-group">
									<input type="text" name="fuel_amount" id="fuel_amount" value="<cfoutput>#tlformat(get_rent_contract.fuel_amount)#</cfoutput>"  onKeyUP="FormatCurrency(this,event);" class="moneybox"> 
									<span class="input-group-addon"><select name="fuel_amount_currency" id="fuel_amount_currency">
										<option value=""></option>
										<cfoutput query="get_money"> 
											<option value="#money#"<cfif money eq get_rent_contract.fuel_amount_currency>selected</cfif>>#money#</option>
										</cfoutput>
									</select></span>
								</div>
							</div>
						</div>

						<div class="form-group" id="item-is_care_added">
							<label class="col col-4 col-xs-12"><cf_get_lang no='344.Bakım Masrafı'></label>
							<div class="col col-2 col-xs-12">
								<input name="is_care_added" id="is_care_added" type="radio" value="0" <cfif get_rent_contract.care_expense eq 0>checked</cfif> onClick="show_hide(care);"><cf_get_lang no='342.Hariç'>
							</div>
							<div class="col col-3 col-xs-12">
								<input name="is_care_added" id="is_care_added" type="radio" value="2" <cfif get_rent_contract.care_expense eq 2>checked</cfif> onClick="show_hide(care);" ><cf_get_lang no='536.Limitsiz'>
							</div>
							<div class="col col-2 col-xs-12">
									<input name="is_care_added" id="is_care_added" type="radio" value="1" <cfif get_rent_contract.care_expense eq 1>checked</cfif> onClick="show_hide(care);"><cf_get_lang no='343.Dahil'>
							</div>
						</div>

						<div class="form-group" id="care" style="display:none;">
							<label class="col col-4 col-xs-12"><cf_get_lang no='341.Üst Limit'></label>
							<div class="col col-6 col-xs-12">
								<div class="input-group">
									<input type="text" name="care_amount" id="care_amount" value="<cfoutput>#tlformat(get_rent_contract.care_amount)#</cfoutput>"onKeyUp="FormatCurrency(this,event);" class="moneybox"> 
									<span class="input-group-addon"><select name="care_amount_currency" id="care_amount_currency">
										<option value=""></option>
										<cfoutput query="get_money"> 
											<option value="#money#" <cfif money eq get_rent_contract.care_amount_currency>selected</cfif>>#money#</option>
										</cfoutput>
									</select></span>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<cf_form_box_footer>
				<cf_record_info query_name="GET_RENT_CONTRACT">
				<cf_workcube_buttons is_upd='1' is_cancel='0' is_reset='0' is_delete='0' add_function='kontrol()'></td>
			</cf_form_box_footer>
		</cfform> 
	</div>
</div>
		
 
<script type="text/javascript">
	window.onload = function () { show_hide(fuel); } 
	function unformat_fields()
	{
		document.rent_contract.fuel_amount.value = filterNum(document.rent_contract.fuel_amount.value);
		document.rent_contract.care_amount.value = filterNum(document.rent_contract.care_amount.value);
		document.rent_contract.rent_amount.value = filterNum(document.rent_contract.rent_amount.value);
	}
	
	function kontrol()
	{
		x = (200 - rent_contract.detail.value.length);
		if ( x < 0 )
	{ 
		alert ("<cf_get_lang_main no='217.Açıklama'> "+ ((-1) * x) +"<cf_get_lang_main no='1741.Karakter Uzun'>");
		return false;
	}
	
		return date_check(rent_contract.support_start_date,rent_contract.support_finish_date,"<cf_get_lang no='52.Başlangıç Tarihi Bitiş Tarihinden Önce Olmalıdır'>!");
	}
	function show_hide()
	{
		if(document.rent_contract.is_care_added[0].checked)
		{
			gizle(care);
			document.rent_contract.care_amount.value = "" ;				
			document.rent_contract.care_amount_currency.selectedIndex = "";		
		}
		
		if(document.rent_contract.is_care_added[1].checked)
		{
			gizle(care);
			document.rent_contract.care_amount.value = "" ;				
			document.rent_contract.care_amount_currency.selectedIndex = "";		
		}
		
		if(document.rent_contract.is_care_added[2].checked)
		{
			goster(care);
		}
		
		if(document.rent_contract.is_fuel_added[0].checked)
		{
			gizle(fuel);
			document.rent_contract.fuel_amount.value = "" ;
			document.rent_contract.fuel_amount_currency.selectedIndex = "";			
		}
		
		if(document.rent_contract.is_fuel_added[1].checked)
		{
			gizle(fuel);
			document.rent_contract.fuel_amount.value = "" ;
			document.rent_contract.fuel_amount_currency.selectedIndex = "";			
		}
		if(document.rent_contract.is_fuel_added[2].checked)
			goster(fuel);			
		
		if(document.rent_contract.is_care_added[2].checked || document.rent_contract.is_fuel_added[2].checked)
			goster(limit);
		else
			gizle(limit);
	}
	
	function kontrol_detail()
	{
		if(document.rent_contract.detail.value.length>200)
		{
			alert("<cf_get_lang no='778.Açıklama alanına en fazla 200 karakter girebilirsiniz'>!");
			return false;
		}
		return true;
	}
</script>

