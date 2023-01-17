<cfquery name="GET_CAMP_STAGE_ID" datasource="#DSN3#">
	SELECT
		STAGE_ID
	FROM
		CATALOG_PROMOTION
	WHERE
		STAGE_ID=#URL.STAGE_ID#
</cfquery>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr>
    <td height="35" class="headbold"><cf_get_lang no='582.Aksiyon Aşaması Güncelle'></td>
    <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_action_stage"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
</tr>
</table>
<table width="98%" border="0" cellspacing="1" cellpadding="2" align="center" class="color-border">
    <tr class="color-row">
        <td width="200" valign="top"><cfinclude template="../display/list_action_stage.cfm">
        </td>
        <td valign="top">
            <table>
                <cfform action="#request.self#?fuseaction=settings.emptypopup_upd_action_stage" method="post" name="position">
                    <cfquery name="get_stage" datasource="#dsn#">
                        SELECT 
                            STAGE_ID, 
                            STAGE_NAME, 
                            DETAIL, 
                            RECORD_DATE, 
                            RECORD_IP, 
                            RECORD_EMP, 
                            UPDATE_DATE, 
                            UPDATE_IP, 
                            UPDATE_EMP 
                        FROM 
                        	SETUP_ACTION_STAGES 
                        WHERE 
                        	STAGE_ID = #URL.STAGE_ID#
                    </cfquery>
                    <input type="Hidden" name="STAGE_ID" id="STAGE_ID" value="<cfoutput>#get_stage.STAGE_ID#</cfoutput>">
                    <tr>
                        <td width="100"><cf_get_lang_main no='68.Başlık'> *</td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
                            <cfinput type="Text" name="stage_name" size="40" value="#get_stage.stage_name#" maxlength="50" required="Yes" message="#message#" style="width:200px;">
                        </td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                        <td>
                        	<TEXTAREA name="detail" id="detail" style="width:200px;height:60px;" maxlength="50" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı : 50"><cfoutput>#get_stage.detail#</cfoutput></TEXTAREA>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td height="35" >
							<cfif get_camp_stage_id.recordcount>
                            	<cf_workcube_buttons is_upd='1' is_delete='0'>
                            <cfelse>
                            <cfif get_stage.stage_id lte 0>
                            	<cf_workcube_buttons is_upd='1' is_delete='0'>
                            <cfelse>
                            	<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_action_stage&stage_id=#URL.stage_id#'>
                            </cfif>
                            </cfif>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <cf_get_lang_main no='71.Kayıt'> :
                            <cfoutput>
								<cfif len(get_stage.record_emp)>#get_emp_info(get_stage.record_emp,0,0)#</cfif>
                                <cfif len(get_stage.record_date)> - #dateformat(get_stage.record_date,dateformat_style)#</cfif>
                                <cfif len(get_stage.update_emp)>
                                    <br/>
                                    <cf_get_lang_main no='291.Son Güncelleme'> :
                                    #get_emp_info(get_stage.update_emp,0,0)#
                                    - #dateformat(get_stage.update_date,dateformat_style)#
                                </cfif>
                            </cfoutput>
                        </td>
                    </tr>
                </cfform>
            </table>
        </td>
    </tr>
</table>

