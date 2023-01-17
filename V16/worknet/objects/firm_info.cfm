<cfif len(attributes.cpid) and attributes.cpid neq 0>
	<cfset cmp = createObject("component","V16.worknet.query.worknet_member") />
	<cfset getCompany = cmp.getCompany(company_id:attributes.cpid) />
	<cfset getPartner = cmp.getPartner(partner_id:attributes.partner_id) />
	<cfif getCompany.recordcount and len(getCompany.sector_cat_id)>
		<cfset getSectorCat = cmp.getSector(sector_cat_id:getCompany.sector_cat_id) />
	<cfelse>
		<cfset getSectorCat.sector_cat = ''>
	</cfif>
	<cfset getMemberStatus = createObject("component","worknet.objects.worknet_objects").getMemberStatus(
		member_id:attributes.partner_id,
		member_type:'partner'
	)>
	<cfoutput>
	<div class="talep_detay_13">
		<div class="firma_kart">
			<div class="firma_kart_1">
			<a href="#request.self#?fuseaction=worknet.dsp_member&cpid=#getCompany.company_id#">
					<cfif len(getCompany.ASSET_FILE_NAME1)>
						<cf_get_server_file output_file="member/#getCompany.ASSET_FILE_NAME1#" output_server="#getCompany.ASSET_FILE_NAME1_SERVER_ID#" output_type="0" image_width="130">
					<cfelse>
						<img src="/images/no_photo.gif" alt="<cf_get_lang no='495.Yok'>" title="<cf_get_lang no='495.Yok'>">
					</cfif>
				</a>
			</div>
			<div class="firma_kart_2">
				<span><a href="#request.self#?fuseaction=worknet.dsp_member&cpid=#getCompany.company_id#">#getCompany.fullname#</a> 
					  <a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_partner&pid=#attributes.partner_id#">
					  	  / #getPartner.company_partner_name# #getPartner.company_partner_surname#
					  </a>
					  <cfif isdefined('session.pp') and session.pp.company_id neq getPartner.company_id>
						<cfset getMemberFollow = createObject("component","worknet.objects.worknet_objects").getFollowMember(
								member_id:session.pp.userid,
								follow_member_id:attributes.partner_id
						)>
						<cfif getMemberFollow.recordcount eq 0>
							<div id="addContact"><a href="javascript://" onclick="add_contact();"><img src="../../documents/templates/worknet/tasarim/yicon_1.png" style="padding-left:5px;" title="<cf_get_lang no='148.Kontak Listeme Ekle'>" /></a></div>
							<div id="removeContact" style="display:none;">
							<a href="javascript://" onclick="remove_contact();"><img src="../../documents/templates/worknet/tasarim/yicon_2.png" style="padding-left:5px;" title="<cf_get_lang no='85.Kontak Listemden Çıkar'>" /></a></div>
						<cfelse>
							<div id="addContact" style="display:none;"><a href="javascript://" onclick="add_contact();"><img src="../../documents/templates/worknet/tasarim/yicon_1.png" style="padding-left:5px;" title="<cf_get_lang no='148.Kontak Listeme Ekle'>" /></a></div>
							<div id="removeContact">
								<a href="javascript://" onclick="remove_contact();">
								<img src="../../documents/templates/worknet/tasarim/yicon_2.png" style="padding-left:5px;" title="<cf_get_lang no='85.Kontak Listemden Çıkar'>" />
								</a>
							</div>
						</cfif>
					</cfif>
				</span>
				<samp><b><cf_get_lang_main no='1311.Adres'> :</b> #cmp.getCompanyAddress(company_id:attributes.cpid)#</samp>
				<samp><b><cf_get_lang_main no='87.Tel'> :</b> #getCompany.COMPANY_TELCODE# #getCompany.COMPANY_TEL1#</samp>
				<div class="firma_kart_21">
					<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_product&company_id=#getCompany.company_id#&company_name=#getCompany.fullname#" class="firm_info_tum_urun"><cf_get_lang no='131.Tüm Ürünler'></a><br />
					<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_demand&company_id=#getCompany.company_id#&company_name=#getCompany.fullname#" class="firm_info_tum_talep"><cf_get_lang no='130.Tüm Talepler'></a><br />
					<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=worknet.popup_sent_message&member_id=#getPartner.partner_id#&subject=#msg_subject#&action_id=#msg_action_id#&action_type=#msg_action_type#','medium')" class="firm_info_message"><cf_get_lang_main no='1899.Mesaj Gönder'></a>
				</div>
				<cfif getMemberStatus eq false>
					<div class="ofline" style="margin:8px 25px 0px 35px;"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=worknet.popup_sent_message&member_id=#getPartner.partner_id#&subject=#msg_subject#&action_id=#msg_action_id#&action_type=#msg_action_type#','medium')">Offline</a></div>
				<cfelse>
					<div class="online" style="margin:8px 25px 0px 35px;"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=worknet.popup_video_conferans&targetUserID=#getMemberStatus#','video_conference');">Online</a></div>
				</cfif>
			</div>
		</div>
		<div class="firma_kart_3"></div>
	</div>
	</cfoutput>
	<script type="text/javascript">
		<cfoutput>
		function add_contact()
		{   
			AjaxPageLoad('#request.self#?fuseaction=worknet.emptypopup_add_contact&partner_id=#attributes.partner_id#&type=1');
			gizle(addContact);
			goster(removeContact);
		}
		function remove_contact()
		{   
			AjaxPageLoad('#request.self#?fuseaction=worknet.emptypopup_add_contact&partner_id=#attributes.partner_id#&type=0');
			goster(addContact);
			gizle(removeContact);
		}
		</cfoutput>
	</script>
</cfif>

