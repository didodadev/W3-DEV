<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.sector" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_catid" default="">
<cfparam name="attributes.is_potential" default="0">
<cfparam name="attributes.company_status" default="1">
<cfparam name="attributes.is_related_company" default="">
<cfparam name="attributes.firm_type_uye" default="">
<cfparam name="attributes.country" default="">
<cfparam name="attributes.city" default="">
<cfparam name="attributes.county" default="">

<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'><!--- #session_base.maxrows#--->
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfset cmp = createObject("component","V16.worknet.query.worknet_member") />
<cfset getCompany = cmp.getCompany(
		keyword:attributes.keyword,
		sector:attributes.sector,
		product_cat:attributes.product_cat,
		product_catid:attributes.product_catid,
		is_potential:attributes.is_potential,
		company_status:attributes.company_status,
		is_related_company:attributes.is_related_company,
		firm_type:attributes.firm_type_uye,
		country:attributes.country,
		city:attributes.city,
		county:attributes.county,
		maxrows:attributes.maxrows,
		startrow:attributes.startrow
	) />
	
<cfparam name="attributes.totalrecords" default="#getCompany.query_count#">
<div class="haber_liste">
	<div class="haber_liste_1">
		<cfform name="search_member" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_member" method="post">
			<div class="haber_liste_11"><h1><cf_get_lang_main no='5.Uyeler'> <cfif getCompany.recordcount>(<cfoutput>#getCompany.query_count#</cfoutput>)</cfif></h1></div>
			<div class="haber_liste_12" style="width:32px;">
				<input class="arama_btn" name="" type="submit" value="" style=" border:none;">
			</div>
			<div class="haber_liste_12">
				<select name="is_related_company" id="is_related_company" style="border:none;padding-bottom:3px; width:170px;">
					<option value=""><cf_get_lang no='262.Tüm Üyeler'></option>
					<option value="1" <cfif attributes.is_related_company eq 1>selected</cfif>>
						<cfif session_base.language is 'tr'>İHKİB Üyeleri<cfelse>IHKIB's Members</cfif>
					</option>
				</select>
			</div>
			<div class="haber_liste_12" style="width:210px;">
				<cfinput type="text" name="keyword" value="#attributes.keyword#" class="txt_10">
			</div>
		</cfform>
	</div>
	<cfif len(attributes.content_head_id)>
		<div class="forum_1">
			<samp style="width:900px;">
				<cfoutput>#createObject("component","worknet.objects.worknet_objects").getContent(content_id:attributes.content_head_id)#</cfoutput>
			</samp>
		</div>
	</cfif>
	<div class="haber_liste_2">
		<cfif getCompany.recordcount>
			<cfoutput query="getCompany">
				<div class="haber_liste_21">
					<div class="uhaber_liste_211">
						<a href="#request.self#?fuseaction=worknet.dsp_member&cpid=#company_id#">
							<cfif len(ASSET_FILE_NAME1)>
								<cf_get_server_file output_file="member/#ASSET_FILE_NAME1#" output_server="#ASSET_FILE_NAME1_SERVER_ID#" output_type="0" image_width="100">
							<cfelse>
								<img src="/images/no_photo.gif" alt="<cf_get_lang no='495.Yok'>" title="<cf_get_lang no='495.Yok'>">
							</cfif>
						</a>
					</div>
					<div class="uhaber_liste_212">
						<div class="uhaber_liste_2121">
							<a href="#request.self#?fuseaction=worknet.dsp_member&cpid=#company_id#">
								<cfif len(attributes.keyword)>
									#createObject("component","worknet.objects.worknet_objects").highLightText(fullname,attributes.keyword,250,'<font color="000000" style="background-color:yellow;font-size:18px; font:calibri;"></font>')#
									&nbsp;(#country_name#/#city_name#)
								<cfelse>
									#fullname#&nbsp;(#country_name#/#city_name#)
								</cfif>
							</a>
						</div>
						<cfif len(company_size_cat)>
							<div class="uhaber_liste_2122">
								<b><cf_get_lang no='151.Şirket Büyüklügü'>:</b> #company_size_cat#
							</div>
						</cfif>
						<cfset getReqType = cmp.getReqType(company_id:company_id) />
						<cfif len(getReqType.liste_name)>
							<div class="uhaber_liste_2122">
								<b><cf_get_lang_main no='1896.Sertifikalar'>:</b> #getReqType.liste_name#
							</div>
						</cfif>
						<div class="uhaber_liste_2122">
							<cfset getProductCat = cmp.getProductCat(company_id:company_id) />
							<cfif getProductCat.recordcount>
								<b><cf_get_lang_main no='155.Ürün Kategorileri'>:</b> <br/>
								<cfloop query="getProductCat" startrow="1" endrow="3">
									<cfset hierarchy_ = "">
									<cfset new_name = "">
									<cfloop list="#HIERARCHY#" delimiters="." index="hi">
										<cfset hierarchy_ = ListAppend(hierarchy_,hi,'.')>
										<cfset getCat = createObject("component","V16.worknet.query.worknet_product").getMainProductCat(hierarchy:hierarchy_)>
										<cfset new_name = ListAppend(new_name,getCat.PRODUCT_CAT,'>')>
									</cfloop>
									<div class="talep_liste_1">
										<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_product&product_catid=#product_catid#&product_cat=#new_name#" title="#new_name#">#new_name#<cfif getProductCat.recordcount gt 3 and getProductCat.currentrow mod 3 eq 0>&nbsp;&nbsp;...</cfif></a>
									</div>
								</cfloop>
							</cfif>
						</div>
					</div>
					<div class="uhaber_liste_213">
						<cfset getMemberStatus = createObject("component","worknet.objects.worknet_objects").getMemberStatus(
							member_id:company_id,
							member_type:'company'
						)>
						<cfif getMemberStatus eq false>
							<div class="uhaber_liste_2133"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=worknet.popup_sent_message&member_id=#manager_partner_id#','medium')"><cf_get_lang no='142.Offline'></a></div>
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
	<div class="maincontent">
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset url_str = "">
			<cfif isDefined("attributes.form_submitted")>
				<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
			</cfif>
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif isDefined("attributes.is_related_company") and len(attributes.is_related_company)>
				<cfset url_str = "#url_str#&is_related_company=#attributes.is_related_company#">
			</cfif>
			<cfif isDefined("attributes.product_catid") and len(attributes.product_catid)>
				<cfset url_str = "#url_str#&product_cat=#attributes.product_cat#&product_catid=#attributes.product_catid#">
			</cfif>
			<cfif isDefined("attributes.company_status") and len(attributes.company_status)>
				<cfset url_str = "#url_str#&company_status=#attributes.company_status#">
			</cfif>
			<cfif isDefined("attributes.firm_type_uye") and len(attributes.firm_type_uye)>
				<cfset url_str = "#url_str#&firm_type_uye=#attributes.firm_type_uye#">
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
						adres="#listgetat(attributes.fuseaction,1,'.')#.list_member#url_str#">
				
		</cfif>
	</div>
</div>
