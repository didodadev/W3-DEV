<cfquery name="get_lab_test" datasource="#dsn#">
    SELECT 
        LAB_REPORT_NO,
        REFINERY_LAB_TEST_ID,
        DETAIL
    FROM 
        REFINERY_LAB_TESTS
    WHERE 
        PRODUCT_SAMPLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_sample_id#">
</cfquery>
<cf_grid_list>
    <thead>
        <tr>
            <th width="25"><cf_get_lang dictionary_id='58577.Sıra'></th>
            <th><cf_get_lang dictionary_id='62139.Lab Rapor No'></th>
            <th><cf_get_lang dictionary_id='64168.Lab. Analizi'></th>
            <th><cf_get_lang dictionary_id='36199.Açıklama'></th>
        </tr>
    </thead>
    <tbody>
        <cfif get_lab_test.recordcount>
            <cfoutput query="get_lab_test">
                <tr>
                    <td>#currentrow#</td>
                    <td><a href="#request.self#?fuseaction=lab.sample_analysis&event=upd&refinery_lab_test_id=#REFINERY_LAB_TEST_ID#" target="blank_">#LAB_REPORT_NO#</a></td>
                    <cfquery name="get_control_type" datasource="#dsn#">
                        SELECT
                            QT.TYPE_ID,
                            QT.QUALITY_CONTROL_TYPE
                        FROM
                            REFINERY_LAB_TESTS_ROW REFR
                        LEFT JOIN #dsn3_alias#.QUALITY_CONTROL_TYPE QT ON QT.TYPE_ID=REFR.GROUP_ID
                        WHERE REFR.REFINERY_LAB_TEST_ID= <cfqueryparam value="#get_lab_test.REFINERY_LAB_TEST_ID#">
                        GROUP BY 
                            QT.TYPE_ID,
                            QT.QUALITY_CONTROL_TYPE
                    </cfquery>
                    <td>
                        <cfloop query="get_control_type">
                            #get_control_type.QUALITY_CONTROL_TYPE#</br>
                        </cfloop>
                    </td>
                    <td>#DETAIL#</td>
                </tr>
            </cfoutput>
        </cfif>
    </tbody>
</cf_grid_list>
<cfif get_lab_test.recordcount eq 0>
    <div class="ui-info-bottom">
        <p><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</p>
    </div>
</cfif>