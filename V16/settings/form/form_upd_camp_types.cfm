<cfquery name="GET_TYPE" datasource="#dsn3#">
	SELECT 
    	CAMP_TYPE_ID, 
        CAMP_TYPE, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	CAMPAIGN_TYPES 
    WHERE 
	    CAMP_TYPE_ID = #attributes.id#
</cfquery>
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0" >
    <tr>
        <td  class="headbold"><cf_get_lang no='918.Kampanya Kategorileri'></td>
        <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_camp_types"><img src="/images/plus1.gif" border="0" alt=<cf_get_lang_main no='170.Ekle'></a></td>
    </tr>
</table>
<table width="98%" border="0" cellpadding="2" cellspacing="1" class="color-border" align="center">
    <tr class="color-row">
        <td width="200" valign="top"><cfinclude template="../display/list_camp_type.cfm"></td>
        <td valign="top">
            <table>
                <cfform name="camp_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_camp_types">
                <input type="hidden" name="type_id" id="type_id" value="<cfoutput>#attributes.id#</cfoutput>">
                    <tr>
                        <td width="100"><cf_get_lang_main no='74.Kategori'> *</td>
                        <td><cfsavecontent variable="message"><cf_get_lang_main no='1143.Kategori girmelisiniz'></cfsavecontent>
                        	<cfinput type="Text" name="camp_type" size="20" value="#get_type.camp_type#" maxlength="100" required="Yes" message="#message#" style="width:150px;"></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td height="35"><cf_workcube_buttons is_upd='1' is_delete='0'></td>
                    </tr>
                    <tr>
                        <td colspan="3"><p><br/>
							<cfoutput>
								<cfif len(get_type.record_emp)>
                                	<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_type.record_emp,0,0)# - #dateformat(get_type.record_date,dateformat_style)#
                                </cfif><br/>
                                <cfif len(get_type.update_emp)>
                                	<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_type.update_emp,0,0)# - #dateformat(get_type.update_date,dateformat_style)#
                                </cfif>
                            </cfoutput>
                        </td>
                    </tr>
                </cfform>
            </table>
        </td>
    </tr>
</table>	

