<cfif not isdefined("attributes.in_out_ids")>
	<script>
		alert("<cf_get_lang dictionary_id='45506.Çıkış Kaydı Seçmelisiniz'>!");
		window.history.go(-2);
	</script>
	<cfabort>
</cfif>

<cfquery name="GET_IN_OUTS" datasource="#dsn#">
	SELECT 
		(SELECT SBC.BUSINESS_CODE FROM SETUP_BUSINESS_CODES SBC WHERE SBC.BUSINESS_CODE_ID = EMPLOYEES_IN_OUT.BUSINESS_CODE_ID) AS BUSINESS_CODE,
		EMPLOYEES_IN_OUT.VALID,		
		EMPLOYEES_IN_OUT.IN_OUT_ID,
		EMPLOYEES_IN_OUT.IS_5084,
		EMPLOYEES_IN_OUT.START_DATE,
		EMPLOYEES_IN_OUT.FINISH_DATE,
		EMPLOYEES_IN_OUT.KIDEM_AMOUNT,
		EMPLOYEES_IN_OUT.IHBAR_AMOUNT,
		EMPLOYEES_IN_OUT.RECORD_DATE,
		EMPLOYEES_IN_OUT.UPDATE_DATE,
		EMPLOYEES_IN_OUT.EXPLANATION_ID,
		EMPLOYEES_IN_OUT.EX_IN_OUT_ID,
		CASE 
			WHEN EMPLOYEES_IN_OUT.SSK_STATUTE = 1 THEN 0
			WHEN EMPLOYEES_IN_OUT.SSK_STATUTE = 2 THEN 8
			WHEN EMPLOYEES_IN_OUT.SSK_STATUTE = 3 THEN 19
			WHEN EMPLOYEES_IN_OUT.SSK_STATUTE = 4 THEN 7
		ELSE 1 END AS SIGORTAKOLU,
		CASE 
			WHEN EMPLOYEES_IN_OUT.DUTY_TYPE = 0 THEN 1
			WHEN EMPLOYEES_IN_OUT.DUTY_TYPE = 1 THEN 1
			WHEN (EMPLOYEES_IN_OUT.SSK_STATUTE = 3 OR EMPLOYEES_IN_OUT.SSK_STATUTE = 4) THEN 5
		ELSE 2 END AS GOREVKODU,		
		BRANCH.BRANCH_WORK,
		EMPLOYEES_IDENTY.TC_IDENTY_NO,
		EMPLOYEES.KIDEM_DATE,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES.EMPLOYEE_ID,
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_FULLNAME,
		BRANCH.BRANCH_ID,
		BRANCH.SSK_OFFICE,
		BRANCH.SSK_NO,
		BRANCH.BRANCH_ADDRESS,
		BRANCH.SSK_AGENT,
		CASE 
			WHEN EGITIM.EDU_TYPE = 1 THEN 2
			WHEN EGITIM.EDU_TYPE = 2 THEN 3
			WHEN EGITIM.EDU_TYPE = 3 THEN 4
			WHEN EGITIM.EDU_TYPE = 4 THEN 4
			WHEN EGITIM.EDU_TYPE = 5 THEN 5
			WHEN EGITIM.EDU_TYPE = 6 THEN 5
			WHEN EGITIM.EDU_TYPE = 7 THEN 6
			WHEN EGITIM.EDU_TYPE = 8 THEN 7
		ELSE 0 END AS OGRENIMKODU,
		EGITIM.EDU_FINISH,
		EGITIM.EDU_PART_NAME,
		CASE WHEN (EMPLOYEES_DETAIL.DEFECTED = 1) THEN 'E' ELSE 'H' END AS OZURLUKODU,
		CASE WHEN (EMPLOYEES_DETAIL.SENTENCED = 1) THEN 'E' ELSE 'H' END AS ESKIHUKUMLU,
		BRANCH.SSK_M + '' + BRANCH.SSK_JOB + '' + BRANCH.SSK_BRANCH + '' + BRANCH.SSK_BRANCH_OLD + '' + BRANCH.SSK_NO + '' + BRANCH.SSK_CITY + '' + BRANCH.SSK_COUNTRY AS SSK_ISYERI,
		D.DEPARTMENT_HEAD,
		EMPLOYEE_POSITIONS.POSITION_NAME
	FROM 
		EMPLOYEES_IN_OUT,
		EMPLOYEES
			LEFT JOIN EMPLOYEE_POSITIONS ON (EMPLOYEE_POSITIONS.IS_MASTER = 1 AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID)
			OUTER APPLY
				(SELECT TOP 1 EDU_TYPE,EDU_PART_NAME,EDU_FINISH FROM EMPLOYEES_APP_EDU_INFO WHERE EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID ORDER BY EDU_FINISH DESC) EGITIM
		,
		EMPLOYEES_DETAIL,
		EMPLOYEES_IDENTY,
		BRANCH,
		DEPARTMENT D
	WHERE
		
		EMPLOYEES_IN_OUT.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_DETAIL.EMPLOYEE_ID AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID AND
		EMPLOYEES_IN_OUT.FINISH_DATE IS NOT NULL  AND
		EMPLOYEES_IN_OUT.IN_OUT_ID IN (#attributes.in_out_ids#)
	ORDER BY
		BRANCH.BRANCH_NAME,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES_IN_OUT.START_DATE
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="38392.İşten Çıkış Mail"></cfsavecontent>
<cf_box title="#message#" closable="0" collapsed="0">
	<cfform name="sgk_outs_mail" action="index.cfm?fuseaction=ehesap.list_outs_mail_send" method="post">
		<div class="row">
			<div class="col col-8 col-md-4 col-sm-6 col-xs-12">
				<div class="col col-6 col-md-4 col-sm-6 col-xs-12">
					<div class="form-group">
						<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57924.Kime'></label>
						<div class="col col-12 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="45456.Alıcı kişiyi girin!"></cfsavecontent>
							<cfinput type="text" name="to" value="" required="yes" message="#message#" />
						</div>
					</div>
					<div class="form-group">
						<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58820.Başlık'></label>
						<div class="col col-12 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='29832.İşten Çıkış'></cfsavecontent>
							<cfinput type="text" name="subject" value="#message#" maxlength="256"/>
						</div>
					</div>
				</div>
				<div class="form-group">
					<div class="col col-12 col-xs-12">
					<cfsavecontent variable = "mail_content">
						<p><cf_get_lang dictionary_id="49699.Sayın Yetkili">;<br><br><cf_get_lang dictionary_id="49496.Aşağıda bilgileri bulunan kişilerin işten çıkışı yapılmıştır"><br><br></p>
						<table cellpadding=3 border=1 cellspacing=0 width="100%" class="workDevList">
							<thead>
								<tr>
									<th><cf_get_lang dictionary_id="57897.Adı"></th>							
									<th><cf_get_lang dictionary_id="58550.Soyadı"></th>
									<th><cf_get_lang dictionary_id="57453.şube"></th>
									<th><cf_get_lang dictionary_id="57572.departman"></th>
									<th><cf_get_lang dictionary_id="58497.pozisyon"></th>
									<th><cf_get_lang dictionary_id="29438.Çıkış Tarihi"></th>
								</tr>
							</thead>
							<tbody>
								<cfoutput query="GET_IN_OUTS">
									<tr>
										<td>#EMPLOYEE_NAME#</td>
										<td>#EMPLOYEE_SURNAME#</td>
										<td>#BRANCH_FULLNAME#</td>
										<td>#DEPARTMENT_HEAD#</td>
										<td>#POSITION_NAME#</td>
										<td>#dateformat(FINISH_DATE,'dd/mm/yyyy')#</td>
									</tr>
								</cfoutput>
							</tbody>
						</table>
						<br>
						<br>
						<cfquery name="ALL_DEPARTMENTS_IC" datasource="#DSN#">
							SELECT DISTINCT
								BRANCH.BRANCH_NAME,
								DEPARTMENT.DEPARTMENT_HEAD
							FROM								
								BRANCH,
								DEPARTMENT
								
							WHERE
								BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID AND								
								DEPARTMENT.DEPARTMENT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
    					</cfquery>
						<b><cfoutput>#session.ep.company# <br>#ALL_DEPARTMENTS_IC.BRANCH_NAME#/#ALL_DEPARTMENTS_IC.DEPARTMENT_HEAD#</b></cfoutput>
						<br>
						<br>
						&nbsp;	
					</cfsavecontent>
					<cfmodule
						template="/fckeditor/fckeditor.cfm"
						toolbarset="Basic"
						basepath="/fckeditor/"
						instancename="detayicerik"
						valign="top"
						value="#mail_content#"
						width="555"
						height="180">
				</div>	
			</div>
			<div class="form-group">
				<div class="col col-12 text-right">
					<cf_form_box_footer>
						<cfinput type="submit" name="Gönder" value="Gönder"/>
					</cf_form_box_footer>
				</div>
			</div>
		</div>
	</cfform>
</cf_box>




























