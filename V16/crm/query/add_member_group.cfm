<cfset cont=0>
<cfset cont1=0>
<cfloop index="i" from="1" to="10">
   <cfif (  (len(evaluate("FORM.POSITION_CODE#i#")) eq 0) and (len(evaluate("FORM.PARTNER_ID#i#")) eq 0)  and (EVALUATE("FORM.get_rol#i#") neq 0))>
     <cfset cont=cont+1>
   </cfif>
   <cfif  (  (len(evaluate("FORM.POSITION_CODE#i#")) eq 0) and (len(evaluate("FORM.PARTNER_ID#i#")) eq 0)  and (EVALUATE("FORM.get_rol#i#") eq 0))>
     <cfset cont1=cont1+1>
   </cfif>
</cfloop>
<cfif (cont neq 0) or (cont1 eq 10)>
 <script type="text/javascript">
	 alert("<cf_get_lang no='25.Çalışan Seçiniz !'>");
	  history.back();
 </script>
 <cfabort>
</cfif>

 <cfloop index="i" from="1" to="10">  
   <cfif LEN(EVALUATE("FORM.get_rol#i#"))>
    <cfset ROLE=EVALUATE("FORM.get_rol#i#")>
   </cfif>
   
   <cfif len(evaluate("FORM.POSITION_CODE#i#")) and (evaluate("FORM.POSITION_CODE#i#") neq 0)>
	<cfset position_code=evaluate("FORM.POSITION_CODE#i#")>
	<cfquery name="add_worker_emp" datasource="#DSN#">
      INSERT INTO 
        WORKGROUP_EMP_PAR
	     (
		  COMPANY_ID,
		  POSITION_CODE
		  <cfif len(evaluate("FORM.get_rol#i#"))>
		   ,ROLE_ID 
		  </cfif> 
		 )
		 VALUES
		 (
		  #URL.CP_ID#,
		  #position_code#
		  <cfif len(evaluate("FORM.get_rol#i#"))>
		   ,#ROLE# 
		  </cfif> 
		 )
     </cfquery>
	 
	 <cfelseif len(evaluate("FORM.PARTNER_ID#i#")) and (evaluate("FORM.PARTNER_ID#i#") neq 0)>

	   <cfset partner_id=evaluate("FORM.PARTNER_ID#i#")>
	   <cfquery name="add_worker_par" datasource="#DSN#">
         INSERT INTO 
          WORKGROUP_EMP_PAR
	       (
		     COMPANY_ID,
		     PARTNER_ID
		  <cfif len(evaluate("FORM.get_rol#i#"))>
		    ,ROLE_ID 
		  </cfif> 
		   )
		  VALUES
		   (
		      #URL.CP_ID#,
		      #PARTNER_ID#
		  <cfif len(evaluate("FORM.get_rol#i#"))>
		     ,#ROLE# 
		  </cfif>  
		 )
     </cfquery>
	 </cfif>

    </cfloop>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
