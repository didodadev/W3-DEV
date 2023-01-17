<cfquery name="GET_EMP_DETAIL" datasource="#DSN#" maxrows="1">
	SELECT LANG1_LEVEL, LANG2_LEVEL FROM EMPLOYEES_DETAIL WHERE LANG1_LEVEL=#URL.ID# OR LANG1_LEVEL=#URL.ID#
</cfquery>
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0" >
    <tr>
        <td  class="headbold"><cf_get_lang no ='1794.Bilgisayar Bilgisi Güncelle'></td>
        <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_computer_info"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
    </tr>
</table>
<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
    <tr class="color-row">
        <td width="200">
            <cfquery name="GETCOMPUTERINFO" datasource="#dsn#">
                SELECT 
	                COMPUTER_INFO_ID, 
                    COMPUTER_INFO_NAME, 
                    COMPUTER_INFO_DESCRIPTION, 
                    COMPUTER_INFO_STATUS, 
                    RECORD_DATE, 
                    RECORD_EMP, 
                    RECORD_IP, 
                    UPDATE_DATE, 
                    UPDATE_EMP, 
                    UPDATE_IP 
                FROM 
                	SETUP_COMPUTER_INFO
            </cfquery>
            <table width="200" cellpadding="0" cellspacing="0" border="0">
                <tr> 
                    <td valign="top" class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no ='1731.Bilgisayar Bilgisi'></td>
                </tr>
				<cfif GETCOMPUTERINFO.recordcount>
					<cfoutput query="GETCOMPUTERINFO">
                        <tr>
                            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                            <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_computer_info&ID=#computer_info_id#" class="tableyazi">#computer_info_name#</a></td>
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
                <cfform action="#request.self#?fuseaction=settings.emptypopup_upd_computer_info" method="post" name="computer_info">
                    <cfquery name="CATEGORY" datasource="#dsn#">
                        SELECT 
                            COMPUTER_INFO_ID, 
                            COMPUTER_INFO_NAME, 
                            COMPUTER_INFO_DESCRIPTION, 
                            COMPUTER_INFO_STATUS, 
                            RECORD_DATE, 
                            RECORD_EMP, 
                            RECORD_IP, 
                            UPDATE_DATE, 
                            UPDATE_EMP, 
                            UPDATE_IP 
                        FROM 
                        	SETUP_COMPUTER_INFO
                        WHERE 
                        	COMPUTER_INFO_ID=#URL.ID#
                    </cfquery>
                    <input type="Hidden" name="computer_info_id" id="computer_info_id" value="<cfoutput>#URL.ID#</cfoutput>">
                    <tr>
                        <td width="100"><cf_get_lang_main no='344.durum'></td>
                        <td><input type="Checkbox" value="1" name="computer_info_status" id="computer_info_status" <cfif category.computer_info_status eq 1>checked</cfif>><cf_get_lang_main no='81.Aktif'></td>
                    </tr>
                    <tr>
                        <td width="100"><cf_get_lang no ='1731.Bilgisayar Bilgisi'>*</td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang_main no='1092.Bilgisayar Bilgisi girmelisiniz'></cfsavecontent>
                            <cfinput type="Text" name="computer_info_name" size="30" value="#category.computer_info_name#" maxlength="150" required="Yes" message="#message#" style="width:200px;">
                        </td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang no='26.Ayrıntı'></td>
                        <td>
                            <Textarea name="computer_info_description" id="computer_info_description" cols="60" rows="2" style="width:200px;height:50px;"><cfoutput>#category.computer_info_description#</cfoutput></TEXTAREA>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td height="35"> 
                            <cfif get_emp_detail.recordcount>
                                <cf_workcube_buttons is_upd='1' is_delete='0'>                  
                            <cfelse>
                                <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_computer_info&computer_info_id=#URL.ID#'>
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
