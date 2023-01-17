<cfif isdefined("attributes.product_serial_no") and len(attributes.product_serial_no)>
	<cfquery name="GET_SEARCH_RESULTS_" datasource="#DSN3#" maxrows="1">
		SELECT 
			SG.PROCESS_ID,
			SG.STOCK_ID,
			SG.GUARANTY_ID,
			SG.IS_SALE,
			SG.PURCHASE_GUARANTY_CATID,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			D.DEPARTMENT_HEAD,
			S.PRODUCT_NAME
		FROM 
			SERVICE_GUARANTY_NEW SG,
			STOCKS S,
			#DSN_ALIAS#.EMPLOYEES E,
			#DSN_ALIAS#.DEPARTMENT D
		WHERE 
			SG.RECORD_EMP = E.EMPLOYEE_ID
			AND SG.DEPARTMENT_ID = D.DEPARTMENT_ID
			AND SG.STOCK_ID = S.STOCK_ID
			AND SG.SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_serial_no#">
		ORDER BY SG.GUARANTY_ID DESC
	</cfquery>
	<cfif get_search_results_.recordcount and len(get_search_results_.process_id)>
		<cfquery name="GET_RELATED_RESULTS_" datasource="#DSN3#">
			SELECT 
				SG.GUARANTY_ID,
                SG.SALE_GUARANTY_CATID,
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				D.DEPARTMENT_HEAD,
				S.PRODUCT_NAME
			FROM 
				SERVICE_GUARANTY_NEW SG,
				STOCKS S,
				#DSN_ALIAS#.EMPLOYEES E,
				#DSN_ALIAS#.DEPARTMENT D
			WHERE 
				SG.RECORD_EMP = E.EMPLOYEE_ID
				AND SG.DEPARTMENT_ID = D.DEPARTMENT_ID
				AND SG.STOCK_ID = S.STOCK_ID
				AND RETURN_SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_serial_no#">
				AND RETURN_STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_search_results_.stock_id#">
				AND RETURN_PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_search_results_.process_id#">
			ORDER BY GUARANTY_ID DESC
		</cfquery>
	</cfif>
</cfif>

<table cellpadding="0" cellspacing="0" align="center" border="0" style="width:98%;">
	<tr>
		<td valign="top">
			<cfinclude template="serial_number.cfm">
			<br/>
			<cfif isdefined("attributes.product_serial_no") and len(attributes.product_serial_no) and get_search_results_.recordcount>
                <table cellpadding="2" cellspacing="1" class="color-border" align="center" style="width:98%; height:100%;">
                    <tr class="color-row">
                        <td>
                            <table>
                                <cfoutput query="get_search_results_">
                                    <tr>
                                        <td><b><cf_get_lang_main no='245.Ürün'> : #product_name#-#guaranty_id#</b></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <b><cf_get_lang_main no='305.Garanti'> :</b>
                                            <cfif is_sale eq 1>
                                                <cf_get_lang_main no='36.Satış'> <cfset attributes.guarantycat_id = sale_guaranty_catid>
                                            <cfelse>
                                                <cf_get_lang_main no='764.Alış'> <cfset attributes.guarantycat_id = purchase_guaranty_catid>
                                            </cfif>
                                            Garantisi - 
                                            <cfif isdefined("attributes.guarantycat_id") and len(attributes.guarantycat_id)>
                                                <cfquery name="GET_GUARANTY_CAT" datasource="#DSN#">
                                                    SELECT *,(SELECT GUARANTYCAT_TIME FROM SETUP_GUARANTYCAT_TIME WHERE GUARANTYCAT_TIME_ID = SETUP_GUARANTY.GUARANTYCAT_TIME) GUARANTYCAT_TIME_ FROM  SETUP_GUARANTY WHERE GUARANTYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.guarantycat_id#">
                                                </cfquery>
                                                #get_guaranty_cat.guarantycat# - #get_guaranty_cat.guarantycat_time_# <cf_get_lang_main no='1312.Ay'>
                                            </cfif>
                                        </td>
                                    </tr>
                                </cfoutput>
                            </table>
                        </td>
                    </tr>
                </table>
			</cfif>
		</td>
	</tr>
</table>
