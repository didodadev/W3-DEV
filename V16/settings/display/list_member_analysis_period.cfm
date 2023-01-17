<cfquery name="get_member_analysis_period" datasource="#dsn#">
	SELECT 
	    TERM_ID, 
        TERM, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_MEMBER_ANALYSIS_TERM
</cfquery>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
    <cfif get_member_analysis_period.recordcount>
    	<cfoutput query="get_member_analysis_period">
        	<tr>
            	<td width="20" align="right" valign="baseline"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td width="380"><a href="#request.self#?fuseaction=settings.form_upd_member_analysis_period&id=#term_id#" class="tableyazi">#term#</a></td>
            </tr>
        </cfoutput>
   	<cfelse>
    	<tr>
        	<td width="20" align="right" valign="baseline"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="380"><font class="tableyazi"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
