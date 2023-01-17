<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.document_number" default="">
<cfparam name="attributes.ship_method" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.ship_stage" default="">
<cfparam name="attributes.process_stage_type" default="">

<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
</cfif>	
<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
</cfif>

<cfset x_equipment_planning_info = 1>

<cfquery name="GET_SHIP_STAGE" datasource="#DSN#">
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
		<cfif isdefined("session.pp")>
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
		<cfelseif isdefined("session.ww")>
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
		<cfelse>
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		</cfif>
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%stock.list_packetship%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>

<cfif session_base.language neq 'tr'>
    <cfquery name="GET_FOR_STAGES" dbtype="query">
        SELECT 
            * 
        FROM 
            GET_ALL_FOR_LANGS 
        WHERE
        	TABLE_NAME = 'PROCESS_TYPE_ROWS' AND
            COLUMN_NAME = 'STAGE'
    </cfquery>

	<cfquery name="GET_FOR_SHIP_METS" dbtype="query">
    	SELECT 
        	* 
        FROM 
        	GET_ALL_FOR_LANGS 
        WHERE 
        	TABLE_NAME = 'SHIP_METHOD' AND 
            COLUMN_NAME = 'SHIP_METHOD' 
    </cfquery>
</cfif>  

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif isdefined("attributes.form_submitted")>
	<cfquery name="GET_SHIP_RESULT" datasource="#DSN2#">
    	WITH CTE1 AS(
            SELECT 
                SR.MAIN_SHIP_FIS_NO,
                SR.OUT_DATE, 
                SR.DELIVERY_DATE, 
                SR.SHIP_METHOD_TYPE, 
                SR.SHIP_STAGE,
                SR.EQUIPMENT_PLANNING_ID,
                SMT.SHIP_METHOD 	
            FROM 
                #dsn_alias#.SHIP_METHOD SMT,
                SHIP_RESULT SR
            WHERE 
                SR.SHIP_METHOD_TYPE = SMT.SHIP_METHOD_ID AND
                SR.MAIN_SHIP_FIS_NO IS NOT NULL
                <cfif x_equipment_planning_info eq 1>
                    AND SR.IS_ORDER_TERMS = 1
                    <!--- Siparis Numarasina Gore Arama --->
                    AND SR.SHIP_RESULT_ID IN(	
                                                SELECT
                                                    SRR.SHIP_RESULT_ID
                                                FROM
                                                    SHIP_RESULT_ROW SRR,
                                                    #dsn3_alias#.ORDERS O
                                                WHERE
                                                    SRR.ORDER_ID = O.ORDER_ID
                                                    <cfif len(attributes.document_number)>
                                                        AND O.ORDER_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.document_number#%">
                                                    </cfif>
                                                    AND O.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
	                                        )
                <cfelse>
                    AND SR.IS_ORDER_TERMS IS NULL
                    <cfif len(attributes.document_number)><!---  Irsaliye numarasina gore arama (xml de dikkate alinarak) --->
                        AND SR.SHIP_RESULT_ID IN(	
                                                    SELECT
                                                        SHIP_RESULT_ID
                                                    FROM
                                                        SHIP_RESULT_ROW
                                                    WHERE
                                                        SHIP_ID IN (SELECT SHIP_ID FROM SHIP WHERE SHIP_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.document_number#%">) OR SHIP_ID IS NULL
	                                            )		  
                    </cfif>
                    AND SR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
                </cfif>	
                <cfif len(attributes.keyword)>
                    AND 
                    (
                        SR.SHIP_FIS_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR 
                        SR.REFERENCE_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                        SR.SHIP_RESULT_ID IN(
                                                SELECT
                                                    SRR.SHIP_RESULT_ID
                                                FROM
                                                    SHIP_RESULT_ROW SRR
                                                WHERE
                                                    SRR.ORDER_ROW_ID IN (
                                                                            SELECT 
                                                                                ORDER_ROW_ID 
                                                                            FROM 
                                                                                #dsn3_alias#.ORDER_ROW 
                                                                            WHERE 
                                                                                PRODUCT_ID IN (
                                                                                                    SELECT 
                                                                                                        PRODUCT_ID 
                                                                                                    FROM 
                                                                                                        #dsn3_alias#.PRODUCT 
                                                                                                    WHERE 
                                                                                                        PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                                                                                               ) OR
                                                                                STOCK_ID IN	(
                                                                                                SELECT
                                                                                                    STOCK_ID
                                                                                                FROM
                                                                                                    #dsn3_alias#.STOCKS
                                                                                                WHERE
                                                                                                    STOCK_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
                                                                                            )	
                                                                        )
                                            )
                    )
                </cfif>
                <cfif len(attributes.process_stage_type)>
                    AND SR.SHIP_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage_type#"></cfif>
                <cfif len(attributes.start_date)>
                    AND SR.OUT_DATE >= #attributes.start_date#
                </cfif>
                <cfif len(attributes.finish_date)>
                    AND SR.OUT_DATE <= #attributes.finish_date#
                </cfif>
            GROUP BY 
                SR.MAIN_SHIP_FIS_NO,
                SR.OUT_DATE, 
                SR.DELIVERY_DATE, 
                SR.SHIP_METHOD_TYPE, 
                SR.SHIP_STAGE, 
                SR.EQUIPMENT_PLANNING_ID,
                SMT.SHIP_METHOD	
        ),
        CTE2 AS 
            (
                SELECT
                    CTE1.*,
                    ROW_NUMBER() OVER (ORDER BY OUT_DATE ASC) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                FROM
                    CTE1
            )
            SELECT
                CTE2.*
            FROM
                CTE2
            WHERE
                RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
	</cfquery>
<cfelse>
	<cfset get_ship_result.recordCount = 0>
</cfif>

<cfif get_ship_result.recordcount>
	<cfparam name="attributes.totalrecords" default='#get_ship_result.query_count#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>

<table border="0" cellspacing="0" cellpadding="0" align="center" style="width:100%; height:35px;">
	<tr>
	    <td class="headbold" style=" vertical-align:bottom;">
			<cfform name="form" method="post" action="#request.self#?fuseaction=objects2.list_packetship">
                <table align="right">
                    <input type="hidden" name="form_submitted" id="form_submitted" value="1">
                    <tr>
                        <cfoutput>
                        <td><cf_get_lang_main no='48.Filtre'> / <cf_get_lang_main no='809.Ürün Adı'></td>
                        <td><input type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="255" style="width:60px;"></td>
                        <td><cfif x_equipment_planning_info eq 0><cf_get_lang_main no='475.Irsaliye No'><cfelse><cf_get_lang_main no='799.Sipariş No'></cfif></td>
                        <td><input type="text" name="document_number" id="document_number" value="#attributes.document_number#" maxlength="255" style="width:60px;"></td>
                        <td>
                            <select name="process_stage_type" id="process_stage_type" style="width:90px;">
                                <option value=""><cf_get_lang_main no='70.Aşama'></option>
                                <cfloop query="get_ship_stage">
                                    <cfif session_base.language neq 'tr'>
                                        <cfquery name="GET_STAGE" dbtype="query">
                                            SELECT * FROM GET_FOR_STAGES WHERE UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#process_row_id#">
                                        </cfquery>
                                        <cfif get_stage.recordcount>
                                            <option value="#process_row_id#" <cfif (attributes.process_stage_type eq process_row_id)>selected</cfif>>#get_stage.item#</option>
                                        <cfelse>
                                            <option value="#process_row_id#" <cfif (attributes.process_stage_type eq process_row_id)>selected</cfif>>#stage#</option>
                                        </cfif>
                                    <cfelse>
                                        <option value="#process_row_id#" <cfif (attributes.process_stage_type eq process_row_id)>selected</cfif>>#stage#</option>
                                    </cfif>
                                </cfloop>
                            </select>
                        </td>
                        <td><cfsavecontent variable="message"><cf_get_lang no ='468.Lütfen Tarih Formatını Düzeltiniz'></cfsavecontent>
                            <cfinput value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" type="text" name="start_date" id="start_date" validate="eurodate" maxlength="10" message="#message#" style="width:65px;">
                            <cf_wrk_date_image date_field="start_date">
                        </td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang no ='468.Lütfen Tarih Formatını Düzeltiniz '></cfsavecontent>
                            <cfinput value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" type="text" name="finish_date" id="finish_date" style="width:65px;" validate="eurodate" maxlength="10" message="#message#">
                            <cf_wrk_date_image date_field="finish_date">
                        </td>
                        <td width="25">
                          <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                          <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                        </td>
                        <td><cf_wrk_search_button></td>
                        </cfoutput>
                    </tr>
                </table>
            </cfform>		
    	</td>
	</tr>
</table>
<table align="center" cellpadding="2" cellspacing="1" border="0" class="color-border" style="width:100%;">  
	<tr class="color-header" style="height:22px;">
		<td class="form-title" style="width:2%;"><cf_get_lang_main no='75.No'></td>
		<td class="form-title"><cf_get_lang no='454.Sevk No'></td>
		<cfif x_equipment_planning_info eq 1><td class="form-title"><cf_get_lang_main no='1458.Ekip-Araç'></td></cfif>
		<td class="form-title"><cf_get_lang_main no='1703.Sevk Yöntemi'></td>
		<td class="form-title"><cf_get_lang_main no='70.Aşama'></td>
		<td class="form-title"><cf_get_lang no='79.Sevkiyat'> <cf_get_lang_main no='1181.Tarihi'></td>
		<td class="form-title"><cf_get_lang_main no='233.Teslim'></td>
		<td class="form-title"><cf_get_lang_main no='217.Aciklama'></td>
	</tr>
	<cfif get_ship_result.recordcount>
		<cfset process_list=''>
		<cfset equipment_list = "">
		<cfoutput query="get_ship_result" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfif len(get_ship_result.ship_stage) and not listfind(process_list,get_ship_result.ship_stage)>
				<cfset process_list = listappend(process_list,get_ship_result.ship_stage)>
			</cfif>
			<cfif x_equipment_planning_info eq 1 and Len(equipment_planning_id) and not ListFind(equipment_list,equipment_planning_id)>
				<cfset equipment_list = ListAppend(equipment_list,equipment_planning_id)>
			</cfif>
		</cfoutput>
		<cfif len(process_list)>
			<cfset process_list=listsort(process_list,"numeric","ASC",",")>
			<cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
				SELECT STAGE,PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#process_list#)
			</cfquery>
			<cfset main_process_list = listsort(listdeleteduplicates(valuelist(get_process_type.process_row_id,',')),'numeric','ASC',',')>
		</cfif> 
		<cfif x_equipment_planning_info eq 1 and Len(equipment_list)>
			<cfquery name="GET_TEAM_ZONES" datasource="#DSN3#">
				SELECT PLANNING_ID,TEAM_CODE FROM DISPATCH_TEAM_PLANNING WHERE PLANNING_ID IN (#equipment_list#) ORDER BY PLANNING_ID
			</cfquery>
			<cfset equipment_list = ListSort(ListDeleteDuplicates(valuelist(get_team_zones.planning_id,',')),'Numeric','ASC',',')>
		</cfif>
		<cfoutput query="get_ship_result" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row" style="height:20px;">
				<td>#currentrow#</td>
				<td><a href="#request.self#?fuseaction=objects2.dsp_packetship&main_ship_fis_no=#main_ship_fis_no#" class="tableyazi">#main_ship_fis_no#</a></td>
				<cfif x_equipment_planning_info eq 1><td>#get_team_zones.team_code[ListFind(Equipment_List,equipment_planning_id,',')]#</td></cfif>
				<td>
                	<cfif session_base.language neq 'tr'>
                        <cfquery name="GET_FOR_SHIP_MET" dbtype="query">
                            SELECT * FROM GET_FOR_SHIP_METS WHERE UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ship_method_type#">
                        </cfquery>
                        <cfif get_for_ship_met.recordcount>
                        	#get_for_ship_met.item#
                        <cfelse>
	                        #ship_method#
						</cfif>
                    <cfelse>
                        #ship_method#                    	
                    </cfif>                
                </td>
				<td>
              		<cfif session_base.language neq 'tr'>
                    	<cfquery name="GET_STAGE" dbtype="query">
                        	SELECT * FROM GET_FOR_STAGES WHERE UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ship_stage#">
                        </cfquery>
                    	<cfif get_stage.recordcount>
							#get_stage.item#
						<cfelse>
	                		#get_process_type.stage[listfind(main_process_list,ship_stage,',')]#                        
                        </cfif>
                    <cfelse>
                		#get_process_type.stage[listfind(main_process_list,ship_stage,',')]#
                	</cfif>
                </td>
				<td>#dateformat(out_date,'dd/mm/yyyy')#</td>
				<td>#dateformat(delivery_date,'dd/mm/yyyy')#</td>
					<cfquery name="GET_SHIP_RESULT_ROW" datasource="#DSN2#" maxrows="1">
						SELECT NOTE FROM SHIP_RESULT WHERE MAIN_SHIP_FIS_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#main_ship_fis_no#">
					</cfquery>
				<td><cfif get_ship_result_row.recordcount>#left(get_ship_result_row.note,30)#</cfif></td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr class="color-row">
			<td colspan="8"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
		</tr>
	</cfif>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_str="objects2.list_packetship">
	<cfif len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfif len(attributes.document_number)>
		<cfset url_str = "#url_str#&document_number=#attributes.document_number#">
	</cfif>
	<cfif len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfif len(attributes.ship_method)>
		<cfset url_str = "#url_str#&ship_method=#attributes.ship_method#">
	</cfif>
	<cfif len(attributes.form_submitted)>
		<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
	</cfif>
	<cfif len(attributes.start_date)>
		<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#">
	</cfif>
	<cfif len(attributes.finish_date)>
		<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,'dd/mm/yyyy')#">
	</cfif>
	<cfif isdefined("attributes.process_stage_type") and len(attributes.process_stage_type)>
		<cfset url_str = "#url_str#&process_stage_type=#attributes.process_stage_type#" >
    </cfif>
	<table border="0" cellpadding="0" cellspacing="0" align="center" style="width:98%; height:35px;">
		<tr>
			<td>
            	<cf_pages page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
					adres="#url_str#&form_submitted=1"> 
			</td>
			<!-- sil --><td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
		</tr>
	</table>
</cfif>
<br/>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
