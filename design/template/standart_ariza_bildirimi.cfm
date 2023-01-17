<!--- Arıza Bildirimi --->
<cf_get_lang_set module_name="assetcare"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="GET_ASSET_FAILURE" datasource="#dsn#">
	SELECT 
		AFN.DOCUMENT_NO BELGE_NO,
		AFN.DETAIL ACIKLAMA,
        AFN.STATION_ID,
        AFN.PROJECT_ID,
        AFN.FAILURE_DATE,
        AFN.RECORD_DATE,
        AFN.FAILURE_EMP_ID,
		AFN.SEND_TO_ID,
        AFN.FAILURE_STAGE,
        A.ASSETP_ID,
        A.ASSETP
	FROM
		ASSET_FAILURE_NOTICE AFN,
        ASSET_P A
	WHERE
		AFN.FAILURE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type#"> AND
        A.ASSETP_ID = AFN.ASSETP_ID
</cfquery>
<!--- asama --->
<cfif len(GET_ASSET_FAILURE.FAILURE_STAGE)>
    <cfquery name="get_stage" datasource="#dsn#">
		SELECT
			PTR.STAGE,
			PTR.PROCESS_ROW_ID 
		FROM
			PROCESS_TYPE_ROWS PTR,
			PROCESS_TYPE_OUR_COMPANY PTO,
			PROCESS_TYPE PT
		WHERE
			PT.IS_ACTIVE = 1 AND
			PT.PROCESS_ID = PTR.PROCESS_ID AND
			PT.PROCESS_ID = PTO.PROCESS_ID AND
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
			PTR.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_ASSET_FAILURE.FAILURE_STAGE#">
    </cfquery>
</cfif>
<!--- arıza kodu --->
<cfquery name="get_failure_using_code" datasource="#dsn3#">
	SELECT
		SSC.SERVICE_CODE_ID,
		SSC.SERVICE_CODE
	FROM 
		#dsn_alias#.FAILURE_CODE_ROWS FCR,
		SETUP_SERVICE_CODE SSC
	WHERE 
		FCR.FAILURE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type#"> AND
		FCR.FAILURE_CODE_ID = SSC.SERVICE_CODE_ID
</cfquery>
<cfset ariza_kodu = valuelist(get_failure_using_code.SERVICE_CODE)>

<!--- istasyon --->
<cfif len(get_asset_failure.station_id)>
	<cfset new_dsn3 = "#dsn#_#session.ep.company_id#">
    <cfquery name="GET_STATION" datasource="#new_dsn3#">
        SELECT STATION_ID,STATION_NAME FROM WORKSTATIONS WHERE STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_asset_failure.station_id#">
    </cfquery>
</cfif>

<cfif len(get_asset_failure.project_id)>
	<cfquery name="GET_PROJECT" datasource="#DSN#">
		SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_asset_failure.project_id#">
	</cfquery>
</cfif>

<table border="0" cellpadding="0" cellspacing="0" style="width:190mm;">
    <tr>
        <td style="width:10mm;" rowspan="30">&nbsp;</td>
        <td style="height:8mm;">&nbsp;</td>
    </tr>
    <tr>
    	<td valign="top">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
        	<cfoutput>
            <tr>
            	<td class="formbold" style="height:8mm; width:60mm;" align="center">#get_asset_failure.BELGE_NO#</td>
                <td style="width:69mm;">&nbsp;</td>
                <td class="formbold" style="width:60mm;" align="center">#dateformat(now(),dateformat_style)#</td>
            </tr>
            <tr>
            	<td colspan="3" class="headbold" align="center" style="height:8mm;"><cf_get_lang no='787.ARIZA BİLDİRİMİ'></td>
            </tr>
            <tr><td colspan="3" style="height:15mm;">&nbsp;<!--- ara bosluk ---></td></tr>
            <tr>
            	<td colspan="3">
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                	<tr>
                    	<td class="formbold" style="height:6mm;"><cf_get_lang_main no='1422.İstasyon'>-<cf_get_lang_main no='1655.Varlık'></td>
                        <td class="formbold"><cf_get_lang_main no='1522.Arıza Kodu'></td>
                        <td class="formbold"><cf_get_lang no="214.İlgili Proje"></td>
                        <td class="formbold"><cf_get_lang no='8.Arıza Tarihi'></td>
                        <td class="formbold"><cf_get_lang no='25.Bildirim Tarihi'></td>
                        <td class="formbold"><cf_get_lang_main no='1447.Süreç'></td>
                    </tr>
                    <tr>
                    	<td style="width:35mm; height:6mm;">
						  <cfif len(get_asset_failure.station_id)>#get_station.station_name#</cfif> <cfif len(get_asset_failure.ASSETP)>- #get_asset_failure.ASSETP#</cfif>
                        </td>
                        <td style="width:19mm;">#ariza_kodu#</td>
                        <td style="width:19mm;"><cfif len(get_asset_failure.project_id)>#get_project.project_head#</cfif></td>
                        <td style="width:12mm;">#dateformat(get_asset_failure.failure_date,dateformat_style)#</td>
                        <td style="width:12mm;">#dateformat(get_asset_failure.record_date,dateformat_style)#</td>
                        <td style="width:10mm;"><cfif len(get_asset_failure.failure_stage)>#get_stage.stage#</cfif></td>
                    </tr>
                    <tr><td colspan="6" style="height:5mm;">&nbsp;</td></tr>
                </table>
                </td>
            </tr>
            <tr>
                <td colspan="3" class="formbold" style="height:6mm;"><cf_get_lang_main no='217.Açıklama'></td>
            </tr>
            <tr>
            	<td colspan="3" style="height:25mm;" valign="top">#get_asset_failure.ACIKLAMA#</td>
            </tr>
            <tr>
            	<td colspan="3">
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                	<tr>
                        <td style="height:6mm;" class="formbold"><cf_get_lang no="217.Bildirimi Yapan"></td>
                        <td style="height:6mm;" class="formbold"><cf_get_lang no="233.Bildirimi Yapılan"></td>
                    </tr>
                    <tr>
                        <td style="height:6mm;">
							<cfif len(get_asset_failure.failure_emp_id)>#get_emp_info(get_asset_failure.failure_emp_id,0,0)#</cfif>
                        </td>
                        <td>
							<cfif len(get_asset_failure.send_to_id)>#get_emp_info(get_asset_failure.send_to_id,0,0)#</cfif>
                        </td>
                    </tr>
                </table>
                </td>
            </tr>
			</cfoutput>
        </table>
        </td>
	</tr>
</table>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
