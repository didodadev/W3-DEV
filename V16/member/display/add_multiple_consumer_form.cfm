<cf_xml_page_edit fuseact="member.add_multiple_consumer_form" is_multi_page="1">
<cf_get_lang_set module_name="member">
<cfparam name="attributes.home_telcode" default="">
<cfparam name="attributes.home_tel" default="">
<cfparam name="attributes.mobiltel" default="">
<cfparam name="attributes.pos_code_text" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.consumer_email" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.consumer_name" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.sales_emp_id" default="">
<cfinclude template="../query/get_mobilcat.cfm">
<cfinclude template="../query/get_country.cfm">
<cfinclude template="../query/get_edu_level.cfm">
<cfinclude template="../query/get_sector_cats.cfm">
<!--- Sadece Aktif kategorilerin gelmesi icin --->
<cfset attributes.is_active_consumer_cat = 1>
<cfinclude template="../query/get_consumer_cat.cfm">
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_SUBSCRIPTION_TYPE" datasource="#DSN3#">
	SELECT
		SUBSCRIPTION_TYPE_ID,
		SUBSCRIPTION_TYPE
	FROM 
		SETUP_SUBSCRIPTION_TYPE
	ORDER BY
		SUBSCRIPTION_TYPE
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="57558.Üye No"></cfsavecontent>
<cf_form_box title="#message#">
	<cfform name="add_multiple_consumer" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=member.add_multiple_consumer">
		<table>
			<tr>
				<td colspan="5"><strong><cf_get_lang dictionary_id ='30236.Kisisel Bilgiler'></strong></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id ='30604.Üyelik No'>&nbsp;</td>
				<td width="205"><input type="text" name="consumer_code" id="consumer_code" value="" style="width:150px;" tabindex="1"></td>
				<td></td>
				<td width="110"><cf_get_lang dictionary_id='30237.Eğitim Durumu'></td>
				<td width="185">
				  <select name="education_level" id="education_level" style="width:150px;" tabindex="10">
                      <option value=""><cf_get_lang dictionary_id='57734.Seciniz'></option>
                      <cfoutput query="get_edu_level">
                        <option value="#edu_level_id#">#education_name#</option>
                      </cfoutput>
				  </select>	
				</td>
			</tr>
			<tr>
				<td width="110"><cf_get_lang dictionary_id='57631.Ad'> *</td>
				<td><input type="text" name="consumer_name" id="consumer_name" value="" style="width:150px;" tabindex="2"></td>
				<td></td>
				<td><cf_get_lang dictionary_id='57764.Cinsiyet'></td>
				<td>
					<select name="sex" id="sex" style="width:150px;"  tabindex="11">
                        <option value="1"><cf_get_lang dictionary_id='58959.Erkek'></option>
                        <option value="0"><cf_get_lang dictionary_id='58958.Kadın'></option>
					</select>
				</td>
			</tr>
			<tr>
				<td width="110"><cf_get_lang dictionary_id='58726.Soyad '>*</td>
				<td><input type="text" name="consumer_surname" id="consumer_surname" value=""  tabindex="3" style="width:150px;"></td>
				<td></td>
				<td height="26"><cf_get_lang dictionary_id='30513.Medeni Durumu'></td>
				<td><input type="checkbox"  tabindex="12" name="married" id="married" value="checkbox">&nbsp;<cf_get_lang dictionary_id='30501.Evli'></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='58727.Doğum Tarihi'></td>
				<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='58727.Doğum Tarihi!'></cfsavecontent>
					<cfinput type="text" tabindex="4" name="birthdate" validate="#validate_style#" message="#message#" style="width:150px;" >
					<cf_wrk_date_image date_field="birthdate">
				</td>
				<td></td>
				<td width="100"><cf_get_lang dictionary_id='30500.meslek Tipi'></td>
				<td>
					<cf_wrk_combo 
						name="vocation_type"
						query_name="GET_VOCATION_TYPE"
						option_name="vocation_type"
						option_value="vocation_type_id"
						width="150">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='58025.TC Kimlik No'></td>
				<td><input type="text" name="tc_identy_no" id="tc_identy_no" tabindex="5" style="width:150px;" maxlength="11" ></td>
				<td></td>
				<td><cf_get_lang dictionary_id='57579.Sektor'></td>
				<td>
				  <select name="sector_cat_id" id="sector_cat_id" style="width:150px;"tabindex="14">
                      <option value=""><cf_get_lang dictionary_id='57734.seciniz'></option>
                      <cfoutput query="get_sector_cats">
                        <option value="#sector_cat_id#">#sector_cat#</option>
                      </cfoutput>
				  </select>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='30254.Kod / Mobil'></td>
				<td>
					<select name="mobilcat_id" id="mobilcat_id" style="width:65px;" tabindex="6">
						<option value=""><cf_get_lang dictionary_id='57734.Seciniz'></option>
						<cfoutput query="get_mobilcat">
							<option value="#mobilcat#" <cfif isdefined("attributes.mobilcat_id") and attributes.mobilcat_id eq mobilcat>selected</cfif>>#mobilcat#</option>
						</cfoutput>
					</select>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='30223.Kod/ Mobil Girmelisiniz'>!</cfsavecontent>
					<cfif isdefined("attributes.mobiltel")>
						<cfinput type="text" name="mobiltel" maxlength="7" tabindex="7" validate="integer" message="#message#" style="width:81px;" value="#attributes.mobiltel#">
					<cfelse>
						<cfinput type="text" name="mobiltel" maxlength="7" tabindex="7" validate="integer" message="#message#" style="width:81px;" value="">
					</cfif>
				</td>
				<td></td>
				<td width="110"><cf_get_lang dictionary_id='57574.sirket'></td>
				<td width="165"><input type="text" name="company" id="company" tabindex="15"value="<cfif isdefined("attributes.company")><cfoutput>#attributes.company#</cfoutput></cfif>" maxlength="40" style="width:150px;" ></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='30243.Fotoğraf'></td>
				<td><input type="file" name="picture" id="picture" style="width:150px;"tabindex="8" ></td>
				<td></td>
				<td><cf_get_lang dictionary_id="58859.Sürec"> *</td>
				<td><cf_workcube_process is_upd='0'process_cat_width='150' is_detail='0'></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57428.e-mail'></td>
				<td>
				  <cfsavecontent variable="message"><cf_get_lang dictionary_id='31691.email Giriniz'> ! </cfsavecontent>
				  <cfif isdefined("attributes.consumer_email")>
				  <cfinput type="text" name="consumer_email"tabindex="9" maxlength="100" validate="email"  message="#message#" style="width:150px;" value="#attributes.consumer_email#">
				  <cfelse>
				  <cfinput type="text" name="consumer_email"tabindex="9"  maxlength="100" validate="email" message="#message#" style="width:150px;" value="">
				  </cfif>	
				</td>		
			</tr>
		</table>
		<cfsavecontent variable="message"><cf_get_lang dictionary_id="30605.Adresler"></cfsavecontent>
		<cf_seperator id="adresler_" title="#message#">
		<table id="adresler_">
			<tr>
				<td class="txtboldblue">
					<cf_get_lang dictionary_id ='30258.Ev Adres Bilgileri'>
				</td>
				<td class="txtboldblue">
					<cf_get_lang dictionary_id ='30381.İs Adres Bilgileri'>
				</td>
				<td class="txtboldblue">
					<cf_get_lang dictionary_id='58749.Fatura Bilgileri'>
				</td>
			</tr>
			<tr>
				<td valign="top" width="330">
					<table>
						<tr>
							<td width="110" nowrap="nowrap"><cf_get_lang dictionary_id='30384.Kod/Ev Telefonu'></td>
							<td>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id ='30316.Telefon Kodu'> !</cfsavecontent>
								<cfif isdefined("attributes.home_telcode")>
									<cfinput text="text" name="home_telcode" tabindex="17" validate="integer" message="#message#" maxlength="3" style="width:65px;" value="#attributes.home_telcode#" >
								<cfelse>
									<cfinput text="text" name="home_telcode" tabindex="17"validate="integer" message="#message#" maxlength="3" style="width:65px;" value="" >
								</cfif>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='57499.telefon'> !</cfsavecontent>	
								<cfif isdefined("attributes.home_tel")>			  
									<cfinput type="text" name="home_tel" tabindex="18" validate="integer" message="#message#" maxlength="7" style="width:81px;" value="#attributes.home_tel#" >
								<cfelse>
									<cfinput type="text" name="home_tel" tabindex="18"validate="integer" message="#message#" maxlength="7" style="width:81px;" value="" >
								</cfif>
							</td> 
						</tr>
						<tr valign="top">
							<td><cf_get_lang dictionary_id='58723.Adres'></td>
							<td rowspan="2"><textarea name="home_address" id="home_address" tabindex="19" style="width:150px;height:50px;" ></textarea></td>
						</tr>
						<tr></tr>
						<tr>
							<td><cf_get_lang dictionary_id='57472.Posta Kodu'></td>
							<td><input type="text" name="home_postcode" id="home_postcode"  tabindex="20"value="" maxlength="5" style="width:150px;"></td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='58219.Ülke'></td>
							<td>
								<select name="home_country" id="home_country" onchange="remove_adress('1','home');"tabindex="21" style="width:152px;">
									<option value=""><cf_get_lang dictionary_id='57734.Seciniz'></option>
									<cfoutput query="get_country">
										<option value="#get_country.country_id#" <cfif is_default eq 1>selected</cfif>>#get_country.country_name#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='57971.sehir'></td>
							<td nowrap="nowrap">
							<input type="hidden" name="home_city_id" id="home_city_id" value="">    
							<input type="text" name="home_city" id="home_city" value="" readonly style="width:150px;">
							<a href="javascript://" onclick="pencere_ac_city('home');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='58638.Ilce'></td>
							<td><input type="hidden" name="home_county_id" id="home_county_id" readonly="">
							<input type="text" name="home_county" id="home_county" value="" readonly style="width:150px;">
							<a href="javascript://" onclick="pencere_ac('home');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='58132.Semt'></td>
							<td><input type="text" name="home_semt" id="home_semt" tabindex="22"value="" maxlength="30" style="width:150px;"></td>
						</tr>
					</table>
				</td>
				<td valign="top" width="330">
					<table>
						<tr>
							<td width="110" nowrap="nowrap"><cf_get_lang dictionary_id ='30382.Kod/İs Telefonu'></td>
							<td>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30382.Kod/İs Telefonu !'></cfsavecontent>
									<cfinput type="text"  tabindex="23" name="work_telcode" validate="integer" message="#message#" maxlength="3" style="width:65px;" >
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='57499.telefon'></cfsavecontent>
									<cfinput type="text" tabindex="24" name="work_tel" validate="integer" message="#message#" maxlength="7" style="width:81px;" >
							</td>	
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='58723.Adres'></td>
							<td rowspan="2"><textarea tabindex="25" name="work_address" id="work_address" style="width:150px;height:50px;" ></textarea></td>
							<td></td>
						</tr>
						<tr></tr>
						<tr>
							<td><cf_get_lang dictionary_id='57472.Posta Kodu'></td>
							<td><input type="text" name="work_postcode" id="work_postcode" value="" tabindex="26"maxlength="5" style="width:150px;"></td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='58219.Ülke'></td>
							<td>
								<select name="work_country"  id="work_country" tabindex="27" onchange="remove_adress('1','work');" style="width:152px;">
									<option value=""><cf_get_lang dictionary_id='57734.Seciniz'></option>
									<cfoutput query="get_country">
										<option value="#get_country.country_id#" <cfif is_default eq 1>selected</cfif>>#get_country.country_name#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='57971.sehir'></td>
							<td nowrap="nowrap">
							<input type="hidden" name="work_city_id" id="work_city_id" value="">    
							<input type="text" name="work_city" id="work_city" value="" readonly style="width:150px;">
							<a href="javascript://" onclick="pencere_ac_city('work');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='58638.Ilce'></td>
							<td><input type="hidden" name="work_county_id" id="work_county_id" readonly="">
							<input type="text" name="work_county" id="work_county" value="" readonly style="width:150px;">
							<a href="javascript://" onclick="pencere_ac('work');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='58132.Semt'></td>
							<td><input type="text" name="work_semt" id="work_semt" tabindex="28" value="" maxlength="30" style="width:150px;"></td>
						</tr>
					</table>
				</td>
				<td valign="top" width="330">
					<table width="98%">
						<tr>
							<td><cf_get_lang dictionary_id='58762.Vergi Dairesi'></td>
							<td><input type="text" name="tax_office" id="tax_office" tabindex="29"maxlength="50" style="width:160px;"></td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='57752.Vergi No'></td>
							<td>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57752.Vergi No!'></cfsavecontent>
								<cfif isdefined("attributes.tax_no")>
									<cfinput type="text" name="tax_no"tabindex="30" validate="integer" message="#message#"maxlength="10" style="width:160px;" value="#attributes.tax_no#">
								<cfelse>
									<cfinput type="text" name="tax_no" tabindex="30" validate="integer" message="#message#"maxlength="10" style="width:160px;" value="">
								</cfif> 
							</td>
						</tr>
						<tr>
							<td nowrap="nowrap"><cf_get_lang dictionary_id='30261.Fatura Adresi'></td>
							<td rowspan="3"><textarea name="tax_address" id="tax_address" tabindex="31" style="width:160px;height:60px;"></textarea></td>
						</tr>
						<tr></tr>
						<tr></tr>
						<tr>
							<td><cf_get_lang dictionary_id='57472.Posta Kodu'></td>
							<td><input type="text" name="tax_postcode" id="tax_postcode" tabindex="32" value="<cfif isdefined("attributes.home_postcode")><cfoutput>#attributes.home_postcode#</cfoutput></cfif>" maxlength="5" style="width:160px;"></td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='58219.Ülke'></td>
							<td>
								<select name="tax_country" id="tax_country" tabindex="33" onchange="remove_adress('1','tax');" style="width:160px;">
									<option value=""><cf_get_lang dictionary_id='57734.Seciniz'></option>
									<cfoutput query="get_country">
										<option value="#get_country.country_id#" <cfif is_default eq 1>selected</cfif>>#get_country.country_name#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='57971.sehir'></td>
							<td nowrap="nowrap">
                                <input type="hidden" name="tax_city_id" id="tax_city_id" value="">    
                                <input type="text" name="tax_city" id="tax_city" value="" readonly style="width:160px;">
                                <a href="javascript://" onclick="pencere_ac_city('tax');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                            </td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='58638.Ilce'></td>
							<td><input type="hidden" name="tax_county_id" id="tax_county_id" readonly="">
							<input type="text" name="tax_county" id="tax_county" value="" readonly style="width:160px;">
							<a href="javascript://" onclick="pencere_ac('tax');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id='58132.Semt'></td>
							<td><input type="text" name="tax_semt" id="tax_semt" tabindex="34" value="<cfif isdefined("attributes.home_semt")><cfoutput>#attributes.home_semt#</cfoutput></cfif>" maxlength="30" style="width:160px;"></td>
						</tr>
						<tr>
							<td></td>
							<td colspan="2">
							<input type="checkbox" name="is_home_address" id="is_home_address" tabindex="35" onclick="adres_aktar(1)"><cf_get_lang dictionary_id ='30606.Ev Adresi'>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="is_work_address" id="is_work_address" tabindex="36" onclick="adres_aktar(2)"><cf_get_lang dictionary_id ='30607.İs Adresi'>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<cfsavecontent variable="message"><cf_get_lang dictionary_id="30608.Üyelik Bilgileri"></cfsavecontent>
		<cf_seperator id="uyelik_bilgileri_" title="#message#">
		<table id="uyelik_bilgileri_"> 
			<tr>
				<td width="115"><cf_get_lang dictionary_id='58609.Üye Kategorisi'> *</td>
				<td width="205">
					<cfset attributes.startrow=1>
					<cfif get_consumer_cat.recordcount>
						<cfset attributes.maxrows = get_consumer_cat.recordcount>
					<cfelse>
						<cfset attributes.maxrows = 1>
					</cfif>
					<select name="consumer_cat_id" id="consumer_cat_id" style="width:130px;" tabindex="37">
						<cfoutput query="get_consumer_cat" startrow="#attributes.STARTROW#" maxrows="#attributes.MAXROWS#">	
							<option value="#conscat_id#">#conscat#</option>
						</cfoutput>
					</select>
				</td>
				<td width="115"><cf_get_lang dictionary_id ='30609.Abonelik Tipi'> *</td>
				<td nowrap="nowrap" width="210">
					<input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
					<input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
					<input type="text" name="product_name" id="product_name"  readonly style="width:150px;" value="<cfoutput>#attributes.product_name#</cfoutput>" passthrough="readonly=yes">
					<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=add_multiple_consumer.stock_id&product_id=add_multiple_consumer.product_id&field_name=add_multiple_consumer.product_name&keyword='+encodeURIComponent(document.add_multiple_consumer.product_name.value),'list','popup_product_names');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
				</td>
				<td width="90"><cf_get_lang dictionary_id='57655.Baslama Tarihi'> *</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='57655.Baslama Tarihi'></cfsavecontent>
					<cfinput type="text" name="start_date" tabindex="39" validate="#validate_style#" message="#message#" style="width:110px;">
					<cf_wrk_date_image date_field="start_date">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id ='30612.Abonelik Kategorisi'>*</td>
				<td>
					<cfquery name="get_faction_control" datasource="#DSN#"><!--- Sistem ekleme sürecine yetkisi olup olmadığını kontrol eder. --->
					SELECT 
						DISTINCT
							PROCESS_TYPE_ROWS.PROCESS_ROW_ID,
							PROCESS_TYPE_ROWS.STAGE,
							PROCESS_TYPE_ROWS.LINE_NUMBER,
							PROCESS_TYPE_ROWS.DISPLAY_FILE_NAME
						FROM
							PROCESS_TYPE PROCESS_TYPE,
							PROCESS_TYPE_OUR_COMPANY PROCESS_TYPE_OUR_COMPANY,
							PROCESS_TYPE_ROWS PROCESS_TYPE_ROWS,
							PROCESS_TYPE_ROWS_POSID PROCESS_TYPE_ROWS_POSID,
							EMPLOYEE_POSITIONS EMPLOYEE_POSITIONS
						WHERE
							PROCESS_TYPE.IS_ACTIVE = 1 AND
							PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_ROWS.PROCESS_ID AND
							PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_OUR_COMPANY.PROCESS_ID AND
							PROCESS_TYPE_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
							CAST(PROCESS_TYPE.FACTION AS NVARCHAR(2500))+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.add_subscription_contract,%"> AND
							EMPLOYEE_POSITIONS.POSITION_CODE = #session.ep.POSITION_CODE# AND 
							PROCESS_TYPE_ROWS_POSID.PROCESS_ROW_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID AND
							EMPLOYEE_POSITIONS.POSITION_ID = PROCESS_TYPE_ROWS_POSID.PRO_POSITION_ID			
					UNION
						SELECT DISTINCT
							PROCESS_TYPE_ROWS.PROCESS_ROW_ID,
							PROCESS_TYPE_ROWS.STAGE,
							PROCESS_TYPE_ROWS.LINE_NUMBER,
							PROCESS_TYPE_ROWS.DISPLAY_FILE_NAME
						FROM 	
							PROCESS_TYPE  AS PROCESS_TYPE,
							PROCESS_TYPE_OUR_COMPANY PROCESS_TYPE_OUR_COMPANY,
							PROCESS_TYPE_ROWS AS PROCESS_TYPE_ROWS,
							PROCESS_TYPE_ROWS_WORKGRUOP AS PROCESS_TYPE_ROWS_WORKGRUOP,
							PROCESS_TYPE_ROWS_POSID AS PROCESS_TYPE_ROWS_POSID
						WHERE 
							PROCESS_TYPE.IS_ACTIVE = 1 AND
							PROCESS_TYPE_ROWS.PROCESS_ID = PROCESS_TYPE.PROCESS_ID AND
							PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_OUR_COMPANY.PROCESS_ID AND
							PROCESS_TYPE_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
							CAST(PROCESS_TYPE.FACTION AS NVARCHAR(2500))+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.add_subscription_contract,%"> AND
							PROCESS_TYPE_ROWS_WORKGRUOP.PROCESS_ROW_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID  AND 
							PROCESS_TYPE_ROWS_WORKGRUOP.MAINWORKGROUP_ID IS NOT NULL AND 
							PROCESS_TYPE_ROWS_WORKGRUOP.MAINWORKGROUP_ID = PROCESS_TYPE_ROWS_POSID.WORKGROUP_ID AND 
							PROCESS_TYPE_ROWS_POSID.PRO_POSITION_ID IN (#session.ep.POSITION_CODE#)
						ORDER BY 
							PROCESS_TYPE_ROWS.LINE_NUMBER
					</cfquery><!--- Sistem sürec kontolü --->
					<input type="hidden" name="faction_value" id="faction_value" value="<cfoutput>#get_faction_control.PROCESS_ROW_ID#</cfoutput>"><!--- Sistemdeki sürecinin row_id'sinin tutar --->
					<!--- Abone ekleme sayfasına yetkisi olup olmadığını kontrol eder. --->
					<cfquery name="get_faction_control2" datasource="#DSN#">
						SELECT DISTINCT
							PROCESS_TYPE_ROWS.PROCESS_ROW_ID,
							PROCESS_TYPE_ROWS.STAGE,
							PROCESS_TYPE_ROWS.LINE_NUMBER,
							PROCESS_TYPE_ROWS.DISPLAY_FILE_NAME
						FROM
							PROCESS_TYPE PROCESS_TYPE,
							PROCESS_TYPE_OUR_COMPANY PROCESS_TYPE_OUR_COMPANY,
							PROCESS_TYPE_ROWS PROCESS_TYPE_ROWS,
							PROCESS_TYPE_ROWS_POSID PROCESS_TYPE_ROWS_POSID,
							EMPLOYEE_POSITIONS EMPLOYEE_POSITIONS
						WHERE
							PROCESS_TYPE.IS_ACTIVE = 1 AND
							PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_ROWS.PROCESS_ID AND
							PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_OUR_COMPANY.PROCESS_ID AND
							PROCESS_TYPE_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
							CAST(PROCESS_TYPE.FACTION AS NVARCHAR(2500))+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.popup_subscription_payment_plan,%"> AND
							EMPLOYEE_POSITIONS.POSITION_CODE = #session.ep.POSITION_CODE# AND 
							PROCESS_TYPE_ROWS_POSID.PROCESS_ROW_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID AND
							EMPLOYEE_POSITIONS.POSITION_ID = PROCESS_TYPE_ROWS_POSID.PRO_POSITION_ID			
					UNION
						SELECT DISTINCT
							PROCESS_TYPE_ROWS.PROCESS_ROW_ID,
							PROCESS_TYPE_ROWS.STAGE,
							PROCESS_TYPE_ROWS.LINE_NUMBER,
							PROCESS_TYPE_ROWS.DISPLAY_FILE_NAME
						FROM 	
							PROCESS_TYPE  AS PROCESS_TYPE,
							PROCESS_TYPE_OUR_COMPANY PROCESS_TYPE_OUR_COMPANY,
							PROCESS_TYPE_ROWS AS PROCESS_TYPE_ROWS,
							PROCESS_TYPE_ROWS_WORKGRUOP AS PROCESS_TYPE_ROWS_WORKGRUOP,
							PROCESS_TYPE_ROWS_POSID AS PROCESS_TYPE_ROWS_POSID
						WHERE
							PROCESS_TYPE.IS_ACTIVE = 1 AND
							PROCESS_TYPE_ROWS.PROCESS_ID = PROCESS_TYPE.PROCESS_ID AND
							PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_OUR_COMPANY.PROCESS_ID AND
							PROCESS_TYPE_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
							CAST(PROCESS_TYPE.FACTION AS NVARCHAR(2500))+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.popup_subscription_payment_plan,%"> AND
							PROCESS_TYPE_ROWS_WORKGRUOP.PROCESS_ROW_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID  AND 
							PROCESS_TYPE_ROWS_WORKGRUOP.MAINWORKGROUP_ID IS NOT NULL AND 
							PROCESS_TYPE_ROWS_WORKGRUOP.MAINWORKGROUP_ID = PROCESS_TYPE_ROWS_POSID.WORKGROUP_ID AND 
							PROCESS_TYPE_ROWS_POSID.PRO_POSITION_ID IN (#session.ep.POSITION_CODE#)
						ORDER BY 
							PROCESS_TYPE_ROWS.LINE_NUMBER
					</cfquery>
					<input type="hidden" name="faction_value2" id="faction_value2" value="<cfoutput>#get_faction_control2.PROCESS_ROW_ID#</cfoutput>"><!--- Abone sürecinin row_id'sinin tutar --->
					<select name="subscription_type" id="subscription_type" style="width:130px;" tabindex="40">
						<cfoutput query="get_subscription_type">
                            <option value="#subscription_type_id#">#subscription_type#</option>
                            <!--- <input type="radio" name="subscription_type" checked="checked" value="#subscription_type_id#">#subscription_type#<br/> --->
                        </cfoutput>
					</select>
				</td>
				<td><cf_get_lang dictionary_id ='30613.Satıs Sorumlusu'></td>
				<td><input type="hidden" name="sales_emp_id" id="sales_emp_id" value="<cfif len(attributes.sales_emp_id) and len(attributes.pos_code_text)><cfoutput>#attributes.sales_emp_id#</cfoutput></cfif>">
					<input type="hidden" name="pos_code" id="pos_code" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
					<input type="text" name="pos_code_text" id="pos_code_text"  readonly style="width:150px;" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#get_emp_info(attributes.pos_code,1,0)#</cfoutput></cfif>">
					<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_multiple_consumer.sales_emp_id&field_code=add_multiple_consumer.pos_code&field_name=add_multiple_consumer.pos_code_text&select_list=1','list','popup_list_positions');return false"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
				</td>
				<td><cf_get_lang dictionary_id ='57700.Bitis Tarihi'></td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id ='57700.Bitis Tarihi'></cfsavecontent>
					<cfinput type="text" tabindex="42" name="finish_date" validate="#validate_style#" message="#message#" style="width:110px;">
					<cf_wrk_date_image date_field="finish_date">
				</td>
			</tr>
		</table>
		<!--- Burası 5 tane icin  calısıyordu 1 taneye düsürüldü eğer boyle sabit kalırsa kod düzeltilecek M.ER 20070726 --->
		<cfloop from="1" to="1" index="urun_no">
		<cfsavecontent variable="message"><cf_get_lang dictionary_id="30203.Ödeme Bilgileri"></cfsavecontent>	
		<cf_seperator id="odeme_bilgileri_" title="#message#">
		<table id="odeme_bilgileri_">
			<tr valign="top">
				<td style="text-align:left;" width="115"><cf_get_lang dictionary_id='58851.odeme Tarihi'> *</td>
				<td width="205">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='57742.Tarih'></cfsavecontent>
					<cfinput type="text"  tabindex="43" name="odeme_tarihi_#urun_no#" validate="#validate_style#"message="#message#" style="width:110px;">
					<cf_wrk_date_image date_field="odeme_tarihi_#urun_no#">
				</td>
				<td width="115"><cf_get_lang dictionary_id='58928.odeme Tipi'> *</td>
				<td width="210">
					<cfoutput>
					<input type="hidden" name="card_paymethod_id_#urun_no#" id="card_paymethod_id_#urun_no#" value="">
					<input type="hidden" name="paymethod_id_#urun_no#" id="paymethod_id_#urun_no#" value="">
					<input type="text" name="paymethod_#urun_no#" id="paymethod_#urun_no#" style="width:150px;"  value="" readonly>
					<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_paymethods&field_id=add_multiple_consumer.paymethod_id_#urun_no#&field_name=add_multiple_consumer.paymethod_#urun_no#&field_card_payment_id=add_multiple_consumer.card_paymethod_id_#urun_no#&field_card_payment_name=add_multiple_consumer.paymethod_#urun_no#','list','popup_paymethods');"><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734.Seciniz'>" border="0" align="absmiddle"></a>
					</cfoutput>
				</td>
				<td width="90"><cf_get_lang dictionary_id ='57673.Tutar'></td>
				<td width="205">
					<input type="text" tabindex="44" style="width:80px;"onkeyup="return(FormatCurrency(this,event));"class="moneybox" name="satir_price_<cfoutput>#urun_no#</cfoutput>" id="satir_price_<cfoutput>#urun_no#</cfoutput>" value="">
					<select name="<cfoutput>money_type_#urun_no#</cfoutput>" id="<cfoutput>money_type_#urun_no#</cfoutput>" tabindex="45" style="width:45px;">
						<cfoutput query="GET_MONEY">
							<option value="#MONEY#">#MONEY#</option>
						</cfoutput>
					</select>
				</td>
			</tr>
		</cfloop>
		</table>
		<table>
			<tr>
				<cfif isdefined('xml_consumer_contract_id') and len(xml_consumer_contract_id)>
					<input type="hidden" name="consumer_contract_id" id="consumer_contract_id" value="<cfoutput>#xml_consumer_contract_id#</cfoutput>">
					<cfquery name="GET_CONTENT_ORDER" datasource="#DSN#">
						SELECT CONT_HEAD FROM CONTENT WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#xml_consumer_contract_id#">
					</cfquery>							
						<td colspan="3" width="37%" style="text-align:right;"><a href="javascript://" class="tableyazi" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_content_notice&content_id=#xml_consumer_contract_id#</cfoutput>','list');"><cfoutput>#get_content_order.cont_head#</cfoutput></a><br /></td>
						<td colspan="2" width="30%" align="center"><input type="checkbox" name="contract_rules" id="contract_rules" class="radio_frame" value="1" /><cf_get_lang dictionary_id ='30184.Temsilci Sozlesmesini Kabul Ediyorum.'>*</td>
				</cfif>
			</tr>
		</table>
	<cf_form_box_footer><cf_workcube_buttons type_format='1' is_upd='0' add_function="control_form()"></cf_form_box_footer>
	</cfform>
</cf_form_box>	
<script type="text/javascript">

function control_form()
{
	//var m_tipi= <cfoutput>#get_consumer_cat.recordcount#</cfoutput>//Üyelik kapsamı kategorisi
	var s_tipi = <cfoutput>#get_subscription_type.recordcount#</cfoutput>//üyelik tipi kategorisi 
	var sayac = 0 ;//Üyelik Kapsamı kontrolü icin
	var sayac2 = 0;//Üyelik Tipi Kontrolü icin
	i=0;j=0;
	/*for (i=0;i<m_tipi;i++)
	{
		if(document.add_multiple_consumer.consumer_cat_id[i].checked == false)
		sayac=sayac+1;
	}
	if(sayac==m_tipi)
	{
		alert('Lütfen Üye Kategorisi Seciniz.');
		return false;
	}*/
	<cfif isdefined('xml_consumer_contract_id') and len(xml_consumer_contract_id)>
		if(document.getElementById('contract_rules').checked!=true)
		{
			alert ("<cf_get_lang dictionary_id ='30234.Temsilci Sozlesmesini Kabul Ediyorum Seceneğini Secmelisiniz!'>");
			return false;
		}
	</cfif>
	for (j=0;j<s_tipi;j++)
	{
		if(document.add_multiple_consumer.subscription_type[j].checked == false)
		sayac2=sayac2+1;
	}
	if(sayac2==s_tipi)
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id ='30618.Sistem Kategorisi '>");
		return false;
	}
	
	if(document.add_multiple_consumer.consumer_name.value=="" || document.add_multiple_consumer.consumer_surname.value=="" )
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id ='30339.Üye Adı'>/<cf_get_lang dictionary_id='58550.soyadı'>");
		return false;
	}
	if(document.add_multiple_consumer.faction_value.value=="")
	{
		alert("<cf_get_lang dictionary_id ='30620.Sistem Eklemek icin yetkiniz bulunmamaktadır,Sistem Süreclerinizi kontrol ediniz'>");	
		return false;
	}
	if(document.add_multiple_consumer.faction_value2.value=="")
	{
		alert("<cf_get_lang dictionary_id ='30621.Abone Eklemek icin yetkiniz bulunmamaktadır,Sistem Süreclerinizi kontrol ediniz'>");	
		return false;
	}
	if(document.add_multiple_consumer.stock_id.value =="" || document.add_multiple_consumer.product_id.value =="")
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id ='30718.Abonelik Tipi Seciniz'>");
		return false;
	}
	if(document.add_multiple_consumer.start_date.value =="")
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id ='30609.abonelik tipi'>");
		return false;
	}
	for (k=1;k<=1;k++)
	{
	if(eval("document.add_multiple_consumer.odeme_tarihi_"+k).value != "" && eval("document.add_multiple_consumer.paymethod_"+k).value != "")
		{
			if(eval("document.add_multiple_consumer.satir_price_"+k).value != "")
			eval("document.add_multiple_consumer.satir_price_"+k).value = filterNum(eval("document.add_multiple_consumer.satir_price_"+k).value);
		}
	else
		{
		alert("<cf_get_lang dictionary_id ='30624.odeme Bilgilerinizi Eksiksiz Giriniz'>");
		return false;
		}
	}
	return true;	
}
function pencere_ac_city(type)
{
	if(type=='work')
	{
		x = document.add_multiple_consumer.work_country.selectedIndex;
		if (document.add_multiple_consumer.work_country[x].value == "")
		{
			alert("<cf_get_lang dictionary_id='57425.uyarı'>:<cf_get_lang dictionary_id='57485.oncelik'>-<cf_get_lang dictionary_id='58219.Ülke'> (<cf_get_lang dictionary_id='58445.Is'>) ! ");
		}	
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=add_multiple_consumer.work_city_id&field_name=add_multiple_consumer.work_city&field_phone_code=add_multiple_consumer.work_telcode&country_id=' + document.add_multiple_consumer.work_country.value,'small','popup_dsp_city');
		}
		return remove_adress('','work');
	}
	else if(type=='home')
	{
		x = document.add_multiple_consumer.home_country.selectedIndex;
		if (document.add_multiple_consumer.home_country[x].value == "")
		{
			alert("<cf_get_lang dictionary_id='57425.uyarı'>:<cf_get_lang dictionary_id='57485.oncelik'>-<cf_get_lang dictionary_id='58219.Ülke'> (<cf_get_lang dictionary_id='30506.Ev'>) ! ");
		}	
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=add_multiple_consumer.home_city_id&field_name=add_multiple_consumer.home_city&field_phone_code=add_multiple_consumer.home_telcode&country_id=' + document.add_multiple_consumer.home_country.value,'small','popup_dsp_city');
		}
		return remove_adress('','home');		
	}
	else if(type=='tax')
	{
		x = document.add_multiple_consumer.tax_country.selectedIndex;
		if (document.add_multiple_consumer.tax_country[x].value == "")
		{
			alert("<cf_get_lang dictionary_id='57425.uyarı'>:<cf_get_lang dictionary_id='57485.oncelik'>-<cf_get_lang dictionary_id='58219.Ülke'>(<cf_get_lang dictionary_id='57441.Fatura'>) ! ");
		}	
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=add_multiple_consumer.tax_city_id&field_name=add_multiple_consumer.tax_city&country_id=' + document.add_multiple_consumer.tax_country.value,'small','popup_dsp_city');
		}
		return remove_adress('','tax');
	}
}function pencere_ac(type)
{
	if(type=='work')
	{
		x = document.add_multiple_consumer.work_country.selectedIndex;
		if (document.add_multiple_consumer.work_country[x].value == "")
		{
			alert("<cf_get_lang dictionary_id='57425.uyarı'>:<cf_get_lang dictionary_id='57485.oncelik'>-<cf_get_lang dictionary_id='58219.Ülke'> (<cf_get_lang dictionary_id='58445.Is'>) !");
		}	
		else if(document.add_multiple_consumer.work_city_id.value == "")
		{
			alert("<cf_get_lang dictionary_id='57425.uyarı'>:<cf_get_lang dictionary_id='57485.oncelik'>-<cf_get_lang dictionary_id='58608.il'> (<cf_get_lang dictionary_id='58445.Is'>) !");
		}
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=add_multiple_consumer.work_county_id&field_name=add_multiple_consumer.work_county&city_id=' + document.add_multiple_consumer.work_city_id.value,'small','popup_dsp_county');
			return remove_adress('','work');
		}
	}
	else if(type=='home')
	{
		x = document.add_multiple_consumer.home_country.selectedIndex;
		if (document.add_multiple_consumer.home_country[x].value == "")
		{
			alert("<cf_get_lang dictionary_id='57425.uyarı'>:<cf_get_lang dictionary_id='57485.oncelik'>-<cf_get_lang dictionary_id='58219.Ülke'> (<cf_get_lang dictionary_id='30506.Ev'>) !");
		}	
		else if(document.add_multiple_consumer.home_city_id.value == "")
		{
			alert("<cf_get_lang dictionary_id='57425.uyarı'>:<cf_get_lang dictionary_id='57485.oncelik'>-<cf_get_lang dictionary_id='58608.il'> (<cf_get_lang dictionary_id='30506.Ev'>) !");
		}
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=add_multiple_consumer.home_county_id&field_name=add_multiple_consumer.home_county&city_id=' + document.add_multiple_consumer.home_city_id.value,'small','popup_dsp_county');
			return remove_adress('','home');
		}
	}
	else if(type=='tax')
	{
		x = document.add_multiple_consumer.tax_country.selectedIndex;
		if (document.add_multiple_consumer.tax_country[x].value == "")
		{
			alert("<cf_get_lang dictionary_id='57425.uyarı'>:<cf_get_lang dictionary_id='57485.oncelik'>-<cf_get_lang dictionary_id='58219.Ülke'> (<cf_get_lang dictionary_id='57441.Fatura'>) !");
		}	
		else if(document.add_multiple_consumer.tax_city_id.value == "")
		{
			alert("<cf_get_lang dictionary_id='57425.uyarı'>:<cf_get_lang dictionary_id='57485.oncelik'>-<cf_get_lang dictionary_id='58608.il'> (<cf_get_lang dictionary_id='57441.Fatura'>) !");
		}
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=add_multiple_consumer.tax_county_id&field_name=add_multiple_consumer.tax_county&city_id=' + document.add_multiple_consumer.tax_city_id.value,'small','popup_dsp_county');
			return remove_adress('','tax');
		}
	}	
}
function remove_adress(parametre,type)
{
	if(type=='tax')
	{
		if(parametre==1)
		{
			document.add_multiple_consumer.tax_city_id.value = '';
			document.add_multiple_consumer.tax_city.value = '';
			document.add_multiple_consumer.tax_county_id.value = '';
			document.add_multiple_consumer.tax_county.value = '';
		}
		else
		{
			document.add_multiple_consumer.tax_county_id.value = '';
			document.add_multiple_consumer.tax_county.value = '';
		}
	}	
}
function adres_aktar(type)
{
	if (type==1)//Ev adresi aktar
	{
		document.add_multiple_consumer.is_work_address.checked = false;
		document.add_multiple_consumer.tax_city_id.value = document.add_multiple_consumer.home_city_id.value;
		document.add_multiple_consumer.tax_city.value = document.add_multiple_consumer.home_city.value;
		document.add_multiple_consumer.tax_county_id.value = document.add_multiple_consumer.home_county_id.value;
		document.add_multiple_consumer.tax_county.value = document.add_multiple_consumer.home_county.value;
		document.add_multiple_consumer.tax_county_id.value = document.add_multiple_consumer.home_county_id.value;
		document.add_multiple_consumer.tax_county.value = document.add_multiple_consumer.home_county.value;
		document.add_multiple_consumer.tax_semt.value = document.add_multiple_consumer.home_semt.value;
		document.add_multiple_consumer.tax_postcode.value = document.add_multiple_consumer.home_postcode.value;
		document.add_multiple_consumer.tax_address.value = document.add_multiple_consumer.home_address.value;
	}
	else if (type==2)
	{
		document.add_multiple_consumer.is_home_address.checked = false;
		document.add_multiple_consumer.tax_city_id.value = document.add_multiple_consumer.work_city_id.value;
		document.add_multiple_consumer.tax_city.value = document.add_multiple_consumer.work_city.value;
		document.add_multiple_consumer.tax_county_id.value = document.add_multiple_consumer.work_county_id.value;
		document.add_multiple_consumer.tax_county.value = document.add_multiple_consumer.work_county.value;
		document.add_multiple_consumer.tax_county_id.value = document.add_multiple_consumer.work_county_id.value;
		document.add_multiple_consumer.tax_county.value = document.add_multiple_consumer.work_county.value;
		document.add_multiple_consumer.tax_semt.value = document.add_multiple_consumer.work_semt.value;
		document.add_multiple_consumer.tax_postcode.value = document.add_multiple_consumer.work_postcode.value;
		document.add_multiple_consumer.tax_address.value = document.add_multiple_consumer.work_address.value;
	}
}
</script>
<cf_get_lang_set module_name="#listgetat(attributes.fuseaction,1,'.')#">
