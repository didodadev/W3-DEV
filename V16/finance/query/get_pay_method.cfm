<cfquery name="pay_method"	 datasource="#DSN#">
	SELECT
		* 	
	FROM
		SETUP_PAYMETHOD
	WHERE
		PAYMETHOD_STATUS = 1 AND
		PAYMETHOD_ID = #PAY_METHOD# AND
		IN_ADVANCE <> 100	
</cfquery>
