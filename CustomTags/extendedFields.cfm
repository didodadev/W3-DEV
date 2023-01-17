<cfparam name="attributes.actionId" default="">
<cfparam name="attributes.sqlOperation" default="0">
<cfparam name="attributes.mainTableAlias" default="">
<cfparam name="attributes.selectClause" default="0">
<cfparam name="attributes.whereClause" default="0">
<cfparam name="attributes.type" default="0"><!--- 0:add,upd ; 1:list --->
<cfif thisTag.executionMode eq "start">
	<cfif attributes.type eq 0>
        <cfparam name="attributes.fuseact" default="#caller.attributes.fuseaction#">
        <cfset attributes.dataSourceName = caller.WOStruct['#caller.attributes.fuseaction#']['systemObject']['dataSourceName']>
        <cfquery name="GET_FIELDS" datasource="#attributes.dataSourceName#">
            SELECT
                EXTEND_PAGE_ID,
                CONTROLLER_NAME,
                EVENT_LIST,
                FIELD_TYPE,
                LABEL,
                REQURITY,
                SIZE,
                FIELD_ID,
                MIN_LENGTH,
                MAX_LENGTH,
                DESCRIPTION,
                BLANK_SPACE,
                OPTION_CHECKED_LIST,
                OPTION_VALUE_LIST,
                OPTION_LABEL_LIST,
                MULTIPLE,
                TABLE_NAME,
                IDENTITY_COLUMN_NAME,
                DATASOURCE_NAME,
                COMPANY_ID_LIST,
                PERIOD_ID_LIST
            FROM
                #caller.dsn_alias#.EXTENDED_FIELDS
            WHERE
                CONTROLLER_NAME = '#attributes.controllerFileName#' AND
                <cfif attributes.sqlOperation eq 0>
                    EVENT_LIST = '#caller.woStruct['#caller.attributes.fuseaction#']['systemObject']['pageExtendedEventList']#' AND
                </cfif>
                COMPANY_ID_LIST = #session.ep.company_id# AND
                PERIOD_ID_LIST = #session.ep.period_id#
        </cfquery>
        <cfset fieldList = valuelist(GET_FIELDS.FIELD_ID)>
        <cfif len(attributes.actionId) and attributes.sqlOperation eq 0 and GET_FIELDS.recordcount>
            <cfquery name="GET_EXTENDED_VALUES" datasource="#attributes.dataSourceName#">
                SELECT #fieldList# FROM #caller.woStruct['#attributes.fuseact#']['systemObject']['pageTableName']# WHERE #GET_FIELDS.IDENTITY_COLUMN_NAME# = #attributes.actionId#
            </cfquery>
        <cfelse>
            <cfset GET_EXTENDED_VALUES.recordcount = 0>
        </cfif>
        <cfif attributes.sqlOperation eq 0>
            <cfif GET_FIELDS.recordcount>
                <div class="row hide" type="extendedFields">
                    <cfoutput query="GET_FIELDS">
                        <div class="form-group" id="item-#FIELD_ID#">
                            <label class="col col-4 col-sm-12">#LABEL#</label>
                            <div class="col col-8 col-sm-12">
                                <cfif FIELD_TYPE is 'text'>
                                     <input type="text" name="#FIELD_ID#" id="#FIELD_ID#" <cfif len(DESCRIPTION)>placeholder="#DESCRIPTION#" </cfif><cfif len(MAX_LENGTH)>maxlength="#MAX_LENGTH#" </cfif><cfif REQURITY>required="required" </cfif><cfif len(SIZE)>class="#SIZE#" </cfif><cfif GET_EXTENDED_VALUES.recordcount>value="#evaluate('GET_EXTENDED_VALUES.#FIELD_ID#')#" </cfif>/>
                                <cfelseif FIELD_TYPE is 'paragraph'>
                                     <textarea name="#FIELD_ID#" <cfif len(DESCRIPTION)>placeholder="#DESCRIPTION#" </cfif><cfif len(MAX_LENGTH)>maxlength="#MAX_LENGTH#" </cfif><cfif REQURITY>required="required" </cfif><cfif len(SIZE)>class="#SIZE#" </cfif>><cfif GET_EXTENDED_VALUES.recordcount>#evaluate('GET_EXTENDED_VALUES.#FIELD_ID#')#</cfif></textarea>
                                <cfelseif FIELD_TYPE is 'date'>
                                    <div class="input-group">
                                         <input type="text" name="#FIELD_ID#" id="#FIELD_ID#" <cfif len(DESCRIPTION)>placeholder="#DESCRIPTION#" </cfif><cfif len(MAX_LENGTH)>maxlength="#MAX_LENGTH#" </cfif><cfif REQURITY>required="required" </cfif><cfif len(SIZE)>class="#SIZE#" </cfif><cfif GET_EXTENDED_VALUES.recordcount>value="#evaluate('GET_EXTENDED_VALUES.#FIELD_ID#')#" </cfif>/>
                                        <span class="input-group-addon">
                                             <cf_wrk_date_image date_field="#FIELD_ID#">
                                        </span>
                                    </div>                             
                                <cfelseif FIELD_TYPE is 'checkboxes'>
                                    <cfloop index="aaa" from="1" to="#listlen(option_value_list,',')#">
                                        <input type="checkbox" name="#FIELD_ID#" id="#FIELD_ID#" <cfif len(DESCRIPTION)>placeholder="#DESCRIPTION#" </cfif><cfif len(MAX_LENGTH)>maxlength="#MAX_LENGTH#" </cfif><cfif REQURITY>required="required" </cfif><cfif len(SIZE)>class="#SIZE#" </cfif><cfif GET_EXTENDED_VALUES.recordcount>value='#listgetat(option_value_list,aaa,",")#' </cfif><cfif GET_EXTENDED_VALUES.recordcount and evaluate('GET_EXTENDED_VALUES.#FIELD_ID#') eq listgetat(option_value_list,aaa,',')>checked </cfif>/>
                                    </cfloop>
                                <cfelseif FIELD_TYPE is 'dropdown'>
                                    <select name="#FIELD_ID#" id="#FIELD_ID#" <cfif len(DESCRIPTION)>placeholder="#DESCRIPTION#" </cfif><cfif len(SIZE)>class="#SIZE#" </cfif><cfif MULTIPLE eq 1>multiple</cfif>>
                                        <cfif BLANK_SPACE eq 1>
                                            <option value="">#attributes.lang#</option><!--- Seçiniz --->
                                        </cfif>
                                        <cfloop index="ind" from="1" to="#listlen(option_value_list,',')#">
                                            <option value="#listgetat(option_value_list,ind,',')#" <cfif evaluate('GET_EXTENDED_VALUES.#FIELD_ID#') eq listgetat(option_value_list,aaa,',')>selected</cfif>>#listgetat(option_label_list,aaa,',')#</option>
                                        </cfloop>
                                    </select>
                                <cfelse>
                                    <cfloop index="ind" from="1" to="#listlen(option_value_list,',')#">
                                        <input type="radio" name="#FIELD_ID#" <cfif len(DESCRIPTION)>placeholder="#DESCRIPTION#" </cfif><cfif len(MAX_LENGTH)>maxlength="#MAX_LENGTH#" </cfif><cfif REQURITY>required="required" </cfif><cfif len(SIZE)>class="#SIZE#" </cfif><cfif GET_EXTENDED_VALUES.recordcount>value="#listgetat(option_value_list,ind,',')#" <cfif evaluate('GET_EXTENDED_VALUES.#FIELD_ID#') eq listgetat(option_value_list,ind,',')>checked</cfif></cfif>/>
                                    </cfloop>
                                </cfif>
                            </div>
                        </div>
                    </cfoutput>
                </div>
            </cfif>
        <cfelse>
            <cfoutput query="GET_FIELDS">
                <cfif FIELD_TYPE is 'date'>
                    <cfif len(caller.attributes['#FIELD_ID#'])><!--- Tarih boş gelirse createodbcdatetime fonksiyonu hata verecektir --->
                    <cfset tarih = caller.attributes['#FIELD_ID#']>
                    <cf_date tarih="tarih"> 
                        <cfset newDate = createodbcdatetime(caller.attributes['#FIELD_ID#'])>
                        <cfquery name="EDIT_EXTEND_FIELD" datasource="#DATASOURCE_NAME#">
                            UPDATE #TABLE_NAME# SET #FIELD_ID# = <cfif isdefined("caller.attributes.#FIELD_ID#") and len(caller.attributes['#FIELD_ID#'])>#tarih#<cfelse>NULL</cfif> WHERE #IDENTITY_COLUMN_NAME# = #attributes.actionId#
                        </cfquery>
                    </cfif>
                <cfelse>
                    <cfquery name="EDIT_EXTEND_FIELD" datasource="#DATASOURCE_NAME#">
                        UPDATE #TABLE_NAME# SET #FIELD_ID# = <cfif isdefined("caller.attributes.#FIELD_ID#")>'#caller.attributes['#FIELD_ID#']#'<cfelse>NULL</cfif> WHERE #IDENTITY_COLUMN_NAME# = #attributes.actionId#
                    </cfquery>
                </cfif>
            </cfoutput>
        </cfif>
    <cfelse>
        <cfquery name="GET_FIELDS" datasource="#caller.dsn#">
            SELECT
                <cfif len(attributes.mainTableAlias)>'#attributes.mainTableAlias#.'+</cfif>FIELD_ID AS FIELD_ID_PLUS_ALIAS,
                FIELD_ID,
                LABEL,
                FIELD_TYPE,
                OPTION_LABEL_LIST,
                OPTION_VALUE_LIST,
                MULTIPLE,
                OPTION_CHECKED_LIST
            FROM
                EXTENDED_FIELDS
            WHERE
                CONTROLLER_NAME = '#attributes.controllerFileName#' AND
                COMPANY_ID_LIST = #session.ep.company_id# AND
                PERIOD_ID_LIST = #session.ep.period_id#
        </cfquery>
        <cfif attributes.selectClause eq 1>
        	<cfif GET_FIELDS.recordcount>
				<cfoutput query="GET_FIELDS">
                    <cfif GET_FIELDS.FIELD_TYPE eq 'dropdown'>
                        ,( CASE #GET_FIELDS.FIELD_ID_PLUS_ALIAS#
                            <cfloop from="1" to="#listlen(GET_FIELDS.OPTION_VALUE_LIST)#" index="i">
                                WHEN '#listGetAt(GET_FIELDS.OPTION_VALUE_LIST,i)#' THEN '#listGetAt(GET_FIELDS.OPTION_LABEL_LIST,i)#'
                            </cfloop>
                            ELSE '' END
                        ) AS #UCase(GET_FIELDS.FIELD_ID)#
                    <cfelse>
                        ,#UCase(GET_FIELDS.FIELD_ID_PLUS_ALIAS)#
                    </cfif>
                </cfoutput>
            </cfif>
		<cfelseif attributes.whereClause eq 1>
			<cfoutput query="GET_FIELDS">
            	<cfif GET_FIELDS.recordcount>
					<cfif isDefined("url.#GET_FIELDS.FIELD_ID#") and len(evaluate("url.#GET_FIELDS.FIELD_ID#"))>
                        <cfif GET_FIELDS.FIELD_TYPE eq 'text' or GET_FIELDS.FIELD_TYPE eq 'paragraph'>
                            AND #GET_FIELDS.FIELD_ID_PLUS_ALIAS# LIKE '%#evaluate("url.#GET_FIELDS.FIELD_ID#")#%'
                        <cfelseif GET_FIELDS.FIELD_TYPE eq 'date'>
                            AND #GET_FIELDS.FIELD_ID_PLUS_ALIAS# = '#dateformat(evaluate("url.#GET_FIELDS.FIELD_ID#"))#'
                        <cfelseif GET_FIELDS.FIELD_TYPE eq 'checkboxes'>
                            AND #GET_FIELDS.FIELD_ID_PLUS_ALIAS# = #evaluate("url.#GET_FIELDS.FIELD_ID#")#
                        <cfelseif GET_FIELDS.FIELD_TYPE eq 'dropdown'>
                        	<cfif GET_FIELDS.MULTIPLE eq 0>
	                            AND #GET_FIELDS.FIELD_ID_PLUS_ALIAS# = '#evaluate("url.#GET_FIELDS.FIELD_ID#")#'
                            <cfelse>
                            	AND #GET_FIELDS.FIELD_ID_PLUS_ALIAS# IN ('#evaluate("url.#GET_FIELDS.FIELD_ID#")#')
                            </cfif>
                        </cfif>
                    </cfif>
                </cfif>
            </cfoutput>
		<cfelse>
        	<cfif GET_FIELDS.recordcount>
                <div class="row">
                    <div class="form-inline text-left float-left">
                        <cfoutput query="GET_FIELDS">
							<cfif GET_FIELDS.FIELD_TYPE eq 'text' or GET_FIELDS.FIELD_TYPE eq 'paragraph'>
                                <div class="form-group x-15">
                                    <div class="input-group">
                                        <input type="text" name="#GET_FIELDS.FIELD_ID#" id="#GET_FIELDS.FIELD_ID#" value="" placeholder="#GET_FIELDS.LABEL#">
                                    </div>
                                </div>
                            <cfelseif GET_FIELDS.FIELD_TYPE eq 'date'>
                                <div class="form-group x-15">
                                    <div class="input-group">
                                        <input type="text" name="#GET_FIELDS.FIELD_ID#" id="#GET_FIELDS.FIELD_ID#" maxlength="10" validate="eurodate" placeholder="#GET_FIELDS.LABEL#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="#GET_FIELDS.FIELD_ID#"></span>
                                    </div>
                                </div>
                            <cfelseif GET_FIELDS.FIELD_TYPE eq 'checkboxes'>
                                <div class="form-group x-15">
                                    <label>#GET_FIELDS.LABEL#</label>
                                    <cfloop from="1" to="#listlen(GET_FIELDS.OPTION_LABEL_LIST)#" index="i">
	                                    <input type="checkbox" name="#GET_FIELDS.FIELD_ID#" id="#GET_FIELDS.FIELD_ID#" value="#listGetAt(GET_FIELDS.OPTION_VALUE_LIST,i)#" <cfif GET_FIELDS.OPTION_CHECKED_LIST eq 'YES'>checked="checked"</cfif>>
                                    </cfloop>
                                </div>
                            <cfelseif GET_FIELDS.FIELD_TYPE eq 'dropdown'>
                                <div class="form-group x-15">
                                    <select name="#GET_FIELDS.FIELD_ID#" id="#GET_FIELDS.FIELD_ID#" <cfif GET_FIELDS.MULTIPLE>multiple="multiple"</cfif>>
                                        <option value="" <cfif GET_FIELDS.MULTIPLE>disabled="disabled"</cfif>>#GET_FIELDS.LABEL#</option>
                                        <cfloop from="1" to="#listlen(GET_FIELDS.OPTION_LABEL_LIST)#" index="i">
                                        	<option value="#listGetAt(GET_FIELDS.OPTION_VALUE_LIST,i)#" <cfif listGetAt(GET_FIELDS.OPTION_CHECKED_LIST,i) is 'YES'>selected="selected"</cfif>>#listGetAt(GET_FIELDS.OPTION_LABEL_LIST,i)#</option>
                                        </cfloop>
                                    </select>
                                </div>
                            </cfif>
                        </cfoutput>
                    </div>
                </div>
            </cfif>
        </cfif>
    </cfif>
</cfif>