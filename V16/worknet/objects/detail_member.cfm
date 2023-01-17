<cfif isdefined('session.pp.userid')>
	<cf_get_lang_set module_name="member"><!--- sayfanin en altinda kapanisi var --->
	<cfset cmp = createObject("component","V16.worknet.query.worknet_member") />
	<cfset getPartnerManager = cmp.getPartner(partner_id:session.pp.userid)>
	<cfset getCompany = cmp.getCompany(company_id:session.pp.company_id)>
	<cfset getPartner = cmp.getPartner(company_id:session.pp.company_id) />
	<cfset getReqType = cmp.getReqType(company_id:session.pp.company_id) />
	<!---<cfset getMobilcat = cmp.getMobilcat() />--->
	<cfset getCountry = cmp.getCountry() />
	<cfset getProductCat = cmp.getProductCat(company_id:session.pp.company_id) />
	<cfset getCompanyCat = createObject("component","worknet.objects.worknet_objects").getCompanyCat() />
	<cfset getCompanyBranch = cmp.getCompanyBranch(company_id:session.pp.company_id) />
	<cfif session.pp.userid eq getPartnerManager.manager_partner_id>
		<div class="haber_liste">
			<div class="haber_liste_1">
            	<div class="haber_liste_11"><h1><cfoutput>#session.pp.company#</cfoutput></h1></div>
            </div>
			<div class="sirketp_1">
				<ul>
					<li><a class="view_member aktif" href="javascript:void(0);" onclick="memberTab2('genel')" id="genel_tab"><cf_get_lang_main no='162.Sirket'></a></li>
					<li><a class="view_member" href="javascript:void(0);" onclick="memberTab2('partners')" id="partners_tab"><cf_get_lang_main no='1463.Çalışanlar'></a></li>
					<li><a class="view_member" href="javascript:void(0);" onclick="memberTab2('branchs')" id="branchs_tab"><cf_get_lang_main no='1637.Şubeler'></a></li>
					<li><a class="view_member" href="javascript:void(0);" onclick="memberTab2('asets')" id="asets_tab"><cf_get_lang_main no='156.Belgeler'> / <cf_get_lang no='45.Videolar'></a></li>
					<li><a class="view_member" href="javascript:void(0);" onclick="memberTab2('company_brands')" id="company_brands_tab"><cf_get_lang no='2.Markalarım'></a></li>
				</ul>
			</div>
			<div class="talep_detay_4" id="genel">
				<cfform name="form_upd_company" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_member_company" enctype="multipart/form-data">
					<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#getCompany.company_id#</cfoutput>">
					<input type="hidden" name="is_status" id="is_status" value="<cfoutput>#getCompany.company_status#</cfoutput>" />
					<input type="hidden" name="type_" id="type_" value="1" />
					<input type="hidden" name="is_related_company" id="is_related_company" value="<cfoutput>#getCompany.is_related_company#</cfoutput>" />
					<div style="display:none;"><cf_workcube_process is_upd='0' select_value = '#getCompany.company_state#' process_cat_width='150' is_detail='1'></div>
					<div class="talep_detay_1" style="width:908px;">
						<div class="talep_detay_11">
							<div class="td_kutu">
								<div class="td_kutu_1">
									<h2><cf_get_lang_main no='162.Şirket'></h2>
								</div>
								<div class="td_kutu_2">
									<table>
										<tr valign="top">
											<td width="650">
											<table>
												<tr>
													<td><cf_get_lang_main no='159.Unvan'>*</td>
													<td colspan="3"><input type="text" name="fullname" id="fullname" value="<cfoutput>#getCompany.fullname#</cfoutput>" maxlength="250" style="width:425px;"></td>
												</tr>
												<tr>
													<td><cf_get_lang_main no='339.Kisa Ad'>*</td>
													<td><input type="text" name="nickname" id="nickname" value="<cfoutput>#getCompany.nickname#</cfoutput>" maxlength="150" style="width:150px;"></td>
													<td><cf_get_lang_main no='1714.Yönetici'> *</td>
													<td><select name="manager_partner_id" id="manager_partner_id" style="width:150px;">
															<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
															<cfoutput query="getPartner">
																<option value="#getPartner.partner_id#" <cfif getPartner.partner_id is getCompany.manager_partner_id>selected</cfif>>#getPartner.company_partner_name# #getPartner.company_partner_surname#</option>
															</cfoutput>
														</select>
													</td>
												</tr>
												<tr>
													<td><cf_get_lang_main no='74.Kategori'>*</td>
													<td><cfsavecontent variable="text"><cf_get_lang_main no='322.Seciniz'></cfsavecontent>
														<select name="companycat_id" id="companycat_id" style="width:150px;">
															<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
															<cfoutput query="getCompanyCat">
																<option value="#COMPANYCAT_ID#" <cfif COMPANYCAT_ID eq getCompany.companycat_id>selected</cfif>>#companycat#</option>
															</cfoutput>
														</select>
													</td>
													<td><cf_get_lang_main no='167.Sektör'></td>
													<td><cfsavecontent variable="text"><cf_get_lang_main no='322.Seçiniz'></cfsavecontent>
														<cf_wrk_selectlang 
															name="company_sector"
															option_name="sector_cat"
															option_value="sector_cat_id"
															width="150"
															table_name="SETUP_SECTOR_CATS"
															option_text="#text#" value=#getCompany.SECTOR_CAT_ID#>
													</td>
												</tr>
												<tr>
													<td><cf_get_lang_main no='1350.Vergi Dairesi'> <!---*---></td>
													<td width="175"><input type="text" name="taxoffice" id="taxoffice" maxlength="30" value="<cfoutput>#getCompany.TAXOFFICE#</cfoutput>" style="width:150px;"></td>
													<td><cf_get_lang_main no='340.Vergi No'> / TCKN *</td>
													<td><input type="text" name="taxno" id="taxno" onKeyup="isNumber(this);" onBlur="isNumber(this);" value="<cfoutput>#getCompany.TAXNO#</cfoutput>" style="width:150px;"></td>
												</tr>
												<tr>
													<td valign="top"><cf_get_lang_main no='155.Ürün Kategorileri'> <!---*---></td>
													<td colspan="5" valign="top">
														<select name="product_category" id="product_category" style="width:425px; height:80px;" multiple>
															<cfif getProductCat.recordcount>
																<cfoutput query="getProductCat">
																	<cfset hierarchy_ = "">
																	<cfset new_name = "">
																	<cfloop list="#HIERARCHY#" delimiters="." index="hi">
																		<cfset hierarchy_ = ListAppend(hierarchy_,hi,'.')>
																		<cfset getCat = createObject("component","V16.worknet.query.worknet_product").getMainProductCat(hierarchy:hierarchy_)>
																		<cfset new_name = ListAppend(new_name,getCat.PRODUCT_CAT,'>')>
																	</cfloop>
																	<option value="#product_catid#">#new_name#</option>
																</cfoutput>
															</cfif>
														</select>
														<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.popup_list_product_categories&field_name=document.form_add_company.product_category','medium');">
															<img src="../documents/templates/worknet/tasarim/icon_9.png" width="22" height="22" />
														</a>
														<a href="javascript://" onClick="remove_field('product_category');"><img src="../documents/templates/worknet/tasarim/icon_8.png" width="22" height="22" /></a>
													</td>
												</tr>
												<tr>
													<td><cf_get_lang no='8.Firma Tipi'> <!---*---></td>
													<td colspan="3">
														<cf_multiselect_check 
															table_name="SETUP_FIRM_TYPE"  
															name="firm_type"
															width="400" 
															option_name="firm_type" 
															option_value="firm_type_id" value="#getCompany.firm_type#">
													</td>
												</tr>
											</table>
											</td>
											<td valign="top">
												<cfif len(getCompany.ASSET_FILE_NAME1)>
													<cf_get_server_file output_file="member/#getCompany.ASSET_FILE_NAME1#" output_server="#getCompany.ASSET_FILE_NAME1_SERVER_ID#" output_type="0" image_width="165">
													<!--- crop tool --->
													<cfif len(getCompany.ASSET_FILE_NAME1) and (listlast(getCompany.ASSET_FILE_NAME1,'.') is 'jpg' or listlast(getCompany.ASSET_FILE_NAME1,'.') is 'png' or listlast(getCompany.ASSET_FILE_NAME1,'.') is 'gif' or listlast(getCompany.ASSET_FILE_NAME1,'.') is 'jpeg')> 
														<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_image_editor&old_file_server_id=#getCompany.ASSET_FILE_NAME1_SERVER_ID#&old_file_name=#getCompany.ASSET_FILE_NAME1#&asset_cat_id=-9</cfoutput>','adminTv','wrk_image_editor')"><img src="/images/canta.gif" alt="Edit" title="Crop Tool" border="0"></a>
													</cfif>
												<cfelse>
													<img src="/images/no_photo.gif" style="margin-left:30px; margin-bottom:10px;">
												</cfif><br />
												<div class="ftd_kutu_22" style="width:176px;">
													<input type="file" name="ASSET1" id="ASSET1" style="width:150px; float:left;">
													<cfif isdefined('attributes.info_content_id') and len(attributes.info_content_id)>
														<a href="javascript://" data-width="250px" style="margin:4px 0px 0px 10px;" data-text="<cfoutput>#createObject('component','worknet.objects.worknet_objects').getContent(content_id:attributes.info_content_id)#</cfoutput>" class="tooltip">
															<img src="../documents/templates/worknet/tasarim/tooltipIcon.png" />
														</a>
													</cfif>
													<br />
													<cfif len(getCompany.asset_file_name1)>
														<samp style="padding-top:1px; margin-left:30px;"><cf_get_lang no='23.Logo Sil'>&nbsp;<input type="checkbox" name="del_asset1" id="del_asset1" value="1" style="float:right;margin-left:7px;"></samp>
													</cfif>
													<br />
													<cfsavecontent variable="message"><cf_get_lang_main no="49.Kaydet"></cfsavecontent>
													<input class="btn_1" type="submit" style="margin-right:30px;" onclick="return kontrol()" value="<cfoutput>#message#</cfoutput>" />
												</div>
										   </td>
										</tr>
										<!---<cfif isdefined('attributes.info_content_id') and len(attributes.info_content_id)>
											<tr><td colspan="2"><hr style="width:850px;"/></td></tr>
											<tr>
												<td colspan="2">
													<cfoutput>#createObject("component","worknet.objects.worknet_objects").getContent(content_id:attributes.info_content_id)#</cfoutput>
												</td>
											</tr>
										</cfif>--->
									</table>
								</div>
							</div>
						</div>
						<div class="talep_detay_12">
							<div class="td_kutu">
								<div class="td_kutu_1">
									<h2><cf_get_lang_main no='1311.Adres'><cf_get_lang_main no='577.ve'><cf_get_lang_main no='731.Iletisim'></h2>
								</div>
								<div class="td_kutu_2">
									<table>
									<tr>
										<td width="80"><cf_get_lang_main no='807.Ulke'> *</td>
										<td width="180">
											<select name="country" id="country" style="width:150px;" onChange="LoadCity(this.value,'city_id','county_id',0);LoadPhone(this.value);">
												<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
												<cfoutput query="getCountry">
													<option value="#country_id#" <cfif getCompany.country eq country_id>selected</cfif>>#country_name#</option>
												</cfoutput>
											</select>
										</td>
										<td width="90" rowspan="3" valign="top"><cf_get_lang_main no='1311.Adres'> *</td>
										<td width="175" rowspan="3">
											<cfsavecontent variable="message"><cf_get_lang no ='611.Adres Uzunluğu 200 Karakteri Geçemez'></cfsavecontent>
											<textarea name="company_address" id="company_address" style="width:150px; height:65px;" message="<cfoutput>#message#</cfoutput>" maxlength="200" onKeyUp="return ismaxlength(this);" onBlur="return ismaxlength(this);"><cfoutput>#getCompany.COMPANY_ADDRESS#</cfoutput></textarea>
										</td>
										<td><cf_get_lang no='36.Kod/Telefon'>*</td>
										<td width="150" align="right" style="text-align:right;">
											<input maxlength="5" type="text" name="company_telcode" id="company_telcode" onKeyup="isNumber(this);" onBlur="isNumber(this);" value="<cfoutput>#getCompany.COMPANY_TELCODE#</cfoutput>" style="width:50px;">
											<input maxlength="10" type="text" name="company_tel1" id="company_tel1" onKeyup="isNumber(this);" onBlur="isNumber(this);" value="<cfoutput>#getCompany.COMPANY_TEL1#</cfoutput>" style="width:85px;">
										</td>
									</tr>
									<tr>
										<td><cf_get_lang_main no='559.Sehir'> *</td>
										<td><cfquery name="get_city" datasource="#dsn#">
												SELECT CITY_ID,CITY_NAME FROM SETUP_CITY <cfif len(getCompany.country)>WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getCompany.country#"></cfif>
											</cfquery>
											<select name="city_id" id="city_id" style="width:150px;" onChange="LoadCounty(this.value,'county_id','company_telcode')">
												<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
												<cfoutput query="get_city">
													<option value="#city_id#" <cfif getCompany.city eq city_id>selected</cfif>>#city_name#</option>
												</cfoutput>
											</select>
										</td>
										<td><cf_get_lang_main no='87.Telefon'> 2</td>
										<td width="150" align="right" style="text-align:right;"><input validate="integer" maxlength="10" type="text" name="company_tel2" id="company_tel2" onKeyup="isNumber(this);" onBlur="isNumber(this);" value="<cfoutput>#getCompany.COMPANY_TEL2#</cfoutput>" style="width:85px;"></td>
									</tr>
									<tr>
										<td><cf_get_lang_main no='1226.Ilce'> *</td>
										<td><select name="county_id" id="county_id" style="width:150px;">
												<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
												<cfif len(getCompany.city)>
													<cfquery name="GET_COUNTY" datasource="#DSN#">
														SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#getCompany.city#"> ORDER BY COUNTY_NAME
													</cfquery>
													<cfoutput query="get_county">
														<option value="#county_id#" <cfif getCompany.county eq county_id>selected</cfif>>#county_name#</option>
													</cfoutput>
												</cfif>
											</select>
										</td>
										<td><cf_get_lang_main no='87.Telefon'>3</td>
										<td width="150" align="right" style="text-align:right;"><input maxlength="10" type="text" name="company_tel3" id="company_tel3" onKeyup="isNumber(this);" onBlur="isNumber(this);" value="<cfoutput>#getCompany.COMPANY_TEL3#</cfoutput>" style="width:85px;"></td>
									</tr>
									<tr>
										<td><cf_get_lang_main no='720.Semt'></td>
										<td><input type="text" name="semt" id="semt" value="<cfoutput>#getCompany.semt#</cfoutput>" maxlength="30" style="width:150px;"></td>
										<td><cf_get_lang_main no='60.Posta Kodu'></td>
				
										<td><input type="text" name="company_postcode" id="company_postcode" style="width:150px;" maxlength="10" value="<cfoutput>#getCompany.company_postcode#</cfoutput>"></td>
										<td><cf_get_lang_main no='76.Fax'></td>
										<td width="150" align="right" style="text-align:right;"><input type="text" name="company_fax" id="company_fax" onKeyup="isNumber(this);" onblur="isNumber(this);" value="<cfoutput>#getCompany.company_fax#</cfoutput>" maxlength="10" style="width:85px;"></td>
									</tr>
									<tr>
										<td><cf_get_lang no='41.Internet'></td>
										<td><input type="text" name="homepage" id="homepage" style="width:150px;" maxlength="50" value="<cfoutput>#getCompany.homepage#</cfoutput>"></td>
										<td><cf_get_lang_main no='16.e-mail'></td>
										<td><cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='16.E-mail'></cfsavecontent>
											<cfinput type="text" name="email" id="email" validate="email" message="#message#" maxlength="100" style="width:150px;" value="#getCompany.company_email#">
										</td>
										<td><cf_get_lang no='116.Kod / Mobil'></td>
										<td width="150" align="right" style="text-align:right;">
											<!---<select name="mobilcat_id" id="mobilcat_id" style="width:50px;" >
												<option value=""><cf_get_lang_main no='1173.Kod'></option>
												<cfoutput query="getMobilcat">
													<option value="#mobilcat#" <cfif getCompany.MOBIL_CODE eq mobilcat>selected</cfif>>#mobilcat#</option>
												</cfoutput>
											</select>--->
                                            <input maxlength="5" type="text" name="mobilcat_id" id="mobilcat_id" onKeyup="isNumber(this);" onblur="isNumber(this);" value="<cfoutput>#getCompany.MOBIL_CODE#</cfoutput>" style="width:50px;">
											<cfinput type="text" name="mobiltel" id="mobiltel" maxlength="20" onKeyup="isNumber(this);" onblur="isNumber(this);" style="width:85px;" value="#getCompany.mobiltel#">
										</td>
									</tr>
									<tr>
										<td><cf_get_lang no='428.Kroki'></td>
										<td><input type="FILE" style="width:150px;float:left;" name="ASSET2" id="ASSET2">
											<cfif isdefined('attributes.info_content_id') and len(attributes.info_content_id)>
												<a href="javascript://" data-width="500px" style="margin:4px 0px 0px 10px;" data-text="<cfoutput>#createObject('component','worknet.objects.worknet_objects').getContent(content_id:attributes.info_content_id)#</cfoutput>" class="tooltip">
													<img src="../documents/templates/worknet/tasarim/tooltipIcon.png" />
												</a>
											</cfif>
										</td>
										<td><cf_get_lang_main no='1137.Koordinatlar'></td>
										<td><cf_get_lang_main no='1141.E'><cfinput type="text" maxlength="10" range="-90,90" tabindex="35" message="Lütfen enlem değerini -90 ile 90 arasında giriniz!" value="#getCompany.coordinate_1#" name="coordinate_1" id="coordinate_1" style="width:56px;"> 
											<cf_get_lang_main no='1179.B'><cfinput type="text" maxlength="10" range="-180,180" tabindex="36" message="Lütfen boylam değerini -180 ile 180 arasında giriniz!" value="#getCompany.coordinate_2#" name="coordinate_2" id="coordinate_2" style="width:56px;">
											<cfif len(getCompany.coordinate_1) and len(getCompany.coordinate_2)>
												<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_view_map&coordinate_1=#getCompany.coordinate_1#&coordinate_2=#getCompany.coordinate_2#&title=#getCompany.fullname#</cfoutput>','list','popup_view_map')"><img src="/images/gmaps.gif" border="0" title="Haritada Göster" align="absbottom"></a>
											</cfif>
										</td>
									</tr>
									<cfif len(getCompany.asset_file_name2)>
									<tR>
										<td></td>
										<td><cf_get_server_file output_file="member/#getCompany.asset_file_name2#" output_server="#getCompany.asset_file_name2_server_id#" output_type="2" small_image="/images/branch_plus.gif" image_link="1">
											<input type="checkbox" name="del_asset2" id="del_asset2" value="1"><span style="margin:5px;"><cf_get_lang no='428.Kroki'><cf_get_lang_main no='51.Sil'></span>
										</td>
									</tR>
									</cfif>
									</table>
								</div>
							</div>
						</div>
						<div class="talep_detay_12">
							<div class="td_kutu">
								<div class="td_kutu_1">
									<h2><cf_get_lang_main no='673.Finansal Ozet'></h2>
								</div>
								<div class="td_kutu_2">
									<table>
									<tr>
										<td width="120"><cf_get_lang_main no='1894.Yurtiçi'><cf_get_lang no='26.Satış Cirosu'></td>
										<td width="170"><cf_wrk_selectlang
												 name="domestic_customer_value"
												 table_name="SETUP_CUSTOMER_VALUE"
												 option_name="CUSTOMER_VALUE"
												 option_value="CUSTOMER_VALUE_ID"
												 value="#getCompany.DOMESTIC_VALUE_ID#"
												 sort_type="CUSTOMER_SALE_START,CUSTOMER_VALUE"
												 width="150">
										</td>
										<td width="120"><cf_get_lang_main no='1895.Yurtdışı'><cf_get_lang no='26.Satış Cirosu'></td>
										<td width="170"><cf_wrk_selectlang
												 name="export_customer_value"
												 table_name="SETUP_CUSTOMER_VALUE"
												 option_name="CUSTOMER_VALUE"
												 option_value="CUSTOMER_VALUE_ID"
												 value="#getCompany.EXPORT_VALUE_ID#"
												 sort_type="CUSTOMER_SALE_START,CUSTOMER_VALUE"
												 width="150">
										</td>
									</tr>
									<tr>
										<td><cf_get_lang_main no='1603.Yillik'><cf_get_lang no='26.Satış Cirosu'></td>
										<td><cf_wrk_selectlang
												 name="annual_customer_value"
												 table_name="SETUP_CUSTOMER_VALUE"
												 option_name="CUSTOMER_VALUE"
												 option_value="CUSTOMER_VALUE_ID"
												 sort_type="CUSTOMER_SALE_START,CUSTOMER_VALUE"
												 value="#getCompany.COMPANY_VALUE_ID#"
												 width="150">
										</td>
										<td><cf_get_lang no='32.Şirket Büyüklüğü'></td>
										<td>
											<cf_wrk_selectlang
												 name="company_size_cat_id"
												 table_name="SETUP_COMPANY_SIZE_CATS"
												 option_name="company_size_cat"
												 option_value="company_size_cat_id"
												 value="#getCompany.company_size_cat_id#"
												 sort_type="COMPANY_SIZE_CAT"
												 width="150">
										</td>
									</tr>
									</table>
								</div>
							</div>
						</div>
						<div class="talep_detay_12">
							<div class="td_kutu">
								<div class="td_kutu_1">
									<h2><cf_get_lang no='11.Profil Bilgileri'></h2>
								</div>
								<div class="td_kutu_2">
									<table>
									<tr>
										<td><cf_get_lang no='119.Kuruluş Tarihi'></td>
										<td>
											<div class="ftd_kutu_22">
												<cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no='119.Kuruluş Tarihi'>!</cfsavecontent>
												<cfinput type="text" name="organization_start_date" id="organization_start_date" value="#dateformat(getCompany.org_start_date,dateformat_style)#" validate="#validate_style#" message="#message#"  style="float:left; width:70px;margin-right:5px;"/>
												<cf_wrk_date_image date_field="organization_start_date">
											</div>
										</td>
									</tr>
									<tr>
										<td width="90"><cf_get_lang_main no='1896.Sertifikalar'></td>
										<td width="175"><cf_multiselect_check 
												query_name="getReqType.query"
												name="req_type"
												width="250" 
												option_name="req_name" 
												option_value="req_id" 
												value="#getReqType.liste#"> </td>
                                    </tr>
                                    <tr>
                                        <td width="80" valign="top"><cf_get_lang_main no='1708.Şirket Profili'> <img src="../documents/templates/worknet/tasarim/dil_icon_3.png" width="18" height="14" alt="TR" style="float:right"></td>
                                        <td><textarea 
                                                name="company_detail" id="company_detail" 
                                                style="width:500px; height:120px;" maxlenght="1500"
                                                onChange="counter(this.id,'detailLen');return ismaxlength(this);"
                                                onkeydown="counter(this.id,'detailLen');return ismaxlength(this);" 
                                                onkeyup="counter(this.id,'detailLen');return ismaxlength(this);" 
                                                onBlur="return ismaxlength(this);"	
                                                ><cfoutput>#getCompany.company_detail#</cfoutput></textarea>
                                        </td>
                                        <td valign="bottom"><input type="text" name="detailLen"  id="detailLen" size="1"  style="width:35px;" value="1500" readonly /> </td>     
                                    </tr>
                                    <tr>
                                        <td width="80" valign="top"><cf_get_lang_main no='1708.Şirket Profili'> <img src="../documents/templates/worknet/tasarim/dil_icon_1.png" width="18" height="14" alt="TR" style="float:right"></td>
                                        <td><textarea 
												name="company_detail_eng" id="company_detail_eng" 
												style="width:500px; height:120px;" maxlenght="1500"
												onChange="counter(this.id,'detailLen_eng');return ismaxlength(this);"
												onkeydown="counter(this.id,'detailLen_eng');return ismaxlength(this);" 
												onkeyup="counter(this.id,'detailLen_eng');return ismaxlength(this);" 
												onBlur="return ismaxlength(this);"	
												><cfoutput>#getCompany.company_detail_eng#</cfoutput></textarea>
                                         </td>
                                         <td valign="bottom"><input type="text" name="detailLen_eng"  id="detailLen_eng" size="1"  style="width:35px;" value="1500" readonly /></td>
									</tr>
                                    <tr>
                                        <td width="80" valign="top"><cf_get_lang_main no='1708.Şirket Profili'> <img src="../documents/templates/worknet/tasarim/dil_icon_2.png" width="18" height="14" alt="TR" style="float:right"></td>
                                        <td><textarea 
												name="company_detail_spa" id="company_detail_spa" 
												style="width:500px; height:120px;" maxlenght="1500"
												onChange="counter(this.id,'detailLen_spa');return ismaxlength(this);"
												onkeydown="counter(this.id,'detailLen_spa');return ismaxlength(this);" 
												onkeyup="counter(this.id,'detailLen_spa');return ismaxlength(this);" 
												onBlur="return ismaxlength(this);"	
												><cfoutput>#getCompany.company_detail_spa#</cfoutput></textarea>
                                         </td>
                                         <td valign="bottom"><input type="text" name="detailLen_spa"  id="detailLen_spa" size="1"  style="width:35px;" value="1500" readonly /></td>
									</tr>
								</table>
								</div>
							</div>
						</div>
						
					</div>
					<div class="talep_detay_3">
						<cfsavecontent variable="message"><cf_get_lang_main no="49.Kaydet"></cfsavecontent>
						<input class="btn_1" type="submit" onclick="return kontrol()" value="<cfoutput>#message#</cfoutput>" />
					</div>
				</cfform>
			</div>
			<div class="talep_detay_4 gizle" id="partners">
				<div class="td_kutu">
					<div style="float:right;">
						<a class="dashboard_162_calisan" href="add_partner"><font color="FFFFFF"><span><samp><cf_get_lang no='3.Çalışan Ekle'></samp></span></font></a>
					</div>
					<div class="td_kutu_2">
						<div class="talep_detay_41">
							<div class="sirketp_211">
								<div class="sirketp_213" style="width:40px;"><cf_get_lang_main no='344.Durumu'></div>
								<div class="sirketp_213" style="width:160px;"><cf_get_lang_main no='485.Adı'><cf_get_lang_main no='1138.Soyadi'></div>
								<div class="sirketp_213" style="width:180px;"><cf_get_lang_main no='41.Sube'></div>
								<div class="sirketp_213" style="width:180px;"><cf_get_lang_main no='161.Görev/Pozisyon'></div>
								<div class="sirketp_213" style="width:190px;"><cf_get_lang_main no='159.Unvan'></div>
								<div class="sirketp_214" style="width:70px;"><cf_get_lang_main no='731.İletişim'></div>
								<div class="sirketp_213"></div>
							</div>
							<cfoutput query="getPartner">
							<div <cfif (currentrow mod 2) eq 0>class="sirketp_211"<cfelse>class="sirketp_212"</cfif>>
								<div class="sirketp_213" style="width:50px;"><cfif getPartner.company_partner_status eq 1><cf_get_lang_main no='81.Aktif'><cfelse><font color="999999"><cf_get_lang_main no='82.Pasif'></font></cfif></div>
								<div class="sirketp_213" style="width:160px;"><a href="#request.self#?fuseaction=worknet.detail_partner&pid=#partner_id#">#getPartner.company_partner_name# #getPartner.company_partner_surname#</a></div>
								<div class="sirketp_213" style="width:170px;">
									<cfif (getPartner.compbranch_id eq 0) or not len(getPartner.compbranch_id)>
									   <cf_get_lang no='181.Merkez Ofis'>
									<cfelse>
										#compbranch__name#
									</cfif>
								</div>
								<div class="sirketp_213" style="width:190px;">#PARTNER_POSITION#</div>
								<div class="sirketp_213" style="width:190px;">#title#</div>
								<div class="sirketp_214" style="width:70px;">
									<img src="../documents/templates/worknet/tasarim/sirketp_213_icon_2.png" width="16" height="16" alt="İcon" title="#company_partner_telcode# #company_partner_tel#" />
									<img src="../documents/templates/worknet/tasarim/sirketp_213_icon_3.png" width="16" height="16" alt="İcon" title="#company_partner_telcode# #company_partner_fax#" />
                                    <a href="#request.self#?fuseaction=worknet.sent_message&member_id=#partner_id#"><img src="../documents/templates/worknet/tasarim/sirketp_213_icon_1.png" width="16" height="16" title="<cf_get_lang_main no='1899.Mesaj Gönder'>"/></a>
								</div>
								<div class="sirketp_213" style="float:right; width:30px;">
									<a href="#request.self#?fuseaction=worknet.detail_partner&pid=#partner_id#"><img src="../documents/templates/worknet/tasarim/icon_6.png"  title="<cf_get_lang_main no='1306.Düzenle'>" /></a>
								</div>
							</div>
						</cfoutput>
						</div>
					</div>
				</div>
			</div>
			<div class="talep_detay_4 gizle" id="branchs">
				<div class="td_kutu">
					<div style="float:right;">
						<a class="dashboard_162_sube" href="add_branch"><font color="FFFFFF"><span><samp><cf_get_lang_main no='41.Sube'><cf_get_lang_main no='170.Ekle'></samp></span></font></a>
					</div>
					<div class="td_kutu_2">
						<div class="talep_detay_41">
							<div class="sirketp_211">
								<div class="sirketp_213"><cf_get_lang_main no='41.Sube'></div>
								<div class="sirketp_216" style="width:525px;"><cf_get_lang_main no='1311.Adres'></div>
								<div class="sirketp_214" style="width:100px;"><cf_get_lang_main no='731.İletişim'></div>
							</div>
							<cfif getCompanyBranch.recordcount>
								<cfoutput query="getCompanyBranch">
									<div <cfif (currentrow mod 2) eq 0>class="sirketp_211"<cfelse>class="sirketp_212"</cfif>>
										<div class="sirketp_213">
										<cfif len(coordinate_1) and len(coordinate_2)>
											<a href="javascript://" ><img src="/images/branch.gif" border="0" title="Haritada Göster" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_view_map&coordinate_1=#coordinate_1#&coordinate_2=#coordinate_2#&title=#compbranch__name#</cfoutput>','list','popup_view_map')" align="absmiddle"></a>
										</cfif>
										<a href="#request.self#?fuseaction=worknet.detail_branch&brid=#compbranch_id#&cpid=#session.pp.company_id#">#getCompanyBranch.COMPBRANCH__NAME#</a></div>
										<div class="sirketp_216" style="width:545px;">#getCompanyBranch.COMPBRANCH_ADDRESS# &nbsp; #getCompanyBranch.COMPBRANCH_POSTCODE# &nbsp;#getCompanyBranch.COUNTY_NAME# - #getCompanyBranch.city_name# - #getCompanyBranch.COUNTRY_NAME#</div>
										<div class="sirketp_214" style="width:100px;">
											<cfif len(getCompanyBranch.COMPBRANCH_TEL1)>#getCompanyBranch.COMPBRANCH_TELCODE# #getCompanyBranch.COMPBRANCH_TEL1#</cfif>
										</div>
										<div class="sirketp_213" style="float:right; width:35px;">
											<a href="#request.self#?fuseaction=worknet.detail_branch&brid=#compbranch_id#&cpid=#session.pp.company_id#"><img src="../documents/templates/worknet/tasarim/icon_6.png"  title="<cf_get_lang_main no='1306.Düzenle'>" /></a>
										</div>
									</div>
								</cfoutput>
							<cfelse>
								<div class="sirketp_212">
									<span style="padding-top:5px; padding-left:5px;"><b><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</b></span>
								</div>
							</cfif>
						</div>
					</div>
				</div>
			</div>
			<div class="talep_detay_4 gizle" id="asets">
				<div class="td_kutu">
					<div style="float:right; margin-right:10px;">
						<cfoutput>
							<a class="dashboard_162_calisan" href="javascript://" onclick="AjaxPageLoad('#request.self#?fuseaction=worknet.form_relation_asset&action_id=#session.pp.company_id#&action_section=COMPANY_ID&asset_cat_id=-9','body_relation_assets',0,'Loading..')">
								<span><samp><font color="FFFFFF"><cf_get_lang_main no='54.Belge Ekle'></font></samp></span>
							</a>
						</cfoutput>
					</div>
					<div class="td_kutu_2" style="width:700px;">
						<cf_box id="relation_assets" title=" " closable="0" collapsable="0" refresh="0" style="width:98%;" box_page="#request.self#?fuseaction=worknet.emptypopup_list_relation_asset&action_id=#session.pp.company_id#&action_section=COMPANY_ID&asset_cat_id=-9"></cf_box>
					</div>
				</div>
			</div>
			<div class="talep_detay_4 gizle" id="company_brands">
				<div class="td_kutu">
					<div style="float:right; margin-right:10px;">
						<cfoutput>
							<a class="dashboard_162_calisan" href="javascript://" onclick="AjaxPageLoad('#request.self#?fuseaction=worknet.form_brands&cpid=#session.pp.company_id#','body_brands',0,'Loading..')">
								<span><samp><font color="FFFFFF"><cf_get_lang no='27.Marka Ekle'></font></samp></span>
							</a>
						</cfoutput>
					</div>
					<div class="td_kutu_2" style="width:700px;">
						<cf_box id="brands" title=" " closable="0"  collapsable="0" refresh="0"  style="width:98%;" box_page="#request.self#?fuseaction=worknet.emptypopup_list_brands&cpid=#session.pp.company_id#"></cf_box>
					</div>
				</div>
			</div>
        </div>
	<script type="text/javascript">
	function remove_field(field_option_name)
	{
		field_option_name_value = document.getElementById(field_option_name);
		for (i=field_option_name_value.options.length-1;i>-1;i--)
		{
			if (field_option_name_value.options[i].selected==true)
			{
				field_option_name_value.options.remove(i);
			}	
		}
	}
	function select_all(selected_field)
	{
		var m = eval("document.form_upd_company." + selected_field + ".length");
		for(i=0;i<m;i++)
		{
			eval("document.form_upd_company."+selected_field+"["+i+"].selected=true");
		}
	}
	function LoadPhone(x)
	{
		if(x != '')
		{
			get_phone_no = wrk_safe_query("mr_get_phone_no","dsn",0,x);
	
			if(get_phone_no.COUNTRY_PHONE_CODE != undefined && get_phone_no.COUNTRY_PHONE_CODE != '')
				document.getElementById('load_phone').innerHTML = '(' + get_phone_no.COUNTRY_PHONE_CODE + ')';
			else
				document.getElementById('load_phone').innerHTML = '';
		}
		else
			document.getElementById('load_phone').innerHTML = '';
	}
	function kontrol()
	{
		select_all('product_category');
		if(document.getElementById('fullname').value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='159.Ünvan'>!");
			document.getElementById('fullname').focus();
			document.getElementById('fullname').style.backgroundColor = '#FF6600';
			return false;
		}
		else document.getElementById('fullname').style.backgroundColor = '';
		
		if(document.getElementById('nickname').value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='339.kisa Ad'>!");
			document.getElementById('nickname').focus();
			document.getElementById('nickname').style.backgroundColor = '#FF6600';
			return false;
		}
		else document.getElementById('nickname').style.backgroundColor = '';
		
		x = document.getElementById('companycat_id').selectedIndex;
		if (document.form_upd_company.companycat_id[x].value == "")
		{ 
			alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='131.Sirket Kategorisi '>!");
			document.getElementById('companycat_id').focus();
			return false;
		}
		if (document.getElementById('manager_partner_id').value == "")
		{ 
			alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1714.Yönetici'>!");
			return false;
		}
		/*if(document.getElementById('taxoffice').value == '' )
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'> : <cf_get_lang_main no='1350.Vergi Dairesi'> !");
			document.getElementById('taxoffice').focus();
			return false;
		}*/
		if(document.getElementById('taxno').value == '' )
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'> : <cf_get_lang_main no='340.Vergi No'> / <cf_get_lang_main no='613.TC Kimlik No'> !");
			document.getElementById('taxno').focus();
			return false;
		}
		else if(document.getElementById('companycat_id').value == 4 && document.getElementById('country').value == 1 && (document.getElementById('taxno').value.length > 11 || document.getElementById('taxno').value.length < 11))
		{
			alert("Vergi no 11 hane olmalıdır!");
			document.getElementById('taxno').focus();
			return false;
		}
		else if(document.getElementById('companycat_id').value != 4 && document.getElementById('country').value == 1 && (document.getElementById('taxno').value.length > 10 || document.getElementById('taxno').value.length < 10))
		{
			alert("Vergi no 10 hane olmalıdır!");
			document.getElementById('taxno').focus();
			return false;
		}
		else if(document.getElementById('country').value != 1 && document.getElementById('taxno').value.length > 40)
		{
			alert("Vergi no Maksimum karakter sayısı 40 hane olmalıdır!");
			document.getElementById('taxno').focus();
			return false;
		}
		/*if(document.getElementById('product_category').value == '' )
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='155.Ürün Kategorileri'>!");
			document.getElementById('product_category').focus();
			return false;
		}
		if (document.getElementById('firm_type').value == "")
		{ 
			alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='8.Firma Tipi'>!");
			return false;
		}*/

		if (document.getElementById('country').value == "")
		{ 
			alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>: <cf_get_lang_main no='807.Ulke'> !");
			document.getElementById('country').focus();
			return false;
		}
		if (document.getElementById('city_id').value == "" && document.getElementById('country').value == 1)
		{ 
			alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>: <cf_get_lang_main no='559.Sehir'> !");
			document.getElementById('city_id').focus();
			return false;
		}
		if (document.getElementById('county_id').value == "" && document.getElementById('country').value == 1)
		{ 
			alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>: <cf_get_lang_main no='1226.İlçe'> !");
			document.getElementById('county_id').focus();
			return false;
		}
		if (document.getElementById('company_address').value == "")
		{ 
			alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>: <cf_get_lang_main no='1311.Adres'> !");
			document.getElementById('adres').focus();
			return false;
		}
		if(document.getElementById('company_telcode').value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='178.Telefon Kodu'> !");
			document.getElementById('company_telcode').focus();
			document.getElementById('company_telcode').style.backgroundColor = '#FF6600';
			return false;
		} else document.getElementById('company_telcode').style.backgroundColor = '';
		
		if(document.getElementById('company_tel1').value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='87.Telefon'> !");
			document.getElementById('company_tel1').focus();
			document.getElementById('company_tel1').style.backgroundColor = '#FF6600';
			return false;
		} else document.getElementById('company_tel1').style.backgroundColor = '';
		
		if(process_cat_control())
			if(confirm("<cf_get_lang no='175.Girdiğiniz bilgileri kaydetmek üzeresiniz lütfen değişiklikleri onaylayın'>!")); else return false;
		else
			return false;
	}
	
	function counter(id1,id2)
	 { 
		if (document.getElementById(id1).value.length > 1500) 
		  {
				document.getElementById(id1).value = document.getElementById(id1).value.substring(0, 1500);
				alert("<cf_get_lang_main no='1324.Maksimum Mesaj Karekteri'>: 1500");  
		   }
		else 
			document.getElementById(id2).value = 1500 - (document.getElementById(id1).value.length); 
	 } 
	counter('company_detail','detailLen');
	counter('company_detail_eng','detailLen_eng');
	counter('company_detail_spa','detailLen_spa');
	
	document.getElementById('fullname').focus();
	</script>
	<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
	<cfelse>
		<cfinclude template="hata.cfm">
	</cfif>
<cfelseif isdefined("session.ww.userid")>
	<script>
		alert('Bu sayfaya erişmek için firma çalışanı olarak giriş yapmanız gerekmektedir!');
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cfinclude template="member_login.cfm">
</cfif>
