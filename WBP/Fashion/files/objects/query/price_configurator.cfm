<cfset textile_round=3>
<cf_xml_page_edit fuseact="textile.list_sample_request">
<cflock name="#CREATEUUID()#" timeout="60">

<cftransaction>
<cfloop from="1" to="#attributes.record_num#" index="i">
	<cfif Evaluate("attributes.type#i#") eq 0>
		<cfquery name="upd_supplier" datasource="#DSN3#">
			UPDATE TEXTILE_SR_SUPLIERS
			SET 
				REVIZE_QUANTITY=#filterNum(evaluate("attributes.r_q#i#"),textile_round)#,
				REVIZE_PRICE=#filterNum(evaluate("attributes.r_p#i#"),textile_round)#
			WHERE
				REQ_ID=#attributes.req_id# AND
				ID=#evaluate("attributes.row_id#i#")#
		</cfquery>
	<cfelse>
		<cfquery name="upd_process" datasource="#DSN3#">
			UPDATE TEXTILE_SR_PROCESS
			SET 
				REVIZE_PRICE=#filterNum(evaluate("attributes.r_p#i#"),textile_round)#
			WHERE
				REQUEST_ID=#attributes.req_id# AND
				ID=#evaluate("attributes.row_id#i#")#
		</cfquery>
	</cfif>
</cfloop>
<cfquery name="upd_sample_request" datasource="#DSN3#">
	UPDATE TEXTILE_SAMPLE_REQUEST
	SET
		COMMISSION=<cfif len(attributes.komisyon)>#filterNum(attributes.komisyon)#<cfelse>0</cfif>,
		GYG_FIRE=<cfif len(attributes.gyg_oran)>#filterNum(attributes.gyg_oran)#<cfelse>0</cfif>,
		CONFIG_PRICE_OTHER=<cfif len(attributes.sft_dv)>#filterNum(attributes.sft_dv,textile_round)#<cfelse>0</cfif>,
		CONFIG_PRICE_MONEY='#attributes.money#',
		CONFIG_STATUS=#attributes.status#
		<cfif isdefined("request_accept_stage_id") and len(request_accept_stage_id)>,REQ_STAGE=#request_accept_stage_id#</cfif><!---numune_onaylandi_asamasi--->
	WHERE
		REQ_ID=#attributes.req_id#
</cfquery>
  <cfquery name="del_money_obj_bskt" datasource="#dsn3#">
                DELETE FROM 
                   TEXTILE_SAMPLE_REQUEST_MONEY 
                WHERE 
                    ACTION_ID= #attributes.req_id#
            </cfquery>
           <cfloop from="1" to="#attributes.kur_say#" index="fnc_i">
            <cfquery name="add_money_obj_bskt" datasource="#dsn3#">
                INSERT INTO TEXTILE_SAMPLE_REQUEST_MONEY 
                (
                    ACTION_ID,
                    MONEY_TYPE,
                    RATE2,
                    RATE1,
                    IS_SELECTED
                )
                VALUES
                (
                     #attributes.req_id#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.hidden_rd_money_#fnc_i#')#">,
                    #filterNum(evaluate("attributes.txt_rate2_#fnc_i#"),textile_round)#,
                    #filterNum(evaluate("attributes.txt_rate1_#fnc_i#"))#,
                    <cfif evaluate("attributes.hidden_rd_money_#fnc_i#") is attributes.BASKET_MONEY>
                        1
                    <cfelse>
                        0
                    </cfif>					
                )
            </cfquery>
        </cfloop>
</cftransaction>
</cflock>


<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=textile.list_sample_request&event=config&req_id=#attributes.req_id#</cfoutput>';
</script>