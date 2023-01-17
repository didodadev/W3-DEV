<!--- Ömer Turhan'ın isteği üzerine masraf/gelir merkezi ve bütçe kalemi inputları kaldırıldı. --->
<cf_get_lang_set module_name="cash">
<cfset cash_status = 1>
<cfinclude template="../query/control_bill_no.cfm">
<cfif isdefined("url.id") and len(url.id) and not isdefined("is_virman_act")>
	<cfquery name="GET_CACHES" datasource="#DSN2#">
	 	SELECT
			*
		FROM
			CASH_ACTIONS
		WHERE
			CASH_ACTIONS.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"> 
	</cfquery>
</cfif>
<cf_catalystHeader>
<cf_papers paper_type="cash_payment">
<cf_box title="#getlang('','Nakit ödeme','63540')#">
<cfform name="add_cash_payment" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_cash_payment">
    <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
    <input type="hidden" name="money_type_id" id="money_type_id" value="<cfif isdefined("attributes.money_type") and len(attributes.money_type)><cfoutput>#attributes.money_type#</cfoutput></cfif>">
    <input type="hidden" name="order_id" id="order_id" value="<cfif isdefined("attributes.order_id")><cfoutput>#attributes.order_id#</cfoutput></cfif>">
    <input type="hidden" name="order_row_id" id="order_row_id" value="<cfif isdefined("attributes.order_row_id")><cfoutput>#attributes.order_row_id#</cfoutput></cfif>">
    <input type="hidden" name="correspondence_info" id="correspondence_info" value="<cfif isdefined("attributes.correspondence_info")><cfoutput>#attributes.correspondence_info#</cfoutput></cfif>">
        <cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true"><!---/// Kolon  type column verilecek sort duruma göre true false--->
                            <div class="form-group" id="item-process_cat">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61806.işlem tipi'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <cfif isdefined("url.id") and len(url.id)>
                                        <cf_workcube_process_cat process_cat=#get_caches.process_cat# slct_width="175">
                                    <cfelse>
                                        <cf_workcube_process_cat slct_width="175">
                                    </cfif>
                                </div>
                            </div>
                            <div class="form-group" id="item-CASH_ACTION_FROM_CASH_ID">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57520.Kasa'></label>
                                <div class="col col-8 col-xs-12">
                                <cfif isdefined("get_caches.CASH_ACTION_FROM_CASH_ID") and len(get_caches.CASH_ACTION_FROM_CASH_ID)>
                                     <cf_wrk_Cash name="CASH_ACTION_FROM_CASH_ID"  currency_branch="0" CASH_STATUS="1" value="#get_caches.CASH_ACTION_FROM_CASH_ID#" onChange="kur_ekle_f_hesapla('CASH_ACTION_FROM_CASH_ID');">   
                                <cfelse>
                                    <cf_wrk_Cash name="CASH_ACTION_FROM_CASH_ID"  currency_branch="0" CASH_STATUS="1" onChange="kur_ekle_f_hesapla('CASH_ACTION_FROM_CASH_ID');">
                                </cfif>    
                                </div>
                            </div>
                            <cfif isdefined("url.id") and len(get_caches.CASH_ACTION_TO_COMPANY_ID)>
                                <cfset member_name = get_par_info(get_caches.CASH_ACTION_TO_COMPANY_ID,1,1,0)>
                            <cfelseif isdefined("url.id") and len(get_caches.CASH_ACTION_TO_CONSUMER_ID) >
                                <cfset member_name = get_cons_info(get_caches.CASH_ACTION_TO_CONSUMER_ID,0,0)>
                            </cfif>
                            <div class="form-group" id="item-special_definition_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58928.Ödeme Tipi'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfif isdefined("url.id") and len(url.id)>
                                        <cf_wrk_special_definition width_info='175' type_info='2' field_id="special_definition_id" selected_value='#get_caches.special_definition_id#'>
                                    <cfelse>
                                        <cf_wrk_special_definition width_info='175' type_info='2' field_id="special_definition_id"></td>
                                    </cfif>
                                </div>
                            </div>
                            <div class="form-group" id="item-CASH_ACTION_TO_COMPANY_ID">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'>*</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                    <cfif isdefined("url.id") and len(url.id) and len(get_caches.CASH_ACTION_TO_EMPLOYEE_ID)>
                                        <cfset emp_id = get_caches.CASH_ACTION_TO_EMPLOYEE_ID>
                                        <cfif len(get_caches.acc_type_id)>
                                            <cfset emp_id = "#emp_id#_#get_caches.acc_type_id#">
                                        <cfelse>
                                            <cfset acc_type_id = ''>
                                        </cfif>
                                    <cfelse>
                                        <cfset acc_type_id = ''>
                                    </cfif>
                                    <input type="hidden" name="EMPLOYEE_ID" id="EMPLOYEE_ID" value="<cfif isdefined("url.id") and len(get_caches.CASH_ACTION_TO_EMPLOYEE_ID)><cfoutput>#emp_id#</cfoutput><cfelseif isdefined('attributes.employee_id') and len(attributes.employee_id)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
                                    <input type="hidden" name="CASH_ACTION_TO_COMPANY_ID" id="CASH_ACTION_TO_COMPANY_ID" value="<cfif isdefined("url.id") and len(url.id)><cfoutput>#get_caches.CASH_ACTION_TO_COMPANY_ID#</cfoutput><cfelseif isdefined('attributes.company_id') and len(attributes.company_id) ><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                                    <input type="hidden" name="CASH_ACTION_TO_CONSUMER_ID" id="CASH_ACTION_TO_CONSUMER_ID" value="<cfif isdefined("url.id") and len(url.id)><cfoutput>#get_caches.CASH_ACTION_TO_CONSUMER_ID#</cfoutput><cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
                                
                                    <cfif isdefined('attributes.employee_id') and listlen(attributes.employee_id,'_') eq 2>
                                        <cfset acc_type_id = listlast(attributes.employee_id,'_')>
                                        <cfset attributes.employee_id = listfirst(attributes.employee_id,'_')>
                                    </cfif>
                                    <input type="text" name="company_name" id="company_name" 
                                    onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'\',\'0\',\'1\',\'\',\'0\'','CONSUMER_ID,COMPANY_ID,EMPLOYEE_ID','CASH_ACTION_TO_CONSUMER_ID,CASH_ACTION_TO_COMPANY_ID,EMPLOYEE_ID','','2','250','get_money_info(\'add_cash_payment\',\'action_date\')');" 
                                    value="<cfif isdefined("url.id") and len(get_caches.CASH_ACTION_TO_COMPANY_ID)><cfoutput>#get_par_info(get_caches.CASH_ACTION_TO_COMPANY_ID,1,1,0)#</cfoutput>
                                    <cfelseif isdefined("url.id") and len(get_caches.CASH_ACTION_TO_CONSUMER_ID)><cfoutput>#get_cons_info(get_caches.CASH_ACTION_TO_CONSUMER_ID,0,0)#</cfoutput>
                                    <cfelseif isdefined("url.id") and len(get_caches.CASH_ACTION_TO_EMPLOYEE_ID)><cfoutput>#get_emp_info(get_caches.CASH_ACTION_TO_EMPLOYEE_ID,0,0,0,get_caches.acc_type_id)#</cfoutput>
                                    <cfelseif isdefined('attributes.company_id') and len(attributes.company_id)>
                                    <cfoutput>#get_par_info(attributes.company_id,1,1,0)#</cfoutput><cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)><cfoutput>#get_cons_info(attributes.consumer_id,0,0)#</cfoutput><cfelseif isdefined('attributes.employee_id') and len(attributes.employee_id)><cfoutput>#get_emp_info(attributes.employee_id,0,0,0,acc_type_id)#</cfoutput></cfif>" style="width:175px;">
                                    <span class="input-group-addon icon-ellipsis" onclick="hesap_sec(); windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_cari_action=1&field_comp_id=add_cash_payment.CASH_ACTION_TO_COMPANY_ID&field_name=add_cash_payment.company_name&field_emp_id=add_cash_payment.EMPLOYEE_ID&field_consumer=add_cash_payment.CASH_ACTION_TO_CONSUMER_ID&field_member_name=add_cash_payment.company_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3,1,9','list','popup_list_pars');"></span>
                                    <input type="hidden" name="exp_emp_id" id="exp_emp_id" value="">
                                    <input type="hidden" name="exp_emp_name" id="exp_emp_name" value="" style="width:175px;" readonly> 
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-paper_number">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'>*</label>
                                <div class="col col-8 col-xs-12">
                                    <cfif len(paper_code) and len(paper_number)><cfset paper_info = paper_code & '-' & paper_number><cfelse><cfset paper_info = ""></cfif>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id ='58556.Belge No Giriniz'>!</cfsavecontent>
                                    <cfinput type="text" name="paper_number" value="#paper_info#" maxlength="20" required="yes" message="#message#" style="width:175px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-action_date">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'>*</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57742.Tarih'>!</cfsavecontent>
                                        <cfif isdefined("url.id") and len(url.id)>
                                            <cfinput value="#dateformat(get_caches.ACTION_DATE,dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#" type="text" name="action_date" style="width:100px;" onBlur="change_money_info('add_cash_payment','action_date');">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="action_date" call_function="change_money_info" control_date="#dateformat(get_caches.ACTION_DATE,dateformat_style)#"></span>
                                        <cfelse>
                                        <cfif isdefined('attributes.date1')>
                                            <cfinput value="#attributes.date1#" validate="#validate_style#" required="Yes" message="#message#" type="text" name="action_date" style="width:175px;" onBlur="change_money_info('add_cash_payment','action_date');">
                                        <cfelse>
                                            <cfinput value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#" type="text" name="action_date" style="width:175px;" onBlur="change_money_info('add_cash_payment','action_date');">
                                        </cfif>
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="action_date" call_function="change_money_info"></span>
                                        </cfif>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-cash_action_value">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'> *</label>
                            <div class="col col-8 colxs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tutar Giriniz'></cfsavecontent>
                                <cfif isdefined("url.id") and len(url.id)>
                                    <cfinput type="text" name="cash_action_value" value="#TLFormat(get_caches.CASH_ACTION_VALUE)#" class="moneybox" required="yes" onBlur="kur_ekle_f_hesapla('CASH_ACTION_FROM_CASH_ID');" onkeyup="return(FormatCurrency(this,event));" message="#message#" style="width:175px;">
                                <cfelse>
                                <cfif isdefined("attributes.order_amount") and len(attributes.order_amount)>
                                    <cfinput type="text" name="cash_action_value" class="moneybox" required="yes" readonly="yes" value="#TLFormat(abs(attributes.order_amount))#" onBlur="kur_ekle_f_hesapla('CASH_ACTION_FROM_CASH_ID');" onkeyup="return(FormatCurrency(this,event));" message="#message#" style="width:175px;">
                                <cfelse> 
                                    <cfinput type="text" name="cash_action_value" class="moneybox" required="yes" onBlur="kur_ekle_f_hesapla('CASH_ACTION_FROM_CASH_ID');" onkeyup="return(FormatCurrency(this,event));" message="#message#" style="width:175px;">
                                </cfif>	
                                </cfif>
                            </div>
                        </div>
                            <div class="form-group" id="item-other_cash_act_value">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58056.Dövizli Tutar'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfif isdefined("url.id") and len(url.id)>
                                        <cfinput type="text" id="other_cash_act_value" name="other_cash_act_value" value="#TLFormat(get_caches.OTHER_CASH_ACT_VALUE)#" class="moneybox" style="width:175px;" onBlur="kur_ekle_f_hesapla('CASH_ACTION_FROM_CASH_ID',true);" onkeyup='return(FormatCurrency(this,event));'>
                                    <cfelse>
                                    <cfif isdefined("attributes.order_amount") and len(attributes.order_amount)><!--- ödeme emrinden geldlgl durumda --->
                                        <cfinput type="text" id="other_cash_act_value" name="other_cash_act_value" readonly="yes" class="moneybox" style="width:175px;" value="" onBlur="kur_ekle_f_hesapla('CASH_ACTION_FROM_CASH_ID',true);" onkeyup="return(FormatCurrency(this,event));">
                                    <cfelse>
                                        <cfinput type="text" id="other_cash_act_value" name="other_cash_act_value" class="moneybox" style="width:175px;" value="" onBlur="kur_ekle_f_hesapla('CASH_ACTION_FROM_CASH_ID',true);" onkeyup="return(FormatCurrency(this,event));">
                                    </cfif>
                                    </cfif>
                                </div>
                            </div>
                            <cfif isdefined("url.id") and len(get_caches.project_id)>
                                <cfset attributes.project_id = get_caches.project_id>
                            </cfif>
                            <div class="form-group" id="item-project_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                                <div class="col col-8 col-xs-12">
                                   <div class="input-group">
                                    <input type="hidden" name="project_id" id="project_id" value="<cfif isDefined("attributes.project_id") and len(attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
                                    <input name="project_name" type="text" id="project_name" style="width:175px;"  onFocus="AutoComplete_Create('project_name','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" value="<cfif isDefined("attributes.project_id") and len(attributes.project_id)><cfoutput>#get_project_name(attributes.project_id)#</cfoutput></cfif>" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=add_cash_payment.project_name&project_id=add_cash_payment.project_id</cfoutput>')"></span>
                                   </div>
                                </div>
                            </div>
                            <cfif session.ep.our_company_info.asset_followup eq 1>
                            <div class="form-group" id="item-asset_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58833.Fiziki Varlık'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfif isdefined("url.id") and len(url.id)>
                                        <cf_wrkAssetp asset_id="#get_caches.assetp_id#" fieldId='asset_id' fieldName='asset_name' form_name='add_cash_payment' width='175'>
                                    <cfelse>
                                        <cf_wrkAssetp fieldId='asset_id' fieldName='asset_name' form_name='add_cash_payment' width='175'>
                                    </cfif>
                                </div>
                            </div>
                            </cfif>
                            <div class="form-group" id="item-PAYER_ID">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33207.Ödeme Yapan'>*</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="PAYER_ID" id="PAYER_ID" value="<cfif isdefined("url.id") and len(url.id)><cfoutput>#get_caches.PAYER_ID#</cfoutput><cfelse><cfoutput>#session.ep.userid#</cfoutput></cfif>">
                                        <input type="text" name="PAYER_NAME" id="PAYER_NAME" value="<cfif isdefined("url.id") and len(url.id)><cfoutput>#get_emp_info(get_caches.PAYER_ID,0,0)#</cfoutput><cfelse><cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput></cfif>" style="width:175px;" onFocus="AutoComplete_Create('PAYER_NAME','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','PAYER_ID','add_cash_payment','3','125');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_cash_payment.PAYER_ID&field_name=add_cash_payment.PAYER_NAME<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1','list','popup_list_positions')"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-ACTION_DETAIL">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea name="ACTION_DETAIL" id="ACTION_DETAIL" style="width:175px;height:40px;"><cfif isdefined("url.id") and len(url.id)><cfoutput>#get_caches.ACTION_DETAIL#</cfoutput></cfif></textarea>
                                </div>
                            </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group">
                            <label class="col col-4 bolt"><cf_get_lang dictionary_id='35578.İşlem Para Br'></label>
                        </div>
                        <div class="form-group">
                        <div class="col col-12">
                            <label class="col col-2 col-xs-12"></label>
                            <div class="col col-10 col-xs-12">
                                <cfif isdefined("url.id") and len(url.id)>
                                    <cfscript>f_kur_ekle(action_id:attributes.id,process_type:1,base_value:'cash_action_value',other_money_value:'other_cash_act_value',form_name:'add_cash_payment',action_table_name:'CASH_ACTION_MONEY',action_table_dsn:'#dsn2#',select_input:'CASH_ACTION_FROM_CASH_ID');</cfscript>
                                <cfelse>
                                    <cfscript>f_kur_ekle(process_type:0,base_value:'cash_action_value',other_money_value:'other_cash_act_value',form_name:'add_cash_payment',select_input:'CASH_ACTION_FROM_CASH_ID');</cfscript>
                                </cfif>
                            </div>
                        </div>
                     </div>
                    </div>                        
                </cf_box_elements>
                <cf_box_footer>
                    <div class="col col-12 text-right"><cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'></div> <!---///butonlar--->
                    </cf_box_footer>        
</cfform>
</cf_box>
<script type="text/javascript">
	function hesap_sec()
	{
		if(document.add_cash_payment.CASH_ACTION_TO_COMPANY_ID.value!='')
		{
			document.add_cash_payment.CASH_ACTION_TO_COMPANY_ID.value='';
			document.add_cash_payment.company_name.value='';
		}
		if(document.add_cash_payment.EMPLOYEE_ID.value!='')
		{
			document.add_cash_payment.EMPLOYEE_ID.value='';
			document.add_cash_payment.company_name.value='';
		}
		if(document.add_cash_payment.CASH_ACTION_TO_CONSUMER_ID.value!='')
		{
			document.add_cash_payment.CASH_ACTION_TO_CONSUMER_ID.value='';
			document.add_cash_payment.company_name.value='';
		}
	}
	function kontrol()
	{
		<!---if(!paper_control(add_cash_payment.paper_number,'CASH_PAYMENT')) return false;--->
		if(!chk_process_cat('add_cash_payment')) return false;
		if(!check_display_files('add_cash_payment')) return false;
		if(document.getElementById('CASH_ACTION_FROM_CASH_ID').value=="")
		{
			alert('Kasa Seçiniz');
		}
		if(document.add_cash_payment.PAYER_NAME.value=='' )	
		{
			alert("<cf_get_lang dictionary_id='49847.Lütfen Ödeme Yapanı Giriniz !'>");
			return false;
		}
		if(document.add_cash_payment.company_name.value!="" )
		{
			if (!chk_period(add_cash_payment.action_date, 'Cari Ödeme')) return false;
		}
		else
		{
			alert("<cf_get_lang dictionary_id='49805.Lütfen Ödeme Yapılan Kişi,Yapan Kişi Veya Çalışanı Seçiniz !'>");
			return false;
		}
		if((add_cash_payment.CASH_ACTION_TO_COMPANY_ID.value =="") && (add_cash_payment.CASH_ACTION_TO_CONSUMER_ID.value =="") && (add_cash_payment.EMPLOYEE_ID.value ==""))
		{
			alert("<cf_get_lang dictionary_id ='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id ='57519.Cari Hesap'>");
			return false;
		}
		deger1=list_getat(document.add_cash_payment.CASH_ACTION_FROM_CASH_ID.value,2,';');
		if ((document.add_cash_payment.money_type_id.value != '')&&(deger1 != document.add_cash_payment.money_type_id.value))
		{
			if (!confirm("<cf_get_lang dictionary_id ='49921.Kasanın para birimi ödeme emrinin para biriminden farklı'>!"))
			return false;
		}
		var parameter = '-1*' + document.add_cash_payment.paper_number.value + '*32*12';<!--- ödeme işlemine göre paper_no unique olmalı. 32 ödeme işlemi action_type_id, 12 tediye fişi--->
		var parameter_2 = document.add_cash_payment.paper_number.value + '*12';
		var get_paper_no = wrk_safe_query('csh_get_paper_no_3','dsn2',0,parameter);
		var get_paper_from_account = wrk_safe_query('acc_get_paper_no','dsn2',0,parameter_2);
		if(get_paper_no.recordcount || get_paper_from_account.recordcount)
		{
			alert("<cf_get_lang dictionary_id='59366.Girdiğiniz Belge Numarası Kullanılmaktadır'> !");
			if(document.getElementById('paper_number').value.indexOf("-") > 0 )
			{
				var index=document.getElementById('paper_number').value.indexOf("-")+1;
				var index2=document.getElementById('paper_number').value.length;
				var temp = parseInt(document.getElementById('paper_number').value.substring(index,index2));
				temp = temp +1;
				document.getElementById('paper_number').value = document.getElementById('paper_number').value.substring(0,index-1) + '-' + temp;
			}
			else
			{
				document.getElementById('paper_number').value = parseInt(document.getElementById('paper_number').value) + 1;	
			}
			return false;
		}
		return true;
	}
	function unformat_fields() 
	{
		document.add_cash_payment.exp_emp_id.value = document.add_cash_payment.EMPLOYEE_ID.value;
	}
	kur_ekle_f_hesapla('CASH_ACTION_FROM_CASH_ID');
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
