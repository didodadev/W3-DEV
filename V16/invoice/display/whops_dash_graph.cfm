<cfif get_invoice.recordcount>
    <cfoutput query="get_invoice_date"> 
        <cfset 'item_#currentrow#' = "#listGetAt(hours_list,REC_DATE)#">
        <cfset 'value_cash_#currentrow#' = "#cash_action_value_#">
        <cfset 'value_total_#currentrow#' = "#amount_#">
        <cfset 'value_nettotal_#currentrow#' = "#NETTOTAL_#">
        <cfset 'value_sepet_#currentrow#' = "#SEPET#">
    </cfoutput>
    <canvas id="whops_dash_graph" style="height:100%"></canvas>
    <script>
        var whops_dash_graph = document.getElementById('whops_dash_graph');
        var whops_dash_graph_pie = new Chart(whops_dash_graph, {
            type: 'line',
            data:   {
                        labels: [
                            <cfloop from="1" to="#get_invoice_date.recordcount#" index="i">
                                        <cfoutput>"#evaluate("item_#i#")#"</cfoutput>,</cfloop>],
                        datasets: [{
                            label: "<cf_get_lang dictionary_id='58645.Nakit'> %",
                            backgroundColor: [<cfloop from="1" to="#get_invoice_date.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                            data: [<cfloop from="1" to="#get_invoice_date.recordcount#" index="x"><cfoutput><cfif evaluate("value_nettotal_#x#") neq 0 >"#wrk_round(evaluate("value_cash_#x#")*100/evaluate("value_nettotal_#x#"))#"<cfelse>"#wrk_round(0)#"</cfif></cfoutput>,</cfloop>],
                            },
                            {
                                label: "<cf_get_lang dictionary_id='38687.Kredi'> %",
                                fill: false,
                                borderColor: [<cfloop from="1" to="#get_invoice_date.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                data: [<cfloop from="1" to="#get_invoice_date.recordcount#" index="x"><cfoutput><cfif evaluate("value_nettotal_#x#") neq 0>"#wrk_round(evaluate("value_total_#x#")*100/evaluate("value_nettotal_#x#"))#"<cfelse>"#wrk_round(0)#"</cfif></cfoutput>,</cfloop>],
                            },
                            {
                                label: "<cf_get_lang dictionary_id='57448.Satış'> %",
                                fill: false,
                                borderColor: [<cfloop from="1" to="#get_invoice_date.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                data: [<cfloop from="1" to="#get_invoice_date.recordcount#" index="x"><cfoutput>"#wrk_round(evaluate("value_nettotal_#x#"))#"</cfoutput>,</cfloop>],
                            } ,
                            {
                                label: "<cf_get_lang dictionary_id='63123.Sepet'>",
                                fill: false,
                                borderColor: [<cfloop from="1" to="#get_invoice_date.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                data: [<cfloop from="1" to="#get_invoice_date.recordcount#" index="x"><cfoutput>"#wrk_round(evaluate("value_sepet_#x#"))#"</cfoutput>,</cfloop>],
                            } 
                            ,
                            {
                                label: "<cf_get_lang dictionary_id='61551.Sepet Ortalama'>",
                                fill: false,
                                borderColor: [<cfloop from="1" to="#get_invoice_date.recordcount#" index="j">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                data: [<cfloop from="1" to="#get_invoice_date.recordcount#" index="x"><cfoutput><cfif evaluate("value_sepet_#x#") neq 0>"#wrk_round(evaluate("value_nettotal_#x#")/evaluate("value_sepet_#x#"))#"<cfelse>"#wrk_round(0)#"</cfif></cfoutput>,</cfloop>],
                            } 
                        ]
                    },
            options: {
                legend: {
                    display: true,
                    position: "bottom"
                }
            }
        });
    </script>
</cfif>