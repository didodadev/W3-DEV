<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
  <tr class="color-border"> 
    <td> 
      <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
        <tr class="color-header"> 
          <td> 
			<table align="center" width="100%">
			<cfform action="#request.self#?fuseaction=stock.popup_vehicle_usage_purpose" method="post" name="form_usage_purpose">
			<cfif isDefined("name")>
			</cfif>
              <tr>
			      <td class="form-title"><cfoutput>#name#(#dateformat(now(),dateformat_style)# #timeformat(now(),timeformat_style)#)</cfoutput></td>
                  <td width="100" style="text-align:right;">				  	 
                  <select name="graph_type" id="graph_type" style="width:100px;">
                    <option value="" selected><cf_get_lang no='1.Grafik Format'></option>
                    <option value="pie"><cf_get_lang_main no='1316.Pasta'></option>
                    <option value="line"><cf_get_lang_main no='253.Eğri'></option>
					<option value="bar"><cf_get_lang_main no='251.Bar'></option>
                  </select>
                </td>
                <td width="18" style="text-align:right;"><cf_wrk_search_button></td>
              </tr>
            </cfform>
			</table>
          </td>
        </tr>
		<tr>
          <td bgcolor="#FFFFFF">
		  
			<cfif isDefined("form.graph_type") and len(form.graph_type)>
				<cfset graph_type = form.graph_type>
			<cfelse>
				<cfset graph_type = "bar">
			</cfif>
			<cfquery name="" datasource="#dsn#">
			
			</cfquery>
 		  <cfchart 
		  	show3D="yes"
			showlegend="yes"
			xaxistitle="Ürün"
			yaxistitle="Miktar"
			tipBGColor="0099FF"
			font="Arial" pieslicestyle="solid" format="jpg">
			<cfif GET_STOCK_GRAPH.recordcount>
			  <cfchartseries 
			  		type="#graph_type#"
					query="GET_USAGE_PURPOSE"
					valuecolumn="product_stock"
					itemcolumn="property"
					serieslabel="Stok Tipine Göre Toplam Stok"
					colorlist="0099FF,6666CC,33CC33,CC6600,FF6600,FFCC00,FF66FF,999933,CCCC99,996699"
					paintstyle="raise"/>
			</cfif>
		  </cfchart>
		  </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
