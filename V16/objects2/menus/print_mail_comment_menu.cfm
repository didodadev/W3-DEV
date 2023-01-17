<script type="text/javascript">
	function connectAjax()
	{   
		var aaa = document.getElementById('my_email').value;
		if (((aaa == '') || (aaa.indexOf('@') == -1) || (aaa.indexOf('.') == -1) || (aaa.length < 6)))
			{ 
				alert("<cf_get_lang no='232.Geçerli Bir Mail Adresi Giriniz'> !");
				return false;
			}
		
		var bbb = document.getElementById('send_email').value;
		if (((bbb == '') || (bbb.indexOf('@') == -1) || (bbb.indexOf('.') == -1) || (bbb.length < 6)))
			{ 
				alert("<cf_get_lang no='232.Geçerli Bir Mail Adresi Giriniz'> !");
				return false;
			}
		
		my_name_ = document.getElementById('my_name').value;
		my_surname_ = document.getElementById('my_surname').value;
		my_email_ = document.getElementById('my_email').value;
		send_email_ = document.getElementById('send_email').value;
		comment_ = document.getElementById('comment').value;
		my_url_= '<cfoutput>#CGI.QUERY_STRING#</cfoutput>';
		var my_friend = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_add_content_webmail&my_name='+my_name_+'&my_surname='+my_surname_+'&my_email='+my_email_+'&send_email='+send_email_+'&comment='+comment_+'&my_url='+my_url_;
		AjaxPageLoad(my_friend,'my_islem');
	}
</script>

<table width="100%" cellpadding="0" cellspacing="0" border="0" border="0">
	<tr height="25" bgcolor="e5e5e5">
		<td width="150"><cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_operate_page&operation=emptypopup_temp_detail_content&action=print&id=#attributes.cid#&module=objects2','page');return false;">
				<img src="../objects2/image/print_content.gif" border="0" align="absmiddle">&nbsp;<cf_get_lang no='1536.Kağıda Bas'>
			</a></cfoutput>&nbsp;&nbsp;
		</td>
		<td width="150">
        	<a href="javascript://" onClick="gizle_goster(webmail);">
				<img src="../objects2/image/mail_content.gif" border="0" align="absmiddle">&nbsp;<cf_get_lang_main no='63.Mail Gönder'>
			</a>&nbsp;&nbsp;
		</td>
		<td>
			<a href="javascript://" onClick="gizle_goster(webcontent);">
				<img src="../objects2/image/yorum_content.gif" border="0" align="absmiddle">&nbsp;<cf_get_lang no='359.Yorum Ekle'>
			</a>&nbsp;&nbsp;
		</td>
	</tr>
</table>

<cfif isdefined("session.pp.userid")>
	<cfquery name="GET_UYE_" datasource="#DSN#">
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
	<cfquery name="GET_UYE_" datasource="#DSN#">
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
				<td><cf_get_lang_main no='219.Adınız'></td>
				<td><cfif get_uye_.recordcount>
						<input type="text" name="my_name" id="my_name" style="width:150px;" value="<cfoutput>#get_uye_.member_name#</cfoutput>">
					<cfelse>
						<input type="text" name="my_name" id="my_name" style="width:150px;"  value="">
					</cfif>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no='15.Soyadınız'></td>
				<td>
					<cfif get_uye_.recordcount>
						<input type="text" name="my_surname" id="my_surname" style="width:150px;"  value="<cfoutput>#get_uye_.member_surname#</cfoutput>">
					<cfelse>
						<input type="text" name="my_surname" id="my_surname" style="width:150px;"  value="">
					</cfif>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='16.E-mailiniz'></td>
				<td>
					<cfif get_uye_.recordcount>
						<input type="text" name="my_email" id="my_email" style="width:150px;"  value="<cfoutput>#get_uye_.member_email#</cfoutput>">
					<cfelse>
						<input type="text" name="my_email" id="my_email" style="width:150px;"  value="">
					</cfif>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no='358.Arkadaşınızın E-maili'></td>
				<td><input type="text" name="send_email" id="send_email" style="width:150px;" value=""></td>
			</tr>
			<tr>
				<td valign="top"><cf_get_lang_main no='359.Yorum'></td>
				<td><textarea name="comment" id="comment" rows="4" style="width:150px;"></textarea></td>
			</tr>
			<tr>
				<td colspan="2"  style="text-align:right;"><input type="button" value="Gönder" onClick="connectAjax()"></td>
			</tr>
		</table>
	</cfform>
</div>
<div id="my_islem"></div>

<div id="webcontent" style="display:none;">
    <cfform name="employe_detail" method="post" action="#request.self#?fuseaction=objects2.emptypopup_add_content_comment">
    <input type="hidden" name="content_id" id="content_id" value="<cfoutput>#attributes.cid#</cfoutput>">
	<input type="hidden" name="backType" id="backType" value="1" />
    <table>
        <tr>
			<td width="90"><cf_get_lang_main no='219.Adınız'>*</td>
          	<td>
				<cfif get_uye_.recordcount>
					<input type="text" name="name" id="name" style="width:150px;"  value="#get_uye_.member_name#">
				<cfelse>
					<cfsavecontent variable="alert"><cf_get_lang no ='219.Ad Girmelisiniz'></cfsavecontent>
					<cfinput type="text" name="name" id="name" style="width:150px;"  value="" required="Yes" message="#alert#">
				</cfif>
          	</td>
        </tr>
        <tr>
			<td><cf_get_lang no='15.Soyadınız'>*</td>
          	<td>
            	<cfif get_uye_.recordcount>
					<input type="text" name="surname" id="surname" style="width:150px;"  value="<cfoutput>#get_uye_.member_surname#</cfoutput>">
				<cfelse>
					<cfsavecontent variable="alert"><cf_get_lang no ='237.Soyad Girmelisiniz'></cfsavecontent>
					<cfinput type="text" name="surname" id="surname" style="width:150px;"  value="" required="Yes" message="#alert#">
				</cfif>
          	</td>
        </tr>
        <tr>
			<td><cf_get_lang_main no='16.e-mail'>*</td>
          	<td>
				<cfif get_uye_.recordcount>
					<input type="text" name="mail_address" id="mail_address" style="width:150px;"  value="<cfoutput>#get_uye_.member_email#</cfoutput>">
				<cfelse>
					<cfsavecontent variable="alert"><cf_get_lang no ='232.Email Girmelisiniz'></cfsavecontent>
					<cfinput type="text" name="mail_address" id="mail_address" style="width:150px;" value="" required="yes" message="#alert#">
				</cfif>
          	</td>
        </tr>
        <tr>
          	<td><cf_get_lang no='354.Puan'></td>
          	<td>
				<input name="content_comment_point" id="content_comment_point" type="radio" value="1">1
				<input name="content_comment_point" id="content_comment_point" type="radio" value="2">2
				<input name="content_comment_point" id="content_comment_point" type="radio" value="3">3
				<input name="content_comment_point" id="content_comment_point" type="radio" value="4">4
				<input name="content_comment_point" id="content_comment_point" type="radio" value="5" checked>5
          	</td>
        </tr>
        <tr>
            <td colspan="2"><cf_wrk_captcha name="captcha" action="display"></td>
        </tr>
        <tr>
			<td></td>
          	<td>
            	<textarea name="content_comment" id="content_comment" rows="7" style="width:200px;"></textarea>
         	</td>
        </tr>
		<tr>
            <td colspan="2" style="text-align:right;"><cf_workcube_buttons is_upd='0'></td>
        </tr>
    </table>
    </cfform>
</div>
<div id="my_islem"></div>
