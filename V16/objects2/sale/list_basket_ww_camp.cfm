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
		DISCOUNT IS NOT NULL
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
	<cfform name="list_basketww" action="#request.self#?fuseaction=objects2.list_basket" method="post">
		<cfoutput>
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
	<!---<cfif ArrayLen(session.basketww_camp)>  --->
			<table width="100%" align="center" cellpadding="2" cellspacing="1">
				<tr height="22" class="color-header">
					<td class="form-title" width="15"></td>
					<td class="form-title" width="25"><cf_get_lang_main no='75.No'></td>
					<td class="form-title" width="90"><cf_get_lang_main no="106.Stok Kod"></td>
					<td class="form-title"><cf_get_lang_main no='245.Ürün'></td>
					<td width="40" class="form-title"><cf_get_lang_main no='223.Miktar'></td>
					<td width="70" align="right" class="form-title" style="text-align:right;"><cf_get_lang_main no='226.Birim Fiyat'></td>
					<td width="70" align="right" class="form-title" style="text-align:right;"><cf_get_lang no='135.KDV li Fiyat'></td>
					<td width="90" align="right" class="form-title" style="text-align:right;"><cf_get_lang no='136.Satır Toplam'></td>
					<td width="90" align="right" class="form-title" style="text-align:right;"><cf_get_lang no='137.KDV li Toplam'></td>
				</tr>
				<cfoutput>
					<cfset tum_toplam = 0>
					<cfset tum_toplam_kdvli = 0>
					<cfset genel_toplam = 0> <!--- promosyon bilgisinin goruntulenmesi bu toplama gore kontrol ediliyor --->
					<cfloop from="1" to="#ArrayLen(session.basketww_camp)#" index="rowno">
						<tr height="20" class="color-row" valign="top">
							<td align="center" width="15"><a style="cursor:pointer" onclick="if (confirm('Silmek istediğinize emin misiniz?')) sil(#rowno#);"><img  src="../images/delete_list.gif" border="0" title="Ürünü Sil"></a></td>
							<td>#rowno#</td>
							<cfquery name="get_stock_code" datasource="#DSN3#">
								SELECT STOCK_CODE FROM STOCKS WHERE STOCK_ID = #session.basketww_camp[rowno][8]#
							</cfquery>
							<td>#get_stock_code.stock_code#</td>
							<td><a href="#request.self#?fuseaction=objects2.detail_product&product_id=#session.basketww_camp[rowno][1]#&stock_id=#session.basketww_camp[rowno][8]#" class="tableyazi">#session.basketww_camp[rowno][2]#</a> 
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
									<cfif len(get_pro.icon_id) and (get_pro.icon_id GT 0)>
										<cfquery name="GET_ICON" datasource="#DSN3#">
											SELECT * FROM SETUP_PROMO_ICON WHERE ICON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pro.icon_id#">
										</cfquery>
										<br/>
										<cf_get_server_file output_file="sales/#get_icon.icon#" output_server="#get_icon.icon_server_id#" output_type="0" image_link=1 alt="#getLang('main',617)#" title="#getLang('main',617)#">
									</cfif>
									<font color="FF0000">
										<cfif len(get_pro.free_stock_id)>
											<strong><cf_get_lang no='131.Hediye'>:</strong> #get_product_name(stock_id:get_pro.free_stock_id,with_property:1)#
										<cfelseif  len(get_pro.discount)>
											<strong><cf_get_lang no='132.Yüzde İndirim'>:</strong> % #get_pro.discount#
										<cfelseif  len(get_pro.amount_discount)>
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
									<td width="60" align="right" style="text-align:right;">#tlformat(session.basketww_camp[rowno][19].product_amount)#</td>
									<td width="40">#session.basketww_camp[rowno][19].product_amount_currency#</td>
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
							<td>
								<cfif session.basketww_camp[rowno][17]>
									<cfinput type="text" name="amount_#rowno#" value="#session.basketww_camp[rowno][3] * session.basketww_camp[rowno][15]#" style="width:40px" validate="integer" required="yes" message="#rowno# no lu üründe miktar girmelisiniz !" class="box" readonly="yes" passThrough="onBlur=""if(filterNum(this.value) <=0) this.value=1;""">
								<cfelse>
									<cfinput type="text" name="amount_#rowno#" value="#session.basketww_camp[rowno][3] * session.basketww_camp[rowno][15]#" style="width:40px" validate="integer" required="yes" message="#rowno# no lu üründe miktar girmelisiniz !" class="box" passThrough="onBlur=""if(filterNum(this.value) <=0) this.value=1;""">
								</cfif>
							</td>
							<td align="right" style="text-align:right;">
								<cfif len(session.basketww_camp[rowno][18])>
									<strike>#TLFormat(session.basketww_camp[rowno][18])# #session.basketww_camp[rowno][6]#</strike><br/>
								</cfif>
								#TLFormat(session.basketww_camp[rowno][4])# #session.basketww_camp[rowno][6]#
							</td>
							<td align="right" style="text-align:right;">
								<cfif len(session.basketww_camp[rowno][18])>
									<strike>#TLFormat(session.basketww_camp[rowno][18])# #session.basketww_camp[rowno][6]#</strike><br/>
								</cfif>
								#TLFormat(session.basketww_camp[rowno][5])# #session.basketww_camp[rowno][6]#
							</td>
							<td align="right" style="text-align:right;">
								<cfif session.basketww_camp[rowno][16]>
									0
								<cfelse>
									#TLFormat(session.basketww_camp[rowno][4] * session.basketww_camp[rowno][3] * session.basketww_camp[rowno][15])#
								</cfif>
								#session.basketww_camp[rowno][6]#
							</td>
							<td align="right" style="text-align:right;">
								<cfif session.basketww_camp[rowno][16]>
									0
								<cfelse>
									#TLFormat(session.basketww_camp[rowno][5] * session.basketww_camp[rowno][3] * session.basketww_camp[rowno][15])#
								</cfif>
								#session.basketww_camp[rowno][6]#
							</td>
						</tr>
						<cfquery dbtype="query" name="GET_MONEY_RATE2">
							SELECT 
								RATE2
							FROM 
								GET_MONEY
							WHERE 
								MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.basketww_camp[rowno][6]#"> AND
								COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
						</cfquery>
						<cfscript>
							if(not session.basketww_camp[rowno][16])
							{
								satir_toplam_std = session.basketww_camp[rowno][4] * session.basketww_camp[rowno][3] * session.basketww_camp[rowno][15] * GET_MONEY_RATE2.RATE2;
								tum_toplam = tum_toplam + satir_toplam_std;
								satir_toplam_std_kdvli = session.basketww_camp[rowno][5] * session.basketww_camp[rowno][3] * session.basketww_camp[rowno][15] * GET_MONEY_RATE2.RATE2;
								tum_toplam_kdvli = tum_toplam_kdvli + satir_toplam_std_kdvli;
							}
						</cfscript>	
					</cfloop>
				</cfoutput>
				<cfif get_general_prom.recordcount>
					<cfquery dbtype="query" name="get_general_prom_MONEY">
						SELECT 
							RATE1,RATE2
						FROM 
							GET_MONEY
						WHERE 
							MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_general_prom.limit_currency#"> AND
							COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
					</cfquery>
					<cfset get_general_prom_limit_value = get_general_prom.LIMIT_VALUE * (get_general_prom_MONEY.RATE2 / get_general_prom_MONEY.RATE1)>
				</cfif>
				<cfif (len(get_general_prom.LIMIT_VALUE) and len(get_general_prom.DISCOUNT) and get_general_prom_limit_value lte tum_toplam)>
					<cfset kdvsiz_toplam_indirimli = tum_toplam * ((100 - get_general_prom.DISCOUNT)/100)>
					<cfset kdvli_toplam_indirimli = 0>
					<cfloop from="1" to="#ArrayLen(session.basketww_camp)#" index="rowno">
						<cfif (not session.basketww_camp[rowno][16])>
							<cfquery dbtype="query" name="GET_MONEY_RATE2">
								SELECT 
									RATE2
								FROM 
									GET_MONEY
								WHERE 
									MONEY = '#session.basketww_camp[rowno][6]#' AND
									COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
							</cfquery>
							<cfscript>
								satir_toplam_kdvsiz = session.basketww_camp[rowno][4] * session.basketww_camp[rowno][3] * session.basketww_camp[rowno][15] * GET_MONEY_RATE2.RATE2;
								toplam_indirim = tum_toplam * (get_general_prom.DISCOUNT/100);
								satir_agirligi = satir_toplam_kdvsiz / tum_toplam;
								satir_indirim = toplam_indirim * satir_agirligi;
								satir_kdvli_toplam_indirimli = (satir_toplam_kdvsiz - satir_indirim) * (1+(session.basketww_camp[rowno][7]/100));
								kdvli_toplam_indirimli = kdvli_toplam_indirimli + satir_kdvli_toplam_indirimli;
							</cfscript>
							<!--- <cfoutput>
									satir_toplam_kdvsiz:#satir_toplam_kdvsiz# = #session.basketww_camp[rowno][4]# * #session.basketww_camp[rowno][3] * session.basketww_camp[rowno][15]# * #GET_MONEY_RATE2.RATE2#;<br/>
									toplam_indirim:#toplam_indirim# = #tum_toplam# * (#get_general_prom.DISCOUNT#/100);<br/>
									satir_agirligi:#satir_agirligi# = #satir_toplam_kdvsiz# / #tum_toplam#;<br/>
									satir_indirim:#satir_indirim# = #toplam_indirim# * #satir_agirligi#;<br/>
									satir_kdvli_toplam_indirimli:#satir_kdvli_toplam_indirimli# = (#satir_toplam_kdvsiz# - #satir_indirim#) * (1+(#session.basketww_camp[rowno][7]#/100));<br/>
									kdvli_toplam_indirimli:#kdvli_toplam_indirimli# = #kdvli_toplam_indirimli# + #satir_kdvli_toplam_indirimli#;<br/><br/>
									</cfoutput> --->
						</cfif>
					</cfloop>
					<cfset genel_toplam =  tum_toplam>
					<cfset tum_toplam = kdvsiz_toplam_indirimli>
					<cfset tum_toplam_kdvli = kdvli_toplam_indirimli>
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
					<cfquery dbtype="query" name="get_general_prom_2_MONEY">
						SELECT 
							RATE1,RATE2
						FROM 
							GET_MONEY
						WHERE 
							MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_general_prom_2.limit_currency#"> AND
							COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
					</cfquery>
					<cfset get_general_prom_2_limit_value = get_general_prom_2.LIMIT_VALUE * (get_general_prom_2_MONEY.RATE2 / get_general_prom_2_MONEY.RATE1)>
				</cfif>
				<cfoutput>
					<cfif get_general_prom_2.recordcount and (len(get_general_prom_2.LIMIT_VALUE) and get_general_prom_2.LIMIT_VALUE lte genel_toplam)>
						<tr height="20" class="color-row" valign="top">
							<td align="center" width="15"><!--- <a style="cursor:pointer" onclick="if (confirm('Silmek istediğinize emin misiniz?')) sil(#rowno#);"><img  src="../images/delete_list.gif" border="0" alt="Ürünü Sil"></a> ---></td>
							<td>#ArrayLen(session.basketww_camp)+1#</td>
							<td>
							#get_general_prom_2.product_name# #get_general_prom_2.PROPERTY#
							<strong>(<cf_get_lang no='131.Hediye'> - Genel P.)</strong>
							</td>
							<td><cfinput type="text" name="amount_#ArrayLen(session.basketww_camp)+1#" value="#get_general_prom_2.FREE_STOCK_AMOUNT#" style="width:40px" validate="integer" required="yes" class="box" readonly="yes"></td>
							<td align="right" style="text-align:right;">#TLFormat(get_general_prom_2.FREE_STOCK_PRICE)# #get_general_prom_2.AMOUNT_1_MONEY#</td>
							<td align="right" style="text-align:right;">0 #get_general_prom_2.AMOUNT_1_MONEY#</td>
						</tr>
					</cfif>
				</cfoutput>
			</table>
			<br/>
			<cfquery name="get_kur" dbtype="query">
				SELECT 
						* 
				FROM 
					GET_MONEY 
				WHERE 
				<cfif isdefined("session.pp.money")>
					MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.money#">
				<cfelse>
					MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.money#">
				</cfif>
			ORDER BY 
					MONEY
			</cfquery>
			<table width="100%" align="center">
				<cfoutput>
				<tr height="20">
					<td rowspan="3" align="left">
						<table>
							<tr>
								<td colspan="2" class="txtbold"><cf_get_lang no='140.Kurlar'></td>
							</tr>
							<cfloop query="get_kur">
								<tr>
									<td class="txtbold">#MONEY#</td>
									<td>#TLFormat(RATE2,4)#</td>
								</tr>
							</cfloop>
						</table>
					</td>
					<td class="formbold"><cf_get_lang_main no='80.TOPLAM'> (<cf_get_lang no='141.KDV Hariç'>)</td>
					<td width="90">#TLFormat(tum_toplam)# #GET_STDMONEY.MONEY#</td>
					<td width="90">#TLFormat(tum_toplam/get_money_money2.rate2/get_money_money2.rate1)# #int_money2#</td>
				</tr>
				<cfif (len(get_general_prom.LIMIT_VALUE) and len(get_general_prom.DISCOUNT) and get_general_prom.LIMIT_VALUE lte genel_toplam)>
					<tr height="20">
						<td class="formbold">"GENEL PROMOSYON" İSKONTOSU</td>
						<td align="right">#TLFormat(toplam_indirim)# #GET_STDMONEY.MONEY#</td>
						<td align="right">#TLFormat(toplam_indirim/get_money_money2.rate2/get_money_money2.rate1)# #int_money2#</td>
					</tr>
				</cfif>
				<tr height="20">
					<td class="formbold">TOPLAM (KDV Dahil)</td>
					<td align="right">#TLFormat(tum_toplam_kdvli)# #GET_STDMONEY.MONEY#</td>
					<td align="right">#TLFormat(tum_toplam_kdvli/get_money_money2.rate2/get_money_money2.rate1)# #int_money2#</td>
				</tr>
					<input type="hidden" name="grosstotal" id="grosstotal" value="#tum_toplam_kdvli#">
				</cfoutput>
			</table>
			<table  width="100%" align="center">
				<cfoutput>				
					<cfif isdefined("session.ww.userid") or isdefined("session.ww.company_id") or isdefined("session.pp.userid")>
						<tr height="20">
							<td align="right" style="text-align:right;">
								<a href="##" onClick="amountChange();" class="basket_fiyat"></a>
								<a href="##" onClick="if (confirm('<cf_get_lang no="146.Sepeti boşaltmak istediğinize emin misiniz">?')) window.location='<cfoutput>#request.self#?fuseaction=objects2.emptypopup_del_basketww_camp</cfoutput>'" class="basket_delete"></a>
								<a href="##" onClick="siparisKaydet();" class="basket_order"></a>
							</td>
						</tr>
					<cfelse>
						<tr height="20">
							<td align="right" style="text-align:right;">
								<a href="##" onClick="amountChange();" class="basket_fiyat"></a>
								<a href="##" onClick="if (confirm('<cf_get_lang no="146.Sepeti boşaltmak istediğinize emin misiniz">?')) window.location='<cfoutput>#request.self#?fuseaction=objects2.emptypopup_del_basketww_camp</cfoutput>'" class="basket_delete"></a>
								<a href="##" onClick="if (confirm('Sipariş kaydetmek için üye girişi yapmalısınız.. \n(Üye değilseniz üye giriş sayfasında ilgili linke tıklayarak üye olabilirsiniz..) \n\nÜye girişi sayfasına gitmek ister misiniz?')) window.location='<cfoutput>#request.self#?fuseaction=objects2.member_login</cfoutput>'" class="basket_order"></a>
							</td>
						</tr>
					</cfif>
				</cfoutput>
			</table>
	<!---	<cfelse>
		<table width="100%" align="center" cellpadding="2" cellspacing="1">
			<tr height="22" class="color-header">
				<td class="form-title"><cf_get_lang_main no='75.No'></td>
				<td class="form-title"><cf_get_lang_main no='152.Ürünler'></td>
				<td width="40" class="form-title"><cf_get_lang_main no='223.Miktar'></td>
				<td width="70" align="right" class="form-title"><cf_get_lang_main no='226.Birim Fiyat'></td>
				<td width="90" align="right" class="form-title"><cf_get_lang_main no='672.Fiyat'></td>
			</tr>
			<tr height="20" class="color-row">
				<td colspan="5"><cf_get_lang no='134.Sepette ürün yok'>!</td>
			</tr>
		</table>
	</cfif>--->
	</cfform>
	<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	  <tr>
		<td class="headbold">
			<a class="tableyazi" href="#request.self#?fuseaction=objects2.list_basket"><cf_get_lang no='1045.Alışveriş Sepeti'></a>
		</td>
	  </tr>
	</table>
	</cfoutput>	
<!--- sıfır stok kontrolleri için listeler olusuyor --->
<cfscript>
	stock_id_list='';
	stock_amount_list='';
	for(brw=1;brw lte ArrayLen(session.basketww_camp);brw=brw+1)
	{
		yer=listfind(stock_id_list,session.basketww_camp[brw][8],',');
		if(yer eq 0)
		{
			stock_id_list=listappend(stock_id_list,session.basketww_camp[brw][8],',');
			stock_amount_list=listappend(stock_amount_list,session.basketww_camp[brw][3],',');
		}
		else
		{
			total_stock_miktar=session.basketww_camp[brw][3]+listgetat(stock_amount_list,yer,',');
			stock_amount_list=listsetat(stock_amount_list,yer,total_stock_miktar,',');
		}
	}
</cfscript>
<script type="text/javascript">
function sil(rowno)
{
	window.location = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_del_basketww_row_camp&rowno='+rowno;
}
function amountChange()
{   
	<cfoutput>
	flag = 0;
	for (i=1; i <= #ArrayLen(session.basketww_camp)#; i++)
	{
		if(eval('document.getElementById("amount_'+i+'")').value.length == 0 || isNaN(eval('document.getElementById("amount_'+i+'")').value))
		{
			flag = 1;
			break;
		}
	}
	if (flag == 0)
	{
		document.list_basketww.action='#request.self#?fuseaction=objects2.emptypopup_upd_basketww_row_camp';  /*&rowno='+rowno*/
		document.list_basketww.submit();
		return true;
	}
	else
	{
		alert("<cf_get_lang no='149.Miktar sayısal olmalıdır'> !");
		return false;
	}
	</cfoutput>
}
function siparisKaydet()
{
	if(!zero_stock_control('','',0,'',1)) return false;
	<cfoutput>
	document.list_basketww.action='<cfif use_https>#https_domain#</cfif>#request.self#?fuseaction=objects2.form_add_orderww_camp';
	document.list_basketww.submit();
	</cfoutput>
}

function zero_stock_control(dep_id,loc_id,is_update,process_type,stock_type)
{
	
	var hata = '';
	var stock_id_list=<cfif listlen(stock_id_list,',')><cfoutput>'#stock_id_list#'</cfoutput><cfelse>'0'</cfif>;
	var stock_amount_list=<cfif listlen(stock_amount_list,',')><cfoutput>'#stock_amount_list#'</cfoutput><cfelse>'0'</cfif>;

	//stock kontrolleri
	var stock_id_count=list_len(stock_id_list,',');
	if(stock_id_count >0)
	{
		for(jj=1;jj<=stock_id_count;jj++)
		{
			var stock_id=list_getat(stock_id_list,jj,',');
			var stock_amount=list_getat(stock_amount_list,jj,',');
			var listParam = stock_id + "*" + "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + "<cfoutput>#dsn_alias#</cfoutput>";
			var get_total_stock = wrk_safe_query("obj2_get_total_stock_2",'dsn2',0,listParam);	
			if(get_total_stock.recordcount)
			{
				if(parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK) < parseFloat(stock_amount))
					hata = hata+ 'Ürün:'+get_total_stock.PRODUCT_NAME+'\n';
			}else
			{//bu lokasyona hiç giriş veya çıkış olmadı ise kayıt gelemyecektir o yüzden else yazıldı
				var get_stock = wrk_safe_query("obj2_get_stock",'dsn3',0,stock_id);
				if(get_stock.recordcount)
					hata = hata+ 'Ürün:'+get_stock.PRODUCT_NAME+'\n';
			}
		}
	}
	if(hata!='')
	{
		alert(hata+"\n\n<cf_get_lang no='150.Yukarıdaki ürünlerde satılabilir stok miktarı yeterli değildir. Lütfen miktarları kontrol ediniz'> !");		
		return false;
	}
	else
		return true;
}


</script>
