<cfquery name="IMS" datasource="#DSN#">
	SELECT 
	    IMCAT_ID, 
        IMCAT, 
        IMCAT_ICON, 
        IMCAT_LINK_TYPE, 
        RECORD_DATE, 
        RECORD_EMP, 
        UPDATE_DATE, 
        UPDATE_EMP
    FROM 
    	SETUP_IM
</cfquery>
<table>
    <cfif ims.recordcount>
		<cfoutput query="ims">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td width="380"><a href="#request.self#?fuseaction=settings.form_upd_im_cat&id=#imcat_id#" class="tableyazi">#imCat#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
        </tr>
    </cfif>
</table>
