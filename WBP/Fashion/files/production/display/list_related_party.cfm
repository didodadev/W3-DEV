<cfsetting showdebugoutput="no">
<cf_get_lang_set module_name="prod">
<cfquery name="GET_PRODUCTION_PART_RELATED" datasource="#DSN3#">	
	select 
		POM.*,
		P.*
	from 
	PRODUCTION_ORDERS_MAIN POM,
	PRODUCT P
	WHERE 
		P.PRODUCT_ID=POM.PRODUCT_ID AND
		(<!---POM.PARTY_ID=#attributes.party_id# OR--->  POM.RELATED_PARTY_ID=#attributes.party_id#)
</cfquery>
<div id="related_p_orders">
	<cf_ajax_list>
		<thead>
			<tr>
				<th>Parti No</th>
				<th><cf_get_lang no='295.Üretilen'></th>
				<th>Ürün Kodu</th>
				<th><cf_get_lang no='291.Hedef Başlangıç'></th>
				<th><cf_get_lang no='293.Hedef Bitiş'></th>				
				<th style="text-align:right"><cf_get_lang_main no='223.Miktar'></th>
				<th style="text-align:right"><cf_get_lang no ='295.Üretilen'></th>
				<th style="text-align:right"><cf_get_lang_main no ='1032.Kalan'></th>
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
		
	
			<cfoutput query="GET_PRODUCTION_PART_RELATED">
					<cfset uretilen_miktar=0>
					<cfif len(RESULT_AMOUNT)>
						<cfset uretilen_miktar=RESULT_AMOUNT>
					</cfif>
			
			<cfset kalan_miktar=AMOUNT-uretilen_miktar>
			<tr class="color-row" height="20">
								<td>
								<cfif len(RELATED_PARTY_ID)>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								</cfif>
									<a href="#request.self#?fuseaction=prod.form_upd_prod_order_tex&party_id=#PARTY_ID#" class="tableyazi">#PARTY_NO#</a>
								</td>
							
								<td >#left(PRODUCT_NAME,40)#</td>
								<td>#PRODUCT_CODE#</td>
								<td>#dateformat(START_DATE,'dd/mm/yyyy')# #timeformat(START_DATE,'HH')#:#timeformat(START_DATE,'MM')#</td>
								<td>#dateformat(FINISH_DATE,'dd/mm/yyyy')# #timeformat(FINISH_DATE,'HH')#:#timeformat(FINISH_DATE,'MM')#</td>
								
								<td style="text-align:right">#AMOUNT#</td>
								<td style="text-align:right">#uretilen_miktar#</td>
								<td style="text-align:right"><font color="red">#kalan_miktar#</font></td>
							
							</tr>
			</cfoutput>
			<input type="hidden" name="related_production_list" id="related_production_list" value="<!---<cfoutput>#related_production_list#</cfoutput>--->">
		</tbody>
	</cf_ajax_list>
</div>
