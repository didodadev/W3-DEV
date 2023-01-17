<!---
Description :
   sends editor content as a mail

Parameters :
	editor_name  ==> Ther editor name of opener window -- not necessary
	editor_header==> Ther editor header name of opener window -- not necessary
	is_pop       ==> whether opener window is popup or not

syntax : #request.self#?fuseaction=objects.popup_send_mail&editor_name=<parent editor name>&editor_header=<parent editor header name>&is_pop=#is_popup#
sample : #request.self#?fuseaction=objects.popup_send_mail&editor_name=fHtmlEditor.makale&editor_header=fHtmlEditor.subject&is_pop=#is_popup#

Note : After writing the correct syntax of the statement , follow :
	1.Settle '<!-- sil -->' statement into the start and the end point of unnecessary part of the page
	2.Define the 'is_pop' variable in the page
--->
<cfsavecontent variable="ust"><cfinclude template="view_company_logo.cfm"></cfsavecontent>
<cfsavecontent variable="alt"><cfinclude template="view_company_info.cfm"></cfsavecontent>
<cfset alt = wrk_content_clear(alt)>
<cfset ust = wrk_content_clear(ust)>
<cfif isDefined("attributes.message")>
	<cfif attributes.attachment neq ''>
	  <cftry>
		<cffile action="UPLOAD" 
						nameconflict="OVERWRITE" 
						filefield="attachment" 
						destination="#upload_folder#mails#dir_seperator#out#dir_seperator#attachments#dir_seperator#">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">
		<cffile action="rename" source="#upload_folder#mails#dir_seperator#out#dir_seperator#attachments#dir_seperator##cffile.serverfile#" destination="#upload_folder#mails#dir_seperator#out#dir_seperator#attachments#dir_seperator##file_name#">
		<!---Script dosyalarını engelle  02092010 FA-ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder#mails#dir_seperator#out#dir_seperator#attachments#dir_seperator##file_name#">
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='47804.\php\,\jsp\,\asp\,\cfm\,\cfml\ Formatlarında Dosya Girmeyiniz'>!!");
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfset attributes.attachment=#file_name#>
		<cfcatch type="any">
		  <script type="text/javascript">
				alert("<cf_get_lang dictionary_id='57455.Dosyanız upload edilemedi! Dosyanızı kontrol ediniz !'>");
				history.back();
			</script>
		  <cfabort>
		</cfcatch>
	  </cftry>
	</cfif>
	<cftry>
		<cfmail  
		  to = "#attributes.to#"
		  from = "#attributes.from#"
		  subject = "#attributes.subject#"
		  cc="#attributes.cc#"		  
		  bcc="#attributes.bcc#" type="HTML">
		<cfif attributes.attachment neq ''>
		  <cfmailparam file="#upload_folder#mails#dir_seperator#out#dir_seperator#attachments#dir_seperator##file_name#">
		</cfif>
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
		#ust#<br/>
		#attributes.message#<br/>
		#alt#
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
		<cfset attributes.body = "#css##ust#<br/>#attributes.message#<br/>#alt#">
		<cfset attributes.type = 0>
		<cfset attributes.to = attributes.to_id>
		<cfset attributes.cc = attributes.cc_id>
		<cfinclude template="../query/add_mail.cfm">
	<script type="text/javascript">
		history.back();
	</script>
		<style type="text/css">
			.color-border	{background-color:##6699cc;}
			.color-row{	background-color: ##f1f0ff;}
			.color-list	{background-color: #E6E6FF;}
		</style>
	  <table style="text-align:center;" width="100%">
		<tr>
		  <td height="35" class="headbold">&nbsp;&nbsp;<cf_get_lang dictionary_id='57512.Workcube E-Mail'></td>
		</tr>
		<tr>
		  <td align="center" class="headbold"><cf_get_lang dictionary_id='57513.Mail Başarıyla Gönderildi'></td>
		</tr>
	  </table>
	<cfcatch type="any">
	<table style="text-align:center">
	  <tr>
		<td height="35" class="headbold">&nbsp;&nbsp;<cf_get_lang dictionary_id='57512.Workcube E-Mail'></td>
	  </tr>
	  <tr>
		<td align="center" class="headbold"><cf_get_lang dictionary_id='57618.Mail Göndermede Bir Hata Oldu Lütfen Verileri Kontrol Edip Sonra Tekrar Deneyiniz'></td>
	  </tr>
	</table>
	</cfcatch>
	</cftry>
	<script type="text/javascript">
			function waitfor(){
			  window.close();
			}
			setTimeout("waitfor()",3000);  
	</script>
<cfelse>
	<script type="text/javascript">
		/*
			var errorString = "Bu sayfayı görüntülemek için\nWindows95 ve Internet Explorer 5 veya üzeri gerekir.";
			var Ok = "false";
			var name =  navigator.appName;
			var version =  parseFloat(navigator.appVersion);
			var platform = navigator.platform;
			
			if (platform == "Win32" && name == "Microsoft Internet Explorer" && version >= 4){
				Ok = "true";
			} else {
				Ok= "false";
			}
			
			if (Ok == "false") {
				alert(errorString);
			}
		*/
	</script>
	<cfif isDefined("attributes.file")>
	<cfsavecontent variable="cont"><cfinclude template="#attributes.file#.cfm"></cfsavecontent>
	<cfset cont = wrk_content_clear(cont)> 
	</cfif>
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='57475.Mail Gönder'></cfsavecontent>
	<cf_box title="#title#" closable="1" draggable="1" popup_box="1">
		<cfform name="send_mail" enctype="multipart/form-data" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,".")#.popup_send_mail" method="post" >
			<input type="hidden" name="type" id="type" value="0">
			<cf_box_elements vertical="1">
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
					<div class="form-group" id="item-to">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32773.TO'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group" id_"names">
								<cfif isDefined("attributes.special_mail")>
									<cfset mails = ''>
									<cfif (attributes.special_mail contains '.') and (attributes.special_mail contains '@') and (Len(attributes.special_mail) gte 6)>
										<cfset mails = attributes.special_mail>
									</cfif>
								</cfif>
								<input type="hidden" name="to_id" id="to_id"<cfif isDefined("attributes.special_mail")> value="<cfoutput>#mails#</cfoutput>"</cfif>>
								<input type="text" name="to" id="to" <cfif isDefined("attributes.special_mail")> value="<cfoutput>#mails#</cfoutput>"<cfelseif isdefined("email")>value="<cfoutput>#email#</cfoutput>"</cfif>>
								<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
									<cfquery name="GET_MAILFROM" datasource="#dsn#">
										SELECT EMPLOYEE_EMAIL EMAIL_ FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.USERID#">
									</cfquery>
								<cfelse>
									<cfquery name="GET_MAILFROM" datasource="#dsn#">
										SELECT COMPANY_PARTNER_EMAIL EMAIL_ FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.USERID#">
									</cfquery>
								</cfif>
								<cfif Len(GET_MAILFROM.EMAIL_)>
									<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
										<cfset sender = "#session.ep.name# #session.ep.surname#<#GET_MAILFROM.EMAIL_#>">
									<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
										<cfset sender = "#session.pp.name# #session.pp.surname#<#GET_MAILFROM.EMAIL_#>">
									</cfif>
								<cfelse>
									<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
										<cfset sender = "#session.ep.company#<#session.ep.company_email#>">
									<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
										<cfset sender = "#session.pp.our_name#<#session.pp.our_company_email#>">
									</cfif>
								</cfif>
								<input type="hidden" name="from" id="from" value="<cfoutput>#sender#</cfoutput>" maxlength="50">
								<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_mail&mail_id=send_mail.to_id&names=send_mail.to','list')"></span>
							</div>
						</div>
					</div>	
					<div class="form-group" id="item-cc">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32774.CC'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group" id_"names">
								<input type="hidden" name="cc_id" id="cc_id">
								<input type="text" name="cc" id="cc">
								<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_mail&mail_id=send_mail.cc_id&names=send_mail.cc','list')"></span>
							</div>
						</div>
					</div>	
					<div class="form-group" id="item-bcc">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32945.BCC'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group" id_"names">
								<input type="hidden" name="bcc_id" id="bcc_id">
								<input type="text" name="bcc" id="bcc">
								<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_mail&mail_id=send_mail.bcc_id&names=send_mail.bcc','list')"></span>
							</div>
						</div>
					</div>	
					<div class="form-group" id="item-subject">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="subject" id="subject" value="<cfif isdefined('attributes.subject') and len(attributes.subject)><cfoutput>#attributes.subject#</cfoutput></cfif>">
						</div>
					</div>	
					<div class="form-group" id="item-attachment">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57515.Dosya Ekle'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="file" name="attachment" id="attachment">
						</div>
					</div>
					<cfparam name="attributes.content_body" default="">		
					<cfif isdefined("attributes.cntid")	and len(attributes.cntid)>
						<cfquery name="get_body" datasource="#dsn#">
							SELECT CONT_BODY FROM CONTENT WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cntid#">
						</cfquery>
						<cfset attributes.content_body=get_body.cont_body>
					</cfif>
					<div class="form-group">
						<cfmodule
							template="/fckeditor/fckeditor.cfm"
							toolbarSet="WRKContent"
							basePath="/fckeditor/"
							instanceName="message"
							valign="top"
							width="575"
							height="300"
							value="#attributes.content_body#"
							>
					</div>
				</div>
			</cf_box_elements>
				<div class="ui-form-list-btn">
					<cf_workcube_buttons type_format='1' is_upd='0' insert_info = 'Gönder' add_function='kontrol()'>
				</div>
		</cfform>
	</cf_box>
	<cfoutput>
		<script type="text/javascript">
			<cfif isDefined("attributes.editor_name")>
				document.all.message.value = window.opener.#attributes.editor_name#.value;
				document.send_mail.subject.value = window.opener.#attributes.editor_header#.value;
			</cfif>
			<cfif isDefined("attributes.editor_From")>
				document.send_mail.from.value = window.opener.#attributes.editor_From#.value;
			</cfif>
			function kontrol()
			{			
				if (document.send_mail.to.value == '')
				{
					alert("<cf_get_lang dictionary_id='34614.Gidecek Kişiler alanı boş olmamalı'>!!");
					return false;
				}
				return true;
			}
		</script>
	</cfoutput>
</cfif>
