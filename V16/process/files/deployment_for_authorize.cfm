<!--- Deployment statusu için yetki kontrolü yapar  --->
<cfset dsn = application.systemParam.systemParam().dsn>
<script type="text/javascript">
    process_cat_dsp_function = function() {
        <cfscript>
            
            proc_query = queryExecute( 
                "
                SELECT COUNT(*) AS CNT FROM (
                SELECT TOP 1 1 AS C 
                FROM PROCESS_TYPE PRC 
                INNER JOIN PROCESS_TYPE_OUR_COMPANY CMP ON PRC.PROCESS_ID = CMP.PROCESS_ID
                INNER JOIN PROCESS_TYPE_ROWS PRWS ON PRC.PROCESS_ID = PRWS.PROCESS_ID
                INNER JOIN PROCESS_TYPE_ROWS_CAUID CPOS ON PRWS.PROCESS_ROW_ID = CPOS.PROCESS_ROW_ID
                INNER JOIN EMPLOYEE_POSITIONS EP ON CPOS.CAU_POSITION_ID = EP.POSITION_ID
                WHERE CMP.OUR_COMPANY_ID = :OUR_COMPANY AND PRC.FACTION LIKE :FACTION AND EP.POSITION_CODE = :POSITION_ID
                ) T
                "
                , { OUR_COMPANY: { value: session.ep.company_id, cfsqltype: "CF_SQL_INTEGER" }, FACTION: "%dev.workdev%", POSITION_ID : { value: session.ep.position_code, cfsqltype: "CF_SQL_INTEGER" } }
                , { datasource: dsn }
            );

            writeOutput( "var auth = " & proc_query['CNT'][1] & ";" );
        </cfscript>
        if ( auth == 0 && document.getElementById("status").value == "Deployment" ) {
            alert('Deploy islemine yetkiniz yok!');
            return false;
        }

        return true;
    }
</script>