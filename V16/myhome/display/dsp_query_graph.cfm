<cfinclude template="../query/get_query.cfm">
<cfset sql_query = get_query.report_query>
<cfset group_bys = "">
<cfset column_names = "">
<cfset column_names_tr = "">
<cfset COUNTER_ = 0>
<cfloop list="#get_query.column_ids#" index="item" delimiters=",">
	<cfset attributes.column_id = item>
	<cfinclude template="../query/get_report_column.cfm">
	<cfscript>
	COUNTER_ = COUNTER_+1;
	column_names_tr = listappend(column_names_tr, '#get_report_column.nick_name_tr#.#get_report_column.column_name_tr#', ',');
	column_names = listappend(column_names, get_report_column.column_name, ',');
	if (listgetat(get_query.COLUMN_FUNCTIONS, COUNTER_, ',') eq '_')
		{
		if (get_report_column.period_year eq 1)
			group_bys = listappend(group_bys, '#dsn_alias#.#get_report_column.table_name#.#get_report_column.column_name#', ',');
		else
			group_bys = listappend(group_bys, '#dsn#_#get_report_column.period_year#.#get_report_column.table_name#.#get_report_column.column_name#', ',');
		}
	</cfscript>
</cfloop>
<cfif (listLEN(GROUP_BYS,',') neq listlen(get_query.column_ids,',')) and len(group_bys)>
  <cfset sql_query = "#sql_query# GROUP BY #group_bys#">
</cfif>
<cfquery name="query_result" datasource="#dsn2#">
	#preservesinglequotes(sql_query)#
</cfquery>
<cfif (get_query.graph_item_id neq 0) and len(get_query.graph_item_id)>
	<cfset attributes.column_id = get_query.graph_item_id>
	<cfinclude template="../query/get_report_column.cfm">
	<cfset graph_item = "#get_report_column.column_name#">
<cfelse>
	<cfset graph_item = "">
</cfif>
<cfif (get_query.graph_value_id neq 0) and len(get_query.graph_value_id)>
	<cfset attributes.column_id = get_query.graph_value_id>
	<cfinclude template="../query/get_report_column.cfm">
	<cfset graph_value = "#get_report_column.column_name#">
<cfelse>
	<cfset graph_value = "">
</cfif>
<table width="98%" border="0">
	<tr>
		<td class="headbold" height="30"><cfoutput>#get_report_queries.query_name#</cfoutput></td>
	</tr>
	<tr> 
	  <td bgcolor="#FFFFFF">
	  <cfif len(graph_item) and len(graph_value)>
	
				<canvas id="myChartgraph" style="float:left;max-height:450px;max-width:450px;"></canvas>
				<script>
					var ctx = document.getElementById('myChartgraph');
						var myChartgraph = new Chart(ctx, {
							type: '<cfoutput>#chart_type#</cfoutput>',
							data: {
								labels: [<cfloop from="1" to="#query_result.recordcount#" index="jj">
												 <cfoutput>#evaluate("value_#jj#")#</cfoutput>,</cfloop>],
								datasets: [{
									label: "Aylara Göre kilometre dagılımı",
									backgroundColor: [<cfloop from="1" to="#query_result.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfloop from="1" to="#query_result.recordcount#" index="jj"><cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
								}]
							},
							options: {}
					});
				</script>				  
		  <cfelse><cf_get_lang dictionary_id='30930.Alan ve Değer Seçilmemiş'>!</cfif> </td>
	</tr>
</table>

