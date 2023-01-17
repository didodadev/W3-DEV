<cfsetting showdebugoutput="no">
<!--- ASIL ÜRÜN --->
<cfset multi = 1>
<!--- prom_relation_info, satır bazlı urune urun promosyonlarında 2 satır arasındaki baglantıyı tutar, boylece baskete aynı promosyondan birden fazla dusuruldugunde karısıklık olmaz  --->
<cfset prom_relation_info ='#CREATEUUID()#'>
<cfinclude template="add_basket_row_js.cfm">
<!--- PROMOSYON --->
<script type="text/javascript">
	var stock_id = <cfoutput>#trim(listgetat(attributes.promosyon_form_info,1,'|'))#</cfoutput>;
	var promotion_id = <cfoutput>#trim(listgetat(attributes.promosyon_form_info,2,'|'))#</cfoutput>;
	<cfif len(trim(listgetat(attributes.promosyon_form_info,3,'|')))>
		var free_stock_price = '<cfoutput>#trim(listgetat(attributes.promosyon_form_info,3,'|'))#</cfoutput>';
	<cfelse>
		var free_stock_price = 0;
	</cfif>
	var money = '<cfoutput>#trim(listgetat(attributes.promosyon_form_info,4,'|'))#</cfoutput>';
	var free_stock_amount = <cfoutput>#trim(listgetat(attributes.promosyon_form_info,5,'|')) * attributes.price_cat_amount_multiplier#</cfoutput>;
	
	<cfif isdefined('attributes.from_add_barcod') and attributes.from_add_barcod eq 1> //barkoddan seri urun ekleniyorsa
		parent.add_free_prom(stock_id,promotion_id,free_stock_price,money,free_stock_amount,0,'','','','<cfoutput>#prom_relation_info#</cfoutput>');
	<cfelse>
		window.opener.add_free_prom(stock_id,promotion_id,free_stock_price,money,free_stock_amount,0,'','','','<cfoutput>#prom_relation_info#</cfoutput>');
		if (<cfoutput>#update_product_row_id#</cfoutput> == 0)
			window.history.back();
		else
			window.close();
	</cfif>
</script>
