<cfset get_lab_test_row = createObject("component","WBP/Recycle/files/sample_analysis/cfc/sample_analysis").getLabTestRow(
		refinery_lab_test_id: attributes.action_id
    ) />
    
<cfquery name="get_process" datasource="#dsn#">
    SELECT PTR.STAGE as STAGE_NAME FROM PROCESS_TYPE_ROWS AS PTR WHERE PTR.PROCESS_ROW_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_lab_test_row.PROCESS_STAGE#">
</cfquery>
<cfif len(get_lab_test_row.NUMUNE_POINT)>
    <cfquery name="get_sampling_place" datasource="#dsn#">
        SELECT SP.SAMPLING_POINTS_NAME as S_NAME FROM SAMPLING_POINTS AS SP WHERE SP.SAMPLING_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_lab_test_row.NUMUNE_POINT#">
    </cfquery>
</cfif>
<cfquery name="get_q_sub_types" datasource="#dsn#">
    SELECT 
        RT.IS_ACCEPT,
        RT.UNIT_ID,
        RT.AMOUNT,
        RT.REFINERY_LAB_TEST_ROW_ID,
        RT.IS_ACCEPT_TEST,
        RT.GROUP_ID,
        RT.OPTIONS,
        RT.DESCRIPTION,
        RT.RESULT,
        RT.MIN_LIMIT,
        RT.STANDART_VALUE,
        RT.REFINERY_LAB_TEST_ID,
        RT.PARAMETER_ID,
        RT.SAMPLE_METHOD,
        RT.SAMPLE_NUMBER,
        RT.MAX_LIMIT,
        QR.QUALITY_CONTROL_ROW,
        QT.QUALITY_CONTROL_TYPE,
        QT.TYPE_ID
    FROM
        REFINERY_LAB_TESTS_ROW RT
    INNER JOIN #dsn3_alias#.QUALITY_CONTROL_ROW AS QR ON QR.QUALITY_CONTROL_ROW_ID= RT.PARAMETER_ID
    LEFT JOIN #dsn3_alias#.QUALITY_CONTROL_TYPE QT ON QT.TYPE_ID= RT.GROUP_ID
    WHERE 
        RT.REFINERY_LAB_TEST_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
    GROUP BY
        RT.REFINERY_LAB_TEST_ID,
        RT.REFINERY_LAB_TEST_ROW_ID,
        QR.QUALITY_CONTROL_ROW,
        RT.IS_ACCEPT,
        RT.UNIT_ID,
        RT.AMOUNT,
        RT.IS_ACCEPT_TEST,
        RT.GROUP_ID,
        RT.OPTIONS,
        RT.DESCRIPTION,
        RT.RESULT,
        RT.MIN_LIMIT,
        RT.STANDART_VALUE,
        RT.PARAMETER_ID,
        RT.SAMPLE_METHOD,
        RT.SAMPLE_NUMBER,
        RT.MAX_LIMIT,
        QT.QUALITY_CONTROL_TYPE,
        QT.TYPE_ID
</cfquery>
<cfif get_q_sub_types.sample_method eq 1>
    <cfset samp_method= 'R'>
<cfelseif get_q_sub_types.sample_method eq 2>
    <cfset samp_method='%'>
<cfelseif get_q_sub_types.sample_method eq 3>
    <cfset samp_method='K'>
<cfelse>
    <cfset samp_method=''>
</cfif>

<cfif not get_lab_test_row.recordcount>
    <cfset hata  = 10>
    <cfsavecontent variable="message"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'>!</cfsavecontent>
    <cfset hata_mesaj  = message>
    <cfinclude template="../../dsp_hata.cfm">
<cfelse>
    <cf_woc_header>
    <cfoutput>
        <cf_woc_elements>
            <cf_wuxi id="process" data="#get_process.STAGE_NAME#" label="58859" type="cell"> <!--- süreç --->
            <cf_wuxi id="lab_report_no" data="#get_lab_test_row.LAB_REPORT_NO#" label="62139" type="cell"> <!--- lab rapor no --->
            <cf_wuxi id="location" data="#get_location_info(get_lab_test_row.DEPARTMENT_ID,get_lab_test_row.LOCATION_ID,1)#" label="58763" type="cell"> <!--- depo --->
            <cf_wuxi id="comp_name" data="#get_cons_info(get_lab_test_row.CONSUMER_ID,0,0)#" label="34578" type="cell"> <!--- firma adı --->
            <cf_wuxi id="sample_emp_name" data="#get_emp_info(get_lab_test_row.SAMPLE_EMPLOYEE_ID,0,0)#" label="62135" type="cell"> <!--- numune alan kişi --->
            <cf_wuxi id="sample_date" data="#dateformat(get_lab_test_row.NUMUNE_DATE,dateformat_style)# #TimeFormat(get_lab_test_row.NUMUNE_DATE,timeformat_style)#" label="62138" type="cell"> <!--- numune alım tarih --->
            <cf_wuxi id="sample_accept_date" data="#dateformat(get_lab_test_row.NUMUNE_ACCEPT_DATE,dateformat_style)# #TimeFormat(get_lab_test_row.NUMUNE_ACCEPT_DATE,timeformat_style)#" label="62123" type="cell"> <!--- numune kabul --->
            <cfif len(get_lab_test_row.NUMUNE_POINT)><cf_wuxi id="sampling_place" data="#get_sampling_place.S_NAME#" label="62132" type="cell"></cfif> <!--- numune alım noktası --->
            <cf_wuxi id="req_emp_name" data="#get_emp_info(get_lab_test_row.REQUESTING_EMPLOYE_ID,0,0)#" label="62137" type="cell"><!--- Analiz talep eden --->
            <cf_wuxi id="analysis_start_date" data="#dateformat(get_lab_test_row.ANALYSE_DATE,dateformat_style)# #TimeFormat(get_lab_test_row.ANALYSE_DATE,timeformat_style)#" label="62138" type="cell"> <!--- analiz başlama tarih --->
            <cf_wuxi id="analysis_finish_date" data="#dateformat(get_lab_test_row.ANALYSE_DATE_EXIT,dateformat_style)# #TimeFormat(get_lab_test_row.ANALYSE_DATE_EXIT,timeformat_style)#" label="62123" type="cell"> <!--- analiz bitiş tarih --->
        </cf_woc_elements> 
        <cf_woc_elements>
            <cf_woc_list id="aaa">
                <thead>
                    <tr>
                        <cf_wuxi label="58826" type="cell" is_row="0" id="wuxi_58826"> <!--- test --->
                        <cf_wuxi label="64052" type="cell" is_row="0" id="wuxi_64052"> <!--- parametre --->
                        <cf_wuxi label="63477" type="cell" is_row="0" id="wuxi_63477"> <!--- örneklem --->
                        <cf_wuxi label="57635" type="cell" is_row="0" id="wuxi_57635"> <!--- miktar --->
                        <cf_wuxi label="57636" type="cell" is_row="0" id="wuxi_57636"> <!--- birim --->
                        <cf_wuxi label="52248" type="cell" is_row="0" id="wuxi_52248"> <!--- alt limit --->
                        <cf_wuxi label="52249" type="cell" is_row="0" id="wuxi_52249"> <!--- üst limit --->
                        <cf_wuxi label="33137+33616" type="cell" is_row="0" id="wuxi_33137"> <!--- std değer --->
                        <td><=></td>
                        <cf_wuxi label="59085" type="cell" is_row="0" id="wuxi_59085"> <!--- sonuç --->
                        <cf_wuxi label="57629" type="cell" is_row="0" id="wuxi_59085"> <!--- açıklama --->
                    </tr>
                </thead>
                <tbody>
                    <cfloop query="get_q_sub_types">
                        <tr>
                            <cf_wuxi data="#get_q_sub_types.QUALITY_CONTROL_TYPE#" type="cell" is_row="0"> 
                            <cf_wuxi data="#get_q_sub_types.QUALITY_CONTROL_ROW#" type="cell" is_row="0"> 
                            <cfif len(get_q_sub_types.SAMPLE_NUMBER)><cf_wuxi data="#TLFormat(get_q_sub_types.SAMPLE_NUMBER)# #samp_method#" type="cell" is_row="0"><cfelse><td></td></cfif>
                            <cfif len(get_q_sub_types.AMOUNT)><cf_wuxi data="#TLFormat(get_q_sub_types.AMOUNT)#" type="cell" is_row="0"><cfelse><td></td></cfif>
                            <td><cfif UNIT_ID eq 1>mg<cfelseif UNIT_ID eq 2>gr <cfelseif UNIT_ID eq 3>kg <cfelseif UNIT_ID eq 4>mm³ <cfelseif UNIT_ID eq 5>cm³ <cfelseif UNIT_ID eq 6>m³ <cfelseif UNIT_ID eq 7>ml <cfelseif UNIT_ID eq 8>cl <cfelseif UNIT_ID eq 9>lt </cfif></td>
                            <cfif len(get_q_sub_types.MIN_LIMIT)><cf_wuxi data="#TLFormat(get_q_sub_types.MIN_LIMIT)#" type="cell"  is_row="0"><cfelse><td></td></cfif>
                            <cfif len(get_q_sub_types.MAX_LIMIT)><cf_wuxi data="#TLFormat(get_q_sub_types.MAX_LIMIT)#" type="cell"  is_row="0"><cfelse><td></td></cfif>
                            <cfif len(get_q_sub_types.STANDART_VALUE)><cf_wuxi data="#TLFormat(get_q_sub_types.STANDART_VALUE)#" type="cell"  is_row="0"><cfelse><td></td></cfif>             
                            <td> 
                                <cfif get_q_sub_types.OPTIONS eq 1>>=
                                <cfelseif get_q_sub_types.OPTIONS eq 2>>>
                                <cfelseif get_q_sub_types.OPTIONS eq 3>><
                                <cfelseif get_q_sub_types.OPTIONS eq 4>>=>
                                <cfelseif get_q_sub_types.OPTIONS eq 5>>=<
                                <cfelse>
                                    &nbsp
                                </cfif>
                            </td>
                            <cfif len(get_q_sub_types.RESULT)><cf_wuxi data="#TLFormat(get_q_sub_types.RESULT)#" type="cell" is_row="0"><cfelse><td></td></cfif>         
                            <cfif len(get_q_sub_types.DESCRIPTION)><cf_wuxi data="#get_q_sub_types.DESCRIPTION#" type="cell" is_row="0"><cfelse><td></td></cfif>              
                        </tr>
                    </cfloop>
                </tbody>
            </cf_woc_list> 
        </cf_woc_elements>
        <cf_woc_footer>
    </cfoutput>
</cfif>