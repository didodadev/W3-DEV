<cfparam name="attributes.puantaj_type" default="-1">
<cfset main_puantaj_table = "EMPLOYEES_PUANTAJ">
<cfset row_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS">
<cfset ext_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_EXT">
<cfset add_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_ADD">
<cfset maas_puantaj_table = "EMPLOYEES_SALARY">
<cffunction name="make_pdf" output="false">
	<cfargument name="file_name" default="pdf_file">
	<cfargument name="pdf_content" default="">
	<cfdocument format="pdf" pagetype="a4" filename="#upload_folder#reserve_files#dir_seperator##drc_name_##dir_seperator##arguments.file_name#.pdf" marginleft="0" marginright="0" margintop="0" overwrite="yes">
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
			<title>Puantaj PDF</title>
			</head>
		<body>
			<cfoutput>#arguments.pdf_content#</cfoutput>
		</body>
	</html>
	</cfdocument>
</cffunction>
<cfscript>
	function QueryRow(Query,Row) 
	{
		var tmp = QueryNew(Query.ColumnList);
		QueryAddRow(tmp,1);
		for(x=1;x lte ListLen(tmp.ColumnList);x=x+1) QuerySetCell(tmp, ListGetAt(tmp.ColumnList,x), query[ListGetAt(tmp.ColumnList,x)][row]);
		return tmp;
	}
</cfscript>
<cfset drc_name_ = "#dateformat(now(),'yyyymmdd')#">
<cfif not directoryexists("#upload_folder#reserve_files#dir_seperator##drc_name_#")>
	<cfdirectory action="create" directory="#upload_folder#reserve_files#dir_seperator##drc_name_#">
</cfif>
<cfset file_name_list = "">

<cfquery name="get_all_mails" datasource="#dsn#">
	SELECT 
		E.EMPLOYEE_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.EMPLOYEE_EMAIL,
		EP.SAL_MON,
		EP.SAL_YEAR,
		B.BRANCH_FULLNAME
	FROM
		EMPLOYEES_PUANTAJ EP,
		EMPLOYEES_PUANTAJ_ROWS EPR,
		EMPLOYEES E,
		BRANCH B
	WHERE
		EP.PUANTAJ_ID = #attributes.puantaj_id# AND
		<cfif isdefined("attributes.employee_id")>
			E.EMPLOYEE_ID = #attributes.employee_id# AND
		</cfif>
		E.EMPLOYEE_ID = EPR.EMPLOYEE_ID AND
		EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND
		E.EMPLOYEE_EMAIL IS NOT NULL AND
		B.SSK_NO = EP.SSK_OFFICE_NO AND
		B.SSK_OFFICE = EP.SSK_OFFICE
        <cfif not isdefined('attributes.is_send_all')>
        AND E.EMPLOYEE_ID NOT IN(SELECT EMPLOYEE_ID FROM EMPLOYEES_PUANTAJ_MAILS WHERE SAL_YEAR = EP.SAL_YEAR AND SAL_MON = EP.SAL_MON AND BRANCH_ID = B.BRANCH_ID)
        </cfif>
</cfquery>
<cfif not get_all_mails.recordcount>
	<script type="text/javascript">
		alert('Puantaj Kaydı Bulunamadı ve/veya Geçerli Hiç Bir Mail Adresi Bulunamadı!');
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cfquery name="get_puantaj" datasource="#dsn#">
		SELECT 
			EP.SSK_OFFICE_NO,
			EP.SSK_OFFICE,
			B.BRANCH_ID,
			EP.SAL_MON,
			EP.SAL_YEAR
		FROM 
			EMPLOYEES_PUANTAJ EP,
			BRANCH B
		WHERE 
			EP.PUANTAJ_ID = #attributes.puantaj_id# AND
			B.SSK_NO = EP.SSK_OFFICE_NO AND
			B.SSK_OFFICE = EP.SSK_OFFICE
	</cfquery>
	<cfset attributes.sal_year = get_puantaj.sal_year>
	<cfset attributes.sal_mon = get_puantaj.sal_mon>
	<cfif not isdefined("attributes.employee_id")>
		<cfquery name="get_old_mails" datasource="#dsn#">
			SELECT 
				ROW_ID 
			FROM 
				EMPLOYEES_PUANTAJ_MAILS 
			WHERE 
				BRANCH_ID = #get_puantaj.BRANCH_ID# AND 
				SAL_MON = #get_puantaj.sal_mon# AND 
				SAL_YEAR = #get_puantaj.sal_year#
		</cfquery>
		<cfif get_old_mails.recordcount>
			<cfquery name="upd_" datasource="#dsn#">
				UPDATE 
					EMPLOYEES_PUANTAJ_MAILS 
				SET 
					LAST_MAIL_DATE = #NOW()#,
					UPDATE_EMP = #session.ep.userid#
				WHERE 
					ROW_ID = #get_old_mails.ROW_ID#
			</cfquery>
		<cfelse>
			<cfquery name="add_" datasource="#dsn#">
				INSERT INTO
					EMPLOYEES_PUANTAJ_MAILS 
					(
					SAL_MON,
					SAL_YEAR,
					BRANCH_ID,
					SSK_OFFICE_NO,
					SSK_OFFICE,
					FIRST_MAIL_DATE,
					RECORD_EMP
					)
					VALUES
					(
					#get_puantaj.sal_mon#,
					#get_puantaj.sal_year#,
					#get_puantaj.BRANCH_ID#,
					'#get_puantaj.SSK_OFFICE_NO#',
					'#get_puantaj.SSK_OFFICE#',
					#now()#,
					#session.ep.userid#		
					)
			</cfquery>
		</cfif>
	</cfif>
<cfif len(attributes.message_type)>
	<cfquery name="get_mail_warnings" datasource="#dsn#">
		SELECT 
			DETAIL 
		FROM 
			SETUP_MAIL_WARNING
		WHERE
			MAIL_CAT_ID = #attributes.message_type#
	</cfquery>
</cfif>
<cfsavecontent variable="message"><cfoutput>#get_all_mails.SAL_YEAR# #listgetat(ay_list(),get_all_mails.SAL_MON)#</cfoutput> Ay Bordrosu</cfsavecontent>
<cfloop query="get_all_mails">
	<cfset active_mail_ = trim(EMPLOYEE_EMAIL)>
	<cfif len(EMPLOYEE_EMAIL)>
		<cfset attributes.employee_id = EMPLOYEE_ID>
		<cfquery name="get_old_mail_emp" datasource="#dsn#">
			SELECT 
				ROW_ID 
			FROM 
				EMPLOYEES_PUANTAJ_MAILS 
			WHERE 
				EMPLOYEE_ID = #EMPLOYEE_ID# AND
				BRANCH_ID = #get_puantaj.branch_id# AND 
				SAL_MON = #get_puantaj.sal_mon# AND 
				SAL_YEAR = #get_puantaj.sal_year#
		</cfquery>
	
		<cfif get_old_mail_emp.recordcount>
			<cfquery name="upd_" datasource="#dsn#">
				UPDATE 
					EMPLOYEES_PUANTAJ_MAILS 
				SET 
					LAST_MAIL_DATE = #NOW()#,
					UPDATE_EMP = #session.ep.userid#
				WHERE 
					ROW_ID = #get_old_mail_emp.ROW_ID#
			</cfquery>
		<cfelse>
			<cfquery name="add_" datasource="#dsn#">
				INSERT INTO
					EMPLOYEES_PUANTAJ_MAILS 
					(
					EMPLOYEE_ID,
					SAL_MON,
					SAL_YEAR,
					BRANCH_ID,
					SSK_OFFICE_NO,
					SSK_OFFICE,
					FIRST_MAIL_DATE,
					RECORD_EMP
					)
					VALUES
					(
					#EMPLOYEE_ID#,
					#get_puantaj.sal_mon#,
					#get_puantaj.sal_year#,
					#get_puantaj.BRANCH_ID#,
					'#get_puantaj.SSK_OFFICE_NO#',
					'#get_puantaj.SSK_OFFICE#',
					#now()#,
					#session.ep.userid#		
					)
			</cfquery>
		</cfif>
		
		<cfif attributes.send_type eq 0>
			<cfmail to="#EMPLOYEE_EMAIL#"
				from="#session.ep.company#<#session.ep.company_email#>"
				subject="#message#" type="HTML">
				Sayın #employee_name# #employee_surname#,
				<br/><br/>
				#SAL_YEAR# #listgetat(ay_list(),SAL_MON)# ayı bordronuza erişmek için aşağıdaki linke tıklayınız.<br/><br/>
				<a href="#employee_domain##request.self#?fuseaction=myhome.list_my_bordro&is_submit=1&sal_mon=#SAL_MON#&sal_year=#SAL_YEAR#" target="_blank">#SAL_YEAR# #listgetat(ay_list(),SAL_MON)# Ayı Bordro</a> <br/><br/>
				
				<cfif len(attributes.message_type)>
					#get_mail_warnings.DETAIL#
				<!--- <cfelse>
					Lütfen bordronuzu kontrol ediniz! --->
				</cfif>
					<!--- <br/><br/>
				Herhangi bir sorunla karşılaşmanız durumunda lütfen insan kaynakları departmanına başvurunuz.<br/><br/>
				#BRANCH_FULLNAME#	 --->	
			</cfmail>
		<cfelse>
			<cfinclude template="../query/get_puantaj_personal.cfm">
			<cfif GET_PUANTAJ_PERSONAL.recordcount>
				<cfset get_ogis.OGI_DAMGA_TOPLAM = 0>
				<cfset get_ogis.OGI_ODENECEK_TOPLAM = 0>
				
				<cfinclude template="get_hours.cfm">
		
				<cfset icmal_type = "personal">
				<cfoutput query="get_puantaj_personal">
					<cfquery name="get_odeneks" datasource="#dsn#">
						SELECT * FROM #ext_puantaj_table# WHERE EMPLOYEE_PUANTAJ_ID = #GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID# AND EXT_TYPE = 0 ORDER BY COMMENT_PAY
					</cfquery>
		
					<cfquery name="get_kesintis" datasource="#dsn#">
						SELECT * FROM #ext_puantaj_table# WHERE EMPLOYEE_PUANTAJ_ID = #GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID# AND EXT_TYPE = 1 ORDER BY COMMENT_PAY
					</cfquery>
		
					<cfquery name="get_vergi_istisnas" datasource="#dsn#">
						SELECT * FROM #ext_puantaj_table# WHERE EMPLOYEE_PUANTAJ_ID = #GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID# AND EXT_TYPE = 2 ORDER BY COMMENT_PAY
					</cfquery>

					<cfquery name="get_kumulatif_gelir_vergisi" datasource="#dsn#" >
						SELECT 
							SUM(EMPLOYEES_PUANTAJ_ROWS.GELIR_VERGISI) AS TOPLAM,
							SUM(EMPLOYEES_PUANTAJ_ROWS.GELIR_VERGISI_MATRAH) AS TOPLAM_MATRAH
						FROM 
							<cfif isdefined("attributes.is_virtual_puantaj") and attributes.is_virtual_puantaj eq 1>
								EMPLOYEES_PUANTAJ_VIRTUAL AS EMPLOYEES_PUANTAJ,
								EMPLOYEES_PUANTAJ_ROWS_VIRTUAL AS EMPLOYEES_PUANTAJ_ROWS
							<cfelse>
								EMPLOYEES_PUANTAJ,
								EMPLOYEES_PUANTAJ_ROWS
							</cfif>
							<cfif get_puantaj_personal.tax_account_style eq 1><!--- şirket içi devir--->
								,BRANCH B
							</cfif>
						WHERE 
							<cfif get_puantaj_personal.tax_account_style eq 1>
								EMPLOYEES_PUANTAJ.SSK_BRANCH_ID = B.BRANCH_ID AND
								B.COMPANY_ID = (SELECT B2.COMPANY_ID FROM BRANCH B2 WHERE B2.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.BRANCH_ID#">) AND
							</cfif>
							EMPLOYEES_PUANTAJ.PUANTAJ_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.puantaj_type#"> AND
							EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID AND 
							EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.sal_year#"> AND 
							(
								EMPLOYEES_PUANTAJ.SAL_MON < <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.sal_mon#">
							)AND
							EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
					</cfquery>
		
					<cfset temp_query_1 = QueryRow(get_puantaj_personal,currentrow)>
					<cfset query_name = "temp_query_1">
					<!--- <cfset filename = "puantaj_#attributes.employee_id#_#attributes.puantaj_id#_#session.ep.userid#"> --->
					<!--- ÖNEMLİ NOT: filename alanından "get_puantaj_personal.employee_puantaj_id" ifadesi kaldırılmasın kişinin birden fazla puantajı var is o ay her puantajın dosya ismi ayrı olmalı Senay 20141010 (iş id :81931)--->
					<cfset filename = "#get_puantaj_personal.employee_puantaj_id#_#listgetat(ay_list(),attributes.SAL_MON)#_#attributes.sal_year#_#employee_name#_#employee_surname#"> 
				<cfsavecontent variable="pdf_cont">
					<style type="text/css" media="print">
						.row, .col, .modal-content, label, div {box-sizing: border-box;}				
					.col-6 {width: 50%!important;float: left;}
					.col-12 {width: 100%!important;}
					.ui-table-list{width:100%;border-collapse:collapse;border-spacing:0;font-size:10px;border:1px solid ##bbb;}			
					.ui-table-list > thead > tr > th a{color:##555;display:block;text-align:center;transition:.4s;}
					.ui-table-list > thead > tr > th a i{color:##555;font-size:10px;font-weight:normal;transition:.4s;}
					.ui-table-list > tfoot > tr > td, .ui-table-list > tbody > tr > td, .ui-table-list > thead > tr > td{border:1px solid ##bbb;font-size:10px;color:##555;min-width:30px;}
					td{font-size:10px!important}
					##wrk_bug_add_div,.portHeadLight,font{ display:none;}	
					</style>
                    <cf_xml_page_edit fuseact="ehesap.popup_view_price_compass">
					<cfinclude template="../display/view_icmal.cfm">
				</cfsavecontent>
				#make_pdf(file_name:'#filename#',pdf_content:'#pdf_cont#')#
				<cfset file_name_list = listappend(file_name_list,filename)>
				<cfmail to="#active_mail_#"
					from="#session.ep.company#<#session.ep.company_email#>"
					subject="#message#" type="HTML">
					<cfmailparam file="#upload_folder#reserve_files#dir_seperator##drc_name_##dir_seperator##filename#.pdf">
					Sayın #employee_name# #employee_surname#,
					<br/><br/>
					#SAL_YEAR# #listgetat(ay_list(),SAL_MON)# ayı bordronuz mail ekindedir. <br/><br/>
					
					<cfif len(attributes.message_type)>
						#get_mail_warnings.DETAIL#
					<!--- <cfelse>
						Lütfen bordronuzu kontrol ediniz! --->
					</cfif>
						<!--- <br/><br/>
					Herhangi bir sorunla karşılaşmanız durumunda lütfen insan kaynakları departmanına başvurunuz.<br/><br/>
					#BRANCH_FULLNAME# --->		
				</cfmail>
				</cfoutput>
			</cfif><!--- puantaji var mi --->
		</cfif><!--- gonderim tipi nedir --->
	</cfif><!--- maili var mi --->
</cfloop>
		
<script type="text/javascript">
	alert('<cf_get_lang dictionary_id="40530.Mailler Başarı İle Gönderildi!">');
	window.close();
</script>
</cfif>
