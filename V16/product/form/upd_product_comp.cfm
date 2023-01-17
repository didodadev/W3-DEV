<cfquery name="GET_PRO_COMP" datasource="#DSN3#">
	SELECT
        DETAIL,
        COMPETITIVE_ID,
		#dsn#.#dsn#.Get_Dynamic_Language(COMPETITIVE_ID,'#session.ep.language#','PRODUCT_COMP','COMPETITIVE',NULL,NULL,COMPETITIVE) AS COMPETITIVE
    FROM 
        PRODUCT_COMP
       WHERE COMPETITIVE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cfquery name="GET_PRO_PERM_POS" datasource="#DSN3#">
	SELECT STATUS, POSITION_CODE AS POS_CODE FROM PRODUCT_COMP_PERM WHERE COMPETITIVE_ID = #attributes.id#
</cfquery>
<cfquery name="GET_PRO_PERM_PAR" datasource="#DSN3#">
	SELECT STATUS, PARTNER_ID FROM PRODUCT_COMP_PERM WHERE COMPETITIVE_ID = #attributes.id#
</cfquery>
<cfset attributes.competitive_id = attributes.id>
<cfif isDefined("session.product.emps") and not isDefined("attributes.session_delete")>
	<cfset structdelete(session.product,"emps")>
</cfif>
<cfif isDefined("session.product.pars") and not isDefined("attributes.session_delete")>
	<cfset structdelete(session.product,"pars")>
</cfif>
<cfif not isDefined("session.product.emps")>
	<cfset session.product.emps=arraynew(1)>
	<cfif get_pro_perm_pos.recordcount>
		<cfloop query="get_pro_perm_pos">
			<cfset uzun = arraylen(session.product.emps)>
			<cfset session.product.emps[uzun+1]= pos_code>
		</cfloop>
	</cfif>
</cfif>
<cfif not isDefined("session.product.pars")>
	<cfset session.product.pars=arraynew(1)>
	<cfif get_pro_perm_par.recordcount>
		<cfloop query="get_pro_perm_par">
			<cfset uzun = arraylen(session.product.pars)>
			<cfset session.product.pars[uzun+1]= partner_id>
		</cfloop>
	</cfif>
</cfif>
<cfparam  name="attributes.modal_id" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Fiyat Yetki Tanımları','37018')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="upd_product_comp" action="#request.self#?fuseaction=product.emptypopup_upd_product_comp&ID=#attributes.competitive_id#" method="post">
            <input type="hidden" id="ID" name="ID" value="<cfoutput>#attributes.ID#</cfoutput>" />
            <cfinput type="hidden" name="modal_id" id="modal_id"  value="#attributes.modal_id#">
            <cf_box_elements>
                <div class="col col-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-PRO_COMP">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58233.Tanım'>*</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='37420.rekabet tanımı girmelisiniz'></cfsavecontent>
                                <cfinput type="Text" name="PRO_COMP" value="#get_pro_comp.COMPETITIVE#"  required="yes" message="#message#"style="width:200px;" maxlength="50">
                                <span class="input-group-addon">
                                    <cf_language_info 
                                        table_name="PRODUCT_COMP" 
                                        column_name="COMPETITIVE" 
                                        column_id_value="#attributes.id#" 
                                        maxlength="500" 
                                        datasource="#DSN3#" 
                                        column_id="COMPETITIVE_ID" 
                                        control_type="0">
                                </span>
                            </div> 
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-9 col-xs-12">
                            <textarea name="detail" id="detail" style="width:200px;height:60px;"><cfoutput>#get_pro_comp.detail#</cfoutput></textarea>
                        </div>
                    </div>
                    <input type="hidden" name="position_code" id="position_code" value="">
                    <div class="form-group scrollContent scroll-x2" id="gizli1">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='37316.Sorumlular'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                            <cfsavecontent variable="txt_1"><cf_get_lang dictionary_id='37316.Sorumlular'></cfsavecontent>
                            <cf_workcube_to_cc 
                                is_update="1" 
                                to_dsp_name="#txt_1#" 
                                form_name="upd_product_comp" 
                                str_list_param="1" 
                                action_dsn="#DSN3#"
                                str_action_names = "PARTNER_ID TO_PAR,POSITION_CODE TO_POS_CODE"
                                str_alias_names = "TO_PAR,TO_POS_CODE"
                                action_table="PRODUCT_COMP_PERM"
                                action_id_name="COMPETITIVE_ID"
                                data_type="2"
                                action_id="#attributes.ID#">
                            </div>
                        </div>
                    </div>
                </div>
            
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-6">
                    <cf_record_info query_name="get_pro_comp">
                </div>
                <div class="col col-6">
                    <cf_workcube_buttons is_upd='1' is_delete="0">
                </div>
            </cf_box_footer>
        
        </cfform>
    </cf_box>
</div>
