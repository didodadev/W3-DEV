<cfquery name="CAMP_CATS" datasource="#dsn3#">
	SELECT 
    	CAMP_CAT_ID, 
        CAMP_CAT_NAME, 
        CAMP_TYPE, 
        RECORD_DATE, 
        RECORD_EMP,
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
	    CAMPAIGN_CATS 
    ORDER BY 
    	CAMP_CAT_NAME
</cfquery>
<div class="scrollContent scroll-x3">
    <table>
        <cfif camp_cats.recordcount>
            <cfoutput query="camp_cats">
                <tr>
                    <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                    <td width="380"><a href="#request.self#?fuseaction=settings.form_upd_camp_cat&ID=#camp_cat_ID#" class="tableyazi">#camp_Cat_name#</a></td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
            </tr>
        </cfif>
    </table>
</div>
