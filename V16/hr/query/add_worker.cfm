
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
	 alert("<cf_get_lang no ='1564.Çalışan seçiniz'> !");
	  history.back();
 </script>
 <cfabort>
</cfif>

<cfloop index="i" from="1" to="10">  
   
   <cfif LEN(EVALUATE("FORM.get_rol#i#"))>
    <cfset ROLE=EVALUATE("FORM.get_rol#i#")>
   </cfif>
 <cfif len(evaluate("FORM.POSITION_CODE#i#")) and evaluate("FORM.POSITION_CODE#i#")>
	<cfset position_code=evaluate("FORM.POSITION_CODE#i#")>
	<cfquery name="add_worker_emp" datasource="#DSN#">
      INSERT INTO 
        WORKGROUP_EMP_PAR
	     (
		  WORKGROUP_ID,
		  POSITION_CODE,
		  ROLE_ID,
		  RECORD_EMP,
		  RECORD_IP,
		  RECORD_DATE
		 )
		 VALUES
		 (
		  #attributes.WORKGROUP_ID#,
		  #position_code#,
		  <cfif len(evaluate("FORM.get_rol#i#"))>#ROLE#<cfelse>NULL</cfif>,
		  #session.ep.userid#,
		  '#cgi.remote_addr#',
		  #now()#
		 )
     </cfquery>
	 
  <cfelseif len(evaluate("FORM.PARTNER_ID#i#")) and evaluate("FORM.PARTNER_ID#i#")>

	   <cfset partner_id=evaluate("FORM.PARTNER_ID#i#")>
	   <cfquery name="add_worker_par" datasource="#DSN#">
         INSERT INTO 
          WORKGROUP_EMP_PAR
	       (
		     WORKGROUP_ID,
		     PARTNER_ID
		  <cfif len(evaluate("FORM.get_rol#i#"))>
		    ,ROLE_ID 
		  </cfif> 
		   )
		  VALUES
		   (
		      #attributes.WORKGROUP_ID#,
		      #partner_id#
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
