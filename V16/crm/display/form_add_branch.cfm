<cfinclude template="../query/get_zone.cfm">
<cfinclude template="../query/get_partner.cfm">
<cfinclude template="../query/get_company_cat.cfm">
<cfquery name="GET_COMPANY" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		COMPANY C, 
		COMPANY_CAT CC
	WHERE 
		COMPANY_ID = #URL.CPID# AND 
		C.COMPANYCAT_ID = CC.COMPANYCAT_ID
</cfquery>
<table border="0" width="98%" class="headbold" cellpadding="0" cellspacing="0" align="center">
  <tr>
    <td height="35"> 
        <cfform name="form_upd_branch" method="post" action="#request.self#?fuseaction=crm.add_branch"> 
        <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#GET_COMPANY.COMPANY_ID#</cfoutput>"><cf_get_lang no='53.Şube Ekle'>:
        <cfoutput query="get_company">#fullname#</cfoutput>
	</td>
  </tr>
</table>
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr class="color-border">
        <td> 
            <table width="100%" align="center" cellpadding="2" cellspacing="1" border="0">
                <tr>
                    <td class="color-row"> 
                        <table>
                            <tr> 
                                <td><cf_get_lang_main no='1735.Şube Adı'>*</td>
                                <td width="185">
                                    <cfsavecontent variable="message"><cf_get_lang no='194.Şube Seçmediniz !'></cfsavecontent>
                                    <cfinput type="text" name="COMPBRANCH__NAME" style="width:150px;" maxlength="50"  required="Yes" message="#message#"></td>
                                <td><cf_get_lang_main no='81.Aktif'></td>
                                <td><input type="checkbox" name="COMPBRANCH_STATUS" id="COMPBRANCH_STATUS" value="1"></td>
                            </tr>
                            <tr> 
                                <td><cf_get_lang_main no='1173.Kod'>/<cf_get_lang_main no='87.Telefon'>*</td>
                                <td>
                                    <cfsavecontent variable="message"><cf_get_lang no='178.Geçerli Bir Telefon Kodu Giriniz !'></cfsavecontent>
                                    <cfinput type="text" name="COMPBRANCH_TELCODE" required="Yes" message="#message#" style="width:52px;"> 
                                    <cfinput type="text" name="COMPBRANCH_TEL1" required="yes" message="#message#" style="width:95px;"> 
                                </td>
                                <td><cf_get_lang no='27.Yönetici'></td>
                                <td>
                                    <select name="manager" id="manager" style="width:150px;">
                                        <option value=""><cf_get_lang no='180.Seçiniz'></option>
                                        <cfoutput query="get_partner"> 
                                            <option value="#partner_id#">#company_partner_name# #company_partner_surname#</option>
                                        </cfoutput> 
                                    </select>
                                </td>
                            </tr>
                            <tr> 
                                <td>
                                    <cf_get_lang_main no='87.Telefon'> 2
                                </td>
                                <td width="150"  style="text-align:right;">
                                    <input type="text" name="COMPBRANCH_TEL2" id="COMPBRANCH_TEL2" style="width:95px;">
                                </td>
                                <td><cf_get_lang no='155.Temsilci'></td>
                                <td>
                                    <input type="hidden" name="pos_code" id="pos_code">
                                    <input readonly type="text" name="pos_code_text" id="pos_code_text" style="width:150px;">                 
                                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=form_upd_branch.pos_code&field_name=form_upd_branch.pos_code_text&select_list=1','list');return false"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                                </td>
                            </tr>
                            <tr> 
                                <td width="100"><cf_get_lang_main no='87.Telefon'> 3</td>
                                <td width="150"  style="text-align:right;"> <input type="text" name="COMPBRANCH_TEL3" id="COMPBRANCH_TEL3" style="width:95px;"  value=""> </td>
                                <td width="100"><cf_get_lang_main no='1311.Adres'></td>
                                <td rowspan="3"><textarea name="COMPBRANCH_ADDRESS" id="COMPBRANCH_ADDRESS" style="width:150px;height:60px;"></textarea> </td>
                            </tr>
                            <tr> 
                                <td><cf_get_lang_main no='76.Fax'></td>
                                <td width="150"  style="text-align:right;"> <input type="text" name="COMPBRANCH_FAX" id="COMPBRANCH_FAX" style="width:95px;" > </td>
                                <td colspan="1" >&nbsp;</td>
                            </tr>
                            <tr> 
                                <td><cf_get_lang_main no='16.E-mail'></td>
                                <td width="150"  style="text-align:right;"><input type="text" name="COMPBRANCH_EMAIL" id="COMPBRANCH_EMAIL" style="width:150px;" maxlength="50"> </td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr> 
                                <td><cf_get_lang_main no='667.İnternet'></td>
                                <td class="formbold"><input type="text" name="homepage" id="homepage" style="width:150px;" maxlength="50"  value="http://"></td>
                                <td><cf_get_lang_main no='60.Posta Kodu'></td>
                                <td><input type="text" name="COMPBRANCH_POSTCODE" id="COMPBRANCH_POSTCODE" style="width:150px;" maxlength="5"></td>
                            </tr>
                            <tr> 
                                <td rowspan="3" valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                                <td rowspan="3" valign="top"><textarea name="COMPBRANCH__NICKNAME" id="COMPBRANCH__NICKNAME" style="width:150px;height:70px;"></textarea> </td>
                                <td><cf_get_lang_main no='1226.ilçe'></td>
                                <td><input type="text" name="COUNTY" id="COUNTY" style="width:150px;" maxlength="20"> </td>
                            </tr>
                                <td><cf_get_lang_main no='559.Şehir'></td>
                                <td><input type="text" name="city" id="city" style="width:150px;" maxlength="20"> </td>
                            </tr>
                            <tr> 
                                <td><cf_get_lang_main no='807.Ülke'></td>
                                <td><input type="text" name="country" id="country" style="width:150px;" maxlength="20"> </td>
                            </tr>
                            <tr> 
                                <td colspan="4"  style="text-align:right;">
                                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</cfform>
<script type="text/javascript">
	function kontrol()
	{
		z = (100 - document.form_upd_branch.COMPBRANCH_ADDRESS.value.length);
		if ( z < 0 )
		{ 
			alert ("<cf_get_lang no='170.Adres İçerisindeki Fazla Karakter Sayısı'>"+ ((-1) * z));
			return false;
		}
		z = (50 - document.form_upd_branch.COMPBRANCH__NICKNAME.value.length);
		if ( z < 0 )
		{ 
			alert ("<cf_get_lang dictionary_id='36199.Açıklama'>" + ((-1) * z) + "<cf_get_lang dictionary_id='29538.Karakter Uzun'>!");
			return false;
		}
		return true;
	}
</script>
