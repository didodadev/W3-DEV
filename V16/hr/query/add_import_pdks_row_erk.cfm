<cfloop from="2" to="#line_count#" index="i">
	<cfset kont=1>
	<cftry>
		<cfset pdks_no = trim(listgetat(dosya1[i],1,';'))>
		<cfset gun = trim(listgetat(dosya1[i],2,';'))>
		<cfset ay = trim(listgetat(dosya1[i],3,';'))>
		<cfset yil = trim(listgetat(dosya1[i],4,';'))>
		<cfset saat = trim(listgetat(dosya1[i],5,';'))>
		<cfset dakika = trim(listgetat(dosya1[i],6,';'))>
		<cfset baslama_tarih_ = '#ay#/#gun#/#yil#'>
		<cfset c_ = createodbcdatetime(baslama_tarih_)>
		<cfset baslama_tarih = baslama_tarih_>
		<cfset baslama_tarih = date_add('h',saat,baslama_tarih)>
		<cfset baslama_tarih = date_add('n', dakika, baslama_tarih)>
		<cfcatch type="Any">
			<cfoutput>#i#. Satır Okuma Hatalı!<br/></cfoutput>	
			<cfset kont=0>
		</cfcatch>  
	</cftry>	
	<cftry>
		<cfquery name="get_in_out" datasource="#dsn#" maxrows="1">
			SELECT EMPLOYEE_ID,IN_OUT_ID,BRANCH_ID FROM EMPLOYEES_IN_OUT WHERE PDKS_NUMBER = '#pdks_no#' ORDER BY FINISH_DATE DESC
		</cfquery>
		
		<cfif get_in_out.recordcount>
			<cfquery name="get_daily_in" datasource="#dsn#">
				SELECT 
					ROW_ID 
				FROM 
					EMPLOYEE_DAILY_IN_OUT 
				WHERE 
					EMPLOYEE_ID = #get_in_out.employee_id# AND 
					FINISH_DATE IS NULL AND
					START_DATE >= #createodbcdatetime(baslama_tarih_)# AND
					START_DATE < #DATEADD("d",1,baslama_tarih_)#
					AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0
			</cfquery>

			<cfquery name="get_offtime" dbtype="query">
				SELECT * FROM get_offtimes WHERE START_DATE <= #createodbcdatetime(baslama_tarih_)# AND FINISH_DATE >= #createodbcdatetime(baslama_tarih_)#
			</cfquery>

			<cfif get_offtime.recordcount eq 1>
				<cfset day_type_ = 2>
			<cfelseif dayofweek(createodbcdatetime(baslama_tarih_)) eq 1>
				<cfset day_type_ = 1>
			<cfelse>
				<cfset day_type_ = 0>
			</cfif>
				<cfif get_daily_in.recordcount eq 0>
					<cfquery name="add_row" datasource="#dsn#">
						INSERT INTO 
							EMPLOYEE_DAILY_IN_OUT
							(
								FILE_ID,
								DAY_TYPE,
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
								#attributes.i_id#,
								#day_type_#,
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
					<cfquery name="upd_row" datasource="#dsn#">
						UPDATE
							EMPLOYEE_DAILY_IN_OUT
						SET
							FINISH_DATE = #baslama_tarih#
						WHERE 
							ROW_ID = #get_daily_in.row_id#				
					</cfquery>	
				</cfif>
		</cfif>	
		<cfcatch type="Any">
			<cfoutput>#i#. Satır Yazma Hatalı!<br/></cfoutput>	
			<cfset kont=0>
		</cfcatch> 
	</cftry>
</cfloop>
