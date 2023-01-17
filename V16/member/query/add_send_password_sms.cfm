<!--- Bu sayfa add_send_sms include edilecek sekilde duzenlenebilir, bakilacak FBS 20110428 (sorun sms_body ile sms_body_control farkli olmasi) --->
<cfset sms_send_date=date_add('h',session.ep.time_zone, now())>
<cfquery name="use_webservice_control" datasource="#dsn#">
	SELECT IS_SMS FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.ep.company_id#
</cfquery>
<cfquery name="get_consumer_info" datasource="#dsn#">
	SELECT MEMBER_CODE,CONSUMER_SURNAME,MOBIL_CODE+MOBILTEL AS MOBILPHONE FROM CONSUMER WHERE CONSUMER_ID = #attributes.member_id#
</cfquery>
<cfquery name="get_cp_control_password" datasource="#dsn#">
	SELECT * FROM CP_CONTROL WHERE CONSUMER_ID = #attributes.member_id#
</cfquery>
<cfif not get_cp_control_password.recordcount>
	<script type="text/javascript">
        alert("Temsilci şifre bilgisini kontrol ediniz.");
        window.close();
    </script>
    <cfabort>
</cfif>

<cfoutput>
<cfsavecontent variable="sms_body">Sayın #get_consumer_info.consumer_surname#, Temsilci Kodunuz: #get_consumer_info.member_code#, Internet Şifreniz: ****** dir. www.doreonline.com.tr Adresimizden Siparişlerinizi Girebilirsiniz.</cfsavecontent>
<cfsavecontent variable="sms_body_control">Sayın #get_consumer_info.consumer_surname#, Temsilci Kodunuz: #get_consumer_info.member_code#, Internet Şifreniz: #get_cp_control_password.consumer_password# dir. www.doreonline.com.tr Adresimizden Siparişlerinizi Girebilirsiniz.</cfsavecontent>
</cfoutput>

<cfset send_sms = 1>

<cftry>
	<cfif len(get_cp_control_password.consumer_password) and len(get_consumer_info.MOBILPHONE)>
		<cfquery name="ADD_SMS_SEND_RECEIVE" datasource="#dsn3#">
			INSERT INTO
				SMS_SEND_RECEIVE
			(
				IS_SEND_RECEIVE,
				PHONE_NUMBER, 
				SMS_STATUS,
				SMS_BODY,
				SEND_DATE,
				RECEIVE_CONSUMER_ID,
				PAPER_PERIOD_ID,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)
			VALUES
			(
				0,
				 '#get_consumer_info.mobilphone#', 
				0,
				 '#sms_body#',
				#sms_send_date#,
				<cfif attributes.member_type eq 'consumer'>#attributes.member_id#<cfelse>NULL</cfif>,
				<cfif isdefined("session.ep.period_id")>#session.ep.period_id#<cfelse>NULL</cfif>,
				<cfif isdefined("session.ep.userid")>#session.ep.userid#<cfelse>NULL</cfif>,
				#now()#,
				'#cgi.remote_addr#'
			)
		</cfquery>
		<cfif len(use_webservice_control.is_use_sms_webservice) and use_webservice_control.is_use_sms_webservice eq 1>
			<cfset _PhoneNumber_ = get_consumer_info.mobilphone>
			<cfset  _Message_ = sms_body_control> 
			<cfset _StatusControl_ = 1>
			<cfset _SendDate_ = sms_send_date>
			<cfset _DeleteDate_ = "">
			<cfinclude template="../../objects/query/send_sms_web_service.cfm">  
		</cfif>
	</cfif>
	<cfcatch type="any">
		<cfset send_sms = 0>
	</cfcatch>
</cftry>
<cf_popup_box title="Workcube SMS">
	<table width="90%">
    	<tr>
        	<td><cfif send_sms eq 1>SMS Başarıyla Gönderildi.<cfelse>SMS Gönderiminde Sorun Oluştu. Lütfen Daha Sonra Tekrar Deneyiniz.</cfif></td>
        </tr>
    </table>
</cf_popup_box>
<script type="text/javascript">
	function waitfor()
	{
		window.close();
	}
	setTimeout("waitfor()",3000);  
</script>
