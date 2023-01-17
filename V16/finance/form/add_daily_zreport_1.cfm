<cfquery name="GET_CASH_POS" datasource="#DSN3#">
	SELECT * FROM POS_EQUIPMENT WHERE IS_STATUS = 1 <cfif session.ep.isBranchAuthorization>AND BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#</cfif> ORDER BY EQUIPMENT
</cfquery>

<cf_basket_form>
	<cfoutput>
        <div id="hidden_fields_zreport" ></div>  
        <input type="hidden" name="form_action_address" id="form_action_address" value="#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_daily_zreport">
        <input type="hidden" name="is_cash" id="is_cash" value="0">
        <input type="hidden" name="is_pos" id="is_pos" value="0">
        <input type="hidden" name="x_show_info" id="x_show_info" value="#x_show_info#">	
        <input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
        <input type="hidden" name="search_process_date" id="search_process_date" value="invoice_date">
    </cfoutput>
    <cf_box_elements>
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
            <div class="form-group require" id="item-process_cat">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'>*</label>
                <div class="col col-8 col-sm-12">
                    <cf_workcube_process_cat>
                </div>                
            </div> 
            <div class="form-group require" id="item-pos_cash_id">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='39344.Yazar Kasa'>*</label>
                <div class="col col-8 col-sm-12">
                    <select name="pos_cash_id" id="pos_cash_id" style="width:140px;" onchange="change_emp()">
                        <cfoutput query="get_cash_pos">
                            <option value="#pos_id#" <cfif session.ep.isBranchAuthorization and branch_id eq ListGetAt(session.ep.user_location,2,"-")>selected</cfif>>#equipment#</option>
                        </cfoutput>
                    </select>
                </div>                
            </div> 
        </div>
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
            <div class="form-group require" id="item-invoice_date">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30631.Tarih'>*</label>
                <div class="col col-8 col-sm-12">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih Giriniz'>!</cfsavecontent>
                        <cfinput type="text" name="invoice_date" style="width:90px;" required="Yes" message="#message#" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" maxlength="10">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="invoice_date"></span>
                    </div>
                </div>                
            </div> 
            <div class="form-group require" id="item-employee_id">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='54577.Kasiyer'>*</label>
                <div class="col col-8 col-sm-12">
                    <div class="input-group">
                        <input type="hidden" name="employee_id" id="employee_id" value="">
                        <input type="text" name="employee_name" id="employee_name" value="" style="width:140px;" readonly>
                        <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=form_basket.employee_name&field_emp_id=form_basket.employee_id</cfoutput>','list');"><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734.Seçiniz'>" border="0" align="absmiddle"></span>
                    </div>
                </div>                
            </div> 
        </div>
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
            <cfif session.ep.isBranchAuthorization>				
                <cfset search_dep_id = listgetat(session.ep.user_location,1,'-')>
                <cfquery name="GET_NAME_OF_DEP" datasource="#DSN#">
                    SELECT
                        DEPARTMENT_HEAD,
                        BRANCH_ID
                    FROM
                        DEPARTMENT
                    WHERE
                        DEPARTMENT_ID = #search_dep_id#	AND 
                        IS_STORE <> 2
                </cfquery>
                <cfquery name="get_loc" datasource="#DSN#">
                    SELECT LOCATION_ID FROM STOCKS_LOCATION WHERE DEPARTMENT_ID=#search_dep_id# AND PRIORITY = 1
                </cfquery>
                <cfif get_loc.recordcount and get_name_of_dep.recordcount>
                    <cfset txt_department_name = get_name_of_dep.department_head>
                <cfelse>
                    <cfset txt_department_name = "" >
                </cfif>	
                <div class="form-group require" id="item-note">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58763.Depo'>*</label>
                    <div class="col col-8 col-sm-12">
                        <div class="input-group">
                            <input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#listgetat(session.ep.user_location,2,'-')#</cfoutput>">
                            <input type="hidden" name="department_id" id="department_id" value="<cfoutput>#listgetat(session.ep.user_location,1,'-')#</cfoutput>">
                            <input type="hidden" name="location_id" id="location_id" value="<cfoutput>#get_loc.location_id#</cfoutput>">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='33242.Depo Girmelisiniz'> !</cfsavecontent>
                            <cfinput type="text" name="department_name" readonly="yes" style="width:150px;" value="#txt_department_name#" required="yes" message="#message#">
                            <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=form_basket&field_location_id=location_id&field_name=department_name&field_id=department_id&branch_id=branch_id&is_no_sale=1&dsp_service_loc=1<cfif session.ep.isBranchAuthorization>&is_branch=1</cfif></cfoutput>','list');"><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734.Seçiniz'>" border="0" align="absmiddle"></span>
                        </div>	
                    </div>
                </div>
            <cfelse>
                <div class="form-group require" id="item-note">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58763.Depo'>*</label>
                    <div class="col col-8 col-sm-12">
                        <div class="input-group">
                            <input type="hidden" name="branch_id" id="branch_id" value="">
                            <input type="hidden" name="department_id" id="department_id" value="">
                            <input type="hidden" name="location_id" id="location_id" value="">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='33242.Depo Girmelisiniz'>!</cfsavecontent>
                            <cfinput type="text" name="department_name" readonly="yes" style="width:150px;" required="yes" message="#message#">
                            <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=form_basket&field_location_id=location_id&field_name=department_name&field_id=department_id&branch_id=branch_id&is_no_sale=1&dsp_service_loc=1<cfif session.ep.isBranchAuthorization>&is_branch=1</cfif></cfoutput>','list');"><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734.Seçiniz'>" border="0" align="absmiddle"></span>
                        </div>	
                    </div>
                </div>
            </cfif> 
            <div class="form-group require" id="item-invoice_number">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57880.Belge No'></label>
                <div class="col col-8 col-sm-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='54868.Belge No Girmelisiniz'>!</cfsavecontent>
                    <cfinput type="text" maxlength="50" name="invoice_number" value="" required="yes" message="#message#" style="width:90px;">
                </div>                
            </div>
        </div>
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
            <div class="form-group require" id="item-note">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                <div class="col col-8 col-sm-12">
                    <textarea name="note" id="note" style="width:135px;height:45px;"></textarea>
                </div>                
            </div> 
        </div>
    </cf_box_elements>
    <cf_box_footer>
        <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
    </cf_box_footer>
</cf_basket_form>

<script type="text/javascript">
	change_emp();
	function change_emp()
	{
		if(document.getElementById('pos_cash_id').value != '')
		{
			var new_sql = wrk_safe_query("get_cashier",'dsn3',0,document.getElementById('pos_cash_id').value);
			if(new_sql.recordcount && new_sql.CASHIER1 != '')
			{
				document.getElementById('employee_id').value = new_sql.CASHIER1;
				var new_sql_2 = wrk_safe_query("obj_get_emp_name",'dsn',0,new_sql.CASHIER1);
				document.getElementById('employee_name').value = new_sql_2.EMPLOYEE_NAME+' '+new_sql_2.EMPLOYEE_SURNAME;	
			}
			else
			{
				document.getElementById('employee_id').value = new_sql.CASHIER1;
				document.getElementById('employee_name').value = new_sql.CASHIER1;	
			}
		}
	}
</script>
