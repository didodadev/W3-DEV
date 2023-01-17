<cfsetting showdebugoutput="no">
<cf_xml_page_edit fuseact="stock.detail_multi_packetship">
<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
<!--- 
	Not : SHIP_RESULT tablosundaki IS_TYPE alani siparis detayindaki Sevkiyat popup'dan atılan kayıtlarda (sadece bu kayitlarda) 2 set edilir.
		O yuzden ekleme ve silme işlemi su an yapilamamakta BK 20070405
	Not 2: Bu sayfada dogtas icin xml e bagli degisiklikler yapildi, bana danisilabilir FBS 20091101
 --->
<cfquery name="GET_SHIP_RESULTS_ALL" datasource="#DSN2#">
	SELECT
		SR.*,
		SM.SHIP_METHOD
	FROM
		SHIP_RESULT SR,
		#dsn_alias#.SHIP_METHOD SM
	WHERE
		SR.MAIN_SHIP_FIS_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.main_ship_fis_no#"> AND
		SR.SHIP_METHOD_TYPE = SM.SHIP_METHOD_ID
	ORDER BY
		SR.SHIP_RESULT_ID
</cfquery>
<cfquery name="GET_SHIP_RESULT" dbtype="query" maxrows="1">
	SELECT * FROM GET_SHIP_RESULTS_ALL ORDER BY SHIP_RESULT_ID DESC
</cfquery>
<cfquery name="get_ship_control" datasource="#dsn2#"><!--- Irsaliyelenmis kayit var mi --->
	SELECT SHIP_ID FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ID IN (#valuelist(get_ship_results_all.ship_result_id)#) AND SHIP_ID IS NOT NULL AND INVOICE_ID IS NOT NULL
</cfquery>
<cfif x_equipment_planning_info eq 0><!--- Planlama Bazinda Gelen Verilerde Bunlara Gerek Yok --->
	<cfinclude template="../query/get_moneys.cfm">
	<cfinclude template="../query/get_package_type.cfm">
	<cfquery name="GET_MONEY" datasource="#DSN#">
		SELECT MONEY, RATE2, RATE1 FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 ORDER BY MONEY_ID
	</cfquery>
	
	<cfquery name="SUM_SHIP_RESULT" dbtype="query">
		SELECT
			SUM(COST_VALUE) COST_VALUE,
			SUM(COST_VALUE2) COST_VALUE2
		FROM
			GET_SHIP_RESULTS_ALL
	</cfquery>
	<cfif listlen(valuelist(get_ship_results_all.company_id))>
		<cfquery name="GET_COMPANY" datasource="#DSN#">
			SELECT FULLNAME,COMPANY_ID FROM COMPANY WHERE COMPANY_ID IN(#listsort(valuelist(get_ship_results_all.company_id),"numeric")#) 
		</cfquery>
	</cfif>
	<cfif listlen(valuelist(get_ship_results_all.consumer_id))>
		<cfquery name="GET_CONSUMER" datasource="#DSN#">
			SELECT CONSUMER_NAME,CONSUMER_SURNAME,CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID IN(#listsort(valuelist(get_ship_results_all.consumer_id),"numeric")#) 
		</cfquery>
	</cfif>

	<cfif not get_ship_result.recordcount or not len(get_ship_result.service_company_id)>
		<br/><font class="txtbold"><cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'>!</font>
		<cfexit method="exittemplate">
	</cfif>
	<cfquery name="GET_SHIP_METHOD_PRICE" datasource="#DSN#">
		SELECT * FROM SHIP_METHOD_PRICE WHERE COMPANY_ID = #get_ship_result.service_company_id#
	</cfquery>
	<!--- Eger ilgili hesap yontemine ait kayit yoksa --->
	<cfif not get_ship_method_price.recordcount>
		<script type="text/javascript">
			alert('<cfoutput>#get_par_info(get_ship_result.service_company_id,1,0,0)#</cfoutput>'+'  <cf_get_lang dictionary_id='45655.Şirketine Ait Bir Taşıyıcı Kaydı Yok. Lütfen Kayıtlarınızı Kontrol Ediniz'>' );
			window.location.href="<cfoutput>#request.self#?</cfoutput>fuseaction=stock.list_multi_packetship"
		</script>
	</cfif>

	<!--- Tasiyici Bilgisi Degistirilirse,yeni tasiyici icin sevk fiyatı verilip verilmedigini kontrol etmek icin  --->
	<cfquery name="GET_SHIP_METHOD_PRICE_" datasource="#DSN#">
		SELECT * FROM SHIP_METHOD_PRICE
	</cfquery>
	<!--- Tasiyici Firma Sadece 1 kez secilsin. --->
	<cfset transport_selected = valueList(get_ship_method_price_.company_id,',')>
	<cfif len(get_ship_result.ship_method_type)>
		<cfquery name="GET_ROWS" datasource="#DSN2#">
			SELECT PACKAGE_PIECE, PACKAGE_DIMENTION, PACKAGE_WEIGHT FROM SHIP_RESULT_PACKAGE WHERE SHIP_ID IN (#valuelist(get_ship_results_all.ship_result_id)#)
		</cfquery>
		<cfset toplam_kg = 0>
		<cfset toplam_desi = 0>
	</cfif>
<cfelse>
	<cfif get_ship_result.is_order_terms neq 1>
		<script type="text/javascript">
			alert('<cf_get_lang dictionary_id='63708.Planlama Bazında Kaydetmediğiniz İçin Bu Sevkiyat Detayını Görüntüleyemezsiniz'>!');
			window.location.href="<cfoutput>#request.self#?</cfoutput>fuseaction=stock.list_multi_packetship"
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfquery name="GET_ROW" datasource="#DSN2#">
	SELECT 
		SRW.*,
		ISNULL(SRW.ORDER_ROW_AMOUNT,0) ORDER_ROW_AMOUNT_,
		ISNULL(SRW.SHIP_RESULT_ROW_AMOUNT,0) SHIP_ROW_AMOUNT_,
		SR.SHIP_RESULT_ID,
		SR.COMPANY_ID,
		SR.PARTNER_ID,
		SR.CONSUMER_ID,
		SR.COST_VALUE,
		SR.COST_VALUE2,
		SR.SHIP_FIS_NO
	FROM
		SHIP_RESULT_ROW SRW,
		SHIP_RESULT SR
	WHERE 
		SRW.SHIP_RESULT_ID IN (#valuelist(get_ship_results_all.ship_result_id)#) AND
		SRW.SHIP_RESULT_ID = SR.SHIP_RESULT_ID
	ORDER BY
		SRW.ORDER_ID,
		SR.SHIP_RESULT_ID
</cfquery>
<cfif x_equipment_planning_info eq 1 and not Get_Row.RecordCount>
	<br />&nbsp;&nbsp;&nbsp;
	<cfoutput>#attributes.main_ship_fis_no#</cfoutput> Nolu Sevkiyat Satırları İle İlgili Bir Sorun Bulunmaktadır. Lütfen Sistem Yöneticinize Başvurunuz !
	<cfexit>
</cfif>
<!---<cfsavecontent variable="right_">
	<cfoutput>
	    <cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-24" module_id='13' action_section='SHIP_RESULT_ID' action_id='#get_ship_results_all.ship_result_id#'>
		<a href="#request.self#?fuseaction=stock.form_add_multi_packetship"><img src="images/plus1.gif" align="top" border="0" title="<cf_get_lang no ='487.Toplu Sevkiyat Ekle'>"></a>
		<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&keyword=#attributes.main_ship_fis_no#&print_type=32','list');"><img src="images/print.gif" align="top" border="0" title="<cf_get_lang_main no ='62.Yazdır'>"></a> 
	</cfoutput>
</cfsavecontent>--->
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Toplu Sevkiyatlar','47233')#">
		<cfform name="upd_packet_ship" id="upd_packet_ship" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_multi_packetship" ><!--- emptypopup_upd_multi_packetship --->
			<cf_box_elements>
				<cfoutput>
					<input type="hidden" name="main_ship_fis_no" id="main_ship_fis_no" value="#attributes.main_ship_fis_no#">
					<input type="hidden" name="is_type" id="is_type" value="#get_ship_result.is_type#">
					<input type="hidden" name="ship_fis_no_count" id="ship_fis_no_count" value="<cfif x_equipment_planning_info eq 0>#listgetat(get_ship_result.ship_fis_no,3,'-')#<cfelse>1</cfif>">
					<input type="hidden" name="is_order_terms" id="is_order_terms" value="#get_ship_result.is_order_terms#">
				</cfoutput>
				<cfoutput>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-process_cat">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no="1447.Süreç">*</label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="header_"><cf_get_lang_main no="1447.Süreç"></cfsavecontent>
								<cf_workcube_process is_upd='0' select_value='#get_ship_result.ship_stage#' process_cat_width='170' is_detail='1'>
							</div>
						</div>
						<div class="form-group" id="item-ship_method_name">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='1703.Sevk Yöntemi'>*</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="header_"><cf_get_lang_main no='1703.Sevk Yöntemi'></cfsavecontent>
									<input type="hidden" name="ship_method_id" id="ship_method_id" value="<cfif Len(get_ship_result.ship_method_type)>#get_ship_result.ship_method_type#</cfif>">
									<input type="text" name="ship_method_name" id="ship_method_name" value="<cfif Len(get_ship_result.ship_method_type)>#get_ship_result.ship_method#</cfif>" readonly>
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_ship_methods&field_name=upd_packet_ship.ship_method_name&field_id=upd_packet_ship.ship_method_id');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-transport_comp_name">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='304.Taşıyıcı'><cfif x_equipment_planning_info eq 0> *</cfif></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="header_"><cf_get_lang_main no='304.Taşıyıcı'></cfsavecontent>
									<input type="hidden" name="transport_comp_id_" id="transport_comp_id_" value="#get_ship_result.service_company_id#">
									<input type="hidden" name="transport_comp_id" id="transport_comp_id" value="#get_ship_result.service_company_id#">
									<input type="text" name="transport_comp_name" id="transport_comp_name" value="#get_par_info(get_ship_result.service_company_id,1,0,0)#" readonly>                                            
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=upd_packet_ship.transport_comp_id&field_comp_name=upd_packet_ship.transport_comp_name&field_partner=upd_packet_ship.transport_deliver_id&field_name=upd_packet_ship.transport_deliver_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&call_function=kontrol_prerecord()&select_list=2');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-transport_deliver_name">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45460.Taşıyıcı Yetkilisi'></label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="header_"><cf_get_lang dictionary_id='45460.Taşıyıcı Yetkilisi'></cfsavecontent>
								<input type="hidden" name="transport_deliver_id" id="transport_deliver_id" value="#get_ship_result.service_member_id#">
								<input type="text" name="transport_deliver_name" id="transport_deliver_name" value="#get_par_info(get_ship_result.service_member_id,0,-1,0)#" readonly>
							</div>
						</div>
						<cfif x_equipment_planning_info eq 0>
						<div class="form-group" id="item-assetp_name">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58480.Araç'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58480.Araç'></cfsavecontent>
									<input type="hidden" name="assetp_id" id="assetp_id" value="#get_ship_result.assetp_id#">
									<cfif len(get_ship_result.assetp_id)>
										<cfquery name="GET_ASSETP" datasource="#DSN#">
											SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_result.assetp_id#">
										</cfquery>
									</cfif>
									<input type="text" name="assetp_name" id="assetp_name" value="<cfif len(get_ship_result.assetp_id)>#get_assetp.assetp#</cfif>" onfocus="AutoComplete_Create('assetp_name','ASSETP','ASSETP,FULL_NAME','get_assept','','ASSETP_ID,FULL_NAME,EMPLOYEE_ID','assetp_id,vehicle_emp_name,vehicle_emp_id','','3','170');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_ship_vehicles&field_id=upd_packet_ship.assetp_id&field_name=upd_packet_ship.assetp_name&field_emp_id=upd_packet_ship.vehicle_emp_id&field_emp_name=upd_packet_ship.vehicle_emp_name');"></span>
								</div>
							</div>
						</div>
						</cfif>
						<cfif x_equipment_planning_info eq 0>
						<div class="form-group" id="item-vehicle_emp_name">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45466.Araç Yetkilisi'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="header_"><cf_get_lang dictionary_id='45466.Araç Yetkilisi'></cfsavecontent>
									<input type="hidden" name="vehicle_emp_id" id="vehicle_emp_id" value="#get_ship_result.deliver_emp#">
									<input  name="vehicle_emp_name" id="vehicle_emp_name" type="text" value="#get_emp_info(get_ship_result.deliver_emp,0,0)#" onfocus="AutoComplete_Create('vehicle_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','vehicle_emp_id','','3','170');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_name=upd_packet_ship.vehicle_emp_name&field_emp_id=upd_packet_ship.vehicle_emp_id&select_list=1');"></span>
								</div>
							</div>
						</div>
						<cfelse>
						<div class="form-group" id="item-deliver_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45304.Fiili Sevk Tarihi'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="header_"><cf_get_lang dictionary_id='45304.Fiili Sevk Tarihi'></cfsavecontent>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='45287.Fiili Sevk Tarihi Girmelisiniz'>!</cfsavecontent>
									<cfinput type="text" name="deliver_date" id="deliver_date" value="#dateformat(get_ship_result.delivery_date,dateformat_style)#" validate="#validate_style#" maxlength="10" required="yes" message="#message#" style="width:65px;">
									<span class="input-group-addon"><cf_wrk_date_image date_field="deliver_date"></span>
								</div>
							</div>
						</div>
						</cfif>
						<cfif x_equipment_planning_info eq 0>
						<div class="form-group" id="item-plate">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29453.Plaka'></label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="header_"><cf_get_lang dictionary_id='29453.Plaka'></cfsavecontent>
								<input type="text" name="plate" id="plate" maxlength="50" value="#get_ship_result.plate#">
							</div>
						</div>
						</cfif>
						<cfif x_equipment_planning_info eq 0>
						<div class="form-group" id="item-note">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57629.Açıklama'></cfsavecontent>
								<textarea name="note" id="note" style="width:170px;height:45px;">#get_ship_result.note#</textarea>
							</div>
						</div>
						</cfif>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-transport_no1">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45458.Sevkiyat No'>*</label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="header_"><cf_get_lang dictionary_id='45458.Sevkiyat No'></cfsavecontent>
							<input name="transport_no1" id="transport_no1" type="text" value="#get_ship_result.main_ship_fis_no#" readonly style="width:100px;">
							</div>
						</div>
						<div class="form-group" id="item-reference_no">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58794.Referans No'></label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58794.Referans No'></cfsavecontent>
								<input type="text" name="reference_no" id="reference_no" value="#get_ship_result.reference_no#" maxlength="25" style="width:100px;">
							</div>
						</div>
						<cfif x_equipment_planning_info eq 0>
						<div class="form-group" id="item-transport_paper_no">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57716.Taşıyıcı'><cf_get_lang dictionary_id='57880.Belge No'></label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57716.Taşıyıcı'><cf_get_lang dictionary_id='57880.Belge No'></cfsavecontent>
								<cfinput name="transport_paper_no" id="transport_paper_no" type="text" value="#get_ship_result.deliver_paper_no#" maxlength="25" style="width:100px;">
							</div>
						</div>
						<cfelse>
							<cfquery name="get_planning_info" datasource="#dsn3#">
								SELECT PLANNING_ID,PLANNING_DATE,TEAM_CODE FROM DISPATCH_TEAM_PLANNING WHERE PLANNING_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#get_ship_result.out_date#">
							</cfquery>
							<script type="text/javascript">
								function depot_date_change()
								{
									var get_planning_info_js =  wrk_safe_query('stk_get_planning_info','dsn3',0,js_date(document.getElementById("action_date").value));
									for(j=#get_planning_info.recordcount#;j>=0;j--)
										document.upd_packet_ship.equipment_planning.options[j] = null;
									
									document.upd_packet_ship.equipment_planning.options[0]= new Option('Ekip-Araç','');
									if(get_planning_info_js.recordcount)
										for(var jj=0;jj < get_planning_info_js.recordcount;jj++)
											document.upd_packet_ship.equipment_planning.options[jj+1]=new Option(get_planning_info_js.TEAM_CODE[jj],get_planning_info_js.PLANNING_ID[jj]);
								}
							</script>
							<div class="form-group" id="item-equipment_planning">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58870.Ekip - Araç'>*</label>
								<div class="col col-8 col-xs-12">
									<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58870.Ekip - Araç'>*</cfsavecontent>
									<select name="equipment_planning" id="equipment_planning">
										<option value=""><cf_get_lang dictionary_id='58870.Ekip - Araç'></option>
										<cfloop query="get_planning_info">
											<option value="#planning_id#" <cfif get_planning_info.planning_id eq get_ship_result.equipment_planning_id>selected</cfif>>#team_code#</option>
										</cfloop>
									</select>
								</div>
							</div>
						</cfif>
						<cfif x_equipment_planning_info eq 0>
						<div class="form-group" id="item-deliver_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57645.Teslim Tarihi'></label>
							<div class="col col-8 col-xs-12">
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57645.Teslim Tarihi'></cfsavecontent>
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='45467.Teslim Tarihi Girmelisiniz'></cfsavecontent>
										<cfinput type="text" name="deliver_date" id="deliver_date" value="#dateformat(get_ship_result.delivery_date,dateformat_style)#" validate="#validate_style#" style="width:65px;" message="Lütfen Teslim Tarihi Formatını Doğru Giriniz !">
										<span class="input-group-addon"><cf_wrk_date_image date_field="deliver_date"></span>
									</div>
								</div>
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
									<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
										<cfif len(get_ship_result.delivery_date)>
											<cf_wrkTimeFormat name="deliver_h" id="deliver_h" value="#numberformat("#hour(get_ship_result.delivery_date)#",00)#">	
										</cfif>
									</div>
									<div class="col col-6 col-md-6 col-sm-6 col-xs-6">  
										<select name="deliver_m" id="deliver_m">
											<cfloop from="0" to="59" index="j">
												<option value="#numberformat(j,00)#" <cfif len(get_ship_result.delivery_date) and j eq minute(get_ship_result.delivery_date)>selected</cfif>>#numberformat(j,00)#</option>	
											</cfloop>
										</select>
									</div>
								</div>
							</div>
						</div>
						<cfelse>
						<div class="form-group" id="item-note_2">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-8 col-xs-12">
							<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57629.Açıklama'></cfsavecontent>
							<textarea name="note_2" id="note_2" style="width:170px;height:45px;">#get_ship_result.note#</textarea>
							</div>
						</div>
						</cfif>
						<div class="form-group" id="item-action_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45463.Depo Çıkış Tarihi'></label>
							<div class="col col-8 col-xs-12">
								<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='45464.Depo Çıkış Tarihi Girmelisiniz'>!</cfsavecontent>
										<cfinput type="text" name="action_date" id="action_date" value="#dateformat(get_ship_result.out_date,dateformat_style)#" onChange="depot_date_change();" validate="#validate_style#" maxlength="10" required="yes" message="#message#" style="width:65px;">
										<span class="input-group-addon"><cf_wrk_date_image date_field="action_date"></span>
									</div>
								</div>
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
									<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
										<cf_wrkTimeFormat  name="start_h" id="start_h" value="#numberformat("#hour(get_ship_result.out_date)#",00)#">	
									</div>
									<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
										<select name="start_m" id="start_m">
											<cfloop from="0" to="59" index="n">
												<option value="#numberformat(n,00)#" <cfif n eq minute(get_ship_result.out_date)>selected</cfif>>#numberformat(n,00)#</option>
											</cfloop>
										</select>
									</div>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-deliver_name2">
							<label class="col col-4 col-xs-12"><cfif x_equipment_planning_info eq 0><cf_get_lang dictionary_id='45470.Teslim Eden'><cfelse><cf_get_lang dictionary_id='45785.Planlayan'></cfif></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="header_"><cfif x_equipment_planning_info eq 0><cf_get_lang dictionary_id='45470.Teslim Eden'><cfelse><cf_get_lang dictionary_id='45785.Planlayan'></cfif></cfsavecontent>
									<input type="hidden" name="deliver_id2" id="deliver_id2" value="#get_ship_result.deliver_pos#">
									<input name="deliver_name2" type="text" id="deliver_name2"  onfocus="AutoComplete_Create('deliver_name2','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','deliver_id2','','3','170');" value="#get_emp_info(get_ship_result.deliver_pos,0,0)#" autocomplete="off">                                            
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id2=upd_packet_ship.deliver_id2&field_name=upd_packet_ship.deliver_name2&select_list=1');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-location_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29428.Çıkış Depo'><cfif x_equipment_planning_info eq 1>*</cfif></label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="header_"><cf_get_lang dictionary_id='29428.Çıkış Depo'><cfif x_equipment_planning_info eq 1>*</cfif></cfsavecontent>
								<cfset location_info_ = get_location_info(get_ship_result.department_id,get_ship_result.location_id,1,1)>
								<cf_wrkdepartmentlocation
									returnInputValue="location_id,department_name,department_id,branch_id"
									returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
									fieldName="department_name"
									fieldid="location_id"
									department_fldId="department_id"
									branch_fldId="branch_id"
									branch_id="#listlast(location_info_,',')#"
									location_id="#get_ship_result.location_id#"
									department_id="#get_ship_result.department_id#"
									location_name="#listfirst(location_info_,',')#"
									user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
									dsp_service_loc="1"
									width=170>
							</div>
						</div>
						<input type="hidden" name="options_kontrol" id="options_kontrol" value="1">
						<cfif x_equipment_planning_info eq 0>
						<div class="form-group" id="item-calculate_type">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45546.Hes. Yöntemi'></label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="header_"><cf_get_lang dictionary_id='45546.Hes. Yöntemi'></cfsavecontent>
								<input type="hidden" name="max_limit" id="max_limit" value="#get_ship_method_price.max_limit#">                                        
								<label><input type="radio" name="calculate_type" id="calculate_type" disabled="disabled" value="1" <cfif get_ship_method_price.calculate_type eq 1>checked</cfif> onclick="change_packet(1);" ><cf_get_lang no='370.Kümülatif'></label>
								<label><input type="radio" name="calculate_type" id="calculate_type" disabled="disabled" value="2" <cfif get_ship_method_price.calculate_type eq 2>checked</cfif> onclick="change_packet(2);"><cf_get_lang no='371.Paket'></label>
							</div>
						</div>
						</cfif>
						<cfif x_equipment_planning_info eq 0>
						<div class="form-group" id="item-total_cost2_value">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57492.Toplam'><cf_get_lang dictionary_id='45493.Maliyet Tutarı'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57492.Toplam'><cf_get_lang dictionary_id='45493.Maliyet Tutarı'></cfsavecontent>
									<input type="text" name="total_cost_value" id="total_cost_value" value="#TlFormat(sum_ship_result.cost_value)#" onkeyup="return(FormatCurrency(this,event));" class="moneybox" readonly style="width:74px;"><span class="input-group-addon no-bg">#session.ep.money#</span>
									<input type="text" name="total_cost2_value" id="total_cost2_value" value="#TlFormat(sum_ship_result.cost_value2)#" onkeyup="return(FormatCurrency(this,event));" class="moneybox" readonly style="width:74px;"><span class="input-group-addon no-bg">#session.ep.money2#</span>
								</div>
							</div>
						</div>
						</cfif>
					</div>
				</cfoutput>    
				<cfif x_equipment_planning_info eq 0>
					<cfquery name="GET_PACKAGE" datasource="#DSN2#">
						(SELECT
							SRP.*,
							'' PACK_NAME,
							SR.COMPANY_ID,
							SR.PARTNER_ID,
							SR.CONSUMER_ID					
						FROM
							SHIP_RESULT_PACKAGE SRP,
							SHIP_RESULT SR
						WHERE 
							SRP.SHIP_ID IN (#valuelist(get_ship_results_all.ship_result_id)#) AND
							SRP.PACK_EMP_ID IS NULL AND
							SRP.SHIP_ID = SR.SHIP_RESULT_ID
							
						UNION ALL
							
						SELECT
							SRP.*,
							<cfif (database_type is 'MSSQL')>
							EMPLOYEES.EMPLOYEE_NAME +' '+ EMPLOYEES.EMPLOYEE_SURNAME PACK_NAME,
							<cfelseif (database_type is 'DB2')>
							EMPLOYEES.EMPLOYEE_NAME ||' '|| EMPLOYEES.EMPLOYEE_SURNAME PACK_NAME,
							</cfif>
							SR.COMPANY_ID,
							SR.PARTNER_ID,
							SR.CONSUMER_ID		
						FROM
							SHIP_RESULT_PACKAGE SRP,
							#dsn_alias#.EMPLOYEES EMPLOYEES,
							SHIP_RESULT SR
						WHERE 
							SRP.SHIP_ID IN (#valuelist(get_ship_results_all.ship_result_id)#) AND
							SRP.PACK_EMP_ID = EMPLOYEES.EMPLOYEE_ID AND
							SRP.SHIP_ID = SR.SHIP_RESULT_ID
						)
						ORDER BY 
							SHIP_ID
					</cfquery>
					<!--- Cari ile iliskili irsaliye satirlari icin --->
					<cfset SHIP_RESULT_ID_CURRENTROW = QueryNew("SIRA,SHIP_RESULT_ID","Integer,Integer")>
					<cfscript>
						for(ii = 1; ii LTE get_row.recordcount; ii = ii + 1)
						{
							QueryAddRow(SHIP_RESULT_ID_CURRENTROW,1);
							QuerySetCell(SHIP_RESULT_ID_CURRENTROW,"SIRA",ii);
							QuerySetCell(SHIP_RESULT_ID_CURRENTROW,"SHIP_RESULT_ID",get_row.ship_result_id[ii]); 
						} 
					</cfscript>
					<!--- Cari ile iliskili paket satirlari icin --->
					<cfset PACKAGE_CURRENTROW = QueryNew("SIRA,SHIP_ID","Integer,Integer")><!--- ,COMPANY_ID,CONSUMER_ID --->
					<cfscript>
						for(ii = 1; ii LTE get_package.recordcount; ii = ii + 1)
						{
							QueryAddRow(PACKAGE_CURRENTROW,1);
							QuerySetCell(PACKAGE_CURRENTROW,"SIRA",ii);
							QuerySetCell(PACKAGE_CURRENTROW,"SHIP_ID",get_package.ship_id[ii]); 
						} 
					</cfscript>
				</cfif>
				<div class="col col-9 col-xs-12 ListContent">
					<cf_seperator id="sevkiyat" title="#getLang('','Sevkiyatlar','34791')#">
					<cf_grid_list id="sevkiyat">
						<thead>
							<cfif x_equipment_planning_info eq 0>
								<tr>
									<th style="text-align:center;" width="50">
										<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_row.recordcount#</cfoutput>">
										<input type="hidden" name="ship_id_list" id="ship_id_list" value="">
										<cfif get_ship_result.is_type neq 2><span onClick="add_row();" class="fa fa-plus" title="<cf_get_lang dictionary_id='58061.Cari'><cf_get_lang dictionary_id='57582.Ekle'>"></span></cfif>
									</th>
									<th width="20"><i class="fa fa-archive" title="<cf_get_lang dictionary_id='63707.Paket Ekle'>"></i></th>
									<th width="20"><i class="fa fa-copy" title="<cf_get_lang dictionary_id='45323.İlişkili İrsaliye Ekle'>"></i></th>
									<th width="160"><cf_get_lang dictionary_id='57519.Cari Hesap'>*</th>
									<th width="125"><cfif get_ship_result.is_type eq 2><cf_get_lang_main no='799.Sipariş No'><cfelse><cf_get_lang dictionary_id='58138.İrsaliye No'></cfif>*</th>
									<th width="65"><cf_get_lang dictionary_id='57742.Tarih'></th>
									<th width="140"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></th>
									<th width="150"><cf_get_lang dictionary_id='58723.Adres'></th>
									<th width="100"><cf_get_lang dictionary_id='45493.Maliyet Tutarı'><cfoutput>(#session.ep.money#)</cfoutput></th>
									<th width="100"><cf_get_lang dictionary_id='45493.Maliyet Tutarı'><cfoutput>(#session.ep.money2#)</cfoutput></th>
									<th width="20"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='45656.Paket Kontrol'>"></i></th>
								</tr>
								
							<cfelse>
								<!--- Planlama Bazinda Siparisler --->
								<tr height="20">
									<th style="text-align:center;">
										<cfoutput>
										<input type="hidden" name="record_num" id="record_num" value="#get_row.recordcount#">
										<input type="hidden" name="ship_result_id" id="ship_result_id" value="#get_row.ship_result_id#">
										</cfoutput>
									</th>
									<th width="65" class="txtboldblue"><cf_get_lang dictionary_id='58211.Sipariş No'></th>
									<th width="75" class="txtboldblue"><cf_get_lang dictionary_id='29501.Sipariş Tarihi'></th>
									<th width="75" class="txtboldblue"><cf_get_lang dictionary_id='57645.Teslim Tarihi'></th>
									<th width="110" class="txtboldblue"><cf_get_lang dictionary_id='58733.Alıcı'></th>
									<th width="190" class="txtboldblue"><cf_get_lang dictionary_id='57657.Ürün'></th>
									<th width="190" class="txtboldblue"><cf_get_lang dictionary_id='57647.Spekt'></th>
									<th width="50" align="right" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='45786.Plan'></th>
									<th width="50" align="right" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='45787.Yüklenen'></th>
									<th width="50" align="right" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='58444.Kalan'></th>
									<th width="80" class="txtboldblue">&nbsp;<!--- Adres ---></th>
								</tr>
								<cfset Diff_Amount_ = 0>
								<cfset Ship_Wrk_Row_List = "">
								<cfset new_dept_list = "">
								<cfoutput query="get_row">
									<cfquery name="Get_Orders_Info" datasource="#dsn3#">
										SELECT
											O.ORDER_ID,
											O.PURCHASE_SALES,
											O.ORDER_ZONE,
											O.ORDER_NUMBER,
											O.ORDER_DATE,
											O.RECORD_DATE,
											(SELECT C.COMPANYCAT_ID FROM #dsn_alias#.COMPANY C WHERE C.COMPANY_ID = O.COMPANY_ID) COMP_CAT,
											(SELECT C.CONSUMER_CAT_ID FROM #dsn_alias#.CONSUMER C WHERE C.CONSUMER_ID = O.CONSUMER_ID) CONS_CAT,
											O.COMPANY_ID,
											O.CONSUMER_ID,
											ISNULL(OW.DELIVER_DATE,O.DELIVERDATE) DELIVER_DATE_,
											OW.ORDER_ROW_ID,
											OW.ORDER_ROW_CURRENCY,
											OW.QUANTITY,
											OW.WRK_ROW_ID,
											OW.STOCK_ID,
											OW.PRODUCT_NAME,
											OW.SPECT_VAR_ID,
											OW.SPECT_VAR_NAME,
											(SELECT PACKAGE_CONTROL_TYPE FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID = OW.PRODUCT_ID) CONTROL_TYPE,
											ISNULL(ISNULL(OW.DELIVER_DEPT,O.DELIVER_DEPT_ID),0) DEPT_ID,
											ISNULL(ISNULL(OW.DELIVER_LOCATION,O.LOCATION_ID),0) LOC_ID
										FROM
											ORDERS O,
											ORDER_ROW OW
										WHERE
											O.ORDER_ID = OW.ORDER_ID AND
											OW.WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Wrk_Row_Relation_Id#">
									</cfquery>
									<cfif len(Get_Orders_Info.comp_cat) and len(x_member_cat) and listfind(x_member_cat,Get_Orders_Info.comp_cat)>
										<cfset x_select_process_type = 2>
									<cfelseif len(Get_Orders_Info.cons_cat) and len(x_consumer_cat) and listfind(x_consumer_cat,Get_Orders_Info.cons_cat)>
										<cfset x_select_process_type = 2>
									<cfelse>
										<cfset x_select_process_type = 1>
									</cfif>
				
									<cfif not listfind(new_dept_list,"#Get_Orders_Info.dept_id#_#Get_Orders_Info.loc_id#")>
										<cfset new_dept_list = listappend(new_dept_list,"#Get_Orders_Info.dept_id#_#Get_Orders_Info.loc_id#")>
									</cfif>
									<cfquery name="Get_Ship_Info" datasource="#dsn2#">
										SELECT PURCHASE_SALES,SHIP_ID,SHIP_NUMBER FROM SHIP WHERE SHIP_ID IN (SELECT SHIP_ID FROM SHIP_ROW WHERE WRK_ROW_RELATION_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Get_Orders_Info.Wrk_Row_Id#"> AND AMOUNT = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row.SHIP_ROW_AMOUNT_#">) AND SHIP_ID = <cfif len(Ship_Id)><cfqueryparam cfsqltype="cf_sql_integer" value="#ship_id#"><cfelse>0</cfif>
									</cfquery>
									<cfquery name="Get_Inv_Info" datasource="#dsn2#">
										SELECT PURCHASE_SALES,INVOICE_ID,INVOICE_NUMBER FROM INVOICE WHERE INVOICE_ID IN (SELECT INVOICE_ID FROM INVOICE_ROW WHERE WRK_ROW_RELATION_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Get_Orders_Info.Wrk_Row_Id#"> AND AMOUNT = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row.SHIP_ROW_AMOUNT_#">)
									</cfquery>
									<tr id="frm_row#currentrow#" <cfif is_problem eq 1>style="color:red;"</cfif>>
										<th><input type="hidden" name="ship_result_row_id#currentrow#" id="ship_result_row_id#currentrow#" value="#ship_result_row_id#">
											<input type="hidden" name="ship_result_wrk_row_id#currentrow#" id="ship_result_wrk_row_id#currentrow#" value="#wrk_row_id#">
											<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
											<cfif (x_select_process_type eq 1 and not Len(Get_Ship_Info.Ship_Id)) or (x_select_process_type eq 2 and not Len(Get_Inv_Info.invoice_id))>
												<cfif is_problem neq 1>
												<a style="cursor:pointer" onclick="sil('#currentrow#');"><i class="fa fa-minus" title="Sil"></i></a>
												</cfif>
											<cfelse>
												<cfset Ship_Wrk_Row_List = ListAppend(Ship_Wrk_Row_List,Get_Orders_Info.Wrk_Row_Id,';')>
											</cfif>
										</th>
										<th><input type="hidden" name="order_id#currentrow#" id="order_id#currentrow#" value="#Get_Orders_Info.Order_Id#">
											<input type="hidden" name="order_row_id#currentrow#" id="order_row_id#currentrow#" value="#Get_Orders_Info.Order_Row_Id#">
											<input type="hidden" name="dep_id#currentrow#" id="dep_id#currentrow#" value="#Get_Orders_Info.dept_id#">
											<input type="hidden" name="loc_id#currentrow#" id="loc_id#currentrow#" value="#Get_Orders_Info.loc_id#">
											<input type="hidden" name="order_wrk_row_id#currentrow#" id="order_wrk_row_id#currentrow#" value="#Get_Orders_Info.Wrk_Row_Id#">
											<input type="hidden" name="ship_id#currentrow#" id="ship_id#currentrow#" value="#Get_Ship_Info.Ship_Id#">
											<input type="hidden" name="invoice_id#currentrow#" id="invoice_id#currentrow#" value="#Get_Inv_Info.invoice_id#">
											<input type="hidden" name="order_number#currentrow#" id="order_number#currentrow#" value="#get_row.Order_Number#" style="width:70px;" readonly>
											<input type="hidden" name="is_problem#currentrow#" id="is_problem#currentrow#" value="<cfif is_problem eq 1>1<cfelse>0</cfif>">
											<input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#Get_Orders_Info.Stock_Id#">
											<cfif len(Get_Orders_Info.Spect_Var_Id)>
												<cfquery name="get_spec_main_id" datasource="#dsn3#">
													SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID = #Get_Orders_Info.Spect_Var_Id#
												</cfquery>
												<input type="hidden" name="spect_var_id#currentrow#" id="spect_var_id#currentrow#" value="#get_spec_main_id.SPECT_MAIN_ID#">
											<cfelse>
												<input type="hidden" name="spect_var_id#currentrow#" id="spect_var_id#currentrow#" value="">
											</cfif>
											<input type="hidden" name="spect_var_name#currentrow#" id="spect_var_name#currentrow#" value="#Get_Orders_Info.SPECT_VAR_NAME#">
											#get_row.Order_Number#
										</th>
										<th align="center">
											<input type="hidden" name="order_date#currentrow#" id="order_date#currentrow#" value="#DateFormat(Get_Orders_Info.Order_Date,dateformat_style)#" style="width:75px;" readonly>
											#DateFormat(Get_Orders_Info.Order_Date,dateformat_style)#
										</th>
										<th align="center">#DateFormat(Get_Orders_Info.Deliver_Date_,dateformat_style)#</th>
										<th><cfif Len(Get_Orders_Info.Company_Id)>#get_par_info(Get_Orders_Info.Company_Id,1,1,0)#<cfelseif Len(Get_Orders_Info.Consumer_Id)>#get_cons_info(Get_Orders_Info.Consumer_Id,0,0)#</cfif></th>
										<th>#Get_Orders_Info.Product_Name#</th>
										<th>#Get_Orders_Info.Spect_Var_Name#</th>
										<th align="right" style="text-align:right;">
											<input type="hidden" name="order_row_amount_#currentrow#" id="order_row_amount_#currentrow#" value="#TLFormat(get_row.Order_Row_Amount_)#" style="width:45px;text-align:right;" readonly>
											<cfif get_row.Order_Row_Amount_ contains '.'>#TLFormat(get_row.Order_Row_Amount_,2,0)#<cfelse>#TLFormat(get_row.Order_Row_Amount_,0)#</cfif>
										</th>
										<th align="right" style="text-align:right;"><input type="<cfif is_problem eq 1>hidden<cfelse>text</cfif>" name="ship_row_amount_#currentrow#" id="ship_row_amount_#currentrow#" value="<cfif Len(get_row.SHIP_ROW_AMOUNT_)><cfif get_row.SHIP_ROW_AMOUNT_ contains '.'>#TLFormat(get_row.SHIP_ROW_AMOUNT_,2,0)#<cfelse>#TLFormat(get_row.SHIP_ROW_AMOUNT_,0)#</cfif><cfelse>#TLFormat(0,0)#</cfif>" style="width:45px;text-align:right;" <cfif (Get_Orders_Info.Control_Type eq 2 and Len(Get_Orders_Info.Spect_Var_Id)) or (not ListFind(x_edit_ship_row_amount,session.ep.company_id,',')) or (not Len(Get_Orders_Info.Wrk_Row_Id)) or get_ship_control.recordcount>readonly</cfif> onblur="if(filterNum(this.value,2)==''){this.value=commaSplit(0,0);}if(filterNum(this.value,2)> #Order_Row_Amount_#){alert('Kalan Miktar <cfif Order_Row_Amount_ contains '.'>#TLFormat(Order_Row_Amount_,2,0)#<cfelse>#TLFormat(Order_Row_Amount_,0)#</cfif> dan Fazla Olmamalıdır!');this.value=commaSplit(#Order_Row_Amount_#<cfif Order_Row_Amount_ contains '.'>,2</cfif>,0);}"></th>
										<th align="right" style="text-align:right;">
											<cfif Len(get_row.SHIP_ROW_AMOUNT_)>
												<cfset Diff_Amount_ = get_row.Order_Row_Amount_ - get_row.SHIP_ROW_AMOUNT_>
											<cfelse>
												<cfset Diff_Amount_ = get_row.Order_Row_Amount_>
											</cfif>
											<cfif Diff_Amount_ lt 0>#TLFormat(0,0)#<cfelse><cfif Diff_Amount_ contains '.'>#TLFormat(Diff_Amount_,2,0)#<cfelse>#TLFormat(Diff_Amount_,0)#</cfif></cfif>
										</th>
										<input type="hidden" name="order_address#currentrow#" id="order_address#currentrow#" value="#Deliver_Adress#">
										<cfif Len(Get_Ship_Info.Ship_Id) and is_problem neq 1>
											<th nowrap>
												<cfif Get_Ship_Info.RecordCount and Get_Ship_Info.Purchase_Sales eq 0>
													<a href="#request.self#?fuseaction=stock.form_add_purchase&event=upd&ship_id=#Get_Ship_Info.Ship_Id#" target="_blank" class="tableyazi">#Get_Ship_Info.Ship_Number#</a>
												<cfelseif Get_Ship_Info.RecordCount and Get_Ship_Info.Purchase_Sales eq 1>
													<a href="#request.self#?fuseaction=stock.form_add_sale&event=upd&ship_id=#Get_Ship_Info.Ship_Id#" target="_blank" class="tableyazi">#Get_Ship_Info.Ship_Number#</a>
												</cfif>
											</th>
										<cfelseif Len(Get_Inv_Info.invoice_id) and is_problem neq 1>
											<th nowrap>
												<cfif Get_Inv_Info.RecordCount and Get_Inv_Info.Purchase_Sales eq 0>
													<a href="#request.self#?fuseaction=invoice.form_add_bill_purchas&event=upd&iid=#Get_Inv_Info.invoice_id#" target="_blank" class="tableyazi">#Get_Inv_Info.invoice_number#</a>
												<cfelseif Get_Inv_Info.RecordCount and Get_Inv_Info.Purchase_Sales eq 1>
													<a href="#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=#Get_Inv_Info.invoice_id#" target="_blank" class="tableyazi">#Get_Inv_Info.invoice_number#</a>
												</cfif>
											</th>
										<cfelseif not Len(Get_Orders_Info.Wrk_Row_Id)>
											<th><cf_get_lang dictionary_id='34126.Sipariş yok'></th>
										<cfelseif is_problem eq 1>
											<th><cf_get_lang dictionary_id='63711.Sorunlu Sevkiyat'></th>
										</cfif>
									</tr>
									<cfif len(Get_Orders_Info.Spect_Var_Id)>
										<cfquery name="get_main_spect" datasource="#dsn3#">
											SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Orders_Info.Spect_Var_Id#">
										</cfquery>
										<cfif Len(get_main_spect.SPECT_MAIN_ID)>
											<cfquery name="get_spect_info" datasource="#dsn3#">
												SELECT
													SM.SPECT_MAIN_NAME,
													SM.STOCK_ID
												FROM
													SPECT_MAIN SM,
													SPECT_MAIN_ROW SMR,
													SPECT_MAIN_ROW SMR2
												WHERE
													SMR2.SPECT_MAIN_ID = SM.SPECT_MAIN_ID
													AND SMR2.SPECT_MAIN_ID = SMR.RELATED_MAIN_SPECT_ID
													AND SMR.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_main_spect.SPECT_MAIN_ID#">
											</cfquery>
											<cfloop query="get_spect_info">
												<cfset "new_spect_name_#STOCK_ID#" = get_spect_info.SPECT_MAIN_NAME>
											</cfloop>
										</cfif>
									</cfif>
									<!--- Bilesenli Urun Varsa Buraya Girer --->
									<cfif Get_Orders_Info.Control_Type eq 2 and Len(Get_Orders_Info.Spect_Var_Id)>
										<cfquery name="Get_Row_Component" datasource="#dsn2#">
											SELECT * FROM SHIP_RESULT_ROW_COMPONENT WHERE SHIP_RESULT_ID = #Ship_Result_Id# AND SHIP_RESULT_ROW_ID = #Ship_Result_Row_Id#
										</cfquery>
										<cfif Get_Row_Component.RecordCount>
										<cfloop query="Get_Row_Component">
											<tr id="frm_rows#get_row.currentrow#_#Get_Row_Component.currentrow#" <cfif get_row.is_problem eq 1>style="color:red;"</cfif>>
												<th>&nbsp;</th>
												<th>&nbsp;</th>
												<th>&nbsp;</th>
												<th>&nbsp;</th>
												<th>&nbsp;</th>
												<th colspan="2">&nbsp;&nbsp;<strong>#Get_Row_Component.Component_Product_Name#</strong><cfif isdefined("new_spect_name_#Get_Row_Component.Component_Stock_Id#")> - #evaluate("new_spect_name_#Get_Row_Component.Component_Stock_Id#")#</cfif></th>
												<th align="right" style="text-align:right;">#TLFormat(Get_Row_Component.Component_Amount,0)#*#TLFormat(get_row.Order_Row_Amount_,0)#</th>
												<th align="right" style="text-align:right;">
													<input type="<cfif get_row.is_problem eq 1>hidden<cfelse>text</cfif>" name="spect_to_ship_amount_#get_row.Wrk_Row_Relation_Id#_#Get_Row_Component.Component_Spect_Row_Id#" id="spect_to_ship_amount_#get_row.Wrk_Row_Relation_Id#_#Get_Row_Component.Component_Spect_Row_Id#" value="#TLFormat(Get_Row_Component.Ship_Result_Row_Amount,0)#" style="width:45px;text-align:right;" <cfif (not ListFind(x_edit_ship_row_amount,session.ep.company_id,',')) or (not Len(Get_Orders_Info.Wrk_Row_Id)) or get_ship_control.recordcount>readonly</cfif> onblur="if(filterNum(this.value,2)==''){this.value=commaSplit(0,0);}if(filterNum(this.value,2)> #get_row.Order_Row_Amount_*Get_Row_Component.Component_Amount#){alert('Yüklenen Miktar #TLFormat((get_row.Order_Row_Amount_*Get_Row_Component.Component_Amount),0)# dan Fazla Olmamalıdır!');this.value=commaSplit((#get_row.Order_Row_Amount_*Get_Row_Component.Component_Amount#),0);};">
													<input type="hidden" name="spect_amount_#get_row.Wrk_Row_Relation_Id#_#Get_Row_Component.Component_Spect_Row_Id#" id="spect_amount_#get_row.Wrk_Row_Relation_Id#_#Get_Row_Component.Component_Spect_Row_Id#" value="#TLFormat(get_row.Order_Row_Amount_*Get_Row_Component.Component_Amount)#">
												</th>
												<th align="right" style="text-align:right;"><cfif Diff_Amount_ lt 0>#TLFormat(0,0)#<cfelse>#TLFormat((Diff_Amount_*Get_Row_Component.Component_Amount),0)#</cfif></th>
											</tr>
										</cfloop>
										</cfif>
									</cfif>
								</cfoutput>
								<cfset Ship_Wrk_Row_List = ListSort(ListDeleteDuplicates(Ship_Wrk_Row_List),"text","asc",";")>
								<cfif not ListLen(Ship_Wrk_Row_List,';')>
									<cfif Get_Orders_Info.RecordCount and Get_Orders_Info.Purchase_Sales eq 0 and Get_Orders_Info.Order_Zone eq 0><!--- Satinalma --->
										<cfif x_select_process_type eq 1>
											<cfset Fuse_Name_ = "stock.form_add_purchase">
										<cfelse>
											<cfset Fuse_Name_ = "invoice.form_add_bill_purchase">
										</cfif>
									<cfelseif Get_Orders_Info.RecordCount and ((Get_Orders_Info.Purchase_Sales eq 0 and Get_Orders_Info.Order_Zone eq 1) or (Get_Orders_Info.Purchase_Sales eq 1 and Get_Orders_Info.Order_Zone eq 0))><!--- Satis --->
										<cfif x_select_process_type eq 1>
											<cfset Fuse_Name_ = "stock.form_add_sale">
										<cfelse>
											<cfset Fuse_Name_ = "invoice.form_add_bill">
										</cfif>
									</cfif>
									<cfif isdefined("Fuse_Name_") and Len(Fuse_Name_)>
										<cfquery name="Get_Process_Cat" datasource="#dsn3#"><!--- Irsaliye Islem Kategorisi --->
											SELECT DISTINCT
												SPC.PROCESS_CAT_ID,
												SPC.PROCESS_TYPE,
												SPC.PROCESS_CAT,
												SPC.IS_ZERO_STOCK_CONTROL
											FROM
												SETUP_PROCESS_CAT_ROWS AS SPCR,
												#dsn_alias#.EMPLOYEE_POSITIONS AS EP,
												SETUP_PROCESS_CAT SPC
											WHERE
												SPC.PROCESS_CAT_ID = SPCR.PROCESS_CAT_ID AND
												SPC.PROCESS_MODULE IN (13,14,32,50,20) AND
												SPC.PROCESS_CAT_ID IN (SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT_FUSENAME WHERE FUSE_NAME = '#Fuse_Name_#')
												AND	EP.POSITION_CODE = #session.ep.position_code# AND
												( SPCR.POSITION_CODE = EP.POSITION_CODE OR SPCR.POSITION_CAT_ID = EP.POSITION_CAT_ID )
											ORDER BY
												SPC.PROCESS_CAT
										</cfquery>
									<cfelse>
										<cfset Get_Process_Cat.RecordCount = 0>
									</cfif>
									<tr>
										<th style="text-align:right;" colspan="10">
											<cfif isdefined("x_ship_group_dept") and x_ship_group_dept eq 1>
												<input type="hidden" name="new_dept_list" id="new_dept_list" value="<cfoutput>#new_dept_list#</cfoutput>">
											<cfelse>
												<input type="hidden" name="new_dept_list" id="new_dept_list" value="0">
											</cfif>
											<input type="hidden" name="x_select_process_type" id="x_select_process_type" value="<cfoutput>#x_select_process_type#</cfoutput>">
											<input type="button" name="transfer_amounts" id="transfer_amounts" value="<cf_get_lang no='144.Hepsini Yükle'>" onclick="row_all_control(3);">&nbsp;&nbsp;
											<input type="hidden" name="spect_control_number" id="spect_control_number" value="<cfif get_row.is_problem eq 1>1<cfelse>0</cfif>">
											<input type="hidden" name="ship_out_date" id="ship_out_date" value="<cfoutput>#get_ship_result.out_date#</cfoutput>">
											<input type="hidden" name="order_wrk_row_list" id="order_wrk_row_list" value=""><!--- Form Gonderilirken Dolduruluyor; Siparislerin Irsaliyelesecek Wrk_Row_Id leri Gonderiliyor --->
											<input type="hidden" name="no_send_stock_id_list" id="no_send_stock_id_list" value=""><!--- Form Gonderilirken Dolduruluyor; Spect Bazinda 0 Stok Kontrolunden Gecemeyen Stock Idler Gönderiliyor Tekrar Isleme Konmamasi Icin --->
											<input type="hidden" name="no_send_ship_wrk_row_list" id="no_send_ship_wrk_row_list" value="<cfoutput>#Ship_Wrk_Row_List#</cfoutput>"><!--- Form Gonderilirken Dolduruluyor; Irsaliyelesmis Satirlar Gonderiliyor, Tekrar Isleme Konmamasi Icin --->
											<select name="process_type_ship" id="process_type_ship" style="width:180px;">
												<option value=""><cf_get_lang_main no='388.İşlem Tipi'></option>
												<cfif Get_Process_Cat.RecordCount>
												<cfoutput query="Get_Process_Cat">
													<option value="#Is_Zero_Stock_Control#_#Process_Type#_#Process_Cat_Id#">#Process_Cat#</option>
												</cfoutput>
												</cfif>
											</select>&nbsp;&nbsp;
											<cfif x_select_process_type eq 1>
												<cfsavecontent variable="irsaliye_planla"><cf_get_lang dictionary_id='45322.İrsaliyeleştir'></cfsavecontent>
											<cfelse>
												<cfsavecontent variable="irsaliye_planla"><cf_get_lang dictionary_id='57263.Fatura Ekle'></cfsavecontent>
											</cfif>
											<cfif x_select_process_type eq 1>
												<cfsavecontent variable="irsaliye_planla_alert"><cf_get_lang dictionary_id='63712.Seçili Siparişleri İrsaliyeleştirmek İstediğinizden Emin Misiniz?'></cfsavecontent>
											<cfelse>
												<cfsavecontent variable="irsaliye_planla_alert"><cf_get_lang dictionary_id='63713.Seçili Siparişleri Faturalandırmak İstediğinizden Emin Misiniz?'></cfsavecontent>
											</cfif>
											<cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='#irsaliye_planla#' add_function='kontrol_sevk()' insert_alert='#irsaliye_planla_alert#'>
										</th>
										<th align="right">&nbsp;</th>
									</tr>
								</cfif>
							</cfif>
						</thead>
						<tbody>
							<cfoutput query="get_row">
								<tr id="frm_row#currentrow#">
									<cfquery name="GET_SHIP" datasource="#DSN2#">
										SELECT SHIP_NUMBER FROM SHIP WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ship_id#">
									</cfquery>
									<td><input type="hidden" name="cari_kontrol#currentrow#" id="cari_kontrol#currentrow#" value="">
										<input type="hidden" name="ship_result_id#currentrow#" id="ship_result_id#currentrow#" value="#ship_result_id#">
										<input type="hidden" name="ship_result_row_id#currentrow#" id="ship_result_row_id#currentrow#" value="#ship_result_row_id#">
										<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
										<a style="cursor:pointer" onclick="sil('#currentrow#');"><i class="fa fa-minus" title="Sil"></i></a>
									</td>
										<cfif get_row.ship_result_id[currentrow-1] neq get_row.ship_result_id>					
											<cfif x_equipment_planning_info eq 0>
												<td><a style="cursor:pointer" onclick="add_row_other('#currentrow#');"><i class="fa fa-archive" title="<cf_get_lang dictionary_id='63707.Paket Ekle'>"></i></a></td>
												<td><a style="cursor:pointer" onclick="add_row2('#currentrow#');"><i class="fa fa-copy" title="<cf_get_lang dictionary_id='45323.İlişkili İrsaliye Ekle'>"></i></a></td>
											</cfif>
										<cfelse>
											<td></td>
											<td></td>
										</cfif>
									</td>
									<td>
										<cfquery name="PACKAGE_CURRENTROW_ROW" dbtype="query">
											SELECT * FROM PACKAGE_CURRENTROW WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ship_result_id#">
										</cfquery>
										<cfquery name="SHIP_RESULT_ID_CURRENTROW_ROW" dbtype="query">
											SELECT * FROM SHIP_RESULT_ID_CURRENTROW WHERE SHIP_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ship_result_id#"> AND SIRA <> <cfqueryparam cfsqltype="cf_sql_integer" value="#currentrow#">
										</cfquery>
										<!--- ust siradaki ship_id bu satirdaki ayni mi? --->
										<cfif get_row.ship_result_id[currentrow-1] neq get_row.ship_result_id>
											<input type="hidden" name="row_count_#currentrow#_list" id="row_count_#currentrow#_list" value="#valuelist(ship_result_id_currentrow_row.sira)#">
											<input type="hidden" name="cari_#currentrow#_ship_id_list" id="cari_#currentrow#_ship_id_list" value="#valuelist(package_currentrow_row.sira)#">
											<input type="hidden" name="related_row_kontrol#currentrow#" id="related_row_kontrol#currentrow#" value="">
										<cfelse>
											<input type="hidden" name="row_count_#currentrow#_list" id="row_count_#currentrow#_list" value="">
											<input type="hidden" name="cari_#currentrow#_ship_id_list" id="cari_#currentrow#_ship_id_list" value="">								
											<input type="hidden" name="related_row_kontrol#currentrow#" id="related_row_kontrol#currentrow#" value="#listfind(valuelist(ship_result_id_currentrow.ship_result_id),get_row.ship_result_id)#">
										</cfif>
										<cfif len(company_id)>
											<cfquery name="GET_COMPANY_ROW" dbtype="query">
												SELECT * FROM GET_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#">						
											</cfquery>
											<cfset member_name_row = get_company_row.fullname>
										<cfelse>
											<cfquery name="GET_CONSUMER_ROW" dbtype="query">
												SELECT * FROM GET_CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#consumer_id#">						
											</cfquery>
											<cfset member_name_row = '#get_consumer_row.consumer_name# #get_consumer_row.consumer_surname#'>
										</cfif>	
										<div class="form-group">
											<div class="input-group">
												<input type="hidden" name="consumer_id#currentrow#" id="consumer_id#currentrow#" value="#consumer_id#">
												<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="#company_id#">
												<input type="hidden" name="partner_id#currentrow#" id="partner_id#currentrow#" value="#partner_id#">
												<input type="text" name="member_name#currentrow#" id="member_name#currentrow#" value="#member_name_row#" readonly>
												<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac_cari('+ row_count +');"></span>
											</div>
										</div>						
									</td>
									<td>
										<div class="form-group">
											<div class="input-group">
												<input type="hidden" name="ship_id#currentrow#" id="ship_id#currentrow#" value="#ship_id#">
												<input type="text" name="ship_number#currentrow#" id="ship_number#currentrow#" value="#get_ship.ship_number#" readonly>
												<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac('#currentrow#');"></span>
											</div>
										</div>	
									</td>
									<td>
										<input type="text" name="ship_date#currentrow#" id="ship_date#currentrow#" value="#dateformat(ship_date,dateformat_style)#" readonly style="width:65px;">
										<input type="hidden" name="ship_deliver#currentrow#" id="ship_deliver#currentrow#" value="#DELIVER_COMP#" readonly style="width:120px;">
									</td>
									<td><input type="text" name="ship_type#currentrow#"  id="ship_type#currentrow#"value="#deliver_type#" readonly style="width:140px;"></td>
									<td><input type="text" name="ship_adress#currentrow#" id="ship_adress#currentrow#" value="#deliver_adress#" readonly style="width:190px;"></td>
									<td>
										<div class="form-group">
											<cfif get_row.ship_result_id[currentrow-1] neq get_row.ship_result_id>
												<input type="text" name="total_cost_value#currentrow#" id="total_cost_value#currentrow#" value="#TlFormat(cost_value)#" class="moneybox" readonly>&nbsp;#session.ep.money#
											<cfelse>
												<input type="hidden" name="total_cost_value#currentrow#" id="total_cost_value#currentrow#" value="#TlFormat(0)#" class="moneybox" readonly>
											</cfif>
										</div>
									</td>
									<td>
										<div class="form-group">
											<cfif get_row.ship_result_id[currentrow-1] neq get_row.ship_result_id>
												<input type="text" name="total_cost2_value#currentrow#" id="total_cost2_value#currentrow#" value="#TlFormat(cost_value2)#" class="moneybox" readonly>&nbsp;#session.ep.money2#
											<cfelse>
												<input type="hidden" name="total_cost2_value#currentrow#" id="total_cost2_value#currentrow#" value="#TlFormat(0)#" class="moneybox" readonly>
											</cfif>
										</div>
									</td>
									<td><cfif get_ship_result.is_type neq 2>
											<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=stock.popup_ship_package_detail&process_id=#ship_id#','project')"><i class="fa fa-cube" title="#SHIP_FIS_NO#<!--- Paket Kontrol --->"></i></a>
										</cfif>						
									</td>
								</tr>
							</cfoutput>
						</tbody>
						<tbody id="table1"></tbody>
					</cf_grid_list>
				</div>
				<cfif x_equipment_planning_info eq 0>
					<div class="col col-9 col-xs-12 ListContent">
						<cf_seperator id="paket" title="#getLang('','Paketler','60')#">
						<cf_grid_list id="paket">
							<thead>
								<tr>
									<th width="50">&nbsp;<input type="hidden" name="record_num_other" id="record_num_other" value="<cfoutput>#get_package.recordcount#</cfoutput>"></th>
									<th width="160"><cf_get_lang dictionary_id='57519.Cari Hesap'>*</th>
									<th width="40"><cf_get_lang dictionary_id='58082.Adet'>*</th>
									<th width="130"><cf_get_lang dictionary_id='45477.Paket Tipi'>*</th>
									<th width="150"><cf_get_lang dictionary_id='45478.Ebat'></th>
									<th width="150"><cf_get_lang dictionary_id='29784.Ağırlık'> (kg)</th>
									<th width="150"><cf_get_lang dictionary_id='57633.Barkod'></th>
									<th width="150"><cf_get_lang dictionary_id='45545.Paketleyen'></th>
								</tr>		
							</thead>
							<tbody>
								<cfoutput query="get_package">
									<cfquery name="GET_TYPE" datasource="#DSN#">
										SELECT PACKAGE_TYPE, DIMENTION FROM SETUP_PACKAGE_TYPE WHERE PACKAGE_TYPE_ID = <cfif len(package_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#package_type#"><cfelse>0</cfif>
									</cfquery>
									<tr id="frm_row_other#currentrow#">
										<cfif len(company_id)>
											<cfquery name="GET_COMPANY_ROW" dbtype="query">
												SELECT * FROM GET_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#">						
											</cfquery>
											<cfset member_name_other_row = get_company_row.fullname>
											<cfset deger_row_count_other = ListFind(ValueList(get_row.company_id),company_id)>
										<cfelse>
											<cfquery name="GET_CONSUMER_ROW" dbtype="query">
												SELECT * FROM GET_CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#consumer_id#">						
											</cfquery>
											<cfset member_name_other_row = '#get_consumer_row.consumer_name# #get_consumer_row.consumer_surname#'>
											<cfset deger_row_count_other = ListFind(ValueList(get_row.consumer_id),consumer_id)>
										</cfif>
										<td><input type="hidden" name="ship_result_package_id#currentrow#" id="ship_result_package_id#currentrow#" value="#ship_result_package_id#">
											<input type="hidden" name="row_count_other#currentrow#" id="row_count_other#currentrow#" value="#deger_row_count_other#">
											<input type="hidden" name="row_kontrol_other#currentrow#" id="row_kontrol_other#currentrow#" value="1">
											<a style="cursor:pointer" onclick="sil_other('#currentrow#');"><i class="fa fa-minus" title="Sil"></i></a>
										</td>
										<td><input type="hidden" name="consumer_id_other#currentrow#" id="consumer_id_other#currentrow#" value="#consumer_id#">
											<input type="hidden" name="company_id_other#currentrow#" id="company_id_other#currentrow#" value="#company_id#">
											<input type="hidden" name="partner_id_other#currentrow#" id="partner_id_other#currentrow#" value="#partner_id#">
											<input type="text" name="member_name_other#currentrow#" id="member_name_other#currentrow#" value="#member_name_other_row#" readonly>
										</td>
										<td><input type="text" name="quantity#currentrow#" id="quantity#currentrow#" value="#tlformat(package_piece,0)#" onblur="degistir('#currentrow#');" onkeyup="return(FormatCurrency(this,event,0));" class="moneybox" style="width:40px;"></td>
										<td><select name="package_type#currentrow#" id="package_type#currentrow#" onchange="degistir('#currentrow#');" style="width:130px;">
												<cfset value_package_type = package_type>
												<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
												<cfloop query="get_package_type">
													<option value="#package_type_id#,#dimention#,#calculate_type_id#" <cfif value_package_type eq package_type_id>selected</cfif>>#package_type#</option>
												</cfloop>
											</select>
										</td>
										<td><input type="text" name="ship_ebat#currentrow#" id="ship_ebat#currentrow#" value="#get_type.dimention#" readonly style="width:90px;"></td>
										<td><input type="text" name="ship_agirlik#currentrow#" id="ship_agirlik#currentrow#" value="#tlformat(package_weight)#" onblur="degistir('#currentrow#');" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:75px;"></td>
										<td>
											<input type="hidden" name="total_price#currentrow#" id="total_price#currentrow#" value="#tlformat(total_price)#" onkeyup="return(FormatCurrency(this,event));" class="moneybox" readonly style="width:75px;">
											<input type="hidden" name="other_money#currentrow#" id="other_money#currentrow#" value="#other_money#" class="moneybox" readonly style="width:50px;">
											<input type="text" name="ship_barcod#currentrow#" id="ship_barcod#currentrow#" value="#barcode#" style="width:120px;">
										</td>
										<td>
											<div class="form-group">
												<div class="input-group">
													<input type="hidden" name="pack_emp_id#currentrow#" id="pack_emp_id#currentrow#" value="#get_package.pack_emp_id#">
													<input type="text" name="pack_emp_name#currentrow#" id="pack_emp_name#currentrow#" value="#get_package.pack_name#" style="width:150px;">
													<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac2(#currentrow#);"></span></div></div>
												</div>
											</div>
										</td>
									</tr>
								</cfoutput>
							</tbody>
							<tbody id="table2"></tbody>
						</cf_grid_list>
					</div>
				</cfif>
			</cf_box_elements>
			<cf_box_footer>
				<cf_record_info query_name="get_ship_result">
				<cfif get_ship_control.recordcount>
					<cf_workcube_buttons is_upd='1' is_delete='0' add_function='control()'>
				<cfelse>
					<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=stock.emptypopup_del_packetship&multi_packet_ship=1&main_ship_fis_no=#attributes.main_ship_fis_no#&head=#get_ship_result.ship_fis_no#' add_function='control()'>
				</cfif>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
row_count=<cfoutput>#get_row.recordcount#</cfoutput>;
<cfif x_equipment_planning_info eq 0>
	<cfoutput>
	calculate_type_deger=#get_ship_method_price.CALCULATE_TYPE#;
	row_count2=#get_package.recordcount#;
	money_list = "#valuelist(moneys.money,',')#";
	rate1_list = "#valuelist(moneys.rate1,',')#";
	rate2_list = "#valuelist(moneys.rate2,',')#";
	</cfoutput>
</cfif>
kontrol_row_count=<cfoutput>#get_row.recordcount#</cfoutput>;
var production_row_ = 0;
var production_row_alert_ = '';
<cfif x_equipment_planning_info eq 1>
	order_amount_control = 0;
	function row_all_control(no_,ono_)
	{
		order_wrk_row_list_ = '';
		<cfif get_row.recordcount>
		<cfoutput query="get_row">
			<cfquery name="Get_Orders_Info" datasource="#dsn3#">
				SELECT
					O.ORDER_NUMBER,
					OW.PRODUCT_NAME,
					OW.SPECT_VAR_ID,
					OW.SPECT_VAR_NAME,
					OW.ORDER_ROW_CURRENCY,
					(SELECT PACKAGE_CONTROL_TYPE FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID = OW.PRODUCT_ID) CONTROL_TYPE
				FROM
					ORDERS O,
					ORDER_ROW OW
				WHERE
					O.ORDER_ID = OW.ORDER_ID AND
					OW.WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Wrk_Row_Relation_Id#">
			</cfquery>
			<cfif Get_Orders_Info.RecordCount and Get_Orders_Info.ORDER_ROW_CURRENCY eq -5>
				if(document.getElementById("ship_row_amount_#currentrow#").value > 0)
				{
					production_row_ = 1;
					production_row_alert_ = production_row_alert_ + "\n #Get_Orders_Info.Order_Number# : #Get_Orders_Info.Product_Name# - #Get_Orders_Info.Spect_Var_Name#";
				}
			</cfif>
			if(no_ == 3)
			{
				<cfif get_row.is_problem neq 1>
					document.getElementById("ship_row_amount_#currentrow#").value = filterNum(document.getElementById("order_row_amount_#currentrow#").value,0);
				<cfelse>
					document.getElementById("ship_row_amount_#currentrow#").value = 0;
				</cfif>
				document.getElementById("spect_control_number").value = 0;
			}
			<cfif Get_Orders_Info.Control_Type eq 2 and Len(Get_Orders_Info.Spect_Var_Id)>
				<cfquery name="Get_Row_Component" datasource="#dsn2#">
					SELECT * FROM SHIP_RESULT_ROW_COMPONENT WHERE SHIP_RESULT_ID = #Ship_Result_Id# AND SHIP_RESULT_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ship_Result_Row_Id#">
				</cfquery>
				var bolum_ = 999999999999999;
				<cfif Get_Row_Component.RecordCount>
				<cfloop query="Get_Row_Component">
					if(no_ == 1 || no_ == 5)
					{
						var spect_amount_script_ = filterNum(document.getElementById("spect_amount_#get_row.Wrk_Row_Relation_Id#_#Get_Row_Component.Component_Spect_Row_Id#").value,0);
						var spect_to_ship_amount_script_ = filterNum(document.getElementById("spect_to_ship_amount_#get_row.Wrk_Row_Relation_Id#_#Get_Row_Component.Component_Spect_Row_Id#").value,0);
						if (spect_to_ship_amount_script_ != undefined)
						{
							if(bolum_ >= parseInt(spect_to_ship_amount_script_/#Get_Row_Component.Component_Amount#))
							{
								bolum_ = parseInt(spect_to_ship_amount_script_/#Get_Row_Component.Component_Amount#);
							}
						}
						<cfif not ListLen(Ship_Wrk_Row_List,';')>
							document.getElementById("spect_control_number").value = 1;
						</cfif>
				
					}
					if(no_ == 3)
					{
						if(document.getElementById("spect_to_ship_amount_#get_row.Wrk_Row_Relation_Id#_#Get_Row_Component.Component_Spect_Row_Id#") != undefined)
						{
						<cfif get_row.is_problem neq 1>
							document.getElementById("spect_to_ship_amount_#get_row.Wrk_Row_Relation_Id#_#Get_Row_Component.Component_Spect_Row_Id#").value = filterNum(document.getElementById("spect_amount_#get_row.Wrk_Row_Relation_Id#_#Get_Row_Component.Component_Spect_Row_Id#").value,0);
						<cfelse>
							document.getElementById("spect_to_ship_amount_#get_row.Wrk_Row_Relation_Id#_#Get_Row_Component.Component_Spect_Row_Id#").value = 0;
						</cfif>
						}
					}
					//4 no silme isleminde bilesenleri de satirlardan temizlemek icin kullaniliyor
					if(no_ == 4 && ono_ == #get_row.currentrow#)
					{
						var my_element2=eval("frm_rows"+#get_row.currentrow#+'_'+#Get_Row_Component.currentrow#);
						my_element2.style.display="none";
					}
				</cfloop>
				</cfif>
				if (no_ == 1 || no_ == 5)
				{
					<cfif get_row.is_problem neq 1>
						document.getElementById("ship_row_amount_#currentrow#").value = commaSplit(bolum_,0);
					<cfelse>
						document.getElementById("ship_row_amount_#currentrow#").value = 0;
					</cfif>
				}
			</cfif>
			if(no_ != 4)
			{
				var ship_row_amount_script_ = filterNum(document.getElementById("ship_row_amount_#currentrow#").value,0);
				<cfif get_row.is_problem neq 1>//Sorunlu Kayitlar Tekrar Eklenmeyecek
				if(document.getElementById("order_wrk_row_id#currentrow#").value != '' && ship_row_amount_script_ != '' && ship_row_amount_script_ > 0)
				{
					var order_wrk_row_list_ = order_wrk_row_list_  + '#get_row.Wrk_Row_Relation_Id#_' + filterNum(document.getElementById("ship_row_amount_#currentrow#").value,2,0) + ';';
					order_amount_control ++;
				}
				</cfif>
				<cfif not ListLen(Ship_Wrk_Row_List,';')>
					document.getElementById("order_wrk_row_list").value = order_wrk_row_list_;
				</cfif>
			}
		</cfoutput>
		</cfif>
		if(no_ == 5)
		{
			//En az Bir Satir Bulunmasi ile Ilgili Kontrol
			var satir_kontrol2_ = 0;
			for(kk=1; kk <= document.getElementById("record_num").value; kk++)
			{	
				if(document.getElementById("row_kontrol"+kk).value == 1)
					var satir_kontrol2_ = satir_kontrol2_ + 1;
			}
			
			if(satir_kontrol2_ == 0)
			{
				alert("<cf_get_lang dictionary_id='63714.Sevkiyatta En Az Bir Satır Bulunmalıdır'> !");
				return false;
			}
		}
		if(no_ == 1)
		{
			//Burada uretim asamasindaki siparisler icin kullaniciya bilgi veriyoruz, devam etmeyebilir.
			if(production_row_ == 1)
			{
				if(!(confirm("<cf_get_lang dictionary_id='63715.Üretim Aşamasında Ürünü Sevk Ediyorsunuz. Devam Edecek Misiniz ?'> " + production_row_alert_)))
				{
					production_row_ = 0;
					production_row_alert_ = '';
					return false;
				}
				production_row_ = 0;
				production_row_alert_ = '';
			}
			if(order_amount_control <= 0)
			{
				alert("<cf_get_lang dictionary_id='63716.İrsaliye/Fatura Oluşturmak İçin En Az Bir Ürüne Miktar Girmelisiniz'> !");
				return false;
			}
			document.upd_packet_ship.action='<cfoutput>#request.self#?fuseaction=stock.emptypopup_add_multi_packetship_to_ship&x_ship_group_dept=#x_ship_group_dept#</cfoutput>';
			document.upd_packet_ship.submit();
			return false;
		}
	}

	var is_add_sale_=1;
	function kontrol_sevk()
	{
		if(is_add_sale_ == 1)
		{
			is_add_sale_ = 0;
			
			//En az Bir Satir Bulunmasi ile Ilgili Kontrol
			var satir_kontrol_ = 0;
			for(kk=1; kk <= document.getElementById("record_num").value; kk++)
			{	
				if(document.getElementById("row_kontrol"+kk).value == 1)
					var satir_kontrol_ = satir_kontrol_ + 1;
			}
			
			if(satir_kontrol_ == 0)
			{
				alert("<cf_get_lang dictionary_id='63714.Sevkiyatta En Az Bir Satır Bulunmalıdır'> !");
				return false;
			}
			if(document.getElementById("process_type_ship").value == '')
			{
				alert("<cf_get_lang dictionary_id='58770.İşlem Tipi Seçiniz'> / <cf_get_lang dictionary_id='63717.Tanımlanan İşlem Tipleri Üzerinde Yetkiniz Yok'> !");
				return false;
			}
			<cfif not Len(listfirst(location_info_,','))>
				alert("<cf_get_lang dictionary_id='63718.İrsaliye/Fatura Oluşturmak İçin Önce Depo Seçip İşlemi Güncellemelisiniz'> !");
				return false;
			</cfif>
			<cfif x_select_process_type eq 2>
				var get_paper_no = wrk_safe_query('obj_get_papers_no','dsn3',0,"<cfoutput>#session.ep.userid#</cfoutput>");
				if(get_paper_no.recordcount == 0 || get_paper_no.INVOICE_NO == '' || get_paper_no.INVOICE_NUMBER == '')
				{
					alert("<cf_get_lang dictionary_id='63719.Lütfen Kişisel Ayarlarınızdan Belge Numaralarınızı Tanımlayınız. Ayarlarım>Belge No sayfasını Kullanınız'> !");
					return false;
				}
			</cfif>
			var hata = '';
			var hatap = '';
			var hatas = '';
			var rowCount = kontrol_row_count;
			var popup_spec_type=1; //specli stok
			
			var dep_id = upd_packet_ship.department_id.value;
			var loc_id = upd_packet_ship.location_id.value;
			
			for(kk_indx=1;kk_indx<=list_len(document.getElementById("new_dept_list").value);kk_indx++)
			{
				var stock_id_list='0';
				var stock_amount_list='0';
				var spec_id_list='0';
				var spec_amount_list='0';
				var main_spec_id_list='0';
				var main_spec_amount_list='0';
				var no_send_stock_id_list_ = '0';
				for (var counter_=1; counter_ <= rowCount; counter_++)
				{
					if(parseFloat(filterNum(document.getElementById("ship_row_amount_"+counter_).value)) > 0)
					{
						var stock_field = document.getElementById("stock_id"+counter_).value;
						var amount_field = document.getElementById("ship_row_amount_"+counter_).value;
						var spec_field = document.getElementById("spect_var_id"+counter_).value;
						var dep_id_ = document.getElementById("dep_id"+counter_).value;
						var loc_id_ = document.getElementById("loc_id"+counter_).value;
						kontrol_dept_row = 0;
						<cfif isdefined("x_ship_group_dept") and x_ship_group_dept eq 1>//depo bazında gruplama
							if(dep_id_ != 0)
							{
								var dep_id = dep_id_;
								var loc_id = loc_id_;
							}
							new_dep_id = list_getat(list_getat(document.getElementById("new_dept_list").value,kk_indx),1,'_');
							new_loc_id = list_getat(list_getat(document.getElementById("new_dept_list").value,kk_indx),2,'_');
							kontrol_dept_row = 1;
						</cfif>
						
						if(kontrol_dept_row == 0 || (kontrol_dept_row == 1 && dep_id == new_dep_id && loc_id == new_loc_id))
						{
							if(spec_field != undefined && spec_field != '')
							{
								var yer=list_find(spec_id_list,spec_field,',');
								if(yer)
								{
									top_stock_miktar=parseFloat(list_getat(spec_amount_list,yer,','))+parseFloat(filterNum(amount_field));
									spec_amount_list=list_setat(spec_amount_list,yer,top_stock_miktar,',');
								}
								else
								{
									spec_id_list=spec_id_list + ',' + spec_field;
									spec_amount_list=spec_amount_list+','+filterNum(amount_field);
								}
							}
					
							//artık uretilen urun icinde once kendi stok miktarı olmalı sonra specli stoğa bakılıyor
							var yer=list_find(stock_id_list,stock_field,',');
							if(yer)
							{
								top_stock_miktar=parseFloat(list_getat(stock_amount_list,yer,','))+parseFloat(filterNum(amount_field));
								stock_amount_list=list_setat(stock_amount_list,yer,top_stock_miktar,',');
							}
							else
							{
								stock_id_list=stock_id_list+',' + stock_field;
								stock_amount_list=stock_amount_list+',' + filterNum(amount_field);
							}
						}
					}
				}
				<cfif isdefined("x_ship_group_dept") and x_ship_group_dept eq 1>
					dep_id = list_getat(list_getat(document.getElementById("new_dept_list").value,kk_indx),1,'_');
					loc_id = list_getat(list_getat(document.getElementById("new_dept_list").value,kk_indx),2,'_');
				</cfif>
				main_spec_id_list = spec_id_list;
				main_spec_amount_list = spec_amount_list;
				get_spect = '';	
				var stock_id_count=list_len(stock_id_list,',');
	
				//specli stok kontrolleri
				if(popup_spec_type==1 && list_len(main_spec_id_list,',') >1)//specli stok bakılacaksa 
				{
					var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + main_spec_id_list + "*" + loc_id + "*" + dep_id;
					if(dep_id == '' || dep_id == undefined || loc_id == '' || loc_id == undefined)
						var new_sql = 'stk_get_total_stock_16';
					else
					{
						var new_sql = 'stk_get_total_stock_17';
					}
					var get_total_stock = wrk_safe_query(new_sql,'dsn2',0,listParam);
					var query_spec_id_list = '0';
					if(get_total_stock.recordcount)
					{
						for(var cnt=0; cnt < get_total_stock.recordcount; cnt++)
						{
							query_spec_id_list=query_spec_id_list+','+get_total_stock.SPECT_MAIN_ID[cnt];//queryden gelen kayıtları tutuyruz gelmeyenlerde stokta yoktur cunku
							var yer=list_find(main_spec_id_list,get_total_stock.SPECT_MAIN_ID[cnt],',');
							if(parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) < parseFloat(list_getat(main_spec_amount_list,yer,',')))
							{
								hatas = hatas + get_total_stock.MAIN_PRODUCT_NAME[cnt] + '-' + get_total_stock.PRODUCT_NAME[cnt] + ' (Stok Kodu: ' + get_total_stock.STOCK_CODE[cnt] + ' / Stok Miktarı: '+  parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) +')\n';
								no_send_stock_id_list_ = no_send_stock_id_list_ + ',' + get_total_stock.STOCK_ID[cnt]; 
							}
						}
					}
					var diff_spec_id='0';
					for(var lst_cnt=1;lst_cnt <= list_len(main_spec_id_list,',');lst_cnt++)
					{
						var spc_id=list_getat(main_spec_id_list,lst_cnt,',');
						if(!list_find(query_spec_id_list,spc_id,','))
							diff_spec_id=diff_spec_id+','+spc_id;//kayıt gelmeyen urunler
					}
					
					if(diff_spec_id!='0' && list_len(diff_spec_id,',')>1)//bu lokasyona hiç giriş veya çıkış olmadı ise kayıt gelemyecektir o yüzden else yazıldı
					{
						var get_stock = wrk_safe_query('stk_get_stock_3','dsn3',0,diff_spec_id);
						for(var cnt=0; cnt < get_stock.recordcount; cnt++)
						{
							hatas = hatas + get_stock.MAIN_PRODUCT_NAME[cnt] + '-' + get_stock.PRODUCT_NAME[cnt] + ' (Stok Kodu: ' + get_stock.STOCK_CODE[cnt]+ ' / Stok Miktarı: 0)\n';
							no_send_stock_id_list_ = no_send_stock_id_list_ + ',' + get_stock.STOCK_ID[cnt]; 
						}
					}
					get_total_stock='';
				}
				//stock kontrolleri
				if(stock_id_count >1)
				{
					var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + stock_id_list + "*" + no_send_stock_id_list_ + "*" + loc_id + "*" + dep_id;
					if(dep_id=='' || dep_id==undefined || loc_id=='' || loc_id==undefined)//departman ve lokasyon yok ise
						var new_sql = 'stk_get_total_stock_18';			
					else
						var new_sql = 'stk_get_total_stock_19';
		
					var get_total_stock = wrk_safe_query(new_sql,'dsn2',0,listParam);			
					if(get_total_stock.recordcount)
					{
						var query_stock_id_list='0';
						for(var cnt=0; cnt < get_total_stock.recordcount; cnt++)
						{
							query_stock_id_list=query_stock_id_list+','+get_total_stock.STOCK_ID[cnt];//queryden gelen kayıtları tutuyruz gelmeyenlerde stokta yoktur cunku
							var yer=list_find(stock_id_list,get_total_stock.STOCK_ID[cnt],',');
							if(parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) < parseFloat(list_getat(stock_amount_list,yer,',')))
							{
								hatap = hatap + get_total_stock.PRODUCT_NAME[cnt] + ' (Stok Kodu: '+get_total_stock.STOCK_CODE[cnt]  + ' / Stok Miktarı: '+  parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) + ')\n';
								no_send_stock_id_list_ = no_send_stock_id_list_ + ',' + get_total_stock.STOCK_ID[cnt]; 
							}
						}
					}
					var diff_stock_id='0';
					for(var lst_cnt=1;lst_cnt <= list_len(stock_id_list);lst_cnt++)
					{
						var stk_id=list_getat(stock_id_list,lst_cnt,',')
						if(query_stock_id_list==undefined || query_stock_id_list=='0' || list_find(query_stock_id_list,stk_id,',') == '0')
							diff_stock_id=diff_stock_id+','+stk_id;//kayıt gelmeyen urunler
					}
					if(list_len(diff_stock_id,',')>1)//bu lokasyona hiç giriş veya çıkış olmadı ise kayıt gelemyecektir o yüzden yazıldı
					{
						var listParam = diff_stock_id + "*" + no_send_stock_id_list_;
						var get_stock = wrk_safe_query("stk_get_total_stock_20",'dsn3',0,listParam);
						for(var cnt=0; cnt < get_stock.recordcount; cnt++)
						{
							hatap = hatap + get_stock.PRODUCT_NAME[cnt] + ' (Stok Kodu: '+get_stock.STOCK_CODE[cnt] + ' / Stok Miktarı: 0)\n';
							no_send_stock_id_list_ = no_send_stock_id_list_ + ',' + get_stock.STOCK_ID[cnt]; 
						}
					}
					get_total_stock='';
					hata = hatap + hatas;
				}
			}
			var sifir_stok_yapilsin_mi = list_getat(document.getElementById("process_type_ship").value,1,'_');
			if(sifir_stok_yapilsin_mi == 1)
			{
				if(hatap!='' || hatas!='')
				{
					alert(hata + "<cf_get_lang dictionary_id='33757.Yukarıdaki ürünlerde stok miktarı yeterli değildir. Lütfen seçtiğiniz depo-lokasyonundaki miktarları kontrol ediniz'>!");
					is_add_sale_ = 1;
					return false;
				}
			}
			else
			{
				if(hatap!='' || hatas!='')
				{
					if(!confirm(hata + "<cf_get_lang dictionary_id='33757.Yukarıdaki ürünlerde stok miktarı yeterli değildir. Lütfen seçtiğiniz depo-lokasyonundaki miktarları kontrol ediniz'>!"))
					{
						document.getElementById("no_send_stock_id_list").value = no_send_stock_id_list_; // irsaliye fonksiyonundaki kontrolleri duzenlemek icin eklendi
						is_add_sale_ = 1;
						return false;
					}
					
				}
			}
			hata='';
			hatap = '';
			hatas = '';
			return row_all_control(1);
		}
		else
			return false;
	}
	
</cfif>
<cfif x_equipment_planning_info eq 0>
	function pencere_ac(no)
	{
		deger_company_id = document.getElementById("company_id"+no).value;
		deger_consumer_id = document.getElementById("consumer_id"+no).value;
		
		document.getElementById("ship_id_list").value ='';
		if(deger_company_id != "")
		{
			for(r=1;r<=document.getElementById("record_num").value;r++)
			{	
				deger_row_kontrol = document.getElementById("row_kontrol"+r).value;
				deger_ship_id = document.getElementById("ship_id"+r).value;
				deger_company_id2 = document.getElementById("company_id"+r).value;
				if(deger_row_kontrol == 1 && (deger_company_id2 == deger_company_id))
				{
					if(document.getElementById("ship_id_list").value == '')
					{
						if(deger_ship_id != '')
							document.getElementById("ship_id_list").value = deger_ship_id;
					}
					else
					{
						if(deger_ship_id != '')
							document.getElementById("ship_id_list").value += ','+deger_ship_id;
					}	
				}
			}
			<!---windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_ship_details</cfoutput>&ship_id_list=' + upd_packet_ship.ship_id_list.value + '&ship_id=upd_packet_ship.ship_id'+no+'&ship_number=upd_packet_ship.ship_number'+no+'&ship_date=upd_packet_ship.ship_date'+no+'&ship_deliver=upd_packet_ship.ship_deliver'+no+'&ship_type=upd_packet_ship.ship_type'+no+'&ship_adress=upd_packet_ship.ship_adress'+no+'&is_gonder=1&deliver_company_id='+deger_company_id,'project');--->
			openBoxDraggable('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_ship_details</cfoutput>&is_multi=1&ship_id_list=' + document.getElementById('ship_id_list').value + '&ship_id=ship_id'+no+'&ship_number=ship_number'+no+'&ship_date=ship_date'+no+'&ship_deliver=ship_deliver'+no+'&ship_type=ship_type'+no+'&ship_adress=ship_adress'+no+'&is_gonder=1&deliver_company_id='+deger_company_id);
		}
		else if(deger_consumer_id != "")
		{
			for(r=1;r<=upd_packet_ship.record_num.value;r++)
			{	
				deger_row_kontrol = document.getElementById("row_kontrol"+r).value;
				deger_ship_id = document.getElementById("ship_id"+r).value;
				deger_consumer_id2 = document.getElementById("consumer_id"+r).value;
				if(deger_row_kontrol == 1 && (deger_consumer_id2 == deger_consumer_id))
				{
					if(document.getElementById("ship_id_list").value == '')
					{
						if(deger_ship_id != '')
							document.getElementById("ship_id_list").value = deger_ship_id;
					}
					else
					{
						if(deger_ship_id != '')
							document.getElementById("ship_id_list").value += ','+deger_ship_id;
					}	
				}
			}
	
<!---			windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_ship_details</cfoutput>&ship_id_list=' + upd_packet_ship.ship_id_list.value + '&ship_id=upd_packet_ship.ship_id'+no+'&ship_number=upd_packet_ship.ship_number'+no+'&ship_date=upd_packet_ship.ship_date'+no+'&ship_deliver=upd_packet_ship.ship_deliver'+no+'&ship_type=upd_packet_ship.ship_type'+no+'&ship_adress=upd_packet_ship.ship_adress'+no+'&is_gonder=1&deliver_company_id='+deger_consumer_id,'list');--->
				openBoxDraggable('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_ship_details</cfoutput>&is_multi=1&ship_id_list=' + document.getElementById('ship_id_list').value + '&ship_id=ship_id'+no+'&ship_number=ship_number'+no+'&ship_date=ship_date'+no+'&ship_deliver=ship_deliver'+no+'&ship_type=ship_type'+no+'&ship_adress=ship_adress'+no+'&is_gonder=1&deliver_consumer_id='+deger_consumer_id);//&deliver_company_id='+add_packet_ship.service_company_id.value	

		}
		else
		{
			alert(no + ".<cf_get_lang dictionary_id='45657.Satır İçin'><cf_get_lang dictionary_id='45308.Cari Hesap Seçmelisiniz'>");
			return false;
		}
	}

	function pencere_ac2(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_packet_ship.pack_emp_id'+ no +'&field_name=upd_packet_ship.pack_emp_name'+ no+'&select_list=1');
	}
	
	function pencere_ac_cari(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_comp_id=upd_packet_ship.company_id'+ no +'&field_partner=upd_packet_ship.partner_id'+ no +'&field_consumer=upd_packet_ship.consumer_id'+ no +'&field_comp_name=upd_packet_ship.member_name'+ no +'&field_name=upd_packet_ship.member_name'+ no +'&call_function=cari_kontrol('+no+')&select_list=7,8');
	}
	
	function cari_kontrol(no)
	{
		deger_company_id = document.getElementById("company_id"+no).value;
		deger_consumer_id = document.getElementById("consumer_id"+no).value;
		if(deger_company_id !='')
			deger_cari = deger_company_id;
		else
			deger_cari = deger_consumer_id;
		for(ck=1;ck<=upd_packet_ship.record_num.value;ck++)
		{
			deger_row_kontrol = document.getElementById("row_kontrol"+ck).value;
			if (deger_company_id != '')

				deger_cari_row = document.getElementById("company_id"+ck).value;
			else
				deger_cari_row = document.getElementById("consumer_id"+ck).value;
			//Satir silinmemis,ilgili satırla dongudeki satir farkli mi ve deger aynimi
			if(deger_row_kontrol == 1 && (ck != no) && (deger_cari == deger_cari_row)) 
				document.getElementById("cari_kontrol"+no).value = ck;
		}
	}
</cfif>

<cfif x_equipment_planning_info eq 0>
	function sil(sy)
	{
		for(r=1;r<=upd_packet_ship.record_num_other.value;r++)
		{
			deger_row_kontrol_other = document.getElementById("row_kontrol_other"+r).value;
			deger_row_count_other = document.getElementById("row_count_other"+r).value;
			if(deger_row_kontrol_other == 1 && (deger_row_count_other == sy))//satir silinmemis ve irsaliye ile iliskili ise
			{
				alert("<cf_get_lang dictionary_id='45658.İlgili İrsaliye ile İlişkili Paketler Mevcut. Kontrol Ediniz'>!");
				return false;
			}
		}
	
		kontrol_row_count--;
		var my_element=document.getElementById("row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	
		for(rr=1;rr<=upd_packet_ship.record_num.value;rr++)
		{
			deger_row_kontrol = document.getElementById("row_kontrol"+rr).value;
			deger_related_row_kontrol = document.getElementById("related_row_kontrol"+rr).value;
			if(deger_row_kontrol == 1 && (deger_related_row_kontrol == sy))
			{
				kontrol_row_count--;
				var my_element=document.getElementById("row_kontrol"+rr);
				my_element.value=0;
				var my_element=eval("frm_row"+rr);
				my_element.style.display="none";
			}
		}
	}	
<cfelse>//siparislerin silinmesi
	function sil(sy)
	{
		kontrol_row_count--;
		var my_element=document.getElementById("row_kontrol"+sy);
		
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		return row_all_control(4,sy);
	}
</cfif>

<cfif x_equipment_planning_info eq 0>
	function sil_other(sy)
	{
		//irsaliye ve paket satir iliskisi icin silinen satırda 
		temp_row_count_other = document.getElementById("row_count_other"+sy).value;
		temp_cari_ship_id_list = document.getElementById("cari_" +temp_row_count_other+ "_ship_id_list").value;
		
		var temp_ship_id_list = '';
		for(r=1;r<=list_len(temp_cari_ship_id_list);r++)
		{
			if(list_getat(temp_cari_ship_id_list,r) != sy)
			{
				if(temp_ship_id_list == '')
					temp_ship_id_list = list_getat(temp_cari_ship_id_list,r);
				else
					temp_ship_id_list += ','+list_getat(temp_cari_ship_id_list,r);
			}
		}
		
		var my_element=document.getElementById("row_kontrol_other"+sy);
		my_element.value=0;
		var my_element=eval("frm_row_other"+sy);
		my_element.style.display="none";
		degistir(sy);
	}

	function add_row()
	{
		if(document.getElementById("options_kontrol").value == 0 || document.getElementById("options_kontrol").value == "")
		{	
			alert("<cf_get_lang dictionary_id='45663.Lütfen Hesaplama için Tasıyıcı Firmayı Kontrol Ediniz (Fiyat Listesi)'>!");
			return false;
		}
		
		row_count++;
		kontrol_row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		document.getElementById("record_num").value=row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" value="1"><input type="hidden" name="ship_result_id' + row_count +'" id="ship_result_id' + row_count +'" value=""><input type="hidden" name="ship_result_row_id' + row_count +'" id="ship_result_row_id' + row_count +'" value=""><input type="hidden" name="row_count_' + row_count +'_list" id="row_count_' + row_count +'_list" value=""><input type="hidden" name="related_row_kontrol' + row_count +'" id="related_row_kontrol' + row_count +'" value=""><a style="cursor:pointer" onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="Sil"></i></a>';
		/* paket */
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<cfif x_equipment_planning_info eq 0><a style="cursor:pointer" onclick="add_row_other(' + row_count + ');" title="<cf_get_lang dictionary_id='63707.Paket Ekle'>"><i class="fa fa-archive"></i></a></cfif>';		
		
		/* copy */
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<cfif x_equipment_planning_info eq 0><a style="cursor:pointer" onclick="add_row2(' + row_count + ');"><i class="fa fa-copy" title="<cf_get_lang dictionary_id='45323.İlişkili İrsaliye Ekle'>"></i></a></cfif>';
		/*  */
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="cari_kontrol' + row_count +'" id="cari_kontrol' + row_count +'" value=""><input type="hidden" name="cari_' + row_count +'_ship_id_list" id="cari_' + row_count +'_ship_id_list" value=""><input type="hidden" name="consumer_id' + row_count +'" id="consumer_id' + row_count +'" value=""><input type="hidden" name="company_id' + row_count +'" id="company_id' + row_count +'" value=""><input type="hidden" name="partner_id' + row_count +'" id="partner_id' + row_count +'" value=""><input type="text" name="member_name' + row_count +'" id="member_name' + row_count +'" value="" readonly style="width:145px;">&nbsp;<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_cari('+ row_count +');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="ship_id' + row_count +'" id="ship_id' + row_count +'"><input type="text" name="ship_number' + row_count +'" id="ship_number' + row_count +'" value="" readonly  style="width:110px;"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac('+ row_count +');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="ship_deliver' + row_count +'" id="ship_deliver' + row_count +'" value="" readonly style="width:120px;"><input type="text" name="ship_date' + row_count +'" id="ship_date' + row_count +'" value="" readonly style="width:65px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="ship_type' + row_count +'" id="ship_type' + row_count +'" value="" readonly style="width:140px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="ship_adress' + row_count +'" id="ship_adress' + row_count +'" value="" readonly style="width:190px;">';
		/* maliyet1 */
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="total_cost_value' + row_count +'" id="total_cost_value' + row_count +'" value="<cfoutput>#TlFormat(0)#</cfoutput>" class="moneybox" readonly style="width:70px;">&nbsp;<cfoutput>#session.ep.money#</cfoutput></div>';
		/* maliyet2 */
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="total_cost2_value' + row_count +'" id="total_cost2_value' + row_count +'" value="<cfoutput>#TlFormat(0)#</cfoutput>" class="moneybox" readonly style="width:70px;">&nbsp;<cfoutput>#session.ep.money2#</cfoutput></div>';
		newCell = newRow.insertCell(newRow.cells.length);
	}

	function add_row2(no)
	{
		deger_company_id = document.getElementById("company_id"+no).value;
		deger_partner_id = document.getElementById("partner_id"+no).value;
		deger_consumer_id = document.getElementById("consumer_id"+no).value;
		deger_member_name = document.getElementById("member_name"+no).value;
		deger_ship_id = document.getElementById("ship_id"+no).value;
		
		deger_cari_ship_id_list = document.getElementById("cari_" +no+ "_ship_id_list");
		
		deger_row_count_list = document.getElementById("row_count_" +no+ "_list");
		
		if(deger_company_id == "" && deger_consumer_id == "")
		{
			alert(no + ". <cf_get_lang dictionary_id='45657.Satır İçin'><cf_get_lang dictionary_id='45308.Cari Hesap Seçmelisiniz'>");
			return false;
		}
		
		if(deger_ship_id == "")
		{
			alert(no + ".<cf_get_lang dictionary_id='45657.Satır İçin'><cf_get_lang dictionary_id='45483.İrsaliye Seçiniz'>!");
			return false;
		}
		
		row_count++;
		kontrol_row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		document.getElementById("record_num").value=row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" value="1"><input type="hidden" name="ship_result_id' + row_count +'" id="ship_result_id' + row_count +'" value=""><input type="hidden" name="ship_result_row_id' + row_count +'" id="ship_result_row_id' + row_count +'" value=""><input type="hidden" name="row_count_' + row_count +'_list" id="row_count_' + row_count +'_list" value=""><input type="hidden" name="related_row_kontrol' + row_count +'" id="related_row_kontrol' + row_count +'" value="'+no+'">';
		/* paket */
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<cfif x_equipment_planning_info eq 0><a style="cursor:pointer" onclick="add_row_other(' + row_count + ');" title="<cf_get_lang dictionary_id='63707.Paket Ekle'>"><i class="fa fa-archive"></i></a></cfif>';		
		/*  */
		/* copy */
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<cfif x_equipment_planning_info eq 0><a style="cursor:pointer" onclick="add_row2(' + row_count + ');"><i class="fa fa-copy" title="<cf_get_lang dictionary_id='45323.İlişkili İrsaliye Ekle'>"></i></a></cfif>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="cari_kontrol' + row_count +'" id="cari_kontrol' + row_count +'" value=""><input type="hidden" name="cari_' + row_count +'_ship_id_list" id="cari_' + row_count +'_ship_id_list" value=""><input type="hidden" name="consumer_id' + row_count +'" id="consumer_id' + row_count +'" value="'+deger_consumer_id+'"><input type="hidden" name="company_id' + row_count +'" id="company_id' + row_count +'" value="'+deger_company_id+'"><input type="hidden" name="partner_id' + row_count +'" id="partner_id' + row_count +'" value="'+deger_partner_id+'"><input type="text" name="member_name' + row_count +'" id="member_name' + row_count +'" value="'+deger_member_name+'" readonly style="width:150px;"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick=""></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="ship_id' + row_count +'" id="ship_id' + row_count +'"><input type="text" name="ship_number' + row_count +'" id="ship_number' + row_count +'" value="" readonly  style="width:110px;"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac('+ row_count +');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="ship_deliver' + row_count +'" id="ship_deliver' + row_count +'" value="" readonly style="width:120px;"><input type="text" name="ship_date' + row_count +'" id="ship_date' + row_count +'" value="" readonly style="width:65px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="ship_type' + row_count +'" id="ship_type' + row_count +'" value="" readonly style="width:140px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="ship_adress' + row_count +'" id="ship_adress' + row_count +'" value="" readonly style="width:190px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="total_cost_value' + row_count +'" id="total_cost_value' + row_count +'" value="<cfoutput>#TlFormat(0)#</cfoutput>" style="width:70px;"></div>';
		/* maliyet2 */
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="total_cost2_value' + row_count +'" id="total_cost2_value' + row_count +'" value="<cfoutput>#TlFormat(0)#</cfoutput>" style="width:70px;"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		if(deger_row_count_list.value == '')
			deger_row_count_list.value = row_count;
		else
			deger_row_count_list.value += ','+row_count;
	}

	function add_row_other(no)
	{	
		deger_company_id = document.getElementById("company_id"+no).value;
		deger_partner_id = document.getElementById("partner_id"+no).value;
		deger_consumer_id = document.getElementById("consumer_id"+no).value;
		deger_member_name = document.getElementById("member_name"+no).value;
		deger_ship_id = document.getElementById("ship_id"+no).value;
		
		deger_cari_ship_id_list = document.getElementById("cari_" +no+ "_ship_id_list");
		
		if(deger_company_id == "" && deger_consumer_id == "")
		{
			alert(no + ".<cf_get_lang dictionary_id='45657.Satır İçin'><cf_get_lang dictionary_id='45308.Cari Hesap Seçmelisiniz'>");
			return false;
		}
		
		if(deger_ship_id == "")
		{
			alert(no + ". <cf_get_lang dictionary_id='45657.Satır İçin'><cf_get_lang dictionary_id='45483.İrsaliye Seçiniz'>!");
			return false;
		}
		
		//transport_control();/*Satır eklerkende taşıyıcıyı kontrol etsin.*/
		row_count2++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);
		newRow.setAttribute("name","frm_row_other" + row_count2);
		newRow.setAttribute("id","frm_row_other" + row_count2);		
		newRow.setAttribute("NAME","frm_row_other" + row_count2);
		newRow.setAttribute("ID","frm_row_other" + row_count2);		
		document.getElementById("record_num_other").value=row_count2;
	
		newCell = newRow.insertCell(newRow.cells.length)
		newCell.innerHTML = '<input type="hidden" name="row_count_other' + row_count2 +'" id="row_count_other' + row_count2 +'" value="'+no+'"><input type="hidden" name="ship_result_package_id' + row_count2 +'" id="ship_result_package_id' + row_count2 +'" value=""><input type="hidden" name="row_kontrol_other' + row_count2 +'" id="row_kontrol_other' + row_count2 +'" value="1"><a style="cursor:pointer" onclick="sil_other(' + row_count2 + ');"><i class="fa fa-minus" title="Sil"></i></a>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="consumer_id_other' + row_count2 +'" id="consumer_id_other' + row_count2 +'" value="'+deger_consumer_id+'"><input type="hidden" name="company_id_other' + row_count2 +'" id="company_id_other' + row_count2 +'" value="'+deger_company_id+'"><input type="hidden" name="partner_id_other' + row_count2 +'" id="partner_id_other' + row_count2 +'" value="'+deger_partner_id+'"><input type="text" name="member_name_other' + row_count2 +'" id="member_name_other' + row_count2 +'" value="'+deger_member_name+'" readonly>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="quantity' + row_count2 +'" id="quantity' + row_count2 +'" onblur="degistir( ' + row_count2 + ');" onKeyup="return(FormatCurrency(this,event,0));" value="<cfoutput>#tlformat(1,0)#</cfoutput>" class="moneybox" style="width:40px;">';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="package_type' + row_count2 +'" id="package_type' + row_count2 +'" onchange="degistir( ' + row_count2 + ');" style="width:130px;"><option value="">Seçiniz</option><cfoutput query="get_package_type"><option value="#package_type_id#,#dimention#,#calculate_type_id#">#package_type#</option></cfoutput></select>'; //add_general_prom();
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="ship_ebat' + row_count2 +'" id="ship_ebat' + row_count2 +'" value="" readonly style="width:90px;">';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="ship_agirlik' + row_count2 +'" id="ship_agirlik' + row_count2 +'" value="" onBlur="degistir(' + row_count2 + ');" onKeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:75px;">';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="total_price' + row_count2 +'" id="total_price' + row_count2 +'" value="" onKeyup="return(FormatCurrency(this,event));" class="moneybox" readonly style="width:75px;"><input type="hidden" name="other_money' + row_count2 +'" id="other_money' + row_count2 +'" value="" class="moneybox" readonly style="width:50px;"><input type="text" name="ship_barcod' + row_count2 +'" id="ship_barcod' + row_count2 +'" value="" style="width:120px;">';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="pack_emp_id' + row_count2 +'" id="pack_emp_id' + row_count2 +'" value=""><input type="text" name="pack_emp_name' + row_count2 +'" id="pack_emp_name' + row_count2 +'" value="" style="width:150px;"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac2('+ row_count2 +');"></span></div></div>';
	
		if(deger_cari_ship_id_list.value == '')
			deger_cari_ship_id_list.value = row_count2;
		else
			deger_cari_ship_id_list.value += ','+row_count2;
	}

	function degistir(id)
	{
		//Coklu satir mantigi icin eklendi ship_id_list degerine ulasmak icin
		temp_row_count_other = document.getElementById("row_count_other"+id).value;
		var ship_id_list = document.getElementById("cari_"+temp_row_count_other+"_ship_id_list").value;
	
		price_sum = 0;
		if(document.upd_packet_ship.calculate_type[1].checked)
		{
			
			for(ii=1;ii<=list_len(ship_id_list);ii++)
			{
				//hangi satırdaki paketler hesaplamaya dahil edilecek
				var ii_ = list_getat(ship_id_list,ii);
				if(document.getElementById("row_kontrol_other"+ii_).value == 1)
				{
					var temp_package_type = document.getElementById("package_type"+ii_);
					var temp_ship_ebat = document.getElementById("ship_ebat"+ii_);
					var temp_total_price = document.getElementById("total_price"+ii_);
					var temp_quantity = document.getElementById("quantity"+ii_);
					var temp_other_money = document.getElementById("other_money"+ii_);
					var temp_ship_agirlik = document.getElementById("ship_agirlik"+ii_);
					
					if(trim(document.getElementById("quantity"+ii_).value).length == 0)
						document.getElementById("quantity"+ii_).value = 1;
					
					temp_desi = list_getat(temp_package_type.value,2,',');
					temp_package_type_id = list_getat(temp_package_type.value,3,',');
					if(temp_package_type_id==1) //Desi
					{
						temp_ship_ebat.value = temp_desi;
						temp_ship_agirlik.value = '';
						desi_1 = list_getat(temp_desi,1,'*');
						desi_2 = list_getat(temp_desi,2,'*');
						desi_3 = list_getat(temp_desi,3,'*');
						desi_hesap = (parseInt(desi_1)*parseInt(desi_2)*parseInt(desi_3)/3000);
						if(desi_hesap < document.getElementById("max_limit").value)
						{
							var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value + "*" + desi_hesap;
							var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
						}
						else
						{
							var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("max_limit").value + "*" + document.getElementById("max_limit").value;
							var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
						}
					}
					else if(temp_package_type_id==2) 
					{	
						temp_ship_ebat.value = '';
						if(trim(temp_ship_agirlik.value).length == 0)
							temp_ship_agirlik.value = 1;
						temp_ship_agirlik_ = parseFloat(filterNum(temp_ship_agirlik.value))*parseFloat(temp_quantity.value);
						if(temp_ship_agirlik_>document.getElementById("max_limit").value)
							temp_ship_agirlik_ = Math.ceil(temp_ship_agirlik_);
						if(temp_ship_agirlik.value !="" && temp_ship_agirlik.value !=0)
						{
							if(temp_ship_agirlik_<document.getElementById("max_limit").value)
							{
								var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value + "*" + temp_ship_agirlik_;
								var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
							}
							else
							{
								var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value + "*" + document.getElementById("max_limit").value;
								var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
							}
						}	
					}	
					else if(temp_package_type_id==3)  //Zarf ise
					{
						var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value;
						var GET_PRICE = wrk_safe_query("stk_GET_PRICE_2",'dsn',0,listParam);
					}
					
					if(GET_PRICE != undefined)
					{
						if(GET_PRICE.recordcount==0)
						{
							alert("<cf_get_lang dictionary_id='45648.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma  Paket Tipini Kontrol Ediniz (Fiyat Listesi)'>!");
							temp_ship_ebat.value = "";
							temp_total_price.value = "";
							temp_other_money.value = "";
						}
						else
						{
							if(temp_package_type_id==1)//Desi ise
							{
								temp_ship_agirlik.value = "";
								if(desi_hesap<document.getElementById("max_limit").value)
								{
									temp_total_price.value = commaSplit(GET_PRICE.PRICE*temp_quantity.value);/*Toplam atanıyor.*/
									price_sum += parseFloat((GET_PRICE.PRICE*temp_quantity.value));
								}
								else
								{
									var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30','dsn',0,document.getElementById("transport_comp_id").value);
									desi_remain = parseFloat((parseInt(desi_1)*parseInt(desi_2)*parseInt(desi_3))/(3000)-<cfoutput>document.getElementById("max_limit").value</cfoutput>);
									temp_total_price.value = commaSplit(parseFloat(GET_PRICE.PRICE*temp_quantity.value)+parseFloat(GET_PRICE_30.PRICE*desi_remain*temp_quantity.value));
									price_sum += parseFloat(GET_PRICE.PRICE*temp_quantity.value)+parseFloat(GET_PRICE_30.PRICE*desi_remain*temp_quantity.value);
									
								}
							}
							if(temp_package_type_id==2)//Kg ise
							{
								temp_ship_ebat.value = "";
								if(trim(temp_ship_agirlik.value).length == 0)
									temp_ship_agirlik.value = 1;							
								if(temp_ship_agirlik_<document.getElementById("max_limit").value)
								{
									price_sum += parseFloat(GET_PRICE.PRICE);
								}
								else
								{
									var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30','dsn',0,document.getElementById("transport_comp_id").value);
									kg_remain = parseFloat(temp_ship_agirlik_-document.getElementById("max_limit").value);
									temp_total_price.value = commaSplit(parseFloat(GET_PRICE.PRICE)+parseFloat(GET_PRICE_30.PRICE*kg_remain));
									price_sum += parseFloat(GET_PRICE.PRICE)+parseFloat(GET_PRICE_30.PRICE*kg_remain);
								}
							}				
							
							else if(temp_package_type_id==3)//Zarf ise
							{
								temp_ship_agirlik = '';
								temp_ship_ebat.value = '';
								temp_total_price.value = commaSplit(parseFloat(GET_PRICE.PRICE) * parseFloat(temp_quantity.value));
								price_sum += parseFloat(GET_PRICE.PRICE) * parseFloat(temp_quantity.value);
							}
							temp_other_money.value = GET_PRICE.OTHER_MONEY;
						}
					}
					else
					{
						temp_total_price.value = "";
						temp_other_money.value = "";	
					}
				}
			}
			document.getElementById("total_cost_value"+temp_row_count_other).value = commaSplit(price_sum);
			var temp2_sira = list_find(money_list,<cfoutput>'#session.ep.money2#'</cfoutput>); 
			var temp2_rate1 = list_getat(rate1_list,temp2_sira);
			var temp2_rate2 = list_getat(rate2_list,temp2_sira);
			var total_cost2_value = price_sum * (parseFloat(temp2_rate1) / parseFloat(temp2_rate2));
			document.getElementById("total_cost2_value"+temp_row_count_other).value = commaSplit(total_cost2_value);
		}
		else
		{
			count_desi = 0;
			count_kg = 0;
			count_envelope = 0;
			desi_sum = 0;
			kg_sum = 0;
			desi_price_sum = 0;
			kg_price_sum = 0;
			envelope_price_sum = 0;
			
			for(ii=1;ii<=list_len(ship_id_list);ii++)
			{
				//hangi satırdaki paketler hesaplamaya dahil edilecek
				var ii_ = list_getat(ship_id_list,ii);
				if(document.getElementById("row_kontrol_other"+ii_).value == 1)
				{
					var temp_quantity = document.getElementById('quantity'+ii_);
					var temp_package_type = document.getElementById('package_type'+ii_);
					var temp_ship_ebat = document.getElementById('ship_ebat'+ii_);
					var temp_ship_agirlik = document.getElementById('ship_agirlik'+ii_);
					
					if(trim(document.getElementById("quantity"+ii_).value).length == 0)
						document.getElementById("quantity"+ii_).value = 1;
	
					var temp_desi = list_getat(temp_package_type.value,2,',');
					var temp_package_type_id = list_getat(temp_package_type.value,3,',');
	
					if(temp_package_type_id==1) //Desi
					{
						count_desi += 1;
						temp_ship_ebat.value = temp_desi;
						temp_ship_agirlik.value = '';
						desi_1 = list_getat(temp_desi,1,'*');
						desi_2 = list_getat(temp_desi,2,'*');
						desi_3 = list_getat(temp_desi,3,'*');
						desi_hesap = (parseInt(desi_1)*parseInt(desi_2)*parseInt(desi_3)/3000*parseFloat(temp_quantity.value));
						desi_sum +=desi_hesap;
					}
					else if(temp_package_type_id==2)//Kg
					{
						count_kg += 1;
						temp_ship_ebat.value = "";
						if(trim(document.getElementById("ship_agirlik"+ii_).value).length == 0)
							document.getElementById("ship_agirlik"+ii_).value = 1;
						temp_ship_agirlik_ = filterNum(temp_ship_agirlik.value);
						if(temp_ship_agirlik.value != "" && temp_ship_agirlik.value !=0)
							kg_sum +=parseFloat(temp_ship_agirlik_)*parseFloat(temp_quantity.value);
					}	
					else if(temp_package_type_id==3)//Zarf ise
					{
						count_envelope += 1;
						temp_ship_agirlik.value = '';
						temp_ship_ebat.value = '';
						var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value;
						var GET_PRICE3 = wrk_safe_query("stk_GET_PRICE_2",'dsn',0,listParam);
						if(GET_PRICE3 != undefined)
						{
							if(GET_PRICE3.recordcount==0)
								alert("<cf_get_lang dictionary_id='45650.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma  Paket Tipini(Desi) Kontrol Ediniz (Fiyat Listesi)'>!");
							else
								envelope_price_sum += GET_PRICE3.PRICE * parseFloat(temp_quantity.value);
						}					
					}
				}
			}
			
			if(count_desi != 0)
			{
				
				if(desi_sum<document.getElementById("max_limit").value)
				{
					var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value + "*" + desi_sum;				
					var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
				}
				else
				{
					var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value + "*" + document.getElementById("max_limit").value;
					var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
				}
				
				if(GET_PRICE1 != undefined)
				{
					if(GET_PRICE1.recordcount==0)
						alert("<cf_get_lang dictionary_id='45650.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma  Paket Tipini(Desi) Kontrol Ediniz (Fiyat Listesi)'>!");
					else
					{
						if(desi_sum<document.getElementById("max_limit").value)
						{
							desi_price_sum = GET_PRICE1.PRICE;
						}
						else
						{					
							var GET_PRICE_30 = wrk_safe_query("stk_GET_PRICE_3",'dsn',0,document.getElementById("transport_comp_id").value);
							desi_remain2 = parseFloat(desi_sum-document.getElementById("max_limit").value);
							desi_price_sum = parseFloat(GET_PRICE1.PRICE)+parseFloat(GET_PRICE_30.PRICE*desi_remain2);
						}
					}
				}
			}
			
			if(count_kg != 0)

			{
	
				if(kg_sum<document.getElementById("max_limit").value)
				{
					var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value + "*" + kg_sum;
					var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
				}
				else
				{
					var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value + "*" + document.getElementById("max_limit").value;
					var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
				}
				
				if(GET_PRICE1 != undefined)
				{
					if(GET_PRICE1.recordcount==0)
						alert("<cf_get_lang dictionary_id='45651.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma  Paket Tipini(Kg) Kontrol Ediniz (Fiyat Listesi)'>!");
					else
					{
						if(kg_sum<document.getElementById("max_limit").value)
							kg_price_sum = GET_PRICE1.PRICE;
						else
						{	
							var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30_2','dsn',0,document.getElementById("transport_comp_id").value);
							kg_remain2 = parseFloat(kg_sum-document.getElementById("max_limit").value);
							kg_remain2 = Math.ceil(kg_remain2);
							kg_price_sum = parseFloat(GET_PRICE1.PRICE)+parseFloat(GET_PRICE_30.PRICE*kg_remain2);
						}
					}
				}
			}
	
			document.getElementById("total_cost_value"+temp_row_count_other).value = commaSplit(parseFloat(desi_price_sum)+parseFloat(kg_price_sum)+parseFloat(envelope_price_sum));
		}
		return kur_hesapla();
	}
	function fiyat_hesapla(satir)
	{
		if(trim(document.getElementById("quantity"+satir).value).length == 0)
			document.getElementById("quantity"+satir).value = 1;
		
		if(document.getElementById("price"+satir).value.length != 0)
			document.getElementById("total_price"+satir).value = commaSplit(filterNum(document.getElementById("quantity"+satir).value) * filterNum(document.getElementById("price"+satir).value));
			
		return kur_hesapla();
	}
</cfif>

function control()
{
	<cfif x_equipment_planning_info eq 1><!--- siparis bazli sevkiyat calisirsa --->
		if(document.getElementById("equipment_planning").value == '')
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='58870.Ekip - Araç'>!");
			return false;
		}
		if(document.getElementById("department_name").value == '' || document.getElementById("department_id").value == '')
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='58763.Depo'>!");
			return false;
		}
		//duzenlenecek sorun olabilir
		if(process_cat_control())
			return row_all_control(5);
		else
			return false;
	
	<cfelse>
		if(document.getElementById("options_kontrol").value==0 || document.getElementById("options_kontrol").value == "")
		{	
			alert("<cf_get_lang dictionary_id='45659.Lütfen Tasıyıcı Firmayı Kontrol Ediniz. Bu Cari İçin Fiyat Listesi Tanımlı Değil'>!");
			return false;
		}
		if(document.getElementById("ship_method_id").value == "")	
		{
			alert("<cf_get_lang dictionary_id='45482.Lütfen Sevk Yöntemi Seçiniz'> !");
			return false;
		}
		if(document.getElementById("transport_comp_id").value == "")	
		{
			alert("<cf_get_lang dictionary_id='45495.Taşıyıcı Seçiniz'>!");
			return false;
		}	
		if(kontrol_row_count == 0)
		{
			alert("<cf_get_lang dictionary_id='45661.En Az Bir Satır İrsaliye Kaydı Giriniz'>!");
			return false;
		}	
	
		temp_satir=0;	
		for(cr=1;cr<=upd_packet_ship.record_num.value;cr++)
		{
			deger_row_kontrol = document.getElementById("row_kontrol"+cr).value;
			deger_company_id = document.getElementById("company_id"+cr).value;
			deger_consumer_id = document.getElementById("consumer_id"+cr).value;
			deger_ship_id = document.getElementById("ship_id"+cr).value;
			deger_cari_kontrol = document.getElementById("cari_kontrol"+cr).value;
			if(deger_row_kontrol == 1)
			{
				temp_satir++;
				if(deger_company_id=="" && deger_consumer_id=="")
				{
					alert(temp_satir + ".<cf_get_lang dictionary_id='45657.Satır İçin'><cf_get_lang dictionary_id='45308.Cari Hesap Seçmelisiniz'>");
					return false;
				}
				if(deger_ship_id == "")
				{
					alert(temp_satir + ".<cf_get_lang dictionary_id='45657.Satır İçin'> <cf_get_lang dictionary_id='45483.İrsaliye Seçiniz'>!");
					return false;
				}
				if(deger_cari_kontrol != "")
				{
					alert(temp_satir + ".<cf_get_lang dictionary_id='45662.Satır İçin Cari Değerini Kontrol Ediniz'>!");
					return false;
				}			
			}
		}
		
		// Paket kontrolleri
		for(r=1;r<=upd_packet_ship.record_num_other.value;r++)
		{
			deger_row_kontrol_other = document.getElementById("row_kontrol_other"+r);
			deger_package_type = document.getElementById("package_type"+r);
			if(deger_row_kontrol_other.value == 1)
			{
				if(deger_package_type.value == "")
				{
					alert("<cf_get_lang dictionary_id='45484.Lütfen Paket Tipi Giriniz'>!");
					return false;
				}
			}
		}
		
	</cfif>
	return ( unformat_fields());
	return true;
}

<cfif x_equipment_planning_info eq 0>
	function kur_hesapla()
	{
		total_cost_value = 0;
		if(document.upd_packet_ship.calculate_type[1].checked)
		{		
			for(r=1;r<=upd_packet_ship.record_num_other.value;r++)
			{				
				if(document.getElementById("row_kontrol_other"+r).value == 1)
				{
					var temp_other_money =document.getElementById("other_money"+r);
					var temp_total_price = document.getElementById("total_price"+r);
					
					if(temp_total_price.value != '')
					{
						temp_sira = list_find(money_list,temp_other_money.value);	
						temp_rate1 = list_getat(rate1_list,temp_sira);
						temp_rate2 = list_getat(rate2_list,temp_sira);
						temp_deger = parseFloat(parseFloat(filterNum(temp_total_price.value)) / ((parseFloat(temp_rate1) / parseFloat(temp_rate2))));
						total_cost_value = parseFloat(total_cost_value) + parseFloat(temp_deger);
					}
				}
			}
			temp2_sira = list_find(money_list,<cfoutput>'#session.ep.money2#'</cfoutput>); 
			temp2_rate1 = list_getat(rate1_list,temp2_sira);
			temp2_rate2 = list_getat(rate2_list,temp2_sira);
			total_cost2_value = total_cost_value * (parseFloat(temp2_rate1) / parseFloat(temp2_rate2));
			document.getElementById("total_cost_value").value = commaSplit(total_cost_value);
			document.getElementById("total_cost2_value").value = commaSplit(total_cost2_value);
		}
		else
		{
			for(rk=1;rk<=document.getElementById("record_num").value;rk++)
			{
				
				temp2_sira = list_find(money_list,<cfoutput>'#session.ep.money2#'</cfoutput>); 
				temp2_rate1 = list_getat(rate1_list,temp2_sira);
				temp2_rate2 = list_getat(rate2_list,temp2_sira);
				temp_total_cost_value = document.getElementById("total_cost_value"+rk).value;
				total_cost2_value = parseFloat(filterNum(temp_total_cost_value)) * ((parseFloat(temp2_rate1) / parseFloat(temp2_rate2)));
				document.getElementById("total_cost2_value"+rk).value = commaSplit(total_cost2_value);
			}
		}
		
		sum_total_cost_value = 0;
		sum_total_cost2_value = 0;
		
		for(r=1;r<=upd_packet_ship.record_num.value;r++)
		{
			if(document.getElementById("row_kontrol"+r).value == 1)
			{
				var temp =document.getElementById("total_cost_value"+r);
				var temp2 =document.getElementById("total_cost2_value"+r);
				temp_total_cost_value = filterNum(temp.value);
				temp_total_cost2_value = filterNum(temp2.value);
		
				sum_total_cost_value = sum_total_cost_value+temp_total_cost_value;
				sum_total_cost2_value = sum_total_cost2_value+temp_total_cost2_value;
			}		
		}
		
		upd_packet_ship.total_cost_value.value = commaSplit(sum_total_cost_value);
		upd_packet_ship.total_cost2_value.value = commaSplit(sum_total_cost2_value);
	
		return true;
	}
	
	function change_packet(calculate_type_value)
	{
		if(row_count2!=0)
		{
			if(calculate_type_deger!=calculate_type_value)
			{
				if(calculate_type_value == 2)/*Satır ise*/
				{
					for(r=1;r<=upd_packet_ship.record_num_other.value;r++)
					{
						if(document.getElementById("row_kontrol_other"+r).value == 1)
						{
							document.getElementById("package_type"+r).value = '';
							document.getElementById("ship_ebat"+r).value = '';
							document.getElementById("ship_agirlik"+r).value = '';
							document.getElementById("total_price"+r).value = '';
							document.getElementById("other_money"+r).value = '';
						}
					}
					document.getElementById("total_cost_value").value = commaSplit(0);
					document.getElementById("total_cost2_value").value = commaSplit(0);				
				}
				else
				{
					degistir(1);
				}
			}
		}
		calculate_type_deger = calculate_type_value;
		return true;
	}
</cfif>

function unformat_fields()
{
	<cfif x_equipment_planning_info eq 0>
		for(r=1;r<=document.getElementById("record_num_other").value;r++)
		{
			if(document.getElementById("row_kontrol_other"+r).value == 1)
			{
				document.getElementById("quantity"+r).value = filterNum(document.getElementById("quantity"+r).value);
				document.getElementById("ship_agirlik"+r).value = filterNum(document.getElementById("ship_agirlik"+r).value);
				document.getElementById("total_price"+r).value = filterNum(document.getElementById("total_price"+r).value);
			}
		}
		for(kr=1;kr<=document.getElementById("record_num").value;kr++)
		{
			if(document.getElementById("row_kontrol"+kr).value == 1)
			{
				document.getElementById("total_cost_value"+kr).value = filterNum(document.getElementById("total_cost_value"+kr).value);
				document.getElementById("total_cost2_value"+kr).value = filterNum(document.getElementById("total_cost2_value"+kr).value);
			}
		}
	<cfelse>
		for(ow=1;ow<=document.getElementById("record_num").value;ow++)
		{
			if(document.getElementById("row_kontrol"+ow).value == 1)
				document.getElementById("order_row_amount_"+ow).value = filterNum(document.getElementById("order_row_amount_"+ow).value);
		}
	</cfif>	
}
function kontrol_prerecord()
{
	<cfif x_equipment_planning_info eq 0>
	if(document.getElementById("transport_comp_id").value != "")
	{
		var GET_MAX_LIMIT = wrk_safe_query('stk_get_max_limit','dsn',0,document.getElementById("transport_comp_id").value);//Seçilen taşıyıcıya ait yapılmış bir tanımlama değeri varsa.
		if(GET_MAX_LIMIT.recordcount > 0)
		{
			document.getElementById("max_limit").value=GET_MAX_LIMIT.MAX_LIMIT;
			if(GET_MAX_LIMIT.CALCULATE_TYPE==1)
			{
				document.upd_packet_ship.calculate_type[0].checked = true;
				document.getElementById("options_kontrol").value=1;/*Form'u kontrol etmek için,*/
			}
			else if	(GET_MAX_LIMIT.CALCULATE_TYPE==2)
			{
				document.upd_packet_ship.calculate_type[1].checked=true;
				document.getElementById("options_kontrol").value=1;/*Form'u kontrol etmek için,*/
			}

			for(xx=1;xx<=document.getElementById("record_num_other").value;xx++)
			{
				deger_row_kontrol_other = document.getElementById("row_kontrol_other"+xx);
				if(deger_row_kontrol_other.value == 1)
					degistir(xx);
			}
		}
		else		
		{
			alert("<cf_get_lang dictionary_id='45663.Lütfen Hesaplama için Tasıyıcı Firmayı Kontrol Ediniz (Fiyat Listesi)'>!");
			document.upd_packet_ship.calculate_type[0].checked=false;
			document.upd_packet_ship.calculate_type[1].checked=false;
			document.getElementById("options_kontrol").value=0;
			document.getElementById("max_limit").value=0;
			return false;	
		}
	}
	</cfif>
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
