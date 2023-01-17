<cfquery name="GET_EMP_DETAIL" datasource="#DSN#" maxrows="1">
	SELECT 
    	PDKS_TYPE_ID
    FROM 
        EMPLOYEES_IN_OUT 
    WHERE 
    	PDKS_TYPE_ID = #URL.ID#
</cfquery>
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0" >
    <tr>
        <td  class="headbold"><cf_get_lang_main no='1692.PDKS Tipi'></td>
        <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_pdks_type"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
    </tr>
</table>
<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
    <tr class="color-row">
        <td width="200" valign="top">
            <cfquery name="GETCOMPUTERINFO" datasource="#dsn#">
                SELECT 
    	            PDKS_TYPE_ID, 
                    PDKS_TYPE, 
                    PDKS_TYPE_DETAIL, 
                    RECORD_DATE, 
                    RECORD_EMP, 
                    RECORD_IP, 
                    UPDATE_DATE, 
                    UPDATE_EMP, 
                    UPDATE_IP 
                FROM 
	                SETUP_PDKS_TYPES
            </cfquery>
            <table width="200" cellpadding="0" cellspacing="0" border="0">
                <tr> 
                    <td valign="top" class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang_main no='1692.PDKS Tipi'></td>
                </tr>
                <cfif GETCOMPUTERINFO.recordcount>
                    <cfoutput query="GETCOMPUTERINFO">
                        <tr>
                            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                            <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_pdks_type&ID=#pdks_type_id#" class="tableyazi">#pdks_type#</a></td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                        <td width="180"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
                    </tr>
                </cfif>
            </table>
        </td>
        <td valign="top">
            <table>
                <cfform action="#request.self#?fuseaction=settings.emptypopup_upd_pdks_type" method="post" name="computer_info">
                    <cfquery name="CATEGORY" datasource="#dsn#">
                        SELECT 
                            * 
                        FROM 
                            SETUP_PDKS_TYPES
                        WHERE 
                            PDKS_TYPE_ID = #URL.ID#
                    </cfquery>
                    <input type="Hidden" name="PDKS_TYPE_ID" id="PDKS_TYPE_ID" value="<cfoutput>#URL.ID#</cfoutput>">
                    <tr>
                        <td width="100"><cf_get_lang_main no='1692.PDKS Tipi'> *</td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang no='1755.Tip Girmelisiniz'>!</cfsavecontent>
                            <cfinput type="Text" name="pdks_type" size="30" value="#category.pdks_type#" maxlength="50" required="Yes" message="#message#" style="width:200px;">
                        </td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang no='26.Ayrıntı'></td>
                        <td>
                            <Textarea name="pdks_type_detail" id="pdks_type_detail" cols="60" rows="2" style="width:200px;height:50px;"><cfoutput>#category.pdks_type_detail#</cfoutput></TEXTAREA>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td height="35"> 
                            <cfif get_emp_detail.recordcount>
                                <cf_workcube_buttons is_upd='1' is_delete='0'>                  
                            <cfelse>
                                <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_pdks_type&pdks_type_id=#URL.ID#'>
                            </cfif>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2"><cf_get_lang_main no='71.Kayıt'> :
                            <cfoutput>
                                <cfif len(category.record_emp)>#get_emp_info(category.record_emp,0,0)#</cfif>
                                <cfif len(category.record_date)>#dateformat(category.record_date,'dd/mm/yyyyy')#</cfif>
                                <cfif len(category.update_emp)>
                                    <br/>
                                    <cf_get_lang_main no='479.Guncelleyen'> :
                                    #get_emp_info(category.update_emp,0,0)#
                                    #dateformat(category.update_date,'dd/mm/yyyyy')#
                                </cfif>
                            </cfoutput>
                        </td>
                    </tr>
                </cfform>
            </table>
        </td>
    </tr>
</table>
