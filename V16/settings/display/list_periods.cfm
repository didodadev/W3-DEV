<cfinclude template="../query/get_periods.cfm">
<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<cfif periods.RecordCount>
		<cfoutput query="PERIODS" group="OUR_COMPANY_ID">	
            <tr> 
                <td class="txtbold" height="20" colspan="2"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></img><a href="javascript://" onclick="show_periods(#OUR_COMPANY_ID#);">#COMPANY_NAME#</a></td>
            </tr>
            <tr>
                <td>
                    <table id="#OUR_COMPANY_ID#" style="display:<cfif OUR_COMPANY_ID neq session.ep.COMPANY_ID>none<cfelse></cfif>;">
                    <cfoutput>
                        <tr>
                            <td width="20" align="right" valign="baseline"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                            <td width="380"><a href="#request.self#?fuseaction=settings.form_upd_period&period_id=#period_ID#" class="tableyazi">#PERIOD#</a></td>
                        </tr>
                    </cfoutput>
                    </table>
               </td>	 
            </tr>
        </cfoutput>
	<cfelse>
        <tr> 
            <td class="txtbold" height="20" colspan="2"><cf_get_lang dictionary_id='42172.Muhasebe Dönemleri'></td>
        </tr>
    	<tr>
			<td width="20" align="right" valign="baseline"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
			<td width="380"><font class="tableyazi"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</font></td>
		</tr>
    </cfif>
</table>
<script type="text/javascript">
function show_periods(comp_id)
{
	if(document.getElementById(comp_id).style.display == 'none')
		document.getElementById(comp_id).style.display='';
	else
		document.getElementById(comp_id).style.display = 'none';
}
</script>
