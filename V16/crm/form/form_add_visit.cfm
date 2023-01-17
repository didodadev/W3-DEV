<cfif fusebox.use_period eq true>
    <cfset dsn2 = dsn2>
<cfelse>
    <cfset dsn2 = dsn>
</cfif>
<cfquery name="GET_EVENT_CATS" datasource="#DSN#">
	SELECT * FROM SETUP_VISIT_TYPES ORDER BY VISIT_TYPE
</cfquery>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT
		BRANCH_NAME,
		BRANCH_ID
	FROM 
		BRANCH,
		COMPANY_BOYUT_DEPO_KOD
	WHERE
		COMPANY_BOYUT_DEPO_KOD.W_KODU = BRANCH.BRANCH_ID AND
		BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
	ORDER BY 
		BRANCH_NAME
</cfquery>
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_EXPENSE" datasource="#dsn2#">
	SELECT * FROM EXPENSE_ITEMS ORDER BY EXPENSE_ITEM_NAME
</cfquery>
<cfform name="add_event" method="post" action="#request.self#?fuseaction=crm.emptypopup_add_visit">
<cf_box title="#getlang('','Ziyaret Planları','51824')# : #getlang('','Yeni Kayıt','45697')#">
	<cf_box_elements>
	<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
		<div class="form-group" id="item-plan">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51861.Plan Adı'> *</label>
			<div class="col col-8 col-xs-12"> 
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='51899.Olay Ziyaret Başlığını Giriniz'> !</cfsavecontent>
				<cfinput type="text" name="warning_head" required="Yes" message="#message#" maxlength="100" style="width:190px;">
			</div>
		</div>
		<div class="form-group" id="item-process">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
			<div class="col col-8 col-xs-12"> 
				<cf_workcube_process is_upd='0' process_cat_width='190' is_detail='0'>
			</div>
		</div>
		<div class="form-group" id="item-visit">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51826.Ziyaret Formu'></label>
			<div class="col col-8 col-xs-12"> 
				<div class="input-group">
			    <input type="hidden" name="analyse_id" id="analyse_id">
                <input type="text" name="analyse_head" id="analyse_head" style="width:190px;">
				<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_analyse&field_id=add_event.analyse_id&field_name=add_event.analyse_head','list');"></span>
			</div>
		</div>
		</div>
		<div class="form-group" id="item-branch">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51554.Yetkili Şubeler'> *</label>
			<div class="col col-8 col-xs-12"> 
			    <select name="sales_zones" id="sales_zones" style="width:190px;">
					<option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
					<cfoutput query="get_branch">
						<option value="#branch_id#">#branch_name#</option>
					</cfoutput>
				</select>
			</div>
		</div>
	</div>
	<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
		<div class="form-group" id="item-detail">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
			<div class="col col-8 col-xs-12"> 
			    <textarea name="event_detail" id="event_detail" style="width:180px;height:60px;"></textarea>
			</div>
		</div>
		<div class="form-group" id="item-branch">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55763.Tarihler'> *</label>
			<div class="col col-8 col-xs-12"> 
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='50060.Başlama Tarihini Doğru Giriniz !'></cfsavecontent>
					<div class="col col-6 col-xs-12"> 
						<div class="input-group">
					<cfif isdefined('attributes.is_detail_search')>
						<cfinput type="text" name="main_start_date" validate="#validate_style#" message="#message#" value="#dateformat(now(),dateformat_style)#" required="yes" style="width:65px">
					<cfelse>
						<cfinput  type="text" name="main_start_date" validate="#validate_style#" message="#message#" value="" required="yes" style="width:65px">
					</cfif>
					<span class="input-group-addon"><cf_wrk_date_image date_field="main_start_date"> </span>
					</div>
					</div>
					<div class="col col-6 col-xs-12"> 
						<div class="input-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='50059.Bitiş Tarihi Doğru Giriniz'></cfsavecontent>
					<cfif isdefined('attributes.is_detail_search')>
						<cfinput type="text"  name="main_finish_date" validate="#validate_style#" message="#message#" value="#dateformat(now(),dateformat_style)#" required="yes" style="width:65px">
					<cfelse>
						<cfinput type="text"  name="main_finish_date" validate="#validate_style#" message="#message#" value="" required="yes" style="width:65px">
					</cfif>
					<span class="input-group-addon"><cf_wrk_date_image date_field="main_finish_date"></span>
				</div>
			</div>
			</div>
		</div>
	</div>
	<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
		<div id="cc" style="width:100%;height:99%; z-index:88; overflow:auto;">
			<cfsavecontent variable="txt_2"><cf_get_lang dictionary_id='58773.Bilgi Verilecekler'></cfsavecontent>
			<cf_workcube_to_cc is_update="0" cc_dsp_name="#txt_2#" form_name="add_event" str_list_param="1" data_type="1">
		  </div>
	</div>
</cf_box_elements>
	<cf_basket id="add_visit_bask">
		<cfinclude template="../display/list_visit_rows.cfm">
	</cf_basket>
    <cf_box_footer><cf_workcube_buttons is_upd='0' add_function='check()'></cf_box_footer>
	</cf_box>

</cfform>
<script type="text/javascript">
function check()
{
	if(document.all.process_stage.value == "")
	{
		alert("<cf_get_lang dictionary_id='57976.Lütfen Süreçlerinizi Tanımlayınız ve veya Tanımlanan Süreçler Üzerinde Yetkiniz Yok'> !");
		return false;
	}
	x = document.add_event.sales_zones.selectedIndex;
	if (document.add_event.sales_zones[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='30126.Şube Seçiniz'> !");
		return false;
	}
	if (document.add_event.record_num.value == 0)
	{
		alert("<cf_get_lang dictionary_id='52053.Lütfen Eczane Seçiniz'> !");
		return false;
	}
	row_kontrol=0;
	for(r=1;r<=add_event.record_num.value;r++)
	{
		deger_row_kontrol = eval("document.add_event.row_kontrol"+r);
		deger_start_date = eval("document.add_event.start_date"+r);
		deger_start_clock = eval("document.add_event.start_clock"+r);
		deger_start_minute = eval("document.add_event.start_minute"+r);
		deger_finish_date = eval("document.add_event.start_date"+r);
		deger_finish_clock = eval("document.add_event.finish_clock"+r);
		deger_finish_minute = eval("document.add_event.finish_minute"+r);
		deger_pos_emp_name = eval("document.add_event.pos_emp_name"+r);
		deger_warning_id = eval("document.add_event.warning_id"+r);
		if(deger_row_kontrol.value == 1)
		{
			row_kontrol++;
			if(deger_start_date.value == "" || deger_start_date.value.length!=10)
			{
				deger_start_date.focus();
				alert("<cf_get_lang dictionary_id='41039.Lütfen Başlangıç Tarihi Giriniz'> !");
				return false;
			}
			if(!CheckEurodate(deger_start_date.value,r+'. Tarih'))
			{ 
				deger_start_date.focus();
				return false;
			}
			if (!time_check(r))
				return false;
		
			if ((deger_start_date.value != "") && (deger_finish_date.value != ""))
			{
				tarih1_ = deger_start_date.value.substr(6,4) + deger_start_date.value.substr(3,2) + deger_start_date.value.substr(0,2);
				tarih2_ = deger_finish_date.value.substr(6,4) + deger_finish_date.value.substr(3,2) + deger_finish_date.value.substr(0,2);
				
				if (deger_start_clock.value.length < 2) saat1_ = '0' + deger_start_clock.value; else saat1_ = deger_start_clock.value;
				if (deger_start_minute.value.length < 2) dakika1_ = '0' + deger_start_minute.value; else dakika1_ = deger_start_minute.value;
				if (deger_finish_clock.value.length < 2) saat2_ = '0' + deger_finish_clock.value; else saat2_ = deger_finish_clock.value;
				if (deger_finish_minute.value.length < 2) dakika2_ = '0' + deger_finish_minute.value; else dakika2_ = deger_finish_minute.value;
			
				tarih1_ = tarih1_ + saat1_ + dakika1_;
				tarih2_ = tarih2_ + saat2_ + dakika2_;	
				if (tarih1_ >= tarih2_)
				{
					alert("<cf_get_lang dictionary_id='41041.Ziyaret Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır'> !");
					return false;
				}
			}	
			x = deger_warning_id.selectedIndex;
			if (deger_warning_id[x].value == "")
			{ 
				alert ("<cf_get_lang dictionary_id='41042.Lütfen Ziyaret Nedeni Giriniz '>!");
				return false;
			}	
			if(deger_pos_emp_name.value == "")
			{
				alert("<cf_get_lang dictionary_id='41043.Lütfen Ziyaret Edecekler Satırına En Az Bir Kişi Ekleyiniz '>!");
				return false;
			}
		}
	}
	if(row_kontrol == 0 )
	{
		alert("<cf_get_lang dictionary_id='52053.Lütfen Eczane Seçiniz'> !");
		return false;
	}	
	return true;	
}

function sil(sy)
{
	var my_element=eval("add_event.row_kontrol"+sy);
	my_element.value=0;
	var my_element=eval("frm_row"+sy);
	my_element.style.display="none";
}

function kontrol_et()
{
	if(row_count ==0)
		return false;
	else
		return true;
}

function pencere_ac(no)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_buyer_seller=0&field_id=add_event.partner_id' + no +'&field_comp_name=add_event.company_name' + no +'&field_name=add_event.partner_name' + no +'&field_comp_id=add_event.company_id' + no + '&is_crm_module=1&select_list=2,6','project');
}
function temizlerim(no)
{
	var my_element=eval("add_event.pos_emp_id"+no);
	var my_element2=eval("add_event.pos_emp_name"+no);
	my_element.value='';
	my_element2.value='';
}

function pencere_ac_pos(no)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multi_pars&field_id=add_event.pos_emp_id' + no +'&field_name=add_event.pos_emp_name' + no +'&select_list=1&is_upd=0','list');
}

function pencere_ac_inf(no)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multi_pars&field_id=add_event.inf_emp_id' + no +'&field_name=add_event.inf_emp_name' + no +'&select_list=1&is_upd=0','list');
}

function pencere_ac_company(no)
{
	if((add_event.main_start_date.value == '') || (add_event.main_finish_date.value == ''))
	{
		alert("<cf_get_lang dictionary_id='51864.Önce Ziyaret Tarihlerini Giriniz'>!");
		return false;
	}
	else	
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multiuser_company&kontrol_startdate='+add_event.main_start_date.value+'&record_num_=' + add_event.record_num.value +'&is_first=1&startdate=' + add_event.main_start_date.value +'');
}

function time_check(satir_deger)
{
	check_start_date = eval("document.add_event.start_date"+satir_deger);
	tarih_main_start_date = add_event.main_start_date.value.substr(6,4) + add_event.main_start_date.value.substr(3,2) + add_event.main_start_date.value.substr(0,2);
	tarih_main_finish_date = add_event.main_finish_date.value.substr(6,4) + add_event.main_finish_date.value.substr(3,2) + add_event.main_finish_date.value.substr(0,2);
	check_start = check_start_date.value.substr(6,4) + check_start_date.value.substr(3,2) + check_start_date.value.substr(0,2);
	if((check_start < tarih_main_start_date) || (check_start > tarih_main_finish_date))
	{
		alert("<cf_get_lang dictionary_id='51867.Tarih Başlangıç ve Bitiş Tarihleri Arasında Olmalıdır'> !");
		check_start_date.value = "";
		check_start_date.focus();
		return false;
	}
	return true;
}
<cfquery name="GET_POSITIONID" datasource="#DSN#">
	SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid#
</cfquery>
<cfif isdefined("attributes.is_target")>
	row_count=0;
	<cfoutput>
	<cfloop list="#attributes.target_company_id#" index="i">
			<cfquery name="GET_COMPANY_PART"  datasource="#dsn#">
				SELECT
					COMPANY.COMPANY_ID,
					COMPANY.FULLNAME,
					COMPANY_PARTNER.PARTNER_ID,
					COMPANY_PARTNER.COMPANY_PARTNER_NAME,
					COMPANY_PARTNER.COMPANY_PARTNER_SURNAME
				FROM
					COMPANY,
					COMPANY_PARTNER
				WHERE
					COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND 
					COMPANY_PARTNER.PARTNER_ID = #i#
			</cfquery>
			row_count++;
			var newRow;
			var newCell;
			var tarihim1 = add_event.main_start_date.value;
			document.all.record_num.value=row_count;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);		
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a>';		
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" ><input type="hidden" name="company_id' + row_count +'" value="<cfoutput>#get_company_part.company_id#</cfoutput>"><input type="text" name="company_name' + row_count +'" readonly="" style="width:140;" value="<cfoutput>#get_company_part.fullname#</cfoutput>">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="partner_id' + row_count +'" value="#get_company_part.partner_id#"><input type="text" name="partner_name' + row_count +'" readonly="" style="width:135;" value="<cfoutput>#get_company_part.company_partner_name# #get_company_part.company_partner_surname#</cfoutput>"><a href="javascript://" onClick="pencere_ac(' + row_count +');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			
			newCell.setAttribute("id","start_date" + row_count + "_td");
			newCell.innerHTML = '<input type="text" name="start_date' + row_count +'" class="text" maxlength="10" style="width:65px;" value="'+tarihim1+'">';
			wrk_date_image('start_date' + row_count);

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="start_clock' + row_count +'" style="width:45px;"><option value="0" selected>Saat</option><cfloop from="7" to="30" index="i"><cfset saat=i mod 24><option value="#saat#" <cfif saat eq 9>selected</cfif>>#saat#</option></cfloop></select> <select name="start_minute' + row_count +'" style="width:40px;"><option value="00">00</option><option value="05">05</option><option value="10">10</option><option value="15">15</option><option value="20">20</option><option value="25">25</option><option value="30">30</option><option value="35">35</option><option value="40">40</option><option value="45">45</option><option value="50">50</option><option value="55">55</option></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="finish_clock' + row_count +'" style="width:45px;"><option value="0" selected>Saat</option><cfloop from="7" to="30" index="i"><cfset saat=i mod 24><option value="#saat#" <cfif saat eq 17>selected</cfif>>#saat#</option></cfloop></select> <select name="finish_minute' + row_count +'" style="width:40px;"><option value="00">00</option><option value="05">05</option><option value="10">10</option><option value="15">15</option><option value="20">20</option><option value="25">25</option><option value="30" selected>30</option><option value="35">35</option><option value="40">40</option><option value="45">45</option><option value="50">50</option><option value="55">55</option></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="warning_id' + row_count +'" style="width:150px;"><option value="" selected>Kategori Seçiniz !</option><cfloop query="get_event_cats"><option value="#visit_type_id#">#visit_type#</option></cfloop></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="pos_emp_id' + row_count +'" value="#session.ep.position_code#,"><input type="text" name="pos_emp_name' + row_count +'" readonly="" style="width:170;" value="#get_emp_info(session.ep.userid,0,0)#,"> <a href="javascript://" onClick="temizlerim(' + row_count +');pencere_ac_pos(' + row_count +');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>';
	</cfloop>
	</cfoutput>
</cfif>
function manage_date(gelen_alan)
{
	wrk_date_image(gelen_alan);
}
</script>
