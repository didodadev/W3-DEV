<cfparam name="attributes.train_group_id" default="">
<cfquery name="get_training_class_groups" datasource="#DSN#">
	SELECT 
        START_DATE, 
        FINISH_DATE
    FROM 
    	TRAINING_CLASS_GROUPS 
    WHERE 
    	TRAIN_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_group_id#">
</cfquery>
<cfif isdefined('par_ids') and len(par_ids)>
	<cfloop list="#par_ids#" index="par_id">
		<cfquery name="GET_CLASS_PAR_ATT" datasource="#DSN#">
			SELECT 
				TRAINING_CLASS_GROUPS.START_DATE,
				TRAINING_CLASS_GROUPS.FINISH_DATE,
				TRAINING_CLASS_GROUPS.TRAIN_GROUP_ID
			FROM
				TRAINING_CLASS_GROUPS,
				TRAINING_GROUP_ATTENDERS 
			WHERE 
				TRAINING_GROUP_ATTENDERS.TRAINING_GROUP_ID = TRAINING_CLASS_GROUPS.TRAIN_GROUP_ID
				AND TRAINING_GROUP_ATTENDERS.PAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#par_id#">
				AND
				(
					(
					  	TRAINING_CLASS_GROUPS.START_DATE >= #CreateODBCDateTime(get_training_class_groups.start_date)# AND
					  	TRAINING_CLASS_GROUPS.START_DATE < #CreateODBCDateTime(get_training_class_groups.finish_date)#
					)
					OR
					(
					  	TRAINING_CLASS_GROUPS.FINISH_DATE >= #CreateODBCDateTime(get_training_class_groups.start_date)# AND
					  	TRAINING_CLASS_GROUPS.FINISH_DATE < #CreateODBCDateTime(get_training_class_groups.start_date)#
					) 
				)
		</cfquery>
		<cfif get_class_par_att.recordcount>
			<cfif get_class_par_att.TRAIN_GROUP_ID neq attributes.TRAIN_GROUP_ID>
				<script type="text/javascript">
					alert("<cfoutput>#get_par_info(par_id,0,-1,0)#</cfoutput> <cf_get_lang no ='518.Bu tarihler arasında başka bir eğitimde katılımcıdır'>");
					<cfif isDefined("attributes.modal_id")>
                        loadPopupBox('form_name',<cfoutput>#attributes.modal_id#</cfoutput>);
                        /* return false; */
						closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
                    <cfelse>
                        window.history.back();
                    </cfif>
				</script>
				<cfabort>
			<cfelse>
				<script type="text/javascript">
					alert("<cfoutput>#get_par_info(par_id,0,-1,0)#</cfoutput> <cf_get_lang no ='519.Seçtiğiniz eğitime zaten katılımcıdır'>");
					<cfif isDefined("attributes.modal_id")>
                        loadPopupBox('form_name',<cfoutput>#attributes.modal_id#</cfoutput>);
                        return false;
                    <cfelse>
                        window.history.back();
                    </cfif>
				</script>
				<cfabort>
			</cfif>
		</cfif>
		<cfquery name="GET_CLASS_POTENTIAL_ATTENDER" datasource="#DSN#">
			SELECT PAR_ID FROM TRAINING_GROUP_ATTENDERS WHERE TRAINING_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.TRAIN_GROUP_ID#"> AND PAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#par_id#">
		</cfquery>
		<cfif not get_class_potential_attender.recordcount>
			<cfquery name="ADD_CLASS_POTENTIAL_ATTENDERS" datasource="#DSN#" result="add_attender">
				INSERT INTO
					TRAINING_GROUP_ATTENDERS
					(
                        TRAINING_GROUP_ID,
                        PAR_ID,
						STATUS,
                        JOIN_STATU
					)
					VALUES
					(
                        #attributes.TRAIN_GROUP_ID#,
                        #par_id#,
						1,
                        0
					)
			</cfquery>
            <cfquery name="ADD_TRAIN_GROUP_POTENTIAL_ATTENDERS" datasource="#DSN#">
                INSERT INTO
                    TRAINING_GROUP_CLASS_ATTENDANCE
                    (
                        TRAINING_GROUP_ATTENDERS_ID,
                        TRAINING_GROUP_ID,
                        PAR_ID,
                        STATUS,
                        JOINED
                    )
                VALUES
                    (
                        #add_attender.IDENTITYCOL#,
                        #attributes.TRAIN_GROUP_ID#,
                        #par_id#,
                        1,
                        0
                    )
            </cfquery>
		</cfif>
	</cfloop>
<cfelseif isdefined('con_ids') and len(con_ids)>
	<cfloop list="#con_ids#" index="con_id">
		<cfquery name="GET_CLASS_CONS_ATT" datasource="#DSN#">
			SELECT 
				TRAINING_CLASS_GROUPS.START_DATE,
				TRAINING_CLASS_GROUPS.FINISH_DATE,
				TRAINING_CLASS_GROUPS.TRAIN_GROUP_ID
			FROM
				TRAINING_CLASS_GROUPS,
				TRAINING_GROUP_ATTENDERS 
			WHERE 
				TRAINING_GROUP_ATTENDERS.TRAINING_GROUP_ID = TRAINING_CLASS_GROUPS.TRAIN_GROUP_ID 
				AND TRAINING_GROUP_ATTENDERS.CON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#con_id#">
				AND
				(
				   (
					  	TRAINING_CLASS_GROUPS.START_DATE >= #CreateODBCDateTime(get_training_class_groups.start_date)#
						AND
					  	TRAINING_CLASS_GROUPS.START_DATE < #CreateODBCDateTime(get_training_class_groups.finish_date)#
					)
					OR
					(
					  	TRAINING_CLASS_GROUPS.FINISH_DATE >= #CreateODBCDateTime(get_training_class_groups.start_date)#
						AND
					  	TRAINING_CLASS_GROUPS.FINISH_DATE < #CreateODBCDateTime(get_training_class_groups.finish_date)#
					) 
				)
		</cfquery>
		<cfif get_class_cons_att.recordcount>
			<cfif get_class_cons_att.TRAIN_GROUP_ID neq attributes.TRAIN_GROUP_ID>
				<script type="text/javascript">
					alert("<cfoutput>#get_cons_info(con_id,0,0)#</cfoutput> <cf_get_lang no ='518.Bu tarihler arasında başka bir eğitimde katılımcıdır'>");
					<cfif isDefined("attributes.modal_id")>
                        loadPopupBox('form_name',<cfoutput>#attributes.modal_id#</cfoutput>);
                       /*  return false; */
                    <cfelse>
                        window.history.back();
                    </cfif>
				</script>
				<cfabort>
			<cfelse>
				<script type="text/javascript">
					alert("<cfoutput>#get_cons_info(con_id,0,0)#</cfoutput> <cf_get_lang no ='519.Seçtiğiniz eğitime zaten katılımcıdır'>");
					<cfif isDefined("attributes.modal_id")>
                        loadPopupBox('form_name',<cfoutput>#attributes.modal_id#</cfoutput>);
                        return false;
                    <cfelse>
                        window.history.back();
                    </cfif>
				</script>
				<cfabort>
			</cfif>
		</cfif>
		<cfquery name="GET_CLASS_POTENTIAL_ATTENDER" datasource="#DSN#">
			SELECT CON_ID FROM TRAINING_GROUP_ATTENDERS WHERE TRAINING_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.TRAIN_GROUP_ID#"> AND CON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#con_id#">
		</cfquery>
		<cfif not get_class_potential_attender.recordcount>
			<cfquery name="ADD_CLASS_POTENTIAL_ATTENDERS" datasource="#DSN#" result="add_attender">
				INSERT INTO
					TRAINING_GROUP_ATTENDERS
					(
                        TRAINING_GROUP_ID,
                        CON_ID,
						STATUS,
                        JOIN_STATU
					)
					VALUES
					(
                        #attributes.TRAIN_GROUP_ID#,
                        #con_id#,
						1,
                        0
					)
			</cfquery>
            <cfquery name="ADD_TRAIN_GROUP_POTENTIAL_ATTENDERS" datasource="#DSN#">
                INSERT INTO
                    TRAINING_GROUP_CLASS_ATTENDANCE
                    (
                        TRAINING_GROUP_ATTENDERS_ID,
                        TRAINING_GROUP_ID,
                        CON_ID,
                        STATUS,
                        JOINED
                    )
                VALUES
                    (
                        #add_attender.IDENTITYCOL#,
                        #attributes.TRAIN_GROUP_ID#,
                        #con_id#,
                        1,
                        0
                    )
            </cfquery>
		</cfif>
	</cfloop>
<cfelse>
	<cfloop list="#emp_ids#" index="emp_id">
		<cfquery name="GET_CLASS_POTENTIAL_ATTENDER" datasource="#DSN#">
			SELECT EMP_ID FROM TRAINING_GROUP_ATTENDERS WHERE TRAINING_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.TRAIN_GROUP_ID#"> AND EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#emp_id#">
		</cfquery>
		<cfquery name="GET_CLASS_EMP_ATT" datasource="#DSN#">
			SELECT 
				TRAINING_CLASS_GROUPS.START_DATE,
				TRAINING_CLASS_GROUPS.FINISH_DATE,
				TRAINING_CLASS_GROUPS.TRAIN_GROUP_ID
			FROM
				TRAINING_CLASS_GROUPS,
				TRAINING_GROUP_ATTENDERS 
			WHERE 
				TRAINING_GROUP_ATTENDERS.TRAINING_GROUP_ID = TRAINING_CLASS_GROUPS.TRAIN_GROUP_ID 
				AND TRAINING_GROUP_ATTENDERS.EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#emp_id#">
				AND
				(
				    (
					  	TRAINING_CLASS_GROUPS.START_DATE >= #CreateODBCDateTime(get_training_class_groups.start_date)# AND
					  	TRAINING_CLASS_GROUPS.START_DATE < #CreateODBCDateTime(get_training_class_groups.finish_date)#
					)
					OR
					(
					  	TRAINING_CLASS_GROUPS.FINISH_DATE >= #CreateODBCDateTime(get_training_class_groups.start_date)# AND
					  	TRAINING_CLASS_GROUPS.FINISH_DATE < #CreateODBCDateTime(get_training_class_groups.finish_date)#
					) 
				)
		</cfquery>
		<cfif get_class_emp_att.recordcount>
			<cfif get_class_emp_att.TRAIN_GROUP_ID neq attributes.TRAIN_GROUP_ID>
				<script type="text/javascript">
					alert("<cfoutput>#get_emp_info(emp_id,0,0)#</cfoutput> <cf_get_lang no ='518.Bu tarihler arasında başka bir eğitimde katılımcıdır'>");
					<cfif isDefined("attributes.modal_id")>
                        loadPopupBox('form_name',<cfoutput>#attributes.modal_id#</cfoutput>);
                        /* return false; */
						closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
                    <cfelse>
                        window.history.back();
                    </cfif>
				</script>
				<cfabort>
			<cfelseif not isdefined("control_emp_id_#emp_id#")>
				<script type="text/javascript">
					alert("<cfoutput>#get_emp_info(emp_id,0,0)#</cfoutput> <cf_get_lang no ='519.Seçtiğiniz eğitime zaten katılımcıdır'>");
					<cfif isDefined("attributes.modal_id")>
                        loadPopupBox('form_name',<cfoutput>#attributes.modal_id#</cfoutput>);
                        return false;
                    <cfelse>
                        window.history.back();
                    </cfif>
				</script>
				<cfabort>
			</cfif>
		</cfif>
		<cfif not get_class_potential_attender.recordcount>
			<cfset "control_emp_id_#emp_id#" = 1>
			<cfquery name="ADD_CLASS_POTENTIAL_ATTENDERS" datasource="#DSN#" result="add_attender">
				INSERT INTO
					TRAINING_GROUP_ATTENDERS
					(
						TRAINING_GROUP_ID,
						EMP_ID,
						STATUS,
                        JOIN_STATU
					)
				VALUES
					(
						#attributes.TRAIN_GROUP_ID#,
						#emp_id#,
						1,
                        0
					)
			</cfquery>
            <cfquery name="ADD_TRAIN_GROUP_POTENTIAL_ATTENDERS" datasource="#DSN#">
                INSERT INTO
                    TRAINING_GROUP_CLASS_ATTENDANCE
                    (
                        TRAINING_GROUP_ATTENDERS_ID,
                        TRAINING_GROUP_ID,
                        EMP_ID,
                        STATUS,
                        JOINED
                    )
                VALUES
                    (
                        #add_attender.IDENTITYCOL#,
                        #attributes.TRAIN_GROUP_ID#,
                        #emp_id#,
                        1,
                        0
                    )
            </cfquery>
		</cfif>
	</cfloop>
</cfif>
 <script type="text/javascript">
    <cfif not isdefined("attributes.draggable")>
        window.opener.$( '#attenders .catalyst-refresh' ).click();
    <cfelseif isdefined("attributes.draggable")>
        $( '#attenders .catalyst-refresh' ).click();
        closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
    </cfif>
</script> 