<!---<cfif isdefined('session.pp')>--->
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.sector" default="">
	<cfparam name="attributes.product_cat" default="">
	<cfparam name="attributes.product_catid" default="">
	<cfparam name="attributes.company_id" default="">
	<cfparam name="attributes.company_name" default="">
	<cfparam name="attributes.is_online" default="1">
    <cfparam name="attributes.firm_type" default="">
    <cfparam name="attributes.sector" default="">
    <cfparam name="attributes.photo_status" default="">
    <cfparam name="attributes.country" default="">
    <cfparam name="attributes.city" default="">
    <cfparam name="attributes.county" default="">
    <cfif attributes.fuseaction contains 'product'>
	    <cfparam name="attributes.is_catalog" default="0">
    <cfelse>
    	<cfparam name="attributes.is_catalog" default="1">
    </cfif>
	<cfparam name="attributes.product_status" default="1">
	
	<cfparam name="attributes.page" default="1">
	<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    
	<cfset cmp = createObject("component","V16.worknet.query.worknet_product") />
	<cfset getProduct = cmp.getProduct(
			is_online:attributes.is_online,
			is_catalog:attributes.is_catalog,
			product_status:attributes.product_status,
			keyword:attributes.keyword,
			product_cat:attributes.product_cat,
			product_catid:attributes.product_catid,
			company_id:attributes.company_id,
			company_name:attributes.company_name,
			firm_type:attributes.firm_type,
			sector:attributes.sector,
			photo_status:attributes.photo_status,
			country:attributes.country,
			city:attributes.city,
			county:attributes.county
	) />
    
	<cfparam name="attributes.totalrecords" default="#getProduct.recordcount#">
	
	<div class="haber_liste">
		<div class="haber_liste_1">
			<cfform name="search" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
				<div class="haber_liste_11"><h1><cfif attributes.fuseaction contains 'product'><cf_get_lang_main no='152.ÜRÜNLER'><cfelse><cf_get_lang no='182.Kataloglar'></cfif> <cfif getProduct.recordcount>(<cfoutput>#getProduct.recordcount#</cfoutput>)</cfif></h1></div>
				<div class="haber_liste_12" style="width:32px;">
					<input class="arama_btn" name="" type="submit" value="" style=" border:none;">
				</div>
				<div class="haber_liste_12" style="width:210px;">
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" class="txt_10">
				</div>
			</cfform>
		</div>
		<div class="forum_1">
			<cfif isdefined('attributes.content_head_id') and len(attributes.content_head_id)>
				<samp style="width:720px;">
					<cfoutput>#createObject("component","worknet.objects.worknet_objects").getContent(content_id:attributes.content_head_id)#</cfoutput>
				</samp>
			</cfif>
			<div class="forum_1">
				<cfif attributes.fuseaction contains 'product'>
					<div class="dashboard_162_duzenle" style="margin-bottom:4px;float:right;"><a href="add_product"><span><samp><cf_get_lang_main no='1613.Ürün Ekle'></samp></span></a></div>
				<cfelse>
					<div class="dashboard_162_duzenle" style="margin-bottom:4px;float:right;"><a href="form_catalog"><span><samp><cf_get_lang no='175.Katalog Ekle'></samp></span></a></div>
				</cfif>
			</div>
		</div>
		<div class="haber_liste_2">
			<cfif getProduct.recordcount>
			<cfoutput query="getProduct" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
				<div class="haber_liste_21">
					<div class="uhaber_liste_211">
						<cfif attributes.fuseaction contains 'product'>
	                        <a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_product&pid=#product_id#">
                        <cfelse>
                        	<cfset getRelationAsset = createObject("component","V16.worknet.query.worknet_asset").getRelationAsset(action_id:product_id) />
                            <a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_catalog&pid=#product_id#" title="#product_name#" target="_blank">
                        </cfif>
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
							<cfif attributes.fuseaction contains 'product'>
                                <a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_product&pid=#product_id#">
                            <cfelse>
                                <cfset getRelationAsset = createObject("component","V16.worknet.query.worknet_asset").getRelationAsset(action_id:product_id) />
                                <a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_catalog&pid=#product_id#" title="#product_name#" target="_blank">
                            </cfif>
                            <b>
								<cfif len(attributes.keyword)>
									#createObject("component","worknet.objects.worknet_objects").highLightText(product_name,attributes.keyword,250,'<font color="000000" style="background-color:yellow; font-weight:bold;"></font>')#
								<cfelse>
									#product_name#
								</cfif>
							</b>
							</a>
							<samp><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_member&cpid=#company_id#" style="font-size:12px;color:A4A4A4; font-weight:bold;">#fullname#-#partner_name#</a></samp>
						</div>                        
						<div class="uhaber_liste_2122">
							<cfset hierarchy_ = "">
							<cfset new_name = "">
							<cfloop list="#getProduct.HIERARCHY#" delimiters="." index="hi">
								<cfset hierarchy_ = ListAppend(hierarchy_,hi,'.')>
								<cfset getCat = cmp.getMainProductCat(hierarchy:hierarchy_)>
								<cfset new_name = ListAppend(new_name,getCat.PRODUCT_CAT,'>')>
							</cfloop>
							<a href="#request.self#?fuseaction=#attributes.fuseaction#&product_catid=#product_catid#&product_cat=#new_name#" title="#new_name#">#new_name#</a>
						</div>
					</div>
					<div class="uhaber_liste_213">
						<div class="uhaber_liste_2131">
							<cfset getMemberStatus = createObject("component","worknet.objects.worknet_objects").getMemberStatus(
								member_id:company_id,
								member_type:'company'
							)>
							<a href="#request.self#?fuseaction=#attributes.fuseaction#&company_id=#company_id#&company_name=#fullname#"><br />
                            	<cfif attributes.fuseaction contains 'product'>
	                                <cf_get_lang no='131.Tüm Ürünler'>
                                <cfelse>
                                	<cf_get_lang no='181.Tüm Kataloglar'>
                                </cfif>
                            </a>
						</div>
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
						<cfif len(attributes.product_cat)>
							<cfoutput><b>#attributes.product_cat#</b> :</cfoutput>
						</cfif>
						<cf_get_lang_main no='72.Kayıt Bulunamadı'>!
					</div>
				</div>
			</cfif>
		</div>
		<div class="maincontent">
			<cfif attributes.totalrecords gt attributes.maxrows>
				<cfset url_str = "">
				<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
					<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
				</cfif>
				<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
					<cfset url_str = "#url_str#&company_id=#attributes.company_id#&company_name=#attributes.company_name#">
				</cfif>
				<cfif isDefined("attributes.product_catid") and len(attributes.product_catid)>
					<cfset url_str = "#url_str#&product_cat=#attributes.product_cat#&product_catid=#attributes.product_catid#">
				</cfif>
				<cfif isDefined("attributes.is_online") and len(attributes.is_online)>
					<cfset url_str = "#url_str#&is_online=#attributes.is_online#">
				</cfif>
				<cfif isDefined("attributes.is_catalog") and len(attributes.is_catalog)>
					<cfset url_str = "#url_str#&is_catalog=#attributes.is_catalog#">
				</cfif>
				<cfif isDefined("attributes.product_status") and len(attributes.product_status)>
					<cfset url_str = "#url_str#&product_status=#attributes.product_status#">
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
				<cfif isDefined("attributes.firm_type") and len(attributes.firm_type)>
					<cfset url_str = "#url_str#&firm_type=#attributes.firm_type#">
				</cfif>
				<cfif isDefined("attributes.photo_status") and len(attributes.photo_status)>
					<cfset url_str = "#url_str#&photo_status=#attributes.photo_status#">
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
<!---<cfelseif isdefined("session.ww.userid")>
	<script>
		alert('Bu sayfaya erişmek için firma çalışanı olarak giriş yapmanız gerekmektedir!');
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cfinclude template="member_login.cfm">
</cfif>--->
