<cfscript>
k=0;
</cfscript>	
<cfquery name="ALERTS" datasource="#dsn#">
	SELECT 
		EVENT_ID,
		EVENT_HEAD,
		STARTDATE,
		FINISHDATE,
		EVENT_TO_PAR,
		EVENT_TO_POS,
		EVENT_TO_CON,
		EVENT_TO_GRP,
		EVENT_CC_PAR,
		EVENT_CC_POS,
		EVENT_CC_CON,
		EVENT_CC_GRP
	FROM 
		EVENT
	WHERE
		WARNING_EMAIL <= #now()# AND
		EMAIL_WARNED = 0
</cfquery>

<cfquery name="SET_EMAIL_WARNED" datasource="#dsn#">
	UPDATE EVENT SET EMAIL_WARNED = 1 WHERE EVENT_ID <= #now()#
</cfquery>
<cfloop QUERY="ALERTS">
	<font color="red"><cfoutput><b>#event_id#</b> : #event_head#</cfoutput></font><HR>
	<cfscript>
		k=k+1;
		to_par = ALERTS.EVENT_TO_PAR[k];
		to_pos = ALERTS.EVENT_TO_POS[k];
		to_con = ALERTS.EVENT_TO_CON[k];
		to_grp = ALERTS.EVENT_TO_GRP[k];
		cc_par = ALERTS.EVENT_CC_PAR[k];
		cc_pos = ALERTS.EVENT_CC_POS[k];
		cc_con = ALERTS.EVENT_CC_CON[k];
		cc_grp = ALERTS.EVENT_CC_GRP[k];
		event = ALERTS.EVENT_HEAD[k];
		startdate = dateformat(ALERTS.startdate[k],dateformat_style);
		finishdate = ALERTS.finishdate[k];
	</cfscript>
	<cfif len(listsort(TO_GRP,"Numeric"))>
		<cfquery name="TO_GRPS" datasource="#dsn#">
			SELECT POSITIONS, PARTNERS, CONSUMERS FROM USERS WHERE GROUP_ID IN (#listsort(TO_GRP,"Numeric")#)
		</cfquery>
		<cfset to_pos = "#TO_POS#,#valuelist(TO_grps.POSITIONS)#">
		<cfset to_par = "#TO_par#,#valuelist(TO_grps.partners)#">
		<cfset to_con = "#TO_con#,#valuelist(TO_grps.consumers)#">
	</cfif>
	<cfif len(CC_GRP)>
		<cfquery name="CC_GRPS" datasource="#dsn#">
			SELECT EMPLOYEES, PARTNERS, CONSUMERS FROM USERS WHERE GROUP_ID IN (#CC_GRP#)
		</cfquery>
		<cfset cc_pos = "#CC_POS#,#valuelist(cc_grps.employees)#">
		<cfset cc_par = "#cc_par#,#valuelist(cc_grps.partners)#">
		<cfset cc_con = "#cc_con#,#valuelist(cc_grps.consumers)#">
	</cfif>

	<cfset to_pos = ListAppend(Listsort(ListDeleteDuplicatesNoCase("#TO_POS#,#CC_POS#"),"Numeric"),"0")>
	<cfset to_par = ListAppend(ListSort(ListDeleteDuplicatesNoCase("#to_par#,#CC_PAR#"),"Numeric"),"0")>
	<cfset to_con = ListAppend(ListSort(ListDeleteDuplicatesNoCase("#to_con#,#CC_CON#"),"Numeric"),"0")>
	<cfquery name="EMPLOYEE_EMAILS" datasource="#dsn#">
		SELECT 
			EMPLOYEE_EMAIL,
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME
		FROM
			EMPLOYEE_POSITIONS
		WHERE
			EMPLOYEE_EMAIL IS NOT NULL AND
			POSITION_ID IN (#TO_POS#) AND
			POSITION_STATUS = 1
	</cfquery>
		
		<cfquery name="PARTNER_EMAILS" datasource="#dsn#">
			SELECT 
				COMPANY_PARTNER_EMAIL,
				COMPANY_PARTNER_NAME,
				COMPANY_PARTNER_SURNAME
			FROM
				COMPANY_PARTNER
			WHERE
				COMPANY_PARTNER_EMAIL IS NOT NULL AND
				PARTNER_ID IN (#TO_PAR#)
		</cfquery>
	
		<cfquery name="consumer_EMAILS" datasource="#dsn#">
			SELECT 
				CONSUMER_EMAIL,
				CONSUMER_NAME,
				CONSUMER_SURNAME
			FROM
				CONSUMER
			WHERE
				CONSUMER_EMAIL IS NOT NULL AND
				CONSUMER_ID IN (#TO_con#)
		</cfquery>
	
		<cfloop QUERY="EMPLOYEE_EMAILS">
			<cfif len(trim(employee_email))>
				<CFMAIL TO='"#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#"<#EMPLOYEE_EMAIL#>'
					FROM='#listlast(server_detail)#<#listfirst(server_detail)#>' type='html'
					<!---SERVER='#MAIL_SERVER#' --->
					SUBJECT='#EVENT# İÇİN UYARI'>
					#STARTDATE# tarihinde #EVENT# olayı var !
				</CFMAIL>
				<cfoutput>#employee_email#<br/></cfoutput>
			</cfif>
		</cfloop>

		<cfloop QUERY="PARTNER_EMAILS">
			<cfif len(COMPANY_PARTNER_EMAIL)>
				<CFMAIL type='html' 
					FROM='#listlast(server_detail)#<#listfirst(server_detail)#>' 
					TO='"#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME#"<#COMPANY_PARTNER_EMAIL#>' 
					<!---SERVER='#MAIL_SERVER#'---> 
					SUBJECT='#EVENT# İÇİN UYARI'>
					#STARTDATE# tarihinde #EVENT# olayı var !
				</CFMAIL>
				<cfoutput>#company_partner_email#<br/></cfoutput>
			</cfif>
		</cfloop>

		<cfloop QUERY="consumer_EMAILS">
			<cfif len(consumer_EMAIL)>
				<CFMAIL type='html' 
					FROM='#listlast(server_detail)#<#listfirst(server_detail)#>' 
					TO='#CONSUMER_NAME# #CONSUMER_SURNAME#<#consumer_EMAIL#>' 
					<!---SERVER='#MAIL_SERVER#' --->
					SUBJECT='#EVENT# İÇİN UYARI'>
					#STARTDATE# tarihinde #EVENT# olayı var !
				</CFMAIL>
				<cfoutput>#consumer_email#<br/></cfoutput>
			</cfif>
		</cfloop>

</cfloop>
<!--- fbs 20120313 sms ile ilgili kisim calismadigindan kaldirildi --->
