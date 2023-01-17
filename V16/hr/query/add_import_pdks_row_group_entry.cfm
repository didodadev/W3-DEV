<!--- toplu pdks import dosyasi. hguL --->
<cfquery name="get_puantaj_info" datasource="#dsn#">
	SELECT 
		EP.PUANTAJ_ID,
		EP.SAL_MON,
		EP.SAL_YEAR,
		EP.SSK_OFFICE,
		B.BRANCH_ID
	FROM
		EMPLOYEES_PUANTAJ EP,
		BRANCH B
	WHERE
		B.SSK_OFFICE = EP.SSK_OFFICE AND
		B.SSK_NO = EP.SSK_OFFICE_NO
</cfquery>
<cfloop from="2" to="#line_count#" index="i">
	<cfset kont=1>
	<cftry>
		<cfset code_ = trim(listgetat(dosya1[i],1,';'))>
		<cfset saat_ = trim(listgetat(dosya1[i],2,';'))>
		<cfset ay_ = trim(listgetat(dosya1[i],3,';'))>
		<cfset yil_ = trim(listgetat(dosya1[i],4,';'))>
		<cfcatch type="Any">
			<cfoutput>#i#. Satır Hatalı<br/></cfoutput>	
			<cfset kont=0>
		</cfcatch>  
	</cftry>
	<cfset time = get_import.time_choice>
	<cfset bu_ay_basi =  createdate(yil_,ay_,1)>
	<cfset bu_ay_sonu = date_add('s',-1,date_add('m',1,bu_ay_basi))>
		<cfquery name="get_" datasource="#dsn#" maxrows="1">
			SELECT
				EI.EMPLOYEE_ID,
				EIO.IN_OUT_ID,
				EIO.BRANCH_ID,
				EIO.START_DATE
			FROM
				EMPLOYEES_IDENTY EI,
				EMPLOYEES_IN_OUT EIO
			WHERE
				EI.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
				EI.TC_IDENTY_NO = '#code_#' AND
				START_DATE < #createodbcdatetime(bu_ay_sonu)# AND
				(FINISH_DATE IS NULL OR FINISH_DATE >= #createodbcdatetime(bu_ay_basi)#)
			ORDER BY
				EIO.IN_OUT_ID DESC
		</cfquery>
		<cfif get_.recordcount>
			<cfif get_import.is_puantaj_off eq 1>
				<cfquery name="control_row" dbtype="query">
					SELECT * FROM get_puantaj_info WHERE SAL_MON = #ay_# AND SAL_YEAR = #yil_# AND BRANCH_ID = #get_.branch_id#
				</cfquery>
			</cfif>
			<cfif get_import.is_puantaj_off eq 1 and control_row.recordcount>
				<cfoutput>#i#. Satır için Puantaj Hesabı Oluşturulmuş, İmport Yapılamaz... <br/></cfoutput>
			<cfelse>
				<cfset fark_ = datediff("d",bu_ay_basi,get_.start_date)>
				<cfset gun_sayisi_ = fix(saat_ / time)>
				<cfif saat_ gt (gun_sayisi_ * time)>
					<cfset gun_sayisi_ = gun_sayisi_ + 1>
				</cfif>
				<cfif fark_ gt 0>
					<cfset baslangic_ = fark_>
				<cfelse>
					<cfset baslangic_ = 0>
				</cfif>
				<cfset kullanilan_ = 0>
				<cfloop from="1" to="#gun_sayisi_#" index="mmd">
					<cfif mmd neq gun_sayisi_>
						<cfset yazilacak_ = time>
					<cfelse>
						<cfset yazilacak_ = saat_ - (time * (mmd-1))>
					</cfif> 
					<cfset new_tarih_ = createodbcdatetime(createdate(yil_,ay_,(baslangic_+mmd)))>
					<cfset startdate_ = date_add('h',8,new_tarih_)>
					<cfset finishdate_ = date_add('h',yazilacak_,startdate_)>
					<!--- <cfif yazilacak_ contains '.'>
						<cfset finishdate_ = date_add('h',1,finishdate_)>
					</cfif> ---> <!--- Bu neden eklendi? Saat bucuklu olunca neden bir saat ekliyor? --->
					<cfquery name="add_emp_daily_in_out" datasource="#dsn#">
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
							#attributes.i_id#,
							#get_.employee_id#,
							#get_.in_out_id#,
							#get_.branch_id#,
							#startdate_#,
							#finishdate_#,
							#now()#,
							#session.ep.userid#,
							'#cgi.remote_addr#'
							)
					</cfquery>
				</cfloop>
				<cfoutput>#i#. Satır İmport Edildi... <br/></cfoutput>
			</cfif>
		</cfif>
</cfloop>
<cfset kayit_yapildi = 1>
