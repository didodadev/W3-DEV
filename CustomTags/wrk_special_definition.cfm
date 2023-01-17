<!--- ayarlardaki özel tanımlar içindir, şuanlık 4 ana parametresi vardır.. Tahsilat Tipi-Ödeme Tipi-Servis Tipi - Yazışma 
bunların altındaki tanımlar zaten çoğaltılmaktadır.. 20100125--->
<cfparam name="attributes.width_info" default="180">
<cfparam name="attributes.type_info" default=""><!--- Tahsilat Tipi-Ödeme Tipi-Servis Tipi - Yazışma --->
<cfparam name="attributes.field_id" default="special_definition_id">
<cfparam name="attributes.selected_value" default="">
<cfparam name="attributes.list_filter_info" default=""><!--- liste sayfalarındaki filtreleme için --->
<cfquery name="GET_SPECIAL_DEFINITION" datasource="#CALLER.DSN#">
	SELECT SPECIAL_DEFINITION_ID,#caller.dsn#.Get_Dynamic_Language(SPECIAL_DEFINITION_ID,'#session.ep.language#','SETUP_SPECIAL_DEFINITION','SPECIAL_DEFINITION',NULL,NULL,SPECIAL_DEFINITION) AS SPECIAL_DEFINITION,SPECIAL_DEFINITION_TYPE FROM SETUP_SPECIAL_DEFINITION <cfif len(attributes.type_info)>WHERE SPECIAL_DEFINITION_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type_info#"></cfif>
</cfquery>
<cfif isDefined("attributes.list_filter_info") and len(attributes.list_filter_info)><!--- liste sayfalarındaki filtreleme icin --->
		<cfoutput>
        	<select name="#attributes.field_id#" id="#attributes.field_id#" style="width:#attributes.width_info#px">
            <option value="">#caller.getLang('main',433)#/#caller.getLang('main',1516)#</option> <!---Tahsilat/Ödeme Tipi--->
            <option value="-1" <cfif len(attributes.selected_value) and attributes.selected_value eq "-1">selected</cfif>>#caller.getLang('main',1517)#</option><!---Tahsilat Tipi--->
		</cfoutput>
		<cfoutput query="get_special_definition">
			<cfif special_definition_type eq 1>
				<option value="#special_definition_id#" <cfif len(attributes.selected_value) and attributes.selected_value eq special_definition_id>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#special_definition#</option>
			</cfif>
		</cfoutput>
		<option value="-2" <cfif len(attributes.selected_value) and attributes.selected_value eq "-2">selected</cfif>><cfoutput>#caller.getLang('main',1516)#</cfoutput></option>
		<cfoutput query="get_special_definition">
			<cfif special_definition_type eq 2>
				<option value="#special_definition_id#" <cfif len(attributes.selected_value) and attributes.selected_value eq special_definition_id>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#special_definition#</option>
			</cfif>
		</cfoutput>
	</select>
<cfelse>
	<cfoutput><select name="#attributes.field_id#" id="#attributes.field_id#" style="width:#attributes.width_info#px">
		<option value="" selected>#caller.getLang('main',322)#</option></cfoutput><!--- Seçiniz --->
		<cfoutput query="get_special_definition">
			<option value="#special_definition_id#" <cfif len(attributes.selected_value) and attributes.selected_value eq special_definition_id>selected</cfif>>#special_definition#</option>
		</cfoutput>
	</select>
</cfif>
