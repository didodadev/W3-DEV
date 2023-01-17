<cfinclude template="../../objects/inc_func_cfquery.cfm">
<cfinclude template="../../objects/inc_func_cfhttp.cfm">
<cfinclude template="events.cfm">

<cfquery name="ALERT" datasource="#dsn#">
	SELECT 
		W_ID,
		WARNING_HEAD,
		URL_LINK,
		EMAIL_WARNING_DATE,
		PARTNER_ID,
		POSITION_CODE,
		RECORD_EMP,
		RECORD_PAR,
		RECORD_CON
	FROM 
		PAGE_WARNINGS
	WHERE
		EMAIL_WARNING_DATE <= #now()# AND
		EMAIL_WARNED = 0
</cfquery>
<cfloop QUERY="ALERT">
	<font color="red"><cfoutput><b>#WARNING_HEAD#</b></cfoutput></font><HR>
	<cfif len(alert.record_emp)>
		<cfquery name="EMPLOYEE_EMAILS" datasource="#dsn#">
			SELECT 
				EMPLOYEE_EMAIL,
				EMPLOYEE_NAME,
				EMPLOYEE_SURNAME
			FROM
				EMPLOYEE_POSITIONS
			WHERE
				EMPLOYEE_EMAIL IS NOT NULL AND
				(
				EMPLOYEE_ID = #ALERT.RECORD_EMP#
				<cfif len(ALERT.POSITION_CODE)>
					OR POSITION_CODE = #ALERT.POSITION_CODE#
				</cfif>
				)
				AND POSITION_STATUS = 1
		</cfquery>
		
		<cfloop QUERY="EMPLOYEE_EMAILS">
			<cfif len(employee_email)>
				<CFMAIL 
					type='html' 
					FROM='#listlast(server_detail)#<#listfirst(server_detail)#>' 
					TO='"#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#"<#EMPLOYEE_EMAIL#>' 
					SERVER='#MAIL_SERVER#' 
					SUBJECT='Sayfa Hatırlatması : #alert.WARNING_HEAD# '>
					Sayın #EMPLOYEE_NAME# #EMPLOYEE_SURNAME#,<br/>
					#dateformat(alert.EMAIL_WARNING_DATE,dateformat_style)# - #timeformat(alert.EMAIL_WARNING_DATE,'HH:MM')# tarihinde <br/>
					<a href="#alert.url_link#" target="_blank">#alert.url_link#</a> sayfasının hatırlatılmasını istemiştiniz.
				</CFMAIL>
				<cfoutput>#employee_email#<br/></cfoutput>
			</cfif>
		</cfloop>
	</cfif>
	
	<cfif len(alert.record_par)>
		<cfquery name="PARTNER_EMAILS" datasource="#dsn#">
			SELECT 
				COMPANY_PARTNER_EMAIL,
				COMPANY_PARTNER_NAME,
				COMPANY_PARTNER_SURNAME
			FROM
				COMPANY_PARTNER
			WHERE
				COMPANY_PARTNER_EMAIL IS NOT NULL AND
				(
					PARTNER_ID = #alert.record_par#
					<cfif len(ALERT.partner_id)>
						OR PARTNER_ID = #ALERT.PARTNER_ID#
					</cfif>
				)
		</cfquery>
	
		<cfloop QUERY="PARTNER_EMAILS">
			<cfif len(COMPANY_PARTNER_EMAIL)>
				<CFMAIL type='html' 
					FROM='#listlast(server_detail)#<#listfirst(server_detail)#>' 
					TO='"#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME#"<#COMPANY_PARTNER_EMAIL#>' 
					SERVER='#MAIL_SERVER#' 
					SUBJECT='Sayfa Hatırlatması : #alert.WARNING_HEAD# '>
					Sayın #COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME#,<br/>
					#dateformat(alert.EMAIL_WARNING_DATE,dateformat_style)# - #timeformat(alert.EMAIL_WARNING_DATE,'HH:MM')# tarihinde <br/>
					<a href="#alert.url_link#" target="_blank">#alert.url_link#</a> sayfasının hatırlatılmasını istemiştiniz.
				</CFMAIL>
				<cfoutput>#company_partner_email#<br/></cfoutput>
			</cfif>
		</cfloop>
	</cfif>
	
	<cfif len(alert.record_con)>
		<cfquery name="consumer_EMAILS" datasource="#dsn#">
			SELECT 
				CONSUMER_EMAIL,
				CONSUMER_NAME,
				CONSUMER_SURNAME
			FROM
				CONSUMER
			WHERE
				CONSUMER_EMAIL IS NOT NULL AND
				CONSUMER_ID = #alert.record_con#
		</cfquery>
		<cfloop QUERY="consumer_EMAILS">
			<cfif len(consumer_EMAIL)>
				<CFMAIL type='html' 
					FROM='#listlast(server_detail)#<#listfirst(server_detail)#>' 
					TO='"#consumer_NAME# #consumer_SURNAME#"<#consumer_EMAIL#>' 
					SERVER='#MAIL_SERVER#' 
					SUBJECT='Sayfa Hatırlatması : #alert.WARNING_HEAD# '>
					Sayın #consumer_NAME# #consumer_SURNAME#,<br/>
					#dateformat(alert.EMAIL_WARNING_DATE,dateformat_style)# - #timeformat(alert.EMAIL_WARNING_DATE,'HH:MM')# tarihinde <br/>
					<a href="#employee_domain##alert.url_link#" target="_blank">#employee_domain##alert.url_link#</a> sayfasının hatırlatılmasını istemiştiniz.
				</CFMAIL>
				<cfoutput>#consumer_email#<br/></cfoutput>
			</cfif>
		</cfloop>
	</cfif>

	<cfquery name="SET_EMAIL_WARNED" datasource="#dsn#">
		UPDATE PAGE_WARNINGS SET EMAIL_WARNED=1 WHERE W_ID=#ALERT.W_ID#
	</cfquery>
</cfloop>
<!--- fbs 20120313 sms ile ilgili kisim calismadigindan kaldirildi --->
