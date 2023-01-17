<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.branch_list")>
	<cfif workcube_mode><!--- 20041028 production larda schedules sadece server dan calismali --->
		<cfif not listfind('127.0.0.1,192.168.0.2,10.0.0.3,192.168.0.250,192.168.0.251',cgi.REMOTE_ADDR,',')>
			<cfmail to="#ListFirst(Server_Detail)#" from="#listlast(server_detail)#<#listfirst(server_detail)#>" type="html" subject="Yetkisiz ">#cgi.REMOTE_ADDR# (#now()#)</cfmail>
			<cfexit method="exittemplate">
		</cfif>
	</cfif>
	<cfquery name="get_period" datasource="#dsn#">
		SELECT * FROM SETUP_PERIOD WHERE PERIOD_YEAR >= (DATEPART(yyyy,GETDATE())-1)
	</cfquery>
	<cfinclude template="../../objects/functions/sales_import_functions.cfm">
	<cfset log_date_now=now()>
	
	<cfloop query="get_period">
		<cfif database_type eq "MSSQL">
			<cfset dsn2 = "#dsn#_#get_period.period_year#_#get_period.our_company_id#">
		<cfelseif database_type eq "DB2">
			<cfset dsn2 = "#dsn#_#get_period.our_company_id#_#MID(get_period.period_year,3,2)#">
		</cfif>
		<cfset dsn3 = "#dsn#_#get_period.our_company_id#">
		<cfquery name="GET_SALES_IMPORTS" datasource="#DSN2#">
			SELECT
				FI.I_ID,
				FI.STARTDATE,
				B.BRANCH_NAME
			FROM
				FILE_IMPORTS FI,
				#dsn_alias#.DEPARTMENT D,
				#dsn_alias#.BRANCH B
			WHERE
				B.BRANCH_ID IN (#attributes.branch_list#) AND
				FI.IMPORTED = 0 AND
				D.BRANCH_ID = B.BRANCH_ID AND
				FI.DEPARTMENT_ID = D.DEPARTMENT_ID AND
				PROCESS_TYPE = -2
			ORDER BY
				FI.STARTDATE 
		</cfquery>
		
		<cfif get_sales_imports.recordcount>
			<cfset hatali_dosyalar = ''>
			<cfloop query="get_sales_imports">
				<cfquery name="CHECK_IMPORTED" datasource="#DSN2#">
					SELECT I_ID FROM FILE_IMPORTS WHERE IMPORTED = 1 AND I_ID = #get_sales_imports.i_id#
				</cfquery>
				<!--- BK 20080810 scheludes calısması sırasında islenmis dosyaların olabilecegi dusunulerek eklendi. --->
				<cfif not check_imported.recordcount>
					<cfset hata_flag = 0>
					<cfset attributes.i_id=get_sales_imports.i_id>
					<cfinclude template="../../objects/query/sales_import.cfm">
					<cfif hata_flag>
						<cfset hatali_dosyalar = listappend(hatali_dosyalar,get_sales_imports.i_id,',')>
					</cfif>
				</cfif>
			</cfloop>
			<cfset log_date_diff=datediff("n",log_date_now,now())>
			<cflog text="#get_sales_imports.recordcount-listlen(hatali_dosyalar,',')# Adet Satis Dosyasi (#get_period.period#) icin #log_date_now# ile #now()# saatleri arasinda #log_date_diff# dakikada veritabanina basariyla islenmistir. #listlen(hatali_dosyalar,',')# adet dosya problemliydi (FILE_IMPORTS.I_ID ler:#hatali_dosyalar#)." file="workcube_schedule" application="yes" date="yes">
		</cfif>
	</cfloop>
</cfif>
