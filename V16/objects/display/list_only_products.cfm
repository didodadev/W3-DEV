<cfparam name="attributes.product_cat" default=''>
<cfparam name="attributes.product_cat_code" default=''>
<cfparam name="attributes.is_alternative_products" default="">
<cfinclude template="../query/get_product_cat.cfm">
<cfparam name="attributes.modal_id" default="">	
<cfif isdefined('attributes.product_catid') and len(attributes.product_catid)>
	<cfquery name="get_product_cat_" datasource="#dsn3#">
		SELECT 
			PRODUCT_CATID, 
			HIERARCHY, 
			PRODUCT_CAT 
		FROM 
			PRODUCT_CAT
		WHERE
			PRODUCT_CATID IS NOT NULL AND 
			PRODUCT_CATID = #attributes.product_catid#
		ORDER BY
			HIERARCHY
	</cfquery>
<cfelse>
	<cfset get_product_cat_.recordcount = 0>
</cfif>
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.page" default="1">
<!--- <cfif get_product_cat_.recordcount>
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif> --->
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfif not isNumeric(attributes.maxrows)>
	<cfset attributes.maxrows = session.ep.maxrows>
</cfif>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
<cfif isdefined('attributes.is_form_submitted')>
	<cfquery name="PRODUCT_NAMES" datasource="#dsn3#">
		SELECT
			PRODUCT.PRODUCT_NAME,
			PRODUCT.COMPANY_ID,
			PRODUCT.PRODUCT_ID
			<cfif (isdefined('attributes.is_alternative_products') and len(attributes.is_alternative_products)) OR (isdefined('attributes.is_related_catalogs') and len(attributes.is_related_catalogs))>,STOCKS.PROPERTY,STOCKS.STOCK_CODE,STOCKS.STOCK_ID<cfelse>,PRODUCT.PRODUCT_CODE STOCK_CODE, '' PROPERTY</cfif>
		FROM
			PRODUCT 
			<cfif (isdefined('attributes.is_alternative_products') and len(attributes.is_alternative_products)) OR (isdefined('attributes.is_related_catalogs') and len(attributes.is_related_catalogs))>,STOCKS</cfif>
		WHERE
			PRODUCT.PRODUCT_STATUS = 1
			<cfif len(attributes.product_cat)>
				AND PRODUCT.PRODUCT_CODE LIKE '#attributes.product_cat_code#.%'
			</cfif>
			<cfif isDefined("attributes.keyword") and len(attributes.keyword) gt 1>
				AND (PRODUCT.PRODUCT_NAME LIKE '%#attributes.keyword#%' OR PRODUCT.PRODUCT_CODE LIKE '%#attributes.keyword#%' OR PRODUCT.PRODUCT_CODE_2 LIKE '%#attributes.keyword#%')
			<cfelseif isDefined("attributes.keyword") and len(attributes.keyword) eq 1>
				AND (PRODUCT.PRODUCT_NAME LIKE '#attributes.keyword#%' OR PRODUCT.PRODUCT_CODE LIKE '#attributes.keyword#%' OR PRODUCT.PRODUCT_CODE_2 LIKE '#attributes.keyword#%')
			</cfif>	
			<cfif (isdefined('attributes.is_alternative_products') and len(attributes.is_alternative_products)) OR (isdefined('attributes.is_related_catalogs') and len(attributes.is_related_catalogs))>AND STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID</cfif>
			<cfif isdefined('attributes.product_catid') and len(attributes.product_catid)>AND PRODUCT.PRODUCT_CATID = #attributes.product_catid#</cfif>
		ORDER BY 
			PRODUCT.PRODUCT_NAME
	</cfquery>
<cfelse>
	<cfset PRODUCT_NAMES.recordcount=0>
</cfif>

<cfparam name="attributes.totalrecords" default="#product_names.recordcount#">

<cfset url_string = "">
<cfif isdefined("attributes.product_id")>
  <cfset url_string = "#url_string#&product_id=#attributes.product_id#">
</cfif>
<cfif isdefined("attributes.counter")>
	<cfset url_string = "#url_string#&counter=#attributes.counter#">
  </cfif>
<cfif isdefined("attributes.field_name")>
  <cfset url_string = "#url_string#&field_name=#field_name#">
</cfif>
<cfif isdefined("attributes.is_alternative_products") and len(attributes.is_alternative_products)>
  <cfset url_string = "#url_string#&is_alternative_products=#attributes.is_alternative_products#">
</cfif>
<cfif isdefined("attributes.is_related_catalogs")>
	<cfset url_string="#url_string#&is_related_catalogs=#attributes.is_related_catalogs#">
</cfif>		
<cfif isdefined("attributes.catalog_id") and len(attributes.catalog_id)>
	<cfset url_string = "#url_string#&catalog_id=#attributes.catalog_id#">
</cfif>							
<cfif isdefined("attributes.is_related_products")>
	<cfset url_string = "#url_string#&is_related_products=#attributes.is_related_products#">
</cfif>	
<cfset url_string2 = ''>
<cfif len(attributes.product_cat)>
	<cfset url_string2 = "#url_string2#&product_cat=#attributes.product_cat#&product_cat_code=#attributes.product_cat_code#">
</cfif>	

<cf_box title="#getLang('','Ürünler',57564)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_wrk_alphabet keyword="url_string" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="search_product" id="search_product" action="#request.self#?fuseaction=objects.popup_products_only#url_string#" method="post">
		<input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">			
		<cf_box_search>
			<cfif isdefined("attributes.field_name")><input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>"></cfif>
			<cfif isdefined("attributes.product_id")><input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>"></cfif>
			<div class="form-group">
				<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#" maxlength="255">
			</div>	
			<div class="form-group">
				<div class="input-group">
					<cfif get_product_cat_.recordcount>
						<input type="hidden" name="product_cat_code" id="product_cat_code" value="<cfoutput>#get_product_cat_.hierarchy#</cfoutput>">
						<input type="text" name="product_cat" id="product_cat" value="<cfoutput>#get_product_cat_.hierarchy# #get_product_cat_.product_cat#</cfoutput>">  
					<cfelse>
						<input type="hidden" name="product_cat_code" id="product_cat_code" value="<cfoutput>#attributes.product_cat_code#</cfoutput>">
						<input type="text" name="product_cat" id="product_cat" placeholder="<cfoutput>#getLang('','Ürün Kategorisi',29401)#</cfoutput>" value="<cfif len(attributes.product_cat)><cfoutput>#attributes.product_cat#</cfoutput></cfif>">  
					</cfif>
						<span class="input-group-addon icon-ellipsis btnPoniter" href="javascript://"onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=search_product.product_cat_code&field_name=search_product.product_cat');"></span>
				</div>
			</div>		
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_product' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>
	</cfform>
	<cf_flat_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='57518.Stok Kod'></th>
				<th><cf_get_lang dictionary_id='57657.Ürün'></th>
				<th><cf_get_lang dictionary_id='29533.Tedarikçi'></th>	
			</tr>
		</thead>
		<tbody>
			<cfif product_names.recordcount>
			<cfset sales_id = "">
			<cfset product_list = "">
			<cfset company_id_list="">
			<cfoutput query="product_names" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif len(product_id) and not listfind(product_list,product_id)>
					<cfset product_list = listappend(product_list,product_id)>
				</cfif>
				<cfif len(company_id) and not listfind(company_id_list,company_id)>
					<cfset company_id_list=listappend(company_id_list,company_id)>
				</cfif>
			</cfoutput>
			<cfif len(product_list)>
				<cfset product_list = listsort(product_list,"numeric","ASC",",")>
				<cfquery  name="get_prod_units" datasource="#dsn3#">
					SELECT DISTINCT ADD_UNIT,PRODUCT_UNIT_ID FROM PRODUCT_UNIT WHERE PRODUCT_ID IN  (#product_list#) ORDER BY ADD_UNIT
				</cfquery>
			</cfif>
			<cfif len(company_id_list)>
				<cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
				<cfquery name="get_company_detail" datasource="#dsn#">
					SELECT COMPANY_ID,NICKNAME FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
				</cfquery>
			</cfif>
			<cfoutput query="product_names" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
				<tr id="row_#currentrow#">
					<cfscript>
						add_unit = get_prod_units.add_unit[listfind(product_list,PRODUCT_ID,',')];
						product_unit_id = get_prod_units.product_unit_id[listfind(product_list,PRODUCT_ID,',')];
					</cfscript>
					<td>#PRODUCT_NAMES.STOCK_CODE#</td>
					<td>
						<cfif isdefined("is_related_products")>
							<a href="javascript://" onclick="send_product('#product_id#','#product_name#');">#product_name# <cfif len(PROPERTY)>- #PROPERTY#</cfif></a>
						<cfelseif isdefined('is_alternative_products')>
							<a href="javascript://" onclick="send_product('#product_id#','#product_name#','#stock_code#','#stock_id#','#add_unit#');">#product_name# <cfif len(PROPERTY)>- #PROPERTY#</cfif></a>
						<cfelseif isdefined('attributes.is_related_catalogs')>
							<a href="javascript://" onclick="send_product('#product_id#','#stock_id#',#attributes.catalog_id#,#currentrow#);">#product_name# <cfif len(PROPERTY)>- #PROPERTY#</cfif></a>
						<cfelse>
							<a href="javascript://" onclick="gonder('#product_id#','#product_name#',new Array(#ListQualify(add_unit,"'")#),new Array(#ListQualify(product_unit_id,"'")#));">#product_name#</a>
						</cfif>
					</td>
					<td><cfif len(company_id)>#get_company_detail.NICKNAME[listfind(company_id_list,COMPANY_ID,',')]#</cfif></td>
				</tr>
			</cfoutput>
			<cfelse>
				<tr>
					<td colspan="3"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
				</tr>
			</cfif>
		</tbody>
	</cf_flat_list>
	<cfif len(attributes.keyword)>
		<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
	</cfif>
	<cfif len(attributes.product_cat)>
		<cfset url_string = "#url_string#&product_cat=#attributes.product_cat#&product_cat_code=#attributes.product_cat_code#">
	</cfif>	
	<cfif isdefined("is_related_products")>
		<cfset url_string = "#url_string#&is_related_products=#attributes.is_related_products#">
	</cfif>		
	<cfif isdefined("attributes.is_related_catalogs")>
		<cfset url_string="#url_string#&is_related_catalogs=#attributes.is_related_catalogs#">
	</cfif>
	<cfif isdefined("attributes.catalog_id") and len(attributes.catalog_id)>
		<cfset url_string = "#url_string#&catalog_id=#attributes.catalog_id#">
	</cfif>	
	<cfif isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted)>
		<cfset url_string = "#url_string#&is_form_submitted=#attributes.is_form_submitted#">
	</cfif>	
	<cfif attributes.maxrows lt attributes.totalrecords>
		<cf_paging
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="objects.popup_products_only#url_string#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
</cf_box>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	<cfif isdefined("attributes.is_related_products") or isdefined('is_alternative_products') or isdefined("attributes.is_related_catalogs")>
		var kontrol=0;
		function send_product(p_id,urun,valueUnitArr,idUnitArr,unit)
		{
			kontrol=0;
			<cfif isdefined("attributes.is_related_catalogs")>
				var data = new FormData();  
				AjaxControlPostData("V16/worknet/cfc/worknet.cfc?method=add_related_product&catalog_id="+valueUnitArr+"&product_id="+p_id+"&stock_id="+urun, data, function(response){
					$("tr#row_"+idUnitArr).remove();
					jQuery('#list_related_products .catalyst-refresh' ).click();
				});
				return false;
			</cfif>
			<cfif not isdefined("is_alternative_products")>
				if(p_id == <cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById('pid').value)  
				{
					alert("<cf_get_lang dictionary_id='29759.Ilgili Urun Secilmistir'>");
					return false;
				}
				for(tt=1; tt<=<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById("record_num").value; tt++)
				{
					if(<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById('product_id'+tt) && <cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById('stock_id'+tt) && p_id == <cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById('product_id'+tt).value && idUnitArr == <cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById('stock_id'+tt).value  && <cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.getElementById('row_kontrol' + tt).value == 1)
					{
						kontrol = 1;
						break;
					}
				}
			</cfif>
			if (kontrol == 1)
			{
				alert("<cf_get_lang dictionary_id='29759.Ilgili Urun Secilmistir'>");
				return false;
			}
			else
			<cfif not isdefined("attributes.draggable")>opener.</cfif>product_gonder<cfif isdefined("attributes.counter")><cfoutput>#attributes.counter#</cfoutput></cfif>(p_id,urun,valueUnitArr,idUnitArr,unit);
		}
	<cfelse>	
		function gonder(p_id,urun,valueUnitArr,idUnitArr)
		{
			<cfoutput>
			<cfif isdefined("attributes.product_id")>
				<cfif not isdefined("attributes.draggable")>opener.</cfif>#attributes.product_id#.value = p_id;
			</cfif>
			<cfif isdefined("attributes.field_name")>
				<cfif not isdefined("attributes.draggable")>opener.</cfif>#attributes.field_name#.value = urun;
			</cfif>
			<cfif isdefined("attributes.constructUnitSelect")>
				<cfif not isdefined("attributes.draggable")>opener.</cfif>constructUnitSelect("#attributes.constructUnitSelect#",valueUnitArr,idUnitArr);
			</cfif>
			<cfif isdefined("attributes.process") and (attributes.process is "purchase_contract" or attributes.process is "sales_contract")>
				<cfif not isdefined("attributes.draggable")>opener.</cfif>findDuplicate(#attributes.process_var#);
			</cfif>
			</cfoutput>
			<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
		}
	</cfif>		
</script>
