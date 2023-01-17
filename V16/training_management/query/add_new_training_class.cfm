<cfif LEN(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
	<cfset attributes.finish_date = date_add('h', FORM.EVENT_finish_CLOCK - session.ep.TIME_ZONE, attributes.finish_date)>
	<cfset attributes.finish_date = date_add('n', FORM.EVENT_finish_minute, attributes.finish_date)>
</cfif>
<cfif LEN(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
	<cfset attributes.start_date = date_add('h', FORM.EVENT_START_CLOCK - session.ep.TIME_ZONE, attributes.start_date)>
	<cfset attributes.start_date = date_add('n', FORM.EVENT_START_minute, attributes.start_date)>
</cfif>
<cfif len(trim(emp_id)) and len(attributes.start_date) and len(attributes.finish_date)>
	<cfquery name="get_warning" datasource="#dsn#">
    	SELECT
        	TCT.CLASS_ID
		FROM
			TRAINING_CLASS_TRAINERS TCT,
            TRAINING_CLASS TC
		WHERE
        	TC.CLASS_ID = TCT.CLASS_ID AND
			TC.START_DATE <= #attributes.finish_date# AND
			TC.FINISH_DATE >=#attributes.start_date# AND
			TCT.EMP_ID = #emp_id#
		<!---SELECT
			CLASS_ID
		FROM
			TRAINING_CLASS
		WHERE
			START_DATE <= #attributes.finish_date# AND
			FINISH_DATE >=#attributes.start_date# AND
			TRAINER_EMP = #emp_id#---> <!---20131021 eğitimciler başka tabloda tutuluyor--->
	</cfquery>
	<cfif get_warning.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='515.Seçilen Tarihlerde Eğitimci Başka Bir Eğitimde Görevli'>");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>

<CFLOCK name="#CREATEUUID()#" timeout="20">
	<CFTRANSACTION>

	<cfinclude template="get_class.cfm">
		
		<cfquery name="ADD_CLASS" datasource="#DSN#" result="MAX_ID">
			INSERT INTO
				TRAINING_CLASS
				(
				TRAINING_SEC_ID,
				TRAINING_CAT_ID,
				TRAINING_ID,
				QUIZ_ID,
				CLASS_NAME,
				CLASS_TARGET,
				CLASS_OBJECTIVE,
				CLASS_PLACE,
				CLASS_PLACE_ADDRESS,
				CLASS_PLACE_TEL,
				CLASS_PLACE_MANAGER,
				START_DATE,
				FINISH_DATE,
				MONTH_ID,
				DATE_NO,
				HOUR_NO,
				ONLINE,
				INT_OR_EXT,
				CLASS_TOOLS,
				PROCESS_STAGE,
			<!---<cfif LEN(Trim(emp_id))>
			   TRAINER_EMP,
			<cfelseif LEN(Trim(par_id))>
			   TRAINER_PAR,
			</cfif>---> <!---20131021 eğitimciler başka tabloda tutuluyor--->
				<!--- TRAINING_STYLE,
				TRAINING_TYPE, --->
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP<!--- ,
				CLASS_RESPONSIBLE --->
				)
			VALUES
				(
				<cfif Len(get_class.TRAINING_SEC_ID)>#get_class.TRAINING_SEC_ID#<cfelse>NULL</cfif>,
				<cfif Len(get_class.TRAINING_CAT_ID)>#get_class.TRAINING_CAT_ID#<cfelse>NULL</cfif>,
				<cfif Len(get_class.TRAINING_ID)>#get_class.TRAINING_ID#<cfelse>NULL</cfif>,
				<cfif Len(get_class.QUIZ_ID)>#get_class.QUIZ_ID#<cfelse>NULL</cfif>,
				'#attributes.CLASS_NAME#',
				'#get_class.CLASS_TARGET#',
				'#get_class.CLASS_OBJECTIVE#',
				'#get_class.CLASS_PLACE#',
				'#get_class.CLASS_PLACE_ADDRESS#',
				'#get_class.CLASS_PLACE_TEL#',
				'#get_class.CLASS_PLACE_MANAGER#',
				<cfif LEN(attributes.START_DATE)>#attributes.START_DATE#,<cfelse>NULL,</cfif>
				<cfif LEN(attributes.FINISH_DATE)>#attributes.FINISH_DATE#,<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.MONTH_ID") and len(attributes.MONTH_ID)>#attributes.MONTH_ID#,<cfelse>NULL,</cfif>
				<cfif Len(get_class.DATE_NO)>#get_class.DATE_NO#<cfelse>NULL</cfif>,
				<cfif Len(get_class.HOUR_NO)>#get_class.HOUR_NO#<cfelse>NULL</cfif>,
				<cfif Len(get_class.ONLINE)>#get_class.ONLINE#<cfelse>NULL</cfif>,
				<cfif Len(get_class.INT_OR_EXT)>#get_class.INT_OR_EXT#<cfelse>NULL</cfif>,
				'#get_class.CLASS_TOOLS#',
				#attributes.process_stage#,
			<!---<cfif LEN(Trim(emp_id))>
			    #emp_id#,
			<cfelseif LEN(Trim(par_id))>
			    #par_id#,
			</cfif>---> <!---20131021 eğitimciler başka tabloda tutuluyor--->
				<!--- <cfif Len(get_class.TRAINING_STYLE)>#get_class.TRAINING_STYLE#<cfelse>NULL</cfif>,
				<cfif Len(get_class.TRAINING_TYPE)>#get_class.TRAINING_TYPE#<cfelse>NULL</cfif>, --->
				#SESSION.EP.USERID#,
				#Now()#,
				'#CGI.REMOTE_ADDR#'<!--- ,
				<cfif Len(get_class.CLASS_RESPONSIBLE)>#get_class.CLASS_RESPONSIBLE#<cfelse>NULL</cfif> --->
				)
		</cfquery>
		<cfif isdefined("flashComServerApplicationsPath") and len(flashComServerApplicationsPath)>
			<CFDIRECTORY action="list" directory="#flashComServerApplicationsPath#class#dir_seperator#" mode="777" name="queryname">
			 <cfoutput>
				<cfloop query="queryname">
					<cfif Type IS 'Dir' and Name IS 'class#MAX_ID.IDENTITYCOL#'>
						<cfset kontroldegiskeni = 1>
						<cfbreak>
					<cfelse>
						<cfset kontroldegiskeni = 0>
					</cfif>
				</cfloop>
			</cfoutput>
			<!--- <cfif kontroldegiskeni IS 0>
				<CFDIRECTORY 
					action="create" 
					directory="#flashComServerApplicationsPath#class#dir_seperator#class#GET_CLASS_ID.MAX_ID#" 
					mode="777">
					
				<cffile 
					action="copy" 
					source="#flashComServerApplicationsPath#main.asc" 
					destination="#flashComServerApplicationsPath#class#dir_seperator#class#GET_CLASS_ID.MAX_ID##dir_seperator#main.asc" mode="777">
			</cfif> --->
		</cfif>
		<cfif len(attributes.emp_id) or len(attributes.par_id) or len(attributes.cons_id)>
			<cfquery name="add_emp_announce" datasource="#dsn#"> <!---20131021 eğitimci ekleniyor--->
				INSERT INTO
					TRAINING_CLASS_TRAINERS
					(
						CLASS_ID,
						EMP_ID,
						PAR_ID,
						CONS_ID,
						RECORD_EMP,
						RECORD_DATE,
						RECORD_IP
					)
				VALUES
					(
						#MAX_ID.IDENTITYCOL#,
						<cfif len(attributes.emp_id)>
							#attributes.emp_id#,
							NULL,
							NULL,
						<cfelseif len(attributes.par_id)>
							NULL,
							#attributes.par_id#,
							NULL,
						<cfelseif len(attributes.cons_id)>
							NULL,
							NULL,
							#attributes.cons_id#,
					   </cfif>
					   #session.ep.userid#,
					   #now()#,
					   '#cgi.REMOTE_ADDR#'
					)	
			</cfquery>
		</cfif>
		<cf_workcube_process 
			is_upd='1' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_table='TRAINING_CLASS'
			action_column='CLASS_ID'
			action_id='#MAX_ID.IDENTITYCOL#'
			action_page='#request.self#?fuseaction=training_management..list_class&event=upd&class_id=#MAX_ID.IDENTITYCOL#' 
			warning_description = 'Eğitim : #MAX_ID.IDENTITYCOL#'>
		
		<!--- <cfloop list="#FORM.ATTENDERS#" index="i" delimiters=",">
			<cfif i contains "EMP">
				<cfquery name="ADD_CLASS" datasource="#DSN#">
					INSERT INTO
						TRAINING_CLASS_ATTENDER
						(
						CLASS_ID,
						EMP_ID
						)
					VALUES
						(
						#GET_CLASS_ID.MAX_ID#,
						#LISTGETAT(I,2,'-')#
						)
				</cfquery>
			<cfelseif i contains "par">
				<cfquery name="ADD_CLASS" datasource="#DSN#">
					INSERT INTO
						TRAINING_CLASS_ATTENDER
						(
						CLASS_ID,
						PAR_ID,
						COMP_ID
						)
					VALUES
						(
						#GET_CLASS_ID.MAX_ID#,
						#LISTGETAT(I,2,'-')#,
						#LISTGETAT(I,3,'-')#
						)
				</cfquery>
			<cfelseif i contains "con">
				<cfquery name="ADD_CLASS" datasource="#DSN#">
					INSERT INTO
						TRAINING_CLASS_ATTENDER
						(
						CLASS_ID,
						CON_ID
						)
					VALUES
						(
						#GET_CLASS_ID.MAX_ID#,
						#LISTGETAT(I,2,'-')#
						)
				</cfquery>
			<cfelseif i contains "grp">
				<cfquery name="ADD_CLASS" datasource="#DSN#">
					INSERT INTO
						TRAINING_CLASS_ATTENDER
						(
						CLASS_ID,
						GRP_ID
						)
					VALUES
						(
						#GET_CLASS_ID.MAX_ID#,
						#LISTGETAT(I,2,'-')#
						)
				</cfquery>
			</cfif>
		</cfloop> --->

		


<!--- burada katılımcılar önce seçilip sonra ekleniyor. --->

		<!--- <cfquery name="GET_CLASS_ATTENDER" datasource="#dsn#">
			SELECT
				*
			FROM
				TRAINING_CLASS_ATTENDER
			WHERE
				CLASS_ID=#attributes.CLASS_ID#
		</cfquery>
		<cfif GET_CLASS_ATTENDER.RECORDCOUNT>
			<cfloop query="GET_CLASS_ATTENDER">
				<cfquery name="ADD_CLASS_ATTENDERS" datasource="#dsn#">
					INSERT INTO
						TRAINING_CLASS_ATTENDER
						(
						CLASS_ID,
						EMP_ID,
						COMP_ID,
						PAR_ID,
						CON_ID,
						GRP_ID,
						STATUS
						)
					VALUES
						(
						#GET_CLASS_ID.MAX_ID#,
						<cfif Len(EMP_ID)>#EMP_ID#<cfelse>NULL</cfif>,
						<cfif Len(COMP_ID)>#COMP_ID#<cfelse>NULL</cfif>,
						<cfif Len(PAR_ID)>#PAR_ID#<cfelse>NULL</cfif>,
						<cfif Len(CON_ID)>#CON_ID#<cfelse>NULL</cfif>,
						<cfif Len(GRP_ID)>#GRP_ID#<cfelse>NULL</cfif>,
						<cfif Len(STATUS)>#STATUS#<cfelse>NULL</cfif>
						)
				</cfquery>
			</cfloop>
		</cfif> --->
		
	</CFTRANSACTION>
</CFLOCK>

<script type="text/javascript">
opener.location='<cfoutput>#request.self#?fuseaction=training_management.list_class&event=upd&class_id=#MAX_ID.IDENTITYCOL#</cfoutput>';
window.close();
</script>
