<cfparam name="attributes.prod_conf_id" default="0">
<cfparam name="attributes.pcat_products" default="0">
<cfparam name="attributes.first_selection_id" default="-1">
<cfif attributes.prod_conf_id is 0>
	<cfset attributes.first_selection_id = -1>
</cfif>
<cfinclude template="../query/get_product_config.cfm">

<cfif not isdefined("attributes.print")>
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="35" align="center">
  <tr class="color-list">
    <td class="headbold">&nbsp;<cf_get_lang no='404.Ürün Konfigürasyonu'> :
	<cfoutput query="GET_SETUP_PRODUCT_CONFIGURATOR">
		<cfif attributes.prod_conf_id is PRODUCT_CONFIGURATOR_ID>#CONFIGURATOR_NAME#</cfif>
	</cfoutput>	
	</td>
	<td  style="text-align:right;">
	<a href="javascript://" onClick="<cfoutput>windowopen('#request.self#?fuseaction=objects2.popup_product_configure_proposal&print=true#page_code#','page')</cfoutput>"><img src="/images/print.gif" title="<cf_get_lang_main no='1331.Gonder'>" border="0"></a>
  	</td>
  </tr>
</table>
</cfif>

<br/>
<cfinclude template="../../objects/display/view_company_logo.cfm">
<br/>

<table cellpadding="0" cellspacing="0" width="700" align="center">
	<tr>
		<td  class="txtbold" style="text-align:right;"><cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput></td>
	</tr>
	<tr>
		<td>
			<cf_get_lang no='365.ürünü ile ilgili olarak aşağıda belirtilen değişikliklerin yapılarak hazırlanacak olan yeni sistemi ile ilgili teklif'>...
		</td>
	</tr>
</table>
<br/>
  <table width="700" border="0" align="center">
	<cfif GET_SETUP_PRODUCT_CONFIGURATOR.recordcount>		
        <tr height="22">
          <td class="txtbold" width="150"><cf_get_lang no='139.Bileşenler'></td>
          <td class="txtbold"><cf_get_lang_main no='152.Ürünler'></td>
		  <td class="txtbold"><cf_get_lang_main no='223.Miktar'></td>
          <td width="100"  class="txtbold" style="text-align:right;"><cf_get_lang_main no='226.Birim Fiyat'></td>
          <td width="150"  class="txtbold" style="text-align:right;"><cf_get_lang_main no='672.Fiyat'></td>
		</tr>
		  <cfinclude template="../query/get_product_config_components.cfm">	
		  <cfscript>
			  total_price = 0;
			  total_price_kdvli = 0;
			  total_price_stdmoney = 0;
			  total_price_kdvli_stdmoney = 0;
		  </cfscript>
		<!--- Sayfa ilk geldiğinde 1 satır sadece key dönecek, sonra hepsi --->
		<cfif attributes.first_selection_id is -1>
			<cfset att_maxrows="1">
		<cfelse>
			<cfset att_maxrows=get_setup_product_configurator_components.recordcount>
		</cfif>
        <cfoutput query="get_setup_product_configurator_components" maxrows="#att_maxrows#">
			<!--- BK kapatti neden oldugunu anlamadi 20070424 120 gune siline
			<cfif attributes.first_selection_id is -1>
				<cfset sub_pcatid = get_setup_product_configurator_components.sub_product_cat_id>
				<cfset sub_pcat_hier = get_setup_product_configurator_components.hierarchy>
			<cfelse>
				<cfset sub_pcatid = get_setup_product_configurator_components.sub_product_cat_id>
				<cfset sub_pcat_hier = get_setup_product_configurator_components.hierarchy>
			</cfif> --->
			<cfset sub_pcatid = get_setup_product_configurator_components.sub_product_cat_id>
			<cfset sub_pcat_hier = get_setup_product_configurator_components.hierarchy>
			
			<cfif evaluate('attributes.pcat_products_#sub_pcatid#')>
            <tr height="20">
              <td class="txtbold">#PRODUCT_CAT# <cfif isDefined('iliskili_varyok_pcatids') and ListFind(iliskili_varyok_pcatids,sub_pcatid)><cfset not_var = 1><font color="FF0000" size="2">*</font></cfif></td>
			  <cfinclude template="../query/get_pcat_products.cfm">	
			  <td>
					<cfloop query="get_pcat_products">
						<cfif isDefined('attributes.pcat_products_#sub_pcatid#') and evaluate('attributes.pcat_products_#sub_pcatid#') is STOCK_ID>
						#PRODUCT_NAME# <cfif PROPERTY is '-'><cfelseif len(PROPERTY) gt 1>#PROPERTY#</cfif>
						</cfif> 
					</cfloop>	
			  </td>
			  <td>
				<cfif isDefined('iliskili_miktar_pcatids') and ListFind(iliskili_miktar_pcatids,sub_pcatid)>
					<cfloop from="1" to="#ListGetAt(iliskili_miktar,ListFind(iliskili_miktar_pcatids,sub_pcatid))#" index="amount_index">
						<cfif isDefined('attributes.pcat_products_amount_#sub_pcatid#') and evaluate('attributes.pcat_products_amount_#sub_pcatid#') is amount_index>
						#amount_index#
						</cfif>						
					</cfloop>	
				<cfelse>
				1
				</cfif>
			  </td>
			  <td  style="text-align:right;">
				<cfloop query="get_pcat_products">
					<cfif isDefined('attributes.pcat_products_#sub_pcatid#') and evaluate('attributes.pcat_products_#sub_pcatid#') is STOCK_ID>
			 		#PRICE# #MONEY#
					</cfif>
				</cfloop>
			  </td>
			  <td  style="text-align:right;">
				<cfloop query="get_pcat_products">
					<cfif isDefined('attributes.pcat_products_amount_#sub_pcatid#') and evaluate('attributes.pcat_products_amount_#sub_pcatid#')>
						<cfset price_found = PRICE * evaluate('attributes.pcat_products_amount_#sub_pcatid#')>
						<cfset price_stdmoney_found = PRICE_STDMONEY * evaluate('attributes.pcat_products_amount_#sub_pcatid#')>
						<cfset price_kdv_found = PRICE_KDV * evaluate('attributes.pcat_products_amount_#sub_pcatid#')>
						<cfset price_kdv_stdmoney_found = PRICE_KDV_STDMONEY * evaluate('attributes.pcat_products_amount_#sub_pcatid#')>
					<cfelse>
						<cfset price_found = PRICE>
						<cfset price_stdmoney_found = PRICE_STDMONEY>
						<cfset price_kdv_found = PRICE_KDV>
						<cfset price_kdv_stdmoney_found = PRICE_KDV_STDMONEY>
					</cfif>					
					<cfif isDefined('attributes.pcat_products_#sub_pcatid#') and evaluate('attributes.pcat_products_#sub_pcatid#') is STOCK_ID>
						<!--- <input type="hidden" name="price" value="#TLFormat(price_found)# #MONEY#"> --->
						#TLFormat(price_found)# #MONEY#
		  				<cfscript>
						price_money = MONEY;
						total_price = total_price + price_found;
						total_price_stdmoney = total_price_stdmoney + price_stdmoney_found;
						if (IS_KDV is 1)
						{
							fiyatkdvli = price_kdv_found;
							fiyatkdvli_stdmoney = price_kdv_stdmoney_found;
						}
						else
						{
							fiyatkdvli = price_found * (1 + tax / 100);
							fiyatkdvli_stdmoney = price_kdv_stdmoney_found * (1 + tax / 100);
						}
						total_price_kdvli = total_price_kdvli + fiyatkdvli;
						total_price_kdvli_stdmoney = total_price_kdvli_stdmoney + fiyatkdvli_stdmoney;
		  				</cfscript>
					</cfif>
				</cfloop>
			  </td>
            </tr>
			</cfif>
        </cfoutput>
		<cfif isDefined("fiyatkdvli")><!--- Ürün seçilmiş ise buraya gir --->
			  <cfoutput>
				<tr height="20">
					<td colspan="5">&nbsp;</td>
				</tr>
				<tr height="20">
					<td colspan="4"  class="formbold" style="text-align:right;"><cf_get_lang_main no='80.TOPLAM'></td>
					<td  style="text-align:right;">#TLFormat(total_price)# #price_money#</td>
				</tr>
				<tr height="20">
					<td colspan="4"  class="formbold" style="text-align:right;"><cf_get_lang no='137.TOPLAM KDV li'></td>
					<td  style="text-align:right;">#TLFormat(total_price_kdvli)# #price_money#</td>
				</tr>
				<tr height="20">
					<td colspan="4"  class="formbold" style="text-align:right;"><cf_get_lang_main no='80.TOPLAM'> (#GET_STDMONEY.MONEY#)</td>
					<td  style="text-align:right;">#TLFormat(total_price_stdmoney)# #GET_STDMONEY.MONEY#</td>
				</tr>
				<tr height="20">
					<td colspan="4"  class="formbold" style="text-align:right;"><cf_get_lang no='137.TOPLAM KDV li'> (#GET_STDMONEY.MONEY#)</td>
					<td  style="text-align:right;">#TLFormat(total_price_kdvli_stdmoney)#  #GET_STDMONEY.MONEY#</td>
				</tr>
			  </cfoutput>
		</cfif>
	</cfif>		
  </table>
<br/>
<cfinclude template="../../objects/display/view_company_info.cfm">
<br/>

<cfif isdefined("attributes.print")>
	<script type="text/javascript">
	function waitfor(){
	  window.close();
	}
	setTimeout("waitfor()",3000);
	window.print();
</script>
</cfif>

