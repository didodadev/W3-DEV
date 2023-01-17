<cf_xml_page_edit>
<cfinclude template="../query/get_money.cfm">
<cfquery name="get_branchs" datasource="#dsn#">
	SELECT 
		BRANCH_ID,BRANCH_NAME 
	FROM 
		BRANCH 
	WHERE
		BRANCH_STATUS = 1 
		AND COMPANY_ID = #session.ep.company_id#
	<cfif session.ep.isBranchAuthorization>
		AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	</cfif>
	ORDER BY BRANCH_NAME
</cfquery>
<cf_catalystHeader>
	<cfform name="add_account_to_account" method="post" action="#request.self#?fuseaction=account.emptypopup_add_account_to_account_act">
    	<div class="row">
			<div class="col col-12 uniqueRow">
            	<div class="row formContent">
                	<div class="row" type="row">
                    	<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                        	<div class="form-group" id="item-action_date">
                            	<label class="col col-4 col-xs-12"><cf_get_lang_main no='330.Tarih'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang_main no='1091.Lütfen işlem tarihini giriniz'></cfsavecontent>
                                        <cfinput validate="#validate_style#" required="Yes" maxlength="10" message="#message#" type="text" name="ACTION_DATE" value="#dateformat(now(),dateformat_style)#" style="width:175px;">
                                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="ACTION_DATE"></span>
                                	</div>
                                </div>
                            </div>
                            <cfif xml_acc_branch_info and session.ep.isBranchAuthorization eq 0>
                                <div class="form-group" id="item-BRANCH_ID">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='41.Şube'></label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="acc_branch_id" id="acc_branch_id" style="width:175px;">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            <cfoutput query="get_branchs">
                                                <option value="#BRANCH_ID#">#BRANCH_NAME#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                            </cfif>
                            <cfif xml_acc_department_info and session.ep.isBranchAuthorization eq 0>
                                <div class="form-group" id="item-acc_department_id">
                                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='160.Departman'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="acc_department_id" id="acc_department_id" value="">
                                            <input type="text" name="acc_department_name" id="acc_department_name"  value="" style="width:175px;">
                                            <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang_main no='322.seçiniz'>" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=add_account_to_account.acc_department_id&field_dep_branch_name=add_account_to_account.acc_department_name','list');"></span>
                                        </div>
                                    </div>
                                </div>
                            </cfif>
                            <div class="form-group" id="item-to_account_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang no='7.Borçlu Hesap'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input name="to_account_name" id="to_account_name" type="hidden" style="width:175px;">
                                        <cfsavecontent variable="message1"><cf_get_lang_main no='59.Eksik veri'>:<cf_get_lang no='7.borçlu hesap'></cfsavecontent>
                                        <cfinput type="text" name="to_account_id" id="to_account_id" required="yes" message="#message1#" style="width:175px;" onFocus="AutoComplete_Create('to_account_id','ACCOUNT_CODE','ACCOUNT_CODE,CODE_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','CODE_NAME','','3','250');">
                                        <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang_main no='322.seçiniz'>" onclick="open_acc_list();"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-from_account_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='34115.Alacaklı hesap'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input name="from_account_name" id="from_account_name" type="hidden" style="width:175;">
                                        <cfsavecontent variable="message1"><cf_get_lang_main no='59.Eksik veri'>:<cf_get_lang dictionary_id='34115.alacaklı hesap'></cfsavecontent>
                                        <cfinput name="from_account_id" id="from_account_id" required="yes" message="#message1#" style="width:175px;" type="text"onFocus="AutoComplete_Create('from_account_id','ACCOUNT_CODE','ACCOUNT_CODE,CODE_NAME','get_account_code','\'0\',0','CODE_NAME','from_account_name','','3','250');">
                                        <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang_main no='322.seçiniz'>" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_account_to_account.from_account_id&field_name=add_account_to_account.from_account_name','list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-ACTION_VALUE">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='261.Tutar'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message1"><cf_get_lang_main no='59.Eksik veri'>:<cf_get_lang_main no='261.Tutar'></cfsavecontent>
									<cfinput type="text" name="ACTION_VALUE" value="" required="yes" message="#message1#" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:175px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-to_account_value">
                                <label class="col col-4 col-xs-12"><cf_get_lang no='124.Borçlu Döviz Tutar'></label>
                                <div class="col col-8 col-xs-12">
                                   	<div class="input-group">
                                        <cfinput type="text" name="to_account_value" value="" class="moneybox" onkeyup="return(FormatCurrency(this,event));" style="width:122px;"><!--- required="yes" message="#message1#" --->
                                        <span class="input-group-addon no-bg">
                                            <select name="to_money_type" id="to_money_type" style="width:50px;">					
                                                <cfoutput query="GET_MONEY">
                                                    <option value="#money#">#money#</option>
                                                </cfoutput>
                                            </select>	
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-from_account_value">
                                <label class="col col-4 col-xs-12"><cf_get_lang no='125.Alacaklı Döviz Tutar'></label>
                                <div class="col col-8 col-xs-12">
                                   	<div class="input-group">
                                        <cfinput type="text" name="from_account_value" value="" class="moneybox" onkeyup="return(FormatCurrency(this,event));" style="width:122px;"><!--- required="yes" message="#message1#" --->
										<span class="input-group-addon no-bg">
                                            <select name="from_money_type" id="from_money_type" style="width:50px;">					
												<cfoutput query="GET_MONEY">
                                                    <option value="#money#">#money#</option>
                                                </cfoutput>
                                            </select>	
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-bill_detail">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
                                <div class="col col-8 col-xs-12">
                                   	<textarea name="bill_detail" id="bill_detail" style="width:175px;height:65px;"></textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row formContentFooter">
                    	<div class="col col-12">
                        	<cf_workcube_buttons type_format='1' is_upd='0' add_function="kontrol()">
                        </div>
                    </div>
                </div>
            </div>        
        </div>
	</cfform>
<script type="text/javascript">
	function unformat_fields()
	{
		fld=document.add_account_to_account.ACTION_VALUE;
		fld.value=filterNum(fld.value);
		document.add_account_to_account.to_account_value.value = filterNum(document.add_account_to_account.to_account_value.value);
		document.add_account_to_account.from_account_value.value = filterNum(document.add_account_to_account.from_account_value.value);
	}
	function open_acc_list()
	{
	   windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_account_to_account.to_account_id&field_name=add_account_to_account.to_account_name','list');
	}
	
	function kontrol()
	{
		if (!chk_period(document.add_account_to_account.ACTION_DATE,'İşlem')) return false;
		if (document.add_account_to_account.to_account_id.value == document.add_account_to_account.from_account_id.value && document.add_account_to_account.from_account_id.value !='' )				
		{
			alert("<cf_get_lang dictionary_id='47303.Seçtiğiniz Hesaplar Aynı'>!");		
			return false; 
		}
		return(unformat_fields());
	}
</script>
