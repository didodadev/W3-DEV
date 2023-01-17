<!---
	BK 060705
	Bu dosya ilgili alanlarin degisiklige ugramasi durumunda surecdeki ilgili kisilere uyarı atmak amaci ile hazirlanmistir.
	Surecdeki diger dosya olan display file tarafından degistirilen page_warning_value degerine gore blok calisir.
 --->

<cfif isdefined("caller.attributes.page_warning_value") and caller.attributes.page_warning_value eq 1><!--- uyari olusacak sart olusmus ise --->
	<cfquery name="OLD_STAGE" datasource="#attributes.data_source#">
		SELECT STAGE FROM #caller.dsn_alias#.PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = #caller.attributes.old_invoice_process_value#
	</cfquery>
	<cfquery name="NEW_STAGE" datasource="#attributes.data_source#">
		SELECT STAGE FROM #caller.dsn_alias#.PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = #attributes.process_stage#
	</cfquery>
	
	<cfquery name="OLD_TYPE" datasource="#attributes.data_source#">
		SELECT SUBSCRIPTION_TYPE FROM #caller.dsn3_alias#.SETUP_SUBSCRIPTION_TYPE  WHERE SUBSCRIPTION_TYPE_ID = #caller.attributes.old_subscription_type#
	</cfquery>
	<cfquery name="NEW_TYPE" datasource="#attributes.data_source#">
		SELECT SUBSCRIPTION_TYPE FROM #caller.dsn3_alias#.SETUP_SUBSCRIPTION_TYPE  WHERE SUBSCRIPTION_TYPE_ID = #caller.attributes.subscription_type#
	</cfquery>
	
	<cfif len(caller.attributes.old_credit_card_id)>
		<cfquery name="GET_MEMBER_CC_OLD" datasource="#attributes.data_source#">
			SELECT
			<cfif len(caller.attributes.old_partner_id)>
				CC.COMPANY_CC_ID MEMBER_CC_ID,
				CC.COMPANY_ID MEMBER_ID,
				CC.COMPANY_CC_TYPE MEMBER_CC_TYPE,
				CC.COMPANY_CC_NUMBER MEMBER_CC_NUMBER,
				CC.COMPANY_EX_MONTH MEMBER_EX_MONTH,
				CC.COMPANY_EX_YEAR MEMBER_EX_YEAR
			<cfelse>
				CC.CONSUMER_CC_ID MEMBER_CC_ID,
				CC.CONSUMER_ID MEMBER_ID,
				CC.CONSUMER_CC_TYPE MEMBER_CC_TYPE,
				CC.CONSUMER_CC_NUMBER MEMBER_CC_NUMBER,
				CC.CONSUMER_EX_MONTH MEMBER_EX_MONTH,
				CC.CONSUMER_EX_YEAR MEMBER_EX_YEAR
			</cfif>
			FROM
			<cfif len(caller.attributes.old_partner_id)>
				#caller.dsn_alias#.COMPANY_CC CC
			<cfelse>
				#caller.dsn_alias#.CONSUMER_CC CC
			</cfif>
			WHERE
			<cfif len(caller.attributes.old_partner_id)>
				CC.COMPANY_ID = #caller.attributes.old_company_id# AND
				COMPANY_CC_ID = #caller.attributes.old_credit_card_id#
			<cfelse>
				CC.CONSUMER_ID = #caller.attributes.old_consumer_id# AND
				CONSUMER_CC_ID = #caller.attributes.old_credit_card_id#
			</cfif>		
		</cfquery>
	</cfif>
	
	<cfif len(caller.attributes.credit_card_id)>
		<cfquery name="GET_MEMBER_CC_NEW" datasource="#attributes.data_source#">
			SELECT
			<cfif len(caller.attributes.partner_id)>
				CC.COMPANY_CC_ID MEMBER_CC_ID,
				CC.COMPANY_ID MEMBER_ID,
				CC.COMPANY_CC_TYPE MEMBER_CC_TYPE,
				CC.COMPANY_CC_NUMBER MEMBER_CC_NUMBER,
				CC.COMPANY_EX_MONTH MEMBER_EX_MONTH,
				CC.COMPANY_EX_YEAR MEMBER_EX_YEAR
			<cfelse>
				CC.CONSUMER_CC_ID MEMBER_CC_ID,
				CC.CONSUMER_ID MEMBER_ID,
				CC.CONSUMER_CC_TYPE MEMBER_CC_TYPE,
				CC.CONSUMER_CC_NUMBER MEMBER_CC_NUMBER,
				CC.CONSUMER_EX_MONTH MEMBER_EX_MONTH,
				CC.CONSUMER_EX_YEAR MEMBER_EX_YEAR
			</cfif>
			FROM
			<cfif len(caller.attributes.partner_id)>
				#caller.dsn_alias#.COMPANY_CC CC
			<cfelse>
				#caller.dsn_alias#.CONSUMER_CC CC
			</cfif>
			WHERE
			<cfif len(caller.attributes.partner_id)>
				CC.COMPANY_ID = #caller.attributes.company_id# AND
				COMPANY_CC_ID = #caller.attributes.credit_card_id#
			<cfelse>
				CC.CONSUMER_ID = #caller.attributes.consumer_id# AND
				CONSUMER_CC_ID = #caller.attributes.credit_card_id#
			</cfif>		
		</cfquery>
	</cfif>

	<cfif len(caller.attributes.company_id)>
		<cfset old_key_type = caller.attributes.old_company_id>
	<cfelse>
		<cfset old_key_type = caller.attributes.old_consumer_id>
	</cfif>
	
	<cfif len(caller.attributes.company_id)>
		<cfset key_type = caller.attributes.company_id>
	<cfelse>
		<cfset key_type = caller.attributes.consumer_id>
	</cfif>
	
	<cfset subscription_update_description1 = '<br/>
	<b>Eski - Yeni Müsteri Adı :</b> (#caller.attributes.old_company_name# - #caller.attributes.old_member_name#) - (#caller.attributes.company_name# - #caller.attributes.member_name#)<br/>
	<b>Eski - Yeni Fatura Şirketi :</b> (#caller.attributes.old_invoice_member_name#) - (#caller.attributes.invoice_member_name#)<br/>
	<b>Eski - Yeni Aşama :</b> (#old_stage.stage#) - (#new_stage.stage#)<br/>
	<b>Eski - Yeni Kategori :</b> (#old_type.subscription_type#) - (#new_type.subscription_type#)<br/>
	<b>Eski - Yeni Referans Müşteri :</b> (#caller.attributes.old_ref_company# - #caller.attributes.old_ref_member#) - (#caller.attributes.ref_company# - #caller.attributes.ref_member#)<br/>'>
	
	<cfset subscription_update_description2 = '<b>Eski - Yeni Kredi Kartı :</b> '>
	<cfif len(caller.attributes.old_credit_card_id) and get_member_cc_old.recordcount>
		<cfset subscription_update_description3 ='(#mid(Decrypt(get_member_cc_old.member_cc_number,old_key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(get_member_cc_old.member_cc_number,old_key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(get_member_cc_old.member_cc_number,old_key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(get_member_cc_old.member_cc_number,old_key_type,"CFMX_COMPAT","Hex")))#/<b>#get_member_cc_old.member_ex_month#-#get_member_cc_old.member_ex_year#</b>) -'>
	<cfelse>
		<cfset subscription_update_description3 ='( ) - '>
	</cfif>
	
	<cfif len(caller.attributes.credit_card_id) and get_member_cc_new.recordcount>
		<cfset subscription_update_description4 =' (#mid(Decrypt(get_member_cc_new.member_cc_number,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(get_member_cc_new.member_cc_number,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(get_member_cc_new.member_cc_number,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(get_member_cc_new.member_cc_number,key_type,"CFMX_COMPAT","Hex")))#/<b>#get_member_cc_new.member_ex_month#-#get_member_cc_new.member_ex_year#</b>)<br/>'>
	<cfelse>
		<cfset subscription_update_description4 ='( )<br/>'>
	</cfif>

	<cfset subscription_update_description5 = '<b>Eski - Yeni Özel Kod :</b> (#caller.attributes.old_special_code#) - (#caller.attributes.special_code#)'>
	
	<cfset subscription_update_description = subscription_update_description1 & subscription_update_description2 & subscription_update_description3 & subscription_update_description4 & subscription_update_description5>

	<!--- Uyari blogu --->
	<cfquery name="GET_EMPLOYEE_WORKGROUP" datasource="#attributes.data_source#"><!--- Sureci guncelleyen kisinin surec grubu bulunur. --->
		SELECT
			PROCESS_TYPE_ROWS_WORKGRUOP.WORKGROUP_ID
		FROM
			#caller.dsn_alias#.EMPLOYEE_POSITIONS EMPLOYEE_POSITIONS,
			#caller.dsn_alias#.PROCESS_TYPE_ROWS_WORKGRUOP PROCESS_TYPE_ROWS_WORKGRUOP,
			#caller.dsn_alias#.PROCESS_TYPE_ROWS_POSID PROCESS_TYPE_ROWS_POSID
		WHERE
			PROCESS_TYPE_ROWS_WORKGRUOP.PROCESS_ROW_ID = #attributes.process_stage# AND
			PROCESS_TYPE_ROWS_WORKGRUOP.WORKGROUP_ID = PROCESS_TYPE_ROWS_POSID.WORKGROUP_ID AND
			EMPLOYEE_POSITIONS.POSITION_CODE = #session.ep.position_code# AND
			EMPLOYEE_POSITIONS.POSITION_ID = PROCESS_TYPE_ROWS_POSID.PRO_POSITION_ID
	</cfquery>
	<cfif get_employee_workgroup.recordcount>
		<cfset value_workgroup_id = get_employee_workgroup.workgroup_id>
	<cfelse>
		<cfset value_workgroup_id = 0>
	</cfif>
	
	<cfquery name="GET_CAU_POSITION_TYPE" datasource="#attributes.data_source#"><!--- O gruptaki uyari gonderilecekler --->
		SELECT 
			PROCESS_TYPE_ROWS_CAUID.CAU_POSITION_ID PRO_POSITION_ID,
			EMPLOYEES.EMPLOYEE_NAME AS EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME AS EMPLOYEE_SURNAME,
			EMPLOYEES.EMPLOYEE_EMAIL AS EMPLOYEE_EMAIL,
			EMPLOYEE_POSITIONS.EMPLOYEE_ID AS EMPLOYEE_ID,
			EMPLOYEES.MOBILCODE AS MOBILCODE,
			EMPLOYEES.MOBILTEL AS MOBILTEL,
			PROCESS_TYPE_ROWS_WORKGRUOP.WORKGROUP_ID,
			EMPLOYEE_POSITIONS.POSITION_CODE,
			0 AS TYPE
		FROM 
			#caller.dsn_alias#.PROCESS_TYPE_ROWS_CAUID PROCESS_TYPE_ROWS_CAUID,
			#caller.dsn_alias#.EMPLOYEES EMPLOYEES,
			#caller.dsn_alias#.EMPLOYEE_POSITIONS EMPLOYEE_POSITIONS,
			#caller.dsn_alias#.PROCESS_TYPE_ROWS_WORKGRUOP PROCESS_TYPE_ROWS_WORKGRUOP
		WHERE 
			PROCESS_TYPE_ROWS_CAUID.PROCESS_ROW_ID = #attributes.process_stage# AND
			PROCESS_TYPE_ROWS_WORKGRUOP.WORKGROUP_ID = #value_workgroup_id# AND
			PROCESS_TYPE_ROWS_CAUID.WORKGROUP_ID = PROCESS_TYPE_ROWS_WORKGRUOP.WORKGROUP_ID AND
			EMPLOYEE_POSITIONS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
			EMPLOYEE_POSITIONS.POSITION_ID = PROCESS_TYPE_ROWS_CAUID.CAU_POSITION_ID
	</cfquery>
		
	<cfif get_cau_position_type.recordcount>
		<cfoutput query="get_cau_position_type">
			<cfset max_warning_date = attributes.record_date>
			<cfif len(get_process_type.answer_hour)>
				<cfset max_warning_date = date_add("h", get_process_type.answer_hour, attributes.record_date)>
			</cfif>
			<cfif len(get_process_type.answer_minute)>
				<cfset max_warning_date = date_add("n", get_process_type.answer_minute, attributes.record_date)>
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
					'Sistem Güncellemesi',
					#get_process_type.process_row_id#,
					<cfif len(subscription_update_description) gt 1000>'#left(subscription_update_description,100)#'<cfelse>'#subscription_update_description#'</cfif>,
					#max_warning_date#,
					#max_warning_date#,
					#max_warning_date#,
					#attributes.record_date#,
					1,
					1,
					0,
					'#cgi.remote_addr#',
					#session.ep.userid#,
					#get_cau_position_type.position_code#,
					1
				)
			</cfquery>
			<cfquery name="UPD_WARNINGS" datasource="#attributes.data_source#">
				UPDATE #caller.dsn_alias#.PAGE_WARNINGS SET PARENT_ID = #get_warnings.IDENTITYCOL# WHERE W_ID = #get_warnings.IDENTITYCOL#			
			</cfquery>
		</cfoutput>
	</cfif>
</cfif>
