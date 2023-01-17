<cfquery name="get_reason" datasource="#dsn#">
    SELECT 
        REASON_ID, 
        REASON,
        ACTIVE,
        RECORD_EMP, 
        RECORD_IP, 
        RECORD_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        UPDATE_DATE
    FROM 
        SETUP_INVENTORY_DEMAND_REASON 
    WHERE 	
        REASON_ID=#attributes.reason_id#
</cfquery>
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0" >
	<tr>
		<td class="headbold">Envanter Talep Nedenleri Parametreleri</td>
		<td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_inventory_demand_reason"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
	</tr>
</table>
<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
	<tr class="color-row">
		<td width="200" valign="top">
			<!--- Liste Sayfasi --->
			<cfinclude template="../display/list_inventory_demand_reason.cfm">
		</td>
		<td valign="top">
		<table>
			<cfform name="reason" action="#request.self#?fuseaction=settings.emptypopup_upd_inventory_demand_reason" method="post" >
            	<cfoutput query="get_reason">
                    <input type="hidden" name="reason_id" id="reason_id" value="<cfoutput>#reason_id#</cfoutput>">
                    <tr>
                        <td width="100"><cf_get_lang_main no='81.Aktif'></td>
                        <td>	
                            <input name="active" id="active" type="checkbox" <cfif active eq 1>checked</cfif>>
                        </td>
                    </tr>
                    <tr>
                        <td width="100">Talep Nedeni*</td>
                        <td><cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
                            <cfinput type="Text" name="demand_reason" id="demand_reason" size="20" value="#reason#" maxlength="100" required="Yes" message="#message#" style="width:175px;">
                        </td>
                    </tr>
                    <tr height="35" valign="middle">
                        <td>&nbsp;</td>
                        <td>
                            <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_inventory_demand_reason&reason_id=#reason_id#'>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <cfif len(record_emp)>
                                <cf_get_lang_main no='71.Kayıt'> : #get_emp_info(record_emp,0,0)#
                            </cfif>
                            <cfif len(record_date)> - #dateformat(record_date,dateformat_style)#</cfif><br/>
                            <cfif  len(update_emp)>
                                <cf_get_lang_main no='479.Güncelleyen'> : #get_emp_info(update_emp,0,0)# - #dateformat(update_date,dateformat_style)#
                            </cfif>
                        </td>
                    </tr>
                </cfoutput>
			</cfform>
		</table>
		</td>
	</tr>
</table>
