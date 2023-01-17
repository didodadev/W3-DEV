<script type="text/javascript">
function basamak_1()
	{
		if(confirm("Çalışan Kademe Aktarım İşlemi Yapacaksınız Bu İşlem Geri Alınamaz Emin misiniz?"))
			document.form_.submit();
		else 
			return false;
	}
</script>
<cfif not isdefined("attributes.hedef_year")>
<cfsavecontent  variable="message"><cf_get_lang dictionary_id='62844.Çalışan Derece Kademe Aktarımı'>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#message#">
		<form action="" method="post" name="form_">
			<cf_box_elements>   
				<div class="col col-2 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group"  id="item-hedef_period_1">
					
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58455.Yıl'></label>
						<div class="col col-8 col-sm-12">
							<select name="hedef_period_1" id="hedef_period_1">
								<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
								<cfoutput>
								<option value="#year(now())#">#year(now())#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
			</cf_box_elements>   
			<cf_box_footer>
				<div class="col col-6  ">
					<font color="red"><cf_get_lang dictionary_id='62845.Bu işlem çalışanların belirtilen yıl için yeni derece kademe kayıtlarını oluşturur.'></font>
				</div>
				<div class="col col-6 text-right ">
					<input type="button" value="Kademe Aktar" onClick="basamak_1();">
				</div>
			</cf_box_footer>
		</form>
	</cf_box>
</div>
</cfif>
<cfif isdefined("attributes.hedef_period_1")>	
	<cfif not len(attributes.hedef_period_1)>
		<script type="text/javascript">
			alert("Yıl Seçmelisiniz!");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cflock name="#CREATEUUID()#" timeout="70">
		<cftransaction>
		<cfquery name="get_in_out_" datasource="#dsn#">
			SELECT 
				EMPLOYEES_IN_OUT.IN_OUT_ID,
				EMPLOYEES.EMPLOYEE_ID,
				EMPLOYEES.EMPLOYEE_NAME+' '+EMPLOYEES.EMPLOYEE_SURNAME AS NAMESURNAME,
				EMPLOYEES_IN_OUT.DUTY_TYPE,
				ERD.GRADE,
				ERD.STEP,
				ERD.PROMOTION_START,
				ERD.PROMOTION_FINISH
			FROM 
				EMPLOYEES_IN_OUT INNER JOIN EMPLOYEES 
				ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
				INNER JOIN EMPLOYEES_IDENTY ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID
				INNER JOIN BRANCH ON EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID
				INNER JOIN DEPARTMENT D ON EMPLOYEES_IN_OUT.DEPARTMENT_ID = D.DEPARTMENT_ID
				INNER JOIN EMPLOYEES_RANK_DETAIL ERD ON ERD.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID 
				INNER JOIN 
				(
					SELECT 
						MAX(ID) AS ROW_ID 
					FROM
						EMPLOYEES_RANK_DETAIL
					WHERE
						YEAR(PROMOTION_START) = #attributes.hedef_period_1#-1
					GROUP BY
						EMPLOYEE_ID
				) RANK_TABLE ON RANK_TABLE.ROW_ID = ERD.ID
			WHERE
				(
					
						(
							(
							EMPLOYEES_IN_OUT.START_DATE <= #CreateDateTime(attributes.hedef_period_1,1,1,0,0,0)# AND
							EMPLOYEES_IN_OUT.FINISH_DATE >= #CreateDateTime(attributes.hedef_period_1,12,31,0,0,0)#
							)
							OR
							(
							EMPLOYEES_IN_OUT.START_DATE <= #CreateDateTime(attributes.hedef_period_1,1,1,0,0,0)# AND
							EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
							)
							OR
							(
							EMPLOYEES_IN_OUT.START_DATE >= #CreateDateTime(attributes.hedef_period_1,1,1,0,0,0)# AND
							EMPLOYEES_IN_OUT.START_DATE <= #CreateDateTime(attributes.hedef_period_1,12,31,0,0,0)#
							)
							OR
							(
							EMPLOYEES_IN_OUT.FINISH_DATE >= #CreateDateTime(attributes.hedef_period_1,1,1,0,0,0)# AND
							EMPLOYEES_IN_OUT.FINISH_DATE <= #CreateDateTime(attributes.hedef_period_1,12,31,0,0,0)#
							)
						)
						
				)
				AND EMPLOYEES_IN_OUT.DUTY_TYPE = 8 <!--- derece kademe--->
				AND EMPLOYEES.EMPLOYEE_ID NOT IN(SELECT EMPLOYEE_ID FROM EMPLOYEES_RANK_DETAIL WHERE YEAR(PROMOTION_START)=#attributes.hedef_period_1#)
			ORDER BY
				EMPLOYEES.EMPLOYEE_NAME,
				EMPLOYEES.EMPLOYEE_SURNAME,
				EMPLOYEES_IN_OUT.START_DATE	
		</cfquery>
		<cfloop query="get_in_out_">
			<cfif grade eq 1 and step eq 4>
				<cfset new_grade = 1>
				<cfset new_step = 4>
			<cfelseif grade eq 1 and step lt 4>
				<cfset new_grade = 1>
				<cfset new_step = step+1>
			<cfelseif step eq 3>
				<cfset new_grade = grade-1>
				<cfset new_step = 1>
			<cfelse>
				<cfset new_grade = grade>
				<cfset new_step = step+1>
			</cfif>
			<cfquery name="add_rank" datasource="#dsn#">
				INSERT INTO
					EMPLOYEES_RANK_DETAIL
					(
						EMPLOYEE_ID,
						GRADE,
						STEP,
						PROMOTION_START,
						PROMOTION_FINISH,
						PROMOTION_REASON,
						RECORD_EMP,
						RECORD_DATE,
						RECORD_IP
					)
				VALUES
					(
						#employee_id#,
						#new_grade#,
						#new_step#,
						#dateadd('d',1,get_in_out_.PROMOTION_FINISH)#,
						#dateadd('yyyy',1,get_in_out_.PROMOTION_FINISH)#,
						2,<!--- terfi--->
						#session.ep.userid#,
						#now()#,
						'#cgi.REMOTE_ADDR#'
					)
			</cfquery>
		</cfloop>
			<script type="text/javascript">
				alert("<cf_get_lang no ='2020.İşlem Başarıyla Tamamlanmıştır'>!");
			</script>
		</cftransaction>
	</cflock>
</cfif>
