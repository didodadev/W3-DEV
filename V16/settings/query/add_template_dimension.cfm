<cfquery name="GET_TEMPLATES" datasource="#DSN#">
	SELECT
		 TEMPLATE_ID
	FROM
		 SETUP_TEMPLATE_DIMENSION
</cfquery>

<cfif get_templates.RecordCount>
<!--- update --->
	<cfloop from="1" to="4" index="i">
		<cfif (evaluate('attributes.template_width' & i) NEQ '') and (evaluate('attributes.template_height' & i) NEQ '')>
			<cfquery name="GET_TEMPLATES" datasource="#DSN#">
				SELECT
					 TEMPLATE_ID
				FROM
					 SETUP_TEMPLATE_DIMENSION
				WHERE
					TEMPLATE_TYPE = #i#	 
			</cfquery>
			<cfif get_templates.RecordCount>
				<cfquery name="UPD_TEMPLATES" datasource="#DSN#">
					UPDATE
						SETUP_TEMPLATE_DIMENSION
					SET
					<cfif Len(evaluate('attributes.template_width' & i))>         
						TEMPLATE_WIDTH = #evaluate('attributes.template_width' & i)#  ,
					<cfelse>
						TEMPLATE_WIDTH = 0,
					</cfif>
					<cfif Len(evaluate('attributes.template_height' & i))>						
						TEMPLATE_HEIGHT = #evaluate('attributes.template_height' & i)# ,
					<cfelse>
						TEMPLATE_HEIGHT = 0,
					</cfif>					
					<cfif Len(evaluate('attributes.template_leftmargin' & i))>
						TEMPLATE_LEFTMARGIN = #evaluate('attributes.template_leftmargin' & i)#,
					<cfelse>
						TEMPLATE_LEFTMARGIN = 0,
					</cfif>
					<cfif Len(evaluate('attributes.template_topmargin' & i))>
						TEMPLATE_TOPMARGIN  = #evaluate('attributes.template_topmargin' & i)#,
					<cfelse>
						TEMPLATE_TOPMARGIN  = 0,
					</cfif>					
						TEMPLATE_UNIT   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.template_unit' & i)#">,
						TEMPLATE_ALIGN  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.template_align' & i)#">                                           
					WHERE
						TEMPLATE_TYPE = #i#							
				</cfquery>  	
		<cfelse>
			<cfquery name="GET_TEMPLATES" datasource="#DSN#">
				SELECT
					 MAX(TEMPLATE_ID) AS OUTPUT_MAX
				FROM
					 SETUP_TEMPLATE_DIMENSION
			</cfquery>	
			<cfif get_templates.output_max eq ''>
				<cfset OUTPUT_MAX = 1>
			<cfelse>
				<cfset OUTPUT_MAX = get_templates.output_max + 1>		
			</cfif>
			
			<cfquery name="ADD_TEMPLATES" datasource="#DSN#">
				INSERT INTO 
					SETUP_TEMPLATE_DIMENSION
				(
					TEMPLATE_ID, 
					TEMPLATE_WIDTH,
					TEMPLATE_HEIGHT,
					TEMPLATE_LEFTMARGIN,
					TEMPLATE_TOPMARGIN,						
					TEMPLATE_UNIT, 
					TEMPLATE_ALIGN,
					TEMPLATE_TYPE
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#OUTPUT_MAX#">,
					<cfif Len(evaluate('attributes.template_width' & i))>         
					#evaluate('attributes.template_width' & i)#,
					<cfelse>
					0,
					</cfif>
					<cfif Len(evaluate('attributes.template_height' & i))>						
					#evaluate('attributes.template_height' & i)#,
					<cfelse>
					0,
					</cfif>						
					<cfif Len(evaluate('attributes.template_leftmargin' & i))>
					#evaluate('attributes.template_leftmargin' & i)#,
					<cfelse>
					0,
					</cfif>
					<cfif Len(evaluate('attributes.template_topmargin' & i))>
					#evaluate('attributes.template_topmargin' & i)#,
					<cfelse>
					0,
					</cfif>						
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.template_unit' & i)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.template_align' & i)#">,
					#i#
				)				
			</cfquery>
		</cfif>		
	  </cfif>	  	  
	</cfloop>
	<cflocation addtoken="no" url="#request.self#?fuseaction=settings.form_add_template_dimension" >
<cfelse>
    <cfloop from="1" to="4" index="i">
	  <cfif (evaluate('attributes.template_width' & i) NEQ '') or (evaluate('attributes.template_height' & i) NEQ '')>
		<cfquery name="GET_TEMPLATES" datasource="#DSN#">
			SELECT
				 MAX(TEMPLATE_ID) AS OUTPUT_MAX
			FROM
				 SETUP_TEMPLATE_DIMENSION
		</cfquery>
		<cfif GET_TEMPLATES.OUTPUT_MAX EQ ''>
			<cfset OUTPUT_MAX = 1>
		<cfelse>
			<cfset OUTPUT_MAX = GET_TEMPLATES.OUTPUT_MAX + 1>		
		</cfif>
		
		<cfquery name="ADD_TEMPLATES" datasource="#DSN#">
			INSERT INTO 
				SETUP_TEMPLATE_DIMENSION
			(
				TEMPLATE_ID, 
				TEMPLATE_WIDTH,
				TEMPLATE_HEIGHT,
				TEMPLATE_LEFTMARGIN,
				TEMPLATE_TOPMARGIN,
				TEMPLATE_UNIT,
				TEMPLATE_ALIGN, 
				TEMPLATE_TYPE
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#OUTPUT_MAX#">,                                      
				<cfif Len(evaluate('attributes.template_width' & i))>         
				#evaluate('attributes.template_width' & i)#,
				<cfelse>
				0,
				</cfif>
				<cfif Len(evaluate('attributes.template_height' & i))>						
				#evaluate('attributes.template_height' & i)#,
				<cfelse>
				0,
				</cfif>	
				<cfif Len(evaluate('attributes.template_leftmargin' & i))>
				#evaluate('attributes.template_leftmargin' & i)#,
				<cfelse>
				0,
				</cfif>
				<cfif Len(evaluate('attributes.template_topmargin' & i))>
				#evaluate('attributes.template_topmargin' & i)#,
				<cfelse>
				0,
				</cfif>					
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.template_unit' & i)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.template_align' & i)#">,
				#i#
			)				
		</cfquery>
	  </cfif>	
	</cfloop>
</cfif>

<cflocation addtoken="no" url="#request.self#?fuseaction=settings.form_add_template_dimension">
