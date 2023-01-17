<cfquery datasource="#DSN3#" name="UNITS">
	SELECT
		*
	FROM
		PRODUCT_UNIT
	WHERE 
		PRODUCT_ID = #attributes.pid#
</cfquery>
<cfoutput query="UNITS">
	<cfquery name="GET_DATAS"  maxrows="5" datasource="#dsn3#">
		SELECT 
			PRICESTANDART_ID
		FROM 
			PRICE_STANDART
		WHERE 
			PRICE_STANDART.PRODUCT_ID = #URL.PID# 
		AND 
			PURCHASESALES = 1 
		ORDER BY 
			RECORD_DATE DESC
	</cfquery>
	<cfset PRI_ROWS=ValueList(GET_DATAS.PRICESTANDART_ID,",") >
	<cfquery name="GET_GRAPH_DATA#PRODUCT_UNIT_ID#" DATASOURCE="#DSN3#" MAXROWS="5">
		SELECT 
			PRICE_STANDART.RECORD_DATE,PRICE,money 
		FROM 
			PRICE_STANDART, PRODUCT_UNIT
		WHERE 
			PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID 
			AND PRICE_STANDART.UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID 
			AND PRICE_STANDART.PRODUCT_ID = #URL.PID# 
			AND PURCHASESALES = 1
			AND	PRODUCT_UNIT.PRODUCT_UNIT_ID = #PRODUCT_UNIT_ID#
			AND PRICESTANDART_ID IN (#PRI_ROWS#)
		ORDER BY 
			PRICESTANDART_ID
	</cfquery>
	<cfset QUERYNAME= Evaluate('GET_GRAPH_DATA'&PRODUCT_UNIT_ID)>
</cfoutput>
<cfform action="#request.self#?fuseaction=product.popup_graph_price_standart&pid=#attributes.pid#" method="post" name="form_stock">
<cf_form_list>
	<thead>
		<cfif isDefined("attributes.product_name")>
            <input type="hidden" name="product_name" id="product_name" value="<cfoutput>#attributes.product_name#</cfoutput>">
        </cfif>	
        <tr>		  			
        </tr>
     </thead>
</cf_form_list>
				<cfloop query="UNITS">
						<cfset QUERYNAME= Evaluate('GET_GRAPH_DATA'&PRODUCT_UNIT_ID)>
						<cfloop query="QUERYNAME" startrow="1" endrow="5">
						<cfset 'item_#currentrow#' = seriesLabel="#UNITS.ADD_UNIT#">
						<cfset 'value_#currentrow#' = "#price#">
						</cfloop>
				</cfloop>
				<script src="JS/Chart.min.js"></script>
				<canvas id="myChart" style="max-height:300px;width:100%;"></canvas>
				<script>
					var ctx = document.getElementById('myChart');
						var myChart = new Chart(ctx, {
							type: 'line',
							data: {
								labels: [<cfloop query="UNITS"><cfset QUERYNAME= Evaluate('GET_GRAPH_DATA'&PRODUCT_UNIT_ID)><cfloop query="QUERYNAME" startrow="1" endrow="5">
												 <cfoutput>"#evaluate("item_#currentrow#")#"</cfoutput>,</cfloop></cfloop>],
								datasets: [{
                            label: "Birim Fiyat",
                            backgroundColor: [<cfloop query="#UNITS#">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                            data: [<cfloop query="UNITS"><cfset QUERYNAME= Evaluate('GET_GRAPH_DATA'&PRODUCT_UNIT_ID)><cfloop query="QUERYNAME" startrow="1" endrow="5"><cfoutput>"#wrk_round(evaluate("value_#currentrow#"))#"</cfoutput>,</cfloop></cfloop>],
								}]
							},
							options: {}
					});
				</script>		                              
</cfform>

