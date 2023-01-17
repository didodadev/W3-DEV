<!--- Standart Zimmet Tutanak --->
<cfset attributes.ID =action_id>
<cfquery name="get_debt" datasource="#dsn#">
	SELECT
		*
	FROM
		EMPLOYEES_INVENT_ZIMMET EIZ,
		EMPLOYEES_INVENT_ZIMMET_ROWS EIZR
	WHERE
		EIZ.ZIMMET_ID = EIZR.ZIMMET_ID AND
		EIZ.ZIMMET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cfquery name="get_department_id" datasource="#DSN#">
		SELECT 
		EP.DEPARTMENT_ID,
		EP.EMPLOYEE_ID
	FROM
		EMPLOYEES_INVENT_ZIMMET EIZ,
		EMPLOYEE_POSITIONS EP
	WHERE 
		EP.EMPLOYEE_ID = EIZ.EMPLOYEE_ID
		AND EIZ.ZIMMET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
	 	AND EP.IS_MASTER= 1
</cfquery>
<cfset attributes.department_id =  get_department_id.DEPARTMENT_ID>
<cfquery name="CHECK" datasource="#DSN#">
	SELECT 
		ASSET_FILE_NAME2, 
		COMPANY_NAME, 
		TEL_CODE,
		TEL,
		TEL2,
		TEL3,
		TEL4,
		FAX,
		ADDRESS,
		WEB,
		EMAIL
	FROM 
	 	OUR_COMPANY 
	WHERE 
		COMP_ID = #session.ep.company_id#
</cfquery>
<br/><br/><br/><br/><br/>
<table bgcolor="FFFFFF" width="650" align="center">
	<tr>
		<cfoutput>
        <td></td>
        <td valign="bottom"> <span class="headbold">#CHECK.company_name# </span>
            <br/><br/>
            #CHECK.address#<br/>
            <b><cf_get_lang_main no='87.Tel'>:</b>(#CHECK.tel_code#) - 
			<cfif Len(CHECK.tel)>#CHECK.tel#,</cfif>
			<cfif Len(CHECK.tel2)>#CHECK.tel2#,</cfif>
			<cfif Len(CHECK.tel3)>#CHECK.tel3#,</cfif>
			<cfif Len(CHECK.tel4)>#CHECK.tel4# </cfif><b>
            <cf_get_lang_main no='76.Fax'>:</b>#CHECK.fax#<br/>
            #CHECK.web# - #CHECK.email#
        </td>
        <td style="text-align:right;"><img src="#file_web_path#settings/#CHECK.asset_file_name2#" border="0"></td>
		</cfoutput>
    </tr>
</table>
<br/><br/><br/><br/>
<table bgcolor="FFFFFF" width="600" align="center">
    <tr>
        <td width="120">&nbsp;</td>
        <td align="center"><b><font size="+1" face="Arial, Helvetica, sans-serif"><cf_get_lang no="815.Zimmet Tutanağı"></font></b></td>
        <td style="text-align:right;"><cf_get_lang_main no='330.Tarih'>: .../.../.....</td>
    </tr>
</table>
<br/><br/>
<table width="600" cellpadding="3" cellspacing="3" align="center">
    <tr class="formbold">
        <td width="33%" align="left" bgcolor="CCCCCC"><cf_get_lang_main no='1655.Varlık'></td>
        <td width="33%" align="left" bgcolor="CCCCCC"><cf_get_lang no='245.Varlık Tipi'></td>
    </tr>
	<cfoutput query="get_debt">
    <tr>
        <td align="left">#DEVICE_NAME#</td>
        <td align="left">#PROPERTY#</td>
    </tr>
    </cfoutput>
</table>
<br/><br/><br/><br/><br/><br/>
<cfoutput>
    <table width="650" cellpadding="3" cellspacing="3" align="center">
            <tr>
                <td align="left" colspan="2">
                    <cf_get_lang no="910.Yukarıda özellikleri belirtilen varlıklar kullanılması ve muhafaza edilmesi için"> 
                    <b>#get_emp_info(get_department_id.EMPLOYEE_ID,0,0)#</b>&nbsp;'a <cf_get_lang no="911.teslim edilmiş ve zimmetlenmiştir">.<br/><br/><br/>
                </td>
            </tr>
        <tr>
            <td width="75%"><b><cf_get_lang no="809.Zimmet Alan"></b></td>
            <td width="25%"><b><cf_get_lang no="814.Zimmet Veren"></b></td>
        </tr>
        <tr>
            <td width="75%">#get_emp_info(get_debt.EMPLOYEE_ID,0,0)#</td>
            <td width="25%">#CHECK.company_name#</td>
        </tr>
    </table>
</cfoutput>


