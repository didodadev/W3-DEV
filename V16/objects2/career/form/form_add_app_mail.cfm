<cfset control = 0> 
<cfif isdefined("attributes.mail_sum")  and (not isdefined("form.mail") or not len(trim(form.mail)))>
   	<script type="text/javascript">
		alert("<cf_get_lang no ='1170.Mail gönderilecek kişi yok,kontrol edin! Listeden mail göndermek istediğiniz kişiler seçili olmamalı'>");
	 	window.close();
   	</script>
  	<cfabort>
<cfelseif isdefined("attributes.mail_sum")  and  isdefined("form.mail")>
	<cfset control = 1>  
    <cfset mail_list = form.mail>
</cfif>

<cfquery name="GET_EMP_MAIL" datasource="#DSN#">
	SELECT
		EMPAPP_ID,
		EMAIL,
		NAME,
		SURNAME
	FROM 
		EMPLOYEES_APP 
	WHERE 
		EMAIL <> '' 
		<cfif isdefined("attributes.mail_sum") and isdefined("form.mail") and len(form.mail)>
			AND EMPAPP_ID IN (#form.mail#)
		<cfelseif isdefined("attributes.empapp_id") and len(attributes.empapp_id)>
			AND EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.empapp_id#">
		</cfif>
	ORDER BY 
		EMPAPP_ID DESC
</cfquery>

<cfset form.mail=ValueList(get_emp_mail.empapp_id,',')>

<cfform name="add_app_mail" method="post" enctype="multipart/form-data"<!---  action="#request.self#?fuseaction=objects2.emptypopup_add_empapp_mail" --->>
<table cellspacing="1" cellpadding="2" border="0" class="color-border" style="width:100%; height:100%;">
  	<cfif isdefined("attributes.app_pos_id")>
  		<input type="hidden" name="app_pos_id" id="app_pos_id" value="<cfoutput>#attributes.app_pos_id#</cfoutput>">
  	</cfif>
	<cfif isdefined("attributes.list_id")>
    	<input type="hidden" name="list_id" id="list_id" value="<cfoutput>#attributes.list_id#</cfoutput>">
    </cfif>
    <cfif isdefined("attributes.kontrol")>
    	<input type="hidden" name="kontrol" id="kontrol" value="<cfoutput>#attributes.kontrol#</cfoutput>">
    </cfif>
    <input type="hidden" id="clicked" name="clicked" value="">
    <cfif isdefined("attributes.mail_sum") and len(form.mail)>
    	<input type="hidden" name="mail_sum" id="mail_sum" value="<cfoutput>#attributes.mail_sum#</cfoutput>">
    </cfif>
    <cfif isdefined("form.mail") and len(form.mail)>
    	<input type="hidden" name="mail" id="mail" value="<cfoutput>#form.mail#</cfoutput>">
    </cfif>
    <cfif isdefined("attributes.is_refresh") and len(attributes.is_refresh)>
    	<input type="hidden" name="is_refresh" id="is_refresh" value="<cfoutput>#attributes.is_refresh#</cfoutput>">
    </cfif>
    <tr class="color-list" style="height:35px;">
    	<td>  
    		<table border="0" cellspacing="0" cellpadding="0" style="width:100%;">
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
    				<td>&nbsp;
						<cfif control eq 0>
                            <input type="hidden" name="empapp_id" id="empapp_id" value="<cfoutput>#attributes.empapp_id#</cfoutput>">
                            <cf_get_lang_main no='16.mail'>&nbsp;&nbsp;&nbsp;&nbsp;
                            <input type="text" name="employee_email" id="employee_email" style="width:450px;" value="<cfoutput>#get_emp_mail.email#</cfoutput>">
                        <cfelse>
                            <input type="hidden" name="empapp_id" id="empapp_id" value="<cfoutput>#mail_list#</cfoutput>">
                            <cf_get_lang_main no='16.email'>&nbsp;&nbsp;&nbsp;&nbsp;
                            <cfset emails = valuelist(get_emp_mail.EMAIL,",")>
                            <input type="text" name="employee_email" id="employee_email" style="width:450px;" value="<cfoutput>#emails#</cfoutput>">
                        </cfif>  
    				</td>
    			</tr>
    		</table>
    		<table>
            	<tr>
                    <td>
                    	&nbsp;&nbsp;<cf_get_lang_main no='68.Başlık'>*&nbsp;&nbsp;&nbsp;
                    	<cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
                    	<cfinput type="text" name="header" id="header" value="" required="yes" message="#message#" style="width:450px;">
                    </td>
                </tr>
                <tr>
                    <td style="vertical-align:top;">
                  		<cfmodule template="/fckeditor/fckeditor.cfm"
                            toolbarset="Basic"
                            basepath="/fckeditor/"
                            instancename="content"
                            valign="top"
                            value=""
                            width="530"
                            height="385">   
                    </td>
                </tr>
                <tr>
                    <td style="text-align:right;">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='35493.Save and Send email'></cfsavecontent>
                        <!--- <input type="submit" style="width:130px;" value="<cfoutput>#message#</cfoutput>" extraFunction="clicked.value='&email=true';return control()"><!--- OnFormSubmit()&& --->	 --->
						<cf_workcube_buttons is_insert='1' insert_info='#message#' data_action="/V16/objects2/career/cfc/data_career_partner:add_empapp_mail" next_page="#request.self#" add_function='control()'>
						
					</td><!--- OnFormSubmit()&& --->
                </tr>
            </table>
        </td>
    </tr>
</table>
</cfform>

<script type="text/javascript">
	function control()
	{
		document.getElementById('add_app_mail').action = document.getElementById('add_app_mail').action + document.getElementById('clicked').value; 
		var aaa = document.getElementById('employee_email').value;
		if (((aaa == "") || (aaa.indexOf("@") == -1) || (aaa.indexOf(".") == -1) || (aaa.length < 6)) && (document.getElementById('clicked').value == "&email=true"))
		{ 
			alert("<cf_get_lang_main no='1072.Lütfen mail alanına geçerli bir mail giriniz'>!!");
			//document.getElementById('add_app_mail').action = "<cfoutput>#request.self#?fuseaction=objects2.emptypopup_add_empapp_mail</cfoutput>"; 
			return false;
		}
		return true;
	}
</script>
