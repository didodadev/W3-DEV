<cfinclude template="../query/get_punishment_upd.cfm">
<cfinclude template="../query/get_money.cfm">
<cfinclude template="../query/get_punishment_type.cfm">
<cfquery name="get_department" datasource="#dsn#">
	SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = #get_punishment_upd.department_id#
</cfquery>
<cfparam name="attributes.modal_id" default="">

<!--- <cfsavecontent variable="right_">
	<a href="javascript://" onclick="ceza_kayit();"><img src="/images/plus1.gif" align="absmiddle" alt="<cf_get_lang_main no='170.Ekle'>" title="<cf_get_lang_main no='170.Ekle'>" border="0"></a>
</cfsavecontent> --->
<cfform name="upd_punishment" action="#request.self#?fuseaction=assetcare.emptypopup_upd_punishment" method="post" onsubmit="return(unformat_fields());">
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('assetcare',465)#" add_href="#request.self#?fuseaction=assetcare.form_add_punishment" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<input type="hidden" name="punishment_id" id="punishment_id" value="<cfoutput>#attributes.punishment_id#</cfoutput>">
		<input type="hidden" name="is_detail" id="is_detail" value="1">
		<cf_box_elements>
			<div class="col col-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-fuel_num">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='75.No'></label>
                    <div class="col col-8 col-xs-12">
						<cfinput type="text" name="punishment_num" value="#get_punishment_upd.punishment_id#" readonly >
                    </div>
                </div>
				<div class="form-group" id="item-accident_id">
                    <label class="col col-4 col-xs-12"><cf_get_lang no='446.Kaza İlişkisi'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="accident_id" id="accident_id" value="<cfoutput>#get_punishment_upd.accident_id#</cfoutput>">
							<cfif len(get_punishment_upd.accident_id)>
								<cfquery name="get_accident" datasource="#dsn#">
									SELECT
										ASSET_P_ACCIDENT.ACCIDENT_DATE,
										ASSET_P.ASSETP
									FROM
										ASSET_P_ACCIDENT,
										ASSET_P
									WHERE
										ACCIDENT_ID = #get_punishment_upd.accident_id# AND
										ASSET_P.ASSETP_ID = ASSET_P_ACCIDENT.ASSETP_ID
								</cfquery>
								<cfset x = get_accident.assetp &  " - " & dateformat(get_accident.accident_date,dateformat_style) & " tarihli kaza">
							<cfelse>
							<cfset x = "">
							</cfif>
							<cfinput type="text" name="accident_name"  value="#x#" readonly >
										<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_accident&field_accident_id=upd_punishment.accident_id&field_accident_name=upd_punishment.accident_name&field_assetp_id=upd_punishment.assetp_id&field_assetp_name=upd_punishment.assetp_name&field_employee_id=upd_punishment.employee_id&field_employee_name=upd_punishment.employee_name&field_dep_id=upd_punishment.department_id&field_dep_name=upd_punishment.department','list');">
										</span>
                        </div>
                    </div>
                </div>

				<div class="form-group" id="item-assetp_name">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='1656.Plaka'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#get_punishment_upd.assetp_id#</cfoutput>">
							<cfsavecontent variable="message3"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1656.Plaka'>!</cfsavecontent>
							<cfinput type="text" name="assetp_name" value="#get_punishment_upd.assetp#" readonly required="yes" message="message3"  >
				
							<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=upd_punishment.assetp_id&field_name=upd_punishment.assetp_name','list');">
                            </span>
                        </div>
                    </div>
                </div>

				<div class="form-group" id="item-assetp_name">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='132.Sorumlu'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_punishment_upd.employee_id#</cfoutput>">
							<cfsavecontent variable="messagemp"></cfsavecontent>
							<cfinput type="text" name="employee_name"  readonly required="yes" value="#get_emp_info(get_punishment_upd.employee_id,0,0)#" message="#messagemp#"  >
				
								<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_punishment.employee_id&field_name=upd_punishment.employee_name&select_list=1','list');"> 
                            </span>
                        </div>
                    </div>
                </div>
				<div class="form-group" id="item-assetp_name">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='41.Şube'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfif len(get_punishment_upd.department_id)>
								<cfset x = get_department.department_head>
							<cfelse>
								<cfset x = "">
							</cfif>
							<input type="hidden" name="department_id" id="department_id" value="<cfoutput>#get_punishment_upd.department_id#</cfoutput>">
							<cfsavecontent variable="messagedep"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='160.Departman'>!</cfsavecontent>
							<cfinput type="text" name="department" required="yes" message="#messagedep#" value="#x#" readonly  >
							<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=upd_punishment.department_id&field_name=upd_punishment.department','list');"> 
                            </span>
                        </div>
                    </div>
                </div>

				<div class="form-group" id="item-receipt_num">
                    <label class="col col-4 col-xs-12"><cf_get_lang no='415.Makbuz No'></label>
                    <div class="col col-8 col-xs-12">
						<cfsavecontent variable="messagepun"><cf_get_lang no='625.Makbuz No Giriniz'>!</cfsavecontent>
						<cfinput type="text" name="receipt_num" value="#get_punishment_upd.receipt_num#" required="yes" message="#messagepun#"  >
                    </div>
                </div>

				<div class="form-group" id="item-punishment_type_id">
                    <label class="col col-4 col-xs-12"><cf_get_lang no='414.Ceza Tipi'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="punishment_type_id" id="punishment_type_id"  >
							<option value=""></option>
							<cfoutput query="get_punishment_type">
								<option value="#punishment_type_id#"<cfif get_punishment_upd.punishment_type_id eq get_punishment_type.punishment_type_id>selected</cfif>>#punishment_type_name#</option>
							</cfoutput>
						</select>
                    </div>
                </div>

				<div class="form-group" id="item-punishment_date">
                    <label class="col col-4 col-xs-12"><cf_get_lang no='416.Ceza Tarihi'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
							<cfsavecontent variable="message1"><cf_get_lang no='629.Ceza Tarihini Kontrol Ediniz'>!</cfsavecontent>
							<cfinput type="text" name="punishment_date" value="#dateformat(get_punishment_upd.punishment_date,dateformat_style)#" maxlength="10" required="yes" validate="#validate_style#" message="#message1#"  >
                            <span class="input-group-addon"><cf_wrk_date_image date_field="punishment_date"></span>
                        </div>
                    </div>
                </div>

				<div class="form-group" id="item-assetp_name">
                    <label class="col col-4 col-xs-12"><cf_get_lang no='185.Son Ödeme Tarihi'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfinput type="text" name="last_payment_date" value="#dateformat(get_punishment_upd.last_payment_date,dateformat_style)#" validate="#validate_style#" maxlength="10"  >
                            <span class="input-group-addon"><cf_wrk_date_image date_field="last_payment_date"></span>
                        </div>
                    </div>
                </div>
            </div>
			<div class="col col-6 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group" id="item-assetp_name">
                    <label class="col col-4 col-xs-12"><cf_get_lang no='417.Ceza Tutarı'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
							<cfinput type="text" name="punishment_amount" value="#tlformat(get_punishment_upd.punishment_amount)#" class="moneybox" onKeyup="return(FormatCurrency(this,event));" >
                            <span class="input-group-addon width">
								<select name="punishment_amount_currency" id="punishment_amount_currency">
									<cfoutput query="get_money">
										<option value="#money#" <cfif money eq get_punishment_upd.punishment_amount_currency>selected</cfif>>#money#</option>
									</cfoutput>
								</select>
                            </span>
                        </div>
                    </div>
                </div>

				
                <div class="form-group" id="item-paid_date">
                    <label class="col col-4 col-xs-12"><cf_get_lang no='447.Ödeme Tarihi'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
							<input type="text" name="paid_date" id="paid_date" value="<cfoutput>#dateformat(get_punishment_upd.paid_date,dateformat_style)#</cfoutput>" maxlength="10"  >
                            <span class="input-group-addon"><cf_wrk_date_image date_field="paid_date"></span>
                        </div>
                    </div>
                </div>

				<div class="form-group" id="item-paid_amount">
                    <label class="col col-4 col-xs-12"><cf_get_lang no='418.Ödenen Tutar'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
							<input type="text" name="paid_amount" id="paid_amount"  value="<cfoutput>#tlformat(get_punishment_upd.paid_amount)#</cfoutput>" class="moneybox" onKeyup="return(FormatCurrency(this,event));">
                            <span class="input-group-addon width">
								<select name="paid_amount_currency" id="paid_amount_currency" >
									<cfoutput query="get_money">
										<option value="#money#" <cfif money eq get_punishment_upd.paid_amount_currency>selected</cfif>>#money#</option>
									</cfoutput>
								</select>
						</span>
                        </div>
                    </div>
                </div>
				<div class="form-group" id="item-payer">
                    <label class="col col-4 col-xs-12"><cf_get_lang no='424.Ödeme Yapan'></label>
                    <div class="col col-4 col-xs-12">
                        <input type="radio" name="payer" id="payer" value="1" <cfif get_punishment_upd.payer_id eq 1>checked</cfif>>
						<cf_get_lang_main no='162.Firma'>
                    </div>
                    <div class="col col-4 col-xs-12">
                        <input type="radio" name="payer" id="payer" value="2" <cfif get_punishment_upd.payer_id eq 2>checked</cfif>>
						<cf_get_lang_main no='2034.Kişi'>
                    </div>
                </div>

				<div class="form-group" id="item-punished_license">
                    <label class="col col-4 col-xs-12"><cf_get_lang no='425.Ceza Kayıtlı Belge'></label>
                    <div class="col col-4 col-xs-12">
                        <input type="radio" name="punished_license" id="punished_license" value="1" <cfif get_punishment_upd.punished_license eq 1>checked</cfif>>
						<cf_get_lang no='432.Ruhsat'>
					</div>
                    <div class="col col-4 col-xs-12">
							<input type="radio" name="punished_license" id="punished_license" value="2" <cfif get_punishment_upd.punished_license eq 2>checked</cfif>>
							<cf_get_lang no='428.Ehliyet'>
					</div>
                </div>

				<div class="form-group" id="item-detail">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no="217.Açıklama"></label>
                    <div class="col col-8 col-xs-12">
						<textarea name="detail" id="detail" style="width:130px;height:80px" ><cfoutput>#get_punishment_upd.detail#</cfoutput></textarea>
                    </div>
                </div>
            </div>
		</cf_box_elements>
	</cf_box>
</div>
				<div class="col col-12" type="column" index="1" sort="true">
					
						<cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="-23" module_id='40' action_section='PUNISHMENT_ID' action_id='#attributes.punishment_id#'>
				
				</div>
				<div class="col col-12" type="column" index="1" sort="true">
		<cf_box_footer>
			<cf_record_info query_name="get_punishment_upd">
			<cf_workcube_buttons type_format="1" is_upd='1' is_cancel='0' is_reset='0' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=assetcare.emptypopup_del_punishment&punishment_id=#attributes.punishment_id#&plaka=#get_punishment_upd.assetp#&is_detail=1'
			search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('upd_punishment' , #attributes.modal_id#)"),DE(""))#">
		</cf_box_footer>
	</div>
	</cfform>

<script type="text/javascript">
function unformat_fields()
{
	document.upd_punishment.punishment_amount.value = filterNum(document.upd_punishment.punishment_amount.value);
	document.upd_punishment.paid_amount.value = filterNum(document.upd_punishment.paid_amount.value);
}
function kontrol()
{		unformat_fields();
	x = document.upd_punishment.punishment_type_id.selectedIndex;
	if (document.upd_punishment.punishment_type_id[x].value == "")
	{ 
		alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='414.Ceza Tipi'>!");
		return false;
	}
	
	if(document.upd_punishment.last_payment_date.value != "" && !date_check(document.upd_punishment.punishment_date,document.upd_punishment.last_payment_date,"<cf_get_lang_main no='394.Tarih Aralığını Kontrol Ediniz'>!"))
		return false;

	/*if(document.upd_punishment.accident_name.value != "")
	{
		if(!date_check(document.upd_punishment.accident_date,document.upd_punishment.punishment_date,"Ceza Tarihini Kontrol Ediniz!"))
		{
			return false;
		}
	}*/
	
	if((document.upd_punishment.punishment_date.value.length) && (document.upd_punishment.paid_date.value.length))
	{
		if(!date_check_hiddens(document.upd_punishment.punishment_date,document.upd_punishment.paid_date,"<cf_get_lang no='630.Ödeme Tarihi Ceza Tarihinden Küçük Olamaz'>!"))
			return false;
	}
	return true;
}
function ceza_kayit()
	{
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.parent.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.form_add_punishment';
			<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>

	}
</script>
