<cfset attributes.ID =action_id>
<cfset attributes.IN_OUT_ID = attributes.ID>
<cfquery name="get_in_out" datasource="#DSN#">
	SELECT * FROM EMPLOYEES_IN_OUT WHERE IN_OUT_ID = #attributes.IN_OUT_ID#
</cfquery>
<cfset attributes.sal_mon = MONTH(get_in_out.FINISH_DATE)>
<cfset attributes.sal_year = YEAR(get_in_out.FINISH_DATE)>
<cfset attributes.group_id = "">
<cfif len(get_in_out.puantaj_group_ids)>
	<cfset attributes.group_id = "#get_in_out.PUANTAJ_GROUP_IDS#,">
</cfif>
<cfset attributes.branch_id = get_in_out.branch_id>
<cfinclude template="/V16/hr/ehesap/query/get_program_parameter.cfm">

<cfif attributes.fuseaction neq "ehesap.form_upd_program_parameters" and (not isdefined("get_program_parameters.recordcount") or not get_program_parameters.recordcount)>
	<script type="text/javascript">
		alert("<cf_get_lang_main no ='1336.Seçtiğiniz Tarihi Kapsayan Program Akış Parametresi Bulunamamıştır! Lütfen Program Akış Parametrelerini Giriniz'>!");
		parent.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.form_add_program_parameters";
	</script>
	<cfabort>
</cfif>
<cfif len(get_program_parameters.CAST_STYLE)>
	<cfset this_cast_style_ = get_program_parameters.CAST_STYLE>
<cfelse>
	<cfset this_cast_style_ = 0>
</cfif>
<cfquery name="get_puantaj_row" datasource="#dsn#">
	SELECT
		EMPLOYEES_PUANTAJ_ROWS.*
	FROM
		BRANCH,
		EMPLOYEES_PUANTAJ,
		EMPLOYEES_PUANTAJ_ROWS
	WHERE
		EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID
		AND EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = #get_in_out.EMPLOYEE_ID#
		AND EMPLOYEES_PUANTAJ.SAL_YEAR = #attributes.sal_year#
		AND EMPLOYEES_PUANTAJ.SAL_MON = #attributes.sal_mon#
		AND BRANCH.BRANCH_ID = #get_in_out.BRANCH_ID#
		AND
	<cfif database_type is "MSSQL">
		BRANCH.SSK_OFFICE = EMPLOYEES_PUANTAJ.SSK_OFFICE
		AND BRANCH.SSK_NO = EMPLOYEES_PUANTAJ.SSK_OFFICE_NO
	<cfelseif database_type is "DB2">
		BRANCH.SSK_OFFICE = EMPLOYEES_PUANTAJ.SSK_OFFICE
		AND BRANCH.SSK_NO = EMPLOYEES_PUANTAJ.SSK_OFFICE_NO
	</cfif>
</cfquery>

<cfif NOT get_puantaj_row.RECORDCOUNT>
	<script type="text/javascript">
		alert("Puantaj Kaydı Bulunamadı !");
		window.close();
	</script>
	<cfabort>
</cfif>

<cfquery name="get_active_tax_slice" datasource="#dsn#">
	SELECT 
		MIN_PAYMENT_1,
		MIN_PAYMENT_2,
		MIN_PAYMENT_3,
		MIN_PAYMENT_4,
		MIN_PAYMENT_5,
		MIN_PAYMENT_6,
		MAX_PAYMENT_1,
		MAX_PAYMENT_2,
		MAX_PAYMENT_3,
		MAX_PAYMENT_4,
		MAX_PAYMENT_5,
		MAX_PAYMENT_6,
		RATIO_1,
		RATIO_2,
		RATIO_3,
		RATIO_4,
		RATIO_5,
		RATIO_6
	FROM 
		SETUP_TAX_SLICES 
	WHERE 
		#CreateODBCDateTime(get_in_out.FINISH_DATE)# BETWEEN STARTDATE  AND FINISHDATE
</cfquery>

<cfif not get_active_tax_slice.recordcount>
	<cfoutput>
		<script type="text/javascript">
			alert('#dateformat(last_month_1,dateformat_style)# - #dateformat(last_month_30,dateformat_style)# aralığında geçerli Vergi Dilimleri Tanımlı Değil !');
			history.back();
		</script>
	</cfoutput>
	<CFABORT>
</cfif>
<cfscript>
if (not len(get_in_out.KULLANILMAYAN_IZIN_AMOUNT)) // kullanmadığı yıllık izin yoksa
	{
	C_B = 0;
	gelir_vergisi_izin = 0;
	C_N = 0;
	}
else
	{
	C_B = get_in_out.KULLANILMAYAN_IZIN_AMOUNT;

	// veritabanında kümülatif e bu ayın matrahı da dahil erk 20030923
	ssk_matrah_salary = get_puantaj_row.ssk_matrah_salary;
	ssk_matrah = get_puantaj_row.ssk_matrah;
	kumulatif_gelir = get_puantaj_row.kumulatif_gelir_matrah;
	gelir_vergisi_matrah = get_puantaj_row.gelir_vergisi_matrah;
	gvm_izin = get_puantaj_row.gvm_izin;
	gvm_ihbar = get_puantaj_row.gvm_ihbar;

	if(get_in_out.GROSS_COUNT_TYPE eq 1)// standart izin hesap sistemi
		{
		if(get_puantaj_row.yillik_izin_amount gt 0)
			C_N = get_puantaj_row.yillik_izin_amount_net;
		else
			C_N = 0;
		}
	else // yeni sistem
		{
		// izinden ssk hesaplanıp çıkarılır
		if (ssk_matrah_salary neq 0)
			{
			if (get_puantaj_row.SSDF_ISCI_HISSESI neq 0) // emekli ise
				C_N = get_in_out.KULLANILMAYAN_IZIN_AMOUNT - (get_puantaj_row.SSDF_ISCI_HISSESI * (ssk_matrah_salary / ssk_matrah));
			else if (get_puantaj_row.SSK_ISCI_HISSESI neq 0)
				{
				C_N = get_in_out.KULLANILMAYAN_IZIN_AMOUNT - (get_puantaj_row.SSK_ISCI_HISSESI * (ssk_matrah_salary / ssk_matrah));
				C_N = C_N - (get_puantaj_row.ISSIZLIK_ISCI_HISSESI * (ssk_matrah_salary / ssk_matrah));
				}
			else
				C_N = get_in_out.KULLANILMAYAN_IZIN_AMOUNT;
			}
		else
			C_N = get_in_out.KULLANILMAYAN_IZIN_AMOUNT;
	
		//writeoutput('C_N_1:#C_N# <br/><br/>');
	
		// izinden damga vergisi çıkarılır
		DAMGA_VERGISI_IZIN = (C_B * get_program_parameters.stamp_tax_binde / 1000);
		GELIR_VERGISI_IZIN = (C_N * get_puantaj_row.tax_ratio);
		C_N = C_N - GELIR_VERGISI_IZIN - DAMGA_VERGISI_IZIN;
		}
	}
if (not len(get_in_out.IHBAR_AMOUNT) or get_in_out.IHBAR_AMOUNT eq 0) // ihbar yoksa
	{
	B_B = 0;
	B_N = 0;
	}
else
	{
	B_B = get_in_out.IHBAR_AMOUNT;
	
	// veritabanında kümülatif e bu ayın matrahı da dahil erk 20030923
	kumulatif_gelir = get_puantaj_row.kumulatif_gelir_matrah;
	gelir_vergisi_matrah = get_puantaj_row.gelir_vergisi_matrah;
	gvm_izin = get_puantaj_row.gvm_izin;
	gvm_ihbar = get_puantaj_row.gvm_ihbar;

		
	gelir_vergisi_ihbar = B_B * get_puantaj_row.tax_ratio;
	
	B_N = B_B - gelir_vergisi_ihbar;
	// ihbardan damga vergisi çıkarılır
	B_N = B_N - ( get_in_out.IHBAR_AMOUNT * (get_program_parameters.stamp_tax_binde / 1000) );	
	}
if (not len(get_in_out.KIDEM_AMOUNT)) // kıdem yoksa
	{
	A_B = 0;
	A_N = 0;
	}
else
	{
	A_B = get_in_out.KIDEM_AMOUNT;
	A_N = ( get_in_out.KIDEM_AMOUNT * (1000-get_program_parameters.stamp_tax_binde) ) / 1000;
	}

BRUT_KIDEM_IHBAR_YILLIK = A_B + B_B + C_B;
NET_KIDEM_IHBAR_YILLIK = A_N + B_N + C_N;
</cfscript>
<cfset attributes.branch_id = get_in_out.branch_id>
<cfquery name="GET_BRANCH" datasource="#dsn#">
	SELECT 
		BRANCH.*,
		OUR_COMPANY.COMPANY_NAME,
		OUR_COMPANY.T_NO,
		OUR_COMPANY.ADDRESS,
		OUR_COMPANY.TEL_CODE,
		OUR_COMPANY.TEL,
		OUR_COMPANY.TAX_NO,
		OUR_COMPANY.TAX_OFFICE
		<cfif isdefined("attributes.department_id")>
		,DEPARTMENT.DEPARTMENT_HEAD
		</cfif>
	FROM 
		<cfif isdefined("attributes.department_id")>
		DEPARTMENT,
		</cfif>
		BRANCH,
		OUR_COMPANY
	WHERE
		OUR_COMPANY.COMP_ID=BRANCH.COMPANY_ID
	<cfif not isdefined("attributes.BRANCH_ID") and (isdefined("attributes.SSK_OFFICE") and len(attributes.SSK_OFFICE))>
		AND
		<cfif database_type is "MSSQL">
			SSK_OFFICE + '-' + SSK_NO = '#attributes.SSK_OFFICE#'
		<cfelseif database_type is "DB2">
			SSK_OFFICE || '-' || SSK_NO = '#attributes.SSK_OFFICE#'
		</cfif>
	<cfelseif isdefined("attributes.department_id")>
		AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
		AND DEPARTMENT.DEPARTMENT_ID = #attributes.department_id#
	<cfelseif isdefined("attributes.branch_id")>
		AND BRANCH.BRANCH_ID = #attributes.BRANCH_ID#
	</cfif>
	<cfif not session.ep.ehesap>
		AND BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# )
	</cfif>
	ORDER BY BRANCH.BRANCH_NAME
</cfquery>

<table>
	<tr>
		<td width="135">&nbsp;</td>
		<td><cfinclude template="/V16/objects/display/view_company_logo.cfm"></td>
	</tr>
</table>
<table width="650" border="0" cellspacing="0" cellpadding="0" align="center" height="35">
  <tr>
    <td class="headbold" align="center">İBRANAME</td>
  </tr>
</table>
<br/>
<table width="650" align="center" height="35">
  <tr>
    <td>
	<cfoutput query="get_branch">
	<span class="headbold">#COMPANY_NAME#</span><br/><br/>
	#ADDRESS#
	</cfoutput>
	</td>
  </tr>
</table>
<br/>
<table width="650" align="center">
  <tr>
    <td>
	<cfoutput query="get_in_out">
	Adresinde kurulu işyerinde <strong>#dateformat(START_DATE,dateformat_style)#</strong> tarihinden <strong>#dateformat(FINISH_DATE,dateformat_style)#</strong> tarihine kadar çalıştığım
	işyerinden 
	<strong>
		<cfif get_in_out.explanation_id eq 50>
			4857 sayılı Kanun Madde 25-II-ı İşin güvenliğini tehlikeye düşürmesi, makineleri, tesisatı veya başka eşya ve maddeleri hasara ve kayba uğratması
		<cfelse>
			<cfloop list="#reason_order_list()#" index="ccc">
				<cfset value_name_ = listgetat(reason_list(),ccc,';')>
				<cfset value_id_ = ccc>
				<cfset value_name_ = Replace(value_name_, "(", "&nbsp", "all")>
				<cfoutput><cfif get_in_out.explanation_id eq value_id_>#ListLast(value_name_,')')#</cfif></cfoutput>
			</cfloop>
		</cfif>
	</strong> nedeniyle ayrıldım.<br/><br/>
	Bu işyerinde çalıştığım süre boyunca hak kazandığım normal ücret, fazla mesai hafta tatil, resmi ve genel tatil ücretlerimi, ikramiye ve primlerimi yıllık izin 
	haklarımı tam ve noksansız bir şekilde almış olduğumu beyan ve kabul ederim. <br/>
	Böylece adı geçen şirketten her türlü alacağımı eksiksiz almış olduğumu, ayrıca yukarıda sayılanlar dışında da çıkış ücreti olarak <strong>net</strong>
	<strong>#TLFormat(get_puantaj_row.net_ucret)# #session.ep.money#</strong> ve gerek hizmet akdimden veya gerekse kanundan doğan hiç bir alacağım kalmadığını ikrarla her türlü dava ve takip hakkımdan feragat 
	ettiğimi beyan eder <strong>#get_branch.COMPANY_NAME#</strong> 'yi tam bir şekilde ibra eylerim.
	</cfoutput></td>
  </tr>
</table>
<br/><br/>
<table width="650" align="center" height="35">
  <tr>
  <td width="65" class="txtbold" height="22">Adı Soyadı</td>
    <td width="150">
<cfset attributes.employee_id = get_in_out.EMPLOYEE_ID>
<cfquery name="GET_EMPLOYEE" datasource="#dsn#">
	SELECT 
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		MEMBER_CODE
	FROM 
		EMPLOYEES 
	WHERE 
		EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
</cfquery>
<cfset calisan = "#get_employee.employee_name#  #get_employee.employee_surname#">
<cfoutput>#calisan#</cfoutput>
	</td>
    <td rowspan="3" style="text-align:right;" valign="top">Saygılarımla;</td>
  </tr>
    <tr>
  <td width="65" class="txtbold" height="22">Tarih</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
  <td width="65" class="txtbold" height="22">Tel</td>
    <td>&nbsp;</td>
  </tr>
</table>
<br/><br/>
<table width="650" align="center">
  <tr>
    <td colspan="2">İş bu imzanın <cfoutput><strong>#calisan#</strong></cfoutput> 'a ait olduğunu ve huzurumda kendisi tarafından imzalandığını beyan ederim.</td>
  </tr>
  <tr>
  <td width="65" class="txtbold" height="22">Adı Soyadı</td>
    <td></td>
  </tr>
    <tr>
  <td width="65" class="txtbold" height="22">İmza</td>
    <td>&nbsp;</td>
  </tr>
</table>

