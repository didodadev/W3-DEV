<cfif isdefined('attributes.comp_id') and len(attributes.comp_id) and isdefined('attributes.partner_id') and len(attributes.partner_id)>
	<cfquery name="GET_PARTNER_" datasource="#DSN#">
		SELECT 
			COMPANY_PARTNER_NAME,
			COMPANY_PARTNER_SURNAME,
			TITLE,
			MOBIL_CODE,
			MOBILTEL,
			MISSION,
			DEPARTMENT,
			COUNTRY,
			CITY,
			COUNTY,
			COMPANY_PARTNER_TELCODE,
			COMPANY_PARTNER_TEL,
			COMPANY_PARTNER_ADDRESS,
			COMPANY_PARTNER_FAX,
			COMPANY_PARTNER_EMAIL,
			RECORD_PAR,
			RECORD_DATE,
			RECORD_IP,
			RECORD_MEMBER,
			UPDATE_PAR,
			UPDATE_DATE,
			UPDATE_IP,
			UPDATE_MEMBER    
		FROM 
			COMPANY_PARTNER 
		WHERE 
			PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#"> AND 
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#">
	</cfquery>
<cfelse>
	<cfset get_partner_.recordcount = 0>
</cfif>
<cfif not get_partner_.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='499.Yetki Dışı Erişim Yapamazsınız'>!");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfinclude template="../query/get_country.cfm">
<cfinclude template="../query/get_mobilcat.cfm">
<cfinclude template="../query/get_partner_positions.cfm">
<cfinclude template="../query/get_partner_departments.cfm">
<table align="center" cellpadding="2" cellspacing="1" border="0" style="width:100%">
	<tr>
		<td>
	    	<table border="0">
    			<cfform name="form_upd_partner" method="post" action="#request.self#?fuseaction=objects2.emptypopup_upd_my_partner&partner_id=#attributes.partner_id#">  
		   		<input type="hidden" name="comp_id" id="comp_id" value="<cfif isdefined('attributes.comp_id') and len(attributes.comp_id)><cfoutput>#attributes.comp_id#</cfoutput></cfif>"> 
		  		<tr>
					<td class="txtboldblue" colspan="4"><cf_get_lang_main no='166.Yetkili'></td>
		  		</tr>
		  		<tr>
					<td><cf_get_lang_main no='219.Ad'> *</td>
					<td><cfsavecontent variable="message"><cf_get_lang no='497.Lütfen Yetkili Ad Giriniz'></cfsavecontent>
						<cfif len(get_partner_.company_partner_name)>
							<cfinput type="text" name="name" id="name" value="#get_partner_.company_partner_name#" maxlength="50" required="yes" message="#message#" style="width:150px;" tabindex="32">
						<cfelse>
							<cfinput type="text" name="name" id="name" value="" maxlength="50" required="yes" message="#message#" style="width:150px;" tabindex="32">
						</cfif>
						<input type="hidden" name="company_partner_status" id="company_partner_status" value="1"></td>
					<td><cf_get_lang_main no='1314.Soyad'> *</td>
					<td  style="text-align:right;">
						<cfsavecontent variable="message"><cf_get_lang no='237.Lütfen Soyad Giriniz'></cfsavecontent>
						<cfif len(get_partner_.company_partner_surname)>
							<cfinput type="text" name="soyad" id="soyad" value="#get_partner_.company_partner_surname#" maxlength="50" required="yes" message="#message#" style="width:150px;" tabindex="33">
						<cfelse>
							<cfinput type="text" name="soyad" id="soyad" value="" maxlength="50" required="yes" message="#message#" style="width:150px;" tabindex="33">
						</cfif>
					</td>	
		  		</tr>
		  		<tr>
					<td><cf_get_lang_main no='159.Unvan'></td>
					<td><input  type="text" name="title" id="title" value="<cfoutput>#get_partner_.title#</cfoutput>" style="width:150px;" maxlength="50" tabindex="34"></td>
					<td><cf_get_lang_main no='352.Cinsiyet'></td>
					<td  style="text-align:right;">
						<select name="sex" id="sex" style="width:150px;" tabindex="35">
							<option value="1" <cfif isdefined("get_partner_.sex") and get_partner_.sex eq 1>selected</cfif>><cf_get_lang_main no='1547.Erkek'></option>
							<option value="2" <cfif isdefined("get_partner_.sex") and get_partner_.sex eq 0>selected</cfif>><cf_get_lang_main no='1546.Kadin'></option>
			  			</select>
					</td>
		  		</tr>
		  		<tr>
					<td><cf_get_lang_main no='1173.Kod'> /<cf_get_lang_main no='1070.Mobil Tel'></td>
					<td>
						<select name="mobilcat_id" id="mobilcat_id"  style="width:60px;" tabindex="38">
						<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="get_mobilcat">
							  	<option value="#mobilcat#" <cfif mobilcat eq get_partner_.mobil_code>selected</cfif>>#mobilcat#</option>
							</cfoutput>
					  	</select>
					  	<input type="text" name="mobiltel" id="mobiltel" maxlength="20"  value="<cfoutput>#get_partner_.mobiltel#</cfoutput>" onKeyUp="isNumber(this);" style="width:86px;" tabindex="38"></td>
					<td><cf_get_lang_main no='161.Gorev'></td>
					<td><select name="mission" id="mission" style="width:150px;" tabindex="36">
						<option value=""><cf_get_lang_main no='161.Grev'></option>
							<cfoutput query="get_partner_positions">
						  		<option value="#partner_position_id#" <cfif partner_position_id eq get_partner_.mission>selected</cfif>>#partner_position#</option>
							</cfoutput>
			  			</select>
					</td> 
				</tr>
				<tr>
					<td><cf_get_lang no='231.Dahili Tel'></td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					  	<input type="text" name="tel_local" id="tel_local" maxlength="5" value="" onKeyUp="isNumber(this);" style="width:86px;" tabindex="39">
					</td>
					<td><cf_get_lang_main no='160.Departman'></td>
					<td  style="text-align:right;">
					  	<select name="department" id="department" style="width:150px;" tabindex="37">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="get_partner_departments">
							  	<option value="#partner_department_id#" <cfif partner_department_id eq get_partner_.department>selected</cfif>>#partner_department#</option>
							</cfoutput>
					  	</select>
					</td>
				</tr>
				<tr>
		 			<td><cf_get_lang_main no='807.Ülke'></td>
			 	 	<td>
						<select name="part_country" id="part_country" onChange="LoadCity(this.value,'part_city_id','part_county_id');remove_adress('1');" style="width:150px;">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="get_country">
								<option value="#get_country.country_id#" <cfif get_country.country_id eq get_partner_.country>selected</cfif>>#get_country.country_name#</option>
							</cfoutput>
				  		</select>
			  		</td>
		   			<td><cf_get_lang_main no='559.Şehir'></td>
		  			<td>			
						<select name="part_city_id" id="part_city_id" style="width:150px;" onChange="LoadCounty(this.value,'part_county_id')">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfquery name="GET_CITY" datasource="#DSN#">
								SELECT CITY_ID,CITY_NAME FROM SETUP_CITY <cfif len(get_partner_.country)>WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_partner_.country#"></cfif>
							</cfquery>
							<cfoutput query="get_city">
								<option value="#city_id#" <cfif get_partner_.city eq city_id>selected</cfif>>#city_name#</option>
							</cfoutput>
						</select>
		  			</td>
		 		</tr>
		 		<tr>
		 			<td><cf_get_lang_main no='1226.İlçe'></td>
		  			<td>
						<select name="part_county_id" id="part_county_id" style="width:150px;">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfquery name="GET_COUNTY" datasource="#DSN#">
								SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY <cfif len(get_partner_.city)>WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_partner_.city#"></cfif>
							</cfquery>
							<cfoutput query="get_county">
								<option value="#county_id#" <cfif get_partner_.county eq county_id>selected</cfif>>#county_name#</option>
							</cfoutput>
						</select>
		  			</td>
		   			<td><cf_get_lang_main no='1173.Kod'>/<cf_get_lang_main no='87.Telefon'></td>
		  			<td>
						<input type="text" name="part_telcod" id="part_telcod" onKeyUp="isNumber(this);" maxlength="3" style="width:45;" value="<cfoutput>#get_partner_.company_partner_telcode#</cfoutput>">
					 	<input type="text" name="part_tel1" id="part_tel1" onKeyUp="isNumber(this);" maxlength="7" style="width:103;" value="<cfoutput>#get_partner_.company_partner_tel#</cfoutput>">
		  			</td>
		 		</tr> 
				<tr>
					<td rowspan="2" style="vertical-align:top"><cf_get_lang_main no='1311.Adres'></td>
					<td rowspan="2"><textarea name="part_adres" id="part_adres" style="width:150px;height:50px;"><cfoutput>#get_partner_.company_partner_address#</cfoutput></textarea></td>
					<td><cf_get_lang_main no='1173.Kod'> / <cf_get_lang_main no='1061.Mobil'></td>
					<td>
						<select name="part_mobilcat_id" id="part_mobilcat_id" style="width:55px;">
							<option value=""><cf_get_lang_main no='1173.Kod'></option>
							<cfoutput query="get_mobilcat">
								<option value="#mobilcat#" <cfif get_partner_.mobil_code eq mobilcat>selected</cfif>>#mobilcat#</option>
							</cfoutput>
						</select>
						<input type="text" name="part_mobiltel" id="part_mobiltel" value="<cfoutput>#get_partner_.mobiltel#</cfoutput>" onKeyUp="isNumber(this);" maxlength="10" tabindex="2" style="width:91px;">
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='76.Fax'></td>
				  	<td>
						<input type="text" name="part_fax" id="part_fax" value="<cfoutput>#get_partner_.company_partner_fax#</cfoutput>" onKeyUp="isNumber(this);" maxlength="7" style="width:150px;">
					</td>
				</tr> 
				<tr>
					<td style="vertical-align:top"><cf_get_lang_main no='667.İnternet'></td>
				  	<td style="vertical-align:top"><input type="text" name="part_homepage" id="part_homepage" style="width:150px;" maxlength="50" value="http://"></td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='16.E-posta'></td>
					<td><cfsavecontent variable="message"><cf_get_lang_main no='1072.Lütfen Geçerli Bir E-mail Adresi Giriniz'></cfsavecontent>
						<cfinput type="text" name="company_partner_email" id="company_partner_email" value="#get_partner_.company_partner_email#" validate="email" message="#message#" maxlength="50" style="width:150px;" tabindex="40">
					</td>
				</tr>
				<tr>
					<td colspan="4">
						<cfoutput>
						<cf_get_lang_main no='71.Kayıt'> :
						<cfif len(get_partner_.record_par)>
							#get_par_info(get_partner_.record_par,0,-1,0)#
						<cfelseif len(get_partner_.record_member)>
							#get_emp_info(get_partner_.record_member,0,0)#
						</cfif>
						<cfif len(get_partner_.record_date)> - #dateformat(date_add('h',session.pp.time_zone,get_partner_.record_date),'dd/mm/yyyy')# #timeformat(date_add('h',session.pp.time_zone,get_partner_.record_date),'HH:MM')#</cfif>&nbsp;
						<cfif len(get_partner_.update_member) or len(get_partner_.update_par)>
							<br/><cf_get_lang_main no='291.Son Güncelleme'> : 
							<cfif len(get_partner_.update_member)>
								#get_emp_info(get_partner_.update_member,0,0)#
							<cfelseif len(get_partner_.update_par)>
								#get_par_info(get_partner_.update_par,0,-1,0)#
							</cfif> - #dateformat(date_add('h',session.pp.time_zone,get_partner_.update_date),'dd/mm/yyyy')# #timeformat(date_add('h',session.pp.time_zone,get_partner_.update_date),'HH:MM')#
						</cfif>
						</cfoutput>
					</td>
				</tr>	
				<tr>
					<td colspan="4"  style="text-align:right;"><cf_workcube_buttons is_upd='1' is_delete='0' add_function="kontrol()"></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</cfform>
<script type="text/javascript">
<!---function kontrol()
{
	for (var i = 1; i < form_upd_partner.tel_local.value.length; i++)
	{
		fax_number = numberformat.indexOf(form_upd_partner.tel_local.value.charAt(i));
		if (fax_number < 0)
		{
			alert("<cf_get_lang no='496.Dahili Sayisal Olmalidir'> !");
			form_upd_partner.tel_local.focus();
			return false;
		}
	}
	if(document.form_upd_partner.name.value == "")
	{
		alert("<cf_get_lang no='497.Lütfen Yetkili Ad Giriniz'> !");
		form_upd_partner.name.focus();
		return false;
	}
	if(document.form_upd_partner.soyad.value == "")
	{
		alert("<cf_get_lang no='237.Lütfen Soyad Giriniz'> !");
		form_upd_partner.soyad.focus();
		return false;
	}*/

	<cfif isdefined("attributes.type")>
	if(form_upd_partner.telcod.value == "")
	{
		alert("<cf_get_lang no='21.Lütfen Telefon Kodu Giriniz'>!");
		return false;
	}
	if(form_upd_partner.title.value == "")
	{
		alert("<cf_get_lang no='498.Lütfen Ünvan Giriniz'> !");
		return false;
	}
	</cfif>
}--->
	document.getElementById('name').focus();
</script>
