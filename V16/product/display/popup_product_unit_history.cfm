<!--- Birimler Tarihce --->
<cfquery name="unit_carpan" datasource="#DSN1#">
	SELECT 
    	MAIN_UNIT,
        MULTIPLIER,
        UPDATE_EMP,
        UPDATE_DATE,
        RECORD_EMP,
        RECORD_DATE,
        (SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME FROM #DSN_ALIAS#.EMPLOYEES E WHERE E.EMPLOYEE_ID=PUH.RECORD_EMP) AS RECORD_NAME,
        (SELECT EMPLOYEE_NAME +' '+EMPLOYEE_SURNAME FROM #DSN_ALIAS#.EMPLOYEES E WHERE  E.EMPLOYEE_ID=PUH.UPDATE_EMP) AS UPDATE_NAME
   FROM 
   		PRODUCT_UNIT_HISTORY PUH
   WHERE 
   		PUH.PRODUCT_UNIT_ID=#attributes.product_unit_id# 
   ORDER BY 
   		UPDATE_DATE 
   DESC
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='37031.Birimler'> <cf_get_lang dictionary_id='57473.Tarihçe'></cfsavecontent>
<cf_box title="#message#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfif unit_carpan.recordcount neq 0>	
		<cf_grid_list>
			<thead>
				<tr>
					<th width="50"><cf_get_lang dictionary_id='37190.Birim Adı'></th>
					<th><cf_get_lang dictionary_id='37612.Birim Çarpanı'></th>
					<th><cf_get_lang dictionary_id='57891.Güncelleyen'></th>
					<th><cf_get_lang dictionary_id='57703.Güncelleme'></th>
				</tr>
			</thead>
			<tbody>
				<cfoutput query="unit_carpan">
					<tr>
						<td>#main_unit#</td>
						<td>#multiplier#</td>
						<td><cfif len(update_name)>#update_name#<cfelse>#record_name#</cfif></td>
						<td>
						<cfif len(update_date)>#DateFormat(update_date,dateformat_style)# #TimeFormat(DateAdd('h',session.ep.time_zone,update_date),timeformat_style)#
						<cfelseif len(record_date)>#DateFormat(record_date,dateformat_style)# #TimeFormat(DateAdd('h',session.ep.time_zone,record_date),timeformat_style)#</cfif>
						</td>
					</tr>
				</cfoutput>
			</tbody>
        </cf_grid_list>
        <cfelse>
			<table>
				<tr>
					<td><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
				</tr>
			</table>
        </cfif>  
</cf_box>
