<!--- bu sayfa ve iliskili sayfalardaki tum degisiklikler tum domainlerde calisacak sekilde yapilmalidir  --->
<cfif session.ep.isBranchAuthorization>
	<cfset attributes.branch_id = listgetat(session.ep.user_location,2,'-')>
</cfif>
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfif isdefined("attributes.is_submitted")>
	<cfset arama_yapilmali = 0>
<cfinclude template="../query/get_proms.cfm">
<cfelse>
  	<cfset arama_yapilmali = 1>
  	<cfset proms.recordcount = 0>
</cfif>
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.price_catid" default="-2">
<cfparam name="attributes.page" default=1>
<cfif isDefined("session.ep.maxrows")>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfelse>
	<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'><!--- partner dan da cagriliyor --->
</cfif>
<cfparam name="attributes.totalrecords" default="#proms.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif isdate(attributes.start_date)>
	<cfset attributes.start_date = dateformat(attributes.start_date, dateformat_style)>
</cfif>
<cfif isdate(attributes.finish_date)>
	<cfset attributes.finish_date = dateformat(attributes.finish_date, dateformat_style)>
</cfif>
<cfinclude template="../query/get_price_cats2.cfm">
<!--- <cfinclude template="../query/get_discount_types.cfm"> --->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="icons"><li><a href="<cfoutput>#request.self#?fuseaction=dev.tools</cfoutput>"><i class="catalyst-briefcase"></i></a></li></cfsavecontent>
	<cf_box>
		<cfform name="search" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<cf_box_search>
				<div class="form-group" id="keyword">
					<cfinput type="text" name="keyword" value="#attributes.keyword#" placeholder="#getLang('','Filtre',57460)#" maxlength="255">
				</div>
				<cfif not isdefined("session.pp.userid")><!--- partnerda filtreler gelmesin --->
					<div class="form-group" id="price_catid">
						<select name="price_catid" id="price_catid">
							<cfif (attributes.price_catid is "-1")>
								<option value="-1" selected><cf_get_lang dictionary_id='58722.Standart Alış'></option>
								<option value="-2"><cf_get_lang dictionary_id='58721.Standart Satış'></option>
							<cfelse>
								<option value="-1"><cf_get_lang dictionary_id='58722.Standart Alış'></option>
								<option value="-2" selected><cf_get_lang dictionary_id='58721.Standart Satış'></option>
							</cfif>
								<cfoutput query="get_price_cats"> 
								<option value="#price_catid#"<cfif (price_catid is attributes.price_catid)>selected</cfif>>#price_cat#</option>
								</cfoutput>
						</select>
					</div>
				</cfif>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<cfif not isdefined("session.pp.userid")><!--- partnerda filtreler gelmesin --->
					<div class="col col-2 col-md-2 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="form_ul_product_catid">
						<label class="col col-12"><cf_get_lang dictionary_id='29401.Ürün Kategorisi'></label>
						<div class="col col-12 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="product_catid" id="product_catid" value="<cfif isdefined('attributes.product_catid')><cfoutput>#attributes.product_catid#</cfoutput></cfif>">
								<input type="text" name="product_cat" id="product_cat" value="<cfif isdefined('attributes.product_cat')><cfoutput>#attributes.product_cat#</cfoutput></cfif>">
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&field_id=search.product_catid&field_name=search.product_cat</cfoutput>');"></span>
							</div>
						</div>
					</div>
					</div>
					<div class="col col-2 col-md-2 col-sm-6 col-xs-12" type="column" index="2" sort="true">    
						<div class="form-group" id="form_ul_product_id">
						<label class="col col-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
						<div class="col col-12 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="product_id" id="product_id" value="<cfif isdefined('attributes.product_id')><cfoutput>#attributes.product_id#</cfoutput></cfif>">
								<input name="product_name" type="text" id="product_name" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','','2','200');" value="<cfif isdefined('attributes.product_name')><cfoutput>#attributes.product_name#</cfoutput></cfif>" autocomplete="off" >
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=search.product_id&field_name=search.product_name');"></span>
							</div>
						</div>
					</div>
					</div>    
					<div class="col col-2 col-md-2 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="form_ul_brand_id">
						<label class="col col-12"><cf_get_lang dictionary_id='58847.Marka'></label>
						<div class="col col-12 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="brand_id" id="brand_id" value="<cfif isdefined("attributes.brand_id")><cfoutput>#attributes.brand_id#</cfoutput></cfif>">
								<cfif isdefined("attributes.brand_id") and len(attributes.brand_id)>
								<cfinclude template="../query/get_brand_name.cfm">
								<input name="brand_name" type="text" id="brand_name" onFocus="AutoComplete_Create('brand_name','BRAND_NAME','BRAND_NAME','get_brand','','BRAND_ID','brand_id','','3','140');" value="<cfif isdefined("attributes.brand_name")><cfoutput>#attributes.brand_name#</cfoutput></cfif>" autocomplete="off" >
								<cfelse>
								<input name="brand_name" type="text" id="brand_name" onFocus="AutoComplete_Create('brand_name','BRAND_NAME','BRAND_NAME','get_brand','','BRAND_ID','brand_id','','3','140');" value="" autocomplete="off">
								</cfif>
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_brands&brand_id=search.brand_id&brand_name=search.brand_name&keyword='+encodeURIComponent(document.search.brand_name.value)</cfoutput>,'','ui-draggable-box-small');"></span>
							</div>
						</div>
					</div>
					</div>
					<div class="col col-4 col-md-2 col-sm-6 col-xs-12" type="column" index="5" sort="true">
						<div class="form-group" id="form_ul_start_date">
							<label class="col col-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
							<div class="col col-12 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="start_date" value="#attributes.start_date#" validate="#validate_style#" maxlength="10" message="#getLang('','başlama girmelisiniz',58766)#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>            
									<span class="input-group-addon no-bg"></span>
									<cfinput type="text" name="finish_date" value="#attributes.finish_date#" validate="#validate_style#" maxlength="10" message="#getLang('','bitiş tarihi girmelisiniz',58767)#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
								</div>
							</div>
						</div>
					</div>    
				</cfif>
			</cf_box_search_detail>
		</cfform>
	</cF_box>
</div>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='57583.Promosyonlar | SATIŞ'></cfsavecontent>
	<cf_box title="#head#" uidrop="1" hide_table_column="1" woc_setting = "#{ checkbox_name : 'print_sales_id'}#">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='57518.stok kodu'></th>
					<th><cf_get_lang dictionary_id='57657.ürün'></th>
					<th><cf_get_lang dictionary_id='37592.Promosyon Başlığı'></th>
					<th><cf_get_lang dictionary_id='57446.Kampanya'></th>
					<th><cf_get_lang dictionary_id='58624.Geçerlilik Tarihi'></th>
					<!-- sil -->
					<cfif not isdefined("session.pp.userid")>
						<th width="20">
							<a href="javascript://"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='57771.Detay'>" alt="<cf_get_lang dictionary_id='57771.Detay'>"></i></a>
						</th>
					</cfif>			
					<th width="20"><a href="javascript://"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></a></th>					
					<cfif proms.recordcount>
						<th width="20" nowrap="nowrap" class="text-center header_icn_none">
							<input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','print_sales_id');">
						</th>
					</cfif>	
					<!-- sil -->			
				</tr>
			</thead>
			<tbody>
				<cfif proms.recordcount>
					<cfoutput query="proms" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#PROM_NO#</td>
							<td>#STOCK_CODE#</td>
							<td>#product_name#</td>
							<td>
								<a href="javascript:openBoxDraggable('#request.self#?fuseaction=objects.popup_detail_promotion_unique&prom_id=#PROM_ID#');">#PROM_HEAD#</a>
							</td>
							<td>#CAMP_HEAD#</td>
							<td>#dateformat(STARTDATE,dateformat_style)#-#dateformat(FINISHDATE,dateformat_style)#</td>
							<!-- sil -->
							<cfif not isdefined("session.pp.userid")>
								<td class="text-center">
									<a href="javascript:openBoxDraggable('#request.self#?fuseaction=sales.list_proms&event=det&prom_id=#PROM_ID#');"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='57771.Detay'>" alt="<cf_get_lang dictionary_id='57771.Detay'>"></i></a>
								</td>
							</cfif>
							<td class="text-center"><a href="#request.self#?fuseaction=product.list_promotions&event=upd&prom_id=#PROM_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
							<td class="text-center"><input type="checkbox" name="print_sales_id" id="print_sales_id"  value="#PROM_ID#"></td>
							<!-- sil -->
					</cfoutput>
				</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif proms.recordcount eq 0>
			<div class="ui-info-bottom">
				<p><cfif arama_yapilmali eq 1><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</cfif></p>
			</div>
		</cfif>
		<cfif attributes.maxrows lt attributes.totalrecords>
			<cfset adres = attributes.fuseaction&"&is_submitted=1">
			<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
				<cfset adres = "#adres#&keyword=#attributes.keyword#">
			</cfif>
			<cfif isDefined('attributes.branch_id') and len(attributes.branch_id)>
				<cfset adres = "#adres#&branch_id=#attributes.branch_id#">
			</cfif>
			<cfif isDefined('attributes.price_catid') and len(attributes.price_catid)>
				<cfset adres = "#adres#&price_catid=#attributes.price_catid#">
			</cfif>
			<cfif isDefined('attributes.product_catid') and len(attributes.product_catid) and isDefined('attributes.product_cat') and len(attributes.product_cat)>
				<cfset adres = "#adres#&product_catid=#attributes.product_catid#&product_cat=#attributes.product_cat#">
			</cfif>
			<!--- BK 20130722 6 aya silinsin <cfif isDefined('attributes.discount_type_id_2') and len(attributes.discount_type_id_2)>
				<cfset adres = "#adres#&discount_type_id_2=#attributes.discount_type_id_2#">
			</cfif> --->
			<cfif isDefined('attributes.product_id') and len(attributes.product_id) and isdefined('attributes.product_name') and len(attributes.product_name)>
				<cfset adres = "#adres#&product_id=#attributes.product_id#&product_name=#attributes.product_name#">
			</cfif>
			<cfif isDefined('attributes.brand_id') and len(attributes.brand_id) and isdefined('attributes.brand_name') and len(attributes.brand_name)>
				<cfset adres = "#adres#&brand_id=#attributes.brand_id#&brand_name=#attributes.brand_name#">
			</cfif>
			<cfif isDefined('attributes.company_id') and len(attributes.company_id) and isdefined('attributes.company') and len(attributes.company)>
				<cfset adres = "#adres#&company_id=#attributes.company_id#&company=#attributes.company#">
			</cfif>
			<cfif isdate(attributes.start_date)>
				<cfset adres = "#adres#&start_date=#attributes.start_date#">
			</cfif>
			<cfif isdate(attributes.finish_date)>
				<cfset adres = "#adres#&finish_date=#attributes.finish_date#">
			</cfif>
			<cf_paging
				page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
