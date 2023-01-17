<cfquery name="GET_LANG" datasource="#DSN#">
    SELECT LANGUAGE_SHORT FROM SETUP_LANGUAGE
</cfquery>
<cfset lang_list = valuelist(get_lang.language_short)>
<cfsetting requestTimeout="1000">
<!--- islem 1: language ler aliniyor --->
<cflock name="#createUUID()#" timeout="500">
	<cftransaction>
		<cfif not FileExists("#index_folder#CustomTags#dir_seperator#xml#dir_seperator#language.csv")>
            <script type="text/javascript">
                alert('language.csv Dosyası bulunamadı');
                history.back();
            </script>
            <cfabort>
        </cfif>
        <cfquery name="ADD_LANGUAGE_DB" datasource="#dsn#">
        <!---TolgaS 20060529 Drop edince db userlara verilen yetkiler kayboluyordu o nedenden kaldirildi ve tablonun olmaya bilecegi goz onune alinarak create de yazildi--->
        if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[SETUP_LANGUAGE_TR]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
            begin
            TRUNCATE TABLE SETUP_LANGUAGE_TR
            end
        else
            begin
                CREATE TABLE [SETUP_LANGUAGE_TR] (
                    [ITEM_ID] [int] NULL ,
                    [MODULE_ID] [nvarchar] (50) COLLATE Turkish_CI_AS NULL ,
                    <cfloop list="#lang_list#" index="my_lang_2">
                        <cfset NEW_COLUMN_NAME="ITEM_#UCASE(my_lang_2)#">
                        [#NEW_COLUMN_NAME#] [nvarchar] (500) COLLATE Turkish_CI_AS NULL 
                    </cfloop>
                ) ON [PRIMARY]
            end
        </cfquery>
	</cftransaction>
</cflock>
<cflock name="#createUUID()#" timeout="500">
	<cftransaction>
        <cffile action="read" file="#index_folder#CustomTags#dir_seperator#xml#dir_seperator#language.csv" variable="dosya" charset="utf-8">
        <cfquery name="DB_COLUMNS" datasource="#DSN#">
            SELECT name FROM syscolumns WHERE id = object_id(N'[SETUP_LANGUAGE_TR]') ORDER BY colorder
        </cfquery> 
        <cfset column_list = listDeleteAt(valueList(DB_COLUMNS.name,','),1,',')><!---DictionaryId alanını almamak için kaldırıldı.--->
        <cfif DB_COLUMNS.recordcount>
            <cfscript>
                ayrac=';';
                CRLF = Chr(13) & Chr(10);// satır atlama karakteri
                dosya = Replace(dosya,'#ayrac##ayrac#',' #ayrac# #ayrac# ','all');
                dosya = Replace(dosya,'#ayrac##ayrac#',' #ayrac# #ayrac# ','all');
                dosya = Replace(dosya,'#ayrac#',' #ayrac# ','all');
                dosya = ListToArray(dosya,CRLF);
                line_count = ArrayLen(dosya);
                counter = 0;
                add_setup_language = ArrayNew(1);
            </cfscript>

            <cfloop from="2" to="#line_count#" index="j">
                <cfscript>
                    row_block = 500;
                    column = 1;
                    error_flag = 0;
                    counter = counter + 1;
                    satir=dosya[j]&'  ;';
                    liste = "";
                    
                    for(i=1; i lte ListLen(column_list,',') ; i++)
                    {
                        ITEM_ = ListGetAt(satir,column,ayrac);
                        ITEM_ = trim(ITEM_);
                        column = column + 1;
                        if(i eq 1){
                            liste = ListAppend(liste,ITEM_,',');
                        }
                        else{
                            liste = ListAppend(liste,"'#ITEM_#'",',');
                        }
                    }
                
                    sonuc = add_setup_language_func
                    (
                        ROW_BLOCK : row_block,
                        LIST : liste
                    );
                </cfscript>
            </cfloop>
            <cfscript>
                sonuc_add_row_2 = add_block_row(db_source:'#DSN#',row_array:add_setup_language);
                add_setup_language = ArrayNew(1);
            </cfscript>
        </cfif> 
	</cftransaction>
</cflock>

<cflock name="#createUUID()#"  timeout="500">
	<cftransaction>
		<cfquery name="get_new_item" datasource="#DSN#">
			SELECT * FROM SETUP_LANGUAGE
		</cfquery>
		<cfloop from="1" to="#get_new_item.recordcount#" index="i">
			<cfset NEW_COLUMN_NAME="ITEM_#UCASE(get_new_item.LANGUAGE_SHORT[i])#">
			<cfquery name="check" datasource="#DSN#">
				SELECT * FROM SETUP_LANG_SPECIAL WHERE LANG_NAME = '#UCASE(get_new_item.LANGUAGE_SHORT[i])#'
			</cfquery>
			<cfif check.recordcount>
				<cfoutput query="check">
					<cfquery name="upd_lang" datasource="#DSN#">
						UPDATE SETUP_LANGUAGE_TR SET #NEW_COLUMN_NAME# = #sql_unicode()#'#ITEM#' 
                        WHERE ITEM_ID = #ITEM_ID# AND MODULE_ID = '#MODULE_ID#'
					</cfquery>
				</cfoutput>
			</cfif>
		</cfloop>
	</cftransaction>
</cflock>

<cffunction name="add_setup_language_func" output="false" returntype="any">
	<cfargument name="DB_SOURCE" type="string" default="#DSN#">
	<cfargument name="ROW_BLOCK" type="numeric" default="500">
    <cfargument name="LIST" required="yes">
	<cfscript>
		add_setup_language[Arraylen(add_setup_language)+1] = "INSERT INTO SETUP_LANGUAGE_TR (#column_list#) VALUES (#arguments.list#)";
		if((ArrayLen(add_setup_language) gt 1) and (ArrayLen(add_setup_language) mod arguments.row_block eq 0))
		{
			sonuc_add_row_2 = add_block_row(db_source:arguments.db_source,row_array:add_setup_language);
			add_setup_language = ArrayNew(1);
		}
	</cfscript>
	<cfreturn true>
</cffunction>

<!---
<cffunction name="add_block_row" output="false" returntype="string">
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
<cfif isdefined("session.ep.userid")>
	<!--- admin_toola dan da include edildiği için kontol kondu --->
	<script type="text/javascript">
		alert("<cf_get_lang no ='2535.language CSV dosyası CustomTags altında XML klasöründen import edildi'> !");
		history.back();
	</script>
</cfif>--->
