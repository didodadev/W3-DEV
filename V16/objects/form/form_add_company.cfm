<!--- 
	Bu sayfanın aynısı Member ve Call Center modulleri altında bulunmaktadır. 
	Burada yapılan degisiklikler oralara da yansıtılmalıdır.
	BK 051026
 --->
<cfinclude template="../query/get_company_size.cfm">
<cfinclude template="../query/get_mobilcat.cfm">
<cfinclude template="../query/get_company_cat.cfm">
<cfinclude template="../query/get_company_sector.cfm">
<cfinclude template="../query/get_country.cfm">
<cfinclude template="../query/get_resource.cfm">
<cfinclude template="../query/get_partner_positions.cfm">
<cfinclude template="../query/get_partner_departments.cfm">
<cfinclude template="../query/get_periods_all.cfm">
<cfinclude template="../query/get_consumer_value.cfm">
<cfquery name="SZ" datasource="#dsn#">
	SELECT * FROM SALES_ZONES WHERE IS_ACTIVE = 1
</cfquery>
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr class="color-border">
    <td>
      <table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
        <tr class="color-list" height="35">
          <td>
            <table width="100%" cellpadding="0" cellspacing="0">
              <tr>
                <td class="headbold">&nbsp; <cf_get_lang dictionary_id='29409.Kurumsal Üye Ekle'></td>
                <cfsavecontent variable="previous_page"><cf_get_lang dictionary_id ='34196.Önceki Sayfaya Döneceksiniz. Emin misiniz?'></cfsavecontent>
				<td style="text-align:right;"><a href="#" onclick="javascript:if (confirm('<cfoutput>#previous_page#</cfoutput>')) history.go(-1); else return;"><img src="/images/back.gif" border="0" title="<cf_get_lang dictionary_id='57432.Geri'>"></a>&nbsp;</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr class="color-row">
          <td valign="top">
            <table>
              <cfform name="form_add_company" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_company">
               <input name="page_code" id="page_code" value="<cfoutput>#page_code#</cfoutput>" type="hidden">
		  <tr>
			<td width="65"><cf_get_lang dictionary_id='57487.No'></td>
			<td><input type="text" name="company_code" id="company_code" style="width:125px;" value="" maxlength="50" tabindex="1"></td>
			<td colspan="2">
			  <input type="checkbox" name="is_buyer" id="is_buyer" value="1" tabindex="2"><cf_get_lang dictionary_id='58733.Alıcı'>
			  <input type="checkbox" name="is_seller" id="is_seller" value="1" tabindex="3"><cf_get_lang dictionary_id='58873.Satıcı'>&nbsp;&nbsp;&nbsp;&nbsp;
			  <input type="checkbox" name="currency" id="currency" value="1" checked tabindex="4"><cf_get_lang dictionary_id='57493.Aktif'>
			  <input type="checkbox" name="ispotential" id="ispotential" value="1" tabindex="5"><cf_get_lang dictionary_id='57577.potansiyel'></td>
                <td><cf_get_lang dictionary_id="58859.Süreç">*</td>
                <td id="surec1"><cf_workcube_process is_upd='0' process_cat_width='120' is_detail='0'></td>
		  </tr>
		  <tr>
			<td><cf_get_lang dictionary_id='57571.Ünvan'> *</td>
			<td colspan="3"><input type="text" name="fullname" id="fullname"  maxlength="100" tabindex="6" style="width:370;"></td>
			<td width="110"><cf_get_lang dictionary_id='57486.Kategori'> *</td>
			<td width="180">
			  <select name="companycat_id" id="companycat_id" style="width:120px;" tabindex="23">
				<option value=""><cf_get_lang dictionary_id='33621.Kategorisi Seciniz'></option>
				<cfoutput query="get_companycat">
				  <option value="#companycat_id#">#companycat#</option>
				</cfoutput>
			  </select>
			</td>
		  </tr>
		  <tr>
			<td><cf_get_lang dictionary_id='57751.Kısa Ad'> *</td>
			<td width="185"><input type="text" name="nickname" id="nickname" maxlength="25" style="width:125px;" tabindex="7"></td>
			<td width="80"><cf_get_lang dictionary_id='57789.Özel Kod'></td>
			<td width="140"><input type="text" name="ozel_kod" id="ozel_kod" maxlength="75" style="width:120px;" tabindex="8"></td>
			<td><cf_get_lang dictionary_id='33622.İliski Bas'>.</td>
			<td>
			  <select name="resource" id="resource" style="width:120px;" tabindex="24">
				<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
				<cfoutput query="get_resource">
				  <option value="#resource_id#">#resource#</option>
				</cfoutput>
			  </select>
			</td>
		  </tr>
		  <tr>
			<td><cf_get_lang dictionary_id='58762.Vergi Dairesi'></td>
			<td><input type="text" name="vd" id="vd" maxlength="30" tabindex="9" style="width:125px;"></td>
			<td><cf_get_lang dictionary_id='57752.Vergi No'></td>
			<td><input type="text" name="vno" id="vno" maxlength="12" tabindex="10" style="width:120px;"></td>
			<td><cf_get_lang dictionary_id='57579.Sektör'></td>
			<td>
              <select name="company_sector" id="company_sector" tabindex="25" style="width:120px;">
                <option value=""><cf_get_lang dictionary_id='51253.Sektör Seçiniz'>               
                <cfoutput query="get_company_sector">
                  <option value="#sector_cat_id#">#sector_cat#</option>
                </cfoutput>
              </select>
			</td>
		  </tr>
		  <tr>
		  	<td colspan="4"></td>
			<td><cf_get_lang dictionary_id='58552.Müşteri Değeri'></td>
			<td>
			  <select name="customer_value" id="customer_value" style="width:120px;">
			  <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
			  <cfoutput query="get_customer_value">
				<option value="#customer_value_id#">#customer_value#</option>
			  </cfoutput>
			  </select>
			</td>
		  </tr>
		  <tr>
			<td class="txtboldblue" colspan="4" height="30"><cf_get_lang dictionary_id='33609.Adres ve Iletisim'></td>
			<td><cf_get_lang dictionary_id='57580.Buyukluk'></td>
			<td>
			  <select name="company_size_cat_id" id="company_size_cat_id" style="width:120px;" tabindex="26">
				<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
				<cfoutput query="get_company_size">
				  <option value="#company_size_cat_id#">#company_size_Cat# 
				</cfoutput>
			  </select>
			</td>
		  </tr>
		  <tr>
			<td><cf_get_lang dictionary_id='58219.Ülke'></td>
			<td>
			  <select name="country" id="country" onchange="remove_adress('1');" style="width:125px;">
			  <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
			  <cfoutput query="get_country">
				<option value="#get_country.country_id#" <cfif is_default eq 1>selected</cfif>>#get_country.country_name#</option>
			  </cfoutput>
			  </select>
			</td>
			<td><cf_get_lang dictionary_id='32851.Kod/Telefon'></td>
			<td width="120"><input maxlength="5" type="text" name="telcod" id="telcod" style="width:45px;" tabindex="16">
			  <input maxlength="20" type="text" name="tel1" id="tel1" style="width:70px;" tabindex="17">
			</td>
			<td><cf_get_lang dictionary_id='57659.Satis Bölgesi'></td>
			<td><select name="sales_county" id="sales_county" style="width:120px;" tabindex="27">
				<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
				<cfoutput query="sz">
				  <option value="#sz_id#">#sz_name#</option>
				</cfoutput>
			  </select>
			</td>
		  </tr>
		  <tr>
			<td><cf_get_lang dictionary_id='57971.Şehir'></td>
			<td><input type="hidden" name="city_id" id="city_id" value="">          
			  <input type="text" name="city" id="city" value="" readonly style="width:125px;">
			  <a href="javascript://" onclick="pencere_ac_city();"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
			</td>
			<td><cf_get_lang dictionary_id='57499.Telefon'> 2</td>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			  <input validate="integer" maxlength="20" type="text" name="tel2" id="tel2" style="width:70px;" tabindex="18"></td>
			<td>M.<cf_get_lang dictionary_id='33624.Bölge Kodu'></td>
			<td><input type="hidden" name="ims_code_id" id="ims_code_id">
			  <input type="text" name="ims_code_name" id="ims_code_name" style="width:120px;" readonly="yes;" tabindex="28">
			  <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=form_add_company.ims_code_name&field_id=form_add_company.ims_code_id&select_list=1','list');return false"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></td>
		  </tr>
		  <tr>
			<td><cf_get_lang dictionary_id='58638.İlçe'></td>
			<td><input type="hidden" name="county_id" id="county_id" readonly="">
			  <input type="text" name="county" id="county" value="" maxlength="30" style="width:125px;" readonly tabindex="12">
			  <a href="javascript://" onclick="pencere_ac();"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></td>
			<td><cf_get_lang dictionary_id='57499.Telefon'> 3</td>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			  <input maxlength="20" type="text" name="tel3" id="tel3" style="width:70px;" tabindex="19"></td>
			<td><cf_get_lang dictionary_id='57908.Temsilci'></td>
			<td><input type="hidden" name="pos_code" id="pos_code" value="">
			  <input readonly type="text" name="pos_code_text" id="pos_code_text" style="width:120px;" tabindex="29">
			  <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=form_add_company.pos_code&field_name=form_add_company.pos_code_text&select_list=1','list');return false"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></td>
		  </tr>
		  <tr>
			<td><cf_get_lang dictionary_id='58132.Semt'></td>
			<td><input type="text" name="semt" id="semt" value="" maxlength="30" style="width:125px;" tabindex="13"></td>
			<td><cf_get_lang dictionary_id='57488.Fax'></td>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			  <input maxlength="10" type="text" name="fax" id="fax" style="width:70px;" tabindex="20"></td>
			<td><cf_get_lang no='92.Üst Şirket'></td>
			<td><input type="hidden" name="hierarchy_id" id="hierarchy_id" value="">
			  <input type="text" name="hierarchy_company" id="hierarchy_company" readonly style="width:120px;">
			  <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=form_add_company.hierarchy_id&field_comp_name=form_add_company.hierarchy_company&select_list=2','list');return false"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></td>
		  </tr>
		  <tr>
			<td>P.<cf_get_lang dictionary_id='32646.Kodu'></td>
			<td><input type="text" name="postcod" id="postcod" maxlength="5" style="width:125px;" tabindex="14"></td>
			<td><cf_get_lang dictionary_id='57428.e-mail'></td>
			<cfsavecontent variable="mail_address"><cf_get_lang dictionary_id='58484.Lütfen Geçerli Bir E-mail Adresi Giriniz'></cfsavecontent>
			<td><cfinput type="text" name="email" validate="email" message="#mail_address#" maxlength="50" style="width:120px;" tabindex="21"></td>
			<td><cf_get_lang dictionary_id='33625.Üyelik Bas Tar'></td>
			<td><input type="text" name="startdate" id="startdate" style="width:120px;" tabindex="28">
			  <cf_wrk_date_image date_field="startdate"></td>
		  </tr>
		  <tr>
			<td rowspan="3" valign="top"><cf_get_lang dictionary_id='58723.Adres'></td>
			<td rowspan="3"><textarea name="adres" id="adres" style="width:125px; height:65px;" tabindex="15"></textarea></td>
			<td valign="top"><cf_get_lang dictionary_id='32481.Internet'></td>
			<td valign="top"><input type="text" name="homepage" id="homepage" style="width:120px;" maxlength="50" value="http://" tabindex="22"></td>
			<td><cf_get_lang dictionary_id='33610.Kuruluş Tarihi'></td>
			<td><input type="text" name="organization_start_date" id="organization_start_date" style="width:120px;" tabindex="28">
			  <cf_wrk_date_image date_field="organization_start_date"></td>
		  </tr>
		  <tr>
			<td colspan="2"></td>
			<td><cf_get_lang dictionary_id='33626.Ön Katsayisi'> (%)</td>
			<td><input type="text" name="company_rate" id="company_rate" value="" maxlength="3" range="0,100" style="width:120px;" tabindex="29"></td>
		  </tr>
		  <tr>
			<td colspan="2"></td>
			<td><cf_get_lang dictionary_id='33627.Şirketimiz'></td>
			<td><input type="hidden" name="our_company_id" id="our_company_id" value="">
			  <input type="text" name="our_company_name" id="our_company_name" style="width:120px;" tabindex="30">
			  <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_our_companies&field_id=form_add_company.our_company_id&field_name=form_add_company.our_company_name','list');return false"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></td>
		  </tr>
		  <tr>
			<td class="txtboldblue" colspan="4"><cf_get_lang dictionary_id='57578.Yetkili'></td>
			<td><cf_get_lang dictionary_id='33628.Muh Dönemi'></td>
			<td>
			  <select name="period_id" id="period_id" style="width:120px;" tabindex="31">
				<cfoutput query="periods">
				  <option value="#period_id#" <cfif session.ep.period_id eq period_id>selected</cfif>>#nick_name# - #period#</option>
				</cfoutput>
			  </select>
			</td>
			
		  </tr>
		  <tr>
			<td><cf_get_lang dictionary_id='57631.Ad'> *</td>
			<td><input type="text" name="name" id="name" maxlength="50" style="width:125px;" tabindex="32"></td>
			<td><cf_get_lang dictionary_id='58726.Soyad'> *</td>
			<td><input type="text" name="soyad" id="soyad" maxlength="50" style="width:120px;" tabindex="33"></td>
			<td><cf_get_lang dictionary_id='33629.Kod/Mobil Tel'></td>
			<td>
			  <select name="mobilcat_id" id="mobilcat_id" style="width:45px;" tabindex="38">
				<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
				<cfoutput query="get_mobilcat">
				  <option value="#mobilcat#">#mobilcat#</option>
				</cfoutput>
			  </select>
			  <input maxlength="10" type="text" name="mobiltel" id="mobiltel" value="" style="width:70px;" tabindex="38">
			</td>
		  </tr>
		  <tr>
			<td><cf_get_lang dictionary_id='57571.Ünvan'></td>
			<td><input  type="text" name="title" id="title" style="width:125px;" maxlength="50" tabindex="34"></td>
			<td><cf_get_lang dictionary_id='57764.Cinsiyet'></td>
			<td>
			  <select name="sex" id="sex" style="width:120px;" tabindex="35">
				<option value="1"><cf_get_lang dictionary_id='58959.Erkek'></option>
				<option value="2"><cf_get_lang dictionary_id='58958.Kadın'></option>
			  </select>
			</td>
			<td><cf_get_lang dictionary_id='32894.Dahili Telefon'></td>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			  <input type="text" name="tel_local" id="tel_local" maxlength="5" style="width:70px;" tabindex="39">
			</td>
		  </tr>
		  <tr>
			<td><cf_get_lang dictionary_id='57573.Görev/Pozisyon'></td>
			<td>
			  <select name="mission" id="mission" style="width:125px;" tabindex="36">
				<option value=""><cf_get_lang dictionary_id='57573.Görev/Pozisyon'></option>
				<cfoutput query="get_partner_positions">
				  <option value="#partner_position_id#">#partner_position#</option>
				</cfoutput>
			  </select>
			</td>
			<td><cf_get_lang dictionary_id='57572.Departman'></td>
			<td>
			  <select name="department" id="department" style="width:120px;" tabindex="37">
				<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
				<cfoutput query="get_partner_departments">
				  <option value="#partner_department_id#">#partner_department#</option>
				</cfoutput>
			  </select>
			</td>
			<td><cf_get_lang dictionary_id='57428.e-mail'></td>
			<cfsavecontent variable="mail_address"><cf_get_lang dictionary_id='58484.Lütfen Geçerli Bir E-mail Adresi Giriniz'></cfsavecontent>
			<td><cfinput  type="text" name="company_partner_email" validate="email" message="#mail_address#" maxlength="50" style="width:120px;" tabindex="40"></td>
		  </tr>
		  <tr>
			<td colspan="5" height="30">&nbsp;</td>
			<td><cf_workcube_buttons is_upd='0' add_function="kontrol()"></td>
		  </tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<script type="text/javascript">
function pencere_ac(no)
{
	x = document.form_add_company.country.selectedIndex;
	if (document.form_add_company.country[x].value == "")
	{
		alert("<cf_get_lang dictionary_id='33069.İlk Olarak Ülke Seçiniz'>.");
	}	
	else if(document.form_add_company.city_id.value == "")
	{
		alert("<cf_get_lang dictionary_id='33176.İl Seçiniz'> !");
	}
	else
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=form_add_company.county_id&field_name=form_add_company.county&city_id=' + document.form_add_company.city_id.value,'small');
		return remove_adress();
	}
}
function remove_adress(parametre)
{
	if(parametre==1)
	{
		document.form_add_company.city_id.value = '';
		document.form_add_company.city.value = '';
		document.form_add_company.county_id.value = '';
		document.form_add_company.county.value = '';
		document.form_add_company.telcod.value = '';
	}
	else
	{
		document.form_add_company.county_id.value = '';
		document.form_add_company.county.value = '';
	}	
}

function pencere_ac_city()
{
	x = document.form_add_company.country.selectedIndex;
	if (document.form_add_company.country[x].value == "")
	{
		alert("<cf_get_lang dictionary_id='33069.İlk Olarak Ülke Seçiniz'>.");
	}	
	else
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=form_add_company.city_id&field_name=form_add_company.city&field_phone_code=form_add_company.telcod&country_id=' + document.form_add_company.country.value,'small');
	}
	return remove_adress('2');
}
function kontrol()
{
	if(document.form_add_company.fullname.value == "")
	{
		alert("<cf_get_lang dictionary_id='33630.Lütfen Ünvan Giriniz'> !");
		form_add_company.fullname.focus();
		return false;
	}
	x = document.form_add_company.companycat_id.selectedIndex;
	if (document.form_add_company.companycat_id[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='33631.Şirket Kategorisi Seçmediniz'> ! ");
		form_add_company.companycat_id.focus();
		return false;
	}
	if(document.form_add_company.nickname.value == "")
	{
		alert("<cf_get_lang dictionary_id='33632.Lütfen Kısa Ad Giriniz'> !");
		form_add_company.nickname.focus();
		return false;
	}
	var numberformat = "1234567890";
	for (var i = 1; i < form_add_company.telcod.value.length; i++)
	{
		check_tel_code_number = numberformat.indexOf(form_add_company.telcod.value.charAt(i));
		if (check_tel_code_number < 0)
		{
			alert("<cf_get_lang dictionary_id='33633.Telefon Kodu Sayısal Olmalıdır'> !");
			form_add_company.telcod.focus();
			return false;
		}
	}
	for (var i = 1; i < form_add_company.tel1.value.length; i++)
	{
		tel_code_number = numberformat.indexOf(form_add_company.tel1.value.charAt(i));
		if (tel_code_number < 0)
		{
			alert("<cf_get_lang dictionary_id='33634.Telefon No Sayısal Olmalıdır'> !");
			form_add_company.tel1.focus();
			return false;
		}
	}
	for (var i = 1; i < form_add_company.tel2.value.length; i++)
	{
		tel_code_number2 = numberformat.indexOf(form_add_company.tel2.value.charAt(i));
		if (tel_code_number2 < 0)
		{
			alert("2.<cf_get_lang dictionary_id ='33634.Telefon Sayisal Olmalidir'> !");
			form_add_company.tel2.focus();
			return false;
		}
	}
	for (var i = 1; i < form_add_company.tel3.value.length; i++)
	{
		tel_code_number3 = numberformat.indexOf(form_add_company.tel3.value.charAt(i));
		if (tel_code_number3 < 0)
		{
			alert("3.<cf_get_lang dictionary_id ='33634.Telefon Sayisal Olmalidir'>!");
			form_add_company.tel3.focus();
			return false;
		}
	}
	for (var i = 1; i < form_add_company.vno.value.length; i++)
	{
		vno_number = numberformat.indexOf(form_add_company.vno.value.charAt(i));
		if (vno_number < 0)
		{
			alert("<cf_get_lang dictionary_id='33635.Vergi No Sayısal Olmalıdır'> !");
			form_add_company.vno.focus();
			return false;
		}
	}
	for (var i = 1; i < form_add_company.fax.value.length; i++)
	{
		fax_number = numberformat.indexOf(form_add_company.fax.value.charAt(i));
		if (fax_number < 0)
		{
			alert("<cf_get_lang dictionary_id='33636.Fax Numarası Sayısal Olmalıdır'> !");
			form_add_company.fax.focus();
			return false;
		}
	}
	for (var i = 1; i < form_add_company.tel_local.value.length; i++)
	{
		fax_number = numberformat.indexOf(form_add_company.tel_local.value.charAt(i));
		if (fax_number < 0)
		{
			alert("<cf_get_lang dictionary_id='33638.Dahili Sayisal Olmalidir'> !");
			form_add_company.tel_local.focus();
			return false;
		}
	}
	for (var i = 1; i < form_add_company.mobiltel.value.length; i++)
	{
		mobiltel_number = numberformat.indexOf(form_add_company.mobiltel.value.charAt(i));
		if (mobiltel_number < 0)
		{
			alert("<cf_get_lang dictionary_id='33639.Dahili Mobil Telefon Olmalıdır'> !");
			form_add_company.mobiltel.focus();
			return false;
		}
	}
	for (var i = 1; i < form_add_company.company_rate.value.length; i++)
	{
		company_rate_number = numberformat.indexOf(form_add_company.company_rate.value.charAt(i));
		if (company_rate_number < 0)
		{
			alert("<cf_get_lang dictionary_id='33640.Kurumsal Üye Öncelik Kaysayisi Sayisal Olmalidir'>!");
			form_add_company.company_rate.focus();
			return false;
		}
	}
	x = (100 - document.form_add_company.adres.value.length);
	if ( x < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id='58723.Adres'><cf_get_lang dictionary_id='58210.Alanindaki Fazla Karakter Sayisi'>"+((-1) * x));
		return false;
	}
	if(document.form_add_company.name.value == "")
	{
		alert("<cf_get_lang dictionary_id='33642.Lütfen Yetkili Ad Giriniz'>");
		form_add_company.name.focus();
		return false;
	}
	if(document.form_add_company.soyad.value == "")
	{
		alert("<cf_get_lang dictionary_id='33643.Lütfen Soyad Giriniz'>");
		form_add_company.soyad.focus();
		return false;
	}
	
	if(document.form_add_company.process_stage.value == "")
	{
		alert("<cf_get_lang dictionary_id='57976.Lütfen Süreçlerinizi Tanımlayınız ve/veya Süreçler Üzerinde Yetkiniz Yok'>");
		return false;
	}
	
	if (confirm("<cf_get_lang dictionary_id='33645.Girdiğiniz Bilgileri Kaydetmek Uzeresiniz, Lütfen Yeni Şirket Kaydini Onaylayin'>"))
		return kontrol_prerecord();
	else
		return false;
}


function kontrol_prerecord()
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_company_prerecords&is_not_link=1&tax_num='+ encodeURIComponent(form_add_company.vno.value) +'fullname='+ encodeURIComponent(form_add_company.fullname.value) +'&nickname=' + encodeURIComponent(form_add_company.nickname.value) +'&name='+ encodeURIComponent(form_add_company.name.value) +'&surname='+ encodeURIComponent(form_add_company.soyad.value) +'&tel_code='+ form_add_company.telcod.value +'&telefon=' + form_add_company.tel1.value,'project');
	return false;
}
form_add_company.fullname.focus();
</script>
