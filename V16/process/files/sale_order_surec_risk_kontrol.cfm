<!--- by 20060405 
satis siparisi surecleri icin risk kontrolu --->
<cfif isDefined("session.ep")>
<script type="text/javascript">
function process_cat_dsp_function()
	{
debugger;
	if(form_basket.company_id!=undefined && form_basket.company_id.value!=''){
		var open_risk;var usable_risk;
		var risk_sql = 'SELECT BAKIYE, CEK_ODENMEDI, CEK_KARSILIKSIZ, SENET_ODENMEDI, SENET_KARSILIKSIZ, OPEN_ACCOUNT_RISK_LIMIT, TOTAL_RISK_LIMIT, COMPANY_ID FROM COMPANY_RISK WHERE COMPANY_ID='+form_basket.company_id.value;
		var get_company_risk = wrk_query(risk_sql,'dsn2');
		order_id = 0;
		bakiye = get_company_risk.BAKIYE;
		if($("#order_id").val() != undefined)
		order_id = $("#order_id").val();
		get_order_ = wrk_query("SELECT NETTOTAL FROM ORDERS WHERE ORDER_ID = "+order_id,'dsn3');
		if(get_order_.NETTOTAL > 0){
			bakiye = get_company_risk.BAKIYE - get_order_.NETTOTAL;
		}
		if(get_company_risk.recordcount)
			{
			open_risk = get_company_risk.OPEN_ACCOUNT_RISK_LIMIT - bakiye;
			usable_risk =parseFloat(get_company_risk.TOTAL_RISK_LIMIT) - parseFloat(bakiye)  - (parseFloat(get_company_risk.CEK_ODENMEDI) + parseFloat(get_company_risk.SENET_ODENMEDI) + parseFloat(get_company_risk.CEK_KARSILIKSIZ) + parseFloat(get_company_risk.SENET_KARSILIKSIZ));
			if(open_risk>0)<!--- mevcut odenmemis, islem gormemis satis siparisleri acik riski daha da kucultur, risk zaten negatif ise buraya hic girmez --->
				{
				if(document.all.order_id != undefined && document.all.order_id.value!='')
				{	
					var order_id_=document.all.order_id.value;
										
					var member_risk_order_='SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ('
					member_risk_order_=member_risk_order_+' SELECT ((ORD_ROW.QUANTITY-ISNULL(ORD_ROW.CANCEL_AMOUNT,0)-(SELECT ISNULL(SUM(SR.AMOUNT),0) FROM <cfoutput>#caller.dsn2_alias#</cfoutput>.SHIP_ROW SR,<cfoutput>#caller.dsn2_alias#</cfoutput>.SHIP S WHERE S.SHIP_ID = SR.SHIP_ID AND S.COMPANY_ID='+document.all.company_id.value+' AND SR.ROW_ORDER_ID<> '+order_id_+' AND ISNULL(S.IS_SHIP_IPTAL,0) = 0 AND SR.WRK_ROW_RELATION_ID=ORD_ROW.WRK_ROW_ID)-(SELECT ISNULL(SUM(SR.AMOUNT),0) FROM <cfoutput>#caller.dsn2_alias#</cfoutput>.INVOICE_ROW SR,<cfoutput>#caller.dsn2_alias#</cfoutput>.INVOICE S WHERE S.INVOICE_ID = SR.INVOICE_ID AND S.COMPANY_ID='+document.all.company_id.value+' AND SR.ORDER_ID<> '+order_id_+' AND S.IS_IPTAL = 0 AND SR.WRK_ROW_RELATION_ID=ORD_ROW.WRK_ROW_ID))*'
					member_risk_order_=member_risk_order_+' (((1-(ORDERS.SA_DISCOUNT)/((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)-(-(((((1-(ORDERS.SA_DISCOUNT)/(ORDERS.NETTOTAL-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100)))))/ORD_ROW.QUANTITY)) AS NETTOTAL FROM <cfoutput>#caller.dsn3_alias#</cfoutput>.ORDERS,<cfoutput>#caller.dsn3_alias#</cfoutput>.ORDER_ROW ORD_ROW WHERE ORDERS.ORDER_ID = ORD_ROW.ORDER_ID AND ISNULL(IS_MEMBER_RISK,1)=1 AND ORDER_STATUS=1'
					member_risk_order_=member_risk_order_+' AND ((ORDERS.PURCHASE_SALES=1 AND ORDERS.ORDER_ZONE=0) OR (ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=1)) AND IS_PAID<>1 AND COMPANY_ID='+document.all.company_id.value+' AND ORDERS.ORDER_ID<>'+order_id_+' AND ((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT))>0 AND ORD_ROW.ORDER_ROW_CURRENCY NOT IN(-8,-9,-10,-3)) AS A1';
					
					var member_risk_ship_ = 'SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ('
					var member_risk_ship_ = member_risk_ship_+' SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM INVOICE_ROW IR,INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES=S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.SHIP_ID=SR.SHIP_ID AND S.PURCHASE_SALES=1 AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.COMPANY_ID='+document.all.company_id.value;
					var member_risk_ship_ = member_risk_ship_+' AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM <cfoutput>#caller.dsn2_alias#</cfoutput>.INVOICE_ROW IR,<cfoutput>#caller.dsn2_alias#</cfoutput>.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES=S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0';
					if(order_id_ > 0)
						member_risk_ship_ = member_risk_ship_+' AND SR.ROW_ORDER_ID <> '+order_id_;
					var member_risk_ship_ = member_risk_ship_+') A1';
				}
				else
				{
					var member_risk_order_='SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ('
					member_risk_order_=member_risk_order_+' SELECT ((ORD_ROW.QUANTITY-ISNULL(ORD_ROW.CANCEL_AMOUNT,0)-(SELECT ISNULL(SUM(SR.AMOUNT),0) FROM <cfoutput>#caller.dsn2_alias#</cfoutput>.SHIP_ROW SR,<cfoutput>#caller.dsn2_alias#</cfoutput>.SHIP S WHERE S.SHIP_ID = SR.SHIP_ID AND S.COMPANY_ID='+document.all.company_id.value+' AND ISNULL(S.IS_SHIP_IPTAL,0) = 0 AND SR.WRK_ROW_RELATION_ID=ORD_ROW.WRK_ROW_ID)-(SELECT ISNULL(SUM(SR.AMOUNT),0) FROM <cfoutput>#caller.dsn2_alias#</cfoutput>.INVOICE_ROW SR,<cfoutput>#caller.dsn2_alias#</cfoutput>.INVOICE S WHERE S.INVOICE_ID = SR.INVOICE_ID AND S.COMPANY_ID='+document.all.company_id.value+' AND S.IS_IPTAL = 0 AND SR.WRK_ROW_RELATION_ID=ORD_ROW.WRK_ROW_ID))*'
					member_risk_order_=member_risk_order_+' (((1-(ORDERS.SA_DISCOUNT)/((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)-(-(((((1-(ORDERS.SA_DISCOUNT)/(ORDERS.NETTOTAL-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100)))))/ORD_ROW.QUANTITY)) AS NETTOTAL FROM <cfoutput>#caller.dsn3_alias#</cfoutput>.ORDERS,<cfoutput>#caller.dsn3_alias#</cfoutput>.ORDER_ROW ORD_ROW WHERE ORDERS.ORDER_ID = ORD_ROW.ORDER_ID AND ISNULL(IS_MEMBER_RISK,1)=1 AND ORDER_STATUS=1'
					member_risk_order_=member_risk_order_+' AND ((ORDERS.PURCHASE_SALES=1 AND ORDERS.ORDER_ZONE=0) OR (ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=1)) AND IS_PAID<>1 AND COMPANY_ID='+document.all.company_id.value+' AND ((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT))>0 AND ORD_ROW.ORDER_ROW_CURRENCY NOT IN(-8,-9,-10,-3)) AS A1';
					
					var member_risk_ship_ = 'SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ('
					var member_risk_ship_ = member_risk_ship_+' SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM INVOICE_ROW IR,INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES=S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.SHIP_ID=SR.SHIP_ID AND S.PURCHASE_SALES=1 AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.COMPANY_ID='+document.all.company_id.value;
					var member_risk_ship_ = member_risk_ship_+' AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM <cfoutput>#caller.dsn2_alias#</cfoutput>.INVOICE_ROW IR,<cfoutput>#caller.dsn2_alias#</cfoutput>.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES=S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0';
					var member_risk_ship_ = member_risk_ship_+') A1';					
				}				
			}
			if(member_risk_order_!=undefined)
			{
				var get_company_orders = wrk_query(member_risk_order_,'dsn3');
				if(get_company_orders.recordcount)
				{
					order_amount = parseFloat(get_company_orders.NETTOTAL);
					open_risk -= get_company_orders.NETTOTAL;
					usable_risk -= get_company_orders.NETTOTAL;
				}
			}
			if(member_risk_ship_!=undefined && member_risk_ship_!='')
			{
				var get_company_ship = wrk_query(member_risk_ship_,'dsn2');
				if(get_company_ship.recordcount)
				{
					ship_amount = parseFloat(get_company_ship.NETTOTAL);
					open_risk -= get_company_ship.NETTOTAL;
					usable_risk -= get_company_ship.NETTOTAL;
				}
			}

			if(open_risk<0 || usable_risk<0){
				alert('Bu cariye ait risk limitleri zaten doldurulmuş!!! \nSipariş Alamazsınız!'+'\nAçık Hesap:'+commaSplit(open_risk)+'\nKullanılabilir Risk:'+commaSplit(usable_risk));
				return false;
				}
			else if(open_risk>0 && open_risk<parseFloat(form_basket.basket_net_total.value) ){
				alert('Bu cariye ait risk bu siparişle birlikte : '+commaSplit( Math.abs(open_risk-parseFloat(form_basket.basket_net_total.value)) )+' <cfoutput><cfif isDefined("session.ep")>#session.ep.money#<cfelseif isDefined("session.pp")>#session.pp.money#</cfif></cfoutput> Aşılıyor\n! Siparişi Kaydedemezsiniz!' );
				return false;
				}
			else return true;<!--- risk satis yapmaya uygun --->
			}
		else
			return true;
		}
	else
		return true;
	}
</script>
</cfif>