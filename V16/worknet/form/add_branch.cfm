<cf_get_lang_set module_name="member"><!--- sayfanin en altinda kapanisi var --->
<cfset cmp = createObject("component","V16.worknet.query.worknet_member") />
<cfset getCompany = cmp.getCompany(company_id:attributes.cpid) />
<cfset getPartner = cmp.getPartner(company_id:attributes.cpid) />
<!---<cfset getMobilcat = cmp.getMobilcat() />--->
<cfset getCountry = cmp.getCountry() />

<table border="0" width="98%" class="headbold" cellpadding="0" cellspacing="0" align="center">
<cfform name="add_company_branch" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_branch">
<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#getCompany.company_id#</cfoutput>">
  <cfif not isdefined('session.pp')>
  <tr>
	<td height="35"><cf_get_lang no='53.Şube Ekle'>: <cfoutput>#getCompany.fullname#</cfoutput></td>
  </tr>
  </cfif>
</table>
<table width="98%" align="center" cellpadding="2" cellspacing="1" border="0">
	<tr>
		<td> 
		<cf_box id="upd_branch" closable="0" collapsable="0">
			<table>
				<tr>
					<td><cf_get_lang_main no='81.Aktif'></td>
					<td><input type="checkbox" name="compbranch_status" id="compbranch_status" value="1" checked="checked"></td>
				</tr>	
				<tr> 
					<td><cf_get_lang_main no='1735.Şube Adı'> *</td>
					<td colspan="3"><cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1735.Şube adı !'></cfsavecontent>
					  <cfinput type="text" name="compbranch__name" id="compbranch__name" maxlength="50" required="yes" message="#message#" style="width:430px;">
					</td>
				</tr>
				<tr> 
					<td style="width:auto;"><cf_get_lang no='36.Kod/ Telefon'> *</td>
					<td width="185">
					  <cfsavecontent variable="message"><cf_get_lang no='178.Geçerli Bir Telefon Kodu Giriniz !'></cfsavecontent>
					  <cfinput type="text" name="compbranch_telcode" id="compbranch_telcode" required="yes" maxlength="5" message="#message#" style="width:55px;">
					  <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='87.Telefon '></cfsavecontent> 
					  <cfinput type="text" name="compbranch_tel1" id="compbranch_tel1" maxlength="10" required="yes" message="#message#" style="width:90px;"> 
					</td>
					<td width="80"><cf_get_lang_main no='1714.Yönetici'></td>
					<td>
					  <select name="manager" id="manager" style="width:160px;">
					 	 <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
						<cfoutput query="getPartner"> 
						  <option value="#partner_id#">#company_partner_name# #company_partner_surname#</option>
						</cfoutput> 
					  </select>
					</td>
				</tr>
				<tr> 
					<td><cf_get_lang_main no='87.Telefon'> 2</td>
					<td><input type="text" name="compbranch_tel2" id="compbranch_tel2" maxlength="10" style="width:97px;"></td>
					<td><cf_get_lang_main no='807.Ülke'></td>
					<td>		
						<select name="country" id="country" style="width:160px;" onchange="LoadCity(this.value,'city_id','county_id',0)"> 
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="getCountry">
							  <option value="#country_id#" <cfif is_default eq 1> selected</cfif>>#country_name#</option>
							</cfoutput>
						  </select>
					</td>
 				</tr>
				<tr> 
					<td><cf_get_lang_main no='87.Telefon'> 3</td>
					<td><input type="text" name="compbranch_tel3" id="compbranch_tel3" value="" maxlength="10" style="width:97px;"></td>
					<td><cf_get_lang_main no='559.Şehir'></td>
					<td><select name="city_id" id="city_id" style="width:160px;" onChange="LoadCounty(this.value,'county_id','compbranch_telcode')">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
						</select>
					</td>
				</tr>
				<tr> 
					<td><cf_get_lang_main no='76.Fax'></td>
					<td><input type="text" name="compbranch_fax" id="compbranch_fax" maxlength="10" style="width:97px;"></td>
					<td><cf_get_lang_main no='1226.ilçe'></td>
                    <td><select name="county_id" id="county_id" style="width:160px;">
                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>						
                        </select>
					</td>
				</tr>
				<tr> 
					<td><cf_get_lang no='116.Kod / Mobil'></td>
					<td>
						<!---<select name="mobilcat_id" id="mobilcat_id" style="width:60px;">
                            <option value=""><cf_get_lang_main no='1173.Kod'></option>
                            <cfoutput query="getMobilCat">
                                <option value="#mobilcat#" <cfif getCompany.mobil_code eq mobilcat>selected</cfif>>#mobilcat#</option>
                            </cfoutput>
						</select>--->
                        <input maxlength="5" type="text" name="mobilcat_id" id="mobilcat_id" onKeyup="isNumber(this);" onblur="isNumber(this);" value="" style="width:60px;">
						<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='116.Kod/ Mobil tel'></cfsavecontent>
						<cfinput type="text" name="mobiltel" id="mobiltel" value="#getCompany.mobiltel#" maxlength="10" validate="integer" message="#message#" tabindex="2" style="width:97px;">
					</td>
					<td><cf_get_lang_main no='720.Semt'></td>
					<td><input type="text" name="semt" id="semt" value="" maxlength="50" style="width:160px;"></td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='16.E-mail'></td>
					<td><cfsavecontent variable="mesaj"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='16.E-mail'></cfsavecontent>
						<cfinput type="text" name="compbranch_email" id="compbranch_email" maxlength="100" validate="email" message="#mesaj#" style="width:160px;"></td>
 					<td><cf_get_lang_main no='60.Posta Kodu'></td>
					<td><input type="text" name="compbranch_postcode" id="compbranch_postcode" maxlength="5" style="width:160px;"></td>
 				</tr>
				<tr> 
					<td><cf_get_lang no='41.İnternet'></td>
					<td class="formbold"><input type="text" name="homepage" id="homepage" value="" maxlength="50" style="width:160px;"></td>
					<td><cf_get_lang_main no='1137.Koordinatlar'></td><!---koordinat--->
					<td colspan="2">
						<cf_get_lang_main no='1141.E'><cfinput type="text" maxlength="10" name="coordinate_1" id="coordinate_1" range="-90,90" message="Lütfen enlem değerini -90 ile 90 arasında giriniz!" value="" style="width:59px;"> 
						<cf_get_lang_main no='1179.B'><cfinput type="text" maxlength="10" name="coordinate_2" id="coordinate_2" range="-180,180" message="Lütfen boylam değerini -180 ile 180 arasında giriniz!" value="" style="width:59px;">
					</td>
				</tr>
				<tr>
					<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
					<td  valign="top"><textarea name="compbranch__nickname" id="compbranch__nickname" style="width:160px;height:70px;"></textarea></td>
					<td valign="top"><cf_get_lang_main no='1311.Adres'></td>
					<td valign="top"><textarea name="compbranch_address" id="compbranch_address" style="width:160px;height:70px;"></textarea></td>
				</tr>
				<tr>
					<td colspan="3"></td>
					<td><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
				</tr>
			</table>
		</cf_box>
		</td>
	</tr>
</table>
</cfform>
<script type="text/javascript">
var country_ = document.getElementById('country').value;
if(country_.length)
	LoadCity(country_,'city_id','county_id',0);
		
function remove_adress(parametre)
{
	if(parametre==1)
	{
		document.getElementById('city_id').value = '';
		document.getElementById('city').value = '';
		document.getElementById('county_id').value = '';
		document.getElementById('county').value = '';
		document.getElementById('compbranch_telcode').value = '';
	}
	else
	{
		document.getElementById('county_id').value = '';
		document.getElementById('county').value = '';
	}	
}

function kontrol()
{
	x = (100 - document.getElementById('compbranch_address').value.length);
	if ( x < 0 )
	{ 
		alert ("<cf_get_lang_main no='1311.Adres'><cf_get_lang_main no='798.Alanindaki Fazla Karakter Sayisi'>"+ ((-1) * x));
		return false;
	}
	
	y = (50 - document.getElementById('compbranch__nickname').value.length);
	if ( y < 0 )
	{ 
		alert ("<cf_get_lang_main no ='217.Açıklama'>"+ ((-1) * y) +" <cf_get_lang_main no='1741.Karakter Uzun '>!");
		return false;
	}
	if((document.getElementById('coordinate_1').value.length != "" && document.getElementById('coordinate_2').value.length == "") || (document.getElementById('coordinate_1').value.length == "" && document.getElementById('coordinate_2').value.length != ""))
	{
		alert ("Lütfen koordinat değerlerini eksiksiz giriniz!");
		return false;
	}
	return true;
	
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
