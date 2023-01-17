<cfquery name="IDCARDCATEGORIES" datasource="#dsn#">
	SELECT 
	    IDENTYCAT_ID, 
        IDENTYCAT, 
        RECORD_EMP, 
        RECORD_DATE,
        RECORD_IP, 
        UPDATE_EMP, 
        UPDATE_DATE, 
        UPDATE_IP 
    FROM 
    	SETUP_IDENTYCARD
</cfquery>		
<table width="200" cellpadding="0" cellspacing="0" border="0">
    <tr> 
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='122.Kimlik Kartı Kategorileri'></td>
    </tr>
    <cfif idCardCategories.recordcount>
		<cfoutput query="idCardCategories">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_id_card&ID=#identycat_id#" clasS="tableyazi">#IDENTYCAT#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="180"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>

