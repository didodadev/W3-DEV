<!--- 
	Bu Sayfada yapilan degisiklik bu sayfada da yapilmali.
	<cfinclude template="list_product_sale_with_nolink.cfm">
	<cfinclude template="list_product_sale_with_link.cfm">
--->
<cfoutput>
<form name="product#currentrow#" method="post" action="">
<input type="hidden" name="is_serial_no" id="is_serial_no" value="#IS_SERIAL_NO#">
<input type="hidden" name="rowcount" id="rowcount" value="#rowcount#">
<cfif not isdefined("attributes.is_promotion")>
	<cfquery name="GET_PRO" datasource="#DSN3#">
		SELECT
			PROMOTIONS.DISCOUNT,
			PROMOTIONS.PROM_HEAD,
			PROMOTIONS.PROM_ID
		FROM
			STOCKS,PROMOTIONS
		WHERE
			STOCKS.PRODUCT_ID = #PRODUCTS.PRODUCT_ID# AND
			STOCKS.STOCK_ID = PROMOTIONS.STOCK_ID AND
			PROMOTIONS.STARTDATE <= #now()# AND
			PROMOTIONS.FINISHDATE >= #now()# AND
			PROMOTIONS.PRICE_CATID = #attributes.price_catid#
	</cfquery> 
	<cfif not len(get_pro.DISCOUNT)>
		<cfset pro_price = products.price>
	<cfelse>
		<cfset attributes.discount = get_pro.DISCOUNT>
		<cfset discount_per = (( (products.price) * attributes.discount) / 100)>
		<cfset pro_price = (products.price - discount_per)>
	</cfif>
<cfelse>				
	<cfset pro_price = products.price>
</cfif>
<cfscript>
if (isDefined("attributes.price_catid") and (not products.add_unit is products.main_unit) and (attributes.price_catid eq "-1"))
	pro_price = evaluate(products.price * products.multiplier);

if (row_money is default_money.money)
	{
		price_text = "#TLFormat(pro_price)#&nbsp;#money# (#products.add_unit#)";
		price = pro_price;
		price_other_add_session = pro_price;
		price_currency = money;
	}
else
	{
		float_cur_price = pro_price*(row_money_rate2/row_money_rate1);
		str_money = default_money.money;
	price_text = "#TLFormat(float_cur_price,#session.ep.our_company_info.sales_price_round_num#)#&nbsp;&nbsp;#str_money# (#products.add_unit#)";
	pro_price = pro_price*(row_money_rate2/row_money_rate1);
	price = pro_price;
	price_other_add_session = float_cur_price;
	price_currency = str_money;
	}
</cfscript>
<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
  <td>#stock_code#</td>
  <td style="cursor:pointer" onClick="javascript:opener.add_basket_row('#product_id#', '#stock_id#', '#stock_code#', '#barcod#', '#MANUFACT_CODE#', '#product_name# #property#', '#products.product_unit_id#', '#products.add_unit#', '', '', '#TLFormat(price)#', '#TLFormat(price_other_add_session)#', '#tax#', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', '','', '', '', '','','','', '','','','','','','','','','','0','','','','0','','');window.close();">#product_name#&nbsp;#property#</td>
  <td  style="text-align:right;">#price_text# <a href="##" onclick="submit_to_product_price_list(#currentrow#,1);"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a></td>
  <cfif not isdefined("attributes.is_promotion")>
	  <td align="center">
		<cfif get_pro.recordcount>
			<input type="hidden" name="prom_id" id="prom_id" value="#get_pro.prom_id#">
			<a href="javascript:windowopen('#request.self#?fuseaction=objects.popup_detail_promotion_unique&prom_id=#GET_PRO.PROM_ID#','list');"  class="tableyazi">#get_pro.prom_head# </a>(%#TLFormat(GET_PRO.DISCOUNT)#)
		<cfelse>
			-
		</cfif>
	  </td>
  </cfif>
  <cfif session.ep.our_company_info.workcube_sector is "it">
	<td  style="text-align:right;">#TLFormat(products.product_stock)# #products.main_unit#</td>
	<td  style="text-align:right;">
	</td>
	<cfset counter = currentrow>
	<cfloop query="get_deps">
		<cfquery name="GET_ROW_STOCKS" datasource="#DSN2#">
			SELECT 
				PRODUCT_STOCK
			FROM
				GET_STOCK_PRODUCT
			WHERE
				STOCK_ID = #PRODUCTS.STOCK_ID[counter]# AND
				DEPARTMENT_ID = #DEPARTMENT_ID#
		</cfquery>
		<td  style="text-align:right;"><a href="##" class="tableyazi" onClick="javascript:submit_to_add_session(#currentrow#,0,#DEPARTMENT_ID#);">#TLFormat(GET_ROW_STOCKS.PRODUCT_STOCK)# #products.main_unit#</a></td>
	</cfloop>
  </cfif>
  <td width="15" align="center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCTS.PRODUCT_ID#&sid=#stock_id#','list')"><img src="/images/update_list.gif" border="0"></a></td>
</tr>
</form>
</cfoutput>
