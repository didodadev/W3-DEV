<cfsetting showdebugoutput="no">
<style type="text/css">
<!--
table 
	{
		border-top: solid 1 black;
		border-left: solid 1 black;
		border-bottom: solid 1 black;
		border-right: solid 1 black;
	}
-->
</style>
<cfif isdefined("attributes.database1") and len(attributes.database1)>
    <cfquery name="dt_name" datasource="#attributes.database1#">
        SELECT DISTINCT
            TABLE_NAME
        FROM 
            INFORMATION_SCHEMA.COLUMNS 
        ORDER BY TABLE_NAME
    </cfquery>
</cfif>
<cfset list_company=''>
<table cellspacing="0" cellpadding="0" border="2"  width="100%">
	<tr class="color-list">
    	<td class="headbold" style="text-align:left;height:35px"><cf_get_lang dictionary_id='29527.VeriTabanı History Karşılaştırma'></td>
	</tr>
	<tr class="color-row">
		<td  height="15%">
			<cfform name="db_diff" action="#request.self#?fuseaction=objects.popup_dsp_history_diff.cfm" method="post">
				<table border="0" cellspacing="0" cellpadding="2" align="center">
                	<tr>
                    	<td colspan="2" style="text-align:center">DB (workcube_cf) </td>
                    </tr>
					<tr>
						<td>DSN</td>
                        <td>
                        	<cfoutput>
                                <select name="database1" id="database">
                                   <option <cfif isdefined('attributes.database1') and attributes.database1 eq 'workcube_cf'>selected</cfif>>#dsn#</option>
                                   <option <cfif isdefined('attributes.database1') and attributes.database1 eq 'workcube_cf_1'>selected</cfif>>#dsn#_#session.ep.company_id#</option>
                                   <option <cfif isdefined('attributes.database1') and attributes.database1 eq 'workcube_cf_2011_1'>selected</cfif>>#dsn#_#session.ep.period_year#_#session.ep.company_id#</option>
                                   <option <cfif isdefined('attributes.database1') and attributes.database1 eq 'workcube_cf_product'>selected</cfif>>#dsn#_product</option>
                                 </select>
                            </cfoutput> 
                        </td>
					</tr>
					<tr>
						<td colspan="2" style="text-align:center">
							<cf_workcube_buttons 
								is_upd='0'
								insert_info='Karşılaştır' 
								insert_alert='' 
								is_cancel='0'>
						</td>
					</tr>
				</table>
			</cfform>
		</td>
    </tr>
	<cfif isdefined('attributes.database1') and len(attributes.database1)>
    <tr class="color-row" style="text-align:center">
        <td>
            <table border="1" align="center" cellpadding="0" cellspacing="0">
                <tr>
                	<td style="text-align:500px"><strong>Database İsmi</strong></td>
                    <td><strong>History-Database İsmi </strong></td>
                </tr>
                <cfquery name="dt1" dbtype="query">
                	SELECT * FROM dt_name WHERE TABLE_NAME LIKE '%HISTORY%'
                </cfquery>
                <cfset total_count=dt1.recordcount>
				<cfoutput query="dt1">
                	<cfset adres = TABLE_NAME>
                    	<cfif left(adres,1) neq '_'>
							<cfset adres2 =  left(adres,find('_HISTORY',adres)-1)>
                            <cfquery name="dt2" dbtype="query">
                                SELECT * FROM dt_name WHERE TABLE_NAME='#adres2#'
                            </cfquery>
                            <tr>
                                <td <cfif dt2.recordcount eq 0> style="color:FF0000;" </cfif>><cfif dt2.recordcount neq 0>#adres2#<cfelse><cf_get_lang dictionary_id='60026.Tablo Mevcut Değil'></cfif></td>
                                <td <cfif dt2.recordcount eq 0> style="color:FF0000;" </cfif>>#adres#</td>
                            </tr>
                            <cfquery name="dt_name_branch" datasource="#attributes.database1#">
                                SELECT 
                                    COLUMN_NAME,
                                    DATA_TYPE,
                                    IS_NULLABLE,
                                    CHARACTER_MAXIMUM_LENGTH,
                                    COLUMNPROPERTY(OBJECT_ID('#adres2#'), COLUMN_NAME, 'ISIDENTITY')
                                FROM 
                                    INFORMATION_SCHEMA.COLUMNS 
                                WHERE 
                                    TABLE_NAME='#adres2#'
                            </cfquery>
                            <cfquery name="dt_name_history" datasource="#attributes.database1#">
                                SELECT 
                                    COLUMN_NAME,
                                    DATA_TYPE,
                                    IS_NULLABLE,
                                    CHARACTER_MAXIMUM_LENGTH,
                                    COLUMNPROPERTY(OBJECT_ID('#adres#'), COLUMN_NAME, 'ISIDENTITY')
                                FROM 
                                    INFORMATION_SCHEMA.COLUMNS 
                                WHERE 
                                    TABLE_NAME='#adres#'
                            </cfquery>
                            <cfquery name="get_columns_name" datasource="#attributes.database1#">
                                SELECT 
                                    COLUMN_NAME  
                                FROM 
                                    INFORMATION_SCHEMA.COLUMNS 
                                WHERE 
                                    TABLE_NAME='#adres#' 
                                AND COLUMN_NAME IN
                                    (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='#adres2#')
                            </cfquery>
                            <cfset vari=0>
                            <tr>
                                <td style="text-align:right;vertical-align:top">
                                    <table style="width:95%">
                                        <cfloop query="get_columns_name">
                                       <cfset varia=1>
                                            <cfquery name="different_db1" dbtype="query">
                                                SELECT * FROM dt_name_branch WHERE  COLUMN_NAME='#COLUMN_NAME#'
                                             </cfquery>
                                             <cfquery name="different_db1_history" dbtype="query">
                                                SELECT * FROM dt_name_history WHERE  COLUMN_NAME='#COLUMN_NAME#'
                                             </cfquery>
                                             <cfif (different_db1.data_type neq different_db1_history.data_type) or (different_db1.CHARACTER_MAXIMUM_LENGTH neq different_db1_history.CHARACTER_MAXIMUM_LENGTH) or (different_db1.IS_NULLABLE neq different_db1_history.IS_NULLABLE)>
                                                <cfif vari neq varia>
                                                    <cfset vari=1>
                                                    <tr><td colspan="4"><strong><cf_get_lang dictionary_id='60027.ORTAK ALANLARDA Kİ FARKLILIKLAR'></strong></td></tr>
                                                    <tr>
                                                        <td style="color:CC6666" nowrap="nowrap"><strong><cf_get_lang dictionary_id='57197.Alan Adı'></strong></td>
                                                        <td style="color:CC6666" nowrap="nowrap"><strong><cf_get_lang dictionary_id='43689.Alan Tipi'></strong></td>
                                                        <td style="color:CC6666" nowrap="nowrap"><strong><cf_get_lang dictionary_id='60028.Alan Uzunluğu'></strong></td>
                                                        <td style="color:CC6666" nowrap="nowrap"><strong>Null</strong></td>
                                                    </tr>
                                                </cfif>	
                                                    <tr>
                                                        <td style="color:CC6666">#different_db1.column_name#</td>
                                                        <td style="color:CC6666">#different_db1.data_type#</td>
                                                        <td style="color:CC6666;text-align:center"><cfif len(different_db1.CHARACTER_MAXIMUM_LENGTH)>#different_db1.CHARACTER_MAXIMUM_LENGTH#<cfelse>-</cfif></td>
                                                        <td style="color:CC6666">#different_db1.IS_NULLABLE#</td>
                                                    </tr>
                                            </cfif>
                                        </cfloop>
                                       <cfset vari=0>
                                  </table>
                                     
                                </td>
                                <td style="text-align:center;vertical-align:top">
                                    <table style="width:95%">
                                        <cfloop query="get_columns_name">
                                             <cfquery name="different_db1" dbtype="query">
                                                SELECT * FROM dt_name_branch WHERE  COLUMN_NAME='#COLUMN_NAME#'
                                             </cfquery>
                                             <cfquery name="different_db1_history" dbtype="query">
                                                SELECT * FROM dt_name_history WHERE  COLUMN_NAME='#COLUMN_NAME#'
                                             </cfquery>
                                             <cfif (different_db1.data_type neq different_db1_history.data_type) or (different_db1.CHARACTER_MAXIMUM_LENGTH neq different_db1_history.CHARACTER_MAXIMUM_LENGTH) or (different_db1.IS_NULLABLE neq different_db1_history.IS_NULLABLE)>
                                             <cfif vari neq varia>
                                                <cfset vari=1>
                                                <tr><td colspan="4"><strong><cf_get_lang dictionary_id='60027.ORTAK ALANLARDA Kİ FARKLILIKLAR'></strong></td></tr> 
                                                <tr>
                                                    <td nowrap="nowrap" style="color:CC6666"><strong><cf_get_lang dictionary_id='57197.Alan Adı'></strong></td>
                                                    <td nowrap="nowrap" style="color:CC6666"><strong><cf_get_lang dictionary_id='43689.Alan Tipi'></strong></td>
                                                    <td nowrap="nowrap" style="color:CC6666; text-align:center"><strong><cf_get_lang dictionary_id='60028.Alan Uzunluğu'></strong></td>
                                                    <td nowrap="nowrap" style="color:CC6666"><strong>Null</strong></td>
                                                </tr>
                                             </cfif>	
                                                <tr >
                                                    <td nowrap="nowrap" style="color:CC6666">#different_db1_history.column_name#</td>
                                                    <td nowrap="nowrap" style="color:CC6666">#different_db1_history.data_type#</td>
                                                    <td nowrap="nowrap" style="color:CC6666; text-align:center"><cfif len(different_db1_history.CHARACTER_MAXIMUM_LENGTH)>#different_db1_history.CHARACTER_MAXIMUM_LENGTH#<cfelse>-</cfif></td>
                                                    <td nowrap="nowrap" style="color:CC6666">#different_db1_history.IS_NULLABLE#</td>
                                                </tr>
                                            </cfif>
                                        </cfloop>
                                    </table>
                                    <cfif dt2.recordcount neq 0>
                                        <cfquery name="dif_col_history" datasource="#attributes.database1#">
                                            SELECT 
                                                COLUMN_NAME,
                                                DATA_TYPE,
                                                IS_NULLABLE,
                                                CHARACTER_MAXIMUM_LENGTH,
                                                COLUMNPROPERTY(OBJECT_ID('#adres#'), COLUMN_NAME, 'ISIDENTITY')
                                            FROM 
                                                INFORMATION_SCHEMA.COLUMNS 
                                            WHERE 
                                                TABLE_NAME='#adres#' 
                                            AND COLUMN_NAME NOT IN
                                                (SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='#adres2#')
                                            AND  COLUMNPROPERTY(OBJECT_ID('#adres#'), COLUMN_NAME, 'ISIDENTITY')=0
                                        </cfquery>
                                        <cfif dif_col_history.recordcount>
                                            <table style="width:95%">
                                                <tr>
                                                    <td colspan="4"><strong><cf_get_lang dictionary_id='60029.ORTAK OLMAYAN ALANLAR'></strong></td>
                                                </tr>
                                                <cfloop query="dif_col_history">
													<cfif left(COLUMN_NAME,1) neq '_'> 
                                                        <tr>
                                                            <td>#COLUMN_NAME#</td>
                                                            <td>#DATA_TYPE#</td>
                                                            <td>#CHARACTER_MAXIMUM_LENGTH#</td>
                                                            <td>#IS_NULLABLE#</td>
                                                        </tr>
                                                    </cfif>	
                                                </cfloop>
                                           </table> 
                                       </cfif> 
                                   </cfif>     
                                </td>
                           </tr>
                        </cfif>    
                </cfoutput>
			</table>
        </td>
    </tr>
    </cfif>
</table>
