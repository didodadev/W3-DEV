<cfquery name="GET_BASKET_INFO_TYPES" datasource="#dsn3#">
	SELECT 
	    BASKET_INFO_TYPE_ID, 
        BASKET_INFO_TYPE,
        OPTION_NUMBER, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        BASKET_ID 
    FROM 
    	SETUP_BASKET_INFO_TYPES
    ORDER BY
    	BASKET_INFO_TYPE ASC
</cfquery>
<table cellpadding="0" cellspacing="0" border="0">
    <cfif get_basket_info_types.recordcount>
		<cfoutput query="get_basket_info_types">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td>&nbsp;<a href="#request.self#?fuseaction=settings.upd_basket_info_type&info_type_id=#basket_info_type_id#">#basket_info_type#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>        </tr>
    </cfif>
</table>
