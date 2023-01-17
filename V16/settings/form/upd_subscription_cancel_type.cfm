<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
    <tr>
        <td class="headbold"><cf_get_lang no='1352.Abonelik Iptal Kategorisi Güncelle'></td>
        <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.add_subscription_cancel_type"><img src="/images/plus1.gif" border="0" align="absmiddle" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
    </tr>
</table>
<cfquery name="GET_SUBSCRIPTION_CANCEL_TYPE" datasource="#DSN3#">
	SELECT 
	    SUBSCRIPTION_CANCEL_TYPE_ID, 
        SUBSCRIPTION_CANCEL_TYPE, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_SUBSCRIPTION_CANCEL_TYPE 
    WHERE 
	    SUBSCRIPTION_CANCEL_TYPE_ID = #attributes.subscription_cancel_type_id#
</cfquery>
<table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
    <cfform name="upd_brand" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_subscription_cancel_type">        
    <input type="hidden" name="subscription_cancel_type_id" id="subscription_cancel_type_id" value="<cfoutput>#get_subscription_cancel_type.subscription_cancel_type_id#</cfoutput>">
        <tr class="color-row" valign="top">
            <td width="200"><cfinclude template="../display/list_subscription_cancel_type.cfm"></td>
            <td>
                <table border="0">
                    <tr>
                        <td><cf_get_lang no='20.Kategori Adı'> *</td>
                        <td><cfsavecontent variable="message"><cf_get_lang no='1189.Iptal Kategorisi Adı Girmelisiniz!'></cfsavecontent>
                        <cfinput type="text" name="subscription_cancel_type" value="#get_subscription_cancel_type.subscription_cancel_type#" maxlength="15" required="yes" message="#message#" style="width:150px;"></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td align="left" height="35"><cf_workcube_buttons is_upd='1' is_delete='0'></td>
                    </tr>
                    <tr>
                        <td colspan="3"><p><br/>
							<cfoutput>
                                <cfif len(get_subscription_cancel_type.record_emp)>
                                	<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_subscription_cancel_type.record_emp,0,0)# - #dateformat(get_subscription_cancel_type.record_date,dateformat_style)#
                                </cfif><br/>
                                <cfif len(get_subscription_cancel_type.update_emp)>
                                	<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_subscription_cancel_type.update_emp,0,0)# - #dateformat(get_subscription_cancel_type.update_date,dateformat_style)#
                                </cfif>
                            </cfoutput>
                        </td>
                    </tr>
                </table>
        </tr>
    </cfform>        
</table>
