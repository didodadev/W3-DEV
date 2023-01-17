<cfform action="#request.self#?fuseaction=objects.emptypopup_upd_employee&id=employee_user" method="post" name="employee_user_name">
<input type="hidden" name="position_id" id="position_id" value="<cfif isdefined('attributes.position_id') and len(attributes.position_id)><cfoutput>#attributes.position_id#</cfoutput></cfif>">
<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined('attributes.employee_id') and len(attributes.employee_id)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
<input type="hidden" name="page_type" id="page_type" value="<cfif isdefined('attributes.type') and len(attributes.type)><cfoutput>#attributes.type#</cfoutput></cfif>">
<input type="hidden" name="tab" id="tab" value="<cfoutput>#attributes.tab#</cfoutput>">
<cfset password_style = createObject('component','V16.hr.cfc.add_rapid_emp')><!--- Şifre standartları çekiliyor. --->
<cfset get_password_style = password_style.pass_control()>
<cfparam name="attributes.modal_id" default="">
	<cf_box_elements>
		<div class="col col-6 col-md-6 col-sm-12" type="column" index="1" sort="true">
			<input type="hidden" name="auth_emps_pos" id="auth_emps_pos" value=""><input type="hidden" name="auth_emps_id" id="auth_emps_id" value="">
			<cfif not (isdefined('attributes.from_sec') and attributes.from_sec eq 1)>
				<div class="form-group" id="item-employee_username">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57551.Kullanıcı Adı'></label>
					<div class="col col-8 col-sm-12">
						<input type="hidden" name="old_employee_username" value="<cfoutput>#get_hr.employee_username#</cfoutput>">
						<cfif isdefined("use_active_directory") and use_active_directory neq 3>
							<cfif session.ep.admin neq 1>
								<cfinput value="#get_hr.employee_username#" type="text" name="employee_username" maxlength="50" readonly="yes" style="width:150px;">
							<cfelse>
								<cfinput value="#get_hr.employee_username#" type="text" name="employee_username" maxlength="50" style="width:150px;">
							</cfif>
						<cfelse>
							<cfinput value="#get_hr.employee_username#" type="text" name="employee_username" maxlength="50" readonly="yes" style="width:150px;">
						</cfif>
					</div>
				</div>
				<div class="form-group" id="item-employee_password">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57552.Şifre'></label>
					<div class="col col-8 col-sm-12">
						<input type="hidden" name="old_employee_password" value="<cfoutput>#get_hr.employee_password#</cfoutput>">
						<cfif isdefined("use_active_directory") and use_active_directory neq 3>
							<cfif session.ep.admin neq 1 and get_hr.employee_username contains 'admin'>
								<cfinput type="password" name="employee_password" value="" maxlength="16" readonly="yes" oncopy="return false" onpaste="return false">
							<cfelse>
								<cfinput type="password" name="employee_password" value="" maxlength="16" oncopy="return false" onpaste="return false">
							</cfif>
						<cfelse>
							<cfinput type="password" name="employee_password" value="" maxlength="16" readonly="yes" oncopy="return false" onpaste="return false">
						</cfif>
					</div>	
				</div>
			<cfelse>
				<input type="hidden" name="from_sec" id="from_sec" value="1">
			</cfif>
			<div id="td_group" style="display:<cfif len(get_position_detail.user_group_id)>''<cfelse>'none'</cfif>;">
				<div class="form-group" id="item-group_id">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='32897.Kullanıcı Grubu'></label>
					<div class="col col-8 col-sm-12">
						<cfset menus="0">
						<cfif len(get_position_detail.user_group_id)>
							<cfset attributes.user_group_id = get_position_detail.user_group_id>
							<cfinclude template="../query/get_user_group_name.cfm">
						</cfif>
						<cfif get_module_user(64)>
							<select name="group_id" id="group_id" onchange="get_menus_select($(this));">
							<option value=""><cf_get_lang dictionary_id='32983.Yetki Grubu'>
							<cfoutput query="get_user_groups">
								<option value="#user_group_id#" <cfif user_group_id eq get_position_detail.user_group_id> selected</cfif>>#user_group_name#</option>
									<cfif user_group_id eq get_position_detail.user_group_id and len(wrk_menu)>
									<cfset menus = wrk_menu>
									</cfif>
							</cfoutput>
							</select>
						<cfelse>
							<input type="hidden" name="group_id" id="group_id" value="<cfoutput>#get_position_detail.user_group_id#</cfoutput>">
							<cfif len(get_position_detail.user_group_id)>
								<cfoutput>#get_user_group_name.user_group_name#</cfoutput>
							</cfif>
						</cfif>
					</div>
				</div>						
				<cfif menus neq 0 and len(menus)>							
					<cfset src_menu= createObject("component", "V16.objects.cfc.wrk_menu")>
					<cfset get_menus = src_menu.get_menu(menu_id:menus)>							
					<div class="form-group" id="item-menu_id">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='42874.Menü'></label>
						<div class="col col-8 col-sm-12">
							<select name="menu_id" id="menu_id">
								<option value="0"><cf_get_lang dictionary_id='37227.Standart'></option>
								<cfoutput query="get_menus">
									<option value="#WRK_MENU_ID#" <cfif wrk_menu_id eq get_position_detail.wrk_menu>selected</cfif>>#WRK_MENU_NAME#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</cfif>
			</div>
		</div>
	</cf_box_elements>
	<cf_box_footer>
		<cf_record_info query_name="get_hr">
		<cf_workcube_buttons is_upd="0" add_function="control()">
	</cf_box_footer>
</cfform>
<script>
	var get_menus_select = function (e){
		$('#menu_id')
			.empty()
			.append('<option value="0">Standart</option>');
		if(e.val()){
			$.ajax({                
				url: 'V16/objects/cfc/wrk_menu.cfc',
				type: "GET",
				data: ({method:'GET_MENU_JSON',usergroup:e.val()}),
				success: function (returnData) {					
					if(returnData !=0){
						var menuList = JSON.parse(returnData);					
						$.each( menuList['DATA'], function( index ) {
							$('<option>').append(this[1]).attr({value:this[0]}).appendTo('#menu_id');					
						});
					}
				},
				error: function () {
					console.warn('E:list_positions_poweruser_in_1.cfm R:114 F:get_menus_select')
				}
			});
		}
	}
	function control(){
		get_auth_emps(1,1,0);
		control_ifade_ = $('#employee_password').val();
		if ($('#employee_password').val().indexOf(" ") != -1)
		{
			alert("Şifre boşluk karakterini içeremez.");
			$('#employee_password').focus();
			return false;
		}
		if(($('#employee_username').val() != "") && ($('#employee_password').val() != "") && ($('#employee_username').val() == $('#employee_password').val()))
		{
			alert("<cf_get_lang dictionary_id='30952.Şifre Kullanıcı Adıyla Aynı Olamaz !'>s");
			$('#employee_password').focus();
			return false;
		}
		if ($('#employee_password').val() != "")
		{
			<cfif get_password_style.recordcount>
			
				var number="0123456789";
				var lowercase = "abcdefghijklmnopqrstuvwxyz";
				var uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
				var ozel="!]'^%&([=?_<£)#$½{\|.:,;/*-+}>";
				var containsNumberCase = contains(control_ifade_,number);
				var containsLowerCase = contains(control_ifade_,lowercase);
				var containsUpperCase = contains(control_ifade_,uppercase);
				var ozl = contains(control_ifade_,ozel);
				
				<cfoutput>
					if(control_ifade_.length < #get_password_style.password_length#)
					{
						alert("<cf_get_lang dictionary_id='30949.Şifre Karakter Sayısı Az'>! <cf_get_lang dictionary_id='30951.Şifrede Olması Gereken Karakter Sayısı'> : #get_password_style.password_length#");
						document.getElementById('employee_password').focus();				
						return false;
					}
					
					if(#get_password_style.password_number_length# > containsNumberCase)
					{
						alert("<cf_get_lang dictionary_id = '30948.Şifrede Olması Gereken Rakam Sayısı'> : #get_password_style.password_number_length#");
						document.getElementById('employee_password').focus();
						return false;
					}
					
					if(#get_password_style.password_lowercase_length# > containsLowerCase)
					{
						alert("<cf_get_lang dictionary_id = '30947.Şifrede Olması Gereken Küçük Harf Sayısı'> :#get_password_style.password_lowercase_length#");
						document.getElementById('employee_password').focus();				
						return false;
					}
					
					if(#get_password_style.password_uppercase_length# > containsUpperCase)
					{
						alert("<cf_get_lang dictionary_id = '30946.Şifrede Olması Gereken Büyük Harf Sayısı'> : #get_password_style.password_uppercase_length#");
						document.getElementById('employee_password').focus();
						return false;
					}
					
					if(#get_password_style.password_special_length# > ozl)
					{
						alert("<cf_get_lang dictionary_id = '30945.Şifrede Olması Gereken Özel Karakter Sayısı'> : #get_password_style.password_special_length#");
						document.getElementById('employee_password').focus();
						return false;
					}
				</cfoutput>
			</cfif>
		}
			<cfif isDefined("attributes.draggable")>
				loadPopupBox('employee_user_name' , <cfoutput>#attributes.modal_id#</cfoutput>);
				return false;
			</cfif>
			
	}
	function contains(deger,validChars)						
	{
		var sayac=0;				             
		for (i = 0; i < deger.length; i++)
		{
			var char = deger.charAt(i);
			if (validChars.indexOf(char) > -1)    
				sayac++;
		}
		return(sayac);				
    }
</script>
