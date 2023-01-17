<cf_get_lang_set module_name="cash">
<cfset refmodule="#listgetat(attributes.fuseaction,1,'.')#">
<cf_catalystHeader>
<cf_box_data asname="get_caches" function="V16.cash.cfc.cash_revenue:GET_CACHES_UPDATE">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box id="upd_cash_revenue_box" title="#getlang('','settings','57845')#">
        <cfif not data_cash_revenue.recordcount>
            <cfset hata  = 11>
            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'> <cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'> !</cfsavecontent>
            <cfset hata_mesaj  = message>
            <cfinclude template="../../dsp_hata.cfm">
        <cfelse>
            <cfform name="upd_cash_revenue" method="post">
                <cf_duxi type="hidden" name="active_period" value="#session.ep.period_id#">
                <cf_duxi type="hidden" name="id" value="#url.id#">
                <cf_box_elements addcol="1">
                    <cf_duxi label="57800" hint="işlem tipi" required="yes">
                        <cf_workcube_process_cat process_cat="#data_cash_revenue.process_cat#" slct_width="175">
                    </cf_duxi>
                    <cf_duxi label="57520" hint="Kasa" required="yes">
                        <cf_wrk_Cash name="CASH_ACTION_TO_CASH_ID" currency_branch="0" value="#data_cash_revenue.CASH_ACTION_TO_CASH_ID#" onChange="kur_ekle_f_hesapla('CASH_ACTION_TO_CASH_ID');">
                    </cf_duxi>
                    <cf_duxi label="58929" hint="Tahsilat Tipi">
                        <cf_wrk_special_definition width_info='175' type_info='1' field_id="special_definition_id" selected_value='#data_cash_revenue.special_definition_id#'>
                    </cf_duxi>
                    <cfset emp_id = data_cash_revenue.CASH_ACTION_FROM_EMPLOYEE_ID>
                    <cfif len(data_cash_revenue.acc_type_id)>
                        <cfset emp_id = "#emp_id#_#data_cash_revenue.acc_type_id#">
                    </cfif>
                    <cf_duxi type="hidden" name="EMPLOYEE_ID" id="EMPLOYEE_ID" value="#emp_id#">
                    <cf_duxi type="hidden" name="CASH_ACTION_FROM_CONSUMER_ID" id="CASH_ACTION_FROM_CONSUMER_ID" value="#data_cash_revenue.CASH_ACTION_FROM_CONSUMER_ID#">
                    <cf_duxi type="hidden" name="CASH_ACTION_FROM_COMPANY_ID" id="CASH_ACTION_FROM_COMPANY_ID" value="#data_cash_revenue.CASH_ACTION_FROM_COMPANY_ID#">
                    <div class="form-group" id="item-company_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="company_name" id="company_name" onFocus= "AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','CONSUMER_ID,COMPANY_ID,EMPLOYEE_ID','CASH_ACTION_FROM_CONSUMER_ID,CASH_ACTION_FROM_COMPANY_ID,EMPLOYEE_ID','','2','250','get_money_info(\'upd_cash_revenue\',\'ACTION_DATE\')');" value="<cfif len(data_cash_revenue.CASH_ACTION_FROM_EMPLOYEE_ID)><cfoutput>#get_emp_info(data_cash_revenue.CASH_ACTION_FROM_EMPLOYEE_ID,0,0,0,data_cash_revenue.acc_type_id)#</cfoutput><cfelseif len(data_cash_revenue.CASH_ACTION_FROM_COMPANY_ID)><cfoutput>#get_par_info(data_cash_revenue.CASH_ACTION_FROM_COMPANY_ID,1,1,0)#</cfoutput><cfelse><cfoutput>#get_cons_info(data_cash_revenue.CASH_ACTION_FROM_CONSUMER_ID,0,0)#</cfoutput></cfif>" style="width:175px;">
                                <span class="input-group-addon icon-ellipsis" onclick="hesap_sec(); javascript:windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&field_comp_id=upd_cash_revenue.CASH_ACTION_FROM_COMPANY_ID&field_comp_name=upd_cash_revenue.company_name&field_emp_id=upd_cash_revenue.EMPLOYEE_ID&field_consumer=upd_cash_revenue.CASH_ACTION_FROM_CONSUMER_ID&field_name=upd_cash_revenue.company_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3,1,9</cfoutput>','list','popup_list_pars');"></span>
                            </div>
                        </div>
                    </div>
                    <cf_duxi type="hidden" name="paper_number_hidden" value="#data_cash_revenue.paper_no#" required="yes">
                    <cf_duxi type="text" name="paper_number" label="57880" maxlength="9" hint="Belge No" value="#data_cash_revenue.paper_no#"  required="yes">
                    <div class="form-group" id="item-action_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30631.Tarih'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput value="#dateformat(data_cash_revenue.ACTION_DATE,dateformat_style)#" validate="#validate_style#" required="Yes"  type="text" name="ACTION_DATE" style="width:175px;" readonly onBlur="change_money_info('upd_cash_revenue','ACTION_DATE');">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="ACTION_DATE" call_function="change_money_info" control_date="#dateformat(data_cash_revenue.ACTION_DATE,dateformat_style)#"></span>
                            </div>
                        </div>
                    </div>
                    <cf_duxi type="text" name="CASH_ACTION_VALUE" hint="Tutar" label="57673" class="moneybox" value="#TLFormat(data_cash_revenue.CASH_ACTION_VALUE)#" onBlur="kur_ekle_f_hesapla('CASH_ACTION_TO_CASH_ID');"  onkeyup="return(FormatCurrency(this,event));"  required="yes">
                    <cf_duxi type="text" name="OTHER_CASH_ACT_VALUE" hint="Dövizli Tutar" label="58056" class="moneybox" value="#TLFormat(data_cash_revenue.OTHER_CASH_ACT_VALUE)#" onBlur="kur_ekle_f_hesapla('CASH_ACTION_TO_CASH_ID',true);" onkeyup="return(FormatCurrency(this,event));">
                    <cf_duxi type="hidden" name="REVENUE_COLLECTOR_ID"  value="#data_cash_revenue.REVENUE_COLLECTOR_ID#">
                    <cfif session.ep.isBranchAuthorization>
                        <cf_duxi type="text" name="REVENUE_COLLECTOR" required="yes" hint="Tahsil Eden" label="50233"  value="#get_emp_info(data_cash_revenue.REVENUE_COLLECTOR_ID,0,0)#" threepoint="#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=upd_cash_revenue.REVENUE_COLLECTOR_ID&field_name=upd_cash_revenue.REVENUE_COLLECTOR&is_store_module=1">
                    <cfelse>
                        <cf_duxi type="text" name="REVENUE_COLLECTOR" required="yes" hint="Tahsil Eden" label="50233"  value="#get_emp_info(data_cash_revenue.REVENUE_COLLECTOR_ID,0,0)#" threepoint="#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=upd_cash_revenue.REVENUE_COLLECTOR_ID&field_name=upd_cash_revenue.REVENUE_COLLECTOR">
                    </cfif>
                    <cf_duxi type="hidden" name="project_id" value="#data_cash_revenue.project_id#">
                    <cfif len(data_cash_revenue.project_id)>
                        <cfquery name="get_project_name" datasource="#dsn#">
                        SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #data_cash_revenue.project_id#
                        </cfquery>
                    <cf_duxi type="text" label="57416" hint="Proje" name="project_name" value="#get_project_name.project_head#" autocomplete="AutoComplete_Create('project_name','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" threepoint="#request.self#?fuseaction=objects.popup_list_projects&project_head=upd_cash_revenue.project_name&project_id=upd_cash_revenue.project_id">
                    <cfelse>
                        <cf_duxi type="text" label="57416" hint="Proje" name="project_name" autocomplete="AutoComplete_Create('project_name','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" threepoint="#request.self#?fuseaction=objects.popup_list_projects&project_head=upd_cash_revenue.project_name&project_id=upd_cash_revenue.project_id">
                    </cfif>
                    <cfif session.ep.our_company_info.asset_followup eq 1>
                        <cf_duxi type="text" name="asset_id" hint="Fiziki Varlık" label="58833">
                            <cf_wrkAssetp asset_id="#data_cash_revenue.assetp_id#" fieldId='asset_id' fieldName='asset_name' form_name='upd_cash_revenue' width='175'>
                        </cf_duxi>
                    </cfif>
                    <cf_duxi type="textarea" name="ACTION_DETAIL" value="#data_cash_revenue.ACTION_DETAIL#" hint="Açıklama" label="57629">
                    <cf_duxi hint="İşlem Para Br" label="35578"></cf_duxi>
                    <div class="form-group" id="item_money">
                        <label class="col col-2 col-xs-12"></label>
                        <div class="col col-10 col-xs-12">
                            <cfscript>f_kur_ekle(action_id:url.id,process_type:1,base_value:'CASH_ACTION_VALUE',other_money_value:'OTHER_CASH_ACT_VALUE',form_name:'upd_cash_revenue',action_table_name:'CASH_ACTION_MONEY',action_table_dsn:'#dsn2#',select_input:'CASH_ACTION_TO_CASH_ID');</cfscript>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_record_info query_name="data_cash_revenue">
                    <cfif not len(isClosed('CASH_ACTIONS',attributes.id))>
                        <cfif listgetat(attributes.fuseaction,2,'.') is 'popup_upd_cash_revenue'>
                        <cf_workcube_buttons 
                        is_upd='1'  
                        update_status='#data_cash_revenue.UPD_STATUS#'
                        del_function_for_submit='del_kontrol()'
                        delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.del_cash_revenue&id=#url.id#&detail=#data_cash_revenue.paper_no#&old_process_type=#data_cash_revenue.action_type_id#' 
                        add_function="kontrol()">
                    <cfelse>
                        <cf_workcube_buttons 
                        is_upd='1'  
                        is_cancel=0
                        update_status='#data_cash_revenue.UPD_STATUS#'
                        del_function_for_submit='del_kontrol()'
                        delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.del_cash_revenue&id=#url.id#&detail=#data_cash_revenue.paper_no#&old_process_type=#data_cash_revenue.action_type_id#' 
                        add_function="kontrol()">
                    </cfif>
                    <cfelse>
                        <span style="float:right"><b><font color="FF0000"><cf_get_lang dictionary_id='47262.Fatura kapama işlemi yapılan belgede değişiklik yapılamaz'>!</font></b></span>
                    </cfif>
                </cf_box_footer>
            </cfform>
        </cfif>
    </cf_box>
</div>
<script type="text/javascript">
	$( document ).ready(function() {
		kur_ekle_f_hesapla('CASH_ACTION_TO_CASH_ID');
	});
	function del_kontrol()
	{
		control_account_process(<cfoutput>'#attributes.id#','#data_cash_revenue.action_type_id#'</cfoutput>);
        if(!chk_period(upd_cash_revenue.ACTION_DATE,'İşlem')) return false;
        else return true;
	}
	function kontrol()
	{
		control_account_process(<cfoutput>'#attributes.id#','#data_cash_revenue.action_type_id#'</cfoutput>);
		if(!chk_process_cat('upd_cash_revenue')) return false;
		if(!check_display_files('upd_cash_revenue')) return false;
		document.getElementById("wrk_submit_button").disabled = true;
        if(!chk_period(upd_cash_revenue.ACTION_DATE,'İşlem')) return false;//işlem uzun sürüyor. Bu nedenle çoklu kayıt atmanın önüne geçmek için öncesinde butonu disabled yapmak gerekti.
		document.getElementById("wrk_submit_button").disabled = false;
        if((document.upd_cash_revenue.CASH_ACTION_FROM_COMPANY_ID.value =='') && (document.upd_cash_revenue.EMPLOYEE_ID.value =='') && (document.upd_cash_revenue.CASH_ACTION_FROM_CONSUMER_ID.value ==''))
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57519.Cari Hesap'>");
			return false;
		}
		if(upd_cash_revenue.REVENUE_COLLECTOR_ID.value=="" || upd_cash_revenue.REVENUE_COLLECTOR.value=="")
		{
			alert("<cf_get_lang dictionary_id='49918.Tahsil Eden Seçiniz'>!");
			return false;
		}
		//var new_sql = "SELECT PAPER_NO FROM CASH_ACTIONS WHERE ACTION_ID <> "+document.upd_cash_revenue.id.value+" AND PAPER_NO = '"+ document.upd_cash_revenue.paper_number.value +"'";

        var paper_number_hidden = document.upd_cash_revenue.paper_number_hidden.value;
        var paper_number = document.upd_cash_revenue.paper_number.value;
        if(paper_number != paper_number_hidden){
            var parameter = document.upd_cash_revenue.id.value + '*' + paper_number + '*31*11'; <!---tahsilat işlemine göre paper no unique olmalı. 31 tahsilat işlemi action_type_id, 11 tahsil fişi --->
            var parameter_2 = document.upd_cash_revenue.id.value + '*' + paper_number + '*11';
            var get_paper_no = wrk_safe_query('csh_get_paper_no_3','dsn2',0,parameter);
            var get_paper_no_from_acc = wrk_safe_query('get_paper_no_from_acc','dsn2',0,parameter_2);<!---tahsilat işleminden oluşan tahsilat fişinin belge numarasıyla manuel olarak eklenmiş tahsilat fişi de var mı? ---> 	
            if( get_paper_no.recordcount || get_paper_no_from_acc.recordcount)
            {
                alert("<cf_get_lang dictionary_id='58122.Girdiğiniz Belge Numarası Kullanılmaktadır'> !");
                return false;
            }
        }
        
		return true;
	}
	function hesap_sec()
	{
		if(document.upd_cash_revenue.CASH_ACTION_FROM_COMPANY_ID.value!='')
		{
			document.upd_cash_revenue.CASH_ACTION_FROM_COMPANY_ID.value='';
			document.upd_cash_revenue.company_name.value='';
		}
		if(document.upd_cash_revenue.CASH_ACTION_FROM_CONSUMER_ID.value!='')
		{
			document.upd_cash_revenue.CASH_ACTION_FROM_CONSUMER_ID.value='';
			document.upd_cash_revenue.company_name.value='';
		}
		if(document.upd_cash_revenue.EMPLOYEE_ID.value!='')
		{
			document.upd_cash_revenue.EMPLOYEE_ID.value='';
			document.upd_cash_revenue.company_name.value='';
		}
	}
	function ekle_ac()
	{
		if(upd_cash_revenue.is_popup.value == 1)
		{
			window.opener.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.form_add_cash_revenue';
			window.close();
		}
		else {window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.form_add_cash_revenue';}
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
