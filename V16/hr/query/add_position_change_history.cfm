<!--- pozisyon detayında pozisyona yeni atanan ve pozisyonu degisen calisanlarin yeni goreve atama ve gorev degisikligi bilgilerinin tutulması icin eklenmistir SG 20120809--->
<cfif isdefined("attributes.is_add") and attributes.employee_id neq 0>
<cfquery name="add_change_history" datasource="#dsn#">
	INSERT INTO
		EMPLOYEE_POSITIONS_CHANGE_HISTORY
		(
			EMPLOYEE_ID,
			DEPARTMENT_ID,
			POSITION_ID,
			POSITION_NAME,
			POSITION_CAT_ID,
			TITLE_ID,
			FUNC_ID,
			ORGANIZATION_STEP_ID,
			COLLAR_TYPE,
			UPPER_POSITION_CODE,
			UPPER_POSITION_CODE2,
			START_DATE,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP,
            REASON_ID<!---20131106 GSO--->
		)
		SELECT
			EMPLOYEE_ID,
			DEPARTMENT_ID,
			POSITION_ID,
			POSITION_NAME,
			POSITION_CAT_ID,
			TITLE_ID,
			FUNC_ID,
			ORGANIZATION_STEP_ID,
			COLLAR_TYPE,
			UPPER_POSITION_CODE,
			UPPER_POSITION_CODE2,
			#attributes.position_in_out_date#,
			#session.ep.userid#,
			#NOW()#,
			'#CGI.REMOTE_ADDR#',
            <cfif len(attributes.reason_id)>#attributes.reason_id#<cfelse>NULL</cfif><!---20131106 GSO--->
		FROM
			EMPLOYEE_POSITIONS 
		WHERE
			POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#change_position_id#">
</cfquery>
<cfelseif isdefined("attributes.is_update")>
	<cfif (not len(attributes.employee_id) and not len(attributes.employee)) or ((isdefined("attributes.old_position_name") and attributes.old_position_name neq attributes.POSITION_NAME) or (attributes.old_department_id neq attributes.department_id) or (attributes.old_title_id neq attributes.title_id) or (attributes.old_func_id neq attributes.func_id) or (attributes.old_position_cat_id neq listfirst(attributes.POSITION_CAT_ID,';')))><!---  pozisyon bosaltiliyor ise son gorev kaydini update edecek--->
		<cfquery name="get_content_history" datasource="#dsn#" maxrows="1">
			SELECT ID FROM EMPLOYEE_POSITIONS_CHANGE_HISTORY WHERE EMPLOYEE_ID = #attributes.old_emp_id# AND FINISH_DATE IS NULL AND POSITION_ID = #change_position_id# ORDER BY START_DATE DESC
		</cfquery>
		<cfif len(attributes.employee_id)><!--- calisanin pozisyonu guncelleniyor ise eski kaydin cikis tarihini -1 gun olarak update edecek--->
			<cfset attributes.position_in_out_date_2 = dateadd('d',-1,attributes.position_in_out_date)>
		<cfelse>
			<cfset attributes.position_in_out_date_2 = attributes.position_in_out_date>
		</cfif>
		<cfif get_content_history.recordcount>
			<cfquery name="upd_conten_history" datasource="#dsn#">
				UPDATE EMPLOYEE_POSITIONS_CHANGE_HISTORY SET FINISH_DATE = #attributes.position_in_out_date_2# WHERE ID=#get_content_history.ID#
			</cfquery>
		</cfif>
	</cfif>
	<cfif len(attributes.employee) and attributes.employee_id neq 0> <!--- calisanin cikisi yapildiysa ekleme yapmayacak--->
	<cfquery name="add_change_history" datasource="#dsn#">
		INSERT INTO
			EMPLOYEE_POSITIONS_CHANGE_HISTORY
			(
				EMPLOYEE_ID,
				DEPARTMENT_ID,
				POSITION_ID,
				POSITION_NAME,
				POSITION_CAT_ID,
				TITLE_ID,
				FUNC_ID,
				ORGANIZATION_STEP_ID,
				COLLAR_TYPE,
				UPPER_POSITION_CODE,
				UPPER_POSITION_CODE2,
				START_DATE,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP,
                REASON_ID<!---20131106 GSO--->
			)
			SELECT
				EMPLOYEE_ID,
				DEPARTMENT_ID,
				POSITION_ID,
				POSITION_NAME,
				POSITION_CAT_ID,
				TITLE_ID,
				FUNC_ID,
				ORGANIZATION_STEP_ID,
				COLLAR_TYPE,
				UPPER_POSITION_CODE,
				UPPER_POSITION_CODE2,
				#attributes.position_in_out_date#,
				#session.ep.userid#,
				#NOW()#,
				'#CGI.REMOTE_ADDR#',
                <cfif len(attributes.reason_id)>#attributes.reason_id#<cfelse>NULL</cfif><!---20131106 GSO--->
			FROM
				EMPLOYEE_POSITIONS 
			WHERE
				POSITION_ID = #change_position_id#
	</cfquery>
	</cfif>
</cfif>
