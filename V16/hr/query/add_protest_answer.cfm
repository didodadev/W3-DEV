<cfquery name="ADD_PROTEST_ANSWER" datasource="#DSN#">
	UPDATE
	   EMPLOYEE_DAILY_IN_OUT_PROTESTS
    SET
	  ANSWER_EMP_ID=#session.ep.userid#,
	  ANSWER_DETAIL='#left(attributes.detail,500)#',
	  ANSWER_DATE=#now()#
   WHERE
      PROTEST_ID=#attributes.id#
</cfquery>
<!--- Mail To Employee--->
<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)>
	<cfsavecontent variable="message">PDKS İtiraz</cfsavecontent>
	<cfquery name="GET_EMP_MAIL" datasource="#dsn#"><!--- to kismini doldurur --->
		SELECT EMPLOYEE_EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID = #attributes.employee_id#
	</cfquery>
	<cfquery name="GET_PROTESTS" datasource="#DSN#"><!--- mail içerigi --->
		SELECT ANSWER_DETAIL FROM EMPLOYEE_DAILY_IN_OUT_PROTESTS WHERE PROTEST_ID=#attributes.id#		
	</cfquery>
	<cfif len(get_emp_mail.employee_email)>
		<cfmail to="#get_emp_mail.employee_email#" from="#session.ep.company#<#session.ep.company_email#>" type="html" subject="#message#">   
			<style type="text/css">
				.css1 {font-size:12px;font-family:arial,verdana;color:000000; background-color:white;}
			</style>
			<table width="600" class="css1">
				<tr>
					<td>#get_protests.answer_detail#</td>
				</tr>
			</table>
		</cfmail>
	<cfelse>
		<script language="javascript">
			alert('Çalışanın Mail Adresini Kontrol Ediniz !');
			window.close();
		</script>
	</cfif>
</cfif> 
<!--- // Mail To Employee--->
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
