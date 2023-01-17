<!--- Çalışma Belgesi 20130214--->
<cfif get_module_user(48) eq 0>		
	<script type="text/javascript">
		alert("Yetkiniz Yok!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfset attributes.ID = attributes.iid>

<cfquery name="get_in_out" datasource="#DSN#" maxrows="1">
	SELECT
    	IN_OUT_ID,
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
    	EMPLOYEE_ID = #attributes.ID#
		<!---IN_OUT_ID = #attributes.ID#--->
    ORDER BY
    	START_DATE DESC
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
		UPPER(EMPLOYEE_NAME) AS EMPLOYEE_NAME,
		UPPER(EMPLOYEE_SURNAME) AS EMPLOYEE_SURNAME,
        BIRTH_DATE,
		BIRTH_PLACE,
        FATHER,
		GROUP_STARTDATE,
		PHOTO_SERVER_ID,
		EI.TC_IDENTY_NO,
		E.KIDEM_DATE
	FROM 
		EMPLOYEES E,
		EMPLOYEES_IDENTY EI
	WHERE 
		E.EMPLOYEE_ID = #attributes.employee_id# AND
		E.EMPLOYEE_ID = EI.EMPLOYEE_ID
</cfquery>
<cfquery name="get_last_position_name" datasource="#DSN#" maxrows="1">
    SELECT
		E.EMPLOYEE_NO,
        EP.POSITION_NAME,
        D.DEPARTMENT_HEAD,
        ST.TITLE,
        B.BRANCH_NAME,
        B.POSITION_NAME,
        B.SSK_NO,
        O.COMPANY_NAME,
        O.ADDRESS
    FROM 
        EMPLOYEE_POSITIONS EP,
        EMPLOYEES E,
        DEPARTMENT D,
        SETUP_TITLE ST,
        BRANCH B,
        OUR_COMPANY O
    WHERE
        EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND
        EP.EMPLOYEE_ID = #attributes.employee_id#
        AND D.DEPARTMENT_ID = EP.DEPARTMENT_ID
        AND EP.IS_MASTER = 1
        AND ST.TITLE_ID = EP.TITLE_ID
        AND B.BRANCH_ID = D.BRANCH_ID
    ORDER BY 
        POSITION_ID DESC
</cfquery>
<cfquery name="get_salary" datasource="#dsn#">
    SELECT 
        M#month(now())# AS UCRET
    FROM 
        EMPLOYEES_SALARY 
    WHERE 
        IN_OUT_ID = #get_in_out.in_out_id# AND 
        EMPLOYEE_ID = #attributes.employee_id# AND
        PERIOD_YEAR = #year(now())#
</cfquery>
<style>
	table,td{ font-family:Arial, Helvetica, sans-serif; font-size:12px;}
</style>
<table style="width:16cm;heigth:29cm;" border="0" align="center">
    <tr>
        <td height="180px;">&nbsp;</td>
    </tr>
    <tr>
        <td>
            <table  style="width:16cm;heigth:29cm;" border="0">
            <cfoutput>
                <tr height="30">
                    <td colspan="3" style="text-align:right"><b>TARİH : #dateformat(now(),dateformat_style)#</b></td>
                </tr>
                <tr>
                    <td colspan="3" style="text-align:center;height:50px;"><b>ÇALIŞMA BELGESİ</b></td>
                </tr>
                <tr height="30">
                    <td style="width:270px,"><b>ADI - SOYADI</b></td>
                    <td style="width:200px;">:&nbsp; #get_emp_short_info.EMPLOYEE_NAME# #get_emp_short_info.EMPLOYEE_SURNAME#</td>
                    <td style="width:55mm; height:60mm;text-align:center" rowspan="6" valign="top">
                        <cfif len(get_emp_short_info.photo)>
                            <cf_get_server_file output_file="hr/#get_emp_short_info.photo#" output_server="#get_emp_short_info.photo_server_id#" output_type="0" image_width="120" image_height="156">
                        <cfelse>
                            Foto
                        </cfif>
                    </td>
                </tr>
                <tr height="30">
                    <td><b>DOĞUM YERİ ve TARİHİ</b></td>
                    <td>:&nbsp; <cfif len(get_emp_short_info.BIRTH_PLACE)>#get_emp_short_info.BIRTH_PLACE# -</cfif> #DateFormat(get_emp_short_info.BIRTH_DATE, dateformat_style)#</td>
                </tr>
                <tr height="30">
                    <td><b>İŞYERİ SİCİL NO</b></td>
                    <td>:&nbsp; #get_last_position_name.EMPLOYEE_NO#</td>
                </tr>
                <tr height="30">
                    <td><b>TC KİMLİK NO</b></td>
                    <td>:&nbsp; #get_emp_short_info.TC_IDENTY_NO#</td>
                </tr>
                <tr height="30">
                    <td><b>İŞE GİRİŞ TARİHİ</b></td>
                    <td>:&nbsp; #dateformat(get_emp_short_info.kidem_date,dateformat_style)#</td>
                </tr>
                <tr height="30">
                    <td><b>İŞTEN ÇIKIŞ TARİHİ</b></td>
                    <td>:&nbsp; #dateformat(get_in_out.finish_date,dateformat_style)#</td>
                </tr>
                <tr height="30">
                    <td><b>SON GÖREVİ</b></td>
                    <td>:&nbsp; #get_last_position_name.position_name#</td>
                </tr>
                <tr height="30">
                    <td><b>SON ÜCRET</b></td>
                    <td>:&nbsp; #TlFormat(get_salary.ucret)# TL/Ay</td>
                </tr>
                <tr>
                    <td colspan="3" style="height:13mm;">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="3">Yukarıda bilgileri belirtilen <b>#get_emp_short_info.EMPLOYEE_NAME# #get_emp_short_info.EMPLOYEE_SURNAME#</b>
                            <b>#dateformat(get_emp_short_info.KIDEM_DATE,dateformat_style)#</b> <cfif len(get_in_out.FINISH_DATE)>tarihinden  <b>#dateformat(get_in_out.FINISH_DATE,dateformat_style)#</b> tarihine kadar kurumumuzda çalışmıştır<cfelse>tarihinden beri kurumumuzda çalışmaktadır</cfif>.
                    </td>
                </tr>
                <tr>
                    <td style="text-align:justify;" colspan="3">İş bu belge 4857 sayılı kanunun 28'nci maddesine göre düzenlenmiştir.</td>
                </tr>
                <tr>
                    <td height="50px;"></td>
                </tr>
                <tr>
                    <td colspan="3"><b>Saygılarımızla,</b></td>
                </tr>
                </cfoutput>
            </table>
        </td>
    </tr>
</table>
