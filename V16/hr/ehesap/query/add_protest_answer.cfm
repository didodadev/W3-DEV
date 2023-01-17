<cfquery name="ADD_PROTEST_ANSWER" datasource="#DSN#">
	UPDATE
	   EMPLOYEES_PUANTAJ_PROTESTS
    SET
	  ANSWER_EMP_ID=#session.ep.userid#,
	  ANSWER_DETAIL='#left(attributes.detail,500)#',
	  ANSWER_DATE=#now()#
   WHERE
      PROTEST_ID=#attributes.id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
