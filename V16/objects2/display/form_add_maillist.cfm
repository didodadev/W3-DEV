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

<cfform name="add_maillist" method="post" action="#request.self#?fuseaction=objects2.emptypopup_add_maillist">
    <table align="center" style="width:98%">	
        <tr>
            <td colspan="2">Workcube bilgilendirmelerini almak,<br/> etkinlik ve egitimlerimizden<br/> haberdar olmak için<br/> lütfen kayit olunuz.</td>
        </tr>
        <tr>
            <td style="width:60px;"><cf_get_lang_main no='219.Adi'> :</td>
            <td><cfif isdefined("session.ww.userid") and len(session.ww.userid)>
                    <input type="text" name="name" id="name" value="<cfoutput>#session.ww.name#</cfoutput>" maxlength="43" style="width:110px;" readonly/>
                <cfelseif isdefined("session.pp.userid")>
                    <input type="text" name="name" id="name" value="<cfoutput>#session.pp.name#</cfoutput>" maxlength="43" style="width:110px;" readonly/>
                <cfelse>
                    <input type="text" name="name" id="name" value="" maxlength="43" style="width:110px;"/>
                </cfif>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='1314.Soyadi'> :</td>
            <td><cfif isdefined("session.ww.userid") and len(session.ww.userid)>
                    <input type="text" name="surname" id="surname" value="<cfoutput>#session.ww.surname#</cfoutput>" maxlength="43" style="width:110px;" readonly/>
                <cfelseif isdefined("session.pp.userid")>
                    <input type="text" name="surname" id="surname" value="<cfoutput>#session.pp.surname#</cfoutput>" maxlength="43" style="width:110px;" readonly/>
                <cfelse>
                    <input type="text" name="surname" id="surname" value="" maxlength="43" style="width:110px;"/>
                </cfif>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='16.E-mail'> :</td>
            <td><cfif get_uye_.recordcount>
                    <input type="text" name="email" id="email" value="<cfoutput>#get_uye_.member_email#</cfoutput>" maxlength="50" style="width:110px;"/>
                <cfelse>
                    <input type="text" name="email" id="email" value="" maxlength="50" style="width:110px;"/>
                </cfif>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:top;"><cf_get_lang_main no='131.Mesajiniz'> :</td>
            <td><textarea name="detail" id="detail" style="width:110px;; height:70px;"></textarea></td>
        </tr>
        <tr>
            <td colspan="2"><cf_wrk_captcha name="captcha" action="display"></td>
        </tr>
        <tr>
            <td colspan="2">						
                <!---<input type="button" name="button1" value="Kayıt Ol" onClick="return control();">--->
                <input type="image" name="submit" src="../../objects2/image/mavi_gonder.jpg" value="<cf_get_lang no ='359.Yorum Ekle'>" onclick="return control();" style=" height:26px; width:104px;">&nbsp;<div id="show_info"></div></td>
            </td>
        </tr>
        <tr>
            <td colspan="2"><div id="list_my_contents"></div></td>
        </tr>
    </table>
</cfform>
<script type="text/javascript">
	function control()
	{
		/*if(document.add_maillist.detail.value.length > 1000)
		{
			alert("<cf_get_lang no='43.Konu Alani En Fazla 1000 Karakter Olmalidir'> !");
			return false;
		}*/
		if(document.getElementById('name').value == "")
		{
			alert("<cf_get_lang no ='219.Adi Dolu Olmalidir'> !");
			return false;
		}
		if(document.getElementById('surname').value == "")
		{
			alert("<cf_get_lang no ='237.Soyadi Dolu Olmalidir'> !");
			return false;
		}
		var aaa = document.getElementById('email').value;
		if (((aaa == '') || (aaa.indexOf('@') == -1) || (aaa.indexOf('.') == -1) || (aaa.length < 6)))
		{ 
			alert("<cf_get_lang_main no='1072.Geerli Bir Mail Giriniz '>!");
			return false;
		}	
		AjaxFormSubmit('add_maillist','show_info','1','Kaydediliyor','Kayıt Alındı','<cfoutput>#request.self#?fuseaction=objects2.emptypopup_add_maillist</cfoutput>','list_my_contents');	
		return false;	  
	}
</script>
