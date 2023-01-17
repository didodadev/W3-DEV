<cfif LEN(attributes.REPORT_DATE)>
	<cf_date tarih='attributes.REPORT_DATE'>
</cfif>
<cfquery name="add_healty_report" datasource="#dsn#">
INSERT INTO
	EMPLOYEE_HEALTY_REPORT
	(
	DOCTOR_NAME,
	DOCTOR_SURNAME,
	DOCTOR_TASK,
	DOCTOR_DIPLOMA_NO,
	KONJENTINAL,
	IS_KAZASI,
	DIGER_KAZA,
	CICEK,
	BCG,
	TETANOZ,
	TIBERKULIN,
	ZEHIRLENME,
	ALERJI,
	MESLEK_HASTALIK,
	BOY,
	GOGUS,
	AGIRLIK,
	GORUNUS,
	DERI,
	AGIZ_DIS,
	ISKELET_SISTEMI,
	DAHILIYE,
	RUH_SINIR,
	SOLUNUM_SISTEMI,
	URO_GENITAL,
	SINDIRIM_SISTEMI,
	GOZ,
	BURUN,
	KULAK,
	BOGAZ,
	EMPLOYEE_ID,
	REPORT_DATE,	
	RECORD_DATE,
	RECORD_IP,
	RECORD_EMP 
	)
VALUES
	(
	'#attributes.DOCTOR_NAME#',
	'#attributes.DOCTOR_SURNAME#',
	<cfif LEN(attributes.DOCTOR_TASK)>'#attributes.DOCTOR_TASK#',<cfelse>NULL,</cfif>
	<cfif LEN(attributes.DOCTOR_DIPLOMA_NO)>'#attributes.DOCTOR_DIPLOMA_NO#',<cfelse>NULL,</cfif>
	<cfif LEN(attributes.KONJENTINAL)>'#attributes.KONJENTINAL#',<cfelse>NULL,</cfif>
	<cfif LEN(attributes.IS_KAZASI)>'#attributes.IS_KAZASI#',<cfelse>NULL,</cfif>
	<cfif LEN(attributes.DIGER_KAZA)>'#attributes.DIGER_KAZA#',<cfelse>NULL,</cfif>
	<cfif LEN(attributes.CICEK)>'#attributes.CICEK#',<cfelse>NULL,</cfif>
	<cfif LEN(attributes.BCG)>'#attributes.BCG#',<cfelse>NULL,</cfif>
	<cfif LEN(attributes.TETANOZ)>'#attributes.TETANOZ#',<cfelse>NULL,</cfif>
	<cfif LEN(attributes.TIBERKULIN)>'#attributes.TIBERKULIN#',<cfelse>NULL,</cfif>
	<cfif LEN(attributes.ZEHIRLENME)>'#attributes.ZEHIRLENME#',<cfelse>NULL,</cfif>
	<cfif LEN(attributes.ALERJI)>'#attributes.ALERJI#',<cfelse>NULL,</cfif>
	<cfif LEN(attributes.MESLEK_HASTALIK)>'#attributes.MESLEK_HASTALIK#',<cfelse>NULL,</cfif>
	<cfif LEN(attributes.BOY)>'#attributes.BOY#',<cfelse>NULL,</cfif>
	<cfif LEN(attributes.GOGUS)>'#attributes.GOGUS#',<cfelse>NULL,</cfif>
	<cfif LEN(attributes.AGIRLIK)>'#attributes.AGIRLIK#',<cfelse>NULL,</cfif>
	<cfif LEN(attributes.GORUNUS)>'#attributes.GORUNUS#',<cfelse>NULL,</cfif>
	<cfif LEN(attributes.DERI)>'#attributes.DERI#',<cfelse>NULL,</cfif>
	<cfif LEN(attributes.AGIZ_DIS)>'#attributes.AGIZ_DIS#',<cfelse>NULL,</cfif>
	<cfif LEN(attributes.ISKELET_SISTEMI)>'#attributes.ISKELET_SISTEMI#',<cfelse>NULL,</cfif>
	<cfif LEN(attributes.DAHILIYE)>'#attributes.DAHILIYE#',<cfelse>NULL,</cfif>
	<cfif LEN(attributes.RUH_SINIR)>'#attributes.RUH_SINIR#',<cfelse>NULL,</cfif>
	<cfif LEN(attributes.SOLUNUM_SISTEMI)>'#attributes.SOLUNUM_SISTEMI#',<cfelse>NULL,</cfif>
	<cfif LEN(attributes.URO_GENITAL)>'#attributes.URO_GENITAL#',<cfelse>NULL,</cfif>
	<cfif LEN(attributes.SINDIRIM_SISTEMI)>'#attributes.SINDIRIM_SISTEMI#',<cfelse>NULL,</cfif>
	<cfif LEN(attributes.GOZ)>'#attributes.GOZ#',<cfelse>NULL,</cfif>
	<cfif LEN(attributes.BURUN)>'#attributes.BURUN#',<cfelse>NULL,</cfif>
	<cfif LEN(attributes.KULAK)>'#attributes.KULAK#',<cfelse>NULL,</cfif>
	<cfif LEN(attributes.BOGAZ)>'#attributes.BOGAZ#',<cfelse>NULL,</cfif>
	#attributes.EMPLOYEE_ID#,
	<cfif LEN(attributes.REPORT_DATE)>#attributes.REPORT_DATE#,<cfelse>NULL,</cfif>
	#now()#,
	'#cgi.REMOTE_ADDR#',
	#session.ep.userid#
	)
</cfquery>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelseif isdefined("attributes.draggable")>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
        closeBoxDraggable( 'healty_report_box' );
        openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_emp_healty_report&employee_id=#attributes.employee_id#</cfoutput>','healty_report_box');
	</cfif>
</script>