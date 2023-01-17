<cfif not isdefined("session.ww.userid")>
	&nbsp;&nbsp;&nbsp;<cf_get_lang no='218.Üye Girişi Yapmalısınız'>!!
	<cfexit method="exittemplate">
</cfif>
<cfif not isdefined("attributes.is_detail_adres")>
	<cfset attributes.is_detail_adres = 0>
</cfif>
<cfif not isdefined("attributes.is_residence_select")>
	<cfset attributes.is_residence_select = 0>
</cfif>
<cfif not isdefined("attributes.is_other_address")>
	<cfset attributes.is_other_address = 0>
</cfif>
<cfif not isdefined("attributes.xml_is_upd")>
	<cfset attributes.xml_is_upd = 1>
</cfif>
<cfset kontrol_zone = 0>
<cfif isdefined("attributes.is_ref_member_zone") and attributes.is_ref_member_zone eq 1 and isdefined("session.ww.userid")>
	<cfquery name="GET_CONTROL_CITY" datasource="#DSN#">
		SELECT ISNULL(HOME_CITY_ID,WORK_CITY_ID) AS CITY_ID FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
	</cfquery>
	<cfif get_control_city.recordcount and len(get_control_city.city_id)>
		<cfset kontrol_zone = ''>
		<cfquery name="GET_CITY_CODE" datasource="#DSN#">
			SELECT PLATE_CODE FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_control_city.city_id#">
		</cfquery>
		<cfif get_city_code.plate_code eq 34>
			<cfquery name="GET_CITYS" datasource="#DSN#">
				SELECT CITY_ID FROM SETUP_CITY WHERE PLATE_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_city_code.plate_code#">
			</cfquery>
			<cfloop query="get_citys">
				<cfset kontrol_zone = listappend(kontrol_zone,get_citys.city_id,',')>
			</cfloop>
		<cfelse>
			<cfset kontrol_zone = listappend(kontrol_zone,get_control_city.city_id,',')>
		</cfif>
	<cfelse>
		<cfset kontrol_zone = -1>
	</cfif>
</cfif>
<cfinclude template="../query/get_consumer.cfm">
<cfif get_consumer.recordcount>
	<cfinclude template="../query/get_company_cat.cfm">
	<cfinclude template="../query/get_im.cfm">
	<cfinclude template="../query/get_mobilcat.cfm">
	<cfinclude template="../query/get_identycard_cat.cfm">
	<cfinclude template="../query/get_consumer_cat.cfm">
	<cfinclude template="../query/get_language.cfm">
	<cfinclude template="../query/get_company_size.cfm">
	<cfinclude template="../query/get_company_sector.cfm">
	<cfinclude template="../query/get_partner_positions.cfm">
	<cfinclude template="../query/get_partner_departments.cfm">
	<cfinclude template="../query/get_sector_cats.cfm">
	<cfinclude template="../query/get_company_size_cats.cfm">
	<cfinclude template="../query/get_vocation_type.cfm">
	<cfinclude template="../query/get_country.cfm">
	<cfinclude template="../career/query/get_edu_level.cfm">
	<cfquery name="GET_CONS_ROW" datasource="#DSN#">
		SELECT 
			CC.CONSCAT 
		FROM 
			CONSUMER_CAT CC,
			CATEGORY_SITE_DOMAIN CSD  
		WHERE 
			CC.CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.consumer_cat_id#"> AND
			CC.CONSCAT_ID = CSD.CATEGORY_ID AND
			CSD.MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.menu_id#"> AND 
			CSD.MEMBER_TYPE = 'CONSUMER' 
	</cfquery>	  
    <cfquery name="GET_POS_INFO" datasource="#DSN#">
        SELECT
            OUR_COMPANY_ID,
            POSITION_CODE,
            IS_MASTER
        FROM
            WORKGROUP_EMP_PAR
        WHERE
            CONSUMER_ID IS NOT NULL AND
		<cfif isdefined("attributes.cid")>
            CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#"> AND
        <cfelse>
            CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
        </cfif>
            OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
            IS_MASTER = 1
    </cfquery>      
    <cfif attributes.xml_is_upd eq 1>
        <cfform name="upd_consumer" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=objects2.emptypopup_upd_consumer">
        <input type="hidden" name="is_other_address" id="is_other_address" value="<cfoutput>#attributes.is_other_address#</cfoutput>">
        <cfif isdefined('attributes.orderww_back') and len(attributes.orderww_back)>
            <input type="hidden" name="orderww_back" id="orderww_back" value="<cfoutput>#attributes.orderww_back#</cfoutput>">
            <input type="hidden" name="grosstotal" id="grosstotal" value="<cfoutput>#attributes.grosstotal#</cfoutput>">
        </cfif>
        <!---Temel Bilgiler --->
        <table cellpadding="2" cellspacing="2" border="0" style="width:100%">
            <tr class="header">
                <td onclick="gizle_goster(gizli992);" style="cursor:pointer;" class="header_title_cont"><cf_get_lang_main no='719.Temel Bilgiler'></td>
            </tr>
            <tr id="gizli992">
                <td>
                    <div style="float:left; width:50%">
                        <table>
                            <tr>
                                <cfif isdefined("attributes.is_ref_info") and attributes.is_ref_info eq 1>
                                    <td class="me-title" style="width:200px;"><cf_get_lang_main no='1224.Referans Üye'></td> 
                                    <td class="inner-menu-link"><cfif len(get_consumer.ref_pos_code)><cfoutput>#get_cons_info(get_consumer.ref_pos_code,0,0)#</cfoutput></cfif><td>
                                </cfif>
                            </tr>
                            <cfif isdefined("attributes.is_member_code") and attributes.is_member_code eq 1>
                                <tr>
                                    <td class="me-title" style="width:200px;"><cf_get_lang no='1508.Üye Kodu'></td>
                                    <td><input type="text" name="member_code" id="member_code" value="<cfoutput>#get_consumer.member_code#</cfoutput>" style="width:140px;" readonly></td>
                                </tr>
                            </cfif>
                            <tr>
                                <td class="me-title" style="width:200px;"><cf_get_lang_main no='219.Ad'> *</td>
                                <td>
                                    <cfsavecontent variable="message"><cf_get_lang no='219.Lütfen adınızı giriniz !'></cfsavecontent>
                                    <cfif isdefined("attributes.is_change_name") and attributes.is_change_name eq 0>
                                        <cfinput type="text" name="consumer_name" id="consumer_name" required="yes" value="#get_consumer.consumer_name#" style="width:140px;" readonly>
                                    <cfelse>
                                        <cfinput type="text" name="consumer_name" id="consumer_name"required="yes" value="#get_consumer.consumer_name#" style="width:140px;" maxlength="30">
                                    </cfif>
                                </td>
                            </tr>
                            <tr>
                                <td class="me-title"><cf_get_lang_main no='1314.Soyad'>*</td>
                                <td>
                                    <cfsavecontent variable="message"><cf_get_lang no='237.Lütfen soyadınızı giriniz !'></cfsavecontent>
                                    <cfif isdefined("attributes.is_change_name") and attributes.is_change_name eq 0>
                                        <cfinput type="text" name="consumer_surname" id="consumer_surname" required="yes" value="#get_consumer.consumer_surname#" style="width:140px;" readonly>
                                    <cfelse>
                                        <cfinput type="text" name="consumer_surname" id="consumer_surname" required="yes" value="#get_consumer.consumer_surname#" style="width:140px;" maxlength="30">
                                    </cfif>
                                </td>
                            </tr>
                            <cfif (isdefined("attributes.is_change_cat") and attributes.is_change_cat eq 1) or not isdefined("attributes.is_change_cat")>
                                <tr>
                                    <td class="me-title"><cf_get_lang_main no='1197.Üye Kategorisi'></td>
                                    <td><select name="consumer_cat_id" id="consumer_cat_id" style="width:145px;">
                                            <cfoutput query="get_consumer_cat">
                                                <option value="#conscat_id#" <cfif conscat_id eq get_consumer.consumer_cat_id>selected</cfif>>#conscat#</option>
                                            </cfoutput>
                                        </select>
                                    </td>
                                </tr>
                            <cfelseif isdefined("attributes.is_change_cat") and attributes.is_change_cat eq 0>
                                <tr>
                                    <td class="me-title"><cf_get_lang_main no='1197.Üye Kategorisi'></td>
                                    <td>
                                        <input type="text" name="consumer_cat_name" id="consumer_cat_name" style="width:140px;" value="<cfoutput>#get_cons_row.conscat#</cfoutput>" readonly>
                                        <input type="hidden" name="consumer_cat_id" id="consumer_cat_id" value="<cfoutput>#get_consumer.consumer_cat_id#</cfoutput>">
                                    </td>
                                </tr>
                            </cfif>
                            <cfif (isdefined("attributes.is_user_name") and attributes.is_user_name eq 1) or not isdefined("attributes.is_user_name")>
                                <tr>
                                    <th class="me-title"><cf_get_lang_main no='139.Kullanıcı Adı'></th>
                                    <td>
                                        <cfif isdefined("attributes.is_change_username") and attributes.is_change_username eq 0>
                                            <input type="text" name="consumer_username" id="consumer_username" value="<cfoutput>#get_consumer.consumer_username#</cfoutput>" style="width:140px;" readonly>
                                        <cfelse>
                                            <input type="text" name="consumer_username" id="consumer_username" value="<cfoutput>#get_consumer.consumer_username#</cfoutput>" maxlength="20" style="width:140px;">
                                        </cfif>
                                    </td>
                                </tr>
                            </cfif>
                            <cfif (isdefined("attributes.is_password") and attributes.is_password eq 1) or not isdefined("attributes.is_password")>
                                <tr>
                                    <th class="me-title"><cf_get_lang_main no='140.Şifre'></th>
                                    <td><input type="password" name="consumer_password" id="consumer_password" value="" maxlength="10" style="width:140px;"></td>
                                </tr>
                            </cfif>
                            <cfif (isdefined("attributes.is_timeout") and attributes.is_timeout eq 1) or not isdefined("attributes.is_timeout")>
                                <tr>
                                    <th class="me-title"><cf_get_lang no='228.Timeout Süresi'></th>
                                    <td><select name="timeout_limit" id="timeout_limit" style="width:145px;">
                                            <option value="15" <cfif get_consumer.timeout_limit is '15'>selected</cfif>>15 dk.</option>
                                            <option value="30" <cfif get_consumer.timeout_limit is '30'>selected</cfif>>30 dk.</option>
                                            <option value="45" <cfif get_consumer.timeout_limit is '45'>selected</cfif>>45 dk.</option>
                                            <option value="60" <cfif get_consumer.timeout_limit is '60'>selected</cfif>>60 dk.</option>
                                        </select>
                                    </td>
                                </tr>
                            </cfif>
                        </table>
                    </div>
                    <div style="float:left; width:50%">
                        <table>
                            <tr>
                                <cfif isdefined("attributes.is_work_pos") and attributes.is_work_pos eq 1>

                                    <td class="me-title" style="width:200px;"><cf_get_lang_main no='496.Temsilci'></td> 
                                    <td class="me-title"><cfif get_pos_info.recordcount and len(get_pos_info.position_code)><cfoutput>#get_emp_info(get_pos_info.position_code,1,0)#</cfoutput></cfif><td>
                                </cfif>
                            </tr>
                            <tr>
                                <td class="me-title" style="width:200px;"><cf_get_lang_main no='16.E-posta'> *</td>
                                <td><cfsavecontent variable="message"><cf_get_lang no='238.E-posta adresini girmelisiniz !'></cfsavecontent>
                                    <cfinput type="text" name="consumer_email" id="consumer_email" value="#get_consumer.consumer_email#" style="width:140px;" maxlength="40" required="yes" message="#message#">
                                </td>
                            </tr>
                            <tr>
                                <td class="me-title"><cf_get_lang_main no='1070.Mobil Telefon'></th>
                                <td><select name="mobilcat_id" id="mobilcat_id" style="width:45px;">
                                        <option value="0"><cf_get_lang_main no='322.Seçiniz'>
                                        <cfoutput query="get_mobilcat">
                                            <option value="#mobilcat#"<cfif mobilcat eq get_consumer.mobil_code>selected</cfif>>#mobilcat#
                                        </cfoutput>
                                    </select>
                                    <cfsavecontent variable="message"><cf_get_lang_main no='1160.Lütfen geçerli bir mobil telefon giriniz!'></cfsavecontent>
                                    <cfinput type="text" name="mobiltel" id="mobiltel" maxlength="9" value="#get_consumer.mobiltel#" message="#message#" onKeyUp="isNumber(this);" style="width:92px;">
                                </td>
                            </tr>
                            <tr>
                                <td class="me-title"><cf_get_lang_main no='1070.Mobil Tel'> 2</th>
                                <td>
                                    <select name="mobilcat_id_2" id="mobilcat_id_2" style="width:45px;">
                                        <option value="0"><cf_get_lang_main no='322.Seçiniz'>
                                        <cfoutput query="get_mobilcat">
                                            <option value="#mobilcat#"<cfif mobilcat eq get_consumer.mobil_code_2>selected</cfif>>#mobilcat#
                                        </cfoutput>
                                    </select>
                                    <cfinput type="text" name="mobiltel_2" id="mobiltel_2" maxlength="9" value="#get_consumer.mobiltel_2#" message="#message#" onKeyUp="isNumber(this);" style="width:92px;">
                                </td>
                            </tr>
                            <tr>
                                <td class="me-title"><cf_get_lang no='226.Ev Tel'></th>
                                <td><cfsavecontent variable="message"><cf_get_lang no='297.Lütfen geçerli bir ev telefon numarası giriniz!'></cfsavecontent>
                                    <cfinput type="text" name="home_telcode" id="home_telcode" value="#get_consumer.consumer_hometelcode#" maxlength="5" message="#message#" onKeyUp="isNumber(this);" style="width:45px;">
                                    <cfinput type="text" name="home_tel" id="home_tel" value="#get_consumer.consumer_hometel#" maxlength="9" message="#message#" onKeyUp="isNumber(this);" style="width:87px;">
                                </td>
                            </tr>
                            <tr>
                                <td class="me-title"><cf_get_lang no='227.İş Tel'></th>
                                <td><cfsavecontent variable="message"><cf_get_lang no='118.Lütfen geçerli bir iş telefon numarası giriniz!'></cfsavecontent>
                                    <cfinput name="work_telcode" id="work_telcode"  value="#get_consumer.consumer_worktelcode#" message="#message#" maxlength="5" onKeyUp="isNumber(this);" style="width:45px;">
                                    <cfinput type="text" name="work_tel" id="work_tel" value="#get_consumer.consumer_worktel#" message="#message#" onKeyUp="isNumber(this);" maxlength="9" style="width:87px;">
                                </td>
                            </tr>
                            <cfif (isdefined("attributes.is_internet_page") and attributes.is_internet_page eq 1) or not isdefined("attributes.is_internet_page")>
                                <tr>
                                    <th class="me-title"><cf_get_lang no='196.İnternet Sitesi'></th>
                                    <td><input type="text" name="homepage" id="homepage" value="<cfoutput>#get_consumer.homepage#</cfoutput>" maxlength="50" style="width:143px;"></td>
                                </tr>
                            </cfif>
                        </table>
                   </div>
                </td>
            </tr>
        </table>
        <!--- Kişisel Bilgiler --->
        <table cellpadding="2" cellspacing="2" border="0" style="width:100%">
            <tr class="header">
                <td onclick="gizle_goster(gizli1);" style="cursor:pointer;" class="header_title_cont"><cf_get_lang no='197.Kişisel Bilgilerim '></td>
            </tr>
            <tr id="gizli1">
                <td>
                    <div style="float:left; width:50%">
                        <table>
                            <tr>
                                <td class="me-title" style="width:200px;"><cf_get_lang_main no='378.Doğum Yeri'></td>
                                <td><input type="text" name="birthplace" id="birthplace" value="<cfoutput>#get_consumer.birthplace#</cfoutput>" style="width:140px;" maxlength="30"></td>
                            </tr>
                            <tr>
                                <td class="me-title"><cf_get_lang no='205.Eğitim Durumu'></td>
                                <td><select name="education_level" id="education_level" style="width:145px;">
                                        <option value="">Seçiniz</option>
                                        <cfoutput query="get_edu_level">
                                            <option value="#edu_level_id#" <cfif get_consumer.education_id eq edu_level_id> selected</cfif>>#education_name#</option>
                                        </cfoutput>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td class="me-title"><cf_get_lang_main no='352.Cinsiyet'></td>
                                <td><select name="sex" id="sex" style="width:145px;">
                                        <option value="1"<cfif get_consumer.sex eq 1> selected</cfif>><cf_get_lang_main no='1547.Erkek'>
                                        <option value="0"<cfif get_consumer.sex eq 0> selected</cfif>><cf_get_lang_main no='1546.Kadin'>
                                    </select>
                                </td>
                            </tr>
                            <tr>  	
                                <td class="me-title"><cf_get_lang no='206.Çocuk Sayısı'></td>
                                <td>
                                    <input type="text" name="child" id="child" value="<cfoutput>#get_consumer.child#</cfoutput>" onkeyup="isNumber(this);" maxlength="2" style="width:20px;">
                                </td>
                            </tr>
                            <tr> 
                                <td class="me-title"><cf_get_lang no='201.Evlilik Durumu'></td>
                                <td><input type="checkbox" name="married" id="married" value="checkbox" <cfif get_consumer.married eq 1>checked</cfif>>&nbsp;<cf_get_lang no='209.Evli'></td>
                            </tr>
                        </table>
                     </div>
                     <div style="float:left; width:50%">
                        <table>
                            <tr>
                                <td class="me-title" style="width:200px;"><cf_get_lang_main no='1315.Doğum Tarihi'></td>
                                <td nowrap="nowrap">
                                    <cfif isdefined("attributes.is_change_birthdate") and attributes.is_change_birthdate eq 0>
                                        <cfinput type="text" name="birthdate" id="birthdate" value="#dateformat(get_consumer.birthdate,'dd/mm/yyyy')#" style="width:140px;" readonly>
                                    <cfelse>
                                        <cfsavecontent variable="message"><cf_get_lang no='1173.Lütfen doğum tarihini kontrol ediniz !'></cfsavecontent>
                                        <cfinput type="text" name="birthdate" id="birthdate" value="#dateformat(get_consumer.birthdate,'dd/mm/yyyy')#" style="width:120px;" validate="eurodate" message="#message#">
                                        <cf_wrk_date_image date_field="birthdate">
                                    </cfif>
                                </td>
                            </tr>
                            <cfif (isdefined("attributes.is_language") and attributes.is_language eq 1) or not isdefined("attributes.is_language")>
                                <tr>
                                    <td class="me-title"><cf_get_lang_main no='1584.Dil'></td>
                                    <td><select name="language_id" id="language_id" style="width:145px;">
                                            <cfoutput query="get_language">
                                                <option value="#language_id#">#language_set#
                                            </cfoutput>
                                        </select>
                                    </td>
                                </tr>
                            </cfif>
                            <tr>
                                <td class="me-title"><cf_get_lang_main no='613.TC Kimlik No'><cfif isdefined("attributes.is_tc_number") and attributes.is_tc_number> *</cfif></td>
                                <td>
                                    <cfif isdefined("attributes.is_change_tcnumber") and attributes.is_change_tcnumber eq 0 and len(get_consumer.tc_identy_no)>
                                        <input type="text" name="tc_identity_no" id="tc_identity_no" value="<cfoutput>#get_consumer.tc_identy_no#</cfoutput>" style="width:140px;" readonly>
                                    <cfelse>
                                        <cf_wrktcnumber fieldid="tc_identity_no" tc_identity_number="#get_consumer.tc_identy_no#" tc_identity_required="#attributes.is_tc_number#" width_info='140'>
                                    </cfif>
                                </td>
                            </tr>
                            <cfif isdefined("attributes.is_bank_account") and attributes.is_bank_account eq 1>
                                <cfquery name="GET_BANK_ACCOUNT" datasource="#DSN#">
                                    SELECT 
                                        CONSUMER_BANK,
                                        CONSUMER_BANK_BRANCH,
                                        CONSUMER_ACCOUNT_NO
                                    FROM 
                                        CONSUMER_BANK 
                                    WHERE 
                                        <cfif isdefined("attributes.cid")>
                                            CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">
                                        <cfelse>
                                            CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
                                        </cfif>
                                        AND CONSUMER_ACCOUNT_DEFAULT = 1
                                </cfquery>
                                <tr>
                                    <td class="me-title">Banka Hesabı</td>
                                    <td><input type="text" name="bank_name" id="bank_name" value="<cfoutput>#get_bank_account.consumer_bank#-#get_bank_account.consumer_bank_branch#-#get_bank_account.consumer_account_no#</cfoutput>" style="width:140px;" readonly></td>
                                </tr>
                            </cfif>
                            <cfif (isdefined("attributes.is_nationality") and attributes.is_nationality eq 1) or not isdefined("attributes.is_nationality")>
                                <tr style="height:20px;">
                                    <td class="me-title"><cf_get_lang no='202.Uyruğu'></td>
                                    <td><select name="nationality" id="nationality" style="width:145px;">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            <cfoutput query="get_country">
                                                <option value="#country_id#" <cfif country_id eq get_consumer.nationality>selected</cfif>>#country_name#</option>
                                            </cfoutput>
                                        </select>
                                    </td>
                                </tr>
                            </cfif>
                            <cfif (isdefined("attributes.is_photo") and attributes.is_photo eq 1) or not isdefined("attributes.is_photo")>
                                <tr>  	
                                    <th class="me-title"><cf_get_lang no='207.Fotoğraf'></th>
                                    <td><input type="hidden" name="old_photo" id="old_photo" value="<cfoutput>#get_consumer.picture#</cfoutput>">
                                        <input type="hidden" name="old_photo_server_id" id="old_photo_server_id" value="<cfoutput>#get_consumer.picture_server_id#</cfoutput>">
                                        <input type="file" name="picture" id="picture" style="width:140px;">
                                    </td>
                                    <cfif (isdefined("attributes.is_photo") and attributes.is_photo eq 1) or not isdefined("attributes.is_photo")>
                                        <td rowspan="5" style="vertical-align:top;">
                                            <cfif len(get_consumer.picture)>
                                                <cfoutput>
                                                    <cf_get_server_file output_file="member/consumer/#get_consumer.picture#" output_server="#get_consumer.picture_server_id#" output_type="0" image_width="100" alt="#getLang('main',668)#" title="#getLang('main',668)#">
                                                </cfoutput>
                                            <cfelse>
                                                <cf_get_lang_main no='1083.Fotoğraf Girilmemiş'>
                                          </cfif>
                                        </td>
                                    </cfif>
                                </tr>
                                <tr>
                                    <th class="me-title"><cf_get_lang no='208.Fotoğrafı Sil'></th>
                                    <td><input type="checkbox" name="del_photo" id="del_photo" value="1"></td>
                                </tr>
                            </cfif>
                        </table>	
                     </div>
                </td>
            </tr>
        </table>
        <cfif (isdefined("attributes.is_work_info") and attributes.is_work_info eq 1) or not isdefined("attributes.is_work_info")>
            <!--- İş Meslek Bilgileri --->
            <table cellpadding="2" cellspacing="2" border="0" style="width:100%">
                <tr class="header">
                    <td onclick="gizle_goster(gizli2);" style="cursor:pointer;" class="header_title_cont"><cf_get_lang no='217.İş ve Meslek Bilgilerim'></td>
                </tr>
                <tr style="display:none;" id="gizli2">	
                    <td class="contentforlabel">
                        <div style="float:left; width:50%;">
                            <table>
                                <tr>
                                    <td class="me-title" style="width:200px;"><cf_get_lang_main no='162.Şirket'></td>
                                    <td><input type="text" name="company" id="company" value="<cfoutput>#get_consumer.company#</cfoutput>" style="width:140px;"></td>
                                </tr>
                                <tr>
                                    <td class="me-title"><cf_get_lang_main no='159.Ünvan'></td>
                                    <td><input type="text" name="title" id="title" value="<cfoutput>#get_consumer.title#</cfoutput>" style="width:140px;"></td>
                                </tr>
                                <tr>
                                    <td class="me-title"><cf_get_lang_main no='161.Görev'></td>
                                    <td><select name="mission" id="mission" style="width:145px;">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            <cfoutput query="get_partner_positions">
                                                <option value="#partner_position_id#" <cfif get_consumer.mission eq partner_position_id>selected</cfif>>#partner_position#</option>
                                            </cfoutput>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="me-title"><cf_get_lang_main no='160.Departman'></td>
                                    <td>
                                        <select name="department" id="department" style="width:145px;">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            <cfoutput query="get_partner_departments">
                                                <option value="#partner_department_id#" <cfif get_consumer.department eq partner_department_id>selected</cfif>>#partner_department#</option>
                                            </cfoutput>
                                        </select>
                                    </td>
                                </tr>
                            </table>
                         </div>        	
                         <div style="float:left; width:50%;">
                            <table>
                                <tr>
                                    <td class="me-title" style="width:150px;"><cf_get_lang_main no='167.Sektör'></td>
                                    <td><select name="sector_cat_id" id="sector_cat_id" style="width:145px;"  size="1">
                                            <cfoutput query="get_sector_cats">
                                                <option value="#sector_cat_id#" <cfif sector_cat_id eq get_consumer.sector_cat_id>selected</cfif>>#sector_cat#</option>
                                            </cfoutput>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="me-title"><cf_get_lang no='212.Meslek'></td>
                                    <td><select name="vocation_type" id="vocation_type" style="width:145px;">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            <cfoutput query="get_vocation_type">
                                                <option value="#vocation_type_id#" <cfif get_consumer.vocation_type_id eq vocation_type_id> selected</cfif>>#vocation_type#</option>
                                            </cfoutput>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="me-title"><cf_get_lang no='16.Şirket Büyüklük'></td>
                                    <td><select name="company_size_cat_id" id="company_size_cat_id" style="width:145px;" size="1">
                                            <cfoutput query="get_company_size_cats">
                                                <option value="#company_size_cat_id#" <cfif company_size_cat_id eq get_consumer.company_size_cat_id>selected</cfif>>#company_size_cat#</option>
                                            </cfoutput>
                                        </select>
                                    </td>
                                </tr>
                            </table>
                         </div>	
                    </td>
                </tr>
            </table>
        </cfif>
        <!--- <cfif (isdefined("attributes.is_adress_info") and attributes.is_adress_info eq 1) or not isdefined("attributes.is_adress_info")> --->
            <!--- Adres Bilgileri  --->
            <cfif isDefined('attributes.is_home_address') and attributes.is_home_address eq 1>
                <table cellpadding="2" cellspacing="2" border="0" style="width:100%">
                    <tr class="header">
                        <td onclick="gizle_goster(gizli3);" style="cursor:pointer;" class="header_title_cont"><cf_get_lang no='213.Ev Adresi'></td>
                    </tr>
                    <cfif len(get_consumer.home_district_id)>
                        <cfquery name="GET_HOME_DIST" datasource="#DSN#">
                            SELECT DISTRICT_NAME FROM SETUP_DISTRICT WHERE DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.home_district_id#">
                        </cfquery>
                        <cfset home_dis = '#get_home_dist.district_name# '>
                    <cfelse>
                        <cfset home_dis = ''>
                    </cfif>
                    <tr style="display:none;" id="gizli3">
                        <td class="contentforlabel" style="vertical-align:top;">
                            <div style="float:left; width:50%;">
                                <table>
                                    <tr>
                                        <td class="me-title" style="width:200px;"><cf_get_lang_main no='807.Ülke'></td>
                                        <td><select name="home_country" id="home_country" style="width:145px;" onchange="LoadCity(this.value,'home_city_id','home_county_id',<cfoutput>'#kontrol_zone#'</cfoutput><cfif attributes.is_detail_adres eq 1 and attributes.is_residence_select eq 1>,'home_district_id'</cfif>)">
                                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                <cfoutput query="get_country">
                                                    <option value="#country_id#" <cfif get_consumer.home_country_id eq country_id>selected</cfif>>#country_name#</option>
                                                </cfoutput>
                                            </select>				
                                        </td>
                                     </tr>
                                     <tr>
                                        <td class="me-title"><cf_get_lang_main no='559.Şehir'><cfif attributes.is_cons_adress eq 1>*</cfif></td>
                                        <td><select name="home_city_id"  id="home_city_id" onchange="LoadCounty(this.value,'home_county_id','home_telcode','0'<cfif attributes.is_detail_adres eq 1 and attributes.is_residence_select eq 1>,'home_district_id'</cfif>);" style="width:145px;">
                                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                <cfif len(get_consumer.home_city_id)>
                                                    <cfquery name="GET_CITY_HOME" datasource="#DSN#">
                                                        SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.home_country_id#">
                                                    </cfquery>
                                                    <cfoutput query="get_city_home">
                                                        <option value="#city_id#" <cfif get_consumer.home_city_id eq city_id>selected</cfif>>#city_name#</option>	
                                                    </cfoutput>
                                                </cfif>
                                            </select>
                                        </td>
                                     </tr>
                                     <tr>
                                        <td class="me-title">İlçe<cfif attributes.is_cons_adress eq 1>*</cfif></td>
                                        <td><select name="home_county_id" id="home_county_id" <cfif attributes.is_detail_adres eq 1 and attributes.is_residence_select eq 1>onChange="LoadDistrict(this.value,'home_district_id');"</cfif> style="width:145px;">
                                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                <cfif len(get_consumer.home_county_id)>
                                                    <cfquery name="GET_COUNTY_HOME" datasource="#DSN#">
                                                        SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.home_city_id#">
                                                    </cfquery>										
                                                    <cfoutput query="get_county_home">
                                                        <option value="#county_id#" <cfif get_consumer.home_county_id eq county_id>selected</cfif>>#county_name#</option>
                                                    </cfoutput>
                                                </cfif>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="me-title"><cf_get_lang_main no='720.Semt'></td>
                                        <td><input type="text" name="home_semt" id="home_semt" value="<cfoutput>#get_consumer.homesemt#</cfoutput>" maxlength="30" style="width:140px;"></td>			
                                     </tr>
                                    <cfif attributes.is_detail_adres eq 1>
                                        <tr>
                                            <td class="me-title">Mahalle <cfif attributes.is_cons_district eq 1>*</cfif></td>
                                            <td>
                                                <cfif attributes.is_residence_select eq 0>
                                                    <input type="text" name="home_district" id="home_district" style="width:145px;" value="<cfif len(get_consumer.home_district)><cfoutput>#get_consumer.home_district#</cfoutput><cfelse><cfoutput>#home_dis#</cfoutput></cfif>">
                                                <cfelse>
                                                    <select name="home_district_id" id="home_district_id" style="width:145px;">
                                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                        <cfif len(get_consumer.home_district_id)>
                                                            <cfquery name="GET_DISTRICT_NAME" datasource="#DSN#">
                                                                SELECT DISTRICT_ID, DISTRICT_NAME FROM SETUP_DISTRICT WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.home_county_id#">
                                                            </cfquery>										
                                                            <cfoutput query="get_district_name">
                                                                <option value="#district_id#" <cfif get_consumer.home_district_id eq district_id>selected</cfif>>#district_name#</option>
                                                            </cfoutput>
                                                        </cfif>
                                                    </select>
                                                </cfif>
                                            </td>
                                        </tr>
                                    </cfif>	
                                 </table>
                            </div>        
                            <div style="float:left; width:50%;">
                                <table>
                                   <cfif attributes.is_detail_adres eq 0>
                                        <tr>
                                            <td class="me-title" style="width:150px;"><cf_get_lang_main no='1311.Adres'></td>
                                            <td><textarea name="home_address" id="home_address" style="width:140px;height:75px;"><cfoutput>#home_dis##get_consumer.homeaddress#</cfoutput></textarea></td>
                                        </tr>
                                   <cfelse>
                                        <tr>
                                            <td class="me-title">Cadde</td>
                                            <td><input type="text" name="home_main_street" id="home_main_street" style="width:140px;" value="<cfoutput>#get_consumer.home_main_street#</cfoutput>"></td>
                                        </tr>
                                        <tr>
                                            <td class="me-title">Sokak</td>
                                            <td><input type="text" name="home_street" id="home_street" value="<cfoutput>#get_consumer.home_street#</cfoutput>" style="width:140px;"></td>
                                        </tr>
                                        <tr>
                                            <td class="me-title">No</td>
                                            <td><input type="text" name="home_door_no" id="home_door_no" style="width:140px;" value="<cfoutput>#get_consumer.home_door_no#</cfoutput>"></td>
                                        </tr>
                                    </cfif>
                                    <tr>
                                        <td class="me-title"><cf_get_lang_main no='60.Posta Kodu'></td>
                                        <td><input type="text" name="home_postcode" id="home_postcode" maxlength="15" value="<cfoutput>#get_consumer.homepostcode#</cfoutput>" style="width:140px;"></td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </cfif>
            <!--- İş Adresi  --->
            <cfif isDefined('attributes.is_work_address') and attributes.is_work_address eq 1>
                <table cellpadding="2" cellspacing="2" border="0" style="width:100%">
                    <tr class="header">
                        <td onclick="gizle_goster(gizli4);" style="cursor:pointer;" class="header_title_cont"><cf_get_lang no='216.İş Adresim'></td>
                    </tr>
                    <cfif len(get_consumer.work_district_id)>
                        <cfquery name="GET_WORK_DIST" datasource="#DSN#">
                            SELECT DISTRICT_NAME FROM SETUP_DISTRICT WHERE DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_district_id#">
                        </cfquery>
                        <cfset work_dis = '#get_work_dist.district_name# '>
                    <cfelse>
                        <cfset work_dis = ''>
                    </cfif>
                    <tr style="display:none;" id="gizli4">
                        <td style="vertical-align:top;">
                            <div style="float:left; width:50%;">
                                <table>
                                    <tr>
                                        <td class="me-title" style="width:200px;"><cf_get_lang_main no='807.Ülke'></td>
                                        <td><select name="work_country" id="work_country" style="width:145px;" onchange="LoadCity(this.value,'work_city_id','work_county_id',<cfoutput>'#kontrol_zone#'</cfoutput><cfif attributes.is_detail_adres eq 1 and attributes.is_residence_select eq 1>,'work_district_id'</cfif>)">
                                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                <cfoutput query="get_country">
                                                    <option value="#country_id#" <cfif get_consumer.work_country_id eq country_id>selected</cfif>>#country_name#</option>
                                                </cfoutput>
                                            </select>				
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="me-title"><cf_get_lang_main no='559.Şehir'> <cfif attributes.is_cons_adress eq 1>*</cfif></td>
                                        <td><select name="work_city_id" id="work_city_id" onchange="LoadCounty(this.value,'work_county_id','work_telcode','0'<cfif attributes.is_detail_adres eq 1 and attributes.is_residence_select eq 1>,'work_district_id'</cfif>);" style="width:145px;">
                                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                <cfif len(get_consumer.work_city_id)>
                                                    <cfquery name="GET_CITY_WORK" datasource="#DSN#">
                                                        SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_country_id#">
                                                    </cfquery>
                                                    <cfoutput query="get_city_work">
                                                        <option value="#city_id#" <cfif get_consumer.work_city_id eq city_id>selected</cfif>>#city_name#</option>	
                                                    </cfoutput>
                                                </cfif>
                                            </select>
                                        </td>
                                     </tr>
                                     <tr>
                                        <td class="me-title">İlçe <cfif attributes.is_cons_adress eq 1>*</cfif></td>
                                        <td><select name="work_county_id"  id="work_county_id" style="width:145px;" <cfif attributes.is_detail_adres eq 1 and attributes.is_residence_select eq 1>onChange="LoadDistrict(this.value,'work_district_id');"</cfif>>
                                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                <cfif len(get_consumer.work_county_id)>
                                                    <cfquery name="GET_COUNTY_WORK" datasource="#DSN#">
                                                        SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_city_id#">
                                                    </cfquery>										
                                                    <cfoutput query="get_county_work">
                                                        <option value="#county_id#" <cfif get_consumer.work_county_id eq county_id>selected</cfif>>#county_name#</option>
                                                    </cfoutput>
                                                </cfif>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="me-title"><cf_get_lang_main no='720.Semt'></td>
                                        <td><input type="text" name="work_semt" id="work_semt" value="<cfoutput>#get_consumer.worksemt#</cfoutput>" maxlength="30" style="width:140px;"></td>			
                                    </tr>	
                                    <cfif attributes.is_detail_adres eq 1>
                                        <tr>
                                            <td class="me-title">Mahalle</td>
                                            <td>
                                                <cfif attributes.is_residence_select eq 0>
                                                    <input type="text" name="work_district" id="work_district" style="width:140px;" value="<cfif len(get_consumer.work_district)><cfoutput>#get_consumer.work_district#</cfoutput><cfelse><cfoutput>#work_dis#</cfoutput></cfif>">
                                                <cfelse>
                                                    <select name="work_district_id" id="work_district_id" style="width:145px;">
                                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                        <cfif len(get_consumer.work_district_id)>
                                                            <cfquery name="GET_DISTRICT_NAME" datasource="#DSN#">
                                                                SELECT DISTRICT_ID, DISTRICT_NAME FROM SETUP_DISTRICT WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_county_id#">
                                                            </cfquery>										
                                                            <cfoutput query="get_district_name">
                                                                <option value="#district_id#" <cfif get_consumer.work_district_id eq district_id>selected</cfif>>#district_name#</option>
                                                            </cfoutput>
                                                        </cfif>
                                                    </select>
                                                </cfif>
                                            </td>
                                        </tr>
                                    </cfif>
                                </table>
                            </div>
                            <div style="float:left; width:50%;">        
                                <table>
                                    <cfif attributes.is_detail_adres eq 0>
                                        <tr>
                                            <td class="me-title" style="width:150px;"><cf_get_lang_main no='1311.Adres'></td>
                                            <td><textarea name="work_address" id="work_address" style="width:140px;height:75px;"><cfoutput>#work_dis##get_consumer.workaddress#</cfoutput></textarea></td>
                                        </tr>
                                    <cfelse>
                                        <tr>
                                            <td class="me-title" style="width:150px;">Cadde</td>
                                            <td><input type="text" name="work_main_street" İd="work_main_street" style="width:140px;" value="<cfoutput>#get_consumer.work_main_street#</cfoutput>"></td>
                                        </tr>
                                        <tr>
                                            <td class="me-title">Sokak</td>
                                            <td><input type="text" name="work_street" id="work_street" style="width:140px;" value="<cfoutput>#get_consumer.work_street#</cfoutput>"></td>
                                        </tr>
                                        <tr>
                                            <td class="me-title">No</td>
                                            <td><input type="text" name="work_door_no" id="work_door_no" style="width:140px;" value="<cfoutput>#get_consumer.work_door_no#</cfoutput>"></td>
                                        </tr>
                                    </cfif>
                                    <tr>
                                        <td class="me-title"><cf_get_lang_main no='60.Posta Kodu'></td>
                                        <td><input type="text" name="work_postcode" id="work_postcode" maxlength="15" value="<cfoutput>#get_consumer.workpostcode#</cfoutput>" style="width:140px;"></td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </cfif>
        <!---<cfelse>
            <cfinclude template="upd_cons_address.cfm">
        </cfif>--->
        <!--- İş Adresi  --->
        <cfif (isdefined("attributes.is_tax_adress") and attributes.is_tax_adress eq 1) or not isdefined("attributes.is_tax_adress")>
            <table cellpadding="2" cellspacing="2" border="0" style="width:100%">
                <tr class="header">
                    <td onclick="gizle_goster(gizli5);" style="cursor:pointer;" class="header_title_cont"><cf_get_lang no='220.Fatura Adresim'></td>
                </tr>
                <cfif len(get_consumer.tax_district_id)>
                    <cfquery name="GET_TAX_DIST" datasource="#DSN#">
                        SELECT DISTRICT_NAME FROM SETUP_DISTRICT WHERE DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.tax_district_id#">
                    </cfquery>
                    <cfset tax_dis = '#get_tax_dist.district_name# '>
                <cfelse>
                    <cfset tax_dis = ''>
                </cfif>
                <tr style="display:none;" id="gizli5">
                    <td class="contentforlabel" style="vertical-align:top;">
                        <div style="float:left; width:50%;">
                            <table>
                                <tr>
                                    <td class="me-title" style="width:200px;">Vergi Dairesi</td>
                                    <td><input type="text" name="tax_office" id="tax_office" value="<cfoutput>#get_consumer.tax_office#</cfoutput>" maxlength="50" style="width:140px;"></td>
                                </tr>
                                <tr>
                                    <td class="me-title"><cf_get_lang_main no='807.Ülke'></td>
                                    <td><select name="tax_country" id="tax_country" style="width:145px;" onchange="LoadCity(this.value,'tax_city_id','tax_county_id',<cfoutput>'#kontrol_zone#'</cfoutput><cfif attributes.is_detail_adres eq 1 and attributes.is_residence_select eq 1>,'tax_district_id'</cfif>)">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            <cfoutput query="get_country">
                                                <option value="#country_id#" <cfif get_consumer.tax_country_id eq country_id>selected</cfif>>#country_name#</option>
                                            </cfoutput>
                                        </select>				
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="me-title"><cf_get_lang_main no='559.Şehir'> <cfif attributes.is_cons_adress eq 1>*</cfif></td>
                                    <td><select name="tax_city_id" id="tax_city_id" onchange="LoadCounty(this.value,'tax_county_id','','0'<cfif attributes.is_detail_adres eq 1 and attributes.is_residence_select eq 1>,'tax_district_id'</cfif>);" style="width:145px;">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            <cfif len(get_consumer.tax_country_id)>
                                                <cfquery name="GET_CITY_TAX" datasource="#DSN#">
                                                    SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.tax_country_id#">
                                                </cfquery>
                                                <cfoutput query="get_city_tax">
                                                    <option value="#city_id#" <cfif get_consumer.tax_city_id eq city_id>selected</cfif>>#city_name#</option>	
                                                </cfoutput>
                                            </cfif>
                                        </select>
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="me-title">İlçe <cfif attributes.is_cons_adress eq 1>*</cfif></td>
                                    <td><select name="tax_county_id" id="tax_county_id"  <cfif attributes.is_detail_adres eq 1 and attributes.is_residence_select eq 1>onChange="LoadDistrict(this.value,'tax_district_id');"</cfif> style="width:145px;">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            <cfif len(get_consumer.tax_county_id)>
                                                <cfquery name="GET_COUNTY_TAX" datasource="#DSN#">
                                                    SELECT * FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.tax_city_id#">
                                                </cfquery>										
                                                <cfoutput query="get_county_tax">
                                                    <option value="#county_id#" <cfif get_consumer.tax_county_id eq county_id>selected</cfif>>#county_name#</option>
                                                </cfoutput>
                                            </cfif>
                                        </select>
                                    </td>
                                 </tr>
                                 <tr>
                                    <td class="me-title"><cf_get_lang_main no='720.Semt'></td>
                                    <td><input type="text" name="tax_semt" id="tax_semt" value="<cfoutput>#get_consumer.tax_semt#</cfoutput>" maxlength="30" style="width:140px;"></td>			
                                </tr>	
                                <cfif attributes.is_detail_adres eq 1>
                                    <tr>
                                        <td class="me-title">Mahalle</td>
                                        <td><cfif attributes.is_residence_select eq 0>
                                                <input type="text" name="tax_district" id="tax_district" style="width:140px;" value="<cfif len(get_consumer.tax_district)><cfoutput>#get_consumer.tax_district#</cfoutput><cfelse><cfoutput>#tax_dis#</cfoutput></cfif>">
                                            <cfelse>
                                                <select name="tax_district_id" id="tax_district_id" style="width:145px;">
                                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                    <cfif len(get_consumer.tax_district_id)>
                                                        <cfquery name="GET_DISTRICT_NAME" datasource="#DSN#">
                                                            SELECT DISTRICT_ID, DISTRICT_NAME FROM SETUP_DISTRICT WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.tax_county_id#">
                                                        </cfquery>										
                                                        <cfoutput query="get_district_name">
                                                            <option value="#district_id#" <cfif get_consumer.tax_district_id eq district_id>selected</cfif>>#district_name#</option>
                                                        </cfoutput>
                                                    </cfif>
                                                </select>
                                            </cfif>
                                        </td>
                                    </tr>
                                </cfif>
                            </table>
                        </div>
                        <div style="float:left; width:50%;">
                            <table>
                                <tr>
                                    <td class="me-title" style="width:150px;">Vergi No</td>
                                    <td>
                                        <input type="text" name="tax_no" id="tax_no" value="<cfoutput>#get_consumer.tax_no#</cfoutput>" onkeyup="isNumber(this);" maxlength="30" style="width:140px;">	
                                    </td>
                                </tr>
                                <cfif attributes.is_detail_adres eq 0>
                                    <td class="me-title"><cf_get_lang_main no='1311.Adres'></td>
                                    <td rowspan="3"><textarea name="tax_address" id="tax_address" style="width:140px;height:75px;"><cfoutput>#tax_dis##get_consumer.tax_adress#</cfoutput></textarea></td>
                                <cfelse>
                                    <tr>
                                        <td class="me-title">Cadde</td>
                                        <td><input type="text" name="tax_main_street" id="tax_main_street" style="width:140px;" value="<cfoutput>#get_consumer.tax_main_street#</cfoutput>"></td>
                                    </tr>
                                    <tr>
                                        <th class="me-title">Sokak</th>
                                        <td><input type="text" name="tax_street" id="tax_street" style="width:140px;" value="<cfoutput>#get_consumer.tax_street#</cfoutput>"></td>
                                    </tr>
                                    <tr>
                                        <td class="me-title">No</td>
                                        <td><input type="text" name="tax_door_no" id="tax_door_no" style="width:140px;" value="<cfoutput>#get_consumer.tax_door_no#</cfoutput>"></td>
                                    </tr>
                                    <tr>
                                        <td class="me-title"><cf_get_lang_main no='60.Posta Kodu'></td>
                                        <td><input type="text" name="tax_postcode" id="tax_postcode" maxlength="15" value="<cfoutput>#get_consumer.tax_postcode#</cfoutput>" style="width:140px;"></td>
                                    </tr>
                                </cfif>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
        </cfif>
        <!--- Hobi --->
        <cfif isdefined("attributes.is_consumer_hoby") and attributes.is_consumer_hoby eq 1>
            <table cellpadding="2" cellspacing="2" border="0" style="width:100%">
                <tr class="header">
                    <td onclick="gizle_goster(gizli6);" style="cursor:pointer;" class="header_title_cont"><cf_get_lang no='222.Hobilerim'> / <cf_get_lang no='856.İlgi Alanlarım'></td>
                </tr>
                <tr style="display:none;" id="gizli6">
                    <td class="contentforlabel" style="vertical-align:top;">
                        <div style="float:left; width:50%;">
                            <cfif isdefined("attributes.member_coloum_number") and len(attributes.member_coloum_number)>
                                <cfparam name="attributes.member_coloum_number" default="#attributes.member_coloum_number#">
                            <cfelse>
                                <cfparam name="attributes.member_coloum_number" default="1">
                            </cfif>
                            <cfquery name="GET_HOBBY" datasource="#DSN#">
                                SELECT HOBBY_ID, HOBBY_NAME FROM SETUP_HOBBY ORDER BY HOBBY_NAME
                            </cfquery>
                            <cfquery name="GET_CONSUMER_HOBBIES" datasource="#DSN#"> 
                                SELECT 
                                    HOBBY_ID 
                                FROM 
                                    CONSUMER_HOBBY
                                WHERE 
                                    <cfif isdefined("attributes.cid")>
                                        CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">
                                    <cfelse>
                                        CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
                                    </cfif>
                            </cfquery>
                            <cfset liste = valuelist(get_consumer_hobbies.hobby_id)>
                            <table>
                                <cfset this_row_ = 0>
                                <cfoutput query="get_hobby">
                                    <cfset this_row_ = this_row_ + 1>
                                    <cfif this_row_ mod attributes.member_coloum_number eq 1><tr></cfif>
                                        <td>
                                            <label for="hobby_id_#get_hobby.hobby_id#">
                                            <input type="checkbox" name="hobby" value="#get_hobby.hobby_id#" id="hobby_id_#get_hobby.hobby_id#"<cfif liste contains hobby_id>checked</cfif>> #get_hobby.hobby_name#</label>&nbsp;&nbsp;
                                        </td>
                                    <cfif this_row_ mod attributes.member_coloum_number eq 0></tr></cfif>
                                </cfoutput>
                            </table>
                         </div>
                    </td>
                  </tr>
            </table>
        </cfif>
        <!--- yetkinlik --->
        <cfif isdefined("attributes.is_consumer_req_type") and attributes.is_consumer_req_type eq 1>
            <table cellpadding="2" cellspacing="2" border="0" style="width:100%">
                <tr class="header">
                    <td onclick="gizle_goster(gizli7);" style="cursor:pointer;" class="header_title_cont"><cf_get_lang_main no='1297.Yetkinliklerim'></td>
                </tr>
                <tr style="display:none;" id="gizli7">
                    <td class="contentforlabel" style="vertical-align:top;"> 
                        <div style="float:left; width:50%;">
                            <cfif isdefined("attributes.member_coloum_number") and len(attributes.member_coloum_number)>
                                <cfparam name="attributes.member_coloum_number" default="#attributes.member_coloum_number#">
                            <cfelse>
                                <cfparam name="attributes.member_coloum_number" default="1">
                            </cfif>
                            <cfquery name="GET_REQ" datasource="#DSN#">
                                SELECT REQ_ID, REQ_NAME FROM SETUP_REQ_TYPE
                            </cfquery>
                            <cfquery name="GET_CONSUMER_REQ" datasource="#DSN#"> 
                                SELECT 
                                    REQ_ID 	
                                FROM 
                                    MEMBER_REQ_TYPE 
                                WHERE 
                                    <cfif isdefined("attributes.cid")>
                                        CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">
                                    <cfelse>
                                        CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
                                    </cfif>
                            </cfquery>
                            <cfset liste = valuelist(get_consumer_req.req_id)>
                            <table border="0" cellpadding="2" cellspacing="1">
                                <cfset this_row_2 = 0>
                                <cfoutput query="get_req">
                                    <cfset this_row_2 = this_row_2 + 1>
                                    <cfif this_row_2 mod attributes.member_coloum_number eq 1><tr></cfif>
                                        <td><label for="req_id_#get_req.req_id#">
                                            <input type="checkbox" name="req" value="#get_req.req_id#" id="req_id_#get_req.req_id#"<cfif liste contains req_id>checked</cfif>>#get_req.req_name#
                                            </label>&nbsp;&nbsp;
                                        </td>
                                    <cfif this_row_2 mod attributes.member_coloum_number eq 0></tr></cfif>
                                </cfoutput>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
        </cfif>
        <!--- egitim --->
        <cfif isdefined("attributes.is_consumer_education") and attributes.is_consumer_education eq 1>
            <table cellpadding="2" cellspacing="2" border="0" style="width:100%">
                <tr class="header">
                    <td onclick="gizle_goster(gizli8);" style="cursor:pointer;" class="header_title_cont"><cf_get_lang no='225.Egitim Bilgilerim'></td>
                </tr>
                <tr style="display:none;" id="gizli8">
                    <td class="contentforlabel" style="vertical-align:top;">
                       <cfinclude template="form_cons_education_info.cfm">
                    </td>
                </tr>
            </table>
        </cfif>
        <!--- diğer adresler --->
        <table cellpadding="2" cellspacing="2" border="0" style="width:100%">
            <cfif isdefined("attributes.is_other_address") and attributes.is_other_address eq 1>
                <tr class="header">
                    <td onclick="gizle_goster(gizli9);" style="cursor:pointer;" class="header_title_cont">Diğer Adresler</td>
                </tr>
                <tr style="display:none;" id="gizli9">
                    <td class="contentforlabel" style="vertical-align:top;">
                        <cfinclude template="dsp_consumer_address.cfm">
                    </td>
                </tr>
            </cfif>
            <cfif not isdefined("attributes.cid")>
                <tr style="height:35px;">
                    <td  style="text-align:right;"><cf_workcube_buttons is_upd='1' class="button" is_delete='0' add_function='kontrol()'></td>
                </tr>
            </cfif>
        </table>
    </cfform>
	<script type="text/javascript">
            <cfif isdefined("attributes.is_tc_number")>
                var is_tc_number = '<cfoutput>#attributes.is_tc_number#</cfoutput>';
            <cfelse>
                var is_tc_number = 0;
            </cfif>
            <cfif isdefined("attributes.is_change_tcnumber")>
                var is_change_tcnumber = '<cfoutput>#attributes.is_change_tcnumber#</cfoutput>';
            <cfelse>
                var is_change_tcnumber = 0;
            </cfif>		
            
            <cfif isdefined("attributes.is_cons_adress")>
                var is_cons_adress = '<cfoutput>#attributes.is_cons_adress#</cfoutput>';
            <cfelse>
                var is_cons_adress = 0;
            </cfif>
            <cfif isdefined("attributes.is_cons_district")>
                var is_cons_district = '<cfoutput>#attributes.is_cons_district#</cfoutput>';
            <cfelse>
                var is_cons_district = 0;
            </cfif>	
            <cfif isdefined("attributes.is_cons_street")>
                var is_cons_street = '<cfoutput>#attributes.is_cons_street#</cfoutput>';
            <cfelse>
                var is_cons_street = 0;
            </cfif>	
            <cfif isDefined('attributes.is_home_address') and attributes.is_home_address eq 1>
                var home_country_= document.getElementById('home_country').value;
                <cfif not len(get_consumer.home_city_id)>
                    if(home_country_.length)
                        LoadCity(home_country_,'home_city_id','home_county_id',<cfoutput>'#kontrol_zone#'</cfoutput>)
                </cfif>
                var home_city_= document.getElementById('home_city_id').value;
                <cfif not len(get_consumer.home_county_id)>
                    if(home_city_.length)
                        LoadCounty(home_city_,'home_county_id')
                </cfif>
                if(document.getElementById('home_district_id') != undefined)
                {
                    var home_county_= document.getElementById('home_county_id').value;
                    <cfif not len(get_consumer.home_district_id)>
                        if(home_county_.length)
                            LoadDistrict(home_county_,'home_district_id')
                    </cfif>
                }	
            </cfif>
            <cfif isDefined('attributes.is_work_address') and attributes.is_work_address eq 1>
                var work_country_= document.getElementById('work_country').value;
                <cfif not len(get_consumer.work_city_id)>
                    if(work_country_.length)
                        LoadCity(work_country_,'work_city_id','work_county_id',<cfoutput>'#kontrol_zone#'</cfoutput>)
                </cfif>
                var work_city_= document.getElementById('work_city_id').value;
                <cfif not len(get_consumer.work_county_id)>
                    if(work_city_.length)
                        LoadCounty(work_city_,'work_county_id')
                </cfif>
                if(document.getElementById('work_district_id') != undefined)
                {
                    var work_county_= document.getElementById('work_county_id').value;
                    <cfif not len(get_consumer.work_district_id)>
                        if(work_county_.length)
                            LoadDistrict(work_county_,'work_district_id')
                    </cfif>
                }	
            </cfif>
            if(document.getElementById('tax_country') != undefined)
            {
                var tax_country_= document.getElementById('tax_country').value;
                <cfif not len(get_consumer.tax_city_id)>
                    if(tax_country_.length)
                        LoadCity(tax_country_,'tax_city_id','tax_county_id',<cfoutput>'#kontrol_zone#'</cfoutput>)
                </cfif>
                var tax_city_= document.getElementById('tax_city_id').value;
                <cfif not len(get_consumer.tax_county_id)>
                    if(tax_city_.length)
                        LoadCounty(tax_city_,'tax_county_id')
                </cfif>
                if(document.getElementById('tax_district_id') != undefined)
                {
                    var tax_county_= document.getElementById('tax_city_id').value;
                    <cfif not len(get_consumer.tax_district_id)>
                        if(tax_county_.length)
                            LoadDistrict(tax_county_,'tax_district_id')
                    </cfif>
                }
            }
            if(document.getElementById('country') != undefined)
            {
                var country_ = document.getElementById('country').value;
                if(country_.length)
                    LoadCity(country_,'city_id','county_id',<cfoutput>'#kontrol_zone#'</cfoutput>);
            }
            
            function kontrol()
            {   
                <cfif isdefined("attributes.is_tel_length_kontrol") and attributes.is_tel_length_kontrol eq 1>
                    if(!form_warning('mobiltel','<cf_get_lang no="119.Mobil telefonunuz yedi hane olmalıdır !">',7))return false;
                    if(!form_warning('mobiltel_2','<cf_get_lang no="120.İkinci mobil telefonunuz yedi hane olmalıdır !">',7))return false;
                    if(!form_warning('home_tel','<cf_get_lang no="121.Ev telefonunuz yedi hane olmalıdır !">',7))return false;
                    if(!form_warning('work_tel','<cf_get_lang no="153.İş Telefon numaranız yedi hane olmalıdır !">',7))return false;
                </cfif>
                <cfif isdefined("attributes.is_pass_control") and attributes.is_pass_control eq 1>
                    var ValidChars = "0123456789";
                    var IsNumber=true;
                    var Char; 
                    if(document.getElementById('consumer_password') != undefined && document.getElementById('consumer_password').value != '')	
                    {
                        for (kk = 0; kk < document.getElementById('consumer_password').value.length && IsNumber == true; kk++) 
                        { 
                            Char = document.getElementById('consumer_password').value.charAt(kk);
                            if (ValidChars.indexOf(Char) == -1) 
                            {
                                IsNumber = false;
                            }
                        }
                        if(document.getElementById('consumer_password').value.length != 6 || IsNumber == false)
                        {
                            alert("<cf_get_lang no='112.Şifreniz en az altı karakterli olmalı ve sadece rakamlardan oluşmalıdır!'>");
                            document.getElementById('consumer_password').focus();
                            return false;
                        }
                    }
                </cfif>
                
                if(is_tc_number== 1 && is_change_tcnumber == 1)
                {
                    if(!isTCNUMBER(document.getElementById('tc_identity_no'))) return false;
                }
                
                if(document.getElementById('tc_identity_no').value != "")
                {
                    var consumer_control = wrk_safe_query("obj2_consumer_control_2",'dsn',0,document.getElementById('tc_identity_no').value);
                    if(consumer_control.recordcount > 0)
                    {
                        alert("<cf_get_lang no ='1083.Aynı TC Kimlik Numarası İle Kayıtlı Üye Var Lütfen Bilgilerinizi Kontrol Ediniz'> !");
                        document.getElementById('tc_identity_no').focus();
                        return false;
                    }
                }
                
                if(document.getElementById('picture') != undefined)
                {
                    var obj =  document.getElementById('picture').value;
                    if ((obj != "") && !((obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'jpg')   || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'gif') || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'png')))
                    {
                        alert("<cf_get_lang no ='515.Lütfen bir resim dosyası(gif,jpg veya png) giriniz !'>");
                        return false;
                    }
                }
    
                <cfif attributes.is_detail_adres eq 0>
                    if(document.getElementById('work_address') != undefined)
                    {
                        y = (75 - document.getElementById('work_address').value.length);
                        if ( y < 0 )
                        {
                            alert ("<cf_get_lang no ='1177.İş adresi içerisindeki fazla karakter sayısı'> :"+ ((-1) * y));
                            document.getElementById('work_address').focus();
                            return false;
                        }
                    }
                
                    if(document.getElementById('home_address') != undefined)
                    {
                        z = (200 - document.getElementById('home_address').value.length);
                        if ( z < 0 )
                        {
                            alert ("<cf_get_lang no ='1533.Ev adresi içerisindeki fazla karakter sayısı'> :"+ ((-1) * z));
                            document.getElementById('home_address').focus();
                            return false;
                        }
                    }
                    if(document.getElementById('tax_address') != undefined)
                    {
                        v = (200 - document.getElementById('tax_address').value.length);
                        if ( v < 0 )
                        { 
                            alert ("<cf_get_lang no ='156.Fatura adresi içerisindeki fazla karakter sayısı'> :"+ ((-1) * v));
                            document.getElementById('tax_address').focus();
                            return false;
                        }
                    }
                </cfif>
                if(document.getElementById('home_city_id') != undefined)
                {
                    x = document.getElementById('home_city_id').selectedIndex;
                    if (is_cons_adress == 1 /*&& document.getElementById('home_address').value != ""*/ && document.getElementById('home_city_id')[x].value == "")
                    {
                        alert("<cf_get_lang no ='32.Lütfen bir şehir seçiniz!'>");
                        document.getElementById('home_city_id').focus();
                        return false;
                    }
                }
                if(document.getElementById('home_county_id') != undefined)
                {
                    x = document.getElementById('home_county_id').selectedIndex;
                    if (is_cons_adress == 1 /*&& document.getElementById('home_address').value != ""*/ && document.getElementById('home_county_id')[x].value == "")
                    {
                        alert("<cf_get_lang no ='1357.Lütfen bir ilçe seçiniz'> !");
                        document.getElementById('home_county_id').focus();
                        return false;
                    }
                }
                if(document.getElementById('work_city_id') != undefined)
                {
                    x = document.getElementById('work_city_id').selectedIndex;
                    if (is_cons_adress == 1 /*&& document.getElementById('work_address').value != ""*/ && document.getElementById('work_city_id')[x].value == "")
                    {
                        alert("<cf_get_lang no ='32.Lütfen bir şehir seçiniz!'>");
                        document.getElementById('work_city_id').focus();
                        return false;
                    }
                }
                if(document.getElementById('work_county_id') != undefined)
                {
                    x = document.getElementById('work_county_id').selectedIndex;
                    if (is_cons_adress == 1 /*&& document.upd_consumer.work_address.value != ""*/ && document.getElementById('work_county_id')[x].value == "")
                    {
                        alert("<cf_get_lang no ='1357.Lütfen bir ilçe seçiniz'> !");
                        document.getElementById('work_county_id').focus();
                        return false;
                    }
                }
                if(document.getElementById('tax_city_id') != undefined)
                {
                    x = document.upd_consumer.tax_city_id.selectedIndex;
                    if (is_cons_adress == 1 /*&& document.getElementById('tax_address').value != ""*/ && document.getElementById('tax_city_id')[x].value == "")
                    {
                        alert("<cf_get_lang no ='32.Lütfen bir şehir seçiniz!'>");
                        document.getElementById('tax_city_id').focus();
                        return false;
                    }
                }
                if(document.getElementById('tax_county_id') != undefined)
                {
                    x = document.getElementById('tax_county_id').selectedIndex;
                    if (is_cons_adress == 1 /*&& document.upd_consumer.tax_address.value != ""*/ && document.getElementById('tax_county_id')[x].value == "")
                    {
                        alert("<cf_get_lang no ='1357.Lütfen bir ilçe seçiniz'> !");
                        document.getElementById('tax_county_id').focus();
                        return false;
                    }
                }
                <cfif isdefined("attributes.is_residence_select") and attributes.is_residence_select eq 0>
                    if(document.getElementById('home_district') != undefined && is_cons_district == 1 && document.getElementById('home_district').value == "")
                    {
                        alert("<cf_get_lang no ='1358.Lütfen mahalle seçiniz!'>");
                        document.getElementById('home_district').focus();
                        return false;
                    }
                <cfelse>
                    if(document.getElementById('home_district_id') != undefined)
                    {
                        x = document.getElementById('home_district_id').selectedIndex;
                        if(is_cons_district == 1 && document.getElementById('home_district_id')[x].value == "")
                        {
                            alert("<cf_get_lang no ='1358.Lütfen mahalle seçiniz!'>");
                            document.getElementById('home_district_id').focus();
                            return false;
                        }
                    }
                </cfif>
                if(is_cons_street == 1 && ((document.getElementById('home_main_street').value == "" || document.getElementById('home_street').value == "")))
                {
                    alert("<cf_get_lang no ='1359.Sokak veya caddeden birini girmelisiniz!'>");
                    document.getElementById('home_main_street').focus();
                    return false;
                }
                <cfif isdefined("attributes.is_other_address") and attributes.is_other_address eq 1>
                    if(add_address != undefined && add_address.style.display == '')
                    {
                        if(document.getElementById('contact_name') != undefined)
                        {
                            if(document.getElementById('contact_name').value == "")
                            {
                                alert("<cf_get_lang no ='157.Lütfen adres adı giriniz!'>");
                                return false;
                            }
                        }
                        if(document.getElementById('contact_telcode') != undefined)
                        {
                            if(document.getElementById('contact_telcode').value == "")
                            {
                                alert("<cf_get_lang no ='161.Diğer adres için telefon kodu girmelisiniz !'>");
                                return false;
                            }
                        }
                        if(document.getElementById('contact_tel1') != undefined)
                        {
                            if(document.getElementById('contact_tel1').value == "")
                            {
                                alert("<cf_get_lang no ='162.Diğer adres için telefon numarası girmelisiniz !'>");
                                return false;
                            }
                        }
                        if(document.getElementById('contact_address') != undefined)
                        {
                            z = (200 - document.getElementById('contact_address').value.length);
                            if ( z < 0 )
                            { 
                                alert ("<cf_get_lang_main no ='1687.Fazla karakter sayısı'> :"+ ((-1) * z));
                                return false;
                            }
                        }
                        if(document.getElementById('contact_detail') != undefined)
                        {
                            z = (100 - document.getElementById('contact_detail').value.length);
                            if ( z < 0 )
                            { 
                                alert ("<cf_get_lang_main no ='217.Açıklama'>"+ ((-1) * z) +"Karakter Uzun !");
                                return false;
                            }
                        }
                    }
                </cfif>
                <cfif  isdefined('attributes.xml_check_cell_phone') and attributes.xml_check_cell_phone eq 1>
                    if(document.getElementById('mobilcat_id').value != "" && document.getElementById('mobiltel').value != "")
                    {
                        
                        var listParam = document.getElementById('mobilcat_id').value + "*" + document.getElementById('mobiltel').value;
                        var get_results = wrk_safe_query('mr_add_cell_phone',"dsn",0,listParam);
                        if(get_results.recordcount>0)
                        {
                              alert("<cf_get_lang no ='78.Girdiğiniz mobil telefona kayıtlı başka temsilci bulunmaktadır!'>");
                              document.getElementById('mobiltel').focus();
                              return false;
                        }              
                    }
                </cfif>
                if(confirm("<cf_get_lang_main no ='2117.Girdiğiniz bilgileri kaydetmek üzeresiniz, lütfen değişiklikleri onaylayınız!'>")) return true; else return false;
            }
        </script>
    <cfelse>
		<cfoutput>
            <input type="hidden" name="is_other_address" id="is_other_address" value="#attributes.is_other_address#">
            <cfif isdefined('attributes.orderww_back') and len(attributes.orderww_back)>
                <input type="hidden" name="orderww_back" id="orderww_back" value="#attributes.orderww_back#">
            </cfif>
            <!---Temel Bilgiler --->
            <table cellpadding="2" cellspacing="2" border="0" style="width:100%">
                <tr class="header">
                    <td onclick="gizle_goster(gizli992);" style="cursor:pointer;" class="header_title_cont"><cf_get_lang_main no='719.Temel Bilgiler'></td>
                </tr>
                <tr id="gizli992">
                    <td>
                        <div style="float:left; width:50%">
                            <table>
                                <tr>
                                    <cfif isdefined("attributes.is_ref_info") and attributes.is_ref_info eq 1>
                                        <td class="me-title" width="200"><cf_get_lang_main no='1224.Referans Üye'></td> 
                                        <td class="inner-menu-link"><cfif len(get_consumer.ref_pos_code)>#get_cons_info(get_consumer.ref_pos_code,0,0)#</cfif><td>
                                    </cfif>
                                </tr>
                                <cfif isdefined("attributes.is_member_code") and attributes.is_member_code eq 1>
                                    <tr>
                                        <td class="me-title"><cf_get_lang no='1508.Üye Kodu'></td>
                                        <td>#get_consumer.member_code#</td>
                                    </tr>
                                </cfif>
                                <tr>
                                    <td class="me-title"><cf_get_lang_main no='219.Ad'> *</td>
                                    <td>#get_consumer.consumer_name#</td>
                                </tr>
                                <tr>
                                    <td class="me-title"><cf_get_lang_main no='1314.Soyad'>*</td>
                                    <td>#get_consumer.consumer_surname#</td>
                                </tr>
                                <cfif (isdefined("attributes.is_change_cat") and attributes.is_change_cat eq 1) or not isdefined("attributes.is_change_cat")>
                                    <tr>
                                        <td class="me-title"><cf_get_lang_main no='1197.Üye Kategorisi'></td>
                                        <td>
                                            <cfloop query="get_consumer_cat">
                                                <cfif conscat_id eq get_consumer.consumer_cat_id>#conscat#</cfif>
                                            </cfloop>
                                        </td>
                                    </tr>
                                <cfelseif isdefined("attributes.is_change_cat") and attributes.is_change_cat eq 0>
                                    <tr>
                                        <td class="me-title"><cf_get_lang_main no='1197.Üye Kategorisi'></td>
                                        <td>
                                            #get_cons_row.conscat#
                                            <input type="hidden" name="consumer_cat_id" id="consumer_cat_id" value="<cfoutput>#get_consumer.consumer_cat_id#</cfoutput>">
                                        </td>
                                    </tr>
                                </cfif>
                                <cfif (isdefined("attributes.is_user_name") and attributes.is_user_name eq 1) or not isdefined("attributes.is_user_name")>
                                    <tr>
                                        <th class="me-title"><cf_get_lang_main no='139.Kullanıcı Adı'></th>
                                        <td>#get_consumer.consumer_username#</td>
                                    </tr>
                                </cfif>
                                <cfif (isdefined("attributes.is_timeout") and attributes.is_timeout eq 1) or not isdefined("attributes.is_timeout")>
                                    <tr>
                                        <th class="me-title"><cf_get_lang no='228.Timeout Süresi'></th>
                                        <td>#get_consumer.timeout_limit# dk.</td>
                                    </tr>
                                </cfif>
                            </table>
                        </div>
                        <div style="float:left; width:50%">
                            <table>
                                <tr>
                                    <cfif isdefined("attributes.is_work_pos") and attributes.is_work_pos eq 1>
                                        <td class="me-title" width="150"><cf_get_lang_main no='496.Temsilci'></td> 
                                        <td class="me-title"><cfif get_pos_info.recordcount and len(get_pos_info.position_code)>#get_emp_info(get_pos_info.position_code,1,0)#</cfif><td>
                                    </cfif>
                                </tr>
                                <tr>
                                    <td class="me-title"><cf_get_lang_main no='16.E-posta'></td>
                                    <td>#get_consumer.consumer_email#</td>
                                </tr>
                                <tr>
                                    <td class="me-title"><cf_get_lang_main no='1070.Mobil Telefon'></th>
                                    <td>
                                        <cfloop query="get_mobilcat">
                                           <cfif mobilcat eq get_consumer.mobil_code>#mobilcat#</cfif>
                                        </cfloop>
                                        #get_consumer.mobiltel#
                                    </td>
                                </tr>
                                <tr>
                                    <td class="me-title"><cf_get_lang_main no='1070.Mobil Tel'> 2</th>
                                    <td>
                                        <cfloop query="get_mobilcat">
                                            <cfif mobilcat eq get_consumer.mobil_code_2>#mobilcat#</cfif>
                                        </cfloop>
                                        #get_consumer.mobiltel_2#
                                    </td>
                                </tr>
                                <tr>
                                    <td class="me-title"><cf_get_lang no='227.İş Tel'></th>
                                    <td>#get_consumer.consumer_worktelcode# #get_consumer.consumer_worktel#
                                    </td>
                                </tr>
                                <cfif (isdefined("attributes.is_internet_page") and attributes.is_internet_page eq 1) or not isdefined("attributes.is_internet_page")>
                                    <tr>
                                        <th class="me-title"><cf_get_lang no='196.İnternet Sitesi'></th>
                                        <td><input type="text" name="homepage" id="homepage" value="<cfoutput>#get_consumer.homepage#</cfoutput>" maxlength="50" style="width:143px;"></td>
                                    </tr>
                                </cfif>
                            </table>
                       </div>
                    </td>
                </tr>
            </table>
            <!--- Kişisel Bilgiler --->
            <table cellpadding="2" cellspacing="2" border="0" style="width:100%">
                <tr class="header">
                    <td onclick="gizle_goster(gizli1);" style="cursor:pointer;" class="header_title_cont"><cf_get_lang no='197.Kişisel Bilgilerim '></td>
                </tr>
                <tr id="gizli1">
                    <td>
                        <div style="float:left; width:50%">
                            <table>
                                <tr>
                                    <td class="me-title" width="200"><cf_get_lang_main no='378.Doğum Yeri'></td>
                                    <td>#get_consumer.birthplace#</td>
                                </tr>
                                <tr>
                                    <td class="me-title"><cf_get_lang no='205.Eğitim Durumu'></td>
                                    <td>
                                        <cfloop query="get_edu_level">
                                           <cfif get_consumer.education_id eq edu_level_id>#education_name#</cfif>
                                        </cfloop>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="me-title"><cf_get_lang_main no='352.Cinsiyet'></td>
                                    <td>
                                        <cfif get_consumer.sex eq 1><cf_get_lang_main no='1547.Erkek'></cfif>
                                        <cfif get_consumer.sex eq 0><cf_get_lang_main no='1546.Kadin'></cfif>
                                    </td>
                                </tr>
                                <tr>  	
                                    <td class="me-title"><cf_get_lang no='206.Çocuk Sayısı'></td>
                                    <td>#get_consumer.child#</td>
                                </tr>
                                <tr> 
                                    <td class="me-title"><cf_get_lang no='201.Evlilik Durumu'></td>
                                    <td><cfif get_consumer.married eq 1><cf_get_lang no='209.Evli'></cfif></td>
                                </tr>
                            </table>
                         </div>
                         <div style="float:left; width:50%">
                            <table>
                                <tr>
                                    <td class="me-title" style="width:150px;"><cf_get_lang_main no='1315.Doğum Tarihi'></td>
                                    <td nowrap="nowrap">#dateformat(get_consumer.birthdate,'dd/mm/yyyy')#</td>
                                </tr>
                                <cfif (isdefined("attributes.is_language") and attributes.is_language eq 1) or not isdefined("attributes.is_language")>
                                    <tr>
                                        <td class="me-title"><cf_get_lang_main no='1584.Dil'></td>
                                        <td>
                                            <cfloop query="get_language">
                                                #language_set#
                                            </cfloop>
                                        </td>
                                    </tr>
                                </cfif>
                                <tr>
                                    <td class="me-title"><cf_get_lang_main no='613.TC Kimlik No'><cfif isdefined("attributes.is_tc_number") and attributes.is_tc_number> *</cfif></td>
                                    <td>#get_consumer.tc_identy_no#</td>
                                </tr>
                                <cfif isdefined("attributes.is_bank_account") and attributes.is_bank_account eq 1>
                                    <cfquery name="GET_BANK_ACCOUNT" datasource="#DSN#">
                                        SELECT 
                                            CONSUMER_BANK,
                                            CONSUMER_BANK_BRANCH,
                                            CONSUMER_ACCOUNT_NO
                                        FROM 
                                            CONSUMER_BANK 
                                        WHERE 
                                            <cfif isdefined("attributes.cid")>
                                                CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">
                                            <cfelse>
                                                CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
                                            </cfif>
                                            AND CONSUMER_ACCOUNT_DEFAULT = 1
                                    </cfquery>
                                    <tr>
                                        <td class="me-title">Banka Hesabı</td>
                                        <td>#get_bank_account.consumer_bank#-#get_bank_account.consumer_bank_branch#-#get_bank_account.consumer_account_no#</td>
                                    </tr>
                                </cfif>
                                <cfif (isdefined("attributes.is_nationality") and attributes.is_nationality eq 1) or not isdefined("attributes.is_nationality")>
                                    <tr style="height:20px;">
                                        <td class="me-title"><cf_get_lang no='202.Uyruğu'></td>
                                        <td>
                                            <cfloop query="get_country">
                                                <cfif country_id eq get_consumer.nationality>#country_name#</cfif>
                                            </cfloop>
                                        </td>
                                    </tr>
                                </cfif>
                                <cfif (isdefined("attributes.is_photo") and attributes.is_photo eq 1) or not isdefined("attributes.is_photo")>
                                    <tr>  	
                                        <th class="me-title"><cf_get_lang no='207.Fotoğraf'></th>
                                        <td><cf_get_server_file output_file="member/consumer/#get_consumer.picture#" output_server="#get_consumer.picture_server_id#" output_type="0" image_width="100" alt="#getLang('main',668)#" title="#getLang('main',668)#"></td>
                                    </tr>
                                    <tr>
                                        <th class="me-title"><cf_get_lang no='208.Fotoğrafı Sil'></th>
                                        <td><input type="checkbox" name="del_photo" id="del_photo" value="1"></td>
                                    </tr>
                                </cfif>
                            </table>	
                         </div>
                    </td>
                </tr>
            </table>
            <cfif (isdefined("attributes.is_work_info") and attributes.is_work_info eq 1) or not isdefined("attributes.is_work_info")>
                <!--- İş Meslek Bilgileri --->
                <table cellpadding="2" cellspacing="2" border="0" style="width:100%">
                    <tr class="header">
                        <td onclick="gizle_goster(gizli2);" style="cursor:pointer;" class="header_title_cont"><cf_get_lang no='217.İş ve Meslek Bilgilerim'></td>
                    </tr>
                    <tr style="display:none;" id="gizli2">	
                        <td class="contentforlabel">
                            <div style="float:left; width:50%;">
                                <table>
                                    <tr>
                                        <td class="me-title" width="200"><cf_get_lang_main no='162.Şirket'></td>
                                        <td>#get_consumer.company#</td>
                                    </tr>
                                    <tr>
                                        <td class="me-title"><cf_get_lang_main no='159.Ünvan'></td>
                                        <td>#get_consumer.title#</td>
                                    </tr>
                                    <tr>
                                        <td class="me-title"><cf_get_lang_main no='161.Görev'></td>
                                        <td>
                                            <cfloop query="get_partner_positions">
                                                <cfif get_consumer.mission eq partner_position_id>#partner_position#</cfif>
                                            </cfloop>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="me-title"><cf_get_lang_main no='160.Departman'></td>
                                        <td>
                                            <cfloop query="get_partner_departments">
                                               <cfif get_consumer.department eq partner_department_id>#partner_department#</cfif>
                                            </cfloop>
                                        </td>
                                    </tr>
                                </table>
                             </div>        	
                             <div style="float:left; width:50%;">
                                <table>
                                    <tr>
                                        <td class="me-title" width="150"><cf_get_lang_main no='167.Sektör'></td>
                                        <td>
                                            <cfloop query="get_sector_cats">
                                                <cfif sector_cat_id eq get_consumer.sector_cat_id>#sector_cat#</cfif>
                                            </cfloop>
                                        </td>
                                    </tr>
                                     <tr>
                                        <td class="me-title"><cf_get_lang no='212.Meslek'></td>
                                        <td>
                                            <cfloop query="get_vocation_type">
                                                <cfif get_consumer.vocation_type_id eq vocation_type_id>#vocation_type#</cfif>
                                            </cfloop>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="me-title"><cf_get_lang no='16.Şirket Büyüklük'></td>
                                        <td>
                                            <cfloop query="get_company_size_cats">
                                                <cfif company_size_cat_id eq get_consumer.company_size_cat_id>#company_size_cat#</cfif>
                                            </cfloop>
                                        </td>
                                    </tr>
                                </table>
                             </div>	
                        </td>
                    </tr>
                </table>
            </cfif>
            <!---<cfif (isdefined("attributes.is_adress_info") and attributes.is_adress_info eq 1) or not isdefined("attributes.is_adress_info")>--->
                <!--- Adres Bilgileri  --->
                <table cellpadding="2" cellspacing="2" border="0" style="width:100%">
                    <tr class="header">
                        <td onclick="gizle_goster(gizli3);" style="cursor:pointer;" class="header_title_cont"><cf_get_lang no='213.Ev Adresi'></td>
                    </tr>
                    <cfif len(get_consumer.home_district_id)>
                        <cfquery name="GET_HOME_DIST" datasource="#DSN#">
                            SELECT DISTRICT_NAME FROM SETUP_DISTRICT WHERE DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.home_district_id#">
                        </cfquery>
                        <cfset home_dis = '#get_home_dist.district_name# '>
                    <cfelse>
                        <cfset home_dis = ''>
                    </cfif>
                    <tr style="display:none;" id="gizli3">
                        <td class="contentforlabel" style="vertical-align:top;">
                            <div style="float:left; width:50%;">
                                <table>
                                    <tr>
                                        <cfif attributes.is_detail_adres eq 0>
                                            <td class="me-title" width="200"><cf_get_lang_main no='1311.Adres'></td>
                                            <td rowspan="3">#home_dis##get_consumer.homeaddress#</td>
                                        </cfif>
                                        <td class="me-title" width="200"><cf_get_lang_main no='807.Ülke'></td>
                                        <td>
                                            <cfloop query="get_country">
                                                <cfif get_consumer.home_country_id eq country_id>#country_name#</cfif>
                                            </cfloop>
                                        </td>
                                     </tr>
                                     <tr>
                                        <cfif attributes.is_detail_adres eq 0>
                                            <td>&nbsp;</td>
                                        </cfif>
                                        <td class="me-title"><cf_get_lang_main no='559.Şehir'><cfif attributes.is_cons_adress eq 1>*</cfif></td>
                                        <td>
                                            <cfif len(get_consumer.home_city_id) and len(get_consumer.home_country_id)>
                                                <cfquery name="GET_CITY_HOME" datasource="#DSN#">
                                                    SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.home_country_id#">
                                                </cfquery>
                                                <cfloop query="get_city_home">
                                                    <cfif get_consumer.home_city_id eq city_id>#city_name#</cfif>
                                                </cfloop>
                                            </cfif>
                                        </td>
                                     </tr>
                                     <tr>
                                        <cfif attributes.is_detail_adres eq 0>
                                            <td>&nbsp;</td>
                                        </cfif>
                                        <td class="me-title">İlçe<cfif attributes.is_cons_adress eq 1>*</cfif></td>
                                        <td>
                                            <cfif len(get_consumer.home_county_id) and len(get_consumer.home_city_id)>
                                                <cfquery name="GET_COUNTY_HOME" datasource="#DSN#">
                                                    SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.home_city_id#">
                                                </cfquery>										
                                                <cfloop query="get_county_home">
                                                    <cfif get_consumer.home_county_id eq county_id>#county_name#</cfif>
                                                </cfloop>
                                            </cfif>
                                        </td>
                                     </tr>
                                     <tr>
                                        <td class="me-title"><cf_get_lang_main no='720.Semt'></td>
                                        <td>#get_consumer.homesemt#</td>				
                                        <cfif attributes.is_detail_adres eq 0>
                                            <td class="me-title"><cf_get_lang_main no='60.Posta Kodu'></td>
                                            <td>#get_consumer.homepostcode#</td>
                                        </cfif>
                                     </tr>
                                     <cfif attributes.is_detail_adres eq 1>
                                        <tr>
                                            <td class="me-title"><cf_get_lang_main no='60.Posta Kodu'></td>
                                            <td>#get_consumer.homepostcode#</td>
                                        </tr>
                                     </cfif>
                                 </table>
                            </div>        
                            <div style="float:left; width:50%;">
                                <table>
                                    <tr>
                                        <cfif attributes.is_detail_adres eq 1>
                                            <td class="me-title" width="150">Mahalle <cfif attributes.is_cons_district eq 1>*</cfif></td>
                                            <td><cfif attributes.is_residence_select eq 0>
                                                    <cfif len(get_consumer.home_district)>#get_consumer.home_district#<cfelse>#home_dis#</cfif>
                                                <cfelse>
                                                    <cfif len(get_consumer.home_district_id)>
                                                        <cfquery name="GET_DISTRICT_NAME" datasource="#DSN#">
                                                            SELECT DISTRICT_ID, DISTRICT_NAME FROM SETUP_DISTRICT WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.home_county_id#">
                                                        </cfquery>										
                                                        <cfloop query="get_district_name">
                                                            <cfif get_consumer.home_district_id eq district_id>#district_name#</cfif>
                                                        </cfloop>
                                                    </cfif>
                                                </cfif>
                                            </td>
                                        </cfif>
                                    </tr>
                                    <cfif attributes.is_detail_adres eq 1>
                                        <tr>
                                            <td class="me-title">Cadde</td>
                                            <td>#get_consumer.home_main_street#</td>
                                        </tr>
                                    </cfif>
                                    <cfif attributes.is_detail_adres eq 1>
                                        <tr>
                                            <td class="me-title">Sokak</td>
                                            <td>#get_consumer.home_street#</td>
                                        </tr>
                                    </cfif>
                                    <cfif attributes.is_detail_adres eq 1>
                                        <tr>
                                            <td class="me-title">No</td>
                                            <td>#get_consumer.home_door_no#</td>
                                        </tr>
                                    </cfif>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
                <!--- İş Adresi  --->
                <table cellpadding="2" cellspacing="2" border="0" style="width:100%">
                    <tr class="header">
                        <td onclick="gizle_goster(gizli4);" style="cursor:pointer;" class="header_title_cont"><cf_get_lang no='216.İş Adresim'></td>
                    </tr>
                    <cfif len(get_consumer.work_district_id)>
                        <cfquery name="GET_WORK_DIST" datasource="#DSN#">
                            SELECT DISTRICT_NAME FROM SETUP_DISTRICT WHERE DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_district_id#">
                        </cfquery>
                        <cfset work_dis = '#get_work_dist.district_name# '>
                    <cfelse>
                        <cfset work_dis = ''>
                    </cfif>
                    <tr style="display:none;" id="gizli4">
                        <td style="vertical-align:top;">
                            <div style="float:left; width:50%;">
                                <table>
                                    <tr>
                                        <cfif attributes.is_detail_adres eq 0>
                                            <td class="me-title" width="200"><cf_get_lang_main no='1311.Adres'></td>
                                            <td rowspan="3">#work_dis##get_consumer.workaddress#</td>
                                        </cfif>
                                        <td class="me-title" width="200"><cf_get_lang_main no='807.Ülke'></td>
                                        <td>
                                            <cfloop query="get_country">
                                               <cfif get_consumer.work_country_id eq country_id>#country_name#</cfif>
                                            </cfloop>			
                                        </td>
                                    </tr>
                                    <tr>
                                        <cfif attributes.is_detail_adres eq 0>
                                            <td>&nbsp;</td>
                                        </cfif>
                                        <td class="me-title"><cf_get_lang_main no='559.Şehir'> <cfif attributes.is_cons_adress eq 1>*</cfif></td>
                                        <td>
                                            <cfif len(get_consumer.work_city_id)>
                                                <cfquery name="GET_CITY_WORK" datasource="#DSN#">
                                                    SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_country_id#">
                                                </cfquery>
                                                <cfloop query="get_city_work">
                                                    <cfif get_consumer.work_city_id eq city_id>#city_name#</cfif>
                                                </cfloop>
                                            </cfif>
                                        </td>
                                     </tr>
                                     <tr>
                                        <cfif attributes.is_detail_adres eq 0>
                                            <td>&nbsp;</td>
                                        </cfif>
                                        <td class="me-title">İlçe <cfif attributes.is_cons_adress eq 1>*</cfif></td>
                                        <td>
                                            <cfif len(get_consumer.work_county_id)>
                                                <cfquery name="GET_COUNTY_WORK" datasource="#DSN#">
                                                    SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_city_id#">
                                                </cfquery>										
                                                <cfloop query="get_county_work">
                                                   <cfif get_consumer.work_county_id eq county_id>#county_name#</cfif>
                                                </cfloop>
                                            </cfif>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="me-title"><cf_get_lang_main no='720.Semt'></td>
                                        <td>#get_consumer.worksemt#</td>				
                                        <cfif attributes.is_detail_adres eq 0>
                                            <td class="me-title"><cf_get_lang_main no='60.Posta Kodu'></td>
                                            <td>#get_consumer.workpostcode#</td>
                                        </cfif>
                                    </tr>
                                </table>
                            </div>
                            <div style="float:left; width:50%;">        
                                <table>
                                    <tr>
                                        <cfif attributes.is_detail_adres eq 1>
                                            <td class="me-title" width="150">Mahalle</td>
                                            <td>
                                                <cfif attributes.is_residence_select eq 0>
                                                    <cfif len(get_consumer.work_district)>#get_consumer.work_district#<cfelse>#work_dis#</cfif>
                                                <cfelse>
                                                    <cfif len(get_consumer.work_district_id)>
                                                        <cfquery name="GET_DISTRICT_NAME" datasource="#DSN#">
                                                            SELECT DISTRICT_ID, DISTRICT_NAME FROM SETUP_DISTRICT WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_county_id#">
                                                        </cfquery>										
                                                        <cfloop query="get_district_name">
                                                            <cfif get_consumer.work_district_id eq district_id>#district_name#</cfif>
                                                        </cfloop>
                                                    </cfif>
                                                </cfif>
                                            </td>
                                        </cfif>
                                    </tr>
                                    <cfif attributes.is_detail_adres eq 1>
                                        <tr>
                                            <td class="me-title">Cadde</td>
                                            <td>#get_consumer.work_main_street#</td>
                                        </tr>
                                    </cfif>
                                    <tr>
                                        <cfif attributes.is_detail_adres eq 1>
                                            <td class="me-title">Sokak</td>
                                            <td>#get_consumer.work_street#</td>
                                        </cfif>
                                    </tr>
                                    <tr>
                                        <cfif attributes.is_detail_adres eq 1>
                                            <td class="me-title">No</td>
                                            <td>#get_consumer.work_door_no#</td>
                                        </cfif>
                                    </tr>
                                    <cfif attributes.is_detail_adres eq 1>
                                        <tr>
                                            <td class="me-title"><cf_get_lang_main no='60.Posta Kodu'></td>
                                            <td>#get_consumer.workpostcode#</td>
                                        </tr>
                                    </cfif>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            <!---<cfelse>
                <cfinclude template="upd_cons_address.cfm">
            </cfif>--->
            <!--- İş Adresi  --->
            <cfif (isdefined("attributes.is_tax_adress") and attributes.is_tax_adress eq 1) or not isdefined("attributes.is_tax_adress")>
                <table cellpadding="2" cellspacing="2" border="0" style="width:100%">
                    <tr class="header">
                        <td onclick="gizle_goster(gizli5);" style="cursor:pointer;" class="header_title_cont"><cf_get_lang no='220.Fatura Adresim'></td>
                    </tr>
                    <cfif len(get_consumer.tax_district_id)>
                        <cfquery name="GET_TAX_DIST" datasource="#DSN#">
                            SELECT DISTRICT_NAME FROM SETUP_DISTRICT WHERE DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.tax_district_id#">
                        </cfquery>
                        <cfset tax_dis = '#get_tax_dist.district_name# '>
                    <cfelse>
                        <cfset tax_dis = ''>
                    </cfif>
                    <tr style="display:none;" id="gizli5">
                        <td class="contentforlabel" style="vertical-align:top;">
                            <div style="float:left; width:50%;">
                                <table>
                                    <tr>
                                        <td class="me-title" width="200">Vergi Dairesi</td>
                                        <td>#get_consumer.tax_office#</td>
                                    </tr>
                                    <tr>
                                        <cfif attributes.is_detail_adres eq 0>
                                            <td class="me-title" width="200"><cf_get_lang_main no='1311.Adres'></td>
                                            <td rowspan="3">#tax_dis##get_consumer.tax_adress#</td>
                                        </cfif>
                                        <td class="me-title"><cf_get_lang_main no='807.Ülke'></td>
                                        <td>
                                            <cfloop query="get_country">
                                               <cfif get_consumer.tax_country_id eq country_id>#country_name#</cfif>
                                            </cfloop>
                                        </td>
                                     </tr>
                                     <tr>
                                        <cfif attributes.is_detail_adres eq 0>
                                            <td>&nbsp;</td>
                                        </cfif>
                                        <td class="me-title"><cf_get_lang_main no='559.Şehir'></td>
                                        <td>
                                            <cfif len(get_consumer.tax_country_id)>
                                                <cfquery name="GET_CITY_TAX" datasource="#DSN#">
                                                    SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.tax_country_id#">
                                                </cfquery>
                                                <cfloop query="get_city_tax">
                                                    <cfif get_consumer.tax_city_id eq city_id>#city_name#</cfif>
                                                </cfloop>
                                            </cfif>
                                        </td>
                                     </tr>
                                     <tr>
                                        <cfif attributes.is_detail_adres eq 0>
                                            <td>&nbsp;</td>
                                        </cfif>
                                        <td class="me-title">İlçe</td>
                                        <td>
                                            <cfif len(get_consumer.tax_county_id)>
                                                <cfquery name="GET_COUNTY_TAX" datasource="#DSN#">
                                                    SELECT * FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.tax_city_id#">
                                                </cfquery>										
                                                <cfloop query="get_county_tax">
                                                    <cfif get_consumer.tax_county_id eq county_id>#county_name#</cfif>
                                                </cfloop>
                                            </cfif>
                                        </td>
                                     </tr>
                                     <tr>
                                        <td class="me-title"><cf_get_lang_main no='720.Semt'></td>
                                        <td>#get_consumer.tax_semt#</td>				
                                        <cfif attributes.is_detail_adres eq 0>
                                            <td class="me-title"><cf_get_lang_main no='60.Posta Kodu'></td>
                                            <td>#get_consumer.tax_postcode#</td>
                                        </cfif>
                                      </tr>
                                  </table>
                            </div>
                            <div style="float:left; width:50%;">
                                <table>
                                    <tr>
                                        <td class="me-title" width="150">Vergi No</td>
                                        <td>#get_consumer.tax_no#	</td>
                                    </tr>
                                    <cfif attributes.is_detail_adres eq 1>
                                        <tr>
                                            <td class="me-title" width="150">Mahalle</td>
                                            <td><cfif attributes.is_residence_select eq 0>
                                                    <cfif len(get_consumer.tax_district)>#get_consumer.tax_district#<cfelse>#tax_dis#</cfif>
                                                <cfelse>
                                                    <cfif len(get_consumer.tax_district_id)>
                                                        <cfquery name="GET_DISTRICT_NAME" datasource="#DSN#">
                                                            SELECT DISTRICT_ID, DISTRICT_NAME FROM SETUP_DISTRICT WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.tax_county_id#">
                                                        </cfquery>										
                                                        <cfloop query="get_district_name">
                                                            <cfif get_consumer.tax_district_id eq district_id>#district_name#</cfif>
                                                        </cfloop>
                                                    </cfif>
                                                </cfif>
                                            </td>
                                        </tr>
                                    </cfif>
                                    <cfif attributes.is_detail_adres eq 1>
                                        <tr>
                                            <td class="me-title">Cadde</td>
                                            <td>#get_consumer.tax_main_street#</td>
                                        </tr>
                                    </cfif>
                                    <cfif attributes.is_detail_adres eq 1>
                                        <tr>
                                            <th class="me-title">Sokak</th>
                                            <td>#get_consumer.tax_street#</td>
                                        </tr>
                                    </cfif>
                                    <cfif attributes.is_detail_adres eq 1>
                                        <tr>
                                            <td class="me-title">No</td>
                                            <td>#get_consumer.tax_door_no#</td>
                                        </tr>
                                    </cfif>
                                    <cfif attributes.is_detail_adres eq 1>
                                        <tr>
                                            <td class="me-title"><cf_get_lang_main no='60.Posta Kodu'></td>
                                            <td>#get_consumer.tax_postcode#</td>
                                        </tr>
                                    </cfif>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </cfif>
            <!--- Hobi --->
            <cfif isdefined("attributes.is_consumer_hoby") and attributes.is_consumer_hoby eq 1>
                <table cellpadding="2" cellspacing="2" border="0" style="width:100%">
                    <tr class="header">
                        <td onclick="gizle_goster(gizli6);" style="cursor:pointer;" class="header_title_cont"><cf_get_lang no='222.Hobilerim'> / <cf_get_lang no='856.İlgi Alanlarım'></td>
                    </tr>
                    <tr style="display:none;" id="gizli6">
                        <td class="contentforlabel" style="vertical-align:top;">
                            <div style="float:left; width:50%;">
                                <cfif isdefined("attributes.member_coloum_number") and len(attributes.member_coloum_number)>
                                    <cfparam name="attributes.member_coloum_number" default="#attributes.member_coloum_number#">
                                <cfelse>
                                    <cfparam name="attributes.member_coloum_number" default="1">
                                </cfif>
                                <cfquery name="GET_HOBBY" datasource="#DSN#">
                                    SELECT HOBBY_ID, HOBBY_NAME FROM SETUP_HOBBY ORDER BY HOBBY_NAME
                                </cfquery>
                                <cfquery name="GET_CONSUMER_HOBBIES" datasource="#DSN#"> 
                                    SELECT 
                                        HOBBY_ID 
                                    FROM 
                                        CONSUMER_HOBBY
                                    WHERE 
                                        <cfif isdefined("attributes.cid")>
                                            CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">
                                        <cfelse>
                                            CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
                                        </cfif>
                                </cfquery>
                                <cfset liste = valuelist(get_consumer_hobbies.hobby_id)>
                                <table>
                                    <cfset this_row_ = 0>
                                    <cfloop query="get_hobby">
                                        <cfset this_row_ = this_row_ + 1>
                                        <cfif this_row_ mod attributes.member_coloum_number eq 1><tr></cfif>
                                            <td>
                                                <cfif liste contains hobby_id> #get_hobby.hobby_name#</cfif>
                                            </td>
                                        <cfif this_row_ mod attributes.member_coloum_number eq 0></tr></cfif>
                                    </cfloop>
                                </table>
                             </div>
                        </td>
                      </tr>
                </table>
            </cfif>
            <!--- yetkinlik --->
            <cfif isdefined("attributes.is_consumer_req_type") and attributes.is_consumer_req_type eq 1>
                <table cellpadding="2" cellspacing="2" border="0" style="width:100%">
                    <tr class="header">
                        <td onclick="gizle_goster(gizli7);" style="cursor:pointer;" class="header_title_cont"><cf_get_lang_main no='1297.Yetkinliklerim'></td>
                    </tr>
                    <tr style="display:none;" id="gizli7">
                        <td class="contentforlabel" style="vertical-align:top;"> 
                            <div style="float:left; width:50%;">
                                <cfif isdefined("attributes.member_coloum_number") and len(attributes.member_coloum_number)>
                                    <cfparam name="attributes.member_coloum_number" default="#attributes.member_coloum_number#">
                                <cfelse>
                                    <cfparam name="attributes.member_coloum_number" default="1">
                                </cfif>
                                <cfquery name="GET_REQ" datasource="#DSN#">
                                    SELECT REQ_ID, REQ_NAME FROM SETUP_REQ_TYPE
                                </cfquery>
                                <cfquery name="GET_CONSUMER_REQ" datasource="#DSN#"> 
                                    SELECT 
                                        REQ_ID 	
                                    FROM 
                                        MEMBER_REQ_TYPE 
                                    WHERE 
                                        <cfif isdefined("attributes.cid")>
                                            CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">
                                        <cfelse>
                                            CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
                                        </cfif>
                                </cfquery>
                                <cfset liste = valuelist(get_consumer_req.req_id)>
                                <table border="0" cellpadding="2" cellspacing="1">
                                    <cfset this_row_2 = 0>
                                    <cfloop query="get_req">
                                        <cfset this_row_2 = this_row_2 + 1>
                                        <cfif this_row_2 mod attributes.member_coloum_number eq 1><tr></cfif>
                                            <td><label for="req_id_#get_req.req_id#">
                                                <input type="checkbox" name="req" value="#get_req.req_id#" id="req_id_#get_req.req_id#"<cfif liste contains req_id>checked</cfif>>#get_req.req_name#
                                                </label>&nbsp;&nbsp;
                                            </td>
                                        <cfif this_row_2 mod attributes.member_coloum_number eq 0></tr></cfif>
                                    </cfloop>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </cfif>
            <!--- egitim --->
            <cfif isdefined("attributes.is_consumer_education") and attributes.is_consumer_education eq 1>
                <table cellpadding="2" cellspacing="2" border="0" style="width:100%">
                    <tr class="header">
                        <td onclick="gizle_goster(gizli8);" style="cursor:pointer;" class="header_title_cont"><cf_get_lang no='225.Egitim Bilgilerim'></td>
                    </tr>
                    <tr style="display:none;" id="gizli8">
                        <td class="contentforlabel" style="vertical-align:top;">
                           <cfinclude template="form_cons_education_info.cfm">
                        </td>
                    </tr>
                </table>
            </cfif>
            <!--- diğer adresler --->
            <table cellpadding="2" cellspacing="2" border="0" style="width:100%">
                <cfif isdefined("attributes.is_other_address") and attributes.is_other_address eq 1>
                    <tr class="header">
                        <td onclick="gizle_goster(gizli9);" style="cursor:pointer;" class="header_title_cont">Diğer Adresler</td>
                    </tr>
                    <tr style="display:none;" id="gizli9">
                        <td class="contentforlabel" style="vertical-align:top;">
                            <cfinclude template="dsp_consumer_address.cfm">
                        </td>
                    </tr>
                </cfif>
            </table>
     	</cfoutput>
    </cfif>
<cfelse>
	<script type="text/javascript">
		alert("Böyle Bir Kayıt Bulunamadı. Bilgileri Kontrol Ediniz !");
		history.back();
	</script>
	<cfabort>
</cfif>
