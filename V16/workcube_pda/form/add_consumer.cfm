<cf_get_lang_set module_name="member">
<cfquery name="GET_MOBILCAT" datasource="#DSN#">
	SELECT MOBILCAT_ID,MOBILCAT FROM SETUP_MOBILCAT ORDER BY MOBILCAT ASC
</cfquery>
<cfquery name="GET_COUNTRY" datasource="#DSN#">
	SELECT COUNTRY_ID,COUNTRY_NAME,IS_DEFAULT FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
</cfquery>
<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT CONSCAT_ID, CONSCAT FROM CONSUMER_CAT ORDER BY CONSCAT
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
		<td class="headbold"><cf_get_lang_main no='1610.Bireysel Üye Ekle'></td>
	</tr>
</table>
<cfform name="add_consumer" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=pda.emptypopup_add_consumer">
	<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%">	
		<tr>
			<td class="color-row"> 
				<table align="center" style="width:99%">
					<tr>
						<td class="infotag" style="width:30%"><cf_get_lang_main no="158.Ad Soyad">*</td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no="219.Ad"></cfsavecontent>
							<cfif isdefined("attributes.consumer_name")>
								<cfinput type="text" name="consumer_name" id="consumer_name" required="yes" message="#message#" maxlength="30" style="width:70px;" value="#attributes.consumer_name#">
							<cfelse>
								<cfinput type="text" name="consumer_name" id="consumer_name" required="yes" message="#message#" maxlength="30" style="width:70px;" value="">				  
							</cfif>  
							<cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no="1314.Soyad"></cfsavecontent>
							<cfif isdefined("attributes.consumer_surname")>
								<cfinput type="text" name="consumer_surname" id="consumer_surname" required="yes" message="#message#" maxlength="30" style="width:112px;" value="#attributes.consumer_surname#">
							<cfelse>
								<cfinput type="text" name="consumer_surname" id="consumer_surname" required="yes" message="#message#" maxlength="30" style="width:112px;" value="">				  
							</cfif>
						</td>
					</tr>
					<tr>
						<td class="infotag">Üye Kategorisi *</td>
						<td>
							<select name="consumer_cat_id" id="consumer_cat_id" style="width:200px;">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfoutput query="get_consumer_cat">
									<option value="#conscat_id#">#conscat#</option>
								</cfoutput>
							</select>
						</td>
					</tr>
					<cfif isdefined('xml_is_resource_id') and xml_is_resource_id neq 0>
						<tr>
							<td class="infotag"><cf_get_lang_main no='1418.İlişki Şekli'> <cfif isdefined('xml_is_resource_id') and xml_is_resource_id eq 2> * </cfif></td>
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
					</cfif>
					<cfif isdefined('xml_is_customer_value') and xml_is_customer_value neq 0>
						<tr>
							<td class="infotag">Müşteri Değeri <cfif isdefined('xml_is_customer_value') and xml_is_customer_value eq 2> * </cfif></td>
							<td>
								<select name="customer_value" id="customer_value" style="width:200px;">
									<option value=""><cf_get_lang_main no='322.seçiniz'></option>
									<cfoutput query="get_customer_value">
										<option value="#customer_value_id#">#customer_value#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
					</cfif>
					<cfif isdefined('xml_is_sales_county') and xml_is_sales_county neq 0>
						<tr>
							<td class="infotag"><cf_get_lang_main no='247.Satış Bölgesi'> <cfif isdefined('xml_is_sales_county') and xml_is_sales_county neq 2> * </cfif></td>
							<td>
								<cf_wrk_saleszone
									 name="sales_county"
									 width="200"
									 tabindex="7"
									 value="">	
							</td>
						</tr>
					</cfif>
					<cfif isdefined('xml_ims_code_id') and xml_ims_code_id neq 0>
						<tr>
							<td class="infotag"><cf_get_lang_main no='722.Mikro Bölge Kodu'> <cfif isdefined('xml_ims_code_id') and xml_ims_code_id neq 2> * </cfif></td>
							<td>
								<input type="hidden" name="ims_code_id" id="ims_code_id" value="">
								<input type="text" name="ims_code_name" id="ims_code_name" value="" style="width:162px;" readonly="readonly">
								<a href="javascript://"onClick="get_ims_code_div();" tabindex="7"><img src="/images/plus_list.gif" border="0" align="absmiddle" class="form_icon"></a>				
							</td>
						</tr>
					</cfif>
					<tr><td colspan="2"><div id="ims_code_div"></div></td></tr>
					<tr>
						<td class="infotag">Internet Adresi</td>
						<td>
							<input type="text" name="homepage" id="homepage" style="width:193px;" maxlength="50">
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='1195.Firma'></td>	
						<td><input type="text" name="company" id="company" value="<cfif isdefined("attributes.company")><cfoutput>#attributes.company#</cfoutput></cfif>" maxlength="40" style="width:193px;"></td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='340.Vergi No'></td>
						<td>
							<input type="text" name="tax_no" id="tax_no" value="" onKeyup="isNumber(this);" onblur="isNumber(this);" maxlength="10" style="width:193px;">
						</td> 
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='16.E-Posta'></td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang_main no="65.Hatalı Veri"> : <cf_get_lang_main no='16.E-Posta'></cfsavecontent>
							<cfinput type="text" name="consumer_email" id="consumer_email" maxlength="40" validate="email" message="#message#" style="width:193px;" value="">				
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='87.Telefon'></td>
						<td>
							<input text="text" name="home_telcode" id="home_telcode" onKeyup="isNumber(this);" onblur="isNumber(this);" maxlength="5" style="width:64px;" value="<cfif isdefined("attributes.home_telcode")>#attributes.home_telcode#</cfif>">
							<input type="text" name="home_tel" id="home_tel" onKeyup="isNumber(this);" onblur="isNumber(this);" maxlength="9" style="width:118px;" value="<cfif isdefined("attributes.home_tel")>#attributes.home_tel#</cfif>">
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='76.Fax'></td>
						<td>
							<input type="text" name="work_faxcode" id="work_faxcode" onKeyup="isNumber(this);" onblur="isNumber(this);" maxlength="5" style="width:64px;" value="<cfif isdefined("attributes.work_faxcode")>#attributes.work_faxcode#</cfif>">		  
							<input type="text" name="work_fax" id="work_fax" onKeyup="isNumber(this);" onblur="isNumber(this);" maxlength="9" style="width:118px;" value="<cfif isdefined("attributes.work_fax")>#attributes.work_fax#</cfif>">
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='1070.Mobil Tel'></td>
						<td>
							<select name="mobilcat_id" id="mobilcat_id" style="width:71px;">
								<option value=""><cf_get_lang_main no='1173.Kod'></option>
								<cfoutput query="get_mobilcat">
									<option value="#mobilcat#" <cfif isdefined("attributes.mobilcat_id") and attributes.mobilcat_id eq mobilcat>selected</cfif>>#mobilcat#</option>
								</cfoutput>
							</select>
							<input type="text" name="mobiltel" id="mobiltel" onKeyup="isNumber(this);" onblur="isNumber(this);" maxlength="9" style="width:118px; vertical-align:top" value="<cfif isdefined("attributes.mobiltel")>#attributes.mobiltel#</cfif>">
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='807.Ülke'></td>
						<td>
							<select name="home_country" id="home_country" onChange="remove_adress('1','home');" style="width:200px;">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfoutput query="get_country">
									<option value="#get_country.country_id#" <cfif is_default eq 1>selected</cfif>>#get_country.country_name#</option>
								</cfoutput>
							</select>
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='559.Şehir'></td>
						<td>
							<input type="hidden" name="home_city_id" id="home_city_id" value="<cfif isdefined("attributes.home_city_id")><cfoutput>#attributes.home_city_id#</cfoutput></cfif>">
							<input type="text" name="home_city" id="home_city" value="<cfif isdefined("attributes.home_city")><cfoutput>#attributes.home_city#</cfoutput></cfif>" readonly style="width:162px;">
							<a href="javascript://" onClick="get_city_div();"><img src="/images/plus_list.gif" border="0" align="absmiddle" class="form_icon"></a>
						</td>
					</tr>
					<tr><td colspan="2"><div id="city_div"></div></td></tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='1226.İlçe'></td>
						<td>
							<input type="hidden" name="home_county_id" id="home_county_id" value="<cfif isdefined("attributes.home_county_id")><cfoutput>#attributes.home_county_id#</cfoutput></cfif>" readonly="">
							<input type="text" name="home_county" id="home_county" value="<cfif isdefined("attributes.home_county")><cfoutput>#attributes.home_county#</cfoutput></cfif>" readonly style="width:162px;">
							<a href="javascript://" onClick="get_county_div();"><img src="/images/plus_list.gif" border="0" align="absmiddle" class="form_icon"></a>
						</td>
					</tr>
					<tr><td colspan="2"><div id="county_div"></div></td></tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='720.Semt'></td>
						<td><input type="text" name="homesemt" id="homesemt" value="" maxlength="30" style="width:193px;"></td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='60.Posta Kodu'></td>
						<td><input type="text" name="homepostcode" id="homepostcode" onKeyup="isNumber(this);" onblur="isNumber(this);" value="" maxlength="15" style="width:193px;"></td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no='1311.Adres'></td>
						<td><textarea name="homeaddress" id="homeaddress" style="width:194px;height:60px;"></textarea></td>
					</tr>
					<tr>
						<td></td>
						<td align="left"><cf_workcube_buttons is_upd='0' add_function="kontrol()"></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</cfform>
<script type="text/javascript">
	function remove_adress(parametre,type)
	{
		if(type=='work')
		{
			if(parametre==1)
			{
				document.getElementById('work_city_id').value = '';
				document.getElementById('work_city').value = '';
				document.getElementById('work_county_id').value = '';
				document.getElementById('work_county').value = '';
				document.getElementById('work_telcode').value = '';
				document.getElementById('work_faxcode').value = '';			
			}
			else
			{
				document.getElementById('work_county_id').value = '';
				document.getElementById('work_county').value = '';
			}
		
		}	
		else if(type=='home')
		{
			if(parametre==1)
			{
				document.getElementById('home_city_id').value = '';
				document.getElementById('home_city').value = '';
				document.getElementById('home_county_id').value = '';
				document.getElementById('home_county').value = '';
				document.getElementById('home_telcode').value = '';		
			}
			else
			{
				document.getElementById('home_county_id').value = '';
				document.getElementById('home_county').value = '';
			}
		}
		else if(type=='tax')
		{
			if(parametre==1)
			{
				document.getElementById('tax_city_id').value = '';
				document.getElementById('tax_city').value = '';
				document.getElementById('tax_county_id').value = '';
				document.getElementById('tax_county').value = '';
			}
			else
			{
				document.getElementById('tax_county_id').value = '';
				document.getElementById('tax_county').value = '';
			}
		}	
	}
	
	function get_ims_code_div()//&field_name=form_add_company.ims_code_name&field_id=form_add_company.ims_code_id+'&div_name='+'ims_code_div'
	{
		goster(ims_code_div);
		AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_get_ims_code_div&keyword='+encodeURI(document.getElementById('ims_code_name').value),'ims_code_div');		
	}
	
	function add_city_div(city_id,city,phone_code)
	{
		document.getElementById('home_city_id').value = city_id;
		document.getElementById('home_city').value = city;
		//document.getElementById('telcod').value = phone_code;
		gizle(city_div);
	}
	
	function add_county_div(county_id,county)
	{
		document.getElementById('home_county_id').value = county_id;
		document.getElementById('home_county').value = county;
		gizle(county_div);
	}
		
	function get_county_div()//&field_id=form_add_company.county_id&field_name=form_add_company.county+'&div_name='+'county_div'
	{
		x = document.getElementById('home_country').selectedIndex;
		if (document.getElementById('home_country')[x].value == "")
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='807.Ülke'>");
		}	
		else if(document.getElementById('home_city_id').value == "")
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1196.Il'>");
		}
		else
		{
			goster(county_div);
			AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_get_county_div&city_id=' + document.getElementById('home_city_id').value+'&keyword='+encodeURI(document.getElementById('home_county').value),'county_div');
			return remove_adress();
		}
	}

	
	function get_city_div()
	{
		x = document.getElementById('home_country').selectedIndex;
		if (document.getElementById('home_country')[x].value == "")
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='807.Ülke'>");
		}	
		else
		{
			goster(city_div);
			AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_get_city_div&country_id='+document.getElementById('home_country').value+'&keyword='+encodeURI(document.getElementById('home_city').value),'city_div');
		}
		return remove_adress('2');
	}
	
	function add_ims_code_div(ims_code,ims_code_id,ims_code_name)
	{
		document.getElementById('ims_code_id').value = ims_code_id;
		document.getElementById('ims_code_name').value = ims_code + ' ' + ims_code_name;	
		gizle(ims_code_div);
	}
	

	function kontrol()
	{
		x = document.getElementById('consumer_cat_id').selectedIndex;
		if (document.getElementById('consumer_cat_id')[x].value == "")
		{ 
			alert ("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1295.Bireysel Üye Kategorisi'>");
			return false;
		}
		
		<cfif isdefined('xml_is_resource_id') and xml_is_resource_id eq 2>
			x = document.getElementById('resource').selectedIndex;
			if (document.getElementById('resource')[x].value == "")
			{ 
				alert ("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1418.ilişki şekli'>");
				return false;
			}
		</cfif>
		
		<cfif isdefined('xml_is_customer_value') and xml_is_customer_value eq 2>
			x = document.getElementById('customer_value').selectedIndex;
			if (document.getElementById('customer_value')[x].value == "")
			{ 
				alert ("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1140.müşteri değeri'>");
				return false;
			}
		</cfif>
		
		<cfif isdefined('xml_is_sales_county') and xml_is_sales_county neq 2>
			x = document.getElementById('sales_county').selectedIndex;
			if (document.getElementById('sales_county')[x].value == "")
			{ 
				alert ("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='247.satış bölgesi'>");
				return false;
			}	
		</cfif>
		
		<cfif isdefined('xml_ims_code_id') and xml_ims_code_id neq 2>
			x = document.getElementById('ims_code_id').selectedIndex;
			if (document.getElementById('ims_code_id')[x].value == "")
			{ 
				alert ("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='722.mikro bölge kodu'>");
				return false;
			}	
		</cfif>	
	}	
		
	document.getElementById('consumer_name').focus();
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
