<cfif not IsDefined("Cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>
	<cfset cookie_name_ = createUUID()>
	<cfcookie name="wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#" value="#cookie_name_#" expires="1">
</cfif>
<cfparam name="attributes.type_id" default="-7">
<cfquery name="GET_VALUES" datasource="#DSN3#">
	SELECT
		*
	FROM
		ORDER_INFO_PLUS
	WHERE
		ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
</cfquery>
<cfquery name="GET_LABELS" datasource="#DSN3#">
	SELECT
		*
	FROM
		SETUP_PRO_INFO_PLUS_NAMES
	WHERE	
		OWNER_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type_id#">
</cfquery>
<cfif GET_LABELS.RECORDCOUNT>
<table id="info_table">
  <tr>
	<td valign="top">
		<table>
		  <input type="hidden" name="cookie_name" id="cookie_name" value="<cfoutput>#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#</cfoutput>">
		  <cfloop index="i" from="1" to="7">
			<tr>
			  <td width="150" class="txtbold">
				<cfif len(Evaluate("GET_LABELS.PROPERTY#i#_NAME"))>
				  <cfoutput>#Evaluate("GET_LABELS.PROPERTY#i#_NAME")#</cfoutput>
				  <cfif Evaluate("GET_LABELS.PROPERTY#i#_REQ") eq 1>*</cfif>
				</cfif>
			  </td>
			  <td width="175">
				<cfif len(Evaluate("GET_LABELS.PROPERTY#i#_NAME"))>
				  <!--- <input type="text" name="<cfoutput>PROPERTY#i#</cfoutput>"  <cfif GET_VALUES.recordcount >value="<cfoutput>#Evaluate("GET_VALUES.PROPERTY#i#")#</cfoutput>"</cfif> style="width:250px;"> --->
				  <cfif GET_VALUES.recordcount ><cfoutput>#Evaluate("GET_VALUES.PROPERTY#i#")#</cfoutput></cfif>
				</cfif>
			  </td>
			  <td width="150" class="txtbold">
				<cfset j=i+7>
				<cfif len(Evaluate("GET_LABELS.PROPERTY#j#_NAME"))>
				  <cfoutput>#Evaluate("GET_LABELS.PROPERTY#j#_NAME")#</cfoutput>
				  <cfif Evaluate("GET_LABELS.PROPERTY#j#_REQ") eq 1>*</cfif>
				</cfif>
			  </td>
			  <td>
				<cfif len(Evaluate("GET_LABELS.PROPERTY#j#_NAME"))>
				  <!--- <input type="text" name="<cfoutput>PROPERTY#j#</cfoutput>" <cfif GET_VALUES.recordcount >value="<cfoutput>#Evaluate("GET_VALUES.PROPERTY#j#")#</cfoutput>"</cfif>  style="width:250px;"  > --->
				  <cfif GET_VALUES.recordcount ><cfoutput>#Evaluate("GET_VALUES.PROPERTY#j#")#</cfoutput></cfif>
				</cfif>
			  </td>
			</tr>
		  </cfloop>
		  <cfloop index="i" from="0" to="4" step="2">
			<tr>
			  <td>
				<cfset st = i+15>
				<cfif len(Evaluate("GET_LABELS.PROPERTY#st#_NAME"))>
				  <cfoutput>#Evaluate("GET_LABELS.PROPERTY#st#_NAME")#</cfoutput>
				  <cfif Evaluate("GET_LABELS.PROPERTY#st#_REQ") eq 1>*</cfif>
				</cfif>
				
			  </td>
			  <td>
				<cfif len(Evaluate("GET_LABELS.PROPERTY#st#_NAME"))> 
				  <textarea name="<cfoutput>PROPERTY#st#</cfoutput>" id="<cfoutput>PROPERTY#st#</cfoutput>" style="width:150;height:50;"><cfif GET_VALUES.recordcount ><cfoutput>#Evaluate("GET_VALUES.PROPERTY#st#")#</cfoutput></cfif></textarea>
				 </cfif> 
			  </td>
			  <td>
				<cfset j = i+15+1>
			   <cfset j=st+1>
				<cfif len(Evaluate("GET_LABELS.PROPERTY#j#_NAME")) >
				  <cfoutput>#Evaluate("GET_LABELS.PROPERTY#j#_NAME")#</cfoutput>
				  <cfif Evaluate("GET_LABELS.PROPERTY#j#_REQ") eq 1>*</cfif>
				 </cfif> 
			  </td>
			  <td>
				<cfif len(Evaluate("GET_LABELS.PROPERTY#j#_NAME")) > 
				  <textarea name="<cfoutput>PROPERTY#j#</cfoutput>" id="<cfoutput>PROPERTY#j#</cfoutput>" style="width:150;height:50;"><cfif GET_VALUES.recordcount><cfoutput>#Evaluate("GET_VALUES.PROPERTY#j#")#</cfoutput></cfif></textarea>
				 </cfif> 
			  </td>
			</tr>
		  </cfloop>
		</table>
	</td>
  </tr>
</table>
</cfif>
<br/>
