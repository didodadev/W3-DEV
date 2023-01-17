<!---
	FB 20121016
	Bu dosya ilgili harcama talebinin revize asamasi icin hazirlanmistir. Revize olan surec satirina eklenmelidir.
 --->

<cfquery name="UPDATE_EXPENSE_ITEM_PLAN_REQUESTS" datasource="#attributes.data_source#">
	UPDATE
		#caller.dsn2_alias#.EXPENSE_ITEM_PLAN_REQUESTS
	SET
		IS_APPROVE = NULL,
		VALID_EMP = #session.ep.userid#,
		VALID_DATE = #now()# 
	WHERE
		EXPENSE_ID = #attributes.action_id#
</cfquery>
