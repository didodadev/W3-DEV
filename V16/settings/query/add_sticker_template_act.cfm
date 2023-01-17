<cfif isdefined('attributes.del_id')>
	<cfquery name="DEL_STICKER" datasource="#DSN#">
			DELETE
				SETUP_STICKER
			WHERE
				STICKER_ID=#attributes.DEL_ID#							
	</cfquery>
<cfelseif isdefined('attributes.upd_id')>
	<!--- update --->
		<cfquery name="UPD_STICKER" datasource="#DSN#">
			UPDATE
				SETUP_STICKER
			SET
				STICKER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.STICKER_NAME#">  
				<cfif LEN(attributes.ROW_NUMBER)>                                     
				,ROW_NUMBER=#attributes.ROW_NUMBER#   
				</cfif>			
				<cfif LEN(attributes.COLUMN_NUMBER)>
				,COLUMN_NUMBER=#attributes.COLUMN_NUMBER# 
				</cfif>
				,HORIZONTAL_GAP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.HORIZONTAL_GAP#">       
				,VERTICAL_GAP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.VERTICAL_GAP#">          
				,STICKER_WIDTH = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.STICKER_WIDTH#">         
				,STICKER_LENGTH = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.STICKER_LENGTH#">
				,PAGE_TOP_BLANK = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAGE_TOP_BLANK#">
				,PAGE_FOT_BLANK = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAGE_FOT_BLANK#">
				,PAGE_RIGHT_BLANK = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAGE_RIGHT_BLANK#">
				,PAGE_LEFT_BLANK = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAGE_LEFT_BLANK#">
				,PAGE_HEIGHT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAGE_HEIGHT#">
				,PAGE_WIDTH = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAGE_WIDTH#"> 
				,PARTNER=<cfif IsDefined('attributes.partner') and len(attributes.partner)>1<cfelse>0</cfif>
				,UPDATE_EMP=#SESSION.EP.USERID#    
				,UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">                                         
				,UPDATE_DATE=#NOW()#                                            
			WHERE
				STICKER_ID=#attributes.STICKER_ID#							
	</cfquery>
	<cflocation addtoken="no" url="#request.self#?fuseaction=settings.form_upd_sticker_template&upd_id=#attributes.STICKER_ID#" >
<cfelse>
	<cfquery name="ADD_STICKER" datasource="#DSN#">
		INSERT INTO 
				SETUP_STICKER
			(
				STICKER_NAME,  
				<cfif LEN(attributes.ROW_NUMBER)>ROW_NUMBER,</cfif>
				<cfif LEN(attributes.COLUMN_NUMBER)>COLUMN_NUMBER,</cfif>
				HORIZONTAL_GAP, 
				VERTICAL_GAP,         
				STICKER_WIDTH,        
				STICKER_LENGTH,
				PAGE_TOP_BLANK,
				PAGE_FOT_BLANK,
				PAGE_RIGHT_BLANK,
				PAGE_LEFT_BLANK,
				PAGE_HEIGHT,
				PAGE_WIDTH,
				PARTNER,
				RECORD_EMP, 
				RECORD_IP,                                         
				RECORD_DATE                                            
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.STICKER_NAME#">,                                      
				<cfif LEN(attributes.ROW_NUMBER)>#attributes.ROW_NUMBER#,</cfif>
				<cfif LEN(attributes.COLUMN_NUMBER)>#attributes.COLUMN_NUMBER#,</cfif>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.HORIZONTAL_GAP#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.VERTICAL_GAP#">,         
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.STICKER_WIDTH#">,       
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.STICKER_LENGTH#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAGE_TOP_BLANK#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAGE_FOT_BLANK#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAGE_RIGHT_BLANK#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAGE_LEFT_BLANK#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAGE_HEIGHT#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PAGE_WIDTH#">, 
				<cfif IsDefined('attributes.partner') and len(attributes.partner)>1<cfelse>0</cfif>,
				#SESSION.EP.USERID#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				#NOW()#
			)				
	</cfquery>
</cfif>

<cflocation addtoken="no" url="#request.self#?fuseaction=settings.form_add_sticker_template" >
