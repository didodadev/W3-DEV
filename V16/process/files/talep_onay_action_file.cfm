<!---
	FB 20070507
	Bu dosya ilgili harcama talebinin onay asamasi icin hazirlanmistir. Onay olan surec satirina eklenmelidir.
	Ayrica surec kullanmadan harcamayi masraf fisine donusturecek firmalarda surece tek asama kaydedilir ve bu asamaya action file olarak eklenmelidir.
 --->

<cfquery name="UPDATE_EXPENSE_ITEM_PLAN_REQUESTS" datasource="#attributes.data_source#">
	UPDATE
		#caller.dsn2_alias#.EXPENSE_ITEM_PLAN_REQUESTS
	SET
		IS_APPROVE = 1,
		VALID_EMP = #session.ep.userid#,
		VALID_DATE = #now()# 
	WHERE
		EXPENSE_ID = #attributes.action_id#
</cfquery>
