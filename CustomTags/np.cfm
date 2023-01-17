<!--- 
<cf_np tablename="offer"             'required table name..
	   primary_key = "offer_id"	     'required primary_field
	   where="offer_status=0"		 'optional	 
	   relation="table1.id1 = table2.id1"		 'optional	 
	   oby="table1.id1, table2.id2"	 'optional	 
	   dsn_var ="dsn2"               'optional
	   pointer="oid=100,deg=1,deg=2" 'required -- first element is primary var
	   >
 --->
<cftry>
	<cfif isdefined('attributes.dsn_var')>
    	<cfset dsn_var = caller['#attributes.dsn_var#']>
    <cfelse>
    	<cfset dsn_var = application.systemParam.systemParam().dsn>
    </cfif>
<cfcatch><!--- catalystHeader custom tag'inde de çağrılıyor. Bu yüzden catch kontrolü eklendi.  --->
	<cfif isdefined('attributes.dsn_var')>
    	<cfset dsn_var = caller.caller['#attributes.dsn_var#']>
    <cfelse>
    	<cfset dsn_var = application.systemParam.systemParam().dsn>
    </cfif>
</cfcatch>
</cftry>
<cfscript>		

tablename = UCASE(attributes.tablename);
primary_key = UCASE(attributes.primary_key);	

if (isdefined('attributes.where'))
	where = UCASE(attributes.where);

pointer = attributes.pointer;
go_addr = listgetat(query_string, 1, '&');
condition_ = listgetat(pointer, 1, ',');
condition = listgetat(condition_, 2, '=');
var_name = listgetat(pointer, 1, '=');
str_ = len(listgetat(pointer, 1, ','));
mtx = listlen(pointer, ',') - 1;
str_n = len(pointer) - str_;
str_ = mid(pointer, str_ + mtx, str_n);
str_ = ReReplace(str_, ',', '&', 'ALL');
var_name = listgetat(pointer, 1, '=');
// ERK 20030911 PRIMARY KEY TABLE1.ID1 OLUNCA ÇAKMAMASI İÇİN EKLENDİ
if (listlen(var_name,'.')) var_name = listlast(var_name,'.');
</cfscript>

<cfquery name="SHOW_END" datasource="#DSN_VAR#">
	SELECT MAX(#PRIMARY_KEY#) AS MAX_OFF, MIN(#PRIMARY_KEY#) AS MIN_OFF FROM #TABLENAME#
	<cfif isdefined("WHERE")>WHERE #PRESERVESINGLEQUOTES(WHERE)#</cfif>
</cfquery>

<cfquery name="SHOW_NP" datasource="#DSN_VAR#">
	SELECT
		DISTINCT #PRIMARY_KEY# AS ID
	<cfif isdefined("attributes.OBY")>
			,#ucase(PRESERVESINGLEQUOTES(attributes.OBY))#
	</cfif>
	FROM
		#TABLENAME#
	WHERE 
		<cfif isdefined("attributes.relation")>
			(#ucase(PRESERVESINGLEQUOTES(attributes.relation))#) AND
		</cfif>
			(	
		 		#PRIMARY_KEY# = (SELECT MAX(#PRIMARY_KEY#) FROM #TABLENAME# WHERE #PRIMARY_KEY#  < #CONDITION# <cfif isdefined("WHERE")>AND #PRESERVESINGLEQUOTES(WHERE)#</cfif>) OR
	  	  		#PRIMARY_KEY# =	(SELECT MIN(#PRIMARY_KEY#) FROM #TABLENAME# WHERE #PRIMARY_KEY#  > #CONDITION# <cfif isdefined("WHERE")>AND #PRESERVESINGLEQUOTES(WHERE)#</cfif>)
			)
	<cfif isdefined("attributes.OBY")>
		ORDER BY 
			#ucase(PRESERVESINGLEQUOTES(attributes.OBY))#
	</cfif>
</cfquery>
<cfif isdefined("caller.tabMenuData")>
	<!---
	<cfif isdefined("caller.attributes.event")>
    	<cfset go_addr = go_addr & '&event='& caller.attributes.event>
    </cfif>
    --->
    <cfset caller.dataLink1 = '#request.self#?#go_addr#&#var_name#=#show_np.ID[1]##str_#'>
    <cfif show_np.recordcount eq 1 and condition lte show_np.ID>
        <cfset caller.dataLinkStatus1 = false>
    <cfelse>
        <cfset caller.dataLinkStatus1 = true>
    </cfif>
    <cfset caller.dataLinkName1 = 'prev'>
    <cfif show_np.recordcount eq 1>
        <cfset strDet = '#show_np.ID[1]#'>
    <cfelse>
        <cfset strDet = '#show_np.ID[2]#'>
    </cfif>
    <cfset caller.dataLink2 = '#request.self#?#go_addr#&#var_name#=#strDet##str_#'>
    <cfset caller.dataLinkName2 = 'next'>
    <cfif show_np.recordcount eq 1 and condition gte show_np.ID>
    	<cfset caller.dataLinkStatus2 = false>
    <cfelse>
    	<cfset caller.dataLinkStatus2 = true>
    </cfif>
<cfelse>
	<cfoutput>
        <cfif condition neq show_end.min_off><li><a href="#request.self#?#go_addr#&#var_name#=#show_end.min_off##str_#"><i class="fa fa-step-backward" title="#caller.getLang('','',57470)#" alt="#caller.getLang('','',57470)#"></i></a></li></cfif>
        <cfif condition neq show_end.min_off><li><a href="#request.self#?#go_addr#&#var_name#=#show_np.ID[1]##str_#"><i class="fa fa-caret-left" title="#caller.getLang('','','58470')#" alt="#caller.getLang('','','58470')#"></i></a></li></cfif>
        <cfif condition neq show_end.max_off><li><a href="#request.self#?#go_addr#&#var_name#=<cfif show_np.recordcount eq 1>#show_np.ID[1]#<cfelse>#show_np.ID[2]#</cfif>#str_#"><i class="fa fa-caret-right" alt="#caller.getLang('','','58471')#" title="#caller.getLang('','','58471')#"></i></a></li></cfif>
        <cfif condition neq show_end.max_off><li><a href="#request.self#?#go_addr#&#var_name#=#show_end.max_off##str_#"><i class="fa fa-step-forward"  alt="#caller.getLang('','',57469)#" title="#caller.getLang('','',57469)#"></i></a></li></cfif>
    </cfoutput>
</cfif>
