<cfif fusebox.circuit eq 'myhome'>
	<cfset attributes.id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.id,accountKey:'wrk')>
</cfif>
<cfquery name="get_payment_request" datasource="#dsn#">
	SELECT 
    	ID, 
        PROCESS_STAGE, 
        CC_EMP, 
        SUBJECT, 
        DUEDATE, 
        TO_EMPLOYEE_ID, 
        AMOUNT, 
        MONEY, 
        DETAIL, 
        STATUS, 
        VALID_EMP, 
        PERIOD_ID, 
        VALID_1, 
        VALIDATOR_POSITION_CODE_1, 
        VALID_EMPLOYEE_ID_1, 
        VALID_2, 
        VALIDATOR_POSITION_CODE_2,
        VALID_EMPLOYEE_ID_2, 
        VALID_1_DETAIL, 
        VALID_2_DETAIL, 
        ACTION_ID, 
        RECORD_EMP, 
        RECORD_DATE, 
        UPDATE_EMP, 
        UPDATE_DATE,
		DEMAND_TYPE
    FROM 
	    CORRESPONDENCE_PAYMENT 
		<cfif isdefined('attributes.id')> 
    		WHERE 
    		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
        </cfif>
</cfquery>
<cfquery name="get_emp_pos" datasource="#dsn#">
	SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
</cfquery>
<cfset pos_code_list = valuelist(get_emp_pos.position_code)>
<!---İzinde olan kişilerin vekalet bilgileri alınıypr --->
<cfquery name="Get_Offtime_Valid" datasource="#dsn#">
	SELECT
		O.EMPLOYEE_ID,
		EP.POSITION_CODE
	FROM
		OFFTIME O,
		EMPLOYEE_POSITIONS EP
	WHERE
		O.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
		O.VALID = 1 AND
		#Now()# BETWEEN O.STARTDATE AND O.FINISHDATE
</cfquery>
<cfif Get_Offtime_Valid.recordcount>
	<cfset Now_Offtime_PosCode = ValueList(Get_Offtime_Valid.Position_Code)>
	<cfquery name="Get_StandBy_Position1" datasource="#dsn#"><!--- Asil Kisi Izinli ise ve 1.Yedek Izinli Degilse --->
		SELECT POSITION_CODE, CANDIDATE_POS_1 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_1 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#pos_code_list#">)
	</cfquery>
	<cfoutput query="Get_StandBy_Position1">
		<cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position1.Position_Code))>
	</cfoutput>
	<cfquery name="Get_StandBy_Position2" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek Izinli ise ve 2.Yedek Izinli Degilse --->
		SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_1 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_2 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#pos_code_list#">)
	</cfquery>
	<cfoutput query="Get_StandBy_Position2">
		<cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position2.Position_Code))>
	</cfoutput>
	<cfquery name="Get_StandBy_Position3" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek,2.Yedek Izinli ise ve 3.Yedek Izinli Degilse --->
		SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_1 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_2 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_3 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#pos_code_list#">)
	</cfquery>
	<cfoutput query="Get_StandBy_Position3">
		<cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position3.Position_Code))>
	</cfoutput>
</cfif>
<cf_catalystHeader>
<cfsavecontent variable="right">
	<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&print_type=184&action_id=#attributes.id#&iid=0</cfoutput>','page','');"><img src="/images/print.gif" title="<cf_get_lang dictionary_id ='57474.Yazdır'>"></a>
</cfsavecontent>
<cf_box>
	<cfform name="form_upd_payment_request" method="post" action="#request.self#?fuseaction=myhome.emptypopup_upd_payment_request_valid">
		<input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
		<input type="hidden" name="valid_1" id="valid_1" value="">
		<input type="hidden" name="valid_2" id="valid_2" value="">
		<cf_box_elements>
			<div class="col col-4 col-md-6 col-sm-8 col-xs-12" type="column" index="1" sort="true">
				<cfoutput>
					<div class="form-group">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='58859.Süreç'></label>
						<div class="col col-9 col-xs-12">
							<cf_workcube_process is_upd='0' select_value='#get_payment_request.process_stage#' process_cat_width='125' is_detail='1'>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
						<div class="col col-9 col-xs-12">
							<input type="text" value="#get_emp_info(get_payment_request.to_employee_id,0,0)#" readonly>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58820.Başlık'></label>
						<div class="col col-9 col-xs-12">
							<input type="text" value="#get_payment_request.subject#" readonly>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='31578.Avans Tipi'></label>
						<div class="col col-9 col-xs-12">
							<cfif len(get_payment_request.demand_type)>
								<cfquery name="get_demand_type" datasource="#dsn#">
									SELECT COMMENT_PAY FROM SETUP_PAYMENT_INTERRUPTION WHERE ISNULL(IS_DEMAND,0) = 1 AND ODKES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_payment_request.demand_type#">
								</cfquery>
								<input type="text" value="#get_demand_type.comment_pay#" readonly>
							<cfelse><input type="text" value="Avans" readonly>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'></label>
						<div class="col col-9 col-xs-12">
							<input type="text" value="#get_payment_request.DETAIL#" readonly>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57556.Bilgi'></label>
						<div class="col col-9 col-xs-12">
							<cfset emp_name="">
							<cfif len(get_payment_request.CC_EMP) and isnumeric(get_payment_request.CC_EMP)>
							<cfset EMP_ID=get_payment_request.CC_EMP>
							<cfset emp_name= get_emp_info(get_payment_request.CC_EMP,0,0)>
							</cfif>
							<input type="text" value="#emp_name#" readonly>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
						<div class="col col-9 col-xs-12">
							<input type="text" value="#dateformat(get_payment_request.duedate,dateformat_style)#" readonly>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'> *</label>
						<div class="col col-9 col-xs-12">
							<input type="text" value="#tlformat(get_payment_request.AMOUNT)#&nbsp;#get_payment_request.money#" readonly>
						</div>
					</div>
				</cfoutput>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_record_info query_name="get_payment_request">
			<cf_workcube_buttons is_upd='1'  is_delete ="0">
		</cf_box_footer>
	</cfform>
</cf_box>
