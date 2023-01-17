<cfset wizard = createObject("component", "V16.budget.cfc.magicBudgeter" )>

<cftransaction>
    <cf_date tarih = "attributes.process_date">

    <!--- Belge --->
    <cfset upd_wizard_id = wizard.upd_wizard(
                                                wizard_id : attributes.wizard_id,
                                                wizard_name : "#attributes.wizard_name#",
                                                wizard_designer : attributes.employee_id,
                                                wizard_stage : attributes.process_stage,
                                                wizard_date : "#attributes.process_date#"
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
                                                                    block_income : '#evaluate("block_type_left_#r#")#'
                                                                )>

            <cfloop from = "1" to = "2" index = "c">
                <cfloop from = "1" to = "#evaluate('attributes.counter_#r#_#c#')#" index = "a">
                    <!--- Blok Satırları --->
                    <cfset add_wizard_block_row = wizard.add_wizard_block_row(
                                                                                wizard_block_id : add_wizard_block_id,
                                                                                block_column : c, 
                                                                                expense_center : '#evaluate("acc_control_#r#_#c#_#a#")#',
                                                                                expense_item : '#evaluate("bud_cat_control_#r#_#c#_#a#")#',
                                                                                activity_type : '#evaluate("exp_act_type_#r#_#c#_#a#")#',
                                                                                rate : '#evaluate("rate_#r#_#c#_#a#")#',
                                                                                description : '#evaluate("desc_#r#_#c#_#a#")#'
                                                                            )>
                </cfloop>
            </cfloop>

        </cfif>
    </cfloop>

</cftransaction>