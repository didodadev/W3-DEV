<cfinclude template="../query/get_net_connection.cfm">
<table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td height="35" class="headbold"><cf_get_lang no='424.Aday Müşteri Ekle'></td>
  </tr>
</table>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr class="color-border">
    <td>
        <table cellspacing="1" cellpadding="2" border="0" align="center" width="100%">
            <tr class="color-row">
            	<td valign="top">
            		<table>
                    <cfform name="form_add_company" method="post" action="#request.self#?fuseaction=crm.add_potential_company">
                    <input name="is_potential" id="is_potential" type="hidden" value="0">
                        <tr>
                            <td><cf_get_lang_main no='338.İşyeri Adı'> *</td>
                            <td colspan="3">
                            	<cfsavecontent variable="message"><cf_get_lang no='34.İş Yeri Adı Girmelisiniz '>!</cfsavecontent>
                                <cfinput type="text" name="fullname" required="yes" message="#message#" maxlength="75" style="width:400px;">
                                <a href="javascript://" onClick="pencere_pos('');"><img src="/images/plus_ques.gif" align="absmiddle" border="0"></a>
                          	</td>
            			</tr>
            			<tr>
            				<td><cf_get_lang no='35.Müşteri Tipi'> </td>
           					<td>
                                <select name="customer_type" id="customer_type" style="width:140px;">
                                    <cfoutput query="get_custs">
                                        <option value="#companycat_id#">#companycat#</option>
                                    </cfoutput>
                                </select>
           					</td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td><cf_get_lang_main no='1350.Vergi Dairesi'> </td>
                            <td><cfinput type="text" name="tax_office"  maxlength="30" style="width:140px;"></td>
            			</tr>
                        <tr>
                            <td><cf_get_lang_main no='780.Müşteri Adı'> </td>
                            <td width="180"><cfinput type="text" name="company_partner_name" maxlength="20" style="width:140px;"></td>
                            <td><cf_get_lang no='37.Müşteri Soyadı'> </td>
                            <td width="180"><cfinput type="text" name="company_partner_surname" style="width:140px;" maxlength="20"></td>
                            <td><cf_get_lang_main no='340.Vergi No'></td>
                            <td>
                                <cfsavecontent variable="message"><cf_get_lang no='57.Vergi No girmelisiniz'></cfsavecontent>
                                <cfinput type="text" name="tax_num"  maxlength="50"  validate="integer" message="#message#"  style="width:140px;">
                            </td>
                        </tr>
                        <tr>
                            <td><cf_get_lang no='337.Kod/Telefon'></td>
                            <td>
                                <input type="text" name="telcod" id="telcod" style="width:50px;" readonly="yes">
                                <cfsavecontent variable="message"><cf_get_lang no='178.Geçerli Bir Telefon Kodu Giriniz !'></cfsavecontent>
                                <cfsavecontent variable="message2"><cf_get_lang no='426.Telefon Numarası Giriniz'> !</cfsavecontent>
                                <cfinput validate="integer" maxlength="9" message="#message2#" type="text" name="tel1" style="width:87px;"></td>
                            <td><cf_get_lang_main no='1323.Mahalle'> </td>
                            <cfsavecontent variable="alert"><cf_get_lang no ='503.Mahalle Seçmelisiniz'></cfsavecontent>
                            <td><cfinput type="text" name="district"   message="#alert#" style="width:140px;"></td>
                            <td><cf_get_lang_main no='722.IMS Bölge Kodu'> </td>
                            <td>
                                <input type="hidden" name="ims_code_id" id="ims_code_id" style="width:140px;">
                                <cfinput type="text" name="ims_code_name" style="width:140px;" readonly="yes">
                                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=form_add_company.ims_code_name&field_id=form_add_company.ims_code_id','list');return false"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                            </td>
                        </tr>
            			<tr>
                            <td><cf_get_lang_main no='87.Telefon'> 2</td>
                            <td><cfsavecontent variable="message"><cf_get_lang no='168.Telefon 2 Girmelisiniz !'></cfsavecontent>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <cfinput type="text" name="tel2" validate="integer" message="#message#" maxlength="9" style="width:86px;"></td>
                            <td><cf_get_lang no='45.Cadde'> </td>
                            <td><cfinput type="text" name="main_street" style="width:140px;" maxlength="50"></td>
                            <td><cf_get_lang no='429.Bölge Direktörlüğü'></td>
                            <td>
                            <select name="zone_director" id="zone_director" style="width:140px;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfoutput query="get_zone">
                                    <option value="#zone_id#">#zone_name#</option>
                                </cfoutput>
                                </option>
                            </select>
                            </td>
            			</tr>
            			<tr>
                            <td><cf_get_lang_main no='87.Telefon'> 3</td>
                            <td><cfsavecontent variable="message"><cf_get_lang no='199.Telefon 3 Girmelisiniz !'></cfsavecontent>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <cfinput validate="integer" message="#message#" maxlength="9" type="text" name="tel3" style="width:86px;"></td>
                            <td><cf_get_lang no='46.Sokak '></td>
                            <cfsavecontent variable="alert"><cf_get_lang no ='62.Lütfen Sokak Giriniz'></cfsavecontent>
                            <td><cfinput type="text" name="street" style="width:140px;" maxlength="50" message="#alert#"></td>
                            <td><cf_get_lang no='102.Bölge Satış Müdürü'></td>
                            <td><input type="hidden" name="satis_muduru_id" id="satis_muduru_id" value="">
                                <input readonly type="text" name="satis_muduru" id="satis_muduru" style="width:140px;">
                                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=form_add_company.satis_muduru_id&field_name=form_add_company.satis_muduru&select_list=1','list');return false"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                            </td>
            			</tr>
                        <tr>
                            <td><cf_get_lang_main no='76.Fax'></td>
                            <td> <input type="text" name="faxcode" id="faxcode" readonly="yes" maxlength="5" style="width:50px;">
                            <cfsavecontent variable="message"><cf_get_lang no='427.Fax Sayısal Olmalıdır'> !  </cfsavecontent>
                            <cfinput validate="integer" message="#message#" maxlength="9" type="text" name="fax" style="width:86px;"></td>
                            <td><cf_get_lang_main no='75.No '></td>
                            <cfsavecontent variable="alert"><cf_get_lang no ='781.Lütfen No Giriniz'></cfsavecontent>
                            <td><cfinput type="text" name="dukkan_no" style="width:140px;" message="#alert#" maxlength="50"></td>
                            <td><cf_get_lang no='430.Telefonla Satış Görevlisi'></td>
                            <td><input type="hidden" name="telefon_satis_id" id="telefon_satis_id" value="">
                                <input readonly type="text" name="telefon_satis" id="telefon_satis" style="width:140px;">
                                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=form_add_company.telefon_satis_id&field_name=form_add_company.telefon_satis&select_list=1','list');return false"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                            </td>
                        </tr>
                        <tr>
                            <td><cf_get_lang_main no='16.e-mail'></td>
                            <td><cfinput type="text" name="email" style="width:140px;" maxlength="50"></td>
                            <td><cf_get_lang_main no='60.Posta Kodu'></td>
                            <td><input type="text" name="post_code" id="post_code" style="width:140px;" maxlength="5"></td>
                            <td><cf_get_lang no='101.Plasiyer'></td>
                            <td><input type="hidden" name="plasiyer_id" id="plasiyer_id" value="">
                                <input readonly type="text" name="plasiyer" id="plasiyer" style="width:140px;">
                                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=form_add_company.plasiyer_id&field_name=form_add_company.plasiyer&select_list=1','list');return false"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                            </td>
                        </tr>
                        <tr>
                            <td><cf_get_lang_main no='667.İnternet'></td>
                            <td><input type="text" name="homepage" id="homepage" value="http://" maxlength="50"  style="width:140px;"></td>
                            <td><cf_get_lang_main no='720.Semt'> </td>
                            <td><cfinput type="text" name="semt" value="" maxlength="30"  style="width:140px;"></td>
                            <td><cf_get_lang no='150.Bilgisayar Sayısı'></td>
                            <td>
                                <select name="pc_number" id="pc_number" style="width:140px;">
                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                    <cfoutput query="get_pc_number">
                                        <option value="#unit_id#">#unit_name#</option>
                                    </cfoutput>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td><cf_get_lang no='71.Cep Tel'></td>
                            <td>
                                <select name="gsm_code" id="gsm_code" style="width:50;">
                                    <option value=""><cf_get_lang_main no='1173.Kod'></option>
                                    <cfoutput query="get_mobilcat">
                                        <option value="#mobilcat_id#">#mobilcat#</option>
                                    </cfoutput>
                                </select>
                                <cfsavecontent variable="message_gsm_tel"><cf_get_lang no='178.Geçerli Bir Telefon Kodu Giriniz !'></cfsavecontent>
                                <cfinput type="text" name="gsm_tel" validate="integer" maxlength="7" message="#message_gsm_tel#" style="width:87px;">
                            </td>
                            <td><cf_get_lang_main no='1226.İlçe'> </td>
                            <td>
                                <input type="hidden" name="county_id" id="county_id" readonly="">
                                <cfsavecontent variable="alert"><cf_get_lang no ='65.Lütfen İlçe Giriniz'></cfsavecontent>
                                <cfinput type="text" name="county" value="" maxlength="30" style="width:140px;"   message="#alert#" readonly="yes">
                                <a href="javascript://" onClick="pencere_ac();"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                            </td>
                            <td><cf_get_lang no='122.İnternet Bağlantısı'></td>
                            <td>
                                <select name="net_connection" id="net_connection" style="width:140px;">
                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                    <cfoutput query="get_net_connection">
                                        <option value="#connection_id#">#connection_name#</option>
                                    </cfoutput>
                                </select>
                            </td>
                        <tr>
                        <td><cf_get_lang no='124.SMS İstiyor mu'> ?</td>
                        <td>
                            <select name="is_sms" id="is_sms" style="width:140px;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <option value="1"><cf_get_lang_main no='83.Evet'></option>
                                <option value="2"><cf_get_lang_main no='84.Hayır'></option>
                            </select>
                        </td>
                        <td><cf_get_lang_main no='1196.İl '></td>
                        <td>
                            <select name="city" id="city" onChange="get_phone_code()" style="width:140px;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="get_city">
                                    <option value="#city_id#">#city_name#</option>
                                </cfoutput>
                            </select>
                        </td>
            			<td valign="top"><cf_get_lang no='77.Hobileri'></td>
            			<td rowspan="2" valign="top">
            				<table border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td width="132">
                                        <select name="hobby" id="hobby" style="width:140px;" multiple></select>
                                    </td>
                                    <td valign="top"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_hobby_detail&field_name=form_add_company.hobby','list');"><img src="/images/plus_list.gif" border="0" align="top"></a><br/>
                                        <a href="javascript://" onClick="kaldir();"><img src="/images/delete_list.gif" border="0" title="<cf_get_lang_main no ='51.Sil'>" style="cursor=hand" align="top"></a>
                                    </td>
                                </tr>
                            </table>
            			</td>
            		</tr>
                    <tr>
                        <td><cf_get_lang no='428.Müşteri Cari Aday No'></td>
                        <td><cfinput type="text" name="current_number" maxlength="50" style="width:140px;"></td>
                        <td><cf_get_lang_main no='807.Ülke'></td>
                        <td>
                            <input name="country" id="country" style="width:140px;" type="text">
                            <input type="hidden" name="country_id" id="country_id" value="">
                        </td>
                        <td></td>
                    </tr>
                    <tr>
                        <td><cf_get_lang_main no='1315.Doğum Tarihi'></td>
                        <cfsavecontent variable="alert"><cf_get_lang no ='917.Lütfen Doğum Tarihi Formatını Doğru Giriniz'></cfsavecontent>
                        <td><cfinput type="text" name="birthday" value="" maxlength="10" validate="#validate_style#" message="#alert#" style="width:140;">
                        <cf_wrk_date_image date_field="birthday"></td>
                        <td><cf_get_lang_main no='378.Doğum Yeri'></td>
                        <td><input type="text" name="birth_place" id="birth_place" maxlength="100" style="width:140;"></td>
                        <td><cf_get_lang no='80.Cinsiyeti'></td>
                        <td>
                            <select name="sexuality" id="sexuality" style="width:140;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <option value="1"><cf_get_lang no='163.Bay'></option>
                                <option value="2"><cf_get_lang no='164.Bayan'></option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td><cf_get_lang no='74.Medeni Hali'></td>
                        <td>
                            <select name="marital_status" id="marital_status" style="width:140;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <option value="1"><cf_get_lang no='110.Bekar'></option>
                                <option value="2"><cf_get_lang no='109.Evli'></option>
                                <option value="3"><cf_get_lang no='108.Dul'></option>
                            </select>
                        </td>
                        <td><cf_get_lang no='75.Evlenme Tarihi'></td>
                        <cfsavecontent variable="alert"><cf_get_lang no ='918.Lütfen Evlenme Tarihi Formatını Doğru Giriniz'></cfsavecontent>
                        <td>
                            <cfinput type="text" name="marriage_date" value="" maxlength="10" validate="#validate_style#" message="#alert#" style="width:140;">
                            <cf_wrk_date_image date_field="marriage_date">&nbsp;
                        </td>
                        <td><cf_get_lang no='76.Çocuk Sayısı'></td>
                        <td><input type="text" name="child_number" id="child_number" style="width:140px;" maxlength="50"></td>
                    </tr>
                    <tr>
                        <td><cf_get_lang no='78.Mez Olduğu Ecz Fakültesi'></td>
                        <td>
                            <select name="faculty" id="faculty" style="width:140;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="get_universty">
                                    <option value="#university_id#">#university_name#</option>
                                </cfoutput>
                            </select>
                        </td>
                        <td><cf_get_lang no='79.Mezuniyet Yılı'></td>
                        <td>
                            <select name="graduate_year" id="graduate_year" style="width:140;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfloop from="1920" to="#2020#" index="i">
                                    <cfoutput>
                                        <option value="#i#"<cfif i eq dateformat(now(),"yyyy")>selected</cfif>>#i#</option>
                                    </cfoutput>
                                </cfloop>
                            </select>
                        </td>
                        <td></td>
                        <cfsavecontent variable="alert"><cf_get_lang no ='919.Aday Müşteri Ekliyorsunuz Lütfen Kaydı Onaylayın'></cfsavecontent>
                        <cfsavecontent variable="alert1"><cf_get_lang_main no ='1331.Gönder'></cfsavecontent>
                        <td><cf_workcube_buttons is_upd='0' add_function='hepsini_sec()' insert_alert='#alert#' insert_info='#alert1#'></td>
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
	function hepsini_sec()
	{
		select_all('hobby');
	}
	
	function select_all(selected_field)
	{
		var m = eval("document.form_add_company."+selected_field+".length");
		for(i=0;i<m;i++)
		{
			eval("document.form_add_company."+selected_field+"["+i+"].selected=true")
		}
		}
	
	function pencere_pos()
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=crm.popup_dsp_company_prerecords&company_name='+ document.form_add_company.fullname.value +'&company_partner_name=' + document.form_add_company.company_partner_name.value +'&company_partner_surname='+ document.form_add_company.company_partner_surname.value +'&company_partner_tax_no='+ document.form_add_company.tax_num.value +'&company_partner_tel_code='+ document.form_add_company.telcod.value +'&company_partner_tel=' + document.form_add_company.tel1.value,'wide');
	}

	function pencere_ac(no)
	{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=form_add_company.county_id&field_name=form_add_company.county&city_id=' + document.form_add_company.city.value,'list');	//&process=purchase_contract      var_=purchase_contr_cat_premium&
	}
	
	function kaldir()
	{
		for (i=document.form_add_company.hobby.options.length-1;i>-1;i--)
		{
			if (document.form_add_company.hobby.options[i].selected==true)
			{
				document.form_add_company.hobby.options.remove(i)
			}	
		}
	}
	phone_code_list = new Array(<cfoutput>#valuelist(get_city.phone_code)#</cfoutput>);
	country_list = new Array(<cfoutput><cfloop query=get_country>"#get_country.country_name#"<cfif not currentrow eq recordcount>,</cfif></cfloop></cfoutput>);
	country_ids = new Array(<cfoutput>#valuelist(get_city.country_id)#</cfoutput>);
	function get_phone_code()
	{	
		if(document.form_add_company.city.selectedIndex > 0)
			{
				document.form_add_company.telcod.value = phone_code_list[document.form_add_company.city.selectedIndex-1];
				document.form_add_company.faxcode.value = phone_code_list[document.form_add_company.city.selectedIndex-1];
				document.form_add_company.country.value = country_list[country_ids[document.form_add_company.city.selectedIndex-1]-1];
				document.form_add_company.country_id.value = country_ids[document.form_add_company.city.selectedIndex-1];
			}
		else
			{
				document.form_add_company.telcod.value = '';
				document.form_add_company.faxcode.value = '';
			}
	}
</script>
