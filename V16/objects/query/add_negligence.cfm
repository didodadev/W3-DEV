<cf_date tarih='attributes.SIGN_DATE'>

<cfquery name="add_ne">
	INSERT INTO 
		EMPLOYEES_NEGLIGENCE_REPORT
		(
			OUR_COMPANY_ID,
			TO_CAUTION,
			SIGN_DATE,
			WITNESS_1,
			WITNESS_2,
			WITNESS_3
		)
		VALUES
		(
			#SESSION.EP.COMPANY_ID#,
			#attributes.caution_to_id#,
			#attributes.SIGN_DATE#,
			#attributes.WITNESS1_ID#,
			#attributes.WITNESS2_ID#,
			#attributes.WITNESS3_ID#
		)
</cfquery>
<script type="text/javascript">
	window.close();
</script>
