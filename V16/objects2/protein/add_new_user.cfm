<cfset password_style = createObject('component','V16.hr.cfc.add_rapid_emp')><!--- Şifre standartları çekiliyor. --->
<cfset get_password_style = password_style.pass_control()>

<cfset company_cmp = createObject("component","V16.member.cfc.member_company")>
<cfscript>

    get_partner_positions = company_cmp.GET_PARTNER_POSITIONS();
    GET_STATUS = company_cmp.GET_STATUS();

</cfscript>

<cfif isDefined("session.pp")>
    <cfset company_id = session.pp.company_id>
<cfelseif isDefined("session.ww")>
    <cfset company_id = session.ww.company_id>
</cfif>

<cfform name="add_company_partner" method="post">
    <cfinput type="hidden" name="company_id" value="#company_id#">
    <div class="ui-scroll row">
        <div class="col-md-8 col-xs-12">
            <div class="form-row">
                <div class="form-group col-lg-6 col-xl-6">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='57631.Ad'>*</label>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='57631.Ad'></cfsavecontent>
                    <input type="text" name="company_partner_name" id="company_partner_name" class="form-control" placeholder="<cf_get_lang dictionary_id='57631.Ad'>" required="yes" message="<cfoutput>#message#</cfoutput>">
                </div>
                <div class="form-group col-lg-6 col-xl-6">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='58726.Soyad'></cfsavecontent>
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='58726.Soyad'>*</label>
                    <input type="text" name="company_partner_surname" id="company_partner_surname" class="form-control" placeholder="<cf_get_lang dictionary_id='58726.Soyad'>" required="yes" message="<cfoutput>#message#</cfoutput>">
                </div>
            </div>
            <div class="form-row">
                <div class="form-group col-lg-12 col-xl-12">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='58497.Pozisyon'></cfsavecontent>
                    <select class="form-control" name="mission" id="mission" required="yes" message="<cfoutput>#message#</cfoutput>">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfoutput query="get_partner_positions">
                            <option value="#partner_position_id#">#partner_position#</option>
                        </cfoutput>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group col-lg-12 col-xl-12">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='57756.Durum'> - <cf_get_lang dictionary_id='57894.Statü'></label>
                    <select class="form-control" name="status_id" id="status_id">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfoutput query="GET_STATUS">
                            <option value="#cps_id#">#status_name#</option>
                        </cfoutput>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group col-lg-4 col-xl-4">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='42782.E-Mail'></label>
                    <input type="email" name="company_partner_email" id="company_partner_email" class="form-control" placeholder="<cf_get_lang dictionary_id='42782.E-Mail'>">
                </div>
                <div class="form-group col-lg-4 col-xl-4">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='61819.?'></label>
                    <input type="text" name="mobilcat_id" id="mobilcat_id" class="form-control" placeholder="<cf_get_lang dictionary_id='61824.?'>" value="">
                </div>
                <div class="form-group col-lg-4 col-xl-4">
                    <label class="font-weight-bold">&nbsp;</label>
                    <input type="text" name="mobiltel" id="mobiltel" class="form-control" placeholder="<cf_get_lang dictionary_id='61824.?'>" value="">
                </div>
            </div>                        
                
            <div class="form-row">
                <div class="form-group col-lg-12 col-xl-12">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='57551.Username'>*</label>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='57551.Username'></cfsavecontent>
                    <input type="text" name="username" id="username" class="form-control" placeholder="<cf_get_lang dictionary_id='57551.Username'>" required="yes" message="<cfoutput>#message#</cfoutput>" value="">
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group col-lg-12 col-xl-12">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='57552.Şifre'>*</label>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='57552.Şifre'></cfsavecontent>
                    <input type="password" name="password" id="password" class="form-control" placeholder="<cf_get_lang dictionary_id='57552.Şifre'>">
                </div>
            </div>
        </div>     
    </div>
    <div class="draggable-footer">
        <cf_workcube_buttons is_insert="1" add_function="pass_control()" data_action="/V16/member/cfc/member_company:add_partner_protein" next_page="/users" >
    </div>
</cfform>

<script>
    function pass_control() {
        control_ifade_ = $('#password').val();
		if ($('#password').val().indexOf(" ") != -1)
		{
			alert("Şifre boşluk karakterini içeremez.");
			$('#password').focus();
			return false;
		}
		if(($('#username').val() != "") && ($('#password').val() != "") && ($('#username').val() == $('#password').val()))
		{
			alert("<cf_get_lang dictionary_id='30952.Şifre Kullanıcı Adıyla Aynı Olamaz !'>");
			$('#password').focus();
			return false;
		}
		if ($('#password').val() != "")
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
						document.getElementById('password').focus();				
						return false;
					}
					
					if(#get_password_style.password_number_length# > containsNumberCase)
					{
						alert("<cf_get_lang dictionary_id = '30948.Şifrede Olması Gereken Rakam Sayısı'> : #get_password_style.password_number_length#");
						document.getElementById('password').focus();
						return false;
					}
					
					if(#get_password_style.password_lowercase_length# > containsLowerCase)
					{
						alert("<cf_get_lang dictionary_id = '30947.Şifrede Olması Gereken Küçük Harf Sayısı'> :#get_password_style.password_lowercase_length#");
						document.getElementById('password').focus();				
						return false;
					}
					
					if(#get_password_style.password_uppercase_length# > containsUpperCase)
					{
						alert("<cf_get_lang dictionary_id = '30946.Şifrede Olması Gereken Büyük Harf Sayısı'> : #get_password_style.password_uppercase_length#");
						document.getElementById('password').focus();
						return false;
					}
					
					if(#get_password_style.password_special_length# > ozl)
					{
						alert("<cf_get_lang dictionary_id = '30945.Şifrede Olması Gereken Özel Karakter Sayısı'> : #get_password_style.password_special_length#");
						document.getElementById('password').focus();
						return false;
					}
				</cfoutput>
			</cfif>
		}
    }
</script>