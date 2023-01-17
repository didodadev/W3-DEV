<cfquery name="sms_cont" datasource="#dsn3#">
	SELECT 
    	SMS_CONT_ID, 
        CAMP_ID, 
        SMS_BODY, 
        IS_SENT, 
        SMS_HEAD,
        SENDED_TARGET_MASS, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP
    FROM 
    	CAMPAIGN_SMS_CONT 
    WHERE 
    	SMS_CONT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sms_cont_id#">
</cfquery>
<cfinclude template="../query/get_campaign.cfm">
<cfinclude template="../query/get_cons.cfm">
<cfinclude template="../query/get_pars.cfm">
<cfset member_id = valuelist(get_cons.consumer_id)>
<cfif len(member_id)>
    <cfset member_type='consumer'>
<cfelse>
    <cfset member_id = valuelist(get_pars.partner_id)>
    <cfset member_type='partner'>
</cfif>
<cfset member_id = len(member_id)?listGetAt(member_id, 1):1>
<cfset sms_text=wrk_sms_body_replace(sms_body:sms_cont.sms_body,member_type:'#member_type#',member_id:#member_id#,paper_type:"",paper_id:"")>
<cfset getComponent = createObject('component', 'WEX.cti.cfc.verimor')>
<cfset getCallInformations = getComponent.getCallInformations()>
<cf_box title="#getLang('','SMS İçeriği','58610')#" popup_box="1">
    <cf_box_elements>
        <cfoutput>
            <div class="form-group col col-12" id="">
                <label class="col col-3 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'></label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                #sms_cont.SMS_HEAD#
                </div>
            </div>
            <div class="form-group col col-12" id="">
                <label class="col col-3 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='46789.Kimden'></label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    +#getCallInformations.SMS_USERNAME#
                </div>
            </div>
            <div class="form-group col col-12" id="item-email-body">
                <p class="bold">#sms_text#</p>
            </div>
        </cfoutput>
    </cf_box_elements>
</cf_box>