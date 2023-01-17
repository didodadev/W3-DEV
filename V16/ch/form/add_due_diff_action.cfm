<cfsetting showdebugoutput="yes">
<cf_xml_page_edit fuseact="ch.form_add_due_diff_action">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.consumer_cat_type" default="">
<cfparam name="attributes.member_action_type" default="1">
<cfparam name="attributes.customer_value" default="">
<cfparam name="attributes.due_date1" default="">
<cfparam name="attributes.due_date2" default="">
<cfparam name="attributes.action_date1" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.action_date2" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.pos_code_text" default="">
<cfparam name="attributes.payment_type_id" default="">
<cfparam name="attributes.card_paymethod_id" default="">
<cfparam name="attributes.payment_type" default="">
<cfparam name="attributes.ozel_kod" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.subscription_type" default="">
<cfparam name="attributes.process_stage_type" default="">
<cfparam name="attributes.is_paper_closer" default="0">
<cfparam name="attributes.due_diff_rate" default="">
<cfparam name="attributes.make_age_type" default="">
<cfparam name="attributes.due_diff_rate_info" default="0">
<cfparam name="attributes.listing_type" default="1">
<cfparam name="attributes.is_subscription_process" default="">
<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
	SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
</cfquery>
<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT ORDER BY HIERARCHY
</cfquery>
<cfquery name="GET_CUSTOMER_VALUE" datasource="#DSN#">
	SELECT
		CUSTOMER_VALUE_ID,
		CUSTOMER_VALUE 
	FROM
		SETUP_CUSTOMER_VALUE
	ORDER BY
		CUSTOMER_VALUE
</cfquery>
<cfquery name="GET_SUB_TYPE" datasource="#DSN3#">
	SELECT
		SUBSCRIPTION_TYPE_ID,
		SUBSCRIPTION_TYPE
	FROM 
		SETUP_SUBSCRIPTION_TYPE
	ORDER BY
		SUBSCRIPTION_TYPE
</cfquery>
<cfquery name="GET_SUB_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.list_subscription_contract%">
</cfquery>
<cfquery name="GET_MONEY_RATE" datasource="#DSN2#">
	SELECT 
		<cfif xml_money_type eq 1>
			ISNULL(RATE3,RATE2) RATE2_
		<cfelseif xml_money_type eq 3>
			ISNULL(EFFECTIVE_PUR,RATE2) RATE2_
		<cfelseif xml_money_type eq 4>
			ISNULL(EFFECTIVE_SALE,RATE2) RATE2_
		<cfelse>
			RATE2 RATE2_
		</cfif>,
		* 
	 FROM 
	 	SETUP_MONEY 
	WHERE 
		MONEY_STATUS=1 
	ORDER BY 
		MONEY_ID
</cfquery>
<cfquery name="GET_PERIOD" datasource="#DSN#"><!--- yetkili olduğum aktif şirketler --->
	SELECT 
    	PERIOD_ID, 
        PERIOD_YEAR, 
        OUR_COMPANY_ID, 
        OTHER_MONEY, 
        RECORD_DATE, 
        RECORD_IP, 
        RECORD_EMP, 
        UPDATE_DATE, 
        UPDATE_IP, 
        UPDATE_EMP
    FROM 
    	SETUP_PERIOD 
    WHERE 
	    OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cf_catalystHeader>
<cfform name="add_due_diff_action" method="post" action="#request.self#?fuseaction=ch.list_due_diff_actions&event=add">
<cf_box title="Filtre" closable="0">
	<cf_box_elements>
		<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
			<div class="form-group" id="item-comp_cat" <cfif attributes.member_action_type eq 2>style="display:none;"</cfif>>
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no ='1197.Üye Kategorisi'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<input type="hidden" name="is_invoice_no_product" id="is_invoice_no_product" value="<cfoutput>#is_invoice_no_product#</cfoutput>">
					<input type="hidden" name="subscription_id" id="subscription_id" value="">
					<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
					<select name="member_cat_type" id="member_cat_type"multiple="multiple">
					<cfoutput query="get_company_cat">
						<option value="#companycat_id#" <cfif listfind(attributes.member_cat_type,companycat_id)>selected</cfif>>&nbsp;#companycat#</option>
					</cfoutput>						
					</select>
				</div>
			</div>
			<div class="form-group" id="item-cons_cat" <cfif attributes.member_action_type eq 1>style="display:none;"</cfif>>
			<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no ='1197.Üye Kategorisi'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<select name="consumer_cat_type" id="consumer_cat_type"multiple="multiple">
						<cfoutput query="get_consumer_cat">
							<option value="#conscat_id#" <cfif listfind(attributes.consumer_cat_type,conscat_id)>selected</cfif>>&nbsp;#conscat#</option>
						</cfoutput>						
					</select>					
				</div>
			</div>
			<div class="form-group" id="item-customer_value">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='1140.Müşteri Değeri'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<select name="customer_value" id="customer_value"multiple="multiple">
					<cfoutput query="get_customer_value">
						<option value="#customer_value_id#" <cfif listfind(attributes.customer_value,customer_value_id)>selected</cfif>>#customer_value#</option>
					</cfoutput>
					</select>
				</div>
			</div>
			<cfif session.ep.our_company_info.subscription_contract eq 1>
			<div class="form-group" id="item-subscription_type">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='40085.Abone Kategorisi'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<select name="subscription_type" id="subscription_type"multiple="multiple">
					<cfoutput query="get_sub_type">
						<option value="#subscription_type_id#" <cfif listfind(attributes.subscription_type,subscription_type_id)>selected</cfif>>#subscription_type#</option>
					</cfoutput>
					</select>
				</div>
			</div>
			</cfif>
			<cfif session.ep.our_company_info.is_paper_closer>
				<div class="form-group" id="item-is_paper_closer">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main dictionary_id='58787.Belge Kapama'></label>
					<div  class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="is_paper_closer" id="is_paper_closer">
							<option value="-1" <cfif attributes.is_paper_closer eq -1>selected="selected"</cfif>><cf_get_lang dictionary_id="54513.kapanmışlar"></option>
							<option value="0" <cfif attributes.is_paper_closer eq 0>selected="selected"</cfif>><cf_get_lang dictionary_id="54449.kapanmamışlar"></option>
							<option value="1" <cfif attributes.is_paper_closer eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id="58081.hepsi"></option>  
						</select>
					</div>
				</div>
			</cfif>
			<!--- <div class="form-group" id="item-transaction-type">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<select name="transaction-type" id="transaction-type">
						<option value="1">Fatura ve Cari İşlemlerden Çalış</option>
						<option value="2">Abone Ödeme Planından Çalış</option>
					</select>
				</div>
			</div> --->
		</div>
		<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
			<div class="form-group" id="item-pos_code">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='1383.Müşteri Temsilcisi'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<div class="input-group">
						<input type="hidden" name="pos_code" id="pos_code" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
						<input type="text" name="pos_code_text" id="pos_code_text" onfocus="AutoComplete_Create('pos_code_text','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','pos_code','','3','135')" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#attributes.pos_code_text#</cfoutput></cfif>">
						<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no='1383.Müşteri Temsilcisi'>" OnCLick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_due_diff_action.pos_code&field_name=add_due_diff_action.pos_code_text&select_list=1','list');"></span>
					</div>
				</div>
			</div>
			<div class="form-group" id="item-card_paymethod_id">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='1104.Ödeme Yöntemi'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<div class="input-group">
						<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="<cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)><cfoutput>#attributes.card_paymethod_id#</cfoutput></cfif>">
						<input type="hidden" name="payment_type_id" id="payment_type_id" value="<cfif isdefined("attributes.payment_type_id") and len(attributes.payment_type_id)><cfoutput>#attributes.payment_type_id#</cfoutput></cfif>">
						<input type="text" name="payment_type" id="payment_type" value="<cfif isdefined("attributes.payment_type") and len(attributes.payment_type)><cfoutput>#attributes.payment_type#</cfoutput></cfif>">
						<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no='1104.Ödeme Yöntemi'>" OnCLick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_paymethods&field_id=add_due_diff_action.payment_type_id&field_name=add_due_diff_action.payment_type&field_card_payment_id=add_due_diff_action.card_paymethod_id&field_card_payment_name=add_due_diff_action.payment_type','medium');"></span>
					</div>
				</div>
			</div>
			<div class="form-group" id="item-consumer_id">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='45.Müşteri'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<div class="input-group">
						<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif len(attributes.company)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
						<input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
						<input type="text" name="company" id="company" value="<cfif len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0,0','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','','3','250');" autocomplete="off">
						<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no='45.Müşteri'>" OnCLick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=add_due_diff_action.company&field_comp_id=add_due_diff_action.company_id&field_consumer=add_due_diff_action.consumer_id&field_member_name=add_due_diff_action.company&select_list=2,3<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list');"></span>
					</div>
				</div>
			</div>
			<cfif session.ep.our_company_info.project_followup eq 1>
				<div class="form-group" id="item-project_id">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no ='4.Proje'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id')><cfoutput>#attributes.project_id#</cfoutput></cfif>">
							<cf_wrk_projects form_name='add_due_diff_action' project_id='project_id' project_name='project_head'>
							<input type="text" name="project_head" id="project_head" onkeyup="get_project_1();" value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>">
							<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no ='4.Proje'>" OnCLick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_due_diff_action.project_id&project_head=add_due_diff_action.project_head');"></span>
						</div>
					</div>
				</div>
			</cfif>
			<cfif session.ep.our_company_info.subscription_contract eq 1>
				<div class="form-group" id="item-process_stage_type">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='40125.Abone Aşaması'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="process_stage_type" id="process_stage_type"multiple="multiple">
						<cfoutput query="get_sub_stage">
							<option value="#process_row_id#" <cfif listfind(attributes.process_stage_type,process_row_id)>selected</cfif>>#stage#</option>
						</cfoutput>
					</select>
					</div>
				</div>
				<div class="form-group" id="item-is_subscription_process">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='40124.Abone durumu'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="is_subscription_process" id="is_subscription_process">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<option value="0" <cfif attributes.is_subscription_process eq 0>selected</cfif>><cf_get_lang dictionary_id='60523.Aboneli işlemler'></option>
							<option value="1" <cfif attributes.is_subscription_process eq 1>selected</cfif>><cf_get_lang dictionary_id='60524.Abonesiz işlemler'></option>
					</select>
					</div>
				</div>
			</cfif>
		</div>
		<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
			<div class="form-group" id="item-due_diff_rate">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='37.Hesaplama Yöntemi'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<select name="due_diff_rate" id="due_diff_rate">
						<option value="1" <cfif attributes.due_diff_rate eq 1>selected</cfif>><cf_get_lang no='35.Ödeme Yönteminden Hesapla'></option>
						<option value="2" <cfif attributes.due_diff_rate eq 2>selected</cfif>><cf_get_lang no='34.Cari Risk Bilgisinden Hesapla'></option>
						<option value="3" <cfif attributes.due_diff_rate eq 3>selected</cfif>><cf_get_lang no='32.Vade Farkı Oranından Hesapla'></option>
					</select>
				</div>
			</div>
			<div class="form-group" id="item-ozel_kod">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='377.Özel Kod'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfinput type="text" name="ozel_kod" id="ozel_kod" value="#attributes.ozel_kod#" maxlength="255">
				</div>
			</div>
			<div class="form-group" id="item-due_date1">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='469.Vade Tarihi'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<div class="input-group">
						<cfinput type="text" name="due_date1" id="due_date1" value="#attributes.due_date1#" validate="#validate_style#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="due_date1"></span>
						<span class="input-group-addon no-bg"></span>
					<cfinput type="text" name="due_date2" id="due_date2" value="#attributes.due_date2#" validate="#validate_style#">
					<span class="input-group-addon"><cf_wrk_date_image date_field="due_date2"></span>
					</div>
				</div>
			</div>
			<div class="form-group" id="item-action_date1">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='467.İşlem Tarihi'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<div class="input-group">
						<cfsavecontent variable="message1"><cf_get_lang_main no ='326.Başlangıç Tarihi Girmelisiniz'>!</cfsavecontent>
						<cfinput type="text" name="action_date1" id="action_date1" value="#attributes.action_date1#" maxlength="10" required="yes" message="#message1#" validate="#validate_style#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="action_date1"></span>
						<span class="input-group-addon no-bg"></span>
						<cfsavecontent variable="message2"><cf_get_lang_main no ='327.Bitiş Tarihi Girmelisiniz'>!</cfsavecontent>
						<cfinput type="text" name="action_date2" id="action_date2" value="#attributes.action_date2#" maxlength="10" required="yes" message="#message2#" validate="#validate_style#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="action_date2"></span>
					</div>
				</div>
			</div>
			<cfif is_action_date eq 1>
				<div class="form-group" id="item-action_date">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='56.Belge'> <cf_get_lang_main no='467.İşlem Tarihi'> *</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">	
							<cfif isdefined("attributes.action_date")>
								<cfinput type="text" name="action_date" id="action_date" validate="#validate_style#" required="yes" value="#attributes.action_date#" maxlength="10">
							<cfelse>	
								<cfinput type="text" name="action_date" id="action_date" validate="#validate_style#" required="yes" value="#dateformat(now(),dateformat_style)#" maxlength="10">
							</cfif>
							<span class="input-group-addon"> <cf_wrk_date_image date_field="action_date"></span>
						</div>
					</div>
				</div>
			</cfif>
			<div class="form-group" id="item-due_diff_rate_info">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='30.Vade Farkı Oranı'> %</label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">	
					<cfinput type="text" name="due_diff_rate_info" id="due_diff_rate_info" value="#attributes.due_diff_rate_info#" class="moneybox" onKeyUp="return(FormatCurrency(this,event,4));" onBlur="if(this.value.length == 0 || filterNum(this.value,4)==0) this.value = 0;">
				</div>
			</div>
			<div class="form-group" id="item-member_action_type">
				<label class="hide col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='1611.Kurumsal Üyeler'> / <cf_get_lang_main no='1609.Bireysel Üyeler'> </label>
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><input name="member_action_type" id="member_action_type" type="radio" value="1" onclick="kontrol_display();" <cfif attributes.member_action_type eq 1>checked</cfif>><cf_get_lang_main no='1611.Kurumsal Üyeler'></label>
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><input name="member_action_type" id="member_action_type" type="radio" value="2" onclick="kontrol_display();" <cfif attributes.member_action_type eq 2>checked</cfif>><cf_get_lang_main no='1609.Bireysel Üyeler'></label>
			</div>
		</div>
	</cf_box_elements>
	<div class="ui-form-list-btn flex-end">
		<div>
			<cf_wrk_search_button button_type='1' is_excel="0">
		</div>
	</div>
</cf_box>		
	<cfset count_row= 0>
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='57777.İşlemler'></cfsavecontent>
	<cfif isdefined("attributes.active_period")>
		<cf_box id="add_due_row" title="#title#" uidrop="1" hide_table_column="1">
			<!--- Vade farkı hesaplanacak işlemler getiriliyor --->
			<cfinclude template="add_due_diff_action_1.cfm">
			<cfif get_actions.recordcount>
				<!--- Eğer işlem varsa ekleme kısmı getiriliyor --->
				<cfinclude template="add_due_diff_action_2.cfm">
			</cfif>
		</cf_box>
	</cfif>
</cfform>
<script type="text/javascript">
	<cfif isdefined("get_money")>
    $(function(){
		control_act_type(1);
		control_checked=<cfoutput>#count_row#</cfoutput>;
		$('input[name=checkAll]').click(function(){
			if(this.checked){
				$('.checkControl').each(function(){
					$(this).prop("checked", true);
				});
			}
			else{
				$('.checkControl').each(function(){
					$(this).prop("checked", false);
				});
			}
        });
        
        $('.checkControl').click(function(){

            deger_artis =  { <cfoutput query="get_money"> #money# : { money : 0.0, counter : 0 , system_money : 0.0 , system_money_counter : 0 } ,</cfoutput> }
                    
            $('.checkControl').each(function() {

                type = $(this).attr("money_type"); 
                if(this.checked){
                   
                        deger_artis[type]["money"] += parseFloat($(this).attr("total_value"));
                        deger_artis["<cfoutput>#session.ep.money#</cfoutput>"]["system_money"] += parseFloat($(this).attr("total_value")) / parseFloat($("table#mny_table input[money_type=<cfoutput>#session.ep.money#</cfoutput>]").val()) * parseFloat($("table#mny_table input[money_type="+type+"]").val()); 
                        deger_artis[type]["counter"] ++;
                        deger_artis["<cfoutput>#session.ep.money#</cfoutput>"]["system_money_counter"]++;
                   
                      
                }
                if( !$(this).hasClass("checkAll") ) {
                    $('#deger_artis_'+type).val(commaSplit(deger_artis[type]["money"])).parent().find("span.input-group-addon > strong").html(deger_artis[type]["counter"]);
                   }
            });

            $("#deger_artis_system").val(commaSplit(deger_artis["<cfoutput>#session.ep.money#</cfoutput>"]["system_money"])).parent().find("span.input-group-addon > strong").html(deger_artis["<cfoutput>#session.ep.money#</cfoutput>"]["system_money_counter"]);
          
          
          
        });

    });
	</cfif>
	function control_act_type(val){
		if(val != 1){
			$("#act_1").hide();
			$("#act_4").hide();
			$("#act_2").show();
			$("#act_3").show();
		}
		else{
			$("#act_1").show();
			$("#act_4").show();
			$("#act_2").hide();
			$("#act_3").hide();
		}
	}
	function hepsi_view()
	{
		if(document.add_due_diff_action.all_view.checked)
		{
		
			for(i=1;i<=document.getElementById('all_records').value; i++)
			{
				if(eval('add_due_diff_action.is_pay_'+i)!= undefined)
					eval('add_due_diff_action.is_pay_'+i).checked = true;
				control_checked++;
			}
		}
		else
		{
			for(i=1;i<=add_due_diff_action.all_records.value; i++)
			{
				if(eval('add_due_diff_action.is_pay_'+i)!= undefined)
					eval('add_due_diff_action.is_pay_'+i).checked = false;
				control_checked = 0;
			}
		}
	}
	function check_kontrol(nesne)
	{
		if(nesne.checked)
			control_checked++;
		else
			control_checked--;
	}
	function kontrol_display()
	{
		if(add_due_diff_action.member_action_type[0].checked)
		{
			comp_cat.style.display='';
			cons_cat.style.display='none';
		}
		else
		{
			comp_cat.style.display='none';
			cons_cat.style.display='';
		}			
	}
	function kontrol()
	{
		if(control_checked > 0)
		{
			act_type = $("#act_type").val();
			if(act_type == 1){
				if(!chk_process_cat('add_due_diff_action')) return false;
				if(!check_display_files('add_due_diff_action')) return false;
			}
			if(!chk_period(add_due_diff_action.action_date,'İşlem')) return false;
			if(act_type == 2){
				for(i=1;i<=document.getElementById('all_records').value; i++)
				{
					if($("#is_pay_"+i).prop("checked") == true && $("#subscription_id_"+i).val() == ''){
						alert('Seçilen Faturanın Abone ilişkisi Yok. Satır : ' + i);
						return false;
					} 
						
				}
			}
			if(act_type != 1)
			{
				if(document.getElementById('product_id').value == '' || document.getElementById('product_name').value == '')
				{
					alert("<cf_get_lang_main no ='313.Ürün Seçmelisiniz'> !");
					return false;
				}
			}
			if(!check_paym_type()) return false;
			add_due_diff_action.action='<cfoutput>#request.self#?fuseaction=ch.emptypopup_add_due_diff_action</cfoutput>';
			add_due_diff_action.submit();
			add_due_diff_action.action='';
			return false;
		}
		else
			return false;
	}
	function toplam_hesapla()
	{
		for (var t=1; t<=document.getElementById('kur_say').value; t++)
		{
			if(document.add_due_diff_action.rd_money[t-1].checked == true)
			{
				rate2_value = filterNum(eval('document.add_due_diff_action.txt_rate2_'+t).value);
			}
		}
		for(j=1;j<=document.getElementById('all_records').value;j++)
		{
			eval('document.add_due_diff_action.control_amount_2_'+j).value = commaSplit(eval("document.add_due_diff_action.control_amount_"+j).value/rate2_value,4);
		}
	}
	function check_paym_type(){
		if($("#payment_type2").val() == "")
		{
			alert("<cf_get_lang_main no='615.Ödeme Yöntemi Seçiniz!'>");
			return false;
		}
		return true;
	}
</script>
