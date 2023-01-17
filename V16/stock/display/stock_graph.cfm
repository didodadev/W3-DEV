<cfparam name="attributes.graph_type" default="">
<script src="JS/Chart.min.js"></script>
<cfif isDefined("product_name")>
	<cfset name = product_name>
<cfelse>
	<cfset name = "">
</cfif>
<cfsetting showdebugoutput="no">
<cfsavecontent variable="head">
	<cfif isDefined("name")>
		<input type="hidden" name="product_name" id="product_name" value="<cfoutput>#name#</cfoutput>">
	</cfif>
	<cfoutput>#name#(#dateformat(now(),dateformat_style)# #timeformat(now(),timeformat_style)#)</cfoutput>
</cfsavecontent>
<cf_box title='#head#' scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfform action="#request.self#?fuseaction=stock.popup_stock_graph&pid=#pid#" method="post" name="form_stock">
			<cfinclude template="../query/get_product_stock_detail.cfm">
			<cfif isDefined("form.graph_type") and len(form.graph_type)>
				<cfset graph_type = form.graph_type>
			<cfelse>
				<cfset graph_type = "bar">
			</cfif>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id ='44019.Ürün'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang dictionary_id ='57635.Miktar'></cfsavecontent>
		<cfif GET_STOCK_GRAPH.recordcount>
                  <cfoutput query="GET_STOCK_GRAPH">
			<cfset value = #PRODUCT_TOTAL_STOCK#>
			<cfset 'item_#currentrow#'="#value#">
			</cfoutput>
				</cfif>
				<canvas id="myChart"></canvas>
				<script>
					var ctx = document.getElementById('myChart');
						var myChart = new Chart(ctx, {
							type: '<cfoutput>#graph_type#</cfoutput>',
							data: {
								labels: [<cfloop query="GET_STOCK_GRAPH">
												'<cfoutput>#GET_STOCK_GRAPH.DEPARTMENT_HEAD#</cfoutput>',</cfloop>],
								datasets: [{
									label: "<cfoutput>#getlang('','Depolara göre toplam stok','63816')#</cfoutput>",
									backgroundColor: [<cfloop from="1" to="#GET_STOCK_GRAPH.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfloop from="1" to="#GET_STOCK_GRAPH.recordcount#" index="jj"><cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
								}]
							},
							options: {}
					});
				</script>		
</cfform>
</cf_box>