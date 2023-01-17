<cfset attributes.branch_id = listgetat(session.ep.user_location, 2, '-')>
<cfinclude template="../query/get_branch_values.cfm">
<cfset dep_ids = ValueList(get_branch_departments.department_id,",")>
<cfquery name="GET_COMPETITIVE_LIST" datasource="#DSN3#">
	SELECT 
		COMPETITIVE_ID
	FROM
		PRODUCT_COMP_PERM 
	WHERE 
		POSITION_CODE = #session.ep.position_code#
</cfquery>
<cfset competitive_list = ValueList(get_competitive_list.competitive_id)>
<cfif isDefined("url.id")>
	<cfquery name="GET_PRODUCT_CAT" datasource="#DSN3#">
		SELECT 
			PRODUCT_CATID, 
			HIERARCHY, 
			PRODUCT_CAT 
		FROM 
			PRODUCT_CAT
		WHERE 
			PRODUCT_CATID = #url.id#
	</cfquery>
</cfif>
<cfinclude template="../query/get_price_cat_id.cfm">
<cfif not isDefined("attributes.price_catid") and len(get_price_cat_id.price_catid)>
	<cfset attributes.price_catid = -2>	<!--- get_price_cat_id.price_catid --->
<cfelseif not isDefined("attributes.price_catid")>
	<cfset attributes.price_catid = 0>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.barcod" default="">
<cfparam name="attributes.stock_code" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_hier" default="0">
<cfif isdefined("attributes.form_varmi")>
	<cfinclude template="../query/get_product_prices.cfm">
	<cfparam name="attributes.totalrecords" default="#get_product.recordcount#">
</cfif>
<cfparam name="attributes.page" default=1>
<cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
	<cfset attributes.maxrows = session.ep.maxrows>
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="100%" border="0" cellspacing="1" cellpadding="2" height="35" align="center">
	<tr>
		<cfsavecontent variable="title_">
			<cfif isdefined("attributes.id")>
				<cfoutput>#get_product_cat.product_cat#</cfoutput>
			<cfelse>
				<cf_get_lang_main no='1614.Fiyatlar'>
			</cfif>
		</cfsavecontent>
		<!-- sil -->
		<td valign="bottom">
			<cfform name="search_product" action="#request.self#?fuseaction=store.prices" method="post">
			<input name="form_varmi" id="form_varmi" type="hidden" value="1">
				<cf_big_list_search title="#title_#"> 
					<cf_big_list_search_area>
						<table>
							<tr>
								<td><cf_get_lang_main no='48.Filtre'></td>
								<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
								<td><cf_get_lang_main no ='106.Stok Kodu'></td>
								<td><cfinput type="text" name="stock_code" style="width:100px;" value="#attributes.stock_code#" maxlength="255"></td>
								<td><cf_get_lang_main no='221.Barkod'></td>
								<td><cfinput type="text" name="barcod" style="width:100px;" value="#attributes.barcod#" maxlength="255"></td>						
								<td><cf_get_lang_main no='74.Kategori'></td>
								<td>
									<input type="hidden" name="product_hier" id="product_hier" value="<cfoutput>#attributes.product_hier#</cfoutput>">
									<input type="text" name="product_cat" id="product_cat" style="width:120px;" value="<cfoutput>#attributes.product_cat#</cfoutput>">
									<a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&<cfif session.ep.our_company_info.workcube_sector is 'per'>is_sub_category=3&</cfif>field_code=search_product.product_hier&field_name=search_product.product_cat</cfoutput>&keyword='+encodeURIComponent(document.search_product.product_cat.value));"><img src="/images/plus_thin.gif" align="absbottom" title="<cf_get_lang no='165.Ürün Kategorisi Seç '>!"></a>
								</td>
								<td>
									<select name="price_catid" id="price_catid">
										<option value=""><cf_get_lang_main no='1552.Fiyat Listesi'></option>
										<option value="-2" <cfif isDefined("attributes.price_catid") and (attributes.price_catid eq -2)>selected </cfif>> <cf_get_lang_main no='1309.Standart Satış'></option>
										<cfoutput query="get_price_cat_id">
											<option value="#price_catid#" <cfif isDefined("attributes.price_catid") and (get_price_cat_id.price_catid eq attributes.price_catid)>selected</cfif>>#price_cat#</option>
										</cfoutput>
									</select>
								</td>
								<td>
									<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
									<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,100" required="yes" message="#message#" maxlength="3" style="width:25px;">
								</td>
								<td><cf_wrk_search_button></td>
								<td>
									<cfif get_module_user(47)>
										<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_collected_barcode&is_branch=1','medium');"><img src="/images/barcode_print.gif" title="<cf_get_lang no='115.Toplu Barkod Yazdır'>"></a>
									</cfif>
								</td>
								<td>
									<cfif get_module_user(47)>
										<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_barcod_search','medium');"><img src="/images/barcode.gif"></a>
									</cfif>
								</td>
							<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
							</tr>
						</table>
					</cf_big_list_search_area>
				</cf_big_list_search>			
			</cfform>
			<cf_big_list>
				<thead>
					<tr>
						<th width="130"><cf_get_lang_main no='106.Stok Kodu'></th>
						<th width="100"><cf_get_lang_main no='221.Barkod'></th>
						<th><cf_get_lang_main no='245.Ürün'></th>
						<th><cf_get_lang_main no='1552.Fiyat Listesi'></th>
						<th style="text-align:right;"><cf_get_lang_main no='672.Fiyat'></th>
						<th width="125" style="text-align:right;" <cfif not isdefined("attributes.trail")>colspan="2"</cfif>><cf_get_lang_main no='672.Fiyat'>(<cf_get_lang no='79.kdv dahil'>)</th>
						<th width="40"><cf_get_lang_main no='224.Birim'></th>
						<th width="65"><cf_get_lang no='102.Tarihi'></th>
						<th class="header_icn_none"></th>

					</tr>
				</thead>
				<tbody>
					<cfif isdefined("attributes.form_varmi") and get_product.recordcount>
						<cfoutput query="get_product" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<tr>
								<td height="20"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#','list');" class="tableyazi">#get_product.product_code#</a></td>
								<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#','list');" class="tableyazi">#get_product.barcod#</a></td>
								<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#','list');" class="tableyazi">#get_product.product_name# - #get_product.property#</a></td>
								<td>#pricecat#</td>
								<td style="text-align:right;"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#','list');" class="tableyazi">#TLFormat(get_product.price)#&nbsp;#get_product.money#</a></td>
								<td style="text-align:right;"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#','list');" class="tableyazi"><cfif get_product.is_kdv eq 1>#TLFormat(get_product.price_kdv)#&nbsp;#money#<cfelse>#TLFormat(get_product.price*(100+get_product.tax)/100)#&nbsp;#get_product.money#</cfif></a></td>
								<!-- sil -->
								<td width="8" style="text-align:right;">
								<cfif len(get_product.PROD_COMPETITIVE)>
									<cfif listfind(COMPETITIVE_LIST,get_product.PROD_COMPETITIVE,",")>
										<cfset str_url_open = "store.popup_add_price&pid=#get_product.product_id[currentrow]#&price_catid=#attributes.price_catid#">
									<cfelse>
										<cfset str_url_open = "store.popup_add_price_request&pid=#get_product.product_id[currentrow]#&price_catid=#attributes.price_catid#">
									</cfif>
								<cfelse>
									<cfset str_url_open = "store.popup_add_price_request&pid=#get_product.product_id[currentrow]#&price_catid=#attributes.price_catid#">
								</cfif>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#str_url_open#','small');"><img src="/images/plus_thin.gif"></a>
								</td>
								<!-- sil -->
								<td>#get_product.add_unit#</td>
								<td>#dateformat(get_product.record_date,dateformat_style)# </td>
								<!-- sil -->
								<td width="20" align="center"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_barcode&barcod=#BARCOD#&price_catid=#attributes.PRICE_CATID#&main_unit_id=#PRODUCT_UNIT_ID#&product_id=#PRODUCT_ID#&first','small','popup_barcode');"><img src="/images/barcode.gif"></a></td>
								<!-- sil -->
							</tr>
						</cfoutput>
					<cfelse>
					<cfif not isdefined("attributes.trail")>
						<cfset colspan = "10">
					<cfelse>
						<cfset colspan = "9">
					</cfif>
						<tr class="color-row">
							<td colspan="<cfoutput>#colspan#</cfoutput>" height="20"><cfif isdefined("attributes.form_varmi") ><cf_get_lang_main no='72.Kayıt Yok'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'>!</cfif></td>
						</tr>
					</cfif>
				</tbody>
			</cf_big_list>
			<cfif isdefined("attributes.form_varmi") and attributes.maxrows lt attributes.totalrecords>
				<table cellpadding="0" cellspacing="0" border="0" width="98%" height="35" align="center">
					<tr>
						<td>
						<cfset adres = "store.prices">
						<cfif isDefined('attributes.product_cat') and len(attributes.product_cat)>
							<cfset adres = '#adres#&product_cat=#attributes.product_cat#'>
						</cfif>
						<cfif isDefined('attributes.product_hier') and len(attributes.product_hier)>
							<cfset adres = '#adres#&product_hier=#attributes.product_hier#'>
						</cfif>
						<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
							<cfset adres = '#adres#&keyword=#attributes.keyword#'>
						</cfif>
						<cfif isDefined('attributes.barcod') and len(attributes.barcod)>
							<cfset adres = '#adres#&barcod=#attributes.barcod#'>
						</cfif>
						<cfif isDefined('attributes.stock_code') and len(attributes.stock_code)>
							<cfset adres = '#adres#&stock_code=#attributes.stock_code#'>
						</cfif>
						<cfif isDefined('attributes.price_catid') and len(attributes.price_catid)>
							<cfset adres = '#adres#&price_catid=#attributes.price_catid#'>
						</cfif>
							<cf_pages page="#attributes.page#" 
							maxrows="#attributes.maxrows#"
							totalrecords="#attributes.totalrecords#"
							startrow="#attributes.startrow#"
							adres="#adres#&form_varmi=1"> </td>
						<!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> </td><!-- sil -->
					</tr>
				</table>
			</cfif>
		</td>
	</tr>
</table>
<script type="text/javascript">
	document.getElementById('keyword').focus();		
</script>
