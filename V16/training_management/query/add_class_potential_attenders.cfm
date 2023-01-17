<cfquery name="GET_CLASS" datasource="#DSN#">
	SELECT 
        TRAINING_ID, 
        CLASS_ID, 
        START_DATE, 
        FINISH_DATE, 
        CLASS_ANNOUNCEMENT_DETAIL
    FROM 
    	TRAINING_CLASS 
    WHERE 
    	CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
</cfquery>
<cfif isdefined('par_ids') and len(par_ids)>
	<cfloop list="#par_ids#" index="par_id">
		<cfquery name="GET_CLASS_PAR_ATT" datasource="#DSN#">
			SELECT 
				TRAINING_CLASS.START_DATE,
				TRAINING_CLASS.FINISH_DATE,
				TRAINING_CLASS.CLASS_ID
			FROM
				TRAINING_CLASS,
				TRAINING_CLASS_ATTENDER 
			WHERE 
				TRAINING_CLASS_ATTENDER.CLASS_ID = TRAINING_CLASS.CLASS_ID 
				AND TRAINING_CLASS_ATTENDER.PAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#par_id#">
				AND
				(
					(
					  	TRAINING_CLASS.START_DATE >= #CreateODBCDateTime(get_class.start_date)# AND
					  	TRAINING_CLASS.START_DATE < #CreateODBCDateTime(get_class.finish_date)#
					)
					OR
					(
					  	TRAINING_CLASS.FINISH_DATE >= #CreateODBCDateTime(get_class.start_date)# AND
					  	TRAINING_CLASS.FINISH_DATE < #CreateODBCDateTime(get_class.start_date)#
					) 
				)
		</cfquery>
		<cfif get_class_par_att.recordcount>
			<cfif get_class_par_att.CLASS_ID neq attributes.class_id>
				<script type="text/javascript">
					alert("<cfoutput>#get_par_info(par_id,0,-1,0)#</cfoutput> <cf_get_lang no ='518.Bu tarihler arasında başka bir eğitimde katılımcıdır'>");
					window.history.back();
					//window.close();
				</script>
				<cfabort>
			<cfelse>
				<script type="text/javascript">
					alert("<cfoutput>#get_par_info(par_id,0,-1,0)#</cfoutput> <cf_get_lang no ='519.Seçtiğiniz eğitime zaten katılımcıdır'>");
					window.history.back();
					//window.close();
				</script>
				<cfabort>
			</cfif>
		</cfif>
		<cfquery name="GET_CLASS_POTENTIAL_ATTENDER" datasource="#DSN#">
			SELECT PAR_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#"> AND PAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#par_id#">
		</cfquery>
		<cfif not get_class_potential_attender.recordcount>
			<cfquery name="ADD_CLASS_POTENTIAL_ATTENDERS" datasource="#DSN#">
				INSERT INTO
					TRAINING_CLASS_ATTENDER
					(
                        CLASS_ID,
                        PAR_ID,
                        IS_SELFSERVICE	
					)
					VALUES
					(
                        #attributes.class_id#,
                        #par_id#,
                        0
					)
			</cfquery>
		</cfif>
	</cfloop>
<cfelseif isdefined('con_ids') and len(con_ids)>
	<cfloop list="#con_ids#" index="con_id">
		<cfquery name="GET_CLASS_CONS_ATT" datasource="#DSN#">
			SELECT 
				TRAINING_CLASS.START_DATE ,
				TRAINING_CLASS.FINISH_DATE,
				TRAINING_CLASS.CLASS_ID
			FROM
				TRAINING_CLASS,
				TRAINING_CLASS_ATTENDER 
			WHERE 
				TRAINING_CLASS_ATTENDER.CLASS_ID = TRAINING_CLASS.CLASS_ID 
				AND TRAINING_CLASS_ATTENDER.CON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#con_id#">
				AND
				(
				   (
					  	TRAINING_CLASS.START_DATE >= #CreateODBCDateTime(get_class.start_date)#
						AND
					  	TRAINING_CLASS.START_DATE < #CreateODBCDateTime(get_class.finish_date)#
					)
					OR
					(
					  	TRAINING_CLASS.FINISH_DATE >= #CreateODBCDateTime(get_class.start_date)#
						AND
					  	TRAINING_CLASS.FINISH_DATE < #CreateODBCDateTime(get_class.finish_date)#
					) 
				)
		</cfquery>
		<cfif get_class_cons_att.recordcount>
			<cfif get_class_cons_att.class_id neq attributes.class_id>
				<script type="text/javascript">
					alert("<cfoutput>#get_cons_info(con_id,0,0)#</cfoutput> <cf_get_lang no ='518.Bu tarihler arasında başka bir eğitimde katılımcıdır'>");
					window.history.back();
					//window.close();
				</script>
				<cfabort>
			<cfelse>
				<script type="text/javascript">
					alert("<cfoutput>#get_cons_info(con_id,0,0)#</cfoutput> <cf_get_lang no ='519.Seçtiğiniz eğitime zaten katılımcıdır'>");
					window.history.back();
					//window.close();
				</script>
				<cfabort>
			</cfif>
		</cfif>
		<cfquery name="GET_CLASS_POTENTIAL_ATTENDER" datasource="#DSN#">
			SELECT CON_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#"> AND CON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#con_id#">
		</cfquery>
		<cfif not get_class_potential_attender.recordcount>
			<cfquery name="ADD_CLASS_POTENTIAL_ATTENDERS" datasource="#DSN#">
				INSERT INTO
					TRAINING_CLASS_ATTENDER
					(
                        CLASS_ID,
                        CON_ID,
                        IS_SELFSERVICE	
					)
					VALUES
					(
                        #attributes.class_id#,
                        #con_id#,
                        0
					)
			</cfquery>
		</cfif>
	</cfloop>
<cfelse>
	<cfloop list="#emp_ids#" index="emp_id">
		<cfquery name="GET_CLASS_POTENTIAL_ATTENDER" datasource="#DSN#">
			SELECT EMP_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#"> AND EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#emp_id#">
		</cfquery>
		<cfquery name="GET_CLASS_EMP_ATT" datasource="#DSN#">
			SELECT 
				TRAINING_CLASS.START_DATE ,
				TRAINING_CLASS.FINISH_DATE,
				TRAINING_CLASS.CLASS_ID
			FROM
				TRAINING_CLASS,
				TRAINING_CLASS_ATTENDER 
			WHERE 
				TRAINING_CLASS_ATTENDER.CLASS_ID = TRAINING_CLASS.CLASS_ID 
				AND TRAINING_CLASS_ATTENDER.EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#emp_id#">
				AND
				(
				    (
					  	TRAINING_CLASS.START_DATE >= #CreateODBCDateTime(get_class.start_date)# AND
					  	TRAINING_CLASS.START_DATE < #CreateODBCDateTime(get_class.finish_date)#
					)
					OR
					(
					  	TRAINING_CLASS.FINISH_DATE >= #CreateODBCDateTime(get_class.start_date)# AND
					  	TRAINING_CLASS.FINISH_DATE < #CreateODBCDateTime(get_class.finish_date)#
					) 
				)
		</cfquery>
		<cfif get_class_emp_att.recordcount>
			<cfif get_class_emp_att.class_id neq attributes.class_id>
				<script type="text/javascript">
					alert("<cfoutput>#get_emp_info(emp_id,0,0)#</cfoutput> <cf_get_lang no ='518.Bu tarihler arasında başka bir eğitimde katılımcıdır'>");
					window.history.back();
					//window.close();
				</script>
				<cfabort>
			<cfelseif not isdefined("control_emp_id_#emp_id#")>
				<script type="text/javascript">
					alert("<cfoutput>#get_emp_info(emp_id,0,0)#</cfoutput> <cf_get_lang no ='519.Seçtiğiniz eğitime zaten katılımcıdır'>");
					window.history.back();
					//window.close();
				</script>
				<cfabort>
			</cfif>
		</cfif>
		<cfif not get_class_potential_attender.recordcount>
			<cfset "control_emp_id_#emp_id#" = 1>
			<cfquery name="ADD_CLASS_POTENTIAL_ATTENDERS" datasource="#DSN#">
				INSERT INTO
					TRAINING_CLASS_ATTENDER
					(
						CLASS_ID,
						EMP_ID,
						IS_SELFSERVICE
					)
				VALUES
					(
						#attributes.class_id#,
						#emp_id#,
						0
					)
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
 <script type="text/javascript">
	wrk_opener_reload();
	window.history.back();
	<!---window.close();--->
</script> 
