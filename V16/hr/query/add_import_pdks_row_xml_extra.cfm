<cfquery name="get_imports_all" datasource="#dsn#">
	SELECT
		EIO.START_DATE,
		EIO.FINISH_DATE,
		EIO.IN_OUT_ID,
		EIO.EMPLOYEE_ID,
		EP.UPPER_POSITION_CODE,
		EP.UPPER_POSITION_CODE2,
		SUM(DATEDIFF(MINUTE,EIO.START_DATE,EIO.FINISH_DATE)) AS TOTAL_MIN
	FROM 
		EMPLOYEE_DAILY_IN_OUT EIO,
		EMPLOYEES_IN_OUT EI,
		EMPLOYEE_POSITIONS EP
	WHERE 
		EIO.FINISH_DATE IS NOT NULL AND
		(
		EIO.FILE_ID = #attributes.i_id#
		OR
		EIO.FILE2_ID = #attributes.i_id#
		)
		AND
		EIO.IN_OUT_ID = EI.IN_OUT_ID AND
		EP.EMPLOYEE_ID = EI.EMPLOYEE_ID AND
		EP.IS_MASTER = 1 AND
		EP.COLLAR_TYPE = 1
		AND ISNULL(ED.FROM_HOURLY_ADDFARE,0) = 0
	GROUP BY
		EIO.START_DATE,
		EIO.FINISH_DATE,
		EIO.IN_OUT_ID,
		EIO.EMPLOYEE_ID,
		EP.UPPER_POSITION_CODE,
		EP.UPPER_POSITION_CODE2
</cfquery>
	
<cfoutput query="get_imports_all">
	<cfif listfindnocase(general_offtime_days_,dateformat(START_DATE,'dd.mm.yyyy')) or dayofweek(START_DATE) eq 1 or dayofweek(START_DATE) eq 7>
	<!--- resmi tatil,pazar veya cumartesi calismasi icin --->
		<cfset toplam_dakika_ = TOTAL_MIN>
		
		<cfset baslangic_saat_ = timeformat(START_DATE,'HH')>
		<cfset baslangic_dakika_ = timeformat(START_DATE,'MM')>
		<cfset bitis_saat_ = timeformat(FINISH_DATE,'HH')>
		<cfset bitis_dakika_ = timeformat(FINISH_DATE,'MM')>
		
		<cfif baslangic_saat_ lt 8> <!--- sekizden once gelsede 8 say --->
			<cfset baslangic_saat_ = 8>
			<cfset baslangic_dakika_ = 0>
		</cfif>
		
		<cfset saat_fark_ = bitis_saat_ - baslangic_saat_>
		<cfset toplam_dakika_ = saat_fark_ * 60>
		<cfset toplam_dakika_ = toplam_dakika_ - baslangic_dakika_>
		<cfset toplam_dakika_ = toplam_dakika_ + bitis_dakika_>
		
		<cfset new_date_ = createdatetime(year(START_DATE),month(START_DATE),day(START_DATE),8,0,0)>
			<cfset hafta_gunu_ = DayOfWeek(new_date_)>
			<cfset mesai_dakika_ = toplam_dakika_>
			
			<cfquery name="add_" datasource="#dsn#">
			INSERT INTO
				EMPLOYEES_EXT_WORKTIMES
				(
				IS_PUANTAJ_OFF,
				IS_FROM_PDKS,
				PDKS_FILE_ID,
				EMPLOYEE_ID,
				IN_OUT_ID,
				DAY_TYPE,
				VALIDATOR_POSITION_CODE_1,
				VALIDATOR_POSITION_CODE_2,
				START_TIME,
				END_TIME,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
				)
				VALUES
				(
				1,
				1,
				#attributes.i_id#,
				#employee_id#,
				#in_out_id#,
				<cfif listlen(general_offtime_days_) and listfindnocase(general_offtime_days_,'#dateformat(new_date_,'dd.mm.yyyy')#')>2<cfelseif hafta_gunu_ eq 1>1<cfelse>0</cfif>,
				<cfif len(UPPER_POSITION_CODE)>#UPPER_POSITION_CODE#,<cfelse>NULL,</cfif>
				<cfif len(UPPER_POSITION_CODE2)>#UPPER_POSITION_CODE2#,<cfelse>NULL,</cfif>
				#createodbcdatetime(new_date_)#,
				#createodbcdatetime(date_add("n",mesai_dakika_,new_date_))#,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
				)
			</cfquery>
	<cfelse>
		<!--- normal gün --->
		<cfset is_mesai_ = 1>
		<cfset baslangic_saat_ = timeformat(START_DATE,'HH')>
		<cfset baslangic_dakika_ = timeformat(START_DATE,'MM')>
		<cfset bitis_saat_ = timeformat(FINISH_DATE,'HH')>
		<cfset bitis_dakika_ = timeformat(FINISH_DATE,'MM')>
		<cfset fark_ = 660>
		<cfset toplam_dakika_ = TOTAL_MIN>
		
		<cfif baslangic_saat_ lt 8> <!--- sekizden once gelsede 8 say --->
			<cfset baslangic_saat_ = 8>
			<cfset baslangic_dakika_ = 0>
		</cfif>
		
		<cfif bitis_saat_ lt 19 or (bitis_saat_ eq 19 and bitis_dakika_ lt 31)> <!--- 1930 dan önce çıkmışsa mesai yazma --->
			<cfset is_mesai_ = 0>
		</cfif>
		
		<cfif is_mesai_ eq 1 and TOTAL_MIN gt fark_>
			<cfset saat_fark_ = bitis_saat_ - baslangic_saat_>
			<cfset toplam_dakika_ = saat_fark_ * 60>
			<cfset toplam_dakika_ = toplam_dakika_ - baslangic_dakika_>
			<cfset toplam_dakika_ = toplam_dakika_ + bitis_dakika_>
		</cfif>
	
		<cfif is_mesai_ eq 1 and toplam_dakika_ gt fark_>
			<cfset new_date_ = createdatetime(year(START_DATE),month(START_DATE),day(START_DATE),19,0,0)>
			<cfset hafta_gunu_ = DayOfWeek(new_date_)>
			<cfset mesai_dakika_ = toplam_dakika_ - fark_>
			
			<cfquery name="add_" datasource="#dsn#">
				INSERT INTO
					EMPLOYEES_EXT_WORKTIMES
					(
					IS_PUANTAJ_OFF,
					IS_FROM_PDKS,
					PDKS_FILE_ID,
					EMPLOYEE_ID,
					IN_OUT_ID,
					DAY_TYPE,
					VALIDATOR_POSITION_CODE_1,
					VALIDATOR_POSITION_CODE_2,
					START_TIME,
					END_TIME,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
					)
					VALUES
					(
					1,
					1,
					#attributes.i_id#,
					#employee_id#,
					#in_out_id#,
					<cfif listlen(general_offtime_days_) and listfindnocase(general_offtime_days_,'#dateformat(new_date_,'dd.mm.yyyy')#')>2<cfelseif hafta_gunu_ eq 1>1<cfelse>0</cfif>,
					<cfif len(UPPER_POSITION_CODE)>#UPPER_POSITION_CODE#,<cfelse>NULL,</cfif>
					<cfif len(UPPER_POSITION_CODE2)>#UPPER_POSITION_CODE2#,<cfelse>NULL,</cfif>
					#createodbcdatetime(new_date_)#,
					#createodbcdatetime(date_add("n",mesai_dakika_,new_date_))#,
					#now()#,
					#session.ep.userid#,
					'#cgi.REMOTE_ADDR#'
					)
			</cfquery>
		</cfif>
	</cfif>
</cfoutput>
