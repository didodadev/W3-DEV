<cfif isdefined("session.pp.userid")>
	<cfquery name="GET_MEMBER" datasource="#DSN#">
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
	<cfquery name="GET_MEMBER" datasource="#DSN#">
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
	<cfset get_member.recordcount = 0>
</cfif>

<cfform name="add_maillist" method="post" action="#request.self#?fuseaction=objects2.popup_add_campaign_maillist&camp_id=#attributes.camp_id#">
    <table align="center" style="width:99%;">
        <tr>
            <td style="width:15%;"><cf_get_lang_main no='721.Fatura No'> :</td>
            <td><input type="text" name="paper_no" id="paper_no" style="width:250px;"></td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='219.Adı'> :</td>
            <td><cfif isdefined("session.ww.userid") and len(session.ww.userid)>
                    <input type="text" name="name" id="name" value="<cfoutput>#session.ww.name#</cfoutput>" maxlength="255" style="width:250px;" readonly>
                <cfelseif isdefined("session.pp.userid")>
                    <input type="text" name="name" id="name" value="<cfoutput>#session.pp.name#</cfoutput>" maxlength="255" style="width:250px;" readonly>
                <cfelse>
                    <input type="text" name="name" id="name" value="" maxlength="255" style="width:250px;">
                </cfif>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='1314.Soyadı'> :</td>
            <td><cfif isdefined("session.ww.userid") and len(session.ww.userid)>
                    <input type="text" name="surname" id="surname" value="<cfoutput>#session.ww.surname#</cfoutput>" maxlength="255" style="width:250px;" readonly>
                <cfelseif isdefined("session.pp.userid")>
                    <input type="text" name="surname" id="surname" value="<cfoutput>#session.pp.surname#</cfoutput>" maxlength="255" style="width:250px;" readonly>
                <cfelse>
                    <input type="text" name="surname" id="surname" value="" maxlength="255" style="width:250px;">
                </cfif>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='16.E-posta'> :</td>
            <td><cfif get_member.recordcount>
                    <input type="text" name="email" id="email" value="<cfoutput>#get_member.member_email#</cfoutput>" style="width:250px;">
                <cfelse>
                    <input type="text" name="email" id="email" value="" style="width:250px;">
                </cfif>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang no ='1138.Cep Telefonu'> :</td>
            <td><input type="text" name="tel_code" id="tel_code" maxlength="5" onkeyup="isNumber(this);" validate="integer" style=" width:75px;">
                <input type="text" name="tel" id="tel" maxlength="9" onkeyup="isNumber(this);" validate="integer" style="width:172px;">
            </td>
        </tr>
        <tr>
            <td style="vertical-align:top;"><cf_get_lang_main no='131.Mesajınız'> :</td>
            <td><textarea name="detail" id="detail" style="width:250px;; height:70px;"></textarea></td>
        </tr>
        <tr style="height:30px;">
            <td></td>
            <td><cf_workcube_buttons is_upd='0' add_function='control()'></td>
        </tr>
    </table>
</cfform>

<script type="text/javascript">
	function control()
	{
		if(document.getElementById('detail').value.length > 1000)
		{
			alert("<cf_get_lang no='43.Konu Alani En Fazla 1000 Karakter Olmalidir'> !");
			document.getElementById('detail').focus();
			return false;
		}
		if(document.getElementById('paper_no').value == "")
		{
			alert("<cf_get_lang no ='1139.Fatura No Boş Olamaz'> !");
			document.getElementById('paper_no').focus();
			return false;
		}
		if(document.getElementById('name').value == "")
		{
			alert("<cf_get_lang no ='219.Adı Dolu Olmalıdır'> !");
			document.getElementById('name').focus();
			return false;
		}
		if(document.getElementById('surname').value == "")
		{
			alert("<cf_get_lang no ='237.Soyadı Dolu Olmalidir'> !");
			document.getElementById('surname').focus();
			return false;
		}
		var aaa = document.getElementById('email').value;
		if (((aaa == '') || (aaa.indexOf('@') == -1) || (aaa.indexOf('.') == -1) || (aaa.length < 6)))
		{ 
			alert("<cf_get_lang no ='29.Geçerli Bir Mail Giriniz'> !");
			document.getElementById('email').focus();
			return false;
		}			  
	}
</script>
