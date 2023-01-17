<cfquery name="GET_STAGE" datasource="#dsn#">
	SELECT 
    	ACTIVITY_TYPE_ID, 
        ACTIVITY_TYPE, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        UPDATE_DATE, 
        UPDATE_EMP
    FROM 
    	SETUP_ACTIVITY_TYPES 
    WHERE 
	    ACTIVITY_TYPE_ID = #attributes.activity_type_id#
</cfquery>
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0" >
    <tr>
        <td  class="headbold"><cf_get_lang no='934.Etkinlik Kategorileri'></td>
        <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_activity_type"><img src="/images/plus1.gif" border="0"></a></td>
    </tr>
</table>
<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
    <tr class="color-row">
        <td width="200" valign="top"><cfinclude template="../display/list_activity_type.cfm"></td>
        <td valign="top" >
            <table border="0">
                <cfform action="#request.self#?fuseaction=settings.emptypopup_upd_activity_type" method="post" name="pro_stage">
                <input type="hidden" name="activity_type_id" id="activity_type_id" value="<cfoutput>#attributes.activity_type_id#</cfoutput>">
                    <tr>
                        <td width="100"><cf_get_lang_main no='74.Kategori'><font color=black>*</font></td>
                        <td><cfsavecontent variable="message"><cf_get_lang no ='1187.Kategori Girmelisiniz '>!</cfsavecontent>
                        <cfinput type="Text" name="activity_type" style="width:200px;" value="#get_stage.activity_type#" maxlength="50" required="Yes" message="#message#"></td>
                    </tr>
                    <tr>
                        <td><cf_get_lang_main no='217.Açıklama'></td>
                        <td><textarea name="detail" id="detail" style="width:200px;" value=""><cfoutput>#get_stage.detail#</cfoutput></textarea></td>
                    </tr>
                    <tr height="35">
                        <td>&nbsp;</td>
                        <td><cf_workcube_buttons is_upd='1' is_delete='0'></td>
                    </tr>
                    <tr>
                        <td align="left" colspan="2">
							<cfoutput>
								<cfif len(get_stage.record_emp)>
                                	<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_stage.record_emp,0,0)# - #dateformat(get_stage.record_date,dateformat_style)#
                                </cfif><br/>
                                <cfif len(get_stage.update_emp)>
                                	<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_stage.update_emp,0,0)# - #dateformat(get_stage.update_date,dateformat_style)#
                                </cfif>
                            </cfoutput>
                        </td>
                    </tr>
                </cfform>
            </table>
        </td>
    </tr>
</table>
