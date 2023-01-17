<cf_get_lang_set module_name="cash">
<cf_xml_page_edit fuseact="cash.add_cash_to_cash">
<cfset refmodule="#listgetat(attributes.fuseaction,1,'.')#">
<cfset attributes.TABLE_NAME = "CASH_ACTIONS">
<cfset is_virman_act = 1>
<cfset all_cash_ = 1>
<cfinclude template="../query/get_cashes.cfm">
<cfquery name="GET_ACTION_DETAIL" datasource="#dsn2#">
	SELECT
        CASH_ACTIONS.*,
        PP.PROJECT_HEAD        
	FROM
		CASH_ACTIONS
        LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON PP.PROJECT_ID = CASH_ACTIONS.PROJECT_ID        
	WHERE
		(ACTION_ID = #ATTRIBUTES.ID# OR ACTION_ID = #ATTRIBUTES.ID+1#) AND
		ACTION_TYPE_ID = 33
		<cfif session.ep.isBranchAuthorization>
			AND
			(
                (CASH_ACTION_FROM_CASH_ID IN (SELECT CASH_ID FROM CASH WHERE (BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) OR IS_ALL_BRANCH = 1)) OR
                CASH_ACTION_TO_CASH_ID IN (SELECT CASH_ID FROM CASH WHERE (BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) OR IS_ALL_BRANCH = 1)))
			)
		</cfif>
	ORDER BY
		ACTION_ID ASC
</cfquery>
<cfif get_action_detail.recordcount neq 2>
	<br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
	<cfexit method="exittemplate">
</cfif>
<cf_catalystHeader>
<cfset attributes.pageHead = "#getlang('','',47099)#: #attributes.id#">
<cfform name="upd_cash_to_cash" id="upd_cash_to_cash" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_cash_to_cash" method="post">
    <input type="hidden" name="active_period"  id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
    <input type="hidden" name="ids" id="ids" value="<cfoutput>#attributes.id#,#attributes.id+1#</cfoutput>">
    <input type="hidden" name="action_id" id="action_id" value="<cfoutput>#attributes.id#</cfoutput>">
    <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
    <cfif listgetat(attributes.fuseaction,2,'.') is 'popup_upd_cash_to_cash'>
        <input type="hidden" name="is_popup" id="is_popup" value="1">
    <cfelse>
        <input type="hidden" name="is_popup" id="is_popup" value="0">
    </cfif>
    <div class="row">
        <div class="col col-12 uniqueRow">
            <div class="row formContent">
                <div class="row" type="row">
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-process_cat">
                            <label class="col col-4 col-xs-12">
                                <cfoutput>#getLang('main',388)# *</cfoutput>
                            </label>
                            <div class="col col-8 col-xs-12"><cf_workcube_process_cat process_cat=#get_action_detail.process_cat# slct_width="150"></div>
                        </div>
                        <div class="form-group" id="item-from_cash_id">
                            <label class="col col-4 col-xs-12">
                                <cfoutput>#getLang('cash',77)# *</cfoutput>
                            </label>
                            <div class="col col-8 col-xs-12">
                            <cf_wrk_Cash name="FROM_CASH_ID" id="FROM_CASH_ID" cash_status="1" currency_branch="0" value="#get_action_detail.CASH_ACTION_FROM_CASH_ID#" onChange="kur_ekle_f_hesapla('FROM_CASH_ID');">
                            </div>
                        </div>
                        <div class="form-group" id="item-to_cash_id">
                            <label class="col col-4 col-xs-12">
                                <cfoutput>#getLang('cash',26)# *</cfoutput>
                            </label>
                            <div class="col col-8 col-xs-12">
                            <cf_wrk_Cash name="TO_CASH_ID" id="TO_CASH_ID" is_virman= "1" cash_status="1" currency_branch="0"  value="#get_action_detail.CASH_ACTION_TO_CASH_ID[2]#" onChange="kur_ekle_f_hesapla('FROM_CASH_ID');change_currency_info();">
                            </div>
                        </div>
                        <div class="form-group" id="item-project_head">
                            <label class="col col-4 col-xs-12">
                                <cfoutput>#getLang('main',4)#</cfoutput>
                            </label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfoutput>
                                        <input type="hidden"  name="project_id" id="project_id" value="#get_action_detail.project_id#"/>
                                        <input type="text" style="width:150px" name="project_head" id="project_head" value="#get_action_detail.project_head#" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','148');" autocomplete="off" />
                                    </cfoutput>
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_cash_to_cash.project_id&project_head=add_cash_to_cash.project_head');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-paper_code">
                            <label class="col col-4 col-xs-12">
                                <cfoutput>#getLang('main',468)#</cfoutput>
                            </label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="paper_number" value="#get_action_detail.paper_no#">
                            </div>
                        </div>
                        <div class="form-group" id="item-action_date">
                            <label class="col col-4 col-xs-12">
                                <cfoutput>#getLang('main',330)# *</cfoutput>
                            </label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'></cfsavecontent>
                                    <cfinput required="Yes" validate="#validate_style#" message="#message#" type="text" name="ACTION_DATE" readonly value="#dateformat(get_action_detail.ACTION_DATE,dateformat_style)#">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="ACTION_DATE" call_function="change_money_info" control_date="#dateformat(get_action_detail.ACTION_DATE,dateformat_style)#"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-cash_action_value">
                            <label class="col col-4 col-xs-12">
                                <cfoutput>#getLang('main',261)# *</cfoutput>
                            </label>
                            <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang_main no='1738.Lutfen Tutar Giriniz'></cfsavecontent>
                                <cfinput type="text" name="CASH_ACTION_VALUE" class="moneybox" value="#TLFormat(get_action_detail.CASH_ACTION_VALUE)#"  onBlur="kur_ekle_f_hesapla('FROM_CASH_ID');" onkeyup="return(FormatCurrency(this,event));" required="yes" message="#message#">
                            </div>
                        </div>
                        <div class="form-group" id="item-other_cash_act_value">
                            <label class="col col-4 col-xs-12">
                                <cfoutput>#getLang('main',644)#</cfoutput>
                            </label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="OTHER_CASH_ACT_VALUE" value="#TLFormat(get_action_detail.OTHER_CASH_ACT_VALUE)#" style="width:150px;" class="moneybox" onBlur="kur_ekle_f_hesapla('FROM_CASH_ID',true);" onkeyup="return(FormatCurrency(this,event));">
                            </div>
                        </div>
                        <div class="form-group" id="item-detail">
                            <label class="col col-4 col-xs-12">
                                <cfoutput>#getLang('main',217)#</cfoutput>
                            </label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="ACTION_DETAIL" id="ACTION_DETAIL"><cfoutput>#get_action_detail.ACTION_DETAIL#</cfoutput></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group">
                            <label class="col col-12 bold"><cfoutput>#getLang('cash',87)#</cfoutput></label>
                            <div class="col col-12 scrollContent scroll-x2">
                                <cfscript>f_kur_ekle(action_id:URL.ID,process_type:1,base_value:'CASH_ACTION_VALUE',other_money_value:'OTHER_CASH_ACT_VALUE',form_name:'upd_cash_to_cash',action_table_name:'CASH_ACTION_MONEY',action_table_dsn:'#dsn2#',select_input:'FROM_CASH_ID',is_disable='1');</cfscript>
                            </div>
                        </div>
                        
                    </div>
                </div>
                <div class="row formContentFooter">
                <div class="col col-6">
                    <cf_record_info query_name="get_action_detail">
                </div>
                <div class="col col-6">
                    <cf_workcube_buttons
                        is_upd='1' update_status='#get_action_detail.UPD_STATUS#'
                        del_function_for_submit='del_kontrol()'
                        delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_cash_to_cash&paper_number=#get_action_detail.paper_no#&pageHead=#attributes.pageHead#&ids=#url.id#,#url.id+1#&old_process_type=#get_action_detail.action_type_id#'
                        add_function='kontrol()'>
                </div>
                </div>
            </div>
        </div>
    </div>
</cfform>
<script type="text/javascript">
	function del_kontrol()
	{
		return control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.action_type_id#'</cfoutput>);
		if(!chk_period(upd_cash_to_cash.ACTION_DATE, 'İşlem')) return false;
		else return true;
	}
	function unformat_fields()
	{
		upd_cash_to_cash.CASH_ACTION_VALUE.value = filterNum(upd_cash_to_cash.CASH_ACTION_VALUE.value);
		upd_cash_to_cash.OTHER_CASH_ACT_VALUE.value = filterNum(upd_cash_to_cash.OTHER_CASH_ACT_VALUE.value);
		upd_cash_to_cash.system_amount.value = filterNum(upd_cash_to_cash.system_amount.value);
		for(var i=1;i<=upd_cash_to_cash.kur_say.value;i++)
		{
			eval('upd_cash_to_cash.txt_rate1_' + i).value = filterNum(eval('upd_cash_to_cash.txt_rate1_' + i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			eval('upd_cash_to_cash.txt_rate2_' + i).value = filterNum(eval('upd_cash_to_cash.txt_rate2_' + i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
	}
	kur_ekle_f_hesapla('FROM_CASH_ID');
	function change_currency_info()
	{
		new_kur_say = document.all.kur_say.value;
		var currency_type_2 = list_getat(upd_cash_to_cash.TO_CASH_ID.options[upd_cash_to_cash.TO_CASH_ID.options.selectedIndex].value,2,';');
		for(var i=1;i<=new_kur_say;i++)
		{
			if(eval('document.all.hidden_rd_money_'+i) != undefined && eval('document.all.hidden_rd_money_'+i).value == currency_type_2)
				eval('document.all.rd_money['+(i-1)+']').checked = true;
		}
		kur_ekle_f_hesapla('FROM_CASH_ID');
	}	
	function virman_ekle_ac()
	{
		if (upd_cash_to_cash.is_popup.value == 1)
		{
			window.opener.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.form_add_cash_to_cash';
			window.close();
		}
		else
		{
			window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.form_add_cash_to_cash';	
		}
	}
	function kontrol()
	{
		var dsn = '<cfoutput>#dsn2#</cfoutput>';
		if(!paper_no_control(0,dsn,'CASH_ACTIONS','ACTION_TYPE_ID*33','PAPER_NO','CASH_TO_CASH',0,'paper_number','ACTION_ID-action_id','<cfoutput>#attributes.id + 1#</cfoutput>')) return false;
		control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.action_type_id#'</cfoutput>);
		if(document.upd_cash_to_cash.TO_CASH_ID.value == document.upd_cash_to_cash.FROM_CASH_ID.value)				
		{
			alert("<cf_get_lang no='47.Seçtiğiniz Kasalar Aynı!'>");		
			return false; 
		}
		if(!chk_period(upd_cash_to_cash.ACTION_DATE,'İşlem'))
			return false;
		
		if ((document.upd_cash_to_cash.ACTION_DETAIL.value.length) > 250) 
		{ 
			alert("<cf_get_lang no ='201.Açıklama bilgisi 250 karakterden fazla girilemez'>");
			return false;
		}
		
		if(!chk_process_cat('upd_cash_to_cash')) return false;
		if(!check_display_files('upd_cash_to_cash')) return false;
		kur_ekle_f_hesapla('FROM_CASH_ID');
		unformat_fields();
		return true;
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
