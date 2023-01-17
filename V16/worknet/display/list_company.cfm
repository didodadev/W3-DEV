<cf_get_lang_set module_name="member"><!--- sayfanin en altinda kapanisi var --->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.watalogy_code" default="">
<cfparam name="attributes.marketplace" default="">
<cfparam name="attributes.is_potential" default="">
<cfparam name="attributes.company_status" default="1">
<cfparam name="attributes.company_stage" default="">
<cfparam name="attributes.sector" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.companycat_id" default="">
<cfparam name="attributes.firm_type" default="">
<cfparam name="attributes.country" default="">
<cfparam name="attributes.city" default="">
<cfparam name="attributes.county" default="">
<cfparam name="attributes.is_related_company" default="">
<cfparam name="attributes.logo_status" default="">
<cfparam name="attributes.search_type" default="1">
<cfparam name="attributes.sortfield" default="FULLNAME">
<cfparam name="attributes.sortdir" default="asc">

<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfset cmp = createObject("component","V16.worknet.cfc.worknet_add_member") />
<cfset getProcess = createObject("component","V16.worknet.cfc.worknet_process").getProcess(fuseaction:attributes.fuseaction)/>
<cfif isdefined('attributes.form_submitted') AND attributes.search_type eq 1><!--- sirket --->
	<cfset getCompany = cmp.getCompany(
			keyword:attributes.keyword,
			watalogy_code:attributes.watalogy_code,
			marketplace:attributes.marketplace,
			sector:attributes.sector,
			product_cat:attributes.product_cat,
			companycat_id:attributes.companycat_id,
			country:attributes.country,
			city:attributes.city,
			county:attributes.county,
			is_related_company:attributes.is_related_company,
			logo_status:attributes.logo_status,
			company_stage:attributes.company_stage,
			is_potential:attributes.is_potential,
			firm_type:attributes.firm_type,
			sortfield:attributes.sortfield,
			sortdir:attributes.sortdir,
			company_status:attributes.company_status
	) />
   	 <cfset getCompanyMember.recordcount = 0>
<cfelseif isdefined('attributes.form_submitted') AND attributes.search_type eq 0 ><!--- calisan --->
    <cfset getCompanyMember = cmp.getPartner(
			keyword:attributes.keyword,
			product_cat:attributes.product_cat,
			partner_country:attributes.country,
			partner_city:attributes.city,
			partner_county:attributes.county,
			sector:attributes.sector,
			companycat_id:attributes.companycat_id,
			logo_status:attributes.logo_status,
			company_stage:attributes.company_stage,
			is_potential:attributes.is_potential,
			is_related_company:attributes.is_related_company,
			firm_type:attributes.firm_type
	) />
   <cfset getCompany.recordcount = 0>
<cfelse>
	<cfset getCompany.recordcount = 0>
    <cfset getCompanyMember.recordcount = 0>
</cfif>
<cfif isdefined('attributes.form_submitted') AND attributes.search_type eq 1>
	<cfparam name="attributes.totalrecords" default="#getCompany.recordcount#">
 <cfelse>
	<cfparam name="attributes.totalrecords" default="#getCompanyMember.recordcount#">
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfform name="search_member" action="" method="post">
		<cf_box id="company_search" closable="0" collapsable="0"> 
			<cf_box_search>
				<input type="hidden" name="form_submitted" id="form_submitted" value="1">
				<div class="form-group medium">
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" placeholder="#getLang('main',48)#">
				</div>
				<div class="form-group">
					<cfinput type="text" name="watalogy_code" id="watalogy_code" value="#attributes.watalogy_code#" placeholder="#getLang('','Watalogy kod',63801)#">
				</div>
				<div class="form-group">
					<cfsavecontent variable="text"><cf_get_lang_main no='74.Kategori'></cfsavecontent>
					<cfif len(attributes.companycat_id)><cfset attributes.companycat_id = attributes.companycat_id><cfelse><cfset attributes.companycat_id = ''></cfif>
					<cf_wrk_MemberCat
						name="companycat_id"
						option_text="#text#"
						comp_cons=1 value="#attributes.companycat_id#" width="110">
				</div>
				<div class="form-group">
					<select name="company_stage" id="company_stage">
						<option value=""><cf_get_lang_main no='70.Aşama'></option>
						<cfoutput query="getProcess">
							<option value="#process_row_id#" <cfif attributes.company_stage eq process_row_id>selected</cfif>>#stage#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="company_status" id="company_status">
						<option value=""><cf_get_lang_main no ='344.Durum'></option>
						<option value="1" <cfif attributes.company_status eq 1>selected</cfif>><cf_get_lang_main no ='81.Aktif'></option>
						<option value="0" <cfif attributes.company_status eq 0>selected</cfif>><cf_get_lang_main no ='82.Pasif'></option>
					</select> 
				</div>
				<div class="form-group">
					<cfsavecontent variable="text"><cf_get_lang_main no='167.Sektör'></cfsavecontent>
						<cfif len(attributes.sector)><cfset attributes.sector = attributes.sector><cfelse><cfset attributes.sector = ''></cfif>
						<cf_wrk_selectlang 
							name="sector"
							option_name="sector_cat"
							option_value="sector_cat_id"
							width="120"
							table_name="SETUP_SECTOR_CATS"
							option_text="#text#" value="#attributes.sector#">
				</div>
				<div class="form-group">
					<select name="is_potential" id="is_potential">
						<option value=""><cf_get_lang_main no ='296.Tumu'></option>
						<option value="1" <cfif attributes.is_potential eq 1>selected</cfif>><cf_get_lang_main no='165.Potansiyel'></option>
						<option value="0" <cfif attributes.is_potential eq 0>selected</cfif>><cf_get_lang_main no ='649.Cari'></option>
					</select>
				</div>
				<div class="form-group">
					<label><cf_get_lang no='421.Bağlı Üye'><input type="checkbox" name="is_related_company" id="is_related_company" value="1" <cfif isdefined('attributes.is_related_company') and attributes.is_related_company eq 1>checked</cfif>></label>
						
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" is_excel="0">
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="form-group col col-4 col-md-4 col-sm-6 col-xs-12">
					<cfset wrk = createObject("component","V16.worknet.cfc.worknet")>
					<cfset get_all_marketplace = wrk.select(status : 1)>
					<select name="marketplace" id="get_all_marketplace">
						<option value=""><cf_get_lang dictionary_id='61344.Marketplaces'></option>
						<cfoutput query="get_all_marketplace">
							<option value="#WORKNET_ID#" <cfif attributes.marketplace eq WORKNET_ID>selected</cfif>>#WORKNET#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group col col-4 col-md-4 col-sm-6 col-xs-12">
					<cfsavecontent variable="firmType"><cf_get_lang_main no='1195.Firma'></cfsavecontent>
					<cfif len(attributes.firm_type)><cfset attributes.firm_type = attributes.firm_type><cfelse><cfset attributes.firm_type = ''></cfif>
					<cf_multiselect_check 
						table_name="SETUP_FIRM_TYPE"  
						name="firm_type"
						width="115" 
						option_text="#firmType#"
						option_name="firm_type" 
						option_value="firm_type_id" value="#attributes.firm_type#">
				</div>
				<div class="form-group col col-4 col-md-4 col-sm-6 col-xs-12">
					<cfset getCountry = cmp.getCountry() />
					<select name="country" id="country" onChange="change_city();">
						<option value="">Ülke</option>
						<cfoutput query="getCountry">
							<option value="#country_id#" <cfif attributes.country eq country_id>selected</cfif>>#country_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group col col-4 col-md-4 col-sm-6 col-xs-12">
					<select name="city" id="city" onChange="change_county();">
						<option value="">Şehir</option>
					</select> 
				</div>
				<div class="form-group col col-4 col-md-4 col-sm-6 col-xs-12">
					<select name="county" id="county">
						<option value="">İlçe</option>
					</select>
				</div>
				<div class="form-group col col-4 col-md-4 col-sm-6 col-xs-12">
					<select name="logo_status" id="logo_status">
						<option value=""><cf_get_lang_main no ='296.Tumu'></option>
						<option value="1" <cfif attributes.logo_status eq 1>selected</cfif>><cf_get_lang_main no ='1225.Logo'><cf_get_lang_main no ='1152.Var'></option>
						<option value="0" <cfif attributes.logo_status eq 0>selected</cfif>><cf_get_lang_main no ='1225.Logo'><cf_get_lang_main no ='1134.Yok'></option>
					</select> 
				</div>
				<div class="form-group col col-4 col-md-4 col-sm-6 col-xs-12">
					<select name="search_type" id="search_type">
						<option value="1" <cfif attributes.search_type eq 1>selected</cfif>><cf_get_lang_main no ='162.Şirket'></option>
						<option value="0" <cfif attributes.search_type eq 0>selected</cfif>><cf_get_lang_main no ='164.Çalışan'></option>
					</select>
				</div>
			</cf_box_search_detail>
		</cf_box>
	</cfform>
	
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='57417.Üyeler'></cfsavecontent>
	<cf_box id="company_list" title="#title#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<cfif attributes.search_type eq 1 AND getCompany.recordcount eq 0>
				<thead>
					<tr>
						<th style="width:20px;"><cf_get_lang_main no='75.No'></th>
						<th><cf_get_lang_main no='162.Şirket'></th>
						<th><cf_get_lang_main no='166.Yetkili'></th>
						<th><cf_get_lang dictionary_id='63801.Watalogy'></th>
						<th><cf_get_lang_main no='731.İletişim'></th>
						<th style="width:20px;" title="<cf_get_lang dictionary_id='61344.Marketplaces'>"><a href="javascript://"><i class="icon-globe"></i></a></th>
						<th style="width:20px;"><a href="index.cfm?fuseaction=worknet.form_list_company&event=add" title="<cf_get_lang_main no='170.Ekle'>"><i class="fa fa-plus"></i></a></th>
					</tr>
				</thead>
			</cfif>
			<cfif getCompany.recordcount>
				<thead>
					<tr>
						<th style="width:20px;"><cf_get_lang_main no='75.No'></th>
						<th><cf_get_lang_main no='162.Şirket'></th>
						<th><cf_get_lang_main no='166.Yetkili'></th>
						<th><cf_get_lang dictionary_id='63801.Watalogy'></th>
						<th><cf_get_lang_main no='731.İletişim'></th>
						<th style="width:20px;" title="<cf_get_lang dictionary_id='61344.Marketplaces'>"><a href="javascript://"><i class="icon-globe"></i></a></th>
						<th style="width:20px;"><a href="index.cfm?fuseaction=worknet.form_list_company&event=add" title="<cf_get_lang_main no='170.Ekle'>"><i class="fa fa-plus"></i></a></th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="getCompany" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
						<cfset getCompanyWorknet = cmp.getRelationWorknet(
							cpid:getCompany.COMPANY_ID
						) />
						<tr>
							<td>#currentrow#</td>
							<td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_list_company&event=upd&cpid=#company_id#" class="tableyazi">#fullname#</a></td>
							<td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.detail_partner&pid=#manager_partner_id#" class="tableyazi">#MANAGER_PARTNER#</a></td>
							<td>#getCompany.WATALOGY_MEMBER_CODE#</td>
							<td>#COMPANY_EMAIL#</td>
							<td>
								<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_list_company&event=popup_addWorknetRelation&cpid=#company_id#&form_submitted=1&draggable=1&logo_list=1','','ui-draggable-box-small')"><i class="icon-globe"></i></a>
							</td>
							<td><a href="index.cfm?fuseaction=worknet.form_list_company&event=upd&cpid=#company_id#" title="<cf_get_lang_main no='52.Güncelle'>"><i class="fa fa-pencil"></i></a></td>
						</tr>
					</cfoutput>
				</tbody>
			<cfelseif getCompanyMember.recordcount>
				<thead>
					<tr>
						<th style="width:20px;"><cf_get_lang_main no='75.No'></th>
						<th><cf_get_lang_main no='164.Çalışan'></th>
						<th><cf_get_lang_main no='162.Şirket'></th>
						<th><cf_get_lang_main no='161.Görev'></th>
						<th><cf_get_lang_main no='160.Departman'></th>
						<th><cf_get_lang_main no='731.İletişim'></th>
						<th style="width:20px;"><a href="index.cfm?fuseaction=worknet.form_list_company&event=add" title="<cf_get_lang_main no='170.Ekle'>"><i class="fa fa-plus"></i></a></th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="getCompanyMember" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
						<tr>
							<td>#currentrow#</td>
							<td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.detail_partner&pid=#partner_id#" class="tableyazi" >#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME#</a></td>
							<td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_list_company&event=upd&cpid=#COMPANY_ID#" class="tableyazi" >#FULLNAME#</a></td>
							<td>#PARTNER_POSITION#</td>
							<td><cfif Len(department)>#PARTNER_DEPARTMENT#</cfif></td>
							<td>
								<ul class="ui-icon-list">
									<cfif len(COMPANY_PARTNER_EMAIL)>
										<li><a href="mailto:#COMPANY_PARTNER_EMAIL#" title="<cf_get_lang_main no='16.E-mail'>:#COMPANY_PARTNER_EMAIL#" ><i class="fa fa-envelope"></i></a></li>
									</cfif>
									<cfif len(COMPANY_PARTNER_TEL)>
										<li><a href="javascript://" title="<cf_get_lang_main no='87.Telefon'>:#COMPANY_PARTNER_TELCODE# - #COMPANY_PARTNER_TEL# <cfif len(company_partner_tel_ext)>(#COMPANY_PARTNER_TEL_EXT#) </cfif>"><i class="fa fa-phone"></i></a></li>
									</cfif>
									<cfif len(COMPANY_PARTNER_FAX)>
										<li><a href="javascript://" title="<cf_get_lang_main no='76.Fax'>:#COMPANY_PARTNER_TELCODE# - #COMPANY_PARTNER_FAX#"><i class="fa fa-fax"></i></a></li>
									</cfif>
									<cfif len(MOBILTEL)>
										<li><a href="javascript://" title="<cf_get_lang no='116.Kod/Mobil Tel'>:#MOBIL_CODE# - #MOBILTEL#"><i class="fa fa-mobile-phone"></i></a></li>
									</cfif>
								</ul>
							</td>
							<td width="15"><a href="index.cfm?fuseaction=worknet.detail_partner&pid=#partner_id#" title="<cf_get_lang_main no='52.Güncelle'>"><i class="fa fa-pencil"></i></a></td>
						</tr>
					</cfoutput>
				</tbody>
			<cfelse>
				<tr><td colspan="7"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'>!</cfif></td></tr>
			</cfif>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset url_str = "">
			<cfif isDefined("attributes.form_submitted")>
				<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
			</cfif>
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.firm_type)>
				<cfset url_str = "#url_str#&firm_type=#attributes.firm_type#">
			</cfif>
			<cfif len(attributes.sector)>
				<cfset url_str = "#url_str#&sector=#attributes.sector#">
			</cfif>
			<cfif len(attributes.companycat_id)>
				<cfset url_str = "#url_str#&companycat_id=#attributes.companycat_id#">
			</cfif>
			<cfif len(attributes.company_status)>
				<cfset url_str = "#url_str#&company_status=#attributes.company_status#">
			</cfif>
			<cfif len(attributes.is_potential)>
				<cfset url_str = "#url_str#&is_potential=#attributes.is_potential#">
			</cfif>
			<cfif len(attributes.company_stage)>
				<cfset url_str = "#url_str#&company_stage=#attributes.company_stage#">
			</cfif>
			<cfif len(attributes.country)>
				<cfset url_str = "#url_str#&country=#attributes.country#">
			</cfif>
			<cfif len(attributes.city)>
				<cfset url_str = "#url_str#&city=#attributes.city#">
			</cfif>
			<cfif len(attributes.county)>
				<cfset url_str = "#url_str#&county=#attributes.county#">
			</cfif>
			<cfif len(attributes.is_related_company)>
				<cfset url_str = "#url_str#&is_related_company=#attributes.is_related_company#">
			</cfif>
			<cfif len(attributes.logo_status)>
				<cfset url_str = "#url_str#&logo_status=#attributes.logo_status#">
			</cfif>
			<cfif len(attributes.search_type eq 0)>
				<cfset url_str = "#url_str#&search_type=#attributes.search_type#">
			</cfif>
			<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#listgetat(attributes.fuseaction,1,'.')#.form_list_company#url_str#">
		</cfif>
	</cf_box>
</div>


<script type="text/javascript">
	function change_city()
	{
		var country_ = document.getElementById("country").value;
		if(country_.length)
			LoadCity(country_,'city','county',0);
	}
	function change_county()
	{
		var city_ = document.getElementById("city").value;
		if(city_.length)
			LoadCounty(city_,'county');
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
