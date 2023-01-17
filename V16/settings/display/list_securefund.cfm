<cfquery name="GET_SECUREFUND" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_SECUREFUND
</cfquery>	
<table width="135" cellpadding="0" cellspacing="0" border="0">
    <tr> 
   	 <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='754.Teminat Kategorileri'></td>
    </tr>
	<cfif GET_SECUREFUND.RecordCount>
      <cfoutput query="GET_SECUREFUND">
          <tr>
              <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
              <td width="115"><a href="#request.self#?fuseaction=settings.form_upd_securefund&SECUREFUND_CAT_ID=#SECUREFUND_CAT_ID#" class="tableyazi">#SECUREFUND_CAT#</a></td>
          </tr>
      </cfoutput>
    <cfelse>
         <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="115"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
          </tr>
     </cfif>
</table>


