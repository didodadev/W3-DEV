<cfset this_owner_type_id_ = listlast(attributes.add_info_pos,';')>
<cfset this_id_ = listfirst(attributes.add_info_pos,';')>
<cfif isdefined("this_owner_type_id_") and ((this_owner_type_id_ eq -1) or (this_owner_type_id_ eq -2) or (this_owner_type_id_ eq -3) or (this_owner_type_id_ eq -4))>
	<cfset tablo_adi = "INFO_PLUS">
	<cfset kolon_adi = "OWNER_ID">
	<cfset dsn_adi = dsn>
<cfelseif isdefined ("this_owner_type_id_") and (this_owner_type_id_ eq -5)>
	<cfset tablo_adi = "PRODUCT_INFO_PLUS">
	<cfset kolon_adi = "PRODUCT_ID">
	<cfset dsn_adi = dsn3>
<cfelseif isdefined ("this_owner_type_id_") and (this_owner_type_id_ eq -6)>
	<cfset tablo_adi = "PRODUCT_TREE_INFO_PLUS">
	<cfset kolon_adi = "STOCK_ID">
	<cfset dsn_adi = dsn3>
<cfelseif isdefined ("this_owner_type_id_") and ((this_owner_type_id_ eq -7) or (this_owner_type_id_ eq -12))><!--- Satis ve satinalma siparisleri --->
	<cfset tablo_adi = "ORDER_INFO_PLUS">
	<cfset kolon_adi = "ORDER_ID">
	<cfset dsn_adi = dsn3>
<cfelseif isdefined ("this_owner_type_id_") and ((this_owner_type_id_ eq -8))>
	<cfset tablo_adi = "INVOICE_INFO_PLUS">
	<cfset kolon_adi = "INVOICE_ID">
	<cfset dsn_adi = dsn2>
<cfelseif isdefined ("this_owner_type_id_") and ((this_owner_type_id_ eq -9))>
	<cfset tablo_adi = "OFFER_INFO_PLUS">
	<cfset kolon_adi = "OFFER_ID">
	<cfset dsn_adi = dsn3>
<cfelseif isdefined ("this_owner_type_id_") and ((this_owner_type_id_ eq -10))>
	<cfset tablo_adi = "PROJECT_INFO_PLUS">
	<cfset kolon_adi = "PROJECT_ID">
	<cfset dsn_adi = dsn>
<cfelseif isdefined("this_owner_type_id_") and ((this_owner_type_id_ eq -11))>
	<cfset tablo_adi = "SUBSCRIPTION_INFO_PLUS">
	<cfset kolon_adi = "SUBSCRIPTION_ID">
	<cfset dsn_adi = dsn3>
</cfif>

<cfset upload_folder = "#upload_folder#temp#dir_seperator#">
<cftry>
	<cffile action = "upload" 
			fileField = "uploaded_file" 
			destination = "#upload_folder#"
			nameConflict = "MakeUnique"  
			mode="777" charset="utf-8">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#" charset="utf-8">

	<cfset file_size = cffile.filesize>
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>

<cftry>
	<cffile action="read" file="#upload_folder##file_name#" variable="dosya" charset="utf-8">
	<cffile action="delete" file="#upload_folder##file_name#">
<cfcatch>
	<script type="text/javascript">
		alert("Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir.");
		history.back();
	</script>
	<cfabort>
</cfcatch>
</cftry>

<cfset upd_ = 1>

<cfscript>
ayirac = ';';
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	dosya = Replace(dosya,'#ayirac##ayirac#','#ayirac#_*_#ayirac#','all');
	dosya = Replace(dosya,'#ayirac##ayirac#','#ayirac#_*_#ayirac#','all');
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
	counter = 0;
	liste = "";
</cfscript>
<cfloop from="2" to="#line_count#" index="kkk">
	<cftry>
		<cfscript>
			error_flag = 0;
			counter = counter + 1;
			satir=dosya[kkk];
			if(right(satir,1) is '#ayirac#')
				satir=satir & '_*_';
			info_id_ = listgetat(satir,1,"#ayirac#");
			info_alan_1 = listgetat(satir,2,"#ayirac#");
			info_alan_2 = listgetat(satir,3,"#ayirac#");
			info_alan_3 = listgetat(satir,4,"#ayirac#");
			info_alan_4 = listgetat(satir,5,"#ayirac#");
			info_alan_5 = listgetat(satir,6,"#ayirac#");
			info_alan_6 = listgetat(satir,7,"#ayirac#");
			info_alan_7 = listgetat(satir,8,"#ayirac#");
			info_alan_8 = listgetat(satir,9,"#ayirac#");
			info_alan_9 = listgetat(satir,10,"#ayirac#");
			info_alan_10 = listgetat(satir,11,"#ayirac#");
			info_alan_11 = listgetat(satir,12,"#ayirac#");
			info_alan_12 = listgetat(satir,13,"#ayirac#");
			info_alan_13 = listgetat(satir,14,"#ayirac#");
			info_alan_14 = listgetat(satir,15,"#ayirac#");
			info_alan_15 = listgetat(satir,16,"#ayirac#");
			info_alan_16 = listgetat(satir,17,"#ayirac#");
			info_alan_17 = listgetat(satir,18,"#ayirac#");
			info_alan_18 = listgetat(satir,19,"#ayirac#");
			info_alan_19 = listgetat(satir,20,"#ayirac#");
			info_alan_20 = listgetat(satir,21,"#ayirac#");
		</cfscript>
		<cfcatch type="Any">
			<cfoutput>#kkk#. satırda okuma sırasında hata oldu.</cfoutput><br/>
		</cfcatch>
	</cftry>
	<cftry> 
		<cfquery name="control_" datasource="#dsn_adi#">
			SELECT 
				* 
			FROM 
				#tablo_adi# 
			WHERE 
				#kolon_adi# = #info_id_#
				<cfif (this_owner_type_id_ eq -1) or (this_owner_type_id_ eq -2) or (this_owner_type_id_ eq -3) or (this_owner_type_id_ eq -4) or (this_owner_type_id_ eq -10)>
					AND INFO_OWNER_TYPE = #this_owner_type_id_#
				<cfelseif this_owner_type_id_ eq -5>
					AND PRO_INFO_ID = #this_id_#
				</cfif>
		</cfquery>
		<cfif control_.recordcount>
			<cfset upd_ = 1>
		<cfelse>
			<cfset upd_ = 0>
		</cfif>
		
		<cfif upd_ eq 1>
			<cfquery name="UPD_INFO_PLUS" datasource="#dsn_adi#">
				UPDATE
					#tablo_adi#
				SET	
					<cfloop from="1" to="20" index="kk">
						<cfset deger_ = evaluate("info_alan_#kk#")>
						<cfif isdefined("attributes.is_update")>
							<cfif deger_ is not '_*_'>
								PROPERTY#kk# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#deger_#">,
							</cfif>
						 <cfelse>
							<cfif deger_ is not '_*_'>
								PROPERTY#kk# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#deger_#">,
							<cfelse>
								PROPERTY#kk# = NULL,
							</cfif>
						</cfif>
					</cfloop>
					<cfif isdefined ("this_owner_type_id_") and ((this_owner_type_id_ eq -1) or (this_owner_type_id_ eq -2) or (this_owner_type_id_ eq -3) or (this_owner_type_id_ eq -4) or (this_owner_type_id_ eq -10))>
						INFO_OWNER_TYPE = #this_owner_type_id_#,
					<cfelseif isdefined ("this_owner_type_id_") and ((this_owner_type_id_ eq -5) and len(this_id_))><!---  or (this_owner_type_id_ eq -6) --->
						PRO_INFO_ID = #this_id_#,
					</cfif>
					#kolon_adi# = #info_id_#
				WHERE
					<cfif isdefined ("this_owner_type_id_") and ((this_owner_type_id_ eq -1) or (this_owner_type_id_ eq -2) or (this_owner_type_id_ eq -3) or (this_owner_type_id_ eq -4) or (this_owner_type_id_ eq -10))>
						INFO_OWNER_TYPE = #this_owner_type_id_# AND
					<cfelseif isdefined ("this_owner_type_id_") and ((this_owner_type_id_ eq -5))>
						PRO_INFO_ID = #this_id_# AND
					</cfif>
					#kolon_adi# = #info_id_#
			</cfquery>
		<cfelse>
			<cfquery name="add_" datasource="#dsn_adi#">
				INSERT INTO 
					#tablo_adi#
				(
					<cfloop from="1" to="20" index="i">
						<cfset deger_ = evaluate("info_alan_#i#")>
						<cfif deger_ is not '_*_'>PROPERTY#i#,</cfif>
					</cfloop>
					<cfif (this_owner_type_id_ eq -1) or (this_owner_type_id_ eq -2) or (this_owner_type_id_ eq -3) or (this_owner_type_id_ eq -4) or (this_owner_type_id_ eq -10)>
						INFO_OWNER_TYPE,
					<cfelseif (this_owner_type_id_ eq -5)>
						PRO_INFO_ID,
					</cfif>
					#kolon_adi#
				)
				VALUES
				(
					<cfloop from="1" to="20" index="i">
						<cfset deger_ = evaluate("info_alan_#i#")>
						<cfif deger_ is not '_*_'><cfqueryparam cfsqltype="cf_sql_varchar" value="#deger_#">,</cfif>
					</cfloop>
					<cfif (this_owner_type_id_ eq -1) or (this_owner_type_id_ eq -2) or (this_owner_type_id_ eq -3) or (this_owner_type_id_ eq -4) or (this_owner_type_id_ eq -10)>
						#this_owner_type_id_#,
					<cfelseif (this_owner_type_id_ eq -5)>
						#this_id_#,
					</cfif>
					#info_id_#
				)
			</cfquery>
		</cfif>
		<cfcatch type="Any">
			<cfoutput>#kkk#. satırda yazma sırasında hata oldu.</cfoutput><br/>
		</cfcatch>
	</cftry>
</cfloop>
<script type="text/javascript">
	alert('İşleminiz Tamamlanmıştır!');
	window.location.href='<cfoutput>#request.self#?fuseaction=settings.import_add_info</cfoutput>';
</script>
