<cfquery name="get_site" datasource="#dsn#">
	SELECT 
	    LAYOUT_ID, 
        FACTION, 
        LEFT_WIDTH, 
        RIGHT_WIDTH,
        CENTER_WIDTH, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP, 
        UPDATE_EMP, 
        UPDATE_IP, 
        UPDATE_DATE
    FROM 
    	MAIN_SITE_LAYOUTS 
    WHERE 
	    LAYOUT_ID = #ATTRIBUTES.LAYOUT_ID#
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="100%">
  <tr>
    <td class="headbold" height="35"><cf_get_lang no='1421.Site Tasarımcısı'</td>
    </td>
  </tr>
<cfform action="#request.self#?fuseaction=settings.emptypopup_upd_site_layout" method="post" name="user_group"> 
<input type="hidden" name="layout_id" id="layout_id" value="<cfoutput>#attributes.layout_id#</cfoutput>">
  <tr>
    <td class="color-border">
      <table border="0" cellspacing="1" cellpadding="2" width="100%" height="100%">
        <tr class="color-row" valign="top">
          <td height="50" colspan="2">
			  <table>
                  <tr>
                    <td><cf_get_lang no='81.Aktif'></td>
                    <td width="130"><input name="is_active" id="is_active" type="checkbox" value="1" <cfif get_site.is_active>checked</cfif>></td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                  </tr>
                  <tr>
                    <td><cf_get_lang no='1457.Tasarım Adı'></td>
                    <td colspan="3">
                    <cfsavecontent variable="message"><cf_get_lang no='1458.Tasarım Adı Girmelisiniz'></cfsavecontent>
                    <cfinput type="text" name="layout_name" value="#get_site.layout_name#" style="width:150px;" required="yes" message="#message#" maxlength="100"></td>
                  </tr>
                  <tr>
				  	<td>&nbsp;</td>
					<td colspan="3" class="txtboldblue"><cf_get_lang no='2648.Kolon Genişlikleri'></td>
				  </tr>
				  <tr>
				  	<td><cf_get_lang no='2649.Sol * Orta * Sağ'></td>
					<td colspan="3">
						<cfsavecontent variable="message"><cf_get_lang no='2650.Sol Ölçü Sayısal Olmalıdır'></cfsavecontent>
						<cfinput type="text" name="left_width" value="#get_site.left_width#" validate="integer" style="width:50px;" message="#message#">
                        <cfsavecontent variable="message"><cf_get_lang no='2651.Orta Ölçü Sayısal Olmalıdır'></cfsavecontent>
						<cfinput type="text" name="center_width" value="#get_site.center_width#" validate="integer" style="width:50px;" message="#message#">
						<cfsavecontent variable="message"><cf_get_lang no='2652.Sağ Ölçü Sayısal Olmalıdır'></cfsavecontent>
                        <cfinput type="text" name="right_width" value="#get_site.right_width#" validate="integer" style="width:50px;" message="#message#">
					</td>
				  </tr>
				  <tr>
                    <td height="35" colspan="4" align="right" style="text-align:right;"><cf_workcube_buttons is_upd='0'></td>
                  </tr>
              </table>			
		</td>
		</tr>
		<tr class="color-row">
			<td width="200" nowrap>
			<cfset faction_list = "welcome,list_product,product_category,detail_product,list_service,list_return,detail_service,view_product_list">
			<div id="factions" style="position:absolute;width:100%;height:98%; z-index:88;overflow:auto;">
				<table>
					<tr>
						<td class="formbold"><cf_get_lang no='159.Fuseactions'></td>
					</tr>
					<cfloop list="#faction_list#" index="mlk">
					<cfoutput>
					<tr>
						<td><li><a href="#request.self#?fuseaction=settings.popup_select_site_objects&faction=#mlk#&layout_id=#attributes.layout_id#&iframe=1" class="tableyazi" target="ic_site">#mlk#</a></li></td>
					</tr>
					</cfoutput>
					</cfloop>
				</table>
			</div>
			</td>
			<td width="100%">
				<cfoutput><iframe src="#request.self#?fuseaction=settings.popup_select_site_objects&iframe=1" width="100%" height="100%" frameborder="0" name="ic_site" id="ic_site"></iframe></cfoutput>
			</td>
		</tr>
		</table>
</td>
</tr>
</cfform>
</table>			    

