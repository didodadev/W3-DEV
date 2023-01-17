<cfquery name="GUARANTYCATS" datasource="#dsn#">
    SELECT 
	    CURRENCY, 
        GUARANTYCAT_ID, 
        #dsn#.Get_Dynamic_Language(GUARANTYCAT_ID,'#session.ep.language#','SETUP_GUARANTY','GUARANTYCAT',NULL,NULL,GUARANTYCAT) AS GUARANTYCAT, 
        GUARANTYCAT_TIME, 
        MAX_GUARANTYCAT_TIME, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_GUARANTY
</cfquery>
<table width="200" cellpadding="0" cellspacing="0" border="0">
    <cfif guarantyCats.recordcount>
		<cfoutput query="guarantyCats">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td width="150">&nbsp;<a href="#request.self#?fuseaction=settings.form_upd_guaranty_cat&ID=#guarantyCat_ID#" >#guarantyCat#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
        </tr>
    </cfif>
</table>
