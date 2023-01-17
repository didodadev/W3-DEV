<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
        <td height="35" class="headbold"><cf_get_lang no='1490.Departman Adı Güncelle'></td>
        <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_department_name"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang no='349.Departman Adı Ekle'>"></a>	</td>
    </tr>
</table>
<table width="98%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
    <tr class="color-row">
        <td width="200" valign="top">
            <div id="mali1" style="position:absolute;width:200px;height:142px; z-index:88;overflow:auto;">
            	<cfinclude template="../display/list_department_name.cfm">
            </div>
        </td>
        <td valign="top">
            <table border="0">
            <cfquery name="get_dep_name" datasource="#dsn#">
            	SELECT 
        	        DEPARTMENT_NAME_ID, 
                    DEPARTMENT_NAME, 
                    DETAIL, 
                    RECORD_DATE, 
                    RECORD_EMP, 
                    RECORD_IP, 
                    UPDATE_DATE, 
                    UPDATE_EMP, 
                    UPDATE_IP, 
                    IS_ACTIVE 
                FROM 
    	            SETUP_DEPARTMENT_NAME 
                WHERE 
	                DEPARTMENT_NAME_ID=#attributes.dep_name_id#
            </cfquery>
                <cfform name="departman" method="post" action="#request.self#?fuseaction=settings.emptypopup_department_name_upd">
                <input type="hidden" value="<cfoutput>#attributes.dep_name_id#</cfoutput>" name="dep_name_id" id="dep_name_id">
                    <tr>
                        <td>&nbsp;</td>
                        <td><input type="Checkbox" name="is_active" id="is_active" value="1" <cfif get_dep_name.is_active eq 1>checked</cfif>><cf_get_lang_main no='81.Aktif'></td>
                    </tr>
                    <tr>
                        <td width="100"><cf_get_lang_main no='68.Başlık'>*</td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
                            <cfinput type="Text" name="department_name"  style="width:250px;" value="#get_dep_name.department_name#" maxlength="50" required="Yes" message="#message#">
                        </td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang no='26.Ayrıntı'></td>
                        <td>
                        	<Textarea name="department_name_detail" id="department_name_detail" cols="60" rows="2" style="width:250px;height:50px;" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı : 250"><cfoutput>#get_dep_name.detail#</cfoutput></TEXTAREA>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" height="35" colspan="2" align="right" style="text-align:right;">
                            <cfquery name="Get_Department_Name_Control" datasource="#dsn#">
                            	SELECT TOP 1 DEPARTMENT_NAME_ID FROM SETUP_POSITION_CAT_DEPARTMENTS WHERE DEPARTMENT_NAME_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dep_name_id#">
                            </cfquery>
                            <cfif not Get_Department_Name_Control.RecordCount>
                                <cfquery name="Get_Department_Name_Control" datasource="#dsn#">
                                    SELECT TOP 1 DEPARTMENT_NAME_ID FROM DEPARTMENT WHERE DEPARTMENT_NAME_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dep_name_id#">
                                </cfquery>
                            </cfif>
                            <cfif Get_Department_Name_Control.RecordCount>
                            	<cfset IsDelete_ = 0>
                            <cfelse>
                            	<cfset IsDelete_ = 1>
                            </cfif>
                            <!--- Kullanildigi tablolarda kontrol edilip, kayit varsa silinmesi engelleniyor FBS20101221 --->
                            <cf_workcube_buttons is_upd='1' is_delete= '#IsDelete_#' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_dep_name&id=#attributes.dep_name_id#'>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <cf_get_lang_main no='71.Kayıt'> :
                            <cfoutput>
								<cfif len(get_dep_name.record_emp)>#get_emp_info(get_dep_name.record_emp,0,0)#</cfif>
                                <cfif len(get_dep_name.record_date)>- #dateformat(get_dep_name.record_date,dateformat_style)#</cfif>
                                <cfif len(get_dep_name.update_date)>
                                    <br/>
                                    <cf_get_lang_main no='479.Güncelleyen'> :
                                    #get_emp_info(get_dep_name.update_emp,0,0)#
                                    - #dateformat(get_dep_name.update_date,dateformat_style)#
                                </cfif>
                            </cfoutput>			
                        </td>
                    </tr>
                </cfform>
            </table>
        </td>
    </tr>
</table>
