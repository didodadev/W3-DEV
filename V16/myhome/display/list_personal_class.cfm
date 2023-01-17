<!--- listenin aynısı training dede var--->
<!---- katalog/katalog dısı egitim talepleri--->
<cfparam name="attributes.keyword" default="">
<cfquery name="GET_TRAINING_JOIN_REQUESTS" datasource="#dsn#">
	SELECT
		TR.TRAIN_REQUEST_ID,
		TR.START_DATE,
		TR.FINISH_DATE,
		TR.REQUEST_TYPE,
		(SELECT DISTINCT TRAIN_HEAD FROM TRAINING T,TRAINING_REQUEST_ROWS TRR WHERE T.TRAIN_ID = TRR.TRAINING_ID AND TRR.TRAIN_REQUEST_ID =TR.TRAIN_REQUEST_ID ) AS TRAIN_HEAD,
		(SELECT DISTINCT OTHER_TRAIN_NAME FROM TRAINING_REQUEST_ROWS TRR WHERE TRR.TRAIN_REQUEST_ID =TR.TRAIN_REQUEST_ID ) AS OTHER_TRAIN_NAME,
		TR.PROCESS_STAGE,
		TR.EMPLOYEE_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		TR.RECORD_DATE,
		TR.REQUEST_TYPE,
		TR.EMP_VALIDDATE
	FROM 
		TRAINING_REQUEST TR
		INNER JOIN EMPLOYEES E
		ON TR.EMPLOYEE_ID = E.EMPLOYEE_ID
	WHERE
		TR.EMPLOYEE_ID = #session.ep.userid# AND 
		TR.REQUEST_TYPE IN(1,2)  <!--- katalog ve katalog disi egitimleri getir--->		
		<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
		AND
		(
			E.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.KEYWORD#%"> OR
			E.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.KEYWORD#%">
		)
		</cfif>
	ORDER BY
		TR.RECORD_DATE DESC,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME 
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_training_join_requests.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif fusebox.circuit is "report"><!---onay raporu özel rapor icin bu kontrol eklendi --->
	<cfset adres_ = "myhome">
<cfelse>
	<cfset adres_ = fusebox.circuit> 
</cfif>
<cfquery name="get_all_positions" datasource="#dsn#">
	SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid#
</cfquery>
<cfset pos_code_list = valuelist(get_all_positions.position_code)>
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
		SELECT POSITION_CODE, CANDIDATE_POS_1 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN(#pos_code_list#)
	</cfquery>
	<cfoutput query="Get_StandBy_Position1">
		<cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position1.Position_Code))>
	</cfoutput>
	<cfquery name="Get_StandBy_Position2" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek Izinli ise ve 2.Yedek Izinli Degilse --->
		SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_2 IN (#pos_code_list#)
	</cfquery>
	<cfoutput query="Get_StandBy_Position2">
		<cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position2.Position_Code))>
	</cfoutput>
	<cfquery name="Get_StandBy_Position3" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek,2.Yedek Izinli ise ve 3.Yedek Izinli Degilse --->
		SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_2 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_3 IN (#pos_code_list#)
	</cfquery>
	<cfoutput query="Get_StandBy_Position3">
		<cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position3.Position_Code))>
	</cfoutput>
</cfif>
<!--- <cfform name="form1" method="post" action="">
  <cf_box>
		<div class="row form-inline">
			<div class="form-group" id="item-keyword">
				<div class="input-group x-12">
					<cfinput type="text" name="keyword" maxlength="50" value="#attributes.keyword#" placeholder="#getLang('main','48')#">
				</div>
			</div>		
		<div class="form-group x-3_5">
			<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
			<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
		</div>
		<div class="form-group">
			<cf_wrk_search_button>
		</div>
			<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> 
		</div>
	</cf_box>
</cfform> --->

<cfsavecontent variable="message"><cf_get_lang dictionary_id='31017.Eğitim Talepleri'></cfsavecontent>
<cf_box title="#message#" closable="0" add_href="?fuseaction=#adres_#.list_my_tranings&event=add">
	<cf_ajax_list>
		<div class="extra_list">
			<thead>
				<tr> 
					<th><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
					<th><cf_get_lang dictionary_id="31090.Eğitimin Adı"></th>
					<th><cf_get_lang dictionary_id='31023.Talep Tarihi'></th>
					<th><cf_get_lang dictionary_id="57756.Durum"></th>
					<th width="20"><a href="<cfoutput>#request.self#?fuseaction=#adres_#.list_my_tranings&event=add</cfoutput>"><i class="fa fa-plus"></i></a></th>
		<!--- 			<th class="header_icn_none" style="text-align:right;"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=#adres_#</cfoutput>.popup_form_add_training_request','list')"><img src="/images/plus_list.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>"></a></th>
		 --->		</tr>
			</thead>
			<tbody>
				<cfif get_training_join_requests.recordcount>
					<cfset stage_id_list=''>
					<cfoutput query="get_training_join_requests" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
						<cfif len(process_stage) and not listfind(stage_id_list,process_stage)>
							<cfset stage_id_list = Listappend(stage_id_list,process_stage)>
						</cfif>
					</cfoutput>
					<cfif len(stage_id_list)>
						<cfset stage_id_list=listsort(stage_id_list,"numeric","ASC",",")>
						<cfquery name="get_content_process_stage" datasource="#DSN#">
							SELECT PROCESS_ROW_ID, STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#stage_id_list#">) ORDER BY PROCESS_ROW_ID
						</cfquery>
						<cfset stage_id_list = listsort(listdeleteduplicates(valuelist(get_content_process_stage.process_row_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfoutput query="get_training_join_requests" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
						<tr>
							<td width="35">#currentrow#</td>
							<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_emp&emp_id=#employee_id#','project');" class="tableyazi">#employee_name# #employee_surname#</a></td>
							<td>
								<cfif request_type eq 1>
									#train_head# (<cf_get_lang dictionary_id="31096.Katalog">)</font>
								<cfelse>
									#other_train_name# (<cf_get_lang dictionary_id="31102.Katalog Dışı">)
								</cfif>
							</td>
							<td>#dateformat(RECORD_DATE,dateformat_style)#</td>
							<td>#get_content_process_stage.stage[listfind(stage_id_list,process_stage,',')]#</td>
							<td style="text-align:right;">
								<cfif fusebox.circuit eq 'myhome'>
									<cfset TRAIN_REQUEST_ID_ = contentEncryptingandDecodingAES(isEncode:1,content:TRAIN_REQUEST_ID,accountKey:session.ep.userid)>
								<cfelse>
									<cfset TRAIN_REQUEST_ID_ = TRAIN_REQUEST_ID>
								</cfif>
								<cfif len(emp_validdate)><!--- çalışan onay--->
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#adres_#.popup_dsp_training_request_form&train_req_id=#TRAIN_REQUEST_ID_#','list')" ><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
								<cfelse>
									<a href="#request.self#?fuseaction=#adres_#.list_my_tranings&event=upd&train_req_id=#TRAIN_REQUEST_ID_#" ><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
								</cfif>
							</td>
						</tr>
					</cfoutput> 
					<cfelse>
						<tr> 
							<td colspan="9"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
						</tr>
				</cfif>
			</tbody>
		</div>
	</cf_ajax_list>
</cf_box> 

<cfset adres = "">
<cfif fusebox.circuit is "myhome">
    <cfset adres = "myhome.list_class_request">
</cfif>
<cfif fusebox.circuit is "training">
    <cfset adres = "training.list_class_request">
</cfif>
<cfif len(attributes.keyword)>
    <cfset adres = "#adres#&keyword=#attributes.keyword#">
</cfif>
<cf_paging
    page="#attributes.page#" 
    maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
    adres="#adres#">
<!--- Yıllık Eğitim Talepleri--->
<cfquery name="get_training_request" datasource="#dsn#">
	SELECT
		TRAIN_REQUEST_ID,
		REQUEST_YEAR,
		RECORD_DATE,
		PROCESS_STAGE,
		EMP_VALID_ID,
		EMP_VALIDDATE
	FROM
		TRAINING_REQUEST
	WHERE
		EMPLOYEE_ID = #session.ep.userid# AND
		REQUEST_TYPE = 3 <!--- yıllık eğitim talebi--->
	ORDER BY
		RECORD_DATE DESC
</cfquery>


<cfsavecontent variable="message"><cf_get_lang dictionary_id='31108.Yıllık Eğitim Talepleri'></cfsavecontent>
<cf_box title="#message#" closable="0" add_href="?fuseaction=training.popup_form_add_training_request_annual">
	<cf_ajax_list>
		<div class="extra_list">
			<thead>
				<tr> 
					<th><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id="58472.Dönem"></th>
					<th><cf_get_lang dictionary_id='31023.Talep Tarihi'></th>
					<th><cf_get_lang dictionary_id="57756.Durum"></th>
		<!--- 			<th class="header_icn_none" style="text-align:right;"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=training.popup_form_add_training_request_annual','list')"><img src="/images/plus_list.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>"></a></th>
		 --->		</tr>
			</thead>
			<tbody>
				<cfif get_training_request.recordcount>
					<cfset stage_id_list=''>
					<cfoutput query="get_training_request" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
						<cfif len(process_stage) and not listfind(stage_id_list,process_stage)>
							<cfset stage_id_list = Listappend(stage_id_list,process_stage)>
						</cfif>
					</cfoutput>
					<cfif len(stage_id_list)>
						<cfset stage_id_list=listsort(stage_id_list,"numeric","ASC",",")>
						<cfquery name="get_content_process_stage" datasource="#DSN#">
							SELECT PROCESS_ROW_ID, STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#stage_id_list#">) ORDER BY PROCESS_ROW_ID
						</cfquery>
						<cfset stage_id_list = listsort(listdeleteduplicates(valuelist(get_content_process_stage.process_row_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfoutput query="get_training_request"> 
						<tr>
							<td width="35">#currentrow#</td>
							<td>#REQUEST_YEAR#</td>
							<td>#dateformat(RECORD_DATE,dateformat_style)#</td>
							<td>#get_content_process_stage.stage[listfind(stage_id_list,process_stage,',')]#</td>
							<td style="text-align:right;">
								<cfif fusebox.circuit eq 'myhome'>
									<cfset TRAIN_REQUEST_ID_ = contentEncryptingandDecodingAES(isEncode:1,content:TRAIN_REQUEST_ID,accountKey:session.ep.userid)>
								<cfelse>
									<cfset TRAIN_REQUEST_ID_ = TRAIN_REQUEST_ID>
								</cfif>
								<cfif len(emp_validdate)>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=training.popup_dsp_training_request_annual&train_req_id=#TRAIN_REQUEST_ID_#&fbx=myhome','list')"><img src="/images/update_list.gif" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></a>
								<cfelse>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=training.popup_form_upd_training_request_annual&train_req_id=#TRAIN_REQUEST_ID_#&fbx=myhome','list')"><img src="/images/update_list.gif" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></a>
								</cfif>
							</td>
						</tr>
					</cfoutput> 
				<cfelse>
					<tr> 
						<td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
			</tbody>
		</div>
	</cf_ajax_list>
</cf_box>

<!--- onay bekleyen talepler--->
<cfquery name="get_valid_request" datasource="#dsn#">
	SELECT
		TRAIN_REQUEST_ID,
		REQUEST_YEAR,
		RECORD_DATE,
		PROCESS_STAGE,
		REQUEST_TYPE,
		START_DATE,
		FINISH_DATE,
		EMPLOYEE_ID
	FROM
		TRAINING_REQUEST
	WHERE
		(
			(FIRST_BOSS_CODE IN(#pos_code_list#) AND FIRST_BOSS_VALID_DATE IS NULL AND EMP_VALIDDATE IS NOT NULL) OR <!--- çalışan onayladıysa ve 1.amir oanyında bekliyor ise--->
			(SECOND_BOSS_CODE IN(#pos_code_list#) AND SECOND_BOSS_VALID_DATE IS NULL AND FIRST_BOSS_VALID_DATE IS NOT NULL AND FIRST_BOSS_VALID = 1) OR <!--- 1.amir onayladıysa ve 2.amir onayı bekleniyor ise--->
			(FOURTH_BOSS_CODE IN(#pos_code_list#) AND FOURTH_BOSS_VALID_DATE IS NULL AND THIRD_BOSS_VALID_DATE IS NOT NULL AND THIRD_BOSS_VALID = 1) <!--- IK onayı verildiyse 4.yonetici onaylayacak--->
		)
	ORDER BY
		RECORD_DATE DESC
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='46127.Onay Bekleyenler'></cfsavecontent>
<cf_box title="#message#" closable="0">
	<cf_ajax_list>
		<div class="extra_list">
			<thead>
				<tr> 
					<th><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id="57630.Tip"></th>
					<th><cf_get_lang dictionary_id="30829.Talep Eden"></th>
					<th><cf_get_lang dictionary_id="58472.Dönem"></th>
					<th><cf_get_lang dictionary_id='31023.Talep Tarihi'></th>
					<th><cf_get_lang dictionary_id="57756.Durum"></th>
					<th></th>
				</tr>
			</thead>
			<tbody>
				<cfset stage_id_list=''>
				<cfoutput query="get_valid_request" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
					<cfif len(process_stage) and not listfind(stage_id_list,process_stage)>
						<cfset stage_id_list = Listappend(stage_id_list,process_stage)>
					</cfif>
				</cfoutput>
				<cfif len(stage_id_list)>
					<cfset stage_id_list=listsort(stage_id_list,"numeric","ASC",",")>
					<cfquery name="get_content_process_stage" datasource="#DSN#">
						SELECT PROCESS_ROW_ID, STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#stage_id_list#">) ORDER BY PROCESS_ROW_ID
					</cfquery>
					<cfset stage_id_list = listsort(listdeleteduplicates(valuelist(get_content_process_stage.process_row_id,',')),'numeric','ASC',',')>
				</cfif>
				<cfif get_valid_request.recordcount>
					<cfoutput query="get_valid_request">
						<tr>
							<td width="35">#currentrow#</td>
							<td><cfif request_type eq 1><cf_get_lang dictionary_id="31096.Katalog"><cfelseif request_type eq 2><cf_get_lang dictionary_id="31102.Katalog Dışı"><cfelseif request_type eq 3><cf_get_lang dictionary_id="29400.Yıllık"></cfif></td>
							<td>#get_emp_info(employee_id,0,0)#</td>
							<td><cfif request_type eq 3>#request_year#<cfelse>#dateformat(start_date,dateformat_style)#-#dateformat(finish_date,dateformat_style)#</cfif></td>
							<td>#dateformat(record_date,dateformat_style)#</td>
							<td>#get_content_process_stage.stage[listfind(stage_id_list,process_stage,',')]#</td>
							<td class="header_icn_none" style="text-align:right;">
								<cfif fusebox.circuit eq 'myhome'>
									<cfset TRAIN_REQUEST_ID_ = contentEncryptingandDecodingAES(isEncode:1,content:TRAIN_REQUEST_ID,accountKey:session.ep.userid)>
								<cfelse>
									<cfset TRAIN_REQUEST_ID_ = TRAIN_REQUEST_ID>
								</cfif>
								<cfif request_type eq 3>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#adres_#.popup_form_upd_training_request_annual&train_req_id=#TRAIN_REQUEST_ID#','list')"><img src="/images/update_list.gif" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></a>
								<cfelse>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#adres_#.popup_form_upd_training_request&train_req_id=#TRAIN_REQUEST_ID_#','list')"><img src="/images/update_list.gif" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></a>
								</cfif>
							</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
			</tbody>
	  </div>
	</cf_ajax_list>
</cf_box>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>