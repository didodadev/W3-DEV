<!---- SETUP_FILE_FORMAT tablosu Dosya Formatlari ---->
<cfquery name="GET_SETUP_FILE_FORMAT" datasource="#DSN#">
	SELECT FORMAT_ID FROM SETUP_FILE_FORMAT
</cfquery>	
<cfif not get_setup_file_format.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#file_format.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.SETUP_FILE_FORMAT.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_SETUP_FILE_FORMAT" datasource="#DSN#">
			INSERT INTO
				SETUP_FILE_FORMAT
			(
				FORMAT_ID,
				FORMAT_SYMBOL,
				FORMAT_DESCRIPTION,
				ICON_NAME,
				ICON_NAME_SERVER_ID
			)
			VALUES
			(
				  #dosyam.SETUP_FILE_FORMAT.SETUPFILEFORMAT[i].FORMAT_ID.XmlText#,
				#sql_unicode()#'#dosyam.SETUP_FILE_FORMAT.SETUPFILEFORMAT[i].FORMAT_SYMBOL.XmlText#',					 
				#sql_unicode()#'#dosyam.SETUP_FILE_FORMAT.SETUPFILEFORMAT[i].FORMAT_DESCRIPTION.XmlText#',
				#sql_unicode()#'#dosyam.SETUP_FILE_FORMAT.SETUPFILEFORMAT[i].ICON_NAME.XmlText#',
				1				 
			)
		</cfquery>
	</cfloop>
</cfif>

<!--- Fuseaction Ekleme --->

<!--- Daha sonra bakilacak
<cfquery name="GET_FUSEACTION" datasource="#DSN#">
	SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS	
</cfquery>
<cfif not get_fuseaction.recordcount>
	<cfset error = 0>
	<cfset record_count = 0>
	
	<cftry>
		<cffile action="read" file="#index_folder#CustomTags#dir_seperator#xml#dir_seperator#wrk_switchs.csv" variable="dosya" charset="utf-8">
	<cfcatch>
		<script type="text/javascript">
			alert("Dosya Okunamadı ! Karakter Seti Yanlış Seçilmiş Olabilir.");
			history.back();
		</script>
		<cfabort>
	</cfcatch>
	</cftry>
	
	<cflock name="#createUUID()#" timeout="500">
        <cftransaction>
            <cfscript>
                ayrac=';';
                CRLF = Chr(13) & Chr(10);// satır atlama karakteri
                dosya = Replace(dosya,'#ayrac##ayrac#',' #ayrac# #ayrac# ','all');
                dosya = Replace(dosya,'#ayrac##ayrac#',' #ayrac# #ayrac# ','all');
                dosya = Replace(dosya,'#ayrac#',' #ayrac# ','all');
                dosya = ListToArray(dosya,CRLF);
                line_count = ArrayLen(dosya);
                counter = 0;
                liste = "";
                add_wrk_objects = ArrayNew(1);
            </cfscript>
            <cfset my_is_purchase = 1>
            <cfset my_is_sale = 0>
            <cfset my_in_out = 1>
            <cfset process_no_ = "#createUUID()#">	
            <cfset islem_date_ = now()>
            
            <cfset column_list = trim(listgetat(dosya[1]&' ;',1,ayrac))>
            
            <cfloop from="2" to="#line_count#" index="i">
                <cftry>
                    <cfscript>
                        column = 1;
                        error_flag = 0;
                        counter = counter + 1;
                        satir=dosya[i]&'  ;';
                        
                        insert_list_ = Listgetat(satir,column,ayrac);
                        insert_list_ = trim(insert_list_);
                        column = column + 1;
                        
                        sonuc = add_wbo_object_switch
                        (
                            ROW_BLOCK : 500,
                            INSERT_LIST : insert_list_
                        );
                        
                    </cfscript>
                    <cfset record_count++>
                <cfcatch type="Any">
                    <cfoutput>#i#. satırda okuma sırasında hata oldu. <BR />
                            INSERT INTO WRK_OBJECTS (#column_list#) VALUES (#insert_list_#)
                     <cfabort></cfoutput><br />
                    <cfset record_count-->
                </cfcatch>
                </cftry> 
            </cfloop>
            
            <cfscript>
                sonuc_add_row_2 = add_block_row(db_source:'#DSN#',row_array:add_wrk_objects);
                add_wrk_objects = ArrayNew(1);
            </cfscript>
        </cftransaction>
    </cflock>

	<cffunction name="add_wbo_object_switch" output="false" returntype="boolean">
		<cfargument name="DB_SOURCE" type="string" default="#DSN#">
		<cfargument name="ROW_BLOCK" type="numeric" default="500">	
   		<cfargument name="INSERT_LIST" type="string" required="yes">
		<cfscript>
			add_wrk_objects[Arraylen(add_wrk_objects)+1] = "INSERT INTO WRK_OBJECTS (#column_list#) VALUES (#insert_list#)";
			if((ArrayLen(add_wrk_objects) gt 1) and (ArrayLen(add_wrk_objects) mod arguments.row_block eq 0))
			{
				sonuc_add_row_2 = add_block_row(db_source:arguments.db_source,row_array:add_wrk_objects);
				add_wrk_objects = ArrayNew(1);
			}
		</cfscript>
		<cfreturn true>
	</cffunction>
	
	<cfset null_list = 'UPDATE_IP;UPDATE_EMP;UPDATE_DATE;FRIENDLY_URL'>
    <cfquery name="UPD_WRK_OBJECTS" datasource="#DSN#">
        UPDATE 
            WRK_OBJECTS 
        SET
            <cfloop from="1" to="#listlen(null_list,';')#" index="kk">
                #listgetat(null_list,kk,';')# = NULL,
            </cfloop>
            RECORD_DATE = #NOW()#,
            RECORD_IP = '127.0.0.1',
            RECORD_EMP = 1,
            OBJECTS_COUNT=0
    </cfquery>

	<cfquery name="FUSEACTION_COUNT" datasource="#DSN#">
		SELECT COUNT(WRK_OBJECTS_ID) COUNT FROM WRK_OBJECTS 
	</cfquery>
	<pre><cfoutput>
	<b>#error# </b>adet hata <br />meydana gelmiştir<br />
	#fuseaction_count.count# adet switch WRK_OBJECTS tablosuna kaydedilmiştir</cfoutput></pre>
</cfif>			
<!--- //Fuseaction ekleme bitti --->
 --->


<!--- SETUP_SECTOR_CATS tablosu Sektor Kategorileri--->
<cfquery name="GET_SECTOR_CAT" datasource="#DSN#">
	SELECT SECTOR_CAT_ID FROM SETUP_SECTOR_CATS 
</cfquery>	
<cfif not get_sector_cat.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#sector_cat.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.MAIN.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_SECTOR_CAT" datasource="#DSN#">
			INSERT INTO
				SETUP_SECTOR_CATS
			(
				SECTOR_CAT
			)
			VALUES
			(
				#sql_unicode()#'#dosyam.MAIN.SECTORCAT[i].SECTOR_CAT.XmlText#'
			)
		</cfquery>
	</cfloop>
</cfif>

<!--- PRO_WORK_CAT tablosu Is Kategorisi  --->
<cfquery name="GET_WORK_CAT" datasource="#DSN#">
	SELECT WORK_CAT_ID FROM PRO_WORK_CAT 
</cfquery>	

<cfif not get_work_cat.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#pro_work_cat.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.PRO_WORK_CAT.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_WORK_CAT" datasource="#DSN#">
			INSERT INTO
				PRO_WORK_CAT
			(
				WORK_CAT_ID,
				WORK_CAT
			)
			VALUES
			(
				#dosyam.PRO_WORK_CAT.WORKCAT[i].WORK_CAT_ID.XmlText#,
				#sql_unicode()#'#dosyam.PRO_WORK_CAT.WORKCAT[i].WORK_CAT.XmlText#'
			)
		</cfquery>
	</cfloop>
</cfif>

<!--- SETUP_CREDITCARD tablosu Odeme Karti Tipleri --->
<cfquery name="GET_SETUP_CREDITCARD" datasource="#DSN#">
	SELECT CARDCAT_ID FROM SETUP_CREDITCARD 
</cfquery>	

<cfif not get_setup_creditcard.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#credit_card.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.SETUP_CREDITCARD.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_CREDITCARD" datasource="#DSN#">
			INSERT INTO
				SETUP_CREDITCARD
			(
				CARDCAT
			)
			VALUES
			(
				#sql_unicode()#'#dosyam.SETUP_CREDITCARD.CARD_CAT[i].CARDCAT.XmlText#'
			)
		</cfquery>
	</cfloop>
</cfif>

<!--- SETUP_DRIVERLICENCE tablosu Surucu Belge Kategorileri  --->
<cfquery name="GET_SETUP_DRIVERLICENCE" datasource="#DSN#">
	SELECT LICENCECAT_ID FROM SETUP_DRIVERLICENCE 
</cfquery>	
<cfif not get_setup_driverlicence.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#driver_licence.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.SETUP_DRIVERLICENCE.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_DRIVERLICENCE" datasource="#DSN#">
			INSERT INTO
				SETUP_DRIVERLICENCE
			(
				LICENCECAT
			)
			VALUES
			(
				#sql_unicode()#'#dosyam.SETUP_DRIVERLICENCE.SETUPDRIVERLICENCE[i].LICENCECAT.XmlText#'
			)
		</cfquery>
	</cfloop>
</cfif>

<!---SETUP_OFFTIME tablosu IK Izın Kategorileri  --->
<cfquery name="GET_OFFTIME" datasource="#DSN#">
	SELECT IS_PAID FROM SETUP_OFFTIME
</cfquery>	

<cfif not get_offtime.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#setup_offtime.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.SETUP_OFFTIME.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_OFFTIME" datasource="#DSN#">
			INSERT INTO
				SETUP_OFFTIME
			(
				OFFTIMECAT_ID,
				OFFTIMECAT,
				IS_PAID,
                EBILDIRGE_TYPE_ID,
                SIRKET_GUN,
                IS_YEARLY,
                IS_KIDEM
			)
			VALUES
			(
                #dosyam.SETUP_OFFTIME.OFFTIME[i].OFFTIMECAT_ID.XmlText#,
                #sql_unicode()#'#dosyam.SETUP_OFFTIME.OFFTIME[i].OFFTIMECAT.XmlText#',
                #dosyam.SETUP_OFFTIME.OFFTIME[i].IS_PAID.XmlText#,
                #dosyam.SETUP_OFFTIME.OFFTIME[i].EBILDIRGE_TYPE_ID.XmlText#,
                #dosyam.SETUP_OFFTIME.OFFTIME[i].SIRKET_GUN.XmlText#,
                #dosyam.SETUP_OFFTIME.OFFTIME[i].IS_YEARLY.XmlText#,
                #dosyam.SETUP_OFFTIME.OFFTIME[i].IS_KIDEM.XmlText#                
			)
		</cfquery>
	</cfloop>
</cfif>

<!--- SETUP_WARNINGS tablosu Uyarı Onay Kategorisi --->
<cfquery name="CHECK" datasource="#DSN#">
	SELECT SETUP_WARNING_ID FROM SETUP_WARNINGS
</cfquery>
<cfif not check.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#setup_warning.xml" variable="xmldosyam" charset = "UTF-8">
	<cfset dosyam = XmlParse(xmldosyam)>
	<cfset xml_dizi = dosyam.setup_warning_all.XmlChildren>
	<cfset d_boyut = ArrayLen(xml_dizi)>
	<cfloop index="i" from = "1" to = "#d_boyut#">
		<cfquery name="ADD_SETUP_WARNING" datasource="#DSN#">
			INSERT INTO
				SETUP_WARNINGS
			(
				SETUP_WARNING
			)
			VALUES
			(
				 #sql_unicode()#'#dosyam.setup_warning_all.setup_warning_detail[i].setup_warning.XmlText#'
			)
		</cfquery>
	</cfloop>
</cfif>

<!--- SETUP_PRINT_FILES_CATS tablosu Sistem Ici Yazıcı Belgeleri --->
<cfquery name="GET_SETUP_PRINT_FILES" datasource="#DSN#">
	SELECT PRINT_CAT_ID FROM SETUP_PRINT_FILES_CATS
</cfquery>
<cfif not get_setup_print_files.recordcount>
	<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#setup_print_type.xml" variable="xmldosyam" charset="utf-8">
	<cfset dosyam=xmlparse(xmldosyam)>
	<cfset xml_dizi = dosyam.workcube_print_types.XmlChildren>
	<cfset d_boyut=arraylen(xml_dizi)>
	<cfloop index="i" from="1" to= "#d_boyut#">
		<cfquery name="add_setup_print_files_cats" datasource="#DSN#">
			INSERT INTO 
				SETUP_PRINT_FILES_CATS
			(
				PRINT_MODULE_ID,
				PRINT_NAME,
				PRINT_NAME_ENG,
				PRINT_TYPE,
				PRINT_MODULE_NAME,
				PRINT_DICTIONARY_ID
			)
			VALUES
			(
				#dosyam.workcube_print_types.print[i].print_module_id.xmltext#,
				#sql_unicode()#'#dosyam.workcube_print_types.print[i].print_name.xmltext#',
				#sql_unicode()#'#dosyam.workcube_print_types.print[i].print_name_eng.xmltext#',
				#dosyam.workcube_print_types.print[i].print_type.xmltext#,
				#sql_unicode()#'#dosyam.workcube_print_types.print[i].print_module_name.xmltext#',
				#dosyam.workcube_print_types.print[i].dictionary_id.xmltext#
			)
		</cfquery>
	</cfloop>
</cfif>

<!--- PROCESS_TYPE tablosu Surecler --->
<cfquery name="PROCESS_TYPE_GET" datasource="#DSN#">
	SELECT PROCESS_ID FROM PROCESS_TYPE
</cfquery>
<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#setup_process_type.xml" variable="xmldosyam" charset = "UTF-8">
<cfset dosyam = XmlParse(xmldosyam)>
<cfset xml_dizi = dosyam.SETUP_PROCESS_TYPE.XmlChildren>
<cfset d_boyut = ArrayLen(xml_dizi)>
<cfif not process_type_get.recordcount>
	<cfloop index="i" from ="1" to="#d_boyut#">
		<cfquery name="ADD_SETUP_PROCESS_TYPE" datasource="#DSN#">
			INSERT INTO
				PROCESS_TYPE
			(
				IS_ACTIVE,
				IS_STAGE_BACK,
				PROCESS_NAME,
				FACTION
			)
			VALUES
			(
				1,
				0,
				#sql_unicode()#'#dosyam.SETUP_PROCESS_TYPE.PROCESS[i].PROCESS_NAME.XmlText#',
				#sql_unicode()#'#dosyam.SETUP_PROCESS_TYPE.PROCESS[i].FACTION.XmlText#'
			)
		</cfquery>
	</cfloop>
</cfif>

<!--- PROCESS_TYPE_ROW table --->
<cfquery name="GET_PROCESS_TYPE_COUNT" datasource="#DSN#">
	SELECT PROCESS_ID FROM PROCESS_TYPE ORDER BY PROCESS_ID
</cfquery>
<cfif get_process_type_count.recordcount>
	<cfquery name="GET_ROWS" datasource="#DSN#">
		SELECT PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS
	</cfquery>
	<cfif not get_rows.recordcount>
		<cfloop index="i" from ="1" to="#get_process_type_count.recordcount#">
			<cfquery name="add_setup_process_type_rows" datasource="#DSN#">
				INSERT INTO
					PROCESS_TYPE_ROWS
				(
					PROCESS_ID,
					IS_WARNING,
					IS_SMS,
					IS_EMAIL,
					IS_ONLINE,
					STAGE,
					LINE_NUMBER,
					ANSWER_HOUR,
					ANSWER_MINUTE,
					IS_ACTION,
					IS_DISPLAY,
					IS_CONTINUE,
					IS_EMPLOYEE,
					IS_PARTNER,
					IS_CONSUMER
				)
				VALUES
				(
					#i#,
					1,
					0,
					0,
					0,
					'Kayıt',
					1,
					0,
					0,
					0,
					0,
					0,
					<cfif dosyam.SETUP_PROCESS_TYPE.PROCESS[i].PROCESS_NAME.XmlText is 'İK Pozisyon' or dosyam.SETUP_PROCESS_TYPE.PROCESS[i].PROCESS_NAME.XmlText is 'Personel Özlük (E-Profil)'>
					1,
					<cfelse>
					0,
					</cfif>
					0,
					0
				)
			</cfquery>
			<!--- Iliskili Sirketler, Default Olarak Secili --->
			<cfquery name="Add_Setup_Process_Type_Our_Company" datasource="#dsn#">
				INSERT INTO
					PROCESS_TYPE_OUR_COMPANY
				(
					PROCESS_ID,
					OUR_COMPANY_ID
				)
				VALUES
				(
					#i#,
					1<!--- Default olarak sirket idsi 1 veriliyor --->
				)
			</cfquery>

		</cfloop>
	</cfif>
</cfif>

<!--- Bankaların Kod ve isimleri --->
<cfquery name="get_bank_names" datasource="#DSN#">
	SELECT BANK_ID FROM SETUP_BANK_TYPES
</cfquery>
<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#setup_bank_name.xml" variable="xmldosyam" charset = "UTF-8">
<cfset dosyam = XmlParse(xmldosyam)>
<cfset xml_dizi = dosyam.BANK_NAMES.XmlChildren>
<cfset d_boyut = ArrayLen(xml_dizi)>
<cfif not get_bank_names.recordcount>
	<cfloop index="i" from ="1" to="#d_boyut#">
		<cfquery name="ADD_SETUP_BANK_NAME" datasource="#DSN#">
			INSERT INTO
				SETUP_BANK_TYPES
			(
				BANK_CODE,
				BANK_NAME
			)
			VALUES
			(
				#sql_unicode()#'#dosyam.bank_names.BANK[i].BANK_CODE.XmlText#',
				#sql_unicode()#'#dosyam.bank_names.BANK[i].BANK_NAME.XmlText#'
			)
		</cfquery>
	</cfloop>
</cfif>

<!--- Maindeki Belge Numaraları --->
<cfquery name="GET_GENERAL_PAPERS_MAIN" datasource="#DSN#">
	SELECT GENERAL_PAPER_ID FROM GENERAL_PAPERS_MAIN
</cfquery>
<cfif not get_general_papers_main.recordcount>
	<cfquery name="ADD_GENERAL_PAPERS" datasource="#DSN#">
		INSERT INTO 
			GENERAL_PAPERS_MAIN
		(  
			EMPLOYEE_NO,
			EMPLOYEE_NUMBER,
			EMP_APP_NO,
			EMP_APP_NUMBER,
			G_SERVICE_APP_NO,
			G_SERVICE_APP_NUMBER,
			EMP_NOTICE_NO,
			EMP_NOTICE_NUMBER,
			FIXTURES_NO,
			FIXTURES_NUMBER,
			EMPLOYEE_HEALTY_NO,
			EMPLOYEE_HEALTY_NUMBER,
			ASSET_NO,
			ASSET_NUMBER
		)		
		VALUES 
		(
			'EMP',
			0,
			'IBN',
			0,
			'SBN',
			0,
			'ILN',
			0,
			'DN',
			0,
			'IB',
			0,
			'DJ',
			0			
		)
	</cfquery>
</cfif>
<cfquery name="GET_UNITS" datasource="#DSN#">
	SELECT COUNT(*) COUNT FROM SETUP_UNIT
</cfquery>
<cfif get_units.count eq 0>
    <cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#units.xml" variable="xmldosyam" charset = "UTF-8">
    <cfset dosyam = XmlParse(xmldosyam)>
    <cfset xml_dizi = dosyam.SETUP_UNITS.XmlChildren>
    <cfset d_boyut = ArrayLen(xml_dizi)>
    <cfloop index="i" from ="1" to="#d_boyut#">
    	<cfquery name="INS_UNIT" datasource="#dsn#">
        INSERT INTO 
            SETUP_UNIT
            (
                UNIT,
                UNIT_CODE
            )
            VALUES
            (
                '#dosyam.SETUP_UNITS.UNITS[i].UNIT_NAME.XmlText#',
                '#dosyam.SETUP_UNITS.UNITS[i].UNIT_CODE.XmlText#'
            )
            SELECT SCOPE_IDENTITY() AS MAX_ID
	    </cfquery>
        
        <cfquery name="INS_LANG" datasource="#dsn#">
        	INSERT INTO
            	SETUP_LANGUAGE_INFO
                (
                	TABLE_NAME,
                    ITEM,
                    UNIQUE_COLUMN_ID,
                    COLUMN_NAME,
                    LANGUAGE
                )
                VALUES
                (
                	'SETUP_UNIT',
                    '#dosyam.SETUP_UNITS.UNITS[i].UNIT_ENG_NAME.XmlText#',
                    #INS_UNIT.MAX_ID#,
                    'UNIT',
                    'eng'
                )
        </cfquery>
    </cfloop>
</cfif>

<!--- Fiş Belge Tipleri --->
<cfquery name="get_account_card_document_types" datasource="#DSN#">
	SELECT ID FROM ACCOUNT_CARD_DOCUMENT_TYPES
</cfquery>
<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#account_card_document_types.xml" variable="xmldosyam" charset = "UTF-8">
<cfset dosyam = XmlParse(xmldosyam)>
<cfset xml_dizi = dosyam.ACCOUNT_CARD_DOCUMENT_TYPES.XmlChildren>
<cfset d_boyut = ArrayLen(xml_dizi)>
<cfif not get_account_card_document_types.recordcount>
	<cfloop index="i" from ="1" to="#d_boyut#">
		<cfquery name="ADD_ACCOUNT_CARD_DOCUMENT_TYPE" datasource="#DSN#">
			INSERT INTO
				ACCOUNT_CARD_DOCUMENT_TYPES
			(
				DOCUMENT_TYPE_ID,
				DOCUMENT_TYPE,
                DETAIL,
                IS_OTHER
			)
			VALUES
			(
				#sql_unicode()#'#dosyam.ACCOUNT_CARD_DOCUMENT_TYPES.ACCOUNT_CARD_DOCUMENT_TYPE[i].DOCUMENT_TYPE_ID.XmlText#',
				#sql_unicode()#'#dosyam.ACCOUNT_CARD_DOCUMENT_TYPES.ACCOUNT_CARD_DOCUMENT_TYPE[i].DOCUMENT_TYPE.XmlText#',
                #sql_unicode()#'#dosyam.ACCOUNT_CARD_DOCUMENT_TYPES.ACCOUNT_CARD_DOCUMENT_TYPE[i].DETAIL.XmlText#',
                #dosyam.ACCOUNT_CARD_DOCUMENT_TYPES.ACCOUNT_CARD_DOCUMENT_TYPE[i].IS_OTHER.XmlText#
			)
		</cfquery>
	</cfloop>
</cfif>

<!--- Fiş Ödeme Şekilleri --->
<cfquery name="get_account_card_payment_types" datasource="#DSN#">
	SELECT ID FROM ACCOUNT_CARD_PAYMENT_TYPES
</cfquery>
<cffile action="read" file="#attributes.upload_folder#xml#dir_seperator#account_card_payment_types.xml" variable="xmldosyam" charset = "UTF-8">
<cfset dosyam = XmlParse(xmldosyam)>
<cfset xml_dizi = dosyam.ACCOUNT_CARD_PAYMENT_TYPES.XmlChildren>
<cfset d_boyut = ArrayLen(xml_dizi)>
<cfif not get_account_card_payment_types.recordcount>
	<cfloop index="i" from ="1" to="#d_boyut#">
		<cfquery name="ADD_ACCOUNT_CARD_PAYMENT_TYPE" datasource="#DSN#">
			INSERT INTO
				ACCOUNT_CARD_PAYMENT_TYPES
			(
				PAYMENT_TYPE_ID,
				PAYMENT_TYPE,
                DETAIL
			)
			VALUES
			(
				#sql_unicode()#'#dosyam.ACCOUNT_CARD_PAYMENT_TYPES.ACCOUNT_CARD_PAYMENT_TYPE[i].PAYMENT_TYPE_ID.XmlText#',
				#sql_unicode()#'#dosyam.ACCOUNT_CARD_PAYMENT_TYPES.ACCOUNT_CARD_PAYMENT_TYPE[i].PAYMENT_TYPE.XmlText#',
                #sql_unicode()#'#dosyam.ACCOUNT_CARD_PAYMENT_TYPES.ACCOUNT_CARD_PAYMENT_TYPE[i].DETAIL.XmlText#'
			)
		</cfquery>
	</cfloop>
</cfif>
