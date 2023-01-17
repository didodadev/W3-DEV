<cfquery name="ADD_BUG" DATASOURCE="#DSN_DEV#">
	INSERT INTO BUG_REPORT 
			(
			<!--- <cfif len(attributes.pos_code)>
			POSITION_SOLVE,
			</cfif> --->
			WORKCUBE_ID,
			WORKCUBE_COMPANY,
			BUG_CIRCUIT,
			BUG_FUSEACTION,
			BUG_HEAD,
			BUG_BODY,
			RECORD_DATE,
			RECORD_IP,
			RECORD_EMP
			)
	VALUES
		(
			<!--- <cfif len(attributes.pos_code)>
			#attributes.POS_CODE#,
			</cfif> --->
			'#attributes.WORKCUBE_ID#',					
			'#attributes.WORKCUBE_COMPANY#',	
			'#attributes.BUG_CIRCUIT#',					
			'#attributes.BUG_FUSEACTION#',				
			'#attributes.BUG_HEAD#',		
			'#attributes.BUG_BODY#',		
			#now()#,
			'#CGI.REMOTE_ADDR#',
			#SESSION.EP.USERID#							
			)
</cfquery>
<cflocation url="#request.self#?fuseaction=help.add_bug_popup&ok=1" addtoken="No">	
