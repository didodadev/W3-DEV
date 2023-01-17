<cftransaction>
	<cfif not isdefined("attributes.table_code") or not len(attributes.table_code)>
        <cflock timeout="20">
            <cfquery name="get_table_no" datasource="#dsn3#">
                SELECT TABLE_NUMBER FROM #dsn_dev_alias#.RIVAL_TABLE_NO
            </cfquery>
            <cfset new_number = get_table_no.TABLE_NUMBER + 1>
            <cfquery name="upd_table_no" datasource="#dsn3#">
                UPDATE #dsn_dev_alias#.RIVAL_TABLE_NO SET TABLE_NUMBER = #new_number#
            </cfquery>
        </cflock>
        <cfset attributes.table_code = new_number>
        <cfloop from="1" to="#8-len(new_number)#" index="ccc">
            <cfset attributes.table_code = "0" & attributes.table_code>
        </cfloop>
        
        <cfquery name="add_" datasource="#DSN3#" result="max_id">
            INSERT INTO 
                #dsn_dev_alias#.RIVAL_TABLES
                (
                TABLE_CODE,
                TABLE_INFO,
                MAIN_PRICE_TYPE,
                RECORD_DATE,
                RECORD_EMP
                )
            VALUES
                (
                '#attributes.table_code#',
                '#attributes.table_info#',
                <cfif len(attributes.main_price_type)>#attributes.main_price_type#<cfelse>NULL</cfif>,
                #now()#,
                #session.ep.userid#
                )
        </cfquery>
        <cfset attributes.table_id = max_id.IDENTITYCOL>
    <cfelse>
        <cfquery name="del_" datasource="#dsn3#">
            DELETE FROM PRICE_RIVAL WHERE TABLE_CODE = '#attributes.table_code#'
        </cfquery>
        
        <cfquery name="get_table_id" datasource="#DSN3#">
            SELECT TABLE_ID FROM #dsn_dev_alias#.RIVAL_TABLES WHERE TABLE_CODE = '#attributes.table_code#'
        </cfquery>
        <cfset attributes.table_id = get_table_id.TABLE_ID>
        
        <cfquery name="upd_" datasource="#dsn3#">
            UPDATE
                #dsn_dev_alias#.RIVAL_TABLES
            SET
                MAIN_PRICE_TYPE = <cfif len(attributes.main_price_type)>#attributes.main_price_type#<cfelse>NULL</cfif>,
                TABLE_INFO = '#attributes.table_info#',
                UPDATE_DATE = #now()#,
                UPDATE_EMP = #session.ep.userid#
            WHERE
                TABLE_ID = #attributes.table_id#
        </cfquery>
    </cfif>
    
    <cfquery name="get_rival_list" datasource="#dsn3#">
        SELECT
            R_ID,
            RIVAL_NAME,
            RIVAL_DETAIL
        FROM
            #dsn_alias#.SETUP_RIVALS
        ORDER BY
            RIVAL_NAME ASC
    </cfquery>
    <cfset aktif_satir_ = 0>
    <cfloop from="1" to="#attributes.row_count#" index="cc">
        <cfoutput>
            <cfif isdefined('attributes.pid_#cc#') and len(evaluate('attributes.pid_#cc#')) and len(evaluate('attributes.txt_product_#cc#'))>
            <cfset aktif_satir_ = aktif_satir_ + 1>
            <cfquery name="GET_PRODUCT_UNIT" datasource="#dsn3#">
                SELECT 
                    MAIN_UNIT_ID
                FROM 
                    PRODUCT_UNIT
                WHERE 
                    PRODUCT_ID = #evaluate('attributes.pid_#cc#')#
            </cfquery>
                <cfif len(evaluate('attributes.startdate_#cc#'))>
                    <CF_DATE tarih="attributes.startdate_#cc#">
                </cfif>
                <cfif isdefined('attributes.finishdate_#cc#') and len(evaluate('attributes.finishdate_#cc#'))>
                    <CF_DATE tarih="attributes.finishdate_#cc#">
                </cfif>
                <cfloop query="get_rival_list">
                    <cfif isdefined("attributes.rival_check_#get_rival_list.R_ID#") and isdefined('attributes.rival_pric_#cc#_#get_rival_list.R_ID#') and len(evaluate('attributes.rival_pric_#cc#_#get_rival_list.R_ID#'))>
                        <cfquery name="upd_product" datasource="#dsn3#">
                            INSERT INTO
                                PRICE_RIVAL
                                (
                                TABLE_CODE,
                                R_ID,
                                PRODUCT_ID,
                                STARTDATE,
                                <cfif isdefined('attributes.finishdate_#cc#') and len(evaluate('attributes.finishdate_#cc#'))>
                                FINISHDATE,
                                </cfif>
                                PRICE,
                                MONEY,
                                UNIT_ID,
                                RIVAL_DETAIL,
                                PRICE_TYPE,
                                RECORD_DATE,
                                RECORD_EMP,
                                RECORD_IP
                                )
                            VALUES
                                (
                                '#attributes.table_code#',
                                #get_rival_list.R_ID#,
                                #evaluate('attributes.pid_#cc#')#,
                                #evaluate('attributes.startdate_#cc#')#,
                                <cfif isdefined('attributes.finishdate_#cc#') and len(evaluate('attributes.finishdate_#cc#'))>
                                    #evaluate('attributes.finishdate_#cc#')#,
                                </cfif>
                                #filternum(evaluate('attributes.rival_pric_#cc#_#get_rival_list.R_ID#'))#,
                                'TL',
                                #GET_PRODUCT_UNIT.MAIN_UNIT_ID#, 
                                '',
                                <cfif isdefined('attributes.price_type_#cc#_#get_rival_list.R_ID#') and len(evaluate('attributes.price_type_#cc#_#get_rival_list.R_ID#'))>#evaluate('attributes.price_type_#cc#_#get_rival_list.R_ID#')#<cfelse>NULL</cfif>,
                                #now()#,
                                #session.ep.userid#,
                                '#cgi.REMOTE_ADDR#'
                                )
                        </cfquery>
                    </cfif>
                 </cfloop>
            </cfif>
        </cfoutput>
    </cfloop>
</cftransaction>
<cfif aktif_satir_ eq 0>
	<script>
		alert('Fiyat Girmediniz!');
		history.back();
	</script>
    <cfabort>
<cfelse>
	<script>
		alert('Fiyatlar Kayıt Edildi!');
		window.location.href = '<cfoutput>#request.self#?fuseaction=retail.list_rival_price&event=upd&table_code=#attributes.table_code#</cfoutput>';
	</script>
    <cfabort>
</cfif>