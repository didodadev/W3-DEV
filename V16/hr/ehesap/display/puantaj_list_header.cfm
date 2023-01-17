<!---
    File: V16\hr\ehesap\display\puantaj_list_header.cfm
    Edit: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2020-11-13
    Description: Puantaj Listeleme, Puantaj Oluşturma, Muhasebe Oluşturma, Bütçe Oluşturma, Puantaj Kilitleme,
	Ücret Dekontu oluşturma fonksiyonlarının bulunduğu dosya.
        
    History:
        
    To Do:
--->
<style>.fa-angle-down{cursor:pointer;}.activeTr{background:#f5f5f5;}.flagTrue{color:green;}.flagFalse{color:red;}.flagWarning{color:orange;}</style>
<cfparam name="attributes.sal_year" default="#year(now())#">
<cfif month(now()) eq 1>
	<cfparam name="attributes.sal_mon" default="1">
<cfelse>
	<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
</cfif>
<cfinclude template="../query/get_ssk_offices.cfm">
<script src="/v16/JS/sweetalert/sweetalert2.min.js"></script>
<link rel="stylesheet" href="/v16/css/assets/template/sweetalert/sweetalert2.min.css">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.ssk_office" default="0">
<cfparam name="attributes.ssk_statue" default="0">
<cfparam name="attributes.statue_type_emp" default="0">
<cfparam name="attributes.statue_type_individual_emp" default="">
<cfparam name="attributes.statue_type_individual" default="">
<cfparam name="attributes.statue_type" default="0">
<cfparam name="attributes.hierarchy_puantaj" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset periods = createObject('component','V16.objects.cfc.periods')>
<cfset period_years = periods.get_period_year()>

<!--- Münferit ödeme --->
<cfset get_pay_cmp = createObject('component','V16.hr.ehesap.cfc.hourly_addfare_percantege')>
<cfset get_pay_type = get_pay_cmp.get_allowance(ssk_statue: 2, statue_type: 10)>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box scroll="0">
		<div class="flex-list ui-form-list">		
			<div class="form-group" class="pull-left">
				<select name="branch_or_user" id="branch_or_user" onChange="gizle_goster(sube_puantaj);gizle_goster(kisi_puantaj);">
					<option value="1"><cf_get_lang dictionary_id='57453.Şube'></option>
					<option value="2"><cf_get_lang dictionary_id='29831.Kişi'></option>
				</select>
			</div>
			<cfform name="employee" method="post" action="" id="sube_puantaj" class="pull-left">
			<div class="ui-form-list flex-list">
				<div class="form-group x-16">
					<select name="ssk_office" id="ssk_office">
						<cfoutput query="GET_SSK_OFFICES" group="nick_name">
							<cfif len(SSK_OFFICE) and len(SSK_NO)>
								<optgroup label="#nick_name#"></optgroup>
								<cfoutput>
									<option value="#BRANCH_ID#"<cfif attributes.ssk_office is BRANCH_ID> selected</cfif>>#BRANCH_NAME#-#SSK_OFFICE#-#SSK_NO#</option>
								</cfoutput>
							</cfif>
						</cfoutput>
					</select>
				</div>				
				<div class="form-group">
					<select name="ssk_statue" id="ssk_statue">
						<option value="0"><cf_get_lang dictionary_id='57894.Statü'></option>
						<option value="1" <cfif attributes.ssk_statue eq 1>selected</cfif>><cf_get_lang dictionary_id='45049.Worker'></option>
						<option value="2" <cfif attributes.ssk_statue eq 2>selected</cfif>><cf_get_lang dictionary_id='62870.Memur'></option>
						<option value="3" <cfif attributes.ssk_statue eq 3>selected</cfif>><cf_get_lang dictionary_id='62871.Serbest Çalışan'></option>
					</select>
				</div>
				<div class="form-group" id="statue_type_div"<cfif attributes.ssk_statue neq 2>style="display:none;"</cfif>>
					<select name="statue_type" id="statue_type">
						<option value="0"><cf_get_lang dictionary_id='30152.Tipi'></option>
						<option value="1" <cfif attributes.statue_type eq 1>selected</cfif>><cf_get_lang dictionary_id='40071.Maaş'></option>
						<option value="2" <cfif attributes.statue_type eq 2>selected</cfif>><cf_get_lang dictionary_id='62888.Döner Sermaye'></option>
						<option value="3" <cfif attributes.statue_type eq 3>selected</cfif>><cf_get_lang dictionary_id='62956.Ek Ders'></option>
						<option value="4" <cfif attributes.statue_type eq 4>selected</cfif>><cf_get_lang dictionary_id='58015.Projeler'></option>
						<option value="5" <cfif attributes.statue_type eq 5>selected</cfif>><cf_get_lang dictionary_id='58583.Fark'></option>
						<option value="6" <cfif attributes.statue_type eq 6>selected</cfif>><cf_get_lang dictionary_id='64673.Jüri Üyeliği'></option>
						<option value="7" <cfif attributes.statue_type eq 7>selected</cfif>><cf_get_lang dictionary_id='64569.Arazi Tazminatı'></option>
						<option value="8" <cfif attributes.statue_type eq 8>selected</cfif>><cf_get_lang dictionary_id='63103.Sanatçı'></option>
						<option value="9" <cfif attributes.statue_type eq 9>selected</cfif>><cf_get_lang dictionary_id='59208.Fazla Mesai'></option>
						<option value="10" <cfif attributes.statue_type eq 10>selected</cfif>><cf_get_lang dictionary_id='65182.Münferit Ödeme'></option>
						<option value="11" <cfif attributes.statue_type eq 11>selected</cfif>><cf_get_lang dictionary_id='65215.Zimmet Yersiz'> / <cf_get_lang dictionary_id='65216.Geçmiş Dönem'></option>
					</select>
				</div>
				<div class="form-group" id="statue_type_individual_div"<cfif attributes.statue_type neq 10>style="display:none;"</cfif>>
					<select name="statue_type_individual" id="statue_type_individual">
						<option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<cfoutput query="get_pay_type">
							<option value="#ODKES_ID#">#COMMENT_PAY#</option>
						</cfoutput>
					</select>
				</div>
				<cfif x_select_special_code eq 1>
					<div class="form-group">
						<label><cf_get_lang dictionary_id='57789.Özel Kod'></label>
						<input type="text" name="hierarchy_puantaj" id="hierarchy_puantaj" maxlength="50" value="">
					</div>
				<cfelse>
					<input type="hidden" name="hierarchy_puantaj" id="hierarchy_puantaj" value="">
				</cfif>
				<div class="form-group">
					<select name="sal_mon" id="sal_mon">
						<cfloop from="1" to="12" index="i">
							<cfoutput>
							<option value="#i#" <cfif month(now()) gt 1 and i eq month(now())-1>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
							</cfoutput>
						</cfloop>
					</select>				
				</div>
				<div class="form-group">
					<select name="sal_year" id="sal_year">
						<cfloop from="#period_years.period_year[1]-period_years.recordcount#" to="#period_years.period_year[period_years.recordcount]+3#" index="i">
							<cfoutput>
								<option value="#i#" <cfif (isdefined("attributes.sal_year") and attributes.sal_year eq i) or (not isdefined("attributes.sal_year") and year(now()) eq i)>selected</cfif>>#i#</option>
							</cfoutput>
						</cfloop>
					</select>
				</div>				
				<cfif x_select_puantaj_type eq 1>
					<div class="form-group x-16">
						<select name="puantaj_type" id="puantaj_type" onChange  = "open_detail_select()">
							<option value="-1" selected><cf_get_lang dictionary_id="38606.Ücret ve ödenek verilerine göre"></option>
							<option value="0"><cf_get_lang dictionary_id="38603.Planlanan maaşa göre"></option>
							<option value="-2"><cf_get_lang dictionary_id="38602.Planlanan ve ücret ödenek arasındaki farka göre"></option>
							<!--- <option value="-3">Son Puantaj</option> --->
						</select>
					</div>
					<div class="form-group" id = "detail_select_div">
						<select name="detail_select" id="detail_select">
							<option value="1"><cf_get_lang dictionary_id="58052.Özet"></option>
							<option value="2"><cf_get_lang dictionary_id="57771.Detay"></option>
						</select>
					</div>
				<cfelse>
					<input type="hidden" name="puantaj_type" id="puantaj_type" value="-1">	
				</cfif>					
				<cf_workcube_buttons update_status="0" extraButton="1" extraButtonText="#getLang('','Listele',58715)#" extraFunction='open_form_ajax()' extraButtonClass="ui-wrk-btn ui-wrk-btn-extra">
				<div id="menu_puantaj_1"></div>
				<div id="menu_puantaj_3"></div>
			</div>					
			</cfform>
			<cfform name="emp_puantaj" method="post" action="" id="kisi_puantaj" style="display:none;" class="pull-left">
				<div class="ui-form-list flex-list">
					<input type="hidden" id="employee_id" name="employee_id" value="">
					<div class="form-group">
						<div class="input-group">
							<input type="text" name="employee_name" value="" id="employee_name" autocomplete="off" onFocus="AutoComplete_Create('employee_name','FULLNAME,TC_IDENTY_NO,SOCIALSECURITY_NO,RETIRED_SGDP_NUMBER','FULLNAME,BRANCH_NAME','get_in_outs_autocomplete','','FULLNAME,EMPLOYEE_ID','employee_name,employee_id','emp_puantaj','3','300');">
							<span class="input-group-addon icon-ellipsis btnPointer"  onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emp_in_out&conf_=1&field_emp_id=emp_puantaj.employee_id&field_emp_name=emp_puantaj.employee_name','list');"></span>
						</div>							
					</div>
					<div class="form-group">
						<select name="ssk_statue_emp" id="ssk_statue_emp">
							<option value="0"><cf_get_lang dictionary_id='57894.Statü'></option>
							<option value="1" <cfif attributes.ssk_statue eq 1>selected</cfif>><cf_get_lang dictionary_id='45049.Worker'></option>
							<option value="2" <cfif attributes.ssk_statue eq 2>selected</cfif>><cf_get_lang dictionary_id='62870.Memur'></option>
							<option value="3" <cfif attributes.ssk_statue eq 3>selected</cfif>><cf_get_lang dictionary_id='62871.Serbest Çalışan'></option>
						</select>
					</div>
					<div class="form-group" id="statue_type_div_emp"<cfif attributes.ssk_statue neq 2>style="display:none;"</cfif>>
						<select name="statue_type_emp" id="statue_type_emp">
							<option value="0"><cf_get_lang dictionary_id='30152.Tipi'></option>
							<option value="1" <cfif attributes.statue_type_emp eq 1>selected</cfif>><cf_get_lang dictionary_id='40071.Maaş'></option>
							<option value="2" <cfif attributes.statue_type_emp eq 2>selected</cfif>><cf_get_lang dictionary_id='62888.Döner Sermaye'></option>
							<option value="3" <cfif attributes.statue_type_emp eq 3>selected</cfif>><cf_get_lang dictionary_id='62956.Ek Ders'></option>
							<option value="4" <cfif attributes.statue_type_emp eq 4>selected</cfif>><cf_get_lang dictionary_id='58015.Projeler'></option>
							<option value="6" <cfif attributes.statue_type_emp eq 6>selected</cfif>><cf_get_lang dictionary_id='64673.Jüri Üyeliği'></option>
							<option value="7" <cfif attributes.statue_type_emp eq 7>selected</cfif>><cf_get_lang dictionary_id='64569.Arazi Tazminatı'></option>
							<option value="8" <cfif attributes.statue_type_emp eq 8>selected</cfif>><cf_get_lang dictionary_id='63103.Sanatçı'></option>
							<option value="9" <cfif attributes.statue_type_emp eq 9>selected</cfif>><cf_get_lang dictionary_id='59208.Fazla Mesai'></option>
							<option value="10" <cfif attributes.statue_type_emp eq 10>selected</cfif>><cf_get_lang dictionary_id='65182.Münferit Ödeme'></option>
							<option value="11" <cfif attributes.statue_type_emp eq 11>selected</cfif>><cf_get_lang dictionary_id='65215.Zimmet Yersiz'> / <cf_get_lang dictionary_id='65216.Geçmiş Dönem'></option>	
						</select>
					</div>
					<div class="form-group" id="statue_type_individual_div_emp"<cfif attributes.statue_type neq 10>style="display:none;"</cfif>>
						<select name="statue_type_individual_emp" id="statue_type_individual_emp">
							<option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_pay_type">
								<option value="#ODKES_ID#">#COMMENT_PAY#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group">
						<select name="emp_sal_mon" id="emp_sal_mon">
							<cfloop from="1" to="12" index="i">
								<cfoutput>
									<option value="#i#" <cfif month(now()) gt 1 and i eq month(now())-1>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
								</cfoutput>
							</cfloop>
						</select>							
					</div>				
					<div class="form-group">
						<select name="emp_sal_year" id="emp_sal_year">
							<cfloop from="#period_years.period_year[1]-period_years.recordcount#" to="#period_years.period_year[period_years.recordcount]+3#" index="i">
								<cfoutput>
									<option value="#i#" <cfif (isdefined("attributes.emp_sal_year") and attributes.emp_sal_year eq i) or (not isdefined("attributes.emp_sal_year") and year(now()) eq i)>selected</cfif>>#i#</option>
								</cfoutput>
							</cfloop>
						</select>							
					</div>				
					<cfif x_select_puantaj_type eq 1>
						<div class="form-group">
							<select name="employee_puantaj_type" id="employee_puantaj_type">
								<option value="-1" selected><cf_get_lang dictionary_id="38606.Ücret ve ödenek verilerine göre"></option>
								<option value="0"><cf_get_lang dictionary_id="38603.Planlanan maaşa göre"></option>
								<!--- <option value="-2">Fark Puantajı</option>
								<option value="-3">Son Puantaj</option> --->
							</select>							
						</div>
					<cfelse>
						<input type="hidden" name="employee_puantaj_type" id="employee_puantaj_type" value="-1">	
					</cfif>					
					<cf_workcube_buttons update_status="0" extraButton="1" extraButtonText="#getLang('','Listele',58715)#" extraFunction='open_form_ajax()' extraButtonClass="ui-wrk-btn ui-wrk-btn-extra">
					<div id="menu_puantaj_2"></div>				
				</div>													
			</cfform>
		</div>													
	</cf_box>
</div>

<script type="text/javascript">
	flag_counter = 1;
	main_adress = '';
	$( "#ssk_statue" ).change(function() {
		if($("#ssk_statue").val() == 2)
			$("#statue_type_div").css("display","");
		else{
			$("#statue_type_div").css("display","none");
			$("#statue_type").val(0);
			$("#statue_type_individual_div").css("display","none");
			$("#statue_type_individual").val(0);
		}
	});

	$( "#ssk_statue_emp" ).change(function() {
		if($("#ssk_statue_emp").val() == 2)
			$("#statue_type_div_emp").css("display","");
		else
		{
			$("#statue_type_div_emp").css("display","none");
			$("#statue_type").val(0);
			$("#statue_type_individual_div_emp").css("display","none");
			$("#statue_type_individual_emp").val(0);
		}
	});

	$( "#statue_type" ).change(function() {
		if($("#statue_type").val() == 10)
			$("#statue_type_individual_div").css("display","");
		else{
			$("#statue_type_individual_div").css("display","none");
			$("#statue_type_individual").val(0);
		}
	});
	
	$( "#statue_type_emp" ).change(function() {
		if($("#statue_type_emp").val() == 10)
			$("#statue_type_individual_div_emp").css("display","");
		else{
			$("#statue_type_individual_div_emp").css("display","none");
			$("#statue_type_individual_emp").val(0);
		}
	});
	function open_form_ajax()
	{ 
		branch_or_user_ = document.getElementById('branch_or_user').value;
		//ehesap.emptypopup_ajax_view_puantaj = ajax_view_puantaj.cfm
		adres_ = '<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_ajax_view_puantaj</cfoutput>';

		//ehesap.emptypopup_ajax_menu_puantaj_sube = ajax_menu_puantaj_branch.cfm
		adres_menu_1 = '<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_ajax_menu_puantaj_sube&x_payment_day=#x_payment_day#&x_puantaj_lock_permission=#x_puantaj_lock_permission#&x_puantaj_day=#x_puantaj_day#&hierarchy_puantaj=#attributes.hierarchy_puantaj#&x_select_process=#x_select_process#</cfoutput>';
		
		if(branch_or_user_ == 1)
		{
			ssk_statue = $("#ssk_statue").val();//ssk durumu
			statue_type = $("#statue_type").val();
			statue_type_individual = $("#statue_type_individual").val();
		}else{
			ssk_statue = $("#ssk_statue_emp").val();//ssk durumu
			statue_type = $("#statue_type_emp").val();
			statue_type_individual = $("#statue_type_individual_emp").val();
		}
		console.log(ssk_statue);
		//ehesap.emptypopup_ajax_menu_puantaj_calisan = ajax_menu_puantaj_emp.cfm
		adres_menu_2 = '<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_ajax_menu_puantaj_calisan&x_puantaj_day=#x_puantaj_day#&x_payment_day=#x_payment_day#&hierarchy_puantaj=#attributes.hierarchy_puantaj#&sal_mon=' + document.getElementById('emp_sal_mon').value+'&&sal_year=' + document.getElementById('emp_sal_year').value+'</cfoutput>';
		adres_menu_2 = adres_menu_2 + '&ssk_statue=' + ssk_statue;//SGK Durumu
		adres_menu_2 = adres_menu_2 + '&statue_type=' + statue_type;//maaş tipi
		adres_menu_2 = adres_menu_2 + '&statue_type_individual=' + statue_type_individual;//Münferit ödeme

		
		
		if(ssk_statue == 0)
		{
			alert("<cf_get_lang dictionary_id='52168.Lütfen Statü Seçiniz'>");
			return false;
		}else if(ssk_statue == 2 && statue_type == 0)
		{
			alert("<cf_get_lang dictionary_id='43738.Tip Seçmelisiniz'>");
			return false;
		}else if(ssk_statue == 2 && statue_type == 10 && statue_type_individual == 0)
		{
			alert("<cf_get_lang dictionary_id='65183.Münferit Ödeme Tipinde Ek Ödenek Tanımlamalısınız'>");
			return false;
		}
		<cfif x_select_special_code eq 1>
			if(branch_or_user_ == 1 && document.getElementById('hierarchy_puantaj').value == '')
			{
				alert("<cf_get_lang dictionary_id='53684.Özel Kod Girmelisiniz'> !");
				return false;
			}
		</cfif>
		if(branch_or_user_==1)//Şube
		{
			sal_year_ = document.getElementById('sal_year').value;
			sal_mon_ = document.getElementById('sal_mon').value;

			branch_id_ =document.getElementById('ssk_office').value;
			hierarchy_puantaj_ = document.getElementById('hierarchy_puantaj').value;

			puantaj_type_ = document.getElementById('puantaj_type').value;
			adres_= adres_ + '&branch_or_user=1';
			<cfif x_select_puantaj_type eq 1>
				if(document.getElementById("detail_select_div").style.display != "none"){
					detail_select = document.getElementById("detail_select").value;
					adres_ = adres_ + '&detail_select='+detail_select;
				}
			</cfif>
			var listParam = sal_mon_ + "*" + sal_year_ + "*" + branch_id_ + "*" + puantaj_type_ +"*"+hierarchy_puantaj_+"*"+ssk_statue+"*"+statue_type+"*"+statue_type_individual;
			
			adres_ = adres_ + '&sal_mon=' + document.getElementById('sal_mon').value;
			adres_ = adres_ + '&sal_year=' + document.getElementById('sal_year').value;
			adres_ = adres_ + '&branch_id=' + branch_id_;
			adres_ = adres_ + '&ssk_statue=' + ssk_statue;//SGK Durumu
			adres_ = adres_ + '&statue_type=' + statue_type;//maaş tipi
			adres_ = adres_ + '&statue_type_individual=' + statue_type_individual;//münferit

			if(hierarchy_puantaj_ == '')
				get_puantaj_ = wrk_safe_query("hr_get_puantaj_",'dsn',0,listParam);//puantaj kontrolü
			else
				get_puantaj_ = wrk_safe_query("hr_get_puantaj_hierarchy",'dsn',0,listParam);//puantaj kontrolü

			console.log(get_puantaj_);
			if(get_puantaj_.recordcount>0)
			{
				adres_= adres_ + '&puantaj_id='+get_puantaj_.PUANTAJ_ID +'&hierarchy_puantaj='+hierarchy_puantaj_;
				adres_menu_1= adres_menu_1 + '&puantaj_type='+puantaj_type_ +'&puantaj_id='+get_puantaj_.PUANTAJ_ID +'&hierarchy_puantaj='+hierarchy_puantaj_;
				adres_menu_1 = adres_menu_1 + '&ssk_statue=' + ssk_statue;//SGK Durumu
				adres_menu_1 = adres_menu_1 + '&statue_type=' + statue_type;//maaş tipi
				adres_menu_1 = adres_menu_1 + '&statue_type_individual=' + statue_type_individual;//münferit

				<cfoutput>
					adres_ = adres_ + '&startrow=' + #attributes.startrow#;
					adres_ = adres_ + '&page=' + #attributes.page#;
				</cfoutput>
			}
			<cfoutput>
				adres_menu_1 = adres_menu_1 + '&startrow=' + #attributes.startrow#;
				adres_menu_1 = adres_menu_1 + '&page=' + #attributes.page#;
			</cfoutput>
			AjaxPageLoad(adres_,'puantaj_list_layer','1',"<cf_get_lang dictionary_id ='53891.Puantaj Listeleniyor'>");
			AjaxPageLoad(adres_menu_1,'menu_puantaj_1','1',"<cf_get_lang dictionary_id ='53892.Puantaj Menüsü Yükleniyor'>");
		}
		else if(branch_or_user_==2)
		{
			puantaj_type_ = document.getElementById('employee_puantaj_type').value;
			if(document.getElementById('employee_id').value=='')
			{
				alert("<cf_get_lang dictionary_id ='54139.Kişi Seçmelisiniz'>");
				return false;
			}
			adres_= adres_ + '&puantaj_type=' + puantaj_type_;
			adres_= adres_ + '&employee_id=' + document.getElementById('employee_id').value;
			adres_= adres_ + '&employee_name=' + document.getElementById('employee_name').value;
			adres_= adres_ + '&sal_mon=' + document.getElementById('emp_sal_mon').value;
			adres_= adres_ + '&sal_year=' + document.getElementById('emp_sal_year').value;
			adres_= adres_ + '&renew=1';
			adres_ = adres_ + '&ssk_statue=' + ssk_statue;//SGK Durumu
			adres_ = adres_ + '&statue_type=' + statue_type;//maaş tipi
			adres_ = adres_ + '&statue_type_individual=' + statue_type_individual;//münferit
			
			<cfif x_payment_day eq 1>
				if(document.getElementById('payment_day') != undefined)
				{
					payment_day = document.getElementById('payment_day').value;
					adres_= adres_ + '&payment_day='+payment_day;
				}
			</cfif>
			
			adres_menu_2 = adres_menu_2 + '&puantaj_type=' + puantaj_type_;
			adres_menu_2 = adres_menu_2 + '&employee_id=' + document.getElementById('employee_id').value;
			<cfoutput>
				adres_menu_2 = adres_menu_2 + '&startrow=' + #attributes.startrow#;
				adres_menu_2 = adres_menu_2 + '&page=' + #attributes.page#;
			</cfoutput>
			AjaxPageLoad(adres_,'puantaj_list_layer','1',"<cf_get_lang dictionary_id ='53891.Puantaj Listeleniyor'>");
			AjaxPageLoad(adres_menu_2,'menu_puantaj_2','1',"<cf_get_lang dictionary_id ='53892.Puantaj Menüsü Yükleniyor'>");
		}
		return false;
	 }
	function create_puantaj(row_id)
	{	
		//console.log("create puantaj: "+row_id,flag_counter)
		if(branch_or_user_==1)
		{
			puantaj_type_ = document.getElementById('puantaj_type').value;
		}
		else
		{
			puantaj_type_ = document.getElementById('employee_puantaj_type').value;
		}
		
		if(puantaj_type_ == '-3')
		{
			alert("<cf_get_lang dictionary_id='54624.Son Puantaj Fark Puantajı İle Beraber Oluşur! Bu Adımda Son Puantaj Oluşturulamaz!'>");
			return false;
		}

		create_adres_ = '<cfoutput>V16/hr/ehesap/cfc/payroll_job.cfc?method=create_payroll&x_puantaj_lock_permission=#x_puantaj_lock_permission#&x_payment_day=#x_payment_day#</cfoutput>';
		var sal_year_ = document.getElementById('sal_year').value;
		var sal_mon_ = document.getElementById('sal_mon').value;
		ssk_office_all_ = document.getElementById('ssk_office').value;
		hierarchy_puantaj_ = document.getElementById('hierarchy_puantaj').value;
		branch_id_ = document.getElementById('ssk_office').value;
		process_stage_ = document.getElementById('process_stage').value;
		branch_or_user_ = document.getElementById('branch_or_user').value;
		ssk_statue = $("#ssk_statue").val();//ssk durumu
		statue_type = $("#statue_type").val();
		statue_type_individual = $("#statue_type_individual").val();
		
		<cfif x_select_process eq 1>
			x_select_process_=1
		<cfelse>
			x_select_process_=0
		</cfif>
		<cfif x_payment_day eq 1>
			if(document.getElementById('payment_day') != undefined)
			{
				payment_day = document.getElementById('payment_day').value;
				create_adres_= create_adres_ + '&payment_day=' + payment_day;
			}			 
		</cfif>
		
		var listParam = sal_mon_ + "*" + sal_year_ + "*" + branch_id_ + "*" + puantaj_type_ + "*" +ssk_statue+"*"+statue_type+"*"+statue_type_individual;
		get_puantaj2_ = wrk_safe_query("hr_get_puantaj_2",'dsn',0,listParam);
		if(get_puantaj2_.recordcount>0)
		{	
			ay_list2 = "<cfoutput>#getLang(180,'Ocak',57592)#,#getLang(181,'Şubat',57593)#,#getLang(182,'Mart',57594)#,#getLang(183,'Nisan',57595)#,#getLang(184,'Mayıs',57596)#,#getLang(185,'Haziran',57597)#,#getLang(186,'Temmuz',57598)#,#getLang(187,'Ağustos',57599)#,#getLang(188,'Eylül',57600)#,#getLang(189,'Ekim',57601)#,#getLang(190,'Kasım',57602)#,#getLang(191,'Aralık',57603)#</cfoutput>";
			aylar = "";
			for(i=0; i<get_puantaj2_.recordcount; i++)
			{
				if(get_puantaj2_.recordcount > 1 && i >0)
				{	
					aylar = aylar+', ';
				}
				aylar = aylar+list_getat(ay_list2,get_puantaj2_.SAL_MON[i],',');
			}
			alert("<cf_get_lang dictionary_id ='53893.İlgili şubenin ileri tarihli bir puantaj kaydı var geçmiş tarihli puantaj çalıştıramazsınız'>("+ aylar +")");
			return false;
		}
		//harcırah kontrolü
		var listParam_2 = sal_mon_+'*'+sal_year_+'*'+branch_id_;
		get_puantaj_2 = wrk_safe_query('hr_control_expense_puantaj_3','dsn',0,listParam_2);
		if(get_puantaj_2.recordcount>0)
		{
			alert("<cf_get_lang dictionary_id='54625.Çalışan İçin İleri Tarihli Bir Harcırah Kaydı Var Geçmiş Tarihli Puantaj Çalıştıramazsınız'> !");
			return false;
		}
		if(hierarchy_puantaj_ != '')//özel kod dolu ise özel kodsuz çalışan puantaj var mı diye bakılıyor
		{
			get_puantaj2_ = wrk_safe_query("hr_get_puantaj_4",'dsn',0,listParam);
			if(get_puantaj2_.recordcount>0)
			{
				alert("<cf_get_lang dictionary_id='54626.Şube İçin Genel Puantaj Çalıştırıldığı İçin Puantaj Çalıştıramazsınız'> !");
				return false;
			}
		}
		else//Değilse özel kodlu çalışan var mı diye bakılıyor
		{
			get_puantaj2_ = wrk_safe_query("hr_get_puantaj_5",'dsn',0,listParam);
			if(get_puantaj2_.recordcount>0)
			{
				alert("<cf_get_lang dictionary_id='54627.Şube İçin Özel Kod İle Çalıştırıldığı İçin Puantaj Çalıştıramazsınız'> !");
				return false;
			}
		}
	
		create_adres_= create_adres_ + '&sal_mon=';
		create_adres_= create_adres_ + sal_mon_ + '&sal_year=';
		create_adres_= create_adres_ + sal_year_ + '&ssk_office='; 
		create_adres_= create_adres_ + encodeURI(ssk_office_all_);
		create_adres_= create_adres_ + '&hierarchy_puantaj=' + hierarchy_puantaj_;
		create_adres_= create_adres_ + '&process_stage=' + process_stage_;
		create_adres_= create_adres_ + '&renew=1';
		create_adres_= create_adres_ + '&puantaj_type=' + puantaj_type_;
		create_adres_= create_adres_ + '&x_select_process=' + x_select_process_;
		create_adres_= create_adres_ + '&ssk_statue=' + ssk_statue;
		create_adres_= create_adres_ + '&statue_type=' + statue_type;
		create_adres_= create_adres_ + '&statue_type_individual=' + statue_type_individual;

		

		main_adress = create_adres_;
		if(row_id != undefined)
		{
			var fileid = row_id;
			is_row = 1;
		}
		else
		{
			var fileid = $("input[data-id = fileids_1]").val();
			is_row = 0;
		}
			//console.log("fileid : "+fileid);
		request_adres= create_adres_ + '&in_out_id=' + fileid;
		$(this).find('input[type = submit]').prop('disabled', true);
		

		<cfif x_select_process eq 1>
			if (process_cat_control())
				startRequest(fileid,request_adres,1,is_row);
		<cfelse>
			startRequest(fileid,request_adres,1,is_row);
		</cfif>
	}
	function startRequest( fileid,create_adres_, checkboxid,is_row ){
		//flag atamaları
		var flag = $("input#fileids_"+fileid+"").parent('td').find('i');
		var flag_account = $("input#account_"+fileid+"").parent('td').find('i');
		var flag_budget = $("input#budget_"+fileid+"").parent('td').find('i');

		var record_count = $('#record_count').val();
		
		if(is_row != undefined && is_row == 1)
			flag_counter = $('#record_count').val();
			$.ajax({
            url: 'V16/hr/ehesap/cfc/payroll_job.cfc?method=get_payroll_control&in_out_id='+fileid+'&puantaj_id='+get_puantaj_.PUANTAJ_ID+'&ssk_statue='+ssk_statue+'&statue_type='+statue_type+'&statue_type_individual='+statue_type_individual,
            dataType: "json",
			method: "post",
            success: function( objResponse )
			{
				if(objResponse)
				{
					message_confirm = "<cf_get_lang dictionary_id='63426.Bu çalışanın başka bir şubede veya tipte yapılmış puantaj kaydı bulunmuştur.'>";
					saveMes = "<cf_get_lang dictionary_id = '44097.devam et'>";
					cancelMes = "<cf_get_lang dictionary_id='51196.Yoksay'>";
					Swal.fire({
						title: message_confirm,
						text: "",
						type: 'warning',
						showCancelButton: true,
						confirmButtonColor: '#3085d6',
						cancelButtonColor: '#d33',
						confirmButtonText: saveMes,
						cancelButtonText: cancelMes
						}).then((result) => {
						if (result.value) {
							$.ajax({
								url: 'V16/hr/ehesap/cfc/payroll_job.cfc?method=delete_next_payroll&list_id='+objResponse,
								dataType: "json",
								method: "post",
								async:false,
								success: function(e)
								{
									if(flag_counter <= record_count)
										sendRequest( fileid,create_adres_,is_row);
									else
										flag_counter = 1;
								}
							});

						}else
						{
							if(flag_counter <= record_count)
								sendRequest( fileid,create_adres_,is_row);
							else
								flag_counter = 1;
						}
					});		
				}else
				{
					if(flag_counter <= record_count)
						sendRequest( fileid,create_adres_,is_row);
					else
						flag_counter = 1;
				}
			},error: function( objResponse ){
				if(flag_counter <= record_count)
					sendRequest( fileid,create_adres_,is_row);
				else
					flag_counter = 1;
			}
		});
	}
	function sendRequest( fileid,create_adres_,is_row ) {
        //Payroll
        $("input#fileids_"+ fileid +"").parent('td').find('i').removeClass('fa-bookmark fa-bookmark-o flagTrue').addClass('fa-cog fa-spin font-yellow-casablanca');
		var flag = $("input#fileids_"+fileid+"").parent('td').find('i');

		//Account
		$("input#account_"+ fileid +"").parent('td').find('i').removeClass('fa-bookmark fa-bookmark-o flagTrue').addClass('fa-cog fa-spin font-yellow-casablanca');
		var flag_account = $("input#account_"+fileid+"").parent('td').find('i');

		//Budget
		$("input#budget_"+ fileid +"").parent('td').find('i').removeClass('fa-bookmark fa-bookmark-o flagTrue').addClass('fa-cog fa-spin font-yellow-casablanca');
		var flag_budget = $("input#budget_"+fileid+"").parent('td').find('i');

		var fileid_ = fileid;
        $.ajax({
            url: create_adres_,
            dataType: "json",
			method: "post",
            success: function( objResponse )
			{
				if(objResponse.STATUS == 1)//Puantaj oluşturmada hata yoksa
				{
					$(flag).removeClass('fa-cog fa-spin font-yellow-casablanca fa-bookmark flagFalse').addClass('fa-bookmark flagTrue').attr({ 'onclick' : 'showParserMessage('+fileid_+','+objResponse.IN_OUT_ID+','+sal_mon_+','+sal_year_+','+objResponse.EMPLOYEE_PAYROLL_ID+')' }).css({ 'cursor' : 'pointer' });
					
					//Print Şablonu
					$("#print_"+fileid_+"").prop("onclick", null).off("click");
					$( "#print_"+fileid_+"" ).on( "click", function() {
						open_template(objResponse.FILEID,objResponse.IN_OUT_ID,objResponse.EMPLOYEE_PAYROLL_ID,sal_mon_,sal_year_);
					});
					$( "#print_"+fileid_+"" ).css({ 'cursor' : 'pointer', 'display' : ''});

					//Puantajı yeniden çalıştır
					$("#refresh_"+fileid_+"").prop("onclick", null).off("click");
					$( "#refresh_"+fileid_+"" ).on( "click", function() {
						create_puantaj(fileid_);
						//console.log("objResponse.FILEID : "+objResponse.FILEID);
					});
					$( "#refresh_"+fileid_+"" ).css({ 'cursor' : 'pointer', 'display' : ''});
					//Muhasebe Kontrolü
					var data = new FormData();
					data.append('in_out_id',objResponse.FILEID);
					data.append('sal_mon',$("#sal_mon").val());
					data.append('sal_year',$("#sal_year").val());
					data.append('ssk_office',$("#ssk_office").val());
					//Çalışan Muhasebe Bilgisi Kontrolü(Bütçe içinde önce muhasebe kodları kontrolü yapılıyor.)
					$.ajax({
						url: '<cfoutput>V16/hr/ehesap/cfc/payroll_job.cfc?method=account_control</cfoutput>',
						dataType: "json",
						method: "post",
						data: data,
						processData: false,
						contentType: false,
						async:false,
						success: function( response )
						{
							if(response == 1)//Çalışan muhasebe bilgileri tam ise
							{
								//Puantaj muhasebeleşmesi(taslak)
								var account_data = new FormData();
								account_data.append('payroll_id_list',objResponse.EMPLOYEE_PAYROLL_ID);
								account_data.append('sal_mon',$("#sal_mon").val());
								account_data.append('sal_year',$("#sal_year").val());
								account_data.append('ssk_office',$("#ssk_office").val());
								account_data.append('puantaj_type',$("#puantaj_type").val());
								account_data.append('ssk_statue',$("#ssk_statue").val());
								account_data.append('statue_type',$("#statue_type").val());
								account_data.append('statue_type_individual',$("#statue_type_individual").val());
								account_data.append('IN_OUT_ID',objResponse.FILEID);
								account_data.append('is_submitted',1);
								//console.log("account aa");
								$.ajax({
									url: '<cfoutput>V16/hr/ehesap/cfc/payroll_job.cfc?method=create_payroll_account&from_payroll_rows=1</cfoutput>',
									dataType: "json",
									method: "post",
									data: account_data,
									processData: false,
									contentType: false,
									async:false,
									success: function( response_account )
									{
										//console.log("account success");
										//console.log(response_account);
										if(response_account == 1)//Taslak muhasebe oluşturulduysa
										{
											$(flag_account).removeClass('fa-cog fa-spin font-yellow-casablanca  fa-bookmark flagFalse').addClass('fa-bookmark flagTrue').attr({ 'onclick' : 'showParserMessageAccount('+objResponse.FILEID+','+objResponse.IN_OUT_ID+','+sal_mon_+','+sal_year_+','+objResponse.EMPLOYEE_PAYROLL_ID+')' }).css({ 'cursor' : 'pointer' });
										}else
										{
											if(response_account.ERRORMESSAGE&&response_account.ERRORMESSAGE.Detail&&response_account.ERRORMESSAGE.Detail != '')
											{
												return_error_acc = " Detail : " + response_account.ERRORMESSAGE.Detail;
												if(response_account.ERRORMESSAGE.KnownLine)
													return_error_acc = return_error_acc + " KnownLine : " + response_account.ERRORMESSAGE.KnownLine;
												if(response_account.ERRORMESSAGE.KnownText)
												return_error_acc = return_error_acc + " KnownText : " + response_account.ERRORMESSAGE.KnownText;
											}
											else if(response_account.ERRORMESSAGE&& response_account.ERRORMESSAGE.LocalizedMessage)
												return_error_acc = response_account.ERRORMESSAGE.LocalizedMessage;
											else if(response_account.ERRORMESSAGE)
												return_error_acc = response_account.ERRORMESSAGE;
											else
												return_error_acc = unescape(response_account);
											//console.log("account success");
											//console.log(response_account);
											$(flag_account).removeClass('fa-cog fa-spin font-yellow-casablanca fa-bookmark flagTrue').addClass('fa-bookmark flagFalse').attr({ 'onclick' : 'showMistakeMessageAccount('+objResponse.FILEID+')' }).css({ 'cursor' : 'pointer' });
											$("#msgid_account"+fileid_+"").empty();
											$("input#fileids_"+fileid_+"").parents('tr').after(
												$('<tr>').attr({ 'id' : 'msgid_account' + fileid_ + '' }).append(
													$('<td>').attr({ 'colspan' : 17 }).append(
														$('<table>').addClass('WorkDevList' + fileid_ + '' ).css({ 'width' : '100%' }).append(
															$('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('<cf_get_lang dictionary_id='57541.Hata'> 1'), $('<td>').html(return_error_acc))
														)
													)
												).hide()
											);
										}
									},
									error: function(e) {
										//console.log("account error");
										//console.log(e);
										if(e.ERRORMESSAGE != undefined && e.ERRORMESSAGE.MESSAGE != undefined)
										{
											return_error_acc = e.ERRORMESSAGE.MESSAGE;
										}
										else
											return_error_acc = e.responseText;
										$(flag_account).removeClass('fa-cog fa-spin font-yellow-casablanca fa-bookmark flagTrue').addClass('fa-bookmark flagFalse').attr({ 'onclick' : 'showMistakeMessageAccount('+objResponse.FILEID+')' }).css({ 'cursor' : 'pointer' });
										$("#msgid_account"+fileid_+"").empty();
										$("input#fileids_"+fileid_+"").parents('tr').after(
											$('<tr>').attr({ 'id' : 'msgid_account' + fileid_ + '' }).append(
												$('<td>').attr({ 'colspan' : 17 }).append(
													$('<table>').addClass('WorkDevList' + fileid_ + '' ).css({ 'width' : '100%' }).append(
														$('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('<cf_get_lang dictionary_id='57541.Hata'> 2'), $('<td>').html(return_error_acc))
													)
												)
											).hide()
										);
									}
								});
								//Çalışan Bütçe Bilgisi Kontrolü
								$.ajax({
									url: '<cfoutput>V16/hr/ehesap/cfc/payroll_job.cfc?method=create_payroll_budget&from_payroll_rows=1</cfoutput>',
									dataType: "json",
									method: "post",
									data: account_data,
									processData: false,
									contentType: false,
									async:false,
									success: function( response_budget )
									{
										//console.log(response_budget);
										if(response_budget == 1)//Taslak Bütçe oluşturulduysa
											$(flag_budget).removeClass('fa-cog fa-spin font-yellow-casablanca fa-bookmark flagFalse').addClass('fa-bookmark flagTrue').attr({ 'onclick' : 'showParserMessageBudget('+objResponse.FILEID+','+objResponse.IN_OUT_ID+','+sal_mon_+','+sal_year_+','+objResponse.EMPLOYEE_PAYROLL_ID+')' }).css({ 'cursor' : 'pointer' });
										else
										{
											$(flag_budget).removeClass('fa-cog fa-spin font-yellow-casablanca fa-bookmark flagTrue').addClass('fa-bookmark flagFalse').attr({ 'onclick' : 'showMistakeMessageBudget('+objResponse.FILEID+')' }).css({ 'cursor' : 'pointer' });
											response_budget_ = response_budget;
											if(response_budget_.ERRORMESSAGE.MESSAGE)
											{
												error_budget = "Messages : " + response_budget_.ERRORMESSAGE.MESSAGE;
												error_budget = error_budget + " Line : " + response_budget_.ERRORMESSAGE.LINE;
												error_budget = error_budget + " Raw Trace : " + response_budget_.ERRORMESSAGE.RAW_TRACE;
											}
											else if(response_budget_.ERRORMESSAGE.LocalizedMessage)
												error_budget = response_budget_.ERRORMESSAGE.LocalizedMessage;
											else
												error_budget = response_budget_.ERRORMESSAGE;
											$("#msgid_budget"+fileid_+"").empty();
											$("input#fileids_"+fileid_+"").parents('tr').after(
												$('<tr>').attr({ 'id' : 'msgid_budget' + fileid_ + '' }).append(
													$('<td>').attr({ 'colspan' : 17 }).append(
														$('<table>').addClass('WorkDevList' + fileid_ + '' ).css({ 'width' : '100%' }).append(
															$('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('<cf_get_lang dictionary_id='57541.Hata'> 3'), $('<td>').html(error_budget))
														)
													)
												).hide()
											);
										}
									}
								});
							}
							else//Çalışan muhasebe bilgileri tam değilse eksik veriyi gösterir
							{
								$(flag_account).removeClass('fa-cog fa-spin font-yellow-casablanca fa-bookmark flagTrue').addClass('fa-bookmark flagFalse').attr({ 'onclick' : 'showMistakeMessageAccount('+objResponse.FILEID+')' }).css({ 'cursor' : 'pointer' });
								$(flag_budget).removeClass('fa-cog fa-spin font-yellow-casablanca fa-bookmark flagTrue').addClass('fa-bookmark flagFalse').attr({ 'onclick' : 'showMistakeMessageBudget('+objResponse.FILEID+')' }).css({ 'cursor' : 'pointer' });
								if(response.ERRORMESSAGE)
									error_message_acc = response.ERRORMESSAGE;
								else
									error_message_acc = response;
								$("#msgid_account"+fileid_+"").empty();
								$("input#fileids_"+objResponse.FILEID+"").parents('tr').after(
									$('<tr>').attr({ 'id' : 'msgid_account' + objResponse.FILEID + '' }).append(
										$('<td>').attr({ 'colspan' : 17 }).append(
											$('<table>').addClass('WorkDevList' + objResponse.FILEID + '' ).css({ 'width' : '100%' }).append(
												$('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('<cf_get_lang dictionary_id='57541.Hata'> 4'), $('<td>').html(error_message_acc))
											)
										)
									).hide()
								);
							}
						}
					});
				}
				else//Puantaj oluştururken hata mesajı döndüyse
				{
					$(flag).removeClass('fa-cog fa-spin font-yellow-casablanca fa-bookmark flagTrue').addClass('fa-bookmark flagFalse').attr({ 'onclick' : 'showMistakeMessage('+fileid_+')' }).css({ 'cursor' : 'pointer' });
					$(flag_account).removeClass('fa-cog fa-spin font-yellow-casablanca fa-bookmark flagTrue').addClass('fa-bookmark flagFalse').attr({ 'onclick' : 'showMistakeMessageAccount('+fileid_+')' }).css({ 'cursor' : 'pointer' });
					$(flag_budget).removeClass('fa-cog fa-spin font-yellow-casablanca fa-bookmark flagTrue').addClass('fa-bookmark flagFalse').attr({ 'onclick' : 'showMistakeMessageBudget('+fileid_+')' }).css({ 'cursor' : 'pointer' });
					
					//Hata Çıktısı
					if(objResponse.ERRORMESSAGE.LocalizedMessage)
                        error_message = objResponse.ERRORMESSAGE.LocalizedMessage;
                    else
                        error_message = objResponse.ERRORMESSAGE;
					//console.log(error_message);
					$("#msgid_"+fileid_+"").empty();
					$("input#fileids_"+fileid_+"").parents('tr').after(
						$('<tr>').attr({ 'id' : 'msgid_' + fileid_ + '' }).append(
							$('<td>').attr({ 'colspan' : 17 }).append(
								$('<table>').addClass('WorkDevList' + fileid_ + '' ).css({ 'width' : '100%' }).append(
									$('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('<cf_get_lang dictionary_id='57541.Hata'> 5'), $('<td>').html(error_message))
								)
							)
						).hide()
					);
				}
				flag_counter++;
				var fileid = $('input[data-id = fileids_'+flag_counter+']').val();
				request_adres= main_adress + '&in_out_id=' + fileid;
				if(is_row != 1)
					startRequest(fileid,request_adres,1);
			},
			error: function(error) //Puantaj oluşturulmada hata ile karşılaşıldıysa
			{
				//Hata Çıktısı
				//console.log(error);
				$(flag).removeClass('fa-cog fa-spin font-yellow-casablanca fa-bookmark flagTrue').addClass('fa-bookmark flagFalse').attr({ 'onclick' : 'showMistakeMessage('+fileid_+')' }).css({ 'cursor' : 'pointer' });
				$(flag_account).removeClass('fa-cog fa-spin font-yellow-casablanca fa-bookmark flagTrue').addClass('fa-bookmark flagFalse').attr({ 'onclick' : 'showMistakeMessageAccount('+fileid_+')' }).css({ 'cursor' : 'pointer' });
				$(flag_budget).removeClass('fa-cog fa-spin font-yellow-casablanca fa-bookmark flagTrue').addClass('fa-bookmark flagFalse').attr({ 'onclick' : 'showMistakeMessageBudget('+fileid_+')' }).css({ 'cursor' : 'pointer' });
				
				flag_counter++;
				var fileid = $('input[data-id = fileids_'+flag_counter+']').val();
				request_adres= main_adress + '&in_out_id=' + fileid;
				$("#msgid_"+fileid_+"").empty();
				$("input#fileids_"+fileid_+"").parents('tr').after(
					$('<tr>').attr({ 'id' : 'msgid_' + fileid_ + '' }).append(
						$('<td>').attr({ 'colspan' : 17 }).append(
							$('<table>').addClass('WorkDevList').css({ 'width' : '100%' }).append(
								$('<tr>').append($('<td>').css({ 'color' : '#f00' }).text('<cf_get_lang dictionary_id='57541.Hata'> 6'), $('<td>').html(error.responseText ))
							)
						)
					).hide()
				);

				startRequest(fileid,request_adres,1);
			}
        });
    }
	function open_detail_select(){
		if(document.getElementById("puantaj_type").value == -1)
			document.getElementById("detail_select_div").style.display = "";
		else
			document.getElementById("detail_select_div").style.display = "none";
	}
	//Hata mesajı Bordro
	function showMistakeMessage(fileid){
		if( $('tr#msgid_'+fileid+'').hasClass("activeTr") ) 
            $('tr#msgid_'+fileid+'').hide().removeClass("activeTr");
        else $('tr#msgid_'+fileid+'').show().addClass("activeTr");
	}	
	//Taslak bordro
	function showParserMessage(fileid, in_out_id, sal_mon, sal_year,employee_payroll_id){
		cfmodal('<cfoutput>#request.self#?fuseaction=ehesap.show_payroll_draft</cfoutput>&in_out_id='+fileid+'&in_out_id='+in_out_id+'&sal_mon='+sal_mon+'&sal_year='+sal_year+'&employee_payroll_id='+employee_payroll_id,'warning_modal');
	}
	//Taslak Muhasebe
	function showParserMessageAccount(fileid, in_out_id, sal_mon, sal_year,employee_payroll_id){
		cfmodal('<cfoutput>#request.self#?fuseaction=ehesap.show_account_draft</cfoutput>&in_out_id='+fileid+'&in_out_id='+in_out_id+'&sal_mon='+sal_mon+'&sal_year='+sal_year+'&employee_payroll_id='+employee_payroll_id,'warning_modal');
	}
	//Muhasebe Hata Mesajı
	function showMistakeMessageAccount(fileid){
		if( $('tr#msgid_account'+fileid+'').hasClass("activeTr") ) 
            $('tr#msgid_account'+fileid+'').hide().removeClass("activeTr");
        else $('tr#msgid_account'+fileid+'').show().addClass("activeTr");
	}
	//Hata mesajı Bütçe
	function showMistakeMessageBudget(fileid){
		if( $('tr#msgid_budget'+fileid+'').hasClass("activeTr") ) 
            $('tr#msgid_budget'+fileid+'').hide().removeClass("activeTr");
        else $('tr#msgid_budget'+fileid+'').show().addClass("activeTr");
	}	
	//Taslak Bütçe
	function showParserMessageBudget(fileid, in_out_id, sal_mon, sal_year,employee_payroll_id){
		cfmodal('<cfoutput>#request.self#?fuseaction=ehesap.show_budget_draft</cfoutput>&in_out_id='+fileid+'&in_out_id='+in_out_id+'&sal_mon='+sal_mon+'&sal_year='+sal_year+'&employee_payroll_id='+employee_payroll_id,'warning_modal');
	}
	function open_template(employee_id,in_out_id,employee_puantaj_id,sal_mon,sal_year)
	{
		//Print şablonu popup
		windowopen('index.cfm?fuseaction=ehesap.popup_view_price_compass&style=one&employee_puantaj_id='+employee_puantaj_id+'&in_out_id='+employee_id+'&sal_mon='+sal_mon+'&sal_year='+sal_year+'&puantaj_type=-1','page');
	}
</script>