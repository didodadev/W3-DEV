<cfif not isdefined("session.cp.userid")>
	<cfif isdefined("attributes.career_login_url") and len(attributes.career_login_url)>
		<cfset url_ = "#attributes.career_login_url#">
	<cfelse>
		<cfset url_ = "#request.self#?fuseaction=home.act_login">
	</cfif>	
	<cfform name="form_login" action="#url_#" method="post">
		<input type="hidden" name="referer" id="referer" value="<cfif isdefined('attributes.fuseaction') and len(attributes.fuseaction) and attributes.fuseaction neq 'home.login'><cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput></cfif>">
		<input type="hidden" name="member_type" id="member_type" value="3">
			<div class="form-group row">
			<label class="col-md-2 col-form-label"><cf_get_lang dictionary_id='57428.E-posta'></label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-2">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='29707.Lütfen e-mail adresinizi giriniz'></cfsavecontent>
				<cfinput type="text" class="form-control" name="username" value="" validate="email" required="yes" message="#message#!" autocomplete="off">
			</div>
		</div>
		<div class="form-group row">
			<label class="col-md-2 col-form-label"><cf_get_lang dictionary_id='35726.Şifreniz'></label>
			<div class="col-12 col-md-8 col-lg-6 col-xl-2">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='30481.Şifrenizi Girmediniz'></cfsavecontent>	
				<cfinput type="password" class="form-control" name="password" value="" required="yes" message="#message#!" autocomplete="off">
			</div>
		</div>
		<div class="form-group row">			
			<div class="col-12 col-md-8 col-lg-6 col-xl-5">
				<input type="submit" class="btn bg-primary" name="giris" id="giris" value=" <cf_get_lang_main no='142.Giriş'>  ">
			</div>
		</div>
		<div class="row">
			<div class="col-xl-12">
				<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.form_add_new_user"><cf_get_lang dictionary_id='35070.Yeni Kullanıcı'></a> | <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.form_lost_pass"><cf_get_lang dictionary_id='29833.Şifremi Unuttum'></a>		
			</div>
		</div>
		
		<cfif isDefined("session.error_text_cp")>
			<tr>
			  <td></td>
			  <td><font color="#FF0000"><cfoutput>#session.error_text_cp#</cfoutput></font></td>
			</tr>
			<cfscript>
				if (isdefined("session.error_text_cp")) 
					{
					structdelete(session,"error_text_cp");
					}
			</cfscript>
		</cfif>
	</cfform>	
	<script type="text/javascript">
		document.getElementById('username').focus();
	</script>
<cfelse>
	<div class="row mb-0">
		<div class="col-xl-12 d-flex justify-content-center">
			<h5 class="font-weight-bold"><cf_get_lang dictionary_id='35123.Hoşgeldiniz'></h5>			
		</div>
	</div>
	<div class="row mb-2">
		<div class="col-xl-12 d-flex justify-content-center">
			<h5><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.form_upd_cv_1"><cfoutput>#session.cp.name# #session.cp.surname#</cfoutput></a></h5>
		</div>
	</div>	
	<table class="table table-borderless">
		<tr>
			<td align="center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.dsp_cv"><cf_get_lang dictionary_id='31446.Özgeçmişim'></a></td>
		</tr>
		<cfif isdefined('attributes.is_fast_cv') and attributes.is_fast_cv eq 1>
			<tr>
				<td align="center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.form_upd_fast_cv"><font color="#FF3333"><cf_get_lang dictionary_id='35125.Hızlı Özgeçmiş Oluştur'></font></a></td>
			</tr>
		</cfif> 
		<tr>
			<td align="center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.form_upd_cv_1"><cf_get_lang dictionary_id='35126.Detaylı Özgeçmiş Oluştur'></a></td>
		</tr>
		<tr>
			<td align="center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.change_pass"><cf_get_lang dictionary_id='35128.Üye Bilgilerim'></a></td>
		</tr>
		<tr>
			<td align="center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.list_app_pos"><cf_get_lang dictionary_id='35129.Başvurularım'></a></td>
		</tr>
		<tr>
			<td align="center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=home.act_logout"><cf_get_lang dictionary_id='57431.Çıkış'></a></td>
		</tr>
	</table>
</cfif>