<!--- Ömer Turhan'ın isteği üzerine masraf/gelir merkezi ve bütçe kalemi inputları kaldırıldı. --->
<cf_get_lang_set module_name="cash">
<cfset refmodule="#listgetat(attributes.fuseaction,1,'.')#">
<cfset attributes.table_name = 'CASH_ACTIONS'>
<cfset attributes.id = attributes.id>
<cfset url.id = attributes.id>
<!---<cfinclude template="../query/get_cashes.cfm">--->
<cfinclude template="../query/get_action_detail.cfm">
<cfif not get_action_detail.recordcount>
	<br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
	<cfexit method="exittemplate">
</cfif>
<cf_catalystHeader>
    <cf_box title="#getlang('','Nakit ödeme','63540')#">
	<cfform name="upd_cash_payment">
		<input type="hidden" name="id"  id="id" value="<cfoutput>#attributes.id#</cfoutput>">
		<cfif listgetat(attributes.fuseaction,2,'.') is 'popup_upd_cash_payment'>
			<input type="hidden" name="is_popup" id="is_popup" value="1">
		<cfelse>
			<input type="hidden" name="is_popup" id="is_popup" value="0">
		</cfif>
		<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
            <cf_box_elements>
                    	<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        	<div class="form-group" id="item-process_cat">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61806.işlem tipi'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <cf_workcube_process_cat process_cat=#get_action_detail.process_cat# slct_width="175">
                                </div>
                            </div>
                            <div class="form-group" id="item-CASH_ACTION_FROM_CASH_ID">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57520.Kasa'></label>
                                <div class="col col-8 col-xs-12">
                                   <cf_wrk_Cash name="CASH_ACTION_FROM_CASH_ID" value="#get_action_detail.CASH_ACTION_FROM_CASH_ID#" currency_branch="0" onChange="kur_ekle_f_hesapla('CASH_ACTION_FROM_CASH_ID');">
                                </div>
                            </div>
                            <div class="form-group" id="item-special_definition_id">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58928.Ödeme Tipi'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_wrk_special_definition width_info='175' type_info='2' field_id="special_definition_id" selected_value='#get_action_detail.special_definition_id#'>
                                </div>
                            </div>
                            <cfif len(get_action_detail.CASH_ACTION_TO_COMPANY_ID)>
								<cfset member_name = get_par_info(get_action_detail.CASH_ACTION_TO_COMPANY_ID,1,1,0)>
                            <cfelse>
                                <cfset member_name = get_cons_info(get_action_detail.CASH_ACTION_TO_CONSUMER_ID,0,0)>
                            </cfif>
                            <div class="form-group" id="item-CASH_ACTION_TO_COMPANY_ID">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'>*</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                    	<cfset emp_id = get_action_detail.CASH_ACTION_TO_EMPLOYEE_ID>
										<cfif len(get_action_detail.acc_type_id)>
                                            <cfset emp_id = "#emp_id#_#get_action_detail.acc_type_id#">
                                        </cfif>
                                        <input type="hidden" name="EMPLOYEE_ID" id="EMPLOYEE_ID" value="<cfoutput>#emp_id#</cfoutput>">
                                        <input type="hidden" name="CASH_ACTION_TO_COMPANY_ID" id="CASH_ACTION_TO_COMPANY_ID" value="<cfoutput>#get_action_detail.CASH_ACTION_TO_COMPANY_ID#</cfoutput>">
                                        <input type="hidden" name="CASH_ACTION_TO_CONSUMER_ID" id="CASH_ACTION_TO_CONSUMER_ID" value="<cfoutput>#get_action_detail.CASH_ACTION_TO_CONSUMER_ID#</cfoutput>">
                                        <input type="text" name="company_name" id="company_name" onFocus= "AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','CONSUMER_ID,COMPANY_ID,EMPLOYEE_ID','CASH_ACTION_TO_CONSUMER_ID,CASH_ACTION_TO_COMPANY_ID,EMPLOYEE_ID','','2','250','get_money_info(\'upd_cash_payment\',\'ACTION_DATE\')');" value="<cfif len(get_action_detail.CASH_ACTION_TO_EMPLOYEE_ID)><cfoutput>#get_emp_info(get_action_detail.CASH_ACTION_TO_EMPLOYEE_ID,0,0,0,get_action_detail.acc_type_id)#</cfoutput><cfelse><cfoutput>#member_name#</cfoutput></cfif>"  style="width:175px;">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="hesap_sec(); windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&field_comp_id=upd_cash_payment.CASH_ACTION_TO_COMPANY_ID&field_emp_id=upd_cash_payment.EMPLOYEE_ID&field_name=upd_cash_payment.company_name&field_consumer=upd_cash_payment.CASH_ACTION_TO_CONSUMER_ID&field_member_name=upd_cash_payment.company_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3,1,9</cfoutput>','list','popup_list_pars');" title="<cf_get_lang_main no='107.Cari Hesap'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-paper_number">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='35570.Belge No'>*</label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="Text" name="paper_number" value="#get_action_detail.paper_no#" style="width:175px;" required="yes" message="Lütfen Makbuz No Giriniz !">
                                </div>
                            </div>
                            <div class="form-group" id="item-action_date">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30631.Tarih'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                    	<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
                                        <cfinput validate="#validate_style#" value="#dateformat(get_action_detail.ACTION_DATE,dateformat_style)#" required="Yes" message="#message#" type="text" name="ACTION_DATE" style="width:175px;" readonly onBlur="change_money_info('upd_cash_payment','ACTION_DATE');">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="ACTION_DATE" call_function="change_money_info" control_date="#dateformat(get_action_detail.ACTION_DATE,dateformat_style)#"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-cash_action_value">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cfoutput>#session.ep.money#</cfoutput><cf_get_lang dictionary_id='58503.Lutfen Tutar Giriniz'></cfsavecontent>
									<cfinput type="text" name="cash_action_value" style="width:175px" value="#TLFormat(get_action_detail.CASH_ACTION_VALUE)#"  onBlur="kur_ekle_f_hesapla('CASH_ACTION_FROM_CASH_ID');" onKeyup="return(FormatCurrency(this,event));"  required="yes" message="#message#" class="moneybox">
                                </div>
                            </div>
                            <div class="form-group" id="item-other_cash_act_value">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58056.Dövizli Tutar'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="other_cash_act_value" style="width:175px;" value="#TLFormat(get_action_detail.OTHER_CASH_ACT_VALUE)#"  onBlur="kur_ekle_f_hesapla('CASH_ACTION_FROM_CASH_ID',true);" onKeyup="return(FormatCurrency(this,event));" class="moneybox">
                                </div>
                            </div>
                            <div class="form-group" id="item-project_id">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                    	<input type="hidden" name="project_id" id="project_id" value="<cfoutput>#get_action_detail.project_id#</cfoutput>">
										<cfif len(get_action_detail.project_id)>
                                            <cfquery name="get_project_name" datasource="#dsn#">
                                                SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_action_detail.project_id#
                                            </cfquery>
                                        </cfif>
                                        <input type="text" name="project_name" id="project_name" value="<cfif len(get_action_detail.project_id)><cfoutput>#get_project_name.project_head#</cfoutput></cfif>" style="width:175px;" onFocus="AutoComplete_Create('project_name','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=upd_cash_payment.project_name&project_id=upd_cash_payment.project_id</cfoutput>');" title="<cf_get_lang no='45.Proje Seçiniz'>"></span>
                                    </div>
                                </div>
                            </div>
                            <cfif session.ep.our_company_info.asset_followup eq 1>
                            <div class="form-group" id="item-asset_id">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58833.Fiziki Varlık'></label>
                                <div class="col col-8 col-xs-12">
                                    	<cf_wrkAssetp asset_id="#get_action_detail.assetp_id#" fieldId='asset_id' fieldName='asset_name' form_name='upd_cash_payment' width='175'>
                                </div>
                            </div>
                            </cfif>
                            <div class="form-group" id="item-PAYER_ID">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33207.Ödeme Yapan'>*</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                    	<input type="Hidden" name="PAYER_ID" id="PAYER_ID" value="<cfoutput>#get_action_detail.PAYER_ID#</cfoutput>">
                                        <input type="text" name="PAYER_NAME" id="PAYER_NAME" value="<cfoutput>#get_emp_info(get_action_detail.PAYER_ID,0,0)#</cfoutput>" style="width:175px;" readonly>
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="javascript:windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_cash_payment.PAYER_ID&field_name=upd_cash_payment.PAYER_NAME<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list','popup_list_positions');" title="<cf_get_lang no='52.Ödeme Yapan'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-ACTION_DETAIL">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea name="ACTION_DETAIL" id="ACTION_DETAIL" style="width:175px;height:40px;"><cfoutput>#get_action_detail.ACTION_DETAIL#</cfoutput></textarea>
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="false">
                            <div class="form-group" id="item-br">
                                <label class="col col-8 col-xs-12"><cf_get_lang dictionary_id='35578.İşlem Para Br'></label>
                            </div>
                            <div class="form-group" id="item-currency">
                                <label class="col col-2 col-xs-12"></label>
                                <div class="col col-10 col-xs-12">
                                	<cfscript>f_kur_ekle(action_id:attributes.id,process_type:1,base_value:'cash_action_value',other_money_value:'other_cash_act_value',form_name:'upd_cash_payment',action_table_name:'CASH_ACTION_MONEY',action_table_dsn:'#dsn2#',select_input:'CASH_ACTION_FROM_CASH_ID');</cfscript>
                                </div>
                            </div>
                        </div>
                    </cf_box_elements>
                <cf_box_footer>
                    	<cf_record_info query_name="get_action_detail">
						<cfif listgetat(attributes.fuseaction,2,'.') is 'popup_upd_cash_payment'>
                            <cfset url_link = "&is_popup=1">
                        <cfelse>
                            <cfset url_link = "">
                        </cfif>
                        <cfif not len(isClosed('CASH_ACTIONS',attributes.id))>
                            <cfif listgetat(attributes.fuseaction,2,'.') is 'popup_upd_cash_payment'>
                            <cf_workcube_buttons
                                is_upd='1' 
                                del_function_for_submit='del_kontrol()'
                                update_status='#get_action_detail.UPD_STATUS#'
                                delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.del_cash_payment&id=#url.id#&old_process_type=#get_action_detail.action_type_id##url_link#'
                                add_function="kontrol()" >
                        <cfelse>
                            <cf_workcube_buttons
                                is_upd='1' 
                                is_cancel=0
                                del_function_for_submit='del_kontrol()'
                                update_status='#get_action_detail.UPD_STATUS#'
                                delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.del_cash_payment&id=#url.id#&old_process_type=#get_action_detail.action_type_id##url_link#'
                                add_function="kontrol()" >
                        </cfif>
                        <cfelse>
                            <span style="float:right"><b><font color="FF0000"><cf_get_lang dictionary_id='47262.Fatura kapama işlemi yapılan belgede değişiklik yapılamaz'>!</font></b></span>
                        </cfif>
                    </cf_box_footer>

	</cfform>
</cf_box>
<script type="text/javascript">
	function del_kontrol()
	{
		control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.action_type_id#'</cfoutput>);
		if (!chk_period(upd_cash_payment.ACTION_DATE, "<cf_get_lang dictionary_id='29561.Cari Ödeme'>")) return false;
		else return true;
	}
	function hesap_sec()
	{
		if(document.upd_cash_payment.CASH_ACTION_TO_COMPANY_ID.value!='')
		{
			document.upd_cash_payment.CASH_ACTION_TO_COMPANY_ID.value='';
			document.upd_cash_payment.company_name.value='';
		}
		if(document.upd_cash_payment.EMPLOYEE_ID.value!='')
		{
			document.upd_cash_payment.EMPLOYEE_ID.value='';
			document.upd_cash_payment.company_name.value='';
		}
		if(document.upd_cash_payment.CASH_ACTION_TO_CONSUMER_ID.value!='')
		{
			document.upd_cash_payment.CASH_ACTION_TO_CONSUMER_ID.value='';
			document.upd_cash_payment.company_name.value='';
		}
	}
	function kontrol()
	{
		control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.action_type_id#'</cfoutput>);
		if(!chk_process_cat('upd_cash_payment')) return false;
		if(!check_display_files('upd_cash_payment')) return false;
		if(document.upd_cash_payment.PAYER_NAME.value=='' || document.upd_cash_payment.PAYER_ID.value=='')	
		{
			alert("<cf_get_lang dictionary_id='49847.Lütfen Ödeme Yapanı Giriniz !'>");
			return false;
		}
		if(document.upd_cash_payment.company_name.value!="" )
		{
			if (!chk_period(upd_cash_payment.ACTION_DATE, 'Cari Ödeme')) return false;
		}
		else
		{
			alert("<cf_get_lang dictionary_id='49805.Lütfen Ödeme Yapılan Kişi,Yapan Kişi Veya Çalışanı Seçiniz !'>");
			return false;
		}
		if((upd_cash_payment.CASH_ACTION_TO_COMPANY_ID.value =="") && (upd_cash_payment.CASH_ACTION_TO_CONSUMER_ID.value =="") &&(upd_cash_payment.EMPLOYEE_ID.value ==""))
		{
			alert("<cf_get_lang dictionary_id ='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id ='57519.Cari Hesap'>");
			return false;
		}
        /* makbuz numara inputu readonly' e alındı, değiştirilemeyeceği için tekrar makbuz no kontrolüne gerek kalmıyor.*/
		var parameter = document.upd_cash_payment.id.value + '*' + document.upd_cash_payment.paper_number.value + '*32*12';<!--- ödeme işlemine göre paper_no unique olmalı. 32 ödeme işlemi action_type_id, 12 tediye fişi--->
		var parameter_2 = document.upd_cash_payment.id.value + '*' + document.upd_cash_payment.paper_number.value + '*12';
		var get_paper_no = wrk_safe_query('csh_get_paper_no_3','dsn2',0,parameter);
		var get_paper_no_from_acc = wrk_safe_query('get_paper_no_from_acc','dsn2',0,parameter_2);<!---ödeme işleminden oluşan tediye fişinin belge numarasıyla manuel olarak eklenmiş tediye fişi de var mı? --->
		if( get_paper_no.recordcount || get_paper_no_from_acc.recordcount)
		{
			alert("<cf_get_lang dictionary_id='59366.Girdiğiniz Belge Numarası Kullanılmaktadır'>!");
			return false;
		} 
		return true;
	}	
	function odeme_ekle_ac()
	{
		if(upd_cash_payment.is_popup.value == 1)
		{
			window.opener.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.form_add_cash_payment';
			window.close();
		}
		else {window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.form_add_cash_payment';}
	}
	kur_ekle_f_hesapla('CASH_ACTION_FROM_CASH_ID');
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">