
<cfinclude template="../query/get_payment_request.cfm">
<cfparam  name="attributes.modal_id" default="">
<cfquery name="get_demand_type" datasource="#dsn#">
	SELECT * FROM SETUP_PAYMENT_INTERRUPTION WHERE ISNULL(IS_DEMAND,0) = 1
</cfquery>
<cf_box title="#getLang('','','53503')#" add_href="openBoxDraggable('#request.self#?fuseaction=ehesap.popup_add_payment_request')" print_href="index.cfm?fuseaction=ehesap.list_payment_requests&event=upd&id=115&is_print=1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform action="#request.self#?fuseaction=ehesap.emptypopup_upd_payment_request" name="form_upd_payment_request" method="POST">
        <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
        <input type="hidden" name="modal_id" id="modal_id" value="<cfoutput>#attributes.modal_id#</cfoutput>">
        <cf_box_elements>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-process_stage">
                    <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='58859.Süreç'></label>
                    <div class="col col-8 col-xs-12">
                        <cf_workcube_process is_upd='0' select_value='#get_payment_request.process_stage#' process_cat_width='150' is_detail='1'>	
                    </div>
                </div>
                <div class="form-group" id="item-subject">
                    <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57480.Konu'></label>
                    <div class="col col-8 col-xs-12">
                        <cfif isdefined('attributes.is_print')>
                            <cfoutput>#get_payment_request.subject#</cfoutput>
                        <cfelse>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='53432.konu girmelisiniz'></cfsavecontent>
                            <cfinput type="text" name="subject" id="subject" style="width:250px;" required="Yes" message="#message#" value="#get_payment_request.subject#">
                        </cfif>
                    </div>
                </div>
                <div class="form-group" id="item-demand_type">
                    <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='31578.Avans Tipi'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="demand_type" id="demand_type">
                            <cfoutput query="get_demand_type">
                                <option value="#odkes_id#" <cfif get_payment_request.demand_type eq odkes_id>selected</cfif>>#comment_pay#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-priority">
                    <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57485.Öncelik'></label>
                    <div class="col col-8 col-xs-12">
                        <cfinclude template="../query/get_priority.cfm">
                        <cfif isdefined('attributes.is_print')>
                            <cfoutput>#get_priority.priority#</cfoutput>
                        <cfelse>
                                <select name="priority" id="priority" style="width:250px;">
                                    <cfoutput query="get_priority">
                                    <option value="#get_priority.priority_id#"<cfif #get_payment_request.priority# eq #get_priority.priority_id# >selected</cfif>>#priority#
                                    </cfoutput>
                                </select>
                        </cfif>
                    </div>
                </div>
                <div class="form-group" id="item-due_date">
                    <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57640.Vade'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfif isdefined('attributes.is_print')>
                                <cfoutput>#dateformat(get_payment_request.duedate,dateformat_style)#</cfoutput>
                            <cfelse>
                                <cfsavecontent variable="alert"><cf_get_lang dictionary_id ='54164.İşlem tarihi yanlış'></cfsavecontent>
                                <cfinput validate="#validate_style#" required="Yes" message="#alert#" type="text" name="due_date" id="due_date"  value="#dateformat(get_payment_request.duedate,dateformat_style)#"style="width:250px;">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="due_date"></span>
                            </cfif>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-pay_method">
                    <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='58516.Ödeme Tipi'></label>
                    <div class="col col-8 col-xs-12">
                        <cfquery name="PAY_METHODS" datasource="#DSN#">
                            SELECT 	
                                SP.* 
                            FROM 
                                SETUP_PAYMETHOD SP,
                                SETUP_PAYMETHOD_OUR_COMPANY SPOC
                            WHERE
                                SP.PAYMETHOD_STATUS = 1
                                AND SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
                                AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                        </cfquery>
                        <cfif isdefined('attributes.is_print')>
                            <cfoutput>#PAY_METHODS.PAYMETHOD#</cfoutput>
                        <cfelse>
                            <select name="pay_method" id="pay_method"  style="width:250px;">
                                <cfoutput query="PAY_METHODS">
                                    <option value="#PAYMETHOD_ID#" <cfif get_payment_request.paymethod_id eq PAYMETHOD_ID> Selected </cfif>>#PAYMETHOD#</option>										
                                </cfoutput>
                            </select>
                        </cfif>
                    </div>
                </div>
                <div class="form-group" id="item-employee_name">
                    <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                    <div class="col col-8 col-xs-12">
                        <cfif isdefined('attributes.is_print')>
                            <cfoutput>#get_emp_info(get_payment_request.TO_EMPLOYEE_ID,0,0)#</cfoutput>
                        <cfelse>
                            <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_payment_request.TO_EMPLOYEE_ID#</cfoutput>">
                            <input type="text" name="employee_name" id="employee_name" style="width:250px;" value="<cfoutput>#get_emp_info(get_payment_request.TO_EMPLOYEE_ID,0,0)#</cfoutput>" readonly>
                        </cfif>
                    </div>
                </div>
                <div class="form-group" id="item-employee_in_out_id">
                    <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='54066.Giriş - Çıkış Kaydı'></label>
                    <div class="col col-8 col-xs-12">
                        <cfquery name="GET_IN_OUTS" datasource="#DSN#">
                            SELECT 
                                EIO.IN_OUT_ID,E.EMPLOYEE_NAME,E.EMPLOYEE_SURNAME,B.BRANCH_NAME 
                            FROM 
                                EMPLOYEES_IN_OUT EIO,
                                EMPLOYEES E,
                                BRANCH B
                            WHERE 
                                E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
                                B.BRANCH_ID = EIO.BRANCH_ID AND
                                EIO.EMPLOYEE_ID = #get_payment_request.TO_EMPLOYEE_ID# AND 
                                (EIO.FINISH_DATE IS NULL OR EIO.FINISH_DATE >= #CREATEODBCDATETIME(now())#)
                        </cfquery>
                        <cfif GET_IN_OUTS.recordcount gt 0>
                            <cfif isdefined('attributes.is_print')>
                                <cfoutput>#GET_IN_OUTS.EMPLOYEE_NAME# #GET_IN_OUTS.EMPLOYEE_SURNAME# - #GET_IN_OUTS.BRANCH_NAME#</cfoutput>
                            <cfelse>
                                <select name="employee_in_out_id" id="employee_in_out_id" style="width:250px;">
                                    <cfoutput query="GET_IN_OUTS">
                                        <option value="#in_out_id#" <cfif len(get_payment_request.in_out_id) and get_payment_request.in_out_id eq in_out_id>selected="selected"</cfif>>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - #BRANCH_NAME#</option>
                                    </cfoutput>
                                </select>
                            </cfif>
                        </cfif>
                    </div>
                </div>
                <div class="form-group" id="item-AMOUNT">
                    <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57673.Tutar'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfquery name="GET_MONEYS" datasource="#DSN#">
                                SELECT MONEY_ID,MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID#
                            </cfquery>
                            <cfif isdefined('attributes.is_print')>
                                <cfoutput>#TLFormat(get_payment_request.AMOUNT)#&nbsp;#get_moneys.money#</cfoutput>
                            <cfelse>
                                <cfinput type="text" name="AMOUNT" id="AMOUNT" style="width:173px;" value="#TLFormat(get_payment_request.AMOUNT)#"  onkeyup="return(FormatCurrency(this,event));">						
                                <span class="input-group-addon width">
                                <select name="MONEY" id="MONEY" style="width:75px;">
                                    <cfoutput query="get_moneys">
                                        <option value="#money#" <cfif money eq get_payment_request.MONEY>SELECTED</cfif>>#money#</option>
                                    </cfoutput>
                                </select>
                                </span>
                            </cfif>	
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-DETAIL">
                    <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                    <div class="col col-8 col-xs-12">
                        <cfif isdefined('attributes.is_print')>
                            <cfoutput>#get_payment_request.DETAIL#</cfoutput>
                        <cfelse>
                            <textarea name="detail" id="detail"  style="width:250px;height:40px;"><cfoutput>#get_payment_request.DETAIL#</cfoutput></textarea>
                        </cfif>
                    </div>
                </div>
                <cfif len(get_payment_request.validator_position_code_1) and not len(get_payment_request.valid_1)>
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
                    <cfset offtime_pos_code_list = valuelist(Get_Offtime_Valid.position_code)>
                    <cfset extra_pos_code = ''>
                    <cfif listfind(offtime_pos_code_list,get_payment_request.validator_position_code_1)>
                        <!--- Eğer 1.amir izindeyse 1.amirin yedekleri bulunuyor --->
                        <cfquery name="Get_StandBy_Position_Other_Offtime" datasource="#dsn#">
                            SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 ,CANDIDATE_POS_3 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE = #get_payment_request.validator_position_code_1#
                        </cfquery>
                        <cfif len(Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_1) and not listfind(offtime_pos_code_list,Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_1)>
                            <cfset extra_pos_code = Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_1>
                        <cfelseif len(Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2) and not listfind(offtime_pos_code_list,Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2)>
                            <cfset extra_pos_code = Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2>
                        <cfelseif len(Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2) and not listfind(offtime_pos_code_list,Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2)>
                            <cfset extra_pos_code = Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2>
                        </cfif>
                    </cfif>
                    <div class="form-group" id="item-position_code_1">
                        <label class="col col-4 col-xs-12 txtbold">1.<cf_get_lang dictionary_id ='53938.Amir Onay'></label>
                        <label class="col col-8 col-xs-12">
                            <cfoutput>#get_emp_info(get_payment_request.validator_position_code_1,1,0)# <cfif len(extra_pos_code)>- #get_emp_info(extra_pos_code,1,0)#</cfif></cfoutput><cf_get_lang_main no ='203.Onay Bekliyor'>
                        </label>
                    </div>
                <cfelseif len(get_payment_request.validator_position_code_1) and len(get_payment_request.valid_1) and get_payment_request.valid_1 eq 1>
                    <div class="form-group" id="item-position_code_1">
                        <label class="col col-4 col-xs-12 txtbold">1. <cf_get_lang dictionary_id ='53938.Amir Onay'></label>
                        <label class="col col-8 col-xs-12">
                            <cfoutput>#get_emp_info(get_payment_request.validator_position_code_1,1,0)#</cfoutput><cf_get_lang dictionary_id='58699.Onaylandı'>
                        </label>
                    </div>
                    <div class="form-group" id="item-valid_1_detail">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <label class="col col-8 col-xs-12">
                            <cfoutput>#get_payment_request.valid_1_detail#</cfoutput>
                        </label>
                    </div>
                <cfelseif len(get_payment_request.validator_position_code_1) and len(get_payment_request.valid_1) and get_payment_request.valid_1 eq 0>
                    <div class="form-group" id="item-position_code_2">
                        <label class="col col-4 col-xs-12 txtbold">1.<cf_get_lang dictionary_id ='53938.Amir Onay'></label>
                        <label class="col col-8 col-xs-12">
                            <cfoutput>#get_emp_info(get_payment_request.validator_position_code_1,1,0)#</cfoutput><cf_get_lang dictionary_id='57617.Reddedildi'>
                        </label>
                    </div>
                    <div class="form-group" id="item-valid_1_detail">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <label class="col col-8 col-xs-12">
                            <cfoutput>#get_payment_request.valid_1_detail#</cfoutput>
                        </label>
                    </div>
                    </cfif>
                <cfif len(get_payment_request.validator_position_code_2) and not len(get_payment_request.valid_2)>
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
                    <cfset offtime_pos_code_list = valuelist(Get_Offtime_Valid.position_code)>
                    <cfset extra_pos_code = ''>
                    <cfif listfind(offtime_pos_code_list,get_payment_request.validator_position_code_2)>
                        <!--- Eğer 1.amir izindeyse 1.amirin yedekleri bulunuyor --->
                        <cfquery name="Get_StandBy_Position_Other_Offtime" datasource="#dsn#">
                            SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 ,CANDIDATE_POS_3 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE = #get_payment_request.validator_position_code_2#
                        </cfquery>
                        <cfif len(Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_1) and not listfind(offtime_pos_code_list,Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_1)>
                            <cfset extra_pos_code = Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_1>
                        <cfelseif len(Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2) and not listfind(offtime_pos_code_list,Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2)>
                            <cfset extra_pos_code = Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2>
                        <cfelseif len(Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2) and not listfind(offtime_pos_code_list,Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2)>
                            <cfset extra_pos_code = Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2>
                        </cfif>
                    </cfif> 
                    <div class="form-group" id="item-position_code_2">
                        <label class="col col-4 col-xs-12 txtbold">2.<cf_get_lang dictionary_id ='53938.Amir Onay'></label>
                        <label class="col col-8 col-xs-12">
                            <cfoutput>#get_emp_info(get_payment_request.validator_position_code_2,1,0)# <cfif len(extra_pos_code)>- #get_emp_info(extra_pos_code,1,0)#</cfif></cfoutput><cf_get_lang dictionary_id='57615.Onay Bekliyor'> !
                        </label>
                    </div>
                    <cfelseif len(get_payment_request.validator_position_code_2) and get_payment_request.valid_2 eq 1> 
                    <div class="form-group" id="item-position_code_2">
                        <label class="col col-4 col-xs-12 txtbold">2.<cf_get_lang dictionary_id ='53938.Amir Onay'></label>
                        <label class="col col-8 col-xs-12">
                            <cfoutput>#get_emp_info(get_payment_request.validator_position_code_2,1,0)#</cfoutput><cf_get_lang dictionary_id='58699.Onaylandı'>
                        </label>
                    </div>
                    <div class="form-group" id="item-valid_2_detail">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id ='57629. Açıklama'></label>
                        <label class="col col-8 col-xs-12">
                            <cfoutput>#get_payment_request.valid_2_detail#</cfoutput>
                        </label>
                    </div>
                    <cfelseif len(get_payment_request.validator_position_code_2) and get_payment_request.valid_2 eq 0>
                    <div class="form-group" id="item-validator_position_code_2">
                        <label class="col col-4 col-xs-12 txtbold">2.<cf_get_lang dictionary_id ='53938.Amir Onay'></label>
                        <label class="col col-8 col-xs-12">
                            <cfoutput>#get_emp_info(get_payment_request.validator_position_code_2,1,0)#</cfoutput><cf_get_lang dictionary_id ='57617.Reddedildi'>
                        </label>
                    </div>
                    <div class="form-group" id="item-valid_2_detail">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <label class="col col-8 col-xs-12">
                            <cfoutput>#get_payment_request.valid_2_detail#</cfoutput>
                        </label>
                    </div>
                    </cfif>
                <cfif not isdefined('attributes.is_print')>
                        <div class="form-group" id="item-acceptit">
                        <label class="col col-4 col-xs-12 txtbold"><span class="hide"><cf_get_lang dictionary_id='53121.Kabul'></span></label>
                        <div class="col col-8 col-xs-12">
                            <div class="col col-6 col-xs-12">
                            <input  type="button"	name="deny" id="deny" value="<cf_get_lang dictionary_id='29537.Red'>" onClick="window.location.href='<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_deny_payment_request&payment_id=#id#&upd_id=0</cfoutput>';">
                            </div>
                            <div class="col col-6 col-xs-12">
                                <input  type="button"	name="acceptit" id="acceptit" value="<cf_get_lang dictionary_id='53121.Kabul'>" onClick="onay_islemi();">
                            </div>
                        </div>
                    </div>
                </cfif>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <div class="col col-6">
                <cf_record_info query_name="get_payment_request">
            </div>
            <div class="col col-6">
                <cf_workcube_buttons is_upd='1' add_function='UnformatFields()' delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_payment_request&id=#attributes.id#&employee_id=#get_payment_request.TO_EMPLOYEE_ID#&modal_id=#attributes.modal_id#'>
            </div>
        
        </cf_box_footer>
            
    </cfform>
</cf_box>
<cfif isdefined('attributes.is_print')>
	<script type="text/javascript">
		function waitfor(){
            <cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
		}	
		setTimeout("waitfor()",3000);
		window.print();
	</script>
</cfif>
<script type="text/javascript">
	function UnformatFields()
	{
		document.getElementById('AMOUNT').value = filterNum(document.getElementById('AMOUNT').value);
	}
	
	function onay_islemi()
	{
		x = document.getElementById('employee_in_out_id').selectedIndex;
		if (document.form_upd_payment_request.employee_in_out_id[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id ='54067.Onay İşlemi İçin Bir Giriş-Çıkış Seçmelisiniz'>!");
			return false;
		}
		else
		{
			my_id = document.form_upd_payment_request.employee_in_out_id[x].value;
			window.location.href='<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_deny_payment_request&payment_id=#attributes.id#&upd_id=1&employee_in_out_id=</cfoutput>'+my_id;
		}	
	}
    $( ".catalyst-plus" ).click(function() {
        window.close();
        });
</script>
