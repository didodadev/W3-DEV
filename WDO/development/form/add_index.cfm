<cfquery name="get_index_type" datasource="#attributes.DB_NAME#">
	SELECT type_desc,is_unique FROM sys.indexes WHERE name = '#attributes.index_name#'	
</cfquery>
<CFSTOREDPROC PROCEDURE="sp_helpindex2" DATASOURCE="#attributes.DB_NAME#">
  <CFPROCPARAM  
    VALUE="#attributes.OBJECT_NAME#" 
    CFSQLTYPE="cf_sql_char">
	<cfprocresult name="result">
</CFSTOREDPROC>
<cfoutput query="result">
	<cfif index_name  is attributes.index_name>
		<cf_popup_box title="#attributes.index_name#">
			<table align="left" width="100%" height="100%">
				<tr>
					<td>
						<textarea style="width:100%; height:290px; border:0px;"  onclick="this.select();" readonly="readonly">
							IF EXISTS (SELECT name FROM sys.indexes WHERE name = N'#index_name#')
								BEGIN   
									PRINT('INDEX MEVCUT');
								END	
							ELSE
								BEGIN
							CREATE <cfif #get_index_type.is_unique# eq 1>UNIQUE</cfif> #get_index_type.type_desc# INDEX #index_name# ON  #attributes.OBJECT_NAME# (#attributes.index_keys#)<cfif len(included_columns)>	INCLUDE (#included_columns#)</cfif>
								END
						</textarea>	
					</td>		
				</tr>
			</table>
		</cf_popup_box>
	</cfif>	
</cfoutput>

