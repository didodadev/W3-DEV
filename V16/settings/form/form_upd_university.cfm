<cfquery name="get_uni" datasource="#dsn#"> 
    SELECT 
    	UNIVERSITY_ID, 
        UNIVERSITY_NAME, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE,
        UPDATE_EMP, 
        UPDATE_IP, 
        SCHOOL_TYPE 
    FROM 
    	SETUP_UNIVERSITY 
    WHERE 
	    UNIVERSITY_ID = #attributes.u_id#
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
    <tr>
        <td class="headbold"><cf_get_lang no='912.Üniversiteler'></td>
        <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_university"><img src="/images/plus1.gif" border="0" align="absmiddle" alt=<cf_get_lang_main no='170.Ekle'>></a></td>
    </tr>
</table>
<table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
    <tr class="color-row" valign="top">
        <td width="280"><cfinclude template="../display/list_university.cfm"></td>
        <td>
            <table>
                <cfform name="upd_university" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_university">
                <input name="u_id" id="u_id" type="hidden" value="<cfoutput>#attributes.u_id#</cfoutput>">
                    <tr>
                        <td width="70"><cf_get_lang_main no='1958.Üniversite'>*</td>
                        <td><cfsavecontent variable="message"><cf_get_lang no ='1137.Üniversite Adı Girmelisiniz'> !</cfsavecontent>
                        <cfinput type="Text" name="university_name" style="width:250px;" value="#trim(get_uni.university_name)#" maxlength="50" required="Yes" message="#message#"></font></td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td height="35"><cf_workcube_buttons is_upd='1' is_delete='0'></td>
                    </tr>
                    <tr>
                        <td colspan="3"><p><br/>
							<cfoutput>
								<cfif len(get_uni.record_emp)>
                                	<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_uni.record_emp,0,0)# - #dateformat(get_uni.record_date,dateformat_style)#
                                </cfif><br/>
                                <cfif len(get_uni.update_emp)>
                                	<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_uni.update_emp,0,0)# - #dateformat(get_uni.update_date,dateformat_style)#
                                </cfif>
							</cfoutput>
                        </td>
                    </tr>
                </cfform>
            </table>
        </td>
    </tr>
</table>
