<cfquery name="GET_PERFORM_CAT" datasource="#dsn#">
	SELECT 
    	PERFORM_CAT_ID, 
        PERFORM_CAT, 
        RECORD_EMP, 
        RECORD_IP, 
        RECORD_DATE, 
        UPDATE_EMP, 
        UPDATE_IP,
        UPDATE_DATE 
    FROM 
    	SETUP_PERFORM_CATS 
    WHERE 
	    PERFORM_CAT_ID = #ATTRIBUTES.PERFORM_CAT_ID#
</cfquery>
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0" >
    <tr>
        <td  class="headbold"><cf_get_lang no='1103.Performans Kategorisi'></td>
        <td align="right" style="text-align:right;">
        	<a href="<cfoutput>#request.self#?fuseaction=settings.form_add_perform_cat</cfoutput>"><img border="0" src="images/plus1.gif" alt=<cf_get_lang_main no='170.Ekle'>></a>
        </td>
    </tr>
</table>
<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
    <tr class="color-row">
        <td width="200" valign="top"><cfinclude template="../display/list_perform_cats.cfm"></td>
        <td valign="top">
            <table>
                <cfform name="add_edu_level" action="#request.self#?fuseaction=settings.emptypopup_upd_perform_cat">
                <input type="hidden" name="perform_cat_id" id="perform_cat_id" value="<cfoutput>#attributes.perform_cat_id#</cfoutput>">
                    <tr>
                        <td width="100"><cf_get_lang no='20.Kategori Adı'>*</td>
                        <td>
                        	<cfinput type="Text" name="perform_cat" size="60" value="#GET_PERFORM_CAT.PERFORM_CAT#" maxlength="100" required="Yes" message="Kategori Adı Girmelisiniz!" style="width:150px;">
                        </td>
                    </tr>
                    <tr>
                    	<td align="right" height="35" colspan="2"><cf_workcube_buttons is_upd='1' is_delete='0'></td>
                    </tr>
                    <tr>
                        <td colspan="3"><p><br/>
							<cfoutput>
								<cfif len(get_perform_cat.record_emp)>
                                	<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_perform_cat.record_emp,0,0)# - #dateformat(get_perform_cat.record_date,dateformat_style)#
                                </cfif><br/>
                                <cfif len(get_perform_cat.update_emp)>
                                	<cf_get_lang_main no='479.Güncelleyen'> : #get_emp_info(get_perform_cat.update_emp,0,0)# - #dateformat(get_perform_cat.update_date,dateformat_style)#
                                </cfif>
							</cfoutput>
                        </td>
                    </tr>
                </cfform>
            </table>
        </td>
    </tr>
</table>	
