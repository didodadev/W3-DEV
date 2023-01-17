<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.cpid" default="0">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_catid" default="">
<cfparam name="attributes.sector" default="">
<cfparam name="attributes.country" default="">
<cfparam name="attributes.city" default="">
<cfparam name="attributes.county" default="">
<cfparam name="attributes.is_online" default="">
<cfparam name="attributes.position" default="">

<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif attributes.fuseaction contains 'list_partner'>
	<cfset getPartner = createObject("component","V16.worknet.query.worknet_member").getPartner(
			partner_status:1,
			keyword:attributes.keyword,
			company_id:attributes.cpid,
			product_cat:attributes.product_cat,
			product_catid:attributes.product_catid,
			sector:attributes.sector,
			partner_country:attributes.country,
			partner_city:attributes.city,
			partner_county:attributes.county,
			is_online:attributes.is_online,
			position:attributes.position
	) />
<cfelseif isdefined('session.pp.userid')>
	<cfset getPartner = createObject("component","worknet.objects.worknet_objects").getMemberFollow(member_id:session.pp.userid,keyword:attributes.keyword) />
<cfelse>
	<cfset getPartner.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#getPartner.recordcount#">
<div class="haber_liste">
	<div class="haber_liste_1">
		<cfform name="search_member" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
			<div class="haber_liste_11"><h1><cfif attributes.fuseaction contains 'list_partner'><cf_get_lang no='189.Kisiler'><cfelse><cf_get_lang no='74.Kontak Listem'></cfif></h1></div>
			<div class="haber_liste_12" style="width:32px;">
				<input class="arama_btn" name="" type="submit" value="" style=" border:none;">
			</div>
			<div class="haber_liste_12" style="width:210px;">
				<cfinput type="text" name="keyword" value="#attributes.keyword#" class="txt_10">
			</div>
		</cfform>
	</div>
	<div class="mesaj">
		<div class="mesaj_3">
			<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tablo">
			   <tr class="mesaj_31">
				<td width="15" class="mesaj_311_1"><cf_get_lang_main no='75.No'></td>
                <td width="200" class="mesaj_311_1"><cf_get_lang_main no='1195.Firma'></td>
				<td width="120" class="mesaj_311_1"><cf_get_lang_main no='219.Ad'> <cf_get_lang_main no='1314.Soyad'></td>
				<td width="80" class="mesaj_311_1"><cf_get_lang_main no='41.Sube'></td>
				<td width="80" class="mesaj_311_1"><cf_get_lang_main no='161.Görev'></td>
				<td width="80" class="mesaj_311_1"><cf_get_lang_main no='159.Ünvan'></td>
				<td width="45" class="mesaj_311_1"></td>
				<td width="70" class="mesaj_311_1"></td>
			  </tr>
			  <cfif getPartner.recordcount>
			  	<cfoutput query="getPartner" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
				  <tr <cfif (currentrow mod 2) eq 0>class="mesaj_35"<cfelse>class="mesaj_34"</cfif>>
					<td class="tablo1">#currentrow#</td>
                    <td class="tablo1">
						<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_member&cpid=#getPartner.company_id#">
							<cfif len(attributes.keyword)>
								#createObject("component","worknet.objects.worknet_objects").highLightText(fullname,attributes.keyword,250,'<font color="000000" style="background-color:yellow; font-weight:bold;"></font>')#
							<cfelse>
								#fullname#
							</cfif>
						</a>
					</td>
					<td class="tablo1">
						<cfset name_surname = "#company_partner_name# #company_partner_surname#">
						<cfif len(attributes.keyword)>
							<cfset name_surname = "#createObject("component","worknet.objects.worknet_objects").highLightText(name_surname,attributes.keyword,250,'<font color="000000" style="background-color:yellow; font-weight:bold;"></font>')#">
						</cfif>
						<cfif isdefined('session.pp')>
							<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_partner&pid=#getPartner.partner_id#">#name_surname#</a>
						<cfelse>
							#name_surname#
						</cfif>
					</td>
					<td class="tablo1">#compbranch__name#</td>
					<td class="tablo1">#partner_position#</td>
					<td class="tablo1">#title#</td>
					<td class="tablo1">
						<cfif isdefined('session.pp')>
							<cfif len(getPartner.follow_member_id) or company_id eq session.pp.company_id>
								<div id="addContact_#partner_id#" style="display:none;"><a href="javascript://" onclick="add_contact(#partner_id#);" title="<cf_get_lang no='148.Kontak Listeme Ekle'>"><img src="/documents/templates/worknet/tasarim/yicon_1.png" width="21" height="12" title="<cf_get_lang no='148.Kontak Listeme Ekle'>"/></a></div>
								<div id="removeContact_#partner_id#">
									<a href="javascript://" onclick="remove_contact(#partner_id#);" title="<cf_get_lang no='85.Kontak Listemden Çıkar'>"><img src="/documents/templates/worknet/tasarim/yicon_2.png" width="21" height="12" title="<cf_get_lang no='85.Kontak Listemden Çıkar'>" /></a>
								</div>
							<cfelse>
                            	<div id="addContact_#partner_id#" style="display:;"><a href="javascript://" onclick="add_contact(#partner_id#);" title="<cf_get_lang no='148.Kontak Listeme Ekle'>"><img src="/documents/templates/worknet/tasarim/yicon_1.png" width="21" height="12" title="<cf_get_lang no='148.Kontak Listeme Ekle'>" /></a></div>
								<div id="removeContact_#partner_id#" style="display:none;">
									<a href="javascript://" onclick="remove_contact(#partner_id#);" title="<cf_get_lang no='85.Kontak Listemden Çıkar'>"><img src="/documents/templates/worknet/tasarim/yicon_2.png" width="21" height="12" title="<cf_get_lang no='85.Kontak Listemden Çıkar'>" /></a>
								</div>
							</cfif>
						<cfelse>
							<a href="login"><img src="/documents/templates/worknet/tasarim/yicon_1.png" width="21" height="12" title="<cf_get_lang no='148.Kontak Listeme Ekle'>" /></a>
						</cfif>
					</td>
					<td class="tablo2">
						<cfif not len(getPartner.workcube_id)>
							<div class="ofline"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=worknet.popup_sent_message&member_id=#partner_id#','medium')" title="<cf_get_lang_main no='1899.Mesaj Gönder'>">Offline</a></div>
						<cfelse>
							<div class="online"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=worknet.popup_video_conferans&targetUserID=#getPartner.workcube_id#','video_conference');">Online</a></div>
						</cfif>
					</td>
				  </tr>
			  </cfoutput>
			  <cfelse>
				<tr class="mesaj_34">
				  <td class="tablo1" colspan="8"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			    </tr>
			  </cfif>
			</table>
		</div>
	</div>
	<div class="maincontent">
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset url_str = "">
			<cfif isDefined("attributes.cpid")>
				<cfset url_str = "#url_str#&cpid=#attributes.cpid#">
			</cfif>
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif isDefined("attributes.is_online") and len(attributes.is_online)>
				<cfset url_str = "#url_str#&is_online=#attributes.is_online#">
			</cfif>
			<cfif isDefined("attributes.product_catid") and len(attributes.product_catid)>
				<cfset url_str = "#url_str#&product_cat=#attributes.product_cat#&product_catid=#attributes.product_catid#">
			</cfif>
			<cfif isDefined("attributes.position") and len(attributes.position)>
				<cfset url_str = "#url_str#&position=#attributes.position#">
			</cfif>
			<cfif isDefined("attributes.country") and len(attributes.country)>
				<cfset url_str = "#url_str#&country=#attributes.country#">
			</cfif>
			<cfif isDefined("attributes.city") and len(attributes.city)>
				<cfset url_str = "#url_str#&city=#attributes.city#">
			</cfif>
			<cfif isDefined("attributes.county") and len(attributes.county)>
				<cfset url_str = "#url_str#&county=#attributes.county#">
			</cfif>
			<cfif isDefined("attributes.sector") and len(attributes.sector)>
				<cfset url_str = "#url_str#&sector=#attributes.sector#">
			</cfif>
			<cf_paging page="#attributes.page#" 
			page_type="1"
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#attributes.fuseaction##url_str#">
					 
		</cfif>
	</div>
</div>

<script type="text/javascript">
	<cfoutput>
	function add_contact(pid)
	{   
		AjaxPageLoad('#request.self#?fuseaction=worknet.emptypopup_add_contact&partner_id='+pid+'&type=1');
		document.getElementById('addContact_'+pid).style.display = 'none';
		document.getElementById('removeContact_'+pid).style.display = '';
	}
	function remove_contact(pid)
	{   
		AjaxPageLoad('#request.self#?fuseaction=worknet.emptypopup_add_contact&partner_id='+pid+'&type=0');
		document.getElementById('addContact_'+pid).style.display = '';
		document.getElementById('removeContact_'+pid).style.display = 'none';
	}
	</cfoutput>
</script>
