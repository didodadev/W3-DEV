<cfquery name="GET_MAIL_DETAIL" datasource="#DSN#">
	SELECT 
  		EMPAPP_MAIL, 
        EMP_APP_MAIL_ID, 
        MAIL_HEAD, 
        MAIL_CONTENT 
    FROM 
    	EMPLOYEES_APP_MAILS 
    WHERE 
    	EMP_APP_MAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_app_mail_id#">
</cfquery>
<cfquery name="GET_EMP_MAIL" datasource="#DSN#">
  SELECT EMAIL FROM EMPLOYEES_APP WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.empapp_id#">
</cfquery>
<cfquery name="GET_CAT" datasource="#DSN#">
	SELECT CORRCAT_ID, DETAIL, CORRCAT FROM SETUP_CORR ORDER BY CORRCAT
</cfquery>

<cfform name="add_app_mail" method="post" enctype="multipart/form-data">
	<input type="hidden" name="emp_app_mail_id" id="emp_app_mail_id" value="<cfoutput>#attributes.emp_app_mail_id#</cfoutput>">
	<input type="Hidden" id="clicked" name="clicked" value="">
	<table cellspacing="1" cellpadding="2" border="0" class="color-border" style="width:100%; height:100%;">
		<tr class="color-list" style="height:35px;">
			<td>
				<table style="width:100%;">
					<tr>
                        <td class="headbold">&nbsp;<cf_get_lang_main no='63.Mail Gönder'></td>
                    </tr>
                </table>
            </td>
     	</tr>
        <tr class="color-row">
            <td style="vertical-align:top;">
                <table>
                    <tr>
                    	<td colspan="2">
                        	&nbsp;
                            <input type="hidden" name="empapp_id" id="empapp_id" value="<cfoutput>#attributes.empapp_id#</cfoutput>">
                            <cf_get_lang_main no='16.mail'>
                            &nbsp;&nbsp;
                            <input type="text" name="employee_email" id="employee_email" value="<cfoutput>#get_mail_detail.empapp_mail#</cfoutput>" style="width:450px;">
                        </td>
                    </tr>
                </table>
                <table>
                    <tr>
                        <td colspan="2">
                        	&nbsp;&nbsp;<cf_get_lang_main no='68.Başlık'>*&nbsp;
                        	<cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık Girmelisiniz'></cfsavecontent>
                        	<cfinput type="text" name="header" id="header" style="width:450px;"  value="#get_mail_detail.MAIL_HEAD#" required="yes" message="#message#">
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="vertical-align:top;">

                            <cfmodule template="/fckeditor/fckeditor.cfm"
                                toolbarset="Basic"
                                basepath="/fckeditor/"
                                instancename="content"
                                valign="top"
                                value="#htmleditformat(get_mail_detail.mail_content)#"
                                width="575"
                                height="385"> 
                        </td>
                    </tr>
                    <tr>
                        <td><!--- &nbsp;&nbsp;&nbsp;Kayıt: <cfoutput>#get_emp_info(get_mail_detail.record_emp,0,0)# - #dateformat(get_mail_detail.record_date,'dd/mm/yyyy')#</cfoutput> ---></td>
                        <td style="text-align:right;">
                        	<cf_workcube_buttons is_upd='1' data_action="/V16/objects2/career/cfc/data_career_partner:upd_empapp_mail" next_page="#request.self#" del_action="/V16/objects2/career/cfc/data_career_partner:del_empapp_mail" del_next_page="#request.self#">&nbsp;&nbsp;&nbsp;
                       	</td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</cfform>
