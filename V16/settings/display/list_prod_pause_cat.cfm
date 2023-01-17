<cfquery name="get_prod_pause_cat" datasource="#dsn3#">
	SELECT 
	    PROD_PAUSE_CAT_ID, 
        #dsn#.Get_Dynamic_Language(PROD_PAUSE_CAT_ID,'#session.ep.language#','SETUP_PROD_PAUSE_CAT','PROD_PAUSE_CAT',NULL,NULL,PROD_PAUSE_CAT) AS PROD_PAUSE_CAT,  
        IS_ACTIVE, 
        IS_WORKING_TIME, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_PROD_PAUSE_CAT
</cfquery>
<table>
    <cfif get_prod_pause_cat.recordcount>
        <cfoutput query="get_prod_pause_cat">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td width="380"><a href="#request.self#?fuseaction=settings.form_add_prod_pause_cat&event=upd&id=#prod_pause_cat_id#" class="tableyazi">#prod_pause_cat#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
			<td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
    </tr>
</cfif>
</table>
