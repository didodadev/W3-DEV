<script type="text/javascript">
	function connectAjax()
	{
		var aaa = document.webmail_form.my_email.value;
		if (((aaa == '') || (aaa.indexOf('@') == -1) || (aaa.indexOf('.') == -1) || (aaa.length < 6)))
			{ 
				alert("<cf_get_lang_main no='1072.Geçerli Bir Mail Adresi Giriniz'> !");
				return false;
			}
		
		var bbb = document.webmail_form.send_email.value;
		if (((bbb == '') || (bbb.indexOf('@') == -1) || (bbb.indexOf('.') == -1) || (bbb.length < 6)))
			{ 
				alert("<cf_get_lang_main no='1072.Geçerli Bir Mail Adresi Giriniz'> !");
				return false;
			}
		
		my_name_ = document.webmail_form.my_name.value;
		my_surname_ = document.webmail_form.my_surname.value;
		my_email_ = document.webmail_form.my_email.value;
		send_email_ = document.webmail_form.send_email.value;
		comment_ = document.webmail_form.comment.value;
		cid = document.webmail_form.cid.value;
		my_url_= '<cfoutput>#CGI.QUERY_STRING#</cfoutput>';
		var my_friend = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_add_content_webmail&my_name='+my_name_+'&my_surname='+my_surname_+'&my_email='+my_email_+'&cid='+cid+'&send_email='+send_email_+'&comment='+comment_+'&my_url='+my_url_;
		AjaxPageLoad(my_friend,'my_islem');
	}
</script>
<table>
	<tr>
		<td>
			<a href="javascript://" onClick="gizle_goster(webmail);" class="Headerfriend">
				<cf_get_lang_main no='63.Mail Gönder'>
			</a>
		</td>
   </tr>
</table>

<cfif isdefined("session.pp.userid")>
	<cfquery name="get_uye_" datasource="#dsn#">
		SELECT 
			COMPANY_PARTNER_NAME AS MEMBER_NAME,
			COMPANY_PARTNER_SURNAME AS MEMBER_SURNAME,
			COMPANY_PARTNER_EMAIL AS MEMBER_EMAIL
		FROM 
			COMPANY_PARTNER 
		WHERE 
			PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
	</cfquery>
<cfelseif isdefined("session.ww.userid")>
	<cfquery name="get_uye_" datasource="#dsn#">
		SELECT 
			CONSUMER_NAME AS MEMBER_NAME,
			CONSUMER_SURNAME AS MEMBER_SURNAME,
			CONSUMER_EMAIL AS MEMBER_EMAIL
		FROM 
			CONSUMER 
		WHERE 
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
	</cfquery>
<cfelse>
	<cfset get_uye_.recordcount = 0>
</cfif>

<div id="webmail" style="display:none;">
<cfform name="webmail_form" method="post">
	<table>
		<tr>
		<cfif isdefined('get_content_prod')>
			<input type="hidden" name="cid" id="cid" value="<cfoutput>#get_content_prod.content_id#</cfoutput>">
		<cfelseif isdefined('attributes.cid')>
		    <input type="hidden" name="cid" id="cid" value="<cfoutput>#attributes.cid#</cfoutput>">
		</cfif>
			<td><cf_get_lang_main no='219.Adınız'></td>
			<td><cfif get_uye_.recordcount>
					<input type="text" name="my_name" id="my_name" value="<cfoutput>#get_uye_.member_name#</cfoutput>">
				<cfelse>
					<input type="text" name="my_name" id="my_name" value="">
				</cfif>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='1314.Soyadınız'></td>
			<td>
				<cfif get_uye_.recordcount>
					<input type="text" name="my_surname" id="my_surname" value="<cfoutput>#get_uye_.member_surname#</cfoutput>">
				<cfelse>
					<input type="text" name="my_surname" id="my_surname" value="">
				</cfif>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='16.E-mailiniz'></td>
			<td>
				<cfif get_uye_.recordcount>
					<input type="text" name="my_email" id="my_email" value="<cfoutput>#get_uye_.member_email#</cfoutput>">
				<cfelse>
					<input type="text" name="my_email" id="my_email" value="">
				</cfif>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang no='358.Arkadaşınızın E-maili'></td>
			<td><input type="text" name="send_email" id="send_email" value=""></td>
		</tr>
		<tr>
			<td valign="top"><cf_get_lang_main no='359.Yorum'></td>
			<td><textarea name="comment" id="comment" rows="4"></textarea></td>
		</tr>
		<tr>
			<td colspan="2"  style="text-align:right;"><input type="button" value="Gönder" onClick="connectAjax()"></td>
		</tr>
	</table>
</cfform>
</div>
<div id="my_islem"></div>
