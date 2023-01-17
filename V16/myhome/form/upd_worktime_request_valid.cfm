<cfset fuseaction = listFirst(attributes.fuseaction,".")>
<cfif fuseaction eq 'myhome'>
	<cfset attributes.ewt_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.ewt_id,accountKey:'wrk')>
<cfelse>
	<cfset attributes.ewt_id = attributes.ewt_id>
</cfif>
<cfquery name="get_payment_request" datasource="#dsn#">
    SELECT
        EMPLOYEES_EXT_WORKTIMES.*,
        PTR.STAGE
    FROM
        EMPLOYEES_EXT_WORKTIMES	
        LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = EMPLOYEES_EXT_WORKTIMES.process_stage
      WHERE
        EWT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ewt_id#">
</cfquery>
<style>
	p{
		text-align:right;
		padding:5px;
	}
	.date{
		color:#555d63;
		padding:10px;
		padding-left:5px;
		font-size:13px;
	}
</style>

<cf_catalystHeader>
<cfsavecontent variable="title"><cf_get_lang dictionary_id = "38224.Fazla mesai"> <cf_get_lang dictionary_id = "57771.Detay"></cfsavecontent>
<div class="col col-9 col-md-8 col-sm-12 col-xs-12">
<cf_box title = "#title#" closable="0">
    <cfform name = "worktime_valid" method="post" action="">
        <input type="hidden" name="EWT_ID" id="EWT_ID" value="<cfoutput>#attributes.EWT_ID#</cfoutput>">
        <input type="hidden" name="valid_1" id="valid_1" value="">
        <input type="hidden" name="valid_2" id="valid_2" value="">
        <cf_box_elements>
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
        <cfoutput query="get_payment_request">
            <div class="form-group" id="item-process">
                <label class="col col-2 col-xs-12"><cf_get_lang dictionary_id = '58859.Süreç'></label>
                <div class="col col-4 col-xs-12">    
                    <cf_workcube_process select_value ="#process_stage#" is_detail='1' is_upd="0">    
                </div>
            </div>
            <div class="form-group" id="item-employee_id">
                <label class="col col-2 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                <div class="col col-4 col-xs-12">
                    <cfset attributes.employee_id=employee_id> 
                    <input name="EMPLOYEE" id="EMPLOYEE" type="text"required="yes" value="#get_emp_info(employee_id,0,0)#" readonly>       
                </div>
            </div>
            <div class="form-group" id="item-fm">
                <label class="col col-2 col-xs-12"><cf_get_lang dictionary_id ='31547.Fazla Mesai'></label>
                <div class="col col-4 col-xs-12">
                    <input name="FM" id="FM" type="text" required="yes"  value="#dateformat(START_TIME,dateformat_style)# (#TIMEFORMAT(START_TIME,timeformat_style)# - #TIMEFORMAT(END_TIME,timeformat_style)#)" readonly>       
                </div>
            </diV>
            <div class="form-group" id="item-diff">
                <label class="col col-2 col-xs-12"><cf_get_lang dictionary_id ='31471.Fark'></label>
                <div class="col col-4 col-xs-12">
                    <input name="diff" id="diff" type="text" required="yes"  value="#datediff("n",START_TIME,END_TIME)# (dk)" readonly>       
                </div>
            </div>
            <div class="form-group" id="item-diff">
                <label class="col col-2 col-xs-12"><cf_get_lang dictionary_id='57490.Gün'></label>
                <div class="col col-4 col-xs-12">
                    <input name="diff" id="diff" type="text" required="yes"  value="<cfif day_type eq 0><cf_get_lang dictionary_id='31474.Normal Gün'><cfelseif day_type eq 1><cf_get_lang dictionary_id='31472.Hafta Sonu'><cfelseif day_type eq 2><cf_get_lang dictionary_id='31473.Resmi Tatil'></cfif>" readonly>       
                </div>
            </div>
           <div class="form-group" id="item-detail">
                <label class="col col-2 col-xs-12"><cf_get_lang dictionary_id='57771.detay'></label>
                <div class="col col-4 col-xs-12">
                    <textarea name="detay" style="height:60px;" readonly>
                        #valid_detail#   
                    </textarea>
                </div>
            </div>
        </cfoutput>
    </div>
</cf_box_elements>
        <cf_box_footer>
            <div class="col col-6"><cf_record_info query_name="get_payment_request"></div>
            <div class="col col-6"><cf_workcube_buttons is_upd='1' is_delete="0"></div>
        </cf_box_footer>
    </cfform>
</cf_box>
</div>

<div class="col col-3 col-md-4 col-sm-12 col-xs-12">
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='51044.Hakedişler'></cfsavecontent>
    <cf_box title="#message#" closable="0" collapsable="0">
		<label class="col col-6 date text-left">
			<cf_get_lang dictionary_id="58472.Dönem">
		</label>
		<label class="col col-6 date text-right"><cfoutput>#session.ep.period_year#</cfoutput></label>
		
		<cfinclude  template="../display/offtimes_dashboard.cfm">
	</cf_box>
</div>

