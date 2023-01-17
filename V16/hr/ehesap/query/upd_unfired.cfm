<cf_date tarih="attributes.START_DATE">
<!--- son 6 altı ay içinde giriş,çıkış  kontrolü , ortalama çalışan sayısı belirlenilerek yeni istihdam yasasına uygunluğu kontrol ediliyor..--->
<cfif isdefined('attributes.is_5510')><!---zaten checkbox chekli ise isdefined olur   --->
	<cfquery name="employment_control" datasource="#dsn#" maxrows="1">
		SELECT 
			E.EMPLOYEE_NAME,
			EIO.FINISH_DATE,
			EIO.START_DATE
		FROM 
			EMPLOYEES E,
			EMPLOYEES_IN_OUT EIO,
			BRANCH B
		WHERE
			EIO.BRANCH_ID = B.BRANCH_ID AND
			B.COMPANY_ID = #session.ep.company_id# AND
			EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND
			E.EMPLOYEE_ID = #attributes.employee_id# AND
			(
			(EIO.START_DATE BETWEEN #attributes.START_DATE# AND #DATEADD("m",-6,attributes.START_DATE)#)
			OR
			(EIO.FINISH_DATE IS NOT NULL AND EIO.FINISH_DATE BETWEEN #attributes.START_DATE# AND #DATEADD("m",-6,attributes.START_DATE)#)
			OR
			EIO.FINISH_DATE IS NULL
			)
	</cfquery>
	<cfif employment_control.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='62412.Çalışanın 6 Ay İçersinde Giriş - Çıkış İşlemi Bulundu'>!\n<cf_get_lang dictionary_id='62413.Çalışanın Yeni İstihdam Yasasından Yararlanması Kanunen Uygun Değildir'>!");
		</script>
	</cfif>
	<cfquery name="get_employment_puantaj" datasource="#dsn#" maxrows="12">
			 SELECT
			 	COUNT(EPR.EMPLOYEE_ID) AS calisan_sayisi,
				COUNT(DISTINCT EP.SAL_MON) AS ay_sayısı
			FROM 
				EMPLOYEES_PUANTAJ_ROWS EPR,
				EMPLOYEES_PUANTAJ EP,
				BRANCH B,
				DEPARTMENT D,
				EMPLOYEES_IN_OUT EIO
			WHERE
				EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND
				EIO.IN_OUT_ID=EPR.IN_OUT_ID AND
				EIO.DEPARTMENT_ID = D.DEPARTMENT_ID AND
				D.BRANCH_ID = B.BRANCH_ID AND
				B.COMPANY_ID = #session.ep.company_id# 
				<cfif DATABASE_TYPE IS "MSSQL">
				AND
				(
					(EP.SAL_MON >= DATEPART(m,#attributes.START_DATE#)  AND DATEPART(yy,DATEADD(m,-12,#attributes.START_DATE#)) = EP.SAL_YEAR)
				OR 
					(EP.SAL_MON < DATEPART(m,#attributes.START_DATE#) AND DATEPART(yy,#attributes.START_DATE#) = EP.SAL_YEAR)
				)
				<cfelseif DATABASE_TYPE IS "DB2"><!--- DB2 için --->
				AND
				(
					(EP.SAL_MON >= MONTH(#attributes.START_DATE#)  AND YEAR(DATE(#attributes.START_DATE#) - 12 MONTHS) = EP.SAL_YEAR)
				OR 
					(EP.SAL_MON < YEAR(#attributes.START_DATE#) AND YEAR(#attributes.START_DATE#) = EP.SAL_YEAR)
				)
			</cfif>
	</cfquery>
		<cfif get_employment_puantaj.calisan_sayisi gt 0 and get_employment_puantaj.ay_sayısı gt 0>
			<cfset ortalama_calisan=(get_employment_puantaj.calisan_sayisi/get_employment_puantaj.ay_sayısı)>
			<cfif ortalama_calisan gte get_employment_puantaj.calisan_sayisi>
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='62414.Ortalamanın Üzerinde Çalışan Olduğundan Yeni İstihdam Yasasından Yararlanması Kanunen Uygun Değildir'>!");
				</script>
			</cfif>
		</cfif>
</cfif>
<!---son 6 altı ay içinde giriş,çıkış  kontrolü , ortalama çalışan sayısı belirlenilerek yeni istihdam yasasına uygunluğu kontrol ediliyor..--->

<cfquery name="get_son_kontrol_" datasource="#dsn#">
	SELECT
		EMPLOYEE_ID
	FROM
		EMPLOYEES_IN_OUT
	WHERE
		EMPLOYEE_ID = #attributes.employee_id# AND
		(
		START_DATE >= #attributes.START_DATE#
		OR
		START_DATE <= #attributes.START_DATE# AND (FINISH_DATE >= #attributes.START_DATE# OR FINISH_DATE IS NULL)
		)
		AND
		BRANCH_ID = #attributes.branch_id#
		AND
		IN_OUT_ID <> #attributes.IN_OUT_ID#
</cfquery>

<cfif get_son_kontrol_.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='62415.Bu Tarihler Arasında Giriş İşlemi Var veya Son Girişten Öncesine Kayıt Yapmaya Çalışıyorsunuz'>\n<cf_get_lang dictionary_id='62416.Lütfen Kayıtlarınızı Düzenleyiniz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="upd_out" datasource="#dsn#">
	UPDATE 
		EMPLOYEES_IN_OUT 
	SET	
		BRANCH_ID=#attributes.BRANCH_ID#,
		DEPARTMENT_ID=#attributes.DEPARTMENT_ID#,
		START_DATE=#attributes.START_DATE#,
		IS_5084=<cfif isdefined("attributes.is_5084")>1<cfelse>0</cfif>,
		IS_5510=<cfif isdefined("attributes.is_5510")>1<cfelse>0</cfif>,
		VALID = NULL,
		VALID_EMP = NULL,
		VALID_DATE = NULL,
		UPDATE_DATE = #NOW()#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_EMP = #SESSION.EP.USERID#
	WHERE 
		IN_OUT_ID = #attributes.IN_OUT_ID#
</cfquery>
	<cfinclude template="../query/add_in_out_history.cfm"> <!--- history tutar--->
	
<script type="text/javascript">
	<cfif not isDefined('attributes.draggable')>
		wrk_opener_reload();
		window.close();
	<cfelse>
		location.href = document.referrer;
	</cfif>
</script>
