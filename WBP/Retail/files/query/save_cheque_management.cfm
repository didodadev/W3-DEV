<cf_date tarih = "attributes.action_startdate">
<cf_date tarih = "attributes.action_finishdate">
<cf_date tarih = "attributes.action_islem_tarihi">
<cftransaction>
	<cfif isdefined("attributes.table_code") and len(attributes.table_code)>
        <cfquery name="upd_" datasource="#dsn_dev#">
            UPDATE
                PAYMENT_TABLE
            SET
                IS_PAID = <cfif isdefined("attributes.is_paid")>1<cfelse>0</cfif>,
                IS_BANK = <cfif isdefined("attributes.is_bank")>1<cfelse>0</cfif>,
                TABLE_DETAIL = '#attributes.detail#',
                ACTION_DATE = #attributes.action_islem_tarihi#,
                ACTION_STARDATE = #attributes.action_startdate#,
                ACTION_FINISHDATE = #attributes.action_finishdate#,
                ACTION_COMPANY_ID = <cfif len(attributes.action_company_id)>'#attributes.action_company_id#'<cfelse>NULL</cfif>,
                ACTION_LIMIT_ALT = '#attributes.action_limit_alt#',
                ACTION_LIMIT_UST = '#attributes.action_limit_ust#',
                ACTION_ORDER_TYPE = #attributes.action_order_type#,
                ACTION_COMPANY_CATS = '#attributes.ACTION_COMPANY_CATS#',
                UZATMA_EKLE = '#attributes.UZATMA_EKLE#'
            WHERE
                TABLE_CODE = '#attributes.table_code#'
        </cfquery>
        <cfquery name="get_table" datasource="#dsn_Dev#">
            SELECT TABLE_ID FROM PAYMENT_TABLE WHERE TABLE_CODE = '#attributes.table_code#'
        </cfquery>
        <cfquery name="del_" datasource="#dsn_dev#">
            DELETE FROM PAYMENT_TABLE_ROWS WHERE TABLE_ID = #get_table.TABLE_ID#
        </cfquery>
        <cfquery name="del_" datasource="#dsn_dev#">
            DELETE FROM PAYMENT_TABLE_GROUPS WHERE TABLE_ID = #get_table.TABLE_ID#
        </cfquery>
        <cfset max_id.IDENTITYCOL = get_table.TABLE_ID>
    <cfelse>
        <cfquery name="add_table" datasource="#dsn_dev#" result="max_id">
            INSERT INTO
                PAYMENT_TABLE
                (
                TABLE_DETAIL,
                ACTION_DATE,
                ACTION_STARDATE,
                ACTION_FINISHDATE,
                ACTION_COMPANY_ID,
                ACTION_LIMIT_ALT,
                ACTION_LIMIT_UST,
                ACTION_ORDER_TYPE,
                ACTION_COMPANY_CATS,
                UZATMA_EKLE,
                IS_BANK
                )
                VALUES
                (
                '#attributes.detail#',
                #attributes.action_islem_tarihi#,
                #attributes.action_startdate#,
                #attributes.action_finishdate#,
                <cfif len(attributes.action_company_id)>'#attributes.action_company_id#'<cfelse>NULL</cfif>,
                '#attributes.action_limit_alt#',
                '#attributes.action_limit_ust#',
                #attributes.action_order_type#,
                '#attributes.ACTION_COMPANY_CATS#',
                '#attributes.UZATMA_EKLE#',
                <cfif isdefined("attributes.is_bank")>1<cfelse>0</cfif>
                )
        </cfquery>
        
        <cfset new_number = max_id.IDENTITYCOL>
        <cfset attributes.table_code = new_number>
        <cfloop from="1" to="#8-len(new_number)#" index="ccc">
            <cfset attributes.table_code = "0" & attributes.table_code>
        </cfloop>
        
        <cfquery name="upd_table" datasource="#dsn_dev#">
            UPDATE
                PAYMENT_TABLE
            SET
                TABLE_CODE = '#attributes.table_code#'
            WHERE
                TABLE_ID = #max_id.IDENTITYCOL#
        </cfquery>
    </cfif>   
    
    <cfif len(attributes.payment_groups)>
        <cfloop list="#attributes.payment_groups#" index="group_">
            <cfquery name="add_" datasource="#dsn_dev#">
                INSERT INTO
                    PAYMENT_TABLE_GROUPS
                    (
                    TABLE_ID,
                    TABLE_CODE,
                    PAYMENT_GROUP_ID
                    )
                    VALUES
                    (
                    #max_id.IDENTITYCOL#,
                    '#attributes.table_code#',
                    #group_#
                    )
            </cfquery>
        </cfloop>
    </cfif>
        
    <cfloop from="1" to="#row_count#" index="ccc">
		<cfif isdefined("attributes.row_active#ccc#")>
        	<cfset evrak_tarihi_ = evaluate("attributes.evrak_tarihi#ccc#")>
        	<cfset vade_tarihi_ = evaluate("attributes.vade_tarihi#ccc#")>
            <cfset uzatma_tarih_ = evaluate("attributes.uzatma_tarih#ccc#")>
            <cfset odeme_gun_tarih_ = evaluate("attributes.odeme_gunu_tarih#ccc#")>
            
            <cfif isdefined("attributes.bank_name#ccc#")>
				<cfset bank_name_ = evaluate("attributes.bank_name#ccc#")>
                <cfset bank_iban_ = evaluate("attributes.bank_iban#ccc#")>
            </cfif>
        
        	<cf_date tarih = "evrak_tarihi_">
            <cf_date tarih = "vade_tarihi_">
            <cf_date tarih = "uzatma_tarih_">
            <cf_date tarih = "odeme_gun_tarih_">
        
        	<cfquery name="add_row_" datasource="#dsn_dev#">
            	INSERT INTO
                	PAYMENT_TABLE_ROWS
                    (
                    TABLE_ID,
                    EVRAK_TARIHI,
                    VADE_TARIHI,
                    VADE_GUN,
                    ISLEM_TAR_VADE,
                    BAKIYE,
                    UZATMA_GUN,
                    UZATMA_TARIH,
                    ODEME_GUNU_TARIH,
                    SON_VADE_GUN,
                    VADE_ASIMI,
                    <cfif isdefined("attributes.bank_name#ccc#")>
                    BANK_NAME,
                    BANK_IBAN,
                    </cfif>
                    PAYMENT_GROUP_ID,
                    PAYMENT_GROUP_ROW_ID,
                    COMPANY_ID
                    )
                    VALUES
                    (
                    #max_id.IDENTITYCOL#,
                    #evrak_tarihi_#,
                    #vade_tarihi_#,
                    #evaluate("attributes.vade_gun#ccc#")#,
                    #evaluate("attributes.islem_tar_vade#ccc#")#,
                    #filternum(evaluate("attributes.bakiye#ccc#"))#,
                    <cfif len(evaluate("attributes.uzatma_gun#ccc#"))>#evaluate("attributes.uzatma_gun#ccc#")#<cfelse>0</cfif>,
                    #uzatma_tarih_#,
                    #odeme_gun_tarih_#,
                    #evaluate("attributes.son_vade_gun#ccc#")#,
                    #evaluate("attributes.vade_asimi#ccc#")#,
                    <cfif isdefined("attributes.bank_name#ccc#")>
                    '#bank_name_#',
                    '#bank_iban_#',
                    </cfif>
                    <cfif len(evaluate("attributes.payment_group_id#ccc#"))>#evaluate("attributes.payment_group_id#ccc#")#<cfelse>NULL</cfif>,
                    <cfif len(evaluate("attributes.payment_group_row_id#ccc#"))>#evaluate("attributes.payment_group_row_id#ccc#")#<cfelse>NULL</cfif>,
                    #evaluate("attributes.company_id#ccc#")#
                    )
            </cfquery>
        </cfif>
    </cfloop>
</cftransaction>
<script>
    window.location.href="<cfoutput>#request.self#?fuseaction=retail.list_cheque_management&event=upd&is_submit=1&table_code=#attributes.table_code#&is_bank=1</cfoutput>";  
</script>
