<cfinclude template="../login/send_login.cfm">
<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>

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
<cfinclude template="../query/get_basket_rows.cfm">
<cfform name="offer_form" method="post" action="#request.self#?fuseaction=objects2.emptypopup_add_offerww">
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
	<input type="hidden" name="basket_money"  id="basket_money" value="#str_money_bskt_func#">
</cfoutput>
<cfif get_rows.recordcount>
<table width="590" border="0">
	<tr height="22" bgcolor="f5f5f5">
	  <td class="txtbold"><cf_get_lang_main no='75.No'></td>
	  <td class="txtbold"><cf_get_lang_main no='245.rn'></td>
	  <td class="txtbold" width="50"><cf_get_lang_main no='223.Miktar'></td>
	  <cfif isdefined("attributes.is_price") and attributes.is_price eq 1>
		  <td width="100" align="right" class="txtbold" style="text-align:right;"><cf_get_lang_main no='226.Birim Fiyat'></td>
		  <td width="150" align="right" class="txtbold" style="text-align:right;"><cf_get_lang_main no='672.Fiyat'></td>
	  </cfif>
	</tr>
  <cfset tum_toplam = 0>
  <cfset tum_toplam_kdvli = 0>
	<cfoutput query="get_rows">
		<tr height="20" bgcolor="f5f5f5">
		  <td>#currentrow#</td>
		  <td><a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="tableyazi">#PRODUCT_NAME#</a></td>	
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
</cfif>
<table cellpadding="0" cellspacing="0" width="98%">
	<cfif isdefined("session.pp.userid")>
		<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#session.pp.company_id#</cfoutput>">
		<input type="hidden" name="company_name" id="company_name" value="<cfoutput>#session.pp.company#</cfoutput>">
	<cfelse>
		<input type="hidden" name="member_id" id="member_id" value="<cfoutput>#session.ww.userid#</cfoutput>">
	</cfif>
	<tr>
		<td>
			<table>
				<tr>
					<td width="80"><cf_get_lang_main no='133.Teklif'> *</td>
					<td colspan="3"><cfinput type="text" name="offer_head" message="Baslik Girmelisiniz" required="yes" value="" style="width:500px;"></td>
				</tr>
				<tr>
					<td valign="top"><cf_get_lang_main no='217.Aciklama'></td>
					<td colspan="3"><textarea style="width:500px;height:150px;" name="offer_detail" id="offer_detail"></textarea></td>
				</tr>
				<tr>
					<td valign="top"><cf_get_lang_main no='1037.Teslim Yeri'></td>
					<td valign="top">
					<input type="hidden" name="city_id" id="city_id" value="">
					<input type="hidden" name="county_id" id="county_id" value="">
					<table cellpadding="1" cellspacing="0">
					  <tr>
					   <td><textarea name="ship_address" id="ship_address" style="width:500px;height:50px;" onChange="kontrol(this,200)"></textarea></td>
					   <td valign="top"><a href="javascript://" onClick="add_adress();"><img border="0" name="imageField2" src="/images/plus_list.gif" align="absmiddle"></a></td>
					  </tr>
					</table>
					</td>
				</tr>
				<tr>
					<cfif isdefined("attributes.is_offer_company") and attributes.is_offer_company eq 1>
						<td><cf_get_lang_main no='45.Musteri'> *</td>
						<cfinclude template="../query/get_emps_pars_cons.cfm">
						<td>
                        	<select name="member" id="member" style="width:170px;">
								<option value=""><cf_get_lang_main no='322.Seiniz'></option>
								<cfoutput query="get_emps_pars_cons">
								<cfif (type eq 2) or (type eq 4) or (type eq 5)>
									<option value="#uye_id#,#comp_id#,#type#"><cfif len(get_emps_pars_cons.nickname)>#nickname# - </cfif>#uye_name# #uye_surname#</option>
								</cfif>
								</cfoutput>
							</select>
						</td>
					</cfif>
					<td><cf_get_lang_main no='1104.Odeme Yontemi'></td>
					<td><input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="">
						<input type="hidden" name="commission_rate" id="commission_rate" value="">
						<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
						<input name="basket_due_value" id="basket_due_value" type="hidden" value="">
						<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
						<input type="text" name="paymethod" id="paymethod" value="" readonly style="width:175px;">
					 	<cfset card_link="&field_card_payment_id=offer_form.card_paymethod_id&field_card_payment_name=offer_form.paymethod&field_commission_rate=offer_form.commission_rate&field_paymethod_vehicle=offer_form.paymethod_vehicle">
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_paymethods&field_id=offer_form.paymethod_id&field_name=offer_form.paymethod&field_dueday=offer_form.basket_due_value#card_link#</cfoutput>','list');"><img src="/images/plus_list.gif" align="absmiddle" border="0"></a>
					</td>
				</tr>
				<tr>
					<td></td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang_main no='1331.Gonder'></cfsavecontent>
						<cf_workcube_buttons insert_info='#message#' is_upd='0'>
					</td>
				</tr>
			</table>		
		</td>
	</tr>
</table>
</cfform>
<script type="text/javascript">
function kontrol (ship_address,limit)
{
	StrLen = ship_address.value.length;
	if (StrLen > limit)
	{
		alert("<cf_get_lang_main no='163.Teslim Yeri En Fazla 200 Karakter Girilebilir'>!");
		return false;
	}
}
function add_adress()
{
	if(!(offer_form.company_id.value=="") || !(offer_form.member_id.value==""))
	{
		if(offer_form.company_id.value!="")
			{
				str_adrlink = '&field_long_adres=offer_form.ship_address';
				if(offer_form.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=offer_form.city_id';
				if(offer_form.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=offer_form.county_id';
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(offer_form.company_name.value)+''+ str_adrlink , 'list');
				return true;
			}
		else
			{
				str_adrlink = '&field_long_adres=offer_form.ship_address'; 
				if(offer_form.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=offer_form.city_id';
				if(offer_form.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=offer_form.county_id';
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(offer_form.consumer.value)+''+ str_adrlink , 'list');
				return true;
			}
	}
}
</script>
