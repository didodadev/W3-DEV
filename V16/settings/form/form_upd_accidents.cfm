<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
    <tr>
        <td class="headbold"><cf_get_lang no='884.Kaza Tipleri'></td>
        <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_accidents"><img src="/images/plus1.gif" border="0" align="absmiddle" alt=<cf_get_lang_main no='170.Ekle'>></a></td>
    </tr>
</table>
<cfquery name="get_accS" datasource="#dsn#"> 
	SELECT
		*
	FROM 
		SETUP_ACCIDENT_TYPE
	WHERE
		ACCIDENT_TYPE_ID = #attributes.accident_type_id#
</cfquery>
<table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
    <cfform name="content_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_accident">
    <input name="accs_id" id="accs_id" type="hidden" value="<cfoutput>#get_accs.accident_type_id#</cfoutput>">
        <tr class="color-row" valign="top">
            <td width="218"><cfinclude template="../display/list_accidents.cfm">
            </td>
            <td width="862">
                <table border="0">
                    <tr>
                        <td width="52"><cf_get_lang no='1149.Kaza Tipi'> *</td>
                        <td width="452"><cfsavecontent variable="message"><cf_get_lang no='1150.Kaza Tipi Girişi Yapmalısınız!'></cfsavecontent>
                        <cfinput type="Text" name="accs_name" style="width:150px;" value="#trim(get_accs.ACCIDENT_TYPE_NAME)#" maxlength="50" required="Yes" message="#message#">
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td><cf_workcube_buttons is_upd='1' is_delete='0'></td>
                    </tr>
                    <tr>
                        <td colspan="3"><p><br/>
                            <cfoutput>
                                <cfif len(get_accS.record_emp)>
                                    <cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_accS.record_emp,0,0)# - #dateformat(get_accS.record_date,dateformat_style)#
                                </cfif><br/>
                                <cfif len(get_accS.update_emp)>
                                    <cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_accS.update_emp,0,0)# - #dateformat(get_accS.update_date,dateformat_style)#
                                </cfif>
                            </cfoutput>
                        </td>
                    </tr>
                </cfform>
            </table>
        </td>
    </tr>
</table>
