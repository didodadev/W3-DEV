<cfquery name="TARGET_CATS" datasource="#dsn#">
	SELECT 
	    TARGETCAT_ID, 
        TARGETCAT_NAME, 
        DETAIL, 
        TARGETCAT_WEIGHT, 
        RECORD_DATE, 
        RECORD_EMP,
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP
    FROM 
    	TARGET_CAT
</cfquery>
<table cellpadding="0" cellspacing="0" border="0">
    <tr> 
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='169.Hedef Kategorileri'></td>
    </tr>
    <cfif target_cats.recordcount>
		<cfoutput query="target_cats">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td><a href="#request.self#?fuseaction=settings.form_upd_target_cat&targetcat_ID=#targetcat_ID#" class="tableyazi">#targetcat_name#</a></td>
            </tr>
        </cfoutput>
        <cfelse>
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
            </tr>
    </cfif>
</table>
