<cfsetting showdebugoutput="no">
<!--- Aktif ve Eksik Teslimat, Sevk Asamalarindaki Satis Siparisleri --->
<cfquery name="GET_ORDER" datasource="#DSN3#">
	SELECT
		O.ORDER_ID,
		O.ORDER_NUMBER,
		O.DELIVERDATE
	FROM
		ORDERS O
	WHERE
		O.ORDER_STATUS = 1 AND
		O.PURCHASE_SALES = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.purchase_sales#"> AND
		<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
			O.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
		</cfif>
		O.ORDER_ID IN 	(	SELECT
								OW.ORDER_ID
							FROM
								ORDER_ROW OW,
								PRODUCT_UNIT PU,
        						STOCKS_BARCODES SB
							WHERE
								OW.STOCK_ID = SB.STOCK_ID AND
								SB.BARCODE IS NOT NULL AND
								PU.PRODUCT_UNIT_STATUS = 1 AND
								PU.PRODUCT_ID = OW.PRODUCT_ID AND
								OW.UNIT = PU.ADD_UNIT AND
								SB.UNIT_ID = PU.PRODUCT_UNIT_ID AND
								( ( OW.ORDER_ROW_CURRENCY IN (-6,-7) AND O.IS_PROCESSED = 1 ) OR ( OW.ORDER_ROW_CURRENCY = -6 AND O.IS_PROCESSED = 0 ) ) AND
								OW.ORDER_ID = O.ORDER_ID
						)
	ORDER BY
		O.ORDER_DATE DESC,
		O.ORDER_ID DESC
</cfquery>
<cf_box title="Siparişler" id="list_ship_order_div" body_style="overflow-y:scroll;height:100px;" call_function="gizle(document.getElementById('#attributes.div_name#'));">
<table cellspacing="0" cellpadding="0" border="0" align="center" style="width:90%;">
	<tr class="color-border">
		<td>
            <table cellspacing="1" cellpadding="2" border="0" style="width:100%;">
                <tr class="color-header" style="height:22px;">		
                    <td class="form-title" style="width:75px;">Teslim Tarihi</td>
                    <td class="form-title">Sipariş No</td>
                </tr>
                <cfif get_order.recordcount>
                    <cfoutput query="get_order">		
                        <tr class="color-row" style="height:20px;">
                            <td><a href="##" onclick="get_order_row_div(0,'#order_id#','#order_number#');" class="tableyazi">#dateformat(deliverdate,'dd/mm/yyyy')#</a></td>
                            <td><a href="##" onclick="get_order_row_div(0,'#order_id#','#order_number#');" class="tableyazi">#order_number#</a></td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr class="color-row">
                        <td colspan="3" height="20">Kayıt Yok !</td>
                    </tr>
                </cfif>
            </table>
		</td>
	</tr>
</table>
</cf_box>
<script type="text/javascript">
	function get_order_row_div(is_send_all,order_id,order_number)
	{	
		if(document.getElementById("order_id").value=='')
		{
			document.getElementById("order_id").value = order_number;
			document.getElementById("order_id_listesi").value = order_id;
		}
		else
		{
			document.getElementById("order_id").value=document.getElementById("order_id").value+','+order_number;
			document.getElementById("order_id_listesi").value=document.getElementById("order_id_listesi").value+','+order_id;
		}
		var div_name_ = "<cfoutput>#attributes.div_name#</cfoutput>";
		AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_get_order_row_products_div&is_send_all='+is_send_all+'&order_id='+order_id,div_name_);
		gizle(eval('' + div_name_ + ''));
		return false;
	}
</script>
