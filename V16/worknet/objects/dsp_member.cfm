<cfif isdefined('attributes.cpid') and len(attributes.cpid)>
	<cfset cmp = createObject("component","V16.worknet.query.worknet_member") />
	<cfset getCompany = cmp.getCompany(company_id:attributes.cpid) />
	<cfset getCompanyBranch = cmp.getCompanyBranch(company_id:attributes.cpid,is_active:1) />
	<cfset getPartner = cmp.getPartner(company_id:attributes.cpid) />
	<cfset getReqType = cmp.getReqType(company_id:attributes.cpid) />
	<cfset getProductCat = cmp.getProductCat(company_id:attributes.cpid) />
	<cfif len(getCompany.firm_type)>
		<cfset getFirmType = cmp.getFirmType(firm_type_id:listdeleteduplicates(getCompany.firm_type)) />
	</cfif>
	<cfset getBrand = cmp.getBrand(member_id:attributes.cpid)>
	<cfset getRelationAsset = createObject("component","V16.worknet.query.worknet_asset").getRelationAsset
		(action_id:attributes.cpid,
			action_section:'COMPANY_ID',
			asset_cat_id:-9
		) />
	<cfif getCompany.recordcount>
		<cfoutput>
		<div class="haber_liste">
			<div class="haber_liste_1">
				<div class="haber_liste_11"><h1>#left(getCompany.fullname,70)#</h1></div>
			</div>
			<div class="sirketp_1">
				<cfif isdefined('session.pp.userid')>
				<ul>
					<li><a class="view_member aktif" href="javascript:void(0);" onclick="memberTab('genel')" id="genel_tab"><cf_get_lang_main no='568.Genel Bilgiler'></a></li>
                    <li><a class="view_member" href="javascript:void(0);" onclick="memberTab('adres')" id="adres_tab"><cf_get_lang_main no='1311.Adres'><cf_get_lang_main no='577.ve'><cf_get_lang_main no='731.Iletisim'></a></li>
                    <li><a class="view_member" href="javascript:void(0);" onclick="memberTab('yonetici')" id="yonetici_tab"><cf_get_lang no='150.İlgili Kişiler'></a></li>
					<li><a class="view_member" href="javascript:void(0);" onclick="memberTab('finans')" id="finans_tab"><cf_get_lang_main no='673.Finansal Ozet'></a></li>
					<li><a class="view_member" href="javascript:void(0);" onclick="memberTab('belge')" id="belge_tab"><cf_get_lang_main no='56.Belge'></a></li>
					<li><a class="view_member" href="javascript:void(0);" onclick="memberTab('marka')" id="marka_tab"><cf_get_lang_main no='1435.Marka'></a></li>
				</ul>
				<cfelse>
				<ul>
					<li><a class="view_member aktif" href="javascript:void(0);" onclick="memberTab('genel')" id="genel_tab"><cf_get_lang_main no='568.Genel Bilgiler'></a></li>
                    <!---<li><a class="view_member" href="javascript:void(0);" onclick="memberTab('login')" id="login_tab"><cf_get_lang_main no='1311.Adres'><cf_get_lang_main no='577.ve'><cf_get_lang_main no='731.Iletisim'></a></li>--->
                    <li><a class="view_member" href="javascript:void(0);" onclick="memberTab('adres')" id="adres_tab"><cf_get_lang_main no='1311.Adres'><cf_get_lang_main no='577.ve'><cf_get_lang_main no='731.Iletisim'></a></li>
                    <li><a class="view_member" href="javascript:void(0);" onclick="memberTab('login2')" id="login2_tab"><cf_get_lang no='150.İlgili Kişiler'></a></li>
					<li><a class="view_member" href="javascript:void(0);" onclick="memberTab('login3')" id="login3_tab"><cf_get_lang_main no='673.Finansal Ozet'></a></li>
					<li><a class="view_member" href="javascript:void(0);" onclick="memberTab('login4')" id="login4_tab"><cf_get_lang_main no='56.Belge'></a></li>
					<li><a class="view_member" href="javascript:void(0);" onclick="memberTab('login5')" id="login5_tab"><cf_get_lang_main no='1435.Marka'></a></li>
				</ul>
				</cfif>
			</div>
			<div class="sirketp_2">
				<!--- genel --->
				<div class="sirketp_21" id="genel">
				    <div class="sirketp_rqkod">
						<cf_workcube_barcode show="1" type="qrcode" width="95" height="100" value="MECARD:N:#getCompany.fullname#;ADR:#getCompany.company_address# #getCompany.semt# #getCompany.company_postcode# #getCompany.COUNTY_NAME# #getCompany.CITY_NAME# #getCompany.country_name#;TEL:#getCompany.COMPANY_TELCODE# #getCompany.company_tel1#;EMAIL:#getCompany.company_email#;URL:#getCompany.homepage#;">
						<cfif isdefined('attributes.info_content_id') and len(attributes.info_content_id)>
                            <a href="javascript://" data-width="300px" style="margin:4px 25px 0px 10px;" data-text="<cfoutput>#createObject('component','worknet.objects.worknet_objects').getContent(content_id:attributes.info_content_id)#</cfoutput>" class="tooltip">
                                <img src="../documents/templates/worknet/tasarim/tooltipIcon.png" />
                            </a>
                        </cfif>
					</div>
					<div class="sirketp_211 sirketp_rq">
						<span><cf_get_lang_main no='159.Unvan'></span>
						<samp><strong>#getCompany.fullname#</strong></samp>
					</div>
					<div class="sirketp_212 sirketp_rq">
						<span><cf_get_lang_main no='166.Yetkili'> <cf_get_lang_main no='518.Kullanıcı'></span>
						<samp><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_partner&pid=#getCompany.manager_partner_id#">#getCompany.MANAGER_PARTNER#</a></samp>
					</div>
					<div class="sirketp_211 sirketp_rq">
						<span><cf_get_lang_main no='74.Kategori'></span>
						<samp>#getCompany.COMPANYCAT#</samp>
					</div>
                    <div class="sirketp_212 sirketp_rq">
                        <span><cf_get_lang no='31.Firma Tipi'></span>
                        <cfif isdefined('getFirmType') and len(getFirmType)><samp title="#getFirmType#">#getFirmType#</samp><cfelse><samp></samp></cfif>
                    </div>
					<div class="sirketp_211">
						<span><cf_get_lang_main no='167.Sektör'></span>
						<samp>#getCompany.SECTOR_CAT#</samp>
					</div>
					<div class="sirketp_212">
						<span><cf_get_lang_main no='1350.Vergi Dairesi'> / <cf_get_lang_main no='340.Vergi No'></span>
						<samp>#getCompany.TAXOFFICE# / #getCompany.TAXNO#</samp>
					</div>
					<div class="sirketp_211">
						<span><cf_get_lang_main no='1896.Sertifikalar'></span>
						<samp>#getReqType.liste_name#</samp>
					</div>
					<div class="sirketp_212" style="height:auto;">
						<span><cf_get_lang_main no='155.Ürün Kategorileri'></span>
						<div class="td_kutu_211">
							<cfif getProductCat.recordcount>
								<cfloop query="getProductCat">
									<cfset hierarchy_ = "">
									<cfset new_name = "">
									<cfloop list="#HIERARCHY#" delimiters="." index="hi">
										<cfset hierarchy_ = ListAppend(hierarchy_,hi,'.')>
										<cfset getCat = createObject("component","V16.worknet.query.worknet_product").getMainProductCat(hierarchy:hierarchy_)>
										<cfset new_name = ListAppend(new_name,getCat.PRODUCT_CAT,'>')>
									</cfloop>
									<samp><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_product&product_catid=#product_catid#&product_cat=#new_name#&company_id=#getCompany.company_id#&company_name=#getCompany.fullname#" title="#new_name#">#new_name#</a></samp>
								</cfloop>
							</cfif>
						</div>
					</div>
					<cfif len(getCompany.COMPANY_DETAIL) AND session_base.language eq "tr">
						<div>
							<span><cf_get_lang no='54.Hakkımızda'></span>
							<div class="td_kutu_211" style="width:490px;">
								#getCompany.COMPANY_DETAIL#
							</div>
						</div>
					</cfif>
                    <cfif len(getCompany.COMPANY_DETAIL_ENG) AND session_base.language eq "eng">
                    	<div>
							<span><cf_get_lang no='54.Hakkımızda'></span>
							<div class="td_kutu_211" style="width:490px;">
								#getCompany.COMPANY_DETAIL_ENG#
							</div>
						</div>
                    </cfif>
                    <cfif len(getCompany.COMPANY_DETAIL_SPA) AND session_base.language eq "spa">
                    	<div>
							<span><cf_get_lang no='54.Hakkımızda'></span>
							<div class="td_kutu_211" style="width:490px;">
								#getCompany.COMPANY_DETAIL_SPA#
							</div>
						</div>
                    </cfif>
				</div>
				<!---finans --->
				<div class="sirketp_21 gizle" id="finans">
					<div class="sirketp_211" style="width:100%;">
						<span><cf_get_lang no='151.Şirket Büyüklüğü'></span>
						<samp>#getCompany.company_size_cat#</samp>
					</div>
					<div class="sirketp_212" style="width:100%;">
						<cfset getCompanyValue = cmp.getCustomerValue(customer_value_id:getCompany.COMPANY_VALUE_ID) />
						<span><cf_get_lang_main no='1603.Yillik'><cf_get_lang no='152.Satış Cirosu'></span>
						<samp>#getCompanyValue.CUSTOMER_VALUE#</samp>
					</div>
					<div class="sirketp_211" style="width:100%;">
						<cfset getDomesticValue = cmp.getCustomerValue(customer_value_id:getCompany.DOMESTIC_VALUE_ID) />
						<span><cf_get_lang_main no='1894.Yurtiçi'><cf_get_lang no='152.Satış Cirosu'></span>
						<samp>#getDomesticValue.CUSTOMER_VALUE#</samp>
					</div>
					<div class="sirketp_212" style="width:100%;">
						<cfset getExportValue = cmp.getCustomerValue(customer_value_id:getCompany.EXPORT_VALUE_ID) />
						<span><cf_get_lang_main no='1895.Yurtdışı'><cf_get_lang no='152.Satış Cirosu'></span>
						<samp>#getExportValue.CUSTOMER_VALUE#</samp>
					</div>
				</div>
				<!--- adres --->
            	<div class="sirketp_21 gizle" id="adres">
                   <cfif len(getCompany.coordinate_1) and len(getCompany.coordinate_2)>
				    <div class="sirketp_rqkod">
                        <cf_workcube_barcode show="1" type="qrcode" width="87" height="87" value="geo:#getCompany.coordinate_1#,#getCompany.coordinate_2#">
						<cfif isdefined('attributes.info_content_id') and len(attributes.info_content_id)>
                            <a href="javascript://" data-width="300px" style="margin:4px 25px 0px 10px;" data-text="<cfoutput>#createObject('component','worknet.objects.worknet_objects').getContent(content_id:attributes.info_content_id)#</cfoutput>" class="tooltip">
                                <img src="../documents/templates/worknet/tasarim/tooltipIcon.png" />
                            </a>
                        </cfif>
					</div>
					</cfif>
                	<div class="sirketp_211 sirketp_rq">
                    	<span><cf_get_lang_main no='1311.Adres'></span>
						<samp>#getCompany.COMPANY_ADDRESS# &nbsp; #getCompany.company_postcode# &nbsp;#getCompany.COUNTY_NAME# - #getCompany.city_name#  - #getCompany.COUNTRY_NAME#
							&nbsp;&nbsp;
							<cfif len(getCompany.coordinate_1) and len(getCompany.coordinate_2)>
								<cfoutput><a href="javascript://" ><img src="documents/templates/worknet/tasarim/harita.png" border="0" title="Haritada Göster" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_view_map&coordinate_1=#getCompany.coordinate_1#&coordinate_2=#getCompany.coordinate_2#&title=#getCompany.fullname#</cfoutput>','list','popup_view_map')" align="absmiddle"></a></cfoutput> 				
							</cfif>
						</samp>
                    </div>
                	<div class="sirketp_212 sirketp_rq">
                        <span><cf_get_lang_main no='87.Telefon'></span>
						<samp>
							<cfif len(getCompany.COMPANY_TEL1)>#getCompany.COMPANY_TELCODE# #getCompany.COMPANY_TEL1#</cfif>
							<cfif len(getCompany.COMPANY_TEL2)> / #getCompany.COMPANY_TELCODE# #getCompany.COMPANY_TEL2#</cfif>
							<cfif len(getCompany.COMPANY_TEL3)> / #getCompany.COMPANY_TELCODE# #getCompany.COMPANY_TEL3#</cfif>
						</samp>
                    </div>
                	<div class="sirketp_211 sirketp_rq">
                        <span><cf_get_lang_main no='76.Fax'></span>
						<samp><cfif len(getCompany.company_fax)>#getCompany.COMPANY_TELCODE# #getCompany.company_fax#</cfif></samp>
                    </div>
                	<div class="sirketp_212">
                        <span><cf_get_lang_main no='667.İnternet'></span>
						<samp>
							<cfif len(getCompany.homepage) gt 10><a href="#getCompany.homepage#" target="_blank">#getCompany.homepage#</a><cfelse>#getCompany.homepage#</cfif>
							<!---#getCompany.homepage#--->
						</samp>
                    </div>
					<cfif len(getCompany.asset_file_name2)>
						<div class="sirketp_211">
							<span><cf_get_lang no='153.Kroki'></span>
							<samp>
								<cf_get_server_file output_file="member/#getCompany.asset_file_name2#" output_server="#getCompany.asset_file_name2_server_id#" output_type="2" small_image="/images/branch_plus.gif" image_link="1">
							</samp>
						</div>
					</cfif>
                	<cfif getCompanyBranch.recordcount>
                    	<div class="sirketp_211">
                            <span><cf_get_lang_main no='1637.Subeler'></span>
                            <samp>
                                <cfloop query="getCompanyBranch">
                                    <div class="sirketp_23">
                                        <b>#getCompanyBranch.COMPBRANCH__NAME#</b>
                                        <cfif len(getCompanyBranch.coordinate_1) and len(getCompanyBranch.coordinate_2)>
                                        <a href="javascript://" ><img src="documents/templates/worknet/tasarim/harita.png" border="0" title="Haritada Göster" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_view_map&coordinate_1=#getCompanyBranch.coordinate_1#&coordinate_2=#getCompanyBranch.coordinate_2#&title=#getCompanyBranch.compbranch__name#</cfoutput>','list','popup_view_map')" align="absmiddle"></a><br />
                                        </cfif><br />
                                        #getCompanyBranch.COMPBRANCH_ADDRESS# &nbsp; #getCompanyBranch.COMPBRANCH_POSTCODE# &nbsp;#getCompanyBranch.COUNTY_NAME# - #getCompanyBranch.city_name# - #getCompanyBranch.COUNTRY_NAME#<br />
                                        <cf_get_lang_main no='87.Tel'>:&nbsp;<cfif len(getCompanyBranch.COMPBRANCH_TEL1)>#getCompanyBranch.COMPBRANCH_TELCODE# #getCompanyBranch.COMPBRANCH_TEL1#</cfif>
											<cfif len(getCompanyBranch.COMPBRANCH_TEL2)> / #getCompanyBranch.COMPBRANCH_TELCODE# #getCompanyBranch.COMPBRANCH_TEL2#</cfif>
											<cfif len(getCompanyBranch.COMPBRANCH_TEL3)> / #getCompanyBranch.COMPBRANCH_TELCODE# #getCompanyBranch.COMPBRANCH_TEL3#</cfif><br /><br />
                                    </div>
                                </cfloop>
                            </samp>
                        </div>
                    </cfif>
                </div>
				<!--- yoneticiler --->
				<div class="sirketp_21 gizle" id="yonetici">
					<div class="sirketp_211">
						<div class="sirketp_213"><cf_get_lang_main no='219.Ad'> <cf_get_lang_main no='1314.Soyad'></div>
						<div class="sirketp_213"><cf_get_lang_main no='41.Sube'></div>
						<div class="sirketp_213"><cf_get_lang_main no='161.Görev'></div>
						<div class="sirketp_213"><cf_get_lang_main no='159.Ünvan'></div>
						<div class="sirketp_214"><cf_get_lang_main no='731.İletişim'></div>
					</div>
					<cfloop query="getPartner">
						<div <cfif (currentrow mod 2) eq 0>class="sirketp_211"<cfelse>class="sirketp_212"</cfif>>
							<div class="sirketp_213">
								<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_partner&pid=#getPartner.partner_id#" style="width:100%;font-size:12px;color:A4A4A4; text-decoration:underline;">#getPartner.company_partner_name# #getPartner.company_partner_surname#</a>
							</div>
							<div class="sirketp_213">
								<cfif (getPartner.compbranch_id eq 0) or not len(getPartner.compbranch_id)>
								   	<cf_get_lang no='143.Merkez Ofis'>
								<cfelse>
									#compbranch__name#
								</cfif>
							</div>
							<div class="sirketp_213">#PARTNER_POSITION#</div>
							<div class="sirketp_213">#title#</div>
							<div class="sirketp_214">
								<cfif not len(getPartner.workcube_id)>
									<a href="##"><img src="/documents/templates/worknet/tasarim/icon_12.png" title="Offline" /></a>
								<cfelse>
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=worknet.popup_video_conferans&targetUserID=#getPartner.workcube_id#','video_conference');"><img src="/documents/templates/worknet/tasarim/icon_11.png" title="Video Konferans" /></a>
								</cfif>
                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=worknet.popup_sent_message&member_id=#partner_id#','medium')"><img src="../documents/templates/worknet/tasarim/sirketp_213_icon_1.png" width="16" height="16"  title="<cf_get_lang_main no='1899.Mesaj Gönder'>"/></a>
								<a href="##"><img src="../documents/templates/worknet/tasarim/sirketp_213_icon_2.png" width="16" height="16" alt="İcon" title="#company_partner_telcode# #company_partner_tel#" /></a>
								<a href="##"><img src="../documents/templates/worknet/tasarim/sirketp_213_icon_3.png" width="16" height="16" alt="İcon" title="#company_partner_telcode# #company_partner_fax#" /></a>
							</div>
						</div>
					</cfloop>
				</div>
				<!--- belgeler --->
				<div class="sirketp_21 gizle" id="belge">
                    <cfif getRelationAsset.recordcount>
						<cfif use_https eq 1>
                        	<cfset http_kontrol = 'https://'>
                        <cfelse>
                        	<cfset http_kontrol = 'http://'>
                        </cfif>
						<cfloop query="getRelationAsset">
							<div class="sirketp_23">
							<div class="sirketp_231">
								<samp>
									<cfif ListLast(asset_file_name,'.') is 'flv'>
										<a href="javascript://" onClick="windowopen('index.cfm?fuseaction=objects.popup_flvplayer&video=#file_web_path##ASSETCAT_PATH#/#asset_file_name#&ext=flv&video_id=#asset_id#','video');" style="float:left;">
											#ASSET_NAME# <!---<cfif len(property_name)><font color="red">(#property_name#)</font></cfif>--->
										</a>
									<cfelse>
										<a href="javascript://" onClick="windowopen('#file_web_path##ASSETCAT_PATH#/#asset_file_name#','medium');" title="#ASSET_NAME#" style="float:left;">
											#ASSET_NAME# <!---<cfif len(property_name)><font color="red">(#property_name#)</font></cfif> --->
										</a>
									</cfif>	
								</samp>
								<samp>#asset_detail#</samp>
							</div>
							<div class="sirketp_232">
								<cfif isdefined('attributes.info_content_id') and len(attributes.info_content_id)>
                                    <a href="javascript://" data-width="300px" style="margin:4px 0px 0px 10px;" data-text="<cfoutput>#createObject('component','worknet.objects.worknet_objects').getContent(content_id:attributes.info_content_id)#</cfoutput>" class="tooltip">
                                        <img src="../documents/templates/worknet/tasarim/tooltipIcon.png" />
                                    </a>
                                </cfif>
                                <cf_workcube_barcode show="1" type="qrcode" width="110" height="110" value="URL:#http_kontrol##cgi.HTTP_HOST##file_web_path##ASSETCAT_PATH#/#asset_file_name#">
							</div>
						</div>
						</cfloop>
					<cfelse>
						<div class="sirketp_23">
							<div class="sirketp_231">
								<span><cf_get_lang_main no='72.Kayıt Yok'> !</span>
							</div>
						</div>
					</cfif>
                </div>
				<!--- markalar --->
				<div class="sirketp_21 gizle" id="marka">
                    <cfif getbrand.recordcount>
						<cfloop query="getbrand">
							<div class="sirketp_23">
								<div class="sirketp_232"><a target="_blank" href="#file_web_path#member/#brand_logo_path#">
                                	<cf_get_server_file output_file="member/#brand_logo_path#" output_server="#getbrand.BRAND_LOGO_PATH_SERVER_ID#" output_type="0" image_width="87">
                                	</a>
                                </div>
								<div class="sirketp_231">
									<samp><a target="_blank" href="#file_web_path#member/#brand_logo_path#" style="margin-left:20px;">#brand_name#</a></samp>
									<samp>#brand_detail#</samp>
								</div>
							</div>
						</cfloop>
					<cfelse>
						<div class="sirketp_23">
							<div class="sirketp_231">
								<span><cf_get_lang_main no='72.Kayıt Yok'> !</span>
							</div>
						</div>
					</cfif>
                </div>
				<!--- member_login --->
				<div class="sirketp_21 gizle" id="login">
					<div class="sirketp_211">
						<cfinclude template="member_login.cfm">
					</div>
				</div>
				<!--- member_login --->
				<div class="sirketp_21 gizle" id="login2">
					<div class="sirketp_211">
						<cfinclude template="member_login.cfm">
					</div>
				</div>
				<!--- member_login --->
				<div class="sirketp_21 gizle" id="login3">
					<div class="sirketp_211">
						<cfinclude template="member_login.cfm">
					</div>
				</div>
				<!--- member_login --->
				<div class="sirketp_21 gizle" id="login4">
					<div class="sirketp_211">
						<cfinclude template="member_login.cfm">
					</div>
				</div>
				<!--- member_login --->
				<div class="sirketp_21 gizle" id="login5">
					<div class="sirketp_211">
						<cfinclude template="member_login.cfm">
					</div>
				</div>
				<div class="sirketp_22">
					<div class="sirketp_222">
						<cfif len(getCompany.ASSET_FILE_NAME1)>
							<cf_get_server_file output_file="member/#getCompany.ASSET_FILE_NAME1#" output_server="#getCompany.ASSET_FILE_NAME1_SERVER_ID#" output_type="0" image_width="165">
						<cfelse>
							<div style="margin:0px 0px 10px 28px;"><img src="/images/no_photo.gif" /></div>
						</cfif>
					</div>
					<div class="sirketp_226"><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_demand&company_id=#attributes.cpid#&company_name=#getCompany.nickname#"><cf_get_lang no='130.Tüm Talepler'></a></div>
					<div class="sirketp_226"><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_product&company_id=#attributes.cpid#&company_name=#getCompany.nickname#"><cf_get_lang no='131.Tüm Ürünler'></a></div>
					<cfset getMemberStatus = createObject("component","worknet.objects.worknet_objects").getMemberStatus(
						member_id:getCompany.company_id,
						member_type:'company'
					)>
					<cfif getMemberStatus eq false>
						<div class="sirketp_223_of"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=worknet.popup_sent_message&member_id=#getCompany.manager_partner_id#','medium')"><cf_get_lang no='142.Offline'></a></div>
					<cfelse>
						<cfif isdefined('session.pp') and session.pp.company_id neq attributes.cpid>
							<div class="sirketp_223"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=worknet.popup_video_conferans&targetUserID=#getMemberStatus#','video_conference');"><cf_get_lang no='56.Online'></a></div>
						<cfelse>
							<div class="sirketp_223"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=worknet.popup_video_conferans','video_conference');"><cf_get_lang no='56.Online'></a></div>
						</cfif>
					</cfif>
					<!---<div class="sirketp_224" style="padding:0px;"><a href=""><img src="../documents/templates/worknet/tasarim/sirketp_224_ap_.png" width="165" height="33" alt="Tıkla Konuş" /></a></div>--->
					<div class="sirketp_225">
                    	<span><cf_get_lang no='179.Paylaşın'></span>
						<script>function fbs_click()  {u=location.href;t=document.title;window.open('http://www.facebook.com/sharer.php?u='+encodeURIComponent(u)+'&t='+encodeURIComponent(t),'sharer','toolbar=0,status=0,width=626,height=436');return false;}</script>
						<a href="http://www.facebook.com/share.php?u=#attributes.fuseaction#" onclick="return fbs_click()" target="_blank"><img src="../documents/templates/worknet/tasarim/p_icon_1.png" width="25" height="28" alt="Facebook" /></a>
                     	<a href="http://twitter.com/home?status=#attributes.fuseaction#" target="_blank"><img src="../documents/templates/worknet/tasarim/p_icon_2.png" width="25" height="28" alt="Twitter" /></a>
                    </div>
					<cfset _url_ = 'http://#cgi.HTTP_HOST#/#request.self#?fuseaction=worknet.dsp_member&cpid=#attributes.cpid#'>
					<div class="sirketp_226"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=worknet.popup_add_help&report_url=#_url_#','medium')"><cf_get_lang no='149.Sikayet Et'></a></div>
				</div>
			</div>
		</div>
	</cfoutput>
	<cfelse>
		<cfinclude template="hata.cfm">
	</cfif>
<cfelse>
	<cfinclude template="hata.cfm">
</cfif>
