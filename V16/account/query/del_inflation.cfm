<cfquery name="del_inflation" datasource="#DSN#">
  DELETE 
  FROM 
  	INFLATION 
  WHERE 
  	INF_ID = #attributes.INF_ID#
</cfquery>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');</cfif>
</script>
