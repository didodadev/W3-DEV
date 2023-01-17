<cfquery name="get_doc" datasource="#dsn#">
	SELECT
		*
	FROM
		COMMANDMENT
	WHERE
		COMMANDMENT_ID = #attributes.COMMANDMENT_ID#
</cfquery>

<cfset upload_folder = "#upload_folder#ehesap#dir_seperator#">

<cf_date tarih='attributes.commandment_date'>
<cfset attributes.commandment_date = dateadd('h',attributes.commandment_date_hour,attributes.commandment_date)>
<cfset attributes.commandment_date = dateadd('n',attributes.commandment_date_min,attributes.commandment_date)>

<cfquery name="add_penalty" datasource="#dsn#">
	UPDATE
		COMMANDMENT
	SET
		COMMANDMENT_DATE = #attributes.commandment_date#,
		RATE_VALUE = #attributes.rate_value#,
		COMMANDMENT_VALUE = #filternum(attributes.commandment_value)#,
		PRE_COMMANDMENT_VALUE = #filternum(attributes.pre_commandment_value)#,
		EMPLOYEE_ID = #attributes.employee_id#,
		SERIAL_NO = '#attributes.serial_no#',
		SERIAL_NUMBER = '#attributes.serial_number#',
		COMMANDMENT_OFFICE = '#attributes.COMMANDMENT_OFFICE#',
		IBAN_NO = '#attributes.iban_no#',
		IS_APPLY = <cfif isdefined("attributes.is_apply")>1<cfelse>0</cfif>,
		IS_REFUSE = <cfif isdefined("attributes.is_refuse")>1<cfelse>0</cfif>,
		IS_MANUEL_CLOSED = <cfif isdefined("attributes.is_manuel_closed")>1<cfelse>0</cfif>,
		TYPE_ID = #attributes.type_id#,
		PRIORITY = #attributes.priority#,
		COMMANDMENT_TYPE = #attributes.commandment_type#,
		COMMANDMENT_DETAIL = '#attributes.commandment_detail#',
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP = #session.ep.userid#
	WHERE
		COMMANDMENT_ID = #attributes.commandment_id#
</cfquery>
<cfset max_id = attributes.commandment_id>

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
	<cfif len(get_doc.commandment_file)>
		<cffile action="delete" file="#upload_folder##get_doc.COMMANDMENT_FILE#">
	</cfif>
	<cftry>
		<cffile
			action="UPLOAD" 
			filefield="commandment_file" 
			destination="#upload_folder#" 
			mode="777" 
			nameconflict="MAKEUNIQUE"
			>
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
			</script>
		</cfcatch>  
	</cftry>

	<cfset file_name = 'icra_#max_id#'>
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
	<cfset attributes.file_ = '#file_name#.#cffile.serverfileext#'>
<cfelse>
	<cfset attributes.file_ = get_doc.commandment_file>
</cfif>

<cfquery name="upd_" datasource="#dsn#">
	UPDATE
		COMMANDMENT
	SET
		COMMANDMENT_FILE = '#attributes.file_#'
	WHERE
		COMMANDMENT_ID = #max_id#
</cfquery>

<script type="text/javascript">
	window.location.href = '<cfoutput>index.cfm?fuseaction=ehesap.upd_icra&COMMANDMENT_ID=#max_id#</cfoutput>';
</script>