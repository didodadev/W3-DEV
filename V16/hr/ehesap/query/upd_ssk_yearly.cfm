<cfif not isdefined("attributes.EMPLOYEE_ID")>
	<script type="text/javascript">
		alert("Çalışan Seçmelisiniz !");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfif not isdefined("attributes.in_out_id")>
	<script type="text/javascript">
		alert("Çalışan İçin Önce Giriş-Çıkış İşlemi Yapmalısınız !");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfquery name="check_ssk" datasource="#dsn#">
	SELECT
		*
	FROM
		EMPLOYEES_SALARY
	WHERE
		EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		AND PERIOD_YEAR = #attributes.SAL_YEAR#
		AND IN_OUT_ID = #attributes.in_out_id#
</cfquery>

<cfif check_ssk.recordcount>
	<cfquery name="add_salary" datasource="#dsn#">
		INSERT INTO
			EMPLOYEES_SALARY_HISTORY
			(
			EMPLOYEE_ID,
			PERIOD_YEAR,
			M1,
			M2,
			M3,
			M4,
			M5,
			M6,
			M7,
			M8,
			M9,
			M10,
			M11,
			M12,
			MONEY,
			RECORD_IP,
			RECORD_DATE,
			RECORD_EMP,
			IN_OUT_ID
			)
		VALUES
			(
			#attributes.EMPLOYEE_ID#,
			#attributes.SAL_YEAR#,
			<cfif len(check_ssk.M1)>#check_ssk.M1#<cfelse>0</cfif>,
			<cfif len(check_ssk.M1)>#check_ssk.M2#<cfelse>0</cfif>,
			<cfif len(check_ssk.M1)>#check_ssk.M3#<cfelse>0</cfif>,
			<cfif len(check_ssk.M1)>#check_ssk.M4#<cfelse>0</cfif>,
			<cfif len(check_ssk.M1)>#check_ssk.M5#<cfelse>0</cfif>,
			<cfif len(check_ssk.M1)>#check_ssk.M6#<cfelse>0</cfif>,
			<cfif len(check_ssk.M1)>#check_ssk.M7#<cfelse>0</cfif>,
			<cfif len(check_ssk.M1)>#check_ssk.M8#<cfelse>0</cfif>,
			<cfif len(check_ssk.M1)>#check_ssk.M9#<cfelse>0</cfif>,
			<cfif len(check_ssk.M1)>#check_ssk.M10#<cfelse>0</cfif>,
			<cfif len(check_ssk.M1)>#check_ssk.M11#<cfelse>0</cfif>,
			<cfif len(check_ssk.M1)>#check_ssk.M12#<cfelse>0</cfif>,
			'#check_ssk.MONEY#',
			'#CGI.REMOTE_ADDR#',
			#NOW()#,
			#SESSION.EP.USERID#,
			#attributes.in_out_id#
			)
	</cfquery>
	<!---
	<CFSET attributes.M10_ = attributes.M10>
	<cf_wrkCrypto value="attributes.M10_" isencryption="1" identityid="attributes.EMPLOYEE_ID">
	--->
	<cfquery name="upd_salary" datasource="#dsn#">
		UPDATE 
			EMPLOYEES_SALARY
		SET
			M1 = #attributes.M1#,
			M2 = #attributes.M2#,
			M3 = #attributes.M3#,
			M4 = #attributes.M4#,
			M5 = #attributes.M5#,
			M6 = #attributes.M6#,
			M7 = #attributes.M7#,
			M8 = #attributes.M8#,
			M9 = #attributes.M9#,
			M10 = #attributes.M10#,
			M11 = #attributes.M11#,
			M12 = #attributes.M12#,
			MONEY = '#attributes.MONEY#',
			UPDATE_IP = '#CGI.REMOTE_ADDR#',
			UPDATE_DATE = #NOW()#,
			UPDATE_EMP = #SESSION.EP.USERID#
		WHERE
			EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
			AND PERIOD_YEAR = #attributes.SAL_YEAR#
			AND IN_OUT_ID = #attributes.in_out_id#
	</cfquery>
<cfelse>
	<cfquery name="add_salary" datasource="#dsn#">
		INSERT INTO
			EMPLOYEES_SALARY
			(
			EMPLOYEE_ID,
			PERIOD_YEAR,
			M1,
			M2,
			M3,
			M4,
			M5,
			M6,
			M7,
			M8,
			M9,
			M10,
			M11,
			M12,
			MONEY,
			RECORD_IP,
			RECORD_DATE,
			RECORD_EMP,
			IN_OUT_ID
			)
		VALUES
			(
			#attributes.EMPLOYEE_ID#,
			#attributes.SAL_YEAR#,
			#attributes.M1#,
			#attributes.M2#,
			#attributes.M3#,
			#attributes.M4#,
			#attributes.M5#,
			#attributes.M6#,
			#attributes.M7#,
			#attributes.M8#,
			#attributes.M9#,
			#attributes.M10#,
			#attributes.M11#,
			#attributes.M12#,
			'#attributes.MONEY#',
			'#CGI.REMOTE_ADDR#',
			#NOW()#,
			#SESSION.EP.USERID#,
			#attributes.in_out_id#
			)
	</cfquery>
</cfif>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		location.reload();
	</cfif>
</script>
