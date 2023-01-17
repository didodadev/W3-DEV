<cfsetting showdebugoutput="no">
<div id="related_p_orders">
	<cf_ajax_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='29474.Emir No'></th>
				<th><cf_get_lang dictionary_id='58211.Siparis No'></th>
				<th><cf_get_lang dictionary_id='36608.Üretilen'></th>
				<th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
				<th><cf_get_lang dictionary_id='58834.İstasyon'></th>
				<th><cf_get_lang dictionary_id='36604.Hedef Başlangıç'></th>
				<th><cf_get_lang dictionary_id='36606.Hedef Bitiş'></th>				
				<th style="text-align:right"><cf_get_lang dictionary_id ='57635.Miktar'></th>
				<th style="text-align:right"><cf_get_lang dictionary_id ='36608.Üretilen'></th>
				<th style="text-align:right"><cf_get_lang dictionary_id ='58444.Kalan'></th>
				<th><cf_get_lang dictionary_id ='36865.Stok Fişi'></th>
			</tr>
		</thead>
		<tbody>
			<cfscript>
				production_level  = 0;
				related_production_list =attributes.upd;
				function WriteRelatedProduction(P_ORDER_ID)
				{
					var i = 1;
					QueryText = '
							SELECT
								S.STOCK_CODE,
								PO.P_ORDER_ID,
								PO.P_ORDER_NO,
								PO.STOCK_ID,
								(SELECT STATION_NAME FROM WORKSTATIONS WHERE STATION_ID = PO.STATION_ID) AS STATION_NAME,
								PO.START_DATE,
								PO.FINISH_DATE,
								PO.QUANTITY,
								S.STOCK_CODE,
								S.PRODUCT_NAME
							FROM
								STOCKS S,
								PRODUCTION_ORDERS PO
							WHERE
								S.STOCK_ID = PO.STOCK_ID AND
								PO_RELATED_ID = #P_ORDER_ID#';
					'GET_RELATED_PRODUCTION#P_ORDER_ID#' = cfquery(SQLString : QueryText, Datasource : dsn3);
					if(Evaluate('GET_RELATED_PRODUCTION#P_ORDER_ID#').recordcount) 
					{
						production_level = production_level + 1;
						for(i=1;i lte Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").recordcount;i=i+1)
						{
							//Verilen Üretim Emirleri Toplamı
							//bu query ilişkili üretim emirlerine sonuç girilip girilmediğini girilen sonucdan sonra kaçta üretilecek miktar kaldığını bulmak için eklendi.
							ProductionOrdersSumText='SELECT 
									ISNULL(SUM(AMOUNT),0) AMOUNT,
									POR.IS_STOCK_FIS
								FROM 
									PRODUCTION_ORDER_RESULTS POR,
									PRODUCTION_ORDER_RESULTS_ROW PORR
								WHERE 
									POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND
									POR.P_ORDER_ID = #Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").P_ORDER_ID[i]#
									AND PORR.TYPE = 1
								GROUP BY 
									POR.IS_STOCK_FIS';
							'ProductionOrdersSum#Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").P_ORDER_ID[i]#' = cfquery(SQLString : ProductionOrdersSumText, Datasource : dsn3);
							//.....Verilen Üretim Emirleri Toplamı
							OrderRelatedTtx = 'SELECT ORDER_NUMBER FROM ORDERS WHERE ORDER_ID IN (SELECT ORDER_ID FROM PRODUCTION_ORDERS_ROW WHERE PRODUCTION_ORDER_ID = #Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").P_ORDER_ID[i]# )';
							'GET_RELATED_ORDERS#Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").P_ORDER_ID[i]#' = cfquery(SQLString : OrderRelatedTtx, Datasource : dsn3);
							for(j=1;j lte Evaluate("GET_RELATED_ORDERS#Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").P_ORDER_ID[i]#").recordcount;j=j+1)
								{
								if(isdefined('ORDER_NUMBERS#Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").P_ORDER_ID[i]#'))
									'ORDER_NUMBERS#Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").P_ORDER_ID[i]#' = ListAppend(Evaluate('ORDER_NUMBERS#Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").P_ORDER_ID[i]#'),Evaluate("GET_RELATED_ORDERS#Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").P_ORDER_ID[i]#").ORDER_NUMBER[j],',');
								else
									'ORDER_NUMBERS#Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").P_ORDER_ID[i]#' = Evaluate("GET_RELATED_ORDERS#Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").P_ORDER_ID[i]#").ORDER_NUMBER[j];
								}
							leftSpace = RepeatString('&nbsp;', production_level*5);
							related_production_list = ListAppend(related_production_list,Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").P_ORDER_ID[i],',');
							if(isdefined("ORDER_NUMBERS#Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").P_ORDER_ID[i]#"))
								related_ordes = Evaluate("ORDER_NUMBERS#Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").P_ORDER_ID[i]#");
							else
								related_ordes ='';
							if(Evaluate('ProductionOrdersSum#Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").P_ORDER_ID[i]#').IS_STOCK_FIS eq 1)
								_stock_fis_durum_ ='<img src="/images/c_ok.gif" align="absmiddle" alt="#getLang('prod',145)#">';
							else	
								_stock_fis_durum_ ='<img src="/images/closethin.gif" align="absmiddle" alt="#getLang('prod',148)#">';
							miktar = Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").QUANTITY[i];
							uretilen_miktar = Evaluate('ProductionOrdersSum#Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").P_ORDER_ID[i]#').AMOUNT;
							if( not len(uretilen_miktar)) uretilen_miktar = 0;
							kalan_miktar = wrk_round(miktar,4)-wrk_round(uretilen_miktar,4);
							if(kalan_miktar eq 0) font_color = 'blue'; else font_color = 'red';
							writeoutput('
							<tr class="color-row" height="20">
								<td>#leftSpace#<a href="#request.self#?fuseaction=prod.order&event=upd&upd=#Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").P_ORDER_ID[i]#" class="tableyazi">#Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").P_ORDER_NO[i]#</a></td>
								<td align="center">#related_ordes#</td>
								<td title="#Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").PRODUCT_NAME[i]#">#left(Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").PRODUCT_NAME[i],40)#</td>
								<td>#Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").STOCK_CODE[i]#</td>
								<td>#Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").STATION_NAME[i]#</td>
								<td>#dateformat(Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").START_DATE[i],dateformat_style)# #timeformat(Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").START_DATE[i],'HH')#:#timeformat(Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").START_DATE[i],'MM')#</td>
								<td>#dateformat(Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").FINISH_DATE[i],dateformat_style)# #timeformat(Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").FINISH_DATE[i],'HH')#:#timeformat(Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").FINISH_DATE[i],'MM')#</td>
								<td style="text-align:right">#miktar#</td>
								<td style="text-align:right">#uretilen_miktar#</td>
								<td style="text-align:right"><font color="#font_color#">#kalan_miktar#</font></td>
								<td>#_stock_fis_durum_#</td>
							</tr> '); 
							WriteRelatedProduction(Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").P_ORDER_ID[i]);
						}
						production_level = production_level-1;
					}
				}
				WriteRelatedProduction(attributes.upd);
			</cfscript>
			<input type="hidden" name="related_production_list" id="related_production_list" value="<cfoutput>#related_production_list#</cfoutput>">
		</tbody>
	</cf_ajax_list>
</div>

