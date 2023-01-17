<cf_get_lang_set module_name="member">
<cfinclude template="../query/get_company_cat.cfm">
<cfinclude template="../query/get_country.cfm">
<cfquery name="GET_MOBILCAT" datasource="#DSN#">
	SELECT
		MOBILCAT_ID,
		MOBILCAT
	FROM
		SETUP_MOBILCAT
	ORDER BY
		MOBILCAT ASC
</cfquery>
<cfquery name="GET_CUSTOMER_VALUE" datasource="#DSN#">
	SELECT
		CUSTOMER_VALUE_ID,
		CUSTOMER_VALUE 
	FROM
		SETUP_CUSTOMER_VALUE WITH (NOLOCK)
	ORDER BY
		CUSTOMER_VALUE
</cfquery>
<table cellpadding="0" cellspacing="0" align="center" style="width:98%">
	<tr style="height:35px;">
		<td class="headbold"><cf_get_lang_main no='1612.Kurumsal Üye Ekle'></td>
	</tr>
</table>
<cfform name="form_add_company" id="form_add_company" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_company" enctype="multipart/form-data">  
	<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%">	
		<tr>
			<td class="color-row">
				<table align="center" style="width:99%"> 
					<input type="hidden" name="process_stage" id="process_stage" value="<cfif isdefined('session.pda.member_add_company_process_id')><cfoutput>#session.pda.member_add_company_process_id#</cfoutput></cfif>">
					<tr>
						<td class="infotag" style="width:30%"><cf_get_lang_main no='159.Ünvan'> *</td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no="159.Ünvan"></cfsavecontent>	
							<cfinput type="text" name="fullname" id="fullname" value=""  maxlength="250" required="yes" message="#message#" style="width:193px;">
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='339.Kısa Ad'> *</td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no='339.Kısa Ad'></cfsavecontent>
							<cfinput type="text" name="nickname" id="nickname" value="" maxlength="25" required="yes" message="#message#" style="width:193px;">
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='74.Kategori'> *</td>
						<td><select name="companycat_id" id="companycat_id" style="width:200px;">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfoutput query="get_companycat">
									<option value="#companycat_id#">#companycat#</option>
								</cfoutput>
							</select>
						</td>
					</tr>
					<tr>
						<td class="infotag"><b><cf_get_lang_main no='174.Bireysel Üye'></b></td>
						<td><input type="hidden" id="related_consumer_id" name="related_consumer_id" value="">
							<input type="text" id="related_consumer_name" name="related_consumer_name" value="" style="width:162px;" autocomplete="off">
							<a href="javascript://" onClick="get_consumers_div();"><img src="/images/buyutec.jpg" border="0" align="absmiddle" class="form_icon"></a>
						</td>
					</tr>
					<tr><td colspan="2"><div id="control_consumer_div"></div></td></tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='166.Yetkili'><cf_get_lang_main no='485.Adı'><cf_get_lang_main no='1138.Soyadı'> *</td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no='166.Yetkili'> <cf_get_lang_main no='485.Adı'></cfsavecontent>
							<cfinput type="text" name="name" id="name" value="KURUMUN" maxlength="50" required="yes" message="#message#" style="width:70px; vertical-align:top">
							<input type="hidden" name="company_partner_status" id="company_partner_status" value="1">
							<cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no='166.Yetkili'> <cf_get_lang_main no='1138.Soyadı'> </cfsavecontent>
							<cfinput type="text" name="surname" id="surname" value="KENDİSİ" maxlength="50" required="yes" message="#message#" style="width:55px; vertical-align:top">
							<select name="sex" id="sex" style="width:53px; vertical-align:top">
								<option value="1"><cf_get_lang_main no='1547.Erkek'></option>
								<option value="2"><cf_get_lang_main no='1546.Kadin'></option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='722.Mikro Blge Kodu'> *</td> 
						<td>
							<input type="hidden" name="ims_code_id" id="ims_code_id" value="">
							<input type="text" name="ims_code_name" id="ims_code_name" value="" style="width:162px;">
							<a href="javascript://" onClick="get_ims_code_div();"><img src="/images/buyutec.jpg" border="0" align="absmiddle" class="form_icon"></a>						
						</td>
					</tr>
					<tr><td colspan="2"><div id="ims_code_div"></div></td></tr>
					<tr>
						<td class="infotag">Müşteri Değeri</td>
						<td><select name="customer_value" id="customer_value" style="width:200px;">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfoutput query="get_customer_value">
									<option value="#customer_value_id#">#customer_value#</option>
								</cfoutput>
							</select>
						</td>	
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='340.Vergi No'></td>
						<td>
							<input type="text" name="tax_no" id="tax_no" value="" onKeyup="isNumber(this);" onblur="isNumber(this);" maxlength="10" style="width:193px;">
						</td> 
					</tr>
					<tr>
						<td class="infotag">Vergi Dairesi</td>
						<td>
							<input type="text" name="tax_office" id="tax_office" value="" style="width:193px;">
						</td> 
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no="16.E posta"></td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no="16.E posta"></cfsavecontent>
							<cfinput type="text" name="email" id="email" validate="email" value="" message="#message#" maxlength="50" style="width:193px;">
						</td>
					</tr>		
					<tr>
						<td class="infotag"><cf_get_lang_main no='247.Satış Bölgesi'> * </td>
						<td>
							<cf_wrk_saleszone
								 name="sales_county"
								 width="200"
								 value="">	
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='1418.İlişki Şekli'> * </td>
						<td>
							<cf_wrk_combo 
								name="resource"
								query_name="GET_PARTNER_RESOURCE"
								value=""
								option_name="resource"
								option_value="resource_id"
								width="200">			    
						</td>			
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang no="36.Kod/Telefon">*</td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no="178.Telefon Kodu"></cfsavecontent>
							<cfinput type="text" name="telcode" id="telcode" maxlength="5" onKeyup="isNumber(this);" onblur="isNumber(this);" required="yes" message="#message#" value="" style="width:64px;">						
							<cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no="87.Telefon"></cfsavecontent>
							<cfinput type="text" name="tel1" id="tel1" maxlength="7" onKeyup="isNumber(this);" onblur="isNumber(this);" required="yes" message="#message#" value="" style="width:118px;">
						</td>
					</tr>
					<tr>
						<td class="infotag">Kod /Mobil Tel</td>
						<td><select name="mobilcat_id" id="mobilcat_id"  style="width:71px; vertical-align:top">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfoutput query="get_mobilcat">
									<option value="#mobilcat#">#mobilcat#</option>
								</cfoutput>
							</select>
							<input type="text" name="mobiltel" id="mobiltel" maxlength="7" onKeyup="isNumber(this);" onblur="isNumber(this);" value="<cfif isdefined("attributes.mobiltel")><cfoutput>#attributes.mobiltel#</cfoutput></cfif>" style="width:118px; vertical-align:top">
						</td>
					</tr>
					<tr>
						<td style="vertical-align:top" class="infotag"><cf_get_lang_main no='1311.Adres'></td>
						<td><cfsavecontent variable="msg"><cf_get_lang no='611.Adres Uzunluğu 200 Karakteri Geçemez!'></cfsavecontent>
							<textarea name="address" id="address" message="<cfoutput>#msg#</cfoutput>" maxlength="200" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);" style="width:194px; height:60px;"></textarea>
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='807.Ulke'> *</td>
						<td><select name="country" id="country" onChange="remove_adress('1');" style="width:200px;">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfoutput query="get_country">
									<option value="#get_country.country_id#" <cfif is_default eq 1>selected</cfif>>#get_country.country_name#</option>
								</cfoutput>
							</select>
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='559.Sehir'> *</td>
						<td>
							<input type="hidden" name="city_id" id="city_id" value="<cfif isdefined("attributes.city_id")><cfoutput>#attributes.city_id#</cfoutput></cfif>">
							<input type="text" name="city" id="city" value="<cfif isdefined("attributes.city")><cfoutput>#attributes.city#</cfoutput></cfif>"  style="width:162px;"><!--- readonly --->
							<a href="javascript://" onClick="get_city_div();"><img src="/images/buyutec.jpg" border="0" align="absmiddle" class="form_icon"></a>
						</td>
					</tr>
					<tr><td colspan="2"><div id="city_div"></div></td></tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='1226.İlçe'> *</td>
						<td>
							<input type="hidden" name="county_id" id="county_id" value="<cfif isdefined("attributes.county_id")><cfoutput>#attributes.county_id#</cfoutput></cfif>" readonly="">
							<input type="text" name="county" id="county" value="<cfif isdefined("attributes.county")><cfoutput>#attributes.county#</cfoutput></cfif>" maxlength="30" style="width:162px;"><!--- readonly --->
							<a href="javascript://" onClick="get_county_div();"><img src="/images/buyutec.jpg" border="0" align="absmiddle" class="form_icon"></a>
						</td>
					</tr>
					<tr><td colspan="2"><div id="county_div"></div></td></tr>
					<tr>
						<td class="infotag">Mahalle *</td>
						<td>
							<input type="hidden" name="district_id" id="district_id" value="<cfif isdefined("attributes.county_id")><cfoutput>#attributes.county_id#</cfoutput></cfif>" readonly="">
							<input type="text" name="district" id="district" value="<cfif isdefined("attributes.county")><cfoutput>#attributes.county#</cfoutput></cfif>" maxlength="30" style="width:162px;"><!--- readonly --->
							<a href="javascript://" onClick="get_district_div();"><img src="/images/buyutec.jpg" border="0" align="absmiddle" class="form_icon"></a>
						</td>
					</tr>
					<tr><td colspan="2"><div id="district_div"></div></td></tr>
					<tr>
						<td class="infotag">Semt</td>
						<td>
							<input type="text" name="semt" id="semt" value="" maxlength="30" style="width:193px;">
						</td>
					</tr>	
                    <tr><td colspan="2"><div id="control_prerecord_div"></div></td></tr>	
					<tr>
						<td height="30">&nbsp;</td>
						<td><cf_workcube_buttons is_upd='0' add_function="kontrol()"></td>
					</tr>
					<input type="hidden" name="get_comp_recordcount" id="get_comp_recordcount" value="">	
				</table>
			</td>
		</tr>
	</table>
</cfform>
<br>
<script type="text/javascript">
	function remove_adress(parametre)
	{
		if(parametre==1)
		{
			document.getElementById('city_id').value = '';
			document.getElementById('city').value = '';
			document.getElementById('county_id').value = '';
			document.getElementById('county').value = '';
			document.getElementById('telcode').value = '';
		}
		else
		{
			document.getElementById('county_id').value = '';
			document.getElementById('county').value = '';
		}	
	}
	
	function get_city_div()//&field_id=form_add_company.city_id&field_name=form_add_company.city&field_phone_code=form_add_company.telcode+'&div_name='+'city_div'
	{
		x = document.getElementById('country').selectedIndex;
		if (document.getElementById('country')[x].value == "")
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='807.Ülke'>");
		}	
		else
		{
			goster(city_div);
			AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_get_city_div&country_id='+document.getElementById('country').value+'&keyword='+document.getElementById('city').value,'city_div');
		}
		return remove_adress('2');
	}
	function add_city_div(city_id,city,phone_code)
	{
		document.getElementById('city_id').value = city_id;
		document.getElementById('city').value = city;
		document.getElementById('telcode').value = phone_code;
		gizle(city_div);
	}
	
	function add_consumer_div(consumer_name, consumer_surname, ims_code_id, ims_code, ims_code_name)
	{
		document.getElementById('name').value = consumer_name;
		document.getElementById('surname').value = consumer_surname;
		document.getElementById('related_consumer_name').value = consumer_name + ' ' + consumer_surname;
		document.getElementById('ims_code_id').value = ims_code_id;
		document.getElementById('ims_code_name').value = ims_code + ' ' + ims_code_name;
		gizle(control_consumer_div);
	}
	
	function get_consumers_div()
	{
		if(document.getElementById('related_consumer_name').value.length < 3)
		{
			alert("Lütfen bireysel üye alanı için en az 3 karakter giriniz !");
			return false;
		}
		goster(control_consumer_div);
		AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_list_consumer_div&name='+ encodeURI(document.getElementById('related_consumer_name').value) +'','control_consumer_div');		
		return false;
	}
		
	function get_county_div()//&field_id=form_add_company.county_id&field_name=form_add_company.county+'&div_name='+'county_div'
	{
		x = document.getElementById('country').selectedIndex;
		if (document.getElementById('country')[x].value == "")
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='807.Ülke'>");
		}	
		else if(document.getElementById('city_id').value == "")
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1196.İl'>");
		}
		else
		{
			goster(county_div);
			AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_get_county_div&city_id=' + document.getElementById('city_id').value+'&keyword='+document.getElementById('county').value,'county_div');
			return remove_adress();
		}
	}
	
	function get_district_div()
	{
		x = document.getElementById('country').selectedIndex;
		if (document.getElementById('country')[x].value == "")
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='807.Ülke'>");
		}	
		else if(document.getElementById('city_id').value == "")
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='559.Şehir'>");
		}
		else if(document.getElementById('county_id').value == "")
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1226.İlçe'>");
		}
		else
		{
			goster(district_div);
			AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_get_district_div&county_id=' + document.getElementById('county_id').value+'&keyword='+encodeURI(document.getElementById('district').value),'district_div');
			//return remove_adress();
		}
	}
	
	function add_county_div(county_id,county)
	{
		document.getElementById('county_id').value = county_id;
		document.getElementById('county').value = county;
		gizle(county_div);
	}

	function add_district_div(district_id,district)
	{
		document.getElementById('district_id').value = district_id;
		document.getElementById('district').value = district;
		gizle(district_div);
		get_ims_code();
	}

	function get_ims_code()
	{
		get_ims_code_ = wrk_safe_query("mr_get_ims_code","dsn",0,document.getElementById('district_id').value);
		if(get_ims_code_.IMS_CODE !=undefined && get_ims_code_.IMS_CODE_ID!=undefined)
		{
			document.getElementById('ims_code_name').value = get_ims_code_.IMS_CODE + ' ' + get_ims_code_.IMS_CODE_NAME;
			document.getElementById('ims_code_id').value = get_ims_code_.IMS_CODE_ID;
		}
		else
		{
			document.getElementById('ims_code_name').value = '';
			document.getElementById('ims_code_id').value = '';
		}
	}
	
	function get_ims_code_div()//&field_name=form_add_company.ims_code_name&field_id=form_add_company.ims_code_id+'&div_name='+'ims_code_div'
	{
		goster(ims_code_div);
		AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_get_ims_code_div&keyword='+encodeURI(form_add_company.ims_code_name.value),'ims_code_div');		
	}
	function add_ims_code_div(ims_code,ims_code_id,ims_code_name)
	{
		document.getElementById('ims_code_id').value = ims_code_id;
		document.getElementById('ims_code_name').value = ims_code + ' ' + ims_code_name;	
		gizle(ims_code_div);
	}
	
	function kontrol()
	{
		x = document.getElementById('companycat_id').selectedIndex;
		if (document.getElementById('companycat_id')[x].value == "")
		{ 
			alert ("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1293.Krumsal Üye Kategorisi'>");
			document.getElementById('companycat_id').focus();
			return false;
		}
		
		if(document.getElementById('ims_code_name').value == "")
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='722.mikro bölge kodu'>");
			document.getElementById('ims_code_name').focus();
			return false;
		}	
		
		x = document.getElementById('sales_county').selectedIndex;
		if(document.getElementById('sales_county')[x].value == "")
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='247.Satış Bölgesi'>");
			document.getElementById('sales_county').focus();
			return false;
		}
		
		x = document.getElementById('resource').selectedIndex;
		if(document.getElementById('resource')[x].value == "")
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1418.İlişki Şekli'>");
			document.getElementById('resource').focus();
			return false;
		}
		
		if(document.getElementById('city').value == "")
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='559.Şehir'>");
			document.getElementById('city').focus();
			return false;
		}
		if(document.getElementById('county').value == "")
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1226.İlçe'>");
			document.getElementById('county').focus();
			return false;
		}
		if(document.getElementById('district').value == "")
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1323.Mahalle'> / <cf_get_lang no='188.Köy'>");
			document.getElementById('district').focus();
			return false;
		}

		/*
		if(process_cat_control())
			if(confirm("<cf_get_lang no='175.Girdiğiniz bilgileri kaydetmek üzeresiniz lütfen değişiklikleri onaylayın'>!")) return true; else return false;
		else
			return false;
		*/
	
		if(!kontrol_prerecord())
			return false;
	}
	
	function kontrol_prerecord()
	{
		goster(control_prerecord_div);
		AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_check_company_div&fullname='+ encodeURI(document.getElementById('fullname').value) +'&nickname=' + encodeURI(document.getElementById('nickname').value) +'&tel_code='+ document.getElementById('telcode').value +'&telephone=' + document.getElementById('tel1').value +'&div_name='+'control_prerecord_div' +'&form_id=' + 'form_add_company','control_prerecord_div');
	}
	
	document.getElementById('fullname').focus();
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
