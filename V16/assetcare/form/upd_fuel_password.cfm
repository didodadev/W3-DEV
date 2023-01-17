<cfinclude template="../query/get_fuel_password.cfm">
<cfparam name="attributes.modal_id" default="">
	<cf_box title="#getLang('','Akaryakıt Şifreleri','47056')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="upd_fuel_password" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_upd_fuel_password">
			<input type="hidden" name="password_id" id="password_id" value="<cfoutput>#attributes.password_id#</cfoutput>">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12" >
					<div class="form-group" >
						<label class="col col-4 col-xs-12">
							<cf_get_lang dictionary_id='57493.Aktif'>
						</label>
						<div class="col col-8 col-xs-12">

							<input name="status" id="status" type="checkbox" <cfif data_assetcare_fuel_password.status eq 1>checked="true"</cfif> value="<cfoutput>#data_assetcare_fuel_password.status#</cfoutput>">
						</div>
					</div>
					<div class="form-group" >
						<label class="col col-4 col-xs-12">
							<cf_get_lang_main no='41.Şube'> *
						</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#get_fuel_password.branch_id#</cfoutput>"> 
								<input type="text" name="branch" id="branch" value="<cfoutput>#get_fuel_password.branch_name#</cfoutput>"   readonly> 
								<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_id=upd_fuel_password.branch_id&field_branch_name=upd_fuel_password.branch','list','popup_list_branches');"> 
								
							</div>
						</div>
					</div>
					<div class="form-group" >
						<label class="col col-4 col-xs-12">
							<cf_get_lang no='470.Akaryakıt Şirketi'> *
						</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_fuel_password.company_id#</cfoutput>"> 
								<input type="text" name="company_name" id="company_name" value="<cfoutput>#get_fuel_password.fullname#</cfoutput>" readonly style="width:150px"> 
								<span class="input-group-addon icon-ellipsis"  onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=upd_fuel_password.company_name&field_comp_id=upd_fuel_password.company_id&is_buyer_seller=1&select_list=2,3','list','popup_list_pars');"></a>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12" >
					<div class="form-group" >
						<label class="col col-4 col-xs-12">
							<cf_get_lang_main no='1110.Kullanıcı Kodu'>
						</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="user_code" id="user_code" value="<cfoutput>#get_fuel_password.user_code#</cfoutput>" maxlength="20"   readonly>
						</div>
					</div>
					<div class="form-group" >
						<label class="col col-4 col-xs-12">
						<cf_get_lang_main no='140.Şifre'> 1
						</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="password1" id="password1" value="<cfoutput>#get_fuel_password.password1#</cfoutput>" maxlength="20"  >
						</div>
					</div>
					<div class="form-group" >
						<label class="col col-4 col-xs-12">
							<cf_get_lang_main no='140.Şifre'> 2
						</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="password2" id="password2" value="<cfoutput>#get_fuel_password.password2#</cfoutput>" maxlength="20"  >
						</div>
					</div>
					</div>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12" >
					<div class="form-group" >
						<label class="col col-4 col-xs-12">
							<cf_get_lang_main no='243.Başlama Tarihi'>
						</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input name="start_date" id="start_date" type="text" value="<cfoutput>#dateformat(get_fuel_password.start_date,dateformat_style)#</cfoutput>" maxlength="10"   > 
								<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
								</span>
							</div>
						</div>
					</div>
					<div class="form-group" >
						<label class="col col-4 col-xs-12">
							<cf_get_lang_main no='288.Bitiş Tarihi'>
						</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								
								<input name="finish_date" id="finish_date" type="text" value="<cfoutput>#dateformat(get_fuel_password.finish_date,dateformat_style)#</cfoutput>" maxlength="10"  > 
								<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date" ></span>
								</span>
							</div>
						</div>
					</div>
					<div class="form-group" >
						<label class="col col-4 col-xs-12">
							<cf_get_lang dictionary_id='54817.Kart No'>
						</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="text" name="card_no" id="card_no" value="<cfoutput>#data_assetcare_fuel_password.card_no#</cfoutput>" > 
							</div>
						</div>
					</div>
					</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_record_info query_name="get_fuel_password">
				<cf_workcube_buttons
					is_upd='1' 
					is_delete='0'
					is_cancel='0'
					add_function='kontrol()'
					is_reset='1'
					<!--- data_action='V16/assetcare/cfc/assetcare_fuel_password:UPD_FUEL_PASSWORD' --->
					next_page="#request.self#?fuseaction=assetcare.fuel_password&event=upd&password_id="
					search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('upd_fuel_password' , #attributes.modal_id#)"),DE(""))#">
				</cf_box_footer>
		</cfform>
	</cf_box>
<script type="text/javascript">
	function kontrol()
	{
		if(document.upd_fuel_password.password1.value == "")
		{
			alert("<cf_get_lang dictionary_id='63587.Girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57552.Şifre'>!");
			return false;
		}
		
		if(!CheckEurodate(document.upd_fuel_password.start_date2.value,'<cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>'))
		{
			return false;
		}
		
		if(!CheckEurodate(document.upd_fuel_password.finish_date2.value,'<cf_get_lang dictionary_id='57700.Bitiş Tarihi'>'))
		{
			return false;
		}
		
		if(!date_check(document.upd_fuel_password.start_date2,document.upd_fuel_password.finish_date2,"<cf_get_lang dictionary_id='57806.Tarih Aralığını Kontrol Ediniz'>!"))
		{
			return false;
		}
		return true;
	}
</script>


