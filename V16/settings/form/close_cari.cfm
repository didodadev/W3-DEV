<cf_xml_page_edit fuseact="settings.form_close_cari">
<cfquery name="get_period" datasource="#dsn#">
	SELECT PERIOD_ID,PERIOD,PERIOD_YEAR FROM SETUP_PERIOD WHERE PERIOD_YEAR <= #year(now())+1# ORDER BY OUR_COMPANY_ID,PERIOD_YEAR
</cfquery>
<cfif is_select_ch_cat eq 1>
		<cfquery name="get_member_cat" datasource="#dsn#">
			SELECT DISTINCT	
				COMPANYCAT_ID MEMBER_CAT_ID,
				COMPANYCAT MEMBER_CAT
			FROM
				GET_MY_COMPANYCAT
			WHERE
				EMPLOYEE_ID = #session.ep.userid# AND
				OUR_COMPANY_ID = #session.ep.company_id#
			ORDER BY
				COMPANYCAT
		</cfquery>
</cfif>
<cfsavecontent variable = "title">
	<cf_get_lang dictionary_id='43538.Kurumsal Üye Dönem Açılışı'>
</cfsavecontent>
<div class="col col-12 col-xs-12">
<cf_box title="#title#">
	<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
		<cfform name="close_ch" method="post" action="" enctype="multipart/form-data">
		<cf_box_elements>
			<div class="col col-12">
			<div class="form-group">
				<label class="col col-6 col-md-6 col-xs-12"><cf_get_lang dictionary_id="45836.Aktarım"></label>
				<div class="col col-6 col-md-6 col-xs-12">	
					<select name="select_close" id="select_close">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<option value="select_period"><cf_get_lang dictionary_id='43052.Dönemden Aktarım'></option>
						<option value="select_file"><cf_get_lang dictionary_id='43057.Dosyadan Aktarım'></option>
					</select>
				</div>
			</div>
			</div>
			<input type="hidden" value="1" name="is_company" id="is_company">
			<cfset select_list_ = 2>
			<cfset select_list_2 = 1>
			<cfset url_ = 'popup_list_pars'>
			<input type="hidden" value="" name="is_from_donem" id="is_from_donem">
			<input type="hidden" value="<cfoutput>#xml_money_type#</cfoutput>" name="xml_money_type" id="xml_money_type">
          <div id="from_period" style="display:none" class="col col-12">
			<div class="form-group">
				<label class="col col-6 col-md-6 col-xs-12"><cf_get_lang dictionary_id="59604.Ödeme Performansına Göre Hesapla"></label>
				<div class="col col-6 col-md-6 col-xs-12">	
					<input type="checkbox" name="is_make_age" id="is_make_age" value="1" onClick="check_row_info(1);">
				</div>
			</div>
			<div class="form-group">
				<label class="col col-6 col-md-6 col-xs-12"><cf_get_lang dictionary_id="59605.Manuel Ödeme Performansına Göre Hesapla"></label>
				<div class="col col-6 col-md-6 col-xs-12">
					<input type="checkbox" name="is_make_age_manuel" id="is_make_age_manuel" value="1" onClick="check_row_info(2);">
				</div>
			</div>
			<div class="form-group">
				<label class="col col-6 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43047.Ödenmemiş Çek\Senetleri Aktarma (Satır Bazında Çek\Senetleri Carileştiren Firmalar İçindir)'></label>
				<div class="col col-6 col-md-6 col-xs-12">
					<input type="checkbox" name="is_cheque_voucher_transfer" id="is_cheque_voucher_transfer" value="1">
				</div>
			</div>
			<div class="form-group">
				<label class="col col-6 col-md-6 col-xs-12"><cf_get_lang dictionary_id="59606.Kur Fiş Tarihinden Alınsın"></label>
				<div class="col col-6 col-md-6 col-xs-12">
					<input type="checkbox" name="check_date_rate" id="check_date_rate" value="1" checked>
				</div>
			</div>
			<div class="form-group">
			
				<label class="col col-6 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43013.Fiş Tarihi'></label>
				<div class="col col-6 col-md-6 col-xs-12">
					<div class="input-group">
					<input type="text" name="action_date_rate" id="action_date_rate" value="01/01/<cfoutput>#session.ep.period_year#</cfoutput>" style="width:200px;">
					<span class="input-group-addon">
					<cf_wrk_date_image date_field="action_date_rate">
					</span>
				</div>
			</div>
			</div>
		</div>
		<div id="from_file" style="display:none" class="col col-12">
			<div class="form-group">
				<label class="col col-6 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43013.Fiş Tarihi'></label>
				<div class="col col-6 col-md-6 col-xs-12">
					<div class="input-group">
					<input type="text" name="action_date" id="action_date" value="01/01/<cfoutput>#session.ep.period_year#</cfoutput>" style="width:200px;">
					<span class="input-group-addon">
					<cf_wrk_date_image date_field="action_date">
					</span>
				</div></div>
			</div>
			<div class="form-group">
				<label class="col col-6 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43044.Tüm Açılış Fişlerini Silip Yeniden Oluştur'></label>
				<div class="col col-6 col-md-6 col-xs-12">
					<input type="checkbox" name="is_delete_all" id="is_delete_all" value="1" checked="checked">
				</div>
			</div>
			<div class="form-group">
				<label class="col col-6 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43272.Dosyadan Aktar'></label>
				<div class="col col-6 col-md-6 col-xs-12">
					<input type="file"  name="cari_file" id="cari_file">
				</div>
			</div>
			<div class="form-group">
				<label class="col col-6 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43027.Dosya Üye Formatı'></label>
				<div class="col col-6 col-md-6 col-xs-12">
					<select name='file_comp_identifier' id="file_comp_identifier">
						<option value="0" selected><cf_get_lang dictionary_id='57752.Vergi No'></option>
						<option value="1"><cf_get_lang dictionary_id='57789.Özel Kod'> 1</option>
						<option value="2"><cf_get_lang dictionary_id='57789.Özel Kod'> 2</option>
						<option value="3"><cf_get_lang dictionary_id='57789.Özel Kod'> 3</option>
						<option value="4"><cf_get_lang dictionary_id='57558.Üye No'></option>
					
				</select>
				</div>
			</div>
		</div>
		<div id="general_options" style="display:none" class="col col-12">
			<div class="form-group">
				<label class="col col-6 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43271.Muhasebe Dönemi'></label>
				<div class="col col-6 col-md-6 col-xs-12">
					<select name="period" id="period">
						<option value="" selected><cf_get_lang dictionary_id='42199.Dönemler'></option>
						<cfoutput query="get_period">
							<option value="#PERIOD_ID#;#PERIOD_YEAR#">#PERIOD#</option>
						</cfoutput>
					</select>
				</div>
			</div>
			<div class="form-group">
				<label class="col col-6 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'>*</label>
				<div class="col col-6 col-md-6 col-xs-12">
					<cf_workcube_process_cat slct_width="200" module_id='23'>
				</div>
			</div>
			<cfif is_select_ch eq 1>
			<div class="form-group" id="from_period2">
				<label class="col col-6 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
				<div class="col col-6 col-md-6 col-xs-12">
					<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.member_type") and len(attributes.member_type) and attributes.member_type is 'partner'><cfoutput>#attributes.company_id#</cfoutput></cfif>">
					<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.member_type") and len(attributes.member_type) and attributes.member_type is 'consumer'><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
					<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and isdefined("attributes.member_type") and len(attributes.member_type) and attributes.member_type is 'employee'><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
					<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type") and len(attributes.member_type)><cfoutput>#attributes.member_type#</cfoutput></cfif>">
					<input type="text" name="company" id="company" style="width:200px;" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'<cfoutput>#select_list_2#</cfoutput>\',\'0\',\'0\',\'0\',\'2\',\'0\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','company_id,consumer_id,employee_id,member_type','','3','225');" value="<cfif  isdefined("attributes.company") and len(attributes.company)><cfoutput>#URLDecode(attributes.company)#</cfoutput></cfif>" autocomplete="off">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.#url_#&is_company_info=1&field_name=close_ch.company&field_type=close_ch.member_type&field_comp_name=close_ch.company&field_consumer=close_ch.consumer_id&field_emp_id=close_ch.employee_id&field_comp_id=close_ch.company_id&select_list=#select_list_#</cfoutput>','list');"> <img src="/images/plus_thin.gif" border="0" align="absmiddle"> </a>			
				</div>
			</div>
		    </cfif>
			<cfif is_select_ch_cat eq 1 and not isdefined("attributes.is_employee")>
			<div class="form-group" id="from_period3">
				<label class="col col-6 col-md-6 col-xs-12"><cf_get_lang dictionary_id='58609.üye Kategorisi'></label>
				<div class="col col-6 col-md-6 col-xs-12">
					<select name="member_cat" id="member_cat" style="width:200px;height:75px;" multiple="multiple">
						<cfoutput query="get_member_cat">
							<option value="#member_cat_id#">&nbsp;#member_cat#</option>
						</cfoutput>						
					</select>
				</div>
			</div>
		</cfif>
			<div class="form-group">
				<label class="col col-6 col-md-6 col-xs-12"><cf_get_lang dictionary_id="58121.İşlem Dövizi"></label>
				<div class="col col-6 col-md-6 col-xs-12">
					<input type="checkbox" name="is_other_money_transfer" id="is_other_money_transfer" value="1" checked="checked">
				</div>
			</div>
			<div class="form-group">
				<label class="col col-6 col-md-6 col-xs-12"><cf_get_lang dictionary_id="29819.Proje Bazında"></label>
				<div class="col col-6 col-md-6 col-xs-12">
					<input type="checkbox" name="is_project_transfer" id="is_project_transfer" value="1">
				</div>
			</div>
			<div class="form-group">
				<label class="col col-6 col-md-6 col-xs-12"><cf_get_lang dictionary_id="59602.Hesap Tipi Bazında"></label>
				<div class="col col-6 col-md-6 col-xs-12">
					<input type="checkbox" name="is_acc_type_transfer" id="is_acc_type_transfer" value="1">
				</div>
			</div>
			<div class="form-group">
				<label class="col col-6 col-md-6 col-xs-12"><cf_get_lang dictionary_id="59603.Abone Bazında"></label>
				<div class="col col-6 col-md-6 col-xs-12">
					<input type="checkbox" name="is_subscription_transfer" id="is_subscription_transfer" value="1">
				</div>
			</div>
			<div class="form-group">
				<label class="col col-6 col-md-6 col-xs-12"><cf_get_lang dictionary_id="35974.Şube Bazında"></label>
				<div class="col col-6 col-md-6 col-xs-12">
					<input type="checkbox" name="is_branch_transfer" id="is_branch_transfer" value="1">
				</div>
			</div>
			<div class="form-group" id="create_file2" style="display:none;">
				<label class="col col-6 col-md-6 col-xs-12"><cf_get_lang dictionary_id="29539.Satır Bazında"></label>
				<div class="col col-6 col-md-6 col-xs-12">
					<input type="checkbox" name="is_row_info" id="is_row_info">
				</div>
			</div>
			<div class="form-group"  id="close_demand" style="display:none;">
				<label class="col col-6 col-md-6 col-xs-12"><cf_get_lang dictionary_id="42334.Ödeme Talepleri Aktarılsın"></label>
				<div class="col col-6 col-md-6 col-xs-12">
					<input type="checkbox" name="is_demand_transfer" id="is_demand_transfer" value="1">
				</div>
			</div>
			<div class="form-group">
				<label class="col col-6 col-md-6 col-xs-12"></label>
				<div class="col col-6 col-md-6 col-xs-12">
				</div>
			</div>
			
		</div>
		</cf_box_elements>
	    </div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
			<h3><cf_get_lang dictionary_id='57433.Yardım'></h3>
			<cfset getImportExpFormat("close_cari") />
	</div><div class="col col-12">
	<cf_box_footer>
		<cf_workcube_buttons is_upd='0' add_function="kontrol()">
	</cf_box_footer>
</div>
</cfform>
</cf_box>
 </div>
<script type="text/javascript">
	function kontrol()
	{
		if(!chk_process_cat('close_ch')) return false;
		alert_info = "<cf_get_lang dictionary_id='44028.Seçtiğiniz dönemdeki cari hesap bakiyelerini yeni döneme açılış fişi olarak aktarmak üzeresiniz Onaylıyor musunuz'>?";
		if(document.close_ch.period.value == '')
		{
			alert("<cf_get_lang dictionary_id='43274.Dönem Seçmelisiniz'>!");
			return false;
		}
		if(document.close_ch.is_make_age != undefined && document.close_ch.is_make_age.checked == true && document.close_ch.is_branch_transfer.checked == true && document.close_ch.is_row_info.checked == false)
		{
			alert("Ödeme Performansında Şube Bazında Aktarım Yapmak İçin Satır Bazında Aktarım Yapmalısınız !");
			return false;
		}
		if(document.close_ch.is_make_age_manuel != undefined && document.close_ch.is_make_age_manuel.checked == true && (document.close_ch.is_other_money_transfer.checked == false || document.close_ch.is_row_info.checked == false))
		{
			alert("Manuel Ödeme Performansında İşlem Dövizi ve Satır Bazında Seçenekleri Seçili Olmalıdır !");
			return false;
		}
		if(document.close_ch.check_date_rate.checked == true && document.close_ch.action_date_rate.value == '')
		{
			alert("Fiş Tarihi Seçmelisiniz !");
			return false
		}
		if(document.close_ch.is_from_donem.value == 0)
		{
			if(list_getat(document.close_ch.action_date_rate.value,3,'/') != list_getat(document.close_ch.period.value,2,';'))
			{
				alert("Fiş Tarihi Aktarım Yapılacak Dönem İçerisinde Olmalı!");
				return false
			}
		}
		else
		{
			if(list_getat(document.close_ch.action_date_rate.value,3,'/') != parseFloat(list_getat(document.close_ch.period.value,2,';'))+1)
			{
				alert("Fiş Tarihi Aktarım Yapılacak Dönem İçerisinde Olmalı!");
				return false
			}
		}
		if((document.close_ch.is_from_donem.value == 0) && (document.close_ch.cari_file.value == ''))
		{
			alert("<cf_get_lang dictionary_id='43275.Dosya Seçmelisiniz'>!");
			return false;
		}
		if (confirm(alert_info)) 
		{
			windowopen('','small','cc_che');
			close_ch.action='<cfoutput>#request.self#?fuseaction=settings.emptypopup_close_ch</cfoutput>';
			close_ch.target='cc_che';
			close_ch.submit();
			return false;
		}
		else 
			return false;
	}
	function check_row_info(type)
	{
		if(type== 1 && document.close_ch.is_make_age.checked == true)
			document.close_ch.is_make_age_manuel.checked = false;
		else if(type== 2 && document.close_ch.is_make_age_manuel.checked == true)
			document.close_ch.is_make_age.checked = false;
		if(document.close_ch.is_make_age.checked == true || document.close_ch.is_make_age_manuel.checked == true)
			create_file2.style.display = '';
		else
			create_file2.style.display = 'none';
		if(document.close_ch.is_make_age_manuel.checked == true)
			close_demand.style.display = '';
		else
			close_demand.style.display = 'none';
	}
	function show_options_info(table_type_info)
	{
		if(table_type_info == 'from_period')
		{
			document.close_ch.is_from_donem.value = 1;
			from_period.style.display = '';
			<cfif is_select_ch eq 1>
				from_period2.style.display = '';
			</cfif>
			<cfif is_select_ch_cat eq 1 and not isdefined("attributes.is_employee")>
				from_period3.style.display = '';
			</cfif>
			from_file.style.display = 'none';
			general_options.style.display = '';
		}
		else if(table_type_info == 'from_file')
		{
			document.close_ch.is_from_donem.value = 0;
			from_period.style.display = 'none';
			<cfif is_select_ch eq 1>
				from_period2.style.display = 'none';
			</cfif>
			<cfif is_select_ch_cat eq 1 and not isdefined("attributes.is_employee")>
				from_period3.style.display = 'none';
			</cfif>
			from_file.style.display = '';
			general_options.style.display = '';
		}
	}

select_close.onchange=function (){
    if(document.getElementById("select_close").value=="select_period"){show_options_info('from_period');}
    else if(document.getElementById("select_close").value=="select_file"){show_options_info('from_file');}
	else {from_period.style.display = 'none';
	      from_file.style.display = 'none';
		  general_options.style.display = 'none';
}
}
</script>
