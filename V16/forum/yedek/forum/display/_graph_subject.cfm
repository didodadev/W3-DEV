<cfinclude template="../query/get_forum_subjects.cfm">
<table border="0" cellpadding="0" cellspacing="0" width="300" height="295">
  <tr class="color-border">
    <td width="100%" valign="top">
      <table border="0" width="100%" cellpadding="2" cellspacing="1" height="295">
        <tr class="color-header">
          <td>
            <table border="0" width="100%" cellpadding="0" cellspacing="0">
              <cfform name="graph" method="post" action="#request.self#?fuseaction=forum.popup_graph_subject">
                <tr class="color-header">
                  <td class="form-title"><cf_get_lang no='58.Konu Sayısına Göre Forumlar'></td>
                  <td align="right" style="text-align:right;">
                    <select name="graph_type" style="width:100px;">
                      <option value="" selected><cf_get_lang_main no='538.Grafik Format'></option>
                      <option value="pie"><cf_get_lang_main no='1316.Pasta'></option>
                      <option value="line"><cf_get_lang_main no='253.Eğri'></option>
                      <option value="bar"><cf_get_lang_main no='251.Bar'></option>
                    </select>
                  </td>
                  <td width="30" align="right" style="text-align:right;"><cf_wrk_search_button>
                  </td>
                </tr>
              </cfform>
            </table>
          </td>
        </tr>
        <tr>
          <cfif isDefined("form.graph_type") and  len(form.graph_type)>
            <cfset graph_type=form.graph_type>
            <cfelse>
            <cfset graph_type="pie">
          </cfif>
          <td bgcolor="#FFFFFF" align="center" valign="top" width="100%">
            <cfset colorlist="d099ff,6666cc,33cc33,cc6600,ff6600,ffcc00,ff66ff,999933,cccc99,996699,339999,ccff66,ccccff,6699ff">
            <cfchart
			 	 format="jpg" 
				show3D="yes"
				showlegend="yes"
				xaxistitle="Forum"
				yaxistitle="Konu Sayısı"
				tipBGColor="0099FF"
				font="arial"
				pieslicestyle="solid">
            <cfchartseries 
			  		type="#graph_type#"
					query="get_forum_subjects"
					valuecolumn="SUB_NUMBER"
					itemcolumn="FORUMNAME"
					serieslabel="Forum Sayıları"
					colorlist="#colorlist#"
					paintstyle="raise"/>
            </cfchart>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

