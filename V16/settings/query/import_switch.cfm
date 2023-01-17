<cfsetting showdebugoutput="no">
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
<cfquery name="UPD_IS_SPECIAL" datasource="#DSN#">
	UPDATE WRK_OBJECTS SET IS_SPECIAL = 0 WHERE IS_SPECIAL IS NULL
</cfquery>
<cfquery name="get_temp_table" datasource="#DSN#"><!--- Yasaklı SAyfalar icin temp table varsa siliniyor --->
    IF object_id('tempdb..#chr(35)#WBO_DENIED_CONTROL') IS NOT NULL
        BEGIN
            DROP TABLE #chr(35)#WBO_DENIED_CONTROL 
        END
</cfquery>
<cfquery name="temp_table" datasource="#DSN#"><!--- Yasaklı sayfalar icin tablo yaratılıyor --->
    CREATE TABLE #chr(35)#WBO_DENIED_CONTROL 
    ( 
        FUSEACTION	nvarchar(250),
        MODUL	nvarchar(50),
        IS_WBO_DENIED	bit,
        IS_WBO_FORM_LOCK	bit,
        IS_WBO_LOCK	bit
    )
</cfquery>
<cfquery name="ins_temp_table" datasource="#DSN#"><!--- Mevcut yasakli sayfa kayitlari temp tabloya yaziliyor --->
    INSERT INTO #chr(35)#WBO_DENIED_CONTROL 
	(
        FUSEACTION,
        MODUL,
        IS_WBO_DENIED,
        IS_WBO_FORM_LOCK,
        IS_WBO_LOCK
    )
    SELECT 
	    FUSEACTION,
        MODUL,
        ISNULL(IS_WBO_DENIED,0),
        ISNULL(IS_WBO_FORM_LOCK,0),
        ISNULL(IS_WBO_LOCK,0)
   FROM
   		WRK_OBJECTS
   WHERE
		IS_WBO_DENIED != 0 OR
        IS_WBO_FORM_LOCK != 0 OR
        IS_WBO_LOCK != 0
</cfquery>

<cfquery name="DELETE_SWITCH" datasource="#DSN#"><!--- Musteri icin yapılmıs ozel sayfalar dısındakiler siliniyor  --->
	DELETE FROM WRK_OBJECTS WHERE IS_SPECIAL != 1 AND MODUL != 'Extra'
</cfquery>
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
				<cfoutput>#i#. satırda okuma sırasında hata oldu. <br />
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
	<cfif error gt 0>
	  <cfoutput>#error# adet hata <br />meydana gelmiştir<br />#record_count# adet switch WRK_OBJECTS tablosuna kaydedilmiştir</cfoutput>
	</cfif>
    <cffunction name="add_wbo_object_switch" output="false" returntype="numeric">
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

	<cffunction name="add_block_row" output="false" returntype="any">
		<cfargument name="db_source" type="string" default="#DSN#">
		<cfargument name="row_array" type="array" required="yes">
		<cfargument name="satir_atla" type="string" default="#chr(13)&chr(10)#">
		<cfif ArrayLen(arguments.row_array) gt 0 and database_type is 'MSSQL'>
			<cfset arguments.row_array = ArrayToList(arguments.row_array,arguments.satir_atla)><!--- SQL cumlesi liste olarak olustu --->
			<cfquery name="add_block_row_" datasource="#arguments.db_source#"> 
				#PreserveSingleQuotes(arguments.row_array)#
			</cfquery>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>	

    
<cfquery name="get_temp_table" datasource="#DSN#"><!--- Temp tablodaki kayitlar cekiliyor --->
	SELECT * FROM #chr(35)#WBO_DENIED_CONTROL 
</cfquery>
<cfif get_temp_table.recordcount>
    <cfloop query="get_temp_table"><!--- Fuseactionlardaki yasaklar geri yukleniyor--->
        <cfquery name="UPD_FUSE" datasource="#DSN#">
            UPDATE 
                WRK_OBJECTS
            SET
                IS_WBO_DENIED = #get_temp_table.IS_WBO_DENIED#,
                IS_WBO_FORM_LOCK = #get_temp_table.IS_WBO_FORM_LOCK#,
                IS_WBO_LOCK	= #get_temp_table.IS_WBO_LOCK#
            WHERE
                FUSEACTION = '#get_temp_table.fuseaction#' AND
                MODUL = '#get_temp_table.modul#'
        </cfquery>
    </cfloop>
</cfif>
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
<cfquery name="get_temp_table" datasource="#DSN#"><!--- Temp tablo siliniyor --->
    DROP TABLE #chr(35)#WBO_DENIED_CONTROL 
</cfquery>


<script type="text/javascript">
	alert("<cfoutput>#record_count# Adet Switch Kaydedilmiştir.</cfoutput> !");
	history.back();
</script>
