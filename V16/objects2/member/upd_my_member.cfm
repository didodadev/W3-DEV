<cfif not isdefined("session.pp.userid")>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang no='233.Erişim İzni Yok'>.
	<cfexit method="exittemplate">
</cfif>
<cfif not isDefined("attributes.company_id")>
	<cfset attributes.company_id = session.pp.company_id>
</cfif>
<cfquery name="MY_COMPANY_" datasource="#DSN#">
	SELECT 
		COMPANY_ID
	FROM
		COMPANY
	WHERE
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
		HIERARCHY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
</cfquery>
<cfquery name="MY_TEAM_" datasource="#DSN#">
	SELECT 
		PARTNER_ID 
	FROM 
		WORKGROUP_EMP_PAR 
	WHERE 
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND 
		PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
</cfquery>

<cfif (not my_company_.recordcount) and (not my_team_.recordcount)>
	<script type="text/javascript">
		alert('<cf_get_lang no="499.Yetki Dışı Erişim Yapamazsınız">!');
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_COMPANY_" datasource="#DSN#">
	SELECT 
		C.*,
		CC.COMPANYCAT
	FROM
		COMPANY C,
		COMPANY_CAT CC
	WHERE
		C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
		CC.COMPANYCAT_ID = C.COMPANYCAT_ID AND
		CC.IS_VIEW = 1 AND
		C.COMPANY_STATUS = 1
</cfquery>
<cfquery name="GET_COMPANYCAT" datasource="#dsn#">
	SELECT 
		COMPANYCAT_ID, 
		COMPANYCAT 
	FROM 
		COMPANY_CAT
	WHERE
		IS_VIEW = 1
</cfquery>
<cfinclude template="../query/get_company_sector.cfm">
<cfinclude template="../query/get_company_size.cfm">
<cfinclude template="../query/get_country.cfm">
<cfinclude template="../query/get_partner_positions.cfm">
<cfinclude template="../query/get_partner_departments.cfm">
<table align="center" cellpadding="2" cellspacing="1" border="0" style="width:100%">
	<tr style="height:30px;">
		<td class="txtboldblue"><cf_get_lang_main no='173.Kurumsal Üye'></td>
		<td  style="text-align:right;">
			<cfif isdefined('attributes.is_member_object') and attributes.is_member_object eq 1>
				<form name="list_call_center" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.list_service_call_center">
				  	<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
				  	<input type="hidden" name="company_name" id="company_name" value="<cfoutput>#get_company_.fullname#</cfoutput>">
				  	<input type="hidden" name="form_submitted" id="form_submitted" value="1">
				</form>
				<a href="<cfoutput>#request.self#?fuseaction=objects2.form_add_opportunity&company_id=#attributes.company_id#</cfoutput>"><img src="../../images/plus1.gif" align="absmiddle" title="Üyeye Fırsat Ekle" border="0" /></a>
				<a href="<cfoutput>#request.self#?fuseaction=objects2.list_opportunities_hier&company_id=#attributes.company_id#</cfoutput>"><img src="../../images/magic.gif" align="absmiddle" title="Üyenin Fırsatları" border="0" /></a>
				<a href="<cfoutput>#request.self#?fuseaction=objects2.add_service_callcenter_system&company_id=#attributes.company_id#</cfoutput>"><img src="/images/tel.gif" title="Şikayet/Talep Ekle" border="0" align="absmiddle"></a>
				<a href="javascript:list_call_center.submit();"><img src="/images/content_plus.gif" title="Şikayet/Talepler" border="0" align="absmiddle"></a>
			</cfif>
		</td>
	</tr>
	<tr>
		<td>
	    	<table border="0">
    			<cfform name="form_add_member" method="post" action="#request.self#?fuseaction=objects2.emptypopup_upd_my_member&company_id=#attributes.company_id#">  
		  		<tr>
					<td style="width:80px;"><cf_get_lang_main no='159.Ünvan'> *</td>
					<td colspan="3"><input type="text" name="fullname" id="fullname" value="<cfoutput>#get_company_.fullname#</cfoutput>" maxlength="100" style="width:420;"></td>
		  		</tr>
		  		<tr>
					<td><cf_get_lang_main no='339.Kisa Ad'> *</td>
					<td style="width:180px;"><input type="text" name="nickname" id="nickname" value="<cfoutput>#get_company_.nickname#</cfoutput>" maxlength="25" style="width:150px;"></td>
					<td><cf_get_lang_main no='74.Kategori'> *</td>
					<td>
						<select name="companycat_id" id="companycat_id" style="width:150px;" tabindex="23">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="get_companycat">
					  			<option value="#companycat_id#" <cfif companycat_id eq get_company_.companycat_id>selected</cfif>>#companycat#</option>
							</cfoutput>
				  		</select>
					 </td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='1350.Vergi Dairesi'></td>
					<td><input type="text" name="taxoffice" id="taxoffice" maxlength="30" value="<cfoutput>#get_company_.taxoffice#</cfoutput>" style="width:150px;"></td>
					<td style="width:80px;"><cf_get_lang_main no='340.Vergi No'></td>
					<td><input type="text" name="taxno" id="taxno" value="<cfoutput>#get_company_.taxno#</cfoutput>" maxlength="12" style="width:150px;"></td>
		  		</tr>
		  		<tr>
					<td><cf_get_lang_main no='167.Sektör'></td>
					<td>
						<select name="sector_cat_id" id="sector_cat_id" tabindex="25" style="width:150px;">
							<option value=""><cf_get_lang_main no='167.Sektr Seiniz'> 
							<cfoutput query="get_company_sector">
							  <option value="#sector_cat_id#" <cfif isdefined("get_company_.get_company_") and sector_cat_id eq get_company_.sector_cat_id>selected</cfif>>#sector_cat#</option>
							</cfoutput>
					  	</select>
					</td>
					<td><cf_get_lang no='535.Çalışan Sayısı'></td>
					<td>
						<select name="company_size_cat_id" id="company_size_cat_id" style="width:150px;" tabindex="26">
							<cfoutput query="get_company_size">
							  	<option value="#company_size_cat_id#" <cfif company_size_cat_id eq get_company_.company_size_cat_id>selected</cfif>>#company_size_Cat# 
							</cfoutput>
					  	</select>
					</td>
				</tr>
				<tr>
					<td></td>
					<td style="display:none;"><cf_workcube_process is_upd='0' select_value = '#get_company_.company_state#' process_cat_width='150' is_detail='1'></td>
		  		</tr>
		  		<tr style="height:30px;">
					<td class="txtboldblue" colspan="4"><cf_get_lang no='235.Adres ve İletişim'></td>
				</tr>
		  		<tr>
					<td><cf_get_lang_main no='807.Ülke'></td>
					<td>
						<select name="country" id="country" onChange="LoadCity(this.value,'city_id','county_id',0);remove_adress('1');" style="width:150px;">
			  				<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
			  				<cfoutput query="get_country">
								<option value="#get_country.country_id#" <cfif country_id eq get_company_.country>selected</cfif>>#get_country.country_name#</option>
			  				</cfoutput>
			  			</select>
					</td>
					<td><cf_get_lang_main no='1173.Kod'>/<cf_get_lang_main no='87.Telefon'></td>
					<td>
						<input type="text" name="telcod" id="telcod" maxlength="5" onKeyUp="isNumber(this);" value="<cfoutput>#get_company_.company_telcode#</cfoutput>" style="width:55px;">
			    		<input type="text" name="tel1" id="tel1" maxlength="10" onKeyUp="isNumber(this);" value="<cfoutput>#get_company_.company_tel1#</cfoutput>" style="width:90px;">
					</td>
		  		</tr>
		  		<tr>
					<td><cf_get_lang_main no='559.Şehir'></td>
					<td>
						<select name="city_id" id="city_id" style="width:150px;" onchange="LoadCounty(this.value,'county_id','telcod')">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfquery name="GET_CITY" datasource="#DSN#">
								SELECT CITY_ID,CITY_NAME FROM SETUP_CITY <cfif len(get_company_.country)>WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company_.country#"></cfif>
							</cfquery>
							<cfoutput query="get_city">
								<option value="#city_id#" <cfif get_company_.city eq city_id>selected</cfif>>#city_name#</option>
							</cfoutput>
						</select>
					</td>
					<td><cf_get_lang_main no='87.Telefon'> 2</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="text" name="tel2" id="tel2" onKeyUp="isNumber(this);" maxlength="10" value="<cfoutput>#get_company_.company_tel2#</cfoutput>" style="width:90px;" />
					</td>
		  		</tr>
		  		<tr>
					<td><cf_get_lang_main no='1226.İlçe'></td>
					<td>
						<select name="county_id" id="county_id" style="width:150px;">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfquery name="GET_COUNTY" datasource="#DSN#">
								SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY <cfif len(get_company_.city)>WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company_.city#"></cfif>
							</cfquery>
							<cfoutput query="get_county">
								<option value="#county_id#" <cfif get_company_.county eq county_id>selected</cfif>>#county_name#</option>
							</cfoutput>
						</select>
					</td>
					<td><cf_get_lang_main no='87.Telefon'> 3</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="text" name="tel3" id="tel3" maxlength="10" onKeyUp="isNumber(this);" value="<cfoutput>#get_company_.company_tel3#</cfoutput>" style="width:90px;">
					</td>
				</tr>
		  		<tr>
					<td><cf_get_lang_main no='720.Semt'></td>
					<td><input type="text" name="semt" id="semt" value="<cfoutput>#get_company_.semt#</cfoutput>" maxlength="30" style="width:150px;"></td>
					<td><cf_get_lang_main no='76.Fax'></td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="text" name="fax" id="fax" onKeyUp="isNumber(this);" value="<cfoutput>#get_company_.company_fax#</cfoutput>" maxlength="10" style="width:90px;">
					</td>
		  		</tr>
		  		<tr>
					<td><cf_get_lang_main no='60.Posta Kodu'></td>
					<td><input type="text" name="postcod" id="postcod" value="<cfoutput>#get_company_.company_postcode#</cfoutput>" maxlength="5" style="width:150px;"></td>
					<td><cf_get_lang_main no='16.e-mail'></td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang_main no='1072.Lütfen Geçerli Bir E-mail Adresi Giriniz'></cfsavecontent>
						<cfinput type="text" name="email" id="email" validate="email" message="#message#" maxlength="50" style="width:150px;" value="#get_company_.company_email#">
					</td>
		  		</tr>
		  		<tr>
					<td style="vertical-align:top"><cf_get_lang_main no='1311.Adres'></td>
					<td><textarea name="adres" id="adres" style="width:150px; height:65px;" tabindex="15" maxlength="200"><cfoutput>#get_company_.company_address#</cfoutput></textarea></td>
					<td style="vertical-align:top"><cf_get_lang_main no='667.İnternet'></td>
					<td style="vertical-align:top"><input type="text" name="homepage" id="homepage" value="<cfoutput>#get_company_.homepage#</cfoutput>" style="width:150px;" maxlength="50"></td>
		  		</tr>	
				<tr>
					<td colspan="8">
						<cfoutput>
						<cf_get_lang_main no='71.Kayıt'> :
						<cfif len(get_company_.record_par)>
							#get_par_info(get_company_.record_par,0,-1,0)#
						<cfelseif len(get_company_.record_emp)>
							#get_emp_info(get_company_.record_emp,0,0)#
						</cfif>
						<cfif len(get_company_.record_date)> - #dateformat(date_add('h',session.pp.time_zone,get_company_.record_date),'dd/mm/yyyy')# #timeformat(date_add('h',session.pp.time_zone,get_company_.record_date),'HH:MM')#</cfif>&nbsp;
						<cfif len(get_company_.update_emp) or len(get_company_.update_par)>
							<br/><cf_get_lang_main no='291.Son Güncelleme'> : 
							<cfif len(get_company_.update_emp)>
								#get_emp_info(get_company_.update_emp,0,0)#
							<cfelseif len(get_company_.update_par)>
								#get_par_info(get_company_.update_par,0,-1,0)#
							</cfif> - #dateformat(date_add('h',session.pp.time_zone,get_company_.update_date),'dd/mm/yyyy')# #timeformat(date_add('h',session.pp.time_zone,get_company_.update_date),'HH:MM')#
						</cfif>
						</cfoutput>
					</td>
				</tr>	
		  		<tr>
					<td colspan="8" style="text-align:right;"><cf_workcube_buttons is_upd='1' is_delete='0' add_function="kontrol()"></td>
		  		</tr>
    		</table>
    	</td>
	</tr>
</table>
<!--- şirket çalışanları --->
<cfquery name="GET_PARTNER" datasource="#DSN#">
	SELECT 
		PARTNER_ID,
		TITLE,
		COMPANY_PARTNER_EMAIL,
		COMPANY_PARTNER_TEL,
		IM,
		COMPANY_PARTNER_FAX,
		COMPANY_PARTNER_NAME,
		COMPANY_PARTNER_SURNAME
	FROM 
		COMPANY_PARTNER 
	WHERE 
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
</cfquery>
<cfset list_partner=ValueList(get_partner.partner_id,',')>
<table cellspacing="2" cellpadding="1" border="0" align="center" style="width:100%">
	<tr style="height:30px;">
		<td class="txtboldblue" colspan="3"><cf_get_lang_main no='1463.Şirket Çalışanları'></td>
	</tr>
	<tr class="color-header" style="height:22px;">
		<td style="width:21px;">&nbsp;</td>
		<td class="form-title"><cf_get_lang_main no='158.Ad Soyad'></td>
		<td class="form-title"><cf_get_lang_main no='159.Ünvan'></td>
		<td class="form-title" style="width:100px;"><cf_get_lang_main no='731.İletişim'></td>
		<td style="width:20px;"><a href="<cfoutput>#request.self#?fuseaction=objects2.form_add_partner&company_id=#attributes.company_id#</cfoutput>"><img src="/images/plus_square.gif" title="<cf_get_lang_main no='170.Ekle'>" border="0"></a></td>
	</tr>
	<cfif get_partner.recordcount>
		<cfoutput query="get_partner">
			<tr class="color-row">
				<td class="color-row" style="width:21px;"><cf_online id="#partner_id#" zone="pp"></td>
				<td class="color-row"><a href="#request.self#?fuseaction=objects2.upd_my_partner&partner_id=#partner_id#&comp_id=#attributes.company_id#" class="tableyazi">#company_partner_name# #company_partner_surname#</a></td>
				<td class="color-row">#title#</td>
				<td class="color-row">
					<cfif len(company_partner_email)>
						<a href="mailto:#company_partner_email#"><img src="/images/mail.gif" width="18" height="21" title="E-mail:#company_partner_email#" border="0"></a>
					</cfif>
					<cfif len(company_partner_tel)>&nbsp;<img src="/images/tel.gif" width="17" height="21" title="Tel:#company_partner_tel#" border="0"></cfif>
					<cfif len(company_partner_fax)>&nbsp;<img src="/images/fax.gif" width="22" height="21" title="Fax:#company_partner_fax#" border="0"></cfif>
				</td>
				<td></td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr class="color-row" style="height:20px;">
			<td colspan="4"><cf_get_lang_main no='72.Kayıt Bulunamadı'>! </td>
		</tr>
	</cfif>
</table>
</cfform>
<script type="text/javascript">
	function remove_adress(parametre)
	{
		if(parametre==1)
		{
			document.getElementById('city_id').value = '';
			document.getElementById('county_id').value = '';
			document.getElementById('telcod').value = '';
		}
		else
		{
			document.getElementById('county_id').value = '';
		}	
	}
	function kontrol()
	{
		if(document.getElementById('fullname').value == "")
		{
			alert("<cf_get_lang no='498.Lütfen Ünvan Giriniz'> !");
			document.getElementById('fullname').focus();
			return false;
		}
		x = document.form_add_member.companycat_id.selectedIndex;
		if (document.form_add_member.companycat_id[x].value == "")
		{ 
			alert ("<cf_get_lang no='500.Sirket Kategorisi Seçmediniz'> !");
			document.getElementById('companycat_id').focus();
			return false;
		}
		if(document.getElementById('nickname').value == "")
		{
			alert("<cf_get_lang no='501.Lütfen Kisa Ad Giriniz'> !");
			document.getElementById('nickname').focus();
			return false;
		}
		var numberformat = "1234567890";

		for (var i = 1; i < document.getElementById('telcod').value.length; i++)
		{
			check_tel_code_number = numberformat.indexOf(document.getElementById('telcod').value.charAt(i));
			if (check_tel_code_number < 0)
			{
				alert("<cf_get_lang no='502.Telefon Kodu Sayisal Olmalidir'> !");
				document.getElementById('telcod').focus();
				return false;
			}
		}
		for (var i = 1; i < document.getElementById('tel1').value.length; i++)
		{
			tel_code_number = numberformat.indexOf(document.getElementById('tel1').value.charAt(i));
			if (tel_code_number < 0)
			{
				alert("<cf_get_lang no='503.Telefon No Sayisal Olmalidir'> !");
				document.getElementById('tel1').focus();
				return false;
			}
		}
		for (var i = 1; i < document.getElementById('tel2').value.length; i++)
		{
			tel_code_number2 = numberformat.indexOf(document.getElementById('tel2').value.charAt(i));
			if (tel_code_number2 < 0)
			{
				alert("<cf_get_lang no='503.Telefon No Sayisal Olmalidir'> 2!");
				document.getElementById('tel2').focus();
				return false;
			}
		}
		for (var i = 1; i < document.getElementById('tel3').value.length; i++)
		{
			tel_code_number3 = numberformat.indexOf(document.getElementById('tel3').value.charAt(i));
			if (tel_code_number3 < 0)
			{
				alert("<cf_get_lang no='503.Telefon No Sayisal Olmalidir'> 3!");
				document.getElementById('tel3').focus();
				return false;
			}
		}
		for (var i = 1; i < document.getElementById('taxno').value.length; i++)
		{
			vno_number = numberformat.indexOf(document.getElementById('taxno').value.charAt(i));
			if (vno_number < 0)
			{
				alert("<cf_get_lang no='504.Vergi No Sayisal Olmalidir'> !");
				document.getElementById('taxno').focus();
				return false;
			}
		}
		for (var i = 1; i < document.getElementById('fax').value.length; i++)
		{
			fax_number = numberformat.indexOf(document.getElementById('fax').value.charAt(i));
			if (fax_number < 0)
			{
				alert("<cf_get_lang no='505.Fax Numarasi Sayisal Olmalidir'> !");
				document.getElementById('fax').focus();
				return false;
			}
		}
		t = (200 - document.getElementById('adres').value.length);
		if ( t < 0 )
		{ 
			alert ("<cf_get_lang_main no='1311.Adres'><cf_get_lang_main no='798.Alanindaki Fazla Karakter Sayisi'> "+((-1) * t));
			return false;
		}
		<cfif isdefined("attributes.type")>
		if(document.getElementById('vd').value == "")
		{
			alert("<cf_get_lang no='507.Lütfen Vergi Dairesi Giriniz2'> !");
			return false;
		}
		if(document.getElementById('vno').value == "")
		{
			alert("<cf_get_lang no='508.Lütfen Vergi No Giriniz'> !");
			return false;
		}
		if(document.getElementById('telcod').value == "")
		{
			alert("<cf_get_lang no='21.Lütfen Telefon Kodu Giriniz'>!");
			return false;
		}
		if(document.getElementById('tel1').value == "")
		{
			alert("<cf_get_lang no ='22.Lütfen Telefon Numarası Giriniz'>'>!");
			return false;
		}
		x = document.form_add_member.country.selectedIndex;
		if (document.form_add_member.country[x].value == "")
		{ 
			alert ("<cf_get_lang no='509.Lütfen Ülke Seçiniz'>");
			return false;
		}
		if(document.getElementById('city_id').value == "")
		{
			alert("<cf_get_lang no='32.Il Seçiniz'>");
			return false;
		}
		if(document.getElementById('county_id').value == "")
		{
			alert("<cf_get_lang no='1357.Lutfen Ilce Seciniz'>");
			return false;
		}
		if(document.getElementById('semt').value == "")
		{
			alert("<cf_get_lang no='511.Lütfen Semt Giriniz'>");
			return false;
		}
		if(document.getElementById('title').value == "")
		{
	
			alert("<cf_get_lang no='498.Lütfen Ünvan Giriniz'>");
			return false;
		}
		</cfif>
		if(process_cat_control())
				if(confirm("<cf_get_lang no='512.Girdiğiniz bilgileri kaydetmek üzeresiniz lütfen değişiklikleri onaylayın'>!")) return true; else return false;
			else
				return false;
	}
	document.getElementById('fullname').focus();
</script>
