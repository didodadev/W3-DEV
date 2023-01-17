<cfloop from="1" to="#line_count#" index="i">
	<cfset kont=1>
	<cftry>
		<cfset pdks_no = trim(listgetat(dosya1[i],1,' '))>
		<cfset start_date = trim(listgetat(dosya1[i],2,' '))>
		<cfset start_hour = trim(listgetat(dosya1[i],3,' '))>
		<cfset branch_code = trim(listgetat(dosya1[i],4,' '))>
		<cfcatch type="Any">
			<cfoutput>#i#. Satır Hatalı<br/></cfoutput>	
			<cfset kont=0>
		</cfcatch>  
	</cftry>
	<cfset gun = listfirst(start_date,'.')>
	<cfset ay = listgetat(start_date,2,'.')>
	<cfset yil = listlast(start_date,'.')>
	<cfset saat = listfirst(start_hour,':')>
	<cfset dakika = listlast(start_hour,':')>
	<cfset baslama_tarih = '#ay#/#gun#/20#yil#'>
	<cfset baslama_gun = baslama_tarih>
	<cfset baslama_tarih = date_add('h',saat,baslama_tarih)>
	<cfset baslama_tarih = date_add('n', dakika, baslama_tarih)>
	<cfquery name="get_in_out" dbtype="query" maxrows="1">
		SELECT EMPLOYEE_ID,IN_OUT_ID FROM get_in_outs WHERE PDKS_NUMBER = '#pdks_no#' ORDER BY FINISH_DATE DESC
	</cfquery>
	<cfquery name="get_branch_id" dbtype="query" maxrows="1">
		SELECT 
			BRANCH_ID 
		FROM 
			get_branch_ids 
		WHERE 
			BRANCH_PDKS_CODE = '#branch_code#' OR
			BRANCH_PDKS_CODE LIKE '#branch_code#,%' OR
			BRANCH_PDKS_CODE LIKE '%,#branch_code#' OR
			BRANCH_PDKS_CODE LIKE '%,#branch_code#,%'
	</cfquery>
	<cfif get_in_out.recordcount and len(get_in_out.EMPLOYEE_ID) and get_branch_id.recordcount and len(get_branch_id.BRANCH_ID)>
		<cfquery name="get_daily_in" datasource="#dsn#">
			SELECT 
            	ROW_ID, 
                FILE_ID, 
                EMPLOYEE_ID, 
                IN_OUT_ID, 
                BRANCH_ID, 
                START_DATE, 
                FINISH_DATE, 
                RECORD_DATE, 
                RECORD_IP, 
                RECORD_EMP, 
                DAY_TYPE 
            FROM 
            	EMPLOYEE_DAILY_IN_OUT
            WHERE 
        	    EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_in_out.employee_id#">
            AND 
    	        FINISH_DATE IS NULL 
            AND 
	            (START_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(baslama_gun)#"> 
            AND 
            	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(dateadd('d',1,baslama_gun))#">)
			AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0
		</cfquery>					
		<cfif get_daily_in.recordcount>
			<cfquery name="get_control_satir" dbtype="query">
				SELECT ROW_ID FROM get_daily_in WHERE START_DATE BETWEEN #createodbcdatetime(baslama_tarih)# AND #createodbcdatetime(DATEADD("n",5,baslama_tarih))#
			</cfquery>						
			<cfif get_control_satir.recordcount>
				<cfset control_ = 1>
			<cfelse>
				<cfquery name="get_control_satir_2" dbtype="query">
					SELECT ROW_ID FROM get_daily_in WHERE FINISH_DATE BETWEEN #createodbcdatetime(baslama_tarih)# AND #createodbcdatetime(DATEADD("n",5,baslama_tarih))#
				</cfquery>							
				<cfif get_control_satir_2.recordcount>
					<cfset control_ = 1>
				<cfelse>
					<cfset control_ = 0>
				</cfif>
			</cfif>
		<cfelse>
			<cfquery name="get_daily_in_out" datasource="#dsn#">
				SELECT * FROM EMPLOYEE_DAILY_IN_OUT WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_in_out.employee_id#"> AND FINISH_DATE IS NOT NULL AND (START_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(baslama_gun)#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(DATEADD('d',1,baslama_gun))#">) AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0
			</cfquery>
			<cfif get_daily_in_out.recordcount>	
				<cfquery name="get_control_satir" dbtype="query">
					SELECT ROW_ID FROM get_daily_in_out WHERE START_DATE BETWEEN #createodbcdatetime(baslama_tarih)# AND #createodbcdatetime(DATEADD("n",5,baslama_tarih))#
				</cfquery>						
				<cfif get_control_satir.recordcount>
					<cfset control_ = 1>
				<cfelse>
					<cfquery name="get_control_satir_2" dbtype="query">
						SELECT ROW_ID FROM get_daily_in_out WHERE FINISH_DATE BETWEEN #createodbcdatetime(baslama_tarih)# AND #createodbcdatetime(DATEADD("n",5,baslama_tarih))#
					</cfquery>							
					<cfif get_control_satir_2.recordcount>
						<cfset control_ = 1>
					<cfelse>
						<cfset control_ = 0>
					</cfif>
				</cfif>
			<cfelse>
				<cfset control_ = 0>
			</cfif>
		</cfif>
		<cfif control_ eq 0>
			<cfif get_daily_in.recordcount eq 0>
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
							<cfqueryparam cfsqltype="cf_sql_integer" value="#get_in_out.employee_id#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#get_in_out.in_out_id#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#get_branch_id.branch_id#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#baslama_tarih#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
						)
				</cfquery>
			<cfelse>
				<cfquery name="upd_row" datasource="#dsn#">
					UPDATE
						EMPLOYEE_DAILY_IN_OUT
					SET
						FINISH_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#baslama_tarih#">
					WHERE 
						ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_daily_in.row_id#">				
				</cfquery>	
			</cfif>
		</cfif>
	</cfif>
</cfloop>
