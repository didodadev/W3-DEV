<!--- 
	TolgaS 20060419
	Dikkat edilecekler : 
	Bu dosya Satış Sipariş Süreci için  yapıldı
	Sipariş iptalde satış temsilcisi uyarılacak
	
	Iptal edilen siparisin satırları acik hale geliyor.
 --->
<cfif len(caller.attributes.order_employee_id)>
	<cfquery name="GET_EMP_POS" datasource="#attributes.data_source#">
		SELECT POSITION_CODE FROM #caller.dsn_alias#.EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=#caller.attributes.order_employee_id# AND IS_MASTER=1
	</cfquery>
	<cfif GET_EMP_POS.RECORDCOUNT>
		<cfset max_warning_date = attributes.record_date>
		<cfif len(get_process_type.answer_hour)>
			<cfset max_warning_date = date_add("h", get_process_type.answer_hour, attributes.record_date)>
		</cfif>
		<cfif len(get_process_type.answer_minute)>
			<cfset max_warning_date = date_add("n", get_process_type.answer_minute, attributes.record_date)>
		</cfif>
		<cfquery name="ADD_WARNING" datasource="#attributes.data_source#" result="GET_WARNINGS">
			INSERT INTO
				#process_db#PAGE_WARNINGS
				(
					URL_LINK,
					WARNING_HEAD,
					SETUP_WARNING_ID,
					WARNING_DESCRIPTION,
					SMS_WARNING_DATE,
					EMAIL_WARNING_DATE,
					LAST_RESPONSE_DATE,
					RECORD_DATE,
					IS_ACTIVE,
					IS_PARENT,
					RESPONSE_ID,
					RECORD_IP,
					RECORD_EMP,
					POSITION_CODE,
					WARNING_PROCESS
				)
			VALUES
				(
					'#attributes.action_page#',
					'#get_process_type.process_name# - #get_process_type.stage#',
					#get_process_type.process_row_id#,
					'<cfif len(get_process_type.detail)>#get_process_type.detail# - </cfif>#attributes.warning_description#',
					#max_warning_date#,
					#max_warning_date#,
					#max_warning_date#,
					#attributes.record_date#,
					1,
					1,
					0,
					'#cgi.remote_addr#',
					#session.ep.userid#,
					#GET_EMP_POS.POSITION_CODE#,
					1
				)
		</cfquery>
		<cfquery name="UPD_WARNINGS" datasource="#attributes.data_source#">
			UPDATE #process_db#PAGE_WARNINGS SET PARENT_ID = #get_warnings.IDENTITYCOL# WHERE W_ID = #get_warnings.IDENTITYCOL#			
		</cfquery>
	</cfif>
</cfif>
<!--- Siparisin satirlari acik yapiliyor --->
<cfquery name="UPD_ORDER_ACIK" datasource="#caller.dsn3#">
	UPDATE
		ORDER_ROW
	SET
		ORDER_ROW_CURRENCY  = -1
	WHERE
		ORDER_ID = #attributes.action_id#
</cfquery>
