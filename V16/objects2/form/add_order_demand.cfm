<!---
demand_types....
1 - fiyat habercisi
2 - stok habercisi
3 - on siparis
--->
<cfif isdefined('attributes.stock_inform_price_list') and len(attributes.stock_inform_price_list)>
	<cfquery name="GET_PRICES" datasource="#DSN3#">
		SELECT
			PRICE,
			PRICE_KDV,
			MONEY
		FROM
			PRICE
		WHERE
			PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_inform_price_list#"> AND
			PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
	</cfquery>
</cfif>
<cfif isdefined('attributes.is_stock_selected') and len(attributes.is_stock_selected)>
	<cfquery name="GET_SALE_STOCK" datasource="#DSN2#">
		SELECT
			S.PROPERTY,
			GSL.STOCK_ID,
			GSL.SALEABLE_STOCK
		FROM
			GET_STOCK_LAST GSL,
			#DSN3#.STOCKS S
		WHERE
			S.STOCK_STATUS = 1 AND
			S.STOCK_ID = GSL.STOCK_ID AND
			GSL.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
	</cfquery>
<cfelse>
	<cfset get_sale_stock.recordcount = 0>
</cfif>
<cfform name="add_demand" action="#request.self#?fuseaction=objects2.emptypopup_add_order_demand">
	<table cellpadding="2" cellspacing="1" class="color-border" style="width:100%; height:100%">
	<cfoutput>
		<!---<input type="hidden" name="stock_id" id="stock_id" value="#attributes.stock_id#"> --->
		<input type="hidden" name="demand_type" id="demand_type" value="#attributes.demand_type#">
		<input type="hidden" name="stock_inform_price_list" id="stock_inform_price_list" value="<cfif isdefined('attributes.stock_inform_price_list') and len(attributes.stock_inform_price_list)>#attributes.stock_inform_price_list#</cfif>" />
		<cfif isdefined("attributes.campaign_id")>
			<input type="hidden" name="campaign_id" id="campaign_id" value="#attributes.campaign_id#">
		</cfif>
		<tr class="color-list" style="height:35px;">
			<td class="headbold">
				<cfif attributes.demand_type eq 1><cf_get_lang no ='1300.Fiyatı Düşünce Haber Ver'>
				<cfelseif attributes.demand_type eq 2><cf_get_lang no ='1301.Stoklara Girince Haber Ver'>
				<cfelseif attributes.demand_type eq 3><cf_get_lang no ='1146.Ön Sipariş / Rezerve'>
				</cfif>
			</td>
		</tr>
		<tr class="color-row">
			<td style="vertical-align:top;">
                <table border="0">
                    <input type="hidden" name="price" id="price" value="<cfif isdefined('attributes.stock_inform_price_list') and len(attributes.stock_inform_price_list) and get_prices.recordcount>#get_prices.price#<cfelse>#attributes.price#</cfif>">
                    <input type="hidden" name="price_kdv" id="price_kdv" value="<cfif isdefined('attributes.stock_inform_price_list') and len(attributes.stock_inform_price_list) and get_prices.recordcount>#get_prices.price_kdv#<cfelse>#attributes.price_kdv#</cfif>">
                    <input type="hidden" name="price_money" id="price_money" value="<cfif isdefined('attributes.stock_inform_price_list') and len(attributes.stock_inform_price_list) and get_prices.recordcount>#get_prices.money#<cfelse>#attributes.price_money#</cfif>">
                    <cfif attributes.demand_type neq 1>
                        <tr>
                            <td style="width:75px;"><cf_get_lang_main no ='245.Ürün'></td>
                            <td><input type="text" value="#get_product_name(stock_id:attributes.stock_id,with_property:1)#" style="width:200px;" readonly></td>
                        </tr>
                        <tr>
                            <td><cf_get_lang_main no ='261.Tutar'></td>
                            <td>
                                <input type="text" value="<cfif isdefined('attributes.stock_inform_price_list') and len(attributes.stock_inform_price_list) and get_prices.recordcount>#get_prices.price# #get_prices.money#<cfelse>#attributes.price# #attributes.price_money#</cfif>" style="width:200px;" readonly>
                                <input type="hidden" name="price" id="price" value="<cfif isdefined('attributes.stock_inform_price_list') and len(attributes.stock_inform_price_list) and get_prices.recordcount>#get_prices.price#<cfelse>#attributes.price#</cfif>">
                                <input type="hidden" name="price_kdv" id="price_kdv" value="<cfif isdefined('attributes.stock_inform_price_list') and len(attributes.stock_inform_price_list) and get_prices.recordcount>#get_prices.price_kdv#<cfelse>#attributes.price_kdv#</cfif>">
                                <input type="hidden" name="price_money" id="price_money" value="<cfif isdefined('attributes.stock_inform_price_list') and len(attributes.stock_inform_price_list) and get_prices.recordcount>#get_prices.money#<cfelse>#attributes.price_money#</cfif>">
                            </td>
                        </tr>
                    </cfif>
                    <tr>
                        <td><cf_get_lang_main no ='40.Stok'> *</td>
                        <td colspan="2" align="left">
                            <select name="stock_id" id="stock_id" style="width:200px;">
                                <option value="">Seçiniz</option>
                                <cfif get_sale_stock.recordcount>
                                    <cfloop query="get_sale_stock">
                                        <!--- <cfif saleable_stock lt 1> --->
                                        <option value="#stock_id#">#property#</option>
                                        <!--- </cfif> --->
                                    </cfloop>
                                </cfif>
                            </select>
                        </td>
                    </tr>
                    <cfif isdefined("session.pp.userid")>
                        <cfquery name="GET_EMAIL" datasource="#DSN#">
                            SELECT COMPANY_PARTNER_EMAIL AS UYE_EMAIL FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
                        </cfquery>
                    <cfelseif isdefined("session.ww.userid")>
                        <cfquery name="GET_EMAIL" datasource="#DSN#">
                            SELECT CONSUMER_EMAIL AS UYE_EMAIL FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
                        </cfquery>
                    </cfif>
                    <tr>
                        <td><cf_get_lang_main no ='16.E-mail'> *</td>
                        <cfsavecontent variable="alert"><cf_get_lang_main no='1072.Email Girmelisiniz'></cfsavecontent>
                        <td><cfif isdefined("session.pp.userid") or  isdefined("session.ww.userid")>
                                <cfinput type="text" name="member_email" id="member_email" value="#get_email.uye_email#" style="width:200px;" required="yes" message="#alert#">
                            <cfelse>
                                <cfinput type="text" name="member_email" id="member_email" value="" style="width:200px;" required="yes" message="#alert#">
                            </cfif>
                        </td>
                    </tr>
                    <cfif attributes.demand_type eq 2 or attributes.demand_type eq 3>
                        <tr>
                            <td><cf_get_lang_main no ='670.Adet'></td>
                            <td>
                                <cfsavecontent variable="alert"><cf_get_lang no ='160.Sayısal Değer Giriniz'></cfsavecontent>
                                <cfinput type="text" name="demand_amount" id="demand_amount" validate="integer" message="#alert#" required="yes" value="1" style="width:50px;">
                                <input type="hidden" name="demand_unit_id" id="demand_unit_id" value="#attributes.unit_id#">
                            </td>
                        </tr>
                    </cfif>
                    <tr>
                        <td style="vertical-align:top;"><cf_get_lang no ='1302.Notunuz'></td>
                        <td><textarea name="demand_note" id="demand_note" style="width:200px;height:80px;"></textarea></td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align:right;"><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
                    </tr>
                </table>
			</td>
		</tr>
	</cfoutput>
	</table>
</cfform>
<script type="text/javascript">
	function kontrol()
	{
		var aaa = document.getElementById('member_email').value;
		if (((aaa == '') || (aaa.indexOf('@') == -1) || (aaa.indexOf('.') == -1) || (aaa.length < 6)))
		{
			alert("<cf_get_lang_main no='1072.Geçerli Bir Mail Girmelisiniz'> !");
			return false;
		}
		if (document.getElementById('stock_id').value == '')
		{
			alert("Lütfen Stok Seçiniz !");
			return false;
		}

	}
</script>
