<cfif len(attributes.sms_code) EQ 3 AND len(attributes.sms_tel) EQ 7>
	<cfif isdefined("attributes.consumer_id")>
		<cfquery name="ADD_SENT_CONT" datasource="#dsn#">
			INSERT INTO
				SEND_CONTENTS
				(
				CONT_ID,
				CONT_TYPE,
				SENT_CONS,
				SENT_DATE,
				RECORD_IP,
				SENDER_EMP
				)
			VALUES
				(
				#SMS_CONT_ID#,
				1,
				#attributes.partner_id#,
				#now()#,
				'#CGI.REMOTE_ADDR#',
				#SESSION.EP.USERID#
				)
			</cfquery>
	</cfif>
	
	<cfif isdefined("attributes.partner_id")>
		<cfquery name="ADD_SENT_CONT" datasource="#dsn#">
			INSERT INTO
				SEND_CONTENTS
				(
				CONT_ID,
				CONT_TYPE,
				SENT_CONS,
				SENT_DATE,
				RECORD_IP,
				SENDER_EMP
				)
			VALUES
				(
				#SMS_CONT_ID#,
				1,
				#attributes.partner_id#,
				#now()#,
				'#CGI.REMOTE_ADDR#',
				#SESSION.EP.USERID#
				)
			</cfquery>
	</cfif>
	
	<cfquery name="ADD_SMS_TO_SERVICE_DETAIL" datasource="#dsn3#"><!--- REPLY_TYPE(BIT): 1-MAIL 0-SMS --->
	INSERT INTO
		SERVICE_REPLY
		(SERVICE_ID, REPLY_HEAD, REPLY_DETAIL, REPLY_TYPE, RECORD_DATE, RECORD_EMP, RECORD_IP)
	VALUES
		(#attributes.service_id#, 'SMS', '#left(attributes.SMS_BODY,160)#', 0, #now()#, #session.ep.userid#, '#cgi.REMOTE_ADDR#')
	</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	alert("<cf_get_lang no ='331.SMS Gönderilmiştir'>.");
	window.close();
</script>
<cfelse>
<script type="text/javascript">
	alert("<cf_get_lang no='33.HATA ! SMS Gönderilemedi Cep Telefonu Numarasında Hata Var !'>");
	/*window.close();*/
	history.go(-1);
</script>

</cfif>				


