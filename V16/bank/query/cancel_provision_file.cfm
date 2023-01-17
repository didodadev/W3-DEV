<!---E.a Select ifadeleri düzenlendi 23.07.2012--->
<cfset CRLF = Chr(13)&Chr(10)>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="GET_IMPORT" datasource="#DSN2#">
			SELECT 
				TARGET_SYSTEM,
				FILE_CONTENT
			FROM 
				FILE_EXPORTS 
			WHERE 
				E_ID = #attributes.export_import_id# AND 
				IS_IPTAL IS NULL
		</cfquery>
		<cfif GET_IMPORT.recordcount>
			<cfif not len(GET_IMPORT.FILE_CONTENT)>
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='49050.Şifrenizi Kontrol Ediniz'>!");
						<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>wrk_opener_reload();window.close();</cfif>
					
				</script>
				<cfabort>
			</cfif>
            <cfif attributes.is_encrypt_file eq 1>
				<cfset file_content_result = Decrypt(GET_IMPORT.FILE_CONTENT,attributes.key_type,"CFMX_COMPAT","Hex")>
                <cfset kontrol_part = left(file_content_result,6)>
				<cfset dosya = ListToArray(file_content_result,CRLF)>
                <cfif not(IsNumeric(kontrol_part) or kontrol_part eq "HEADER" or left(kontrol_part,3) eq "H20" or left(kontrol_part,1) eq "I" or left(kontrol_part,1) eq "O" or left(kontrol_part,2) eq "HM")><!--- encrypt in doğru açılması kontrolu --->
                    <script type="text/javascript">
                        alert("<cf_get_lang dictionary_id='49050.Şifrenizi Kontrol Ediniz'>!");
							<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>wrk_opener_reload();window.close();</cfif>
                    </script>
                    <cfabort>
                </cfif>
            <cfelse>
				<cfset file_content_result = GET_IMPORT.FILE_CONTENT>
				<cfset dosya = ListToArray(file_content_result,CRLF)>
            </cfif>
			<cfscript>
				if (listfind("2,4,5,6,10",GET_IMPORT.TARGET_SYSTEM,','))//TPOS - TEB - İşbank - YKB
					ArrayDeleteAt(dosya,1);//header satırını silmek için
				else if(GET_IMPORT.TARGET_SYSTEM eq 3){//HSBC
					for(i = 1; i lte 3; i=i+1)
						ArrayDeleteAt(dosya,1);}//header satırını silmek için
				line_count = ArrayLen(dosya);
			</cfscript>
			<cfif GET_IMPORT.TARGET_SYSTEM eq 2><!--- HSBC --->
				<cfscript>
					satir = dosya[1];
					prov_row_id = oku(satir,Find(".",satir)+1,Find(" ",satir)-1);//prov satır idsi
				</cfscript>
				<cfquery name="GET_PERIOD_INFO" datasource="#dsn2#">
					SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
				</cfquery>
				<cfif GET_PERIOD_INFO.PERIOD_ID neq session.ep.period_id>
					<script type="text/javascript">
						alert("<cf_get_lang dictionary_id='49068.Lütfen Döneminizi Kontrol Ediniz'>");
							<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>wrk_opener_reload();window.close();</cfif>
					</script>
					<cfabort>
				</cfif>
				<cfloop from="1" to="#line_count-1#" index="i"><!--- trailer satırını almamak için --->
					<cfscript>
						satir = dosya[i];
						invoice_id = oku(satir,1,Find(".",satir)-1);//invoice idsi
					</cfscript>
					<cfquery name="UPDATE_PAY_PLAN_ROW" datasource="#dsn2#">
						UPDATE
							#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
						SET
							IS_COLLECTED_PROVISION = 0,
							UPDATE_DATE = #now()#,
							UPDATE_IP = '#cgi.remote_addr#',
							UPDATE_EMP = #session.ep.userid#
						WHERE
							INVOICE_ID = #invoice_id# AND
							PERIOD_ID = #session.ep.period_id#
					</cfquery>
				</cfloop>
			<cfelseif GET_IMPORT.TARGET_SYSTEM eq 1><!--- GARANTI text format--->
				<cfscript>
					satir = dosya[1];
					prov_row_id = oku(satir,451,30);//prov satır idsi
				</cfscript>
				<cfquery name="GET_PERIOD_INFO" datasource="#dsn2#">
					SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
				</cfquery>
				<cfif GET_PERIOD_INFO.PERIOD_ID neq session.ep.period_id>
					<script type="text/javascript">
						alert("<cf_get_lang dictionary_id='49068.Lütfen Döneminizi Kontrol Ediniz'>");
							<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>wrk_opener_reload();window.close();</cfif>
					</script>
					<cfabort>
				</cfif>
				<cfloop from="1" to="#line_count#" index="i">
					<cfscript>
						satir = dosya[i];
						invoice_id = oku(satir,481,30);
					</cfscript>
					<cfquery name="UPDATE_PAY_PLAN_ROW" datasource="#dsn2#">
						UPDATE
							#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
						SET
							IS_COLLECTED_PROVISION = 0,
							UPDATE_DATE = #now()#,
							UPDATE_IP = '#cgi.remote_addr#',
							UPDATE_EMP = #session.ep.userid#
						WHERE
							INVOICE_ID = #invoice_id# AND
							PERIOD_ID = #session.ep.period_id#
					</cfquery>
				</cfloop>
			<cfelseif GET_IMPORT.TARGET_SYSTEM eq 3><!--- GARANTI TPOS format--->
				<cfscript>
					satir = dosya[1];
					prov_row_id = oku(satir,90,10);//prov satır idsi
				</cfscript>
				<cfquery name="GET_PERIOD_INFO" datasource="#dsn2#">
					SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
				</cfquery>
				<cfif GET_PERIOD_INFO.PERIOD_ID neq session.ep.period_id>
					<script type="text/javascript">
						alert("<cf_get_lang dictionary_id='49068.Lütfen Döneminizi Kontrol Ediniz'>");
							<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>wrk_opener_reload();window.close();</cfif>
					</script>
					<cfabort>
				</cfif>
				<cfloop from="1" to="#line_count-2#" index="i">
					<cfscript>
						satir = dosya[i];
						invoice_id = oku(satir,100,10);
					</cfscript>
					<cfquery name="UPDATE_PAY_PLAN_ROW" datasource="#dsn2#">
						UPDATE
							#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
						SET
							IS_COLLECTED_PROVISION = 0,
							UPDATE_DATE = #now()#,
							UPDATE_IP = '#cgi.remote_addr#',
							UPDATE_EMP = #session.ep.userid#
						WHERE
							INVOICE_ID = #invoice_id# AND
							PERIOD_ID = #session.ep.period_id#
					</cfquery>
				</cfloop>
			<cfelseif GET_IMPORT.TARGET_SYSTEM eq 4><!--- TEB format--->
				<cfscript>
					satir = dosya[1];
					prov_row_id = oku(satir,42,20);//prov satır idsi
				</cfscript>
				<cfquery name="GET_PERIOD_INFO" datasource="#dsn2#">
					SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
				</cfquery>
				<cfif GET_PERIOD_INFO.PERIOD_ID neq session.ep.period_id>
					<script type="text/javascript">
						alert("<cf_get_lang dictionary_id='49068.Lütfen Döneminizi Kontrol Ediniz'>");
							<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>wrk_opener_reload();window.close();</cfif>
					</script>
					<cfabort>
				</cfif>
				<cfloop from="1" to="#line_count-1#" index="i">
					<cfscript>
						satir = dosya[i];
						invoice_id = oku(satir,62,255);
					</cfscript>
					<cfquery name="UPDATE_PAY_PLAN_ROW" datasource="#dsn2#">
						UPDATE
							#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
						SET
							IS_COLLECTED_PROVISION = 0,
							UPDATE_DATE = #now()#,
							UPDATE_IP = '#cgi.remote_addr#',
							UPDATE_EMP = #session.ep.userid#
						WHERE
							INVOICE_ID = #invoice_id# AND
							PERIOD_ID = #session.ep.period_id#
					</cfquery>
				</cfloop>
			<cfelseif GET_IMPORT.TARGET_SYSTEM eq 5><!--- İşBankası format--->
				<cfscript>
					satir = dosya[1];
					prov_row_id = ListGetAt(oku(satir,133,30),2,'.');//prov satır idsi
				</cfscript>
				<cfquery name="GET_PERIOD_INFO" datasource="#dsn2#">
					SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
				</cfquery>
				<cfif GET_PERIOD_INFO.PERIOD_ID neq session.ep.period_id>
					<script type="text/javascript">
						alert("<cf_get_lang dictionary_id='49068.Lütfen Döneminizi Kontrol Ediniz'>");
							<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>wrk_opener_reload();window.close();</cfif>
					</script>
					<cfabort>
				</cfif>
				<cfloop from="1" to="#line_count-1#" index="i">
					<cfscript>
						satir = dosya[i];
						invoice_id = ListGetAt(oku(satir,133,30),1,'.');//invoice_id
					</cfscript>
					<cfquery name="UPDATE_PAY_PLAN_ROW" datasource="#dsn2#">
						UPDATE
							#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
						SET
							IS_COLLECTED_PROVISION = 0,
							UPDATE_DATE = #now()#,
							UPDATE_IP = '#cgi.remote_addr#',
							UPDATE_EMP = #session.ep.userid#
						WHERE
							INVOICE_ID = #invoice_id# AND
							PERIOD_ID = #session.ep.period_id#
					</cfquery>
				</cfloop>
			<cfelseif GET_IMPORT.TARGET_SYSTEM eq 6><!--- YKB format--->
				<cfscript>
					satir = dosya[1];
					prov_row_id = ListGetAt(oku(satir,77,74),2,'.');//prov satır idsi
				</cfscript>
				<cfquery name="GET_PERIOD_INFO" datasource="#dsn2#">
					SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
				</cfquery>
				<cfif GET_PERIOD_INFO.PERIOD_ID neq session.ep.period_id>
					<script type="text/javascript">
						alert("<cf_get_lang dictionary_id='49068.Lütfen Döneminizi Kontrol Ediniz'>");
							<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>wrk_opener_reload();window.close();</cfif>
					</script>
					<cfabort>
				</cfif>
				<cfloop from="1" to="#line_count#" index="i">
					<cfscript>
						satir = dosya[i];
						invoice_id = ListGetAt(oku(satir,77,74),1,'.');//invoice_id
					</cfscript>
					<cfquery name="UPDATE_PAY_PLAN_ROW" datasource="#dsn2#">
						UPDATE
							#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
						SET
							IS_COLLECTED_PROVISION = 0,
							UPDATE_DATE = #now()#,
							UPDATE_IP = '#cgi.remote_addr#',
							UPDATE_EMP = #session.ep.userid#
						WHERE
							INVOICE_ID = #invoice_id# AND
							PERIOD_ID = #session.ep.period_id#
					</cfquery>
				</cfloop>
			<cfelseif GET_IMPORT.TARGET_SYSTEM eq 7><!--- Akbank format--->
				<cfscript>
					satir = dosya[1];
					prov_row_id = oku(satir,376,30);//prov satır idsi
				</cfscript>
				<cfquery name="GET_PERIOD_INFO" datasource="#dsn2#">
					SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
				</cfquery>
				<cfif GET_PERIOD_INFO.PERIOD_ID neq session.ep.period_id>
					<script type="text/javascript">
						alert("<cf_get_lang dictionary_id='49068.Lütfen Döneminizi Kontrol Ediniz'>");
							<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>wrk_opener_reload();window.close();</cfif>
					</script>
					<cfabort>
				</cfif>
				<cfloop from="1" to="#line_count#" index="i">
					<cfscript>
						satir = dosya[i];
						invoice_id = oku(satir,406,30);//invoice_id
					</cfscript>
					<cfquery name="UPDATE_PAY_PLAN_ROW" datasource="#dsn2#">
						UPDATE
							#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
						SET
							IS_COLLECTED_PROVISION = 0,
							UPDATE_DATE = #now()#,
							UPDATE_IP = '#cgi.remote_addr#',
							UPDATE_EMP = #session.ep.userid#
						WHERE
							INVOICE_ID = #invoice_id# AND
							PERIOD_ID = #session.ep.period_id#
					</cfquery>
				</cfloop>
			<cfelseif GET_IMPORT.TARGET_SYSTEM eq 10><!--- Banksoft format--->
				<cfscript>
					satir = dosya[1];
					prov_row_id = oku(satir,4,15);//prov satır idsi
				</cfscript>
				<cfquery name="GET_PERIOD_INFO" datasource="#dsn2#">
					SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
				</cfquery>
				<cfif GET_PERIOD_INFO.PERIOD_ID neq session.ep.period_id>
					<script type="text/javascript">
						alert("<cf_get_lang dictionary_id='49068.Lütfen Döneminizi Kontrol Ediniz'>");
							<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>wrk_opener_reload();window.close();</cfif>
					</script>
					<cfabort>
				</cfif>
				<cfloop from="1" to="#line_count-1#" index="i">
					<cfscript>
						satir = dosya[i];
						invoice_id = oku(satir,171,50);//invoice_id
					</cfscript>
					<cfquery name="UPDATE_PAY_PLAN_ROW" datasource="#dsn2#">
						UPDATE
							#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
						SET
							IS_COLLECTED_PROVISION = 0,
							UPDATE_DATE = #now()#,
							UPDATE_IP = '#cgi.remote_addr#',
							UPDATE_EMP = #session.ep.userid#
						WHERE
							INVOICE_ID = #invoice_id# AND
							PERIOD_ID = #session.ep.period_id#
					</cfquery>
				</cfloop>
			<cfelseif GET_IMPORT.TARGET_SYSTEM eq 8><!--- Denizbank format--->
				<cfscript>
					satir = dosya[1];
					prov_row_id = oku(satir,376,30);//prov satır idsi
				</cfscript>
				<cfquery name="GET_PERIOD_INFO" datasource="#dsn2#">
					SELECT PERIOD_ID FROM #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #prov_row_id#
				</cfquery>
				<cfif GET_PERIOD_INFO.PERIOD_ID neq session.ep.period_id>
					<script type="text/javascript">
						alert("<cf_get_lang dictionary_id='49068.Lütfen Döneminizi Kontrol Ediniz'>");
							<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>wrk_opener_reload();window.close();</cfif>
					</script>
					<cfabort>
				</cfif>
				<cfloop from="1" to="#line_count#" index="i">
					<cfscript>
						satir = dosya[i];
						invoice_id = oku(satir,406,30);//invoice_id
					</cfscript>
					<cfquery name="UPDATE_PAY_PLAN_ROW" datasource="#dsn2#">
						UPDATE
							#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
						SET
							IS_COLLECTED_PROVISION = 0,
							UPDATE_DATE = #now()#,
							UPDATE_IP = '#cgi.remote_addr#',
							UPDATE_EMP = #session.ep.userid#
						WHERE
							INVOICE_ID = #invoice_id# AND
							PERIOD_ID = #session.ep.period_id#
					</cfquery>
				</cfloop>
			</cfif>
			<cfquery name="DEL_CREDIT_CARD_PAY_ROWS" datasource="#dsn2#">
				UPDATE FILE_EXPORTS SET IS_IPTAL = 1 WHERE E_ID = #attributes.export_import_id#
			</cfquery>
			<script type="text/javascript">
				<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>wrk_opener_reload();window.close();</cfif>
			</script>
		<cfelse>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='49069.Bu Belge İçin İptal İşlemi Yapılmıştır'>!");
					<cfif  isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>wrk_opener_reload();window.close();</cfif>
			</script>
			<cfabort>
		</cfif>
	</cftransaction>
</cflock>
