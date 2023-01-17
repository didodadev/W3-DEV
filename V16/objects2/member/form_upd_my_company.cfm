<cfset url.cpid = session.pp.company_id>
<cfset attributes.cpid = session.pp.company_id>
<cfquery name="GET_COMPANY" datasource="#DSN#">
	SELECT 
		C.COMPANY_ID,
		C.NICKNAME,
		C.FULLNAME,
		C.TAXNO,
		C.TAXOFFICE,
		C.COMPANY_TELCODE,
		C.COMPANY_TEL1,
		C.COMPANY_TEL2,
		C.COMPANY_TEL3,
		C.COMPANY_FAX,
		C.COMPANY_EMAIL,
		C.COMPANY_ADDRESS,
		C.COMPANY_POSTCODE,
		C.MANAGER_PARTNER_ID,
		C.COMPANY_ID,
		C.HOMEPAGE AS WEB,
		C.SEMT AS COMPANY_SEMT,
		C.COUNTY AS COMPANY_COUNTY,
		C.COUNTRY AS COMPANY_COUNTRY,
		C.CITY AS COMPANY_CITY,
        CP.TITLE,
        CP.COMPANY_PARTNER_EMAIL,
        CP.COMPANY_PARTNER_TEL,
        CP.COMPANY_PARTNER_FAX,
        CP.PARTNER_ID,
        CP.COMPANY_PARTNER_NAME,
        CP.COMPANY_PARTNER_SURNAME,
		CP.COMPANY_ID,
		CP.HOMEPAGE,
		CP.SEMT,
		CP.COUNTY,
		CP.COUNTRY,
		CP.CITY
	FROM 
		COMPANY C, 
		COMPANY_PARTNER CP
	WHERE
		CP.COMPANY_ID = C.COMPANY_ID AND
		C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">
</cfquery>
<cfquery name="GET_WORKGROUP_POSITION" datasource="#DSN#">
	SELECT
		COMPANY_ID,
		OUR_COMPANY_ID,
		POSITION_CODE,
		IS_MASTER
	FROM
		WORKGROUP_EMP_PAR
	WHERE
		COMPANY_ID IS NOT NULL AND
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#"> AND
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
		IS_MASTER = 1
</cfquery>
<cfinclude template="../query/get_country.cfm">
<cfform name="upd_my_company" method="post" action="#request.self#?fuseaction=objects2.emptypopup_upd_my_company" enctype="multipart/form-data">
<cfoutput>
<input type="hidden" name="old_fullname" id="old_fullname" value="#get_company.fullname#">
<cfif isdefined('attributes.orderww_back') and len(attributes.orderww_back)>
	<input type="hidden" name="orderww_back" id="orderww_back" value="#attributes.orderww_back#">
	<input type="hidden" name="grosstotal" id="grosstotal" value="#attributes.grosstotal#">
</cfif>
<table border="0" cellspacing="0" cellpadding="0" align="center" style="width:100%">
	<tr>
		<td>
			<table align="center" style="width:100%">
				<tr class="color-row" style="height:20px;">
					<td class="txtbold" style="width:20%;"><cf_get_lang no='229.Şirket Ünvanı'> *</td>
					<td style="width:30%;">
						<cfsavecontent variable="message"><cf_get_lang no='498.Lütfen Ünvan Giriniz'></cfsavecontent>
						<cfif isdefined('attributes.is_fullname_readonly') and attributes.is_fullname_readonly eq 1>
							<cfinput type="text" name="fullname" id="fullname" value="#get_company.fullname#" maxlength="250" style="width:220px;" readonly>
						<cfelse>
							<cfinput type="text" name="fullname" id="fullname" value="#get_company.fullname#" required="yes" message="#message#" maxlength="250" style="width:220px;">
						</cfif>
					</td>
					<td class="txtbold" style="width:20%;"><cf_get_lang_main no='87.Telefon'> 1</td>
					<td class="color-row">
						<input type="text" name="company_telcode" id="company_telcode"  onkeyup="isNumber(this);" value="#get_company.company_telcode#" maxlength="5" style="width:57px;">
						<input type="text" name="company_tel1" id="company_tel1" onkeyup="isNumber(this);" value="#get_company.company_tel1#" maxlength="10" style="width:90px;">
					</td>
				</tr>
				<tr class="color-row" style="height:20px;">
					<td class="txtbold"><cf_get_lang_main no='339.Kısa Ad'></td>
					<td><input type="text" name="nickname" id="nickname" value="#get_company.nickname#" maxlength="25" style="width:220px;"></td>
					<td class="txtbold"><cf_get_lang_main no='87.Telefon'> 2</td>
					<td><input type="text" name="company_tel2" id="company_tel2" value="#get_company.company_tel2#" onkeyup="isNumber(this);" maxlength="10" style="width:150px;"></td>
				</tr>
				<tr class="color-row" style="height:20px;">
					<td class="txtbold"><cf_get_lang_main no='1714.Yönetici'></td>
					<td>
						<select name="manager_partner_id" id="manager_partner_id"  style="width:220px;">
							<option value=""><cf_get_lang_main no='1714.Yönetici'></option>
							<cfloop query="get_company">
								<option value="#partner_id#" <cfif partner_id eq get_company.manager_partner_id>selected</cfif>>#company_partner_name# #company_partner_surname#</option>
							</cfloop>
						</select>
					</td>
					<td class="txtbold"><cf_get_lang_main no='87.Telefon'> 3</td>
					<td><input type="text" name="company_tel3" id="company_tel3" value="#get_company.company_tel3#" onkeyup="isNumber(this);" maxlength="10" style="width:150px;"></td>
				</tr>
				<tr class="color-row" style="height:20px;">
					<td class="txtbold"><cf_get_lang_main no='496.Temsilci'></td>
					<td><input type="text" name="position_code" id="position_code" value="<cfif len(get_workgroup_position.position_code)>#get_emp_info(get_workgroup_position.position_code,1,0)#</cfif>" style="width:220px;"></td>
					<td class="txtbold"><cf_get_lang_main no='76.Faks'></td>
					<td><input type="text" name="company_fax" id="company_fax" onkeyup="isNumber(this);" value="#get_company.company_fax#" maxlength="10" style="width:150px;"></td>
				</tr>
				<tr class="color-row" style="height:20px;">
					<td class="txtbold"><cf_get_lang_main no='1350.Vergi Dairesi'></td>
					<td><input type="text" name="taxoffice" id="taxoffice" value="#get_company.taxoffice#" maxlength="30" style="width:220px;"></td>
					<td class="txtbold"><cf_get_lang_main no='16.E-mail'></td>
					<td class="color-row">
						<cfsavecontent variable="message"><cf_get_lang_main no='1072.Lütfen Geçerli Bir E-posta Adresi Giriniz'>!</cfsavecontent>
						<cfinput type="text" name="company_email" id="company_email" value="#get_company.company_email#" maxlength="50" validate="email" message="#message#"  style="width:150px;">
					</td>
				</tr>
				<tr class="color-row" style="height:20px;">
					<td class="txtbold"><cf_get_lang_main no='340.Vergi No'></td>
					<td class="color-row"><input type="text" name="taxno" id="taxno" value="#get_company.taxno#" onkeyup="isNumber(this);" maxlength="12" style="width:220px;" /></td>
					<td class="txtbold"><cf_get_lang_main no='60.Posta Kodu'></td>
					<td class="color-row"><input type="text" name="company_postcode" id="company_postcode" onkeyup="isNumber(this);" style="width:150px;" maxlength="5" value="#get_company.company_postcode#"></td>
				</tr>
				<tr class="color-row" style="height:20px;">
					<td class="txtbold"><cf_get_lang_main no='667.İnternet'></td>
					<td><input type="text" name="homepage" id="homepage" value="#get_company.web#" maxlength="50" style="width:220px;" /></td>
					<td class="txtbold"><cf_get_lang_main no='720.Semt'></td>
					<td><input type="text" name="semt" id="semt" value="#get_company.company_semt#" maxlength="30" style="width:150px;"></td>
				</tr>
				<tr class="color-row" style="height:20px;">
					<td class="txtbold" rowspan="3" style="vertical-align:top;"><cf_get_lang_main no='1311.Adres'></td>
					<td class="color-row" rowspan="3"><textarea name="company_address" id="company_address" style="width:220px; height:60px;">#get_company.company_address#</textarea></td>
					<td class="txtbold"><cf_get_lang_main no='1226.İlçe'></td>
					<td>
						<select name="county_id" id="county_id" style="width:150px;">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfquery name="GET_COUNTY" datasource="#DSN#">
								SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY <cfif len(get_company.company_city)> WHERE  CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.company_city#"></cfif>
							</cfquery>
							<cfloop query="get_county">
								<option value="#county_id#" <cfif get_company.company_county eq county_id>selected</cfif>>#county_name#</option>
							</cfloop>
						</select>
					</td>
				</tr>
				<tr class="color-row" style="height:20px;">
					<td class="txtbold"><cf_get_lang_main no='559.İl'></td>
					<td>					
						<select name="city_id" id="city_id" style="width:150px;" onchange="LoadCounty(this.value,'county_id','company_telcode')">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfquery name="GET_CITY" datasource="#DSN#">
								SELECT CITY_ID,CITY_NAME FROM SETUP_CITY <cfif len(get_company.company_country)> WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.company_country#"></cfif>
							</cfquery>
							<cfloop query="get_city">
								<option value="#city_id#" <cfif get_company.company_city eq city_id>selected</cfif>>#city_name#</option>
							</cfloop>
						</select>
					</td>
				</tr>
				<tr class="color-row">
					<td class="txtbold"><cf_get_lang_main no='807.Ülke'></td>
					<td>
						<select name="country" id="country" onchange="LoadCity(this.value,'city_id','county_id',0);remove_adress('1');" style="width:150px;">
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfloop query="get_country">
								<option value="#country_id#" <cfif get_company.company_country eq country_id>selected</cfif>>#country_name#</option>
							</cfloop>
						</select>
					</td>
				</tr>
				<cfif isdefined('attributes.is_workcube_buttons') and (attributes.is_workcube_buttons eq 2 or (attributes.is_workcube_buttons eq 1 and get_company.manager_partner_id eq session.pp.userid))>
                    <tr style="height:20px;">
                        <td colspan="4"  style="text-align:right;"><cf_workcube_buttons is_upd='1' is_delete= '0'></td>
                    </tr>
                </cfif>
			</table>
			<!--- Şirket Detay Bilgileri Burada Bitti --->
            <cfquery name="GET_ADDRESS" datasource="#DSN#">
                SELECT
                    COMPBRANCH_ID,
                    COMPBRANCH_ADDRESS ADDRESS,
                    COMPBRANCH_POSTCODE POSTCODE,
                    COUNTY_ID COUNTY,
                    CITY_ID CITY,
                    COUNTRY_ID COUNTRY,
                    SEMT SEMT,
                    COMPBRANCH_EMAIL,
                    COMPBRANCH_TELCODE,
                    COMPBRANCH_TEL1
                FROM
                    COMPANY_BRANCH
                WHERE 
                    COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#"> AND
                    COMPBRANCH_STATUS = 1 AND
                    COMPBRANCH_ADDRESS IS NOT NULL
            </cfquery>
			<cfif get_address.recordcount>
                <cfset city_id_list = ''> <!--- Sehir  --->
                <cfset county_id_list = ''> <!--- Ilce --->
                <cfloop query="get_address">
                    <cfif len(city) and not listfind(city_id_list,city)>
                        <cfset city_id_list=listappend(city_id_list,city)>
                    </cfif>
                    <cfif len(county) and not listfind(county_id_list,county)>
                        <cfset county_id_list=listappend(county_id_list,county)>
                    </cfif>
                </cfloop>
                <cfif len(city_id_list)>
                    <cfquery name="GET_CITY" datasource="#DSN#">
                        SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#city_id_list#) ORDER BY CITY_ID
                    </cfquery>
                    <cfset city_id_list = listsort(listdeleteduplicates(valuelist(get_city.city_id,',')),'numeric','ASC',',')>
                </cfif>
                <cfif len(county_id_list)>
                    <cfquery name="GET_COUNTY" datasource="#DSN#">
                        SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN (#county_id_list#) ORDER BY COUNTY_ID
                    </cfquery>
                    <cfset county_id_list = listsort(listdeleteduplicates(valuelist(get_county.county_id,',')),'numeric','ASC',',')>
                </cfif>
            </cfif>
            <table cellspacing="1" cellpadding="1" border="0" align="center" style="width:100%">
                <tr style="height:22px;">
                    <td class="txtboldblue"><cf_get_lang no='235.Adresler'></td>
                    <td style="text-align:right" colspan="6">
                        <cfif isdefined('attributes.is_workcube_buttons') and (attributes.is_workcube_buttons eq 2 or (attributes.is_workcube_buttons eq 1 and get_company.manager_partner_id eq session.pp.userid))>
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_form_add_branch','small');"><img src="/images/plus_list.gif" border="0" align="absmiddle" alt="<cf_get_lang no='1004.Adres Ekle'>"/></a>
                        </cfif>
                    </td>
                </tr>
                <tr class="color-header" style="height:22px;">
                    <td class="form-title"><cf_get_lang_main no='1311.Adres'></td>
                    <td class="form-title" style="width:10%;"><cf_get_lang_main no='60.Posta Kodu'></td>
                    <td class="form-title" style="width:10%;"><cf_get_lang_main no='720.Semt'></td>
                    <td class="form-title" style="width:12%;"><cf_get_lang_main no='1226.İlçe'></td>
                    <td class="form-title" style="width:13%;"><cf_get_lang_main no='1196.İl'></td>
                    <td class="form-title" style="width:10%;"><cf_get_lang_main no='807.Ülke'></td>
                    <td class="form-title" style="width:13%;"><cf_get_lang_main no='731.İletişim'></td>
                </tr>
                <cfif get_address.recordcount>
                    <input type="hidden" name="count" id="count" value="<cfoutput>#get_address.recordcount#</cfoutput>">
                    <cfloop query="get_address">
                        <tr class="color-row">
                            <input type="hidden" name="compbranch_id_#currentrow#" id="compbranch_id_#currentrow#" value="#compbranch_id#" >
                            <td><input type="text" name="branch_address_#currentrow#" id="branch_address_#currentrow#" style="width:240px;" maxlength="200" value="#address#"></td>
                            <td><input type="text" name="branch_postcode_#currentrow#" id="branch_postcode_#currentrow#" onkeyup="isNumber(this);" onblur="isNumber(this);" style="width:60px;" maxlength="5" value="#postcode#"></td>
                            <td><input type="text" name="branch_semt_#currentrow#" id="branch_semt_#currentrow#" value="#semt#" maxlength="30" style="width:85px;"></td>
                            <td>
                                <input type="hidden" name="branch_county_id_#currentrow#" id="branch_county_id_#currentrow#" value="<cfif len(county)>#county#</cfif>">
                                <input type="text" name="branch_county_#currentrow#" id="branch_county_#currentrow#" value="<cfif len(county)>#get_county.county_name[listfind(county_id_list,county,',')]#</cfif>" style="width:85px;" readonly="yes">
                                <a href="javascript://" onclick="pencere_ac_branch(#currentrow#);"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
                            </td>
                            <td>
                                <input type="hidden" name="branch_city_id_#currentrow#" id="branch_city_id_#currentrow#" value="<cfif len(city)>#city#</cfif>" />
                                <input type="text" name="branch_city_#currentrow#" id="branch_city_#currentrow#" value="<cfif len(city)>#get_city.city_name[listfind(city_id_list,city,',')]#</cfif>" style="width:100px;" readonly="yes" >
                                <a href="javascript://" onclick="pencere_ac_branch_city(#currentrow#);"><img src="/images/plus_list.gif" border="0" align="absmiddle" /></a>
                            </td>
                            <td>
                                <cfif len(country)>
                                    <cfset cntry = country>
                                    <select name="branch_country_#currentrow#" id="branch_country_#currentrow#" style="width:100px;">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfloop query="get_country">
                                            <option value="#get_country.country_id#" <cfif cntry eq get_country.country_id>selected</cfif>>#get_country.country_name#</option>
                                        </cfloop>
                                    </select>
                                </cfif>
                            </td>
                            <td>
                                <input type="text" name="compbranch_telcode_#currentrow#" id="compbranch_telcode_#currentrow#"  onkeyup="isNumber(this);" onblur="isNumber(this);" value="#compbranch_telcode#" maxlength="5" style="width:45px;">
                                <input type="text" name="compbranch_tel1_#currentrow#" id="compbranch_tel1_#currentrow#"  onkeyup="isNumber(this);" onblur="isNumber(this);" value="#compbranch_tel1#" maxlength="10" style="width:70px;">
                            </td>
                        </tr> 
                    </cfloop>
                <cfelse>
                    <tr class="color-row" style="height:20px;">
                        <td colspan="7"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                    </tr>
                </cfif>
                <cfif isdefined('attributes.is_workcube_buttons') and (attributes.is_workcube_buttons eq 2 or (attributes.is_workcube_buttons eq 1 and get_company.manager_partner_id eq session.pp.userid))>
                    <tr style="height:20px;">
                        <td colspan="5"></td>
                        <td colspan="2"  style="text-align:right;"><cf_workcube_buttons is_upd='1' is_delete= '0'></td>
                    </tr>
                </cfif>
            </table>
            
            <!--- şirket çalışanları --->
            <!---<cfquery name="GET_PARTNER" datasource="#DSN#">
                SELECT 
                    PARTNER_ID,
                    TITLE,
                    COMPANY_PARTNER_EMAIL,
                    COMPANY_PARTNER_TEL,
                    IM,
                    COMPANY_PARTNER_FAX,
                    COMPANY_PARTNER_NAME,
                    COMPANY_PARTNER_SURNAME
                FROM 
                    COMPANY_PARTNER 
                WHERE 
                    COMPANY_PARTNER_STATUS = 1 AND
                    COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cpid#">
            </cfquery>--->
            <table cellspacing="1" cellpadding="1" border="0" align="center" style="width:100%;">
                <tr>
                    <td class="txtboldblue" colspan="3"><cf_get_lang_main no='1463.Şirket Çalışanları'></td>
                    <!---<td  style="text-align:right"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.form_add_partner"><img src="/images/plus_list.gif" border="0" align="absmiddle" alt="<cf_get_lang_main no='1673.Çalışan Ekle'>"/></a></td>--->
                    <td  style="text-align:right">
                        <cfif isdefined('attributes.is_add_partner') and ((attributes.is_add_partner eq 1 and get_company.manager_partner_id eq session.pp.userid) or attributes.is_add_partner eq 2)>
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_form_add_partner','list');"><img src="/images/plus_list.gif" border="0" align="absmiddle" alt="<cf_get_lang_main no='1673.Çalışan Ekle'>"/></a>
                        </cfif>
                    </td> 
                </tr>
                <tr class="color-header" style="height:22px;">
                    <td style="width:21px;">&nbsp;</td>
                    <td class="form-title"><cf_get_lang_main no='158.Ad Soyad'></td>
                    <td class="form-title"><cf_get_lang_main no='159.Ünvan'></td>
                    <td class="form-title" style="width:150px;"><cf_get_lang_main no='731.İletişim'></td>
                </tr>
                <cfif get_company.recordcount>
                    <cfloop query="get_company">
                       <tr class="color-row">
                            <td class="color-row" style="width:21px;"><cf_online id="#partner_id#" zone="pp"></td>
                            <td class="color-row"><a href="#request.self#?fuseaction=objects2.form_upd_partner&pid=#partner_id#" class="tableyazi">#company_partner_name# #company_partner_surname#</a></td>
                            <td class="color-row">#title#</td>
                            <td class="color-row">
                                <cfif len(company_partner_email)>
                                    <a href="mailto:#company_partner_email#"><img src="/images/mail.gif" width="18" height="21" title="E-posta:#company_partner_email#" border="0"></a>
                                </cfif>
                                <cfif len(company_partner_tel)>&nbsp;<img src="/images/tel.gif" width="17" height="21" title="Tel:#company_partner_tel#" border="0"></cfif>
                                <cfif len(company_partner_fax)>&nbsp;<img src="/images/fax.gif" width="22" height="21" title="Faks:#company_partner_fax#" border="0"></cfif>
                            </td>
                        </tr> 
                    </cfloop>
                <cfelse>
                    <tr class="color-row" style="height:20px;">
                        <td colspan="4"><cf_get_lang_main no='72.Kayıt Bulunamadı'>! </td>
                    </tr>
                </cfif>
            </table>
            <!--- Bireysel üyeler Burada Bitti --->
            <cfquery name="GET_ALL_EMPS_PARS" datasource="#DSN#">
                SELECT 
                    1 TYPE,
                    EMPLOYEE_POSITIONS.EMPLOYEE_ID MEMBER_ID,
                    EMPLOYEE_POSITIONS.EMPLOYEE_NAME MEMBER_NAME,
                    EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME MEMBER_SURNAME,
                    '' NICKNAME,
                    WORKGROUP_EMP_PAR.ROLE_ID ROLE,
                    WORKGROUP_EMP_PAR.IS_MASTER IS_MASTER
                FROM 
                    EMPLOYEE_POSITIONS,
                    WORKGROUP_EMP_PAR
                WHERE 
                    WORKGROUP_EMP_PAR.COMPANY_ID IS NOT NULL AND
                    WORKGROUP_EMP_PAR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#"> AND
                    EMPLOYEE_POSITIONS.POSITION_CODE = WORKGROUP_EMP_PAR.POSITION_CODE AND
                    WORKGROUP_EMP_PAR.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
            UNION ALL 
                SELECT 
                    2 TYPE,
                    COMPANY_PARTNER.PARTNER_ID MEMBER_ID,
                    COMPANY_PARTNER.COMPANY_PARTNER_NAME MEMBER_NAME,
                    COMPANY_PARTNER.COMPANY_PARTNER_SURNAME MEMBER_SURNAME,
                    COMPANY.NICKNAME NICKNAME,
                    WORKGROUP_EMP_PAR.ROLE_ID ROLE,
                    WORKGROUP_EMP_PAR.IS_MASTER IS_MASTER
                FROM 
                    COMPANY_PARTNER,
                    COMPANY,
                    WORKGROUP_EMP_PAR
                WHERE 
                    WORKGROUP_EMP_PAR.COMPANY_ID IS NOT NULL AND
                    WORKGROUP_EMP_PAR.COMPANY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#"> AND
                    COMPANY_PARTNER.PARTNER_ID = WORKGROUP_EMP_PAR.PARTNER_ID AND
                    COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
                    WORKGROUP_EMP_PAR.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
            </cfquery>	
            <cfif get_all_emps_pars.recordcount>
                <cfset role_id_list =''>
                <cfloop query="get_all_emps_pars">
                    <cfif len(role) and not listfind(role_id_list,role)>
                        <cfset role_id_list=listappend(role_id_list,role)>
                    </cfif>
                </cfloop>
                <cfif len(role_id_list)>
                    <cfquery name="GET_ROL_NAME" datasource="#DSN#">
                        SELECT PROJECT_ROLES_ID, PROJECT_ROLES FROM SETUP_PROJECT_ROLES WHERE PROJECT_ROLES_ID IN (#role_id_list#) ORDER BY PROJECT_ROLES_ID
                    </cfquery>
                    <cfset role_id_list = listsort(listdeleteduplicates(valuelist(get_rol_name.project_roles_id,',')),'numeric','ASC',',')>
                </cfif>
            </cfif>
            <cfif get_all_emps_pars.recordcount>
                <table cellspacing="2" cellpadding="2" border="0" align="center" style="width:100%">
                    <tr style="height:22px;"> 
                        <td class="txtboldblue" colspan="2"><cf_get_lang no='482.Ekibiniz'></td>
                    </tr>
                    <tr class="color-header">
                        <td style="width:21px;"></td>
                        <td class="form-title"><cf_get_lang_main no='158.Ad Soyad'></td>
                        <td class="form-title">Rol</td>
                    </tr>
                    <cfloop query="get_all_emps_pars">
                        <tr>
                            <td style="width:21px;"class="color-row"><cf_online id="#member_id#" zone="ep"></td>
                            <td class="color-row">
                                <cfif type eq 1 and len(member_id)>
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_emp_det&emp_id=#encrypt(member_id,"WORKCUBE","BLOWFISH","Hex")#','list')" class="tableyazi" >#member_name# #member_surname#</a><cfif is_master eq 1><i> - <cf_get_lang_main no='1383.Müşteri Temsilcisi'></i></cfif>
                                <cfelseif type eq 2>
                                    #member_name# #member_surname# - #nickname#
                                </cfif>
                            </td>
                            <td class="color-row"><cfif len(role)>#get_rol_name.project_roles[listfind(role_id_list,role,',')]#</cfif></td>
                        </tr>
                    </cfloop>
                </table>
            </cfif>
		</td>
	</tr>
</table>
</cfoutput>
</cfform>

<script type="text/javascript">
	function remove_adress(parametre)
	{
		if(parametre==1)
		{
			document.getElementById('city_id').value = '';
			document.getElementById('city').value = '';
			document.getElementById('county_id').value = '';
			document.getElementById('county').value = '';
			document.getElementById('company_telcode').value = '';
		}
		else
		{
			document.getElementById('county_id').value = '';
			document.getElementById('county').value = '';
		}	
	}
	function pencere_ac_city()
	{
		
		x = document.getElementById('country').selectedIndex;
		if (document.getElementById('country')[x].value == "")
		{
			alert("<cf_get_lang no='31.İlk Olarak Ülke Seçiniz'>.");
		}	
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=upd_my_company.city_id&field_name=upd_my_company.city&field_phone_code=upd_my_company.company_telcode&country_id=' + document.upd_my_company.country.value,'small');
		}
		return remove_adress('2');
	}
	
	function pencere_ac(no)
	{
		x = document.getElementById('country').selectedIndex;
		if (document.getElementById('country')[x].value == "")
		{
			alert("<cf_get_lang no='31.İlk Olarak Ülke Seçiniz'>.");
		}	
		else if(document.getElementById('city_id').value == "")
		{
			alert("<cf_get_lang no='32.Il Seçiniz'> !");
		}
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=upd_my_company.county_id&field_name=upd_my_company.county&city_id=' + document.upd_my_company.city_id.value,'small');
			return remove_adress();
		}
	}
	
	function pencere_ac_branch_city(row)
	{
		a=eval('document.getElementById("branch_country_'+row+'")').selectedIndex;
		if (eval('document.getElementById("branch_country_'+row+'")').options[a].value == "")
		{
			alert("<cf_get_lang no='31.İlk Olarak Ülke Seçiniz'>.");
		}
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=upd_my_company.branch_city_id_' + row +'&field_name=upd_my_company.branch_city_' + row +'&country_id=' + eval('document.getElementById("branch_country_'+row+'")').value,'small');
		}
	}
	function pencere_ac_branch(rrw)
	{
		b=eval('document.getElementById("branch_country_'+rrw+'")').selectedIndex;
		if (eval('document.getElementById("branch_country_'+rrw+'")').options[b].value == "")
		{
			alert("<cf_get_lang no='31.İlk Olarak Ülke Seçiniz'>.");
		}	
		else if(eval('document.getElementById("branch_city_id_'+rrw+'")').value == "")
		{
			alert("<cf_get_lang no='32.Il Seçiniz'> !");
		}
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=upd_my_company.branch_county_id_' + rrw +'&field_name=upd_my_company.branch_county_' + rrw +'&city_id=' + eval('document.getElementById("branch_city_id_'+rrw+'")').value,'small');
		}
	}
</script>
