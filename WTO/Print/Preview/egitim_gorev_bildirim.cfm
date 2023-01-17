<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">
<cfif isDefined("attributes.training_sec_id") and len(attributes.training_sec_id)>
	<cfquery name="get_class_ids" datasource="#dsn#">
		SELECT CLASS_ID FROM TRAINING_CLASS_SECTIONS WHERE TRAINING_SEC_ID = #attributes.training_sec_id#
	</cfquery>
	<cfif get_class_ids.recordcount>
		<cfset class_ids = valuelist(get_class_ids.CLASS_ID)>
	</cfif>
</cfif>
<cfquery name="get_class" datasource="#dsn#">
	SELECT
		*
	FROM
		TRAINING_CLASS
	WHERE
		CLASS_ID IS NOT NULL
	<cfif isDefined("attributes.action_id") and len(attributes.action_id)>
		AND CLASS_ID = #attributes.action_id#
	</cfif>
	<cfif isDefined("attributes.online") and len(attributes.online)>
		AND ONLINE = #attributes.ONLINE#
	</cfif>
	<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
		AND
		(CLASS_NAME LIKE '%#attributes.KEYWORD#%' OR CLASS_OBJECTIVE LIKE '%#attributes.KEYWORD#%')
	</cfif>
	<!---<cfif isdefined("attributes.TRAIN_ID")> AND TRAINING_ID = #attributes.TRAIN_ID# </cfif>--->
	<cfif isdefined("attributes.training_sec_id") and get_class_ids.recordcount>
	    AND	CLASS_ID IN (#class_ids#)
	</cfif> 	
	<cfif isDefined("attributes.date1") and len(attributes.date1)>
		<cf_date tarih='attributes.date1'>
		AND	START_DATE >= #attributes.date1#
	</cfif>
	<cfif isdefined("attributes.training_sec_id")>
	   AND TRAINING_SEC_ID = #attributes.training_sec_id#
	</cfif>
</cfquery>
<cfquery name="CHECK" datasource="#DSN#">
    SELECT 
      ASSET_FILE_NAME2,
      ASSET_FILE_NAME2_SERVER_ID,
    COMPANY_NAME
    FROM 
      OUR_COMPANY 
    WHERE 
      <cfif isdefined("attributes.our_company_id")>
        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
      <cfelse>
        <cfif isDefined("session.ep.company_id") and len(session.ep.company_id)>
          COMP_ID = #session.ep.company_id#
        <cfelseif isDefined("session.pp.company_id") and len(session.pp.company_id)>  
          COMP_ID = #session.pp.company_id#
        <cfelseif isDefined("session.ww.our_company_id")>
          COMP_ID = #session.ww.our_company_id#
        <cfelseif isDefined("session.cp.our_company_id")>
          COMP_ID = #session.cp.our_company_id#
        </cfif> 
      </cfif> 
  </cfquery>

<cfquery name="get_training_poscats_departments" datasource="#dsn#">
		SELECT 
			TRAIN_POSITION_CATS, 
			TRAIN_DEPARTMENTS
		FROM 
			TRAINING WHERE TRAIN_ID
		IN 
			(
				SELECT 
					TRAIN_ID
				FROM 
					TRAINING_CLASS_SECTIONS 
				WHERE 
					CLASS_ID = #attributes.action_id#
			)
</cfquery>
	
<cfset attributes.training_id = get_class.training_id>
<cfif len(get_class.start_date)>
	<cfset start_date = date_add('h', session.ep.time_zone, get_class.start_date)>
</cfif>
<cfif len(get_class.finish_date)>
	<cfset finish_date = date_add('h', session.ep.time_zone, get_class.finish_date)>
</cfif>
<table style="width:210mm">
	<tr>
		<td>
			<table width="100%">
				<tr class="row_border">
					<td class="print-head">
						<table style="width:100%;">
							<tr>
								<td class="print_title"><cf_get_lang dictionary_id='30644.SATIN ALMA TEKLİFLERİ'></td>
									<td style="text-align:right;">
										<cfif len(check.asset_file_name2)>
										<cfset attributes.type = 1>
											<cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5">
										</cfif>
									</td>
								</td>
							</tr> 
						</table>
					</td>
				</tr>
				<tr class="row_border" class="row_border">
					<td>
						<table style="width:150mm">
							<cfoutput>
								<tr>
									<td><b><cf_get_lang dictionary_id='31090.Eğitimin Adı'></b></td>
									<td> #get_class.class_name#</td>
								</tr>
								<tr>
									<td><b><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'> / <cf_get_lang dictionary_id='57491.Saat'></b></td>
									<td> 
									<cfif len(get_class.start_date)>
										#dateformat(start_date,dateformat_style)# #timeformat(start_date,timeformat_style)#
									</cfif>
									</td>
								</tr>
								<tr>
									<td><b><cf_get_lang dictionary_id='57700.Bitiş Tarihi'> / <cf_get_lang dictionary_id='57491.Saat'></b></td>
									<td>
									<cfif len(get_class.finish_date)>
										#dateformat(finish_date,dateformat_style)# #timeformat(finish_date,timeformat_style)#
									</cfif>
									</td>
								</tr>
								
								<tr>
									<td><b><cf_get_lang dictionary_id='41194.Telefon'></b></td>
										<td>#get_class.CLASS_PLACE_TEL#</td>
								</tr>
								<tr>
									<td><b><cf_get_lang dictionary_id='46180.Eğitim Yeri Sorumlusu'></b></td>
									<td> #get_class.CLASS_PLACE_MANAGER#</td>
								</tr>
								<tr>
									<td><b><cf_get_lang dictionary_id='46634.Ders İçeriği'></b></td>
									<td> #ParagraphFormat(get_class.class_objective)#</td>
								</tr>
								
									<tr>
										<td ><b><cf_get_lang dictionary_id='46178.Eğitim Yeri Adresi'></b> </td>
										<td>#get_class.CLASS_PLACE# -#get_class.CLASS_PLACE_ADDRESS#</td>
									</tr>
								
							</cfoutput>
						</table>	
					</td>
				</tr>
							
				<table style="width:210mm;height:35px;">
					<tr>
						<td><b><cf_get_lang dictionary_id='46408.Açıklamalar'></b></td>
					</tr>
					<tr>
						<td ><cf_get_lang dictionary_id='46372.Katılımcıların Eğitimden En Az 15 dk Öncesinde Eğitim Yerinde Bulunmaları Gerekmektedir Eğitimlerde Kıyafet Serbesttir'></td>
					</tr>
					<tr>
						<td>
						<cf_get_lang dictionary_id='46409.Yukarıda Belirtilen Bilgiler Doğrultusunda İlgili Tarih ve Saatlerde Eğitim Yerinde Bulunmanızı Rica Ederiz'>
						</td>
					</tr>
				</table>
				<table>
					<br>
						<tr class="fixed">
							<td style="font-size:9px!important;"><b>© Copyright</b> <cfoutput>#check.COMPANY_NAME#</cfoutput> dışında kullanılamaz, paylaşılamaz.</td>
						</tr>
					</br>
				</table>
			</table>
		</td>
	</tr>
</table>

