<cfquery name="GET_SALES_ZONE" datasource="#dsn#">
SELECT	SZ_ID,SZ_NAME,RESPONSIBLE_PAR_ID FROM SALES_ZONES ORDER BY SZ_NAME
</cfquery>
<script type="text/javascript">
function gonder(sz_id,sz_name)
	{
	<cfoutput>
		<cfif isdefined("field_id")>
		opener.#field_id#.value = sz_id;
		</cfif>
		<cfif isdefined("field_name")>
		opener.#field_name#.value = sz_name;
		</cfif>
	</cfoutput>
	self.close();
	}
</script>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang dictionary_id='57767.Satış Bölgeleri'></td>
  </tr>
</table>
<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr height="22" class="color-header">
		<td class="form-title"><cf_get_lang dictionary_id='57487.No'></td>
          <td class="form-title"><cf_get_lang dictionary_id='55188.Bölgeler'></td>
		  <td class="form-title"><cf_get_lang dictionary_id='30613.Bölge Satış Sorumlusu'></td>
        </tr>
        <cfif get_sales_zone.recordcount>
          <cfoutput query="get_sales_zone">
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
			  <td>#currentrow#</td>
              <td><a href="javascript://" class="tableyazi" onClick="gonder(#sz_id#,'#sz_name#')">#sz_name#</a></td>
			  <td>#get_emp_info(RESPONSIBLE_PAR_ID,1,0)#</td>
            </tr>
          </cfoutput>
          <cfelse>
          <tr class="color-row">
            <td colspan="2" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>

