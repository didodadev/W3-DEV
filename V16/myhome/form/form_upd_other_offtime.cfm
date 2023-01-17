<cfset attributes.offtime_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.offtime_id,accountKey:'wrk') />
<cfif (isDefined('attributes.offtime_id') and (not len(attributes.offtime_id)))>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1531.Boyle Bir Kayıt Bulunmamaktadir'>!");
		window.close(); 
	</script>
	<cfabort>
</cfif>
<cfquery name="get_my_pos" datasource="#dsn#">
	SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid#
</cfquery>
<cfset my_pos_list = valuelist(get_my_pos.POSITION_CODE)>
<!---İzinde olan kişilerin vekalet bilgileri alınıypr --->
<cfquery name="Get_Offtime_Valid" datasource="#dsn#">
	SELECT
		O.EMPLOYEE_ID,
		EP.POSITION_CODE
	FROM
		OFFTIME O,
		EMPLOYEE_POSITIONS EP
	WHERE
		O.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
		O.VALID = 1 AND
		#Now()# BETWEEN O.STARTDATE AND O.FINISHDATE
</cfquery>
<cfif Get_Offtime_Valid.recordcount>
	<cfset Now_Offtime_PosCode = ValueList(Get_Offtime_Valid.Position_Code)>
	<cfquery name="Get_StandBy_Position1" datasource="#dsn#"><!--- Asil Kisi Izinli ise ve 1.Yedek Izinli Degilse --->
		SELECT POSITION_CODE, CANDIDATE_POS_1 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN(#my_pos_list#)
	</cfquery>
	<cfoutput query="Get_StandBy_Position1">
		<cfset my_pos_list = ListAppend(my_pos_list,ValueList(Get_StandBy_Position1.Position_Code))>
	</cfoutput>
	<cfquery name="Get_StandBy_Position2" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek Izinli ise ve 2.Yedek Izinli Degilse --->
		SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_2 IN (#my_pos_list#)
	</cfquery>
	<cfoutput query="Get_StandBy_Position2">
		<cfset my_pos_list = ListAppend(my_pos_list,ValueList(Get_StandBy_Position2.Position_Code))>
	</cfoutput>
	<cfquery name="Get_StandBy_Position3" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek,2.Yedek Izinli ise ve 3.Yedek Izinli Degilse --->
		SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_2 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_3 IN (#my_pos_list#)
	</cfquery>
	<cfoutput query="Get_StandBy_Position3">
		<cfset my_pos_list = ListAppend(my_pos_list,ValueList(Get_StandBy_Position3.Position_Code))>
	</cfoutput>
</cfif>
<cfset pageHead = #getLang('myhome',166)# >
<cf_catalystHeader>
<cfinclude template="../query/get_offtime.cfm">
<cfif len(get_offtime.startdate)>
  <cfset start_=date_add('h',session.ep.time_zone,get_offtime.startdate)>
<cfelse>
	<cfset start_="">
</cfif>
<cfif len(get_offtime.finishdate)>
  <cfset end_=date_add('h',session.ep.time_zone,get_offtime.finishdate)>
<cfelse>
	<cfset end_="">
</cfif>
<cfif len(get_offtime.work_startdate)>
  <cfset work_startdate=date_add('h',session.ep.time_zone,get_offtime.work_startdate)>
<cfelse>
	 <cfset work_startdate="">
</cfif>
<cfparam name="attributes.employee_id" default="#get_offtime.employee_id#">
<cfset getEmp = CreateObject("component","V16.hr.cfc.get_employee")>
<cfset empInformations = getEmp.get_employee(emp_id:attributes.employee_id)>
<style>
	p{
		text-align:right;
		padding:5px;
	}
	.date{
		color:#555d63;
		padding:10px;
		padding-left:5px;
		font-size:13px;
	}
</style>
<div class="col col-9 col-md-8 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="offtime_request" method="post" action="">
			<input type="hidden" name="offtime_id" id="offtime_id" value="<cfoutput>#get_offtime.offtime_id#</cfoutput>">
			<input type="hidden" name="valid_1" id="valid_1" value="">
			<input type="hidden" name="valid_2" id="valid_2" value="">
			<div class="ui-form-list" type="row">
				<div class="col col-6 col-md-12 col-sm-12 col-xs-12"  type="column" index="1" sort="true">
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id = '58859.Süreç'></label>
						<div class="col col-8 col-xs-12">    
							<cf_workcube_process select_value ="#get_offtime.offtime_stage#" is_detail='1' is_upd="0" action_id="#attributes.offtime_id#">    
						</div>
					</div>
					<div class="form-group" id="item-emp_name">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='164.Calışan'></label>
						<div class="col col-8 col-xs-12"> 
							<input type="text" name = "employee" value = "<cfoutput>#get_emp_info(get_offtime.employee_id,0,0)#</cfoutput>" readonly>
						</div>
					</div>
					<div class="form-group" id="item-GET_OFFTIME_CATS">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='74.Kategori'></label>
						<div class="col col-8 col-xs-12"> 
							<input  type="text" name = "GET_OFFTIME_CATS" value = "<cfoutput>#get_offtime.NEW_CAT_NAME#</cfoutput>" readonly>
						</div>
					</div>
					<div class="form-group" id="item-startdate">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='89.Başlama'></label>
						<div class="col col-8 col-xs-12"> 
						<input  type="text" name = "startdate" value = "<cfif len(start_)><cfoutput>#dateformat(start_,dateformat_style)# (#timeformat(start_,timeformat_style)#)</cfoutput></cfif>" readonly>
						</div>
					</div>
					<div class="form-group" id="item-finishdate">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='90.Bitiş'></label>
						<div class="col col-8 col-xs-12"> 
							<input  type="text" name = "finishdate" value = "<cfif len(end_)><cfoutput>#dateformat(end_,dateformat_style)# (#timeformat(end_,timeformat_style)#)</cfoutput></cfif>" readonly>
						</div>
					</div>
					<div class="form-group" id="item-work_startdate">
						<label class="col col-4 col-xs-12"><cf_get_lang no='396.İşe Başlama'></label>
						<div class="col col-8 col-xs-12"> 
							<input  type="text" name = "finishdate" value = "<cfif len(work_startdate)><cfoutput>#dateformat(work_startdate,dateformat_style)# (#timeformat(work_startdate,timeformat_style)#)</cfoutput></cfif>" readonly>
						</div>
					</div>
					<div class="form-group" id="item-tel_no">
						<label class="col col-4 col-xs-12"><cf_get_lang no='397.İzinde Ulaşılacak Telefon'></label>							
						<div class="col col-8 col-xs-12">
							<input  type="text" name = "tel_no" value = "<cfoutput>#get_offtime.tel_code# #get_offtime.tel_no#</cfoutput>" readonly>
						</div>
					</div>
					<div class="form-group" id="item-address">
						<label class="col col-4 col-xs-12"><cf_get_lang no='398.İzinde Geçirilecek Adres'></label>
						<div class="col col-8 col-xs-12"> 
							<input  type="text" name = "address" value = "<cfoutput>#get_offtime.address#</cfoutput>" readonly>
						</div>
					</div>
					<div class="form-group" id="item-detail">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
						<div class="col col-8 col-xs-12"> 
							<input  type="text" name = "address" value = "<cfoutput>#get_offtime.detail#</cfoutput>" readonly>
						</div>
					</div>
				</div>
			</div>
			<cf_box_footer>
				<div class="col col-6"><cf_record_info query_name="get_offtime"></div>
				<div class="col col-6"><cf_workcube_buttons is_upd='1' is_delete="0"></div>
			</cf_box_footer>
			
		</cfform>
	</cf_box>
</div>
<div class="col col-3 col-md-4 col-sm-12 col-xs-12">
	<cf_box>
		<cfoutput query="empInformations">
			<div class="profile-userpic text-center">
				<cfif len(PHOTO)>
					<img class="img-circle" src="/documents/hr/#PHOTO#" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#">
				<cfelseif SEX eq 1>
					<img class="img-circle" src="/images/maleicon.jpg" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#">
				<cfelse>
					<img class="img-circle" src="/images/femaleicon.jpg" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#">
				</cfif>
				<div class="profile-usertitle-name">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</div>
				<div class="profile-usertitle-job">#POSITION_NAME#</div>
				<div class="profile-usertitle-job"><small>#DEPARTMENT_HEAD#</small></div>
			</div>
		</cfoutput>
	</cf_box>
	<cf_box title="#getLang('contract',344,'İzin Hakedişleri')#" closable="0" collapsable="0">
		<label class="col col-6 date text-left">
			<cf_get_lang dictionary_id="58472.Dönem">
		</label>
		<label class="col col-6 date text-right"><cfoutput>#session.ep.period_year#</cfoutput></label>
		
		<cfinclude  template="../display/offtimes_dashboard.cfm">
	</cf_box>
</div>