<cf_xml_page_edit fuseact="settings.form_add_period">
<cfquery name="PERIOD" datasource="#DSN#">
	SELECT 
		ISNULL(IS_ACTIVE,1) AS IS_ACTIVE,
    	*
    FROM 
	    SETUP_PERIOD 
    WHERE 
    	PERIOD_ID = #attributes.period_id#
</cfquery>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT 
        MONEY, 
        MONEY_STATUS, 
        PERIOD_ID, 
        COMPANY_ID, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE,
        UPDATE_EMP, 
        UPDATE_IP
    FROM 
    	SETUP_MONEY 
    WHERE 
	    COMPANY_ID = #session.ep.company_id# AND PERIOD_ID = #session.ep.period_id#
</cfquery>
<cfform name="period" method="post" action="#request.self#?fuseaction=settings.emptypopup_period_upd">
	<cf_box title="#getLang(499,'Muhasebe Dönemleri',42172)#" add_href="#request.self#?fuseaction=settings.form_add_period">
		<cf_box_elements>			
			<div class="col col-3 col-xs-12" type="column" index="1" sort="true">
				<div class="scrollbar" style="max-height:403px;overflow:auto;">
					<div id="cc">
						<cfinclude template="../display/list_periods.cfm">
					</div>
				</div>
			</div>
			<cfif isdefined("is_special_period_date") and is_special_period_date eq 1>
				<input type="hidden" name="is_special_period_date" id="is_special_period_date" value="<cfoutput>#is_special_period_date#</cfoutput>" />
			<cfelse>
				<input type="hidden" name="is_special_period_date" id="is_special_period_date" value="" />
			</cfif>
			<cfif isdefined("session.ep.admin")>
					<input type="hidden" name="period_year" id="period_year" value="<cfoutput>#period.period_year#</cfoutput>">
					<input type="hidden" name="period_id" id="period_id" value="<cfoutput>#attributes.period_id#</cfoutput>">
					<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#period.our_company_id#</cfoutput>">
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-is_locked">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='43710.Sistem 2 Dövizini Kilitle'></label>
						<label class="col col-8 col-xs-12"><input type="checkbox" name="is_locked" id="is_locked" <cfif period.is_locked eq 1>checked</cfif>></label>
					</div>
					<div class="form-group" id="item-is_active">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57493.Aktif'></label>
						<label class="col col-8 col-xs-12"><input type="checkbox" name="is_active" id="is_active" <cfif period.is_active eq 1>checked</cfif>></label>
					</div>
					</cfif>
					<div class="form-group" id="item-IS_INTEGRATED">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42485.Entegre'> *</label>
						<div class="col col-4 col-xs-12">
							<input type="checkbox" id="IS_INTEGRATED" name="IS_INTEGRATED" <cfif period.is_integrated>checked</cfif>>
						</div>
						<div class="col col-4 col-xs-12">
							<cf_get_lang dictionary_id='57495.Evet'>
						</div>
					</div>
					<div class="form-group" id="item-our_company">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
						<div class="col col-8 col-xs-12"> 		
							<cfquery name="OUR_COMPANY" datasource="#dsn#">
								SELECT 
									COMP_ID,
									COMPANY_NAME,
									NICK_NAME
								FROM 
									OUR_COMPANY
								WHERE
									COMP_ID = #period.our_company_id#
								ORDER BY 
									COMPANY_NAME
							</cfquery>
							<cfoutput>#OUR_COMPANY.COMPANY_NAME#</cfoutput>
						</div>

					</div>
					<div class="form-group" id="item-period_year">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42484.Dönem Yılı'></label>
						<div class="col col-8 col-xs-12">
							<cfoutput>#period.period_year#</cfoutput>
						</div>
					</div>
					<div class="form-group" id="item-period_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42483.Dönem Adı'>*</label>
						<div class="col col-8 col-xs-12"> 
							<cfinput type="text" name="period_name" size="60" value="#period.period#" maxlength="50" required="Yes" message="#getLang('','Dönem Adı girmelisiniz',42617)#">
						</div>
					</div>
					<div class="form-group" id="item-inventory_calc_type">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42074.Envanter Yöntemi '></label>
						<div class="col col-8 col-xs-12">
							<select name="inventory_calc_type" id="inventory_calc_type">
								<option value="3" <cfif period.inventory_calc_type eq 3>selected</cfif>><cf_get_lang dictionary_id='42100.Ağırlıklı Ortalama'></option>
								<option value="1" <cfif period.inventory_calc_type eq 1>selected</cfif>><cf_get_lang dictionary_id='42193.İlk Giren İlk Çıkar'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-PERIOD_DATE">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51145.Muhasebe İşlem Tarihi Kısıtı'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfinput validate="#validate_style#" message="#getLang('','Lutfen Tarih Giriniz',58503)#" type="text" name="PERIOD_DATE" value="#DATEFORMAT(period.PERIOD_DATE,dateformat_style)#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="PERIOD_DATE"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-budget_period_date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60556.Bütçe İşlem Tarih Kısıtı'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfinput validate="#validate_style#" message="#getLang('','Lutfen Tarih Giriniz',58503)#" type="text" value="#DATEFORMAT(period.budget_period_date,dateformat_style)#" name="budget_period_date" id="budget_period_date">
								<span class="input-group-addon"><cf_wrk_date_image date_field="budget_period_date"></span>
							</div>
						</div>
					</div>
					<cfif isdefined("is_special_period_date") and is_special_period_date eq 1>
					<div class="form-group" id="item-finish_date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58690.Tarih Aralığı"></label>
						<div class="col col-4 col-xs-12">
							<div class="input-group">
								<cfinput validate="#validate_style#" message="#getLang('','Lutfen Tarih Giriniz',58503)#" type="text" name="start_date" id="start_date" value="#DATEFORMAT(period.start_date,dateformat_style)#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="start_date">
							</div>
						</div>
						<div class="col col-4 col-xs-12">
							<div class="input-group">
								<cfinput validate="#validate_style#" message="#getLang('','Lutfen Tarih Giriniz',58503)#" type="text" name="finish_date" id="finish_date" value="#DATEFORMAT(period.finish_date,dateformat_style)#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date">
							</div>
						</div>
					</div>
					</cfif>
					<div class="form-group" id="item-other_money">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43267.İkinci Döviz Birimi'> *</label>
						<div class="col col-8 col-xs-12">
						<cfif period.is_locked eq 1>
								<input type="text" readonly name="other_money" id="other_money" value="<cfoutput>#period.other_money#</cfoutput>">
							<cfelse>
								<select name="other_money" id="other_money">
									<option value=""><cf_get_lang dictionary_id ='58474.Para Br'></option>
									<cfoutput query="get_money">
										<option value="#money#" <cfif period.other_money eq money>selected</cfif>>#money#</option>
									</cfoutput>
								</select>
							</cfif>
						</div>
					</div>
					<div class="form-group" id="item-standart_process_money">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='43708.Standart İşlem Dövizi'></label>
						<div class="col col-8 col-xs-12">
							<select name="standart_process_money" id="standart_process_money">
								<option value=""><cf_get_lang dictionary_id ='58474.Para Br'></option>
								<cfoutput query="get_money">
									<option value="#money#" <cfif period.standart_process_money eq money>selected</cfif>>#money#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_record_info 
				query_name="period"
				record_emp="record_emp" 
				record_date="record_date"
				update_emp="update_emp"
				update_date="update_date">
			<cfif session.ep.admin eq 1>
				<cf_workcube_buttons is_upd='1' add_function='chk()' delete_page_url='#request.self#?fuseaction=settings.emptypopup_period_del&period_id=#attributes.period_id#&head=#period.period#'>
			<cfelse>
				<cf_workcube_buttons is_upd='1' is_delete='0' add_function='chk()'>
			</cfif>
		</cf_box_footer>
	</cf_box>
</cfform>
<script type="text/javascript">
	function chk()
	{
		if (document.period.other_money.value == "")
		{
			alert("<cf_get_lang dictionary_id='43267.İkinci Döviz Birimi'> <cf_get_lang dictionary_id='57734.Seçiniz'> !");
			return false;
		} 
		<cfif isdefined("is_special_period_date") and is_special_period_date eq 1>
			if(document.getElementById('start_date').value !='' && document.getElementById('finish_date').value != '')
			{
				if (!date_check (document.getElementById('start_date'),document.getElementById('finish_date'),"<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Önce Olamaz'>!"))
					return false;
				else
					return true;	
			}
		</cfif>
		return true;
	}
</script>
