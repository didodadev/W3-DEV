<cfquery name="GET_TOTAL" datasource="#dsn#">
	SELECT COUNT(EMP_ID) AS TOTAL_EMP,COUNT(CON_ID) AS TOTAL_PAR,COUNT(PAR_ID) AS TOTAL_CON FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID = #attributes.class_id#
</cfquery>
<cfset total = get_total.total_emp + get_total.total_par + get_total.total_con> 
<cfquery name="GET_CLASS" datasource="#dsn#">
	SELECT MAX_PARTICIPATION FROM TRAINING_CLASS WHERE CLASS_ID = #attributes.class_id#
</cfquery>
<cfif len(get_class.max_participation) and (total gte get_class.max_participation)>
	<script type="text/javascript">
		alert("<cf_get_lang no ='202.Bu Dersin Kontenjanı Dolmuştur'>!");
		history.go(-1);
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_CLASS_TRAINING_REQUEST_ROWS" datasource="#dsn#">
	SELECT CLASS_ID,EMPLOYEE_ID FROM TRAINING_REQUEST_ROWS WHERE CLASS_ID = #attributes.class_id# AND EMPLOYEE_ID = #attributes.EMP_ID#
</cfquery>
<cfif GET_CLASS_TRAINING_REQUEST_ROWS.RECORDCOUNT>
	<script type="text/javascript">
		alert("<cf_get_lang no ='203.Daha önce bu ders için talepte bulunmuşsunuz'>!");
		history.go(-1);
	</script>
	<cfabort>
</cfif>
<cfif isdefined("attributes.announce_id") and len(attributes.announce_id)>
	<cfquery name="UPD_TRAINING_JOIN_REQUESTS" datasource="#dsn#">
		UPDATE
			TRAINING_REQUEST_ROWS
		SET
			CLASS_ID = #attributes.CLASS_ID#,
			UPDATE_DATE = #Now()#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = '#REMOTE_ADDR#'
		WHERE
			ANNOUNCE_ID = #attributes.announce_id# AND
			EMPLOYEE_ID = #attributes.EMP_ID#
	</cfquery>
	<cfquery name="UPD_TRAINING_JOIN_REQUESTS" datasource="#dsn#">
		UPDATE
			TRAINING_CLASS_ANNOUNCE_ATTS
		SET
			CLASS_ID = #attributes.CLASS_ID#
		WHERE
			ANNOUNCE_ID = #attributes.announce_id# AND
			EMPLOYEE_ID = #attributes.EMP_ID#
	</cfquery>
<cfelse>
	<cfquery name="UPD_TRAINING_JOIN_REQUESTS" datasource="#dsn#">
		UPDATE
			TRAINING_REQUEST_ROWS
		SET
			EMPLOYEE_ID = #attributes.EMP_ID#,
			CLASS_ID = #attributes.CLASS_ID#,
			UPDATE_DATE = #Now()#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = '#REMOTE_ADDR#'
		WHERE
			REQUEST_ROW_ID = #attributes.REQUEST_ROW_ID#
	</cfquery>
</cfif>
<cfif isdefined("attributes.mail") and len(attributes.mail) and attributes.mail eq 1>
	<cflocation url="#request.self#?fuseaction=training.list_class_announce" addtoken="no">
<cfelse>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
</cfif>
