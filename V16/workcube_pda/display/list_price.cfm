<cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
<cfset brnch = "">
<cfif len(trim(listgetat(session.pda.user_location,2,'-')))>
	<cfset brnch = listgetat(session.pda.user_location,2,'-')>
</cfif>

<cfif len(brnch)>
    <cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
        SELECT TOP 1 PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1 AND BRANCH LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#brnch#,%"> ORDER BY PRICE_CATID
    </cfquery>
</cfif>

<table border="0" cellpadding="0" cellspacing="0" align="center" style="width:98%; height:35px;">
	<tr>
		<td class="headbold">Fiyat Gör</td>
	</tr>
</table>
<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%;">	
	<tr>
		<td class="color-row">
            <cfform name="add_order" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_order" enctype="multipart/form-data">  
	            <table>
                    <tr>
                        <td style="width:70px;">Barkod</td>
                        <td style="width:200px;">
							:&nbsp;<input type="text" name="search_product" id="search_product" style="width:140px;" onkeydown="if(event.keyCode == 13) {return calc_list_price(trim(document.getElementById('search_product').value));}">
                             <a href="javascript://" onclick="calc_list_price(trim(document.getElementById('search_product').value));"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
                        </td>
                    </tr>
                    <tr style="height:30px;">
                        <td>Stok Adı</td>
                        <td id="stock_name">:&nbsp;</td>
                    </tr>
                    <tr style="height:30px;">
                        <td nowrap>Fiyat</td>
                        <td>:&nbsp;<input type="text" name="money_type" id="money_type" value="" readonly="yes" class="moneybox" style="width:40px;">&nbsp;<input type="text" name="nettotal" id="nettotal" value="" readonly="yes" class="moneybox" style="width:90px;">
							<br />&nbsp;&nbsp;KDV Hariç
						</td>
                    </tr>
	            </table>
            </cfform>
		</td>
	</tr>
</table>
<br/>
<cfform name="form_calc_order" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=pda.emptypopup_calc_list_price">  
	<input type="hidden" name="basket_products" id="basket_products" value="">
	<input type="hidden" name="basket_products_amount" id="basket_products_amount" value="">
	<input type="hidden" name="price_list_id" id="price_list_id" value="<cfif len(brnch) and get_price_cat.recordcount><cfoutput>#get_price_cat.price_catid#</cfoutput><cfelse>0</cfif>">
	<input type="hidden" name="price_date" id="price_date" value="<cfoutput></cfoutput>">
	<cfoutput query="get_money_bskt">
		<input type="hidden" name="txt_rate1_#money_type#" id="txt_rate1_#money_type#" value="#rate1#">
		<input type="hidden" name="txt_rate2_#money_type#" id="txt_rate2_#money_type#" value="#rate2#">
	</cfoutput>
	<input type="hidden" name="basket_money" id="basket_money" value="USD">
</cfform>

<div id="calc_order_div" style="display:none"></div>

<cfinclude template="../form/basket_js_functions_list_price.cfm">
