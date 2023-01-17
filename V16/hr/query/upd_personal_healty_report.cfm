<cfif LEN(attributes.REPORT_DATE)>
	<cf_date tarih='attributes.REPORT_DATE'>
</cfif>
<cfquery name="add_healty_report" datasource="#dsn#">
	UPDATE 
		EMPLOYEE_HEALTY_REPORT 
	SET
		DOCTOR_NAME = '#attributes.DOCTOR_NAME#',
		DOCTOR_SURNAME = '#attributes.DOCTOR_SURNAME#',
		DOCTOR_TASK = '#attributes.DOCTOR_TASK#',
		DOCTOR_DIPLOMA_NO = <cfif LEN(attributes.DOCTOR_DIPLOMA_NO)>'#attributes.DOCTOR_DIPLOMA_NO#',<cfelse>NULL,</cfif>
		KONJENTINAL = <cfif LEN(attributes.KONJENTINAL)>'#attributes.KONJENTINAL#',<cfelse>NULL,</cfif>
		IS_KAZASI = <cfif LEN(attributes.IS_KAZASI)>'#attributes.IS_KAZASI#',<cfelse>NULL,</cfif>
		DIGER_KAZA = <cfif LEN(attributes.DIGER_KAZA)>'#attributes.DIGER_KAZA#',<cfelse>NULL,</cfif>
		CICEK = <cfif LEN(attributes.CICEK)>'#attributes.CICEK#',<cfelse>NULL,</cfif>
		BCG = <cfif LEN(attributes.BCG)>'#attributes.BCG#',<cfelse>NULL,</cfif>
		TETANOZ = <cfif LEN(attributes.TETANOZ)>'#attributes.TETANOZ#',<cfelse>NULL,</cfif>
		TIBERKULIN = <cfif LEN(attributes.TIBERKULIN)>'#attributes.TIBERKULIN#',<cfelse>NULL,</cfif>
		ZEHIRLENME = <cfif LEN(attributes.ZEHIRLENME)>'#attributes.ZEHIRLENME#',<cfelse>NULL,</cfif>
		ALERJI = <cfif LEN(attributes.ALERJI)>'#attributes.ALERJI#',<cfelse>NULL,</cfif>
		MESLEK_HASTALIK = <cfif LEN(attributes.MESLEK_HASTALIK)>'#attributes.MESLEK_HASTALIK#',<cfelse>NULL,</cfif>
		BOY = <cfif LEN(attributes.BOY)>'#attributes.BOY#',<cfelse>NULL,</cfif>
		GOGUS = <cfif LEN(attributes.GOGUS)>'#attributes.GOGUS#',<cfelse>NULL,</cfif>
		AGIRLIK = <cfif LEN(attributes.AGIRLIK)>'#attributes.AGIRLIK#',<cfelse>NULL,</cfif>
		GORUNUS = <cfif LEN(attributes.GORUNUS)>'#attributes.GORUNUS#',<cfelse>NULL,</cfif>
		DERI = <cfif LEN(attributes.DERI)>'#attributes.DERI#',<cfelse>NULL,</cfif>
		AGIZ_DIS = <cfif LEN(attributes.AGIZ_DIS)>'#attributes.AGIZ_DIS#',<cfelse>NULL,</cfif>
		ISKELET_SISTEMI = <cfif LEN(attributes.ISKELET_SISTEMI)>'#attributes.ISKELET_SISTEMI#',<cfelse>NULL,</cfif>
		DAHILIYE = <cfif LEN(attributes.DAHILIYE)>'#attributes.DAHILIYE#',<cfelse>NULL,</cfif>
		RUH_SINIR = <cfif LEN(attributes.RUH_SINIR)>'#attributes.RUH_SINIR#',<cfelse>NULL,</cfif>
		SOLUNUM_SISTEMI = <cfif LEN(attributes.SOLUNUM_SISTEMI)>'#attributes.SOLUNUM_SISTEMI#', <cfelse>NULL,</cfif>
		URO_GENITAL = <cfif LEN(attributes.URO_GENITAL)>'#attributes.URO_GENITAL#',<cfelse>NULL,</cfif>
		SINDIRIM_SISTEMI = <cfif LEN(attributes.SINDIRIM_SISTEMI)>'#attributes.SINDIRIM_SISTEMI#',<cfelse>NULL,</cfif>
		GOZ = <cfif LEN(attributes.GOZ)>'#attributes.GOZ#',<cfelse>NULL,</cfif>
		BURUN = <cfif LEN(attributes.BURUN)>'#attributes.BURUN#',<cfelse>NULL,</cfif>
		KULAK = <cfif LEN(attributes.KULAK)>'#attributes.KULAK#',<cfelse>NULL,</cfif>
		BOGAZ = <cfif LEN(attributes.BOGAZ)>'#attributes.BOGAZ#',<cfelse>NULL,</cfif>
		EMPLOYEE_ID = #attributes.EMPLOYEE_ID#,
		REPORT_DATE=<cfif LEN(attributes.REPORT_DATE)>#attributes.REPORT_DATE#,<cfelse>NULL,</cfif>
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.REMOTE_ADDR#',
		UPDATE_EMP  = #session.ep.userid#
	WHERE
		HEALTY_REPORT_ID = #attributes.HEALTY_REPORT_ID#
</cfquery>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
    <cfelseif isdefined("attributes.draggable")>
        closeBoxDraggable( 'list' );
        closeBoxDraggable( 'healty_report_box' );
        openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_emp_healty_report&employee_id=#attributes.employee_id#</cfoutput>','healty_report_box');
	</cfif>
</script>