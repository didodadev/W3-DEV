<cfif not isnumeric(attributes.DEPARTMENT_IN)>
	<cfset LOC_IN=LISTGETAT(attributes.DEPARTMENT_IN,2,"-")>
	<cfset attributes.DEPARTMENT_IN=LISTFIRST(attributes.DEPARTMENT_IN,"-")>
</cfif>
<CF_DATE tarih='attributes.START_DATE'>
<CF_DATE tarih='attributes.FINISH_DATE'>

<cfquery name="UPD_PRODUCT_PLACE" datasource="#DSN3#">
	UPDATE
		PRODUCT_CAT_PLACE
	SET
		PRODUCT_CATID=#attributes.PRODUCT_CATID#,
		DEPARTMENT_ID=#attributes.DEPARTMENT_IN#,
		<cfif isDefined("LOC_IN") > 
		LOCATION_ID=#LOC_IN#,
		</cfif>
		START_DATE=#attributes.START_DATE#,   
		FINISH_DATE=#attributes.FINISH_DATE#,
		UPDATE_EMP=#session.ep.userid#,  
		UPDATE_EMP_IP='#CGI.REMOTE_ADDR#',	                           
		UPDATE_DATE =#now()#,
		DETAIL='#attributes.detail#',
		HEIGHT=<cfif len(attributes.HEIGHT)>#attributes.HEIGHT#,<cfelse>NULL,</cfif>
		WIDTH=<cfif len(attributes.WIDTH)>#attributes.WIDTH#,<cfelse>NULL,</cfif>
		DEPTH=<cfif len(attributes.DEPTH)>#attributes.DEPTH#<cfelse>NULL</cfif>			
	WHERE
		PC_PLACE_ID=#attributes.PC_PLACE_ID#	
</cfquery>
<script type="text/javascript">
	location.reload();
	self.close();
</script>
