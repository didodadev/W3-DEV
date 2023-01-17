<cfset cont=0>
<cfset cont1=0>
<cfloop index="i" from="1" to="10">
  <cfif ((len(evaluate("FORM.POSITION_CODE#i#")) eq 0) and (len(evaluate("FORM.PARTNER_ID#i#")) eq 0) and (EVALUATE("FORM.get_rol#i#") neq 0))>
	<cfset cont=cont+1>
  </cfif>
  <cfif ((len(evaluate("FORM.POSITION_CODE#i#")) eq 0) and (len(evaluate("FORM.PARTNER_ID#i#")) eq 0) and (EVALUATE("FORM.get_rol#i#") eq 0))>
	<cfset cont1=cont1+1>
  </cfif>
</cfloop>
<cfif (cont neq 0) or (cont1 eq 10)>
  <script type="text/javascript">
	alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='164.Çalışan'>");
	history.back();
  </script>
  <cfabort>
</cfif>

<cfloop index="i" from="1" to="10">  
  <cfif len(evaluate("attributes.get_rol#i#"))>
	<cfset role=evaluate("attributes.get_rol#i#")>
  </cfif>

  <cfif len(evaluate("attributes.position_code#i#")) and (evaluate("attributes.position_code#i#") neq 0)>
	<cfset position_code=evaluate("attributes.position_code#i#")>
	<cfquery name="ADD_WORKER_EMP" datasource="#DSN#">
		INSERT INTO 
			SALES_ZONE_GROUP
		(
			SZ_ID,
			POSITION_CODE
		  <cfif len(evaluate("attributes.get_rol#i#"))>
			,ROLE_ID 
		  </cfif> 
		)
		VALUES
		(
			#url.sz_id#,
			#position_code#
		  <cfif len(evaluate("attributes.get_rol#i#"))>
			,#role# 
		  </cfif> 
		)
	</cfquery>
 
  <cfelseif len(evaluate("attributes.partner_id#i#")) and (evaluate("attributes.partner_id#i#") neq 0)>

	<cfset partner_id=evaluate("attributes.partner_id#i#")>
	<cfquery name="ADD_WORKER_PAR" datasource="#DSN#">
		INSERT INTO 
			SALES_ZONE_GROUP
		(
			SZ_ID,
			PARTNER_ID
		  <cfif len(evaluate("attributes.get_rol#i#"))>
			,ROLE_ID 
		  </cfif> 
		)
		VALUES
		(
			#url.sz_id#,
			#partner_id#
		  <cfif len(evaluate("attributes.get_rol#i#"))>
			,#role# 
		  </cfif>  
		)
	</cfquery>
  </cfif>
</cfloop>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');</cfif>
	wrk_opener_reload();
	window.close();
</script>
