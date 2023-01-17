<cfquery name="TRAINING_CATS" datasource="#dsn#">
	SELECT 
        TRAINING_CAT_ID,
        TRAINING_CAT, 
        DETAIL, 
        TRAINING_LANGUAGE, 
        RECORD_DATE,
        RECORD_EMP,
        RECORD_IP,
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	TRAINING_CAT
</cfquery>
<table width="200" cellpadding="0" cellspacing="0" border="0">
    <tr> 
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='536.Eğitim Üst Kategorileri'></td>
    </tr>
	<cfif training_cats.recordcount>
		<cfoutput query="training_cats">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="115">
					<cfif listfirst(url.fuseaction,'.') is 'training_management'>
                        <a href="#request.self#?fuseaction=settings.form_upd_training_cat&ID=#training_cat_id#" class="tableyazi">#training_cat#</a>
                    <cfelse>
                        <a href="#request.self#?fuseaction=settings.form_upd_training_cat&ID=#training_cat_id#" class="tableyazi">#training_cat#</a>
                    </cfif>
                </td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
