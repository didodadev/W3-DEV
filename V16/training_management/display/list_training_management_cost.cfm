 <cfif isdefined("attributes.form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfparam name="attributes.training_cat" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset url_str = "">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfset attributes.start_date = date_add('d',-7,createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#'))>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = date_add('d',7,attributes.start_date)>
</cfif>
	<cfquery name="get_training_class" datasource="#dsn#">
		SELECT CLASS_NAME FROM TRAINING_CLASS WHERE CLASS_ID IS NOT NULL
	</cfquery>
	<cfquery name="get_training_class_cost_rows" datasource="#dsn#">
		SELECT
			TCC.TRAINING_CLASS_COST_ID,
			TCC.CLASS_ID,
			TCCR.EXPENSE_ITEM_ID,
			TCCR.EXPLANATION,
			TCCR.GERCEKLESEN,
			TCCR.ONGORULEN,
			TCCR.GERCEKLESEN_BIRIM,
			TCCR.ONGORULEN_BIRIM,
			TCCR.GERCEKLESEN_MIKTAR,
			TCCR.ONGORULEN_MIKTAR,
			TCCR.COST_DATE,
			TCCR.BRANCH_ID
		FROM
			TRAINING_CLASS_COST TCC,
			TRAINING_CLASS_COST_ROWS TCCR
		WHERE
			TCC.TRAINING_CLASS_COST_ID = TCCR.TRAINING_CLASS_COST_ID
			<cfif len(attributes.branch_id)>
				AND TCCR.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
			<cfelse>
				AND (TCCR.BRANCH_ID IN (
                                        SELECT 
                                            BRANCH_ID
                                        FROM 
                                            BRANCH
                                        WHERE
                                            BRANCH_ID IN (
                                                            SELECT
                                                                BRANCH_ID
                                                            FROM
                                                                EMPLOYEE_POSITION_BRANCHES
                                                            WHERE
                                                                POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.POSITION_CODE#">	
                                                        )
									) OR BRANCH_ID IS NULL)
			</cfif>
			<cfif len(attributes.keyword)>
				AND TCCR.EXPLANATION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
			</cfif>
			<cfif len(attributes.training_cat)>
				AND TCCR.EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_cat#">
			</cfif>
			<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
				AND (
					(TCCR.COST_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">) OR (TCCR.COST_DATE IS NULL)
					)
			<cfelseif isdate(attributes.start_date)>
				AND (TCCR.COST_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">)
				AND (TCCR.COST_DATE IS NULL)
			<cfelseif isdate(attributes.finish_date)>
				AND (TCCR.COST_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">)
				AND (TCCR.COST_DATE IS NULL)
			</cfif>
			ORDER BY TCC.RECORD_DATE DESC
	</cfquery>
	<cfquery name="get_expense_items" datasource="#dsn2#">
		SELECT * FROM EXPENSE_ITEMS WHERE EXPENSE_CATEGORY_ID IN (SELECT EXPENSE_CAT_ID FROM EXPENSE_CATEGORY WHERE EXPENCE_IS_TRAINING = 1)
	</cfquery>
	<cfquery name="get_branchs" datasource="#dsn#">
		SELECT 
			BRANCH_ID,
			BRANCH_NAME 
		FROM 
			BRANCH
		WHERE
			BRANCH_ID IN (
						SELECT
							BRANCH_ID
						FROM
							EMPLOYEE_POSITION_BRANCHES
						WHERE
							POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.POSITION_CODE#">	
						)
		ORDER BY BRANCH_ID
	</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="form" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post"><!--- ehesap.list_expense_item --->
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group" id="item-keyword">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" style="width:100px;" placeholder="#place#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group" id="item-training_cat">
					<select name="training_cat" id="training_cat" style="width:140px;">
						<option value=""><cf_get_lang dictionary_id='58551.Gider Kalemi'></option>
						<cfoutput query="get_expense_items">
							<option value="#expense_item_id#" <cfif attributes.training_cat eq expense_item_id>selected</cfif>>#expense_item_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group" id="item-branch_id">
					<select name="branch_id" id="branch_id" style="width:140px;">
						<option value=""><cf_get_lang dictionary_id ='57453.Şube'></option>
						<cfoutput query="get_branchs">
							<option value="#branch_id#" <cfif attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group" id="item-start_date">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id ='58053.başlangıç tarihi'></cfsavecontent>
						<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#" required="yes">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group" id="item-finish_date">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57739.bitiş tarihi girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#" required="yes">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
				<div class="form-group small" id="item-maxrows">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyup="isNumber (this)" style="width:25px;">
				</div>
				<div class="form-group" id="item-button">
					<cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
					<cf_wrk_search_button button_type="4" search_function="date_check(form.start_date,form.finish_date,'#message_date#')">
				</div>	
			</cf_box_search>
		</cfform>
	</cf_box>
		<cfparam name="attributes.keyword" default="">
		<cfparam name="attributes.page" default=1>
		<cfparam name="attributes.totalrecords" default="#get_training_class_cost_rows.recordcount#">
		<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cf_box title="#getLang(239,'Eğitim Maliyeti',46446)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>		
				<tr> 
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='58551.Gider Kalemi'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th><cf_get_lang dictionary_id='57419.Eğitim Adı'></th>
					<th><cf_get_lang dictionary_id ='57742.Tarih'></th>
					<th><cf_get_lang dictionary_id ='57453.Şube'></th>
					<th> <cf_get_lang dictionary_id='46709.Planlnn Miktar'></th>
					<th><cf_get_lang dictionary_id='58869.Planlanan'></th>
					<th><cf_get_lang dictionary_id='46711.Gerçekleşen Miktar'></th>
					<th><cf_get_lang dictionary_id ='46465.Gerçekleşen'></th>
					<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=training_management.list_training_management_cost&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_training_class_cost_rows.recordcount and form_varmi eq 1>
					<cfset expense_item_list = "">
					<cfset class_id_list = "">
					<cfset branch_id_list = "">
					<cfset gerceklesen_toplam = 0>
					<cfoutput query="get_training_class_cost_rows" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(expense_item_id) and not listfind(expense_item_list,expense_item_id)>
							<cfset expense_item_list = listappend(expense_item_list,expense_item_id)>
						</cfif>
						<cfif len(class_id) and not listfind(class_id_list,class_id)>
							<cfset class_id_list = listappend(class_id_list,class_id)>
						</cfif>
						<cfif len(branch_id) and not listfind(branch_id_list,branch_id)>
							<cfset branch_id_list = listappend(branch_id_list,branch_id)>
						</cfif>
					</cfoutput>
					<cfset class_id_list=listsort(class_id_list,"numeric")>
					<cfset expense_item_list=listsort(expense_item_list,"numeric")>
					<cfset branch_id_list=listsort(branch_id_list,"numeric")>
					<cfif len(expense_item_list)>
						<cfquery name="get_list_training_category" datasource="#dsn2#">
							SELECT
								EXPENSE_ITEM_ID,
								EXPENSE_ITEM_NAME
							FROM
								EXPENSE_ITEMS
							WHERE
								EXPENSE_CATEGORY_ID IN (SELECT EXPENSE_CAT_ID FROM EXPENSE_CATEGORY WHERE EXPENCE_IS_TRAINING = 1) AND
								EXPENSE_ITEM_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#expense_item_list#">) ORDER BY EXPENSE_ITEM_ID
						</cfquery>
					</cfif>
					<cfif len(class_id_list)>
						<cfquery name="get_training_class_name" datasource="#dsn#">
							SELECT CLASS_ID,CLASS_NAME FROM TRAINING_CLASS WHERE CLASS_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#class_id_list#">) ORDER BY CLASS_ID
						</cfquery>
					</cfif>
					<cfif len(branch_id_list)>
						<cfquery name="get_training_branch_name" datasource="#dsn#">
							SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#branch_id_list#">) ORDER BY BRANCH_ID
						</cfquery>
					</cfif>
					<cfoutput query="get_training_class_cost_rows" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
						<cfset sayac_=1>
						<tr>
							<td width="35">#currentrow#</td>
							<td><cfif len(expense_item_list)>#get_list_training_category.expense_item_name[listfind(expense_item_list,expense_item_id,',')]#</cfif></td>
							<td>#explanation#</td>
							<td><cfif len(class_id_list)>#get_training_class_name.class_name[listfind(class_id_list,class_id,',')]#</cfif></td>
							<td>#dateformat(cost_date,dateformat_style)#</td>
							<td><cfif len(branch_id_list)>#get_training_branch_name.branch_name[listfind(branch_id_list,branch_id,',')]#</cfif></td>
							<td style="text-align:right;">#ongorulen_miktar#</td>
							<td style="text-align:right;">#tlformat(ongorulen)#</td>
							<td style="text-align:right;">#gerceklesen_miktar#</td>
							<td style="text-align:right;">#tlformat(gerceklesen)#</td>
							<td width="15" style="text-align:right;"><a href="#request.self#?fuseaction=training_management.list_training_management_cost&event=upd&<cfif len(class_id)>class_id=#class_id#<cfelse>training_class_cost_id=#training_class_cost_id#</cfif>&is_class_type=1;"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='57464.Güncelle'>"></i></a></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="12"><cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'><cfelse><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#"> 
			</cfif>
			<cfif len(attributes.training_cat)>
				<cfset url_str = "#url_str#&training_cat=#attributes.training_cat#"> 
			</cfif>
			<cfif len(attributes.branch_id)>
				<cfset url_str = "#url_str#&attributes.branch_id=#attributes.branch_id#"> 
			</cfif>
			<cfif len(attributes.start_date)>
				<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,'dd/mm/yyy')#">					  
			</cfif>
			<cfif len(attributes.finish_date)>
				<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,'dd/mm/yyy')#">					  
			</cfif>
			<cfset url_str = "#url_str#&form_submitted=1">
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#attributes.fuseaction#&#url_str#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
