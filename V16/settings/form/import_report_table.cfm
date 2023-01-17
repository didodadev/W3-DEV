<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td class="headbold"><cf_get_lang no='791.Rapor Tablosu Aktar'></td>
  </tr>
</table>
<table width="98%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
    <tr class="color-row">
        <td>
            <table border="0">
                <form method="POST" enctype="multipart/form-data" action="<cfoutput>#request.self#?fuseaction=settings.emptypopup_import_report_from_xml</cfoutput>" name="hlp_dsk">
                    <tr>
                        <td><cf_get_lang no='283.Döküman'>*</td>
                        <td>
                        	<input type="FILE" style="width:250px;" name="asset" id="asset">
                        </td>
                    </tr>
                    <tr>
                    	<td align="right" height="35" class="headbig" colspan="2"><cf_workcube_buttons is_upd='0'></td>
                    </tr>
                </form>
            </table>
        </td>
    </tr>
</table>
