<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_workgroup_inf.cfm">
<table align="center" width="100%" cellpadding="2" cellspacing="1" border="0">
	  <tr>
		<td valign="top">
        <cfoutput query="GET_WORKGROUPS">
         <table width="98%" align="center" cellpadding="2" cellspacing="2">
            <tr>
                <td width="30"><img src="#file_web_path#objects2/image/tavsiye.gif"  border="0"></td>
                <td class="formbold" height="25">#WORKGROUP_NAME#</td>
            </tr>
			<tr>
				<td></td>
				<td><div id="SHOW_UPD_MESSAGE"></div></td>
			</tr>
            <tr>
                <td></td>
                <td><a href="javascript://"onClick="gizle_goster(my_workgroup#WORKGROUP_ID#);"><img src="#file_web_path#objects2/image/ok.gif" border="0" title="<cf_get_lang no ='1140.Not Bırak'>" align="absmiddle">&nbsp;&nbsp;<cf_get_lang no ='1344.İletişime Geçmek İçin Tıklayınız'>.</a></td>
            </tr>
			<tr style="display:none;" id="my_workgroup#WORKGROUP_ID#">
				<td></td>
				<td>
					<cfinclude template="add_information_workgroup_not.cfm">
				</td>
			  </tr>
          </table>
        </cfoutput>
        </td>
      </tr>
</table>

