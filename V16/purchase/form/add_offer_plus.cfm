<cfset xfa.add = "purchase.emptypopup_add_plus">
<cfinclude template="../query/get_commethods.cfm">
<cfsavecontent variable="title"><cf_get_lang dictionary_id='38587.Teklif Takip'></cfsavecontent>
<cf_popup_box title="#title#">
	<cfform name="add_offer_meet" method="post" action="#request.self#?fuseaction=#xfa.add#">
	<input type="hidden" name="offer_id" id="offer_id" value="<cfoutput>#url.offer_id#</cfoutput>">
	<input type="hidden" name="plus_type" id="plus_type" iplus_type value="<cfoutput>#attributes.plus_type#</cfoutput>">
	<input type="hidden" id="clicked" value="">
		<table>
			<tr>
				<td width="50">&nbsp;<cf_get_lang dictionary_id='57428.Email'></td>
				<td width="210">
					<input type="hidden" name="employee_emails" id="employee_emails" value="">
					<input type="hidden" name="employee_id" id="employee_id">
					<input type="text" name="employee_names" id="employee_names" style="width:190px;" value="">
					<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_mail&mail_id=add_offer_meet.employee_emails&names=add_offer_meet.employee_names','list');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
				</td>
				<td width="100">
					<cfsavecontent variable="alert"><cf_get_lang dictionary_id ='57742.Tarih'></cfsavecontent>
					<cfinput type="text" name="plus_date" style="width:65px;" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" maxlength="10" message="#alert#">
					<cf_wrk_date_image date_field="plus_date">
				</td>
				<td><select name="commethod_id" id="commethod_id" style="width:150px;">
					<option value="0" selected><cf_get_lang dictionary_id='58090.İletişim Yöntemi'></option>
						<cfoutput query="get_commethods">
							<option value="#commethod_id#">#commethod#</option>
						</cfoutput>
					</select>
				</td>
			</tr>
			<tr> 
				<td>&nbsp;<cf_get_lang dictionary_id='57480.Başlık'>*</td>
				<td colspan="2"><input type="text" name="header" id="header" style="width:301px;" value=""></td>
				<td><cfinclude template="../query/get_pursuit_templates.cfm">
					<select name="pursuit_templates" id="pursuit_templates" onChange="document.add_offer_meet.action = '';document.add_offer_meet.submit();" style="width:150px;">
						<option value="-1"><cf_get_lang dictionary_id='38643.Şablon Seçiniz'></option>
						<cfoutput query="GET_PURSUIT_TEMPLATES">
							<option value="#TEMPLATE_ID#"<cfif isDefined("attributes.pursuit_templates") and (attributes.pursuit_templates eq TEMPLATE_ID)> selected</cfif>>#TEMPLATE_HEAD#</option>
						</cfoutput>
					</select>					  
				</td>
			</tr>			  
			<tr>
			<td valign="top" colspan="4">
				<cfmodule
				template="/fckeditor/fckeditor.cfm"
				toolbarSet="WRKContent"
				basePath="/fckeditor/"
				instanceName="plus_content"
				valign="top"
				value=""
				width="550"
				height="300">
			</td>
			</tr>
		</table>
		<cf_popup_box_footer>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='38496.Kaydet ve Mail Gönder'></cfsavecontent>
			<cf_workcube_buttons type_format='1' is_upd='0' insert_info='#message#' is_cancel='0' add_function="control2()" insert_alert=''>
			<cf_workcube_buttons type_format='1' is_upd='0' add_function='control()'>
		</cf_popup_box_footer>
	</cfform>
</cf_popup_box>
<cfif isDefined("header")>
<script type="text/javascript">
	<cfif isdefined("attributes.header") and len(attributes.header)>
		document.add_offer_meet.header.value = '<cfoutput>#attributes.header#</cfoutput>';
	<cfelse>
		document.add_offer_meet.header.value = '';
	</cfif>
	<cfif isDefined("attributes.contact_mail") and (attributes.contact_mail NEQ '')> 
	 document.add_offer_meet.employee_emails.value = '<cfoutput>#attributes.contact_mail#</cfoutput>';
	 document.add_offer_meet.employee_names.value = '<cfoutput>#attributes.contact_mail#</cfoutput>';
	</cfif> 
	 document.add_offer_meet.employee_id.value = '<cfoutput>#session.ep.userid#</cfoutput>';
	 
	 function control(){
		 
		 var aaa = document.add_offer_meet.employee_names.value;
		 if (((aaa == '') || (aaa.indexOf('@') == -1) || (aaa.indexOf('.') == -1) || (aaa.length < 6)) && (document.add_offer_meet.clicked.value == '&email=true'))
		 { 
				   alert("<cf_get_lang dictionary_id ='58484.Lütfen mail alanına geçerli bir mail giriniz'>!!");
				   document.add_offer_meet.action = "<cfoutput>#request.self#?fuseaction=#xfa.add#</cfoutput>"; 
				   return false;
		 }			  
		 
		 return true;
	 }
	 
	 function control2(){
		 add_offer_meet.action = add_offer_meet.action + '&email=true';
		 add_offer_meet.submit();
		 return false;
	 }	 
	 	 
	<cfset attributes.pursuit_template_id = -1>
	<cfif isDefined("attributes.pursuit_templates")>
		<cfset attributes.pursuit_template_id = attributes.pursuit_templates>
	</cfif>
	<cfinclude template="../query/get_pursuit_templates.cfm">	
	document.all.plus_content.value = '<cfoutput>#GET_PURSUIT_TEMPLATES.TEMPLATE_CONTENT#</cfoutput>';	 
</script>
</cfif>
