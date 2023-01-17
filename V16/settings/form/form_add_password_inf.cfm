<cfquery name="VERILER" datasource="#DSN#">
	SELECT 
		PASSWORD_ID,  
		PASSWORD_NAME
	FROM 
		PASSWORD_CONTROL
</cfquery>
<cfobject name="inst_plevne_settings" type="component" component="AddOns.Plevne.models.settings">
<cfset is_plevne_installed = inst_plevne_settings.is_installed()>
<cfsavecontent variable="title"><cf_get_lang dictionary_id='42823.Şifreleme Sistemi'></cfsavecontent>
<cf_box title="#title#" closable="0" collapsed="0">
	<form action="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.emptypopup_add_password_inf" method="post" name="form1">
		<cf_box_elements>
			<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
				<cfif veriler.recordcount>
					<cfoutput query="VERILER">
						<div class="scrollbar" style="max-height:403px;overflow:auto;">
							<label width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></label>
							<label valign="top" width="180"><a href="#request.self#?fuseaction=settings.form_upd_password_inf&ID=#PASSWORD_ID#" class="tableyazi">#PASSWORD_NAME#</a></label>
						</div>
					</cfoutput>
				<cfelse>
					<div class="form-group">
						<label width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></label>
						<label width="180"><font class="tableyazi"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</font></label>
					</div>
				</cfif>
			</div>
			<input type="hidden" name="insert" id="insert" value="<cfoutput>#VERILER.PASSWORD_ID#</cfoutput>">
			<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group" id="item-ACTIVE">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12 font-blue-madison bold"><cf_get_lang dictionary_id='57756.Durum'></label>
					<label class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="ACTIVE" id="ACTIVE"><cf_get_lang dictionary_id='57493.Aktif'></label>
				</div>   
				<div class="form-group" id="item-PASSWORD_NAME">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='44765.Şifre Tanımı'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
						<input type="text" name="PASSWORD_NAME" id="PASSWORD_NAME" maxlength="50">
					</div>
				</div>   
				<div class="form-group" id="item-SIFRE_UZUNLUK">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57552.Şifre'><cf_get_lang dictionary_id='42844.Uzunluk'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select style="width:80px;" name="SIFRE_UZUNLUK" id="SIFRE_UZUNLUK">
							<option value="6">6 <cf_get_lang dictionary_id ='42569.Karakter'></option>
							<option value="7">7 <cf_get_lang dictionary_id ='42569.Karakter'></option>
							<option value="8">8 <cf_get_lang dictionary_id ='42569.Karakter'></option>
							<option value="9">9 <cf_get_lang dictionary_id ='42569.Karakter'></option>
							<option value="10">10 <cf_get_lang dictionary_id ='42569.Karakter'></option>
							<option value="11">11 <cf_get_lang dictionary_id ='42569.Karakter'></option>
							<option value="12">12 <cf_get_lang dictionary_id ='42569.Karakter'></option>
							<option value="13">13 <cf_get_lang dictionary_id ='42569.Karakter'></option>
							<option value="14">14 <cf_get_lang dictionary_id ='42569.Karakter'></option>
							<option value="15">15 <cf_get_lang dictionary_id ='42569.Karakter'></option>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-KUCUK_HARF_UZUNLUK">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57552.Şifre'><cf_get_lang dictionary_id ='44209.Kucuk Harf Sayısı'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select style="width:80px;" name="KUCUK_HARF_UZUNLUK" id="KUCUK_HARF_UZUNLUK">
							<option value="0">0</option>
							<option value="1">1</option>
							<option value="2">2</option>
							<option value="3">3</option>
							<option value="4">4</option>
							<option value="5">5</option>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-BUYUK_HARF_UZUNLUK">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57552.Şifre'><cf_get_lang dictionary_id ='43877.Buyuk Harf Sayısı'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select style="width:80px;" name="BUYUK_HARF_UZUNLUK" id="BUYUK_HARF_UZUNLUK" >
							<option value="0">0</option>
							<option value="1">1</option>
							<option value="2">2</option>
							<option value="3">3 </option>
							<option value="4">4</option>
							<option value="5">5</option>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-RAKAM_UZUNLUK">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57552.Şifre'><cf_get_lang dictionary_id ='43818.Rakam Sayısı'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select  style="width:80px;" name="RAKAM_UZUNLUK" id="RAKAM_UZUNLUK">
							<option value="1">1</option>
							<option value="2">2</option>
							<option value="3">3</option>
							<option value="4">4</option>
							<option value="5">5</option>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-OZEL_KARAKTER_UZUNLUK">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57552.Şifre'><cf_get_lang dictionary_id ='43823.Özel Karakter Sayısı'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select  style="width:80px;" name="OZEL_KARAKTER_UZUNLUK" id="OZEL_KARAKTER_UZUNLUK">
							<option value="1">1</option>
							<option value="2">2</option>
							<option value="3">3</option>
							<option value="4">4</option>
							<option value="5">5</option>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-KONTROL_SAYISI">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='43845.Eski Sifre Kontrol Sayısı'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select style="width:80px;" name="KONTROL_SAYISI" id="KONTROL_SAYISI">
							<option value="0">0</option>
							<option value="1">1</option>
							<option value="2">2</option>
							<option value="3">3</option>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-KONTROL_GUN">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='43876.Sifre Degisim Aralıgı'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select style="width:80px;" name="KONTROL_GUN" id="KONTROL_GUN">
							<option value="0"><cf_get_lang dictionary_id='58845.Tanımsız'></option>
							<cfif isdefined("use_active_directory") and use_active_directory neq 3>
								<option value="30">30 <cf_get_lang dictionary_id='57490.gün'></option>
								<option value="60">60 <cf_get_lang dictionary_id='57490.gün'></option>
								<option value="90">90 <cf_get_lang dictionary_id='57490.gün'></option>
								<option value="120">120 <cf_get_lang dictionary_id='57490.gün'></option>
							</cfif>
						</select>
					</div>
				</div> 
				<div class="form-group" id="item-login_count">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42186.Maksimum Hatalı Giris Sayisi'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select style="width:80px;" name="login_count" id="login_count">
							<cfoutput>
								<option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfloop index="count" from="3" to="10">
									<option value="#count#">#count#</option>
								</cfloop>
							</cfoutput>
						</select>
					</div>
				</div>
				<cfif is_plevne_installed neq 0>
					<cfset plevne_mfa_enabled = inst_plevne_settings.get_plevne_setting_bykey("MFA_ENABLED")>
					<div class="form-group" id="item-mfa_enabled">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='64912.MFA Aktif'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name="mfa_enabled" id="mfa_enabled">
								<cfoutput>
									<option value="0"><cf_get_lang dictionary_id='57494.Pasif'></option>
									<option value="1"><cf_get_lang dictionary_id='57493.Aktif'></option>
								</cfoutput>
							</select>
						</div>
					</div>
					<cfset plevne_mfa_until = inst_plevne_settings.get_plevne_setting_bykey("MFA_UNTIL")>
					<div class="form-group" id="item-mfa_until">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='64913.MFA Zaman Aşımı'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name="mfa_until" id="mfa_until">
								<cfoutput>
									<option value="0"><cf_get_lang dictionary_id='64914.Oturum Başına'></option>
									<option value="3">3 <cf_get_lang dictionary_id='57490.gün'></option>
									<option value="7">7 <cf_get_lang dictionary_id='57490.gün'></option>
									<option value="14">14 <cf_get_lang dictionary_id='57490.gün'></option>
									<option value="30">30 <cf_get_lang dictionary_id='57490.gün'></option>
								</cfoutput>
							</select>
						</div>
					</div>
					</cfif>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0' add_function='form_kontrol()'>
		</cf_box_footer>
	</form>
</cf_box>	
<script type="text/javascript">
function form_kontrol()
{
	var r=document.getElementById('KUCUK_HARF_UZUNLUK').value;
	var d=document.getElementById('BUYUK_HARF_UZUNLUK').value;
	var e=document.getElementById('RAKAM_UZUNLUK').value;
	var c=document.getElementById('OZEL_KARAKTER_UZUNLUK').value;
	var SİFRE_UZUNLUGU=document.getElementById('SIFRE_UZUNLUK').value;
	var a=parseInt(r)+parseInt(d)+parseInt(e)+parseInt(c);

	if(a>SİFRE_UZUNLUGU)
	{
		alert("<cf_get_lang dictionary_id ='43878.SIFRE UZUNLUGUNUZ BELIRLENEN LIMITI ASMISTIR'> !");
		return false;
	}
	else	
	{
		window.form1.submit();
		return false;
	}
}
</script>
