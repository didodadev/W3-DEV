<cf_date tarih="attributes.copy_date">
<cflock name="#CREATEUUID()#" timeout="20">
<cftransaction>
    <cfscript>
    add_record = createObject("component", "V16.account.cfc.get_financial_audits");
    add_record.dsn2 = dsn2;
    if(isdefined("attributes.rec_id") and len(attributes.rec_id)){
             upd_record = add_record.upd_table_copies_fnc(
                financial_table_id : attributes.rec_id,
                name : attributes.copy_name,
                is_ifrs : attributes.table_code_type,
                process_stage : attributes.process_stage,
                copy_date : attributes.copy_date,
                emp_id : attributes.emp_id 
            );
            add_record = attributes.rec_id;
    }
    else{
        add_record = add_record.add_table_copies_fnc(
        name : attributes.copy_name,
        is_ifrs : attributes.table_code_type,
        process_stage : attributes.process_stage,
        copy_date : attributes.copy_date,
        emp_id : attributes.emp_id 
        );
    }
    </cfscript>
</cftransaction>
</cflock>
<script>
	window.location.href= "<cfoutput>#request.self#?fuseaction=finance.audit_table_copies&event=upd&rec_id=#add_record#</cfoutput>";
</script>