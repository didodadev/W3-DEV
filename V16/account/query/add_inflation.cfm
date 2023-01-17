<cfquery name="CONTROL" datasource="#DSN#">
  SELECT 
  	* 
  FROM 
  	INFLATION 
  WHERE 
  	INF_MONTH = #MONTH# AND INF_YEAR = #YEAR# 
</cfquery>
<cfif control.recordcount EQ 0>
	<cfquery name="add_inflation" datasource="#DSN#">
	 INSERT INTO
	  INFLATION
	  (
		   INF_RATE,
		   INF_MONTH,
		   INF_YEAR,
		   RECORD_DATE,
		   RECORD_EMP
	  )
	  VALUES
	  (
		   #bill2#,
		   #MONTH#,
		   #YEAR#,
		   #NOW()#,
		   #SESSION.EP.USERID#
	  )
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
