<cf_get_lang_set module_name="cash">
<cfset cash_status = 1>
<cf_catalystHeader>
<cf_papers paper_type="revenue_receipt">
<cf_box id="cash_revenue_box" title="#getlang('','settings','57845')#">
    <cf_box_data asname="data_bill_no" function="V16.cash.cfc.cash_revenue:GET_BILL_NO">
    <cfif isdefined("url.id") and len(url.id)>
        <cf_box_data asname="data_caches" function="V16.cash.cfc.cash_revenue:GET_CACHES">
    </cfif>
        <cfif not data_bill_no.recordcount>
            <font color="FF0000">
                <a href="<cfoutput>#request.self#?fuseaction=account.bill_no</cfoutput>"><cf_get_lang dictionary_id='29413.Lütfen Muhasebe Fiş numaralarını Düzenleyiniz'></a>
            </font>
            <cfabort>
        </cfif>
<cfform name="add_cash_revenue" method="post">
	<cf_duxi type="hidden" name="active_period" value="#session.ep.period_id#">
<cf_box_elements addcol="1">
                        <cf_duxi name="process_cat" label="57800" hint="işlem tipi" required="yes">
                            <cfif isdefined("url.id") and len(url.id)>
                                <cf_workcube_process_cat  process_cat="#data_caches.process_cat#" slct_width="175">
                             <cfelse>
                                <cf_workcube_process_cat slct_width="175">
                            </cfif>
                        </cf_duxi>  
                        <cf_duxi label="57520" hint="Kasa" required="yes">
                            <cfif isdefined("url.id") and len(url.id)>
                              <cf_wrk_Cash name="CASH_ACTION_TO_CASH_ID"  currency_branch="0" cash_status="1" value="#data_caches.CASH_ACTION_TO_CASH_ID#" onChange="kur_ekle_f_hesapla('CASH_ACTION_TO_CASH_ID');">
                            <cfelse>
                                <cf_wrk_Cash name="CASH_ACTION_TO_CASH_ID"  currency_branch="0"  onChange="kur_ekle_f_hesapla('CASH_ACTION_TO_CASH_ID');">
                            </cfif>
                        </cf_duxi>
                        <cf_duxi label="58929" hint="Tahsilat Tipi">
							<cfif isdefined("url.id") and len(url.id)>
								<cf_wrk_special_definition width_info='175' type_info='1' field_id="special_definition_id" selected_value='#data_caches.special_definition_id#'>
							<cfelse>
								<cf_wrk_special_definition width_info='175' type_info='1' field_id="special_definition_id">
							</cfif>
                        </cf_duxi>
                    <cfif isdefined("url.id") and len(url.id)>
                        <cfset emp_id = data_caches.CASH_ACTION_FROM_EMPLOYEE_ID>
                        <cfif len(data_caches.acc_type_id)>
                            <cfset emp_id = "#emp_id#_#data_caches.acc_type_id#">
                        </cfif>
                    </cfif>
                    <cfif isdefined("url.id") and len(url.id)>
                        <cf_duxi type="hidden" name="EMPLOYEE_ID" id="EMPLOYEE_ID" value="#emp_id#">
                        <cf_duxi type="hidden" name="CASH_ACTION_FROM_CONSUMER_ID" value="#data_caches.CASH_ACTION_FROM_CONSUMER_ID#">
                        <cf_duxi type="hidden" name="CASH_ACTION_FROM_COMPANY_ID" value="#data_caches.CASH_ACTION_FROM_COMPANY_ID#">
                        <cfelse>
                        <cf_duxi type="hidden" name="EMPLOYEE_ID" id="EMPLOYEE_ID">
                        <cf_duxi type="hidden" name="CASH_ACTION_FROM_CONSUMER_ID">
                        <cf_duxi type="hidden" name="CASH_ACTION_FROM_COMPANY_ID">
                    </cfif>
                    <div class="form-group" id="item-company_name">
                    	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.cari Hesap'>*</label>
                        <div class="col col-8 col-xs-12">
                        	<div class="input-group"> 
                                <input type="text" name="company_name" id="company_name" onFocus= "AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'\',\'0\',\'1\',\'\',\'0\'','CONSUMER_ID,COMPANY_ID,EMPLOYEE_ID','CASH_ACTION_FROM_CONSUMER_ID,CASH_ACTION_FROM_COMPANY_ID,EMPLOYEE_ID','','2','250','get_money_info(\'add_cash_revenue\',\'ACTION_DATE\')');" value="<cfif isdefined("data_caches.CASH_ACTION_FROM_COMPANY_ID") and len(data_caches.CASH_ACTION_FROM_COMPANY_ID)><cfoutput>#get_par_info(data_caches.CASH_ACTION_FROM_COMPANY_ID,1,1,0)#</cfoutput><cfelseif isdefined("data_caches.CASH_ACTION_FROM_CONSUMER_ID") and len(data_caches.CASH_ACTION_FROM_CONSUMER_ID)><cfoutput>#get_cons_info(data_caches.CASH_ACTION_FROM_CONSUMER_ID,0,0)#</cfoutput><cfelseif isdefined("data_caches.CASH_ACTION_FROM_EMPLOYEE_ID") and len(data_caches.CASH_ACTION_FROM_EMPLOYEE_ID)><cfoutput>#get_emp_info(data_caches.CASH_ACTION_FROM_EMPLOYEE_ID,0,0,0,data_caches.acc_type_id)#</cfoutput></cfif>" style="width:175px;">
                                <span class="input-group-addon icon-ellipsis" onclick="hesap_sec(); windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_cari_action=1&field_comp_id=add_cash_revenue.CASH_ACTION_FROM_COMPANY_ID&field_comp_name=add_cash_revenue.company_name&field_emp_id=add_cash_revenue.EMPLOYEE_ID&field_consumer=add_cash_revenue.CASH_ACTION_FROM_CONSUMER_ID&field_name=add_cash_revenue.company_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9,2,3','list','popup_list_pars');" title="<cf_get_lang dictionary_id='57519.cari Hesap'>"></span>
                            </div>
                        </div>
                    </div>
                    <cfif isDefined('paper_printer_code')>
                    <cf_duxi type="hidden" name="paper_printer_id" value="#paper_printer_code#">
                    <cfelse>
                    <cf_duxi type="hidden" name="paper_printer_id">
                    </cfif>
                    <cfif len(paper_code) and len(paper_number)><cfset paper_info = paper_code & '-' & paper_number><cfelse><cfset paper_info = ""></cfif>
                        <cf_duxi type="text" name="paper_number" label="57880" hint="Belge No" value="#paper_info#" required="yes">
                            <div class="form-group" id="item-action_date">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'>*</label>
                                <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="message1"><cf_get_lang dictionary_id='57742.Tarih'>!</cfsavecontent>
                                <cfif isdefined("url.id") and len(url.id)>
                                    <div class="input-group">
                                    <cfinput value="#dateformat(data_caches.ACTION_DATE,dateformat_style)#" validate="#validate_style#" required="Yes" message="#message1#" type="text" name="ACTION_DATE" style="width:175px;" onBlur="change_money_info('add_cash_revenue','ACTION_DATE');">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="ACTION_DATE" call_function="change_money_info" control_date="#dateformat(data_caches.ACTION_DATE,dateformat_style)#"></span>
                                </div>
                                <cfelse>
                                    <div class="input-group">
                                    <cfinput value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" required="Yes" message="#message1#" type="text" name="ACTION_DATE" style="width:175px;" onBlur="change_money_info('add_cash_revenue','ACTION_DATE');">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="ACTION_DATE" call_function="change_money_info"></span>
                                </div>
                                 </cfif>
                                </div>
                            </div>
                    <cfif isdefined("url.id") and len(url.id)>
                            <cf_duxi type="text" name="CASH_ACTION_VALUE" hint="Tutar" label="57673" onBlur="kur_ekle_f_hesapla('CASH_ACTION_TO_CASH_ID');" class="moneybox" value="#TLFormat(data_caches.CASH_ACTION_VALUE)#"  onkeyup="return(FormatCurrency(this,event));" required="yes">
                            <cf_duxi type="text" name="OTHER_CASH_ACT_VALUE" hint="Dövizli Tutar" label="58056" class="moneybox" value="#TLFormat(data_caches.OTHER_CASH_ACT_VALUE)#" onBlur="kur_ekle_f_hesapla('CASH_ACTION_TO_CASH_ID',true);" onkeyup="return(FormatCurrency(this,event));">
                        <cfelse>
                            <cf_duxi type="text" name="CASH_ACTION_VALUE" hint="Tutar" label="57673" class="moneybox" onBlur="kur_ekle_f_hesapla('CASH_ACTION_TO_CASH_ID');" onkeyup="return(FormatCurrency(this,event));" required="yes">
                            <cf_duxi type="text" name="OTHER_CASH_ACT_VALUE" hint="Dövizli Tutar" label="58056" class="moneybox" onBlur="kur_ekle_f_hesapla('CASH_ACTION_TO_CASH_ID',true);" onkeyup="return(FormatCurrency(this,event));">
                        </cfif>
                        <cfif isdefined("url.id") and len(url.id) and session.ep.isBranchAuthorization>
                            <cf_duxi type="hidden" name="REVENUE_COLLECTOR_ID"  value="#data_caches.REVENUE_COLLECTOR_ID#">
                            <cf_duxi type="text" name="REVENUE_COLLECTOR" value="#get_emp_info(data_caches.REVENUE_COLLECTOR_ID,0,0)#" required="yes"  hint="Tahsil Eden" label="50233" autocomplete="AutoComplete_Create('REVENUE_COLLECTOR','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','REVENUE_COLLECTOR_ID','add_cash_revenue','3','125');" threepoint="#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_cash_revenue.REVENUE_COLLECTOR_ID&field_name=add_cash_revenue.REVENUE_COLLECTOR&is_store_module=1&select_list=1,9">
                        <cfelseif isdefined("url.id") and len(url.id) and not session.ep.isBranchAuthorization>
                            <cf_duxi type="hidden" name="REVENUE_COLLECTOR_ID"  value="#data_caches.REVENUE_COLLECTOR_ID#">
                            <cf_duxi type="text" name="REVENUE_COLLECTOR"  value="#get_emp_info(data_caches.REVENUE_COLLECTOR_ID,0,0)#" required="yes" hint="Tahsil Eden" label="50233" autocomplete="AutoComplete_Create('REVENUE_COLLECTOR','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','REVENUE_COLLECTOR_ID','add_cash_revenue','3','125');" threepoint="#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_cash_revenue.REVENUE_COLLECTOR_ID&field_name=add_cash_revenue.REVENUE_COLLECTOR&select_list=1,9">
                        <cfelseif session.ep.isBranchAuthorization>
                            <cf_duxi type="hidden" name="REVENUE_COLLECTOR_ID"  value="#session.ep.userid#">
                            <cf_duxi type="text" name="REVENUE_COLLECTOR"  value="#get_emp_info(session.ep.userid,0,0)#" required="yes" hint="Tahsil Eden" label="50233" autocomplete="AutoComplete_Create('REVENUE_COLLECTOR','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','REVENUE_COLLECTOR_ID','add_cash_revenue','3','125');" threepoint="#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_cash_revenue.REVENUE_COLLECTOR_ID&field_name=add_cash_revenue.REVENUE_COLLECTOR&is_store_module=1&select_list=1,9">
                        <cfelse>
                            <cf_duxi type="hidden" name="REVENUE_COLLECTOR_ID"  value="#session.ep.userid#">
                            <cf_duxi type="text" name="REVENUE_COLLECTOR"  value="#get_emp_info(session.ep.userid,0,0)#" required="yes" hint="Tahsil Eden" label="50233" autocomplete="AutoComplete_Create('REVENUE_COLLECTOR','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','REVENUE_COLLECTOR_ID','add_cash_revenue','3','125');" threepoint="#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_cash_revenue.REVENUE_COLLECTOR_ID&field_name=add_cash_revenue.REVENUE_COLLECTOR&select_list=1,9">
                        </cfif> 
                    <cfif isdefined("url.id") and len(url.id) and len(data_caches.project_id)>
					<cfquery name="get_project_name" datasource="#dsn#">
						SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #data_caches.project_id#
					</cfquery>
                        <cf_duxi type="hidden" name="project_id"  value="#data_caches.project_id#">
                        <cf_duxi type="text" label="57416" hint="Proje" name="project_name"  value="#get_project_name.project_head#" autocomplete="AutoComplete_Create('project_name','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" threepoint="#request.self#?fuseaction=objects.popup_list_projects&project_head=add_cash_revenue.project_name&project_id=add_cash_revenue.project_id">
                    <cfelse>
                        <cf_duxi type="hidden" name="project_id">
                        <cf_duxi type="text" label="57416" hint="Proje" name="project_name" autocomplete="AutoComplete_Create('project_name','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" threepoint="#request.self#?fuseaction=objects.popup_list_projects&project_head=add_cash_revenue.project_name&project_id=add_cash_revenue.project_id">
					</cfif>
                    <cfif session.ep.our_company_info.asset_followup eq 1>
                        <cf_duxi type="text" name="asset_id" hint="Fiziki Varlık" label="58833">
                        <cfif isdefined("url.id") and len(url.id)>
                            <cf_wrkAssetp asset_id="#data_caches.assetp_id#" fieldId='asset_id' fieldName='asset_name' form_name='add_cash_revenue' width='175'>
                        <cfelse>
                            <cf_wrkAssetp fieldId='asset_id' fieldName='asset_name' form_name='add_cash_revenue' width='175'>
                        </cfif>
                    </cf_duxi>
                    </cfif>
                    <cfif isdefined("url.id") and len(url.id)>
                    <cf_duxi type="textarea" name="ACTION_DETAIL" id="ACTION_DETAIL" value="#data_caches.ACTION_DETAIL#" hint="Açıklama" label="57629">
                    <cfelse>
                    <cf_duxi type="textarea" name="ACTION_DETAIL" id="ACTION_DETAIL" value="" hint="Açıklama" label="57629">
                    </cfif>
                    <cf_duxi hint="İşlem Para Br" label="35578"></cf_duxi>
                    <div class="form-group" id="item_money">
                        <label class="col col-2 col-xs-12"></label>
                        <div class="col col-10 col-xs-12">
                            <cfscript>f_kur_ekle(process_type:0,base_value:'CASH_ACTION_VALUE',other_money_value:'OTHER_CASH_ACT_VALUE',form_name:'add_cash_revenue',select_input:'CASH_ACTION_TO_CASH_ID');</cfscript>
                        </div>
                    </div>
            </cf_box_elements>
               <cf_box_footer>
                    <cf_workcube_buttons 
                    type_format='1' 
                    is_upd='0'
                    add_function='kontrol()'>
               <!---///butonlar--->
        </cf_box_footer>              
</cfform>
<script type="text/javascript">
	function kontrol()
	{
		<!---if(!paper_control(add_cash_revenue.paper_number,'REVENUE_RECEIPT')) return false;--->
		if(!chk_process_cat('add_cash_revenue')) return false;
        if(!check_display_files('add_cash_revenue')) return false;
        document.getElementById("wrk_submit_button").disabled = true;
		if(!chk_period(add_cash_revenue.ACTION_DATE,'İşlem')) return false;//işlem uzun sürüyor. Bu nedenle çoklu kayıt atmanın önüne geçmek için öncesinde butonu disabled yapmak gerekti.
        document.getElementById("wrk_submit_button").disabled = false;
        if(document.getElementById('CASH_ACTION_TO_CASH_ID').value=="")
		{
			alert('Kasa Seçiniz!');
			return false;
		}
		if(document.add_cash_revenue.REVENUE_COLLECTOR.value =='' )
		{
			alert("<cf_get_lang dictionary_id='49918.Tahsil Eden Seçiniz '>!");
			return false;
		}
		if((document.add_cash_revenue.CASH_ACTION_FROM_COMPANY_ID.value =='') && (document.add_cash_revenue.EMPLOYEE_ID.value =='') && (document.add_cash_revenue.CASH_ACTION_FROM_CONSUMER_ID.value ==''))
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57519.Cari Hesap'>");
			return false;
		}
		x = document.add_cash_revenue.CASH_ACTION_TO_CASH_ID.selectedIndex;
		if (document.add_cash_revenue.CASH_ACTION_TO_CASH_ID[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='49919.Lütfen Kasa Seçiniz'>!");
			return false;
		}
		var parameter = '-1*' + document.add_cash_revenue.paper_number.value + '*31*11'; <!---tahsilat işlemine göre paper no unique olmalı. 31 tahsilat işlemi action_type_id --->
		var parameter_2 = document.add_cash_revenue.paper_number.value + '*11';
		var get_paper_no = wrk_safe_query('csh_get_paper_no_3','dsn2',0,parameter);
		var get_paper_from_account = wrk_safe_query('acc_get_paper_no','dsn2',0,parameter_2);
		if( get_paper_no.recordcount || get_paper_from_account.recordcount)
		{
			alert("<cf_get_lang dictionary_id='59366.Girdiğiniz Belge Numarası Kullanılmaktadır'> !");
			return false;
		}
		return true;
	}
	function hesap_sec()
	{
		if(document.add_cash_revenue.CASH_ACTION_FROM_COMPANY_ID.value!='')
		{
			document.add_cash_revenue.CASH_ACTION_FROM_COMPANY_ID.value='';
			document.add_cash_revenue.company_name.value='';
		}
		if(document.add_cash_revenue.CASH_ACTION_FROM_CONSUMER_ID.value!='')
		{
			document.add_cash_revenue.CASH_ACTION_FROM_CONSUMER_ID.value='';
			document.add_cash_revenue.company_name.value='';
		}
		if(document.add_cash_revenue.EMPLOYEE_ID.value!='')
		{
			document.add_cash_revenue.EMPLOYEE_ID.value='';
			document.add_cash_revenue.company_name.value='';
		}
	}
    
	$( document ).ready(function() {
		kur_ekle_f_hesapla('CASH_ACTION_TO_CASH_ID');
	});
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">