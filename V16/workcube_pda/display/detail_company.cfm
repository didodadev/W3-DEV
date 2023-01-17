<cf_get_lang_set module_name="member">
<cfquery name="GET_COMPANY" datasource="#DSN#">
	SELECT
		COMPANY_ID,
		COMPANY_STATE,
		FULLNAME,
		COMPANYCAT_ID,
		MANAGER_PARTNER_ID,
		COMPANY_TELCODE,
		COMPANY_TEL1,
		COMPANY_ADDRESS,
		COUNTRY,
		CITY,
		COUNTY,
		SEMT,
		IMS_CODE_ID,
		TAXNO,
		TAXOFFICE,
		COMPANY_EMAIL,
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_EMP,
		UPDATE_DATE,
		SALES_COUNTY,
		RESOURCE_ID,
		NICKNAME
	FROM
		COMPANY 
	WHERE
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">
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
<cfif not get_company.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='589.Böyle Bir Üye Bulunamadı'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
	<cfquery name="GET_WORK_POS" datasource="#DSN#">
		SELECT
			COMPANY_ID,
			OUR_COMPANY_ID,
			POSITION_CODE,
			IS_MASTER
		FROM
			WORKGROUP_EMP_PAR
		WHERE
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#"> AND
			COMPANY_ID IS NOT NULL AND
			OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#">
	</cfquery>
	<cfquery name="GET_PARTNER" datasource="#DSN#">
		SELECT 
			PARTNER_ID,
			COMPANY_PARTNER_NAME,
			COMPANY_PARTNER_SURNAME,
			COMPANY_PARTNER_STATUS,
			MOBIL_CODE,
			MOBILTEL,
			SEX
		FROM 
			COMPANY_PARTNER
		WHERE 
			PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.manager_partner_id#">
	</cfquery>
</cfif>

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
<table cellpadding="0" cellspacing="0" align="center" style="width:98%">
	<tr style="height:35px;">
		<td class="headbold"><cf_get_lang_main no='246.Üye'> : <cfoutput>#get_company.nickname#</cfoutput></td>
		<td align="right">
			<cfoutput>
				<a href="#request.self#?fuseaction=pda.form_add_partner&cpid=#url.cpid#"><img src="/images/plus_list.gif" border="0" title="Üyeye Çalışan Ekle" class="form_icon"></a>
				<a href="#request.self#?fuseaction=pda.form_add_opportunity&cpid=#url.cpid#"><img src="/images/add_1.gif" border="0" alt="<cf_get_lang_main no='1077.Fırsat Ekle'>" title="<cf_get_lang_main no='1077.Fırsat Ekle'>" class="form_icon"></a>&nbsp;	
				<a href="#request.self#?fuseaction=pda.list_opportunity&cpid=#url.cpid#"><img src="/images/balon.gif" border="0" title="Üyenin Fırsat Listesi" class="form_icon"></a>&nbsp;
				<a href="#request.self#?fuseaction=pda.form_add_order_sale&cpid=#url.cpid#"><img src="/images/forklift.gif" border="0" title="Sipariş Al" class="form_icon"></a>	
			</cfoutput>
		</td>
	</tr>
</table>
<cfform name="form_add_company" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_company" enctype="multipart/form-data">
	<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%">	
		<tr>
			<td class="color-row">
				<table align="center" style="width:99%">				  
					<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_company.company_id#</cfoutput>">
					<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_partner.partner_id#</cfoutput>">
					<input type="hidden" name="process_stage" id="process_stage" value="<cfoutput>#get_company.company_state#</cfoutput>">
					<tr>
						<td class="infotag" style="width:30%"><cf_get_lang_main no='159.Unvan'>*</td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no='159.Unvan'></cfsavecontent>	
							<cfinput type="text" name="fullname" id="fullname" value="#get_company.fullname#" maxlength="250" required="yes" message="#message#" style="width:193px;">
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='339.Kısa Ad'>*</td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no='339.Kısa Ad'></cfsavecontent>
							<cfinput type="text" name="nickname" id="nickname" value="#get_company.nickname#" maxlength="25" required="yes" message="#message#" style="width:193px;">
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='74.Kategori'> *</td>
						<td><select name="companycat_id" id="companycat_id" style="width:200px;">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfoutput query="get_companycat">
									<option value="#companycat_id#" <cfif get_company.companycat_id is companycat_id>selected</cfif>>#companycat#</option>
								</cfoutput>
							</select>
						</td>
					</tr>
					<tr>
						<td class="infotag"><b><cf_get_lang_main no='174.Bireysel Üye'></b></td>
						<td><input type="hidden" id="related_consumer_id" name="related_consumer_id" value="">
							<input type="text" id="related_consumer_name" name="related_consumer_name" value="" style="width:162px;" autocomplete="off">
							<a href="javascript://" onClick="get_consumers_div();"><img src="/images/plus_list.gif" border="0" align="absmiddle" class="form_icon"></a>
						</td>
					</tr>
					<tr><td colspan="2"><div id="control_consumer_div"></div></td></tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='166.Yetkili'><cf_get_lang_main no='485.Adı'><cf_get_lang_main no='1138.Soyadı'> *</td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no='166.Yetkili'><cf_get_lang_main no='485.Adı'></cfsavecontent>
							<cfinput type="text" name="name" id="name" value="#get_partner.company_partner_name#" maxlength="50" required="yes" message="#message#" style="width:70px; vertical-align:top">
							<input type="hidden" name="company_partner_status" id="company_partner_status" <cfif get_partner.company_partner_status eq 1> value="1"</cfif>>
							<cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no='166.Yetkili'> <cf_get_lang_main no='1138.Soyadı'></cfsavecontent>
							<cfinput type="text" name="surname" id="surname" value="#get_partner.company_partner_surname#" maxlength="50" style="width:55px; vertical-align:top">
							<select name="sex" id="sex" style="width:53px; vertical-align:top" tabindex="6">
								<option value="1" <cfif get_partner.sex eq 1>selected</cfif>><cf_get_lang_main no='1547.Erkek'></option>
								<option value="2" <cfif get_partner.sex eq 2>selected</cfif>><cf_get_lang_main no='1546.Kadin'></option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='722.Mikro Blge Kodu'> *</td> 
						<td>										
							<input type="hidden" name="ims_code_id" id="ims_code_id" value="<cfoutput>#get_company.ims_code_id#</cfoutput>">
							<cfif len(get_company.ims_code_id)>
								<cfquery name="GET_IMS" datasource="#DSN#">
									SELECT * FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.ims_code_id#">
								</cfquery>
							</cfif>
							<input type="text" name="ims_code_name" id="ims_code_name" value="<cfif isdefined('get_ims')><cfoutput>#get_ims.ims_code# #get_ims.ims_code_name#</cfoutput></cfif>" style="width:162px;"><!--- readonly="yes"  --->
							<a href="javascript://" onClick="get_ims_code_div();"><img src="/images/plus_list.gif" border="0" align="absmiddle" class="form_icon"></a>						
						</td>
					</tr>
					<tr><td colspan="2"><div id="ims_code_div"></div></td></tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no="1140.Müşteri Değeri"></td>
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
						<td><input type="text" name="taxno" id="taxno" value="<cfif len(get_company.taxoffice)><cfoutput>#get_company.taxno#</cfoutput></cfif>" onKeyup="isNumber(this);" onblur="isNumber(this);" maxlength="12" style="width:193px;"></td>
					</tr>	
					<tr>
						<td class="infotag"><cf_get_lang_main no="1350.Vergi Dairesi"></td>
						<td>
							<input type="text" name="taxoffice" id="taxoffice" value="<cfif len(get_company.taxno)><cfoutput>#get_company.taxoffice#</cfoutput></cfif>" style="width:193px;">
						</td> 
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='16.E-posta'></td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no='16.E-posta'></cfsavecontent>
							<cfinput type="text" name="email" id="email" value="#get_company.company_email#" validate="email" message="#message#" maxlength="50" style="width:193px;">
						</td>
					</tr>	
					<tr>
						<td class="infotag"><cf_get_lang_main no='247.Satış Bölgesi'> *</td>
						<td>
							<cf_wrk_saleszone
								 name="sales_county"
								 width="200"
								 value="#get_company.sales_county#">	
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='1418.İlişki Şekli'> *</td>
						<td>
							<cf_wrk_combo 
								name="resource"
								query_name="GET_PARTNER_RESOURCE"
								value="#get_company.resource_id#"
								option_name="resource"
								option_value="resource_id"
								width="200">			    
						</td>			
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang no="36.Kod/Telefon">*</td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang no="178.Telefon Kodu"></cfsavecontent>
							<cfinput type="text" name="telcode" id="telcode" value="#get_company.company_telcode#" maxlength="5" onKeyup="isNumber(this);" onblur="isNumber(this);" message="#message#" required="yes" style="width:64px;">						
							<cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no="87.Telefon"></cfsavecontent>
							<cfinput type="text" name="telno" id="telno" value="#get_company.company_tel1#" maxlength="7" onKeyup="isNumber(this);" onblur="isNumber(this);" message="#message#" required="yes" style="width:118px;">
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no="1173.Kod"> / <cf_get_lang_main no="1070.Mobil Tel"></td>
						<td><select name="mobilcat_id" id="mobilcat_id" style="width:71px; vertical-align:top">
								<option selected value=""><cf_get_lang_main no='322.Seçiniz'>
								<cfoutput query="get_mobilcat">
									<option value="#mobilcat#" <cfif mobilcat is get_partner.mobil_code>selected</cfif>>#mobilcat#</option>
								</cfoutput>
							</select>
							<input type="text" name="mobiltel" id="mobiltel" maxlength="7" onKeyup="isNumber(this);" onblur="isNumber(this);" value="<cfoutput>#get_partner.mobiltel#</cfoutput>" style="width:118px;vertical-align:top">
						</td>
					</tr>
					<tr>
						<td style="vertical-align:top" class="infotag"><cf_get_lang_main no='1311.Adres'></td>
						<td>
							<cfsavecontent variable="msg"><cf_get_lang no='611.Adres Uzunluğu 200 Karakteri Geçemez!'></cfsavecontent>
							<textarea name="address" id="address" message="<cfoutput>#msg#</cfoutput>" maxlength="200" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);" style="width:194px; height:60px;"><cfoutput>#get_company.company_address#</cfoutput></textarea>
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='807.Ulke'> </td>
						<td><select name="country" id="country" onChange="remove_address('1');" style="width:200px;">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfoutput query="get_country">
									<option value="#get_country.country_id#" <cfif get_company.country eq get_country.country_id>selected</cfif>>#get_country.country_name#</option>
								</cfoutput>
							</select>
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='559.Sehir'> *</td>
						<td>
							<input type="hidden" name="city_id" id="city_id" value="<cfoutput>#get_company.city#</cfoutput>">
							<cfif len(get_company.city)>
								<cfquery name="GET_CITY" datasource="#DSN#">
									SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.city#">
								</cfquery>
							</cfif>
							<input type="text" name="city" id="city" value="<cfif isdefined('get_city')><cfoutput>#get_city.city_name#</cfoutput></cfif>"  style="width:162px;"><!--- readonly --->
							<a href="javascript://" onClick="get_city_div();"><img src="/images/plus_list.gif" border="0" align="absmiddle" class="form_icon"></a>
						</td>
					</tr>
					<tr><td colspan="2"><div id="city_div"></div></td></tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='1226.İlçe'> *</td>
						<td>
							<input type="hidden" name="county_id" id="county_id" value="<cfoutput>#get_company.county#</cfoutput>">
							<cfif len(get_company.county)>
								<cfquery name="GET_COUNTY" datasource="#DSN#">
									SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.county#">
								</cfquery>
							</cfif>
							<input type="text" name="county" id="county" value="<cfif isdefined('get_county')><cfoutput>#get_county.county_name#</cfoutput></cfif>" maxlength="30" style="width:162px;"><!--- readonly --->
							<a href="javascript://" onClick="get_county_div()"><img src="/images/plus_list.gif" border="0" align="absmiddle" class="form_icon"></a>
						</td>
					</tr>
					<tr><td colspan="2"><div id="county_div"></div></td></tr>
					<tr>
						<td class="infotag">Mahalle </td>
						<td>
							<input type="hidden" name="district_id" id="district_id" value="<cfif isdefined("attributes.county_id")><cfoutput>#attributes.county_id#</cfoutput></cfif>" readonly="">
							<input type="text" name="district" id="district" value="<cfif isdefined("attributes.county")><cfoutput>#attributes.county#</cfoutput></cfif>" maxlength="30" style="width:162px;"><!--- readonly --->
							<a href="javascript://" onClick="get_district_div();"><img src="/images/plus_list.gif" border="0" align="absmiddle" class="form_icon"></a>
						</td>
					</tr>
					<tr><td colspan="2"><div id="district_div"></div></td></tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='720.Semt'></td>
						<td>
							<input type="text" name="semt" id="semt" value="<cfoutput>#get_company.semt#</cfoutput>" maxlength="30" style="width:193px;" tabindex="15">
						</td>
					</tr>
					<tr><td colspan="2"><div id="kontrol_prerecord_div"></div></td></tr>
					<tr>
						<td height="30">&nbsp;</td>
						<td>
							<!---<cfif isdefined('session.pda.member_upd_company_process_id') and get_company.company_state is session.pda.member_upd_company_process_id>
								---><cf_workcube_buttons is_upd='1' add_function="kontrol()" is_delete='0'>
							<!--- </cfif>--->
						</td>
					</tr>
					<tr>
						<td colspan="2" class="infotag"><cf_get_lang_main no='71.Kayıt'>:
							<cfif len(get_company.record_emp)>
							  <cfoutput>#get_emp_info(get_company.record_emp,0,0)#</cfoutput>
							</cfif> - <cfoutput>#dateformat(date_add('h',session.pda.time_zone,get_company.record_date),'dd/mm/yyyy')# - #timeformat(date_add('h',session.pda.time_zone,get_company.record_date),'HH:MM')#</cfoutput> 
						</td>
					</tr>
					<cfif len(get_company.update_emp)>
						<tr>
							<td colspan="2" class="infotag"><cf_get_lang_main no='291.Güncelleme'>:
								<cfoutput>#get_emp_info(get_company.update_emp,0,0)#</cfoutput>
								- <cfoutput>#dateformat(date_add('h',session.pda.time_zone,get_company.update_date),'dd/mm/yyyy')# - #timeformat(date_add('h',session.pda.time_zone,get_company.update_date),'HH:MM')#</cfoutput> 
							</td>
						</tr>
					</cfif>
				</table>
			</td>
		</tr>
	</table>
</cfform>
<br>
<script type="text/javascript">
	function remove_address(parametre)
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
	
	function get_city_div()//&field_id=form_add_company.city_id&field_name=form_add_company.city&field_phone_code=form_add_company.telcod+'&div_name='+'city_div'
	{
		x = document.form_add_company.country.selectedIndex;
		if (document.form_add_company.country[x].value == "")
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='807.Ülke'>");
		}	
		else
		{
			goster(city_div);
			AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_get_city_div&country_id='+document.form_add_company.country.value+'&keyword='+encodeURI(document.form_add_company.city.value),'city_div');
		}
		return remove_address('2');
	}
	function add_city_div(city_id,city,phone_code)
	{
		document.getElementById('city_id').value = city_id;
		document.getElementById('city').value = city;
		document.getElementById('telcode').value = phone_code;
		gizle(city_div);
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
	function get_county_div()//&field_id=form_add_company.county_id&field_name=form_add_company.county+'&div_name='+'county_div'
	{
		x = document.form_add_company.country.selectedIndex;
		if (document.form_add_company.country[x].value == "")
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='807.Ülke'>");
		}	
		else if(document.getElementById('city_id').value == "")
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1196.Il'>");
		}
		else
		{
			goster(county_div);
			AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_get_county_div&city_id=' + document.form_add_company.city_id.value+'&keyword='+encodeURI(document.form_add_company.county.value),'county_div');
			return remove_address();
		}
	}	
	function add_consumer_div(consumer_name, consumer_surname)
	{
		document.getElementById('name').value = consumer_name;
		document.getElementById('surname').value = consumer_surname;
		document.getElementById('related_consumer_name').value = consumer_name + ' ' + consumer_surname;
		gizle(control_consumer_div);
	}
	function add_county_div(county_id,county)
	{
		document.getElementById('county_id').value = county_id;
		document.getElementById('county').value = county;
		gizle(county_div);
	}
	function get_ims_code_div()//&field_name=form_add_company.ims_code_name&field_id=form_add_company.ims_code_id+'&div_name='+'ims_code_div'
	{
		goster(ims_code_div);
		AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_get_ims_code_div&keyword='+encodeURI(form_add_company.ims_code_name.value),'ims_code_div');		
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
	
	function add_ims_code_div(ims_code,ims_code_id,ims_code_name)
	{
		document.getElementById('ims_code_id').value = ims_code_id;
		document.getElementById('ims_code_name').value = ims_code + ' ' + ims_code_name;
		gizle(ims_code_div);
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
	
	function kontrol()
	{
		if(document.getElementById('fullname').value == "")
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='159.Ünvan'>");
			document.getElementById('fullname').focus();
			return false;
		}
		if(document.getElementById('nickname').value == "")
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='339.Kısa Ad'>");
			document.getElementById('nickname').focus();
			return false;
		}
		
		x = document.getElementById('companycat_id').selectedIndex;
		if (document.getElementById('companycat_id')[x].value == "")
		{ 
			alert ("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='131.Şirket Kategorisi'>!");
			document.getElementById('companycat_id').focus();
			return false;
		}
		
		if(document.getElementById('name').value == "")
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang no='187.Yetkili Adı'>");
			return false;
		}
		if(document.getElementById('surname').value == "")
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1138.Soyadı'>");
			return false;
		}
		
		if(document.getElementById('ims_code_name').value == "")
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='722.Mikro Bölge Kodu'>");
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
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='1418.İlişki Şekli'>");
			document.getElementById('resource').focus();
			return false;
		}
		if(document.getElementById('city_id').value == "")
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='559.Şehir'>");
			return false;
		}
		if(document.getElementById('county_id').value == "")
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1226.İlçe'>");
			return false;
		}
		if(document.getElementById('ims_code_id').value == "")
		{
			alert("<cf_get_lang_main no='722.Mikro Bölge Kodu'> : <cf_get_lang_main no='722.Mikro Bölge Kodu'>");
			return false;
		}		
	
		if(!kontrol_prerecord())
			return false;
	}
	
	function kontrol_prerecord()
	{
		goster(kontrol_prerecord_div);
		AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_check_company_div&fullname='+ encodeURI(form_add_company.fullname.value) +'&nickname=' + encodeURI(form_add_company.nickname.value) +'&tel_code='+ form_add_company.telcod.value +'&telefon=' + form_add_company.tel1.value +'&div_name='+'kontrol_prerecord_div' +'&form_id=' + 'form_add_company' +'&company_id=' + form_add_company.company_id.value,'kontrol_prerecord_div');		
		return false;
	}
	
	document.getElementById('fullname').focus();
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->

