<cf_get_lang_set module_name="correspondence"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="get_internaldemand_history" datasource="#DSN3#">
	SELECT * FROM INTERNALDEMAND_HISTORY WHERE INTERNAL_ID=#attributes.id# ORDER BY INTERNAL_HISTORY_ID 
</cfquery>
<cfquery name="GET_INTERNALDEMAND_ROWS" datasource="#DSN3#">
	SELECT
		IRH.I_HISTORY_ID,
		IRH.STOCK_ID,
		P.PRODUCT_NAME,
		S.PROPERTY,
		S.STOCK_CODE,
		IRH.PRODUCT_ID,
		IRH.PRODUCT_NAME2,
		IRH.QUANTITY,
		IRH.UNIT,
		IRH.PRICE,
		IRH.TAX,
		IRH.NETTOTAL,
		IRH.PRICE_OTHER,
		IRH.OTHER_MONEY_VALUE,
		IRH.OTHER_MONEY,
        IRH.ROW_PROJECT_ID
	FROM
		INTERNALDEMAND_ROW_HISTORY IRH,
		PRODUCT P,
		STOCKS S
	WHERE
		IRH.I_ID=#attributes.id# AND 
		IRH.PRODUCT_ID=P.PRODUCT_ID AND
		IRH.STOCK_ID=S.STOCK_ID
	ORDER BY 
		IRH.I_HISTORY_ID,
		IRH.I_ROW_ID
</cfquery>
<cfset int_list = listdeleteduplicates(ValueList(get_internaldemand_history.INTERNALDEMAND_STAGE,','))>
<cfset work_id_list =listdeleteduplicates(ValueList(get_internaldemand_history.WORK_ID,','))>
<cfif listlen(int_list,',')>
	<cfquery name="get_pro_stage" datasource="#DSN#">
		SELECT DISTINCT  PROCESS_ROW_ID, STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#int_list#)
	</cfquery>
  	<cfif get_pro_stage.recordcount>
		<cfscript>
			for(pind=1;pind lte get_pro_stage.recordcount; pind=pind+1)
				'opp_stage_#get_pro_stage.PROCESS_ROW_ID[pind]#' = get_pro_stage.STAGE[pind];
		</cfscript>
	</cfif>
</cfif>
<cfif listlen(work_id_list,',')>
<cfset work_id_list=listsort(work_id_list,"numeric","ASC",",")>
<cfquery name="get_work_info" datasource="#dsn#">
	SELECT WORK_ID, WORK_HEAD FROM PRO_WORKS WHERE WORK_ID IN (#work_id_list#) ORDER BY WORK_ID
</cfquery>
<cfset work_id_list = listsort(listdeleteduplicates(valuelist(get_work_info.WORK_ID,',')),'numeric','ASC',',')>
</cfif>
	<cfset sayi = 0>
	<cfset satir_sayi = 0>
<cfsavecontent variable="title_">
	<cfif isdefined('attributes.is_demand') and attributes.is_demand eq 1><cf_get_lang_main no ='37.Satınalma'><cf_get_lang_main no ='61.Tarihçe'><cfelse><cf_get_lang no ='8.Satınalma İç Talep Tarihçe'></cfif></td>
</cfsavecontent>
<style>
.history_head tr:first-child td{
	background-color:#67bbc9;
	color:white;
	font-weight:bold;
	border:none;
	}
.history_head td {
	text-align:center;
	}	

</style>

<cf_box title="#title_#" closable="0">
    <cfif get_internaldemand_history.recordcount>
        <cfoutput query="get_internaldemand_history">
         <cfsavecontent variable="header_txt"><cfif Len(UPDATE_DATE)>#dateformat(UPDATE_DATE,dateformat_style)# (#timeformat(UPDATE_DATE,timeformat_style)#)<cfelse>#dateformat(record_date,dateformat_style)# (#timeformat(record_date,timeformat_style)#)</cfif> -<cfif len(update_emp)> #get_emp_info(UPDATE_EMP,0,0)#<cfelse>#get_emp_info(record_emp,0,0)#</cfif></cfsavecontent>
         <cf_seperator id="history_#currentrow#" header="#header_txt#" is_closed="1">
            <div id="history_#currentrow#">
            <table class"ui-table-list">
                <tbody>
                    <tr>
                        <td class="txtbold" >No : #currentrow#</td>
                        <td class="txtbold"><cf_get_lang_main no ='68.Başlık'> : #get_internaldemand_history.subject#</td>
                        <td class="txtbold"><cf_get_lang_main no ='233.Teslim Tarihi'> : #dateformat(get_internaldemand_history.target_date,dateformat_style)#</td>
                        <td class="txtbold"><cf_get_lang no ='139.İş/Görev'> : <cfif len(get_internaldemand_history.work_id)>#get_work_info.work_head[listfind(work_id_list,work_id)]#</cfif></td>
                        <td class="txtbold" ><cf_get_lang_main no ='344.Süreç'> : <cfif isdefined('opp_stage_#INTERNALDEMAND_STAGE#')>#Evaluate('opp_stage_#INTERNALDEMAND_STAGE#')#</cfif></td>
                        <td class="txtbold"><cf_get_lang_main no ='479.Güncelleyen'> / <cf_get_lang_main no ='330.Tarih'> :  
                            <cfif Len(UPDATE_DATE)>
                                #get_emp_info(UPDATE_EMP,0,0)# / #dateformat(UPDATE_DATE,dateformat_style)# #timeFormat(dateadd('h',session.ep.time_zone,UPDATE_DATE),timeformat_style)#
                            <cfelse>
                                #get_emp_info(record_emp,0,0)# / #dateformat(record_date,dateformat_style)# #timeFormat(dateadd('h',session.ep.time_zone,record_date),timeformat_style)#
                            </cfif>
                        </td>
                    </tr>
                </tbody>
            </table>
            <table class="ui-table-list">
                <thead> 
                    <tr> 
                        <th><cf_get_lang_main no="75.No"></th>
                        <th><cf_get_lang_main no ='1096.Satır'><cf_get_lang_main no='75.No'></th>
                        <th><cf_get_lang_main no ='106.Stok Kod'></th>
                        <th><cf_get_lang_main no ='245.Ürün'></th>             
                        <th><cf_get_lang_main no ='223.Miktar'></th>
                        <th><cf_get_lang_main no ='217.Açıklama'></th>
                        <th><cf_get_lang_main no ='4.Proje'> </th>
                        <th><cf_get_lang_main no ='672.Fiyat'></th>
                        <th><cf_get_lang no ='15.Döviz Fiyat'></th>
                        <th><cf_get_lang_main no ='265.Döviz'></th>
                        <th><cf_get_lang_main no ='227.KDV'></th>
                        <th><cf_get_lang_main no ='261.Tutar'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif GET_INTERNALDEMAND_ROWS.recordcount>

                        <cfset INTERNAL_HISTORY_ID_ = INTERNAL_HISTORY_ID>
                        <cfloop query="GET_INTERNALDEMAND_ROWS" >
                        <cfset sayi = sayi + 1>
                        <cfif GET_INTERNALDEMAND_ROWS.I_HISTORY_ID eq INTERNAL_HISTORY_ID_>
                        <cfset satir_sayi = satir_sayi + 1>
                        <tr>
                        <td align="center">#sayi#</td>
                        <td align="center">#satir_sayi#</td>
                        <td>#STOCK_CODE#</td>
                        <td>#PRODUCT_NAME#</td>
                        <td>#QUANTITY# #UNIT#</td>
                        <td>#PRODUCT_NAME2#</td>
                        <td ><cfif len (GET_INTERNALDEMAND_ROWS.ROW_PROJECT_ID)>#get_project_name(GET_INTERNALDEMAND_ROWS.ROW_PROJECT_ID)#</cfif></td>
                        <td style="text-align:right;">#TLFormat(PRICE)#</td>
                        <td style="text-align:right;">#TLFormat(PRICE_OTHER)#</td>
                        <td>#OTHER_MONEY#</td>
                        <td style="text-align:right;">#TAX#</td>
                        <td style="text-align:right;">#TLFormat(NETTOTAL)#</td>
                    </tr>
                    </cfif>
                        </cfloop>
                    </cfif>
                </tbody>
            </table>
            </div>
        </cfoutput>
    </cfif>
</cf_box>
<!--- <cf_popup_box title="#title_#">
<cf_medium_list>
    <tbody>
        <cfif get_internaldemand_history.recordcount>
          <cfoutput query="get_internaldemand_history">
           <cfsavecontent variable="header_txt"><cfif Len(UPDATE_DATE)>#dateformat(UPDATE_DATE,dateformat_style)# (#timeformat(UPDATE_DATE,timeformat_style)#)<cfelse>#dateformat(record_date,dateformat_style)# (#timeformat(record_date,timeformat_style)#)</cfif> -<cfif len(update_emp)> #get_emp_info(UPDATE_EMP,0,0)#<cfelse>#get_emp_info(record_emp,0,0)#</cfif></cfsavecontent>
           <cf_seperator id="history_#currentrow#" header="#header_txt#" is_closed="1">
            <table id="history_#currentrow#" style="display:none" style="width:100%;" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td>
                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                            <tr>
                                <td class="txtbold" >No</td>
                                <td >#currentrow#</td>
                                <td class="txtbold"><cf_get_lang_main no ='68.Başlık'></td>
                                <td style="">#get_internaldemand_history.subject#</td>
                                <td class="txtbold"><cf_get_lang_main no ='233.Teslim Tarihi'></td>
                                <td>#dateformat(get_internaldemand_history.target_date,dateformat_style)#</td>
                				<!---<td class="txtbold"><cf_get_lang_main no ='4.Proje'> </td>
                                <td ><cfif len (get_internaldemand_history.project_id)>#get_project_name(get_internaldemand_history.project_id)#</cfif></td>--->
                            </tr>
                            <tr>  
                            	<td class="txtbold"><cf_get_lang no ='139.İş/Görev'></td>
                                <td style=""><cfif len(get_internaldemand_history.work_id)>#get_work_info.work_head[listfind(work_id_list,work_id)]#</cfif></td>
                                <td class="txtbold" ><cf_get_lang_main no ='344.Süreç'></td>
                                <td style=""><cfif isdefined('opp_stage_#INTERNALDEMAND_STAGE#')>#Evaluate('opp_stage_#INTERNALDEMAND_STAGE#')#</cfif></td>  
                                <td class="txtbold"><cf_get_lang_main no ='479.Güncelleyen'> / <cf_get_lang_main no ='330.Tarih'></td>
                                <td style="">
									<cfif Len(UPDATE_DATE)>
                                        #get_emp_info(UPDATE_EMP,0,0)# / #dateformat(UPDATE_DATE,dateformat_style)# #timeFormat(dateadd('h',session.ep.time_zone,UPDATE_DATE),timeformat_style)#
                                    <cfelse>
                                        #get_emp_info(record_emp,0,0)# / #dateformat(record_date,dateformat_style)# #timeFormat(dateadd('h',session.ep.time_zone,record_date),timeformat_style)#
                                    </cfif>
                                </td> 
                            </tr>
                        </table>
                    </td>    
                </tr>
                <tr>
                	<td> 
                    <table cellpadding="0" cellspacing="0" border="0" width="100%"  class="history_head">
                        	<cfif GET_INTERNALDEMAND_ROWS.recordcount>
                                <tr height="20"> 
                                    <td width="40" style="padding:1mm;"><cf_get_lang_main no="75.No"></td>
                                    <td width="140"><cf_get_lang_main no ='1096.Satır'><cf_get_lang_main no='75.No'></td>
                                    <td width="60" ><cf_get_lang_main no ='106.Stok Kod'></td>
                                    <td width="159"><cf_get_lang_main no ='245.Ürün'></td>
                                        				  
                                    <td  width="40"><cf_get_lang_main no ='223.Miktar'></td>
                                    <td  width="100" ><cf_get_lang_main no ='217.Açıklama'></td>
                                    <td class="txtbold"><cf_get_lang_main no ='4.Proje'> </td>
                                    <td width="100"><cf_get_lang_main no ='672.Fiyat'></td>
                                    <td width="100"><cf_get_lang no ='15.Döviz Fiyat'></td>
                                    <td width="100"><cf_get_lang_main no ='265.Döviz'></td>
                                    <td><cf_get_lang_main no ='227.KDV'></td>
                                    <td><cf_get_lang_main no ='261.Tutar'></td>
                                 </tr>
                                 <cfset INTERNAL_HISTORY_ID_ = INTERNAL_HISTORY_ID>
                                <cfloop query="GET_INTERNALDEMAND_ROWS" >
                                 <cfset sayi = sayi + 1>
                                 <cfif GET_INTERNALDEMAND_ROWS.I_HISTORY_ID eq INTERNAL_HISTORY_ID_>
								<cfset satir_sayi = satir_sayi + 1>
                        		<tr>
							<td align="center">#sayi#</td>
							<td align="center">#satir_sayi#</td>
							<td>#STOCK_CODE#</td>
							<td>#PRODUCT_NAME#</td>
							<td>#QUANTITY# #UNIT#</td>
							<td>#PRODUCT_NAME2#</td>
                            <td ><cfif len (GET_INTERNALDEMAND_ROWS.ROW_PROJECT_ID)>#get_project_name(GET_INTERNALDEMAND_ROWS.ROW_PROJECT_ID)#</cfif></td>
							<td >#TLFormat(PRICE)#</td>
							<td >#TLFormat(PRICE_OTHER)#</td>
							<td >#OTHER_MONEY#</td>
							<td >#TAX#</td>
							<td style="text-align:right;">#TLFormat(NETTOTAL)#</td>
						</tr>
                        </cfif>
                                </cfloop>
                            </cfif>
                    </table>	
                    </td>
                </tr> 
                <cfset satir_sayi = 0>
          </cfoutput>
          <cfelse>
          <tr>
            <td colspan="13"><cf_get_lang dictionary_id="57484.Kayıt Yok">!</td> 
          </tr>
        </cfif>
        </table>
	</tbody>
</cf_medium_list>
</cf_popup_box> --->
