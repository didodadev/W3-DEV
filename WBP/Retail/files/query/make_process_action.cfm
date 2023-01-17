<cfif isdefined("attributes.table_code") and len(attributes.table_code)>
    <cfquery name="get_table" datasource="#dsn_dev#">
        SELECT
            TABLE_SECRET_CODE,
            TABLE_INFO,
            TABLE_ID
        FROM
            SEARCH_TABLES
        WHERE
            TABLE_CODE = '#attributes.table_code#'
    </cfquery>
    <cfset attributes.table_id = get_table.TABLE_ID>
    <cfset attributes.table_secret_code = get_table.TABLE_SECRET_CODE>
<cfelseif isdefined("attributes.table_secret_code") and len(attributes.table_secret_code)>
	<cfset attributes.table_id = "">
    <cfset attributes.table_code = "">
<cfelse>
	<cfset attributes.table_id = "">
    <cfset attributes.table_code = "">
    <cfset attributes.table_secret_code = "">
</cfif>

<cfquery name="get_departments_search" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>
<cfset all_dept_list = valuelist(get_departments_search.DEPARTMENT_ID)>

<cfloop from="1" to="5" index="ccc">
	<cfif len(evaluate("attributes.process_type_#ccc#"))>
        <cfset process_type_ = evaluate("attributes.process_type_#ccc#")>
        <cfset detail_ = evaluate("attributes.process_detail_#ccc#")>
        <cfset process_startdate_ = evaluate("attributes.process_startdate_#ccc#")>
        <cfset process_finishdate_ = evaluate("attributes.process_finishdate_#ccc#")>
        <cfset payment_date_ = evaluate("attributes.payment_date_#ccc#")>
        <cfset tax_ = evaluate("attributes.tax_#ccc#")>
        <cfset period_ = evaluate("attributes.period_#ccc#")>
        <cfset quantity_ = evaluate("attributes.quantity_#ccc#")>
        <cfset cost_ = filternum(evaluate("attributes.cost_#ccc#"))>
        <cfset revenue_rate_ = evaluate("attributes.revenue_rate_#ccc#")>
        <cfset uretici_id_ = evaluate("attributes.uretici_id_#ccc#")>
        
        <cfif not isdefined("attributes.department_id_#ccc#")>
        	<cfset row_dept_list = all_dept_list>
        <cfelse>
        	<cfset row_dept_list = evaluate("attributes.department_id_#ccc#")>
        </cfif>
        
        <cfquery name="get_type" datasource="#dsn_dev#">
        	SELECT * FROM SEARCH_TABLE_PROCESS_TYPES WHERE TYPE_ID = #process_type_#
        </cfquery>
        <cfif get_type.IS_RATE eq 1>
        	<cfset row_dept_list = merkez_depo_id>
            <cfset quantity_ = 1>
        </cfif>

        <cf_date tarih="process_startdate_">        
        <cf_date tarih="process_finishdate_">
        <cfif len(payment_date_)>
            <cf_date tarih="payment_date_">
        </cfif>
        
        <cfloop from="1" to="#quantity_#" index="miktar_">
            <cfset inner_process_startdate_ = dateadd("m",(miktar_ - 1) * period_,process_startdate_)>
            <cfset inner_process_finishdate_ = dateadd("m",(miktar_ - 1) * period_,process_finishdate_)>
            <cfif len(payment_date_)>
				<cfset inner_payment_date_ = dateadd("m",(miktar_ - 1) * period_,payment_date_)>
            </cfif>
            
            <cfloop list="#row_dept_list#" index="dept_">
                <cfquery name="add_" datasource="#dsn_dev#" result="my_result">
                    INSERT INTO
                        PROCESS_ROWS
                        (
                        COMPANY_ID,
                        PROJECT_ID,
                        TABLE_CODE,
                        TABLE_ID,
                        TABLE_SECRET_CODE,
                        DEPARTMENT_ID,
                        PROCESS_TYPE,
                        PROCESS_DETAIL,
                        PROCESS_STARTDATE,
                        PROCESS_FINISHDATE,
                        PAYMENT_DATE,
                        COST,
                        REVENUE_RATE,
                        RECORD_DATE,
                        RECORD_EMP,
                        QUANTITY,
                        TAX,
                        URETICI_ID,
                        PERIOD
                        )
                        VALUES
                        (
                        #attributes.COMPANY_ID#,
                        <cfif len(attributes.PROJECT_ID)>#attributes.PROJECT_ID#<cfelse>NULL</cfif>,
                        '#attributes.TABLE_CODE#',
                        <cfif len(attributes.TABLE_ID)>#attributes.TABLE_ID#<cfelse>NULL</cfif>,
                        '#attributes.TABLE_SECRET_CODE#',
                        #dept_#,
                        #process_type_#,
                        '#detail_#',
                        #inner_process_startdate_#,
                        #inner_process_finishdate_#,
                        <cfif len(payment_date_)>#inner_payment_date_#<cfelse>#inner_process_finishdate_#</cfif>,
                        <cfif len(cost_)>#cost_#<cfelse>NULL</cfif>,
                        '#revenue_rate_#',
                        #now()#,
                        #session.ep.userid#,
                        1,
                        #tax_#,
                        <cfif len(uretici_id_)>#uretici_id_#<cfelse>NULL</cfif>,
                        #period_#
                        )
                </cfquery>

                <cfif isdefined("attributes.ana_group_id_#ccc#")>
                	<cfset list_ = evaluate("attributes.ana_group_id_#ccc#")>
                    <cfloop from="1" to="#listlen(list_)#" index="ccm">
                    	<cfquery name="add_" datasource="#dsn_dev#">
                        	INSERT INTO 
                            	PROCESS_ROWS_CATS
                                (
                                ROW_ID,
                                HIERARCHY
                                )
                                VALUES
                                (
                                #my_result.IDENTITYCOL#,
                                '#listgetat(list_,ccm)#'
                                )
                        </cfquery>
                    </cfloop>
                </cfif>
                
                <cfif isdefined("attributes.alt_group_id_#ccc#")>
                	<cfset list_ = evaluate("attributes.alt_group_id_#ccc#")>
                    <cfloop from="1" to="#listlen(list_)#" index="ccm">
                    	<cfquery name="add_" datasource="#dsn_dev#">
                        	INSERT INTO 
                            	PROCESS_ROWS_CATS
                                (
                                ROW_ID,
                                HIERARCHY
                                )
                                VALUES
                                (
                                #my_result.IDENTITYCOL#,
                                '#listgetat(list_,ccm)#'
                                )
                        </cfquery>
                    </cfloop>
                </cfif>
                
                <cfif isdefined("attributes.alt_group_2_id_#ccc#")>
                	<cfset list_ = evaluate("attributes.alt_group_2_id_#ccc#")>
                    <cfloop from="1" to="#listlen(list_)#" index="ccm">
                    	<cfquery name="add_" datasource="#dsn_dev#">
                        	INSERT INTO 
                            	PROCESS_ROWS_CATS
                                (
                                ROW_ID,
                                HIERARCHY
                                )
                                VALUES
                                (
                                #my_result.IDENTITYCOL#,
                                '#listgetat(list_,ccm)#'
                                )
                        </cfquery>
                    </cfloop>
                </cfif>
          </cfloop>
      </cfloop>
    </cfif>
</cfloop>
<cflocation url="#request.self#?fuseaction=retail.popup_make_process_action&company_name=#attributes.company_name#&company_id=#attributes.company_id#&project_id=#attributes.project_id#&table_code=#attributes.table_code#&table_secret_code=#attributes.table_secret_code#" addtoken="no">
