<cfparam name="attributes.show" default="">
<cf_xml_page_edit fuseact="product.list_product_cat">
<cfset sayfa_ad = "list_product_cat_detail">
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_product_cat_list.cfm">
<cfelse>
	<cfset productcats.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default="">
<cfif isdefined("xml_authority_situation") and xml_authority_situation eq 1>
	<cfparam name="attributes.our_company" default="">
<cfelse>
	<cfparam name="attributes.our_company" default="#session.ep.company_id#">
</cfif>

<cfparam name="attributes.totalrecords" default="#productcats.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfinclude template="../query/get_product_cat.cfm">
<cfset company_cmp = createObject("component","V16.member.cfc.member_company")>
<cfset cmp = createObject("component","V16/settings/cfc/watalogyWebServices")>
<cfset GET_OUR_COMPANY_INFO = company_cmp.GET_OURCMP_INFO()>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="search_product" action="#request.self#?fuseaction=product.list_product_cat" method="post">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">	
			<cf_box_search more="0">
				<div class="form-group">
					<label><input type="checkbox" name="class_category" id="class_category" value="1" <cfif isdefined("attributes.class_category")>checked</cfif>><cf_get_lang dictionary_id='37594.Sadece Ana Kategoriler'></label>				
				</div>
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" placeholder="#message#" id="keyword" maxlength="50" value="#attributes.keyword#">
				</div>
				<div class="form-group large">
					<select name="cat" id="cat">
						<option value="" selected><cf_get_lang dictionary_id='58137.Kategoriler'></option>
						<cfoutput query="get_product_cat">
							<option value="#hierarchy#" <cfif isDefined("attributes.cat") and attributes.cat is hierarchy and len(attributes.cat) eq len(hierarchy)>selected</cfif>>#hierarchy#-#product_cat#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<cfquery name="get_our_company" datasource="#dsn#">
						SELECT COMP_ID,NICK_NAME FROM OUR_COMPANY
					</cfquery>
					<select name="our_company" id="our_company">
						<option value=""><cf_get_lang dictionary_id='29531.Şirketler'></option>
						<cfoutput query="get_our_company">
							<option value="#comp_id#" <cfif attributes.our_company eq comp_id>selected</cfif>>#nick_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber(this);" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<select name="show" id="show">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<option value="1" <cfif attributes.show eq 1>selected</cfif>><cf_get_lang dictionary_id='37161.Web de Göster'></option>
						<option value="2" <cfif attributes.show eq 2>selected</cfif>><cf_get_lang dictionary_id='65171.Whops da Göster'></option>
						<option value="3" <cfif attributes.show eq 3>selected</cfif>><cf_get_lang dictionary_id='37342.Konfigüre edilebilir'></option>
					</select>
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>				
				<div class="form-group">
					<a class="ui-btn ui-btn-gray" href="<cfoutput>#request.self#</cfoutput>?fuseaction=product.list_product_cat&event=add"><i class="fa fa-plus"></i></a>
				</div>				
			</cf_box_search> 
		</cfform>
	</cf_box>
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='57567.Ürün Kategorileri'></cfsavecontent>
	<cf_box title="#head#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='58585.Kod'></th>
					<th><cf_get_lang dictionary_id='57486.Kategori'></th>
					<cfif GET_OUR_COMPANY_INFO.recordCount and GET_OUR_COMPANY_INFO.IS_WATALOGY_INTEGRATED eq 1><th width="300"><cf_get_lang dictionary_id='63801.Watalogy Code'></th></cfif>
					<th><cf_get_lang dictionary_id='37374.Min Marj'>(%)</th>
					<th><cf_get_lang dictionary_id='37375.Max Marj'>(%)</th>
					<th><cf_get_lang dictionary_id='37040.S D Tarihi'></th>
					<th width="20" class="text-center"><i class="fa fa-sort-numeric-asc" title="<cf_get_lang dictionary_id='37545.Listeleme Sırası'>"></i></th>
					<th width="20" class="text-center"><i class="fa fa-globe" style="color:#ff9800!important; cursor:default" title="<cf_get_lang dictionary_id='37161.Display on Web'>"></i></th>
					<th width="20" class="text-center"><i class="fa fa-shopping-basket" style="color:#1fca25!important; cursor:default" title="<cf_get_lang dictionary_id='65171.Display on Whops'>"></i></th>
					<th width="20" class="text-center"><i class="fa fa-wrench" style="color:#bf005f!important; cursor:default" title="<cf_get_lang dictionary_id='37342.Konfigüre edilebilir'>"></i></th>
					<th width="20" class="text-center"><a href="javascript://"><i class="fa fa-pencil"></i></a></th>
					<th width="20" class="text-center"><a href="<cfoutput>#request.self#?fuseaction=product.list_product_cat&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='37157.Ürün Kategorisi Ekle'>"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif productcats.recordcount>
				<cfoutput query="productcats" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td ><a href="#request.self#?fuseaction=product.list_product_cat&event=upd&ID=#productcats.product_catid#" class="tableyazi">#productcats.currentrow#</a></td>
						<td>#hierarchy#</td>
						<td><cfloop from="1" to="#listlen(hierarchy,'.')#" index="i">&nbsp;</cfloop><a href="#request.self#?fuseaction=product.list_product_cat&event=upd&ID=#product_CatID#" class="tableyazi">#product_cat#</a></td>
						<cfif GET_OUR_COMPANY_INFO.recordCount and GET_OUR_COMPANY_INFO.IS_WATALOGY_INTEGRATED eq 1>
							<td>
								<cfif len(WATALOGY_CAT_ID)>
									<cfset watalogy_cat_name="">
									<cfset get_watalogy_category = cmp.getWatalogyCategory(cat_id:WATALOGY_CAT_ID)>
									<cfloop query="get_watalogy_category">
										<cfset watalogy_cat_name = ListAppend(watalogy_cat_name,get_watalogy_category.hierarchy & ' '&get_watalogy_category.CATEGORY_NAME)>
									</cfloop>
									#watalogy_cat_name#
								</cfif>								
							</td>
						</cfif>
						<td>#tlformat(profit_margin)#</td>
						<td>#tlformat(profit_margin_max)#</td>
						<td><cfif isdate(update_date)>#dateformat(update_date,dateformat_style)#<cfelse>#dateformat(record_date,dateformat_style)#</cfif></td>
						<td class="text-center">#list_order_no#</td>
						<td class="text-center"><cfif is_public eq 1><i class="fa fa-globe" style="color:##ff9800!important; cursor:default" title="<cf_get_lang dictionary_id='37161.Display on Web'>"></i></cfif></td>
						<td class="text-center"><cfif is_cash_register eq 1><i class="fa fa-shopping-basket" style="color:##1fca25!important; cursor:default" title="<cf_get_lang dictionary_id='65171.Display on Whops'>"></i></cfif></td>		
						<td class="text-center"><cfif is_customizable eq 1><i class="fa fa-wrench" style="color:##bf005f!important; cursor:default" title="<cf_get_lang dictionary_id='37342.Konfigüre edilebilir'>"></i></cfif></td>
						<td><a href="#request.self#?fuseaction=product.list_product_cat&event=upd&id=#product_catid#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
						<td><a href="#request.self#?fuseaction=product.list_product_cat&event=add&ust_cat=#hierarchy#"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57986.Alt'> <cf_get_lang dictionary_id='37157.Ürün Kategorisi Ekle'>"></i></a></td>
					</tr>
				</cfoutput>
				<cfelse>
					<tr>
						<td colspan="12"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'> !<cfelse><cf_get_lang dictionary_id='57701.Filte Ediniz'></cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset adres = attributes.fuseaction>
		<cfif isDefined('attributes.cat') and len(attributes.cat)>
			<cfset adres = "#adres#&cat=#attributes.cat#">
		</cfif>
		<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
			<cfset adres = "#adres#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isDefined('attributes.class_category') and len(attributes.class_category)>
			<cfset adres = "#adres#&class_category=#attributes.class_category#">
		</cfif>
		<cfif isDefined('attributes.our_company') and len(attributes.our_company)>
			<cfset adres = "#adres#&our_company=#attributes.our_company#">
		</cfif>
		<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
			<cfset adres = "#adres#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cfif isdefined('attributes.show') and len(attributes.show)>
			<cfset adres = "#adres#&show=#attributes.show#">
		</cfif>
		
		<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#">
	</cf_box>
</div>
<script type="text/javascript">
	$('#keyword').focus();
	//document.getElementById('keyword').focus();
</script>

