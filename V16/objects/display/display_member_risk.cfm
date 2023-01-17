<cfquery name="check_company_risk_type" datasource="#dsn#"><!--- şirkette detaylı risk takibi yapılıyor mu kontrol ediliyor --->
	SELECT ISNULL(IS_DETAILED_RISK_INFO,0) IS_DETAILED_RISK_INFO FROM OUR_COMPANY_INFO WHERE COMP_ID=#session.ep.company_id#
</cfquery>
<div class="col col-12 col-xs-12">
<div class="ui-row">
	<div id="sepetim_total">
		<div class="col col-3 col-md-4 col-sm-6 col-xs-12" id="basket_money_totals_table" <cfif isdefined("display_list") and not ListFindNoCase(display_list, "is_price_total_other_money")>style="display:none"</cfif>>
			<div class="totalBox">
				<div class="totalBoxHead font-grey-mint">
					<span class="headText"><cf_get_lang dictionary_id ='58619.Risk Bilgisi'></span>
					<div class="collapse">
						<span class="icon-minus"></span>
					</div>
				</div>
				<div class="totalBoxBody">
					<table>	
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id ='57589.Bakiye'></td>
							<td nowrap="nowrap"><input type="text" name="member_bakiye" id="member_bakiye" value="0" class="box" readonly> <cfoutput>#session.ep.money#</cfoutput></td>
						</tr>
						<cfif isdefined('use_basket_project_discount_') and use_basket_project_discount_ eq 1>
							<tr>
								<td class="txtbold"><cf_get_lang dictionary_id ='58858.Bağlantı Bakiyesi'></td>
								<td nowrap="nowrap"><input type="text" name="prj_remainder_" id="prj_remainder_" value="0" class="box" readonly> <cfoutput>#session.ep.money#</cfoutput></td>
							</tr>	
							<tr>
								<td class="txtbold" nowrap="nowrap"><cf_get_lang dictionary_id ='58893.Bağlantı Kullanılabilir Limit'></td>
								<td nowrap="nowrap"><input type="text" name="prj_useable_limit" id="prj_useable_limit" value="0" class="box" readonly> <cfoutput>#session.ep.money#</cfoutput></td>
							</tr>
						</cfif>
						<tr>
							<td class="txtbold" nowrap="nowrap"><cf_get_lang dictionary_id ='58622.Açık Siparişler'></td>
							<td nowrap="nowrap"><input type="text" name="member_order_value" id="member_order_value" value="0" class="box" readonly> <cfoutput>#session.ep.money#</cfoutput></td>
						</tr>	
						<tr>
							<td class="txtbold" nowrap="nowrap"><cf_get_lang dictionary_id ='58620.Üye Kullanılabilir Limit'></td>
							<td nowrap="nowrap"><input type="text" name="member_use_limit" id="member_use_limit" value="0" class="box" readonly> <cfoutput>#session.ep.money#</cfoutput></td>
						</tr>
						<tr style="color:#FF0000">
							<td><b><cf_get_lang dictionary_id ='58621.Limit Aşımı'></b></td>
							<td nowrap="nowrap"><input type="text" name="limit_diff_value" id="limit_diff_value" value="0" class="box" readonly> <cfoutput>#session.ep.money#</cfoutput></td>
						</tr>
					</table>
				</div>
			</div>    
		</div>  
	</div> 
</div>
</div>

<script type="text/javascript">
<cfif isdefined('use_basket_project_discount_') and use_basket_project_discount_ eq 1>
	function set_project_risk_limit() /*proje baglantılarına gore bakıyeyi hesaplar*/
	{ 
		var prj_remainder_info=0;
		var open_order_limit=0;
		var prj_ship_total_=0
		var total_prj_limit_=0;
		if($("#basket_main_div #project_id").length != 0 && $("#basket_main_div #project_id").val().length != 0)
		{
			var project_id_ = $("#basket_main_div #project_id").val()
			if(project_id_!=undefined && project_id_ !='')
			{
				var prj_total_risk_=0;
				if($("#basket_main_div #company_id").length != 0 && $("#basket_main_div #company_id").val().length != 0)
				{
					var company_id_ = $("#basket_main_div #company_id").val();
					var str_member_prj_risk_ = 'SELECT * FROM COMPANY_REMAINDER_PROJECT WHERE COMPANY_ID = '+ company_id_ +' AND PROJECT_ID='+project_id_;
					
					var str_prj_order_risk_='SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ('
					str_prj_order_risk_=str_prj_order_risk_+' SELECT ((ORD_ROW.QUANTITY-ISNULL(ORD_ROW.CANCEL_AMOUNT,0)-ISNULL(ORD_ROW.DELIVER_AMOUNT,0))*'
					str_prj_order_risk_=str_prj_order_risk_+' (((1-(ORDERS.SA_DISCOUNT)/((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)-(-(((((1-(ORDERS.SA_DISCOUNT)/(ORDERS.NETTOTAL-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100)))))/ORD_ROW.QUANTITY)) AS NETTOTAL FROM <cfoutput>#dsn3_alias#</cfoutput>.ORDERS,<cfoutput>#dsn3_alias#</cfoutput>.ORDER_ROW ORD_ROW WHERE ORDERS.ORDER_ID = ORD_ROW.ORDER_ID AND ISNULL(IS_MEMBER_RISK,1)=1 AND ORDER_STATUS=1'
					str_prj_order_risk_=str_prj_order_risk_+' AND ((ORDERS.PURCHASE_SALES=1 AND ORDERS.ORDER_ZONE=0) OR (ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=1)) AND IS_PAID<>1 AND COMPANY_ID='+company_id_+' AND PROJECT_ID='+project_id_+' AND ORDERS.ORDER_ID<>'+order_id_+' AND ((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT))>0 AND ORD_ROW.ORDER_ROW_CURRENCY NOT IN(-8,-9,-10,-3)) AS A1';
			
					var str_prj_ship_total_ = 'SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ('
					var str_prj_ship_total_ = str_prj_ship_total_+' SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM INVOICE_ROW IR,INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.PURCHASE_SALES = 1 AND S.SHIP_ID=SR.SHIP_ID AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.COMPANY_ID='+company_id_+' AND S.PROJECT_ID='+project_id_;
					var str_prj_ship_total_ = str_prj_ship_total_+' AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM <cfoutput>#dsn2_alias#</cfoutput>.INVOICE_ROW IR,<cfoutput>#dsn2_alias#</cfoutput>.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0';
					if(order_id_ > 0)
						str_prj_ship_total_ = str_prj_ship_total_+' AND SR.ROW_ORDER_ID <> '+order_id_;
					var str_prj_ship_total_ = str_prj_ship_total_+') A1';
				}
				else if($("#basket_main_div #consumer_id").length != 0 && $("#basket_main_div #consumer_id").val().length != 0)
				{
					var consumer_id_ = $("#basket_main_div #consumer_id").val();
					var str_member_prj_risk_ = 'SELECT * FROM CONSUMER_REMAINDER_PROJECT WHERE CONSUMER_ID = '+consumer_id_+' AND PROJECT_ID='+project_id_;
					
					var str_prj_order_risk_='SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ('
					str_prj_order_risk_=str_prj_order_risk_+' SELECT ((ORD_ROW.QUANTITY-ISNULL(ORD_ROW.CANCEL_AMOUNT,0)-ISNULL(ORD_ROW.DELIVER_AMOUNT,0))*'
					str_prj_order_risk_=str_prj_order_risk_+' (((1-(ORDERS.SA_DISCOUNT)/((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)-(-(((((1-(ORDERS.SA_DISCOUNT)/(ORDERS.NETTOTAL-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100)))))/ORD_ROW.QUANTITY)) AS NETTOTAL FROM <cfoutput>#dsn3_alias#</cfoutput>.ORDERS,<cfoutput>#dsn3_alias#</cfoutput>.ORDER_ROW ORD_ROW WHERE ORDERS.ORDER_ID = ORD_ROW.ORDER_ID AND ISNULL(IS_MEMBER_RISK,1)=1 AND ORDER_STATUS=1'
					str_prj_order_risk_=str_prj_order_risk_+' AND ((ORDERS.PURCHASE_SALES=1 AND ORDERS.ORDER_ZONE=0) OR (ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=1)) AND IS_PAID<>1 AND CONSUMER_ID='+consumer_id_+' AND PROJECT_ID='+project_id_+' AND ORDERS.ORDER_ID<>'+order_id_+' AND ((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT))>0 AND ORD_ROW.ORDER_ROW_CURRENCY NOT IN(-8,-9,-10,-3)) AS A1';

					var str_prj_ship_total_ = 'SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ('
					var str_prj_ship_total_ = str_prj_ship_total_+' SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM INVOICE_ROW IR,INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.SHIP_ID=SR.SHIP_ID AND S.PURCHASE_SALES = 1 AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.CONSUMER_ID='+consumer_id_+' AND S.PROJECT_ID='+project_id_;
					var str_prj_ship_total_ = str_prj_ship_total_+' AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM <cfoutput>#dsn2_alias#</cfoutput>.INVOICE_ROW IR,<cfoutput>#dsn2_alias#</cfoutput>.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0';
					if(order_id_ > 0)
						str_prj_ship_total_ = str_prj_ship_total_+' AND SR.ROW_ORDER_ID <> '+order_id_;
					var str_prj_ship_total_ = str_prj_ship_total_+') A1';
				}
				//form_basket.note.value=str_prj_order_risk_+'aaaaaaa'+str_prj_ship_total_;
				if(str_member_prj_risk_!=undefined)
				{
					var get_member_prj_risk = wrk_query(str_member_prj_risk_,'dsn2');
					if(get_member_prj_risk.recordcount!= 0 && get_member_prj_risk.BAKIYE!='')
					{
						prj_remainder_info=get_member_prj_risk.BAKIYE; //proje bakiyesi display edilen
						total_prj_limit_=(-1)*get_member_prj_risk.BAKIYE //proje bakiyesi hesaplamalarda kullanılan
					}
				}
				if(str_prj_order_risk_!=undefined)
				{
					var get_prj_order_risk_=wrk_query(str_prj_order_risk_,'dsn2');
					if(get_prj_order_risk_.recordcount!= 0 && get_prj_order_risk_.NETTOTAL!='' )
						open_order_limit=parseFloat(get_prj_order_risk_.NETTOTAL);
				}
				if(str_prj_ship_total_!=undefined)
				{
					var get_prj_ship_total_=wrk_query(str_prj_ship_total_,'dsn2');
					if(get_prj_ship_total_.recordcount!= 0 && get_prj_ship_total_.NETTOTAL!='' )
						prj_ship_total_=parseFloat(get_prj_ship_total_.NETTOTAL);
				}
			}
			document.all.prj_remainder_.value=commaSplit(prj_remainder_info);
			document.all.prj_useable_limit.value=commaSplit(total_prj_limit_-open_order_limit-prj_ship_total_);	
		 }
		 return true;
	}
</cfif>
function find_risk(is_start)
{
	if($("#basket_main_div #order_id").length != 0 && $("#basket_main_div #order_id").val().length != 0)
		order_id_ = $("#basket_main_div #order_id").val();
	else
		order_id_ = 0;
	if(order_id_ == '' || isNaN(order_id_))
		order_id_ = 0;
	var order_amount = 0;
	var ship_amount = 0;
	if($("#basket_main_div #consumer_id").length != 0 && $("#basket_main_div #consumer_id").val().length != 0)
	{
		var consumer_id_ = $("#basket_main_div #consumer_id").val();
		if(document.all.add_member_button != undefined)
			document.all.add_member_button.style.display="none";
		if(document.all.paper_button != undefined)	
			document.all.paper_button.style.display='';
		var get_consumer_cc_2 = wrk_safe_query('obj_consumer_cc_2','dsn2', 0, consumer_id_);
		if(get_consumer_cc_2.recordcount)
		{
			toplam_risk_2 = parseFloat(get_consumer_cc_2.TOTAL_RISK_LIMIT) - (parseFloat(get_consumer_cc_2.BAKIYE) + parseFloat(get_consumer_cc_2.SENET_KARSILIKSIZ) + parseFloat(get_consumer_cc_2.CEK_KARSILIKSIZ) + parseFloat(get_consumer_cc_2.CEK_ODENMEDI) + parseFloat(get_consumer_cc_2.SENET_ODENMEDI) + parseFloat(get_consumer_cc_2.KEFIL_SENET_ODENMEDI) + parseFloat(get_consumer_cc_2.KEFIL_SENET_KARSILIKSIZ));
			bakiye_2 = parseFloat(get_consumer_cc_2.BAKIYE);
		}
		else
		{
			toplam_risk_2 = 0;
			bakiye_2=0;
		}
		var listParam4 = "<cfoutput>#dsn2_alias#</cfoutput>" + "*" + consumer_id_ + "*" + order_id_;
		<cfif check_company_risk_type.recordcount neq 0 and check_company_risk_type.IS_DETAILED_RISK_INFO eq 1> /*detaylı risk takibi yapılıyor*/
			var risk_order='obj_get_company_orders';
			
			var listParam5 = "<cfoutput>#dsn2_alias#</cfoutput>" + "*" + consumer_id_ + "*" + order_id_;
			var risk_ship = 'obj_get_company_ship';
			if(order_id_ > 0)
				risk_ship = 'obj_get_company_ship_3';
		<cfelse>
			var risk_order = 'obj_get_company_orders_3';
			var risk_ship='';
		</cfif>
	}
	else if($("#basket_main_div #company_id").length != 0 && $("#basket_main_div #company_id").val().length != 0)
	{
		var company_id_ =  $("#basket_main_div #company_id").val();
		if(document.all.add_member_button != undefined)
			document.all.add_member_button.style.display="none";
		if(document.all.paper_button != undefined)
			document.all.paper_button.style.display='';
		var get_company_cc_2 = wrk_safe_query('obj_company_cc_2','dsn2',0,company_id_);
		if(get_company_cc_2.recordcount)
		{
			toplam_risk_2 = parseFloat(get_company_cc_2.TOTAL_RISK_LIMIT) - (parseFloat(get_company_cc_2.BAKIYE) + parseFloat(get_company_cc_2.SENET_KARSILIKSIZ) + parseFloat(get_company_cc_2.CEK_KARSILIKSIZ) + parseFloat(get_company_cc_2.CEK_ODENMEDI) + parseFloat(get_company_cc_2.SENET_ODENMEDI));
			bakiye_2 = parseFloat(get_company_cc_2.BAKIYE);
		}
		else
		{
			toplam_risk_2 = 0;
			bakiye_2=0;
		}
		var listParam4 = "<cfoutput>#dsn2_alias#</cfoutput>" + "*" + company_id_ + "*" + order_id_;
		<cfif check_company_risk_type.recordcount neq 0 and check_company_risk_type.IS_DETAILED_RISK_INFO eq 1> /*detaylı risk takibi yapılıyor*/
			var risk_order='obj_get_company_orders_2';
			
			var listParam5 = "<cfoutput>#dsn2_alias#</cfoutput>" + "*" + company_id_ + "*" + order_id_;
			var risk_ship = 'obj_get_company_ship_2';
			if(order_id_ > 0)
				risk_ship = 'obj_get_company_ship_4';
		<cfelse>
			var risk_order = 'obj_get_company_orders_4';
			var risk_ship='';
		</cfif>
	}
	else
	{
		if(document.all.add_member_button != undefined && is_start == undefined)
			document.all.add_member_button.style.display='';
		if(document.all.paper_button != undefined)
			document.all.paper_button.style.display="none";
		toplam_risk_2 = 0;
		bakiye_2=0;
	}
	if(risk_order != undefined)
	{
		var get_company_orders = wrk_safe_query(risk_order,'dsn3',0,listParam4);
		if(get_company_orders.recordcount)
		{
			document.getElementById('member_order_value').value = commaSplit(get_company_orders.NETTOTAL);
			order_amount = parseFloat(get_company_orders.NETTOTAL);
		}
		else
			document.getElementById('member_order_value').value = commaSplit(0);
	}
	else
		document.getElementById('member_order_value').value = commaSplit(0);
	
	if(risk_ship!=undefined && risk_ship!='')
	{
		var get_company_ship = wrk_safe_query(risk_ship,'dsn2',0,listParam5);
		if(get_company_ship.recordcount)
			ship_amount = parseFloat(get_company_ship.NETTOTAL);
	}

	if(document.all.member_bakiye != undefined)
		document.all.member_bakiye.value = commaSplit(bakiye_2);
	if(document.getElementById('member_use_limit') != undefined)	
	{
		document.getElementById('member_use_limit').value = commaSplit(toplam_risk_2-order_amount-ship_amount);
	}
	<cfif isdefined('use_basket_project_discount_') and use_basket_project_discount_ eq 1> /*basket sablonunda proje iskontoları seciliyse risk bölümünde proje bakiye limiti vs gelir*/
		set_project_risk_limit();
	</cfif>
	$( document ).ready(function() {
		toplam_limit_hesapla();
	});
	
}
	
function toplam_limit_hesapla()
{
	total_kefil_limit = 0;
	if(form_basket.record_num_2!= undefined)
	{
		for(j=1;j<=form_basket.record_num_2.value;j++)
		{
			if(eval('form_basket.row_kontrol_2'+j).value == 1)
			total_kefil_limit = total_kefil_limit + filterNum(eval('form_basket.last_use_risk'+j).value,4);
		}				
		form_basket.total_guarantor_limit.value = commaSplit(total_kefil_limit);
	}
	total_member_limit = filterNum(form_basket.member_use_limit.value);
	if(form_basket.total_voucher_value != undefined)
		total_value = filterNum(form_basket.total_voucher_value.value);
	else
		total_value = form_basket.basket_net_total.value;
	total_open_order = filterNum(form_basket.member_order_value.value);
	total_limit = total_kefil_limit + total_member_limit;
	if((total_value-total_limit) > 0)
		form_basket.limit_diff_value.value = commaSplit(total_value-total_limit);	
	else
		form_basket.limit_diff_value.value = commaSplit(0);	
	if(form_basket.limit_diff_value.style!=undefined)form_basket.limit_diff_value.style.color='FF0000';
}
$( document ).ready(function() {
	find_risk(1);
});

	
</script>
