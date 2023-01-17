<cfsavecontent variable="txt_2"><cf_get_lang no='6.Taraflar'> (<cf_get_lang_main no='1473.Partner'>)</cfsavecontent>
<cf_workcube_to_cc 
    is_update="1" 
    cc_dsp_name="#txt_2#" 
    form_name="upd_cont" 
    str_list_param="2,3" 
    action_dsn="#DSN3#"
    str_action_names="COMPANY_PARTNER AS CC_PAR,CONSUMERS AS CC_CON"
    action_table="RELATED_CONTRACT"
    action_id_name="CONTRACT_ID"
    action_id="#attributes.contract_id#"
    data_type="1"
    str_alias_names="">	
<br /><br />
<cfsavecontent variable="txt_1"><cf_get_lang no='6.Taraflar'> (<cf_get_lang_main no='164.Çalışan'>)</cfsavecontent>
<cf_workcube_to_cc 
    is_update="1" 
    to_dsp_name="#txt_1#" 
    form_name="upd_cont" 
    str_list_param="1" 
    action_dsn="#DSN3#"
    str_action_names="EMPLOYEE AS TO_POS"
    action_table="RELATED_CONTRACT"
    action_id_name="CONTRACT_ID"
    action_id="#attributes.contract_id#"
    data_type="1"
    str_alias_names="">	
