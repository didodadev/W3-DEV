<cfscript>
	if (listfindnocase(partner_url,'#cgi.http_host#',';'))
	{
		int_userid = session.pp.userid;
		int_money = session.pp.money;
		int_comp_id = session.pp.our_company_id;
		int_period_id = session.pp.period_id;
		int_money2 = session.pp.money2;
	}
	else if (listfindnocase(server_url,'#cgi.http_host#',';') and isdefined('session.ww.userid') )
	{	
		int_userid = session.ww.userid;
		int_money = session.ww.money;
		int_comp_id = session.ww.our_company_id;
		int_period_id = session.ww.period_id;
		int_money2 = session.ww.money2;
	}
	else if (listfindnocase(server_url,'#cgi.http_host#',';') )
	{	
		int_money = session.ww.money;
		int_comp_id = session.ww.our_company_id;
		int_period_id = session.ww.period_id;
		int_money2 = session.ww.money2;
	}
</cfscript>
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
<cfif not isdefined("attributes.print")>
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="35" align="center">
  <tr class="color-list">
	<td class="headbold"><cf_get_lang_main no='133.Teklif'></td>
	<td align="right" style="text-align:right;">
	<a href="javascript://" onClick="<cfoutput>windowopen('#request.self#?fuseaction=objects2.popup_list_basketww_proposal&print=true#page_code#','page')</cfoutput>"><img src="/images/print.gif" title="Gönder" border="0"></a>
  	</td>
  </tr>
</table>
</cfif>
<cfinclude template="../query/get_basket_rows.cfm">
<br/>
<cfinclude template="../../objects/display/view_company_logo.cfm">
<br/>
<table cellpadding="0" cellspacing="0" width="700" align="center">
	<tr>
		<td align="right" class="txtbold" style="text-align:right;"><cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput></td>
	</tr>
</table>
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
<cfif get_rows.recordcount>
<table width="700" border="0" align="center">
	<tr height="22">
	  <td class="txtbold"><cf_get_lang_main no='75.No'></td>
	  <td class="txtbold"><cf_get_lang_main no='152.Ürünler'></td>
	  <td class="txtbold" width="50"><cf_get_lang_main no='223.Miktar'></td>
	  <cfif isdefined("attributes.is_price") and attributes.is_price eq 1>
		  <td width="100" align="right" class="txtbold" style="text-align:right;"><cf_get_lang_main no='226.Birim Fiyat'></td>
		  <td width="150" align="right" class="txtbold" style="text-align:right;"><cf_get_lang_main no='672.Fiyat'></td>
	  </cfif>
	</tr>
  <cfset tum_toplam = 0>
  <cfset tum_toplam_kdvli = 0>
	<cfoutput query="get_rows">
		<tr height="20">
		  <td>#currentrow#</td>
		  <td>#PRODUCT_NAME#</td>	
		  <td>#PROM_STOCK_AMOUNT#</td>
		 <cfif isdefined("attributes.is_price") and attributes.is_price eq 1>
		  <td align="right" style="text-align:right;">#TLFormat(PRICE)# #PRICE_MONEY#</td>
		  <td align="right" style="text-align:right;">
			#TLFormat(PRICE * PROM_STOCK_AMOUNT)#
			#PRICE_MONEY#
		  </td>
		  </cfif>
		</tr>
		 <cfif is_spec eq 1>
		     <cfquery name="get_inner_rows" datasource="#dsn3#">
				SELECT PRODUCT_NAME,DIFF_PRICE,ROW_MONEY,AMOUNT FROM ORDER_PRE_ROWS_SPECS WHERE MAIN_ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_row_id#">
			</cfquery>
		    <br/>
			<cfloop query="get_inner_rows">
				<tr>
					<td>&nbsp;</td>
					<td>#get_inner_rows.product_name#</td>
					<td>#get_inner_rows.AMOUNT#</td>
				</tr>
			</cfloop>
		</cfif> 
		<cfquery dbtype="query" name="GET_MONEY_RATE2">
			SELECT 
				RATE2
			FROM 
				GET_MONEY
			WHERE 
				MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#price_money#">
		</cfquery>
		<cfset satir_toplam_std = PRICE * PROM_STOCK_AMOUNT * GET_MONEY_RATE2.RATE2>
		<cfset tum_toplam = tum_toplam + satir_toplam_std>
	    <cfset satir_toplam_std_kdvli = PRICE_KDV* <!--- session.basketww[rowno][3] * ---> GET_MONEY_RATE2.RATE2> 
		<cfset tum_toplam_kdvli = tum_toplam_kdvli + satir_toplam_std_kdvli>		
  </cfoutput>
</table>
	<cfif isdefined("attributes.is_price") and attributes.is_price eq 1>
		<table cellpadding="0" cellspacing="0" width="700" align="center">
			<tr>
				<td align="right">
					<table>
						<cfoutput>
						<tr height="20">
							<td class="formbold"><cf_get_lang_main no='80.TOPLAM'></td>
							<td align="right">#TLFormat(tum_toplam)# #GET_STDMONEY.MONEY#</td>
						</tr>
						<tr height="20">
							<td class="formbold"><cf_get_lang_main no='80.TOPLAM'> (<cf_get_lang no='142.KDV Dahil'>)</td>
							<td align="right">#TLFormat(tum_toplam_kdvli)# #GET_STDMONEY.MONEY#</td>
						</tr>
						<input type="hidden" name="grosstotal" id="grosstotal" value="#tum_toplam_kdvli#">
						</cfoutput>
					</table>
				</td>
			</tr>
		</table>
	</cfif>
<cfelse>
<table cellpadding="0" cellspacing="0" width="700" align="center">
	<tr>
		<td>
		<table>
				<tr height="20">
					<td class="formbold"><cf_get_lang no='134.Sepette ürün yok'> !</td>
				</tr>
      	</table>
		</td>
	</tr>
</table>
</cfif>
</cfform>
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
<script type="text/javascript">
function sil(rowno)
{
	<cfoutput>
	window.location = '#request.self#?fuseaction=objects2.emptypopup_del_basketww_row&rowno='+rowno;
	</cfoutput>
}
function amountChange()
{
	<cfoutput>
	document.list_basketww.action='#request.self#?fuseaction=objects2.emptypopup_upd_basketww_row';  /*&rowno='+rowno*/
	document.list_basketww.submit();
	</cfoutput>
}
function siparisKaydet()
{
	<cfoutput>
	document.list_basketww.action='#request.self#?fuseaction=objects2.emptypopup_add_orderww';
	document.list_basketww.submit();
	</cfoutput>
}
</script>
