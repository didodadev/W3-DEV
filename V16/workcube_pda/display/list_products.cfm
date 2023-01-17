<cfquery name="GET_CATEGORIES" datasource="#DSN1#">
	SELECT 
		PC.PRODUCT_CAT,
		PC.PRODUCT_CATID
	FROM 
		PRODUCT_CAT PC,
		PRODUCT_CAT_OUR_COMPANY PCO
	WHERE 
		PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
		PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
		PC.IS_PUBLIC = 1 
	ORDER BY 
		PC.LIST_ORDER_NO,PC.HIERARCHY
</cfquery>

<cfparam name="attributes.product_ids_list" default=''>
<cfif isdefined('attributes.order_id') and len(attributes.order_id)>
	<cfquery name="GET_ORDER_DETAIL" datasource="#dsn3#" blockfactor="1">
		SELECT 
		P.PRODUCT_ID
	FROM 
		ORDERS,
		ORDER_ROW,
		PRODUCT P,
		STOCKS S
	WHERE 
		ORDERS.ORDER_ID = ORDER_ROW.ORDER_ID AND
		S.PRODUCT_ID = P.PRODUCT_ID AND
		S.STOCK_ID = ORDER_ROW.STOCK_ID AND
		ORDERS.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
	</cfquery>
	<cfoutput query="get_order_detail">
		<cfif len(product_id) and not listfind(attributes.product_ids_list,product_id)>
			<cfset attributes.product_ids_list = Listappend(attributes.product_ids_list,product_id)>
		</cfif>
	</cfoutput>
</cfif>

<cfquery name="GET_PROPERTY_VAR" datasource="#DSN1#">
	SELECT
		PP.PROPERTY_ID,
		PP.PROPERTY,
		PPD.PROPERTY_DETAIL_ID,
		PPD.PROPERTY_DETAIL
	FROM
		PRODUCT_PROPERTY PP,
		PRODUCT_PROPERTY_DETAIL PPD
	WHERE
		PP.PROPERTY_ID = PPD.PRPT_ID
	ORDER BY
		PP.PROPERTY,
		PPD.PROPERTY_DETAIL
</cfquery>

<cfif not (isdefined('attributes.amount') and len(attributes.amount))>
	<cfset default_ = 5>
</cfif>

<cfif not (isdefined('attributes.stock_status') and len(attributes.stock_status))>
	<cfset default_status = 1>
</cfif>

<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.price_cat_id" default="-2">
<cfif isdefined('attributes.form_submited')>
	<cfinclude template="../query/get_products.cfm">
<cfelse>
	<cfset get_product_price.recordcount = 0>
</cfif>
<cfset url_string = "">

<cfif isdefined("attributes.form_submited") and len(attributes.form_submited)>
	<cfset url_string =  "#url_string#&form_submited=#attributes.form_submited#">
</cfif>
<cfif isdefined("attributes.field_stock_id")>
	<cfset url_string = "#url_string#&field_stock_id=#attributes.field_stock_id#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_string = "#url_string#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.field_amount")>
	<cfset url_string = "#url_string#&field_amount=#attributes.field_amount#">
</cfif>		
<cfif isdefined("attributes.field_unit_id")>
	<cfset url_string = "#url_string#&field_unit_id=#attributes.field_unit_id#">
</cfif>		
<cfif isdefined("attributes.field_unit")>
	<cfset url_string = "#url_string#&field_unit=#attributes.field_unit#">
</cfif>
<cfif isdefined("attributes.field_price")>
	<cfset url_string = "#url_string#&field_price=#attributes.field_price#">
</cfif>		
<cfif isdefined("attributes.field_total_price")>
	<cfset url_string = "#url_string#&field_total_price=#attributes.field_total_price#">
</cfif>		
<cfif isdefined("attributes.field_money")>
	<cfset url_string = "#url_string#&field_money=#attributes.field_money#">
</cfif>
<cfif isdefined("attributes.field_money2")>
	<cfset url_string = "#url_string#&field_money2=#attributes.field_money2#">
</cfif>
<cfif isdefined("attributes.field_tax")>
	<cfset url_string = "#url_string#&field_tax=#attributes.field_tax#">
</cfif>
<cfif isdefined("attributes.field_code")>
	<cfset url_string = "#url_string#&field_code=#attributes.field_code#">
</cfif>
<cfset url_string2 = "">
<cfset url_string2 = attributes.fuseaction>
<cfif len(attributes.price_cat_id)>
	<cfset url_string2 = "#url_string2#&price_cat_id=#attributes.price_cat_id#">
</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.pda.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_product_price.recordCount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1 >

<table cellspacing="0" cellpadding="0" align="center" style="height:35px; width:98%">
	<tr>
		<td class="headbold"><cf_get_lang_main no='152.Ürünler'></td>
		<td align="right" valign="bottom" style="width:90%">
    		<table style="width:100%">
    			<cfform name="search_product" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#&#url_string#">
				<input type="hidden" name="field_row_count" id="field_row_count" value="<cfif isdefined('attributes.field_row_count') and len(attributes.field_row_count)><cfoutput>#attributes.field_row_count#</cfoutput></cfif>" /> 
				<input type="hidden" name="field_currentrow" id="field_currentrow" value="<cfif isdefined('attributes.field_currentrow') and len(attributes.field_currentrow)><cfoutput>#attributes.field_currentrow#</cfoutput></cfif>" />
				<input type="hidden" name="form_submited" id="form_submited" value="1" />
				<input type="hidden" name="product_ids_list" id="product_ids_list" value="<cfif isdefined('attributes.product_ids_list')><cfoutput>#attributes.product_ids_list#</cfoutput></cfif>" />
				<input type="hidden" name="is_basket" id="is_basket" value="<cfif isdefined('attributes.is_basket')><cfoutput>#attributes.is_basket#</cfoutput></cfif>" />
				<input type="hidden" name="price_cat_id" id="price_cat_id" value="<cfoutput>#attributes.price_cat_id#</cfoutput>" />
				<input type="hidden" name="list_property_id" id="list_property_id" value="<cfif isdefined("attributes.list_property_id")><cfoutput>#attributes.list_property_id#</cfoutput></cfif>">
				<input type="hidden" name="list_variation_id" id="list_variation_id" value="<cfif isdefined("attributes.list_variation_id")><cfoutput>#attributes.list_variation_id#</cfoutput></cfif>">
				<tr>
					<td align="right">
						<select name="product_cat" id="product_cat">
							<cfoutput query='get_categories'>			
								<option value="#product_catid#" <cfif isdefined('attributes.product_cat') and attributes.product_cat eq product_catid>selected</cfif>>#product_cat#</option>
							</cfoutput>
						</select>
						<select name="sort_type" id="sort_type">
							<option value="">Tümü</option>
							<option value="1"<cfif isdefined('attributes.sort_type') and attributes.sort_type eq 1>selected</cfif>>Stok Miktarı Artan</option>
							<option value="2"<cfif isdefined('attributes.sort_type') and attributes.sort_type eq 2>selected</cfif>>Stok Miktarı Azalan</option>
							<option value="3"<cfif isdefined('attributes.sort_type') and attributes.sort_type eq 3>selected</cfif>>Stok Yaşı Artan</option>
							<option value="4"<cfif isdefined('attributes.sort_type') and attributes.sort_type eq 4>selected</cfif>>Stok Yaşı Azalan</option>
							<option value="5"<cfif isdefined('attributes.sort_type') and attributes.sort_type eq 5>selected</cfif>>Ada Göre Artan</option>
							<option value="6"<cfif isdefined('attributes.sort_type') and attributes.sort_type eq 6>selected</cfif>>Ada Göre Azalan</option>
						</select>
						<select name="amount" id="amount">
							<option value="1"<cfif isdefined('attributes.amount') and attributes.amount eq 1>selected</cfif>>1</option>
							<option value="2"<cfif isdefined('attributes.amount') and attributes.amount eq 2>selected</cfif>>2</option>
							<option value="3"<cfif isdefined('attributes.amount') and attributes.amount eq 3>selected</cfif>>3</option>
							<option value="4"<cfif isdefined('attributes.amount') and attributes.amount eq 4>selected</cfif>>4</option>
							<option value="5"<cfif (isdefined('attributes.amount') and attributes.amount eq 5) or (isdefined('default_') and len(default_))>selected</cfif>>5</option>
							<option value="6"<cfif isdefined('attributes.amount') and attributes.amount eq 6>selected</cfif>>6</option>
						</select>
			  		</td>
				</tr>
				<tr>
					<td align="right" style="vertical-align:bottom">
						<select name="stock_status" id="stock_status">
							<option value="0"<cfif isdefined('attributes.stock_status') and attributes.stock_status eq 0>selected</cfif>>Stok Durumu</option>
							<option value="1"<cfif isdefined('attributes.stock_status') and attributes.stock_status eq 1>selected</cfif>>Pozitif Stok</option>
							<option value="2"<cfif isdefined('attributes.stock_status') and attributes.stock_status eq 2>selected</cfif>>Negatif Stok</option>
						</select>
						Stok :<input type="checkbox" name="is_saleable_stock" id="is_saleable_stock" value="1" <cfif isdefined('attributes.is_saleable_stock') and attributes.is_saleable_stock eq 1>checked</cfif>>
						Bedelsiz Ürün :<input type="checkbox" name="free_product" id="free_product" value="1" <cfif isdefined('attributes.free_product') and attributes.free_product eq 1>checked</cfif>>
						Marka:
						<input type="hidden" name="brand_id" id="brand_id" value="<cfif isdefined('attributes.brand_id') and len(attributes.brand_id) and isdefined('attributes.brand_name') and len(attributes.brand_name)><cfoutput>#attributes.brand_id#</cfoutput></cfif>" />
						<input type="text" name="brand_name" id="brand_name" value="<cfif isdefined('attributes.brand_id') and len(attributes.brand_id) and isdefined('attributes.brand_name') and len(attributes.brand_name)><cfoutput>#attributes.brand_name#</cfoutput></cfif>"> 
						<a class="tableyazi" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=pda.popup_list_brands&brand_id=search_product.brand_id&&brand_name=search_product.brand_name','list');"><img  src="/images/plus_thin.gif" border="0" style="cursor:hand;" align="absbottom"></a>
						<input type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>" maxlength="100">    
						<cfsavecontent variable="message">Lütfen Miktar Alanını Giriniz!</cfsavecontent>
						<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" validate="integer" range="1," required="yes" message="#message#" style="width:20px;">
						<input type="image" src="../../images/ara_blue.gif" onClick="kontrol();"/>
						<a href="javascript://" onClick="gizle_goster(detail_search);" ><img src="/images/find.gif" border="0"></a>	
					</td>
	  			</tr>
			</table>
    	</td>
  	</tr>
	<tr id="detail_search" style="display:none;" class="color-list">
		<td colspan="2">
			<cfinclude template="detailed_product_search.cfm" />
		</td>
	</tr> 
</table>
<table cellspacing="0" cellpadding="0" border="0" align="center" style="width:98%">
	<cfif get_product_price.recordcount>
		<cfset stock_id_list = ''>
		<cfoutput query="get_product_price" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfset stock_id_list = listappend(stock_id_list,stock_id)>
		</cfoutput>
		<cfquery name="GET_MONEYS"  datasource="#DSN#">
			SELECT MONEY, RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.period_id#"> 
		</cfquery>
		<cfif isdefined('attributes.is_saleable_stock') and attributes.is_saleable_stock eq 1 and len(stock_id_list)>
			<cfquery name="GET_LAST_STOCKS" datasource="#DSN2#">
				SELECT SALEABLE_STOCK,STOCK_ID FROM GET_STOCK_LAST WHERE STOCK_ID IN(#stock_id_list#)
			</cfquery>
		</cfif>
		<cfoutput query="get_product_price" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfif (currentrow mod attributes.amount) eq 1>
				</tr>
			</cfif>
				<td>
					<table style="width:100%">
						<tr>
							<cfquery name="GET_PRODUCT_IMAGES" datasource="#DSN3#">
								SELECT PATH,PRODUCT_ID,PATH_SERVER_ID,DETAIL FROM PRODUCT_IMAGES WHERE IMAGE_SIZE = 0 AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> ORDER BY PRODUCT_ID
							</cfquery>
							<td colspan="2" align="center">
								<cfif len(get_product_images.path)>
									<img src="/documents/product/#get_product_images.path#" border="0" style="height:180px;">
								</cfif>
							</td>
						</tr>
						<tr>
							<td colspan="2" align="center"><b>#product_name#</b></td>
						</tr>	
						<cfquery name="GET_MONEY" dbtype="query">
							SELECT RATE2,* FROM GET_MONEYS WHERE MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#money#"> 
						</cfquery>
						<tr>
							<td colspan="2" align="center">
								<cfif get_money.recordcount and len(get_money.rate2) and len(price_kdv)>
									<input type="text" name="price_kdv_#currentrow#" id="price_kdv_#currentrow#" maxlength="8"  style="border-width:0px;text-align:center;font-weight:bold;" value="#TLFormat(price_kdv * get_money.rate2)#"> <b>TL</b>
								</cfif>
							</td>
						</tr>
						<cfif isdefined('attributes.is_saleable_stock') and attributes.is_saleable_stock eq 1>
							<cfquery name="GET_LAST_STOCK" dbtype="query">
								SELECT SALEABLE_STOCK FROM GET_LAST_STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#">
							</cfquery>
							<tr>
								<td colspan="2" align="center"><b>#get_last_stock.saleable_stock#</b></td>
							</tr>
						</cfif>
						<cfif isdefined('attributes.is_basket') and attributes.is_basket neq 0>
							<tr>
								<td align="right" style="width:50%">
									<input type="text" name="miktar_#currentrow#" id="miktar_#currentrow#" value="1" maxlength="8" <cfif listfind(attributes.product_ids_list,get_product_price.product_id,',')>style="background-color:58A0C0;color:FFFFFF;width:25px;"<cfelse>class="moneybox" style="width:25px;"</cfif> onkeyup="return FormatCurrency(this,event,0);">
								</td>
								<td><a href="javascript://" onClick="add_barcode2('#get_product_price.product_name#','#get_product_price.barcod#','#currentrow#');"><img src="../../images/sepete_ekle.jpg" border="0"/></a></td>
							</tr>
						</cfif>	
					</table>
				</td>
			<cfif currentrow mod attributes.amount eq 0>
				</tr>
        	</cfif>
		</cfoutput>
	<cfelse>
		<tr>
			<td colspan="2" class="color-row"><cfif isdefined("attributes.form_submited")><cf_get_lang_main no='72.Kayıt Yok'>!<cfelse><cf_get_lang_main no='289.filtre ediniz'>!</cfif></td>
		</tr>
	</cfif>
	</cfform>
</table>

<cfif attributes.totalrecords gt attributes.maxrows>
	<table cellpadding="2" cellspacing="0" border="0" align="center" style="width:98%">
  		<tr height="2">
			<td>
		  		<cfset url_string = attributes.fuseaction>
		  		<cfif len(attributes.keyword)>
					<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
		  		</cfif>
		  		<cfif isdefined('attributes.brand_id') and len(attributes.brand_id)>
					<cfset url_string = "#url_string#&brand_id=#attributes.brand_id#">
		  		</cfif>
		  		<cfif isdefined('attributes.sort_type') and len(attributes.sort_type)>
					<cfset url_string = "#url_string#&sort_type=#attributes.sort_type#">
				</cfif>
		  		<cfif isdefined('attributes.is_saleable_stock') and len(attributes.is_saleable_stock)>
					<cfset url_string = "#url_string#&is_saleable_stock=#attributes.is_saleable_stock#">
	 	 		</cfif>
          		<cfif isdefined('attributes.brand_name') and len(attributes.brand_name)>
					<cfset url_string = "#url_string#&brand_name=#attributes.brand_name#">
	  			</cfif>
 	  			<cfif isdefined('attributes.field_row_count') and len(attributes.field_row_count)>
					<cfset url_string = "#url_string#&field_row_count=#attributes.field_row_count#">
	  			</cfif>
	 			<cfif isdefined('attributes.form_submited') and len(attributes.form_submited)>
					<cfset url_string = "#url_string#&form_submited=#attributes.form_submited#">
	  			</cfif>
	  			<cfif isdefined('attributes.amount') and len(attributes.amount)>
					<cfset url_string = "#url_string#&amount=#attributes.amount#">
	  			</cfif>
	  			<cfif isdefined('attributes.price_cat_id') and len(attributes.price_cat_id)>
					<cfset url_string = "#url_string#&price_cat_id=#attributes.price_cat_id#">
	  			</cfif>
	  			<cfif isdefined('attributes.stock_status') and len(attributes.stock_status)>
					<cfset url_string = "#url_string#&stock_status=#attributes.stock_status#">
	  			</cfif>
	  			<cfif isdefined('attributes.product_cat') and len(attributes.product_cat)>
					<cfset url_string = "#url_string#&product_cat=#attributes.product_cat#">
	  			</cfif>
	  			<cfif isdefined("attributes.form_submited") and len(attributes.form_submited)>
					<cfset url_string =  "#url_string#&form_submited=#attributes.form_submited#">
				</cfif>
				<cfif isdefined("attributes.field_stock_id")>
					<cfset url_string = "#url_string#&field_stock_id=#attributes.field_stock_id#">
				</cfif>
				<cfif isdefined("attributes.field_id")>
					<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
				</cfif>
				<cfif isdefined("attributes.field_name")>
					<cfset url_string = "#url_string#&field_name=#attributes.field_name#">
				</cfif>
				<cfif isdefined("attributes.field_amount")>
					<cfset url_string = "#url_string#&field_amount=#attributes.field_amount#">
				</cfif>		
				<cfif isdefined("attributes.field_unit_id")>
					<cfset url_string = "#url_string#&field_unit_id=#attributes.field_unit_id#">
				</cfif>		
				<cfif isdefined("attributes.field_unit")>
					<cfset url_string = "#url_string#&field_unit=#attributes.field_unit#">
				</cfif>
				<cfif isdefined("attributes.field_price")>
					<cfset url_string = "#url_string#&field_price=#attributes.field_price#">
				</cfif>		
				<cfif isdefined("attributes.field_total_price")>
					<cfset url_string = "#url_string#&field_total_price=#attributes.field_total_price#">
				</cfif>		
				<cfif isdefined("attributes.field_money")>
					<cfset url_string = "#url_string#&field_money=#attributes.field_money#">
				</cfif>
				<cfif isdefined("attributes.field_money2")>
					<cfset url_string = "#url_string#&field_money2=#attributes.field_money2#">
				</cfif>
				<cfif isdefined("attributes.field_tax")>
					<cfset url_string = "#url_string#&field_tax=#attributes.field_tax#">
				</cfif>
				<cfif isdefined("attributes.field_code")>
					<cfset url_string = "#url_string#&field_code=#attributes.field_code#">
				</cfif>	
				<cfif isdefined("attributes.is_basket")>
					<cfset url_string = "#url_string#&is_basket=#attributes.is_basket#">
				</cfif>
				<cfif isdefined("attributes.product_ids_list")>
					<cfset url_string = "#url_string#&product_ids_list=#attributes.product_ids_list#">
				</cfif>
				<cfif isDefined('attributes.list_property_id') and len(attributes.list_property_id)>
					<cfset url_string = '#url_string#&list_property_id=#attributes.list_property_id#'>
				</cfif>	
				<cfif isDefined('attributes.list_variation_id') and len(attributes.list_variation_id)>
					<cfset url_string = '#url_string#&list_variation_id=#attributes.list_variation_id#'>
				</cfif>	
				<cfif attributes.totalrecords>
					<cfparam name="attributes.page" default=1>
					<cfparam name="attributes.maxrows" default=20>
					<cfparam name="attributes.totalrecords" default=1>
					<cfparam name="attributes.page_type" default="3">
					<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
					<cfset lastpage = (attributes.totalrecords \ attributes.maxrows) + iif(attributes.totalrecords mod attributes.maxrows,1,0) >
					<!-- sil -->
					<cfoutput>
						<!--- Tüm linklerin oncliklerine go_pages fonksiyonu ekledik,ilk değer eklenecek olan form adını,2.ci değer ise sayfa numarasını tutuyor. --->
						<cfif not listlen(attributes.page_type) or listfind(attributes.page_type,1)>
							<cfif attributes.page neq 1><a href="##" onClick="_go_page_('cf_pages_form_name1','1');" style="margin-left:5px;margin-right:5px;"></cfif><font size="+4" >&laquo;</font><cfif attributes.page neq 1></a></cfif>
							<cfif attributes.page neq 1><a href="##" onClick="_go_page_('cf_pages_form_name1','#Evaluate(attributes.page-1)#');" style="margin-left:5px;margin-right:5px;"></cfif><font size="+4" >&lsaquo;</font><cfif attributes.page neq 1></a></cfif>
							<cfif attributes.page neq lastpage><a href="##" onClick="_go_page_('cf_pages_form_name1','#Evaluate(attributes.page+1)#');" style="margin-left:5px;margin-right:5px;"></cfif><font size="+4" >&rsaquo;</font><cfif attributes.page neq lastpage></a></cfif>
							<cfif attributes.page neq lastpage><a href="##" onClick="_go_page_('cf_pages_form_name1','#lastpage#');" style="margin-left:5px;margin-right:5px;"></cfif><font size="+4" >&raquo;</font><cfif attributes.page neq lastpage></a></cfif>
						</cfif>
						<cfif listlen(attributes.page_type) and listfind(attributes.page_type,2)>
							<cfif attributes.page neq 1><a href="##" onClick="_go_page_('cf_pages_form_name2','1');"  class="tableyazi" style="margin-left:5px;margin-right:5px;"></cfif><img src="../images/arrowleft.png" border="0" height="30"><cfif attributes.page neq 1></a></cfif>
							<cfif attributes.page - 2 gt 0><a href="##" onClick="_go_page_('cf_pages_form_name2','#attributes.page-2#');" style="margin-left:5px;margin-right:5px;">[#attributes.page-2#]</a><cfelse>[..]</cfif>
							<cfif attributes.page - 1 gt 0><a href="##" onClick="_go_page_('cf_pages_form_name2','#attributes.page-1#');" style="margin-left:5px;margin-right:5px;">[#attributes.page-1#]</a><cfelse>[..]</cfif>			
							<b>[#attributes.page#]</b>
							<cfif attributes.page + 1 lte lastpage ><a href="##" onClick="_go_page_('cf_pages_form_name2','#attributes.page+1#');" style="margin-left:5px;margin-right:5px;">[#attributes.page+1#]</a><cfelse>[..]</cfif>
							<cfif attributes.page + 2 lte lastpage ><a href="##" onClick="_go_page_('cf_pages_form_name2','#attributes.page+2#');" style="margin-left:5px;margin-right:5px;">[#attributes.page+2#]</a><cfelse>[..]</cfif>
							<cfif attributes.page neq lastpage><a href="##" onClick="_go_page_('cf_pages_form_name2','#lastpage#');"class="tableyazi" style="margin-left:5px;margin-right:5px;"></cfif><img src="../images/arrowright.png" border="0" height="30"><cfif attributes.page neq lastpage></a></cfif>
						 </cfif>
						<cfif listlen(attributes.page_type) and listfind(attributes.page_type,3)>
							<select name="select_pages" id="select_pages" onChange="_go_page_('cf_pages_form_name3',+' '+ this.value +' ');">
								<cfloop from="1" to="#lastpage#" index="pp">
									<option value="#pp#"<cfif attributes.page eq pp >selected</cfif>>#pp#</option>
								</cfloop>	
							</select>.Sayfaya Git
						</cfif>
					</cfoutput>
					<!-- sil -->
				</cfif>
				<cfoutput>
					<form id="_fav_xpage_" name="cf_pages_form_name#attributes.page_type#" method="post" action="<cfoutput>#request.self#?fuseaction=#ListGetAt(ListGetAt(url_string,1,'&'),1,'=')#</cfoutput>">
						<input type="hidden" name="maxrows" id="maxrows"  value="#attributes.maxrows#">
						<input type="hidden" name="page" id="page"  value="#attributes.page#">
						<cfloop from="1" to="#listlen(url_string,'&')#" index="adr">
							<input type="hidden" name="#ListGetAt(ListGetAt(url_string,adr,'&'),1,'=')#" id="#ListGetAt(ListGetAt(url_string,adr,'&'),1,'=')#" value="<cfif listlen(ListGetAt(url_string,adr,'&'),'=') eq 2>#ListGetAt(ListGetAt(url_string,adr,'&'),2,'=')#</cfif>">
						</cfloop>
					</form>
			   	</cfoutput>
				<script language="javascript">
					function _go_page_(form_name,page_number)
					{
						//hangi page_type seçildiyse ona göre oluşan form üzerinde page değeri dolduruluyor ve submit ediliyor.
						eval("document."+ form_name).page.value = filterNum(page_number);
						eval("document."+ form_name).submit();
					}
				</script>
			</td>
    		<!-- sil -->
			<td align="right"><cfoutput> <cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
			<!-- sil -->
  		</tr>
	</table>
</cfif>
<script type="text/javascript">
	function kontrol(){
		document.getElementById('list_property_id').value="";
		document.getElementById('list_variation_id').value="";
		row_count=<cfoutput>#get_property_var.recordcount#</cfoutput>;
		for(r=1;r<=row_count;r++)
		{     
			deger_variation_id = eval('document.getElementById("variation_id'+r+'")');
			if(deger_variation_id!=undefined && deger_variation_id.value != "")
			{  
				deger_property_id = eval('document.getElementById("property_id'+r+'")');
				if(document.getElementById('list_property_id').value.length==0) ayirac=''; else ayirac=',';
				document.getElementById('list_property_id').value=document.getElementById('list_property_id').value+ayirac+deger_property_id.value;
				document.getElementById('list_variation_id').value=document.getElementById('list_variation_id').value+ayirac+deger_variation_id.value;
			}
		}
		if(document.getElementById('amount').value>0)
			document.getElementById('amount').value=filterNum(document.getElementById('amount').value);
		else
			document.getElementById('amount').value=1;
		return true;
	}

	function add_barcode2(prodname,barcode,crntrw)//,stock_cntrl
	{  
		var barcode_found = 0;
		var xx = opener.document.getElementById("row_count").value;
		if(xx > 0)
		{	
			for(var i=1; i<=xx; i++)      
			{
				if(eval('opener.document.getElementById("row_kontrol'+i+'")').value ==1)
				{
					if(barcode == eval('opener.document.getElementById("barcode'+i+'")').value)
					{
						eval('opener.document.getElementById("amount'+i+'")').value = parseFloat(eval('opener.document.getElementById("amount'+i+'")').value) + parseFloat(eval('opener.document.getElementById("miktar_'+crntrw+'")').value); 
						barcode_found = 1;
						break;
					}	
				}	    
			}
		}	
		if(barcode_found == 0)
		{   
			no = parseInt(opener.document.getElementById('row_count').value);
			no++;        
			goster(opener.document.getElementById('n_my_div'+no));
			eval('opener.document.getElementById("row_kontrol'+no+'")').value = 1;
			eval('opener.document.getElementById("barcode'+no+'")').value = barcode;
			//eval('opener.document.getElementById("prod_name'+no+'")').value = prodname;

			if(eval('opener.document.getElementById("price_kdv'+no+'")'))
			{
				if(document.getElementById('free_product').checked == false)
				{
					eval('opener.document.getElementById("price_kdv'+no+'")').value = eval('document.getElementById("price_kdv_'+crntrw+'")').value;  
					eval('opener.document.getElementById("is_free_product'+no+'")').value = 0;
				}
				else
				{
					eval('opener.document.getElementById("price_kdv'+no+'")').value = 0; 
					eval('opener.document.getElementById("is_free_product'+no+'")').value = 1; 
					eval('opener.document.getElementById("detail'+no+'")').value = 'BEDELSİZ ÜRÜN';
				}
			}
			else
			{
				if(document.getElementById('free_product').checked == false)
				{ 
					eval('opener.document.getElementById("is_free_product'+no+'")').value = 0;
				}
				else
				{
					eval('opener.document.getElementById("is_free_product'+no+'")').value = 1; 
					eval('opener.document.getElementById("detail'+no+'")').value = 'BEDELSİZ ÜRÜN';
				}
			}
			eval('opener.document.getElementById("amount'+no+'")').value= eval('document.getElementById("miktar_'+crntrw+'")').value;
			eval('opener.document.getElementById("amount'+no+'")').focus();
			opener.document.getElementById('row_count').value = parseInt(opener.document.getElementById('row_count').value) + 1;
		}	
	}  
	document.getElementById('keyword').focus();
</script>
