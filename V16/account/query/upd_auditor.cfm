
<cfset wizard = createObject("component", "V16.account.cfc.MagicAuditor" )>

<cftransaction>
    <cf_date tarih = "attributes.process_date">

    <!--- Belge --->
    <cfset upd_wizard_id = wizard.upd_wizard(
                                                wizard_id : attributes.wizard_id,
                                                wizard_name : "#attributes.wizard_name#",
                                                wizard_designer : attributes.employee_id,
                                                wizard_stage : attributes.process_stage,
                                                wizard_date : "#attributes.process_date#",
                                                period_month : attributes.run_period,
                                                period_day : "#iif(len(attributes.period_day), 'attributes.period_day', DE(''))#",
                                                target_type : "#iif(len(attributes.target_type), 'attributes.target_type', DE(''))#"
                                            )>

    <cfset get_wizard_block = wizard.get_wizard_block(
                                                        wizard_id : attributes.wizard_id
                                                     )>

    <cfset del_wizard_block = wizard.del_wizard_block(
                                                        wizard_id : attributes.wizard_id
                                                     )>

    <cfif len(get_wizard_block.wizard_block_id)>
        <cfset del_wizard_block_row = wizard.del_wizard_block_row(
                                                                    block_id : valueList(get_wizard_block.wizard_block_id)
                                                                 )>
    </cfif>

    <cfloop from = "1" to = "#attributes.rowcount#" index = "r">
        <cfif evaluate("attributes.row_kontrol_#r#") eq 1>

            <!--- Blok --->
            <cfset add_wizard_block_id = wizard.add_wizard_block(
                                                                    wizard_id : attributes.wizard_id,
                                                                    block_name_left : '#evaluate("block_name_left_#r#")#',
                                                                    block_name_right : '#evaluate("block_name_right_#r#")#',
                                                                    block_operation : '#evaluate("detail_counter_block_type_#r#")#',
                                                                    block_rate : '#evaluate("detail_counter_rate_type_#r#")#'
                                                                )>

            <cfloop from = "1" to = "2" index = "c">
                <cfloop from = "1" to = "#evaluate('attributes.counter_#r#_#c#')#" index = "a">

                    <!--- Blok Satırları --->
                    <cfset add_wizard_block_row = wizard.add_wizard_block_row(
                                                                                wizard_block_id : add_wizard_block_id,
                                                                                block_column : c, 
                                                                                account_code : '#evaluate("acc_#r#_#c#_#a#")#',
                                                                                rate : '#evaluate("rate_#r#_#c#_#a#")#',
                                                                                description : '#evaluate("desc_#r#_#c#_#a#")#',
                                                                                ba : '#evaluate("ba_#r#_#c#_#a#")#',
                                                                                action_type_hidden : '#listdeleteduplicates(evaluate("action_type_hidden_#r#_#c#_#a#"))#'
                                                                            )>
                </cfloop>
            </cfloop>

        </cfif>
    </cfloop>

</cftransaction>