<div class="row">
	<div class="col col-12 uniqueRow" id="content">
		<cfform name="form_upd_company" method="post" enctype="multipart/form-data">
			<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#getCompany.company_id#</cfoutput>">

			<div class="portBox portBottom">
				<div class="portHeadLight font-green-sharp">
					<span><cf_get_lang_main no='162.Şirket'></span>
				</div>
				<div class="portBoxBodyStandart">
					<div class="col col-12 uniqueRow">
						<div class="row formContent">
							<div class="row" type="row">
								<div class="col col-1 col-md-1 col-sm-1 col-xs-12" type="column" index="1" sort="true">
									<div class="form-group" id="item-is_status">
										<label>
											<input type="checkbox" name="is_status" id="is_status" value="1" <cfif getCompany.company_status is 1>checked</cfif>><cf_get_lang_main no='81.Aktif'>
										</label>
									</div>
								</div>
								<div class="col col-1 col-md-1 col-sm-1 col-xs-12" type="column" index="2" sort="true">
									<div class="form-group" id="item-is_potential">
										<label>
											<input type="checkbox" name="is_potential" id="is_potential" value="1" <cfif getCompany.ispotantial is 1>checked</cfif>><cf_get_lang_main no='165.Potansiyel'>
										</label>
									</div>
								</div>
								<div class="col col-1 col-md-1 col-sm-1 col-xs-12" type="column" index="3" sort="true">
									<div class="form-group" id="item-is_related_company">
										<input type="checkbox" name="is_related_company" id="is_related_company" value="1" <cfif getCompany.is_related_company is 1>checked</cfif>><cf_get_lang no='421.Bağlı Üye'>
									</div>
								</div>
								<div class="col col-1 col-md-1 col-sm-1 col-xs-12" type="column" index="4" sort="true">
									<div class="form-group" id="item-is_homepage">
										<input type="checkbox" name="is_homepage" id="is_homepage" value="1" <cfif getCompany.is_homepage is 1>checked</cfif>><cf_get_lang no="182.Anasayfa">	
									</div>
								</div>
							</div>
							<div class="row" type="row">
								<div class="col col-12 uniqueRow">
									<div class="row formContent">
										<div class="row" type="row">
											<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="5" sort="true">
												<div class="form-group" id="item-fullname">
													<label class="col col-4 col-xs-12"><cf_get_lang_main no='159.Unvan'>*</label>
													<div class="col col-8 col-xs-12">
														<input type="text" name="fullname" id="fullname" value="<cfoutput>#getCompany.fullname#</cfoutput>" maxlength="250" style="width:455px;">
													</div>
												</div>
												<div class="form-group" id="item-process_cat">
													<label class="col col-4 col-xs-12"><cf_get_lang_main no="1447.Süreç">*</label>
													<div class="col col-8 col-xs-12">
														<cf_workcube_process is_upd='0' select_value = '#getCompany.company_state#' process_cat_width='150' is_detail='1'>
													</div>
												</div>
												<div class="form-group" id="item-sector_cat">
													<label class="col col-4 col-xs-12"><cf_get_lang_main no='167.Sektör'></label>
													<div class="col col-8 col-xs-12">
														<cfsavecontent variable="text"><cf_get_lang_main no='322.Seçiniz'></cfsavecontent>
														<cf_wrk_selectlang 
															name="company_sector"
															option_name="sector_cat"
															option_value="sector_cat_id"
															width="150"
															table_name="SETUP_SECTOR_CATS"
															option_text="#text#" value=#getCompany.SECTOR_CAT_ID#>
													</div>
												</div>
											</div>
											<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="6" sort="true">
												<div class="form-group" id="item-nickname">
													<label class="col col-4 col-xs-12"><cf_get_lang_main no='339.Kisa Ad'>*</label>
													<div class="col col-8 col-xs-12">
														<input type="text" name="nickname" id="nickname" value="<cfoutput>#getCompany.nickname#</cfoutput>" maxlength="150" style="width:150px;">
													</div>
												</div>
												<div class="form-group" id="item-firm_type">
													<label class="col col-4 col-xs-12"><cf_get_lang no="8.Firma Tipi"></label>
													<div class="col col-8 col-xs-12">
														<cf_multiselect_check 
															table_name="SETUP_FIRM_TYPE"  
															name="firm_type"
															width="150" 
															option_name="firm_type" 
															option_value="firm_type_id" value="#getCompany.firm_type#">
													</div>
												</div>
												<div class="form-group" id="item-manager_partner_id">
													<label class="col col-4 col-xs-12"><cf_get_lang_main no='1714.Yönetici'> *</label>
													<div class="col col-8 col-xs-12">
														<select name="manager_partner_id" id="manager_partner_id" style="width:150px;">
															<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
															<cfoutput query="getPartner">
																<option value="#getPartner.partner_id#" <cfif getPartner.partner_id is getCompany.manager_partner_id>selected</cfif>>#getPartner.company_partner_name# #getPartner.company_partner_surname#</option>
															</cfoutput>
														</select>
													</div>
												</div>
											</div>
											<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="7" sort="true">
												<div class="form-group" id="item-companycat_id">
													<label class="col col-4 col-xs-12"><cf_get_lang_main no='74.Kategori'>*</label>
													<div class="col col-8 col-xs-12">
														<cfsavecontent variable="text"><cf_get_lang_main no='322.Seciniz'></cfsavecontent>
														<cf_wrk_MemberCat
															name="companycat_id"
															option_text="#text#"
															comp_cons=1 value="#getCompany.COMPANYCAT_ID#">
													</div>
												</div>
												<div class="form-group" id="item-taxoffice">
													<label class="col col-4 col-xs-12"><cf_get_lang_main no='1350.Vergi Dairesi'></label>
													<div class="col col-8 col-xs-12">
														<input type="text" name="taxoffice" id="taxoffice" maxlength="30" value="<cfoutput>#getCompany.TAXOFFICE#</cfoutput>" style="width:150px;">
													</div>
												</div>
											</div>
											<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="8" sort="true">
												<div class="form-group" id="item-sort">
													<label class="col col-4 col-xs-12"><cf_get_lang_main no="1512.Sıralama"></label>
													<div class="col col-8 col-xs-12">
														<input type="text" name="sort" id="sort" value="<cfoutput>#getCompany.sort#</cfoutput>" style="width:30px;" maxlength="2" onKeyup="isNumber(this);" onblur="isNumber(this);"/>
													</div>
												</div>
												<div class="form-group" id="item-taxno">
													<label class="col col-4 col-xs-12"><cf_get_lang_main no='340.Vergi No'></label>
													<div class="col col-8 col-xs-12">
														<input type="text" name="taxno" id="taxno" onKeyup="isNumber(this);" onBlur="isNumber(this);" value="<cfoutput>#getCompany.TAXNO#</cfoutput>" maxlength="12" style="width:150px;">
													</div>
												</div>
											</div>
										</div>
										<div class="row" type="row">
											<div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="9" sort="true">
												<div class="form-group" id="item-product_category">
													<label class="col col-2 col-xs-12"><cf_get_lang_main no='155.Ürün Kategorileri'></label>
													<div class="col col-10 col-xs-12">
														<select name="product_category" id="product_category" style="width:450px; height:80px;" multiple>
															<cfif getProductCat.recordcount>
																<cfoutput query="getProductCat">
																	<cfset hierarchy_ = "">
																	<cfset new_name = "">
																	<cfloop list="#HIERARCHY#" delimiters="." index="hi">
																		<cfset hierarchy_ = ListAppend(hierarchy_,hi,'.')>
																		<cfquery name="getCat" datasource="#dsn1#">
																			SELECT PRODUCT_CAT FROM PRODUCT_CAT WHERE HIERARCHY = '#hierarchy_#'
																		</cfquery>
																		<cfset new_name = ListAppend(new_name,getCat.PRODUCT_CAT,'>')>
																	</cfloop>
																	<option value="#product_catid#">#new_name#</option>
																</cfoutput>
															</cfif>
														</select>
														<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.popup_list_product_categories&field_name=document.form_upd_company.product_category','medium');"><img src="/images/plus_list.gif" border="0" align="top" title="<cf_get_lang_main no='170.Ekle'>"></a>
														<a href="javascript://" onClick="remove_field('product_category');"><img src="/images/delete_list.gif" border="0" style="cursor=hand" align="top" title="<cf_get_lang_main no='51.Sil'>"></a>
													</div>
												</div>
											</div>
											<div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="10" sort="true">							
												<div class="form-group">
													<label class="col col-2 col-xs-12">Ek Bilgi</label>
													<div class="col col-10 col-xs-12">
														<cf_wrk_add_info info_type_id="-1" info_id="#attributes.cpid#" upd_page = "1" colspan="9">
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="portBox portBottom">
				<div class="portHeadLight font-green-sharp">
					<span><cf_get_lang no='265.Adres ve Iletisim'></span>
				</div>
				<div class="portBoxBodyStandart">
					<div class="col col-12 uniqueRow">
						<div class="row formContent">
							<div class="row" type="row">
								<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="11" sort="true">
									<div class="form-group" id="item-country">
										<label class="col col-4 col-xs-12"><cf_get_lang_main no='807.Ulke'></label>
										<div class="col col-8 col-xs-12">
											<select name="country" id="country" style="width:155px;" onChange="LoadCity(this.value,'city_id','county_id',0);LoadPhone(this.value);">
												<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
												<cfoutput query="getCountry">
													<option value="#country_id#" <cfif getCompany.country eq country_id>selected</cfif>>#country_name#</option>
												</cfoutput>
											</select>
										</div>
									</div>
									<div class="form-group" id="item-company_postcode">
										<label class="col col-4 col-xs-12"><cf_get_lang_main no='60.Posta Kodu'></label>
										<div class="col col-8 col-xs-12">
											<input type="text" name="company_postcode" id="company_postcode" style="width:150px;" maxlength="10" value="<cfoutput>#getCompany.company_postcode#</cfoutput>">
										</div>
									</div>
									<div class="form-group" id="item-company_tel1">
										<label class="col col-4 col-xs-12"><cf_get_lang no='36.Kod/Telefon'>*</label>
										<div class="col col-3">
											<input maxlength="5" type="text" name="company_telcode" id="company_telcode" onKeyup="isNumber(this);" onBlur="isNumber(this);" value="<cfoutput>#getCompany.COMPANY_TELCODE#</cfoutput>" style="width:50px;">
										</div>
										<div class="col col-5">
											<input maxlength="10" type="text" name="company_tel1" id="company_tel1" onKeyup="isNumber(this);" onBlur="isNumber(this);" value="<cfoutput>#getCompany.COMPANY_TEL1#</cfoutput>" style="width:85px;">
										</div>
									</div>
									<div class="form-group" id="item-ASSET2">
										<label class="col col-4 col-xs-12"><cf_get_lang no='428.Kroki'></label>
										<div class="col col-8 col-xs-12">
											<input type="FILE" style="width:150px;" name="ASSET2" id="ASSET2">
										</div>
										<cfif len(getCompany.asset_file_name2)>
											<label class="col col-4 col-xs-12"><cf_get_lang no='428.Kroki'> <cf_get_lang_main no='51.Sil'></label>
											<div class="col col-8 col-xs-12">
												<cf_get_server_file output_file="member/#getCompany.asset_file_name2#" output_server="#getCompany.asset_file_name2_server_id#" output_type="2" small_image="/images/branch_plus.gif" image_link="1">
												<input type="checkbox" name="del_asset2" id="del_asset2" value="1">
											</div>
										</cfif>
									</div>
								</div>
								<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="12" sort="true">
									<div class="form-group" id="item-city_id">
										<label class="col col-4 col-xs-12"><cf_get_lang_main no='559.Sehir'></label>
										<div class="col col-8 col-xs-12">
											<cfquery name="get_city" datasource="#dsn#">
												SELECT CITY_ID,CITY_NAME FROM SETUP_CITY <cfif len(getCompany.country)>WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getCompany.country#"></cfif>
											</cfquery>
											<select name="city_id" id="city_id" style="width:155px;" onChange="LoadCounty(this.value,'county_id','company_telcode')">
												<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
												<cfoutput query="get_city">
													<option value="#city_id#" <cfif getCompany.city eq city_id>selected</cfif>>#city_name#</option>
												</cfoutput>
											</select>
										</div>
									</div>
									<div class="form-group" id="item-email">
										<label class="col col-4 col-xs-12"><cf_get_lang_main no='16.e-mail'></label>
										<div class="col col-8 col-xs-12">
											<cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='16.E-mail'></cfsavecontent>
											<cfinput type="text" name="email" id="email" validate="email" message="#message#" maxlength="100" style="width:150px;" value="#getCompany.company_email#">
										</div>
									</div>
									<div class="form-group" id="item-company_tel2">
										<label class="col col-4 col-xs-12"><cf_get_lang_main no='87.Telefon'> 2</label>
										<div class="col col-8 col-xs-12">
											<input validate="integer" maxlength="10" type="text" name="company_tel2" id="company_tel2" onKeyup="isNumber(this);" onBlur="isNumber(this);" value="<cfoutput>#getCompany.COMPANY_TEL2#</cfoutput>" style="width:90px;">
										</div>
									</div>
									<div class="form-group" id="item-coordinate_1">
										<label class="col col-4 col-xs-12"><cf_get_lang_main no='1137.Koordinatlar'></label>
										<div class="col col-4">
											<div class="input-group">
												<div class="input-group-addon">
													<cf_get_lang_main no='1141.E'>
												</div>
												<cfinput type="text" maxlength="10" range="-90,90" tabindex="35" message="Lütfen enlem değerini -90 ile 90 arasında giriniz!" value="#getCompany.coordinate_1#" name="coordinate_1" id="coordinate_1" style="width:56px;"> 
											</div>
										</div>
										<div class="col col-4">
											<div class="input-group">
												<div class="input-group-addon">
													<cf_get_lang_main no='1179.B'>
												</div>
												<cfinput type="text" maxlength="10" range="-180,180" tabindex="36" message="Lütfen boylam değerini -180 ile 180 arasında giriniz!" value="#getCompany.coordinate_2#" name="coordinate_2" id="coordinate_2" style="width:56px;">
											</div>
										</div>
										<div class="col col-8 offset-4">
											<cfif len(getCompany.coordinate_1) and len(getCompany.coordinate_2)>
												<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_view_map&coordinate_1=#getCompany.coordinate_1#&coordinate_2=#getCompany.coordinate_2#&title=#getCompany.fullname#</cfoutput>','list','popup_view_map')"><img src="/images/gmaps.gif" border="0" title="Haritada Göster" align="absbottom"></a>
											</cfif>
										</div>
									</div>
								</div>
								<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="12" sort="true">
									<div class="form-group" id="item-county_id">
										<label class="col col-4 col-xs-12"><cf_get_lang_main no='1226.Ilce'></label>
										<div class="col col-8 col-xs-12">
											<select name="county_id" id="county_id" style="width:155px;">
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
										</div>
									</div>
									<div class="form-group" id="item-homepage">
										<label class="col col-4 col-xs-12"><cf_get_lang no='41.Internet'></label>
										<div class="col col-8 col-xs-12">
											<input type="text" name="homepage" id="homepage" style="width:150px;" maxlength="50" value="<cfoutput>#getCompany.homepage#</cfoutput>">
										</div>
									</div>
									<div class="form-group">
										<label class="col col-4 col-xs-12"><cf_get_lang_main no='87.Telefon'>3</label>
										<div class="col col-8 col-xs-12">
											<input maxlength="10" type="text" name="company_tel3" id="company_tel3" onKeyup="isNumber(this);" onBlur="isNumber(this);" value="<cfoutput>#getCompany.COMPANY_TEL3#</cfoutput>" style="width:90px;">
										</div>
									</div>
								</div>
								<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="13" sort="true">
									<div class="form-group" id="item-semt">
										<label class="col col-4 col-xs-12"><cf_get_lang_main no='720.Semt'></label>
										<div class="col col-8 col-xs-12">
											<input type="text" name="semt" id="semt" value="<cfoutput>#getCompany.semt#</cfoutput>" maxlength="30" style="width:150px;">
										</div>
									</div>
									<div class="form-group" id="item-mobiltel">
										<label class="col col-4 col-xs-12"><cf_get_lang no='116.Kod / Mobil'></label>
										<div class="col col-3">
											<input maxlength="5" type="text" name="mobilcat_id" id="mobilcat_id" onKeyup="isNumber(this);" onblur="isNumber(this);" value="<cfoutput>#getCompany.mobil_code#</cfoutput>" style="width:50px;">
										</div>
										<div class="col col-5">
											<cfinput type="text" name="mobiltel" id="mobiltel" maxlength="10" onKeyup="isNumber(this);" onblur="isNumber(this);" style="width:85px;" value="#getCompany.mobiltel#">
										</div>
									</div>
									<div class="form-group" id="item-company_fax">
										<label class="col col-4 col-xs-12"><cf_get_lang_main no='76.Fax'></label>
										<div class="col col-8 col-xs-12">
											<input type="text" name="company_fax" id="company_fax" onKeyup="isNumber(this);" onblur="isNumber(this);" value="<cfoutput>#getCompany.company_fax#</cfoutput>" maxlength="10" style="width:90px;">
										</div>
									</div>
								</div>
							</div>
							<div class="row" type="row">
								<div class="col col-6 col-xs-12" type="column" index="14" sort="true">
									<div class="form-group">
										<label class="col col-2 col-xs-12"><cf_get_lang_main no='1311.Adres'></label>
										<div class="col col-10 col-xs-12">
											<cfsavecontent variable="message"><cf_get_lang no ='611.Adres Uzunluğu 200 Karakteri Geçemez'></cfsavecontent>
											<textarea name="company_address" id="company_address" style="width:150px; height:65px;" message="<cfoutput>#message#</cfoutput>" maxlength="200" onKeyUp="return ismaxlength(this);" onBlur="return ismaxlength(this);"><cfoutput>#getCompany.COMPANY_ADDRESS#</cfoutput></textarea>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="portBox portBottom">
				<div class="portHeadLight font-green-sharp">
					<span>Finansal Bilgiler</span>
				</div>
				<div class="portBoxBodyStandart">
					<div class="col col-12 uniqueRow">
						<div class="row formContent">
							<div class="row" type="row">
								<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="15" sort="true">
									<div class="form-group" id="item-annual_customer_value">
										<label class="col col-4 col-xs-12"><cf_get_lang no="183.Yıllık Satış Cirosu"></label>
										<div class="col col-8 col-xs-12">
											<cf_wrk_selectlang
												name="annual_customer_value"
												table_name="SETUP_CUSTOMER_VALUE"
												option_name="CUSTOMER_VALUE"
												option_value="CUSTOMER_VALUE_ID"
												sort_type="CUSTOMER_SALE_START,CUSTOMER_VALUE"
												value="#getCompany.COMPANY_VALUE_ID#"
												width="150">
										</div>
									</div>
								</div>
								<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="16" sort="true">
									<div class="form-group" id="item-domestic_customer_value">
										<label class="col col-4 col-xs-12"><cf_get_lang no="184.Yurtiçi Satış Cirosu"></label>
										<div class="col col-8 col-xs-12">
											<cf_wrk_selectlang
												name="domestic_customer_value"
												table_name="SETUP_CUSTOMER_VALUE"
												option_name="CUSTOMER_VALUE"
												option_value="CUSTOMER_VALUE_ID"
												value="#getCompany.DOMESTIC_VALUE_ID#"
												sort_type="CUSTOMER_SALE_START,CUSTOMER_VALUE"
												width="150">
										</div>
									</div>
								</div>
								<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="17" sort="true">
									<div class="form-group" id="item-export_customer_value">
										<label class="col col-4 col-xs-12"><cf_get_lang no="185.Yurtdışı Satış Cirosu"></label>
										<div class="col col-8 col-xs-12">
											<cf_wrk_selectlang
												name="export_customer_value"
												table_name="SETUP_CUSTOMER_VALUE"
												option_name="CUSTOMER_VALUE"
												option_value="CUSTOMER_VALUE_ID"
												value="#getCompany.EXPORT_VALUE_ID#"
												sort_type="CUSTOMER_SALE_START,CUSTOMER_VALUE"
												width="150">
										</div>
									</div>
								</div>
								<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="18" sort="true">
									<div class="form-group" id="item-">
										<label class="col col-4 col-xs-12"><cf_get_lang no='32.Şirket Büyüklüğü'></label>
										<div class="col col-8 col-xs-12">
											<cf_wrk_selectlang
												name="company_size_cat_id"
												table_name="SETUP_COMPANY_SIZE_CATS"
												option_name="company_size_cat"
												option_value="company_size_cat_id"
												value="#getCompany.company_size_cat_id#"
												sort_type="COMPANY_SIZE_CAT"
												width="150">
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="portBox portBottom">
				<div class="portHeadLight font-green-sharp">
					<span><cf_get_lang no="11.Profil Bilgileri"></span>
				</div>
				<div class="portBoxBodyStandart">
					<div class="col col-12 uniqueRow">
						<div class="row formContent">
							<div class="row" type="row">
								<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="19" sort="true">
									<div class="form-group" id="item-organization_start_date">
										<label class="col col-4 col-xs-12"><cf_get_lang no='119.Kuruluş Tarihi'></label>
										<div class="col col-8 col-xs-12">
											<cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no='119.Kuruluş Tarihi'>!</cfsavecontent>
											<div class="input-group">
												<cfinput type="text" name="organization_start_date" id="organization_start_date" value="#dateformat(getCompany.org_start_date,'dd/mm/yyyy')#" validate="eurodate" message="#message#" style="width:65px;">
												<div class="input-group-addon"><cf_wrk_date_image date_field="organization_start_date"></div>
											</div>
										</div>
									</div>
								</div>
								<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="20" sort="true">
									<div class="form-group" id="item-ASSET1">
										<label class="col col-4 col-xs-12"><cf_get_lang_main no='1225.Logo'></label>
										<div class="col col-8 col-xs-12">
											<div class="input-group">
												<input type="file" name="ASSET1" id="ASSET1" style="width:150px;">
												<cfif len(getCompany.asset_file_name1)>
													<div class="input-group-addon">
														<cf_get_server_file output_file="member/#getCompany.asset_file_name1#" output_server="#getCompany.asset_file_name1_server_id#" output_type="2" small_image="/images/branch_plus.gif" image_link="1">
													</div>
													<div class="input-group-addon">
														<input type="checkbox" name="del_asset1" id="del_asset1" value="1"><cf_get_lang no="23.Logo Sil">
													</div>
												</cfif>
											</div>
										</div>
									</div>
								</div>
								<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="20" sort="true">
									<div class="form-group" id="item-req_type">
										<label class="col col-4 col-xs-12"><cf_get_lang_main no="1896.Sertifikalar"></label>
										<div class="col col-8 col-xs-12">
											<cf_multiselect_check 
												query_name="getReqType.query"
												name="req_type"
												width="250" 
												option_name="req_name" 
												option_value="req_id" 
												value="#getReqType.liste#">
										</div>
									</div>
								</div>
							</div>
							<div class="row" type="row">
								<div class="col col-1 col-md-1 col-sm-1 col-xs-12" type="column" index="22" sort="true">
									<div class="form-group">
										<div class="col col-12 col-xs-12">
											<img src="../documents/templates/worknet/tasarim/dil_icon_3.png" width="18" height="14" alt="TR" align="top" >
										</div>
									</div>
								</div>
								<div class="col col-1 col-md-1 col-sm-1 col-xs-12" type="column" index="23" sort="true">
									<div class="form-group">
										<div class="col col-12 col-xs-12">
											<img src="../documents/templates/worknet/tasarim/dil_icon_1.png" width="18" height="14" alt="ENG" align="top" onclick="gizle_goster_detail('profile_eng')" >
										</div>
									</div>
								</div>
								<div class="col col-1 col-md-1 col-sm-1 col-xs-12" type="column" index="24" sort="true">
									<div class="form-group">
										<div class="col col-12 col-xs-12">
											<img src="../documents/templates/worknet/tasarim/dil_icon_2.png" width="18" height="14" alt="SPA" align="top" onclick="gizle_goster_detail('profile_spa')" >
										</div>
									</div>
								</div>
							</div>
							<div class="row" type="row">
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="25" sort="true">
									<div class="form-group" id="item-company_detail">
										<label class="col col-2 col-xs-12"><cf_get_lang_main no="1708.Şirket Profili"></label>
										<div class="col col-10 col-xs-12">
											<textarea 
												name="company_detail" id="company_detail" 
												style="width:500px; height:120px;" maxlenght="1500"
												onChange="counter(this.id,'detailLen');return ismaxlength(this);"
												onkeydown="counter(this.id,'detailLen');return ismaxlength(this);" 
												onkeyup="counter(this.id,'detailLen');return ismaxlength(this);" 
												onBlur="return ismaxlength(this);"	
												><cfoutput>#getCompany.company_detail#</cfoutput></textarea>
											<input type="text" name="detailLen"  id="detailLen" size="1"  style="width:40px !important;" value="1500" readonly />
										</div>
									</div>
								</div>
							</div>
							<div class="row" type="row" id="profile_eng" style="display: none;">
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="26" sort="true">
									<div class="form-group" id="item-company_detail_eng">
										<label class="col col-2 col-xs-12"><cf_get_lang_main no="1708.Şirket Profili"> <img src="../documents/templates/worknet/tasarim/dil_icon_1.png" width="18" height="14" alt="ENG" align="top" ></label>
										<div class="col col-10 col-xs-12">
											<textarea 
												name="company_detail_eng" id="company_detail_eng" 
												style="width:500px; height:120px;" maxlenght="1500"
												onChange="counter(this.id,'detailLen_eng');return ismaxlength(this);"
												onkeydown="counter(this.id,'detailLen_eng');return ismaxlength(this);" 
												onkeyup="counter(this.id,'detailLen_eng');return ismaxlength(this);" 
												onBlur="return ismaxlength(this);"	
												><cfoutput>#getCompany.company_detail_eng#</cfoutput></textarea>
											<input type="text" name="detailLen_eng"  id="detailLen_eng" size="1"  style="width:40px !important;" value="1500" readonly />
										</div>
									</div>
								</div>						
							</div>
							<div class="row" type="row" id="profile_spa" style="display: none;">
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="27" sort="true">
									<div class="form-group">
										<label class="col col-2 col-xs-12"><cf_get_lang_main no="1708.Şirket Profili"><img src="../documents/templates/worknet/tasarim/dil_icon_2.png" width="18" height="14" alt="SPA" align="top" ></label>
										<div class="col col-10 col-xs-12">
											<textarea 
												name="company_detail_spa" id="company_detail_spa" 
												style="width:500px; height:120px;" maxlenght="1500"
												onChange="counter(this.id,'detailLen_spa');return ismaxlength(this);"
												onkeydown="counter(this.id,'detailLen_spa');return ismaxlength(this);" 
												onkeyup="counter(this.id,'detailLen_spa');return ismaxlength(this);" 
												onBlur="return ismaxlength(this);"	
												><cfoutput>#getCompany.company_detail_spa#</cfoutput></textarea>
											<input type="text" name="detailLen_spa"  id="detailLen_spa" size="1"  style="width:40px !important;" value="1500" readonly />
										</div>
									</div>
								</div>						
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col col-12 uniqueRow">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-6" type="column" index="28" sort="false">
								<div class="form-group">
									<div class="col col-12">
										<cfoutput>
											<cf_get_lang_main no='71.Kayıt'> :
											<cfif len(getCompany.record_par)>
												#get_par_info(getCompany.record_par,0,-1,0)#
											<cfelseif len(getCompany.record_emp)>
												#get_emp_info(getCompany.record_emp,0,0)#
											</cfif>
											<cfif len(getCompany.record_date)> - #dateformat(date_add('h',session.ep.time_zone,getCompany.record_date),'dd/mm/yyyy')# #timeformat(date_add('h',session.ep.time_zone,getCompany.record_date),'HH:MM')#</cfif>&nbsp;
											<cfif len(getCompany.record_ip)> - #getCompany.record_ip#</cfif>
					
											<cfif len(getCompany.update_emp) or len(getCompany.update_par)>
												<br/><cf_get_lang_main no='291.Son Güncelleme'> : 
												<cfif len(getCompany.update_emp)>
													#get_emp_info(getCompany.update_emp,0,0)#
												<cfelseif len(getCompany.update_par)>
													#get_par_info(getCompany.update_par,0,-1,0)#
												</cfif> - #dateformat(date_add('h',session.ep.time_zone,getCompany.update_date),'dd/mm/yyyy')# #timeformat(date_add('h',session.ep.time_zone,getCompany.update_date),'HH:MM')#
												<cfif len(getCompany.update_ip)> - #getCompany.update_ip#</cfif>
											</cfif>
											</cfoutput>
									</div>
								</div>
							</div>
							<div class="col col-6" type="column" index="29" sort="false">
								<div class="form-group">
									<div class="col col-12">
										<cf_workcube_buttons is_upd='0' add_function="kontrol()">
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</cfform>
	</div>
</div>