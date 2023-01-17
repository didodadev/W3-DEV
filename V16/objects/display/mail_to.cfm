<!---
Description :
   sends page content as a mail

Parameters :
	module       ==> Module directory path name for page
	file         ==> file name of the page
	is_pop       ==> whether opener window is popup or not

syntax : #request.self#?fuseaction=objects.popup_mail2&module=<module name>&file=<file name>&is_pop=#is_popup##page_code#
sample : #request.self#?fuseaction=objects.popup_mail2&module=finance/cash&file=list_cashes&is_pop=#is_popup##page_code#

Note1 : For sub modules , we should  arrange 'module' that syntax : <parent file structure>/<child file structure>
Note2 : After writing the correct syntax of the statement , follow :
        1.Settle '<!-- sil -->' statement into the start and the end point of unnecessary part of the page
        2.Define the 'is_pop' variable in the page
--->
<cfsavecontent variable="ust">
<cfinclude template="view_company_logo.cfm"></cfsavecontent>

<cfsavecontent variable="alt">
<cfinclude template="view_company_info.cfm"></cfsavecontent>

<cfsavecontent variable="cont">
<cfmodule template="../../index.cfm" fuseaction="#attributes.module#.#attributes.faction#" popup_for_files='1'></cfsavecontent>

<cfset cont = "<!-- sil -->" & cont & "<!-- sil -->">

<cfset start = find('<!-- sil -->',cont,1)>
<cfset middle = find('<!-- sil -->',cont,start + 12)>
<cfloop condition="(start GT 0) and (middle GT 0)">
	<cfset cont = removechars(cont,start,middle-start+12)>	
	<cfset start = find('<!-- sil -->',cont,1)>
	<cfset middle = find('<!-- sil -->',cont,start + 12)>
</cfloop>

<cfset start = find('<!-- siil -->',cont,1)>
<cfset middle = find('<!-- siil -->',cont,start + 13)>
<cfloop condition="(start GT 0) and (middle GT 0)">
	<cfset cont = removechars(cont,start,middle-start+13)>	
	<cfset start = find('<!-- siil -->',cont,1)>
	<cfset middle = find('<!-- siil -->',cont,start + 13)>
</cfloop>

<cfset start = find('<a href="',cont,1)>
<cfloop condition="(start GT 0)">
	<cfset cont = Insert("#cgi.http_host#/",cont,start + 8)>
	<cfset start = find('<a href="',cont,start+9)>
</cfloop>		
<cfif isDefined("mailto")>			
	<cftry>
		<cfmail  
			to = "#attributes.mailto#"
			from = "#attributes.mailFrom#"
			subject = "#attributes.subject#" type="HTML">
			<style type="text/css">
				.color-header{background-color: ##a7caed;}
				.color-border	{background-color:##6699cc;}
				.color-row{	background-color: ##f1f0ff;}
				.label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
				.form-title	{font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color:white;font-weight : bold;padding-left: 2px;}
				.tableyazi {font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 2px;color : ##0033CC;	}          
				a.tableyazi:visited {font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;	text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 2px;color : ##0033CC;} 
				a.tableyazi:active {text-decoration: none;}
				a.tableyazi:hover {text-decoration: underline; color:##339900;}  
				a.tableyazi:link {	font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;	text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 2px;color : ##0033CC;}
				.headbold {  font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
			</style>
			<div style="text-align:right;">#ust#</div><br/>   
			#cont#<br/>
			<CENTER>#alt#</CENTER>	
		</cfmail>
	  
		<cfsavecontent variable="css">
			<style type="text/css">
				.color-header{background-color: ##a7caed;}
				.color-border	{background-color:##6699cc;}
				.color-row{	background-color: ##f1f0ff;}
				.label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
				.form-title	{font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color:white;font-weight : bold;padding-left: 2px;}	
				.tableyazi {font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 2px;color : ##0033CC;	}          
				a.tableyazi:visited {font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;	text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 2px;color : ##0033CC;} 
				a.tableyazi:active {text-decoration: none;}
				a.tableyazi:hover {text-decoration: underline; color:##339900;}  
				a.tableyazi:link {	font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;	text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 2px;color : ##0033CC;}
				.headbold {  font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
			</style>
		</cfsavecontent>
		<cfset attributes.from = attributes.mailFrom>	
		<cfset attributes.to = attributes.mailto>  
		<cfset attributes.body="#css##ust#<br/>#cont#<br/>#alt#">
		<cfset attributes.type = 0>
		<cfinclude template="../query/add_mail.cfm">
		<table height="100%" width="100%" cellspacing="0" cellpadding="0">
			<tr class="color-border">
				<td valign="top"> 
				<table height="100%" width="100%" cellspacing="1" cellpadding="2">
					<tr class="color-list">
						<td height="35" class="headbold">&nbsp;&nbsp;<cf_get_lang dictionary_id='57512.Workcube E-Mail'></td>
					</tr>
					<tr class="color-row">
						<td align="center" class="headbold"><cf_get_lang dictionary_id='57513.Mail Başarıyla Gönderildi'></td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		<cfcatch type="any">
		<table height="100%" width="100%" cellspacing="0" cellpadding="0">
			<tr class="color-border">
				<td valign="top"> 
				<table height="100%" width="100%" cellspacing="1" cellpadding="2">
					<tr class="color-list">
						<td height="35" class="headbold">&nbsp;&nbsp;<cf_get_lang dictionary_id='57512.Workcube E-Mail'></td>
					</tr>
					<tr class="color-row">
						<td align="center" class="headbold">
						<cf_get_lang dictionary_id='57618.Mail Göndermede Bir Hata Oldu Lütfen Verileri Kontrol Edip Sonra Tekrar Deneyiniz'></td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</cfcatch>
	</cftry>
	<script type="text/javascript">
		function waitfor()
		{
			<cfif isDefined("attributes.is_pop") and (attributes.is_pop EQ 1)>
				window.opener.close();
			</cfif>  
			window.close();
		}
		setTimeout("waitfor()",3000);  
	</script>
<cfelse>
    <script type="text/javascript">
		self.moveTo(100,100);
		function kontrol()
		{			
			if (document.mail_form.mailto.value == '')
			{
				alert("<cf_get_lang dictionary_id='33824.Kime alanı boş olmamalı'>!");
				return false;
			}
			else if (document.mail_form.subject.value == '')
			{
				alert("<cf_get_lang dictionary_id='33825.Konu alanı boş olmamalı'>!");
				return false;
			}					
			return true;
		}	
	</script>
	<table cellspacing="0" cellpadding="0" border="0" height="100%" width="100%">
		<tr class="color-border"> 
			<td>
			<table cellspacing="1" cellpadding="2" border="0" class="label" width="100%" height="100%">
				<tr class="color-list" valign="middle"> 
					<td height="35">
					<table width="100%" align="center">
						<tr> 
							<td valign="bottom" class="headbold"><cf_get_lang dictionary_id='57475.Mail Gönder'></td>
						</tr>
					</table>
					</td>
				</tr>
				<tr class="color-row"> 
					<td valign="top">
						<cfoutput>
						<form name="mail_form" id="mail_form" action="#request.self#?fuseaction=objects.popup_mail2#page_code#" method="post" onSubmit="return kontrol();">
						<table>
							<tr>                   
								<td width="80"> &nbsp;&nbsp;<cf_get_lang dictionary_id='57924.Kime'>*</td>
								<input  type="hidden" name="to_id" id="to_id" value="">	  
								<td><input  type="text" name="mailto" id="mailto" value=""  style="width:275px;"></td>
								<td><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_mail&mail_id=mail_form.to_id&names=mail_form.mailto','list')"><img SRC="/images/plus_thin.gif" BORDER="0" ALIGN="absmiddle"></a></td>							
							</tr>
							<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
								<cfset sender = "#session.ep.company#<#session.ep.company_email#>">
							<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
								<cfset sender = "#session.pp.our_name#<#session.pp.our_company_email#>">
							<cfelseif listfindnocase(career_url,'#cgi.http_host#',';')>
								<cfset sender = "#session.cp.our_name#<#session.cp.our_company_email#>">
							<cfelseif listfindnocase(server_url,'#cgi.http_host#',';')>
								<cfset sender = "#session.ww.our_name#<#session.ww.our_company_email#>">
							</cfif>
							<cfquery name="GET_MAILFROM" datasource="#dsn#">
								select
									<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_EMAIL<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME,COMPANY_PARTNER_EMAIL</cfif>
								from		
									<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_POSITIONS<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>COMPANY_PARTNER</cfif>		
								where
									<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_ID=#session.ep.USERID#
									<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>PARTNER_ID=#session.pp.USERID#
									</cfif>
							</cfquery>
							<cfif Len(GET_MAILFROM.EMPLOYEE_EMAIL)>
								<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
									<cfset sender = "#GET_MAILFROM.EMPLOYEE_NAME# #GET_MAILFROM.EMPLOYEE_SURNAME#&lt;#GET_MAILFROM.EMPLOYEE_EMAIL#&gt;">
								<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
									<cfset sender = "#GET_MAILFROM.COMPANY_PARTNER_NAME# #GET_MAILFROM.COMPANY_PARTNER_SURNAME#&lt;#GET_MAILFROM.COMPANY_PARTNER_EMAIL#&gt;">							
								</cfif>
							</cfif>
							<input  type="hidden" name="mailfrom" id="mailfrom" value="<cfoutput>#sender#</cfoutput>" maxlength="50">
							<tr>				  				  
								<td width="80">&nbsp;&nbsp;<cf_get_lang dictionary_id='57480.Konu'> *</td>
								<td width="170" colspan="2"><input  type="text" name="subject" id="subject" value=""  style="width:275px;" maxlength="50"></td>								    				  
							</tr>						   
							<tr>
								<td colspan="3"  style="text-align:right;">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='58743.Gönder'></cfsavecontent>
									<cf_workcube_buttons is_upd='0' insert_info='#message#'>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								</td>				 
							</tr>
						</table>
						</form>
						<div style="text-align:right;">#ust#</div><br/>   
						#cont#<br/>
						<CENTER>#alt#</CENTER>  	
						<cfif isdefined("attributes.extra_parameters")>
						<script type="text/javascript">
							mail_form.mailto.value = opener.#attributes.extra_parameters#.value;
						</script>
						</cfif>
						</cfoutput>
					</td>
				</tr>
			</table>
			</td>
		</tr>
	</table>
</cfif>
