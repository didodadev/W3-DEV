<cfsetting showdebugoutput="no">
<cfset attributes.campaign_id = "">
<cfif ArrayLen(session.basketww_camp)>
	<cfset attributes.campaign_id = session.basketww_camp[1][24]>
</cfif>
<cfscript>
session_basket_kur_ekle(process_type:0);
	if (listfindnocase(employee_url,'#cgi.http_host#',';'))
	{
		int_comp_id = session.ep.company_id;
		int_period_id = session.ep.period_id;
		int_money = session.ep.money;
		int_money2 = session.ep.money2;
	}
	else if (listfindnocase(partner_url,'#cgi.http_host#',';'))
	{
		int_comp_id = session.pp.our_company_id;
		int_period_id = session.pp.period_id;
		int_money = session.pp.money;
		int_money2 = session.pp.money2;
		attributes.company_id = session.pp.company_id;
	}
	else if (listfindnocase(server_url,'#cgi.http_host#',';') )
	{	
		int_comp_id = session.ww.our_company_id;
		int_period_id = session.ww.period_id;
		int_money = session.ww.money;
		int_money2 = session.ww.money2;
		attributes.consumer_id = session.ww.userid;
	}
</cfscript>
<cfinclude template="../query/get_order_detail_money.cfm">
<cfinclude template="../query/get_order_detail_account.cfm">
<cfinclude template="../query/get_order_detail.cfm">
<cfoutput>
	<cfif ArrayLen(session.basketww_camp)>
		<input type="hidden" name="campaign_id" id="campaign_id" value="#session.basketww_camp[1][24]#">
	<cfelse>
		<input type="hidden" name="campaign_id" id="campaign_id" value="">
	</cfif>
	<cfloop query="get_money_bskt">
		<cfif str_money_bskt_func eq money_type>
			<input type="hidden" name="rd_money" id="rd_money" value="#currentrow#" >
		</cfif>
		<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money_type#">
		<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
		<input type="hidden" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#rate2#">
	</cfloop>
	<input type="hidden" name="kur_say" id="kur_say" value="#get_money_bskt.RecordCount#">
	<input type="hidden" name="basket_money" id="basket_money" value="#str_money_bskt_func#">
</cfoutput>
<cfif ArrayLen(session.basketww_camp)>
<table width="99%" align="center">
	<tr height="22" class="color-header">
		<td class="form-title" width="25">No</td>
		<td class="form-title" width="90">Stok Kod</td>
		<td class="form-title">Ürünler</td>
		<td class="form-title" width="45">Miktar</td>
		<td width="80"  class="form-title" style="text-align:right;">Birim Fiyat</td>
		<td width="100"  class="form-title" style="text-align:right;">Satır Toplam</td>
	</tr>
  	<cfoutput>
		<cfscript>
			genel_toplam = 0; /*promosyon bilgisinin goruntulenmesi bu toplama gore kontrol ediliyor*/
			tum_toplam = 0;	
			tum_toplam_kdvli = 0;
			tum_toplam_kdvli_ps = 0;
			tum_toplam_komisyonsuz = 0;
			kdv_toplam = 0;
			my_temp_tutar = 0;
			my_temp_tutar_price_standard = 0;
			toplam_desi = 0;
		</cfscript>
		<cfloop from="1" to="#ArrayLen(session.basketww_camp)#" index="rowno">
			<cfquery dbtype="query" name="GET_MONEY_RATE2">
				SELECT 
			<cfif isDefined("session.pp")>
				RATEPP2 RATE2
			<cfelseif isDefined("session.ww")>
				RATEWW2 RATE2
			<cfelse>
				RATE2
			</cfif>	
				FROM 
					GET_MONEY
				WHERE 
					MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.basketww_camp[rowno][6]#"> AND
					COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
			</cfquery>
			<cfquery dbtype="query" name="GET_MONEY_RATE2_price_standard">
				SELECT 
				<cfif isDefined("session.pp")>
					RATEPP2 RATE2
				<cfelseif isDefined("session.ww")>
					RATEWW2 RATE2
				<cfelse>
					RATE2
				</cfif>	
				FROM 
					GET_MONEY
				WHERE 
					MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.basketww_camp[rowno][23]#"> AND
					COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
			</cfquery>
			
			<cfquery name="get_p_dimen" datasource="#dsn1#">
				SELECT DIMENTION FROM PRODUCT_UNIT WHERE PRODUCT_UNIT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.basketww_camp[rowno][9]#">
			</cfquery>
			
			<cfif len(get_p_dimen.DIMENTION) and listlen(get_p_dimen.DIMENTION,'*') eq 3>
				<cfset toplam_desi = toplam_desi + (replace(listgetat(get_p_dimen.DIMENTION,1,'*'),',','.','all') * replace(listgetat(get_p_dimen.DIMENTION,2,'*'),',','.','all') * replace(listgetat(get_p_dimen.DIMENTION,3,'*'),',','.','all') / 3000)>
			</cfif>
		<tr height="20" valign="top" class="color-row">
		  <td>#rowno#</td>
			<cfquery name="get_stock_code" datasource="#dsn3#">
				SELECT STOCK_CODE FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.basketww_camp[rowno][8]#">
			</cfquery>
		  <td>#get_stock_code.stock_code#</td>
		  <td>
			#session.basketww_camp[rowno][2]# 
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
						PROM_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.basketww_camp[rowno][10]#">
				</cfquery>
				<cfif GET_PRO.recordcount>
                  	<cfif len(GET_PRO.ICON_ID) AND (GET_PRO.ICON_ID GT 0)>
						<cfquery name="GET_ICON" datasource="#DSN3#">
						SELECT * FROM SETUP_PROMO_ICON WHERE ICON_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_pro.icon_id#">
						</cfquery>
						<br/>
						<!--- <img src="#file_web_path#sales/#get_icon.icon#" align="absmiddle"> --->
						<cf_get_server_file output_file="sales/#get_icon.icon#" output_server="#get_icon.icon_server_id#" output_type="0"  image_link="1" alt="#getLang('main',617)#" title="#getLang('main',617)#">
			    <cfelse>
						<!---<br/><font color="FF0000">PROM [#prom_id#]:--->
                  	</cfif>
					<font color="FF0000">
					<cfif len(GET_PRO.FREE_STOCK_ID)>
						<strong><cf_get_lang no ='131.Hediye'>:</strong> #get_product_name(stock_id:GET_PRO.FREE_STOCK_ID,with_property:1)#
					<cfelseif  len(GET_PRO.DISCOUNT)>
						<strong><cf_get_lang no ='132.Yüzde İndirim'>:</strong> % #GET_PRO.DISCOUNT#
					<cfelseif  len(GET_PRO.AMOUNT_DISCOUNT)>
						<strong><cf_get_lang no='133.Tutar Indirimi'>:</strong> #GET_PRO.AMOUNT_DISCOUNT# #GET_PRO.AMOUNT_1_MONEY#
					</cfif>
					</font>
                <cfelse>
	                &nbsp;
                </cfif>
			</cfif>
			<cfif session.basketww_camp[rowno][16]><strong>(<cf_get_lang no ='131.Hediye'>)</strong></cfif>
			<cfif IsStruct(session.basketww_camp[rowno][19])><br/>
			<a href="javascript://" onClick="gizle_goster(spect#rowno#);"><b><font color="##FF0000"><cf_get_lang no ='139.Ürün Bileşenleri'></font></b></a>
			  <table style="display:none;" id="spect#rowno#">
			   	<tr>
					<td>#session.basketww_camp[rowno][19].SPEC_NAME#</td>
					<td width="40"  style="text-align:right;"></td>
					<td width="60"  style="text-align:right;">#tlformat(session.basketww_camp[rowno][19].PRODUCT_AMOUNT)#</td>
					<td width="40">#session.basketww_camp[rowno][19].PRODUCT_AMOUNT_CURRENCY#</td>
				<tr>
				<cfif IsStruct(session.basketww_camp[rowno][19].spect_row)>
					<cfloop from="1" to="#StructCount(session.basketww_camp[rowno][19].spect_row)#" index="i">
					<tr>
						<td>#session.basketww_camp[rowno][19].spect_row[i][3]#</td>
						<td width="40"  style="text-align:right;">#session.basketww_camp[rowno][19].spect_row[i][4]#</td>
						<cfif session.basketww_camp[rowno][19].spect_row[i][9] eq 0>
						<td width="60"  style="text-align:right;"><cfif session.basketww_camp[rowno][19].spect_row[i][8] neq 0>#tlformat(session.basketww_camp[rowno][19].spect_row[i][8])#</cfif></td>
						<td width="40"><!--- <cfif session.basketww_camp[rowno][19].spect_row[i][8] neq 0>#session.basketww_camp[rowno][19].spect_row[i][6]#</cfif> ---></td>
						<cfelse>
						<td width="60"  style="text-align:right;">#tlformat(session.basketww_camp[rowno][19].spect_row[i][5])#</td>
						<td width="40">#session.basketww_camp[rowno][19].spect_row[i][6]#</td>
						</cfif>
					</tr>
					</cfloop>
				</cfif>
			  </table>
			 </cfif>
		  </td>
		  <td  style="text-align:right;">#session.basketww_camp[rowno][3] * session.basketww_camp[rowno][15]#</td>
		  <td  style="text-align:right;">
			<cfif len(session.basketww_camp[rowno][18])>
			<strike>#TLFormat(session.basketww_camp[rowno][18])# #session.basketww_camp[rowno][6]#</strike><br/>
			</cfif>
			#TLFormat(session.basketww_camp[rowno][4])# #session.basketww_camp[rowno][6]#
		  </td>
		  <td  style="text-align:right;">
		  	<cfif session.basketww_camp[rowno][16]>
			0
			<cfelse>
			#TLFormat(session.basketww_camp[rowno][4] * session.basketww_camp[rowno][3] * session.basketww_camp[rowno][15])#
			</cfif>
			#session.basketww_camp[rowno][6]#
		  </td>
		</tr>
		<cfscript>
			if(not session.basketww_camp[rowno][16])
			{
				if(not len(session.basketww_camp[rowno][22]))//AK sorulcak geçici kontrol eklendi
					session.basketww_camp[rowno][22] = 0;
				if(not GET_MONEY_RATE2_price_standard.recordcount)
					my_money = 1;
				else
					my_money = GET_MONEY_RATE2_price_standard.RATE2;
				satir_toplam_std = session.basketww_camp[rowno][4] * session.basketww_camp[rowno][3] * session.basketww_camp[rowno][15] * GET_MONEY_RATE2.RATE2;
				tum_toplam = tum_toplam + satir_toplam_std;
				satir_toplam_std_kdvli = session.basketww_camp[rowno][5] * session.basketww_camp[rowno][3] * session.basketww_camp[rowno][15] * GET_MONEY_RATE2.RATE2;
				satir_toplam_std_kdvli_ps = session.basketww_camp[rowno][22] * session.basketww_camp[rowno][3] * session.basketww_camp[rowno][15] * my_money;
				if(session.basketww_camp[rowno][20] neq 1)
					satir_toplam_komisyonsuz = session.basketww_camp[rowno][5] * session.basketww_camp[rowno][3] * session.basketww_camp[rowno][15] * GET_MONEY_RATE2.RATE2;
				tum_toplam_kdvli = tum_toplam_kdvli + satir_toplam_std_kdvli;
				tum_toplam_kdvli_ps = tum_toplam_kdvli_ps + satir_toplam_std_kdvli_ps;
				if(session.basketww_camp[rowno][20] neq 1)
					tum_toplam_komisyonsuz = tum_toplam_komisyonsuz + satir_toplam_komisyonsuz;
				kdv_miktari = satir_toplam_std * (session.basketww_camp[rowno][7]/100);
				kdv_toplam = kdv_toplam + kdv_miktari;
				if(session.basketww_camp[rowno][20] neq 1)
				{
					my_temp_tutar = my_temp_tutar + session.basketww_camp[rowno][5] * session.basketww_camp[rowno][3] * session.basketww_camp[rowno][15] * GET_MONEY_RATE2.RATE2;
					my_temp_tutar_price_standard = my_temp_tutar_price_standard + session.basketww_camp[rowno][22] * session.basketww_camp[rowno][3] * session.basketww_camp[rowno][15] * my_money;					
				}
			}
		</cfscript>
	</cfloop>
  </cfoutput>

	<cfif get_general_prom.recordcount>
		<cfquery dbtype="query" name="get_general_prom_MONEY">
			SELECT 
				RATE1,
			<cfif isDefined("session.pp")>
				RATEPP2 RATE2
			<cfelseif isDefined("session.ww")>
				RATEWW2 RATE2
			<cfelse>
				RATE2
			</cfif>	
			FROM 
				GET_MONEY
			WHERE 
				MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_general_prom.limit_currency#"> AND
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
		</cfquery>
		<cfset get_general_prom_limit_value = get_general_prom.LIMIT_VALUE * (get_general_prom_MONEY.RATE2 / get_general_prom_MONEY.RATE1)>
	</cfif>
  <cfset toplam_indirim = 0>
  <cfif (len(get_general_prom.LIMIT_VALUE) and len(get_general_prom.DISCOUNT) and get_general_prom_limit_value lte tum_toplam)>
  	<cfset kdvsiz_toplam_indirimli = tum_toplam * ((100 - get_general_prom.DISCOUNT)/100)>
  	<cfset kdvli_toplam_indirimli = 0>
	<cfset kdv_toplam_indirimli = 0>
	<cfloop from="1" to="#ArrayLen(session.basketww_camp)#" index="rowno">
		<cfif (not session.basketww_camp[rowno][16])>
			<cfquery dbtype="query" name="GET_MONEY_RATE2">
				SELECT 
				<cfif isDefined("session.pp")>
					RATEPP2 RATE2
				<cfelseif isDefined("session.ww")>
					RATEWW2 RATE2
				<cfelse>
					RATE2
				</cfif>	
				FROM 
					GET_MONEY
				WHERE 
					MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.basketww_camp[rowno][6]#"> AND
					COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
			</cfquery>
			<cfscript>
				satir_toplam_kdvsiz = session.basketww_camp[rowno][4] * session.basketww_camp[rowno][3] * session.basketww_camp[rowno][15] * GET_MONEY_RATE2.RATE2;
				if(session.basketww_camp[rowno][20] neq 1)
					satir_toplam_kdvsiz_com = session.basketww_camp[rowno][4] * session.basketww_camp[rowno][3] * session.basketww_camp[rowno][15] * GET_MONEY_RATE2.RATE2;
				toplam_indirim = tum_toplam * (get_general_prom.DISCOUNT/100);
				satir_agirligi = satir_toplam_kdvsiz / tum_toplam;
				satir_indirim = toplam_indirim * satir_agirligi;
				satir_kdvli_toplam_indirimli = (satir_toplam_kdvsiz - satir_indirim) * (1+(session.basketww_camp[rowno][7]/100));
				kdvli_toplam_indirimli = kdvli_toplam_indirimli + satir_kdvli_toplam_indirimli;
  				kdvli_toplam_indirimli_komisyonsuz = kdvli_toplam_indirimli_komisyonsuz + satir_kdvli_toplam_indirimli_kom;
				kdv_miktari_indirimli = (satir_toplam_kdvsiz - satir_indirim) * (session.basketww_camp[rowno][7]/100);
				kdv_toplam_indirimli = kdv_toplam_indirimli + kdv_miktari_indirimli;
			</cfscript>
		</cfif>
	</cfloop>
	<cfset genel_toplam = tum_toplam> <!--- sıralamayı degistirmeyin --->
	<cfset tum_toplam = kdvsiz_toplam_indirimli>
	<cfset tum_toplam_kdvli = kdvli_toplam_indirimli>
	<cfset tum_toplam_komisyonsuz = kdvli_toplam_indirimli_komisyonsuz>
	<cfset kdv_toplam = kdv_toplam_indirimli>
	<cfoutput>
	<input type="hidden" name="genel_indirim" id="genel_indirim" value="#toplam_indirim#">
	<input type="hidden" name="GENERAL_PROM_ID" id="GENERAL_PROM_ID" value="#get_general_prom.PROM_ID#">
	<input type="hidden" name="GENERAL_PROM_LIMIT" id="GENERAL_PROM_LIMIT" value="#get_general_prom.LIMIT_VALUE#">
	<input type="hidden" name="GENERAL_PROM_LIMIT_CURRENCY" id="GENERAL_PROM_LIMIT_CURRENCY" value="#get_general_prom.LIMIT_CURRENCY#">
	<input type="hidden" name="GENERAL_PROM_DISCOUNT" id="GENERAL_PROM_DISCOUNT" value="#get_general_prom.DISCOUNT#">
	<input type="hidden" name="GENERAL_PROM_AMOUNT" id="GENERAL_PROM_AMOUNT" value="#get_general_prom.AMOUNT_DISCOUNT#">
	</cfoutput>
  </cfif>
  
	<cfquery name="get_general_prom_2" datasource="#DSN3#" maxrows="1">
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
		S.PROPERTY,
		P.TOTAL_PROMOTION_COST
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
		#now()# BETWEEN P.STARTDATE AND P.FINISHDATE
	ORDER BY
		P.PROM_ID DESC
	</cfquery>
	<cfif get_general_prom_2.recordcount>
		<cfquery dbtype="query" name="get_general_prom_2_MONEY">
			SELECT 
				RATE1,
			<cfif isDefined("session.pp")>
				RATEPP2 RATE2
			<cfelseif isDefined("session.ww")>
				RATEWW2 RATE2
			<cfelse>
				RATE2
			</cfif>	
			FROM 
				GET_MONEY
			WHERE 
				MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_general_prom_2.LIMIT_CURRENCY#"> AND
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
		</cfquery>
		<cfset get_general_prom_2_limit_value = get_general_prom_2.LIMIT_VALUE * (get_general_prom_2_MONEY.RATE2 / get_general_prom_2_MONEY.RATE1)>
	</cfif>
	<cfoutput>
  	<cfif get_general_prom_2.recordcount and (len(get_general_prom_2.LIMIT_VALUE) and get_general_prom_2.LIMIT_VALUE lte genel_toplam)>
		<tr height="20" class="color-row" valign="top">
		  <td>#ArrayLen(session.basketww_camp)+1#</td>
		  <td>#get_general_prom_2.PRODUCT_NAME# #get_general_prom_2.PROPERTY# <strong>(Hediye - Genel P.)</strong></td>
		  <td  style="text-align:right;">#get_general_prom_2.FREE_STOCK_AMOUNT#			
		  </td>
		  <td  style="text-align:right;">#TLFormat(get_general_prom_2.FREE_STOCK_PRICE)# #get_general_prom_2.AMOUNT_1_MONEY#</td>
		  <td  style="text-align:right;">0 #get_general_prom_2.AMOUNT_1_MONEY#</td>
		</tr>
		<input type="hidden" name="FREE_PROM_ID" id="FREE_PROM_ID" value="#get_general_prom_2.PROM_ID#">
		<input type="hidden" name="FREE_PROM_LIMIT" id="FREE_PROM_LIMIT" value="#get_general_prom_2.LIMIT_VALUE#">
		<input type="hidden" name="FREE_PROM_AMOUNT" id="FREE_PROM_AMOUNT" value="#get_general_prom_2.FREE_STOCK_AMOUNT#">
		<input type="hidden" name="FREE_PROM_STOCK_ID" id="FREE_PROM_STOCK_ID" value="#get_general_prom_2.FREE_STOCK_ID#">
		<input type="hidden" name="FREE_STOCK_PRICE" id="FREE_STOCK_PRICE" value="#get_general_prom_2.FREE_STOCK_PRICE#">
		<input type="hidden" name="FREE_STOCK_MONEY" id="FREE_STOCK_MONEY" value="#get_general_prom_2.AMOUNT_1_MONEY#">
		<input type="hidden" name="FREE_PROM_COST" id="FREE_PROM_COST" value="#get_general_prom_2.TOTAL_PROMOTION_COST#">
  	</cfif>
	</cfoutput>
</table>

<cfif isdefined("session.pp.userid")>
	<cfquery name="get_kur" dbtype="query">
		SELECT * FROM GET_MONEY WHERE MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.money#"> ORDER BY MONEY
	</cfquery>
<cfelse>
	<cfset get_kur.recordcount = 0>
</cfif>

<table cellpadding="0" cellspacing="0" width="100%" align="center">
	<cfoutput>
	<tr height="20">
		<cfif get_kur.recordcount>
		<td rowspan="3">
			<table>
				<tr>
					<td class="txtbold"><cf_get_lang no ='140.Kurlar'></td>
				</tr>
				<cfloop query="get_kur">
				<tr>
					<td class="txtbold">#MONEY#</td>
					<td>
						<cfif isDefined("session.pp")>
							#TLFormat(RATEPP2,4)#
						<cfelseif isDefined("session.ww")>
							#TLFormat(RATEWW2,4)#
						<cfelse>
							#TLFormat(RATE2,4)#
						</cfif>	
					
					</td>
				</tr>
				</cfloop>
			</table>
		</td>
		</cfif>
		<td  class="formbold" style="text-align:right;"><cf_get_lang_main no ='80.TOPLAM'> (<cf_get_lang no ='141.KDV Hariç'>)</td>
		<td width="100"  style="text-align:right;">#TLFormat(tum_toplam)# #GET_STDMONEY.MONEY#</td>
		<td width="100" style="text-align:right;">#TLFormat(tum_toplam/get_money_money2.rate2/get_money_money2.rate1)# #int_money2#</td>
	</tr>
	<cfif (len(get_general_prom.LIMIT_VALUE) and len(get_general_prom.DISCOUNT) and get_general_prom.LIMIT_VALUE lte genel_toplam)>
	<tr height="20">
		<td class="formbold"><cf_get_lang no ='1305.GENEL PROMOSYON İSKONTOSU'></td>
		<td style="text-align:right;">#TLFormat(toplam_indirim)# #GET_STDMONEY.MONEY#</td>
		<td style="text-align:right;">#TLFormat(toplam_indirim/get_money_money2.rate2/get_money_money2.rate1)# #int_money2#</td>
	</tr>
	</cfif>
	<tr height="20">
		<td class="formbold"><cf_get_lang_main no ='80.TOPLAM'> (<cf_get_lang no ='142.KDV Dahil'>)</td>
		<td style="text-align:right;">#TLFormat(tum_toplam_kdvli)# #GET_STDMONEY.MONEY#</td>
		<td style="text-align:right;">#TLFormat(tum_toplam_kdvli/get_money_money2.rate2/get_money_money2.rate1)# #int_money2#</td>
	</tr>
	<input type="hidden" name="grosstotal" id="grosstotal" value="#tum_toplam#">
	<input type="hidden" name="TAXTOTAL" id="TAXTOTAL" value="#kdv_toplam#">
	<input type="hidden" name="DISCOUNTTOTAL" id="DISCOUNTTOTAL" value="#toplam_indirim#">
	<input type="hidden" name="NETTOTAL" id="NETTOTAL" value="#tum_toplam_kdvli#">
	<input type="hidden" name="OTHER_MONEY" id="OTHER_MONEY" value="#int_money2#">
	<input type="hidden" name="OTHER_MONEY_VALUE" id="OTHER_MONEY_VALUE" value="<cfif len(get_money_money2.rate2)>#tum_toplam_kdvli/(get_money_money2.rate2/get_money_money2.rate1)#</cfif>">
	</cfoutput>
</table>
</cfif>

<script type="text/javascript">
	document.getElementById('tum_toplam_kdvli').value='<cfoutput>#tum_toplam_kdvli#</cfoutput>';
	document.getElementById('tum_toplam_komisyonsuz').value='<cfoutput>#TUM_TOPLAM_KOMISYONSUZ#</cfoutput>';
	document.getElementById('my_temp_tutar').value='<cfoutput>#MY_TEMP_TUTAR#</cfoutput>';
	document.getElementById('my_temp_tutar_price_standart').value='<cfoutput>#MY_TEMP_TUTAR_PRICE_STANDARD#</cfoutput>';
	document.getElementById('toplam_desi').value='<cfoutput>#toplam_desi#</cfoutput>';
	
	
	if(isDefined('price_standart_dsp'))
		document.getEelemetnById('price_standart_dsp').value= commaSplit(wrk_round(<cfoutput>#tum_toplam_kdvli_ps#</cfoutput>));
	
	<cfif GET_HAVALE.RECORDCOUNT>
		havale_hesapla();
	</cfif>
	
	<cfif get_accounts.recordcount>
		kredi_karti_hesapla();
	</cfif>
		risk_hesapla();
</script>
