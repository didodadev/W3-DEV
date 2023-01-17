<cfsetting showdebugoutput="no">
<cfif not isdefined("session.pp") and not isdefined("session.ww.userid") and not IsDefined("Cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>
	<cfset cookie_name_ = createUUID()>
	<cfcookie name="wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#" value="#cookie_name_#" expires="1">
</cfif>

<cfscript>
	if (listfindnocase(partner_url,'#cgi.http_host#',';'))
	{
		int_comp_id = session.pp.our_company_id;
		int_period_id = session.pp.period_id;
		int_money2 = session.pp.money2;
	}
	else if (listfindnocase(server_url,'#cgi.http_host#',';') )
	{	
		int_comp_id = session.ww.our_company_id;
		int_period_id = session.ww.period_id;
		int_money2 = session.ww.money2;
	}
</cfscript>

<cfinclude template="../query/get_basket_rows.cfm">

<cfquery name="GET_GENERAL_PROM" datasource="#DSN3#" maxrows="1">
	SELECT 
		COMPANY_ID, 
		LIMIT_VALUE, 
		DISCOUNT, 
		AMOUNT_DISCOUNT, 
		PROM_ID,
		LIMIT_CURRENCY
	FROM 
		PROMOTIONS 
	WHERE 
		PROM_STATUS = 1 AND 
		PROM_TYPE = 0 AND 
		LIMIT_TYPE <> 1 AND 
		LIMIT_VALUE IS NOT NULL AND 
		DISCOUNT IS NOT NULL AND 
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> BETWEEN STARTDATE AND FINISHDATE
	ORDER BY
		PROM_ID DESC
</cfquery>
<cfscript>
	prom_general_limit_money = get_general_prom.limit_value;
	prom_general_company_id = get_general_prom.company_id;
	prom_general_discount = get_general_prom.discount;
	prom_general_prom_id = get_general_prom.prom_id;
	prom_general_amount_discount = get_general_prom.amount_discount;
</cfscript>
<cfquery name="GET_COMP_MONEY" datasource="#DSN#">
	SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_period_id#"> AND RATE1=1 AND RATE2=1
</cfquery> 
<cfset str_money_bskt_func = get_comp_money.money>
<cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
<cfquery name="get_money" datasource="#dsn#">
	SELECT 
		COMPANY_ID,
		PERIOD_ID,
		MONEY,
		RATE1,
		<cfif isDefined("session.pp")>
			RATEPP2 RATE2
		<cfelse>
			RATEWW2 RATE2
		</cfif>
	FROM 
		SETUP_MONEY
	WHERE 
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_period_id#">
</cfquery>
<cfquery dbtype="query" name="GET_STDMONEY">
	SELECT MONEY FROM GET_MONEY WHERE RATE2 = RATE1
</cfquery>
<cfquery dbtype="query" name="GET_MONEY_MONEY2">
	SELECT 
		RATE1,RATE2
	FROM 
		GET_MONEY
	WHERE 
		MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#int_money2#"> AND
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
</cfquery>
<table cellspacing="0" cellpadding="0" align="center" style="width:100%">
  	<tr>
  		<td>
			<cfif get_rows.recordcount>
				<table align="center" cellpadding="2" cellspacing="1" style="width:100%">
					<cfset tum_toplam = 0>
				  	<cfset tum_toplam_kdvli = 0>
					<cfoutput query="get_rows">
						<tr>
							<td>
                            	<cfif session_base.language neq 'tr'>
									<cfquery name="GET_PRODUCT_NAME" dbtype="query">
                                    	SELECT * FROM GET_PRODUCT_NAMES WHERE UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
                                    </cfquery>
                                    <cfif get_product_name.recordcount>
										<font class="printbold">> #get_product_name.item#</font>
                                    <cfelse>
										<font class="printbold">> #product_name#</font>                                    
                                    </cfif>
                                <cfelse>
									<font class="printbold">> #product_name#</font>
								</cfif>
								<cfif len(prom_id) and not is_prom_asil_hediye>
                                    <cfquery name="GET_PRO" datasource="#DSN3#">
                                        SELECT						
                                            ICON_ID,
                                            FREE_STOCK_ID,
                                            DISCOUNT,
                                            AMOUNT_DISCOUNT,
                                            AMOUNT_1_MONEY,
                                            AMOUNT_DISCOUNT_MONEY_1
                                        FROM
                                            PROMOTIONS
                                        WHERE
                                            PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#prom_id#">
                                    </cfquery>
                                    <cfif get_pro.recordcount>
                                        <cfif len(get_pro.icon_id) and (get_pro.icon_id gt 0)>
                                            <cfquery name="GET_ICON" datasource="#DSN3#">
                                                SELECT ICON, ICON_SERVER_ID FROM SETUP_PROMO_ICON WHERE ICON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pro.icon_id#">
                                            </cfquery>
                                            <br/><cf_get_server_file output_file="sales/#get_icon.icon#" output_server="#get_icon.icon_server_id#" output_type="0" image_link=1 alt="#getLang('main',617)#" title="#getLang('main',617)#">
                                        </cfif>
                                        <font color="FF0000">
                                        <cfif len(get_pro.free_stock_id)>
                                            <strong><cf_get_lang no="131.Hediye">:</strong> #get_product_name(stock_id:get_pro.free_stock_id,with_property:1)#
                                        <cfelseif len(get_pro.discount)>
                                            <strong><cf_get_lang no="132.Yüzde İndirim">:</strong> % #get_pro.discount#
                                        <cfelseif len(get_pro.amount_discount)>
                                            <strong><cf_get_lang no="133.Tutar İndirimi">:</strong> #get_pro.amount_discount# #get_pro.amount_discount_money_1#
                                        </cfif>
                                        </font>
                                    <cfelse>
                                        &nbsp;
                                    </cfif>
                                </cfif>
								<cfif is_prom_asil_hediye><strong>(<cf_get_lang no="131.Hediye">)</strong></cfif>
						    </td>
						</tr>
						<cfquery dbtype="query" name="GET_MONEY_RATE2">
							SELECT 
								RATE2
							FROM 
								GET_MONEY
							WHERE 
								MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#price_money#"> AND
								COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
						</cfquery>
						<cfscript>
							if(not is_prom_asil_hediye)
							{
								satir_toplam_std = price * quantity * prom_stock_amount * get_money_rate2.rate2;
								tum_toplam = tum_toplam + satir_toplam_std;
								satir_toplam_std_kdvli = price_kdv * quantity * prom_stock_amount * get_money_rate2.rate2;
								tum_toplam_kdvli = tum_toplam_kdvli + satir_toplam_std_kdvli;
							}
						</cfscript>
						<cfif isdefined("attributes.basket_price") and attributes.basket_price eq 1>
							<tr class="print">
								<td align="right" style="text-align:right;">#quantity * prom_stock_amount# x #tlformat(price)# #price_money#</td>
							</tr>
						</cfif>
					</cfoutput>
				  	<cfif (len(prom_general_limit_money) and len(prom_general_discount) and prom_general_limit_money lte tum_toplam)>
						<cfset kdvsiz_toplam_indirimli = tum_toplam * ((100 - prom_general_discount)/100)>
						<cfset kdvli_toplam_indirimli = 0>
						<cfoutput query="get_rows">
							<cfif not is_prom_asil_hediye>
								<cfquery dbtype="query" name="GET_MONEY_RATE2">
									SELECT 
										RATE2
									FROM 
										GET_MONEY
									WHERE 
										MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#price_money#"> AND
										COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
								</cfquery>
								<cfscript>
									satir_toplam_kdvsiz = price * quantity * prom_stock_amount * get_money_rate2.rate2;
									toplam_indirim = tum_toplam * (prom_general_discount/100);
									satir_agirligi = satir_toplam_kdvsiz / tum_toplam;
									satir_indirim = toplam_indirim * satir_agirligi;
									satir_kdvli_toplam_indirimli = (satir_toplam_kdvsiz - satir_indirim) * (1+(tax/100));
									kdvli_toplam_indirimli = kdvli_toplam_indirimli + satir_kdvli_toplam_indirimli;
								</cfscript>
							</cfif>
						</cfoutput>
						<cfset tum_toplam = kdvsiz_toplam_indirimli>
						<cfset tum_toplam_kdvli = kdvli_toplam_indirimli>
					</cfif>
					<cfquery name="GET_GENERAL_PROM_2" datasource="#DSN3#" maxrows="1">
						SELECT 
							P.COMPANY_ID, 
							P.LIMIT_VALUE, 
							P.DISCOUNT, 
							P.AMOUNT_DISCOUNT, 
							P.PROM_ID,
							P.LIMIT_CURRENCY,
							P.LIMIT_TYPE,
							P.FREE_STOCK_ID,
							P.FREE_STOCK_AMOUNT,
							P.FREE_STOCK_PRICE,
							P.AMOUNT_1_MONEY,
							S.PRODUCT_NAME,
							S.PROPERTY
						FROM 
							PROMOTIONS P,
							STOCKS S
						WHERE 
							P.FREE_STOCK_ID = S.STOCK_ID AND 
							P.PROM_STATUS = 1 AND 
							P.PROM_TYPE = 0 AND 
							P.FREE_STOCK_ID IS NOT NULL AND 
							P.FREE_STOCK_AMOUNT IS NOT NULL AND 
							P.FREE_STOCK_PRICE IS NOT NULL AND 
							P.LIMIT_VALUE IS NOT NULL AND 
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> BETWEEN P.STARTDATE AND P.FINISHDATE
						ORDER BY
							P.PROM_ID DESC
					</cfquery>
					<cfif get_general_prom_2.recordcount>
						<cfquery dbtype="query" name="get_general_prom_2_money">
							SELECT 
								RATE1,RATE2
							FROM 
								GET_MONEY
							WHERE 
								MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_general_prom_2.limit_currency#"> AND
								COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
						</cfquery>
						<cfset get_general_prom_2_limit_value = get_general_prom_2.limit_value * (get_general_prom_2_money.rate2 / get_general_prom_2_money.rate1)>
					</cfif>
					<cfoutput>
						<cfif get_general_prom_2.recordcount and (len(get_general_prom_2.limit_value) and get_general_prom_2.limit_value lte tum_toplam)>
							<tr class="color-row" style="height:20px;">
							  	<td style="vertical-align:top">
									#get_general_prom_2.product_name# #get_general_prom_2.property#
									<strong>(<cf_get_lang no="131.Hediye"> - Genel P.)</strong>
							  	</td>
							  	<td align="right" style="text-align:right;">
									#get_general_prom_2.free_stock_amount#
							  	</td>
							</tr>
						</cfif>
					</cfoutput>
					<cfoutput>
						<cfif isdefined("attributes.basket_price") and attributes.basket_price eq 1>
							<tr>
								<td class="printbold"><cf_get_lang_main no="80.TOPLAM"> (KDV D.)</td>
							</tr>
							<tr>
								<td align="right" class="print" style="text-align:right;">
									#TLFormat(tum_toplam_kdvli)# #get_stdmoney.money#<br/>
									<cfif len(get_money_money2.rate2)>#TLFormat(tum_toplam_kdvli/get_money_money2.rate2/get_money_money2.rate1)# #int_money2#</cfif>
								</td>
							</tr>
						</cfif>
					</cfoutput>
				</table>
			<cfelse>
				<table align="center" cellpadding="2" cellspacing="1" style="width:100%;">
					<tr class="color-row" style="height:20px;">
						<td><cf_get_lang no="134.Sepette Ürün Yok">!</td>
					</tr>
				</table>
			</cfif>
		</td>
	</tr>
</table>
