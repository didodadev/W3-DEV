<cfparam name="attributes.system_company_id" default="#SESSION.EP.COMPANY_ID#">
<cfinclude template="../query/get_stores.cfm">
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td class="headbold"><cf_get_lang dictionary_id='32766.Depolar'></td>
  </tr>
</table>

<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr class="color-border">
    <td>
	<table width="100%" border="0" cellspacing="1" cellpadding="2">
        <cfif not isdefined("attributes.field_id")>
	    <tr> 
          <td>
		 
	<font color="#ff0000"><strong><cf_get_lang dictionary_id='32762.HATA FIELD_ID VE FIELD_NAME DEĞİŞKENLERİ TANIMLI DEĞİL'><br/>
	</strong></font>
	<cfabort>
		  </td>
        </tr>
		</cfif>
		<cftry>

<script type="text/javascript">
	function add_store(in_coming_id, in_coming_name)
	{
		opener.document.<cfoutput>#attributes.field_id#</cfoutput>.value = in_coming_id;
		opener.document.<cfoutput>#attributes.field_name#</cfoutput>.value = in_coming_name;
		window.close();
	}
</script>		
        <tr height="22" class="color-header"> 
          <td width="100" class="form-title"><cf_get_lang dictionary_id='58763.Depo Adı'></td>
        </tr>
       <cfoutput query="get_stores">
	   <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
          <td><a href="javascript://" onClick="add_store('#department_id#','#DEPARTMENT_HEAD#')" class="tableyazi">#DEPARTMENT_HEAD#</a></td>
        </tr>
		</cfoutput>
		<cfcatch>
		<tr height="20" class="color-row">
		<td><font color="##ff0000"><strong><cf_get_lang dictionary_id='29917.HATA OLUŞTU'> ..</strong></font></td>
		</tr>
		</cfcatch>
      </table>

	</td>
  </tr>
</table>
</cftry>

