<cfform name="change_pass" action="#request.self#?fuseaction=objects2.emptypopup_add_change_pass" method="post">
<div class="row">
	<div class="col-md-12">		
		<cfif isDefined("session.error_text")>		
			<p class="text-color-3"><cfoutput>#session.error_text#</cfoutput></p>		 
			<cfscript>
				if (isdefined("session.error_text")) 
					{
					structdelete(session,"error_text");
					}
			</cfscript>
		</cfif>

		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='35813.E-posta adresiniz'></label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-3">
				<cfinput type="text" class="form-control" name="username" value="" validate="email" required="yes" message="E-Posta Adresinizi Girin!">
			</div>
		</div>
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='58674.Yeni'> <cf_get_lang dictionary_id='35813.E-posta adresiniz'></label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-3">
				<cfinput type="text" class="form-control" name="new_username" value="" validate="email">
			</div>
		</div>
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='35470.Eski Şifrenizi Girin'></label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-3">
				<cfinput type="password" class="form-control" name="old_password" value="" maxlength="16">
			</div>
		</div>
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='35471.Yeni Şifrenizi Giriniz'></label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-3">
				<cfinput type="password" class="form-control" name="new_password" value="" maxlength="16">
			</div>
		</div>
		<div class="form-group row">
			<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='35471.Yeni Şifrenizi Giriniz'> (<cf_get_lang dictionary_id='33154.Tekrar'>)</label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-3">
				<cfinput type="password" class="form-control" name="new_password2" value="" maxlength="16" >
			</div>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-12 d-flex justify-content-start">
		<cfsavecontent variable="update_btn"><cf_get_lang dictionary_id='57464.Update'></cfsavecontent>
		<td>
			<!--- <cf_workcube_buttons is_upd='0' insert_info='#update_btn#' add_function='kontrol()' is_cancel='0'> --->
			<cf_workcube_buttons is_insert='1' insert_info='#update_btn#' add_function='kontrol()'	data_action="/V16/objects2/career/cfc/data_career_partner:add_change_pass" next_page="#request.self#" >
		</td>
	</div>
</div>
</cfform>


<script type="text/javascript">
	function kontrol()
	{
		if (document.change_pass.old_password.value.length != 0 && (document.change_pass.new_password.value.length == 0 || document.change_pass.new_password2.value.length == 0))
		{
			alert("<cf_get_lang dictionary_id='35091.Please Enter New Password Twice'>!");
			return false;
		}
		if (document.change_pass.new_username.value.length == 0 && document.change_pass.old_password.value.length == 0)
		{
			alert("<cf_get_lang dictionary_id='35092.Enter your current email address or password information.'>!");
			return false;
		}
		return true;
	}
	change_pass.username.focus();
</script>

