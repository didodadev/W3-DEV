<cfscript>
	if (listfindnocase(employee_url,'#cgi.http_host#',';'))
	{
		int_money = session.ep.money;
		int_comp_id = session.ep.company_id;
		int_period_id = session.ep.period_id;
		int_money2 = session.ep.money2;
	}
	else if (listfindnocase(partner_url,'#cgi.http_host#',';'))
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
</cfscript>
<cfquery name="get_general_prom" datasource="#DSN3#" maxrows="1">
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
<cfquery name="get_comp_money" datasource="#DSN#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_period_id#"> AND RATE1=1 AND RATE2=1
</cfquery> 
<cfset str_money_bskt_func = get_comp_money.money>
<cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
<cfquery name="GET_MONEY" datasource="#DSN#">
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
<table width="100%" align="center" cellpadding="2" cellspacing="1">		
  <tr>
	<td height="20"><a href="##" onclick="parent.window.location='<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.list_basket_camp'"><font color="FF0000">>> <cf_get_lang no="130.Sepet Detaya Git"></font></a></td>
  </tr>
</table>
<cfif ArrayLen(session.basketww_camp)>
		<table>
				<cfoutput>
					<cfset tum_toplam = 0>
					<cfset tum_toplam_kdvli = 0>
					<cfset genel_toplam = 0> <!--- promosyon bilgisinin goruntulenmesi bu toplama gore kontrol ediliyor --->
					<cfloop from="1" to="#ArrayLen(session.basketww_camp)#" index="rowno">
						<!--- <cfset toplam_istenen_miktar = session.basketww_camp[rowno][3] * session.basketww_camp[rowno][15]> --->
						<tr class="printbold">
							<td>#session.basketww_camp[rowno][2]#
							<cfif len(session.basketww_camp[rowno][10]) and not session.basketww_camp[rowno][16]>
								<cfquery name="GET_PRO" datasource="#DSN3#">
									SELECT						
										ICON_ID,
										FREE_STOCK_ID,
										DISCOUNT,
										AMOUNT_DISCOUNT
									FROM
										PROMOTIONS
									WHERE
										PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.basketww_camp[rowno][10]#">
								</cfquery>
								<cfif get_pro.recordcount>
									<cfif len(get_pro.icon_id) and (get_pro.icon_id gt 0)>
										<cfquery name="GET_ICON" datasource="#DSN3#">
											SELECT * FROM SETUP_PROMO_ICON WHERE ICON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pro.icon_id#">
										</cfquery>
										<br/><cf_get_server_file output_file="sales/#get_icon.icon#" output_server="#get_icon.icon_server_id#" output_type="0" image_link=1 alt="#getLang('main',617)#" title="#getLang('main',617)#">
									</cfif>
									<font color="FF0000">
										<cfif len(get_pro.free_stock_id)>
											<strong><cf_get_lang no='131.Hediye'>:</strong> #get_product_name(stock_id:get_pro.free_stock_id,with_property:1)#
										<cfelseif len(get_pro.discount)>
											<strong><cf_get_lang no='132.Yüzde İndirim'>:</strong> % #get_pro.discount#
										<cfelseif len(get_pro.amount_discount)>
											<strong><cf_get_lang no='133.Tutar Indirimi'>:</strong> #get_pro.amount_discount# #get_pro.amount_1_money#
										</cfif>
									</font>
								<cfelse>
								&nbsp;
								</cfif>
							</cfif>
						<cfif session.basketww_camp[rowno][16]><strong>(<cf_get_lang no='131.Hediye'>)</strong></cfif>
							<cfif IsStruct(session.basketww_camp[rowno][19])><br/>
								<a href="javascript://" onClick="gizle_goster(spect#rowno#);"><b><font color="##FF0000"><cf_get_lang no='139.Ürün Bileşenleri'></font></b></a>
							<table style="display:none;" id="spect#rowno#">
								<tr>
									<td>#session.basketww_camp[rowno][19].spec_name#</td>
									<td width="40" align="right" style="text-align:right;"></td>
									<td width="60" align="right" style="text-align:right;">#tlformat(session.basketww_camp[rowno][19].PRODUCT_AMOUNT)#</td>
									<td width="40">#session.basketww_camp[rowno][19].PRODUCT_AMOUNT_CURRENCY#</td>
								<tr>
								<cfif IsStruct(session.basketww_camp[rowno][19].spect_row)>
									<cfloop from="1" to="#StructCount(session.basketww_camp[rowno][19].spect_row)#" index="i">
										<tr>
											<td>#session.basketww_camp[rowno][19].spect_row[i][3]#</td>
											<td width="40" align="right" style="text-align:right;">#session.basketww_camp[rowno][19].spect_row[i][4]#</td>
										<cfif session.basketww_camp[rowno][19].spect_row[i][9] eq 0>
											<td width="60" align="right" style="text-align:right;"><cfif session.basketww_camp[rowno][19].spect_row[i][8] neq 0>#tlformat(session.basketww_camp[rowno][19].spect_row[i][8])#</cfif></td>
											<td width="40"><!--- <cfif session.basketww_camp[rowno][19].spect_row[i][8] neq 0>#session.basketww_camp[rowno][19].spect_row[i][6]#</cfif> ---></td>
										<cfelse>
											<td width="60" align="right" style="text-align:right;">#tlformat(session.basketww_camp[rowno][19].spect_row[i][5])#</td>
											<td width="40">#session.basketww_camp[rowno][19].spect_row[i][6]#</td>
										</cfif>
										</tr>
									</cfloop>
								</cfif>
							</table>
							</cfif>
						</td>
						</tr>
						<tr class="print">						
							<td align="right" style="text-align:right;">
								#session.basketww_camp[rowno][3] * session.basketww_camp[rowno][15]# x
								<cfif session.basketww_camp[rowno][16]>
									0
								<cfelse>
									#TLFormat(session.basketww_camp[rowno][4] * session.basketww_camp[rowno][3] * session.basketww_camp[rowno][15])#
								</cfif>
								#session.basketww_camp[rowno][6]#
							</td>
						</tr>
					</cfloop>
				</cfoutput>
<cfelse>
<cf_get_lang no='134.Sepette ürün yok'>!
</cfif>
