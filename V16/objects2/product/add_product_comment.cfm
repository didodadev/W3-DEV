<cfsetting showdebugoutput="no">
<script language="javascript" type="text/javascript">
	function add_product_comment()
	{  
		if(document.getElementById('product_comment').value == '')
		{
			alert("<cf_get_lang no ='1306.Lütfen Yorumunuzu Yazınız'>!");
			return false;
		}
		if(document.getElementById('name').value == '')
		{
			alert("<cf_get_lang no ='1290.Lütfen Adınızı Giriniz'>!");
			return false;
		}
		if(document.getElementById('surname').value == '')
		{
			alert("<cf_get_lang no ='237.Lütfen Soyadınızı Giriniz'>!");
			return false;
		}
		var aaa = document.getElementById('mail_address').value;
		if (((aaa == '') || (aaa.indexOf('@') == -1) || (aaa.indexOf('.') == -1) || (aaa.length < 6)))
			{ 
				alert("<cf_get_lang_main no='1072.Geçerli Bir Mail Adresi Giriniz'> !");
				return false;
			}
		
		var bbb = document.getElementById('mail_address').value;
		if (((bbb == '') || (bbb.indexOf('@') == -1) || (bbb.indexOf('.') == -1) || (bbb.length < 6)))
			{
				alert("<cf_get_lang_main no='1072.Geçerli Bir Mail Adresi Giriniz'> !");
				return false;
			}
		
		my_pid_ = document.getElementById('product_id').value;
		my_comment_ = document.getElementById('product_comment').value;
		my_name_ = document.getElementById('name').value;
		my_surname_ = document.getElementById('surname').value;
		my_email_ = document.getElementById('mail_address').value;
		my_comment_point_ = document.getElementById('product_comment_point').value;
		var my_product_comment = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_add_product_comment&my_name='+my_name_+'&my_surname='+my_surname_+'&my_email='+my_email_+'&my_comment='+my_comment_+'&my_pid='+my_pid_+'&my_comment_point='+my_comment_point_;
		AjaxPageLoad(my_product_comment,'my_islem');
		//document.getElementById('my_comment_add').style.display ='none';
		alert('Yorum Eklendi!');
		//yorum_kapat();
	}
</script>

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
<cf_box title="Yorum Ekle" id="my_comment_add">
<table width="99%" align="center">
<tr>
	<td colspan="2"  style="text-align:right;"><a href="javascript://" onClick="yorum_kapat();" class="comment_close"></a></td>
</tr>
	<input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.pid#</cfoutput>">
    <tr>
  		<td valign="top"><cf_get_lang_main no ='2008.Yorum'></td>
        <td><textarea name="product_comment" id="product_comment" style=" width:200px; height:100px;"></textarea></td>
	</tr>
	<tr>
	  <td width="75"><cf_get_lang no ='1308.Adınız'> *</td>
	  <td>
		<cfif isdefined("session.ww.name")>
		  <input type="text" name="name" id="name" style="width:150px;" maxlength="50" readonly value="<cfoutput>#session.ww.name#</cfoutput>">
		<cfelseif isdefined("session.pp.name")>
		 <input type="text" name="name" id="name" style="width:150px;" maxlength="50" readonly value="<cfoutput>#session.pp.name#</cfoutput>">
		 <cfelse>
		  <input type="text" name="name" id="name" style="width:150px;" maxlength="50" required="Yes">
		</cfif>
	  </td>
	</tr>
	<tr>
	  <td><cf_get_lang no ='1309.Soyadınız'>*</td>
	  <td>
		<cfif isdefined("session.ww.surname")>
		  <input type="text" name="surname" id="surname" style="width:150px;" maxlength="50" readonly value="<cfoutput>#session.ww.surname#</cfoutput>">
		 <cfelseif isdefined("session.pp.name")>
		 <input type="text" name="surname" id="surname" style="width:150px;" maxlength="50" readonly value="<cfoutput>#session.pp.surname#</cfoutput>">
		  <cfelse>
		  <input type="text" name="surname" id="surname" style="width:150px;" maxlength="50" required="Yes">
		</cfif>
	  </td>
	</tr>
	<tr>
	  <td>e-mail*</td>
	  <td>
	  	<cfif get_uye_.recordcount>
			<input type="text" name="mail_address" id="mail_address" value="<cfoutput>#get_uye_.member_email#</cfoutput>" style="width:150px;" maxlength="100" required="yes" message="Email Girmelisiniz!">
		<cfelse>
			<input type="text" name="mail_address" id="mail_address" style="width:150px;" maxlength="100" required="yes">
		</cfif>
	  </td>
	</tr>
	<tr>
	  <td><cf_get_lang_main no='1572.Puan'></td>
	  <td>
		<select name="product_comment_point" id="product_comment_point" style="width:150px;">
        	<option value="1">1 <cf_get_lang_main no='1572.Puan'></option>
            <option value="2">2 <cf_get_lang_main no='1572.Puan'></option>
            <option value="3">3 <cf_get_lang_main no='1572.Puan'></option>
            <option value="4">4 <cf_get_lang_main no='1572.Puan'></option>
            <option value="5" selected="selected">5 <cf_get_lang_main no='1572.Puan'></option>
        </select>
	  </td>
	</tr>
	<tr>
		<td></td>
  		<td height="35">
            <input type="button" value="<cf_get_lang_main no ='170.Ekle'>" onClick="add_product_comment()">
  		</td>
	</tr>
</table>
</cf_box>
<div id="my_islem"></div>


