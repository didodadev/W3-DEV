<cfif len(attributes.PRIZE_DATE)>
	<CF_DATE tarih="attributes.PRIZE_DATE">
</cfif>
<cfquery name="ADD_PRIZE" datasource="#DSN#">
  UPDATE EMPLOYEES_PRIZE 
   SET
	PRIZE_GIVE_PERSON = #attributes.prize_give_person_id#,
	PRIZE_TYPE_ID = #attributes.PRIZE_TYPE#,
	PRIZE_DATE = <cfif LEN(attributes.PRIZE_DATE)>#attributes.PRIZE_DATE#,<cfelse>NULL,</cfif>
	PRIZE_TO = #attributes.PRIZE_TO_ID#,
	PRIZE_HEAD = '#attributes.PRIZE_HEAD#',
	PRIZE_DETAIL = <cfif LEN(attributes.PRIZE_DETAIL)>'#attributes.PRIZE_DETAIL#',<cfelse>NULL,</cfif>
	UPDATE_EMP = #SESSION.EP.USERID#,
	UPDATE_IP = '#CGI.REMOTE_ADDR#',
	UPDATE_DATE = #NOW()#
  WHERE
  	PRIZE_ID = #attributes.PRIZE_ID#
</cfquery>	
<cfset attributes.actionId = attributes.PRIZE_ID>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');</cfif>
</script>

