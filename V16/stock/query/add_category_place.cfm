<cfif not isnumeric(attributes.DEPARTMENT_IN)>
	<cfset LOC_IN = listgetat(attributes.DEPARTMENT_IN,2,"-")>
	<cfset attributes.DEPARTMENT_IN = LISTGETAT(attributes.DEPARTMENT_IN,1,"-")>
</cfif>
<cf_date tarih='attributes.START_DATE'>
<cf_date tarih='attributes.FINISH_DATE'>
<cfquery name="ADD_PRODUCT_PLACE" datasource="#DSN3#">
	INSERT 
		INTO
			PRODUCT_CAT_PLACE
			(
				PRODUCT_CATID,
				DEPARTMENT_ID,
				<cfif isDefined("LOC_IN")>LOCATION_ID,</cfif>
				START_DATE,    
				FINISH_DATE,  
				RECORD_EMP,  
				RECORD_EMP_IP,                              
				RECORD_DATE,   
				<cfif len(attributes.detail)>DETAIL,</cfif>
				HEIGHT,
				WIDTH,
				DEPTH              
			)
		VALUES
			(
				#attributes.PRODUCT_CATID#,
				#attributes.DEPARTMENT_IN#,
				<cfif isDefined("LOC_IN")>#LOC_IN#,</cfif>
				#attributes.START_DATE#,
				#attributes.FINISH_DATE#,
				#session.ep.userid#,
				'#CGI.REMOTE_ADDR#',			
				#now()#,
				<cfif len(attributes.detail)>'#attributes.detail#',</cfif>
				<cfif len(attributes.HEIGHT)>#attributes.HEIGHT#,<cfelse>NULL,</cfif>
				<cfif len(attributes.WIDTH)>#attributes.WIDTH#,<cfelse>NULL,</cfif>
				<cfif len(attributes.DEPTH)>#attributes.DEPTH#<cfelse>NULL</cfif>				
		)	
</cfquery>
<script type="text/javascript">
	location.reload();
	self.close();
</script>
