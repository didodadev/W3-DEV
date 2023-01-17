<!---<cfif isdefined('session.pp')>--->
	<cfif isdefined('attributes.demand_id') and len(attributes.demand_id)>
   		<!--- cookie kaydı yapiliyor --->
		<cfset createObject("component","cookie").AddCookie(cookied:attributes.demand_id,actionType:"demand")>
		
		<cfset cmp = createObject("component","V16.worknet.query.worknet_demand") />
		<cfset getDemand = cmp.getDemand(demand_id:attributes.demand_id) />
		<cfset attributes.cpid = getDemand.company_id>
		<cfset attributes.partner_id = getDemand.partner_id>
		<cfset msg_subject = getDemand.demand_head>
		<cfset msg_action_id = getDemand.demand_id>
		<cfset msg_action_type = "demand">
	<cfelse>
		<cfset getDemand.recordcount = 0>
		<cfset attributes.cpid = 0>
		<cfset attributes.partner_id = 0>
		<cfset msg_subject = "">
		<cfset msg_action_id = "">
		<cfset msg_action_type = "">
	</cfif>
    
	<cfif getDemand.recordcount>
		<cfset getProductCat = cmp.getProductCat(demand_id:attributes.demand_id) />
		<cfset getSectorCat = createObject("component","V16.worknet.query.worknet_member").getSector(sector_cat_id:getDemand.sector_cat_id) />
		
		<cfoutput>
		<div class="haber_liste">
			<div class="haber_liste_1">
				<div class="haber_liste_11"><h1>#getDemand.demand_head#</h1></div>
					 <cfif isdefined('session.pp.userid') and session.pp.company_id eq getDemand.company_id>
					<div class="haber_liste_right" style="width:40px;">
						 <a href="#request.self#?fuseaction=worknet.detail_demand&demand_id=#attributes.demand_id#">
							<img src="../documents/templates/worknet/tasarim/kutu_icon_2.png" alt="#getDemand.demand_head#" title="<cf_get_lang_main no='1306.Düzenle'>" />
						</a>
					</div>
				</cfif>
			</div>
			<div class="talep_detay">
				<div class="talep_detay_1">
					<div class="talep_detay_11">
						<div class="td_kutu">
							<div class="td_kutu_1" style="width:598px;">
								<span><img src="../documents/templates/worknet/tasarim/kutu_icon_3.png" width="31" height="31" alt="İcon" /></span>
								<h2><cf_get_lang no='88.Talep'></h2>
							</div>
							<div class="td_kutu_2">
								<div class="td_kutu_22">
									<h3>#getDemand.demand_head#</h3>
									<span>#getDemand.detail#</span>
								</div>
							</div>
						</div>
					</div>
					<div class="talep_detay_12">
						<div class="td_kutu">
							<div class="td_kutu_1" style="width:598px;">
								<span><img src="../documents/templates/worknet/tasarim/kutu_icon_2.png" width="31" height="31" alt="İcon" /></span>
								<h2><cf_get_lang no="89.Talep Bilgileri"></h2>
							</div>
							<div class="td_kutu_2">
								<cfif isdefined('session.pp.userid') and session.pp.company_id eq getDemand.company_id>
									<div class="td_kutu_21">
										<span><cf_get_lang_main no='70.Asama'></span>
										<samp><strong>#getDemand.STAGE#</strong></samp>
									</div>
								</cfif>
								<div class="td_kutu_21">
									<span><cf_get_lang no='84.Yayın Tarihi'></span>
									<samp><b><cfoutput>#dateformat(getDemand.start_date,dateformat_style)#</cfoutput> - <cfoutput>#dateformat(getDemand.finish_date,dateformat_style)#</cfoutput></b></samp>
								</div>
								<div class="td_kutu_21">
									<span><cf_get_lang no="81.Talep Türü"></span>
									<samp><cfif getDemand.demand_type eq 1><cf_get_lang no ='79.Alım'><cfelse><cf_get_lang no ='80.Satım'></cfif></samp>
								</div>
								<div class="td_kutu_21">
									<span><cf_get_lang_main no='1195.Firma'></span>
									<samp><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_member&cpid=#getDemand.company_id#" style="width:100%;font-size:12px;color:A4A4A4;">#getDemand.fullname#</a></samp>
								</div>
								<div class="td_kutu_21">
									<span><cf_get_lang_main no='166.Yetkili'></span>
									<samp><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_partner&pid=#getDemand.partner_id#" style="width:100%;font-size:12px;color:A4A4A4;">#getDemand.partner_name#</a></samp>
								</div>
								<div class="td_kutu_21">
									<span><cf_get_lang_main no='167.Sektör'></span>
									<samp>#getSectorCat.sector_cat#</samp>
								</div>
								<div class="td_kutu_21">
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
												<samp><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_product&product_catid=#product_catid#&product_cat=#new_name#" title="#new_name#">#new_name#</a></samp>
											</cfloop>
										</cfif>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="talep_detay_2" style="margin-bottom:10px;">
					<div class="td_kutu">
						<div class="td_kutu_1" style="width:290px;">
							<span><img src="../documents/templates/worknet/tasarim/kutu_icon_1.png" width="31" height="31" alt="İcon" /></span>
							<h2><cf_get_lang no='12.Fiyat ve Teslimat'></h2>
						</div>
						<div class="td_kutu_2">
							<div class="td_kutu_21">
								<span><cf_get_lang_main no='672.Fiyat'></span>
								<samp>#tlformat(getDemand.total_amount)# #getDemand.money#</samp>
							</div>
							<div class="td_kutu_21">
								<span><cf_get_lang_main no='233.Teslim Tarihi'></span>
								<samp>#dateformat(getDemand.deliver_date,dateformat_style)#</samp>
							</div>
							<div class="td_kutu_21">
								<span><cf_get_lang_main no='1037.Teslim Yeri'></span>
								<samp>#getDemand.deliver_addres#</samp>
							</div>
							<div class="td_kutu_21">
								<span><cf_get_lang_main no='1104.Ödeme Yöntemi'></span>
								<samp>#getDemand.paymethod#</samp>
							</div>
							<div class="td_kutu_21">
								<span><cf_get_lang_main no='1703.Sevk Yöntemi'></span>
								<samp>#getDemand.ship_method#</samp>
							</div>
                            <cfif len(getDemand.quantity)>
                                <div class="td_kutu_21">
                                    <span><cf_get_lang_main no='223.Miktar'></span>
                                    <samp>#tlformat(getDemand.quantity)#</samp>
                                </div>
                            </cfif>
                            <cfif len(getDemand.colour)>
                                <div class="td_kutu_21">
                                    <span><cf_get_lang no='236.Renk'></span>
                                    <samp>#getDemand.colour#</samp>
                                </div>
                            </cfif>
                            <cfif len(getDemand.type)>
                                <div class="td_kutu_21">
                                    <span><cf_get_lang_main no='519.Cins'></span>
                                    <samp>#getDemand.type#</samp>
                                </div>
                            </cfif>
						</div>
					</div>
				</div>
	
				<cfset getRelationAsset = createObject("component","V16.worknet.query.worknet_asset").getRelationAsset
					(action_id:attributes.demand_id,
						action_section:"DEMAND_ID",
						asset_cat_id:-11
					) />
				
				 <div class="talep_detay_2">
					<cfif getRelationAsset.recordcount>
						<div class="talep_detay_222">
							<ul>
								<li><a class="talep_detay_222a aktif"><cf_get_lang_main no='156.Belgeler'></a></li>
							</ul>
						</div>
						<div class="td_kutu_2">
							<cfloop query="getRelationAsset">
							<div class="td_kutu_21">
								<span style="width:290px;">
								<cfif ListLast(asset_file_name,'.') is 'flv'>
									<a href="javascript://" onClick="windowopen('index.cfm?fuseaction=objects.popup_flvplayer&video=#file_web_path##ASSETCAT_PATH#/#asset_file_name#&ext=flv&video_id=#asset_id#','video');" class="tableyazi">
									#ASSET_NAME# <font color="red">(#property_name#)</font>
									</a>
								<cfelse>
									<a href="javascript://" onClick="windowopen('#file_web_path##ASSETCAT_PATH#/#asset_file_name#','medium');" title="#ASSET_NAME#" class="tableyazi">
									#ASSET_NAME# <font color="red">(#property_name#)</font>
									</a>
								</cfif>	
								</span>
							</div>
							</cfloop>
						</div>
					</cfif>
					<div class="talep_detay_21">
						<a href="javascript:" onClick="windowopen('#request.self#?fuseaction=worknet.popup_add_demand_offer&demand_id=#attributes.demand_id#','medium')"><font color="FFFFFF" style="font-size:20px;"><cf_get_lang no='105.TEKLİF VER'></font></a>
					</div>
					<cfset getFavorite = createObject("component","worknet.objects.worknet_objects").getFavorite
						(action_id:attributes.demand_id,
							action_type:"demand"
						) />					
					<cfif getFavorite.recordcount>
						<div class="talep_detay_21" style="display:none;" id="add_favorite">
							<a href="javascript:" onClick="addFavorite();"><cf_get_lang no='122.Favorilerime Ekle'> (+)</a>
						</div>
						<div class="talep_detay_21" style="display:block;" id="remove_favorite">
							<a href="javascript:" onClick="removeFavorite();"><cf_get_lang no='52.Favorilerimden Çıkar'> (-)</a>
						</div>
					<cfelse>
						<div class="talep_detay_21" style="display:block;" id="add_favorite">
							<a href="javascript:" onClick="addFavorite();"><cf_get_lang no='122.Favorilerime Ekle'> (+)</a>
						</div>
						<div class="talep_detay_21" style="display:none;" id="remove_favorite">
							<a href="javascript:" onClick="removeFavorite();"><cf_get_lang no='52.Favorilerimden Çıkar'> (-)</a>
						</div>
					</cfif>
				</div>
			</div>		
		</div>
		<script language="javascript">
			function addFavorite()
			{
				document.getElementById('add_favorite').style.display = 'none';
				document.getElementById('remove_favorite').style.display = 'block';
				AjaxPageLoad('#request.self#?fuseaction=worknet.emptypopup_add_remove_relation_objects&action_id=#attributes.demand_id#&action_type=demand&add=1',2);
			}
			function removeFavorite()
			{
				document.getElementById('remove_favorite').style.display = 'none';
				document.getElementById('add_favorite').style.display = 'block';
				AjaxPageLoad('#request.self#?fuseaction=worknet.emptypopup_add_remove_relation_objects&action_id=#attributes.demand_id#&action_type=demand&add=0');
			}
		</script>
		</cfoutput>
	<cfelse>
		<cfinclude template="hata.cfm">
	</cfif>
<!---<cfelse>
	<cfset getDemand.recordcount = 0>
	<cfset attributes.cpid = 0>
	<cfset attributes.partner_id = 0>
	<cfset msg_subject = "">
	<cfset msg_action_id = "">
	<cfset msg_action_type = "">
	<cfinclude template="member_login.cfm">
</cfif>--->
