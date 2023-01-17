<cfscript>//bu blokta faction_list'de belirtilen LINK_FILE'daki dosya isimlerine göre hangisinin geçerli oluğunu bulucaz.
	dosyam = XmlParse(dosya);
	xml_dizi = dosyam.DATAPACKET.ROWDATA.XmlChildren;
	d_boyut = ArrayLen(xml_dizi);
	line_count = d_boyut;
</cfscript>
<cfloop from="1" to="#d_boyut#" index="i">
	<cfset kont=1>
	<cftry>
		<cfset pdks_no = dosyam.DATAPACKET.ROWDATA.ROW[i].XmlAttributes.PIN>
		<cfset tarih_ = dosyam.DATAPACKET.ROWDATA.ROW[i].XmlAttributes.CHECKTIME>
		<cfset tarih_ = replace(tarih_,' ','*_*','all')>
		<cfset tarih_1 = listgetat(tarih_,1,'*_*')>
		<cfset tarih_2 = listgetat(tarih_,2,'*_*')>
		
		<cfset gun = listgetat(tarih_1,1,'.')>
		<cfset ay = listgetat(tarih_1,2,'.')>
		<cfset yil = listgetat(tarih_1,3,'.')>
		<cfset saat = listgetat(tarih_2,1,':')>
		
		<cfset dakika = listgetat(tarih_2,2,':')>
		<cfset baslama_tarih_ = '#ay#/#gun#/#yil#'>
		<cfset baslama_tarih = baslama_tarih_>
		<cfset baslama_tarih = date_add('h',saat,baslama_tarih)>
		<cfset baslama_tarih = date_add('n', dakika, baslama_tarih)>
		<cfcatch type="Any">
			<cfoutput>#i#. Satır Okuma Hatalı!<br/></cfoutput>	
			<cfset kont=0>
		</cfcatch>  
	</cftry>	
	<cftry>
		<cfquery name="get_in_out" datasource="#dsn#" maxrows="1">
			SELECT EMPLOYEE_ID,IN_OUT_ID,BRANCH_ID FROM EMPLOYEES_IN_OUT WHERE PDKS_NUMBER = '#pdks_no#' ORDER BY FINISH_DATE DESC
		</cfquery>
		
		<cfif get_in_out.recordcount>
			<cfquery name="get_daily_in" datasource="#dsn#">
				SELECT ROW_ID,FILE_ID
				FROM 
					EMPLOYEE_DAILY_IN_OUT 
				WHERE 
					EMPLOYEE_ID = #get_in_out.employee_id# AND 
					FINISH_DATE IS NULL AND (
					START_DATE >= #createodbcdatetime(baslama_tarih_)# AND
					START_DATE < #DATEADD("d",1,baslama_tarih_)#)
					AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0
			</cfquery>
			<cfquery name="get_daily_out" datasource="#dsn#">
				SELECT ROW_ID,START_DATE,FINISH_DATE 
				FROM 
					EMPLOYEE_DAILY_IN_OUT 
				WHERE 
					EMPLOYEE_ID = #get_in_out.employee_id# AND 
					FINISH_DATE IS NOT NULL AND (DATEDIFF(n ,FINISH_DATE,#baslama_tarih# )<2)
					AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0
			</cfquery>
			<cfquery name="get_offtime" dbtype="query" maxrows="1">
				SELECT START_DATE FROM get_offtimes WHERE (START_DATE <= #createodbcdatetime(baslama_tarih_)# AND FINISH_DATE >= #createodbcdatetime(baslama_tarih_)#)
			</cfquery>
			<cfif get_offtime.recordcount eq 1>
				<cfset day_type_ = 2>
			<cfelseif dayofweek(createodbcdatetime(baslama_tarih_)) eq 1>
				<cfset day_type_ = 1>
			<cfelse>
				<cfset day_type_ = 0>
			</cfif>
				<cfif (get_daily_in.recordcount eq 0) and (get_daily_out.recordcount eq 0)>
					<cfquery name="add_row" datasource="#dsn#">
						INSERT INTO 
							EMPLOYEE_DAILY_IN_OUT
							(
								FILE_ID,
								DAY_TYPE,
								EMPLOYEE_ID,
								IN_OUT_ID,
								BRANCH_ID,
								START_DATE,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP
							)
						VALUES
							(
								#attributes.i_id#,
								#day_type_#,
								#get_in_out.employee_id#,
								#get_in_out.in_out_id#,
								#get_in_out.branch_id#,
								#baslama_tarih#,
								#now()#,
								#session.ep.userid#,
								'#cgi.REMOTE_ADDR#'
							)
					</cfquery>
				<cfelse>
					<cfif (get_daily_out.recordcount eq 0)>
						<cfquery name="upd_row" datasource="#dsn#">
							UPDATE
								EMPLOYEE_DAILY_IN_OUT
							SET					
								<cfif get_daily_in.file_id neq attributes.i_id><!--- giris farkli cikis farkli dosyadan okutulmus ise --->
									FILE2_ID = #attributes.i_id#,
								</cfif>
								FINISH_DATE = #baslama_tarih#
							WHERE 
								ROW_ID = #get_daily_in.row_id#	and DATEDIFF(n ,START_DATE,#baslama_tarih# )>2	
						</cfquery>					
					</cfif>	
		
				</cfif>
		</cfif>	
			<cfcatch type="Any">
			<cfoutput>#pdks_no# nolu personel <br/> #i#. Satır Yazma Hatalı!<br/></cfoutput>	
			<cfset kont=0>
		</cfcatch> 	
	</cftry>
</cfloop>
