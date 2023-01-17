<cfquery name="GET_EMP_IDENTYCARD" datasource="#DSN#" maxrows="1">
	SELECT IDENTYCARD_CAT FROM EMPLOYEES_DETAIL WHERE	IDENTYCARD_CAT=#URL.ID#
</cfquery>
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0" >
    <tr>
        <td align="left" class="headbold"><cf_get_lang no='625.Kimlik Kartı Kategorisi Güncelle'></td>
        <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_id_card"><img src="/images/plus1.gif" border="0" align="absmiddle" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
    </tr>
</table>
<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
    <tr class="color-row">
        <td width="200">
            <cfinclude template="../display/list_id_card.cfm">
        </td>
        <td>
            <table border="0">
                <cfform action="#request.self#?fuseaction=settings.emptypopup_id_card_upd" method="post" name="id_card" >
                <input type="hidden" ID="clicked" name="clicked" value="">
                <cfquery name="CATEGORY" datasource="#dsn#">
                    SELECT 
                        IDENTYCAT_ID, 
                        IDENTYCAT, 
                        RECORD_EMP, 
                        RECORD_DATE, 
                        RECORD_IP, 
                        UPDATE_EMP, 
                        UPDATE_DATE, 
                        UPDATE_IP 
                    FROM 
                        SETUP_IDENTYCARD 
                    WHERE 
                        IDENTYCAT_ID=#URL.ID#
                </cfquery>
                <input type="hidden" name="identycat_id" id="identycat_id" value="<cfoutput>#url.id#</cfoutput>">
                    <tr>
                        <td width="100"><cf_get_lang_main no='68.Başlık'> *</td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
                            <cfinput type="Text" name="identycat" style="width:150px;" value="#category.identycat#" maxlength="25" required="Yes" message="#message#">
                        </td>
                    </tr>
                    <tr>
                    <tr height="35">
                        <td></td>
                        <td>
							<cfif get_emp_identycard.recordcount>
                            	<cf_workcube_buttons is_upd='1' is_delete='0'>
                            <cfelse>
                            	<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_id_card_del&identycat_id=#URL.ID#'>
                        	</cfif>
                        </td>
                    </tr>
                    <td colspan="2"><cf_get_lang_main no='71.Kayıt'> : 
						<cfoutput> 
                            <cfif len(category.record_emp)>#get_emp_info(category.record_emp,0,0)#</cfif> 
                            <cfif len(category.record_date)>#dateformat(category.record_date,dateformat_style)#</cfif>
                            <cfif len(category.update_EMP)>
                                <br/>
                                <cf_get_lang_main no='479.guncelleyen'> :
                                #get_emp_info(category.update_emp,0,0)# 
                                #dateformat(category.update_date,dateformat_style)#
                            </cfif>
                        </cfoutput>
                    </td>
                    </tr>
                </cfform>
            </table>
        </td>
    </tr>
</table>
