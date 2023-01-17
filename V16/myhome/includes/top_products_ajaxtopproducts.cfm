<cfsetting showdebugoutput="no">
<cfset attributes.maxrows=5>
<cfinclude template="high_sales_products.cfm">
    <cfquery name="chartque" datasource="#dsn3#" maxrows="#attributes.maxrows#" >
        SELECT 	
            SS.PRODUCT_NAME AS LABELS,
            SUM(SS.SATIS) AS DATA,
            SUM(SR.STOCK_OUT) AS DATA2            
        FROM 
            #dsn2_alias#.STOCKS_SALES SS, 
            #dsn2_alias#.STOCKS_ROW SR
        WHERE 
            SS.STOCK_ID = SR.STOCK_ID AND
            SR.STOCK_OUT > 0
        GROUP BY
            SS.PRODUCT_NAME
        ORDER BY 
            DATA2 DESC
	</cfquery>
	
		<cfif high_sales_products.recordcount>
			<cfoutput query="high_sales_products" maxrows="#attributes.maxrows#">
				<cfset 'item_#currentrow#' = "#high_sales_products.product_name# - #high_sales_products.main_unit#">
				<cfset 'value_#currentrow#' = "#TLFormat(round(high_sales_products.satis))#">
			</cfoutput>
		<cfelse>
			<cf_get_lang_main no='72.Kayıt Bulunamadı'>!
		</cfif>

		<canvas id="myChartproduct" style="height:50%;"></canvas>
		<script>
			var ctx = document.getElementById('myChartproduct');
			var myChartproduct = new Chart(ctx, {
				type: 'bar',
				data: {
						labels: [<cfloop from="1" to="#high_sales_products.recordcount#" index="jj">
								<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
						datasets: [{
						label: "<cfoutput>#getLang('myhome',177)#</cfoutput>",
						backgroundColor: [<cfloop from="1" to="#high_sales_products.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
						data: [<cfloop from="1" to="#high_sales_products.recordcount#" index="jj"><cfoutput>"#wrk_round(evaluate("value_#jj#"))#"</cfoutput>,</cfloop>],
							}]
						},
						options: {
							legend: {
								display: false
							}
						}
			});
		</script>

