<cfquery name="GET_ORDER_ROWS" datasource="#dsn3#">
	SELECT 
		* 
	FROM 
		ORDER_ROW
	WHERE 
		ORDER_ID = #attributes.ORDER_ID# 
	AND	
		STOCK_ID=#attributes.STOCK_ID#
</cfquery>
<table width="98%" border="0" cellspacing="0" cellpadding="0">
  <tr class="color-border">
    <td>
      <table border="0" cellspacing="1" cellpadding="2" width="100%">
        <tr class="color-header" height="22">
          <td class="form-title"  colspan="2"><cf_get_lang dictionary_id='36588.Asorti'></td>
        </tr>
        <cfif GET_ORDER_ROWS.RECORDCOUNT >
          <cfoutput query="GET_ORDER_ROWS">
            <tr>
              <td class="color-row" width="65"><cf_get_lang dictionary_id='36589.Beden'></td>
              <td class="color-row">#PARSE1#</td>
            </tr>
            <tr>
              <td class="color-row"><cf_get_lang dictionary_id='36554.Renk'></td>
              <td class="color-row">#PARSE2#</td>
            </tr>
          </cfoutput>
          <cfelse>
          <tr>
            <td class="color-row" colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>

