<cfset bulunamayan_listesi = ''>
<cfloop from="1" to="#line_count#" index="i">
	<cfset kont=1>
	<cftry>
		<cfset pdks_no = trim(listgetat(dosya1[i],2,','))>
		<cfset start_date = trim(listgetat(dosya1[i],4,','))>
		<cfset start_hour = trim(listgetat(dosya1[i],5,','))>

		<cfset gun = listlast(start_date,'/')>
		<cfset ay = listgetat(start_date,2,'/')>
		<cfset yil = listfirst(start_date,'/')>
		<cfset saat = listfirst(start_hour,':')>
		<cfset dakika = listgetat(start_hour,2,':')>
		<cfset baslama_tarih = '#ay#/#gun#/#yil#'>
		<cfset baslama_gun = baslama_tarih>
		<cfset baslama_tarih = dateadd('h',saat,baslama_tarih)>
		<cfset baslama_tarih = dateadd('n',dakika,baslama_tarih)>
		<cfcatch type="Any">
			<cfset kont=0>
			<cfoutput>#i#</cfoutput>.satır okuma esnasında hata verdi.<br />
		</cfcatch>
	</cftry>

	<cfif kont eq 1>
			<cfquery name="get_in_out" dbtype="query" maxrows="1">
				SELECT EMPLOYEE_ID,IN_OUT_ID,BRANCH_ID FROM get_in_outs WHERE PDKS_NUMBER = '#pdks_no#' ORDER BY FINISH_DATE DESC
			</cfquery>
		
			<cfif get_in_out.recordcount>
				<cfquery name="get_daily_in" datasource="#dsn#">
					SELECT * FROM EMPLOYEE_DAILY_IN_OUT WHERE EMPLOYEE_ID = #get_in_out.employee_id# AND FINISH_DATE IS NULL AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0 AND (START_DATE BETWEEN #createodbcdatetime(baslama_gun)# AND #createodbcdatetime(DATEADD("d",1,baslama_gun))#)
				</cfquery>					

					<cfif get_daily_in.recordcount eq 0>
						<cfoutput>daily de kayıt var: #attributes.i_id#, #get_in_out.employee_id#</cfoutput>,<br />
						<cfquery name="add_row" datasource="#dsn#">
						INSERT INTO 
							EMPLOYEE_DAILY_IN_OUT
							(
								FILE_ID,
								EMPLOYEE_ID,
								IN_OUT_ID,
								BRANCH_ID,
								START_DATE,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP
							)
							VALUES
							(
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.i_id#">,
								#get_in_out.employee_id#,
								#get_in_out.in_out_id#,
								#get_in_out.branch_id#,
								#baslama_tarih#,
								#now()#,
								#session.ep.userid#,
								'#cgi.REMOTE_ADDR#'
							)
						</cfquery>
					<cfelse>
						kayıt yok update ediliyor..<br />
						<cfquery name="upd_row" datasource="#dsn#">
							UPDATE
								EMPLOYEE_DAILY_IN_OUT
							SET
								FINISH_DATE = #baslama_tarih#
							WHERE
								ROW_ID = #get_daily_in.row_id#
						</cfquery>
					</cfif>
				<cfoutput>#i#.satır kişi (#pdks_no#) kayıt yapıldı!</cfoutput><br/><br />
			<cfelse>
				<cfoutput>#i#.satır kişi (#pdks_no#)bulunamadı!</cfoutput><br /><br />
				<cfset bulunamayan_listesi = listappend(bulunamayan_listesi,'#pdks_no#')>
			</cfif>
	</cfif>
</cfloop>
<cfquery name="get_daily_by_fileID" datasource="#DSN#">
	SELECT
		EMPLOYEE_ID,
		IN_OUT_ID,
		BRANCH_ID,
		MIN(START_DATE) AS STARTDATE,
		MAX(FINISH_DATE) AS FINISH_SON,
		MAX(START_DATE) AS START_SON
	FROM
		EMPLOYEE_DAILY_IN_OUT
	WHERE
		FILE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.i_id#">
	GROUP BY
		EMPLOYEE_ID,
		IN_OUT_ID,
		BRANCH_ID,
		DAY(START_DATE),
		MONTH(START_DATE)
</cfquery>
<cfquery name="del_" datasource="#dsn#">
	DELETE FROM EMPLOYEE_DAILY_IN_OUT WHERE FILE_ID = #attributes.i_id#
</cfquery>
<cfoutput query="get_daily_by_fileID">
	<cfif FINISH_SON gt START_SON>
		<cfset FINISHDATE_ = FINISH_SON>
	<cfelse>
		<cfset FINISHDATE_ = START_SON>
	</cfif>
	<cfif STARTDATE gt FINISHDATE_>
		<cfset R_STARTDATE = FINISHDATE_>
		<cfset R_FINISHDATE_ = STARTDATE>
	<cfelse>
		<cfset R_STARTDATE = STARTDATE>
		<cfset R_FINISHDATE_ = FINISHDATE_>
	</cfif>
	<cfquery name="son_daily_ekle" datasource="#DSN#">
		INSERT INTO
			EMPLOYEE_DAILY_IN_OUT
			(
				FILE_ID,
				EMPLOYEE_ID,
				IN_OUT_ID,
				BRANCH_ID,
				START_DATE,
				FINISH_DATE,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.i_id#">,
				#EMPLOYEE_ID#,
				#in_out_id#,
				#branch_id#,
				#CreateODBCDateTime(R_STARTDATE)#,
				#CreateODBCDateTime(R_FINISHDATE_)#,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
</cfoutput>
<cfoutput>Bulunamayanlar Listesi : #listdeleteduplicates(bulunamayan_listesi)#</cfoutput>
<br /><br />İşlem Tamamlandı!
