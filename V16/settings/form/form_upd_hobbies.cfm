<cfquery name="get_hobbies" datasource="#dsn#"> 
	SELECT 
    	HOBBY_ID, 
        HOBBY_NAME, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_HOBBY 
    WHERE 
	    HOBBY_ID = #attributes.hobby_id#
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
    <tr>
        <td class="headbold"> <cf_get_lang no='868.Hobiler'></td>
        <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_hobbies"><img src="/images/plus1.gif" border="0" align="absmiddle" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
    </tr>
</table>
<table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
    <tr class="color-row" valign="top">
        <td width="220"><cfinclude template="../display/list_hobbies.cfm"></td>
        <td>
            <cfform name="content_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_hobbies_upd">
            <input name="hobby_id" id="hobby_id" type="hidden" value="<cfoutput>#get_hobbies.HOBBY_ID#</cfoutput>">
                <table border="0">
                    <tr>
                        <td width="60"><cf_get_lang no='869.Hobiler'><font color=black>*</font></td>
                        <td><cfsavecontent variable="message"><cf_get_lang no ='1237.Hobi girişi yapmalısınız'>!</cfsavecontent>
                        <cfinput type="Text" name="hobby_name" style="width:150px;" value="#trim(get_hobbies.HOBBY_NAME)#" maxlength="50" required="Yes" message="#message#"></td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td height="35"><cf_workcube_buttons is_upd='1' is_delete='0'></td>
                    </tr>
                    <cfif len(get_hobbies.RECORD_EMP)>			
                    	<tr>
                            <td nowrap colspan="2"><p><br/><cf_get_lang_main no='71.Kayıt'> :
                                <cfoutput>#get_emp_info(get_hobbies.RECORD_EMP,0,0)#&nbsp;#dateformat(date_add('h',session.ep.time_zone,get_hobbies.RECORD_DATE),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,get_hobbies.RECORD_DATE),timeformat_style)#</cfoutput><br/>
                                <cfif len(get_hobbies.UPDATE_EMP)><cf_get_lang_main no ='479.Güncelleyen'>:<cfoutput>#get_emp_info(get_hobbies.update_emp,0,0)# - #dateformat(date_add('h',session.ep.time_zone,get_hobbies.update_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,get_hobbies.update_date),timeformat_style)#</cfoutput></cfif>
                            </td>
                        </tr>
                    </cfif>
                </table>
            </cfform>
        </td>
    </tr>
</table>
