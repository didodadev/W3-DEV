<cfquery name="PRO_STAGE" datasource="#dsn3#">
	SELECT 
	    PRODUCT_STAGE_ID, 
        PRODUCT_STAGE, 
        PRODUCT_STAGE_DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	PRODUCT_STAGE
</cfquery>
<table width="200" cellpadding="0" cellspacing="0" border="0">
    <tr> 
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='181.Ürün Aşamaları'></td>
    </tr>
    <cfif PRO_STAGE.RecordCount>
		<cfoutput query="PRO_STAGE">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_pro_stage&type=upd&ID=#PRODUCT_STAGE_ID#" class="tableyazi">#PRODUCT_STAGE#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="180" align="left"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
