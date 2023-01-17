<cfsetting showdebugoutput="no">
<cf_get_lang_set module_name="prod">
<cfquery name="GET_PRODUCTION_ORDERS_RELATED2" datasource="#DSN3#">	

SELECT
								STOCK_CODE,
								P_ORDER_ID,
								P_ORDER_NO,
								STOCK_ID,
								STATION_NAME,
								START_DATE,
								FINISH_DATE,
								ISNULL(QUANTITY,0) QUANTITY,
								STOCK_CODE,
								PRODUCT_NAME,
								PROPERTY,
								PO_RELATED_ID,
								OPERATION_TYPE
FROM
(
			SELECT
										S.STOCK_CODE,
										PO.P_ORDER_ID,
										PO.P_ORDER_NO,
										PO.STOCK_ID,
										(SELECT STATION_NAME FROM WORKSTATIONS WHERE STATION_ID = PO.STATION_ID) AS STATION_NAME,
										PO.START_DATE,
										PO.FINISH_DATE,
										PO.QUANTITY,
										S.PRODUCT_NAME,
										S.PROPERTY,
										PO_RELATED_ID,
										OPERATION_TYPE
									FROM
										STOCKS S,
										PRODUCTION_ORDERS PO,
										TEXTILE_PRODUCTION_ORDERS_MAIN POM,
										OPERATION_TYPES
									WHERE
										S.STOCK_ID = PO.STOCK_ID AND
										PO.PARTY_ID=POM.PARTY_ID AND
										POM.PARTY_ID=#attributes.party_id# AND 
										OPERATION_TYPES.OPERATION_TYPE_ID=POM.OPERATION_TYPE_ID
											
			UNION ALL 
			SELECT
									S.STOCK_CODE,
									PO.P_ORDER_ID,
									PO.P_ORDER_NO,
									PO.STOCK_ID,
									(SELECT STATION_NAME FROM WORKSTATIONS WHERE STATION_ID = PO.STATION_ID) AS STATION_NAME,
									PO.START_DATE,
									PO.FINISH_DATE,
									PO.QUANTITY,
									S.PRODUCT_NAME,
									S.PROPERTY,
									PO_RELATED_ID,
									OPERATION_TYPE
								FROM
									STOCKS S,
									PRODUCTION_ORDERS PO,
									TEXTILE_PRODUCTION_ORDERS_MAIN POM,
									OPERATION_TYPES
								WHERE
									S.STOCK_ID = PO.STOCK_ID AND
									PO.PARTY_ID=POM.PARTY_ID AND
									POM.RELATED_PARTY_ID=#attributes.party_id# AND
									OPERATION_TYPES.OPERATION_TYPE_ID=POM.OPERATION_TYPE_ID
								
		)
		AS R
		ORDER BY R.P_ORDER_ID
				
	<!---= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#">--->
</cfquery>
<div id="related_p_orders">
	<cf_ajax_list>
		<thead>
			<tr>
				<th>Operasyon No</th>
				<th>Operasyon</th>
				<th><cf_get_lang_main no='799.Siparis No'></th>
				<th><cf_get_lang no='295.Üretilen'></th>
				<th><cf_get_lang_main no ='106.Stok Kodu'></th>
				<th><cf_get_lang_main no='1422.İstasyon'></th>
				<!---<th><cf_get_lang no='291.Hedef Başlangıç'></th>
				<th><cf_get_lang no='293.Hedef Bitiş'></th>	--->			
				<th style="text-align:right"><cf_get_lang_main no='223.Miktar'></th>
				<th style="text-align:right"><cf_get_lang no ='295.Üretilen'></th>
				<th style="text-align:right"><cf_get_lang_main no ='1032.Kalan'></th>
				<th><cf_get_lang no ='552.Stok Fişi'></th>
			</tr>
		</thead>
		<tbody>
			<!---<cfscript>
				production_level  = 0;
			
				related_production_list =GET_PRODUCTION_ORDERS_RELATED2.P_ORDER_ID;
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
								_stock_fis_durum_ ='<img src="/images/c_ok.gif" align="absmiddle" alt="#lang_array.item[145]#">';
							else	
								_stock_fis_durum_ ='<img src="/images/closethin.gif" align="absmiddle" alt="#lang_array.item[148]#">';
							miktar = Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").QUANTITY[i];
							uretilen_miktar = Evaluate('ProductionOrdersSum#Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").P_ORDER_ID[i]#').AMOUNT;
							if( not len(uretilen_miktar)) uretilen_miktar = 0;
							kalan_miktar = miktar-uretilen_miktar;
							if(kalan_miktar eq 0) font_color = 'blue'; else font_color = 'red';
							writeoutput('
							<tr class="color-row" height="20">
								<td>#leftSpace#<a href="#request.self#?fuseaction=prod.form_upd_prod_order&upd=#Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").P_ORDER_ID[i]#" class="tableyazi">#Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").P_ORDER_NO[i]#</a></td>
								<td align="center">#related_ordes#</td>
								<td title="#Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").PRODUCT_NAME[i]#">#left(Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").PRODUCT_NAME[i],40)#</td>
								<td>#Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").STOCK_CODE[i]#</td>
								<td>#Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").STATION_NAME[i]#</td>
								<td>#dateformat(Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").START_DATE[i],'dd/mm/yyyy')# #timeformat(Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").START_DATE[i],'HH')#:#timeformat(Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").START_DATE[i],'MM')#</td>
								<td>#dateformat(Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").FINISH_DATE[i],'dd/mm/yyyy')# #timeformat(Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").FINISH_DATE[i],'HH')#:#timeformat(Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").FINISH_DATE[i],'MM')#</td>
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
				WriteRelatedProduction(GET_PRODUCTION_ORDERS_RELATED2.P_ORDER_ID);
			</cfscript>
			--->
			<cfquery name="GET_SUM_AMOUNT_" datasource="#DSN3#">
			SELECT 
				ISNULL(SUM(POR_.AMOUNT),0) AS SUM_AMOUNT,
				POR_.P_ORDER_ID,
				POO.IS_STOCK_FIS
				
			FROM 
				PRODUCTION_ORDER_RESULTS_ROW POR_,
				PRODUCTION_ORDER_RESULTS POO
				
			WHERE 
				POR_.PR_ORDER_ID = POO.PR_ORDER_ID AND
					<!---AND POO.PARTY_ID =#attributes.party_id#--->
				POR_.P_ORDER_ID IN(#ValueList(GET_PRODUCTION_ORDERS_RELATED2.P_ORDER_ID)#)
				AND ISNULL(IS_FREE_AMOUNT,0) = 0
				AND TYPE=1
				GROUP BY
						POR_.P_ORDER_ID,
						POO.IS_STOCK_FIS
		</cfquery>
	
			<cfset _stock_fis_durum_ ='<img src="/images/closethin.gif" align="absmiddle" '>
			<cfoutput query="GET_PRODUCTION_ORDERS_RELATED2">
				<cfset uretilen_miktar=0>
			<cfif GET_SUM_AMOUNT_.recordcount>
					<cfquery name="get_prod_result_sum" dbtype="query">
							select *from GET_SUM_AMOUNT_ where P_ORDER_ID=#P_ORDER_ID#
					</cfquery>
						<cfif len(get_prod_result_sum.SUM_AMOUNT)>
						<cfset uretilen_miktar=get_prod_result_sum.SUM_AMOUNT>
						</cfif>
					<cfif get_prod_result_sum.is_stock_fis eq 1>
						<cfset _stock_fis_durum_='<img src="/images/c_ok.gif" align="absmiddle" '>
					</cfif>
			</cfif>
			
			<cfset kalan_miktar=QUANTITY-uretilen_miktar>
			<tr class="color-row" height="20">
								<td>
								<cfif len(PO_RELATED_ID)>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								</cfif>
									#P_ORDER_NO#
								</td>
								<td align="center">#OPERATION_TYPE#</td>
								<TD></TD>
								<td >#left(PRODUCT_NAME,40)# #property#</td>
								<td>#STOCK_CODE#</td>
								<td>#STATION_NAME#</td>
							<!---	<td>#dateformat(START_DATE,'dd/mm/yyyy')# #timeformat(START_DATE,'HH')#:#timeformat(START_DATE,'MM')#</td>
								<td>#dateformat(FINISH_DATE,'dd/mm/yyyy')# #timeformat(FINISH_DATE,'HH')#:#timeformat(FINISH_DATE,'MM')#</td>
							--->
								<td style="text-align:right">#QUANTITY#</td>
								<td style="text-align:right">#uretilen_miktar#</td>
								<td style="text-align:right"><font color="red">#kalan_miktar#</font></td>
								<td>#_stock_fis_durum_#</td>
							</tr>
			</cfoutput>
			<input type="hidden" name="related_production_list" id="related_production_list" value="<!---<cfoutput>#related_production_list#</cfoutput>--->">
		</tbody>
	</cf_ajax_list>
</div>
