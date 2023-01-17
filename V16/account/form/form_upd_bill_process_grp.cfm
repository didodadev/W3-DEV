<!--- Fiş Listesi Güncelle--->
<cf_xml_page_edit fuseact="account.popup_form_add_bills_process_groups">
<cfquery name="GET_ALL_PROCESS_CAT" datasource="#DSN3#">
	SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT,IS_ACCOUNT FROM SETUP_PROCESS_CAT
</cfquery>
<cfquery name="get_acc_card_type" dbtype="query">
	SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT,IS_ACCOUNT FROM GET_ALL_PROCESS_CAT WHERE 1=1 <cfif is_selected_account eq 0>AND IS_ACCOUNT = 1 </cfif> AND PROCESS_TYPE IN (11,12,13,14) ORDER BY PROCESS_TYPE
</cfquery>
<cfquery name="get_process_cat_process_type" dbtype="query">
	SELECT DISTINCT PROCESS_TYPE FROM GET_ALL_PROCESS_CAT WHERE 1=1 <cfif is_selected_account eq 0>AND IS_ACCOUNT = 1 </cfif> ORDER BY PROCESS_TYPE
</cfquery>
<cfquery name="get_process_cat" dbtype="query">
	SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT,IS_ACCOUNT FROM GET_ALL_PROCESS_CAT WHERE 1=1 <cfif is_selected_account eq 0>AND IS_ACCOUNT = 1 </cfif> ORDER BY PROCESS_TYPE
</cfquery>
<cfquery name="get_process_list_process" datasource="#DSN3#">
 	SELECT 
    	PROCESS_TYPE_GROUP_ID, 
        PROCESS_NAME, 
        PROCESS_TYPE, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        ACCOUNT_CODE_1, 
        ACCOUNT_CODE_2, 
        ACTION_DETAIL, 
        IS_DAY_GROUP, 
        IS_ACCOUNT_GROUP 
    FROM 
    	BILLS_PROCESS_GROUP 
    where 
    	PROCESS_TYPE_GROUP_ID=#url.id#
</cfquery>
<cfquery name="record_name" datasource="#DSN#">
	SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #get_process_list_process.record_emp#
</cfquery>
<cfif len(#get_process_list_process.update_emp#)>
    <cfquery name="update_name" datasource="#DSN#">
        SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #get_process_list_process.update_emp#
    </cfquery>
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="Add_Form_List_Bills" action="#request.self#?fuseaction=account.emptypopup_upt_bills_process_group&id=#url.id#" method="post">
			<input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">	
			<cf_box_elements vertical="1">
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_name">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='47302.İşlem Grup Adı'> *</label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
							<input type="text" name="process_name" id="process_name" value="<cfoutput>#get_process_list_process.PROCESS_NAME#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-get_pro_cat">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'> *</label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
							<select name="process_type" id="process_type" multiple>
								<cfoutput query="get_process_cat_process_type">
									<optgroup label="#get_process_name(process_type)#"></optgroup>
									<!--- Klavye ile aranmak istenen harfe basildiginda bu sekilde gelmediginden duzenlendi, fbs sorun varsa duzeltilebilir
									<option disabled  value="#process_type#-0" <cfif isdefined('x_selected_process_id') and len(x_selected_process_id) and x_selected_process_id eq process_type>selected</cfif>>#get_process_name(process_type)#</option> --->
										<cfquery name="get_pro_cat" dbtype="query">
											SELECT * FROM get_process_cat WHERE PROCESS_TYPE = #get_process_cat_process_type.process_type# 
										</cfquery>
										<cfloop query="get_pro_cat">
											<option <cfif listfind(get_process_list_process.PROCESS_TYPE,get_pro_cat.process_cat_id,',')> selected</cfif><cfif is_selected_account eq 1 and is_account eq 0>style="color:red"</cfif> value="#get_pro_cat.process_cat_id#"><!--- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; --->#get_pro_cat.process_cat#</option>
										</cfloop>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-code1">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='47308.Başlangıç Hesabı'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
							<div class="input-group">
								<cfinput type="Text" name="code1" value="#get_process_list_process.account_code_1#" id="code1" onFocus="AutoComplete_Create('code1','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'1\',0','','','add_sum_bills','3','250');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="javascript:pencere_ac_muavin('Add_Form_List_Bills.code1','Add_Form_List_Bills.name1','Add_Form_List_Bills.name1');" title="Başlangıç Hesabı"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-code2">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='47311.Bitiş Hesabı'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
							<div class="input-group">
								<cfinput type="Text" name="code2" value="#get_process_list_process.account_code_2#" id="code2" onFocus="AutoComplete_Create('code2','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'1\',0','','','add_sum_bills','3','250');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="javascript:pencere_ac_muavin('Add_Form_List_Bills.code2','Add_Form_List_Bills.name2','Add_Form_List_Bills.name2');" title="Bitiş Hesabı"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-bill_detail">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
							<textarea name="bill_detail" id="bill_detail" ><cfoutput>#get_process_list_process.action_detail#</cfoutput></textarea>
						</div>
					</div>
					<div class="form-group" id="item-is_what_group">
						<div class="col col-12">
							<label><cf_get_lang dictionary_id='47432.Hesap Bazında Grupla'> <input type="checkbox" name="is_account_group" id="is_account_group" value="1" <cfif get_process_list_process.is_account_group eq 1>checked</cfif>></label>
							<label><cf_get_lang dictionary_id='47525.Gün Bazında Grupla'> <input type="checkbox" name="is_day_group" id="is_day_group" value="1" <cfif get_process_list_process.is_day_group eq 1>checked</cfif>></label>
						</div>							
					</div>
				</div>
			</cf_box_elements>	
			<cf_box_footer>	
				<div class="col col-6"><cf_record_info query_name="get_process_list_process"></div>
				<div class="col col-6"><cf_workcube_buttons is_upd='1' is_delete="0" add_function='kontrol()'></div>  
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	function pencere_ac_muavin(str_alan_1,str_alan_2,str_alan)
	{
		var txt_keyword = eval(str_alan_1 + ".value" );
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id='+str_alan_1+'&field_id2='+str_alan_1+'&keyword='+txt_keyword,'list');
	}
	function kontrol()
	{
	   if(document.Add_Form_List_Bills.process_name.value == "")
		{
			alert("<cf_get_lang dictionary_id='52632.İşlem Grup Adını Girmelisiniz'>!");
			return false;
		}
		else if(document.Add_Form_List_Bills.process_type.value == "")
		{
			alert("<cf_get_lang dictionary_id='58770.İşlem Tipini Secmelisiniz'>!");
			return false;
		}
		else 
		return true;
	}
</script>
