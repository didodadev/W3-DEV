<cfsetting showdebugoutput="no">
<cfquery name="GET_IMPORT" datasource="#dsn#">
	SELECT * FROM FILE_IMPORTS_MAIN WHERE I_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.i_id#">
</cfquery>
<cfquery name="get_in_outs" datasource="#dsn#">
	SELECT 
		EMPLOYEES_IN_OUT.EMPLOYEE_ID,
		IN_OUT_ID,
		PDKS_NUMBER,
		FINISH_DATE,
		BRANCH_ID,
		START_DATE,
		EMPLOYEE_NO
	FROM 
		EMPLOYEES_IN_OUT ,
		EMPLOYEES
	WHERE 
		EMPLOYEES_IN_OUT.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
	ORDER BY 
		START_DATE DESC
</cfquery>
<cfquery name="get_branch_ids" datasource="#dsn#">
	SELECT 
		BRANCH_ID,
		BRANCH_PDKS_CODE
	FROM 
		BRANCH
	WHERE
		BRANCH_PDKS_CODE IS NOT NULL
</cfquery>
<cfquery name="GET_OFFTIMES" datasource="#dsn#">
	SELECT START_DATE,FINISH_DATE,OFFTIME_NAME FROM SETUP_GENERAL_OFFTIMES
</cfquery>
<cfset general_offtime_days_ = "">
<cfset general_offtime_days_names_ = "">
<cfoutput query="GET_OFFTIMES">
	<cfset day_count = DateDiff("d",start_date,finish_date) + 1>
	<cfloop index="k" from="1" to="#day_count#">
		<cfset current_day = date_add("d", k-1, start_date)>
		<cfset current_day = dateformat(current_day,'dd.mm.yyyy')>
		<cfset general_offtime_days_ = listappend(general_offtime_days_,current_day)>
		<cfset general_offtime_days_names_ = listappend(general_offtime_days_names_,offtime_name)>
	</cfloop>
</cfoutput>

<cfif get_import.recordcount>
	<!---DAHA ÖNCE İŞLETİLDİMİ--->
	<cfif get_import.imported eq 1>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1688.Bu Dosya İmport Edilmiş, Tekrar İmport Edilemez'> !");
			wrk_opener_reload();
			window.close;
		</script>
		<cfabort>
	</cfif>
	Aktarım İşlemi Başladı, Lütfen Bekleyiniz...<br/>

	<cfscript>
		if(get_import.file_format eq 1) charset='ISO-8859-9'; else charset='UTF-8';
		if(get_import.delimiter eq 1) ayirac=','; else if (get_import.delimiter eq 2) ayirac=';'; else ayirac=' ';
		start_time = now();
	</cfscript>
	<cffile action="read" file="#upload_folder#hr#dir_seperator##get_import.file_name#" variable="dosya" charset="#charset#">
	<cfif get_import.paper_type eq 1><!--- Hedef için yapılan import tipi --->
		<cfscript>
			CRLF = Chr(13)&Chr(10); // satır atlama karakteri
			dosya1 = ListToArray(dosya,CRLF);		
			line_count = ArrayLen(dosya1);
		</cfscript>
		<cfinclude template="add_import_pdks_row_multiport.cfm">
		<cfset kayit_yapildi = 1>
	<cfelseif get_import.paper_type eq 2><!--- WRK için yapılan import tipi --->
		<cfinclude template="add_import_pdks_row_xml.cfm">
		<cfset kayit_yapildi = 1>
	<cfelseif get_import.paper_type eq 3><!--- WRK için yapılan import tipi --->
		<cfscript>
			CRLF = Chr(13)&Chr(10); // satır atlama karakteri
			dosya1 = ListToArray(dosya,CRLF);		
			line_count = ArrayLen(dosya1);
		</cfscript>
		<cfinclude template="add_import_pdks_row_erk.cfm">
		<cfset kayit_yapildi = 1>
	<cfelseif get_import.paper_type eq 4><!--- TXT File için yapılan import tipi --->
		<cfscript>
			CRLF = Chr(13)&Chr(10); // satır atlama karakteri
			dosya1 = ListToArray(dosya,CRLF);		
			line_count = ArrayLen(dosya1);
		</cfscript>
		<cfinclude template="add_import_pdks_row_multiport_2.cfm">
		<cfset kayit_yapildi = 1>
	<cfelseif get_import.paper_type eq 5><!--- Toplu PDKS Giriş için yapılan import tipi --->
		<cfscript>
			CRLF = Chr(13)&Chr(10); // satır atlama karakteri
			dosya1 = ListToArray(dosya,CRLF);
			line_count = ArrayLen(dosya1);
		</cfscript>
		<cfinclude template="add_import_pdks_row_group_entry.cfm">
		<cfset kayit_yapildi = 1>
	<cfelseif get_import.paper_type eq 6><!--- | Worknet için yapılan import tipi | --->
		<cfscript>
			CRLF = Chr(13)&Chr(10); // satır atlama karakteri
			dosya1 = ListToArray(dosya,CRLF);		
			line_count = ArrayLen(dosya1);
		</cfscript>
		<cfinclude template="add_import_pdks_row_worknet.cfm">
		<cfset kayit_yapildi = 1>
	<cfelseif get_import.paper_type eq 7><!--- | Emre için yapılan import tipi | --->
		<cfscript>
			CRLF = Chr(13)&Chr(10); // satır atlama karakteri
			dosya1 = ListToArray(dosya,CRLF);		
			line_count = ArrayLen(dosya1);
		</cfscript>
		<cfinclude template="add_import_pdks_row_emre.cfm">
		<cfset kayit_yapildi = 1>
	<cfelseif get_import.paper_type eq 8><!--- | TA import tipi | --->
		<cfscript>
			CRLF = Chr(13)&Chr(10); // satır atlama karakteri
			dosya1 = ListToArray(dosya,CRLF);		
			line_count = ArrayLen(dosya1);
		</cfscript>
		<cfinclude template="add_import_pdks_row_ta.cfm">
		<cfset kayit_yapildi = 1>
	<cfelseif get_import.paper_type eq 9><!--- | Polin import tipi | --->
		<cfscript>
			CRLF = Chr(13)&Chr(10); // satır atlama karakteri
			dosya1 = ListToArray(dosya,CRLF);		
			line_count = ArrayLen(dosya1);
		</cfscript>
		<cfinclude template="add_import_pdks_row_pln.cfm">
		<cfset kayit_yapildi = 1>
	<cfelseif get_import.paper_type eq 10><!--- | Tezcan import tipi | --->
		<cfscript>
			CRLF = Chr(13)&Chr(10); // satır atlama karakteri
			dosya1 = ListToArray(dosya,CRLF);		
			line_count = ArrayLen(dosya1);
		</cfscript>
		<cfinclude template="add_import_pdks_row_tezcan.cfm">
		<cfset kayit_yapildi = 1>
	<cfelseif get_import.paper_type eq 11><!--- | Adnan Akat import tipi | --->
		<cfscript>
			CRLF = Chr(13)&Chr(10); // satır atlama karakteri
			dosya1 = ListToArray(dosya,CRLF);		
			line_count = ArrayLen(dosya1);
		</cfscript>
		<cfinclude template="add_import_pdks_row_aa.cfm">
		<cfset kayit_yapildi = 1>
	<cfelseif get_import.paper_type eq 12><!--- | WORKCUBE | --->
		<cfscript>
			CRLF = Chr(13)&Chr(10); // satır atlama karakteri
			dosya1 = ListToArray(dosya,CRLF);		
			line_count = ArrayLen(dosya1);
		</cfscript>
		<cfinclude template="add_import_pdks_row_workcube.cfm">
		<cfset kayit_yapildi = 1>
	<cfelse>
		<cfset kayit_yapildi = 0>
	</cfif>
	<cfif kayit_yapildi eq 1>
		<cfquery name="upd_file" datasource="#dsn#">
			UPDATE 
				FILE_IMPORTS_MAIN 
			SET
				IMPORTED=1,
				LINE_COUNT=<cfif len(line_count)>#line_count#<cfelse>0</cfif>
			WHERE 
				I_ID = #attributes.i_id#
		</cfquery>
	</cfif>

<cfif get_import.paper_type eq 1><!--- Hedef için yapılan import tipi --->
	<cfinclude template="add_import_pdks_row_multiport_extra.cfm">
<cfelseif get_import.paper_type eq 2>
	<cfinclude template="add_import_pdks_row_xml_extra.cfm">
</cfif>

<cfif kayit_yapildi eq 1>
	<cfoutput>
		<hr>
			import satır sayısı : #line_count#<br/>
			Toplam Süre : #timeformat(now()-start_time,'mm:ss')#<br/>
		<hr>
	</cfoutput>
</cfif>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
</cfif> 
