<cfif isDefined("attributes.password") and Len(attributes.password)>
	<cfset pass = Encrypt(attributes.password,session.ep.userid)>
<cfelse>	
	<cfset pass = "">
</cfif>

<cfquery name="add_exchange_mail_settings" datasource="#DSN#">  
	INSERT INTO
		EXCHANGE_SETTINGS
		
		(
			USER_ID,
			SERVER_ADDRESS,
			USERNAME,
			PASSWORD,
			PORT,
			PROTOCOL,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP
		)
		
		VALUES (
			#session.ep.userid#,
			'#attributes.SERVER_ADDRESS#',
			'#attributes.USERNAME#',
			'#attributes.PASSWORD#',
			'#attributes.PORT#',
			'#attributes.PROTOCOL#',
			#session.ep.userid#,
			#now()#,
			'#cgi.remote_addr#'	
		)
</cfquery>
 <cflocation url="#request.self#?fuseaction=correspondence.list_mymails_exchange" addtoken="no"> 
