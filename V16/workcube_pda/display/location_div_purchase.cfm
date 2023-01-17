<!--- Tum PDAlerde Ortak Kullanilan Depo Sayfasi --->
<cfsetting showdebugoutput="no">
<cfquery name="getSelectedDepartmentLocation" datasource="#DSN#">
	SELECT
		D.DEPARTMENT_ID,
		B.BRANCH_ID,
		B.COMPANY_ID,
		B.BRANCH_NAME,			
		D.DEPARTMENT_HEAD,
		SL.COMMENT LOCATION_NAME,
		SL.LOCATION_ID,
		D.DEPARTMENT_HEAD + ' - ' + SL.COMMENT AS DEPARTMENT_LOCATION
	FROM 
		DEPARTMENT D,
		BRANCH B,
		STOCKS_LOCATION SL
	WHERE 
		D.IS_STORE <> 2 AND
		D.DEPARTMENT_STATUS = 1 AND
		B.BRANCH_ID = D.BRANCH_ID AND
		SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		<!--- D.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#">)  --->
		B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#"> AND
		SL.STATUS = 1 AND 
		( CAST(D.DEPARTMENT_ID AS NVARCHAR) + '-' + CAST(SL.LOCATION_ID AS NVARCHAR) IN (SELECT LOCATION_CODE FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#">) OR D.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#"> AND LOCATION_ID IS NULL) ) 
		<cfif isDefined("attributes.keyword") and Len(attributes.keyword)>
			AND (
					D.DEPARTMENT_HEAD + ' - ' + SL.COMMENT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UrlDecode(attributes.keyword)#%"> OR
					D.DEPARTMENT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UrlDecode(attributes.keyword)#%"> OR
					SL.COMMENT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UrlDecode(attributes.keyword)#%">
				)
		</cfif>
	ORDER BY
		DEPARTMENT_LOCATION
</cfquery>
<cf_box title="Depo- Lokasyon" body_style="overflow:auto;height:100px;">
    <table cellspacing="0" cellpadding="0" border="0" align="center" style="width:98%;">
        <tr class="color-border">
            <td>
                <table cellspacing="1" cellpadding="2" border="0" style="width:100%;">
                    <tr class="color-header" style="height:22px;">		
                        <td class="form-title" style="width:20px;">No</td>
                        <td class="form-title">Depo- Lokasyon</td>
                    </tr>
                    <cfif getSelectedDepartmentLocation.recordcount>
                        <cfoutput query="getSelectedDepartmentLocation">		
                            <tr class="color-row" style="height:20px;">
                                <td>#currentrow#</td>
                                <td><a href="javascript://" class="tableyazi"  onclick="add_location_div('#branch_id#','#department_id#','#location_id#','#department_location#')">#department_location#</a></td>
                            </tr>		
                        </cfoutput>
                    <cfelse>
                        <tr class="color-row" style="height:20px;">
                            <td colspan="3">Kayıt Yok !</td>
                        </tr>
                    </cfif>
                </table>
            </td>
        </tr>
    </table>
</cf_box>

<script language="javascript" type="text/javascript">
	function add_location_div(branch_value,department_value,location_value,department_location_value)
	{
		<cfoutput>
		<cfif isdefined("attributes.branch_id") and Len(attributes.branch_id)>
			document.getElementById("#attributes.branch_id#").value = branch_value;
		</cfif>
		<cfif isdefined("attributes.department_id") and Len(attributes.department_id)>
			document.getElementById("#attributes.department_id#").value = department_value;
		</cfif>
		<cfif isdefined("attributes.location_id") and Len(attributes.location_id)>
			document.getElementById("#attributes.location_id#").value = location_value;
		</cfif>		
		<cfif isdefined("attributes.department_location") and Len(attributes.department_location)>
			document.getElementById("#attributes.department_location#").value = department_location_value;
		</cfif>
		
		gizle(document.getElementById("#attributes.div_name#"));
		</cfoutput>
	}
</script>
