<cfquery name="GET_BROADCAST_CAT" datasource="#dsn#" maxrows="1">
	SELECT 
    	CAT_ID, 
        BROADCAST_CAT_NAME, 
        BROADCAST_CAT_DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
	    BROADCAST_CAT 
    WHERE 
    	CAT_ID = #attributes.id#
</cfquery>
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0" >
    <tr>
        <td class="headbold"><cf_get_lang no='562.Yayın Kategorisi'></td>
        <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_broadcast_cat"><img src="/images/plus1.gif" border="0" align="absmiddle" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
    </tr>
</table>
<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
    <tr class="color-row">
        <td width="200" valign="top"><cfinclude template="../display/list_broadcast_cat.cfm"></td>
        <td valign="top" >
            <table border="0">
                <cfform action="#request.self#?fuseaction=settings.emptypopup_upd_broadcast_cat" method="post" name="pro_work_cat">
                <input type="hidden" name="cat_id" id="cat_id" value="<cfoutput>#attributes.id#</cfoutput>">
                    <tr>
                        <td width="100"><cf_get_lang_main no='74.Kategori'><font color=black>*</font></td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang_main no='1143.Kategori girmelisiniz'></cfsavecontent>
                            <cfinput type="text" name="broadcast_cat" style="width:200px;" value="#get_broadcast_cat.broadcast_cat_name#" maxlength="30" required="Yes" message="#message#">
                        </td>
                    </tr>
                    <tr>
                        <td><cf_get_lang_main no='217.Açıklama'></td>
                        <td><textarea name="detail" id="detail" style="width:200px;"  cols="75"><cfoutput>#get_broadcast_cat.broadcast_cat_detail#</cfoutput></textarea></td>
                    </tr>
                    <tr height="35">
                        <td colspan="2" align="right" style="text-align:right;">
                        	<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_broadcast_cat&cat_id=#attributes.id#'>
                        </td>
                    </tr>
                    <tr>
                        <td align="left" colspan="2"><p><br/>
							<cfoutput>
								<cfif len(get_broadcast_cat.RECORD_EMP)>
                                	<cf_get_lang_main no='71.Kayit'> : #get_emp_info(get_broadcast_cat.RECORD_EMP,0,0)# - #dateformat(get_broadcast_cat.RECORD_DATE,dateformat_style)#
                                </cfif><br/>
                                <cfif len(get_broadcast_cat.UPDATE_EMP)>
                                	<cf_get_lang_main no='291.Son Gncelleme'> : #get_emp_info(get_broadcast_cat.UPDATE_EMP,0,0)# - #dateformat(get_broadcast_cat.UPDATE_DATE,dateformat_style)#
                                </cfif>
                            </cfoutput>
                        </td>
                    </tr>
                </cfform>
            </table>
        </td>
    </tr>
</table>
