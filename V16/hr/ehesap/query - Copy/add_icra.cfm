<cfset upload_folder = "#upload_folder#ehesap#dir_seperator#">

<cf_date tarih='attributes.commandment_date'>
<cfset attributes.commandment_date = dateadd('h',attributes.commandment_date_hour,attributes.commandment_date)>
<cfset attributes.commandment_date = dateadd('n',attributes.commandment_date_min,attributes.commandment_date)>

<cfquery name="add_penalty" datasource="#dsn#" result="get_max">
	INSERT INTO
		COMMANDMENT
		(
		COMMANDMENT_DATE,
		COMMANDMENT_VALUE,
		RATE_VALUE,
		PRE_COMMANDMENT_VALUE,
		EMPLOYEE_ID,
		SERIAL_NO,
		SERIAL_NUMBER,
		COMMANDMENT_DETAIL,
		COMMANDMENT_OFFICE,
		IBAN_NO,
		TYPE_ID,
		PRIORITY,
		COMMANDMENT_TYPE,
		RECORD_DATE,
		RECORD_EMP
		)
		VALUES
		(
		#attributes.commandment_date#,
		#filternum(attributes.commandment_value)#,
		#attributes.rate_value#,
		<cfif len(attributes.pre_commandment_value)>#filternum(attributes.pre_commandment_value)#<cfelse>0</cfif>,
		#attributes.employee_id#,
		'#attributes.serial_no#',
		'#attributes.serial_number#',
		'#attributes.commandment_detail#',
		'#attributes.COMMANDMENT_OFFICE#',
		'#attributes.iban_no#',
		#attributes.type_id#,
		#attributes.priority#,
		#attributes.commandment_type#,
		#now()#,
		#session.ep.userid#
		)
</cfquery>
<cfset max_id = get_max.identitycol>

<cfquery name="add_history" datasource="#dsn#">
	INSERT INTO
		COMMANDMENT_HISTORY
		(
		COMMANDMENT_ID,
		DETAIL,
		RECORD_DATE,
		COMMANDMENT_DATE,
		RECORD_EMP,
		COMMANDMENT_VALUE,
		COMMANDMENT_OFFICE,
		COMMANDMENT_DETAIL,
		IS_REFUSE,
		IS_APPLY,
		IS_TRANSFER,
		EMPLOYEE_ID,
		PROJECT_ID,
		SERIAL_NO,
		SERIAL_NUMBER,
		PROCESS_STAGE,
		COMMANDMENT_FILE,
		IBAN_NO,
		PRE_COMMANDMENT_VALUE,
		RATE_VALUE,
		IS_CVP,
		ODENEN,
		COMMANDMENT_TYPE,
		TYPE_ID,
		PRIORITY,
		UPDATE_DATE,
		UPDATE_EMP,
		IS_MANUEL_CLOSED
		)
		SELECT
			COMMANDMENT_ID,
			DETAIL,
			RECORD_DATE,
			COMMANDMENT_DATE,
			RECORD_EMP,
			COMMANDMENT_VALUE,
			COMMANDMENT_OFFICE,
			COMMANDMENT_DETAIL,
			IS_REFUSE,
			IS_APPLY,
			IS_TRANSFER,
			EMPLOYEE_ID,
			PROJECT_ID,
			SERIAL_NO,
			SERIAL_NUMBER,
			PROCESS_STAGE,
			COMMANDMENT_FILE,
			IBAN_NO,
			PRE_COMMANDMENT_VALUE,
			RATE_VALUE,
			IS_CVP,
			ODENEN,
			COMMANDMENT_TYPE,
			TYPE_ID,
			PRIORITY,
			UPDATE_DATE,
			UPDATE_EMP,
			IS_MANUEL_CLOSED
		FROM
			COMMANDMENT
		WHERE
			COMMANDMENT_ID = #max_id#
</cfquery>

<cfif isDefined("form.commandment_file") and len(form.commandment_file)>
	<cftry>
		<cffile
			action="UPLOAD" 
			filefield="commandment_file" 
			destination="#upload_folder#" 
			mode="777" 
			nameconflict="MAKEUNIQUE"
			>
			
			<cfset file_name = 'icra_#max_id#'>
			<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
			<cfset attributes.file_ = '#file_name#.#cffile.serverfileext#'>
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
			</script>
			<cfset attributes.file_ = ''>
		</cfcatch>  
	</cftry>
<cfelse>
	<cfset attributes.file_ = ''>
</cfif>

<cfquery name="upd_" datasource="#dsn#">
	UPDATE
		COMMANDMENT
	SET
		COMMANDMENT_FILE = '#attributes.file_#'
	WHERE
		COMMANDMENT_ID = #max_id#
</cfquery>

<cfquery name="get_doc" datasource="#dsn#">
	SELECT
		*
	FROM
		COMMANDMENT
	WHERE
		COMMANDMENT_ID = #max_id#
</cfquery>


<script type="text/javascript">
	window.location.href = '<cfoutput>index.cfm?fuseaction=ehesap.list_executions&event=upd&id=#get_max_execution.MAX_ID#</cfoutput>';
</script>