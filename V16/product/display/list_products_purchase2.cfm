<cfif isdefined("attributes.compid")>
	<cfset dsn3 = "#dsn#_#attributes.compid#">
</cfif>
<cfparam name="attributes.product_cat_code" default=''>
<cfparam name="attributes.search_company" default=''>
<cfparam name="attributes.search_company_id" default=''>
<cfparam name="attributes.employee" default=''>
<cfparam name="attributes.position_code" default=''>
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.barcode" default=''>
<cfif isdefined("attributes.is_submitted") or len(attributes.keyword)>
	<cfquery name="PRODUCTS" datasource="#DSN3#">
        SELECT
            PRODUCT.COMPANY_ID,
            PRODUCT.PRODUCT_ID,
            PRODUCT.PRODUCT_NAME +' '+ STOCKS.PROPERTY PRODUCT_NAME,
            STOCKS.STOCK_ID,
            PRODUCT.MANUFACT_CODE,
            PRICE_STANDART.MONEY,
            PRICE_STANDART.PRICE,
            PRODUCT_UNIT.ADD_UNIT,
            PRODUCT.PRODUCT_CODE,
            PRODUCT.BARCOD
		FROM
            PRODUCT,
            PRODUCT_UNIT,
            PRICE_STANDART,
            STOCKS
		WHERE
	        STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
            STOCKS.STOCK_STATUS = 1 AND
			PRODUCT.PRODUCT_STATUS = 1 AND 	
			PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND 
			PRODUCT.IS_SALES = 1 AND
			PRODUCT_UNIT.IS_MAIN = 1 AND 
			PRICE_STANDART.PRICESTANDART_STATUS = 1	AND 
			PRICE_STANDART.PURCHASESALES = 0 AND 
			PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND 
			PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID
			<cfif isDefined("attributes.product_cat_code") and len(attributes.product_cat_code)>
				AND PRODUCT.PRODUCT_CODE LIKE '#attributes.product_cat_code#.%'
			</cfif>
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				AND 
				(
				<cfif len(attributes.keyword) eq 1>
					PRODUCT.PRODUCT_NAME LIKE '#attributes.keyword#%' 
				<cfelseif len(attributes.keyword) gt 1>
					<cfif listlen(attributes.keyword,"+") gt 1>
						(
							<cfloop from="1" to="#listlen(attributes.keyword,'+')#" index="pro_index">
							PRODUCT.PRODUCT_NAME LIKE '%#ListGetAt(attributes.keyword,pro_index,"+")#%' 
							<cfif pro_index neq listlen(attributes.keyword,'+')>AND</cfif>
							</cfloop>
						)		
					<cfelse>
						PRODUCT.PRODUCT_NAME LIKE '%#attributes.keyword#%' OR
						PRODUCT.PRODUCT_CODE LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%' OR
						PRODUCT.PRODUCT_CODE_2 LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%' OR
						STOCKS.STOCK_CODE LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%' OR
						PRODUCT.BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR 
						PRODUCT.MANUFACT_CODE LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%' 
					</cfif>
				</cfif>		
				) 
			</cfif>
			<cfif len(attributes.position_code) and isdefined("attributes.employee") and len(attributes.employee)>
				AND PRODUCT.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">
			</cfif>
			<cfif len(attributes.search_company_id) and isdefined("attributes.search_company") and len(attributes.search_company)>
				AND PRODUCT.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.search_company_id#">
			</cfif>
			<cfif isdefined("attributes.brand_name") and len(attributes.brand_id) and len(attributes.brand_name)>
				AND PRODUCT.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
			</cfif>
            <cfif IsDefined("attributes.barcode") and len(attributes.barcode)>
				AND PRODUCT.BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.barcode#">
			</cfif>
			<cfif isdefined("is_promotion") and isdefined("prod_id_list")>
				AND PRODUCT.PRODUCT_ID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prod_id_list#" list="yes">)
			</cfif>
		ORDER BY
			PRODUCT.PRODUCT_NAME
	</cfquery>
<cfelse>
	<cfset products.recordcount=0>
</cfif>

<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.totalrecords" default="#products.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = "">
<cfif isdefined("module_name")>
	<cfset url_str = "#url_str#&module_name=#module_name#">
</cfif>
<cfif isdefined("attributes.startdate")>
	<cfset url_str = "#url_str#&startdate=#attributes.startdate#">
</cfif>
<cfif isdefined("attributes.finishdate")>
	<cfset url_str = "#url_str#&finishdate=#attributes.finishdate#">
</cfif>
<cfif isdefined("attributes.kondusyon_date")>
	<cfset url_str = "#url_str#&kondusyon_date=#attributes.kondusyon_date#">
</cfif>
<cfif isdefined("attributes.kondusyon_finish_date")>
	<cfset url_str = "#url_str#&kondusyon_finish_date=#attributes.kondusyon_finish_date#">
</cfif>
<cfif isdefined("attributes.price_lists")>
	<cfset url_str = "#url_str#&price_lists=#attributes.price_lists#">
</cfif>
<cfif isdefined("attributes.compid")>
	<cfset url_str = "#url_str#&compid=#attributes.compid#">
</cfif>
<cfif isdefined("attributes.catalog_id")>
	<cfset url_str = "#url_str#&catalog_id=#attributes.catalog_id#">
</cfif>
<cfif isdefined("attributes.finishdate")>
	<cfset attributes.finishdate2 = attributes.finishdate>
	<cf_date tarih='attributes.finishdate2'>
</cfif>
<cfif IsDefined("attributes.is_promotion") and Len(attributes.is_promotion)>
	<cfset url_str = "#url_str#&is_promotion=#attributes.is_promotion#">
</cfif> 
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='58964.Fiyat Listesi'></cfsavecontent>
	<cf_box title="#message#">
		<cfform name="price_cat" method="post" action="#request.self#?fuseaction=product.popup_products2#url_str#&var_=#attributes.var_#">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<cfoutput>
				<cf_box_search title="#message#">
					<div class="form-group">
						<cfinput type="text" maxlength="50" name="keyword" value="#attributes.keyword#" placeholder="#getLang('','filtre',57460)#">
					</div>
					<div class="form-group">
						<input type="text" name="barcode" id="barcode" value="#attributes.barcode#" placeholder="<cf_get_lang dictionary_id='57633.Barkod'>">
					</div>
					<div class="form-group small">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3">
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4" search_function="input_control()">
					</div>
				</cf_box_search>
				<cf_box_search_detail>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<div class="form-group">
							<label><cf_get_lang dictionary_id='58847.Marka'></label>
							<div class="input-group">
								<input type="hidden" name="brand_id" id="brand_id" value="<cfif isdefined("attributes.brand_id") and len(attributes.brand_id)>#attributes.brand_id#</cfif>">
								<input type="text" name="brand_name" id="brand_name" value="<cfif isdefined("attributes.brand_id") and len(attributes.brand_id)>#attributes.brand_name#</cfif>">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('#request.self#?fuseaction=objects.popup_product_brands&brand_id=price_cat.brand_id&brand_name=price_cat.brand_name&keyword='+encodeURIComponent(document.price_cat.brand_name.value),'small');"></span>
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<div class="form-group">
							<label><cf_get_lang dictionary_id='57544.Sorumlu'></label>
							<div class="input-group">
								<input type="hidden" name="position_code" id="position_code" value="#attributes.position_code#">
								<input type="text" name="employee" id="employee" value="<cfif len(attributes.position_code) and isdefined("attributes.employee") and len(attributes.employee)>#get_emp_info(attributes.position_code,1,0)#</cfif>" maxlength="255">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_code=price_cat.position_code&field_name=price_cat.employee&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.price_cat.employee.value),'list');"></span>
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<div class="form-group">
							<label><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
							<div class="input-group">
								<input type="hidden" name="search_company_id" id="search_company_id" value="#attributes.search_company_id#">
								<input type="text" name="search_company" id="search_company" value="<cfif len(attributes.search_company_id) and isdefined("attributes.search_company") and len(attributes.search_company)>#get_par_info(attributes.search_company_id,1,1,0)#</cfif>">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&field_comp_name=price_cat.search_company&field_comp_id=price_cat.search_company_id&select_list=2&keyword='+encodeURIComponent(document.price_cat.search_company.value),'list');"></span>
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<div class="form-group">
							<label><cf_get_lang dictionary_id='57486.Kategori'></label>
							<div class="input-group">
								<input type="text" name="product_cat_code" id="product_cat_code" value="#attributes.product_cat_code#">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=3&field_code=price_cat.product_cat_code&keyword='+encodeURIComponent(document.price_cat.product_cat_code.value));"></span>
							</div>
						</div>
					</div>
				</cf_box_search_detail>
			</cfoutput>
		</cfform>
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
					<th><cf_get_lang dictionary_id='57633.Barkod'></th>
					<th><cf_get_lang dictionary_id='57657.Ürün'></th>
					<th><cf_get_lang dictionary_id='37481.Ürt Kodu'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='58084.Fiyat'></th>
					<th width="20"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=product.list_product&event=add" target="_blank"><i class="fa fa-plus"></i></a></th>
					<th width="20" class="text-center header_icn_none">
						<input type="checkbox" name="allProductId" id="allProductId" onclick="wrk_select_all('allProductId','cat_product_id');">
					</th>
				</tr>
			</thead>
			<tbody>
				<cfif products.recordcount>
					<cfoutput query="products" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>           
							<td>#product_id#-#product_code#</td>
							<td>#Barcod#</td>
							<td>
							<cfif isdefined("attributes.kondusyon_date") and isdefined("attributes.kondusyon_finish_date")>
								<a href="javascript://" onclick="check_aksiyon(#product_id#,#stock_id#);">#product_name#</a>
							<cfelse>
								<a href="javascript://" onclick="javascript:window.location='#request.self#?fuseaction=product.popup_products_add_basket&product_id=#product_id#&stock_id=#stock_id#&#url_str#';">#product_name#</a>
							</cfif>
							</td> 
							<td>#products.manufact_code#</td>
							<td align="right" style="text-align:right;">#TLFormat(products.price,4)#&nbsp;#money# (#products.add_unit#)</td>
							<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#products.product_id#','list')"><i class="fa fa-pencil"></i></a></td>
							<td>
								<input type="checkbox" name="cat_product_id" id="cat_product_id" value="#product_id#,#stock_id#">
							</td>
						</tr>
					</cfoutput> 
				<cfelse>
					<tr> 
						<td colspan="6">
							<cfif isdefined("attributes.is_submitted")>
								<cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<br/>
								<a href="javascript:window.opener.parent.location='<cfoutput>#request.self#</cfoutput>?fuseaction=product.form_add_product';window.close();"><cf_get_lang dictionary_id='37917.Urun Kaydetmek Icin Tıklayin'></a>
							<cfelse>
								<cf_get_lang dictionary_id='57701.Filtre Ediniz '> !
							</cfif>
						</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif products.recordcount>
			<div class="ui-info-bottom flex-end">
				<div>
					<a href="javascript://" onclick="add_product()" class="ui-wrk-btn ui-wrk-btn-extra"><cf_get_lang dictionary_id='64160.Seçilenleri Kaydet'></a>
				</div>
				<div>
					<a href="javascript://" onclick="check_aksiyon("<cfoutput>#valuelist(products.product_id,',')#</cfoutput>","<cfoutput>#valuelist(products.stock_id,',')#</cfoutput>");" class="ui-wrk-btn ui-wrk-btn-extra"><cf_get_lang dictionary_id='64218.Tümünü Kaydet'></a>
				</div>
			</div>
		</cfif>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset adres = "product.popup_products2">
			<cfif len(attributes.keyword)>
				<cfset adres = "#adres#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.var_)>
				<cfset adres = "#adres#&var_=#attributes.var_#">
			</cfif>
			<cfif isDefined('attributes.product_cat_code') and len(attributes.product_cat_code)>
				<cfset adres = "#adres#&product_cat_code=#attributes.product_cat_code#">
			</cfif>
			<cfif isDefined('attributes.module_name') and len(attributes.module_name)>
				<cfset adres = "#adres#&module_name=#attributes.module_name#">
			</cfif>
			<cfif isdefined("attributes.startdate")>
				<cfset adres = "#adres#&startdate=#attributes.startdate#">
			</cfif>
			<cfif isdefined("attributes.finishdate")>
				<cfset adres = "#adres#&finishdate=#attributes.finishdate#">
			</cfif>
			<cfif isdefined("attributes.kondusyon_date")>
				<cfset adres = "#adres#&kondusyon_date=#attributes.kondusyon_date#">
			</cfif>
			<cfif isdefined("attributes.kondusyon_finish_date")>
				<cfset adres = "#adres#&kondusyon_finish_date=#attributes.kondusyon_finish_date#">
			</cfif>
			<cfif isdefined("attributes.price_lists")>
				<cfset adres = "#adres#&price_lists=#attributes.price_lists#">
			</cfif>
			<cfif isdefined("attributes.compid")>
				<cfset adres = "#adres#&compid=#attributes.compid#">
			</cfif>
			<cfif isdefined("is_submitted")>
				<cfset adres="#adres#&is_submitted=1">
			</cfif>
			<cfif isdefined("attributes.employee") and isdefined("attributes.position_code")>
				<cfset adres = "#adres#&employee=#attributes.employee#&position_code=#attributes.position_code#">
			</cfif>
			<cfif isdefined("attributes.catalog_id")>
				<cfset url_str = "#url_str#&catalog_id=#attributes.catalog_id#">
			</cfif>
			<cfif isdefined("attributes.search_company") and isdefined("attributes.search_company_id")>
				<cfset adres = "#adres#&search_company=#attributes.search_company#&search_company_id=#attributes.search_company_id#">
			</cfif>
			<cfif isdefined("attributes.brand_name") and Len(attributes.brand_name) and isdefined("attributes.brand_id") and Len(attributes.brand_id)>
				<cfset adres = "#adres#&brand_name=#attributes.brand_name#&brand_id=#attributes.brand_id#">
			</cfif>
			<cfif IsDefined("attributes.barcode") and Len(attributes.barcode)>
				<cfset adres = "#adres#&barcode=#attributes.barcode#&barcode=#attributes.barcode#">
			</cfif>
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">

	document.getElementById('keyword').focus();
	function check_aksiyon(prod_id,stock_id)
	{
		var p_id=prod_id;
		var s_id=stock_id;
		var u_str=<cfoutput>'#url_str#'</cfoutput>;
		<cfif isdefined("attributes.kondusyon_date") and isdefined("attributes.kondusyon_finish_date")>
		var s_date= <cfoutput>'#attributes.kondusyon_date#'</cfoutput>;
		var f_date = <cfoutput>'#attributes.kondusyon_finish_date#'</cfoutput>;
		</cfif>
		var params=p_id;
		var disc_coup_no = wrk_safe_query("control_aksiyon",'dsn3',0,params);
		if(disc_coup_no.recordcount > 0)
		{
		
			for ( var i = 1; i <= disc_coup_no.recordcount; i++ ) 
			{
				if( (disc_coup_no.STARTDATE[i] == s_date) && (disc_coup_no.FINISHDATE[i] == f_date))
				{
					if(confirm("<cf_get_lang dictionary_id='60409.Ürün Aynı Tarihlerde Aksiyonda kullanılmış'>! <cf_get_lang dictionary_id='58587.Devam Etmek İstiyor musunuz'>?  <cf_get_lang dictionary_id='57368.Aksiyon Adı'>: "+disc_coup_no.CATALOG_HEAD[i]+" - <cf_get_lang dictionary_id='57368.Aksiyon '> <cf_get_lang dictionary_id='58527.ID'>: " + disc_coup_no.CATALOG_ID[i]))
					{
						window.location='<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_products_add_basket&<cfif isdefined("attributes.is_promotion")>is_promotion=1</cfif>product_id='+p_id+'&stock_id='+s_id+'&'+u_str;	
						return true;
					}
					else return false;
				}
				else window.location='<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_products_add_basket&product_id='+p_id+'&stock_id='+s_id+'&'+u_str;
			}
			
		}
		else window.location='<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_products_add_basket&product_id='+p_id+'&stock_id='+s_id+'&'+u_str;
			
	}
	function input_control()
	{	
		<cfif not session.ep.our_company_info.unconditional_list>
			if (document.price_cat.keyword.value.length == 0 && document.price_cat.employee.value.length == 0 && document.price_cat.search_company.value.length == 0  && document.price_cat.product_cat_code.value.length == 0 && document.price_cat.brand_name.value.length == 0)
			{
				alert("<cf_get_lang dictionary_id='58950.En Az Bir Alanda Filtre Etmelisiniz'> !");
				return false;
			}
			else
				return true;
		<cfelse>
			return true;
		</cfif>	
	}
	function add_product() {
		var product_list="",stock_list="";
		$("input[name = cat_product_id]").each(function() {
			var vals = $(this).val().split(",");
			product_list += vals[0] + ",";			
			stock_list += vals[1]+ ",";			
		});
		String(product_list);
		String(stock_list);
		check_aksiyon(product_list,stock_list);
	}
	<cfif isdefined("attributes.is_promotion") and isdefined("attributes.prod_id_list")>
		check_aksiyon("<cfoutput>#valuelist(products.product_id,',')#</cfoutput>","<cfoutput>#valuelist(products.stock_id,',')#</cfoutput>");
	</cfif>
</script>
