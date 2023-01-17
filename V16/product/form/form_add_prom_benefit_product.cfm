<cfsetting showdebugoutput="no">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12 nohover_div">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='29410.Ürün Ekle'></cfsavecontent>
    <cf_box id="open_process" title="#message#">
		<cf_box_elements>
			<div class="col col-12 col-md-4 col-sm-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-first_page_no_1">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="57581.Sayfa"></label>
					<div class="col col-3 col-sm-12">
						<input type="text" name="first_page_no_1" id="first_page_no_1" value="" onkeyup="isNumber(this);" class="moneybox"> 
					</div>
					<div class="col col-1 col-sm-12">
						<cf_get_lang dictionary_id="30022.ile"> 
					</div>
					<div class="col col-3 col-sm-12">
						<input type="text" name="last_page_no_1" id="last_page_no_1" value="" onkeyup="isNumber(this);" class="moneybox"> 
					</div>
					<div class="col col-1 col-sm-12">
						<cf_get_lang dictionary_id="30023.Arası">
					</div>
				</div>
				<div class="form-group" id="item-product_catid_1">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="57486.Kategori"></label>
					<div class="col col-8 col-sm-12">
						<div class="input-group">
							<input type="hidden" name="product_catid_1" id="product_catid_1" value="">
							<input type="text" name="product_cat_1" id="product_cat_1" value="" style="width:130px;" readonly>
							<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&field_id=add_prom.product_catid_1&field_name=add_prom.product_cat_1</cfoutput>');"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-brand_name_1">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="58847.Marka"></label>
					<div class="col col-8 col-sm-12">
						<div class="input-group">
							<input type="hidden" name="brand_id_1" id="brand_id_1">			
							<input type="text" name="brand_name_1" id="brand_name_1" value="" style="width:130px;" readonly>
							<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_brands&brand_id=add_prom.brand_id_1&brand_name=add_prom.brand_name_1</cfoutput>','list');"></span>
						</div>
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<input type="button" value="<cf_get_lang dictionary_id='57582.Ekle'>" onclick="add_process();">
		</cf_box_footer>
    </cf_box>
</div>
<script type="text/javascript">
	function add_process()
	{
		if(document.getElementById('brand_name_1').value == "" && document.getElementById('product_cat_1').value == "" && document.getElementById('first_page_no_1').value == "" && document.getElementById('last_page_no_1').value == "")
			alert("<cf_get_lang dictionary_id='34067.En Az Bir Arama Kriteri Girmelisiniz'> !");
		else
		{	
			<cfif len(attributes.catalog_id)>
				var product_sql = 'SELECT PRODUCT_ID,STOCK_ID,PRODUCT_NAME,<cfif isdefined("attributes.is_product_code_2") and attributes.is_product_code_2 eq 1>PRODUCT_CODE_2 AS PRODUCT_CODE<cfelse>PRODUCT_CODE</cfif>,(SELECT CPP.PAGE_NO FROM CATALOG_PROMOTION_PRODUCTS CPP WHERE CPP.CATALOG_ID = <cfoutput>#attributes.catalog_id#</cfoutput> AND CPP.PRODUCT_ID = STOCKS.PRODUCT_ID) AS PAGE_NO,PRODUCT_CAT.PROFIT_MARGIN FROM STOCKS,PRODUCT_CAT WHERE PRODUCT_STATUS = 1 AND PRODUCT_CAT.PRODUCT_CATID = STOCKS.PRODUCT_CATID';
			<cfelse>
				var product_sql = 'SELECT PRODUCT_ID,STOCK_ID,PRODUCT_NAME,<cfif isdefined("attributes.is_product_code_2") and attributes.is_product_code_2 eq 1>PRODUCT_CODE_2 AS PRODUCT_CODE<cfelse>PRODUCT_CODE</cfif>,PRODUCT_CAT.PROFIT_MARGIN FROM STOCKS,PRODUCT_CAT WHERE PRODUCT_STATUS = 1 AND PRODUCT_CAT.PRODUCT_CATID = STOCKS.PRODUCT_CATID';
			</cfif>

			if(document.getElementById('product_catid_1').value != "" && document.getElementById('product_cat_1').value != "")
				product_sql = product_sql+' AND PRODUCT_CAT.PRODUCT_CATID = '+document.getElementById('product_catid_1').value+'';
			if(document.getElementById('brand_id_1').value != "" && document.getElementById('brand_name_1').value != "")
				product_sql = product_sql+' AND BRAND_ID = '+document.getElementById('brand_id_1').value+'';
			if(document.getElementById('first_page_no_1').value != "")
				product_sql = product_sql+' AND PRODUCT_ID IN(SELECT PRODUCT_ID FROM CATALOG_PROMOTION_PRODUCTS WHERE CATALOG_ID = <cfoutput>#attributes.catalog_id#</cfoutput> AND PAGE_NO IS NOT NULL AND PAGE_NO >= '+document.getElementById('first_page_no_1').value+')';
			if(document.getElementById('last_page_no_1').value != "")
				product_sql = product_sql+' AND PRODUCT_ID IN(SELECT PRODUCT_ID FROM CATALOG_PROMOTION_PRODUCTS WHERE CATALOG_ID = <cfoutput>#attributes.catalog_id#</cfoutput> AND PAGE_NO IS NOT NULL AND PAGE_NO <= '+document.getElementById('last_page_no_1').value+')';
			var get_product = wrk_query(product_sql,'dsn3');
			if(get_product.recordcount > 0)
			{
				for(i=0;i<get_product.recordcount;i++)
				{
					<cfif len(attributes.catalog_id)>
						add_product(get_product.PRODUCT_ID[i],get_product.STOCK_ID[i],get_product.PRODUCT_NAME[i],get_product.PRODUCT_CODE[i],get_product.PAGE_NO[i],get_product.PROFIT_MARGIN[i]);
					<cfelse>
						add_product(get_product.PRODUCT_ID[i],get_product.STOCK_ID[i],get_product.PRODUCT_NAME[i],get_product.PRODUCT_CODE[i],'',get_product.PROFIT_MARGIN[i]);
					</cfif>
				}
				document.getElementById('open_process').innerHTML='';
				document.getElementById('open_process').style.display ='none'
			}
			else
				alert("<cf_get_lang dictionary_id='58642.Uygun Ürün Kaydı Bulunamadı'> !");
		}
	}
</script>
