<cfquery name="GET_BILL_no" datasource="#dsn2#">
	SELECT
		BILL_NO,
		MAHSUP_BILL_NO,
		TAHSIL_BILL_NO,
		TEDIYE_BILL_NO
	FROM
		BILLS
</cfquery>
