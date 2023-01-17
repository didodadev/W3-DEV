<cfif isdefined('attributes.share_not') and attributes.share_not eq 1>
	<cfif len(attributes.company_id)>
        <cfquery name="GET_COMP_NAME" datasource="#DSN#">
            SELECT COMPANY_NAME FROM OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
        </cfquery>
    </cfif>
	<cfmail  
		to = "#attributes.receive_email#"
		from = "#attributes.sender_email#"
		subject = "Iconomy Group İş Fırsatı - Pozisyon Adı" type="HTML">
		<table width="698" height="523" border="0" style="background:url(http://cp.kariyerportal/documents/templates/newcareer/images/mail_sablon.jpg);font-size:12px;">
			<tr height="30">
				<td></td>
			</tr>
			<tr>
				<td rowspan="6" width="30"></td>
				<td>Merhaba!<br/>
					Arkadaşınız #attributes.sender_name# <a href="http://#cgi.HTTP_HOST#" target="_blank">Iconomy Kariyer Portal</a>'dan size bu iş fırsatını gönderdi :
				</td>
			</tr>
			<tr>
				<td class="headbold">
					şirket &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:
					<cfif len(attributes.company_id)>
                    	#get_comp_name.company_name#
                    </cfif><br/>
					konu &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:
					#attributes.detail#<br/>
					pozisyon :
					#attributes.position#
				</td>
			</tr>
			<tr>
				<td>Arkadaşınızın Mesajı :<br/>
					#attributes.receive_notes#		
				</td>
			</tr>
			<tr>
				<td>İlana ulaşmak için aşağıdaki linke tıklayın!<br/>
					<a href="#request.self#?fuseaction=objects2.dsp_notice&notice_id=#attributes.notice_id#" target="_blank">http://#cgi.HTTP_HOST#/#request.self#?fuseaction=objects2.dsp_notice&amp;notice_id=#attributes.notice_id#</a>
				</td>
			</tr>
			<tr height="40%">
				<td></td>
			</tr>
		</table>
	</cfmail>
    <cflocation url="#request.self#?fuseaction=objects2.welcome" addtoken="no">
<cfelse>
	<cfquery name="ADD_EMPAPP_MAIL" datasource="#DSN#">
		INSERT INTO
			EMPLOYEES_APP_MAILS
			(
				EMPAPP_ID,
				MAIL_CONTENT,
				EMPAPP_MAIL,
				RECORD_DATE,
				RECORD_IP,
				RECORD_APP
			)
			VALUES
			(
				#session.cp.userid#,
				<cfif isDefined('attributes.temp_detail')>'#attributes.temp_detail#'<cfelse>'#attributes.message_detail#'</cfif>,
				<cfif isDefined('attributes.temp_email')>'#attributes.temp_email#'<cfelse>'#attributes.email#'</cfif>,
				 #now()#,
				'#cgi.REMOTE_ADDR#',
				#session.cp.userid#
			)
	 </cfquery>
</cfif>
