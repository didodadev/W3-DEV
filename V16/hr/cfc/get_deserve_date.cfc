<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dateformat_style = session.ep.dateformat_style>
	<cffunction name="get_def_type" access="public" returntype="query">
		<cfargument name="startdate" default="">
	    <cfargument name="finishdate" default="">
	    <cfargument name="group_id" default="">
		<cfquery name="get_def_type_" datasource="#dsn#">
			SELECT TOP 1 
				DEFINITION_TYPE,
				ISNULL(LIMIT_1_DAYS,0) LIMIT_1_DAYS,
				ISNULL(LIMIT_2_DAYS,0) LIMIT_2_DAYS,
				ISNULL(LIMIT_3_DAYS,0) LIMIT_3_DAYS,
				ISNULL(LIMIT_4_DAYS,0) LIMIT_4_DAYS,
				MIN_MAX_DAYS,
				MIN_YEARS,
				MAX_YEARS,
				LIMIT_1,
				LIMIT_2,
				LIMIT_3,
				LIMIT_ID
			FROM 
				SETUP_OFFTIME_LIMIT 
			WHERE 
				STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#"> AND 
				FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishdate#">
				<cfif len(arguments.group_id)>
					AND ( <cfloop from="1" to="#listlen(arguments.group_id,',')#" index="i">
					  	','+PUANTAJ_GROUP_IDS+',' LIKE '%,#listgetat(arguments.group_id,i,",")#,%' 
					  	<cfif i neq listlen(arguments.group_id,',')>OR</cfif>
					  </cfloop>
					OR PUANTAJ_GROUP_IDS IS NULL) ORDER BY PUANTAJ_GROUP_IDS DESC
				</cfif>
		</cfquery>
		<cfreturn get_def_type_>
	</cffunction>
	<cffunction name="get_bos_zaman" access="public" returntype="query">
		<cfargument name="employee_id" default="">
		<cfargument name="baslangic_tarihi" default="">
		<cfargument name="bitis_tarihi" default="">
		<cfquery name="get_bos_zaman_" datasource="#dsn#">
			SELECT 
				* 
			FROM 
				EMPLOYEE_PROGRESS_PAYMENT_OUT 
			WHERE 
				EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"> AND 
				START_DATE IS NOT NULL AND 
				FINISH_DATE IS NOT NULL AND 
				IS_YEARLY = 1 AND
				((
					START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.baslangic_tarihi#"> AND 
					FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.baslangic_tarihi#">
				) OR 
				(
					START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.baslangic_tarihi#"> AND 
					FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.bitis_tarihi#">
				) OR 
				(
					(START_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.baslangic_tarihi#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.bitis_tarihi#">) AND 
					FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.bitis_tarihi#">
				))
		</cfquery>
		<cfreturn get_bos_zaman_>
	</cffunction>
	<cffunction name="get_date" access="remote" returntype="any" returnformat="plain">
		<cfargument name="employee_id" default="">
		<cfquery name="get_emp" datasource="#dsn#">
			SELECT 
				E.EMPLOYEE_ID,
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				E.KIDEM_DATE,
				E.IZIN_DATE,
				E.IZIN_DAYS,
				EI.BIRTH_DATE,
				E.GROUP_STARTDATE,
				(SELECT TOP 1 PUANTAJ_GROUP_IDS FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID AND (FINISH_DATE IS NULL OR FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">) AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> ORDER BY START_DATE DESC) AS PUANTAJ_GROUP_IDS
			FROM
				EMPLOYEES E
				INNER JOIN EMPLOYEES_IDENTY EI ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
			WHERE 
				E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
		</cfquery>
		<cfscript>
			returndate = '';
			if (get_emp.recordcount and len(get_emp.izin_date))
			{
				tmp_def_type = 1;
		
				tck = 0;
				tck_ = 0;
				my_giris_date = get_emp.izin_date;
				flag = true;
				baslangic_tarih_ = my_giris_date;
				my_baz_date = now();
				employee_id_ = get_emp.employee_id;
				tmp_baslangic_tarih_ = createodbcdatetime(baslangic_tarih_);
				def_type = get_def_type(startdate:tmp_baslangic_tarih_,finishdate:my_baz_date,group_id:get_emp.puantaj_group_ids);
				if(def_type.recordcount)
				{
					tmp_def_type = def_type.definition_type;
				}
				if(tmp_def_type eq 0)
				{
					tck = datediff('yyyy',my_giris_date,my_baz_date) + 1;
					while(flag)
					{
						bitis_tarihi_ = createodbcdatetime(dateadd("m",def_type.limit_1,baslangic_tarih_));
						baslangic_tarih_ = createodbcdatetime(baslangic_tarih_);
						get_bos_zaman_ = get_bos_zaman(employee_id:employee_id_,baslangic_tarihi:baslangic_tarih_,bitis_tarihi:bitis_tarihi_);
						if(get_bos_zaman_.recordcount)
						{
							eklenecek_gun = 0;
							for(izd = 1; izd lte get_bos_zaman_.recordcount; izd=izd+1)
							{
								if(datediff("d",get_bos_zaman_.start_date[izd],baslangic_tarih_) gt 0)
									fark_ = datediff("d",baslangic_tarih_,get_bos_zaman_.finish_date[izd]);
								else if(datediff("d",get_bos_zaman_.start_date[izd],baslangic_tarih_) lte 0)
									fark_ = datediff("d",get_bos_zaman_.start_date[izd],get_bos_zaman_.finish_date[izd]);
								eklenecek_gun = eklenecek_gun + fark_;
							}
							bitis_tarihi_ = dateadd("d",eklenecek_gun,bitis_tarihi_);
							
							tck_ = tck_ + 1;
						}
						ilk_tarih_ = baslangic_tarih_;
						baslangic_tarih_ = bitis_tarihi_;
						bitis_tarihi_ = dateadd("m",def_type.limit_1,bitis_tarihi_);
						if(datediff("d",baslangic_tarih_,now()) lt 0)
							flag = false;
					}
				}
				else
				{
					while(flag)
					{
						bitis_tarihi_ = createodbcdatetime(dateadd("yyyy",1,baslangic_tarih_));
						baslangic_tarih_ = createodbcdatetime(baslangic_tarih_);
						get_bos_zaman_ = get_bos_zaman(employee_id:employee_id_,baslangic_tarihi:baslangic_tarih_,bitis_tarihi:bitis_tarihi_);
						
						if(get_bos_zaman_.recordcount)
						{
							eklenecek_gun = 0;
							for(izd = 1; izd lte get_bos_zaman_.recordcount; izd=izd+1)
							{
								if(datediff("d",get_bos_zaman_.start_date[izd],baslangic_tarih_) gt 0)
									fark_ = datediff("d",baslangic_tarih_,get_bos_zaman_.finish_date[izd]);
								else if(datediff("d",get_bos_zaman_.start_date[izd],baslangic_tarih_) lte 0)
									fark_ = datediff("d",get_bos_zaman_.start_date[izd],get_bos_zaman_.finish_date[izd]);
								eklenecek_gun = eklenecek_gun + fark_;
							}
							
							bitis_tarihi_ = dateadd("d",eklenecek_gun,bitis_tarihi_);
							tck = tck + 1;
							get_offtime_limit=get_def_type(startdate:bitis_tarihi_,finishdate:bitis_tarihi_,group_id:get_emp.puantaj_group_ids);
							if(not get_offtime_limit.recordcount)
								returndate = '';
						}
						if(datediff("yyyy",bitis_tarihi_,now()) lt 0)
							flag = false;
						else
						{
							ilk_tarih_ = baslangic_tarih_;
							baslangic_tarih_ = bitis_tarihi_;
							bitis_tarihi_ = dateadd("yyyy",1,bitis_tarihi_);
						}
					}
				}
			}
			if (len(get_emp.izin_date) and datediff("d",ilk_tarih_,get_emp.izin_date) neq 0)
				returndate = ilk_tarih_;
		</cfscript>
		<cfreturn dateformat(returndate,dateformat_style)>
	</cffunction>
</cfcomponent>
