<cfquery name="GET_GENERAL_OFFTIMES" datasource="#dsn#">
	SELECT START_DATE,FINISH_DATE FROM SETUP_GENERAL_OFFTIMES
</cfquery>
<cfset general_offtime_days_ = "">
<cfoutput query="GET_GENERAL_OFFTIMES">
	<cfset day_count = DateDiff("d",START_DATE,FINISH_DATE) + 1>
	<cfloop index="k" from="1" to="#day_count#">
		<cfset current_day = date_add("d", k-1, START_DATE)>
		<cfset current_day = dateformat(current_day,'dd.mm.yyyy')>
		<cfset general_offtime_days_ = listappend(general_offtime_days_,current_day)>
	</cfloop>
</cfoutput>

<cfquery name="get_pos_" datasource="#dsn#">
	SELECT 
		EP.POSITION_NAME,
		B.BRANCH_NAME
	FROM 
		EMPLOYEE_POSITIONS EP,
		DEPARTMENT D,
		BRANCH B
	WHERE
		EP.EMPLOYEE_ID = #aktif_employee_id# AND
		EP.IS_MASTER = 1 AND
		EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		D.BRANCH_ID = B.BRANCH_ID
</cfquery>

<cfoutput>
<cfloop from="1" to="#toplam_gun_#" index="gun_sira">
<cfset aktif_gun_ = date_add("d",gun_sira-1,gecen_ay_)>
<cfset hafta_gunu_ = DayOfWeek(aktif_gun_)>
	<cfquery name="get_ins_" dbtype="query">
		SELECT * FROM get_in_outs WHERE START_DATE BETWEEN #aktif_gun_# AND #DATEADD("d",1,aktif_gun_)# AND START_DATE IS NOT NULL AND <cfif fusebox.circuit is 'hr' or fusebox.circuit is 'myhome'>EMPLOYEE_ID<cfelse>PARTNER_ID</cfif>= #aktif_employee_id#
	</cfquery>
<cfif fusebox.circuit is 'hr' or  fusebox.circuit is 'myhome'>
	<cfquery name="get_izin_" dbtype="query" maxrows="1">
		SELECT 
			* 
		FROM 
			GET_TODAY_OFFTIMES 
		WHERE 
			(
			(
			STARTDATE >= #DATEADD("h",-session.ep.time_zone,aktif_gun_)# AND
			STARTDATE < #DATEADD("d",1,DATEADD("h",-session.ep.time_zone,aktif_gun_))#
			)
			OR
			(
			STARTDATE <= #DATEADD("h",-session.ep.time_zone,aktif_gun_)# AND
			FINISHDATE >= #DATEADD("h",-session.ep.time_zone,aktif_gun_)#
			)
			)
			AND EMPLOYEE_ID = #aktif_employee_id#			
	</cfquery>
	<cfquery name="get_fee" dbtype="query" maxrows="1">
		SELECT 
			* 
		FROM 
			get_fees 
		WHERE		
			(
			(FEE_DATEOUT >= #aktif_gun_# AND FEE_DATEOUT < #DATEADD('D',1,aktif_gun_)#) OR
			(FEE_DATEOUT >= #aktif_gun_# AND FEE_DATEOUT < #DATEADD('D',1,aktif_gun_)#)
			)
			AND EMPLOYEE_ID = #aktif_employee_id#
		
	</cfquery>
<cfelse>
	<cfset get_fee.recordcount = 0>
</cfif>
	<tr height="20" <cfif listlen(general_offtime_days_) and listfindnocase(general_offtime_days_,'#dateformat(aktif_gun_,'dd.mm.yyyy')#')>onMouseOut="this.bgColor='66CCCC';" bgcolor="66CCCC"<cfelseif hafta_gunu_ eq 1>onMouseOut="this.bgColor='FF9B94';" bgcolor="FF9B94"<cfelseif hafta_gunu_ eq 7>onMouseOut="this.bgColor='cccccc';" bgcolor="cccccc"</cfif>>
		<cfif isdefined("isim_yazdir_")>
			<td nowrap><cfif fusebox.circuit is 'hr'>#employee_name# #employee_surname#<cfelse>#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME#</cfif></td>
		</cfif>
		<td width="75">#dateformat(aktif_gun_,dateformat_style)#</td>
		<td width="50" <cfif (listlen(general_offtime_days_) and listfindnocase(general_offtime_days_,'#dateformat(aktif_gun_,"dd.mm.yyyy")#')) or hafta_gunu_ eq 1>style="color:red;"</cfif>>
			<b>
				<cfif hafta_gunu_ eq 2><cf_get_lang dictionary_id='57604.Pazartesi'>
				<cfelseif hafta_gunu_ eq 3><cf_get_lang dictionary_id='57605.Salı'>
				<cfelseif hafta_gunu_ eq 4><cf_get_lang dictionary_id='57606.Çarşamba'>
				<cfelseif hafta_gunu_ eq 5><cf_get_lang dictionary_id='57607.Perşembe'>
				<cfelseif hafta_gunu_ eq 6><cf_get_lang dictionary_id='57608.Cuma'>
				<cfelseif hafta_gunu_ eq 7><cf_get_lang dictionary_id='57609.Cumartesi'>
				<cfelseif hafta_gunu_ eq 1><cf_get_lang dictionary_id='57610.Pazar'>
				</cfif></b>
		</td>
<cfif isdefined("is_pdks_multirecord") and is_pdks_multirecord eq 1>
	<td>#get_ins_.recordcount#</td>
	<td>
	<cfif get_ins_.recordcount>
		<cfif len(get_ins_.START_DATE[1])><!--- <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popup_edit_daily_in&row_id=#get_ins_.row_id[1]#','small')" class="tableyazi"> --->#timeformat(get_ins_.START_DATE[1],timeformat_style)#<!---</a>---></cfif>
	</cfif>
	</td>
	<td>
	<cfif get_ins_.recordcount>
		<cfif len(get_ins_.FINISH_DATE[1])>#timeformat(get_ins_.FINISH_DATE[1],timeformat_style)#</cfif>
	</cfif>
	</td>
	<td>
	<cfif get_ins_.recordcount gte 2>
		<cfif len(get_ins_.START_DATE[2])>#timeformat(get_ins_.START_DATE[2],timeformat_style)#</cfif>
	</cfif>
	</td>
	<td>
	<cfif get_ins_.recordcount gte 2>
		<cfif len(get_ins_.FINISH_DATE[2])>#timeformat(get_ins_.FINISH_DATE[2],timeformat_style)#</cfif>
	</cfif>
	</td>
	<td>
	<cfif get_ins_.recordcount gt 2>
		<cfif len(get_ins_.START_DATE[get_ins_.recordcount])>#timeformat(get_ins_.START_DATE[get_ins_.recordcount],timeformat_style)#</cfif>
	</cfif>
	</td>
	<td>
	<cfif get_ins_.recordcount gt 2>
		<cfif len(get_ins_.FINISH_DATE[get_ins_.recordcount])>#timeformat(get_ins_.FINISH_DATE[get_ins_.recordcount],timeformat_style)#</cfif>
	</cfif>
	</td>
<cfelse>
	<td>
	<cfif get_ins_.recordcount and len(get_ins_.START_DATE[1])>#timeformat(get_ins_.START_DATE[1],timeformat_style)#</cfif>
	</td>
	<td>
	<cfif get_ins_.recordcount and len(get_ins_.FINISH_DATE[get_ins_.recordcount])>#timeformat(get_ins_.FINISH_DATE[get_ins_.recordcount],timeformat_style)#</cfif>
	</td>
</cfif>
<cfif fusebox.circuit is 'hr' or fusebox.circuit is 'myhome'>
<td><cfif get_pos_.recordcount>#get_pos_.position_name#</cfif></td>
<td><cfif get_pos_.recordcount>#get_pos_.branch_name#</cfif></td>
<td>
	<cfif get_izin_.recordcount>#get_izin_.OFFTIMECAT# : 
	#dateformat(date_add("h",session.ep.time_zone,get_izin_.startdate),dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,get_izin_.startdate),timeformat_style)#) - 
	#dateformat(date_add("h",session.ep.time_zone,get_izin_.finishdate),dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,get_izin_.finishdate),timeformat_style)#)
	</cfif>
</td>
</cfif>
<cfif fusebox.circuit is 'hr' or fusebox.circuit is 'member'>
<td nowrap="nowrap">
<cfif get_ins_.recordcount>
	<cfif not Len(get_ins_.IS_WEEK_REST_DAY)>
		<cf_get_lang dictionary_id='55753.Çalışma Günü'>
	<cfelseif get_ins_.IS_WEEK_REST_DAY eq 0>
		<cf_get_lang dictionary_id='58867.Hafta Tatili'>
	<cfelseif get_ins_.IS_WEEK_REST_DAY eq 1>
		<cf_get_lang dictionary_id='29482.Genel Tatil'>
	<cfelseif get_ins_.IS_WEEK_REST_DAY eq 2>
		<cf_get_lang dictionary_id='55837.Genel Tatil-Hafta Tatili'>
	<cfelseif get_ins_.IS_WEEK_REST_DAY eq 3>
		<cf_get_lang dictionary_id='55840.Ücretli İzin Hafta Tatili'>
	<cfelseif get_ins_.IS_WEEK_REST_DAY eq 4>
		<cf_get_lang dictionary_id='55844.Ücretsiz İzin Hafta Tatili'>
	</cfif>
</cfif>
</td>
</cfif>
<cfset attributes.employee_id = session.ep.userid>
<cfquery name="GET_TODAY_OFFTIMES" datasource="#DSN#">
	SELECT 
		OFFTIME.VALID, 
		OFFTIME.VALIDDATE,
		OFFTIME.EMPLOYEE_ID, 
		OFFTIME.OFFTIME_ID, 
		OFFTIME.VALID_EMPLOYEE_ID, 
		OFFTIME.STARTDATE, 
		OFFTIME.FINISHDATE, 
		OFFTIME.TOTAL_HOURS, 
		SETUP_OFFTIME.OFFTIMECAT,
		D.HIERARCHY_DEP_ID AS HIERARCHY_DEP_ID1,
		CASE 
			WHEN EMPLOYEES.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE START_DATE <= GETDATE() AND (FINISH_DATE >= GETDATE() OR FINISH_DATE IS NULL))
		THEN	
			D.HIERARCHY_DEP_ID
		ELSE 
			CASE WHEN 
				D.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENT_HISTORY WHERE CHANGE_DATE IS NOT NULL AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID))
			THEN
				(SELECT TOP 1 HIERARCHY_DEP_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = D.DEPARTMENT_ID AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID) ORDER BY CHANGE_DATE DESC, DEPT_HIST_ID DESC)
			ELSE
				D.HIERARCHY_DEP_ID
			END
		END AS HIERARCHY_DEP_ID
	FROM 
		OFFTIME,
		EMPLOYEES,
		DEPARTMENT D,
		SETUP_OFFTIME
	WHERE
		OFFTIME.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
		OFFTIME.EMPLOYEE_ID = #attributes.employee_id# AND
		OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID AND
		OFFTIME.EMPLOYEE_ID=EMPLOYEES.EMPLOYEE_ID
</cfquery>
<td width="85" nowrap="nowrap"><cfif get_fee.recordcount><cf_get_lang dictionary_id='62759.vizitede'></cfif></td>
<!-- sil -->
<cfif isDefined("x_show_level") and x_show_level eq 1>
	<td>                           
		<cfset up_dep_len = listlen(GET_TODAY_OFFTIMES.HIERARCHY_DEP_ID1,'.')>
		<cfif up_dep_len gt 0>
			<cfset temp = up_dep_len> 
			<cfloop from="1" to="#up_dep_len#" index="i" step="1">
				<cfif isdefined("GET_TODAY_OFFTIMES.HIERARCHY_DEP_ID1") and listlen(GET_TODAY_OFFTIMES.HIERARCHY_DEP_ID1,'.') gt temp>
					<cfset up_dep_id = ListGetAt(GET_TODAY_OFFTIMES.HIERARCHY_DEP_ID1, listlen(GET_TODAY_OFFTIMES.HIERARCHY_DEP_ID1,'.')-temp,".")>
					<cfquery name="get_upper_departments" datasource="#dsn#">
						SELECT DEPARTMENT_HEAD, LEVEL_NO FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#up_dep_id#">
					</cfquery>
					<cfset up_dep_head = get_upper_departments.department_head>
					#up_dep_head# 
						<cfset get_org_level = cmp_org_step.get_organization_step(level_no : get_upper_departments.LEVEL_NO)>
						<cfif get_org_level.recordcount>
							(#get_org_level.ORGANIZATION_STEP_NAME#)
						</cfif>
					<cfif up_dep_len neq i>
						>
					</cfif>
				<cfelse>
					<cfset up_dep_head = ''>
				</cfif>
				<cfset temp = temp - 1>
			</cfloop>
		</cfif>​
	</td>
</cfif>
<cfif fusebox.circuit is 'hr'>
<td style="text-align:center;" width="20"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=<cfoutput>#listgetat(attributes.fuseaction,1,".")#</cfoutput>.list_emp_pdks&event=mail&employee_id=#aktif_employee_id#&aktif_gun=#dateformat(aktif_gun_,dateformat_style)#');"><i class="fa fa-envelope" title="<cf_get_lang dictionary_id='55720.Uyarı Maili Gönder'>" border="0"></i></a></td>
</cfif>
<cfif fusebox.circuit is 'hr' or fusebox.circuit is 'member'>
<td style="text-align:center;" width="20"><input type="checkbox" name="pdks_emp_list" id="pdks_emp_list" value="<cfif isdefined("employee_id")>#employee_id#;#dateformat(aktif_gun_,dateformat_style)#</cfif>"></td>
</cfif>
<!-- sil -->
	</tr>
</cfloop>
</cfoutput>