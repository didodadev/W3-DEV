<cfcomponent>
	<cffunction name="cfquery" returntype="any" output="false">
		<cfargument name="SQLString" type="string" required="true">
		<cfargument name="Datasource" type="string" required="true">
		<cfargument name="dbtype" type="string" required="no">
		<cfargument name="is_select" type="boolean" required="no" default="true">
		
		<cfif isdefined("arguments.dbtype") and len(arguments.dbtype)>
			<cfquery name="workcube_cf_query" dbtype="query">
				#preserveSingleQuotes(arguments.SQLString)#
			</cfquery>
		<cfelse>
			<cfquery name="workcube_cf_query" datasource="#arguments.Datasource#">
				#preserveSingleQuotes(arguments.SQLString)#
			</cfquery>
		</cfif>
		<cfif arguments.is_select>
			<cfreturn workcube_cf_query>
		<cfelse>
			<cfreturn true>
		</cfif>
	</cffunction>
	<cfset dsn = application.systemParam.systemParam().dsn>
<cffunction name="F_Employee_Offtime" access="remote" returntype="string" output="yes">
<cfargument name="employee_id" type="string" required="yes">
<cfargument name="is_view_last_year" type="string" default="1" required="no">
<cfset employee_id_ = arguments.employee_id>
<cfquery name="get_employee" datasource="#dsn#">
	SELECT
		E.IZIN_DATE,
		E.IZIN_DAYS,
		EI.BIRTH_DATE 
	FROM 
		EMPLOYEES E,
		EMPLOYEES_IDENTY EI
	WHERE 
		E.EMPLOYEE_ID = #employee_id_# AND
		EI.EMPLOYEE_ID = E.EMPLOYEE_ID
</cfquery>

<cfif get_employee.recordcount and len(get_employee.IZIN_DATE)>
	<cfquery name="GET_GENERAL_OFFTIMES" datasource="#dsn#">
		SELECT START_DATE,FINISH_DATE FROM SETUP_GENERAL_OFFTIMES
	</cfquery>
	<cfif len(get_employee.izin_days)>
		<cfset old_days = get_employee.izin_days>
	<cfelse>
		<cfset old_days = 0>
	</cfif>
	<cfset my_baz_date = now()>
	<cfset offday_list = ''>
	<cfoutput query="GET_GENERAL_OFFTIMES">
		<cfscript>
			offday_gun = datediff('d',GET_GENERAL_OFFTIMES.start_date,GET_GENERAL_OFFTIMES.finish_date)+1;
			offday_startdate = DATEADD("h",2, GET_GENERAL_OFFTIMES.start_date); 
			offday_finishdate = DATEADD("h",2, GET_GENERAL_OFFTIMES.finish_date);
			
			for (mck=0; mck lt offday_gun; mck=mck+1)
				{
				temp_izin_gunu = DATEADD("d",mck,offday_startdate);
				daycode = '#dateformat(temp_izin_gunu,'dd/mm/yyyy')#';
				if(not listfindnocase(offday_list,'#daycode#'))
					offday_list = listappend(offday_list,'#daycode#');
				}
		</cfscript>
	</cfoutput><cfquery name="get_offtime_limits" datasource="#dsn#">
		SELECT * FROM SETUP_OFFTIME_LIMIT
	</cfquery>
	
	<cfquery name="get_progress_payment_outs" datasource="#dsn#">
		SELECT * FROM EMPLOYEE_PROGRESS_PAYMENT_OUT WHERE EMP_ID = #employee_id_#
	</cfquery>
	
	<cfquery name="get_offtime" datasource="#dsn#">
		SELECT 
			OFFTIME.*,
			SETUP_OFFTIME.OFFTIMECAT_ID,
			SETUP_OFFTIME.OFFTIMECAT
		FROM 
			OFFTIME,
			SETUP_OFFTIME
		WHERE
			SETUP_OFFTIME.OFFTIMECAT_ID=OFFTIME.OFFTIMECAT_ID AND
			OFFTIME.IS_PUANTAJ_OFF = 0 AND
			OFFTIME.VALID = 1 AND
			SETUP_OFFTIME.IS_PAID = 1 AND
			SETUP_OFFTIME.IS_YEARLY = 1
			AND
			EMPLOYEE_ID=#employee_id_#
			AND STARTDATE >= #createodbcdatetime(get_employee.IZIN_DATE)#		
		ORDER BY
			STARTDATE DESC
	</cfquery>
	
	<cfset kisi_izin_toplam = 0>
	<cfset kisi_izin_sayilmayan = 0>
	
	<cfset genel_izin_toplam = 0>
	<cfset izin_sayilmayan = 0>
	<cfset resmi_izin_sayilmayan = 0>
	
	<cfif get_offtime.recordcount>
		<CFLOOP query="get_offtime">
			<cfquery name="get_offtime_cat" datasource="#dsn#" maxrows="1">
				SELECT * FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= '#get_offtime.startdate#'  AND FINISHDATE >= '#get_offtime.startdate#'
			</cfquery>
			<cfif get_offtime_cat.recordcount and len(get_offtime_cat.SATURDAY_ON)>
				<cfset saturday_on = get_offtime_cat.SATURDAY_ON>
			<cfelse>
				<cfset saturday_on = 1>
			</cfif>
			<cfif get_offtime_cat.recordcount and len(get_offtime_cat.DAY_CONTROL)>
				<cfset day_control_ = get_offtime_cat.DAY_CONTROL>
			<cfelse>
				<cfset day_control_ = 0>
			</cfif>
			<cfif len(get_employee.IZIN_DATE)>
				<cfset kidem=datediff('d',get_employee.IZIN_DATE,get_offtime.startdate)>
			<cfelse>
				<cfset kidem=0>
			</cfif>
			<cfset kidem_yil=kidem/365>
			<cfscript>
				temporary_sunday_total = 0;
				temporary_resmi_total = 0;
				temporary_offday_total=0;
				temporary_halfday_total = 0;
				total_izin = datediff('d',get_offtime.startdate,get_offtime.finishdate)+1;
				izin_startdate = dateadd("h",2, get_offtime.startdate); 
				izin_finishdate = dateadd("h",2, get_offtime.finishdate);
				for (mck=0; mck lt total_izin; mck=mck+1)
					{
					temp_izin_gunu = dateadd("d",mck,izin_startdate);
					daycode = '#dateformat(temp_izin_gunu,'dd/mm/yyyy')#';
					if (dayofweek(temp_izin_gunu) eq 1)
						temporary_sunday_total = temporary_sunday_total + 1;
					else if (dayofweek(temp_izin_gunu) eq 7 and saturday_on eq 0)
						temporary_sunday_total = temporary_sunday_total + 1;
					else if(listfindnocase(offday_list,'#daycode#'))
						temporary_offday_total = temporary_offday_total + 1;
					else if(daycode is '#dateformat(dateadd("h",2,get_offtime.finishdate),'dd/mm/yyyy')#' and day_control_ gt 0 and timeformat(dateadd("h",2,get_offtime.finishdate),'HH') lt day_control_)
						temporary_halfday_total = temporary_halfday_total + 1;
					}
				genel_izin_toplam = genel_izin_toplam + total_izin - temporary_sunday_total - temporary_offday_total  - (0.5 * temporary_halfday_total);
				kisi_izin_toplam = kisi_izin_toplam + genel_izin_toplam;
				kisi_izin_sayilmayan = kisi_izin_sayilmayan + temporary_sunday_total + temporary_offday_total;
			</cfscript>
		</CFLOOP>
	</CFIF>
	
	<cfscript>
		tck = 0;
		toplam_hakedilen_izin = 0;
		eklenecek = 0;
				my_giris_date = get_employee.IZIN_DATE;
				flag = true;
				baslangic_tarih_ = my_giris_date;
				while(flag)
				{
				bitis_tarihi_ = createodbcdatetime(dateadd("yyyy",1,baslangic_tarih_));
				baslangic_tarih_ = createodbcdatetime(baslangic_tarih_);
				get_bos_zaman_ = cfquery(Datasource="#dsn#",dbtype="query",sqlstring="SELECT * FROM get_progress_payment_outs WHERE EMP_ID = #employee_id_# AND ((START_DATE <= #baslangic_tarih_# AND FINISH_DATE >= #baslangic_tarih_#) OR (START_DATE >= #baslangic_tarih_# AND FINISH_DATE <= #bitis_tarihi_#) OR ((START_DATE BETWEEN #baslangic_tarih_# AND #bitis_tarihi_#) AND FINISH_DATE >= #bitis_tarihi_#))");	
				if(get_bos_zaman_.recordcount eq 0)
					{
					tck = tck + 1; 
					kontrol_date = dateadd("yyyy",tck-1,baslangic_tarih_);
					get_offtime_limit=cfquery(Datasource="#dsn#",dbtype="query",sqlstring="SELECT * FROM get_offtime_limits WHERE STARTDATE <= #baslangic_tarih_# AND FINISHDATE >= #baslangic_tarih_#");	
						if(get_offtime_limit.recordcount)
							{
							if(tck lte get_offtime_limit.limit_1)
								eklenecek = get_offtime_limit.LIMIT_1_DAYS;
							else if(tck gt get_offtime_limit.limit_1 and tck lte get_offtime_limit.limit_2)
								eklenecek = get_offtime_limit.LIMIT_2_DAYS;
							else if(tck gt get_offtime_limit.limit_2 and tck lte get_offtime_limit.limit_3)
								eklenecek = get_offtime_limit.LIMIT_3_DAYS;
							else 
								eklenecek = get_offtime_limit.LIMIT_4_DAYS;
								
							if(len(get_employee.BIRTH_DATE) and eklenecek lt get_offtime_limit.MIN_MAX_DAYS and (datediff("yyyy",get_employee.BIRTH_DATE,kontrol_date) lt get_offtime_limit.MIN_YEARS or datediff("yyyy",get_employee.BIRTH_DATE,kontrol_date) gt get_offtime_limit.MAX_YEARS) )
								eklenecek = get_offtime_limit.MIN_MAX_DAYS;
							if(tck neq 1 and eklenecek neq 0) 
								{
								toplam_hakedilen_izin = toplam_hakedilen_izin + eklenecek;
								son_baslangic_ = baslangic_tarih_;
								son_bitis_ = bitis_tarihi_;
								}
							}
					}
				else
					{
						eklenecek_gun = 0;
						for(izd = 1; izd lte get_bos_zaman_.recordcount; izd=izd+1)
							{
							if(datediff("d",get_bos_zaman_.start_date[izd],baslangic_tarih_) gt 0 and len(get_bos_zaman_.finish_date[izd]))
								{
								fark_ = datediff("d",baslangic_tarih_,get_bos_zaman_.finish_date[izd]);
								}
							else if(datediff("d",get_bos_zaman_.start_date[izd],baslangic_tarih_) lte 0 and len(get_bos_zaman_.PROGRESS_TIME[izd]))
								{
								fark_ = get_bos_zaman_.PROGRESS_TIME[izd];
								}
							else if(datediff("d",get_bos_zaman_.start_date[izd],baslangic_tarih_) lte 0 and len(get_bos_zaman_.finish_date[izd]))
								{
								fark_ = datediff("d",get_bos_zaman_.start_date[izd],get_bos_zaman_.finish_date[izd]);
								}
							else
								 {
								 fark_ = 0;
								 }
							eklenecek_gun = eklenecek_gun + fark_;
							}
						bitis_tarihi_ = dateadd("d",eklenecek_gun,bitis_tarihi_);
							
							tck = tck + 1; 
							kontrol_date = dateadd("yyyy",tck-1,baslangic_tarih_);
							get_offtime_limit=cfquery(Datasource="#dsn#",dbtype="query",sqlstring="SELECT * FROM get_offtime_limits WHERE STARTDATE <= #baslangic_tarih_# AND FINISHDATE >= #baslangic_tarih_#");	
								if(get_offtime_limit.recordcount)
									{
									if(tck lte get_offtime_limit.limit_1)
										eklenecek = get_offtime_limit.LIMIT_1_DAYS;
									else if(tck gt get_offtime_limit.limit_1 and tck lte get_offtime_limit.limit_2)
										eklenecek = get_offtime_limit.LIMIT_2_DAYS;
									else if(tck gt get_offtime_limit.limit_2 and tck lte get_offtime_limit.limit_3)
										eklenecek = get_offtime_limit.LIMIT_3_DAYS;
									else 
										eklenecek = get_offtime_limit.LIMIT_4_DAYS;
										
									if(len(get_employee.BIRTH_DATE) and eklenecek lt get_offtime_limit.MIN_MAX_DAYS and (datediff("yyyy",get_employee.BIRTH_DATE,kontrol_date) lt get_offtime_limit.MIN_YEARS or datediff("yyyy",get_employee.BIRTH_DATE,kontrol_date) gt get_offtime_limit.MAX_YEARS) )
										eklenecek = get_offtime_limit.MIN_MAX_DAYS;
									if(tck neq 1 and eklenecek neq 0) 
										{
										toplam_hakedilen_izin = toplam_hakedilen_izin + eklenecek;
										son_baslangic_ = baslangic_tarih_;
										son_bitis_ = bitis_tarihi_;
										}
									}
					}	
				baslangic_tarih_ = bitis_tarihi_;
				bitis_tarihi_ = dateadd("yyyy",1,bitis_tarihi_);
				if(datediff("yyyy",bitis_tarihi_,my_baz_date) lt 0)				
					{
					flag = false;
					}
				}
	</cfscript>
	<cfif get_offtime.recordcount and toplam_hakedilen_izin gt 0>
		<cfset son_izin_toplam = 0>
		<cfquery name="get_ic" dbtype="query">
			SELECT * FROM get_offtime WHERE EMPLOYEE_ID = #employee_id_# AND STARTDATE >= #createodbcdatetime(son_baslangic_)# AND FINISHDATE <= #createodbcdatetime(son_bitis_)#
		</cfquery>
			<CFLOOP query="get_ic">
			<cfquery name="get_offtime_cat" datasource="#dsn#" maxrows="1">
				SELECT * FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= #createodbcdatetime(get_ic.startdate)#  AND FINISHDATE >= #createodbcdatetime(get_ic.startdate)#
			</cfquery>
			<cfif get_offtime_cat.recordcount and len(get_offtime_cat.SATURDAY_ON)>
				<cfset saturday_on = get_offtime_cat.SATURDAY_ON>
			<cfelse>
				<cfset saturday_on = 1>
			</cfif>
				<cfscript>
					temporary_sunday_total = 0;
					temporary_resmi_total = 0;
					total_izin = datediff('d',get_ic.startdate,get_ic.finishdate)+1;
					izin_startdate = dateadd("h",2, get_ic.startdate); 
					izin_finishdate = dateadd("h",2, get_ic.finishdate);
					for (mck=0; mck lt total_izin; mck=mck+1)
						{
						temp_izin_gunu = dateadd("d",mck,izin_startdate);
						daycode = '#dateformat(temp_izin_gunu,'dd/mm/yyyy')#';
						if (dayofweek(temp_izin_gunu) eq 1)
							temporary_sunday_total = temporary_sunday_total + 1;
						else if (dayofweek(temp_izin_gunu) eq 7 and saturday_on eq 0)
							temporary_sunday_total = temporary_sunday_total + 1;
						else if(listfindnocase(offday_list,'#daycode#'))
							temporary_resmi_total = temporary_resmi_total + 1;
						}
					son_izin_toplam = son_izin_toplam + total_izin - temporary_sunday_total - temporary_resmi_total;
				</cfscript>
			</CFLOOP>
		<cfset son_donem_kullanilan = son_izin_toplam>
	<cfelse>
		<cfset son_donem_kullanilan = 0>
	</cfif>
	
	<cfset genel_ = toplam_hakedilen_izin-genel_izin_toplam-old_days>
	<cfset son_ = eklenecek - son_donem_kullanilan>
	<cfif arguments.is_view_last_year eq 1>
		<cfif genel_ gt son_>
			<cfset offtime_info = '#genel_# - #son_#'>
		<cfelse>
			<cfset offtime_info = '#genel_# - #genel_#'>
		</cfif>
	<cfelse>
		<cfset offtime_info = '#genel_#'>
	</cfif>
<cfelse>
	<cfset offtime_info = 'Tanımsız'>
</cfif>
		<cfreturn offtime_info>
	</cffunction>
</cfcomponent>
