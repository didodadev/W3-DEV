<!--- Eklendigi Asamanin Satirlarini Iptal Yapar ve bu kaydi yapanın bulunduğu yetki grubuna uyarı yollar ve satırları Iptal hale getirir --->
<cfif len(caller.attributes.order_employee_id)>
	<cfquery name="GET_EMP_POS" datasource="#attributes.data_source#">
		SELECT POSITION_CODE FROM #caller.dsn_alias#.EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=#caller.attributes.order_employee_id# AND IS_MASTER=1
	</cfquery>
	<cfif GET_EMP_POS.RECORDCOUNT>
		<cfset max_warning_date = attributes.record_date>
		<cfquery name="get_process_type" datasource="#attributes.data_source#">
			SELECT
				P.PROCESS_ID,
				P.PROCESS_NAME,
				PR.PROCESS_ROW_ID,
				PR.STAGE,
				PR.DETAIL,
				PR.ANSWER_HOUR,
				PR.ANSWER_MINUTE
			FROM
				#caller.dsn_alias#.PROCESS_TYPE P,
				#caller.dsn_alias#.PROCESS_TYPE_ROWS PR
			WHERE
				P.PROCESS_ID = PR.PROCESS_ID AND
				PR.PROCESS_ROW_ID = #attributes.process_stage#
		</cfquery>
		<cfif len(get_process_type.answer_hour)>
			<cfset max_warning_date = caller.date_add("h", get_process_type.answer_hour, attributes.record_date)>
		</cfif>
		<cfif len(get_process_type.answer_minute)>
			<cfset max_warning_date = caller.date_add("n", get_process_type.answer_minute, attributes.record_date)>
		</cfif>
		<cfquery name="ADD_WARNING" datasource="#attributes.data_source#" result="GET_WARNINGS">
			INSERT INTO
				#caller.dsn_alias#.PAGE_WARNINGS
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
<cfquery name="UPD_ORDER_ACIK" datasource="#attributes.data_source#">
	UPDATE
		#caller.dsn3_alias#.ORDER_ROW
	SET
		ORDER_ROW_CURRENCY  = -9
	WHERE
		ORDER_ID = #attributes.action_id#
</cfquery>
