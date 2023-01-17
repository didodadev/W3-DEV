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
<cfset kontrol_zone = 0>
<cfif isdefined("attributes.is_ref_member_zone") and attributes.is_ref_member_zone eq 1 and isdefined("session.ww.userid")>
	<cfquery name="GET_CONTROL_CITY" datasource="#DSN#">
		SELECT ISNULL(HOME_CITY_ID,WORK_CITY_ID) AS CITY_ID FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
	</cfquery>
	<cfif get_control_city.recordcount and len(get_control_city.city_id)>
		<cfset kontrol_zone = ''>
		<cfquery name="get_city_code" datasource="#DSN#">
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
	<cfinclude template="../query/get_edu_level.cfm">
	<cfform name="upd_consumer" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=objects2.emptypopup_upd_consumer">
		<input type="hidden" name="is_other_address" id="is_other_address" value="<cfoutput>#attributes.is_other_address#</cfoutput>">
		<cfif isdefined('attributes.orderww_back') and len(attributes.orderww_back)>
			<input type="hidden" name="orderww_back" id="orderww_back" value="<cfoutput>#attributes.orderww_back#</cfoutput>">
		</cfif>
		<!---Kisisel--->
		<table cellpadding="2" cellspacing="2" style="width:100%;">
			<tr class="header" style="height:20px;">
				<td onclick="gizle_goster(gizli992);" colspan="2" class="header_title"><cf_get_lang_main no='719.Temel Bilgiler'></td>
			</tr>
			<tr id="gizli992">
				<td>
					<table>
						<tr>
							<td style="vertical-align:top;">
								<table>
                                    <tr style="height:20px;">
                                        <cfif isdefined("attributes.is_ref_info") and attributes.is_ref_info eq 1>
                                            <th class="me-title" style="width:120px;"><cf_get_lang_main no='1224.Referans Üye'></th> 
                                            <td class="inner-menu-link"><cfif len(get_consumer.ref_pos_code)><cfoutput>#get_cons_info(get_consumer.ref_pos_code,0,0)#</cfoutput></cfif><td>
                                        </cfif>
                                    </tr>
                                    <cfif isdefined("attributes.is_member_code") and attributes.is_member_code eq 1>
                                        <tr style="height:20px;">
                                            <th class="me-title"><cf_get_lang no='1508.Üye Kodu'></th>
                                            <td><cfoutput>#get_consumer.member_code#</cfoutput></td>
                                            <th style="width:40px;">&nbsp;</th>
                                        </tr>
                                    </cfif>
                                    <cfoutput>
                                    <tr style="height:20px;">
                                        <th class="me-title"><cf_get_lang_main no='219.Ad'></th>
                                        <td style="width:100px;">#get_consumer.consumer_name#</td>
                                        <th>&nbsp;</th>
                                    </tr>
                                    <tr style="height:20px;">
                                        <th class="me-title"><cf_get_lang_main no='1314.Soyad'></th>
                                        <td>#get_consumer.consumer_surname#</td>
                                        <th>&nbsp;</th>
                                    </tr>
                                    </cfoutput>
									<cfif (isdefined("attributes.is_change_cat") and attributes.is_change_cat eq 1) or not isdefined("attributes.is_change_cat")>
                                        <tr style="height:20px;">
                                            <th class="me-title"><cf_get_lang_main no='1197.Üye Kategorisi'></th>
                                            <td>
                                            <cfoutput query="get_consumer_cat">
                                                <cfif conscat_id eq get_consumer.consumer_cat_id>#conscat#</cfif>
                                            </cfoutput>
                                            </td>
                                            <th>&nbsp;</th>
                                        </tr>
                                    <cfelseif isdefined("attributes.is_change_cat") and attributes.is_change_cat eq 0>
                                        <tr style="height:20px;">
                                            <th class="me-title"><cf_get_lang_main no='1197.Üye Kategorisi'></th>
                                            <td>
                                                <cfquery name="GET_CONS_ROW" datasource="#DSN#">
                                                    SELECT 
                                                        * 
                                                    FROM 
                                                        CONSUMER_CAT,
                                                        CATEGORY_SITE_DOMAIN  
                                                    WHERE 
                                                        CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.consumer_cat_id#"> AND
                                                        CONSUMER_CAT.CONSCAT_ID = CATEGORY_SITE_DOMAIN.CATEGORY_ID AND
                                                        CATEGORY_SITE_DOMAIN.SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#"> AND 
                                                        CATEGORY_SITE_DOMAIN.MEMBER_TYPE = 'CONSUMER' 
                                                </cfquery>
                                                <cfoutput>#get_cons_row.conscat#</cfoutput>
                                            </td>
                                            <th>&nbsp;</th>
                                        </tr>
                                    </cfif>
									<cfif (isdefined("attributes.is_user_name") and attributes.is_user_name eq 1) or not isdefined("attributes.is_user_name")>
                                        <tr style="height:20px;">
                                            <th class="me-title"><cf_get_lang_main no='139.Kullanıcı Adı'></th>
                                            <td><cfoutput>#get_consumer.consumer_username#</cfoutput></td>
                                            <th>&nbsp;</th>
                                        </tr>
                                    </cfif>
                                    <cfif (isdefined("attributes.is_timeout") and attributes.is_timeout eq 1) or not isdefined("attributes.is_timeout")>
                                        <tr style="height:20px;">
                                            <th class="me-title"><cf_get_lang no='228.Timeout Süresi'></th>
                                            <td>
                                                <cfif get_consumer.timeout_limit is '15'>15 dk.</cfif>
                                                <cfif get_consumer.timeout_limit is '30'>30 dk.</cfif>
                                                <cfif get_consumer.timeout_limit is '45'>45 dk.</cfif>
                                                <cfif get_consumer.timeout_limit is '60'>60 dk.</cfif>
                                            </td>
                                            <th>&nbsp;</th>
                                        </tr>
                                    </cfif>
                                </table>
                            </td>
                            <td style="vertical-align:top;">				
                                <table>
                                    <tr style="height:20px;">
                                        <cfif isdefined("attributes.is_work_pos") and attributes.is_work_pos eq 1>
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
                                            <th class="me-title" style="width:120px;"><cf_get_lang_main no='496.Temsilci'></th> 
                                            <td class="me-title"><cfif get_pos_info.recordcount and len(get_pos_info.position_code)><cfoutput>#get_emp_info(get_pos_info.position_code,1,0)#</cfoutput></cfif><td>
                                        </cfif>
                                    </tr>
                                    <tr style="height:20px;">
                                        <th class="me-title"><cf_get_lang_main no='16.Email'></th>
                                        <td>
                                            <cfoutput>#get_consumer.consumer_email#</cfoutput>
                                        </td>
                                        <td align="center" rowspan="5" style="vertical-align:top;">&nbsp;&nbsp;</td>
                                    </tr>
                                    <tr style="height:20px;">
                                        <th class="me-title"><cf_get_lang_main no='1070.Mobil Tel'></th>
                                        <td>
                                            <cfoutput query="get_mobilcat">
                                                <cfif mobilcat eq get_consumer.mobil_code>#mobilcat#</cfif>
                                            </cfoutput>
                                            <cfoutput>- #get_consumer.mobiltel#</cfoutput>
                                        </td>
                                    </tr>
                                    <tr style="height:20px;">
                                        <th class="me-title"><cf_get_lang_main no='1070.Mobil Tel'> 2</th>
                                        <td>
                                            <cfoutput query="get_mobilcat">
                                                <cfif mobilcat eq get_consumer.mobil_code_2>#mobilcat#</cfif>
                                            </cfoutput>
                                            <cfoutput>- #get_consumer.mobiltel_2#</cfoutput>
                                        </td>
                                    </tr>
                                    <tr style="height:20px;">
                                        <th class="me-title"><cf_get_lang no='226.Ev Tel'></th>
                                        <td><cfoutput>#get_consumer.consumer_hometelcode# -#get_consumer.consumer_hometel#</cfoutput></td>
                                    </tr>
                                    <tr style="height:20px;">
                                        <th class="me-title"><cf_get_lang no='227.İş Tel'></th>
                                        <td><cfoutput>#get_consumer.consumer_worktelcode# -#get_consumer.consumer_worktel#</cfoutput></td>
                                    </tr>
                                    <cfif (isdefined("attributes.is_internet_page") and attributes.is_internet_page eq 1) or not isdefined("attributes.is_internet_page")>
                                        <tr style="height:20px;">
                                            <th class="me-title"><cf_get_lang no='196.İnternet Sitesi'></th>
                                            <td><cfoutput>#get_consumer.homepage#</cfoutput></td>
                                        </tr>
                                    </cfif>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <!--- Kisisel Bilgiler --->
            <tr class="header" style="height:20px;">
                <td onClick="gizle_goster(gizli1);" class="header_title"><cf_get_lang no='197.Kişisel Bilgilerim'></td>
            </tr>
            <tr id="gizli1">
                <td>
                    <table>
                        <tr>
                            <td style="vertical-align:top;">
                                <table>
                                    <tr>
                                        <th class="me-title" style="width:120px;"><cf_get_lang_main no='378.Doğum Yeri'></th>
                                        <td style="width:100px;"><cfoutput>#get_consumer.birthplace#</cfoutput></td>
                                        <th>&nbsp;</th>
                                    </tr>
                                    <tr style="height:20px;">
                                        <th class="me-title"><cf_get_lang no='205.Eğitim Durumu'></th>
                                        <td>
                                            <cfoutput query="get_edu_level">
                                                <cfif get_consumer.education_id eq edu_level_id>#education_name#</cfif>
                                            </cfoutput>
                                        </td>
                                        <th>&nbsp;</th>
                                    </tr>
                                    <tr style="height:20px;">
                                        <th class="me-title"><cf_get_lang_main no='352.Cinsiyet'></th>
                                        <td>
                                            <cfif get_consumer.sex eq 1><cf_get_lang_main no='1547.Erkek'></cfif>
                                            <cfif get_consumer.sex eq 0><cf_get_lang_main no='1546.Kadin'></cfif>
                                        </td>
                                        <th>&nbsp;</th>
                                    </tr>
                                    <tr style="height:20px;"> 	
                                        <th class="me-title"><cf_get_lang no='206.Çocuk Sayısı'></th>
                                        <td>
                                            <cfoutput>#get_consumer.child#</cfoutput>
                                        </td>
                                        <th>&nbsp;</th>
                                    </tr>
                                    <tr style="height:20px;">
                                        <th class="me-title"><cf_get_lang no='201.Evlilik Durumu'></th>
                                        <td><cfif get_consumer.married eq 1><cf_get_lang no='209.Evli'></cfif></td>
                                        <th>&nbsp;</th>
                                    </tr>
                                    <tr style="height:20px;">
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <th>&nbsp;</th>
                                    </tr>
                                </table>
                            </td>
                            <td style="vertical-align:top;">
                                <table>
                                    <tr style="height:20px;">
                                        <th class="me-title" style="width:130px;"><cf_get_lang_main no='1315.Doğum Tarihi'></th>
                                        <td nowrap="nowrap">
                                                <cfoutput>#dateformat(get_consumer.birthdate,'dd/mm/yyyy')#</cfoutput>
                                        </td>
                                        <cfif (isdefined("attributes.is_photo") and attributes.is_photo eq 1) or not isdefined("attributes.is_photo")>
                                            <td rowspan="5" style="vertical-align:top;">
                                                <cfif len(get_consumer.picture)>
                                                <cfoutput>
                                                    <cf_get_server_file output_file="member/consumer/#get_consumer.picture#" output_server="#get_consumer.picture_server_id#" output_type="0" image_width="100" alt="#getLang('main',668)#" title="#getLang('main',668)#">
                                                </cfoutput>
                                                <cfelse>
                                                    <cf_get_lang_main no='716.Fotoğraf Girilmemiş'>
                                              </cfif>
                                            </td>
                                        </cfif>
                                    </tr>
                                    <!--- <cfif (isdefined("attributes.is_language") and attributes.is_language eq 1) or not isdefined("attributes.is_language")>
                                        <tr height="20">
                                            <td class="me-title"><cf_get_lang_main no='1584.Dil'></td>
                                            <td><select name="language_id"  style="width:140px;">
                                                    <cfoutput query="get_language">
                                                        <option value="#language_id#">#language_set#
                                                    </cfoutput>
                                                </select>
                                            </td>
                                        </tr>
                                    </cfif> --->
                                    <tr style="height:20px;">
                                        <th class="me-title"><cf_get_lang_main no='613.TC Kimlik No'><cfif isdefined("attributes.is_tc_number") and attributes.is_tc_number> *</cfif></th>
                                        <td>
                                            <cfoutput>#get_consumer.tc_identy_no#</cfoutput>
                                        </td>
                                    </tr>
                                    <cfif isdefined("attributes.is_bank_account") and attributes.is_bank_account eq 1>
                                        <cfquery name="GET_BANK_ACCOUNT" datasource="#DSN#">
                                            SELECT 
                                                * 
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
                                        <tr style="height:20px;">
                                            <th class="me-title">Banka Hesabı</th>
                                            <td><cfoutput>#get_bank_account.consumer_bank#-#get_bank_account.consumer_bank_branch#-#get_bank_account.consumer_account_no#</cfoutput></td>
                                        </tr>
                                    </cfif>
                                    <cfif (isdefined("attributes.is_nationality") and attributes.is_nationality eq 1) or not isdefined("attributes.is_nationality")>
                                        <tr style="height:20px;">
                                            <th class="me-title"><cf_get_lang no='202.Uyruğu'></th>
                                            <td>
                                                <cfoutput query="get_country">
                                                    <cfif get_country.country_id eq get_consumer.nationality>#country_name#</cfif>
                                                </cfoutput>
                                            </td>
                                        </tr>
                                    </cfif>
                                </table>	
                            </td>
						</tr>
					</table>
				</td>
			</tr>
			<cfif (isdefined("attributes.is_work_info") and attributes.is_work_info eq 1) or not isdefined("attributes.is_work_info")>
				<!--- İş Meslek Bilgileri --->
				<tr class="header" style="height:20px;">
					<td onClick="gizle_goster(gizli2);" class="header_title"><cf_get_lang no='217.İş ve Meslek Bilgilerim'></td>
				</tr>
				<tr STYLE="display:none;" id="gizli2">	
					<td class="contentforlabel">
						<table>
							<tr>
								<td style="vertical-align:top;">
									<table>
										<tr style="height:20px;">
											<th class="me-title" style="width:120px;"><cf_get_lang_main no='162.Şirket'></th>
											<td style="width:100px;"><cfoutput>#get_consumer.company#</cfoutput></td>
											<th>&nbsp;</th>
										</tr>
										<tr style="height:20px;">
											<th class="me-title"><cf_get_lang_main no='159.Ünvan'></th>
											<td><cfoutput>#get_consumer.title#</cfoutput></td>
											<th>&nbsp;</th>
										</tr>
										<tr style="height:20px;">
											<th class="me-title"><cf_get_lang_main no='161.Görev'></th>
											<td>
												<cfoutput query="get_partner_positions">
													<cfif get_consumer.mission eq partner_position_id>#partner_position#</cfif>
												</cfoutput>
											</td>
											<th>&nbsp;</th>
										</tr>
										<tr style="height:20px;">
											<th class="me-title"><cf_get_lang_main no='160.Departman'></th>
											<td>
												<cfoutput query="get_partner_departments">
													<cfif get_consumer.department eq partner_department_id>#partner_department#</cfif>
												</cfoutput>
											</td>
											<th>&nbsp;</th>
										</tr>
									</table>
								</td>
								<td style="vertical-align:top;">
									<table>
										<tr style="height:20px;">
											<th class="me-title" style="width:130px;"><cf_get_lang no='212.Meslek'></th>
											<td>
												<cfoutput query="get_vocation_type">
													<cfif get_consumer.vocation_type_id eq vocation_type_id>#vocation_type#</cfif>
												</cfoutput>
											</td>
										</tr>
										<tr style="height:20px;">
											<th class="me-title"><cf_get_lang no='16.Şirket Büyüklük'></th>
											<td>
												<cfoutput query="get_company_size_cats">
													<cfif company_size_cat_id eq get_consumer.company_size_cat_id>#company_size_cat#</cfif>
												</cfoutput>
											</td>
										</tr>
										<tr style="height:20px;">
											<th class="me-title"><cf_get_lang_main no='167.Sektör'></th>
											<td>
												<cfoutput query="get_sector_cats">
													<cfif sector_cat_id eq get_consumer.sector_cat_id>#sector_cat#</cfif>
												</cfoutput>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>	
					</td>
				</tr>
			</cfif>
			<cfif (isdefined("attributes.is_adress_info") and attributes.is_adress_info eq 1) or not isdefined("attributes.is_adress_info")>
				<!--- Adres Bilgileri  --->
				<tr class="header" style="height:20px;">
					<td onClick="gizle_goster(gizli3);" class="header_title"><cf_get_lang no='213.Ev Adresi'></td>
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
                        <table>
                            <tr style="height:20px;">
                                <cfif attributes.is_detail_adres eq 0>
                                    <th class="me-title"><cf_get_lang_main no='1311.Adres'></th>
                                    <td rowspan="3"><textarea name="home_address" id="home_address" style="width:140px;height:75px;"><cfoutput>#home_dis##get_consumer.homeaddress#</cfoutput></textarea></td>
                                    <th>&nbsp;</th>
                                </cfif>
                                <th class="me-title" style="width:120px;"><cf_get_lang_main no='807.Ülke'></th>
                                <td style="width:110px;">
                                    <cfoutput query="get_country">
                                        <cfif get_consumer.home_country_id eq country_id>#country_name#</cfif>
                                    </cfoutput>
                                </td>
                                <cfif attributes.is_detail_adres eq 1>
                                    <th>&nbsp;</th>
                                    <th class="me-title" style="width:130px;">Mahalle</th>
                                    <td ><cfif attributes.is_residence_select eq 0>
                                            <cfif len(get_consumer.home_district)><cfoutput>#get_consumer.home_district#</cfoutput><cfelse><cfoutput>#home_dis#</cfoutput></cfif>
                                        <cfelse>
                                            <cfif len(get_consumer.home_district_id)>
                                                <cfquery name="GET_DISTRICT_NAME" datasource="#DSN#">
                                                    SELECT DISTRICT_ID, DISTRICT_NAME FROM SETUP_DISTRICT WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.home_county_id#">
                                                </cfquery>										
                                                <cfoutput query="get_district_name">
                                                    <cfif get_consumer.home_district_id eq district_id>#district_name#</cfif>
                                                </cfoutput>
                                            </cfif>
                                        </cfif>
                                    </td>
                                </cfif>
                            </tr>
                            <tr style="height:20px;">
                                <cfif attributes.is_detail_adres eq 0>
                                    <th></th>
                                    <th>&nbsp;</th>
                                </cfif>
                                <th class="me-title" style="width:120px;"><cf_get_lang_main no='559.Şehir'></th>
                                <td>
                                    <cfif len(get_consumer.home_city_id)>
                                        <cfquery name="GET_CITY_HOME" datasource="#DSN#">
                                            SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.home_country_id#">
                                        </cfquery>
                                        <cfoutput query="get_city_home">
                                            <cfif get_consumer.home_city_id eq city_id>#city_name#</cfif>
                                        </cfoutput>
                                    </cfif>
                                </td>
                                <cfif attributes.is_detail_adres eq 1>
                                    <th>&nbsp;</th>
                                    <th class="me-title">Cadde</th>
                                    <td><cfoutput>#get_consumer.home_main_street#</cfoutput></td>
                                </cfif>
                            </tr>
                            <tr<tr style="height:20px;">>
                                <cfif attributes.is_detail_adres eq 0>
                                    <th></th>
                                    <th>&nbsp;</th>
                                </cfif>
                                <th class="me-title">İlçe<cfif attributes.is_cons_adress eq 1>*</cfif></th>
                                <td>
                                    <cfif len(get_consumer.home_county_id)>
                                        <cfquery name="GET_COUNTY_HOME" datasource="#DSN#">
                                            SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.home_city_id#">
                                        </cfquery>										
                                        <cfoutput query="get_county_home">
                                            <cfif get_consumer.home_county_id eq county_id>#county_name#</cfif>
                                        </cfoutput>
                                    </cfif>
                                </td>
                                <cfif attributes.is_detail_adres eq 1>
                                    <th>&nbsp;</th>
                                    <th class="me-title">Sokak</th>
                                    <td><cfoutput>#get_consumer.home_street#</cfoutput></td>
                                </cfif>
                            </tr>
                            <tr style="height:20px;">
                                <th class="me-title"><cf_get_lang_main no='720.Semt'></th>
                                <td><cfoutput>#get_consumer.homesemt#</cfoutput></td>				
                                <cfif attributes.is_detail_adres eq 0>
                                    <th>&nbsp;</th>
                                    <th class="me-title"><cf_get_lang_main no='60.Posta Kodu'></th>
                                    <td><cfoutput>#get_consumer.homepostcode#</cfoutput></td>
                                </cfif>
                                <cfif attributes.is_detail_adres eq 1>
                                    <th>&nbsp;</th>
                                    <th class="me-title">No</th>
                                    <td><cfoutput>#get_consumer.home_door_no#</cfoutput></td>
                                </cfif>
                            </tr>
                            <cfif attributes.is_detail_adres eq 1>
                                <tr style="height:20px;">
                                    <th class="me-title"><cf_get_lang_main no='60.Posta Kodu'></th>
                                    <td><cfoutput>#get_consumer.homepostcode#</cfoutput></td>
                                </tr>
                            </cfif>
                        </table>
					</td>
				</tr>
				<tr class="header" style="height:20px;">
					<td onClick="gizle_goster(gizli4);" class="header_title"><cf_get_lang no='216.İş Adresim'></td>
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
                        <table>
                            <tr style="height:20px;">
                                <cfif attributes.is_detail_adres eq 0>
                                    <th class="me-title"><cf_get_lang_main no='1311.Adres'></th>
                                    <td rowspan="3"><textarea name="work_address" id="work_address" disabled="disabled" style="width:140px;height:75px;"><cfoutput>#work_dis##get_consumer.workaddress#</cfoutput></textarea></td>
                                    <th>&nbsp;</th>
                                </cfif>
                                <th class="me-title" style="width:120px;"><cf_get_lang_main no='807.Ülke'></th>
                                <td style="width:110px;">
                                    <cfoutput query="get_country">
                                        <cfif get_consumer.work_country_id eq country_id>#country_name#</cfif>
                                    </cfoutput>
                                </td>
                                <cfif attributes.is_detail_adres eq 1>
                                    <th style="width:40px;">&nbsp;</th>
                                    <th class="me-title" style="width:130px;">Mahalle</th>
                                    <td><cfif attributes.is_residence_select eq 0>
                                            <cfif len(get_consumer.work_district)><cfoutput>#get_consumer.work_district#</cfoutput><cfelse><cfoutput>#work_dis#</cfoutput></cfif>">
                                        <cfelse>
                                            <cfif len(get_consumer.work_district_id)>
                                                <cfquery name="GET_DISTRICT_NAME" datasource="#DSN#">
                                                    SELECT DISTRICT_ID, DISTRICT_NAME FROM SETUP_DISTRICT WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_county_id#">
                                                </cfquery>										
                                                <cfoutput query="get_district_name">
                                                    <cfif get_consumer.work_district_id eq district_id>#district_name#</cfif>
                                                </cfoutput>
                                            </cfif>
                                        </cfif>
                                    </td>
                                </cfif>
                            </tr>
                            <tr style="height:20px;">
                                <cfif attributes.is_detail_adres eq 0>
                                    <th></th>
                                    <th>&nbsp;</th>
                                </cfif>
                                <th class="me-title"><cf_get_lang_main no='559.Şehir'></th>
                                <td>
                                    <cfif len(get_consumer.work_city_id)>
                                        <cfquery name="GET_CITY_WORK" datasource="#DSN#">
                                            SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_country_id#">
                                        </cfquery>
                                        <cfoutput query="get_city_work">
                                            <cfif get_consumer.work_city_id eq city_id>#city_name#</cfif>
                                        </cfoutput>
                                    </cfif>
                                </td>
                                <cfif attributes.is_detail_adres eq 1>
                                    <th>&nbsp;</th>
                                    <th class="me-title">Cadde</th>
                                    <td><cfoutput>#get_consumer.work_main_street#</cfoutput>
                                </cfif>
                            </tr>
                            <tr style="height:20px;">
                                <cfif attributes.is_detail_adres eq 0>
                                    <th></th>
                                    <th>&nbsp;</th>
                                </cfif>
                                <th class="me-title">İlçe</th>
                                <td>
                                    <cfif len(get_consumer.work_county_id)>
                                        <cfquery name="GET_COUNTY_WORK" datasource="#DSN#">
                                            SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_city_id#">
                                        </cfquery>										
                                        <cfoutput query="get_county_work">
                                            <cfif get_consumer.work_county_id eq county_id>#county_name#</cfif>
                                        </cfoutput>
                                    </cfif>
                                </td>
                                <cfif attributes.is_detail_adres eq 1>
                                    <th>&nbsp;</th>
                                    <th class="me-title">Sokak</th>
                                    <td><cfoutput>#get_consumer.work_street#</cfoutput>
                                </cfif>
                            </tr>
                            <tr style="height:20px;">
                                <th class="me-title"><cf_get_lang_main no='720.Semt'></th>
                                <td><cfoutput>#get_consumer.worksemt#</cfoutput></td>				
                                <cfif attributes.is_detail_adres eq 0>
                                    <th>&nbsp;</th>
                                    <th class="me-title"><cf_get_lang_main no='60.Posta Kodu'></th>
                                    <td><cfoutput>#get_consumer.workpostcode#</cfoutput></td>
                                </cfif>
                                <cfif attributes.is_detail_adres eq 1>
                                    <th>&nbsp;</th>
                                    <th class="me-title">No</th>
                                    <td><cfoutput>#get_consumer.work_door_no#</cfoutput></td>
                                </cfif>
                            </tr>
                            <cfif attributes.is_detail_adres eq 1>
                                <tr style="height:20px;">
                                    <th class="me-title"><cf_get_lang_main no='60.Posta Kodu'></th>
                                    <td style="width:100px;"><cfoutput>#get_consumer.workpostcode#</cfoutput></td>
                                </tr>
                            </cfif>
                    	</table>
                    </td>
                </tr>
            <cfelse>
                <cfinclude template="upd_cons_address.cfm">
            </cfif>
			<cfif (isdefined("attributes.is_tax_adress") and attributes.is_tax_adress eq 1) or not isdefined("attributes.is_tax_adress")>
                <tr class="header" style="height:20px;">
                    <td onClick="gizle_goster(gizli5);" class="header_title"><cf_get_lang no='220.Fatura Adresim'></td>
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
                        <table>
                            <tr style="height:20px;">
                                <th class="me-title" style="width:120px;">Vergi Dairesi</th>
                                <td style="width:110px;"><cfoutput>#get_consumer.tax_office#</cfoutput></td>
                                <th>&nbsp;</th>
                                <th class="me-title" style="width:130px;">Vergi No</th>
                                <td>
                                    <cfoutput>#get_consumer.tax_no#</cfoutput>
                                </td>
                            </tr>
                            <tr style="height:20px;">
                                <cfif attributes.is_detail_adres eq 0>
                                    <th class="me-title"><cf_get_lang_main no='1311.Adres'></th>
                                    <td rowspan="3"><textarea name="tax_address" id="tax_address" disabled="disabled" style="width:140px;height:75px;"><cfoutput>#tax_dis##get_consumer.tax_adress#</cfoutput></textarea></td>
                                    <th>&nbsp;</th>
                                </cfif>
                                <th class="me-title"><cf_get_lang_main no='807.Ülke'></th>
                                <td>
                                    <cfoutput query="get_country">
                                        <cfif get_consumer.tax_country_id eq country_id>#country_name#</cfif>
                                    </cfoutput>
                                </td>
                                <cfif attributes.is_detail_adres eq 1>
                                    <th>&nbsp;</th>
                                    <th class="me-title">Mahalle</th>
                                    <td><cfif attributes.is_residence_select eq 0>
                                            <input type="text" name="tax_district" id="tax_district" disabled="disabled" style="width:140px;" value="<cfif len(get_consumer.tax_district)><cfoutput>#get_consumer.tax_district#</cfoutput><cfelse><cfoutput>#tax_dis#</cfoutput></cfif>">
                                        <cfelse>
                                            <cfif len(get_consumer.tax_district_id)>
                                                <cfquery name="GET_DISTRICT_NAME" datasource="#DSN#">
                                                    SELECT DISTRICT_ID, DISTRICT_NAME FROM SETUP_DISTRICT WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.tax_county_id#">
                                                </cfquery>										
                                                <cfoutput query="get_district_name">
                                                    <cfif get_consumer.tax_district_id eq district_id>#district_name#</cfif>
                                                </cfoutput>
                                            </cfif>
                                        </cfif>
                                    </td>
                                </cfif>
                            </tr>
                            <tr style="height:20px;">
                                <cfif attributes.is_detail_adres eq 0>
                                    <th></th>
                                    <th>&nbsp;</th>
                                </cfif>
                                <th class="me-title"><cf_get_lang_main no='559.Şehir'></th>
                                <td>
                                    <cfif len(get_consumer.tax_city_id)>
                                        <cfquery name="GET_CITY_TAX" datasource="#DSN#">
                                            SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.tax_country_id#">
                                        </cfquery>
                                        <cfoutput query="get_city_tax">
                                            <cfif get_consumer.tax_city_id eq city_id>#city_name#</cfif>
                                        </cfoutput>
                                    </cfif>
                                </td>
                                <cfif attributes.is_detail_adres eq 1>
                                    <th>&nbsp;</th>
                                    <th class="me-title">Cadde</th>
                                    <td><cfoutput>#get_consumer.tax_main_street#</cfoutput></td>
                                </cfif>
                            </tr>
                            <tr style="height:20px;">
                                <cfif attributes.is_detail_adres eq 0>
                                    <th></th>
                                    <th>&nbsp;</th>
                                </cfif>
                                <th class="me-title">İlçe</th>
                                <td>
                                    <cfif len(get_consumer.tax_county_id)>
                                        <cfquery name="GET_COUNTY_TAX" datasource="#DSN#">
                                            SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.tax_city_id#">
                                        </cfquery>										
                                        <cfoutput query="get_county_tax">
                                            <cfif get_consumer.tax_county_id eq county_id>#county_name#</cfif>
                                        </cfoutput>
                                    </cfif>
                                </td>
                                <cfif attributes.is_detail_adres eq 1>
                                    <th>&nbsp;</th>
                                    <th class="me-title">Sokak</th>
                                    <td><cfoutput>#get_consumer.tax_street#</cfoutput></td>
                                </cfif>
                            </tr>
                            <tr style="height:20px;">
                                <th class="me-title"><cf_get_lang_main no='720.Semt'></th>
                                <td><cfoutput>#get_consumer.tax_semt#</cfoutput></td>				
                                <cfif attributes.is_detail_adres eq 0>
                                    <th>&nbsp;</th>
                                    <th class="me-title"><cf_get_lang_main no='60.Posta Kodu'></th>
                                    <td><cfoutput>#get_consumer.tax_postcode#</cfoutput></td>
                                </cfif>
                                <cfif attributes.is_detail_adres eq 1>
                                    <th>&nbsp;</th>
                                    <th class="me-title">No</th>
                                    <td><cfoutput>#get_consumer.tax_door_no#</cfoutput></td>
                                </cfif>
                            </tr>
                            <cfif attributes.is_detail_adres eq 1>
                                <tr style="height:20px;">
                                    <th class="me-title"><cf_get_lang_main no='60.Posta Kodu'></th>
                                    <td><cfoutput>#get_consumer.tax_postcode#</cfoutput></td>
                                </tr>
                            </cfif>
                        </table>
					</td>
				</tr>
			</cfif>
			<!--- Hobi --->
			<cfif isdefined("attributes.is_consumer_hoby") and attributes.is_consumer_hoby eq 1>
				<tr class="header" style="height:20px;">
					<td onClick="gizle_goster(gizli6);" class="header_title"><cf_get_lang no='222.Hobilerim'> / <cf_get_lang no='856.İlgi Alanlarım'></td>
				</tr>
				<tr style="display:none;" id="gizli6">
					<td class="contentforlabel" style="vertical-align:top;">
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
						<table border="0" cellpadding="2" cellspacing="1">
							<cfset this_row_ = 0>
							<cfif get_consumer_hobbies.recordcount>
								<cfoutput query="get_hobby">
									<cfif this_row_ mod attributes.member_coloum_number eq 0><tr></cfif>
                                        <cfif liste contains HOBBY_ID>
                                            <cfset this_row_ = this_row_ + 1>
                                            <td style="width:150px;">
                                            <label for="hobby_id_#get_hobby.hobby_id#">
                                                #get_hobby.hobby_name# </label>&nbsp;&nbsp;
                                            </td>
                                        </cfif>
                                    <cfif this_row_ mod attributes.member_coloum_number eq 0></tr></cfif>
                                </cfoutput>
							<cfelse>
								Kayıt Bulunamadı !
							</cfif> 
						</table>
					</td>
				</tr>
			</cfif>
			<!--- yetkinlik --->
			<cfif isdefined("attributes.is_consumer_req_type") and attributes.is_consumer_req_type eq 1>
				<tr class="header" style="height:20px;">
					<td onClick="gizle_goster(gizli7);" class="header_title"><cf_get_lang_main no='1297.Yetkinliklerim'></td>
				</tr>
				<tr style="display:none;" id="gizli7">
					<td class="contentforlabel" style="vertical-align:top;">
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
							<cfif get_consumer_req.recordcount>
								<cfoutput query="get_req">
									<cfif this_row_2 mod attributes.member_coloum_number eq 0><tr></cfif>
										<cfif liste contains req_id>
											<cfset this_row_2 = this_row_2 + 1>
											<td style="width:150px;">
												<label for="req_id_#get_req.req_id#">#get_req.req_name#</label>&nbsp;&nbsp;
											</td>
										</cfif>
									<cfif this_row_2 mod attributes.member_coloum_number eq 0></tr></cfif>
								</cfoutput>
							<cfelse>
								Kayıt Bulunamadı !
							</cfif>
						</table>
					</td>
				</tr>
			</cfif>
			<!--- egitim --->
			<cfif isdefined("attributes.is_consumer_education") and attributes.is_consumer_education eq 1>
				<tr class="header" style="height:20px;">
					<td onClick="gizle_goster(gizli8);" class="header_title"><cf_get_lang no='225.Eğitim Bilgilerim'></td>
				</tr>
				<tr style="display:none;" id="gizli8">
					<td class="contentforlabel" style="vertical-align:top;">
						<cfquery name="GET_UNV" datasource="#DSN#">
							SELECT SCHOOL_ID,SCHOOL_NAME FROM SETUP_SCHOOL ORDER BY SCHOOL_NAME ASC
						</cfquery>
						<cfquery name="GET_CONS_EDUCATION" datasource="#DSN#">
							SELECT TOP 1 * FROM CONSUMER_EDUCATION_INFO WHERE 
							<cfif isdefined("attributes.cid")>
								CONS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">
							<cfelse>
								CONS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
							</cfif>
						</cfquery>
						<cfif get_cons_education.recordcount>
							<table border="0" style="width:100%;">
								<tr>
									<td style="width:110px;"></td>
									<td class="txtboldblue" style="width:229px;"><cf_get_lang no='520.Okul Adı'></td>
									<td class="txtboldblue" style="width:53px;"><cf_get_lang_main no='142.Giriş'></td>
									<td class="txtboldblue" style="width:145px;"><cf_get_lang no='521.Mezuniyet'></td>
									<td class="txtboldblue" style="width:35px;">&nbsp;</td>
								</tr>
								<tr>
									<td><b><cf_get_lang no='522.İlköğretim'></b></td>
									<td><cfoutput>#get_cons_education.edu1#</cfoutput></td>
									<td><cfoutput>#get_cons_education.edu1_start#</cfoutput></td>
									<td><cfoutput>#get_cons_education.edu1_start#</cfoutput></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td><b><cf_get_lang no='523.Ortaokul'></b></td>
									<td><cfoutput>#get_cons_education.edu2#</cfoutput></td>
									<td><cfoutput>#get_cons_education.edu2_start#</cfoutput></td>
									<td><cfoutput>#get_cons_education.edu2_finish#</cfoutput></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td><b><cf_get_lang no='524.Lise'></b></td>
									<td><cfoutput>#get_cons_education.edu3#</cfoutput></td>
									<td><cfoutput>#get_cons_education.edu3_start#</cfoutput></td>
									<td><cfoutput>#get_cons_education.edu3_finish#</cfoutput></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td><b><cf_get_lang_main no='1958.Üniversite'></b></td>
									<td>
										<cfoutput query="get_unv">
											<cfif get_unv.school_id eq get_cons_education.edu4_id >#get_unv.school_name#</cfif>	
										</cfoutput>
									</td>
									<td><cfoutput>#get_cons_education.edu4_start#</cfoutput></td>
									<td><cfoutput>#get_cons_education.edu4_finish#</cfoutput></td>
									<td>&nbsp;</td>
								</tr>	
								<tr>
									<td><b><cf_get_lang no='526.Yüksek Lisans'></b></td>
									<td><cfoutput>#get_cons_education.edu5#</cfoutput></td>
									<td><cfoutput>#get_cons_education.edu5_start#</cfoutput></td>
									<td><cfoutput>#get_cons_education.edu5_finish#</cfoutput></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td><b><cf_get_lang no='527.Diğer Üniversite'></b></td>
									<td><cfoutput>#get_cons_education.edu4#</cfoutput>
									</td>
								</tr>
							</table>
						<cfelse>
							Kayıt Bulunamadı !
						</cfif>
					</td>
				</tr>
			</cfif>
			<!--- diğer adresler --->
			<cfif isdefined("attributes.is_other_address") and attributes.is_other_address eq 1>
				<tr class="header" style="height:20px;">
					<td onClick="gizle_goster(gizli9);" class="me-title">Diğer Adresler</td>
				</tr>
				<tr style="display:none;" id="gizli9">
					<td class="contentforlabel" style="vertical-align:top;">
						<cfquery name="GET_CONSUMER_ADRESS" datasource="#DSN#">
							SELECT
								CONTACT_ID,
								CONTACT_NAME,
								CONTACT_TELCODE,
								CONTACT_TEL1,
								CONTACT_EMAIL,
								CONTACT_COUNTY_ID,
								CONTACT_CITY_ID,
								CONTACT_COUNTRY_ID,
								STATUS		
							FROM
								CONSUMER_BRANCH
							WHERE
								<cfif isdefined("attributes.cid")>
                                    CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">
                                <cfelse>
                                    CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
                                </cfif>
							ORDER BY
								CONTACT_NAME
						</cfquery>
						<table cellspacing="1" cellpadding="2" border="0" style="width:98%;">
							<tr class="color-row">
								<td>
                                    <table>
                                        <input type="hidden" name="address_count" id="address_count" value="<cfoutput>#get_consumer_adress.recordcount#</cfoutput>">
                                        <input type="hidden" name="add_adres" id="add_adres" value="0">
                                        <tr class="header" style="height:22px;">
                                            <td class="txtbold" style="width:150px;">Adres Adı</td>
                                            <td class="txtbold" style="width:110px;">İletişim</td>
                                            <td class="txtbold" style="width:150px;">İlçe</td>
                                            <td class="txtbold" style="width:150px;">Şehir</td>
                                            <td class="txtbold" style="width:150px;">Ülke</td>
                                            <td class="txtbold">Durum</td>
                                        </tr>	
										<cfif get_consumer_adress.recordcount>
                                            <cfset county_list=''>
                                            <cfset city_list=''>
                                            <cfset country_list=''>	
                                            <cfoutput query="get_consumer_adress">
                                                <cfif len(contact_county_id) and not listfind(county_list,contact_county_id)>
                                                    <cfset county_list = Listappend(county_list,contact_county_id)>
                                                </cfif>
                                                <cfif len(contact_city_id) and not listfind(city_list,contact_city_id)>
                                                    <cfset city_list = Listappend(city_list,contact_city_id)>
                                                </cfif>
                                                <cfif len(contact_country_id) and not listfind(country_list,contact_country_id)>
                                                    <cfset country_list = Listappend(country_list,contact_country_id)>
                                                </cfif>	
                                            </cfoutput>
                                            <cfif len(county_list)>
                                                <cfset county_list=listsort(county_list,"numeric","ASC",",")>			
                                                <cfquery name="GET_COUNTY_NAME" datasource="#DSN#">
                                                    SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN (#county_list#) ORDER BY COUNTY_ID
                                                </cfquery>
                                                <cfset main_county_list = listsort(listdeleteduplicates(valuelist(get_county_name.county_id,',')),'numeric','ASC',',')>
                                            </cfif>
                                            <cfif len(city_list)>
                                                <cfset city_list=listsort(city_list,"numeric","ASC",",")>			
                                                <cfquery name="GET_CITY_NAME" datasource="#DSN#">
                                                    SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#city_list#) ORDER BY CITY_ID
                                                </cfquery>
                                                <cfset main_city_list = listsort(listdeleteduplicates(valuelist(get_city_name.city_id,',')),'numeric','ASC',',')>
                                            </cfif>
                                            <cfif len(country_list)>
                                                <cfset country_list=listsort(country_list,"numeric","ASC",",")>			
                                                <cfquery name="GET_COUNTRY_NAME" datasource="#DSN#">
                                                    SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID IN (#country_list#) ORDER BY COUNTRY_ID
                                                </cfquery>
                                                <cfset main_country_list = listsort(listdeleteduplicates(valuelist(get_country_name.country_id,',')),'numeric','ASC',',')>
                                            </cfif>
                                            <cfoutput query="get_consumer_adress">
                                                <input type="hidden" name="address_id#currentrow#" id="address_id#currentrow#" value="#contact_id#">
                                                <input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                                                <tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" id="frm_row#currentrow#" style="height:20px;">
                                                    <td>#contact_name#</td>
                                                    <td>
                                                        #contact_telcode#-#contact_tel1# &nbsp;
                                                        <cfif len(contact_email)>
                                                            #contact_email#
                                                        </cfif>
                                                    </td>
                                                    <td><cfif len(contact_county_id)>#get_county_name.county_name[listfind(main_county_list,get_consumer_adress.contact_county_id,',')]#</cfif></td>
                                                    <td><cfif len(contact_city_id)>#get_city_name.city_name[listfind(main_city_list,get_consumer_adress.contact_city_id,',')]#</cfif></td>
                                                    <td><cfif len(contact_country_id)>#get_country_name.country_name[listfind(main_country_list,get_consumer_adress.contact_country_id,',')]#</cfif></td>
                                                    <td><cfif status eq 1>Aktif<cfelse>Pasif</cfif></td>
                                                </tr>
                                                <tr class="color-row" id="upd_address_t#currentrow#" style="display:none;">
                                                    <td colspan="5">
                                                        <div id="upd_address#currentrow#" style="display:none;"></div>
                                                    </td>
                                                </tr>
                                            </cfoutput>
                                        <cfelse>
                                            <tr class="color-row" height="20">
                                                <td colspan="5"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                                            </tr>
                                        </cfif>
                                    </table>
                                </td>
                            </tr>
                            <tr class="color-row" id="add_address_t" style="display:none;">
                                <td>
                                    <div id="add_address" style="display:none;"></div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </cfif> 
			<cfif not isdefined("attributes.cid")>
				<tr style="height:35px;">
					<td style="text-align:right;"><cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'></td>
				</tr>
			</cfif>
		</table>
	</cfform>
<cfelse>
	<script type="text/javascript">
		alert("Böyle Bir Kayıt Bulunamadı. Bilgileri Kontrol Ediniz !");
		history.back();
	</script>
	<cfabort>
</cfif>
