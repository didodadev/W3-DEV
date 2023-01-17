<cfsetting showdebugoutput="no">
<cfset dsn = application.systemParam.systemParam().dsn>
<style type="text/css">
<!--
td {
	border-bottom: solid 1 black;
	border-right: solid 1 black;
}
table {
	border-top: solid 1 black;
	border-left: solid 1 black;
}
-->
</style>
<script type="text/javascript">
function db2func1(secilen)
{
	if (secilen == 0)
		db_diff.db_type_1_1.style.display = 'none';
	else if (secilen == 1)
		db_diff.db_type_1_1.style.display = '';			
}
function db2func2(secilen)
{
	if (secilen == 0)
		db_diff.db_type_2_1.style.display = 'none';
	else if (secilen == 1)
		db_diff.db_type_2_1.style.display = '';			
}
</script>

<cffunction name="getColumns" returntype="query" output="false">
	<cfargument name="db_type" type="string" required="true">
	<cfargument name="dsn_name" type="string" required="true">
	<cfargument name="table_name" type="string" required="true">

	<cfquery name="columns" datasource="#dsn#">
		<cfif arguments.db_type is "mssql">
			EXEC sp_columns @table_name = '#arguments.table_name#',@table_owner='#arguments.dsn_name#'
		<cfelseif arguments.db_type is "db2">
			SELECT
				COLNAME AS COLUMN_NAME,
				TYPENAME AS TYPE_NAME,
				LENGTH,
				NULLS AS NULLABLE,
				IDENTITY
			FROM
				SYSCAT.COLUMNS
			WHERE
				TABNAME = '#arguments.table_name#'
		</cfif>
	</cfquery>
	<cfquery dbtype="query" name="columns">
		SELECT * FROM COLUMNS ORDER BY COLUMN_NAME
	</cfquery>
	<cfreturn columns>
</cffunction>
<cffunction name="write_field" output="true">
	<cfargument name="db_type" type="string" required="true">
	<cfargument name="db_name" type="string" required="true">
	<cfargument name="x" type="string" required="true"><!--- i --->
	<cfargument name="y" type="string" required="true"><!--- j --->
	<td style="font-size:12px;color:red" width="50%">
		<cfoutput>
			<b>#arguments.y#</b> ( 
			<cfset sira = listgetat(evaluate("#arguments.db_name#.#x#.types"),evaluate("#arguments.db_name#_counter"))>
			<cfif sira neq 999>
				<cfif arguments.db_type is "mssql">
					<font color="blue">#ListGetAt(mssql_variables,sira)#</font> : 
				<cfelseif arguments.db_type is "db2">
					<font color="blue">#ListGetAt(db2_variables,sira)#</font> : 
				</cfif>
			<cfelse>
				<br/><font color="navy"><strong><cf_get_lang dictionary_id='32797.Standart Dışı Değişken Kullanımı'> !</strong></font><br/>
			</cfif>
			<font color="navy">#listgetat(evaluate("#arguments.db_name#.#x#.lengths"),evaluate("#arguments.db_name#_counter"))#</font> ) 
			<cfif listgetat(evaluate("#arguments.db_name#.#x#.iden"),  evaluate("#arguments.db_name#_counter")) is "Y">
				<font color="green">id</font>
			<cfelse>
				<font color="green">not id</font>
			</cfif>
		</cfoutput>
	</td>
</cffunction>

<cfparam name="attributes.dsn_1" default="">
<cfparam name="attributes.dsn_2" default="">
<cfparam name="attributes.db_1" default="">
<cfparam name="attributes.db_2" default="">
<cfparam name="attributes.db_type_1" default="">
<cfparam name="attributes.db_type_2" default="">
<cfparam name="attributes.db_type_1_1" default="">
<cfparam name="attributes.db_type_2_1" default="">
<cfparam name="attributes.db_chartype_1" default="">
<cfparam name="attributes.db_chartype_2" default="">
<cf_popup_box title="#getLang('objects',440)#">
    <cfform name="db_diff" action="" method="post">
        <table align="center">
            <tr>
                <td>&nbsp;</td>
                <td align="center" class="txtbold"><cf_get_lang dictionary_id='32798.DB 1(workcube_cf)'></td>
                <td align="center" class="txtbold"><cfoutput>DB 2 (#DSN#)</cfoutput></td>
            </tr>
            <tr>
                <td class="txtbold"><cf_get_lang dictionary_id='32893.DSN'></td>
                <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='32841.DSN 1 Girmelisiniz !'></cfsavecontent>
                    <cfinput type="text" name="dsn_1" value="#attributes.dsn_1#" required="yes" message="#message#" style="width:160px;"> 
                </td>
                <td><cfsavecontent variable="message2"><cf_get_lang dictionary_id='32760.DSN 2 Girmelisiniz !'></cfsavecontent>
                    <cfinput type="text" name="dsn_2" value="#attributes.dsn_2#" required="yes" message="#message2#" style="width:160px;">
                </td>
            </tr>
            <tr>
                <td class="txtbold"><cf_get_lang dictionary_id='32791.Veritabanı'></td>
                <td><cfsavecontent variable="message3"><cf_get_lang dictionary_id='32759.DB 1 Girmelisiniz !'></cfsavecontent>
                    <cfinput type="text" name="db_1" value="#attributes.db_1#" required="yes" message="#message3#" style="width:160px;">
                </td>
                <td><cfsavecontent variable="message4"><cf_get_lang dictionary_id='32758.DB 2 Girmelisiniz !'></cfsavecontent>
                    <cfinput type="text" name="db_2" value="#attributes.db_2#" required="yes" message="#message4#" style="width:160px;">
                </td>
            </tr>
            <tr>
                <td class="txtbold"><cf_get_lang dictionary_id='57630.Tip'></td>
                <td><select name="db_type_1" id="db_type_1" style="width:100px;" onchange="db2func1(this.selectedIndex);">
                        <option value="mssql"<cfif attributes.db_type_1 is "mssql"> selected</cfif>><cf_get_lang dictionary_id='32809.MS SQL Server'></option>
                        <option value="db2"<cfif attributes.db_type_1 is "db2"> selected</cfif>><cf_get_lang dictionary_id='32813.DB2 UDB Server'></option>
                    </select>
                    <select name="db_chartype_1" id="db_chartype_1">
                        <option value="0"<cfif attributes.db_chartype_1 is "0"> selected</cfif>><cf_get_lang dictionary_id='32806.ASCII'></option>
                        <option value="1"<cfif attributes.db_chartype_1 is "1"> selected</cfif>><cf_get_lang dictionary_id='32802.UTF-8'></option>
                    </select>
                </td>
                <td><select name="db_type_2" id="db_type_2" style="width:100px;" onchange="db2func2(this.selectedIndex);">
                        <option value="mssql"<cfif attributes.db_type_2 is "mssql"> selected</cfif>><cf_get_lang dictionary_id='32809.MS SQL Server'></option>
                        <option value="db2" <cfif attributes.db_type_2 is "db2"> selected</cfif>><cf_get_lang dictionary_id='32813.DB2 UDB Server'></option>
                    </select>
                    <select name="db_chartype_2" id="db_chartype_2">
                        <option value="0"<cfif attributes.db_chartype_2 is "0"> selected</cfif>><cf_get_lang dictionary_id='32806.ASCII'></option>
                        <option value="1"<cfif attributes.db_chartype_2 is "1"> selected</cfif>><cf_get_lang dictionary_id='32802.UTF-8'></option>
                    </select>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td><select name="db_type_1_1" id="db_type_1_1" style="width:100px;display:'none';">
                        <option value="0" <cfif attributes.db_type_1_1 eq 0> selected</cfif>><cf_get_lang dictionary_id='32814.Ana Veritabanı'></option>
                        <option value="1" <cfif attributes.db_type_1_1 eq 1> selected</cfif>><cf_get_lang dictionary_id='57574.Şirket'></option>
                        <option value="2" <cfif attributes.db_type_1_1 eq 2> selected</cfif>><cf_get_lang dictionary_id='57447.Muhasebe'></option>
                    </select>
                </td>
                <td><select name="db_type_2_1" id="db_type_2_1" style="width:100px;display:'none';">
                        <option value="0"<cfif attributes.db_type_2_1 eq 0> selected</cfif>><cf_get_lang dictionary_id='32814.Ana Veritabanı'></option>
                        <option value="1"<cfif attributes.db_type_2_1 eq 1> selected</cfif>><cf_get_lang dictionary_id='57574.Şirket'></option>
                        <option value="2"<cfif attributes.db_type_2_1 eq 2> selected</cfif>><cf_get_lang dictionary_id='57447.Muhasebe'></option>
                    </select>
                </td>
            </tr>
        	<tr>
            	<td colspan="3">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='32516.Karşılaştır'></cfsavecontent>
                    <cf_workcube_buttons 
                        is_upd='0'
                        insert_info='#message#' 
                        insert_alert='' 
                        is_cancel='0'>
       			</td>
            </tr>
       </table>
    </cfform>
</cf_popup_box>    
<cfif not (len(attributes.dsn_1) and len(attributes.dsn_2))>
<cfexit method="exittemplate">
</cfif>
<cfscript>
	function ListCompare(List1, List2)
	{
		var TempList = "";
		var Delim1 = ",";
		var Delim2 = ",";
		var Delim3 = ",";
		var i = 0;
		// Handle optional arguments
		switch(ArrayLen(arguments))
		{
			case 3:
			{
				Delim1 = Arguments[3];
				break;
			}
			case 4:
			{
				Delim1 = Arguments[3];
				Delim2 = Arguments[4];
				break;
			}
			case 5:
			{
				Delim1 = Arguments[3];
				Delim2 = Arguments[4];          
				Delim3 = Arguments[5];
				break;
			}        
		} 
		for (i=1; i LTE ListLen(List1, "#Delim1#"); i=i+1)
		{
			if (not ListFindNoCase(List2, ListGetAt(List1, i, Delim1), Delim2))
			{
				TempList = ListAppend(TempList, ListGetAt(List1, i, Delim1), Delim3);
			}
		}
		Return TempList;
	}
		
	db1 = structnew();
	db1.db = attributes.db_1;
	db1.dsn = attributes.dsn_1;
	db1.table_list = '';
	
	db2 = structnew();
	db2.db = attributes.db_2;
	db2.dsn = attributes.dsn_2;
	db2.table_list = '';
	
	mssql_variables = 'nvarchar,int identity,bit,float,ntext,datetime,int';
	db2_variables = 'VARGRAPHIC,INTEGER,SMALLINT,DOUBLE,CLOB,TIMESTAMP,INTEGER';
	counter1 = 0;
</cfscript>
<cfif attributes.db_type_1 is "mssql">
	<cfquery name="getTables" datasource="#db1.dsn#">
		EXEC sp_tables NULL, #db1.db#, #db1.dsn#, "'TABLE'"
		<!--- EXEC sp_tables RELATION_ROW, NULL, workcube_cf_1, "'TABLE'"  --->
	</cfquery>
<cfelseif attributes.db_type_1 is "db2">
	<cfquery name="getTables" datasource="#db1.dsn#">
		SELECT 
			TABNAME AS TABLE_NAME
		FROM 
			SYSCAT.TABLES
		WHERE
		<cfif attributes.db_type_1_1 eq 2>
			TABSCHEMA = '#db1.db#_DBO'
		<cfelseif attributes.db_type_1_1 eq 1>
			TABSCHEMA = '#db1.db#_DBO'
		<cfelseif attributes.db_type_1_1 eq 0>
			TABSCHEMA = 'DBO'
		</cfif>
	</cfquery>
<cfelse>
	<cf_get_lang dictionary_id='32815.Bilinmeyen Veritabanı'>! 
	<cfexit method="exittemplate">
</cfif>
<cfscript>
	db1.table_list = ValueList(getTables.table_name);
	for (counter1=1; counter1 lt (getTables.recordcount+1); counter1 = counter1+1)
	{
		table_name = getTables.table_name[counter1];
		"db1.#table_name#" = structnew();
		columns = getColumns(db_type : attributes.db_type_1, dsn_name : db1.dsn, table_name : table_name);
		"db1.#table_name#.columns" = "";
		"db1.#table_name#.types" = "";
		"db1.#table_name#.LENGTHs" = "";
		"db1.#table_name#.iden" = "";
	for (counter2=1; counter2 lt (columns.recordcount+1); counter2 = counter2 + 1)
		if ( ((attributes.db_type_1 is "mssql") ) or (attributes.db_type_1 is "db2") )
		{
			"db1.#table_name#.columns" = listappend(evaluate("db1.#table_name#.columns"),columns.column_name[counter2]);
			if (attributes.db_type_1 is "mssql")
			{
				type_index = ListFindNoCase(mssql_variables,columns.type_name[counter2]);
				if (type_index eq 2) // int identity
					"db1.#table_name#.types" = listappend(evaluate("db1.#table_name#.types"),7);
				else if (type_index gt 0)
					"db1.#table_name#.types" = listappend(evaluate("db1.#table_name#.types"), type_index);
				else
					"db1.#table_name#.types" = listappend(evaluate("db1.#table_name#.types"),999);
				if ((attributes.db_chartype_1 eq 1) and ListContainsNoCase("1,5",type_index) )
					"db1.#table_name#.LENGTHs" = listappend(evaluate("db1.#table_name#.LENGTHs"),columns.LENGTH[counter2] / 2);
				else
					"db1.#table_name#.LENGTHs" = listappend(evaluate("db1.#table_name#.LENGTHs"),columns.LENGTH[counter2]);
				
				if (columns.type_name[counter2] contains "identity")
					"db1.#table_name#.iden" = listappend(evaluate("db1.#table_name#.iden"),"Y");
				else 
					"db1.#table_name#.iden" = listappend(evaluate("db1.#table_name#.iden"),"N");
			}
			else
			{
				type_index = ListFindNoCase(db2_variables,columns.type_name[counter2]);
				if (type_index eq 2)
					"db1.#table_name#.types" = listappend(evaluate("db1.#table_name#.types"),7);
				else if (type_index)
					"db1.#table_name#.types" = listappend(evaluate("db1.#table_name#.types"),type_index);
				else
					"db1.#table_name#.types" = listappend(evaluate("db1.#table_name#.types"),999);
				"db1.#table_name#.LENGTHs" = listappend(evaluate("db1.#table_name#.LENGTHs"),columns.LENGTH[counter2]);
				"db1.#table_name#.iden" = listappend(evaluate("db1.#table_name#.iden"),columns.identity[counter2]);
			}
		}
	}
</cfscript>
<cfif attributes.db_type_2 is "mssql">
	<cfquery name="getTables" datasource="#db2.dsn#">
		EXEC sp_tables NULL, #db2.db#, #db2.dsn#, "'TABLE'"
	</cfquery>
<cfelseif attributes.db_type_2 is "db2">
	<cfquery name="getTables" datasource="#db2.dsn#">
		SELECT 
			TABNAME AS TABLE_NAME
		FROM 
			SYSCAT.TABLES
		WHERE
		<cfif attributes.db_type_2_1 eq 2>
			TABSCHEMA = '#db2.db#_DBO'
		<cfelseif attributes.db_type_2_1 eq 1>
			TABSCHEMA = '#db2.db#_DBO'
		<cfelseif attributes.db_type_2_1 eq 0>
			TABSCHEMA = 'DBO'
		</cfif>
	</cfquery>
<cfelse>
	<cf_get_lang dictionary_id='32815.Bilinmeyen Veritabanı'>! 
	<cfexit method="exittemplate">
</cfif>
<cfscript>
	db2.table_list = ValueList(getTables.table_name);
	for (counter1=1;counter1 lt (getTables.recordcount+1);counter1 = counter1 + 1)
		{
		table_name = getTables.table_name[counter1];
		"db2.#table_name#" = structnew();
		columns = getColumns(db_type : attributes.db_type_2, dsn_name : db2.dsn, table_name : table_name);
		"db2.#table_name#.columns" = "";
		"db2.#table_name#.types" = "";
		"db2.#table_name#.LENGTHs" = "";
		"db2.#table_name#.iden" ="";
		for (counter2=1; counter2 lt (columns.recordcount+1); counter2 = counter2 + 1)
			if ( ( (attributes.db_type_2 is "mssql") ) or (attributes.db_type_2 is "db2") )
			{
				"db2.#table_name#.columns" = listappend(evaluate("db2.#table_name#.columns"),columns.COLUMN_NAME[counter2]);
				if (attributes.db_type_2 is "mssql")
				{
					type_index = ListFindNoCase(mssql_variables,columns.type_name[counter2]);
					if (type_index eq 2) // int identity
						"db2.#table_name#.types" = listappend(evaluate("db2.#table_name#.types"),7);
					else if (type_index)
						"db2.#table_name#.types" = listappend(evaluate("db2.#table_name#.types"), type_index);
					else
						"db2.#table_name#.types" = listappend(evaluate("db2.#table_name#.types"),999);
					if ((attributes.db_chartype_1 eq 1) and ListContainsNoCase("1,5",type_index) )
						"db2.#table_name#.LENGTHs" = listappend(evaluate("db2.#table_name#.LENGTHs"),columns.LENGTH[counter2] / 2);
					else
						"db2.#table_name#.LENGTHs" = listappend(evaluate("db2.#table_name#.LENGTHs"),columns.LENGTH[counter2]);
	
					if (columns.type_name[counter2] contains "identity")
						"db2.#table_name#.iden" = listappend(evaluate("db2.#table_name#.iden"),"Y");
					else 
						"db2.#table_name#.iden" = listappend(evaluate("db2.#table_name#.iden"),"N");
				}
				else
				{
					type_index = ListFindNoCase(db2_variables,columns.type_name[counter2]);
					if (type_index eq 2)
						"db2.#table_name#.types" = listappend(evaluate("db2.#table_name#.types"),7);
					else if (type_index)
						"db2.#table_name#.types" = listappend(evaluate("db2.#table_name#.types"),type_index);
					else
						"db2.#table_name#.types" = listappend(evaluate("db2.#table_name#.types"),999);
					"db2.#table_name#.LENGTHs" = listappend(evaluate("db2.#table_name#.LENGTHs"),columns.LENGTH[counter2]);
					"db2.#table_name#.iden" = listappend(evaluate("db2.#table_name#.iden"),columns.identity[counter2]);
				}
			}
		}
</cfscript>

<!--- farkli tablolar --->
<cfset sql_code_1_1 = "">
<cfset sql_code_2_1 = "">
<cfset attributes.upgrade_dsn_1 = "">
<cfset attributes.upgrade_dsn_2 = "">
<cfoutput>
	<table width="800" align="center" cellspacing="0">
		<cfif listlen(listcompare(db1.table_list,db2.table_list)) or listlen(listcompare(db2.table_list,db1.table_list))>
			<tr>
				<td><b>#db1.db#</b>
					<cfif listlen(listcompare(db1.table_list,db2.table_list))>
						<cfset attributes.tablenames = listcompare(db1.table_list,db2.table_list)>
						<cfset attributes.newdsn = db1.dsn>
						<cfset attributes.upgrade_dsn = db2.dsn>
						<cfinclude template="db_diff_mssql_tables.cfm">
						<cfset sql_code_1_1 = sql_code>
						<cfset attributes.upgrade_dsn_1 = attributes.upgrade_dsn>
						<!--- &nbsp;&nbsp;&nbsp;<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_db_diff_mssql_tables&tablenames=#listcompare(db1.table_list,db2.table_list)#&newdsn=#db1.dsn#&upgrade_dsn=#db2.dsn#','project');"><font color="FF0000">Table Upgrade SQL</font></a> --->
					</cfif>
				</td>
				<td><b>#db2.db#</b>
					<cfif listlen(listcompare(db2.table_list,db1.table_list))>
						<cfset attributes.tablenames = listcompare(db2.table_list,db1.table_list)>
						<cfset attributes.newdsn = db2.dsn>
						<cfset attributes.upgrade_dsn = db1.dsn>
						<cfinclude template="db_diff_mssql_tables.cfm">
						<cfset sql_code_2_1 = sql_code>
						<cfset attributes.upgrade_dsn_2 = attributes.upgrade_dsn>
						<!--- &nbsp;&nbsp;&nbsp;<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_db_diff_mssql_tables&tablenames=#listcompare(db2.table_list,db1.table_list)#&newdsn=#db2.dsn#&upgrade_dsn=#db1.dsn#','project');"><font color="FF0000">Table Upgrade SQL</font></a> --->
					</cfif>
				</td>
			</tr>
		</cfif>
		<cfloop list="#listcompare(db1.table_list,db2.table_list)#" index="i">
			<tr>
				<td style="color : blue"><b>#i#</b></td>
				<td align="center"> X </td>
			</tr>
		</cfloop>
		<cfloop list="#listcompare(db2.table_list,db1.table_list)#" index="i">
			<tr>
				<td align="center"> X </td>
				<td style="color : blue"><b>#i#</b></td>
			</tr>
		</cfloop>
	</table>
</cfoutput>
<hr>
<!--- ortak tablolar --->
<table cellspacing="0" width="800" style="border-top: solid 1 black;border-left: solid 1 black;" align="center">
	<tr>
		<td style="font-size:14px;color:blue;" width="300">&nbsp;</td>
		<td>
			<table cellspacing="0" width="100%">
				<tr>
					<td width="50%" style="color:red"><cfoutput><b>#db1.db#</b></cfoutput></td>
					<td width="50%" style="color:red"><cfoutput><b>#db2.db#</b></cfoutput></td>
				</tr>
			</table>
		</td>
	</tr>
	<!---   diff_list1 : İlk Db de olup, ikincide olmayan alanlar 
			diff_list2 : İkinci Db de olup, ilk olmayan alanlar
			diff_list3 : İki Db de mevcut olan alanlar --->
	<cfset sql_code_1_2 = "">
	<cfset sql_code_2_2 = "">
	<cfloop list="#listcompare(db1.table_list,listcompare(db1.table_list,db2.table_list))#" index="i">
		<cfscript>
			diff_list1 = listsort(listcompare(evaluate("db1.#i#.columns"),evaluate("db2.#i#.columns")),"text");
			diff_list2 = listsort(listcompare(evaluate("db2.#i#.columns"),evaluate("db1.#i#.columns")),"text");
			diff_list3 = listsort(listcompare(evaluate("db1.#i#.columns"),diff_list1),"text");
			diff_list4 = "";
		</cfscript>
	
		<cfset show_diff_list3 = 0>
		<cfset show_diff_length_list3 = 0>
		<cfif len(listsort(diff_list3,"Text"))>
			<cfloop list="#diff_list3#" index="j">
				<cfset db1_counter = listfindnocase(evaluate("db1.#i#.columns"),j)>
				<cfset db2_counter = listfindnocase(evaluate("db2.#i#.columns"),j)>
	
				<cfif listgetat(evaluate("db1.#i#.types"),db1_counter) neq listgetat(evaluate("db2.#i#.types"),db2_counter)>
					<cfset show_diff_list3 = 1>
				<cfelse>
					<cfif ( listgetat(evaluate("db1.#i#.types"),db1_counter) eq 1 ) and ( listgetat(evaluate("db1.#i#.LENGTHs"),db1_counter) neq listgetat(evaluate("db2.#i#.LENGTHs"),db2_counter) )>
						<cfset show_diff_list3 = 1>
						<cfset show_diff_length_list3 = 1>
					<cfelseif listgetat(evaluate("db1.#i#.iden"),db1_counter) neq listgetat(evaluate("db2.#i#.iden"),db2_counter)>
						<cfset show_diff_list3 = 1>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		<cfset show_diff_list4 = 0>
		<cfset show_diff_length_list4 = 0>
		<cfif len(listsort(diff_list3,"Text"))>
			<cfloop list="#diff_list3#" index="j">
				<cfset db1_counter = listfindnocase(evaluate("db1.#i#.columns"),j)>
				<cfset db2_counter = listfindnocase(evaluate("db2.#i#.columns"),j)>
				<cfif listgetat(evaluate("db1.#i#.types"),db1_counter) eq 5 and listgetat(evaluate("db2.#i#.types"),db2_counter)  eq 1>
					<cfset show_diff_list4 = 1>
					<cfset show_diff_length_list4 = 1>
				</cfif>
			</cfloop>
		</cfif>
		<cfset show_diff_list5 = 0>
		<cfset show_diff_length_list5 = 0>
		<cfif len(listsort(diff_list3,"Text"))>
			<cfloop list="#diff_list3#" index="j">
				<cfset db1_counter = listfindnocase(evaluate("db1.#i#.columns"),j)>
				<cfset db2_counter = listfindnocase(evaluate("db2.#i#.columns"),j)>
				<cfif listgetat(evaluate("db1.#i#.types"),db1_counter) eq 4 and listgetat(evaluate("db2.#i#.types"),db2_counter)  eq 7>
					<cfset show_diff_list5 = 1>
					<cfset show_diff_length_list5 = 1>
				</cfif>
			</cfloop>
		</cfif>
		<cfif len(listsort(diff_list1,"Text")) or len(listsort(diff_list2,"Text")) or show_diff_list3>
			<!--- tablo adı --->
			<tr>
				<td style="font-size:12px;" valign="top">
					<cfoutput>#i#</cfoutput><!--- i Tablo isimlerini goruntuluyor --->
					<cfif len(listsort(diff_list1,"Text"))>
						<cfset attributes.tablename = i>
						<cfset attributes.columnnames = diff_list1>
						<cfset attributes.newdsn = db1.dsn>
						<cfset attributes.upgrade_dsn = db2.dsn>
						<cfinclude template="db_diff_mssql_columns.cfm">
						<cfset sql_code_1_2 = sql_code_1_2 & sql_code>
						<cfset attributes.upgrade_dsn_1 = attributes.upgrade_dsn>
					</cfif>
					<cfif len(listsort(diff_list2,"Text"))>							
						<cfset attributes.tablename = i>
						<cfset attributes.columnnames = diff_list2>
						<cfset attributes.newdsn = db2.dsn>
						<cfset attributes.upgrade_dsn = db1.dsn>
						<cfinclude template="db_diff_mssql_columns.cfm">
						<cfset sql_code_2_2 = sql_code_2_2 & sql_code>
						<cfset attributes.upgrade_dsn_2 = attributes.upgrade_dsn>
					</cfif>
					<!--- ayni kolonlarin nvarchar icin alan genislemesi FB & BK 20071115 --->
					<cfif show_diff_length_list3>	
						<cfset attributes.tablename = i>
						<cfset attributes.columnnames = diff_list3>
						<cfset attributes.newdsn = db1.dsn>
						<cfset attributes.upgrade_dsn = db2.dsn>
						<cfinclude template="db_diff_mssql_length_columns.cfm">
						<cfset sql_code_1_2 = sql_code_1_2 & sql_code>
						<cfset attributes.upgrade_dsn_1 = attributes.upgrade_dsn>
						<cfset attributes.upgrade_dsn_2 = attributes.newdsn>
					</cfif>
					<!--- nvarchar alanların ntext yapılması için eklendi sm20131105 --->
					<cfif show_diff_length_list4>	
						<cfset attributes.tablename = i>
						<cfset attributes.columnnames = diff_list3>
						<cfset attributes.newdsn = db1.dsn>
						<cfset attributes.upgrade_dsn = db2.dsn>
						<cfinclude template="db_diff_mssql_nvarchar_to_ntext.cfm">
						<cfset sql_code_1_2 = sql_code_1_2 & sql_code>
						<cfset attributes.upgrade_dsn_1 = attributes.upgrade_dsn>
						<cfset attributes.upgrade_dsn_2 = attributes.newdsn>
					</cfif>
					<!--- int alanların float yapılması için eklendi sm20131105 --->
					<cfif show_diff_length_list5>	
						<cfset attributes.tablename = i>
						<cfset attributes.columnnames = diff_list3>
						<cfset attributes.newdsn = db1.dsn>
						<cfset attributes.upgrade_dsn = db2.dsn>
						<cfinclude template="db_diff_mssql_int_to_float.cfm">
						<cfset sql_code_1_2 = sql_code_1_2 & sql_code>
						<cfset attributes.upgrade_dsn_1 = attributes.upgrade_dsn>
						<cfset attributes.upgrade_dsn_2 = attributes.newdsn>
					</cfif>
				</td>
				<td valign="top" style="padding : none;">
					<table width="100%" cellspacing="0" bgcolor="#FFFF66">
						<cfif len(listsort(diff_list1,"Text"))>
							<!--- db1 de yeni alan var --->
							<cfloop list="#diff_list1#" index="j">
								<cfset db1_counter = listfindnocase(evaluate("db1.#i#.columns"),j)>
								<tr>
									<cfoutput>#write_field(attributes.db_type_1,"db1",i,j)#</cfoutput>
									<td width="50%" align="center"> X </td>
								</tr>
							</cfloop>
						</cfif>
						<cfif len(listsort(diff_list2,"Text"))>
							<!--- db2 de yeni alan var --->
							<cfloop list="#diff_list2#" index="j">
								<cfset db2_counter = listfindnocase(evaluate("db2.#i#.columns"),j)>
								<tr>
									<td width="50%" align="center"> X </td>
									<cfoutput>#write_field(attributes.db_type_2,"db2",i,j)#</cfoutput>
								</tr>
							</cfloop>
						</cfif>
						<!--- iki farkli db de bulunan ayni tablolarin ayni alanlari --->
						<cfif len(listsort(diff_list3,"Text"))>
							<cfloop list="#diff_list3#" index="j">
								<cfset db1_counter = listfindnocase(evaluate("db1.#i#.columns"),j)>
								<cfset db2_counter = listfindnocase(evaluate("db2.#i#.columns"),j)>
								<!--- alan tipleri farklı --->
								<cfif listgetat(evaluate("db1.#i#.types"),db1_counter) neq listgetat(evaluate("db2.#i#.types"),db2_counter)>
									<tr>
										<cfoutput>#write_field(attributes.db_type_1,"db1",i,j)#</cfoutput>
										<cfoutput>#write_field(attributes.db_type_2,"db2",i,j)#</cfoutput>
									</tr>
								<!--- alan tipi ayni uzunluklari farkli --->
								<cfelse>
									<cfif (listgetat(evaluate("db1.#i#.types"),db1_counter) eq 1 ) and ( listgetat(evaluate("db1.#i#.lengths"),db1_counter) neq listgetat(evaluate("db2.#i#.lengths"),db2_counter))>
										<!--- sadece nvarchar uzunluk olarak karşılaştırılıyor --->
										<tr>
											<cfoutput>#write_field(attributes.db_type_1,"db1",i,j)#</cfoutput>
											<cfoutput>#write_field(attributes.db_type_2,"db2",i,j)#</cfoutput>
										</tr>
									<cfelseif listgetat(evaluate("db1.#i#.iden"),db1_counter) neq listgetat(evaluate("db2.#i#.iden"),db2_counter)>
										<tr>
											<cfoutput>#write_field(attributes.db_type_1,"db1",i,j)#</cfoutput>
											<cfoutput>#write_field(attributes.db_type_2,"db2",i,j)#</cfoutput>
										</tr>
									</cfif>
								</cfif>
							</cfloop>
						</cfif>
					</table>
				</td>
			</tr>
		</cfif>
	</cfloop>
</table>
<cfif isdefined("attributes.dsn_1") and isdefined("attributes.dsn_2")>
	<table width="800" align="center" cellspacing="0">
		<tr class="formbold">
			<td valign="top">
				<font color="FF0000">DSN:<cfoutput>#db1.dsn#</cfoutput> de <cf_get_lang dictionary_id='32817.oluşturulan SQL Kodu'></font>
				<form name="form_db_1" action="<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_db_diff_mssql" method="post">
					<cfoutput>
						<textarea cols="70" rows="40" name="sql_kod" id="sql_kod">#sql_code_1_1# #sql_code_1_2#</textarea>
						<cfif len(sql_code_1_1&sql_code_1_2)>
							<input type="hidden" name="dsn_1" id="dsn_1" value="#attributes.dsn_1#">
							<input type="hidden" name="dsn_2" id="dsn_2" value="#attributes.dsn_2#">
							<input type="hidden" name="db_1" id="db_1" value="#attributes.db_1#">
							<input type="hidden" name="db_2" id="db_2" value="#attributes.db_2#">
							<input type="hidden" name="db_type_1" id="db_type_1" value="#attributes.db_type_1#">
							<input type="hidden" name="db_type_2" id="db_type_2" value="#attributes.db_type_2#">
							<input type="hidden" name="db_chartype_1" id="db_chartype_1" value="#attributes.db_chartype_1#">
							<input type="hidden" name="db_chartype_2" id="db_chartype_2" value="#attributes.db_chartype_2#">
							<input type="hidden" name="db_type_1_1" id="db_type_1_1" value="#attributes.db_type_1_1#">
							<input type="hidden" name="db_type_2_1" id="db_type_2_1" value="#attributes.db_type_2_1#">
							<input type="hidden" name="upgrade_dsn" id="upgrade_dsn" value="#attributes.upgrade_dsn_1#">
							<cf_workcube_buttons is_upd='0' insert_info='#attributes.upgrade_dsn_1# de Çalıştır'>
						</cfif>
					</cfoutput>
				</form>
			</td>
			<td valign="top">
				<font color="FF0000">DSN:<cfoutput>#db2.dsn#</cfoutput> de <cf_get_lang dictionary_id='32817.oluşturulan SQL Kodu'></font>
				<form name="form_db_2" action="<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_db_diff_mssql" method="post">
					<cfoutput>
						<textarea cols="70" rows="40" name="sql_kod" id="sql_kod">#sql_code_2_1# #sql_code_2_2#</textarea>
						<cfif len(sql_code_2_1&sql_code_2_2)>
							<input type="hidden" name="dsn_1" id="dsn_1" value="#attributes.dsn_1#">
							<input type="hidden" name="dsn_2" id="dsn_2" value="#attributes.dsn_2#">
							<input type="hidden" name="db_1" id="db_1" value="#attributes.db_1#">
							<input type="hidden" name="db_2" id="db_2" value="#attributes.db_2#">
							<input type="hidden" name="db_type_1" id="db_type_1" value="#attributes.db_type_1#">
							<input type="hidden" name="db_type_2" id="db_type_2" value="#attributes.db_type_2#">
							<input type="hidden" name="db_chartype_1" id="db_chartype_1" value="#attributes.db_chartype_1#">
							<input type="hidden" name="db_chartype_2" id="db_chartype_2" value="#attributes.db_chartype_2#">
							<input type="hidden" name="db_type_1_1" id="db_type_1_1" value="#attributes.db_type_1_1#">
							<input type="hidden" name="db_type_2_1" id="db_type_2_1" value="#attributes.db_type_2_1#">
							<input type="hidden" name="upgrade_dsn" id="upgrade_dsn" value="#attributes.upgrade_dsn_2#">
							<cf_workcube_buttons is_upd='0' insert_info='#attributes.upgrade_dsn_2# de Çalıştır'>
						</cfif>
					</cfoutput>
				</form>
			</td>
		</tr>
	</table>
</cfif>



