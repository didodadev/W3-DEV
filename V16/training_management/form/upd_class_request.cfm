<cfquery name="get_emp_pos" datasource="#dsn#">
	SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=#session.ep.userid#
</cfquery>
<cfset position_list=valuelist(get_emp_pos.POSITION_CODE,',')>
<cfquery name="get_trains_all" datasource="#dsn#">
		SELECT
			TRR.REQUEST_ROW_ID,
			TR.TRAIN_REQUEST_ID,
			TR.EMPLOYEE_ID,
			TR.POSITION_CODE,
			TR.REQUEST_YEAR,
			TRAINING_PRIORITY,
			WORK_TARGET_ADDITION,
			TR.FIRST_BOSS_ID,
			TR.FIRST_BOSS_CODE,
			TR.FIRST_BOSS_VALID,
			TR.SECOND_BOSS_ID,
			TR.SECOND_BOSS_CODE,
			TR.SECOND_BOSS_VALID,
			TR.THIRD_BOSS_ID,
			TR.THIRD_BOSS_CODE,
			TR.THIRD_BOSS_VALID,
			TR.FOURTH_BOSS_ID,
			TR.FOURTH_BOSS_CODE,	
			TR.FOURTH_BOSS_VALID,
			TR.FIFTH_BOSS_ID,
			TR.FIFTH_BOSS_CODE,	
			TR.FIFTH_BOSS_VALID,			
			TR.RECORD_EMP,
			TR.RECORD_DATE,
			TR.UPDATE_DATE,
			TR.UPDATE_EMP,
			TRR.REQUEST_TYPE,
			TRR.REQUEST_STATUS,
			TRR.CLASS_ID,
			TC.CLASS_TARGET,
			TC.CLASS_OBJECTIVE,
			TC.CLASS_NAME,
			TRR.FIRST_BOSS_VALID_ROW,
			TRR.FIRST_BOSS_DATE_ROW,
			TRR.FIRST_BOSS_DETAIL_ROW,
			TRR.SECOND_BOSS_VALID_ROW,
			TRR.SECOND_BOSS_DATE_ROW,
			TRR.SECOND_BOSS_DETAIL_ROW,
			TRR.THIRD_BOSS_VALID_ROW,
			TRR.THIRD_BOSS_DATE_ROW,
			TRR.THIRD_BOSS_DETAIL_ROW,
			TRR.FOURTH_BOSS_VALID_ROW,
			TRR.FOURTH_BOSS_DATE_ROW,
			TRR.FOURTH_BOSS_DETAIL_ROW,
			TRR.FIFTH_BOSS_VALID_ROW,
			TRR.FIFTH_BOSS_DATE_ROW,
			TRR.FIFTH_BOSS_DETAIL_ROW
		FROM 
			TRAINING_REQUEST TR,
			TRAINING_REQUEST_ROWS TRR,
			TRAINING_CLASS TC
		WHERE 
			TR.TRAIN_REQUEST_ID=#attributes.train_req_id# AND
			TRR.TRAIN_REQUEST_ID=TR.TRAIN_REQUEST_ID AND
			TC.CLASS_ID=TRR.CLASS_ID AND
			TRR.CLASS_ID IS NOT NULL
			<cfif not session.ep.ehesap>
			AND (
				TR.FIRST_BOSS_CODE IN (#position_list#) OR
				TR.SECOND_BOSS_CODE IN (#position_list#) OR
				TR.THIRD_BOSS_CODE IN (#position_list#) OR
				TR.FOURTH_BOSS_CODE IN (#position_list#) OR
				TR.FIFTH_BOSS_CODE IN (#position_list#)
				)
			</cfif>
	UNION ALL
		SELECT
			TRR.REQUEST_ROW_ID,
			TR.TRAIN_REQUEST_ID,
			TR.EMPLOYEE_ID,
			TR.POSITION_CODE,
			TR.REQUEST_YEAR,
			TRAINING_PRIORITY,
			WORK_TARGET_ADDITION,
			TR.FIRST_BOSS_ID,
			TR.FIRST_BOSS_CODE,	
			TR.FIRST_BOSS_VALID,
			TR.SECOND_BOSS_ID,
			TR.SECOND_BOSS_CODE,
			TR.SECOND_BOSS_VALID,
			TR.THIRD_BOSS_ID,
			TR.THIRD_BOSS_CODE,	
			TR.THIRD_BOSS_VALID,
			TR.FOURTH_BOSS_ID,
			TR.FOURTH_BOSS_CODE,	
			TR.FOURTH_BOSS_VALID,
			TR.FIFTH_BOSS_ID,
			TR.FIFTH_BOSS_CODE,	
			TR.FIFTH_BOSS_VALID,					
			TR.RECORD_EMP,
			TR.RECORD_DATE,
			TR.UPDATE_DATE,
			TR.UPDATE_EMP,
			TRR.REQUEST_TYPE,
			TRR.REQUEST_STATUS,
			0 CLASS_ID,
			NULL CLASS_TARGET,
			NULL CLASS_OBJECTIVE,
			OTHER_TRAIN_NAME CLASS_NAME,
			TRR.FIRST_BOSS_VALID_ROW,
			TRR.FIRST_BOSS_DATE_ROW,
			TRR.FIRST_BOSS_DETAIL_ROW,
			TRR.SECOND_BOSS_VALID_ROW,
			TRR.SECOND_BOSS_DATE_ROW,
			TRR.SECOND_BOSS_DETAIL_ROW,
			TRR.THIRD_BOSS_VALID_ROW,
			TRR.THIRD_BOSS_DATE_ROW,
			TRR.THIRD_BOSS_DETAIL_ROW,
			TRR.FOURTH_BOSS_VALID_ROW,
			TRR.FOURTH_BOSS_DATE_ROW,
			TRR.FOURTH_BOSS_DETAIL_ROW,
			TRR.FIFTH_BOSS_VALID_ROW,
			TRR.FIFTH_BOSS_DATE_ROW,
			TRR.FIFTH_BOSS_DETAIL_ROW
		FROM 
			TRAINING_REQUEST TR,
			TRAINING_REQUEST_ROWS TRR
		WHERE
			TR.TRAIN_REQUEST_ID=#attributes.train_req_id# AND
			TRR.TRAIN_REQUEST_ID=TR.TRAIN_REQUEST_ID
			AND CLASS_ID IS NULL
			AND TRR.TRAINING_ID IS NULL
			<cfif not session.ep.ehesap>
			AND (
				TR.FIRST_BOSS_CODE IN (#position_list#) OR
				TR.SECOND_BOSS_CODE IN (#position_list#) OR
				TR.THIRD_BOSS_CODE IN (#position_list#) OR
				TR.FOURTH_BOSS_CODE IN (#position_list#) OR
				TR.FIFTH_BOSS_CODE IN (#position_list#)
				)
			</cfif>
	UNION ALL
		SELECT
			TRR.REQUEST_ROW_ID,
			TR.TRAIN_REQUEST_ID,
			TR.EMPLOYEE_ID,
			TR.POSITION_CODE,
			TR.REQUEST_YEAR,
			TRAINING_PRIORITY,
			WORK_TARGET_ADDITION,
			TR.FIRST_BOSS_ID,
			TR.FIRST_BOSS_CODE,	
			TR.FIRST_BOSS_VALID,
			TR.SECOND_BOSS_ID,
			TR.SECOND_BOSS_CODE,
			TR.SECOND_BOSS_VALID,
			TR.THIRD_BOSS_ID,
			TR.THIRD_BOSS_CODE,	
			TR.THIRD_BOSS_VALID,
			TR.FOURTH_BOSS_ID,
			TR.FOURTH_BOSS_CODE,	
			TR.FOURTH_BOSS_VALID,
			TR.FIFTH_BOSS_ID,
			TR.FIFTH_BOSS_CODE,	
			TR.FIFTH_BOSS_VALID,					
			TR.RECORD_EMP,
			TR.RECORD_DATE,
			TR.UPDATE_DATE,
			TR.UPDATE_EMP,
			TRR.REQUEST_TYPE,
			TRR.REQUEST_STATUS,
			0 CLASS_ID,
			NULL CLASS_TARGET,
			NULL CLASS_OBJECTIVE,
			T.TRAIN_HEAD,
			TRR.FIRST_BOSS_VALID_ROW,
			TRR.FIRST_BOSS_DATE_ROW,
			TRR.FIRST_BOSS_DETAIL_ROW,
			TRR.SECOND_BOSS_VALID_ROW,
			TRR.SECOND_BOSS_DATE_ROW,
			TRR.SECOND_BOSS_DETAIL_ROW,
			TRR.THIRD_BOSS_VALID_ROW,
			TRR.THIRD_BOSS_DATE_ROW,
			TRR.THIRD_BOSS_DETAIL_ROW,
			TRR.FOURTH_BOSS_VALID_ROW,
			TRR.FOURTH_BOSS_DATE_ROW,
			TRR.FOURTH_BOSS_DETAIL_ROW,
			TRR.FIFTH_BOSS_VALID_ROW,
			TRR.FIFTH_BOSS_DATE_ROW,
			TRR.FIFTH_BOSS_DETAIL_ROW
		FROM 
			TRAINING_REQUEST TR,
			TRAINING_REQUEST_ROWS TRR,
			TRAINING T
		WHERE 
			TR.EMPLOYEE_ID=#session.ep.userid# AND
			TR.TRAIN_REQUEST_ID=#attributes.train_req_id# AND
			TRR.TRAIN_REQUEST_ID=TR.TRAIN_REQUEST_ID AND
			T.TRAIN_ID=TRR.TRAINING_ID AND
			TRR.TRAINING_ID IS NOT NULL	
			<cfif not session.ep.ehesap>
			AND (
				TR.FIRST_BOSS_CODE IN (#position_list#) OR
				TR.SECOND_BOSS_CODE IN (#position_list#) OR
				TR.THIRD_BOSS_CODE IN (#position_list#) OR
				TR.FOURTH_BOSS_CODE IN (#position_list#) OR
				TR.FIFTH_BOSS_CODE IN (#position_list#)
				)
			</cfif>
</cfquery>
<cfif not get_trains_all.recordcount>
	<script type="text/javascript">
		alert('Eğitim Talepleri Silinmiş Veya Yetkiniz Yok!');
		history.go(-1);
	</script>
	<cfabort>
</cfif>

<cfquery name="get_trains_standart" dbtype="query">
	SELECT * FROM get_trains_all WHERE REQUEST_TYPE = 1
</cfquery>
<cfquery name="get_trains_required" dbtype="query">
	SELECT * FROM get_trains_all WHERE REQUEST_TYPE = 2
</cfquery>
<cfquery name="get_trains_pos_req" dbtype="query">
	SELECT * FROM get_trains_all WHERE REQUEST_TYPE = 3
</cfquery>
<cfquery name="get_trains_tech" dbtype="query">
	SELECT * FROM get_trains_all WHERE REQUEST_TYPE = 4
</cfquery>
<!--- formu goruntuleyen kisini kacinci amir oldugunu buluyor--->
<cfset amir=0>
<cfif listfind(position_list,get_trains_all.FIRST_BOSS_CODE,',')>
	<cfset amir=1>
<cfelseif listfind(position_list,get_trains_all.SECOND_BOSS_CODE,',')>
	<cfset amir=2>
<cfelseif listfind(position_list,get_trains_all.THIRD_BOSS_CODE,',')>
	<cfset amir=3>
<cfelseif listfind(position_list,get_trains_all.FOURTH_BOSS_CODE,',')>
	<cfset amir=4>
<cfelseif listfind(position_list,get_trains_all.FIFTH_BOSS_CODE,',')>
	<cfset amir=5>
</cfif>

<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
  <tr>
	<td class="headbold">Eğitim Talep Formu : <cfoutput>#get_emp_info(get_trains_all.EMPLOYEE_ID,0,0)# - #get_trains_all.REQUEST_YEAR#</cfoutput></td>
	<td width="15">
		<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#get_trains_all.employee_id#</cfoutput>','project');" class="tableyazi"><img src="/images/quiz_paper.gif" title="Geçmiş Eğitimler" border="0"></a> 
	</td>
	<cfif get_module_user(3)>
		<cfquery name="get_perf" datasource="#dsn#">
			SELECT
				EPT.PER_ID
			FROM 
				EMPLOYEE_PERFORMANCE_TARGET EPT,
				EMPLOYEE_PERFORMANCE EP
			WHERE 
				EP.EMP_ID=#get_trains_all.employee_id# AND YEAR(START_DATE)=#get_trains_all.REQUEST_YEAR#
				AND EP.PER_ID=EPT.PER_ID
		</cfquery>
		<cfif get_perf.recordcount>
			<td width="15">
				<a href="<cfoutput>#request.self#?fuseaction=hr.upd_target_plan_forms&per_id=#GET_PERF.PER_ID#</cfoutput>" class="tableyazi"><img src="/images/quiz.gif" title="Hedef Yetkinlik Değerlendirme Formu" border="0"></a> 
			</td>
		</cfif>
	</cfif>
	<cfif session.ep.ehesap>
	<td width="15">
		<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=training_management.popup_upd_class_request_boss&train_req_id=#attributes.train_req_id#</cfoutput>','small');"><img src="/images/family.gif" title="Amirler" border="0"></a>
	</td>
	</cfif>
  </tr>
</table>
<table width="98%" border="0" cellspacing="0" cellpadding="0" height="35" align="center">
	<tr>
	  <td class="headbold">Standart Eğitimler</td>
	</tr>
</table>
<table width="98%" border="0"  cellspacing="0" cellpadding="0" align="center">
<cfform name="add_class_request" method="post" action="#request.self#?fuseaction=training_management.emptypopup_upd_class_request">
<input type="hidden" name="train_req_id" id="train_req_id" value="<cfoutput>#get_trains_all.TRAIN_REQUEST_ID#</cfoutput>">
<input type="hidden" name="amir" id="amir" value="<cfoutput>#amir#</cfoutput>">
<tr class="color-border">
  <td>
	<table width="100%" border="0" height="100%" cellspacing="1" cellpadding="2">
	  <tr class="color-header" height="22">
		<td class="form-title" width="15">No</td>
		<td class="form-title" width="200">Eğitim Adı</td>
		<td class="form-title" width="200">Eğitim Amacı</td>
		<td class="form-title" width="200">Eğitim İçeriği</td>
	  </tr>
	<input type="hidden" name="record_num_standart" id="record_num_standart" value="<cfoutput>#get_trains_standart.recordcount#</cfoutput>">
	<cfif get_trains_standart.recordcount>
	<cfoutput query="get_trains_standart">
		  <tr class="color-row" height="20">
			<input type="hidden" name="class_id_required#currentrow#" id="class_id_required#currentrow#" value="#CLASS_ID#">
			<td>#currentrow#</td>
			<td><a href="#request.self#?fuseaction=training_management.form_upd_class&class_id=#CLASS_ID#" class="tableyazi">#CLASS_NAME#</a></td>
			<td>#CLASS_TARGET#</td>
			<td>#CLASS_OBJECTIVE#</td>
		  </tr>
	</cfoutput> 
		<cfelse>
		  <tr class="color-row" height="20">
			<td colspan="5">Kayıt Yok</td>
		  </tr>
		</cfif>
	</table>
  </td>
</tr>
</table>
<br/>
<table width="98%" border="0" cellspacing="0" cellpadding="0" height="35" align="center">
<tr>
  <td class="headbold">Zorunlu Eğitimler</td>
</tr>
</table>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr class="color-border">
  <td>
	<table width="100%" border="0" height="100%" cellspacing="1" cellpadding="2">
	  <tr class="color-header" height="22">
		<td class="form-title" width="15">No</td>
		<td class="form-title" width="200">Eğitim Adı</td>
		<td class="form-title" width="200">Eğitim Amacı</td>
		<td class="form-title" width="200">Eğitim İçeriği</td>
	  </tr>
		<input type="hidden" name="record_num_required" id="record_num_required" value="<cfoutput>#get_trains_required.recordcount#</cfoutput>">
		<cfif get_trains_required.recordcount>
		<cfoutput query="get_trains_required">
		  <tr class="color-row" height="20">
			<input type="hidden" name="class_id_required#currentrow#" id="class_id_required#currentrow#" value="#CLASS_ID#">
			<td>#currentrow#</td>
			<td><a href="#request.self#?fuseaction=training_management.form_upd_class&class_id=#CLASS_ID#" class="tableyazi">#CLASS_NAME#</a></td>
			<td>#CLASS_TARGET#</td>
			<td>#CLASS_OBJECTIVE#</td>
		  </tr>
		</cfoutput> 
		<cfelse>
		  <tr class="color-row" height="20">
			<td colspan="5">Kayıt Yok</td>
		  </tr>
		</cfif>
	</table>
  </td>
</tr>
</table>
<br/>
<table width="98%" border="0" cellspacing="0" cellpadding="0" height="35" align="center">
<tr>
  <td class="headbold">Yetkinlik Gelişim Eğitimleri</td>
</tr>
</table>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" id="table_pos_req">
<input type="hidden" name="record_num_pos_req" id="record_num_pos_req" value="<cfoutput>#get_trains_pos_req.recordcount#</cfoutput>">
<tr class="color-border">
  <td>
	<table width="100%" border="0" height="100%" cellspacing="1" cellpadding="2" id="tablo_2">
	  <tr class="color-header" >
		<td class="form-title">Eğitim Adı</td>
		<td class="form-title" width="250">Öncellik</td>
		<td class="form-title" width="250">İş Hedefine Katkısı</td>
		<td width="15"><input type="button" class="eklebuton" title="" onClick="add_row_pos_req();"></td>
	  </tr>
	  <cfif get_trains_pos_req.recordcount>
		<cfoutput query="get_trains_pos_req">
	  <tr id="frm_row_pos_req#currentrow#" name="frm_row_pos_req#currentrow#" class="color-list">
		<input type="hidden" name="train_req_row_id_pos_req#currentrow#" id="train_req_row_id_pos_req#currentrow#" value="#REQUEST_ROW_ID#">
		<input type="hidden" name="class_id_pos_req#currentrow#" id="class_id_pos_req#currentrow#" value="#CLASS_ID#">
		<input  type="hidden"  value="1"  name="row_kontrol_pos_req#currentrow#" id="row_kontrol_pos_req#currentrow#">
		<input type="hidden" name="class_name_pos_req#currentrow#" id="class_name_pos_req#currentrow#" value="#CLASS_NAME#">
		<td>#CLASS_NAME#</td>
		<td><input type="text" name="priority_pos_req#currentrow#" id="priority_pos_req#currentrow#" value="#TRAINING_PRIORITY#" maxlength="150" style="width:250px;"></td>
		<td><input type="text" name="work_addition_pos_req#currentrow#" id="work_addition_pos_req#currentrow#" value="#WORK_TARGET_ADDITION#" maxlength="150" style="width:250px;"></td>
		<td><!--- <a style="cursor:pointer" onclick="sil_pos_req(#currentrow#);"><img  src="/images/delete_list.gif" border="0"></a> ---></td>
	  </tr>
	  <tr class="color-row">
		<td colspan="4">
		
		<table cellpadding="0" cellspacing="0" width="100%">
		  <tr>
			<td></td>
			<td class="txtboldblue" width="200">1. Amir</td>
			<td class="txtboldblue" width="200">2. Amir</td>
			<td class="txtboldblue" width="200">3. Amir</td>
			<td class="txtboldblue" width="200">4. Amir</td>
			<td class="txtboldblue" width="200">5. Amir</td>
		  </tr>
		  <tr>
			<td class="txtboldblue">Çalışan</td>
			<td><cfif FIRST_BOSS_VALID eq 1>#get_emp_info(FIRST_BOSS_ID,0,0)#<cfelse>#get_emp_info(FIRST_BOSS_CODE,1,0)#</cfif></td>
			<td><cfif SECOND_BOSS_VALID eq 1>#get_emp_info(SECOND_BOSS_ID,0,0)#<cfelse>#get_emp_info(SECOND_BOSS_CODE,1,0)#</cfif></td>
			<td><cfif THIRD_BOSS_VALID eq 1>#get_emp_info(THIRD_BOSS_ID,0,0)#<cfelse>#get_emp_info(THIRD_BOSS_CODE,1,0)#</cfif></td>
			<td><cfif FOURTH_BOSS_VALID eq 1>#get_emp_info(FOURTH_BOSS_ID,0,0)#<cfelse>#get_emp_info(FOURTH_BOSS_CODE,1,0)#</cfif></td>
			<td><cfif FIFTH_BOSS_VALID eq 1>#get_emp_info(FIFTH_BOSS_ID,0,0)#<cfelse>#get_emp_info(FIFTH_BOSS_CODE,1,0)#</cfif></td>
		  </tr>
		  <tr>
			<td class="txtboldblue">Durum</td>
			<td>
				<cfif amir eq 1 and not len(SECOND_BOSS_VALID_ROW)>
					Onay <input type="checkbox" name="first_boss_pos_req#currentrow#" id="first_boss_pos_req#currentrow#" <cfif FIRST_BOSS_VALID_ROW eq 1 or not len(FIRST_BOSS_VALID_ROW)>checked</cfif>> #dateformat(FIRST_BOSS_DATE_ROW,dateformat_style)#
				<cfelseif FIRST_BOSS_VALID_ROW eq 1>
					Onaylandı (#dateformat(FIRST_BOSS_DATE_ROW,dateformat_style)#)
				<cfelseif FIRST_BOSS_VALID_ROW eq 0>
					Rededildi (#dateformat(FIRST_BOSS_DATE_ROW,dateformat_style)#)
				<cfelse>
					Bekliyor
				</cfif>
			</td>
			<td>
				<cfif amir eq 2 and not len(THIRD_BOSS_VALID_ROW)>
					Onay <input type="checkbox" name="second_boss_pos_req#currentrow#" id="second_boss_pos_req#currentrow#" <cfif SECOND_BOSS_VALID_ROW eq 1 or (not len(SECOND_BOSS_VALID_ROW) and FIRST_BOSS_VALID_ROW eq 1)>checked</cfif>>
				<cfelseif SECOND_BOSS_VALID_ROW eq 1>
					Onaylandı (#dateformat(SECOND_BOSS_DATE_ROW,dateformat_style)#)
				<cfelseif SECOND_BOSS_VALID_ROW eq 0>
					Rededildi (#dateformat(SECOND_BOSS_DATE_ROW,dateformat_style)#)
				<cfelse>
					Bekliyor
				</cfif>
			</td>
			<td>
				<cfif amir eq 3 and not len(FOURTH_BOSS_VALID_ROW)>
					Onay <input type="checkbox" name="third_boss_pos_req#currentrow#" id="third_boss_pos_req#currentrow#" <cfif THIRD_BOSS_VALID_ROW eq 1 or (not len(THIRD_BOSS_VALID_ROW) and SECOND_BOSS_VALID_ROW eq 1)>checked</cfif>> #dateformat(THIRD_BOSS_DATE_ROW,dateformat_style)#
				<cfelseif THIRD_BOSS_VALID_ROW eq 1>
					Onaylandı (#dateformat(THIRD_BOSS_DATE_ROW,dateformat_style)#)
				<cfelseif THIRD_BOSS_VALID_ROW eq 0>
					Rededildi (#dateformat(THIRD_BOSS_DATE_ROW,dateformat_style)#)
				<cfelse>
					Bekliyor
				</cfif>
			</td>
			<td>
				<cfif amir eq 4 and not len(FIFTH_BOSS_VALID_ROW)>
					Onay <input type="checkbox" name="fourth_boss_pos_req#currentrow#" id="fourth_boss_pos_req#currentrow#" <cfif FOURTH_BOSS_VALID_ROW eq 1 or (not len(FOURTH_BOSS_VALID_ROW) and THIRD_BOSS_VALID_ROW eq 1)>checked</cfif>> #dateformat(FOURTH_BOSS_DATE_ROW,dateformat_style)#
				<cfelseif FOURTH_BOSS_VALID_ROW eq 1>
					Onaylandı (#dateformat(FOURTH_BOSS_DATE_ROW,dateformat_style)#)
				<cfelseif FOURTH_BOSS_VALID_ROW eq 0>
					Rededildi (#dateformat(FOURTH_BOSS_DATE_ROW,dateformat_style)#)
				<cfelse>
					Bekliyor
				</cfif>
			</td>
			<td>
				<cfif amir eq 5>
					Onay <input type="checkbox" name="fifth_boss_pos_req#currentrow#" id="fifth_boss_pos_req#currentrow#" <cfif FIFTH_BOSS_VALID_ROW eq 1 or (not len(FIFTH_BOSS_VALID_ROW) and FOURTH_BOSS_VALID_ROW eq 1)>checked</cfif>> #dateformat(FIFTH_BOSS_DATE_ROW,dateformat_style)#
				<cfelseif FIFTH_BOSS_VALID_ROW eq 1>
					Onaylandı (#dateformat(FIFTH_BOSS_DATE_ROW,dateformat_style)#)
				<cfelseif FIFTH_BOSS_VALID_ROW eq 0>
					Rededildi (#dateformat(FIFTH_BOSS_DATE_ROW,dateformat_style)#)
				<cfelse>
					Bekliyor
				</cfif>					
			</td>
		  </tr>
		  <tr class="color-row">
			<td class="txtboldblue">Açıklama</td>
			<td>
			<cfif amir eq 1>
				<input type="text" name="first_boss_detail_pos_req#currentrow#" id="first_boss_detail_pos_req#currentrow#" value="#FIRST_BOSS_DETAIL_ROW#" style="width:180px" maxlength="250">
			<cfelse>
				#FIRST_BOSS_DETAIL_ROW#
			</cfif>
			</td>
			<td>
			<cfif amir eq 2>
				<input type="text" name="second_boss_detail_pos_req#currentrow#" id="second_boss_detail_pos_req#currentrow#" value="#SECOND_BOSS_DETAIL_ROW#" style="width:180px" maxlength="250">
			<cfelse>
				#SECOND_BOSS_DETAIL_ROW#
			</cfif>
			</td>
			<td>
			<cfif amir eq 3>
				<input type="text" name="third_boss_detail_pos_req#currentrow#" id="third_boss_detail_pos_req#currentrow#" value="#THIRD_BOSS_DETAIL_ROW#" style="width:180px" maxlength="250">
			<cfelse>
				#THIRD_BOSS_DETAIL_ROW#
			</cfif>
			</td>
			<td>
			<cfif amir eq 4>
				<input type="text" name="fourth_boss_detail_pos_req#currentrow#" id="fourth_boss_detail_pos_req#currentrow#" value="#FOURTH_BOSS_DETAIL_ROW#" style="width:180px" maxlength="250">
			<cfelse>
				#FOURTH_BOSS_DETAIL_ROW#
			</cfif>
			</td>
			<td>
			<cfif amir eq 5>
				<input type="text" name="fifth_boss_detail_pos_req#currentrow#" id="fifth_boss_detail_pos_req#currentrow#" value="#FIFTH_BOSS_DETAIL_ROW#" style="width:180px" maxlength="250">
			<cfelse>
				#FIFTH_BOSS_DETAIL_ROW#
			</cfif>					
			</td>
		  </tr>
		</table>
		</td>
	  </tr>
		</cfoutput>
	</cfif>
	</table>
</td>
</tr>
</table>
	
  


<br/>
<table width="98%" border="0" cellspacing="0" cellpadding="0" height="35" align="center">
<tr>
  <td class="headbold">Teknik Gelişim Eğitimleri</td>
</tr>
</table>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
<input type="hidden" name="record_num_tech" id="record_num_tech" value="<cfoutput>#get_trains_tech.recordcount#</cfoutput>">
<tr class="color-border">
  <td>
	<table width="100%" border="0" height="100%" cellspacing="1" cellpadding="2" id="tablo_1">
	  <tr class="color-header" >
		<td class="form-title">Eğitim Adı</td>
		<td class="form-title" width="250">Öncellik</td>
		<td class="form-title" width="250">İş Hedefine Katkısı</td>
		<td width="15"><input type="button" class="eklebuton" title="" onClick="add_row_tech();"></td>
	  </tr>
	  <cfif get_trains_pos_req.recordcount>
			<cfoutput query="get_trains_tech">
			  <tr id="frm_row_tech#currentrow#" name="frm_row_tech#currentrow#" class="color-list">
			  	<input type="hidden" name="train_req_row_id_tech#currentrow#" id="train_req_row_id_tech#currentrow#" value="#REQUEST_ROW_ID#">
			  	<input type="hidden" name="class_id_tech#currentrow#" id="class_id_tech#currentrow#" value="#CLASS_ID#">
				<input type="hidden" name="class_name_tech#currentrow#" id="class_name_tech#currentrow#" value="#CLASS_NAME#">
				<input  type="hidden"  value="1"  name="row_kontrol_tech#currentrow#" id="row_kontrol_tech#currentrow#">
				<td>#CLASS_NAME#</td>
				<td style="text-align:right;"><input type="text" name="priority_tech#currentrow#" id="priority_tech#currentrow#" value="#TRAINING_PRIORITY#" maxlength="150" style="width:250px;"></td>
				<td style="text-align:right;"><input type="text" name="work_addition_tech#currentrow#" id="work_addition_tech#currentrow#" value="#WORK_TARGET_ADDITION#" maxlength="150" style="width:250px;"></td>
				<td><!--- <a style="cursor:pointer" onclick="sil_pos_tech(#currentrow#);"><img  src="/images/delete_list.gif" border="0"></a> ---></td>
			  </tr>
			  <tr class="color-row">
			  	<td colspan="4">
				<table cellpadding="0" cellspacing="0" width="100%">
				  <tr class="color-list">
					<td></td>
				  	<td class="txtboldblue" width="200">1. Amir</td>
					<td class="txtboldblue" width="200">2. Amir</td>
					<td class="txtboldblue" width="200">3. Amir</td>
					<td class="txtboldblue" width="200">4. Amir</td>
					<td class="txtboldblue" width="200">5. Amir</td>
				  </tr>
				  <tr class="color-row">
				  	<td class="txtboldblue">Çalışan</td>
				  	<td><cfif FIRST_BOSS_VALID eq 1>#get_emp_info(FIRST_BOSS_ID,0,0)#<cfelse>#get_emp_info(FIRST_BOSS_CODE,1,0)#</cfif></td>
					<td><cfif SECOND_BOSS_VALID eq 1>#get_emp_info(SECOND_BOSS_ID,0,0)#<cfelse>#get_emp_info(SECOND_BOSS_CODE,1,0)#</cfif></td>
					<td><cfif THIRD_BOSS_VALID eq 1>#get_emp_info(THIRD_BOSS_ID,0,0)#<cfelse>#get_emp_info(THIRD_BOSS_CODE,1,0)#</cfif></td>
					<td><cfif FOURTH_BOSS_VALID eq 1>#get_emp_info(FOURTH_BOSS_ID,0,0)#<cfelse>#get_emp_info(FOURTH_BOSS_CODE,1,0)#</cfif></td>
					<td><cfif FIFTH_BOSS_VALID eq 1>#get_emp_info(FIFTH_BOSS_ID,0,0)#<cfelse>#get_emp_info(FIFTH_BOSS_CODE,1,0)#</cfif></td>
				  </tr>
				  <tr class="color-row">
				  	<td class="txtboldblue">Durum</td>
				  	<td>
						<cfif amir eq 1 and not len(SECOND_BOSS_VALID_ROW)>
							Onay <input type="checkbox" name="first_boss_tech#currentrow#" id="first_boss_tech#currentrow#" <cfif FIRST_BOSS_VALID_ROW eq 1 or not len(FIRST_BOSS_VALID_ROW)>checked</cfif>> #dateformat(FIRST_BOSS_DATE_ROW,dateformat_style)#
						<cfelseif FIRST_BOSS_VALID_ROW eq 1>
							Onaylandı (#dateformat(FIRST_BOSS_DATE_ROW,dateformat_style)#)
						<cfelseif FIRST_BOSS_VALID_ROW eq 0>
							Rededildi (#dateformat(FIRST_BOSS_DATE_ROW,dateformat_style)#)
						<cfelse>
							Bekliyor
						</cfif>
					</td>
					<td>
						<cfif amir eq 2 and not len(THIRD_BOSS_VALID_ROW)>
							Onay <input type="checkbox" name="second_boss_tech#currentrow#" id="second_boss_tech#currentrow#" <cfif SECOND_BOSS_VALID_ROW eq 1 or (not len(SECOND_BOSS_VALID_ROW) and FIRST_BOSS_VALID_ROW eq 1)>checked</cfif>> #dateformat(SECOND_BOSS_DATE_ROW,dateformat_style)#
						<cfelseif SECOND_BOSS_VALID_ROW eq 1>
							Onaylandı (#dateformat(SECOND_BOSS_DATE_ROW,dateformat_style)#)
						<cfelseif SECOND_BOSS_VALID_ROW eq 0>
							Rededildi (#dateformat(SECOND_BOSS_DATE_ROW,dateformat_style)#)
						<cfelse>
							Bekliyor
						</cfif>
					</td>
					<td>
						<cfif amir eq 3 and not len(FOURTH_BOSS_VALID_ROW)>
							Onay <input type="checkbox" name="third_boss_tech#currentrow#" id="third_boss_tech#currentrow#" <cfif THIRD_BOSS_VALID_ROW eq 1 or (not len(THIRD_BOSS_VALID_ROW) and THIRD_BOSS_VALID_ROW eq 1)>checked</cfif>> #dateformat(THIRD_BOSS_DATE_ROW,dateformat_style)#
						<cfelseif THIRD_BOSS_VALID_ROW eq 1>
							Onaylandı (#dateformat(THIRD_BOSS_DATE_ROW,dateformat_style)#)
						<cfelseif THIRD_BOSS_VALID_ROW eq 0>
							Rededildi (#dateformat(THIRD_BOSS_DATE_ROW,dateformat_style)#)
						<cfelse>
							Bekliyor
						</cfif>
					</td>
					<td>
						<cfif amir eq 4 and not len(FIFTH_BOSS_VALID_ROW)>
							Onay <input type="checkbox" name="fourth_boss_tech#currentrow#" id="fourth_boss_tech#currentrow#" <cfif FOURTH_BOSS_VALID_ROW eq 1 or (not len(FOURTH_BOSS_VALID_ROW) and FOURTH_BOSS_VALID_ROW eq 1)>checked</cfif>> #dateformat(FOURTH_BOSS_DATE_ROW,dateformat_style)#
						<cfelseif FOURTH_BOSS_VALID_ROW eq 1>
							Onaylandı (#dateformat(FOURTH_BOSS_DATE_ROW,dateformat_style)#)
						<cfelseif FOURTH_BOSS_VALID_ROW eq 0>
							Rededildi (#dateformat(FOURTH_BOSS_DATE_ROW,dateformat_style)#)
						<cfelse>
							Bekliyor
						</cfif>
					</td>
					<td>
						<cfif amir eq 5>
							Onay <input type="checkbox" name="fifth_boss_tech#currentrow#" id="fifth_boss_tech#currentrow#" <cfif FIFTH_BOSS_VALID_ROW eq 1 or (not len(FIFTH_BOSS_VALID_ROW) and FIFTH_BOSS_VALID_ROW eq 1)>checked</cfif>> #dateformat(FIFTH_BOSS_DATE_ROW,dateformat_style)#
						<cfelseif FIFTH_BOSS_VALID_ROW eq 1>
							Onaylandı (#dateformat(FIFTH_BOSS_DATE_ROW,dateformat_style)#)
						<cfelseif FIFTH_BOSS_VALID_ROW eq 0>
							Rededildi (#dateformat(FIFTH_BOSS_DATE_ROW,dateformat_style)#)
						<cfelse>
							Bekliyor
						</cfif>					
					</td>
				  </tr>
				  <tr class="color-row">
				  	<td class="txtboldblue">Açıklama</td>
				  	<td>
					<cfif amir eq 1>
						<input type="text" name="first_boss_detail_tech#currentrow#" id="first_boss_detail_tech#currentrow#" value="#FIRST_BOSS_DETAIL_ROW#" style="width:180px" maxlength="250">
					<cfelse>
						#FIRST_BOSS_DETAIL_ROW#
					</cfif>
					</td>
					<td>
					<cfif amir eq 2>
						<input type="text" name="second_boss_detail_tech#currentrow#" id="second_boss_detail_tech#currentrow#" value="#SECOND_BOSS_DETAIL_ROW#" style="width:180px" maxlength="250">
					<cfelse>
						#SECOND_BOSS_DETAIL_ROW#
					</cfif>
					</td>

					<td>
					<cfif amir eq 3>
						<input type="text" name="third_boss_detail_tech#currentrow#" id="third_boss_detail_tech#currentrow#" value="#THIRD_BOSS_DETAIL_ROW#" style="width:180px" maxlength="250">
					<cfelse>
						#THIRD_BOSS_DETAIL_ROW#
					</cfif>
					</td>
					<td>
					<cfif amir eq 4>
						<input type="text" name="fourth_boss_detail_tech#currentrow#" id="fourth_boss_detail_tech#currentrow#" value="#FOURTH_BOSS_DETAIL_ROW#" style="width:180px" maxlength="250">
					<cfelse>
						#FOURTH_BOSS_DETAIL_ROW#
					</cfif>
					</td>
					<td>
					<cfif amir eq 5>
						<input type="text" name="fifth_boss_detail_tech#currentrow#" id="fifth_boss_detail_tech#currentrow#" value="#FIFTH_BOSS_DETAIL_ROW#" style="width:180px" maxlength="250">
					<cfelse>
						#FIFTH_BOSS_DETAIL_ROW#
					</cfif>					
					</td>
				  </tr>
				</table>
				</td>
			  </tr>
			</cfoutput>
	</cfif>
	</table>
	</td>
  </tr>
</table>
<cfif (amir eq 1 and get_trains_all.SECOND_BOSS_VALID neq 1) or (amir eq 2 and get_trains_all.THIRD_BOSS_VALID neq 1) or (amir eq 3 and get_trains_all.FOURTH_BOSS_VALID neq 1) or (amir eq 4 and get_trains_all.FIFTH_BOSS_VALID neq 1) or amir eq 5>
	<table cellpadding="0" cellspacing="0" width="98%" align="center" height="30">
		<tr>
			<td style="text-align:right;"><cf_workcube_buttons is_upd='1' is_delete='0'></td>
		</tr>
	</table>
</cfif>
</cfform>

<script type="text/javascript">
var row_count_pos_req=<cfoutput>#get_trains_pos_req.recordcount#</cfoutput>;
var row_count_tech=<cfoutput>#get_trains_tech.recordcount#</cfoutput>;
function kontrol_pos_req()
{
	var satir=0;
	for(var i=1;i<=row_count_pos_req;i++)
		if(eval("add_class_request.row_kontrol_pos_req"+i).value==1) satir=satir+1;
	if(<cfoutput>#get_trains_standart.recordcount#</cfoutput>+satir >= 3)
	{
		alert('3 tanaden fazla standart ve yetkinlik eğitimi eklenemez!');
		return false;
	}
	return true;
}
function add_row_pos_req()
{
	if(!kontrol_pos_req())return false;
	row_count_pos_req++;
	var newRow;
	var newCell;
	newRow = document.getElementById("tablo_2").insertRow(document.getElementById("tablo_2").rows.length);
	newRow.className = 'color-row';
	newRow.setAttribute("name","frm_row_pos_req" + row_count_pos_req);
	newRow.setAttribute("id","frm_row_pos_req" + row_count_pos_req);		
	
	document.add_class_request.record_num_pos_req.value=row_count_pos_req;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol_pos_req' + row_count_pos_req +'" ><input type="text" readonly name="class_name_pos_req' + row_count_pos_req + '" value="" style="width:420px;"><input type="hidden" name="class_id_pos_req' + row_count_pos_req + '" value=""><a onclick="javascript:open_class('+row_count_pos_req+',1);"><img src="/images/plus_thin.gif" border="0" align="absmiddle" style="cursor:pointer;"></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="priority_pos_req' + row_count_pos_req + '" value="" style="width:250px;" maxlength="150">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="work_addition_pos_req' + row_count_pos_req + '" value="" style="width:250px;" maxlength="150">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a style="cursor:pointer" onclick="sil_pos_req('+ row_count_pos_req +');"><img  src="/images/delete_list.gif" border="0"></a>';
}
function sil_pos_req(sy)
{
	var my_element=eval("add_class_request.row_kontrol_pos_req"+sy);
	my_element.value=0;
	var my_element=eval("frm_row_pos_req"+sy);
	my_element.style.display="none";	
}

function kontrol_pos_req()
{
	var satir=0;
	for(var i=1;i<=row_count_pos_req;i++)
		if(eval("add_class_request.row_kontrol_pos_req"+i).value==1) satir=satir+1;
	if(<cfoutput>#get_trains_standart.recordcount#</cfoutput>+satir >= 3)
	{
		alert('3 tanaden fazla standart ve yetkinlik eğitimi eklenemez!');
		return false;
	}
	return true;
}

function add_row_tech()
{
	row_count_tech++;
	var newRow;
	var newCell;
	newRow = document.getElementById("tablo_1").insertRow(document.getElementById("tablo_1").rows.length);
	newRow.className = 'color-row';
	newRow.setAttribute("name","frm_row_tech" + row_count_tech);
	newRow.setAttribute("id","frm_row_tech" + row_count_tech);		
	
	document.add_class_request.record_num_tech.value=row_count_tech;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol_tech' + row_count_tech +'" ><input type="text" name="class_name_tech' + row_count_tech + '" value="" onBlur="tech_id_kontrol('+ row_count_tech +')" style="width:420px;"><input type="hidden" name="class_id_tech' + row_count_tech + '" value=""><a onclick="javascript:open_class('+row_count_tech+',2);"><img src="/images/plus_thin.gif" border="0" align="absmiddle" style="cursor:pointer;"></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="priority_tech' + row_count_tech + '" value="" style="width:150px;" maxlength="250">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="work_addition_tech' + row_count_tech + '" value="" style="width:150px;" maxlength="250">';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a style="cursor:pointer" onclick="sil_pos_tech('+ row_count_tech +');"><img  src="/images/delete_list.gif" border="0"></a>';
}
function sil_pos_tech(sy)
{
	var my_element=eval("add_class_request.row_kontrol_tech"+sy);
	my_element.value=0;
	var my_element=eval("frm_row_tech"+sy);
	my_element.style.display="none";	
}
function tech_id_kontrol(st)
{
	var my_element=eval("add_class_request.class_id_tech"+st);
	my_element.value='';
}

function open_class(sy,type)
{
if(type == 1)
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=training.popup_list_classes&field_id=add_class_request.class_id_pos_req'+sy+'&field_name=add_class_request.class_name_pos_req'+sy+'&list_type=1','list');
else
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=training.popup_list_classes&field_id=add_class_request.class_id_tech'+sy+'&field_name=add_class_request.class_name_tech'+sy+'&class_type=2','list');
}
</script>
