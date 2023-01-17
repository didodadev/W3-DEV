<cfif not isDefined("attributes.UPD")>
	<cfquery name="add_bill" datasource="#dsn2#">
		INSERT INTO 
			BILLS
		(
			BILL_NO,
			TEDIYE_BILL_NO,
			TAHSIL_BILL_NO,
			MAHSUP_BILL_NO
		)
		VALUES
		(
			#attributes.BILL#,
			#attributes.TE_BILL#,
			#attributes.T_BILL#,
			#attributes.M_BILL#
		)
	</cfquery>
<cfelse>
	<cfquery name="UPD_BILLS" datasource="#DSN2#">
		UPDATE
			BILLS
		SET
			BILL_NO=#attributes.BILL#,
			TEDIYE_BILL_NO=#attributes.TE_BILL#,
			TAHSIL_BILL_NO=#attributes.T_BILL#,
			MAHSUP_BILL_NO=#attributes.M_BILL#
	</cfquery>
</cfif>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=account.bill_no';
</script>