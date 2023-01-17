<!--- kolon bilgilerinin cekildigi query--->
<cfquery name="get_column_property" datasource="#dsn#">
	SELECT * FROM WRK_COLUMN_INFORMATION WHERE TABLE_ID = #attributes.TABLE_ID#
</cfquery>
<!--- kolon bilgilerinin cekildigi query--->

<!---Tablo bilgisinin cekildigi query---->
<cfquery datasource="#dsn#" name="text_info">
	SELECT TABLE_INFO,OBJECT_NAME,OBJECT_ID,DB_NAME,STATUS,TYPE,VERSION,TABLE_INFO_ENG FROM WRK_OBJECT_INFORMATION WHERE OBJECT_ID=#attributes.TABLE_ID#
</cfquery>
<!---Tablo bilgisinin Çekildiği query---->

<!---Index bilgisinin çekildiği query---->
<CFSTOREDPROC PROCEDURE="sp_helpindex2" DATASOURCE="#text_info.DB_NAME#">
  <CFPROCPARAM  
    VALUE="#text_info.OBJECT_NAME#" 
    CFSQLTYPE="cf_sql_char">
	<cfprocresult name="result">
</CFSTOREDPROC>
<!---Index bilgisinin Çekildiği query---->

<!---History tablosunun çekildiği query---->
<cfquery datasource="#dsn#" name="get_history_table">
	SELECT HISTORY_TABLE_NAME FROM WRK_TABLE_HISTORY_INFORMATION WHERE MAIN_TABLE_NAME='#text_info.OBJECT_NAME#' 
</cfquery>
<!---Hıstory Tablosunun çekildiği query---->

<!---kolon ilişkilerinin çekildiği query---->
<cfquery datasource="#dsn#" name="get_relational_column">
SELECT 
	RELATION_TABLE_NAME AS TABLE_NAME,
	RELATION_COLUMN_NAME AS COLUMN_NAME ,
	RELATION_COLUMN_DATA_TYPE AS DATA_TYPE,
	RELATION_COLUMN_LENGTH AS COLUMN_LENGTH
FROM 
	WRK_COLUMN_RELATION 
WHERE 
	MAIN_TABLE_NAME='#text_info.OBJECT_NAME#'
UNION
SELECT 
	MAIN_TABLE_NAME AS TABLE_NAME,
	MAIN_COLUMN_NAME AS COLUMN_NAME,
	MAIN_COLUMN_DATA_TYPE AS DATA_TYPE,
	MAIN_COLUMN_LENGTH AS COLUMN_LENGTH
FROM 
	WRK_COLUMN_RELATION 
WHERE 
	RELATION_TABLE_NAME='#text_info.OBJECT_NAME#'
</cfquery>
<!---kolon ilişkilerinin çekildiği query---->


<!---constraintlerin çekildiği query----> 
<cfquery datasource="#text_info.DB_NAME#" name="get_constraint">
Select 
		SysObjects.[Name] As CONSTRAINT_NAME ,
		Tab.[Name] as TABLE_NAME,
		Col.[Name] As COLUMN_NAME
From 
		SysObjects Inner Join (Select Name,ID From SysObjects Where XType = 'U') As Tab
		On Tab.ID= Sysobjects.[Parent_Obj] 
		Inner Join sysconstraints On sysconstraints.Constid = Sysobjects.[ID] 
		Inner Join SysColumns Col On Col.ColID = sysconstraints.ColID And Col.ID = Tab.ID
WHERE
	 Tab.Name='#text_info.OBJECT_NAME#'
</cfquery>

<!---constraintlerinin çekildiği query i---->


<cfsavecontent variable="veri">
	<cfoutput>
		<cfloop query="get_column_property">
			<cfquery datasource="#text_info.DB_NAME#" name="check_identity">
				SELECT COLUMNPROPERTY(OBJECT_ID('#TABLE_NAME#'),'#COLUMN_NAME#','IsIdentity') AS 'CHECK'
			</cfquery>
			<cfif len(COLUMN_NAME)>#COLUMN_NAME#</cfif>
			<cfif len(DATA_TYPE)> #DATA_TYPE#</cfif>
			<cfif len(MAXIMUM_LENGTH)>(#MAXIMUM_LENGTH#)</cfif>
			<cfif len(IS_NULL) and IS_NULL is 'YES'> NULL<cfelse> NOT NULL</cfif>
			<cfif len(COLUMN_DEFAULT)>DEFAULT #COLUMN_DEFAULT#</cfif>
			<cfif (check_identity.CHECK eq 1)>IDENTITY (1,1)</cfif>, 	
		</cfloop>
	</cfoutput>
</cfsavecontent>
<cfset veri=trim(tostring(veri))>
<cfset kont=left(tostring(veri),len(veri)-1)>
<!---Tablo ilişkilerinin çekildiği query---->
	<cfquery datasource="#dsn#" name="get_relation">
		SELECT 
			RELATIONSHIP_ID,
			PARENT_COLUMN_ID,
			PRIMARY_KEY_TABLE_NAME AS ANA_TABLO,
			PRIMARY_KEY_COLUMN_NAME AS PRIMARY_KEY,
			FOREIGN_KEY_TABLE_NAME AS YAVRU_TABLO,
			FOREIGN_KEY_COLUMN_NAME AS FOREIGN_KEY,
			CHILD_COLUMN_ID 
		FROM 
			WRK_TABLE_RELATION_SHIP 
		WHERE 
			PRIMARY_KEY_TABLE_NAME='#text_info.OBJECT_NAME#'
		UNION
		SELECT 
			RELATIONSHIP_ID,
			PARENT_COLUMN_ID,
			PRIMARY_KEY_TABLE_NAME AS ANA_TABLO,
			PRIMARY_KEY_COLUMN_NAME AS PRIMARY_KEY,
			FOREIGN_KEY_TABLE_NAME AS YAVRU_TABLO,
			FOREIGN_KEY_COLUMN_NAME AS FOREIGN_KEY,
			CHILD_COLUMN_ID 
		FROM 
			WRK_TABLE_RELATION_SHIP 
		WHERE 
			FOREIGN_KEY_TABLE_NAME='#text_info.OBJECT_NAME#'
	</cfquery> 
<!---Tablo ilişkilerinin çekildiği query---->
<cfparam name="type" default="">
<!---İndexler--->
<cfif attributes.type eq 1>
    <table id="tbl_index" name="tbl_index" class="ajax_list">	
        <thead>								
            <tr>
                <th>Index Name</th>
                <th>&nbsp;&nbsp;</th>
                <th>Index Column</th>
            </tr>	
        </thead>
        <tbody>
            <cfif isdefined("result")>
                <cfoutput query="result">
                    <tr>
                        <td><a href="javascript://" onclick="javascript:windowopen('#request.self#?fuseaction=dev.popup_add_index&index_name=#index_name#&db_name=#text_info.DB_NAME#&object_name=#text_info.OBJECT_NAME#&index_keys=#index_keys#','small')" class="tableyazi">#index_name#</a></td>
                        <td>&nbsp;&nbsp;</td>
                        <td>#index_keys#</td>
                    </tr>
                </cfoutput>
            </cfif>
        </tbody>
    </table>
<!---Constraints--->
<cfelseif attributes.type eq 2>
    <table class="ajax_list">
        <thead>
            <tr>
                <th>Column Name</th>
                <th>Constraint Name</th>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="get_constraint">
                <tr>
                    <td>#CONSTRAINT_NAME#</td>
                    <td>#COLUMN_NAME#</td>
                </tr>
            </cfoutput>
        </tbody>
    </table>
<!---History Table--->   	
<cfelseif attributes.type eq 3>
    <table class="ajax_list">
        <thead>
            <tr>
                <th>History Table Name</th>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="get_history_table">
                <tr>
                    <td>#HISTORY_TABLE_NAME#</td>
                </tr>
            </cfoutput>
        </tbody>
    </table>
<!---Column Relation--->
<cfelseif attributes.type eq 4>
    <table class="ajax_list">
        <thead>
            <tr>
                <th>Table Name</th>
                <th>Column Name</th>
                <th>Data Type</th>
                <th>Length</th>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="get_relational_column">
                <tr>
                    <td>#TABLE_NAME#</td>
                    <td>#COLUMN_NAME#</td>
                    <td>#DATA_TYPE#</td>
                    <td>#COLUMN_LENGTH#</td>
                </tr>
            </cfoutput>
        </tbody>
    </table>
<!---Alter Table--->    
<cfelseif attributes.type eq 5>
    <table width="100%">
        <tr>
            <td><textarea name="alter_text" id="alter_text" style="width:99%;height:100px; border:none;" onclick="this.select();"></textarea></td>
        </tr>
    </table>
<!---CREATE TABLE--->    
<cfelseif attributes.type eq 6>
    <table width="100%">
        <tr>
            <td>
                <textarea name="create_text" id="create_text"  style="width:99%;height:100px; border:none;" readonly="readonly" onclick="this.select();">
                    <cfoutput>
                        IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='#text_info.OBJECT_NAME#')
                        BEGIN 
                        CREATE TABLE #text_info.OBJECT_NAME# (#kont#) 
                        END 
                        ELSE 
                        BEGIN 
                        PRINT 'TABLO MEVCUT' 
                        END
                    </cfoutput>	
                </textarea>
            </td>
        </tr>	
    </table>
<!---İlişkili Tablolar---> 
<cfelseif attributes.type eq 7>   
    <table id="tbl_to_fuseactions" name="tbl_to_fuseactions" class="medium_list">
        <thead>
            <tr>
                <th>Primary Key</th>
                <th>Parent</th>
                <th>Child</th>
                <th>Foreign Key</th>
                <th>&nbsp;</th>
            </tr>
        </thead>
        <tbody>
            <cfif get_relation.recordcount>
                <cfoutput query="get_relation">
                    <tr>
                        <td>#ANA_TABLO#</td>
                        <td>#PRIMARY_KEY#</td>
                        <td>#YAVRU_TABLO#</td>
                        <td>#FOREIGN_KEY#</td>
                            <cfsavecontent variable="del_pro">İlişkiyi Siliyorsunuz! Emin misiniz?</cfsavecontent>
                        <td><a href="javascript://" onClick="javascript:if(confirm('#del_pro#')) windowopen('#request.self#?fuseaction=dev.emptypopup_del_relationship&relation_id=#relationship_id#','small'); else return false;"><img src="/images/delete_list.gif" border="0"></a></td>
                    </tr>
                </cfoutput>
            </cfif>
        </tbody>
    </table> 
</cfif>
