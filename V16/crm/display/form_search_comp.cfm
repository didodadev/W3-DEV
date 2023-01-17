<cfinclude template="../query/get_zone.cfm">
<cfinclude template="../query/get_company_cat.cfm">
<cfinclude template="../query/get_company_sector.cfm">
<cfinclude template="../query/get_company_size.cfm">
<cfquery name="get_resource" datasource="#dsn#">
SELECT * FROM COMPANY_PARTNER_RESOURCE
</cfquery>
<cfquery name="SZ" datasource="#dsn#">
	SELECT * FROM SALES_ZONES
</cfquery>
<table cellspacing="1" cellpadding="2" border="0" align="center" width="100%">
    <tr class="color-row">
        <td valign="top">
            <table border="0">
            <cfform name="form_add_company" method="post" action="#request.self#?fuseaction=crm.add_company">
                <tr>
                    <!---<td colspan="2">
                    <input type="checkbox" name="is_buyer" value="1">Alıcı
                    <input type="checkbox" name="is_seller" value="1">Satıcı</td>
                    <td colspan="3">
                    <input type="checkbox" name="currency" value="1" checked><cf_get_lang_main no='81.Aktif'>
                    <input type="checkbox" name="ispotential" value="1"><cf_get_lang_main no='165.Potansiyel'></td>
                    --->         
                    <td><cf_get_lang no='35.Müşteri Tipi'></td>
                    <td colspan="3">
                        <cfoutput query="get_companycat">
                        #companycat#<input type="checkbox" name="company_cat#currentrow#" id="company_cat#currentrow#"></cfoutput>
                    </td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td><cf_get_lang_main no='338.İşyeri Adı'></td>
                    <td colspan="3">
                        <cfsavecontent variable="message"><cf_get_lang no='171.Ünvan Girmelisiniz !'></cfsavecontent>
                        <cfinput required="Yes" message="#message#" type="text" name="fullname" style="width:385;" maxlength="75">
                    </td>
                    <td><cf_get_lang_main no='1350.Vergi Dairesi'></td>
                    <td><cfinput type="text" name="tax_office" style="width:140px;" maxlength="30"></td>
                </tr>
                <tr>
                    <td><cf_get_lang_main no='780.Müşteri Adı'></td>
                    <td width="160"><input type="text" name="authority_name" id="authority_name" style="width:140px;"></td>
                    <td width="77"><cf_get_lang no='37.Müşteri Soyadı'></td>
                    <td width="175"><input type="text" name="authority_surname" id="authority_surname" style="width:140px;"></td>		
                    <td><cf_get_lang_main no='340.Vergi No'></td>
                    <td>
                        <cfsavecontent variable="message"><cf_get_lang no='57.Vergi No girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="tax_num" style="width:140px;" maxlength="12"  validate="integer" message="#message#">
                    </td>
                </tr>
                <tr>
                    <td><cf_get_lang_main no='1173.Kod'>/<cf_get_lang_main no='87.Telefon'></td>
                    <td><cfsavecontent variable="message"><cf_get_lang no='178.Geçerli Bir Telefon Kodu Giriniz !'></cfsavecontent>
                    <cfinput validate="integer" maxlength="5" message="#message#" type="text" name="telcod" style="width:50px;">
                    <cfinput validate="integer" maxlength="9" message="#message#" type="text" name="tel1" style="width:87px;"></td>
                    <td><cf_get_lang_main no='1323.Mahalle'></td>
                    <td><input type="text" name="area" id="area" style="width:140px;"></td>
                    <td><cf_get_lang no='429.Bölge Direktörlüğü'></td>
                    <td>
                    <select name="bolge" id="bolge" style="width:140px;">
                        <option value=""><cf_get_lang no='779.İstanbul Avrupa Bölge Direktörlüğü'></option>
                    </select>
                    </td>
                </tr>
                <tr>
                    <td><cf_get_lang_main no='87.Telefon'> 2</td>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <cfsavecontent variable="message"><cf_get_lang no='168.Telefon 2 Girmelisiniz !'></cfsavecontent>
                        <cfinput  name="tel2" validate="integer" message="#message#" maxlength="9" type="text" style="width:86px;">
                    </td>
                    <td><cf_get_lang no='45.Cadde'></td>
                    <td><input type="text" name="main_street" id="main_street" style="width:140px;"></td>
                    <td><cf_get_lang_main no='722.Mikro Bolge Kodu'></td>
                    <td><input type="text" name="ims_code" id="ims_code" style="width:140px;"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></td>
                </tr>
                <tr>
                    <td><cf_get_lang_main no='87.Telefon'> 3</td>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <cfsavecontent variable="message"><cf_get_lang no='199.Telefon 3 Girmelisiniz !'></cfsavecontent>
                    <cfinput validate="integer" message="#message#" maxlength="9" type="text" name="tel3" style="width:86px;">
                    </td>
                    <td><cf_get_lang no='46.Sokak'></td>
                    <td><input type="text" name="street" id="street" style="width:140px;"></td>
                    <td><cf_get_lang_main no='247.Satış Bölgesi'></td>
                    <td>
                    <select name="county" id="county" style="width:140px;">
                        <option value=""><cf_get_lang no='180.Seçiniz'></option>
                        <cfoutput query="sz">
                            <option value="#sz_id#">#sz_name#</option>
                        </cfoutput>
                    </select>
                    </td>
                </tr>
                <tr>
                    <td><cf_get_lang_main no='76.Fax'></td>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <cfsavecontent variable="message"><cf_get_lang no='193.Fax Girmelisiniz !'></cfsavecontent>
                    <cfinput validate="integer" message="#message#" maxlength="9" type="text" name="fax" style="width:86px;"></td>
                    <td><cf_get_lang_main no='75.No'></td>
                    <td><input type="text" name="dukkan_no" id="dukkan_no" style="width:140px;"></td>
                    <td><cf_get_lang no='102.Bölge Satış Müdürü'></td>
                    <td><input type="hidden" name="satis_muduru_id" id="satis_muduru_id" value="">
                    <input readonly type="text" name="satis_muduru" id="satis_muduru" style="width:140px;">
                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=form_add_company.satis_muduru_id&field_name=form_add_company.satis_muduru&select_list=1','list');return false"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></td>
                </tr>
                <tr>
                    <td><cf_get_lang_main no='16.e-mail'></td>
                    <td><cfinput type="text" name="email" style="width:140px;" maxlength="50"></td>
                    <td><cf_get_lang_main no='60.Posta Kodu'></td>
                    <td><input type="text" name="postcod" id="postcod" style="width:140px;" maxlength="5"> <img src="/images/plus_thin.gif" border="0" align="absmiddle"></td>
                    <td><cf_get_lang no='780.Plasiyer'></td>
                    <td><input type="hidden" name="pos_code" id="pos_code" value="">
                        <input readonly type="text" name="pos_code_text" id="pos_code_text" style="width:140px;">
                        <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=form_add_company.pos_code&field_name=form_add_company.pos_code_text&select_list=1','list');return false"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                    </td>
                </tr>
                <tr>
                    <td><cf_get_lang_main no='667.İnternet'></td>
                    <td><input type="text" name="homepage" id="homepage" style="width:140px;" maxlength="50" value="http://"></td>
                    <td><cf_get_lang_main no='720.Semt'></td>
                    <td><input type="text" name="county2" id="county2" value="" maxlength="30" style="width:140px;"></td>
                    <td><cf_get_lang no='430.Telefonla Satış Görevlisi'></td>
                    <td><input type="hidden" name="plasiyer_id" id="plasiyer_id" value="">
                        <input readonly type="text" name="plasiyer" id="plasiyer" style="width:140px;">
                        <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=form_add_company.plasiyer_id&field_name=form_add_company.plasiyer&select_list=1','list');return false"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                    </td>
                </tr>
                <tr>
                    <td><cf_get_lang no='795.GSM Tel'></td>
                    <td>
                        <cfsavecontent variable="message"><cf_get_lang no='178.Geçerli Bir Telefon Kodu Giriniz !'></cfsavecontent>
                        <select name="gsm" id="gsm" style="width:50;">
                            <option value="532">532</option>
                            <option>533</option>
                            <option>535</option>
                            <option>542</option>
                            <option>543</option>
                            <option>555</option>
                        </select>
                        <cfinput validate="integer" maxlength="7" message="#message#" type="text" name="gsm_tel1" style="width:90px;">
                    </td>
                    <td><cf_get_lang_main no='1226.İlçe'></td>
                    <td>
                        <input type="text" name="county" id="county" value="" maxlength="30" style="width:140px;">
                        <img src="/images/plus_thin.gif" border="0" align="absmiddle">
                    </td>
                    <td><cf_get_lang no='1001.Depodaki Açılış Tarihi'></td>
                    <td>
                        <cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'> !</cfsavecontent>
                        <cfinput type="text" name="birthday" value="" maxlength="10" validate="#validate_style#" message="#message#" style="width:140;" required="yes">
                        <cf_wrk_date_image date_field="birthday">
                    </td>
                </tr>
                <tr>
                    <td colspan="2">&nbsp;</td>
                    <td><cf_get_lang_main no='1196.İl'></td>
                    <td>
                        <select name="city" id="city" style="width:140px;">
                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        </select>
                    </td>
                    <td></td>
                    <cfsavecontent variable="search"><cf_get_lang_main no ='153.Ara'></cfsavecontent>
                    <cfsavecontent variable="button_alert"><cf_get_lang no ='954.Arama Yapmak İstediğinizden Emin misiniz'></cfsavecontent> 
                    <td><cf_workcube_buttons is_cancel='0' insert_alert='#button_alert#' insert_info='#search#'></td>
                </tr>
            </cfform>
            </table>
        </td>
    </tr>
</table>
<script type="text/javascript">
function kontrol()
{
	x = document.form_add_company.companycat_id.selectedIndex;
	if (document.form_add_company.companycat_id[x].value == "")
	{ 
		alert ("<cf_get_lang no='131.Şirket Kategorisi Seçmediniz !'>");
		return false;
	}
	x = (100 - document.form_add_company.adres.value.length);
	if ( x < 0 )
	{ 
		alert ("<cf_get_lang no='170.Adres İçerisindeki Fazla Karakter Sayısı'> "+((-1) * x));
		return false;
	}

	if (confirm("<cf_get_lang no='175.Girdiğiniz bilgileri kaydetmek üzeresiniz, Lütfen yeni şirket kaydını onaylayın ! '>")) return true; else return false;
}
</script>
