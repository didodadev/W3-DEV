<cfquery name="BILGI_GETIR" datasource="#DSN#" maxrows="1">
	SELECT  
    	PASSWORD_ID, 
        PASSWORD_LENGTH, 
        PASSWORD_LOWERCASE_LENGTH, 
        PASSWORD_UPPERCASE_LENGTH, 
        PASSWORD_NUMBER_LENGTH, 
        PASSWORD_SPECIAL_LENGTH, 
        PASSWORD_HISTORY_CONTROL, 
        PASSWORD_CHANGE_INTERVAL, 
        PASSWORD_STATUS, 
        PASSWORD_NAME,
        FAILED_LOGIN_COUNT, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
	    PASSWORD_CONTROL 
    WHERE 
    	PASSWORD_ID=#URL.ID#
</cfquery>
<cfquery datasource="#DSN#" name="TUM_VERILER">
    SELECT 
    	PASSWORD_ID, 
        PASSWORD_LENGTH, 
        PASSWORD_LOWERCASE_LENGTH, 
        PASSWORD_UPPERCASE_LENGTH, 
        PASSWORD_NUMBER_LENGTH, 
        PASSWORD_SPECIAL_LENGTH, 
        PASSWORD_HISTORY_CONTROL, 
        PASSWORD_CHANGE_INTERVAL, 
        PASSWORD_STATUS, 
        PASSWORD_NAME,
        FAILED_LOGIN_COUNT, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	PASSWORD_CONTROL
</cfquery>
<cfobject name="inst_plevne_settings" type="component" component="AddOns.Plevne.models.settings">
<cfset is_plevne_installed = inst_plevne_settings.is_installed()>

<cfsavecontent variable="title"><cf_get_lang dictionary_id='42823.Şifreleme Sistemi'></cfsavecontent>
<cf_box title="#title#">
	<form action="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.emptypopup_upd_password_inf" method="post" name="computer_info">
		<cf_box_elements>
			<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
				<cfif TUM_VERILER.recordcount>
					<cfoutput query="TUM_VERILER">
						<div class="scrollbar" style="max-height:403px;overflow:auto;">
							<label width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></label>
							<label width="180"><a href="#request.self#?fuseaction=settings.form_upd_password_inf&ID=#PASSWORD_ID#">#PASSWORD_NAME#</a></label>
						</div>
					</cfoutput>
				<cfelse>
					<div class="form-group">
						<label width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></label>
						<label width="180"><font><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</font></label>
					</div>
				</cfif>
			</div>
			<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
				<input type="hidden" name="update" id="update" value="<cfoutput>#BILGI_GETIR.PASSWORD_ID#</cfoutput>">
				<div class="form-group" id="item-ACTIVE">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12 font-blue-madison bold"><cf_get_lang dictionary_id='57756.Durum'></label>
					<label class="col col-8 col-xs-12"><input type="checkbox"  name="ACTIVE" id="ACTIVE" <cfif BILGI_GETIR.PASSWORD_STATUS eq 1>checked</cfif>><cf_get_lang_main no='81.Aktif'></label>
				</div>
				<div class="form-group" id="item-PASSWORD_NAME">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='44765.Şifre Tanımı'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
						<input type="text" name="PASSWORD_NAME" id="PASSWORD_NAME" maxlength="50" value="<cfoutput>#BILGI_GETIR.PASSWORD_NAME#</cfoutput>">
					</div>
				</div>	
				<div class="form-group" id="item-SIFRE_UZUNLUK">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57552.Şifre'><cf_get_lang dictionary_id='42844.Uzunluk'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="SIFRE_UZUNLUK" id="SIFRE_UZUNLUK" style="width:80px;">
							<option value="1" <cfif BILGI_GETIR.PASSWORD_LENGTH eq 1> selected</cfif>>1 <cf_get_lang dictionary_id ='42569.Karakter'></option>
							<option value="2" <cfif BILGI_GETIR.PASSWORD_LENGTH eq 2> selected</cfif>>2 <cf_get_lang dictionary_id ='42569.Karakter'></option>
							<option value="3" <cfif BILGI_GETIR.PASSWORD_LENGTH eq 3> selected</cfif>>3 <cf_get_lang dictionary_id ='42569.Karakter'></option>
							<option value="4" <cfif BILGI_GETIR.PASSWORD_LENGTH eq 4> selected</cfif>>4 <cf_get_lang dictionary_id ='42569.Karakter'></option>
							<option value="5" <cfif BILGI_GETIR.PASSWORD_LENGTH eq 5> selected</cfif>>5 <cf_get_lang dictionary_id ='42569.Karakter'></option>
							<option value="6" <cfif BILGI_GETIR.PASSWORD_LENGTH eq 6> selected</cfif>>6 <cf_get_lang dictionary_id ='42569.Karakter'></option>
							<option value="7" <cfif BILGI_GETIR.PASSWORD_LENGTH eq 7> selected</cfif>>7 <cf_get_lang dictionary_id ='42569.Karakter'></option>
							<option value="8" <cfif BILGI_GETIR.PASSWORD_LENGTH eq 8> selected</cfif>>8 <cf_get_lang dictionary_id ='42569.Karakter'></option>
							<option value="9" <cfif BILGI_GETIR.PASSWORD_LENGTH eq 9> selected</cfif>>9 <cf_get_lang dictionary_id ='42569.Karakter'></option>
							<option value="10" <cfif BILGI_GETIR.PASSWORD_LENGTH eq 10> selected</cfif>>10 <cf_get_lang dictionary_id ='42569.Karakter'></option>
							<option value="11" <cfif BILGI_GETIR.PASSWORD_LENGTH eq 11> selected</cfif>>11 <cf_get_lang dictionary_id ='42569.Karakter'></option>
							<option value="12" <cfif BILGI_GETIR.PASSWORD_LENGTH eq 12> selected</cfif>>12 <cf_get_lang dictionary_id ='42569.Karakter'></option>
							<option value="13" <cfif BILGI_GETIR.PASSWORD_LENGTH eq 13> selected</cfif>>13 <cf_get_lang dictionary_id ='42569.Karakter'></option>
							<option value="14" <cfif BILGI_GETIR.PASSWORD_LENGTH eq 14> selected</cfif>>14 <cf_get_lang dictionary_id ='42569.Karakter'></option>
							<option value="15"<cfif BILGI_GETIR.PASSWORD_LENGTH eq 15> selected</cfif>>15 <cf_get_lang dictionary_id ='42569.Karakter'></option>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-KUCUK_HARF_UZUNLUK">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57552.Şifre'><cf_get_lang dictionary_id ='44209.Kucuk Harf Sayısı'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="KUCUK_HARF_UZUNLUK" id="KUCUK_HARF_UZUNLUK" style="width:80px;">
							<option value="0"<cfif BILGI_GETIR.PASSWORD_LOWERCASE_LENGTH eq 0>selected</cfif>>0</option>
							<option value="1" <cfif BILGI_GETIR.PASSWORD_LOWERCASE_LENGTH eq 1>selected</cfif>>1</option>
							<option value="2" <cfif BILGI_GETIR.PASSWORD_LOWERCASE_LENGTH eq 2>selected</cfif>>2</option>
							<option value="3" <cfif BILGI_GETIR.PASSWORD_LOWERCASE_LENGTH eq 3>selected</cfif>>3</option>
							<option value="4" <cfif BILGI_GETIR.PASSWORD_LOWERCASE_LENGTH eq 4>selected</cfif>>4</option>
							<option value="5"<cfif BILGI_GETIR.PASSWORD_LOWERCASE_LENGTH eq 5>selected</cfif>>5</option>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-BUYUK_HARF_UZUNLUK">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57552.Şifre'><cf_get_lang dictionary_id ='43877.Buyuk Harf Sayısı'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="BUYUK_HARF_UZUNLUK" id="BUYUK_HARF_UZUNLUK" style="width:80px;">
							<option value="0" <cfif BILGI_GETIR.PASSWORD_UPPERCASE_LENGTH eq 0>selected</cfif>>0</option>
							<option value="1" <cfif BILGI_GETIR.PASSWORD_UPPERCASE_LENGTH eq 1>selected</cfif>>1</option>
							<option value="2" <cfif BILGI_GETIR.PASSWORD_UPPERCASE_LENGTH eq 2>selected</cfif>>2</option>
							<option value="3" <cfif BILGI_GETIR.PASSWORD_UPPERCASE_LENGTH eq 3>selected</cfif>>3</option>
							<option value="4" <cfif BILGI_GETIR.PASSWORD_UPPERCASE_LENGTH eq 4>selected</cfif>>4</option>
							<option value="5" <cfif BILGI_GETIR.PASSWORD_UPPERCASE_LENGTH eq 5>selected</cfif>>5</option>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-RAKAM_UZUNLUK">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57552.Şifre'><cf_get_lang dictionary_id ='43818.Rakam Sayısı'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="RAKAM_UZUNLUK" id="RAKAM_UZUNLUK" style="width:80px;">
							<option value="1"<cfif BILGI_GETIR.PASSWORD_NUMBER_LENGTH eq 1>selected</cfif>>1</option>
							<option value="2" <cfif BILGI_GETIR.PASSWORD_NUMBER_LENGTH eq 2>selected</cfif>>2</option>
							<option value="3" <cfif BILGI_GETIR.PASSWORD_NUMBER_LENGTH eq 3>selected</cfif>>3</option>
							<option value="4" <cfif BILGI_GETIR.PASSWORD_NUMBER_LENGTH eq 4>selected</cfif>>4</option>
							<option value="5" <cfif BILGI_GETIR.PASSWORD_NUMBER_LENGTH eq 5>selected</cfif>>5</option>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-OZEL_KARAKTER_UZUNLUK">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57552.Şifre'><cf_get_lang dictionary_id ='43823.Özel Karakter Sayısı'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="OZEL_KARAKTER_UZUNLUK" id="OZEL_KARAKTER_UZUNLUK" style="width:80px;">
							<option value="1" <cfif BILGI_GETIR.PASSWORD_SPECIAL_LENGTH eq 1>selected</cfif>>1</option>
							<option value="2" <cfif BILGI_GETIR.PASSWORD_SPECIAL_LENGTH eq 2>selected</cfif>>2</option>
							<option value="3" <cfif BILGI_GETIR.PASSWORD_SPECIAL_LENGTH eq 3>selected</cfif>>3</option>
							<option value="4" <cfif BILGI_GETIR.PASSWORD_SPECIAL_LENGTH eq 4>selected</cfif>>4</option>
							<option value="5" <cfif BILGI_GETIR.PASSWORD_SPECIAL_LENGTH eq 5>selected</cfif>>5</option>
						</select>
					</div>     
				</div>
				<div class="form-group" id="item-KONTROL_SAYISI">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='43845.Eski Sifre Kontrol Sayısı'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="KONTROL_SAYISI" id="KONTROL_SAYISI" style="width:80px;">
							<option value="0" <cfif BILGI_GETIR.PASSWORD_HISTORY_CONTROL eq 0>selected</cfif>>0</option>
							<option value="1" <cfif BILGI_GETIR.PASSWORD_HISTORY_CONTROL eq 1>selected</cfif>>1</option>
							<option value="2" <cfif BILGI_GETIR.PASSWORD_HISTORY_CONTROL eq 2>selected</cfif>>2</option>
							<option value="3" <cfif BILGI_GETIR.PASSWORD_HISTORY_CONTROL eq 3>selected</cfif>>3</option>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-KONTROL_GUN">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='43876.Sifre Degisim Aralıgı'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="KONTROL_GUN" id="KONTROL_GUN" style="width:80px;">
							<option value="0" <cfif BILGI_GETIR.PASSWORD_CHANGE_INTERVAL eq 0>selected</cfif>><cf_get_lang dictionary_id='58845.Tanımsız'></option>
							<cfif isdefined("use_active_directory") and use_active_directory neq 3>
								<option value="30" <cfif BILGI_GETIR.PASSWORD_CHANGE_INTERVAL eq 30>selected</cfif>>30 <cf_get_lang dictionary_id='57490.gün'></option>
								<option value="60" <cfif BILGI_GETIR.PASSWORD_CHANGE_INTERVAL eq 60>selected</cfif>>60 <cf_get_lang dictionary_id='57490.gün'></option>
								<option value="90" <cfif BILGI_GETIR.PASSWORD_CHANGE_INTERVAL eq 90>selected</cfif>>90 <cf_get_lang dictionary_id='57490.gün'></option>
								<option value="120" <cfif BILGI_GETIR.PASSWORD_CHANGE_INTERVAL eq 120>selected</cfif>>120 <cf_get_lang dictionary_id='57490.gün'></option>
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
									<option value="#count#" <cfif BILGI_GETIR.FAILED_LOGIN_COUNT eq count>selected</cfif>>#count#</option>
								</cfloop>
							</cfoutput>
						</select>
					</div>
				</div>
				<cfif is_plevne_installed neq 0>
				<cfset plevne_mfa_enabled = inst_plevne_settings.get_plevne_setting_bykey("MFA_ENABLED")>
				<div class="form-group" id="item-mfa_enabled">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12">MFA <cf_get_lang dictionary_id='57493.Aktif'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select style="width:80px;" name="mfa_enabled" id="mfa_enabled">
							<cfoutput>
								<option value="0" <cfif plevne_mfa_enabled eq "0">selected</cfif>>Pasif</option>
								<option value="1" <cfif plevne_mfa_enabled eq "1">selected</cfif>>Aktif</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<cfset plevne_mfa_until = inst_plevne_settings.get_plevne_setting_bykey("MFA_UNTIL")>
				<div class="form-group" id="item-mfa_until">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12">MFA <cf_get_lang dictionary_id='64277.Zaman Aşımı'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select style="width:80px;" name="mfa_until" id="mfa_until">
							<cfoutput>
							<option value="0" <cfif plevne_mfa_until eq "0">selected</cfif>>Oturum başına</option>
							<option value="3" <cfif plevne_mfa_until eq "3">selected</cfif>>3 Gün</option>
							<option value="7" <cfif plevne_mfa_until eq "7">selected</cfif>>7 Gün</option>
							<option value="14" <cfif plevne_mfa_until eq "14">selected</cfif>>14 Gün</option>
							<option value="30" <cfif plevne_mfa_until eq "30">selected</cfif>>30 Gün</option>
							</cfoutput>
						</select>
					</div>
				</div>
				</cfif>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_record_info query_name="BILGI_GETIR"><cf_workcube_buttons is_upd='1' add_function='form_kontrol()' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_password_inf&sil=#BILGI_GETIR.PASSWORD_ID#'>
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
			alert("<cf_get_lang no='43878.SIFRE UZUNLUGUNUZ BELIRLENEN LIMITI ASMISTIR'>!");
			return false;
		}
		else	
		{
			window.computer_info.submit();
			return false;
		}
	}
</script>
