<cf_date tarih='attributes.transfer_date'>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfset login_act = createObject("component", "V16.assetcare.cfc.assetp_care_calender")>
		<cfset login_act.dsn = dsn />
        <cfset UPD_SOLD = login_act.UPD_SELL_BUY_FNC( 
								position_name : '#iif(isdefined("attributes.position_name") and len(attributes.position_name),"attributes.position_name",DE(""))#',    
                                position_code : '#iif(isdefined("attributes.position_code") and len(attributes.position_code),"attributes.position_code",DE(""))#', 
                               	tel_num1 :  '#iif(isdefined("attributes.tel_num1") and len(attributes.tel_num1),"attributes.tel_num1",DE(""))#',
                                tel_num2 : '#iif(isdefined("attributes.tel_num2") and len(attributes.tel_num2),"attributes.tel_num2",DE(""))#',
                                gsm_num1 : '#iif(isdefined("attributes.gsm_num1") and len(attributes.gsm_num1),"attributes.gsm_num1",DE(""))#',
                                adress_buyer : '#iif(isdefined("attributes.adress_buyer") and len(attributes.adress_buyer),"attributes.adress_buyer",DE(""))#',
								gsm_num2 : '#iif(isdefined("attributes.gsm_num2") and len(attributes.gsm_num2),"attributes.gsm_num2",DE(""))#', 
                                tax_num : '#iif(isdefined("attributes.tax_num") and len(attributes.tax_num),"attributes.tax_num",DE(""))#',
                                detail : '#iif(isdefined("attributes.detail") and len(attributes.detail),"attributes.detail",DE(""))#',
								transfer_date : '#iif(isdefined("attributes.transfer_date") and len(attributes.transfer_date),"attributes.transfer_date",DE(""))#',
								is_paid : '#iif(isdefined("attributes.is_paid") and len(attributes.is_paid),"attributes.is_paid",DE(""))#',
								is_transfered : '#iif(isdefined("attributes.is_transfered") and len(attributes.is_transfered),"attributes.is_transfered",DE(""))#',
								sale_currency : '#iif(isdefined("attributes.sale_currency") and len(attributes.sale_currency),"attributes.sale_currency",DE(""))#',
                                driving_licence : '#iif(isdefined("attributes.driving_licence") and len(attributes.driving_licence),"attributes.driving_licence",DE(""))#',
								sold_id : '#iif(isdefined("attributes.sold_id") and len(attributes.sold_id),"attributes.sold_id",DE(""))#',
								sale_currency_money : '#iif(isdefined("attributes.sale_currency_money") and len(attributes.sale_currency_money),"attributes.sale_currency_money",DE(""))#'
								)>
		<cfif isDefined("attributes.is_transfered")>
			<!--- arac pasif ve satis kaydi --->
			<cfquery name="GET_ASSET" datasource="#DSN#">
				SELECT ASSETP_ID,ASSETP,PROPERTY,DEPARTMENT_ID,DEPARTMENT_ID2,POSITION_CODE,STATUS FROM ASSET_P WHERE ASSETP_ID = #attributes.assetp_id#				
			</cfquery>
			<!--- tarihce kaydi --->
			<cfquery name="ADD_HISTORY" datasource="#DSN#">
				INSERT INTO
					ASSET_P_HISTORY
				(
					ASSETP_ID,
					ASSETP,
					PROPERTY,
					DEPARTMENT_ID,
					DEPARTMENT_ID2,
					POSITION_CODE,
					STATUS,
					IS_SALES,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
				VALUES
				(
					#get_asset.assetp_id#,
					'#get_asset.assetp#',
					#get_asset.property#,
					#get_asset.department_id#,
					<cfif len(get_asset.department_id2)>#get_asset.department_id2#<cfelseif len(get_asset.department_id)>#get_asset.department_id#<cfelse>NULL</cfif>,
					#get_asset.position_code#,
					0,
					1,
					#now()#,
					#session.ep.userid#,
					'#cgi.remote_addr#'
				)			
			</cfquery>
			<!--- arac guncelleme --->
			<cfquery name="UPD_ASSET_STATUS" datasource="#DSN#">
				UPDATE ASSET_P SET STATUS = 0, IS_SALES = 1, EXIT_DATE = #attributes.transfer_date#, ASSETP_STATUS = #attributes.assetp_status#, UPDATE_DATE = #now()#, UPDATE_EMP = #session.ep.userid#, UPDATE_IP = '#cgi.remote_addr#' WHERE ASSETP_ID = #attributes.assetp_id#
			</cfquery>
			<!--- Talebe satis kaydi Arac talep surecinden geliyorsa--->
			<cfif (isDefined("attributes.request_id")) and (attributes.request_id neq "")>
			<cfquery name="UPD_REQUEST_STATUS" datasource="#DSN#">
				UPDATE ASSET_P_REQUEST_ROWS SET IS_SALES = 1 WHERE REQUEST_ROW_ID = #attributes.request_row_id#
			</cfquery>
			</cfif>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	self.close();
</script>
