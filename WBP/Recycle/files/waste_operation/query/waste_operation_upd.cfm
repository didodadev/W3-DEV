<cfset waste_operation = createObject("component","WBP/Recycle/files/waste_operation/cfc/waste_operation") />

<cfif len( attributes.car_entry_time )>
    <cf_date tarih="attributes.car_entry_time">
    <cfif len( attributes.car_entry_hour )><cfset attributes.car_entry_time = date_add("h", attributes.car_entry_hour - session.ep.time_zone, attributes.car_entry_time)></cfif>
    <cfif len( attributes.car_entry_minute )><cfset attributes.car_entry_time = date_add("n", attributes.car_entry_minute, attributes.car_entry_time)></cfif>
</cfif>

<cfif len( attributes.car_exit_time )>
    <cf_date tarih="attributes.car_exit_time">
    <cfif len( attributes.car_exit_hour )><cfset attributes.car_exit_time = date_add("h", attributes.car_exit_hour - session.ep.time_zone, attributes.car_exit_time)></cfif>
    <cfif len( attributes.car_exit_minute )><cfset attributes.car_exit_time = date_add("n", attributes.car_exit_minute, attributes.car_exit_time)></cfif>
</cfif>

<cftransaction>

    <cfset updWasteOperation = waste_operation.updWasteOperation(
        waste_operation_id: attributes.waste_operation_id,
        process_stage: attributes.process_stage,
        general_paper_no: attributes.general_paper_no,
        carNumber: attributes.carNumber,
        consumer_id: attributes.consumer_id,
        company_id: attributes.company_id,
        member_name: attributes.member_name,
        member_type: attributes.member_type,
        dorse_plaka: attributes.dorse_plaka,
        bo_number: attributes.bo_number,
        driver_partner_id: attributes.driver_id,
        driver_yrd_partner_id: attributes.yrd_driver_id,
        car_entry_time: attributes.car_entry_time,
        car_entry_kg: attributes.car_entry_kg,
        car_exit_time: attributes.car_exit_time,
        car_exit_kg: attributes.car_exit_kg,
        car_entry_hour: attributes.car_entry_hour,
        car_entry_minute: attributes.car_entry_minute,
        car_exit_hour: attributes.car_exit_hour,
        car_exit_minute: attributes.car_exit_minute,
        product_id: attributes.product_id,
        product_name: attributes.product_name,
        property_id: attributes.property_id,
        branch_id: attributes.branch_id,
        department_id: attributes.department_id,
        location_id: attributes.location_id,
        department_name: attributes.department_name,
        carrier_consumer_id: attributes.carrier_consumer_id,
        carrier_company_id: attributes.carrier_company_id,
        carrier_member_name: attributes.carrier_member_name,
        carrier_member_type: attributes.carrier_member_type,
        stock_id: attributes.stock_id,
        main_unit_id: attributes.main_unit_id
    ) />

    <cfset attributes.actionid = attributes.waste_operation_id />

    <!--- Dosya yükleme işlemleri başlar --->

    <cfset fileUploadFolder = "#upload_folder#/member/" />

    <cffunction name="uploadAssetFile">
        <cfargument name="file" required="true" />
        <cfargument name="parameter" required="true" type="struct"/>

        <cfset assetInfo = structNew() />
        <cfset assetInfo.fileName = createUUID() />
        <cfset assetInfo.fileExtension = ucase(file.serverfileext) />
        <cfset assetInfo.asset_file_name = "#assetInfo.fileName#.#assetInfo.fileExtension#" />
        <cfset assetInfo.asset_file_size = file.filesize/>
        <cfset assetInfo.asset_file_real_name = file.serverfile />

        <!--- Dosyayı yeniden adlandırır --->
        <cffile action="rename" source="#fileUploadFolder##file.serverfile#" destination="#fileUploadFolder##assetInfo.fileName#.#assetInfo.fileExtension#">

        <cfif len( parameter.old_asset_id )> <!--- Dosya varsa güncellenir --->
            
            <!--- Önceki dosya silinir --->
            <cfset getAsset = waste_operation.getAsset(parameter.old_asset_id) />
            <cfif getAsset.recordcount and fileExists("#fileUploadFolder#/#getAsset.ASSET_FILE_NAME#")>
                <cffile action = "delete" file = "#fileUploadFolder#/#getAsset.ASSET_FILE_NAME#">
            </cfif>

            <cfset asset = waste_operation.updAsset(
                asset_id: parameter.old_asset_id,
                action_id: parameter.action_id,
                asset_file_name: assetInfo.asset_file_name, 
                asset_file_size: assetInfo.asset_file_size,
                asset_name: parameter.asset_name,
                asset_file_real_name: assetInfo.asset_file_real_name,
                property_id: attributes.property_id
            ) />

        <cfelse>

            <cfset asset = waste_operation.addAsset(
                module_name: parameter.module_name,
                module_id: parameter.module_id,
                action_section: parameter.action_section,
                action_id: parameter.action_id,
                assetcat_id: parameter.assetcat_id,
                asset_file_name: assetInfo.asset_file_name, 
                asset_file_size: assetInfo.asset_file_size,
                asset_file_server_id: fusebox.server_machine,
                asset_name: parameter.asset_name,
                asset_file_server_name: listFirst(fusebox.server_machine_list),
                asset_file_real_name: assetInfo.asset_file_real_name,
                property_id: attributes.property_id
            ) />

        </cfif>

        <cfreturn asset />

    </cffunction>

    <cffunction name="delAssetFile">
        <cfargument name="refinery_waste_oil_row_id" required="false">

        <cfset oilRow = waste_operation.getWasteOperationRow( refinery_waste_oil_row_id: arguments.refinery_waste_oil_row_id ) />
        <cfif len(oilRow.ASSET_ID)>
            <cfset getAsset = waste_operation.getAsset(oilRow.ASSET_ID) />
            <cfif getAsset.recordcount and fileExists("#fileUploadFolder#/#getAsset.ASSET_FILE_NAME#")>
                <cffile action = "delete" file = "#fileUploadFolder#/#getAsset.ASSET_FILE_NAME#">
            </cfif>
            <cfset waste_operation.delAsset(oilRow.ASSET_ID) />
            <cfquery datasource="#dsn2#">UPDATE #dsn#.REFINERY_WASTE_OPERATION_ROW SET ASSET_ID = NULL WHERE REFINERY_WASTE_OIL_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.refinery_waste_oil_row_id#"></cfquery>
        </cfif>
        
    </cffunction>

    <cftry>
        <cfquery name = "get_documents" datasource="#dsn2#">
            SELECT
                *
            FROM
                #dsn_alias#.WASTE_OPERATION_DOCUMENTS WOD
            WHERE
                WOD.OUR_COMPANY_ID = #session.ep.company_id#
            ORDER BY
                WOD.CATEGORY,
                WOD.DOC_CODE
        </cfquery>

        <cfoutput query = "get_documents">
            <cfquery name = "check_asset_row" datasource="#dsn2#">
                SELECT * FROM #dsn#.REFINERY_WASTE_OPERATION_ROW WHERE REFINERY_WASTE_OIL_ID = #attributes.waste_operation_id# AND ASSET_CODE = '#evaluate("attributes.row_code_#currentrow#")#'
            </cfquery>
    
            <cfif isDefined("attributes.row_status_#currentrow#") and evaluate("attributes.row_status_#currentrow#") eq 1 and (isDefined("attributes.row_file_#currentrow#") and len(evaluate("attributes.row_file_#currentrow#")) or (isDefined("attributes.row_asset_id_#currentrow#") and len(evaluate("attributes.row_asset_id_#currentrow#"))))><!--- Dosya seçilmişse yüklenir --->
                <cfif isDefined("attributes.row_file_#currentrow#") and len(evaluate("attributes.row_file_#currentrow#"))>
                    <cfscript>
                        parameter = {
                            module_name: asset_module,
                            module_id: asset_module_id,
                            assetcat_id: assetcat_id,
                            asset_name: doc_name,
                            old_asset_id: check_asset_row.asset_id,
                            action_section: asset_action,
                            action_id: attributes.waste_operation_id
                        };
                    </cfscript>
                    <cffile action = "upload" filefield = "row_file_#currentrow#" destination = "#upload_folder#/#asset_module#/" nameconflict = "Overwrite" mode="777">
                    <cfset asset = uploadAssetFile( cffile, parameter ) />
                </cfif>
            <cfelse>
                <cfset asset = delAssetFile( check_asset_row.REFINERY_WASTE_OIL_ROW_ID ) />
            </cfif>
    
            <cfif not check_asset_row.recordCount>
                <cfquery name="insert_waste_oil_row" datasource="#dsn2#">
                    INSERT INTO #dsn#.REFINERY_WASTE_OPERATION_ROW
                    (
                        REFINERY_WASTE_OIL_ID,
                        ASSET_ID,
                        VALIDITY_START_DATE,
                        VALIDITY_FINISH_DATE,
                        FILE_STATUS,
                        RECORD_EMP,
                        RECORD_DATE,
                        RECORD_IP,
                        ASSET_CODE
                    )
                    VALUES(
                        #attributes.actionid#,
                        <cfif isDefined("attributes.row_file_#currentrow#") and len(evaluate("attributes.row_file_#currentrow#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#asset.identitycol#"><cfelseif isDefined("attributes.row_status_#currentrow#") and evaluate("attributes.row_status_#currentrow#") eq 1 and isDefined("attributes.row_asset_id_#currentrow#") and len(evaluate("attributes.row_asset_id_#currentrow#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.row_asset_id_#currentrow#")#"><cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.row_startdate_#currentrow#") and len(evaluate("attributes.row_startdate_#currentrow#"))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#evaluate("attributes.row_startdate_#currentrow#")#"><cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.row_finishdate_#currentrow#") and len(evaluate("attributes.row_finishdate_#currentrow#"))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#evaluate("attributes.row_finishdate_#currentrow#")#"><cfelse>NULL</cfif>,
                        <cfif isDefined("attributes.row_status_#currentrow#") and len(evaluate("attributes.row_status_#currentrow#"))><cfqueryparam cfsqltype="cf_sql_bit" value="#evaluate("attributes.row_status_#currentrow#")#"><cfelse>0</cfif>,
                        #session.ep.userid#,
                        #now()#,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
                        '#doc_code#'
                    )
                </cfquery>
            <cfelse>
                <cfquery datasource="#dsn2#">
                    UPDATE #dsn#.REFINERY_WASTE_OPERATION_ROW 
                    SET
                        <cfif isDefined("asset") and structKeyExists(asset,"identitycol")>
                        ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#asset.identitycol#">,
                        </cfif>
                        VALIDITY_START_DATE = <cfif isDefined("attributes.row_startdate#currentrow#") and len(evaluate("attributes.row_startdate#currentrow#"))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#evaluate("attributes.row_startdate#currentrow#")#"><cfelse>NULL</cfif>,
                        VALIDITY_FINISH_DATE = <cfif isDefined("attributes.row_finishdate#currentrow#") and len(evaluate("attributes.row_finishdate#currentrow#"))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#evaluate("attributes.row_finishdate#currentrow#")#"><cfelse>NULL</cfif>,
                        FILE_STATUS = <cfif isDefined("attributes.row_status#currentrow#") and len(evaluate("attributes.row_status#currentrow#"))><cfqueryparam cfsqltype="cf_sql_bit" value="#evaluate("attributes.row_status#currentrow#")#"><cfelse>0</cfif>,
                        UPDATE_EMP = #session.ep.userid#,
                        UPDATE_DATE = #now()#,
                        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">
                    WHERE 
                        REFINERY_WASTE_OIL_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.row_id_#currentrow#")#">
                </cfquery>
            </cfif>
        </cfoutput>
        <cfcatch>
            <cfdump var = "#cfcatch#">
            <cfabort>
        </cfcatch>
    </cftry>

    <!--- Dosya yükleme işlemleri biter --->

    <cf_workcube_process 
        is_upd='1' 
        data_source='#dsn2#'
        old_process_line='#attributes.old_process_line#'
        process_stage='#attributes.process_stage#' 
        record_member='#session.ep.userid#' 
        record_date='#now()#' 
        action_table='REFINERY_WASTE_OPERATION'
        action_column='REFINERY_WASTE_OPERATION_ID'
        action_id='#attributes.actionid#'
        action_page='#request.self#?fuseaction=recycle.waste_operation&event=upd&#attributes.actionid#' 
        warning_description='Atık Belgesi: #attributes.actionid#'>
    
</cftransaction>