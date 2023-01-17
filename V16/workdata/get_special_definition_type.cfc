<cfcomponent>
    <cffunction name="getComponentFunction">
    <cfset special_definition_types = QueryNew("SPECIAL_DEFINITION_TYPE_ID,SPECIAL_DEFINITION_NAME","Integer,VarChar")>
		<cfscript>
			QueryAddRow(special_definition_types,1);
			QuerySetCell(special_definition_types,"SPECIAL_DEFINITION_NAME","Tahsilat",1);
			QuerySetCell(special_definition_types,"SPECIAL_DEFINITION_TYPE_ID",'1',1);
			
			QueryAddRow(special_definition_types,1);
			QuerySetCell(special_definition_types,"SPECIAL_DEFINITION_NAME","Ödeme",2);
			QuerySetCell(special_definition_types,"SPECIAL_DEFINITION_TYPE_ID",'2',2);
			
			QueryAddRow(special_definition_types,1);
			QuerySetCell(special_definition_types,"SPECIAL_DEFINITION_NAME","Servis",3);
			QuerySetCell(special_definition_types,"SPECIAL_DEFINITION_TYPE_ID",'3',3);
		
			QueryAddRow(special_definition_types,1);
			QuerySetCell(special_definition_types,"SPECIAL_DEFINITION_NAME","Yazışma",4);
			QuerySetCell(special_definition_types,"SPECIAL_DEFINITION_TYPE_ID",'4',4);
			
			QueryAddRow(special_definition_types,1);
			QuerySetCell(special_definition_types,"SPECIAL_DEFINITION_NAME","Etkileşim",5);
			QuerySetCell(special_definition_types,"SPECIAL_DEFINITION_TYPE_ID",'5',5);
			
			QueryAddRow(special_definition_types,1);
			QuerySetCell(special_definition_types,"SPECIAL_DEFINITION_NAME","Proje",6);
			QuerySetCell(special_definition_types,"SPECIAL_DEFINITION_TYPE_ID",'6',6);
			
			QueryAddRow(special_definition_types,1);
			QuerySetCell(special_definition_types,"SPECIAL_DEFINITION_NAME","İş",7);
			QuerySetCell(special_definition_types,"SPECIAL_DEFINITION_TYPE_ID",'7',7);
			
			QueryAddRow(special_definition_types,1);
			QuerySetCell(special_definition_types,"SPECIAL_DEFINITION_NAME","Forum",8);
			QuerySetCell(special_definition_types,"SPECIAL_DEFINITION_TYPE_ID",'8',8);
			
			QueryAddRow(special_definition_types,1);
			QuerySetCell(special_definition_types,"SPECIAL_DEFINITION_NAME","Kurumsal Üye",9);
			QuerySetCell(special_definition_types,"SPECIAL_DEFINITION_TYPE_ID",'9',9);
			
			QueryAddRow(special_definition_types,1);
			QuerySetCell(special_definition_types,"SPECIAL_DEFINITION_NAME","Bireysel Üye",10);
			QuerySetCell(special_definition_types,"SPECIAL_DEFINITION_TYPE_ID",'10',10);
			
			QueryAddRow(special_definition_types,1);
			QuerySetCell(special_definition_types,"SPECIAL_DEFINITION_NAME","Disiplin İşlemleri",11);
			QuerySetCell(special_definition_types,"SPECIAL_DEFINITION_TYPE_ID",'11',11);
			
			QueryAddRow(special_definition_types,1);
			QuerySetCell(special_definition_types,"SPECIAL_DEFINITION_NAME","Call Center-Başvuru",12);
			QuerySetCell(special_definition_types,"SPECIAL_DEFINITION_TYPE_ID",'12',12);
        </cfscript>	 
		<cfquery name="GET_SPECIAL_DEFINITION_TYPE" dbtype="query">
			SELECT * FROM special_definition_types
		</cfquery>
	  <cfreturn GET_SPECIAL_DEFINITION_TYPE>
    </cffunction>
</cfcomponent>
