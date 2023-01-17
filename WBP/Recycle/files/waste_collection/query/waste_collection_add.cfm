<cfset waste_collection = createObject("component","WBP/Recycle/files/waste_collection/cfc/waste_collection") />

<cfif len( attributes.expedition_entry_time )>
    <cf_date tarih="attributes.expedition_entry_time">
    <cfif len( attributes.expedition_entry_hour )><cfset attributes.expedition_entry_time = date_add("h", attributes.expedition_entry_hour - session.ep.time_zone, attributes.expedition_entry_time)></cfif>
    <cfif len( attributes.expedition_entry_minute )><cfset attributes.expedition_entry_time = date_add("n", attributes.expedition_entry_minute, attributes.expedition_entry_time)></cfif>
</cfif>

<cfif len( attributes.expedition_exit_time )>
    <cf_date tarih="attributes.expedition_exit_time">
    <cfif len( attributes.expedition_exit_hour )><cfset attributes.expedition_exit_time = date_add("h", attributes.expedition_exit_hour - session.ep.time_zone, attributes.expedition_exit_time)></cfif>
    <cfif len( attributes.expedition_exit_minute )><cfset attributes.expedition_exit_time = date_add("n", attributes.expedition_exit_minute, attributes.expedition_exit_time)></cfif>
</cfif>

<cfset expedition_entry_time = CreateDateTime(year(attributes.expedition_entry_time), month(attributes.expedition_entry_time), day(attributes.expedition_entry_time), attributes.expedition_entry_hour,attributes.expedition_entry_minute,0) >
<cfset expedition_exit_time = CreateDateTime(year(attributes.expedition_exit_time), month(attributes.expedition_exit_time), day(attributes.expedition_exit_time), attributes.expedition_exit_hour,attributes.expedition_exit_minute,0) >
<cftransaction>

    <cfset saveWasteCollection = waste_collection.saveWasteCollection(
        process_stage: attributes.process_stage,
        ats_no: attributes.ats_no,
        driver_id: attributes.driver_id,
        driver_name : attributes.driver_name,
        driver_yrd_id : attributes.driver_yrd_id,
        driver_yrd_name : attributes.driver_yrd_name,
        assetp_id : attributes.assetp_id,
        assetp_name : attributes.assetp_name,
        assetp_dorse_id : attributes.assetp_dorse_id,
        assetp_dorse_name : attributes.assetp_dorse_name,
        expedition_entry_time: expedition_entry_time,
        expedition_exit_time : expedition_exit_time
    ) />

    <cfset attributes.actionid = saveWasteCollection.identitycol />
    

    <cfif isDefined("attributes.rowCountSave") and attributes.rowCountSave gt 0>
        <cfloop index="i" from="1" to="#attributes.rowCountSave#">
            <cfif evaluate('attributes.rowDeleted#i#') eq 0>
                <cfquery name="add_row" datasource="#dsn#">
                    INSERT INTO REFINERY_WASTE_COLLECTION_ROWS(
                        WASTE_COLLECTION_EXPEDITIONS_ID,
                        SERVICE_ID,
                        RECORD_DATE,
                        RECORD_MEMBER,
                        RECORD_IP
                    )
                    VALUES(
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.actionid#">,
                        <cfif len(evaluate('attributes.service_id#i#')) and len(evaluate('attributes.service_no#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.service_id#i#')#"><cfelse>NULL</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">
                    )
                </cfquery>
            </cfif>
        </cfloop>
    </cfif>

    <cfquery name="UPDATE_GENERAL_PAPERS" datasource="#dsn#">
        UPDATE #dsn3#.GENERAL_PAPERS 
        SET WASTE_COLLECTION_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#listLast(attributes.ats_no,"-")#">
        WHERE PAPER_TYPE IS NULL
    </cfquery>

    <cf_workcube_process 
        is_upd='1' 
        data_source='#dsn#' 
        old_process_line='0'
        process_stage='#attributes.process_stage#' 
        record_member='#session.ep.userid#' 
        record_date='#now()#' 
        action_table='REFINERY_WASTE_COLLECTION'
        action_column='WASTE_COLLECTION_EXPEDITIONS_ID'
        action_id='#attributes.actionid#'
        action_page='#request.self#?fuseaction=waste_collection_id&event=upd&#attributes.actionid#' 
        warning_description='Atık Toplama Seferleri: #attributes.actionid#'>

</cftransaction>