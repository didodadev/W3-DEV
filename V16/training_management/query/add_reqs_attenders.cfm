<cfset url_str = "">
<cfif isdefined('attributes.is_submitted')>
	<cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
</cfif>
<cfif isdefined('attributes.request_type')>
	<cfset url_str = "#url_str#&request_type=#attributes.request_type#">
</cfif>
<cfif isdefined('attributes.employee_id')>
	<cfset url_str = "#url_str#&employee_id=#attributes.employee_id#">
</cfif>
<cfif isdefined('attributes.req_year')>
	<cfset url_str = "#url_str#&req_year=#attributes.req_year#">
</cfif>
<cfif isdefined('attributes.process_stage_type')>
	<cfset url_str = "#url_str#&process_stage_type=#attributes.process_stage_type#">
</cfif>	
<cfif isdefined('attributes.class_id')>
	<cfset url_str = "#url_str#&class_id=#attributes.class_id#">
</cfif>	
<cfif isdefined('attributes.startdate')>
	<cfset url_str = "#url_str#&startdate=#attributes.startdate#">
</cfif>	
<cfif isdefined('attributes.finishdate')>
	<cfset url_str = "#url_str#&finishdate=#attributes.finishdate#">
</cfif>	
<cfif isdefined('attributes.comp_id')>
	<cfset url_str = "#url_str#&comp_id=#attributes.comp_id#">
</cfif>	
<cfif isdefined('attributes.branch_id')>
	<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
</cfif>	
<cfif isdefined("attributes.department")>
	<cfset url_str = "#url_str#&department=#attributes.department#">
</cfif>
<cfif isdefined("attributes.pos_cat")>
	<cfset url_str = "#url_str#&pos_cat=#attributes.pos_cat#">
</cfif>
<cfif isdefined("attributes.title_id")>
	<cfset url_str = "#url_str#&title_id=#attributes.title_id#">
</cfif>
<cfif isdefined("attributes.func_id")>
	<cfset url_str = "#url_str#&func_id=#attributes.func_id#">
</cfif>

<cfloop from="1" to="#listlen(attributes.id_list)#" index="i">
    <cfset emp_id = listfirst(listgetat(attributes.id_list,i,','),';')>
    <cfset class_id = listgetat(listgetat(attributes.id_list,i,','),2,';')>
    <cfset statu = listlast(listgetat(attributes.id_list,i,','),';')>
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
            CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#">
    </cfquery>
    <cfquery name="GET_CLASS_POTENTIAL_ATTENDER" datasource="#DSN#">
        SELECT 
            EMP_ID 
        FROM 
            TRAINING_CLASS_ATTENDER 
        WHERE 
            CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#"> AND 
            EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#emp_id#">
    </cfquery>
    <cfif statu eq 'ac'>
        <cfquery name="GET_CLASS_EMP_ATT" datasource="#DSN#">
            SELECT 
                TRAINING_CLASS.START_DATE ,
                TRAINING_CLASS.FINISH_DATE,
                TRAINING_CLASS.CLASS_ID
            FROM
                TRAINING_CLASS,
                TRAINING_CLASS_ATTENDER 
            WHERE 
                TRAINING_CLASS_ATTENDER.CLASS_ID=TRAINING_CLASS.CLASS_ID 
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
            <cfif get_class_emp_att.class_id neq class_id>
                <script type="text/javascript">
                    alert("<cfoutput>#get_emp_info(emp_id,0,0)#</cfoutput> <cf_get_lang no ='518.Bu tarihler arasinda baska bir egitimde katilimcidir'>");
                </script>
                <cfabort>
            <cfelseif not isdefined("control_emp_id_#emp_id#")>
                <script type="text/javascript">
                    alert("<cfoutput>#get_emp_info(emp_id,0,0)#</cfoutput> <cf_get_lang no ='519.Se�tiginiz egitime zaten katilimcidir'>");
                    window.location = "<cfoutput>#request.self#?fuseaction=#attributes.fsactn##url_str#</cfoutput>";
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
                        #class_id#,
                        #emp_id#,
                        0
                    )
            </cfquery>
            <cfquery name="UPD_TRR_HR" datasource="#DSN#">
                UPDATE
                    TRAINING_REQUEST_ROWS
                SET
                    HR_VALID = 1,
                    HR_VALID_DATE = #Now()#,
                    HR_VALID_EMP = #session.ep.userid#
                WHERE
                    EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#emp_id#">
                    AND CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#">
            </cfquery>
        </cfif>
    <cfelseif statu eq 'de'>
        <cfquery name="UPD_TRR_HR_DE" datasource="#DSN#">
            UPDATE
                TRAINING_REQUEST_ROWS
            SET
                HR_VALID = 0,
                HR_VALID_DATE = #Now()#,
                HR_VALID_EMP = #session.ep.userid#
            WHERE
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#emp_id#">
                AND CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#">
        </cfquery>
    </cfif>
</cfloop>
    
<cflocation url="#request.self#?fuseaction=#attributes.fsactn##url_str#" addtoken="No">

