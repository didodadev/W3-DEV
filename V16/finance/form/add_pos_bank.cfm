<cfquery name="BRANCHES" datasource="#dsn#">
	SELECT * FROM BRANCH WHERE COMPANY_ID = #session.ep.company_id# ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="GET_ACCOUNTS" datasource="#dsn3#">
	SELECT
		*
	FROM
		ACCOUNTS,
		BANK_BRANCH
	WHERE
		ACCOUNTS.ACCOUNT_BRANCH_ID=BANK_BRANCH.BANK_BRANCH_ID AND
		ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn_alias#.SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id#)
	ORDER BY
		BANK_NAME,
		ACCOUNT_NAME
</cfquery>
<!--- Pos Cihazi Ekle --->
<cfparam  name="attributes.modal_id" default="">
<cf_box title="#getLang('','Banka','57521')##getLang('','Pos Tanımları','47182')#"popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_pos" id="add_pos" action="#request.self#?fuseaction=finance.emptypopup_add_pos_bank" method="post">
        <input type="hidden" name="modal_id" id="modal_id" value="<cfoutput>#attributes.modal_id#</cfoutput>">
        <cf_box_elements>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-pos_code">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='54804.Cihaz Kodu'> *</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput type="Text" name="pos_code"  maxlength="30" required="yes">
                        </div>
                    </div>
                    <div class="form-group" id="item-equipment">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='54805.Cihaz Adı'> *</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput type="Text" name="equipment"  maxlength="100" required="yes">									 
                        </div>
                    </div>                            
                    <div class="form-group" id="item-seller_code">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='54806.İşyeri Kodu'> *</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput type="text" name="seller_code"  maxlength="30" required="yes">                                    									 
                        </div>
                    </div>                                  
                    <div class="form-group" id="item-account_id">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57652.Hesap'> *</label><!---Bank hesapları gelir,daha sonra pos dönüşlerinde bu postaki hesaba göre gelen banka talimatı işlemi yapılır Ayşenur20060412 --->
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="account_id" id="account_id" >
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_accounts">
                                    <option value="#ACCOUNT_ID#">#ACCOUNT_NAME#&nbsp;#ACCOUNT_CURRENCY_ID#</option>
                                </cfoutput>
                            </select>		                             									 
                        </div>
                    </div>
                    <div class="form-group" id="item-branch_id">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'> *</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="branch_id" id="branch_id" >
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="branches">
                                    <option value="#branch_ID#">#branch_name#</option>
                                </cfoutput>
                            </select>                                   	                             									 
                        </div>
                    </div> 
                </div>    
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">                        
                    <div class="form-group" id="item-assetp">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58833.Fiziki Varlık'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                <input type="hidden" name="assetp_id" id="assetp_id" value="">
                                <input type="text" name="assetp" id="assetp" >
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_assets&field_id=add_pos.assetp_id&field_name=add_pos.assetp&event_id=0');"></span>   	                             									 
                            </div>
                        </div>
                    </div>  
                    <div class="form-group" id="item-company_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='54808.Cari Kurumsal'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                <input type="hidden" name="company_id" id="company_id" value="">
                                <input  type="text" name="company_name" id="company_name" >
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_comp_id=add_pos.company_id&field_comp_name=add_pos.company_name&select_list=2');"></span>   	                             									 
                            </div>
                        </div>
                    </div>                                                           
                    <div class="form-group" id="item-pos_code_text1">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='54577.Kasiyer'> 1</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                <input type="hidden" name="pos_code1" id="pos_code1" value="">
                                <input readonly type="text" name="pos_code_text1" id="pos_code_text1" >
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_pos.pos_code1&field_name=add_pos.pos_code_text1&select_list=1');"></span>   	                             									 
                            </div>
                        </div>
                    </div>                                                              
                    <div class="form-group" id="item-pos_code_text2">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='54577.Kasiyer'> 2</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                <input type="hidden" name="pos_code2" id="pos_code2" value="">
                                <input  type="text" name="pos_code_text2" id="pos_code_text2" >
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_pos.pos_code2&field_name=add_pos.pos_code_text2&select_list=1');"></span>   	                             									 
                            </div>
                        </div>
                    </div> 
                </div>
        </cf_box_elements>
        <cf_box_footer>
            <div class="col col-12"> 
                <div id="workcube_button" class="pull-right">
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()&&#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_pos' , #attributes.modal_id#)"),DE(""))#'>                      
                </div>
            </div>
        </cf_box_footer>	
	</cfform>
</cf_box>

<script type="text/javascript">
	function kontrol()
	{
        if(!$("#assetp").val().length)
		{
			
			$("#assetp_id").val('');
		}
		if(!$("#company_name").val().length)
		{
			
			$("#company_id").val('');
		}
        if(!$("#pos_code_text2").val().length)
		{
			
			$("#pos_code2").val('');
		}
		if(!$("#pos_code_text1").val().length)
		{
			
			$("#pos_code1").val('');
		}
		if(!$("#pos_code").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='54811.Cihaz Kodu Girmelisiniz'>!</cfoutput>"})    
			return false;
		}
		if(!$("#equipment").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='54584.Cihaz Adı Girmelisiniz'></cfoutput>"})    
			return false;
		}
		if(!$("#seller_code").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='54807.İşyeri Kodu Girmelisiniz'>!</cfoutput>"})    
			return false;
		}
		if(!$("#account_id").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='49008.Lütfen Hesap Seçiniz'></cfoutput>"})    
			return false;
		}
		
		x = document.add_pos.branch_id.selectedIndex;
		if (document.add_pos.branch_id[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='58579.Lütfen Şube Seçiniz'> !");
			return false;
		}
	}
</script>
