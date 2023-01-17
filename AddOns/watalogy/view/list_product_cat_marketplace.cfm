<cfset sayfa_ad = "list_product_cat_detail">
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../../../V16/product/query/get_product_cat_list.cfm">
<cfelse>
	<cfset productcats.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.our_company" default="#session.ep.company_id#">
<cfparam name="attributes.totalrecords" default="#productcats.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	
<cfinclude template="../../../V16/product/query/get_product_cat.cfm">
<cfform name="search_product" action="#request.self#?fuseaction=protein.list_product_cat_marketplace" method="post">
<input type="hidden" name="form_submitted" id="form_submitted" value="1">
<cf_big_list_search title="#getLang('main',155)#"> 
	<cf_big_list_search_area>
    	<div class="row">
        	<div class="col col-12 form-inline">
            	<div class="form-group">
                	<div class="input-group">
                    	<label><cfoutput>#getLang('product',583)#</cfoutput></label>
                        <label><input type="checkbox" name="class_category" id="class_category" value="1" <cfif isdefined("attributes.class_category")>checked</cfif>></label>
                    </div>
                </div>
                <div class="form-group">
                	<div class="input-group">
                    	<cfinput type="text" name="keyword" placeholder="#getlang('main',48)#" id="keyword" maxlength="50" style="width:100px;" value="#attributes.keyword#">
                    </div>
                </div>
                <div class="form-group">
                	<div class="input-group x-15">
                    	<select name="cat" id="cat" style="width:225px;">
                            <option value="" selected><cf_get_lang_main no='725.Kategoriler'></option>
                            <cfoutput query="get_product_cat">
                                <option value="#hierarchy#" <cfif isDefined("attributes.cat") and attributes.cat is hierarchy and len(attributes.cat) eq len(hierarchy)>selected</cfif>>#hierarchy#-#product_cat#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                	<div class="input-group">
                    	<cfquery name="get_our_company" datasource="#dsn#">
                            SELECT COMP_ID,NICK_NAME FROM OUR_COMPANY
                        </cfquery>
                        <select name="our_company" id="our_company" style="width:150px;">
                            <option value=""><cf_get_lang_main no='1734.Şirketler'></option>
                            <cfoutput query="get_our_company">
                                <option value="#comp_id#" <cfif attributes.our_company eq comp_id>selected</cfif>>#nick_name#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                	<div class="input-group x-3_5">
                    	<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" onKeyUp="isNumber(this);" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                    </div>
                </div>
                <div class="form-group">
                	<div class="input-group x-3_5">
                    	<cf_wrk_search_button>
                        <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                    </div>
                </div>
            </div>
        </div>
	</cf_big_list_search_area>
</cf_big_list_search> 
</cfform>
<cf_big_list>
	<thead>
		<tr>
			<th colspan="3">&nbsp;</th>
			<th colspan="2"><img src="/images/pazaryeri/gittigidiyor.png" height="20"> Gittigidiyor</th>
			<th colspan="2"><img src="/images/pazaryeri/n11.png" height="20"> N11</th>
			<th colspan="2"><img src="/images/pazaryeri/hepsiburada.png" height="20"> Hepsiburada</th>
			<th colspan="2"><img src="/images/pazaryeri/sahibinden.png" height="20"> Sahibinden</th>
			<th colspan="2"><img src="/images/pazaryeri/amazon.png" height="20"> Amazon</th>
			<!---<th colspan="2"><img src="/images/pazaryeri/pttavm.png" height="20"> PttAvm</th>--->
			<!-- sil -->
			<th class="header_icn_none" <cfif productcats.recordcount neq 0>colspan="2"</cfif> style="text-align:center; width:30px;"></th>
			<!-- sil -->
		</tr>
		<tr>
			<th style="width:15px;"><cf_get_lang_main no='1165.Sıra'></th>
			<th style="width:75px;"><cf_get_lang_main no='1173.Kod'></th>
			<th><cf_get_lang_main no='74.Kategori'></th>
			<th><cf_get_lang_main no='1173.Kod'></th>
			<th><cf_get_lang_main no='74.Kategori'></th>
			<th><cf_get_lang_main no='1173.Kod'></th>
			<th><cf_get_lang_main no='74.Kategori'></th>			
			<th><cf_get_lang_main no='1173.Kod'></th>
			<th><cf_get_lang_main no='74.Kategori'></th>			
			<th><cf_get_lang_main no='1173.Kod'></th>
			<th><cf_get_lang_main no='74.Kategori'></th>			
			<th><cf_get_lang_main no='1173.Kod'></th>
			<th><cf_get_lang_main no='74.Kategori'></th>
			<!---<th><cf_get_lang_main no='1173.Kod'></th>
			<th><cf_get_lang_main no='74.Kategori'></th>--->
			<!-- sil -->
			<th class="header_icn_none" <cfif productcats.recordcount neq 0>colspan="2"</cfif> style="text-align:center; width:30px;"><a href="<cfoutput>#request.self#?fuseaction=product.list_product_cat&event=add</cfoutput>"><img src="/images/plus_list.gif" title="<cf_get_lang no='146.Ürün Kategorisi Ekle'>"></a></th>
			<!-- sil -->
		</tr>
	</thead>
	<tbody>
		<cfif productcats.recordcount>
		  <cfoutput query="productcats" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfscript>
					marketplace = createObject("component","AddOns.watalogy.cfc.marketplace");
					marketplace.dsn = dsn;
					marketplace.dsn1 = dsn1;
					get_market_place_product_catid = marketplace.get_market_place_product_cat_fnc(productcats.product_catid);
				</cfscript>
			<tr>
				<td><a href="#request.self#?fuseaction=product.list_product_cat&event=upd&ID=#productcats.product_catid#" class="tableyazi">#productcats.currentrow#</a></td>
				<td>#hierarchy#</td>
				<td><cfloop from="1" to="#listlen(hierarchy,'.')#" index="i">&nbsp;</cfloop><a href="#request.self#?fuseaction=product.list_product_cat&event=upd&ID=#product_CatID#" class="tableyazi">#product_cat#</a></td>
				<td style="text-align:right;">#get_market_place_product_catid.gittigidiyor_hierarchy#</td>
				<td style="text-align:right;">#get_market_place_product_catid.gittigidiyor_product_cat#</td>
				<td style="text-align:right;">#get_market_place_product_catid.n11_hierarchy#</td>
				<td style="text-align:right;">#get_market_place_product_catid.n11_product_cat#</td>
				<td style="text-align:right;">#get_market_place_product_catid.hepsiburada_hierarchy#</td>
				<td style="text-align:right;">#get_market_place_product_catid.hepsiburada_product_cat#</td>
				<td style="text-align:right;">#get_market_place_product_catid.sahibinden_hierarchy#</td>
				<td style="text-align:right;">#get_market_place_product_catid.sahibinden_product_cat#</td>
				<td style="text-align:right;">#get_market_place_product_catid.amazon_hierarchy#</td>
				<td style="text-align:right;">#get_market_place_product_catid.amazon_product_cat#</td>
				<!---<td style="text-align:right;">#get_market_place_product_catid.pttavm_hierarchy#</td>
				<td style="text-align:right;">#get_market_place_product_catid.pttavm_product_cat#</td>--->
				<!-- sil -->
				<td style="width:15px;"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=protein.popup_upd_marketplace_product_cat&product_catid=#product_catid#','list');"><img src="/images/update_list.gif" title="<cf_get_lang_main no='52.guncelle'>"></a></td>
				<!-- sil -->
			</tr>
		  </cfoutput>
		<cfelse>
			<tr>
				<td colspan="7"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Yok'> !<cfelse><cf_get_lang_main no='289.Filte Ediniz'></cfif></td>
			</tr>
		</cfif>
	</tbody>
</cf_big_list>
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
<cf_paging page="#attributes.page#"
	maxrows="#attributes.maxrows#"
	totalrecords="#attributes.totalrecords#"
	startrow="#attributes.startrow#"
	adres="#adres#">
<script type="text/javascript">
	$('#keyword').focus();
</script>

