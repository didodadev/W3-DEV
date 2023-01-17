<cfquery name="GET_SERVICE_SUPPORT_CAT_ID" datasource="#DSN3#" maxrows="1">
	SELECT
		SUPPORT_CAT_ID
	FROM
		SERVICE_SUPPORT
	WHERE
		SUPPORT_CAT_ID=#URL.ID#
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
    <tr>
        <td class="headbold"><cf_get_lang no='644.Destek Kategorisi Güncelle'></td>
        <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_service_support_cat"><img src="/images/plus1.gif" border="0" align="absmiddle" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
    </tr>
</table>
<table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
    <tr class="color-row" valign="top">
        <td width="200"><cfinclude template="../display/list_service_support_cat.cfm"></td>
        <td>
            <table border="0">
                <cfform name="service_upd_support" method="post" action="#request.self#?fuseaction=settings.emptypopup_service_support_cat_upd">
                    <cfquery name="CATEGORY" datasource="#dsn#">
                        SELECT 
        	                SUPPORT_CAT_ID, 
                            SUPPORT_CAT, 
                            RECORD_DATE, 
                            RECORD_EMP, 
                            RECORD_IP, 
                            UPDATE_DATE, 
                            UPDATE_EMP, 
                            UPDATE_IP 
                        FROM 
    	                    SETUP_SUPPORT 
                        WHERE 
	                        SUPPORT_CAT_ID=#URL.ID#
                    </cfquery>
                    <input type="Hidden" name="SUPPORT_CAT_ID" id="SUPPORT_CAT_ID" value="<cfoutput>#URL.ID#</cfoutput>">
                    <tr>
                        <td width="100"><cf_get_lang_main no='68.Başlık'>*</td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
                            <cfinput type="Text" name="SUPPORT_CAT" style="width:150px;" value="#category.SUPPORT_CAT#" maxlength="50" required="Yes" message="#message#">
                        </td>
                    </tr>
                    <tr height="35">
                        <td colspan="2" align="right" style="text-align:right;">
							<cfif get_service_support_cat_id.recordcount>
                                <cf_workcube_buttons is_upd='1' is_delete='0'>
                            <cfelse>
                                <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_service_support_cat_del&support_cat_id=#URL.ID#'>
                            </cfif>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3" align="left"><p><br/>
                            <cfoutput>
                                <cfif len(category.record_emp)>
                                    <cf_get_lang_main no='71.Kayıt'> : #get_emp_info(category.record_emp,0,0)# - #dateformat(category.record_date,dateformat_style)#
                                </cfif><br/>
                                <cfif len(category.update_emp)>
                                    <cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(category.update_emp,0,0)# - #dateformat(category.update_date,dateformat_style)#
                                </cfif>
                            </cfoutput>
                        </td>
                    </tr>
                </cfform>
            </table>
        </td>
    </tr>
</table>
