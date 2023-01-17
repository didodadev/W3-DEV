<cfset siram_ = 0>
<cfloop list="#attributes.invoice_row_id_list#" index="invoice_row_id">
<cfset siram_ = siram_ + 1>

<cfif isdefined("attributes.rate_row_id_list")>
	<cfset rate_ = listgetat(attributes.rate_row_id_list,siram_)>
<cfelse>
	<cfset rate_ = 100>
</cfif>

<cfset toplam_kapama_ = 0>
	<cfquery name="get_i_row" datasource="#dsn2#">
    	SELECT
            (NETTOTAL - ODENEN) KALAN,
            NETTOTAL,
            INVOICE_ID,
            INVOICE_DATE,
            INVOICE_NUMBER,
            NAME_PRODUCT,
            INVOICE_ROW_ID,
            WRK_ROW_ID
        FROM
            (
            SELECT 
                ROUND(ISNULL((SELECT SUM(ISNULL(PAID_COST,0)) FROM #dsn_dev_alias#.INVOICE_ROW_CLOSED IRC WHERE IRC.WRK_ROW_ID = IR.WRK_ROW_ID),0),2) ODENEN,
                ROUND(IR.NETTOTAL / 100 * #rate_#,2) AS NETTOTAL,
                I.INVOICE_ID,
                I.INVOICE_DATE,
                I.INVOICE_NUMBER,
                IR.NAME_PRODUCT,
                IR.INVOICE_ROW_ID,
                IR.WRK_ROW_ID
            FROM 
                INVOICE_ROW IR,
                INVOICE I
            WHERE
                IR.INVOICE_ROW_ID = #invoice_row_id# AND
                I.INVOICE_ID = IR.INVOICE_ID
            ) T1
        WHERE
            ROUND(NETTOTAL - ODENEN,2) > 0
        ORDER BY
            INVOICE_DATE,
            INVOICE_NUMBER,
            NAME_PRODUCT
    </cfquery>
    
	<cfset baz_tutar_ = get_i_row.KALAN>
    <cfif attributes.type eq 0>
	<cfquery name="get_row" datasource="#dsn2#">
            SELECT 
                (COST - ISNULL(COST_PAID,0)) AS KALAN,
                ROW_ID AS ACTION_ID
            FROM 
                #dsn_dev_alias#.PROCESS_ROWS 
            WHERE 
                ROW_ID IN (#row_list_id#) AND
                (COST - ISNULL(COST_PAID,0)) > 0
        </cfquery>
    </cfif>
    <cfif attributes.type eq 1>
        <cfquery name="get_row" datasource="#dsn2#">
            SELECT 
                C_ROW_ID AS ACTION_ID,
                (REVENUE_NET - ISNULL(REVENUE_PAID,0)) AS KALAN
           FROM 
                #dsn_dev_alias#.INVOICE_REVENUE_ROWS 
           WHERE 
                C_ROW_ID IN (#listsort(row_list_id,'numeric','ASC')#) AND
                (REVENUE_NET - ISNULL(REVENUE_PAID,0)) > 0
           ORDER BY
           		INVOICE_DATE ASC,
            	C_ROW_ID ASC
        </cfquery>
    </cfif>
	<cfif attributes.type eq 2>
	<cfquery name="get_row" datasource="#dsn2#">
    	SELECT 
        	FF_ROW_ID AS ACTION_ID,
            (FF_NET - ISNULL(FF_PAID,0)) AS KALAN
       	FROM 
        	#dsn_dev_alias#.INVOICE_FF_ROWS 
        WHERE 
        	FF_ROW_ID IN (#row_list_id#) AND
            (FF_NET - ISNULL(FF_PAID,0)) > 0
    </cfquery>
    </cfif>
    
    <cfif get_row.recordcount>
    	<cfoutput query="get_row">
			<cfif baz_tutar_ gt 0>
            	<cfif baz_tutar_ gte KALAN>
                    <cfset kapatilacak = KALAN>
                    <cfset baz_tutar_ = baz_tutar_ - KALAN>
                    <cfset toplam_kapama_ = toplam_kapama_ + kapatilacak>
                <cfelse>
                    <cfset kapatilacak = baz_tutar_>
                    <cfset baz_tutar_ = 0>
                    <cfset toplam_kapama_ = toplam_kapama_ + kapatilacak>
                </cfif>
                
                <cfquery name="add_" datasource="#dsn2#"> 
                	INSERT INTO
                    	#dsn_dev_alias#.INVOICE_ROW_CLOSED
                        (
                            INVOICE_ID,
                            PERIOD_ID,
                            INVOICE_ROW_ID,
                            WRK_ROW_ID,
                            TYPE,
                            RELATED_ROW_ID,
                            PAID_COST,
                            CODE,
                            RECORD_EMP,
                            RECORD_DATE
                        )
                        VALUES
                        (
                        	#get_i_row.INVOICE_ID#,
                            #session.ep.period_id#,
                            #invoice_row_id#,
                            '#get_i_row.WRK_ROW_ID#',
                            #attributes.type#,
                            #ACTION_ID#,
                            #kapatilacak#,
                            'KAPAMA',
                            #session.ep.userid#,
                            #now()#
                        )             
                </cfquery>
                
                <cfif attributes.type eq 0>
                    <cfquery name="UPD1" datasource="#dsn2#">
                        UPDATE
                            #dsn_dev_alias#.PROCESS_ROWS
                        SET
                            COST_PAID = ISNULL(COST_PAID,0) + #kapatilacak#
                        WHERE
                            ROW_ID = #ACTION_ID#
                    </cfquery>
                </cfif>
                <cfif attributes.type eq 1>
                    <cfquery name="UPD1" datasource="#dsn2#">
                        UPDATE
                            #dsn_dev_alias#.INVOICE_REVENUE_ROWS
                        SET
                            REVENUE_PAID = ISNULL(REVENUE_PAID,0) + #kapatilacak#
                        WHERE
                            C_ROW_ID = #ACTION_ID#
                    </cfquery>
                </cfif>
                <cfif attributes.type eq 2>
                    <cfquery name="UPD1" datasource="#dsn2#">
                        UPDATE
                            #dsn_dev_alias#.INVOICE_FF_ROWS
                        SET
                            FF_PAID = ISNULL(FF_PAID,0) + #kapatilacak#
                        WHERE
                            FF_ROW_ID = #ACTION_ID#
                    </cfquery>
                </cfif>
            </cfif>
            <BR />
        </cfoutput>
    </cfif>
</cfloop>