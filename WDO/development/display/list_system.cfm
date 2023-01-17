<cfquery name="query_version" datasource="#dsn#">
    SELECT TOP 1 * FROM WRK_LICENSE ORDER BY RELEASE_DATE DESC
</cfquery>
<cfquery name="query_ourcompany_count" datasource="#dsn#">
    SELECT * FROM OUR_COMPANY
</cfquery>
<cfquery name="query_period_count" datasource="#dsn#">
    SELECT * FROM SETUP_PERIOD
</cfquery>
<cfquery name="query_dbschemas_company_count" datasource="#dsn#">
    select s.name as schema_name, 
    s.schema_id,
    u.name as schema_owner
    from sys.schemas s
        inner join sys.sysusers u
            on u.uid = s.principal_id
    where s.name like '#dsn#_[0-9]%' and s.name not like '%[0-9]_[0-9]%'
    order by s.name
</cfquery>
<cfquery name="query_dbschemas_period_count" datasource="#dsn#">
    select s.name as schema_name, 
    s.schema_id,
    u.name as schema_owner
    from sys.schemas s
        inner join sys.sysusers u
            on u.uid = s.principal_id
    where s.name like '#dsn#_[0-9]%_[0-9]%'
    order by s.name
</cfquery>
<cfdirectory directory="#getDirectoryFromPath(getCurrentTemplatePath())#..\..\..\documents\" action="list" name="documentsfiles" recurse="true">
<cfquery name="query_document_size" dbtype="query">
    SELECT SUM(size) as totalsize FROM documentsfiles
</cfquery>

<cfquery name="query_employees_count" datasource="#dsn#">
    SELECT COUNT(*) AS CNT FROM EMPLOYEES WHERE EMPLOYEE_PASSWORD IS NOT NULL AND EMPLOYEE_PASSWORD <> ''
</cfquery>

<cfquery name="query_addoptions_count" datasource="#dsn#">
    SELECT * FROM WRK_OBJECTS
    WHERE FILE_PATH LIKE '%add_options%' or ADDOPTIONS_CONTROLLER_FILE_PATH IS NOT NULL OR ADDOPTIONS_CONTROLLER_FILE_PATH <> ''
</cfquery>

<cfquery name="query_report_count" datasource="#dsn#">
    SELECT COUNT(*) AS CNT FROM REPORTS
</cfquery>

<cfquery name="query_process_file_count" datasource="#dsn#">
    SELECT COUNT(*) AS CNT FROM (
    SELECT COUNT(*) AS CNT
    FROM PROCESS_TYPE_ROWS
    WHERE FILE_NAME IS NOT NULL OR FILE_NAME <> '' OR DISPLAY_FILE_NAME IS NOT NULL OR DISPLAY_FILE_NAME <> ''
    GROUP BY PROCESS_ID
    ) T
</cfquery>
<cfquery name="query_process_cat_table_in_db" datasource="#dsn#">
    SELECT TABLE_SCHEMA
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_SCHEMA IN ('#valueList(query_dbschemas_company_count.schema_name, "','")#')
    AND TABLE_NAME = 'SETUP_PROCESS_CAT'
</cfquery>
<cfset qpcindex = 1>
<cfquery name="query_process_cat_file_count" datasource="#dsn#">
    SELECT COUNT(*) AS CNT FROM (
    <cfloop query="query_process_cat_table_in_db">
    SELECT PROCESS_CAT_ID
      FROM #query_process_cat_table_in_db.TABLE_SCHEMA#.SETUP_PROCESS_CAT
    WHERE DISPLAY_FILE_NAME IS NOT NULL OR DISPLAY_FILE_NAME <> '' OR ACTION_FILE_NAME IS NOT NULL OR ACTION_FILE_NAME <> ''
    <cfif qpcindex lt query_process_cat_table_in_db.recordCount>
    UNION ALL
    </cfif>
    <cfset qpcindex = qpcindex + 1>
    </cfloop>
    ) T
</cfquery>
<cfquery name="query_db_sizes" datasource="#dsn#">
    Select (size * 8 /1024.0) AS MB, name from dbo.sysfiles
</cfquery>
<cfquery name="query_get_wex" datasource="#dsn#">
    SELECT WEX_ID FROM WRK_WEX
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="SYSTEM">
        <div class="ui-info-text">
            <div class="col col-6 col-md-6 col-sm-8 col-xs-12">
                <cf_flat_list>
                    <cfoutput>
                        <tr>
                            <td><b>Release Version</b></td>
                            <td>#query_version.RELEASE_NO#</td>
                        </tr>
                        <tr>
                            <td><b>Upgrade Date</b></td>
                            <td>#dateformat(query_version.RELEASE_DATE, dateformat_style)#</td>
                        </tr>
                        <tr>
                            <td><b>Patch Version</b></td>
                            <td>#query_version.PATCH_NO#</td>
                        </tr>
                        <tr>
                            <td><b>Patch Date</b></td>
                            <td>#dateformat(query_version.PATCH_DATE, dateformat_style)#</td>
                        </tr>
                        <tr>
                            <td><b>Total Company (From App registered)</b></td>
                            <td><strong>#query_ourcompany_count.recordCount#</strong> (#valueList(query_ourcompany_count.NICK_NAME, ", ")#)</td>
                        </tr>
                        <tr>
                            <td><b>Total Company (From DB Schemas)</b></td>
                            <td><strong>#query_dbschemas_company_count.recordCount#</strong> (#valueList(query_dbschemas_company_count.schema_name, ", ")#)</td>
                        </tr>
                        <tr>
                            <td><b>Total Period (From App Registered)</b></td>
                            <td><strong>#query_period_count.recordCount#</strong> (Years: #listRemoveDuplicates(valueList(query_period_count.PERIOD_YEAR, ", "))#)</td>
                        </tr>
                        <tr>
                            <td><b>Total Period (From DB Schemas)</b></td>
                            <td><strong>#query_dbschemas_period_count.recordCount#</strong> (#valueList(query_dbschemas_period_count.schema_name, ", ")#)</td>
                        </tr>
                        <tr>
                            <td><b>Digital Archive Size</b></td> 
                            <td>#numberFormat((len(query_document_size.totalsize) ? query_document_size.totalsize : 0)/1000000000, ",.99")# GB</td>
                        </tr>
                        <tr>
                            <td><b>Users Count</b></td>
                            <td>#query_employees_count.CNT#</td>
                        </tr>
                        <tr>
                            <td><b>Add-Options Count</b></td>
                            <td>#query_addoptions_count.recordCount#</td>
                        </tr>
                        <tr>
                            <td><b>Special Reports Count</b></td>
                            <td>#query_report_count.CNT#</td>
                        </tr>
                        <tr>
                            <td><b>Customize Proces Count</b></td>
                            <td>#query_process_file_count.CNT#</td>
                        </tr>
                        <tr>
                            <td><b>Customize Proces Cat Count</b></td>
                            <td>#query_process_cat_file_count.CNT#</td>
                        </tr> 
                        <tr>
                            <td><b>Wex Count</b></td>
                            <td>#query_get_wex.recordCount#</td>
                        </tr>
                    </cfoutput>
                    <cfoutput query="query_db_sizes">
                        <cfif currentrow eq 1>
                                <tr>
                                    <td><b>DB File Name</b></td>
                                    <td>#name#</td>
                                </tr>
                                <tr>
                                    <td><b>DB File Size</b></td>
                                    <td>#numberFormat(mb, ",.99")# MB</td>
                            </tr>
                        <cfelse>
                                <tr>
                                    <td><b>DB Log Name</b></td>
                                    <td>#name#</td>
                                </tr>
                                <tr>
                                    <td><b>DB Log Size</b></td>
                                    <td>#numberFormat(mb, ",.99")# MB</td>
                                </tr>
                        </cfif>
                    </cfoutput>
                </cf_flat_list>
            </div>
        </div>
    </cf_box>
</div>
