<!---BU SAYFA HEM POPUP HEM BASKET OLARAK ÇAĞRILDIĞI İÇİN BASKETE GÖRE DÜZENLENMİŞTİR.--->
<cfsetting showdebugoutput="no">
<cfparam name="attributes.modal_id" default="">
<cf_box uidrop="1"  title="#getlang('','Akaryakıt Şifre Kayıt',48340)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfform name="add_fuel_password" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_add_fuel_password">
	<input type="hidden" name="is_detail" id="is_detail" value="0">
	<cf_box_elements>
		<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">

			<div class="form-group" >
				<label class="col col-4 col-xs-12">
					<cf_get_lang dictionary_id='57482.Asama'>
				</label>
				<div class="col col-8 col-xs-12">
					<input type="checkbox" name="status" id="status" checked>
					<cf_get_lang dictionary_id='57493.Aktif'>
				</div>
			</div>

			<div class="form-group" id="branch_id">
				<label class="col col-4 col-xs-12">
					<cf_get_lang dictionary_id='57453.Şube'> *
				</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="branch_id" id="branch_id" value=""> 
							<input type="text" name="branch" id="branch" value=""  readonly> 
							<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_id=add_fuel_password.branch_id&field_branch_name=add_fuel_password.branch');"> 
						</div>
					</div>
			</div>
			<div class="form-group" id="branch_id">
				<label class="col col-4 col-xs-12">
					<cf_get_lang dictionary_id='48341.Akaryakıt Şirketi'> *
				</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="company_id" id="company_id"> 
							<input type="text" name="company_name" id="company_name" value="" readonly > 
							<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=add_fuel_password.company_name&field_comp_id=add_fuel_password.company_id&is_buyer_seller=1&select_list=2,3');"></span>
						
						</div>
					</div>
			</div>

		</div>
		<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
			<div class="form-group" >
				<label class="col col-4 col-xs-12">
					<cf_get_lang dictionary_id='58522.Kullanıcı Kodu'>
				</label>
				<div class="col col-8 col-xs-12">
					<input type="text" name="user_code" id="user_code" value="" maxlength="20">
				</div>
			</div>

			<div class="form-group" >
				<label class="col col-4 col-xs-12">
					<cf_get_lang dictionary_id='57552.Şifre '>1 *
				</label>
				<div class="col col-8 col-xs-12">
					<input type="text" name="password1" id="password1" value="" maxlength="20">
				</div>
			</div>
			<div class="form-group" >
				<label class="col col-4 col-xs-12">
					<cf_get_lang dictionary_id='57552.Şifre '>2 
				</label>
				<div class="col col-8 col-xs-12">
					<input type="text" name="password2" id="password2" value="" maxlength="20">
				</div>
			</div>
			
		</div>
		<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="3" sort="true">
			<div class="form-group" >
				<label class="col col-4 col-xs-12">
					<cf_get_lang dictionary_id='57655.Başlama Tarihi'>
				</label>
				<div class="col col-8 col-xs-12">
					<div class="input-group">
						<cfsavecontent variable="alert"><cf_get_lang dictionary_id='57471.eksik veri'>:<cf_get_lang dictionary_id ='30448.Üyelik Başlama Tarihi'></cfsavecontent>
						<input name="start_date" id="start_date" type="text" value="" maxlength="10" message="#alert#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
						</span>
					</div>
				</div>
			</div>

			<div class="form-group" >
				<label class="col col-4 col-xs-12">
					<cf_get_lang dictionary_id='57700.Bitiş Tarihi'>
				</label>
				<div class="col col-8 col-xs-12">
					<div class="input-group">
						<input name="finish_date" id="finish_date" type="text" value="" maxlength="10"> 
					<span class="input-group-addon btnPointer">
						<cf_wrk_date_image date_field="finish_date" >
					</span>
				</div>
				</div>
			</div>
		</div>
	</cf_box_elements>
	<cf_box_footer>
		<cf_workcube_buttons is_add='1' is_reset='1' is_cancel='0' add_function='kontrol()' search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_fuel_password' , #attributes.modal_id#)"),DE(""))#">
	</cf_box_footer>
</cfform>
</cf_box>
<script type="text/javascript">
	function kontrol()
	{
		if(document.add_fuel_password.branch.value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1735.Şube Adı'>!");
			return false;
		}
		
		if(document.add_fuel_password.company_name.value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='48341.Akaryakıt Şirketi'>!");
			return false;
		}
		
		if(document.add_fuel_password.user_code.value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1110.Kullanıcı Kodu'>!");
			return false;
		}
		
		if(document.add_fuel_password.password1.value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='140.Şifre'>!");
			return false;
		}
		
		if(!CheckEurodate(document.add_fuel_password.start_date.value,"<cf_get_lang_main no='641.Başlangıç Tarihi'>"))
		{
			return false;
		}
		
		if(!CheckEurodate(document.add_fuel_password.finish_date.value,"<cf_get_lang_main no='288.Bitiş Tarihi'>"))
		{
			return false;
		}
		
		if((document.add_fuel_password.start_date.value != "") && (document.add_fuel_password.finish_date.value != ""))
		{
			if(!date_check(document.add_fuel_password.start_date,document.add_fuel_password.finish_date,"<cf_get_lang_main no='394.Tarih Aralığını Kontrol Ediniz'>!"))
			{
				return false;
			}
		}
	}
</script>
