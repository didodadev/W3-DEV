<cfquery name="GET_LAST_GUARANTIES" datasource="#DSN3#">
	SELECT 
		SG.RECORD_DATE,
		SG.IS_SALE,
		SG.SALE_GUARANTY_CATID,
		SG.PURCHASE_GUARANTY_CATID,
		SG.PROCESS_CAT,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		D.DEPARTMENT_HEAD
	FROM 
		SERVICE_GUARANTY_NEW SG,
		#dsn_alias#.EMPLOYEES E,
		#dsn_alias#.DEPARTMENT D
	WHERE 
		<cfif isdefined("session.pp.userid")>
			(SG.SALE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> OR SG.PURCHASE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">) AND
		<cfelseif isdefined("session.ww.userid")>
			(SG.SALE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> OR SG.PURCHASE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">) AND
		<cfelse>
			1 = 0 AND
		</cfif>
		SG.RECORD_EMP = E.EMPLOYEE_ID AND 
		SG.DEPARTMENT_ID = D.DEPARTMENT_ID AND 
		SG.SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_serial_no#">
	ORDER BY
		SG.GUARANTY_ID DESC
</cfquery>	
<table cellpadding="2" cellspacing="2" style="width:100%;">
	<tr style="height:22px;">
		<td class="formbold" colspan="7"><cf_get_lang no='636.Seri No Tarihçesi'></td>
	</tr>
	<tr class="color-list" style="height:22px;">
		<td class="txtboldblue"></td>
		<td class="txtboldblue"><cf_get_lang_main no='218.Tip'></td>
		<td class="txtboldblue"><cf_get_lang no='637.Garanti Kategori'></td>
		<td class="txtboldblue"><cf_get_lang_main no='388.İşlem Tipi'></td>
		<td class="txtboldblue" style="width:100px;"><cf_get_lang_main no='71.Kayıt'></td>
		<td class="txtboldblue" style="width:65px;"><cf_get_lang_main no='330.Tarih'></td>
		<td class="txtboldblue"><cf_get_lang_main no='1351.Depo'></td>
	</tr>
	<cfif get_last_guaranties.recordcount>
		<cfoutput query="get_last_guaranties">
            <tr class="color-row">
                <td>#currentrow#</td>
                <td>
                    <cfif is_sale eq 1>
                        <cf_get_lang_main no='36.Satış'> <cfset attributes.guarantycat_id = sale_guaranty_catid>
                    <cfelse>
                        <cf_get_lang_main no='764.Alış'> <cfset attributes.guarantycat_id = purchase_guaranty_catid>
                    </cfif>
                </td>
                <td>
                    <cfif len(attributes.guarantycat_id)>
                        <cfquery name="GET_GUARANTY_CAT" datasource="#DSN#">
                            SELECT *,(SELECT GUARANTYCAT_TIME FROM SETUP_GUARANTYCAT_TIME WHERE GUARANTYCAT_TIME_ID = SETUP_GUARANTY.GUARANTYCAT_TIME) GUARANTYCAT_TIME_ FROM SETUP_GUARANTY WHERE GUARANTYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.guarantycat_id#">
                        </cfquery>
                        #get_guaranty_cat.guarantycat# - #get_guaranty_cat.guarantycat_time_# <cf_get_lang_main no='1312.Ay'>
                    </cfif>
                </td>
                <td>#get_process_name(process_cat)#</td>
                <td>#employee_name# #employee_surname#</td>
                <td>#dateformat(record_date,'dd/mm/yyyy')#</td>
                <td>#department_head#</td>
            </tr>	
        </cfoutput>
	</cfif>
</table>
