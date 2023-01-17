<cfif not IsDefined("session.pp.userid")>
	<script type="text/javascript">
		alert("<cf_get_lang no ='218.Önce Üye Girişi Yapmalısınız'> !");
		window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=public.member_login';
	</script>
	<cfabort>
</cfif>
<cfinclude template="../../query/get_mobilcat.cfm">
<cfquery name="GET_CITY" datasource="#dsn#">
	SELECT CITY_ID, CITY_NAME, PHONE_CODE, COUNTRY_ID,PLATE_CODE FROM SETUP_CITY ORDER BY CITY_NAME
</cfquery>
<cfquery name="GET_COUNTRY" datasource="#DSN#">
	SELECT COUNTRY_ID, COUNTRY_NAME, IS_DEFAULT FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
</cfquery>

<cfquery name="GET_SERVICE_APPCAT" datasource="#dsn3#">
	SELECT * FROM SERVICE_APPCAT
</cfquery>
<table  border="0" cellspacing="0" cellpadding="0" align="center" width="98%">
  <tr class="color-header">
	<td>
	<table width="100%"  border="0" cellspacing="1" cellpadding="0" align="center"> 
	 <cfform name="form_add_crm" method="post" action="#request.self#?fuseaction=objects2.add_service_act_party">
	  <tr class="color-row">
		<td valign="top">
		<table align="center" width="98%">
		 <tr>
			<td class="headbold" height="25"><cf_get_lang no='569.Başvuru Ekle'></td>
		  </tr>
		  <tr>
			<td>
			<table id="musteri_ekle" style="display:none;">
				<tr>
				<td width="100"><cf_get_lang no='257.Firma Adi'></td>
				<td><input name="comp_name" id="comp_name" type="text" value="" style="width:200px;">
			  </tr>
			  <tr>
				<td><cf_get_lang_main no='158.Ad Soyad'></td>
				<td>
				  <input type="text" name="member_name" id="member_name" value="" style="width:97px;">
				  <input type="text" name="member_surname" id="member_surname" value="" style="width:100px;">
				</td>
			  </tr>
			  <tr>
				<td><cf_get_lang_main no='87.Telefon'></td>
				<td>
				<cfsavecontent variable="message"><cf_get_lang no ='21.Telefon Kodu'></cfsavecontent>
				<cfsavecontent variable="message2"><cf_get_lang no ='22.Telefon Numarası'></cfsavecontent>
				  <cfinput type="text" name="tel_code" style="width:77px;" maxlength="5" passthrough = "readonly=yes" validate="integer" message="#message#">
				  <cfinput type="text" name="tel_number" style="width:120px;" maxlength="7"  validate="integer" message="#message2#">
				</td>
			  </tr>
			  <tr>
				<td><cf_get_lang_main no='1070.Mobil'></td>
				<td>
				  <select name="mobil_code" id="mobil_code"  style="width:77px;">
				  <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
					  <cfoutput query="get_mobilcat">
						<option value="#mobilcat#">#mobilcat#</option>
					  </cfoutput>
				  </select>
				  <cfsavecontent variable="message"><cf_get_lang no ='1160.Mobil Telefon'></cfsavecontent>
				  <cfinput name="mobil_tel" maxlength="7" type="text" style="width:120px;" validate="integer"  message="#message#">
				</td>
			  </tr>
			  <tr>
				<td><cf_get_lang_main no='16.Email'></td>
			 	<td><input type="text" name="email" id="email" style="width:200px;" maxlength="50"></td>
			  </tr>
			  <tr>
				<td><cf_get_lang_main no='1311.Adres'></td>
				<td><textarea name="address" id="address" style="width:200px;height:45px;"></textarea></td>
			  </tr>
			  <tr>
				<td><cf_get_lang_main no='720.Semt'></td>
				<td><input type="text" name="semt" id="semt" value="" maxlength="30" style="width:200px;"></td>
			  </tr>
			  <tr>
				<td><cf_get_lang_main no='60.Posta Kodu'></td>
				<td><input type="text" name="postcod" id="postcod" maxlength="5" style="width:200px;"></td>
			  </tr>
			  <tr>
				<td><cf_get_lang_main no='559.İl'>-<cf_get_lang_main no='1226.İlçe'></td>
				<td nowrap>                       
				<select name="city" id="city" onChange="get_phone_code()" style="width:80px;">
					<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
					<cfoutput query="get_city">
					  <option value="#city_id#">#city_name#</option>
					</cfoutput>
				  </select>
				<input type="text" name="county" id="county" value="" maxlength="30" style="width:80px;" readonly="yes">
				<a href="javascript://" onClick="pencere_ac();"><img src="/images/plus_list.gif" title="Seçiniz"  border="0" align="absmiddle"></a>
				<input type="hidden" name="county_id" id="county_id" readonly=""></td>
			  </tr>
			  <tr>
				<td><cf_get_lang_main no='807.Ülke'></td>
				<td><select name="country" id="country" onChange="remove_adress('1');" style="width:200px;">
				  <option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
				  <cfoutput query="get_country">
					<option value="#get_country.country_id#" <cfif is_default eq 1>selected</cfif>>#get_country.country_name#</option>
				  </cfoutput>
				  </select>
				</td>
			  </tr>
			</table>
			<table id="musteri_sec">
			  <tr>
				<td width="100"><cf_get_lang_main no='45.Müşteri'></td>
				<td>
				  <input type="hidden" name="company_id" id="company_id" value="">	
				  <input type="text" name="company_name" id="company_name" value="" style="width:200px;">
				  <cfset str_linke_ait="field_partner=form_add_crm.partner_id&field_name=form_add_crm.partner_name&field_comp_id=form_add_crm.company_id&field_comp_name=form_add_crm.company_name"> 
				  <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_all_pars&#str_linke_ait#&select_list=7'</cfoutput>,'list','popup_list_all_pars');"><img src="/images/plus_list.gif" align="absmiddle" border="0"></a>
			 </tr>
			 <tr>
				<td><cf_get_lang_main no='166.Yetkili'></td>
				<td>
					<input type="hidden" name="partner_id" id="partner_id" value="">
					<input type="text" name="partner_name" id="partner_name" value="" style="width:200px;">
				</td>
			 </tr>
			</table>
			<table> 
			 <tr>
			 	<td colspan="2"><input type="checkbox" name="is_new_member" id="is_new_member" value="1" onClick="musteri_degis();"><cf_get_lang no='8.Yeni Üye Ekle'>..</td>
			 </tr>
			 <tr>
				<td width="100"><cf_get_lang_main no='74.Kategori'></td>
				<td>
				  <select name="appcat" id="appcat" style="width:200px;">
				  <cfoutput query="get_service_appcat">
					<option value="#SERVICECAT_ID#">#SERVICECAT#</option>
				  </cfoutput>
				  </select>
				</td>
			  </tr>
			  <tr>
				<td><cf_get_lang_main no='225.Seri No'> *</td>
					<cfsavecontent variable="message"><cf_get_lang no ='577.Seri No Girmelisiniz'></cfsavecontent>
				<td><cfinput type="text" name="seri_no" style="width:200px;" required="yes" message="!"></td>
			  </tr>
			  <tr>
				<td><cf_get_lang no='596.Ana Seri No'></td>
				<td><cfinput type="text" name="main_serial_no" style="width:200px;"></td>
			  </tr>
			  <tr>
				<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
				<td><textarea name="CRM_DETAIL" id="CRM_DETAIL" style="width:350px; height:75px;"></textarea></td>
			  </tr>
			<tr>
				<td width="80"></td>
				<td><cfinput type="text" name="bring_name" value="" maxlength="150" style="width:140px;"></td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='87.Telefon'></td>
				<td><cfinput type="text" name="bring_tel_no" value="" maxlength="150" style="width:140px;"></td>
			</tr>
			<tr>
				<td valign="top"><cf_get_lang no='575.Servis Adresi'></td>
				<td><textarea name="service_address" id="service_address" style="width:140px;height:70px;"></textarea></td>
			</tr>
			  <tr>
			  	<td></td>
				<td><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
			  </tr>
			</table>
				</td>
			  </tr>
			</table>
			</td>
		  </tr>
		  </cfform>
		</table>
		</td>
	  </tr>
	</table>
<br/>
<script type="text/javascript">
phone_code_list = new Array(<cfoutput>#valuelist(get_city.phone_code)#</cfoutput>);
function get_phone_code()
 {	
	if(document.form_add_crm.city.selectedIndex > 0)
	{
		document.form_add_crm.tel_code.value = phone_code_list[document.form_add_crm.city.selectedIndex-1];
	}
	else
	{
		document.form_add_crm.tel_code.value = '';
	}
}

function pencere_ac(no)
{
	if (document.form_add_crm.city[document.form_add_crm.city.selectedIndex].value == "")
		alert("<cf_get_lang no='110.İlk Olarak İl Seçiniz'>!");
	else
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=form_add_crm.county_id&field_name=form_add_crm.county&city_id=' + document.form_add_crm.city.value,'small');
}

function kontrol()
{
	if(document.form_add_crm.is_new_member.checked)
		{
		company_ = document.form_add_crm.comp_name.value;	
		partner_name_ = document.form_add_crm.member_name.value;
		partner_surname_ = document.form_add_crm.member_surname.value;
		if(company_ == "" || partner_name_ == "" || partner_surname_ == "")
			{
			alert('<cf_get_lang no="610.Üye Girmelisiniz">!');
			return false;
			}
		else
			return true;
		}
	else
		{
		company_id_ = document.form_add_crm.company_id.value;	
		company_ = document.form_add_crm.company_name.value;	
		partner_id_ = document.form_add_crm.partner_id.value;	
		partner_ = document.form_add_crm.partner_name.value;	
		if(company_id_ == "" || company_ == "" || partner_id_ == "" || partner_ == "")
			{
			alert("<cf_get_lang no ='373.Üye Seçmelisiniz'>!");
			return false;
			}
		else
			return true;
		}
}

function remove_adress(parametre)
{
	if(parametre==1)
	{
		document.form_add_crm.county_id.value = '';
		document.form_add_crm.county.value = '';
	}
	else
	{
		document.form_add_crm.county_id.value = '';
		document.form_add_crm.county.value = '';
	}	
}
function musteri_degis()
{
	if (document.form_add_crm.is_new_member.checked)
	 	{
		gizle(musteri_sec);
		goster(musteri_ekle);
		}
	else
		{
		goster(musteri_sec);
		gizle(musteri_ekle);
		}
}
</script> 
