<!--- bu dosyanin benzeri myhome ben altinda izinlerim bölümünde de var --->
<cfquery name="GET_GENERAL_OFFTIMES" datasource="#dsn#">
	SELECT START_DATE,FINISH_DATE,IS_HALFOFFTIME FROM SETUP_GENERAL_OFFTIMES
</cfquery>

<cfquery name="get_emp" datasource="#dsn#">
	SELECT 
		E.EMPLOYEE_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.KIDEM_DATE,
		E.IZIN_DATE,
		E.IZIN_DAYS,
		E.OLD_SGK_DAYS,
		EI.BIRTH_DATE,
		E.GROUP_STARTDATE,
		(SELECT TOP 1 PUANTAJ_GROUP_IDS FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID AND (FINISH_DATE IS NULL OR FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">) AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> ORDER BY FINISH_DATE ASC) AS PUANTAJ_GROUP_IDS,
		(
			CASE 
				WHEN (
					SELECT 
						TOP 1 FINISH_DATE 
					FROM 
						EMPLOYEES_IN_OUT
					WHERE 
						EMPLOYEE_ID = E.EMPLOYEE_ID 
						AND (FINISH_DATE IS NULL OR FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">) 
						AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> ORDER BY FINISH_DATE ASC
				) IS NULL THEN NULL 
				ELSE 
				(
					SELECT 
						TOP 1 FINISH_DATE 
					FROM 
						EMPLOYEES_IN_OUT
					WHERE 
						EMPLOYEE_ID = E.EMPLOYEE_ID 
						AND (FINISH_DATE IS NULL OR FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">) 
						AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> ORDER BY FINISH_DATE DESC
				)
				END
		) 
		AS FINISH_DATE
	FROM
		EMPLOYEES E
		INNER JOIN EMPLOYEES_IDENTY EI ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
	WHERE 
		E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
</cfquery>

<cfif len(get_emp.IZIN_DATE)>
	<!--- İZİN BAZ TARİHİNDEN ÖNCEKİ İZİNLER --->						
	<cfquery name="get_offtime_old" datasource="#dsn#">
		SELECT 
			OFFTIME.*,
			SETUP_OFFTIME.OFFTIMECAT_ID,
			SETUP_OFFTIME.OFFTIMECAT,
            SETUP_OFFTIME.IS_PAID,
			SETUP_OFFTIME.CALC_CALENDAR_DAY
		FROM 
			OFFTIME,
			SETUP_OFFTIME
		WHERE
			SETUP_OFFTIME.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID AND
			OFFTIME.IS_PUANTAJ_OFF = 0 AND
			OFFTIME.VALID = 1 AND
			SETUP_OFFTIME.IS_PAID = 1 AND
			SETUP_OFFTIME.IS_YEARLY = 1	AND
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
			OFFTIME.FINISHDATE < <cfqueryparam cfsqltype="cf_sql_date" value="#get_emp.izin_date#">
		ORDER BY
			STARTDATE DESC
	</cfquery>
	<!--- // İZİN BAZ TARİHİNDEN ÖNCEKİ İZİNLER --->
</cfif>

<cfquery name="get_progress_payment_out" datasource="#dsn#">
	SELECT * FROM EMPLOYEE_PROGRESS_PAYMENT_OUT WHERE EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
</cfquery>
<cfquery name="get_offtime_delay" datasource="#dsn#">
	SELECT 
		OFFTIME.STARTDATE,
		OFFTIME.FINISHDATE,
		IS_YEARLY,
		IS_KIDEM,
		DATEDIFF(dd,OFFTIME.STARTDATE,OFFTIME.FINISHDATE)+1 AS PROGRESS_TIME
	FROM 
		OFFTIME,
		SETUP_OFFTIME
	WHERE
		<cfif isdefined('attributes.IZIN_DATE') and len(attributes.IZIN_DATE)>
			OFFTIME.STARTDATE > <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.IZIN_DATE#"> AND
		</cfif>
		SETUP_OFFTIME.OFFTIMECAT_ID=OFFTIME.OFFTIMECAT_ID AND
		OFFTIME.IS_PUANTAJ_OFF = 0 AND
		OFFTIME.VALID = 1 AND
		SETUP_OFFTIME.IS_OFFDAY_DELAY = 1 AND
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	ORDER BY
		STARTDATE DESC
</cfquery>


<cfinclude template="../query/get_eski_izinler.cfm">
<cfinclude template="../query/get_in_out_other.cfm">

<cfset genel_izin_toplam = 0> <!--- izinler toplanirken asagida lazim silmeyin yo20122005 --->
<!-- sil -->
<cfsavecontent variable="txt">
	<cf_get_lang dictionary_id ='56372.Geçmiş Çalışmalar'> : <cfoutput>#get_emp.employee_name# #get_emp.employee_surname# - #dateformat(get_emp.KIDEM_DATE,dateformat_style)# (#dateformat(get_emp.BIRTH_DATE,dateformat_style)#)</cfoutput>
</cfsavecontent>
<cfsavecontent variable="right_"><cf_workcube_file_action box="1" pdf='1' mail='1' doc='1' print='1' simple="1"></cfsavecontent>
<cf_box title="#txt#" right_images="#right_#">
<!-- sil -->
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="56706.Giriş Çıkışlar"></cfsavecontent>
	<!---Giriş Çıkışlar--->
	<cf_box title="#message#">
		<cf_flat_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th width="75"><cf_get_lang dictionary_id='57554.Giriş'></th>
					<th width="75"><cf_get_lang dictionary_id='57431.Çıkış'></th>
					<th><cf_get_lang dictionary_id='57490.Gün'></th>
					<!-- sil --><th width="15">&nbsp;</th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_in_out_other.recordcount>
					<cfoutput query="get_in_out_other">
					<tr>
						<td>#NICK_NAME#</td>
						<td>#branch_name#</td>
						<td>#dateformat(start_date,dateformat_style)#</td>
						<td><cfif len(finish_date)>#dateformat(finish_date,dateformat_style)#</cfif></td>
						<td width="25"><cfif len(finish_date)>#datediff("d",start_date,finish_date)+1#<cfelse>#datediff("d",start_date,now())+1#</cfif></td>
						<!-- sil --><td>&nbsp;</td><!-- sil -->
					</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
	</cf_box>
	<!---Geçmiş Çalışmalar--->
	<cf_box title="#getLang('hr',1287)#">
		<cf_flat_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th width="75"><cf_get_lang dictionary_id='57554.Giriş'></th>
					<th width="75"><cf_get_lang dictionary_id='57431.Çıkış'></th>
					<th><cf_get_lang dictionary_id='57490.Gün'></th>
					<!-- sil --><th style="width:15px;"><cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.list_emp_progress_payment&event=popupAdd&employee_id=#attributes.employee_id#','medium');"><i class="fa fa-plus " title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></cfoutput></th><!-- sil -->
				</tr>
			</thead>
			<cfif get_eski_izinler.recordcount>
				<cfset calisilan = 0>
				<cfoutput query="get_eski_izinler">
				<cfif len(WORKED_DAY)>
					<cfset calisilan_employee = WORKED_DAY>
				<cfelse>
					<cfset calisilan_employee = datediff("d",startdate,finishdate)>
				</cfif>
				<tbody>
					<tr>
						<td>#NICK_NAME#</td>
						<td>#branch_name#</td>
						<td>#dateformat(STARTDATE,dateformat_style)#</td>
						<td>#dateformat(FINISHDATE,dateformat_style)#</td>
						<td>#calisilan_employee#</td>
						<!-- sil --><td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.list_emp_progress_payment&event=popupUpd&progress_id=#progress_id#','medium');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
					</tr>
				</tbody>
				<cfset calisilan = calisilan + calisilan_employee>
				</cfoutput> 
				<cfoutput>
				<tfoot>
					<tr>
						<td colspan="4"><cf_get_lang dictionary_id='57492.Toplam'></td>
						<td>#calisilan#</td>
						<td>&nbsp;</td>
					</tr>
				</tfoot>
				</cfoutput>
			<cfelse>
				<tbody>
					<tr>
						<td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
					</tr>
				</tbody>
			</cfif>
		</cf_flat_list>
	</cf_box>
	<cfset is_control = 1>
	<cfinclude template="/V16/hr/display/employee_offtime_contract_info.cfm">
	<cfset attributes.izin_date = get_emp.IZIN_DATE>
	<cfinclude template="list_offtime_emp_days.cfm">

	<cfsavecontent variable="message"><cf_get_lang dictionary_id="56633.Çalışma Süresi Dağılımı"></cfsavecontent>
	<!---Çalışma Süresi Dağılımı--->
	<cf_box title="#message#">
		<cf_flat_list>	
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th width="65"><cf_get_lang dictionary_id='57501.Başlangıç'></th>
					<th width="65"><cf_get_lang dictionary_id='57502.Bitiş'></th>
					<th width="45"><cf_get_lang dictionary_id ='57490.Gün'></th>
					<th style="width:130px;"><cf_get_lang dictionary_id ='56632.Boş Geçen Kıdem Günü'></th>
					<!-- sil --><th width="15"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_add_employees_in_out_real&employee_id=#attributes.employee_id#</cfoutput>','medium');"><i class="fa fa-plus " title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfquery name="get_real" datasource="#dsn#">
					SELECT * FROM EMPLOYEES_IN_OUT_REAL WHERE EMPLOYEE_ID = #attributes.employee_id#
				</cfquery>
				<cfif get_real.recordcount>
					<cfoutput query="get_real">
					<tr>
						<td>
						<!---<cfif len(branch_id)>
							<cfquery name="get_b" datasource="#dsn#">
								SELECT BRANCH_FULLNAME FROM BRANCH_FOR_SENIORITY WHERE BRANCH_FOR_SENIORITY_ID = #branch_id#
							</cfquery>
							#get_b.BRANCH_FULLNAME#
						<cfelse>--->
							#branch_name#
						<!---</cfif>--->
						</td>
						<td>#dateformat(start_date,dateformat_style)#</td>
						<td><cfif len(finish_date)>#dateformat(finish_date,dateformat_style)#</cfif></td>
						<td><cfif len(worked_day)>#worked_day#</cfif></td>
						<td>
						<cfif len(worked_day) or len(finish_date)>
							<cfquery name="get_off" dbtype="query">
								SELECT 
									SUM(PROGRESS_TIME) AS TOTAL_OFF 
								FROM 
									get_progress_payment_out 
								WHERE 
									IS_KIDEM = 1 AND
									START_DATE >= #createodbcdatetime(start_date)# AND 
									<cfif len(finish_date)>
										FINISH_DATE <= #createodbcdatetime(finish_date)#
									<cfelse>
										FINISH_DATE <= #createodbcdatetime(DATEADD("d",worked_day,start_date))#
									</cfif>  
							</cfquery>
							<cfif get_off.recordcount and len(get_off.TOTAL_OFF)>
								#get_off.TOTAL_OFF#
							<cfelse>
								0
							</cfif>
						<cfelse>
						0
						</cfif>
						</td>
						<!-- sil --><td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_upd_employees_in_out_real&real_id=#real_id#','medium');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
					</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="56631.İzin ve Kıdemden Sayılmayacak Günler"></cfsavecontent>
	<cf_box title="#message#">
		<cf_flat_list>
			<thead>
				<tr>
					<th width="65"><cf_get_lang dictionary_id='57501.Başlangıç'></th>
					<th width="65"><cf_get_lang dictionary_id='57502.Bitiş'></th>
					<th><cf_get_lang dictionary_id='57490.Gün'></th>
					<th><cf_get_lang dictionary_id ='56630.Kıdem'></th>
					<th><cf_get_lang dictionary_id='58575.İzin'></th>
					<!-- sil --><th width="15"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_progress_payment_out&emp_id=#attributes.employee_id#</cfoutput>','medium');"><i class="fa fa-plus " title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
				</tr>
			</thead>
			<cfif len(get_progress_payment_out.START_DATE) and len(get_progress_payment_out.FINISH_DATE)>
				<cfset gun = datediff('d',get_progress_payment_out.START_DATE,get_progress_payment_out.FINISH_DATE)+1>
			<cfelseif len(get_progress_payment_out.START_DATE)>
				<cfset gun = datediff('d',get_progress_payment_out.START_DATE,now())+1>
			</cfif>
			<tbody>
			<cfif get_progress_payment_out.recordcount or get_offtime_delay.recordcount>
				<cfoutput query="get_progress_payment_out">
				<tr>
					<td>#dateformat(start_date,dateformat_style)#</td>
					<td><cfif len(finish_date)>#dateformat(finish_date,dateformat_style)#</cfif></td>
					<td><cfif len(PROGRESS_TIME)>#PROGRESS_TIME#<cfelse>#gun#</cfif></td>
					<td><cfif IS_KIDEM eq 1><cf_get_lang dictionary_id='57495.Evet'></cfif></td>
					<td><cfif IS_YEARLY eq 1><cf_get_lang dictionary_id='57495.Evet'></cfif></td>
					<!-- sil --><td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_upd_progress_payment_out&progress_payment_out_id=#progress_payment_out_id#','medium');" title="<cf_get_lang dictionary_id = "57464.Güncelle">"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
				</tr>
				</cfoutput>
				<cfoutput query="get_offtime_delay">
				<tr>
					<td>#dateformat(STARTDATE,dateformat_style)#</td>
					<td><cfif len(finishdate)>#dateformat(finishdate,dateformat_style)#</cfif></td>
					<td>#datediff("d",STARTDATE,finishdate) + 1#</td>
					<td></td>
					<td><cf_get_lang dictionary_id='57495.Evet'></td>
					<!-- sil --><td></td><!-- sil -->
				</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
				</tr>
			</cfif>
			</tbody>
		</cf_flat_list>
	</cf_box>
</cf_box>