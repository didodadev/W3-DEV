<cfset relative_url_string = "">
<cfset ssk_ek = "">
<cfquery name="DEL_RELATIVE" datasource="#DSN#">
  DELETE FROM
 	EMPLOYEES_RELATIVES
  WHERE
	RELATIVE_ID=#attributes.RELATIVE_ID#
</cfquery>
<cf_add_log  log_type="-1" action_id="#attributes.RELATIVE_ID#" action_name="#attributes.head# " >
  <script>
      location.href= document.referrer;
  </script>
