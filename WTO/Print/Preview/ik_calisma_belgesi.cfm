<!--- Çalışma Belgesi --->
<cfset attributes.ID = attributes.action_id>
<cfset attributes.ID = action_id>

<cfquery name="get_in_out" datasource="#DSN#">
	SELECT
		EMPLOYEE_ID,
		START_DATE,
		FINISH_DATE,
		EXPLANATION_ID,
		SOCIALSECURITY_NO,
		VALID_EMP,
		START_CUMULATIVE_TAX,
		IS_START_CUMULATIVE_TAX,
		BRANCH_ID
	FROM
		EMPLOYEES_IN_OUT
	WHERE
		IN_OUT_ID = #attributes.ID#
</cfquery>

<cfset attributes.sal_mon = Month(get_in_out.FINISH_DATE)>
<cfset attributes.sal_year = Year(get_in_out.FINISH_DATE)>

<cfquery name="get_puantaj_row" datasource="#DSN#" maxrows="1">
	SELECT
		PUANTAJ_ID,
		ISNULL(KUMULATIF_GELIR_MATRAH, 0) AS KUM_GELIR_MATRAH,
		ISNULL(GELIR_VERGISI, 0) AS GELIR_VERGISI,
		ISNULL(VERGI_IADESI, 0) AS VERGI_IADESI
	FROM
		EMPLOYEES_PUANTAJ_ROWS
	WHERE
		IN_OUT_ID = #attributes.ID#
	ORDER BY
		PUANTAJ_ID DESC
</cfquery>

<cfset attributes.employee_id = get_in_out.EMPLOYEE_ID>
<cfif not len(attributes.employee_id)>
	<script type="text/javascript">
		alert("Çalışan Kaydı Bulunamadı !");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="get_emp_short_info" datasource="#DSN#">
	SELECT 	
		MEMBER_CODE,
		PHOTO,
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
        BIRTH_DATE,
		BIRTH_PLACE,
        FATHER,
		GROUP_STARTDATE,
		PHOTO_SERVER_ID,
		EI.TC_IDENTY_NO
	FROM 
		EMPLOYEES E,
		EMPLOYEES_IDENTY EI
	WHERE 
		E.EMPLOYEE_ID = #attributes.employee_id# AND
		E.EMPLOYEE_ID = EI.EMPLOYEE_ID
</cfquery>
<cfquery name="get_last_position_name" datasource="#DSN#" maxrows="1">
    SELECT
		EPH.*,
        D.DEPARTMENT_HEAD,
        ST.TITLE,
        B.BRANCH_NAME,
        B.POSITION_NAME,
        B.SSK_NO,
        O.COMPANY_NAME,
        O.ADDRESS
    FROM 
        EMPLOYEE_POSITIONS_HISTORY EPH,
        DEPARTMENT D,
        SETUP_TITLE ST,
        BRANCH B,
        OUR_COMPANY O
    WHERE
        EPH.EMPLOYEE_ID = #attributes.employee_id#
        AND D.DEPARTMENT_ID = EPH.DEPARTMENT_ID
        AND EPH.IS_MASTER = 1
        AND ST.TITLE_ID = EPH.TITLE_ID
        AND B.BRANCH_ID = D.BRANCH_ID
        AND B.COMPANY_ID = O.COMP_ID
    ORDER BY 
        HISTORY_ID DESC
</cfquery>

<cfquery name="get_branch_ssk_info" datasource="#DSN#">
	SELECT
		ADMIN1_POSITION_CODE,
		REAL_WORK,
		BRANCH_WORK
	FROM 
		BRANCH B
	WHERE 
		B.BRANCH_ID = #get_in_out.BRANCH_ID#
</cfquery>

<cfset sube_yonetici_1 = "">

<!--- Çalışanın Şube Yöneticisini getir --->
<cfif len(get_branch_ssk_info.ADMIN1_POSITION_CODE)>
	<cfset attributes.position_code = get_branch_ssk_info.ADMIN1_POSITION_CODE>
	<cfquery name="GET_POSITION" datasource="#dsn#">
		SELECT
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME
		FROM
			EMPLOYEE_POSITIONS
		WHERE
			EMPLOYEE_POSITIONS.POSITION_STATUS = 1
		<cfif isDefined("attributes.POSITION_CODE") and len(attributes.POSITION_CODE)>
			AND EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.POSITION_CODE#">
		</cfif>
	</cfquery>
	<cfset sube_yonetici_1 = GET_POSITION.EMPLOYEE_NAME & " " & GET_POSITION.EMPLOYEE_SURNAME>
</cfif>

<cfquery name="get_kumulatif_gelir_vergisi" datasource="#dsn#">
	SELECT SUM(EMPLOYEES_PUANTAJ_ROWS.GELIR_VERGISI) AS TOPLAM FROM EMPLOYEES_PUANTAJ, EMPLOYEES_PUANTAJ_ROWS WHERE EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID AND EMPLOYEES_PUANTAJ.SAL_YEAR = #session.ep.period_year# AND EMPLOYEES_PUANTAJ.SAL_MON < #attributes.sal_mon# AND EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
</cfquery>

<cfscript>
	t_kum_gelir_vergisi = 0;
	t_kum_gelir_vergisi_matrah = 0;

	if (isnumeric(get_kumulatif_gelir_vergisi.TOPLAM))
		t_kum_gelir_vergisi_matrah = get_kumulatif_gelir_vergisi.TOPLAM;
	else
		t_kum_gelir_vergisi_matrah = 0;

	if(get_in_out.IS_START_CUMULATIVE_TAX eq 1 and isnumeric(get_in_out.START_CUMULATIVE_TAX))
		t_kum_gelir_vergisi_matrah = t_kum_gelir_vergisi_matrah + get_in_out.START_CUMULATIVE_TAX;

	t_kum_gelir_vergisi = get_puantaj_row.GELIR_VERGISI + get_puantaj_row.VERGI_IADESI + t_kum_gelir_vergisi_matrah;
</cfscript>

<style>
	table,td{ font-family:Arial, Helvetica, sans-serif; font-size:12px;}
</style>
<table border="0" align="center" style="width:180mm;">
<cfoutput>
    <tr>
        <td valign="middle">
        <table border="0">
            <tr>
            	<td colspan="2" class="formbold" align="center" style="height:10mm;">ÇALIŞMA BELGESİ</td>
            </tr>
            <tr>
                <td colspan="2" class="formbold">İşçinin</td>
            </tr>
            <tr>
                <td style="width:40mm;">Adı - Soyadı</td>
                <td>:&nbsp; #get_emp_short_info.EMPLOYEE_NAME# #get_emp_short_info.EMPLOYEE_SURNAME#</td>
            </tr>
            <tr>
                <td>Baba Adı</td>
                <td>:&nbsp; #get_emp_short_info.FATHER#</td>
            </tr>
            <tr>
                <td>Doğum Yeri ve Yılı</td>
                <td>:&nbsp; #get_emp_short_info.BIRTH_PLACE# - #DateFormat(get_emp_short_info.BIRTH_DATE, dateformat_style)#</td>
            </tr>
            <tr>
                <td>Sigorta Sicil Numarası</td>
                <td>:&nbsp; #get_in_out.SOCIALSECURITY_NO#</td>
            </tr>
        </table>
        </td>
        <td style="width:55mm; height:60mm;" style="text-align:right;">
            <cfif len(get_emp_short_info.photo)>
                <cf_get_server_file output_file="hr/#get_emp_short_info.photo#" output_server="#get_emp_short_info.photo_server_id#" output_type="0" image_width="105" image_height="136">
            <cfelse>
                Foto
            </cfif>
        </td>
    </tr>
    <tr>
        <td colspan="2" style="height:15mm;">&nbsp;</td>
    </tr>
    <tr>
    	<td colspan="2">
        <table border="0">
            <tr>
                <td colspan="2" class="formbold">Çalıştığı İşyerinin</td>
            </tr>
            <tr>
                <td style="width:40mm;">Ünvanı</td>
                <td>:&nbsp; <cfif len(get_last_position_name.COMPANY_NAME)>#get_last_position_name.COMPANY_NAME#</cfif>
               </td>
            </tr>
            <tr>
                <td>Adresi</td>
                <td>:&nbsp; <cfif len(get_last_position_name.ADDRESS)>#get_last_position_name.ADDRESS#</cfif></td>
            </tr>
            <tr>
                <td>Yetkili</td>
                <td>:&nbsp; #sube_yonetici_1#</td>
            </tr>
            <tr>
                <td>İşyeri SSK Sicil Numarası</td>
                <td>:&nbsp; <cfif len(get_last_position_name.SSK_NO)>#get_last_position_name.SSK_NO#</cfif></td>
            </tr>
        </table>
        </td>
    </tr>
    <tr>
        <td colspan="2" style="height:7mm;">&nbsp;</td>
    </tr>
    <tr>
    	<td colspan="2">
        <table border="0">
            <tr>
                <td style="width:40mm;">İşyerinde Yapılan İş/İş Kolu</td>
                <td>:&nbsp; #get_branch_ssk_info.REAL_WORK# / #get_branch_ssk_info.BRANCH_WORK#</td>
            </tr>
            <tr>
                <td>İşçinin Görevi</td>
                <td>:&nbsp; #get_last_position_name.POSITION_NAME#</td>
            </tr>
            <tr>
                <td>İşe Başlama Tarihi</td>
                <td>:&nbsp; #dateformat(get_in_out.START_DATE,dateformat_style)#</td>
            </tr>
            <tr>
                <td>İşten Ayrılış Tarihi</td>
                <td>:&nbsp; #dateformat(get_in_out.FINISH_DATE,dateformat_style)#</td>
            </tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<cfif get_puantaj_row.RecordCount>
				<tr>
					<td>K.Gelir Vergisi Matrahı</td>
					<td>:&nbsp; #tlformat(get_puantaj_row.KUM_GELIR_MATRAH,2)#</td>
				</tr>
				<tr>
					<td>K.Gelir Vergisi</td>
					<td>:&nbsp; #tlformat(t_kum_gelir_vergisi,2)#</td>
				</tr>
			</cfif>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="2"><span style="color:Red;">#ListGetAt(ay_list(),Month(get_in_out.FINISH_DATE))#</span> Asgari Geçim İndirimi ödenmiştir.</td>
			</tr>
        </table>
        </td>
    </tr>
    <tr>
    	<td colspan="2" style="height:13mm;">&nbsp;</td>
    </tr>
    <tr>
    	<td colspan="2">
        <table border="0" cellpadding="0"  width="700">
			<tr>
				<td style="text-align:justify;">Yukarıda fotoğrafı, kimliği ve çalıştığı işyeri belirtilen <b>#get_emp_short_info.EMPLOYEE_NAME# #get_emp_short_info.EMPLOYEE_SURNAME#</b>
                	<b>#dateformat(get_in_out.START_DATE,dateformat_style)# - #dateformat(get_in_out.FINISH_DATE,dateformat_style)#</b> tarihleri arasında işyerimizde çalışmıştır.
				</td>
			</tr>
        	<tr>
            	<td>İş bu çalışma belgesi 4857 sayılı İş Kanunu'nun #ListGetAt(law_list(),get_in_out.EXPLANATION_ID)#. maddesine istinaden düzenlenmiş ve kendisine verilmiştir.</td>
            </tr>
			<tr>
				<td>#dateformat(get_in_out.FINISH_DATE,dateformat_style)#</td>
			</tr>
            <tr>
            	<td style="height:8mm;">&nbsp;</td>
            </tr>
            <tr>
            	<td>İşveren veya İşveren Vekilinin</td>
            </tr>
            <tr>
            	<td style="height:5mm;">&nbsp;</td>
            </tr>
            <tr>
            	<td><cfif len(get_last_position_name.COMPANY_NAME)>#get_last_position_name.COMPANY_NAME#</cfif></td>
            </tr>           
        </table>
        </td>
    </tr>
	</cfoutput>
</table>
