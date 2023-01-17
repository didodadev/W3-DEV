<cfset discount_manuel = attributes.p_discount_manuel>
<cfif len(discount_manuel)>
	<cfset discount_manuel = discount_manuel>
<cfelse>
	<cfset discount_manuel = 0>
</cfif>
<cfset discount_ilk = attributes.sales_discount>

<cfloop from="1" to="10" index="i">
	<cfset 'discount#i#' = 0>
</cfloop>

<cfset i = 0>
<cfloop list="#discount_ilk#" index="dis" delimiters="+">
	<cfset i = i+1>
	<cfset 'discount#i#' = filterNum(dis)>
</cfloop>

<cfif len(attributes.company_code)>
	<cfset company_id_ = listfirst(attributes.company_code,'_')>
	<cfset project_id_ = listlast(attributes.company_code,'_')>
<cfelse>
	<cfset company_id_ = "">
	<cfset project_id_ = "">
</cfif>


<cfif 
	attributes.FIRST_SATIS_PRICE gt 0 and 
	(
		(len(attributes.startdate) and len(attributes.finishdate) and isdate(attributes.startdate) and isdate(attributes.finishdate))
		or
		(len(attributes.p_startdate) and len(attributes.p_finishdate) and isdate(attributes.p_startdate) and isdate(attributes.p_finishdate))
	)
	>
     
	<cfif len(attributes.startdate) and isdate(attributes.startdate)><cf_date tarih = 'attributes.startdate'></cfif>
	<cfif len(attributes.finishdate) and isdate(attributes.finishdate)><cf_date tarih = 'attributes.finishdate'></cfif>
	
	<cfif len(attributes.p_startdate)><cf_date tarih = 'attributes.p_startdate'></cfif>
	<cfif len(attributes.p_finishdate)><cf_date tarih = 'attributes.p_finishdate'></cfif>
	
    
	<cfset p_alis = attributes.NEW_ALIS_KDVLI>
    <cfset p_satis = attributes.FIRST_SATIS_PRICE_KDV>
    
    <cfset p_start = attributes.p_startdate>
    <cfset p_finish_ = attributes.p_finishdate>
    
    <cfset start_ = attributes.startdate>
    <cfset finish_ = attributes.finishdate>
    
    <cfset p_type_ = attributes.price_type_id>
    
    <cfif attributes.is_active_s eq 1>
    	<cfset is_active_s_ = 1>
    <cfelse>
    	<cfset is_active_s_ = 0>
    </cfif>
    
    <cfif attributes.is_active_p eq 1>
    	<cfset is_active_p_ = 1>
    <cfelse>
    	<cfset is_active_p_ = 0>
    </cfif>
    
    <cfif attributes.update_price_action eq 0>
    	<cfset is_active_s_ = 1>
        <cfset is_active_p_ = 1>
    </cfif>
    
    <cfif attributes.update_price_action eq 2>
    	<cfset is_active_s_ = 0>
        <cfset is_active_p_ = 0>
    </cfif>
    
    <cfset row_id_ =  attributes.product_price_change_lastrowid>
    
    <cfif attributes.update_price_action eq 1 and len(row_id_) and row_id_ gt 0>
    	<cfquery name="get_old_startdate" datasource="#dsn_dev#">
        	SELECT STARTDATE,IS_ACTIVE_S FROM PRICE_TABLE WHERE ROW_ID = #row_id_#
        </cfquery>
        <cfset old_startdate = dateformat(get_old_startdate.startdate,'ddmmyyyy')>
    </cfif>
    <cfset control_startdate = dateformat(attributes.startdate,'ddmmyyyy')>
    
       
    <cfif attributes.update_price_action eq 1 and len(row_id_) and row_id_ gt 0 and (old_startdate is control_startdate or datediff('d',now(),old_startdate) gte 0 or (is_active_s_ eq 0 and get_old_startdate.IS_ACTIVE_S eq 0))>
    	  <cfquery name="get_checks" datasource="#dsn_dev#">
          		SELECT
                	ISNULL(IS_ACTIVE_S,0) AS ACTIVE_S,
                    ISNULL(IS_ACTIVE_P,0) AS ACTIVE_P
                FROM
                	PRICE_TABLE
                WHERE
               		ROW_ID = #row_id_#
          </cfquery>
          <cfquery name="add_" datasource="#dsn_dev#" result="aa">
                UPDATE
                    PRICE_TABLE
                SET
                    SALIS = #attributes.STANDART_ALIS_LISTE#,
                    SALISKDV = #attributes.STANDART_ALIS_KDVLI#,
                    AKDV = #attributes.tax_purchase#,
                    SSATIS = #attributes.READ_FIRST_SATIS_PRICE#,
                    SSATISKDV = #attributes.READ_FIRST_SATIS_PRICE_KDV#,
                    SKDV = #attributes.tax#,
                    DISCOUNT1 = <cfif len(discount1)>#discount1#<cfelse>0</cfif>,
                    DISCOUNT2 = <cfif len(discount2)>#discount2#<cfelse>0</cfif>,
                    DISCOUNT3 = <cfif len(discount3)>#discount3#<cfelse>0</cfif>,
                    DISCOUNT4 = <cfif len(discount4)>#discount4#<cfelse>0</cfif>,
                    DISCOUNT5 = <cfif len(discount5)>#discount5#<cfelse>0</cfif>,
                    DISCOUNT6 = <cfif len(discount6)>#discount6#<cfelse>0</cfif>,
                    DISCOUNT7 = <cfif len(discount7)>#discount7#<cfelse>0</cfif>,
                    DISCOUNT8 = <cfif len(discount8)>#discount8#<cfelse>0</cfif>,
                    DISCOUNT9 = <cfif len(discount9)>#discount9#<cfelse>0</cfif>,
                    DISCOUNT10 = <cfif len(discount10)>#discount10#<cfelse>0</cfif>,
                    MANUEL_DISCOUNT = #discount_manuel#,
                    NEW_ALIS = #attributes.NEW_ALIS#,
                    NEW_ALIS_KDV = #attributes.NEW_ALIS_KDVLI#,
                    NEW_PRICE = #attributes.FIRST_SATIS_PRICE#,
                    NEW_PRICE_KDV = #attributes.FIRST_SATIS_PRICE_KDV#,
                    MARGIN = #attributes.p_ss_marj#,
                    STARTDATE = <cfif len(attributes.startdate)>#attributes.startdate#<cfelse>NULL</cfif>,
                    FINISHDATE = <cfif len(attributes.finishdate)>#attributes.finishdate#<cfelse>NULL</cfif>,
                    UPDATE_EMP = #session.ep.userid#,
                    UPDATE_DATE = #simdiki_zaman_#, 
                    PRODUCT_ID = #product_id_#,
                    STOCK_ID = NULL,
                    PRICE_TYPE = #attributes.price_type_id#,
                    IS_ACTIVE_S = <cfif is_active_s_ eq 1>1<cfelseif get_checks.ACTIVE_S eq 1>1<cfelse>0</cfif>,
                    IS_ACTIVE_P = <cfif is_active_p_ eq 1>1<cfelseif get_checks.ACTIVE_P eq 1>1<cfelse>0</cfif>,
                    CHANGE_RATE = '#attributes.READ_FIRST_SATIS_PRICE_RATE#',
                    P_STARTDATE = <cfif len(attributes.p_startdate)>#attributes.p_startdate#<cfelse>NULL</cfif>,
                    P_FINISHDATE = <cfif len(attributes.p_finishdate)>#attributes.p_finishdate#<cfelse>NULL</cfif>,
                    P_MARGIN = <cfif len(attributes.p_marj)>#attributes.p_marj#<cfelse>NULL</cfif>,
                    DUEDAY = <cfif len(attributes.p_dueday)>#attributes.p_dueday#<cfelse>NULL</cfif>,
                    P_PRODUCT_TYPE = #attributes.p_product_type#,
                    BRUT_ALIS = #attributes.NEW_ALIS_START#,
                    COMPANY_ID = <cfif len(company_id_)>#company_id_#<cfelse>NULL</cfif>,
                    PROJECT_ID = <cfif len(project_id_)>#project_id_#<cfelse>NULL</cfif>
               WHERE
               		ROW_ID = #row_id_#
            </cfquery>
            <cfquery name="del_b" datasource="#dsn_dev#">
                DELETE FROM PRICE_TABLE_DEPARTMENTS WHERE ROW_ID = #row_id_#
            </cfquery>
            <cfif len(attributes.price_departments) and attributes.price_departments neq 0>
                <cfset attributes.price_departments = listsort(listdeleteduplicates(attributes.price_departments),'numeric','ASC')>
                <cfloop list="#attributes.price_departments#" index="dept_">
                	<cfquery name="add_" datasource="#dsn_dev#">
                    	INSERT INTO
                        	PRICE_TABLE_DEPARTMENTS
                            (
                            ROW_ID,
                            DEPARTMENT_ID
                            )
                            VALUES
                            (
                            #row_id_#,
                            #dept_#
                            )
                    </cfquery>
                </cfloop>
            </cfif>
	<cfelse>
        <cfquery name="control_" datasource="#dsn_dev#">
            SELECT
                *
            FROM
                PRICE_TABLE
            WHERE
                TABLE_ID IS NOT NULL AND
                PRODUCT_ID = #product_id_#
                <cfif len(p_start)>
                    AND P_STARTDATE = #p_start#
                </cfif>
                <cfif len(p_finish_)>
                    AND P_FINISHDATE = #p_finish_#
                </cfif>
                <cfif len(start_)>
                    AND STARTDATE = #start_#
                </cfif>
                <cfif len(finish_)>
                    AND FINISHDATE = #finish_#
                </cfif>
                <cfif len(p_type_)>
                    AND PRICE_TYPE = #p_type_#
                </cfif>
        </cfquery>
        
        <cfif not control_.recordcount>
        	<cfset yeni_fiyat_yaz_ = 1>
        <cfelse>
        	<cfset yeni_fiyat_yaz_ = 0>
            
            <cfif attributes.price_departments eq 0>
            	<cfset attributes.price_departments = ''>
            <cfelse>
            	<cfset attributes.price_departments = listsort(listdeleteduplicates(attributes.price_departments),'numeric','ASC')>
            </cfif>
            <cfquery name="get_p_row_depts" datasource="#dsn_dev#"> 
            	SELECT DEPARTMENT_ID FROM PRICE_TABLE_DEPARTMENTS WHERE ROW_ID = #control_.row_id#
            </cfquery>
            <cfif get_p_row_depts.recordcount>
            	<cfset new_price_departments = listsort(listdeleteduplicates(valuelist(get_p_row_depts.DEPARTMENT_ID)),'numeric','ASC')>
            <cfelse>
            	<cfset new_price_departments = ''>
            </cfif>
            
            <cfif new_price_departments is not attributes.price_departments>
            	<cfset yeni_fiyat_yaz_ = 1>
            </cfif>
        </cfif>
        
        <cfif yeni_fiyat_yaz_ eq 1>
            <cfquery name="add_" datasource="#dsn_dev#" result="price_add_result">
                INSERT INTO
                    PRICE_TABLE
                    (
                    WRK_ID,
                    P_PRODUCT_TYPE,
                    SALIS,
                    SALISKDV,
                    AKDV,
                    SSATIS,
                    SSATISKDV,
                    SKDV,
                    DISCOUNT1,
                    DISCOUNT2,
                    DISCOUNT3,
                    DISCOUNT4,
                    DISCOUNT5,
                    DISCOUNT6,
                    DISCOUNT7,
                    DISCOUNT8,
                    DISCOUNT9,
                    DISCOUNT10,
                    MANUEL_DISCOUNT,
                    NEW_ALIS,
                    NEW_ALIS_KDV,
                    NEW_PRICE,
                    NEW_PRICE_KDV,
                    MARGIN,
                    STARTDATE,
                    FINISHDATE,
                    TABLE_ID,
                    TABLE_CODE,
                    <cfif isdefined("session.ep.userid")>
                    RECORD_EMP,
                    <cfelse>
                    RECORD_PAR,
                    </cfif>
                    RECORD_DATE,
                    PRODUCT_ID,
                    STOCK_ID,
                    PRICE_TYPE,
                    IS_ACTIVE_S,
                    IS_ACTIVE_P,
                    CHANGE_RATE,
                    P_STARTDATE,
                    P_FINISHDATE,
                    P_MARGIN,
                    DUEDAY,
                    BRUT_ALIS,
                    COMPANY_ID,
                    PROJECT_ID
                    )
                    VALUES
                    (
                    '#WRK_ID#',
                    #attributes.p_product_type#,
                    #attributes.STANDART_ALIS_LISTE#,
                    #attributes.STANDART_ALIS_KDVLI#,
                    #attributes.tax_purchase#,
                    #attributes.READ_FIRST_SATIS_PRICE#,
                    #attributes.READ_FIRST_SATIS_PRICE_KDV#,
                    #attributes.tax#,
                    <cfif len(discount1)>#discount1#<cfelse>0</cfif>,
                    <cfif len(discount2)>#discount2#<cfelse>0</cfif>,
                    <cfif len(discount3)>#discount3#<cfelse>0</cfif>,
                    <cfif len(discount4)>#discount4#<cfelse>0</cfif>,
                    <cfif len(discount5)>#discount5#<cfelse>0</cfif>,
                    <cfif len(discount6)>#discount6#<cfelse>0</cfif>,
                    <cfif len(discount7)>#discount7#<cfelse>0</cfif>,
                    <cfif len(discount8)>#discount8#<cfelse>0</cfif>,
                    <cfif len(discount9)>#discount9#<cfelse>0</cfif>,
                    <cfif len(discount10)>#discount10#<cfelse>0</cfif>,
                    #discount_manuel#,
                    #attributes.NEW_ALIS#,
                    #attributes.NEW_ALIS_KDVLI#,
                    #attributes.FIRST_SATIS_PRICE#,
                    #attributes.FIRST_SATIS_PRICE_KDV#,
                    <cfif len(attributes.p_ss_marj)>#attributes.p_ss_marj#<cfelse>0</cfif>,
                    <cfif len(attributes.startdate)>#attributes.startdate#<cfelse>NULL</cfif>,
                    <cfif len(attributes.finishdate)>#attributes.finishdate#<cfelse>NULL</cfif>,
                    #attributes.p_table_id#,
                    '#attributes.p_table_code#',
                    <cfif isdefined("session.ep.userid")>
                    #session.ep.userid#,
                    <cfelse>
                    #session.pp.userid#,
                    </cfif>
                    #simdiki_zaman_#,
                    #product_id_#,
                    NULL,
                    #attributes.price_type_id#,
                    #is_active_s_#,
                    #is_active_p_#,
                    '#attributes.READ_FIRST_SATIS_PRICE_RATE#',
                    <cfif len(attributes.p_startdate)>#attributes.p_startdate#<cfelse>NULL</cfif>,
                    <cfif len(attributes.p_finishdate)>#attributes.p_finishdate#<cfelse>NULL</cfif>,
                    <cfif len(attributes.p_marj)>#attributes.p_marj#<cfelse>NULL</cfif>,
                    <cfif len(attributes.p_dueday)>#attributes.p_dueday#<cfelse>NULL</cfif>,
                    #attributes.NEW_ALIS_START#,
                    <cfif len(company_id_)>#company_id_#<cfelse>NULL</cfif>,
                    <cfif len(project_id_)>#project_id_#<cfelse>NULL</cfif>
                    )
            </cfquery>
            <cfif len(attributes.price_departments) and attributes.price_departments neq 0>
                <cfloop list="#attributes.price_departments#" index="dept_">
                	<cfquery name="add_" datasource="#dsn_dev#">
                    	INSERT INTO
                        	PRICE_TABLE_DEPARTMENTS
                            (
                            ROW_ID,
                            DEPARTMENT_ID
                            )
                            VALUES
                            (
                            #price_add_result.identitycol#,
                            #dept_#
                            )
                    </cfquery>
                </cfloop>
            </cfif>
         <cfelse>
         	<cfquery name="add_" datasource="#dsn_dev#">
                UPDATE
                    PRICE_TABLE
                SET
                    SALIS = #attributes.STANDART_ALIS_LISTE#,
                    SALISKDV = #attributes.STANDART_ALIS_KDVLI#,
                    AKDV = #attributes.tax_purchase#,
                    SSATIS = #attributes.READ_FIRST_SATIS_PRICE#,
                    SSATISKDV = #attributes.READ_FIRST_SATIS_PRICE_KDV#,
                    SKDV = #attributes.tax#,
                    DISCOUNT1 = <cfif len(discount1)>#discount1#<cfelse>0</cfif>,
                    DISCOUNT2 = <cfif len(discount2)>#discount2#<cfelse>0</cfif>,
                    DISCOUNT3 = <cfif len(discount3)>#discount3#<cfelse>0</cfif>,
                    DISCOUNT4 = <cfif len(discount4)>#discount4#<cfelse>0</cfif>,
                    DISCOUNT5 = <cfif len(discount5)>#discount5#<cfelse>0</cfif>,
                    DISCOUNT6 = <cfif len(discount6)>#discount6#<cfelse>0</cfif>,
                    DISCOUNT7 = <cfif len(discount7)>#discount7#<cfelse>0</cfif>,
                    DISCOUNT8 = <cfif len(discount8)>#discount8#<cfelse>0</cfif>,
                    DISCOUNT9 = <cfif len(discount9)>#discount9#<cfelse>0</cfif>,
                    DISCOUNT10 = <cfif len(discount10)>#discount10#<cfelse>0</cfif>,
                    MANUEL_DISCOUNT = #discount_manuel#,
                    NEW_ALIS = #attributes.NEW_ALIS#,
                    NEW_ALIS_KDV = #attributes.NEW_ALIS_KDVLI#,
                    NEW_PRICE = #attributes.FIRST_SATIS_PRICE#,
                    NEW_PRICE_KDV = #attributes.FIRST_SATIS_PRICE_KDV#,
                    MARGIN = #attributes.p_ss_marj#,
                    STARTDATE = <cfif len(attributes.startdate)>#attributes.startdate#<cfelse>NULL</cfif>,
                    FINISHDATE = <cfif len(attributes.finishdate)>#attributes.finishdate#<cfelse>NULL</cfif>,
					UPDATE_EMP = <cfif isdefined("session.ep.userid")>#session.ep.userid#<cfelse>NULL</cfif>,
                    UPDATE_PAR = <cfif isdefined("session.pp.userid")>#session.pp.userid#<cfelse>NULL</cfif>,
                    UPDATE_DATE = #simdiki_zaman_#,
                    PRODUCT_ID = #product_id_#,
                    STOCK_ID = NULL,
                    PRICE_TYPE = #attributes.price_type_id#,
                    IS_ACTIVE_S = <cfif is_active_s_ eq 1>1<cfelse>0</cfif>,
                    IS_ACTIVE_P = <cfif is_active_p_ eq 1>1<cfelse>0</cfif>,
                    CHANGE_RATE = '#attributes.READ_FIRST_SATIS_PRICE_RATE#',
                    P_STARTDATE = <cfif len(attributes.p_startdate)>#attributes.p_startdate#<cfelse>NULL</cfif>,
                    P_FINISHDATE = <cfif len(attributes.p_finishdate)>#attributes.p_finishdate#<cfelse>NULL</cfif>,
                    P_MARGIN = <cfif len(attributes.p_marj)>#attributes.p_marj#<cfelse>NULL</cfif>,
                    DUEDAY = <cfif len(attributes.p_dueday)>#attributes.p_dueday#<cfelse>NULL</cfif>,
                    P_PRODUCT_TYPE = #attributes.p_product_type#,
                    BRUT_ALIS = #attributes.NEW_ALIS_START#
               WHERE
               		ROW_ID = #control_.row_id#
            </cfquery>
            <cfquery name="del_b" datasource="#dsn_dev#">
                DELETE FROM PRICE_TABLE_DEPARTMENTS WHERE ROW_ID = #control_.row_id#
            </cfquery>
            <cfif len(attributes.price_departments) and attributes.price_departments neq 0>
                <cfloop list="#attributes.price_departments#" index="dept_">
                	<cfquery name="add_" datasource="#dsn_dev#">
                    	INSERT INTO
                        	PRICE_TABLE_DEPARTMENTS
                            (
                            ROW_ID,
                            DEPARTMENT_ID
                            )
                            VALUES
                            (
                            #control_.row_id#,
                            #dept_#
                            )
                    </cfquery>
                </cfloop>
            </cfif>
         </cfif>
     </cfif>
</cfif>