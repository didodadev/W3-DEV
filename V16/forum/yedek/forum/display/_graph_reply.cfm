<cfinclude template="../query/get_subject_replies.cfm">
<table border="0" width="300" cellpadding="0" cellspacing="0" height="295">
  <tr class="color-border">
    <td width="100%" valign="top">
      <table width="100%" height="100%" border="0" cellpadding="2" cellspacing="1">
        <tr class="color-header">
          <td>
            <table border="0" width="100%" cellpadding="0" cellspacing="0">
              <cfform name="graph" method="post" action="#request.self#?fuseaction=forum.popup_graph_reply">
                <tr class="color-header">
                  <td class="form-title"><cf_get_lang no='59.Cevap Sayısına Göre Konular'></td>
                  <td align="right" style="text-align:right;">
                    <select name="graph_type" style="width:100px;">
                      <option value="" selected><cf_get_lang_main no='37.Grafik Format'></option>
                      <option value="pie"><cf_get_lang_main no='1316.Pasta'></option>
                      <option value="line"><cf_get_lang_main no='253.Eğri'></option>
                      <option value="bar"><cf_get_lang_main no='251.Bar'></option>
                    </select>
                  </td>
                  <td width="30" align="right" style="text-align:right;"><cf_wrk_search_button></td>
                </tr>
              </cfform>
            </table>
          </td>
        </tr>
        <tr>
          <cfif isDefined("form.graph_type") and  len(form.graph_type)>
            <cfset graph_type=#form.graph_type#>
            <cfelse>
            <cfset graph_type="pie">
          </cfif>
          <td bgcolor="#FFFFFF" align="center" valign="top" width="100%">
            <cfset colorlist="d099ff,6666cc,33cc33,cc6600,ff6600,ffcc00,ff66ff,999933,cccc99,996699,339999,ccff66,ccccff,6699ff">
          
              
          <cfoutput query="get_subject_replies">
                                    <cfset value = #REPLY_COUNT#>
                                    <cfset item = #TITLE#>
                                    <cfset 'item_#currentrow#'="#value#">
                                    <cfset 'value_#currentrow#'="#item#"> 
                                    </cfoutput>
                                     <script src="JS/Chart.min.js"></script>
                                        <canvas id="myChart" style="float:left;max-height:450px;max-width:450px;"></canvas>
                                        <script>
                                            var ctx = document.getElementById('myChart');
                                                var myChart = new Chart(ctx, {
                                                    type: '<cfoutput>#graph_type#</cfoutput>',
                                                    data: {
                                                        labels: [<cfloop from="1" to="#get_subject_replies.recordcount#" index="jj">
                                                                        <cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
                                                        datasets: [{
                                                            label: " ",
                                                            backgroundColor: [<cfloop from="1" to="#get_subject_replies.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                                            data: [<cfloop from="1" to="#get_subject_replies.recordcount#" index="jj"><cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
                                                        }]
                                                    },
                                                    options: {}
                                            });
                                        </script>		                     
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

