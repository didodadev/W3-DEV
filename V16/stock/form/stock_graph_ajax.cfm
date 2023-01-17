<cfparam name="attributes.graph_type" default="">
<script src="JS/Chart.min.js"></script>
<cfsetting showdebugoutput="no">
<cfif isDefined("stock_code")>
	<cfset name = stock_code>
<cfelse>
	<cfset name = "">
</cfif>
<cfsetting showdebugoutput="no">
<cfsavecontent variable="head">
	<cfif isDefined("name")>
		<input type="hidden" name="stock_code" id="stock_code" value="<cfoutput>#name#</cfoutput>">
	</cfif>
	<cfoutput>#name#</cfoutput>
</cfsavecontent>
<cf_box  title='#head#' scroll="1"  collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfform action="#request.self#?fuseaction=stock.popup_stock_graph_ajax&pid=#pid#" method="post" name="form_stock">
			<cfinclude template="../query/get_product_stock_detail.cfm">
			<cfif isDefined("form.graph_type") and len(form.graph_type)>
				<cfset graph_type = form.graph_type>
			<cfelse>
				<cfset graph_type = "bar">
			</cfif>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id ='44019.Ürün'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang dictionary_id ='57635.Miktar'></cfsavecontent>
                  <cfoutput query="GET_STOCK_GRAPH">
			<cfset value = #PRODUCT_TOTAL_STOCK#>
			<cfset 'item_#currentrow#'="#value#">
			</cfoutput>
                <cfsavecontent variable="message3"><cf_get_lang dictionary_id ='63816.Depolara Göre Toplam Stoklar'></cfsavecontent>
				<canvas id="myChart"></canvas>
				<cfif GET_STOCK_GRAPH.recordcount>
				<script>
					var ctx = document.getElementById('myChart');
						var myChart = new Chart(ctx, {
							
							type: '<cfoutput>#graph_type#</cfoutput>',
							data: {
								labels: [<cfloop query="GET_STOCK_GRAPH">
												'<cfoutput>#GET_STOCK_GRAPH.DEPARTMENT_HEAD#</cfoutput>',</cfloop>],
								datasets: [{
									label: <cfoutput>"#message3#"</cfoutput>,
									backgroundColor: [<cfloop from="1" to="#GET_STOCK_GRAPH.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfloop from="1" to="#GET_STOCK_GRAPH.recordcount#" index="jj"><cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
								}]
							},
							options: {},
					});
				</script>	
					</cfif>
</cfform>
</cf_box>