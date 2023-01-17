<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_catid" default="0">
<cfparam name="attributes.oby" default=1>
<cfset attributes.branch_id = #listgetat(session.ep.user_location,2,'-')#>
<cfinclude template="../query/get_branch_values.cfm">
<cfset dep_ids=ValueList(get_branch_departments.department_id,',')>
<cfquery name="GET_COMPETITIVE_LIST" datasource="#DSN3#">
	SELECT
		COMPETITIVE_ID
	FROM
		PRODUCT_COMP_PERM
	WHERE
		POSITION_CODE = #session.ep.position_code#
</cfquery>
<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfset COMPETITIVE_LIST = ValueList(get_competitive_list.competitive_id)>
<cfinclude template="../query/get_price_cat_id.cfm">
<cfif len(get_price_cat_id.price_catid)>
	<cfset attributes.price_catid = get_price_cat_id.price_catid>
<cfelse>
	<cfset attributes.price_catid = 0>
</cfif>
<cfinclude template="../query/get_product_label.cfm"> 
<cfparam name="attributes.page" default='1'>
<cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
	<cfset attributes.maxrows = session.ep.maxrows>
</cfif>
<cfparam name="attributes.totalrecords" default='#get_product.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
            <cfsavecontent variable="title_">
                <cfif len(attributes.product_cat) and len(attributes.product_catid)>
                    <cfoutput>#get_product_cats.product_cat#</cfoutput>
                <cfelse>
                    <cf_get_lang no='163.Fiyat Değişimi'> / <cf_get_lang no='74.Etiketler'>
                </cfif>
            </cfsavecontent>
			<cfform name="search_product" method="post" action="#request.self#?fuseaction=store.list_label">
				<cf_big_list_search title="#title_#"> 
					<cf_big_list_search_area>		
						<table>
							<tr>
                            	<cfinput type="hidden" name="is_form_submitted" value="1">
								<td><cf_get_lang_main no='48.Filtre'></td>
								<td><cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50" style="width:90px;"></td>
								<td><cf_get_lang_main no ='74.Kategori'></td>
								<td>
									<input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#attributes.product_catid#</cfoutput>">
									<input type="text" name="product_cat" id="product_cat" value="<cfoutput>#attributes.product_cat#</cfoutput>" style="width:110px;">
									<a href="javascript://"onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=3&field_id=search_product.product_catid&field_name=search_product.product_cat&keyword='+encodeURIComponent(document.search_product.product_cat.value)</cfoutput>);"><img src="/images/plus_thin.gif" title="<cf_get_lang no='158.Ürün Kategorisi Seç'> !"></a>
								</td>
								<td>
									<select name="oby" id="oby" style="width:105px;">
										<option value="1"<cfif attributes.oby eq 1>selected</cfif>><cf_get_lang no='106.İsme Göre Artan'></option>
										<option value="2"<cfif attributes.oby eq 2>selected</cfif>><cf_get_lang no='105.İsme Göre Azalan'></option>
										<option value="3"<cfif attributes.oby eq 3>selected</cfif>><cf_get_lang_main no='513.Artan Tarih'></option>
										<option value="4"<cfif attributes.oby eq 4>selected</cfif>><cf_get_lang_main no='514.Azalan Tarih'></option>
									</select>
								</td>			
								<td>
									<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
										<cfsavecontent variable="message"><cf_get_lang_main no ='1091.Tarih Giriniz '></cfsavecontent>
										<cfinput type="text" name="start_date" maxlength="10" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" message="#message#" style="width:65px;">
									<cfelse>
										<cfsavecontent variable="message"><cf_get_lang_main no ='1091.Tarih Giriniz '></cfsavecontent>
										<cfinput type="text" name="start_date" value="" maxlength="10" validate="#validate_style#" message="#message#" style="width:65px;">
									</cfif>
								<cf_wrk_date_image date_field="start_date"> 
								</td>
								<td>
									<cfsavecontent variable="alert"><cf_get_lang_main no='1091.Tarih Giriniz'></cfsavecontent>
									<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
										<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#alert#" style="width:65px;" >
									<cfelse>
										<cfsavecontent variable="message"><cf_get_lang_main no ='1091.Tarih Giriniz '></cfsavecontent>
										<cfinput type="text" name="finish_date" value="" maxlength="10" validate="#validate_style#" message="#message#" style="width:65px;">
									</cfif>
								<cf_wrk_date_image date_field="finish_date">
								</td>
								<td>
									<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
									<cfinput type="text" name="maxrows" value="#attributes.maxrows#" onKeyUp="isNumber(this)" maxlength="3" validate="integer" range="1,250" required="yes" message="#message#" style="width:25px;">
								</td>
								<td><cf_wrk_search_button search_function="kontrol()"></td>
								<td>
									<cfif get_module_user(47)>
										<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_collected_barcode&is_branch=1','medium','pos_islem');"><img src="/images/barcode_print.gif" title="<cf_get_lang no='115.Toplu Barkod Yazdır'>"></a>
											<cfsavecontent variable="message"><cf_get_lang no='103.Fiyat Değişim Export Belgesi Oluşturuyorsunuz! Emin misiniz'></cfsavecontent>
										<a href="javascript://" onClick="javascript:if (confirm('<cfoutput>#message#</cfoutput>')) windowopen('<cfoutput>#request.self#?fuseaction=objects.emptypopupflush_export_price_change_genius&branch_id=#attributes.branch_id#&startdate=#dateformat(attributes.start_date,dateformat_style)#&finishdate=#dateformat(attributes.finish_date,dateformat_style)#&start_hour=0&start_min=0&finish_hour=0&finish_min=0&target_pos=-1&from_store=1<cfif len(attributes.product_cat) and len(attributes.product_catid)>&product_cat=#product_cat#&product_catid=#product_catid#</cfif></cfoutput>','medium'); return false;">
											<img src="/images/oriantation.gif" title="<cf_get_lang no='107.Fiyat Değişim Belgesi Oluştur'>">
										</a>
									</cfif>	
								</td>
								<td>
								<cfset url_barcode="start_date=#dateformat(attributes.start_date,dateformat_style)#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#&product_catid=#attributes.product_catid#&product_cat=#attributes.product_cat#&keyword=#attributes.keyword#&product_catid=#attributes.product_catid#">
								<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popupflush_print_all_templates&#url_barcode#&print=1&iframe=1&price_catids=1</cfoutput>','small');"><img src="/images/barcode.gif" title="<cf_get_lang no='164.Toplu Print'>"></a>
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
                    	<th width="35"><cf_get_lang_main no="1165.Sıra"></th>
						<th width="130"><cf_get_lang_main no='106.Stok Kodu'></th>
						<th width="110"><cf_get_lang_main no='221.Barkod'></th>
						<th><cf_get_lang_main no='245.Ürün'></th>
						<th style="text-align:right;" <cfif not isdefined ("attributes.trail")>colspan="2"</cfif>><cf_get_lang_main no='672.Fiyat'></th>
						<th width="40"><cf_get_lang_main no='224.Birim'></th>
						<th width="65"><cf_get_lang no='102.Tarihi'></th>
						<th class="header_icn_none"></th>
					
					</tr>
				</thead>
				<tbody>
					<cfif get_product.recordcount and form_varmi eq 1>
					<cfoutput query="get_product" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfset pid = PRODUCT_ID>
						<cfset pro_cat_id = PRODUCT_CATID>
						<tr>
                        	<td>#currentrow#</td>
							<td>#stock_code#</td>
							<td>#barcod#</td>
							<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#','list');" class="tableyazi">#product_name# - #property#</a></td>
							<td style="text-align:right;"><cfif is_kdv eq 1>#TLFormat(price_kdv)#&nbsp;#money#<cfelse>#TLFormat(price*(100+tax)/100)#&nbsp;#money#</cfif><!--- #TLFormat((price*(tax+100))/100)#&nbsp;#money# ---></td>
							<!-- sil -->
							<td width="8" style="text-align:right;">
							<cfif len(get_product.PROD_COMPETITIVE)>
							<cfif listfind(COMPETITIVE_LIST,get_product.PROD_COMPETITIVE,",")>
								<cfset str_url_open="store.popup_add_price&pid=#get_product.product_id[currentrow]#">
							<cfelse>
								<cfset str_url_open="store.popup_add_price_request&pid=#get_product.product_id[currentrow]#">
							</cfif>
							<cfelse>
								<cfset str_url_open="store.popup_add_price_request&pid=#get_product.product_id[currentrow]#">
							</cfif>
							<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#str_url_open#','small');"><img src="/images/plus_thin.gif"></a>
							</td>
							<!-- sil -->
							<td align="center">#add_unit#</td>
							<td>#dateformat(record_date,dateformat_style)#</td>
							<!-- sil -->
							<td width="20" align="center"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_barcode&barcod=#BARCOD#&price_catid=#PRICE_CATID#&product_id=#pid#&first=','small');"><img src="/images/barcode.gif" title="<cf_get_lang_main no="221.Barkod">"></a></td>	  		  
							<!-- sil -->
						</tr>
					</cfoutput>
					<cfelse>
						<tr>
							<td colspan="9"><cfif form_varmi eq 0><cf_get_lang_main no='289. Filtre Ediniz'>!<cfelse><cf_get_lang_main no='72.Kayıt Yok'>!</cfif></td>
						</tr>
					</cfif>
				</tbody>
			</cf_big_list> 	  
			<cfset adres = "store.list_label">
            <cfif isDefined('attributes.product_cat') and len(attributes.product_cat)>
                <cfset adres = '#adres#&product_cat=#attributes.product_cat#'>
            </cfif>
            <cfif isDefined('attributes.product_catid') and len(attributes.product_catid)>
                <cfset adres = '#adres#&product_catid=#attributes.product_catid#'>
            </cfif>
            <cfif isDefined('attributes.keyword') and len(attributes.keyword)>
                <cfset adres = '#adres#&keyword=#attributes.keyword#'>
            </cfif>
            <cfif isDefined('attributes.price_catid') and len(attributes.price_catid)>
                <cfset adres = '#adres#&price_catid=#attributes.price_catid#'>
            </cfif>
            <cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
                <cfset adres = '#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#'>
            </cfif>
            <cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
                <cfset adres = '#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#'>
            </cfif>
            <cfif isDefined('attributes.oby') and len(attributes.oby)>
                <cfset adres = adres & '&oby=' & attributes.oby>
            </cfif>
            <cf_paging page="#attributes.page#" 
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="#adres#">
<script type="text/javascript">
	document.getElementById('keyword').focus();	
	function kontrol()
		{
			if(!date_check (document.getElementById('start_date'),document.getElementById('finish_date'),"<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
				return false;
			else
				return true;	
		}	
</script>

