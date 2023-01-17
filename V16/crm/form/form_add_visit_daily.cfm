<cfset url_str = "">
<cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID,
		PTR.LINE_NUMBER
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%crm.form_add_visit_daily%">
	ORDER BY 
		PTR.LINE_NUMBER	
</cfquery>
<cfquery name="GET_EVENT_CATS" datasource="#DSN#">
	SELECT VISIT_TYPE_ID FROM SETUP_VISIT_TYPES WHERE VISIT_TYPE = 'Rutin Eczane Ziyareti'
</cfquery>
<cfif not get_event_cats.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="51449.Ziyaret Nedenlerini Kontrol Ediniz"> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
<cf_box title="#getLang('','',52225)#">
<cfform name="add_event_daily" id="add_event_daily" method="post" action="#request.self#?fuseaction=crm.emptypopup_add_visit_daily">
	<cfoutput>
    <input type="hidden" name="warning_head" id="warning_head" value="#dateformat(now(),dateformat_style)# Ziyaretleri (#session.ep.name# #session.ep.surname#)" maxlength="100">
    <input type="hidden" name="process_stage" id="process_stage" value="#get_process_type.process_row_id#">
    <input type="hidden" name="sales_zones" id="sales_zones" value="#ListGetAt(session.ep.user_location,2,"-")#">
    <input type="hidden" name="start_clock" id="start_clock" value="9">
    <input type="hidden" name="start_minute" id="start_minute" value="00">
    <input type="hidden" name="finish_clock" id="finish_clock" value="17">
    <input type="hidden" name="finish_minute" id="finish_minute" value="30">
    <input type="hidden" name="warning_id" id="warning_id" value="#get_event_cats.visit_type_id#">
    <input type="hidden" name="pos_emp_id" id="pos_emp_id" value="#session.ep.position_code#">	
    <input type="hidden" name="date_now" id="date_now" value="#dateformat(now(),dateformat_style)#">
    <input type="hidden" name="date_yesterday" id="date_yesterday" value="#dateformat(date_add('d',-1,now()),dateformat_style)#">
    </cfoutput>
                <cf_box_search>  
						<div class="form-group large"> 
							<div class="input-group">
								<input type="hidden" name="company_id" id="company_id" <cfif isdefined("attributes.company") and len(attributes.company)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
								<input name="company" type="text" id="company" placeholder="<cf_get_lang dictionary_id='63893.Şirket'>" value="<cfif isdefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>"  onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','company_id','','3','140');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&field_comp_name=add_event_daily.company&field_comp_id=add_event_daily.company_id&&select_list=2</cfoutput>&keyword='+encodeURIComponent(document.add_event_daily.company.value),'list')"></span>
							</div>
						</div>				
						<div class="form-group large"> 
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='50060.Başlama Tarihini Doğru Giriniz !'></cfsavecontent>
									<cfinput type="text" name="main_start_date" validate="#validate_style#" message="#message#" value="#dateformat(now(),dateformat_style)#" required="yes">
									<span class="input-group-addon"><cf_wrk_date_image date_field="main_start_date"></span>
								</div>
						</div>
						<div class="form-group large">							 
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='50059.Bitiş Tarihi Doğru Giriniz'></cfsavecontent>
									<cfinput type="text" name="main_finish_date" validate="#validate_style#" message="#message#" value="#dateformat(now(),dateformat_style)#" required="yes">
									<span class="input-group-addon"><cf_wrk_date_image date_field="main_finish_date"></span>
								</div>							
                        </div>
						<div class="form-group">
							<cf_wrk_search_button button_type="4" search_function="kontrol()">
						 </div>
                </cf_box_search>
		<cfinclude template="list_visit_daily_company.cfm">
</cfform>
</cf_box>
	<script type="text/javascript">
	function kontrol(){
		document.add_event_daily.action="<cfoutput>#request.self#?fuseaction=crm.form_add_visit_daily</cfoutput>";
		$( "#add_event_daily" ).submit();
	}
	function hepsi()
	{
		if(document.add_event_daily.all_check.checked)
			for(r=1;r<=add_event_daily.record_num.value;r++)
				eval("add_event_daily.check_"+r).checked = true;	
		else
			for(r=1;r<=add_event_daily.record_num.value;r++)
				eval("add_event_daily.check_"+r).checked = false;	
	}
	
	function check()
	{
		if(!date_check(document.add_event_daily.main_start_date,document.add_event_daily.main_finish_date,"<cf_get_lang dictionary_id='41814.Tarih Değerlerini Kontrol Ediniz'>!"))
			return false;
			
		if(
		(document.add_event_daily.main_start_date.value != document.add_event_daily.date_now.value && document.add_event_daily.main_start_date.value != document.add_event_daily.date_yesterday.value) || 
		(document.add_event_daily.main_finish_date.value != document.add_event_daily.date_now.value && document.add_event_daily.main_finish_date.value != document.add_event_daily.date_yesterday.value))
		{
			alert("<cf_get_lang dictionary_id='33528.Tarih Değerlerini Dün yada Bugun Seçebilirsiniz'>!");
			return false;
		}
		
		row_kontrol=0;
		for(r=1;r<=add_event_daily.record_num.value;r++)
		{
			deger_check = eval("document.add_event_daily.check_"+r);
			if(deger_check.checked == true)
				row_kontrol++;
		}
		
		if(row_kontrol==0)
		{
			alert("<cf_get_lang dictionary_id='52021.Lütfen Müşteri Seçiniz'>!");
			return false;
		}

		return true;		
	}
	</script>
</cfif>
