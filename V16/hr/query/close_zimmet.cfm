<cf_date tarih="attributes.tarih">
<!--- <cfquery name="upd_zimmet" datasource="#DSN#">
	UPDATE
		EMPLOYEES_INVENT_ZIMMET
	SET 
		CONSIGNEER=#attributes.employee_id#,
		CONSIGN_DATE=#attributes.tarih#,
		STATUS=1
	WHERE
		ZIMMET_ID=#attributes.zimmet_id#
</cfquery> --->

<cfquery name="get_emp" datasource="#DSN#">
	SELECT
		ZIMMET_ID
	FROM
		EMPLOYEES_INVENT_ZIMMET
	WHERE
		EMPLOYEE_ID=#attributes.employee_id#
</cfquery>
<cfif not get_emp.recordcount>
	<cfquery name="add_invent" datasource="#DSN#">
		INSERT INTO 
			EMPLOYEES_INVENT_ZIMMET
			(	
				EMPLOYEE_ID,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
			VALUES
			(
				#attributes.employee_id#,
				#now()#,
				#SESSION.EP.USERID#,
				'#CGI.REMOTE_ADDR#'
			)
	</cfquery>	
	<cfquery name="get_max" datasource="#DSN#">
		SELECT
			 MAX(ZIMMET_ID) AS MAX_ID
		FROM
			EMPLOYEES_INVENT_ZIMMET
	</cfquery>
	<cfset NEW_ZIMMET_ID=get_max.MAX_ID>	
<cfelse>
	<cfset NEW_ZIMMET_ID=get_emp.ZIMMET_ID>	
</cfif>



<cfif isdefined("attributes.zimmet_row_id") and LEN(attributes.zimmet_row_id)>
	<!--- sadece 1 tane esya el degistiriyor. --->
	<cfquery  name="upd_row_" datasource="#DSN#">
		UPDATE
			EMPLOYEES_INVENT_ZIMMET_ROWS
		SET 
			GIVEN_EMP_ID=#attributes.give_emp_id#,
			ZIMMET_ID=#NEW_ZIMMET_ID#,
			ZIMMET_DATE=#attributes.tarih#
		WHERE
			ZIMMET_ROW_ID=#attributes.ZIMMET_ROW_ID#
	</cfquery>
	
<cfelse>
	<!--- hepsi devredeiliyor --->
	<cfquery name="get_zim" datasource="#DSN#">
			SELECT
				EIZR.*
			FROM
				EMPLOYEES_INVENT_ZIMMET EIZ,
				EMPLOYEES_INVENT_ZIMMET_ROWS EIZR
			WHERE
				EIZ.ZIMMET_ID=EIZR.ZIMMET_ID
			AND
				EIZ.EMPLOYEE_ID=#attributes.give_emp_id#
	</cfquery>
	<cfset row_ids=ValueList(get_zim.ZIMMET_ROW_ID)>	
	<cfif not len(row_ids)><cfset row_ids=0></cfif>
		<cfquery  name="upd_row_" datasource="#DSN#">
			UPDATE
				EMPLOYEES_INVENT_ZIMMET_ROWS
			SET 
				GIVEN_EMP_ID=#attributes.give_emp_id#,
				ZIMMET_ID=#NEW_ZIMMET_ID#,
				ZIMMET_DATE=#attributes.tarih#
			WHERE
				ZIMMET_ROW_ID IN (#row_ids#)
		</cfquery>
</cfif>

<script type="text/javascript">
	window.close();
	wrk_opener_reload();	
</script>
