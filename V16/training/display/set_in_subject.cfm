<cfquery name="SET_TRAINING_IN_SUBJECT" datasource="#DSN#">
    INSERT INTO 
        TRAINING_IN_SUBJECT
    (
        EMPLOYEE_ID,
        TRAIN_ID,
        ACCESS_DATE,
        IS_IN,
        IS_READED,
        READING_DATE
    )
    VALUES
    (
        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#">,
        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
        1,
        1,
        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
    )
</cfquery>
<div id="set_in_subject_div">
    <input name="is_readed" id="is_readed" type="checkbox" disabled="disabled" checked>
    <font color="red">Konuyu Okudunuz.</font>
</div>
