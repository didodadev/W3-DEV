<cfquery name="GET_DEMAND_LIST" datasource="#DSN3#">
	<cfif not isdefined("attributes.order_id")>
		SELECT
			DEMAND_STATUS,
			RECORD_DATE,
			STOCK_ID,
			DEMAND_AMOUNT,
			GIVEN_AMOUNT,
			PRICE_KDV,
			DEMAND_ID,
            STOCK_ACTION_TYPE,
			'' ORDER_NUMBER
		FROM
			ORDER_DEMANDS
		WHERE
		<cfif isdefined("session.pp.userid")>
			RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
		<cfelseif isdefined("session.ww.userid")>
			RECORD_CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
		<cfelseif  isdefined("session.ep.userid")>
		   <cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
			   ORR.RECORD_CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
		   <cfelseif isdefined("attributes.partner_id") and len(attributes.partner_id)>
			   ORR.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#"> AND
		   </cfif>
		<cfelse>
			1 = 2 AND
		</cfif>
			DEMAND_STATUS = 1 AND 
			DEMAND_AMOUNT > ISNULL(GIVEN_AMOUNT,0)
		ORDER BY
			RECORD_DATE	
	<cfelse>
		SELECT
			ORR.DEMAND_STATUS,
			ORR.RECORD_DATE,
			ORR.STOCK_ID,
			ORR.DEMAND_AMOUNT,
			ORR.GIVEN_AMOUNT,
			ORR.PRICE_KDV,
			ORR.DEMAND_ID,
			ORR.STOCK_ACTION_TYPE,
			O.ORDER_NUMBER
		FROM
			ORDER_DEMANDS ORR,
			ORDERS O
		WHERE
			ORR.ORDER_ID = O.ORDER_ID AND
			O.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> AND
			ORR.DEMAND_STATUS = 1 
		ORDER BY
			ORR.RECORD_DATE
    </cfif>
</cfquery>

<cfparam name="attributes.totalrecords" default="#get_demand_list.recordcount#">

<table cellpadding="1" cellspacing="1" style="width:100%;">
	<tr class="color-header" style="height:22px;">
		<td class="form-title" style="width:55px;"><cf_get_lang_main no='75.No'></td>
		<td class="form-title" style="width:110px;"><cf_get_lang_main no='799.Siparis No'></td>
		<td class="form-title" style="width:90px;"><cf_get_lang_main no='1704.Sipariş Tarihi'></td>
		<td class="form-title"><cf_get_lang_main no='1388.Ürün Kodu'></td>
		<td class="form-title"><cf_get_lang_main no='245.Ürün'></td>
		<td class="form-title"><cf_get_lang_main no='223.Miktar'></td>
		<td class="form-title"><cf_get_lang_main no='226.Birim Fiyat'></td>
		<td class="form-title"><cf_get_lang_main no='1737.Toplam Tutar'></td>
		<td class="form-title" style="width:40px;"><cf_get_lang_main no='344.Durum'></td>
		<td class="form-title" align="center"><cf_get_lang_main no='1094.İptal'></td>
	</tr>
	<div id="demand_div" style="display:none;"></div>
	<cfif get_demand_list.recordcount>
        <cfset stock_list = ''>
        <cfoutput query="get_demand_list" startrow="1" maxrows="#attributes.maxrows#">
            <cfif len(stock_id) and not listfind(stock_list,stock_id,',')>
                <cfset stock_list = listappend(stock_list,stock_id)>
            </cfif>
        </cfoutput>
        <cfif listlen(stock_list)>
            <cfset stock_list=listsort(stock_list,"numeric","ASC",",")>
            <cfquery name="GET_STOCKS" datasource="#DSN3#">
                SELECT PRODUCT_NAME,PROPERTY,STOCK_ID,PRODUCT_ID,PRODUCT_CODE_2 FROM STOCKS WHERE STOCK_ID IN (#stock_list#) ORDER BY STOCK_ID
            </cfquery>
            <cfset stock_list = listsort(listdeleteduplicates(valuelist(get_stocks.stock_id,',')),'numeric','ASC',',')>
        </cfif>
        
        <cfoutput query="get_demand_list" startrow="1" maxrows="#attributes.maxrows#">
            <tr onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row" style="height:20px;">
                <td>#currentrow#</td>
                <td>#order_number#</td>
                <td>#dateformat(record_date,'dd/mm/yyyy')#</td>
                <td>#get_stocks.product_code_2[listfind(stock_list,get_demand_list.stock_id,',')]#</td>
                <td>#get_stocks.product_name[listfind(stock_list,get_demand_list.stock_id,',')]#</td>
                <td align="right" style="text-align:right;">
                    <cfif len(given_amount)>
                        #demand_amount-given_amount#
                        <cfset kalan_amount = demand_amount-given_amount>
                    <cfelse>
                        #demand_amount#
                        <cfset kalan_amount = demand_amount>
                    </cfif>
                </td>
                <td align="right" style="text-align:right;">#tlformat(price_kdv)# #session_base.money#</td>
                <td align="right" style="text-align:right;">#tlformat(price_kdv*kalan_amount)# #session_base.money#</td>
                <td id="refuse_3#demand_id#" <cfif demand_status eq 1>style=""<cfelse>style="display:none;"</cfif>>
                    <cfif demand_status eq 1>
                        Beklemede
                    <cfelse>
                        <cf_get_lang no='1645.İptal Edildi'>
                    </cfif>
                </td>
                <td id="refuse_4#demand_id#" <cfif demand_status eq 1>style="display:none;"</cfif>>
                    <cf_get_lang no='1645.İptal Edildi'>
                </td>
                <td align="center" id="refuse#demand_id#" <cfif demand_status eq 1>style=""<cfelse>style="display:none;"</cfif>>
                    <cfif demand_status eq 1  and stock_action_type neq 2>
                        <a href="javascript://" onclick="if (confirm('Ürün Talebi İptal Edilecek Emin misiniz ?')) connectAjax_demand('demand_div',#demand_id#);"><img src="/images/refusal.gif" border="0" title="Talebi İptal Et"></a>
                    </cfif>
                </td>
                <td id="refuse_2#demand_id#" <cfif demand_status eq 1>style="display:none;"</cfif>></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr class="color-row">
            <td colspan="10"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
        </tr>
    </cfif>
</table>
<script language="javascript">
	function connectAjax_demand(div_id,demand_id)
	{
		AjaxPageLoad(<cfoutput>'#request.self#?fuseaction=objects2.emptypopup_ajax_upd_order_demand&demand_id='+demand_id+''</cfoutput>,div_id);
		eval("document.getElementById('refuse" + demand_id + "')").style.display='none';
		eval("document.getElementById('refuse_2" + demand_id + "')").style.display='';
		eval("document.getElementById('refuse_3" + demand_id + "')").style.display='none';
		eval("document.getElementById('refuse_4" + demand_id + "')").style.display='';
	}
</script>

