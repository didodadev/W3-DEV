<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.product_cat" default=''>
<cfparam name="attributes.product_cat_id" default=''> 
<cfparam name="attributes.barcode" default=''>
<cfparam name="attributes.fnk" default="">
<cfparam name="attributes.price_cat_id" default="-2">

<cfinclude template="../../objects/functions/get_prod_order_funcs.cfm">
<cfif isdefined("attributes.is_submitted")>
	<cfinclude template="../query/get_product_price_unit.cfm">
<cfelse>
	<cfset get_product_price.recordcount = 0>
</cfif>
<cfinclude template="../query/get_price_cats2.cfm">
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 ORDER BY MONEY DESC
</cfquery>
<cfset url_string = "">
<cfif isdefined("attributes.field_price_contract")>
	<cfset url_string = "#url_string#&field_price_contract=#attributes.field_price_contract#">
</cfif>
<cfif isdefined("attributes.field_price_contract_money")>
	<cfset url_string = "#url_string#&field_price_contract_money=#attributes.field_price_contract_money#">
</cfif>
<cfif isdefined("attributes.company_id")>
	<cfset url_string = "#url_string#&company_id=#attributes.company_id#">
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
<cfif isdefined("attributes.field_money_rate")>
	<cfset url_string = "#url_string#&field_money_rate=#attributes.field_money_rate#">
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
<cfif isdefined("attributes.field_otv")>
	<cfset url_string = "#url_string#&field_otv=#attributes.field_otv#">
</cfif>
<cfif isdefined("attributes.field_product_catid")>
	<cfset url_string = "#url_string#&field_product_catid=#attributes.field_product_catid#">
</cfif>
<cfif isdefined("attributes.count")>
	<cfset url_string = "#url_string#&count=#attributes.count#">
</cfif>
<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id)>
	<cfset url_string = "#url_string#&subscription_id=#attributes.subscription_id#">
</cfif>
<cfif isdefined("attributes.field_select_money_type") and len(attributes.field_select_money_type)>
	<cfset url_string = "#url_string#&field_select_money_type=#attributes.field_select_money_type#">
</cfif>
<cfif isdefined("attributes.fnk") and attributes.fnk eq 1> <!--- ürün servis işlemlerinde, ürün seçildiği gibi toplama fonksiyonu çalışsın diye koyuldu --->
	<cfset url_string = "#url_string#&fnk=1">
</cfif>

<cfset url_string2 = "">
<cfif len(attributes.product_cat)>
	<cfset url_string2 = "#url_string2#&product_cat=#attributes.product_cat#">
</cfif>
<cfif len(attributes.product_cat_id)>
	<cfset url_string2 = "#url_string2#&product_cat_id=#attributes.product_cat_id#">
</cfif>
<cfif len(attributes.barcode)>
	<cfset url_string2 = "#url_string2#&barcode=#attributes.barcode#">
</cfif>
<cfif len(attributes.price_cat_id)>
	<cfset url_string2 = "#url_string2#&price_cat_id=#attributes.price_cat_id#">
</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_product_price.recordCount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1 >
<cfset OldList = "#chr(34)#,#chr(39)#">
<cfset NewList = ",">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Ürünler',57564)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_wrk_alphabet keyword="url_string,url_string2" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="search_product" method="post" action="#request.self#?fuseaction=objects.popup_product_price_unit&#url_string#">
			<cf_box_search>
				<input type="hidden" name="is_submitted" id="is_submitted" value="1">
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="100" placeholder="#message#">
				</div>
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57633.Barkod'></cfsavecontent>
					<cfinput type="text" name="barcode" value="#attributes.barcode#" maxlength="13" placeholder="#message#">
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1," required="yes" message="Sayi_Hatasi_Mesaj">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_product' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
			<cf_box_search_detail search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_product' , #attributes.modal_id#)"),DE(""))#">
				<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
					<div class="form-group">
						<div class="input-group">
							<input type="hidden" name="product_cat_id" id="product_cat_id" value="<cfoutput>#attributes.product_cat_id#</cfoutput>">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='29401.Ürün Kategorisi'></cfsavecontent>
							<cfinput type="text" name="product_cat" value="#attributes.product_cat#" placeholder="#message#">
							<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=search_product.product_cat_id&field_name=search_product.product_cat</cfoutput>&keyword='+encodeURIComponent(document.search_product.product_cat.value));"></span>
						</div> 
					</div>
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
					<div class="form-group">
						<select name="price_cat_id" id="price_cat_id">
							<cfif (attributes.price_cat_id eq "-2")>				
								<option value="-2" selected><cf_get_lang dictionary_id='58721.Standart Satış'></option>
							<cfelse>
								<option value="-2"><cf_get_lang dictionary_id='58721.Standart Satış'></option>			  	  
							</cfif>
							<cfoutput query="get_price_cats"> 
								<option value="#price_catid#"<cfif (price_catid is attributes.price_cat_id)> selected</cfif>>#price_cat#</option>
							</cfoutput>
						</select>	
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
		<cf_grid_list>
			<thead>
			<tr>
				<th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
				<th><cf_get_lang dictionary_id='57657.Ürün'></th>
				<th><cf_get_lang dictionary_id='33005.Ana Birim'></th>
				<th><cf_get_lang dictionary_id='32717.Fiyat (KDV Hariç)'></th>			
			</tr>
			</thead>
			<tbody>
			<cfif get_product_price.recordcount>
				<cfoutput query="get_product_price" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#stock_code#</td>
						<cfset New_Product_Name = ReplaceList(product_name,OldList,NewList)>
						<cfif len(property)>
						<cfset New_Product_Name=New_Product_Name&"-"&property>
						</cfif>
						<cfquery name="get_money_row" dbtype="query">
							SELECT * FROM GET_MONEY WHERE MONEY = '#money#'
						</cfquery>
						<cfquery name="get_money_row_2" dbtype="query">
							SELECT * FROM GET_MONEY WHERE MONEY = '#price_money#'
						</cfquery>
						<cfset price_sbr = "">
						<cfset money_sbr = "">
						<cfset money_sbr_rate1 = "">
						<cfset money_sbr_rate2 = "">
						<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id)>
							<cfquery name="get_subscription_price" datasource="#dsn3#">
								SELECT TOP 1 PRICE_OTHER OTHER_MONEY_VALUE,OTHER_MONEY FROM SUBSCRIPTION_CONTRACT_ROW WHERE SUBSCRIPTION_ID = #attributes.subscription_id# AND PRODUCT_ID = #product_id# ORDER BY SUBSCRIPTION_ROW_ID DESC
							</cfquery>	
							<cfif get_subscription_price.recordcount>
								<cfset price_sbr = get_subscription_price.OTHER_MONEY_VALUE>
								<cfset money_sbr = get_subscription_price.OTHER_MONEY>
								<cfquery name="get_money_row_3" dbtype="query">
									SELECT * FROM GET_MONEY WHERE MONEY = '#get_subscription_price.OTHER_MONEY#'
								</cfquery>
								<cfset money_sbr_rate1 = get_money_row_3.rate1>
								<cfset money_sbr_rate2 = get_money_row_3.rate2>
							</cfif>
						</cfif>
						<td><a href="javascript://" class="tableyazi" onclick="send('#stock_id#','#product_id#','#New_Product_Name#','1','#tlFormat(price)#','#add_unit#','#product_unit_id#','#money#','#tax#','#otv#','#get_money_row.rate1#','#get_money_row.rate2#','#price_contract#','#price_money#;#get_money_row_2.rate1#;#get_money_row_2.rate2#','#product_catid#','#price_sbr#',<cfif len(money_sbr)>'#money_sbr#;#money_sbr_rate1#;#money_sbr_rate2#'<cfelse>''</cfif>);">#product_name# #property#</a></td>
						<td>#add_unit#</td>
						<td>
							<cfif isdefined("price_sbr") and len(price_sbr)>#tlFormat(price_sbr)#<cfelse>#tlFormat(price)#</cfif> <cfif isdefined("money_sbr") and len(money_sbr)>#money_sbr#<cfelse>#money#</cfif>
						</td>		
					</tr>			  
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="4" class="color-row"><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif> !</td>
				</tr>
			</cfif>
			</tbody>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfif len(attributes.keyword)>
				<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.product_cat)>
				<cfset url_string = "#url_string#&product_cat=#attributes.product_cat#">
			</cfif>
			<cfif len(attributes.product_cat_id)>
				<cfset url_string = "#url_string#&product_cat_id=#attributes.product_cat_id#">
			</cfif>
			<cfif len(attributes.barcode)>
				<cfset url_string = "#url_string#&barcode=#attributes.barcode#">
			</cfif>
			<cfif len(attributes.price_cat_id)>
				<cfset url_string = "#url_string#&price_cat_id=#attributes.price_cat_id#">
			</cfif>
			<cfif len(attributes.is_submitted)>
				<cfset url_string = "#url_string#&is_submitted=#attributes.is_submitted#">
			</cfif>
			<cfif isDefined("attributes.draggable") and len(attributes.draggable)>
				<cfset url_string = '#url_string#&draggable=#attributes.draggable#'>
			</cfif>
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#attributes.fuseaction##url_string#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
	</cf_box>
</div>		

<script type="text/javascript">
document.getElementById('keyword').focus();
function send(stock_id,product_id,product_name,amount,product_sale_price,product_unit,product_unit_id,money,tax,otv,rate1,rate2,price,price_money,product_catid,price_sbr,money_sbrt)
{
	<cfif isdefined("attributes.field_stock_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_stock_id#</cfoutput>.value = stock_id;
	</cfif>
	<cfif isdefined("attributes.field_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value = product_id;
	</cfif>
	<cfif isdefined("attributes.field_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = product_name;
	</cfif>
	<cfif isdefined("attributes.field_amount")>
		if(<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_amount#</cfoutput> != undefined)
			<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_amount#</cfoutput>.value = amount;
	</cfif>
	<cfif isdefined("attributes.field_unit_id")>
		if(<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_unit_id#</cfoutput> != undefined)
			<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_unit_id#</cfoutput>.value = product_unit_id;
	</cfif>
	<cfif isdefined("attributes.field_unit")>
		if(<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_unit#</cfoutput> != undefined)
			<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_unit#</cfoutput>.value = product_unit;
	</cfif>
	<cfif isdefined("attributes.field_price")>
		<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id)>
			if(price_sbr != '')
				<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_price#</cfoutput>.value = price_sbr;		
			else
				<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_price#</cfoutput>.value = product_sale_price;		
		<cfelse>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_price#</cfoutput>.value = product_sale_price;
		</cfif>
	</cfif>
	<cfif isdefined("attributes.field_money")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_money#</cfoutput>.value = money;
	</cfif>
	<cfif isdefined("attributes.field_money_rate")>
		<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id)>
			if(money_sbrt != '')
				<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_money_rate#</cfoutput>.value = money_sbrt;
			else
				<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_money_rate#</cfoutput>.value = money+';'+rate1+';'+rate2;
		<cfelse>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_money_rate#</cfoutput>.value = money+';'+rate1+';'+rate2;
		</cfif>
	</cfif>
	<cfif isDefined("attributes.field_money2")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_money2#</cfoutput>.value = money;
	</cfif>	
	<cfif isdefined("attributes.field_tax")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_tax#</cfoutput>.value = tax;
	</cfif>
	<cfif isdefined("attributes.field_otv")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_otv#</cfoutput>.value = otv;
	</cfif>
	<cfif isdefined("attributes.field_price_contract")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_price_contract#</cfoutput>.value = price;
		<cfif isdefined("attributes.field_total_price")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_total_price#</cfoutput>.value = price;
		</cfif>
	<cfelse>
		<cfif isdefined("attributes.field_total_price")>
			<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id)>
				if(price_sbr != '')
					<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_total_price#</cfoutput>.value = price_sbr;
				else
					<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_total_price#</cfoutput>.value = product_sale_price;
			<cfelse>
				<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_total_price#</cfoutput>.value = product_sale_price;
			</cfif>
		</cfif>
	</cfif>
	<cfif isdefined("attributes.field_price_contract_money")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_price_contract_money#</cfoutput>.value = price_money;
	</cfif>
	<cfif isdefined("attributes.field_product_catid") and isdefined("attributes.count")>
		<cfif not isdefined("attributes.draggable")>window.opener.document.</cfif><cfoutput>#attributes.field_product_catid#</cfoutput>.value = product_catid;
		<cfif not isdefined("attributes.draggable")>window.opener.</cfif>get_service_cat('<cfoutput>#attributes.count#</cfoutput>',product_catid);
	</cfif>
	<cfif isdefined("attributes.field_select_money_type")>
		var selectMoneyType = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_select_money_type#</cfoutput>.querySelectorAll('option');
		selectMoneyType.forEach((obj) => {
			if(obj.value.split(';')[1] == money){
				obj.selected = true;
			}
		});
	</cfif>
	<cfif isdefined("attributes.fnk") and  attributes.fnk eq 1>
		<cfif not isdefined("attributes.draggable")>window.opener.</cfif>toplam_kontrol();
	</cfif>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>		
}
</script>
