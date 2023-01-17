<cfset relative_name_list = "#getLang(dictionary_id:31962)#,#getLang(dictionary_id:31963)#,
                            #getLang(dictionary_id:31329)#,#getLang(dictionary_id:31330)#,
                            #getLang(dictionary_id:31331)#,#getLang(dictionary_id:31449)#">

<!--- <cfquery name="get_data" datasource="#dsn2#">
    SELECT
        XT.*,
        E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS EMP_FULLNAME,
        E.EMPLOYEE_NO,
        ER.RELATIVE_LEVEL,
        ER.NAME + ' ' + ER.SURNAME AS REL_FULLNAME,
        SHAT.ASSURANCE,
        ISNULL(SHATS.MIN,0) AS MIN,
        ISNULL(SHATS.MAX,9999999) AS MAX,
        SHATS.RATE,
        D.DEPARTMENT_HEAD,
        B.BRANCH_NAME
    FROM
        (
            SELECT 
                EMP_ID,
                ASSURANCE_ID,
                TREATED,
                RELATIVE_ID,
                SUM(NET_TOTAL_AMOUNT) AS NET_TOTAL_AMOUNT
            FROM
                EXPENSE_ITEM_PLAN_REQUESTS
            WHERE
                TREATED IS NOT NULL AND
                IS_APPROVE = 1
                <cfif len(attributes.employee_id)>
                    AND EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
                </cfif>
                <cfif len(attributes.assurance_id)>
                    AND ASSURANCE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assurance_id#" list="true">)
                </cfif>
            GROUP BY
                EMP_ID,
                TREATED,
                RELATIVE_ID,
                ASSURANCE_ID
        ) XT
        LEFT JOIN #dsn#.EMPLOYEES E ON E.EMPLOYEE_ID = XT.EMP_ID
        LEFT JOIN #dsn#.EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID
        LEFT JOIN #dsn#.DEPARTMENT D ON D.DEPARTMENT_ID = EP.DEPARTMENT_ID
        LEFT JOIN #dsn#.BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
        LEFT JOIN #dsn#.EMPLOYEES_RELATIVES ER ON ER.RELATIVE_ID = XT.RELATIVE_ID
        LEFT JOIN #dsn#.SETUP_HEALTH_ASSURANCE_TYPE SHAT ON SHAT.ASSURANCE_ID = XT.ASSURANCE_ID
        LEFT JOIN #dsn#.SETUP_HEALTH_ASSURANCE_TYPE_SUPPORT SHATS ON SHATS.ASSURANCE_ID = SHAT.ASSURANCE_ID
    WHERE
        SHAT.IS_ACTIVE = 1 AND
        SHATS.IS_ACTIVE = 1 AND
        XT.NET_TOTAL_AMOUNT > ISNULL(SHATS.MIN,0)
        <cfif len(attributes.relative_level)>
            <cfif attributes.relative_level eq -1>
                AND XT.TREATED = 1
                AND XT.RELATIVE_ID IS NULL
                AND ER.RELATIVE_LEVEL IS NULL
            <cfelse>
                AND XT.TREATED = 2
                AND XT.RELATIVE_ID IS NOT NULL
                AND ER.RELATIVE_LEVEL = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.relative_level#">
            </cfif>
        </cfif>
    ORDER BY
        XT.EMP_ID,
        XT.TREATED,
        XT.RELATIVE_ID,
        XT.ASSURANCE_ID,
        ISNULL(SHATS.MIN,0)
</cfquery> --->

<cfquery name="get_data2" datasource="#dsn2#">
    SELECT 
        EIPR.*,
        E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS EMP_FULLNAME,
        E.EMPLOYEE_NO,
        ER.RELATIVE_LEVEL,
        ER.NAME + ' ' + ER.SURNAME AS REL_FULLNAME,
        SHAT.ASSURANCE
    FROM
        EXPENSE_ITEM_PLAN_REQUESTS EIPR
        LEFT JOIN #dsn#.EMPLOYEES E ON E.EMPLOYEE_ID = EIPR.EMP_ID
        LEFT JOIN #dsn#.EMPLOYEES_RELATIVES ER ON ER.RELATIVE_ID = EIPR.RELATIVE_ID
        LEFT JOIN #dsn#.SETUP_HEALTH_ASSURANCE_TYPE SHAT ON SHAT.ASSURANCE_ID = EIPR.ASSURANCE_ID
    WHERE
        EIPR.TREATED IS NOT NULL AND
        EIPR.IS_APPROVE = 1
        <cfif len(attributes.employee_id)>
            AND EIPR.EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
        </cfif>
        <cfif len(attributes.assurance_id)>
            AND EIPR.ASSURANCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assurance_id#">
        </cfif>
        <cfif len(attributes.relative_id) and (attributes.relative_id eq -1 or attributes.relative_id eq 0)>
            AND EIPR.TREATED = 1
            AND (EIPR.RELATIVE_ID IS NULL OR EIPR.RELATIVE_ID = 0)
        <cfelse>
            AND EIPR.TREATED = 2
            AND EIPR.RELATIVE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.relative_id#">
        </cfif>
    ORDER BY
        EIPR.EXPENSE_DATE
</cfquery>

<cf_grid_list>
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id = '57880.Belge No'></th>
            <th><cf_get_lang dictionary_id = "51231.Sicil No"></th>
            <th><cf_get_lang dictionary_id = "57576.Çalışan"></th>
            <th><cf_get_lang dictionary_id = "34712.Tedavi Gören"></th>
            <th><cf_get_lang dictionary_id = "53143.Yakınlığı"></th>
            <th><cf_get_lang dictionary_id = "58689.Teminat"><cf_get_lang dictionary_id = "216.Tipi"></th>
            <th><cf_get_lang dictionary_id = "34434.Para Br"></th>
            <th><cf_get_lang dictionary_id = "48323.Fatura Tutarı"></th>
            <th><cf_get_lang dictionary_id = "59887.Tedaviye Esas Tutar"></th>
            <th><cf_get_lang dictionary_id = "61027.Ödeme Oranı"></th>
            <th><cf_get_lang dictionary_id = "41154.Kurum Payı"></th>
            <th><cf_get_lang dictionary_id = "41148.Çalışan Payı"></th>
            <th><cf_get_lang dictionary_id = '57482.Aşama'></th>
            <th><cf_get_lang dictionary_id = "33203.Belge Tarihi"></th>
        <tr>
    </thead>
    <tbody>
        <cfif get_data2.recordcount>
            <cfoutput query="get_data2">
                <tr>
                    <td><a href="#request.self#?fuseaction=hr.health_expense_approve&event=upd&health_id=#EXPENSE_ID#" target="_blank">#PAPER_NO#</a></td>
                    <td>#EMPLOYEE_NO#</td>
                    <td>#EMP_FULLNAME#</td>
                    <td>#REL_FULLNAME#</td>
                    <td>
                        <cfif len(RELATIVE_LEVEL) and len(RELATIVE_ID)>
                            #ListGetAt(relative_name_list,RELATIVE_LEVEL)#
                        <cfelse>
                            <cf_get_lang dictionary_id = "40429.Kendisi">
                        </cfif>
                    </td>
                    <td>#ASSURANCE#</td>
                    <td class="text-right">#MONEY#</td>
                    <td class="text-right">#TLFormat(NET_TOTAL_AMOUNT)#</td>
                    <td class="text-right">#TLFormat(TREATMENT_AMOUNT)#</td>
                    <td class="text-right">#TLFormat(COMPANY_AMOUNT_RATE)#</td>
                    <td class="text-right">#TLFormat(OUR_COMPANY_HEALTH_AMOUNT)#</td>
                    <td class="text-right">#TLFormat(EMPLOYEE_HEALTH_AMOUNT)#</td>
                    <td>
                        <cfif len(EXPENSE_STAGE)>
                            <cf_workcube_process type="color-status" process_stage="#EXPENSE_STAGE#" fuseaction="hr.health_expense_approve">
                        </cfif>
                    </td>
                    <td>#dateFormat(EXPENSE_DATE,dateformat_style)#</td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="14"><cf_get_lang dictionary_id='57484.kayıt yok'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_grid_list>