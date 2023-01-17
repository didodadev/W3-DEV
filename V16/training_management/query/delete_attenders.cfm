<!--- <cfquery name="UPD_CLASS" datasource="#DSN#">
	DELETE FROM
		TRAINING_CLASS_ATTENDER
	WHERE
		EMP_ID = #listgetat(url.id,2,"-")#
		AND CLASS_ID = #url.class_id#
</cfquery> --->
<cfquery name="UPD_CLASS" datasource="#DSN#">
	DELETE FROM
		TRAINING_CLASS_ATTENDER
	WHERE
		<cfif url.type eq 'employee'>
		EMP_ID = #url.id#
		<cfelseif url.type eq 'partner'>
		PAR_ID = #url.id#
		<cfelseif url.type eq 'consumer'>
		CON_ID =  #url.id#
		<cfelseif url.type eq 'group'> 
		GRP_ID = #url.id#
		</cfif>
		AND CLASS_ID = #url.class_id#
</cfquery>
<cfquery name="get_emp_list" datasource="#dsn#">
	SELECT 
        CLASS_ID, 
        ENTRY_EMP_ID,
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	TRAINING_PERFORMANCE 
    WHERE 
    	CLASS_ID = #url.class_id#
</cfquery>
<cfif get_emp_list.recordcount>
	<cfquery name="UPD_CLASS_FORM" datasource="#DSN#">
		DELETE FROM
			TRAINING_PERFORMANCE
		WHERE
			<cfif url.type eq 'employee'>
				ENTRY_EMP_ID = #url.id#
			</cfif>
			AND CLASS_ID = #url.class_id#
	</cfquery>
</cfif>
<!--- Katilimcilar da kurumsal,bireysel ve calisan icin kayit yapiliyor. Talep edenler de Kurumsal ve bireysele gore duzenlenecek simdilik talep edenler calisana göre geliyor..Senay 20061106 --->
<!--- katilimcilardan sildiginde talepler tablosudaki satirini 0 set ediyoruz--->
<cfquery name="UPD_REQ_ROWS" datasource="#dsn#">
	UPDATE
		TRAINING_REQUEST_ROWS
	SET
		IS_VALID=0,
		VALID_EMP=#session.ep.userid#,
		VALID_DATE=#NOW()#
	WHERE 
		<!--- EMPLOYEE_ID = #listgetat(url.id,2,"-")# --->
		EMPLOYEE_ID = #url.id#
		AND 
		(	CLASS_ID = #url.class_id#
		OR
			TRAINING_ID IN (SELECT TRAIN_ID FROM TRAINING_CLASS_SECTIONS WHERE CLASS_ID=#attributes.class_id#)	
		)
</cfquery>
<cfquery name="get_class_attendance" datasource="#dsn#">
	SELECT * FROM TRAINING_CLASS_ATTENDANCE WHERE CLASS_ID = #url.class_id#
</cfquery>
<cfif get_class_attendance.recordcount>
	<cfquery name="DELETE_CLASS_ATTENDANCE_DT" datasource="#DSN#">
		DELETE FROM
			TRAINING_CLASS_ATTENDANCE_DT
		WHERE
			<cfif url.type eq 'employee'>
			EMP_ID = #url.id#
			<cfelseif url.type eq 'partner'>
			PAR_ID = #url.id#
			<cfelseif url.type eq 'consumer'>
			CON_ID =  #url.id#
			</cfif>
			AND CLASS_ATTENDANCE_ID = #get_class_attendance.class_attendance_id#
	</cfquery>
</cfif>
<cfquery name="get_class_attendence_2" datasource="#dsn#">
	SELECT * FROM TRAINING_CLASS_ATTENDANCE WHERE CLASS_ID = #url.class_id#
</cfquery>
<cfif get_class_attendence_2.recordcount eq 0>
	<cfquery name="delete_class_attendence" datasource="#dsn#">
		DELETE FROM TRAINING_CLASS_ATTENDANCE WHERE CLASS_ID = #url.class_id#
	</cfquery>
</cfif>
<cfquery name="DELETE_TRAINING_CLASS_RESULTS" datasource="#dsn#">
	DELETE FROM
		TRAINING_CLASS_RESULTS
	WHERE
		<cfif url.type eq 'employee'>
		EMP_ID = #url.id#
		<cfelseif url.type eq 'partner'>
		PAR_ID = #url.id#
		<cfelseif url.type eq 'consumer'>
		CON_ID =  #url.id#
		</cfif>
		AND CLASS_ID = #url.class_id#
</cfquery>
<cfquery name="DELETE_ATTENDER_EVAL" datasource="#dsn#">
	DELETE FROM 
		TRAINING_CLASS_ATTENDER_EVAL 
	WHERE 
		<cfif url.type eq 'employee'>
		EMP_ID = #url.id#
		<cfelseif url.type eq 'partner'>
		PAR_ID = #url.id#
		<cfelseif url.type eq 'consumer'>
		CON_ID =  #url.id#
		</cfif>
		AND CLASS_ID = #url.class_id#
</cfquery>
<cfquery name="DELETE_ATTENDER_EVAL_NOTE" datasource="#dsn#">
	DELETE FROM 
		TRAINING_CLASS_EVAL_NOTE 
	WHERE 
		<cfif url.type eq 'employee'>
		EMPLOYEE_ID = #url.id#
		<cfelseif url.type eq 'partner'>
		PAR_ID = #url.id#
		<cfelseif url.type eq 'consumer'>
		CON_ID =  #url.id#
		</cfif>
		AND CLASS_ID = #url.class_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

