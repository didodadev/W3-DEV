      <table cellspacing="1" cellpadding="2" border="0" width="98%" height="100%" class="color-border" align="center">
        <tr class="color-header"> 
          <td height="25" align="right" style="text-align:right;"> 
			<table align="center" width="100%">
			<cfform action="" method="post" name="form_stock">
              <tr>
			    <td class="form-title"><cf_get_lang_main no='3373.Master Plan Durumu'></td>
                <td width="100" align="right" style="text-align:right;"> 
                  <select name="graph_type" style="width:100px;">
                  	<option value="bar"<cfif isdefined("attributes.graph_type") and attributes.graph_type is 'bar'>selected</cfif>><cf_get_lang_main no='251.Bar'></option>
                    <option value="pie"<cfif isdefined("attributes.graph_type") and attributes.graph_type is 'pie'>selected</cfif>>Pie</option>
                    <option value="line"<cfif isdefined("attributes.graph_type") and attributes.graph_type is 'line'>selected</cfif>><cf_get_lang_main no='253.Eğri'></option>
                  </select>
                </td>
                <td width="18" align="right" style="text-align:right;"><input type="submit" name="graph" value="<cf_get_lang_main no='1184.Göster'>" /></td>
              </tr>
            </cfform>
			</table>
          </td>
        </tr>
		<tr bgcolor="#FFFFFF">
          <td> 
			<cfif isdefined("form.graph_type") and len(form.graph_type)>
                <cfset graph_type = form.graph_type>
            <cfelse>
                <cfset graph_type = "bar">
            </cfif>
            <cfset my_height = ((3*20)+90)>
			 <cfchart show3d="yes" labelformat="number" format="jpg" chartheight="#my_height#" chartwidth="220"> 
				<cfchartseries type="#graph_type#" itemcolumn="deneme1"> 
                   	<cfchartdata item="Hedef" value="#get_shift.H_POINT#">
                    <cfchartdata item="Plan" value="#get_shift.T_POINT#">
                    <cfchartdata item="Gerçekleşen" value="#get_shift.G_POINT#">
				</cfchartseries>
			</cfchart> 
          </td>
        </tr>
      </table>