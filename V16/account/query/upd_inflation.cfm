<cfquery name="CONTROL" datasource="#DSN#">
 	 SELECT 
	 		*
	 FROM
		 	INFLATION 
	 WHERE 
		 	INF_MONTH = #MONTH# 
	 	AND 
			INF_YEAR = #YEAR#
		AND 
			INF_ID <> #attributes.INF_ID#
</cfquery>
<cfif control.recordcount EQ 0>
<cfquery name="upd_inf" datasource="#DSN#">
   UPDATE INFLATION
	 SET
	   INF_RATE = #bill2#,
	   INF_MONTH = #MONTH#,
	   INF_YEAR = #YEAR#,
       UPDATE_DATE = #now()#,
	    UPDATE_EMP = #session.ep.userid#,
	    UPDATE_IP =	'#cgi.remote_addr#'	
	WHERE
	   INF_ID = #attributes.INF_ID#  
</cfquery>
<script type="text/javascript">
    <cfif not isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');</cfif>
</script>
<cfelse>
	<script type="text/javascript">
		 alert("<cf_get_lang no='98.Aynı ay ve yıl için iki kez enflasyon oranı giremezsiniz !'>");
		<cfif not isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');</cfif>
	</script>
</cfif>
