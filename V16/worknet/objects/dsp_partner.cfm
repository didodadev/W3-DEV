<cfif isdefined('attributes.pid') and len(attributes.pid)>
	<cfset cmp = createObject("component","V16.worknet.query.worknet_member") />
	<cfset getPartner = cmp.getPartner(partner_id:attributes.pid) />
	<cfset getCountry = cmp.getCountry() />
	<cfset getPartnerPositions = cmp.getPartnerPositions() />
	<cfset getPartnerDepartments = cmp.getPartnerDepartments() />
	<cfset getLanguage = cmp.getLanguage() />
	<cfset getCompanyBranch = cmp.getCompanyBranch(partner_id:attributes.pid) />
	<cfoutput>
		<div class="haber_liste">
			<div class="haber_liste_1">
				<div class="haber_liste_11"><h1>#left(getPartner.nickname,50)# - #getPartner.company_partner_name# #getPartner.company_partner_surname#</h1></div>
			</div>
			<div>
				<!--- genel --->
				<div class="sirketp_21" id="genel">
					 <div class="sirketp_rqkod">
						<cfif isdefined('attributes.info_content_id') and len(attributes.info_content_id)>
                            <a href="javascript://" data-width="300px" style="margin:4px 0px 0px 10px;" data-text="<cfoutput>#createObject('component','worknet.objects.worknet_objects').getContent(content_id:attributes.info_content_id)#</cfoutput>" class="tooltip">
                                <img src="../documents/templates/worknet/tasarim/tooltipIcon.png" />
                            </a>
                        </cfif>
                        <cf_workcube_barcode show="1" type="qrcode" width="110" height="110" value="MECARD:N:#getPartner.COMPANY_PARTNER_NAME# #getPartner.COMPANY_PARTNER_SURNAME# - #getPartner.TITLE# - #getPartner.fullname#; ADR:#getPartner.COMPANY_PARTNER_ADDRESS# #getPartner.COUNTY_NAME# #getPartner.COMPANY_PARTNER_POSTCODE# #getPartner.CITY_NAME# #getPartner.COUNTRY_NAME# ;TEL:#getPartner.COMPANY_PARTNER_TELCODE##getPartner.COMPANY_PARTNER_TEL#; EMAIL:#getPartner.COMPANY_PARTNER_EMAIL#;">
					</div>
                	<div class="sirketp_211 sirketp_rq">
						<span><cf_get_lang_main no='1195.Firma'></span>
						<samp><a href="#request.self#?fuseaction=worknet.dsp_member&cpid=#getPartner.company_id#" style="margin-left:0px;">#getPartner.fullname#</a></samp>
					</div>
					<div class="sirketp_212 sirketp_rq">
						<span><cf_get_lang_main no='219.Ad'> <cf_get_lang_main no='1314.Soyad'></span>
						<samp><strong>#getPartner.company_partner_name# #getPartner.company_partner_surname#</strong></samp>
					</div>
					<div class="sirketp_211 sirketp_rq">
						<span><cf_get_lang_main no='159.Ünvan'></span>
						<samp>#getPartner.title#</samp>
					</div>
                    <div class="sirketp_212 sirketp_rq">
						<span><cf_get_lang_main no='161.Görev'></span>
						<samp>#getPartner.PARTNER_POSITION#</samp>
					</div>
                    <div class="sirketp_211">
                        <span><cf_get_lang_main no='160.Departman'></span>
                        <samp>#getPartner.PARTNER_DEPARTMENT#</samp>
                    </div>
					<div class="sirketp_212">
						<span><cf_get_lang_main no='1173.Kod'>/<cf_get_lang_main no='87.Telefon'></span>
						<samp>#getPartner.company_partner_telcode# #getPartner.company_partner_tel#</samp>
					</div>
                    <div class="sirketp_211">
						<span><cf_get_lang_main no='76.Fax'></span>
						<samp>#getPartner.company_partner_fax#</samp>
					</div>
				</div>
				<div class="sirketp_22">
					<div class="sirketp_222" style=" margin-left:20px;">
						<cfif len(getPartner.photo)>
                            <cf_get_server_file output_file="member/#getPartner.photo#" output_server="#getPartner.photo_server_id#" output_type="0" image_width="120" image_height="160">
                        <cfelse>
                            <cfif getPartner.sex eq 1>
                                <img src="/images/male.jpg ">
                            <cfelse>
                                <img src="/images/female.jpg">
                            </cfif> 
                        </cfif>
					</div>
					<cfif not len(getPartner.sessionid)>
						<div class="uhaber_liste_2133"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=worknet.popup_sent_message&member_id=#getPartner.partner_id#','medium')"><cf_get_lang no='142.Offline'></a></div>
					<cfelse>
						<cfif isdefined('session.pp') and session.pp.userid neq attributes.pid>
							<div class="uhaber_liste_2132"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=worknet.popup_video_conferans&targetUserID=#getPartner.sessionid#','video_conference');"><cf_get_lang no='56.Online'></a></div>
						<cfelse>
							<div class="uhaber_liste_2132"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=worknet.popup_video_conferans','video_conference');"><cf_get_lang no='56.Online'></a></div>
						</cfif>
					</cfif>
                    <!---<div class="sirketp_224"><a href=""><img src="../documents/templates/worknet/tasarim/sirketp_224_ap.png" width="118" height="33" alt="Tıkla Konuş" /></a></div>--->
					<div class="sirketp_226"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=worknet.popup_sent_message&member_id=#getPartner.partner_id#','medium')"><cf_get_lang_main no='1899.Mesaj Gonder'></a></div>
					<cfif isdefined('session.pp') and session.pp.company_id neq getPartner.company_id>
						<cfset getMemberFollow = createObject("component","worknet.objects.worknet_objects").getMemberFollow(member_id:session.pp.userid,follow_member_id:getPartner.partner_id,type_:0)>
						<cfif getMemberFollow.recordcount eq 0>
							<div class="sirketp_226" id="addContact" style="display:;"><a href="javascript://" onclick="add_contact();"><cf_get_lang no='148.Kontak Listeme Ekle'></a></div>
							<div class="sirketp_226" id="removeContact" style="display:none; color:red;">
							<a href="javascript://" onclick="remove_contact();"><font style=" color:red;"><cf_get_lang no='85.Kontak Listemden Çıkar'></font></a></div>
						<cfelse>
							<div class="sirketp_226" id="addContact" style="display:none;"><a href="javascript://" onclick="add_contact();"><cf_get_lang no='148.Kontak Listeme Ekle'></a></div>
							<div class="sirketp_226" id="removeContact">
								<a href="javascript://" onclick="remove_contact();">
								<font style=" color:red;"><cf_get_lang no='85.Kontak Listemden Çıkar'></font>
								</a>
							</div>
						</cfif>
					</cfif>
					<cfset _url_ = 'http://#cgi.HTTP_HOST#/#request.self#?fuseaction=worknet.dsp_partner&pid=#attributes.pid#'>
					<div class="sirketp_226"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=worknet.popup_add_help&report_url=#_url_#','medium')"><cf_get_lang no='149.Sikayet Et'></a></div>
				</div>
			</div>
		</div>
	</cfoutput>
<cfelse>
	<cfinclude template="hata.cfm">
</cfif>
<script type="text/javascript">
	<cfoutput>
	function add_contact()
	{   
		AjaxPageLoad('#request.self#?fuseaction=worknet.emptypopup_add_contact&partner_id=#attributes.pid#&type=1');
		document.getElementById('addContact').style.display = 'none';
		document.getElementById('removeContact').style.display = '';
	}
	function remove_contact()
	{   
	 	AjaxPageLoad('#request.self#?fuseaction=worknet.emptypopup_add_contact&partner_id=#attributes.pid#&type=0');
		document.getElementById('addContact').style.display = '';
		document.getElementById('removeContact').style.display = 'none';
	}
	</cfoutput>
</script>
