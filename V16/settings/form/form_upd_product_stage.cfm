<cfquery name="GET_PRODUCT_STAGE_ID" datasource="#DSN3#" maxrows="1">
	SELECT
		PRODUCT_STAGE
	FROM
		PRODUCT
	WHERE
		PRODUCT_STAGE=#URL.ID#
</cfquery>
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0" >
  <tr>
    <td  class="headbold"><cf_get_lang no='591.Ürün Aşaması Güncelle'></td>
    <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_pro_stage"><img src="/images/plus1.gif" border="0" align="absmiddle" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
  </tr>
</table>
<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
<tr class="color-row">
  <td width="200" valign="top">
    <cfinclude template="../display/list_pro_stage.cfm">
  </td>
  <td valign="top" >
    <table border="0">
      <cfform name="pro_stage" method="post" action="#request.self#?fuseaction=settings.emptypopup_pro_stage_upd">
        <cfquery name="CATEGORY" datasource="#dsn3#">
             SELECT
                 * 
             FROM 
                 PRODUCT_STAGE 
             WHERE 
                  PRODUCT_STAGE_ID=#URL.ID#
        </cfquery>
        <input type="Hidden" name="PRODUCT_STAGE_ID" id="PRODUCT_STAGE_ID" value="<cfoutput>#URL.ID#</cfoutput>">
        <tr>
          <td width="100"><cf_get_lang no='494.Aşama Tipi'><font color=black>*</font></td>
          <td>
          <cfsavecontent variable="message"><cf_get_lang no='19.Aşama Tipi girmelisiniz'></cfsavecontent>
          <cfinput type="Text" name="product_stage" style="width:200px;" value="#category.PRODUCT_STAGE#" maxlength="50" required="Yes" message="#message#">
          </td>
        </tr>
        <tr>
          <td><cf_get_lang_main no='217.Açıklama'></td>
          <td>
            <textarea name="DETAIL" id="DETAIL" style="width:200px;"  cols="75"><cfoutput>#category.PRODUCT_STAGE_DETAIL#</cfoutput></textarea>
          </td>
        </tr>
        <tr height="35">
          <td colspan="2" align="right" style="text-align:right;">
            <cfif get_product_stage_id.recordcount>
                <cf_workcube_buttons is_upd='1' is_delete='0'>
            <cfelse>
                <cf_workcube_buttons is_upd='1'  delete_page_url='#request.self#?fuseaction=settings.emptypopup_pro_stage_del&PRODUCT_STAGE_ID=#URL.ID#'>
            </cfif>
          </td>
        </tr>
        <tr>
            <td align="left" colspan="2"><p><br/>
            <cfoutput>
            <cfif len(category.record_emp)>
                <cf_get_lang_main no='71.Kayıt'> : #get_emp_info(category.record_emp,0,0)# - #dateformat(category.record_date,dateformat_style)#
            </cfif><br/>
            <cfif len(category.update_emp)>
                <cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(category.update_emp,0,0)# - #dateformat(category.update_date,dateformat_style)#
            </cfif>
            </cfoutput>
            </td>
        </tr>
      </cfform>
    </table>
  </td>
</tr>
</table>
