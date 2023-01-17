<cfinclude template="../query/get_moneys.cfm">
<cfinclude template="../query/get_department_product.cfm">
<cfset url_str = ''>
<cfif isdefined("is_sale_product")>
	<cfset url_str = "#url_str#&is_sale_product=#is_sale_product#">
</cfif>
<cfif isdefined("attributes.is_cost")>
	<cfset url_str = "#url_str#&is_cost=#attributes.is_cost#">
</cfif>
<cfif isdefined("attributes.search_process_date") and isdate(attributes.search_process_date)>
	<cfset url_str = "#url_str#&search_process_date=#attributes.search_process_date#">
</cfif>
<cfif isdefined("sepet_process_type")>
	<cfset url_str = "#url_str#&sepet_process_type=#sepet_process_type#">
</cfif>
<!--- 30 güne silinsin aselam 20062003
<cfif isdefined("attributes.is_fcurrency")>
	<cfset url_str = "#url_str#&is_fcurrency=#attributes.is_fcurrency#">
</cfif> --->
<cfif isdefined("attributes.company_id")>
	<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
</cfif>
<cfif isDefined('attributes.rowcount') and len(attributes.rowcount)>
	<cfset url_str = "#url_str#&rowcount=#attributes.rowcount#">
</cfif>
<cfif isDefined('attributes.is_price') and len(attributes.is_price)>
	<cfset url_str = "#url_str#&is_price=#attributes.is_price#">
</cfif>
<cfloop query="moneys">
	<cfif isdefined("attributes.#money#")>
		<cfset url_str = "#url_str#&#money#=#evaluate("attributes.#money#")#">
	</cfif>
</cfloop>
<cfparam name="attributes.pid" default="#attributes.product_id#">
<cfinclude template="../query/get_stocks.cfm">
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="35" class="headbold"><cf_get_lang dictionary_id='58166.Stoklar'></td>
	<td  style="text-align:right;"><a href="##" onClick="history.go(-1);"><img src="/images/back.gif" border="0" title="<cf_get_lang dictionary_id='57432.Geri'>"></a></td>	
  </tr>
</table>

<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr class="color-border">
<td>
<table width="100%" border="0" cellpadding="2" cellspacing="1">
  <tr class="color-header">
	<td height="22" class="form-title"><cf_get_lang dictionary_id='58763.Depo'></td>
	<td width="70"  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></td>
	<td width="70" class="form-title"><cf_get_lang dictionary_id='57636.Birim'></td>
	<td width="90"  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='32546.Verilen Sipariş(Beklenen)'></td>			  
	<td width="90"  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='32545.Alınan Sipariş(Rezerve)'></td>
  </tr>
  <cfif GET_STOCKS_ALL.RECORDCOUNT >
	<cfoutput query="GET_STOCKS_ALL">
   <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
		<td><a href="##" onclick="javascript:set_opener_dep('#department_id#','#DEPARTMENT_HEAD#');" class="tableyazi">#DEPARTMENT_HEAD# #PROPERTY#</a></td>
		<td  style="text-align:right;"><cfif PRODUCT_STOCK lt 0 ><font color="red">#TLFormat(PRODUCT_STOCK)#</font><cfelse>#TLFormat(PRODUCT_STOCK)#</cfif></td>
		<td>#ATTRIBUTES.UNIT#</td>
		<td  style="text-align:right;">
			<cfif len(department_id)>
				<cfquery name="get_purc" dbtype="query">
					SELECT SUM(AMOUNT) AMOUNT FROM get_reserved_orders_sale WHERE DEPARTMENT_ID=#department_id#
				</cfquery>
				#numberformat(get_purc.AMOUNT)#
			</cfif>
		</td>
		<td  style="text-align:right;">
			<cfif len(department_id)>
				<cfquery name="get_purc" dbtype="query">
					SELECT SUM(AMOUNT) AMOUNT FROM get_reserved_orders_purchase WHERE DEPARTMENT_ID=#department_id#
				</cfquery>
				#numberformat(get_purc.AMOUNT)#
			</cfif>
		</td>		
	  </tr>
	</cfoutput>
	<cfelse>
	<tr class="color-row">
	  <td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
	</tr>
  </cfif>
</table>
</td>
</tr>
</table>
<cfoutput>
<form name="form_product" method="post"  action="#request.self#?fuseaction=objects.emptypopup_add_basket_row#url_str#">
	<input type="Hidden" name="from_price_page" id="from_price_page" value="1">
	<input type="Hidden" name="update_product_row_id" id="update_product_row_id" value="#update_product_row_id#">
	<input type="Hidden" name="product_id" id="product_id" value="#product_id#" >
	<input type="Hidden" name="stock_id" id="stock_id" value="#stock_id#">
	<input type="Hidden" name="stock_code" id="stock_code" value="#stock_code#">
	<input type="Hidden" name="barcod" id="barcod" value="#barcod#">
	<input type="Hidden" name="manufact_code" id="manufact_code" value="#manufact_code#">
	<input type="Hidden" name="product_name" id="product_name" value="#product_name#">
	<input type="Hidden" name="unit_id" id="unit_id" value="">
	<input type="Hidden" name="unit" id="unit" value="">
	<input type="Hidden" name="unit_multiplier" id="unit_multiplier" value="#unit_multiplier#">
	<input type="Hidden" name="product_code" id="product_code" value="#product_code#">
	<input type="Hidden" name="amount" id="amount" value="#amount#">
	<input type="hidden" name="is_serial_no" id="is_serial_no" value="#is_serial_no#">
 	<input type="hidden" name="kur_hesapla" id="kur_hesapla" value="#kur_hesapla#">	
	<input type="hidden" name="is_sale_product" id="is_sale_product" value="<cfif isdefined("is_sale_product")><cfoutput>#is_sale_product#</cfoutput><cfelse>-1</cfif>">
	<input type="hidden" name="tax" id="tax"  value="#tax#">
	<input type="hidden" name="flt_price_other_amount" id="flt_price_other_amount"  value="">
	<input type="hidden" name="str_money_currency" id="str_money_currency"  value="">
	<input type="hidden" name="is_inventory" id="is_inventory" value="#is_inventory#">
	<input type="hidden" name="net_maliyet" id="net_maliyet"  value="">
	<input type="hidden" name="marj" id="marj"  value="">	
	<input type="Hidden" name="department_id" id="department_id" value="">
	<input type="Hidden" name="department_name" id="department_name" value="">	
	<input type="Hidden" name="due_day_value" id="due_day_value" value="<cfif isdefined("attributes.due_day_value")>#attributes.due_day_value#</cfif>">
	<input type="hidden" name="row_promotion_id" id="row_promotion_id" value="#row_promotion_id#">
	<input type="hidden" name="promosyon_yuzde" id="promosyon_yuzde" value="#promosyon_yuzde#">
	<input type="hidden" name="promosyon_maliyet" id="promosyon_maliyet" value="#promosyon_maliyet#">
	<input type="hidden" name="shelf_number" id="shelf_number" value="">
	<input type="hidden" name="deliver_date" id="deliver_date" value="">
</form>
</cfoutput>
<script type="text/javascript">
function set_opener_dep(department_id,department_name)
{
<!--- 	
	/*
	product_exists = false;

 SIL 90 GUNE
<cfif workcube_sector is "it">
	if (opener.rowCount > 1)
		{
		for (i=1; (!product_exists) && (i<=opener.rowCount); i++)
			if (opener.form_basket.stock_id[i-1].value == <cfoutput>#stock_id#</cfoutput>)
				{
				product_exists = true;
				opener.form_basket.amount[i-1].value++;
				opener.hesapla('amount',i);
				}
		}
	else if (opener.rowCount == 1)
		{
		if (opener.form_basket.stock_id.value == <cfoutput>#stock_id#</cfoutput>)
			{
			product_exists = true;
			opener.form_basket.amount.value++;
			opener.hesapla('amount',1);
			}
		}
</cfif> 
	if (!product_exists)
		{
	*/
--->
		form_product.department_id.value = department_id;
		form_product.department_name.value = department_name;
		form_product.submit();
		/*
		}
		*/
}
</script>
