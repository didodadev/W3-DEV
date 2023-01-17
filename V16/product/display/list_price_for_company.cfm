<cf_xml_page_edit fuseact="product.upd_price_list_for_company">
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="GET_PRICE_CAT_EXCEPTIONS" datasource="#DSN3#">
		SELECT
			ISNULL(COMPANYCAT_ID,(SELECT COMPANYCAT_ID FROM #dsn_alias#.COMPANY WHERE COMPANY_ID = PRICE_CAT_EXCEPTIONS.COMPANY_ID)) COMPANY_CAT,
			*
		FROM
			PRICE_CAT_EXCEPTIONS
		WHERE
			<cfif isdefined("keyword") and len(keyword)>
				PRICE_CATID IN (SELECT PRICE_CATID FROM PRICE_CAT WHERE PRICE_CAT LIKE '%#attributes.keyword#%') AND
			</cfif>
			CONTRACT_ID IS NULL  AND
			(IS_GENERAL = 1 OR ACT_TYPE IN (1))
	</cfquery>
<cfelse>
	<cfset get_price_cat_exceptions.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_price_cat_exceptions.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_product" action="#request.self#?fuseaction=product.list_price_for_company" method="post">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" placeholder="#message#" id="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='37476.İstisnai Fiyat Listesi'></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='58964.Fiyat Listesi'></th>
					<cfif is_supplier eq 1><th><cf_get_lang dictionary_id='58202.Üretici'></th></cfif>
					<cfif is_comp_cat eq 1><th><cf_get_lang dictionary_id='58609.Üye Kategorisi'></th></cfif>
					<cfif xml_is_company eq 1><th><cf_get_lang dictionary_id='57658.Üye'></th></cfif>
					<cfif xml_is_product_cat eq 1><th><cf_get_lang dictionary_id='57486.Kategori'></th></cfif>
					<cfif xml_is_brand_id eq 1><th><cf_get_lang dictionary_id='58847.Marka'></th></cfif>
					<cfif xml_is_product_id eq 1><th><cf_get_lang dictionary_id='57657.Ürün'></th></cfif>
					<cfif xml_is_discount_rate eq 1><th><cf_get_lang dictionary_id='57641.İskonto'> %</th></cfif>
					<!-- sil --><th width="20" class="header_icn_none text-center"><a onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.list_price_for_company&event=add</cfoutput>')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></td><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_price_cat_exceptions.recordcount>
					<cfset supplier_id_list=''>
					<cfset cons_id_list=''>
					<cfset product_catid_list=''>
					<cfset brand_id_list=''>
					<cfset product_id_list=''>
					<cfset price_cat_id_list=''>
					<cfset company_cat_id_list=''>
					<cfoutput query="get_price_cat_exceptions">
						<cfif len(supplier_id) and not listfind(supplier_id_list,supplier_id)>
							<cfset supplier_id_list=listappend(supplier_id_list,supplier_id)>
						</cfif>
						<cfif len(company_id) and not listfind(supplier_id_list,company_id)>
							<cfset supplier_id_list=listappend(supplier_id_list,company_id)>
						</cfif>
						<cfif len(consumer_id) and not listfind(cons_id_list,consumer_id)>
							<cfset cons_id_list=listappend(cons_id_list,consumer_id)>
						</cfif>
						<cfif len(product_catid) and not listfind(product_catid_list,product_catid)>
							<cfset product_catid_list=listappend(product_catid_list,product_catid)>
						</cfif>
						<cfif len(brand_id) and not listfind(brand_id_list,brand_id)>
							<cfset brand_id_list=listappend(brand_id_list,brand_id)>
						</cfif>
						<cfif len(product_id) and not listfind(product_id_list,product_id)>
							<cfset product_id_list=listappend(product_id_list,product_id)>
						</cfif>
						<cfif len(price_catid) and not listfind(price_cat_id_list,price_catid)>
							<cfset price_cat_id_list=listappend(price_cat_id_list,price_catid)>
						</cfif>
						<cfif len(companycat_id) and not listfind(company_cat_id_list,companycat_id)>
							<cfset company_cat_id_list=listappend(company_cat_id_list,companycat_id)>
						</cfif>
					</cfoutput>
					<cfif len(supplier_id_list)>
						<cfset supplier_id_list=listsort(supplier_id_list,"numeric","ASC",",")>
						<cfquery name="GET_SUP_NAME" datasource="#DSN#">
							SELECT COMPANY_ID, NICKNAME FROM COMPANY WHERE COMPANY_ID IN (#supplier_id_list#) ORDER BY COMPANY_ID
						</cfquery>
						<cfset supplier_id_list = listsort(listdeleteduplicates(valuelist(get_sup_name.company_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(cons_id_list)>
						<cfset cons_id_list=listsort(cons_id_list,"numeric","ASC",",")>
						<cfquery name="GET_CONSUMER_DETAIL" datasource="#DSN#">
							SELECT (CONSUMER_NAME+' '+CONSUMER_SURNAME) CONS_NAME, CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID IN (#cons_id_list#) ORDER BY CONSUMER_ID
						</cfquery>
						<cfset cons_id_list = listsort(listdeleteduplicates(valuelist(get_consumer_detail.consumer_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif listlen(product_catid_list)>
						<cfset product_catid_list=listsort(product_catid_list,"numeric","ASC",",")>
						<cfquery name="GET_PRODUCT_CAT" datasource="#DSN3#">
							SELECT PRODUCT_CATID, HIERARCHY, PRODUCT_CAT FROM PRODUCT_CAT WHERE PRODUCT_CATID IN (#product_catid_list#) ORDER BY PRODUCT_CATID
						</cfquery>
						<cfset product_catid_list = listsort(listdeleteduplicates(valuelist(get_product_cat.product_catid,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(brand_id_list)>
						<cfset brand_id_list=listsort(brand_id_list,"numeric","ASC",",")>
						<cfquery name="GET_BRAND_NAME" datasource="#DSN3#">
							SELECT BRAND_NAME, BRAND_ID	FROM PRODUCT_BRANDS WHERE BRAND_ID IN (#brand_id_list#) ORDER BY BRAND_ID
						</cfquery>
						<cfset brand_id_list = listsort(listdeleteduplicates(valuelist(get_brand_name.brand_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(product_id_list)>
						<cfset product_id_list=listsort(product_id_list,"numeric","ASC",",")>
						<cfquery name="GET_PRODUCT_NAME" datasource="#DSN3#">
							SELECT PRODUCT_ID, PRODUCT_NAME, PROD_COMPETITIVE FROM  PRODUCT WHERE PRODUCT_ID IN (#product_id_list#) ORDER BY PRODUCT_ID
						</cfquery>
						<cfset product_id_list = listsort(listdeleteduplicates(valuelist(get_product_name.product_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(price_cat_id_list)>
						<cfset price_cat_id_list=listsort(price_cat_id_list,"numeric","ASC",",")>
						<cfquery name="GET_PRICE_CATS" datasource="#DSN3#">
							SELECT PRICE_CATID,PRICE_CAT,PRICE_CAT_STATUS FROM PRICE_CAT WHERE PRICE_CATID IN (#price_cat_id_list#) ORDER BY PRICE_CATID
						</cfquery>
						<cfset price_cat_id_list = listsort(listdeleteduplicates(valuelist(get_price_cats.price_catid,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(company_cat_id_list)>
						<cfset company_cat_id_list=listsort(company_cat_id_list,"numeric","ASC",",")>
						<cfquery name="GET_COMP_CATS" datasource="#DSN#">
							SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT WHERE COMPANYCAT_ID IN (#company_cat_id_list#) ORDER BY COMPANYCAT_ID
						</cfquery>
						<cfset company_cat_id_list = listsort(listdeleteduplicates(valuelist(get_comp_cats.companycat_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfoutput query="get_price_cat_exceptions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td><cfif len(price_catid)><a href="javascript://"  onClick="openBoxDraggable('#request.self#?fuseaction=product.list_price_for_company&event=upd&pid=#price_cat_exception_id#','medium');">#get_price_cats.price_cat[listfind(price_cat_id_list,price_catid,',')]#</a></cfif></td>
							<cfif is_supplier eq 1>
								<td><cfif len(supplier_id)>#get_sup_name.nickname[listfind(supplier_id_list,supplier_id,',')]#</cfif></td>
							</cfif>
							<cfif is_comp_cat eq 1>
								<td><cfif len(companycat_id)>#get_comp_cats.companycat[listfind(company_cat_id_list,companycat_id,',')]#</cfif></td>
							</cfif>
							<cfif xml_is_company eq 1>
								<td>
									<cfif len(company_id)>
										<cfset company_txt_=get_sup_name.nickname[listfind(supplier_id_list,company_id,',')]>
									<cfelseif len(consumer_id)>
										<cfset company_txt_=get_consumer_detail.cons_name[listfind(cons_id_list,consumer_id,',')]>
									<cfelse>
										<cfset company_txt_=''>
									</cfif>
									<cfif len(company_txt_)>#company_txt_#</cfif>
								</td>
							</cfif>
							<cfif xml_is_product_cat eq 1>
								<td><cfif len(get_price_cat_exceptions.product_catid)>#get_product_cat.hierarchy[listfind(product_catid_list,product_catid,',')]# #get_product_cat.product_cat[listfind(product_catid_list,product_catid,',')]#</cfif></td>
							</cfif>
							<cfif xml_is_brand_id eq 1>
								<td><cfif len(get_price_cat_exceptions.brand_id)>#get_brand_name.brand_name[listfind(brand_id_list,brand_id,',')]#</cfif></td>
							</cfif>
							<cfif xml_is_product_id eq 1>
								<td><cfif len(get_price_cat_exceptions.product_id)>#get_product_name.product_name[listfind(product_id_list,product_id,',')]#</cfif></td>
							</cfif>
							<cfif xml_is_discount_rate eq 1>
								<td style="text-align:right;">#TLFormat(DISCOUNT_RATE)#</td>
							</cfif>
							<!-- sil --><td width="15"><a onclick="openBoxDraggable('#request.self#?fuseaction=product.list_price_for_company&event=upd&pid=#price_cat_exception_id#')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="10"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'> !<cfelse><cf_get_lang dictionary_id='57701.Filte Ediniz'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>

		<cfset adres = attributes.fuseaction>
		<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
			<cfset adres = "#adres#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined ('attributes.form_submitted') and len(attributes.form_submitted)>
			<cfset adres = "#adres#&form_submitted=#attributes.form_submitted#">
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
