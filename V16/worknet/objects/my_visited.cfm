<div class="haber_liste">
	<div class="haber_liste_1">
		<div class="haber_liste_11"><h1><cf_get_lang_main no='115.TALEPLER'></h1></div>
	</div>
	<div class="haber_liste_2">
		<cfif isdefined('cookie.demand') and len(cookie.demand)>
			<cfset cmp = createObject("component","V16.worknet.query.worknet_demand") />
			<cfset getDemand = cmp.getDemand(
					my_demand:0,
					is_online:1,
					is_status:1,
					demand_id_list:cookie.demand
				) 
			/>
			<cfoutput query="getDemand">
				<div class="haber_liste_21">
					<cfif isdefined('session.pp')>
                        <div class="uhaber_liste_211">
                            <a href="#request.self#?fuseaction=worknet.dsp_demand&demand_id=#demand_id#">
                                <cfif len(ASSET_FILE_NAME1) and isdefined('session.pp')>
                                    <cf_get_server_file output_file="member/#ASSET_FILE_NAME1#" output_server="#ASSET_FILE_NAME1_SERVER_ID#" output_type="0" image_width="100">
                                <cfelse>
                                    <img src="/images/no_photo.gif">
                                </cfif>
                            </a>
                        </div>
                    </cfif>
					<div class="talep_liste_212">
						<span>#dateformat(start_date,dateformat_style)# <cfif len(finish_date)>- #dateformat(finish_date,dateformat_style)#</cfif></span>
						<a href="#request.self#?fuseaction=worknet.dsp_demand&demand_id=#demand_id#">
							<cfif demand_type eq 1><cf_get_lang no ='79.Alım'><cfelse><cf_get_lang no ='80.Satım'></cfif> - #demand_head#
						</a>
						<cfif isdefined('session.pp')>
							<samp><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_member&cpid=#company_id#" style="font-size:12px;color:A4A4A4; font-weight:bold;">#fullname#-#partner_name#</a></samp>
						</cfif>
					</div>
					<div class="uhaber_liste_213" style="float:right;">
						<div class="talep_detay_21">
							<a href="javascript:" onClick="windowopen('#request.self#?fuseaction=worknet.popup_add_demand_offer&demand_id=#demand_id#','medium')"><font color="FFFFFF" style="font-size:20px;"><cf_get_lang no='105.TEKLİF VER'></font></a>
						</div>
					</div>
				</div>
			</cfoutput>
		<cfelse>
			<div class="haber_liste_21">
				<div class="haber_liste_212">
				   <cf_get_lang_main no='72.Kayıt Bulunamadı'>!
				</div>
			</div>
		</cfif>
	</div>
</div>

<cfif isdefined('session.pp')>
	<div class="haber_liste"><br /><br />
		<div class="haber_liste_1">
			<div class="haber_liste_11"><h1><cf_get_lang_main no='152.ÜRÜNLER'></h1></div>
		</div>
		<div class="haber_liste_2">
			<cfif isdefined('cookie.product') and len(cookie.product)>
				<cfset cmp = createObject("component","V16.worknet.query.worknet_product") />
				<cfset getProduct = cmp.getProduct(
						is_online:1,
						is_catalog:0,
						product_status:1,
						product_id_list:cookie.product
				) />
				<cfoutput query="getProduct">
					<div class="haber_liste_21">
						<div class="uhaber_liste_211">
							<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_product&pid=#product_id#">
								<cfif len(path)>
									<cf_get_server_file output_file="product/#path#" output_server="#path_server_id#" output_type="0" image_width="100" alt="#product_name#">
								<cfelse>
									<img src="/images/no_photo.gif" alt="<cf_get_lang no='495.Yok'>">
								</cfif>
							</a>
						</div>
						<div class="uhaber_liste_212">
							<div class="uhaber_liste_2121">
								<span>#dateformat(record_date,dateformat_style)#</span>
								<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_product&pid=#product_id#"><b>#product_name#</b></a>
								<samp><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_member&cpid=#company_id#" style="font-size:12px;color:A4A4A4; font-weight:bold;">#fullname#-#partner_name#</a></samp>
							</div>                        
						</div>
						<div class="uhaber_liste_213">
							<cfset getMemberStatus = createObject("component","worknet.objects.worknet_objects").getMemberStatus(
                                member_id:company_id,
                                member_type:'company'
                            )>
							<cfif getMemberStatus eq false>
								<div class="uhaber_liste_2133"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=worknet.popup_sent_message&member_id=#getProduct.partner_id#','medium')"><cf_get_lang no='142.Offline'></a></div>
							<cfelse>
								<div class="uhaber_liste_2132"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=worknet.popup_video_conferans&targetUserID=#getMemberStatus#','video_conference');"><cf_get_lang no='56.Online'></a></div>
							</cfif>
						</div>
					</div>
				</cfoutput>
			<cfelse>
				<div class="haber_liste_21">
					<div class="haber_liste_212">
						<cf_get_lang_main no='72.Kayıt Bulunamadı'>!
					</div>
				</div>
			</cfif>
		</div>
	</div>
</cfif>

