<cfscript>
	if(listfindnocase(partner_url,'#cgi.http_host#',';'))
	{
		int_money = session.pp.money;
		int_comp_id = session.pp.our_company_id;
		int_period_id = session.pp.period_id;
		int_money2 = session.pp.money2;
	}
	else if (listfindnocase(server_url,'#cgi.http_host#',';') )
	{	
		int_money = session.ww.money;
		int_comp_id = session.ww.our_company_id;
		int_period_id = session.ww.period_id;
		int_money2 = session.ww.money2;
	}
	else if (listfindnocase(employee_url,'#cgi.http_host#',';'))
	{
		int_money = session.ep.money;
		int_comp_id = session.ep.company_id;
		int_period_id = session.ep.period_id;
		int_money2 = session.ep.money2;
	}
</cfscript>
<cfquery name="GET_MONEY_ALL" datasource="#DSN#">
	SELECT
		COMPANY_ID,
		PERIOD_ID,
		MONEY,
		RATE1,
		<cfif isDefined("session.pp")>
			RATEPP2 RATE2
		<cfelseif isDefined("session.ww")>
			RATEWW2 RATE2
		<cfelse>
			RATE2 RATE2
		</cfif>
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_period_id#">
</cfquery>

<cfquery name="GET_" dbtype="query">
	SELECT * FROM GET_SETUP_PRODUCT_CONFIGURATOR WHERE PRODUCT_CONFIGURATOR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_configurator_id#">
</cfquery>
<table cellspacing="1" cellpadding="2" border="0" style="vertical-align:top; text-align:center">
	<cfoutput>
		<tr>
			<td style="vertical-align:top">
				<cf_get_server_file output_file="product/#get_.configurator_image#" output_server="#get_.configurator_server_image_id#" output_type="0" image_link="5" alt="#getLang('main',668)#" title="#getLang('main',668)#">
	    </td>
			<td style="vertical-align:top"><font class="formbold">#get_.configurator_name#</font>
				<br /><br />
				#get_.configurator_detail#
		  </td>
		</tr>
	</cfoutput>
</table>
<table cellspacing="1" cellpadding="2" border="0" style="vertical-align:top; width:98%">
	<cfform name="product_configuration" action="#request.self#?fuseaction=objects2.product_configure" method="post">
	<input type="hidden" name="submit_type" id="submit_type" value="<cfoutput>#attributes.submit_type#</cfoutput>">
	<input type="hidden" name="product_configurator_id" id="product_configurator_id" value="<cfoutput>#attributes.product_configurator_id#</cfoutput>">
	<tr class="color-header" style="height:22px;">
        <td class="form-title" style="width:150px;"><cf_get_lang no='139.Bileşenler'></td>
        <td class="form-title"><cf_get_lang_main no='152.Ürünler'></td>
        <td class="form-title" style="width:60px;"><cf_get_lang_main no='223.Miktar'></td>
        <td class="form-title" style="text-align:right; width:100px;"><cf_get_lang_main no='226.Birim Fiyat'></td>
        <td class="form-title" style="text-align:right; width:150px;"><cf_get_lang_main no='672.Fiyat'></td>
	</tr>
	<cfif attributes.submit_type eq 1>
	  	<cfquery name="GET_KEY" datasource="#DSN3#">
			SELECT 
				SETUP_PRODUCT_CONFIGURATOR_COMPONENTS.IS_KEY_COMPONENT,
				SETUP_PRODUCT_CONFIGURATOR_COMPONENTS.SUB_PRODUCT_CAT_ID,
				SETUP_PRODUCT_CONFIGURATOR_COMPONENTS.PROPERTY_ID,
				SETUP_PRODUCT_CONFIGURATOR_COMPONENTS.MAX_AMOUNT,
				SETUP_PRODUCT_CONFIGURATOR_COMPONENTS.PROPERTY_DETAIL,
				PRODUCT_CAT.PRODUCT_CAT,
				PRODUCT_CAT.HIERARCHY
			FROM 
				SETUP_PRODUCT_CONFIGURATOR_COMPONENTS,
				PRODUCT_CAT
			WHERE 
				SETUP_PRODUCT_CONFIGURATOR_COMPONENTS.IS_KEY_COMPONENT = 1 AND
				PRODUCT_CAT.PRODUCT_CATID  = SETUP_PRODUCT_CONFIGURATOR_COMPONENTS.SUB_PRODUCT_CAT_ID AND
				PRODUCT_CONFIGURATOR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_configurator_id#">
			ORDER BY
				SETUP_PRODUCT_CONFIGURATOR_COMPONENTS.ORDER_NO
		</cfquery>
		<cfif get_key.recordcount>
			<cfquery name="GET_KEY_PRODUCT" datasource="#DSN3#">
				SELECT 
					STOCKS.STOCK_ID,
					PRODUCT.PRODUCT_NAME,
					STOCKS.PROPERTY
				FROM 
					#dsn1_alias#.PRODUCT_DT_PROPERTIES PRODUCT_DT_PROPERTIES,
					PRODUCT,
					STOCKS,
					PRODUCT_CAT
				WHERE 
					PRODUCT_DT_PROPERTIES.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
					PRODUCT.PRODUCT_CATID = PRODUCT_CAT.PRODUCT_CATID AND
					PRODUCT_CAT.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_key.sub_product_cat_id#"> AND
					STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID
					<cfif len(get_key.property_id)>AND PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_key.property_id#"></cfif>
			</cfquery>
		</cfif>
	  	<cfoutput query="get_key">
			<tr style="height:20px;" class="color-row">
				<td>#product_cat#</td>
				<td>
					<select name="get_key_product1" id="get_key_product1" onChange="javascript:product_config_change(2);" style="width:300px;">
						<option value="0"><cf_get_lang_main no ='322.Seçiniz'></option>
						<cfloop query="get_key_product">
							<option value="#stock_id#">#product_name# <cfif len(property) and property neq '-'>#property#</cfif></option>
						</cfloop>
					</select>
				</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
	  	</cfoutput>
	<cfelseif attributes.submit_type eq 2>
		<cfquery name="GET_MAIN" datasource="#DSN3#">
			SELECT 
				SETUP_PRODUCT_CONFIGURATOR_COMPONENTS.*,
				PRODUCT_CAT.PRODUCT_CAT,
				PRODUCT_CAT.HIERARCHY,
				PRODUCT_CAT.PRODUCT_CATID
			FROM 
				SETUP_PRODUCT_CONFIGURATOR_COMPONENTS,
				PRODUCT_CAT
			WHERE 
				PRODUCT_CAT.PRODUCT_CATID  = SETUP_PRODUCT_CONFIGURATOR_COMPONENTS.SUB_PRODUCT_CAT_ID AND
				PRODUCT_CONFIGURATOR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_configurator_id#">
			ORDER BY
				SETUP_PRODUCT_CONFIGURATOR_COMPONENTS.ORDER_NO
		</cfquery>
		<cfset main_total_price = 0>
		<cfset main_total_price_kdv = 0>
		<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_main.recordcount#</cfoutput>">
		<cfoutput query="get_main">
			<cfquery name="GET_MAIN_PRODUCT" datasource="#DSN3#">
				SELECT 
					STOCKS.STOCK_ID,
					PRODUCT.PRODUCT_NAME,
					STOCKS.PROPERTY,
					PRODUCT_DT_PROPERTIES.PROPERTY_ID
				FROM 
					#dsn1_alias#.PRODUCT_DT_PROPERTIES PRODUCT_DT_PROPERTIES,
					PRODUCT,
					STOCKS,
					PRODUCT_CAT
				WHERE 
					PRODUCT_DT_PROPERTIES.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
					PRODUCT.PRODUCT_CATID = PRODUCT_CAT.PRODUCT_CATID AND
					PRODUCT_CAT.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_main.product_catid#"> AND
					STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID
					<cfif len(get_main.property_id)>AND PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_main.property_id#"></cfif>
			</cfquery>
			<cfif isdefined("attributes.get_key_product#currentrow#")>
				<cfset value_get_key_product = evaluate('attributes.get_key_product#currentrow#')>
			<cfelse>
				<cfset value_get_key_product = 0>
			</cfif>
			<cfif isdefined("attributes.amount#currentrow#")>
				<cfset value_amount = evaluate('attributes.amount#currentrow#')>
			<cfelse>
				<cfset value_amount = 0>
			</cfif>
			<cfquery name="GET_PRODUCT_AMOUNT" datasource="#DSN3#">
				SELECT 
					PRODUCT.PRODUCT_NAME,
					PRODUCT.TAX,
					PRODUCT.PRODUCT_ID,
					PRODUCT.PRODUCT_CATID,
					PRICE_STANDART.PRICE,
					PRICE_STANDART.PRICE_KDV,
					PRICE_STANDART.MONEY,
				<cfif isDefined("session.pp")>
					(PRICE_STANDART.PRICE*(SM.RATEPP2/SM.RATE1)) AS PRICE_STDMONEY,
					(PRICE_STANDART.PRICE_KDV*(SM.RATEPP2/SM.RATE1)) AS PRICE_KDV_STDMONEY,
				<cfelse>
					(PRICE_STANDART.PRICE*(SM.RATEWW2/SM.RATE1)) AS PRICE_STDMONEY,
					(PRICE_STANDART.PRICE_KDV*(SM.RATEWW2/SM.RATE1)) AS PRICE_KDV_STDMONEY,
				</cfif>
					PRODUCT_UNIT.PRODUCT_UNIT_ID,
					PRODUCT_DT_PROPERTIES.PROPERTY_ID,
					PRODUCT_DT_PROPERTIES.AMOUNT
				FROM
					PRODUCT,
					PRICE_STANDART,
					#dsn_alias#.SETUP_MONEY AS SM,
					STOCKS,
					PRODUCT_UNIT,
					PRODUCT_CAT,
					#dsn1_alias#.PRODUCT_DT_PROPERTIES PRODUCT_DT_PROPERTIES
				WHERE
					PRODUCT_DT_PROPERTIES.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
					PRODUCT.PRODUCT_CATID = PRODUCT_CAT.PRODUCT_CATID AND	
					PRODUCT.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID AND	
					PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND	
					PRODUCT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
					SM.MONEY = PRICE_STANDART.MONEY AND
					SM.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_period_id#"> AND
					STOCKS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#value_get_key_product#"> AND
					PURCHASESALES = 1 AND
					PRICESTANDART_STATUS = 1 AND
					PRODUCT_UNIT.IS_MAIN = 1 
					<cfif len(property_id)>AND PRODUCT_DT_PROPERTIES.PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#property_id#"></cfif>
				ORDER BY
					PRODUCT.PRODUCT_NAME
			</cfquery>
			<cfif len(get_product_amount.price)>
				<cfset value_price = get_product_amount.price>
				<cfset value_total_price = get_product_amount.price*value_amount>
				<cfset main_total_price = main_total_price + (get_product_amount.price_stdmoney*value_amount)>
				<cfset main_total_price_kdv = main_total_price_kdv + (get_product_amount.price_kdv_stdmoney*value_amount)>
			<cfelse>
				<cfset value_price = 0>
				<cfset value_total_price = 0>
			</cfif>
			<input type="hidden" name="property_id#currentrow#" id="property_id#currentrow#" value="#property_id#">
			<input type="hidden" name="money_type#currentrow#" id="money_type#currentrow#" value="#get_product_amount.money#">
			<input type="hidden" name="value_price#currentrow#" id="value_price#currentrow#" value="#value_price#">
			<input type="hidden" name="value_total_price#currentrow#" id="value_total_price#currentrow#" value="#value_total_price#">
			<cfif is_key_component eq 1>
				<tr class="color-row" style="height:20px;">
					<td>#product_cat# <cfif len(property_detail)>- (<b>#property_detail#</b>)</cfif></td>
					<td>
						<select name="get_key_product#currentrow#" id="get_key_product#currentrow#" onChange="javascript:product_config_change(2);" style="width:300px;">
					  		<option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
						  	<cfloop query="get_main_product">
								<option value="#stock_id#" <cfif value_get_key_product eq stock_id>selected</cfif>>#get_main_product.product_name# <cfif len(property) and property neq '-'>#property#</cfif></option>
						  	</cfloop>
						</select>
					</td>
					<td>
						<select name="amount#currentrow#" id="amount#currentrow#" onChange="javascript:product_config_change(2);" style="width:60px;">
						  	<option value="1">1</option>
						</select>
					</td>
					<td style="text-align:right;"><cfif value_price neq 0>#tlformat(value_price)#</cfif> #get_product_amount.money#</td>
					<td style="text-align:right;"><cfif value_total_price neq 0>#tlformat(value_total_price)#</cfif> #get_product_amount.money#</td>
				</tr>
			</cfif>
			<cfif is_key_component eq 0>
				<tr class="color-row" style="height:20px;">
					<td>#product_cat# <cfif len(property_detail)>- (<b>#property_detail#</b>)</cfif></td>
					<td>
						<select name="get_key_product#currentrow#" id="get_key_product#currentrow#" onChange="javascript:product_config_change(2);" style="width:300px;">
							<option value="0"><cf_get_lang_main no ='322.Seçiniz'></option>
							<cfloop query="get_main_product">
								<option value="#stock_id#" <cfif value_get_key_product eq stock_id>selected</cfif>>#product_name# <cfif len(property) and property neq '-'>#property#</cfif></option>
						  	</cfloop>
						</select>
					</td>
					<td>
						<cfif (get_product_amount.recordcount) and len(get_product_amount.amount) and (get_product_amount.amount neq 0)>
							<select name="amount#currentrow#" id="amount#currentrow#" onChange="javascript:product_config_change(2);" style="width:60px;">
								<cfloop from="1" to="#get_product_amount.amount#" index="i">
								<option value="#i#" <cfif value_amount eq i>selected</cfif>>#i#</option>
								</cfloop>
							</select>
						<cfelseif len(max_amount)>
							<select name="amount#currentrow#" id="amount#currentrow#" onChange="javascript:product_config_change(2);" style="width:60px;">
								<cfloop from="1" to="#max_amount#" index="i">
									<option value="#i#">#i#</option>
								</cfloop>
							</select>		
						<cfelse>
							<select name="amount#currentrow#" id="amount#currentrow#" onChange="javascript:product_config_change(2);" style="width:60px;">
								<option value="1">1</option>
							</select>
						</cfif>
					</td>
					<td style="text-align:right;"><cfif value_price neq 0>#tlformat(value_price)#</cfif> #get_product_amount.money#</td>
					<td style="text-align:right;"><cfif value_total_price neq 0>#tlformat(value_total_price)#</cfif> #get_product_amount.money#</td>
				</tr>
			</cfif>
			</cfoutput>
			<cfquery name="GET_MONEY" dbtype="query">
				SELECT RATE2, RATE1 FROM GET_MONEY_ALL WHERE MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#int_money2#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_period_id#">
			</cfquery>
			<cfquery name="GET_KUR" dbtype="query">
				SELECT RATE2, RATE1,MONEY FROM GET_MONEY_ALL WHERE MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.money#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_period_id#">
			</cfquery>
			<cfoutput>
			  	<tr class="color-row" style="height:20px;">
			  		<td rowspan="4">
						<table>
					  		<tr>
								<td class="txtbold"><cf_get_lang no='140.Döviz Kurları'></td>
					  		</tr>
					  		<cfloop query="get_kur">
					  			<tr>
									<td class="txtbold">#money#</td>
									<td class="txt_kur">#TLFormat(rate2/rate1,4)#</td>
					  			</tr>
					  		</cfloop>
						</table>
					</td>
					<td colspan="3" class="txtbold" style="text-align:right;"><cf_get_lang_main no='80.TOPLAM'></td>
					<td class="txtbold" style="text-align:right;"><input type="hidden" name="main_total_price" id="main_total_price" value="#main_total_price#">#tlformat(main_total_price)# #int_money#</td>
			  	</tr>
			  	<tr class="color-row" style="height:20px;">
					<td colspan="3" class="txtbold" style="text-align:right;"><cf_get_lang no='137.TOPLAM KDV li'></td>
					<td class="txtbold" style="text-align:right;"><input type="hidden" name="main_total_price_kdv" id="main_total_price_kdv" value="#main_total_price_kdv#">#tlformat(main_total_price_kdv)# #int_money#</td>
			  	</tr>
			  	<tr class="color-row" style="height:20px;">
					<td colspan="3" class="txtbold" style="text-align:right;"><cf_get_lang_main no='80.TOPLAM'> (#int_money2#)</td>
					<td class="txtbold" style="text-align:right;"><input type="hidden" name="other_main_total_price" id="other_main_total_price" value="#main_total_price*(get_money.rate1/get_money.rate2)#">#tlformat(main_total_price*(get_money.rate1/get_money.rate2))# #int_money2#</td>
			  	</tr>
				<tr class="color-row" style="height:20px;">
					<td colspan="3"  class="txtbold" style="text-align:right;"><cf_get_lang no='137.TOPLAM KDV li'> (#int_money2#)</td>
					<td class="txtbold" style="text-align:right;"><input type="hidden" name="other_main_total_price_kdv" id="other_main_total_price_kdv" value="#main_total_price_kdv*(get_money.rate1/get_money.rate2)#">#tlformat(main_total_price_kdv*(get_money.rate1/get_money.rate2))# #int_money2#</td>
			  	</tr>
		   </cfoutput>
      		<tr class="color-row" style="height:20px;">
      		  	<td colspan="5" style="text-align:right;">
			  		<a href="javascript://" onClick="addBasket()"><img src="../objects2/image/basket.gif" border="0" title="<cf_get_lang_main no='1376.Sepete At'>" align="absmiddle" style="cursor:pointer"></a>
			  	</td>
      		</tr>
		</cfif>
  	</table>
</cfform>
<script type="text/javascript">
	function product_config_change(id)
	{
		document.getElementById('submit_type').value = id;
		if(id==2)
		{
			value_get_key_produt = eval('document.getElementById("get_key_product1")');
			if(value_get_key_produt.value == 0)
				document.product_configuration.submit_type.value = 1;	
		}
		document.product_configuration.action='<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.product_configure';
		document.product_configuration.submit();
	}
	function changeAction()
	{
		document.product_configuration.action='<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.product_configure_proposal';
		document.product_configuration.submit();
	}
	function addBasket()
	{
		document.product_configuration.action='<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_add_basketww_config_row';
		document.product_configuration.submit();
	}
</script>

