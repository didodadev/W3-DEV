<cfquery name="DRIVERLICENCECATEGORIES" datasource="#dsn#">
	SELECT 
    	LICENCECAT_ID, 
        LICENCECAT, 
        RECORD_EMP, 
        RECORD_IP, 
        RECORD_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        UPDATE_DATE, 
        IS_LAST_YEAR_CONTROL, 
        USAGE_YEAR 
    FROM 
	    SETUP_DRIVERLICENCE 
    ORDER BY 
    	LICENCECAT
</cfquery>
<table width="200" cellpadding="0" cellspacing="0" border="0">
    <tr valign="top"> 
        <td class="txtbold" height="20" colspan="2" valign="top" >&nbsp;&nbsp;<cf_get_lang no='154.Sürücü Belgesi Kategorisi'></td>
    </tr>
    <cfif driverLicenceCategories.recordcount>
		<cfoutput query="driverLicenceCategories">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_driver_licence&ID=#LICENCECAT_ID#" class="tableyazi">#LICENCECAT#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="180"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
