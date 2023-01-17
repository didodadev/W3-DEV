<!--- Masraf Fişi --->
<cfset attributes.expense_id = attributes.iid>
<cfquery name="get_expense" datasource="#dsn2#">	
	SELECT 
		*
	FROM
		EXPENSE_ITEM_PLAN_REQUESTS
	WHERE
		EXPENSE_ID = #attributes.expense_id#		
</cfquery>

<table border="0" cellspacing="0" cellpadding="0">
    <tr valign="top" border="0">
        <td style="text-align:center;width:21mm;">Belge No</td>
		<td style="text-align:center;width:21mm;">Belge Tarihi</td>
		<td style="text-align:center;width:21mm;">Çalışan</td>
	</tr>
	<tr>
		<td style="text-align:center;"><cfoutput>#get_expense.PAPER_NO#</cfoutput></td>
		<td style="text-align:center;"><cfoutput>#dateformat(get_expense.EXPENSE_DATE,dateformat_style)#</cfoutput></td>
		<td style="text-align:center;"><cfoutput>#get_emp_info(get_expense.EMP_ID,0,0)#</cfoutput></td>
	</tr>
	<tr>
		<td>
		</td>
	</tr>
	<tr>
		<td style="text-align:center;">Arşivleyen : </td>
		<td colspan="2"><cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput></td>
	</tr>
</table>