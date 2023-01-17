<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_catid" default="">

<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfset getGeneralSearch = createObject("component","worknet.objects.worknet_objects").getGeneralSearch(
		keyword:attributes.keyword,
		product_cat:attributes.product_cat,
		product_catid:attributes.product_catid
	) 
/>
<cfparam name="attributes.totalrecords" default="#getGeneralSearch.recordcount#">
<div class="haber_liste">
	<div class="haber_liste_1">
			<div class="haber_liste_11"><h1><cf_get_lang_main no='723.Sonuçlar'></h1></div>
	</div>
	<div class="haber_liste_2">
		 <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tablo">
           <tr class="mesaj_31">
            <td width="15" class="mesaj_311_1"><cf_get_lang_main no='75.No'></td>
            <td class="mesaj_311_1"><cf_get_lang_main no='218.Tip'></td>
            <td class="mesaj_311_1"><cf_get_lang_main no='219.Ad'></td>
           </tr>
		<cfif getGeneralSearch.recordcount>
			<cfoutput query="getGeneralSearch" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
				<tr <cfif (currentrow mod 2) eq 0>class="mesaj_35"<cfelse>class="mesaj_34"</cfif>>
                    <td class="tablo1">#currentrow#</td>
                    <td class="tablo1">
						<cfif type eq 1>
							<cf_get_lang_main no='241.İçerik'>
						<cfelseif type eq 2>
							<cf_get_lang_main no='246.Üye'>
						<cfelseif type eq 3>
							<cf_get_lang_main no='2034.Kişi'>
						<cfelseif type eq 4>
							<cf_get_lang no='88.Talep'>
						<cfelseif type eq 5>
							<cf_get_lang_main no='245.Ürün'>
						<cfelseif type eq 6>
							<cf_get_lang no='182.Katalog'>
						</cfif>
					</td>
                    <td class="tablo2" style="padding-left:5px;">
						<cfif type eq 1>
							<a href="#url_friendly_request('worknet.detail_content&cid=#action_id#','#user_friendly_url#')#">#action_name#</a>
						<cfelseif type eq 2>
							<a href="#request.self#?fuseaction=worknet.dsp_member&cpid=#action_id#">#action_name#</a>
						<cfelseif type eq 3>
							<cfif isdefined('session.pp')>
								<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_partner&pid=#action_id#">#action_name#</a>
							<cfelse>
								<a href="login">#action_name#</a>
							</cfif>
						<cfelseif type eq 4>
							<a href="#request.self#?fuseaction=worknet.dsp_demand&demand_id=#action_id#">#action_name#</a>
						<cfelseif type eq 5>
							<a href="#request.self#?fuseaction=worknet.dsp_product&pid=#action_id#">#action_name#</a>
						<cfelseif type eq 6>
							<cfif isdefined('session.pp')>
								<cfset getRelationAsset = createObject("component","V16.worknet.query.worknet_asset").getRelationAsset(action_id:action_id) />
                                <a href="javascript://" onclick="windowopen('#file_web_path##getRelationAsset.ASSETCAT_PATH#/#getRelationAsset.asset_file_name#','large');">
									#action_name#
								</a>
							<cfelse>
								<a href="list_catalog">#action_name#</a>
							</cfif>
						</cfif>
					</td>
                </tr>
			</cfoutput>
		<cfelse>
			<tr class="mesaj_34">
              <td class="tablo1" colspan="7"> <cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
            </tr>
		</cfif>
       </table>
	</div>
	<div class="maincontent">
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset urlstr="&keyword=#attributes.keyword#&product_cat=#attributes.product_cat#&product_catid=#attributes.product_catid#">
	
			<cf_paging page="#attributes.page#" 
			page_type="1"
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#attributes.fuseaction##urlstr#">
					
		</cfif>
	</div>
</div>
