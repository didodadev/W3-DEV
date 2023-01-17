<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.demand_type" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_catid" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company_name" default="">
<cfparam name="attributes.is_online" default="1">
<cfparam name="attributes.is_status" default="1">
<cfparam name="attributes.my_demand" default="0">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.sector" default="">
<cfparam name="attributes.country" default="">
<cfparam name="attributes.city" default="">
<cfparam name="attributes.county" default="">

<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif len(attributes.start_date)><cf_date tarih = "attributes.start_date"></cfif>
<cfif len(attributes.finish_date)><cf_date tarih = "attributes.finish_date"></cfif>

<cfset cmp = createObject("component","V16.worknet.query.worknet_demand") />
<cfset getDemand = cmp.getDemand(
		my_demand:attributes.my_demand,
		is_online:attributes.is_online,
		is_status:attributes.is_status,
		keyword:attributes.keyword,
		demand_type:attributes.demand_type,
		product_cat:attributes.product_cat,
		product_catid:attributes.product_catid,
		company_id:attributes.company_id,
		company_name:attributes.company_name,
		start_date:attributes.start_date,
		finish_date:attributes.finish_date,
		sector:attributes.sector,
		country:attributes.country,
		city:attributes.city,
		county:attributes.county
	) 
/>
<cfparam name="attributes.totalrecords" default="#getDemand.recordcount#">
<div class="haber_liste">
	<div class="haber_liste_1">
		<cfform name="search_demand" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_demand" method="post">
			<div class="haber_liste_11"><h1><cf_get_lang_main no='115.TALEPLER'> <cfif getDemand.recordcount>(<cfoutput>#getDemand.recordcount#</cfoutput>)</cfif></h1></div>
			<div class="haber_liste_12" style="width:32px;">
				<input class="arama_btn" name="" type="submit" value="" style=" border:none;">
			</div>
			<div class="haber_liste_12" id="dateBetween" style="width:180px;margin-right: 1px;">
				<input type="text" name="start_date" id="start_date" value="<cfif len(attributes.start_date)><cfoutput>#dateformat(attributes.start_date,dateformat_style)#</cfoutput></cfif>" maxlength="10" style="width:70px; float:left;height: 25px;">
				<cf_wrk_date_image date_field="start_date">
				<input type="text" name="finish_date" id="finish_date" value="<cfif len(attributes.finish_date)><cfoutput>#dateformat(attributes.finish_date,dateformat_style)#</cfoutput></cfif>" maxlength="10" style="width:70px; float:left; margin-left:5px;height: 25px;">
				<cf_wrk_date_image date_field="finish_date">
			</div>
			<div class="haber_liste_12" style="margin-right:1px;">
				<select name="demand_type" id="demand_type" style="border:none;padding-bottom:3px; width:170px;">
					<option value=""><cf_get_lang no="81.Talep Türü"></option>
					<option value="1" <cfif attributes.demand_type eq 1>selected</cfif>><cf_get_lang no ='79.Alım'></option>
					<option value="2" <cfif attributes.demand_type eq 2>selected</cfif>><cf_get_lang no ='80.Satım'></option>
				</select>
			</div>
			<div class="haber_liste_12" id="demandKeyword" style="width:210px;margin-right: 5px;">
				<cfinput type="text" name="keyword" value="#attributes.keyword#" class="txt_10">
			</div>
		</cfform>
	</div>
	<div class="forum_1">
		<cfif isdefined('session.pp')>
			<cfif isdefined('attributes.content_head_id') and len(attributes.content_head_id)>
				<samp style="width:720px;">
					<cfoutput>#createObject("component","worknet.objects.worknet_objects").getContent(content_id:attributes.content_head_id)#</cfoutput>
				</samp>
			</cfif>
			<div class="dashboard_162_duzenle" style="margin-bottom:4px;float:right;"><a href="add_demand"><span><samp><cf_get_lang no='124.Talep Ekle'></samp></span></a></div>
		<cfelse>
			<cfif isdefined('attributes.content_head_id') and len(attributes.content_head_id)>
				<samp style="width:900px;">
					<cfoutput>#createObject("component","worknet.objects.worknet_objects").getContent(content_id:attributes.content_head_id)#</cfoutput>
				</samp>
			</cfif>
		</cfif>
	</div>

	<div class="haber_liste_2">
		<cfif getDemand.recordcount>
			<cfoutput query="getDemand" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
				<div class="haber_liste_21">
				<cfif isdefined('session.pp')>
					<div class="uhaber_liste_211">
						<a href="#request.self#?fuseaction=worknet.dsp_demand&demand_id=#demand_id#">
							<cfif len(ASSET_FILE_NAME1)>
								<cftry>
									<cfimage source="../../documents/member/#ASSET_FILE_NAME1#" name="myImage">
									<cfset imgInfo=ImageInfo(myImage)>
									<cfif imgInfo.width/imgInfo.height lt 100/70>
										<img src="../documents/member/#ASSET_FILE_NAME1#" height="70" />
									<cfelse>
										<img src="../documents/member/#ASSET_FILE_NAME1#" width="100" />
									</cfif>
									<cfcatch type="Any">
										<img src="/images/no_photo.gif" class="productImagea" height="70">
									</cfcatch>
								</cftry>
							<cfelse>
								<img src="/images/no_photo.gif" height="70">
							</cfif>
						</a>
					</div>
				</cfif>
					<div class="talep_liste_212">
						<span>#dateformat(start_date,dateformat_style)# <cfif len(finish_date)>- #dateformat(finish_date,dateformat_style)#</cfif></span>
						<a href="#request.self#?fuseaction=worknet.dsp_demand&demand_id=#demand_id#">
							<cfif demand_type eq 1><cf_get_lang no ='79.Alım'><cfelse><cf_get_lang no ='80.Satım'></cfif> - 
							<cfif len(attributes.keyword)>
								#createObject("component","worknet.objects.worknet_objects").highLightText(demand_head,attributes.keyword,250,'<font color="000000" style="background-color:yellow;font-size:18px; font:calibri;"></font>')#
							<cfelse>
								#demand_head#
							</cfif>
						</a>
                        <cfif isdefined('session.pp')>
	                        <samp><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_member&cpid=#company_id#" style="font-size:12px;color:A4A4A4; font-weight:bold;">#fullname#-#partner_name#</a></samp>
                        </cfif>
						<cfset getProductCat = cmp.getProductCat(demand_id:demand_id) />
						<cfif getProductCat.recordcount>
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
					<div class="uhaber_liste_213" style="float:right;">
						<div class="talep_detay_21">
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=worknet.popup_add_demand_offer&demand_id=#demand_id#','medium')"><font color="FFFFFF" style="font-size:20px;"><cf_get_lang no='105.TEKLİF VER'></font></a>
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
			<cfif isDefined("attributes.demand_type") and len(attributes.demand_type)>
				<cfset url_str = "#url_str#&demand_type=#attributes.demand_type#">
			</cfif>
			<cfif isDefined("attributes.is_online") and len(attributes.is_online)>
				<cfset url_str = "#url_str#&is_online=#attributes.is_online#">
			</cfif>
			<cfif isDefined("attributes.is_status") and len(attributes.is_status)>
				<cfset url_str = "#url_str#&is_status=#attributes.is_status#">
			</cfif>
			<cfif isDefined("attributes.my_demand") and len(attributes.my_demand)>
				<cfset url_str = "#url_str#&my_demand=#attributes.my_demand#">
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
			<cfif isDefined("attributes.start_date") and len(attributes.start_date)>
				<cfset url_str = "#url_str#&start_date=#attributes.start_date#">
			</cfif>
			<cfif isDefined("attributes.finish_date") and len(attributes.finish_date)>
				<cfset url_str = "#url_str#&finish_date=#attributes.finish_date#">
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
